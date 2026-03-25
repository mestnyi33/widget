
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure GetRowStatus( *this._s_WIDGET, *row._s_ROWS )
      ;Debug ""+MousePress(*g) +" "+ *row\press +" "+ MouseButtons( ) +" "+ MousePress( )
      
      If *row\focus And *row\press  
         If *row\ColorState( )
            ;Debug "focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn 3
         Else
            ;Debug "lost focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 3
         EndIf
      ElseIf MousePress(*this) And *row\_enter  
         ;Debug "press enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( ) +" "+ *row\press
         ProcedureReturn 2
      ElseIf *row\_focus 
         If *row\_enter 
            If MouseButtons( )
               ;Debug ""+*g\press +" "+ *row\press +" "+ MouseButtons( ) +" "+ MousePress( )
               ;Debug "focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               ProcedureReturn 3
            Else
               ;Debug "enter focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               ProcedureReturn 4
            EndIf
         Else
            If Not *row\ColorState( ) 
               ; Debug *row\focus ; bug должен быть 3
               ;Debug "lost focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               ProcedureReturn - 3
            Else
               If Not MousePress(*this)
                  ;Debug "leave from focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
                  ProcedureReturn - 4
               Else
                 ; Debug "deactive "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               EndIf
            EndIf
         EndIf
      ElseIf *row\enter
         ;Debug "enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
         ProcedureReturn 1
      Else
         If MousePress(*this)
            ;Debug "press leave "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 2
         Else
            ;Debug "leave "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 1
         EndIf
      EndIf
   EndProcedure
   
   Procedure all_events()
      Protected._s_ROWS *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      Select WidgetEvent( )
         Case #__event_Drop
         Case #__event_DragStart
            DragDropText( "dragtext" )
            
         Case #__event_LeftDown
            ;
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
               Debug " status "+*g\class +" "+ *row\index +" "+ *row\ColorState( )
;                Select *g
;                   Case *first 
;                      ;If GetState( *second ) <> *row\index
;                      ChangeStatus( *second, *row )
;                      ;EndIf
;                   Case *second 
;                      ;If GetState( *first ) <> *row\index
;                      ChangeStatus( *first, *row )
;                      ;EndIf   
;                EndSelect
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
      
;       EnableDrop( *first, #PB_Drop_Text, #PB_Drag_Link )
;       EnableDrop( *second, #PB_Drop_Text, #PB_Drag_Link )
      
      Bind(*first, @all_events(), #__event_DragStart)
      Bind(*second, @all_events(), #__event_DragStart)
      
;       Bind(*first, @all_events(), #__event_LeftDown)
;       Bind(*second, @all_events(), #__event_LeftDown)
      
      Bind(*first, @all_events(), #__event_StatusChange)
      Bind(*second, @all_events(), #__event_StatusChange)
      
      Bind(*first, @all_events(), #__event_Change)
      Bind(*second, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 43
; FirstLine = 39
; Folding = ---
; EnableXP
; DPIAware