;-\\ LINUX OS
XIncludeFile "../events.pbi"

Module events
   ;-
   Procedure   Events( )
      Protected eventgadget = - 1
      
      If *setcallback
         Select Event( ) 
            Case #PB_Event_Gadget
               If EventType( ) = #PB_EventType_Resize
                  CallCFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget( ), EventType( ), EventData( ))
               EndIf
               
               ;             Case #PB_Event_ActivateWindow   
               ;                Debug " Events - ActivateWindow"
               ;                eventgadget = GetWindowData( EventWindow( ) )
               ;                If IsGadget( eventgadget )
               ;                CallCFunctionFast(*setcallback, #PB_Event_ActivateWindow, eventgadget, #PB_EventType_Focus, #Null )
               ;                EndIf
               ;                
               ;             Case #PB_Event_DeactivateWindow
               ;                Debug " Events - DeactivateWindow"
               ;                eventgadget = GetWindowData( EventWindow( ) )
               ;                If IsGadget( eventgadget )
               ;                   CallCFunctionFast(*setcallback, #PB_Event_DeactivateWindow, eventgadget, #PB_EventType_LostFocus, #Null )
               ;                EndIf
               
            Case #PB_Event_SizeWindow
               eventgadget = GetWindowData( EventWindow( ) )
               If IsGadget( eventgadget )
                  CallCFunctionFast(*setcallback, #PB_Event_SizeWindow, eventgadget, #PB_EventType_Resize, #Null )
               EndIf
         EndSelect
      EndIf
   EndProcedure
   
   Procedure.i WaitEvent( event.i, second.i = 0 )
      Protected EventGadget, EventType, EventData
      
      If *setcallback 
;          If event = #PB_Event_Repaint
;             ; Debug " WaitEvent - Repaint"
;             If IsWindow( EventWindow( ) )
;                eventgadget = GetWindowData( EventWindow( ) )
;                If IsGadget( eventgadget )
;                   CallCFunctionFast(*setcallback, #PB_Event_Repaint, eventgadget, #PB_All, EventData( ) )
;                EndIf
;             EndIf
;          EndIf
         
         If event = #PB_Event_ActivateWindow
            ; Debug " WaitEvent - ActivateWindow"
            eventgadget = GetWindowData( EventWindow( ) )
            If IsGadget( eventgadget )
               CallCFunctionFast( *setcallback, #PB_Event_ActivateWindow, eventgadget, #PB_EventType_Focus, #Null )
            EndIf
         EndIf
         
         If event = #PB_Event_DeactivateWindow
            ;             ; Debug " WaitEvent - DeactivateWindow"
           eventgadget = GetWindowData( EventWindow( ) )
           If IsGadget( eventgadget )
             CallCFunctionFast( *setcallback, #PB_Event_DeactivateWindow, eventgadget, #PB_EventType_LostFocus, #Null )
           EndIf
         EndIf
         
         If event = #PB_Event_Gadget
            eventgadget = EventGadget( )
            EventType = EventType( )
            
            If EventType <> #PB_EventType_LeftClick
               If EventType = #PB_EventType_MouseEnter
                  EnteredGadget( ) = eventgadget
               EndIf
               
               CallFunctionFast( *setcallback, #PB_Event_Gadget, eventgadget, EventType, EventData( ) )
            EndIf
         EndIf
      EndIf
      
      ProcedureReturn event
   EndProcedure
   
   Procedure   SetCallBack(*callback)
      *setcallback = *callback
   EndProcedure
EndModule
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 50
; FirstLine = 38
; Folding = ---
; EnableXP