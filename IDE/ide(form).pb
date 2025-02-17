;- 
#IDE_path = "../"
XIncludeFile #IDE_path + "/widgets.pbi"
XIncludeFile #IDE_path + "/include/newcreate/anchorbox.pbi"
XIncludeFile #IDE_path + "IDE/include/parser.pbi"
XIncludeFile #IDE_path + "IDE/ide(code).pb"
;
EnableExplicit
;
UseWidgets( )
UsePNGImageDecoder( )
; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
; test_focus_show = 1
; test_focus_set = 1
   
;
;- ENUMs
#_DD_CreateNew = 1<<1
#_DD_reParent = 1<<2
#_DD_Group = 1<<3
#_DD_CreateCopy = 1<<4
;
; properties items
Enumeration 
   #_pi_group_0 
   #_pi_id
   #_pi_class
   #_pi_text
   
   #_pi_group_1 
   #_pi_align
   #_pi_x
   #_pi_y
   #_pi_width
   #_pi_height
   
   #_pi_group_2 
   #_pi_disable
   #_pi_hide
   
   #_pi_group_3
EndEnumeration

; events items
Enumeration 
   #_ei_leftclick
   #_ei_change
   #_ei_enter
   #_ei_leave
EndEnumeration

; bar items
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
   
   #_tb_file_new
   #_tb_file_open
   #_tb_file_save
   #_tb_file_save_as
   #_tb_file_quit
   
   #_tb_menu 
EndEnumeration

;- GLOBALs
Global ide_window, 
       ide_g_code,
       ide_g_canvas

Global ide_root,
       ide_splitter,
       ide_toolbar_container, 
       ide_toolbar

Global ide_design_splitter, 
       ide_design_panel_splitter,
       ide_design_panel, 
       ide_design_panel_MDI,
       ide_design_panel_CODE, 
       ide_design_panel_HIASM, 
       ide_design_DEBUG 
Global ide_design_FORM 

Global ide_inspector_view_splitter, 
       ide_inspector_view, 
       ide_inspector_panel_splitter,
       ide_inspector_panel,
       ide_inspector_elements,
       ide_inspector_properties, 
       ide_inspector_events,
       ide_inspector_HELP

Global group_select
Global group_drag


Global img = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" ) 

;- 
Declare widget_events( )
Declare Properties_SetItemText( *splitter._s_WIDGET, item, Text.s )
Declare.s Properties_GetItemText( *splitter._s_WIDGET, item, mode = 0 )
Declare   Properties_Updates( type$ )
Declare.s CodeChange( code$, find$, replace$, type$ )

;-
;- PUBLICs
;-
;-
Procedure.s BoolToStr( val )
   If (val) > 0
      ProcedureReturn "True"
   Else ; If (val) = 0
      ProcedureReturn "False"
   EndIf
EndProcedure

Procedure StrToBool( str.s )
   If str = "True"
      ProcedureReturn 1
   ElseIf str = "False"
      ProcedureReturn 0
   EndIf
EndProcedure

;-
Procedure is_parent_item( *this._s_WIDGET, item )
   Protected result
   PushItem(*this)
   If SelectItem( *this, item)
      result = *this\__rows( )\childrens 
   EndIf
   PopItem(*this)
   ProcedureReturn result
EndProcedure

;-

  



;-
Procedure Properties_ButtonHide( *second._s_WIDGET, state )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      ;
      If *this
         Hide( *this, state )
      EndIf
   EndIf
EndProcedure

Procedure Properties_ButtonChange( *inspector._s_WIDGET )
   Protected *second._s_WIDGET = GetAttribute(*inspector, #PB_Splitter_SecondGadget)
   ;
   If *second And *second\RowFocused( )
      Protected *this._s_WIDGET = *second\RowFocused( )\data
      
      If *this
         Select Type( *this )
            Case #__type_Spin     : SetState(*this, Val(*second\RowFocused( )\text\string) )
            Case #__type_String   : SetText(*this, *second\RowFocused( )\text\string )
            Case #__type_ComboBox : SetState(*this, StrToBool(*second\RowFocused( )\text\string) )
         EndSelect
      EndIf
   EndIf
EndProcedure

Procedure Properties_ButtonResize( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      ;
      If *this
         If *row\hide
            If Not Hide( *this )
               Hide( *this, #True )
            EndIf
         Else
            If Hide( *this )
               Hide( *this, #False )
            EndIf
            ;
            ;Debug *this\WIdgetChange(  ) = 1
            Resize(*this,
                   *row\x + *second\scroll_x( ),; +30, 
                   *row\y + *second\scroll_y( ), 
                   *second\inner_width( )-dpiscaled(2),;*row\width,;; -30, 
                   *row\height, 0 )
            
;             ;*this\WIdgetChange( ) = 1
;             *this\TextChange( ) = 1
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure Properties_ButtonDisplay( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   Static *last._s_WIDGET
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      
      ;  
      If *this 
         If *row\childrens
            If Not Hide( *this )
               Hide( *this, #True )
            EndIf
         Else
            If *last = *this
               ;\\ show widget
               Hide( *this, #False )
            Else
               If *last 
                  Hide( *last, #True )
               EndIf
               
               *last = *this
               
               ;
               Select Type( *this )
                  Case #__type_String
                     If GetData( *this ) = #_pi_class
                        *this\text\upper = 1
                     Else
                        *this\text\upper = 0
                     EndIf
                     SetText( *this, *row\text\string )
                     
                  Case #__type_Spin
                     SetState( *this, Val(*row\text\string) )
                     
                  Case #__type_ComboBox
                     Select LCase(*row\text\string)
                        Case "false" : SetState( *this, 0)
                        Case "true"  : SetState( *this, 1)
                     EndSelect
                     
               EndSelect
               
               ;
               Properties_ButtonResize( *second )
               ;SetActive( *this )
            EndIf
         EndIf
      EndIf
   EndIf
   
   ProcedureReturn *last
EndProcedure

Procedure Properties_ButtonEvents( )
   ; Debug ""+widget::ClassFromEvent(WidgetEvent( )) +" "+ widget::GetClass( EventWidget( ))
   
   Select WidgetEvent( )
      Case #__event_Down
         GetActive( )\gadget = EventWidget( )
         ;
         Select Type( EventWidget( ))
            Case #__type_Spin     : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), Str(GetState(EventWidget( ))) )
            Case #__type_String   : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), GetText(EventWidget( )) )
            Case #__type_ComboBox : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), Str(GetState(EventWidget( ))) )
         EndSelect
         
      Case #__event_MouseWheel
         If WidgetEventItem( ) > 0
            SetState(EventWidget( )\scroll\v, GetState( EventWidget( )\scroll\v ) - WidgetEventData( ) )
         EndIf
         
      Case #__event_Change
         Select Type( EventWidget( ) )
            Case #__type_Button
              ; Debug 555
               
            Case #__type_String
               Select GetData( EventWidget( ) ) 
                  Case #_pi_class  
                     SetClass( a_focused( ), UCase( GetText( EventWidget( ) )))
                     Properties_Updates( "Class" ) 
                  Case #_pi_text   
                     SetText( a_focused( ), GetText( EventWidget( ) ) )  
                     Properties_Updates( "Text" ) 
               EndSelect
               
            Case #__type_Spin
                
               Select GetData( EventWidget( ) ) 
                  Case #_pi_x      : Resize( a_focused( ), GetState( EventWidget( ) ), #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
                  Case #_pi_y      : Resize( a_focused( ), #PB_Ignore, GetState( EventWidget( ) ), #PB_Ignore, #PB_Ignore )
                  Case #_pi_width  : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, GetState( EventWidget( ) ), #PB_Ignore )
                  Case #_pi_height : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState( EventWidget( ) ) )
               EndSelect
                  
                     
            Case #__type_ComboBox
               Select GetData( EventWidget( ) ) 
                  Case #_pi_id
                     If GetState( EventWidget( ) ) 
                        If SetClass( a_focused( ), "#"+Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( "ID" ) 
                           Properties_Updates( "Class" ) 
                        EndIf
                     Else
                        If SetClass( a_focused( ), Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( "ID" ) 
                           Properties_Updates( "Class" ) 
                        EndIf
                     EndIf
                    
                  Case #_pi_disable 
                     If Disable( a_focused( ), GetState( EventWidget( ) ) )
                        Properties_Updates( "Disable" ) 
                     EndIf
                     
                  Case #_pi_hide    
                     If Hide( a_focused( ), GetState( EventWidget( ) ) )
                        Properties_Updates( "Hide" ) 
                     EndIf
               EndSelect
               
         EndSelect
       
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure Properties_ButtonCreate( Type, *parent._s_WIDGET, item )
   Protected *this._s_WIDGET
   Protected flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
   
   Select Type
      Case #__type_Spin
         ;          Select item
         ;             Case #_pi_x, #_pi_width
         ;                *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, #Null$, flag|#__flag_invert|#__flag_vertical, -2147483648, 2147483647, 0, #__bar_button_size, 0, 7 )
         ;             Case #_pi_y, #_pi_height
         ;                *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, #Null$, flag|#__flag_invert, -2147483648, 2147483647, 0, #__bar_button_size, 0, 7 )
         ;          EndSelect
         
         *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, "", flag|#__spin_Plus, -2147483648, 2147483647, 0, #__bar_button_size, 0, 7 )
         
         ;SetState( *this, Val(StringField(Text.s, 2, Chr(10))))
      Case #__type_CheckBox
          *this = Create( *parent, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", flag, 0, 0, 0, 0, 0, 0 )
      Case #__type_String
         *this = Create( *parent, "String", Type, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
         ;*this = Create( *parent, "String", #__type_String, 0, 0, 0, 0, StringField(Text.s, 2, Chr(10)), flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_Button
         *this = AnchorBox::Create( *parent, 0,0,0,20 )
         
      Case #__type_ComboBox
         *this = Create( *parent, "ComboBox", Type, 0, 0, 0, 0, "", flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
         AddItem(*this, -1, "False")
         AddItem(*this, -1, "True")
         SetState(*this, 0)
   EndSelect
   
   If *this
     ; SetActive( *this )
      SetData(*this, item)
      Bind(*this, @Properties_ButtonEvents( ))
   EndIf
   
   ProcedureReturn *this
EndProcedure

;-
Procedure Properties_StatusChange( *this._s_WIDGET, item )
   If GetState( *this ) = item
      ProcedureReturn 0
   EndIf 
   
;    If GetState( EventWidget( ) ) = item
;       ProcedureReturn 0
;    EndIf 
   
   PushListPosition(EventWidget( )\__rows( ))
   SelectElement( EventWidget( )\__rows( ), item )
   ;
   If EventWidget( )\__rows( ) 
      PushListPosition( *this\__rows( ) )
      SelectElement( *this\__rows( ), EventWidget( )\__rows( )\index)
      *this\__rows( )\color = EventWidget( )\__rows( )\color
      
      If *this\__rows( )\colorState( ) = #__s_2
         If *this\RowFocused( )
            *this\RowFocused( )\focus = 0
         EndIf
         *this\RowFocused( ) = *this\__rows( )
         *this\RowFocused( )\focus = 1
      EndIf
      
      PopListPosition( *this\__rows( ) )
   EndIf
   PopListPosition(EventWidget( )\__rows( ))
   
   ;    If WidgetEventData( ) = 3
   ;       If GetActive( ) <> EventWidget( )
   ;          Debug "set active "+GetClass(EventWidget( ))
   ;          SetActive( EventWidget( ))
   ;       EndIf
   ;    EndIf
   
EndProcedure

Procedure.s Properties_GetItemText( *splitter._s_WIDGET, item, mode = 0 )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   ;
   If mode = 0
      ProcedureReturn GetItemText( *first, item )
   Else
      ProcedureReturn GetItemText( *second, item )
   EndIf
EndProcedure

Procedure Properties_SetItemText( *splitter._s_WIDGET, item, Text.s )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   ;
   SetItemText( *first, item, StringField(Text.s, 1, Chr(10)) )
   SetItemText( *second, item, StringField(Text.s, 2, Chr(10)) )
   
   ;Properties_ButtonChange( *splitter )
EndProcedure

Procedure Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
   Protected *this._s_WIDGET
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
   AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
   
   item = CountItems( *first ) - 1
   
   *this = Properties_ButtonCreate( Type, *second, item )
   
   ; SetItemData(*first, item, *this)
   SetItemData(*second, item, *this)
EndProcedure

Procedure Properties_Events( )
   Protected *first._s_WIDGET = GetAttribute( EventWidget( )\parent, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute( EventWidget( )\parent, #PB_Splitter_SecondGadget)
   ;  
   Select WidgetEvent( )
      Case #__event_Down
         If is_parent_item( EventWidget( ), WidgetEventItem( ) )
            Properties_ButtonHide( *second, #True)
         EndIf
         If Not EnteredButton( )
            SetState( EventWidget( ), WidgetEventItem( ))
         EndIf
         
      Case #__event_Change
         Select EventWidget( )
            Case *first : SetState(*second, GetState(EventWidget( )))
            Case *second : SetState(*first, GetState(EventWidget( )))
         EndSelect
         
         ; create PropertiesButton
         Properties_ButtonDisplay( *second )
         
      Case #__event_StatusChange
         If EventWidget( ) = *first
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               SetItemState( *second, WidgetEventItem( ), WidgetEventData( ))
            EndIf
         EndIf
         
         Select EventWidget( ) 
            Case *first : Properties_StatusChange( *second, WidgetEventItem( ) )
            Case *second : Properties_StatusChange( *first, WidgetEventItem( ) )
         EndSelect
         
      Case #__event_ScrollChange
         If EventWidget( ) = *first 
            If GetState( *second\scroll\v ) <> WidgetEventData( )
               SetState(*second\scroll\v, WidgetEventData( ) )
            EndIf
         EndIf   
         
         If EventWidget( ) = *second
            If GetState( *first\scroll\v ) <> WidgetEventData( )
               SetState(*first\scroll\v, WidgetEventData( ) )
            EndIf
         EndIf
         
   EndSelect
   
   ;
   Select WidgetEvent( )
      Case #__event_resize, #__event_ScrollChange
         If EventWidget( ) = *second
            Properties_ButtonResize( *second )
         EndIf
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure Properties_Create( X,Y,Width,Height, flag=0 )
   Protected position = 70
   Protected *first._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoLines)
   Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines)
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   *splitter\bar\button\size = DPIScaled(2)
   *splitter\bar\button\round = 0;  DPIScaled(1)
                                 ;SetState(*splitter, DPIScaled(position) ) ; похоже ошибка DPI
   
   ;
   SetClass(*first\scroll\v, "first_v")
   SetClass(*first\scroll\h, "first_h")
   SetClass(*second\scroll\v, "second_v")
   SetClass(*second\scroll\h, "second_h")
   
   ;
   Hide( *first\scroll\v, 1 )
   Hide( *first\scroll\h, 1 )
   Hide( *second\scroll\h, 1 )
   
   ;CloseList( )
   
   ;
   Bind(*first, @Properties_Events( ))
   Bind(*second, @Properties_Events( ))
   
   ; draw и resize отдельно надо включать пока поэтому вот так
   Bind(*second, @Properties_Events( ), #__event_resize)
   ProcedureReturn *splitter
EndProcedure

Procedure Properties_Updates( type$ )
   Protected find$, replace$, name$, class$
   ; class$ = Properties_GetItemText( ide_inspector_properties, #_pi_class, 1 )
   
   If type$ = "Focus" Or type$ = "ID"
      Properties_SetItemText( ide_inspector_properties, #_pi_id,     
                              Properties_GetItemText( ide_inspector_properties, #_pi_id ) +
                              Chr( 10 ) + BoolToStr( Bool( GetClass( a_focused( ) ) <> Trim( GetClass( a_focused( ) ), "#" ) )))
   EndIf
   If type$ = "Focus" Or type$ = "Hide"
      Properties_SetItemText( ide_inspector_properties, #_pi_hide,    
                              Properties_GetItemText( ide_inspector_properties, #_pi_hide ) + 
                              Chr( 10 ) + BoolToStr( Hide( a_focused( ) )))
   EndIf
   If type$ = "Focus" Or type$ = "Disable"
      Properties_SetItemText( ide_inspector_properties, #_pi_disable, 
                              Properties_GetItemText( ide_inspector_properties, #_pi_disable ) +
                              Chr( 10 ) + BoolToStr( Disable( a_focused( ) )))
   EndIf
   
   If type$ = "Focus" Or type$ = "Class"
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_class, 1 )
      replace$ = GetClass( a_focused( ) )
      Properties_SetItemText( ide_inspector_properties, #_pi_class,  Properties_GetItemText( ide_inspector_properties, #_pi_class ) + Chr( 10 ) + replace$ )
   EndIf
   If type$ = "Focus" Or type$ = "Text"
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_text, 1 )
      replace$ = GetText( a_focused( ) )
      Properties_SetItemText( ide_inspector_properties, #_pi_text,   Properties_GetItemText( ide_inspector_properties, #_pi_text ) + Chr( 10 ) + replace$ )
   EndIf
   If type$ = "Focus" Or type$ = "Resize"
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_x, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_y, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_width, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_height, 1 )
      
      Protected x$ = Str( X( a_focused( ) ))
      Protected y$ = Str( Y( a_focused( ) ))
      Protected width$ = Str( Width( a_focused( ) ))
      Protected height$ = Str( Height( a_focused( ) ))
      
      replace$ = x$ +", "+ y$ +", "+ width$ +", "+ height$
      
      Properties_SetItemText( ide_inspector_properties, #_pi_x,      Properties_GetItemText( ide_inspector_properties, #_pi_x )      + Chr( 10 ) + x$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_y,      Properties_GetItemText( ide_inspector_properties, #_pi_y )      + Chr( 10 ) + y$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_width,  Properties_GetItemText( ide_inspector_properties, #_pi_width )  + Chr( 10 ) + width$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_height, Properties_GetItemText( ide_inspector_properties, #_pi_height ) + Chr( 10 ) + height$ )
      
      ;
      Properties_ButtonChange( ide_inspector_properties )
   EndIf
   
;    Define find = FindString( code$,  GetClass( a_focused( ) ) + " =" )
;    
;    Debug find
   
 ;  ClearDebugOutput()
;    Protected *this._s_WIDGET = ide_design_panel_CODE
;    ForEach *this\__lines( )
;       If FindString( *this\__lines( )\text\string,  GetClass( a_focused( ) ) + " = " + ClassFromType( Type( a_focused( )) ) )
;          *this\RowFocused( ) = *this\__lines( )
;          Break
;       EndIf
;    Next
;    
;    If *this\RowFocused( ) 
;       Debug "["+*this\RowFocused( )\text\pos +" - "+ *this\RowFocused( )\text\len +"] "+ *this\RowFocused( )\text\string
;       ; SetCaret( *this)
;    EndIf
   
   If type$ <> "Focus"
      Define code$ = CodeChange( GetText( ide_design_DEBUG ), find$, replace$, type$ )
      If code$
         SetText( ide_design_DEBUG, code$ )
      EndIf
   EndIf 
   
 EndProcedure


;-
Declare  widget_add( *parent._s_widget, Class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, Flag$="" )

;-
Procedure.s CodeChange( code$, find$, replace$, type$ )
   Protected name$
   If code$
      If type$ = "Class"
         code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive )
      Else
         name$ = GetClass( a_focused( ) ) + " = " + ClassFromType( Type( a_focused( )) )
         Define pos = FindString( code$, name$ )
         ; Define len = (FindString( code$, #CRLF$, pos ) - pos)
         code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive, pos, 1 )
         ;Debug "["+pos +" "+ len +"] "+ find$ +" "+ replace$
      EndIf
   EndIf
   ProcedureReturn code$
EndProcedure

Procedure.S IsFunctions( ReadString$ ) ; Ok
  Protected Finds.S, Type.S
  Restore Types
  Read$ Type.S
  
  While Type.S 
    If FindString(ReadString$, Type.S+"(") 
      Finds.S = "Find >> "+ReadString$
    EndIf
    
    If Finds.S
      Break
    EndIf
    Read$ Type.S
  Wend
  
  ProcedureReturn Finds.S
  
  DataSection
    Types: 
    Data$ "OpenWindow"
    Data$ "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
          "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
          "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
          "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
          "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
          "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
          "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
          "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
    Data$ ""
  EndDataSection
EndProcedure

Procedure.S ParseFunctions( ReadString$ ) ;Ok
   Protected I
   Protected Count.I
   Protected Arguments$
   
   Protected Name$
   Protected Class$
   Protected x$
   Protected y$
   Protected width$
   Protected height$
   Protected Text$
   Protected Image$
   Protected Param1$
   Protected Param2$
   Protected Param3$
   Protected Flag$
   Protected CountString.I
   
   Static Parent =- 1
   Protected Element
   
   
   ReadString$ = Trim( ReadString$ )
   ReadString$ = ReplaceString( ReadString$, "Open", "")
   ReadString$ = ReplaceString( ReadString$, "Gadget", "")
   ReadString$ = ReplaceString( ReadString$, "Find >>", "")
   
   ;
   Arguments$ = Trim( StringField( ReadString$, (2), Chr('(')), Chr(')'))
   
   If Arguments$
      Name$ = Trim( StringField(ReadString$, 1, Chr('=') ))  
      
      Class$ = Trim( StringField( ReadString$, (1), Chr('(') ))
      Class$ = Trim( StringField( Class$, (2), Chr('=') ))
      
      If Parent =- 1 
         Parent = ide_design_panel_MDI 
         x$ = "10"
         y$ = "10"
      Else
         x$ = Trim( StringField( Arguments$, 2, "," ))
         y$ = Trim( StringField( Arguments$, 3, "," ))
      EndIf
      
      width$ = Trim( StringField( Arguments$, 4, "," ))
      ;   If width$ = StringField( width$, 1, "(")
      ;   Else
      ;     width$ + ")"
      ;   EndIf
      
      height$ = Trim( StringField( Arguments$, 5, "," ))
      ;   If height$ = StringField( height$, 1, "(")
      ;   Else
      ;     height$ + ")"
      ;   EndIf
      
      
      Select Class$
         Case "Spin", "Track", "Progress", "Splitter", "MDI", "ListIcon", "Date", "HyperLink", "Scroll", "ScrollArea"
            Param1$ = Trim( StringField( Arguments$, 6, "," ))
            Param2$ = Trim( StringField( Arguments$, 7, "," ))
            
            Select Class$
               Case "Scroll", "ScrollArea"
                  Param3$ = Trim( StringField( Arguments$, 8, "," ))
                  Flag$ = Trim( StringField( Arguments$, 9, "," ))
               Default
                  Flag$ = Trim( StringField( Arguments$, 8, "," ))
            EndSelect  
            
         Default
            Select Class$
               Case "Image", "ButtonImage"
                  Image$ = Trim( StringField( Arguments$, 6, "," ))
               Default
                  Text$ = Trim( StringField( Arguments$, 6, "," ))
            EndSelect
            
            Flag$ = Trim( StringField( Arguments$, 7, "," ))
            
      EndSelect
      
      If CountString(Text$, Chr('"')) = 0
         Flag$ = Text$
         Text$ = ""
      EndIf
      
      Element = widget_add( Parent, Class$, Val(x$), Val(y$), Val(width$), Val(height$), Flag$ )
      ;Debug ""+Name$+" = "+Class$+"( "+ x$+" "+y$+" "+width$+" "+height$ +" "+ Text$+" )"
      
      If Element
         If Name$
            SetClass( Element, Name$ )
         EndIf
         
         If Text$
            If FindString( Text$, Chr('"'))
               Text$ = Trim( Text$, Chr('"'))
            EndIf
            
            SetText( Element, Text$ )
         EndIf
         
         If Image$
            SetImage( Element, Val(Image$) )
         EndIf
         
         Select Class$
            Case "Spin", "Track", "Progress", "Scroll"
               If Param1$
                  SetAttribute(Element, #__bar_Minimum, Val(Param1$) )
               EndIf
               If Param2$
                  SetAttribute(Element, #__bar_Maximum, Val(Param2$) )
               EndIf
         EndSelect
         
         If Param3$
            Select Class$
               Case "Scroll"
                  
               Case "ScrollArea"
                  
            EndSelect  
         EndIf
         
         If Param1$ And Param2$
            Select Class$
               Case "Splitter"
                  Debug ""+ Param1$ +" "+ Param2$
;                   SetAttribute(Element, #PB_Splitter_FirstGadget, Val(Param1$) )
;                   SetAttribute(Element, #PB_Splitter_SecondGadget, Val(Param2$) )
                  
            EndSelect  
         EndIf
         
         If IsContainer(Element)
            Parent = Element
         EndIf
      EndIf
   EndIf
EndProcedure

;-
#File = 0
Procedure IDE_OpenFile(Path$) ; Открытие файла
   Protected Text$, String$
   
   If Path$
      ClearDebugOutput( )
      Debug "Открываю файл '"+Path$+"'"
      
      Delete( ide_design_panel_MDI )
      ReDraw( GetRoot( ide_design_panel_MDI ))   
      
      If ReadFile( #File, Path$ ) ; Если файл можно прочитать, продолжаем...
         
         While Eof( #File ) = 0 ; Цикл, пока не будет достигнут конец файла. (Eof = 'Конец файла')
            String$ = ReadString( #File ) ; Построчный просмотр содержимого файла
            
            String$ = IsFunctions(String$)
;             
            If String$
               ParseFunctions(String$)
            EndIf
         Wend
         
;          ;
;          Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         
         
         ;
         CloseFile(#File) ; Закрывает ранее открытый файл
         Debug "..успешно"
         ProcedureReturn 1
      Else
         ProcedureReturn 0
      EndIf
   Else
      ProcedureReturn 1
   EndIf 
EndProcedure

Procedure IDE_SaveFile(Path$) ; Процедура сохранения файла
   Protected Space$, Text$
   Protected len, Length, Position, Object
   
   If Path$
      ClearDebugOutput()
    Debug "Сохраняю файл '"+Path$+"'"
    
    Text$ = GeneratePBCode( ide_design_panel_MDI )
    
;     SetText( ide_design_panel_CODE, Text$ )
;     Text$ = GetText( ide_design_panel_CODE )

    If CreateFile( #File, Path$, #PB_UTF8 )
      ; TruncateFile( #File )

       WriteStringFormat( #File, #PB_UTF8 )
       WriteString( #File, Text$, #PB_UTF8 )
       CloseFile( #File )
       
       Debug "..успешно"
       ProcedureReturn 1
    Else
       ProcedureReturn 0
    EndIf
 Else
    ProcedureReturn 1
 EndIf
EndProcedure


;-
Procedure.S Help_elements(Class.s)
  Protected Result.S
  
  Class = UCase(Class)
  
  Select TypeFromClass(Class)
    Case 0
      Result.S = "[" +Class+ "] - Элемент не выбран"
      
    Case #__type_Date
      Result.S = "Первая строка"+#CRLF$+
                 "Вторая строка"
      
    Case #__type_Window
      Result.S = "[" +Class+ "] - Это окно"
      
    Case #__type_Button
      Result.S = "[" +Class+ "] - Это кнопка"
      
    Case #__type_ButtonImage
      Result.S = "[" +Class+ "] - Это кнопка картинка"
      
    Case #__type_CheckBox
      Result.S = "[" +Class+ "] - Это переключатель"
      
    Case #__type_ComboBox
      Result.S = "[" +Class+ "] - Это выподающий список"
      
    Case #__type_Image
      Result.S = "[" +Class+ "] - Это картинка"
      
   Case #__type_Calendar
      Result.S = "[" +Class+ "] - Это календарь"
      
   Case #__type_Canvas
      Result.S = "[" +Class+ "] - Это холст для рисования"
      
    Case #__type_Container
      Result.S = "[" +Class+ "] - Это контейнер для других элементов"
      
    Case #__type_Editor
      Result.S ="[" +Class+ "] - Это многострочное поле ввода"
      
    Default
      Result.S = "[" +Class+ "] - не реализованно"
      
  EndSelect
  
  ProcedureReturn Result.S
EndProcedure

Procedure.s FlagFromFlag( Type, flag.i ) ; 
   Protected flags.S
   
   Select Type
      Case #__Type_Text
         If flag & #__text_Center
            flags + "#PB_Text_Center | "
         EndIf
         If flag & #__text_Right
            flags + "#PB_Button_Right | "
         EndIf
         ;         If flag & #__flag_Textborder
         ;           flags + "#PB_Text_Border | "
         ;         EndIf
         
      Case #__Type_Button
         If flag & #PB_Button_Left
            flags + "#PB_Button_Left | "
         EndIf
         If flag & #PB_Button_Right
            flags + "#PB_Button_Right | "
         EndIf
         If flag & #PB_Button_MultiLine
            flags + "#PB_Button_MultiLine | "
         EndIf
         If flag & #PB_Button_Toggle
            flags + "#PB_Button_Toggle | "
         EndIf
         If flag & #PB_Button_Default
            flags + "#PB_Button_Default | "
         EndIf
         
      Case #__Type_Container
         If flag & #__flag_borderless
            flags + "#PB_Container_BorderLess | "
         EndIf
         ;         If flag & #__flag_flat
         ;           flags + "#PB_Container_Border | "
         ;         EndIf
         
   EndSelect
   
   ProcedureReturn Trim( flags, "|" )
EndProcedure

;-
Procedure add_code( *new._s_widget, Name$, item.i, SubLevel.i )
   Protected Result$ 
   Protected Space$ = Space( ( Level(*new) - Level(ide_design_panel_MDI) ) * 3 )
   
   Result$ = GenerateCODE( *new, "FUNCTION", space$ )
   
   Result$ = ReplaceString( Result$, "OpenWindow( #PB_Any, ", "Window( ")
   Result$ = ReplaceString( Result$, "OpenWindow( " + Name$, "Window( ")
   Result$ = ReplaceString( Result$, "Gadget( #PB_Any, ", "( ")
   Result$ = ReplaceString( Result$, "Gadget( " + Name$, "( ")
   Result$ = ReplaceString( Result$, "Gadget", "")
   
   If IsGadget( ide_g_code )
      AddGadgetItem( ide_g_code, item, Result$ )
   Else
      AddItem( ide_design_panel_CODE, item, Result$ )
      AddItem( ide_design_DEBUG, item, Result$ )
      SetItemData( ide_design_DEBUG, item, *new)
   EndIf
EndProcedure

Procedure code_edit_events( *this._s_WIDGET, event.i, item.i, *line._s_ROWS )
   ;Debug ""+GetState(*this)+" change-["+GetClass(*this)+"]"
   Protected q, startpos, stoppos
   Protected X = #PB_Ignore, Y = #PB_Ignore
   Protected Width = #PB_Ignore, Height = #PB_Ignore
   
   If event = #__event_Up
     
   EndIf
   
   If event = #__event_StatusChange
     ; Debug 6543456789
   EndIf
   
   If event = #__event_Change
      Protected object
      object = GetItemData( ide_inspector_view, item )
     ; Debug object
      
      ;Debug item ;
      ; Debug  Left( *this\text\string, *this\text\caret\pos[1] )
      Protected findstring.s = GetItemText( *this, item ) ; Left( *this\text\string, *this\text\caret\pos )
      findstring.s = Left( findstring.s, *this\text\caret\pos )
      Protected countstring = CountString( findstring, "," )
      ; Debug ""+countstring +" ? "+ findstring
      
      Select countstring
         Case 0, 1, 2, 3, 4, 5
            For q = *this\text\edit[1]\len To *this\text\edit[1]\pos Step - 1
               If Mid( *this\text\string, q, 1 ) = "(" Or 
                  Mid( *this\text\string, q, 1 ) = ~"\"" Or
                  Mid( *this\text\string, q, 1 ) = ","
                  startpos = q + 1
                  Break
               EndIf
            Next q
            
            For q = *this\text\edit[3]\pos To ( *this\text\edit[3]\pos + *this\text\edit[3]\len )
               If Mid( *this\text\string, q, 1 ) = "," Or
                  Mid( *this\text\string, q, 1 ) = ~"\"" Or
                  Mid( *this\text\string, q, 1 ) = ")"
                  stoppos = q
                  Break
               EndIf
            Next q
            
            
            If stoppos And stoppos - startpos
               findstring = Mid( *this\text\string, startpos, stoppos - startpos )
               ; countstring = CountString( findstring, "," )
               ; Debug ""+startpos +" "+ stoppos +" ? "+ countstring ; findstring
               
               If countstring
                  If object
                     If countstring = 5
                        SetText( object, findstring )
                     Else
                        If countstring = 1
                           X = Val( findstring )
                        ElseIf countstring = 2
                           Y = Val( findstring )
                        ElseIf countstring = 3
                           Width = Val( findstring )
                        ElseIf countstring = 4
                           Height = Val( findstring )
                        EndIf
                        
                        Resize( object, X, Y, Width, Height)
                     EndIf
                  EndIf
               EndIf
               
            EndIf
      EndSelect
      
      ; Debug Left( *this\text\string, *this\text\caret\pos ); GetState( ide_design_panel_CODE )
   EndIf
EndProcedure

;-
Macro widget_copy( )
   ClearList( *copy( ) )
   
   If a_focused( )\anchors
      AddElement( *copy( ) ) 
      *copy.allocate( A_GROUP, ( ) )
      *copy( )\widget = a_focused( )
   Else
      ;       ForEach a_group( )
      ;         AddElement( *copy( ) ) 
      ;         *copy.allocate( GROUP, ( ) )
      ;         *copy( )\widget = a_group( )\widget
      ;       Next
      
      CopyList( a_group( ), *copy( ) )
      
   EndIf
   
   mouse( )\selector\x = mouse( )\steps
   mouse( )\selector\y = mouse( )\steps
EndMacro

Macro widget_paste( )
   If ListSize( *copy( ) )
      ForEach *copy( )
         widget_add( *copy( )\widget\parent, 
                     *copy( )\widget\class, 
                     *copy( )\widget\x[#__c_container] + ( mouse( )\selector\x ),; -*copy( )\widget\parent\x[#__c_inner] ),
                     *copy( )\widget\y[#__c_container] + ( mouse( )\selector\y ),; -*copy( )\widget\parent\y[#__c_inner] ), 
                     *copy( )\widget\width[#__c_frame],
                     *copy( )\widget\height[#__c_frame] )
      Next
      
      mouse( )\selector\x + mouse( )\steps
      mouse( )\selector\y + mouse( )\steps
      
      ClearList( a_group( ) )
      CopyList( *copy( ), a_group( ) )
   EndIf
   
   ;
   ForEach a_group( )
      Debug " group "+a_group( )\widget
   Next
   
   ;
   ;a_update( a_focused( ) )
EndMacro

Procedure widget_delete( *this._s_WIDGET  )
   Protected item
   Protected i 
   Protected CountItems
   
   ;    If ListSize( a_group( ))
   ;       ForEach a_group( )
   ;          RemoveItem( ide_inspector_view, GetData( a_group( )\widget ) )
   ;          Free( a_group( )\widget )
   ;          DeleteElement( a_group( ) )
   ;       Next
   ;       
   ;       ClearList( a_group( ) )
   ;    Else
   
   If *this <> ide_design_panel_MDI
      item = GetData( *this )
      
      If item 
         Free( *this )
         
         RemoveItem( ide_inspector_view, item )
         ;
         ; after remove item 
         CountItems = CountItems( ide_inspector_view ) 
         If CountItems 
            ; update widget data item
            For i = 0 To CountItems - 1
               SetData( GetItemData( ide_inspector_view, i ), i )
            Next 
            ;
            ; set anchor focus
            If a_set( GetItemData( ide_inspector_view, GetState( ide_inspector_view ) ) )
              ; Это не нужен так как a_set( ) мы получаем фокус выджета 
              ; Properties_Updates( "Delete" )
            EndIf
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure widget_add( *parent._s_widget, Class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag$="" )
   Protected *new._s_widget, *param1, *param2, *param3
   Protected flag.i ;= #__flag_NoFocus
   Protected newClass.s
   
   If *parent 
      OpenList( *parent, CountItems( *parent ) - 1 )
      Class.s = LCase( Trim( Class ) )
      
      ; defaul width&height
      If Class = "scrollarea" Or
         Class = "container" Or
         Class = "panel"
         
         If Width = #PB_Ignore
            Width = 200
         EndIf
         If Height = #PB_Ignore
            Height = 150
         EndIf
         
         If Class = "scrollarea"
            *param1 = Width
            *param2 = Height
            *param3 = 5
         EndIf
         
      Else
         If Class = "spin"
            *param1 = 0
            *param2 = 100
         EndIf
         
         If Class = "progress"
            *param1 = 0
            *param2 = 100
         EndIf
         
         If Width = #PB_Ignore
            Width = 100
         EndIf
         If Height = #PB_Ignore
            Height = 30
         EndIf
      EndIf
      
      ; create elements
      Select Class
         Case "window"    
            If Type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, "", - 1, flag | #__window_NoActivate )
               Resize( *new, X, Y, Width,Height )
            Else
               flag | #__window_systemmenu | #__window_maximizegadget | #__window_minimizegadget | #__window_NoActivate
               *new = Window( X,Y,Width,Height, "", flag, *parent )
            EndIf
            
         Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, *param1, *param2, *param3, flag ) : CloseList( )
         Case "container"   : *new = Container( X,Y,Width,Height, flag ) : CloseList( )
         Case "panel"       : *new = Panel( X,Y,Width,Height, flag ) : CloseList( )
            AddItem( *new, -1, Class+"_item_0" )
            
         Case "splitter"    : *new = Splitter( X,Y,Width,Height, *param1, *param2, flag )
         Case "spin"        : *new = Spin( X,Y,Width,Height, *param1, *param2, flag )
         Case "progress"    : *new = Progress( X,Y,Width,Height, *param1, *param2, flag ) 
            
         Case "image"       : *new = Image( X,Y,Width,Height, img, flag )
         Case "buttonimage" : *new = ButtonImage( X,Y,Width,Height, img, flag )
            
         Case "text"        : *new = Text( X,Y,Width,Height, "", flag )
         Case "string"      : *new = String( X,Y,Width,Height, "", flag )
         Case "button"      : *new = Button( X,Y,Width,Height, "", flag ) 
         Case "option"      : *new = Option( X,Y,Width,Height, "", flag ) 
         Case "checkbox"    : *new = CheckBox( X,Y,Width,Height, "", flag ) 
            
         Case "combobox"    : *new = ComboBox( X,Y,Width,Height, flag ) 
      EndSelect
      
      If *new
         ;\\ первый метод формирования названия переменной
         newClass.s = Class+"_"+CountType( *new )
         
         ;\\ второй метод формирования названия переменной
         ;          If *parent = ide_design_panel_MDI
         ;             newClass.s = Class( *new )+"_"+CountType( *new , 2 )
         ;          Else
         ;             newClass.s = Class( *parent )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
         ;          EndIf
         ;\\
         SetClass( *new, UCase(newClass) )
         SetText( *new, newClass )
         
         ;
         If IsContainer( *new )
            EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
            If is_window_( *new )
               Protected *imagelogo = CatchImage( #PB_Any,?group_bottom )
               CompilerIf #PB_Compiler_DPIAware
                  ResizeImage(*imagelogo, DPIScaled(ImageWidth(*imagelogo)), DPIScaled(ImageHeight(*imagelogo)), #PB_Image_Raw)
               CompilerEndIf
               SetImage( *new, *imagelogo )
               
               a_set(*new, #__a_full, (14))
               SetBackgroundColor( *new, $FFECECEC )
               ;
               Bind( *new, @widget_events( ) )
            Else
               a_set(*new, #__a_full, (10))
               SetBackgroundColor( *new, $FFF1F1F1 )
            EndIf  
         Else
            a_set(*new, #__a_full)
         EndIf
         ;
         ; get new add position & sublevel
         Protected i, CountItems, sublevel, position = GetData( *parent ) 
         CountItems = CountItems( ide_inspector_view )
         For i = 0 To CountItems - 1
            Position = ( i+1 )
            
            If *parent = GetItemData( ide_inspector_view, i ) 
               SubLevel = GetItemAttribute( ide_inspector_view, i, #PB_Tree_SubLevel ) + 1
               Continue
            EndIf
            
            If SubLevel > GetItemAttribute( ide_inspector_view, i, #PB_Tree_SubLevel )
               Position = i
               Break
            EndIf
         Next 
         
         ; set new widget data
         SetData( *new, position )
         
         ; update new widget data item ;????
         If CountItems > position
            For i = position To CountItems - 1
               SetData( GetItemData( ide_inspector_view, i ), i + 1 )
            Next 
         EndIf
         
         
         ; get image associated with class
         Protected img =- 1
         CountItems = CountItems( ide_inspector_elements )
         For i = 0 To CountItems - 1
            If LCase(StringField( Class.s, 1, "_" )) = LCase(GetItemText( ide_inspector_elements, i ))
               img = GetItemData( ide_inspector_elements, i )
               Break
            EndIf
         Next  
         
         ; add to inspector
         AddItem( ide_inspector_view, position, newClass.s, img, sublevel )
         SetItemData( ide_inspector_view, position, *new )
         ; SetItemState( ide_inspector_view, position, #PB_tree_selected )
         
         ; Debug " "+position
         SetState( ide_inspector_view, position )
         
         If IsGadget( ide_g_code )
            AddGadgetItem( ide_g_code, position, newClass.s, ImageID(img), SubLevel )
            SetGadgetItemData( ide_g_code, position, *new )
            ; SetGadgetItemState( ide_g_code, position, #PB_tree_selected )
            SetGadgetState( ide_g_code, position ) ; Bug
         EndIf
         
         ; Debug  " pos "+position + "   ( debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
         add_code( *new, newClass.s, position, sublevel )
         
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure widget_events( )
   Protected eventtype = WidgetEvent( ) 
   Protected *new, *e_widget._s_widget = EventWidget( )
   
   Select eventtype 
      Case #__event_Free
         Protected item = GetData( *e_widget ) 
         RemoveItem( ide_inspector_view, item ) 
         ; Debug "free "+item
         ; ProcedureReturn 0
         
      Case #__event_RightDown
         Debug "right"
         
      Case #__event_Down
         If a_focused( ) = *e_widget
            If GetActive( ) <> ide_inspector_view 
               SetActive( ide_inspector_view )
               Debug "------------- active "+GetClass(GetActive( ))
            EndIf
         EndIf
         
      Case #__event_LostFocus
         If a_focused( ) = *e_widget
            ; Debug "LOSTFOCUS "+GetClass(*e_widget)
            SetState( ide_inspector_view, - 1 )
         EndIf
         
      Case #__event_Focus
         If a_focused( ) = *e_widget
            ; Debug "FOCUS "+GetClass(*e_widget)
         
            If GetData( *e_widget ) >= 0
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, GetData( *e_widget ) )
               EndIf
               SetState( ide_inspector_view, GetData( *e_widget ) )
            EndIf
            
            Properties_Updates( "Focus" )
         EndIf
         
      Case #__event_Resize
         If a_focused( ) = *e_widget
            Properties_Updates( "Resize" )
            ;
            ; SetWindowTitle( GetCanvasWindow(*e_widget\root), Str(Width(*e_widget))+"x"+Str(Height(*e_widget) ) )
         EndIf
         
      Case #__event_DragStart
         If is_drag_move( )
            If DragDropPrivate( #_DD_reParent )
               ChangeCurrentCursor( *e_widget, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer( *e_widget ) 
               If MouseEnter( *e_widget )
                  If Not a_index( )
                     If GetState( ide_inspector_elements) > 0 
                        If DragDropPrivate( #_DD_CreateNew )
                           ChangeCurrentCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     Else
                        If DragDropPrivate( #_DD_Group )
                           ChangeCurrentCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_Drop
         Select DropPrivate( )
            Case #_DD_Group
               Debug " ----- DD_group ----- " + GetClass(*e_widget)
               
;             Case #_DD_reParent
;                Debug " ----- DD_move ----- " +GetClass(Pressed( )) +" "+ Entered(  )\class
;                If SetParent( Pressed( ), Entered(  ) )
;                   Protected i = 3 : Debug "re-parent "+ GetClass(Pressed( )\parent) +" "+ Pressed( )\x[i] +" "+ Pressed( )\y[i] +" "+ Pressed( )\width[i] +" "+ Pressed( )\height[i]
;                EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( ide_inspector_elements ) +" "+ DropX( ) +" "+ DropY( ) +" "+ DropWidth( ) +" "+ DropHeight( )
               widget_add( *e_widget, GetText( ide_inspector_elements ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( Pressed( ) )
               
               ;            *new = widget_add( *e_widget, GetClass( Pressed( ) ), 
               ;                         X( Pressed( ) ), Y( Pressed( ) ), Width( Pressed( ) ), Height( Pressed( ) ) )
               
               *new = widget_add( *e_widget, DropText( ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               SetText( *new, "Copy_"+ DropText( ) )
               
         EndSelect
         
      Case #__event_LeftDown
         If IsContainer( *e_widget )
            If mouse( )\selector
               If GetState( ide_inspector_elements) > 0 
                  mouse( )\selector\dotted = 0
               EndIf
            EndIf
         EndIf
         
      Case #__event_LeftUp
         ; then group select
         If IsContainer( *e_widget )
            
            If GetState( ide_inspector_view) >= 0
               Debug " ----- new ----- "+ GetText( ide_inspector_elements ) 
               widget_add( *e_widget, GetText( ide_inspector_elements ), GetMouseDeltaX( ), GetMouseDeltaY( ), 100,100 );   )mouse( )\x, mouse( )\y, 
            EndIf
            
            If mouse( )\selector And ListSize( a_group( ) )
               SetState( ide_inspector_view, - 1 )
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, - 1 )
               EndIf
               
               ForEach a_group( )
                  SetItemState( ide_inspector_view, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  If IsGadget( ide_g_code )
                     SetGadgetItemState( ide_g_code, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
         ;
         If Not MouseButtonPress( )
             If IsContainer( *e_widget ) 
               If GetState( ide_inspector_elements ) > 0 
                  If eventtype = #__event_MouseLeave
                     ResetCursor( *e_widget ) 
                  EndIf
                  If eventtype = #__event_MouseEnter
                     ; SetCursor( *e_widget, #__Cursor_Cross, 1 )
                     SetCursor( *e_widget, Cursor::Create( ImageID( GetItemData( ide_inspector_elements, GetState( ide_inspector_elements ) ) ) ), 1 )
            
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
   EndSelect
   
   ;\\
   If eventtype = #__event_Drop Or 
      eventtype = #__event_LeftUp Or 
      eventtype = #__event_RightUp 
      
      ; end new create
      If GetState( ide_inspector_elements ) > 0 
         SetState( ide_inspector_elements, 0 )
         
         ; ChangeCursor( *e_widget, GetCursor( *e_widget ))
         If ResetCursor( *e_widget ) 
         EndIf
      EndIf
   EndIf
   
   ; отключаем дальнейшую обработку всех событий
   ; а также события кнопок окна (Close, Maximize, Minimize)
   ProcedureReturn #PB_Ignore
EndProcedure


Declare ide_events( )


;-
Procedure.i ide_add_image_list( *id, Directory$ )
   Protected ZipFile$ = Directory$ + "SilkTheme.zip"
   
   If FileSize( ZipFile$ ) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
         ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize( ZipFile$ ) < 1
         MessageRequester( "Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error | #PB_MessageRequester_Ok )
         End
      EndIf
   EndIf
   ;   Directory$ = GetCurrentDirectory( )+"images/" ; "";
   ;   Protected ZipFile$ = Directory$ + "images.zip"
   
   
   If FileSize( ZipFile$ ) > 0
      ; UsePNGImageDecoder( )
      
      CompilerIf #PB_Compiler_Version > 522
         UseZipPacker( )
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *memory, Image, ZipFile
      ZipFile = OpenPack( #PB_Any, ZipFile$, #PB_PackerPlugin_Zip )
      
      If ZipFile  
         If ExaminePack( ZipFile )
            While NextPackEntry( ZipFile )
               
               PackEntryName.S = PackEntryName( ZipFile )
               ImageSize = PackEntrySize( ZipFile )
               If ImageSize
                  *memory = AllocateMemory( ImageSize )
                  UncompressPackMemory( ZipFile, *memory, ImageSize )
                  PackEntryName.S = ReplaceString( PackEntryName.S,".png","" )
                  
                  If PackEntryName.S="application_form" 
                     PackEntryName.S="vd_windowgadget"
                  EndIf
                  
                  If PackEntryName.S="page_white_edit" 
                     PackEntryName.S="vd_scintillagadget"
                  EndIf
                  
                  Select PackEntryType( ZipFile )
                     Case #PB_Packer_File
                        If FindString( Left( PackEntryName.S, 3 ), "vd_" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"vd_","" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"gadget","" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"bar","" )
                           PackEntryName = LCase( PackEntryName.S )
                           
                           If FindString( PackEntryName, "cursor" )
                              PackEntryName.S = UCase( Left( PackEntryName.S, 1 ) ) + 
                                                Right( PackEntryName.S, Len( PackEntryName.S )-1 )
                              
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, 0, PackEntryName.S, Image )
                              SetItemData( *id, 0, Image )
                              Image = #Null
                              
                           ElseIf FindString( PackEntryName, "window" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "image" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "button" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "option" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "checkbox" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "string" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "text" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "progress" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "combobox" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "panel" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "container" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "scrollarea" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "splitter" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "spin" )
                              Image = #PB_Any
                           Else
                              ; Image = #PB_Any
                           EndIf
                           
                           If Image
                              PackEntryName.S = UCase( Left( PackEntryName.S, 1 ) ) + 
                                                Right( PackEntryName.S, Len( PackEntryName.S )-1 )
                              
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, PackEntryName.S, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              Image = #Null
                           EndIf
                        EndIf    
                  EndSelect
                  
                  FreeMemory( *memory )
               EndIf
            Wend  
         EndIf
         
         ; select cursor
         SetState( *id, 0 )
         ClosePack( ZipFile )
      EndIf
   EndIf
EndProcedure

Procedure ide_menu_events( *e_widget._s_WIDGET, BarButton )
   Protected transform, move_x, move_y
   Static NewList *copy._s_a_group( )
   
   ; Debug "ide_menu_events "+BarButton
   
   Select BarButton
      Case #_tb_group_select
         If Type( *e_widget ) = #__type_ToolBar
            If GetItemState( *e_widget, BarButton )  
               ; group
               group_select = *e_widget
               ; SetAtributte( *e_widget, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         Else
            If GetState( *e_widget )  
               ; group
               group_select = *e_widget
               ; SetAtributte( *e_widget, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         EndIf
         
         ForEach a_group( )
            Debug a_group( )\widget\x
            
         Next
         
         
      Case #_tb_file_new
         ClearItems( ide_design_DEBUG ) ; TEMP
         ; сначала удаляем всех детей 
         Delete( ide_design_panel_MDI )
         ; затем создаем новое окно
         ide_design_form = widget_add( ide_design_panel_MDI, "window", 10, 10, 500, 250 )
         ; и показываем гаджеты для добавления
         SetState( ide_inspector_panel, 0 )
   
      Case #_tb_file_open
         Protected StandardFile$, Pattern$, File$
         StandardFile$ = "open_example.pb" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = OpenFileRequester("Пожалуйста выберите файл для загрузки", StandardFile$, Pattern$, 0)
         
         SetWindowTitle( EventWindow(), File$ )
         
         If Not IDE_OpenFile( File$ )
            Message("Информация", "Не удалось открыть файл.")
         EndIf
         
      Case #_tb_file_save
         StandardFile$ = "save_example.pbf" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = SaveFileRequester("Пожалуйста выберите файл для сохранения", StandardFile$, Pattern$, 0)
         
         If Not IDE_SaveFile( File$ )
            Message("Информация","Не удалось сохранить файл.", #PB_MessageRequester_Error)
         EndIf
          
      Case #_tb_widget_copy
         widget_copy( )
         
      Case #_tb_widget_cut
         widget_copy( )
         widget_delete( a_focused( ) )
         
      Case #_tb_widget_paste
         widget_paste( )
         
      Case #_tb_widget_delete
         widget_delete( a_focused( ) )
         
         
      Case #_tb_group_left,
           #_tb_group_right, 
           #_tb_group_top, 
           #_tb_group_bottom, 
           #_tb_group_width, 
           #_tb_group_height
         
         ;\\ toolbar buttons events
         If mouse( )\selector
            move_x = mouse( )\selector\x - a_focused( )\x[#__c_inner]
            move_y = mouse( )\selector\y - a_focused( )\y[#__c_inner]
            
            ForEach a_group( )
               Select BarButton
                  Case #_tb_group_left ; left
                                       ;mouse( )\selector\x = 0
                     mouse( )\selector\width = 0
                     Resize( a_group( )\widget, move_x, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_right ; right
                     mouse( )\selector\x = 0
                     mouse( )\selector\width = 0
                     Resize( a_group( )\widget, move_x + a_group( )\width, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_top ; top
                                      ;mouse( )\selector\y = 0
                     mouse( )\selector\height = 0
                     Resize( a_group( )\widget, #PB_Ignore, move_y, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_bottom ; bottom
                     mouse( )\selector\y = 0
                     mouse( )\selector\height = 0
                     Resize( a_group( )\widget, #PB_Ignore, move_y + a_group( )\height, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_width ; stretch horizontal
                     Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, mouse( )\selector\width, #PB_Ignore )
                     
                  Case #_tb_group_height ; stretch vertical
                     Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, mouse( )\selector\height )
                     
               EndSelect
            Next
            
            a_update( a_focused( ) )
         EndIf
         
         ;       Case #_tb_menu
         ;          DisplayPopupBar( *e_widget )
         
   EndSelect
   
EndProcedure

Procedure ide_events( )
   Protected *this._s_widget
   Protected e_type = WidgetEvent( )
   Protected e_item = WidgetEventItem( )
   Protected *e_widget._s_widget = EventWidget( )
   
   Select e_type
      Case #__event_Close
         If *e_widget = ide_root
            If #PB_MessageRequester_Yes = Message( "Message", 
                                                   "Are you sure you want to go out?",
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn #PB_All
            Else
               ProcedureReturn #False ; no close
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *e_widget = ide_inspector_elements
            SetState( *e_widget, WidgetEventItem( ))
            
            Debug " ------ drag ide_events() ----- "
            If DragDropPrivate( #_DD_CreateNew )
               ChangeCurrentCursor( *e_widget, Cursor::Create( ImageID( GetItemData( *e_widget, WidgetEventItem( ) ) ) ) )
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If *e_widget = ide_design_panel_CODE
            ; Debug Left( *e_widget\text\string, *e_widget\text\caret\pos ); GetState( ide_design_panel_CODE )
         EndIf
         
         If e_item = - 1
            SetText( ide_inspector_HELP, "help for the inspector" )
         Else
            If WidgetEventData( ) < 0
               If *e_widget = ide_inspector_view
                  ; Debug ""+WidgetEventData( )+" i "+e_item
                  SetText( ide_inspector_HELP, GetItemText( *e_widget, e_item ) )
               EndIf
               If *e_widget = ide_inspector_elements
                  SetText( ide_inspector_HELP, Help_elements(GetItemText( *e_widget, e_item )) )
               EndIf
               If *e_widget = ide_inspector_properties
                  SetText( ide_inspector_HELP, GetItemText( *e_widget, e_item ) )
               EndIf
               If *e_widget = ide_inspector_events
                  SetText( ide_inspector_HELP, GetItemText( *e_widget, e_item ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Change
         
         If *e_widget = ide_design_panel
            If e_item = 1
               Define code$ = GeneratePBCode( ide_design_panel_MDI )
               
               SetText( ide_design_panel_CODE, code$ )
               SetActive( ide_design_panel_CODE )
            EndIf
         EndIf
         
         If *e_widget = ide_inspector_view
            ; Debug ""+GetState(*e_widget)+" change-["+GetClass(*e_widget)+"]"
            ;PushListPosition(*e_widget\__rows())
            ;Debug GetClass(GetItemData(*e_widget, GetState(*e_widget)))
            If a_set( GetItemData(*e_widget, GetState(*e_widget)), #__a_full )
               ; Это не нужен так как a_set( ) мы получаем фокус выджета 
               ; Properties_Updates( "ide_inspector_view_Change" )
            EndIf
            ;PopListPosition(*e_widget\__rows())
         EndIf
         If *e_widget = ide_inspector_properties
            ; Debug " 2 change-["+GetClass(*e_widget)+"]"
           ; Properties_Updates( "ide_inspector_properties_Change" )
         EndIf
         
           
      Case #__event_LeftClick
         ; ide_menu_events( *e_widget, WidgetEventItem( ) )
         
         ; Debug *e_widget\TabEntered( )
         
         If *e_widget\TabEntered( )
            ide_menu_events( *e_widget, *e_widget\TabEntered( )\index )
         Else
            If Type( *e_widget ) = #__type_toolbar
               ide_menu_events( *e_widget, GetData( *e_widget ) )
            EndIf
         EndIf
         
   EndSelect
   
   ;\\ CODE EVENTS
   If *e_widget = ide_design_panel_CODE                      Or *e_widget = ide_design_DEBUG ; TEMP
      If e_type = #__event_Up Or
         e_type = #__event_Change Or
         e_type = #__event_StatusChange
         
         code_edit_events( *e_widget, e_type, e_item, WidgetEventData( ) )
      EndIf
   EndIf
   
EndProcedure

Procedure ide_open( X=100,Y=100,Width=850,Height=600 )
   ;     OpenWindow( #PB_Any, 0,0,332,232, "" )
   ;     ide_g_code = TreeGadget( -1,1,1,330,230 ) 
   
   Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
   ide_root = Open( 1, X,Y,Width,Height, "ide", flag ) 
   ide_window = GetCanvasWindow( ide_root )
   ide_g_canvas = GetCanvasGadget( ide_root )
   
   ;    Debug "create window - "+WindowID(ide_window)
   ;    Debug "create canvas - "+GadgetID(ide_g_canvas)
   
   ide_toolbar_container = Container( 0,0,0,0, #__flag_BorderFlat ) 
   ide_toolbar = ToolBar( ide_toolbar_container, #PB_ToolBar_Small );|#PB_ToolBar_Large|#PB_ToolBar_Buttons);| #PB_ToolBar_InlineText )
   SetColor(ide_toolbar, #__color_back, $fffefefe )
   
   OpenSubBar("Menu")
   BarItem( #_tb_file_new, "New" );+ Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_open, "Open" );+ Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_save, "Save" );+ Chr(9) + "Ctrl+S")
   BarItem( #_tb_file_save_as, "Save as...")
   BarSeparator( )
   BarItem( #_tb_file_quit, "Quit" );+ Chr(9) + "Ctrl+Q")
   CloseSubBar( )
   ;
   BarSeparator( )
   BarItem( #_tb_file_new, "New" );+ Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_open, "Open" );+ Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_save, "Save" );+ Chr(9) + "Ctrl+S")
   BarSeparator( )
   BarButton( #_tb_group_select, CatchImage( #PB_Any,?group ), #PB_ToolBar_Toggle ) 
   ;
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
   ;
   BarSeparator( )
   BarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
   BarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
   BarSeparator( )
   BarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
   BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
   BarSeparator( )
   BarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
   BarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
   
   ;    BarSeparator( )
   ;    OpenSubBar("ComboBox")
   ;    BarItem(55, "item1")
   ;    BarItem(56, "item2")
   ;    BarItem(57, "item3")
   ;    CloseSubBar( )
   
   BarSeparator( )
   BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
   BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
   BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
   BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
   BarSeparator( )
   BarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
   BarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
   BarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
   BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
   BarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
   CloseList( )
   
   ; gadgets
   
   ;\\\ 
   Define ide_root2 ;= Open(1) : Define ide_design_g_canvas =  GetCanvasGadget(ide_root2)
   
   ide_design_panel = Panel( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel, "ide_design_panel" ) ; , #__flag_Vertical ) : OpenList( ide_design_panel )
   AddItem( ide_design_panel, -1, "Form" )
   ide_design_panel_MDI = MDI( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel_MDI, "ide_design_panel_MDI" ) ;: SetFrame(ide_design_panel_MDI, 10)
   SetColor( ide_design_panel_MDI, #__color_back, RGBA(195, 156, 191, 255) )
   a_init( ide_design_panel_MDI);, 0 )
   
   AddItem( ide_design_panel, -1, "Code" )
   ide_design_panel_CODE = Editor( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel_CODE, "ide_design_panel_CODE" ) ; bug then move anchors window
   SetBackgroundColor( ide_design_panel_CODE, $FFDCF9F6)
   AddItem( ide_design_panel, -1, "Hiasm" )
   CloseList( )
   
   If ide_root2
      CloseGadgetList( )
      UseGadgetList( GadgetID(ide_g_canvas))
      OpenList(ide_root)
   Else
      Define ide_design_g_canvas = ide_design_panel
   EndIf
   
   ;
   ;ide_design_DEBUG = Editor( 0,0,0,0, #PB_Editor_ReadOnly ) : SetClass(ide_design_DEBUG, "ide_design_DEBUG" ) ; ListView( 0,0,0,0 ) 
   ide_design_DEBUG = Editor( 0,0,0,0 ) : SetClass(ide_design_DEBUG, "ide_design_DEBUG" ) ; ListView( 0,0,0,0 ) 
   If Not ide_design_panel_CODE
      ide_design_panel_CODE = ide_design_DEBUG
   EndIf
   
   ;\\\ open inspector gadgets 
   ide_inspector_view = Tree( 0,0,0,0 ) : SetClass(ide_inspector_view, "ide_inspector_view" ) ;, #__flag_gridlines )
   EnableDrop( ide_inspector_view, #PB_Drop_Text, #PB_Drag_Link )
   
   ; ide_inspector_view_splitter_panel_open
   ide_inspector_panel = Panel( 0,0,0,0 ) : SetClass(ide_inspector_panel, "ide_inspector_panel" )
   
   ; ide_inspector_panel_item_1 
   AddItem( ide_inspector_panel, -1, "elements", 0, 0 ) 
   ide_inspector_elements = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines | #__flag_borderless ) : SetClass(ide_inspector_elements, "ide_inspector_elements" )
   If ide_inspector_elements
      ide_add_image_list( ide_inspector_elements, GetCurrentDirectory( )+"Themes/" )
   EndIf
   
   ; ide_inspector_panel_item_2
   AddItem( ide_inspector_panel, -1, "properties", 0, 0 )  
   ide_inspector_properties = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_borderless ) : SetClass(ide_inspector_properties, "ide_inspector_properties" )
   If ide_inspector_properties
      Properties_AddItem( ide_inspector_properties, #_pi_group_0,  "Common"+Chr(10) )
      Properties_AddItem( ide_inspector_properties, #_pi_id,       "#ID"  , #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_class,    "Class"   , #__Type_String, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_text,     "Text"    , #__Type_String, 1 )
      
      Properties_AddItem( ide_inspector_properties, #_pi_group_1,  "Layout" )
      Properties_AddItem( ide_inspector_properties, #_pi_align,    "align"+Chr(10)+"LEFT&TOP"   , #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_x,        "x"       , #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_y,        "Y"       , #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_width,    "Width"   , #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_height,   "Height"  , #__Type_Spin, 1 )
      
      Properties_AddItem( ide_inspector_properties, #_pi_group_2,  "State" )
      Properties_AddItem( ide_inspector_properties, #_pi_disable,  "Disable" , #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_hide,     "Hide"    , #__Type_ComboBox, 1 )
      
      Properties_AddItem( ide_inspector_properties, #_pi_group_3,  "Flag" )
   EndIf
   
   ; ide_inspector_panel_item_3 
   AddItem( ide_inspector_panel, -1, "events", 0, 0 )  
   ide_inspector_events = Tree( 0,0,0,0, #__flag_autosize | #__flag_borderless ) : SetClass(ide_inspector_events, "ide_inspector_events" ) 
   If ide_inspector_events
      AddItem( ide_inspector_events, #_ei_leftclick,  "LeftClick" )
      AddItem( ide_inspector_events, #_ei_change,  "Change" )
      AddItem( ide_inspector_events, #_ei_enter,  "Enter" )
      AddItem( ide_inspector_events, #_ei_leave,  "Leave" )
   EndIf
   
   ; ide_inspector_view_splitter_panel_close
   CloseList( )
   
   ; ide_inspector_ide_inspector_panel_splitter_text
   ide_inspector_HELP  = Text( 0,0,0,0, "help for the inspector", #PB_Text_Border ) : SetClass(ide_inspector_HELP, "ide_inspector_HELP" )
   ;\\\ close inspector gadgets 
   
   ;
   ;\\\ ide splitters
   ;       ;
   ;       ; main splitter 1 example
   ;       ide_design_splitter = Splitter( 0,0,0,0, ide_toolbar_container,ide_design_g_canvas, #PB_Splitter_FirstFixed | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;       ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;       ide_design_panel_splitter = Splitter( 0,0,0,0, ide_design_splitter,ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_panel_splitter, "ide_design_panel_splitter" )
   ;       ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;       ide_splitter = Splitter( 0,0,0,0, ide_design_panel_splitter,ide_inspector_panel_splitter, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;       
   ;       ; set splitters default minimum size
   ;       SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 500 )
   ;       SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 120 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;       SetAttribute( ide_design_panel_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;       SetAttribute( ide_design_panel_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   ;       ; SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, $ffffff )
   ;       
   ;       ; set splitters dafault positions
   ;       SetState( ide_splitter, Width( ide_splitter )-200 )
   ;       SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;       SetState( ide_design_panel_splitter, Height( ide_design_panel_splitter )-150 )
   ;       SetState( ide_inspector_view_splitter, 200 )
   ;       SetState( ide_design_splitter, Height( ide_toolbar ) - 1 + 2 )
   ;    
   ;    ;
   ;    ;\\ main splitter 2 example 
   ;    ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;    ide_design_panel_splitter = Splitter( 0,0,0,0, ide_design_g_canvas,ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_panel_splitter, "ide_design_panel_splitter" )
   ;    ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;    ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_panel_splitter, ide_design_panel_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;    ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;    
   ;    ; set splitters default minimum size
   ;    SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;    SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;    SetAttribute( ide_design_panel_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;    SetAttribute( ide_design_panel_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;    
   ;    ; set splitters dafault positions
   ;    SetState( ide_splitter, Height( ide_toolbar ) )
   ;    SetState( ide_design_splitter, 200 )
   ;    SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;    SetState( ide_design_panel_splitter, Height( ide_design_panel_splitter )-200 )
   ;    SetState( ide_inspector_view_splitter, 230 )
   ;    
   
   ;
   ;\\ main splitter 2 example 
   ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_panel, ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_view_splitter" )
   ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view, ide_inspector_panel_splitter) : SetClass(ide_inspector_view_splitter, "ide_inspector_panel_splitter" )
   ide_design_panel_splitter = Splitter( 0,0,0,0, ide_design_g_canvas, ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_panel_splitter, "ide_design_panel_splitter" )
   ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter, ide_design_panel_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   
   ; set splitters default minimum size
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   SetAttribute( ide_design_panel_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   SetAttribute( ide_design_panel_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   
   ; set splitters dafault positions
   SetState( ide_splitter, Height( ide_toolbar ))
   SetState( ide_design_splitter, 200 )
   SetState( ide_design_panel_splitter, Height( ide_design_panel_splitter )-180 )
   ;SetState( ide_inspector_panel_splitter, 250 )
   SetState( ide_inspector_view_splitter, 200 )
   
   ;
   ;\\\ ide events binds
   ;
   If Type( ide_toolbar ) = #__type_ToolBar
      Bind( ide_toolbar, @ide_events( ), #__event_LeftClick )
   EndIf
   Bind( ide_inspector_view, @ide_events( ) )
   ;
   Bind( ide_design_panel, @ide_events( ), #__event_Change )
   ;
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Up )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Change )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_StatusChange )
   ; TEMP
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Up )
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Change )
   Bind( ide_design_DEBUG, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_events, @ide_events( ), #__event_Change )
   Bind( ide_inspector_events, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_properties, @ide_events( ), #__event_Change )
   Bind( ide_inspector_properties, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_elements, @ide_events( ), #__event_Change )
   Bind( ide_inspector_elements, @ide_events( ), #__event_StatusChange )
   Bind( ide_inspector_elements, @ide_events( ), #__event_LeftClick )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseEnter )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseLeave )
   Bind( ide_inspector_elements, @ide_events( ), #__event_DragStart )
   ;
   ;
   Bind( ide_root, @ide_events( ), #__event_Close )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   SetState( ide_inspector_panel, 1 )
   
   ;   ;OpenList(ide_design_panel_MDI)
   Define result, btn2, example = 3
   
   
   ide_design_form = widget_add( ide_design_panel_MDI, "window", 10, 10, 350, 200 )
   
   If example = 2
      ;       widget_add( ide_design_form, "button", 10, 20, 100, 30 )
      ;       
      ;       Debug ""+GetClass(widget()\parent) +" "+ widget()\x[0] +" "+ widget()\x[7] +" "+ widget()\width[0] +" "+ widget()\width[7]
      ;       Define *container = widget_add( ide_design_form, "container", 130, 20, 220, 140 )
      ;       widget_add( *container, "button", 10, 20, 30, 30 )
      ;       
      ; ;       ClearItems(ide_inspector_view)
      ; ; ;       AddItem(ide_inspector_view, -1, "window_0", -1, 0)
      ; ; ;       AddItem(ide_inspector_view, -1, "button_0", -1, 1)
      ; ; ;       AddItem(ide_inspector_view, -1, "container_0", -1, 1)
      ; ; ;       AddItem(ide_inspector_view, -1, "button_1", -1, 2)
      ; ; ;       
      ; ;       Define *parent._s_WIDGET = ide_design_panel_MDI
      ; ;       ;PushListPosition(widgets())
      ; ;       If StartEnum( *parent ,0)
      ; ;          Debug "99 "+ GetClass(widget()) +" "+ GetClass(widget()\parent) +" "+ Str(Level(widget()))+" "+Str(Level(*parent));IsChild(widget(), *parent )
      ; ;          Select CountItems(ide_inspector_view)
      ; ;             Case 0 
      ; ;                AddItem(ide_inspector_view, -1, "window_0", -1, Level(widget())-Level(*parent)-1)
      ; ;             Case 1 
      ; ;                AddItem(ide_inspector_view, -1, "button_0", -1, Level(widget())-Level(*parent)-1)
      ; ;             Case 2 
      ; ;                AddItem(ide_inspector_view, -1, "container_0", -1, Level(widget())-Level(*parent)-1)
      ; ;             Case 3 
      ; ;                AddItem(ide_inspector_view, -1, "button_1", -1, Level(widget())-Level(*parent)-1)
      ; ;          EndSelect
      ; ;          
      ; ;          ;   Debug CountItems(ide_inspector_view)-1
      ; ;          SetData(widget(), CountItems(ide_inspector_view)-1)
      ; ;          SetItemData(ide_inspector_view, CountItems(ide_inspector_view)-1, widget())
      ; ;          
      ; ;          StopEnum()
      ; ;       EndIf
      ; ;       ;PopListPosition(widgets())
      ;       
      ;       ;\\ example 2
      ; ;       Define *container = widget_add( ide_design_form, "container", 130, 20, 220, 140 )
      ; ;       widget_add( *container, "button", 10, 20, 30, 30 )
      ; ;       widget_add( ide_design_form, "button", 10, 20, 100, 30 )
      ; ;       
      ; ;       Define item = 1
      ; ;       SetState( ide_inspector_view, item )
      ; ;       If IsGadget( ide_g_code )
      ; ;          SetGadgetState( ide_g_code, item )
      ; ;       EndIf
      ; ;       Define *container2 = widget_add( *container, "container", 60, 10, 220, 140 )
      ; ;       widget_add( *container2, "button", 10, 20, 30, 30 )
      ; ;       
      ; ;       SetState( ide_inspector_view, 0 )
      ; ;       widget_add( ide_design_form, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      Resize(ide_design_form, 10, 10, 500, 250)
      Disable(widget_add(ide_design_form, "button", 15, 25, 50, 30),1)
      widget_add(ide_design_form, "text", 25, 65, 50, 30)
      btn2 = widget_add(ide_design_form, "button", 35, 65+40, 50, 30)
      widget_add(ide_design_form, "string", 45, 65+40*2, 50, 30)
      ;widget_add(ide_design_form, "button", 45, 65+40*2, 50, 30)
      
      Define *scrollarea = widget_add(ide_design_form, "scrollarea", 120, 25, 165, 175)
      widget_add(*scrollarea, "button", 15, 25, 30, 30)
      widget_add(*scrollarea, "text", 25, 65, 50, 30)
      widget_add(*scrollarea, "button", 35, 65+40, 80, 30)
      widget_add(*scrollarea, "text", 45, 65+40*2, 50, 30)
      
      Define *panel = widget_add(ide_design_form, "panel", 320, 25, 165, 175)
      widget_add(*panel, "button", 15, 25, 30, 30)
      widget_add(*panel, "text", 25, 65, 50, 30)
      widget_add(*panel, "button", 35, 65+40, 80, 30)
      widget_add(*panel, "text", 45, 65+40*2, 50, 30)
      
      AddItem( *panel, -1, "pane_item_1" )
      ;OpenList( *panel, 1 )
      widget_add(*panel, "button", 115, 25, 30, 30)
      widget_add(*panel, "text", 125, 65, 50, 30)
      widget_add(*panel, "button", 135, 65+40, 80, 30)
      widget_add(*panel, "text", 145, 65+40*2, 50, 30)
      ;CloseList( )
      SetState( *panel, 1 )
      
      ;       ;SetMoveBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;SetSizeBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;SetSizeBounds( *scrollarea )
      ;       SetMoveBounds( btn2, -1,-1,-1,-1 )
      SetMoveBounds( ide_design_form, -1,-1,-1,-1 )
      ;       ;SetChildrenBounds( ide_design_panel_MDI )
      
   ElseIf example = 4
      ;\\ example 3
      Resize(ide_design_form, 30, 30, 400, 250)
      
      Define q=widget_add(ide_design_form, "button", 15, 25, 50, 30)
      widget_add(ide_design_form, "text", 25, 65, 50, 30)
      widget_add(ide_design_form, "button", 285, 25, 50, 30)
      widget_add(ide_design_form, "text", 45, 65+40*2, 50, 30)
      
      Define *container = widget_add(ide_design_form, "scrollarea", 100, 25, 165, 170)
      widget_add(*container, "button", 15, 25, 30, 30)
      widget_add(*container, "text", 25, 65, 50, 30)
      widget_add(*container, "button", 35, 65+40, 80, 30)
      widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
      
   ElseIf example = 5
      ;\\ example 3
      Resize(ide_design_form, 30, 30, 400, 250)
      
      Define q=widget_add(ide_design_form, "button", 280, 25, 50, 30)
      widget_add(ide_design_form, "text", 25, 65, 50, 30)
      widget_add(ide_design_form, "button", 340, 25, 50, 30)
      widget_add(ide_design_form, "text", 45, 65+40*2, 50, 30)
      
      Define *container = widget_add(ide_design_form, "scrollarea", 100, 25, 155, 170)
      widget_add(*container, "button", 15, 25, 30, 30)
      widget_add(*container, "text", 25, 65, 50, 30)
      widget_add(*container, "button", 35, 65+40, 80, 30)
      widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
   EndIf
   
   
   ;    Define._S_WIDGET *this, *parent
   ;    Debug "--- enumerate all gadgets ---"
   ;    If StartEnum( root( ) )
   ;       Debug "     gadget - "+ widget( )\index +" "+ GetClass(widget( )) +"               ("+ GetClass(widget( )\parent) +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   ;    Debug ""
   ;    *parent = *container
   ;    *this = GetPositionLast( *parent )
   ;    Debug ""+GetClass(*this) +"           ("+ GetClass(*parent) +")" ;  +" - ("+ *this\text\string +")"
   ;    
   ;    
   ;    If StartEnum( *parent )
   ;       Debug "   *parent  gadget - "+ widget( )\index +" "+ GetClass(widget( )) +"               ("+ GetClass(widget( )\parent) +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   
;       Define code$ = GeneratePBCode( ide_design_panel_MDI )
;       SetText( ide_design_panel_CODE, code$ )
;       ;SetText( ide_design_DEBUG, code$ )
;       ;ReDraw( GetRoot(ide_design_panel_CODE) )
     
   If SetActive( ide_inspector_view )
      SetActiveGadget( ide_g_canvas )
   EndIf
    
   ;\\ 
   WaitClose( )
CompilerEndIf


;\\ include images
DataSection   
   IncludePath #IDE_path + "ide/include/images"
   
   widget_delete:    : IncludeBinary "16/delete.png"
   widget_paste:     : IncludeBinary "16/paste.png"
   widget_copy:      : IncludeBinary "16/copy.png"
   widget_cut:       : IncludeBinary "16/cut.png"
   
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
; CursorPosition = 1058
; FirstLine = 1021
; Folding = -----6-----P+-----------------------0------
; EnableXP
; DPIAware
; Executable = ..\widgets-ide.app.exe