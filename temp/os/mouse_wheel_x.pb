EnableExplicit
Global wheel_x
Global Event
Global app, ev
              
If OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0, 10, 10, 200, 200, #PB_Canvas_Keyboard)
    SetActiveGadget(0)
    
    Repeat
      Event = WaitWindowEvent()
          
      If Event = #PB_Event_Gadget And EventGadget() = 0 
        ; clear 
        If EventType() = #PB_EventType_LeftButtonDown
          wheel_x = 0
          
          If StartDrawing(CanvasOutput(0))
           Box(0,0,OutputWidth(), OutputHeight())
           StopDrawing()
          EndIf
        EndIf
        
        ; draw
        If EventType() = #PB_EventType_MouseWheel
          If StartDrawing(CanvasOutput(0))
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              app = CocoaMessage(0,0,"NSApplication sharedApplication")
              If app
                ev = CocoaMessage(0,app,"currentEvent")
                If ev
                  wheel_x + CocoaMessage(0,ev,"scrollingDeltaX")
                EndIf
              EndIf
            CompilerEndIf
        
            If wheel_x < 0 
              wheel_x = 200
            EndIf
            
            If wheel_x > 200 
              wheel_x = 0
            EndIf
            
            Circle(wheel_x, 30+Random(140), 10, RGB(Random(255), Random(255), Random(255)))
            StopDrawing()
          EndIf
        EndIf
      EndIf    
      
    Until Event = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP