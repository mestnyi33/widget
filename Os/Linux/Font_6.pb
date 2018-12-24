; Module/File:     System_GetGtkFontSize.pb
; Function:        Get gtk standard font size - Linux
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
#MainWin= 0
#Text   = 1

#WinX=300
#WinY=200
#WinW=300
#WinH=200

#G_TYPE_STRING= 64
Global.i gEvent, gQuit

Procedure.i GtkStandardFontSizeGet()
	Protected   gVal.GValue
	Protected.i Size
	Protected.s StdFnt
	g_value_init_(@gval, #G_TYPE_STRING)
	g_object_get_property(gtk_settings_get_default_(), "gtk-font-name", @gval)
	StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
	g_value_unset_(@gval)
	If Val(StringField(ReverseString(StdFnt), 1, " "))
		Size= Val(ReverseString(StringField(ReverseString(StdFnt), 1, " ")))
	Else
		Size= 10
	EndIf
	ProcedureReturn Size
EndProcedure

If OpenWindow(#MainWin, #WinX, #WinY, #WinW, #WinH, "Get GtkFontSize", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#PB_Any, 5, 5, 100, 22, "Gtk-Fontsize: ")
	TextGadget(#PB_Any, 110, 5, 100, 22, Str(GtkStandardFontSizeGet()))
	
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
; CurrentDirectory = /home/charly-xubuntu/Programming/PureBasic/purebasic/
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 41
; FirstLine = 20
; Folding = -
; EnableXP