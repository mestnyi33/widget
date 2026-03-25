EnableExplicit

;- --- 1. СТРУКТУРЫ ---
Structure _s_TEXT : Array Str.s(0) : EndStructure

Structure _s_ROWS
  Text._s_TEXT : Level.i : Height.i : Hide.b : IsSelected.b : IsGroup.b : IsFolded.b
EndStructure

Structure _s_COLUMN
  Text._s_TEXT : Width.i : X.i : Hide.b
EndStructure

Structure _s_VISIBLEITEMS
  *firstElement : *lastElement 
EndStructure

Structure _s_WIDGET
  X.i : Y.i : Width.i : Height.i : HeaderHeight.i : RowHeight.i
  List __rows._s_ROWS()            ; База данных
  List *__Items._s_ROWS()          ; Визуальный рулон
  List __columns._s_COLUMN()       ; Колонки
  *HoverItem._s_ROWS : *HoverColumn._s_COLUMN
  visible._s_VISIBLEITEMS
  scroll_v_pos.i : scroll_h_pos.i
  IsScrollingH.b
  *root.struct_ROOT                ; Ссылка на корень
EndStructure

Structure struct_ROOT
  CanvasGadget.i : Window.i : Width.i : Height.i
  *ActiveWidget._s_WIDGET
  *DragColumn._s_COLUMN : *DragItem._s_ROWS : *ResizingColumn._s_COLUMN
  List widgets._s_WIDGET()
EndStructure

Global Root.struct_ROOT

;- --- 2. ЛОГИКА ---

Procedure Column_UpdateLayout(*this._s_WIDGET)
  Protected cur_x = 0
  ForEach *this\__columns()
    If Not *this\__columns()\Hide
      *this\__columns()\X = cur_x
      cur_x + *this\__columns()\Width
    EndIf
  Next
EndProcedure

Procedure Column_Sync(*this._s_WIDGET)
  ClearList(*this\__Items())
  ForEach *this\__rows()
    If Not *this\__rows()\Hide
      AddElement(*this\__Items()) : *this\__Items() = @*this\__rows()
    EndIf
  Next
EndProcedure

Procedure Column_ToggleGroup(*this._s_WIDGET, *group._s_ROWS)
  If Not *group\IsGroup : ProcedureReturn : EndIf
  *group\IsFolded ! 1
  Protected CurrentLevel = *group\Level
  PushListPosition(*this\__rows())
  ChangeCurrentElement(*this\__rows(), *group)
  While NextElement(*this\__rows()) And *this\__rows()\Level > CurrentLevel
    *this\__rows()\Hide = *group\IsFolded
  Wend
  PopListPosition(*this\__rows())
  Column_Sync(*this)
EndProcedure

Procedure Column_AutoSizeColumn(*this._s_WIDGET, ColumnIndex.i)
  Protected max_w = 0, txt_w = 0
  If StartDrawing(CanvasOutput(Root\CanvasGadget))
    SelectElement(*this\__columns(), ColumnIndex)
    max_w = TextWidth(*this\__columns()\Text\Str(0)) + 30
    ForEach *this\__rows()
      Protected off = 0 : If ColumnIndex = 0 : off = *this\__rows()\Level * 16 + 20 : EndIf
      txt_w = TextWidth(*this\__rows()\Text\Str(ColumnIndex)) + 20 + off
      If txt_w > max_w : max_w = txt_w : EndIf
    Next
    *this\__columns()\Width = max_w : StopDrawing()
    Column_UpdateLayout(*this)
  EndIf
EndProcedure

;- --- 3. РЕНДЕРИНГ ---

Procedure ReDraw(*root.struct_ROOT)
  If StartDrawing(CanvasOutput(*root\CanvasGadget))
    Box(0, 0, *root\Width, *root\Height, $F0F0F0)
    ForEach *root\widgets()
      Protected *this._s_WIDGET = @*root\widgets()
      
      ; 1. ШАПКА
      ClipOutput(*this\X, *this\Y, *this\Width, *this\HeaderHeight)
      ForEach *this\__columns()
        Protected cx = (*this\X + *this\__columns()\X) - *this\scroll_h_pos
        Protected clr = $E5E5E5 : If @*this\__columns() = *this\HoverColumn : clr = $D8D8D8 : EndIf
        Box(cx, *this\Y, *this\__columns()\Width, *this\HeaderHeight, clr)
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(cx + 5, *this\Y + 7, *this\__columns()\Text\Str(0), $000000)
        Line(cx + *this\__columns()\Width - 1, *this\Y, 1, *this\HeaderHeight, $B0B0B0)
      Next
      UnclipOutput()
      
      ; 2. ТЕЛО
      Protected cur_y = (*this\Y + *this\HeaderHeight) - *this\scroll_v_pos
      *this\visible\firstElement = 0 : *this\visible\lastElement = 0
      ClipOutput(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height - *this\HeaderHeight - 6)
      Box(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height, $FFFFFF)
      
      ForEach *this\__Items()
        Protected *row._s_ROWS = *this\__Items()
        If cur_y + *row\Height < *this\Y + *this\HeaderHeight : cur_y + *row\Height : Continue : EndIf
        If cur_y > *this\Y + *this\Height - 6 : Break : EndIf
        
        If Not *this\visible\firstElement : *this\visible\firstElement = @*this\__Items() : EndIf
        *this\visible\lastElement = @*this\__Items()
        
        ; Фон (Зебра / Hover / Select)
        If *row\IsSelected : Box(*this\X, cur_y, *this\Width, *row\Height, $D1E5FE)
        ElseIf *row = *this\HoverItem : Box(*this\X, cur_y, *this\Width, *row\Height, $F5F5F5)
        ElseIf ListIndex(*this\__Items()) % 2 = 0 : Box(*this\X, cur_y, *this\Width, *row\Height, $FAFAFA)
        EndIf
        
        ForEach *this\__columns()
          Protected col_x = (*this\X + *this\__columns()\X) - *this\scroll_h_pos
          Protected off = 0 : If ListIndex(*this\__columns()) = 0 : off = *row\Level * 16 + 18 : EndIf
          DrawText(col_x + 5 + off, cur_y + 4, *row\Text\Str(ListIndex(*this\__columns())), $000000)
          If *row\IsGroup And ListIndex(*this\__columns()) = 0
            Circle(col_x + off - 10, cur_y + 12, 4, $808080)
          EndIf
        Next
        Line(*this\X, cur_y + *row\Height - 1, *this\Width, 1, $EEEEEE)
        cur_y + *row\Height
      Next
      UnclipOutput()
      
      ; 3. ГОРИЗОНТАЛЬНЫЙ СКРОЛЛ
      Protected total_w = 0 : ForEach *this\__columns() : total_w + *this\__columns()\Width : Next
      If total_w > *this\Width
        Protected sw = (*this\Width * *this\Width) / total_w
        Protected sx = *this\X + (*this\scroll_h_pos * (*this\Width - sw)) / (total_w - *this\Width)
        Box(*this\X, *this\Y + *this\Height - 6, *this\Width, 6, $F0F0F0)
        Box(sx, *this\Y + *this\Height - 5, sw, 4, $C0C0C0)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined) : Box(*this\X, *this\Y, *this\Width, *this\Height, $A0A0A0)
    Next
    StopDrawing()
  EndIf
EndProcedure

;- --- 4. СОБЫТИЯ ---

Procedure Column_HandleSwap(*this._s_WIDGET, mx, my)
  Protected *root.struct_ROOT = *this\root
  If *root\DragColumn
    ForEach *this\__columns()
      If @*this\__columns() = *root\DragColumn : Continue : EndIf
      Protected cx = *this\X + *this\__columns()\X - *this\scroll_h_pos
      If mx > cx And mx < cx + *this\__columns()\Width
        Protected *target = @*this\__columns()
        PushListPosition(*this\__columns()) : ChangeCurrentElement(*this\__columns(), *root\DragColumn)
        MoveElement(*this\__columns(), #PB_List_Before, *target) : PopListPosition(*this\__columns())
        Column_UpdateLayout(*this) : Break
      EndIf
    Next
;   ElseIf *root\DragItem And *this\HoverItem
;     If *this\HoverItem <> *root\DragItem
;       PushListPosition(*this\__Items())
;       ForEach *this\__Items() : If *this\__Items() = *root\DragItem : MoveElement(*this\__Items(), #PB_List_Before, *this\HoverItem) : Break : EndIf : Next
;       PopListPosition(*this\__Items())
;     EndIf
;   EndIf
      ElseIf *root\DragItem And *this\HoverItem
    If *this\HoverItem <> *root\DragItem
      ; 1. Запоминаем, куда хотим вставить
      Protected *targetElement = *this\visible\lastElement ; Временный буфер для поиска
      
      ; 2. Находим элемент-цель (HoverItem) и элемент-донор (DragItem) в списке узлов
      PushListPosition(*this\__Items())
      
      Protected *hoverNode = 0, *dragNode = 0
      ForEach *this\__Items()
        If *this\__Items() = *this\HoverItem : *hoverNode = @*this\__Items() : EndIf
        If *this\__Items() = *root\DragItem  : *dragNode  = @*this\__Items() : EndIf
        If *hoverNode And *dragNode : Break : EndIf
      Next
      
      ; 3. Если оба узла найдены — двигаем
      If *hoverNode And *dragNode
        ChangeCurrentElement(*this\__Items(), *dragNode)
        MoveElement(*this\__Items(), #PB_List_Before, *hoverNode)
      EndIf
      
      PopListPosition(*this\__Items())
    EndIf
  EndIf

EndProcedure

Procedure Column_HandleEvents(*root.struct_ROOT, et)
  Protected mx = GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_MouseX)
  Protected my = GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_MouseY)

  ForEach *root\widgets()
    Protected *this._s_WIDGET = @*root\widgets()
   *this\HoverColumn = 0 : *this\HoverItem = 0
   
   If mx >= *this\X And mx <= *this\X + *this\Width And my >= *this\Y And my <= *this\Y + *this\Height
      *root\ActiveWidget = *this
      
      ForEach *this\__columns()
         If mx - *this\X + *this\scroll_h_pos >= *this\__columns()\X And mx - *this\X + *this\scroll_h_pos <= *this\__columns()\X + *this\__columns()\Width And 
            my - *this\y + *this\scroll_v_pos >= 0 And my - *this\y + *this\scroll_v_pos <= *this\HeaderHeight
            *this\HoverColumn = @*this\__columns() : Break
         EndIf
      Next
      
      If *this\visible\firstElement
        Protected cy = (*this\Y + *this\HeaderHeight) - *this\scroll_v_pos
        PushListPosition(*this\__Items()) : ChangeCurrentElement(*this\__Items(), *this\visible\firstElement)
        Repeat
          If my >= cy And my < cy + *this\__Items()\Height : *this\HoverItem = *this\__Items() : Break : EndIf
          cy + *this\__Items()\Height
        Until @*this\__Items() = *this\visible\lastElement Or Not NextElement(*this\__Items())
        PopListPosition(*this\__Items())
      EndIf
    EndIf
  Next
  
  If Not *root\ActiveWidget : ProcedureReturn : EndIf
  *this = *root\ActiveWidget
  
  Select et
    Case #PB_EventType_LeftButtonDown
      If my > *this\Y + *this\Height - 10 : *this\IsScrollingH = #True : ProcedureReturn : EndIf
      If *this\HoverColumn
        Protected edge = *this\X + *this\HoverColumn\X + *this\HoverColumn\Width - *this\scroll_h_pos
        If Abs(mx - edge) < 8 : *root\ResizingColumn = *this\HoverColumn : Else : *root\DragColumn = *this\HoverColumn : EndIf
      EndIf
      If Not *root\ResizingColumn And *this\HoverItem
        *root\DragItem = *this\HoverItem
        If mx < *this\X + 60 And *this\HoverItem\IsGroup : Column_ToggleGroup(*this, *this\HoverItem) : EndIf
        ForEach *this\__rows() : *this\__rows()\IsSelected = #False : Next : *this\HoverItem\IsSelected = #True
      EndIf
      
    Case #PB_EventType_MouseMove
      If *this\IsScrollingH
        Protected tw = 0 : ForEach *this\__columns() : tw + *this\__columns()\Width : Next
        *this\scroll_h_pos = ((mx - *this\X) * (tw - *this\Width)) / *this\Width
        If *this\scroll_h_pos < 0 : *this\scroll_h_pos = 0 : EndIf : If *this\scroll_h_pos > tw - *this\Width : *this\scroll_h_pos = tw - *this\Width : EndIf
      ElseIf *root\ResizingColumn
        *root\ResizingColumn\Width = (mx + *this\scroll_h_pos) - (*this\X + *root\ResizingColumn\X)
        If *root\ResizingColumn\Width < 20 : *root\ResizingColumn\Width = 20 : EndIf
        Column_UpdateLayout(*this)
      ElseIf *root\DragColumn Or *root\DragItem : Column_HandleSwap(*this, mx, my) : EndIf
      
    Case #PB_EventType_LeftButtonUp : *root\ResizingColumn = 0 : *root\DragColumn = 0 : *root\DragItem = 0 : *this\IsScrollingH = #False
      
    Case #PB_EventType_LeftDoubleClick
      If *this\HoverColumn : Column_AutoSizeColumn(*this, ListIndex(*this\__columns())) : EndIf
      
    Case #PB_EventType_MouseWheel
      *this\scroll_v_pos - (GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_WheelDelta) * *this\RowHeight * 2)
      If *this\scroll_v_pos < 0 : *this\scroll_v_pos = 0 : EndIf
  EndSelect
  ReDraw(*root)
EndProcedure

Procedure Column_AddItem(*this._s_WIDGET, Text$, Level=0, isgroup=#False)
  AddElement(*this\__rows()) : Protected i, TotalCols = ListSize(*this\__columns()) - 1
  ReDim *this\__rows()\Text\Str(TotalCols)
  For i = 0 To TotalCols : *this\__rows()\Text\Str(i) = StringField(Text$, i + 1, #LF$) : Next
  *this\__rows()\Level = Level : *this\__rows()\Height = *this\RowHeight : *this\__rows()\IsGroup = isgroup
  Column_Sync(*this)
EndProcedure

;- --- 5. ЗАПУСК ---
OpenWindow(0, 0, 0, 800, 600, "Master 2D Listicon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
Root\CanvasGadget = CanvasGadget(#PB_Any, 0, 0, 800, 600, #PB_Canvas_Keyboard)
Root\Width = 800 : Root\Height = 600

AddElement(Root\widgets()) : Define *w._s_WIDGET = @Root\widgets() : *w\root = @Root
*w\X = 10 : *w\Y = 10 : *w\Width = 780 : *w\Height = 580 : *w\HeaderHeight = 30 : *w\RowHeight = 25
AddElement(*w\__columns()) : *w\__columns()\Text\Str(0) = "Имя файла" : *w\__columns()\Width = 200
AddElement(*w\__columns()) : *w\__columns()\Text\Str(0) = "Размер" : *w\__columns()\Width = 100
AddElement(*w\__columns()) : *w\__columns()\Text\Str(0) = "Дата изменения" : *w\__columns()\Width = 150
Column_UpdateLayout(*w)

Column_AddItem(*w, "Мои документы" + #LF$ + "<DIR>" + #LF$ + "20.03.2024", 0, #True)
Define i : For i = 1 To 20 : Column_AddItem(*w, "Отчет_" + Str(i) + ".pdf" + #LF$ + Str(Random(1000)) + " KB" + #LF$ + "15.01.2024", 1) : Next
Column_Sync(*w) : ReDraw(@Root)

Repeat
  Define ev = WaitWindowEvent()
  If ev = #PB_Event_Gadget And EventGadget() = Root\CanvasGadget : Column_HandleEvents(@Root, EventType()) : EndIf
Until ev = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 220
; FirstLine = 212
; Folding = ----------
; EnableXP
; DPIAware