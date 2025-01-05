;- 
#IDE_path = "../"
XIncludeFile #IDE_path + "widgets.pbi"
;XIncludeFile #IDE_path + "test.pbi"
;
EnableExplicit
;
UseWidgets( )
UsePNGImageDecoder( )
;test_docursor = 1
;test_changecursor = 1
;test_setcursor = 1
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
       ide_design_panel, 
       ide_design_MDI,
       ide_design_code

Global ide_debug_splitter, 
       ide_debug_view 

Global ide_inspector_view_splitter, 
       ide_inspector_view, 
       ide_inspector_panel,
       ide_inspector_elements,
       ide_inspector_properties, 
       ide_inspector_events

Global ide_inspector_panel_splitter,
       ide_help_view

Global group_select
Global group_drag


Global img = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" ) 

;-
;- PUBLICs
;-
Procedure.s StrBool( state )
   If state > 0
      ProcedureReturn "True"
   ElseIf state = 0
      ProcedureReturn "False"
   EndIf
EndProcedure

Procedure StatusChange( *this._s_WIDGET, item )
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

Procedure ChangeEditPropertiesItem( *inspector._s_WIDGET )
   Protected *second._s_WIDGET = GetAttribute(*inspector, #PB_Splitter_SecondGadget)
   If *second And *second\RowFocused( )
      Protected *this._s_WIDGET = *second\RowFocused( )\data
      If *this
         Select Type( *this )
            Case #__type_Spin     : SetState(*this, Val(*second\RowFocused( )\text\string) )
            Case #__type_String   : SetText(*this, *second\RowFocused( )\text\string )
            Case #__type_ComboBox : SetState(*this, Val(*second\RowFocused( )\text\string) )
         EndSelect
      EndIf
   EndIf
EndProcedure

Procedure ResizeEditPropertiesItem( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      ;
      If *this
         Resize(*this,
                *row\x + *second\scroll_x( ),; +30, 
                *row\y + *second\scroll_y( ), 
                *row\width,;*second\inner_width( ),;; -30, 
                *row\height, 0 )
      EndIf
   EndIf
EndProcedure

Procedure CreateEditPropertiesItem( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   Static *last._s_WIDGET
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      
      If *this And *last <> *this
         If *last 
            Hide( *last, #True )
         EndIf
         
         *last = *this
         
         ;\\ show widget
         Hide( *this, #False )
         Select Type( *this )
            Case #__type_String
               SetText( *this, (*row\text\string) )
               
            Case #__type_Spin
               SetState( *this, Val(*row\text\string) )
               
            Case #__type_ComboBox
;                Select *row\text\string
;                   Case "false" : SetState( *this, 0)
;                   Case "true"  : SetState( *this, 1)
;                EndSelect
               
                                     Select GetData( *this ) 
                                        Case #_pi_disable : SetState( *this, Disable( a_focused( ) ))
                                        Case #_pi_hide    : SetState( *this, Hide( a_focused( ) ))
                                     EndSelect
               
               
         EndSelect
         
         ResizeEditPropertiesItem( *this\parent )
      EndIf
   EndIf
   
   ProcedureReturn *last
EndProcedure

;-
Procedure PropertiesEvents( )
   Protected *splitter._s_WIDGET = EventWidget( )\parent
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   Static *this._s_WIDGET
   
   
   Select WidgetEvent( )
      Case #__event_Up
;          If mouse( )\drag
;             If EventWidget( ) = *first Or
;                EventWidget( ) = *second 
;                
;                *this = CreateEditPropertiesItem( *second )
;             EndIf
;          EndIf
         
      Case #__event_Down
         If EventWidget( ) = *first Or
            EventWidget( ) = *second 
            ; 
            SetState( EventWidget( ), WidgetEventItem( ))
         Else
            Select Type( EventWidget( ))
               Case #__type_Spin     : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), Str(GetState(EventWidget( ))) )
               Case #__type_String   : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), GetText(EventWidget( )) )
               Case #__type_ComboBox : SetItemText(EventWidget( )\parent, GetData(EventWidget( )), Str(GetState(EventWidget( ))) )
            EndSelect
         EndIf
         
      Case #__event_Change
         If EventWidget( ) = *first Or
            EventWidget( ) = *second 
            ;
            Select EventWidget( )
               Case *first : SetState(*second, GetState(EventWidget( )))
               Case *second : SetState(*first, GetState(EventWidget( )))
            EndSelect
            
            ; create EditPropertiesItem
            Select WidgetEventItem( )
               Case #_pi_group_0, #_pi_group_1, #_pi_group_2, #_pi_group_3
                  If *this 
                     Hide( *this, #True )
                  EndIf
                  
               Default
                  *this = CreateEditPropertiesItem( *second )
            EndSelect
         EndIf
      
         If *this = EventWidget( )
            Select Type( EventWidget( ) )
               Case #__type_String
                  Select GetData( EventWidget( ) ) 
                     Case #_pi_class  : SetClass( a_focused( ), GetText( EventWidget( ) ) )
                     Case #_pi_text   : SetText( a_focused( ), GetText( EventWidget( ) ) )
                  EndSelect
                  
               Case #__type_Spin
                  ; SetItemText( GetParent(EventWidget( )), GetData( EventWidget( ) ), Str(GetState( EventWidget( ) )))
                  Select GetData( EventWidget( ) ) 
                     Case #_pi_x      : Resize( a_focused( ), GetState( EventWidget( ) ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     Case #_pi_y      : Resize( a_focused( ), #PB_Ignore, GetState( EventWidget( ) ), #PB_Ignore, #PB_Ignore )
                     Case #_pi_width  : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, GetState( EventWidget( ) ), #PB_Ignore )
                     Case #_pi_height : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState( EventWidget( ) ) )
                  EndSelect
                  
               Case #__type_ComboBox
                  SetItemText( GetParent(EventWidget( )), GetData( EventWidget( ) ), StrBool(GetState( EventWidget( ) )))
                  ;
                  Select GetData( EventWidget( ) ) 
                     Case #_pi_disable : Disable( a_focused( ), GetState( EventWidget( ) ) )
                     Case #_pi_hide    : Hide( a_focused( ), GetState( EventWidget( ) ) )
                  EndSelect
                  
            EndSelect
            
         EndIf
         
         
      Case #__event_StatusChange
         If WidgetEventData( ) = #PB_Tree_Expanded Or
            WidgetEventData( ) = #PB_Tree_Collapsed
            ;
            If EventWidget( ) = *first
               If *this 
                  Hide( *this, Bool( WidgetEventData( ) = #PB_Tree_Collapsed ))
               EndIf
               ;
               SetItemState( *second, WidgetEventItem( ), WidgetEventData( ))
            EndIf
         EndIf
         
         Select EventWidget( ) 
            Case *first : StatusChange( *second, WidgetEventItem( ) )
            Case *second : StatusChange( *first, WidgetEventItem( ) )
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
               ;
               ResizeEditPropertiesItem( *second )
            EndIf
         EndIf
         
      Case #__event_resize
         If EventWidget( ) = *second
            ResizeEditPropertiesItem( *second )
         EndIf
         
         
   EndSelect
EndProcedure

Procedure AddItemProperties( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
   Protected *this._s_WIDGET
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
   AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
   
   item = CountItems( *first ) - 1
   Protected flag = #__flag_NoFocus | #__flag_Transparent ;| #__flag_child|#__flag_invert
   
   Select Type
      Case #__type_Spin
        ;*this = Create( *second, "Spin", #__type_Spin, 0, 0, 0, 0, #Null$, flag, - 2147483648, 2147483648, 0, #__bar_button_size, 0, 7 )
         Select item
            Case #_pi_x, #_pi_width
               *this = Create( *second, "Spin", #__type_Spin, 0, 0, 0, 0, #Null$, flag|#__flag_vertical|#__flag_invert, -1000, 1000, 0, #__bar_button_size, 0, 7 )
            Case #_pi_y, #_pi_height
               *this = Create( *second, "Spin", #__type_Spin, 0, 0, 0, 0, #Null$, flag, -1000, 1000, 0, #__bar_button_size, 0, 7 )
         EndSelect
         
         ;SetState( *this, Val(StringField(Text.s, 2, Chr(10))))
      Case #__type_String
         *this = Create( *second, "String", #__type_String, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
         ;*this = Create( *second, "String", #__type_String, 0, 0, 0, 0, StringField(Text.s, 2, Chr(10)), flag, 0, 0, 0, 0, 0, 0 )
      Case #__type_ComboBox
         *this = Create( *second, "ComboBox", #__type_ComboBox, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
         AddItem(*this, -1, "False")
         AddItem(*this, -1, "True")
         ; SetState(*this, 1)
   EndSelect
   
   If *this
      SetActive( *this )
      SetData(*this, item)
      Bind(*this, @PropertiesEvents( ), #__event_Change)
      Bind(*this, @PropertiesEvents( ), #__event_LostFocus)
   EndIf
   
   ; SetItemData(*first, item, *this)
   SetItemData(*second, item, *this)
EndProcedure

Procedure CreateProperties( X,Y,Width,Height, flag=0 )
   Protected position = 70
   Protected *first._s_WIDGET = Tree(0,0,0,0)
   Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines)
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   ;SetState(*splitter, width-position )
   
   *splitter\bar\button\size = DPIScaled(2)
   *splitter\bar\button\round = 0;  DPIScaled(1)
   
   SetClass(*first\scroll\v, "first_v")
   SetClass(*first\scroll\h, "first_h")
   
   SetClass(*second\scroll\v, "second_v")
   SetClass(*second\scroll\h, "second_h")
   
   Hide( *first\scroll\v, 1 )
   Hide( *first\scroll\h, 1 )
   Hide( *second\scroll\h, 1 )
   CloseList( )
   
   Bind(*first, @PropertiesEvents( ))
   Bind(*second, @PropertiesEvents( ))
   
   ; draw и resize отдельно надо включать пока
   Bind(*second, @PropertiesEvents( ), #__event_resize)
   ProcedureReturn *splitter
EndProcedure


Procedure.s GetItemTextProperties( *splitter._s_WIDGET, item )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   ProcedureReturn GetItemText( *first, item )
EndProcedure

Procedure SetItemTextProperties( *splitter._s_WIDGET, item, Text.s )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   SetItemText( *first, item, StringField(Text.s, 1, Chr(10)) )
   SetItemText( *second, item, StringField(Text.s, 2, Chr(10)) )
   ;ChangeEditPropertiesItem( *splitter )
            
   ProcedureReturn 
EndProcedure

;-
Macro properties_update_id( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_id,      GetItemTextProperties( _gadget_, #_pi_id )      +Chr( 10 )+Str( Index(_value_) - 25 ) )
EndMacro

Macro properties_update_text( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_text,    GetItemTextProperties( _gadget_, #_pi_text )    +Chr( 10 )+GetText( _value_ ) )
EndMacro

Macro properties_update_class( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_class,   GetItemTextProperties( _gadget_, #_pi_class )   +Chr( 10 )+UCase(GetText( _value_ ))); GetClass( _value_ )+"_"+CountType( _value_ ) )
EndMacro

Macro properties_update_hide( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_hide,    GetItemTextProperties( _gadget_, #_pi_hide )    +Chr( 10 )+StrBool( Hide( _value_ ) ) )
EndMacro

Macro properties_update_disable( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_disable, GetItemTextProperties( _gadget_, #_pi_disable ) +Chr( 10 )+StrBool( Disable( _value_ ) ) )
EndMacro

Macro properties_update_coordinate( _gadget_, _value_ )
   SetItemTextProperties( _gadget_, #_pi_x,       GetItemTextProperties( _gadget_, #_pi_x )       +Chr( 10 )+Str( X( _value_, #__c_container ) ) )
   SetItemTextProperties( _gadget_, #_pi_y,       GetItemTextProperties( _gadget_, #_pi_y )       +Chr( 10 )+Str( Y( _value_, #__c_container ) ) )
   SetItemTextProperties( _gadget_, #_pi_width,   GetItemTextProperties( _gadget_, #_pi_width )   +Chr( 10 )+Str( Width( _value_ ) ) )
   SetItemTextProperties( _gadget_, #_pi_height,  GetItemTextProperties( _gadget_, #_pi_height )  +Chr( 10 )+Str( Height( _value_ ) ) )
EndMacro

Macro properties_updates( _gadget_, _value_ )
   properties_update_id( _gadget_, _value_ )
   properties_update_class( _gadget_, _value_ )
   
   properties_update_text( _gadget_, _value_ )
   properties_update_coordinate( _gadget_, _value_ )
   
   properties_update_disable( _gadget_, _value_ )
   properties_update_hide( _gadget_, _value_ )
EndMacro


;-
Procedure.s FlagFromFlag( Type, flag.i ) ; 
   Protected flags.S
   
   Select Type
      Case #__Type_Text
         If flag & #__flag_TextCenter
            flags + "#PB_Text_Center | "
         EndIf
         If flag & #__flag_TextRight
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

Procedure$ add_line( *new._s_widget, Handle$ ) ; Ok
   Protected ID$, Result$, param1$, param2$, param3$, Text$, flag$
   
   flag$ = FlagFromFlag( *new\type, *new\flag )
   
   Select Asc( Handle$ )
      Case '#'        : ID$ = Handle$           : Handle$ = ""
      Case '0' To '9' : ID$ = Chr( Asc( Handle$ ) ) : Handle$ = ""
      Default         : ID$ = "#PB_Any"         : Handle$ + " = "
   EndSelect
   
   Text$ = Chr( 34 )+*new\text\string+Chr( 34 )
   
   If *new\class = "Window"
      Result$ = Handle$ +"Window( "+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
   Else
      ; type_$ = "Gadget( "+ID$+", "
      Result$ = Handle$ + *new\class +"( "+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
   EndIf
   
   Select *new\class
      Case "Window" : Result$ +", "+ Text$                                                                          
         If param1$ : Result$ +", "+ param1$ : EndIf 
         
      Case "ScrollArea"    : Result$ +", "+ param1$ +", "+ param2$    
         If param3$ : Result$ +", "+ param3$ : EndIf 
         
      Case "Calendar"      
         If param1$ : Result$ +", "+ param1$ : EndIf 
         If param1$ : Result$ +", "+ param1$ : EndIf 
         
      Case "Button"        : Result$ +", "+ Text$                                                                               
      Case "String"        : Result$ +", "+ Text$                                                                               
      Case "Text"          : Result$ +", "+ Text$                                                                                 
      Case "CheckBox"      : Result$ +", "+ Text$                                                                             
      Case "Option"        : Result$ +", "+ Text$
      Case "Frame"         : Result$ +", "+ Text$                                                                                
      Case "Web"           : Result$ +", "+ Text$
      Case "Date"          : Result$ +", "+ Text$              
      Case "ExplorerList"  : Result$ +", "+ Text$                                                                         
      Case "ExplorerTree"  : Result$ +", "+ Text$                                                                         
      Case "ExplorerCombo" : Result$ +", "+ Text$                                                                        
         
      Case "HyperLink"     : Result$ +", "+ Text$ +", "+ param1$                                                       
      Case "ListIcon"      : Result$ +", "+ Text$ +", "+ param1$                                                        
         
      Case "Image"         : Result$ +", "+ param1$   
      Case "Scintilla"     : Result$ +", "+ param1$
      Case "Shortcut"      : Result$ +", "+ param1$
      Case "ButtonImage"   : Result$ +", "+ param1$                                                                                             
         
      Case "TrackBar"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
      Case "Spin"          : Result$ +", "+ param1$ +", "+ param2$                                                                             
      Case "Splitter"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
      Case "MDI"           : Result$ +", "+ param1$ +", "+ param2$                                                                              
      Case "ProgressBar"   : Result$ +", "+ param1$ +", "+ param2$                                                                      
      Case "ScrollBar"     : Result$ +", "+ param1$ +", "+ param2$ +", "+ param3$                                                 
   EndSelect
   
   If flag$ : Result$ +", "+ flag$ : EndIf 
   
   Result$+" )" 
   
   ProcedureReturn Result$
EndProcedure

Procedure add_code( *new._s_widget, Class.s, Position.i, SubLevel.i )
   Protected code.s 
   
   ;   code = Space( ( *new\level-2 )*4 ) +
   ;          Class +" = "+ 
   ;          *new\class +"( " + 
   ;          *new\x +", "+
   ;          *new\y +", "+ 
   ;          *new\width +", "+ 
   ;          *new\height +", "+ 
   ;          *new\text\string +", "+ 
   ;          FlagFromFlag( *new\type, *new\flag )+
   ;          " )"
   
   code = Space( ( Level(*new)-Level(ide_design_MDI) )*5 ) + add_line( *new._s_widget, Class.s )
   
   ;   ForEach widget( )
   ;     If Child( widget( ), ide_design_MDI )
   ;       Debug widget( )\class
   ;     EndIf
   ;   Next
   
   If IsGadget( ide_g_code )
      AddGadgetItem( ide_g_code, Position, code )
   Else
      AddItem( ide_design_code, Position, code )
   EndIf
EndProcedure


;-
Declare widget_events( )

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


Procedure widget_data( ide_inspector_view, position, CountItems )
   Protected i
   
   If position =- 1
      For i = 0 To CountItems - 1
         SetData( GetItemData( ide_inspector_view, i ), i )
      Next  
   Else
      If CountItems > position
         For i = position To CountItems - 1
            SetData( GetItemData( ide_inspector_view, i ), i + 1 )
         Next 
      EndIf
   EndIf
EndProcedure

Macro widget_delete( )
;    If ListSize( a_group( ))
;       ForEach a_group( )
;          RemoveItem( ide_inspector_view, GetData( a_group( )\widget ) )
;          Free( a_group( )\widget )
;          DeleteElement( a_group( ) )
;       Next
;       
;       ClearList( a_group( ) )
;    Else
   RemoveItem( ide_inspector_view, GetData( a_focused( ) ) )
   
   Free( a_focused( ) )
   
   widget_data( ide_inspector_view, - 1, CountItems( ide_inspector_view ) )
   
   a_Set( GetItemData( ide_inspector_view, GetState( ide_inspector_view ) ) )
;    EndIf
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
   
   ForEach a_group( )
      Debug " group "+a_group( )\widget
   Next
   
   ;a_update( a_focused( ) )
EndMacro

Procedure widget_add( *parent._s_widget, class.s, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore )
   Protected *new._s_widget, *param1, *param2, *param3
   Protected is_window.b, flag.i = #__flag_NoFocus
   Protected newClass.s
   
   If *parent 
      OpenList( *parent, CountItems( *parent ) - 1 )
      class.s = LCase( Trim( class ) )
      
      ; defaul width&height
      If class = "scrollarea" Or
         class = "container" Or
         class = "panel"
         
         If Width = #PB_Ignore
            Width = 200
         EndIf
         If Height = #PB_Ignore
            Height = 150
         EndIf
         
         If class = "scrollarea"
            *param1 = Width
            *param2 = Height
            *param3 = 5
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
      Select class
         Case "window"    
            is_window = #True
            If Type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, "", - 1, flag )
               Resize( *new, #PB_Ignore, #PB_Ignore, Width,Height )
            Else
               flag | #__window_systemmenu | #__window_maximizegadget | #__window_minimizegadget
               *new = Window( X,Y,Width,Height, "", flag, *parent )
            EndIf
            
            SetColor( *new, #__color_back, $FFECECEC )
            Protected *imagelogo = CatchImage( #PB_Any,?group_bottom )
            CompilerIf #PB_Compiler_DPIAware
               ResizeImage(*imagelogo, DPIScaled(ImageWidth(*imagelogo)), DPIScaled(ImageHeight(*imagelogo)), #PB_Image_Raw)
            CompilerEndIf
            SetImage( *new, *imagelogo )
            Bind( *new, @widget_events( ) )
            
            ; на тот случай если изменили 
            ; формирование класса например "Window0;Window1"
            SetClass( *new, UlCase(class))
            
         Case "container"   
            *new = Container( X,Y,Width,Height, flag ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
         Case "panel"       
            *new = Panel( X,Y,Width,Height, flag ) : AddItem( *new, -1, class+"_item_0" ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
         Case "scrollarea"  
            *new = ScrollArea( X,Y,Width,Height, *param1, *param2, *param3, flag ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
         Case "splitter"    : *new = Splitter( X,Y,Width,Height, *param1, *param2, flag )
         Case "image"       : *new = Image( X,Y,Width,Height, img, flag )
         Case "buttonimage" : *new = ButtonImage( X,Y,Width,Height, img, flag )
         Case "progress"    : *new = Progress( X,Y,Width,Height, 0,100, flag ) 
         Case "button"      : *new = Button( X,Y,Width,Height, "", flag ) 
         Case "string"      : *new = String( X,Y,Width,Height, "", flag )
         Case "text"        : *new = Text( X,Y,Width,Height, "", flag )
      EndSelect
      
      If *new
         ;\\ первый метод формирования названия переменной
         newClass.s = class+"_"+CountType( *new )
         ;\\ второй метод формирования названия переменной
         ;         If *parent = ide_design_MDI
         ;           newClass.s = GetClass( *new )+"_"+CountType( *new , 1 )
         ;         Else
         ;           newClass.s = GetClass( *parent )+"_"+CountType( *parent )+"_"+GetClass( *new )+"_"+CountType( *new , 1 )
         ;         EndIf
         ;\\
         SetText( *new, newClass )
         
         ;
         If IsContainer( *new )
            EnableDDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
            ;           EnableDDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
            ;           EnableDDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
            ;           EnableDDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
            ;           EnableDDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
            If is_window
               a_set(*new, #__a_full, (14))
            Else
               a_set(*new, #__a_full, (10))
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
            If LCase(StringField( class.s, 1, "_" )) = LCase(GetItemText( ide_inspector_elements, i ))
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
   ;    Static *beforeWidget
   
   Select eventtype 
      Case #__event_RightDown
         Debug "right"
         
         ; disable window-toolbar-buttons events
      Case #__event_Close ;, #__event_Minimize, #__event_Maximize
         ProcedureReturn 1
         
       Case #__event_Down
         If a_focused( ) = *e_widget
            If GetData( *e_widget ) >= 0
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, GetData( *e_widget ) )
               EndIf
               SetState( ide_inspector_view, GetData( *e_widget ) )
            EndIf
            
            properties_updates( ide_inspector_properties, *e_widget )
            ChangeEditPropertiesItem( ide_inspector_properties )
            
            ; 
            If GetActive( ) <> ide_inspector_view 
               SetActive( ide_inspector_view )
               Debug "------------- active "+GetActive( )\class
            EndIf
         EndIf
         
      Case #__event_DragStart
;          ; 
;          If GetActive( ) <> ide_inspector_properties 
;             SetActive( ide_inspector_properties )
;             Debug "------------- active "+GetActive( )\class
;          EndIf
            
         If is_drag_move( )
            If DDragPrivate( #_DD_reParent )
               ChangeCurrentCursor( *e_widget, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer( *e_widget ) 
               If MouseEnter( *e_widget )
                  If Not a_index( )
                     If GetState( ide_inspector_elements) > 0 
                        If DDragPrivate( #_DD_CreateNew )
                           ChangeCurrentCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     Else
                        If DDragPrivate( #_DD_Group )
                           ChangeCurrentCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_Drop
         Select DDropPrivate( )
            Case #_DD_Group
               Debug " ----- DD_group ----- " + *e_widget\class
               
            Case #_DD_reParent
               Debug " ----- DD_move ----- " +PressedWidget( )\class +" "+ EnteredWidget( )\class
               If SetParent( PressedWidget( ), EnteredWidget( ) )
                  Protected i = 3 : Debug "re-parent "+ PressedWidget( )\parent\class +" "+ PressedWidget( )\x[i] +" "+ PressedWidget( )\y[i] +" "+ PressedWidget( )\width[i] +" "+ PressedWidget( )\height[i]
               EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( ide_inspector_elements ) +" "+ DDropX( ) +" "+ DDropY( ) +" "+ DDropWidth( ) +" "+ DDropHeight( )
               widget_add( *e_widget, GetText( ide_inspector_elements ), DDropX( ), DDropY( ), DDropWidth( ), DDropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( PressedWidget( ) )
               
               ;            *new = widget_add( *e_widget, GetClass( PressedWidget( ) ), 
               ;                         X( PressedWidget( ) ), Y( PressedWidget( ) ), Width( PressedWidget( ) ), Height( PressedWidget( ) ) )
               
               *new = widget_add( *e_widget, DDropText( ), DDropX( ), DDropY( ), DDropWidth( ), DDropHeight( ) )
               SetText( *new, "Copy_"+ DDropText( ) )
               
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
         
      Case #__event_Resize
         ; Debug ""+GetClass(*e_widget)+" resize"
         properties_update_coordinate( ide_inspector_properties, *e_widget )
         ChangeEditPropertiesItem( ide_inspector_properties )
         SetWindowTitle( GetCanvasWindow(*e_widget\root), Str(Width(*e_widget))+"x"+Str(Height(*e_widget) ) )
         
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
         
         If mouse( )\press
            If eventtype = #__event_MouseEnter
               If mouse( )\drag
                  Debug "drag entered "+EnteredWidget( )\class
                  ; EnteredWidget( )\root\repaint = 1
               EndIf
            EndIf
         Else
            If IsContainer( *e_widget ) 
               If GetState( ide_inspector_elements ) > 0 
                  If eventtype = #__event_MouseLeave
                     ;ChangeCursor( *e_widget, GetCursor( *e_widget ))
                     If ResetCursor( *e_widget ) 
                        ; Debug "reset cursor"
                     EndIf
                  EndIf
                  If eventtype = #__event_MouseEnter
                     If SetCursor( *e_widget, #__Cursor_Cross, 1 )
                        ; Debug "update cursor"
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
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
EndProcedure


Global ide_design_form ; TEMP
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
                           ElseIf FindString( PackEntryName, "string" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "text" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "progress" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "container" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "scrollarea" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "splitter" )
                              Image = #PB_Any
                           ElseIf FindString( PackEntryName, "panel" )
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
   
   Debug "ide_menu_events "+BarButton
   
   Select BarButton
      Case 1
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
         
         
      Case #_tb_file_open
         Debug "#_tb_file_open"
         Close( ide_design_form )
         ;          ClearItems( ide_inspector_view )
         
         
      Case #_tb_file_save
         Debug "#_tb_file_save"
         
      Case #_tb_widget_copy
         widget_copy( )
         
      Case #_tb_widget_cut
         widget_copy( )
         widget_delete( )
         
      Case #_tb_widget_paste
         widget_paste( )
         
      Case #_tb_widget_delete
         widget_delete( )
         
         
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
            ; bug при отмене выбора закрыть
            If #PB_MessageRequester_Yes = Message( "Message", 
                                                   "Are you sure you want to go out?",
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn 0
            Else
               ProcedureReturn 1
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *e_widget = ide_inspector_elements
            Debug " ------ drag ide_events() ----- "
            If DDragPrivate( #_DD_CreateNew )
               ChangeCurrentCursor( *e_widget, Cursor::Create( ImageID( GetItemData( *e_widget, GetState( *e_widget ) ) ) ) )
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If *e_widget = ide_design_code
            ; Debug Left( *e_widget\text\string, *e_widget\text\caret\pos ); GetState( ide_design_code )
         EndIf
         
         If e_item = - 1
            ;SetText( ide_help_view, GetItemText( *e_widget, GetState( *e_widget ) ) )
         Else
           If WidgetEventData( ) > 0
             If *e_widget = ide_inspector_view
                  ;Debug ""+WidgetEventData( )+" i "+e_item
                  SetText( ide_help_view, GetItemText( *e_widget, e_item ) )
               EndIf
               If *e_widget = ide_inspector_elements
                  SetText( ide_help_view, GetItemText( *e_widget, e_item ) )
               EndIf
               If *e_widget = ide_inspector_properties
                  SetText( ide_help_view, GetItemText( *e_widget, e_item ) )
               EndIf
               If *e_widget = ide_inspector_events
                  SetText( ide_help_view, GetItemText( *e_widget, e_item ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Change
         If *e_widget = ide_inspector_view
            ; Debug " 1 change-["+*e_widget\class+"]"
            If a_set( GetItemData(*e_widget, GetState(*e_widget)), #__a_full )
               properties_updates( ide_inspector_properties, a_focused( ) )
            EndIf
         EndIf
         If *e_widget = ide_inspector_properties
            ; Debug " 2 change-["+*e_widget\class+"]"
            properties_updates( ide_inspector_properties, a_focused( ) )
         EndIf
         
         If *e_widget = ide_design_code
            Protected q, startpos, stoppos
            Protected X = #PB_Ignore, Y = #PB_Ignore
            Protected Width = #PB_Ignore, Height = #PB_Ignore
            
            Protected findstring.s = Left( *e_widget\text\string, *e_widget\text\caret\pos )
            Protected countstring = CountString( findstring, "," )
            
            Select countstring
               Case 0, 1, 2, 3, 4
                  For q = *e_widget\text\edit[1]\len To *e_widget\text\edit[1]\pos Step - 1
                     If Mid( *e_widget\text\string, q, 1 ) = "(" Or 
                        Mid( *e_widget\text\string, q, 1 ) = ~"\"" Or
                        Mid( *e_widget\text\string, q, 1 ) = ","
                        startpos = q + 1
                        Break
                     EndIf
                  Next q
                  
                  For q = *e_widget\text\edit[3]\pos To ( *e_widget\text\edit[3]\pos + *e_widget\text\edit[3]\len )
                     If Mid( *e_widget\text\string, q, 1 ) = "," Or
                        Mid( *e_widget\text\string, q, 1 ) = ~"\"" Or
                        Mid( *e_widget\text\string, q, 1 ) = ")"
                        stoppos = q
                        Break
                     EndIf
                  Next q
                  
                  If stoppos And stoppos - startpos
                     findstring = Mid( *e_widget\text\string, startpos, stoppos - startpos )
                     
                     If countstring = 4
                        SetText( a_focused( ), findstring )
                     Else
                        If countstring = 0
                           X = Val( findstring )
                        ElseIf countstring = 1
                           Y = Val( findstring )
                        ElseIf countstring = 2
                           Width = Val( findstring )
                        ElseIf countstring = 3
                           Height = Val( findstring )
                        EndIf
                        
                        Resize( a_focused( ), X, Y, Width, Height)
                     EndIf
                     
                  EndIf
            EndSelect
            
            ; Debug Left( *e_widget\text\string, *e_widget\text\caret\pos ); GetState( ide_design_code )
         EndIf
         
      Case #__event_LeftClick
         ; ide_menu_events( *e_widget, WidgetEventItem( ) )
         
         ; Debug *e_widget\TabEntered( )
         
         If *e_widget\TabEntered( )
            ide_menu_events( *e_widget, *e_widget\TabEntered( )\index )
         Else
            If GetClass( *e_widget ) = "ToolBar"
               ide_menu_events( *e_widget, GetData( *e_widget ) )
            EndIf
         EndIf
         
   EndSelect
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
   ide_toolbar = ToolBar( ide_toolbar_container, #PB_ToolBar_Small );|#PB_ToolBar_Buttons|#PB_ToolBar_Large);| #PB_ToolBar_InlineText )
   SetColor(ide_toolbar, #__color_back, $FFD8DBDB )
   
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
   Define ide_root2 ;= Open(1) : Define ide_g_canvas2 =  GetCanvasGadget(ide_root2)
   
   ide_design_panel = Panel( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel, "ide_design_panel" ) ; , #__bar_vertical ) : OpenList( ide_design_panel )
   AddItem( ide_design_panel, -1, "Form" )
   ide_design_MDI = MDI( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_MDI, "ide_design_MDI" ) ;: SetFrame(ide_design_MDI, 10)
   SetColor( ide_design_MDI, #__color_back, RGBA(195, 156, 191, 255) )
   a_init( ide_design_MDI);, 0 )
   
   AddItem( ide_design_panel, -1, "Code" )
   ;ide_design_code = Editor( 0,0,0,0 ) : SetClass(ide_design_code, "ide_design_code" ) ; bug then move anchors window
   AddItem( ide_design_panel, -1, "Hiasm" )
   CloseList( )
   
   If ide_root2
     CloseGadgetList( )
     UseGadgetList( GadgetID(ide_g_canvas))
     OpenList(ide_root)
   Else
     Define ide_g_canvas2 = ide_design_panel
   EndIf
 
   ;
   ide_debug_view = Editor( 0,0,0,0 ) : SetClass(ide_debug_view, "ide_debug_view" ) ; ListView( 0,0,0,0 ) 
   If Not ide_design_code
      ide_design_code = ide_debug_view
   EndIf
   
   ;\\\ open inspector gadgets 
   ide_inspector_view = Tree( 0,0,0,0 ) : SetClass(ide_inspector_view, "ide_inspector_view" ) ;, #__flag_gridlines )
   EnableDDrop( ide_inspector_view, #PB_Drop_Text, #PB_Drag_Link )
   
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
   ide_inspector_properties = CreateProperties( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_borderless ) : SetClass(ide_inspector_properties, "ide_inspector_properties" )
   If ide_inspector_properties
      AddItemProperties( ide_inspector_properties, #_pi_group_0,  "Common"+Chr(10) )
      AddItemProperties( ide_inspector_properties, #_pi_id,       "ID"      , #__Type_String, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_class,    "Class"   , #__Type_String, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_text,     "Text"    , #__Type_String, 1 )
      
      AddItemProperties( ide_inspector_properties, #_pi_group_1,  "Layout" )
      AddItemProperties( ide_inspector_properties, #_pi_x,        "x"       , #__Type_Spin, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_y,        "Y"       , #__Type_Spin, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_width,    "Width"   , #__Type_Spin, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_height,   "Height"  , #__Type_Spin, 1 )
      
      AddItemProperties( ide_inspector_properties, #_pi_group_2,  "State" )
      AddItemProperties( ide_inspector_properties, #_pi_disable,  "Disable" , #__Type_ComboBox, 1 )
      AddItemProperties( ide_inspector_properties, #_pi_hide,     "Hide"    , #__Type_ComboBox, 1 )
      
      AddItemProperties( ide_inspector_properties, #_pi_group_3,  "Flag" )
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
   ide_help_view  = Text( 0,0,0,0, "help for the inspector", #PB_Text_Border ) : SetClass(ide_help_view, "ide_help_view" )
   ;\\\ close inspector gadgets 
   
   ;
   ;\\\ ide splitters
   ;       ;
   ;       ; main splitter 1 example
   ;       ide_design_splitter = Splitter( 0,0,0,0, ide_toolbar_container,ide_g_canvas2, #PB_Splitter_FirstFixed | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;       ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;       ide_debug_splitter = Splitter( 0,0,0,0, ide_design_splitter,ide_debug_view, #PB_Splitter_SecondFixed ) : SetClass(ide_debug_splitter, "ide_debug_splitter" )
   ;       ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_help_view, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;       ide_splitter = Splitter( 0,0,0,0, ide_debug_splitter,ide_inspector_panel_splitter, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;       
   ;       ; set splitters default minimum size
   ;       SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 500 )
   ;       SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 120 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;       SetAttribute( ide_debug_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;       SetAttribute( ide_debug_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   ;       ; SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, $ffffff )
   ;       
   ;       ; set splitters dafault positions
   ;       SetState( ide_splitter, Width( ide_splitter )-200 )
   ;       SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;       SetState( ide_debug_splitter, Height( ide_debug_splitter )-150 )
   ;       SetState( ide_inspector_view_splitter, 200 )
   ;       SetState( ide_design_splitter, Height( ide_toolbar ) - 1 + 2 )
   ;    
   ;    ;
   ;    ;\\ main splitter 2 example 
   ;    ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;    ide_debug_splitter = Splitter( 0,0,0,0, ide_g_canvas2,ide_debug_view, #PB_Splitter_SecondFixed ) : SetClass(ide_debug_splitter, "ide_debug_splitter" )
   ;    ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_help_view, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;    ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_panel_splitter, ide_debug_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;    ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;    
   ;    ; set splitters default minimum size
   ;    SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;    SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;    SetAttribute( ide_debug_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;    SetAttribute( ide_debug_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;    
   ;    ; set splitters dafault positions
   ;    SetState( ide_splitter, Height( ide_toolbar ) )
   ;    SetState( ide_design_splitter, 200 )
   ;    SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;    SetState( ide_debug_splitter, Height( ide_debug_splitter )-200 )
   ;    SetState( ide_inspector_view_splitter, 230 )
   ;    
   
   ;
   ;\\ main splitter 2 example 
   ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_panel,ide_help_view, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_view_splitter" )
   ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view, ide_inspector_panel_splitter) : SetClass(ide_inspector_view_splitter, "ide_inspector_panel_splitter" )
   ide_debug_splitter = Splitter( 0,0,0,0, ide_g_canvas2,ide_debug_view, #PB_Splitter_SecondFixed ) : SetClass(ide_debug_splitter, "ide_debug_splitter" )
   ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter, ide_debug_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   
   ; set splitters default minimum size
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   SetAttribute( ide_debug_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   SetAttribute( ide_debug_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   
   ; set splitters dafault positions
   SetState( ide_splitter, Height( ide_toolbar ) )
   SetState( ide_design_splitter, 200 )
   SetState( ide_debug_splitter, Height( ide_debug_splitter )-180 )
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
   Bind( ide_design_code, @ide_events( ), #__event_Change )
   Bind( ide_design_code, @ide_events( ), #__event_StatusChange )
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
   
   ;   ;OpenList(ide_design_MDI)
   Define result, btn2, example = 3
   
   
   ide_design_form = widget_add( ide_design_MDI, "window", 10, 10, 350, 200 )
   
   If example = 2
      ;\\ example 2
      Define *container = widget_add( ide_design_form, "container", 130, 20, 220, 140 )
      widget_add( *container, "button", 10, 20, 30, 30 )
      widget_add( ide_design_form, "button", 10, 20, 100, 30 )
      
      Define item = 1
      SetState( ide_inspector_view, item )
      If IsGadget( ide_g_code )
         SetGadgetState( ide_g_code, item )
      EndIf
      Define *container2 = widget_add( *container, "container", 60, 10, 220, 140 )
      widget_add( *container2, "button", 10, 20, 30, 30 )
      
      SetState( ide_inspector_view, 0 )
      widget_add( ide_design_form, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      Resize(ide_design_form, 30, 30, 500, 250)
      Disable(widget_add(ide_design_form, "button", 15, 25, 50, 30),1)
      widget_add(ide_design_form, "text", 25, 65, 50, 30)
      btn2 = widget_add(ide_design_form, "button", 35, 65+40, 50, 30)
      widget_add(ide_design_form, "text", 45, 65+40*2, 50, 30)
      
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
;       ;SetChildrenBounds( ide_design_MDI )
      
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
   ;       Debug "     gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   ;    Debug ""
   ;    *parent = *container
   ;    *this = GetPositionLast( *parent )
   ;    Debug ""+*this\class +"           ("+ *parent\class +")" ;  +" - ("+ *this\text\string +")"
   ;    
   ;    
   ;    If StartEnum( *parent )
   ;       Debug "   *parent  gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   If SetActive( ide_inspector_view )
      SetActiveGadget( ide_g_canvas )
   EndIf
   
   ;\\ 
   WaitClose( )
CompilerEndIf


;\\ include images
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
; CursorPosition = 845
; FirstLine = 806
; Folding = ----4------------f-0-------------
; EnableXP
; DPIAware
; Executable = ..\widgets-ide.app.exe