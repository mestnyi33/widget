EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Font = 0
#Gadget_TabBar = 0
#btn1 = 1
#btn2 = 2
Global Container_id
Define i, ww, hw, PnTabHeight
ww = 320
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	For i = 0 To 9
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	Container_id = ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	OpenGadgetList(Container_id)
	ButtonGadget (#btn1, 10, 30, 300, 30, "Задать шрифт")
	ButtonGadget (#btn2, 10, 70, 300, 30, "Сделать вкладку 3 неактивной")
	CloseGadgetList()

	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #btn1
						LoadFont(#Font, "Consolas", 14, #PB_Font_Italic | #PB_Font_Bold)
						SetTabBarGadgetFont(#Gadget_TabBar, FontID(#Font))
						DisableGadget(#btnSetPos, #True)
					Case #btn2
						SetTabBarGadgetItemState(#Gadget_TabBar, 3, #TabBarGadget_Disabled, #TabBarGadget_Disabled)
				EndSelect
			Case #PB_Event_CloseWindow
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf