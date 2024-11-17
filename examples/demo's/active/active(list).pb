XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Procedure active()
  If EventWidget( )\type > 0
    Debug "  "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive()
  If EventWidget( )\type > 0
    Debug "  "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure active_0()
  If EventWidget( )\type > 0
    Debug " -   "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure

Procedure deactive_0()
  If EventWidget( )\type > 0
    Debug " -   "+EventWidget( )\index +" "+ #PB_Compiler_Procedure + " gadget_"+EventWidget( )\index
  EndIf
EndProcedure


Define width=500, height=400

If OpenRootWidget(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If OpenRootWidget(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If WindowWidget(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   BindWidgetEvent(#PB_All, @active(), #PB_EventType_Focus)
;   BindWidgetEvent(#PB_All, @deactive(), #PB_EventType_LostFocus)

  WindowWidget(10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *tree_0 = TreeWidget(10,10,170,60)
  additem(*tree_0,-1,"tree_0")
  additem(*tree_0,-1,"tree_00")
  ;SetActive(*tree_0)
  
  Define *tree_1 = TreeWidget(10,80,170,60)
  additem(*tree_1,-1,"tree_1")
  additem(*tree_1,-1,"tree_11")
  ;SetActive(*tree_1)
  
;   WindowWidget(110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   Define *tree_2 = TreeWidget(10,10,170,60)
;   additem(*tree_2,-1,"tree_2")
;   additem(*tree_2,-1,"tree_22")
;   ;SetActive(*tree_2)
;   
;   Define *tree_3 = TreeWidget(10,80,170,60)
;   additem(*tree_3,-1,"tree_3")
;   additem(*tree_3,-1,"tree_33")
;   ;SetActive(*tree_3)
;   
;   WindowWidget(220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   Define *tree_4 = TreeWidget(10,10,170,60)
;   additem(*tree_4,-1,"tree_4")
;   additem(*tree_4,-1,"tree_44")
;   SetActive(*tree_4)
;   
;   Define *tree_5 = TreeWidget(10,80,170,60)
;   additem(*tree_5,-1,"tree_5")
;   additem(*tree_5,-1,"tree_55")
;   ;SetActive(*tree_5)
  
    
  BindWidgetEvent( #PB_All, @active_0(), #PB_EventType_Focus)
  BindWidgetEvent( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
  WaitCloseRootWidget()

;   Repeat
;     Event = WaitWindowEvent()
;     
;     If Event = #PB_Event_CloseWindow 
;       Quit = 1
;     EndIf
;     
;   Until Quit = 1
  
EndIf

End  
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 68
; FirstLine = 36
; Folding = --
; EnableXP