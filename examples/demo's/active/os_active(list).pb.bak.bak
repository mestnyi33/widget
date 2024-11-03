
Procedure active( )
  Debug "  "+#PB_Compiler_Procedure + " window_"+EventWindow()
EndProcedure

Procedure deactive()
  Debug "  "+#PB_Compiler_Procedure + " window_"+EventWindow()
EndProcedure

Procedure event_gadget()
  Select EventType()
    Case #PB_EventType_Focus
      Debug "active" + " gadget_"+EventGadget()
    Case #PB_EventType_LostFocus
      Debug "deactive" + " gadget_"+EventGadget()
  EndSelect
EndProcedure



Define width=500, height=400

OpenWindow(0, 10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(0, 10,10,170,60)
AddGadgetItem(0,-1,"editor_0")
AddGadgetItem(0,-1,"editor_00")
;SetActiveGadget(0)

EditorGadget(1, 10,80,170,60)
AddGadgetItem(1,-1,"editor_1")
AddGadgetItem(1,-1,"editor_11")
;SetActiveGadget(1)

OpenWindow(1, 110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(2, 10,10,170,60)
AddGadgetItem(2,-1,"editor_2")
AddGadgetItem(2,-1,"editor_22")
;SetActiveGadget(2)

EditorGadget(3, 10,80,170,60)
AddGadgetItem(3,-1,"editor_3")
AddGadgetItem(3,-1,"editor_3")
;SetActiveGadget(3)

OpenWindow(2, 220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(4, 10,10,170,60)
AddGadgetItem(4,-1,"editor_4")
AddGadgetItem(4,-1,"editor_44")
SetActiveGadget(4)

EditorGadget(5, 10,80,170,60)
AddGadgetItem(5,-1,"editor_5")
AddGadgetItem(5,-1,"editor_55")
;SetActiveGadget(5)


BindEvent( #PB_Event_Gadget, @event_gadget())
BindEvent( #PB_Event_ActivateWindow, @active())
BindEvent( #PB_Event_DeactivateWindow, @deactive())

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_CloseWindow 
    Quit = 1
  EndIf
  
Until Quit = 1


End  
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 52
; FirstLine = 35
; Folding = -
; EnableXP