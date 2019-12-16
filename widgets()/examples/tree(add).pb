IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"

UseModule Tree
LN=100; количесвто итемов 
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 700, "tree", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  *w=GetGadgetData(Gadget(1, 270, 10, 250, 680, #__tree_GridLines|#__tree_MultiSelect|#__tree_NoButtons|#__tree_NoLines ))
  
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
      
;    HideGadget(0, 1)
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     AddGadgetItem (0, -1, "Item "+Str(a), 0)
;     
;     If a & $f=$f
;       WindowEvent() ; это нужно чтобы раздет немного обновлялся
;     EndIf
;     If a & $8ff=$8ff
;       WindowEvent() ; это позволяет показывать скоко циклов пройшло
;       Debug a
;     EndIf
;   Next
;   Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
;    HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP