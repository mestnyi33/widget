;Global NewMap IDGadget( )
Global NewMap IsEnableDDrop( )

Global PressedGadgetID = 0, MouseX =- 1, MouseY =- 1
Global EnteredGadget =- 1, PressedGadget =- 1, 
       DraggedGadget =- 1, DroppedGadget =- 1, lastEnteredID, time_click


Enumeration #PB_EventType_FirstCustomValue
  #PB_EventType_Drop
EndEnumeration

Macro PB(Function)
  Function
EndMacro

CompilerSelect #PB_Compiler_OS
    
  CompilerCase #PB_OS_Windows
    Procedure IDWindow(Handle)
      ProcedureReturn GetProp_(Handle, "pb_windowid") - 1
    EndProcedure
    
    Procedure IDGadget(Handle)
      ProcedureReturn GetProp_(Handle, "pb_id")
    EndProcedure
    
  CompilerCase #PB_OS_Linux
    
    Procedure IDWindow(Handle)
      ProcedureReturn g_object_get_data_(Handle, "pb_id" )
    EndProcedure
    
    Procedure IDGadget(Handle)
      ProcedureReturn g_object_get_data_(Handle, "pb_id" ) - 1 
    EndProcedure
      
  CompilerCase #PB_OS_MacOS
    
    Import ""
      PB_Window_GetID(hWnd) 
    EndImport
    
    Procedure IDWindow(Handle)
      ProcedureReturn PB_Window_GetID(Handle)
    EndProcedure
    
    Procedure IDGadget(Handle)
      ProcedureReturn CocoaMessage(0, Handle, "tag")
    EndProcedure
    
CompilerEndSelect

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
    
    If type = 1 ; 1 << type = #LeftMouseDownMask ; LeftButtonDown
      If GetActiveWindow( ) <> EventWindow( ) 
        Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        If NSEvent
          Protected Window = CocoaMessage(0, NSEvent, "window")
          If Window
            Protected Point.NSPoint
            CocoaMessage(@Point, NSEvent, "locationInWindow")
            Protected contentView = CocoaMessage(0, Window, "contentView")
            Protected View = IDGadget( CocoaMessage(0, contentView, "hitTest:@", @Point) )
          EndIf
        EndIf           
        
        If IsGadget( View )
          event_window = EventWindow( )
          event_gadget = View
          PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown, NSEvent )
        EndIf
      EndIf
      
    ElseIf type = 2 ; 1 << type = #LeftMouseUpMask ; LeftButtonUp
      If IsWindow( event_window )
        PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp, NSEvent )
        event_window =- 1
        event_gadget =- 1
      EndIf
    EndIf
  EndProcedure
  
  eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
  EndIf
  
CompilerEndIf

Macro GadgetMouseX( _canvas_ )
  ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
  DesktopMouseX( ) - GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate )
  ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
EndMacro

Macro GadgetMouseY( _canvas_ )
  ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
  DesktopMouseY( ) - GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate )
  ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
EndMacro

Procedure CanvasEvents( Gadget, EventType )
  Select EventType
      
    Case #PB_EventType_DragStart
      Debug ""+Gadget + " #PB_EventType_DragStart " 
    Case #PB_EventType_Drop
      Debug ""+Gadget + " #PB_EventType_Drop " 
    Case #PB_EventType_LeftButtonDown
      Debug ""+Gadget + " #PB_EventType_LeftButtonDown " 
    Case #PB_EventType_LeftButtonUp
      Debug ""+Gadget + " #PB_EventType_LeftButtonUp " 
    Case #PB_EventType_LeftClick
      Debug ""+Gadget + " #PB_EventType_LeftClick " 
    Case #PB_EventType_LeftDoubleClick
      Debug ""+Gadget + " #PB_EventType_LeftDoubleClick " 
    Case #PB_EventType_MouseEnter
      Debug ""+Gadget + " #PB_EventType_MouseEnter " 
    Case #PB_EventType_MouseLeave
      Debug ""+Gadget + " #PB_EventType_MouseLeave " 
    Case #PB_EventType_MouseMove
     ; Debug ""+Gadget + " #PB_EventType_MouseMove " 
    
  EndSelect
EndProcedure

Procedure DoCanvasEvents( event )
  Protected EnterID, MouseChange, MouseMove, Canvas
  
  If event ;= #PB_Event_Gadget Or event =- 1 
    ;    
    EnterID = EnterID( )
    
    ;
    If EnterID  
      Canvas = IDGadget( EnterID )
      
      If Canvas >= 0
        mouse_x = GadgetMouseX( Canvas )
        mouse_y = GadgetMouseY( Canvas )
      Else
        mouse_x =- 1
        mouse_y =- 1
      EndIf
      
      MouseChange = #True
    EndIf
    
    ;
    If PressedGadgetID  
      mouse_x = GadgetMouseX( PressedGadget )
      mouse_y = GadgetMouseY( PressedGadget )
      
      MouseChange = #True
    EndIf
    
    ;
    If MouseChange
      If MouseX <> mouse_x
        MouseX = mouse_x
        MouseMove = #True
      EndIf
      
      If MouseY <> mouse_y
        MouseY = mouse_y
        MouseMove = #True
      EndIf
    EndIf
    
    ;
    If MouseMove 
      If PressedGadgetID 
        ; mouse drag start
        If DraggedGadget <> PressedGadget
          DraggedGadget = PressedGadget
          
          CanvasEvents( PressedGadget, #PB_EventType_DragStart )
        EndIf
      EndIf
      
      If EnteredGadget <> Canvas 
        If EnteredGadget >= 0
          CanvasEvents( EnteredGadget , #PB_EventType_MouseLeave )
        EndIf
        
        EnteredGadget = Canvas
        
        If EnteredGadget >= 0
          CanvasEvents( EnteredGadget, #PB_EventType_MouseEnter )
        EndIf
      Else
        If EnteredGadget >= 0
          CanvasEvents( EnteredGadget, #PB_EventType_MouseMove )
        EndIf
        
        If EnteredGadget <> PressedGadget And PressedGadgetID
          CanvasEvents( PressedGadget, #PB_EventType_MouseMove )
        EndIf
      EndIf
      
    EndIf
    
    
    If event = #PB_Event_Gadget
      Protected EventType = EventType( )
      
      If EventType = #PB_EventType_LeftButtonDown
        PressedGadget = EventGadget( )
        PressedGadgetID = GadgetID( PressedGadget )
        
        If Not ( time_click And ElapsedMilliseconds( ) - time_click < 160 )
          time_click = 0
          
          CanvasEvents( PressedGadget, #PB_EventType_LeftButtonDown )
        EndIf
      EndIf
      
      If EventType = #PB_EventType_LeftButtonUp
        If Not ( time_click And ElapsedMilliseconds( ) - time_click < DoubleClickTime( ) )
          ;time_click = ElapsedMilliseconds( )
          
          If PressedGadget = DraggedGadget
            If IsGadget( EnteredGadget ) And
               FindMapElement( IsEnableDDrop( ), Str(EnteredGadget) )
              DroppedGadget = EnteredGadget
              
              CanvasEvents( DroppedGadget, #PB_EventType_Drop )
            EndIf
            DraggedGadget =- 1
          EndIf
          
          CanvasEvents( PressedGadget, #PB_EventType_LeftButtonUp )
        
          If IsGadget( PressedGadget ) And
             GadgetID( PressedGadget ) = EnterID
            
            CanvasEvents( PressedGadget, #PB_EventType_LeftClick )
          EndIf
        Else
          ;time_click = 0
          
          CanvasEvents( PressedGadget, #PB_EventType_LeftDoubleClick )
        EndIf
        
        time_click = ElapsedMilliseconds( )
        PressedGadgetID = 0
       
      EndIf
    EndIf
    
  EndIf
  
EndProcedure

Macro CanvasGadget(gadget, x,y,width,height, flag=0 )
  PB(CanvasGadget)(gadget, x,y,width,height, flag ) 
  IsEnableDDrop( Str( gadget ) ) = 1
EndMacro

OpenWindow(1, 200, 100, 320, 320, "click hire", #PB_Window_SystemMenu)
CanvasGadget(1, 10, 10, 200, 200)
CanvasGadget(2, 110, 110, 200, 200)

OpenWindow(3, 450, 200, 220, 220, "Canvas down/up", #PB_Window_SystemMenu)
CanvasGadget(3, 10, 10, 200, 200)

Repeat 
  event = WaitWindowEvent( )
  
  DoCanvasEvents( event )
  
Until event = #PB_Event_CloseWindow

;   2 #PB_EventType_LeftButtonDown 
;   2 #PB_EventType_LeftButtonUp 
;   2 #PB_EventType_LeftClick 
;   2 #PB_EventType_LeftDoubleClick 

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 370
; FirstLine = 338
; Folding = ----------
; EnableXP