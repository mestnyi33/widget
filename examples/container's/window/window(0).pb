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
  
  Open(0, 100, 100, 600, 600, "demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  
  ;
  Window(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  ;
  Procedure window_1_focus()
     Debug " "+ ClassFromEvent(WidgetEvent( )) +" "+ EventWidget( )\index
     HideGadget(GetData(widget()),0)
  EndProcedure
  Procedure window_1_lostfocus()
     Debug " "+ ClassFromEvent(WidgetEvent( )) +" "+ EventWidget( )\index
;      Protected img
;      ;If StartDrawing( CanvasOutput(GetCanvasGadget(EventWidget( ))))
;      If StartDrawing( CanvasOutput(EventGadget()))
;      ;If StartDrawing( WindowOutput(EventWindow()))
;         img = GrabDrawingImage(#PB_Any, EventWidget()\x[#__c_inner], EventWidget()\y[#__c_inner], EventWidget()\width[#__c_inner], EventWidget()\height[#__c_inner])
;         StopDrawing()
;      EndIf
;      SetBackgroundImage(EventWidget( ),img)
     HideGadget(GetData(widget()),1)
  EndProcedure
  Procedure window_1_resize()
    ResizeGadget(GetData(widget()), EventWidget()\x[#__c_inner], EventWidget()\y[#__c_inner], EventWidget()\width[#__c_inner], EventWidget()\height[#__c_inner])
  EndProcedure
  Window(150, 150, 200, 200, "window_1", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  SetData(widget(), ContainerGadget(#PB_Any, 0,0,0,0 ))
  ButtonGadget(#PB_Any, 0,0,80,20,"button")
  ButtonGadget(#PB_Any, 200-80,200-20,80,20,"button")
  CloseGadgetList()
  Bind(widget(), @window_1_resize(), #__event_Resize)
  Bind(widget(), @window_1_focus(), #__event_Focus)
  Bind(widget(), @window_1_lostfocus(), #__event_LostFocus)
  
  ; 
  Window(200, 200, 200, 200, "window_2", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Button(0,0,80,20,"button")
  Button(200-80,200-20,80,20,"button")
  
  
  Bind(root(), @Events_widgets(), #PB_EventType_LeftClick)
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 47
; FirstLine = 19
; Folding = --
; EnableXP