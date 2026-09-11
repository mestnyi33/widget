
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure GetStatus( *this._s_WIDGET, *row._s_ROW )
      ;Debug ""+MousePress(*g) +" "+ *row\press +" "+ MouseButtons( ) +" "+ MousePress( )
      
      If *row\focus And *row\mask & #__mask_press  
         If *row\ColorState( )
            ;Debug "focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn 3
         Else
            ;Debug "lost focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 3
         EndIf
      ElseIf MousePress(*this) And *row\mask & #__mask_hover  
         ;Debug "press enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( ) +" "+ *row\press
         ProcedureReturn 2
      ElseIf *row\focus 
         If *row\mask & #__mask_hover 
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
                  ProcedureReturn 0
               EndIf
            EndIf
         EndIf
      ElseIf *row\mask & #__mask_hover
         ;Debug "enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
         ProcedureReturn 1
      Else
         If MousePress(*this)
            ;Debug "press leave "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 2
         Else
            If *this\RowFocused( ) = *row
               ; Debug "lost focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               ProcedureReturn - 3
            Else
               ; Debug "leave "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
               ProcedureReturn - 1
            EndIf
         EndIf
      EndIf
   EndProcedure
   
   Procedure   _ChangeStatus( *this._s_WIDGET, *row._s_ROW )
         Protected count = ListSize( *this\__rows( ))
         If count
            If *row\index < 0 Or
               *row\index > count
               ProcedureReturn 0
            EndIf
            ;
            PushListPosition( *this\__rows( ))
            If SelectElement( *this\__rows( ), *row\index )
               ;If *this\__rows( )\ColorState( ) <> *row\ColorState( )
                  *this\__rows( )\ColorState( ) = *row\ColorState( )
                  *this\__rows( )\focus = *row\focus
                  *this\__rows( )\mask = *row\mask
                  
                  If *row\focus
                     *this\RowFocused( ) = *this\__rows( )
                  EndIf
              ; EndIf
            EndIf
            PopListPosition( *this\__rows( ) )
         EndIf
      EndProcedure
      
   Procedure all_events()
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      Select WidgetEvent( )
         Case #__event_DragStop
            *row = *g\rowentered()
            Debug *row\index
;                If SetState( *g, *row\index)
;                   DoEvents( *g, #__event_StatusChange, *row\index, *row )
;                EndIf
               
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
               
               ProcedureReturn 
               ;
               Select GetStatus( *g, *row )
                     ;Case 1 : Debug "enter "+*g\class +" "+ *row\index
                     ;Case 2 : Debug "e-press "+*g\class +" "+ *row\index
                  Case 3 : Debug "focus "+*g\class +" "+ *row\index
                     ;Case 4 : Debug "e-focus "+*g\class +" "+ *row\index
                     ;Case -1 : Debug "leave "+*g\class +" "+ *row\index
                     ;Case -2 : Debug "l-press "+*g\class +" "+ *row\index
                  Case -3 : Debug "f-lost "+*g\class +" "+ *row\index
                     ;Case -4 : Debug "l-focus "+*g\class +" "+ *row\index
               EndSelect
               
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
      
;       Bind(*first, @all_events(), #__event_MouseEnter)
;       Bind(*second, @all_events(), #__event_MouseEnter)
;       
;       Bind(*first, @all_events(), #__event_MouseLeave)
;       Bind(*second, @all_events(), #__event_MouseLeave)
      
      Bind(*first, @all_events(), #__event_DragStop)
      Bind(*second, @all_events(), #__event_DragStop)
      
      Bind(*first, @all_events(), #__event_StatusChange)
      Bind(*second, @all_events(), #__event_StatusChange)
      
      Bind(*first, @all_events(), #__event_Change)
      Bind(*second, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 155
; FirstLine = 144
; Folding = ----
; EnableXP
; DPIAware