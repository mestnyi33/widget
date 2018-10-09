Procedure ButtonHandler()
  Select EventType()
    Case #PB_EventType_LeftButtonDown
      Debug "LeftButtonDown"
      
    Case #PB_EventType_LostFocus
      Debug "LostFocus"
      
    Case #PB_EventType_Focus
      Debug "Focus"
      
;     Case #PB_EventType_MouseEnter
;       Debug "MouseEnter"
;       
;     Case #PB_EventType_MouseLeave 
;       Debug "MouseLeave"
;       
;     Case #PB_EventType_LeftButtonUp
;       Debug "LeftButtonUp"
;       
;     Case #PB_EventType_LeftClick
;       Debug "LeftClick"
      
      
  EndSelect
EndProcedure

OpenWindow(0, 100, 100, 200, 90, "Mouse events bug", #PB_Window_SystemMenu)

CanvasGadget(1, 10, 10, 180, 30, #PB_Canvas_Keyboard)
CanvasGadget(2, 10, 50, 180, 30, #PB_Canvas_Keyboard)

BindGadgetEvent(1, @ButtonHandler())
BindGadgetEvent(2, @ButtonHandler())

OpenWindow(10, 100, 100, 200, 90, "Mouse events bug", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)

CanvasGadget(11, 10, 10, 180, 30, #PB_Canvas_Keyboard)
CanvasGadget(12, 10, 50, 180, 30, #PB_Canvas_Keyboard)

BindGadgetEvent(11, @ButtonHandler())
BindGadgetEvent(12, @ButtonHandler())

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP