Define NewMap EventConstantsMap$()

Macro DQ
  "
EndMacro

Macro AddEventConstantToConstantsMap(_constant_)
  EventConstantsMap$(Str(_constant_)) = DQ#_constant_#DQ
EndMacro

AddEventConstantToConstantsMap(#PB_Event_Menu)
AddEventConstantToConstantsMap(#PB_Event_Gadget)
AddEventConstantToConstantsMap(#PB_Event_SysTray)
AddEventConstantToConstantsMap(#PB_Event_Timer)
AddEventConstantToConstantsMap(#PB_Event_CloseWindow)
AddEventConstantToConstantsMap(#PB_Event_Repaint)
AddEventConstantToConstantsMap(#PB_Event_SizeWindow)
AddEventConstantToConstantsMap(#PB_Event_MoveWindow)
AddEventConstantToConstantsMap(#PB_Event_MinimizeWindow)
AddEventConstantToConstantsMap(#PB_Event_MaximizeWindow)
AddEventConstantToConstantsMap(#PB_Event_RestoreWindow)
AddEventConstantToConstantsMap(#PB_Event_ActivateWindow)
AddEventConstantToConstantsMap(#PB_Event_DeactivateWindow)
AddEventConstantToConstantsMap(#PB_Event_WindowDrop)
AddEventConstantToConstantsMap(#PB_Event_GadgetDrop)
AddEventConstantToConstantsMap(#PB_Event_RightClick)
AddEventConstantToConstantsMap(#PB_Event_LeftClick)
AddEventConstantToConstantsMap(#PB_Event_LeftDoubleClick)

Procedure$ GetEventConstantNameOfEventNumber(eventNumber)
  Shared EventConstantsMap$()
  If FindMapElement(EventConstantsMap$(), Str(eventNumber))
    ProcedureReturn EventConstantsMap$()
  EndIf
EndProcedure

OpenWindow(0, #PB_Ignore, #PB_Ignore, 300, 300, "Test", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)

Define eventConstantName$
Repeat
  event = WaitWindowEvent()
  eventConstantName$ = GetEventConstantNameOfEventNumber(event)
  If eventConstantName$
    Debug eventConstantName$
  EndIf
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP