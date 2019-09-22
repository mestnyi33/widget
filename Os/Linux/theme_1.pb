; Module/File:     Gtk_GetCurrTheme.pb
; Function:        Get current gtk-theme - Linux
; Author:          Omi
; Date:            Apr. 18, 2015
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

EnableExplicit

ImportC ""
	g_object_get_property(*object.GObject, property.p-utf8, *gval)
EndImport

; Object constants
#MainWin  = 0
#txt1     = 0
#txt2     = 1

#G_TYPE_STRING= 64

Global.i gEvent, gQuit

Procedure.s GtkActiveThemeGet()
	Protected   gVal.GValue
	Protected.s Theme
	g_value_init_(@gval, #G_TYPE_STRING)
	g_object_get_property(gtk_settings_get_default_(), "gtk-theme-name", @gval)
	Theme= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
	g_value_unset_(@gval)
	ProcedureReturn Theme
EndProcedure


If OpenWindow(#MainWin, 300, 200, 400, 100, "gtk theme", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#txt1, 5, 5, 150, 22, "Current gtk theme: ")
	TextGadget(#txt2, 160, 5, 215, 30, " ")
	
	SetGadgetText(#txt2, GtkActiveThemeGet())
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
				
			Case #PB_Event_Gadget
				
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.61 (Linux - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; EnableUnicode
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 58
; FirstLine = 22
; Folding = -
; EnableXP