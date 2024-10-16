﻿; comment uncomment to see
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

; Shows possible flags of ButtonGadget in action...
If OpenWindow(#PB_Any, 0, 0, 222, 200, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
  ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
  ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
  ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine|#PB_Button_Default)
  ButtonGadget(4, 10,170, 200, 20, "Toggle Button", #PB_Button_Toggle)
  
  For i = 0 To 4
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP