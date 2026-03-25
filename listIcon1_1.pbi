EnableExplicit

; --- Константы ---
#ALIGN_LEFT   = 0
#ALIGN_CENTER = 1
#ALIGN_RIGHT  = 2

; --- Структуры ---
Structure _s_COLUMN
  Title.s
  Width.i
  ImageIndex.i
  Align.b
EndStructure

Structure _s_ITEM
  List ColText.s()
  ImageIndex.i
  Checked.b
  Selected.b
EndStructure

Structure _s_WIDGET
  GadgetID.i
  HeaderHeight.i
  RowHeight.i
  HoverCol.i
  ResizeCol.i
  ColumnStartX.i
  ; СПИСКИ УКАЗАТЕЛЕЙ (в узле списка только адрес 4/8 байт)
  List *Columns._s_COLUMN() 
  List *Items._s_ITEM()
EndStructure

; Удаление строки (УКАЗАТЕЛИ)
Procedure RemoveItem(*this._s_WIDGET, Index.l)
  If SelectElement(*this\Items(), Index)
    ; 1. Сначала удаляем саму структуру по адресу, который лежит в списке
    FreeStructure(*this\Items()) 
    ; 2. Теперь удаляем сам указатель (адрес) из списка
    DeleteElement(*this\Items())
  EndIf
EndProcedure

; Удаление колонки (УКАЗАТЕЛИ)
Procedure RemoveColumn(*this._s_WIDGET, Index.l)
  If SelectElement(*this\Columns(), Index)
    ; Синхронизируем строки (удаляем ячейку из вложенных списков)
    ForEach *this\Items()
      SelectElement(*this\Items()\ColText(), Index)
      DeleteElement(*this\Items()\ColText())
    Next
    ; Удаляем структуру колонки и сам указатель
    FreeStructure(*this\Columns())
    DeleteElement(*this\Columns())
  EndIf
EndProcedure

; Очистка всех строк (УКАЗАТЕЛИ)
Procedure ClearItems(*this._s_WIDGET)
  ForEach *this\Items()
    FreeStructure(*this\Items()) ; Чистим память каждой структуры
  Next
  ClearList(*this\Items()) ; Чистим список адресов
EndProcedure

; --- Отрисовка ---
Procedure ReDraw(*this._s_WIDGET)
  Protected X, Y, txt.s, BgColor, CurX, tx, tw, HeadColor
  If Not *this Or Not IsGadget(*this\GadgetID) : ProcedureReturn : EndIf
  
  If StartDrawing(CanvasOutput(*this\GadgetID))
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF) 
    
    Y = *this\HeaderHeight
    ForEach *this\Items()
      ; *this\Items() — это указатель. PB сам переходит по адресу к полям.
      BgColor = $FFFFFF : If *this\Items()\Selected : BgColor = $F0D090 : EndIf
      Box(0, Y, OutputWidth(), *this\RowHeight, BgColor)
      
      X = 0
      ForEach *this\Columns()
        ClipOutput(X, Y, *this\Columns()\Width, *this\RowHeight)
        SelectElement(*this\Items()\ColText(), ListIndex(*this\Columns()))
        txt = *this\Items()\ColText()
        DrawingMode(#PB_2DDrawing_Transparent)
        
        CurX = X + 5
        If ListIndex(*this\Columns()) = 0
          Box(CurX, Y+6, 12, 12, $808080) : Box(CurX+1, Y+7, 10, 10, $FFFFFF)
          If *this\Items()\Checked : DrawText(CurX+2, Y+3, "v", $FF0000) : EndIf
          CurX + 20
          If *this\Items()\ImageIndex <> -1 And IsImage(*this\Items()\ImageIndex)
            DrawImage(ImageID(*this\Items()\ImageIndex), CurX, Y + (*this\RowHeight-16)/2, 16, 16)
            CurX + 20
          EndIf
        EndIf

        tw = TextWidth(txt)
        Select *this\Columns()\Align
          Case #ALIGN_CENTER : tx = X + (*this\Columns()\Width - tw) / 2
          Case #ALIGN_RIGHT  : tx = X + *this\Columns()\Width - tw - 5
          Default            : tx = CurX
        EndSelect
        
        DrawText(tx, Y + 4, txt, 0)
        UnclipOutput()
        Line(X + *this\Columns()\Width - 1, Y, 1, *this\RowHeight, $F0F0F0)
        X + *this\Columns()\Width
      Next
      Y + *this\RowHeight
    Next
    
    X = 0
    DrawingMode(#PB_2DDrawing_Transparent)
    ForEach *this\Columns()
      HeadColor = $D0D0D0 : If ListIndex(*this\Columns()) = *this\HoverCol : HeadColor = $E5E5E5 : EndIf
      Box(X, 0, *this\Columns()\Width, *this\HeaderHeight, HeadColor)
      Line(X + *this\Columns()\Width - 1, 0, 1, *this\HeaderHeight, $808080)
      
      CurX = X + 5
      If *this\Columns()\ImageIndex <> -1 And IsImage(*this\Columns()\ImageIndex)
        DrawImage(ImageID(*this\Columns()\ImageIndex), CurX, (*this\HeaderHeight-16)/2, 16, 16)
        CurX + 20
      EndIf
      
      txt = *this\Columns()\Title : tw = TextWidth(txt)
      Select *this\Columns()\Align
        Case #ALIGN_CENTER : tx = X + (*this\Columns()\Width - tw) / 2
        Case #ALIGN_RIGHT  : tx = X + *this\Columns()\Width - tw - 5
        Default            : tx = CurX
      EndSelect
      DrawText(tx, 7, txt, 0)
      X + *this\Columns()\Width
    Next
    StopDrawing()
  EndIf
EndProcedure

; --- API ---
Procedure.i AddColumn(*this._s_WIDGET, position.l, Text.s, Width.l, img.i = -1, Align.b = #ALIGN_LEFT)
  If Not *this : ProcedureReturn #False : EndIf
  If position = -1 : AddElement(*this\Columns()) : Else : SelectElement(*this\Columns(), position) : InsertElement(*this\Columns()) : EndIf
  
  ; ВРУЧНУЮ выделяем память под структуру и записываем адрес в список
  *this\Columns() = AllocateStructure(_s_COLUMN)
  *this\Columns()\Title = Text : *this\Columns()\Width = Width : *this\Columns()\ImageIndex = img : *this\Columns()\Align = Align
  
  Protected colIdx = ListIndex(*this\Columns())
  ForEach *this\Items()
    SelectElement(*this\Items()\ColText(), colIdx) : InsertElement(*this\Items()\ColText())
  Next
  ProcedureReturn colIdx
EndProcedure

Procedure.i AddItem(*this._s_WIDGET, Item.l, Text.s, img.i = -1, Flag.q = 0)
  If Not *this : ProcedureReturn #False : EndIf
  If Item = -1 : AddElement(*this\Items()) : Else : SelectElement(*this\Items(), Item) : InsertElement(*this\Items()) : EndIf
  
  ; ВРУЧНУЮ выделяем память под структуру элемента
  *this\Items() = AllocateStructure(_s_ITEM)
  *this\Items()\ImageIndex = img
  
  Protected i, Count = ListSize(*this\Columns())
  For i = 1 To Count
    AddElement(*this\Items()\ColText()) : *this\Items()\ColText() = StringField(Text, i, Chr(10))
  Next
  ProcedureReturn *this\Items()
EndProcedure

Procedure.i ListIcon(X.l, Y.l, Width.l, Height.l, ColumnTitle.s, ColumnWidth.i, Flag.q = 0)
  Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
  If *this
    *this\HeaderHeight = 30 : *this\RowHeight = 25 : *this\HoverCol = -1 : *this\ResizeCol = -1
    *this\GadgetID = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
    SetGadgetData(*this\GadgetID, *this)
    AddColumn(*this, -1, ColumnTitle, ColumnWidth)
    ProcedureReturn *this
  EndIf
EndProcedure

Procedure DoEvents(*this._s_WIDGET)
  If Not *this : ProcedureReturn : EndIf
  Protected GID = *this\GadgetID, mx = GetGadgetAttribute(GID, #PB_Canvas_MouseX), my = GetGadgetAttribute(GID, #PB_Canvas_MouseY), curX, idx
  Select EventType()
    Case #PB_EventType_MouseMove
      If *this\ResizeCol <> -1
        SelectElement(*this\Columns(), *this\ResizeCol)
        *this\Columns()\Width = mx - *this\ColumnStartX
        If *this\Columns()\Width < 20 : *this\Columns()\Width = 20 : EndIf
        ReDraw(*this)
      Else
        Protected oldHover = *this\HoverCol, foundBorder = -1
        *this\HoverCol = -1 : curX = 0
        ForEach *this\Columns()
          curX + *this\Columns()\Width
          If mx > curX - 5 And mx < curX + 5 And my < *this\HeaderHeight : foundBorder = ListIndex(*this\Columns()) : EndIf
          If mx >= curX - *this\Columns()\Width And mx < curX And my < *this\HeaderHeight : *this\HoverCol = ListIndex(*this\Columns()) : EndIf
        Next
        If foundBorder <> -1 : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
        Else : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_Default) : EndIf
        If oldHover <> *this\HoverCol : ReDraw(*this) : EndIf
      EndIf
    Case #PB_EventType_LeftButtonDown
      If GetGadgetAttribute(GID, #PB_Canvas_Cursor) = #PB_Cursor_LeftRight
        curX = 0
        ForEach *this\Columns()
          curX + *this\Columns()\Width
          If mx < curX + 5 : *this\ResizeCol = ListIndex(*this\Columns()) : *this\ColumnStartX = curX - *this\Columns()\Width : Break : EndIf
        Next
      ElseIf my > *this\HeaderHeight
        idx = (my - *this\HeaderHeight) / *this\RowHeight
        If idx >= 0 And idx < ListSize(*this\Items())
          SelectElement(*this\Items(), idx)
          If mx < 25 : *this\Items()\Checked ! 1 : Else
            ForEach *this\Items() : *this\Items()\Selected = 0 : Next
            SelectElement(*this\Items(), idx) : *this\Items()\Selected = 1
          EndIf
          ReDraw(*this)
        EndIf
      EndIf
    Case #PB_EventType_LeftButtonUp
      *this\ResizeCol = -1 : ReDraw(*this)
  EndSelect
EndProcedure

; --- ТЕСТ ---
CreateImage(0, 16, 16) : StartDrawing(ImageOutput(0)) : Box(0,0,16,16,$00FF00) : StopDrawing()
OpenWindow(0, 0, 0, 640, 300, "Pointers ListIcon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

Global *MyList = ListIcon(10, 10, 620, 280, "Имя (Указатель)", 200)
AddColumn(*MyList, -1, "Возраст (Центр)", 150, 0, #ALIGN_CENTER)
AddColumn(*MyList, -1, "Город (Право)", 150, -1, #ALIGN_RIGHT)

AddItem(*MyList, -1, "Дмитрий" + Chr(10) + "34" + Chr(10) + "Тула", 0)
AddItem(*MyList, -1, "Елена" + Chr(10) + "28" + Chr(10) + "Сочи")

ReDraw(*MyList)

Repeat
  Define Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget
    Define *obj = GetGadgetData(EventGadget())
    If *obj : DoEvents(*obj) : EndIf
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 44
; FirstLine = 44
; Folding = --------
; EnableXP
; DPIAware