ImportC ""
  gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
EndImport


ProcedureC ChangeHandler(*Scrollbar, *event.GdkEventScroll, value.d, user_data)
   Protected.d delta_x, delta_y
 	gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
    Debug ""+*event\direction +" "+ delta_x +" "+ delta_y +" "+ value
		
  ; display the scroll event
  Select *event\type
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
 
  
  ; move scrollbar 1 step forward regardless of the event
  ;SetGadgetState(0, GetGadgetState(0)+1)
  
  ; return #true to stop default processing
  ProcedureReturn #True
EndProcedure
  
  
If OpenWindow(0, 0, 0, 305, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0,  10, 42, 250,  200, #PB_Canvas_Border|#PB_Canvas_Container)
  g_signal_connect_data_(GadgetID(0), "scroll-event", @ChangeHandler(), 0, #Null, 0)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 40
; Folding = -
; EnableXP
; DPIAware