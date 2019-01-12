Procedure DebugSubviews(view, level=0)
  Protected subviews, i, n
  Debug Space(level*3) + PeekS(CocoaMessage(0, CocoaMessage(0, view, "className"), "UTF8String"), -1, #PB_UTF8)
  subviews = CocoaMessage(0, view, "subviews")
  n = CocoaMessage(0, subviews, "count") - 1
  For i = 0 To n
    DebugSubviews(CocoaMessage(0, subviews, "objectAtIndex:", i), level + 1)
  Next
EndProcedure

Procedure DebugViewHierarchy(Window)
  Debug "--- View hierarchy ---"
  DebugSubviews(CocoaMessage(0, WindowID(Window), "contentView"))
  Debug "---------------"  
EndProcedure


OpenWindow(0, 0, 0, 320, 320, "Canvas container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CanvasGadget(0, 10, 10, 300, 300, #PB_Canvas_Container)
ListViewGadget(1, 50, 10, 150, 50)
CloseGadgetList()
AddGadgetItem(1,-1, "ListView_1")
AddGadgetItem(1,-1, "ListView_2")

DebugViewHierarchy(0)

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP