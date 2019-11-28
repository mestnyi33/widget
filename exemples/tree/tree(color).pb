IncludePath "../../"
XIncludeFile "widgets().pbi"


CompilerIf #PB_Compiler_IsMainFile
UseModule Widget
Global *w._S_widget

If OpenWindow(0, 0, 0, 590, 300, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TreeGadget(0, 10, 10, 280, 280)
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text 1");+Chr(10)+"Text 2")
    Next

    SetGadgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadgetItemColor(0,  3, #PB_Gadget_BackColor,  $00FFFF)
    SetGadgetItemColor(0,  9, #PB_Gadget_BackColor,  $FFFF00)
    
    Open(0, 300, 10, 280, 280, "", #__flag_borderless)
    
    *w=Tree(0, 0, 280, 280)
    For i = 1 To 10
      AddItem(*w, -1, "Text 1");+Chr(10)+"Text 2")
    Next

    SetItemColor(*w, #PB_All, #__Color_Front, $FF0000FF)
    SetItemColor(*w,  3, #__Color_Back,  $FF00FFFF)
    SetItemColor(*w,  9, #__Color_Back,  $FFFFFF00)
    
    SetItemColor(*w,  3, #__Color_Frame,  $FF0000f0)
    
    SetItemColor(*w,  #PB_All, #__Color_Front,  $FF00FFFF, 2)
    SetItemColor(*w,  #PB_All, #__Color_Back,  $FF3F00F0, 2)
    
    SetItemColor(*w,  #PB_All, #__Color_Line,  $FF3F00F0)
    
    redraw(root())
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP