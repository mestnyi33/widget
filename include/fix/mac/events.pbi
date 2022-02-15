;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  CompilerIf #PB_Compiler_IsMainFile
    DeclareModule constants
      Enumeration #PB_EventType_FirstCustomValue
        #PB_EventType_Repaint
        #PB_EventType_Drop
      EndEnumeration
    EndDeclareModule
    Module constants
    EndModule
  CompilerEndIf
  
  DeclareModule events
    EnableExplicit
    
    Structure s_GADGET
      *entered
      *pressed
      *dragged
      *focused
    EndStructure
    
    Macro CanvasMouseX( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      DesktopMouseX( ) - GadgetX( _canvas_, _mode_ )
      ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
    EndMacro
    
    Macro CanvasMouseY( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      DesktopMouseY( ) - GadgetY( _canvas_, _mode_ )
      ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
    EndMacro
    
    Global *gadget.s_GADGET = AllocateStructure( s_GADGET )
    Macro DraggedGadget( ) : *gadget\dragged : EndMacro
    Macro EnteredGadget( ) : *gadget\entered : EndMacro
    Macro FocusedGadget( ) : *gadget\focused : EndMacro
    Macro PressedGadget( ) : *gadget\pressed : EndMacro
    
    DraggedGadget( ) =- 1 
    EnteredGadget( ) =- 1 
    PressedGadget( ) =- 1 
    FocusedGadget( ) =- 1 
    
    Declare.i WaitEvent( *callback, event.i )
  EndDeclareModule 
  
  Module events
    UseModule constants
    
    Import ""
      PB_Window_GetID(hWnd) 
    EndImport
    
    Procedure.s GetClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      
      If Result
        ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
      EndIf
    EndProcedure
    
    Procedure IDWindow(Handle)
      ProcedureReturn PB_Window_GetID(Handle)
    EndProcedure
    
    Procedure IDGadget(Handle)
      ProcedureReturn CocoaMessage(0, Handle, "tag")
    EndProcedure
    
    Procedure GetAtPointWindow( )
      Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
      
      ; get-WindowNumber
      CocoaMessage(@Point, 0, "NSEvent mouseLocation")
      WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
      
      ; get-NSWindow
      NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
      NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
      
      ProcedureReturn NSWindow
    EndProcedure
    
    Procedure GetAtPointGadget( NSWindow )
      Protected handle, superview
      
      If NSWindow
        Protected.i ContentView, NSApp, WindowNumber, Point.CGPoint
        CocoaMessage(@Point, NSWindow, "mouseLocationOutsideOfEventStream")
        ContentView = CocoaMessage(0, NSWindow, "contentView")
        handle = CocoaMessage(0, ContentView, "hitTest:@", @Point)
        
        If handle
          Select GetClassName( handle )
            Case "NSStepper" 
              handle = CocoaMessage( 0, handle, "superview" ) ; PB_SpinView
              
              Debug " ---- "+ GetClassName( handle )
          
            Case "NSTableHeaderView" 
              handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
             
            Case "NSScroller" 
              handle = CocoaMessage( 0, handle, "superview" ) ; NSScrollView , PBScrollView
                  
              Select GetClassName( handle ) 
                Case "WebDynamicScrollBarsView"
                  handle = CocoaMessage( 0, handle, "superview" ) ; WebFrameView
                  handle = CocoaMessage( 0, handle, "superview" ) ; PB_WebView
                  
                Case "PBTreeScrollView"
                  handle = CocoaMessage(0, handle, "documentView")
                  
                Case "NSScrollView"
                  superview = CocoaMessage( 0, handle, "superview" )
                  If GetClassName( superview ) = "PBScintillaView"
                    handle = superview ; PBScintillaView
                  Else
                    handle = CocoaMessage(0, handle, "documentView")
                  EndIf
                  
              EndSelect
              
            Case "_NSRulerContentView", "SCIContentView" 
              handle = CocoaMessage( 0, handle, "superview" ) ; NSClipView
              handle = CocoaMessage( 0, handle, "superview" ) ; NSScrollView
              handle = CocoaMessage( 0, handle, "superview" ) ; PBScintillaView
            
            Case "NSView" 
              handle = CocoaMessage( 0, handle, "superview" ) ; PB_NSBox
              
            Case "NSTextField", "NSButton"
              handle = CocoaMessage( 0, handle, "superview" ) ; PB_DateView
          
            Case "WebHTMLView" 
              handle = CocoaMessage( 0, handle, "superview" ) ; WebClipView
              handle = CocoaMessage( 0, handle, "superview" ) ; WebDynamicScrollBarsView
              handle = CocoaMessage( 0, handle, "superview" ) ; WebFrameView
              handle = CocoaMessage( 0, handle, "superview" ) ; PB_WebView
             
            Case "PB_NSFlippedView" 
              ; container
              handle = CocoaMessage( 0, handle, "superview" ) ; NSClipView
              ; scrollarea
              If GetClassName( handle ) = "NSClipView"
                handle = CocoaMessage( 0, handle, "superview" ) ; PBScrollView
              EndIf
          EndSelect
        EndIf
       EndIf
      
      ProcedureReturn handle
    EndProcedure
    
    ; pb-bug-fix
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
      
      Global psn.q, mask, eventTap, key.s
      
      ImportC ""
        CFRunLoopGetCurrent()
        CFRunLoopAddCommonMode(rl, mode)
        
        GetCurrentProcess(*psn)
        CGEventTapCreateForPSN(*psn, place, options, eventsOfInterest.q, callback, refcon)
      EndImport
      
      ;       Procedure WindowNumber( WindowID )
      ;         ProcedureReturn CocoaMessage(0, WindowID, "windowNumber")
      ;       EndProcedure
      ;       
      ;       Procedure NSWindow( NSApp, WindowNumber )
      ;         ProcedureReturn CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
      ;       EndProcedure
      
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
          Protected EnteredID = GetAtPointGadget( NSWindow )
          If EnteredID
            event_gadget = IDGadget( EnteredID )
            If IsGadget( event_gadget )
              PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
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
          If event_window >= 0 And event_gadget =- 1
            event_window =- 1
          EndIf
        EndIf
      EndProcedure
      
      eventTap = CGEventTapCreateForPSN(@psn, 0, 1, mask, @eventTapFunction(), 0)
      If eventTap
        CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
      EndIf
      
    CompilerEndIf
    
    Procedure.i WaitEvent( *callback, event.i )
      If Not *callback
        ProcedureReturn 0
      EndIf
      
      Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY
      Protected MouseMove, MouseX, MouseY, MoveStart
      Protected EnteredID, Canvas =- 1, EventType =- 1
      
      If MouseDrag Or Event( ) = #PB_Event_Gadget
        EventType = EventType( )
        
        If EventType = #PB_EventType_LeftButtonDown
          MouseDrag = 1
        EndIf
        
        If EventType = #PB_EventType_LeftButtonUp
          If EnteredGadget( ) >= 0 
            If MouseDrag > 0 And PressedGadget( ) = DraggedGadget( ) 
              CompilerIf Defined( constants, #PB_Module )
                CallCFunctionFast( *callback, EnteredGadget( ), #PB_EventType_Drop )
              CompilerEndIf
            EndIf
          EndIf
          MouseDrag = 0
        EndIf
        
        If MouseDrag >= 0
          EnteredID = GetAtPointGadget( GetAtPointWindow( ) )
        EndIf
        
        ;
        If EnteredID
          Canvas = IDGadget( EnteredID )
          ;Debug ""+Canvas +" "+ EnteredID +" "+ NSView(EnteredID) +" "+ CocoaMessage( 0, EnteredID, "superview" ) +" "+ GadgetID(2)
          
          If Canvas >= 0
            Mousex = CanvasMouseX( Canvas )
            Mousey = CanvasMouseY( Canvas )
          Else
            Mousex =- 1
            Mousey =- 1
          EndIf
        Else
          Mousex =- 1
          Mousey =- 1
        EndIf
        
        ;
        If MouseDrag And
           Mousex =- 1 And Mousey =- 1
          If PressedGadget( ) >= 0
            Mousex = CanvasMouseX( PressedGadget( ) )
            Mousey = CanvasMouseY( PressedGadget( ) )
          EndIf
        EndIf
        
        If MouseMoveX <> Mousex
          MouseMoveX = Mousex
          MouseMove = #True
        EndIf
        
        If MouseMoveY <> Mousey
          MouseMoveY = Mousey
          MouseMove = #True
        EndIf
        
        ;
        If MouseMove 
          If MouseDrag >= 0 And 
             EnteredGadget( ) <> Canvas
            If EnteredGadget( ) >= 0
              CallCFunctionFast( *callback, EnteredGadget( ) , #PB_EventType_MouseLeave )
            EndIf
            
            EnteredGadget( ) = Canvas
            
            If EnteredGadget( ) >= 0
              CallCFunctionFast( *callback, EnteredGadget( ), #PB_EventType_MouseEnter )
            EndIf
          Else
            ; mouse drag start
            If MouseDrag > 0
              If DraggedGadget( ) <> PressedGadget( )
                DraggedGadget( ) = PressedGadget( )
                CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_DragStart )
                DeltaX = GadgetX( PressedGadget( ) ) 
                DeltaY = GadgetY( PressedGadget( ) )
              EndIf
            EndIf
            
            If EnteredGadget( ) <> PressedGadget( ) And MouseDrag
              CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_MouseMove )
            EndIf
            
            If EnteredGadget( ) >= 0
              CallCFunctionFast( *callback, EnteredGadget( ), #PB_EventType_MouseMove )
              If MouseDrag > 0 And PressedGadget( ) = EnteredGadget( ) 
                If DeltaX <> GadgetX( PressedGadget( ) ) Or 
                   DeltaY <> GadgetY( PressedGadget( ) )
                  MouseDrag =- 1
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        ;
        If EventType = #PB_EventType_LeftButtonDown
          PressedGadget( ) = EnteredGadget( ) ; EventGadget( )
          
          If FocusedGadget( ) =- 1
            FocusedGadget( ) = GetActiveGadget( )
            If GadgetType( FocusedGadget( ) ) = #PB_GadgetType_Canvas
              CallCFunctionFast( *callback, FocusedGadget( ), #PB_EventType_Focus )
            EndIf
          EndIf
          
          If FocusedGadget( ) >= 0 And 
             FocusedGadget( ) <> PressedGadget( )
            CallCFunctionFast( *callback, FocusedGadget( ), #PB_EventType_LostFocus )
            
            FocusedGadget( ) = PressedGadget( )
            CallCFunctionFast( *callback, FocusedGadget( ), #PB_EventType_Focus )
          EndIf
          
          If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < 160 )
            CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_LeftButtonDown )
            LeftClick = 1
            ClickTime = 0
          EndIf
        EndIf
        
        ;
        If EventType = #PB_EventType_LeftButtonUp
          If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < DoubleClickTime( ) )
            If LeftClick 
              LeftClick = 0
              
              CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_LeftButtonUp )
              
              If PressedGadget( ) <> DraggedGadget( )
                If PressedGadget( ) >= 0 And EnteredID = GadgetID( PressedGadget( ) )
                  CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_LeftClick )
                EndIf
              EndIf
            Else
              If PressedGadget( ) <> DraggedGadget( )
                CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_LeftDoubleClick )
              EndIf
            EndIf
            
            ClickTime = ElapsedMilliseconds( )
          Else
            If PressedGadget( ) <> DraggedGadget( )
              CallCFunctionFast( *callback, PressedGadget( ), #PB_EventType_LeftDoubleClick )
            EndIf
            ClickTime = 0
          EndIf
          ;
          DraggedGadget( ) =- 1
        EndIf
        
        
        If EventType = #PB_EventType_Resize
          CallCFunctionFast( *callback, EventGadget( ), #PB_EventType_Resize )
        EndIf
        CompilerIf Defined( constants, #PB_Module )
          If EventType = #PB_EventType_Repaint
            CallCFunctionFast( *callback, EventGadget( ), #PB_EventType_Repaint )
          EndIf
        CompilerEndIf
      EndIf
      
      ProcedureReturn event
    EndProcedure
    
  EndModule 
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  UseModule constants
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
    Protected window = EventWindow()
    Protected dropx, dropy
    Static deltax, deltay
    
    Select eventtype
      Case #PB_EventType_DragStart
        deltax = CanvasMouseX( gadget, #PB_Gadget_WindowCoordinate )
        deltay = CanvasMouseY( gadget, #PB_Gadget_WindowCoordinate )
        Debug ""+Gadget + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
        
      Case #PB_EventType_Drop
        dropx = CanvasMouseX( gadget, #PB_Gadget_ScreenCoordinate )
        dropy = CanvasMouseY( gadget, #PB_Gadget_ScreenCoordinate )
        Debug ""+Gadget + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
        
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
        Debug ""+Gadget + " #PB_EventType_MouseEnter " 
        DrawCanvasFrame( gadget, $2C70F5)
        
      Case #PB_EventType_MouseLeave
        Debug ""+Gadget + " #PB_EventType_MouseLeave " 
        DrawCanvasFrame( gadget, 0 )
        
      Case #PB_EventType_MouseMove
        ; Debug ""+Gadget + " #PB_EventType_MouseMove " 
        If DraggedGadget( ) = 1
          ResizeGadget( DraggedGadget( ), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        
    EndSelect
  EndProcedure
  
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu)
  CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container);|#PB_Canvas_DrawFocus)
                                                        ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )
  
;   Debug GadgetID(1)
;   Debug GadgetID(11)
;   Debug GadgetID(2)
  
  Repeat 
    event = WaitEvent( @EventHandler( ), WaitWindowEvent( ) )
    
;     If event = #PB_Event_Gadget
;       ;       If EventType() = #PB_EventType_Focus
;       ;         Debug ""+EventGadget() + " #PB_EventType_Focus "
;       ;       EndIf
;       ;       If EventType() = #PB_EventType_LostFocus
;       ;         Debug "  "+EventGadget() + " #PB_EventType_LostFocus "
;       ;       EndIf
;       ;       
;       ;       If EventType() = #PB_EventType_LeftButtonDown
;       ;         Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
;       ;       EndIf
;       ;       If EventType() = #PB_EventType_LeftButtonUp
;       ;         Debug "  "+EventGadget() + " #PB_EventType_LeftButtonUp "
;       ;       EndIf
;       ;       
;       ;       If EventType() = #PB_EventType_Change
;       ;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
;       ;       EndIf
;       ;       If EventType() = #PB_EventType_MouseEnter
;       ;         Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData() +" "+ GetActiveWindow( )
;       ;       EndIf
;       ;       If EventType() = #PB_EventType_MouseLeave
;       ;         Debug "  "+EventGadget() + " #PB_EventType_MouseLeave "
;       ;       EndIf
;     EndIf
;     
; ;     If event = #PB_Event_GadgetDrop
; ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_GadgetDrop "
; ;     EndIf
; ;     ;     If event = #PB_Event_Repaint
; ;     ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_Repaint "
; ;     ;     EndIf
; ;     ;     If event = #PB_Event_LeftClick
; ;     ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_LeftClick "
; ;     ;     EndIf
; ;     ;     If event = #PB_Event_RightClick
; ;     ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_RightClick "
; ;     ;     EndIf
; ;     ;     If event = #PB_Event_ActivateWindow
; ;     ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_ActivateWindow "
; ;     ;     EndIf
; ;     ;     If event = #PB_Event_DeactivateWindow
; ;     ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_DeactivateWindow "
; ;     ;     EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---------------
; EnableXP