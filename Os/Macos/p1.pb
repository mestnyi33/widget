Procedure Set( Gadget, ParentID, Item=#PB_Default ) ; Set a new parent for the gadget
  
  If IsGadget( Gadget ) ; NSObject
    
    If ParentID

      ; Debug CocoaMessage(0, 0, "window")
      ParentID = CocoaMessage(0, GadgetID(3), "superview")
      
      ;Debug CocoaMessage(0, GadgetID(3), "ancestorShared:", @"with:")
      Debug ParentID
      Debug WindowID(10)
      
      CocoaMessage (0, ParentID, "addSubview:", GadgetID (Gadget), "positioned:", -1, "relativeTo:", #nil) 
    EndIf
    
    ProcedureReturn ParentID
  EndIf
EndProcedure

OpenWindow(10, 440, 0, 600, 340, "Gadget Reordering", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
ButtonGadget(4, 10, 25, 100, 30, "Button " + Str(4))

If OpenWindow(0, 0, 0, 600, 340, "Gadget Reordering", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  
  ButtonGadget(1, 10, 10, 100, 40, "Button " + Str(1))
  ButtonGadget(2, 10, 25, 100, 30, "Button " + Str(2))
  ButtonGadget(3, 10, 35, 100, 30, "Button " + Str(3))
  
  ;  CocoaMessage (0, CocoaMessage(0, GadgetID(1), "superview"), "addSubview:", GadgetID (1), "positioned:", 1, "relativeTo:", GadgetID (2)) 
  ;  CocoaMessage (0, CocoaMessage(0, GadgetID(1), "superview"), "addSubview:", GadgetID (1), "positioned:", -1, "relativeTo:", GadgetID (3)) 
   ; CocoaMessage (0, CocoaMessage(0, GadgetID(3), "superview"), "replaceSubview:",GadgetID(3),  "with:", GadgetID(4))
    CocoaMessage (0, CocoaMessage(0, GadgetID(3), "superview"), "isDescendant:",GadgetID(3),  "of:", GadgetID(4))
  ;  func replaceSubview(NSView, With: NSView)
  Repeat
    EventID = WaitWindowEvent()
    
    If EventID = #PB_Event_Gadget
      ;  Gadget_BringToFront(EventGadget())
    ElseIf EventID = #PB_Event_LeftClick
      Debug set(1, WindowID(10))
    EndIf
  Until EventID = #PB_Event_CloseWindow
  
EndIf


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP