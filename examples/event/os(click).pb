Global *this,  w_flag
Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"

Procedure events_widgets()
  Static _2click
  Protected flag
  
  Select EventType()
    Case #PB_EventType_LeftButtonDown
      If _2click = 3
        _2click = 0
        ClearGadgetItems(w_flag)
      EndIf
      AddGadgetItem(w_flag, -1, "down")
    Case #PB_EventType_LeftButtonUp
      AddGadgetItem(w_flag, -1, "up")
    Case #PB_EventType_LeftClick
      AddGadgetItem(w_flag, -1, "click")
      _2click + 1
    Case #PB_EventType_LeftDoubleClick
      AddGadgetItem(w_flag, -1, "2_click")
      _2click = 3
  EndSelect
  
  SetGadgetState(w_flag, CountGadgetItems(w_flag) - 1)
EndProcedure

If OpenWindow(#PB_Any, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  w_flag = TreeGadget(-1, 10, 10, 150, 200, #PB_Tree_NoButtons|#PB_Tree_NoLines) 
  *this = CanvasGadget(-1, 10, 220, 150, 70) 
  
  
  BindGadgetEvent(*this, @events_widgets(), #PB_EventType_LeftButtonDown)
  BindGadgetEvent(*this, @events_widgets(), #PB_EventType_LeftButtonUp)
  BindGadgetEvent(*this, @events_widgets(), #PB_EventType_LeftClick)
  BindGadgetEvent(*this, @events_widgets(), #PB_EventType_LeftDoubleClick)
  
  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP