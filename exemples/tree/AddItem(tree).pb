; ; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
; ;   IncludePath "/Users/as/Documents/GitHub/Widget/"
; ; CompilerElse
;    IncludePath "../../"
; ; CompilerEndIf
; 
; XIncludeFile "module_macros.pbi"
; XIncludeFile "module_constants.pbi"
; XIncludeFile "module_structures.pbi"
; XIncludeFile "module_bar.pbi"
; XIncludeFile "module_text.pbi"
; XIncludeFile "module_editor.pbi"
; XIncludeFile "module_tree.pbi"
IncludePath "../../"
XIncludeFile "widgets.pbi"

UseModule Widget
Procedure Gadget(Window, X,Y,Width,Height, Flag)
  Open(Window, X,Y,Width,Height,"")
  ProcedureReturn Tree(0, 0, Width,Height, Flag)
EndProcedure

LN=1500; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "treeGadget", #PB_Window_SystemMenu)
  TreeGadget(0, 10, 10, 250, 680)
  ;Tree(1, 270, 10, 250, 680, #PB_Flag_FullSelection) : *w=GetGadgetData(1)
  *w=Gadget(0, 270, 10, 250, 680, #PB_Flag_FullSelection)
  
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
  
  Redraw(*w)
  
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
; Folding = --
; EnableXP