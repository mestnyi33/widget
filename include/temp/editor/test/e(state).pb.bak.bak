;IncludePath "../../"
XIncludeFile "widgets.pbi"

; ver 1.0.6
; 361 - widget add items time count - 101
; 85 - widget set items state time
; 23 - gadget add items time count - 101
; 0 - gadget set items state time
; -------- 
; 917 - widget add items time count - 101
; 60 - widget set items state time
; 29 - gadget add items time count - 101
; 0 - gadget set items state time
; -------- 

; ver 1.0.2
; 306 - widget add items time count - 101
; 80 - widget set items state time
; 25 - gadget add items time count - 101
; 0 - gadget set items state time
; -------- 
; 858 - widget add items time count - 101
; 267 - widget set items state time
; 29 - gadget add items time count - 101
; 0 - gadget set items state time
; -------- 



LN=100; количесвто итемов 
Global *w

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 150)    ;, #PB_ListView_MultiSelect
  
  Open(0, 270, 10, 250, 150)
  *w=Editor(0, 0, 250, 150);, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetState(*w, a-1) ; set (beginning with 0) the tenth item as the active one
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
    SetGadgetState(0, a-1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  ; HideGadget(0, 0)
  
  Redraw(root())
  
  Debug " -------- "
  
  EditorGadget(10, 10, 170, 250, 520, #PB_ListView_MultiSelect)
  
  Open(0, 270, 170, 250, 520);, "", #__flag_borderless)
  *w=Editor(0, 0, 250, 520);, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
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
  
  Redraw(root())
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 23
; Folding = -
; EnableXP