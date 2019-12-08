IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"

UseModule Tree
Global *w._S_widget

Global Space

Procedure OnChange()
   Debug Space(Space)+"OnChange() start " + EventType() +" "+ *event\type
   Debug Space(Space)+"  Event Items: " + CountItems(*w) +" "+ CountGadgetItems(0)
   Debug Space(Space)+"OnChange() end"
EndProcedure

Procedure OnClick()
   Debug "OnClick() start"
   Debug "  Clear Items"
   Space = 5
   ;
   ;SetState(*w, -1)
   ;
   ClearItems(*w)
   ClearGadgetItems(0)
   
   Debug "  Items cleared"
   Debug "OnClick() end"
EndProcedure


If OpenWindow(0, 0, 0, 340, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   TreeGadget(0, 10, 10, 155, 130, #PB_Tree_CheckBoxes)
   ButtonGadget(1, 140, 130, 60, 25, "Clear")
   
   AddGadgetItem(0, -1, "Line " + Str(i))
   For i = 1 To 5
     AddGadgetItem(0, -1, "Line " + Str(i), 0, 1+Bool(i=3)-Bool(i=5))
   Next i
   For i=0 To CountGadgetItems(0) : SetGadgetItemState(0, i, #PB_Tree_Expanded) : Next
    
   BindGadgetEvent(0, @OnChange());, #PB_EventType_Change)
   
   *w = GetGadgetData(Tree::Gadget(10, 175, 10, 155, 130, #__tree_CheckBoxes | #__tree_AlwaysSelection)) ;| #__tree_Collapse
   ButtonGadget(1, 140, 150, 60, 25, "Clear")
   
   AddItem(*w, -1, "Line " + Str(i))
   For i = 1 To 5
     AddItem(*w, -1, "Line " + Str(i), -1, 1+Bool(i=3)-Bool(i=5))
   Next i
   
   Bind(*w, @OnChange());, #PB_EventType_Change)
   BindGadgetEvent(1, @OnClick())
   
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP