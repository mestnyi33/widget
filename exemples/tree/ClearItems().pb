CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_tree.pbi"

LN=1500; количесвто итемов 
Define m.s=#LF$
Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
If OpenWindow(0, 100, 50, 530, 700, "treeGadget", #PB_Window_SystemMenu)
  TreeGadget(0, 10, 10, 250, 680) : SetGadgetText(0, Text.s)
  tree::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection) : *w=GetGadgetData(1) : tree::SetText(*w, Text.s)
  
  
  Debug " - add - "
  Define time = ElapsedMilliseconds()
  For a = 3 To LN
    tree::AddItem (*w, -1, "Item "+Str(a), 0,1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + tree::CountItems(*w)
  Text::Redraw(*w)
  
  ; HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 3 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Debug " - clears - "
  Delay(1000)
  
  Define time = ElapsedMilliseconds()
  tree::ClearItems(*w) : Debug Str(ElapsedMilliseconds()-time) + " - clear widget items time count - " + tree::CountItems(*w)
  
  Define time = ElapsedMilliseconds()
  ClearGadgetItems(0) : Debug Str(ElapsedMilliseconds()-time) + " - clear gadget items time count - " + CountGadgetItems(0)
  
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 3
; Folding = --
; EnableXP