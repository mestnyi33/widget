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
  
  
CompilerElse
  ;   XIncludeFile "../../mac/get.pbi"
  ;   XIncludeFile "../../mac/id.pbi"
  ;   XIncludeFile "../../mac/mouse.pbi"
CompilerEndIf

;XIncludeFile "../../modules.pbi"
DeclareModule Get
  Declare.s ClassName(handle.i)
EndDeclareModule
Module Get
  Procedure.s ClassName(handle.i)
    Protected Result
    CocoaMessage(@Result, CocoaMessage(0, handle, "className"), "UTF8String")
    If Result
      ProcedureReturn PeekS(Result, -1, #PB_UTF8)
    EndIf
  EndProcedure
EndModule
;///
DeclareModule ID
  Declare.i Window(WindowID.i)
  Declare.i Gadget(GadgetID.i)
  Declare.i IsWindowID(handle.i)
  Declare.i GetWindowID(handle.i)
EndDeclareModule
Module ID
  ;   XIncludeFile "../import.pbi"
  Import ""
    PB_Window_GetID(hWnd) 
  EndImport
  
  Procedure.s ClassName(handle.i)
    Protected Result
    CocoaMessage(@Result, CocoaMessage(0, handle, "className"), "UTF8String")
    
    If Result
      ProcedureReturn PeekS(Result, - 1, #PB_UTF8)
    EndIf
  EndProcedure
  
  Procedure.i GetWindowID(handle.i) ; Return the handle of the parent window from the handle
    ProcedureReturn CocoaMessage(0, handle, "window")
  EndProcedure
  
  Procedure.i IsWindowID(handle.i)
    If ClassName(handle) = "PBWindow"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window(WindowID.i) ; Return the id of the window from the window handle
    ProcedureReturn PB_Window_GetID(WindowID)
  EndProcedure
  
  Procedure.i Gadget(GadgetID.i)  ; Return the id of the gadget from the gadget handle
    ProcedureReturn CocoaMessage(0, GadgetID, "tag")
  EndProcedure
EndModule
;///
DeclareModule Mouse
  Declare.i Window()
  Declare.i Gadget(WindowID)
EndDeclareModule
Module Mouse
  Procedure Window()
    Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
    
    ; get-WindowNumber
    CocoaMessage(@Point, 0, "NSEvent mouseLocation")
    WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
    
    ; get-NSWindow
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    ProcedureReturn NSWindow
  EndProcedure
  
  Macro GetCocoa(objectCocoa, funcCocoa, paramCocoa)
    CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  EndMacro
  
  Procedure Gadget(WindowID)
    Protected.i handle, superview, ContentView, Point.CGPoint
    
    If  WindowID 
      ContentView = CocoaMessage(0,  WindowID , "contentView")
      CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
      
      ;       ;func isMousePoint(_ point: NSPoint, in rect: NSRect) -> Bool
      ;       Debug GetCocoa(ContentView, "isMousePoint:@", @Point) 
      
      ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint
      handle = CocoaMessage(0, ContentView, "hitTest:@", @Point) ; hitTest(_:) 
                                                                 ;handle = GetCocoa(ContentView, "hitTest", Point) 
      
      If handle
        Select Get::ClassName(handle)
          Case "NSStepper" 
            CompilerIf #PB_Compiler_IsMainFile
              ;handle = CocoaMessage(0, handle, "superclass") ; NSControl
              
              ; handle = CocoaMessage(0, handle, "nextResponder") ; PB_SpinView
              ;handle = CocoaMessage(0, handle, "superview") ; PB_SpinView
              
              ;handle = CocoaMessage(0, handle, "superclass") ; NSView
              
              ;;handle = CocoaMessage(0, handle, "contentView") ; 
              ;Debug  Get::ClassName(CocoaMessage(0, handle, "subviews"));
              ;Debug  Get::ClassName(CocoaMessage(0, handle, "opaqueAncestor"));
              ;Debug  Get::ClassName(CocoaMessage(0, handle, "enclosingScrollView"));
              ;;Debug  Get::ClassName(CocoaMessage(0, handle, "superclass"));
              ;;handle = CocoaMessage(0, handle, "opaqueAncestor") ; 
              ;; handle = CocoaMessage(0, handle, "superview") ; PB_SpinView
              
              ; handle = CocoaMessage(0, handle, "NSTextView") ; PB_SpinView
              ; handle = CocoaMessage(0, handle, "NSTextField") ; PB_SpinView
              Debug  Get::ClassName(handle) 
            CompilerEndIf
            
          Case "NSTableHeaderView" 
            handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
            
          Case "NSScroller"                                 ;
                                                            ; PBScrollView
            handle = CocoaMessage(0, handle, "superview") ; NSScrollView
            
            Select Get::ClassName(handle) 
              Case "WebDynamicScrollBarsView"
                handle = CocoaMessage(0, handle, "superview") ; WebFrameView
                handle = CocoaMessage(0, handle, "superview") ; PB_WebView
                
              Case "PBTreeScrollView"
                handle = CocoaMessage(0, handle, "documentView")
                
              Case "NSScrollView"
                superview = CocoaMessage(0, handle, "superview")
                If Get::ClassName(superview) = "PBScintillaView"
                  handle = superview ; PBScintillaView
                Else
                  handle = CocoaMessage(0, handle, "documentView")
                EndIf
                
            EndSelect
            
          Case "_NSRulerContentView", "SCIContentView" 
            handle = CocoaMessage(0, handle, "superview") ; NSClipView
            handle = CocoaMessage(0, handle, "superview") ; NSScrollView
            handle = CocoaMessage(0, handle, "superview") ; PBScintillaView
            
          Case "NSView" 
            handle = CocoaMessage(0, handle, "superview") ; PB_NSBox
            
          Case "NSTextField", "NSButton"
            handle = CocoaMessage(0, handle, "superview") ; PB_DateView
            
          Case "WebHTMLView" 
            handle = CocoaMessage(0, handle, "superview") ; WebClipView
            handle = CocoaMessage(0, handle, "superview") ; WebDynamicScrollBarsView
            handle = CocoaMessage(0, handle, "superview") ; WebFrameView
            handle = CocoaMessage(0, handle, "superview") ; PB_WebView
            
          Case "PB_NSFlippedView"                           ;
                                                            ; container
            handle = CocoaMessage(0, handle, "superview") ; NSClipView
                                                            ; scrollarea
            If Get::ClassName(handle) = "NSClipView"
              handle = CocoaMessage(0, handle, "superview") ; PBScrollView
            EndIf
            ;           Default
            ;             Debug "-"  
            ;             Debug  Get::ClassName(handle) ; PB_NSTextField
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
  
  Structure _s_cursor
    icursor.a
    *hcursor
    *window
    *gadget
    change.b
  EndStructure
  
  Declare.i createCursor(ImageID.i, x.l = 0, y.l = 0)
  Declare   freeCursor(hCursor.i)
  Declare   hideCursor(state.b)
  Declare   getCursor()
  Declare   updateCursor()
  Declare   changeCursor(*cursor._s_cursor)
  Declare   setCursor(gadget.i, cursor.i, ImageID.i = 0)
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
    CGCursorIsVisible()
  EndImport
  
  
  Procedure   freeCursor(hCursor.i)
    CocoaMessage(0, hCursor, "release")
  EndProcedure
  
  Procedure   isHideCursor()
    CGCursorIsVisible()
  EndProcedure
  
  Procedure   hideCursor(state.b)
    If state
      CocoaMessage(0, 0, "NSCursor hide")
    Else
      CocoaMessage(0, 0, "NSCursor unhide")
    EndIf
  EndProcedure
  
  Procedure   getCurrentCursor()
    ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
    ProcedureReturn CocoaMessage(0, 0, "NSCursor currentCursor")
  EndProcedure
  
  Procedure   getCursor()
    Protected result.i
    ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
    
    If CGCursorIsVisible() ;  GetGadgetAttribute(EventGadget(), #PB_Canvas_CustomCursor) ; 
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
  
  Procedure.i createCursor(ImageID.i, x.l = 0, y.l = 0)
    Protected *ic, Hotspot.NSPoint
    
    If ImageID
      Hotspot\x = x
      Hotspot\y = y
      *ic = CocoaMessage(0, 0, "NSCursor alloc")
      CocoaMessage(0, *ic, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
    EndIf
    
    ProcedureReturn *ic
  EndProcedure
  
  Procedure updateCursor()
    Debug "updateCursor"
    
    If IsGadget(EventGadget())
      *cursor.cursor::_s_cursor = GetGadgetData(EventGadget())
      If *cursor And
         *cursor\hcursor 
        If *cursor\change 
          Debug "u+"
          CocoaMessage(0, WindowID(EventWindow()), "disableCursorRects")
          CocoaMessage(0, *cursor\hcursor, "set") 
        Else
          Debug "u-"
          CocoaMessage(0, WindowID(EventWindow()), "enableCursorRects")
          CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
        EndIf
      EndIf
    EndIf
    
    UnbindEvent(#PB_Event_FirstCustomValue, @UpdateCursor(), EventWindow(), EventGadget())
  EndProcedure
  
  Procedure changeCursor(*cursor._s_cursor)
    Debug "changeCursor"
    Protected gadget = *cursor\gadget
    Protected window = *cursor\window
    
;     PostEvent(#PB_Event_FirstCustomValue, window, gadget)
;     BindEvent(#PB_Event_FirstCustomValue, @UpdateCursor(), window, gadget)
    
        If *cursor\change
          Debug "u+"
          CocoaMessage(0, WindowID(window), "disableCursorRects")
          CocoaMessage(0, *cursor\hcursor, "set") 
        Else
          Debug "u-"
          CocoaMessage(0, WindowID(window), "enableCursorRects")
          CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
        EndIf
  EndProcedure
  
  Procedure setCursor(handle.i, cursor.i, ImageID.i=0)
    Protected gadget =-1, WindowID, *cursor._s_cursor
    
    If handle
      Debug "setCursor"
      ;       If GetCursor() = cursor
      ;         ProcedureReturn 0
      ;       EndIf
      If ID::IsWindowID(handle)
        window = ID::Window(handle)
        windowID = handle
      Else
        gadget = ID::Gadget(handle)
        windowID = ID::GetWindowID(handle)
      EndIf
      
      *cursor = AllocateStructure(_s_cursor)
      *cursor\icursor = cursor
      *cursor\gadget = gadget
      *cursor\window = ID::Window(windowID)
      
      If cursor >= 0
        ; if ishidden cursor show cursor
        If Not CGCursorIsVisible()
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
        
        Select cursor
            ;           Case #PB_Cursor_Default   : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
            ;           Case #PB_Cursor_IBeam     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
            ;           Case #PB_Cursor_Cross     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
            ;           Case #PB_Cursor_Hand      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
            ;           Case #PB_Cursor_UpDown    : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
            ;           Case #PB_Cursor_LeftRight : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
            
            
          Case #PB_Cursor_Invisible 
            CocoaMessage(0, 0, "NSCursor hide")
            ; SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, cursor)
            ; Case #PB_Cursor_VIBeam : *cursor\hcursor = CreateCursor(ImageID(CatchImage(#PB_Any, ?cross, ?cross_end-?cross)), -8,-8) ; CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor")
            ;*cursor\hcursor = CreateCursor(ImageID(CatchImage(#PB_Any, ?hand, ?hand_end-?hand))) ; : 
            
          Case #PB_Cursor_Busy 
            SetAnimatedThemeCursor(#kThemeWatchCursor, 0)
            
          Case #PB_Cursor_Default   : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
          Case #PB_Cursor_IBeam     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
            
          Case #PB_Cursor_Drag      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor")
          Case #PB_Cursor_Drop      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
          Case #PB_Cursor_Denied    : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
            
          Case #PB_Cursor_Cross     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
          Case #PB_Cursor_Hand      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
          Case #PB_Cursor_Grab      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor openHandCursor")
          Case #PB_Cursor_Grabbing  : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor closedHandCursor")
            
          Case #PB_Cursor_Left      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
          Case #PB_Cursor_Right     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
          Case #PB_Cursor_LeftRight : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
            
          Case #PB_Cursor_Up        : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
          Case #PB_Cursor_Down      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
          Case #PB_Cursor_UpDown    : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
        EndSelect 
      Else
        If ImageID
          *cursor\hcursor = createCursor(ImageID)
        EndIf
      EndIf
      
      If IsGadget(gadget)
        SetGadgetData(gadget, *cursor)
      EndIf
      
      If *cursor\hcursor And handle = mouse::Gadget(WindowID)
        *cursor\change = 1
        changeCursor(*cursor)
        ProcedureReturn #True
      EndIf
    EndIf
    ; CocoaMessage(0, CocoaMessage(0, GadgetID(gadget), "window"), "discardCursorRects") 
    ; CocoaMessage(0, CocoaMessage(0, GadgetID(gadget), "window"), "resetCursorRects") ; for the actived-window gadget
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

DeclareModule events
  EnableExplicit
  
  CompilerIf #PB_Compiler_IsMainFile
    Macro PB(Function)
      Function
    EndMacro
  CompilerEndIf
  
  Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
    DesktopMouseX() - GadgetX(_canvas_, _mode_)
    ; WindowMouseX(window) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
  EndMacro
  Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
    DesktopMouseY() - GadgetY(_canvas_, _mode_)
    ; WindowMouseY(window) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
  EndMacro
  
  Macro ResizeGadget(_gadget_,_x_,_y_,_width_,_height_)
    PB(ResizeGadget)(_gadget_,_x_,_y_,_width_,_height_)
    
    If *setcallback ;And GadgetType(_gadget_) = #PB_GadgetType_Canvas
      CompilerIf #PB_Compiler_IsMainFile
        Debug "resize - " + _gadget_
      CompilerEndIf
      
      CallCFunctionFast(*setcallback, _gadget_, #PB_EventType_Resize)
    EndIf
  EndMacro
  
  
  Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback
  
  Macro DraggedGadget() : events::*dragged : EndMacro
  Macro EnteredGadget() : events::*entered : EndMacro
  Macro FocusedGadget() : events::*focused : EndMacro
  Macro PressedGadget() : events::*pressed : EndMacro
  
  DraggedGadget() =- 1 
  EnteredGadget() =- 1 
  PressedGadget() =- 1 
  FocusedGadget() =- 1 
  
  Declare.i WaitEvent(event.i, second.i=0)
  Declare DrawCanvasFrame(gadget, color)
  Declare DrawCanvasBack(gadget, color)
  Declare SetCallBack(*callback)
EndDeclareModule
Module events
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
  
  Global event_window =- 1
  Global event_gadget =- 1
  
  ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  EndImport
  
  ;       ;
  ;       ; callback function
  ;       ;
  Procedure EventWindowActivate()
    Protected Point.NSPoint
    event_window = EventWindow()
    Protected NSWindow = WindowID(event_window) 
    
    If NSWindow
      Protected EnteredID = Mouse::Gadget(NSWindow)
      
      If EnteredID
        event_gadget = ID::Gadget(EnteredID)
        
        If IsGadget(event_gadget)
          PostEvent(#PB_Event_Gadget , event_window, event_gadget, #PB_EventType_LeftButtonDown)
          SetActiveGadget(event_gadget)
        EndIf
      EndIf
    EndIf
  EndProcedure
  
  ;       Procedure WindowNumber(WindowID)
  ;         ProcedureReturn CocoaMessage(0, WindowID, "windowNumber")
  ;       EndProcedure
  ;       
  ;       Procedure NSWindow(NSApp, WindowNumber)
  ;         ProcedureReturn CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
  ;       EndProcedure
  
  ProcedureC  eventTapFunction(proxy, eType, event, refcon)
    Protected Point.CGPoint
    Protected *cursor.cursor::_s_cursor = #Null
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    
    If refcon And NSEvent
      Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
      Protected MouseMove, MouseX, MouseY, MoveStart, LeftDoubleClick, EnteredID, gadget =- 1
      
      If eType = #NSLeftMouseDown
        MouseDrag = 1
      ElseIf eType = #NSLeftMouseUp
        MouseDrag = 0
        If EnteredGadget() >= 0 
          If DraggedGadget() >= 0 And DraggedGadget() = PressedGadget() 
            CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
              CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_Drop)
            CompilerEndIf
          EndIf
          
          If Not (LeftDoubleClickTime And ElapsedMilliseconds() - LeftDoubleClickTime < DoubleClickTime())
            LeftDoubleClickTime = ElapsedMilliseconds() 
          Else
            LeftDoubleClick = 1
          EndIf
        EndIf
      EndIf
      
      If MouseDrag >= 0 
        EnteredID = Mouse::Gadget(Mouse::Window())
      EndIf
      
      ;
      If EnteredID
        gadget = ID::Gadget(EnteredID)
        
        If gadget >= 0
          Mousex = GadgetMouseX(gadget)
          Mousey = GadgetMouseY(gadget)
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
        
        If PressedGadget() >= 0
          Mousex = GadgetMouseX(PressedGadget())
          Mousey = GadgetMouseY(PressedGadget())
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
           EnteredGadget() <> gadget
          If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
            If Not MouseDrag
              *cursor.cursor::_s_cursor = GetGadgetData(EnteredGadget())
              If *cursor And 
                 *cursor\hcursor And 
                 *cursor\change = 1
                *cursor\change = 0
                Debug "e-" ;+ NSWindow + " " + ID::Window(NSWindow)
                
                Cursor::changeCursor(*cursor)
              EndIf
            EndIf
            
            CallCFunctionFast(refcon, EnteredGadget() , #PB_EventType_MouseLeave)
          EndIf
          
          EnteredGadget() = gadget
          
          If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
            If Not MouseDrag
              *cursor.cursor::_s_cursor = GetGadgetData(EnteredGadget())
              If *cursor And
                 *cursor\hcursor And 
                 *cursor\change = 0
                *cursor\change = 1
                Debug "e+"
                
                Cursor::changeCursor(*cursor)
              EndIf
            EndIf
            
            CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseEnter)
          EndIf
        Else
          ; mouse drag start
          If MouseDrag > 0
            If EnteredGadget() >= 0 And
               DraggedGadget() <> PressedGadget()
              DraggedGadget() = PressedGadget()
              CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_DragStart)
              DeltaX = GadgetX(PressedGadget()) 
              DeltaY = GadgetY(PressedGadget())
            EndIf
          EndIf
          
          If MouseDrag And EnteredGadget() <> PressedGadget()
            CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_MouseMove)
          EndIf
          
          If EnteredGadget() >= 0
            CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseMove)
            
            ; if move gadget x&y position
            If MouseDrag > 0 And PressedGadget() = EnteredGadget() 
              If DeltaX <> GadgetX(PressedGadget()) Or 
                 DeltaY <> GadgetY(PressedGadget())
                MouseDrag =- 1
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If eType = #NSLeftMouseDown
        PressedGadget() = EnteredGadget() ; EventGadget()
                                            ;Debug CocoaMessage(0, Mouse::Window(), "focusView")
        
        If PressedGadget() >= 0
          If FocusedGadget() =- 1
            FocusedGadget() = PressedGadget() ; GetActiveGadget()
            If GadgetType(FocusedGadget()) = #PB_GadgetType_Canvas
              CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
            EndIf
          EndIf
          
          If FocusedGadget() >= 0 And 
             FocusedGadget() <> PressedGadget()
            CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_LostFocus)
            
            FocusedGadget() = PressedGadget()
            CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
          EndIf
          
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonDown)
        EndIf
      EndIf
      
      ;
      If eType = #NSLeftMouseUp
        If PressedGadget() >= 0 And 
           PressedGadget() <> gadget  
          *cursor.cursor::_s_cursor = GetGadgetData(PressedGadget())
          If *cursor And
             *cursor\hcursor And 
             *cursor\change = 1
            *cursor\change = 0
            ;Debug "p-"
            
            Cursor::changeCursor(*cursor)
          EndIf
        EndIf
        
        If gadget >= 0 And 
           gadget <> PressedGadget()
          EnteredGadget() = gadget
          *cursor.cursor::_s_cursor = GetGadgetData(gadget)
          If *cursor And
             *cursor\hcursor
            *cursor\change = 1
            ;Debug "p+"
            
            Cursor::changeCursor(*cursor)
          EndIf
        EndIf
        
        If PressedGadget() >= 0 
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonUp)
          
          If LeftDoubleClick
            CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftDoubleClick)
          Else
            If PressedGadget() <> DraggedGadget()
              If PressedGadget() >= 0 And EnteredID = GadgetID(PressedGadget())
                CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftClick)
              EndIf
            EndIf
          EndIf
        EndIf
        
        ; PressedGadget() =- 1
        DraggedGadget() =- 1
      EndIf
      
      ;         ;
      ;         If eType = #PB_EventType_LeftDoubleClick
      ;           CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_LeftDoubleClick)
      ;         EndIf
      
      If eType = #NSScrollWheel
        ;NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        
        If NSEvent
          Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
          Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
          
          If scrollX And Not scrollY
            ; Debug "X - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
                CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelX, scrollX)
              CompilerEndIf
            EndIf
          EndIf
          
          If scrollY And Not scrollX
            ; Debug "Y - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
                CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelY, scrollY)
              CompilerEndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      ;           If eType = #PB_EventType_Resize
      ;             ; CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Resize)
      ;           EndIf
      ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
      ;             If eType = #PB_EventType_Repaint
      ;               CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Repaint)
      ;             EndIf
      ;           CompilerEndIf
      ;           
    EndIf
    
  EndProcedure
  
  Procedure   DrawCanvasBack(gadget, color)
    If GadgetType(gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(), OutputHeight(), color)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure   DrawCanvasFrame(gadget, color)
    If GadgetType(gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(gadget))
      If GetGadgetState(gadget)
        DrawImage(0,0, GetGadgetState(gadget))
      EndIf
      If Not color
        color = Point(10,10)
      EndIf
      If color 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0,0,OutputWidth(), OutputHeight(), color)
      EndIf
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i WaitEvent(event.i, second.i=0)
    Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY
    Protected MouseMove, MouseX, MouseY, MoveStart
    Protected EnteredID, Canvas =- 1, EventType =- 1
    
    If MouseDrag Or Event() = #PB_Event_Gadget
      ;             If EventType = #PB_EventType_Repaint
      CallCFunctionFast(*setcallback, EventGadget(), EventType())
      ;             EndIf
      
    EndIf
    
    ProcedureReturn event
  EndProcedure
  
  Procedure   SetCallBack(*callback)
    *setcallback = *callback
    
    Protected mask, EventTap
    mask = #NSMouseMovedMask | #NSScrollWheelMask
    mask | #NSMouseEnteredMask | #NSMouseExitedMask 
    mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask 
    mask | #NSRightMouseDownMask | #NSRightMouseDownMask 
    mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask   ;| #NSCursorUpdateMask
    
    #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
    #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
    #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
    
    #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
    #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
    
    EventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
    
    ;         GetCurrentProcess(@psn.q)
    ;         eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction(), *callback)
    
    If EventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", EventTap, "forMode:$", @"kCFRunLoopDefaultMode")
    EndIf
    
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  UseModule constants
  ;UseModule events
  
  Define event
  Define g1,g2
  
  Procedure Resize_2()
    Protected canvas = 2
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure Resize_3()
    Protected canvas = 3
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    Protected window = EventWindow()
    Protected dropx, dropy
    Static deltax, deltay
    
    Select eventtype
      Case #PB_EventType_MouseWheelX
        Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
        
      Case #PB_EventType_MouseWheelY
        Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
        
      Case #PB_EventType_DragStart
        deltax = events::GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
        deltay = events::GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
        Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
              
      Case #PB_EventType_Drop
        dropx = events::GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
        dropy = events::GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
        Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
        
      Case #PB_EventType_Focus
        Debug ""+eventobject + " #PB_EventType_Focus " 
        events::DrawCanvasBack(eventobject, $FFA7A4)
        events::DrawCanvasFrame(eventobject, $2C70F5)
        
      Case #PB_EventType_LostFocus
        Debug ""+eventobject + " #PB_EventType_LostFocus " 
        events::DrawCanvasBack(eventobject, $FFFFFF)
        
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
        events::DrawCanvasFrame(eventobject, $2C70F5)
       
      Case #PB_EventType_MouseLeave
        Debug ""+eventobject + " #PB_EventType_MouseLeave "
        events::DrawCanvasFrame(eventobject, 0)
        
      Case #PB_EventType_Resize
        Debug ""+eventobject + " #PB_EventType_Resize " 
        
      Case #PB_EventType_MouseMove
        If events::DraggedGadget() = 1
          Debug ""+eventobject + " #PB_EventType_MouseMove " 
          ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        ;         If events::DraggedGadget() = 0
        ;           ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         EndIf
        
    EndSelect
  EndProcedure
  
  Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
    Protected result = OpenWindow(window, x,y,width,height, title.s, flag)
    If window >= 0
      WindowID = WindowID(window)
    Else
      WindowID = result
    EndIf
    Debug 77
    ;CocoaMessage(0, WindowID, "disableCursorRects")
    ProcedureReturn result
  EndProcedure
  
  Macro OpenWindow(window, x,y,width,height, title, flag=0)
    OpenWindow_(window, x,y,width,height, title, flag)
  EndMacro
  
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  ; If setCursor(GadgetID(111),#PB_Cursor_UpDown)
  ;   Debug "updown"           
  ; EndIf       
  
  If cursor::setCursor(GadgetID(100),#PB_Cursor_Hand)
    Debug "setCursorHand"           
  EndIf       
  
  If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If cursor::setCursor(GadgetID(g2),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
    MessageRequester("Error",
                     "Loading of image World.png failed!",
                     #PB_MessageRequester_Error)
    End
  EndIf
  If cursor::setCursor(GadgetID(0), #PB_Default, ImageID(0))
    Debug "setCursorImage"           
  EndIf       
  
  If cursor::setCursor(GadgetID(1),#PB_Cursor_Hand)
    Debug "setCursorHand - " +CocoaMessage(0, 0, "NSCursor currentCursor")
  EndIf       
  
  If cursor::setCursor(GadgetID(11),#PB_Cursor_Cross)
    Debug "setCursorCross"           
  EndIf       
  
  
  
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=StringGadget(-1,0,0,0,0,"StringGadget")
  g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
  
;   If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
;     Debug "setCursorIBeam"           
;   EndIf       
;   
;   If cursor::setCursor(GadgetID(g2),#PB_Cursor_Hand)
;     Debug "setCursorHand"           
;   EndIf       
;   
;   If cursor::setCursor(GadgetID(2),#PB_Cursor_UpDown)
;     Debug "setCursorHand"           
;   EndIf       
  
  
  
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
  
  If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
;   If cursor::setCursor(GadgetID(g2),#PB_Cursor_IBeam)
;     Debug "setCursorIBeam"           
;   EndIf       
  
  
  ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
  events::SetCallback(@EventHandler())
  
  Repeat 
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --f---------------f------
; EnableXP