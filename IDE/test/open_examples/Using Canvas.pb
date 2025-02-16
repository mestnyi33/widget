EnableExplicit

Global Window_0=-1,
       Window_0_Canvas_0=-1,
       Window_0_Canvas_0_Button_0=-1,
       Window_0_Button_0=-1,
       Window_0_Container_1=-1,
       Window_0_Container_1_Button_0=-1,
       Window_0_Panel_0=-1,
       Window_0_Panel_0_Panel_0=-1,
       Window_0_Panel_0_Panel_0_Button_0=-1,
       Window_0_Panel_0_Button_0=-1,
       Window_0_Button_1=-1

Declare Window_0_Events()

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 527, 94, 195, 421, "Window_0", Flag) 
    Window_0_Canvas_0 = CanvasGadget(#PB_Any, 25, 10, 150, 70, #PB_Canvas_Container) 
    Window_0_Canvas_0_Button_0 = ButtonGadget(#PB_Any, 30, 25, 80, 20, "Button_0")
    CloseGadgetList()
    Window_0_Button_0 = ButtonGadget(#PB_Any, 55, 90, 80, 20, "Button_0")
    Window_0_Container_1 = ContainerGadget(#PB_Any, 25, 120, 150, 70, #PB_Container_Flat) 
    Window_0_Container_1_Button_0 = ButtonGadget(#PB_Any, 30, 20, 80, 20, "Button_0")
    CloseGadgetList()
    Window_0_Panel_0 = PanelGadget(#PB_Any, 9, 205, 180, 185)
    AddGadgetItem(Window_0_Panel_0,-1,"Panel_0_0")
    Window_0_Panel_0_Panel_0 = PanelGadget(#PB_Any, 10, 10, 155, 120)
    AddGadgetItem(Window_0_Panel_0_Panel_0,-1,"Panel_1_0")
    Window_0_Panel_0_Panel_0_Button_0 = ButtonGadget(#PB_Any, 30, 20, 80, 20, "Button_0")
    AddGadgetItem(Window_0_Panel_0_Panel_0,-1,"Panel_1_1")
    CloseGadgetList()
    Window_0_Panel_0_Button_0 = ButtonGadget(#PB_Any, 42, 135, 80, 20, "Button_0")
    AddGadgetItem(Window_0_Panel_0,-1,"Panel_0_1")
    CloseGadgetList()
    Window_0_Button_1 = ButtonGadget(#PB_Any, 55, 395, 80, 20, "Button_1")
    
    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)
  EndIf

  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Events()
  Select Event()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
             
          EndSelect
      EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Window_0_Open()

  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 32
; Folding = -
; EnableXP
; CompileSourceDirectory