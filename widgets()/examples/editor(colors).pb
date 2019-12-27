IncludePath "../"
;XIncludeFile "editor().pb"
XIncludeFile "editor.pb"
;XIncludeFile "widgets().pbi"

UseModule editor
UseModule constants

Global *w._struct_

If OpenWindow(0, 0, 0, 590, 300, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    EditorGadget(0, 10, 10, 280, 280)
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text "+Str(i))
    Next

    SetGadgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadgetItemColor(0,  3, #PB_Gadget_BackColor,  $00FFFF)
    SetGadgetItemColor(0,  9, #PB_Gadget_BackColor,  $FFFF00)
    
    *w=GetGadgetData(Gadget(10, 300, 10, 280, 280))
    
    For i = 1 To 10
      AddItem(*w, -1, "Text "+Str(i)) ; , "Text 1"+Chr(10)+"Text 2")
    Next
    
    redraw(*w)
    
    SetItemColor(*w, #PB_All, #__color_Front, $FF0000FF)
    SetItemColor(*w,  3, #__color_Back,  $FF00FFFF)
    SetItemColor(*w,  9, #__color_Back,  $FFFFFF00)
    
    SetItemColor(*w,  3, #__color_Frame,  $FF0000f0)
    
    SetItemColor(*w,  #PB_All, #__color_Front,  $FF00FFFF, 2)
    SetItemColor(*w,  #PB_All, #__color_Back,  $FF3F00F0, 2)
    
    SetItemColor(*w,  #PB_All, #__color_Line,  $FF3F00F0)
    
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP