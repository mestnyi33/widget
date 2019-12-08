IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"

UseModule Tree
LN=1000; количесвто итемов 

Global *w._S_widget
Global *w1._S_widget

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 150)    ;, #PB_ListView_MultiSelect
  Gadget(1, 270, 10, 250, 150, #__tree_GridLines|#__tree_NoButtons|#__tree_NoLines)  ; |#__tree_MultiSelect
  *w=GetGadgetData(1)
  
  ListViewGadget(10, 10, 170, 250, 520, #PB_ListView_MultiSelect)
  Gadget(11, 270, 170, 250, 520, #__tree_GridLines|#__tree_MultiSelect|#__tree_NoButtons|#__tree_NoLines)
  *w1=GetGadgetData(11)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget_0 add items time count - " + CountItems(*w)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w1, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget_1 add items time count - " + CountItems(*w1)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget_0 add items time count - " + CountGadgetItems(0)
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (10, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget_1 add items time count - " + CountGadgetItems(10)
  
  Debug ""
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetState(*w, a-1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set state time"
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetItemState(*w1, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetState(0, a-1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set state time"
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetItemState(10, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  
  Debug ""
  
  Redraw(*w)
  Redraw(*w1)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP