; Module/File:     System_GetGtkFont.pb
; Function:        Get gtk standard font - Linux
; Author:          Omi
; Date:            Apr. 04, 2015
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

#WinX=300
#WinY=200
#WinW=350
#WinH=100

Global.i gEvent, gQuit

Procedure.s GtkStandardFontNameGet()
	Protected   gVal.GValue
	Protected.s StdFnt
	g_value_init_(@gval, #G_TYPE_STRING)
	g_object_get_property(gtk_settings_get_default_(), "gtk-font-name", @gval)
	StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
	g_value_unset_(@gval)
	ProcedureReturn StdFnt
EndProcedure


If OpenWindow(#MainWin, #WinX, #WinY, #WinW, #WinH, "gtk system font", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#txt1, 5, 5, 120, 22, "gtk system font: ")
	TextGadget(#txt2, 110, 5, 235, 30, " ")
	
	SetGadgetText(#txt2, GtkStandardFontNameGet())
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
				
			Case #PB_Event_Gadget
				
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.41 LTS (Linux - x64)
; CursorPosition = 12
; Folding = -
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 63
; FirstLine = 31
; Folding = -
; EnableXP