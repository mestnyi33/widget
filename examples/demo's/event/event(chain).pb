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
      Case #__event_MouseEnter      : AddItem(*view, -1, Space + "enter <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
      Case #__event_MouseLeave      : AddItem(*view, -1, Space + "leave <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
        
        If GetWidgetText( *eventWidget ) = "new"
          FreeWidget( *eventWidget )
        EndIf
        
      Case #__event_DragStart       : AddItem(*view, -1, Space + " drag <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
        If *eventWidget = *dragbutton
           DDragTextWidget( "drag", #PB_Drag_Copy )
        EndIf
        
        If *eventWidget = *dropbutton
          DDragTextWidget( "drag" )
        EndIf
        
      Case #__event_Drop            : AddItem(*view, -1, Space + " drop <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
        
        If *eventWidget = *dropbutton And Not *eventWidget\press
           ButtonWidget( WidgetX(*eventWidget)+5, WidgetY(*eventWidget)+5, 30, 30, "new" )
           BindWidgetEvent(widget( ), @events_widgets(), #__event_MouseEnter)
           BindWidgetEvent(widget( ), @events_widgets(), #__event_LeftDown)
           BindWidgetEvent(widget( ), @events_widgets(), #__event_MouseLeave)
        EndIf
      
      Case #__event_LeftDown
        If _2click = 2
          _2click = 0
          ClearItems(*view)
        EndIf
        AddItem(*view, -1, Space + "down <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
        
      Case #__event_LeftUp    : AddItem(*view, -1, Space + " up <<" + Trim(GetWidgetText(*eventWidget)) + ">>")
      Case #__event_LeftClick       : AddItem(*view, -1, Space + "  click <<" + Trim(GetWidgetText(*eventWidget)) + ">>") : _2click + 1
      Case #__event_Left2Click : AddItem(*view, -1, Space + "   2_click <<" + Trim(GetWidgetText(*eventWidget)) + ">>") : _2click = 2
    EndSelect
    
    SetWidgetState(*view, countitems(*view) - 1)
  EndProcedure
  
  ;\\
  If OpenRoot(1, 0, 0, 260, 360, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *view = TreeWidget( 10, 10, 240, 260, #__tree_nobuttons | #__tree_nolines ) 
    *dragbutton = ButtonWidget( 10, 280, 240, 70, "   drag", #__flag_TextLeft|#__flag_Textmultiline );| #__flag_ButtonToggle) 
    ;EnableDDrop( *dragbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_LeftDown)
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_LeftUp)
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_LeftClick)
    
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_MouseEnter)
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_MouseLeave)
    
    BindWidgetEvent(*dragbutton, @events_widgets(), #__event_DragStart)
    BindWidgetEvent(*dragbutton, @events_widgets(), constants::#__event_Drop)
      
    *dropbutton = ButtonWidget( 195, 295, 40, 40, "drop", #__flag_Textmultiline );| #__flag_ButtonToggle) 
    EnableDDrop( *dropbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_LeftDown)
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_LeftUp)
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_LeftClick)
    
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_MouseEnter)
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_MouseLeave)
    
    BindWidgetEvent(*dropbutton, @events_widgets(), #__event_DragStart)
    BindWidgetEvent(*dropbutton, @events_widgets(), constants::#__event_Drop)
      
    WaitCloseRoot( )
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