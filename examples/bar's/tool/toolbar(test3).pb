;                                                       - PB
;                               Separator( [*address] ) - ToolBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
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

#IDE_path = "../../../"
XIncludeFile #IDE_path + "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   UsePNGImageDecoder()
   
   Global *toolbar._s_widget, th=24
   
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
      
      #_tb_widget_paste
      #_tb_widget_delete
      #_tb_widget_copy
      #_tb_widget_cut
      
      #_tb_file_open
      #_tb_file_save
      #_tb_file_save_as
      
   EndEnumeration
   
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class +"_"+ widgets( )\TabIndex( ) ; TabAddIndex( ) ; TabState( )
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   
   Procedure ToolBarEvents( )
      Protected *e_widget._s_WIDGET = EventWidget( )
      Protected BarButton = WidgetEventItem( ) ; GetData( *e_widget ) 
      
      If *e_widget\TabEntered( )
         Debug "click " + BarButton +" "+ *e_widget\TabEntered( )\itemindex
      EndIf
   EndProcedure
   
   If OpenWindow( 0, 30, 200, 800, 380, "ToolBar example")   
      If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large|#PB_ToolBar_Text);|#PB_ToolBar_InlineText)
         ToolBarImageButton( #_tb_file_open, 0, 0, "Open" )
         ToolBarImageButton( #_tb_file_save, 0, 0, "Save" )
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_group_select, ImageID(CatchImage( #PB_Any,?group )), #PB_ToolBar_Toggle ) ;: group_select = widget( )
                                                                                                            ;       SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
                                                                                                            ;       SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_group_left, ImageID(CatchImage( #PB_Any,?group_left )) )
         ToolBarImageButton( #_tb_group_right, ImageID(CatchImage( #PB_Any,?group_right )) )
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_group_top, ImageID(CatchImage( #PB_Any,?group_top )) )
         ToolBarImageButton( #_tb_group_bottom, ImageID(CatchImage( #PB_Any,?group_bottom )) )
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_group_width, ImageID(CatchImage( #PB_Any,?group_width )) )
         ToolBarImageButton( #_tb_group_height, ImageID(CatchImage( #PB_Any,?group_height )) )
         
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_widget_copy, ImageID(CatchImage( #PB_Any,?widget_copy )) )
         ToolBarImageButton( #_tb_widget_paste, ImageID(CatchImage( #PB_Any,?widget_paste )) )
         ToolBarImageButton( #_tb_widget_cut, ImageID(CatchImage( #PB_Any,?widget_cut )) )
         ToolBarImageButton( #_tb_widget_delete, ImageID(CatchImage( #PB_Any,?widget_delete )) )
         ToolBarSeparator( )
         ToolBarImageButton( #_tb_align_left, ImageID(CatchImage( #PB_Any,?group_left )) )
         ToolBarImageButton( #_tb_align_top, ImageID(CatchImage( #PB_Any,?group_top )) )
         ToolBarImageButton( #_tb_align_center, ImageID(CatchImage( #PB_Any,?group_width )) )
         ToolBarImageButton( #_tb_align_bottom, ImageID(CatchImage( #PB_Any,?group_bottom )) )
         ToolBarImageButton( #_tb_align_right, ImageID(CatchImage( #PB_Any,?group_right )) )
         
      EndIf
      
      ;DisableBarButton(0, 2, 1) ; Disable the button '2'
      
      
      Define w_ide_toolbar, w_ide_toolbar_container                          ;= Window( 10, 10, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      
      Open(0,10,10+ToolBarHeight(0),780,300)
      ;a_init(root( ), 0)
      
      w_ide_toolbar_container = Container( 10,10,700,120 )
      ;w_ide_toolbar_container = Window( 10,60,700,120, "", #PB_Window_SystemMenu )
      ;w_ide_toolbar_container = Panel( 10,60,700,120 )
      
      Button( 10,10, 50,50,"btn0" ) : SetClass(widget( ), "btn0" )
      
      w_ide_toolbar = ToolBar( w_ide_toolbar_container, #PB_ToolBar_Small)
      BarButton( #_tb_file_open, -1, 0, "Open" )
      BarButton( #_tb_file_save, -1, 0, "Save" )
      Separator( )
      BarButton( #_tb_group_select, CatchImage( #PB_Any,?group ), #__flag_ButtonToggle ) ;: group_select = widget( )
      
      ;       SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
      ;       SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
      Separator( )
      BarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
      BarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
      Separator( )
      BarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
      BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
      Separator( )
      BarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
      BarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
      
      Separator( )
      BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
      BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
      BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
      BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
      Separator( )
      BarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
      BarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
      BarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
      BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
      BarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
      
      Bind( w_ide_toolbar, @ToolBarEvents( ), #__event_LeftClick )
      ;Bind( w_ide_toolbar, @ToolBarEvents( ), #__event_Change )
      
      Button( 110,10, 50,50,"btn1" ) : SetClass(widget( ), "btn1" )
   CloseList( ) ;: Resize( w_ide_toolbar, 0, 0, 800,60)
   
   
   ; a_set( w_ide_toolbar_container )
   
EndIf

Show_DEBUG( )

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

DataSection   
   IncludePath #IDE_path + "ide/include/images"
   
   file_open:        : IncludeBinary "delete1.png"
   file_save:        : IncludeBinary "paste.png"
   
   widget_delete:    : IncludeBinary "delete1.png"
   widget_paste:     : IncludeBinary "paste.png"
   widget_copy:      : IncludeBinary "copy.png"
   widget_cut:       : IncludeBinary "cut.png"
   
   group:            : IncludeBinary "group/group.png"
   group_un:         : IncludeBinary "group/group_un.png"
   group_top:        : IncludeBinary "group/group_top.png"
   group_left:       : IncludeBinary "group/group_left.png"
   group_right:      : IncludeBinary "group/group_right.png"
   group_bottom:     : IncludeBinary "group/group_bottom.png"
   group_width:      : IncludeBinary "group/group_width.png"
   group_height:     : IncludeBinary "group/group_height.png"
EndDataSection
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 206
; FirstLine = 122
; Folding = --
; EnableXP