XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  UseWidgets( )
  
  Procedure Events_windows()
    Debug "gw "+Event() +" "+ EventType() +" "+ EventWindow()
  EndProcedure
  
  Procedure Events_widgets()
    Debug "ww "+ WidgetEvent( ) +" "+ EventWidget( )\index
  EndProcedure
  
  OpenRoot(OpenWindow(#PB_Any, 100, 100, 600, 600, "demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu))
  
  WindowWidget(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  ButtonWidget(0,0,80,20,"button")
  ButtonWidget(200-80,200-20,80,20,"button")
  
  WindowWidget(150, 150, 200, 200, "window_1", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  ContainerGadget(#PB_Any, widget()\x[#__c_inner], widget()\y[#__c_inner], widget()\width[#__c_inner], widget()\height[#__c_inner])
  ButtonGadget(#PB_Any, 0,0,80,20,"button")
  ButtonGadget(#PB_Any, 200-80,200-20,80,20,"button")
  ;   ButtonWidget(0,0,80,20,"button")
  ;   ButtonWidget(200-80,200-20,80,20,"button")
  CloseGadgetList()
  
  ;
  WindowWidget(200, 200, 200, 200, "window_2", #__Window_SizeGadget | #__Window_SystemMenu)
  ;;ContainerGadget(#PB_Any, widget()\x[#__c_inner], widget()\y[#__c_inner], widget()\width[#__c_inner], widget()\height[#__c_inner]) : CloseGadgetList()
  ButtonWidget(0,0,80,20,"button")
  ButtonWidget(200-80,200-20,80,20,"button")
  
  BindWidgetEvent(Root(), @Events_widgets(), #PB_EventType_LeftClick)
  WaitCloseRoot()
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 9
; Folding = -
; EnableXP