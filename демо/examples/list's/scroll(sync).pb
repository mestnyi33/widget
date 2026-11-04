IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 20
   Global._s_WIDGET *g, *g1, *g2
   
   Procedure widget_events()
      *g = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_ScrollChange
            Protected  scoll = WidgetEventData( )
            
            Select *g
               Case *g1 
                  If GetState( *g2\scroll\v ) <> scoll
                     SetState(*g2\scroll\v, scoll)
                  EndIf
               Case *g2 
                  If GetState( *g1\scroll\v ) <> scoll
                     SetState(*g1\scroll\v, scoll)
                  EndIf
            EndSelect
            
         Case #__event_Change, #__event_StatusChange
            Protected._s_ROW *row = WidgetEventData( )
            
            If *row > 0
               ; *row\mask &~ #__MASK_Hover
               ; *row\mask = 0
               *row\ColorState( ) = 0
            EndIf
            
      EndSelect
      
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items scrolls", #PB_Window_SystemMenu)
      *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "g1")
      *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "g2")
      
      For a = 0 To CountItems
         AddItem(*g1, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*g2, -1, "item "+Str(a), -1, 0)
      Next
      
      Bind(*g1, @widget_events(), #__event_ScrollChange)
      Bind(*g2, @widget_events(), #__event_ScrollChange)
      
      Bind(*g1, @widget_events(), #__event_StatusChange)
      Bind(*g2, @widget_events(), #__event_StatusChange)
      
      Bind(*g1, @widget_events(), #__event_Change)
      Bind(*g2, @widget_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 34
; FirstLine = 28
; Folding = --
; EnableXP
; DPIAware