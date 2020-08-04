IncludePath "../../"
XIncludeFile "widgets.pbi"
;XIncludeFile "../empty.pb"
UseLib(widget)

Macro EventGadget()
  this()\widget
EndMacro

Macro EventType()
  this()\event
EndMacro

Procedure TestHandler()
  If EventType() = #PB_EventType_LeftClick
    Debug " "+GetState(EventGadget()) +" "+ GetItemText(EventGadget(), GetState(EventGadget()))
  EndIf
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 355, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ID = Tree(10, 10, 160, 160)                                         ; TreeGadget standard
  
  AddItem(ID, 5, "1", 0, 0)
  AddItem(ID, 6, "4", 0, 0)
  AddItem(ID, 1, "2", 0, 0)
  AddItem(ID, 3, "5", 0, 0)
  AddItem(ID, 2, "3", 0, 0)
  
  Bind(ID, @TestHandler())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP