IncludePath "../../../../"
 ;XIncludeFile "widgets.pbi"

CompilerIf Defined(widgets, #PB_Module)
  UseWidgets( )
  Macro EventGadget() : EventWidget( ) : EndMacro
  Macro EventType() : WidgetEventType( ) : EndMacro
  Macro AddGadgetItem(Gadget,position,Text,imageID=0,flags=) : AddItem(Gadget,position,Text,imageID,flags) : EndMacro
  Macro BindGadgetEvent(Gadget,callback,eventtype=-1) : Bind(Gadget,callback,eventtype) : EndMacro
  Macro GetGadgetState(Gadget) : GetState(Gadget) : EndMacro
  Macro GetGadgetItemText(Gadget,position) : GetItemText(Gadget,position) : EndMacro
  Macro TreeGadget(Gadget,X,Y,Width,Height,flags=0) : Tree(X,Y,Width,Height,flags) : EndMacro
  Macro OpenWindow(Window,X,Y,Width,Height,Text, flags=0) : Open(Window,X,Y,Width,Height,Text,flags) : EndMacro
CompilerEndIf

Define a, ID, CountItems = 20

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
  
  
;   For a = 0 To CountItems
;      AddGadgetItem(ID, -1, "item "+Str(a), 0, 1)
;   Next
;   For a = 0 To CountItems
;      If a % 5 = 0
;         AddGadgetItem(ID, a, "--- ["+Str(a) +"] ---", 0, 0)
;      EndIf
;   Next
  
  BindGadgetEvent(ID, @TestHandler())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 31
; FirstLine = 22
; Folding = ---
; EnableXP
; DPIAware