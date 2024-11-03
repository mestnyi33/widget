; comment uncomment to see
XIncludeFile "../../gadgets.pbi" : UseModule gadget

Procedure events_gadgets()
  Select EventType()
    Case #PB_EventType_Change
      ClearDebugOutput()
      Debug  ""+ EventGadget() +" - gadget change state " + GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget click"
  EndSelect
EndProcedure

; Shows possible flags of TextGadget in action...
If OpenWindow(0, 0, 0, 222, 230, "TextGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetWindowColor(0, $ff00ff)
  TextGadget(0, 10, 10, 200, 30, "Standard text")
  TextGadget(1, 10, 50, 200, 60, "Center text", #PB_Text_Center|#PB_Text_Border)
  TextGadget(2, 10, 70+50, 200, 30, "Right text", #PB_Text_Right)
  TextGadget(3, 10,100+60, 200, 60, "Center right text", #PB_Text_Center|#PB_Text_Right|#PB_Text_Border)
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP