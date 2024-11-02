XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
 ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  Uselib(widget)
 
  Procedure Events_windows()
    Debug "gw "+Event() +" "+ EventType() +" "+ EventWindow()
  EndProcedure
  
  Procedure Events_widgets()
    Debug "ww "+ widgetevent()\type +" "+ eventwidget()\index
  EndProcedure
  
  OpenWindow(0, 100, 100, 200, 200, "PB (window_0 & gadget)", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
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
  
  
  
  Open(OpenWindow(#PB_Any, 150, 150, 200, 200, "PB (main window_1)", #PB_Window_SizeGadget | #PB_Window_SystemMenu))
;   Button(0,0,80,20,"button")
;   Button(200-80,200-20,80,20,"button")
  ButtonGadget(#PB_Any, 0,0,80,20,"button")
  ButtonGadget(#PB_Any, 200-80,200-20,80,20,"button")
  
  Bind(Root(), @Events_widgets())
  
  
  
  Open(Window(200, 200, 200, 200, "main window_2", #__Window_SizeGadget | #__Window_SystemMenu))
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
;   ContainerGadget(#PB_Any, widget()\x[#__c_inner], widget()\y[#__c_inner], widget()\width[#__c_inner], widget()\height[#__c_inner])
;   ButtonGadget(#PB_Any, 0,0,80,20,"button")
;   ButtonGadget(#PB_Any, 200-80,200-20,80,20,"button")
;   CloseGadgetList()
  
  Bind(Root(), @Events_widgets())
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP