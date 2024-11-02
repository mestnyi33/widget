EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
#btnSetPos = 1
#btnGetPos = 2
Global Container_id
Define i, ww, hw, PnTabHeight
ww = 320
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "Get/Set TabBarGadgetItemPosition", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	For i = 0 To 9
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	Container_id = ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	OpenGadgetList(Container_id)
	ButtonGadget (#btnSetPos, 10, 30, 300, 30, "Изменить позицию вкладки")
	ButtonGadget (#btnGetPos, 10, 70, 300, 30, "Получить позицию выбранной вкладки")
	CloseGadgetList()

	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #btnSetPos
						SetTabBarGadgetItemPosition(#Gadget_TabBar, 5, 1)
					Case #btnGetPos
						MessageRequester("", Str(GetTabBarGadgetItemPosition(#Gadget_TabBar, #TabBarGadgetItem_Selected)))
				EndSelect
			Case #PB_Event_CloseWindow
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf