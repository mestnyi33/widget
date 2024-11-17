; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *item2, *item3, *item4, *item1, *this._s_widget, *g1, *g2, countitems=99; количесвто итемов 
  
  Procedure.b SetState_( *this._S_widget, state.f )
      Protected result
      
      ;;\\ - widget::tree_SetState_
      If *this\type = #PB_WidgetType_Tree Or
         *this\type = #PB_WidgetType_ListIcon Or
         *this\type = #PB_WidgetType_ListView
        ; Debug *this\mode\check
        
        ; reset all selected items
        If State = - 1
          If *this\RowFocused( )
            If *this\mode\check <> #__m_optionselect
              If *this\RowFocused( )\focus
                *this\RowFocused( )\focus = #False
                ; multi select mode
                If *this\mode\multiselect
                  Post( *this, #__event_Change, *this\RowFocused( )\_index, - 1 )
                EndIf
              EndIf
            EndIf
            
            *this\RowFocused( )\color\state = #__S_0
            *this\RowFocused( )             = #Null
          EndIf
        EndIf
        
        ;
        If is_no_select_item_( *this\__items( ), State )
          ProcedureReturn #False
        EndIf
        
        ;\\
        If *this\countitems
          *this\scroll\state  = - 1
          
          If *this\row\index <> state
          *this\row\index = state
          ;\\
          If *this\RowFocused( ) <> *this\__items( )
            If *this\RowFocused( )
              If *this\RowFocused( )\focus
                *this\RowFocused( )\focus = #False
                ; multi select mode
                If *this\row\multiselect
                  Post( *this, #__event_Change, *this\RowFocused( )\index, - 1 )
                EndIf
              EndIf
              
              *this\RowFocused( )\color\state = #__S_0
            EndIf
            
            *this\RowFocused( ) = *this\__items( )
            
            ; click select mode
            If *this\row\clickselect
              If *this\RowFocused( )\focus
                *this\RowFocused( )\focus = 0
                *this\RowFocused( )\color\state = #__S_0
              Else
                *this\RowFocused( )\focus = 1
                *this\RowFocused( )\color\state = #__S_3
              EndIf
              
              Post( *this, #__event_Change, *this\RowFocused( )\index )
            Else
              If *this\RowFocused( )\focus = 0 ; ???
                *this\RowFocused( )\focus = 1
                ; multi select mode
                If *this\row\multiselect
                  Post( *this, #__event_Change, *this\RowFocused( )\index, 1 )
                EndIf
              EndIf
              
              *this\RowFocused( )\color\state = #__S_2 + Bool( *this\focus = #False )
            EndIf
            
            PostEventCanvasRepaint( *this )
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
      EndIf
      
      PostEventCanvasRepaint( *this )
      ProcedureReturn result
    EndProcedure
    
    
  Procedure button_events()
    Protected count
    
    Select widget::WidgetEvent( )
      Case #__event_Up
        
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\focus
        EndIf
        If *this\RowFocused( )
          Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\state\press + " " + *this\RowFocused( )\state\enter + " " + *this\RowFocused( )\focus
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
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\focus
        EndIf
        If *this\RowFocused( )
          Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\state\press + " " + *this\RowFocused( )\state\enter + " " + *this\RowFocused( )\focus
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEvent( )
      Case #__event_Change
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\focus
        EndIf
        If *this\RowFocused( )
          Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\state\press + " " + *this\RowFocused( )\state\enter + " " + *this\RowFocused( )\focus
        EndIf
        
        Debug "--------------"
        SetState_(*this, widget::GetState(widget::EventWidget( )))
        Debug "--------------"
        
        If *this\EnteredRow( )
          Debug "e - " + *this\EnteredRow( ) + " " + *this\EnteredRow( )\text\string + " " + *this\EnteredRow( )\state\press + " " + *this\EnteredRow( )\state\enter + " " + *this\EnteredRow( )\focus
        EndIf
        If *this\PressedRow( )
          Debug "p - " + *this\PressedRow( ) + " " + *this\PressedRow( )\text\string + " " + *this\PressedRow( )\state\press + " " + *this\PressedRow( )\state\enter + " " + *this\PressedRow( )\focus
        EndIf
        If *this\RowFocused( )
          Debug "f - " + *this\RowFocused( ) + " " + *this\RowFocused( )\text\string + " " + *this\RowFocused( )\state\press + " " + *this\RowFocused( )\state\enter + " " + *this\RowFocused( )\focus
        EndIf
    EndSelect
  EndProcedure
  
  If Open(1, 100, 50, 370, 330, "demo ListView state", #PB_Window_SystemMenu)
    *this = widget::ListViewWidget(10, 10, 230, 310)
    
    For a = 0 To countitems
      widget::AddItem(*this, -1, "Item "+Str(a), 0)
    Next
    
    Define h = 20, y = 20
    widget::Bind(*this, @widget_events(), #__event_Change)
    
    *item1 = widget::ButtonWidget( 250, y+(1+h)*1, 100, h, "1")
    *item2 = widget::ButtonWidget( 250, y+(1+h)*2, 100, h, "2")
    *item3 = widget::ButtonWidget( 250, y+(1+h)*3, 100, h, "3")
    *item4 = widget::ButtonWidget( 250, y+(1+h)*4, 100, h, "90")
    
    
    widget::Bind(*item1, @button_events(), #__event_Up)
    widget::Bind(*item2, @button_events(), #__event_Up)
    widget::Bind(*item3, @button_events(), #__event_Up)
    widget::Bind(*item4, @button_events(), #__event_Up)
    
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 44
; Folding = -------
; EnableXP