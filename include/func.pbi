; linux
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=60884&start=1
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=75323
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=73397
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=71992
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=71196

; macos
; https://www.purebasic.fr/english/viewtopic.php?f=19&t=51968&start=1

DeclareModule func
  Declare.s InvertCase( Text.s )  
  Declare.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
  Declare.s TrimRight(*a, n)
  Declare.s TrimLeft(*a, n)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Declare.i ResizeIcon( hIcon.i, Width.l, Height.l, Depth.l=32 )
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Declare.CGFloat GetFontSize( FontID.i )
  CompilerElse
    Declare.i GetFontSize( FontID.i )
  CompilerEndIf
  
  Declare.i GetImageWidth( ImageID.i )
  Declare.i GetImageHeight( ImageID.i )
  Declare.i SetImageWidth( ImageID.i, Width.l )
  Declare.i SetImageHeight( ImageID.i, Height.l )
  
  Declare   _HideGadget(Gadget, state)
EndDeclareModule 

Module func
  #__sOC = SizeOf(Character)
  
  Procedure   FreeCursor( hCursor.i )
		CompilerSelect #PB_Compiler_OS
			CompilerCase #PB_OS_Linux
				g_object_unref_( hCursor )
			CompilerCase #PB_OS_MacOS
				CocoaMessage( 0, hCursor, "release" )
			CompilerCase #PB_OS_Windows
				DestroyCursor_( hCursor )
		CompilerEndSelect
	EndProcedure
	
	Procedure.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
    If ImageID
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          Protected *ic
          Protected ico.ICONINFO
          ico\fIcon = 0
          ico\xHotspot =- x 
          ico\yHotspot =- y 
          ico\hbmMask = ImageID
          ico\hbmColor = ImageID
          *ic = CreateIconIndirect_( ico ) 
          If Not *ic 
            *ic = ImageID 
          EndIf
        CompilerCase #PB_OS_Linux
          Protected *ic.GdkCursor = gdk_cursor_new_from_pixbuf_( gdk_display_get_default_( ), ImageID, x, y )
        CompilerCase #PB_OS_MacOS
          Protected *ic
          Protected Hotspot.NSPoint
          Hotspot\x = x
          Hotspot\y = y
          *ic = CocoaMessage( 0, 0, "NSCursor alloc" )
          CocoaMessage( 0, *ic, "initWithImage:", ImageID, "hotSpot:@", @Hotspot )
      CompilerEndSelect
    EndIf
    
    ProcedureReturn *ic
  EndProcedure
  
  ;-
  Procedure.s InvertCase( Text.s )  
    Protected *C.CHARACTER = @Text
    
    While ( *C\c )
      If ( *C\c = Asc( LCase( Chr( *C\c ) ) ) )
        *C\c = Asc( UCase( Chr( *C\c ) ) )
      Else
        *C\c = Asc( LCase( Chr( *C\c ) ) )
      EndIf
      
      *C + #__sOC ; SizeOf( CHARACTER )
    Wend
    
    ProcedureReturn Text
  EndProcedure
  
  Procedure.s TrimRight(*a, n)
    Protected *p.string = @*a
    *p\s = Left(*p\s, Len(*p\s) - n)
  EndProcedure
  
  Procedure.s TrimLeft(*a, n)
    Protected *p.string = @*a
    *p\s = Right(*p\s, Len(*p\s) - n)
  EndProcedure
  
  ;-
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure.i ResizeIcon(hIcon.i, Width.l, Height.l, Depth.l=32)
      Protected IInfo.ICONINFO, ColorImg.i, MaskImg.i, DC.i, RethIcon.i, ICONINFO.ICONINFO
      
      If hIcon <> 0
        ;Get icon data
        If GetIconInfo_(hIcon, @IInfo)
          ColorImg = CreateImage(#PB_Any, Width, Height, Depth)
          If IsImage(ColorImg) <> 0
            ;Draw color image
            DC = StartDrawing(ImageOutput(ColorImg))
            If DC <> 0
              DrawIconEx_(DC,0,0,hIcon,Width,Height,0,0,#DI_IMAGE)
              StopDrawing()
            EndIf
          EndIf
          
          MaskImg = CreateImage(#PB_Any, Width, Height) ;Depth is 24 by default
          If IsImage(MaskImg) <> 0
            ;Draw mask
            DC = StartDrawing(ImageOutput(MaskImg))
            If DC <> 0
              DrawIconEx_(DC,0,0,hIcon,Width,Height,0,0,#DI_MASK)
              StopDrawing()
            EndIf
          EndIf
          
          ;Create new icon
          ICONINFO\fIcon = 1
          ICONINFO\hbmMask = ImageID(MaskImg)
          ICONINFO\hbmColor = ImageID(ColorImg)
          RethIcon = CreateIconIndirect_(@ICONINFO)
          
          ;And free the resources
          If IsImage(ColorImg)
            FreeImage(ColorImg)
          EndIf
          If IsImage(MaskImg)
            FreeImage(MaskImg)
          EndIf
          
          DeleteObject_(IInfo\hbmColor)
          DeleteObject_(IInfo\hbmMask)
        EndIf
      EndIf
      
      ProcedureReturn RethIcon
    EndProcedure
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure.CGFloat GetFontSize( FontID.i )
      ;
      ; returns the font size of FontID
      ;
      Protected pointSize.CGFloat = 0.0
      If FontID
        CocoaMessage(@pointSize,FontID,"pointSize")
      EndIf
      ProcedureReturn pointSize
    EndProcedure
    
;     ; Toggle window shadow on and off:
;     ShadowState = CocoaMessage(0, WindowID(0), "hasShadow") ! 1
;     CocoaMessage(0, WindowID(0), "setHasShadow:", ShadowState)
    
;     CreateImage(0, 64, 64, 32, #PB_Image_Transparent)
;     StartDrawing(ImageOutput(0))
;     DrawingMode(#PB_2DDrawing_AlphaBlend)
;     Circle(32, 32, 30, $ffd0f080)
;     StopDrawing()
;     
;     Application = CocoaMessage(0, 0, "NSApplication sharedApplication")
;     CocoaMessage(0, Application, "setApplicationIconImage:", ImageID(0))
;     
;     MessageRequester("", "Icon set")

  CompilerElse
    Procedure.i GetFontSize( FontID.i )
      
    EndProcedure
  CompilerEndIf
  
  Procedure.i GetImageHeight( ImageID.i )
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected size.NSSize
      CocoaMessage(@size, ImageID, "size")
      ProcedureReturn size\height
    CompilerEndIf
  EndProcedure
  
  Procedure.i GetImageWidth( ImageID.i )
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected size.NSSize
      CocoaMessage(@size, ImageID, "size")
      ProcedureReturn size\width
    CompilerEndIf
  EndProcedure
  
  Procedure.i SetImageWidth( ImageID.i, width.l )
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected size.NSSize
      size\width = width
      CocoaMessage(0, ImageID, "setSize:@", @Size)
    CompilerEndIf
  EndProcedure
  
  Procedure.i SetImageHeight( ImageID.i, height.l )
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected size.NSSize
      size\height = height
      CocoaMessage(0, ImageID, "setSize:@", @Size)
    
      
        ;         Protected.i Result, DataObj, Class, Rep, vImg.vImage_Buffer, MemorySize
        ;         Protected size.NSSize, Point.NSPoint
        ;         CocoaMessage(@DataObj, 0, "NSData dataWithBytesNoCopy:", *MemoryAddress, "length:", MemorySize, "freeWhenDone:", #NO)
        ;         CocoaMessage(@Class, 0, "NSImageRep imageRepClassForData:", DataObj)
        ;         If Class
        ;           CocoaMessage(@Rep, Class, "imageRepWithData:", DataObj)
        ;           If Rep
        ;             Size\width = CocoaMessage(0, Rep, "pixelsWide")
        ;             Size\height = CocoaMessage(0, Rep, "pixelsHigh")
        ;             If Size\width And Size\height
        ;               CocoaMessage(0, Rep, "setSize:@", @Size)
        ;             Else
        ;               CocoaMessage(@Size, Rep, "size")
        ;             EndIf    
        ;           EndIf
        ;         EndIf  
      CompilerEndIf
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_widget_is_visible(widget)
    EndImport
  CompilerEndIf
  
  Procedure _HideGadget(Gadget, state)
    If state = #PB_Default
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          ProcedureReturn IsWindowVisible_(GadgetID(Gadget))
          
        CompilerCase #PB_OS_MacOS
          ProcedureReturn Bool(Not CocoaMessage(0, GadgetID(Gadget), "isHidden"))
          
        CompilerCase #PB_OS_Linux
          ProcedureReturn gtk_widget_is_visible(GadgetID(Gadget))
          
      CompilerEndSelect
    Else
    ;  ProcedureReturn PB(HideGadget)( Gadget, state )
      ProcedureReturn HideGadget( Gadget, state )
    EndIf
  EndProcedure
  
  Procedure scroll_to_visible(EditorGadgetID.I)
    ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=62136&start=4
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
;         Protected *Adjustment.GtkAdjustment
;         
;         *Adjustment.GtkAdjustment = gtk_scrolled_window_get_vadjustment_(gtk_widget_get_parent_(GadgetID(EditorGadgetID)))
;         *Adjustment\value = *Adjustment\upper
;         gtk_adjustment_value_changed_(*Adjustment)     
        
        Protected EndMark.I
        Protected TextBuffer.I
        Protected EndIter.GtkTextIter
        
        TextBuffer = gtk_text_view_get_buffer_(GadgetID(EditorGadgetID))
        gtk_text_buffer_get_end_iter_(TextBuffer, @EndIter)
        EndMark = gtk_text_buffer_create_mark_(TextBuffer, "end_mark", @EndIter, #False)
        gtk_text_view_scroll_mark_onscreen_(GadgetID(EditorGadgetID), EndMark)
        
      CompilerCase #PB_OS_MacOS
        Protected Range.NSRange
        
        Range.NSRange\location = Len(GetGadgetText(EditorGadgetID))
        CocoaMessage(0, GadgetID(EditorGadgetID), "scrollRangeToVisible:@", @Range)
        
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(EditorGadgetID), #EM_SETSEL, -1, -1) 
    CompilerEndSelect
  EndProcedure

EndModule 

UseModule func

CompilerIf #PB_Compiler_IsMainFile
  Define x.s = "Привет"
  TrimRight(@x, 2)
  Debug x
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --+--8-
; EnableXP