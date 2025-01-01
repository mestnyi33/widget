; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *demo._s_WIDGET, *test, *get, *focus, *reset, *item1, *item2, *item3, *item4, *this._s_widget, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   Procedure.b SetState_( *this._S_widget, state.f )
      SetState( *this, state )
   EndProcedure
   
   
   Procedure StatusChange( *this._s_WIDGET, item )
      PushListPosition(EventWidget( )\__rows( ))
      SelectElement( EventWidget( )\__rows( ), item)
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
   EndProcedure
   
   Procedure ResizePropertiesItem( *second._s_WIDGET )
      Protected *this._s_WIDGET
      Protected *row._s_ROWS
      
      *row = *second\RowFocused( )
      If *row
         *this = *row\data
         ;
         If *this
;             Resize(*this,
;                    *row\x + *second\scroll_x( ),; +30, 
;                    *row\y + *second\scroll_y( ), 
;                    *row\width,;*second\inner_width( ),;; -30, 
;                    *row\height, 0 )
            Debug ""+*row\width +" "+ *row\height ;*second\scroll\v\bar\page\pos
            Resize(*this,
                   *row\x + *second\scroll_x( ), 
                   *row\y + *second\scroll_y( ), 
                   *second\inner_width( )-4, 
                   *row\height, 0 )
            
;             *this\x[7] = *this\x
;             *this\y[7] = *this\y
;             *this\width[7] = *this\width
;             *this\height[7] = *this\height
;             *this\x[8] = *this\x
;             *this\y[8] = *this\y
;             *this\width[8] = *this\width
;             *this\height[8] = *this\height
;             
         EndIf
      EndIf
   EndProcedure

   
   Procedure widget_events()
      If WidgetEvent( ) <> #__event_mousemove
         ;If WidgetEventData( ) = 1
          ;  Debug ""+ WidgetEventData( ) +" "+ classfromevent(WidgetEvent( )) +" "+ WidgetEventItem( ) +" "+ GetClass(EventWidget( ))
         ;EndIf
      EndIf
      
      Select WidgetEvent( )
         Case #__event_Down
;             Select EventWidget( )
;                Case *demo : SetState_(*this, WidgetEventItem( ))
;                Case *this : SetState_(*demo, WidgetEventItem( ))
;             EndSelect
            SetState_( EventWidget( ), WidgetEventItem( ))
            
            
         Case #__event_StatusChange
            ; 
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               Select EventWidget( )
                  Case *demo : SetItemState(*this, WidgetEventItem( ), WidgetEventData( ))
                  Case *this : SetItemState(*demo, WidgetEventItem( ), WidgetEventData( ))
               EndSelect
            EndIf
            
            ; изменять цвета только у выделеных итемов
            ; If Not MouseButtons( ) : ProcedureReturn : EndIf
            
            Select EventWidget( )
               Case *demo : StatusChange(*this, WidgetEventItem( ))
               Case *this : StatusChange(*demo, WidgetEventItem( ))
            EndSelect
            ;  SetItemState( *demo, WidgetEventItem( ), 1)
            
         ; Case #__event_LostFocus
            If WidgetEventData( ) = 3
               If GetActive( ) <> EventWidget( )
                  Debug "set active "+GetClass(EventWidget( ))
                  SetActive( EventWidget( ))
               EndIf
            EndIf
            
         Case #__event_Change
             Debug "change  "+GetClass(EventWidget( )) +" "+ WidgetEventData( )
           SetItemData( *this, WidgetEventItem( ), *test )
            ResizePropertiesItem( *this )
            ; Debug ""+WidgetEventItem( ) +" "+ GetState(EventWidget( ))
            SetItemData( *this, WidgetEventItem( ), 0 )
            
;             ;Debug "-------change-start-------"
;             Select EventWidget( )
;                Case *demo : SetState_(*this, GetState(EventWidget( )))
;                Case *this : SetState_(*demo, GetState(EventWidget( )))
;             EndSelect
            Select EventWidget( )
               Case *demo : SetState_(*this, WidgetEventItem( ))
               Case *this : SetState_(*demo, WidgetEventItem( ))
            EndSelect
; ;             SetActive( EventWidget( ))
;             ;Debug "-------change-stop-------"
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
               Case *reset : SetState_(*this, - 1)
               Case *item1 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item2 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item3 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item4 : SetState_(*this, Val(GetText(EventWidget( ))))
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
      ;Container(0, 0, 240, 330)
      *demo = Tree(10, 10, 220/2, 310) : SetClass(*demo, "demo")
      *this = Tree(110, 10, 220/2, 310) : SetClass(*this, "this")
      ;*this = ListView(10, 10, 220, 310)
      ;*this = Panel(10, 10, 230, 310) 
      
      Bind(*demo, @widget_events());, #__event_Change)
      Bind(*this, @widget_events());, #__event_Change)
      
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
      Next
      
      If IsContainer(*this)
         CloseList( ) 
      EndIf
      ; CloseList( ) 
      
      Define h = 20, Y = 20
      
      OpenList( *this )
      *test = Button( 0, 0, 0, 0, "test", #__flag_NoFocus)
      CloseList( )
      
      *reset = Button( 250, Y+(1+h)*0, 100, h, "reset")
      *item1 = Button( 250, Y+(1+h)*1, 100, h, "1")
      *item2 = Button( 250, Y+(1+h)*2, 100, h, "3")
      *item3 = Button( 250, Y+(1+h)*3, 100, h, "5")
      *item4 = Button( 250, Y+(1+h)*4, 100, h, "25")
      
      *focus = Button( 250, Y+(1+h)*12, 100, h, "focus")
      *get = Button( 250, Y+(1+h)*13, 100, h, "get")
      
      
      
      Bind(*focus, @button_events(), #__event_Up)
      Bind(*get, @button_events(), #__event_Up)
      
      Bind(*reset, @button_events(), #__event_Up)
      Bind(*item1, @button_events(), #__event_Up)
      Bind(*item2, @button_events(), #__event_Up)
      Bind(*item3, @button_events(), #__event_Up)
      Bind(*item4, @button_events(), #__event_Up)
      
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 55
; FirstLine = 42
; Folding = ---+-
; EnableXP