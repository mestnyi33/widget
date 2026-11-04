
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *g1, *g2
   
   Procedure all_events()
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      If *row
         Select WidgetEvent( )
            Case #__event_LeftDown
               If SetState( *g, *row\index)
                  DoEvents( *g, #__event_StatusChange, *row\index, *row )
               EndIf
               
            Case #__event_Change
               Debug "             ["+*row\index+"] "+*g\class +" change "
               
            Case #__event_StatusChange
               Select *g
                  Case *g1  : ChangeStatus( *g2, *row )
                  Case *g2  : ChangeStatus( *g1, *row )
               EndSelect
              Debug "             ["+*row\index+"] "+*g\class +" status "
               
           EndSelect
      EndIf
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items status", #PB_Window_SystemMenu)
      *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "*g1")
      *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "*g2")
      
      For a = 0 To CountItems
         AddItem(*g1, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*g2, -1, "item "+Str(a), -1, 0)
      Next
      
      ;  
      SetState(*g1, CountItems(*g1)-1) : SetActive(*g1)
      ; SetState(*g2, CountItems(*g2)-1): SetActive(*g2)
  
      ;
      Bind(*g1, @all_events(), #__event_LeftDown)
      Bind(*g2, @all_events(), #__event_LeftDown)
      
      Bind(*g1, @all_events(), #__event_StatusChange)
      Bind(*g2, @all_events(), #__event_StatusChange)
      
      Bind(*g1, @all_events(), #__event_Change)
      Bind(*g2, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 31
; FirstLine = 17
; Folding = --
; EnableXP
; DPIAware