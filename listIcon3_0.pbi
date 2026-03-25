EnableExplicit

; --- Константы ---
#ALIGN_LEFT   = 0
#ALIGN_CENTER = 1
#ALIGN_RIGHT  = 2

; --- Структуры ---
Structure _s_COLUMN
  Title.s
  Width.i
  img.i
  Align.b
  DisplayOrder.i ; Логический порядок отображения
EndStructure

Structure _s_ITEM
  List ColText.s()
  img.i
  Checked.b
  Selected.b
EndStructure

Structure _s_WIDGET
  GadgetID.i
  
  ColHeight.i
  MoveColX.i
  HoverCol.i
  DragCol.i     
  ResizeCol.i
  
  RowHeight.i
  TargetIdx.i   
  DragItem.i    
  
  MouseOffX.i   
  MouseOffY.i
  
  List Columns._s_COLUMN()
  List Items._s_ITEM()
EndStructure

; --- Вспомогательная функция для поиска колонки по её позиции на экране ---
Procedure.i GetColumnByDisplayPos(*this._s_WIDGET, DisplayPos.i)
  ForEach *this\Columns()
    If *this\Columns()\DisplayOrder = DisplayPos
      ProcedureReturn @*this\Columns()
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

; --- Отрисовка ---
Procedure ReDraw(*this._s_WIDGET)
  Protected X, Y, txt.s, BgColor, CurX, tx, tw, Index, mx, my, i, dispIdx
  Protected *col._s_COLUMN
  
  If Not *this Or Not IsGadget(*this\GadgetID) : ProcedureReturn : EndIf
  
  mx = GetGadgetAttribute(*this\GadgetID, #PB_Canvas_MouseX)
  my = GetGadgetAttribute(*this\GadgetID, #PB_Canvas_MouseY)
  
  If StartDrawing(CanvasOutput(*this\GadgetID))
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF) 
    
    ; 1. Отрисовка Строк
    Y = *this\ColHeight
    ForEach *this\Items()
      Index = ListIndex(*this\Items())
      BgColor = $FFFFFF : If *this\Items()\Selected : BgColor = $F0D090 : EndIf
      If Index = *this\DragItem : BgColor = $F5F5F5 : EndIf
      
      Box(0, Y, OutputWidth(), *this\RowHeight, BgColor)
      X = 0
      ; Рисуем колонки в порядке их DisplayOrder
      For dispIdx = 0 To ListSize(*this\Columns()) - 1
        *col = GetColumnByDisplayPos(*this, dispIdx)
        If *col
          ClipOutput(X, Y, *col\Width, *this\RowHeight)
          ; Выбираем текст по физическому индексу колонки в памяти
          SelectElement(*this\Items()\ColText(), ListIndex(*this\Columns()))
          txt = *this\Items()\ColText()
          
          DrawingMode(#PB_2DDrawing_Transparent)
          CurX = X + 5
          ; Чекбокс и иконка всегда в самой левой (по экрану) колонке
          If dispIdx = 0 
            Box(CurX, Y+6, 12, 12, $808080) : Box(CurX+1, Y+7, 10, 10, $FFFFFF)
            If *this\Items()\Checked : DrawText(CurX+2, Y+3, "v", $FF0000) : EndIf
            CurX + 20
            If *this\Items()\img <> -1 And IsImage(*this\Items()\img)
              DrawImage(ImageID(*this\Items()\img), CurX, Y + (*this\RowHeight-16)/2, 16, 16)
              CurX + 20
            EndIf
          EndIf

          tw = TextWidth(txt)
          Select *col\Align
            Case #ALIGN_CENTER : tx = X + (*col\Width - tw) / 2
            Case #ALIGN_RIGHT  : tx = X + *col\Width - tw - 5
            Default            : tx = CurX
          EndSelect
          DrawText(tx, Y + 4, txt, 0)
          UnclipOutput()
          Line(X + *col\Width - 1, Y, 1, *this\RowHeight, $F0F0F0)
          X + *col\Width
        EndIf
      Next
      Y + *this\RowHeight
    Next
    
    ; 2. Отрисовка Шапки
    X = 0 : DrawingMode(#PB_2DDrawing_Transparent)
    For dispIdx = 0 To ListSize(*this\Columns()) - 1
      *col = GetColumnByDisplayPos(*this, dispIdx)
      If *col
        Protected HeadColor = $D0D0D0
        If ListIndex(*this\Columns()) = *this\HoverCol : HeadColor = $E5E5E5 : EndIf
        If ListIndex(*this\Columns()) = *this\DragCol : HeadColor = $AAAAAA : EndIf
        
        Box(X, 0, *col\Width, *this\ColHeight, HeadColor)
        Line(X + *col\Width - 1, 0, 1, *this\ColHeight, $808080)
        
        txt = *col\Title : tw = TextWidth(txt)
        Select *col\Align
          Case #ALIGN_CENTER : tx = X + (*col\Width - tw) / 2
          Case #ALIGN_RIGHT  : tx = X + *col\Width - tw - 5
          Default            : tx = X + 5
        EndSelect
        DrawText(tx, 7, txt, 0)
        X + *col\Width
      EndIf
    Next
    
    ; 3. Фантомы
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    If *this\DragItem <> -1
      Box(0, my - *this\MouseOffY, OutputWidth(), *this\RowHeight, $6090D0F0)
      Line(0, *this\ColHeight + *this\TargetIdx * *this\RowHeight, OutputWidth(), 2, $FF0000FF)
    EndIf
    
    If *this\DragCol <> -1
      SelectElement(*this\Columns(), *this\DragCol)
      Box(mx - *this\MouseOffX, 0, *this\Columns()\Width, *this\ColHeight, $60A0A0A0)
      Protected lineX = 0
      For i = 0 To *this\TargetIdx - 1 
        *col = GetColumnByDisplayPos(*this, i)
        If *col : lineX + *col\Width : EndIf
      Next
      Line(lineX, 0, 2, *this\ColHeight, $FF0000FF)
   EndIf
   
    StopDrawing()
  EndIf
EndProcedure

; --- API Добавления ---
; Procedure.i AddColumn(*this._s_WIDGET, position.l, Text.s, Width.l, img.i = -1, Align.b = #ALIGN_LEFT)
;   If position = -1 : AddElement(*this\Columns()) : Else : SelectElement(*this\Columns(), position) : InsertElement(*this\Columns()) : EndIf
;   *this\Columns()\Title = Text : *this\Columns()\Width = Width : *this\Columns()\img = img : *this\Columns()\Align = Align
;   *this\Columns()\DisplayOrder = ListSize(*this\Columns()) - 1 ; Назначаем порядковый номер
;   
;   Protected index = ListIndex(*this\Columns())
;   ForEach *this\Items() : SelectElement(*this\Items()\ColText(), index) : InsertElement(*this\Items()\ColText()) : Next
;   ProcedureReturn index
; EndProcedure
Procedure.i AddColumn(*this._s_WIDGET, position.l, Text.s, Width.l, img.i = -1, Align.b = #ALIGN_LEFT)
  Protected newOrder
  
  ; 1. Определяем логический индекс для новой колонки
  If position = -1 Or position >= ListSize(*this\Columns())
    newOrder = ListSize(*this\Columns())
    AddElement(*this\Columns())
  Else
    newOrder = position
    ; Сдвигаем DisplayOrder у всех, кто стоит на этом месте и дальше
    ForEach *this\Columns()
      If *this\Columns()\DisplayOrder >= newOrder
        *this\Columns()\DisplayOrder + 1
      EndIf
    Next
    SelectElement(*this\Columns(), position)
    InsertElement(*this\Columns())
  EndIf
  
  ; 2. Заполняем данные
  *this\Columns()\Title = Text 
  *this\Columns()\Width = Width 
  *this\Columns()\img = img 
  *this\Columns()\Align = Align
  *this\Columns()\DisplayOrder = newOrder
  
  ; 3. Синхронизируем данные в строках (Items)
  Protected Index = ListIndex(*this\Columns())
  ForEach *this\Items()
    SelectElement(*this\Items()\ColText(), Index)
    InsertElement(*this\Items()\ColText())
  Next
  
  ProcedureReturn Index
EndProcedure

Procedure.i AddItem(*this._s_WIDGET, Item.l, Text.s, img.i = -1)
   If ListSize(*this\Columns())
      Protected i
      If Item = -1 : AddElement(*this\Items()) : Else : SelectElement(*this\Items(), Item) : InsertElement(*this\Items()) : EndIf
      *this\Items()\img = img
      ForEach *this\Columns()
         AddElement(*this\Items()\ColText()) 
         *this\Items()\ColText() = StringField(Text, i+1, Chr(10)) 
         i + 1
      Next
      ProcedureReturn @*this\Items()
   EndIf
EndProcedure

; --- API Удаления ---
Procedure RemoveItem(*this._s_WIDGET, Index.l)
  If Not *this Or Index < 0 Or Index >= ListSize(*this\Items()) : ProcedureReturn : EndIf
  SelectElement(*this\Items(), Index) : DeleteElement(*this\Items())
  *this\DragItem = -1 : ReDraw(*this)
EndProcedure

Procedure ClearItems(*this._s_WIDGET)
  If Not *this : ProcedureReturn : EndIf
  ClearList(*this\Items()) : *this\DragItem = -1 : ReDraw(*this)
EndProcedure

Procedure RemoveColumn(*this._s_WIDGET, Index.l)
  If Not *this Or Index < 0 Or Index >= ListSize(*this\Columns()) : ProcedureReturn : EndIf
  ForEach *this\Items()
    If SelectElement(*this\Items()\ColText(), Index) : DeleteElement(*this\Items()\ColText()) : EndIf
  Next
  SelectElement(*this\Columns(), Index)
  Protected oldOrder = *this\Columns()\DisplayOrder
  DeleteElement(*this\Columns())
  ; Пересчитываем DisplayOrder для оставшихся
  ForEach *this\Columns()
    If *this\Columns()\DisplayOrder > oldOrder : *this\Columns()\DisplayOrder - 1 : EndIf
  Next
  *this\DragCol = -1 : *this\HoverCol = -1 : *this\ResizeCol = -1 : ReDraw(*this)
EndProcedure

; --- СОБЫТИЯ ---
Procedure DoEvents(*this._s_WIDGET)
  If Not *this : ProcedureReturn : EndIf
  Protected GID = *this\GadgetID, mx = GetGadgetAttribute(GID, #PB_Canvas_MouseX), my = GetGadgetAttribute(GID, #PB_Canvas_MouseY)
  Protected curX, idx, targetIdx, *srcPtr, i, *col._s_COLUMN, *tCol._s_COLUMN
  
  Select EventType()
    Case #PB_EventType_MouseMove
      If *this\ResizeCol <> -1
        SelectElement(*this\Columns(), *this\ResizeCol)
        *this\Columns()\Width = mx - *this\MoveColX
        If *this\Columns()\Width < 20 : *this\Columns()\Width = 20 : EndIf
      ElseIf *this\DragItem <> -1
        *this\TargetIdx = (my - *this\ColHeight + *this\RowHeight/2) / *this\RowHeight
        If *this\TargetIdx < 0 : *this\TargetIdx = 0 : EndIf
        If *this\TargetIdx > ListSize(*this\Items()) : *this\TargetIdx = ListSize(*this\Items()) : EndIf
      ElseIf *this\DragCol <> -1
        curX = 0 : *this\TargetIdx = 0
        For i = 0 To ListSize(*this\Columns()) - 1
          *col = GetColumnByDisplayPos(*this, i)
          If *col
            curX + *col\Width
            If mx > curX - *col\Width/2 : *this\TargetIdx = i + 1 : EndIf
          EndIf
        Next
      Else
        curX = 0 : *this\HoverCol = -1
        For i = 0 To ListSize(*this\Columns()) - 1
          *col = GetColumnByDisplayPos(*this, i)
          If *col
            curX + *col\Width
            If mx > curX - 5 And mx < curX + 5 And my < *this\ColHeight
              SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
              *this\HoverCol = ListIndex(*this\Columns()) : Break
            EndIf
            If mx >= curX - *col\Width And mx < curX And my < *this\ColHeight : *this\HoverCol = ListIndex(*this\Columns()) : EndIf
          EndIf
        Next
        If *this\HoverCol = -1 : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_Default) : EndIf
      EndIf
      ReDraw(*this)
      
    Case #PB_EventType_LeftButtonDown
      curX = 0
      For i = 0 To ListSize(*this\Columns()) - 1
        *col = GetColumnByDisplayPos(*this, i)
        If *col
          curX + *col\Width
          If mx > curX - 5 And mx < curX + 5 And my < *this\ColHeight
            *this\ResizeCol = ListIndex(*this\Columns()) : *this\MoveColX = curX - *col\Width : ProcedureReturn
          EndIf
        EndIf
      Next
      
      If my < *this\ColHeight 
        curX = 0
        For i = 0 To ListSize(*this\Columns()) - 1
          *col = GetColumnByDisplayPos(*this, i)
          If *col
            curX + *col\Width
            If mx < curX 
               *this\DragCol = ListIndex(*this\Columns()) 
               *this\MouseOffX = mx - (curX - *col\Width) 
               Break 
            EndIf
          EndIf
        Next
      Else 
        idx = (my - *this\ColHeight) / *this\RowHeight
        If idx >= 0 And idx < ListSize(*this\Items())
          *this\DragItem = idx
          *this\MouseOffY = (my - *this\ColHeight) % *this\RowHeight
          SelectElement(*this\Items(), idx)
          If mx < 25 : *this\Items()\Checked ! 1 : Else
            ForEach *this\Items() : *this\Items()\Selected = 0 : Next
            SelectElement(*this\Items(), idx) : *this\Items()\Selected = 1
          EndIf
        EndIf
      EndIf
      ReDraw(*this)
      
    Case #PB_EventType_LeftButtonUp
      ; ПЕРЕМЕЩЕНИЕ КОЛОНКИ (МГНОВЕННОЕ)
      If *this\DragCol <> -1
        targetIdx = *this\TargetIdx
        SelectElement(*this\Columns(), *this\DragCol)
        Protected currentOrder = *this\Columns()\DisplayOrder
        
        If targetIdx > currentOrder : targetIdx - 1 : EndIf
        
        If targetIdx <> currentOrder
          ForEach *this\Columns()
            If currentOrder < targetIdx ; Двигаем вправо
              If *this\Columns()\DisplayOrder > currentOrder And *this\Columns()\DisplayOrder <= targetIdx
                *this\Columns()\DisplayOrder - 1
              EndIf
            Else ; Двигаем влево
              If *this\Columns()\DisplayOrder < currentOrder And *this\Columns()\DisplayOrder >= targetIdx
                *this\Columns()\DisplayOrder + 1
              EndIf
            EndIf
          Next
          SelectElement(*this\Columns(), *this\DragCol)
          *this\Columns()\DisplayOrder = targetIdx
        EndIf
      EndIf
      
      ; ПЕРЕМЕЩЕНИЕ СТРОКИ
      If *this\DragItem <> -1
        targetIdx = *this\TargetIdx
        If targetIdx > *this\DragItem : targetIdx - 1 : EndIf
        If targetIdx >= 0 And targetIdx < ListSize(*this\Items()) And targetIdx <> *this\DragItem
          SelectElement(*this\Items(), *this\DragItem) : *srcPtr = @*this\Items()
          SelectElement(*this\Items(), targetIdx) : MoveElement(*this\Items(), #PB_List_Before, *srcPtr)
        EndIf
      EndIf
      
      *this\DragCol = -1 : *this\DragItem = -1 : *this\ResizeCol = -1 : ReDraw(*this)
  EndSelect
EndProcedure

Procedure.i ListIcon(X, Y, Width, Height, Title.s, ColWidth.i)
  Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
  *this\GadgetID = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
  *this\ColHeight = 30 : *this\RowHeight = 25 : *this\ResizeCol = -1 : *this\DragCol = -1 : *this\DragItem = -1
  SetGadgetData(*this\GadgetID, *this)
  AddColumn(*this, -1, Title, ColWidth)
  ProcedureReturn *this
EndProcedure

; --- ПРИМЕР ---
CreateImage(0, 16, 16) : StartDrawing(ImageOutput(0)) : Box(0,0,16,16,$00FF00) : StopDrawing()
OpenWindow(0, 0, 0, 640, 400, "Logic Display Order (Fast)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

Global *MyList = ListIcon(10, 10, 620, 300, "Имя (Left)", 200)
AddColumn(*MyList, -1, "Возраст (Center)", 120, 0, #ALIGN_CENTER)
AddColumn(*MyList, -1, "Город (Right)", 180, -1, #ALIGN_RIGHT)

AddColumn(*MyList, 1, "add", 180, -1)

AddItem(*MyList, -1, "Александр" + Chr(10) + "31" + Chr(10) + "Москва", 0)
AddItem(*MyList, -1, "Елена" + Chr(10) + "24" + Chr(10) + "Владивосток")
AddItem(*MyList, -1, "Дмитрий" + Chr(10) + "45" + Chr(10) + "Тула")

Define i
For i = 1 To 10
  AddItem(*MyList, -1, "Пользователь " + Str(i) + Chr(10) + Str(Random(60, 18)))
Next

ButtonGadget(1, 10, 320, 150, 30, "Удалить 1-ю строку")
ButtonGadget(2, 170, 320, 150, 30, "Удалить 2-ю колонку")
ButtonGadget(3, 330, 320, 150, 30, "Очистить всё")

ReDraw(*MyList)

Repeat
  Define Event = WaitWindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Define *obj = GetGadgetData(EventGadget())
      If *obj ;And EventGadget() = *obj\GadgetID
        DoEvents(*obj)
      Else
        Select EventGadget()
          Case 1 : RemoveItem(*MyList, 0)
          Case 2 : RemoveColumn(*MyList, 1)
          Case 3 : ClearItems(*MyList)
        EndSelect
      EndIf
  EndSelect
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 137
; FirstLine = 118
; Folding = ------------
; EnableXP
; DPIAware