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
   
   ;-
   Declare PropertiesItems_ChangeStatus( item, state )
   Procedure PropertiesButton_SetActive( *this._s_WIDGET )
      Protected._s_ROWS *row = *this\RowFocused( )
      
      If *row
         If *row\data
            SetData( *row\data, *row\rindex )
            SetActive( *row\data )
         EndIf
      EndIf
   EndProcedure
   
   Procedure PropertiesButton_Display( *g._s_WIDGET )
      Protected._s_ROWS *row = *g\RowFocused( )
      
      If *row
         If *row\data
            ;
            If *row\hide Or *row\childrens
               If Hide( *row\data ) = 0
                  Hide( *row\data, #True )
               EndIf
            Else
               If Hide( *row\data )
                  Hide( *row\data, #False )
               EndIf
               ;
               If Not Resize(*row\data,
                             *row\x+10, ; + *g\scroll_x( )
                             *row\y + *g\scroll_y( ),
                             *g\inner_width( )-20, 
                             *row\height, 0 )
                  
                  SetText( *row\data, *row\text\string )
               Else
                  ProcedureReturn *row\data
               EndIf
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure PropertiesButton_Events( )
      Select WidgetEvent( )
         Case #__event_Input
            Debug "button "+keyboard( )\input
      
         Case #__event_LostFocus
            PropertiesItems_ChangeStatus( GetData( EventWidget( ) ), 3 )
            
         Case #__event_Focus
           ; SetActive( GetParent( EventWidget( )))
            PropertiesItems_ChangeStatus( GetData( EventWidget( ) ), 2 )
            
         Case #__event_Down
           ; GetActive( )\gadget = EventWidget( )
            
         Case #__event_MouseWheel
            If MouseDirection( ) > 0
               SetState(*this\scroll\v, GetState( *this\scroll\v ) - WidgetEventData( ) )
            EndIf
      EndSelect
   EndProcedure
   
   ;-
   Procedure PropertiesItems_ChangeStatus( item, state )
      Protected._s_ROWS *titem, *eitem 
      *titem = ItemID( *this, item )
      *eitem = ItemID( *demo, item )
      
      If *titem And *eitem
;          *this\focus = state
;          *demo\focus = state
         *titem\colorState( ) = state
         *eitem\colorState( ) = state
      EndIf
   EndProcedure

   Procedure PropertiesItems_ChangeColor( *this._s_WIDGET, item )
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
         
         Debug "" + *this\class +" "+ *g\class +" "+item +" "+ *this\__rows( )\colorState( ) +" "+ *g\__rows( )\colorState( )
        ; *this\__rows( )\color = *g\__rows( )\color
;          If Not *this\__rows( )\press 
            *this\__rows( )\colorState( ) = *g\__rows( )\colorState( )
;          Else
;             *g\__rows( )\colorState( ) = *this\__rows( )\colorState( )
;          EndIf
         
;          If *this\__rows( )\colorState( ) = #__s_2
;             If *this\RowFocused( )
;                *this\RowFocused( )\focus = 0
;             EndIf
;             *this\RowFocused( ) = *this\__rows( )
;             *this\RowFocused( )\focus = 1
;          EndIf
;          
         PopListPosition( *this\__rows( ) )
      EndIf
      PopListPosition(*g\__rows( ))
      
   EndProcedure
   
   Procedure PropertiesItems_Events()
      Select WidgetEvent( )
            ;             ; Case #__event_LostFocus
            ;             If WidgetEventData( ) = 3
            ;                If GetActive( ) <> EventWidget( )
            ;                   Debug "set active "+GetClass(EventWidget( ))
            ;                   SetActive( EventWidget( ))
            ;                EndIf
            ;             EndIf
            
         Case #__event_Focus
            ; SetActive( GetParent( EventWidget( )))
            
         Case #__event_Down
            ; чтобы выбирать сразу
            If Not EnteredButton( )
               Select EventWidget( )
                  Case *demo 
                     SetState(*this, WidgetEventItem( ))
                     SetState(*demo, WidgetEventItem( ))
                  Case *this 
                     SetState(*demo, WidgetEventItem( ))
                     SetState(*this, WidgetEventItem( ))
               EndSelect
               
;                If SetState( EventWidget( ), WidgetEventItem( ))
                   PropertiesButton_SetActive( *this )
                   ;                EndIf
                   PropertiesItems_ChangeStatus( WidgetEventItem( ), 2 )
                EndIf
            
         Case #__event_Change
            If PropertiesButton_Display( *this )
               ; PropertiesButton_SetActive( *this )
            Else
;                Select EventWidget( )
;                   Case *demo : SetState(*this, WidgetEventItem( ))
;                   Case *this : SetState(*demo, WidgetEventItem( ))
;                EndSelect
            EndIf
            
         Case #__event_StatusChange
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               
               ;                ;
               ;                If *this\RowFocused( ) 
               ;                   If *this\RowFocused( )\data
               ;                      If *this\RowFocused( )\index = WidgetEventItem( )
               ;                         Debug 8765678
               ;                         Hide( *this\RowFocused( )\data, Bool( WidgetEventData( ) = #PB_Tree_Collapsed ))
               ;                      EndIf
               ;                   EndIf
               ;                EndIf
               
               ;
               Select EventWidget( )
                  Case *demo : SetItemState(*this, WidgetEventItem( ), WidgetEventData( ))
                  Case *this : SetItemState(*demo, WidgetEventItem( ), WidgetEventData( ))
               EndSelect
            EndIf
            
            ;
            Select EventWidget( )
               Case *demo : PropertiesItems_ChangeColor(*this, WidgetEventItem( ))
               Case *this : PropertiesItems_ChangeColor(*demo, WidgetEventItem( ))
            EndSelect
            
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *demo 
                  If GetState( *this\scroll\v ) <> WidgetEventData( )
                     SetState(*this\scroll\v, WidgetEventData( ) )
                  EndIf
               Case *this 
                  If GetState( *demo\scroll\v ) <> WidgetEventData( )
                     SetState(*demo\scroll\v, WidgetEventData( ) )
                  EndIf
            EndSelect
            
            ;Debug "scroll change"
      EndSelect
      
      ;
      Select WidgetEvent( )
         Case #__event_Resize,
              #__event_ScrollChange
            PropertiesButton_Display( *this )
            
      EndSelect
      
   EndProcedure
   
   ;-
   Procedure Properties_Events( )
      Select WidgetEvent( )
         Case #__event_Input
            Debug "splitter "+keyboard( )\input
            
         Case #__event_FOCUS
            If Not *this\RowFocused( )
               SetState( *this, 1 )
            EndIf
            PropertiesButton_SetActive( *this )
            
      EndSelect
   EndProcedure
   
   ;-
   Procedure widgets_events()
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
      
      OpenList( *this )
      *test = String( 0, 0, 0, 0, "test") ; #__flag_TextCenter| bug
      ;*test = String( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
      ; *test = Button( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
      
      Bind( *test, @PropertiesButton_Events( ))                       ;, #__event_Change)
      CloseList( )
      
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
; CursorPosition = 146
; FirstLine = 106
; Folding = ----+---
; EnableXP
; DPIAware