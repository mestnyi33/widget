; Module/File:     Gadget_GetFontMetrics.pb
; Function:        Demo: Get Gadgets- or Gdk- font metrics (only usefull with monospace) - Linux
; Author:          Omi
; Date:            Mar. 08, 2016
; Version:         0.2 (some changes to .i on PB 5.6 17.04)
; Target Compiler: PureBasic 5.22/5.31/5.4/5.5/5.6
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

EnableExplicit

ImportC ""
	pango_context_get_font_description(*context)
	pango_context_get_metrics(*context, desc, *language);          PangoFontMetrics
; 	pango_context_get_font_map(*context);                          PangoFontMap
; 	pango_context_get_language(*context);                          PangoLanguage
; 	pango_context_get_base_dir(*context)
; 	pango_context_load_font(*context, *desc);                      PangoFont
; 	pango_context_load_fontset(*context, *desc, *language);        PangoFontset
	pango_context_list_families(*context, *families, *n_families); PangoFontFamily
	pango_font_description_get_family(*desc)
	pango_font_description_get_gravity(*desc)
	pango_font_description_get_set_fields(*desc)
	pango_font_description_get_size(*desc)
	pango_font_description_get_size_is_absolute(*desc)
	pango_font_description_get_stretch(*desc)
	pango_font_description_get_style(*desc)
	pango_font_description_get_variant(*desc)
	pango_font_description_get_weight(*desc)
	pango_font_description_from_string(str.p-utf8)
	pango_font_description_to_string(*desc)
	pango_font_description_free(*desc)
	pango_font_family_get_name(*family)
	pango_font_family_is_monospace(*family)
	pango_font_family_list_faces(*family, *faces, *n_faces)
	pango_font_face_get_face_name(*face)
	pango_font_face_list_sizes(*face, *sizes, n_sizes)
; 	pango_font_metrics_get_approximate_char_width(*metrics)
	pango_font_metrics_get_approximate_digit_width(*metrics)
	pango_font_metrics_get_ascent(*metrics)
	pango_font_metrics_get_descent(*metrics)
	pango_font_metrics_unref(*metrics)
	pango_language_get_default()
	pango_language_get_sample_string(*language)
	pango_language_to_string(*language)
EndImport

;-Object constants
#Win_Main = 0
#Edt1     = 0
#But1     = 1

;-API constants
#PangoUnit        = 1024
Enumeration PangoStyle
	#PANGO_STYLE_NORMAL
	#PANGO_STYLE_OBLIQUE
	#PANGO_STYLE_ITALIC
EndEnumeration

Enumeration PangoVariant
	#PANGO_VARIANT_NORMAL
	#PANGO_VARIANT_SMALL_CAPS
EndEnumeration

Enumeration PangoWeight
	#PANGO_WEIGHT_THIN      = 100;  Since: 1.24
	#PANGO_WEIGHT_ULTRALIGHT= 200
	#PANGO_WEIGHT_LIGHT     = 300
	#PANGO_WEIGHT_SEMILIGHT = 350;  Since: 1.36.7
	#PANGO_WEIGHT_BOOK      = 380;  Since: 1.24
	#PANGO_WEIGHT_NORMAL    = 400
	#PANGO_WEIGHT_MEDIUM    = 500;  Since: 1.24
	#PANGO_WEIGHT_SEMIBOLD  = 600
	#PANGO_WEIGHT_BOLD      = 700
	#PANGO_WEIGHT_ULTRABOLD = 800
	#PANGO_WEIGHT_HEAVY     = 900
	#PANGO_WEIGHT_ULTRAHEAVY= 1000; Since: 1.24
EndEnumeration

Enumeration PangoStretch
	#PANGO_STRETCH_ULTRA_CONDENSED
	#PANGO_STRETCH_EXTRA_CONDENSED
	#PANGO_STRETCH_CONDENSED
	#PANGO_STRETCH_SEMI_CONDENSED
	#PANGO_STRETCH_NORMAL
	#PANGO_STRETCH_SEMI_EXPANDED
	#PANGO_STRETCH_EXPANDED
	#PANGO_STRETCH_EXTRA_EXPANDED
	#PANGO_STRETCH_ULTRA_EXPANDED
EndEnumeration

Enumeration PangoGravity
	#PANGO_GRAVITY_SOUTH
	#PANGO_GRAVITY_EAST
	#PANGO_GRAVITY_NORTH
	#PANGO_GRAVITY_WEST
	#PANGO_GRAVITY_AUTO
EndEnumeration

EnumerationBinary PangoFontMask; ab 5.40
	#PANGO_FONT_MASK_FAMILY = 1 << 0
	#PANGO_FONT_MASK_STYLE  = 1 << 1
	#PANGO_FONT_MASK_VARIANT= 1 << 2
	#PANGO_FONT_MASK_WEIGHT = 1 << 3
	#PANGO_FONT_MASK_STRETCH= 1 << 4
	#PANGO_FONT_MASK_SIZE   = 1 << 5
	#PANGO_FONT_MASK_GRAVITY= 1 << 6
EndEnumeration


;-Globals
Global.i gEvent, gQuit
Global.i gFontMask
Global.s S1= "A little text to demonstrate and show a collection of functions showing a lot of infos about the font in Gadgets (here the EditorGadget, " + 
             "the font in the ButtonGadget) and the currently used GdkFont." + #LF$ + 
             "Most useful are the functions For monospace fonts and the 'Line height'-value, which e.g. shows the distances of lines in the EditorGadget (if only a single font is used)." + #LF$ + 
             "Additionally a list of all and monospace fonts families and their faces is writen in the debug output." + #LF$

;-Fonts
#FontCode  = 0
LoadFont(#FontCode, "Monospace", 10)

;-Prototypes
Prototype CallbackIntern_Pango(var.i);                     Prototyp with Parameters

;-
;-PangoFont _________________

Procedure PangoFont_FaceSizes(PangoFace);                  only with Bitmap-fonts, rarely needed
	Protected.i PangoFaceSizes, PangoSize
	Protected.i I, nSizes
	Protected.l pPangoSize
	
	pango_font_face_list_sizes(PangoFace, @PangoFaceSizes, @nSizes)
	pPangoSize= PangoFaceSizes

	For I= 1 To nSizes;                                      If nSizes = 0 -> Font is scalable
		PangoSize= PeekL(pPangoSize)
		If PangoSize
			Debug PangoSize
		EndIf
		pPangoSize+ SizeOf(pPangoSize);                        *** COULD BE Int-Type ??? ***
	Next I
	g_free_(PangoFaceSizes)
EndProcedure

Procedure.s PangoFont_FamilyFaces(PangoFamily, ListSizes= #False)
	Protected.i PangoFaces, PangoFace, pFaceName
	Protected.i I, nFaces
	Protected.i pPangoFace;.l
	Protected.s sFaceName
	
	pango_font_family_list_faces(PangoFamily, @PangoFaces, @nFaces)
	pPangoFace= PangoFaces
	For I= 1 To nFaces
		PangoFace= PeekI(pPangoFace);PeekL(pPangoFace)
		If PangoFace
			pFaceName= pango_font_face_get_face_name(PangoFace); occasionally IMA ?
			If pFaceName
				sFaceName+ PeekS(pFaceName, -1, #PB_UTF8) + ";"
			EndIf
			If ListSizes
				PangoFont_FaceSizes(PangoFace)
			EndIf
		EndIf
		pPangoFace+ SizeOf(pPangoFace);                        *** COULD BE Int-Type ??? ***
	Next I
	g_free_(PangoFaces)
	ProcedureReturn RTrim(sFaceName, ";")
EndProcedure


;-
;-PangoCallbacks intern _________________

Procedure CallbackInt_PanFamForEach_All(PangoFamily)
	Protected.s sFamilyData
	
	If PangoFamily
		Protected.i pFamilyName= pango_font_family_get_name(PangoFamily)
		
		If pFamilyName
			sFamilyData= PeekS(pFamilyName, -1, #PB_UTF8) + ", " + #TAB$
		EndIf
		sFamilyData+ "Monospace: " + Str(pango_font_family_is_monospace(PangoFamily)) + #TAB$
		sFamilyData+ "Faces: "     + PangoFont_FamilyFaces(PangoFamily)
		Debug sFamilyData
	EndIf
; 	ProcedureReturn nMonospace
EndProcedure

Procedure CallbackInt_PanFamForEach_Monospace(PangoFamily)
	Protected.i nMonospace= 0
	Protected.s sFamilyData
	
	If PangoFamily
		If pango_font_family_is_monospace(PangoFamily)
			Protected.i pFamilyName= pango_font_family_get_name(PangoFamily)
			
			If pFamilyName
				sFamilyData= PeekS(pFamilyName, -1, #PB_UTF8) + ", " + #TAB$
			EndIf
			sFamilyData+ "Faces: " + PangoFont_FamilyFaces(PangoFamily)
			Debug sFamilyData
			nMonospace= 1
		EndIf
	EndIf
	ProcedureReturn nMonospace
EndProcedure



;-
;- GadgetFonts ______________

Procedure.i GadgetFont_GetWidth(Gadget)
	Protected   PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   PangoFontDescription= pango_context_get_font_description(PangoContext)
	Protected   PangoMetrics        = pango_context_get_metrics(PangoContext, PangoFontDescription, pango_language_get_default())
	Protected.i FontWidth           = pango_font_metrics_get_approximate_digit_width(PangoMetrics) / #PangoUnit
	
	pango_font_metrics_unref(PangoMetrics)
	ProcedureReturn FontWidth
EndProcedure

Procedure.i GadgetFont_GetHeight(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_size(PangoFontDescription) / #PangoUnit
EndProcedure

Procedure.i GadgetFont_GetSizeAbsolut(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_size_is_absolute(PangoFontDescription)
EndProcedure

Procedure.i GadgetFont_GetLineHeight(Gadget)
	Protected   PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected   PangoFontDescription= pango_context_get_font_description(PangoContext)
	Protected   PangoMetrics        = pango_context_get_metrics(PangoContext, PangoFontDescription, pango_language_get_default())
	Protected.i LineHeight          = pango_font_metrics_get_ascent(PangoMetrics) / #PangoUnit + pango_font_metrics_get_descent(PangoMetrics) / #PangoUnit
	
	pango_font_metrics_unref(PangoMetrics)
	ProcedureReturn LineHeight
EndProcedure

Procedure.i GadgetFont_GetGravity(Gadget);                           might be disabled
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_gravity(PangoFontDescription)
EndProcedure

Procedure.s GadgetFont_GetFamily(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn PeekS(pango_font_description_get_family(PangoFontDescription), -1, #PB_UTF8)
EndProcedure

Procedure.i GadgetFont_GetStyle(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_style(PangoFontDescription)
EndProcedure

Procedure.i GadgetFont_GetVariant(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_variant(PangoFontDescription)
EndProcedure

Procedure.i GadgetFont_GetWeight(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_weight(PangoFontDescription)
EndProcedure

Procedure.i GadgetFont_GetStretch(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn pango_font_description_get_stretch(PangoFontDescription)
EndProcedure

Procedure.s GadgetFont_GetDescriptionString(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	
	ProcedureReturn PeekS(pango_font_description_to_string(PangoFontDescription), -1, #PB_UTF8)
EndProcedure

Procedure.i GadgetFont_GetMask(Gadget)
	Protected PangoContext        = gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected PangoFontDescription= pango_context_get_font_description(PangoContext)
	Protected PangoFontMask       = pango_font_description_get_set_fields(pango_context_get_font_description(PangoContext))
	
	ProcedureReturn pango_font_description_get_set_fields(PangoFontDescription)
EndProcedure

Procedure.i GadgetFont_GetFamilies(Gadget, CallbackDynamic.CallbackIntern_Pango, ListFaces= #False, ListSizes= #False)
	Protected   PangoContext= gtk_widget_get_pango_context_(GadgetID(Gadget))
	Protected.i PangoFamilies, PangoFamily, pFamilyName
	Protected.i pPangoFamily
	Protected.i I, nFamilies, n
	
	pango_context_list_families(PangoContext, @PangoFamilies, @nFamilies)
	pPangoFamily= PangoFamilies
	For I= 1 To nFamilies
		PangoFamily= PeekI(pPangoFamily)
		If PangoFamily
			CallbackDynamic(PangoFamily)
			n+ 1
		EndIf
		pPangoFamily+ SizeOf(PangoFamily);                     *** COULD BE Int-Type 'PangoFamily' !!! *** see Font_CheckReqMonospace.pb
	Next I
	g_free_(PangoFamilies)
	; Rest must not be freed
	ProcedureReturn n
EndProcedure


;-
;- GdkFonts _________________

Procedure.i GdkFont_GetWidth()
	Protected   PangoContext        = gdk_pango_context_get_()
	Protected   PangoMetrics        = pango_context_get_metrics(PangoContext, pango_context_get_font_description(PangoContext), pango_language_get_default())
	Protected.i FontWidth           = pango_font_metrics_get_approximate_digit_width(PangoMetrics) / #PangoUnit
	
	pango_font_metrics_unref(PangoMetrics)
	g_object_unref_(PangoContext)
	ProcedureReturn FontWidth
EndProcedure

Procedure.i GdkFont_GetHeight()
	Protected   PangoContext        = gdk_pango_context_get_()
	Protected.i FontHeight          = pango_font_description_get_size(pango_context_get_font_description(PangoContext)) / #PangoUnit
	
	g_object_unref_(PangoContext)
	ProcedureReturn FontHeight
EndProcedure

Procedure.i GdkFont_GetSizeAbsolut()
	Protected   PangoContext        = gdk_pango_context_get_()
	Protected.i PangoSizeAbsolute   = pango_font_description_get_size_is_absolute(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoSizeAbsolute
EndProcedure

Procedure.i GdkFont_GetLineHeight()
	Protected   PangoContext        = gdk_pango_context_get_()
	Protected   PangoMetrics        = pango_context_get_metrics(PangoContext, pango_context_get_font_description(PangoContext), pango_language_get_default())
	Protected.i LineHeight          = pango_font_metrics_get_ascent(PangoMetrics) / #PangoUnit + pango_font_metrics_get_descent(PangoMetrics) / #PangoUnit
	
	pango_font_metrics_unref(PangoMetrics)
	g_object_unref_(PangoContext)
	ProcedureReturn LineHeight
EndProcedure

Procedure.i GdkFont_GetGravity();                                    might be disabled
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoGravity        = pango_font_description_get_gravity(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoGravity
EndProcedure

Procedure.s GdkFont_GetFamily()
	Protected   PangoContext        = gdk_pango_context_get_()
	Protected.s PangoFamily         = PeekS(pango_font_description_get_family(pango_context_get_font_description(PangoContext)), -1, #PB_UTF8)
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoFamily
EndProcedure

Procedure.i GdkFont_GetStyle()
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoFontStyle      = pango_font_description_get_style(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoFontStyle
EndProcedure

Procedure.i GdkFont_GetVariant()
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoVariant        = pango_font_description_get_variant(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoVariant
EndProcedure

Procedure.i GdkFont_GetWeight()
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoWeight         = pango_font_description_get_weight(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoWeight
EndProcedure

Procedure.i GdkFont_GetStretch()
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoStrech         = pango_font_description_get_stretch(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoStrech
EndProcedure

Procedure.s GdkFont_GetDescriptionString()
	Protected   PangoContext         = gdk_pango_context_get_()
	Protected.s sPangoFontDescription= PeekS(pango_font_description_to_string(pango_context_get_font_description(PangoContext)), -1, #PB_UTF8)
	
	g_object_unref_(PangoContext)
	ProcedureReturn sPangoFontDescription
EndProcedure

Procedure.i GdkFont_GetMask()
	Protected PangoContext        = gdk_pango_context_get_()
	Protected PangoFontMask       = pango_font_description_get_set_fields(pango_context_get_font_description(PangoContext))
	
	g_object_unref_(PangoContext)
	ProcedureReturn PangoFontMask
EndProcedure

Procedure.i GdkFont_GetFamilies(CallbackDynamic.CallbackIntern_Pango, ListFaces= #False, ListSizes= #False)
	Protected   PangoContext= gdk_pango_context_get_()
	Protected.i PangoFamilies, PangoFamily, pFamilyName
	Protected.i pPangoFamily; .l
	Protected.i I, nFamilies, nMonospace
	
	pango_context_list_families(PangoContext, @PangoFamilies, @nFamilies)
	pPangoFamily= PangoFamilies
	For I= 1 To nFamilies
		PangoFamily= PeekI(pPangoFamily);PeekL
		If PangoFamily
			nMonospace+ CallbackDynamic(PangoFamily)
		EndIf
		pPangoFamily+ SizeOf(pPangoFamily);                    *** COULD BE Int-Type 'PangoFamily' !!! *** see Font_CheckReqMonospace.pb
	Next I
	g_free_(PangoFamilies)
	g_object_unref_(PangoContext)
	ProcedureReturn nMonospace
EndProcedure

;-
;-Description from String _________
; Procedure PangoDescriptionFromString(sFontDescription.s)
; 	Protected   PangoFontDescription= pango_font_description_from_string(sFontDescription)
; 	
; 	ProcedureReturn PangoFontDescription
; EndProcedure


;-
;-Owns ______________________

Procedure PangoMask_Divide(FontMask)
	If FontMask & #PANGO_FONT_MASK_FAMILY  : Debug #TAB$ + "+ PANGO_FONT_MASK_FAMILY"  : Else : Debug #TAB$ + "- PANGO_FONT_MASK_FAMILY" : EndIf
	If FontMask & #PANGO_FONT_MASK_STYLE   : Debug #TAB$ + "+ PANGO_FONT_MASK_STYLE"   : Else : Debug #TAB$ + "- PANGO_FONT_MASK_STYLE" : EndIf
	If FontMask & #PANGO_FONT_MASK_VARIANT : Debug #TAB$ + "+ PANGO_FONT_MASK_VARIANT" : Else : Debug #TAB$ + "- PANGO_FONT_MASK_VARIANT" : EndIf
	If FontMask & #PANGO_FONT_MASK_WEIGHT  : Debug #TAB$ + "+ PANGO_FONT_MASK_WEIGHT"  : Else : Debug #TAB$ + "- PANGO_FONT_MASK_WEIGHT" : EndIf
	If FontMask & #PANGO_FONT_MASK_STRETCH : Debug #TAB$ + "+ PANGO_FONT_MASK_STRETCH" : Else : Debug #TAB$ + "- PANGO_FONT_MASK_STRETCH" : EndIf
	If FontMask & #PANGO_FONT_MASK_SIZE    : Debug #TAB$ + "+ PANGO_FONT_MASK_SIZE"    : Else : Debug #TAB$ + "- PANGO_FONT_MASK_SIZE" : EndIf
	If FontMask & #PANGO_FONT_MASK_GRAVITY : Debug #TAB$ + "+ PANGO_FONT_MASK_GRAVITY" : Else : Debug #TAB$ + "- PANGO_FONT_MASK_GRAVITY" : EndIf
EndProcedure


If OpenWindow(#Win_Main, 0, 0, 500, 200, "Font - get height, width, line height", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	ButtonGadget(#But1, 5, 168, 350, 26, "Show Editor-, Button- & Gdk-font-metrics")
	EditorGadget(#Edt1, 2,   5, 496, 160, #PB_Editor_WordWrap)
	SetGadgetFont(#Edt1, FontID(#FontCode))
	AddGadgetItem(#Edt1, -1, S1)
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
				
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #But1
						Debug "Font data from EditorGadget ..."
						Debug "--------------------------------------------"
						Debug "Font name      : " + GadgetFont_GetFamily(#Edt1)
						Debug "Font descrip.  : " + GadgetFont_GetDescriptionString(#Edt1)
						Debug "Char height    : " + Str(GadgetFont_GetHeight(#Edt1))
						Debug "Size absolute? : " + Str(GadgetFont_GetSizeAbsolut(#Edt1)); #False = points, #True = Units
						Debug "Char width     : " + Str(GadgetFont_GetWidth(#Edt1))
						Debug "Line height    : " + Str(GadgetFont_GetLineHeight(#Edt1))
						Debug "Gravity        : " + Str(GadgetFont_GetGravity(#Edt1))
						Debug "Font style     : " + Str(GadgetFont_GetStyle(#Edt1));       #PANGO_STYLE_NORMAL, #PANGO_STYLE_OBLIQUE, #PANGO_STYLE_ITALIC
						Debug "Font variant   : " + Str(GadgetFont_GetVariant(#Edt1));     #PANGO_VARIANT_NORMAL, #PANGO_VARIANT_SMALL_CAPS
						Debug "Font weight    : " + Str(GadgetFont_GetWeight(#Edt1))
						Debug "Font stretch   : " + Str(GadgetFont_GetStretch(#Edt1))
						gFontMask= GadgetFont_GetMask(#Edt1)
						Debug "Font mask      : " + Str(gFontMask)
						PangoMask_Divide(gFontMask)
						Debug ""
						
						Debug "Font data from ButtonGadget (Default) ..."
						Debug "--------------------------------------------"
						Debug "Font name      : " + GadgetFont_GetFamily(#But1)
						Debug "Font descrip.  : " + GadgetFont_GetDescriptionString(#But1)
						Debug "Char height    : " + Str(GadgetFont_GetHeight(#But1))
						Debug "Size absolute? : " + Str(GadgetFont_GetSizeAbsolut(#But1)); #False = points, #True = Units
						Debug "Char width     : " + Str(GadgetFont_GetWidth(#But1))
						Debug "Line height    : " + Str(GadgetFont_GetLineHeight(#But1))
						Debug "Gravity        : " + Str(GadgetFont_GetGravity(#But1))
						Debug "Font style     : " + Str(GadgetFont_GetStyle(#But1));       #PANGO_STYLE_NORMAL, #PANGO_STYLE_OBLIQUE, #PANGO_STYLE_ITALIC
						Debug "Font variant   : " + Str(GadgetFont_GetVariant(#But1));     #PANGO_VARIANT_NORMAL, #PANGO_VARIANT_SMALL_CAPS
						Debug "Font weight    : " + Str(GadgetFont_GetWeight(#But1))
						Debug "Font stretch   : " + Str(GadgetFont_GetStretch(#But1))
						gFontMask= GadgetFont_GetMask(#But1)
						Debug "Font mask      : " + Str(gFontMask)
						PangoMask_Divide(gFontMask)
						Debug ""
						
						Debug "Font data from Gdk ..."
						Debug "--------------------------------------------"
						Debug "Font name      : " + GdkFont_GetFamily()
						Debug "Font descrip.  : " + GdkFont_GetDescriptionString()
						Debug "Char height    : " + Str(GdkFont_GetHeight())
						Debug "Size absolute? : " + Str(GdkFont_GetSizeAbsolut()); #False = points, #True = Units
						Debug "Char width     : " + Str(GdkFont_GetWidth())
						Debug "Line height    : " + Str(GdkFont_GetLineHeight())
						Debug "Gravity        : " + Str(GdkFont_GetGravity())
						Debug "Font style     : " + Str(GdkFont_GetStyle());       #PANGO_STYLE_NORMAL, #PANGO_STYLE_OBLIQUE, #PANGO_STYLE_ITALIC
						Debug "Font variant   : " + Str(GdkFont_GetVariant());     #PANGO_VARIANT_NORMAL, #PANGO_VARIANT_SMALL_CAPS
						Debug "Font weight    : " + Str(GdkFont_GetWeight())
						Debug "Font stretch   : " + Str(GdkFont_GetStretch())
						gFontMask= GadgetFont_GetMask(#Edt1)
						Debug "Font mask      : " + Str(GdkFont_GetMask())
						PangoMask_Divide(gFontMask)
						Debug ""
						
						Debug "Language data ..."
						Debug "--------------------------------------------"
						Debug "Language string: " + PeekS(pango_language_to_string(pango_language_get_default()), -1, #PB_UTF8)
						Debug "Language sample: " + PeekS(pango_language_get_sample_string(pango_language_get_default()), -1, #PB_UTF8)
						Debug ""
						
						Debug "List: All families ..."
						Debug "--------------------------------------------"
						Debug #LF$ + "Families total : " + GadgetFont_GetFamilies(#Edt1, @CallbackInt_PanFamForEach_All())
						Debug ""
						Debug "List: Monospace families ..."
						Debug "--------------------------------------------"
						Debug #LF$ + "Families total : " + GdkFont_GetFamilies(@CallbackInt_PanFamForEach_Monospace())
						Debug ""
						;Debug PangoDescriptionFromString("Monaco 10")
				EndSelect
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.45 LTS (Linux - x86)
; CursorPosition = 8
; Folding = ------
; EnableUnicode
; EnableXPÃ¶ï¿Ã¿ï¡Ã¨ï¿Ã¿ï¿Ã¿ï Ã®ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï« Ã¶ï¯Ã·ï¿Ã¿ï¿Ã¿ï¿Ã¿ïÃ¨ï¿Ã¾ï³Ã¼î¿Ã¤ïÃ¯ï»Ã¾ï£Ã²ïÃ®ïÃ¨ï¿Ã¿ï«Ã¶ïÃ«ï£Ã²ï¿Ã¿ï»Ã¾ï§Ã¶ïÃ§ï«Ã¶ï¿Ã¿ïÃ¨ï¿Ã¿ï·Ã¾î¯Ã°î»Ã±îÃ°ï¿Ã¾ï§Ã»ïÃ·ïÃ»ï³Ã¾ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¿Ã¿ï¯Ã¾ï¿Ã¿ï¯Ã·ï¯Ã·ï¿Ã¿ï¿Ã¿ï£ Ã±ï¡Ã©ï¿Ã¾ï¿Ã¿ï¡Ã­ï¡Ã¯ï¡Ãªï£ Ã±ï¡Ã©ï¡Ã¨ï¿Ã¾ï¡Ã¬
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 129
; FirstLine = 327
; Folding = ---------
; EnableXP