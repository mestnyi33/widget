IncludePath "../../"
XIncludeFile "widgets.pbi"

UseModule Widget
Procedure Gadget(Window, X,Y,Width,Height, Flag)
  Open(Window, X,Y,Width,Height,"")
  ProcedureReturn Tree(0, 0, Width,Height, Flag)
EndProcedure


LN=150; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "TreeGadget", #PB_Window_SystemMenu)
  *w=Gadget(0, 270, 10, 250, 680, #PB_Flag_FullSelection)
  Debug "---------------Start"
  Define time = ElapsedMilliseconds()
  
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a));, 0);,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  ReDraw(Root())
  
  Debug "---------------END "+Str(ElapsedMilliseconds()-time)
  
  TreeGadget(0, 10, 10, 250, 680)
  Debug "---------------Start"
  Define time = ElapsedMilliseconds()
  
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  
  Debug "---------------END "+Str(ElapsedMilliseconds()-time)
  

  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP