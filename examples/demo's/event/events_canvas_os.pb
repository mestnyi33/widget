CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  ;-
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
    Declare.s ClassName( handle.i )
  EndDeclareModule
  
  Module ID
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Import ""
        PB_Window_GetID( WindowID.i ) 
      EndImport
    CompilerEndIf
    
    Procedure.s GetTitle(Handle)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Protected Name.s
        Name.s = Space(1024)
        GetWindowText_(Handle, @Name, Len(Name))
        ProcedureReturn Left(Name, Len(Name))
      CompilerEndIf
    EndProcedure
    
    Procedure.s ClassName( handle.i )
      If handle
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Protected Class$ = Space( 16 )
          GetClassName_( handle, @Class$, Len( Class$ ) )
          ProcedureReturn Class$
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          Protected Result
          CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
          If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
          EndIf
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          Protected Result = gtk_widget_get_name_( handle )
          If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
          EndIf
        CompilerEndIf
      EndIf
    EndProcedure
    
    Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
      If handle 
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          ProcedureReturn GetAncestor_( handle, #GA_ROOT )
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          ProcedureReturn CocoaMessage( 0, handle, "window" )
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          ProcedureReturn gtk_widget_get_toplevel_( handle )
        CompilerEndIf
      EndIf
    EndProcedure
    
    Procedure.i IsWindowID( handle.i )
      If handle
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          If Left(ClassName( handle ), 11) = "WindowClass"
            ProcedureReturn 1
          EndIf
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          If ClassName( handle ) = "PBWindow"
            ProcedureReturn 1
          EndIf
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          If ClassName( handle ) = "PBWindow"
            ProcedureReturn 1
          EndIf
        CompilerEndIf
      EndIf
    EndProcedure
    
    Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
      If WindowID
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          Protected Window = PB_Window_GetID( WindowID )
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          Protected Window = g_object_get_data_( WindowID, "pb_id" )
        CompilerEndIf
        ;
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
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
          Protected Gadget = CocoaMessage(0, GadgetID, "tag")
        CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          Protected Gadget = g_object_get_data_( GadgetID, "pb_id" ) - 1 
        CompilerEndIf
        ;
        If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
          ProcedureReturn Gadget
        EndIf
        ProcedureReturn - 1
      Else
        ProcedureReturn - 1
      EndIf
    EndProcedure
  EndModule
  
  ;-
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
    
    ;-
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    DeclareModule mouse
      Declare.i Window( )
      Declare.i Gadget( WindowID )
      Declare.i State( )
    EndDeclareModule
    
    Module mouse
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
      
      Procedure State( )
        Static press.b
        Protected mask, state.b, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( 0,0 )
        
        If *GdkWindow
          gdk_window_get_pointer_(*GdkWindow, 0,0, @mask)
        EndIf
        
        If mask & 256; #GDK_BUTTON1_MASK
          state = 1
        EndIf
        If mask & 512 ; #GDK_BUTTON3_MASK
          state = 3
        EndIf
        If mask & 1024 ; #GDK_BUTTON2_MASK
          state = 2
        EndIf
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
      ; ProcedureReturn 0
    EndIf
    ;
    Debug " ["+gadget+"] "+ PBClassFromEvent(event) 
  EndProcedure
  
  Procedure windows_events( )
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
  EndProcedure
  
  Procedure macos_events( ) ; OK
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
      
    Else
      fixed_events( EventGadget( ), EventType( ) )
    EndIf
  EndProcedure
  
  Procedure linux_events( )
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
  EndProcedure
  
  Procedure all_events( )
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 739
; FirstLine = 663
; Folding = -------------------f-----
; EnableXP
; DPIAware