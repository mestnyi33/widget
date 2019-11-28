IncludePath "../../"
XIncludeFile "widgets().pbi"

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseModule Widget
  EnableExplicit
  
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._S_widget
  Global *Button_1._S_widget
  
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
  
  LoadFont(0, "Arial", 18)
  
  If Open(0, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    Button(10, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline, -1, 8)
    Button(30, 100, 80, 100, "Standard Button Button (Vertical)", #__button_vertical|#__button_multiline, -1, 8)
    Button(120, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline|#__button_inverted, -1, 8)
    Button(120, 100, 80, 100, "Standard Button Button (Vertical)", #__button_vertical|#__button_multiline|#__button_inverted, -1, 8)
    Button(10,  210, 210, 55, "change button font", 0,-1, 20)
    SetFont(widget(), FontID(0))
    
    Button(230, 10, 200, 20, "Standard Button", 0, -1, 8)
    Button(230, 40, 200, 20, "Left Button", #__button_left)
    Button(230, 70, 200, 20, "Right Button", #__button_right)
    Button(230,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #__button_default|#__text_wordwrap, -1, 4)
    Button(230,170, 200, 60, "Multiline Button  (longer text gets automatically multiline)", #__button_multiline, -1, 4)
    Button(230,170+70, 200, 25, "Toggle Button", #__button_toggle)
    
    redraw(root())
  EndIf
  
  
  Global c2
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate) 
    Protected Height = WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)
    
    Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
    Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-100, #PB_Ignore)
    ResizeGadget(c2, 10, 10, Width-20, Height-20)
    SetWindowTitle(EventWindow(), Str(*Button_1\width))
  EndProcedure
  
  If Open(11, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    c2 = GetGadget(Root())
     
    With *Button_0
      *Button_0 = Button(270, 10,  60, 120, "Button (Vertical)", #__button_multiline|#__button_vertical)
      ;       SetColor(*Button_0, #PB_Gadget_BackColor, $CCBFB4)
      SetColor(*Button_0, #__color_front, $D56F1A)
      SetFont(*Button_0, FontID(0))
    EndWith
    
    With *Button_1
      ResizeImage(0, 32,32)
      *Button_1 = Button(10, 42, 250,  60, "Button (Horisontal)", #__button_multiline,0)
      ;       SetColor(*Button_1, #PB_Gadget_BackColor, $D58119)
      \Cursor = #PB_Cursor_Hand
      SetColor(*Button_1, #__color_front, $4919D5)
      SetFont(*Button_1, FontID(0))
    EndWith
    
    redraw(root())
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
;     BindGadgetEvent(g, @CallBacks())
;     PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
;     
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP