; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *item2, *item3, *item4, *item1, *this._s_widget, *g1, *g2, countitems=99; количесвто итемов 
  
  Procedure.b SetState_( *this._S_widget, state.f )
      Protected result
      
      ;;\\ - widget::tree_SetState_
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
        ; Debug *this\mode\check
        
        ; reset all selected items
        If State = - 1
          If *this\FocusedRow( )
            If *this\mode\check <> #__m_optionselect
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode
                If *this\row\multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
            EndIf
            
            *this\FocusedRow( )\color\state = #__S_0
            *this\FocusedRow( )             = #Null
          EndIf
        EndIf
        
        ;
        If is_no_select_item_( *this\_rows( ), State )
          ProcedureReturn #False
        EndIf
        
        ;\\
        If *this\count\items
          *this\scroll\state  = - 1
          
          If *this\row\index <> state
          *this\row\index = state
          ;\\
          If *this\FocusedRow( ) <> *this\_rows( )
            If *this\FocusedRow( )
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = #False
                ; multi select mode
                If *this\row\multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, - 1 )
                EndIf
              EndIf
              
              *this\FocusedRow( )\color\state = #__S_0
            EndIf
            
            *this\FocusedRow( ) = *this\_rows( )
            
            ; click select mode
            If *this\row\clickselect
              If *this\FocusedRow( )\state\focus
                *this\FocusedRow( )\state\focus = 0
                *this\FocusedRow( )\color\state = #__S_0
              Else
                *this\FocusedRow( )\state\focus = 1
                *this\FocusedRow( )\color\state = #__S_3
              EndIf
              
              Post( *this, #__event_Change, *this\FocusedRow( )\index )
            Else
              If *this\FocusedRow( )\state\focus = 0 ; ???
                *this\FocusedRow( )\state\focus = 1
                ; multi select mode
                If *this\row\multiselect
                  Post( *this, #__event_Change, *this\FocusedRow( )\index, 1 )
                EndIf
              EndIf
              
              *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
            EndIf
            
            PostCanvasRepaint( *this )
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      EndIf
      
      PostCanvasRepaint( *this )
      ProcedureReturn result
    EndProcedure
    
    
  Procedure button_events()
    Protected count
    
    Select widget::WidgetEventType( )
      Case #PB_EventType_Up
        
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\state\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\state\focus
        EndIf
        If *this\FocusedRow( )
          Debug "f - " + *this\FocusedRow( ) + " " + *this\FocusedRow( )\text\string + " " + *this\FocusedRow( )\state\press + " " + *this\FocusedRow( )\state\enter + " " + *this\FocusedRow( )\state\focus
        EndIf
        
        Debug "--------------"
        Select widget::EventWidget( )
          Case *item1 : SetState_(*this, 1)
          Case *item2 : SetState_(*this, 2)
          Case *item3 : SetState_(*this, 3)
          Case *item4 : SetState_(*this, 90)
        EndSelect
        Debug "--------------"
        
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\state\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\state\focus
        EndIf
        If *this\FocusedRow( )
          Debug "f - " + *this\FocusedRow( ) + " " + *this\FocusedRow( )\text\string + " " + *this\FocusedRow( )\state\press + " " + *this\FocusedRow( )\state\enter + " " + *this\FocusedRow( )\state\focus
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEventType( )
      Case #PB_EventType_Change
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\state\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\state\focus
        EndIf
        If *this\FocusedRow( )
          Debug "f - " + *this\FocusedRow( ) + " " + *this\FocusedRow( )\text\string + " " + *this\FocusedRow( )\state\press + " " + *this\FocusedRow( )\state\enter + " " + *this\FocusedRow( )\state\focus
        EndIf
        
        Debug "--------------"
        SetState_(*this, widget::GetState(widget::EventWidget( )))
        Debug "--------------"
        
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\state\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\state\focus
        EndIf
        If *this\FocusedRow( )
          Debug "f - " + *this\FocusedRow( ) + " " + *this\FocusedRow( )\text\string + " " + *this\FocusedRow( )\state\press + " " + *this\FocusedRow( )\state\enter + " " + *this\FocusedRow( )\state\focus
        EndIf
    EndSelect
  EndProcedure
  
  If Open(1, 100, 50, 370, 330, "demo ListView state", #PB_Window_SystemMenu)
    *this = widget::ListView(10, 10, 230, 310)
    
    For a = 0 To countitems
      widget::AddItem(*this, -1, "Item "+Str(a), 0)
    Next
    
    Define h = 20, y = 20
    widget::Bind(*this, @widget_events(), #PB_EventType_Change)
    
    *item1 = widget::Button( 250, y+(1+h)*1, 100, h, "1")
    *item2 = widget::Button( 250, y+(1+h)*2, 100, h, "2")
    *item3 = widget::Button( 250, y+(1+h)*3, 100, h, "3")
    *item4 = widget::Button( 250, y+(1+h)*4, 100, h, "4")
    
    
    widget::Bind(*item1, @button_events(), #PB_EventType_Up)
    widget::Bind(*item2, @button_events(), #PB_EventType_Up)
    widget::Bind(*item3, @button_events(), #PB_EventType_Up)
    widget::Bind(*item4, @button_events(), #PB_EventType_Up)
    
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 4------
; EnableXP