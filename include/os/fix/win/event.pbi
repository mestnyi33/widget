;-\\ WINDOW OS
XIncludeFile "../events.pbi"

Module events
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
          
          
          If EventType = #PB_EventType_Focus 
            ;Debug "f "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
              CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
          ElseIf EventType = #PB_EventType_LostFocus
            ; Debug "l "+FocusedGadget( ) +" "+ PressedGadget( )
            If FocusedGadget( ) = - 1
              CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            EndIf
            
          ElseIf (EventType = #PB_EventType_KeyDown Or
                  EventType = #PB_EventType_KeyUp Or
                  EventType = #PB_EventType_Input)
            
            CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            
            ;             ElseIf (EventType = #PB_EventType_RightButtonDown Or
            ;                     EventType = #PB_EventType_RightButtonUp)
            ;                
            ;                CallFunctionFast(*setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
          Else
            
            ;CallBack( EventType ) ;\\
            CallFunctionFast( *setcallback, #PB_Event_Gadget, EventGadget, EventType, EventData( ) )
            
          EndIf
       
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
    ;BindEvent( #PB_Event_Repaint, @Events( ) )
    
    ;       BindEvent( #PB_Event_ActivateWindow, @Events( ) )
    ;       BindEvent( #PB_Event_DeactivateWindow, @Events( ) )
    ;       BindEvent( #PB_Event_SizeWindow, @Events( ) )
  EndProcedure
EndModule
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = v-
; EnableXP