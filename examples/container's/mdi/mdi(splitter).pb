;
; Module name   : elements
; Author        : mestnyi
; Last updated  : mar 12, 2020
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
	Uselib(widget)
	
	Global MDI, MDI_splitter, Splitter
	
	If Open(0, 0, 0, 700, 280, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		
		MDI = MDI(0, 0, 0, 0) ; as they will be sized automatically
		Define *g0 = AddItem(MDI, -1, "form_0")
		Button(10,10,80,80,"button_0")
		
		Define *g1 = AddItem(MDI, -1, "form_1")
		Button(10,10,80,80,"button_1")
		
		Define *g2 = AddItem(MDI, -1, "form_2")
		Button(10,10,80,80,"button_2")
		
		; use root list
		OpenList(Root())
		;;CloseList()
		
		MDI_splitter = Splitter(0, 0, 0, 0, -1, MDI)
		Splitter = Splitter(10, 10, 680, 260, -1, MDI_splitter, #PB_Splitter_Vertical)
		
		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 28
; FirstLine = 1
; Folding = -
; EnableXP