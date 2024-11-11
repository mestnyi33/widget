;- LINUX
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
    Declare.s ClassName( handle.i )
  EndDeclareModule
  
  Module ID
    Procedure.s ClassName( handle.i )
      Protected Result = gtk_widget_get_name_( handle )
      If Result
        ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
      EndIf
    EndProcedure
    
    Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
      ProcedureReturn gtk_widget_get_toplevel_( handle )
    EndProcedure
    
    Procedure.i IsWindowID( handle.i )
      If ClassName( handle ) = "PBWindow"
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
      ProcedureReturn g_object_get_data_( WindowID, "pb_id" )
    EndProcedure
    
    Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
      ProcedureReturn g_object_get_data_( GadgetID, "pb_id" ) - 1 
    EndProcedure
  EndModule
  
  DeclareModule Mouse
    Declare.i Window( )
    Declare.i Gadget( WindowID )
  EndDeclareModule
  
  Module Mouse
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
                Debug "eee "+ClassName(handle)
                ;handle = gtk_children(handle)
                
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
  EndModule
  
  ;- WINDOWS
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
    Declare.s ClassName( handle.i )
  EndDeclareModule
  
  Module ID
    Procedure.s ClassName( handle.i )
      Protected Class$ = Space( 16 )
      GetClassName_( handle, @Class$, Len( Class$ ) )
      ProcedureReturn Class$
    EndProcedure
    
    Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
      ProcedureReturn GetAncestor_( handle, #GA_ROOT )
    EndProcedure
    
    Procedure.i IsWindowID( handle.i )
      If ClassName( handle ) = "PBWindow"
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
      Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
      If IsWindow( Window ) And WindowID( Window ) = WindowID
        ProcedureReturn Window
      EndIf
      ProcedureReturn - 1
    EndProcedure
    
    Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
      Protected gadget = GetProp_( GadgetID, "PB_ID" )
      If IsGadget( gadget ) And GadgetID( gadget ) = GadgetID
        ProcedureReturn gadget
      EndIf
      ProcedureReturn - 1
    EndProcedure
  EndModule
  
  DeclareModule Mouse
    Declare.i Window( )
    Declare.i Gadget( WindowID )
  EndDeclareModule
  
  Module Mouse
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
            If ClassName( handle ) <> "Edit"
              Debug ClassName( handle )
            EndIf
          Else
            handle = GetParent_(handle)
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
  EndModule
  
  ;- MACOS
CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
    Declare.s ClassName( handle.i )
  EndDeclareModule
  
  Module ID
    ; XIncludeFile "../import.pbi"
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
      If GadgetID
        ProcedureReturn CocoaMessage(0, GadgetID, "tag")
      Else
        ProcedureReturn - 1
      EndIf
    EndProcedure
  EndModule
  
  DeclareModule Mouse
    Declare.i Window( )
    Declare.i Gadget( WindowID )
  EndDeclareModule
  
  Module Mouse
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
      
      ProcedureReturn handle
    EndProcedure
  EndModule
CompilerEndIf

Enumeration #PB_Event_FirstCustomValue
  #PB_Event_LeftButtonDown
  #PB_Event_LeftButtonUp
  #PB_Event_RightButtonDown
  #PB_Event_RightButtonUp
  #PB_Event_MiddleButtonDown
  #PB_Event_MiddleButtonUp
  #PB_Event_MouseMove
EndEnumeration

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

Procedure MouseState()
  Static State = 0, Gadget =-1
  Protected Click, Window, EnterGadget=-1
  Window = Mouse::Window()
  EnterGadget = ID::Gadget(Mouse::Gadget(Window))
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
    If      (GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1) : Click = #PB_Event_LeftButtonDown
    ElseIf  (GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 1) : Click = #PB_Event_RightButtonDown
    ElseIf  (GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 1) : Click = #PB_Event_MiddleButtonDown
    EndIf  
    
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
    
    If *GdkWindow
      gdk_window_get_user_data_( *GdkWindow, @handle )
      
      Protected.l x,y,mask;,*Window.GTKWindow = WindowID(Window) 
                          ;           gdk_window_get_pointer_(*Window\bin\child\window, @x, @y, @mask)
      gdk_window_get_pointer_( gtk_widget_get_toplevel_( handle ), @x, @y, @mask)
      If     (mask & #GDK_BUTTON1_MASK) : Click = #PB_Event_LeftButtonDown
      ElseIf (mask & #GDK_BUTTON3_MASK) : Click = #PB_Event_RightButtonDown
      ElseIf (mask & #GDK_BUTTON2_MASK) : Click = #PB_Event_MiddleButtonDown
      EndIf
    EndIf
    
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
    Protected mask = CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
    If mask & 1 << 0     : Click = #PB_Event_LeftButtonDown
    ElseIf mask & 1 << 1 : Click = #PB_Event_RightButtonDown
    ElseIf mask & 1 << 2 : Click = #PB_Event_MiddleButtonDown
    EndIf
  CompilerEndIf
  
  If Click 
    If Click = #PB_Event_LeftButtonDown 
      If State <> Click 
        State = Click 
        Gadget = EnterGadget
        PostEvent(#PB_Event_LeftButtonDown, Window,Gadget)
      EndIf
    EndIf
    If Click = #PB_Event_RightButtonDown
      If State <> Click 
        State = Click 
        Gadget = EnterGadget
        PostEvent(#PB_Event_RightButtonDown, Window,Gadget) 
      EndIf
    EndIf
    If Click = #PB_Event_MiddleButtonDown
      If State <> Click 
        State = Click 
        Gadget = EnterGadget
        PostEvent(#PB_Event_MiddleButtonDown, Window,Gadget) 
      EndIf
    EndIf
  Else
    If State = #PB_Event_LeftButtonDown  
      State = #PB_Event_LeftButtonUp
      PostEvent(#PB_Event_LeftButtonUp, Window,Gadget) 
    EndIf
    If State = #PB_Event_RightButtonDown 
      State = #PB_Event_RightButtonUp
      PostEvent(#PB_Event_RightButtonUp, Window,Gadget) 
    EndIf
    If State = #PB_Event_MiddleButtonDown 
      State = #PB_Event_MiddleButtonUp
      PostEvent(#PB_Event_MiddleButtonUp, Window,Gadget) 
    EndIf
  EndIf
  
  Static MouseMoveX, MouseMoveY
  Protected MouseX,MouseY
  
  If IsWindow(Window) 
    MouseX = WindowMouseX(Window) 
    MouseY = WindowMouseY(Window)
  Else
    MouseX = DesktopMouseX() 
    MouseY = DesktopMouseY()
  EndIf  
  
  If ((MouseX <>-1 And MouseY <>-1) And 
      ((MouseMoveX <> MouseX) Or (MouseMoveY <> MouseY))) 
    MouseMoveX = MouseX 
    MouseMoveY = MouseY
    PostEvent(#PB_Event_MouseMove, Window,EnterGadget)
    ProcedureReturn #True
  EndIf
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=StringGadget(-1,0,0,0,0,"StringGadget")
  g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  
  
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  
  
  Define deltaGadget=- 1, deltax, deltay
  Repeat 
    
    MouseState( )
    
    event = WindowEvent()
    
    Select event
      Case #PB_Event_LeftButtonDown
        deltaGadget = EventGadget()
        Debug deltaGadget
        
        If IsGadget( deltaGadget )
          deltax = GadgetMouseX(deltaGadget, #PB_Gadget_WindowCoordinate)
          deltay = GadgetMouseY(deltaGadget, #PB_Gadget_WindowCoordinate)
        EndIf
        
      Case #PB_Event_LeftButtonUp
        deltaGadget =- 1
        
      Case #PB_Event_MouseMove
        If deltaGadget  >= 0
          ResizeGadget(deltaGadget, DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        
      Case #PB_Event_RightButtonDown
      Case #PB_Event_RightButtonUp
      Case #PB_Event_MiddleButtonDown
      Case #PB_Event_MiddleButtonUp
      Case #PB_Event_Repaint
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 472
; FirstLine = 451
; Folding = -------------------
; EnableXP