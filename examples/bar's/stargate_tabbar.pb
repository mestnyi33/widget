;|-------------------------------------------------------------------------------------------------
;|
;|  Title            : TabBar
;|  Version          : 1.5 Beta 2a (2019-03-25)
;|  Copyright        : UnionBytes
;|                     (Martin Guttmann alias STARGÅTE)
;|  PureBasic        : 5.20+
;|  String Format    : Ascii, Unicode
;|  Operating System : Windows, Linux, MacOS
;|  Processor        : x86, x64
;|
;|-------------------------------------------------------------------------------------------------
;|
;|  Description      : Gadget for displaying and using tabs like in the browser
;|
;|  Forum Topic      : http://www.purebasic.fr/german/viewtopic.php?f=8&t=24788
;|                     http://www.purebasic.fr/english/viewtopic.php?f=12&t=47588
;|  Website          : http://www.unionbytes.de/includes/TabBar/
;|
;|  Documentation    : http://help.unionbytes.de/tbg/
;|
;|-------------------------------------------------------------------------------------------------





EnableExplicit





;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  1. Constants / Konstanten
;|__________________________________________________________________________________________________



; Attribute für das TabBar
Enumeration
	#__tab_None                 = 0<<0
	#__tab_CloseButton          = 1<<0
	#__tab_NewTab               = 1<<1
	#__tab_TextCutting          = 1<<2
	#__tab_MirroredTabs         = 1<<3
	#__tab_Vertical             = 1<<4
	#__tab_NoTabMoving          = 1<<5
	#__tab_MultiLine            = 1<<6
	#__tab_BottomLine           = 1<<7
	#__tab_PopupButton          = 1<<8
	#__tab_Editable             = 1<<9
	#__tab_MultiSelect          = 1<<10
	#__tab_CheckBox             = 1<<11
	#__tab_SelectedCloseButton  = 1<<12
	#__tab_ReverseOrdering      = 1<<13
	#__tab_ImageSize            = 1<<23
	#__tab_TabTextAlignment     = 1<<24
	#__tab_ScrollPosition       = 1<<25
	#__tab_NormalTabLength      = 1<<26 ; für Später
	#__tab_MaxTabLength         = 1<<27
	#__tab_MinTabLength         = 1<<28
	#__tab_TabRounding          = 1<<29
EndEnumeration

; Ereignisse von TabBarEvent
Enumeration #PB_EventType_FirstCustomValue
	#__event_Pushed 
	#__event_Updated      ; Das Gadget hat sich aktualisiert (intern)
	#__event_Change       ; Der aktive Tab wurde geändert
	#__event_Resize       ; Die größe der Leiste hat sich geändert
	#__event_NewItem      ; ein neuer Tab wird angefordert
	#__event_CloseItem    ; ein Tab soll geschlossen werden
	#__event_SwapItem     ; der aktive Tab wurde verschoben
	#__event_EditItem     ; der Text einer Karte wurde geändert
	#__event_CheckBox     ; der Status der Checkbox hat sich geändert
	#__event_PopupButton  ; der Popup-Button wurde gedrückt
EndEnumeration




; Positionskonstanten für "Item"-Befehle
Enumeration
	#__tab_item_None        = -1
	#__tab_item_NewTab      = -2
	#__tab_item_Selected    = -3
	#__tab_item_Event       = -4
EndEnumeration

; Status-Konstanten
Enumeration
	#__tab_Disabled        = 1<<0
	#__tab_Selected        = 1<<1
	#__tab_Checked         = 1<<2
EndEnumeration

; Status-Konstanten
Enumeration
	#__tab_update_Directly  = 0
	#__tab_update_PostEvent = 1
EndEnumeration

#__tab_DefaultHeight     = 1



; Interne Konstanten
#__tab_PreviousArrow   = 1<<30
#__tab_NextArrow       = 1<<31
#__tab_item_DisableFace = -1
#__tab_item_NormalFace  = 0
#__tab_item_HoverFace   = 1
#__tab_item_ActiveFace  = 2
#__tab_item_MoveFace    = 3




;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  2. Structures / Strukturen
;|__________________________________________________________________________________________________



; Sortierter Eintrag für die Textkürzung
Structure _s_SortedItem
	*Item._s_rows  ; Registerkarte
	Characters.i            ; Anzahl der Buchstaben
EndStructure

; Aktuelle Parameter eine Kartenzeile
Structure _s_row
	Length.i  ; Aktuelle Länge einer Zeile
	Items.i   ; Aktuelle Anzahl der Tabs
EndStructure

; Farben für einen Eintrag
Structure _s_Color
	Text.i        ; Textfarbe
	Background.i  ; Hintergrundfarbe
EndStructure

; Lage und Größe einer Registerkarte 
Structure _s_itemLayout
	X.i         ; X-Position
	Y.i         ; Y-Position
	Width.i     ; (innere) Breite
	Height.i    ; (innere) Höhe
	PaddingX.i  ; Vergrößerung (z.B. bei aktiver Registerkarte)
	PaddingY.i  ; 
	CrossX.i    ; Position des Schließen-X
	CrossY.i    ;
	TextX.i     ; Textposition
	TextY.i     ;
	CheckX.i    ; Checkbox-Position
	CheckY.i    ;
	ImageX.i    ; Icon-Position
	ImageY.i    ;
EndStructure

; Registerkarte
Structure _s_rows
	Text.s                                  ; Text
	ShortText.s                             ; verkürzter Text
	Color._s_Color             ; Farbattribute
	Image.i                                 ; Bild (Kopie vom Original)
	DrawedImage.i                           ; Bild (Kopie ggf. rotiert)
	DataValue.i                             ; Benutzer-Daten-Wert
	Attributes.i                            ; Attribute
	Disabled.i                              ; Deaktiviert
	Selected.i                              ; Aktuell ausgewählt
	Checked.i                               ; Abgehakt
	ToolTip.s                               ; ToolTop
	Length.i                                ; Länge in Pixel (TEMP)
	Row.i                                   ; Zeile (TEMP)
	Position.i                              ; Position (TEMP)
	Visible.i                               ; Sichtbar und wird gezeichnet (TEMP)
	Face.i                                  ; Aussehen (TEMP)
	Layout._s_itemLayout           ; Layout der Karte (TEMP)
	*PreviousSelectedItem._s_rows  ; Zuvor ausgewählter Tab
EndStructure

; Tooltips
Structure Tab_ToolTip
	*Current                         ; Aktuelle ToolTip-Adresse
	*Old                             ; Alte ToolTip-Adresse
	ItemText.s                       ; Text für die Registerkarte
	NewText.s                        ; Text für die "Neu"-Registerkarte
	CloseText.s                      ; Text für den Schließen-Button
EndStructure

; Editierte Karte
Structure _s_Editor
	*Item._s_rows  ; Zu Bearbeitende Karte
	OldText.s               ; Alter Text vor dem Bearbeiten
	Cursor.i                ; Cursor-Position
	Selection.i             ; Textmarkierungslänge
	Selectable.i            ; Ob die Mausbewegung zu einer Textmarkierung führt
EndStructure

; Layout der Leiste
Structure _s_Layout
	PreviousButtonX.i  ; Position des "zurück" Navigationspfeil
	PreviousButtonY.i
	NextButtonX.i  ; Position des "vor" Navigationspfeil
	NextButtonY.i
	PopupButtonX.i ; Position des Popup-Pfeils
	PopupButtonY.i
	ButtonWidth.i  ; Größe der Buttons
	ButtonHeight.i
	ButtonSize.i
EndStructure

; Registerkartenleiste
Structure _s_widget
	Number.i                          ; #Nummer
	Window.i                          ; Fenster-Nummer
	FontID.i                          ; Schrift
	DataValue.i                       ; Benutzer-Daten-Wert
	Attributes.i                      ; Attribute
	List		Item._s_rows()   ; Registerkarten
	NewTabItem._s_rows       ; "Neu"-Registerkarte
	*SelectedItem._s_rows    ; ausgewählte Registerkarte
	*MoveItem._s_rows        ; bewegte Registerkarte
	*HoverItem._s_rows       ; hervorgehobene Registerkarte
	HoverClose.i                      ; Schließenbutton hervorgehoben
	HoverCheck.i                      ; Checkbox hervorgehoben
	HoverArrow.i                      ; Navigationbutton hervorgehoben
	*ReadyToMoveItem._s_rows ; Registerkarte die bereit ist bewegt zu werden
	*LockedItem._s_rows      ; Registerkarte angeschlagen wurde (für Klicks)
	LockedClose.i                     ; Schließenbutton angeschlagen
	LockedCheck.i                     ; Schließenbutton angeschlagen
	LockedArrow.i                     ; Navigationsbutton angeschlagen
	SaveMouseX.i                      ; gespeicherte Mausposition
	SaveMouseY.i                      ; gespeicherte Mausposition
	MouseX.i                          ; X-Mausposition
	MouseY.i                          ; Y-Mausposition
	Event.i                           ; letztes Ereignis
	EventTab.i                        ; Registerkartenposition auf der das letzte Ereignis war
	Shift.i                           ; Verschiebung der Leiste
	LastShift.i                       ; Maximale sinnvolle Verschiebung
	FocusingSelectedTab.i             ; muss die ausgewählte Registerkarte fokussiert werden
	MaxLength.i                       ; maximal nutzbare Länge für Karten
	Length.i                          ; Länge aller sichtbaren Karten
	Radius.i                          ; Radius der Kartenrundung
	MinTabLength.i                    ; minimale Länge einer Karte
	MaxTabLength.i                    ; maximale Länge einer Karte
	NormalTabLength.i                 ; normale Länge einer Karte
	TabTextAlignment.i                ; Textausrichtung
	ToolTip.Tab_ToolTip       ; ToolTip
	TabSize.i                         ; Größer einer Registerkarte
	Rows.i                            ; Anzahl der Zeilen
	Resized.i                         ; Das Gadget muss vergrößert werden
	Editor._s_Editor         ; Editor für eine Karte
	Layout._s_Layout         ; Layout der Leiste
	UpdatePosted.i                    ; Nach einem PostEvent #True
EndStructure

; Timer für das kontinuierliche Scrollen
Structure Timer
	*widget._s_widget  ; TabBar-ID
	Type.i                      ; Modus (Scrollen)
	Mutex.i                     ; Mutex zur Sicherung
EndStructure

; Include für das Registerkartenleisten-Gadget
Structure _s_include
	TabBarColor.i                   ; Hintergrundfarbe des Gadgets
	FaceColor.i                     ; Hintergrundfarbe einer Karte
	HoverColorPlus.i                ; Farbänderung für den Hover-Effekt
	ActivColorPlus.i                ; Farbänderung für aktuell ausgewählte Karten
	BorderColor.i                   ; Rahmenfarbe
	TextColor.i                     ; Textfarbe
	PaddingX.i                      ; Innenabstand (Text zu Rahmen)
	PaddingY.i                      ; Innenabstand (Text zu Rahmen)
	Margin.i                        ; Außenabstand (Rahmen zu Gadget-Rand)
	ImageSpace.i                    ; Freiraum zwischen Bild und Text
	CloseButtonSize.i               ; Größe des Schließenkreuzes
	CheckBoxSize.i
	ImageSize.i
	ArrowSize.i                     ; Größe des Navigationspfeils
	ArrowWidth.i                    ; 
	ArrowHeight.i                   ;
	Radius.i                        ; Radius der Abrundung der Karte
	MinTabLength.i                  ; Mimimale Länge einer Karte
	MaxTabLength.i                  ; Maximale Länge einer Karte
	TabTextAlignment.i
	VerticalTextBugFix.f            
	NormalTabLength.i               ; [für später]
	FadeOut.i                       ; Länge der Farbausblendung bei einer Navigation
	WheelDirection.i                ; Scrollrichtung bei Mausradbewegung
	RowDirection.i                  ; Reihenfolge der Zeilen
	EnableDoubleClickForNewTab.i    ; Doppelklick ins "Leere" erzeigt ein Ereignis 
	EnableMiddleClickForCloseTab.i  ; Mittelklick auf eine Karte erzeigt ein Ereignis
	Timer.Timer        ; Timer für das kontinuierliche Scrollen
EndStructure





;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  3. Initializations / Initialisierungen
;|__________________________________________________________________________________________________



Global includes._s_include
Declare Timer(Null.i)

; Diese Werte können sowohl im Include, als auch im Hauptcode später über includes\Feld geändert werden.
With includes
	CompilerSelect #PB_Compiler_OS
		CompilerCase #PB_OS_Windows
			\TabBarColor   = $FF<<24 | GetSysColor_(#COLOR_BTNFACE)
			\BorderColor   = $FF<<24 | GetSysColor_(#COLOR_3DSHADOW)
			\FaceColor     = $FF<<24 | GetSysColor_(#COLOR_BTNFACE)
			\TextColor     = $FF<<24 | GetSysColor_(#COLOR_BTNTEXT)
		CompilerDefault
			\TabBarColor   = $FFD0D0D0
			\BorderColor   = $FF808080
			\FaceColor     = $FFD0D0D0
			\TextColor     = $FF000000
	CompilerEndSelect
	\HoverColorPlus               = $FF101010
	\ActivColorPlus               = $FF101010
	\PaddingX                     = 6  ; Space from tab border to text
	\PaddingY                     = 5  ; Space from tab border to text
	\Margin                       = 4  ; Space from tab to border
	\ImageSpace                   = 3  ; Space from image zu text
	\ImageSize                    = 16
	\CloseButtonSize              = 13 ; Size of the close cross
	\CheckBoxSize                 = 10
	\ArrowSize                    = 5  ; Size of the Arrow in the button in navigation
	\ArrowWidth                   = 12 ; Width of the Arrow-Button in navigation
	\ArrowHeight                  = 18 ; Height of the Arrow-Button in navigation
	\Radius                       = 3  ; Radius of the edge of the tab
	\TabTextAlignment             = -1
	\VerticalTextBugFix           = 1.05
	\MinTabLength                 = 0
	\MaxTabLength                 = 10000
	\NormalTabLength              = 150
	\FadeOut                      = 32 ; Length of fade out to the navi
	\WheelDirection               = -1
	\RowDirection                 = 1 ; not used
	\EnableDoubleClickForNewTab   = #True
	\EnableMiddleClickForCloseTab = #True
	\Timer\Mutex                  = CreateMutex()
	CompilerIf #PB_Compiler_Thread
		CreateThread(@Timer(), #Null)
	CompilerEndIf
EndWith






;|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-  4. Procedures & Macros / Prozeduren & Makros
;|__________________________________________________________________________________________________



;-  4.1 Private procedures for internal calculations ! Not for use !
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯



; Gitb die Adresse (ID) der Registerkarte zurück.
;   Position kann eine Konstante, Position oder ID sein.
Procedure.i ItemID(*this._s_widget, Position.i) ; Code OK
	
	With *this
		
		Select Position
			Case #__tab_item_Event
				ProcedureReturn ItemID(*this, \EventTab)
			Case #__tab_item_Selected
				If \SelectedItem
					ChangeCurrentElement(\Item(), \SelectedItem)
					ProcedureReturn @\Item()
				Else
					ProcedureReturn #Null
				EndIf
			Case #__tab_item_NewTab
				ProcedureReturn @\NewTabItem
			Case #__tab_item_None
				ProcedureReturn #Null
			Default 
				If Position >= 0 And Position < ListSize(\Item())
					ProcedureReturn SelectElement(\Item(), Position)
				ElseIf Position >= ListSize(\Item())
					ForEach \Item()
						If @\Item() = Position
							ProcedureReturn @\Item()
						EndIf
					Next
				EndIf
		EndSelect
		
	EndWith
	
EndProcedure



; Gibt die Ressourcen einer Registerkarte wieder frei.
Procedure ClearItem(*this._s_widget, *Item._s_rows) ; Code OK
	
	If *Item\Image
		FreeImage(*Item\Image)
	EndIf
	If *Item\DrawedImage
		FreeImage(*Item\DrawedImage)
	EndIf
	
EndProcedure



; Wählt die angegebene Karte aus und aktualisiert die Select-Hierarchie
Procedure SelectItem(*this._s_widget, *Item._s_rows) ; Code OK
	
	If *this\Attributes & #__tab_MultiSelect = #False
		ForEach *this\Item()
			*this\Item()\Selected = #False
		Next 
	EndIf
	If *Item
		*Item\Selected = #True
		If *Item <> *this\SelectedItem
			*Item\PreviousSelectedItem = *this\SelectedItem
		EndIf
		*this\FocusingSelectedTab = #True
	EndIf
	*this\SelectedItem = *Item
	
EndProcedure



; Wählt die angegebene Karte ab und aktualisiert die Select-Hierarchie
Procedure UnselectItem(*this._s_widget, *Item._s_rows) ; Code OK
	
	*Item\Selected = #False
	ForEach *this\Item()
		If *this\Item()\PreviousSelectedItem = *Item
			If *Item\PreviousSelectedItem <> *this\Item()
				*this\Item()\PreviousSelectedItem = *Item\PreviousSelectedItem
			Else
				*this\Item()\PreviousSelectedItem = #Null
			EndIf
		EndIf
	Next
	If *this\SelectedItem = *Item ; Auswahl muss geändert werden
		*this\SelectedItem = *Item\PreviousSelectedItem
		If *this\SelectedItem
			*this\SelectedItem\Selected = #True
		EndIf
	EndIf
	
EndProcedure



; Entfernt die Registerkarte und aktualisiert die Select-Hierarchie
Procedure RemoveItem(*this._s_widget, *Item._s_rows) ; Code OK
	
	ClearItem(*this, *Item)
	If *this\SelectedItem
		UnselectItem(*this, *Item)
		If *this\SelectedItem = #Null
			ChangeCurrentElement(*this\Item(), *Item)
			If NextElement(*this\Item())
				SelectItem(*this._s_widget, *this\Item())
			ElseIf PreviousElement(*this\Item())
				SelectItem(*this._s_widget, *this\Item())
			EndIf
		EndIf
	Else
		UnselectItem(*this, *Item)
	EndIf
	
	ChangeCurrentElement(*this\Item(), *Item)
	DeleteElement(*this\Item())
	
EndProcedure



; Gibt #True zurück, wenn die Maus innerhalb des Rechtecks ist.
;   Width und Height können auch negativ sein.
Procedure.i MouseIn(*this._s_widget, X.i, Y.i, Width.i, Height.i) ; Code OK
	
	With *this
		
		If Width  < 0 : X + Width  : Width  * -1 : EndIf
		If Height < 0 : Y + Height : Height * -1 : EndIf
		If \MouseX >= X And \MouseX < X+Width And \MouseY >= Y And \MouseY < Y+Height
			ProcedureReturn #True
		EndIf
		
	EndWith
	
EndProcedure



; Farbaddition
Procedure.i ColorPlus(Color.i, Plus.i) ; Code OK
	
	If Color&$FF + Plus&$FF < $FF
		Color + Plus&$FF
	Else
		Color | $FF
	EndIf 
	If Color&$FF00 + Plus&$FF00 < $FF00
		Color + Plus&$FF00
	Else
		Color | $FF00
	EndIf 
	If Color&$FF0000 + Plus&$FF0000 < $FF0000
		Color + Plus&$FF0000
	Else
		Color | $FF0000
	EndIf 
	
	ProcedureReturn Color
	
EndProcedure



; Farbsubtraktion
Procedure.i ColorMinus(Color.i, Minus.i) ; Code OK
	
	If Color&$FF - Minus&$FF > 0
		Color - Minus&$FF
	Else
		Color & $FFFFFF00
	EndIf 
	If Color&$FF00 - Minus&$FF00 > 0
		Color - Minus&$FF00
	Else
		Color & $FFFF00FF
	EndIf 
	If Color&$FF0000 - Minus&$FF0000 > 0
		Color - Minus&$FF0000
	Else
		Color & $FF00FFFF
	EndIf 
	
	ProcedureReturn Color
	
EndProcedure



; Zeichnet ein (Schließen-)Kreuz
Procedure DrawCross(X.i, Y.i, Size.i, Color.i) ; Code OK
	
	Protected Alpha.i = Alpha(Color)/4
	
	Line(X  , Y+1     , Size-1,  Size-1, Color&$FFFFFF|Alpha<<24)
	Line(X+1, Y       , Size-1,  Size-1, Color&$FFFFFF|Alpha<<24)
	Line(X  , Y+Size-2, Size-1, -Size+1, Color&$FFFFFF|Alpha<<24)
	Line(X+1, Y+Size-1, Size-1, -Size+1, Color&$FFFFFF|Alpha<<24)
	Line(X  , Y       , Size  ,  Size  , Color)
	Line(X  , Y+Size-1, Size  , -Size  , Color)
	
EndProcedure



; Zeichnet einen Button
Procedure DrawButton(X.i, Y.i, Width.i, Height.i, Type.i, Color, Vertical.i=#False) ; Code OK
	
	If Type
		DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
		ResetGradientColors()
		If Type = 1
			GradientColor(0.0, ColorPlus(Color, $404040))
			GradientColor(0.5, Color)
			GradientColor(1.0, ColorMinus(Color, $404040))
		ElseIf Type = -1
			GradientColor(1.0, ColorPlus(Color, $404040))
			GradientColor(0.5, Color)
			GradientColor(0.0, ColorMinus(Color, $404040))
		EndIf
		If Vertical
			LinearGradient(X, Y, X+Width-1, Y)
			RoundBox(X, Y, Width, Height, 3, 3)
			DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
			RoundBox(X, Y, Width, Height, 3, 3, includes\BorderColor&$FFFFFF|$80<<24)
		Else
			LinearGradient(X, Y, X, Y+Height-1)
			RoundBox(X, Y, Width, Height, 3, 3)
			DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
			RoundBox(X, Y, Width, Height, 3, 3, includes\BorderColor&$FFFFFF|$80<<24)
		EndIf
		DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
	EndIf
	
EndProcedure



; Zeichnet einen Pfeil
Procedure DrawArrow(X.i, Y.i, Type.i, Color.i, Attributes.i=#Null) ; Code OK
	
	Protected Index.i, Alpha.i = Alpha(Color)/4
	
	With includes
		If Attributes & #__tab_Vertical
			If Attributes & #__tab_MirroredTabs
				Select Type
					Case #__tab_PopupButton
						X - \ArrowSize/2-1
						For Index = 1 To \ArrowSize
							Line(X+Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			Else
				Select Type
					Case #__tab_PopupButton
						X + \ArrowSize/2
						For Index = 1 To \ArrowSize
							Line(X-Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			EndIf
			If Attributes & #__tab_MirroredTabs XOr Attributes & #__tab_ReverseOrdering
				Select Type
					Case #__tab_PreviousArrow
						Y - \ArrowSize/2-1
						For Index = 1 To \ArrowSize
							Line(X-Index, Y+Index, Index*2, 1, Color)
						Next
						LineXY(X-1, Y, X-1-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
					Case #__tab_NextArrow
						Y + \ArrowSize/2
						For Index = 1 To \ArrowSize
							Line(X-Index, Y-Index, Index*2, 1, Color)
						Next
						LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			Else
				Select Type
					Case #__tab_PreviousArrow
						Y + \ArrowSize/2
						For Index = 1 To \ArrowSize
							Line(X-Index, Y-Index, Index*2, 1, Color)
						Next
						LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
					Case #__tab_NextArrow
						Y - \ArrowSize/2-1
						For Index = 1 To \ArrowSize
							Line(X-Index, Y+Index, Index*2, 1, Color)
						Next
						LineXY(X-1, Y, X-1-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			EndIf
		Else
			Select Type
				Case #__tab_PopupButton
					Y + \ArrowSize/2
					For Index = 1 To \ArrowSize
						Line(X-Index, Y-Index, Index*2, 1, Color)
					Next
					LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
					LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
			EndSelect
			If Attributes & #__tab_ReverseOrdering
				Select Type
					Case #__tab_PreviousArrow
						X + \ArrowSize/2
						For Index = 1 To \ArrowSize
							Line(X-Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
					Case #__tab_NextArrow
						X - \ArrowSize/2-1
						For Index = 1 To \ArrowSize
							Line(X+Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			Else
				Select Type
					Case #__tab_PreviousArrow
						X - \ArrowSize/2-1
						For Index = 1 To \ArrowSize
							Line(X+Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
					Case #__tab_NextArrow
						X + \ArrowSize/2
						For Index = 1 To \ArrowSize
							Line(X-Index, Y-Index, 1, Index*2, Color)
						Next
						LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
						LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
				EndSelect
			EndIf
		EndIf
	EndWith
	
EndProcedure



; Gibt die Länge der Registerkate zurück.
Procedure.i ItemLength(*this._s_widget, *Item._s_rows) ; Code OK
	
	Protected TextLength.i = TextWidth(*Item\ShortText)
	Protected Length.i = 2 * includes\PaddingX
	Protected Characters.i, VerticalTextBugFix.f = 1.0
	
	If *this\Attributes & #__tab_Vertical
		TextLength * includes\VerticalTextBugFix ; 5% länger, wegen Ungenaugikeit von TextWidth bei Rotation
		VerticalTextBugFix = includes\VerticalTextBugFix
	EndIf
	If *Item\Attributes & #__tab_CloseButton Or (*Item\Attributes & #__tab_SelectedCloseButton And *Item\Selected)
		Length + includes\CloseButtonSize-4 + includes\ImageSpace
	EndIf
	If *Item\Attributes & #__tab_CheckBox
		Length + includes\CheckBoxSize + includes\ImageSpace
	EndIf
	If *Item\Image
		If *this\Attributes & #__tab_Vertical
			Length + ImageHeight(*Item\Image)
		Else
			Length + ImageWidth(*Item\Image)
		EndIf
		If *Item\ShortText
			Length + includes\ImageSpace
		EndIf
	ElseIf *Item = *this\NewTabItem And *Item\Text = ""
		Length + 16
	EndIf
	If *Item <> *this\NewTabItem
		If TextLength+Length < *this\MinTabLength
			Length = *this\MinTabLength-TextLength
		EndIf
		If TextLength+Length > *this\MaxTabLength
			Characters = Len(*Item\Text)
			Repeat
				Characters - 1
				TextLength = TextWidth(Left(*Item\Text, Characters)+"..")*VerticalTextBugFix
			Until Characters = 1 Or TextLength+Length <= *this\MaxTabLength
			*Item\ShortText = Left(*Item\Text, Characters) + ".."
		EndIf
	EndIf
	
	ProcedureReturn TextLength + Length
	
EndProcedure



; Gibt den maximal zur verfügungstehenden Platz für Registerkarten zurück.
Procedure.i MaxLength(*this._s_widget, WithNewTab.i=#True) ; Code OK
	
	Protected Length.i
	
	With *this
		If \Attributes & #__tab_Vertical
			Length = OutputHeight() - includes\Margin*2
		Else
			Length = OutputWidth()  - includes\Margin*2
		EndIf
		If \Attributes & #__tab_NewTab And WithNewTab
			Length - *this\NewTabItem\Length + 1
		EndIf
		If \Attributes & #__tab_PreviousArrow
			Length - includes\ArrowWidth
		EndIf
		If \Attributes & #__tab_NextArrow
			Length - includes\ArrowWidth
			If \Attributes & #__tab_NewTab
				Length - includes\Margin
			EndIf
		EndIf
		If \Attributes & #__tab_PopupButton
			Length - includes\ArrowHeight
		EndIf
	EndWith
	
	ProcedureReturn Length
	
EndProcedure



; Führt eine Textkürzung durch, bis alle Karte in die Leiste passen.
Procedure.i TextCutting(*this._s_widget) ; Code OK
	
	Protected NewList SortedItem._s_SortedItem()
	Protected *SortedItem._s_SortedItem
	Protected MaxLength.i = 1, Length.i
	
	With *this
		
		; Der Textlänge nach (groß -> klein) sortierte Einträge anlegen.
		ForEach \Item()
			\Item()\ShortText      = \Item()\Text
			\Item()\Length         = ItemLength(*this, @\Item())
			If *this\Editor\Item <> \Item()
				LastElement(SortedItem())
				*SortedItem            = AddElement(SortedItem())
				*SortedItem\Item       = @\Item()
				*SortedItem\Characters = Len(\Item()\Text)
				While PreviousElement(SortedItem()) And *SortedItem\Item\Length > SortedItem()\Item\Length
					SwapElements(SortedItem(), @SortedItem(), *SortedItem)
					ChangeCurrentElement(SortedItem(), *SortedItem)
				Wend
			EndIf
			MaxLength + \Item()\Length - 1
		Next
		
		; Textkürzung durchführen, bis alle Karte in die maximale Breite passen.
		While MaxLength > \MaxLength And FirstElement(SortedItem())
			*SortedItem = @SortedItem()
			If *SortedItem\Characters > 3 And *SortedItem\Item\Length > \MinTabLength
				*SortedItem\Characters - 1
				*SortedItem\Item\ShortText = Left(*SortedItem\Item\Text, *SortedItem\Characters)+".."
				Length = ItemLength(*this, *SortedItem\Item)
				MaxLength - (*SortedItem\Item\Length-Length)
				*SortedItem\Item\Length = Length
				While NextElement(SortedItem()) And *SortedItem\Item\Length < SortedItem()\Item\Length
					SwapElements(SortedItem(), @SortedItem(), *SortedItem)
					ChangeCurrentElement(SortedItem(), *SortedItem)
				Wend
			Else
				DeleteElement(SortedItem())
			EndIf
		Wend
		
	EndWith
	
	ProcedureReturn MaxLength
	
EndProcedure



; Rotiert das Image abhängig von der Leistenausrichtung 
Procedure RotateImage(*this._s_widget, *Item._s_rows) ; Code OK
	
	Protected LastX.i = ImageWidth(*Item\Image)-1
	Protected LastY.i = ImageHeight(*Item\Image)-1
	Protected Dim Pixel.l(LastX, LastY)
	Protected Y.i, X.i, RotatedImage.i
	
	If *Item\DrawedImage
		FreeImage(*Item\DrawedImage)
	EndIf
	
	If *this\Attributes & #__tab_Vertical
		If StartDrawing(ImageOutput(*Item\Image))
			DrawingMode(#PB_2DDrawing_AllChannels)
			For Y = 0 To LastY
				For X = 0 To LastX
					Pixel(X, Y) = Point(X, Y)
				Next
			Next
			StopDrawing()
		EndIf
		CompilerIf #PB_Compiler_Version >= 520
			*Item\DrawedImage = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32, #PB_Image_Transparent)
		CompilerElse
			*Item\DrawedImage = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32|#PB_Image_Transparent)
		CompilerEndIf
		If StartDrawing(ImageOutput(*Item\DrawedImage))
			DrawingMode(#PB_2DDrawing_AllChannels)
			If *this\Attributes & #__tab_MirroredTabs
				For Y = 0 To LastY
					For X = 0 To LastX
						Plot(LastY-Y, X, Pixel(X, Y))
					Next
				Next
			Else
				For Y = 0 To LastY
					For X = 0 To LastX
						Plot(Y, LastX-X, Pixel(X, Y))
					Next
				Next
			EndIf
			StopDrawing()
		EndIf
	Else
		*Item\DrawedImage = CopyImage(*Item\Image, #PB_Any)
	EndIf
	
EndProcedure



; (Er-)setz ein neues Icon für die Karte
Procedure ReplaceImage(*this._s_widget, *Item._s_rows, NewImageID.i=#Null) ; Code OK
	
	If *Item\Image
		FreeImage(*Item\Image)
		*Item\Image = #Null
	EndIf
	If *Item\DrawedImage
		FreeImage(*Item\DrawedImage)
		*Item\DrawedImage = #Null
	EndIf
	If NewImageID
		CompilerIf #PB_Compiler_Version >= 520
			*Item\Image = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32, #PB_Image_Transparent)
		CompilerElse
			*Item\Image = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32|#PB_Image_Transparent)
		CompilerEndIf
		StartDrawing(ImageOutput(*Item\Image))
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			DrawImage(NewImageID, 0, 0, includes\ImageSize, includes\ImageSize)
		StopDrawing()
		RotateImage(*this, *Item)
	EndIf
	
EndProcedure



; Berechnet das Layout einer Karte
Procedure ItemLayout(*this._s_widget, *Item._s_rows)
	
	Protected TextAreaLength.i = *Item\Length - 2 * includes\PaddingX
	Protected NextSelected.i, PreviousSelected.i
	
	PushListPosition(*this\Item())
	If *Item\Selected
		ChangeCurrentElement(*this\Item(), *Item)
		If NextElement(*this\Item()) And *this\Item()\Selected
			NextSelected = #True
		EndIf
		ChangeCurrentElement(*this\Item(), *Item)
		If PreviousElement(*this\Item()) And *this\Item()\Selected
			PreviousSelected = #True
		EndIf
	EndIf
	PopListPosition(*this\Item())
	
	With includes
		
		If *Item\Attributes & #__tab_CloseButton Or (*Item\Attributes & #__tab_SelectedCloseButton And *Item\Selected)
			TextAreaLength - (includes\CloseButtonSize-4 + includes\ImageSpace)
		EndIf
		If *Item\Attributes & #__tab_CheckBox
			TextAreaLength - (includes\CheckBoxSize + includes\ImageSpace)
		EndIf
		If *Item\Image
			If *this\Attributes & #__tab_Vertical
				TextAreaLength - (ImageHeight(*Item\Image)+includes\ImageSpace)
			Else
				TextAreaLength - (ImageWidth(*Item\Image)+includes\ImageSpace)
			EndIf
		EndIf
		
		If *this\Attributes & #__tab_Vertical
			*Item\Layout\Height = *Item\Length
			*Item\Layout\Width  = *this\TabSize + 1
			If *this\Attributes & #__tab_MirroredTabs
				*Item\Layout\X      = *this\TabSize * *Item\Row; - 1
			Else
				*Item\Layout\X      = OutputWidth() - *this\TabSize * (*Item\Row+1)
			EndIf
			If *this\Attributes & #__tab_ReverseOrdering XOr *this\Attributes & #__tab_MirroredTabs
				*Item\Layout\Y    = *Item\Position
			Else
				*Item\Layout\Y    = OutputHeight() - *Item\Position - *Item\Length
			EndIf
			If *Item\Selected
				*Item\Layout\Width  + \Margin
				If *this\Attributes & #__tab_MirroredTabs = 0
					*Item\Layout\X    - \Margin
				EndIf
			EndIf
			*Item\Layout\PaddingX = \PaddingY
			*Item\Layout\PaddingY = \PaddingX
			*Item\Layout\CrossX = *Item\Layout\X + (*Item\Layout\Width-\CloseButtonSize)/2
			*Item\Layout\CheckX = *Item\Layout\X + (*Item\Layout\Width-\CheckBoxSize)/2
			If *this\Attributes & #__tab_MirroredTabs
				*Item\Layout\TextX  = *Item\Layout\X + (*Item\Layout\Width+TextHeight("|"))/2
			Else
				*Item\Layout\TextX  = *Item\Layout\X + (*Item\Layout\Width-TextHeight("|"))/2
			EndIf
			If *this\Attributes & #__tab_MirroredTabs XOr *this\Attributes & #__tab_ReverseOrdering
				*Item\Layout\CrossY = *Item\Layout\Y + *Item\Layout\Height - (\CloseButtonSize-3) - *Item\Layout\PaddingY
				*Item\Layout\TextY = *Item\Layout\Y + *Item\Layout\PaddingY + (TextAreaLength-TextWidth(*Item\ShortText)*\VerticalTextBugFix) * (*this\TabTextAlignment+1)/2
				If *Item\Image
					*Item\Layout\ImageX = *Item\Layout\X + (*Item\Layout\Width-ImageWidth(*Item\Image))/2
					*Item\Layout\ImageY = *Item\Layout\Y + *Item\Layout\PaddingY
					*Item\Layout\TextY + ImageHeight(*Item\Image) + \ImageSpace
				EndIf
				If *Item\Attributes & #__tab_CheckBox
					*Item\Layout\TextY + \CheckBoxSize + \ImageSpace
				EndIf
				*Item\Layout\CheckY = *Item\Layout\TextY-\CheckBoxSize-\ImageSpace ;-hier
				If *this\Attributes & #__tab_ReverseOrdering : *Item\Layout\TextY + TextWidth(*Item\ShortText)*\VerticalTextBugFix : EndIf
			Else
				*Item\Layout\CrossY = *Item\Layout\Y + (-3) + *Item\Layout\PaddingY
				*Item\Layout\TextY = *Item\Layout\Y + *Item\Layout\Height - *Item\Layout\PaddingY - (TextAreaLength-TextWidth(*Item\ShortText)*\VerticalTextBugFix) * (*this\TabTextAlignment+1)/2
				If *Item\Image
					*Item\Layout\ImageX = *Item\Layout\X + (*Item\Layout\Width-ImageWidth(*Item\Image))/2
					*Item\Layout\ImageY = *Item\Layout\Y + *Item\Layout\Height-ImageHeight(*Item\Image) - *Item\Layout\PaddingY
					*Item\Layout\TextY - ImageHeight(*Item\Image) - \ImageSpace
				EndIf
				If *Item\Attributes & #__tab_CheckBox
					*Item\Layout\TextY - \CheckBoxSize - \ImageSpace
				EndIf
				*Item\Layout\CheckY = *Item\Layout\TextY+\ImageSpace
				If *this\Attributes & #__tab_ReverseOrdering : *Item\Layout\TextY - TextWidth(*Item\ShortText)*\VerticalTextBugFix : EndIf
			EndIf
			If *Item\Selected
				If *this\Attributes & #__tab_MirroredTabs XOr *this\Attributes & #__tab_ReverseOrdering
					If PreviousSelected = #False 
						*Item\Layout\Y - \Margin/2
						*Item\Layout\Height + \Margin/2
					EndIf
					If NextSelected = #False 
						*Item\Layout\Height + \Margin/2
					EndIf
				Else
					If NextSelected = #False 
						*Item\Layout\Y - \Margin/2
						*Item\Layout\Height + \Margin/2
					EndIf
					If PreviousSelected = #False 
						*Item\Layout\Height + \Margin/2
					EndIf
				EndIf
			EndIf
		Else
			*Item\Layout\Width  = *Item\Length
			*Item\Layout\Height = *this\TabSize + 1
			If *this\Attributes & #__tab_ReverseOrdering
				*Item\Layout\X      = OutputWidth() - *Item\Position - *Item\Length
			Else
				*Item\Layout\X      = *Item\Position
			EndIf
			If *this\Attributes & #__tab_MirroredTabs
				*Item\Layout\Y      = *this\TabSize * *Item\Row; - 1
			Else
				*Item\Layout\Y      = OutputHeight() - *this\TabSize * (*Item\Row+1)
			EndIf
			If *Item\Selected
				*Item\Layout\Height + \Margin
				If *this\Attributes & #__tab_MirroredTabs = 0
					*Item\Layout\Y    - \Margin
				EndIf
			EndIf
			*Item\Layout\PaddingX = \PaddingX
			*Item\Layout\PaddingY = \PaddingY
			*Item\Layout\CrossY = *Item\Layout\Y + (*Item\Layout\Height-\CloseButtonSize)/2
			*Item\Layout\CheckY = *Item\Layout\Y + (*Item\Layout\Height-\CheckBoxSize)/2
			*Item\Layout\TextY  = *Item\Layout\Y + (*Item\Layout\Height-TextHeight("|"))/2
			If *this\Attributes & #__tab_ReverseOrdering
				*Item\Layout\CrossX = *Item\Layout\X + (-3) + *Item\Layout\PaddingX
				*Item\Layout\TextX = *Item\Layout\X + *Item\Layout\Width-TextWidth(*Item\ShortText) - *Item\Layout\PaddingX - (TextAreaLength-TextWidth(*Item\ShortText)) * (*this\TabTextAlignment+1)/2
				If *Item\Image
					*Item\Layout\ImageX = *Item\Layout\X + *Item\Layout\Width-ImageWidth(*Item\Image) - *Item\Layout\PaddingX
					*Item\Layout\ImageY = *Item\Layout\Y + (*Item\Layout\Height-ImageHeight(*Item\Image))/2
					*Item\Layout\TextX - ImageWidth(*Item\Image) - \ImageSpace
				EndIf
				If *Item\Attributes & #__tab_CheckBox
					*Item\Layout\TextX - \CheckBoxSize - \ImageSpace
				EndIf
				*Item\Layout\CheckX = *Item\Layout\TextX + TextWidth(*Item\ShortText) + \ImageSpace
			Else
				*Item\Layout\CrossX = *Item\Layout\X + *Item\Layout\Width - (\CloseButtonSize-3) - *Item\Layout\PaddingX
				*Item\Layout\TextX = *Item\Layout\X + *Item\Layout\PaddingX + (TextAreaLength-TextWidth(*Item\ShortText)) * (*this\TabTextAlignment+1)/2
				If *Item\Image
					*Item\Layout\ImageX = *Item\Layout\X + *Item\Layout\PaddingX
					*Item\Layout\ImageY = *Item\Layout\Y + (*Item\Layout\Height-ImageHeight(*Item\Image))/2
					*Item\Layout\TextX + ImageWidth(*Item\Image) + \ImageSpace
				EndIf
				If *Item\Attributes & #__tab_CheckBox
					*Item\Layout\TextX + \CheckBoxSize + \ImageSpace
				EndIf
				*Item\Layout\CheckX = *Item\Layout\TextX - \CheckBoxSize - \ImageSpace
			EndIf
			If *Item\Selected
				If *this\Attributes & #__tab_ReverseOrdering
					If NextSelected = #False 
						*Item\Layout\X - \Margin/2
						*Item\Layout\Width + \Margin/2
					EndIf
					If PreviousSelected = #False 
						*Item\Layout\Width + \Margin/2
					EndIf
				Else
					If PreviousSelected = #False 
						*Item\Layout\X - \Margin/2
						*Item\Layout\Width + \Margin/2
					EndIf
					If NextSelected = #False 
						*Item\Layout\Width + \Margin/2
					EndIf
				EndIf
			EndIf
		EndIf
		
	EndWith
	
EndProcedure



; Berechnet das Layout
Procedure Layout(*this._s_widget)
	
	Protected Shift.i
	
	With includes
		
		If *this\Attributes & #__tab_MirroredTabs
			Shift = -includes\Margin
		Else
			Shift = includes\Margin
		EndIf
		
		If *this\Attributes & #__tab_Vertical
			*this\Layout\ButtonHeight = \ArrowWidth
			*this\Layout\ButtonWidth  = \ArrowHeight
			*this\Layout\ButtonSize   = \ArrowHeight
			If *this\Attributes & #__tab_MirroredTabs XOr *this\Attributes & #__tab_ReverseOrdering
				If *this\Attributes & #__tab_PopupButton
					*this\Layout\PopupButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\PopupButtonY = OutputHeight() - *this\Layout\ButtonSize / 2
				EndIf
				If *this\Attributes & #__tab_PreviousArrow
					*this\Layout\PreviousButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\PreviousButtonY = *this\Layout\ButtonHeight / 2
				EndIf
				If *this\Attributes & #__tab_NextArrow
					*this\Layout\NextButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\NextButtonY = OutputHeight() - *this\Layout\ButtonHeight / 2
					If *this\Attributes & #__tab_NewTab
						*this\Layout\NextButtonY - *this\NewTabItem\Length-includes\Margin
					EndIf
					If *this\Attributes & #__tab_PopupButton
						*this\Layout\NextButtonY - *this\Layout\ButtonSize
					EndIf
				EndIf
			Else
				If *this\Attributes & #__tab_PopupButton
					*this\Layout\PopupButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\PopupButtonY = *this\Layout\ButtonSize / 2
				EndIf
				If *this\Attributes & #__tab_PreviousArrow
					*this\Layout\PreviousButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\PreviousButtonY = OutputHeight() - *this\Layout\ButtonHeight / 2
				EndIf
				If *this\Attributes & #__tab_NextArrow
					*this\Layout\NextButtonX = (OutputWidth()+Shift) / 2
					*this\Layout\NextButtonY = *this\Layout\ButtonHeight / 2
					If *this\Attributes & #__tab_NewTab
						*this\Layout\NextButtonY + *this\NewTabItem\Length+includes\Margin
					EndIf
					If *this\Attributes & #__tab_PopupButton
						*this\Layout\NextButtonY + *this\Layout\ButtonSize
					EndIf
				EndIf
			EndIf
		Else
			*this\Layout\ButtonHeight = \ArrowHeight
			*this\Layout\ButtonWidth  = \ArrowWidth
			*this\Layout\ButtonSize   = \ArrowHeight
			If *this\Attributes & #__tab_ReverseOrdering
				If *this\Attributes & #__tab_PopupButton
					*this\Layout\PopupButtonX = *this\Layout\ButtonSize / 2
					*this\Layout\PopupButtonY = (OutputHeight()+Shift) / 2
				EndIf
				If *this\Attributes & #__tab_PreviousArrow
					*this\Layout\PreviousButtonX = OutputWidth() - *this\Layout\ButtonWidth / 2
					*this\Layout\PreviousButtonY = (OutputHeight()+Shift) / 2
				EndIf
				If *this\Attributes & #__tab_NextArrow
					*this\Layout\NextButtonX = *this\Layout\ButtonWidth / 2
					*this\Layout\NextButtonY = (OutputHeight()+Shift) / 2
					If *this\Attributes & #__tab_NewTab
						*this\Layout\NextButtonX + *this\NewTabItem\Length+includes\Margin
					EndIf
					If *this\Attributes & #__tab_PopupButton
						*this\Layout\NextButtonX + *this\Layout\ButtonSize
					EndIf
				EndIf
			Else
				If *this\Attributes & #__tab_PopupButton
					*this\Layout\PopupButtonX = OutputWidth() - *this\Layout\ButtonSize / 2
					*this\Layout\PopupButtonY = (OutputHeight()+Shift) / 2
				EndIf
				If *this\Attributes & #__tab_PreviousArrow
					*this\Layout\PreviousButtonX = *this\Layout\ButtonWidth / 2
					*this\Layout\PreviousButtonY = (OutputHeight()+Shift) / 2
				EndIf
				If *this\Attributes & #__tab_NextArrow
					*this\Layout\NextButtonX = OutputWidth() - *this\Layout\ButtonWidth / 2
					*this\Layout\NextButtonY = (OutputHeight()+Shift) / 2
					If *this\Attributes & #__tab_NewTab
						*this\Layout\NextButtonX - *this\NewTabItem\Length-includes\Margin
					EndIf
					If *this\Attributes & #__tab_PopupButton
						*this\Layout\NextButtonX - *this\Layout\ButtonSize
					EndIf
				EndIf
			EndIf
			
		EndIf
		
	EndWith
	
EndProcedure



; Zeichnet eine Karte
Procedure DrawItem(*this._s_widget, *Item._s_rows)
	
	Protected X.i, Y.i, LayoutX.i, LayoutY.i, LayoutWidth.i, LayoutHeight.i, Padding.i
	Protected Color.i, Width.i, Height.i, Text.s, Len.i, Angle.i
	
	With includes
		
		; Orientierung der Registerkarte
		If *this\Attributes & #__tab_Vertical
			If *this\Attributes & #__tab_MirroredTabs
				LayoutX = -*this\Radius-1
			EndIf
			LayoutWidth = *this\Radius
		Else
			If *this\Attributes & #__tab_MirroredTabs
				LayoutY = -*this\Radius-1
			EndIf
			LayoutHeight = *this\Radius
		EndIf
		
		; Aussehen
		ResetGradientColors()
		If *this\Attributes & #__tab_Vertical
			If *this\Attributes & #__tab_MirroredTabs
				LinearGradient(*Item\Layout\X+*Item\Layout\Width-1, 0, *Item\Layout\X, 0)
			Else
				LinearGradient(*Item\Layout\X, 0, *Item\Layout\X+*Item\Layout\Width-1, 0)
			EndIf
		Else
			If #False ;*this\Attributes & #__tab_MirroredTabs
				LinearGradient(0, *Item\Layout\Y+*Item\Layout\Height-1, 0, *Item\Layout\Y)
			Else
				LinearGradient(0, *Item\Layout\Y, 0, *Item\Layout\Y+*Item\Layout\Height-1)
			EndIf
		EndIf
		Select *Item\Face
			Case #__tab_item_MoveFace
				Color = ColorPlus(*Item\Color\Background, \ActivColorPlus)
				GradientColor(0.0, ColorPlus(Color, $FF101010)&$FFFFFF|$C0<<24)
				GradientColor(0.5, Color&$FFFFFF|$C0<<24)
				GradientColor(1.0, ColorMinus(Color, $FF101010)&$FFFFFF|$C0<<24)
			Case #__tab_item_DisableFace
				GradientColor(0.0, ColorPlus(*Item\Color\Background, $FF202020)&$FFFFFF|$80<<24)
				GradientColor(0.5, *Item\Color\Background&$FFFFFF|$80<<24)
				GradientColor(0.6, ColorMinus(*Item\Color\Background, $FF101010)&$FFFFFF|$80<<24)
				GradientColor(1.0, ColorMinus(*Item\Color\Background, $FF303030)&$FFFFFF|$80<<24)
			Case #__tab_item_NormalFace
				GradientColor(0.0, ColorPlus(*Item\Color\Background, $FF202020))
				GradientColor(0.5, *Item\Color\Background)
				GradientColor(0.6, ColorMinus(*Item\Color\Background, $FF101010))
				GradientColor(1.0, ColorMinus(*Item\Color\Background, $FF303030))
			Case #__tab_item_HoverFace
				Color = ColorPlus(*Item\Color\Background, \HoverColorPlus)
				GradientColor(0.0, ColorPlus(Color, $FF202020))
				GradientColor(0.5, Color)
				GradientColor(0.6, ColorMinus(Color, $FF101010))
				GradientColor(1.0, ColorMinus(Color, $FF303030))
			Case #__tab_item_ActiveFace
				Color = ColorPlus(*Item\Color\Background, \ActivColorPlus)
				GradientColor(0.0, ColorPlus(Color, $FF101010))
				GradientColor(0.5, Color)
				GradientColor(1.0, ColorMinus(Color, $FF101010))
		EndSelect
		
; 		; andere ausgewählte Nachbarn
; 		If *Item <> *this\NewTabItem And *Item\Selected
; 			PushListPosition(*this\Item())
; 			ChangeCurrentElement(*this\Item(), *Item)
; 			If NextElement(*this\Item()) And *this\Item()\Selected
; 				LayoutWidth - \Margin/2
; 			EndIf
; 			ChangeCurrentElement(*this\Item(), *Item)
; 			If PreviousElement(*this\Item()) And *this\Item()\Selected
; 				LayoutX     + \Margin/2
; 				LayoutWidth - \Margin/2
; 			EndIf
; 			PopListPosition(*this\Item())
; 		EndIf
		
		; Registerkarte zeichnen
		DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
		RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius)
		DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Outlined)
		If *Item\Disabled
			RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius, \BorderColor&$FFFFFF|$80<<24)
		Else
			RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius, \BorderColor)
		EndIf
		DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
		
		If *this\Attributes & #__tab_Vertical
			Angle = 90 + 180*Bool(*this\Attributes&#__tab_MirroredTabs)
			If *Item\Image
				If *Item\DrawedImage = #Null
					*Item\DrawedImage = RotateImage(*Item\Image, Angle)
				EndIf
				If *Item\Disabled
					DrawAlphaImage(ImageID(*Item\DrawedImage), *Item\Layout\ImageX, *Item\Layout\ImageY, $40)
				Else
					DrawAlphaImage(ImageID(*Item\DrawedImage), *Item\Layout\ImageX, *Item\Layout\ImageY, $FF)
				EndIf
			EndIf
			If *Item\Disabled
				DrawRotatedText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, Angle, *Item\Color\Text&$FFFFFF|$40<<24)
			Else
				DrawRotatedText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, Angle, *Item\Color\Text)
			EndIf
		Else
			If *Item\Image
				If *Item\Disabled
					DrawAlphaImage(ImageID(*Item\Image), *Item\Layout\ImageX, *Item\Layout\ImageY, $40)
				Else
					DrawAlphaImage(ImageID(*Item\Image), *Item\Layout\ImageX, *Item\Layout\ImageY, $FF)
				EndIf
			EndIf
			If *Item\Disabled
				DrawText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, *Item\Color\Text&$FFFFFF|$40<<24)
			Else
				DrawText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, *Item\Color\Text)
				If *this\Editor\Item = *Item
					DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_XOr)
					If *this\Editor\Selection < 0
						LayoutX = TextWidth(Left(*Item\Text, *this\Editor\Cursor+*this\Editor\Selection))-1
						LayoutWidth = TextWidth(Left(*Item\Text, *this\Editor\Cursor)) - LayoutX
						Box(*Item\Layout\TextX+LayoutX, *Item\Layout\TextY, LayoutWidth, TextHeight("|"))
					Else
						LayoutX = TextWidth(Left(*Item\Text, *this\Editor\Cursor))-1
						LayoutWidth = TextWidth(Left(*Item\Text, *this\Editor\Cursor+*this\Editor\Selection)) - LayoutX
						Box(*Item\Layout\TextX+LayoutX, *Item\Layout\TextY, LayoutWidth, TextHeight("|"))
					EndIf
					DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
				EndIf
			EndIf
		EndIf
		
		; CheckBox
		If *Item\Attributes & #__tab_CheckBox
			DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Outlined)
			If *this\HoverItem = *Item And *this\HoverCheck
				RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, *Item\Color\Text)
			ElseIf *Item\Disabled
				RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, \BorderColor&$FFFFFF|$40<<24)
			Else
				RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, \BorderColor)
			EndIf
			If *Item\Checked
				DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
				LinearGradient(*Item\Layout\CheckX+2, *Item\Layout\CheckY+2, *Item\Layout\CheckX+\CheckBoxSize-2, *Item\Layout\CheckY+\CheckBoxSize-2)
				ResetGradientColors()
				If *Item\Disabled
					GradientColor(0, *Item\Color\Text&$FFFFFF|$20000000)
					GradientColor(0.5, *Item\Color\Text&$FFFFFF|$30000000)
					GradientColor(1, *Item\Color\Text&$FFFFFF|$20000000)
				Else
					GradientColor(0, *Item\Color\Text&$FFFFFF|$80000000)
					GradientColor(0.5, *Item\Color\Text&$FFFFFF|$C0000000)
					GradientColor(1, *Item\Color\Text&$FFFFFF|$80000000)
				EndIf
				Box(*Item\Layout\CheckX+2, *Item\Layout\CheckY+2, \CheckBoxSize-4, \CheckBoxSize-4)
			EndIf
			DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
		EndIf
		
		; Schließen-Schaltfläche
		If *Item\Attributes & #__tab_CloseButton Or (*Item\Attributes & #__tab_SelectedCloseButton And *Item\Selected)
			If *this\HoverItem = *Item And *this\HoverClose
				If *this\LockedClose And *this\LockedItem = *Item
					DrawButton(*Item\Layout\CrossX, *Item\Layout\CrossY, \CloseButtonSize, \CloseButtonSize, -1, *Item\Color\Background, *this\Attributes & #__tab_Vertical)
				Else
					DrawButton(*Item\Layout\CrossX, *Item\Layout\CrossY, \CloseButtonSize, \CloseButtonSize, 1, *Item\Color\Background, *this\Attributes & #__tab_Vertical)
				EndIf
			EndIf
			If *Item\Disabled
				DrawCross(*Item\Layout\CrossX+3, *Item\Layout\CrossY+3, \CloseButtonSize-6, *Item\Color\Text&$FFFFFF|$40<<24)
			Else
				DrawCross(*Item\Layout\CrossX+3, *Item\Layout\CrossY+3, \CloseButtonSize-6, *Item\Color\Text)
			EndIf
		EndIf
		
	EndWith
	
EndProcedure



; Verwaltet die Ereignisse beim Editieren einer Karte
Procedure Examine_Editor(*this._s_widget)
	
	Protected MinDistance.i, Distance.i, Index.i
	
	With *this
		
		If \Editor\Item
			
			If MouseIn(*this, \Editor\Item\Layout\X, \Editor\Item\Layout\Y,  \Editor\Item\Layout\Width, \Editor\Item\Layout\Height)
				SetGadgetAttribute(\Number, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
			Else
				SetGadgetAttribute(\Number, #PB_Canvas_Cursor, #PB_Cursor_Default)
			EndIf
			
			Select EventType()
				Case #PB_EventType_LeftDoubleClick
					If \Editor\Item = \HoverItem
						\Editor\Cursor = 0
						\Editor\Selection = Len(\Editor\Item\Text)
						\Editor\Selectable = #False
					EndIf
				Case #PB_EventType_LeftButtonDown
					If \Editor\Item = \HoverItem
						\Editor\Cursor = 0
						\Editor\Selection = 0
						\Editor\Selectable = #True
						MinDistance = $FFFF
						For Index = Len(\Editor\Item\Text) To 0 Step -1
							Distance = Abs(\Editor\Item\Layout\TextX+TextWidth(Left(\Editor\Item\Text, Index))-\MouseX)
							If Distance < MinDistance
								\Editor\Cursor = Index
								MinDistance = Distance
							EndIf
						Next
					Else
						If \Editor\OldText <> \Editor\Item\Text
							ChangeCurrentElement(\Item(), \Editor\Item)
							PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_EditItem, ListIndex(\Item()))
						EndIf
						\Editor\Item = #Null
						ProcedureReturn #Null
					EndIf
				Case #PB_EventType_MouseMove
					If \Editor\Item = \HoverItem And \Editor\Selectable
						\Editor\Selection = 0
						MinDistance = $FFFF
						For Index = Len(\Editor\Item\Text) To 0 Step -1
							Distance = Abs(\Editor\Item\Layout\TextX+TextWidth(Left(\Editor\Item\Text, Index))-\MouseX)
							If Distance < MinDistance
								\Editor\Selection = Index-\Editor\Cursor
								MinDistance = Distance
							EndIf
						Next
					EndIf
				Case #PB_EventType_LeftButtonUp
					\Editor\Selectable = #False
				Case #PB_EventType_Input
					If \Editor\Selection > 0
						\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
						\Editor\Selection = 0
					ElseIf \Editor\Selection < 0
						\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
						\Editor\Cursor + \Editor\Selection
						\Editor\Selection = 0
					EndIf
					\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Chr(GetGadgetAttribute(\Number, #PB_Canvas_Input)) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
					\Editor\Item\ShortText = \Editor\Item\Text
					\Editor\Cursor + 1
				Case #PB_EventType_KeyDown
					Select GetGadgetAttribute(\Number, #PB_Canvas_Key)
						Case #PB_Shortcut_Return
							If \Editor\OldText <> \Editor\Item\Text
								ChangeCurrentElement(\Item(), \Editor\Item)
								PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_EditItem, ListIndex(\Item()))
							EndIf
							\Editor\Item = #Null
							ProcedureReturn #Null
						Case #PB_Shortcut_Escape
							\Editor\Item\Text = \Editor\OldText
							\Editor\Item\ShortText = \Editor\Item\Text
							\Editor\Item = #Null
							ProcedureReturn #Null
						Case #PB_Shortcut_Left
							If GetGadgetAttribute(\Number, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
								If \Editor\Cursor+\Editor\Selection > 0
									\Editor\Selection - 1
								EndIf
							Else
								\Editor\Selection = 0
								If \Editor\Cursor > 0
									\Editor\Cursor - 1
								EndIf
							EndIf
						Case #PB_Shortcut_Right
							If GetGadgetAttribute(\Number, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
								If \Editor\Cursor+\Editor\Selection < Len(\Editor\Item\Text)
									\Editor\Selection + 1
								EndIf
							Else
								\Editor\Selection = 0
								If \Editor\Cursor < Len(\Editor\Item\Text)
									\Editor\Cursor + 1
								EndIf
							EndIf
						Case #PB_Shortcut_Home
							\Editor\Cursor = 0
						Case #PB_Shortcut_End
							\Editor\Cursor = Len(\Editor\Item\Text)
						Case #PB_Shortcut_Back
							If \Editor\Selection > 0
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
								\Editor\Selection = 0
							ElseIf \Editor\Selection < 0
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
								\Editor\Cursor + \Editor\Selection
								\Editor\Selection = 0
							ElseIf \Editor\Cursor > 0
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor-1) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
								\Editor\Cursor - 1
							EndIf
						Case #PB_Shortcut_Delete
							If \Editor\Selection > 0
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
								\Editor\Selection = 0
							ElseIf \Editor\Selection < 0
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
								\Editor\Cursor + \Editor\Selection
								\Editor\Selection = 0
							ElseIf \Editor\Cursor < Len(\Editor\Item\Text)
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+2)
							EndIf
						Case #PB_Shortcut_C
							If GetGadgetAttribute(\Number, #PB_Canvas_Modifiers) & #PB_Canvas_Control
								If \Editor\Selection > 0
									SetClipboardText(Mid(\Editor\Item\Text, \Editor\Cursor+1, \Editor\Selection))
								ElseIf \Editor\Selection < 0
									SetClipboardText(Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1, -\Editor\Selection))
								EndIf
							EndIf
						Case #PB_Shortcut_V
							If GetGadgetAttribute(\Number, #PB_Canvas_Modifiers) & #PB_Canvas_Control
								If \Editor\Selection > 0
									\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
									\Editor\Selection = 0
								ElseIf \Editor\Selection < 0
									\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
									\Editor\Cursor + \Editor\Selection
									\Editor\Selection = 0
								EndIf
								\Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + GetClipboardText() + Mid(\Editor\Item\Text, \Editor\Cursor+1)
								\Editor\Item\ShortText = \Editor\Item\Text
								\Editor\Cursor + Len(GetClipboardText())
							EndIf
					EndSelect
					\Editor\Item\ShortText = \Editor\Item\Text
				Case #PB_EventType_LostFocus
				If \Editor\OldText <> \Editor\Item\Text
					ChangeCurrentElement(\Item(), \Editor\Item)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_EditItem, ListIndex(\Item()))
				EndIf
				\Editor\Item = #Null
			EndSelect
			
		Else
			
			SetGadgetAttribute(\Number, #PB_Canvas_Cursor, #PB_Cursor_Default)
			
		EndIf
		
	EndWith
	
EndProcedure



; Ermittelt das Aussehen und die Lage der Tabs
Procedure Examine(*this._s_widget)
	
	Protected MinLength.i, X.i, Y.i, Shift.i, MousePosition.i, Row.i
	Protected Index.i, Distance.i, MinDistance.i
	
	With *this
		
		; Initialisierung
		\ToolTip\Current = #Null
		\MouseX      = GetGadgetAttribute(\Number, #PB_Canvas_MouseX)
		\MouseY      = GetGadgetAttribute(\Number, #PB_Canvas_MouseY)
		\Event       = #Null
		\EventTab    = #__tab_item_None
		\HoverItem   = #Null
		\HoverClose  = #False
		\HoverCheck  = #False
		\HoverArrow  = #Null
		DrawingFont(\FontID)
		
		; Hover bei Registerkarten
		If \MoveItem = #Null
			
			ForEach \Item()
				If \Item()\Visible And MouseIn(*this, \Item()\Layout\X, \Item()\Layout\Y,  \Item()\Layout\Width-1, \Item()\Layout\Height-1)
					\HoverItem = \Item()
				EndIf
			Next
			If \Attributes & #__tab_NewTab And MouseIn(*this, \NewTabItem\Layout\X, \NewTabItem\Layout\Y, \NewTabItem\Layout\Width-1, \NewTabItem\Layout\Height-1)
				\HoverItem = \NewTabItem
			EndIf
			
		EndIf
		
		; Navigation
		If \Attributes & (#__tab_PreviousArrow|#__tab_NextArrow)
			
			If EventType() = #PB_EventType_MouseWheel
				\Shift + includes\WheelDirection * GetGadgetAttribute(\Number, #PB_Canvas_WheelDelta)
				If \Shift < 0
					\Shift = 0
				ElseIf \Shift > \LastShift
					\Shift = \LastShift
				EndIf
			EndIf
			
			LockMutex(includes\Timer\Mutex)
			includes\Timer\Type = #Null
			If \Attributes & #__tab_PreviousArrow
				If MouseIn(*this, \Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight)
					\HoverArrow = #__tab_PreviousArrow
					\HoverItem = #Null
					includes\Timer\Type = #__tab_PreviousArrow
					Select EventType()
						Case #PB_EventType_LeftButtonDown
							\LockedArrow = #__tab_PreviousArrow
							includes\Timer\widget = *this
						Case #PB_EventType_LeftButtonUp
							If \LockedArrow = \HoverArrow And \Shift > 0
								\Shift - 1
							EndIf
					EndSelect
				EndIf
			EndIf
			If \Attributes & #__tab_NextArrow
				If MouseIn(*this, \Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight)
					\HoverArrow = #__tab_NextArrow
					\HoverItem = #Null
					includes\Timer\Type = #__tab_NextArrow
					Select EventType()
						Case #PB_EventType_LeftButtonDown
							\LockedArrow = #__tab_NextArrow
							includes\Timer\widget = *this
						Case #PB_EventType_LeftButtonUp
							If \LockedArrow = \HoverArrow And \Shift < \LastShift
								\Shift + 1
							EndIf
					EndSelect
				EndIf
			EndIf
			UnlockMutex(includes\Timer\Mutex)
			
		EndIf
		
		; Popup-Button
		If \Attributes & #__tab_PopupButton
			If MouseIn(*this, \Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize)
				\HoverArrow = #__tab_PopupButton
				\HoverItem = #Null
				Select EventType()
					Case #PB_EventType_LeftButtonDown
						\LockedArrow = #__tab_PopupButton
					Case #PB_EventType_LeftButtonUp
						If \LockedArrow = \HoverArrow 
							PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_PopupButton, -1)
						EndIf
				EndSelect
			EndIf
		EndIf
		
		; Registerkarten
		If \HoverItem
			
			; Tooltip aktualisieren & Schließenbutton & Checkbox
			If \HoverItem\ToolTip
				\ToolTip\Current = @\HoverItem\ToolTip
			Else
				\ToolTip\Current = @\HoverItem\Text
			EndIf
			If ( \HoverItem\Attributes & #__tab_CloseButton Or (\HoverItem\Attributes & #__tab_SelectedCloseButton And \HoverItem\Selected) ) And \Editor\Item <> \HoverItem
				If MouseIn(*this, \HoverItem\Layout\CrossX, \HoverItem\Layout\CrossY, includes\CloseButtonSize, includes\CloseButtonSize)
					\HoverClose = \HoverItem
					\ToolTip\Current = @\ToolTip\CloseText
					Select EventType()
						Case #PB_EventType_LeftButtonDown
							\LockedClose = \HoverItem
						Case #PB_EventType_LeftButtonUp
							If \LockedClose = \HoverClose
								ChangeCurrentElement(\Item(), \LockedClose)
								\EventTab = ListIndex(\Item())
								PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_CloseItem, \EventTab)
							EndIf
					EndSelect
				EndIf
			EndIf
			If \HoverItem\Attributes & #__tab_CheckBox And \HoverItem\Disabled = #False And \Editor\Item <> \HoverItem
				If MouseIn(*this, \HoverItem\Layout\CheckX, \HoverItem\Layout\CheckY, includes\CheckBoxSize, includes\CheckBoxSize)
					\HoverCheck = \HoverItem
					Select EventType()
						Case #PB_EventType_LeftButtonDown
							\LockedCheck = \HoverItem
						Case #PB_EventType_LeftButtonUp
							If \LockedCheck = \HoverCheck
								ChangeCurrentElement(\Item(), \LockedCheck)
								\EventTab = ListIndex(\Item())
								PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_CheckBox, \EventTab)
								\HoverItem\Checked = 1 - \HoverItem\Checked
							EndIf
					EndSelect
				EndIf
			EndIf
			
			; Ereignisverwaltung
			If \HoverItem = \NewTabItem
				\EventTab = #__tab_item_NewTab
				\ToolTip\Current = @\ToolTip\NewText
			Else
				ChangeCurrentElement(\Item(), \HoverItem)
				\EventTab = ListIndex(\Item())
			EndIf
			Select EventType()
				Case #PB_EventType_LeftButtonDown
					\LockedItem = \HoverItem
					If \LockedItem = \NewTabItem 
						PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_NewItem, \EventTab)
					ElseIf \LockedClose = #False And \LockedCheck = #False
						If \HoverItem\Disabled = #False
							If \Attributes & #__tab_MultiSelect And GetGadgetAttribute(\Number, #PB_Canvas_Modifiers) & #PB_Canvas_Control
								If \HoverItem\Selected 
									UnselectItem(*this, \HoverItem)
								Else
									SelectItem(*this, \HoverItem)
								EndIf
								PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_Change, \EventTab)
							Else
								ForEach \Item()
									\Item()\Selected = #False
								Next 
								If \SelectedItem <> \HoverItem
									PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_Change, \EventTab)
								EndIf
								SelectItem(*this, \HoverItem)
							EndIf
						EndIf
						If Not \Attributes & #__tab_NoTabMoving And \Editor\Item = #Null
							\ReadyToMoveItem = \HoverItem
							\SaveMouseX = \MouseX
							\SaveMouseY = \MouseY
						EndIf
					EndIf
				Case #PB_EventType_MiddleButtonDown
					\LockedItem = \HoverItem
				Case #PB_EventType_MiddleButtonUp
					If includes\EnableMiddleClickForCloseTab And \LockedItem = \HoverItem And \LockedItem <> \NewTabItem And \LockedItem <> \Editor\Item
						PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_CloseItem, \EventTab)
						\MoveItem        = #Null
						\ReadyToMoveItem = #Null
					EndIf
					\LockedItem = #Null
				Case #PB_EventType_MouseMove
					If \ReadyToMoveItem
						If Abs(\SaveMouseX-\MouseX) > 4 Or Abs(\SaveMouseY-\MouseY) > 4
							\MoveItem = \ReadyToMoveItem
							If \Attributes & (#__tab_NextArrow|#__tab_PreviousArrow)
								LockMutex(includes\Timer\Mutex)
								includes\Timer\widget = *this
								UnlockMutex(includes\Timer\Mutex)
							EndIf
						EndIf
					EndIf
				Case #PB_EventType_LeftDoubleClick
					If \Attributes & #__tab_Editable And \HoverItem\Disabled = #False
						\Editor\Item    = \HoverItem
						\Editor\OldText = \Editor\Item\Text
					EndIf
			EndSelect
			
		EndIf
		
		; Editor
		Examine_Editor(*this)
		
		; Sonstiges
		Select EventType()
			Case #PB_EventType_LeftButtonUp
				\LockedClose     = #False
				\LockedCheck     = #False
				\MoveItem        = #Null
				\ReadyToMoveItem = #Null
				\LockedArrow     = #Null
				LockMutex(includes\Timer\Mutex)
				includes\Timer\widget = #Null
				UnlockMutex(includes\Timer\Mutex)
			Case #PB_EventType_MouseLeave
				\HoverItem       = #Null
			Case #PB_EventType_LeftDoubleClick
				If includes\EnableDoubleClickForNewTab And \HoverArrow = #Null And \HoverItem = #Null
					PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_NewItem, \EventTab)
				EndIf
		EndSelect
		If (\Shift <= 0 And \HoverArrow = #__tab_PreviousArrow) Or (\Shift >= \LastShift And \HoverArrow = #__tab_NextArrow)
			\HoverArrow = #False
		EndIf
		
		; Registerkartenverschiebung: Verschiebungspartner suchen und tauschen
		If \MoveItem
			\EventTab = \MoveItem
			If \Attributes & #__tab_Vertical
				If \Attributes & #__tab_MultiLine
					If \Attributes & #__tab_MirroredTabs
						Row = Int((\MouseX-includes\Margin)/\TabSize)
					Else
						Row = Int(\Rows-(\MouseX-includes\Margin)/\TabSize)
					EndIf
					If Row < 0 : Row = 0 : ElseIf Row >= \Rows : Row = \Rows-1 : EndIf
					MousePosition = Row*\MaxLength + \MouseY
				Else
					MousePosition = \MouseY
				EndIf
				If Not (\Attributes & #__tab_MirroredTabs XOr \Attributes & #__tab_ReverseOrdering)
					MousePosition = OutputHeight() - MousePosition
				EndIf
			Else
				If \Attributes & #__tab_MultiLine
					If \Attributes & #__tab_MirroredTabs
						Row = Int((\MouseY-includes\Margin)/\TabSize)
					Else
						Row = Int(\Rows-(\MouseY-includes\Margin)/\TabSize)
					EndIf
					If Row < 0 : Row = 0 : ElseIf Row >= \Rows : Row = \Rows-1 : EndIf
					MousePosition = Row*\MaxLength + \MouseX
				Else
					MousePosition = \MouseX
				EndIf
				If \Attributes & #__tab_ReverseOrdering
					MousePosition = OutputWidth() - MousePosition
				EndIf
			EndIf
			
			If Not \Event
			  ; swap to right
			  ChangeCurrentElement(\Item(), \MoveItem)
				While NextElement(\Item())
					If MousePosition > \Item()\Position + \MaxLength*\Item()\Row
						SwapElements(\Item(), @\Item(), \MoveItem)
						\Item()\Position = \MoveItem\Position
						\MoveItem\Position = \Item()\Position + \Item()\Length
						\Event = #__event_SwapItem
						PushListPosition(\Item())
						ChangeCurrentElement(\Item(), \MoveItem)
						\EventTab = ListIndex(\Item())
						PopListPosition(\Item())
					EndIf
				Wend
			EndIf
			If Not \Event
			  ; swap to left
			  ChangeCurrentElement(\Item(), \MoveItem)
				While PreviousElement(\Item()) And ListIndex(\Item()) >= \Shift-1
					If \MoveItem\Length < \Item()\Length
						MinLength = \MoveItem\Length
					Else
						MinLength = \Item()\Length 
					EndIf
					If MousePosition < \Item()\Position + \MaxLength*\Item()\Row + MinLength
						SwapElements(\Item(), @\Item(), \MoveItem)
						\MoveItem\Position = \Item()\Position
						\Item()\Position = \MoveItem\Position + \MoveItem\Length
						\Event = #__event_SwapItem
						PushListPosition(\Item())
						ChangeCurrentElement(\Item(), \MoveItem)
						\EventTab = ListIndex(\Item())
						PopListPosition(\Item())
					EndIf
				Wend
			EndIf
			If \Event = #__event_SwapItem
				PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_SwapItem, \EventTab)
			EndIf
		EndIf
		
		; ToolTip aktualisieren
		If \ToolTip\Current <> \ToolTip\Old
			If \ToolTip\Current = #Null
				GadgetToolTip(\Number, "")
			ElseIf \ToolTip\Current = @\ToolTip\NewText Or \ToolTip\Current =  @\ToolTip\CloseText
				GadgetToolTip(\Number, PeekS(\ToolTip\Current))
			ElseIf \HoverItem And \ToolTip\Current = @\HoverItem\ToolTip
				GadgetToolTip(\Number, PeekS(\ToolTip\Current))
			Else
				GadgetToolTip(\Number, ReplaceString(\ToolTip\ItemText, "%ITEM", PeekS(\ToolTip\Current)))
			EndIf
			\ToolTip\Old = \ToolTip\Current
		EndIf
		
	EndWith
	
EndProcedure



; Ermittelt das Aussehen und die Lage der Tabs
Procedure Update(*this._s_widget)
	
	Protected FocusingSelectedTab.i
	Protected ShowLength.i, X.i
	Protected OldAttributes.i
	Protected Difference.f, Factor.f, Position.i, Length.i, MaxWidth.i, MousePosition.i
	Protected *Item._s_rows, Row.i, Rows.i=1
	Protected *Current, *Last, AddLength.i, RowCount.i
	Protected Dim Row._s_row(0)
	
	With *this
		
		; Vorbereitung
		DrawingFont(\FontID)
		\Attributes & ~(#__tab_PreviousArrow|#__tab_NextArrow) ; erstmal keine Navigation
		If \TabSize = 0
			If \Attributes & #__tab_Vertical
				If GadgetWidth(\Number) > 1
					\TabSize = OutputWidth() - includes\Margin
				Else
					\TabSize = TextHeight("|") + includes\PaddingY*2
				EndIf
			Else
				If GadgetHeight(\Number) > 1
					\TabSize = OutputHeight() - includes\Margin
				Else
					\TabSize = TextHeight("|") + includes\PaddingY*2
				EndIf
			EndIf
		EndIf
		If \Attributes & #__tab_NewTab
			\NewTabItem\Length = ItemLength(*this, \NewTabItem)
			\NewTabItem\Row = 0
		EndIf
		
		; Mehrzeilige Registerkartenleiste
		If \Attributes & #__tab_MultiLine
			
			\MaxLength = MaxLength(*this)
			\Length    = \MaxLength
			\Shift     = 0
			
			; Breiten ermitteln
			Length = 1
			ForEach \Item()
				\Item()\Row = 0
				\Item()\Length  = ItemLength(*this, \Item())
				\Item()\Visible = #True
				Length - 1 + \Item()\Length
			Next
			
			; Mehrere Zeilen einrichten
			If Length > \MaxLength
				Row = 0
				Row(Row)\Length = 1
				ForEach \Item()
					If NextElement(\Item())
						PreviousElement(\Item())
						MaxWidth = MaxLength(*this, #False)
					Else
						LastElement(\Item())
						MaxWidth = MaxLength(*this)
					EndIf
					If Row(Row)\Length-1+\Item()\Length > MaxWidth And Row(Row)\Items > 0
						Row + 1
						ReDim Row(Row)
						Row(Row)\Length = 1
					EndIf
					Row(Row)\Length - 1 + \Item()\Length
					Row(Row)\Items + 1
					\Item()\Row = Row
				Next
			Else
				Row(Row)\Length = Length
			EndIf
			Rows = Row+1
			
			; Verbreitern
			If Rows > 1
				MaxWidth = MaxLength(*this, #False)
				ForEach \Item()
					AddLength = (MaxWidth-Row(\Item()\Row)\Length)/Row(\Item()\Row)\Items
					If \Item()\Row <> Rows-1 Or AddLength < 0
						\Item()\Length + AddLength
						Row(\Item()\Row)\Length + AddLength
						Row(\Item()\Row)\Items - 1
					EndIf
				Next
			EndIf
			
			; Positionen errechnen
			Length = includes\Margin
			Row = 0
			ForEach \Item()
				If Row <> \Item()\Row
					Row + 1
					Length = includes\Margin
				EndIf
				\Item()\Position = Length
				Length + \Item()\Length - 1
			Next
			If Row(Rows-1)\Length > MaxLength(*this) And LastElement(\Item())
				\Item()\Length = MaxLength(*this, #False)
				Rows + 1
				\NewTabItem\Row = Rows-1
				\NewTabItem\Position = includes\Margin
			Else
				\NewTabItem\Row = Rows-1
				\NewTabItem\Position = includes\Margin+Row(\NewTabItem\Row)\Length - 1
			EndIf
			
		; Einzeilige Registerkartenleiste
		Else
			
			\MaxLength = MaxLength(*this)
			
			; ggf. Textkürzung
			If \Attributes & #__tab_TextCutting
				\Length = TextCutting(*this)
				If \Length <= \MaxLength
					\Shift = 0
				EndIf
			EndIf
			
			; Breiten ermitteln
			\Length = 1
			ForEach \Item()
				\Item()\Length = ItemLength(*this, \Item())
				\Item()\Row    = 0
				\Length + \Item()\Length-1
			Next
			
			; Navigation nötig ?
			If \Length > \MaxLength
				\Attributes | (#__tab_PreviousArrow | #__tab_NextArrow)
				\MaxLength = MaxLength(*this)
			Else
				;\Shift = 0
			EndIf
			
			; LastShift ermitteln
			If LastElement(\Item())
				\LastShift = ListIndex(\Item())
				ShowLength = \Item()\Length
				While PreviousElement(\Item())
					If ShowLength + \Item()\Length - 1 > \MaxLength - Bool(ListIndex(\Item())>0)*includes\FadeOut
						Break
					Else
						ShowLength + \Item()\Length - 1
						\LastShift - 1
					EndIf
				Wend
			Else
				\LastShift = 0
			EndIf
			
			; ggf. aktuell ausgewählte Registerkarte in den sichtbaren Bereich bringen
			If \FocusingSelectedTab And \SelectedItem
				ChangeCurrentElement(\Item(), \SelectedItem)
				If ListIndex(\Item()) <= \Shift
					\Shift = ListIndex(\Item())
				Else
					While \Shift < \LastShift And SelectElement(\Item(), \Shift)
						ShowLength = \Item()\Length
						If \Item() = \SelectedItem
							Break
						EndIf
						While NextElement(\Item())
							If ShowLength + \Item()\Length - 1 > \MaxLength - (Bool(\Shift>0)+Bool(\Shift<\LastShift))*includes\FadeOut
								\Shift + 1
								Break
							ElseIf \Item() = \SelectedItem
								Break 2
							EndIf
							ShowLength + \Item()\Length - 1
						Wend
					Wend
				EndIf
				\FocusingSelectedTab = #False
			EndIf
			
			If \Shift > \LastShift
				\Shift = \LastShift
			EndIf
			\MaxLength - (Bool(\Shift>0)+Bool(\Shift<\LastShift))*includes\FadeOut
			
			; Position der Tabs
			
			; vorherige Registerkarte
			If \Attributes & #__tab_PreviousArrow
				If \Shift > 0
					ForEach \Item()
						\Item()\Position = -$FFFF
						\Item()\Visible  = #False
						If ListIndex(\Item()) >= \Shift-1 : Break : EndIf
					Next
					Position = includes\ArrowWidth + includes\Margin + includes\FadeOut
					SelectElement(\Item(), \Shift-1)
					\Item()\Position = Position - \Item()\Length + 1
					\Item()\Visible  = #True
				Else
					Position = includes\ArrowWidth + includes\Margin
				EndIf
			Else
				Position = includes\Margin
			EndIf
			
			; sichtbare Registerkarten
			\Length = 0
			If SelectElement(\Item(), \Shift)
				Repeat
					\Item()\Position = Position + \Length
					\Item()\Visible  = #True
					If \Length + \Item()\Length - 1 > \MaxLength
						Break
					EndIf
					\Length + \Item()\Length - 1
				Until Not NextElement(\Item())
			EndIf
			
			; nächste Registerkarte
			If \Attributes & #__tab_NextArrow And ListIndex(\Item()) <> -1
				If ListIndex(\Item()) <> ListSize(\Item())-1
					\Item()\Position = Position + \Length
					\Length + \Item()\Length - 1
					\Item()\Visible  = #True
					If NextElement(\Item())
						\Item()\Position = Position + \Length
						\Item()\Visible  = #True
					EndIf
				EndIf
				If \Attributes & #__tab_NewTab
					If \Attributes & #__tab_Vertical
						\NewTabItem\Position = OutputHeight()-\NewTabItem\Length-includes\Margin/2
					Else
						\NewTabItem\Position = OutputWidth()-\NewTabItem\Length-includes\Margin/2
					EndIf
					If \Attributes & #__tab_PopupButton
						\NewTabItem\Position - includes\ArrowHeight
					EndIf
				EndIf
				While NextElement(\Item())
					\Item()\Position = $FFFF
					\Item()\Visible  = #False
				Wend
			Else
				If \Attributes & #__tab_NewTab
					\NewTabItem\Position = Position + \Length
				EndIf
			EndIf
			
			Row(0)\Length = Position - includes\Margin+\Length+1
			
		EndIf
		
		; Größenänderung des Gadgets
		If Rows <> \Rows And (EventType() >= #PB_EventType_FirstCustomValue Or GetGadgetAttribute(\Number, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = #False)
			StopDrawing()
			If \Attributes & #__tab_Vertical
				ResizeGadget(\Number, #PB_Ignore, #PB_Ignore, Rows*\TabSize+includes\Margin, #PB_Ignore)
			Else
				ResizeGadget(\Number, #PB_Ignore, #PB_Ignore, #PB_Ignore, Rows*\TabSize+includes\Margin)
			EndIf
			PostEvent(#PB_Event_Gadget, \Window, \Number, #__event_Resize, -1)
			StartDrawing(CanvasOutput(\Number))
			DrawingFont(\FontID)
			\Resized = #True
			\Rows = Rows
		EndIf

		; Animation der bewegten Registerkarte
		If \MoveItem
			If \Attributes & #__tab_Vertical
				If \Attributes & #__tab_MirroredTabs XOr \Attributes & #__tab_ReverseOrdering
					MousePosition = \MouseY
				Else
					MousePosition = OutputHeight()-\MouseY-1
				EndIf
			Else
				If \Attributes & #__tab_ReverseOrdering
					MousePosition = OutputWidth()-\MouseX-1
				Else
					MousePosition = \MouseX
				EndIf
			EndIf
			Difference = Abs(\MoveItem\Position-(MousePosition-\MoveItem\Length/2))
			If Difference > 24
				Position = MousePosition - \MoveItem\Length/2
			Else
				Factor = Pow(Difference/24, 2)
				Position = \MoveItem\Position*(1-Factor) + (MousePosition-\MoveItem\Length/2)*Factor
			EndIf
			If \Attributes & #__tab_PreviousArrow = #Null 
				If Position < includes\Margin
					Position = includes\Margin
				EndIf
			ElseIf \Shift <= 0 And Position < includes\Margin + includes\ArrowWidth
				Position = includes\Margin + includes\ArrowWidth
			EndIf
			If (\Attributes & #__tab_NextArrow = #Null Or \Shift >= \LastShift) And Position + \MoveItem\Length + 1 - includes\Margin > Row(\MoveItem\Row)\Length - 1
				Position = Row(\MoveItem\Row)\Length + includes\Margin - \MoveItem\Length
			EndIf
			\MoveItem\Position = Position
		EndIf
		
		; Aussehen
		ForEach \Item()
			If \Item()\Disabled
				\Item()\Face = #__tab_item_DisableFace
			ElseIf \Item() = \MoveItem
				\Item()\Face = #__tab_item_MoveFace
			ElseIf \Item() = \SelectedItem Or \Item()\Selected
				\Item()\Face = #__tab_item_ActiveFace
			ElseIf \Item() = \HoverItem
				\Item()\Face = #__tab_item_HoverFace
			Else
				\Item()\Face = #__tab_item_NormalFace
			EndIf
			ItemLayout(*this, \Item())
		Next
		If \NewTabItem = \HoverItem
			\NewTabItem\Face = #__tab_item_HoverFace
		Else
			\NewTabItem\Face = #__tab_item_NormalFace
		EndIf
		ItemLayout(*this, \NewTabItem)
		Layout(*this)
		
		*this\UpdatePosted = #False
		
	EndWith
	
EndProcedure



; Zeichnet das gesamte TabBar
Procedure Draw(*this._s_widget)
	
	Protected X.i, Y.i, Size.i, SelectedItemDrawed.i, MoveItemDrawed.i, Row.i, *LastItem
	
	With *this
		
		; Initialisierung
		DrawingFont(\FontID)
		DrawingMode(#PB_2DDrawing_AllChannels)
		Box(0, 0, OutputWidth(), OutputHeight(), includes\TabBarColor)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		
		; Sichtbare Registerkarten
		*LastItem = LastElement(\Item())
		For Row = \Rows-1 To 0 Step -1
			If *LastItem
				PushListPosition(\Item())
				While \Item()\Row >= Row
					If \Item()\Visible And \Item()\Selected = #False And \Item() <> \MoveItem
						DrawItem(*this, \Item())
					EndIf
					If Not PreviousElement(\Item())
						Break
					EndIf
				Wend
			EndIf
			; ggf. "Neu"-Registerkarte (wenn keine Navigation)
			If \NewTabItem\Row = Row And \Attributes & #__tab_NewTab And \Attributes & #__tab_NextArrow = #Null
				DrawItem(*this, \NewTabItem)
			EndIf
			; ggf. Unterlinien
			If Row = 0 And \Attributes & #__tab_BottomLine
				If \Attributes & #__tab_Vertical
					If \Attributes & #__tab_MirroredTabs
						Line(0, 0, 1, OutputHeight(), includes\BorderColor)
					Else
						Line(OutputWidth()-1, 0, 1, OutputHeight(), includes\BorderColor)
					EndIf
				Else
					If \Attributes & #__tab_MirroredTabs
						Line(0, 0, OutputWidth(), 1, includes\BorderColor)
					Else
						Line(0, OutputHeight()-1, OutputWidth(), 1, includes\BorderColor)
					EndIf
				EndIf
			EndIf
			; ggf. aktive Registerkarte
			If *LastItem
				PopListPosition(\Item())
				While \Item()\Row >= Row
					If \Item()\Visible And \Item()\Selected = #True And \Item() <> \MoveItem
						DrawItem(*this, \Item())
					EndIf
					If Not PreviousElement(\Item())
						Break
					EndIf
				Wend
			EndIf
			; ggf. bewegte Registerkarte
			If \MoveItem And \MoveItem\Row = Row
				DrawItem(*this, \MoveItem)
			EndIf
		Next
		
		; Navigationsausblendung
		DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
		ResetGradientColors()
		GradientColor(0.0, includes\TabBarColor&$FFFFFF)
		GradientColor(0.5, includes\TabBarColor&$FFFFFF|$A0<<24)
		GradientColor(1.0, includes\TabBarColor&$FFFFFF|$FF<<24)
		Size = includes\Margin + includes\ArrowWidth + includes\FadeOut
		If \Attributes & #__tab_PreviousArrow And \Shift
			If \Attributes & #__tab_Vertical
				If \Attributes & #__tab_MirroredTabs XOr \Attributes & #__tab_ReverseOrdering
					LinearGradient(0, Size, 0, Size-includes\FadeOut)
					Box(0, 0, OutputWidth(), Size)
				Else
					LinearGradient(0, OutputHeight()-Size, 0, OutputHeight()-Size+includes\FadeOut)
					Box(0, OutputHeight()-Size, OutputWidth(), Size)
				EndIf
			Else
				If \Attributes & #__tab_ReverseOrdering
					LinearGradient(OutputWidth()-Size, 0, OutputWidth()-Size+includes\FadeOut, 0)
					Box(OutputWidth()-Size, 0, Size, OutputHeight())
				Else
					LinearGradient(Size, 0, Size-includes\FadeOut, 0)
					Box(0, 0, Size, OutputHeight())
				EndIf
			EndIf
		EndIf
		If \Attributes & #__tab_NextArrow And \Shift < \LastShift
			If \Attributes & #__tab_NewTab
				Size + \NewTabItem\Length+includes\Margin
			EndIf
			If \Attributes & #__tab_PopupButton
				Size + includes\ArrowHeight
			EndIf
			If \Attributes & #__tab_Vertical
				If \Attributes & #__tab_MirroredTabs XOr \Attributes & #__tab_ReverseOrdering
					LinearGradient(0, OutputHeight()-Size, 0, OutputHeight()-Size+includes\FadeOut)
					Box(0, OutputHeight()-Size, OutputWidth(), Size)
				Else
					LinearGradient(0, Size, 0, Size-includes\FadeOut)
					Box(0, 0, OutputWidth(), Size)
				EndIf
			Else
				If \Attributes & #__tab_ReverseOrdering
					LinearGradient(Size, 0, Size-includes\FadeOut, 0)
					Box(0, 0, Size, OutputHeight())
				Else
					LinearGradient(OutputWidth()-Size, 0, OutputWidth()-Size+includes\FadeOut, 0)
					Box(OutputWidth()-Size, 0, Size, OutputHeight())
				EndIf
			EndIf
		EndIf
		
		; Navigation
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		If \Attributes & #__tab_PreviousArrow
			If \HoverArrow = #__tab_PreviousArrow
				If \HoverArrow = \LockedArrow
					DrawButton(\Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, -1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				Else
					DrawButton(\Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, 1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				EndIf
				DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__tab_PreviousArrow, includes\TextColor, *this\Attributes)
			ElseIf \Shift > 0
				DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__tab_PreviousArrow, includes\TextColor&$FFFFFF|$80<<24, *this\Attributes)
			Else
				DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__tab_PreviousArrow, includes\TextColor&$FFFFFF|$20<<24, *this\Attributes)
			EndIf
		EndIf
		If \Attributes & #__tab_NextArrow
			If \HoverArrow = #__tab_NextArrow
				If \HoverArrow = \LockedArrow
					DrawButton(\Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, -1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				Else
					DrawButton(\Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, 1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				EndIf
				DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__tab_NextArrow, includes\TextColor, *this\Attributes)
			ElseIf \Shift < \LastShift
				DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__tab_NextArrow, includes\TextColor&$FFFFFF|$80<<24, *this\Attributes)
			Else
				DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__tab_NextArrow, includes\TextColor&$FFFFFF|$20<<24, *this\Attributes)
			EndIf
		EndIf
		
		; "Neu"-Registerkarten (wenn Navigation)
		If \Attributes & #__tab_NewTab And \Attributes & #__tab_NextArrow 
			DrawItem(*this, \NewTabItem)
		EndIf
		
		; Popup-Button
		If \Attributes & #__tab_PopupButton
			If \HoverArrow = #__tab_PopupButton
				If \HoverArrow = \LockedArrow
					DrawButton(\Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize, -1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				Else
					DrawButton(\Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize, 1, includes\FaceColor, *this\Attributes & #__tab_Vertical)
				EndIf
				DrawArrow(\Layout\PopupButtonX, \Layout\PopupButtonY, #__tab_PopupButton, includes\TextColor, *this\Attributes)
			Else
				DrawArrow(\Layout\PopupButtonX, \Layout\PopupButtonY, #__tab_PopupButton, includes\TextColor&$FFFFFF|$80<<24, *this\Attributes)
			EndIf
		EndIf
		
	EndWith
	
EndProcedure



; Dauerschleife für das automatische Scrollen in der Navigation
Procedure Timer(Null.i) ; Code OK
	
	With includes\Timer
		Repeat
			If \widget
				Delay(250)
				Repeat
					LockMutex(\Mutex)
					If \widget
						PostEvent(#PB_Event_Gadget, \widget\Window, \widget\Number, #__event_Pushed, \Type)
						UnlockMutex(\Mutex)
					Else
						UnlockMutex(\Mutex)
						Break
					EndIf
					Delay(150)
				ForEver
			Else
				Delay(50)
			EndIf
		ForEver
	EndWith
	
EndProcedure



; Sendet ein Ereignis, um die Registerkarte zu aktualisieren.
Procedure PostUpdate(*this._s_widget) ; Code OK
	
	If *this\UpdatePosted = #False
		*this\UpdatePosted = #True
		PostEvent(#PB_Event_Gadget, *this\Window, *this\Number, #__event_Updated, -1)
	EndIf
	
EndProcedure



; Callback für BindGadgetEvent()
Procedure Callback() ; Code OK
	
	Protected *this._s_widget = GetGadgetData(EventGadget())
	
	If EventType() >= #PB_EventType_FirstCustomValue
		*this\EventTab = EventData()
		Select EventType()
			Case #__event_Pushed
				Select EventData()
					Case #__tab_PreviousArrow
						If *this\Shift > 0
							*this\Shift - 1
						EndIf
					Case #__tab_NextArrow
						If *this\Shift < *this\LastShift
							*this\Shift + 1
						EndIf
				EndSelect
				If StartDrawing(CanvasOutput(*this\Number))
					Update(*this)
					Draw(*this)
					StopDrawing()
				EndIf
			Case #__event_Updated
				If StartDrawing(CanvasOutput(*this\Number))
					Update(*this)
					Draw(*this)
					StopDrawing()
				EndIf
		EndSelect
	Else
		If StartDrawing(CanvasOutput(*this\Number))
			Examine(*this)
			Update(*this)
			Draw(*this)
			StopDrawing()
		EndIf
	EndIf
	
EndProcedure





;-  4.2 Procedures for the TabBar
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯



; Führt eine Aktualisierung (Neuzeichnung) des Gadgets durch.
Procedure UpdateTabBar(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	If StartDrawing(CanvasOutput(Gadget))
		Update(*this)
		Draw(*this)
		StopDrawing()
	EndIf
	
EndProcedure



; Gibt das angegebene TabBar wieder frei.
Procedure FreeTabBar(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	ForEach *this\Item()
		ClearItem(*this, *this\Item())
	Next
	ClearStructure(*this, _s_widget)
	FreeMemory(*this)
	FreeGadget(Gadget)
	
EndProcedure



; Erstellt ein neus TabBar.
Procedure.i TabBar(Gadget.i, X.i, Y.i, Width.i, Height.i, Attributes.i, Window.i) ; Code OK
	
	Protected *this._s_widget = AllocateMemory(SizeOf(_s_widget))
	Protected Result.i, OldGadgetList.i, DummyGadget.i
	
	InitializeStructure(*this, _s_widget)
	OldGadgetList = UseGadgetList(WindowID(Window))
	Result = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard)
	UseGadgetList(OldGadgetList)
	If Gadget = #PB_Any
		Gadget = Result
	EndIf
	SetGadgetData(Gadget, *this)
	
	With *this
		\Attributes                  = Attributes
		\Number                      = Gadget
		\Window                      = Window
		\NewTabItem\Color\Text       = includes\TextColor
		\NewTabItem\Color\Background = includes\FaceColor
		\Radius                      = includes\Radius
		\MinTabLength                = includes\MinTabLength
		\MaxTabLength                = includes\MaxTabLength
		\NormalTabLength             = includes\NormalTabLength
		\TabTextAlignment            = includes\TabTextAlignment
		CompilerSelect #PB_Compiler_OS
			CompilerCase #PB_OS_Windows
				\FontID                  = GetGadgetFont(#PB_Default)
			CompilerDefault
				DummyGadget = TextGadget(#PB_Any, 0, 0, 10, 10, "Dummy")
				\FontID                  = GetGadgetFont(DummyGadget)
				FreeGadget(DummyGadget)
		CompilerEndSelect
		\EventTab                    = #__tab_item_None
	EndWith
	
	BindGadgetEvent(Gadget, @Callback())
	;BindEvent(#PB_Event_Gadget, @Callback(), #PB_All, Gadget, #PB_All) ; Aktuelle nicht benutzbar
	UpdateTabBar(Gadget)
	
	ProcedureReturn Result
	
EndProcedure



; Fügt eine Registerkarte an die angegebenen Position ein.
Procedure.i Add_Item(Gadget.i, Position.i, Text.s, ImageID.i=#Null, DataValue.i=#Null) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *Item._s_rows
	
	If Position = #__tab_item_NewTab
		*this\Attributes | #__tab_NewTab
		*Item = @*this\NewTabItem
	ElseIf ItemID(*this, Position)
		*Item = InsertElement(*this\Item())
	Else
		LastElement(*this\Item())
		*Item = AddElement(*this\Item())
		Position = ListIndex(*this\Item())
	EndIf
	
	With *Item
		\Text             = Text
		\ShortText        = Text
		ReplaceImage(*this, *Item, ImageID)
		\DataValue        = DataValue
		\Color\Text       = includes\TextColor
		\Color\Background = includes\FaceColor
		If *Item <> @*this\NewTabItem
			\Attributes       = *this\Attributes
		EndIf
	EndWith
	
	PostUpdate(*this)
	
	ProcedureReturn Position
	
EndProcedure



; Gibt die einmalige ID der angegebenen Registerkarte zurück.
Procedure.i _ItemID(Gadget.i, Position.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	ProcedureReturn ItemID(*this, Position)
	
EndProcedure



; Entfernt die Registerkarte mit der angegebenen Position.
Procedure Remove_Item(Gadget.i, Position.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	If Position = #__tab_item_NewTab
		*this\Attributes & ~#__tab_NewTab
	ElseIf ItemID(*this, Position)
		RemoveItem(*this, *this\Item())
	EndIf
	
	PostUpdate(*this)
	
EndProcedure



; Entfernt alle Registerkarten aus der Leiste.
Procedure Clear_Items(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	ForEach *this\Item()
		ClearItem(*this, *this\Item())
	Next
	ClearList(*this\Item())
	*this\SelectedItem = #Null
	
	PostUpdate(*this)
	
EndProcedure



; Gibt die Anzahl der Registerkarten zurück.
Procedure.i Count_Items(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	ProcedureReturn ListSize(*this\Item())
	
EndProcedure


; Setz einen ToolTip für die Registerkartenleiste (für die Registerkarten, die "Neu"-Registerkarte und den Schließenbutton)
Procedure Tab_ToolTip(Gadget.i, ItemText.s="", NewText.s="", CloseText.s="") ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	*this\ToolTip\ItemText  = ItemText
	*this\ToolTip\NewText   = NewText
	*this\ToolTip\CloseText = CloseText
	
EndProcedure



; Setz einen ToolTip für die Registerkarte.
Procedure Tab_ItemToolTip(Gadget.i, Tab.i, Text.s) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		*Item\ToolTip = Text
	EndIf
	
EndProcedure



; Ändert den Wert eines Attributs der Registerkartenleiste.
Procedure Set_Attribute(Gadget.i, Attribute.i, Value.i, Overwrite.i=#True) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	Select Attribute
		Case #__tab_CloseButton, #__tab_SelectedCloseButton, #__tab_NewTab, #__tab_NoTabMoving, #__tab_BottomLine,
					#__tab_MultiLine, #__tab_PopupButton, #__tab_Editable, #__tab_CheckBox, #__tab_ReverseOrdering
			If Value
				*this\Attributes | Attribute
				If Overwrite
					ForEach *this\Item()
						*this\Item()\Attributes | Attribute
					Next
				EndIf
			Else
				*this\Attributes & ~Attribute
				If Overwrite
					ForEach *this\Item()
						*this\Item()\Attributes & ~Attribute
					Next
				EndIf
			EndIf
		Case #__tab_MultiSelect
			If Value
				*this\Attributes | Attribute
			Else
				*this\Attributes & ~Attribute
				ForEach *this\Item()
					*this\Item()\Selected = #False
				Next
				If *this\SelectedItem
					*this\SelectedItem\Selected = #True
				EndIf
			EndIf
		Case #__tab_TextCutting
			If Value
				*this\Attributes | Attribute
			Else
				ForEach *this\Item()
					*this\Item()\ShortText = *this\Item()\Text
				Next
				*this\Attributes & ~Attribute
			EndIf
		Case #__tab_MirroredTabs, #__tab_Vertical
			*this\Rows = 0
			If Value
				*this\Attributes | Attribute
			Else
				*this\Attributes & ~Attribute
			EndIf
			ForEach *this\Item()
				If *this\Item()\Image
					RotateImage(*this, *this\Item())
				EndIf
			Next
			If *this\NewTabItem\Image
				RotateImage(*this, *this\NewTabItem)
			EndIf
		Case #__tab_TabRounding
			*this\Radius = Value
		Case #__tab_MinTabLength
			*this\MinTabLength = Value
		Case #__tab_TabTextAlignment
			*this\TabTextAlignment = Value
		Case #__tab_MaxTabLength
			ForEach *this\Item()
				*this\Item()\ShortText = *this\Item()\Text
			Next
			*this\MaxTabLength = Value
		Case #__tab_ScrollPosition
			If Value < 0
				*this\Shift = 0
			ElseIf Value > *this\LastShift
				*this\Shift = *this\LastShift
			Else
				*this\Shift = Value
			EndIf
	EndSelect
	
	PostUpdate(*this)
	
EndProcedure



; Gibt den Wert eines Attributs der Registerkartenleiste zurück.
Procedure.i Get_Attribute(Gadget.i, Attribute.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	Select Attribute
		Case #__tab_CloseButton, #__tab_SelectedCloseButton, #__tab_NewTab, #__tab_MirroredTabs, #__tab_TextCutting,
		     #__tab_NoTabMoving, #__tab_BottomLine, #__tab_MultiLine, #__tab_PopupButton, #__tab_Editable,
		     #__tab_MultiSelect, #__tab_Vertical, #__tab_CheckBox, #__tab_ReverseOrdering
			If *this\Attributes & Attribute
				ProcedureReturn #True
			Else
				ProcedureReturn #False
			EndIf
		Case #__tab_TabRounding
			ProcedureReturn *this\Radius
		Case #__tab_MinTabLength
			ProcedureReturn *this\MinTabLength
		Case #__tab_MaxTabLength
			ProcedureReturn *this\MaxTabLength
		Case #__tab_ScrollPosition
			ProcedureReturn *this\Shift
		Case #__tab_TabTextAlignment
			ProcedureReturn *this\TabTextAlignment
	EndSelect
	
EndProcedure



; Ändert den Daten-Wert der Registerkartenleiste.
Procedure Set_Data(Gadget.i, DataValue.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	*this\DataValue = DataValue
	
EndProcedure



; Gibt den Daten-Wert der Registerkartenleiste zurück.
Procedure.i Get_Data(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	ProcedureReturn *this\DataValue
	
EndProcedure



; Ändert die zu nutzende Schrift.
Procedure Set_Font(Gadget.i, FontID.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	If FontID = #PB_Default
		*this\FontID = GetGadgetFont(#PB_Default)
	Else
		*this\FontID = FontID
	EndIf
	
	PostUpdate(*this)
	
EndProcedure



; Ändert den Status der Registerkartenleiste.
Procedure Set_State(Gadget.i, State.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *Item._s_rows
	
	ForEach *this\Item()
		*this\Item()\Selected = #False
	Next
	Select State
		Case #__tab_item_None, #__tab_item_NewTab
			*this\SelectedItem = #Null
		Case #__tab_item_Selected
		Default
			*Item = ItemID(*this, State)
			If *Item
				SelectItem(*this, *Item)
			EndIf
	EndSelect
	
	PostUpdate(*this)
	
EndProcedure



; Gibt den Status der Registerkartenleiste zurück.
Procedure.i Get_State(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	If *this\SelectedItem
		ChangeCurrentElement(*this\Item(), *this\SelectedItem)
		ProcedureReturn ListIndex(*this\Item())
	EndIf
	
	ProcedureReturn #__tab_item_None
	
EndProcedure



; Wechselt zur der Registerkarte mit dem angegebenen Text
Procedure Set_Text(Gadget.i, Text.s) ; Code OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	*this\SelectedItem = #Null
	ForEach *this\Item()
		If *this\Item()\Text = Text
			Set_State(Gadget, @*this\Item())
			Break
		EndIf
	Next
	
EndProcedure



; Gibt den Text der aktuell ausgewählten Registerkarte zurück.
Procedure.s Get_Text(Gadget.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	If *this\SelectedItem
		ProcedureReturn *this\SelectedItem\Text
	EndIf
	
EndProcedure



; Ändert die Attribute der angegebenen Registerkarte.
Procedure Set_ItemAttribute(Gadget.i, Tab.i, Attribute.i, Value.i)
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *Item._s_rows = ItemID(*this, Tab)
	
	If *Item And *Item <> *this\NewTabItem
		Select Attribute
			Case #__tab_CloseButton, #__tab_SelectedCloseButton, #__tab_CheckBox
				If Value
					*Item\Attributes | Attribute
				Else
					*Item\Attributes & ~Attribute
				EndIf
		EndSelect
		PostUpdate(*this)
	EndIf
	
EndProcedure



; Gibt den Status der angegebenen Registerkarte zurück.
Procedure.i Get_ItemAttribute(Gadget.i, Tab.i, Attribute.i)
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	Protected State.i
	
	If *Item
		Select Attribute
			Case #__tab_CloseButton, #__tab_SelectedCloseButton, #__tab_CheckBox
				If *Item\Attributes & Attribute
					ProcedureReturn #True
				Else
					ProcedureReturn #False
				EndIf
		EndSelect
	EndIf
	
EndProcedure



; Ändert den Datenwert der angegebenen Registerkarte.
Procedure Set_ItemData(Gadget.i, Tab.i, DataValue.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		*Item\DataValue = DataValue
	EndIf
	
EndProcedure



; Gibt den Datenwert der angegebenen Registerkarte zurück.
Procedure.i Get_ItemData(Gadget.i, Tab.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		ProcedureReturn *Item\DataValue
	EndIf
	
EndProcedure



; Ändert die Farbe der angegebenen Registerkarte.
Procedure Set_ItemColor(Gadget.i, Tab.i, Type.i, Color.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		Select Type
			Case #PB_Gadget_FrontColor
				If Color = #PB_Default
					Color = includes\TextColor
				EndIf
				*Item\Color\Text = Color | $FF<<24
			Case #PB_Gadget_BackColor
				If Color = #PB_Default
					Color = includes\FaceColor
				EndIf
				*Item\Color\Background = Color | $FF<<24
		EndSelect
		PostUpdate(GetGadgetData(Gadget))
	EndIf
	
EndProcedure



; Gibt die Farbe der angegebenen Registerkarte zurück.
Procedure.i Get_ItemColor(Gadget.i, Tab.i, Type.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		Select Type
			Case #PB_Gadget_FrontColor
				ProcedureReturn *Item\Color\Text
			Case #PB_Gadget_BackColor
				ProcedureReturn *Item\Color\Background
		EndSelect
	EndIf
	
EndProcedure



; Ändert das Icon der angegebenen Registerkarte.
Procedure Set_ItemImage(Gadget.i, Tab.i, ImageID.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *Item._s_rows = ItemID(*this, Tab)
	
	If *Item
		ReplaceImage(*this, *Item, ImageID)
		PostUpdate(*this)
	EndIf
	
EndProcedure



; Ändert die Position der angegebenen Registerkarte (die Registerkarte wird also verschoben).
Procedure Set_ItemPosition(Gadget.i, Tab.i, Position.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *NewItem._s_rows = ItemID(*this, Position)
	Protected *Item._s_rows = ItemID(*this, Tab)
	
	If *Item And *Item <> *this\NewTabItem
		If *NewItem And *NewItem <> *this\NewTabItem
			If Position > Tab
				MoveElement(*this\Item(), #PB_List_After, *NewItem)
			Else
				MoveElement(*this\Item(), #PB_List_Before, *NewItem)
			EndIf
		Else
			MoveElement(*this\Item(), #PB_List_Last)
		EndIf
		PostUpdate(*this)
	EndIf
	
EndProcedure



; Gibt die Position der angegebenen Registerkarte zurück.
Procedure Get_ItemPosition(Gadget.i, Tab.i) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	
	With *this
		
		Select Tab
			Case #__tab_item_Event
				ProcedureReturn \EventTab
			Case #__tab_item_Selected
				If \SelectedItem
					ChangeCurrentElement(\Item(), \SelectedItem)
					ProcedureReturn ListIndex(\Item())
				Else
					ProcedureReturn #__tab_item_None
				EndIf
			Case #__tab_item_NewTab, #__tab_item_None
				ProcedureReturn Tab
			Default 
				If Tab >= 0 And Tab < ListSize(\Item())
					ProcedureReturn Tab
				ElseIf Tab >= ListSize(\Item())
					ForEach \Item()
						If @\Item() = Tab
							ProcedureReturn ListIndex(\Item())
						EndIf
					Next
					ProcedureReturn #__tab_item_None
				EndIf
		EndSelect
		
	EndWith
	
EndProcedure



; Ändert den Status der angegebenen Registerkarte.
Procedure Set_ItemState(Gadget.i, Tab.i, State.i, Mask.i=#__tab_Disabled|#__tab_Selected|#__tab_Checked) ; Code OK, Hilfe OK
	
	Protected *this._s_widget = GetGadgetData(Gadget)
	Protected *Item._s_rows = ItemID(*this, Tab)
	
	If *Item And *Item <> *this\NewTabItem
		If Mask & #__tab_Disabled
			*Item\Disabled = Bool(State&#__tab_Disabled)
		EndIf
		If Mask & #__tab_Checked
			*Item\Checked = Bool(State&#__tab_Checked)
		EndIf
		If Mask & #__tab_Selected
			If State & #__tab_Selected
				SelectItem(*this, *Item)
			Else
				UnselectItem(*this, *Item)
			EndIf
		EndIf
		PostUpdate(*this)
	EndIf
	
EndProcedure



; Gibt den Status der angegebenen Registerkarte zurück.
Procedure.i Get_ItemState(Gadget.i, Tab.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		ProcedureReturn (*Item\Disabled*#__tab_Disabled) | (*Item\Selected*#__tab_Selected) | (*Item\Checked*#__tab_Checked)
	EndIf
	
EndProcedure



; Ändert den Text der angegebenen Registerkarte.
Procedure Set_ItemText(Gadget.i, Tab.i, Text.s) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		*Item\Text      = Text
		*Item\ShortText = Text
		PostUpdate(GetGadgetData(Gadget))
	EndIf
	
EndProcedure



; Gibt den Text der angegebenen Registerkarte zurück.
Procedure.s Get_ItemText(Gadget.i, Tab.i) ; Code OK, Hilfe OK
	
	Protected *Item._s_rows = _ItemID(Gadget, Tab)
	
	If *Item
		ProcedureReturn *Item\Text
	EndIf
	
EndProcedure














;-
;XIncludeFile "TabBar.pbi"

Enumeration
	#Window
	#Image
	#Gadget_TabBar
	#Gadget_Vertical
	#Gadget_CloseButton
	#Gadget_SelectedCloseButton
	#Gadget_EmptyButton
	#Gadget_MirroredTabs
	#Gadget_TextCutting
	#Gadget_NoTabMoving
	#Gadget_TabRounding
	#Gadget_MultiLine
	#Gadget_BottomLine
	#Gadget_Editable
	#Gadget_MultiSelect
	#Gadget_CheckBox
	#Gadget_ReverseOrdering
	#Gadget_TabTextAlignment
	#Gadget_MinTabLength
	#Gadget_MaxTabLength
	#Gadget_Item
	#Gadget_ItemBackColor
	#Gadget_ItemFrontColor
	#Gadget_ItemText
	#Gadget_ItemImage
	#Gadget_ItemDisabled
	#Gadget_ItemSelected
	#Gadget_ItemChecked
	#Gadget_ItemCloseButton
	#Gadget_ItemCheckBox
	#Gadget_Events
	#Gadget_Container
EndEnumeration

Procedure BorderGadget(ID.i, X.i, Y.i, Width.i, Height.i, Text.s)
	Protected Result.i
	If ID = #PB_Any
		Result = ContainerGadget(ID, X, Y, Width, Height)
		SetGadgetData(Result, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
	Else
		Result = ContainerGadget(ID, X, Y, Width, Height)
		SetGadgetData(ID, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
	EndIf
	ProcedureReturn Result
EndProcedure

Procedure GetItemGadgetState()
	Select GetGadgetState(#Gadget_Item)
		Case -1
			ProcedureReturn #__tab_item_None
		Case 0
			ProcedureReturn #__tab_item_NewTab
		Default
			ProcedureReturn GetGadgetState(#Gadget_Item)-1
	EndSelect
EndProcedure

Procedure UpdateItemAttributes(Position)
	If GetGadgetText(#Gadget_ItemText) <> Get_ItemText(#Gadget_TabBar, Position)
		SetGadgetText(#Gadget_ItemText, Get_ItemText(#Gadget_TabBar, Position))
	EndIf
	SetGadgetState(#Gadget_ItemDisabled, (Get_ItemState(#Gadget_TabBar, Position)&#__tab_Disabled))
	SetGadgetState(#Gadget_ItemSelected, (Get_ItemState(#Gadget_TabBar, Position)&#__tab_Selected))
	SetGadgetState(#Gadget_ItemChecked, (Get_ItemState(#Gadget_TabBar, Position)&#__tab_Checked))
	SetGadgetState(#Gadget_ItemCloseButton, Get_ItemAttribute(#Gadget_TabBar, Position, #__tab_CloseButton))
	SetGadgetState(#Gadget_ItemCheckBox, Get_ItemAttribute(#Gadget_TabBar, Position, #__tab_CheckBox))
EndProcedure

Procedure UpdateItemGadget(Position)
	Protected Index
	ClearGadgetItems(#Gadget_Item)
	AddGadgetItem(#Gadget_Item, #PB_Default, "NewTab")
	For Index = 1 To Count_Items(#Gadget_TabBar)
		AddGadgetItem(#Gadget_Item, #PB_Default, "Position "+Str(Index-1))
	Next
	Set_State(#Gadget_TabBar, Position)
	SetGadgetState(#Gadget_Item, Position+1)
	UpdateItemAttributes(GetItemGadgetState())
EndProcedure



Define Color.i, FileName.s, Position.i

UsePNGImageDecoder()

OpenWindow(#Window, 0, 0, 800, 450, "TabBar", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget)

TabBar(#Gadget_TabBar, 0, 0, WindowWidth(#Window), #__tab_DefaultHeight, #__tab_None, #Window)
	Add_Item(#Gadget_TabBar, #PB_Default, "In this")
	Add_Item(#Gadget_TabBar, #PB_Default, "example")
	Add_Item(#Gadget_TabBar, #PB_Default, "you can")
	Add_Item(#Gadget_TabBar, #PB_Default, "feel the")
	Add_Item(#Gadget_TabBar, #PB_Default, "power of")
	Add_Item(#Gadget_TabBar, #PB_Default, "Pure Basic")
	Add_Item(#Gadget_TabBar, #PB_Default, "and the")
	Add_Item(#Gadget_TabBar, #PB_Default, "TabBar")
	Add_Item(#Gadget_TabBar, #PB_Default, "include")
Tab_ToolTip(#Gadget_TabBar, "%ITEM", "new", "close")

If ContainerGadget(#Gadget_Container, 0, GadgetHeight(#Gadget_TabBar), WindowWidth(#Window), WindowHeight(#Window)-GadgetHeight(#Gadget_TabBar), #PB_Container_Flat)
	
	If BorderGadget(#PB_Any, 5, 5, 170, 370, "Attributes for the bar")
		CheckBoxGadget(#Gadget_CloseButton, 10, 20, 130, 20, "tab close button")
		CheckBoxGadget(#Gadget_SelectedCloseButton, 10, 40, 130, 20, "selected tab close button")
		CheckBoxGadget(#Gadget_EmptyButton, 10, 60, 130, 20, "'new' tab")
		CheckBoxGadget(#Gadget_CheckBox, 10, 80, 130, 20, "tab check box")
		CheckBoxGadget(#Gadget_Vertical, 10, 100, 130, 20, "vertical tab bar")
		CheckBoxGadget(#Gadget_MirroredTabs, 10, 120, 130, 20, "mirror tab bar")
		CheckBoxGadget(#Gadget_ReverseOrdering, 10, 140, 130, 20, "reverse ordering")
		CheckBoxGadget(#Gadget_MultiLine, 10, 160, 130, 20, "multiline tab bar")
		CheckBoxGadget(#Gadget_TextCutting, 10, 180, 130, 20, "text cutting")
		CheckBoxGadget(#Gadget_Editable, 10, 200, 130, 20, "editable tab text")
		CheckBoxGadget(#Gadget_MultiSelect, 10, 220, 130, 20, "multi select")
		CheckBoxGadget(#Gadget_NoTabMoving, 10, 240, 130, 20, "no tab moving")
		CheckBoxGadget(#Gadget_BottomLine, 10, 260, 130, 20, "bottom line")
		TextGadget(#PB_Any, 10, 285, 90, 20, "tab text alignment:")
			SpinGadget(#Gadget_TabTextAlignment, 100, 280, 60, 20, -1, 1, #PB_Spin_Numeric)
			SetGadgetState(#Gadget_TabTextAlignment, Get_Attribute(#Gadget_TabBar, #__tab_TabTextAlignment))
		TextGadget(#PB_Any, 10, 305, 90, 20, "tab rounding:")
			SpinGadget(#Gadget_TabRounding, 100, 300, 60, 20, 0, 20, #PB_Spin_Numeric)
			SetGadgetState(#Gadget_TabRounding, Get_Attribute(#Gadget_TabBar, #__tab_TabRounding))
		TextGadget(#PB_Any, 10, 325, 90, 20, "min tab length:")
			SpinGadget(#Gadget_MinTabLength, 100, 320, 60, 20, 0, 1000, #PB_Spin_Numeric)
			SetGadgetState(#Gadget_MinTabLength, Get_Attribute(#Gadget_TabBar, #__tab_MinTabLength))
		TextGadget(#PB_Any, 10, 345, 90, 20, "max tab length:")
			SpinGadget(#Gadget_MaxTabLength, 100, 340, 60, 20, 0, 1000, #PB_Spin_Numeric)
			SetGadgetState(#Gadget_MaxTabLength, Get_Attribute(#Gadget_TabBar, #__tab_MaxTabLength))
		CloseGadgetList()
	EndIf
	
	If BorderGadget(#PB_Any, 180, 5, 375, 195, "Tabs")
		TextGadget(#PB_Any, 10, 28, 50, 20, "Position:")
		ComboBoxGadget(#Gadget_Item, 60, 25, 100, 20)
		ButtonGadget(#Gadget_ItemBackColor, 10, 50, 100, 20, "background color")
		ButtonGadget(#Gadget_ItemFrontColor, 115, 50, 100, 20, "text color")
		TextGadget(#PB_Any, 10, 78, 30, 20, "Text:")
		StringGadget(#Gadget_ItemText, 40, 75, 175, 20, Get_Text(#Gadget_TabBar))
		CheckBoxGadget(#Gadget_ItemDisabled, 10, 100, 100, 20, "disabled")
		CheckBoxGadget(#Gadget_ItemSelected, 10, 120, 100, 20, "seleced")
		CheckBoxGadget(#Gadget_ItemChecked, 10, 140, 100, 20, "checked")
		CheckBoxGadget(#Gadget_ItemCloseButton, 210, 100, 100, 20, "close button")
		CheckBoxGadget(#Gadget_ItemCheckBox, 210, 120, 100, 20, "check box")
		ButtonGadget(#Gadget_ItemImage, 10, 165, 100, 20, "image or icon", #PB_Button_Toggle)
		CloseGadgetList()
	EndIf
	
	If BorderGadget(#PB_Any, 180, 210, 225, 120, "Events")
		EditorGadget(#Gadget_Events, 10, 20, 200, 90, #PB_Editor_ReadOnly)
		CloseGadgetList()
	EndIf

UpdateItemGadget(0)

EndIf


Procedure Resize()
	
	If Get_Attribute(#Gadget_TabBar, #__tab_Vertical)
		ResizeGadget(#Gadget_TabBar, 0, 0, #PB_Ignore, WindowHeight(#Window))
		UpdateTabBar(#Gadget_TabBar)
		ResizeGadget(#Gadget_Container, GadgetWidth(#Gadget_TabBar), 0, WindowWidth(#Window)-GadgetWidth(#Gadget_TabBar), WindowHeight(#Window))
	Else
		ResizeGadget(#Gadget_TabBar, 0, 0, WindowWidth(#Window), #PB_Ignore)
		UpdateTabBar(#Gadget_TabBar)
		ResizeGadget(#Gadget_Container, 0, GadgetHeight(#Gadget_TabBar), WindowWidth(#Window), WindowHeight(#Window)-GadgetHeight(#Gadget_TabBar))
	EndIf
	
EndProcedure

BindEvent(#PB_Event_SizeWindow, @Resize())
Resize()


Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_CloseWindow
			
			End
			
		Case #PB_Event_SizeWindow
			
		Case #PB_Event_Gadget
			
			Select EventGadget()
				Case #Gadget_TabBar
					Select EventType()
						Case #__event_NewItem
							AddGadgetItem(#Gadget_Events, 0, "NewItem: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
							Position = Add_Item(#Gadget_TabBar, #PB_Default, "New tab")
							UpdateItemGadget(Position)
						Case #__event_CloseItem
							AddGadgetItem(#Gadget_Events, 0, "CloseItem: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
							Remove_Item(#Gadget_TabBar, #__tab_item_Event)
						Case #__event_Change
							AddGadgetItem(#Gadget_Events, 0, "Change: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
						Case #__event_CheckBox
							AddGadgetItem(#Gadget_Events, 0, "CheckBox: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
						Case #__event_Resize
							AddGadgetItem(#Gadget_Events, 0, "Resize")
							Resize()
						Case #__event_EditItem
							AddGadgetItem(#Gadget_Events, 0, "EditItem: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
						Case #__event_SwapItem
							AddGadgetItem(#Gadget_Events, 0, "SwapItem: "+Str(Get_ItemPosition(#Gadget_TabBar, #__tab_item_Event)))
					EndSelect
					UpdateItemAttributes(GetItemGadgetState())
				Case #Gadget_CloseButton
					Set_Attribute(#Gadget_TabBar, #__tab_CloseButton, GetGadgetState(#Gadget_CloseButton))
				Case #Gadget_SelectedCloseButton
					Set_Attribute(#Gadget_TabBar, #__tab_SelectedCloseButton, GetGadgetState(#Gadget_SelectedCloseButton))
				Case #Gadget_EmptyButton
					Set_Attribute(#Gadget_TabBar, #__tab_NewTab, GetGadgetState(#Gadget_EmptyButton))
				Case #Gadget_Vertical
					Set_Attribute(#Gadget_TabBar, #__tab_Vertical, GetGadgetState(#Gadget_Vertical))
					Resize()
				Case #Gadget_MirroredTabs
					Set_Attribute(#Gadget_TabBar, #__tab_MirroredTabs, GetGadgetState(#Gadget_MirroredTabs))
				Case #Gadget_TextCutting
					Set_Attribute(#Gadget_TabBar, #__tab_TextCutting, GetGadgetState(#Gadget_TextCutting))
				Case #Gadget_NoTabMoving
					Set_Attribute(#Gadget_TabBar, #__tab_NoTabMoving, GetGadgetState(#Gadget_NoTabMoving))
				Case #Gadget_TabRounding
					Set_Attribute(#Gadget_TabBar, #__tab_TabRounding, GetGadgetState(#Gadget_TabRounding))
				Case #Gadget_MultiLine
					Set_Attribute(#Gadget_TabBar, #__tab_MultiLine, GetGadgetState(#Gadget_MultiLine))
				Case #Gadget_BottomLine
					Set_Attribute(#Gadget_TabBar, #__tab_BottomLine, GetGadgetState(#Gadget_BottomLine))
				Case #Gadget_Editable
					Set_Attribute(#Gadget_TabBar, #__tab_Editable, GetGadgetState(#Gadget_Editable))
				Case #Gadget_MultiSelect
					Set_Attribute(#Gadget_TabBar, #__tab_MultiSelect, GetGadgetState(#Gadget_MultiSelect))
				Case #Gadget_CheckBox
					Set_Attribute(#Gadget_TabBar, #__tab_CheckBox, GetGadgetState(#Gadget_CheckBox))
				Case #Gadget_ReverseOrdering
					Set_Attribute(#Gadget_TabBar, #__tab_ReverseOrdering, GetGadgetState(#Gadget_ReverseOrdering))
				Case #Gadget_MinTabLength
					Set_Attribute(#Gadget_TabBar, #__tab_MinTabLength, GetGadgetState(#Gadget_MinTabLength))
				Case #Gadget_MaxTabLength
					Set_Attribute(#Gadget_TabBar, #__tab_MaxTabLength, GetGadgetState(#Gadget_MaxTabLength))
				Case #Gadget_TabTextAlignment
					Set_Attribute(#Gadget_TabBar, #__tab_TabTextAlignment, GetGadgetState(#Gadget_TabTextAlignment))
				Case #Gadget_Item
					SetGadgetText(#Gadget_ItemText, Get_ItemText(#Gadget_TabBar, GetItemGadgetState()))
					UpdateItemAttributes(GetItemGadgetState())
				Case #Gadget_ItemBackColor
					Color = Get_ItemColor(#Gadget_TabBar, Get_State(#Gadget_TabBar), #PB_Gadget_BackColor)
					Color = ColorRequester(Color)
					If Color > -1
						Set_ItemColor(#Gadget_TabBar, GetItemGadgetState(), #PB_Gadget_BackColor, Color)
					EndIf
				Case #Gadget_ItemFrontColor
					Color = Get_ItemColor(#Gadget_TabBar, Get_State(#Gadget_TabBar), #PB_Gadget_FrontColor)
					Color = ColorRequester(Color)
					If Color > -1
						Set_ItemColor(#Gadget_TabBar, GetItemGadgetState(), #PB_Gadget_FrontColor, Color)
					EndIf
				Case #Gadget_ItemText
					Set_ItemText(#Gadget_TabBar, GetItemGadgetState(), GetGadgetText(#Gadget_ItemText))
				Case #Gadget_ItemDisabled
					Set_ItemState(#Gadget_TabBar, GetItemGadgetState(), GetGadgetState(#Gadget_ItemDisabled)*#__tab_Disabled, #__tab_Disabled)
				Case #Gadget_ItemSelected
					Set_ItemState(#Gadget_TabBar, GetItemGadgetState(), GetGadgetState(#Gadget_ItemSelected)*#__tab_Selected, #__tab_Selected)
				Case #Gadget_ItemChecked
					Set_ItemState(#Gadget_TabBar, GetItemGadgetState(), GetGadgetState(#Gadget_ItemChecked)*#__tab_Checked, #__tab_Checked)
				Case #Gadget_ItemCloseButton
					Set_ItemAttribute(#Gadget_TabBar, GetItemGadgetState(), #__tab_CloseButton, GetGadgetState(#Gadget_ItemCloseButton))
				Case #Gadget_ItemCheckBox
					Set_ItemAttribute(#Gadget_TabBar, GetItemGadgetState(), #__tab_CheckBox, GetGadgetState(#Gadget_ItemCheckBox))
				Case #Gadget_ItemImage
					If GetGadgetState(#Gadget_ItemImage)
						FileName = OpenFileRequester("Image", "", "Images (*.bmp;*.png)|*.bmp;*.png", 0)
						If FileName And LoadImage(#Image, FileName)
							Set_ItemImage(#Gadget_TabBar, GetItemGadgetState(), ImageID(#Image))
						EndIf
					Else
						Set_ItemImage(#Gadget_TabBar, GetItemGadgetState(), #Null)
					EndIf
			EndSelect
			
	EndSelect
	
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------------------------------------------------------------------------------
; EnableXP