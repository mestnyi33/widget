; Module/File:     System_GetCurrentDpi.pb
; Function:        Get the current dpi setting - Linux
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
#G_TYPE_INT  = 24

Procedure GetCurrentDpi()
	Protected   gVal.GValue
	Protected.i Ret
	
	g_value_init_(@gval, #G_TYPE_INT)
	g_object_get_property(gtk_settings_get_default_(), "gtk-xft-dpi", @gval)
	Ret= g_value_get_int_(@gval)
	g_value_unset_(@gval)
	ProcedureReturn Ret
EndProcedure

If OpenWindow(0, 300, 200, 500, 200, "Get current dpi setting", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(0, 5, 5, 490, 45, "Current dpi value: " + Str(GetCurrentDpi()/1024))
	
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
; CursorPosition = 40
; FirstLine = 8
; Folding = -
; EnableXP