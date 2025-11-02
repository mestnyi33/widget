;-\\ LINUX OS
XIncludeFile "../events.pbi"


Module events
   ImportC ""
      gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
   EndImport
   
   ProcedureC ChangeHandler(*Scrollbar, ScrollType, value.d, user_data)
      ; https://www.purebasic.fr/english/viewtopic.php?p=370832#p370832
      
      ; display the scroll event
      Select ScrollType
         Case #GTK_SCROLL_NONE: Debug "#GTK_SCROLL_NONE"
         Case #GTK_SCROLL_JUMP: Debug "#GTK_SCROLL_JUMP"
         Case #GTK_SCROLL_STEP_BACKWARD: Debug "#GTK_SCROLL_STEP_BACKWARD"
         Case #GTK_SCROLL_STEP_FORWARD: Debug "#GTK_SCROLL_STEP_FORWARD"
         Case #GTK_SCROLL_PAGE_BACKWARD: Debug "#GTK_SCROLL_PAGE_BACKWARD"
         Case #GTK_SCROLL_PAGE_FORWARD: Debug "#GTK_SCROLL_PAGE_FORWARD"
         Case #GTK_SCROLL_STEP_UP: Debug "#GTK_SCROLL_STEP_UP"
         Case #GTK_SCROLL_STEP_DOWN: Debug "#GTK_SCROLL_STEP_DOWN"
         Case #GTK_SCROLL_PAGE_UP: Debug "#GTK_SCROLL_PAGE_UP"
         Case #GTK_SCROLL_PAGE_DOWN: Debug "#GTK_SCROLL_PAGE_DOWN"
         Case #GTK_SCROLL_STEP_LEFT: Debug "#GTK_SCROLL_STEP_LEFT"
         Case #GTK_SCROLL_STEP_RIGHT: Debug "#GTK_SCROLL_STEP_RIGHT"
         Case #GTK_SCROLL_PAGE_LEFT: Debug "#GTK_SCROLL_PAGE_LEFT"
         Case #GTK_SCROLL_PAGE_RIGHT: Debug "#GTK_SCROLL_PAGE_RIGHT"
         Case #GTK_SCROLL_START: Debug "#GTK_SCROLL_START"
         Case #GTK_SCROLL_END: Debug "#GTK_SCROLL_END"
      EndSelect
      Debug value
      
      ; move scrollbar 1 step forward regardless of the event
      SetGadgetState(0, GetGadgetState(0)+1)
      
      ; return #true to stop default processing
      ProcedureReturn #True
   EndProcedure
   
   Procedure signal_scroll_event_cb(*self, *event.gdkeventscroll, user_data)
      ; https://www.purebasic.fr/english/viewtopic.php?t=83913
      Protected deltaX.d, deltaY.d
      
      If *event\type = #GDK_SCROLL
         ;Debug "Scroll State " + *event\state
         gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
         
         PostEvent(#PB_Event_Gadget, GetActiveWindow(), user_data, #PB_EventType_MouseWheel, -deltaY)
      EndIf
   EndProcedure
   
   Procedure SetScrollEvent( gadget )
      g_signal_connect_data_(GadgetID(gadget), "change-value", @ChangeHandler(), 0, #Null, 0)
      g_signal_connect_(GadgetID(gadget), "scroll-event", @signal_scroll_event_cb(), gadget)
   EndProcedure
   
   ;-
   Procedure Events( )
      Protected eventgadget
      Protected eventtype
      
      If *setcallback
         eventtype = EventType( )
         EventGadget = EventGadget( )
         
         If eventtype = #PB_EventType_Resize
            CallFunctionFast( *setcallback, EventGadget, eventtype, EventData( ))
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
            
            CallFunctionFast( *setcallback, EventGadget, eventtype, EventData( ) )
         EndIf
      EndIf
   EndProcedure
   
   Procedure.i WaitEvent( event.i, second.i = 0 )
      ProcedureReturn event
   EndProcedure
   
   Procedure   SetCallBack(*callback)
      *setcallback = *callback
      
      ;       ;\\
      BindEvent( #PB_Event_Gadget, @Events( ) )
   EndProcedure
EndModule
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 53
; FirstLine = 65
; Folding = ---
; EnableXP