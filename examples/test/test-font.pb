
XIncludeFile "../../widgets.pbi" 
UseWidgets( )

Global *b._s_widget

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   LoadFont(4, "Arial", 10)
   LoadFont(5, "Arial", 18)
   LoadFont(6, "Arial", 25)
   
CompilerElse
   LoadFont(4, "Arial", 6)
   LoadFont(5, "Arial", 14)
   LoadFont(6, "Arial", 21)
   
CompilerEndIf

; Shows using of several panels...
OpenWindow(0, 0, 0, 322 + 322 + 100, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
g = PanelGadget(#PB_Any, 10, 10, 334, 130)
AddGadgetItem (g, -1,"Panel 1")
AddGadgetItem (g, -1,"Panel 2")
AddGadgetItem (g, -1,"Panel 3")
butt = ButtonGadget(#PB_Any,10, 15+24+10, 100, 24,"auto resize when changing font");, #PB_Button_MultiLine)
SetGadgetFont(butt, FontID(4))
ResizeGadget(butt, #PB_Ignore, #PB_Ignore, GadgetWidth(butt, #PB_Gadget_RequiredSize), GadgetHeight(butt, #PB_Gadget_RequiredSize))
SetGadgetState(g, 2)

CloseGadgetList()

;SetGadgetItemFont(g, 1, FontID(6))
;SetGadgetItemFont(g, 2, FontID(5))

If Open(0, 322+50, 0, 322+50, 220)
   
   *p = Panel(10, 10, 334, 130)
   AddItem (*p, -1,"Panel 1")
   AddItem (*p, -1,"Panel 2")
   AddItem (*p, -1,"Panel 3")
   *b = Button(10, 15+24+10, 100, 24,"auto resize when changing font");, #PB_Button_MultiLine)
   If SetFont(*b, 4)
     ; Repaint(*b)
   EndIf
   
   ;Debug ""+*b\text\width +" "+ *b\text\height +" "+ *b\Width[#__c_required] +" "+ *b\Height[#__c_required] ; mac = 121 29 ; win 70 16
   Resize(*b, #PB_Ignore, #PB_Ignore, Width(*b, #__c_required), Height(*b, #__c_required))
   SetState(*p, 2)
   
   CloseList()
   
   SetItemFont(*p, 1, 6)
   SetItemFont(*p, 2, 5)
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 26
; Folding = -
; EnableXP
; DPIAware