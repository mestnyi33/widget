Global *this,  w_flag
Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"

Procedure events_widgets()
  Protected result
    Static _2click
    
    Select EventType()
      Case #PB_EventType_LeftButtonDown : result = 1
        If _2click = 2
          _2click = 0
          ClearGadgetItems(w_flag)
        EndIf
        AddGadgetItem(w_flag, -1, "down")
        
      Case #PB_EventType_LeftButtonUp    : result = 1 : AddGadgetItem(w_flag, -1, " up")
      Case #PB_EventType_LeftClick       : result = 1 : AddGadgetItem(w_flag, -1, "  click") : _2click + 1
      Case #PB_EventType_LeftDoubleClick : result = 1 : AddGadgetItem(w_flag, -1, "   2_click") : _2click = 2
    EndSelect
    
    If result
      SetGadgetState(w_flag, CountGadgetItems(w_flag) - 1)
    EndIf
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