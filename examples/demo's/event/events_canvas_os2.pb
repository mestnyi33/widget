CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    DeclareModule mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
  Declare.i State( )
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
  
  Procedure State( )
    Static press.b
    Protected state.b = CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
    
    If press <> state
      If state
        If state = 1
          Debug "LeftDown - "+state
        ElseIf state = 2
          Debug "RightDown - "+state
        EndIf
      Else
        If press = 1
          Debug "LeftUp - "+press
        ElseIf press = 2
          Debug "RightUp - "+press
        EndIf
      EndIf
      press = state
    EndIf
    
  EndProcedure
EndModule

  CompilerEndIf
  
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
    Debug " ["+gadget+"] "+ PBClassFromEvent(event) 
  EndProcedure
  
  Procedure windows_events( )
    fixed_events( EventGadget( ), EventType( ) )
  EndProcedure
  
  Procedure linux_events( )
    If EventType( ) = #PB_EventType_LeftButtonDown
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    ElseIf EventType( ) = #PB_EventType_Focus
      fixed_events( EventGadget( ), EventType( ) )
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), #PB_EventType_LeftButtonDown )
      EndIf
    ElseIf EventType( ) = #PB_EventType_MouseLeave
      If Not GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    Else
      fixed_events( EventGadget( ), EventType( ) )
    EndIf
  EndProcedure
  
  Procedure macos_events( )
    Static leave, drag
    
    If EventType( ) = #PB_EventType_LeftButtonDown
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    ElseIf EventType( ) = #PB_EventType_Focus
      fixed_events( EventGadget( ), EventType( ) )
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), #PB_EventType_LeftButtonDown )
      EndIf
    ElseIf EventType( ) = #PB_EventType_DragStart
      fixed_events( EventGadget( ), EventType( ) )
      drag = 1
    ElseIf EventType( ) = #PB_EventType_MouseEnter
      If drag = 1
        drag = 0
      Else
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    ElseIf EventType( ) = #PB_EventType_MouseLeave
      If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
        leave = 1
      Else
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    ElseIf EventType( ) = #PB_EventType_LeftButtonUp
      fixed_events( EventGadget( ), EventType( ) )
      If leave = 1
        leave = 0
        
        If GadgetID( EventGadget( )) <> mouse::Gadget( mouse::Window( ))
          drag = 0
          fixed_events( EventGadget( ), #PB_EventType_MouseLeave )
        EndIf
      EndIf
    Else
      fixed_events( EventGadget( ), EventType( ) )
    EndIf
  EndProcedure
  
  Procedure all_events( )
    If EventType( ) = #PB_EventType_MouseMove
      ProcedureReturn 0
    EndIf
    ;
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      windows_events( )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      linux_events( )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      macos_events( )
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; CursorPosition = 311
; FirstLine = 283
; Folding = --------
; EnableXP
; DPIAware