XIncludeFile "../../widgets.pbi" : Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  
  Procedure Events_windows()
    Debug ""+Event() +" "+ EventType() +" "+ EventWindow()
  EndProcedure
  
  Procedure Events_widgets()
    Debug " "+ *event\type
  EndProcedure
  
  OpenWindow(0, 100, 100, 200, 200, "Live resize test", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  ButtonGadget(#PB_Any, 0,0,80,20,"button")
  ButtonGadget(#PB_Any, 200-80,200-20,80,20,"button")
  
   BindEvent(#PB_Event_ActivateWindow, @Events_windows())
   BindEvent(#PB_Event_DeactivateWindow, @Events_windows())
;   BindEvent(#PB_Event_CloseWindow, @Events_windows())
;   BindEvent(#PB_Event_Gadget, @Events_windows())
;   BindEvent(#PB_Event_LeftClick, @Events_windows())
;   BindEvent(#PB_Event_LeftDoubleClick, @Events_windows())
;   BindEvent(#PB_Event_MaximizeWindow, @Events_windows())
;   BindEvent(#PB_Event_MinimizeWindow, @Events_windows())
;   BindEvent(#PB_Event_MoveWindow, @Events_windows())
;   BindEvent(#PB_Event_Repaint, @Events_windows())
;   BindEvent(#PB_Event_RestoreWindow, @Events_windows())
;   BindEvent(#PB_Event_RightClick, @Events_windows())
;   BindEvent(#PB_Event_SizeWindow, @Events_windows())
  
  
  
  Open(OpenWindow(#PB_Any, 150, 150, 200, 200+#__window_frame, "window_0", #PB_Window_BorderLess))
  Window(0,0,0,0,GetWindowTitle(Root()\canvas\window), #__flag_autosize | #__Window_SizeGadget | #__Window_SystemMenu)
  Root()\_childrens()\container = #__type_root
  Root()\_childrens()\round = 7
  SetActive(Root()\_childrens())
  
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  ; ResizeWindow(Root()\canvas\window)
  
  Bind(Root(), @Events_widgets())
  
  Open(OpenWindow(#PB_Any, 200, 200, 200, 200+#__window_frame, "window_1", #PB_Window_BorderLess))
  Window(0,0,0,0,GetWindowTitle(Root()\canvas\window), #__flag_autosize | #__Window_SizeGadget | #__Window_SystemMenu)
  Root()\_childrens()\container = #__type_root
  Root()\_childrens()\round = 7
  SetActive(Root()\_childrens())
  
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  ; ResizeWindow(Root()\canvas\window)
  
  Bind(Root(), @Events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 39
; FirstLine = 28
; Folding = -
; EnableXP