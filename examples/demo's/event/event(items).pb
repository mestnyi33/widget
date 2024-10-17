; #__from_mouse_state = 1
IncludePath "../../../"
XIncludeFile "widgets.pbi"

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
    
    Select WidgetEvent( )
      Case #__event_MouseEnter      : AddItem(w_flag, -1, Space + "enter <<" + Trim(getText(EventWidget( ))) + ">>")
      Case #__event_MouseLeave      : AddItem(w_flag, -1, Space + "leave <<" + Trim(getText(EventWidget( ))) + ">>")
        
        If GetText( EventWidget( ) ) = "new"
          Free( EventWidget( ) )
        EndIf
        
      Case #__event_DragStart       : AddItem(w_flag, -1, Space + " drag")
        DragText( "drag" )
        
      Case #__event_Drop            : AddItem(w_flag, -1, Space + " drop")
        widget::Button( 145, 240, 30, 30, "new" )
        widget::Bind(widget( ), @events_widgets(), #__event_MouseEnter)
        widget::Bind(widget( ), @events_widgets(), #__event_MouseLeave)
    
      Case #__event_LeftButtonDown
        If _2click = 2
          _2click = 0
          ClearItems(w_flag)
        EndIf
        AddItem(w_flag, -1, Space + "down")
        
      Case #__event_LeftButtonUp    : AddItem(w_flag, -1, Space + " up")
      Case #__event_LeftClick       : AddItem(w_flag, -1, Space + "  click") : _2click + 1
      Case #__event_LeftDoubleClick : AddItem(w_flag, -1, Space + "   2_click") : _2click = 2
    EndSelect
    
    SetState(w_flag, countitems(w_flag) - 1)
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 200, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    w_flag = widget::Tree( 10, 10, 180, 200, #__tree_nobuttons | #__tree_nolines ) 
    w_this = widget::Tree( 10, 220, 180, 70, #__tree_nobuttons | #__tree_nolines )
    
    widget::Bind(w_this, @events_widgets(), #__event_LeftButtonDown)
    widget::Bind(w_this, @events_widgets(), #__event_LeftButtonUp)
    widget::Bind(w_this, @events_widgets(), #__event_LeftClick)
    widget::Bind(w_this, @events_widgets(), #__event_LeftDoubleClick)
    
    widget::Bind(w_this, @events_widgets(), #__event_MouseEnter)
    widget::Bind(w_this, @events_widgets(), #__event_MouseLeave)
    
    widget::bind(w_this, @events_widgets(), #__event_DragStart)
    widget::bind(w_this, @events_widgets(), constants::#__event_Drop)
      
    w_this1 = widget::Tree( 140, 235, 40, 40, #__tree_nobuttons | #__tree_nolines) 
    EnableDrop( w_this1, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::Bind(w_this1, @events_widgets(), #__event_LeftButtonDown)
    widget::Bind(w_this1, @events_widgets(), #__event_LeftButtonUp)
    widget::Bind(w_this1, @events_widgets(), #__event_LeftClick)
    widget::Bind(w_this1, @events_widgets(), #__event_LeftDoubleClick)
    
    widget::Bind(w_this1, @events_widgets(), #__event_MouseEnter)
    widget::Bind(w_this1, @events_widgets(), #__event_MouseLeave)
    
    widget::bind(w_this1, @events_widgets(), #__event_DragStart)
    widget::bind(w_this1, @events_widgets(), constants::#__event_Drop)
      
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware