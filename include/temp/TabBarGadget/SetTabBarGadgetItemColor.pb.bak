EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
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
	SetTabBarGadgetItemColor(#Gadget_TabBar, 2, #PB_Gadget_BackColor, $00FFFF)
	SetTabBarGadgetItemColor(#Gadget_TabBar, 3, #PB_Gadget_FrontColor, $0000FF)
	Debug Hex(GetTabBarGadgetItemColor(#Gadget_TabBar, 2, #PB_Gadget_BackColor), #PB_Long)
	Debug Hex(GetTabBarGadgetItemColor(#Gadget_TabBar, 3, #PB_Gadget_FrontColor), #PB_Long)
	Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf