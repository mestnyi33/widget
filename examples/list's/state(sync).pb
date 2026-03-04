
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure all_events()
      Protected._s_ROWS *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      Select WidgetEvent( )
         Case #__event_LeftDown
            If *row > 0
               If SetState( *g, *row\index)
                  DoEvents( *g, #__event_StatusChange, *row\rindex, *row )
               EndIf
            EndIf
            
         Case #__event_Change
            If *row > 0
               Debug "  [+] change "+*g\class +" "+*row\index
            EndIf
            
         Case #__event_StatusChange
            If *row > 0
               Select *g
                  Case *first  : ChangeStatus( *second, *row )
                  Case *second : ChangeStatus( *first, *row )
               EndSelect
           EndIf
            ;                
            ;                         ForEach *second\__rows( )
            ;                               Debug "[s] "+*second\__rows( )\focus +" "+ *second\__rows( )\index +" "+ *second\__rows( )\ColorState( )
            ;                            Next
            ;                          ForEach *first\__rows( )
            ;                               Debug "[f] "+*first\__rows( )\focus +" "+ *first\__rows( )\index +" "+ *first\__rows( )\ColorState( )
            ;                            Next
            
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
; CursorPosition = 59
; FirstLine = 44
; Folding = --
; EnableXP
; DPIAware