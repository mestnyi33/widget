
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure GetStatus( *this._s_WIDGET, *row._s_ROWS )
      ;Debug ""+*g\press +" "+ *row\press +" "+ MouseButtons( ) +" "+ MousePress( )
      
      If *row\focus And *row\press  
         If *row\ColorState( )
            ;Debug "focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn 3
         Else
            ;Debug "lost focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
            ProcedureReturn - 3
         EndIf
      ElseIf *this\press And *row\enter  
         ;Debug "press enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( ) +" "+ *row\press
         ProcedureReturn 2
      ElseIf *row\focus 
         If *row\enter 
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
               If Not *this\press
                  ;Debug "leave from focus "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
                  ProcedureReturn - 4
               Else
                  ; Debug "deactive "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
                  ProcedureReturn 0
               EndIf
            EndIf
         EndIf
      ElseIf *row\enter
         ;Debug "enter "+*this\class +" "+ *row\index +" "+ *row\ColorState( )
         ProcedureReturn 1
      Else
         If *this\press
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
   
   Procedure   _ChangeStatus( *this._s_WIDGET, *row._s_ROWS )
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
                              *this\__rows( )\enter = *row\enter
                              *this\__rows( )\press = *row\press
                  If *row\focus
                     *this\RowFocused( ) = *this\__rows( )
                  EndIf
              ; EndIf
            EndIf
            PopListPosition( *this\__rows( ) )
         EndIf
      EndProcedure
      
   Procedure all_events()
      Protected._s_ROWS *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      Select WidgetEvent( )
         Case #__event_MouseLeave
;             If MousePress( )
;             Else
;                Pressed( ) = 0
;                *g\press = 0
;             EndIf
            
         Case #__event_MouseEnter
            If *g\RowFocused( ) > 0
               Debug "  [+] enter "+*g\class +" "+*g\RowFocused( )\index
            EndIf
            
            If MousePress( )
               Pressed( ) = *g
               *g\press = 1
            EndIf
            
         Case #__event_Change
            If *row > 0
               Debug "  [+] change "+*g\class +" "+*row\index
            EndIf
            
         Case #__event_StatusChange
            If *row > 0
               Select *g
                  Case *first 
                     ;If GetState( *second ) <> *row\index
                     _ChangeStatus( *second, *row )
                     ;EndIf
                  Case *second 
                     ;If GetState( *first ) <> *row\index
                     _ChangeStatus( *first, *row )
                     ;EndIf   
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
      
      Bind(*first, @all_events(), #__event_MouseEnter)
      Bind(*second, @all_events(), #__event_MouseEnter)
      
      Bind(*first, @all_events(), #__event_MouseLeave)
      Bind(*second, @all_events(), #__event_MouseLeave)
      
      Bind(*first, @all_events(), #__event_StatusChange)
      Bind(*second, @all_events(), #__event_StatusChange)
      
      Bind(*first, @all_events(), #__event_Change)
      Bind(*second, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 172
; FirstLine = 69
; Folding = -----
; EnableXP
; DPIAware