EnableExplicit

UsePNGImageDecoder()
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
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ImportC ""
    gtk_widget_get_window(*Widget.GtkWidget)
  EndImport
CompilerEndIf


Procedure ChangeCursorToPNGImage(WindowID.I, ImageID.I)
  Protected CustomCursor.I
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      CustomCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(),
                                                 ImageID(ImageID), 0, 0)
      gdk_window_set_cursor_(gtk_widget_get_window(WindowID(WindowID)),
                             CustomCursor)
    CompilerCase #PB_OS_MacOS
      Protected Hotspot.NSPoint
      
      Hotspot\x = 1
      Hotspot\y = 1
      CustomCursor = CocoaMessage(0, 0, "NSCursor alloc")
      CocoaMessage(0, CustomCursor,
                   "initWithImage:", ImageID(ImageID),
                   "hotSpot:@", @Hotspot)
      CocoaMessage(0, CustomCursor, "set")
      ;SetWindowData(0, CustomCursor)
      ;CocoaMessage(0, WindowID(WindowID), "discardCursorRects") 
      CocoaMessage(0, WindowID(WindowID), "disableCursorRects")
      
    CompilerCase #PB_OS_Windows
      Protected Cursor.ICONINFO
      
      Cursor\fIcon = #False
      Cursor\xHotspot = 1
      Cursor\yHotspot = 1
      Cursor\hbmColor = ImageID(ImageID)
      Cursor\hbmMask = ImageID(ImageID)
      CustomCursor = CreateIconIndirect_(Cursor)
      SetClassLongPtr_(WindowID(WindowID), #GCL_HCURSOR, CustomCursor)
  CompilerEndSelect
  
  ProcedureReturn CustomCursor
EndProcedure

If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
  MessageRequester("Error",
                   "Loading of image World.png failed!",
                   #PB_MessageRequester_Error)
  End
EndIf


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
  
  ;
  #MaskLeftMouseDown      = 1<<1
  #MaskLeftMouseUp        = 1<<2
  #MaskRightMouseDown     = 1<<3
  #MaskRightMouseUp       = 1<<4
  #MaskMouseMoved         = 1<<5
  #MaskLeftMouseDragged   = 1<<6
  #MaskRightMouseDragged  = 1<<7
  #MaskMouseEntered       = 1<<9
  #MaskMouseExited        = 1<<8
  #MaskKeyDown            = 1<<10
  #MaskKeyUp              = 1<<11
  #MaskFlagsChanged       = 1<<12
  #MaskAppKitDefined      = 1<<13
  #MaskSystemDefined      = 1<<14
  #MaskApplicationDefined = 1<<15
  #MaskPeriodic           = 1<<16
  #MaskCursorUpdate       = 1<<17
  #MaskScrollWheel        = 1<<22
  #MaskTabletPoint        = 1<<23
  #MaskTabletProximity    = 1<<24
  
  #MaskOtherMouseDown     = 1<<25
  #MaskOtherMouseUp       = 1<<26
  #MaskOtherMouseDragged  = 1<<27
  
  #MaskEventTypeGesture   = 1<<29
  #MaskEventTypeMagnify   = 1<<30
  #MaskEventTypeSwipe     = 1<<31
  #MaskEventTypeRotate    = 1<<18
  #MaskEventTypeBeginGesture = 1<<19
  #MaskEventTypeEndGesture   = 1<<20
  #MaskEventTypeSmartMagnify = 1<<32
  #MaskEventTypeQuickLook    = 1<<33
  
  Global eventTap, mask = #MaskMouseEntered | #MaskMouseExited | #MaskMouseMoved | #MaskCursorUpdate |#MaskLeftMouseDown|#MaskLeftMouseUp|#MaskLeftMouseDragged
  
  Procedure UnderMouse( NSWindow )
    ;     Protected Point.CGPoint
    ;     Protected ContentView = CocoaMessage(0,  NSWindow , "contentView")
    ;     CocoaMessage(@Point,  NSWindow , "mouseLocationOutsideOfEventStream")
    ;     If ContentView
    ;       ProcedureReturn CocoaMessage(0, ContentView, "hitTest:@", @Point) 
    ;     EndIf
    ProcedureReturn Mouse::Gadget(NSWindow)
  EndProcedure
  
  Structure cursor
    index.i
    *object
    *cursor
    ;button.b
    ;state.b
    change.b
  EndStructure
  Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback
  Macro DraggedGadget( ) : *dragged : EndMacro
  Macro EnteredGadget( ) : *entered : EndMacro
  Macro FocusedGadget( ) : *focused : EndMacro
  Macro PressedGadget( ) : *pressed : EndMacro
  
  Procedure setCursor( gadget, cursor )
    If IsGadget(gadget)
      Protected *cur.cursor = AllocateStructure(cursor)
      *cur\index = cursor
      *cur\object = GadgetID(gadget)
      
      Protected NSWindow = CocoaMessage( 0, *cur\object, "window" )
      
      Select cursor
        Case #PB_Cursor_Default : *cur\cursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
        Case #PB_Cursor_IBeam : *cur\cursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
        Case #PB_Cursor_Cross : *cur\cursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
        Case #PB_Cursor_Hand : *cur\cursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
        Case #PB_Cursor_LeftRight : *cur\cursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
        Case #PB_Cursor_UpDown : *cur\cursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
      EndSelect 
      
      SetGadgetData(gadget, *cur)
      
      If *cur\cursor And *cur\object = UnderMouse(NSWindow)
        CocoaMessage(0, NSWindow, "disableCursorRects")
        CocoaMessage(0, *cur\cursor, "set")
        *cur\change = 1
        ProcedureReturn #True
      EndIf
      
    EndIf
  EndProcedure
  
  
  Procedure updateCursor( NSWindow, *cursor.cursor )
    If *cursor And *cursor\cursor
      If *cursor\change = 0
        Debug "e+"
        CocoaMessage(0, NSWindow, "disableCursorRects")
        CocoaMessage(0, *cursor\cursor, "set") 
      EndIf
    EndIf
  EndProcedure
  
  ProcedureC eventTapFunction(proxy, type, event, refcon)
    Static *widget
    Protected Point.CGPoint
    Protected ContentView
    Protected handle
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    
    Static  *cursor.cursor 
    
    If NSEvent
      Protected NSWindow = CocoaMessage(0, NSEvent, "window")
      Protected gadget 
      
      If type = #NSLeftMouseUp
        ;         If *cursor\cursor And *cursor\object <> handle And 
        ;            CocoaMessage(0, 0, "NSCursor currentCursor") <> CocoaMessage(0, 0, "NSCursor arrowCursor")
        ;           Debug "---"
        ;           CocoaMessage(0, NSWindow, "enableCursorRects")
        ;           CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
        ;         EndIf
        
        handle = UnderMouse( NSWindow )
        gadget = ID::Gadget(handle)
        EnteredGadget( ) = gadget
        
        If EnteredGadget( ) >= 0 
          *cursor.cursor = GetGadgetData(EnteredGadget( ))
        Else
          *cursor.cursor = #Null
        EndIf
        
        If *cursor And
           *cursor\cursor
          Debug "+"
          CocoaMessage(0, NSWindow, "disableCursorRects")
          CocoaMessage(0, *cursor\cursor, "set") 
          *cursor\change = 1
        Else
          If PressedGadget() >= 0
            If GadgetID(PressedGadget()) <> UnderMouse( NSWindow )
              *cursor.cursor = GetGadgetData(PressedGadget())
              If *cursor And
                 *cursor\cursor
                *cursor\change = 0
                
                Debug "-"
                CocoaMessage(0, NSWindow, "enableCursorRects")
                CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
              EndIf
            EndIf
            
            PressedGadget() =- 1
          EndIf
        EndIf
        
      ElseIf type = #NSLeftMouseDown
        If NSWindow
          PressedGadget() = ID::Gadget(UnderMouse( NSWindow ))
        EndIf
        
      ElseIf type = #NSMouseMoved
        ;ElseIf type = #NSLeftMouseDragged
        If NSWindow
          handle = UnderMouse( NSWindow )
          gadget = ID::Gadget(handle)
          
          If EnteredGadget( ) <> gadget
            If EnteredGadget( ) >= 0 
              *cursor.cursor = GetGadgetData(EnteredGadget( ))
              If *cursor And
                 *cursor\cursor
                *cursor\change = 0
                Debug "e-"
                CocoaMessage(0, NSWindow, "enableCursorRects")
                CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
              EndIf
            EndIf
            
            EnteredGadget( ) = gadget
            
            If EnteredGadget( ) >= 0 
              *cursor.cursor = GetGadgetData(EnteredGadget( ))
              If *cursor And
                 *cursor\cursor
                If *cursor\change = 0
                  Debug "e+"
                  CocoaMessage(0, NSWindow, "disableCursorRects")
                  CocoaMessage(0, *cursor\cursor, "set") 
                EndIf
              EndIf
            EndIf
          EndIf
          
        EndIf
        
      ElseIf type = #NSCursorUpdate
      EndIf
    EndIf           
  EndProcedure
  
  #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
  #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
  #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
  
  #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
  #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
  
  eventTap = CGEventTapCreate_(#cgAnnotatedSessionEventTap, #headInsertEventTap, 1, mask, @eventTapFunction(), 0) 
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
  EndIf
CompilerEndIf

OpenWindow(0, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)

ButtonGadget(-1, 60,240,60,60,"")
Define g1,g2
g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
SplitterGadget(-1,10,240,60,60, g1,g2)

If setCursor(1,#PB_Cursor_Hand)
  Debug "hand"           
EndIf       

If setCursor(11,#PB_Cursor_Cross)
  Debug "cross"           
EndIf       


; 
;         
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 0 And EventType() = #PB_EventType_LeftClick
        ;         cursor\cursor = ChangeCursorToPNGImage(0, 0)
        ;         cursor\object = GadgetID(EventGadget())
        ;         
        SetWindowTitle(0, Str(Random(255)))
        ;*lastcursor = CocoaMessage(0, 0, "NSCursor currentCursor")
        
        DisableGadget(0, #True)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------
; EnableXP