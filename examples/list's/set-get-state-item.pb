; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *demo, *get, *reset, *item1, *item2, *item3, *item4, *this._s_widget, *g1, *g2, CountItems=20;99; количесвто итемов 
   
   Procedure.b SetState_( *this._S_widget, state.f )
      Debug SetState( *this, state )
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
            
            Debug "-------b-------"
            Select EventWidget( )
               Case *get : Debug GetState(*this)
               Case *reset : SetState_(*this, - 1)
               Case *item1 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item2 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item3 : SetState_(*this, Val(GetText(EventWidget( ))))
               Case *item4 : SetState_(*this, Val(GetText(EventWidget( ))))
            EndSelect
            Debug "-------b-------"
            
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
   
   Procedure UpdateItemColor( *this._s_WIDGET, *row._s_ROWS  )
      If *row 
         PushListPosition( *this\__rows( ) )
         SelectElement( *this\__rows( ), *row\index)
         *this\__rows( )\color = *row\color
         PopListPosition( *this\__rows( ) )
      EndIf
   EndProcedure
   
   Procedure widget_events()
      If WidgetEvent( ) <> #__event_mousemove
         ;If WidgetEventData( ) = 1
            Debug ""+WidgetEventData( ) +" "+ classfromevent(WidgetEvent( )) +" "+ WidgetEventItem( )
         ;EndIf
      EndIf
      
      Select WidgetEvent( )
         Case #__event_StatusChange
            ; изменять цвета только у выделеных итемов
            ; If Not MouseButtons( ) : ProcedureReturn : EndIf
            
            PushListPosition(EventWidget( )\__rows( ))
            SelectElement( EventWidget( )\__rows( ), WidgetEventItem( ))
            UpdateItemColor( *demo, EventWidget( )\__rows( ))
            PopListPosition(EventWidget( )\__rows( ))
            
            ;  SetItemState( *demo, WidgetEventItem( ), 1)
             
         Case #__event_Change
            Debug "-------w-------"
            SetState_(*this, GetState(EventWidget( )))
            Debug "-------w-------"
      EndSelect
   EndProcedure
   
   If Open(1, 100, 50, 370, 330, "demo ListView state", #PB_Window_SystemMenu)
      ;Container(0, 0, 240, 330)
      *demo = Tree(10, 10, 220/2, 310)
      *this = Tree(110, 10, 220/2, 310)
      ;*this = ListView(10, 10, 220, 310)
      ;*this = Panel(10, 10, 230, 310) 
      
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
      
      *reset = Button( 250, Y+(1+h)*0, 100, h, "reset")
      *item1 = Button( 250, Y+(1+h)*1, 100, h, "1")
      *item2 = Button( 250, Y+(1+h)*2, 100, h, "3")
      *item3 = Button( 250, Y+(1+h)*3, 100, h, "5")
      *item4 = Button( 250, Y+(1+h)*4, 100, h, "25")
      
      *get = Button( 250, Y+(1+h)*13, 100, h, "get")
      
      
      Bind(*this, @widget_events());, #__event_Change)
      
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
; CursorPosition = 74
; FirstLine = 57
; Folding = ---
; EnableXP