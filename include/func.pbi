; linux
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=60884&start=1
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=75323
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=73397
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=71992
; https://www.purebasic.fr/english/viewtopic.php?f=15&t=71196

; macos
; https://www.purebasic.fr/english/viewtopic.php?f=19&t=51968&start=1

  Procedure SetCaretPos(Gadget, Position)
    ;     SetActiveGadget(Gadget)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        If GadgetType( Gadget) = #PB_GadgetType_Editor
          Protected PositionIter.GtkTextIter
          Protected TextBuffer = gtk_text_view_get_buffer_(GadgetID(Gadget))
          gtk_text_buffer_get_iter_at_offset_(TextBuffer, @PositionIter, Position)
          gtk_text_buffer_place_cursor_(TextBuffer, PositionIter)
        Else
          gtk_editable_set_position_( GadgetID(Gadget), Position )
        EndIf
        
      CompilerCase #PB_OS_MacOS
        Protected Range.NSRange : Range\location = Position
        CocoaMessage(0, GadgetID(Gadget), "setSelectedRange:@", @Range)
        CocoaMessage(0, GadgetID(Gadget), "scrollRangeToVisible:@", @Range)
        
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(Gadget), #EM_SETSEL, Position, Position) 
        
    CompilerEndSelect
  EndProcedure

Procedure GadgetRefresh(gadget)
  ; https://www.purebasic.fr/english/viewtopic.php?t=71125
  CompilerSelect #PB_Compiler_OS

    CompilerCase #PB_OS_Windows
      InvalidateRect_(GadgetID(gadget), 0, #True)
      ; UpdateWindow_(GadgetID(gadget))
      
    CompilerCase #PB_OS_Linux 
      CompilerIf Subsystem("qt")
        QtScript("gadget(" + Str(gadget) + ").repaint()")
      CompilerElse
        gtk_widget_queue_draw_(GadgetID(gadget))
      CompilerEndIf

    CompilerCase #PB_OS_MacOS
      CocoaMessage(0, GadgetID(gadget), "setNeedsDisplay:", 1)

  CompilerEndSelect 
  
EndProcedure

DeclareModule func
  Declare   SetMouseCursor( CursorID.I, handle.i = #NUL )
  Declare.s InvertCase( Text.s )  
  Declare.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
  Declare.s TrimRight(*a, n)
  Declare.s TrimLeft(*a, n)
  
  CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    ;--- WINDOWS
    ; #IDC_ARROW=32512
    ; #IDC_APPSTARTING=32650
    ; #IDC_HAND=32649
    ; #IDC_HELP=32651
    ; #IDC_IBEAM=32513
    ; #IDC_CROSS=32515
    ; #IDC_NO=32648
    ; #IDC_SIZE=32640
    ; #IDC_SIZEALL=32646
    ; #IDC_SIZENESW=32643
    ; #IDC_SIZENS=32645
    ; #IDC_SIZENWSE=32642
    ; #IDC_SIZEWE=32644
    ; #IDC_UPARROW=32516
    ; #IDC_WAIT=32514
    
    #CURSOR_ARROW = #IDC_CROSS
    #CURSOR_BUSY = #IDC_WAIT
    
  CompilerCase #PB_OS_MacOS
    #kThemeArrowCursor = 0
    #kThemeCopyArrowCursor = 1
    #kThemeAliasArrowCursor = 2
    #kThemeContextualMenuArrowCursor = 3
    #kThemeIBeamCursor = 4
    #kThemeCrossCursor = 5
    #kThemePlusCursor = 6
    #kThemeWatchCursor = 7
    #kThemeClosedHandCursor = 8
    #kThemeOpenHandCursor = 9
    #kThemePointingHandCursor = 10
    #kThemeCountingUpHandCursor = 11
    #kThemeCountingDownHandCursor = 12
    #kThemeCountingUpAndDownHandCursor = 13
    #kThemeSpinningCursor = 14
    #kThemeResizeLeftCursor = 15
    #kThemeResizeRightCursor = 16
    #kThemeResizeLeftRightCursor = 17
    #kThemeNotAllowedCursor = 18
    #kThemeResizeTopBottomCursor = 21
    
    #CURSOR_UPDOWN = #kThemeResizeTopBottomCursor
    #CURSOR_LEFTRIGHT = #kThemeResizeLeftRightCursor
    #CURSOR_CROSS = #kThemeCrossCursor
    #CURSOR_IBEAM = #kThemeIBeamCursor
    #CURSOR_HAND = #kThemePointingHandCursor
    #CURSOR_LEFT = #kThemeResizeLeftCursor
    #CURSOR_RIGHT = #kThemeResizeRightCursor
    #CURSOR_ARROW = #kThemeArrowCursor
    #CURSOR_BUSY = #kThemeWatchCursor
    
    ImportC ""
      SetThemeCursor(CursorType.i)
    EndImport
    
  CompilerCase #PB_OS_Linux
    ;--- LINUX:
;   GDK_X_CURSOR 		  = 0,
;   GDK_ARROW 		  = 2,
;   GDK_BASED_ARROW_DOWN    = 4,
;   GDK_BASED_ARROW_UP 	  = 6,
;   GDK_BOAT 		  = 8,
;   GDK_BOGOSITY 		  = 10,
;   GDK_BOTTOM_LEFT_CORNER  = 12,
;   GDK_BOTTOM_RIGHT_CORNER = 14,
;   GDK_BOTTOM_SIDE 	  = 16,
;   GDK_BOTTOM_TEE 	  = 18,
;   GDK_BOX_SPIRAL 	  = 20,
;   GDK_CENTER_PTR 	  = 22,
;   GDK_CIRCLE 		  = 24,
;   GDK_CLOCK	 	  = 26,
;   GDK_COFFEE_MUG 	  = 28,
;   GDK_CROSS 		  = 30,
;   GDK_CROSS_REVERSE 	  = 32,
;   GDK_CROSSHAIR 	  = 34,
;   GDK_DIAMOND_CROSS 	  = 36,
;   GDK_DOT 		  = 38,
;   GDK_DOTBOX 		  = 40,
;   GDK_DOUBLE_ARROW 	  = 42,
;   GDK_DRAFT_LARGE 	  = 44,
;   GDK_DRAFT_SMALL 	  = 46,
;   GDK_DRAPED_BOX 	  = 48,
;   GDK_EXCHANGE 		  = 50,
;   GDK_FLEUR 		  = 52,
;   GDK_GOBBLER 		  = 54,
;   GDK_GUMBY 		  = 56,
;   GDK_HAND1 		  = 58,
;   GDK_HAND2 		  = 60,
;   GDK_HEART 		  = 62,
;   GDK_ICON 		  = 64,
;   GDK_IRON_CROSS 	  = 66,
;   GDK_LEFT_PTR 		  = 68,
;   GDK_LEFT_SIDE 	  = 70,
;   GDK_LEFT_TEE 		  = 72,
;   GDK_LEFTBUTTON 	  = 74,
;   GDK_LL_ANGLE 		  = 76,
;   GDK_LR_ANGLE 	 	  = 78,
;   GDK_MAN 		  = 80,
;   GDK_MIDDLEBUTTON 	  = 82,
;   GDK_MOUSE 		  = 84,
;   GDK_PENCIL 		  = 86,
;   GDK_PIRATE 		  = 88,
;   GDK_PLUS 		  = 90,
;   GDK_QUESTION_ARROW 	  = 92,
;   GDK_RIGHT_PTR 	  = 94,
;   GDK_RIGHT_SIDE 	  = 96,
;   GDK_RIGHT_TEE 	  = 98,
;   GDK_RIGHTBUTTON 	  = 100,
;   GDK_RTL_LOGO 		  = 102,
;   GDK_SAILBOAT 		  = 104,
;   GDK_SB_DOWN_ARROW 	  = 106,
;   GDK_SB_H_DOUBLE_ARROW   = 108,
;   GDK_SB_LEFT_ARROW 	  = 110,
;   GDK_SB_RIGHT_ARROW 	  = 112,
;   GDK_SB_UP_ARROW 	  = 114,
;   GDK_SB_V_DOUBLE_ARROW   = 116,
;   GDK_SHUTTLE 		  = 118,
;   GDK_SIZING 		  = 120,
;   GDK_SPIDER		  = 122,
;   GDK_SPRAYCAN 		  = 124,
;   GDK_STAR 		  = 126,
;   GDK_TARGET 		  = 128,
;   GDK_TCROSS 		  = 130,
;   GDK_TOP_LEFT_ARROW 	  = 132,
;   GDK_TOP_LEFT_CORNER 	  = 134,
;   GDK_TOP_RIGHT_CORNER 	  = 136,
;   GDK_TOP_SIDE 		  = 138,
;   GDK_TOP_TEE 		  = 140,
;   GDK_TREK 		  = 142,
;   GDK_UL_ANGLE 		  = 144,
;   GDK_UMBRELLA 		  = 146,
;   GDK_UR_ANGLE 		  = 148,
;   GDK_WATCH 		  = 150,
;   GDK_XTERM 		  = 152
;   GDK_BLANK_CURSOR = -2
;   GDK_CURSOR_IS_PIXMAP = -1
    
    #CURSOR_ARROW = #GDK_ARROW
    #CURSOR_BUSY = #GDK_WATCH
    
    ImportC ""
      gtk_widget_get_window(*Widget.GtkWidget)
    EndImport
CompilerEndSelect

  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Declare.i ResizeIcon( hIcon.i, Width.l, Height.l, Depth.l=32 )
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Declare.CGFloat GetFontSize( FontID.i )
  CompilerElse
    Declare.i GetFontSize( FontID.i )
  CompilerEndIf
  
  CompilerIf #PB_Compiler_Unicode
    Macro MidFast(_string_, _start_pos_, _length_=-1)
      PeekS(@_string_ + ((_start_pos_ - 1) * SizeOf(Character)), _length_, #PB_Unicode)
    EndMacro 
  CompilerElse
    Macro MidFast(_string_, _start_pos_, _length_=-1)
      PeekS(@_string_ + ((_start_pos_ - 1) * SizeOf(Character)), _length_, #PB_Ascii)
    EndMacro  
  CompilerEndIf
  
  
  Declare.i GetImageWidth( ImageID.i )
  Declare.i GetImageHeight( ImageID.i )
  Declare.i SetImageWidth( ImageID.i, Width.l )
  Declare.i SetImageHeight( ImageID.i, Height.l )
  
  Declare   _HideGadget(Gadget, state)
  Declare SetWindowBackgroundImage(hWnd.i, hImage.i)
  Declare TransformImage( source_image, flip_mode = 0, rotation_mode = 0, free_source_image = 1 )
EndDeclareModule 

Module func
  #__sOC = SizeOf(Character)
  
  
;-
Procedure  SetMouseCursor(CursorID.I, handle.i = #NUL)
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      SetClassLongPtr_(handle, #GCL_HCURSOR, LoadCursor_(0, CursorID))
      
    CompilerCase #PB_OS_MacOS
      SetThemeCursor(CursorID)
      ;CursorID = CocoaMessage(0, 0, "NSCursor arrowCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor crosshairCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor iBeamCursorForVerticalLayoutCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor iBeamCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor openHandCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor closedHandCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
      
      ;CursorID = CocoaMessage(0, 0, "NSCursor contextualMenuCursor")
      ;CursorID = CocoaMessage(0, 0, "NSCursor dragLinkCursor")
      
      ;CocoaMessage(0, CursorID, "set")
    CompilerCase #PB_OS_Linux
      Protected Cursor.I = gdk_cursor_new_(CursorID)
      If Cursor
        gdk_window_set_cursor_(gtk_widget_get_window(handle), Cursor)
      EndIf
  CompilerEndSelect
EndProcedure

  Procedure HideCursor( HideCursor.I = #True )
    Protected Cursor.I
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        CompilerIf Subsystem("gtk3")
          If HideCursor
            Cursor = gdk_cursor_new_(#GDK_BLANK_CURSOR)
          Else
            Cursor = 0
          EndIf
          
          gdk_window_set_cursor_(gtk_widget_get_window(WindowID(0)), Cursor)
        CompilerEndIf
      CompilerCase #PB_OS_MacOS
        If HideCursor
          CocoaMessage(0, 0, "NSCursor hide")
        Else
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
      CompilerCase #PB_OS_Windows
        If HideCursor
          ShowCursor_(#False)
        Else
          ShowCursor_(#True)
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure   FreeCursor( hCursor.i )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        CompilerIf Subsystem("gtk3")
          g_object_unref_( hCursor )
        CompilerEndIf
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
          CompilerIf Subsystem("gtk3")
            Protected *ic.GdkCursor = gdk_cursor_new_from_pixbuf_( gdk_display_get_default_( ), ImageID, x, y )
          CompilerEndIf
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
      
      *C + SizeOf( CHARACTER )
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
      ; Size\height = CocoaMessage(0, ImageID, "pixelsHigh")
      
      ProcedureReturn size\height
    CompilerEndIf
  EndProcedure
  
  Procedure.i GetImageWidth( ImageID.i )
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected size.NSSize
      CocoaMessage(@size, ImageID, "size")
      ; Size\width = CocoaMessage(0, ImageID, "pixelsWide")
      
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
    CompilerIf Subsystem("gtk3")
      #GDK_BLANK_CURSOR = -2
      
      ImportC ""
        gtk_widget_is_visible(widget)
        gtk_widget_get_window(*Widget.GtkWidget)
        gtk_entry_set_placeholder_TextWidget(*entry, text.p-utf8)
        gtk_entry_get_placeholder_TextWidget(*entry)
      EndImport
    CompilerEndIf
  CompilerEndIf
  
  
  Procedure _HideGadget(Gadget, state)
    If state = #PB_Default
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          ProcedureReturn IsWindowVisible_(GadgetID(Gadget))
          
        CompilerCase #PB_OS_MacOS
          ProcedureReturn Bool(Not CocoaMessage(0, GadgetID(Gadget), "isHidden"))
          
        CompilerCase #PB_OS_Linux
          CompilerIf Subsystem("gtk3")
            ProcedureReturn gtk_widget_is_visible(GadgetID(Gadget))
          CompilerEndIf 
      CompilerEndSelect
    Else
      ;  ProcedureReturn PB(HideGadget)( Gadget, state )
      ProcedureReturn HideGadget( Gadget, state )
    EndIf
  EndProcedure
  
  Procedure IsGadgetEditable(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        CompilerIf Subsystem("QT")
          ProcedureReturn Bool(qtscript("gadget(" + Gadget + ").readOnly") <> "true")
          
        CompilerElseIf Subsystem("gtk3")
          ProcedureReturn gtk_editable_get_editable_(GadgetID(Gadget))
          
        CompilerEndIf
        
      CompilerCase #PB_OS_MacOS
        ProcedureReturn CocoaMessage(0, GadgetID(Gadget), "isEditable")
        
      CompilerCase #PB_OS_Windows
        ProcedureReturn Bool(GetWindowLongPtr_(GadgetID(gadg), #GWL_STYLE) & #ES_READONLY = 0)
        
    CompilerEndSelect
  EndProcedure
  
  Procedure IsGadgetVisible(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ProcedureReturn IsWindowVisible_(GadgetID(Gadget))
        
      CompilerCase #PB_OS_MacOS
        ProcedureReturn Bool(Not CocoaMessage(0, GadgetID(Gadget), "isHidden"))
        
      CompilerCase #PB_OS_Linux
        CompilerIf Subsystem("qt")
          ProcedureReturn Bool(qtscript("gadget(" + Gadget + ").visible") = "true")
          
        CompilerElseIf Subsystem("gtk3")
          ProcedureReturn gtk_widget_is_visible(GadgetID(Gadget))
          
        CompilerEndIf
        
    CompilerEndSelect
  EndProcedure
  
  
  
  
  Procedure SetGadgetPlaceholder(Gadget.i, Text.s)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      SendMessage_(GadgetID(Gadget), #EM_SETCUEBANNER, #True, Text)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      CompilerIf Subsystem("gtk3")
        gtk_entry_set_placeholder_TextWidget(GadgetID(Gadget), Text)
      CompilerEndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "cell"), "setPlaceholderString:$", @Text)
    CompilerEndIf
    ProcedureReturn
  EndProcedure
  
  Procedure.s GetGadgetPlaceholder(Gadget.i)
    Protected.s Text = Space(1024)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      SendMessage_(GadgetID(Gadget), #EM_GETCUEBANNER, @Text, StringByteLength(Text))
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      CompilerIf Subsystem("gtk3")
        Text = PeekS(gtk_entry_get_placeholder_TextWidget(GadgetID(Gadget)), -1, #PB_UTF8)
      CompilerEndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      Text = PeekS(CocoaMessage(0, CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "cell"), "placeholderString"), "UTF8String"), -1, #PB_UTF8)
    CompilerEndIf
    ProcedureReturn Text
  EndProcedure
  
  
  Procedure GetWindowBackgroundColor(hwnd=0) ;hwnd only used in Linux, ignored in Win/Mac
    CompilerSelect #PB_Compiler_OS
        
      CompilerCase #PB_OS_Windows  
        Protected color = GetSysColor_(#COLOR_WINDOW)
        If color = $FFFFFF Or color=0: color = GetSysColor_(#COLOR_BTNFACE): EndIf
        ProcedureReturn color
        
      CompilerCase #PB_OS_Linux   ;thanks to uwekel http://www.purebasic.fr/english/viewtopic.php?p=405822
        CompilerIf Subsystem("gtk3")
          Protected *style.GtkStyle, *color.GdkColor
          *style = gtk_widget_get_style_(hwnd) ;GadgetID(Gadget))
          *color = *style\bg[0]                ;0=#GtkStateNormal
          ProcedureReturn RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8)
        CompilerEndIf
      CompilerCase #PB_OS_MacOS   ;thanks to wilbert http://purebasic.fr/english/viewtopic.php?f=19&t=55719&p=497009
        Protected.i color, Rect.NSRect, Image, NSColor = CocoaMessage(#Null, #Null, "NSColor windowBackgroundColor")
        ; ;         If NSColor
        ; ;           Rect\size\width = 1
        ; ;           Rect\size\height = 1
        ; ;           Image = CreateImage(#PB_Any, 1, 1)
        ; ;           StartDrawing(ImageOutput(Image))
        ; ;           CocoaMessage(#Null, NSColor, "drawSwatchInRect:@", @Rect)
        ; ;           color = Point(0, 0)
        ; ;           StopDrawing()
        ; ;           FreeImage(Image)
        ; ;           ProcedureReturn color
        ; ;         Else
        ; ;           ProcedureReturn -1
        ; ;         EndIf
        
        
        If NSColor
          Protected.cgfloat red, green, blue, alpha
          Protected nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
          
          If nscolorspace
            CocoaMessage(@red, nscolorspace, "redComponent")
            CocoaMessage(@green, nscolorspace, "greenComponent")
            CocoaMessage(@blue, nscolorspace, "blueComponent")
            CocoaMessage(@alpha, nscolorspace, "alphaComponent")
            ProcedureReturn RGBA(red * 260.0, green * 260.0, blue * 260.0, alpha * 260.0)
          EndIf
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure  
  
  Procedure SetWindowBackgroundImage(hWnd.i, hImage.i)
    ; https://www.purebasic.fr/german/viewtopic.php?f=16&t=28467&start=7
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        ;         Protected *Background
        ;         Protected FixedBox.i
        ;         Protected *Style.GtkStyle
        ;         gdk_pixbuf_render_pixmap_and_mask_(hImage, @*Background, 0, 0) ; no work linux
        ;         *Style = gtk_style_new_()
        ;         *Style\bg_pixmap[0] = *Background
        ;         FixedBox = g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(hWnd)), 0)
        ;         gtk_widget_set_style_(FixedBox, *Style)
        
      CompilerCase #PB_OS_Windows
        Protected hBrush = CreatePatternBrush_(hImage)
        If hBrush
          SetClassLongPtr_(hWnd, #GCL_HBRBACKGROUND, hBrush)
          InvalidateRect_(hWnd, 0, #True)
          UpdateWindow_(hWnd)
        EndIf
        
      CompilerCase #PB_OS_MacOS
        CocoaMessage(0, hWnd, "setBackgroundColor:",
                     CocoaMessage(0, 0, "NSColor colorWithPatternImage:", hImage))
    CompilerEndSelect
  EndProcedure
  
  Procedure scroll_to_visible(EditorGadgetID.I)
    ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=62136&start=4
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        ;         ;         Protected *Adjustment.GtkAdjustment
        ;         ;         
        ;         ;         *Adjustment.GtkAdjustment = gtk_scrolled_window_get_vadjustment_(gtk_widget_get_parent_(GadgetID(EditorGadgetID)))
        ;         ;         *Adjustment\value = *Adjustment\upper
        ;         ;         gtk_adjustment_value_changed_(*Adjustment)     
        ;         
        ;         Protected EndMark.I
        ;         Protected TextBuffer.I
        ;         Protected EndIter.GtkTextIter
        ;         
        ;         TextBuffer = gtk_text_view_get_buffer_(GadgetID(EditorGadgetID))
        ;         gtk_text_buffer_get_end_iter_(TextBuffer, @EndIter)
        ;         EndMark = gtk_text_buffer_create_mark_(TextBuffer, "end_mark", @EndIter, #False)
        ;         gtk_text_view_scroll_mark_onscreen_(GadgetID(EditorGadgetID), EndMark)
        
      CompilerCase #PB_OS_MacOS
        Protected Range.NSRange
        
        Range.NSRange\location = Len(GetGadgetTextWidget(EditorGadgetID))
        CocoaMessage(0, GadgetID(EditorGadgetID), "scrollRangeToVisible:@", @Range)
        
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(EditorGadgetID), #EM_SETSEL, -1, -1) 
    CompilerEndSelect
  EndProcedure
  
  Procedure SetCaretPosition(StringGadgetID.I, CursorPosition.I)
    ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=58868&start=5
    SetActiveGadget(StringGadgetID)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(StringGadgetID), #EM_SETSEL, CursorPosition, CursorPosition)
        
      CompilerCase #PB_OS_Linux
        CompilerIf Subsystem("gtk3")
          gtk_editable_set_position_(GadgetID(StringGadgetID), CursorPosition)
        CompilerEndIf
        
      CompilerCase #PB_OS_MacOS
        Protected Range.NSRange
        Protected TextView.I
        
        Range\location = CursorPosition
        Range\length = 0
        TextView = CocoaMessage(0, GadgetID(StringGadgetID), "currentEditor")
        
        If TextView
          CocoaMessage(0, TextView, "setSelectedRange:@", @Range)
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure TransformImage( source_image, flip_mode = 0, rotation_mode = 0, free_source_image = 1 )
    ; https://www.purebasic.fr/english/viewtopic.php?f=12&t=77720&sid=8511c4e16685f66b2418f5d3b5452d72
    ; Transforms the source image by first flipping and then rotating it as specified.
    ; Note that there's a lot of overlap between flip and rotation operations in terms of the end result. I've kept the operations separate though as it makes them easier to work with conceptually.
    ; Returns a zero on failure or the Purebasic ID of the new rotated image on success.
    ; PARAMETERS:-
    ; source_image - The Purebasic ID of the source image to be rotated.
    ; flip_mode - 0 = Don't flip (default). 1 = Flip vertically. 2 = Flip horizontally. 3 = Flip both vertically and horizontally.
    ; rotation_mode - 0 = Don't rotate (default). 1 = Rotate 90 degrees clockwise (default). 2 = Rotate 180 degrees clockwise. 3 = Rotate 270 degrees clockwise.
    ; free_source_image - 0 = Don't free source image. 1 = Free source image (default).
    
    If IsImage( source_image ) = 0 : ProcedureReturn 0 : EndIf ; The source image was invalid, so abort.
    
    source_image_width = ImageWidth( source_image )
    source_image_height = ImageHeight( source_image )
    
    If ( flip_mode < 0 ) Or ( flip_mode > 3 ) : ProcedureReturn 0 : EndIf ; Abort if the flip mode is invalid.
    
    Select rotation_mode
      Case 0, 2 ; Rotate 0 or 180 degrees clockwise.
        output_image_width = source_image_width
        output_image_height = source_image_height
      Case 1, 3 ; Rotate 90 or 270 degrees clockwise.
        output_image_width = source_image_height
        output_image_height = source_image_width
      Default
        ProcedureReturn 0 ; The rotation mode was invalid, so abort.
    EndSelect
    
    ; Create an array for the pixel data and copy the pixel data to it. This will also perform any flagged flip operations.
    array_max_x = source_image_width - 1
    array_max_y = source_image_height - 1
    Dim TempPixelArray.l( array_max_x, array_max_y )
    StartDrawing( ImageOutput( source_image ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    For y = 0 To array_max_y
      For x = 0 To array_max_x
        Select flip_mode
          Case 0 ; Don't flip.
            TempPixelArray( x, y ) = Point( x, y )
          Case 1 ; Flip vertically.
            TempPixelArray( x, y ) = Point( x, array_max_y - y )
          Case 2 ; Flip horizontally.
            TempPixelArray( x, y ) = Point( array_max_x - x, y )
          Case 3 ; Flip both vertically and horizontally.
            TempPixelArray( x, y ) = Point( array_max_x - x, array_max_y - y )
        EndSelect
      Next
    Next
    StopDrawing()
    
    ; Create the output image.
    output_image = CreateImage( #PB_Any, output_image_width, output_image_height, ImageDepth( source_image ) ) : If output_image = 0 : ProcedureReturn 0 : EndIf
    output_image_max_x = output_image_width - 1
    output_image_max_y = output_image_height - 1
    
    ; Copy the pixel data from the pixel array to a new output image.
    StartDrawing( ImageOutput( output_image ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    
    Select rotation_mode
      Case 0 ; Don't rotate.
        For y = 0 To array_max_y
          For x = 0 To array_max_x
            Plot( x, y , TempPixelArray( x, y ) )
          Next
        Next
        
      Case 1 ; Rotate 90 degrees clockwise.
        out_x = output_image_max_x
        For y = 0 To array_max_y
          out_y = 0
          For x = 0 To array_max_x
            Plot( out_x, out_y , TempPixelArray( x, y ) )
            out_y + 1
          Next
          out_x - 1
        Next
        
      Case 2 ; Rotate 180 degrees clockwise.
        out_y = output_image_max_y
        For y = 0 To array_max_y
          out_x = output_image_max_x
          For x = 0 To array_max_x
            Plot( out_x, out_y , TempPixelArray( x, y ) )
            out_x - 1
          Next
          out_y - 1
        Next
        
      Case 3 ; Rotate 270 degrees clockwise.
        out_x = 0
        For y = 0 To array_max_y
          out_y = output_image_max_y
          For x = 0 To array_max_x
            Plot( out_x, out_y , TempPixelArray( x, y ) )
            out_y - 1
          Next
          out_x + 1
        Next
        
    EndSelect
    
    StopDrawing()
    
    If free_source_image : FreeImage( source_image ) : EndIf ; Free the source image if it is flagged to be freed.
    
    ProcedureReturn output_image
  EndProcedure
  
EndModule 


CompilerIf #PB_Compiler_IsMainFile
  UseModule func
  Define x.s = "Привет"
  TrimRight(@x, 2)
  Debug x
CompilerEndIf








; ; https://www.purebasic.fr/english/viewtopic.php?f=15&t=77261
; ProcedureC WindowCloseHandler(*Widget.GtkWidget, *Event.GdkEventAny, UserData.I)
;   gtk_main_quit_()
; EndProcedure
; 
; If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp")
;   gtk_init_(0, 0)
;   Window = gtk_window_new_(#GTK_WINDOW_TOPLEVEL)
;   
;   If Window
;     gtk_window_set_default_size_(Window, ImageWidth(0), ImageHeight(0))
;     gtk_window_set_title_(Window, "API")
;     gtk_window_set_position_(Window, #GTK_WIN_POS_NONE)
;     gtk_window_move_(Window, 100, 100)
;     
;     Layout = gtk_layout_new_(0, 0)
;     gtk_container_add_(Window, Layout)
;     gtk_widget_show_(Layout)
;     
;     gtk_layout_put_(Layout, gtk_image_new_from_pixbuf_(ImageID(0)), 0, 0)
;     gtk_widget_show_all_(Window)
;     
;     g_signal_connect_(Window, "delete-event", @WindowCloseHandler(), 0)
;     g_signal_connect_(Window, "destroy", @WindowCloseHandler(), 0)
;     
;     gtk_widget_show_(Window)
;     gtk_main_()
;   EndIf
; EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 780
; FirstLine = 776
; Folding = ---------------
; EnableXP