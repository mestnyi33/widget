DeclareModule func
  Declare.s InvertCase( Text.s )  
  Declare.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Declare.i ResizeIcon( hIcon.i, Width.l, Height.l, Depth.l=32 )
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Declare.CGFloat GetFontSize( FontID.i )
  CompilerElse
    Declare.i GetFontSize( FontID.i )
  CompilerEndIf
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
    
  CompilerElse
    Procedure.i GetFontSize( FontID.i )
      
    EndProcedure
  CompilerEndIf
EndModule 

UseModule func

CompilerIf #PB_Compiler_IsMainFile
  Define x.s = "Привет"
  TrimRight(@x, 2)
  Debug x
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = P-+--
; EnableXP