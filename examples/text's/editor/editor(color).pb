IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
UseWidgets( )
Global *w._S_widget
Define i
Define font = LoadFont(#PB_Any, "Helvetica", 15)
Define font1 = LoadFont(#PB_Any, "Helvetica", 25, #PB_Font_Italic)
Define font2 = LoadFont(#PB_Any, "Helvetica", 18, #PB_Font_Bold)

If OpenWindow(0, 0, 0, 390, 250, "SetGadgetItemColor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    EditorGadget(0, 10, 10, 180, 230)
    SetGadgetFont(0, FontID(font))
    
    Open(0, 200, 10, 180, 230);, "", #__flag_borderless)
    *w = EditorWidget(0, 0, 180, 230)
    
    For i = 1 To 10
      AddGadgetItem(0, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
      AddItem(*w, -1, "Text_"+Str(i));+Chr(10)+"Text 2")
    Next
    
    SetGadGetWidgetItemColor(0, #PB_All, #PB_Gadget_FrontColor, $0000FF)
    SetGadGetWidgetItemColor(0, 3, #PB_Gadget_BackColor, $00FFFF)
    SetGadGetWidgetItemColor(0, 7, #PB_Gadget_BackColor, $FFFF00)
    
    SetFont(*w, font)
    SetItemFont(*w, 3, font1)
    SetItemFont(*w, 7, font2)
    
;     ; index-3 item default text-color 
;     SetWidgetItemColor(*w, 3, #__Color_Front, $FF00FF00)
    
    ; index-3 item default frame-color
    SetWidgetItemColor(*w, 3, #__Color_Frame,  $FF0000f0)
    
    ; index-3 item default frame-color
    SetWidgetItemColor(*w, 3, #__Color_Back,  $FF00FFFF)
    
    ; index-7 item default back-color
    SetWidgetItemColor(*w, 7, #__Color_Back,  $FFFFFF00)
    
    ; all default item's text-color 
    SetWidgetItemColor(*w, #PB_All, #__Color_Front, $FF0000FF)
    
    ; all selected item's text-color 
    SetWidgetItemColor(*w, #PB_All, #__Color_Front,  $FF00FFFF, 2);#__color_state_selected)
    
    ; all selected item's back-color 
    SetWidgetItemColor(*w, #PB_All, #__Color_Back,  $FF3F00F0, 2);#__color_state_selected)
    
    ; all entered item's back-color
    SetWidgetItemColor(*w, #PB_All, #__Color_Back,  $FF3Ff0F0, 1);#__color_state_entered)
    
    ; vertical and horizontal line back-color
    SetWidgetItemColor(*w, #PB_All, #__Color_Line,  $C03AD55A)
    
    WaitClose( )
  EndIf
  CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP