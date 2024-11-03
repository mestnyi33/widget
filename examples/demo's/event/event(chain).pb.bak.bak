; #__from_mouse_state = 1
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  
  Global *dragbutton, *dropbutton, *view
  
  ;\\
  Procedure events_widgets()
    Protected *eventWidget._s_widget = EventWidget( )
    Static _2click
    Protected Space.s
    If *eventWidget = *dragbutton
    ElseIf *eventWidget = *dropbutton
      Space.s = "   "
    Else
      Space.s = "       "
    EndIf
    ;Debug ClassFromEvent( WidgetEvent( ) )
    Select WidgetEvent( )
      Case #__event_MouseEnter      : AddItem(*view, -1, Space + "enter <<" + Trim(getText(*eventWidget)) + ">>")
      Case #__event_MouseLeave      : AddItem(*view, -1, Space + "leave <<" + Trim(getText(*eventWidget)) + ">>")
        
        If GetText( *eventWidget ) = "new"
          Free( *eventWidget )
        EndIf
        
      Case #__event_DragStart       : AddItem(*view, -1, Space + " drag <<" + Trim(getText(*eventWidget)) + ">>")
        If *eventWidget = *dragbutton
           DragDropText( "drag", #PB_Drag_Copy )
        EndIf
        
        If *eventWidget = *dropbutton
          DragDropText( "drag" )
        EndIf
        
      Case #__event_Drop            : AddItem(*view, -1, Space + " drop <<" + Trim(getText(*eventWidget)) + ">>")
        
        If *eventWidget = *dropbutton And Not *eventWidget\press
           Button( WidgetX(*eventWidget)+5, WidgetY(*eventWidget)+5, 30, 30, "new" )
           Bind(widget( ), @events_widgets(), #__event_MouseEnter)
           Bind(widget( ), @events_widgets(), #__event_LeftButtonDown)
           Bind(widget( ), @events_widgets(), #__event_MouseLeave)
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
    
    *view = Tree( 10, 10, 240, 260, #__tree_nobuttons | #__tree_nolines ) 
    *dragbutton = Button( 10, 280, 240, 70, "   drag", #__button_left|#__button_multiline );| #__button_toggle) 
    ;EnableDrop( *dragbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    Bind(*dragbutton, @events_widgets(), #__event_LeftButtonDown)
    Bind(*dragbutton, @events_widgets(), #__event_LeftButtonUp)
    Bind(*dragbutton, @events_widgets(), #__event_LeftClick)
    
    Bind(*dragbutton, @events_widgets(), #__event_MouseEnter)
    Bind(*dragbutton, @events_widgets(), #__event_MouseLeave)
    
    bind(*dragbutton, @events_widgets(), #__event_DragStart)
    bind(*dragbutton, @events_widgets(), constants::#__event_Drop)
      
    *dropbutton = Button( 195, 295, 40, 40, "drop", #__button_multiline );| #__button_toggle) 
    EnableDrop( *dropbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    Bind(*dropbutton, @events_widgets(), #__event_LeftButtonDown)
    Bind(*dropbutton, @events_widgets(), #__event_LeftButtonUp)
    Bind(*dropbutton, @events_widgets(), #__event_LeftClick)
    
    Bind(*dropbutton, @events_widgets(), #__event_MouseEnter)
    Bind(*dropbutton, @events_widgets(), #__event_MouseLeave)
    
    bind(*dropbutton, @events_widgets(), #__event_DragStart)
    bind(*dropbutton, @events_widgets(), constants::#__event_Drop)
      
    WaitClose( )
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 38
; Folding = --
; EnableXP