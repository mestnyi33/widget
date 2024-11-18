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
;                                 GetWidgetItemText( *address, TitleIndex ) - GetMenuTitleTextWidget( #Menu, Title )
;                         SetWidgetItemText( *address, TitleIndex, text.s ) - SetMenuTitleTextWidget( #Menu, Title, Text$ )
; 
;                                                    FreeWidget( *address ) - FreeMenu( #Menu )
;                                DisableItem( *address, item, state ) - DisableMenuItem( #Menu, MenuItem, State )
;                                      GetWidgetItemState( *address, item ) - GetMenuItemState( #Menu, MenuItem )
;                                       GetWidgetItemText( *address, item ) - GetMenuItemTextWidget( #Menu, Item )
;                                                    Hide( *address ) - HideMenu( #Menu, State )
;                                             Separator( [*address] ) - MenuBar( )
;                                                  WidgetHeight( *address ) - MenuWidgetHeight( )
;                            AddItem( *address, item, text.s, image ) - MenuItem( MenuItemID, Text$ [, ImageID]) )
;
;                                        OpenItem( text.s [, image] ) = AddItem( *address, item, text.s, image, mode )
;                                        OpenItem( text.s [, image] ) - OpenSubMenu( Text$ [, ImageID] )
;                                                        CloseItem( ) - CloseSubMenu( )
; 
;                               SetWidgetItemState( *address, item, state ) - SetMenuItemState( #Menu, MenuItem, State )
;                               SetWidgetItemText( *address, item, text.s ) - SetMenuItemTextWidget( #Menu, Item, Text$ )
;
;                      BindWidgetEvent( *address, @callback( ), eventtype, item) - BindMenuEvent( #Menu, MenuItem, @Callback( ) )
;                    UnBindWidgetEvent( *address, @callback( ), eventtype, item) - UnbindMenuEvent( #Menu, MenuItem, @Callback( ) )

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
   Define WindowID = OpenRoot( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   ;\\
   ; ButtonWidget( 415, 180, 80, 35, "Button1" ) : SetWidgetClass(widget(), "Button1" )
   *menu = CreateBar( root( ) ) : SetWidgetClass(widget( ), "root_MenuBar" )
   
   ;\\
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
   BarItem(23, "test(EVENT)")
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
   
   ;\\
   BarTitle("Title-2")
   ;    BarItem(5, "title-2-item-1")
   ;    BarItem(6, "title-2-item-2")
   
   ;\\
   BarTitle("Title-event-test")
   BarItem(7, "test")
   BarSeparator( )
   BarItem(8, "quit")
   
   ;\\
   BarTitle("Title-4")
   BarItem(9, "title-4-item-1")
   BarItem(10, "title-4-item-2")
   
   ;BindWidgetEvent(*menu, @TestHandler(), -1, 7)
   BindWidgetEvent(*menu, @QuitHandler(), -1, 8)
   BindWidgetEvent(*menu, @TestHandler(), -1, 23)
   
   
   
   
   If StartEnum( root( ) )
      Debug widget( )\class
      StopEnum( )
   EndIf
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         ;
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 21
; FirstLine = 17
; Folding = -
; EnableXP
; DPIAware