IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf Defined(WIDGET, #PB_Module)
  UseWidgets( )
  Macro EventGadget() : EventWidget() : EndMacro
  Macro EventType() : ToPBEventType(WidgetEvent()) : EndMacro
  Macro AddGadgetItem(gadget,position,text,imageID=0,flags=) : AddItem(gadget,position,text,imageID,flags) : EndMacro
  Macro BindGadgetEvent(gadget,callback,eventtype=0) : BindWidgetEvent(gadget,callback,eventtype) : EndMacro
  Macro GetGadGetWidgetState(gadget) : GetWidgetState(gadget) : EndMacro
  Macro GetGadGetWidgetItemText(gadget,position) : GetWidgetItemText(gadget,position) : EndMacro
  Macro TreeGadget(gadget,x,y,width,height,flags=0) : TreeWidget(x,y,width,height,flags) : EndMacro
  Macro OpenWindow(window,x,y,width,height,text, flags=0) : OpenRoot(window,x,y,width,height,text,flags) : EndMacro
CompilerEndIf

Procedure TestHandler()
  If EventType() = #PB_EventType_LeftClick
    Debug " "+GetGadGetWidgetState(EventGadget()) +" "+ GetGadGetWidgetItemText(EventGadget(), GetGadGetWidgetState(EventGadget()))
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; FirstLine = 1
; Folding = ---
; EnableXP
; DPIAware