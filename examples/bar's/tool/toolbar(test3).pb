;                                                       - PB
;                               Separator( [*address] ) - ToolBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableToolBarButton( #ToolBar, Button, State )
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetToolBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetToolBarButtonState( #ToolBar, Button, State )
;                 SetItemText( *address, item, text.s ) - ToolBarButtonText( #ToolBar, Button, Text$ )
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
   Uselib(widget)
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
      Protected toolbarbutton = WidgetEventItem( ) ; GetData( *e_widget ) 
      
      Debug "click " + toolbarbutton +" "+ *e_widget\EnteredTab( )\index
   EndProcedure
   
   
   Procedure _ToolBar( *parent._s_WIDGET, flag.i = #PB_ToolBar_Small )
      Protected *this._s_WIDGET = widget::Tab(0, 0, 100, 30)
      SetAlignment( *this, #__align_full|#__align_top )
      
      Bind( *this, @ToolBarEvents( ), #__event_LeftClick )
      ;Bind( *this, @ToolBarEvents( ), #__event_Change )
      
      ProcedureReturn *this
   EndProcedure
   
   Macro _ToolBarButton( _button_, _image_, _mode_=0, _text_="" )
      If widget( )
         AddItem( widget( ), -1, _text_, _image_, _mode_)
         widget( )\__tabs( )\index = _button_
      EndIf
   EndMacro
   
   Macro _Separator( )
      If widget( )
         AddItem( widget( ), 65535, "|", - 1, #Null )
      EndIf
   EndMacro
   
   
   Macro ToolBar( parent, flag = #PB_ToolBar_Small )
      _ToolBar( parent, flag )
      ;    Container( 0,0,0,0 ) 
      ;    widget( )\class = "TOOLBAR"
      ;    Text( widget( )\x+widget( )\width, 5,3,30,"" )
      ;    widget( )\class = "^"
   EndMacro
   
   Macro ToolBarButton( _button_, _image_, _mode_=0, _text_="" )
      _ToolBarButton( _button_, _image_, _mode_, _text_ )
      ;    If _image_
      ;       ButtonImage(( ( widget( )\x+widget( )\width ) ), 5,30,30,_image_, _mode_ )
      ;    Else
      ;       Button(( ( widget( )\x+widget( )\width ) ), 5,50,30,_text_, _mode_ )
      ;    EndIf
      ;    
      ;    ;widget( )\color = widget( )\parent\color
      ;    widget( )\class = "TOOLBAR_BOTTON_"+MacroExpandedCount
      ;    widget( )\data = _button_
      ;    
      ;    Bind( widget( ), @ide_events( ) )
   EndMacro
   
   Macro Separator( )
      _Separator( )
      ;    Text( widget( )\x+widget( )\width, 5,1,30,"" )
      ;    widget( )\class = "<"
      ;    Button( widget( )\x+widget( )\width, 5+3,1,30-6,"" )
      ;    widget( )\class = "|"
      ;    ; SetData( widget( ), - MacroExpandedCount )
      ;    Text( widget( )\x+widget( )\width, 5,1,30,"" )
      ;    widget( )\class = ">"
   EndMacro
   
   
   If OpenWindow(0, 100, 200, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
      
      If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small)
         ToolBarImageButton(0, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
         ToolBarImageButton(1, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
         ToolBarImageButton(2, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"))
         
         ToolBarSeparator()
         
         ToolBarImageButton(3, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
         ToolBarToolTip(0, 3, "Cut")
         
         ToolBarImageButton(4, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
         ToolBarToolTip(0, 4, "Copy")
         
         ToolBarImageButton(5, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
         ToolBarToolTip(0, 5, "Paste")
         
         ToolBarSeparator()
         
         ToolBarImageButton(6, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
         ToolBarToolTip(0, 6, "Find a document")
      EndIf
      
      DisableToolBarButton(0, 2, 1) ; Disable the button '2'
   EndIf
   
   
   If Open( 1, 300, 200, 800, 380, "ToolBar example");, #PB_Window_BorderLess )
                                                     ;a_init(root( ))
      Define w_ide_toolbar                           ;= Window( 10, 10, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      
      w_ide_toolbar = ToolBar( w_ide_toolbar )
      ToolBarButton( #_tb_file_open, -1, 0, "Open" )
      ToolBarButton( #_tb_file_save, -1, 0, "Save" )
      Separator( )
      ToolBarButton( #_tb_group_select, CatchImage( #PB_Any,?group ), #PB_Button_Toggle ) ;: group_select = widget( )
                                                                                          ;       SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
                                                                                          ;       SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
      Separator( )
      ToolBarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
      ToolBarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
      Separator( )
      ToolBarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
      ToolBarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
      Separator( )
      ToolBarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
      ToolBarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
      
      Separator( )
      ToolBarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
      ToolBarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
      ToolBarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
      ToolBarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
      Separator( )
      ToolBarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
      ToolBarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
      ToolBarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
      ToolBarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
      ToolBarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
      
      ;CloseList( ) : Resize( w_ide_toolbar, 0, 0, 800,60)
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 60
; FirstLine = 50
; Folding = ---
; EnableXP