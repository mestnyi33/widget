; Module/File:     System_GetScreenDpi_Gdk.pb
; Function:        Get the screen dpi setting from Gdk - Linux
; Author:          Omi
; Date:            Sep. 05, 2016
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

EnableExplicit

ImportC ""
	gdk_screen_get_resolution.d(*screen.GdkScreen)
EndImport

Global.i gEvent, gQuit

If OpenWindow(0, 300, 200, 500, 200, "Get sreen resolution", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(0, 5, 5, 490, 45, "Screen resolution (dpi): " + StrD(gdk_screen_get_resolution(gdk_screen_get_default_())))
	
	Repeat
		If WaitWindowEvent() = #PB_Event_CloseWindow
			gQuit= #True
		EndIf
	Until gQuit
EndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x86)
; CursorPosition = 14
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 29
; Folding = -
; EnableXP