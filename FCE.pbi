; FIXED CANVAS EVENTS

;- >>> [DECLARE] <<<
DeclareModule ID
   Declare.i Window( WindowID.i )
   Declare.i Gadget( GadgetID.i )
   Declare.i IsWindowID( handle.i )
   Declare.i GetWindowID( handle.i )
   Declare.s ClassName( handle.i )
EndDeclareModule

Module ID
   ;- >>> [MACOS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ; XIncludeFile "../import.pbi"
      Import ""
         PB_Window_GetID( WindowID.i ) 
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
         If WindowID
            Protected Window = PB_Window_GetID( WindowID )
            If IsWindow( Window ) And WindowID( Window ) = WindowID
               ProcedureReturn Window
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
      
      Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
         If GadgetID
            Protected Gadget = CocoaMessage(0, GadgetID, "tag")
            If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
               ProcedureReturn Gadget
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
   CompilerEndIf
   
   ;- >>> [WINDOWS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Procedure.s GetTitle(Handle)
         Protected Name.s
         Name.s = Space(1024)
         GetWindowText_(Handle, @Name, Len(Name))
         ProcedureReturn Left(Name, Len(Name))
      EndProcedure
      
      Procedure.s ClassName( handle.i )
         Protected Class$ = Space( 16 )
         GetClassName_( handle, @Class$, Len( Class$ ) )
         ProcedureReturn Class$
      EndProcedure
      
      Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
         ProcedureReturn GetAncestor_( handle, #GA_ROOT )
      EndProcedure
      
      Procedure.i IsWindowID( handle.i )
         If Left(ClassName( handle ), 11) = "WindowClass"
            ProcedureReturn 1
         EndIf
      EndProcedure
      
      Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
         If WindowID
            Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
            If IsWindow( Window ) And WindowID( Window ) = WindowID
               ProcedureReturn Window
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
      
      Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
         If GadgetID
            Protected Gadget = GetProp_( GadgetID, "PB_ID" )
            If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
               ProcedureReturn Gadget
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
   CompilerEndIf
   
   ;- >>> [LINUX] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      Procedure.s ClassName( handle.i )
         Protected Result = gtk_widget_get_name_( handle )
         If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
         EndIf
      EndProcedure
      
      Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
         If handle
            ProcedureReturn gtk_widget_get_toplevel_( handle )
         EndIf
      EndProcedure
      
      Procedure.i IsWindowID( handle.i )
         If handle And ClassName( handle ) = "PBWindow"
            ProcedureReturn 1
         EndIf
      EndProcedure
      
      Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
         If WindowID 
            Protected Window = g_object_get_data_( WindowID, "pb_id" )
            If IsWindow( Window ) And WindowID( Window ) = WindowID
               ProcedureReturn Window
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
      
      Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
         If GadgetID
            Protected Gadget = g_object_get_data_( GadgetID, "pb_id" ) - 1 
            If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
               ProcedureReturn Gadget
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
   CompilerEndIf
EndModule

;- >>> [DECLARE] <<<
DeclareModule mouse
   Macro GadgetMouseX( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
      ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      ;WindowMouseX( ID::Window(ID::GetWindowID(GadgetID(_canvas_))) ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )
      DesktopMouseX( ) - DesktopScaledX(GadgetX( _canvas_, _mode_ ))
   EndMacro
   Macro GadgetMouseY( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
      ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      ;WindowMouseY(  ID::Window(ID::GetWindowID(GadgetID(_canvas_)))  ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
      DesktopMouseY( ) - DesktopScaledY(GadgetY( _canvas_, _mode_ ))
   EndMacro
   
   Declare State( MouseButtons.b )
   Declare.i Window( )
   Declare.i Gadget( WindowID )
   Declare.i Buttons( )
   ; return
   ; Debug #PB_MouseButton_Left   ; 1
   ; Debug #PB_MouseButton_Right  ; 2
   ; Debug #PB_MouseButton_Middle ; 3
EndDeclareModule

Module mouse
   Procedure State( MouseButtons.b )
      Static press.b, ClickCount, ClickTime.q
      Protected DoubleClickTime, ElapsedMilliseconds.q
      
      If press <> MouseButtons
         press = MouseButtons
         ;
         If MouseButtons
            ElapsedMilliseconds.q = ElapsedMilliseconds( ) 
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
               DoubleClickTime = 10
            CompilerElse
               DoubleClickTime = DoubleClickTime( )
            CompilerEndIf
            
            If DoubleClickTime > ( ElapsedMilliseconds - ClickTime )
               ClickCount + 1
            Else
               ClickCount = 1
            EndIf
            ClickTime = ElapsedMilliseconds
            Debug "real down "
         EndIf
         ProcedureReturn ClickCount
      EndIf
   EndProcedure
   
   ;- >>> [MACOS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
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
      
      Procedure Buttons( )
         ; Debug CocoaMessage(0, 0, "buttonNumber") ; var buttonNumber: Int { get }
         ; Debug CocoaMessage(0, 0, "clickCount") ; var clickCount: Int { get }
         ProcedureReturn CocoaMessage(0, 0, "NSEvent pressedMouseButtons") ; class var pressedMouseButtons: Int { get }
      EndProcedure
   CompilerEndIf
   
   ;- >>> [WINDOWS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
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
                     ProcedureReturn WindowID
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
         ;ProcedureReturn Gadget1( WindowID )
         
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
               If Not handle
                  handle = WindowID
               EndIf
            EndIf
            
            ProcedureReturn handle
         Else
            ProcedureReturn 0
         EndIf
      EndProcedure
      
      Procedure Handle( WindowID )
         Protected Cursorpos.q, handle, GadgetID
         GetCursorPos_( @Cursorpos )
         ;
         If WindowID
            GadgetID = WindowFromPoint_( Cursorpos )
            ;
            ScreenToClient_( GadgetID, @Cursorpos ) 
            handle = ChildWindowFromPoint_( GadgetID, Cursorpos )
            ;
            If handle
               ProcedureReturn handle
            Else
               ProcedureReturn GadgetID
            EndIf
         Else
            ProcedureReturn 0
         EndIf
      EndProcedure
      
      Procedure Buttons( )
         ProcedureReturn GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1 + 
                         GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 2 + 
                         GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 3 
      EndProcedure
   CompilerEndIf
   
   ;- >>> [LINUX] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux 
      ; no good all gadgets
      
      Macro gtk_children( _handle_, _children_ = 0 ) : g_list_nth_data_( gtk_container_get_children_( _handle_ ), _children_ ) : EndMacro
      Macro gtk_bin( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_bin_get_type_ ( ) ) : EndMacro
      Macro gtk_box( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_box_get_type_ ( ) ) : EndMacro
      Macro gtk_frame( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_frame_get_type_ ( ) ) : EndMacro
      Macro gtk_fixed( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_fixed_get_type_ ( ) ) : EndMacro
      Macro gtk_container( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_container_get_type_ ( ) ) : EndMacro
      Macro gtk_widget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_widget_get_type_ ( ) ) : EndMacro
      Macro gtk_window( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_window_get_type_ ( ) ) : EndMacro
      Macro gtk_table( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_table_get_type_ ( ) ) : EndMacro
      Macro gtk_hbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
      Macro gtk_vbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
      Macro gtk_vpaned( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_vpaned_get_type_ ( ) ) : EndMacro
      Macro gtk_viewport( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_viewport_get_type_ ( ) ) : EndMacro
      
      Procedure.s ClassName( handle.i )
         Protected Result = gtk_widget_get_name_( handle )
         If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
         EndIf
      EndProcedure
      
      Procedure Window( )
         Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
         
         If *GdkWindow
            gdk_window_get_user_data_( *GdkWindow, @handle )
            ProcedureReturn gtk_widget_get_toplevel_( handle )
         EndIf
      EndProcedure
      
      Procedure Gadget( WindowID )
         If WindowID
            Protected handle, desktop_x, desktop_y, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
            
            If *GdkWindow
               gdk_window_get_user_data_( *GdkWindow, @handle )
               If IsGadget(ID::Gadget(handle))
                  ProcedureReturn handle
               Else
                  If IsGadget(ID::Gadget(gtk_widget_get_parent_( handle )))
                     ProcedureReturn gtk_widget_get_parent_( handle )
                  Else
                     
                     If ClassName(handle) = "GtkButton"
                        ; listicon heder
                        handle = gtk_widget_get_parent_( handle )
                     ElseIf ClassName(handle) = "GtkToggleButton"
                        ; combobox
                        handle = gtk_widget_get_parent_( handle )
                        handle = gtk_widget_get_parent_( handle )
                     ElseIf ClassName(handle) = "GtkEventBox"
                        ; hyperlink
                        handle = gtk_children(handle)
                        If ClassName(handle) = "GtkFrame"
                           ; text & image
                           handle = gtk_children(handle)
                        EndIf
                     ElseIf ClassName(handle) = "GtkLabel"
                        handle = gtk_widget_get_parent_( handle )
                        
                     ElseIf ClassName(handle) = "GtkLayout"
                        handle = gtk_widget_get_parent_( handle )
                        handle = gtk_widget_get_parent_( handle )
                        ;handle = gtk_children(handle)
                        ;Debug "eee "+ClassName(handle)
                        ;handle = gtk_children(handle)
                        ;ProcedureReturn 0
                     Else
                        ;               Debug ""
                        ;               Debug ClassName(handle)
                        ;               handle = gtk_children(handle)
                        ;               Debug ClassName(handle)
                        ;               handle = gtk_children(handle)
                        ;               Debug ClassName(handle)
                        
                     EndIf
                     ;handle = gtk_widget_get_parent_( handle )
                     
                     ProcedureReturn handle
                  EndIf
               EndIf
            EndIf
         EndIf
      EndProcedure
      
      Procedure Buttons( )
         ; Protected mask, desktop_x, desktop_y, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
         Protected mask, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( 0,0 )
         If *GdkWindow
            gdk_window_get_pointer_(*GdkWindow, 0,0, @mask)
         EndIf
         
         If mask & 256; #GDK_BUTTON1_MASK
            ProcedureReturn #PB_MouseButton_Left
         EndIf
         If mask & 512 ; #GDK_BUTTON3_MASK
            ProcedureReturn #PB_MouseButton_Middle
         EndIf
         If mask & 1024 ; #GDK_BUTTON2_MASK
            ProcedureReturn #PB_MouseButton_Right
         EndIf
      EndProcedure
   CompilerEndIf
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
Declare   EventHandler( EvGadget = - 1, EvType = - 1, eventdata = 0 )
CompilerEndIf

Procedure   CanvasEvents( )
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
      Static leave, drag, gadgetID, enterID, leaveID
      
      If EventType( ) = #PB_EventType_Focus
         EventHandler( EventGadget( ), EventType( ), EventData( ))
         If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
            If GetActiveGadget( ) = EventGadget( )
               EventHandler( EventGadget( ), #PB_EventType_LeftButtonDown, EventData( ))
            EndIf
         EndIf
      ElseIf EventType( ) = #PB_EventType_LeftButtonDown
         If GetActiveGadget( ) = -1 Or GetActiveGadget( ) = EventGadget( )
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
            If enterID
               leaveID = enterID
            EndIf
            enterID = mouse::Gadget( mouse::Window( ))
            If enterID = GadgetID(EventGadget())
               If leaveID
                  EventHandler( ID::Gadget(leaveID), #PB_EventType_MouseLeave, EventData( ))
                  leaveID = 0
               EndIf
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
         EndIf
      ElseIf EventType( ) = #PB_EventType_MouseLeave
         If GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
            If leave = 0
               leave = 1
               EventHandler( EventGadget( ), EventType( ), EventData( ))
            EndIf
         Else
            If enterID = GadgetID(EventGadget())
               enterID = mouse::Gadget( mouse::Window( ))
               EventHandler( EventGadget( ), EventType( ), EventData( ))
               If enterID
                  EventHandler( ID::Gadget(enterID), #PB_EventType_MouseEnter, EventData( ))
                 ; enterID = GadgetID(EventGadget())
               EndIf
            EndIf
         EndIf
         
      ElseIf EventType( ) = #PB_EventType_MouseMove
;          If leave
;             enterID = mouse::Gadget( mouse::Window( ))
;             ;
;             If gadgetID <> enterID 
;                If gadgetID = GadgetID( EventGadget( ))
;                   EventHandler( EventGadget( ), #PB_EventType_MouseLeave, EventData( ))
;                EndIf
;                If enterID = GadgetID( EventGadget( ))
;                   EventHandler( EventGadget( ), #PB_EventType_MouseEnter, EventData( ))
;                EndIf
;                gadgetID = enterID
;             EndIf
;          EndIf
         
         EventHandler( EventGadget( ), EventType( ), EventData( ))
         
      Else
         EventHandler( EventGadget( ), EventType( ), EventData( ))
      EndIf
   CompilerEndIf
EndProcedure

BindEvent( #PB_Event_Gadget, @CanvasEvents() )

CompilerIf #PB_Compiler_IsMainFile
   Procedure   EventHandler( EvGadget = - 1, EvType = - 1, eventdata = 0 )
      Select EvType
         Case #PB_EventType_DragStart
            Debug "drag: " + EvGadget
         Case #PB_EventType_MouseEnter
            Debug "enter: " + EvGadget
         Case #PB_EventType_MouseLeave
            Debug "leave: " + EvGadget
         Case #PB_EventType_LeftButtonDown
            Debug "press: " + EvGadget
         Case #PB_EventType_LeftButtonUp
            Debug "release: " + EvGadget
         Case #PB_EventType_Focus
            Debug "focus: " + EvGadget
         Case #PB_EventType_LostFocus
            Debug "lostfocus: " + EvGadget
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure Draw(gadget)
      ; Рисуем в тот холст, который сейчас "подставлен" в root
      If StartDrawing(CanvasOutput(gadget))
         Box(0, 0, OutputWidth(), OutputHeight(), RGB(Random(255),Random(255),Random(255))) 
         
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure Open( window, X,Y,w,h, title.s )
      Static gadget : gadget + 1
      CanvasGadget(gadget, X,Y, w, h, #PB_Canvas_Container) : CloseGadgetList()
      
      Draw(gadget)
      ProcedureReturn gadget
   EndProcedure
   
   ; В одном окне
   Global *r, *r1,*r2,*r3,*r4,*r5, *g
   Global win = OpenWindow(#PB_Any, 600, 100, 410, 410, "4 Холста в одном окне")
   RandomSeed(3)
   
   ; Создаем 4 независимых корня/холста
   *r1 = Open(win, 0,   0,   200, 200, "Топ-Лево")
   *r2 = Open(win, 205, 0,   200, 200, "Топ-Право")
   *r3 = Open(win, 0,   205, 200, 200, "Бот-Лево")
   *r4 = Open(win, 205, 205, 200, 200, "Бот-Право")
   *r5 = Open(win, 40,   40,   230, 230, "Топ-Лево")
   
   Repeat
      Define Event = WaitWindowEvent()
      Define EvWin = EventWindow()
      ;
      If Event = #PB_Event_Gadget
         Define EvGadget = EventGadget()
         Define EvType = EventType()
         
      EndIf
   Until Event = #PB_Event_CloseWindow
   
CompilerEndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 2
; Folding = ------------------f0--8-----
; EnableXP
; DPIAware