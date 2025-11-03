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
      
   EndModule
    
  CompilerEndIf
  
  
  ;-
  Procedure Draw( gadget, text$ )
     If StartDrawing(CanvasOutput(gadget))
        Box(0,0,OutputWidth(), OutputHeight(), RGB( Random(255), Random(255), Random(255) ))
        DrawText(10,10,text$ + " ["+Str(gadget)+"]")
        StopDrawing()
     EndIf
  EndProcedure
  
  Procedure EventHandler( gadget, event, *data )
    Select event
      Case #PB_EventType_MouseEnter       : Debug " ["+gadget+"] MouseEnter"           
      Case #PB_EventType_MouseLeave       : Debug " ["+gadget+"] MouseLeave"          
      ; Case #PB_EventType_MouseMove        : Debug " ["+gadget+"] MouseMove"           
      Case #PB_EventType_MouseWheel       : Debug " ["+gadget+"] MouseWheel"           
        
      Case #PB_EventType_LeftButtonDown   : Debug " ["+gadget+"] LeftButtonDown"  
      Case #PB_EventType_LeftButtonUp     : Debug " ["+gadget+"] LeftButtonUp"     
      Case #PB_EventType_LeftClick        : Debug " ["+gadget+"] LeftClick"        
      Case #PB_EventType_LeftDoubleClick  : Debug " ["+gadget+"] LeftDoubleClick"  
        
      Case #PB_EventType_RightButtonDown  : Debug " ["+gadget+"] RightButtonDown" 
      Case #PB_EventType_RightButtonUp    : Debug " ["+gadget+"] RightButtonUp"   
      Case #PB_EventType_RightClick       : Debug " ["+gadget+"] RightClick"      
      Case #PB_EventType_RightDoubleClick : Debug " ["+gadget+"] RightDoubleClick"
        
      Case #PB_EventType_MiddleButtonDown : Debug " ["+gadget+"] MiddleButtonDown" 
      Case #PB_EventType_MiddleButtonUp   : Debug " ["+gadget+"] MiddleButtonUp"   
         
      Case #PB_EventType_Focus            : Debug " ["+gadget+"] Focus"   
         Draw(gadget, "Focus")
         
      Case #PB_EventType_LostFocus        : Debug " ["+gadget+"] LostFocus"        
         Draw(gadget, "")
         
      Case #PB_EventType_KeyDown          : Debug " ["+gadget+"] KeyDown"          
      Case #PB_EventType_KeyUp            : Debug " ["+gadget+"] KeyUp"           
      Case #PB_EventType_Input            : Debug " ["+gadget+"] Input"            
         
      Case #PB_EventType_Resize           : Debug " ["+gadget+"] Resize"           
      Case #PB_EventType_DragStart        : Debug " ["+gadget+"] DragStart"
      Case #PB_EventType_StatusChange     : Debug " ["+gadget+"] StatusChange"
      Case #PB_EventType_TitleChange      : Debug " ["+gadget+"] TitleChange"
      Case #PB_EventType_Change           : Debug " ["+gadget+"] Change"
      Case #PB_EventType_Down             : Debug " ["+gadget+"] Down"
      Case #PB_EventType_Up               : Debug " ["+gadget+"] Up"
   EndSelect
  EndProcedure
  
  ;-
  Procedure CanvasEvents( )
        ; uncomment\comment to see bug
        ; ProcedureReturn EventHandler( EventGadget( ), EventType( ), EventData( ) )
         
         CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            Static down, move, leave, drag, double, gadgetID, enterID
            
            If EventType( ) = #PB_EventType_LeftButtonDown
               down = 1
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            ElseIf EventType( ) = #PB_EventType_LeftButtonUp
               drag = 0
               move = 1
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            ElseIf EventType( ) = #PB_EventType_LeftDoubleClick
               double = 1
            ElseIf EventType( ) = #PB_EventType_LeftClick
               If down = 1
                  down = 0
                  If double = 1
                     double = 0
                     EventHandler( EventGadget( ), #PB_EventType_LeftDoubleClick, EventData( ))
                  Else
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseLeave
               If drag
                  ; drag = 0
               Else
                  If leave = 1
                     leave = 0
                  Else
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseMove
               If down = 1
                  down = 0
                  drag = 1
                  EventHandler( EventGadget( ), #PB_EventType_DragStart, EventData( ))
               Else
                  If drag 
                     enterID = mouse::Gadget( mouse::Window( ))
                     ;
                     If gadgetID <> enterID 
                        If gadgetID = GadgetID( EventGadget( ))
                           leave = 1
                           EventHandler( EventGadget( ), #PB_EventType_MouseLeave, EventData( ))
                        EndIf
                        ;
                        If enterID = GadgetID( EventGadget( ))
                           If leave = 1 
                              leave = 0
                              EventHandler( EventGadget( ), #PB_EventType_MouseEnter, EventData( ))
                           EndIf
                        EndIf
                        
                        gadgetID = enterID
                     EndIf
                  EndIf
                  
                  If move = 1
                     move = 0
                  Else
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               EndIf
               
            Else
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
            
         CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            Static down, double, enterID
            
            If EventType( ) = #PB_EventType_Focus
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
                 If GetActiveGadget( ) = EventGadget( )
                   down = 1
                   EventHandler( EventGadget( ), #PB_EventType_LeftButtonDown, EventData( ))
                 EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_LeftButtonDown
               If GetActiveGadget( ) = EventGadget( )
                  down = 1
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
            ElseIf EventType( ) = #PB_EventType_LeftDoubleClick
               double = 1
            ElseIf EventType( ) = #PB_EventType_LeftClick
               If down = 1
                  down = 0
                  If double = 1
                     double = 0
                     EventHandler( EventGadget( ), #PB_EventType_LeftDoubleClick, EventData( ))
                  Else
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseEnter
               enterID = 1
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            ElseIf EventType( ) = #PB_EventType_MouseLeave
               If enterID
                  enterID = 0
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseMove
               If down = 1
                  down = 0
                  EventHandler( EventGadget( ), #PB_EventType_DragStart, EventData( ))
               Else
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
            Else
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
            
         CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
            Static leave, drag, gadgetID, enterID
            
            If EventType( ) = #PB_EventType_Focus
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
                 If GetActiveGadget( ) = EventGadget( )
                   EventHandler( EventGadget( ), #PB_EventType_LeftButtonDown, EventData( ))
                 EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_LeftButtonDown
               If GetActiveGadget( ) = EventGadget( )
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
            ElseIf EventType( ) = #PB_EventType_DragStart
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               drag = 1
            ElseIf EventType( ) = #PB_EventType_LeftButtonUp
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               If leave 
                  enterID = mouse::Gadget( mouse::Window( ))
                  If enterID;
                     If GadgetID( EventGadget( )) <> enterID 
                        EventHandler( ID::Gadget( enterID ), #PB_EventType_MouseEnter, EventData( ))
                     EndIf
                  EndIf
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseEnter
               If drag = 1
                  drag = 0
               Else
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
            ElseIf EventType( ) = #PB_EventType_MouseLeave
               If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
                  If leave = 0
                     leave = 1
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               Else
                  EventHandler( EventGadget( ), EventType( ), EventData( ))
               EndIf
               
            ElseIf EventType( ) = #PB_EventType_MouseMove
               If leave
                  enterID = mouse::Gadget( mouse::Window( ))
                  ;
                  If gadgetID <> enterID 
                     If gadgetID = GadgetID( EventGadget( ))
                        EventHandler( EventGadget( ), #PB_EventType_MouseLeave, EventData( ))
                     EndIf
                     If enterID = GadgetID( EventGadget( ))
                        EventHandler( EventGadget( ), #PB_EventType_MouseEnter, EventData( ))
                     EndIf
                     gadgetID = enterID
                  EndIf
               EndIf
               
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               
            Else
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
         CompilerEndIf
      EndProcedure
      
      
  Procedure TestGadget( gadget, X,Y,Width,Height )
     CanvasGadget(gadget, X,Y,Width,Height, #PB_Canvas_Keyboard ) 
     Draw(gadget, "")
     ; SetActiveGadget( gadget ) ; BUG
     BindGadgetEvent( gadget, @CanvasEvents( ))
     SetActiveGadget( gadget )
  EndProcedure
  
  Procedure TestWindow( ID )
     Static X,Y
     OpenWindow( ID, 300+X,150+Y,170,170,"window_"+Str(ID), #PB_Window_BorderLess)
     TestGadget( ID, 10, 0, 160, 170 )
     
     X + 100
     Y + 100
     ProcedureReturn 1
  EndProcedure
  
  If TestWindow( 10 )
     TestWindow( 30 )
;   If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     TestGadget(10, 10, 10, 150, 150) 
;     
; ;     TestGadget(20, 210, 10, 150, 150) 
;     
;     TestGadget(30, 10, 210, 150, 150) 
;     
; ;     TestGadget(40, 210, 210, 150, 150) 
    
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

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 457
; FirstLine = 32
; Folding = -0--+r-------
; EnableXP
; DPIAware