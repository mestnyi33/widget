; IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_17.pb"
;XIncludeFile "_module_tree_12_map.pb"
;XIncludeFile "_module_tree_10_2.pb"
;XIncludeFile "_module_tree_7_1_0.pb"

UseModule Tree
Global *w._S_widget
LN=1000  ; 14 количесвто итемов 32 плохо работает

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  *w=GetGadgetData(Gadget(5, 270, 10, 250, 680, #PB_Tree_NoButtons|#PB_Tree_NoLines)) 
  
  *w\hide = 1
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
  *w\hide = 0
  Redraw(*w)
  
  ListViewGadget(0, 10, 10, 250, 680) 
  HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  HideGadget(0, 0)
  
    
    Define time = ElapsedMilliseconds()
    count = CountItems(*w) : For a = 0 To count : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
    
    Define time = ElapsedMilliseconds()
    count = CountGadgetItems(0) : For a = 0 To count : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
  
  
;   Define time = ElapsedMilliseconds()
;   count = CountItems(*w) : For a = count To 0 Step - 1 : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
;   
;   Define time = ElapsedMilliseconds()
;   count = CountGadgetItems(0) : For a = count To 0 Step - 1 : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
  
  Redraw(*w)
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableXP