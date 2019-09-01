IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_7.pb"

UseModule Tree
LN=1000; количесвто итемов 
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_MultiSelect|#PB_Tree_NoButtons|#PB_Tree_NoLines)
  *w=GetGadgetData(1)
  
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     AddItem (*w, -1, "Item "+Str(a), 0)
;     SetItemState(*w, a, 1) ; set (beginning with 0) the tenth item as the active one
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
;   
;   ; HideGadget(0, 1)
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     AddGadgetItem (0, -1, "Item "+Str(a), 0)
;     SetGadgetItemState(0, a, 1) ; set (beginning with 0) the tenth item as the active one
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
;   ; HideGadget(0, 0)
  
  ;
  ;-
  ;
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetItemState(*w, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
  
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetItemState(0, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  ; HideGadget(0, 0)
  
  Redraw(*w)
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP