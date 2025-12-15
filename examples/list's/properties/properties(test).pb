; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global ide_inspector_PROPERTIES
   Global a, *demo._s_WIDGET, *this._s_widget, *test, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   ;- DECLARE
   Declare PropertiesItems_ChangeStatus( *this._s_WIDGET, item, state )
   Declare PropertiesButton_Events( )
   Declare PropertiesItems_Events( )
   Declare Properties_Events( )
   
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
   Procedure   PropertiesButton_Resize( *row._s_ROWS, scroll_y, inner_width )
      Protected result
      Protected._s_WIDGET *this = *test
      If *row
         Select *row\index
            Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
               result = Resize( *this,
                                ( *row\x + inner_width ) - *this\width, 
                                *row\y + scroll_y,                                        
                                #PB_Ignore, 
                                *row\height, 0 )
            Default
               result = Resize(*this,
                               *row\x,
                               *row\y + scroll_y,
                               inner_width,
                               *row\height, 0 )
         EndSelect 
      EndIf
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Free( )
      If *test
         Unbind(*test, @PropertiesButton_Events( ))
         Free( @*test )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *parent._s_WIDGET, item )
      Protected *this._s_WIDGET
      Protected min, max, steps, flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
      Protected Type = GetItemData( *parent, item )
      
      PropertiesButton_Free( )
      
      Select Type
         Case #__type_Spin
            flag = #__spin_Plus
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
            
            *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, "", flag, min, max, 0, #__bar_button_size, 0, steps )
            
         Case #__type_String
            *this = Create( *parent, "String", Type, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_CheckBox
            *this = Create( *parent, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_Button
            Select item
               Case #_pi_align
                  CompilerIf Defined( AnchorBox, #PB_Module )
                     *this = AnchorBox::Create( *parent, 0,0,0,20 )
                  CompilerEndIf
                  
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  *this = Create( *parent, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", flag, 0, 0, 0, 0, 0, 0 )
                  
            EndSelect
            
         Case #__type_ComboBox
            *this = Create( *parent, "ComboBox", Type, 0, 0, 0, 0, "", flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
            ;
            Select item
               Case #_pi_flag
                  
               Case #_pi_fontstyle
                  AddItem(*this, -1, "None")         
                  If *this\PopupCombo( )
                     *this\PopupCombo( )\mode\Checkboxes = 1
                     *this\PopupCombo( )\mode\optionboxes = 1
                     ;    Flag( *this\PopupCombo( ), #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
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
                  ;                ColorType = MakeConstants("#PB_Gadget_" + GetItemText( *this, 0))
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
         *test = *this
         SetData(*this, item)
         ; SetItemData(*parent, item, *this)
         Bind(*this, @PropertiesButton_Events( ))
      EndIf
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure   PropertiesButton_Display( *this._s_WIDGET )
      Protected._s_ROWS *row = *this\RowFocused( )
      
      If *test 
         If *row
            If Not *row\childrens
               If *row\hide
                  If Hide( *test ) = 0
                     Hide( *test, #True )
                  EndIf
               Else
                  If Hide( *test )
                     Hide( *test, #False )
                  EndIf
                  
                  ;
                  If PropertiesButton_Resize( *row, *this\scroll_y( ), *this\inner_width( ))
                     ProcedureReturn *test
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Events( )
      Protected item
      
      Select WidgetEvent( )
         Case #__event_Input
            Debug "button "+keyboard( )\input
            
         Case #__event_LostFocus
            item = GetData( EventWidget( ))
            PropertiesItems_ChangeStatus( *this, item, 3 )
            PropertiesItems_ChangeStatus( *demo, item, 3 )
            
         Case #__event_Focus
            item = GetData( EventWidget( ))
            PropertiesItems_ChangeStatus( *this, item, 2 )
            PropertiesItems_ChangeStatus( *demo, item, 2 )
            
            EventWidget( )\padding\x = *this\row\sublevelsize
            SetText( EventWidget( ), *this\RowFocused( )\text\string )
            ;PropertiesButton_Create( *this, item )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*this\scroll\v, GetState( *this\scroll\v ) - WidgetEventData( ) )
            EndIf
      EndSelect
   EndProcedure
   
   ;-
   Procedure   PropertiesItems_ChangeStatus( *this._s_WIDGET, item, state )
      Protected._s_ROWS *item = ItemID( *this, item )
      If *item 
         *item\ColorState( ) = state
         ProcedureReturn *item
      EndIf
   EndProcedure
   
   Procedure   Propertiesitems_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
      Protected *this._s_WIDGET
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
;       If mode
;          AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
;       Else
;          AddItem( *first, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
;       EndIf
;       AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      AddItem( *first, item, Text.s, -1, mode )
      AddItem( *second, item, Text.s, -1, mode )
      
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
   
   Procedure   PropertiesItems_Events( )
      Protected item, state
      Protected._s_ROWS *row
      
      Select WidgetEvent( )
         Case #__event_Focus
            If Not EnteredButton( )
               *row = WidgetEventData( )
               ;
               If Not *row\childrens
                  item = WidgetEventItem( )
                  ;
                  Select EventWidget( )
                     Case *this 
                        SetState(*demo, item)
                        SetState(*this, item)
                     Case *demo 
                        SetState(*this, item)
                        SetState(*demo, item)
                  EndSelect
               EndIf
            EndIf
            SetActive( GetParent( EventWidget( )))
            
         Case #__event_Change
            If *this = EventWidget( )
               *row = WidgetEventData( )
               If Not *row\childrens
                  item = WidgetEventItem( )
                  PropertiesButton_Create( *this, item )
                  PropertiesButton_Display( *this )
               EndIf
            EndIf
            
         Case #__event_StatusChange
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               Select EventWidget( )
                  Case *demo : SetItemState(*this, WidgetEventItem( ), WidgetEventData( ))
                  Case *this : SetItemState(*demo, WidgetEventItem( ), WidgetEventData( ))
               EndSelect
            EndIf
            
            ;
            If PushItem( EventWidget( ))
               If SelectItem( EventWidget( ), WidgetEventItem( ))
                  *row = EventWidget( )\__rows( )
               EndIf
               PopItem( EventWidget( ))
            EndIf
            
            If *row\childrens
               *row\ColorState( ) = #__s_0
               
               ;
               If *demo = EventWidget( )
                  If *this\RowFocused( )
                     item = *this\RowFocused( )\index 
                     state = *this\RowFocused( )\ColorState( )
                  EndIf
               EndIf
               
               If *this = EventWidget( )
                  If *demo\RowFocused( )
                     item = *demo\RowFocused( )\index 
                     state = *demo\RowFocused( )\ColorState( )
                  EndIf
               EndIf
               
               If PushItem( EventWidget( ))
                  If SelectItem( EventWidget( ), item)
                     EventWidget( )\__rows( )\ColorState( ) = state
                     If *row\focus 
                        EventWidget( )\__rows( )\focus = *row\focus
                        EventWidget( )\RowFocused( ) = EventWidget( )\__rows( )
                        *row\focus = 0
                     EndIf
                  EndIf
                  PopItem( EventWidget( ))
               EndIf
               
            Else
               Select EventWidget( )
                  Case *this 
                     If GetState( *demo ) <> *row\index
                        PropertiesItems_ChangeStatus( *demo, *row\index, *row\ColorState( ) )
                     EndIf
                  Case *demo 
                     If GetState( *this ) <> *row\index
                        PropertiesItems_ChangeStatus( *this, *row\index, *row\ColorState( ) )
                     EndIf   
               EndSelect
            EndIf
            
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *demo 
                  If GetState( *this\scroll\v ) <> WidgetEventData( )
                     If SetState(*this\scroll\v, WidgetEventData( ) )
                     EndIf
                  EndIf
                  ;
               Case *this 
                  If GetState( *demo\scroll\v ) <> WidgetEventData( )
                     If SetState(*demo\scroll\v, WidgetEventData( ) )
                     EndIf
                  EndIf
                  ;
                  ; Debug "ScrollChange " + WidgetEventData( )
                  PropertiesButton_Resize( *this\RowFocused( ), *this\scroll_y( ), *this\inner_width( ))
            EndSelect
            
         Case #__event_Resize
            If *this = EventWidget( )
               ; Debug "Resize "
               PropertiesButton_Resize( *this\RowFocused( ), *this\scroll_y( ), *this\inner_width( ))
            EndIf
            
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure   Properties_Create( X,Y,Width,Height, flag=0 )
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
      
      Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
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
      Bind(*second, @PropertiesItems_Events( ), #__event_Draw)
      ProcedureReturn *splitter
   EndProcedure
   
   Procedure   Properties_Events( )
      Select WidgetEvent( )
         Case #__event_FOCUS
            If *test
               SetActive( *test )
            EndIf
            
      EndSelect
   EndProcedure
   
   
   ;-
   Procedure   widgets_events()
      Protected count
      
      Select WidgetEvent( )
         Case #__event_Up
            
            ;             If *this\row
            ;                If *this\EnteredRow( )
            ;                   Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\press + " " + *this\EnteredRow( )\enter + " " + *this\EnteredRow( )\focus
            ;                EndIf
            ;                If *this\PressedRow( )
            ;                   Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\press + " " + *this\PressedRow( )\enter + " " + *this\PressedRow( )\focus
            ;                EndIf
            ;                If *this\RowFocused( )
            ;                   Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\press + " " + *this\RowFocused( )\enter + " " + *this\RowFocused( )\focus
            ;                EndIf
            ;             EndIf
            
            Debug "-------set-start-------"
            Select EventWidget( )
               Case *get : Debug GetState(*this)
               Case *focus : SetActive(GetParent(*this))
               Case *remove 
                  If *this\RowFocused( )
                     Protected item = *this\RowFocused( )\index
                     RemoveItem(*this, item)
                     ; RemoveItem(*demo, item)
                  EndIf
                  
               Case *reset : SetState(*this, - 1)
               Case *item1 : SetState(*this, Val(GetText(EventWidget( ))))
               Case *item2 : SetState(*this, Val(GetText(EventWidget( ))))
               Case *item3 : SetState(*this, Val(GetText(EventWidget( ))))
               Case *item4 : SetState(*this, Val(GetText(EventWidget( ))))
            EndSelect
            Debug "-------set-stop-------"
            
            ;             If *this\row
            ;                If *this\EnteredRow( )
            ;                   Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\press + " " + *this\EnteredRow( )\enter + " " + *this\EnteredRow( )\focus
            ;                EndIf
            ;                If *this\PressedRow( )
            ;                   Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\press + " " + *this\PressedRow( )\enter + " " + *this\PressedRow( )\focus
            ;                EndIf
            ;                If *this\RowFocused( )
            ;                   Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\press + " " + *this\RowFocused( )\enter + " " + *this\RowFocused( )\focus
            ;                EndIf
            ;             EndIf
            
      EndSelect
   EndProcedure
   
   
   ;-
   If Open(1, 100, 50, 370, 330, "demo ListView state", #PB_Window_SystemMenu)
      ;       ;       ;Container(0, 0, 240, 330)
      ;       *demo = Tree(10, 10, 220/2, 310) : SetClass(*demo, "demo")
      ;       *this = Tree(110, 10, 220/2, 310, #__flag_nolines) : SetClass(*this, "this")
      ;       
      ;       
      ;       ;*this = ListView(10, 10, 220, 310)
      ;       ;*this = Panel(10, 10, 230, 310) 
      ;       ;Debug *demo\scroll\v\hide 
      ;       Splitter(10,10, 230, 310, *demo, *this, #PB_Splitter_Vertical )
      ;Debug *demo\scroll\v\hide 
      ;       ;
      ;       ;Hide( *demo\scroll\v, 1 )
      ;       Hide( HBar(*demo), #True )
      ;       Hide( HBar(*this), #True )
      ;       Bind(Widget( ), @Properties_Events())
      ;       Bind(*demo, @PropertiesItems_Events());, #__event_Change)
      ;       Bind(*this, @PropertiesItems_Events());, #__event_Change)
      
      ide_inspector_PROPERTIES = Properties_Create( 10,10, 230, 310 )
      *demo = GetAttribute(Widget(), #PB_Splitter_FirstGadget)
      *this = GetAttribute(Widget(), #PB_Splitter_SecondGadget)
      
      OpenList( *this )
      *test = String( 0, 0, 0, 0, "test") ; #__flag_TextCenter| bug
                                          ;*test = String( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
                                          ; *test = Button( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
      
      Bind( *test, @PropertiesButton_Events( ))                       ;, #__event_Change)
      CloseList( )
      
      If ide_inspector_PROPERTIES
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_group_COMMON, "COMMON" )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_ID,             "#ID",      #__Type_ComboBox, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_class,          "Class",    #__Type_String, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_text,           "Text",     #__Type_String, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_IMAGE,          "Image",    #__Type_Button, 1 )
      ;
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_group_LAYOUT, "LAYOUT" )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__Type_Button, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_x,              "X",        #__Type_Spin, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_y,              "Y",        #__Type_Spin, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_width,          "Width",    #__Type_Spin, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_height,         "Height",   #__Type_Spin, 1 )
      ;
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_group_VIEW,   "VIEW" )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_cursor,         "Cursor",   #__Type_ComboBox, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_hide,           "Hide",     #__Type_ComboBox, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_disable,        "Disable",  #__Type_ComboBox, 1 )
      ;
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_flag,          "Flag",      #__Type_ComboBox, 1 )
      ;
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_FONT,           "Font",     #__Type_Button, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_fontsize,       "size",     #__Type_Spin, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_fontstyle,      "style",    #__Type_ComboBox, 2 )
      ;
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_COLOR,           "Color",   #__Type_Button, 1 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_colortype,       "type",    #__Type_ComboBox, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_colorstate,      "state",    #__Type_ComboBox, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_coloralpha,      "alpha",   #__Type_Spin, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_colorblue,       "blue",    #__Type_Spin, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_colorgreen,      "green",   #__Type_Spin, 2 )
      Propertiesitems_AddItem( ide_inspector_PROPERTIES, #_pi_colorred,        "red",     #__Type_Spin, 2 )
   EndIf
   
;       For a = 0 To CountItems
;          If a % 10 = 0
;             AddItem(*demo, -1, "collaps "+Str(a), -1, 0)
;          Else
;             AddItem(*demo, -1, "Item "+Str(a), -1, 1)
;          EndIf
;       Next
;       For a = 0 To CountItems
;          If a % 10 = 0
;             AddItem(*this, -1, "collaps "+Str(a), -1, 0)
;          Else
;             AddItem(*this, -1, "Item "+Str(a), -1, 1)
;          EndIf
;          SetItemData( *this, a, *test )
;       Next
      
      If IsContainer(*this)
         CloseList( ) 
      EndIf
      ; CloseList( ) 
      
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
      
      
      ;       ReDraw(root())
      ;       ;Unbind(*w2, @PropertiesItems_Events())
      ;       Free(root())
      ;       
      ;       PushListPosition(widgets( ))
      ;       ForEach widgets( )
      ;            Debug "p "+widgets( )\class +" "+ widgets( )\parent\class
      ;           If Not ( widgets( )\parent And widgets( )\parent\address )
      ;           ;  SetParent( widgets( ), roots( ) )
      ;          EndIf      
      ;       Next
      ;       PopListPosition(widgets( ))
      ;       
      ;       If root( )\FirstWidget( )
      ;          Debug "  f "+ root( )\FirstWidget( )\class +" "+ root( )\FirstWidget( )\address
      ;       EndIf
      ;       
      ; ;       
      ; ;       ;        ReDraw( root( ))
      ; ;       ;       ;*demo\scroll\v\hide = 1
      ; ;       ;       Debug *demo\scroll\v\hide 
      
      WaitClose()
      
      
      
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 275
; FirstLine = 229
; Folding = --8--0a04---
; EnableXP
; DPIAware