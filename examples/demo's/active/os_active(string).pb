
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

Procedure SetGadGetWidgetTextWordWrap( gadget,state )
  CompilerIf Subsystem("qt")
    QtScript(~"gadget("+gadget+").wordWrap = "+state+"")
  CompilerEndIf
EndProcedure



Define width=500, height=400
BindEvent( #PB_Event_Gadget, @event_gadget())
BindEvent( #PB_Event_ActivateWindow, @active())
BindEvent( #PB_Event_DeactivateWindow, @deactive())


OpenWindow(0, 10, 10, 190, 150, "Window_0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(0, 10,10,170,60,"string_0")
;SetActiveGadget(0)

StringGadget(1, 10,80,170,60,"string_1")
;SetActiveGadget(1)

OpenWindow(1, 110, 30, 190, 150, "Window_1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(2, 10,10,170,60,"string_2")
;SetActiveGadget(2)

StringGadget(3, 10,80,170,60,"string_3")
;SetActiveGadget(3)

OpenWindow(2, 220, 50, 190, 150, "Window_2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(4, 10,10,170,60,"string_4")
;SetActiveGadget(4)

StringGadget(5, 10,80,170,60,"string_5")
SetActiveGadget(5)


Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_CloseWindow 
    Quit = 1
  EndIf
  
Until Quit = 1


End  
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP