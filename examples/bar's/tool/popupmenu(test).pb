;                                                                     - PB 
;                                                PopupMenu( [flags] ) - CreatePopupMenu( #Menu )
;                                                                       CreatePopupImageMenu( #Menu [, Flags] )
;
;                                           Menu( *parent [, flags] ) - CreateMenu( #Menu, WindowID )
;                                                                       CreateImageMenu( #Menu, WindowID [, Flags] )
; 
;                        DisplayPopup( *address, *display [, x, y] )  - DisplayPopupMenu( #Menu, WindowID [, x, y] )
;                                                                     - IsMenu( #Menu )
;                                                                     - MenuID( #Menu )
; 
;                                                     Title( Title$ ) - MenuTitle( Title$ )
;                                 GetItemText( *address, TitleIndex ) - GetMenuTitleText( #Menu, Title )
;                         SetItemText( *address, TitleIndex, text.s ) - SetMenuTitleText( #Menu, Title, Text$ )
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
   UseWidgets( )
   
   Define *menu._s_widget
   ;-
   Procedure TestHandler()
      ;ClearDebugOutput()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      ;ClearDebugOutput()
      Debug "Quit menu event"
      ; End
   EndProcedure
   
   ;\\
   Define WindowID = OpenWindow( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   
   Open(0, 50,50,400,250)
   CreateMenu(0, WindowID(0))
   MenuTitle("Title-1")
   MenuItem(1, "title-1-item-1")
   MenuBar()
   ;
   OpenSubMenu("title-1-sub-item")   
   MenuItem(3, "title-1-item")
   MenuBar()
   ;
   OpenSubMenu("title-2-sub-item")   
   MenuItem(13, "title-2-item")
   MenuBar()
   ;
   OpenSubMenu("title-3-sub-item")   
   MenuItem(23, "title-3-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(24, "title-2-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(14, "title-1-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(2, "title-1-item-2")
   
   MenuTitle("Title-2")
;    MenuItem(5, "title-2-item-1")
;    MenuItem(6, "title-2-item-2")
   
   MenuTitle("Title-event-test")
   MenuItem(7, "test")
   MenuBar( )
   MenuItem(8, "quit")
   
   MenuTitle("Title-4")
   MenuItem(9, "title-4-item-1")
   MenuItem(10, "title-4-item-2")
   
   BindMenuEvent(0, 7, @TestHandler())
   BindMenuEvent(0, 8, @QuitHandler())
   
   ;\\
   *menu = CreateBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarSeparator( )
   
   OpenSubBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarSeparator( )
   ;
   OpenSubBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarSeparator( )
   ;
   OpenSubBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseSubBar( ) 
   ;
   BarSeparator( )
   BarItem(14, "title-2-item")
   CloseSubBar( ) 
   ;
   BarSeparator( )
   BarItem(4, "title-1-item")
   CloseSubBar( ) 
   ;
   BarSeparator( )
   BarItem(2, "title-1-item-2")
   
   BarTitle("Title-2")
;    BarItem(5, "title-2-item-1")
;    BarItem(6, "title-2-item-2")
   
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarSeparator( )
   BarItem(8, "quit")
   
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   ;\\
   Define a
   ComboBox(100, 10, 250, 21, #PB_ComboBox_Editable)
    For a = 1 To 31
      AddItem(widget(), -1,"ComboBox item " + Str(a))
    Next
    
    ComboBox(100, 40, 250, 21, #PB_ComboBox_Image)
    AddItem(widget(), -1, "ComboBox item with image1", (0))
    AddItem(widget(), -1, "ComboBox item with image2", (1))
    AddItem(widget(), -1, "ComboBox item with image3", (2))
    
    ComboBox(100, 70, 250, 21)
    AddItem(widget(), -1, "ComboBox editable...1")
    AddItem(widget(), -1, "ComboBox editable...2")
    AddItem(widget(), -1, "ComboBox editable...3")
    
    SetState(ID(0), 2)
    SetState(ID(1), 1)
    SetState(ID(2), 0)    ; set (beginning with 0) the third item as active one
      
   Bind(*menu, @TestHandler(), -1, 7)
   Bind(*menu, @QuitHandler(), -1, 8)
   
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventGadget() = 777
            Debug " -777- event "
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 163
; FirstLine = 154
; Folding = -
; EnableXP