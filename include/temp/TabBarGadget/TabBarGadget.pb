EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi" 
;XIncludeFile "TabBarGadget_.pbi"
#Window = 0
#Gadget_TabBar = 0
Define i, ww, hw, PnTabHeight
ww = 320
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	For i = 0 To 9
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 3
; Folding = -
; EnableXP