;-\\ LINUX OS
XIncludeFile "../events.pbi"

Module events
   ; https://www.purebasic.fr/english/viewtopic.php?t=83913
   ImportC ""
      gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
   EndImport
   #GDK_SCROLL_SMOOTH = 4 ; Since 3.4
   
   Procedure signal_event( *widget, *event.GdkEventScroll, Gadget) 
     
      ; CallCFunctionFast( user_data, ID::gadget( *widget )
         Protected deltaX.d, deltaY.d, Window = EventWindow( )
         
         If *event\type = #GDK_SCROLL
           ;Debug "Scroll State " + *event\state
           
           If Gadget
             
             If *event\direction = #GDK_SCROLL_LEFT
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, -1)
             ElseIf *event\direction = #GDK_SCROLL_RIGHT
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, 1)
             ElseIf *event\direction = #GDK_SCROLL_UP
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, -1)
             ElseIf *event\direction = #GDK_SCROLL_DOWN
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, 1)
             ElseIf *event\direction = #GDK_SCROLL_SMOOTH
               gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
               Debug 3333
               If deltax <> 0.0
                 PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, - deltaX)
               EndIf
               If deltaY <> 0.0
                 PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, - deltaY)
               EndIf
             EndIf
             
             ProcedureReturn #True
           EndIf
         EndIf
         
         ProcedureReturn #False
   EndProcedure
   
   Procedure BindGadget( gadget, *callBack, eventtype = #PB_All  )
      ; g_signal_connect_data_(GadgetID(gadget), "change-value", @ChangeHandler( ), 0, #Null, 0)
      g_signal_connect_( GadgetID(gadget), "event", @signal_event( ), gadget )
   EndProcedure
   
   ;-
   ;    Procedure.i WaitEvent( event.i, second.i = 0 )
   ;       ProcedureReturn event
   ;    EndProcedure
   
   Procedure   SetCallBack( *callback )
      
   EndProcedure
EndModule
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 30
; FirstLine = 10
; Folding = --
; EnableXP