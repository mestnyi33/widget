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
  Declare SetWindowBackgroundImage(hWnd.i, hImage.i)
EndDeclareModule 

Module func
  #__sOC = SizeOf(Character)
  
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
    CompilerIf Subsystem("gtk3")
      #GDK_BLANK_CURSOR = -2
      
      ImportC ""
        gtk_widget_is_visible(widget)
        gtk_widget_get_window(*Widget.GtkWidget)
        gtk_entry_set_placeholder_text(*entry, text.p-utf8)
        gtk_entry_get_placeholder_text(*entry)
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
        
        Range.NSRange\location = Len(GetGadgetText(EditorGadgetID))
        CocoaMessage(0, GadgetID(EditorGadgetID), "scrollRangeToVisible:@", @Range)
        
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(EditorGadgetID), #EM_SETSEL, -1, -1) 
    CompilerEndSelect
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
  
  Procedure HideCursor(HideCursor.I = #True)
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
  
  
  Procedure SetGadgetPlaceholder(Gadget.i, Text.s)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      SendMessage_(GadgetID(Gadget), #EM_SETCUEBANNER, #True, Text)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      CompilerIf Subsystem("gtk3")
        gtk_entry_set_placeholder_text(GadgetID(Gadget), Text)
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
        Text = PeekS(gtk_entry_get_placeholder_text(GadgetID(Gadget)), -1, #PB_UTF8)
      CompilerEndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      Text = PeekS(CocoaMessage(0, CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "cell"), "placeholderString"), "UTF8String"), -1, #PB_UTF8)
    CompilerEndIf
    ProcedureReturn Text
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
  
  Procedure SetCursorPosition(StringGadgetID.I, CursorPosition.I)
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
  
EndModule 

UseModule func

CompilerIf #PB_Compiler_IsMainFile
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
; IDE Options = PureBasic 5.72 (Linux - x64)
; Folding = ----vq-f----
; EnableXP