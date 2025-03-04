;
EnableExplicit
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
   
   #_tb_file_run
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
Global enumerations 

Global img = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" ) 

; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
; test_focus_show = 1
; test_focus_set = 1
; test_changecursor = 1

Global NewMap FlagsString.s( )
Global NewMap EventsString.s( )
Global NewMap ImagePuchString.s( )
Global NewMap ClassString.s( )
Global NewMap GetObject.s( )

Structure _s_LINE
   type$
   pos.i
   len.i
   String.s
   
   id$
   func$
   arg$
EndStructure
Structure _s_PARSER
   List *line._s_LINE( )
EndStructure
Global *parser._s_PARSER = AllocateStructure( _s_PARSER )
;*parser\Line( ) = AllocateStructure( _s_LINE )

;
;- DECLAREs
Declare   widget_events( )
Declare   Properties_SetItemText( *splitter, item, Text.s )
Declare.s Properties_GetItemText( *splitter, item, mode = 0 )
Declare   Properties_Updates( *object, type$ )
Declare   widget_Create( *parent, Class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
Declare   widget_add( *parent, Class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag = 0 )
Declare   ide_addline( *new )
Declare   MakeObject( class$ )
;
Declare.s GenerateGUICODE( *mdi, mode.a = 0 )
Declare.s GeneratePBCode( *parent )
Declare$  FindArguments( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
Declare   MakeCallFunction( str$, arg$, findtext$ )
Declare   GetArgIndex( text$, len, caret, mode.a = 0 )
Declare$  GetWord( text$, len, caret )
;
Declare$  FindFunctions( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
Declare   NumericString( string$ )
Declare.q MakeFlag( Flag_Str.s )
Declare.q MakeConstants( string$ )
;
;- INCLUDEs
#ide_path = "../"
XIncludeFile #ide_path + "widgets.pbi"
XIncludeFile #ide_path + "include/newcreate/anchorbox.pbi"
CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "code.pbi"
CompilerEndIf

;
;- USES
UseWidgets( )
UsePNGImageDecoder( )

;
;- PUBLICs
Procedure.s BoolToStr( val )
   If (val) > 0
      ProcedureReturn "True"
   Else ; If (val) = 0
      ProcedureReturn "False"
   EndIf
EndProcedure

Procedure   StrToBool( STR.s )
   If STR = "True"
      ProcedureReturn 1
   ElseIf STR = "False"
      ProcedureReturn 0
   EndIf
EndProcedure

;-
Procedure   is_parent_item( *this._s_WIDGET, item )
   Protected result
   PushItem(*this)
   If SelectItem( *this, item)
      result = *this\__rows( )\childrens 
   EndIf
   PopItem(*this)
   ProcedureReturn result
EndProcedure

;-
Procedure ide_addline( *new._s_widget )
   Protected *parent._s_widget, Param1, Param2, Param3, newClass.s = GetClass( *new )
   
   If *new
      *parent = GetParent( *new )
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
         If LCase(newClass.s) = LCase(GetItemText( ide_inspector_elements, i ))
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
      
      ; Debug  " pos "+position + "   ( Debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
   EndIf
   
   ProcedureReturn *new
EndProcedure

;-
Procedure ReplaceText( *this._s_WIDGET, find$, replace$, NbOccurrences.b = 0 )
   Protected code$ = GetText( *this )
   
   If NbOccurrences
      code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive, FindString( code$, find$ ), NbOccurrences )
   Else
      code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive )
   EndIf
   
   If code$
      SetText( *this, code$ )
   EndIf
EndProcedure

Procedure   ReplaceArg( *object._s_WIDGET, argument, replace$ )
   Protected find$, count, caret
   
   Select argument
      Case 0
         SetClass( *object, replace$ )
         
         ;
         Properties_Updates( *object, "Class" )
         
      Case 1                              ; id
         Debug "  ------ id"
         
      Case 2,3,4,5 
         ;
         Select argument
            Case 2 : Resize( *object, Val( replace$ ), #PB_Ignore, #PB_Ignore, #PB_Ignore)
            Case 3 : Resize( *object, #PB_Ignore, Val( replace$ ), #PB_Ignore, #PB_Ignore)
            Case 4 : Resize( *object, #PB_Ignore, #PB_Ignore, Val( replace$ ), #PB_Ignore)
            Case 5 : Resize( *object, #PB_Ignore, #PB_Ignore, #PB_Ignore, Val( replace$ ))
         EndSelect
         
      Case 6 
         replace$ = StringField( replace$, 1, ")" )
         replace$ = Trim( replace$ )
         replace$ = Trim( replace$, Chr('"') )
         ;
         SetText( *object, replace$ ) 
         ;
         Properties_Updates( *object, "Text" )
         
   EndSelect
   
EndProcedure

;-
Procedure   Properties_ButtonHide( *second._s_WIDGET, state )
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

Procedure   Properties_ButtonChange( *inspector._s_WIDGET )
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

Procedure   Properties_ButtonResize( *second._s_WIDGET )
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

Procedure   Properties_ButtonDisplay( *second._s_WIDGET )
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

Procedure   Properties_ButtonEvents( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   ; Debug ""+widget::ClassFromEvent(__event) +" "+ widget::GetClass( *g)
   
   Select __event
      Case #__event_Down
         GetActive( )\gadget = *g
         ;          ;
         ;          Select Type( *g)
         ;             ;Case #__type_Spin     : SetItemText(*g\parent, GetData(*g), Str(GetState(*g)) )
         ;             ;Case #__type_String   : SetItemText(*g\parent, GetData(*g), GetText(*g) )
         ;             Case #__type_ComboBox : SetItemText(*g\parent, GetData(*g), Str(GetState(*g)) )
         ;          EndSelect
         
      Case #__event_MouseWheel
         If __item > 0
            SetState(*g\scroll\v, GetState( *g\scroll\v ) - __data )
         EndIf
         
      Case #__event_Change
         Select Type(*g)
            Case #__type_Button
               ; Debug 555
               
            Case #__type_String
               Select GetData(*g) 
                  Case #_pi_class  
                     SetClass( a_focused( ), UCase( GetText(*g)))
                     Properties_Updates( a_focused( ), "Class" ) 
                  Case #_pi_text   
                     SetText( a_focused( ), GetText(*g) )  
                     Properties_Updates( a_focused( ), "Text" ) 
               EndSelect
               
            Case #__type_Spin
               Select GetData(*g) 
                  Case #_pi_x      : Resize( a_focused( ), GetState(*g), #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
                  Case #_pi_y      : Resize( a_focused( ), #PB_Ignore, GetState(*g), #PB_Ignore, #PB_Ignore )
                  Case #_pi_width  : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, GetState(*g), #PB_Ignore )
                  Case #_pi_height : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(*g) )
               EndSelect
               
               
            Case #__type_ComboBox
               Select GetData(*g) 
                  Case #_pi_id
                     If GetState(*g) 
                        If SetClass( a_focused( ), "#"+Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( a_focused( ), "ID" ) 
                           Properties_Updates( a_focused( ), "Class" ) 
                        EndIf
                     Else
                        If SetClass( a_focused( ), Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( a_focused( ), "ID" ) 
                           Properties_Updates( a_focused( ), "Class" ) 
                        EndIf
                     EndIf
                     
                  Case #_pi_disable 
                     If Disable( a_focused( ), GetState(*g) )
                        Properties_Updates( a_focused( ), "Disable" ) 
                     EndIf
                     
                  Case #_pi_hide    
                     If Hide( a_focused( ), GetState(*g) )
                        Properties_Updates( a_focused( ), "Hide" ) 
                     EndIf
               EndSelect
               
         EndSelect
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_ButtonCreate( Type, *parent._s_WIDGET, item )
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
Procedure   Properties_StatusChange( *this._s_WIDGET, item )
   Protected *g._s_WIDGET = EventWidget( )
   
   If GetState( *this ) = item
      ProcedureReturn 0
   EndIf 
   
   ;    If GetState(*g) = item
   ;       ProcedureReturn 0
   ;    EndIf 
   
   PushListPosition(*g\__rows( ))
   SelectElement( *g\__rows( ), item )
   ;
   If *g\__rows( ) 
      PushListPosition( *this\__rows( ) )
      SelectElement( *this\__rows( ), *g\__rows( )\index)
      *this\__rows( )\color = *g\__rows( )\color
      
      If *this\__rows( )\colorState( ) = #__s_2
         If *this\RowFocused( )
            *this\RowFocused( )\focus = 0
         EndIf
         *this\RowFocused( ) = *this\__rows( )
         *this\RowFocused( )\focus = 1
      EndIf
      
      PopListPosition( *this\__rows( ) )
   EndIf
   PopListPosition(*g\__rows( ))
   
   ;    If __data = 3
   ;       If GetActive( ) <> *g
   ;          Debug "set active "+GetClass(*g)
   ;          SetActive( *g)
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

Procedure   Properties_SetItemText( *splitter._s_WIDGET, item, Text.s )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   ;
   SetItemText( *first, item, StringField(Text.s, 1, Chr(10)) )
   SetItemText( *second, item, StringField(Text.s, 2, Chr(10)) )
   
   ;Properties_ButtonChange( *splitter )
EndProcedure

Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
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

Procedure   Properties_Events( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Protected *first._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_SecondGadget)
   ;  
   Select __event
      Case #__event_Down
         If is_parent_item( *g, __item )
            Properties_ButtonHide( *second, #True)
         EndIf
         If Not EnteredButton( )
            SetState( *g, __item)
         EndIf
         
      Case #__event_Change
         Select *g
            Case *first : SetState(*second, GetState(*g))
            Case *second : SetState(*first, GetState(*g))
         EndSelect
         
         ; create PropertiesButton
         Properties_ButtonDisplay( *second )
         
      Case #__event_StatusChange
         If *g = *first
            If __data = #PB_Tree_Expanded Or
               __data = #PB_Tree_Collapsed
               ;
               SetItemState( *second, __item, __data)
            EndIf
         EndIf
         
         Select*g
            Case *first : Properties_StatusChange( *second, __item )
            Case *second : Properties_StatusChange( *first, __item )
         EndSelect
         
      Case #__event_ScrollChange
         If *g = *first 
            If GetState( *second\scroll\v ) <> __data
               SetState(*second\scroll\v, __data )
            EndIf
         EndIf   
         
         If *g = *second
            If GetState( *first\scroll\v ) <> __data
               SetState(*first\scroll\v, __data )
            EndIf
         EndIf
         
   EndSelect
   
   ;
   Select __event
      Case #__event_resize, #__event_ScrollChange
         If *g = *second
            Properties_ButtonResize( *second )
         EndIf
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_Create( X,Y,Width,Height, flag=0 )
   Protected position = 70
   Protected *first._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoLines)
   Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines)
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   ;
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

Procedure   Properties_Updates( *object._s_WIDGET, type$ )
   Protected find$, replace$, name$, class$, x$, y$, width$, height$
   ; class$ = Properties_GetItemText( ide_inspector_properties, #_pi_class, 1 )
   
   If type$ = "Focus" Or type$ = "ID"
      Properties_SetItemText( ide_inspector_properties, #_pi_id,     
                              Properties_GetItemText( ide_inspector_properties, #_pi_id ) +
                              Chr( 10 ) + BoolToStr( Bool( GetClass( *object ) <> Trim( GetClass( *object ), "#" ) )))
   EndIf
   If type$ = "Focus" Or type$ = "Hide"
      Properties_SetItemText( ide_inspector_properties, #_pi_hide,    
                              Properties_GetItemText( ide_inspector_properties, #_pi_hide ) + 
                              Chr( 10 ) + BoolToStr( Hide( *object )))
   EndIf
   If type$ = "Focus" Or type$ = "Disable"
      Properties_SetItemText( ide_inspector_properties, #_pi_disable, 
                              Properties_GetItemText( ide_inspector_properties, #_pi_disable ) +
                              Chr( 10 ) + BoolToStr( Disable( *object )))
   EndIf
   
   If type$ = "Focus" Or type$ = "Class"
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_class, 1 )
      replace$ = GetClass( *object )
      Properties_SetItemText( ide_inspector_properties, #_pi_class,  Properties_GetItemText( ide_inspector_properties, #_pi_class ) + Chr( 10 ) + replace$ )
   EndIf
   If type$ = "Focus" Or type$ = "Text"
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_text, 1 )
      replace$ = GetText( *object )
      Properties_SetItemText( ide_inspector_properties, #_pi_text,   Properties_GetItemText( ide_inspector_properties, #_pi_text ) + Chr( 10 ) + replace$ )
   EndIf
   If type$ = "Focus" Or type$ = "Resize"
      ; Debug "---- "+type$
      If is_window_( *object )
         x$ = Str( X( *object, #__c_container ))
         y$ = Str( Y( *object, #__c_container ))
         width$ = Str( Width( *object, #__c_inner ))
         height$ = Str( Height( *object, #__c_inner ))
      Else
         x$ = Str( X( *object ))
         y$ = Str( Y( *object ))
         width$ = Str( Width( *object ))
         height$ = Str( Height( *object ))
      EndIf
      
      find$ = Properties_GetItemText( ide_inspector_properties, #_pi_x, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_y, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_width, 1 ) +", "+ 
              Properties_GetItemText( ide_inspector_properties, #_pi_height, 1 )
      replace$ = x$ +", "+ y$ +", "+ width$ +", "+ height$
      
      Properties_SetItemText( ide_inspector_properties, #_pi_x,      Properties_GetItemText( ide_inspector_properties, #_pi_x )      + Chr( 10 ) + x$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_y,      Properties_GetItemText( ide_inspector_properties, #_pi_y )      + Chr( 10 ) + y$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_width,  Properties_GetItemText( ide_inspector_properties, #_pi_width )  + Chr( 10 ) + width$ )
      Properties_SetItemText( ide_inspector_properties, #_pi_height, Properties_GetItemText( ide_inspector_properties, #_pi_height ) + Chr( 10 ) + height$ )
      
      ;
      Properties_ButtonChange( ide_inspector_properties )
   EndIf
   
   ;\\
   If type$ <> "Focus"
      Protected NbOccurrences
      Protected *this._s_WIDGET = GetActive( )
      
      If find$
         If type$ = "Class"
            If *this = ide_design_panel_CODE Or 
               *this = ide_design_DEBUG
               ;
               Define code$ = GetText( *this )
               
               Define caret1 = FindString( code$, replace$ )
               Define caret2 = GetCaret( *this )
               
               ; количество слов для замены до позиции коретки
               Define count = CountString( Left( code$, caret1), find$ )
               
               Debug "caret "+caret1 +" "+ Str(caret2 - Len( find$ ))
               
               ; если коретка в конце слова Ok
               If caret1 = caret2 - Len( find$ )
                  code$ = ReplaceString( code$, replace$, find$, #PB_String_CaseSensitive, caret1, 1 )
                  
                  ;             If Len( replace$ ) > Len( find$ )
                  ;                SetCaret( *this, caret1 - (Len( replace$ ) - Len( find$ )))
                  ;             EndIf
               Else
                  ; если коретка в начале слова
                  If caret1 = caret2
                     code$ = ReplaceString( code$, replace$, find$, #PB_String_CaseSensitive, caret1, 1 )
                  EndIf
               EndIf
               
               ; caret update
               If count
                  If  keyboard( )\key
                     If keyboard( )\key = #PB_Shortcut_Back
                        If *this\text\edit[2]\len
                           SetCaret( *this, caret2 - count - (*this\text\edit[2]\len*(count))+2 )
                        Else
                           SetCaret( *this, caret2 - count )
                        EndIf
                     Else
                        SetCaret( *this, caret2 + count - (*this\text\edit[2]\len*count) )
                     EndIf
                  EndIf
               EndIf
               
               ;
               ; code$ = ReplaceString( code$, " "+find$+" ", " "+replace$+" ", #PB_String_CaseSensitive )
               code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive )
               If code$
                  SetText( *this, code$ )
               EndIf
            EndIf
            ; Меняем все найденные слова 
            NbOccurrences = 0
         Else
            ; Меняем первое одно найденное слово 
            NbOccurrences = 1
         EndIf
         
         ;
         If *this <> ide_design_DEBUG
            ReplaceText( ide_design_DEBUG, find$, replace$, NbOccurrences )
         EndIf
         If *this <> ide_design_panel_CODE
            If Not Hide( ide_design_panel_CODE )
               ReplaceText( ide_design_panel_CODE, find$, replace$, NbOccurrences )
            EndIf 
         EndIf
      EndIf
   EndIf
   
EndProcedure

;-
Procedure$  MakeArgString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
  Protected i, chr$, start, stop 
  Static ii
  
   For i = 0 To len
      chr$ = Mid( string$, i, 1 )
      If chr$ = "(" 
         start = i + 1
         For i = len To start Step - 1
            chr$ = Mid( string$, i, 1 )
            If chr$ = ")" 
               stop = i - start
               
               For i = start To len
                  chr$ = Mid( Mid( string$, start, stop ), i, 1 )
                  
                  If chr$ = ")" 
                     stop = i - Bool(FindString( string$, ":" ))
                     Break 
                  EndIf
               Next i
               
               If *start
                  *start\i = start
               EndIf
               If *stop
                  *stop\i = stop
               EndIf
               If Not stop
                  ProcedureReturn " "
               Else
                  ; Debug Mid( string$, start, stop )
                  ProcedureReturn Mid( string$, start, stop )
               EndIf 
               Break
            EndIf
         Next i
         
         Break
      EndIf
   Next i
EndProcedure

Procedure$  MakeFuncString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, result$, str$, start, stop
   Protected space, pos = FindString( string$, "=" )
   
   If pos
      If pos > FindString( string$, "(" )
         pos = 0
      Else
         string$ = Mid( string$, pos + 1, len - pos )
      EndIf
   Else
      pos = FindString( string$, ":" )
      If pos
         string$ = StringField( string$, 2, ":" )
      EndIf
   EndIf
   
   For i = 1 To len
      If Mid( string$, i, 1 ) = "(" 
         stop = i - 1
         str$ = Mid( string$, start, stop )
         result$ = Trim( str$ )
         space = FindString( str$, result$ )
         If space 
            start + space
            stop - space
         EndIf
         If *start
            *start\i = pos + start
         EndIf
         If *stop
            *stop\i = stop + 1
         EndIf
         Break
      EndIf
   Next i
   
   ProcedureReturn result$
EndProcedure

Procedure MakeVal( string$ )
   Protected result, len = Len( string$ ) 
   
   Define arg$ = MakeArgString( string$, len )
   Define func$ = MakeFuncString( string$, len )
   Debug "[MakeVal]"+func$ 
   
   Select Trim( func$ )
      Case "RGB"
         result = RGB( Val(Trim(StringField( arg$, 1, ","))), 
                       Val(Trim(StringField( arg$, 2, ","))),
                       Val(Trim(StringField( arg$, 3, ","))) )
      Case "RGBA"
         result = RGBA( Val(Trim(StringField( arg$, 1, ","))), 
                        Val(Trim(StringField( arg$, 2, ","))),
                        Val(Trim(StringField( arg$, 3, ","))),
                        Val(Trim(StringField( arg$, 4, ","))) )
   EndSelect
   
   ProcedureReturn result
EndProcedure

Procedure MakeFunc( string$, Index )
   Protected result, result$
   result$ = StringField(StringField(string$, 1, "("), Index, ",") +"("+ StringField(string$, 2, "(")
   Debug "[MakeFunc]"+result$
   result = MakeVal( result$ )
   
   ProcedureReturn result
EndProcedure

;-
Procedure MakeLine( string$, findtext$ )
   Protected result
   Protected text$, flag$, type$, id$, x$, y$, width$, height$, param1$, param2$, param3$, param4$
   Protected param1, param2, param3, flags.q
   
   Define string_len = Len( String$ )
   Define arg_start, arg_stop, arg$ = MakeArgString( string$, string_len, @arg_start, @arg_stop ) 
   If arg$
     ; Debug arg$ +" "+ arg_start
      Define str$ = Mid( String$, 1, arg_start - 1 - 1 ) ; исключаем открывающую скобку '('
      
      If FindString( str$, ";" )
         ProcedureReturn 0
      EndIf
      
      LastElement( *parser\Line( ))
      If AddElement( *parser\Line( ))
         *parser\Line( ) = AllocateStructure( _s_LINE )
         
         With *parser\Line( )
            \arg$ = arg$
            \string = string$
            \func$ = MakeFuncString( string$, string_len )
            
            ;
            \pos = FindString( str$, "Declare" )
            If \pos
               \type$ = "Declare"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Procedure" )
            If \pos
               \type$ = "Procedure"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Select" )
            If \pos
               \type$ = "Select"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "While" )
            If \pos
               \type$ = "While"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Repeat" )
            If \pos
               \type$ = "Repeat"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "If" )
            If \pos
               \type$ = "If"
               \func$ = Trim( StringField( \func$, 2, " " ))
               ; ProcedureReturn 
            EndIf
            
             Debug "[Make]"+\func$;arg$
       
            ;
            Select \func$
               Case "OpenWindow",
                    "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                    "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                    "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                    "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                    "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                    "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                    "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                    "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                  
                  Static *parent
                  Protected *new._s_WIDGET
                  
                  ;
                  \func$ = ReplaceString( \func$, "Gadget", "")
                  \func$ = ReplaceString( \func$, "Open", "")
                       
                  ; id$
                  If FindString( str$, "=" )
                     \id$ = Trim( StringField( str$, 1, "=" ))
                  Else
                     \id$ = Trim( StringField( arg$, 1, "," ))
                     
                     If NumericString( \id$ )
                        AddMapElement( GetObject( ), \id$ )
                        \id$ = "#" + \func$ +"_"+ \id$
                        If Not enumerations
                           \id$ = Trim( \id$, "#" )
                        EndIf
                        GetObject( ) = UCase(\id$)
                     Else
                        If Not enumerations
                           \id$ = Trim( \id$, "#" )
                        EndIf
                     EndIf
                  EndIf   
                  
                  ;
                  x$      = Trim(StringField( arg$, 2, ","))
                  y$      = Trim(StringField( arg$, 3, ","))
                  width$  = Trim(StringField( arg$, 4, ","))
                  height$ = Trim(StringField( arg$, 5, ","))
                  ;
                  param1$ = Trim(StringField( arg$, 6, ","))
                  param2$ = Trim(StringField( arg$, 7, ","))
                  param3$ = Trim(StringField( arg$, 8, ",")) 
                  param4$ = Trim(StringField( arg$, 9, ","))
                  
                  ;
                  If Not NumericString( x$ )  
                     x$ = StringField( StringField( Mid( findtext$, FindString( findtext$, x$ ) ), 1, "," ), 2, "=" )
                  EndIf
                  If Not NumericString( y$ )  
                     y$ = StringField( StringField( Mid( findtext$, FindString( findtext$, y$ ) ), 1, "," ), 2, "=" )
                  EndIf
                  If Not NumericString( width$ )  
                     width$ = StringField( StringField( Mid( findtext$, FindString( findtext$, width$ ) ), 1, "," ), 2, "=" )
                  EndIf
                  If Not NumericString( height$ )  
                     height$ = StringField( StringField( Mid( findtext$, FindString( findtext$, height$ ) ), 1, "," ), 2, "=" )
                  EndIf
                  
                  ; text
                  Select \func$
                     Case "Window", "Web", "Frame",
                          "Text", "String", "Button", "CheckBox",
                          "Option", "HyperLink", "ListIcon", "Date",
                          "ExplorerList", "ExplorerTree", "ExplorerCombo"
                        
                        If FindString( param1$, Chr('"'))
                           text$ = Trim( param1$, Chr('"'))
                        Else
                           text$ = Trim(StringField( StringField( Mid( findtext$, FindString( findtext$, param1$ ) ), 1, ")" ), 2, "=" ))
                        EndIf
                        If text$
                           ;If FindString( text$, Chr('"'))
                           text$ = Trim( text$, Chr('"'))
                           ;EndIf
                        EndIf
                        
                  EndSelect
                  
                  ; param1
                  Select \func$
                     Case "Track", "Progress", "Scroll", "ScrollArea",
                          "TrackBar","ProgressBar", "ScrollBar"
                        param1 = Val( param1$ )
                        
                     Case "Splitter" 
                        param1 = MakeObject(UCase(Param1$))
                        
                     Case "ListIcon"
                        param1 = Val( param2$ ) ; *this\columns( )\width
                        
                  EndSelect
                  
                  ; param2
                  Select \func$
                     Case "Track", "Progress", "Scroll", "TrackBar", 
                          "ProgressBar", "ScrollBar", "ScrollArea"
                        param2 = Val( param2$ )
                        
                     Case "Splitter" 
                        param2 = MakeObject(UCase(Param2$))
                        
                  EndSelect
                  
                  ; param3
                  Select \func$
                     Case "Scroll", "ScrollBar", "ScrollArea"
                        param3 = Val( param3$ )
                  EndSelect
                  
                  ; param4
                  Select \func$
                     Case "Date", "Calendar", "Container", 
                          "Tree", "ListView", "ComboBox", "Editor"
                        flag$ = param1$
                        
                     Case "Window", "Web", "Frame",
                          "Text", "String", "Button", "CheckBox", 
                          "ExplorerCombo", "ExplorerList", "ExplorerTree", "Image", "ButtonImage"
                        flag$ = param2$
                        
                     Case "Track", "Progress", "TrackBar", "ProgressBar", 
                          "Spin", "OpenGL", "Splitter", "MDI", "Canvas"
                        flag$ = param3$
                        
                     Case "Scroll", "ScrollBar", "ScrollArea", "HyperLink", "ListIcon"  
                        flag$ = param4$
                        
                  EndSelect
                  
                  ; flag
                  If flag$
                     flags = MakeFlag(Flag$)
                  EndIf
                  
                  ; window parent ID
                  If \func$ = "Window"
                     If param3$
                        *Parent = MakeObject( param3$ )
                        If Not *Parent
                           Debug "window ParentID"
                           *Parent = ide_design_panel_MDI
                        EndIf
                     Else
                        *Parent = ide_design_panel_MDI
                     EndIf

                     x$ = Str(Val(x$)+10)
                     y$ = Str(Val(y$)+10)
                  EndIf
                  
                  *new = widget_Create( *parent, \func$, Val(x$), Val(y$), Val(width$), Val(height$), text$, param1, param2, param3, flags )
                  
                  If *new
                     ;          If \func$ = "Panel"
                     ;             RemoveItem( *new, 0 )
                     ;             ; ClearItems( *new )
                     ;          EndIf
                     ;             If flag$
                     ;                SetFlagsString( *new, flag$ )
                     ;             EndIf
                     
                     If \id$
                        SetClass( *new, UCase(\id$) )
                     EndIf
                     
                     SetText( *new, text$ )
                     
                     ;
                     If IsContainer( *new ) > 0
                        *Parent = *new
                     EndIf
                     
                     ; 
                     ide_addline( *new )
                     result = 1
                  EndIf
                  
               Case "SetGadgetColor"
                  \id$ = Trim( StringField( arg$, 1, "," ))
                  Define ID = MakeObject( \id$ )
                  
                  param1$ = Trim( StringField( arg$, 2, "," ))
                  ;param2$ = Trim( StringField( arg$, 3, "," ))
                  
                  Debug ""+\id$ +" "+ ID ; +" "+ StringField( arg$, 1, "," );arg$
                  
                  If ID
                     SetColor( ID, MakeConstants( param1$ ), MakeFunc( arg$, 3 ))
                  EndIf
                  
               Case "CloseGadgetList"
                  If Not *parent
                     Debug "ERROR "+\func$
                     ProcedureReturn 
                  EndIf
                  *Parent = GetParent( *Parent )
                  ; CloseList( ) 
                  
               Case "AddGadgetItem"
                  If *parent
                     ; AddGadgetItem(#Gadget , Position , Text$ [, ImageID [, Flags]])
                     
                     \id$ = Trim( StringField( arg$, 1, "," ))
                     ID = MakeObject( \id$ ) 
                     param1$ = Trim( StringField( arg$, 2, "," ))
                     param2$ = Trim( StringField( arg$, 3, "," ))
                     param3$ = Trim( StringField( arg$, 4, "," ))
                     flag$ = Trim( StringField( arg$, 5, "," ))
                     ;
                     If param1$ = "- 1" Or 
                        param1$ = "-1"
                        param1 = - 1
                     Else
                        param1 = Val(param1$)
                     EndIf
                     text$ = Trim( param2$, Chr('"'))
                     param3 = Val(param3$)
                     Flags = MakeFlag( flag$ )
                     
                     
                     ;          Select Asc(\id$)
                     ;             Case '0' To '9'
                     ;                \id$ = "#" + \func$ +"_"+ \id$
                     ;          EndSelect
                     
                     ;
                     If ID
                        AddItem( ID, param1, text$, param3, Flags )
                        
                        If IsContainer( ID ) > 0
                           *parent = ID 
                           If Not *parent
                              Debug "ERROR " + \func$ +" "+ \id$ 
                              ProcedureReturn 
                           EndIf
                        EndIf
                     EndIf
                  EndIf
                  
            EndSelect
         EndWith
      EndIf
      
       ; Mid( String$, arg_start+arg_stop + 1 )
      ; если строка такого ввида "containergadget() : closegadgetlist()" 
      Define lines$ = Trim( Mid( String$, arg_start+arg_stop + 1 ), ":" )
      If lines$
         MakeLine( lines$, findtext$ )
      EndIf
      
      ProcedureReturn result
      ; Debug "["+start +" "+ stop +"] " + Mid( str$, start, stop ) ;+" "+ str$ ; arg$
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
               ; Properties_Updates( a_focused( ), "Delete" )
            EndIf
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
   Protected *new._s_widget
   ; flag.i | #__flag_NoFocus
   Protected newtype$
     
   If *parent > 0 
      OpenList( *parent, CountItems( *parent ) - 1 )
      type$ = LCase( Trim( type$ ) )
      
      ; defaul width&height
      If type$ = "scrollarea" Or
         type$ = "container" Or
         type$ = "panel"
         
         If Width = #PB_Ignore
            Width = 200
         EndIf
         If Height = #PB_Ignore
            Height = 150
         EndIf
         
         If Param3 = 0
            If type$ = "scrollarea"
               Param1 = Width
               Param2 = Height
               Param3 = 5
            EndIf
         EndIf
         
      Else
         If Width = #PB_Ignore
            Width = 100
         EndIf
         If Height = #PB_Ignore
            Height = 30
         EndIf
      EndIf
      
      ; create elements
      Select type$
         Case "window"    
            If Type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, text$, - 1, flag | #__window_NoActivate )
               Resize( *new, X, Y, Width, Height )
            Else
               flag | #__window_systemmenu | #__window_maximizegadget | #__window_minimizegadget | #__window_NoActivate
               *new = Window( X,Y,Width,Height, text$, flag, *parent )
            EndIf
            
         Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Param1, Param2, Param3, flag ) : CloseList( ) ; 1 
         Case "container"   : *new = Container( X,Y,Width,Height, flag ) : CloseList( )
         Case "panel"       : *new = Panel( X,Y,Width,Height, flag ) : CloseList( )
            
         Case "button"        : *new = Button(       X, Y, Width, Height, text$, flag ) 
         Case "string"        : *new = String(       X, Y, Width, Height, text$, flag )
         Case "text"          : *new = Text(         X, Y, Width, Height, text$, flag )
         Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, text$, flag ) 
            ; Case "web"           : *new = Web(          X, Y, Width, Height, text$, flag )
         Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, text$, flag )                                                                          
         Case "frame"         : *new = Frame(        X, Y, Width, Height, text$, flag )                                                                                  
            
            ; Case "date"          : *new = Date(         X, Y, Width, Height, text$, Param1, flag )         ; 2            
         Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, text$, Param1, flag )                                                          
         Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, text$, Param1, flag )                                                       
            
         Case "scroll"        : *new = Scroll(       X, Y, Width, Height, Param1, Param2, Param3, flag )  ; bar                                                             
            
         Case "progress"      : *new = Progress(     X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                           
         Case "track"         : *new = Track(        X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                                           
         Case "spin"          : *new = Spin(         X, Y, Width, Height, Param1, Param2, flag )                                                                             
         Case "splitter"      : *new = Splitter(     X, Y, Width, Height, Param1, Param2, flag )                                                                         
         Case "mdi"           : *new = MDI(          X, Y, Width, Height, flag )  ;  , Param1, Param2                                                                          
         Case "image"         : *new = Image(        X, Y, Width, Height, Param1, flag )                                                                                                     
         Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, Param1, flag )                                                                                                 
            
            ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
            
         Case "listview"      : *new = ListView(     X, Y, Width, Height, flag )                                                                                                                       
         Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, flag ) 
         Case "editor"        : *new = Editor(       X, Y, Width, Height, flag )                                                                                                                          
         Case "tree"          : *new = Tree(         X, Y, Width, Height, flag )                                                                                                                            
            ; Case "canvas"        : *new = Canvas(       X, Y, Width, Height, flag )                                                                                                                          
            
         Case "option"        : *new = Option(       X, Y, Width, Height, text$ )
            ; Case "scintilla"     : *new = Scintilla(    X, Y, Width, Height, Param1 )
            ; Case "shortcut"      : *new = Shortcut(     X, Y, Width, Height, Param1 )
         Case "ipaddress"     : *new = IPAddress(    X, Y, Width, Height )
            
      EndSelect
      
      If *new
         ; Debug ""+*parent\class +" "+ *new\class
         ;\\ первый метод формирования названия переменной
         newtype$ = type$+"_"+CountType( *new )
         
         ;\\ второй метод формирования названия переменной
         ;          If *parent = ide_design_panel_MDI
         ;             newtype$ = Class( *new )+"_"+CountType( *new , 2 )
         ;          Else
         ;             newtype$ = Class( *parent )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
         ;          EndIf
         ;\\
         SetClass( *new, UCase(newtype$) )
         SetText( *new, newtype$ )
         
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
               
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (14))
               EndIf
               SetBackgroundColor( *new, $FFECECEC )
               ;
               Properties_Updates( *new, "Resize" )
               Bind( *new, @widget_events( ) )
            Else
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (10))
               EndIf
               SetBackgroundColor( *new, $FFF1F1F1 )
            EndIf  
         Else
            If Not flag & #__flag_NoFocus 
               a_set(*new, #__a_full)
            EndIf
         EndIf
         
         Bind( *new, @widget_events( ), #__event_Resize )
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure widget_add( *parent._s_widget, Class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag = 0 )
   Protected *new._s_widget
   ; flag.i | #__flag_NoFocus
   
   If *parent 
      ; OpenList( *parent, CountItems( *parent ) - 1 )
      *new = widget_Create( *parent, Class.s, X,Y, Width, Height, "", 0,100,0, flag )
      
      If *new
         If LCase(Class.s) = "panel"
            AddItem( *new, -1, Class.s+"_item_0" )
         EndIf
         
         ide_addline( *new )
      EndIf
      ; CloseList( )
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure widget_events( )
   Protected *new
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Select __event 
      Case #__event_Free
         Protected item = GetData(*g) 
         RemoveItem( ide_inspector_view, item ) 
         
         ;
         DeleteMapElement( GetObject( ), RemoveString( GetClass(*g), "#"+ClassFromType(Type(*g))+"_" ))
         ;
      
         ; Debug "free "+item
         ; ProcedureReturn 0
         
      Case #__event_RightDown
         Debug "right"
         
      Case #__event_Down
         If a_focused( ) = *g
            If GetActive( ) <> ide_inspector_view 
               SetActive( ide_inspector_view )
               Debug "------------- active "+GetClass(GetActive( ))
            EndIf
         EndIf
         
      Case #__event_LostFocus
         If a_focused( ) = *g
            ; Debug "LOSTFOCUS "+GetClass(*g)
            SetState( ide_inspector_view, - 1 )
         EndIf
         
      Case #__event_Focus
         If a_focused( ) = *g
            ; Debug "FOCUS "+GetClass(*g)
            
            If GetData(*g) >= 0
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, GetData(*g) )
               EndIf
               SetState( ide_inspector_view, GetData(*g) )
            EndIf
            
            Properties_Updates( a_focused( ), "Focus" )
         EndIf
         
      Case #__event_Resize
         If a_focused( ) = *g
            Properties_Updates( a_focused( ), "Resize" )
         EndIf
         
      Case #__event_DragStart
         If is_drag_move( )
            If DragDropPrivate( #_DD_reParent )
               ChangeCurrentCursor( *g, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer(*g) 
               If MouseEnter(*g)
                  If Not a_index( )
                     If GetState( ide_inspector_elements) > 0 
                        If DragDropPrivate( #_DD_CreateNew )
                           ChangeCurrentCursor( *g, #PB_Cursor_Cross )
                        EndIf
                     Else
                        If DragDropPrivate( #_DD_Group )
                           ChangeCurrentCursor( *g, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_Drop
         Select DropPrivate( )
            Case #_DD_Group
               Debug " ----- DD_group ----- " + GetClass(*g)
               
               ;             Case #_DD_reParent
               ;                Debug " ----- DD_move ----- " +GetClass(Pressed( )) +" "+ Entered(  )\class
               ;                If SetParent( Pressed( ), Entered(  ) )
               ;                   Protected i = 3 : Debug "re-parent "+ GetClass(Pressed( )\parent) +" "+ Pressed( )\x[i] +" "+ Pressed( )\y[i] +" "+ Pressed( )\width[i] +" "+ Pressed( )\height[i]
               ;                EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( ide_inspector_elements ) +" "+ DropX( ) +" "+ DropY( ) +" "+ DropWidth( ) +" "+ DropHeight( )
               widget_add( *g, GetText( ide_inspector_elements ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( Pressed( ) )
               
               ;            *new = widget_add( *g, GetClass( Pressed( ) ), 
               ;                         X( Pressed( ) ), Y( Pressed( ) ), Width( Pressed( ) ), Height( Pressed( ) ) )
               
               *new = widget_add( *g, DropText( ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               SetText( *new, "Copy_"+ DropText( ) )
               
         EndSelect
         
      Case #__event_LeftDown
         If IsContainer(*g)
            If mouse( )\selector
               If GetState( ide_inspector_elements) > 0 
                  mouse( )\selector\dotted = 0
               EndIf
            EndIf
         EndIf
         
      Case #__event_LeftUp
         ; then group select
         If IsContainer(*g)
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
            If IsContainer(*g) 
               If GetState( ide_inspector_elements ) > 0 
                  If __event = #__event_MouseLeave
                     ResetCursor(*g) 
                  EndIf
                  If __event = #__event_MouseEnter
                     ; SetCursor( *g, #__Cursor_Cross, 1 )
                     SetCursor( *g, Cursor::Create( ImageID( GetItemData( ide_inspector_elements, GetState( ide_inspector_elements ) ) ) ), 1 )
                     
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
   EndSelect
   
   ;
   If  __event = #__event_LeftUp
      If IsContainer(*g)
         If GetState( ide_inspector_elements) > 0
            widget_add( *g, GetText( ide_inspector_elements ), GetMouseX( ) - X(*g, #__c_inner), GetMouseY( ) - Y(*g, #__c_inner))
         EndIf
      EndIf
      
      If keyboard( )\key[1]
         ProcedureReturn #PB_Ignore
      EndIf
   EndIf
   
   ;\\
   If __event = #__event_Drop  Or 
      __event = #__event_RightUp Or
      __event = #__event_LeftUp
      
      ; end new create
      If GetState( ide_inspector_elements ) > 0 
         SetState( ide_inspector_elements, 0 )
         
         ; ChangeCursor( *g, GetCursor(*g))
         If ResetCursor(*g) 
         EndIf
      EndIf
   EndIf
   
   ; отключаем дальнейшую обработку всех событий
   ; а также события кнопок окна (Close, Maximize, Minimize)
   ProcedureReturn #PB_Ignore
EndProcedure

;-
#File = 0
Procedure   ide_NewFile( )
   ; удаляем всех детей MDI
   Delete( ide_design_panel_MDI )
   ; Очишаем текст
   ClearItems( ide_design_DEBUG ) 
   ; затем создаем новое окно
   ide_design_form = widget_add( ide_design_panel_MDI, "window", 7, 7, 400, 250 )
   
   ; и показываем гаджеты для добавления
   SetState( ide_design_panel, 0 )
   SetState( ide_inspector_panel, 0 )
   
   If Not Hide( ide_design_panel_CODE )
      SetText( ide_design_panel_CODE, GeneratePBCode( ide_design_panel_MDI ) )
      ;                SetActive( ide_design_panel_CODE )
   EndIf
   ; SetText( ide_design_DEBUG, GeneratePBCode( ide_design_panel_MDI ) )
   
EndProcedure

Procedure   ide_OpenFile(Path$) ; Открытие файла
   Protected Text$, String$
   
   If Path$
      ClearDebugOutput( )
      ClearItems( ide_design_DEBUG )
      Debug "Открываю файл '"+Path$+"'"
      ;
      SetState( ide_design_panel, 0 )
      SetState( ide_inspector_panel, 0 )
      ;
      Delete( ide_design_panel_MDI )
      ReDraw( GetRoot( ide_design_panel_MDI ))   
      
      If ReadFile( #File, Path$ ) ; Если файл можно прочитать, продолжаем...
         Define Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         FileSeek( #File, 0 ) ; 
         
         While Eof( #File ) = 0 ; Цикл, пока не будет достигнут конец файла. (Eof = 'Конец файла')
            String$ = ReadString( #File ) ; Построчный просмотр содержимого файла
            
            MakeLine( String$, Text$ )
         Wend

;          
;          ForEach *parser\Line()
;             Debug *parser\Line()\func$ +"?"+ *parser\Line()\arg$
;          Next
         
         ;          ;          ;
         ;          ;          Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         ;          
         ;          ; bug hides
         ;          If Not Hide( ide_design_panel_CODE )
         ;             SetText( ide_design_panel_CODE, GeneratePBCode( ide_design_panel_MDI ) )
         ;             ;                SetActive( ide_design_panel_CODE )
         ;          EndIf
         
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

Procedure   ide_SaveFile(Path$) ; Процедура сохранения файла
   Protected Space$, Text$
   Protected len, Length, Position, Object
   
   If Path$
      ClearDebugOutput()
      Debug "Сохраняю файл '"+Path$+"'"
      
      ;
      If #PB_MessageRequester_Yes = Message("Как вы хотите сохранить",
                                                    " Нажмите OK чтобы сохранить PUREBASIC код"+#LF$+
                                                    " Нажмите NO чтобы сохранить WIDGET коде", #PB_MessageRequester_YesNo)
         Text$ = GeneratePBCode( ide_design_panel_MDI )
      Else
         Text$ = GetText( ide_design_panel_CODE )
      EndIf
      
      ;
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

Procedure ide_menu_events( *g._s_WIDGET, BarButton )
   Protected transform, move_x, move_y
   Static NewList *copy._s_a_group( )
   
   ; Debug "ide_menu_events "+BarButton
   
   Select BarButton
      Case #_tb_group_select
         If Type(*g) = #__type_ToolBar
            If GetItemState( *g, BarButton )  
               ; group
               group_select = *g
               ; SetAtributte( *g, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         Else
            If GetState(*g)  
               ; group
               group_select = *g
               ; SetAtributte( *g, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         EndIf
         
         ForEach a_group( )
            Debug a_group( )\widget\x
            
         Next
         
         
      Case #_tb_file_run
         Debug "run "+#PB_Compiler_Home
;          ;result = RunProgram(Filename$ [, Parameter$, WorkingDirectory$ [, Flags [, SenderProgram]]])
;         Define  Compiler = RunProgram(#PB_Compiler_Home+"/PureBasic.exe", "/EXE "+GetText( ide_design_panel_CODE ), "", #PB_Program_Open | #PB_Program_Read)
;         Debug Compiler
        
      Case #_tb_file_new
         ide_NewFile( )
         
      Case #_tb_file_open
         Protected StandardFile$, Pattern$, File$
         StandardFile$ = "open_example.pb" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = OpenFileRequester("Пожалуйста выберите файл для загрузки", StandardFile$, Pattern$, 0)
         
         SetWindowTitle( EventWindow(), File$ )
         
         If Not ide_OpenFile( File$ )
            Message("Информация", "Не удалось открыть файл.")
         EndIf
         
      Case #_tb_file_save
         StandardFile$ = "save_example.pbf" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = SaveFileRequester("Пожалуйста выберите файл для сохранения", StandardFile$, Pattern$, 0)
         
         If Not ide_SaveFile( File$ )
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
         ;          DisplayPopupBar(*g)
         
   EndSelect
   
EndProcedure

Procedure ide_events( )
   Protected *this._s_widget
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   ; Debug ""+ClassFromEvent(__event) +" "+ GetClass(*g)
   
   Select __event
      Case #__event_Close
         If *g = ide_root
            If #PB_MessageRequester_Yes = Message( "Message", 
                                                   "Are you sure you want to go out?",
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn #PB_All
            Else
               ProcedureReturn #False ; no close
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *g = ide_inspector_elements
            If __item >= 0
               SetState( *g, __item)
               
               Debug " ------ drag ide_events() ----- "
               If DragDropPrivate( #_DD_CreateNew )
                  ChangeCurrentCursor( *g, Cursor::Create( ImageID( GetItemData( *g, __item ) ) ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If __item = - 1
            SetText( ide_inspector_HELP, "help for the inspector" )
         Else
            If __data < 0
               If *g = ide_inspector_view
                  ; Debug ""+__data+" i "+__item
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_elements
                  SetText( ide_inspector_HELP, Help_elements(GetItemText( *g, __item )) )
               EndIf
               If *g = ide_inspector_properties
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_events
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Change
         If *g = ide_inspector_view
            a_set( GetItemData( *g, GetState(*g) ))
         EndIf
         
         If *g = ide_design_panel
            If __item = 1
               AddItem( ide_design_panel_CODE, 0, "" ) ; BUG 
               SetText( ide_design_panel_CODE, GeneratePBCode( ide_design_panel_MDI ) )
               SetActive( ide_design_panel_CODE )
            EndIf
         EndIf
         
      Case #__event_Left2Click
         ; Debug "2click"
         If a_focused( )
            If IsContainer(a_focused( ))
               If GetState( ide_inspector_elements) > 0
                  Static _x_, _y_
                  widget_add( a_focused( ), GetText( ide_inspector_elements ), _x_ + mouse( )\steps, _y_ + mouse( )\steps, #PB_Ignore, #PB_Ignore, #__flag_NoFocus )
                  ;a_set( a_focused( )\parent )
                  _x_ + mouse( )\steps
                  _y_ + mouse( )\steps
                  SetState( ide_inspector_elements, 0 )
               EndIf
            EndIf  
         EndIf  
         
      Case #__event_LeftClick 
         ; ide_menu_events( *g, __item )
         
         ; Debug *g\TabEntered( )
         
         If *g\TabEntered( )
            ide_menu_events( *g, *g\TabEntered( )\index )
         Else
            If Type(*g) = #__type_toolbar
               ide_menu_events( *g, GetData(*g) )
            EndIf
         EndIf
         
   EndSelect
   
   ;-\\ EDIT CODE EVENTS
   If *g = ide_design_panel_CODE                      Or *g = ide_design_DEBUG ; TEMP
      Static argument, object  
      Protected name$, text$, len, caret
      Protected *line._s_ROWS
      
      ;
      If __event = #__event_Down
         If __data
            *line._s_ROWS  = __data
            text$ = *line\text\string
            len = *line\text\len
            caret = *g\text\caret\pos[1] - *line\text\pos
            
            ;
            If text$
               *g\text\numeric = 0 
               *g\text\editable = 0 
               
               name$ = *g\text\caret\word ; GetWord( text$, len, caret ) 
               
               If name$
                  object = MakeObject( name$ )
                  If Not object
                     If CountString( text$, "=" )
                        name$ = Trim( StringField( text$, 1, "=" ))
                        If CountString( name$, " " )
                           name$ = Trim( StringField( name$, 2, " " ))
                        EndIf
                     EndIf
                     
                     object = MakeObject( name$ )
                  EndIf
               EndIf
               
               ;
               If object
                  
                  ;argument =  CountString( Left( text$, caret ), "," ) + 1 
                  argument = GetArgIndex( text$, len, caret ) 
                  name$ = *g\text\caret\word
                  If name$ <> GetClass( object )
                     If CountString( text$, "(" )
                        name$ = Trim( StringField( text$, 1, "(" ))
                        name$ = GetWord( name$, Len( name$ ), Len( name$ ) ) 
                     EndIf
                  EndIf
                  If argument
                     If name$ = ClassFromType( Type( object ))
                        argument + 1
                     EndIf
                     If name$ = GetClass( object )
                        argument - 1
                     EndIf
                  EndIf
                  
                  Debug "?"+ argument +" "+ name$
                  
                  If argument > 1
                     If argument < 6 ; coordinate
                        *g\text\numeric = 1 
                     EndIf
                     *g\text\editable = 1 
                  EndIf
                  
                  If GetClass( object ) = *g\text\caret\word ; GetWord( text$, len, caret )
                     *g\text\editable = 1
                     *g\text\upper = 1 
                  Else
                     *g\text\upper = 0 
                  EndIf
               EndIf
               
               If *g\text\editable
                  *line\color\back[1] = *g\color\back[1]
               Else
                  *line\color\back[1] = $CD9CC3EE
               EndIf
            EndIf
         EndIf
      EndIf
      
      ;
      If __event = #__event_Change
         If object
            ReplaceArg( object, argument, *g\text\caret\word ) 
            ; ReplaceArg( object, argument, GetWord( *line\text\string, *line\text\len, *g\text\caret\pos[1] - *line\text\pos )  )
         EndIf
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
   BarItem( #_tb_file_new, "New" + Space(9) + Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_open, "Open" + Space(9) + Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_save, "Save" + Space(9) + Chr(9) + "Ctrl+S")
   BarItem( #_tb_file_save_as, "Save as...")
   BarSeparator( )
   BarItem( #_tb_file_quit, "Quit" );+ Chr(9) + "Ctrl+Q")
   CloseSubBar( )
   ;
   BarSeparator( )
   BarItem( #_tb_file_new, "New" )
   BarItem( #_tb_file_open, "Open" )
   BarItem( #_tb_file_save, "Save" )
   BarSeparator( )
   BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
   BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
   BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
   BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
   BarSeparator( )
   BarItem( #_tb_file_run, "[RUN]" )
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
;    BarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
;    BarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
;    BarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
;    BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
;    BarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
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
   ;ide_inspector_events = Tree( 0,0,0,0, #__flag_autosize | #__flag_borderless ) : SetClass(ide_inspector_events, "ide_inspector_events" ) 
   ide_inspector_events = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_borderless ) : SetClass(ide_inspector_properties, "ide_inspector_properties" )
   If ide_inspector_events
      Properties_AddItem( ide_inspector_events, #_ei_leftclick,  "LeftClick", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_change,  "Change", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_enter,  "Enter", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_leave,  "Leave", #__Type_ComboBox )
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
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Down )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Up )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Change )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_StatusChange )
   ; TEMP
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Down )
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
   Bind( ide_inspector_elements, @ide_events( ), #__event_Left2Click )
   Bind( ide_inspector_elements, @ide_events( ), #__event_LeftClick )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseEnter )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseLeave )
   Bind( ide_inspector_elements, @ide_events( ), #__event_DragStart )
   ;
   ;
   Bind( ide_root, @ide_events( ), #__event_Close )
   
   ;Bind( #PB_All, @ide_events( ) )
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
      Define cont1 = widget_add( ide_design_form, "container", 10, 10, 320, 180 )
      SetBackgroundColor( cont1, $FF9CF9F6)
      widget_add( cont1, "button", 10, 20, 100, 30 )
      Define cont2 = widget_add( cont1, "container", 130, 20, 90, 140 )
      widget_add( cont2, "button", 10, 20, 30, 30 )
      Define cont3 = widget_add( cont1, "container", 230, 20, 90, 140 )
      widget_add( cont2, "button", 10, 20, 30, 30 )
      
      ;       ClearItems(ide_inspector_view)
      ; ;       AddItem(ide_inspector_view, -1, "window_0", -1, 0)
      ; ;       AddItem(ide_inspector_view, -1, "button_0", -1, 1)
      ; ;       AddItem(ide_inspector_view, -1, "container_0", -1, 1)
      ; ;       AddItem(ide_inspector_view, -1, "button_1", -1, 2)
      ; ;       
      ;       Define *parent._s_WIDGET = ide_design_panel_MDI
      ;       ;PushListPosition(widgets())
      ;       If StartEnum( *parent ,0)
      ;          Debug "99 "+ GetClass(widget()) +" "+ GetClass(widget()\parent) +" "+ Str(Level(widget()))+" "+Str(Level(*parent));IsChild(widget(), *parent )
      ;          Select CountItems(ide_inspector_view)
      ;             Case 0 
      ;                AddItem(ide_inspector_view, -1, "window_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 1 
      ;                AddItem(ide_inspector_view, -1, "button_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 2 
      ;                AddItem(ide_inspector_view, -1, "container_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 3 
      ;                AddItem(ide_inspector_view, -1, "button_1", -1, Level(widget())-Level(*parent)-1)
      ;          EndSelect
      ;          
      ;          ;   Debug CountItems(ide_inspector_view)-1
      ;          SetData(widget(), CountItems(ide_inspector_view)-1)
      ;          SetItemData(ide_inspector_view, CountItems(ide_inspector_view)-1, widget())
      ;          
      ;          StopEnum()
      ;       EndIf
      ;       ;PopListPosition(widgets())
      
      ;\\ example 2
      ;       Define *container = widget_add( ide_design_form, "container", 130, 20, 220, 140 )
      ;       widget_add( *container, "button", 10, 20, 30, 30 )
      ;       widget_add( ide_design_form, "button", 10, 20, 100, 30 )
      ;       
      ;       Define item = 1
      ;       SetState( ide_inspector_view, item )
      ;       If IsGadget( ide_g_code )
      ;          SetGadgetState( ide_g_code, item )
      ;       EndIf
      ;       Define *container2 = widget_add( *container, "container", 60, 10, 220, 140 )
      ;       widget_add( *container2, "button", 10, 20, 30, 30 )
      ;       
      ;       SetState( ide_inspector_view, 0 )
      ;       widget_add( ide_design_form, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      Resize(ide_design_form, #PB_Ignore, #PB_Ignore, 500, 250)
      
      Disable(widget_add(ide_design_form, "button", 15, 25, 50, 30, #PB_Button_MultiLine),1)
      widget_add(ide_design_form, "text", 25, 65, 50, 30)
      btn2 = widget_add(ide_design_form, "button", 35, 65+40, 50, 30)
      widget_add(ide_design_form, "string", 45, 65+40*2, 50, 30)
      ;widget_add(ide_design_form, "button", 45, 65+40*2, 50, 30)
      
      Define *scrollarea = widget_add(ide_design_form, "scrollarea", 120, 25, 165, 175, #PB_ScrollArea_Flat )
      widget_add(*scrollarea, "button", 15, 25, 30, 30)
      widget_add(*scrollarea, "text", 25, 65, 50, 30)
      widget_add(*scrollarea, "button", 35, 65+40, 80, 30)
      widget_add(*scrollarea, "text", 45, 65+40*2, 50, 30)
      
      Define *panel = widget_add(ide_design_form, "panel", 320, 25, 165, 175)
      widget_add(*panel, "button", 15, 25, 30, 30)
      widget_add(*panel, "text", 25, 65, 50, 30)
      widget_add(*panel, "button", 35, 65+40, 80, 30)
      widget_add(*panel, "text", 45, 65+40*2, 50, 30)
      
      AddItem( *panel, -1, "panel_item_1" )
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
   
   a_set( ide_design_form )
   Define code$ = GenerateGUICODE( ide_design_panel_MDI )
   SetText( ide_design_DEBUG, code$ )
   
   ;Define code$ = GeneratePBCode( ide_design_panel_MDI )
   ; SetText( ide_design_panel_CODE, code$ )
   ;SetText( ide_design_DEBUG, code$ )
   
   ;SetState( ide_design_panel, 1 )
   
   If SetActive( ide_inspector_view )
      SetActiveGadget( ide_g_canvas )
   EndIf
   
   ;\\ 
   WaitClose( )
CompilerEndIf


;\\ include images
DataSection   
   IncludePath #ide_path + "ide/include/images"
   
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
; CursorPosition = 260
; FirstLine = 251
; Folding = -----------------------dDs----------------------------
; Optimizer
; EnableAsm
; EnableXP
; DPIAware
; Executable = ..\widgets-ide.app.exe