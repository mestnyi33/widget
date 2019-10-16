;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_18.pb"
;XIncludeFile "_module_tree_7.pb"

UseModule Tree
LN=500; количесвто итемов 
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  *w=GetGadgetData(Gadget(1, 270, 10, 250, 680, #PB_Flag_GridLines|#PB_Tree_NoButtons|#PB_Tree_NoLines |#PB_Flag_MultiSelect))
  
  a=0
  *w\hide = 1
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
    
    If a & $f=$f
      WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If a & $8ff=$8ff
      WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  *w\hide = 0
  Redraw(*w)
      
   HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
    
    If a & $f=$f
      WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If a & $8ff=$8ff
      WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
   HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP