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

LN=150; количесвто итемов 
 
If OpenWindow(0, 0, 0, 270, 270, "treeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TreeGadget(0, 10, 10, 250, 120)
  tree::Gadget(1, 10, 140, 250, 120) : *w=GetGadgetData(1)
    
  For a = 1 To LN
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the tree") ; define tree content
  Next
  SetGadgetState(0, 3) ; set (beginning with 0) the tenth item as the active one
  ; SetActiveGadget(0)
  
  For a = 1 To LN
    tree::AddItem (*w, -1, "Item " + Str(a) + " of the tree") ; define tree content
  Next
  tree::SetState(*w, 3) ; set (beginning with 0) the tenth item as the active one
  
  Debug " get state - " + tree::GetState(*w)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP