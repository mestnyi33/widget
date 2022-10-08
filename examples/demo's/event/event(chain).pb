; #__from_mouse_state = 1
IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  EnableExplicit
  
  Global w_this, w_flag
  Global w_this1, w_flag1
  
  Procedure events_widgets()
    Static _2click
    Protected Space.s
    
    If EventWidget( ) = w_this
    ElseIf EventWidget( ) = w_this1
      Space.s = "   "
    Else
      Space.s = "       "
    EndIf
    
    Select WidgetEventType( )
      Case #PB_EventType_MouseEnter      : AddItem(w_flag, -1, Space + "enter <<" + Trim(getText(EventWidget( ))) + ">>")
      Case #PB_EventType_MouseLeave      : AddItem(w_flag, -1, Space + "leave <<" + Trim(getText(EventWidget( ))) + ">>")
        
        If GetText( EventWidget( ) ) = "new"
          Free( EventWidget( ) )
        EndIf
        
      Case #PB_EventType_DragStart       : AddItem(w_flag, -1, Space + " drag <<" + Trim(getText(EventWidget( ))) + ">>")
        DragText( "drag" )
        
      Case #PB_EventType_Drop            : AddItem(w_flag, -1, Space + " drop <<" + Trim(getText(EventWidget( ))) + ">>")
        widget::Button( X(EventWidget( ))+5, Y(EventWidget( ))+5, 30, 30, "new" )
        widget::Bind(widget( ), @events_widgets(), #PB_EventType_MouseEnter)
        widget::Bind(widget( ), @events_widgets(), #PB_EventType_MouseLeave)
    
      Case #PB_EventType_LeftButtonDown
        If _2click = 2
          _2click = 0
          ClearItems(w_flag)
        EndIf
        AddItem(w_flag, -1, Space + "down <<" + Trim(getText(EventWidget( ))) + ">>")
        
      Case #PB_EventType_LeftButtonUp    : AddItem(w_flag, -1, Space + " up <<" + Trim(getText(EventWidget( ))) + ">>")
      Case #PB_EventType_LeftClick       : AddItem(w_flag, -1, Space + "  click <<" + Trim(getText(EventWidget( ))) + ">>") : _2click + 1
      Case #PB_EventType_LeftDoubleClick : AddItem(w_flag, -1, Space + "   2_click <<" + Trim(getText(EventWidget( ))) + ">>") : _2click = 2
    EndSelect
    
    SetState(w_flag, countitems(w_flag) - 1)
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 260, 360, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    w_flag = widget::Tree( 10, 10, 240, 260, #__tree_nobuttons | #__tree_nolines ) 
    w_this = widget::Button( 10, 280, 240, 70, "   drag", #__button_left|#__button_multiline );| #__button_toggle) 
    ;EnableDrop( w_this, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonDown)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonUp)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftClick)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftDoubleClick)
    
    widget::Bind(w_this, @events_widgets(), #PB_EventType_MouseEnter)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_MouseLeave)
    
    widget::bind(w_this, @events_widgets(), #PB_EventType_DragStart)
    widget::bind(w_this, @events_widgets(), constants::#PB_EventType_Drop)
      
    w_this1 = widget::Button( 195, 295, 40, 40, "drop here", #__button_multiline );| #__button_toggle) 
    EnableDrop( w_this1, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_LeftButtonDown)
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_LeftButtonUp)
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_LeftClick)
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_LeftDoubleClick)
    
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_MouseEnter)
    widget::Bind(w_this1, @events_widgets(), #PB_EventType_MouseLeave)
    
    widget::bind(w_this1, @events_widgets(), #PB_EventType_DragStart)
    widget::bind(w_this1, @events_widgets(), constants::#PB_EventType_Drop)
      
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP