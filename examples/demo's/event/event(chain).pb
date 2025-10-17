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
      Case #__event_MouseEnter      : AddItem(*view, -1, Space + "enter <<" + Trim(GetText(*eventWidget)) + ">>")
      Case #__event_MouseLeave      : AddItem(*view, -1, Space + "leave <<" + Trim(GetText(*eventWidget)) + ">>")
        
        If GetText( *eventWidget ) = "new"
          Free( @*eventWidget )
        EndIf
        
      Case #__event_DragStart       : AddItem(*view, -1, Space + " drag <<" + Trim(GetText(*eventWidget)) + ">>")
        If *eventWidget = *dragbutton
           DragDropText( "drag", #PB_Drag_Copy )
        EndIf
        
        If *eventWidget = *dropbutton
          DragDropText( "drag" )
        EndIf
        
      Case #__event_Drop            : AddItem(*view, -1, Space + " drop <<" + Trim(GetText(*eventWidget)) + ">>")
        
        If *eventWidget = *dropbutton And Not *eventWidget\press
           Button( X(*eventWidget)+5, Y(*eventWidget)+5, 30, 30, "new" )
           Bind(widget( ), @events_widgets(), #__event_MouseEnter)
           Bind(widget( ), @events_widgets(), #__event_LeftDown)
           Bind(widget( ), @events_widgets(), #__event_MouseLeave)
        EndIf
      
      Case #__event_LeftDown
        If _2click = 2
          _2click = 0
          ClearItems(*view)
        EndIf
        AddItem(*view, -1, Space + "down <<" + Trim(GetText(*eventWidget)) + ">>")
        
      Case #__event_LeftUp    : AddItem(*view, -1, Space + " up <<" + Trim(GetText(*eventWidget)) + ">>")
      Case #__event_LeftClick       : AddItem(*view, -1, Space + "  click <<" + Trim(GetText(*eventWidget)) + ">>") : _2click + 1
      Case #__event_Left2Click : AddItem(*view, -1, Space + "   2_click <<" + Trim(GetText(*eventWidget)) + ">>") : _2click = 2
    EndSelect
    
    SetState(*view, CountItems(*view) - 1)
  EndProcedure
  
  ;\\
  If Open(1, 0, 0, 260, 360, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *view = Tree( 10, 10, 240, 260, #__flag_nobuttons | #__flag_nolines ) 
    *dragbutton = Button( 10, 280, 240, 70, "   drag", #PB_Button_Left|#PB_Button_MultiLine );| #PB_Button_Toggle) 
    ;EnableDrop( *dragbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    Bind(*dragbutton, @events_widgets(), #__event_LeftDown)
    Bind(*dragbutton, @events_widgets(), #__event_LeftUp)
    Bind(*dragbutton, @events_widgets(), #__event_LeftClick)
    
    Bind(*dragbutton, @events_widgets(), #__event_MouseEnter)
    Bind(*dragbutton, @events_widgets(), #__event_MouseLeave)
    
    Bind(*dragbutton, @events_widgets(), #__event_DragStart)
    Bind(*dragbutton, @events_widgets(), constants::#__event_Drop)
      
    *dropbutton = Button( 195, 295, 40, 40, "drop", #__flag_Textmultiline );| #PB_Button_Toggle) 
    EnableDrop( *dropbutton, #PB_Drop_Text, #PB_Drag_Copy )
  
    Bind(*dropbutton, @events_widgets(), #__event_LeftDown)
    Bind(*dropbutton, @events_widgets(), #__event_LeftUp)
    Bind(*dropbutton, @events_widgets(), #__event_LeftClick)
    
    Bind(*dropbutton, @events_widgets(), #__event_MouseEnter)
    Bind(*dropbutton, @events_widgets(), #__event_MouseLeave)
    
    Bind(*dropbutton, @events_widgets(), #__event_DragStart)
    Bind(*dropbutton, @events_widgets(), constants::#__event_Drop)
      
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
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 27
; FirstLine = 14
; Folding = --
; EnableXP