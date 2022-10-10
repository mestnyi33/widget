IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf Defined(WIDGET, #PB_Module)
  UseLib(widget)
  Macro EventGadget() : EventWidget() : EndMacro
  Macro EventType() : WidgetEventType() : EndMacro
  Macro AddGadgetItem(gadget,position,text,imageID=0,flags=) : AddItem(gadget,position,text,imageID,flags) : EndMacro
  Macro BindGadgetEvent(gadget,callback,eventtype=0) : Bind(gadget,callback,eventtype) : EndMacro
  Macro GetGadgetState(gadget) : GetState(gadget) : EndMacro
  Macro GetGadgetItemText(gadget,position) : GetItemText(gadget,position) : EndMacro
  Macro TreeGadget(gadget,x,y,width,height,flags=0) : Tree(x,y,width,height,flags) : EndMacro
  Macro OpenWindow(window,x,y,width,height,text, flags=0) : Open(window,x,y,width,height,text,flags) : EndMacro
CompilerEndIf

Procedure TestHandler()
  If EventType() = #PB_EventType_LeftClick
    Debug " "+GetGadgetState(EventGadget()) +" "+ GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget()))
  EndIf
EndProcedure

If OpenWindow(#PB_Any, 0, 0, 355, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ID = TreeGadget(-1, 10, 10, 160, 160)                                         ; TreeGadget standard
  
  AddGadgetItem(ID, 5, "5-1", 0, 0)
  AddGadgetItem(ID, 6, "6-4", 0, 0)
  AddGadgetItem(ID, 1, "1-2", 0, 0)
  AddGadgetItem(ID, 3, "3-5", 0, 0)
  AddGadgetItem(ID, 2, "2-3", 0, 0)
  
  BindGadgetEvent(ID, @TestHandler())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP