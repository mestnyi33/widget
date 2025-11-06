;-\\ LINUX OS
XIncludeFile "../events.pbi"

Module events
   ; https://www.purebasic.fr/english/viewtopic.php?t=83913
   ImportC ""
      gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
   EndImport
   #GDK_SCROLL_SMOOTH = 4 ; Since 3.4
   
   Structure GdkEventScrollEx Extends GdkEventScroll
      delta_x.d
      delta_y.d
      is_stop.l
   EndStructure
   
   CompilerIf Defined(GdkEvent,#PB_Structure)=#False
      Structure GdkEvent
         StructureUnion
            Type.l
            any.GdkEventAny
            expose.GdkEventExpose   
            no_expose.GdkEventNoExpose   
            visibility.GdkEventVisibility   
            motion.GdkEventMotion
            Button.GdkEventButton
            Scroll.GdkEventScrollEx
            key.GdkEventKey
            crossing.GdkEventCrossing
            focus_change.GdkEventFocus           
            configure.GdkEventConfigure       
            property.GdkEventProperty   
            selection.GdkEventSelection   
            proximity.GdkEventProximity
            client.GdkEventClient       
            dnd.GdkEventDND               
            window_state.GdkEventWindowState       
            setting.GdkEventSetting           
         EndStructureUnion
      EndStructure
   CompilerEndIf
   
   Procedure signal_event( *Widget, *Event.GdkEvent, Gadget) ; *self, *event.gdkeventscroll, user_data )
                                                             ;       Protected deltaX.d, deltaY.d
                                                             ;       
                                                             ;       If *event\type = #GDK_SCROLL
                                                             ;          ;Debug "Scroll State " + *event\state
                                                             ;          gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
                                                             ;          
                                                             ;          If user_data
                                                             ;             CallCFunctionFast( user_data, ID::gadget( *self ), #PB_EventType_MouseWheelX, -deltaX )
                                                             ;          EndIf
                                                             ;       EndIf
      
      
      With *Event
         Select \Type
            Case #GDK_BUTTON_PRESS
               Select \button\button
                  Case  1
                     ;Debug "Left Button Press"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_LeftButtonDown)
                  Case 2
                     ;Debug "Right Button Press"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_MiddleButtonDown)
                  Case 3
                     ;Debug "Right Button Press"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_RightButtonDown)
               EndSelect
               ProcedureReturn #True
               
            Case #GDK_BUTTON_RELEASE
               Select \button\button
                  Case  1
                     ;Debug "Left Button Release"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_LeftButtonUp)
                  Case 2
                     ;Debug "Right Button Release"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_MiddleButtonUp)
                  Case 3
                     ;Debug "Right Button Release"
                     PostEvent(#PB_Event_Gadget, EventWindow(), Gadget, #PB_EventType_RightButtonUp)
               EndSelect
               ProcedureReturn #True
               
            Case #GDK_SCROLL
               
               If \scroll\direction = #GDK_SCROLL_LEFT Or 
                  \scroll\direction = #GDK_SCROLL_RIGHT
                  PostEvent(#PB_Event_Gadget, GetActiveWindow(), user_data, #PB_EventType_MouseWheelX, \scroll\x)
                  
               ElseIf \scroll\direction = #GDK_SCROLL_UP Or
                      \scroll\direction = #GDK_SCROLL_DOWN
                  PostEvent(#PB_Event_Gadget, GetActiveWindow(), user_data, #PB_EventType_MouseWheelY, \scroll\y)
                  
               ElseIf \scroll\direction = #GDK_SCROLL_SMOOTH
                  If \scroll\delta_x <> 0.0
                     PostEvent(#PB_Event_Gadget, GetActiveWindow(), user_data, #PB_EventType_MouseWheelX, \scroll\delta_x)
                  EndIf
                  If \scroll\delta_y <> 0.0
                     PostEvent(#PB_Event_Gadget, GetActiveWindow(), user_data, #PB_EventType_MouseWheelY, \scroll\delta_y)
                  EndIf
               EndIf
               ProcedureReturn #True
               
         EndSelect
      EndWith
      ProcedureReturn #False
   EndProcedure
   
   Procedure BindGadget( gadget, *callBack, eventtype = #PB_All  )
      ; g_signal_connect_data_(GadgetID(gadget), "change-value", @ChangeHandler( ), 0, #Null, 0)
      g_signal_connect_( GadgetID(gadget), "event", @signal_event( ), *callBack )
   EndProcedure
   
   ;-
   ;    Procedure.i WaitEvent( event.i, second.i = 0 )
   ;       ProcedureReturn event
   ;    EndProcedure
   
   Procedure   SetCallBack( *callback )
      
   EndProcedure
EndModule
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 89
; FirstLine = 68
; Folding = ---
; EnableXP