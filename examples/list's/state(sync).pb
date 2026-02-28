
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure   _ChangeItemState( *this._s_WIDGET, Item.l, State.b )
      ProcedureReturn ChangeItemState( *this, Item, State )
      
      If item < 0 Or item > ListSize( *this\__rows( ))
         ProcedureReturn 0
      EndIf
      ;
      If ListSize( *this\__rows( ))
         PushListPosition( *this\__rows( ))
         If SelectElement( *this\__rows( ), item )
            If *this\__rows( )\ColorState( ) <> state
               If state = #__s_2
                  If *this\RowFocused( )
                     *this\RowFocused( )\focus = 0
                     *this\RowFocused( )\ColorState( ) = 0
                  EndIf
                  *this\RowFocused( ) = *this\__rows( )
                  *this\RowFocused( )\focus = state
               EndIf
               
               
               *this\__rows( )\ColorState( ) = state
            EndIf
         EndIf
         PopListPosition( *this\__rows( ) )
      EndIf
   EndProcedure
   
   Procedure widget_events()
      Protected i
      *g = EventWidget( )
      i = WidgetEventItem( )
      
      Select WidgetEvent( )
         Case #__event_LeftDown
            SetState( *g, i)
            
         Case #__event_StatusChange
            Protected._s_ROWS *row = WidgetEventData( )
            
            If *row > 0 
               If *g\press Or *row\focus  ; *row\press Or *row\focus 
                  Select *g
                     Case *first 
                        ;If GetState( *second ) <> *row\index
                        _ChangeItemState( *second, *row\index, *row\ColorState( ))
                        ;EndIf
                     Case *second 
                        ;If GetState( *first ) <> *row\index
                        _ChangeItemState( *first, *row\index, *row\ColorState( ))
                        ;EndIf   
                  EndSelect
                  Debug ""+*g\class +" "+ *row\index +" "+ *row\ColorState( )
               Else
                  *row\ColorState( ) = 0
               EndIf
            EndIf
            
            If *second\press
               ForEach *first\__rows( )
                  Debug ""+*first\__rows( )\focus +" "+ *first\__rows( )\index +" "+ *first\__rows( )\ColorState( )
               Next
            EndIf
            
      EndSelect
      
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items status", #PB_Window_SystemMenu)
      *first = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*first, "first")
      *second = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*second, "second")
      
      For a = 0 To CountItems
         AddItem(*first, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*second, -1, "item "+Str(a), -1, 0)
      Next
      
      Bind(*first, @widget_events())
      Bind(*second, @widget_events())
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 51
; FirstLine = 24
; Folding = 0--
; EnableXP
; DPIAware