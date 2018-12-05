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

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 10, 10, 250, 120)
  editor::Gadget(1, 10, 140, 250, 120) : *w=GetGadgetData(1)
    
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  For a = 1 To 12
    editor::AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  editor::SetState(*w, -1) ; 119) ; set caret pos   
  
  
  Debug " get state - " + editor::GetState(*w)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP