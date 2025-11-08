CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
   EndEnumeration
   
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
                        handle = CocoaMessage(0, handle, "superview")  ; NSScrollView
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
                        handle = CocoaMessage(0, handle, "superview")  ; NSClipView
                                                                       ; scrollarea
                        If ClassName(handle) = "NSClipView"            ;
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
      
      Global psn.q, mask, key.s
      
      ImportC ""
         CFRunLoopGetCurrent( )
         CFRunLoopAddCommonMode(rl, mode)
         
         CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
         
         ;     GetCurrentProcess(*psn)
         ;     CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
         
         GetCurrentProcess(*ProcessSerialNumber)
         CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.i, CGEventTapOptions.i, CGEventMask.q, CGEventTapCallback.i, *UserData)
      EndImport
      
      ProcedureC eventTapFunction(proxy, eType, event, refcon)
         Protected Gadget, scrollX, scrollY, NSClass, NSEvent, Window, View, Point.NSPoint
         
         If refcon
           If eType = #NSScrollWheel Or
              eType = #NSLeftMouseDown Or eType = #NSRightMouseDown 
             
             NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
             If NSEvent
               Window = CocoaMessage(0, NSEvent, "window")
               If Window
                 CocoaMessage(@Point, NSEvent, "locationInWindow")
                 ;
                 View = CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "hitTest:@", @Point)
                 If View
                   CocoaMessage( @NSClass, CocoaMessage( 0, View, "className" ), "UTF8String" )
                   ;
                   If NSClass And 
                      PeekS( NSClass, -1, #PB_UTF8 ) = "PB_NSFlippedView"
                     View = CocoaMessage(0, View, "superview")
                   EndIf
                   ;
                   Gadget = CocoaMessage(0, View, "tag")
                   If IsGadget( Gadget )
                     If GetActiveGadget( ) <> Gadget 
                       If GetActiveGadget() 
                         SetActiveGadget( #PB_Default )
                       EndIf
                       ; SetActiveWindow( EventWindow( ))
                       SetActiveGadget( Gadget )
                     EndIf
                     
                     If eType = #NSScrollWheel
                       Window = EventWindow( )
                       scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
                       scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
                       
                       If scrollX And Not scrollY
                         ; Debug "X - scroll"
                         CompilerIf Defined(PB_EventType_MouseWheelY, #PB_Constant) 
                           CallCFunctionFast(refcon, Gadget, #PB_EventType_MouseWheelX, scrollX )
                         CompilerEndIf
                       EndIf
                       
                       If scrollY And Not scrollX
                         ; Debug "Y - scroll"
                         CompilerIf Defined(PB_EventType_MouseWheelX, #PB_Constant) 
                           CallCFunctionFast(refcon, Gadget, #PB_EventType_MouseWheelY, scrollY )
                         CompilerEndIf
                       EndIf
                     EndIf
                   EndIf
                 EndIf
               EndIf
             EndIf
           EndIf
         EndIf
         
      EndProcedure
      
      ;    Procedure.i WaitEvent( event.i, second.i = 0 )
      ;      ProcedureReturn event
      ;    EndProcedure
      
      Procedure   SetCallBack( *callback )
         Protected mask, EventTap
         mask = #NSMouseMovedMask | #NSScrollWheelMask
         ; mask | #NSMouseEnteredMask | #NSMouseExitedMask  ;| #NSCursorUpdateMask
         mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask | #NSOtherMouseUpMask
         mask | #NSRightMouseDownMask | #NSRightMouseDownMask | #NSOtherMouseDownMask
         mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask | #NSOtherMouseDraggedMask 
         mask | #NSKeyDownMask | #NSKeyUpMask
         
         ;mask = #kCGEventForAllEventsMask
         
         #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
         #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
         #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
         
         #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
         #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
         
         ;\\
         GetCurrentProcess( @psn )
         eventTap = CGEventTapCreateForPSN( @psn, #headInsertEventTap, 1, mask, @eventTapFunction( ), *callback )
         
         ;\\ с ним mousemove не происходит если приложение не активно
         ; eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction( ), *callback)
         
         ;\\
         If eventTap
            CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
         EndIf
         
         ;\\
         ; CFRelease_(eventTap)
      EndProcedure
      
      Declare EventHandler( gadget, event, *data )
      SetCallBack( @EventHandler( ) )
      
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
      
      Procedure.w HIWORD(Value.L)
         ProcedureReturn (((Value) >> 16) & $FFFF)
      EndProcedure
      
      Procedure.w LOWORD(Value)
         ProcedureReturn ((Value) & $FFFF)
      EndProcedure
      
      Procedure CallbackHandler(hWnd, uMsg, wParam, lParam) 
         Protected gadget = GetProp_( hWnd, "PB_ID" )
         Protected sysProc = GetProp_(hWnd, "sysProc")
         Protected *callBack = GetProp_(hWnd, "sysProc"+Str(GetProp_(hWnd, "sysProcType")))
         Static focus.i, enter.b, move.b 
         
         Select uMsg
            Case #WM_NCDESTROY 
               SetWindowLongPtr_(hwnd, #GWLP_USERDATA, sysProc)
               RemoveProp_(hwnd, sysProc)
               
            Case #WM_MOUSEHWHEEL 
               CallFunctionFast( *callBack,  gadget, #PB_EventType_MouseWheelX, - HIWORD(wparam) );( delta * step / #WHEEL_DELTA )) )
               ProcedureReturn 0
               
            Case #WM_MOUSEWHEEL 
               CallFunctionFast( *callBack,  gadget, #PB_EventType_MouseWheelY , HIWORD(wparam) );( delta * step / #WHEEL_DELTA ))
               ProcedureReturn 0
               
               ;          Case #WM_KEYDOWN
               ;             Debug 656789098765
         EndSelect
         
         ProcedureReturn CallWindowProc_(sysProc, hWnd, uMsg, wParam, lParam)
      EndProcedure 
      
      Procedure BindGadget( gadget, *callBack, eventtype = #PB_All )
         Protected hWnd = GadgetID( gadget )
         Protected sysProc = SetWindowLongPtr_(hWnd, #GWL_WNDPROC, @CallbackHandler())
         SetProp_(hWnd, "sysProc", sysProc)
         SetProp_(hWnd, "sysProcType", eventtype)
         SetProp_(hWnd, "sysProc"+Str(eventtype), *callBack)
      EndProcedure
      ;-
   CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      
     #GDK_SCROLL_SMOOTH = 4
     ImportC ""
         gdk_event_get_scroll_deltas(*Event, *delta_x, *delta_y)
      EndImport
      
      Procedure signal_event( *self, *event.gdkeventscroll, user_data )
        Protected deltaX.d, deltaY.d
        Protected Window = EventWindow( )
        Protected Gadget = EventGadget( ) 
         
         If *event\type = #GDK_SCROLL
           ;Debug "Scroll State " + *event\state
           
           If user_data
             
             If *event\direction = #GDK_SCROLL_LEFT
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, 1)
             ElseIf *event\direction = #GDK_SCROLL_RIGHT
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, -1)
             ElseIf *event\direction = #GDK_SCROLL_UP
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, 1)
             ElseIf *event\direction = #GDK_SCROLL_DOWN
               PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, -1)
             ElseIf *event\direction = #GDK_SCROLL_SMOOTH
               gdk_event_get_scroll_deltas(*event, @deltaX, @deltaY)
               
               If deltax <> 0.0
                 PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelX, - deltaX)
               EndIf
               If deltaY <> 0.0
                 PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseWheelY, - deltaY)
               EndIf
             EndIf
             
             ProcedureReturn #True
           EndIf
         EndIf
       EndProcedure
    
      Procedure BindGadget( gadget, *callBack, eventtype = #PB_All  )
         ; g_signal_connect_data_(GadgetID(gadget), "change-value", @ChangeHandler( ), 0, #Null, 0)
         g_signal_connect_( GadgetID(gadget), "event", @signal_event( ), *callBack )
      EndProcedure
      
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
      If event = #PB_EventType_MouseMove
         Static move
         If move = 0
            move = 1
            
            Debug "     ["+gadget+"] Move" 
         EndIf
      Else
         move = 0
      EndIf
      
      Select event
         Case #PB_EventType_MouseEnter       : Debug "["+gadget+"] Enter"           
         Case #PB_EventType_MouseLeave       : Debug "["+gadget+"] Leave"          
            ; Case #PB_EventType_MouseMove        : Debug "["+gadget+"] Move"           
         Case #PB_EventType_MouseWheel       : Debug "["+gadget+"] Wheel " + *data            
         Case #PB_EventType_MouseWheelX      : Debug "["+gadget+"] WheelHorizontal " + *data           
         Case #PB_EventType_MouseWheelY      : Debug "["+gadget+"] WheelVertical " + *data           
            
         Case #PB_EventType_LeftButtonDown   : Debug "["+gadget+"] LeftDown"  
         Case #PB_EventType_LeftButtonUp     : Debug "["+gadget+"] LeftUp"     
         Case #PB_EventType_LeftClick        : Debug "["+gadget+"] LeftClick"        
         Case #PB_EventType_LeftDoubleClick  : Debug "["+gadget+"] Left2Click"  
            
         Case #PB_EventType_RightButtonDown  : Debug "["+gadget+"] RightDown" 
         Case #PB_EventType_RightButtonUp    : Debug "["+gadget+"] RightUp"   
         Case #PB_EventType_RightClick       : Debug "["+gadget+"] RightClick"      
         Case #PB_EventType_RightDoubleClick : Debug "["+gadget+"] Right2Click"
            
         Case #PB_EventType_MiddleButtonDown : Debug "["+gadget+"] MiddleDown" 
         Case #PB_EventType_MiddleButtonUp   : Debug "["+gadget+"] MiddleUp"   
            
         Case #PB_EventType_Focus            : Debug "["+gadget+"] Focus"   
            Draw(gadget, "Focus")
            
         Case #PB_EventType_LostFocus        : Debug "["+gadget+"] LostFocus"        
            Draw(gadget, "")
            
         Case #PB_EventType_KeyDown          : Debug "["+gadget+"] KeyDown"          
         Case #PB_EventType_KeyUp            : Debug "["+gadget+"] KeyUp"           
         Case #PB_EventType_Input            : Debug "["+gadget+"] Input"            
            
         Case #PB_EventType_Resize           : Debug "["+gadget+"] Resize"           
         Case #PB_EventType_DragStart        : Debug "["+gadget+"] DragStart"
         Case #PB_EventType_StatusChange     : Debug "["+gadget+"] StatusChange"
         Case #PB_EventType_TitleChange      : Debug "["+gadget+"] TitleChange"
         Case #PB_EventType_Change           : Debug "["+gadget+"] Change"
         Case #PB_EventType_Down             : Debug "["+gadget+"] Down"
         Case #PB_EventType_Up               : Debug "["+gadget+"] Up"
      EndSelect
   EndProcedure
   
   ;-
   Procedure CanvasEvents( )
      ; uncomment\comment to see bug
      ; ProcedureReturn EventHandler( EventGadget( ), EventType( ), EventData( ) )
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         Static down, move, leave, drag, double, gadgetID, enterID, focus
         
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
         ElseIf EventType( ) = #PB_EventType_Focus
            If focus <> GadgetID( EventGadget( ))
               focus = GadgetID( EventGadget( ))
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
            
         ElseIf EventType( ) = #PB_EventType_LostFocus
            If GetFocus_( ) <> GadgetID( EventGadget( ))
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               focus = 0
            EndIf
            
         ElseIf EventType( ) = #PB_EventType_MouseEnter
            If Not GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
               If enterID <> GadgetID( EventGadget( ))
                  If enterID
                     EventHandler(  ID::Gadget( enterID ), #PB_EventType_MouseLeave, EventData( ))
                  EndIf
                  
                  enterID = GadgetID( EventGadget( ))
               EndIf
            EndIf
            EventHandler( EventGadget( ), EventType( ), EventData( ))
            
         ElseIf EventType( ) = #PB_EventType_MouseLeave
            If drag
               ; drag = 0
            Else
               If leave = 1
                  leave = 0
               Else
                  If enterID = GadgetID( EventGadget( ))
                     enterID = 0
                     EventHandler( EventGadget( ), EventType( ), EventData( ))
                  EndIf
               EndIf
            EndIf
         ElseIf EventType( ) = #PB_EventType_MouseMove
            If down 
               If down = 3
                  down = 0
                  drag = 1
                  EventHandler( EventGadget( ), #PB_EventType_DragStart, EventData( ))
               Else
                  down + 1
               EndIf
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
                     Else
                        enterID = 0
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
         Static leave, drag, gadgetID, enterID, focus =- 1
         
         If EventType( ) = #PB_EventType_Focus
           If focus <> EventGadget( )
             If IsGadget( focus )
               SetActiveWindow(focus)
               SetActiveGadget(#PB_Default)
               SetActiveWindow(EventWindow( ))
               ;EventHandler( focus, #PB_EventType_LostFocus, EventData( ))
             EndIf
             focus = EventGadget( )
           EndIf
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
   
   
   Procedure TestGadget( Canvas, X,Y,Width,Height )
     ; scroll wheel delta linux
     ; CanvasGadget(Canvas, X,Y,Width,Height, #PB_Canvas_Keyboard ) 
     CanvasGadget(Canvas, X,Y,Width,Height, #PB_Canvas_Keyboard|#PB_Canvas_Container ) : CloseGadgetList( )
     
      Draw(Canvas, "")
      ; SetActiveGadget( Canvas ) ; BUG
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         BindGadgetEvent( Canvas, @CanvasEvents( ))
       CompilerElse
         BindGadget( Canvas, @EventHandler( ))
         BindGadgetEvent( Canvas, @CanvasEvents( ))
      CompilerEndIf
      
      SetActiveGadget( Canvas )
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
            Case #PB_Event_ActivateWindow
               Debug "["+EventWindow( )+"] active"
               
            Case #PB_Event_DeactivateWindow
               Debug " --- "
               Debug "["+EventWindow( )+"] deactive"
               
            Case #PB_Event_CloseWindow
               gQuit= #True
         EndSelect
         
      Until gQuit
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 402
; FirstLine = 381
; Folding = -----------0--8-----
; EnableXP
; DPIAware