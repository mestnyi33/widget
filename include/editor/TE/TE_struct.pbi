;- TE_COLORSCHEME
Structure TE_COLORSCHEME
  defaultTextColor.i
  selectedTextColor.i
  cursor.i
  inactiveBackground.i
  currentBackground.i
  selectionBackground.i
  currentLine.i
  currentLineBackground.i
  inactiveLineBackground.i
  indentationGuides.i
  repeatedSelections.i
  lineNr.i
  currentLineNr.i
  lineNrBackground.i
  foldIcon.i
  foldIconBorder.i
  foldIconBackground.i
EndStructure

;- TE_TEXTSTYLE
Structure TE_TEXTSTYLE
  fColor.i
  bColor.i
  fontNr.i
  underlined.i
EndStructure

;- TE_TOKEN
Structure TE_TOKEN
  type.b
  charNr.l
  *text.Character
  size.l
EndStructure

;- TE_FONT
Structure TE_FONT
  name.s
  nr.i
  id.i
  size.i
  height.i
  style.i
  Array width.i(#TE_CharRange)
EndStructure

;- TE_PARSER
Structure TE_PARSER
  *textline.TE_TEXTLINE
  *token.TE_TOKEN
  Array tokenType.c(#TE_CharRange)
  lineNr.i
  tokenIndex.i
  state.i
EndStructure

;- TE_SYNTAX
Structure TE_SYNTAX
  keyword.s
  flags.i
  Map before.TE_SYNTAX()
  Map after.TE_SYNTAX()
EndStructure

;- TE_KEYWORD
Structure TE_KEYWORD
  name.s
  style.b
  foldState.b
  indentationBefore.b
  indentationAfter.b
  caseCorrection.b
EndStructure

;- TE_KEYWORDITEM
Structure TE_KEYWORDITEM
  name.s
  length.i
EndStructure

;- TE_INDENTATIONPOS
Structure TE_INDENTATIONPOS
  *textLine.TE_TEXTLINE
  charNr.i
EndStructure

;- TE_POSITION
Structure TE_POSITION
  *textline.TE_TEXTLINE
  lineNr.i
  visibleLineNr.i
  charNr.i
  charX.i
  currentX.i
  width.i
EndStructure

;- TE_RANGE
Structure TE_RANGE
  pos1.TE_POSITION
  pos2.TE_POSITION
EndStructure

;- TE_CURSORSTATE
Structure TE_CURSORSTATE
  overwrite.i
  compareMode.i
  
  blinkDelay.i
  blinkSuspend.i
  blinkState.i
  
  buttons.i
  modifiers.i
  
  clickSpeed.i				; in Event_Mouse
  clickCount.i        ; in Event_Mouse:	used to detect 'double/tripple/... -click'
  firstClickTime.i    ; in Event_Mouse
  firstClickX.i       ; in Event_Mouse:	first x-position of the mouse
  firstClickY.i       ; in Event_Mouse:	first y-position of the mouse
  firstSelection.TE_RANGE		; in Event_Mouse:	first selection
  lastSelection.TE_RANGE
  lastPosition.TE_POSITION	; in Event_Mouse:	previous position
  
  state.i
  dragStart.i
  dragText.s
  dragTextPreview.s
  dragPosition.TE_POSITION
  
  mouseX.i					; mouse Position inside Canvas
  mouseY.i
  windowMouseX.i				; mouse Position inside Window
  windowMouseY.i
  desktopMouseX.i				; mouse Position inside Desktop
  desktopMouseY.i
  deltaX.i					; mouse movement
  deltaY.i
EndStructure

;- TE_CURSOR
Structure TE_CURSOR
  firstPosition.TE_POSITION
  lastPosition.TE_POSITION
  position.TE_POSITION
  
  lastSelection.TE_POSITION
  selection.TE_POSITION
  
  visible.i
  number.i
EndStructure

;- TE_SCROLL
Structure TE_SCROLL
  visibleLineNr.i
  charX.i
  scrollTime.i
  scrollDelay.i
  autoScroll.i				; activated, when the mouse is in upper or lower canvas position
EndStructure

;- TE_SCROLLBAR
Structure TE_SCROLLBAR
  gadget.i
  enabled.i
  isHidden.i
  scale.d
EndStructure

;- TE_FIND
Structure TE_FIND
  wnd_findReplace.i
  cmb_search.i
  txt_search.i
  chk_replace.i
  cmb_replace.i
  frm_0.i
  chk_caseSensitive.i
  chk_wholeWords.i
  chk_insideSelection.i
  chk_noComments.i
  chk_noStrings.i
  chk_regEx.i
  btn_findNext.i
  btn_findPrevious.i
  btn_replace.i
  btn_replaceAll.i
  btn_close.i
  
  text.s
  replace.s
  replaceCount.i
  flags.i
  startPos.TE_POSITION
  endPos.TE_POSITION
  
  regEx.i
  
  isVisible.i
EndStructure

;- TE_AUTOCOMPLETE
Structure TE_AUTOCOMPLETE
  window.i    ;  wnd_autocomplete.i
  gadget.i    ;  lst_listBox.i
  
  font.TE_FONT
  
  minCharacterCount.i
  maxRows.i
  
  isVisible.i
  enabled.i
  
  mode.i
EndStructure

;- TE_UNDOENTRY
Structure TE_UNDOENTRY
  action.b
  startPos.TE_POSITION
  endPos.TE_POSITION
  text.s
EndStructure

;- TE_UNDO
Structure TE_UNDO
  List entry.TE_UNDOENTRY()
  
  start.i
  index.i
  clearRedo.i
EndStructure

;- TE_SYNTAXHIGHLIGHT
Structure TE_SYNTAXHIGHLIGHT
  style.i
  *textline.TE_TEXTLINE
  startCharNr.i
  EndCharNr.i
EndStructure

;- TE_TEXTBLOCK
Structure TE_TEXTBLOCK
  firstVisibleLineNr.i
  firstLineNr.i
  firstCharNr.i
  lastVisibleLineNr.i
  lastLineNr.i
  lastCharNr.i
  *firstLine.TE_TEXTLINE
  *lastLine.TE_TEXTLINE
EndStructure

;- TE_TEXTLINE
Structure TE_TEXTLINE
  text.s
  textWidth.d
  
  Array style.b(0)
  Array syntaxHighlight.b(0)
  Array token.TE_TOKEN(0)
  
  tokenCount.i
  
  foldState.b				; #TE_Folding_Folded		start of textblock (folded)
                    ; #TE_Folding_Unfolded		start of textblock (unfolded)
                    ; #TE_Folding_End			end of textblock
  foldCount.l
  foldSum.l
  
  indentationBefore.b
  indentationAfter.b
  
  needRedraw.b
  needStyling.b
  marker.b
EndStructure

;- TE_VIEW
Structure TE_VIEW
  *editor.TE_STRUCT
  canvas.i
  
  x.i
  y.i
  width.i
  height.i
  zoom.d
  
  pageHeight.i
  pageWidth.i
  
  firstVisibleLineNr.i
  lastVisibleLineNr.i
  
  scroll.TE_SCROLL
  
  scrollBarH.TE_SCROLLBAR
  scrollBarV.TE_SCROLLBAR
  
  *parent.TE_VIEW
  *child.TE_VIEW[2]
EndStructure

;- TE_LANGUAGE
Structure TE_LANGUAGE
  fileName.s
  
  errorTitle.s
  errorRegEx.s
  errorNotFound.s
  
  warningTitle.s
  warningLongText.s
  
  gotoTitle.s
  gotoMessage.s
  
  messageTitleFindReplace.s
  messageNoMoreMatches.s
  messageNoMoreMatchesStart.s
  messageNoMoreMatchesEnd.s
  messageReplaceComplete.s
EndStructure

;- TE_STRUCT
Structure TE_STRUCT
  *view.TE_VIEW
  *currentView.TE_VIEW
  
  List textLine.TE_TEXTLINE()
  List textBlock.TE_TEXTBLOCK()
  List syntaxHighlight.TE_SYNTAXHIGHLIGHT()
  List lineHistory.i()
  
  Map keyWord.TE_KEYWORD()
  Map keyWordLineContinuation.s()
  Map autoCompleteList.s()
  Map syntax.TE_SYNTAX()
  
  Array font.TE_FONT(8)
  fontName.s
  
  laguage.TE_LANGUAGE
  
  x.i
  y.i
  width.i
  height.i
  
  lineHeight.i
  
  parser.TE_PARSER
  
  visibleLineCount.i
  
  window.i
  popupMenu.i
  autocomplete.TE_AUTOCOMPLETE
  
  maxLineWidth.i
  maxTextWidth.i
  
  scrollbarWidth.i
  leftBorderOffset.i
  leftBorderSize.i
  topBorderSize.i
  
  cursorState.TE_CURSORSTATE
  List cursor.TE_CURSOR()
  *currentCursor.TE_CURSOR
  *maincursor.TE_CURSOR
  
  undo.TE_UNDO
  redo.TE_UNDO
  
  find.TE_FIND
  
  needScrollUpdate.i
  needFoldUpdate.i
  redrawMode.i
  
  highlightSyntax.i
  highlightSelection.s
  highlightMode.i
  
  Array textStyle.TE_TEXTSTYLE(255)
  
  indentationMode.i
  
  useRealTab.i
  tabSize.i
  
  commentChar.s
  uncommentChar.s
  
  newLineText.s
  newLineChar.c
  
  colors.TE_COLORSCHEME
  
  enableScrollBarHorizontal.b
  enableScrollBarVertical.b
  enableStyling.b
  enableLineNumbers.b
  enableShowCurrentLine.b
  enableFolding.b
  enableIndentation.b
  enableCaseCorrection.b
  enableIndentationLines.b
  enableShowWhiteSpace.b
  enableAutoComplete.b
  enableDictionary.b
  enableSyntaxCheck.b
  enableBeautify.b
  enableMultiCursor.b
  enableSplitScreen.b
  enableSelectPastedText.b
  enableHighlightSelection.b
EndStructure

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -----
; EnableXP