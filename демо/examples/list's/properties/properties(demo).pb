; 
; g2 state

IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global ide_inspector_PROPERTIES
   Global a, *g1._s_widget, *g2._s_WIDGET, *display._s_WIDGET, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
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
   
   Procedure   PropertiesButton_Resize( *g2._s_WIDGET )
      Protected._s_ROW *row = *g2\RowFocused( )
      Protected._s_WIDGET *this
      Protected result
      
      If *row
         *this = *display
         ;
         If *this
            Select *row\index
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  result = Resize( *this,
                                   ( *row\x + *g2\inner_width( )) - *this\width, 
                                   *row\y + *g2\scroll_y( ),                                        
                                   #PB_Ignore, 
                                   *row\height, 0 )
               Default
                  result = Resize( *this,
                                   *row\x,
                                   *row\y + *g2\scroll_y( ),
                                   *g2\inner_width( ),
                                   *row\height, 0 )
            EndSelect 
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Display( *g2._s_WIDGET )
      Protected._s_ROW *row = *g2\RowFocused( )
      Protected._s_WIDGET *this
      
      If *row
         *this = *display
         ;
         If *this 
            If Not *row\childrens
               If *row\mask & #__mask_hide
                  If Hide( *this ) = 0
                     Hide( *this, #True )
                  EndIf
               Else
                  If Hide( *this )
                     Hide( *this, #False )
                  EndIf
                  
                  ;
                  If PropertiesButton_Resize( *g2 )
                     ProcedureReturn *this
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *g2._s_WIDGET, item )
      Protected Type = GetItemData( *g2, item )
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
            
            *this = Create( *g2, "Spin", Type, 0, 0, 0, 0, "", Flag, min, max, 0, #__bar_button_size, 0, steps )
            
         Case #__type_String
            *this = Create( *g2, "String", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_CheckBox
            *this = Create( *g2, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", Flag, 0, 0, 0, 0, 0, 0 )
            
         Case #__type_Button
            Select item
               Case #_pi_align
                  CompilerIf Defined( AnchorBox, #PB_Module )
                     *this = AnchorBox::Create( *g2, 0,0,0,20 )
                  CompilerElse
                     *this = Create( *g2, "Button", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
                  CompilerEndIf
                  
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  *this = Create( *g2, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", Flag, 0, 0, 0, 0, 0, 0 )
                  
            EndSelect
            
         Case #__type_ComboBox
            *this = Create( *g2, "ComboBox", Type, 0, 0, 0, 0, "", Flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
            ;
            Select item
               Case #_pi_flag
                  
               Case #_pi_fontstyle
                  AddItem(*this, -1, "None")         
;                   If *this\ComboBar( )
;                      *this\ComboBar( )\mode\Checkboxes = 1
;                      *this\ComboBar( )\mode\optionboxes = 1
;                      ;    Flag( *this\ComboBar( ), #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
;                   EndIf
                  AddItem(*this, -1, "Bold")        ; Ўрифт будет выделен жирным
                  AddItem(*this, -1, "Italic")      ; Ўрифт будет набран курсивом
                  AddItem(*this, -1, "Underline")   ; Ўрифт будет подчеркнут (только дл€ Windows)
                  AddItem(*this, -1, "StrikeOut")   ; Ўрифт будет зачеркнут (только дл€ Windows)
                  AddItem(*this, -1, "HighQuality") ; Ўрифт будет в высококачественном режиме (медленнее) (только дл€ Windows)
                  
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
            PropertiesItems_StatusChange( *g1, item, #__s_3 )
            PropertiesItems_StatusChange( *g2, item, #__s_3 )
            
         Case #__event_Focus
            item = GetData( EventWidget( ))
            PropertiesItems_StatusChange( *g1, item, #__s_2 )
            PropertiesItems_StatusChange( *g2, item, #__s_2 )
            
            ;
            SetText( EventWidget( ), *g1\RowFocused( )\txt(0)\text )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*g1\scroll\v, GetState( *g1\scroll\v ) - WidgetEventData( ) )
            EndIf
            
      EndSelect
   EndProcedure
   
   ;-
   Procedure   PropertiesItems_StatusChange( *this._s_WIDGET, item, state )
      Protected._s_ROW *row = ItemID( *this, item )
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
      Protected._s_WIDGET *g1 = GetAttribute( *splitter, #PB_Splitter_FirstGadget)
      Protected._s_WIDGET *g2 = GetAttribute( *splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROW *row
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
                     Case *g1 
                        SetState(*g2, item)
                        SetState(*g1, item)
                        
                     Case *g2 
                        SetState(*g1, item)
                        SetState(*g2, item)
                  EndSelect
               EndIf
            EndIf
            SetActive( GetParent( *g))
            
         Case #__event_StatusChange
            If EnteredButton( ) ; Expanded/Collapsed
               Select *g
                  Case *g1 : SetItemState(*g2, WidgetEventItem( ), WidgetEventData( ))
                  Case *g2 : SetItemState(*g1, WidgetEventItem( ), WidgetEventData( ))
               EndSelect
            Else
               Properties_StatusChange( GetParent(*g), *g )
            EndIf
            
         Case #__event_ScrollChange
            Select *g
               Case *g2 
                  If GetState( *g1\scroll\v ) <> WidgetEventData( )
                     If SetState( *g1\scroll\v, WidgetEventData( ))
                        PropertiesButton_Resize( *g2 )
                     EndIf
                  EndIf
                  ;
               Case *g1 
                  If GetState( *g2\scroll\v ) <> WidgetEventData( )
                     SetState( *g2\scroll\v, WidgetEventData( ))
                  EndIf
            EndSelect
            
         Case #__event_Change
            If *g = *g2
               *row = WidgetEventData( )
               
               If Not *row\childrens
                  item = WidgetEventItem( )
                  PropertiesButton_Create( *g2, item )
                  PropertiesButton_Display( *g2 )
               EndIf
            EndIf
            
         Case #__event_Resize
            If *g = *g2
               PropertiesButton_Resize( *g2 )
            EndIf
            
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure   Properties_StatusChange( *splitter._s_WIDGET, *this._s_WIDGET )
      Protected *g1._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *g2._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROW *row = ItemID( *this, WidgetEventItem( ))
      Protected item, state
      
      ;
      If *row\childrens
         *row\ColorState( ) = #__s_0
         ;
         If *g2 = *this
            If *g1\RowFocused( )
               item = *g1\RowFocused( )\index 
               state = *g1\RowFocused( )\ColorState( )
            EndIf
         EndIf
         ;
         If *g1 = *this
            If *g2\RowFocused( )
               item = *g2\RowFocused( )\index 
               state = *g2\RowFocused( )\ColorState( )
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
            Case *g1 
               StatusChange( *g2, *row )
;                If GetState( *g2 ) <> *row\index
;                   PropertiesItems_StatusChange( *g2, *row\index, *row\ColorState( ) )
;                EndIf
            Case *g2 
               StatusChange( *g1, *row )
;                If GetState( *g1 ) <> *row\index
;                   PropertiesItems_StatusChange( *g1, *row\index, *row\ColorState( ) )
;                EndIf   
         EndSelect
      EndIf
   EndProcedure
   
   Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
      Protected *g1._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *g2._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      If mode
         AddItem( *g1, item, StringField(Text.s, 1, Chr(10)), -1, mode )
         AddItem( *g2, item, Text.s, -1, mode )
         ;     AddItem( *g2, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      Else
         AddItem( *g1, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
         AddItem( *g2, item, "", -1, mode )
      EndIf
      
      item = CountItems( *g1 ) - 1
      If mode = 0
         Define color_properties.q = $FFBF9CC3;$BE80817D
         Define fcolor_properties.q = $CA2E2E2E
         
         
         ;                      SetItemFont( *g1, item, font_properties)
         ;                      SetItemFont( *g2, item, font_properties)
         
         SetItemColor( *g1, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
         SetItemColor( *g2, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
         
         SetItemColor( *g1, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)
         SetItemColor( *g2, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)   
         
         SetItemColor( *g1, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)
         SetItemColor( *g2, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)   
      Else
         SetItemColor( *g1, item, #PB_Gadget_BackColor, $FFFEFEFE)
         SetItemColor( *g2, item, #PB_Gadget_BackColor, $FFFEFEFE )
      EndIf
      
      SetItemData( *g2, item, Type )
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
      Protected *g1._s_WIDGET = Tree(0,0,0,0, tflag)
      Protected *g2._s_WIDGET = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
      ;    *g1\padding\x = 10
      ;    *g2\padding\x = 10
      Protected *g._s_WIDGET
      *g = *g1
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      *g = *g2
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *g1,*g2, Flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_firstFixed )
      SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
      SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
      ;
      *splitter\bar\btn\round = 0
      *splitter\bar\btn\size = DPIScaled(5)
      *splitter\bar\btn\size + Bool( *splitter\bar\btn\size % 2 )
      SetState(*splitter, (position) ) ; похоже ошибка DPI
      
      ;
      SetClass(*g1\scroll\v, "first_v")
      SetClass(*g1\scroll\h, "first_h")
      SetClass(*g2\scroll\v, "second_v")
      SetClass(*g2\scroll\h, "second_h")
      
      ;
      Hide( *g1\scroll\v, 1 )
      Hide( *g1\scroll\h, 1 )
      Hide( *g2\scroll\h, 1 )
      
      ; CloseList( )
      
      SetColor( *splitter, #PB_Gadget_BackColor, -1, #PB_All )
      SetColor( *g1, #PB_Gadget_BackColor, $FF00FFFF)
      SetColor( *g2, #PB_Gadget_BackColor, $FF00FFFF)
      SetColor( *g1, #PB_Gadget_LineColor, $FFBF9CC3)
      SetColor( *g2, #PB_Gadget_LineColor, $FFBF9CC3)
      
      ;
      Bind(*splitter, @Properties_Events( ))
      Bind(*g1, @PropertiesItems_Events( ))
      Bind(*g2, @PropertiesItems_Events( ))
      
      ; draw и resize отдельно надо включать пока поэтому вот так
      Bind(*g2, @PropertiesItems_Events( ), #__event_Resize)
      ;Bind(*g2, @PropertiesItems_Events( ), #__event_Draw)
      ProcedureReturn *splitter
   EndProcedure
   
   
   ;-
   Procedure   widgets_events()
      Protected count
      
      Select WidgetEvent( )
         Case #__event_Up
            
            ;             If *g1\row
            ;                If *g1\EnteredRow( )
            ;                   Debug "e - " + *g1\EnteredRow( ) + " " + *g1\EnteredRow( )\text\string + " " + *g1\EnteredRow( )\press + " " + *g1\EnteredRow( )\enter + " " + *g1\EnteredRow( )\focus
            ;                EndIf
            ;                If *g1\PressedRow( )
            ;                   Debug "p - " + *g1\PressedRow( ) + " " + *g1\PressedRow( )\text\string + " " + *g1\PressedRow( )\press + " " + *g1\PressedRow( )\enter + " " + *g1\PressedRow( )\focus
            ;                EndIf
            ;                If *g1\RowFocused( )
            ;                   Debug "f - " + *g1\RowFocused( ) + " " + *g1\RowFocused( )\text\string + " " + *g1\RowFocused( )\press + " " + *g1\RowFocused( )\enter + " " + *g1\RowFocused( )\focus
            ;                EndIf
            ;             EndIf
            
            Debug "-------set-start-------"
            Select EventWidget( )
               Case *get : Debug GetState(*g1)
               Case *focus : SetActive(GetParent(*g1))
               Case *remove 
                  If *g1\RowFocused( )
                     Protected item = *g1\RowFocused( )\index
                     RemoveItem(*g1, item)
                     ; RemoveItem(*g2, item)
                  EndIf
                  
               Case *reset : SetState(*g1, - 1)
               Case *item1 : SetState(*g1, Val(GetText(EventWidget( ))))
               Case *item2 : SetState(*g1, Val(GetText(EventWidget( ))))
               Case *item3 : SetState(*g1, Val(GetText(EventWidget( ))))
               Case *item4 : SetState(*g1, Val(GetText(EventWidget( ))))
            EndSelect
            Debug "-------set-stop-------"
            
            ;             If *g1\row
            ;                If *g1\EnteredRow( )
            ;                   Debug "e - " + *g1\EnteredRow( ) + " " + *g1\EnteredRow( )\text\string + " " + *g1\EnteredRow( )\_press + " " + *g1\EnteredRow( )\_enter + " " + *g1\EnteredRow( )\_focus
            ;                EndIf
            ;                If *g1\PressedRow( )
            ;                   Debug "p - " + *g1\PressedRow( ) + " " + *g1\PressedRow( )\text\string + " " + *g1\PressedRow( )\_press + " " + *g1\PressedRow( )\_enter + " " + *g1\PressedRow( )\_focus
            ;                EndIf
            ;                If *g1\RowFocused( )
            ;                   Debug "f - " + *g1\RowFocused( ) + " " + *g1\RowFocused( )\text\string + " " + *g1\RowFocused( )\_press + " " + *g1\RowFocused( )\_enter + " " + *g1\RowFocused( )\_focus
            ;                EndIf
            ;             EndIf
            
      EndSelect
   EndProcedure
   
   
   ;-
   If Open(1, 100, 50, 370, 330, "second ListView state", #PB_Window_SystemMenu)
      ;       ;       ;Container(0, 0, 240, 330)
      ;       *g2 = Tree(10, 10, 220/2, 310) : SetClass(*g2, "g2")
      ;       *g1 = Tree(110, 10, 220/2, 310, #__flag_nolines) : SetClass(*g1, "g1")
      ;       
      ;       
      ;       ;*g1 = ListView(10, 10, 220, 310)
      ;       ;*g1 = Panel(10, 10, 230, 310) 
      ;       ;Debug *g2\scroll\v\hide 
      ;       Splitter(10,10, 230, 310, *g2, *g1, #PB_Splitter_Vertical )
      ;Debug *g2\scroll\v\hide 
      ;       ;
      ;       ;Hide( *g2\scroll\v, 1 )
      ;       Hide( HBar(*g2), #True )
      ;       Hide( HBar(*g1), #True )
      ;       Bind(Widget( ), @Properties_Events())
      ;       Bind(*g2, @PropertiesItems_Events());, #__event_Change)
      ;       Bind(*g1, @PropertiesItems_Events());, #__event_Change)
      
      ide_inspector_PROPERTIES = Properties_Create( 10,10, 230, 310 )
      *g1 = GetAttribute( ide_inspector_PROPERTIES, #PB_Splitter_FirstGadget)
      *g2 = GetAttribute( ide_inspector_PROPERTIES, #PB_Splitter_SecondGadget)
      
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
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 403
; FirstLine = 368
; Folding = ------------
; EnableXP
; DPIAware