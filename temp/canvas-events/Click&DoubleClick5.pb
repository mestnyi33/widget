

; OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
;   CanvasGadget(1, 10, 10, 200, 200)
;   CanvasGadget(11, 110, 110, 200, 200)

OpenWindow(2, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(2, 10, 10, 200, 200)

Define time_click, PressedGadget, down
Repeat 
  event = WaitWindowEvent()
  
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_LeftButtonDown
      PressedGadget = EventGadget()
      Debug Str( ElapsedMilliseconds( ) - time_click )
      
      If Not ( time_click And ElapsedMilliseconds( ) - time_click < 160 )
        time_click = 0
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "+ Str( ElapsedMilliseconds( ) - time_click)
      EndIf
    EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      If EventType( ) = #PB_EventType_LeftButtonUp
        ; do click events
        If Not ( time_click And ElapsedMilliseconds( ) - time_click < DoubleClickTime( ) )
          time_click = ElapsedMilliseconds( )
          Debug ""+EventGadget( ) + " #PB_EventType_LeftButtonUp "
          
          If PressedGadget = EventGadget( )
            ; do one-click events
            Debug ""+EventGadget( ) + " #PB_EventType_LeftClick"
          EndIf
        Else
          If PressedGadget = EventGadget( )
            ; do double-click events 
            Debug ""+EventGadget( ) + " #PB_EventType_LeftDoubleClick"
          EndIf
          
          time_click = 0
        EndIf
        
        
      EndIf
    CompilerElse
      If EventType( ) = #PB_EventType_LeftButtonUp
        Debug ""+EventGadget( ) + " #PB_EventType_LeftButtonUp "
      EndIf
      If EventType( ) = #PB_EventType_LeftClick
        Debug ""+EventGadget( ) + " #PB_EventType_LeftClick "
      EndIf
      If EventType( ) = #PB_EventType_LeftDoubleClick
        Debug ""+EventGadget( ) + " #PB_EventType_LeftDoubleClick "
      EndIf
    CompilerEndIf
    
    ;       If EventType() = #PB_EventType_Change
    ;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
    ;       EndIf
    If EventType() = #PB_EventType_MouseEnter
      Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData()
    EndIf
    If EventType() = #PB_EventType_MouseLeave
      PressedGadget = 0
      Debug ""+EventGadget() + " #PB_EventType_MouseLeave "
    EndIf
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP