IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"


CompilerIf #PB_Compiler_IsMainFile
UseLib(widget)
Global *w._S_widget
Define i
Define font1 = LoadFont(#PB_Any, "Helvetica", 25, #PB_Font_Italic)
Define font2 = LoadFont(#PB_Any, "Helvetica", 18, #PB_Font_Bold)

If OpenWindow(0, 0, 0, 390, 250, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TreeGadget(0, 10, 10, 180, 230)
    
    Open(0, 200, 10, 180, 230);, "", #__flag_borderless)
    *w = Tree(0, 0, 180, 230)
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
      AddItem(*w, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
    Next
    
    SetGadgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadgetItemColor(0, 3, #PB_Gadget_BackColor, $00FFFF)
    SetGadgetItemColor(0, 7, #PB_Gadget_BackColor, $FFFF00)
    
    SetItemFont(*w, 3, font1)
    SetItemFont(*w, 7, font2)
    
;     ; index-3 item default text-color 
;     SetItemColor(*w, 3, #__Color_Front, $FF00FF00)
    
    ; index-3 item default frame-color
    SetItemColor(*w, 3, #__Color_Frame,  $FF0000f0)
    
    ; index-3 item default frame-color
    SetItemColor(*w, 3, #__Color_Back,  $FF00FFFF)
    
    ; index-7 item default back-color
    SetItemColor(*w, 7, #__Color_Back,  $FFFFFF00)
    
    ; all default item's text-color 
    SetItemColor(*w, #PB_All, #__Color_Front, $FF0000FF)
    
    ; all selected item's text-color 
    SetItemColor(*w, #PB_All, #__Color_Front,  $FF00FFFF, #__color_state_selected)
    
    ; all selected item's back-color 
    SetItemColor(*w, #PB_All, #__Color_Back,  $FF3F00F0, #__color_state_selected)
    
    ; all entered item's back-color
    SetItemColor(*w, #PB_All, #__Color_Back,  $FF3Ff0F0, #__color_state_entered)
    
    ; vertical and horizontal line back-color
    SetItemColor(*w, #PB_All, #__Color_Line,  $C03AD55A)
    
    WaitClose( )
  EndIf
  CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; Folding = -
; EnableXP