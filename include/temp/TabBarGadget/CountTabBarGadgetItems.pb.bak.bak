EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
#btnCount = 1
#btnClear = 2
#btnFree = 3
Global Container_id
Define i, ww, hw, PnTabHeight
ww = 220
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	For i = 0 To 9
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	Container_id = ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	OpenGadgetList(Container_id)
	ButtonGadget (#btnCount, 10, 30, 200, 30, "Количество вкладок")
	ButtonGadget (#btnClear, 10, 70, 200, 30, "Удалить все вкладки")
	ButtonGadget (#btnFree, 10, 110, 200, 30, "Удалить гаджет")
	CloseGadgetList()

	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #btnCount
						If IsGadget(#Gadget_TabBar)
							MessageRequester("", Str(CountTabBarGadgetItems(#Gadget_TabBar)))
						EndIf
					Case #btnClear
						If IsGadget(#Gadget_TabBar)
							ClearTabBarGadgetItems(#Gadget_TabBar)
						EndIf
					Case #btnFree
						; при использовании FreeTabBarGadget() нужно проверять существование гаджета перед тем как его использовать
						If IsGadget(#Gadget_TabBar)
							FreeTabBarGadget(#Gadget_TabBar)
						EndIf
				EndSelect
			Case #PB_Event_CloseWindow
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf