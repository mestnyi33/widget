﻿XIncludeFile "../../../widgets.pbi" 
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

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Open(Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
  ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
;   Bind(#PB_All, @active(), #PB_EventType_Focus)
;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

  Window(10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Define *tree_0 = tree(10,10,170,60)
  additem(*tree_0,-1,"tree_0")
  additem(*tree_0,-1,"tree_00")
  ;SetActive(*tree_0)
  
  Define *tree_1 = tree(10,80,170,60)
  additem(*tree_1,-1,"tree_1")
  additem(*tree_1,-1,"tree_11")
  ;SetActive(*tree_1)
  
;   Window(110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   Define *tree_2 = tree(10,10,170,60)
;   additem(*tree_2,-1,"tree_2")
;   additem(*tree_2,-1,"tree_22")
;   ;SetActive(*tree_2)
;   
;   Define *tree_3 = tree(10,80,170,60)
;   additem(*tree_3,-1,"tree_3")
;   additem(*tree_3,-1,"tree_33")
;   ;SetActive(*tree_3)
;   
;   Window(220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   Define *tree_4 = tree(10,10,170,60)
;   additem(*tree_4,-1,"tree_4")
;   additem(*tree_4,-1,"tree_44")
;   SetActive(*tree_4)
;   
;   Define *tree_5 = tree(10,80,170,60)
;   additem(*tree_5,-1,"tree_5")
;   additem(*tree_5,-1,"tree_55")
;   ;SetActive(*tree_5)
  
    
  Bind( #PB_All, @active_0(), #PB_EventType_Focus)
  Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
  
  WaitClose()

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