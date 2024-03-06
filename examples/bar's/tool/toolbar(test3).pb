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
   
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach __widgets( )
         ;Debug __widgets( )\class
         line = "  "
         
         If __widgets( )\before\widget
            line + __widgets( )\before\widget\class +" <<  "    ;  +"_"+__widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + __widgets( )\class +"_"+ __widgets( )\TabIndex( ) ; TabAddIndex( ) ; TabState( )
         
         If __widgets( )\after\widget
            line +"  >> "+ __widgets( )\after\widget\class ;+"_"+__widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   Procedure ToolBarEvents( )
      Protected *e_widget._s_WIDGET = EventWidget( )
      Protected toolbarbutton = WidgetEventItem( ) ; GetData( *e_widget ) 
      
      If *e_widget\EnteredTab( )
         Debug "click " + toolbarbutton +" "+ *e_widget\EnteredTab( )\itemindex
      EndIf
   EndProcedure
   
   
   Procedure _ToolBar( *parent._s_WIDGET, flag.i = #PB_ToolBar_Normal )
     ; ProcedureReturn *parent
      ;         If Flag & #__bar_vertical = #False
;                   *parent\fs[2] + #__panel_height
;                Else
;                   *parent\fs[1] = #__panel_width
;                EndIf
      If flag & #PB_ToolBar_Small 
         *parent\ToolBarHeight = 25
      ElseIf flag & #PB_ToolBar_Large 
         *parent\ToolBarHeight = 45
      Else;If flag & #PB_ToolBar_Normal 
         *parent\ToolBarHeight = 35
      EndIf
      Protected *this._s_WIDGET = Create( *parent, *parent\class + "_ToolBar", #__type_ToolBar, 0, 0, 900, *parent\ToolBarHeight, #Null$, Flag | #__flag_child, 0, 0, 0, 0, 0, 30 )
               *parent\TabBox( ) = *this
               
               ;ProcedureReturn ToolBar( *parent, flag )
      
             ;  Debug *this\TabAddIndex( ) ; TabState( ) ; TabIndex( )
      ;*this\type = #__type_ToolBar
      ;SetFrame(*this, 10 )
      ;SetAlignment( *this, #__align_full|#__align_top )
      
      Resize( *parent, #PB_Ignore, 30, #PB_Ignore, #PB_Ignore )
      
      widget( ) = *this ;????????????????
      ProcedureReturn *this
   EndProcedure
   
   
   Macro ToolBar( parent, flag = #PB_ToolBar_Normal )
      _ToolBar( parent, flag )
      ;    Container( 0,0,0,0 ) 
      ;    widget( )\class = "TOOLBAR"
      ;    Text( widget( )\x+widget( )\width, 5,3,30,"" )
      ;    widget( )\class = "^"
   EndMacro
   
;    Macro ToolBarButton( _button_, _image_, _mode_=0, _text_="" )
;          If _image_
;             ButtonImage(( ( widget( )\x+widget( )\width ) ), 5,30,30,_image_, _mode_ )
;          Else
;             Button(( ( widget( )\x+widget( )\width ) ), 5,50,30,_text_, _mode_ )
;          EndIf
;          
;          ;widget( )\color = widget( )\parent\color
;          widget( )\class = "TOOLBAR_BOTTON_"+MacroExpandedCount
;          widget( )\data = _button_
;          
;          Bind( widget( ), @ide_events( ) )
;    EndMacro
;    
;    Macro Separator( )
;          Text( widget( )\x+widget( )\width, 5,1,30,"" )
;          widget( )\class = "<"
;          Button( widget( )\x+widget( )\width, 5+3,1,30-6,"" )
;          widget( )\class = "|"
;          ; SetData( widget( ), - MacroExpandedCount )
;          Text( widget( )\x+widget( )\width, 5,1,30,"" )
;          widget( )\class = ">"
;    EndMacro
   
   
   If Open( 0, 30, 200, 800, 380, "ToolBar example")   
      a_init(root( ), 0)
      
      If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large)
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
      
      ;DisableToolBarButton(0, 2, 1) ; Disable the button '2'
      
      
      Define w_ide_toolbar, w_ide_toolbar_container                          ;= Window( 10, 10, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      
      w_ide_toolbar_container = Container( 10,60,700,120 )
      ;w_ide_toolbar_container = Window( 10,60,700,120, "", #PB_Window_SystemMenu )
      ;w_ide_toolbar_container = Panel( 10,60,700,120 )
      
       Button( 10,10, 50,50,"btn0" ) : SetClass(widget( ), "btn0" )
       
       w_ide_toolbar = ToolBar( w_ide_toolbar_container, #PB_ToolBar_Normal )
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
       Bind( w_ide_toolbar, @ToolBarEvents( ), #__event_LeftClick )
      ;Bind( w_ide_toolbar, @ToolBarEvents( ), #__event_Change )
      
       Button( 110,10, 50,50,"btn1" ) : SetClass(widget( ), "btn1" )
     CloseList( ) ;: Resize( w_ide_toolbar, 0, 0, 800,60)
      
      
      a_set( w_ide_toolbar_container )
      
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

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 155
; FirstLine = 126
; Folding = -v-
; EnableXP