CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  ;-
  DeclareModule ID
    Declare.i Gadget( GadgetID.i )
  EndDeclareModule
  
  Module ID
    Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
      Protected Gadget = #PB_All
      If GadgetID
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Gadget = GetProp_( GadgetID, "PB_ID" )
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          Gadget = CocoaMessage(0, GadgetID, "tag")
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          Gadget = g_object_get_data_( GadgetID, "pb_id" ) - 1 
        CompilerEndIf
      EndIf
      ;
      If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
        ProcedureReturn Gadget
      Else
        ProcedureReturn #PB_All
      EndIf
    EndProcedure
  EndModule
  
  ;-
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    DeclareModule mouse
      Declare.i Window( )
      Declare.i Gadget( WindowID )
    EndDeclareModule
    
    Module mouse
      Procedure.s ClassName( handle.i )
        Protected Result
        CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
        If Result
          ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
        EndIf
      EndProcedure
      
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
      
      Procedure Gadget( WindowID )
        Protected.i handle, superview, ContentView, Point.CGPoint
        
        If  WindowID 
          ContentView = CocoaMessage(0,  WindowID , "contentView")
          CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
          
          ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint ; hitTest(_:) 
          handle = CocoaMessage(0, ContentView, "hitTest:@", @Point)
          
          If handle
            Select ClassName(handle)
              Case "PBFlippedWindowView"
                handle = 0
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
                Select ClassName(handle) 
                  Case "WebDynamicScrollBarsView"
                    handle = CocoaMessage(0, handle, "superview") ; WebFrameView
                    handle = CocoaMessage(0, handle, "superview") ; PB_WebView
                    
                  Case "PBTreeScrollView"
                    handle = CocoaMessage(0, handle, "documentView")
                    
                  Case "NSScrollView"
                    superview = CocoaMessage(0, handle, "superview")
                    If ClassName(superview) = "PBScintillaView"
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
                If ClassName(handle) = "NSClipView"             ;
                  handle = CocoaMessage(0, handle, "superview") ; PBScrollView
                EndIf
                ;           Default
                ;             Debug "-"  
                ;             Debug  Get::ClassName(handle) ; PB_NSTextField
                ;             Debug "-"
            EndSelect
          EndIf
        EndIf
        
        ;Debug ClassName(handle)
        ProcedureReturn handle
      EndProcedure
    EndModule
    
    ;-
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
    DeclareModule mouse
      Declare.i Window( )
      Declare.i Gadget( WindowID )
      Declare.i Handle( WindowID )
    EndDeclareModule
    
    Module mouse
      Procedure.s ClassName( handle.i )
        Protected Class$ = Space( 16 )
        GetClassName_( handle, @Class$, Len( Class$ ) )
        ProcedureReturn Class$
      EndProcedure
      
      Procedure Window( )
        Protected Cursorpos.q, handle
        GetCursorPos_( @Cursorpos )
        handle = WindowFromPoint_( Cursorpos )
        ProcedureReturn GetAncestor_( handle, #GA_ROOT )
      EndProcedure
      
      Procedure Gadget1( WindowID )
        Protected Cursorpos.q, handle, GadgetID
        GetCursorPos_( @Cursorpos )
        
        If WindowID
          GadgetID = WindowFromPoint_( Cursorpos )
          
          If IsGadget( ID::Gadget( GadgetID ) )
            handle = GadgetID
          Else
            ScreenToClient_( WindowID, @Cursorpos ) 
            handle = ChildWindowFromPoint_( WindowID, Cursorpos )
            
            If handle = GadgetID 
              If handle = WindowID
                ; in the window
                ProcedureReturn 0 ; WindowID
              Else
                ; spin-gadget spin-buttons on window
                If ClassName( handle ) = "msctls_updown32"
                  handle = GetWindow_( GadgetID, #GW_HWNDNEXT )
                EndIf
              EndIf
            Else
              Debug ClassName( handle )
              If ClassName( handle ) = "PureSplitter"
                handle = GetWindow_( GadgetID, #GW_HWNDNEXT )
              EndIf
              
              ; MDIGadget childrens
              If ClassName( handle ) = "MDIClient"
                handle = FindWindowEx_( handle, 0, 0, 0 ) ; 
              EndIf
            EndIf
          EndIf
          
          ProcedureReturn handle
        Else
          ProcedureReturn 0
        EndIf
      EndProcedure
      
      Procedure Gadget( WindowID )
        ; ProcedureReturn Gadget1( WindowID )
        
        Protected Cursorpos.q, handle, GadgetID
        GetCursorPos_( @Cursorpos )
        
        If WindowID
          GadgetID = WindowFromPoint_( Cursorpos )
          
          ScreenToClient_( GadgetID, @Cursorpos ) 
          handle = ChildWindowFromPoint_( GadgetID, Cursorpos )
          
          If Not IsGadget( ID::Gadget( handle ) )
            If IsGadget( ID::Gadget( GadgetID ) )
              handle = GadgetID
            ElseIf ClassName( GadgetID ) = "Internet Explor"
              handle = GetParent_(GetParent_(GetParent_(GadgetID)))
            ElseIf ClassName( GadgetID ) = "msctls_updown32"
              handle = GetWindow_( GadgetID, #GW_HWNDPREV )
              ;           If ClassName( handle ) <> "Edit"
              ;             Debug ClassName( handle )
              ;           EndIf
            Else
              If ClassName( GadgetID ) = "MDI_ChildClass"
                handle = GadgetID
              Else
                handle = GetParent_(handle)
              EndIf
            EndIf
            ; panel item scroll buttons 
            If ClassName( handle ) = "Static"
              handle = GetParent_(handle)
            EndIf
            ;                   If Not handle
            ;                      handle = WindowID
            ;                   EndIf
          EndIf
          
          ProcedureReturn handle
        Else
          ProcedureReturn 0
        EndIf
      EndProcedure
      
      Procedure Handle( WindowID )
        Protected Cursorpos.q, handle, GadgetID
        GetCursorPos_( @Cursorpos )
        
        If WindowID
          GadgetID = WindowFromPoint_( Cursorpos )
          
          ScreenToClient_( GadgetID, @Cursorpos ) 
          handle = ChildWindowFromPoint_( GadgetID, Cursorpos )
          
          If Not handle
            ; Debug ""+ handle +" "+ GadgetID
            handle = GadgetID
          EndIf
          
          ProcedureReturn handle
        Else
          ProcedureReturn 0
        EndIf
      EndProcedure
    EndModule
    
  CompilerEndIf
  
  ;-
  Procedure.s PBClassFromEvent( event.i )
    Protected result.s
    
    Select event
      Case #PB_EventType_MouseEnter       : result.s = "MouseEnter"           ; The mouse cursor entered the gadget
      Case #PB_EventType_MouseLeave       : result.s = "MouseLeave"           ; The mouse cursor left the gadget
      Case #PB_EventType_MouseMove        : result.s = "MouseMove"            ; The mouse cursor moved
      Case #PB_EventType_MouseWheel       : result.s = "MouseWheel"           ; The mouse wheel was moved
        
      Case #PB_EventType_LeftButtonDown   : result.s = "LeftButtonDown"   ; The left mouse button was pressed
      Case #PB_EventType_LeftButtonUp     : result.s = "LeftButtonUp"     ; The left mouse button was released
      Case #PB_EventType_LeftClick        : result.s = "LeftClick"        ; A click With the left mouse button
      Case #PB_EventType_LeftDoubleClick  : result.s = "LeftDoubleClick"  ; A double-click With the left mouse button
        
      Case #PB_EventType_RightButtonDown  : result.s = "RightButtonDown" ; The right mouse button was pressed
      Case #PB_EventType_RightButtonUp    : result.s = "RightButtonUp"   ; The right mouse button was released
      Case #PB_EventType_RightClick       : result.s = "RightClick"      ; A click With the right mouse button
      Case #PB_EventType_RightDoubleClick : result.s = "RightDoubleClick"; A double-click With the right mouse button
        
      Case #PB_EventType_MiddleButtonDown : result.s = "MiddleButtonDown" ; The middle mouse button was pressed
      Case #PB_EventType_MiddleButtonUp   : result.s = "MiddleButtonUp"   ; The middle mouse button was released
      Case #PB_EventType_Focus            : result.s = "Focus"            ; The gadget gained keyboard focus
      Case #PB_EventType_LostFocus        : result.s = "LostFocus"        ; The gadget lost keyboard focus
      Case #PB_EventType_KeyDown          : result.s = "KeyDown"          ; A key was pressed
      Case #PB_EventType_KeyUp            : result.s = "KeyUp"            ; A key was released
      Case #PB_EventType_Input            : result.s = "Input"            ; Text input was generated
      Case #PB_EventType_Resize           : result.s = "Resize"           ; The gadget has been resized
      Case #PB_EventType_StatusChange     : result.s = "StatusChange"
      Case #PB_EventType_Change           : result.s = "Change"
      Case #PB_EventType_DragStart        : result.s = "DragStart"
      Case #PB_EventType_TitleChange      : result.s = "TitleChange"
        ;          Case #PB_EventType_CloseItem        : result.s = "CloseItem"
        ;          Case #PB_EventType_SizeItem         : result.s = "SizeItem"
      Case #PB_EventType_Down             : result.s = "Down"
      Case #PB_EventType_Up               : result.s = "Up"
        ;                
        ;             Case #pb_eventtype_cursor : result.s = "Cursor"
        ;             Case #pb_eventtype_free : result.s = "Free"
        ;             Case #pb_eventtype_drop : result.s = "Drop"
        ;             Case #pb_eventtype_create : result.s = "Create"
        ;             Case #pb_eventtype_Draw : result.s = "Draw"
        ;                
        ;             Case #pb_eventtype_repaint : result.s = "Repaint"
        ;             Case #pb_eventtype_resizeend : result.s = "ResizeEnd"
        ;             Case #pb_eventtype_scrollchange : result.s = "ScrollChange"
        ;                
        ;             Case #pb_eventtype_close : result.s = "CloseWindow"
        ;             Case #pb_eventtype_maximize : result.s = "MaximizeWindow"
        ;             Case #pb_eventtype_minimize : result.s = "MinimizeWindow"
        ;             Case #pb_eventtype_restore : result.s = "RestoreWindow"
        ;             Case #pb_eventtype_ReturnKey : result.s = "returnKey"
        ;             Case #pb_eventtype_mousewheelX : result.s = "MouseWheelX"
        ;             Case #pb_eventtype_mousewheelY : result.s = "MouseWheelY"
    EndSelect
    
    ProcedureReturn result.s
  EndProcedure
  
  Procedure fixed_events( gadget, event )
    If event = #PB_EventType_MouseMove
      ProcedureReturn 0
    EndIf
    ;
    Debug " ["+gadget+"] "+ PBClassFromEvent(event) 
  EndProcedure
  
  Procedure all_events( )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Static down, move, leave, drag, double, gadgetID, enterID
      
      If EventType( ) = #PB_EventType_LeftButtonDown
        down = 1
        fixed_events( EventGadget( ), EventType( ))
      ElseIf EventType( ) = #PB_EventType_LeftButtonUp
        drag = 0
        move = 1
        fixed_events( EventGadget( ), EventType( ))
      ElseIf EventType( ) = #PB_EventType_LeftDoubleClick
        double = 1
      ElseIf EventType( ) = #PB_EventType_LeftClick
        If down = 1
          down = 0
          If double = 1
            double = 0
            fixed_events( EventGadget( ), #PB_EventType_LeftDoubleClick)
          Else
            fixed_events( EventGadget( ), EventType( ))
          EndIf
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseLeave
        If drag
          ; drag = 0
        Else
          If leave = 1
            leave = 0
          Else
            fixed_events( EventGadget( ), EventType( ))
          EndIf
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseMove
        If down = 1
          down = 0
          drag = 1
          fixed_events( EventGadget( ), #PB_EventType_DragStart )
        Else
          If drag 
            enterID = mouse::Gadget( mouse::Window( ))
            ;
            If gadgetID <> enterID 
              If gadgetID = GadgetID( EventGadget( ))
                leave = 1
                fixed_events( EventGadget( ), #PB_EventType_MouseLeave )
              EndIf
              ;
              If enterID = GadgetID( EventGadget( ))
                If leave = 1 
                  leave = 0
                  fixed_events( EventGadget( ), #PB_EventType_MouseEnter )
                EndIf
              EndIf
              
              gadgetID = enterID
            EndIf
          EndIf
          
          If move = 1
            move = 0
          Else
            fixed_events( EventGadget( ), EventType( ))
          EndIf
        EndIf
        
      Else
        fixed_events( EventGadget( ), EventType( ))
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      Static down, double, enterID
      
      If EventType( ) = #PB_EventType_Focus
        fixed_events( EventGadget( ), EventType( ))
        If GetActiveGadget( ) = EventGadget( )
          down = 1
          fixed_events( EventGadget( ), #PB_EventType_LeftButtonDown )
        EndIf
      ElseIf EventType( ) = #PB_EventType_LeftButtonDown
        If GetActiveGadget( ) = EventGadget( )
          down = 1
          fixed_events( EventGadget( ), EventType( ))
        EndIf
      ElseIf EventType( ) = #PB_EventType_LeftDoubleClick
        double = 1
      ElseIf EventType( ) = #PB_EventType_LeftClick
        If down = 1
          down = 0
          If double = 1
            double = 0
            fixed_events( EventGadget( ), #PB_EventType_LeftDoubleClick)
          Else
            fixed_events( EventGadget( ), EventType( ))
          EndIf
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseEnter
        enterID = 1
        fixed_events( EventGadget( ), EventType( ))
      ElseIf EventType( ) = #PB_EventType_MouseLeave
        If enterID
          enterID = 0
          fixed_events( EventGadget( ), EventType( ))
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseMove
        If down = 1
          down = 0
          fixed_events( EventGadget( ), #PB_EventType_DragStart )
        Else
          fixed_events( EventGadget( ), EventType( ))
        EndIf
      Else
        fixed_events( EventGadget( ), EventType( ))
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      Static leave, drag, gadgetID, enterID
      
      If EventType( ) = #PB_EventType_Focus
        fixed_events( EventGadget( ), EventType( ) )
        If GetActiveGadget( ) = EventGadget( )
          fixed_events( EventGadget( ), #PB_EventType_LeftButtonDown )
        EndIf
      ElseIf EventType( ) = #PB_EventType_LeftButtonDown
        If GetActiveGadget( ) = EventGadget( )
          fixed_events( EventGadget( ), EventType( ) )
        EndIf
      ElseIf EventType( ) = #PB_EventType_DragStart
        fixed_events( EventGadget( ), EventType( ) )
        drag = 1
      ElseIf EventType( ) = #PB_EventType_LeftButtonUp
        fixed_events( EventGadget( ), EventType( ) )
        If leave 
          enterID = mouse::Gadget( mouse::Window( ))
          If enterID;
            If GadgetID( EventGadget( )) <> enterID 
              fixed_events( ID::Gadget( enterID ), #PB_EventType_MouseEnter )
            EndIf
          EndIf
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseEnter
        If drag = 1
          drag = 0
        Else
          fixed_events( EventGadget( ), EventType( ) )
        EndIf
      ElseIf EventType( ) = #PB_EventType_MouseLeave
        If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
          If leave = 0
            leave = 1
            fixed_events( EventGadget( ), EventType( ) )
          EndIf
        Else
          fixed_events( EventGadget( ), EventType( ) )
        EndIf
        
      ElseIf EventType( ) = #PB_EventType_MouseMove
        If leave
          enterID = mouse::Gadget( mouse::Window( ))
          ;
          If gadgetID <> enterID 
            If gadgetID = GadgetID( EventGadget( ))
              fixed_events( EventGadget( ), #PB_EventType_MouseLeave )
            EndIf
            If enterID = GadgetID( EventGadget( ))
              fixed_events( EventGadget( ), #PB_EventType_MouseEnter )
            EndIf
            gadgetID = enterID
          EndIf
        EndIf
        
        fixed_events( EventGadget( ), EventType( ) )
        
      Else
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    CompilerEndIf
  EndProcedure
  
  Define flag.q = #PB_Canvas_DrawFocus
  
  Procedure TestRoot( gadget, X,Y,Width,Height, flag )
    CanvasGadget(gadget, X,Y,Width,Height, #PB_Canvas_Keyboard ) 
    StartDrawing(CanvasOutput(gadget))
    DrawText(10,10,Str(gadget))
    StopDrawing()
    BindGadgetEvent( gadget, @all_events( ))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TestRoot(10, 10, 10, 150, 150,flag) 
    
    TestRoot(20, 210, 10, 150, 150,flag) 
    
    TestRoot(30, 10, 210, 150, 150,flag) 
    
    TestRoot(40, 210, 210, 150, 150,flag) 
    
    Define gEvent, gQuit
    Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
        Case #PB_Event_CloseWindow
          gQuit= #True
      EndSelect
      
    Until gQuit
  EndIf
  
CompilerEndIf

; [10] MouseEnter
; [10] Focus
; [10] LeftButtonDown
; [10] DragStart
; [10] MouseLeave
; [10] LeftButtonUp
; [20] MouseEnter
; [10] LostFocus
; [20] Focus
; [20] LeftButtonDown
; [20] DragStart
; [20] MouseLeave
; [20] LeftButtonUp
; [20] LostFocus
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; CursorPosition = 563
; FirstLine = 536
; Folding = --------------
; EnableXP
; DPIAware