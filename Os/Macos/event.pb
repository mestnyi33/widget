#NSFlagsChanged       = 12
#NSControlKeyMask    = 1 << 18

Global sharedApplication = CocoaMessage(0, 0, "NSApplication sharedApplication")
Define currentEvent, type, modifierFlags


If OpenWindow(0, 0, 0, 320, 170, "Test modifierFlags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
    ListViewGadget(0, 10, 10, 300, 100)
    For type=1 To 5
        AddGadgetItem(0, -1, "line "+Str(type))
    Next
   
    ButtonGadget(1, 10,120, 100,  25, "Button",#PB_Button_Default)
 
  Repeat
    Event = WaitWindowEvent() ; comes first in loop

    currentEvent = CocoaMessage(0, sharedApplication, "currentEvent")
    If currentEvent
        type = CocoaMessage(0, currentEvent, "type")
        If type = #NSFlagsChanged
            modifierFlags = CocoaMessage(0, currentEvent, "modifierFlags")
        EndIf
    EndIf
   
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case 1
          If modifierFlags & #NSControlKeyMask
              SetGadgetItemText(0, 0, "Right-click button") ; "Ctrl key is pressed")
          Else
              SetGadgetItemText(0, 0, "Left-click button")
          EndIf
      Case 0
          lne=GetGadgetState(0)
          If modifierFlags & #NSControlKeyMask
              SetGadgetItemText(0, 0, "Right-click on line "+Str(lne)) ; "Ctrl key is pressed")
          Else
              SetGadgetItemText(0, 0, "Left-click on line "+Str(lne))
          EndIf
        EndSelect
    EndIf
  Until event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP