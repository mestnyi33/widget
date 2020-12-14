IncludePath "../../"
XIncludeFile "widgets.pbi"
UseLib(widget)


CompilerIf #PB_Compiler_IsMainFile
UseModule Widget
Global *w._S_widget
Define i

If OpenWindow(0, 0, 0, 390, 250, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TreeGadget(0, 10, 10, 180, 230)
    
    Open(0, 200, 10, 180, 230);, "", #__flag_borderless)
    *w = Tree(0, 0, 180, 230)
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
      AddItem(*w, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
    Next
    
    SetGadgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadgetItemColor(0,  3, #PB_Gadget_BackColor,  $00FFFF)
    SetGadgetItemColor(0,  7, #PB_Gadget_BackColor,  $FFFF00)
    
    SetItemColor(*w, #PB_All, #__Color_Front, $FF0000FF)
    SetItemColor(*w,  3, #__Color_Back,  $FF00FFFF)
    SetItemColor(*w,  7, #__Color_Back,  $FFFFFF00)
    SetItemFont(*w,  7, (LoadFont(#PB_Any, "Helvetica", 18)))
    
    SetItemColor(*w,  3, #__Color_Frame,  $FF0000f0)
    
    SetItemFont(*w,  3, (LoadFont(#PB_Any, "Helvetica", 25)))
    
    SetItemColor(*w,  #PB_All, #__Color_Front,  $FF00FFFF, 2)
    SetItemColor(*w,  #PB_All, #__Color_Back,  $FF3F00F0, 2)
    
    SetItemColor(*w,  #PB_All, #__Color_Line,  $FF3F00F0)
    
    redraw(root())
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP