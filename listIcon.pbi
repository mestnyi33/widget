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

; --- Отрисовка ---
Procedure ReDraw(*this._s_WIDGET)
  Protected X, Y, txt.s, BgColor, CurX, tx, tw, colIdx, mx, my, i
  If Not *this Or Not IsGadget(*this\GadgetID) : ProcedureReturn : EndIf
  
  mx = GetGadgetAttribute(*this\GadgetID, #PB_Canvas_MouseX)
  my = GetGadgetAttribute(*this\GadgetID, #PB_Canvas_MouseY)
  
  If StartDrawing(CanvasOutput(*this\GadgetID))
    Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF) 
    
    ; 1. Строки
    Y = *this\ColHeight
    ForEach *this\Items()
      colIdx = ListIndex(*this\Items())
      BgColor = $FFFFFF : If *this\Items()\Selected : BgColor = $F0D090 : EndIf
      If colIdx = *this\DragItem : BgColor = $F5F5F5 : EndIf
      
      Box(0, Y, OutputWidth(), *this\RowHeight, BgColor)
      X = 0
      ForEach *this\Columns()
        colIdx = ListIndex(*this\Columns())
        ClipOutput(X, Y, *this\Columns()\Width, *this\RowHeight)
        SelectElement(*this\Items()\ColText(), colIdx)
        txt = *this\Items()\ColText()
        
        DrawingMode(#PB_2DDrawing_Transparent)
        CurX = X + 5
        If colIdx = 0 
          Box(CurX, Y+6, 12, 12, $808080) : Box(CurX+1, Y+7, 10, 10, $FFFFFF)
          If *this\Items()\Checked : DrawText(CurX+2, Y+3, "v", $FF0000) : EndIf
          CurX + 20
          If *this\Items()\img <> -1 And IsImage(*this\Items()\img)
            DrawImage(ImageID(*this\Items()\img), CurX, Y + (*this\RowHeight-16)/2, 16, 16)
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
    
    ; 2. Шапка
    X = 0 : DrawingMode(#PB_2DDrawing_Transparent)
    ForEach *this\Columns()
      Protected HeadColor = $D0D0D0 : If ListIndex(*this\Columns()) = *this\HoverCol : HeadColor = $E5E5E5 : EndIf
      If ListIndex(*this\Columns()) = *this\DragCol : HeadColor = $AAAAAA : EndIf
      
      Box(X, 0, *this\Columns()\Width, *this\ColHeight, HeadColor)
      Line(X + *this\Columns()\Width - 1, 0, 1, *this\ColHeight, $808080)
      
      txt = *this\Columns()\Title : tw = TextWidth(txt)
      Select *this\Columns()\Align
        Case #ALIGN_CENTER : tx = X + (*this\Columns()\Width - tw) / 2
        Case #ALIGN_RIGHT  : tx = X + *this\Columns()\Width - tw - 5
        Default            : tx = X + 5
      EndSelect
      DrawText(tx, 7, txt, 0)
      X + *this\Columns()\Width
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
      For i = 0 To *this\TargetIdx - 1 : SelectElement(*this\Columns(), i) : lineX + *this\Columns()\Width : Next
      Line(lineX, 0, 2, *this\ColHeight, $FF0000FF)
    EndIf
    StopDrawing()
  EndIf
EndProcedure

; --- API Добавления ---
Procedure.i AddColumn(*this._s_WIDGET, position.l, Text.s, Width.l, img.i = -1, Align.b = #ALIGN_LEFT)
  If position = -1 : AddElement(*this\Columns()) : Else : SelectElement(*this\Columns(), position) : InsertElement(*this\Columns()) : EndIf
  *this\Columns()\Title = Text : *this\Columns()\Width = Width : *this\Columns()\img = img : *this\Columns()\Align = Align
  Protected colIdx = ListIndex(*this\Columns())
  ForEach *this\Items() : SelectElement(*this\Items()\ColText(), colIdx) : InsertElement(*this\Items()\ColText()) : Next
  ProcedureReturn colIdx
EndProcedure

Procedure.i AddItem(*this._s_WIDGET, Item.l, Text.s, img.i = -1)
   If ListSize(*this\Columns())
      Protected i
      If Item = -1 : AddElement(*this\Items()) : Else : SelectElement(*this\Items(), Item) : InsertElement(*this\Items()) : EndIf
      *this\Items()\img = img
      
      ; Наполняем данными строго по количеству существующих колонок
      ForEach *this\Columns()
         AddElement(*this\Items()\ColText()) 
         *this\Items()\ColText() = StringField(Text, i+1, Chr(10)) 
         i + 1
      Next
      ProcedureReturn @*this\Items()
   EndIf
EndProcedure

; --- API Удаления (НОВОЕ) ---
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
  ; Если индекс некорректен или колонок уже нет - выходим
  If Not *this Or Index < 0 Or Index >= ListSize(*this\Columns()) : ProcedureReturn : EndIf
  
  ; Очищаем данные в строках
  ForEach *this\Items()
    If SelectElement(*this\Items()\ColText(), Index)
      DeleteElement(*this\Items()\ColText())
    EndIf
  Next
  
  ; Удаляем саму колонку
  SelectElement(*this\Columns(), Index)
  DeleteElement(*this\Columns())
  
  ; ОБЯЗАТЕЛЬНО: сбрасываем индексы интерактива
  *this\DragCol = -1
  *this\HoverCol = -1
  *this\ResizeCol = -1 
  
  ReDraw(*this)
EndProcedure

Procedure.i ListIcon(X, Y, Width, Height, Title.s, ColWidth.i)
  Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
  *this\GadgetID = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard)
  *this\ColHeight = 30 : *this\RowHeight = 25 : *this\ResizeCol = -1 : *this\DragCol = -1 : *this\DragItem = -1
  SetGadgetData(*this\GadgetID, *this)
  AddColumn(*this, -1, Title, ColWidth)
  ProcedureReturn *this
EndProcedure

; --- СОБЫТИЯ ---
Procedure DoEvents(*this._s_WIDGET)
  If Not *this : ProcedureReturn : EndIf
  Protected GID = *this\GadgetID, mx = GetGadgetAttribute(GID, #PB_Canvas_MouseX), my = GetGadgetAttribute(GID, #PB_Canvas_MouseY)
  Protected curX, idx, targetIdx, *srcPtr, i
  
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
        ForEach *this\Columns()
          curX + *this\Columns()\Width
          If mx > curX - *this\Columns()\Width/2 : *this\TargetIdx = ListIndex(*this\Columns()) + 1 : EndIf
        Next
      Else
        curX = 0 : *this\HoverCol = -1
        ForEach *this\Columns()
          curX + *this\Columns()\Width
          If mx > curX - 5 And mx < curX + 5 And my < *this\ColHeight
            SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
            *this\HoverCol = ListIndex(*this\Columns()) : Break
          EndIf
          If mx >= curX - *this\Columns()\Width And mx < curX And my < *this\ColHeight : *this\HoverCol = ListIndex(*this\Columns()) : EndIf
        Next
        If *this\HoverCol = -1 : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_Default) : EndIf
      EndIf
      ReDraw(*this)
      
    Case #PB_EventType_LeftButtonDown
      curX = 0
      ForEach *this\Columns()
        curX + *this\Columns()\Width
        If mx > curX - 5 And mx < curX + 5 And my < *this\ColHeight
          *this\ResizeCol = ListIndex(*this\Columns()) : *this\MoveColX = curX - *this\Columns()\Width : ProcedureReturn
        EndIf
      Next
      
      If my < *this\ColHeight 
        curX = 0
        ForEach *this\Columns()
          curX + *this\Columns()\Width
          If mx < curX : *this\DragCol = ListIndex(*this\Columns()) : *this\MouseOffX = mx - (curX - *this\Columns()\Width) : Break : EndIf
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
      If *this\DragCol <> -1
        targetIdx = *this\TargetIdx
        If targetIdx > *this\DragCol : targetIdx - 1 : EndIf ; Коррекция индекса для MoveElement
        If targetIdx >= 0 And targetIdx < ListSize(*this\Columns()) And targetIdx <> *this\DragCol
          SelectElement(*this\Columns(), *this\DragCol) : *srcPtr = @*this\Columns()
          SelectElement(*this\Columns(), targetIdx) : MoveElement(*this\Columns(), #PB_List_Before, *srcPtr)
          ForEach *this\Items()
            SelectElement(*this\Items()\ColText(), *this\DragCol) : *srcPtr = @*this\Items()\ColText()
            SelectElement(*this\Items()\ColText(), targetIdx) : MoveElement(*this\Items()\ColText(), #PB_List_Before, *srcPtr)
          Next
        EndIf
      EndIf
      
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

; --- ПРИМЕР ---
CreateImage(0, 16, 16) : StartDrawing(ImageOutput(0)) : Box(0,0,16,16,$00FF00) : StopDrawing()
OpenWindow(0, 0, 0, 640, 400, "Classic 3-List Drag & Drop + API", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

Global *MyList = ListIcon(10, 10, 620, 300, "Имя (Left)", 200)
AddColumn(*MyList, -1, "Возраст (Center)", 120, 0, #ALIGN_CENTER)
AddColumn(*MyList, -1, "Город (Right)", 180, -1, #ALIGN_RIGHT)

AddColumn(*MyList, 1, "add", 180, -1)

AddItem(*MyList, -1, "Александр" + Chr(10) + "31" + Chr(10) + "Москва", 0)
AddItem(*MyList, -1, "Елена" + Chr(10) + "24" + Chr(10) + "Владивосток")
AddItem(*MyList, -1, "Дмитрий" + Chr(10) + "45" + Chr(10) + "Тула")

Define i
For i = 1 To 5;000
  AddItem(*MyList, -1, "Пользователь " + Str(i) + Chr(10) + Str(Random(60, 18)))
Next

; Кнопки для теста новых функций
ButtonGadget(1, 10, 320, 150, 30, "Удалить 1-ю строку")
ButtonGadget(2, 170, 320, 150, 30, "Удалить 2-ю колонку")
ButtonGadget(3, 330, 320, 150, 30, "Очистить всё")

ReDraw(*MyList)

Repeat
  Define Event = WaitWindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 1 : RemoveItem(*MyList, 0)
        Case 2 : RemoveColumn(*MyList, 1)
        Case 3 : ClearItems(*MyList)
        Default
          Define *obj = GetGadgetData(EventGadget())
          If *obj : DoEvents(*obj) : EndIf
      EndSelect
  EndSelect
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 331
; FirstLine = 304
; Folding = ----------
; EnableXP
; DPIAware