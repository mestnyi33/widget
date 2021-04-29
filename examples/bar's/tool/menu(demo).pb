;                                                                     - PB 
;                                                PopupMenu( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                           Menu( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                             Display( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
; 
;                                                     Title( Title$ ) - MenuTitle( Title$ )
;                         GetItemText( *address, #PB_Default, title ) - GetMenuTitleText( #Menu, Title )
;                 SetItemText( *address, #PB_Default, text.s, title ) - SetMenuTitleText( #Menu, Title, Text$ )
; 
;                                                    Free( *address ) - FreeMenu( #Menu )
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                                      GetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                                       GetItemText( *address, item ) - GetMenuItemText( #Menu, Item )
;                                                    Hide( *address ) - HideMenu( #Menu, State )
;                                             Separator( [*address] ) - MenuBar( )
;                                                  Height( *address ) - MenuHeight( )
;                            AddItem( *address, item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;
;                                        OpenItem( text.s [, image] ) = AddItem( *address, item, text.s, image, mode )
;                                        OpenItem( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                                        CloseItem( ) - CloseSubMenu( )
; 
;                               SetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                               SetItemText( *address, item, text.s ) - SetMenuItemText( #Menu, Item, Text$ )
;
;                      Bind( *address, @callback( ), eventtype, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnBind( *address, @callback( ), eventtype, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Procedure Menu( *parent._s_widget, flags = #Null )
;     If _is_root_( *parent )
;       CreateToolBar(#PB_Any, UseGadgetList(0)) 
;       
; ;       StartDrawing(WindowOutput(*parent\root\canvas\window))
; ;       DrawingFont(PB_( GetGadgetFont )( #PB_Default ))
; ;       Box(0,0,OutputWidth(),OutputHeight(),RGB(255,255,255))
; ;       DrawText( 5, 5, "menu", $ff000000)
; ;       StopDrawing()
;       
;       ToolBarImageButton(0, 0)
;     EndIf
    
    ;*parent\bs = 20
    ;*parent\fs = 1
    ;*parent\bs = 20
    *parent\MenuBarHeight = #__menu_height
    Debug *parent\MenuBarHeight
;     Protected i
;     For i=0 To constants::#__c-1
;       Debug "   "+i
;       Debug *parent\x[i]
;       Debug *parent\y[i]
;       Debug *parent\height[i]
;       Debug *parent\width[i]
;     Next
    
    
     Resize( *parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
     Debug 6666;     Resize( *parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
   ;;  Redraw(root())
  EndProcedure
  
  Procedure TestHandler()
    Debug "Test menu event"
  EndProcedure
  
  Procedure QuitHandler()
    Debug "Quit menu event"
    End
  EndProcedure
  
;   OpenWindow(-1,150, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
  Open(OpenWindow(#PB_Any, 100, 100, 500, 400, "main window_1", #__Window_SystemMenu))
  ;ButtonGadget( #PB_Any, 10, 10, 300-20, 100-20, "button")
  ContainerGadget( #PB_Any, 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
  
  CreateMenu(0, WindowID(GetWindow(root())))
  MenuTitle("File")
  MenuItem(0, "Test")
  MenuItem(1, "Quit")
  
  BindMenuEvent(0, 0, @TestHandler())
  BindMenuEvent(0, 1, @QuitHandler())
  
  ;
  Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
  ;Button( 10, 10, 300-20, 100-20, "button")
  Container( 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseList( )
  widget( )\bs = 8
  SetFrame(widget( ), 3);, -1)
  
  Menu( widget( )\parent ) ;root( )\window )
  
  
;   ResizeWindow(GetWindow(root()), #PB_Ignore, #PB_Ignore, 600, 600)
;   ResizeGadget(GetGadget(root()), #PB_Ignore, #PB_Ignore, 600, 600)
  Bind( #PB_Default, #PB_Default )
  
  Define Event
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP