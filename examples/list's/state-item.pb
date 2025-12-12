; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, *demo._s_WIDGET, *this._s_widget, *test, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   ;- DECLARE
   Declare PropertiesItems_ChangeStatus( *this._s_WIDGET, item, state )
   Declare PropertiesButton_Events( )
   
   ;-
   Procedure   PropertiesButton_Resize( *row._s_ROWS, scroll_y, inner_width )
      Protected result
      If *row
         result = Resize(*test,
                               *row\x,
                               *row\y + scroll_y,
                               inner_width,
                               *row\height, 0 )
      EndIf
      ProcedureReturn result
   EndProcedure
   
   Procedure PropertiesButton_SetActive( *this._s_WIDGET )
      Protected._s_ROWS *row = *this\RowFocused( )
      
      If *row
         If *test
            ; Debug " data "+*row\rindex
            SetData( *test, *row\rindex )
            SetActive( *test )
         EndIf
      EndIf
   EndProcedure
   
   Procedure PropertiesButton_Display( *g._s_WIDGET )
      Protected._s_ROWS *row = *g\RowFocused( )
      
      If *row
         If *test 
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
                  If PropertiesButton_Resize(*row, *g\scroll_y( ), *g\inner_width( ))
                     ProcedureReturn *test
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *parent._s_WIDGET, item )
      Protected *this._s_WIDGET
      Protected min, max, steps, flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
      Protected Type = GetItemData( *parent, item )
      
      OpenList( *parent )
         *this = String( 0, 0, 0, 0, "test") 
      CloseList( )
      
      If *this
         *test = *this
         SetData(*this, item)
         ; SetItemData(*parent, item, *this)
         Bind(*this, @PropertiesButton_Events( ))
      EndIf
      
      ProcedureReturn *this
   EndProcedure
   
   Procedure PropertiesButton_Events( )
      Select WidgetEvent( )
         Case #__event_Input
            Debug "button "+keyboard( )\input
            
         Case #__event_LostFocus
            PropertiesItems_ChangeStatus( *this, GetData( EventWidget( )), 3 )
            PropertiesItems_ChangeStatus( *demo, GetData( EventWidget( )), 3 )
            
         Case #__event_Focus
            PropertiesItems_ChangeStatus( *this, GetData( EventWidget( )), 2 )
            PropertiesItems_ChangeStatus( *demo, GetData( EventWidget( )), 2 )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*this\scroll\v, GetState( *this\scroll\v ) - WidgetEventData( ) )
            EndIf
      EndSelect
   EndProcedure
   
   ;-
   Procedure PropertiesItems_ChangeStatus( *this._s_WIDGET, item, state )
      Protected._s_ROWS *item = ItemID( *this, item )
      If *item 
         *item\ColorState( ) = state
         ProcedureReturn *item
      EndIf
   EndProcedure
   
   Procedure PropertiesItems_Events()
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
               PropertiesButton_Display( *this )
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
                  Debug "ScrollChange " + WidgetEventData( )
                  PropertiesButton_Resize( *this\RowFocused( ), *this\scroll_y( ), *this\inner_width( ))
            EndSelect
            
         Case #__event_Resize
            If *this = EventWidget( )
               Debug "Resize "
               PropertiesButton_Resize( *this\RowFocused( ), *this\scroll_y( ), *this\inner_width( ))
            EndIf
            
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure Properties_Events( )
      Select WidgetEvent( )
         Case #__event_Input
            Debug "splitter "+keyboard( )\input
            
         Case #__event_FOCUS
            If *this\RowFocused( )
               PropertiesButton_SetActive( *this )
            EndIf
            
      EndSelect
   EndProcedure
   
   ;-
   Procedure widgets_events()
      Protected count
      
      Select WidgetEvent( )
         Case #__event_Up
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
             
      EndSelect
   EndProcedure
   
   ;-
   If Open(1, 100, 50, 370, 330, "demo ListView state", #PB_Window_SystemMenu)
      ;       ;Container(0, 0, 240, 330)
      *demo = Tree(10, 10, 220/2, 310) : SetClass(*demo, "demo")
      *this = Tree(110, 10, 220/2, 310, #__flag_nolines) : SetClass(*this, "this")
      ;
      ;Hide( *demo\scroll\v, 1 )
      Hide( HBar(*demo), #True )
      Hide( HBar(*this), #True )
      
      
      ;*this = ListView(10, 10, 220, 310)
      ;*this = Panel(10, 10, 230, 310) 
      ;Debug *demo\scroll\v\hide 
      Splitter(10,10, 230, 310, *demo, *this, #PB_Splitter_Vertical )
      ;Debug *demo\scroll\v\hide 
      
      Bind(Widget( ), @Properties_Events())
      Bind(*demo, @PropertiesItems_Events());, #__event_Change)
      Bind(*this, @PropertiesItems_Events());, #__event_Change)
      
      *test = PropertiesButton_Create( *this, 2 )
      
      For a = 0 To CountItems
         If a % 10 = 0
            AddItem(*demo, -1, "collaps "+Str(a), -1, 0)
         Else
            AddItem(*demo, -1, "Item "+Str(a), -1, 1)
         EndIf
      Next
      For a = 0 To CountItems
         If a % 10 = 0
            AddItem(*this, -1, "collaps "+Str(a), -1, 0)
         Else
            AddItem(*this, -1, "Item "+Str(a), -1, 1)
         EndIf
         SetItemData( *this, a, *test )
      Next
      
      
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
      
      
      WaitClose()
      
      
      
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 349
; FirstLine = 322
; Folding = ----------
; EnableXP