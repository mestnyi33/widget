; Module/File:     Font_MonospaceRequester.pb
; Function:        Add FontButton, calling a font chooser for Monospace fonts - Linux gtk2.4+
; Author:          Omi
; Date:            Mar. 16, 2016
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

EnableExplicit

ImportC ""
	gtk_font_button_new_with_font(fontname.p-utf8)
	gtk_font_chooser_set_filter_func(*fontchooser, *filter, *user_data, destroy)
	pango_font_family_is_monospace(*family)
	g_signal_connect(*instance, detailed_signal.p-utf8, *c_handler, *data, destroy= 0, flags= 0) As "g_signal_connect_data"
EndImport

; Object constants
#MainWin= 0

#Text1  = 0


Global.i gEvent, gQuit
Global gFont

ProcedureC Callback_FontMonospaceFilter(*family, *face, user_data)
	ProcedureReturn pango_font_family_is_monospace(*family)
EndProcedure

ProcedureC Callback_FontSet(*widget.GtkWidget, user_data);                     Get selected font data
	If *widget = gFont
		Debug "Font name: "     + PeekS(gtk_font_button_get_font_name_(*widget), -1, #PB_UTF8)
		Debug "label w. font: " + Str(gtk_font_button_get_use_font_(*widget))
		Debug "style in name: " + Str(gtk_font_button_get_show_style_(*widget))
		Debug "size in name : " + Str(gtk_font_button_get_show_size_(*widget))
	EndIf
EndProcedure

Procedure.i FontButtonGadget(Gadget, x, y, w, h, fontname.s= "")
	Protected.i Container= ContainerGadget(Gadget, x, y, w, h)
	Protected *fButton
	
	If fontname = ""
		*fButton= gtk_font_button_new_()
	Else
		*fButton= gtk_font_button_new_with_font(fontname)
	EndIf

	If Gadget <> #PB_Any : Container= Gadget : EndIf
	gtk_container_add_(GadgetID(Container), *fButton)
; 	gtk_font_button_set_show_size_ (*fButton, #False);      #False: no size is shown in the label
; 	gtk_font_button_set_show_style_(*fButton, #False);      #False: no style is shown in the label
; 	gtk_font_button_set_use_font_  (*fButton, #True);       #True : label is written using the selected font  
	gtk_font_chooser_set_filter_func(*fButton, @Callback_FontMonospaceFilter(), #Null, #Null)
	gtk_widget_show_(*fButton)
	CloseGadgetList()
	ProcedureReturn *fButton
EndProcedure

If OpenWindow(#MainWin, 300, 200, 360, 100, "Call Monospace FontRequester", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#Text1, 5, 10, 100, 22, "change font: ")
	gFont= FontButtonGadget(#PB_Any, 95, 5, 260, 32);, "monospace 10");    uncomment for presetted font e.g. monospace w. height= 10
	
	g_signal_connect(gFont, "font-set", @Callback_FontSet(), 0)
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
				
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.45 LTS (Linux - x86)
; CursorPosition = 3
; Folding = -
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 82
; FirstLine = 29
; Folding = --
; EnableXP