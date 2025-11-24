IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  #__s_entered = 1
  #__s_selected = 2
  
  UseWidgets( )
  Global *g._S_widget
  Define i
  Define font = LoadFont(#PB_Any, "Helvetica", 15)
  Define font1 = LoadFont(#PB_Any, "Helvetica", 25, #PB_Font_Italic)
  Define font2 = LoadFont(#PB_Any, "Helvetica", 18, #PB_Font_Bold)
  
  If OpenWindow(0, 0, 0, 390, 250, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TreeGadget(0, 10, 10, 180, 230)
    
    Open(0, 200, 10, 180, 230);, "", #__flag_Borderless)
    *g = Tree(0, 0, 180, 230)
    
    ;*g\padding\x = DPIScaled(20)
    *g\fs[1] = DPIScaled(20)
    Resize(*g, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
      AddItem(*g, -1, "Text_"+Str(i))     ;+Chr(10)+"Text 2")
    Next
    
    SetGadgetFont(0, FontID(font))
;     SetGadgetItemFont(0, 3, FontID(font1))
;     SetGadgetItemFont(0, 4, FontID(font1))
;     SetGadgetItemFont(0, 7, FontID(font2))
    
    SetGadgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadgetItemColor(0, 3, #PB_Gadget_BackColor, $00FFFF)
    SetGadgetItemColor(0, 7, #PB_Gadget_BackColor, $FFFF00)
    
    
    ;\\
    SetFont(*g, font)
    SetItemFont(*g, 3, font1)
    SetItemFont(*g, 4, font1)
    SetItemFont(*g, 7, font2)
    
    ;     ; index-3 item default text-color 
    ;     SetItemColor(*g, 3, #PB_Gadget_FrontColor, $FF00FF00)
    
    ; index-3 item default frame-color
    SetItemColor(*g, 3, #__FrameColor,  $FF0000f0)
    
    ; index-3 item default frame-color
    SetItemColor(*g, 3, #PB_Gadget_BackColor,  $FF00FFFF)
    
    ; index-7 item default back-color
    SetItemColor(*g, 7, #PB_Gadget_BackColor,  $FFFFFF00)
    
    ; all default item's text-color 
    SetItemColor(*g, #PB_All, #PB_Gadget_FrontColor, $FF0000FF)
    
    ; all selected item's text-color 
    SetItemColor(*g, #PB_All, #PB_Gadget_FrontColor,  $FF00FFFF, 2);#__s_selected)
    
    ; all selected item's back-color 
    SetItemColor(*g, #PB_All, #PB_Gadget_BackColor,  $FF3F00F0, 2);#__s_selected)
    
    ; all entered item's back-color
    SetItemColor(*g, #PB_All, #PB_Gadget_BackColor,  $FF3Ff0F0, 1);#__s_entered)
    
    ; vertical and horizontal line back-color
    SetItemColor(*g, #PB_All, #PB_Gadget_LineColor,  $C03AD55A)
    
    Debug "---"
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 21
; FirstLine = 3
; Folding = -
; EnableXP