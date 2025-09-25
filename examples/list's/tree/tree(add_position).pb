IncludePath "../../../"
; XIncludeFile "widgets.pbi"

CompilerIf Defined(widget, #PB_Module)
  UseWidgets( )
  Macro EventGadget() : EventWidget( ) : EndMacro
  Macro EventType() : WidgetEventType( ) : EndMacro
  Macro AddGadgetItem(gadget,position,Text,imageID=0,flags=) : AddItem(gadget,position,Text,imageID,flags) : EndMacro
  Macro BindGadgetEvent(gadget,callback,eventtype=-1) : Bind(gadget,callback,eventtype) : EndMacro
  Macro GetGadgetState(gadget) : GetState(gadget) : EndMacro
  Macro GetGadgetItemText(gadget,position) : GetItemText(gadget,position) : EndMacro
  Macro TreeGadget(gadget,X,Y,Width,Height,flags=0) : Tree(X,Y,Width,Height,flags) : EndMacro
  Macro OpenWindow(window,X,Y,Width,Height,Text, flags=0) : Open(window,X,Y,Width,Height,Text,flags) : EndMacro
CompilerEndIf

Define ID

Procedure TestHandler()
  If EventType() = #PB_EventType_LeftClick
    Debug " "+GetGadgetState(EventGadget()) +" "+ GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget()))
  EndIf
EndProcedure

If OpenWindow(0, 0, 0, 355, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ID = TreeGadget(#PB_Any, 10, 10, 160, 160) ; TreeGadget standard
  
  AddGadgetItem(ID, 5, "1-5", 0, 0)
  AddGadgetItem(ID, 6, "4-6", 0, 0)
  AddGadgetItem(ID, 1, "2-1", 0, 0)
  AddGadgetItem(ID, 3, "5-3", 0, 0)
  AddGadgetItem(ID, 2, "3-2", 0, 0)
  
  BindGadgetEvent(ID, @TestHandler())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 1
; Folding = ---
; EnableXP
; DPIAware