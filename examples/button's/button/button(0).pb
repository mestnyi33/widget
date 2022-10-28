IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseLib(Widget)
  EnableExplicit
  
  
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._s_widget
  Global *Button_1._s_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*4)
  
  If OpenWindow(0, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0)
    
    Button(10, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline);, -1,8)
    Button(30, 100, 80, 100, "Standard Button Button (Vertical)", #__button_multiline|#__flag_vertical, -1, 8)
    Button(120, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline|#__text_invert);, -1,8)
    Button(120, 100, 80, 100, "Standard Button Button (Vertical)", #__button_multiline|#__flag_vertical|#__text_invert, -1,8)
    Button(10,  210, 210, 55, "change button font", 0,-1, 20)
    SetFont(widget(), FontID(0))
    
    Button(230, 10, 200, 20, "Standard Button", 0, -1,8)
    Button(230, 40, 200, 20, "Left Button", #__text_left)
    Button(230, 70, 200, 20, "Right Button", #__text_right)
    Button(230,100, 200, 60, "multiline Button (longer text gets automatically wrapped)", #__flag_vertical|#__text_invert|#__button_default, -1, 4)
    Button(230,170, 200, 60, "multiline Button (longer text gets automatically multiline)", #__button_multiline, -1, 4)
    Button(230,170+70, 200, 25, "Toggle Button", #__button_toggle)
    
    redraw(root())
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
 CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 23
; FirstLine = 21
; Folding = -
; EnableXP