
Enumeration
  #WINDOW
  #OBJECT
EndEnumeration


CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux 
    ImportC ""
      gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
      gdk_event_get_scroll_direction( *Event, *direction )
    EndImport
    ImportC ""
      gtk_widget_is_composited(*widget.GtkWidget)
      gtk_widget_set_opacity(*window.GtkWindow, opacity.d)
      gtk_scale_clear_marks(*scale.GtkScale)
      gtk_scale_add_mark(*scale.GtkScale, value.d, position.i, *markup)
      gtk_range_get_value.d(*range.GtkRange)
      gtk_adjustment_set_lower(*adjustment.GtkAdjustment, lower.d)
      gtk_adjustment_set_value(*adjustment.GtkAdjustment, value.d)
      g_signal_connect(*instance, detailed_signal.p-utf8, *c_handler, *data, destroy= 0, flags= 0) As "g_signal_connect_data"
    EndImport

    ProcedureC MouseWheelCallback( *event.GdkEventMotion, user_data ) ; GdkEventAny
      Protected.d delta_x, delta_y
      Protected *object.GtkWidget = user_data
      
      Protected *eventScroll.GdkEventScroll = *event
      Protected *eventButton.GdkEventButton = *Event
      
      If *event\type = #GDK_SCROLL
        gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
        
        ;         Protected direction
        ;         gdk_event_get_scroll_direction( *Event, @direction )
        ;         Debug direction
        
        Debug "wheel "+*eventScroll\direction +" "+ delta_x +" "+delta_y ;+" "+ gtk_range_get_value(*object)
        
        ;         Select *event\direction
        ;           Case #GDK_SCROLL_LEFT
        ;             Debug "wheel left "+delta_x
        ;           Case #GDK_SCROLL_RIGHT
        ;             Debug "wheel right "+delta_x
        ;           Case #GDK_SCROLL_UP
        ;             Debug "wheel up "+delta_y
        ;           Case #GDK_SCROLL_DOWN
        ;             Debug "wheel down "+delta_y +" "+*event\y
        ;         EndSelect
      EndIf
      
      
      
;       Select *Event\type
;         Case #GDK_DELETE
;           Debug "Event: GDK_DELETE: 0 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DESTROY
;           Debug "Event: GDK_DESTROY: 1 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_EXPOSE ; огда перерисовываем наше окно
;           Debug "Event: GDK_EXPOSE: 2 " + Str(*Event\type) + " user_data: " + *object\name ; Str(user_data)
;           ; ;     Case #GDK_BUTTON_MOTION_MASK
;           ; ;         Debug "Event: GDK_MOTION_NOTIFY: 3 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_MOTION_NOTIFY
;           ; Debug "Event: GDK_MOTION_NOTIFY: 3 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_BUTTON_PRESS
;           Debug "Event: GDK_BUTTON_PRESS: 4 " + Str(*eventButton\button) + " user_data: " + Str(user_data)
;         Case #GDK_2BUTTON_PRESS
;           Debug "Event: GDK_2BUTTON_PRESS: 5 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_3BUTTON_PRESS
;           Debug "Event: GDK_3BUTTON_PRESS: 6 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_BUTTON_RELEASE
;           Debug "Event: GDK_BUTTON_RELEASE: 7 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_KEY_PRESS
;           Debug "Event: GDK_KEY_PRESS: 8 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_KEY_RELEASE
;           Debug "Event: GDK_KEY_RELEASE: 9 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_ENTER_NOTIFY
;           Debug "Event: GDK_ENTER_NOTIFY: 10 " + *Widget +" "+ Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_LEAVE_NOTIFY
;           Debug "Event: GDK_LEAVE_NOTIFY: 11 " + *Widget +" "+ Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_FOCUS_CHANGE
;           Debug "Event: GDK_FOCUS_CHANGE: 12 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_CONFIGURE
;           Debug "Event: GDK_CONFIGURE: 13 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_MAP
;           Debug "Event: GDK_MAP: 14 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_UNMAP
;           Debug "Event: GDK_UNMAP: 15 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_PROPERTY_NOTIFY
;           Debug "Event: GDK_PROPERTY_NOTIFY: 16 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_SELECTION_CLEAR
;           Debug "Event: GDK_SELECTION_CLEAR: 17 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_SELECTION_REQUEST
;           Debug "Event: GDK_SELECTION_REQUEST: 18 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_SELECTION_NOTIFY
;           Debug "Event: GDK_SELECTION_NOTIFY: 19 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_PROXIMITY_IN
;           Debug "Event: GDK_PROXIMITY_IN: 20 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_PROXIMITY_OUT
;           Debug "Event: GDK_PROXIMITY_OUT: 21 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DRAG_ENTER
;           Debug "Event: GDK_DRAG_ENTER: 22 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DRAG_LEAVE
;           Debug "Event: GDK_DRAG_LEAVE: 23 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DRAG_MOTION
;           Debug "Event: GDK_DRAG_MOTION: 24 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DRAG_STATUS
;           Debug "Event: GDK_DRAG_STATUS: 25 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DROP_START
;           Debug "Event: GDK_DROP_START: 26 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_DROP_FINISHED
;           Debug "Event: GDK_DROP_FINISHED: 27 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_CLIENT_EVENT
;           Debug "Event: GDK_CLIENT_EVENT: 28 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_VISIBILITY_NOTIFY
;           Debug "Event: GDK_VISIBILITY_NOTIFY: 29 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_NO_EXPOSE
;           Debug "Event: GDK_NO_EXPOSE: 30 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_SCROLL
;           Debug "Event: GDK_SCROLL: 31 " + Str(*Event\type) + " user_data: " + Str(user_data)
;         Case #GDK_WINDOW_STATE
;           Debug "Event: GDK_WINDOW_STATE: 32 " + Str(*Event\type) + " user_data: " + Str(user_data)
;       EndSelect
; ;       
;       Select *event\type
;     Case #GTK_SCROLL_NONE: Debug "#GTK_SCROLL_NONE"
;     Case #GTK_SCROLL_JUMP: Debug "#GTK_SCROLL_JUMP"
;     Case #GTK_SCROLL_STEP_BACKWARD: Debug "#GTK_SCROLL_STEP_BACKWARD"
;     Case #GTK_SCROLL_STEP_FORWARD: Debug "#GTK_SCROLL_STEP_FORWARD"
;     Case #GTK_SCROLL_PAGE_BACKWARD: Debug "#GTK_SCROLL_PAGE_BACKWARD"
;     Case #GTK_SCROLL_PAGE_FORWARD: Debug "#GTK_SCROLL_PAGE_FORWARD"
;     Case #GTK_SCROLL_STEP_UP: Debug "#GTK_SCROLL_STEP_UP"
;     Case #GTK_SCROLL_STEP_DOWN: Debug "#GTK_SCROLL_STEP_DOWN"
;     Case #GTK_SCROLL_PAGE_UP: Debug "#GTK_SCROLL_PAGE_UP"
;     Case #GTK_SCROLL_PAGE_DOWN: Debug "#GTK_SCROLL_PAGE_DOWN"
;     Case #GTK_SCROLL_STEP_LEFT: Debug "#GTK_SCROLL_STEP_LEFT"
;     Case #GTK_SCROLL_STEP_RIGHT: Debug "#GTK_SCROLL_STEP_RIGHT"
;     Case #GTK_SCROLL_PAGE_LEFT: Debug "#GTK_SCROLL_PAGE_LEFT"
;     Case #GTK_SCROLL_PAGE_RIGHT: Debug "#GTK_SCROLL_PAGE_RIGHT"
;     Case #GTK_SCROLL_START: Debug "#GTK_SCROLL_START"
;     Case #GTK_SCROLL_END: Debug "#GTK_SCROLL_END"
;   EndSelect
;  
      gtk_main_do_event_(*event)
    EndProcedure
    
  CompilerCase #PB_OS_MacOS 
    Define MachPort.I
    #kCGEventTapOptionListenOnly = 1
    #kCGHeadInsertEventTap = 0
    #NX_SCROLLWHEELMOVED = 22
    #NX_SCROLLWHEELMOVEDMASK = 1 << #NX_SCROLLWHEELMOVED
    
    ImportC ""
      CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.I, CGEventTapOptions.I, CGEventMask.Q, CGEventTapCallback.I, *UserData)
      GetCurrentProcess(*ProcessSerialNumber)
    EndImport
    
    ProcedureC MouseWheelCallback(CGEventTapProxy.I, CGEventType.I, CGEvent.I,  *UserData)
      Protected DeltaY.CGFloat
      Protected NSEvent.I, contentView.I
      Protected Point.NSPoint
      
      NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", CGEvent)
      CocoaMessage(@Point, NSEvent, "locationInWindow")
      contentView = CocoaMessage(0, WindowID(#WINDOW), "contentView")
      
      If CocoaMessage(0, contentView, "hitTest:@", @Point) = GadgetID(#OBJECT)
        CocoaMessage(@DeltaY, NSEvent, "deltaY")
        
        If DeltaY < 0.0
          Debug "down"
        Else
          Debug "up"
        EndIf
      EndIf
    EndProcedure
    
  CompilerCase #PB_OS_Windows
    Define DefaultObjectCallback.I
    
    Procedure.w HIWORD(Value.L)
      ProcedureReturn (((Value) >> 16) & $FFFF)
    EndProcedure
    
    Procedure.w LOWORD(Value)
      ProcedureReturn ((Value) & $FFFF)
    EndProcedure
    
    Procedure MouseWheelCallback(Handle.I, Msg.I, WParam.I, LParam.I)
      Shared DefaultObjectCallback.I
      
      If Msg = #WM_MOUSEWHEEL
        If (WParam >> 16) & $8000
          Debug ""+Str(WParam >> 16) 
        Else         
          Debug ""+Str(WParam >> 16) 
        EndIf
        
      ElseIf Msg = #WM_MOUSEHWHEEL
        
      EndIf
      
      ProcedureReturn CallWindowProc_(DefaultObjectCallback, Handle, Msg, WParam, LParam)
    EndProcedure
CompilerEndSelect



Procedure FreeEventCallback( )
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      gdk_event_handler_set_(0, 0, 0)
    CompilerCase #PB_OS_MacOS
      CFRelease_( MachPort )
  CompilerEndSelect
EndProcedure

Procedure SetEventCallback( object )
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      ; gtk_widget_add_events_(object, #GDK_ALL_EVENTS_MASK)
      gdk_event_handler_set_( @MouseWheelCallback() , object, 0)
      ; g_signal_connect(object, "event", @MouseWheelCallback2(), object )  
                            
    CompilerCase #PB_OS_MacOS
      Shared MachPort.I
      Protected ProcessSerialNumber.Q
      
      GetCurrentProcess(@ProcessSerialNumber)
      MachPort = CGEventTapCreateForPSN(@ProcessSerialNumber,
                                        #kCGHeadInsertEventTap, #kCGEventTapOptionListenOnly,
                                        #NX_SCROLLWHEELMOVEDMASK,  @MouseWheelCallback() , 0)
      
      If MachPort
        CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), 
                     "addPort:", MachPort, "forMode:$", @"kCFRunLoopCommonModes")
      EndIf
    CompilerCase #PB_OS_Windows
      Shared DefaultObjectCallback.I 
      DefaultObjectCallback = GetWindowLongPtr_(object, #GWL_WNDPROC)
      SetWindowLongPtr_(object, #GWL_WNDPROC,  @MouseWheelCallback() )
  CompilerEndSelect
EndProcedure


; Open a Window
If OpenWindow(#WINDOW,0,0,600,400,"mouse wheel demo",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  SetWindowColor( #WINDOW, $ffff00)
  CanvasGadget(#OBJECT,10,10,580,380)
  
  SetEventCallback( GadgetID(#OBJECT) )
  
  SetActiveGadget(#OBJECT)    
  
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        FreeEventCallback( )
        Break
    EndSelect
  ForEver
  End
EndIf

; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 224
; FirstLine = 12
; Folding = ---
; EnableXP