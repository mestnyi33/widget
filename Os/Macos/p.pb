Global Dim MyArray.i(0)

Procedure.s GetClass(handle.i)
  Protected Result
  
  Result = CocoaMessage(0, handle, "className")
  CocoaMessage(@Result, Result, "UTF8String")
  
  If Result
    ProcedureReturn PeekS(Result, -1, #PB_UTF8)
  EndIf
EndProcedure

If OpenWindow(0, 0, 0, 322, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  PanelGadget     (0, 8, 8, 306, 203)
  AddGadgetItem (0, -1, "Panel 1")
  
  PanelGadget (1, 5, 5, 290, 166)
  AddGadgetItem(1, -1, "Sub-Panel 1")
  AddGadgetItem(1, -1, "Sub-Panel 2")
    AddGadgetItem(1, -1, "Sub-Panel 3")
    CloseGadgetList()
  
  AddGadgetItem (0, -1,"Panel 2")
  
    ButtonGadget(2, 10, 15, 80, 24,"Button 1")
    ButtonGadget(3, 95, 15, 80, 24,"Button 2")
    
  CloseGadgetList()
  
  ;SetGadgetState(0, 1)
  ;func ancestorShared(With: NSView) -> NSView?
  ;Debug "   class - "+GetClass(CocoaMessage(0, GadgetID(0), "ancestorShared"))
 
  Debug "Panel = " + GadgetID(0)
  Debug "Panel 1 = " + GadgetID(1)
  Debug "Button 2 = " + GadgetID(2)
  
  sv = CocoaMessage(0, GadgetID(1), "superview")
  Debug " class - "+GetClass(sv)
  sv = CocoaMessage(0, sv, "superview")
  Debug "  class - "+GetClass(sv)
  Debug "Parent from Panel 1 = " + sv
  
  sv = CocoaMessage(0, GadgetID(2), "superview")
  Debug " class - "+GetClass(sv)
  sv = CocoaMessage(0, sv, "superview")
  Debug "  class - "+GetClass(sv)
  Debug "Parent from Gadget 2 = " + sv
  
  
  ;CocoaMessage(0, GadgetID(0), "subviews", @MyArray())
  ;view = WindowID(0) ; GadgetID(0)
  view = GadgetID(1)
  subviews = CocoaMessage(0, view, "subviews")
  Debug CocoaMessage(0, subviews, "count") 
  i=0;CocoaMessage(0, subviews, "count") - 1
  
  Debug "get - "+GetClass(CocoaMessage(0, subviews, "objectAtIndex:", i))
  
;   Debug ArraySize(MyArray())
;   For i=0 To ArraySize(MyArray())
;   Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP