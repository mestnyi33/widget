;-\\ LINUX OS
XIncludeFile "../events.pbi"

Module events
   ; https://www.purebasic.fr/english/viewtopic.php?t=83913
   ImportC ""
      gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
   EndImport
   
   Procedure signal_event( *self, *event.gdkeventscroll, user_data )
      Protected deltaX.d, deltaY.d
      
      If *event\type = #GDK_SCROLL
         ;Debug "Scroll State " + *event\state
         gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
         
         If user_data
            CallCFunctionFast( user_data, ID::gadget( *self ), #PB_EventType_MouseWheelX, -deltaX )
         EndIf
      EndIf
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
; CursorPosition = 2
; Folding = --
; EnableXP