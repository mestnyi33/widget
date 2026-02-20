; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"
;XIncludeFile "temp.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 20
   Global._s_WIDGET *first, *second
   
   Procedure widget_events()
      
      Select WidgetEvent( )
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *first 
                  If GetState( *second\scroll\v ) <> WidgetEventData( )
                     SetState(*second\scroll\v, WidgetEventData( ))
                  EndIf
               Case *second 
                  If GetState( *first\scroll\v ) <> WidgetEventData( )
                     SetState(*first\scroll\v, WidgetEventData( ))
                  EndIf
            EndSelect
            
         Case #__event_StatusChange
            Protected._s_ROWS *row 
            ;
            If PushItem( EventWidget( ))
               If SelectItem( EventWidget( ), WidgetEventItem( ))
                  *row = EventWidget( )\__rows( )
               EndIf
               PopItem( EventWidget( ))
            EndIf
            
            If *row > 0
               Select EventWidget( )
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
            
           ; Root( )\repaint = 0
      EndSelect
      
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo ListView state", #PB_Window_SystemMenu)
      *first = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*first, "demo")
      *second = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*second, "this")
      
      For a = 0 To CountItems
         AddItem(*first, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*second, -1, "item "+Str(a), -1, 0)
      Next
      
      Bind(*first, @widget_events(), #__event_ScrollChange)
      Bind(*second, @widget_events(), #__event_ScrollChange)
      
      Bind(*first, @widget_events(), #__event_StatusChange)
      Bind(*second, @widget_events(), #__event_StatusChange)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 54
; FirstLine = 21
; Folding = -7-
; EnableXP
; DPIAware