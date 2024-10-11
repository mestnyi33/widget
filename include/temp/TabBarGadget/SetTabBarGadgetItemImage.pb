EnableExplicit
; https://www.purebasic.fr/english/viewtopic.php?t=47588
XIncludeFile "TabBarGadget.pbi"
#Window = 0
#Gadget_TabBar = 0
#btn1 = 1
Global Container_id, hIcon, hIcon1
Define i, ww, hw, PnTabHeight, tmp$
ww = 420
hw = 200
ExtractIconEx_("Shell32.dll", 3, 0, @hIcon, 1)
ExtractIconEx_("Shell32.dll", 131, 0, @hIcon1, 1)

If OpenWindow(#Window, 0, 0, ww, hw, "Get/Set TabBarGadgetItemText", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	
	TabBarGadget(#Gadget_TabBar, 0, 0, ww, 26, #TabBarGadget_None, #Window)
	PnTabHeight = GadgetHeight(#Gadget_TabBar) ; предварительный оценочный размер
	For i = 0 To 9
		AddTabBarGadgetItem(#Gadget_TabBar, i, Str(i), hIcon)
	Next
	Container_id = ContainerGadget(#PB_Any, 0, PnTabHeight, ww, hw - PnTabHeight, #PB_Container_Flat)
	OpenGadgetList(Container_id)
	ButtonGadget (#btn1, 10, 70, 300, 30, "Задать иконку выбранной вкладке (или 6)")
	CloseGadgetList()
	
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #btn1
						If GetTabBarGadgetState(#Gadget_TabBar) = -1
							SetTabBarGadgetState(#Gadget_TabBar, 6)
						EndIf
						SetTabBarGadgetItemImage(#Gadget_TabBar, GetTabBarGadgetState(#Gadget_TabBar), hIcon1)
				EndSelect
			Case #PB_Event_CloseWindow
				DestroyIcon_(hIcon)
				DestroyIcon_(hIcon1)
				CloseWindow(#Window)
				End
		EndSelect
	ForEver
EndIf