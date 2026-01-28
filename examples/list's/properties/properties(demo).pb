; 
; second state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global ide_inspector_PROPERTIES
   Global a, *first._s_widget, *second._s_WIDGET, *display._s_WIDGET, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   ;- DECLARE
   Declare PropertiesButton_Events( )
   Declare PropertiesItems_Events( )
   ;
   Declare Properties_Events( )
   Declare Properties_StatusChange( *splitter._s_WIDGET, *this._s_WIDGET )
   Declare PropertiesItems_StatusChange( *this._s_WIDGET, item, state )
   
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
   
   ;-
   Procedure   PropertiesButton_Free( )
      If *display
         Unbind(*display, @PropertiesButton_Events( ))
         Free( @*display )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Resize( *second._s_WIDGET )
      Protected._s_ROWS *row = *second\RowFocused( )
      Protected._s_WIDGET *this
      Protected result
      
      If *row
         *this = *display
         ;
         If *this
            Select *row\index
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  result = Resize( *this,
                                   ( *row\x + *second\inner_width( )) - *this\width, 
                                   *row\y + *second\scroll_y( ),                                        
                                   #PB_Ignore, 
                                   *row\height, 0 )
               Default
                  result = Resize( *this,
                                   *row\x,
                                   *row\y + *second\scroll_y( ),
                                   *second\inner_width( ),
                                   *row\height, 0 )
            EndSelect 
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Display( *second._s_WIDGET )
      Protected._s_ROWS *row = *second\RowFocused( )
      Protected._s_WIDGET *this
      
      If *row
         *this = *display
         ;
         If *this 
            If Not *row\childrens
               If *row\hide
                  If Hide( *this ) = 0
                     Hide( *this, #True )
                  EndIf
               Else
                  If Hide( *this )
                     Hide( *this, #False )
                  EndIf
                  
                  ;
                  If PropertiesButton_Resize( *second )
                     ProcedureReturn *this
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *second._s_WIDGET, item )
      Protected Type = GetItemData( *second, item )
      Protected min, max, steps, Flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
      Protected *this._s_WIDGET
      
      PropertiesButton_Free( )
      
      Select Type
         Case #__type_Spin
            Flag = #__spin_Plus
            steps = 1 
            ;
            Select item
               Case #_pi_fontsize
                  min = 1
                  max = 50
               Case #_pi_coloralpha, #_pi_colorblue, #_pi_colorgreen, #_pi_colorred
                  min = 0
                  max = 255
               Default
                  ; flag = #__flag_invert ; #__spin_Plus
                  min = -2147483648
                  max = 2147483647
                  steps = 7 
            EndSelect
            
            *this = Create( *second, "Spin", Type, 0, 0, 0, 0, "", Flag, min, max, 0, #__bar_button_size, 0, steps )
            
         Case #__type_String
            *this = Create( *second, "String", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_CheckBox
            *this = Create( *second, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", Flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_Button
            Select item
               Case #_pi_align
                  CompilerIf Defined( AnchorBox, #PB_Module )
                     *this = AnchorBox::Create( *second, 0,0,0,20 )
                  CompilerElse
                     *this = Create( *second, "Button", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
                  CompilerEndIf
                  
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  *this = Create( *second, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", Flag, 0, 0, 0, 0, 0, 0 )
                  
            EndSelect
            
         Case #__type_ComboBox
            *this = Create( *second, "ComboBox", Type, 0, 0, 0, 0, "", Flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
            ;
            Select item
               Case #_pi_flag
                  
               Case #_pi_fontstyle
                  AddItem(*this, -1, "None")         
                  If *this\ComboBar( )
                     *this\ComboBar( )\mode\Checkboxes = 1
                     *this\ComboBar( )\mode\optionboxes = 1
                     ;    Flag( *this\ComboBar( ), #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
                  EndIf
                  AddItem(*this, -1, "Bold")        ; Шрифт будет выделен жирным
                  AddItem(*this, -1, "Italic")      ; Шрифт будет набран курсивом
                  AddItem(*this, -1, "Underline")   ; Шрифт будет подчеркнут (только для Windows)
                  AddItem(*this, -1, "StrikeOut")   ; Шрифт будет зачеркнут (только для Windows)
                  AddItem(*this, -1, "HighQuality") ; Шрифт будет в высококачественном режиме (медленнее) (только для Windows)
                  
               Case #_pi_colorstate
                  AddItem(*this, -1, "Default")
                  AddItem(*this, -1, "Entered")
                  AddItem(*this, -1, "Selected")
                  AddItem(*this, -1, "Disabled")
                  ;                ColorState = 0
                  ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
                  
               Case #_pi_colortype
                  AddItem(*this, -1, "BackColor")
                  AddItem(*this, -1, "FrontColor")
                  AddItem(*this, -1, "LineColor")
                  AddItem(*this, -1, "FrameColor")
                  AddItem(*this, -1, "ForeColor")
                  ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
                  
               Case #_pi_cursor
                  AddItem(*this, -1, "Default")
                  AddItem(*this, -1, "Arrows")
                  AddItem(*this, -1, "Busy")
                  AddItem(*this, -1, "Cross")
                  AddItem(*this, -1, "Denied")
                  AddItem(*this, -1, "Hand")
                  AddItem(*this, -1, "IBeam")
                  AddItem(*this, -1, "Invisible")
                  AddItem(*this, -1, "LeftDownRightUp")
                  AddItem(*this, -1, "LeftRight")
                  AddItem(*this, -1, "LeftUpRightDown")
                  AddItem(*this, -1, "UpDown")
                  ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
                  
               Default
                  AddItem(*this, -1, "False")
                  AddItem(*this, -1, "True")
                  
            EndSelect
            ;
            SetState(*this, 0)
            
      EndSelect
      
      If *this
         *display = *this
         SetData( *this, item )
         ; SetItemData(*parent, item, *this)
         Bind( *this, @PropertiesButton_Events( ))
      EndIf
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure   PropertiesButton_Events( )
      Protected item
      
      Select WidgetEvent( )
         Case #__event_Input
            Debug "button "+keyboard( )\input
            
         Case #__event_LostFocus
            item = GetData( EventWidget( ))
            PropertiesItems_StatusChange( *first, item, #__s_3 )
            PropertiesItems_StatusChange( *second, item, #__s_3 )
            
         Case #__event_Focus
            item = GetData( EventWidget( ))
            PropertiesItems_StatusChange( *first, item, #__s_2 )
            PropertiesItems_StatusChange( *second, item, #__s_2 )
            
            ;
            SetText( EventWidget( ), *first\RowFocused( )\text\string )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*first\scroll\v, GetState( *first\scroll\v ) - WidgetEventData( ) )
            EndIf
            
      EndSelect
   EndProcedure
   
   ;-
   Procedure   PropertiesItems_StatusChange2( *this._s_WIDGET, item, state )
      If item < 0 Or item > ListSize( *this\__rows( ))
         ProcedureReturn 0
      EndIf
      If ListSize( *this\__rows( ))
         PushListPosition( *this\__rows( ))
         If SelectElement( *this\__rows( ), item )
            If state = #__s_2
               If *this\RowFocused( )
                  *this\RowFocused( )\focus = 0
               EndIf
               *this\RowFocused( ) = *this\__rows( )
               *this\RowFocused( )\focus = 1
            EndIf
            
            *this\__rows( )\ColorState( ) = state
         EndIf
         PopListPosition( *this\__rows( ) )
      EndIf
   EndProcedure
   
   Procedure   PropertiesItems_StatusChange( *this._s_WIDGET, item, state )
      ;ProcedureReturn PropertiesItems_StatusChange2( *this, item, state )
      
      Protected._s_ROWS *row = ItemID( *this, item )
      If *row 
         If state = #__s_2
               If *this\RowFocused( )
                  *this\RowFocused( )\focus = 0
               EndIf
               *this\RowFocused( ) = *this\__rows( )
               *this\RowFocused( )\focus = 1
            EndIf
            
            *row\ColorState( ) = state
         ProcedureReturn *row
      EndIf
   EndProcedure
   
   Procedure   PropertiesItems_Events( )
      Protected._s_WIDGET *g = EventWidget( )
      Protected._s_WIDGET *splitter = GetParent(*g)
      Protected._s_WIDGET *first = GetAttribute( *splitter, #PB_Splitter_FirstGadget)
      Protected._s_WIDGET *second = GetAttribute( *splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROWS *row
      Protected item, state
      
      Select WidgetEvent( )
         Case #__event_Focus
            If Not EnteredButton( )
               *row = WidgetEventData( )
               ;
               If Not *row\childrens
                  item = WidgetEventItem( )
                  ;
                  Select *g
                     Case *first 
                        SetState(*second, item)
                        SetState(*first, item)
                        
                     Case *second 
                        SetState(*first, item)
                        SetState(*second, item)
                  EndSelect
               EndIf
            EndIf
            SetActive( GetParent( *g))
            
         Case #__event_StatusChange
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               Select *g
                  Case *first : SetItemState(*second, WidgetEventItem( ), WidgetEventData( ))
                  Case *second : SetItemState(*first, WidgetEventItem( ), WidgetEventData( ))
               EndSelect
            Else
               Properties_StatusChange( GetParent(*g), *g )
            EndIf
            
         Case #__event_ScrollChange
            Select *g
               Case *second 
                  If GetState( *first\scroll\v ) <> WidgetEventData( )
                     If SetState( *first\scroll\v, WidgetEventData( ))
                        PropertiesButton_Resize( *second )
                     EndIf
                  EndIf
                  ;
               Case *first 
                  If GetState( *second\scroll\v ) <> WidgetEventData( )
                     SetState( *second\scroll\v, WidgetEventData( ))
                  EndIf
            EndSelect
            
         Case #__event_Change
            If *g = *second
               *row = WidgetEventData( )
               
               If Not *row\childrens
                  item = WidgetEventItem( )
                  PropertiesButton_Create( *second, item )
                  PropertiesButton_Display( *second )
               EndIf
            EndIf
            
         Case #__event_Resize
            If *g = *second
               PropertiesButton_Resize( *second )
            EndIf
            
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure   Properties_StatusChange( *splitter._s_WIDGET, *this._s_WIDGET )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROWS *row
      Protected item, state
      ;
      If PushItem( *this)
         If SelectItem( *this, WidgetEventItem( ))
            *row = *this\__rows( )
         EndIf
         PopItem( *this)
      EndIf
      ;
      If *row\childrens
         *row\ColorState( ) = #__s_0
         ;
         If *second = *this
            If *first\RowFocused( )
               item = *first\RowFocused( )\index 
               state = *first\RowFocused( )\ColorState( )
            EndIf
         EndIf
         ;
         If *first = *this
            If *second\RowFocused( )
               item = *second\RowFocused( )\index 
               state = *second\RowFocused( )\ColorState( )
            EndIf
         EndIf
         ;
         If PushItem( *this )
            If SelectItem( *this, item)
               *this\__rows( )\ColorState( ) = state
               If *row\focus 
                  *this\__rows( )\focus = *row\focus
                  *this\RowFocused( ) = *this\__rows( )
                  *row\focus = 0
               EndIf
            EndIf
            PopItem( *this )
         EndIf
         ;
      Else
         Select *this
            Case *first 
               If GetState( *second ) <> *row\index
                  PropertiesItems_StatusChange( *second, *row\index, *row\ColorState( ) )
               EndIf
            Case *second 
               If GetState( *first ) <> *row\index
                  PropertiesItems_StatusChange( *first, *row\index, *row\ColorState( ) )
               EndIf   
         EndSelect
      EndIf
   EndProcedure
   
   Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      If mode
         AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
         AddItem( *second, item, Text.s, -1, mode )
         ;     AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      Else
         AddItem( *first, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
         AddItem( *second, item, "", -1, mode )
      EndIf
      
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
      
      SetItemData( *second, item, Type )
   EndProcedure
   
   Procedure   Properties_Events( )
      Select WidgetEvent( )
         Case #__event_FOCUS
            If *display
               SetActive( *display )
            EndIf
            
      EndSelect
   EndProcedure
   
   Procedure   Properties_Create( X,Y,Width,Height, Flag=0 )
      Protected position = 80
      Protected tflag.q = #__flag_BorderLess|#PB_Tree_NoLines|#__flag_Transparent;|#__flag_gridlines
      Protected *first._s_WIDGET = Tree(0,0,0,0, tflag)
      Protected *second._s_WIDGET = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
      ;    *first\padding\x = 10
      ;    *second\padding\x = 10
      Protected *g._s_WIDGET
      *g = *first
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      *g = *second
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, Flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
      SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
      SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
      ;
      *splitter\bar\button\round = 0
      *splitter\bar\button\size = DPIScaled(5)
      *splitter\bar\button\size + Bool( *splitter\bar\button\size % 2 )
      SetState(*splitter, (position) ) ; похоже ошибка DPI
      
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
      SetColor( *first, #PB_Gadget_BackColor, $FF00FFFF)
      SetColor( *second, #PB_Gadget_BackColor, $FF00FFFF)
      SetColor( *first, #PB_Gadget_LineColor, $FFBF9CC3)
      SetColor( *second, #PB_Gadget_LineColor, $FFBF9CC3)
      
      ;
      Bind(*splitter, @Properties_Events( ))
      Bind(*first, @PropertiesItems_Events( ))
      Bind(*second, @PropertiesItems_Events( ))
      
      ; draw и resize отдельно надо включать пока поэтому вот так
      Bind(*second, @PropertiesItems_Events( ), #__event_Resize)
      ;Bind(*second, @PropertiesItems_Events( ), #__event_Draw)
      ProcedureReturn *splitter
   EndProcedure
   
   
   ;-
   Procedure   widgets_events()
      Protected count
      
      Select WidgetEvent( )
         Case #__event_Up
            
            ;             If *first\row
            ;                If *first\EnteredRow( )
            ;                   Debug "e - " + *first\EnteredRow( ) + " " + *first\EnteredRow( )\text\string + " " + *first\EnteredRow( )\press + " " + *first\EnteredRow( )\enter + " " + *first\EnteredRow( )\focus
            ;                EndIf
            ;                If *first\PressedRow( )
            ;                   Debug "p - " + *first\PressedRow( ) + " " + *first\PressedRow( )\text\string + " " + *first\PressedRow( )\press + " " + *first\PressedRow( )\enter + " " + *first\PressedRow( )\focus
            ;                EndIf
            ;                If *first\RowFocused( )
            ;                   Debug "f - " + *first\RowFocused( ) + " " + *first\RowFocused( )\text\string + " " + *first\RowFocused( )\press + " " + *first\RowFocused( )\enter + " " + *first\RowFocused( )\focus
            ;                EndIf
            ;             EndIf
            
            Debug "-------set-start-------"
            Select EventWidget( )
               Case *get : Debug GetState(*first)
               Case *focus : SetActive(GetParent(*first))
               Case *remove 
                  If *first\RowFocused( )
                     Protected item = *first\RowFocused( )\index
                     RemoveItem(*first, item)
                     ; RemoveItem(*second, item)
                  EndIf
                  
               Case *reset : SetState(*first, - 1)
               Case *item1 : SetState(*first, Val(GetText(EventWidget( ))))
               Case *item2 : SetState(*first, Val(GetText(EventWidget( ))))
               Case *item3 : SetState(*first, Val(GetText(EventWidget( ))))
               Case *item4 : SetState(*first, Val(GetText(EventWidget( ))))
            EndSelect
            Debug "-------set-stop-------"
            
            ;             If *first\row
            ;                If *first\EnteredRow( )
            ;                   Debug "e - " + *first\EnteredRow( ) + " " + *first\EnteredRow( )\text\string + " " + *first\EnteredRow( )\press + " " + *first\EnteredRow( )\enter + " " + *first\EnteredRow( )\focus
            ;                EndIf
            ;                If *first\PressedRow( )
            ;                   Debug "p - " + *first\PressedRow( ) + " " + *first\PressedRow( )\text\string + " " + *first\PressedRow( )\press + " " + *first\PressedRow( )\enter + " " + *first\PressedRow( )\focus
            ;                EndIf
            ;                If *first\RowFocused( )
            ;                   Debug "f - " + *first\RowFocused( ) + " " + *first\RowFocused( )\text\string + " " + *first\RowFocused( )\press + " " + *first\RowFocused( )\enter + " " + *first\RowFocused( )\focus
            ;                EndIf
            ;             EndIf
            
      EndSelect
   EndProcedure
   
   
   ;-
   If Open(1, 100, 50, 370, 330, "second ListView state", #PB_Window_SystemMenu)
      ;       ;       ;Container(0, 0, 240, 330)
      ;       *second = Tree(10, 10, 220/2, 310) : SetClass(*second, "second")
      ;       *first = Tree(110, 10, 220/2, 310, #__flag_nolines) : SetClass(*first, "first")
      ;       
      ;       
      ;       ;*first = ListView(10, 10, 220, 310)
      ;       ;*first = Panel(10, 10, 230, 310) 
      ;       ;Debug *second\scroll\v\hide 
      ;       Splitter(10,10, 230, 310, *second, *first, #PB_Splitter_Vertical )
      ;Debug *second\scroll\v\hide 
      ;       ;
      ;       ;Hide( *second\scroll\v, 1 )
      ;       Hide( HBar(*second), #True )
      ;       Hide( HBar(*first), #True )
      ;       Bind(Widget( ), @Properties_Events())
      ;       Bind(*second, @PropertiesItems_Events());, #__event_Change)
      ;       Bind(*first, @PropertiesItems_Events());, #__event_Change)
      
      ide_inspector_PROPERTIES = Properties_Create( 10,10, 230, 310 )
      *first = GetAttribute( ide_inspector_PROPERTIES, #PB_Splitter_FirstGadget)
      *second = GetAttribute( ide_inspector_PROPERTIES, #PB_Splitter_SecondGadget)
      
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
      
      ;
      Define h = 20, Y = 20
      
      *reset = Button( 250, Y+(1+h)*0, 100, h, "reset")
      *item1 = Button( 250, Y+(1+h)*1, 100, h, "1")
      *item2 = Button( 250, Y+(1+h)*2, 100, h, "3")
      *item3 = Button( 250, Y+(1+h)*3, 100, h, "5")
      *item4 = Button( 250, Y+(1+h)*4, 100, h, "25")
      
      *remove = Button( 250, Y+(1+h)*11, 100, h, "remove")
      *focus = Button( 250, Y+(1+h)*12, 100, h, "focus")
      *get = Button( 250, Y+(1+h)*13, 100, h, "get")
      
      
      Bind(*remove, @widgets_events(), #__event_Up)
      Bind(*focus, @widgets_events(), #__event_Up)
      Bind(*get, @widgets_events(), #__event_Up)
      
      Bind(*reset, @widgets_events(), #__event_Up)
      Bind(*item1, @widgets_events(), #__event_Up)
      Bind(*item2, @widgets_events(), #__event_Up)
      Bind(*item3, @widgets_events(), #__event_Up)
      Bind(*item4, @widgets_events(), #__event_Up)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 181
; FirstLine = 174
; Folding = -----------0-
; EnableXP
; DPIAware