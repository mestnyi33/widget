; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

Define editable ;= #__flag_anchorsgadget  ; #__flag_flat ; 

Procedure events_widgets()
  Protected repaint
  
  Select WidgetEventType( )
    Case #PB_EventType_MouseEnter : EventWidget( )\color\back = $ff0000ff : repaint = 1
    Case #PB_EventType_MouseLeave : EventWidget( )\color\back = $ff00ff00 : repaint = 1
  EndSelect
  
  If repaint
    Debug 777
    ; Repaints( )
    ;_post_repaint_canvas_( root( )\canvas )
   ; ReDraw( root( ) )
  EndIf
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 240, 240, "enter&leave demo",
                   #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  If editable = #__flag_anchorsgadget
    a_init(root())
  EndIf
  
  SetData(ScrollArea(20, 20, 180, 180, 200,200,1, editable), 1)
  SetData(Button(20, 20, 180, 100, "button", editable), 2)
  
  CloseList()
  
  
  If editable = #__flag_anchorsgadget
    Bind(#PB_All, @events_widgets())
  Else
    ;     ; TODO
    ;     Bind(#PB_All, @events_widgets(), #PB_EventType_MouseEnter)
    ;     Bind(#PB_All, @events_widgets(), #PB_EventType_MouseLeave)
    
    ForEach widget()
      Bind(widget(), @events_widgets(), #PB_EventType_MouseEnter)
      Bind(widget(), @events_widgets(), #PB_EventType_MouseLeave)
    Next
  EndIf
  
  WaitClose( )
  ;Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 2
; Folding = --
; EnableXP