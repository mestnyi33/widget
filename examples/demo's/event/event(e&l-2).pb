; #__from_mouse_state = 1

XIncludeFile "../../../widgets3.pbi" 
Uselib(widget)

Define editable ;= #__flag_anchorsgadget  ; #__flag_flat ; 

Procedure events_widgets()
  Protected repaint, BackColor
  Protected *ew._s_widget = EventWidget( )
  
  Select WidgetEventType( )
    Case #PB_EventType_MouseEnter 
      *ew\color\back = $ff0000ff : repaint = 1
    Case #PB_EventType_MouseLeave 
      *ew\color\back = $ff00ff00 : repaint = 1
  EndSelect
  
  If *ew\state\enter
    If mouse( )\buttons
      BackColor = $ff00F7FF
    Else
      BackColor = $ff301DE8
    EndIf
  Else
    BackColor = $ff13FF00
  EndIf
  If *ew\state\press
    BackColor = $ffFFAA00
  Else
    If *ew\state\focus
      BackColor = $ffFF0090
    EndIf
  EndIf
  
  
  
  If *ew\color\back <> BackColor ; repaint
    *ew\color\back = BackColor
    ; Repaints( )
    ;_post_repaint_canvas_( root( )\canvas )
    ReDraw( root( ) )
  EndIf
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 220, 220, "enter&leave demo",
                   #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  If editable = #__flag_anchorsgadget
    a_init(root())
  EndIf
  
  SetData(Container(20, 20, 180, 180, editable), 1)
  SetData(Container(70, 10, 70, 180, #__Flag_NoGadgets|editable), 2) 
  SetData(Container(40, 20, 180, 180, editable), 3)
  SetData(Container(20, 20, 180, 180, editable), 4)
  
  SetData(Container(5, 30, 180, 30, #__Flag_NoGadgets|editable), 5) 
  SetData(Container(5, 45, 180, 30, #__Flag_NoGadgets|editable), 6) 
  SetData(Container(5, 60, 180, 30, #__Flag_NoGadgets|editable), 7) 
  
  SetData(Splitter(5, 80, 180, 50, 
                   Container(0,0,0,0, #__Flag_NoGadgets|editable), 
                   Container(0,0,0,0, #__Flag_NoGadgets|editable),
                   #PB_Splitter_Vertical|editable), 8) 
  
  CloseList()
  CloseList()
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
  SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  CloseList()
  CloseList()
  CloseList()
  CloseList()
  
  ; set text
  ForEach widget()
   ; SetText(widget( ), Str(GetData(widget())))
  Next
  
  
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
; CursorPosition = 82
; FirstLine = 67
; Folding = --
; EnableXP