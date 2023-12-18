;-\\ WINDOW OS
XIncludeFile "../events.pbi"

Module events
   ;-
   Procedure Events( )
      Protected eventgadget
      Protected eventtype
      
      If *setcallback
         Select Event( ) 
            Case #PB_Event_Gadget
              eventtype = EventType( )
               EventGadget = EventGadget( )
               
                If eventtype = #PB_EventType_Resize
                  CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ))
               EndIf
               
               If eventtype <> #PB_EventType_LeftClick
                  If eventtype = #PB_EventType_MouseEnter
                     EnteredGadget( ) = EventGadget
                  EndIf
                  If eventtype = #PB_EventType_LeftButtonDown
                     PressedGadget( ) = EnteredGadget( )
                  EndIf
                  If eventtype = #PB_EventType_Focus
                     FocusedGadget( ) = EnteredGadget( )
                  EndIf
                  If eventtype = #PB_EventType_LostFocus
                     FocusedGadget( ) = - 1
                  EndIf
                  
                  CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, eventtype, EventData( ) )
               EndIf
               
            Case #PB_Event_SizeWindow
               CallFunctionFast(*setcallback, #PB_Event_SizeWindow, #PB_All, #PB_All, #Null )
               
         EndSelect
      EndIf
   EndProcedure
   
   Procedure.i WaitEvent( event.i, second.i = 0 )
      ProcedureReturn event
   EndProcedure
   
   Procedure   SetCallBack(*callback)
      *setcallback = *callback
      
      ;       ;\\
             BindEvent( #PB_Event_Gadget, @Events( ) )
      ;       BindEvent( #PB_Event_ActivateWindow, @Events( ) )
      ;       BindEvent( #PB_Event_DeactivateWindow, @Events( ) )
      ;       BindEvent( #PB_Event_SizeWindow, @Events( ) )
   EndProcedure
EndModule
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 36
; FirstLine = 14
; Folding = ---
; EnableXP