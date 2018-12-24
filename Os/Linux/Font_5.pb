; Module/File:     System_GetGtkFontName.pb
; Function:        Get gtk standard font name - Linux
; Author:          Omi
; Date:            Apr. 18, 2015
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

EnableExplicit

ImportC ""
	g_object_get_property(*widget.GtkWidget, property.p-utf8, *gval)
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

Procedure.s GtkStandardFontNameGet()
	Protected   gVal.GValue
	Protected.i I
	Protected.s StdFnt, FontName
	g_value_init_(@gval, #G_TYPE_STRING)
	g_object_get_property(gtk_settings_get_default_(), "gtk-font-name", @gval)
	StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
	g_value_unset_(@gval)
	If Val(StringField(ReverseString(StdFnt), 1, " "))
		For I= 1 To CountString(StdFnt, " ")
			FontName+ StringField(StdFnt, I, " ")
		Next I
	Else
		FontName= StdFnt
	EndIf
	ProcedureReturn FontName
EndProcedure

If OpenWindow(#MainWin, #WinX, #WinY, #WinW, #WinH, "Get GtkFontName", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#PB_Any, 5, 7, 160, 22, "Gtk-Fontname: ")
	TextGadget(#PB_Any, 105, 5, 190, 22, GtkStandardFontNameGet())
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
				
			Case #PB_Event_Gadget
				
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.40 LTS (Linux - x86)
; CursorPosition = 5
; Folding = -
; EnableUnicode
; EnableXP
; CurrentDirectory = /home/charly-xubuntu/Programming/PureBasic/purebasic/
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 47
; FirstLine = 26
; Folding = -
; EnableXP