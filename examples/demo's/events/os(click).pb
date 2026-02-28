Global *this,  w_flag
Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"

Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect
    
    SetGadgetState(gadget, state)
  EndProcedure
  
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If GetGadgetState(gadget) >= 0
          SetGadgetState_(gadget, CountGadgetItems(gadget) - 1)
        EndIf
    CompilerEndSelect
  EndProcedure
  
 Procedure events_widgets()
  Protected result
    
    Select EventType()
      Case #PB_EventType_LeftButtonDown : result = 1 : AddGadgetItem_(w_flag, -1, "down")
      Case #PB_EventType_LeftButtonUp    : result = 1 : AddGadgetItem_(w_flag, -1, " up")
      Case #PB_EventType_LeftClick       : result = 1 : AddGadgetItem_(w_flag, -1, "  click") 
      Case #PB_EventType_LeftDoubleClick : result = 1 : AddGadgetItem_(w_flag, -1, "   2_click") 
    EndSelect
    
    If result
      SetGadgetState_(w_flag, CountGadgetItems(w_flag) - 1)
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP