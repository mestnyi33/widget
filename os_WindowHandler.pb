Procedure Handler()
  Select Event()
    Case #PB_Event_ActivateWindow  
      Debug "Activate - " + EventWindow()
      
    Case #PB_Event_DeactivateWindow
      Debug "Deactivate - " + EventWindow()
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_Focus
          Debug "Focus - " + EventGadget()
        Case #PB_EventType_LostFocus
          Debug "LostFocus - " + EventGadget()
      EndSelect
  EndSelect
EndProcedure

Procedure WindowHandler()
;   Select Event()
;     Case #PB_Event_ActivateWindow  
;       Debug "  Activate - " + EventWindow()
;       
;     Case #PB_Event_DeactivateWindow
;       Debug "  Deactivate - " + EventWindow()
;       
;     Case #PB_Event_Gadget
;       Select EventType()
;         Case #PB_EventType_Focus
;           Debug "  Focus - " + EventGadget()
;         Case #PB_EventType_LostFocus
;           Debug "  LostFocus - " + EventGadget()
;       EndSelect
;   EndSelect
EndProcedure

BindEvent(#PB_Event_ActivateWindow, @Handler())
BindEvent(#PB_Event_DeactivateWindow, @Handler())
BindEvent(#PB_Event_Gadget, @Handler())

; OpenWindow(0, 100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu)
; StringGadget(0, 10, 10, 180, 85, "String_0")
; StringGadget(1, 10, 105, 180, 85, "String_1")
; 
; OpenWindow(10, 160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu)
; StringGadget(10, 10, 10, 180, 85, "String_10")
; StringGadget(11, 10, 105, 180, 85, "String_11")
; 
; OpenWindow(20, 220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu)
; StringGadget(20, 10, 10, 180, 85, "String_20")
; StringGadget(21, 10, 105, 180, 85, "String_21")

; OpenWindow(0, 100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu)
; CanvasGadget(0, 10, 10, 180, 85, #PB_Canvas_DrawFocus);, "String_0")
; CanvasGadget(1, 10, 105, 180, 85, #PB_Canvas_DrawFocus);, "String_1")
; 
; OpenWindow(10, 160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu)
; CanvasGadget(10, 10, 10, 180, 85, #PB_Canvas_DrawFocus);, "String_10")
; CanvasGadget(11, 10, 105, 180, 85, #PB_Canvas_DrawFocus);, "String_11")
; 
; OpenWindow(20, 220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu)
; CanvasGadget(20, 10, 10, 180, 85, #PB_Canvas_DrawFocus);, "String_20")
; CanvasGadget(21, 10, 105, 180, 85, #PB_Canvas_DrawFocus);, "String_21")

OpenWindow(100, 220, 140, 200, 260, "Window_100", #PB_Window_ScreenCentered)
ButtonGadget(101, 10, 10, 180, 25, "101 Active window_0")
ButtonGadget(102, 10, 35, 180, 25, "102 Focus gadget_1")
ButtonGadget(103, 10, 60, 180, 25, "103 Focus gadget_2")

ButtonGadget(104, 10, 85+10, 180, 25, "104 Active window_10")
ButtonGadget(105, 10, 85+35, 180, 25, "105 Focus gadget_11")
ButtonGadget(106, 10, 85+60, 180, 25, "106 Focus gadget_12")

ButtonGadget(107, 10, 85+85+10, 180, 25, "107 Active window_20")
ButtonGadget(108, 10, 85+85+35, 180, 25, "108 Focus gadget_21")
ButtonGadget(109, 10, 85+85+60, 180, 25, "109 Focus gadget_22")


;  bug в мак ос не устанавливает фокус
OpenWindow(0, 100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu, WindowID(100))
CanvasGadget(1, 10, 10, 180, 85, #PB_Canvas_Keyboard);, "String_1")
CanvasGadget(2, 10, 105, 180, 85, #PB_Canvas_Keyboard);, "String_2")
; Debug GetActiveWindow()
BindEvent(#PB_Event_ActivateWindow, @WindowHandler(), 0)
BindEvent(#PB_Event_DeactivateWindow, @WindowHandler(), 0)
BindEvent(#PB_Event_Gadget, @WindowHandler(), 0)

OpenWindow(10, 160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu, WindowID(100))
CanvasGadget(11, 10, 10, 180, 85, #PB_Canvas_Keyboard);, "String_11")
CanvasGadget(12, 10, 105, 180, 85, #PB_Canvas_Keyboard);, "String_12")
; Debug GetActiveWindow()
BindEvent(#PB_Event_ActivateWindow, @WindowHandler(), 10)
BindEvent(#PB_Event_DeactivateWindow, @WindowHandler(), 10)
BindEvent(#PB_Event_Gadget, @WindowHandler(), 10)

OpenWindow(20, 220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu, WindowID(100))
CanvasGadget(21, 10, 10, 180, 85, #PB_Canvas_Keyboard);, "String_21")
CanvasGadget(22, 10, 105, 180, 85, #PB_Canvas_Keyboard);, "String_22")
; Debug GetActiveWindow()
BindEvent(#PB_Event_ActivateWindow, @WindowHandler(), 20)
BindEvent(#PB_Event_DeactivateWindow, @WindowHandler(), 20)
BindEvent(#PB_Event_Gadget, @WindowHandler(), 20)



Repeat
  Event = WaitWindowEvent()
  
  Select Event
;     Case #PB_Event_ActivateWindow  
;       Debug "Wait  Activate - " + EventWindow()
;       
;     Case #PB_Event_DeactivateWindow
;       Debug "Wait  Deactivate - " + EventWindow()
       
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Debug ""
          
          Select EventGadget()
            Case 101
              SetActiveWindow(0)
            Case 102
              SetActiveGadget(1)
            Case 103
              SetActiveGadget(2)
              
            Case 104
              SetActiveWindow(10)
            Case 105
              SetActiveGadget(11)
            Case 106
              SetActiveGadget(12)
              
            Case 107
              SetActiveWindow(20)
            Case 108
              SetActiveGadget(21)
            Case 109
              SetActiveGadget(22)
          EndSelect
          
;         Case #PB_EventType_Focus
;           Debug "Wait  Focus - " + EventGadget()
;         Case #PB_EventType_LostFocus
;           Debug "Wait  LostFocus - " + EventGadget()
      EndSelect
  EndSelect
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP