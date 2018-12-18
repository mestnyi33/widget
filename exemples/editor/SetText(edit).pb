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

Define Text.s, LN.i=15000; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 680)
  editor::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection) : *w.Widget_S=GetGadgetData(1)
  
  *Buffer = AllocateMemory(LN*100)
  *Pointer = *Buffer
  
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    Text.s = "Item "+Str(a) + #LF$
    CopyMemoryString(PeekS(@Text), @*Pointer) ; 3
    
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  
  Text = PeekS(*Buffer)
  Text.s = Trim(Text.s, #LF$)
  Debug "time "+Str(ElapsedMilliseconds()-time) 
  
  Editor::SetText(*w, Text.s)
  SetGadgetText(0, Text.s)
  
  Debug " - add widget count - " + Editor::CountItems(*w)
  Debug " - add gadget count - " + CountGadgetItems(0)
  
  
  Repeat 
    Event=WaitWindowEvent()
    
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP