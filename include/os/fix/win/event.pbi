;-\\ WINDOW OS
XIncludeFile "../events.pbi"

Module events
   ;-
   Procedure Events( )
      
      If *setcallback
         Select Event( ) 
            Case #PB_Event_Gadget
               If EventType( ) = #PB_EventType_Resize
                  CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget( ), EventType( ), EventData( ))
               EndIf
               
               If EventType( ) <> #PB_EventType_LeftClick
                  If EventType( ) = #PB_EventType_MouseEnter
                     EnteredGadget( ) = EventGadget( )
                  EndIf
                  If EventType( ) = #PB_EventType_LeftButtonDown
                     PressedGadget( ) = EnteredGadget( )
                  EndIf
                  If EventType( ) = #PB_EventType_Focus
                     FocusedGadget( ) = EnteredGadget( )
                  EndIf
                  If EventType( ) = #PB_EventType_LostFocus
                     FocusedGadget( ) = - 1
                  EndIf
                  
                  CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget( ), EventType( ), EventData( ) )
               EndIf
               
            Case #PB_Event_SizeWindow
               CallFunctionFast(*setcallback, #PB_Event_SizeWindow, #PB_All, #PB_All, #Null )
               
         EndSelect
      EndIf
   EndProcedure
   
   Procedure.i WaitEvent( event.i, second.i = 0 )
      Protected EventGadget, EventType, EventData
      
      If *setcallback 
;          If event = #PB_Event_ActivateWindow
;             ; Debug " WaitEvent - ActivateWindow"
;             CallCFunctionFast(*setcallback, #PB_Event_ActivateWindow, #PB_All, #PB_EventType_Focus, #Null )
;          EndIf
;          
;          If event = #PB_Event_DeactivateWindow
;             ; Debug " WaitEvent - DeactivateWindow"
;             CallCFunctionFast(*setcallback, #PB_Event_DeactivateWindow, #PB_All, #PB_EventType_LostFocus, #Null )
;          EndIf
         
;          If event = #PB_Event_Gadget
;             eventgadget = EventGadget( )
;             EventType = EventType( )
;             
;             If EventType <> #PB_EventType_LeftClick
;                If EventType = #PB_EventType_MouseEnter
;                   EnteredGadget( ) = eventgadget
;                EndIf
;                
;                CallFunctionFast( *setcallback, #PB_Event_Gadget, eventgadget, EventType, EventData( ) )
;             EndIf
;          EndIf
      EndIf
      
      ProcedureReturn event
   EndProcedure
   
   Procedure   SetCallBack(*callback)
      *setcallback = *callback
      
      ;       ;\\
      ;       BindEvent( #PB_Event_Gadget, @Events( ) )
      ;       BindEvent( #PB_Event_ActivateWindow, @Events( ) )
      ;       BindEvent( #PB_Event_DeactivateWindow, @Events( ) )
      ;       BindEvent( #PB_Event_SizeWindow, @Events( ) )
   EndProcedure
EndModule
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 33
; FirstLine = 5
; Folding = ---
; EnableXP