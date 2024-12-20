﻿;                                                                     - PB 
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
;                                             BarBar( [*address] ) - MenuBar( )
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
   Define WindowID = Open( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   ;\\
   ; Button( 415, 180, 80, 35, "Button1" ) : SetClass(widget(), "Button1" )
   *menu = CreateMenuBar( root( ) ) 
   SetClass(widget( )\root, "mainroot" )
   
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
   
   ;Bind(*menu, @TestHandler(), -1, 7)
   Bind(*menu, @QuitHandler(), -1, 8)
   Bind(*menu, @TestHandler(), -1, 23)
   
   
   
   
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
; CursorPosition = 26
; FirstLine = 16
; Folding = -
; EnableXP
; DPIAware