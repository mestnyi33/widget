CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_listview.pbi"

LN=1500; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListView::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection)
  Debug "---------------Start"
  Define time = ElapsedMilliseconds()
  
  For a = 0 To LN
    ListView::AddItem (1, -1, "Item "+Str(a), 0,1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  
  PostEvent(#PB_Event_Gadget, 0, 1, #PB_EventType_Resize)
        
  Debug "---------------END "+Str(ElapsedMilliseconds()-time)
  
  Text::Redraw(GetGadgetData(1), 1)
  
  ListViewGadget(0, 10, 10, 250, 680)
  Debug "---------------Start"
  ; HideGadget(0, 1)
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
  ; HideGadget(0, 0)
  
  
  Define time = ElapsedMilliseconds()
  ListView::ClearItems(1)
  Debug Str(ElapsedMilliseconds()-time) + " - clear widget items time "
  
  Define time = ElapsedMilliseconds()
  ClearGadgetItems(0)
  Debug Str(ElapsedMilliseconds()-time) + " - clear gadget items time "
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP