
Procedure Active( )
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



Define i, Width=500, Height=400

OpenWindow(0, 10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(0, 10,10,170,60)
For i = 0 To 9
   AddGadgetItem(0,-1,"editor_0"+Str(i))
Next
;SetActiveGadget(0)

EditorGadget(1, 10,80,170,60)
For i = 0 To 9
   AddGadgetItem(1,-1,"editor_1"+Str(i))
Next
;SetActiveGadget(1)

OpenWindow(1, 110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(2, 10,10,170,60)
For i = 0 To 9
   AddGadgetItem(2,-1,"editor_2"+Str(i))
Next
;SetActiveGadget(2)

EditorGadget(3, 10,80,170,60)
For i = 0 To 9
   AddGadgetItem(3,-1,"editor_3"+Str(i))
Next
;SetActiveGadget(3)

OpenWindow(2, 220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
EditorGadget(4, 10,10,170,60)
For i = 0 To 9
   AddGadgetItem(4,-1,"editor_4"+Str(i))
Next
;SetActiveGadget(4)

EditorGadget(5, 10,80,170,60)
For i = 0 To 9
   AddGadgetItem(5,-1,"editor_5"+Str(i))
Next
SetActiveGadget(5)


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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 56
; FirstLine = 28
; Folding = -
; EnableXP