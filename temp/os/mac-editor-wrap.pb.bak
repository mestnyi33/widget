Procedure EditorGadget_SetWordWrap(EditorGadget, wrap)
  Protected Size.NSSize
  Protected EditorGadgetID = GadgetID(EditorGadget)
  Protected Container.i = CocoaMessage(0, EditorGadgetID, "textContainer")
  CocoaMessage(@Size, Container, "containerSize")
  Debug Size\width  
  If wrap
    Size\width = GadgetWidth(EditorGadget) - 2
  Else
    Size\width = $FFFF
  EndIf
  CocoaMessage(0, Container, "setContainerSize:@", @Size)
EndProcedure

OpenWindow(0, 270, 100, 250, 110, "Word Wrap Test", #PB_Window_SystemMenu)
EditorGadget(0, 10, 10, 230, 60);, #PB_Editor_WordWrap)
ButtonGadget(1, 60, 80, 140, 25, "Toggle Word Wrap")

For i = 1 To 5
  Text$ = Text$ + "This is a word wrap test - "
Next i

SetGadgetText(0, Text$)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 1
        WordWrap ! 1
        EditorGadget_SetWordWrap(0, WordWrap)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP