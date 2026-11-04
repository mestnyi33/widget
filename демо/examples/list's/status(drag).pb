
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *g1, *g2
   
   Procedure all_events()
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      Select WidgetEvent( )
         Case #__event_Drop
         Case #__event_DragStart
            DragDropText( "dragtext" )
            
         Case #__event_LeftDown
            If SetState( *g, *row\index)
               DoEvents( *g, #__event_StatusChange, *row\rindex, *row )
            EndIf
            
         Case #__event_Change
            Debug "  [+] change "+*g\class +" "+*row\index
            
         Case #__event_StatusChange
            Debug " status "+*g\class +" "+ *row\index +" "+ *row\ColorState( )
            
      EndSelect
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items status", #PB_Window_SystemMenu)
      *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "first")
      *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "second")
      
      For a = 0 To CountItems
         AddItem(*g1, -1, "g1 item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*g2, -1, "g2 item "+Str(a), -1, 0)
      Next
      
            EnableDrop( *g1, #PB_Drop_Text, #PB_Drag_Link )
            EnableDrop( *g2, #PB_Drop_Text, #PB_Drag_Link )
      
      Bind(*g1, @all_events(), #__event_DragStart)
      Bind(*g2, @all_events(), #__event_DragStart)
      
      ;       Bind(*g1, @all_events(), #__event_LeftDown)
      ;       Bind(*g2, @all_events(), #__event_LeftDown)
      
      Bind(*g1, @all_events(), #__event_StatusChange)
      Bind(*g2, @all_events(), #__event_StatusChange)
      
      Bind(*g1, @all_events(), #__event_Change)
      Bind(*g2, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 12
; Folding = -
; EnableXP
; DPIAware