IncludePath "../../"
XIncludeFile "widgets().pbi"
;XIncludeFile "widgets(_align_0_0_0).pbi"
UseModule widget
  Global *g._S_widget, g_Canvas, NewList *List._S_widget()
  
    
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure GetWindowBackgroundColor(hwnd=0) ;hwnd only used in Linux, ignored in Win/Mac
    CompilerSelect #PB_Compiler_OS
        
      CompilerCase #PB_OS_Windows  
        Protected color = GetSysColor_(#COLOR_WINDOW)
        If color = $FFFFFFFF Or color=0: color = GetSysColor_(#COLOR_BTNFACE): EndIf
        ProcedureReturn color
        
      CompilerCase #PB_OS_Linux   ;thanks to uwekel http://www.purebasic.fr/english/viewtopic.php?p=405822
        Protected *style.GtkStyle, *color.GdkColor
        *style = gtk_widget_get_style_(hwnd) ;GadgetID(Gadget))
        *color = *style\bg[0]                ;0=#GtkStateNormal
        ProcedureReturn RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8)
        
      CompilerCase #PB_OS_MacOS   ;thanks to wilbert http://purebasic.fr/english/viewtopic.php?f=19&t=55719&p=497009
        Protected.i color, Rect.NSRect, Image, NSColor = CocoaMessage(#Null, #Null, "NSColor windowBackgroundColor")
        If NSColor
          Rect\size\width = 1
          Rect\size\height = 1
          Image = CreateImage(#PB_Any, 1, 1)
          StartDrawing(ImageOutput(Image))
          CocoaMessage(#Null, NSColor, "drawSwatchInRect:@", @Rect)
          color = Point(0, 0)
          StopDrawing()
          FreeImage(Image)
          ProcedureReturn color
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure  
  
  Global winBackColor
  
  Global *S_0._s_widget
  Global *S_1._s_widget
  Global *S_2._s_widget
  Global *S_3._s_widget
  Global *S_4._s_widget
  Global *S_5._s_widget
  Global *S_6._s_widget
  Global *S_7._s_widget
  Global *S_8._s_widget
  
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
;     Select EventType()
;       Case #PB_EventType_KeyDown ; Debug  " key "+GetGadgetAttribute(Canvas, #PB_Canvas_Key)
;         Select GetGadgetAttribute(Canvas, #PB_Canvas_Key)
;           Case #PB_Shortcut_Tab
;             ForEach List()
;               If List()\Widget = List()\Widget\Focus
;                 Result | CallBack(List()\Widget, #PB_EventType_LostFocus);, Canvas) 
;                 NextElement(List())
;                 ;Debug List()\Widget
;                 Result | CallBack(List()\Widget, #PB_EventType_Focus);, Canvas) 
;                 Break
;               EndIf
;             Next
;         EndSelect
;     EndSelect
    
    Select EventType()
      Case #PB_EventType_Repaint : Result = EventData()
      Case #PB_EventType_Resize : Result = EventData()
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
;         ForEach List()
;           If Canvas = List()\Widget\Canvas\Gadget
;             Result | CallBack(List()\Widget, EventType()) 
;           EndIf
;         Next
    EndSelect
    
    If Result 
      SetWindowTitle(0, "SizeOf(_s_widget) - "+Str(SizeOf(_s_widget)))
    
;       ReDraw(Canvas, winBackColor)
    EndIf
    
  EndProcedure
  
  Procedure Widget_Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget " +  EventType()
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget " + EventType()
      EndIf
    EndIf
    
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 615, 310, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define height, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
    winBackColor = GetWindowBackgroundColor(WindowID(0))
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      height = 19
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      height = 18
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux ; 
      height = 19
      LoadFont(0, "monospace", 10)
      SetGadgetFont(-1,FontID(0))
    CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, height, "StringGadget to right")
    StringGadget(3, 8,  85, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 135, 290, height, "Borderless & read-only StringGadget", #PB_String_BorderLess|#PB_String_ReadOnly)
    StringGadget(6, 8, 160, 290, height, "Password", #PB_String_Password)
    StringGadget(7, 8,  185, 290, height, "")
    StringGadget(8, 8,  210, 290, 90, Text)
    
    Define i
    For i=0 To 8
      BindGadgetEvent(i, @Widget_Events())
    Next
    
    SetGadgetText(6, "GaT")
    
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", #NSCenterTextAlignment)
      CocoaMessage(0,GadgetID(2),"setAlignment:", #NSRightTextAlignment)
      
      ; Debug CocoaMessage (0, GadgetID (1), "isHidden")
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
    
    ; Demo draw string on the canvas
    Open(0, 305, 0, 310, 310, "", #__flag_borderless) : g_Canvas = GetGadget(Root())
;     g_Canvas = CanvasGadget(#PB_Any,  305, 0, 310, 310, #PB_Canvas_Keyboard)
;     SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Cross)
;     BindGadgetEvent(g_Canvas, @CallBacks())
    
    *S_0 = String(8,  10, 290, height, "Normal StringGadget...",0, 8)
    *S_1 = String(8,  35, 290, height, "123-only-4567", #__string_numeric|#__string_center)
    *S_2 = String(8,  60, 290, height, "StringGadget to right", #__string_right)
    *S_3 = String(8,  85, 290, height, "LOWERCASE...", #__string_lowercase)
    *S_4 = String(8, 110, 290, height, "uppercase...", #__string_uppercase)
    *S_5 = String(8, 135, 290, height, "Borderless & read-only StringGadget", #__flag_borderless|#__string_readonly)
    *S_6 = String(8, 160, 290, height, "Password", #__string_password)
    *S_7 = String(8, 185, 290, height, "")
    
;     For i=0 To 30
;       Create(g_Canvas, -1, 8, 185-i*3, 290, height, "")
;     Next
    
    *S_8 = String(8,  210, 290, 90, Text);, #__string_MultiLine);, #__string_Top)
    
    
    SetText(*S_6, "GaT")
    Debug "password: "+GetText(*S_6)
    
    ;     SetColor(*S_1, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_2, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_3, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_4, #PB_Gadget_BackColor, $FFF0F0F0)
    
    BindEvent(#PB_Event_Widget, @Widget_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 04v-
; EnableXP