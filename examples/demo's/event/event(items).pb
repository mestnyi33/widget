; #__from_mouse_state = 1
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
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
      Case #__event_MouseEnter      : AddItem(w_flag, -1, Space + "enter <<" + Trim(getTextWidget(EventWidget( ))) + ">>")
      Case #__event_MouseLeave      : AddItem(w_flag, -1, Space + "leave <<" + Trim(getTextWidget(EventWidget( ))) + ">>")
        
        If GetTextWidget( EventWidget( ) ) = "new"
          FreeWidget( EventWidget( ) )
        EndIf
        
      Case #__event_DragStart       : AddItem(w_flag, -1, Space + " drag")
        DragTextWidget( "drag" )
        
      Case #__event_Drop            : AddItem(w_flag, -1, Space + " drop")
        widget::ButtonWidget( 145, 240, 30, 30, "new" )
        widget::BindWidgetEvent(widget( ), @events_widgets(), #__event_MouseEnter)
        widget::BindWidgetEvent(widget( ), @events_widgets(), #__event_MouseLeave)
    
      Case #__event_LeftDown
        If _2click = 2
          _2click = 0
          ClearItems(w_flag)
        EndIf
        AddItem(w_flag, -1, Space + "down")
        
      Case #__event_LeftUp    : AddItem(w_flag, -1, Space + " up")
      Case #__event_LeftClick       : AddItem(w_flag, -1, Space + "  click") : _2click + 1
      Case #__event_Left2Click : AddItem(w_flag, -1, Space + "   2_click") : _2click = 2
    EndSelect
    
    SetState(w_flag, countitems(w_flag) - 1)
  EndProcedure
  
  If OpenRootWidget(OpenWindow(#PB_Any, 0, 0, 200, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    w_flag = widget::TreeWidget( 10, 10, 180, 200, #__tree_nobuttons | #__tree_nolines ) 
    w_this = widget::TreeWidget( 10, 220, 180, 70, #__tree_nobuttons | #__tree_nolines )
    
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_LeftDown)
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_LeftUp)
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_LeftClick)
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_Left2Click)
    
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_MouseEnter)
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_MouseLeave)
    
    widget::BindWidgetEvent(w_this, @events_widgets(), #__event_DragStart)
    widget::BindWidgetEvent(w_this, @events_widgets(), constants::#__event_Drop)
      
    w_this1 = widget::TreeWidget( 140, 235, 40, 40, #__tree_nobuttons | #__tree_nolines) 
    EnableDDrop( w_this1, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_LeftDown)
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_LeftUp)
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_LeftClick)
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_Left2Click)
    
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_MouseEnter)
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_MouseLeave)
    
    widget::BindWidgetEvent(w_this1, @events_widgets(), #__event_DragStart)
    widget::BindWidgetEvent(w_this1, @events_widgets(), constants::#__event_Drop)
      
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 70
; FirstLine = 51
; Folding = --
; EnableXP
; DPIAware