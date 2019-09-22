; проблема с перерисовкой линии

IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_12.pb"
;XIncludeFile "_module_tree_10_2.pb"
;XIncludeFile "_module_tree_7_1_0.pb"

UseModule Tree
Global *w._s_widget

OpenWindow(0, 0, 0, 410, 300, "", #PB_Window_SystemMenu)
TreeGadget(0, 5, 5, 200, 260)

AddGadgetItem(0, -1, "Item 1", 0, 0)
AddGadgetItem(0, -1, "Item 2", 0, 0)
AddGadgetItem(0, -1, "Item 3", 0, 1)
AddGadgetItem(0, -1, "Item 4", 0, 1)

SetGadgetItemState(0, 1, #PB_Tree_Expanded)


 *w = GetGadgetData(Gadget(10, 205, 5, 200, 260))
ButtonGadget(1, 25, 270, 120, 24, "Add Item")

AddItem(*w, -1, "Item 1", 0, 0)
AddItem(*w, -1, "Item 2", 0, 0)
AddItem(*w, -1, "Item 3", 0, 1)
AddItem(*w, -1, "Item 4", 0, 1)

SetItemState(*w, 1, #PB_Tree_Expanded)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 1
          AddGadgetItem(0, 1, "Added #1", 0, 0)
          AddGadgetItem(0, 2, "Added #2", 0, 1)
          AddGadgetItem(0, 3, "Added #3", 0, 1)
          
          SetGadgetItemState(0, 1, #PB_Tree_Expanded)
          SetGadgetState(0, 1)
          
          AddItem(*w, 1, "Added #1", 0, 0)
          AddItem(*w, 2, "Added #2", 0, 1)
          AddItem(*w, 3, "Added #3", 0, 1)
          
          SetState(*w, 1)
          SetItemState(*w, 1, #PB_Tree_Expanded)
          
          redraw(*w)
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP