; 
; second state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, *second._s_WIDGET, *first._s_widget, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *g1, *g2, CountItems=20;99; количесвто итемов 
   
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
      
      OpenList( *parent )
      *this = String( 0, 0, 0, 0, "test") 
      ; Debug GetClass(EventWidget( )) ; BUG
      CloseList( )
      
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
   Procedure   Properties_Events( )
      Static *test  
      Protected item, state
      Protected._s_ROWS *row
      Protected._s_WIDGET *g
      *g = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_LostFocus
            Debug "lost " + *g\class
            
         Case #__event_FOCUS
            If Not IsContainer(*g)
               If Not EnteredButton( )
                  *row = WidgetEventData( )
                  If *row
                     If Not *row\childrens
                        If SetState( *g, *row\index )
                           If *first <> *g
                              ChangeItemState( *first, *row\index, 2 )
                           EndIf
                           If *second <> *g
                              ChangeItemState( *second, *row\index, 2 )
                           EndIf
                           ;
                           PropertiesButton_Free( *test )
                           *test = PropertiesButton_Create( *second, *row\index )
                           PropertiesButton_Resize( *test )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            SetActive( *test )
            
         Case #__event_StatusChange
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               If *first = *g
                  If SetItemState(*second, WidgetEventItem( ), WidgetEventData( ))
                     PropertiesButton_Hide( *test )
                  EndIf
               EndIf
            EndIf
            
            ;
            If Not EnteredButton( )
               If PushItem( *g)
                  If SelectItem( *g, WidgetEventItem( ))
                     *row = *g\__rows( )
                  EndIf
                  PopItem( *g)
               EndIf
               
               If *row\childrens
                  If *second = *g
                     If *first\RowFocused( )
                        item = *first\RowFocused( )\index 
                        state = *first\RowFocused( )\ColorState( )
                     EndIf
                  EndIf
                  
                  If *first = *g
                     If *second\RowFocused( )
                        item = *second\RowFocused( )\index 
                        state = *second\RowFocused( )\ColorState( )
                     EndIf
                  EndIf
                  
                  ChangeItemState( *first, item, state )
                  ChangeItemState( *second, item, state )
                  
                  *row\ColorState( ) = #__s_0
                  *g\EnteredRow( ) = 0
                  
               Else
                  Select *g
                     Case *first 
                        If GetState( *second ) <> *row\index
                           ChangeItemState( *second, *row\index, *row\ColorState( ))
                        EndIf
                     Case *second 
                        If GetState( *first ) <> *row\index
                           ChangeItemState( *first, *row\index, *row\ColorState( ))
                        EndIf   
                  EndSelect
               EndIf
            EndIf
            
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
   If Open(1, 100, 50, 370, 330, "second ListView state", #PB_Window_SystemMenu)
      ;       ;Container(0, 0, 240, 330)
      *first = Tree(10, 10, 220/2, 310) : SetClass(*first, "first")
      *second = Tree(110, 10, 220/2, 310, #__flag_nolines|#__flag_nobuttons) : SetClass(*second, "second")
      ;
      Hide( HBar(*second), #True )
      Hide( HBar(*first), #True )
      Hide( VBar(*first), #True )
      
      
      ;*first = ListView(10, 10, 220, 310)
      ;*first = Panel(10, 10, 230, 310) 
      ;Debug *second\scroll\v\hide 
      Splitter(10,10, 230, 310, *first, *second, #PB_Splitter_Vertical )
      ;Debug *second\scroll\v\hide 
      
      Bind(Widget( ), @Properties_Events(), #__event_Focus)
      Bind(*second, @Properties_Events(), #__event_Resize)
      Bind(*second, @Properties_Events())
      Bind(*first, @Properties_Events())
      
      For a = 0 To CountItems
         If a % 10 = 0
            AddItem(*first, -1, "collaps "+Str(a), -1, 0)
         Else
            AddItem(*first, -1, "Item "+Str(a), -1, 1)
         EndIf
      Next
      For a = 0 To CountItems
         If a % 10 = 0
            AddItem(*second, -1, "collaps "+Str(a), -1, 0)
         Else
            AddItem(*second, -1, "Item "+Str(a), -1, 1)
         EndIf
      Next
      
      
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
      
      
      WaitClose()
      
      
      
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 84
; FirstLine = 108
; Folding = ---------
; EnableXP