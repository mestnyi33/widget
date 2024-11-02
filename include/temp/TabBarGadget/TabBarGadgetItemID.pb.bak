EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
Define i, ww, hw, PnTabHeight, *item.TabBarGadgetItem
ww = 320
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	For i = 0 To 5
		AddTabBarGadgetItem(#Gadget_TabBar, i, "tab" + Str(i))
	Next
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	For i = 0 To CountTabBarGadgetItems(#Gadget_TabBar) - 1
		*item = TabBarGadgetItemID(#Gadget_TabBar, i)
		Debug *item\Text
; 		Debug *item\ShortText
; 		Debug *item\DataValue
; 		Debug Hex(*item\Color\Text, #PB_Long)
; 		Debug Hex(*item\Color\Background, #PB_Long)
; 		Debug *item\Attributes
; 		Debug "————————"
	Next
	Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf