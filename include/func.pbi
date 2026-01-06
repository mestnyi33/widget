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
   Declare.s InvertCase( Text.s )  
   Declare.s TrimRight(*a, n)
   Declare.s TrimLeft(*a, n)
   
   CompilerSelect #PB_Compiler_OS
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
         ImportC ""
            gtk_widget_get_window(*Widget.GtkWidget)
         EndImport
   CompilerEndSelect
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Declare.i ResizeIcon( hIcon.i, Width.l, Height.l, Depth.l=32 )
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
   
   
   Declare   _HideGadget(Gadget, state)
   Declare SetWindowBackgroundImage(hWnd.i, hImage.i)
EndDeclareModule 

Module func
   #__sOC = SizeOf(Character)
   
   
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
      Protected *p.String = @*a
      *p\s = Left(*p\s, Len(*p\s) - n)
   EndProcedure
   
   Procedure.s TrimLeft(*a, n)
      Protected *p.String = @*a
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
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      CompilerIf Subsystem("gtk3")
         #GDK_BLANK_CURSOR = -2
         
         ImportC ""
            gtk_widget_is_visible(Widget)
            gtk_widget_get_window(*Widget.GtkWidget)
            gtk_entry_set_placeholder_text(*entry, Text.p-utf8)
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
            
            Range.NSRange\location = Len(GetGadgetText(EditorGadgetID))
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
   
   Procedure DrawTextEx(hDc,X, Y, Text.s, FrontColor, BackColor)
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Windows
            Protected chRect.RECT
            chRect\left = X
            chRect\top = Y
            chRect\right = X ;+ VT\CharPixelW
            chrect\bottom = Y;+ VT\CharPixelH
            
            SetTextColor_(hdc, frontColor)
            SetBkColor_(hdc, backColor)
            
            DrawText_(hDC, Text, Len(Text), @chRect.Rect, #DT_SINGLELINE )
            
      CompilerEndSelect
   EndProcedure
EndModule 


CompilerIf #PB_Compiler_IsMainFile
   UseModule func
   Define X.s = "Привет"
   TrimRight(@x, 2)
   Debug X
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
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 206
; FirstLine = 163
; Folding = -v-------
; EnableXP