
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure all_events()
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      If *row > 0
         Select WidgetEvent( )
            Case #__event_LeftDown
               If SetState( *g, *row\index)
                  DoEvents( *g, #__event_StatusChange, *row\index, *row )
               EndIf
               
            Case #__event_Change
               Debug "  [+] change "+*g\class +" "+*row\index
               
            Case #__event_StatusChange
               Select *g
                  Case *first  : ChangeStatus( *second, *row )
                  Case *second : ChangeStatus( *first, *row )
               EndSelect
         EndSelect
      EndIf
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
      
         Repaint( )
      
   ;
      Bind(*first, @all_events(), #__event_LeftDown)
      Bind(*second, @all_events(), #__event_LeftDown)
      
      Bind(*first, @all_events(), #__event_StatusChange)
      Bind(*second, @all_events(), #__event_StatusChange)
      
      Bind(*first, @all_events(), #__event_Change)
      Bind(*second, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 34
; FirstLine = 29
; Folding = --
; EnableXP
; DPIAware