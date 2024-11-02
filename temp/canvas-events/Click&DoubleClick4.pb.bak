

; OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
;   CanvasGadget(1, 10, 10, 200, 200)
;   CanvasGadget(11, 110, 110, 200, 200)

OpenWindow(2, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(2, 10, 10, 200, 200)

Define click_time = DoubleClickTime( )/2, PressedGadget, up_time
Repeat 
  event = WaitWindowEvent()
  
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_LeftButtonDown
      PressedGadget = EventGadget()
      
      If up_time And ElapsedMilliseconds( ) - up_time <= click_time
        Debug " "+Str(ElapsedMilliseconds( ) - up_time)
        up_time = ElapsedMilliseconds( )
      Else
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown" 
      EndIf
      
    EndIf
    
    If EventType() = #PB_EventType_LeftButtonUp
      ; do click events
      If PressedGadget = EventGadget( )
        
        If up_time And ElapsedMilliseconds( ) - up_time <= click_time
          Debug "    "+Str(ElapsedMilliseconds( ) - up_time)
          Debug ""+EventGadget() + " #PB_EventType_LeftDoubleClick" 
          Debug ""
          up_time = 0
        Else
          Debug ""+EventGadget() + " #PB_EventType_LeftButtonUp " 
          Debug ""+EventGadget() + " #PB_EventType_LeftClick" 
          
          up_time = ElapsedMilliseconds( )
        EndIf
        
      EndIf
    EndIf
    
  EndIf
Until event = #PB_Event_CloseWindow

; click
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 

; double click
;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
;   2 #PB_EventType_LeftDoubleClick 

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP