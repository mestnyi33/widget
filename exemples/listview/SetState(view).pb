CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_bar.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_listview.pbi"

LN=15 ; количесвто итемов 
pos=7

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(0, 10, 10, 250, 120)
  ListView::Gadget(1, 10, 140, 250, 120, #PB_Flag_GridLines) : *w=GetGadgetData(1)
    
  For a = 1 To LN
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(0, pos) ; set (beginning with 0) the tenth item as the active one
  
  For a = 1 To LN
    ListView::AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  ListView::SetState(*w, pos) ; set (beginning with 0) the tenth item as the active one
  
  Debug " get state - " + ListView::GetState(*w)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP