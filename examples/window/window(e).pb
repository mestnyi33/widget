XIncludeFile "../../widgets.pbi" : Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  
  Global *Button_0._s_widget
  Global *Button_1._s_widget
  Global *Button_2._s_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure _events_()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*4)
  
  If Open(OpenWindow(#PB_Any, 0, 0, 720+45, 405, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered))
    Define._s_widget *f_0, *f_1, *f_2, *f_3, *f_4, *f_5, *f_6, *f_7, *f_8, *f_9, *f_10, *f_11, *sp_0, *sp_1, *sc_0
    
    *f_0 = window(10, 10, 180,  120, "form_0", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    button(10, -10, 80, 40, "Butt_0", #__flag_anchorsgadget)
    ;*f_0\fs = 10
    
    ; set_border_size()
    *f_0\bs = 10
    Resize(*f_0, 0, 0, #PB_Ignore, #PB_Ignore)
    
    button(10, 40, 80, 40, "Butt_0", #__flag_anchorsgadget)
    closelist()
    
    *f_1 = window(10, 10, 180,  120, "form_1", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    button(10, -10, 80, 40, "Butt_1", #__flag_anchorsgadget)
    closelist()
    
    *f_2 = window(10, 10, 180,  120, "form_2", #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
    *f_3 = ScrollArea(10, 10, 180,  120, 250, 250, 1, #__flag_anchorsgadget)
    ;*f_3 = window(10, 10, 180,  120, "form_3", #__flag_anchorsgadget, *f_2)
    button(10, 0, 80, 40, "Butt_3", #__flag_anchorsgadget)
    closelist()
    closelist()
    
    *sp_0 = splitter(0, 0, 0, 0, *f_1, *f_0, #__bar_vertical)
    *sp_1 = splitter(10, 10, 360, 360+25, *f_2, *sp_0)
    
    *f_4 = window(370+10, 10, 180,  100, "form_4", #__flag_BorderLess)
    button(5, 5, 80, 20, "Butt_4_0")
    *f_5 = window(370+10, 130+10, 180,  100, "form_6", #PB_Window_SizeGadget)
    button(5, 5, 80, 20, "Butt_6_0")
    
    *f_6 = window(370+10, 130+10+130, 180,  100, "form_8", #PB_Window_TitleBar)
    button(5, 5, 80, 20, "Butt_8_0")
    
    *f_7 = window(370+10+190, 10, 180,  100, "form_5 SystemMenu", #PB_Window_SystemMenu)
    button(5, 5, 80, 20, "Butt_5_0")
    
    *f_8 = window(370+10+190, 130+10, 180,  100, "form_7 Minimize", #PB_Window_MinimizeGadget)
    button(5, 5, 80, 20, "Butt_7_0")
    
    *f_9 = window(370+10+190, 130+10+130, 180,  100, "form_9 Maximize", #PB_Window_MaximizeGadget)
    button(5, 5, 80, 20, "Butt_9_0")
    
  
    SetColor(*f_4, #__color_back, $CA00D7FF)
    SetColor(*f_5, #__color_back, $CA00D7FF)
    SetColor(*f_6, #__color_back, $CA00D7FF)

    redraw(root())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP