;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule events
    
      Macro PB(Function)
        Function
      EndMacro
      
      Declare.i WaitEvent( *callback, event.i )
    EndDeclareModule 
  
  Module events
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ; bug when clicking on the canvas in an inactive window
      #LeftMouseDownMask      = 1 << 1
      #LeftMouseUpMask        = 1 << 2
      ; #RightMouseDownMask     = 1 << 3
      ; #RightMouseUpMask       = 1 << 4
       #MouseMovedMask         = 1 << 5
       #LeftMouseDraggedMask   = 1 << 6
      ; #RightMouseDraggedMask  = 1 << 7
      ; #KeyDownMask            = 1 << 10
      ; #KeyUpMask              = 1 << 11
      ; #FlagsChangedMask       = 1 << 12
      ; #ScrollWheelMask        = 1 << 22
      ; #OtherMouseDownMask     = 1 << 25
      ; #OtherMouseUpMask       = 1 << 26
      ; #OtherMouseDraggedMask  = 1 << 27
      
      Global PressedGadgetID,
           EnteredGadget =- 1,
           PressedGadget =- 1,
           DraggedGadget =- 1,
           FocusedGadget =- 1
    Global MouseX, MouseY, ClickTime
    Global psn.q, mask, eventTap, key.s
      
      ImportC ""
        CFRunLoopGetCurrent()
        CFRunLoopAddCommonMode(rl, mode)
        
        GetCurrentProcess(*psn)
        CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
      EndImport
      
      Import ""
        PB_Window_GetID(hWnd) 
      EndImport
      
;       Procedure.s GetClassName( handle.i )
;         Protected Result
;         CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
;         If Result
;           ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
;         EndIf
;       EndProcedure
;       
      Procedure IDWindow(Handle)
        ProcedureReturn PB_Window_GetID(Handle)
      EndProcedure
      
      Procedure IDGadget(Handle)
        ProcedureReturn CocoaMessage(0, Handle, "tag")
      EndProcedure
      
      Procedure EnteredID( NSWindow ) 
        Protected Point.NSPoint
        ; CocoaMessage(@Point, NSEvent, "locationInWindow")
        CocoaMessage(@Point, NSWindow, "mouseLocationOutsideOfEventStream")
        Protected contentView = CocoaMessage(0, NSWindow, "contentView")
        ProcedureReturn CocoaMessage(0, contentView, "hitTest:@", @Point)
      EndProcedure    
      
      GetCurrentProcess(@psn.q)
      
      mask = #LeftMouseDownMask | #LeftMouseUpMask | #LeftMouseDraggedMask ; | #MouseMovedMask ;| 1 << 8 | 1 << 9 ; 
      ; mask | #RightMouseDownMask | #RightMouseUpMask
      ; mask | #LeftMouseDraggedMask | #RightMouseDraggedMask
      ; mask | #KeyDownMask
      
      ;       ;
      ;       ; callback function
      ;       ;
      Global event_window =- 1
      Global event_gadget =- 1
      
      Procedure EventWindowActivate( )
        Protected NSWindow = WindowID( EventWindow( ) ) 
        If NSWindow
          Protected Point.NSPoint
          event_window = IDWindow( NSWindow )
          Protected EnteredID = EnteredID( NSWindow )
          If EnteredID
            event_gadget = IDGadget( EnteredID )
            If IsGadget( event_gadget )
              PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown, NSEvent )
              SetActiveGadget( event_gadget )
            EndIf
          EndIf
        EndIf
      EndProcedure
      
      BindEvent( #PB_Event_ActivateWindow, @EventWindowActivate( ) )
      
      ProcedureC eventTapFunction(proxy, type, event, refcon)
        If type = 1 ; 1 << type = #LeftMouseDownMask ; LeftButtonDown
          Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
          If NSEvent
            Protected NSWindow = CocoaMessage(0, NSEvent, "window")
            If NSWindow
              event_window = IDWindow( NSWindow )
            EndIf
          EndIf           
          
          If event_window = GetActiveWindow( )
            event_window =- 1
          EndIf
          
        ElseIf type = 2 ; 1 << type = #LeftMouseUpMask ; LeftButtonUp
          If IsWindow( event_window )
            If IsGadget( event_gadget )
              PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp, NSEvent )
              event_gadget =- 1
            Else
              PostEvent( #PB_Event_LeftClick , event_window, EventGadget( ), EventType( ), NSEvent )
            EndIf
            event_window =- 1
          EndIf
        ElseIf type = 6
          If event_window >= 0
            event_window =- 1
          EndIf
        EndIf
      EndProcedure
 
      eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
      If eventTap
        CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
      EndIf
      
     CompilerEndIf
     
     Macro CanvasMouseX( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      DesktopMouseX( ) - GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
    EndMacro
    
    Macro CanvasMouseY( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      DesktopMouseY( ) - GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
    EndMacro
    
    Procedure.i WaitEvent( *callback, event.i )
      Static down
      Protected EnteredID, MouseChange, MouseMove
      Protected Canvas =- 1, EventType =- 1, mouse_x, mouse_y
      
      If Not *callback
        ProcedureReturn 0
      EndIf
      
      If Event( ) = #PB_Event_Gadget Or PressedGadgetID
        ; Debug "event - "+event+" "+Event()
        EventType = EventType( )
        EnteredID = EnteredID( WindowID( EventWindow( ) ) )
        
        ;
        If EnteredID  
          Canvas = IDGadget( EnteredID )
          
          If EventType = #PB_EventType_MouseLeave
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              If EnteredGadget = Canvas And 
                 EnteredGadget = EventGadget( )
                MouseMove = 1
                Canvas =- 1
                ; Debug ""+Canvas +" "+ EventType +" "+ EventWindow() +" "+ EventGadget()
              EndIf
            CompilerEndIf
          EndIf
          
          If Canvas >= 0
            mouse_x = CanvasMouseX( Canvas )
            mouse_y = CanvasMouseY( Canvas )
          Else
            mouse_x =- 1
            mouse_y =- 1
          EndIf
          
          MouseChange = #True
        Else
          If EventType = #PB_EventType_MouseLeave
            ; Debug ""+EnteredID +" "+ Canvas +" "+ EventType +" "+ EventWindow() +" "+ EventGadget()
            MouseChange = 1
            Canvas =- 1
          EndIf
        EndIf
        
        ;
        If PressedGadgetID  
          mouse_x = CanvasMouseX( PressedGadget )
          mouse_y = CanvasMouseY( PressedGadget )
          
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
              CallCFunctionFast( *callback, PressedGadget, #PB_EventType_DragStart )
            EndIf
          EndIf
          
          If EnteredGadget <> Canvas 
            If EnteredGadget >= 0
              CallCFunctionFast( *callback, EnteredGadget , #PB_EventType_MouseLeave )
            EndIf
            
            EnteredGadget = Canvas
            
            If EnteredGadget >= 0
              CallCFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseEnter )
            EndIf
          Else
            If EnteredGadget <> PressedGadget And PressedGadgetID
              CallCFunctionFast( *callback, PressedGadget, #PB_EventType_MouseMove )
            EndIf
            
            If EnteredGadget >= 0
              CallCFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseMove )
            EndIf
          EndIf
          
        EndIf
        
        ;
        If EventType = #PB_EventType_LeftButtonDown
          PressedGadget = EventGadget( )
          If FocusedGadget =- 1
            FocusedGadget = GetActiveGadget( )
            If GadgetType( FocusedGadget ) = #PB_GadgetType_Canvas
              CallCFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
            EndIf
          EndIf
          
          If FocusedGadget >= 0 And 
             FocusedGadget <> PressedGadget
            CallCFunctionFast( *callback, FocusedGadget, #PB_EventType_LostFocus )
            
            FocusedGadget = PressedGadget
            CallCFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
          EndIf
          
          PressedGadgetID = GadgetID( PressedGadget )
          
          If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < 160 )
            down = 1
            CallCFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonDown )
            ClickTime = 0
          EndIf
        EndIf
        
        ;
        If EventType = #PB_EventType_LeftButtonUp
          If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < DoubleClickTime( ) )
            If PressedGadget = DraggedGadget
              ;           ; Debug EnteredID
              ;           If FindMapElement( IsEnableDrop( ), Str(EnteredID) )
              ;             ; EnteredGadget >= 0 And
              ;              DroppedGadget = EnteredGadget
              ;             
              ;             CallCFunctionFast( *callback, DroppedGadget, #PB_EventType_Drop )
              ;           EndIf
              DraggedGadget =- 1
            EndIf
            
            If down
              down = 0
              CallCFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonUp )
              
              If PressedGadget >= 0 And
                 EnteredID = GadgetID( PressedGadget )
                
                CallCFunctionFast( *callback, PressedGadget, #PB_EventType_LeftClick )
              EndIf
            Else
              CallCFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
            EndIf
            
            ClickTime = ElapsedMilliseconds( )
          Else
            CallCFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
            ClickTime = 0
          EndIf
          
          PressedGadgetID = 0
        EndIf
        
        
        If EventType = #PB_EventType_Resize
          CallCFunctionFast( *callback, EventGadget( ), #PB_EventType_Resize )
        EndIf
;         If EventType = #PB_EventType_Repaint
;           CallCFunctionFast( *callback, EventGadget( ), #PB_EventType_Repaint )
;         EndIf
        
      EndIf
      
      ProcedureReturn event
    EndProcedure
    
  EndModule 
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  UseModule events
  Define event
  
  Procedure DrawCanvasBack( gadget, color )
    StartDrawing( CanvasOutput( gadget ) )
    DrawingMode( #PB_2DDrawing_Default )
    Box( 0,0,OutputWidth( ), OutputHeight( ), color )
    StopDrawing( )
  EndProcedure
  
  Procedure DrawCanvasFrame( gadget, color )
    StartDrawing( CanvasOutput( gadget ) )
    If GetGadgetState( gadget )
      DrawImage( 0,0, GetGadgetState( gadget ) )
    EndIf
    If Not color
      color = Point( 10,10 )
    EndIf
    If color 
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( 0,0,OutputWidth( ), OutputHeight( ), color )
    EndIf
    StopDrawing( )
  EndProcedure
  
  Procedure EventHandler( gadget, eventtype )
    Select eventtype
        
      Case #PB_EventType_DragStart
        Debug ""+Gadget + " #PB_EventType_DragStart " 
;       Case #PB_EventType_Drop
;         Debug ""+Gadget + " #PB_EventType_Drop " 
      Case #PB_EventType_Focus
        Debug ""+Gadget + " #PB_EventType_Focus " 
        DrawCanvasBack( gadget, $FFA7A4)
        DrawCanvasFrame( gadget, $2C70F5)
      Case #PB_EventType_LostFocus
        Debug ""+Gadget + " #PB_EventType_LostFocus " 
        DrawCanvasBack( gadget, $FFFFFF)
      Case #PB_EventType_LeftButtonDown
        Debug ""+Gadget + " #PB_EventType_LeftButtonDown " 
      Case #PB_EventType_LeftButtonUp
        Debug ""+Gadget + " #PB_EventType_LeftButtonUp " 
      Case #PB_EventType_LeftClick
        Debug ""+Gadget + " #PB_EventType_LeftClick " 
      Case #PB_EventType_LeftDoubleClick
        Debug ""+Gadget + " #PB_EventType_LeftDoubleClick " 
      Case #PB_EventType_MouseEnter
        DrawCanvasFrame( gadget, $2C70F5)
        Debug ""+Gadget + " #PB_EventType_MouseEnter " 
      Case #PB_EventType_MouseLeave
        DrawCanvasFrame( gadget, 0 )
        Debug ""+Gadget + " #PB_EventType_MouseLeave " 
      Case #PB_EventType_MouseMove
        ; Debug ""+Gadget + " #PB_EventType_MouseMove " 
        
    EndSelect
  EndProcedure
  
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu)
  CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  
  Debug GadgetID(1)
  Debug GadgetID(11)
  Debug GadgetID(2)
  
  Repeat 
    event = WaitEvent( @EventHandler( ), WaitWindowEvent( ) )
    
    If event = #PB_Event_Gadget
;       If EventType() = #PB_EventType_Focus
;         Debug ""+EventGadget() + " #PB_EventType_Focus "
;       EndIf
;       If EventType() = #PB_EventType_LostFocus
;         Debug "  "+EventGadget() + " #PB_EventType_LostFocus "
;       EndIf
;       
;       If EventType() = #PB_EventType_LeftButtonDown
;         Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
;       EndIf
;       If EventType() = #PB_EventType_LeftButtonUp
;         Debug "  "+EventGadget() + " #PB_EventType_LeftButtonUp "
;       EndIf
;       
;       If EventType() = #PB_EventType_Change
;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
;       EndIf
;       If EventType() = #PB_EventType_MouseEnter
;         Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData() +" "+ GetActiveWindow( )
;       EndIf
;       If EventType() = #PB_EventType_MouseLeave
;         Debug "  "+EventGadget() + " #PB_EventType_MouseLeave "
;       EndIf
    EndIf
    
;     If event = #PB_Event_Repaint
;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_Repaint "
;     EndIf
;     If event = #PB_Event_LeftClick
;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_LeftClick "
;     EndIf
;     If event = #PB_Event_RightClick
;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_RightClick "
;     EndIf
;     If event = #PB_Event_ActivateWindow
;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_ActivateWindow "
;     EndIf
;     If event = #PB_Event_DeactivateWindow
;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_DeactivateWindow "
;     EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------
; EnableXP