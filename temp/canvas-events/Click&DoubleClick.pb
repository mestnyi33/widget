

; OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
;   CanvasGadget(1, 10, 10, 200, 200)
;   CanvasGadget(11, 110, 110, 200, 200)

OpenWindow(2, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(2, 10, 10, 200, 200)

Define time_click, PressedGadget
Repeat 
  event = WaitWindowEvent()
  
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_LeftButtonDown
      PressedGadget = EventGadget()
      Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
    EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      If EventType() = #PB_EventType_LeftButtonUp
        ; do click events
        If PressedGadget = EventGadget( )
          ; do double-click events 
          If time_click And DoubleClickTime( ) > ElapsedMilliseconds( ) - time_click
            Debug ""+EventGadget() + " #PB_EventType_LeftDoubleClick"
            
            time_click = 0
          Else
            time_click = ElapsedMilliseconds( )
          EndIf
        EndIf
        
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonUp "
        
        ; do one-click events
        If PressedGadget = EventGadget( )
          Debug ""+EventGadget() + " #PB_EventType_LeftClick"
        EndIf
      EndIf
    CompilerElse
      If EventType() = #PB_EventType_LeftButtonUp
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonUp "
      EndIf
      If EventType() = #PB_EventType_LeftClick
        Debug ""+EventGadget() + " #PB_EventType_LeftClick "
      EndIf
      If EventType() = #PB_EventType_LeftDoubleClick
        Debug ""+EventGadget() + " #PB_EventType_LeftDoubleClick "
      EndIf
    CompilerEndIf
    
    ;       If EventType() = #PB_EventType_Change
    ;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
    ;       EndIf
    ;       If EventType() = #PB_EventType_MouseEnter
    ;         Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData()
    ;       EndIf
    ;       If EventType() = #PB_EventType_MouseLeave
    ;         Debug ""+EventGadget() + " #PB_EventType_MouseLeave "
    ;       EndIf
  EndIf
Until event = #PB_Event_CloseWindow

; windows
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftDoubleClick 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 19
; FirstLine = 9
; Folding = --
; EnableXP