If OpenWindow(0, 0, 0, 422, 650, "Color list", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 8, 8, 406, 633)
 
  Lists = CocoaMessage(0, 0, "NSColorList availableColorLists")
  NumLists = CocoaMessage(0, Lists, "count")
  For l = 1 To NumLists
    ColorList = CocoaMessage(0, Lists, "objectAtIndex:", l - 1)
    ColorListName.s = PeekS(CocoaMessage(0, CocoaMessage(0, ColorList, "name"), "UTF8String"), -1, #PB_UTF8)
    Keys = CocoaMessage(0, ColorList, "allKeys")
    NumKeys = CocoaMessage(0, Keys, "count")
    For k = 1 To NumKeys
      Key = CocoaMessage(0, Keys, "objectAtIndex:", k - 1)
      KeyName.s = PeekS(CocoaMessage(0, Key, "UTF8String"), -1, #PB_UTF8)
      AddGadgetItem(0, -1, ColorListName + " -> " + KeyName)
    Next
  Next
 
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP