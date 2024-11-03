

; OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
;   CanvasGadget(1, 10, 10, 200, 200)
;   CanvasGadget(11, 110, 110, 200, 200)

OpenWindow(2, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(2, 10, 10, 200, 200)

Define click_time = 200, count, PressedGadget, up_time, down_time, click
Repeat 
  event = WaitWindowEvent()
  
  If event = #PB_Event_Gadget
    If EventType() = #PB_EventType_LeftButtonDown
      PressedGadget = EventGadget()
      
      If down_time And ElapsedMilliseconds( ) - down_time <= click_time
        If double = 1
          double = 2
        Else
          click = 1
        EndIf
      EndIf
      
      If up_time And ElapsedMilliseconds( ) - up_time <= click_time
        up_time = ElapsedMilliseconds( )
        
        If double = 1
          click = 1
        EndIf
      Else
        double = 1
        click = 1
      EndIf
      
      If click = 1
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown " + double
        click = 0
      EndIf
      
      down_time = ElapsedMilliseconds( )
      
    EndIf
    
    If EventType() = #PB_EventType_LeftButtonUp
      
      ; do click events
      If PressedGadget = EventGadget( )
        down_time = ElapsedMilliseconds( )
        If ElapsedMilliseconds( ) - down_time <= click_time
          If double = 1
            Debug ""+EventGadget() + " #PB_EventType_LeftClick " 
            click = 2
          EndIf
        Else
          click = 2
        EndIf
        
        If ElapsedMilliseconds( ) - up_time <= click_time
          If double = 2
            Debug ""+EventGadget() + " .. #PB_EventType_LeftDoubleClick " 
            ;              up_time = 0
            ;              down_time = 0
            double = 0
          Else
            Debug ""+EventGadget() + " #PB_EventType_LeftClick " 
            click = 2
          EndIf
        Else
          ; Debug ""+EventGadget() + " #PB_EventType_LeftClick " 
          ;  Debug double
        EndIf
        
        If click = 2
          Debug ""+EventGadget() + " #PB_EventType_LeftButtonUp " 
          
          click = 0
        EndIf
        
        
        up_time = ElapsedMilliseconds( )
      EndIf
      
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