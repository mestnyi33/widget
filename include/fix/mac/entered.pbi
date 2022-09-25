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
  Declare.i IsWindowID(WindowID.i)
  Declare.i GetWindowID(GadgetID.i)
  Macro GetWindow(Gadget)
    ID::Window(ID::GetWindowID(GadgetID(gadget)))
    ;PB_Window_GetID(CocoaMessage(0, GadgetID(gadget), "window"))
  EndMacro
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
  
  Procedure.i GetWindowID(GadgetID.i) ; Return the handle of the parent window from the GadgetID
    ProcedureReturn CocoaMessage(0, GadgetID, "window")
  EndProcedure
  
  Procedure.i IsWindowID(WindowID.i)
    ProcedureReturn Bool(ClassName(WindowID) = "PBWindow")
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
  ;   Macro GetCocoa(objectCocoa, funcCocoa, paramCocoa)
  ;     CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  ;   EndMacro
  
  ;   Procedure CocoaNSApp()
  ;     ProcedureReturn CocoaMessage(0, 0, "NSApplication sharedApplication")
  ;   EndProcedure
  ;   
  ;   Procedure CocoaWindowNumber(CocoaNSWindow)
  ;     ProcedureReturn CocoaMessage(0, CocoaNSWindow, "windowNumber")
  ;   EndProcedure
  ;   
  ;   Procedure CocoaNSWindow(CocoaNSApp, CocoaWindowNumber)
  ;     ProcedureReturn CocoaMessage(0, CocoaNSApp, "windowWithWindowNumber:", CocoaWindowNumber)
  ;   EndProcedure
  ;   
  Procedure Window()
    Protected.i NSApp, WindowID, WindowNumber, Point.CGPoint
    
    ; get-WindowNumber
    CocoaMessage(@Point, 0, "NSEvent mouseLocation")
    WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
    
    ; get-NS-WindowID
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    WindowID = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    ProcedureReturn WindowID
  EndProcedure
  
  Procedure Gadget(WindowID)
    Protected.i handle, superview, ContentView, Point.CGPoint
    
    If  WindowID 
      ContentView = CocoaMessage(0,  WindowID , "contentView")
      CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
      
      ;       ;func isMousePoint(_ point: NSPoint, in rect: NSRect) -> Bool
      ;       Debug GetCocoa(ContentView, "isMousePoint", Point) 
      
      ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint
      handle = CocoaMessage(0, ContentView, "hitTest:@", @Point) ; hitTest(_:) 
                                                                 ;handle = GetCocoa(ContentView, "hitTest", Point) 
      
      If handle
        Select Get::ClassName(handle)
          Case "NSStepper" 
            handle = CocoaMessage( 0, handle, "superview" )     ; PB_SpinView
            handle = CocoaMessage(0, handle, "subviews")
            handle = CocoaMessage(0, handle, "objectAtIndex:", 0)
            
          Case "NSTableHeaderView" 
            handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
            
          Case "NSScroller"                                 ;
                                                            ; PBScrollView
            handle = CocoaMessage(0, handle, "superview")   ; NSScrollView
                                                            ;
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
            handle = CocoaMessage(0, handle, "superview")   ; NSClipView
                                                            ; scrollarea
            If Get::ClassName(handle) = "NSClipView"        ;
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
      *cursor.cursor::_s_cursor = objc_getAssociatedObject_(GadgetID(EventGadget()), "__cursor") ; GetGadgetData(EventGadget())
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
      ;;CocoaMessage(0, GadgetID(gadget), "disableCursorRects")
      ;Debug CocoaMessage(0,  WindowID(window), "areCursorRectsEnabled")
      ;CocoaMessage(0, WindowID(window), "resetCursorRects")
      ;CocoaMessage(0, WindowID(window), "discardCursorRects")
      CocoaMessage(0, WindowID(window), "disableCursorRects")
      ; CocoaMessage(0,  GadgetID(gadget), "NSView invalidateCursorRects")
      ; CocoaMessage(0, *cursor\hcursor, "push") 
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
         objc_setAssociatedObject_(handle, "__cursor", *cursor, 0) ; SetGadgetData(gadget, *cursor)
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

;///
DeclareModule Parent
  Declare GetParentID(handle.i)
  Declare GetWindowID(handle.i)
  
  Declare SetCallBack(*callback)
  
  
  
  Declare GetWindow(gadget.i)
  Declare GetParent(gadget.i)
  Declare SetParent(gadget.i, ParentID.i, Item.i = #PB_Default)
EndDeclareModule
Module Parent
  Procedure.i GetWindowID(GadgetID.i) ; Return the handle of the parent window from the GadgetID
    ProcedureReturn CocoaMessage(0, GadgetID, "window")
  EndProcedure
  
  Procedure GetParentID(handle.i) ; Return the handle of the parent from the gadget handle
    Protected WindowID = GetWindowID(handle)
    
    While handle 
      handle = CocoaMessage(0, handle, "superview")
      
      If Not handle 
        ProcedureReturn WindowID
      EndIf
      
      If ID::Gadget(handle) >= 0
        ProcedureReturn handle
      EndIf
    Wend
  EndProcedure
  
  Procedure GetWindow(gadget.i) ; Return the id of the parent window from the gadget id
    If IsGadget(gadget)
      ProcedureReturn ID::Window(GetWindowID(GadgetID(gadget)))
    EndIf
  EndProcedure
  
  Procedure GetParent(gadget.i) ; Return the id of the parent gadget from the gadget id
    If IsGadget(gadget)
      Protected gadgetID = GadgetID(gadget)  
      Protected handle = GetParentID(gadgetID)
      Protected WindowID = GetWindowID(gadgetID)
      
      If WindowID = handle
        ProcedureReturn - 1 ; ID::Window(handle)
      Else
        ProcedureReturn ID::Gadget(handle)
      EndIf
    EndIf
  EndProcedure
  
  Macro is_at_box_( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
    Bool(Bool( _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 ) And 
         Bool( _mouse_x_ >= _position_x_ And _mouse_x_ < ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 ) )
  EndMacro
  
  
  Procedure SetParent(gadget.i, ParentID.i, Item.i = #PB_Default) ; Set a new parent for the gadget
    If IsGadget(gadget)
      Protected i = item
      Protected GadgetID = GadgetID(gadget)
      
      If ParentID
        Select GadgetType(gadget)
          Case #PB_GadgetType_ListView,                               ; PBListViewTableView    -> NSClipView -> NSScrollView
               #PB_GadgetType_Editor,                                 ; PBEditorGadgetTextView -> NSClipView -> NSScrollView
               #PB_GadgetType_ListIcon,                               ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerList,                           ; PB_NSTableView         -> NSClipView -> NSScrollView
               #PB_GadgetType_ExplorerTree,                           ; PB_NSOutlineView       -> NSClipView -> NSScrollView
               #PB_GadgetType_Tree,                                   ; PBTreeOutlineView      -> NSClipView -> PBTreeScrollView
               #PB_GadgetType_Web                                     ; PB_WebView             -> NSClipView -> PBWebScrollView
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
          Case #PB_GadgetType_Spin,                                   ; PB_NSTextField         -> PB_SpinView
               #PB_GadgetType_Scintilla                               ; PBScintillaView        -> NSBox
            GadgetID = CocoaMessage(0, GadgetID, "superview")       
        EndSelect
        
        Select Get::ClassName(ParentID)
          Case "PBTabView"
            Protected parent = ID::gadget(ParentID)
            If item <> #PB_Default 
              Protected selectedTabViewItem = CocoaMessage(0, ParentID, "selectedTabViewItem")
              ; i = GetGadgetState(parent)
              i = CocoaMessage(0, ParentID, "indexOfTabViewItem:@", @selectedTabViewItem)
            EndIf
            If i <> item 
              SetGadgetState(parent, item)
              ;;CocoaMessage(0, GadgetID(parent), "selectTabViewItem:", item)
            EndIf
            ParentID = CocoaMessage(0, ParentID, "subviews")
            ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
            If i <> item 
              ;;Debug  CocoaMessage(0, gadgetID(parent), "selectedItem")
              SetGadgetState(parent, i)
              ;                 CocoaMessage(0, gadgetID(parent), "tabView:", i)
              
              ;              CocoaMessage(0, GadgetID(parent), "selectTabViewItem:@", @i)
              ;  CocoaMessage(0, GadgetID(parent), "selectTabViewItem:", i)
            EndIf
          Case "PB_CanvasView"
            ParentID = CocoaMessage(0, ParentID, "subviews")
            ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
          Case "PBSplitterView"
            Protected first, Second
            parent = ID::gadget(ParentID)
            first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
            Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
            
            
            Debug ""+gadget +" - "+ parent +" "+ GadgetX(first, #PB_Gadget_ScreenCoordinate) +" "+ DesktopMouseX()
            
            If is_at_box_(GadgetX(first, #PB_Gadget_ScreenCoordinate),GadgetY(first, #PB_Gadget_ScreenCoordinate),GadgetHeight(first),GadgetWidth(first),DesktopMouseX(),DesktopMouseY())
              Debug 5555555
            EndIf
            
            ;             Select Item ; ID::Gadget(Mouse::Gadget(ID::GetWindowID(ParentID)))
            ;               Case first
            ;                 Debug "parent "+parent
            ;                 SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, gadget)
            ;                 Parent::SetParent(first, GadgetID(gadget))
            ;               Case Second
            ;                 SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, gadget)
            ;                 Parent::SetParent(Second, GadgetID(gadget))
            ;                 Debug 2222
            ;             EndSelect
            Select Item 
              Case 1
                Debug 1111
                SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, gadget)
                Parent::SetParent(first, GadgetID(gadget))
              Case 2
                SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, gadget)
                Parent::SetParent(Second, GadgetID(gadget))
                Debug 2222
            EndSelect
            
            ;             ParentID = CocoaMessage(0, ParentID, "subviews")
            ;             ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
            ProcedureReturn 0
          Default
            ParentID = CocoaMessage(0, ParentID, "contentView")
        EndSelect
        
        CocoaMessage (0, ParentID, "addSubview:", GadgetID) 
      Else
        ; to desktop move
      EndIf
      
      ProcedureReturn ParentID
    EndIf
  EndProcedure
  
  Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback
  
  Macro DraggedGadget() : *dragged : EndMacro
  Macro EnteredGadget() : *entered : EndMacro
  Macro FocusedGadget() : *focused : EndMacro
  Macro PressedGadget() : *pressed : EndMacro
  
  Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
    DesktopMouseX() - GadgetX(_canvas_, _mode_)
    ; WindowMouseX(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
  EndMacro
  Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
    DesktopMouseY() - GadgetY(_canvas_, _mode_)
    ; WindowMouseY(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
  EndMacro
  
  
  DraggedGadget() =- 1 
  EnteredGadget() =- 1 
  PressedGadget() =- 1 
  FocusedGadget() =- 1 
  
  ProcedureC  eventTapFunction(proxy, eType, event, refcon)
    Protected Point.CGPoint
    Protected *cursor.cursor::_s_cursor = #Null
    Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    ;Protected NSEnter = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    
    If refcon And NSEvent
      Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
      Protected MouseMove, MouseX, MouseY, MoveStart, LeftDoubleClick, EnteredID, gadget =- 1
      
      ;       If eType = #NSMouseEntered
      ;         Debug "en "+proxy+" "+CocoaMessage(0, CocoaMessage(0, NSEvent, "window"), "contentView") +" "+CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      ;       If eType = #NSMouseExited
      ;         Debug "le "+proxy+" "+ CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      If eType = #NSLeftMouseDown
        ;Debug CocoaMessage(0, Mouse::Gadget(Mouse::Window()), "pressedMouseButtons")
        MouseDrag = 1
      ElseIf eType = #NSLeftMouseUp
        MouseDrag = 0
;         If EnteredGadget() >= 0 
;           If DraggedGadget() >= 0 And DraggedGadget() = PressedGadget() 
;             CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
;               CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_Drop)
;             CompilerEndIf
;           EndIf
;           
;           If Not (LeftDoubleClickTime And ElapsedMilliseconds() - LeftDoubleClickTime < DoubleClickTime())
;             LeftDoubleClickTime = ElapsedMilliseconds() 
;           Else
;             LeftDoubleClick = 1
;           EndIf
;         EndIf
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
              *cursor.cursor::_s_cursor = objc_getAssociatedObject_(GadgetID(EnteredGadget()), "__cursor") ; GetGadgetData(EnteredGadget())
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
              *cursor.cursor::_s_cursor = objc_getAssociatedObject_(GadgetID(EnteredGadget()), "__cursor") ; GetGadgetData(EnteredGadget())
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
          *cursor.cursor::_s_cursor = objc_getAssociatedObject_(GadgetID(PressedGadget()), "__cursor") ; GetGadgetData(PressedGadget())
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
          *cursor.cursor::_s_cursor = objc_getAssociatedObject_(GadgetID(EnteredGadget()), "__cursor") ; GetGadgetData(gadget)
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
      
; ;       If eType = #NSScrollWheel
; ;         ;NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
; ;         
; ;         If NSEvent
; ;           Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
; ;           Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
; ;           
; ;           If scrollX And Not scrollY
; ;             ; Debug "X - scroll"
; ;             If EnteredGadget() >= 0
; ;               CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
; ;                 CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelX, scrollX)
; ;               CompilerEndIf
; ;             EndIf
; ;           EndIf
; ;           
; ;           If scrollY And Not scrollX
; ;             ; Debug "Y - scroll"
; ;             If EnteredGadget() >= 0
; ;               CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
; ;                 CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelY, scrollY)
; ;               CompilerEndIf
; ;             EndIf
; ;           EndIf
; ;         EndIf
; ;       EndIf
      
      
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
  ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  EndImport
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
    
    
    ; GetCurrentProcess(@psn.q): eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction(), *callback)
    eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
    
    If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
    EndIf
    
  EndProcedure
  
  ;SetCallBack(0)
EndModule




CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i
  
  Procedure scrolled()
    
  EndProcedure
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    Protected window = EventWindow()
    Static parentID, parent =-1, first=-1, second=-1
    
    If eventobject <> 315
      Select eventtype
        Case #PB_EventType_MouseEnter
          Debug ""+eventobject + " #PB_EventType_MouseEnter "
;           parentID = Parent::GetParentID(GadgetID(eventobject))
;           
;           If Not ID::IsWindowID(parentID)
;             parent = ID::Gadget(parentID)
;           Else
;             parent=-1
;           EndIf
;           
;           If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
;             first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
;             Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
;             
;             If first = eventobject
;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
;             ElseIf Second = eventobject
;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
;             EndIf
;             Parent::SetParent(eventobject, GadgetID(315))
;           Else
;             Parent::SetParent(315, parentID)
;             ResizeGadget(315, GadgetX(eventobject)-1, GadgetY(eventobject)-1, GadgetWidth(eventobject)+2, GadgetHeight(eventobject)+2)
;             ResizeGadget(eventobject, 1, 1, #PB_Ignore, #PB_Ignore)
;             Parent::SetParent(eventobject, GadgetID(315))
;           EndIf
;           
;           Cursor::setCursor(GadgetID(eventobject), #PB_Cursor_Hand)
           PostEvent(#PB_Event_Gadget, EventWindow(), eventobject, eventtype, eventdata)
       
        Case #PB_EventType_MouseLeave
          Debug ""+eventobject + " #PB_EventType_MouseLeave "
;             If first = eventobject
;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
;               first =- 1
;             ElseIf Second = eventobject
;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
;               Second =- 1
;             Else
;               ResizeGadget(eventobject, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
;               Parent::SetParent(eventobject, parentID)
; ;              ResizeGadget(Parent, 0,0,0,0)
;             EndIf
          PostEvent(#PB_Event_Gadget, EventWindow(), eventobject, eventtype, eventdata)
      EndSelect
    EndIf
  EndProcedure
  
  Parent::SetCallBack(@EventHandler())
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define WindowID = UseGadgetList(0)
    ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
    StringGadget(#PB_GadgetType_String, 5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
    CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
    OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
    ListViewGadget(#PB_GadgetType_ListView, 5, 505, 160,95) : AddGadgetItem(#PB_GadgetType_ListView, -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ListView, i, "item_"+Str(i)) : Next
    FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
    ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 105, 160,95) : AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ComboBox, i, "item_"+Str(i)) : Next : SetGadgetState(#PB_GadgetType_ComboBox, 0) 
    ImageGadget(#PB_GadgetType_Image, 170, 205, 160,95, 0, #PB_Image_Border ) 
    HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    ContainerGadget(#PB_GadgetType_Container, 170, 405, 160,95, #PB_Container_Flat )
    OptionGadget(101, 10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetGadgetState(101, 1)  
    OptionGadget(102, 10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
    CloseGadgetList()
    ListIconGadget(#PB_GadgetType_ListIcon,170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
    
    IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,95 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    
    ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 105, 160,95,0,100) : SetGadgetState(#PB_GadgetType_ProgressBar, 50)
    ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 205, 160,95,0,100,0) : SetGadgetState(#PB_GadgetType_ScrollBar, 40)
    ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) :  ButtonGadget(201, 0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) :  ButtonGadget(202, 180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseGadgetList()
    TrackBarGadget(#PB_GadgetType_TrackBar, 335, 405, 160,95,0,21, #PB_TrackBar_Ticks) : SetGadgetState(#PB_GadgetType_TrackBar, 11)
    WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" )
    
    ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, ImageID(0), 1)
    CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
    ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    
    ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    SpinGadget(#PB_GadgetType_Spin, 665, 105, 160,95,20,100)
    
    TreeGadget(#PB_GadgetType_Tree, 665, 205, 160, 95 ) 
    AddGadgetItem(#PB_GadgetType_Tree, -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Tree, i, "item_"+Str(i)) : Next
    ButtonGadget(-1,665+10,205+5,50,35, "444444") 
    
    PanelGadget(#PB_GadgetType_Panel,665, 305, 160,95) 
    AddGadgetItem(#PB_GadgetType_Panel, -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
    ButtonGadget(255, 0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Panel, i, "item_"+Str(i)) : ButtonGadget(-1,10,5,50,35, "butt_"+Str(i)) : Next 
    CloseGadgetList()
    
    OpenGadgetList(#PB_GadgetType_Panel, 1)
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ButtonGadget(-1,10,5,50,35, "butt_1") 
    CloseGadgetList()
    CloseGadgetList()
    CloseGadgetList()
    SetGadgetState( #PB_GadgetType_Panel, 4)
    
    SpinGadget(301, 0, 0, 100,20,0,10)
    SpinGadget(302, 0, 0, 100,20,0,10)                 
    SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, 301, 302)
    
    InitScintilla()
    ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container )
    CloseGadgetList()
    
    ContainerGadget(315,0,0,0,0);, #PB_Container_Flat) 
    SetGadgetColor(315, #PB_Gadget_BackColor, RGB(255, 0, 0))
    CloseGadgetList()
    
    Define enGadget=-1,leGadget=-1,parent =-1, first=-1, second=-1
    Define handle,parentID, eventobject=-1
    
     ;; Cursor::setCursor(GadgetID(1), #PB_Cursor_Hand)
          
    Repeat
      Define  Event = WaitWindowEvent()
;       handle = Mouse::Gadget( Mouse::Window( ) )
;       If handle
;         enGadget = ID::Gadget( handle )
;         
;         If leGadget <> enGadget
;           If leGadget >= 0 And leGadget <> 315 
;             If first = leGadget
;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
;               first =- 1
;             ElseIf Second = leGadget
;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
;               Second =- 1
;             Else
;               ResizeGadget(leGadget, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
;               Parent::SetParent(leGadget, parentID)
;             EndIf
;           EndIf
;           
;           leGadget = enGadget
;           
;           If enGadget >= 0  And enGadget <> 315 
;           parentID = Parent::GetParentID(GadgetID(enGadget))
;           If Not ID::IsWindowID(parentID)
;             parent = ID::Gadget(parentID)
;           Else
;             parent=-1
;           EndIf
;           
;           If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
;             first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
;             Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
;             
;             If first = leGadget
;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
;             ElseIf Second = leGadget
;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
;             EndIf
;             Parent::SetParent(leGadget, GadgetID(315))
;           Else
;             Parent::SetParent(315, parentID)
;             ResizeGadget(315, GadgetX(leGadget)-1, GadgetY(leGadget)-1, GadgetWidth(leGadget)+2, GadgetHeight(leGadget)+2)
;             ResizeGadget(leGadget, 1, 1, #PB_Ignore, #PB_Ignore)
;             Parent::SetParent(leGadget, GadgetID(315))
;           EndIf
;           
;           Cursor::setCursor(GadgetID(leGadget), #PB_Cursor_Hand)
;         EndIf
;         ;Debug ""+ leGadget
;         EndIf
;       EndIf
;       
      
      Select event 
        Case #PB_Event_Gadget
          eventobject = EventGadget()
          If eventobject <> 315
          If EventType() = #PB_EventType_MouseEnter
            parentID = Parent::GetParentID(GadgetID(eventobject))
            
            If Not ID::IsWindowID(parentID)
              parent = ID::Gadget(parentID)
            Else
              parent=-1
            EndIf
            
            If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
              first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
              Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
              
              If first = eventobject
                SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
              ElseIf Second = eventobject
                SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
              EndIf
              Parent::SetParent(eventobject, GadgetID(315))
            Else
              Parent::SetParent(315, parentID)
              ResizeGadget(315, GadgetX(eventobject)-1, GadgetY(eventobject)-1, GadgetWidth(eventobject)+2, GadgetHeight(eventobject)+2)
              ResizeGadget(eventobject, 1, 1, #PB_Ignore, #PB_Ignore)
              Parent::SetParent(eventobject, GadgetID(315))
            EndIf
            
            Cursor::setCursor(GadgetID(eventobject), #PB_Cursor_Cross)
          EndIf
          If EventType() = #PB_EventType_MouseLeave
            If first = eventobject
              SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
              first =- 1
            ElseIf Second = eventobject
              SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
              Second =- 1
            Else
              ResizeGadget(eventobject, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
              Parent::SetParent(eventobject, parentID)
              ;              ResizeGadget(Parent, 0,0,0,0)
            EndIf
          EndIf
        EndIf
      EndSelect
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --v--------------------
; EnableXP