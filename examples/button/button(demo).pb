IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  UseLib(Widget)
  UsePNGImageDecoder()
  
  Global i, *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._S_widget
  Global *Button_1._S_widget
  
  #Font18R = 18
  Global fs = 9
  Global igFS18.i = fs + Bool(#PB_Compiler_OS=#PB_OS_MacOS)*(fs-7)
  Debug igFS18
  LoadFont(#Font18R, "Arial Unicode MS Regular", igFS18);, #PB_Font_HighQuality)
  ;LoadFont(#Font18R, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4)
  
  fs = 12
  LoadFont(0, "Arial", fs + Bool(#PB_Compiler_OS=#PB_OS_MacOS)*(fs-8))
    
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure _Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  Procedure events_gadgets()
    Select EventType()
      Case #PB_EventType_LeftClick
        Debug  ""+ EventGadget() +" - gadget click"
    EndSelect
  EndProcedure
  
  Procedure events_widgets()
    Select WidgetEvent()
      Case #PB_EventType_LeftClick
        Debug  ""+EventIndex()+" - widget click"
    EndSelect
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    Global main = GetWindow(Root())
    SetGadgetFont(#PB_Any, FontID(#Font18R))
  
    ButtonGadget(0, 10, 10, 200, 20, "Standard button")
    ButtonGadget(1, 10, 40, 200, 20, "Left button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right button", #PB_Button_Right)
    ButtonGadget(3, 10,100, 200, 60, "Default button and long long long long text", #PB_Button_Default)
    ButtonGadget(4, 10,170, 200, 60, "Multiline button  (longer text gets automatically multiline)", #PB_Button_MultiLine)
    ButtonGadget(5, 10,170+70, 200, 25, "Toggle button", #PB_Button_Toggle) ; height = 20 bug in mac os 
    
    SetGadgetState(5, 1)
    SetGadgetFont(5, FontID(0))
    For i = 0 To 5
      BindGadgetEvent(i, @events_gadgets())
    Next
    
    Button(10+222, 10, 200, 20, "Standard button", 0,-1,8)
    Button(10+222, 40, 200, 20, "Left button", #__button_left)
    Button(10+222, 70, 200, 20, "Right button", #__button_right)
    Button(10+222,100, 200, 60, "Default button and long long long long text", #__button_default, -1,4)
    Button(10+222,170, 200, 60, "Multiline button  (longer text gets automatically multiline)", #__button_multiline, -1,4)
    Button(10+222,170+70, 200, 25, "Toggle button", #__button_toggle)
    
    SetState(GetWidget(5), 1)
    SetFont(GetWidget(5), FontID(0))
    Bind(#PB_All, @events_widgets())
    
    ;     For i = 0 To 5
    ;       Bind(GetWidget(i), @events_widgets())
    ;     Next
  EndIf
  
  Global c2
  LoadFont(10, "Arial", 16 + Bool(#PB_Compiler_OS = #PB_OS_MacOS) * 2)
  
;     Procedure ResizeCallBack()
;       ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
;     EndProcedure
  
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(11, #PB_Window_InnerCoordinate) 
    Protected Height = WindowHeight(11, #PB_Window_InnerCoordinate)
    
    Resize(*Button_0, Width-85, #PB_Ignore, #PB_Ignore, Height-30)
    Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-100, #PB_Ignore)
    ResizeGadget(c2, 10, 10, Width-20, Height-20)
    SetWindowTitle(11, Str(*Button_1\width))
  EndProcedure
  
  If OpenWindow(11, 0, 0, 260, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Open(11, 10, 10 , 240, 160)
    c2 = GetGadget(Root())
    
    *Button_0 = Button(270, 5,  60, 120, "Button (Vertical)", #__button_multiline|#__button_vertical);|#__button_inverted)
    SetColor(*Button_0, #__Color_Front, $D56F1A)
    SetFont(*Button_0, FontID(10))
    
    *Button_1 = Button(5, 42, 250,  60, "Button (Horisontal)", #__button_multiline,-1)
    SetColor(*Button_1, #__Color_fore, $0000FF)
    SetColor(*Button_1, #__Color_Back, $00FF00)
    SetColor(*Button_1, #__Color_Front, $FFFFFF) ; $4919D5)
    SetFont(*Button_1, FontID(10))
    
    ResizeWindow(11, #PB_Ignore, WindowY(main)+WindowHeight(main, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    ; PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore) ; bug in linux
    ResizeCallBack()
    
    ;     BindGadgetEvent(g, @CallBacks())
    ;     PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
        
  EndIf
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 5.72 (Linux - x64)
; CursorPosition = 116
; FirstLine = 99
; Folding = --
; EnableXP