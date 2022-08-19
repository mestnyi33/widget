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
  
  Structure cursor
    index.i
    ;*windowID
    ;*gadgetID
    *cursor
    ;button.b
    ;state.b
    change.b
  EndStructure
  
  Global *entered=-1, *pressed=-1;, *dragged=-1, *focused=-1, *setcallback
  Macro EnteredGadget( ) : *entered : EndMacro
  Macro PressedGadget( ) : *pressed : EndMacro
;   Macro DraggedGadget( ) : *dragged : EndMacro
;   Macro FocusedGadget( ) : *focused : EndMacro
  
  Procedure underGadget(NSWindow)
    If NSWindow
      Protected handle = Mouse::Gadget(NSWindow)
      If handle
        ProcedureReturn ID::Gadget(handle)
      EndIf
    EndIf
    
    ProcedureReturn - 1
  EndProcedure
  
  Procedure setCursor( gadget, cursor, ImageID.i=0 )
    If IsGadget(gadget)
      Protected *cursor.cursor = AllocateStructure(cursor)
      Protected NSWindow = CocoaMessage( 0, GadgetID(gadget), "window" )
      *cursor\index = cursor
      
      If cursor >= 0
        Select cursor
          Case #PB_Cursor_Default : *cursor\cursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
          Case #PB_Cursor_IBeam : *cursor\cursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
          Case #PB_Cursor_Cross : *cursor\cursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
          Case #PB_Cursor_Hand : *cursor\cursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
          Case #PB_Cursor_LeftRight : *cursor\cursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
          Case #PB_Cursor_UpDown : *cursor\cursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
        EndSelect 
      Else
        If ImageID
          Protected Hotspot.NSPoint
          Hotspot\x = 1
          Hotspot\y = 1
          *cursor\cursor = CocoaMessage(0, 0, "NSCursor alloc")
          CocoaMessage(0, *cursor\cursor, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
        EndIf
      EndIf
      
      SetGadgetData(gadget, *cursor)
      
      If *cursor\cursor And gadget = underGadget(NSWindow)
        CocoaMessage(0, NSWindow, "disableCursorRects")
        CocoaMessage(0, *cursor\cursor, "set")
        *cursor\change = 1
        ProcedureReturn #True
      EndIf
      
    EndIf
  EndProcedure
  
  ProcedureC eventTapFunction(proxy, type, event, refcon)
    Static *widget
    Protected Point.CGPoint
    Protected ContentView
    Protected handle
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    Protected *cursor.cursor = #Null
    
    
    If NSEvent
      Protected gadget =- 1
      Protected NSWindow = Mouse::Window( ) ; CocoaMessage(0, NSEvent, "window")
      
      
      If type = #NSLeftMouseDown
        PressedGadget() = underGadget(NSWindow)
        
      ElseIf type = #NSLeftMouseUp
        gadget = underGadget(NSWindow)
        
        If PressedGadget() >= 0 And 
           PressedGadget() <> gadget  
          
          *cursor.cursor = GetGadgetData(PressedGadget())
          If *cursor And
             *cursor\cursor And 
             *cursor\change = 1
            *cursor\change = 0
            Debug "p-"
            CocoaMessage(0, NSWindow, "enableCursorRects")
            CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
          EndIf
        EndIf
        
        If gadget >= 0 And 
           gadget <> PressedGadget()
          
          EnteredGadget() = gadget
          *cursor.cursor = GetGadgetData(gadget)
          If *cursor And
             *cursor\cursor
            Debug "p+"
            CocoaMessage(0, NSWindow, "disableCursorRects")
            CocoaMessage(0, *cursor\cursor, "set") 
            *cursor\change = 1
          EndIf
        EndIf
        
        PressedGadget() =- 1
        
      ElseIf type = #NSMouseMoved
        gadget = underGadget(NSWindow)
        
        If EnteredGadget( ) <> gadget
          If EnteredGadget( ) >= 0 
            *cursor.cursor = GetGadgetData(EnteredGadget( ))
            If *cursor And 
               *cursor\cursor And 
               *cursor\change = 1
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
               *cursor\cursor And 
               *cursor\change = 0
              *cursor\change = 1
              Debug "e+"
              CocoaMessage(0, NSWindow, "disableCursorRects")
              CocoaMessage(0, *cursor\cursor, "set") 
            EndIf
          EndIf
        EndIf
        
        ;       ElseIf type = #NSCursorUpdate
        ;         Debug 999999
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

; OpenWindow(0, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
; CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
; CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
; CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
; 
; ButtonGadget(-1, 60,240,60,60,"")
; Define g1,g2
; g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
; g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
; SplitterGadget(-1,10,240,60,60, g1,g2)

Procedure Resize_2( )
    Protected canvas = 2
    ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
  EndProcedure
  
  Procedure Resize_3( )
    Protected canvas = 3
    ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
  EndProcedure
  
  
  ;;events::SetCallback( @EventHandler( ) )
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
  
If setCursor(0, #PB_Default, ImageID(0))
  Debug "hand"           
EndIf       

If setCursor(1,#PB_Cursor_Hand)
  Debug "hand"           
EndIf       

If setCursor(11,#PB_Cursor_Cross)
  Debug "cross"           
EndIf       

If setCursor(g1,#PB_Cursor_IBeam)
  Debug "IBeam"           
EndIf       

If setCursor(g2,#PB_Cursor_IBeam)
  Debug "IBeam"           
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
        ;         cursor\gadgetID = GadgetID(EventGadget())
        ;         
        SetWindowTitle(0, Str(Random(255)))
        ;*lastcursor = CocoaMessage(0, 0, "NSCursor currentCursor")
        
        DisableGadget(0, #True)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----0------
; EnableXP