; Module/File:     Font_GetFromGadget1.pb
; Function:        Set Gadget font with API, simple - Linux
; Author:          Omi
; Date:            Jul. 27, 2017
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.3/5.4/5.5/5.6
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------
;part from Font_GetMetrics.pb

EnableExplicit

ImportC ""
	pango_context_get_font_description(*context)
	pango_font_description_get_family(*description)
	pango_font_description_to_string(*description)
	pango_font_description_get_style(*description)
	pango_font_description_get_weight(*description)
	pango_font_description_get_stretch(*description)
	pango_font_description_get_size(*description)
	pango_font_description_get_size_is_absolute(*description)
	
;	just to change font for demonstration under gtk3 ...
; 		gtk_widget_override_font(*widget.GtkWidget, *font_desc)
;	just to change font for demonstration under gtk2 ...
; 		gtk_widget_modify_font(*widget.GtkWidget, *font_desc)
;	+ all gtk ...
; 		pango_font_description_from_string(str.p-utf8)
EndImport

#PANGO_SCALE= 1024

; Object constants
#Win_Main  = 0

#Txt1      = 0
#But1      = 1

Global.i gEvent, gQuit

Procedure.s Gadget_GetFontFamily(Gadget)
	Protected.s sFontFamily
	Protected   *context    = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description= pango_context_get_font_description(*context)
	Protected   *family     = pango_font_description_get_family(*description)
	
	If *family
		sFontFamily= PeekS(*family, -1, #PB_UTF8)
	EndIf
	ProcedureReturn sFontFamily
EndProcedure

Procedure.s Gadget_GetFontDescription(Gadget)
	Protected.s sFontDescription
	Protected   *pFontDescription
	Protected   *context    = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description= pango_context_get_font_description(*context)
	
	If *description
		*pFontDescription= pango_font_description_to_string(*description)
		If *pFontDescription
			sFontDescription= PeekS(*pFontDescription, -1, #PB_UTF8)
		EndIf
	EndIf
	ProcedureReturn sFontDescription
EndProcedure

Procedure.i Gadget_GetFontStyle(Gadget)
	Protected.i FontStyle
	Protected   *context    = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description= pango_context_get_font_description(*context)
	
	If *description
		FontStyle= pango_font_description_get_style(*description)
	EndIf
	ProcedureReturn FontStyle
EndProcedure

Procedure.i Gadget_GetFontWeight(Gadget)
	Protected.i FontWeight
	Protected   *context    = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description= pango_context_get_font_description(*context)
	
	If *description
		FontWeight= pango_font_description_get_weight(*description)
	EndIf
	ProcedureReturn FontWeight
EndProcedure

Procedure.i Gadget_GetFontStretch(Gadget)
	Protected.i FontStretch
	Protected   *context    = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description= pango_context_get_font_description(*context)
	
	If *description
		FontStretch= pango_font_description_get_stretch(*description)
	EndIf
	ProcedureReturn FontStretch
EndProcedure

Procedure.i Gadget_GetFontPixelSize(Gadget)
	Protected.i FontSize
	Protected   *context     = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   *description = pango_context_get_font_description(*context)
	
	If *description
		FontSize= pango_font_description_get_size(*description)
		
		If Not pango_font_description_get_size_is_absolute(*description)
			FontSize / #PANGO_SCALE
		EndIf
	EndIf
	
	ProcedureReturn FontSize
EndProcedure


Procedure Create_WinMain()
	If OpenWindow(#Win_Main, 300, 200, 400, 100, "API get Gadget font infos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		
		TextGadget(#Txt1, 5, 5, 390, 24, "This is a Gadget to query current font infos")
		
		;trying a changed font, gtk3 ...
		;gtk_widget_override_font(GadgetID(#Txt1), pango_font_description_from_string("Monospace bold 10"))
		;trying a changed font, gtk2 ...
		;gtk_widget_modify_font(GadgetID(#Txt1), pango_font_description_from_string("Monospace bold 10"))
		
		ButtonGadget(#But1, 5, 40, 390, 30, "Debug font infos")
		
	EndIf
EndProcedure

Create_WinMain()

Repeat
	gEvent= WaitWindowEvent()
	
	Select gEvent
		Case #PB_Event_CloseWindow
			gQuit= #True
			
		Case #PB_Event_Gadget
			If EventGadget() = #But1
				Debug "Font family     : " + Gadget_GetFontFamily(#Txt1)
				Debug "Font description: " + Gadget_GetFontDescription(#Txt1)
				Debug "Font style      : " + Gadget_GetFontStyle(#Txt1) +     "  (0= PANGO_STYLE_NORMAL, 1= PANGO_STYLE_OBLIQUE, 2= PANGO_STYLE_ITALIC)"
				Debug "Font weight     : " + Gadget_GetFontWeight(#Txt1) +    "  (100= PANGO_WEIGHT_THIN, 200= PANGO_WEIGHT_ULTRALIGHT, 300= PANGO_WEIGHT_LIGHT, 380= PANGO_WEIGHT_BOOK, 400= PANGO_WEIGHT_NORMAL, 500= PANGO_WEIGHT_MEDIUM, 600= PANGO_WEIGHT_SEMIBOLD, 700= PANGO_WEIGHT_BOLD, 800= PANGO_WEIGHT_ULTRABOLD, 900= PANGO_WEIGHT_HEAVY, 1000= PANGO_WEIGHT_ULTRAHEAVY)"
				Debug "Font stretch    : " + Gadget_GetFontStretch(#Txt1) +   "  (0= PANGO_STRETCH_ULTRA_CONDENSED, 1= PANGO_STRETCH_EXTRA_CONDENSED, 2= PANGO_STRETCH_CONDENSED, 3= PANGO_STRETCH_SEMI_CONDENSED, 4= PANGO_STRETCH_NORMAL, 5= PANGO_STRETCH_SEMI_EXPANDED, 6= PANGO_STRETCH_EXPANDED, 7= PANGO_STRETCH_EXTRA_EXPANDED, 8= PANGO_STRETCH_ULTRA_EXPANDED)"
				Debug "Font size       : " + Gadget_GetFontPixelSize(#Txt1)
			EndIf
			
	EndSelect
	
Until gQuit
; IDE Options = PureBasic 5.45 LTS (Linux - x86)
; CursorPosition = 9
; Folding = --
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 139
; FirstLine = 111
; Folding = ----
; EnableXP