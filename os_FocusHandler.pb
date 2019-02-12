Procedure Handler()
  Select Event()
    Case #PB_Event_ActivateWindow    : Debug "Activate - " + EventWindow()
    Case #PB_Event_DeactivateWindow  : Debug "Deactivate - " + EventWindow()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_Focus     : Debug "Focus - " + EventGadget()
        Case #PB_EventType_LostFocus : Debug "LostFocus - " + EventGadget()
      EndSelect
  EndSelect
EndProcedure

BindEvent(#PB_Event_ActivateWindow, @Handler())
BindEvent(#PB_Event_DeactivateWindow, @Handler())
BindEvent(#PB_Event_Gadget, @Handler())


OpenWindow(100, 220, 140, 200+20, 260+40, "Window_100", #PB_Window_ScreenCentered)
PanelGadget(500,0,0, 200+20, 260+40)
AddGadgetItem(500,-1,"")
ButtonGadget(101, 10, 10, 180, 20, "(101) SetActive window_0")
ButtonGadget(102, 10, 35, 180, 20, "(102) SetFocus gadget_1")
ButtonGadget(103, 10, 60, 180, 20, "(103) SetFocus gadget_2")

ButtonGadget(104, 10, 85+10, 180, 20, "(104) SetActive window_10")
ButtonGadget(105, 10, 85+35, 180, 20, "(105) SetFocus gadget_11")
ButtonGadget(106, 10, 85+60, 180, 20, "(106) SetFocus gadget_12")

ButtonGadget(107, 10, 85+85+10, 180, 20, "(107) SetActive window_20")
ButtonGadget(108, 10, 85+85+35, 180, 20, "(108) SetFocus gadget_21")
ButtonGadget(109, 10, 85+85+60, 180, 20, "(109) SetFocus gadget_22")


OpenWindow(0, 100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu, WindowID(100))
StringGadget(1, 10, 10, 180, 85, "String_1")
StringGadget(2, 10, 105, 180, 85, "String_2")

OpenWindow(10, 160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu, WindowID(100))
StringGadget(11, 10, 10, 180, 85, "String_11")
StringGadget(12, 10, 105, 180, 85, "String_12")

OpenWindow(20, 220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu, WindowID(100))
StringGadget(21, 10, 10, 180, 85, "String_21")
StringGadget(22, 10, 105, 180, 85, "String_22")

Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick : Debug " "
          Select EventGadget()
            Case 101 : SetActiveWindow(0)
            Case 102 : SetActiveGadget(1)
            Case 103 : SetActiveGadget(2)
              
            Case 104 : SetActiveWindow(10)
            Case 105 : SetActiveGadget(11)
            Case 106 : SetActiveGadget(12)
              
            Case 107 : SetActiveWindow(20)
            Case 108 : SetActiveGadget(21)
            Case 109 : SetActiveGadget(22)
          EndSelect
      EndSelect
  EndSelect
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP