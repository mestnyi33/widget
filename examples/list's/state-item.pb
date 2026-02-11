; 
; second state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
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

   Global._s_widget *splitter, *second, *first
   Global a, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   ;- DECLARE
   Declare PropertiesButton_Events( )
   
   ;-
   Procedure   PropertiesButton_Hide( *this._s_WIDGET )
      Protected._s_ROWS *row
      If *this
         *row = *this\parent\RowFocused( ) 
         If *row
            Hide(*this, *row\hide)
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Free( *this._s_WIDGET )
      If *this
         Unbind( *this, @PropertiesButton_Events( ))
         Free( @*this )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Resize( *this._s_WIDGET  )
      Protected._s_ROWS *row
      Protected result
      If *this
         *row = *this\parent\RowFocused( )
         If *row
            result = Resize(*this,
                            *row\x,
                            *row\y + *this\parent\scroll_y( ),
                            *this\parent\inner_width( ),
                            *row\height, 0 )
         EndIf
         ProcedureReturn result
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *parent._s_WIDGET, item )
      Protected Type = GetItemData( *parent, item )
      Protected min, max, steps, Flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
      Protected._s_WIDGET *this
      
; ;       OpenList( *parent )
; ;       *this = String( 0, 0, 0, 0, "test") 
; ;       ; Debug GetClass(EventWidget( )) ; BUG
; ;       CloseList( )
;       max = 200
;       *this = Create( *parent, Str(Type), Type, 0, 0, 0, 0, "", Flag, 0, max, 0, #__bar_button_size, 0, 0 )
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
         
         *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, "", Flag, min, max, 0, #__bar_button_size, 0, steps )
;          OpenList( *parent )
;          *this = Spin( 0,0,0,0, min,max,flag, 0, steps )
;          CloseList( )
         
      Case #__type_String
         *this = Create( *parent, "String", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_CheckBox
         *this = Create( *parent, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", Flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_Button
         Select item
            Case #_pi_align
               ; *this = AnchorBox::Create( *parent, 0,0,0,20 )
               *this = Create( *parent, Str(Type), Type, 0, 0, 0, 0, "", Flag, 0, max, 0, #__bar_button_size, 0, 0 )
       
            Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
               *this = Create( *parent, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", Flag, 0, 0, 0, 0, 0, 0 )
               
         EndSelect
         
      Case #__type_ComboBox
         *this = Create( *parent, "ComboBox", Type, 0, 0, 0, 0, "", Flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
         ;
         Select item
            Case #_pi_flag
               Flag( *this, #__flag_CheckBoxes|#__flag_optionboxes )
               
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
         SetData( *this, item )
         Bind( *this, @PropertiesButton_Events( ))
      EndIf
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure   PropertiesButton_Display( *parent._s_WIDGET, *this._s_WIDGET, item )
      PropertiesButton_Free( *this )
      *this = PropertiesButton_Create( *parent, item )
      PropertiesButton_Resize( *this )
      Debug 444
      SetText( *this, Str(item))
      ProcedureReturn *this
   EndProcedure
   
   Procedure   PropertiesButton_Events( )
      Select WidgetEvent( )
         Case #__event_Input
            Debug "test "+keyboard( )\input
            
         Case #__event_Focus
            ; Debug "test focus"
            ChangeItemState( *first, GetData( EventWidget( )), 2 )
            ChangeItemState( *second, GetData( EventWidget( )), 2 )
            
         Case #__event_LostFocus
            ChangeItemState( *first, GetData( EventWidget( )), 3 )
            ChangeItemState( *second, GetData( EventWidget( )), 3 )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*second\scroll\v, GetState( *second\scroll\v ) - WidgetEventData( ) )
            EndIf
      EndSelect
   EndProcedure
   
   ;-
   Procedure   Properties_Status( *splitter._s_WIDGET, *this._s_WIDGET, item )
      Protected._s_WIDGET *first = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected._s_WIDGET *second = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      Protected._s_ROWS *row
      Protected state
      
      ;
      If PushItem( *this )
         If SelectItem( *this, Item)
            *row = *this\__rows( )
         EndIf
         PopItem( *this)
      EndIf
      
      ; чтобы не виделялся
      If MouseDrag( )
         If *this\RowFocused( ) = *row 
            *row\focus = 1
            *row\ColorState( ) = #__s_2
         Else
            *row\focus = 0
            *row\ColorState( ) = #__s_0
         EndIf
         ProcedureReturn
      EndIf
      
      ;
      If *row\data
         Select *this
            Case *first 
               If GetState( *second ) <> *row\index
                  ChangeItemState( *second, *row\index, *row\ColorState( ))
               EndIf
            Case *second 
               If GetState( *first ) <> *row\index
                  ChangeItemState( *first, *row\index, *row\ColorState( ))
               EndIf   
         EndSelect
         
      Else
         Select *this
            Case *first 
               If *second\RowFocused( )
                  item = *second\RowFocused( )\index
                  state = *second\RowFocused( )\ColorState( ) 
               EndIf
               
            Case *second 
               If *first\RowFocused( )
                  item = *first\RowFocused( )\index
                  state = *first\RowFocused( )\ColorState( ) 
               EndIf
         EndSelect
         
         If GetState( *this ) <> item
            ChangeItemState( *this, item, state )
         EndIf
         
         *row\focus = 0
         *row\ColorState( ) = #__s_0
      EndIf
      
   EndProcedure
   
   Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=0, mode=0 )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      Protected *this._s_WIDGET
      Protected._s_ROWS *row
      
      If mode
         *row = AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
      Else
         *row = AddItem( *first, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
      EndIf
      ;
      If *row\parent
         *row\color\back = - 1
         *row\parent\color\back = $D4C8C8C8
      Else
         *row\color\back = $D4C8C8C8
      EndIf
      *row\data = Type
      
      *row = AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      ;
      If *row\parent
         *row\color\back = - 1
         *row\parent\color\back = $D4C8C8C8
      Else
         *row\color\back = $D4C8C8C8
      EndIf
      *row\data = Type
      
   EndProcedure
   
   Procedure   Properties_Events( )
      Static *test  
      Protected._s_ROWS *row
      Protected._s_WIDGET *g
      *g = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_LostFocus
            ; Debug "lost " + *g\class
            
         Case #__event_FOCUS
            If Not IsContainer(*g)
               If Not EnteredButton( )
                  *row = WidgetEventData( )
                  If *row
                     If SetState( *g, *row\index )
                        If *row\data
                           If *first <> *g
                              ChangeItemState( *first, *row\index, 2 )
                           EndIf
                           If *second <> *g
                              ChangeItemState( *second, *row\index, 2 )
                           EndIf
                           
                           PropertiesButton_Free( *test )
                           *test = PropertiesButton_Create( *second, *row\index )
                           PropertiesButton_Resize( *test )
                           SetState( *test, *row\index)
      
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            SetActive( *test )
            
         Case #__event_Change
            If Not MousePress( ) 
               *row = WidgetEventData( )
               If *row
                  If Not *row\data
                     If *row\focus
                        Properties_Status( GetParent(*g), *g, WidgetEventItem( ))
                     EndIf
                  EndIf
                  ;
                  If *g\RowFocused( )
                     If *g\RowFocused( )\ColorState( ) = #__s_3
                        *g\RowFocused( )\ColorState( ) = #__s_2
                     EndIf
                  EndIf
               EndIf
            EndIf
            
         Case #__event_Up
            If Not EnteredButton( )
               *row = WidgetEventData( )
               If *row 
                  ;                   If *test
                  ;                      SetState( *g, GetData( *test ))
                  ;                   Else
                  ;                   EndIf
                  *row = *g\RowEntered( )
;                   If *row
;                      If  *row\data
;                         If *first <> *g
;                            ChangeItemState( *first, *row\index, 2 )
;                         EndIf
;                         If *second <> *g
;                            ChangeItemState( *second, *row\index, 2 )
;                         EndIf
;                         PropertiesButton_Free( *test )
;                         *test = PropertiesButton_Create( *second, *row\index )
;                         PropertiesButton_Resize( *test )
;                         SetActive( *test )
;                      EndIf
;                   EndIf
                  
               EndIf
            EndIf
            
         Case #__event_StatusChange
            If *first = *g
               If WidgetEventData( ) = #PB_Tree_Expanded Or
                  WidgetEventData( ) = #PB_Tree_Collapsed
                  ;
                  If SetItemState(*second, WidgetEventItem( ), WidgetEventData( ))
                     PropertiesButton_Hide( *test )
                  EndIf
               EndIf
            EndIf
            ;
            Properties_Status( GetParent(*g), *g, WidgetEventItem( ))
            
         Case #__event_ScrollChange
            Select *g
               Case *first 
                  If GetState( *second\scroll\v ) <> WidgetEventData( )
                     SetState(*second\scroll\v, WidgetEventData( ) )
                  EndIf
               Case *second 
                  If GetState( *first\scroll\v ) <> WidgetEventData( )
                     SetState(*first\scroll\v, WidgetEventData( ) )
                  EndIf
                  ;
                  PropertiesButton_Resize( *test ) 
            EndSelect
            
         Case #__event_Resize
            If *second = *g
               PropertiesButton_Resize( *test )
            EndIf
            
      EndSelect
   EndProcedure
   
   ;-
   Procedure widgets_events()
      Protected count
      
      Select WidgetEvent( )
         Case #__event_Up
            Select EventWidget( )
               Case *get : Debug GetState(*second)
               Case *focus : SetActive(GetParent(*second))
               Case *remove 
                  If *second\RowFocused( )
                     Protected item = *second\RowFocused( )\index
                     RemoveItem(*second, item)
                     ; RemoveItem(*second, item)
                  EndIf
                  
               Case *reset : SetState(*second, - 1)
               Case *item1 : SetState(*second, Val(GetText(EventWidget( ))))
               Case *item2 : SetState(*second, Val(GetText(EventWidget( ))))
               Case *item3 : SetState(*second, Val(GetText(EventWidget( ))))
               Case *item4 : SetState(*second, Val(GetText(EventWidget( ))))
            EndSelect
            
      EndSelect
   EndProcedure
   
   ;-
   Define h = 418
   If Open(1, 100, 50, 370, h, "second ListView state", #PB_Window_SystemMenu)
      ;       ;Container(0, 0, 240, h)
      *first = Tree(0,0,0,0) : SetClass(*first, "first")
      *second = Tree(0,0,0,0, #__flag_nolines|#__flag_nobuttons) : SetClass(*second, "second")
      ;
      Hide( HBar(*second), #True )
      Hide( HBar(*first), #True )
      ;Hide( VBar(*first), #True )
      
      
      ;*first = ListView(10, 10, 220, 310)
      ;*first = Panel(10, 10, 230, 310) 
      ;Debug *second\scroll\v\hide 
      *splitter = Splitter(10,10, 230, h-20, *first, *second, #PB_Splitter_Vertical )
      ;Debug *second\scroll\v\hide 
      
      Bind(*splitter, @Properties_Events(), #__event_Focus)
      Bind(*second, @Properties_Events(), #__event_Resize)
      Bind(*second, @Properties_Events())
      Bind(*first, @Properties_Events())
      
;          Properties_AddItem(*splitter, -1, "collaps "+Str(0), -1, 0)
;          Properties_AddItem(*splitter, -1, "Item "+Str(1), -1, 1)
;          Properties_AddItem(*splitter, -1, "Item collaps"+Str(2), -1, 1)
;          Properties_AddItem(*splitter, -1, "Item "+Str(21), -1, 2)
;          Properties_AddItem(*splitter, -1, "Item "+Str(22), -1, 2)
;          Properties_AddItem(*splitter, -1, "Item "+Str(23), -1, 2)
;          Properties_AddItem(*splitter, -1, "Item "+Str(3), -1, 1)
;          Properties_AddItem(*splitter, -1, "collaps "+Str(4), -1, 0)
;          
;       For a = 0 To CountItems
;          If a % 10 = 0
;             Properties_AddItem(*splitter, -1, "collaps "+Str(a), -1, 0)
;          Else
;             Properties_AddItem(*splitter, -1, "Item "+Str(a), -1, 1)
;          EndIf
;       Next
         If *splitter
            Properties_AddItem( *splitter, #_pi_group_COMMON, "COMMON" )
            Properties_AddItem( *splitter, #_pi_ID,             "#ID",      #__Type_ComboBox, 1 )
            Properties_AddItem( *splitter, #_pi_class,          "Class",    #__Type_String, 1 )
            Properties_AddItem( *splitter, #_pi_text,           "Text",     #__Type_String, 1 )
            Properties_AddItem( *splitter, #_pi_IMAGE,          "Image",    #__Type_Button, 1 )
            ;
            Properties_AddItem( *splitter, #_pi_group_LAYOUT, "LAYOUT" )
            Properties_AddItem( *splitter, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__Type_Button, 1 )
            Properties_AddItem( *splitter, #_pi_x,              "X",        #__Type_Spin, 1 )
            Properties_AddItem( *splitter, #_pi_y,              "Y",        #__Type_Spin, 1 )
            Properties_AddItem( *splitter, #_pi_width,          "Width",    #__Type_Spin, 1 )
            Properties_AddItem( *splitter, #_pi_height,         "Height",   #__Type_Spin, 1 )
            ;
            Properties_AddItem( *splitter, #_pi_group_VIEW,   "VIEW" )
            Properties_AddItem( *splitter, #_pi_cursor,         "Cursor",   #__Type_ComboBox, 1 )
            Properties_AddItem( *splitter, #_pi_hide,           "Hide",     #__Type_ComboBox, 1 )
            Properties_AddItem( *splitter, #_pi_disable,        "Disable",  #__Type_ComboBox, 1 )
            ;
            Properties_AddItem( *splitter, #_pi_flag,          "Flag",      #__Type_ComboBox, 1 )
            ;
            Properties_AddItem( *splitter, #_pi_FONT,           "Font",     #__Type_Button, 1 )
            Properties_AddItem( *splitter, #_pi_fontsize,       "size",     #__Type_Spin, 2 )
            Properties_AddItem( *splitter, #_pi_fontstyle,      "style",    #__Type_ComboBox, 2 )
            ;
            Properties_AddItem( *splitter, #_pi_COLOR,           "Color",   #__Type_Button, 1 )
            Properties_AddItem( *splitter, #_pi_colortype,       "type",    #__Type_ComboBox, 2 )
            Properties_AddItem( *splitter, #_pi_colorstate,      "state",    #__Type_ComboBox, 2 )
            Properties_AddItem( *splitter, #_pi_coloralpha,      "alpha",   #__Type_Spin, 2 )
            Properties_AddItem( *splitter, #_pi_colorblue,       "blue",    #__Type_Spin, 2 )
            Properties_AddItem( *splitter, #_pi_colorgreen,      "green",   #__Type_Spin, 2 )
            Properties_AddItem( *splitter, #_pi_colorred,        "red",     #__Type_Spin, 2 )
            Properties_AddItem( *splitter, -1,        "others" )
         EndIf
   
      
      If IsContainer(*second)
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
      
      
      Debug "--------"
      Hide( VBar(*first), #True )
      Repaint( )
      ;Define._s_WIDGET *this = *first\scroll\h
      Define._s_WIDGET *this = *second\scroll\h
      Define._s_BAR *bar = *this\bar
      Debug "["+ *this\class +"] "+;mode +" >< "+;*bar\PageChange( ) +" >< "+
            *bar\percent +" >< "+
            *bar\min +" "+
            *bar\max +" >< "+
            *bar\page\pos +" "+
            *bar\page\len +" "+
            *bar\page\end +" >< "+
            *bar\area\pos +" "+
            *bar\area\len +" "+
            *bar\thumb\end +" >< "+
            *bar\thumb\pos +" "+
            *bar\thumb\len +" "+
            *bar\area\end +" "
      Debug "<<<<<<<<<<<<<<<<<"
      
           
      WaitClose()
      
      
      
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 586
; FirstLine = 440
; Folding = 0+c--------+
; EnableXP