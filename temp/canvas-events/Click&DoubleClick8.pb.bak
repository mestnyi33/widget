Global NewMap IDGadget( )

Macro PB(Function)
  Function
EndMacro

Procedure EnterID( ) 
  Protected handle
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      Protected EnterGadgetID, GadgetID
      Protected Cursorpos.q
      
      GetCursorPos_( @Cursorpos )
      handle = WindowFromPoint_( Cursorpos )
      ScreenToClient_(handle, @Cursorpos) 
      GadgetID = ChildWindowFromPoint_( handle, Cursorpos )
      
      GetCursorPos_( @Cursorpos )
      handle = GetAncestor_( handle, #GA_ROOT )
      ScreenToClient_(handle, @Cursorpos) 
      handle = ChildWindowFromPoint_( handle, Cursorpos )
      
      If IsGadget( GetDlgCtrlID_( GadgetID )) 
        If GadgetID = GadgetID( GetDlgCtrlID_( GadgetID ))
          handle = GadgetID
        Else
          ; SpinGadget
          If GetWindow_( GadgetID, #GW_HWNDPREV ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            EndIf
            handle = GetWindow_( GadgetID, #GW_HWNDPREV)
            
          ElseIf GetWindow_( GadgetID, #GW_HWNDNEXT ) = GadgetID( GetDlgCtrlID_( GadgetID ))
            If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
              SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
            EndIf
            handle = GetWindow_( GadgetID, #GW_HWNDNEXT)
          EndIf
        EndIf
      Else
        If GetParent_( GadgetID )
          handle = GetParent_( GadgetID ) ; С веб гаджетом проблемы
                                          ;Debug handle ; 
        EndIf
      EndIf
      
      ; SplitterGadget( ) 
      Protected RealClass.S = Space(13) 
      GetClassName_( GetParent_( handle ), @RealClass, Len( RealClass ))
      If RealClass.S = "PureSplitter" 
        handle = GetParent_( handle ) 
      EndIf
      
      ;Debug handle
      ProcedureReturn handle
      
    CompilerCase #PB_OS_MacOS
      Protected win_id, win_cv, pt.NSPoint
      win_id = WindowID(EventWindow( ))
      win_cv = CocoaMessage(0, win_id, "contentView")
      CocoaMessage(@pt, win_id, "mouseLocationOutsideOfEventStream")
      handle = CocoaMessage(0, win_cv, "hitTest:@", @pt)
      ProcedureReturn handle
      
    CompilerCase #PB_OS_Linux
      Protected desktop_x, desktop_y, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
      If *GdkWindow
        gdk_window_get_user_data_( *GdkWindow, @handle )
        ; handle = *GdkWindow\user_data ; Начиная с PB 5.40, * GdkWindow.GdkWindowObject \ user_data больше не содержит GtkWindow или является неверным
        ProcedureReturn handle
      EndIf
      
  CompilerEndSelect
  
EndProcedure    

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  ; bug when clicking on the canvas in an inactive window
  #LeftMouseDownMask      = 1 << 1
  #LeftMouseUpMask        = 1 << 2
  ; #RightMouseDownMask     = 1 << 3
  ; #RightMouseUpMask       = 1 << 4
  #MouseMovedMask         = 1 << 5
  ; #LeftMouseDraggedMask   = 1 << 6
  ; #RightMouseDraggedMask  = 1 << 7
  ; #KeyDownMask            = 1 << 10
  ; #KeyUpMask              = 1 << 11
  ; #FlagsChangedMask       = 1 << 12
  ; #ScrollWheelMask        = 1 << 22
  ; #OtherMouseDownMask     = 1 << 25
  ; #OtherMouseUpMask       = 1 << 26
  ; #OtherMouseDraggedMask  = 1 << 27
  
  Global psn.q, mask, eventTap, key.s
  
  ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
  EndImport
  
  GetCurrentProcess(@psn.q)
  
  mask = #LeftMouseDownMask | #LeftMouseUpMask | #MouseMovedMask ;| 1 << 8 | 1 << 9 ; 
                                                                 ; mask | #RightMouseDownMask | #RightMouseUpMask
                                                                 ; mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
                                                                 ; mask | #KeyDownMask
  
  ;       ;
  ;       ; callback function
  ;       ;
  ProcedureC eventTapFunction(proxy, type, event, refcon)
    Static event_window =- 1
    Static event_gadget =- 1
    
    Static lastView
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    
    If NSEvent
      Protected  Window = CocoaMessage(0, NSEvent, "window")
      
      If Window
        Protected Point.NSPoint
        CocoaMessage(@Point, NSEvent, "locationInWindow")
        Protected contentView = CocoaMessage(0, Window, "contentView")
        
        Protected View = CocoaMessage(0, contentView, "hitTest:@", @Point)
      EndIf
    EndIf           
    
    If type = 1 ; 1 << type = #LeftMouseDownMask ; LeftButtonDown
      If GetActiveWindow( ) <> EventWindow( ) 
        
        If FindMapElement( IDGadget( ), Str(View) )
          event_window = EventWindow( )
          event_gadget = IDGadget( )
          Debug " ---  fixmePB --- "+#PB_Compiler_Procedure +"( )"
          
          PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown, NSEvent )
        EndIf
      EndIf
      
    ElseIf type = 2 ; 1 << type = #LeftMouseUpMask ; LeftButtonUp
      If IsWindow( event_window )
        PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp, NSEvent )
        event_window =- 1
        event_gadget =- 1
      EndIf
      
      ; bug mouse enter 
    ElseIf type = 5 Or type = 8 Or type = 9 ; 1 << type = #MouseMovedMask ; MouseMove
      
      If lastView <> View 
        If lastView And FindMapElement( IDGadget( ), Str(lastView) )
          PostEvent( #PB_Event_Gadget, EventWindow(), IDGadget( ), #PB_EventType_MouseLeave, 0 )
          ;Debug ""+IDGadget( ) + " #PB_EventType_MouseLeave " 
        EndIf
        
        lastView = View 
        If FindMapElement( IDGadget( ), Str(View) )
          PostEvent( #PB_Event_Gadget, EventWindow(), IDGadget( ), #PB_EventType_MouseEnter, 0 )
          ;Debug ""+IDGadget( ) + " #PB_EventType_MouseEnter " 
        EndIf
      EndIf
      
    EndIf
  EndProcedure
  
  eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
  EndIf
  
CompilerEndIf

Procedure is_double_click( _event_type_ )
  Static time_click
  
  If _event_type_ = #PB_EventType_LeftButtonDown
    If Not ( time_click And ElapsedMilliseconds( ) - time_click < 160 )
      time_click = 0
      ProcedureReturn 0
    EndIf
  EndIf
  
  If _event_type_ = #PB_EventType_LeftButtonUp
    If Not ( time_click And ElapsedMilliseconds( ) - time_click < DoubleClickTime( ) )
      time_click = ElapsedMilliseconds( )
      ProcedureReturn 0
    Else
      time_click = 0
    EndIf
  EndIf
  
  ProcedureReturn 1
EndProcedure


Macro CanvasGadget(gadget, x,y,width,height, flag=0 )
  IDGadget( Str(PB(CanvasGadget)(gadget, x,y,width,height, flag )) ) = gadget
EndMacro

OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
CanvasGadget(1, 10, 10, 200, 200)
CanvasGadget(2, 110, 110, 200, 200)

OpenWindow(3, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(3, 10, 10, 200, 200)

Define PressedGadgetID
Repeat 
  event = WaitWindowEvent( )
  
  If event = #PB_Event_Gadget
    If EventType( ) = #PB_EventType_LeftButtonDown
      PressedGadgetID = GadgetID( EventGadget() )
      
      If Not is_double_click( EventType( ) ) 
        Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "+EventData( )
      EndIf
    EndIf
    
    If EventType( ) = #PB_EventType_LeftButtonUp
      If Not is_double_click( EventType( ) )
        ; do up events
        Debug ""+EventGadget( ) + " #PB_EventType_LeftButtonUp "
        
        If PressedGadgetID = EnterID( ) 
          ; do one-click events
          Debug ""+EventGadget( ) + " #PB_EventType_LeftClick"
        EndIf
      Else
        ; do double-click events 
        Debug ""+EventGadget( ) + " #PB_EventType_LeftDoubleClick"
      EndIf
    EndIf
    
    If Not ( EventData( ) And #PB_Compiler_OS = #PB_OS_MacOS )
      If EventType( ) = #PB_EventType_MouseEnter
        Debug ""+EventGadget( ) + " #PB_EventType_MouseEnter " 
      EndIf
      If EventType( ) = #PB_EventType_MouseLeave
        Debug ""+EventGadget( ) + " #PB_EventType_MouseLeave " 
      EndIf
    EndIf
    
  EndIf
Until event = #PB_Event_CloseWindow

;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
;   2 #PB_EventType_LeftDoubleClick 

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 0--v---
; EnableXP