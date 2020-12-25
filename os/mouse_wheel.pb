EnableExplicit
Global wheel_y
Global Event

If OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0, 10, 10, 200, 200, #PB_Canvas_Keyboard)
    SetActiveGadget(0)
    
    Repeat
      Event = WaitWindowEvent()
          
      If Event = #PB_Event_Gadget And EventGadget() = 0 
        ; clear 
        If EventType() = #PB_EventType_LeftButtonDown
          wheel_y = 0
          
          If StartDrawing(CanvasOutput(0))
           Box(0,0,OutputWidth(), OutputHeight())
           StopDrawing()
          EndIf
        EndIf
        
        ; draw
        If EventType() = #PB_EventType_MouseWheel
         If StartDrawing(CanvasOutput(0))
            wheel_y + GetGadgetAttribute(0, #PB_Canvas_WheelDelta)
            
            If wheel_y < 0 
              wheel_y = 200
            EndIf
            
            If wheel_y > 200 
              wheel_y = 0
            EndIf
            
            Circle(50, wheel_y, 10, RGB(Random(255), Random(255), Random(255)))
            StopDrawing()
          EndIf
        EndIf
      EndIf    
      
    Until Event = #PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP