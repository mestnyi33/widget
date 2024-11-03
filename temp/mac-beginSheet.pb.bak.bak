Global NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")

Procedure BeginSheet(SheetWindowID, ParentWindowID)
  CocoaMessage(0, NSApp, "beginSheet:", SheetWindowID, "modalForWindow:", ParentWindowID, "modalDelegate:", #nil, "didEndSelector:", 0, "contextInfo:", 0); <= OSX 10.8
  ;CocoaMessage(0, ParentWindowID, "beginSheet:", SheetWindowID, "completionHandler:", #nil); >= OSX 10.9
EndProcedure

Procedure EndSheet(Sheet, ParentWindowID)
  CocoaMessage(0, NSApp, "endSheet:", SheetWindowID); <= OSX 10.8
  ;CocoaMessage(0, ParentWindowID, "endSheet:", SheetWindowID); >= OSX 10.9
  CocoaMessage(0, SheetWindowID, "orderOut:", #nil)
EndProcedure


OpenWindow(1, 0, 0, 140, 95, "", #PB_Window_SystemMenu | #PB_Window_Invisible); Sheet window has to be invisible
ComboBoxGadget(1, 20, 20, 100, 25)
For a = 1 To 5
  AddGadgetItem(1, -1,"ComboBox item " + Str(a))
Next
ButtonGadget(2, 20, 50, 100, 25, "Close")
SheetWindowID = WindowID(1)

OpenWindow(0, 270, 100, 300, 300, "")
ButtonGadget(0, 20, 20, 100, 25, "Click me!")
ParentWindowID = WindowID(0)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 0; "Click me!" button on window clicked
          BeginSheet(SheetWindowID, ParentWindowID)
        Case 1
          Debug "ComboBox event"
        Case 2; "Close" button on sheet clicked
          EndSheet(SheetWindowID, ParentWindowID)
          Debug "ComboBox state : " + Str(GetGadgetState(1))
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 3
; Folding = -
; EnableXP