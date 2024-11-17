;                                                       - PB
;                               Separator( [*address] ) - ToolBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableBarButtonWidget( #ToolBar, Button, State )
;                                      FreeWidget( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetBarButtonState( #ToolBar, Button, State )
;                 SetItemTextWidget( *address, item, text.s ) - BarButtonTextWidget( #ToolBar, Button, Text$ )
;                                    WidgetHeight( *address ) - ToolBarWidgetHeight( #ToolBar )
;      AddItem( *address, button, text.s, image, mode ) - ToolBarImageButtonWidget( #Button, ImageID [, Mode [, Text$]] )
;       AddItem( *address, button, text.s, icon, mode ) - ToolBarStandardButtonWidget( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarWidgetToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemTextWidget( *address, item ) - 
;                        GetWidgetItemImage( *address, item ) - 
;                 SetWidgetItemImage( *address, item, image ) - 

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
   
   Procedure ToolBarEvents( )
      Protected *e_widget._s_WIDGET = EventWidget( )
      Protected BarButton = GetData( *e_widget ) 
      
      Debug "click " + BarButton
   EndProcedure
   
   
   If OpenWindow(0, 100, 200, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
      
      If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small)
         ToolBarImageButtonWidget( #_tb_file_open, 0, #PB_ToolBar_Normal, "Open" )
      ToolBarImageButtonWidget( #_tb_file_save, 0, #PB_ToolBar_Normal, "Save" )
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_group_select, ImageID( CatchImage( #PB_Any,?group )), #PB_ToolBar_Toggle ) ;: group_select = widget( )
;       SetAttribute( widget( ), #PB_Button_Image, ImageID( CatchImage( #PB_Any,?group_un )))
;       SetAttribute( widget( ), #PB_Button_PressedImage, ImageID( CatchImage( #PB_Any,?group )))
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_group_left, ImageID( CatchImage( #PB_Any,?group_left )))
      ToolBarImageButtonWidget( #_tb_group_right, ImageID( CatchImage( #PB_Any,?group_right )))
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_group_top, ImageID( CatchImage( #PB_Any,?group_top )))
      ToolBarImageButtonWidget( #_tb_group_bottom, ImageID( CatchImage( #PB_Any,?group_bottom )))
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_group_width, ImageID( CatchImage( #PB_Any,?group_width )))
      ToolBarImageButtonWidget( #_tb_group_height, ImageID( CatchImage( #PB_Any,?group_height )))
      
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_widget_copy, ImageID( CatchImage( #PB_Any,?widget_copy )))
      ToolBarImageButtonWidget( #_tb_widget_paste, ImageID( CatchImage( #PB_Any,?widget_paste )))
      ToolBarImageButtonWidget( #_tb_widget_cut, ImageID( CatchImage( #PB_Any,?widget_cut )))
      ToolBarImageButtonWidget( #_tb_widget_delete, ImageID( CatchImage( #PB_Any,?widget_delete )))
      ToolBarSeparator( )
      ToolBarImageButtonWidget( #_tb_align_left, ImageID( CatchImage( #PB_Any,?group_left )))
      ToolBarImageButtonWidget( #_tb_align_top, ImageID( CatchImage( #PB_Any,?group_top )))
      ToolBarImageButtonWidget( #_tb_align_center, ImageID( CatchImage( #PB_Any,?group_width )))
      ToolBarImageButtonWidget( #_tb_align_bottom, ImageID( CatchImage( #PB_Any,?group_bottom )))
      ToolBarImageButtonWidget( #_tb_align_right, ImageID( CatchImage( #PB_Any,?group_right )))
      
      EndIf
      
      DisableBarButtonWidget(0, 2, 1) ; Disable the button '2'
   EndIf
   
   
   If OpenRootWidget( 1, 300, 200, 800, 380, "ToolBar example");, #PB_Window_BorderLess )
      ;a_init(root( ))
      Define w_ide_toolbar = WindowWidget( 10, 10, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      
      w_ide_toolbar = ToolBar( w_ide_toolbar, #PB_ToolBar_Small )
      BarButtonWidget( #_tb_file_open, -1, 0, "Open" )
      BarButtonWidget( #_tb_file_save, -1, 0, "Save" )
      BarSeparator( )
      BarButtonWidget( #_tb_group_select, CatchImage( #PB_Any,?group ), #PB_ToolBar_Toggle ) ;: group_select = widget( )
;       SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
;       SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
      BarSeparator( )
      BarButtonWidget( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
      BarButtonWidget( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
      BarSeparator( )
      BarButtonWidget( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
      BarButtonWidget( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
      BarSeparator( )
      BarButtonWidget( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
      BarButtonWidget( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
      
      BarSeparator( )
      BarButtonWidget( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
      BarButtonWidget( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
      BarButtonWidget( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
      BarButtonWidget( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
      BarSeparator( )
      BarButtonWidget( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
      BarButtonWidget( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
      BarButtonWidget( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
      BarButtonWidget( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
      BarButtonWidget( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
      
     ; ResizeWidget( w_ide_toolbar, 0, 60, 800,60)
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
CompilerEndIf

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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; FirstLine = 6
; Folding = --
; EnableXP