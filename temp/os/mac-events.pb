#NSKeyDown            = 10
#NSKeyUp              = 11
#NSFlagsChanged       = 12

#NSAlphaShiftKeyMask = 1 << 16
#NSShiftKeyMask      = 1 << 17
#NSControlKeyMask    = 1 << 18
#NSAlternateKeyMask  = 1 << 19
#NSCommandKeyMask    = 1 << 20

Global sharedApplication = CocoaMessage(0, 0, "NSApplication sharedApplication")
Define currentEvent, type, modifierFlags


If OpenWindow(0, 0, 0, 320, 230, "Test modifierFlags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  EditorGadget(0, 10, 10, 300, 100)
  CanvasGadget(10, 10, 110, 300, 100)
  
  Repeat;/
    
    Event = WaitWindowEvent()
    currentEvent = CocoaMessage(0, sharedApplication, "currentEvent")
    
    If currentEvent
      type = CocoaMessage(0, currentEvent, "type")
      ;Debug type 
      If type = #NSMouseEntered
        Debug "en"
      EndIf
      If type = #NSMouseExited
        Debug "le"
      EndIf
      If type = #NSLeftMouseDown
        Debug "down"
      EndIf
      If type = #NSLeftMouseUp
        Debug "up"
      EndIf
      
      If type = #NSFlagsChanged
        modifierFlags = CocoaMessage(0, currentEvent, "modifierFlags")
        
        SetGadgetText(0, "Modifier keys pressed")
        AddGadgetItem(0, -1, "=====================")
        If modifierFlags & #NSAlphaShiftKeyMask  
          AddGadgetItem(0, -1, "Caps lock is on")
        Else
          AddGadgetItem(0, -1, "Caps lock is off")
        EndIf
        If modifierFlags & #NSShiftKeyMask
          AddGadgetItem(0, -1, "Shift key is pressed")
        EndIf
        If modifierFlags & #NSControlKeyMask
          AddGadgetItem(0, -1, "Ctrl key is pressed")
        EndIf
        If modifierFlags & #NSAlternateKeyMask
          AddGadgetItem(0, -1, "Alt key is pressed")
        EndIf
        If modifierFlags & #NSCommandKeyMask
          AddGadgetItem(0, -1, "Cmd key is pressed")
        EndIf
        
      EndIf
    EndIf
    
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP