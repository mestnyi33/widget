; #__from_mouse_state = 1
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  EnableExplicit
  
  Global *button1, *button2, *view
  
  ;\\
  Procedure events_widgets()
    Protected *eventWidget._s_widget = EventWidget( )
    Static _2click
    Protected Space.s
    If *eventWidget = *button1
    ElseIf *eventWidget = *button2
      Space.s = "   "
    Else
      Space.s = "       "
    EndIf
    
    Select WidgetEventType( )
      Case #__event_MouseEnter      : AddItem(*view, -1, Space + "enter <<" + Trim(getText(*eventWidget)) + ">>")
      Case #__event_MouseLeave      : AddItem(*view, -1, Space + "leave <<" + Trim(getText(*eventWidget)) + ">>")
        
        If GetText( *eventWidget ) = "new"
          Free( *eventWidget )
        EndIf
        
      Case #__event_DragStart       : AddItem(*view, -1, Space + " drag <<" + Trim(getText(*eventWidget)) + ">>")
        If *eventWidget = *button1
          DragText( "drag", #PB_Drag_Copy )
        EndIf
        
        If *eventWidget = *button2
          DragText( "drag", #PB_Drag_Drop )
        EndIf
        
      Case #__event_Drop            : AddItem(*view, -1, Space + " drop <<" + Trim(getText(*eventWidget)) + ">>")
        
        If *eventWidget = *button2 And Not *eventWidget\dragstart
          widget::Button( X(*eventWidget)+5, Y(*eventWidget)+5, 30, 30, "new" )
          widget::Bind(widget( ), @events_widgets(), #__event_MouseEnter)
          widget::Bind(widget( ), @events_widgets(), #__event_MouseLeave)
        EndIf
      
      Case #__event_LeftButtonDown
        If _2click = 2
          _2click = 0
          ClearItems(*view)
        EndIf
        AddItem(*view, -1, Space + "down <<" + Trim(getText(*eventWidget)) + ">>")
        
      Case #__event_LeftButtonUp    : AddItem(*view, -1, Space + " up <<" + Trim(getText(*eventWidget)) + ">>")
      Case #__event_LeftClick       : AddItem(*view, -1, Space + "  click <<" + Trim(getText(*eventWidget)) + ">>") : _2click + 1
      Case #__event_LeftDoubleClick : AddItem(*view, -1, Space + "   2_click <<" + Trim(getText(*eventWidget)) + ">>") : _2click = 2
    EndSelect
    
    SetState(*view, countitems(*view) - 1)
  EndProcedure
  
  ;\\
  If Open(1, 0, 0, 260, 360, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *view = widget::Tree( 10, 10, 240, 260, #__tree_nobuttons | #__tree_nolines ) 
    *button1 = widget::Button( 10, 280, 240, 70, "   drag", #__button_left|#__button_multiline );| #__button_toggle) 
    ;EnableDrop( *button1, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::Bind(*button1, @events_widgets(), #__event_LeftButtonDown)
    widget::Bind(*button1, @events_widgets(), #__event_LeftButtonUp)
    widget::Bind(*button1, @events_widgets(), #__event_LeftClick)
    
    widget::Bind(*button1, @events_widgets(), #__event_MouseEnter)
    widget::Bind(*button1, @events_widgets(), #__event_MouseLeave)
    
    widget::bind(*button1, @events_widgets(), #__event_DragStart)
    widget::bind(*button1, @events_widgets(), constants::#__event_Drop)
      
    *button2 = widget::Button( 195, 295, 40, 40, "drop", #__button_multiline );| #__button_toggle) 
    EnableDrop( *button2, #PB_Drop_Text, #PB_Drag_Copy )
  
    widget::Bind(*button2, @events_widgets(), #__event_LeftButtonDown)
    widget::Bind(*button2, @events_widgets(), #__event_LeftButtonUp)
    widget::Bind(*button2, @events_widgets(), #__event_LeftClick)
    
    widget::Bind(*button2, @events_widgets(), #__event_MouseEnter)
    widget::Bind(*button2, @events_widgets(), #__event_MouseLeave)
    
    widget::bind(*button2, @events_widgets(), #__event_DragStart)
    widget::bind(*button2, @events_widgets(), constants::#__event_Drop)
      
    widget::WaitClose()
  EndIf
CompilerEndIf

; enter <<drag>>
; down <<drag>>
; drag <<drag>>
; leave <<drag>>
;   enter <<drop>>
;   drop <<drop>>
;   leave <<drop>>
;     enter <<new>>
; up <<drag>>
;     leave <<new>>
;   enter <<drop>>
;   leave <<drop>>
; enter <<drag>>
; leave <<drag>>
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 106
; Folding = --
; EnableXP