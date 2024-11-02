; https://www.purebasic.fr/english/viewtopic.php?t=85162
;***********************************************************
;
;                      TOM Library
;
;                  For text formatting
;                   in EditorGadgets.
;
;            Pour la mise en forme de textes
;                 dans un EditorGadget.
;
;***********************************************************
;
;     Example of using the Text Object Model (TOM)
;                 For Windows only.
;           Works on PureBasic 4.5 -> 6.11
;
; One of the advantages of TOM is that it allows modifying
; the formatting of text in an EditorGadget without changing
; (and thus, without losing) the current selection.
;
; The two main procedures in this library are:
; - TOM_SetFontStyles(), which allows applying a specific style
;   (bold, italic, underline, etc.) to a given text range.
; - TOM_SetParaStyles(), which allows applying a specific paragraph
;   style (indentation, spacing, etc.) to a given text range.
;
; The formatting commands are provided to these procedures
; in text mode.
; For example: TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Bold, Size(12)"),
; so that they can be used by programmers of all levels.
;
; The possible commands are numerous and should cover almost
; all possible needs.
;
; A more complete usage example is provided at the end of the page.
;
; The list of possible commands is provided at the beginning of the code for
; the TOM_SetFontStyles() and TOM_SetParaStyles() procedures.
;
;***********************************************************
;
;     Exemple d'utilisation du Text Object Model (TOM)
;                 Pour Windows uniquement.
;           Fonctionne sur PureBasic 4.5 -> 6.11
;
; L'un des avantages du TOM est qu'il permet de modifier la
; mise en forme d'un texte dans un EditorGadget sans modifier
; (et donc, sans perdre) la sélection courante.
;
; Les deux principales procédures de la présente librairie sont
; - TOM_SetFontStyles() qui permet d'appliquer un style particulier
;   (gras, italique, souligné, etc.) à une plage de texte donnée.
; - TOM_SetParaStyles() qui permet d'appliquer un style de paragraphe
;   particulier (indentation, interparagraphe, etc.) à une plage
;   de texte donnée.
;
; Les commandes de mise en forme sont fournies à ces procédures
; en mode texte.
; Par exemple : TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Bold, Size(12)"),
; afin d'être utilisables par les programmeurs de tous niveaux.
;
; Les commandes possibles sont très nombreuses et devraient permettre de
; répondre à peu près à tous les besoins possibles.
;
; Un exemple d'utilisation plus complet figure en fin de page.
;
; La liste des commandes possibles et fournies au début du code des
; procédures TOM_SetFontStyles() et TOM_SetParaStyles()
;
#TomTrue      = -1
#TomFalse     = 0
#TomDefault   = -9999996
#TomAutoColor = -9999997
;
Enumeration Tom_UnderlineStyles
  #TomNone
  #TomSingle
  #TomWords
  #TomDouble
  #TomDotted
  #TomDash
  #TomDashDot
  #TomDashDotDot
  #TomWave
  #TomThick
  #TomHair
  #TomDoubleWave
  #TomHeavyWave
  #TomLongDash
  #TomThickDash
  #TomThickDashDot
  #TomThickDashDotDot
  #TomThickDotted
  #TomThickLongDash
EndEnumeration
;
Enumeration Tom_AlignmentStyles
  #TomAlignLeft       = 0
  #TomAlignCenter     = 1
  #TomAlignRight      = 2
  #TomAlignJustify    = 3
  #TomAlignDecimal    = 3
  #TomAlignBar        = 4
  #TomAlignInterWord  = 3
  #TomAlignNewspaper  = 4
  #TomAlignInterLetter= 5
  #TomAlignScaled     = 6
EndEnumeration
;
Enumeration Tom_SpaceLineRules
  #TomLineSpaceSingle
  #TomLineSpace1pt5
  #TomLineSpaceDouble
  #TomLineSpaceAtLeast
  #TomLineSpaceExactly
  #TomLineSpaceMultiple
  #TomLineSpacePercent
EndEnumeration
;
Enumeration Tom_Animations
  #TomNoAnimation
  #TomLasVegasLights
  #TomBlinkingBackground
  #TomSparkleText
  #TomMarchingBlackAnts
  #TomMarchingRedAnts
  #TomShimmer
  #TomWipeDown
  #TomWipeRight
EndEnumeration
;
; The resident Interface of ITextFont has bad parameters with
; version 6.11 (and olders) of PureBasic.
; So, a fixed interface must be set. Thanks to Justin (PB Forum)
; for the fixed interface:
Interface ITextFont_Fixed Extends IDispatch
	GetDuplicate(prop.i)
	SetDuplicate(Duplicate.i)
	CanChange(prop.i)
	IsEqual(pFont.i, prop.i)
	Reset(Value.l)
	GetStyle(prop.i)
	SetStyle(Style.l)
	GetAllCaps(prop.i)
	SetAllCaps(AllCaps.l)
	GetAnimation(prop.i)
	SetAnimation(Animation.l)
	GetBackColor(prop.i)
	SetBackColor(BackColor.l)
	GetBold(prop.i)
	SetBold(Bold.l)
	GetEmboss(prop.i)
	SetEmboss(Emboss.l)
	GetForeColor(prop.i)
	SetForeColor(ForeColor.l)
	GetHidden(prop.i)
	SetHidden(Hidden.l)
	GetEngrave(prop.i)
	SetEngrave(Engrave.l)
	GetItalic(prop.i)
	SetItalic(Italic.l)
	GetKerning(prop.i)
	SetKerning(Kerning.f)
	GetLanguageID(prop.i)
	SetLanguageID(LanguageID.l)
	GetName(prop.i)
	SetName(Name.p-bstr)
	GetOutline(prop.i)
	SetOutline(Outline.l)
	GetPosition(prop.i)
	SetPosition(Position.f)
	GetProtected(prop.i)
	SetProtected(Protected.l)
	GetShadow(prop.i)
	SetShadow(Shadow.l)
	GetSize(prop.i)
	SetSize(Size.f)
	GetSmallCaps(prop.i)
	SetSmallCaps(SmallCaps.l)
	GetSpacing(prop.i)
	SetSpacing(Spacing.f)
	GetStrikeThrough(prop.i)
	SetStrikeThrough(StrikeThrough.l)
	GetSubscript(prop.i)
	SetSubscript(Subscript.l)
	GetSuperscript(prop.i)
	SetSuperscript(Superscript.l)
	GetUnderline(prop.i)
	SetUnderline(Underline.l)
	GetWeight(prop.i)
	SetWeight(Weight.l)
EndInterface 
;
; The resident Interface of ITextPara has bad parameters with
; version 6.11 (and olders) of PureBasic.
; So, a fixed interface must be set. Thanks to Justin (PB Forum)
; for the fixed interface:
Interface ITextPara_Fixed Extends IDispatch
	GetDuplicate(prop.i)
	SetDuplicate(Duplicate.i)
	CanChange(prop.i)
	IsEqual(pPara.i, prop.i)
	Reset(Value.l)
	GetStyle(prop.i)
	SetStyle(Style.l)
	GetAlignment(prop.i)
	SetAlignment(Alignment.l)
	GetHyphenation(prop.i)
	SetHyphenation(Hyphenation.l)
	GetFirstLineIndent(prop.i)
	GetKeepTogether(prop.i)
	SetKeepTogether(KeepTogether.l)
	GetKeepWithNext(prop.i)
	SetKeepWithNext(KeepWithNext.l)
	GetLeftIndent(prop.i)
	GetLineSpacing(prop.i)
	GetLineSpacingRule(prop.i)
	GetListAlignment(prop.i)
	SetListAlignment(ListAlignment.l)
	GetListLevelIndex(prop.i)
	SetListLevelIndex(ListLevelIndex.l)
	GetListStart(prop.i)
	SetListStart(ListStart.l)
	GetListTab(prop.i)
	SetListTab(ListTab.f)
	GetListType(prop.i)
	SetListType(ListType.l)
	GetNoLineNumber(prop.i)
	SetNoLineNumber(NoLineNumber.l)
	GetPageBreakBefore(prop.i)
	SetPageBreakBefore(PageBreakBefore.l)
	GetRightIndent(prop.i)
	SetRightIndent(RightIndent.f)
	SetIndents(First.f, Left.f, Right.f)
	SetLineSpacing(Rule.l, Spacing.f)
	GetSpaceAfter(prop.i)
	SetSpaceAfter(SpaceAfter.f)
	GetSpaceBefore(prop.i)
	SetSpaceBefore(SpaceBefore.f)
	GetWidowControl(prop.i)
	SetWidowControl(WidowControl.l)
	GetTabCount(prop.i)
	AddTab(tbPos.f, tbAlign.l, tbLeader.l)
	ClearAllTabs()
	DeleteTab(tbPos.f)
	GetTab(iTab.l, ptbPos.i, ptbAlign.i, ptbLeader.i)
EndInterface 
;
Procedure TOM_PrintErrorMessage(result)
  If result <> #S_OK
    Select Result
      Case #E_INVALIDARG: Debug ("E_INVALIDARG- Invalid argument")
      Case #E_ACCESSDENIED:  Debug ("E_ACCESSDENIED - write access denied")
      Case #E_OUTOFMEMORY:   Debug ("E_OUTOFMEMORY - out of memory")
      Case #CO_E_RELEASED:   Debug ("CO_E_RELEASED - The paragraph formatting object is attached to a range that has been deleted.")
      Default: Debug "Some other error occurred"
    EndSelect
  Else
    Debug "No error"
  EndIf
EndProcedure
;
Procedure TOM_GetTextFontObj(GadgetID, StartPos, EndPos, Duplicate = #TomFalse)
  ;
  ; This procedure sets up a 'TextFont' interface for the 'GadgetID' gadget.
  ;
  ; It returns an ITextFont object that can be:
  ; - The ITextFont of the character range StartPos->EndPos, if Duplicate = #TomFalse
  ; - A copy of this ITextFont, if Duplicate = #TomTrue
  ;
  ; This ITextFont object should be cleaned up after use by calling: *TextFontObject\Release().
  ;
  ; Example of usage:
  ;
  ; We will copy the styles from the tenth character contained in the gadget:
  ; *TextFontObjet.ITextFont = TOM_GetTextFontObj(EGadget, 10, 11, #TomTrue)
  ; We apply the same styles to the character range from 20 to 26:
  ; TOM_ApplyTextFont(EGadget, 20, 27, *TextFontObjet)
  ; Then we free the memory:
  ; *TextFontObjet\Release()
  ;
  ; The last parameter of this procedure ('Duplicate') allows obtaining
  ; an active ITextFont object (when Duplicate = #TomFalse), with which you
  ; can later play to modify the style of the text corresponding
  ; to the provided character range. As long as this ITextFont object
  ; is not deleted by *TextFontObjet\Release(), it continues to reflect
  ; the style changes made to the corresponding range, and it can be used
  ; to modify these styles.
  ; If Duplicate = #TomTrue, the obtained ITextFont object is just a snapshot
  ; taken at a given moment. If you modify its content (with *TextFontObjet\Reset(),
  ; for example), it does not affect the character range that was used to create it.
  ; However, you can use TOM_ApplyTextFont() to reapply this set of
  ; styles to any character range.
  ;
  Protected RichEditOleObject.IRichEditOle
  Protected *pTextDocument.ITextDocument
  Protected *pTextRange.ITextRange
  Protected *pTextFont.ITextFont_Fixed
  Protected *DTextFont.ITextFont_Fixed
  Protected Result = #S_FALSE ; Valeur de retour.
                                 ;
  SendMessage_(GadgetID(GadgetID), #EM_GETOLEINTERFACE, 0, @RichEditOleObject)

  If RichEditOleObject
    RichEditOleObject\QueryInterface(?IID_ITextDocument2, @*pTextDocument)
    RichEditOleObject\Release()
    ;
    ; Get the ITextRange:
    If *pTextDocument\Range(StartPos, EndPos, @*pTextRange) = #S_OK
      ; Get the ITextFont:
      If *pTextRange\GetFont(@*pTextFont) = #S_OK And *pTextFont
        If Duplicate = #TomTrue
          *pTextFont\GetDuplicate(@*DTextFont)
          Result = *DTextFont
          *pTextFont\Release()
        Else
          Result = *pTextFont
        EndIf
      EndIf
      *pTextRange\Release()
    EndIf
    *pTextDocument\Release()
  EndIf
  ProcedureReturn Result
EndProcedure
;
Procedure TOM_GetTextParaObj(GadgetID, StartPos, EndPos, Duplicate = #TomFalse)
  ;
  ; This procedure sets up a 'TextPara' interface for the 'GadgetID' gadget.
  ;
  ; It returns an ITextPara object that can be:
  ; - The ITextPara of the character range StartPos->EndPos, if Duplicate = #TomFalse
  ; - A copy of this ITextPara, if Duplicate = #TomTrue
  ;
  ; This ITextPara object should be cleaned up after use by calling: *TextParaObject\Release().
  ;
  ; Example of usage:
  ;
  ; We will copy the paragraph styles from the tenth character contained in the gadget:
  ; *TextParaObjet.ITextPara_Fixed = TOM_GetTextParaObj(EGadget, 10, 11, #TomTrue)
  ; We apply the same styles to the character range from 20 to 26:
  ; TOM_ApplyParaFont(EGadget, 20, 27, *TextFontObjet)
  ; Then we free the memory:
  ; *TextParaObjet\Release()
  ;
  ; Refer to the notes of 'TOM_GetTextFontObj()' for more details on the usage
  ; of the 'Duplicate' parameter.
  ;
  Protected RichEditOleObject.IRichEditOle
  Protected *pTextDocument.ITextDocument
  Protected *pTextRange.ITextRange
  Protected *pTextPara.ITextPara_Fixed
  Protected *DTextPara.ITextPara_Fixed
  Protected Result = #S_FALSE ; Valeur de retour.
                                 ;
  SendMessage_(GadgetID(GadgetID), #EM_GETOLEINTERFACE, 0, @RichEditOleObject)

  If RichEditOleObject
    RichEditOleObject\QueryInterface(?IID_ITextDocument2, @*pTextDocument)
    RichEditOleObject\Release()
    ;
    ; Get the ITextRange:
    If *pTextDocument\Range(StartPos, EndPos, @*pTextRange) = #S_OK
      ; Get the ITextPara:
      If *pTextRange\GetPara(@*pTextPara) = #S_OK And *pTextPara
        If Duplicate = #TomTrue
          *pTextPara\GetDuplicate(@*DTextPara)
          Result = *DTextPara
          *pTextPara\Release()
        Else
          Result = *pTextPara
        EndIf
      EndIf
      *pTextRange\Release()
    EndIf
    *pTextDocument\Release()
  EndIf
  ProcedureReturn Result
EndProcedure
;
Procedure TOM_ApplyTextFont(GadgetID, StartPos, EndPos, *pTextFont.ITextFont_Fixed)
  ;
  ; This procedure applies to a text range defined by StartPos->EndPos
  ; the set of styles contained in the '*pTextFont' object.
  ;
  ; Example of usage:
  ;
  ; We will copy the styles from the tenth character contained in the 'GadgetID' gadget:
  ; *TextFontObjet.ITextFont_Fixed = TOM_GetTextFontObj(EGadget, 10, 11, #TomTrue)
  ; We apply the same styles to the character range from 20 to 26:
  ; TOM_ApplyTextFont(EGadget, 20, 27, *TextFontObjet)
  ; 
  ; Then we free the memory:
  ; *TextFontObjet\Release()
  ;
  Protected RichEditOleObject.IRichEditOle
  Protected *pTextDocument.ITextDocument
  Protected *pTextRange.ITextRange
  Protected Result = #S_FALSE ; Return value
  ;
  SendMessage_(GadgetID(GadgetID), #EM_GETOLEINTERFACE, 0, @RichEditOleObject)
  If RichEditOleObject
    RichEditOleObject\QueryInterface(?IID_ITextDocument2, @*pTextDocument)
    RichEditOleObject\Release()
    ;
    ; Get the ITextRange:
    If *pTextDocument\Range(StartPos, EndPos, @*pTextRange) = #S_OK
      ; Apply:
      Result = *pTextRange\SetFont(*pTextFont)
      *pTextRange\Release()
    EndIf
    *pTextDocument\Release()
  EndIf
  ProcedureReturn Result
EndProcedure
;
Procedure TOM_ApplyTextPara(GadgetID, StartPos, EndPos, *pTextPara.ITextPara_Fixed)
  ;
  ; This procedure applies to a text range defined by StartPos->EndPos
  ; the set of paragraph styles contained in the '*pTextPara' object.
  ;
  ; Example of usage:
  ;
  ; We will copy the paragraph styles from the tenth character contained in the 'GadgetID' gadget:
  ; *TextParaObjet.ITextPara_Fixed = TOM_GetTextParaObj(EGadget, 10, 11, #TomTrue)
  ; We apply the same styles to the character range from 20 to 26:
  ; TOM_ApplyTextPara(EGadget, 20, 27, *TextParaObjet)
  ; 
  ; Then we free the memory:
  ; *TextParaObjet\Release()
  ;
  Protected RichEditOleObject.IRichEditOle
  Protected *pTextDocument.ITextDocument
  Protected *pTextRange.ITextRange
  Protected Result = #S_FALSE ; Return value
  ;
  SendMessage_(GadgetID(GadgetID), #EM_GETOLEINTERFACE, 0, @RichEditOleObject)
  If RichEditOleObject
    RichEditOleObject\QueryInterface(?IID_ITextDocument2, @*pTextDocument)
    RichEditOleObject\Release()
    ;
    ; Get the ITextRange:
    If *pTextDocument\Range(StartPos, EndPos, @*pTextRange) = #S_OK
      ; Apply:
      Result = *pTextRange\SetPara(*pTextPara)
      *pTextRange\Release()
    EndIf
    *pTextDocument\Release()
  EndIf
  ProcedureReturn Result
EndProcedure
;
Procedure.s TOM_ExtractParameter(Style$, ParameterName$)
  ;
  ; This procedure, used by 'TOM_SetFontStyles()'
  ; retrieves the parameter in parenthesis that follows 'ParameterName$'
  ; in the 'Style$' string.
  ;
  Protected pa, pas, limp
  ;
  pa = FindString(Style$, ParameterName$,1)
  If pa
    pa + Len(ParameterName$)
    If PeekC(@Style$ + (pa - 1) * SizeOf(CHARACTER)) = Asc("(")
      pa + 1
    EndIf
    If PeekC(@Style$ + (pa - 2) * SizeOf(CHARACTER)) <> Asc("(")
      MessageRequester("Error", "Error with 'TOM_SetFontStyles':  No parenthesis after " + ParameterName$ + Chr(13) + Style$)
      ProcedureReturn
    Else
      pas = pa
      limp = Len(Style$)
      While pa <= limp And PeekC(@Style$ + (pa - 1) * SizeOf(CHARACTER)) <> Asc(")")
        pa + 1
      Wend
      ProcedureReturn PeekS(@Style$ + (pas - 1) * SizeOf(CHARACTER), pa - pas)
    EndIf
  Else
    MessageRequester("Error", "Error with 'TOM_SetFontStyles':  Wrong parameter name -> " + ParameterName$ + Chr(13) + Style$)
  EndIf
EndProcedure
;
Procedure TOM_SetFontStyles(GadgetID, StartPos, EndPos, Style$, SetUnset = #TomTrue)
  ;
  ; This procedure applies various styles to the text range
  ; defined by StartPos->EndPos.
  ; GadgetID must be the gadget number of an EditorGadget containing text.
  ;
  ; Example content for the 'Style$' string:
  ; "Bold, Italic, BackColor($F08050)"
  ; -> will apply bold-italic to the text range with the background color $F08050.
  ; 
  ; 'SetUnset' can be omitted or can contain : #TomTrue, #TomFalse or #TomDefault
  ; With '#TomTrue', the commands contained by 'Style$' will be applied to the text range.
  ; With '#TomDefault', the text range will be set to default values, wathever the values
  ; evenually specified in parenthesis.
  ; With '#TomFalse', all the precise specified styles will be set to defaut values.
  ; For exemples:
  ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Bold")
  ; -> Range is set to bold
  ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Bold", #TomDefault)
  ; -> Range is set to bold if default style is bold or non-bold if default style is non-bold
  ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Bold", #TomFalse)
  ; -> Range is set to non-bold
  ;
    ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Size(12.5)")
  ; -> Range is set to size 12.5 pts
  ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Size()", #TomDefault) or TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Size(xxx)", #TomDefault)
  ; -> Range is set to default size.
  ; TOM_SetFontStyles(GadgetID, StartPos, EndPos, "Size(12.5)", #TomFalse)
  ; -> Only the characters having a size of 12.5 into the range will be set to default size.
  ;
  ; 'Style$' can contain some of the following commands (separated by comma):
  ; Bold, Italic, Emboss, AllCaps, SmallCaps, Engrave, Shadow, OutLine, Underline(value),
  ; StrikeThrough, Hidden, Protected, Size(value.f), Spacing(value.f), Position(value.f), Kerning(value.f),
  ; BackColor(value), ForeColor(value), Weight(value), Style(value), Name(value).
  ;
  ; The possible values for Underline are:

  ; Underline(Single)
  ; Underline(Words)
  ; Underline(Double)
  ; Underline(Dotted)
  ; Underline(Dash)
  ; Underline(DashDot)
  ; Underline(DashDotDot)
  ; Underline(Wave)
  ; Underline(Thick)
  ; Underline(Hair)
  ; Underline(DoubleWave)
  ; Underline(HeavyWave)
  ; Underline(LongDash)
  ; Underline(ThickDash)
  ; Underline(ThickDashDot)
  ; Underline(ThickDashDotDot)
  ; Underline(ThickDotted)
  ; Underline(ThickLongDash)
  ;  
  Protected *pTextFont.ITextFont_Fixed
  Protected *pFontDefault.ITextFont_Fixed
  Protected pl.l = 0, gpl.l = 0
  Protected pf.f = 0
  Protected ps.s = "", BSTRString = 0
  Protected parameter$
  ;
  ; To simplify the parsing of the parameter string,
  ; the spaces it contains are removed.
  While FindString(Style$, " ", 1)
    Style$ = ReplaceString(Style$, " ", "")
  Wend
  Style$ = LCase(Style$)
  ;
  ; Get first a TextFontObj copy for the range:
  *pFontDefault = TOM_GetTextFontObj(GadgetID, StartPos, EndPos, #TomTrue)
  ; Set the copy's styles to default:
  *pFontDefault\Reset(#TomDefault)
  ; Now, get an active TextFontObj for the range:
  *pTextFont = TOM_GetTextFontObj(GadgetID, StartPos, EndPos)
  If *pTextFont
    If FindString(Style$, "bold")
      If SetUnset = #TomDefault
        *pFontDefault\GetBold(@pl)
        *pTextFont\SetBold(pl)
      Else
        *pTextFont\SetBold(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "italic")
      If SetUnset = #TomDefault
        *pFontDefault\GetItalic(@pl)
        *pTextFont\SetItalic(pl)
      Else
        *pTextFont\SetItalic(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "emboss")
      If SetUnset = #TomDefault
        *pFontDefault\GetEmboss(@pl)
        *pTextFont\SetEmboss(pl)
      Else
        *pTextFont\SetEmboss(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "allcaps")
      If SetUnset = #TomDefault
        *pFontDefault\GetAllCaps(@pl)
        *pTextFont\SetAllCaps(pl)
      Else
        *pTextFont\SetAllCaps(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "smallcaps")
      *pTextFont\SetSmallCaps(SetUnset)
    EndIf
    If FindString(Style$, "engrave")
      If SetUnset = #TomDefault
        *pFontDefault\GetEngrave(@pl)
        *pTextFont\SetEngrave(pl)
      Else
        *pTextFont\SetEngrave(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "shadow")
      If SetUnset = #TomDefault
        *pFontDefault\GetShadow(@pl)
        *pTextFont\SetShadow(pl)
      Else
        *pTextFont\SetShadow(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "outline")
      If SetUnset = #TomDefault
        *pFontDefault\GetOutline(@pl)
        *pTextFont\SetOutline(pl)
      Else
        *pTextFont\SetOutline(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "underline(")
      parameter$ = TOM_ExtractParameter(Style$, "underline(")
      If parameter$ = "none"
        pl = #TomNone
      ElseIf parameter$ = "words"
        pl = #TomWords
      ElseIf parameter$ = "double"
        pl = #TomDouble
      ElseIf parameter$ = "dotted"
        pl = #TomDotted
      ElseIf parameter$ = "dash"
        pl = #TomDash
      ElseIf parameter$ = "dashdot"
        pl = #TomDashDot
      ElseIf parameter$ = "dashdotdot"
        pl = #TomDashDotDot
      ElseIf parameter$ = "wave"
        pl = #TomWave
      ElseIf parameter$ = "thick"
        pl = #TomThick
      ElseIf parameter$ = "hair"
        pl = #TomHair
      ElseIf parameter$ = "doublewave"
        pl = #TomDoubleWave
      ElseIf parameter$ = "heavywave"
        pl = #TomHeavyWave
      ElseIf parameter$ = "longdash"
        pl = #TomLongDash
      ElseIf parameter$ = "thickdash"
        pl = #TomThickDash
      ElseIf parameter$ = "thickdashdot"
        pl = #TomThickDashDot
      ElseIf parameter$ = "thickdashdotdot"
        pl = #TomThickDashDotDot
      ElseIf parameter$ = "thickdotted"
        pl = #TomThickDotted
      ElseIf parameter$ = "thicklongdash"
        pl = #TomThickLongDash
      Else
        pl = #TomSingle
      EndIf

      If SetUnset = #TomDefault
        *pFontDefault\GetUnderline(@pl)
        *pTextFont\SetUnderline(pl)
      ElseIf SetUnset = #TomTrue
        *pTextFont\SetUnderline(pl)
      Else
        *pTextFont\GetUnderline(@gpl)
        If gpl = pl Or parameter$ = ""
          *pTextFont\SetUnderline(#TomNone)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "strikethrough")
      If SetUnset = #TomDefault
        *pFontDefault\GetStrikeThrough(@pl)
        *pTextFont\SetStrikeThrough(pl)
      Else
        *pTextFont\SetStrikeThrough(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "subscript")
      If SetUnset = #TomDefault
        *pFontDefault\GetSubscript(@pl)
        *pTextFont\SetSubscript(pl)
      Else
        *pTextFont\SetSubscript(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "superscript")
      If SetUnset = #TomDefault
        *pFontDefault\GetSuperscript(@pl)
        *pTextFont\SetSuperscript(pl)
      Else
        *pTextFont\SetSuperscript(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "hidden")
      If SetUnset = #TomDefault
        *pFontDefault\GetHidden(@pl)
        *pTextFont\SetHidden(pl)
      Else
        *pTextFont\SetHidden(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "protected")
      If SetUnset = #TomDefault
        *pFontDefault\GetProtected(@pl)
        *pTextFont\SetProtected(pl)
      Else
        *pTextFont\SetProtected(SetUnset)
      EndIf
    EndIf
    If FindString(Style$, "size(")
      parameter$ = TOM_ExtractParameter(Style$, "size(")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextFont\SetSize(pf)
      Else
        *pTextFont\GetSize(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetSize(@pf)
          *pTextFont\SetSize(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "spacing(")
      parameter$ = TOM_ExtractParameter(Style$, "spacing(")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextFont\SetSpacing(pf)
      Else
        *pTextFont\GetSpacing(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetSpacing(@pf)
          *pTextFont\SetSpacing(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "position(")
      parameter$ = TOM_ExtractParameter(Style$, "position(")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextFont\SetPosition(pf)
      Else
        *pTextFont\GetPosition(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetPosition(@pf)
          *pTextFont\SetPosition(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "kerning(")
      parameter$ = TOM_ExtractParameter(Style$, "kerning(")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextFont\SetKerning(pf)
      Else
        *pTextFont\GetKerning(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetKerning(@pf)
          *pTextFont\SetKerning(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "backcolor(")
      parameter$ = TOM_ExtractParameter(Style$, "backcolor(")
      If SetUnset = #TomTrue
        *pTextFont\SetBackColor(Val(parameter$))
      Else
        *pTextFont\GetBackColor(@pl)
        If pl = Val(parameter$)
          *pFontDefault\GetBackColor(@pl)
          *pTextFont\SetBackColor(pl)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "forecolor(")
      parameter$ = TOM_ExtractParameter(Style$, "forecolor(")
      If SetUnset = #TomTrue
        *pTextFont\SetForeColor(Val(parameter$))
      Else
        *pTextFont\GetForeColor(@pl)
        If pl = Val(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetForeColor(@pl)
          *pTextFont\SetForeColor(pl)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "weight(")
      parameter$ = TOM_ExtractParameter(Style$, "weight(")
      If SetUnset = #TomTrue
        *pTextFont\SetWeight(Val(parameter$))
      Else
        *pTextFont\GetWeight(@pl)
        If pl = Val(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetWeight(@pl)
          *pTextFont\SetWeight(pl)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "style(")
      parameter$ = TOM_ExtractParameter(Style$, "style(")
      If SetUnset = #TomTrue
        *pTextFont\SetStyle(Val(parameter$))
      Else
        *pTextFont\GetStyle(@pl)
        If pl = Val(parameter$) Or SetUnset = #TomDefault
          *pFontDefault\GetStyle(@pl)
          *pTextFont\SetStyle(pl)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "name(")
      parameter$ = TOM_ExtractParameter(Style$, "name(")
      If SetUnset = #TomTrue
        *pTextFont\SetName(parameter$)
      Else
        *pTextFont\GetName(@BSTRString)
        ps = PeekS(BSTRString, -1, #PB_Unicode)
        SysFreeString_(BSTRString)
        If ps = parameter$ Or SetUnset = #TomDefault
          *pFontDefault\GetName(@BSTRString)
          ps = PeekS(BSTRString, -1, #PB_Unicode)
          SysFreeString_(BSTRString)
          *pTextFont\SetName(ps)
        ElseIf parameter$ = ""
          *pTextFont\SetName("")
        EndIf
      EndIf
    EndIf
    *pTextFont\Release()
  EndIf
EndProcedure
;
Procedure TOM_SetParaStyles(GadgetID, StartPos, EndPos, Style$, SetUnset = #TomTrue)
  ;
  ; This procedure applies various paragraphe styles to the text range
  ; defined by StartPos->EndPos.
  ; GadgetID must be the gadget number of an EditorGadget containing text.
  ;
  ; Example content for the 'Style$' string:
  ; "Align(left), FirstLineIndent(20)"
  ; 
  ; Explanations for the use of last parameter ('SetUnset') can be found
  ; into the code of procedure TOM_SetFontStyles()'.
  ;
  ; 'Style$' can contain some of the following commands (separated by comma):
  ; Align(value), SpaceBefore(Value.f), SpaceAfter(Value.f)
  ; RightIndent(value.f), LeftIndent(value.f), FirstLineIndent(value.f)
  ; Style(value), LineSpacing(SpacingRule, value.f)
  ;
  ; For LineSpacing, the SpacingRule value can contain:
  ; "Single", "1pt5", "Double", "AtLeast", "Exactly", "Multiple" or "Percent"
  ; The second parameter is unused with "Single", "1pt5" and "Double".
  
  Protected *pTextPara.ITextPara_Fixed
  Protected *pParaDefault.ITextPara_Fixed
  Protected pl.l = 0, gpl.l
  Protected pf.f = 0, pf1.f = 0, pf2.f = 0, pf3.f = 0
  Protected ps.s = "", BSTRString = 0
  Protected parameter$, param1$, param2$
  ;
  ; To simplify the parsing of the parameter string,
  ; the spaces it contains are removed.
  While FindString(Style$, " ",1)
    Style$ = ReplaceString(Style$, " ", "")
  Wend
  Style$ = LCase(Style$)
  ;
  ; Get first a TextParaObj copy for the range:
  *pParaDefault.ITextPara_Fixed = TOM_GetTextParaObj(GadgetID, StartPos, EndPos, #TomTrue)
  ; Set the copy's styles to default:
  *pParaDefault\Reset(#TomDefault)
  ; Now, get an active TextParaObj for the range:
  *pTextPara.ITextPara_Fixed = TOM_GetTextParaObj(GadgetID, StartPos, EndPos)
  If *pTextPara
    If FindString(Style$, "align(")
      If FindString(Style$, "align(left")
        pl = #TomAlignLeft
      ElseIf FindString(Style$, "align(center")
        pl = #TomAlignCenter
      ElseIf FindString(Style$, "align(right")
        pl = #TomAlignRight
      ElseIf FindString(Style$, "align(justify")
        pl = #TomAlignJustify
      ElseIf FindString(Style$, "align(decimal")
        pl = #TomAlignDecimal
      ElseIf FindString(Style$, "align(bar")
        pl = #TomAlignBar
      ElseIf FindString(Style$, "align(interword")
        pl = #TomAlignInterWord
      ElseIf FindString(Style$, "align(newspaper")
        pl = #TomAlignNewspaper
      ElseIf FindString(Style$, "align(interletter")
        pl = #TomAlignInterLetter
      ElseIf FindString(Style$, "align(scaled")
        pl = #TomAlignScaled
      EndIf
      If SetUnset = #TomTrue
        *pTextPara\SetAlignment(pl)
      Else
        *pTextPara\GetAlignment(@gpl)
        If gpl = pl Or SetUnset = #TomDefault
          *pParaDefault\GetAlignment(@pl)
          *pTextPara\SetAlignment(pl)
        EndIf
      EndIf
    EndIf
    ;
    If FindString(Style$, "rightindent")
      parameter$ = TOM_ExtractParameter(Style$, "rightindent")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextPara\SetRightIndent(pf)
      Else
        *pTextPara\GetRightIndent(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetRightIndent(@pf)
          *pTextPara\SetRightIndent(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "leftindent")
      parameter$ = TOM_ExtractParameter(Style$, "leftindent")
      If SetUnset = #TomTrue
        pf2.f = ValF(parameter$)
        *pTextPara\GetFirstLineIndent(@pf1)
        *pTextPara\GetRightIndent(@pf3)
        *pTextPara\SetIndents(pf1, pf2, pf3)
      Else
        *pTextPara\GetLeftIndent(@pf2)
        If pf2 = ValF(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetLeftIndent(@pf2)
          *pTextPara\GetFirstLineIndent(@pf1)
          *pTextPara\GetRightIndent(@pf3)
          *pTextPara\SetIndents(pf1, pf2, pf3)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "firstlineindent")
      parameter$ = TOM_ExtractParameter(Style$, "firstlineindent")
      If SetUnset = #TomTrue
        pf1.f = ValF(parameter$)
        *pTextPara\GetLeftIndent(@pf2)
        *pTextPara\GetRightIndent(@pf3)
        *pTextPara\SetIndents(pf1, pf2, pf3)
      Else
        *pTextPara\GetFirstLineIndent(@pf1)
        If pf1 = ValF(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetFirstLineIndent(@pf1)
          *pTextPara\GetLeftIndent(@pf2)
          *pTextPara\GetRightIndent(@pf3)
          *pTextPara\SetIndents(pf1, pf2, pf3)
        EndIf
      EndIf
    EndIf
    ;
    If FindString(Style$, "spacebefore")
      parameter$ = TOM_ExtractParameter(Style$, "spacebefore")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextPara\SetSpaceBefore(pf)
      Else
        *pTextPara\GetSpaceBefore(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetSpaceBefore(@pf)
          *pTextPara\SetSpaceBefore(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "spaceafter")
      parameter$ = TOM_ExtractParameter(Style$, "spaceafter")
      If SetUnset = #TomTrue
        pf.f = ValF(parameter$)
        *pTextPara\SetSpaceAfter(pf)
      Else
        *pTextPara\GetSpaceAfter(@pf)
        If pf = ValF(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetSpaceAfter(@pf)
          *pTextPara\SetSpaceAfter(pf)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "style",1)
      parameter$ = TOM_ExtractParameter(Style$, "style")
      If SetUnset = #TomTrue
        *pTextPara\SetStyle(Val(parameter$))
      Else
        *pTextPara\GetStyle(@pl)
        If pl = Val(parameter$) Or SetUnset = #TomDefault
          *pParaDefault\GetStyle(@pl)
          *pTextPara\SetStyle(pl)
        EndIf
      EndIf
    EndIf
    If FindString(Style$, "linespacing")
      parameter$ = TOM_ExtractParameter(Style$, "linespacing")
      param1$ = StringField(parameter$,1,",")
      param2$ = StringField(parameter$,2,",")
      If param1$ = "single"
        pl = #TomLineSpaceSingle
      ElseIf param1$ = "1pt5"
        pl = #TomLineSpace1pt5
      ElseIf param1$ = "double"
        pl = #TomLineSpaceDouble
      ElseIf param1$ = "atleast"
        pl = #TomLineSpaceAtLeast
      ElseIf param1$ = "exactly"
        pl = #TomLineSpaceExactly
      ElseIf param1$ = "multiple"
        pl = #TomLineSpaceMultiple
      ElseIf param1$ = "percent"
        pl = #TomLineSpacePercent
      EndIf
      If SetUnset = #TomTrue
        pf.f = ValF(param2$)
        *pTextPara\SetLineSpacing(pl, pf)
      Else
        *pTextPara\GetLineSpacing(@pf)
        *pTextPara\GetLineSpacingRule(gpl)
        If (pf = ValF(param2$) And gpl = pl) Or SetUnset = #TomDefault
          *pParaDefault\GetLineSpacing(@pf)
          *pParaDefault\GetLineSpacingRule(@pl)
          *pTextPara\SetLineSpacing(pf, pl)
        EndIf
      EndIf
    EndIf
    *pTextPara\Release()
  EndIf
EndProcedure
;
Procedure.s TOM_GetFontStyles(GadgetID, StartPos, EndPos)
  ;
  ; GadgetID must be the number of an EditorGadget.
  ; This procedure examines the styles of the text range
  ; defined by StartPos->EndPos and returns a descriptive
  ; string.
  ;  
  Protected *pTextFont.ITextFont_Fixed
  ;
  Protected pl.l = 0
  Protected pf.f = 0
  Protected ps.s = "", BSTRString = 0
  ;
  Protected Style$ = "" ; Return value.
  ;
  ; Get a TextFont object for the range:
  *pTextFont = TOM_GetTextFontObj(GadgetID, StartPos, EndPos)
  ;
  If *pTextFont
    *pTextFont\GetBold(@pl)
    If pl = #TomTrue
      Style$ + "Bold, "
    EndIf
    *pTextFont\GetItalic(@pl)
    If pl = #TomTrue
      Style$ + "Italic, "
    EndIf
    *pTextFont\GetEmboss(@pl)
    If pl = #TomTrue
      Style$ + "Emboss, "
    EndIf
    *pTextFont\GetAllCaps(@pl)
    If pl = #TomTrue
      Style$ + "AllCaps, "
    EndIf
    *pTextFont\GetSmallCaps(@pl)
    If pl = #TomTrue
      Style$ + "SmallCaps, "
    EndIf
    *pTextFont\GetEngrave(@pl)
    If pl = #TomTrue
      Style$ + "Engrave, "
    EndIf
    *pTextFont\GetShadow(@pl)
    If pl = #TomTrue
      Style$ + "Shadow, "
    EndIf
    *pTextFont\GetOutline(@pl)
    If pl = #TomTrue
      Style$ + "OutLine, "
    EndIf
    *pTextFont\GetUnderline(@pl)
    If pl = #TomSingle
      Style$ + "Underline(Single), "
    ElseIf pl = #TomWords
      Style$ + "Underline(Words), "
    ElseIf pl = #TomDouble
      Style$ + "Underline(Double), "
    ElseIf pl = #TomDotted
      Style$ + "Underline(Dotted), "
    ElseIf pl = #TomDash
      Style$ + "Underline(Dash), "
    ElseIf pl = #TomDashDot
      Style$ + "Underline(DashDot), "
    ElseIf pl = #TomDashDotDot
      Style$ + "Underline(DashDotDot), "
    ElseIf pl = #TomWave
      Style$ + "Underline(Wave), "
    ElseIf pl = #TomThick
      Style$ + "Underline(Thick), "
    ElseIf pl = #TomHair
      Style$ + "Underline(Hair), "
    ElseIf pl = #TomDoubleWave
      Style$ + "Underline(DoubleWave), "
    ElseIf pl = #TomHeavyWave
      Style$ + "Underline(HeavyWave), "
    ElseIf pl = #TomLongDash
      Style$ + "Underline(LongDash), "
    ElseIf pl = #TomThickDash
      Style$ + "Underline(ThickDash), "
    ElseIf pl = #TomThickDashDot
      Style$ + "Underline(ThickDashDot), "
    ElseIf pl = #TomThickDashDotDot
      Style$ + "Underline(ThickDashDotDot), "
    ElseIf pl = #TomThickDotted
      Style$ + "Underline(ThickDotted), "
    ElseIf pl = #TomThickLongDash
      Style$ + "Underline(ThickLongDash), "
    EndIf
    *pTextFont\GetStrikeThrough(@pl)
    If pl = #TomTrue
      Style$ + "StrikeThrough, "
    EndIf
    *pTextFont\GetSubscript(@pl)
    If pl = #TomTrue
      Style$ + "Subscript, "
    EndIf
    *pTextFont\GetSuperscript(@pl)
    If pl = #TomTrue
      Style$ + "Superscript, "
    EndIf
    *pTextFont\GetHidden(@pl)
    If pl = #TomTrue
      Style$ + "Hidden, "
    EndIf
    *pTextFont\GetProtected(@pl)
    If pl = #TomTrue
      Style$ + "Protected, "
    EndIf
    *pTextFont\GetSize(@pf)
    Style$ + "Size(" + StrF(pf) + "), "
    *pTextFont\GetSpacing(@pf)
    If pf
      Style$ + "Spacing(" + StrF(pf) + "), "
    EndIf
    *pTextFont\GetPosition(@pf)
    If pf
      Style$ + "Position(" + StrF(pf) + "), "
    EndIf
    *pTextFont\GetKerning(@pf)
    If pf
      Style$ + "Kerning(" + StrF(pf) + "), "
    EndIf
    *pTextFont\GetBackColor(@pl)
    If pl <> #TomAutoColor
      Style$ + "BackColor(" + Str(pl) + "), "
    EndIf
    *pTextFont\GetForeColor(@pl)
    If pl <> #TomAutoColor
      Style$ + "ForeColor(" + Str(pl) + "), "
    EndIf
    *pTextFont\GetWeight(@pl)
    If pl <> 400
      Style$ + "Weight(" + Str(pl) + "), "
    EndIf
    *pTextFont\GetStyle(@pl)
    If pl
      Style$ + "Style(" + Str(pl) + "), "
    EndIf
    *pTextFont\GetName(@BSTRString)
    ps = PeekS(BSTRString, -1, #PB_Unicode)
    SysFreeString_(BSTRString)
    Style$ + "Name(" + ps + ")"
    ;
    *pTextFont\Release()
  EndIf
  If Right(Style$, 2) = ", "
    Style$ = Left(Style$, Len(Style$) - 2)
  EndIf
  ProcedureReturn Style$
EndProcedure
;
Procedure.s TOM_GetParaStyles(GadgetID, StartPos, EndPos)
  ;
  ; GadgetID must be the number of an EditorGadget.
  ; This procedure examines the styles of the paragraphe(s)
  ; containing the text range defined by StartPos->EndPos
  ; and returns a descriptive string.
  ;  
  Protected *pTextPara.ITextPara_Fixed
  ;
  Protected pl.l = 0
  Protected pf.f = 0
  ;
  Protected Style$ = "" ; Return value.
  ;
  ; Get a TextPara object for the range:
  *pTextPara = TOM_GetTextParaObj(GadgetID, StartPos, EndPos)
  ;
  If *pTextPara
    *pTextPara\GetAlignment(@pl)
    ;
    If pl = #TomAlignLeft
      Style$ + "Align(Left), "
    ElseIf pl = #TomAlignCenter
      Style$ + "Align(Center), "
    ElseIf pl = #TomAlignRight
      Style$ + "Align(Right), "
    ElseIf pl = #TomAlignJustify
      Style$ + "Align(Justify), "
    ElseIf pl = #TomAlignBar
      Style$ + "Align(Bar), "
    ElseIf pl = #TomAlignInterLetter
      Style$ + "Align(InterLetter), "
    ElseIf pl = #TomAlignScaled
      Style$ + "Align(Scaled), "    
    EndIf
    ;
    *pTextPara\GetLeftIndent(@pf)
    If pf
      Style$ + "LeftIndent("+StrF(pf)+"), "
    EndIf
    *pTextPara\GetRightIndent(@pf)
    If pf
      Style$ + "RightIndent("+StrF(pf)+"), "
    EndIf
    *pTextPara\GetFirstLineIndent(@pf)
    If pf <> 0
      Style$ + "FirstLineIndent("+StrF(pf)+"), "
    EndIf
    ;
    *pTextPara\GetSpaceBefore(@pf)
    If pf
      Style$ + "SpaceBefore("+StrF(pf)+"), "
    EndIf
    *pTextPara\GetSpaceAfter(@pf)
    If pf
      Style$ + "SpaceAfter("+StrF(pf)+"), "
    EndIf
    ;
    *pTextPara\GetStyle(@pl)
    If pl <> -1
      Style$ + "Style("+Str(pl)+"), "
    EndIf
    ;
    *pTextPara\GetLineSpacingRule(@pl)
    *pTextPara\GetLineSpacing(@pf)
    If pl = #TomLineSpace1pt5
      Style$ + "LineSpacing(1pt5), "
    ElseIf pl = #TomLineSpaceDouble
      Style$ + "LineSpacing(Double), "
    ElseIf pl = #TomLineSpaceAtLeast
      Style$ + "LineSpacing(AtLeast,"+StrF(pf)+"), "
    ElseIf pl = #TomLineSpaceExactly
      Style$ + "LineSpacing(Exactly,"+StrF(pf)+"), "
    ElseIf pl = #TomLineSpaceMultiple
      Style$ + "LineSpacing(Multiple,"+StrF(pf)+"), "
    ElseIf pl = #TomLineSpacePercent
      Style$ + "LineSpacing(Percent,"+StrF(pf)+"), "
    EndIf
    ;
    *pTextPara\Release()
  EndIf
  If Right(Style$, 2) = ", "
    Style$ = Left(Style$, Len(Style$) - 2)
  EndIf
  ProcedureReturn Style$
EndProcedure
;
Procedure TOM_ComputeWordPosition(GadgetID, MyWord$, StartPos = 0)
  ; Look for the position of 'MyWord$' inside the gadget's content.
  ;
  Protected EditorText$, Result
  ;
  ; Get the gadget's content
  EditorText$ = GetGadgetText(GadgetID)
  ; An ajustment is necessary to be able to compute position from the text obtained,
  ; because The TOM system, as all other RichEdit interfaces, count only one
  ; character for the EndOfLine (Carriage return). But the text we have now has
  ; two characters for the EndOfLine: Chr(10) + Chr(13)    (CRLF).
  ; So, we delete Chr(10) to keep only the carriage return (one sole character).
  EditorText$ = ReplaceString(EditorText$, Chr(10), "")
  ; Now, the positions which we'll get from FindString will be compatible with
  ; our needs.
  Result = FindString(EditorText$, MyWord$, StartPos)
  ;
  ; The returned value is Result less one, because PureBasic attribute position '1' 
  ; to the first character, while Windows's functions attribute position '0' to it.
  ;
  ; We set the result to Windows needs:
  ProcedureReturn Result - 1
EndProcedure
;
Procedure TOM_SetGadgetAsRichEdit(GadgetID)
  SendMessage_(GadgetID(GadgetID), #EM_SETTEXTMODE, #TM_RICHTEXT, 0)
  SendMessage_(GadgetID(GadgetID), #EM_SETTARGETDEVICE, #Null, 0);<<--- Automatic carriage return.
  SendMessage_(GadgetID(GadgetID), #EM_LIMITTEXT, -1, 0)             ; Set unlimited content size.
EndProcedure
;
;
; Examples of use
If OpenWindow(0, 200, 200, 600, 400, "TOM Example")
  EGadget = EditorGadget(#PB_Any, 10, 10, 580, 300)
  TGadget = TextGadget(#PB_Any, 10, 320, 580, 70, "")
  ; TOM_SetFontStyles() works on any
  ; EditorGadget without any special configuration.
  ; However, TOM_SetParamStyles() requires that the
  ; gadget be set up as a RichEdit gadget:
  TOM_SetGadgetAsRichEdit(EGadget)
  ;
  ; Note that the TOM library can't be used with TextGadgets or StringGadgets.
  
  AddGadgetItem(EGadget, -1, "This is a sample text.")

  ; Apply styles (bold, italic, underline, size: 15, position on line: 4, Times font) to characters from 10 to 15
  TOM_SetFontStyles(EGadget, 10, 16, "Size(15), Bold, Italic, Underline(), Name(Times), position(4)")
  ;
  ; Apply Wave underline to characters from 0 to 4
  TOM_SetFontStyles(EGadget, 0, 5, "Underline(Wave)")
  ;
  ; Center first line:
  TOM_SetParaStyles(EGadget, 10, 16, "Align(Center)")
  ;
  ; Describe styles of character 11 :
  Info$ = "Character 11: " + TOM_GetFontStyles(EGadget, 11, 12) + Chr(13)
  ; Describe styles of character 3:
  Info$ + "Character 3: " + TOM_GetFontStyles(EGadget, 3, 4) + Chr(13)
  ;
  ; Copy style from character 10:
  *TextFontObjet.ITextFont_Fixed = TOM_GetTextFontObj(EGadget, 10, 11, #TomTrue)
  ; Apply this style to characters from 18 to 19:
  TOM_ApplyTextFont(EGadget, 18, 20, *TextFontObjet)
  ; Free memory:
  *TextFontObjet\Release()
  ;
  ; Unset styles applied to character 18:
  TOM_SetFontStyles(EGadget, 15, 16, "Size(15), Bold, Italic, Underline(), Name(Times), position(4)", #TomFalse)
  
  AddGadgetItem(EGadget, -1, "")
  AddGadgetItem(EGadget, -1, "This is another sample text with more words to see other possibilities of setting for paragraphe, including FirstLineIndent for this one.")
  TOM_SetFontStyles(EGadget, 132, 148, "ForeColor($0000D0), Bold")
  TOM_SetParaStyles(EGadget, 132, 148, "Align(Left), FirstLineIndent(10)")
  ;
  AddGadgetItem(EGadget, -1, "")
  AddGadgetItem(EGadget, -1, "This is another sample text with more words to see other possibilities of setting for paragraphe, including LeftIndent for this one.")
  TOM_SetFontStyles(EGadget, 270, 282, "ForeColor($0000D0), Bold")
  TOM_SetParaStyles(EGadget, 270, 282, "FirstLineIndent(0), LeftIndent(10)")
  ;
  AddGadgetItem(EGadget, -1, "This is another sample text with more words to see other possibilities of setting for paragraphe, including RightIndent, Justify, LineSpacing and SpaceBefore for this one. Qui sommes-nous ? Quelle est notre essence, notre véritable identité ? Ces questions nous préoccupent depuis toujours.")
  TOM_SetFontStyles(EGadget, 404, 417, "ForeColor($DE7723), Bold")
  TOM_SetParaStyles(EGadget, 404, 417, "LeftIndent(0), RightIndent(40), Align(Justify), LineSpacing(exactly,16), SpaceBefore(3)")
  ;
    ; Describe styles of paragraphe including character 404:
  Info$ + "Character 400: " + TOM_GetParaStyles(EGadget, 400, 401) + Chr(13)
  ;
  ; If you’re as bored as I am, calculating the character positions to determine which range to apply styles to,
  ; you can do it this way:
  StartPos = TOM_ComputeWordPosition(EGadget, "Justify")
  EndPos = StartPos + Len("justify")
  TOM_SetFontStyles(EGadget, StartPos, EndPos, "BackColor($00D0D0), Bold")
  StartPos = TOM_ComputeWordPosition(EGadget, "LineSpacing", StartPos)
  EndPos = StartPos + Len("LineSpacing")
  TOM_SetFontStyles(EGadget, StartPos, EndPos, "ForeColor($0000D0), Bold")
  StartPos = TOM_ComputeWordPosition(EGadget, "SpaceBefore", StartPos)
  EndPos = StartPos + Len("SpaceBefore")
  TOM_SetFontStyles(EGadget, StartPos, EndPos, "ForeColor($0000D0), Bold")
  ;
  SetGadgetText(TGadget, Info$)
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf


DataSection
  IID_ITextDocument2:
  Data.l $01C25500
  Data.w $4268, $11D1
  Data.b $88, $3A, $3C, $8B, $00, $C1, $00, $00
EndDataSection

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = -------------------------
; EnableXP
; DPIAware