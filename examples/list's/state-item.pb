; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, *demo._s_WIDGET, *test, *get, *remove, *focus, *reset, *item1, *item2, *item3, *item4, *this._s_widget, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   Procedure.b Properties_SetState( *this._S_widget, state.f )
      If GetState( *this ) = state
      ;   ProcedureReturn 0
      EndIf
      
      SetState( *this, state )
   EndProcedure
   
   Procedure Properties_StatusChange( *this._s_WIDGET, item )
      ; 
      If GetState( *this ) = item
         ProcedureReturn 0
      EndIf
      
      PushItem(EventWidget( ))
      If SelectItem( EventWidget( ), item)
         ;
         If EventWidget( )\__rows( ) 
            PushItem( *this )
            If SelectItem( *this, EventWidget( )\__rows( )\index)
               *this\__rows( )\color = EventWidget( )\__rows( )\color
               
               If *this\__rows( )\colorState( ) = #__s_2
                  If *this\RowFocused( )
                     *this\RowFocused( )\focus = 0
                     ;Debug *this\RowFocused( )\index
                  EndIf
                  *this\RowFocused( ) = *this\__rows( )
                  *this\RowFocused( )\focus = 1
               EndIf
            EndIf
            
            PopItem( *this )
         EndIf
      EndIf
      
      PopItem(EventWidget( ))
   EndProcedure
   
   ;-
   Procedure Properties_ButtonResize( *this._s_WIDGET )
      Protected *row._s_ROWS
      *row = *this\RowFocused( )
      If *row
         If *row\data
            If *row\hide
               If Not Hide( *row\data )
                  Hide( *row\data, #True )
               EndIf
            Else
               If Hide( *row\data )
                  Hide( *row\data, #False )
               EndIf
               ;
               Resize(*row\data,
                      *row\x, ; + *this\scroll_x( )
                      *row\y, ; + *this\scroll_y( )
                      *this\inner_width( )-2, 
                      *row\height, 0 )
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure Properties_ButtonDisplay( item )
      Protected *row._s_ROWS
      *row = *this\RowFocused( )
      If *row
         If *row\childrens
            If Not Hide( *row\data )
               Hide( *row\data, #True )
            EndIf
         Else
            If Hide( *row\data )
               Hide( *row\data, #False )
            EndIf
            ;
            Properties_ButtonResize( *this )
            SetText( *row\data, *row\text\string )
         EndIf
      EndIf
   EndProcedure
   
   Procedure Properties_ButtonEvents( )
      Select WidgetEvent( )
         Case #__event_Down
            GetActive( )\gadget = EventWidget( )
            
         Case #__event_MouseWheel
            If WidgetEventItem( ) > 0
               SetState(*this\scroll\v, GetState( *this\scroll\v ) - WidgetEventData( ) )
            EndIf
      EndSelect
   EndProcedure
   
   ;-
   Procedure widget_events()
      Select WidgetEvent( )
         Case #__event_Down
            ; чтобы выбирать сразу
            If Not EnteredButton( )
               Properties_SetState( EventWidget( ), WidgetEventItem( ))
            EndIf
            
         Case #__event_Change
            ;Debug "change  "+GetClass(EventWidget( )) +" "+ WidgetEventData( )
            
            ;
            Properties_ButtonDisplay( WidgetEventItem( ) )
            
            ; Debug "-------change-start-------"
            Select EventWidget( )
               Case *demo : Properties_SetState(*this, WidgetEventItem( ))
               Case *this : Properties_SetState(*demo, WidgetEventItem( ))
            EndSelect
            ; Debug "-------change-stop-------"
            
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
            
            ; изменять цвета только у выделеных итемов
            ; If Not CanvasMouseButton( ) : ProcedureReturn : EndIf
            
            ;
            Select EventWidget( )
               Case *demo : Properties_StatusChange(*this, WidgetEventItem( ))
               Case *this : Properties_StatusChange(*demo, WidgetEventItem( ))
            EndSelect
            
            ;             ; Case #__event_LostFocus
            ;             If WidgetEventData( ) = 3
            ;                If GetActive( ) <> EventWidget( )
            ;                   Debug "set active "+GetClass(EventWidget( ))
            ;                   SetActive( EventWidget( ))
            ;                EndIf
            ;             EndIf
            
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
         Case #__event_Resize, ;#__event_Properties_StatusChange,
              #__event_ScrollChange
            ;Debug 77
            Properties_ButtonResize( *this )
            
      EndSelect
      
   EndProcedure
   
   Procedure button_events()
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
               Case *focus : SetActive(*this)
               Case *remove 
                  If *this\RowFocused( )
                     Protected item = *this\RowFocused( )\index
                     RemoveItem(*this, item)
                     ; RemoveItem(*demo, item)
                  EndIf
                  
               Case *reset : Properties_SetState(*this, - 1)
               Case *item1 : Properties_SetState(*this, Val(GetText(EventWidget( ))))
               Case *item2 : Properties_SetState(*this, Val(GetText(EventWidget( ))))
               Case *item3 : Properties_SetState(*this, Val(GetText(EventWidget( ))))
               Case *item4 : Properties_SetState(*this, Val(GetText(EventWidget( ))))
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
      
      Bind(*demo, @widget_events());, #__event_Change)
      Bind(*this, @widget_events());, #__event_Change)
      
      OpenList( *this )
      ; *test = String( 0, 0, 0, 0, "test") ; #__flag_TextCenter| bug
      ;*test = String( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
      *test = Button( 0, 0, 0, 0, "test", #__flag_NoFocus) ; #__flag_TextCenter| bug
      
      Bind( *test, @Properties_ButtonEvents( ))                       ;, #__event_Change)
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
      
      
      
      Bind(*remove, @button_events(), #__event_Up)
      Bind(*focus, @button_events(), #__event_Up)
      Bind(*get, @button_events(), #__event_Up)
      
      Bind(*reset, @button_events(), #__event_Up)
      Bind(*item1, @button_events(), #__event_Up)
      Bind(*item2, @button_events(), #__event_Up)
      Bind(*item3, @button_events(), #__event_Up)
      Bind(*item4, @button_events(), #__event_Up)
      
      
;       ReDraw(root())
;       ;Unbind(*w2, @widget_events())
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
; CursorPosition = 19
; FirstLine = 16
; Folding = -----f--
; EnableXP