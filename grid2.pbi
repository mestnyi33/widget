EnableExplicit

;- --- КОНСТАНТЫ СОСТОЯНИЙ ---
EnumerationBinary
  #State_None
  #State_Hovered
  #State_Splitter
  #State_ColumnDrag
  #State_ItemDrag
  #State_Captured
EndEnumeration

;- --- СТРУКТУРЫ ---

Structure _s_ITEM
  Title.s : Value.s
  Level.i : Height.i
  Hide.b : IsSelected.b : IsGroup.b : IsFolded.b
EndStructure

Structure _s_COLUMN
  Title.s : Width.i : X.i : Hide.b
EndStructure

Structure _s_WIDGET
  X.i : Y.i : Width.i : Height.i
  HeaderHeight.i : RowHeight.i : ScrollSize.i
  ScrollV.i : ScrollH.i : State.i
  *FirstVisible._s_ITEM : *LastVisible._s_ITEM
  *HoverItem._s_ITEM : *HoverColumn._s_COLUMN
  List Items._s_ITEM()
  List *ExpandedItems._s_ITEM()
  List Columns._s_COLUMN()
EndStructure

Structure _s_CANVAS
  Gadget.i : Window.i : Width.i : Height.i
EndStructure

Structure _s_ROOT
  Canvas._s_CANVAS
  *ActiveWidget._s_WIDGET
  *DragColumn._s_COLUMN : *DragItem._s_ITEM
  *ResizingColumn._s_COLUMN
  List widgets._s_WIDGET()
EndStructure

Global Root._s_ROOT

;- --- МАКРОСЫ ---
Macro GetActive() : Root\ActiveWidget : EndMacro

;- --- ЯДРО И ОБРАБОТКА ДАННЫХ ---

Procedure Widget_UpdateLayout(*this._s_WIDGET)
  Protected cur_x = 0
  ForEach *this\Columns()
    If Not *this\Columns()\Hide
      *this\Columns()\X = cur_x
      cur_x + *this\Columns()\Width
    EndIf
  Next
EndProcedure

Procedure Widget_Sync(*this._s_WIDGET)
  ClearList(*this\ExpandedItems())
  ForEach *this\Items()
    If Not *this\Items()\Hide
      AddElement(*this\ExpandedItems())
      *this\ExpandedItems() = @*this\Items()
    EndIf
  Next
EndProcedure

;- --- ОТРИСОВКА ---

Procedure ReDraw(*root._s_ROOT)
  If StartDrawing(CanvasOutput(*root\Canvas\Gadget))
    Box(0, 0, *root\Canvas\Width, *root\Canvas\Height, $F2F2F2)
    
    ForEach *root\Widgets()
      Protected *this._s_WIDGET = @*root\Widgets()
      Protected cur_y = (*this\Y + *this\HeaderHeight) - *this\ScrollV
      *this\FirstVisible = 0 : *this\LastVisible = 0
      
      ; 1. ШАПКА
      ClipOutput(*this\X, *this\Y, *this\Width, *this\HeaderHeight)
      Box(*this\X, *this\Y, *this\Width, *this\HeaderHeight, $E0E0E0)
      ForEach *this\Columns()
        If Not *this\Columns()\Hide
          Protected cx = (*this\X + *this\Columns()\X) - *this\ScrollH
          Box(cx, *this\Y, *this\Columns()\Width, *this\HeaderHeight, $E0E0E0)
          DrawText(cx + 5, *this\Y + 7, *this\Columns()\Title, $000000)
          Line(cx + *this\Columns()\Width - 1, *this\Y, 1, *this\HeaderHeight, $B0B0B0)
        EndIf
      Next
      UnclipOutput()
      
      ; 2. ИТЕМЫ
      ClipOutput(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height - *this\HeaderHeight)
      Box(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height - *this\HeaderHeight, $FFFFFF)
      
      ForEach *this\ExpandedItems()
        Protected *it._s_ITEM = *this\ExpandedItems()
        
        ; Фильтр окошка
        If cur_y + *it\Height < *this\Y + *this\HeaderHeight : cur_y + *it\Height : Continue : EndIf
        If cur_y > *this\Y + *this\Height : Break : EndIf
        
        If Not *this\FirstVisible : *this\FirstVisible = *it : EndIf
        *this\LastVisible = *it
        
        ; Отрисовка строки
        If *it = Root\DragItem : Box(*this\X, cur_y, *this\Width, *it\Height, $EEEEEE) : EndIf
        If *it\IsSelected : Box(*this\X, cur_y, *this\Width, *it\Height, $D1E5FE) : EndIf
        
        ForEach *this\Columns()
          Protected col_x = (*this\X + *this\Columns()\X) - *this\ScrollH
          Protected txt$ = ""
          If ListIndex(*this\Columns()) = 0 : txt$ = *it\Title : Else : txt$ = *it\Value : EndIf
          DrawText(col_x + 5 + (*it\Level * 16 * Bool(ListIndex(*this\Columns())=0)), cur_y + 4, txt$, $000000)
        Next
        
        Line(*this\X, cur_y + *it\Height - 1, *this\Width, 1, $F0F0F0)
        cur_y + *it\Height
      Next
      UnclipOutput()
      
      ; Рамка виджета
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\X, *this\Y, *this\Width, *this\Height, $A0A0A0)
      DrawingMode(#PB_2DDrawing_Default)
    Next
    StopDrawing()
  EndIf
EndProcedure

;- --- ЛОГИКА ПЕРЕМЕЩЕНИЯ (SWAP) ---

Procedure Widget_HandleColumnSwap(*root._s_ROOT, mx)
  Protected *this._s_WIDGET = GetActive()
  Protected lx = mx - *this\X + *this\ScrollH
  ForEach *this\Columns()
    If @*this\Columns() <> *root\DragColumn
      If lx > *this\Columns()\X And lx < *this\Columns()\X + *this\Columns()\Width
        Protected target = @*this\Columns()
        ChangeCurrentElement(*this\Columns(), *root\DragColumn)
        If lx < *this\Columns()\X + (*this\Columns()\Width / 2)
          MoveElement(*this\Columns(), #PB_List_Before, target)
        Else
          MoveElement(*this\Columns(), #PB_List_After, target)
        EndIf
        Widget_UpdateLayout(*this) : ReDraw(*root) : Break
      EndIf
    EndIf
  Next
EndProcedure

Procedure Widget_HandleItemSwap(*root._s_ROOT, my)
  Protected *this._s_WIDGET = GetActive()
  Protected ly = my - *this\Y - *this\HeaderHeight + *this\ScrollV
  Protected cy = 0
  ForEach *this\ExpandedItems()
    If *this\ExpandedItems() <> *root\DragItem
      If ly > cy And ly < cy + *this\ExpandedItems()\Height
        Protected *target = *this\ExpandedItems()
        ChangeCurrentElement(*this\Items(), *root\DragItem)
        If ly < cy + (*this\ExpandedItems()\Height / 2)
          MoveElement(*this\Items(), #PB_List_Before, *target)
        Else
          MoveElement(*this\Items(), #PB_List_After, *target)
        EndIf
        Widget_Sync(*this) : ReDraw(*root) : Break
      EndIf
    EndIf
    cy + *this\ExpandedItems()\Height
  Next
EndProcedure

;- --- ДИСПЕТЧЕР СОБЫТИЙ ---

Procedure Widget_HandleEvents(*root._s_ROOT, et)
  Protected mx = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_MouseX)
  Protected my = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_MouseY)
  
  ; 1. Обновление Hover (только по видимым!)
  *root\ActiveWidget = 0
  ForEach *root\Widgets()
    Protected *this._s_WIDGET = @*root\Widgets()
    If mx >= *this\X And mx <= *this\X + *this\Width And my >= *this\Y And my <= *this\Y + *this\Height
      *root\ActiveWidget = *this
      ; Поиск колонки
      Protected lx = mx - *this\X + *this\ScrollH
      ForEach *this\Columns()
        If lx >= *this\Columns()\X And lx <= *this\Columns()\X + *this\Columns()\Width
          *this\HoverColumn = @*this\Columns() : Break
        EndIf
      Next
      ; Поиск итема (от FirstVisible до LastVisible)
      If *this\FirstVisible
        Protected cur_y = (*this\Y + *this\HeaderHeight) - *this\ScrollV
        ChangeCurrentElement(*this\ExpandedItems(), *this\FirstVisible)
        Repeat
          If my >= cur_y And my < cur_y + *this\ExpandedItems()\Height
            *this\HoverItem = *this\ExpandedItems() : Break
          EndIf
          cur_y + *this\ExpandedItems()\Height
        Until *this\ExpandedItems() = *this\LastVisible Or Not NextElement(*this\ExpandedItems())
      EndIf
    EndIf
  Next

  If Not GetActive() : ProcedureReturn : EndIf
  *this = GetActive()

  Select et
    Case #PB_EventType_LeftButtonDown
      If *this\HoverColumn
        Protected edge = *this\X + *this\HoverColumn\X + *this\HoverColumn\Width - *this\ScrollH
        If Abs(mx - edge) < 5 : *root\ResizingColumn = *this\HoverColumn : EndIf
      EndIf
      If Not *root\ResizingColumn And *this\HoverItem
        ForEach *this\Items() : *this\Items()\IsSelected = #False : Next
        *this\HoverItem\IsSelected = #True
        ReDraw(*root)
      EndIf

    Case #PB_EventType_DragStart
      If my < *this\Y + *this\HeaderHeight
        *root\DragColumn = *this\HoverColumn : *this\State | #State_ColumnDrag
      Else
        *root\DragItem = *this\HoverItem : *this\State | #State_ItemDrag
      EndIf

    Case #PB_EventType_MouseMove
      If *root\ResizingColumn
        *root\ResizingColumn\Width = (mx + *this\ScrollH) - (*this\X + *root\ResizingColumn\X)
        Widget_UpdateLayout(*this) : ReDraw(*root)
      ElseIf *this\State & #State_ColumnDrag
        Widget_HandleColumnSwap(*root, mx)
      ElseIf *this\State & #State_ItemDrag
        Widget_HandleItemSwap(*root, my)
      EndIf

    Case #PB_EventType_LeftButtonUp
      *root\ResizingColumn = 0
      *this\State & ~#State_ColumnDrag
      *this\State & ~#State_ItemDrag
      *root\DragColumn = 0 : *root\DragItem = 0
      ReDraw(*root)

    Case #PB_EventType_MouseWheel
      Protected delta = GetGadgetAttribute(*root\Canvas\Gadget, #PB_Canvas_WheelDelta)
      *this\ScrollV - (delta * *this\RowHeight)
      If *this\ScrollV < 0 : *this\ScrollV = 0 : EndIf
      ReDraw(*root)
  EndSelect
EndProcedure

;- --- API ---

Procedure OpenRoot(Window, X, Y, w, h)
  Root\Canvas\Window = Window : Root\Canvas\Gadget = CanvasGadget(#PB_Any, X, Y, w, h, #PB_Canvas_Keyboard)
  Root\Canvas\Width = w : Root\Canvas\Height = h
  ProcedureReturn Root\Canvas\Gadget
EndProcedure

Procedure Widget_Create(X, Y, w, h)
  AddElement(Root\Widgets())
  Protected *w._s_WIDGET = @Root\Widgets()
  *w\X = X : *w\Y = Y : *w\Width = w : *w\Height = h
  *w\HeaderHeight = 30 : *w\RowHeight = 25
  ProcedureReturn *w
EndProcedure

Procedure Widget_AddColumn(*w._s_WIDGET, title$, Width)
  AddElement(*w\Columns()) : *w\Columns()\Title = title$ : *w\Columns()\Width = Width
  Widget_UpdateLayout(*w)
EndProcedure

Procedure Widget_AddItem(*w._s_WIDGET, t$, v$, Level=0)
  AddElement(*w\Items()) : *w\Items()\Title = t$ : *w\Items()\Value = v$ : *w\Items()\Level = Level : *w\Items()\Height = *w\RowHeight
  Widget_Sync(*w)
EndProcedure

;- --- ТЕСТ ---

OpenWindow(0, 0, 0, 800, 600, "Ultimate 2D Listicon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenRoot(0, 0, 0, 800, 600)

Define *W1 = Widget_Create(10, 10, 350, 580)
Widget_AddColumn(*W1, "Property", 150) : Widget_AddColumn(*W1, "Value", 150)
Define i
For i = 1 To 40 : Widget_AddItem(*W1, "Param " + Str(i), "Val " + Str(i), i % 3) : Next

Define *W2 = Widget_Create(370, 10, 420, 580)
Widget_AddColumn(*W2, "Log", 400)
Widget_AddItem(*W2, "System Start...", "", 0)

ReDraw(@Root)

Repeat
  Define ev = WaitWindowEvent()
  If ev = #PB_Event_Gadget And EventGadget() = Root\Canvas\Gadget
    Widget_HandleEvents(@Root, EventType())
  EndIf
Until ev = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 285
; FirstLine = 270
; Folding = --------
; EnableXP
; DPIAware