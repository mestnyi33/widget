;                                                       - PB
;                               BarSeparator( [*address] ) - ToolBarBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          CreateBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableBarButton( #ToolBar, Button, State )
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;                 SetItemText( *address, item, text.s ) - BarButtonText( #ToolBar, Button, Text$ )
;                                    Height( *address ) - ToolBarHeight( #ToolBar )
;      AddItem( *address, button, text.s, image, mode ) - ToolBarImageButton( #Button, ImageID [, Mode [, Text$]] )
;       AddItem( *address, button, text.s, icon, mode ) - ToolBarStandardButton( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemText( *address, item ) - 
;                        GetItemImage( *address, item ) - 
;                 SetItemImage( *address, item, image ) - 

;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   UsePNGImageDecoder()
   
   Enumeration 
      #_tb_group_select = 1
      
      #_tb_group_left = 3
      #_tb_group_right
      #_tb_group_top
      #_tb_group_bottom
      #_tb_group_width
      #_tb_group_height
      
      #_tb_align_left
      #_tb_align_right
      #_tb_align_top
      #_tb_align_bottom
      #_tb_align_center
      
      #_tb_new_widget_paste
      #_tb_new_widget_delete
      #_tb_new_widget_copy
      #_tb_new_widget_cut
      
      #_tb_file_run
      #_tb_file_new
      #_tb_file_open
      #_tb_file_save
      #_tb_file_SAVEAS
      #_tb_file_quit
      
      #_tb_LNG
      #_tb_lng_ENG
      #_tb_lng_RUS
      #_tb_lng_FRENCH
      #_tb_lng_GERMAN
   EndEnumeration
   Global ide_toolbar, 
          ide_popup_lenguage,
          ide_menu
   
   Procedure ide_events( )
      Protected *e_widget._s_WIDGET = EventWidget( )
      Protected BarButton = GetData( *e_widget ) 
      Debug WidgetEventItem()
      
   EndProcedure
   
   If Open( 1, 300, 200, 650, 200, "ToolBar example", #PB_Window_SizeGadget )
      a_init(root( ))
      ide_toolbar = CreateBar( root( ), #PB_ToolBar_Small )
      SetClass( ide_toolbar, "ide_toolbar")
      
      If ide_toolbar
         ide_menu = OpenSubBar("Menu")
         ;    BarItem( #_tb_file_new, "New" + Space(9) + Chr(9) + "Ctrl+O")
         BarItem( #_tb_file_new, "New (Ctrl+N)")
         BarItem( #_tb_file_open, "Open (Ctrl+O)")
         BarItem( #_tb_file_save, "Save (Ctrl+S)")
         BarItem( #_tb_file_SAVEAS, "Save as...")
         BarSeparator( )
         BarItem( #_tb_file_quit, "Quit" );+ Chr(9) + "Ctrl+Q")
         CloseSubBar( )
         ;
         BarSeparator( )
         BarItem( #_tb_file_new, "New" )
         BarItem( #_tb_file_open, "Open" )
         BarItem( #_tb_file_save, "Save" )
         BarSeparator( )
         BarButton( #_tb_new_widget_copy, CatchImage( #PB_Any,?image_new_widget_copy ) )
         BarButton( #_tb_new_widget_paste, CatchImage( #PB_Any,?image_new_widget_paste ) )
         BarButton( #_tb_new_widget_cut, CatchImage( #PB_Any,?image_new_widget_cut ) )
         BarButton( #_tb_new_widget_delete, CatchImage( #PB_Any,?image_new_widget_delete ) )
         BarSeparator( )
         BarButton( #_tb_group_select, CatchImage( #PB_Any,?image_group ), #PB_ToolBar_Toggle ) 
         ;
         ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_Image, CatchImage( #PB_Any,?image_group_un ) )
         ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_PressedImage, CatchImage( #PB_Any,?image_group ) )
         ;
         BarSeparator( )
         BarButton( #_tb_group_left, CatchImage( #PB_Any,?image_group_left ) )
         BarButton( #_tb_group_right, CatchImage( #PB_Any,?image_group_right ) )
         BarSeparator( )
         BarButton( #_tb_group_top, CatchImage( #PB_Any,?image_group_top ) )
         BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?image_group_bottom ) )
         BarSeparator( )
         BarButton( #_tb_group_width, CatchImage( #PB_Any,?image_group_width ) )
         BarButton( #_tb_group_height, CatchImage( #PB_Any,?image_group_height ) )
         ;    
         ;       BarSeparator( )
         ;       OpenSubBar("ComboBox")
         ;       BarItem(55, "item1")
         ;       BarItem(56, "item2")
         ;       BarItem(57, "item3")
         ;       CloseSubBar( )
         ;    
         BarSeparator( )
         BarItem( #_tb_file_run, "[RUN]" )
         BarItem( #_tb_lng_ENG, "ENG")
         BarItem( #_tb_lng_RUS, "RUS")
         BarSeparator( )
         
         ide_popup_lenguage = OpenSubBar("[LENGUAGE]")
         ; BarItem( #_tb_LNG, "[LENGUAGE]" )
         BarSeparator( )
         
         ; ide_popup_lenguage = CreatePopupBar( )
         If ide_popup_lenguage
            BarItem(#_tb_lng_ENG, "ENG")
            BarItem(#_tb_lng_RUS, "RUS")
            BarItem(#_tb_lng_FRENCH, "FRENCH")
            BarItem(#_tb_lng_GERMAN, "GERMAN")
         EndIf
         
         CloseList( ) 
      EndIf
      
      If Type( ide_toolbar ) = #__type_ToolBar
         ;       BindBarEvent( ide_menu, -1, @ide_events( ) )
         ;       BindBarEvent( ide_toolbar, -1, @ide_events( ) )
         ;       BindBarEvent( ide_popup_lenguage, -1, @ide_events( ) )
         Bind( ide_menu, @ide_events( ), #__event_Change )
         Bind( ide_toolbar, @ide_events( ), #__event_Change )
         Bind( ide_popup_lenguage, @ide_events( ), #__event_Change )
         Bind( ide_menu, @ide_events( ), #__event_LeftClick )
         Bind( ide_toolbar, @ide_events( ), #__event_LeftClick )
         Bind( ide_popup_lenguage, @ide_events( ), #__event_LeftClick )
      EndIf
   EndIf
   
   
   Define Event, Quit
   Repeat
      Event = WaitWindowEvent()
      
      Select Event
            
         Case #PB_Event_Menu
            Debug Str(EventMenu())+" - event item"
            
         Case #PB_Event_CloseWindow  ; If the user has pressed on the close button
            Quit = 1
            
      EndSelect
      
   Until Quit = 1
   
   
   End   ; All resources are automatically freed
   
   ;\\ include images
DataSection   
   IncludePath "../../../ide/include/images"
   
   image_new_widget_delete:    : IncludeBinary "16/delete.png"
   image_new_widget_paste:     : IncludeBinary "16/paste.png"
   image_new_widget_copy:      : IncludeBinary "16/copy.png"
   image_new_widget_cut:       : IncludeBinary "16/cut.png"
   *imagelogo:       : IncludeBinary "group/group_bottom.png"
   
   image_group:            : IncludeBinary "group/group.png"
   image_group_un:         : IncludeBinary "group/group_un.png"
   image_group_top:        : IncludeBinary "group/group_top.png"
   image_group_left:       : IncludeBinary "group/group_left.png"
   image_group_right:      : IncludeBinary "group/group_right.png"
   image_group_bottom:     : IncludeBinary "group/group_bottom.png"
   image_group_width:      : IncludeBinary "group/group_width.png"
   image_group_height:     : IncludeBinary "group/group_height.png"
EndDataSection
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 75
; FirstLine = 59
; Folding = --
; EnableXP
; DPIAware