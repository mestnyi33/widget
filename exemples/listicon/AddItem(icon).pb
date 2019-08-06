IncludePath "../../"
XIncludeFile "widgets.pbi"
UseModule Widget

Global *w
LN=800; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "treeGadget", #PB_Window_SystemMenu)
  
  Open(0, 270, 10, 250, 680, "")
  *w=listicon(0, 0, 250, 680, "column_0", 200, #PB_Flag_FullSelection)
  
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), -1);,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
  
  Redraw() ; Display() ; 
  
  ListIconGadget(0, 10, 10, 250, 680, "column_0", 200)
  ; HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0 );,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP