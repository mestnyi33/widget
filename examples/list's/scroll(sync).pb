IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 20
   Global._s_WIDGET *g, *first, *second
   
   Procedure widget_events()
      Protected scoll
      *g = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_ScrollChange
            scoll = WidgetEventData( )
            
            Select *g
               Case *first 
                  If GetState( *second\scroll\v ) <> scoll
                     SetState(*second\scroll\v, scoll)
                  EndIf
               Case *second 
                  If GetState( *first\scroll\v ) <> scoll
                     SetState(*first\scroll\v, scoll)
                  EndIf
            EndSelect
            
         Case #__event_Change, #__event_StatusChange
            Protected._s_ROWS *row = WidgetEventData( )
            
            If *row > 0
               *row\press = 0
               *row\focus = 0
               *row\enter = 0
               *row\ColorState( ) = 0
            EndIf
            
      EndSelect
      
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items scrolls", #PB_Window_SystemMenu)
      *first = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*first, "first")
      *second = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*second, "second")
      
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
      
      Bind(*first, @widget_events(), #__event_Change)
      Bind(*second, @widget_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 35
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware