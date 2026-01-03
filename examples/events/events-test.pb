#ide_path = "../../"
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
Enumeration Properties
   #_pi_group_COMMON 
   #_pi_ID 
   #_pi_class
   #_pi_text
   #_pi_IMAGE
   ;
   #_pi_group_LAYOUT 
   #_pi_align
   #_pi_x
   #_pi_y
   #_pi_width
   #_pi_height
   ;
   #_pi_group_VIEW 
   #_pi_cursor
   #_pi_hide
   #_pi_disable
   #_pi_FLAG
   ;
   #_pi_FONT
   #_pi_fontsize
   #_pi_fontstyle
   ;
   #_pi_COLOR
   #_pi_colortype
   #_pi_colorstate
   #_pi_coloralpha
   #_pi_colorblue
   #_pi_colorgreen
   #_pi_colorred
EndEnumeration

; events items
Enumeration Properties
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
   #_tb_file_SAVEAS
   #_tb_QUIT
   
   #_tb_LNG
   #_tb_lng_ENG
   #_tb_lng_RUS
   #_tb_lng_FRENCH
   #_tb_lng_GERMAN
EndEnumeration

;- GLOBALs
Global ide_window, 
       ide_g_inspector_VIEW,
       ide_g_canvas

Global ide_root,
       ide_main_SPLITTER,
       ide_SPLITTER, 
       ide_toolbar_container, 
       ide_toolbar, 
       ide_popup_lenguage,
       ide_menu

Global ide_design_SPLITTER,
       ide_design_PANEL, 
       ide_design_MDI,
       ide_design_CODE, 
       ide_design_HIASM, 
       ide_design_DEBUG 

Global ide_inspector_SPLITTER,
       ide_inspector_VIEW, 
       ide_inspector_panel_SPLITTER, 
       ide_inspector_PANEL,
       ide_inspector_ELEMENTS,
       ide_inspector_PROPERTIES, 
       ide_inspector_EVENTS,
       ide_inspector_HELP

Global group_select
Global group_drag

Global ColorState
Global ColorType 

Global enum_object = 0
Global enum_image = 0
Global enum_font = 0
Global pb_object$ = "";"Gadget"

;
;- DECLAREs
Declare   PropertiesItems_SetText( *splitter, item, Text.s )
Declare.s PropertiesItems_GetText( *splitter, item )
XIncludeFile #ide_path + "widgets.pbi"
;
;- USES
UseWidgets( )
UsePNGImageDecoder( )
; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
; test_focus_draw = 1
; test_focus_set = 1
; test_changecursor = 1
test_focus_draw = 1
;test_focus_set = 1

;-
Global *PropertiesButton._s_WIDGET
Declare   PropertiesButton_Events( )
Declare   PropertiesItems_StatusChange( *this._s_WIDGET, item, state )
Declare   Properties_StatusChange( *splitter._s_WIDGET, *this._s_WIDGET, item )
;-
Procedure   PropertiesButton_Get( )
   ProcedureReturn *PropertiesButton
EndProcedure

Procedure   PropertiesButton_Set( *this._s_WIDGET )
   *PropertiesButton = *this
EndProcedure

Procedure   PropertiesButton_Free( *this._s_WIDGET )
   If *this
      Unbind( *this, @PropertiesButton_Events( ))
      Free( @*this )
      *PropertiesButton = 0
   EndIf
EndProcedure

Procedure   PropertiesButton_Resize( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = PropertiesButton_Get( )
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
            Select *row\index
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  Resize(*this,
                         *row\x + (*second\inner_width( )-*this\width), ; + *second\scroll_x( )
                         *row\y,                                        ; + *second\scroll_y( ), 
                         #PB_Ignore, 
                         *row\height, 0 )
               Default
                  Resize(*this,
                         *row\x,
                         *row\y + *second\scroll_y( ),
                         *second\inner_width( ), ; *row\width,
                         *row\height, 0 )
            EndSelect 
            ;             ;*this\WIdgetChange( ) = 1
            ;             *this\TextChange( ) = 1
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure   PropertiesButton_Display( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   Static *last._s_WIDGET
   
   *row = *second\RowFocused( )
   If *row
      *this = *PropertiesButton
      If *this 
         If *last <> *this
            *last = *this
            
            ;
            Select GetType( *this )
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
            PropertiesButton_Resize( *second )
            
            ; SetActive( *this )
            
         EndIf
      EndIf
   EndIf
   
   ProcedureReturn *last
EndProcedure

Procedure   PropertiesButton_Events( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Protected *splitter._s_WIDGET = GetParent( *g )
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   ; Debug ""+widget::ClassFromEvent(__event) +" "+ widget::GetClass( *g) +" "+ GetData(*g)
   
   If Not a_focused( )
    ;  ProcedureReturn 0
   EndIf
   
   Select __event
      Case #__event_Input
         Debug "button "+keyboard( )\input
         
      Case #__event_LostFocus
         __item = GetData( EventWidget( ))
         PropertiesItems_StatusChange( *first, __item, 3 )
         PropertiesItems_StatusChange( *second, __item, 3 )
         
      Case #__event_Focus
         Debug "focus ????????"
         __item = GetData( EventWidget( ))
         PropertiesItems_StatusChange( *first, __item, 2 )
         PropertiesItems_StatusChange( *second, __item, 2 )
         ;
         SetText( EventWidget( ), *first\RowFocused( )\text\string )
         
          
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   PropertiesButton_Create( *second._s_WIDGET, item )
   Protected *this._s_WIDGET
   Protected min, max, steps, Flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
   Protected Type = #__type_Button ; GetItemData( *second, item )
   
   PropertiesButton_Free( PropertiesButton_Get( ))
   
   Debug "create "+item +" "+ Type
   
   *this = Create( *second, "Button", Type, 0, 0, #__bar_button_size+1, 0, "test", Flag, 0, 0, 0, 0, 0, 0 )
               
   If *this
      PropertiesButton_Set(*this)
      SetData( *this, item )
      Bind( *this, @PropertiesButton_Events( ))
      PropertiesButton_Display( *second )
   EndIf
   
   ProcedureReturn *this
EndProcedure

;-
Procedure   PropertiesItems_StatusChange( *this._s_WIDGET, item, state )
   Protected._s_ROWS *item = ItemID( *this, item )
   If *item 
      *item\ColorState( ) = state
      ProcedureReturn *item
   EndIf
EndProcedure

Procedure.s PropertiesItems_GetText( *splitter._s_WIDGET, item )
   ProcedureReturn GetItemText( GetAttribute(*splitter, #PB_Splitter_SecondGadget), item )
EndProcedure

Procedure   PropertiesItems_SetText( *splitter._s_WIDGET, item, Text.s )
   ProcedureReturn SetItemText( GetAttribute(*splitter, #PB_Splitter_SecondGadget), item, Text.s )
EndProcedure

Procedure   PropertiesItems_Events( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Protected item, state
   Protected._s_ROWS *row
   
   Protected *first._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_SecondGadget)
   ;  
   Select __event
      Case #__event_Focus
         
      Case #__event_LostFocus
         If PropertiesButton_Get( ) = GetActive( )
            Debug "wy"
         EndIf
         
      Case #__event_Down
         If Not EnteredButton( )
            If SetState( *g, __item)
               PropertiesButton_Create( *second, __item )
            EndIf
            
            ;
            If SetActive( PropertiesButton_Get( ) ) 
               Debug "wyy"
            EndIf
         EndIf
         
      Case #__event_Change
         Select *g
            Case *first : SetState(*second, GetState(*g))
            Case *second : SetState(*first, GetState(*g))
         EndSelect
         
         PropertiesButton_Display( *second )
         
      Case #__event_CursorChange
         ProcedureReturn 0
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

;-
Procedure   Properties_StatusChange( *splitter._s_WIDGET, *this._s_WIDGET, item )
   Protected._s_WIDGET *first = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected._s_WIDGET *second = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   Protected._s_ROWS *row
   ;
   If PushItem( *this )
      If SelectItem( *this, Item)
         *row = *this\__rows( )
      EndIf
      PopItem( *this)
   EndIf
   
   If *this <> *first And Not ( *first\RowFocused( ) And *first\RowFocused( )\index = *row\index ) ; And GetState( *first ) <> *row\index
      If ListSize( *first\__rows( ))
         PushListPosition( *first\__rows( ) )
         If SelectElement( *first\__rows( ), *row\index)
            If *row\ColorState( ) = #__s_2
               If *first\RowFocused( )
                  *first\RowFocused( )\focus = 0
               EndIf
               *first\RowFocused( ) = *first\__rows( )
               *first\RowFocused( )\focus = 1
            EndIf
            
            *first\__rows( )\ColorState( ) = *row\ColorState( )
         EndIf
         PopListPosition( *first\__rows( ) )
      EndIf
   EndIf 
   
   If *this <> *second And Not ( *second\RowFocused( ) And *second\RowFocused( )\index = *row\index ) ; And GetState( *second ) <> *row\index
      If ListSize( *second\__rows( ))
         PushListPosition( *second\__rows( ))
         If SelectElement( *second\__rows( ), *row\index )
            If *row\ColorState( ) = #__s_2
               If *second\RowFocused( )
                  *second\RowFocused( )\focus = 0
               EndIf
               *second\RowFocused( ) = *second\__rows( )
               *second\RowFocused( )\focus = 1
            EndIf
            
            *second\__rows( )\ColorState( ) = *row\ColorState( )
         EndIf
         PopListPosition( *second\__rows( ) )
      EndIf
   EndIf 
EndProcedure

Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
   Protected *this._s_WIDGET
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   If mode
      AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
   Else
      AddItem( *first, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
   EndIf
   AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
   
   item = CountItems( *first ) - 1
   If mode = 0
      Define color_properties.q = $FFBF9CC3;$BE80817D
      Define fcolor_properties.q = $CA2E2E2E
      
      
      ;                      SetItemFont( *first, item, font_properties)
      ;                      SetItemFont( *second, item, font_properties)
      
      SetItemColor( *first, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      SetItemColor( *second, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      
      SetItemColor( *first, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)
      SetItemColor( *second, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)   
      
      SetItemColor( *first, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)
      SetItemColor( *second, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)   
   Else
      SetItemColor( *first, item, #PB_Gadget_BackColor, $FFFEFEFE)
      SetItemColor( *second, item, #PB_Gadget_BackColor, $FFFEFEFE )
   EndIf
   ;*this = PropertiesButton_Create( *second, item )
   
   ; SetItemData(*first, item, *this)
   SetItemData(*second, item, Type)
EndProcedure

Procedure   Properties_Create( X,Y,Width,Height, Flag=0 )
   Protected position = 90
   Protected tflag.q = #__flag_BorderLess|#PB_Tree_NoLines|#__flag_Transparent;|#__flag_gridlines
   Protected *first._s_WIDGET = Tree(0,0,0,0, tflag)
   Protected *second._s_WIDGET = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
   ;    *first\padding\x = 10
   ;    *second\padding\x = 10
   Protected *g._s_WIDGET
   *g = *first
   ;*g\padding\x = DPIScaled(20)
   *g\fs[1] = DPIScaled(20)
   ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
   SetColor(*g, #PB_Gadget_BackColor,  $FF00FFFF)
   
   *g = *second
   ;*g\padding\x = DPIScaled(20)
   ;*g\fs[1] = DPIScaled(20)
   ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
   SetColor(*g, #PB_Gadget_BackColor,  $FF00FFFF)
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, Flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   ;
   *splitter\bar\button\size = DPIScaled(1)
   *splitter\bar\button\size + Bool( *splitter\bar\button\size % 2 )
   *Splitter\bar\button\round = 0;  DPIScaled(1)
   SetState(*splitter, DPIScaled(position) ) ; похоже ошибка DPI
   
   ;
   SetClass(*first\scroll\v, "first_v")
   SetClass(*first\scroll\h, "first_h")
   SetClass(*second\scroll\v, "second_v")
   SetClass(*second\scroll\h, "second_h")
   
   ;
   Hide( *first\scroll\v, 1 )
   Hide( *first\scroll\h, 1 )
   Hide( *second\scroll\h, 1 )
   
   ; CloseList( )
   
   SetColor( *splitter, #PB_Gadget_BackColor, -1, #PB_All )
   SetColor( *first, #PB_Gadget_LineColor, $FFBF9CC3)
   SetColor( *second, #PB_Gadget_LineColor, $FFBF9CC3)
   
   ;
   Bind(*first, @PropertiesItems_Events( ))
   Bind(*second, @PropertiesItems_Events( ))
   
   ; draw и resize отдельно надо включать пока поэтому вот так
   Bind(*second, @PropertiesItems_Events( ), #__event_Resize)
   Bind(*second, @PropertiesItems_Events( ), #__event_Draw)
   ProcedureReturn *splitter
EndProcedure



;-
Procedure   ide_open( X=50,Y=75,Width=900,Height=700 )
   Define Flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_Invisible
   ide_root = Open( 1, X,Y,Width,Height, "ide", Flag ) 
   ide_window = GetCanvasWindow( ide_root )
   ide_g_canvas = GetCanvasGadget( ide_root )
   
   
   ide_inspector_PROPERTIES = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_Borderless ) : SetClass(ide_inspector_PROPERTIES, "ide_inspector_PROPERTIES" )
   If ide_inspector_PROPERTIES
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_COMMON, "COMMON" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_ID,             "#ID",      #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_class,          "Class",    #__Type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_text,           "Text",     #__Type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_IMAGE,          "Image",    #__Type_Button, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_LAYOUT, "LAYOUT" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_x,              "X",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_y,              "Y",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_width,          "Width",    #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_height,         "Height",   #__Type_Spin, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_VIEW,   "VIEW" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_cursor,         "Cursor",   #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_hide,           "Hide",     #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_disable,        "Disable",  #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_flag,          "Flag",      #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_FONT,           "Font",     #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontsize,       "size",     #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontstyle,      "style",    #__Type_ComboBox, 2 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_COLOR,           "Color",   #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colortype,       "type",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorstate,      "state",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_coloralpha,      "alpha",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorblue,       "blue",    #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorgreen,      "green",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorred,        "red",     #__Type_Spin, 2 )
   EndIf
   
   
   ;Bind( #PB_All, @ide_events( ) )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   HideWindow( ide_window, #False )
   
   
   ;\\ 
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 222
; FirstLine = 219
; Folding = ----------
; EnableXP
; DPIAware