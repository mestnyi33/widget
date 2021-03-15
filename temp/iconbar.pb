; +---------------+-------+
; | IconBarGadget | kenmo |
; +---------------+-------+
; | 2014.07.31 @ Version 1.0 released
; | 2014.08.01 @ Version 1.1 released
; | 2016.05.02 @ Version 1.2 released


;-
;- [ IconBarGadget Include ]

CompilerIf (#PB_Compiler_IsMainFile)
  EnableExplicit
CompilerEndIf








;-
;- Constants - PUBLIC

; Include version
#IconBar_Version = 120

; Display Modes
#IconBarDisplay_ImageOnly    = $00
#IconBarDisplay_TextOnly     = $01
#IconBarDisplay_ImageAndText = $02

; Return Values
#IconBarReturn_ItemNumber = $00
#IconBarReturn_Position   = $01
#IconBarReturn_UserData   = $02

; Text Types
#IconBarText_Label   = $00
#IconBarText_ToolTip = $01

; Gadget attributes which can be written and read
#IconBar_BackgroundColor = $00000001
#IconBar_TextColor       = $00000002
#IconBar_DividerColor    = $00000004
#IconBar_HighlightColor  = $00000008
#IconBar_Margin          = $00000100
#IconBar_Padding         = $00000200
#IconBar_Spacing         = $00000400
#IconBar_Radius          = $00000800
#IconBar_DisplayMode     = $00001000
#IconBar_ReturnValue     = $00002000
#IconBar_MouseOverEvents = $00004000
#IconBar_PopupMenu       = $00010000
#IconBar_FontID          = $00020000
#IconBar_UserData        = $00040000
#IconBar_LatchItem       = $00080000
#IconBar_LatchColor      = $00100000

; Color Constant aliases
#IconBarColor_Background = #IconBar_BackgroundColor
#IconBarColor_Text       = #IconBar_TextColor
#IconBarColor_Divider    = #IconBar_DividerColor
#IconBarColor_Highlight  = #IconBar_HighlightColor
#IconBarColor_Latch      = #IconBar_LatchColor

; Gadget attributes which are read-only
#IconBar_Width     = $01000000
#IconBar_Height    = $02000000
#IconBar_FitWidth  = $04000000
#IconBar_FitHeight = $08000000

; Common constants
#IconBar_First   =  0
#IconBar_Last    = -1
#IconBar_None    = -1
#IconBar_All     = -2
#IconBar_Invalid = -1
#IconBar_Default = -1
#IconBar_Toggle  = -2
#IconBar_Ignore  = #PB_Ignore
#IconBar_Auto    = #PB_Ignore - 1


; Custom events
Enumeration
  #IconBarEventType_MouseOver = #PB_EventType_FirstCustomValue
  ;
  #IconBarEventType_LeftClick = #PB_EventType_LeftClick
EndEnumeration










;-
;- Constants - PRIVATE

; IconBarItem Types
#_IconBar_Item    = $00
#_IconBar_Divider = $01
#_IconBar_Spacer  = $02

; IconBar States
#_IconBar_Hovering = $00
#_IconBar_Clicking = $01

; IconBar Flags
#_IconBar_Locked   = $0001
#_IconBar_Disabled = $0002
#_IconBar_Hidden   = $0004
#_IconBar_SizeLock = $0008

; IconBar EventType Flags
#_IconBar_MouseOver = $010000

; Compile Switches
#_IconBar_UseWinAPIText = Bool((#PB_Compiler_OS = #PB_OS_Windows) And (#True))













;-
;- Structures - PRIVATE

Structure _ICONBARITEM
  Type.i
  ItemNumber.i
  UserData.i
  MenuID.i
  Flags.i
  ;
  Text.s
  Tip.s
  Lines.i
  TextWidth.i
  Image.i
  ImgWidth.i
  ImgHeight.i
  ;
  x.i
  y.i
  Width.i
  Height.i
EndStructure

Structure _ICONBAR
  Canvas.i
  Window.i
  Flags.i
  FontID.i
  UserData.i
  ReturnValue.i
  Popup.i
  ;
  ColorBack.i
  ColorText.i
  ColorDiv.i
  ColorHigh.i
  ColorFade.i
  ColorClick.i
  ColorTextDis.i
  ColorLatch.i
  ;
  Margin.i
  Padding.i
  Spacing.i
  Radius.i
  DisplayMode.i
  ;
  ViewWidth.i
  ViewHeight.i
  IdealWidth.i
  IdealHeight.i
  UsedWidth.i
  UsedHeight.i
  TextHeight.i
  MaxImgWidth.i
  MaxImgHeight.i
  MaxTextWidth.i
  MaxTextHeight.i
  ;
  NumPositions.i
  NumItems.i
  List Pos._ICONBARITEM()
  ;
  State.i
  HoverItem.i
  ClickItem.i
  LatchItem.i
EndStructure











;-
;- Macros - PRIVATE

Macro _IBGMax(Variable, Value)
  If ((Variable) < (Value))
    Variable = (Value)
  EndIf
EndMacro

CompilerIf (#_IconBar_UseWinAPIText)
  Procedure _IBGText(_did.i, _x.i, _y.i, _Text.s, _Fore.i, _Back.i)
    Protected _Rect.RECT
    _Rect\left   = _x
    _Rect\top    = _y
    _Rect\right  = OutputWidth()
    _Rect\bottom = OutputHeight()
    SetTextColor_(_did, _Fore)
    SetBkColor_(_did, _Back)
    DrawText_(_did, _Text, -1, @_Rect, #DT_SINGLELINE | #DT_NOPREFIX)
  EndProcedure
CompilerElse
  Macro _IBGText(_did, _x, _y, _Text, _Fore, _Back)
    DrawText((_x), (_y), (_Text), (_Fore), (_Back))
  EndMacro
CompilerEndIf











;-
;- Macros - PUBLIC

; Get the version of this IncludeFile (100 = Version 1.00)
Macro IconBarGadgetVersion()
  (#IconBar_Version)
EndMacro
Macro IconBarGadgetVersionString()
  StrF(#IconBar_Version * 0.01, 1)
EndMacro

; Size an IconBarGadget to show (position not affected)
Macro AutoSizeIconBarGadget(IB)
  ResizeIconBarGadget((IB), #IconBar_Auto, #IconBar_Auto)
EndMacro

; Set the margin (empty pixels between buttons and gadget border)
Macro SetIconBarGadgetMargin(IB, Size = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_Margin, (Size))
EndMacro

; Set the button padding (pixels between
Macro SetIconBarGadgetPadding(IB, Size = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_Padding, (Size))
EndMacro

; Set the button spacing (empty pixels between buttons and dividers)
Macro SetIconBarGadgetSpacing(IB, Size = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_Spacing, (Size))
EndMacro

; Set the highlight corner radius (0 = no rounded corners)
Macro SetIconBarGadgetRadius(IB, Size = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_Radius, (Size))
EndMacro

; Set the Display Mode (see constants)
Macro SetIconBarGadgetDisplayMode(IB, Mode = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_DisplayMode, (Mode))
EndMacro

; Set the Return Value mode (see constants)
Macro SetIconBarGadgetReturnValue(IB, ReturnValue = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_ReturnValue, (ReturnValue))
EndMacro

; Specify a PB popup menu to automatically appear on right-clicks
Macro SetIconBarGadgetPopupMenu(IB, Menu = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_PopupMenu, (Menu))
EndMacro

; Specify a custom font by its FontID (not its PB font number)
Macro SetIconBarGadgetFontID(IB, FontID = #IconBar_Default)
  SetIconBarGadgetAttribute((IB), #IconBar_FontID, (FontID))
EndMacro

; Specify a latched item by its item number (not its position number)
Macro SetIconBarGadgetLatchItem(IB, ItemNumber = #IconBar_None)
  SetIconBarGadgetAttribute((IB), #IconBar_LatchItem, (ItemNumber))
EndMacro

; Attribute read macros:

Macro GetIconBarGadgetMargin(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Margin)
EndMacro

Macro GetIconBarGadgetPadding(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Padding)
EndMacro

Macro GetIconBarGadgetSpacing(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Spacing)
EndMacro

Macro GetIconBarGadgetRadius(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Radius)
EndMacro

Macro GetIconBarGadgetDisplayMode(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_DisplayMode)
EndMacro

Macro GetIconBarGadgetReturnValue(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_ReturnValue)
EndMacro

Macro GetIconBarGadgetPopupMenu(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_PopupMenu)
EndMacro

Macro GetIconBarGadgetFontID(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_FontID)
EndMacro

Macro GetIconBarGadgetLatchItem(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_LatchItem)
EndMacro

Macro IconBarGadgetWidth(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Width)
EndMacro

Macro IconBarGadgetHeight(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_Height)
EndMacro

Macro IconBarGadgetFitWidth(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_FitWidth)
EndMacro

Macro IconBarGadgetFitHeight(IB)
  GetIconBarGadgetAttribute((IB), #IconBar_FitHeight)
EndMacro














;-
;- Procedures - PRIVATE

Procedure _FormatIconBarGadgetText(*IB._ICONBAR, *IBI._ICONBARITEM)
  *IBI\Text  = ReplaceString(*IBI\Text, #TAB$,  " " )
  *IBI\Text  = ReplaceString(*IBI\Text, #CRLF$, #LF$)
  *IBI\Text  = ReplaceString(*IBI\Text, #CR$,   #LF$)
  *IBI\Lines = CountString(*IBI\Text, #LF$) + 1
  *IBI\Tip   = ReplaceString(*IBI\Tip, #LF$, " ")
  If (StartDrawing(CanvasOutput(*IB\Canvas)))
    DrawingFont(*IB\FontID)
    If (*IBI\Lines = 1)
      *IBI\Text      = Trim(*IBI\Text)
      *IBI\TextWidth = TextWidth(*IBI\Text)
    Else
      Protected Build.s
      Protected Line.s
      Protected i.i
      *IBI\TextWidth = 0
      For i = 1 To *IBI\Lines
        Line = Trim(StringField(*IBI\Text, i, #LF$))
        _IBGMax(*IBI\TextWidth, TextWidth(Line))
        Build + #LF$ + Line
      Next
      *IBI\Text = Mid(Build, 2)
    EndIf
    StopDrawing()
  EndIf
EndProcedure

Procedure _RedrawIconBarGadget(*IB._ICONBAR, Force.i = #False)
  If (*IB And *IB\Canvas)
    If ((Not (*IB\Flags & (#_IconBar_Locked | #_IconBar_Hidden))) Or Force)
      Protected DrawingID.i = StartDrawing(CanvasOutput(*IB\Canvas))
      If (DrawingID)
        Box(0, 0, OutputWidth(), OutputHeight(), *IB\ColorBack)
        If (*IB\NumPositions)
          CompilerIf (#_IconBar_UseWinAPIText)
            SelectObject_(DrawingID, *IB\FontID)
          CompilerEndIf
          DrawingFont(*IB\FontID)
          ForEach (*IB\Pos())
            With *IB\Pos()
              If (\Type = #_IconBar_Divider)
                Box(\x + *IB\Padding, \y + *IB\Padding, \Width - 2 * *IB\Padding, \Height - 2 * *IB\Padding, *IB\ColorDiv)
              EndIf
            EndWith
          Next
          Protected ImageAlpha.i, TextColor.i
          ForEach (*IB\Pos())
            If ((*IB\Flags & #_IconBar_Disabled) Or (*IB\Pos()\Flags & #_IconBar_Disabled))
              ImageAlpha =  128
              TextColor  = *IB\ColorTextDis
            Else
              ImageAlpha =  255
              TextColor  = *IB\ColorText
            EndIf
            With *IB\Pos()
              If (\Type = #_IconBar_Item)
                Protected Border.i = #False
                Protected Shade.i  = #False
                Protected Back.i   = *IB\ColorBack
                If (*IB\Pos()\ItemNumber = *IB\LatchItem)
                  Shade = #True
                  Back  = *IB\ColorLatch
                ElseIf (*IB\State = #_IconBar_Hovering)
                  If (*IB\HoverItem = ListIndex(*IB\Pos()))
                    Back = *IB\ColorFade
                    Border = #True
                  EndIf
                ElseIf (*IB\State = #_IconBar_Clicking)
                  If ((*IB\HoverItem = *IB\ClickItem) And (*IB\HoverItem = ListIndex(*IB\Pos())))
                    Back = *IB\ColorClick
                    Border = #True
                  EndIf
                EndIf
                If (Shade)
                  Box(\x, \y, \Width, \Height, Back)
                EndIf
                If (Border)
                  If (*IB\Radius > 0)
                    RoundBox(\x, \y, \Width, \Height, *IB\Radius, *IB\Radius, Back)
                  Else
                    Box(\x, \y, \Width, \Height, Back)
                  EndIf
                EndIf
                If (*IB\DisplayMode <> #IconBarDisplay_TextOnly)
                  If (\Image <> #IconBar_None)
                    DrawAlphaImage(ImageID(\Image), \x + (\Width - \ImgWidth)/2, \y + *IB\Padding + (*IB\MaxImgHeight - \ImgHeight)/2, ImageAlpha)
                  EndIf
                EndIf
                If (*IB\DisplayMode <> #IconBarDisplay_ImageOnly)
                  If (*IB\Pos()\Lines = 1)
                    _IBGText(DrawingID, \x + (\Width - \TextWidth)/2, \y + *IB\Padding + *IB\MaxImgHeight + (*IB\MaxTextHeight - *IB\TextHeight)/2, \Text, TextColor, Back)
                  Else
                    Protected i.i
                    For i = 1 To \Lines
                      Protected LineText.s = StringField(\Text, i, #LF$)
                      _IBGText(DrawingID, \x + (\Width - TextWidth(LineText))/2, \y + *IB\Padding + *IB\MaxImgHeight + (*IB\MaxTextHeight - (*IB\TextHeight * \Lines))/2 + (i-1) * *IB\TextHeight, LineText, TextColor, Back)
                    Next i
                  EndIf
                EndIf
                If (Border)
                  DrawingMode(#PB_2DDrawing_Outlined)
                  If (*IB\Radius > 0)
                    RoundBox(\x, \y, \Width, \Height, *IB\Radius, *IB\Radius, *IB\ColorHigh)
                  Else
                    Box(\x, \y, \Width, \Height, *IB\ColorHigh)
                  EndIf
                  DrawingMode(#PB_2DDrawing_Default)
                EndIf
              EndIf
            EndWith
          Next
        EndIf
        StopDrawing()
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure _UpdateIconBarGadget(*IB._ICONBAR, Redraw.i = #False)
  If (*IB And *IB\Canvas)
    *IB\ViewWidth  = GadgetWidth(*IB\Canvas)
    *IB\ViewHeight = GadgetHeight(*IB\Canvas)
   
    If (*IB\TextHeight <= 0)
      If (StartDrawing(CanvasOutput(*IB\Canvas)))
        DrawingFont(*IB\FontID)
        *IB\TextHeight = TextHeight("ABC123")
        StopDrawing()
      EndIf
    EndIf
   
    *IB\IdealWidth  = 0
    *IB\IdealHeight = 0
    *IB\UsedWidth   = 0
    *IB\UsedHeight  = 0
   
    *IB\MaxImgWidth  = 0
    *IB\MaxImgHeight = 0
    *IB\MaxTextWidth   = 0
    *IB\MaxTextHeight  = 0
   
    Protected ItemWidth.i
    Protected ItemHeight.i
    Protected SpacingToAdd.i
    Protected NumSpacers.i = 0
    ForEach (*IB\Pos())
      If (ListIndex(*IB\Pos()) >= 1)
        SpacingToAdd = *IB\Spacing
      Else
        SpacingToAdd = 0
      EndIf
      Select (*IB\Pos()\Type)
       
        Case #_IconBar_Item
          ItemWidth = 0
          If (*IB\DisplayMode = #IconBarDisplay_ImageOnly)
            ItemHeight = *IB\TextHeight
          Else
            ItemHeight = *IB\TextHeight * *IB\Pos()\Lines
          EndIf
          Select (*IB\DisplayMode)
           
            Case #IconBarDisplay_ImageOnly
              _IBGMax(*IB\MaxImgWidth,  *IB\Pos()\ImgWidth)
              _IBGMax(*IB\MaxImgHeight, *IB\Pos()\ImgHeight)
              _IBGMax(ItemWidth,  *IB\Pos()\ImgWidth)
              _IBGMax(ItemHeight, *IB\Pos()\ImgHeight)
           
            Case #IconBarDisplay_ImageAndText
              _IBGMax(*IB\MaxTextWidth,   *IB\Pos()\TextWidth)
              _IBGMax(*IB\MaxTextHeight,  ItemHeight)
              _IBGMax(*IB\MaxImgWidth,  *IB\Pos()\ImgWidth)
              _IBGMax(*IB\MaxImgHeight, *IB\Pos()\ImgHeight)
              _IBGMax(ItemWidth, *IB\Pos()\ImgWidth)
              _IBGMax(ItemWidth, *IB\Pos()\TextWidth)
              ItemHeight + *IB\Pos()\ImgHeight
           
            Case #IconBarDisplay_TextOnly
              _IBGMax(*IB\MaxTextWidth,  *IB\Pos()\TextWidth)
              _IBGMax(*IB\MaxTextHeight, ItemHeight)
              ItemWidth = *IB\Pos()\TextWidth
             
          EndSelect
          ItemWidth + *IB\Padding * 2
       
        Case #_IconBar_Divider
          ItemWidth  = 1 + *IB\Padding * 2
          ItemHeight = *IB\TextHeight
       
        Case #_IconBar_Spacer
          If (*IB\Pos()\TextWidth = #IconBar_Default)
            NumSpacers + 1
            ItemWidth  = 0
          Else
            ItemWidth = *IB\Pos()\TextWidth
          EndIf
          ItemHeight = *IB\TextHeight
          SpacingToAdd = 0
         
      EndSelect
      ItemHeight + *IB\Padding * 2
      If (Not (*IB\Flags & #_IconBar_SizeLock))
        *IB\Pos()\Width  = ItemWidth
        *IB\Pos()\Height = ItemHeight
      EndIf
      *IB\IdealWidth    + ItemWidth + SpacingToAdd
      _IBGMax(*IB\IdealHeight, ItemHeight)
    Next
   
    *IB\IdealWidth  + (*IB\Margin * 2)
    *IB\IdealHeight + (*IB\Margin * 2)
    Protected FreeSpace.i = *IB\ViewWidth - *IB\IdealWidth
   
    *IB\UsedWidth  = *IB\Margin * 2
    *IB\UsedHeight = *IB\IdealHeight
    Protected x.i = *IB\Margin
    Protected y.i = *IB\Margin
    ForEach (*IB\Pos())
      *IB\Pos()\x = x
      *IB\Pos()\y = y
      If (Not (*IB\Flags & #_IconBar_SizeLock))
        *IB\Pos()\Height = *IB\IdealHeight - (*IB\Margin * 2)
      EndIf
      If (*IB\Pos()\Type = #_IconBar_Spacer)
        If (ListIndex(*IB\Pos()) >= 1)
          x - *IB\Spacing
          *IB\Pos()\x - *IB\Spacing
        EndIf
        If ((*IB\Pos()\TextWidth = #IconBar_Default) And (FreeSpace > 0))
          *IB\Pos()\Width = FreeSpace / NumSpacers
          FreeSpace  - *IB\Pos()\Width
          NumSpacers - 1
        EndIf
        *IB\UsedWidth + *IB\Pos()\Width
      Else
        *IB\UsedWidth + *IB\Pos()\Width
      EndIf
      x + *IB\Pos()\Width + *IB\Spacing
    Next
   
    If (Redraw)
      _RedrawIconBarGadget(*IB)
    EndIf
  EndIf
EndProcedure

Procedure _CalculateIconBarGadgetColors(*IB._ICONBAR)
  If (*IB And *IB\Canvas)
    Protected R.i, G.i, B.i
    R = Red(*IB\ColorHigh)   * 0.2 + Red(*IB\ColorBack)   * 0.8
    G = Green(*IB\ColorHigh) * 0.2 + Green(*IB\ColorBack) * 0.8
    B = Blue(*IB\ColorHigh)  * 0.2 + Blue(*IB\ColorBack)  * 0.8
    *IB\ColorFade = RGB(R, G, B)
   
    R = Red(*IB\ColorHigh)   * 0.3 + Red(*IB\ColorBack)   * 0.7
    G = Green(*IB\ColorHigh) * 0.3 + Green(*IB\ColorBack) * 0.7
    B = Blue(*IB\ColorHigh)  * 0.3 + Blue(*IB\ColorBack)  * 0.7
    *IB\ColorClick = RGB(R, G, B)
   
    If (#True)
      R = Red(*IB\ColorText)   * 0.4 + Red(*IB\ColorBack)   * 0.6
      R + Green(*IB\ColorText) * 0.4 + Green(*IB\ColorBack) * 0.6
      R + Blue(*IB\ColorText)  * 0.4 + Blue(*IB\ColorBack)  * 0.6
      R = R / 3
      G = R
      B = R
    Else
      R = Red(*IB\ColorText)   * 0.4 + Red(*IB\ColorBack)   * 0.6
      G = Green(*IB\ColorText) * 0.4 + Green(*IB\ColorBack) * 0.6
      B = Blue(*IB\ColorText)  * 0.4 + Blue(*IB\ColorBack)  * 0.6
    EndIf
    *IB\ColorTextDis = RGB(R, G, B)
  EndIf
EndProcedure

Procedure.i _CountIconBarGadgetItems(*IB._ICONBAR)
  Protected Result.i = 0
  If (*IB)
    ForEach (*IB\Pos())
      Select (*IB\Pos()\Type)
        Case #_IconBar_Item
          *IB\Pos()\ItemNumber = Result
          Result + 1
        Default
          *IB\Pos()\ItemNumber = #IconBar_Invalid
      EndSelect
    Next
    *IB\NumItems = Result
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i _GetIconBarGadgetDefault(Attribute.i)
  Protected Result.i = #Null
 
  Select (Attribute)
   
    Case (#IconBar_FontID)
      CompilerIf (#PB_Compiler_OS = #PB_OS_MacOS)
        Static DefaultFont.i = #Null
        If (DefaultFont = #Null)
          Protected TempGadget.i = TextGadget(#PB_Any, 0, 0, 0, 0, "")
          If (TempGadget)
            DefaultFont = GetGadgetFont(TempGadget)
            FreeGadget(TempGadget)
          EndIf
        EndIf
        Result = DefaultFont
      CompilerElse
        Result = GetGadgetFont(#PB_Default)
      CompilerEndIf
   
    Case (#IconBar_BackgroundColor)
      CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
        Result = GetSysColor_(#COLOR_MENU)
      CompilerElse
        Result = $EDEDED
      CompilerEndIf
    Case (#IconBar_TextColor)
      CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
        Result = GetSysColor_(#COLOR_MENUTEXT)
      CompilerElse
        Result = $000000
      CompilerEndIf
    Case (#IconBar_DividerColor)
      CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
        Result = GetSysColor_(#COLOR_3DSHADOW)
      CompilerElse
        Result = $A0A0A0
      CompilerEndIf
    Case (#IconBar_HighlightColor)
      CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
        Result = GetSysColor_(#COLOR_MENUHILIGHT)
      CompilerElse
        Result = $FF8000
      CompilerEndIf
    Case (#IconBar_LatchColor)
      CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
        Result = GetSysColor_(#COLOR_3DLIGHT)
      CompilerElse
        Result = $F8F8F8
      CompilerEndIf
   
    Case (#IconBar_Margin)
      Result = 2
    Case (#IconBar_Padding)
      Result = 3
    Case (#IconBar_Spacing)
      Result = 0
    Case (#IconBar_Radius)
      Result = 0
    Case (#IconBar_DisplayMode)
      Result = #IconBarDisplay_ImageOnly
    Case (#IconBar_ReturnValue)
      Result = #IconBarReturn_ItemNumber
    Case (#IconBar_MouseOverEvents)
      Result = #False
     
    Case (#IconBar_PopupMenu)
      Result = #IconBar_None
    Case (#IconBar_UserData)
      Result = #Null
     
  EndSelect
 
  ProcedureReturn (Result)
EndProcedure

Procedure _IconBarGadgetCallback()
  Protected *IB._ICONBAR = GetGadgetData(EventGadget())
  If (*IB And *IB\Canvas)
    Protected PreHover.i = *IB\HoverItem
    Protected Redraw.i   = #False
    Protected Tip.s = ""
    Select (EventType())
   
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter
        If (*IB\NumPositions And (Not *IB\Flags & (#_IconBar_Hidden | #_IconBar_Disabled)))
          Protected mx.i = GetGadgetAttribute(*IB\Canvas, #PB_Canvas_MouseX)
          Protected my.i = GetGadgetAttribute(*IB\Canvas, #PB_Canvas_MouseY)
          Protected Item.i = #IconBar_None
          ForEach (*IB\Pos())
            If (*IB\Pos()\Type = #_IconBar_Item)
              If (Not (*IB\Pos()\Flags & #_IconBar_Disabled))
                If (*IB\LatchItem <> *IB\Pos()\ItemNumber)
                  If ((mx >= *IB\Pos()\x) And (mx < *IB\Pos()\x + *IB\Pos()\Width))
                    If ((my >= *IB\Pos()\y) And (my < *IB\Pos()\y + *IB\Pos()\Height))
                      Item = ListIndex(*IB\Pos())
                      Tip  = *IB\Pos()\Tip
                      Break
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
          Next
          *IB\HoverItem = Item
        Else
          *IB\State     = #_IconBar_Hovering
          *IB\HoverItem = #IconBar_None
        EndIf
       
      Case #PB_EventType_MouseLeave
        *IB\State     = #_IconBar_Hovering
        *IB\HoverItem = #IconBar_None
        *IB\ClickItem = #IconBar_None
       
      Case #PB_EventType_LeftButtonDown
        If (Not (*IB\Flags & #_IconBar_Disabled))
          If ((*IB\State = #_IconBar_Hovering) And (*IB\HoverItem >= 0))
            *IB\State     = #_IconBar_Clicking
            *IB\ClickItem = *IB\HoverItem
            Redraw        = #True
          EndIf
        EndIf
       
      Case #PB_EventType_LeftButtonUp
        If (Not (*IB\Flags & #_IconBar_Disabled))
          Protected i.i = #IconBar_None
          If (*IB\State = #_IconBar_Clicking)
            If (*IB\HoverItem = *IB\ClickItem)
              i = *IB\ClickItem
              SelectElement(*IB\Pos(), *IB\ClickItem)
            EndIf
            Redraw = #True
          EndIf
          If (i >= 0)
            Select (*IB\ReturnValue)
              Case #IconBarReturn_Position
                ; i = i
              Case #IconBarReturn_UserData
                i = *IB\Pos()\UserData
              Default ; Case #IconBarReturn_ItemNumber
                i = *IB\Pos()\ItemNumber
            EndSelect
            PostEvent(#PB_Event_Gadget, *IB\Window, *IB, #IconBarEventType_LeftClick, i)
            If (*IB\Pos()\MenuID >= 0)
              PostEvent(#PB_Event_Menu, *IB\Window, *IB\Pos()\MenuID)
            EndIf
          EndIf
        EndIf
        *IB\State = #_IconBar_Hovering
       
      Case #PB_EventType_RightClick
        If (Not (*IB\Flags & #_IconBar_Disabled))
          If ((*IB\Popup <> #IconBar_None) And IsMenu(*IB\Popup))
            DisplayPopupMenu(*IB\Popup, WindowID(*IB\Window))
          EndIf
        EndIf
    EndSelect
   
    If (*IB\HoverItem <> PreHover)
      If (*IB\Flags & #_IconBar_MouseOver)
        If (*IB\HoverItem >= 0)
          SelectElement(*IB\Pos(), *IB\HoverItem)
          PostEvent(#PB_Event_Gadget, *IB\Window, *IB, #IconBarEventType_MouseOver, *IB\Pos()\ItemNumber)
        Else
          PostEvent(#PB_Event_Gadget, *IB\Window, *IB, #IconBarEventType_MouseOver, #IconBar_None)
        EndIf
      EndIf
      If (*IB\HoverItem >= 0)
        GadgetToolTip(*IB\Canvas, Tip)
      Else
        GadgetToolTip(*IB\Canvas, "")
      EndIf
      Redraw = #True
    EndIf
    If (Redraw)
      _RedrawIconBarGadget(*IB)
    EndIf
  EndIf
EndProcedure















;-
;-
;- Procedures - Public

; Convert an IconBar Item Number (zero-based - only includes clickable items)
; to a position index (zero-based - includes dividers and spacers)

Procedure.i IconBarPositionFromItemNumber(*IB._ICONBAR, ItemNumber.i)
  Protected Result.i = #IconBar_Invalid
  If (*IB)
    If (ItemNumber = #IconBar_Last)
      ItemNumber = *IB\NumItems - 1
    EndIf
    If ((ItemNumber >= 0) And (ItemNumber < *IB\NumItems))
      ForEach (*IB\Pos())
        If ((*IB\Pos()\ItemNumber = ItemNumber))
          Result = ListIndex(*IB\Pos())
          Break
        EndIf
      Next
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Convert an IconBar position index (zero-based - includes dividers and spacers)
; to an Item Number (zero-based - only includes clickable items)

Procedure.i IconBarItemNumberFromPosition(*IB._ICONBAR, Position.i)
  Protected Result.i = #IconBar_Invalid
  If (*IB)
    If (Position = #IconBar_Last)
      Position = *IB\NumPositions - 1
    EndIf
    If ((Position >= 0) And (Position < *IB\NumPositions))
      SelectElement(*IB\Pos(), Position)
      Result = *IB\Pos()\ItemNumber
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Resize an IconBar (you can use Ignore or Auto constants)
; or move the IconBar's position (you can use the Ignore constant)

Procedure.i ResizeIconBarGadget(*IB._ICONBAR, Width.i, Height.i, x.i = #IconBar_Ignore, y.i = #IconBar_Ignore)
  Protected Result.i = #IconBar_Invalid
 
  If (*IB And *IB\Canvas)
    If (Width = #IconBar_Auto)
      If (*IB\IdealWidth > 0)
        Width = *IB\IdealWidth
      Else
        Width = #PB_Ignore
      EndIf
    EndIf
    If (Height = #IconBar_Auto)
      If (*IB\IdealHeight > 0)
        Height = *IB\IdealHeight
      Else
        Height = #PB_Ignore
      EndIf
    EndIf
    ResizeGadget(*IB\Canvas, x, y, Width, Height)
    _UpdateIconBarGadget(*IB, #True)
    Result = *IB\ViewHeight
  EndIf
 
  ProcedureReturn (Result)
EndProcedure

; Hide an IconBar (True, False, or #IconBar_Toggle)
; Returns the new state

Procedure.i HideIconBarGadget(*IB._ICONBAR, State.i = #True)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (State = #IconBar_Toggle)
      State = Bool(Not (*IB\Flags & #_IconBar_Hidden))
    EndIf
    If (State And (Not (*IB\Flags & #_IconBar_Hidden)))
      HideGadget(*IB\Canvas, #True)
      *IB\Flags     | #_IconBar_Hidden
      *IB\State     = #_IconBar_Hovering
      *IB\HoverItem = #IconBar_None
    ElseIf ((Not State) And (*IB\Flags & #_IconBar_Hidden))
      HideGadget(*IB\Canvas, #False)
      *IB\Flags     & ~#_IconBar_Hidden
      *IB\State     = #_IconBar_Hovering
      *IB\HoverItem = #IconBar_None
      _RedrawIconBarGadget(*IB)
    EndIf
    Result = Bool(State)
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Lock IconBar redraw (True, False, or #IconBar_Toggle)
; Returns the new state

Procedure.i LockIconBarGadgetRedraw(*IB._ICONBAR, State.i = #True)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (State = #IconBar_Toggle)
      State = Bool(Not (*IB\Flags & #_IconBar_Locked))
    EndIf
    If (State And (Not (*IB\Flags & #_IconBar_Locked)))
      *IB\Flags | #_IconBar_Locked
    ElseIf ((Not State) And (*IB\Flags & #_IconBar_Locked))
      *IB\Flags & ~#_IconBar_Locked
      _RedrawIconBarGadget(*IB)
    EndIf
    Result = Bool(State)
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Lock IconBar item sizes (True, False, or #IconBar_Toggle)
; Returns the new state
; (Useful if you want to change Item text without changing the Item size)

Procedure.i LockIconBarGadgetSizes(*IB._ICONBAR, State.i = #True)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (State = #IconBar_Toggle)
      State = Bool(Not (*IB\Flags & #_IconBar_SizeLock))
    EndIf
    If (State And (Not (*IB\Flags & #_IconBar_SizeLock)))
      *IB\Flags | #_IconBar_SizeLock
    ElseIf ((Not State) And (*IB\Flags & #_IconBar_SizeLock))
      *IB\Flags & ~#_IconBar_SizeLock
      _UpdateIconBarGadget(*IB, #True)
    EndIf
    Result = Bool(State)
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Disable an IconBar (True, False, or #IconBar_Toggle)
; Returns the new state

Procedure.i DisableIconBarGadget(*IB._ICONBAR, State.i = #True)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (State = #IconBar_Toggle)
      State = Bool(Not (*IB\Flags & #_IconBar_Disabled))
    EndIf
    If (State And (Not (*IB\Flags & #_IconBar_Disabled)))
      *IB\Flags     | #_IconBar_Disabled
      *IB\State     = #_IconBar_Hovering
      *IB\HoverItem = #IconBar_None
      _RedrawIconBarGadget(*IB)
    ElseIf ((Not State) And (*IB\Flags & #_IconBar_Disabled))
       *IB\Flags    & ~#_IconBar_Disabled
      *IB\State     = #_IconBar_Hovering
      *IB\HoverItem = #IconBar_None
      _RedrawIconBarGadget(*IB)
    EndIf
    Result = Bool(State)
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Disable an individual IconBar item (True, False, or #IconBar_Toggle)
; Returns the new state
; You can also pass #IconBar_All as the ItemNumber

Procedure.i DisableIconBarGadgetItem(*IB._ICONBAR, ItemNumber.i, State.i = #True)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (ItemNumber = #IconBar_Last)
      ItemNumber = *IB\NumItems - 1
    EndIf
    Protected AllItems.i = Bool(ItemNumber = #IconBar_All)
    Protected Toggle.i   = Bool(State = #IconBar_Toggle)
    If (((ItemNumber >= 0) And (ItemNumber < *IB\NumItems)) Or AllItems)
      ForEach (*IB\Pos())
        If (*IB\Pos()\Type = #_IconBar_Item)
          If ((*IB\Pos()\ItemNumber = ItemNumber) Or AllItems)
            If (Toggle)
              State = Bool(Not (*IB\Pos()\Flags & #_IconBar_Disabled))
            EndIf
            If (State And (Not (*IB\Pos()\Flags & #_IconBar_Disabled)))
              *IB\Pos()\Flags | #_IconBar_Disabled
            ElseIf ((Not State) And (*IB\Pos()\Flags & #_IconBar_Disabled))
              *IB\Pos()\Flags & ~#_IconBar_Disabled
            EndIf
            Result = Bool(State)
            If (Not AllItems)
              Break
            EndIf
          EndIf
        EndIf
      Next
      _UpdateIconBarGadget(*IB, #True)
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Get an IconBar color

Procedure.i GetIconBarGadgetColor(*IB._ICONBAR, ColorType.i)
  Protected Result.i = #IconBar_Invalid
  If (*IB)
    Select (ColorType)
      Case #IconBar_BackgroundColor
        Result = *IB\ColorBack
      Case #IconBar_TextColor
        Result = *IB\ColorText
      Case #IconBar_DividerColor
        Result = *IB\ColorDiv
      Case #IconBar_HighlightColor
        Result = *IB\ColorHigh
      Case #IconBar_LatchColor
        Result = *IB\ColorLatch
    EndSelect
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Set an IconBar color or reset to default

Procedure SetIconBarGadgetColor(*IB._ICONBAR, ColorType.i, Color.i = #IconBar_Default)
  If (*IB)
    If (Color = #IconBar_Default)
      Color = _GetIconBarGadgetDefault(ColorType)
    EndIf
    If (Color >= 0)
      Protected NeedRedraw.i = #False
      Select (ColorType)
        Case #IconBar_BackgroundColor
          *IB\ColorBack = Color : NeedRedraw = #True
        Case #IconBar_TextColor
          *IB\ColorText = Color : NeedRedraw = #True
        Case #IconBar_DividerColor
          *IB\ColorDiv = Color : NeedRedraw = #True
        Case #IconBar_HighlightColor
          *IB\ColorHigh = Color : NeedRedraw = #True
        Case #IconBar_LatchColor
          *IB\ColorLatch = Color : NeedRedraw = Bool(*IB\LatchItem >= 0)
      EndSelect
      If (NeedRedraw)
        _CalculateIconBarGadgetColors(*IB)
        _RedrawIconBarGadget(*IB)
      EndIf
    EndIf
  EndIf
EndProcedure

; Get an IconBar attribute (including some read-only attributes)

Procedure.i GetIconBarGadgetAttribute(*IB._ICONBAR, Attribute.i)
  Protected Result.i = #IconBar_Invalid
 
  If (*IB)
    Select (Attribute)
   
      Case #IconBar_Margin
        Result = *IB\Margin
      Case #IconBar_Padding
        Result = *IB\Padding
      Case #IconBar_Spacing
        Result = *IB\Spacing
      Case #IconBar_Radius
        Result = *IB\Radius
     
      Case #IconBar_DisplayMode
        Result = *IB\DisplayMode
      Case #IconBar_ReturnValue
        Result = *IB\ReturnValue
      Case #IconBar_MouseOverEvents
        Result = Bool(*IB\Flags & #_IconBar_MouseOver)
     
      Case #IconBar_PopupMenu
        Result = *IB\Popup
      Case #IconBar_FontID
        Result = *IB\FontID
      Case #IconBar_UserData
        Result = *IB\UserData
      Case #IconBar_LatchItem
        Result = *IB\LatchItem
     
      ; Read-only (not allowed in SetAttribute)
     
      Case #IconBar_Width
        Result = *IB\ViewWidth
      Case #IconBar_Height
        Result = *IB\ViewHeight
      Case #IconBar_FitWidth
        Result = *IB\IdealWidth
      Case #IconBar_FitHeight
        Result = *IB\IdealHeight
   
    EndSelect
  EndIf
 
  ProcedureReturn (Result)
EndProcedure

; Set IconBar attributes (see macros for easier usage)

Procedure SetIconBarGadgetAttribute(*IB._ICONBAR, Attribute.i, Value.i = #IconBar_Default)
  If (*IB)
    If (Value = #IconBar_Default)
      Select (Attribute)
        Case #IconBar_UserData
          ; (allow IconBar_Default as valid Value)
        Default
          Value = _GetIconBarGadgetDefault(Attribute)
      EndSelect
    EndIf
    Protected NeedUpdate.i = #False
    Protected NeedRedraw.i = #False
    Select (Attribute)
   
      Case #IconBar_Margin
        If (Value >= 0)
          *IB\Margin = Value : NeedUpdate = #True : NeedRedraw = #True
        EndIf
      Case #IconBar_Padding
        If (Value >= 0)
          *IB\Padding = Value : NeedUpdate  = #True : NeedRedraw  = #True
        EndIf
      Case #IconBar_Spacing
        If (Value >= 0)
          *IB\Spacing = Value : NeedUpdate  = #True : NeedRedraw  = #True
        EndIf
      Case #IconBar_Radius
        If (Value >= 0)
          *IB\Radius = Value : NeedRedraw  = #True
        EndIf
     
      Case #IconBar_DisplayMode
        Select (Value)
          Case #IconBarDisplay_ImageOnly, #IconBarDisplay_ImageAndText, #IconBarDisplay_TextOnly
            *IB\DisplayMode = Value : NeedUpdate  = #True : NeedRedraw  = #True
        EndSelect
      Case #IconBar_ReturnValue
        Select (Value)
          Case #IconBarReturn_ItemNumber, #IconBarReturn_Position, #IconBarReturn_UserData
            *IB\ReturnValue = Value
        EndSelect
      Case #IconBar_MouseOverEvents
        If (Value)
          *IB\Flags | (#_IconBar_MouseOver)
        Else
          *IB\Flags & (~#_IconBar_MouseOver)
        EndIf
     
      Case #IconBar_PopupMenu
        *IB\Popup = Value
      Case #IconBar_FontID
        *IB\FontID     =  Value
        *IB\TextHeight = #IconBar_Invalid
        ForEach (*IB\Pos())
          If (*IB\Pos()\Type = #_IconBar_Item)
            _FormatIconBarGadgetText(*IB, @*IB\Pos())
          EndIf
        Next
        NeedUpdate = #True : NeedRedraw = #True
      Case #IconBar_UserData
        *IB\UserData = Value
      Case #IconBar_LatchItem
        If ((Value >= 0) And (Value < *IB\NumItems))
          *IB\LatchItem = Value
        Else
          *IB\LatchItem = #IconBar_None
        EndIf
   
    EndSelect
    If (NeedUpdate)
      _UpdateIconBarGadget(*IB)
    EndIf
    If (NeedRedraw)
      _RedrawIconBarGadget(*IB)
    EndIf
  EndIf
EndProcedure

; Get an IconBar item's text (specified by item number, clickable items only)
; TextType can be Label or ToolTip

Procedure.s GetIconBarGadgetItemText(*IB._ICONBAR, ItemNumber.i = #IconBar_First, TextType.i = #IconBar_Default)
  Protected Result.s = ""
  If (*IB)
    If (ItemNumber = #IconBar_Last)
      ItemNumber = *IB\NumItems - 1
    EndIf
    If (IconBarPositionFromItemNumber(*IB, ItemNumber) >= 0)
      If (*IB\Pos()\Type = #_IconBar_Item)
        Select (TextType)
          Case #IconBarText_ToolTip
            Result = *IB\Pos()\Tip
          Default
            Result = *IB\Pos()\Text
        EndSelect
      EndIf
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Set an IconBar item's text (specified by item number, clickable items only)
; TextType can be Label or ToolTip

Procedure SetIconBarGadgetItemText(*IB._ICONBAR, Text.s, ItemNumber.i = #IconBar_First, TextType.i = #IconBar_Default)
  If (*IB)
    If (ItemNumber = #IconBar_Last)
      ItemNumber = *IB\NumItems - 1
    EndIf
    If (TextType = #IconBar_Default)
      TextType = #IconBarText_Label
    EndIf
    If (IconBarPositionFromItemNumber(*IB, ItemNumber) >= 0)
      If (*IB\Pos()\Type = #_IconBar_Item)
        Select (TextType)
          Case #IconBarText_ToolTip
            *IB\Pos()\Tip = Text
          Default
            *IB\Pos()\Text = Text
        EndSelect
        _FormatIconBarGadgetText(*IB, @*IB\Pos())
        _UpdateIconBarGadget(*IB, #True)
      EndIf
    EndIf
  EndIf
EndProcedure

; Add a clickable IconBar item
; - Text: Tooltip or displayed text, depending on Display Mode
; - Image: Displayed icon, depending on Display Mode
; - UserData: Optional data, can be reported on clicks by Return Value Mode
; - MenuItemID: Optional, if specified, will generate a PB Menu event when clicked
; - Position: A specific position, or the end of the bar by default

Procedure.i AddIconBarGadgetItem(*IB._ICONBAR, Text.s, Image.i = #IconBar_None, ItemUserData.i = #Null, MenuItemID.i = #IconBar_None, Position.i = #IconBar_Last)
  Protected Result.i = #IconBar_Invalid
 
  If (*IB And *IB\Canvas)
    If (Position = #IconBar_Last)
      Position = *IB\NumPositions
    EndIf
    If (Position <= *IB\NumPositions)
      If (Position = *IB\NumPositions)
        LastElement(*IB\Pos())
        AddElement(*IB\Pos())
      Else
        SelectElement(*IB\Pos(), Position)
        InsertElement(*IB\Pos())
      EndIf
      *IB\Pos()\Text     =  Text
      If (*IB\DisplayMode = #IconBarDisplay_ImageOnly)
        *IB\Pos()\Tip      =  Text
      EndIf
      _FormatIconBarGadgetText(*IB, @*IB\Pos())
      *IB\Pos()\Image    =  Image
      *IB\Pos()\UserData =  ItemUserData
      *IB\Pos()\MenuID   =  MenuItemID
      *IB\Pos()\Type     = #_IconBar_Item
      *IB\NumPositions + 1
      If (*IB\Pos()\Image <> #IconBar_None)
        If (IsImage(*IB\Pos()\Image))
          *IB\Pos()\ImgWidth  = ImageWidth(*IB\Pos()\Image)
          *IB\Pos()\ImgHeight = ImageHeight(*IB\Pos()\Image)
        Else
          *IB\Pos()\Image = #IconBar_None
        EndIf
      EndIf
      _CountIconBarGadgetItems(*IB)
      _UpdateIconBarGadget(*IB, #True)
      Result = Position
    EndIf
  EndIf
 
  ProcedureReturn (Result)
EndProcedure

; Remove an IconBar item (icon, divider, or spacer) by position

Procedure RemoveIconBarGadgetItem(*IB._ICONBAR, Position.i = #IconBar_Last)
  If (*IB And *IB\Canvas)
    If (Position = #IconBar_Last)
      Position = *IB\NumPositions - 1
    EndIf
    If ((Position >= 0) And (Position < *IB\NumPositions))
      SelectElement(*IB\Pos(), Position)
      DeleteElement(*IB\Pos())
      *IB\NumPositions - 1
      _CountIconBarGadgetItems(*IB)
      _UpdateIconBarGadget(*IB, #True)
    EndIf
  EndIf
EndProcedure

; Remove all items from an IconBarGadget

Procedure ClearIconBarGadgetItems(*IB._ICONBAR)
  If (*IB And *IB\Canvas)
    ClearList(*IB\Pos())
    *IB\NumPositions = 0
    *IB\NumItems = 0
    _UpdateIconBarGadget(*IB, #True)
  EndIf
EndProcedure

; Returns the number of IconBar items (or all positions, including dividers and spacers)

Procedure.i CountIconBarGadgetItems(*IB._ICONBAR, IncludeNonItems.i = #False)
  Protected Result.i = #IconBar_Invalid
  If (*IB And *IB\Canvas)
    If (IncludeNonItems)
      Result = *IB\NumPositions
    Else
      Result = *IB\NumItems
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

; Add an IconBar divider (vertical line between items)

Procedure.i IconBarGadgetDivider(*IB._ICONBAR, Position.i = #IconBar_Last)
  Protected Result.i = #IconBar_Invalid
 
  If (*IB And *IB\Canvas)
    If (Position = #IconBar_Last)
      Position = *IB\NumPositions
    EndIf
    If (Position <= *IB\NumPositions)
      If (Position = *IB\NumPositions)
        LastElement(*IB\Pos())
        AddElement(*IB\Pos())
      Else
        SelectElement(*IB\Pos(), Position)
        InsertElement(*IB\Pos())
      EndIf
      *IB\Pos()\Type = #_IconBar_Divider
      *IB\NumPositions + 1
      _UpdateIconBarGadget(*IB, #True)
      Result = Position
    EndIf
  EndIf
 
  ProcedureReturn (Result)
EndProcedure

; Add an IconBar spacer (empty section which automatically fills any extra horizontal space)
; You can right-justify an IconBar by adding a spacer in the left-most position
; You can center-justify an IconBar by adding a spacer at each end
; You can place a spacer between icons to force them to the left and right sides
; You can use other combinations of spacers to achieve many layouts

Procedure.i IconBarGadgetSpacer(*IB._ICONBAR, Width.i = #IconBar_Auto, Position.i = #IconBar_Last)
  Protected Result.i = #IconBar_Invalid
 
  If (*IB And *IB\Canvas)
    If (Position = #IconBar_Last)
      Position = *IB\NumPositions
    EndIf
    If (Position <= *IB\NumPositions)
      If (Position = *IB\NumPositions)
        LastElement(*IB\Pos())
        AddElement(*IB\Pos())
      Else
        SelectElement(*IB\Pos(), Position)
        InsertElement(*IB\Pos())
      EndIf
      *IB\Pos()\Type = #_IconBar_Spacer
      If (Width >= 0)
        *IB\Pos()\TextWidth = Width
      Else
        *IB\Pos()\TextWidth = #IconBar_Default
      EndIf
      *IB\NumPositions + 1
      _UpdateIconBarGadget(*IB, #True)
      Result = Position
    EndIf
  EndIf
 
  ProcedureReturn (Result)
EndProcedure

; Removes an IconBarGadget and releases all its memory

Procedure.i FreeIconBarGadget(*IB._ICONBAR, FreeImages.i = #False)
  If (*IB)
    If (*IB\Canvas And IsGadget(*IB\Canvas))
      UnbindGadgetEvent(*IB\Canvas, @_IconBarGadgetCallback())
      FreeGadget(*IB\Canvas)
    EndIf
    If (FreeImages)
      ForEach (*IB\Pos())
        If (IsImage(*IB\Pos()\Image))
          FreeImage(*IB\Pos()\Image)
        EndIf
      Next
    EndIf
    ClearList(*IB\Pos())
    ClearStructure(*IB, _ICONBAR)
    FreeMemory(*IB)
  EndIf
  ProcedureReturn (#Null)
EndProcedure

; Create an IconBarGadget:
; - x, y: position coordinates
; - Width, Height: gadget dimensions
; - DisplayMode: ImageOnly (Default), ImageAndText, or TextOnly (see constants)
; - Window: PB window to report events to (default is 0 - window number, not ID)

Procedure.i IconBarGadget(x.i, y.i, Width.i, Height.i, DisplayMode.i = #IconBar_Default, Window.i = #IconBar_Default)
  Protected *IB._ICONBAR
 
  If (Window = #IconBar_Default)
    Window = 0
  EndIf
  If (IsWindow(Window))
    *IB = AllocateMemory(SizeOf(_ICONBAR))
    If (*IB)
      *IB\Canvas = CanvasGadget(#PB_Any, x, y, Width, Height)
      If (*IB\Canvas)
        SetGadgetData(*IB\Canvas, *IB)
        InitializeStructure(*IB, _ICONBAR)
        If (DisplayMode = #IconBar_Default)
          DisplayMode = _GetIconBarGadgetDefault(#IconBar_DisplayMode)
        EndIf
        *IB\Window      = Window
        *IB\FontID      = _GetIconBarGadgetDefault(#IconBar_FontID)
        *IB\ReturnValue = _GetIconBarGadgetDefault(#IconBar_ReturnValue)
        *IB\Popup       = _GetIconBarGadgetDefault(#IconBar_PopupMenu)
        *IB\ColorBack   = _GetIconBarGadgetDefault(#IconBar_BackgroundColor)
        *IB\ColorText   = _GetIconBarGadgetDefault(#IconBar_TextColor)
        *IB\ColorDiv    = _GetIconBarGadgetDefault(#IconBar_DividerColor)
        *IB\ColorHigh   = _GetIconBarGadgetDefault(#IconBar_HighlightColor)
        *IB\ColorLatch  = _GetIconBarGadgetDefault(#IconBar_LatchColor)
        *IB\Margin      = _GetIconBarGadgetDefault(#IconBar_Margin)
        *IB\Padding     = _GetIconBarGadgetDefault(#IconBar_Padding)
        *IB\Spacing     = _GetIconBarGadgetDefault(#IconBar_Spacing)
        *IB\Radius      = _GetIconBarGadgetDefault(#IconBar_Radius)
        *IB\DisplayMode =  DisplayMode
        *IB\State       = #_IconBar_Hovering
        *IB\HoverItem   = #IconBar_None
        *IB\ClickItem   = #IconBar_None
        *IB\LatchItem   = #IconBar_None
        _CalculateIconBarGadgetColors(*IB)
        _UpdateIconBarGadget(*IB, #True)
        BindGadgetEvent(*IB\Canvas, @_IconBarGadgetCallback())
      Else
        FreeMemory(*IB)
        *IB = #Null
      EndIf
    EndIf
  EndIf
 
  ProcedureReturn (*IB)
EndProcedure

; A helper function to create a single-item IconBar which acts like a button gadget

Procedure.i IconBarGadgetButton(x.i, y.i, Width.i, Height.i, Image.i, Text.s = "", DisplayMode.i = #IconBar_Default, Window.i = #IconBar_Default)
  Protected *IB._ICONBAR = IconBarGadget(x, y, Width, Height, DisplayMode, Window)
  If (*IB)
    SetIconBarGadgetMargin(*IB, 0)
    AddIconBarGadgetItem(*IB, Text, Image)
    LockIconBarGadgetSizes(*IB, #True)
  EndIf
  ProcedureReturn (*IB)
EndProcedure

UndefineMacro _IBGMax
































;-
;-
;-
;- [ Demo Program ]

CompilerIf (#PB_Compiler_IsMainFile)

DisableExplicit

UsePNGImageDecoder()

Procedure.i LoadImage_( img, type.s )
    Protected ZipFile$ = GetCurrentDirectory( )+"Themes/" + "SilkTheme.zip"
    Debug ""
    
    If FileSize( ZipFile$ ) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize( ZipFile$ ) < 1
        MessageRequester( "Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error | #PB_MessageRequester_Ok )
        End
      EndIf
    EndIf
    
    If FileSize( ZipFile$ ) > 0
      CompilerIf #PB_Compiler_Version > 522
        UseZipPacker( )
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *memory, Image, ZipFile
      ZipFile = OpenPack( #PB_Any, ZipFile$, #PB_PackerPlugin_Zip )
      
      If ZipFile  
        If ExaminePack( ZipFile )
          While NextPackEntry( ZipFile )
            
            PackEntryName.S = PackEntryName( ZipFile )
            ImageSize = PackEntrySize( ZipFile )
            If ImageSize
              *memory = AllocateMemory( ImageSize )
              UncompressPackMemory( ZipFile, *memory, ImageSize )
              
              ;Debug PackEntryName
              
              Select PackEntryType( ZipFile )
                Case #PB_Packer_File
                  If FindString( ( PackEntryName.S ), type )
                    CatchImage( img, *memory, ImageSize )
;                     FreeMemory( *memory )
;                     ClosePack( ZipFile )
;                     ProcedureReturn img 
                  EndIf
              EndSelect
              
              FreeMemory( *memory )
            EndIf
          Wend  
        EndIf
        
        ClosePack( ZipFile )
      EndIf
    EndIf
    
    ProcedureReturn img 
  EndProcedure
  
OpenWindow(0, 0, 0, 640, 530, "IconBarGadget Demo " + IconBarGadgetVersionString(), #PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
CreateStatusBar(0, WindowID(0))
AddStatusBarField(#PB_Ignore)
AddKeyboardShortcut(0, #PB_Shortcut_Escape, 0)
WindowBounds(0, #PB_Ignore, WindowHeight(0), #PB_Ignore, WindowHeight(0))

LoadImage_(0, "page_white.png")
LoadImage_(1, "folder_page.png")
LoadImage_(2, "disk.png")
LoadImage_(3, "page_copy.png")
LoadImage_(4, "page_paste.png")
LoadImage_(5, "cut.png")
LoadImage_(6, "world.png")
LoadImage_(7, "help.png")
LoadImage_(8, "world_16.png")
LoadImage_(9, "star_16.png")

Global n = 5
Global Dim IBG(n - 1)

y = 10

;-
;- - Create IconBarGadget 0

TextGadget(#PB_Any, 20, y, WindowWidth(0) - 20, 20, "Default style (icons with tooltips) with 1 divider and 1 spacer:")
IBG(0) = IconBarGadget(0, y+20, WindowWidth(0), 20)
  AddIconBarGadgetItem(IBG(0), "New",  0)
  AddIconBarGadgetItem(IBG(0), "Open", 1)
  AddIconBarGadgetItem(IBG(0), "Save", 2)
  IconBarGadgetDivider(IBG(0))
  AddIconBarGadgetItem(IBG(0), "Copy", 3)
  AddIconBarGadgetItem(IBG(0), "Paste", 4)
  AddIconBarGadgetItem(IBG(0), "Cut", 5)
  IconBarGadgetSpacer(IBG(0))
  AddIconBarGadgetItem(IBG(0), "Website", 6)
  AddIconBarGadgetItem(IBG(0), "Help", 7)
  y + ResizeIconBarGadget(IBG(0), #PB_Ignore, #IconBar_Auto)
  y + 20 + 30
 
;- - Create IconBarGadget 1

TextGadget(#PB_Any, 20, y, WindowWidth(0) - 20, 20, "Images and Text, using 2 spacers to center, latch item, disabled item, returns click position:")
IBG(1) = IconBarGadget(0, y+20, WindowWidth(0), 20, #IconBarDisplay_ImageAndText)
  IconBarGadgetSpacer(IBG(1))
  AddIconBarGadgetItem(IBG(1), "New",  0)
  AddIconBarGadgetItem(IBG(1), "Open", 1)
  AddIconBarGadgetItem(IBG(1), "Save", 2)
  IconBarGadgetDivider(IBG(1))
  AddIconBarGadgetItem(IBG(1), "Copy", 3)
  AddIconBarGadgetItem(IBG(1), "Paste", 4)
  AddIconBarGadgetItem(IBG(1), "Cut", 5)
  IconBarGadgetSpacer(IBG(1))
  SetIconBarGadgetReturnValue(IBG(1), #IconBarReturn_Position)
  SetIconBarGadgetLatchItem(IBG(1), 0)
  DisableIconBarGadgetItem(IBG(1), 2)
  y + ResizeIconBarGadget(IBG(1), #PB_Ignore, #IconBar_Auto)
  y + 20 + 30
 
;- - Create IconBarGadget 2

TextGadget(#PB_Any, 20, y, WindowWidth(0) - 20, 20, "Text only, with right-click menu, returns custom values:")
IBG(2) = IconBarGadget(0, y+20, WindowWidth(0), 20, #IconBarDisplay_TextOnly)
  AddIconBarGadgetItem(IBG(2), "New", #IconBar_None, 123)
  AddIconBarGadgetItem(IBG(2), "Open", #IconBar_None, 456)
  AddIconBarGadgetItem(IBG(2), "Save", #IconBar_None, 789)
  IconBarGadgetDivider(IBG(2))
  AddIconBarGadgetItem(IBG(2), "Copy", #IconBar_None, 42)
  AddIconBarGadgetItem(IBG(2), "Paste", #IconBar_None, 555)
  AddIconBarGadgetItem(IBG(2), "Cut", #IconBar_None, 1024)
  IconBarGadgetDivider(IBG(2))
  AddIconBarGadgetItem(IBG(2), "Website", #IconBar_None, 1000)
  AddIconBarGadgetItem(IBG(2), "Help", #IconBar_None, 1001)
  IconBarGadgetDivider(IBG(2))
  AddIconBarGadgetItem(IBG(2), "Quit", #IconBar_None, 999, 0)
  SetIconBarGadgetItemText(IBG(2), "Click to actually Quit the demo!", #IconBar_Last, #IconBarText_ToolTip)
  CreatePopupMenu(0)
  MenuItem(0, "Quit Demo")
  SetIconBarGadgetAttribute(IBG(2), #IconBar_PopupMenu, 0)
  SetIconBarGadgetReturnValue(IBG(2), #IconBarReturn_UserData)
  y + ResizeIconBarGadget(IBG(2), #PB_Ignore, #IconBar_Auto)
  y + 20 + 30
 
;- - Create IconBarGadget 3

TextGadget(#PB_Any, 20, y, WindowWidth(0) - 20, 20, "Multi-line, custom font, various icon sizes, missing image, custom colors, rounded corners:")
IBG(3) = IconBarGadget(0, y+20, WindowWidth(0), 20, #IconBarDisplay_ImageAndText)
  AddIconBarGadgetItem(IBG(3), "Blank" + #LF$ + "Page", 0)
  AddIconBarGadgetItem(IBG(3), "Another" + #LF$ + "Page", 0)
  ;IconBarGadgetDivider(IBG(3))
  AddIconBarGadgetItem(IBG(3), "Missing" + #LF$ + "Image")
  IconBarGadgetSpacer(IBG(3))
  AddIconBarGadgetItem(IBG(3), "A", 9)
  AddIconBarGadgetItem(IBG(3), "B", 9)
  AddIconBarGadgetItem(IBG(3), "C", 9)
  IconBarGadgetSpacer(IBG(3))
  AddIconBarGadgetItem(IBG(3), "Hello" + #LF$ + "World", 6)
  AddIconBarGadgetItem(IBG(3), "Small" + #LF$ + "World", 8)
  SetIconBarGadgetFontID(IBG(3), LoadFont(0, "Georgia", 10))
  SetIconBarGadgetRadius(IBG(3), 7)
  y + ResizeIconBarGadget(IBG(3), #IconBar_Ignore, #IconBar_Auto)
  y + 20 + 30
  y + 20

;- - Create IconBarGadget 4

TextGadget(#PB_Any, 20, y, WindowWidth(0) - 20, 20, "IconBar acting as a single button, with custom ToolTip:")
IBG(4) = IconBarGadgetButton(10, y+20, 20, 20, 7, "Disable", #IconBarDisplay_ImageAndText)
  AutoSizeIconBarGadget(IBG(4))
  SetIconBarGadgetItemText(IBG(4), "Click to disable/enable the above IconBarGadget", 0, #IconBarText_ToolTip)

For i = 0 To n - 1
  SetIconBarGadgetAttribute(IBG(i), #IconBar_MouseOverEvents, #True)
Next i

;-
Procedure ResizeCallback()
  If (GetWindowState(0) <> #PB_Window_Minimize)
    Protected i.i
    For i = 0 To n - 1
      ResizeIconBarGadget(IBG(i), WindowWidth(0), #IconBar_Ignore)
    Next i
  EndIf
EndProcedure

BindEvent(#PB_Event_SizeWindow, @ResizeCallback(), 0)

Repeat
  Select (WaitWindowEvent())
    Case #PB_Event_CloseWindow
      Done = #True
    Case #PB_Event_Menu
      Done = #True
   
    ;-
    ;- - IconBarGadget Events
   
    Case #PB_Event_Gadget
      If (EventType() = #IconBarEventType_LeftClick)
        Select (EventGadget())
          Case IBG(0)
            Debug "IBG 0: Clicked item " + Str(EventData())
          Case IBG(1)
            Debug "IBG 1: Clicked position " + Str(EventData())
            If (#False)
              DisableIconBarGadgetItem(IBG(1), #IconBar_All, #False)
              DisableIconBarGadgetItem(IBG(1), IconBarItemNumberFromPosition(IBG(1), EventData()), #True)
            Else
              SetIconBarGadgetLatchItem(IBG(1), IconBarItemNumberFromPosition(IBG(1), EventData()))
            EndIf
          Case IBG(2)
            Debug "IBG 2: User data = " + Str(EventData())
          Case IBG(3)
            LockIconBarGadgetRedraw(IBG(3), #True)
         
            ; Random layout
            SetIconBarGadgetMargin(IBG(3), Random(10))
            SetIconBarGadgetPadding(IBG(3), Random(10))
            SetIconBarGadgetSpacing(IBG(3), Random(10))
            SetIconBarGadgetDisplayMode(IBG(3), Random(2))
           
            ; Random colors and font
            SetIconBarGadgetColor(IBG(3), #IconBar_BackgroundColor, RGB(230+Random(25),230+Random(25),230+Random(25)))
            SetIconBarGadgetColor(IBG(3), #IconBar_TextColor, $A0 << (Random(2) * 8))
            SetIconBarGadgetColor(IBG(3), #IconBar_HighlightColor, Random($FFFFFF))
            SetIconBarGadgetFontID(IBG(3), LoadFont(0, "Georgia", 6+Random(10)))
           
            ; Auto-fit gadget height
            ResizeIconBarGadget(IBG(3), #IconBar_Ignore, #IconBar_Auto)
           
            LockIconBarGadgetRedraw(IBG(3), #False)
          Case IBG(4)
            If (DisableIconBarGadget(IBG(3), #IconBar_Toggle))
              SetIconBarGadgetItemText(IBG(4), "Enable")
            Else
              SetIconBarGadgetItemText(IBG(4), "Disable")
            EndIf
        EndSelect
      ElseIf (EventType() = #IconBarEventType_MouseOver)
        If (EventData() >= 0)
          StatusBarText(0, 0, "MouseOver: " + GetIconBarGadgetItemText(EventGadget(), EventData()))
        Else
          StatusBarText(0, 0, "")
        EndIf
      EndIf
     
  EndSelect
Until Done

For i = 0 To n - 1
  FreeIconBarGadget(IBG(i), #True)
Next i

CompilerEndIf

;-
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -------------------------------------------
; EnableXP