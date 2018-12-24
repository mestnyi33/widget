; Module/File:     System_GetCurrentFontHinting.pb
; Function:        Get the current Font hinting - Linux
; Author:          Omi
; Date:            Sep. 25, 2015
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

ImportC ""
	g_object_get_property(*object.GObject, property.p-utf8, *gval)
EndImport

Global.i gEvent, gQuit
#G_TYPE_INT    = 24
#G_TYPE_STRING = 64

Procedure GetCurrentFontHinting()
	Protected   gVal.GValue
	Protected.i Ret
	
	g_value_init_(@gval, #G_TYPE_INT)
	g_object_get_property(gtk_settings_get_default_(), "gtk-xft-hinting", @gval)
	Ret= g_value_get_int_(@gval)
	g_value_unset_(@gval)
	ProcedureReturn Ret
EndProcedure

Procedure.s GetCurrentFontHintStyle()
	Protected   gVal.GValue
	Protected.s Ret
	
	g_value_init_(@gval, #G_TYPE_STRING)
	g_object_get_property(gtk_settings_get_default_(), "gtk-xft-hintstyle", @gval)
	Ret= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
	g_value_unset_(@gval)
	ProcedureReturn Ret
EndProcedure

If OpenWindow(0, 300, 200, 500, 200, "Get current fonthinting setting", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(0, 5,  5, 490, 45, "Current FontHinting setting: " + Str(GetCurrentFontHinting()) + #LF$ + "-1= default, 0 = off, 1 = on")
	TextGadget(1, 5, 55, 490, 45, "Current FontHinting style: " + GetCurrentFontHintStyle())
	
	Repeat
		If WaitWindowEvent() = #PB_Event_CloseWindow
			gQuit= #True
		EndIf
	Until gQuit
EndIf
; IDE Options = PureBasic 5.41 LTS (Linux - x64)
; CursorPosition = 10
; Folding = -
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 53
; FirstLine = 21
; Folding = -
; EnableXP