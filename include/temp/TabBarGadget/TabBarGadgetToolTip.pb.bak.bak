EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
Define i, ww, hw, PnTabHeight, tmp
ww = 420
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	For i = 0 To 5
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	SetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_CloseButton, #TabBarGadget_CloseButton)
	SetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_NewTab, #TabBarGadget_NewTab)
	TabBarGadgetToolTip(#Gadget_TabBar, "Это вкладка", "Создать новую", "Закрыть вкладку")

	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #Gadget_TabBar
						Select EventType()
							Case #TabBarGadget_EventType_NewItem
								tmp = CountTabBarGadgetItems(#Gadget_TabBar)
								AddTabBarGadgetItem(#Gadget_TabBar, #PB_Default, Str(tmp))
								SetTabBarGadgetState(#Gadget_TabBar, tmp)
						EndSelect
				EndSelect
			Case #PB_Event_CloseWindow
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf