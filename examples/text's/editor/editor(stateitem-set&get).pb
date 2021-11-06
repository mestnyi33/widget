IncludePath "../../../"
XIncludeFile "-widgets.pbi"

UseLib(widget)

LN=5
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 540, "editor set&get item state", #PB_Window_SystemMenu)
  EditorGadget(10, 10, 10, 250, 520, #PB_ListView_MultiSelect)
  
  Open(0, 270, 10, 250, 520);, "", #__flag_borderless)
  *w=Editor(0, 0, 250, 520, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
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
    AddGadgetItem (10, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(10)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetItemState(10, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  ; HideGadget(0, 0)
  
  Debug " -------- "
  
  ; Redraw(root())
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP