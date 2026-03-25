; =================================================================
; Модуль: CanvasListIcon (PureBasic)
; Возможности: Скролл, Drag&Drop, Resize, Edit, Sort, Icons, Checkboxes, AutoSize
; =================================================================

EnableExplicit

;- --- КОНСТАНТЫ ---
#ALIGN_LEFT   = 0
#ALIGN_CENTER = 1
#ALIGN_RIGHT  = 2

;- --- СТРУКТУРЫ ---
Structure _s_COLUMN
  Title.s
  Width.i
  Align.b
EndStructure

Structure _s_ITEM
  List ColText.s()
  List ColImage.i()
  SortKey.s
  Checked.b   ; Флаг чекбокса
  Selected.b
EndStructure

Structure _s_WIDGET
  GadgetID.i : ScrollVID.i : ScrollHID.i : EditID.i
  X.i : Y.i : W.i : H.i
  HeaderHeight.i : RowHeight.i
  HoverCol.i : ResizeCol.i : DragCol.i : DropCol.i ; <--- Добавили DropCol
  ColumnStartX.i : DragMouseX.i : CurrentDragX.i
  SortColumn.i : SortOrder.i
  EditRow.i : EditCol.i
  List Columns._s_COLUMN()
  List Items._s_ITEM()
EndStructure

;- --- РЕАЛИЗАЦИЯ ЛОГИКИ ---
Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro


; Перемещение колонок (Drag & Drop логика)
Procedure MoveColumnLogic(*this._s_WIDGET, FromIdx, ToIdx)
   If FromIdx = ToIdx : ProcedureReturn : EndIf
   
   ; Перемещаем саму колонку
   SelectElement(*this\Columns(), FromIdx)
   If FromIdx < ToIdx
      MoveElement(*this\Columns(), #PB_List_After, SelectElement(*this\Columns(), ToIdx))
   Else
      MoveElement(*this\Columns(), #PB_List_Before, SelectElement(*this\Columns(), ToIdx))
   EndIf
   
   ; Перемещаем данные (текст и картинки) во всех строках
   ForEach *this\Items()
      SelectElement(*this\Items()\ColText(), FromIdx)
      If FromIdx < ToIdx
         MoveElement(*this\Items()\ColText(), #PB_List_After, SelectElement(*this\Items()\ColText(), ToIdx))
      Else
         MoveElement(*this\Items()\ColText(), #PB_List_Before, SelectElement(*this\Items()\ColText(), ToIdx))
      EndIf
      
      SelectElement(*this\Items()\ColImage(), FromIdx)
      If FromIdx < ToIdx
         MoveElement(*this\Items()\ColImage(), #PB_List_After, SelectElement(*this\Items()\ColImage(), ToIdx))
      Else
         MoveElement(*this\Items()\ColImage(), #PB_List_Before, SelectElement(*this\Items()\ColImage(), ToIdx))
      EndIf
   Next
EndProcedure

; Обновление параметров скроллбаров
Procedure UpdateScrollState(*this._s_WIDGET)
  Protected SumW = 0, VisibleH = *this\H - *this\HeaderHeight
  Protected PageV = VisibleH / *this\RowHeight
  Protected Count = ListSize(*this\Items())
  ForEach *this\Columns() : SumW + *this\Columns()\Width : Next
  SetGadgetAttribute(*this\ScrollHID, #PB_ScrollBar_Maximum, SumW)
  SetGadgetAttribute(*this\ScrollHID, #PB_ScrollBar_PageLength, *this\W - 20)
  HideGadget(*this\ScrollHID, Bool(SumW <= *this\W - 20))
  SetGadgetAttribute(*this\ScrollVID, #PB_ScrollBar_Maximum, Count)
  SetGadgetAttribute(*this\ScrollVID, #PB_ScrollBar_PageLength, PageV)
  HideGadget(*this\ScrollVID, Bool(Count <= PageV))
EndProcedure

; Авто-подбор ширины колонки по содержимому
Procedure AutoSizeColumn(*this._s_WIDGET, Col)
  Protected maxW = 40, tw
  If Not StartDrawing(CanvasOutput(*this\GadgetID)) : ProcedureReturn : EndIf
  ; Ширина заголовка
  SelectElement(*this\Columns(), Col)
  maxW = TextWidth(*this\Columns()\Title) + 25
  ; Ширина данных
  ForEach *this\Items()
    SelectElement(*this\Items()\ColText(), Col)
    tw = TextWidth(*this\Items()\ColText()) + 15
    If Col = 0 : tw + 45 : EndIf ; Запас под чекбокс и иконку
    If tw > maxW : maxW = tw : EndIf
  Next
  StopDrawing()
  *this\Columns()\Width = maxW
  UpdateScrollState(*this)
EndProcedure

; Отрисовка всего контрола
Procedure RedrawCanvas(*this._s_WIDGET)
  Protected X, Y, txt.s, BgColor, i = 0, tx, tw, img, imgW
  Protected sx = GetGadgetState(*this\ScrollHID) ; Смещение по X
  Protected sy = GetGadgetState(*this\ScrollVID) ; Индекс первой строки
  
  If Not StartDrawing(CanvasOutput(*this\GadgetID)) : ProcedureReturn : EndIf
  Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
  
  ; --- ОТРИСОВКА СТРОК ---
  Y = *this\HeaderHeight
  ForEach *this\Items()
    If i >= sy And Y < OutputHeight()
      BgColor = $FFFFFF : If *this\Items()\Selected : BgColor = $F0D090 : EndIf
      Box(0, Y, OutputWidth(), *this\RowHeight, BgColor)
      X = -sx
      ForEach *this\Columns()
        ClipOutput(Max(0, X), Y, *this\Columns()\Width, *this\RowHeight)
        SelectElement(*this\Items()\ColText(), ListIndex(*this\Columns())) : txt = *this\Items()\ColText()
        SelectElement(*this\Items()\ColImage(), ListIndex(*this\Columns())) : img = *this\Items()\ColImage()
        
        DrawingMode(#PB_2DDrawing_Transparent)
        imgW = 0
        
        ; Отрисовка чекбокса в первой колонке
        If ListIndex(*this\Columns()) = 0
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(X + 5, Y + 6, 14, 14, $A0A0A0)
          If *this\Items()\Checked
            FillArea(X + 7, Y + 8, -1, $404040) ; Упрощенная отметка
          EndIf
          DrawingMode(#PB_2DDrawing_Transparent)
          imgW + 20
        EndIf
          
        ; Отрисовка иконки
        If img <> -1 And IsImage(img)
          DrawImage(ImageID(img), X + 5 + imgW, Y + 4, 16, 16)
          imgW + 20
        EndIf
        
        ; Выравнивание текста
        tw = TextWidth(txt)
        Select *this\Columns()\Align
          Case #ALIGN_CENTER : tx = X + (*this\Columns()\Width - tw)/2
          Case #ALIGN_RIGHT  : tx = X + *this\Columns()\Width - tw - 5
          Default            : tx = X + 5 + imgW
        EndSelect
        DrawText(tx, Y+4, txt, 0)
        UnclipOutput()
        Line(X + *this\Columns()\Width - 1, Y, 1, *this\RowHeight, $F0F0F0)
        X + *this\Columns()\Width
      Next
      Y + *this\RowHeight
    EndIf
    i + 1
  Next
  
  ; --- ОТРИСОВКА ЗАГОЛОВКА ---
  X = -sx : DrawingMode(#PB_2DDrawing_Default)
  ForEach *this\Columns()
    If ListIndex(*this\Columns()) <> *this\DragCol
      Protected HeadColor = $D0D0D0 : If ListIndex(*this\Columns()) = *this\HoverCol : HeadColor = $E5E5E5 : EndIf
      Box(X, 0, *this\Columns()\Width, *this\HeaderHeight, HeadColor)
      Line(X + *this\Columns()\Width - 1, 0, 1, *this\HeaderHeight, $808080)
      DrawText(X+5, 7, *this\Columns()\Title, 0, HeadColor)
    EndIf
    X + *this\Columns()\Width
  Next
  
  ; Отрисовка перетаскиваемой колонки
  If *this\DragCol <> -1 : SelectElement(*this\Columns(), *this\DragCol)
    Box(*this\CurrentDragX, 0, *this\Columns()\Width, *this\HeaderHeight, $A0A0A0)
    DrawText(*this\CurrentDragX+5, 7, *this\Columns()\Title, $FFFFFF)
  EndIf
  StopDrawing()
EndProcedure

;- --- API ФУНКЦИИ ---

Procedure AddColumn(*this._s_WIDGET, Title.s, Width, Align = #ALIGN_LEFT)
  AddElement(*this\Columns())
  *this\Columns()\Title = Title : *this\Columns()\Width = Width : *this\Columns()\Align = Align
  ForEach *this\Items()
    AddElement(*this\Items()\ColText()) : AddElement(*this\Items()\ColImage()) : *this\Items()\ColImage() = -1
  Next
EndProcedure

Procedure AddItem(*this._s_WIDGET, Text.s, Image = -1)
  Protected i
  AddElement(*this\Items())
  For i = 1 To ListSize(*this\Columns())
    AddElement(*this\Items()\ColText()) : AddElement(*this\Items()\ColImage()) : *this\Items()\ColImage() = -1
  Next
  FirstElement(*this\Items()\ColText()) : *this\Items()\ColText() = Text
  FirstElement(*this\Items()\ColImage()) : *this\Items()\ColImage() = Image
  UpdateScrollState(*this) : RedrawCanvas(*this)
EndProcedure

Procedure SetItemText(*this._s_WIDGET, Row, Col, Text.s)
  If SelectElement(*this\Items(), Row) And SelectElement(*this\Items()\ColText(), Col)
    *this\Items()\ColText() = Text : RedrawCanvas(*this)
  EndIf
EndProcedure

Procedure.s GetItemText(*this._s_WIDGET, Row, Col)
  If SelectElement(*this\Items(), Row) And SelectElement(*this\Items()\ColText(), Col)
    ProcedureReturn *this\Items()\ColText()
  EndIf
EndProcedure

Procedure SortListIcon(*this._s_WIDGET, Col)
  ForEach *this\Items() : SelectElement(*this\Items()\ColText(), Col) : *this\Items()\SortKey = *this\Items()\ColText() : Next
  If *this\SortColumn = Col : *this\SortOrder ! 1 : Else : *this\SortColumn = Col : *this\SortOrder = 0 : EndIf
  SortStructuredList(*this\Items(), *this\SortOrder, OffsetOf(_s_ITEM\SortKey), #PB_String)
  RedrawCanvas(*this)
EndProcedure

Procedure StartEdit(*this._s_WIDGET, Row, Col)
  Protected X = -GetGadgetState(*this\ScrollHID), Y = *this\HeaderHeight + (Row - GetGadgetState(*this\ScrollVID)) * *this\RowHeight, i
  For i = 0 To Col-1 : SelectElement(*this\Columns(), i) : X + *this\Columns()\Width : Next
  *this\EditID = StringGadget(#PB_Any, *this\X + X, *this\Y + Y, *this\Columns()\Width, *this\RowHeight, "", #PB_String_BorderLess)
  SetGadgetText(*this\EditID, GetItemText(*this, Row, Col))
  *this\EditRow = Row : *this\EditCol = Col : SetActiveGadget(*this\EditID)
EndProcedure

Procedure StopEdit(*this._s_WIDGET, Save = #True)
  If IsGadget(*this\EditID)
    If Save : SetItemText(*this, *this\EditRow, *this\EditCol, GetGadgetText(*this\EditID)) : EndIf
    FreeGadget(*this\EditID) : *this\EditID = 0 : SetActiveGadget(*this\GadgetID) : RedrawCanvas(*this)
  EndIf
EndProcedure

Procedure.i ListIcon(X, Y, w, h, Title.s, Width)
  Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
  *this\X=X : *this\Y=Y : *this\W=w : *this\H=h : *this\HeaderHeight=30 : *this\RowHeight=25 : *this\HoverCol=-1 : *this\ResizeCol=-1 : *this\DragCol=-1
  *this\GadgetID = CanvasGadget(#PB_Any, X, Y, w-20, h-20, #PB_Canvas_Keyboard)
  *this\ScrollVID = ScrollBarGadget(#PB_Any, X+w-20, Y, 20, h-20, 0, 1, 1, #PB_ScrollBar_Vertical)
  *this\ScrollHID = ScrollBarGadget(#PB_Any, X, Y+h-20, w-20, 20, 0, 1, 1)
  SetGadgetData(*this\GadgetID, *this) : SetGadgetData(*this\ScrollVID, *this) : SetGadgetData(*this\ScrollHID, *this)
  AddColumn(*this, Title, Width)
  ProcedureReturn *this
EndProcedure

;- --- ОБРАБОТКА СОБЫТИЙ ---

Procedure DoEvent_ListIcon(*this._s_WIDGET)
  Protected GID = EventGadget(), mx = GetGadgetAttribute(GID, #PB_Canvas_MouseX), my = GetGadgetAttribute(GID, #PB_Canvas_MouseY), et = EventType(), i
  Protected sx = GetGadgetState(*this\ScrollHID)
  Protected realMX = mx + sx
  
  If IsGadget(*this\EditID) : ProcedureReturn : EndIf 
  
  Select et
    Case #PB_EventType_MouseMove
      If *this\ResizeCol <> -1 ; РЕСАЙЗ
        SelectElement(*this\Columns(), *this\ResizeCol)
        *this\Columns()\Width = Max(20, realMX - *this\ColumnStartX) : RedrawCanvas(*this)
      ElseIf *this\DragCol <> -1 ; ПЕРЕМЕЩЕНИЕ КОЛОНКИ
        *this\CurrentDragX = mx - *this\DragMouseX : RedrawCanvas(*this)
      Else ; НАВЕДЕНИЕ
        Protected tx = -sx, foundB = -1 : *this\HoverCol = -1
        ForEach *this\Columns()
          If mx >= tx And mx < tx + *this\Columns()\Width And my < *this\HeaderHeight : *this\HoverCol = ListIndex(*this\Columns()) : EndIf
          tx + *this\Columns()\Width 
          If mx > tx - 5 And mx < tx + 5 And my < *this\HeaderHeight : foundB = ListIndex(*this\Columns()) : EndIf
        Next
        If foundB <> -1 : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_LeftRight) : Else : SetGadgetAttribute(GID, #PB_Canvas_Cursor, #PB_Cursor_Default) : EndIf
        RedrawCanvas(*this)
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      If GetGadgetAttribute(GID, #PB_Canvas_Cursor) = #PB_Cursor_LeftRight ; Начало ресайза
        Protected curX = -sx
        ForEach *this\Columns() 
          If mx > curX + *this\Columns()\Width-5 And mx < curX + *this\Columns()\Width+5 
            *this\ResizeCol = ListIndex(*this\Columns()) : *this\ColumnStartX = curX + sx : Break 
          EndIf : curX + *this\Columns()\Width 
        Next
      ElseIf my < *this\HeaderHeight ; Начало Drag&Drop колонки
        *this\DragCol = *this\HoverCol : Protected dx = -sx : For i=0 To *this\DragCol-1 : SelectElement(*this\Columns(), i) : dx + *this\Columns()\Width : Next 
        *this\DragMouseX = mx - dx
      Else ; Работа со строками
        ; Проверка клика по ЧЕКБОКСУ
        If mx >= -sx + 5 And mx <= -sx + 20
          Protected chkIdx = ((my - *this\HeaderHeight) / *this\RowHeight) + GetGadgetState(*this\ScrollVID)
          If SelectElement(*this\Items(), chkIdx)
            *this\Items()\Checked ! 1 : RedrawCanvas(*this) : ProcedureReturn
          EndIf
        EndIf
        ; Выбор строки
        Protected idx = ((my - *this\HeaderHeight) / *this\RowHeight) + GetGadgetState(*this\ScrollVID)
        If idx >= 0 And idx < ListSize(*this\Items())
          If Not (GetGadgetAttribute(GID, #PB_Canvas_Modifiers) & #PB_Canvas_Control) : ForEach *this\Items() : *this\Items()\Selected = 0 : Next : EndIf
          SelectElement(*this\Items(), idx) : *this\Items()\Selected ! 1 : RedrawCanvas(*this)
        EndIf
      EndIf
      
    Case #PB_EventType_LeftDoubleClick
      If GetGadgetAttribute(GID, #PB_Canvas_Cursor) = #PB_Cursor_LeftRight ; АВТОПОДБОР
        Protected autoX = -sx, cIdx = 0
        ForEach *this\Columns()
          If mx > autoX + *this\Columns()\Width-5 And mx < autoX + *this\Columns()\Width+5
            AutoSizeColumn(*this, cIdx) : RedrawCanvas(*this) : Break
          EndIf
          autoX + *this\Columns()\Width : cIdx + 1
        Next
      ElseIf my > *this\HeaderHeight ; РЕДАКТИРОВАНИЕ
        StartEdit(*this, ((my - *this\HeaderHeight) / *this\RowHeight) + GetGadgetState(*this\ScrollVID), *this\HoverCol)
      EndIf
      
        Case #PB_EventType_LeftButtonUp
      If *this\DragCol <> -1 
        Protected target = -1, targetX = -sx
        ; Ищем над какой колонкой отпустили мышь
        ForEach *this\Columns()
          If mx >= targetX And mx < targetX + *this\Columns()\Width
            target = ListIndex(*this\Columns())
            Break
          EndIf
          targetX + *this\Columns()\Width
        Next
        
        ; Если нашли цель - перемещаем и ОБЯЗАТЕЛЬНО обновляем состояние
        If target <> -1 And target <> *this\DragCol
          MoveColumnLogic(*this, *this\DragCol, target)
          UpdateScrollState(*this) ; Чтобы скролл пересчитал границы если надо
        EndIf
      EndIf
      
      *this\DragCol = -1 
      *this\ResizeCol = -1 
      RedrawCanvas(*this)

    Case #PB_EventType_MouseWheel
      SetGadgetState(*this\ScrollVID, GetGadgetState(*this\ScrollVID) - GetGadgetAttribute(GID, #PB_Canvas_WheelDelta)) : RedrawCanvas(*this)
  EndSelect
EndProcedure

;- --- ПРИМЕР ИСПОЛЬЗОВАНИЯ ---

CompilerIf #PB_Compiler_IsMainFile
  OpenWindow(0, 0, 0, 600, 400, "Advanced Canvas ListIcon", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  AddKeyboardShortcut(0, #PB_Shortcut_Return, 1)
  
  Global *L = ListIcon(10, 10, 580, 380, "Имя файла", 200)
  AddColumn(*L, "Размер", 100, #ALIGN_RIGHT)
  AddColumn(*L, "Тип", 100, #ALIGN_CENTER)
  
  AddItem(*L, "Notes.txt") : SetItemText(*L, 0, 1, "14 KB") : SetItemText(*L, 0, 2, "Text")
  AddItem(*L, "Image.png") : SetItemText(*L, 1, 1, "2.4 MB") : SetItemText(*L, 1, 2, "Image")
  AddItem(*L, "Huge_Database_File_Backup.sql") : SetItemText(*L, 2, 1, "1.2 GB") : SetItemText(*L, 2, 2, "SQL")
  
  Repeat
    Define ev = WaitWindowEvent()
    If ev = #PB_Event_Menu And EventMenu() = 1 : StopEdit(*L) : EndIf
    If ev = #PB_Event_Gadget
      Define *obj._s_WIDGET = GetGadgetData(EventGadget())
      If *obj
        ; Обработка и скроллов, и холста
        If EventGadget() = *obj\ScrollVID Or EventGadget() = *obj\ScrollHID
          RedrawCanvas(*obj)
        Else
          DoEvent_ListIcon(*obj)
        EndIf
      EndIf
    EndIf
  Until ev = #PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 158
; FirstLine = 138
; Folding = -----------
; EnableXP
; DPIAware