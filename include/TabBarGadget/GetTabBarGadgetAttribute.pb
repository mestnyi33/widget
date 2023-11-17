EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
#btn1 = 1
Global Container_id
Define i, ww, hw, PnTabHeight, tmp
ww = 420
hw = 200
If OpenWindow(#Window, 0, 0, ww, hw, "TabBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	For i = 0 To 5
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i))
	Next
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	SetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_CloseButton, #TabBarGadget_CloseButton)
	Container_id = ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	OpenGadgetList(Container_id)
	ButtonGadget (#btn1, 10, 30, 300, 30, " Получить атрибуты")
	CloseGadgetList()
	
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #btn1
						Debug GetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_MultiLine)
						Debug GetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_CloseButton)
						Debug GetTabBarGadgetAttribute(#Gadget_TabBar, #TabBarGadget_MaxTabLength)
				EndSelect
			Case #PB_Event_CloseWindow
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf