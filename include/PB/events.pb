CompilerIf #PB_Compiler_IsMainFile
  DeclareModule constants
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Drop
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
  EndDeclareModule
  Module constants
  EndModule
  
  ;XIncludeFile "../../modules.pbi"
  DeclareModule Get
    Declare.s ClassName( handle.i )
  EndDeclareModule
  Module Get
    Procedure.s ClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      If Result
        ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
      EndIf
    EndProcedure
  EndModule
  ;///
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
  EndDeclareModule
  Module ID
    ;   XIncludeFile "../import.pbi"
    Import ""
      PB_Window_GetID(hWnd) 
    EndImport
    
    Procedure.s ClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      
      If Result
        ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
      EndIf
    EndProcedure
    
    Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
      ProcedureReturn CocoaMessage( 0, handle, "window" )
    EndProcedure
    
    Procedure.i IsWindowID( handle.i )
      If ClassName( handle ) = "PBWindow"
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
      ProcedureReturn PB_Window_GetID( WindowID )
    EndProcedure
    
    Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
      ProcedureReturn CocoaMessage(0, GadgetID, "tag")
    EndProcedure
  EndModule
  ;///
  DeclareModule Mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
EndDeclareModule

Module Mouse
  Procedure Window( )
    Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
    
    ; get-WindowNumber
    CocoaMessage(@Point, 0, "NSEvent mouseLocation")
    WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
    
    ; get-NSWindow
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    ProcedureReturn NSWindow
  EndProcedure
  
  Macro GetCocoa( objectCocoa, funcCocoa, paramCocoa )
    CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  EndMacro
  
  Procedure Gadget( WindowID )
    Protected.i handle, superview, ContentView, Point.CGPoint
    
    If  WindowID 
      ContentView = CocoaMessage(0,  WindowID , "contentView")
      CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
      
      ;       ;func isMousePoint(_ point: NSPoint, in rect: NSRect ) -> Bool
      ;       Debug GetCocoa( ContentView, "isMousePoint", Point) 
      
      ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint
      handle = CocoaMessage(0, ContentView, "hitTest:@", @Point) ; hitTest(_:) 
                                                                 ;handle = GetCocoa( ContentView, "hitTest", Point) 
      
      If handle
        Select Get::ClassName( handle )
          Case "NSStepper" 
            ;handle = CocoaMessage(0, handle, "superclass") ; NSControl
            
            ; handle = CocoaMessage( 0, handle, "nextResponder" ) ; PB_SpinView
            ;handle = CocoaMessage( 0, handle, "superview" ) ; PB_SpinView
            
            ;handle = CocoaMessage(0, handle, "superclass") ; NSView
            
            ;;handle = CocoaMessage(0, handle, "contentView") ; 
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "subviews") );
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "opaqueAncestor") );
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "enclosingScrollView") );
            ;;Debug  Get::ClassName( CocoaMessage(0, handle, "superclass") );
            ;;handle = CocoaMessage(0, handle, "opaqueAncestor") ; 
            ;; handle = CocoaMessage( 0, handle, "superview" ) ; PB_SpinView
            
            ; handle = CocoaMessage( 0, handle, "NSTextView" ) ; PB_SpinView
            ; handle = CocoaMessage( 0, handle, "NSTextField" ) ; PB_SpinView
            Debug  Get::ClassName( handle ) 
            
          Case "NSTableHeaderView" 
            handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
            
          Case "NSScroller"                                 ;
                                                            ; PBScrollView
            handle = CocoaMessage( 0, handle, "superview" ) ; NSScrollView
            
            Select Get::ClassName( handle ) 
              Case "WebDynamicScrollBarsView"
                handle = CocoaMessage( 0, handle, "superview" ) ; WebFrameView
                handle = CocoaMessage( 0, handle, "superview" ) ; PB_WebView
                
              Case "PBTreeScrollView"
                handle = CocoaMessage(0, handle, "documentView")
                
              Case "NSScrollView"
                superview = CocoaMessage( 0, handle, "superview" )
                If Get::ClassName( superview ) = "PBScintillaView"
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
            
          Case "PB_NSFlippedView"                           ;
                                                            ; container
            handle = CocoaMessage( 0, handle, "superview" ) ; NSClipView
                                                            ; scrollarea
            If Get::ClassName( handle ) = "NSClipView"
              handle = CocoaMessage( 0, handle, "superview" ) ; PBScrollView
            EndIf
            ;           Default
            ;             Debug "-"  
            ;             Debug  Get::ClassName( handle ) ; PB_NSTextField
            ;             Debug "-"
        EndSelect
      EndIf
    EndIf
    
    ProcedureReturn handle
  EndProcedure
EndModule
;///
DeclareModule Cursor
      Enumeration 
        #PB_Cursor_Default         ; = 0
        #PB_Cursor_Cross           ; = 1
        #PB_Cursor_IBeam           ; = 2
        #PB_Cursor_Hand            ; = 3
        #PB_Cursor_Busy            ; = 4
        #PB_Cursor_Denied          ; = 5
        #PB_Cursor_Arrows          ; = 6
        #PB_Cursor_LeftRight       ; = 7
        #PB_Cursor_UpDown          ; = 8
        #PB_Cursor_LeftUpRightDown ; = 9
        #PB_Cursor_LeftDownRightUp ; = 10
        #PB_Cursor_Invisible       ; = 11
        #PB_Cursor_Left
        #PB_Cursor_Right
        #PB_Cursor_Up
        #PB_Cursor_Down
        #PB_Cursor_Grab
        #PB_Cursor_Grabbing
        #PB_Cursor_Drag
        #PB_Cursor_Drop
        #PB_Cursor_VIBeam
      EndEnumeration
      
      UsePNGImageDecoder()
      
      Declare.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
      Declare   FreeCursor( hCursor.i )
      Declare   HideCursor( state.b )
      Declare   GetCursor( )
      Declare   UpdateCursor( gadget.i )
      Declare   SetCursor( gadget.i, cursor.i )
    EndDeclareModule
    
    Module Cursor 
      #kThemeArrowCursor                   = 0
      #kThemeCopyArrowCursor               = 1
      #kThemeAliasArrowCursor              = 2
      #kThemeContextualMenuArrowCursor     = 3
      #kThemeIBeamCursor                   = 4
      #kThemeCrossCursor                   = 5
      #kThemePlusCursor                    = 6
      #kThemeWatchCursor                   = 7
      #kThemeClosedHandCursor              = 8
      #kThemeOpenHandCursor                = 9
      #kThemePointingHandCursor            = 10
      #kThemeCountingUpHandCursor          = 11
      #kThemeCountingDownHandCursor        = 12
      #kThemeCountingUpAndDownHandCursor   = 13
      #kThemeSpinningCursor                = 14
      #kThemeResizeLeftCursor              = 15
      #kThemeResizeRightCursor             = 16
      #kThemeResizeLeftRightCursor         = 17
      
      ImportC ""
        SetAnimatedThemeCursor(CursorType.i, AnimationStep.i)
        SetThemeCursor(CursorType.i)
        CGCursorIsVisible( )
      EndImport
      
      
      Procedure   FreeCursor( hCursor.i )
        CocoaMessage( 0, hCursor, "release" )
      EndProcedure
      
      Procedure   IsHideCursor( )
        CGCursorIsVisible( )
      EndProcedure
      
      Procedure   HideCursor( state.b )
        If state
          CocoaMessage(0, 0, "NSCursor hide")
        Else
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
      EndProcedure
      
      Procedure.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
        Protected *ic
        Protected Hotspot.NSPoint
        
        If ImageID
          Hotspot\x = x
          Hotspot\y = y
          *ic = CocoaMessage( 0, 0, "NSCursor alloc" )
          CocoaMessage( 0, *ic, "initWithImage:", ImageID, "hotSpot:@", @Hotspot )
        EndIf
        
        ProcedureReturn *ic
      EndProcedure
      
      Procedure   GetCurrentCursor( )
        ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
        ProcedureReturn CocoaMessage(0, 0, "NSCursor currentCursor")
      EndProcedure
      
      Procedure   GetCursor( )
        Protected result.i
        ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
        
        If CGCursorIsVisible( ) ;  GetGadgetAttribute( EventGadget( ), #PB_Canvas_CustomCursor ) ; 
          Select CocoaMessage(0, 0, "NSCursor currentCursor")
            Case CocoaMessage(0, 0, "NSCursor arrowCursor") : result = #PB_Cursor_Default
            Case CocoaMessage(0, 0, "NSCursor IBeamCursor") : result = #PB_Cursor_IBeam
              ; Case CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor") : result = #PB_Cursor_VIBeam
              
            Case CocoaMessage(0, 0, "NSCursor dragCopyCursor") : result = #PB_Cursor_Drop
            Case CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor") : result = #PB_Cursor_Drag
            Case CocoaMessage(0, 0, "NSCursor disappearingItemCursor") : result = #PB_Cursor_Denied
              
            Case CocoaMessage(0, 0, "NSCursor crosshairCursor") : result = #PB_Cursor_Cross
            Case CocoaMessage(0, 0, "NSCursor pointingHandCursor") : result = #PB_Cursor_Hand
            Case CocoaMessage(0, 0, "NSCursor openHandCursor") : result = #PB_Cursor_Grab
            Case CocoaMessage(0, 0, "NSCursor closedHandCursor") : result = #PB_Cursor_Grabbing
              
            Case CocoaMessage(0, 0, "NSCursor resizeUpCursor") : result = #PB_Cursor_Up
            Case CocoaMessage(0, 0, "NSCursor resizeDownCursor") : result = #PB_Cursor_Down
            Case CocoaMessage(0, 0, "NSCursor resizeUpDownCursor") : result = #PB_Cursor_UpDown
              
            Case CocoaMessage(0, 0, "NSCursor resizeLeftCursor") : result = #PB_Cursor_Left
            Case CocoaMessage(0, 0, "NSCursor resizeRightCursor") : result = #PB_Cursor_Right
            Case CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor") : result = #PB_Cursor_LeftRight
          EndSelect 
        Else
          result = #PB_Cursor_Invisible
        EndIf
        
        ProcedureReturn result
      EndProcedure
      
      Procedure SetCursor( handle.i, cursor.i )
        Protected result, windowID
        Protected gadget.i =- 1, window.i =- 1
        
        If GetCursor( ) <> cursor
          If id::IsWindowID( handle )
            window = id::Window( handle )
            windowID = handle
          Else
            gadget = id::Gadget( handle )
            windowID = id::GetWindowID( handle )
          EndIf
          
          ; if ishidden cursor show cursor
          If Not CGCursorIsVisible( )
            CocoaMessage(0, 0, "NSCursor unhide")
          EndIf
          setCursor = cursor
          
          Select cursor
            Case #PB_Cursor_Invisible 
              CocoaMessage(0, 0, "NSCursor hide")
              ; SetGadgetAttribute( EventGadget( ), #PB_Canvas_Cursor, cursor )
              
            Case #PB_Cursor_Busy 
              SetAnimatedThemeCursor( #kThemeWatchCursor, 0 )
              
            Case #PB_Cursor_Default : result = CocoaMessage(0, 0, "NSCursor arrowCursor")
            Case #PB_Cursor_IBeam : result = CocoaMessage(0, 0, "NSCursor IBeamCursor")
              ; Case #PB_Cursor_VIBeam : result = CreateCursor(ImageID(CatchImage(#PB_Any, ?cross, ?cross_end-?cross)), -8,-8) ; CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor")
              ;result = CreateCursor(ImageID(CatchImage(#PB_Any, ?hand, ?hand_end-?hand))) ; : 
            Case #PB_Cursor_Drag : result = CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor")
            Case #PB_Cursor_Drop : result = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
            Case #PB_Cursor_Denied : result = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
              
            Case #PB_Cursor_Cross : result = CocoaMessage(0, 0, "NSCursor crosshairCursor")
            Case #PB_Cursor_Hand : result = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
            Case #PB_Cursor_Grab : result = CocoaMessage(0, 0, "NSCursor openHandCursor")
            Case #PB_Cursor_Grabbing : result = CocoaMessage(0, 0, "NSCursor closedHandCursor")
              
            Case #PB_Cursor_Left : result = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
            Case #PB_Cursor_Right : result = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
            Case #PB_Cursor_LeftRight : result = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
              
            Case #PB_Cursor_Up : result = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
            Case #PB_Cursor_Down : result = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
            Case #PB_Cursor_UpDown : result = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
          EndSelect 
          
          If result
            Debug "pbi.cursor( "+ GetCursor( ) +" - " +cursor +" ) "+GetCurrentCursor( ) +" - "+ result
            
            CocoaMessage(0, result, "set") ; for the no actived-window gadget
;             If gadget >= 0
;               SetGadgetAttribute( gadget, #PB_Canvas_CustomCursor, result )
;             EndIf
            If cursor = #PB_Cursor_Default
              CocoaMessage(0, windowID, "enableCursorRects")
            Else
              CocoaMessage(0, windowID, "disableCursorRects") 
            EndIf
            
            ; CocoaMessage(0, CocoaMessage( 0, GadgetID( gadget ), "window" ), "discardCursorRects") 
            ; CocoaMessage(0, CocoaMessage( 0, GadgetID( gadget ), "window" ), "resetCursorRects") ; for the actived-window gadget
          EndIf
        EndIf
      
        ProcedureReturn cursor
      EndProcedure
      
      Procedure UpdateCursor( gadget.i )
;         Protected currentCursor = CocoaMessage( 0, 0, "NSCursor currentCursor" )
;         Protected currentCanvasCursor = GetGadgetAttribute( gadget, #PB_Canvas_CustomCursor )
;         
;         If currentCursor <> currentCanvasCursor
;           If currentCanvasCursor =- 1
;             SetGadgetAttribute( gadget, #PB_Canvas_CustomCursor, currentCursor )
;           Else
;             CocoaMessage( 0, currentCanvasCursor, "set" )
;           EndIf
;           ProcedureReturn 1
;         EndIf
      EndProcedure
      
;       DataSection
;         cross:
;         ;IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/cross.png"
;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/cross1.png"
;         cross_end:
;         
;         hand:
;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand2.png"
;         hand_end:
;         
;         move:
;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand1.png"
;         move_end:
;         
;       EndDataSection
    EndModule   

CompilerElse
  XIncludeFile "../../mac/get.pbi"
  XIncludeFile "../../mac/id.pbi"
  XIncludeFile "../../mac/mouse.pbi"
CompilerEndIf


; pb-bug-fix
; bug when clicking on the canvas in an inactive window
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  ;   #NSLeftMouseDown      = 1
  ;   #NSLeftMouseUp        = 2
  ;   #NSRightMouseDown     = 3
  ;   #NSRightMouseUp       = 4
  ;   #NSMouseMoved         = 5
  ;   #NSLeftMouseDragged   = 6
  ;   #NSRightMouseDragged  = 7
  ;   #NSMouseEntered       = 8
  ;   #NSMouseExited        = 9
  ;   #NSKeyDown            = 10
  ;   #NSKeyUp              = 11
  ;   #NSFlagsChanged       = 12
  ;   #NSAppKitDefined      = 13
  ;   #NSSystemDefined      = 14
  ;   #NSApplicationDefined = 15
  ;   #NSPeriodic           = 16
  ;   #NSCursorUpdate       = 17
  ;   #NSScrollWheel        = 22
  ;   #NSTabletPoint        = 23
  ;   #NSTabletProximity    = 24
  ;   #NSOtherMouseDown     = 25
  ;   #NSOtherMouseUp       = 26
  ;   #NSOtherMouseDragged  = 27
  ;   #NSEventTypeGesture   = 29
  ;   #NSEventTypeMagnify   = 30
  ;   #NSEventTypeSwipe     = 31
  ;   #NSEventTypeRotate    = 18
  ;   #NSEventTypeBeginGesture = 19
  ;   #NSEventTypeEndGesture   = 20
  ;   #NSEventTypeSmartMagnify = 32
  ;   #NSEventTypeQuickLook   = 33
  
  Global psn.q, mask, key.s
  
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
  
  
  mask = 1<<#NSScrollWheel;| 1<<#NSMouseEntered | 1<<#NSMouseExited
  mask | 1<<#NSLeftMouseDown | 1<<#NSLeftMouseUp | 1<<#NSLeftMouseDragged 
  ; mask | 1<<#NSMouseMoved  ; 
  ; mask | 1<<#NSRightMouseDown | 1<<#NSRightMouseUp
  ; mask | 1<<#NSLeftMouseDragged | 1<<#NSRightMouseDragged
  ; mask | 1<<#NSKeyDown
  
  ;       ;
  ;       ; callback function
  ;       ;
  Global event_window =- 1
  Global event_gadget =- 1
  
  Procedure EventWindowActivate( )
    Protected Point.NSPoint
    event_window = EventWindow( )
    Protected NSWindow = WindowID( event_window ) 
    
    If NSWindow
      Protected EnteredID = Mouse::Gadget( NSWindow )
      
      If EnteredID
        event_gadget = ID::Gadget( EnteredID )
        
        If IsGadget( event_gadget )
          PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown )
          SetActiveGadget( event_gadget )
        EndIf
      EndIf
    EndIf
  EndProcedure
  
  ProcedureC eventTapFunction(proxy, type, event, refcon)
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    If NSEvent
      Protected NSWindow = CocoaMessage(0, NSEvent, "window")
      
      If type = #NSScrollWheel
        Protected window = ID::Window( NSWindow )
        Protected gadget = ID::Gadget( Mouse::Gadget( Mouse::window( ) ) )
        Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
        Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
        
        If scrollX And scrollY = 0
          ;Debug "X - scroll"
          CompilerIf Defined(PB_EventType_MouseWheelX, #PB_Constant)
            PostEvent( #PB_Event_Gadget , window, gadget, constants::#PB_EventType_MouseWheelX, scrollX )
          CompilerEndIf
        EndIf
        
        If scrollY And scrollX = 0
          ;Debug "Y - scroll"
          CompilerIf Defined(PB_EventType_MouseWheelY, #PB_Constant)
            PostEvent( #PB_Event_Gadget , window, gadget, constants::#PB_EventType_MouseWheelY, scrollY )
          CompilerEndIf
        EndIf
      EndIf
      
      If type = #NSLeftMouseDown
        If NSWindow
          event_window = ID::Window( NSWindow )
        EndIf           
        
        If event_window = GetActiveWindow( )
          event_window =- 1
        EndIf
        
      ElseIf type = #NSLeftMouseUp
        If IsWindow( event_window )
          If IsGadget( event_gadget )
            PostEvent( #PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonUp, NSEvent )
            event_gadget =- 1
          Else
            PostEvent( #PB_Event_LeftClick , event_window, EventGadget( ), EventType( ), NSEvent )
          EndIf
          event_window =- 1
        EndIf
        
      ElseIf type = #NSLeftMouseDragged
        If event_window >= 0 And event_gadget =- 1
          event_window =- 1
        EndIf
      EndIf
    EndIf           
  EndProcedure
  
  #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
  #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
  #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
  
  #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
  #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
  
  Procedure FixDownUp( )
    Protected eventTap
    GetCurrentProcess(@psn.q)
    eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction(), 0)
    ; eventTap = CGEventTapCreate_(#cgAnnotatedSessionEventTap, #headInsertEventTap, 1, mask, @eventTapFunction(), 0) 
    If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
    EndIf
    BindEvent( #PB_Event_ActivateWindow, @EventWindowActivate( ) )
  EndProcedure
  
  CompilerIf #PB_Compiler_IsMainFile
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      EnableExplicit
      
      ImportC ""
        CGEventTapCreate(Tap.I, Place.I, Options.I, EventsOfInterest.Q, Callback.I, *UserData)
      EndImport
      
      Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1
      Macro DraggedGadget( ) : *dragged : EndMacro
      Macro EnteredGadget( ) : *entered : EndMacro
      Macro FocusedGadget( ) : *focused : EndMacro
      Macro PressedGadget( ) : *pressed : EndMacro
      
      Macro GadgetMouseX( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
        ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
        DesktopMouseX( ) - GadgetX( _canvas_, _mode_ )
        ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
      EndMacro
      
      Macro GadgetMouseY( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
        ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
        DesktopMouseY( ) - GadgetY( _canvas_, _mode_ )
        ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
      EndMacro
      
      Procedure DrawCanvasBack( gadget, color )
        If GadgetType( gadget ) = #PB_GadgetType_Canvas
          StartDrawing( CanvasOutput( gadget ) )
          DrawingMode( #PB_2DDrawing_Default )
          Box( 0,0,OutputWidth( ), OutputHeight( ), color )
          StopDrawing( )
        EndIf
      EndProcedure
      
      Procedure DrawCanvasFrame( gadget, color )
        If GadgetType( gadget ) = #PB_GadgetType_Canvas
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
        EndIf
      EndProcedure
      
      Procedure Events( eventobject, eventtype, eventdata )
        Protected deltax, deltay, dropx, dropy
        ;         If eventtype <> #PB_EventType_MouseMove
        ;           ;  Debug ""+ get::classname(gadget) +" "+ eventobject +" "+ eventtype
        ;           Debug ""+ eventobject +" "+ eventtype
        ;         EndIf
        
        Select eventtype
          Case constants::#PB_EventType_MouseWheelX
            Debug ""+eventobject + " #PB_EventType_MouseWheelX " 
            
          Case constants::#PB_EventType_MouseWheelY
            Debug ""+eventobject + " #PB_EventType_MouseWheelY " 
            
          Case #PB_EventType_DragStart
            deltax = GadgetMouseX( eventobject, #PB_Gadget_WindowCoordinate )
            deltay = GadgetMouseY( eventobject, #PB_Gadget_WindowCoordinate )
            Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
            
          Case constants::#PB_EventType_Drop
            dropx = GadgetMouseX( eventobject, #PB_Gadget_ScreenCoordinate )
            dropy = GadgetMouseY( eventobject, #PB_Gadget_ScreenCoordinate )
            Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
            
          Case #PB_EventType_Focus
            Debug ""+eventobject + " #PB_EventType_Focus " 
            DrawCanvasBack( eventobject, $FFA7A4)
            DrawCanvasFrame( eventobject, $2C70F5)
            
          Case #PB_EventType_LostFocus
            Debug ""+eventobject + " #PB_EventType_LostFocus " 
            DrawCanvasBack( eventobject, $FFFFFF)
          Case #PB_EventType_LeftButtonDown
            Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
            
          Case #PB_EventType_LeftButtonUp
            Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
          Case #PB_EventType_LeftClick
            Debug ""+eventobject + " #PB_EventType_LeftClick " 
          Case #PB_EventType_LeftDoubleClick
            Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
          Case #PB_EventType_MouseEnter
            Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
            DrawCanvasFrame( eventobject, $2C70F5)
            
             cursor::SetCursor( GadgetID(eventobject), #PB_Cursor_Hand )
            ;         ;
            ;         If GetActiveWindow( ) = EventWindow( )
            ;           SetGadgetAttribute( eventobject, #PB_Canvas_Cursor, #PB_Cursor_Hand )
            ;         Else
            ;           ;           SetGadgetAttribute( eventobject, #PB_Canvas_Cursor, #PB_Cursor_Invisible)
            ;           ;           If HideCursor
            ;           ; CocoaMessage(0, 0, "NSCursor hide")
            ;           ;         Else
            ;           ;           CocoaMessage(0, 0, "NSCursor unhide")
            ;           ;         EndIf
            ;           CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            ;             ; SetAnimatedThemeCursor(#kThemeWatchCursor, 0)
            ;             ;SetThemeCursor(#kThemePointingHandCursor)
            ;           CompilerEndIf
            ;         EndIf
            ;         
            ;         ;Debug GetCursor( )
            
          Case #PB_EventType_MouseLeave
            Debug ""+eventobject + " #PB_EventType_MouseLeave "
            
            
            DrawCanvasFrame( eventobject, 0 )
            
            ;
            If GetActiveWindow( ) <> EventWindow( )
              CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                ; SetThemeCursor(#kThemeArrowCursor)
              CompilerEndIf
            EndIf
            
          Case #PB_EventType_Resize
            Debug ""+eventobject + " #PB_EventType_Resize " 
            
          Case #PB_EventType_MouseMove
            ; Debug ""+eventobject + " #PB_EventType_MouseMove " 
            ;         If DraggedGadget( ) = 1
            ;           ResizeGadget( DraggedGadget( ), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            ;         EndIf
            If DraggedGadget( ) = 0
              ResizeGadget( DraggedGadget( ), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            EndIf
            
        EndSelect
        
      EndProcedure
      
      ProcedureC EventTapHandler( Proxy.I, EventType.I, Event.I, *UserData )
        If *UserData
          Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
          Protected MouseMove, MouseX, MouseY, MoveStart
          Protected EnteredID, Canvas =- 1, LeftDoubleClick
          
          If EventType = #NSLeftMouseDown
            MouseDrag = 1
          EndIf
          
          If EventType = #NSLeftMouseUp
            If EnteredGadget( ) >= 0 
              If DraggedGadget( ) >= 0 And DraggedGadget( ) = PressedGadget( ) 
                CompilerIf Defined( constants::PB_EventType_Drop, #PB_Constant ) 
                  CallCFunctionFast( *UserData, EnteredGadget( ), constants::#PB_EventType_Drop )
                CompilerEndIf
              EndIf
              
              If Not ( LeftDoubleClickTime And ElapsedMilliseconds( ) - LeftDoubleClickTime < DoubleClickTime( ) )
                LeftDoubleClickTime = ElapsedMilliseconds( ) 
              Else
                LeftDoubleClick = 1
              EndIf
            EndIf
            
            MouseDrag = 0
          EndIf
          
          If MouseDrag >= 0 
            EnteredID = Mouse::Gadget( Mouse::Window( ) )
          EndIf
          
          ;
          If EnteredID
            Canvas = ID::Gadget( EnteredID )
            
            If Canvas >= 0
              Mousex = GadgetMouseX( Canvas )
              Mousey = GadgetMouseY( Canvas )
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
              Mousex = GadgetMouseX( PressedGadget( ) )
              Mousey = GadgetMouseY( PressedGadget( ) )
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
              If EnteredGadget( ) >= 0 ;And GadgetType( EnteredGadget( ) ) = #PB_GadgetType_Canvas
                If cursor::getcursor( ) <> #PB_Cursor_Default
                  cursor::SetCursor( GadgetID( EnteredGadget( ) ), #PB_Cursor_Default )
                EndIf
                CallCFunctionFast( *UserData, EnteredGadget( ) , #PB_EventType_MouseLeave )
              EndIf
              
              EnteredGadget( ) = Canvas
              
              If EnteredGadget( ) >= 0 ;And GadgetType( EnteredGadget( ) ) = #PB_GadgetType_Canvas
                CallCFunctionFast( *UserData, EnteredGadget( ), #PB_EventType_MouseEnter )
              EndIf
            Else
              ; mouse drag start
              If MouseDrag > 0
                If EnteredGadget( ) >= 0 And
                   DraggedGadget( ) <> PressedGadget( )
                  DraggedGadget( ) = PressedGadget( )
                  CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_DragStart )
                  DeltaX = GadgetX( PressedGadget( ) ) 
                  DeltaY = GadgetY( PressedGadget( ) )
                EndIf
              EndIf
              
              If MouseDrag And EnteredGadget( ) <> PressedGadget( )
                CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_MouseMove )
              EndIf
              
              If EnteredGadget( ) >= 0
                CallCFunctionFast( *UserData, EnteredGadget( ), #PB_EventType_MouseMove )
                
                ; if move gadget x&y position
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
          If EventType = #NSLeftMouseDown
            PressedGadget( ) = EnteredGadget( ) ; EventGadget( )
                                                ;Debug CocoaMessage(0, Mouse::Window( ), "focusView")
            
            If PressedGadget( ) >= 0
              If FocusedGadget( ) =- 1
                FocusedGadget( ) = PressedGadget( ) ; GetActiveGadget( )
                If GadgetType( FocusedGadget( ) ) = #PB_GadgetType_Canvas
                  CallCFunctionFast( *UserData, FocusedGadget( ), #PB_EventType_Focus )
                EndIf
              EndIf
              
              If FocusedGadget( ) >= 0 And 
                 FocusedGadget( ) <> PressedGadget( )
                CallCFunctionFast( *UserData, FocusedGadget( ), #PB_EventType_LostFocus )
                
                FocusedGadget( ) = PressedGadget( )
                CallCFunctionFast( *UserData, FocusedGadget( ), #PB_EventType_Focus )
              EndIf
              
              CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_LeftButtonDown )
            EndIf
          EndIf
          
          ;
          If eventtype = #NSLeftMouseUp
            If PressedGadget( ) >= 0 
              CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_LeftButtonUp )
              
              If LeftDoubleClick
                CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_LeftDoubleClick )
              Else
                If PressedGadget( ) <> DraggedGadget( )
                  If PressedGadget( ) >= 0 And EnteredID = GadgetID( PressedGadget( ) )
                    CallCFunctionFast( *UserData, PressedGadget( ), #PB_EventType_LeftClick )
                  EndIf
                EndIf
              EndIf
            EndIf
            
            DraggedGadget( ) =- 1
          EndIf
          
          ;         ;
          ;         If eventtype = #PB_EventType_LeftDoubleClick
          ;           CallCFunctionFast( *UserData, EnteredGadget( ), #PB_EventType_LeftDoubleClick )
          ;         EndIf
          
          If eventtype = #NSScrollWheel
            Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
            
            If NSEvent
              Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
              Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
              
              If scrollX And Not scrollY
                ; Debug "X - scroll"
                If EnteredGadget( ) >= 0
                  CompilerIf Defined( constants::PB_EventType_MouseWheelY, #PB_Constant ) 
                    CallCFunctionFast( *UserData, EnteredGadget( ), constants::#PB_EventType_MouseWheelX, scrollX )
                  CompilerEndIf
                EndIf
              EndIf
              
              If scrollY And Not scrollX
                ; Debug "Y - scroll"
                If EnteredGadget( ) >= 0
                  CompilerIf Defined( constants::PB_EventType_MouseWheelX, #PB_Constant ) 
                    CallCFunctionFast( *UserData, EnteredGadget( ), constants::#PB_EventType_MouseWheelY, scrollY )
                  CompilerEndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          
          ;           If EventType = #PB_EventType_Resize
          ;             ; CallCFunctionFast( *UserData, EventGadget( ), #PB_EventType_Resize )
          ;           EndIf
          ;           CompilerIf Defined( PB_EventType_Repaint, #PB_Constant ) And Defined( constants, #PB_Module )
          ;             If EventType = #PB_EventType_Repaint
          ;               CallCFunctionFast( *UserData, EventGadget( ), #PB_EventType_Repaint )
          ;             EndIf
          ;           CompilerEndIf
          ;           
        EndIf
        
      EndProcedure
      
      Procedure SetCallBack( *callback )
        Protected mask, EventTap
        mask = #NSMouseMovedMask | #NSScrollWheelMask
        mask | #NSMouseEnteredMask | #NSMouseExitedMask 
        mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask 
        mask | #NSRightMouseDownMask | #NSRightMouseDownMask 
        mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask
        EventTap = CGEventTapCreate(2, 0, 1, mask, @EventTapHandler( ), *callback)
        
;         GetCurrentProcess(@psn.q)
;         eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @EventTapHandler( ), *callback)
    
        If EventTap
          CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", EventTap, "forMode:$", @"kCFRunLoopDefaultMode")
        EndIf
      EndProcedure
      
      ; SetCallBack( @Events( ) )
    CompilerEndIf
  CompilerEndIf
CompilerEndIf

; CompilerIf #PB_Compiler_IsMainFile
;   Procedure down_eventtype( )
;     Debug "down"
;   EndProcedure
;   
;   Procedure up_eventtype( )
;     Debug "  up"
;   EndProcedure
;   
;   ;
;   FixDownUp( )
;   
;   OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
;   CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container)
;   
;   BindGadgetEvent( 2, @down_eventtype( ), #PB_EventType_LeftButtonDown ) 
;   BindGadgetEvent( 2, @up_eventtype( ), #PB_EventType_LeftButtonUp ) 
;   
;   OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
;   CanvasGadget(3, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container)
;   
;   BindGadgetEvent( 3, @down_eventtype( ), #PB_EventType_LeftButtonDown ) 
;   BindGadgetEvent( 3, @up_eventtype( ), #PB_EventType_LeftButtonUp ) 
;   
;   Define event
;   Repeat 
;     event = WaitWindowEvent( )
;   Until event = #PB_Event_CloseWindow
; CompilerEndIf
CompilerIf #PB_Compiler_IsMainFile
  UseModule constants
  ;UseModule events
  
  Define event
  
  ;   Procedure DrawCanvasBack( gadget, color )
  ;     If GadgetType( gadget ) = #PB_GadgetType_Canvas
  ;       StartDrawing( CanvasOutput( gadget ) )
  ;       DrawingMode( #PB_2DDrawing_Default )
  ;       Box( 0,0,OutputWidth( ), OutputHeight( ), color )
  ;       StopDrawing( )
  ;     EndIf
  ;   EndProcedure
  ;   
  ;   Procedure DrawCanvasFrame( gadget, color )
  ;     If GadgetType( gadget ) = #PB_GadgetType_Canvas
  ;       StartDrawing( CanvasOutput( gadget ) )
  ;       If GetGadgetState( gadget )
  ;         DrawImage( 0,0, GetGadgetState( gadget ) )
  ;       EndIf
  ;       If Not color
  ;         color = Point( 10,10 )
  ;       EndIf
  ;       If color 
  ;         DrawingMode( #PB_2DDrawing_Outlined )
  ;         Box( 0,0,OutputWidth( ), OutputHeight( ), color )
  ;       EndIf
  ;       StopDrawing( )
  ;     EndIf
  ;   EndProcedure
  
  
  
  Procedure EventHandler( eventobject, eventtype, eventdata )
    Protected window = EventWindow()
    Protected dropx, dropy
    Static deltax, deltay
    
    Select eventtype
      Case #PB_EventType_MouseWheelX
        Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
        
      Case #PB_EventType_MouseWheelY
        Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
        
      Case #PB_EventType_DragStart
        deltax = GadgetMouseX( eventobject, #PB_Gadget_WindowCoordinate )
        deltay = GadgetMouseY( eventobject, #PB_Gadget_WindowCoordinate )
        Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
        
      Case #PB_EventType_Drop
        dropx = GadgetMouseX( eventobject, #PB_Gadget_ScreenCoordinate )
        dropy = GadgetMouseY( eventobject, #PB_Gadget_ScreenCoordinate )
        Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
        
      Case #PB_EventType_Focus
        Debug ""+eventobject + " #PB_EventType_Focus " 
        DrawCanvasBack( eventobject, $FFA7A4)
        DrawCanvasFrame( eventobject, $2C70F5)
        
      Case #PB_EventType_LostFocus
        Debug ""+eventobject + " #PB_EventType_LostFocus " 
        DrawCanvasBack( eventobject, $FFFFFF)
      Case #PB_EventType_LeftButtonDown
        Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
        ;CocoaMessage(0, WindowID(EventWindow()), "disableCursorRects") 
        CocoaMessage(0, WindowID(EventWindow()), "discardCursorRects") 
        ;CocoaMessage(0, WindowID(EventWindow()), "resetCursorRects") ; for the actived-window gadget
         
      Case #PB_EventType_LeftButtonUp
        Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
        CocoaMessage(0, WindowID(EventWindow()), "resetCursorRects") 
        
      Case #PB_EventType_LeftClick
        Debug ""+eventobject + " #PB_EventType_LeftClick " 
      Case #PB_EventType_LeftDoubleClick
        Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
      Case #PB_EventType_MouseEnter
        Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
        DrawCanvasFrame( eventobject, $2C70F5)
;;         Debug cursor::getcursor( )
        If cursor::getcursor( ) = #PB_Cursor_Default
          cursor::SetCursor( GadgetID(eventobject), #PB_Cursor_Hand )
        EndIf
       ;         ;
        ;         If GetActiveWindow( ) = EventWindow( )
        ;           SetGadgetAttribute( eventobject, #PB_Canvas_Cursor, #PB_Cursor_Hand )
        ;         Else
        ;           ;           SetGadgetAttribute( eventobject, #PB_Canvas_Cursor, #PB_Cursor_Invisible)
        ;           ;           If HideCursor
        ;           ; CocoaMessage(0, 0, "NSCursor hide")
        ;           ;         Else
        ;           ;           CocoaMessage(0, 0, "NSCursor unhide")
        ;           ;         EndIf
        ;           CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ;             ; SetAnimatedThemeCursor(#kThemeWatchCursor, 0)
        ;             ;SetThemeCursor(#kThemePointingHandCursor)
        ;           CompilerEndIf
        ;         EndIf
        ;         
        ;         ;Debug GetCursor( )
        
      Case #PB_EventType_MouseLeave
        Debug ""+eventobject + " #PB_EventType_MouseLeave "
        
        
        DrawCanvasFrame( eventobject, 0 )
        
        ;
        If GetActiveWindow( ) <> EventWindow( )
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            ; SetThemeCursor(#kThemeArrowCursor)
          CompilerEndIf
        EndIf
        
      Case #PB_EventType_Resize
        Debug ""+eventobject + " #PB_EventType_Resize " 
        
      Case #PB_EventType_MouseMove
       ; Debug ""+eventobject + " #PB_EventType_MouseMove " 
        ;         If DraggedGadget( ) = 1
        ;           ResizeGadget( DraggedGadget( ), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         EndIf
        If DraggedGadget( ) = 0
          ResizeGadget( DraggedGadget( ), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure Resize_2( )
    Protected canvas = 2
    ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
  EndProcedure
  
  Procedure Resize_3( )
    Protected canvas = 3
    ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
  EndProcedure
  
  
  SetCallback( @EventHandler( ) )
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  
  ButtonGadget(-1, 60,240,60,60,"")
  Define g1,g2
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(-1,10,240,60,60, g1,g2)
  
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container);|#PB_Canvas_DrawFocus)
                                                                             ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )
  BindEvent( #PB_Event_SizeWindow, @Resize_2(), 2 )
  
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  CanvasGadget(3, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container);|#PB_Canvas_DrawFocus)
  
  ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )
  ;cursor::SetCursor( 3, #PB_Cursor_Hand )
  BindEvent( #PB_Event_SizeWindow, @Resize_3( ), 3 )
  
  ;   SetGadgetData( 0, @EventHandler( ) )
  ;   SetGadgetData( 1, @EventHandler( ) )
  ;   SetGadgetData( 2, @EventHandler( ) )
  ;   SetGadgetData( 3, @EventHandler( ) )
  ;   SetGadgetData( 11, @EventHandler( ) )
  
  ;SetCallback( @EventHandler( ) )
  
  ;   Debug GadgetID(1)
  ;   Debug GadgetID(11)
  ;   Debug GadgetID(2)
  Define lastcursor=-1
  Repeat 
    event = WaitWindowEvent( )
    
    ;     If event = #PB_Event_SizeWindow
    ;       Define canvas = EventWindow()
    ;       ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
    ;     EndIf
    
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
    If event =- 1
      ; Debug GetCursor( )
    EndIf
    If lastcursor <> cursor::getcursor( )
      Debug lastcursor
      lastcursor = cursor::getcursor( )
    EndIf
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = n6f-4X+-+----v4------f---
; EnableXP