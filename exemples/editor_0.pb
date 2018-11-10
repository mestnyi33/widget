CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"

LN=1500; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "TreeGadget", #PB_Window_SystemMenu)
  editor::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection)
  Debug "---------------Start"
  Define time = ElapsedMilliseconds()
  
  For a = 0 To LN
    editor::AddItem (1, -1, "Item "+Str(a), 0,1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  
  PostEvent(#PB_Event_Gadget, 0, 1, #PB_EventType_Resize)
        
  Debug "---------------END "+Str(ElapsedMilliseconds()-time)
  
  EditorGadget(0, 10, 10, 250, 680)
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
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP