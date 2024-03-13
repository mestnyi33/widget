;                                                                     - PB 
;                                       CreatePopupMenuBar( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                  CreateMenuBar( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                             Display( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
; 
;                                              MenuBarTitle( Title$ ) - MenuTitle( Title$ )
;                                 GetItemText( *address, TitleIndex ) - GetMenuTitleText( #Menu, Title )
;                         SetItemText( *address, TitleIndex, text.s ) - SetMenuTitleText( #Menu, Title, Text$ )
; 
;                                                    Free( *address ) - FreeMenu( #Menu )
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                                      GetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                                       GetItemText( *address, item ) - GetMenuItemText( #Menu, Item )
;                                                    Hide( *address ) - HideMenu( #Menu, State )
;                                      MenuBarSeparator( [*address] ) - MenuBar( )
;                                                  Height( *address ) - MenuHeight( )
;                            AddItem( *address, item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;
;                                     MenuBarItem( text.s [, image] ) = AddItem( *address, item, text.s, image, mode )
;                              MenuBarOpenSubItem( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                              MenuBarCloseSubItem( ) - CloseSubMenu( )
; 
;                        MenuBarSetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                        MenuBarSetItemText( *address, item, text.s ) - SetMenuItemText( #Menu, Item, Text$ )
;
;          BindMenuBarEvent( *address, @callback( ), eventtype, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnBind( *address, @callback( ), eventtype, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global *menu
   
   Procedure PopupMenu( x, y, width, height )
      Protected *parent._s_WIDGET
      *parent = Root( ) ; Container( x, y, width + x*2, height + y*2 ) ; 
      
      __gui\popupmenu = Create( *parent, *parent\class + "PopupMenu", #__type_Menu,
                           x, y, width, height, #Null$, #__flag_vertical, 0, 0, 0, 0, 0, 30 ) ; |#__flag_vertical|#__flag_child
      SetColor( __gui\popupmenu, #__color_back, $FFF7FDFF)
      
      ;CloseList( ) ; *parent
      
      widget( ) = __gui\popupmenu 
      
      ProcedureReturn __gui\popupmenu
   EndProcedure
   
   Procedure PopupMenuBar( flag = #Null ) 
      ;__gui\popupmenu = Create( root( ), "PopupMenu", #__type_ListView, 0, 0, 0, 0, #Null$, #__flag_child | #__flag_nobuttons | #__flag_nolines ) ;| #__flag_borderless
      __gui\popupmenu = Create( root( ), "PopupMenu", #__type_Menu, 0, 0, 0, 0, #Null$, #__flag_child|#__flag_vertical, 0, 0, 0, 0, 0, 30 )
      
      
      ;Hide( __gui\popupmenu, #True )
      ProcedureReturn __gui\popupmenu
   EndProcedure
   
   Procedure MenuBarItem( item, text.s, image = - 1 )
      If __gui\popupmenu
         AddItem( __gui\popupmenu, - 1, text, image )
         If __gui\popupmenu[1]
            Protected *parent_row._s_ROWS = __gui\popupmenu\data
            
            If *parent_row
               *parent_row\childrens + 1
               *parent_row\data = __gui\popupmenu
               __gui\popupmenu\__tabs( )\parent = *parent_row
            EndIf
            
         EndIf
      EndIf
      ProcedureReturn __gui\popupmenu\__tabs( )
   EndProcedure
   
   Procedure MenuBarSeparator( )
      If __gui\popupmenu
         AddItem( __gui\popupmenu, #PB_Ignore, "", - 1, #Null )
         __gui\popupmenu\__tabs( )\itemindex = #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure MenuBarOpenSubItem( text.s, image =- 1)
      Protected *item._s_ROWS 
      *item = MenuBarItem( #PB_Ignore, text.s, image )
      
      __gui\popupmenu[1] = __gui\popupmenu
      ;
      __gui\popupmenu = PopupMenu( 200,50,200,100 )
      __gui\popupmenu\data = *item
      Hide(__gui\popupmenu,  1) 
      ;*item\data = __gui\popupmenu
      ;
      ProcedureReturn __gui\popupmenu
   EndProcedure
   
   Procedure MenuBarCloseSubItem( )
      If __gui\popupmenu[1]
         __gui\popupmenu = __gui\popupmenu[1]
         __gui\popupmenu[1] = 0
      EndIf
   EndProcedure
   
   ;-
   Macro row_x_( _this_, _address_ )
      ( _this_\inner_x( ) + _address_\x )  ; + _this_\scroll_x( )
   EndMacro
   
   Macro row_y_( _this_, _address_ )
      ( _this_\inner_y( ) + _address_\y )
   EndMacro
   
   Procedure.b bar_area_update( *this._s_WIDGET )
      Protected result.b
      
      ;\\ change vertical scrollbar max
      If *this\scroll\v And *this\scroll\v\bar\max <> *this\scroll_height( ) And
         bar_SetAttribute( *this\scroll\v, #PB_ScrollBar_Maximum, *this\scroll_height( ) )
         result = 1
      EndIf
      
      ;\\ change horizontal scrollbar max
      If *this\scroll\h And *this\scroll\h\bar\max <> *this\scroll_width( ) And
         bar_SetAttribute( *this\scroll\h, #PB_ScrollBar_Maximum, *this\scroll_width( ) )
         result = 1
      EndIf
      
      If result
         bar_area_resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure.l update_items_( *this._s_WIDGET, List *items._s_ROWS( ), _change_ = 1 )
      Protected state.b, x.l, y.l
      
      With *this
         If Not *this\hide
            ;\\ update coordinate
            If _change_ > 0
               ; Debug "   " + #PB_Compiler_Procedure + "( )"
               
               ;\\
               ReDrawing( *this, *this\EnteredLine( ) )
               
               
               ;\\ if the item list has changed
               *this\scroll_width( ) = 0
               If ListSize( *this\columns( ) )
                  *this\scroll_height( ) = *this\columns( )\height
               Else
                  *this\scroll_height( ) = 0
               EndIf
               
               ; reset item z - order
               Protected buttonpos = 6
               Protected buttonsize = 9
               Protected boxpos = 4
               Protected boxsize = 11
               Protected bs = Bool( *this\fs )
               
               ;\\
               PushListPosition( *this\__rows( ))
               ForEach *this\__rows( )
                  *this\__rows( )\index = ListIndex( *this\__rows( ))
                  
                  If *this\__rows( )\hide
                     *this\__rows( )\visible = 0
                  Else
                     ;\\ drawing item font
                     draw_font_item_( *this, *this\__rows( ), *this\__rows( )\TextChange( ) )
                     
                     ;\\ draw items height
                     CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                        CompilerIf Subsystem("qt")
                           *this\__rows( )\height = *this\__rows( )\text\height - 1
                        CompilerElse
                           *this\__rows( )\height = *this\__rows( )\text\height + 3
                        CompilerEndIf
                     CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
                        *this\__rows( )\height = *this\__rows( )\text\height + 4
                     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
                        If *this\type = #__type_ListView
                           *this\__rows( )\height = *this\__rows( )\text\height
                        Else
                           *this\__rows( )\height = *this\__rows( )\text\height + 2
                        EndIf
                     CompilerEndIf
                     
                     *this\__rows( )\y = *this\scroll_height( )
                     
                     If *this\row\column = 0
                        ;\\ check box size
                        If ( *this\mode\check = #__m_checkselect Or
                             *this\mode\check = #__m_optionselect )
                           *this\__rows( )\checkbox\width  = boxsize
                           *this\__rows( )\checkbox\height = boxsize
                        EndIf
                        
                        ;\\ collapse box size
                        If ( *this\mode\Lines Or *this\mode\Buttons ) And
                           Not ( *this\__rows( )\sublevel And *this\mode\check = #__m_optionselect )
                           *this\__rows( )\buttonbox\width  = buttonsize
                           *this\__rows( )\buttonbox\height = buttonsize
                        EndIf
                        
                        ;\\ sublevel position
                        *this\row\sublevelpos = *this\__rows( )\sublevel * *this\row\sublevelsize + Bool( *this\mode\check ) * (boxpos + boxsize) + Bool( *this\mode\Lines Or *this\mode\Buttons ) * ( buttonpos + buttonsize )
                        
                        ;\\ check & option box position
                        If ( *this\mode\check = #__m_checkselect Or
                             *this\mode\check = #__m_optionselect )
                           
                           If *this\__rows( )\ParentRow( ) And *this\mode\check = #__m_optionselect
                              *this\__rows( )\checkbox\x = *this\row\sublevelpos - *this\__rows( )\checkbox\width
                           Else
                              *this\__rows( )\checkbox\x = boxpos
                           EndIf
                           *this\__rows( )\checkbox\y = ( *this\__rows( )\height ) - ( *this\__rows( )\height + *this\__rows( )\checkbox\height ) / 2
                        EndIf
                        
                        ;\\ expanded & collapsed box position
                        If ( *this\mode\Lines Or *this\mode\Buttons ) And Not ( *this\__rows( )\sublevel And *this\mode\check = #__m_optionselect )
                           
                           If *this\mode\check = #__m_optionselect
                              *this\__rows( )\buttonbox\x = *this\row\sublevelpos - 10
                           Else
                              *this\__rows( )\buttonbox\x = *this\row\sublevelpos - (( buttonpos + buttonsize ) - 4)
                           EndIf
                           
                           *this\__rows( )\buttonbox\y = ( *this\__rows( )\height ) - ( *this\__rows( )\height + *this\__rows( )\buttonbox\height ) / 2
                        EndIf
                        
                        ;\\ image position
                        If *this\__rows( )\image\id
                           *this\__rows( )\image\x = *this\row\sublevelpos + *this\image\padding\x + 2
                           *this\__rows( )\image\y = ( *this\__rows( )\height - *this\__rows( )\image\height ) / 2
                           
                           If *this\type = #__type_ListIcon
                              *this\row\sublevelpos = *this\__rows( )\image\x
                           EndIf
                        Else
                           If *this\type = #__type_ListIcon
                              ;*this\row\sublevelpos = *this\__rows( )\x
                           EndIf
                        EndIf
                        
                     EndIf
                     
                     If *this\row\column = 0
                        *this\__rows( )\x = *this\columns( )\x
                     Else
                        *this\__rows( )\x = *this\columns( )\x + *this\row\sublevelpos + *this\MarginLine( )\width
                     EndIf
                     
                     ;\\ text position
                     If *this\__rows( )\text\string
                        If *this\row\column > 0
                           *this\__rows( )\text\x = *this\text\padding\x
                        Else
                           *this\__rows( )\text\x = *this\row\sublevelpos + *this\MarginLine( )\width + *this\text\padding\x
                        EndIf
                        *this\__rows( )\text\y = ( *this\__rows( )\height - *this\__rows( )\text\height ) / 2
                     EndIf
                     
                     ;\\ vertical scroll max value
                     *this\scroll_height( ) + *this\__rows( )\height + Bool( *this\__rows( )\index <> *this\count\items - 1 ) * *this\mode\GridLines
                     
                     ;\\ horizontal scroll max value
                     If *this\type = #__type_ListIcon
                        If *this\scroll_width( ) < ( *this\row\sublevelpos + *this\text\padding\x + *this\MarginLine( )\width + *this\columns( )\x + *this\columns( )\width )
                           *this\scroll_width( ) = ( *this\row\sublevelpos + *this\text\padding\x + *this\MarginLine( )\width + *this\columns( )\x + *this\columns( )\width )
                        EndIf
                     Else
                        If *this\scroll_width( ) < ( *this\__rows( )\x + *this\__rows( )\text\x + *this\__rows( )\text\width + *this\mode\fullSelection + *this\text\padding\x * 2 ) ; - *this\inner_x( )
                           *this\scroll_width( ) = ( *this\__rows( )\x + *this\__rows( )\text\x + *this\__rows( )\text\width + *this\mode\fullSelection + *this\text\padding\x * 2 ) ; - *this\inner_x( )
                        EndIf
                     EndIf
                  EndIf
               Next
               PopListPosition( *this\__rows( ))
               
               ;\\
               If *this\mode\gridlines
                  ; *this\scroll_height( ) - *this\mode\gridlines
               EndIf
            EndIf
         EndIf
      EndWith
      
   EndProcedure
   
   Procedure ChangeParent( *this._s_WIDGET, *parent._s_WIDGET )
      ;\\
      *parent\haschildren + 1
      
      ;\\
      If *parent\root
         If Not is_root_( *parent )
            *parent\root\haschildren + 1
         EndIf
         *this\root = *parent\root
      Else
         *this\root = *parent
      EndIf
      
      ;\\
      If is_window_( *parent )
         *this\window = *parent
      Else
         If *parent\window
            *this\window = *parent\window
         Else
            *this\window = *parent
         EndIf
      EndIf
      
      *this\level  = *parent\level + 1
      *this\parent = *parent
      
      ;\\ is integrall scroll bars
      If *this\scroll
         If *this\scroll\v
            *this\scroll\v\root   = *this\root
            *this\scroll\v\window = *this\window
         EndIf
         If *this\scroll\h
            *this\scroll\h\root   = *this\root
            *this\scroll\h\window = *this\window
         EndIf
      EndIf
      
      ;\\ is integrall tab bar
      If *this\TabBox( )
         *this\TabBox( )\root   = *this\root
         *this\TabBox( )\window = *this\window
      EndIf
      
      ;\\ is integrall string bar
      If *this\StringBox( )
         *this\StringBox( )\root   = *this\root
         *this\StringBox( )\window = *this\window
      EndIf
      
      ;\\
      If *parent\bounds\children
         MoveBounds( *this )
      EndIf
   EndProcedure
   
   Procedure CreatePopup( *display._s_WIDGET = 0, flags.q = 0 )
      Protected Window
      Protected WindowID
      Protected ParentID
      Protected *root
      
      ;\\
      If *display
         ParentID = WindowID( *display\root\canvas\window )
      EndIf
      
      ;\\
      *root    = Open( #PB_Any, 0, 0, 1, 1, "", flags | #PB_Window_Invisible, ParentID )
      Window   = GetWindow( *root )
      WindowID = WindowID( Window )
      
      ;\\
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         If CocoaMessage(0, WindowID, "hasShadow") = 0
            CocoaMessage(0, WindowID, "setHasShadow:", 1)
         EndIf
         
         ;\\
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
         If GetClassLongPtr_( WindowID, #GCL_STYLE ) & #CS_DROPSHADOW = 0
            SetClassLongPtr_( WindowID, #GCL_STYLE, #CS_DROPSHADOW )
         EndIf
         
      CompilerElse
         
      CompilerEndIf
      
      ;\\ Important is #PB_Window_Invisible and
      ;\\ HideWindow( )... Without them, there is no shadow....
      HideWindow( Window, #False, #PB_Window_NoActivate)
      ProcedureReturn *root
   EndProcedure
   
   Procedure DisplayMenu( *this._s_WIDGET, *display._s_WIDGET, x.l = #PB_Ignore, y.l = #PB_Ignore )
      Protected width
      Protected height
      Protected mode = 0
      
      ;\\
      If *this
         ;\\ hide current popup widget
         Hide( *this, *this\hide ! 1 )
         
         ;\\
         If *display
            If x = #PB_Ignore
               x = GadgetX( *display\root\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + *display\x + 1
            Else
               x + *display\x + 1
            EndIf
            If y = #PB_Ignore
               y = GadgetY( *display\root\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + *display\y + *display\height
            Else
               y + *display\y + 1
            EndIf
            
            ;\\ ComboBox
            If *display\CombButton( )
               If *this\hide
                  *display\CombButton( )\arrow\direction = 2
               Else
                  *display\CombButton( )\arrow\direction = 3
               EndIf
            EndIf
         EndIf
         
         ;\\ hide previews popup widget
         If Popup( )
            If Popup( )\widget
               If Popup( )\widget <> *this
                  ChangeParent( Popup( )\widget, Popup( )\parent )
                  Hide( Popup( )\widget, #True )
               EndIf
            EndIf
         EndIf
         
         ;\\
         If *this\hide
            If Popup( )
               Debug "display - hide"
               Popup( )\widget = #Null
               If PressedWidget( ) = *this
                  PressedWidget( ) = *display
               EndIf
               HideWindow( Popup( )\canvas\window, #True, #PB_Window_NoActivate )
            EndIf
         Else
            ;\\
            If Popup( )
               If Popup( )\widget
                  Debug "display - resize"
               Else
                  Debug "display - show"; +" "+ Popup( )\width +" "+ Popup( )\height
                  HideWindow( Popup( )\canvas\window, #False, #PB_Window_NoActivate )
               EndIf
            Else
               Debug "display - create "
               Popup( ) = CreatePopup( *display, #PB_Window_NoActivate | #PB_Window_NoGadgets | #PB_Window_BorderLess )
            EndIf
            
            ;\\
            Debug "" + *this\root\class + " " + *display\root\class
            If *this\root = *display\root
               Debug "display - update"
               If *this\row
                  update_items_( *this, *this\__rows( ) )
               Else
                  bar_tab_update_items_( *this, *this\__tabs( ) )
               EndIf
               
               If *this\scroll And 
                  ( *this\scroll\v Or *this\scroll\h )
                  bar_area_update( *this )
               EndIf
               *this\autosize = 0
               Resize( *this, #PB_Ignore, #PB_Ignore, *this\root\width, *this\root\height )
               *this\autosize = 1
            EndIf
            
            ;\\
            If *this\scroll And
               *this\scroll\v And
               Not *this\scroll\v\hide
               width = *this\scroll\v\width
            EndIf
            width + *this\scroll_width( )
            
            ;\\
            If *this\type = #__type_TabBar Or
               *this\type = #__type_ToolBar Or 
               *this\type = #__type_Menu 
               
               ForEach *this\__tabs( )
                  height + *this\__tabs( )\height
                  
                  If mode
                     If *this\__tabs( )\focus
                        y = GadgetY( *display\root\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + ( Mouse( )\y - row_y_( *this, *this\__tabs( ) ) - *this\__tabs( )\height / 2 )
                     EndIf
                  EndIf
                  
                  If ( ListIndex(*this\__tabs( )) + 1 ) >= 10
                     Break
                  EndIf
               Next
               ; height = 100
               
            ElseIf *this\row
               ForEach *this\__rows( )
                  height + *this\__rows( )\height
                  
                  If mode
                     If *this\__rows( )\focus
                        y = GadgetY( *display\root\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + ( Mouse( )\y - row_y_( *this, *this\__rows( ) ) - *this\__rows( )\height / 2 )
                     EndIf
                  EndIf
                  
                  If ( ListIndex(*this\__rows( )) + 1 ) >= 10
                     Break
                  EndIf
               Next
            Else
               height = *this\inner_height( )
            EndIf
            
            ;\\
            width + *this\fs * 2
            height + *this\fs * 2
            
            ;\\
            If width < *display\width - 2
               width = *display\width - 2
            EndIf
            
            Debug ""+width +" "+ height
            ;\\
            If mode
               x = GadgetX( *display\root\canvas\gadget, #PB_Gadget_ScreenCoordinate ) + Mouse( )\x - width / 2
            EndIf
            
            ;\\
            ; StickyWindow( window, #True )
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
               ; var windowLevel: UIWindow.Level { get set } ; stay on top
               CocoaMessage(0, WindowID(Popup( )\canvas\window), "setLevel:", 3)
               ; Debug CocoaMessage(0, WindowID(Popup( )\canvas\window), "level")
            CompilerEndIf
            
            ;\\
            Popup( )\widget = *this
            Popup( )\parent = *display
            ChangeParent( *this, Popup( ) )
            PostRepaint( Popup( ) )
            
            ;\\
            If *display\round
               x + *display\round
               width - *display\round * 2
            EndIf
            
            ;\\
            If Popup( )\width = width And
               Popup( )\height = height
               ; Debug ""+ WindowWidth( Popup( )\canvas\window ) +" "+  WindowHeight( Popup( )\canvas\window ) +" "+Popup( )\width +" "+ Popup( )\height
               Resize( Popup( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            ;           ;\\
            ;           CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            ;             ResizeWindow( Popup( )\canvas\window, x, y, width-6, height-29 )
            ;           CompilerElse
            ResizeWindow( Popup( )\canvas\window, x, y, width, height )
            ;           CompilerEndIf
            ProcedureReturn #True
         EndIf
      EndIf
   EndProcedure
   
   ;-
   Procedure TestHandler()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      Debug "Quit menu event"
      End
   EndProcedure
   
   Procedure ClickHandler( )
      If is_root_( EventWidget( ))
         DisplayPopupMenu( 0, WindowID(EventWindow()))
      Else
         DisplayMenu( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
      EndIf
   EndProcedure
   
   ;\\
   Define window = GetWindow(Open( 1, 100, 100, 500, 400, "main window_1", #__Window_SystemMenu))
   ;Define container = ContainerGadget( #PB_Any, 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
   
   
   CreatePopupMenu( 0 )
   MenuItem(1, "Open")      ; You can use all commands for creating a menu
   MenuItem(2, "Save")      ; just like in a normal menu...
   MenuBar()
   OpenSubMenu("open sub item")
   MenuItem(5, "1 sub item")
   MenuItem(6, "2 sub item")
   CloseSubMenu()
   MenuBar()
   MenuItem(3, "Save as")
   MenuItem(4, "Quit")
   
   BindMenuEvent(0, 6, @TestHandler())
   BindMenuEvent(0, 4, @QuitHandler())
   
   ;
   Define *window._s_widget = Window(100, 100, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 10, 10, 300-20, 100-20, #PB_Container_Flat ) : CloseList( )
   CloseList( )
   ;   widget( )\bs = 8
   ;   SetFrame(widget( ), 3);, -1)
   
   ;*menu = PopupMenuBar( )
   PopupMenu( 10, 10, 200, 200 )
   
   MenuBarItem(1, "Open")      ; You can use all commands for creating a menu
   MenuBarItem(2, "Save")      ; just like in a normal menu...
   MenuBarSeparator( )
   MenuBarOpenSubItem("open sub item")
   MenuBarItem(5, "1 sub item")
   MenuBarItem(6, "2 sub item")
   MenuBarCloseSubItem()
   MenuBarSeparator( )
   MenuBarItem(3, "Save as")
   MenuBarItem(4, "Quit")
   
   ;   Bind(*menu, @TestHandler(), 7)
   ;   Bind(*menu, @QuitHandler(), 8)
   
   
   
   Bind(root(), @ClickHandler(), #__event_LeftClick)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 96
; FirstLine = 90
; Folding = --8+---0-e------
; EnableXP