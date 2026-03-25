EnableExplicit

;- --- 1. СТРУКТУРЫ ---
Structure _s_TEXT : Array Str.s(0) : EndStructure

Structure _s_ROWS
  Text._s_TEXT : Level.i : Height.i : Y.i 
  Hide.b : IsSelected.b : IsGroup.b : IsFolded.b
EndStructure

Structure _s_COLUMN
  Text._s_TEXT : Width.i : X.i : Hide.b
EndStructure

Structure _s_VISIBLEITEMS
  *firstNode : *lastNode 
EndStructure

Structure _s_WIDGET
  X.i : Y.i : Width.i : Height.i : HeaderHeight.i : RowHeight.i
  List __rows._s_ROWS()            
  List *__Items._s_ROWS()          
  List __columns._s_COLUMN()       
  *HoverItem._s_ROWS : *HoverColumn._s_COLUMN
  visible._s_VISIBLEITEMS
  scroll_v_pos.i : scroll_h_pos.i
  IsScrollingH.b
  *root.struct_ROOT                
EndStructure

Structure struct_ROOT
  CanvasGadget.i : Window.i : Width.i : Height.i
  *ActiveWidget._s_WIDGET
  *DragColumn._s_COLUMN : *DragItem._s_ROWS : *ResizingColumn._s_COLUMN : *ResizingRow._s_ROWS
  List widgets._s_WIDGET()
EndStructure

Global Root.struct_ROOT

;- --- 2. ЛОГИКА ---

Procedure Row_UpdateLayout(*this._s_WIDGET)
  Protected cur_y = 0
  ForEach *this\__Items()
    Protected *row._s_ROWS = *this\__Items()
    If *this\RowHeight > 0 : *row\Height = *this\RowHeight : EndIf
    If *row\Height = 0 : *row\Height = 25 : EndIf
    *row\Y = cur_y
    cur_y + *row\Height
  Next
EndProcedure

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
    If Not *this\__rows()\Hide : AddElement(*this\__Items()) : *this\__Items() = @*this\__rows() : EndIf
  Next
  Row_UpdateLayout(*this)
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

Procedure Column_HandleSwap(*this._s_WIDGET, mx, my)
  Protected *root.struct_ROOT = *this\root
  If *root\DragColumn
    ForEach *this\__columns()
      Protected *target._s_COLUMN = @*this\__columns()
      If *target = *root\DragColumn : Continue : EndIf
      Protected cx = *this\X + *target\X - *this\scroll_h_pos
      If mx > cx And mx < cx + *target\Width
        PushListPosition(*this\__columns()) : ChangeCurrentElement(*this\__columns(), *root\DragColumn)
        If mx > cx + (*target\Width / 2) : MoveElement(*this\__columns(), #PB_List_After, *target)
        Else : MoveElement(*this\__columns(), #PB_List_Before, *target) : EndIf
        PopListPosition(*this\__columns())
        Column_UpdateLayout(*this) : Break
      EndIf
    Next
  ElseIf *root\DragItem And *this\HoverItem
    If *this\HoverItem <> *root\DragItem
      PushListPosition(*this\__Items())
      Protected *dragNode = 0, *hoverNode = 0, hover_y = *this\Y + *this\HeaderHeight + (*this\HoverItem\Y - *this\scroll_v_pos)
      ForEach *this\__Items()
        If *this\__Items() = *this\HoverItem : *hoverNode = @*this\__Items() : EndIf
        If *this\__Items() = *root\DragItem  : *dragNode = @*this\__Items() : EndIf
        If *dragNode And *hoverNode : Break : EndIf
      Next
      If *dragNode And *hoverNode
        ChangeCurrentElement(*this\__Items(), *dragNode)
        If my > hover_y + (*this\HoverItem\Height / 2) : MoveElement(*this\__Items(), #PB_List_After, *hoverNode)
        Else : MoveElement(*this\__Items(), #PB_List_Before, *hoverNode) : EndIf
        Row_UpdateLayout(*this)
      EndIf
      PopListPosition(*this\__Items())
    EndIf
  EndIf
EndProcedure

;- --- 3. РЕНДЕРИНГ ---

Procedure ReDraw(*root.struct_ROOT)
  If StartDrawing(CanvasOutput(*root\CanvasGadget))
    Box(0, 0, *root\Width, *root\Height, $F0F0F0)
    ForEach *root\widgets()
      Protected *this._s_WIDGET = @*root\widgets()
      ClipOutput(*this\X, *this\Y, *this\Width, *this\HeaderHeight)
      ForEach *this\__columns()
        Protected cx = (*this\X + *this\__columns()\X) - *this\scroll_h_pos
        Protected clr = $E5E5E5 : If @*this\__columns() = *this\HoverColumn : clr = $D8D8D8 : EndIf
        Box(cx, *this\Y, *this\__columns()\Width, *this\HeaderHeight, clr)
        DrawingMode(#PB_2DDrawing_Transparent) : DrawText(cx + 5, *this\Y + 7, *this\__columns()\Text\Str(0), $000000)
        Line(cx + *this\__columns()\Width - 1, *this\Y, 1, *this\HeaderHeight, $B0B0B0)
      Next
      UnclipOutput()
      *this\visible\firstNode = 0 : *this\visible\lastNode = 0
      ClipOutput(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height - *this\HeaderHeight - 6)
      Box(*this\X, *this\Y + *this\HeaderHeight, *this\Width, *this\Height, $FFFFFF)
      If ListSize(*this\__Items()) > 0
        If *this\RowHeight > 0 : SelectElement(*this\__Items(), *this\scroll_v_pos / *this\RowHeight)
        Else : ForEach *this\__Items() : If *this\__Items()\Y + *this\__Items()\Height > *this\scroll_v_pos : Break : EndIf : Next : EndIf
        Repeat
          Protected *row._s_ROWS = *this\__Items()
          Protected draw_y = (*this\Y + *this\HeaderHeight) + (*row\Y - *this\scroll_v_pos)
          If Not *this\visible\firstNode : *this\visible\firstNode = @*this\__Items() : EndIf
          *this\visible\lastNode = @*this\__Items()
          If *row\IsSelected : Box(*this\X, draw_y, *this\Width, *row\Height, $D1E5FE)
          ElseIf *row = *this\HoverItem : Box(*this\X, draw_y, *this\Width, *row\Height, $F5F5F5)
          ElseIf ListIndex(*this\__Items()) % 2 = 0 : Box(*this\X, draw_y, *this\Width, *row\Height, $FAFAFA) : EndIf
          ForEach *this\__columns()
            Protected col_x = (*this\X + *this\__columns()\X) - *this\scroll_h_pos
            Protected off = 0 : If ListIndex(*this\__columns()) = 0 : off = *row\Level * 16 + 18 : EndIf
            DrawText(col_x + 5 + off, draw_y + 4, *row\Text\Str(ListIndex(*this\__columns())), $000000)
            If *row\IsGroup And ListIndex(*this\__columns()) = 0 : Circle(col_x + off - 10, draw_y + 12, 4, $808080) : EndIf
          Next
          Line(*this\X, draw_y + *row\Height - 1, *this\Width, 1, $EEEEEE)
        Until draw_y + *row\Height > *this\Y + *this\Height - 6 Or Not NextElement(*this\__Items())
      EndIf
      UnclipOutput()
      Protected tw = 0 : ForEach *this\__columns() : tw + *this\__columns()\Width : Next
      If tw > *this\Width
        Protected sw = (*this\Width * *this\Width) / tw, sx = *this\X + (*this\scroll_h_pos * (*this\Width - sw)) / (tw - *this\Width)
        Box(*this\X, *this\Y + *this\Height - 6, *this\Width, 6, $F0F0F0) : Box(sx, *this\Y + *this\Height - 5, sw, 4, $C0C0C0)
      EndIf
      DrawingMode(#PB_2DDrawing_Outlined) : Box(*this\X, *this\Y, *this\Width, *this\Height, $A0A0A0)
    Next
    StopDrawing()
  EndIf
EndProcedure

;- --- 4. СОБЫТИЯ ---

Procedure Column_HandleEvents(*root.struct_ROOT, et)
  Protected mx = GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_MouseX), my = GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_MouseY)
  ForEach *root\widgets()
    Protected *this._s_WIDGET = @*root\widgets()
    *this\HoverColumn = 0 : *this\HoverItem = 0
    If mx >= *this\X And mx <= *this\X + *this\Width And my >= *this\Y And my <= *this\Y + *this\Height
      *root\ActiveWidget = *this
      ForEach *this\__columns()
        If mx >= (*this\X + *this\__columns()\X) - *this\scroll_h_pos And mx <= (*this\X + *this\__columns()\X + *this\__columns()\Width) - *this\scroll_h_pos And
           my >= *this\Y And my <= *this\Y + *this\HeaderHeight : *this\HoverColumn = @*this\__columns() : Break : EndIf
      Next
      If *this\visible\firstNode And my > *this\Y + *this\HeaderHeight
        Protected rel_y = (my - (*this\Y + *this\HeaderHeight)) + *this\scroll_v_pos
        PushListPosition(*this\__Items())
        If *this\RowHeight > 0 : Protected idx = rel_y / *this\RowHeight : If idx < ListSize(*this\__Items()) : SelectElement(*this\__Items(), idx) : *this\HoverItem = *this\__Items() : EndIf
        Else : ChangeCurrentElement(*this\__Items(), *this\visible\firstNode)
          Repeat : If rel_y >= *this\__Items()\Y And rel_y < *this\__Items()\Y + *this\__Items()\Height : *this\HoverItem = *this\__Items() : Break : EndIf
          Until @*this\__Items() = *this\visible\lastNode Or Not NextElement(*this\__Items()) : EndIf
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
        Protected rb = (*this\Y + *this\HeaderHeight) + (*this\HoverItem\Y + *this\HoverItem\Height - *this\scroll_v_pos)
        If Abs(my - rb) < 7 And *this\RowHeight = 0 : *root\ResizingRow = *this\HoverItem
        Else : *root\DragItem = *this\HoverItem
          If mx < *this\X + 60 And *this\HoverItem\IsGroup : Column_ToggleGroup(*this, *this\HoverItem) : EndIf
          ForEach *this\__rows() : *this\__rows()\IsSelected = #False : Next : *this\HoverItem\IsSelected = #True : EndIf : EndIf
    Case #PB_EventType_MouseMove
      If *this\IsScrollingH : Protected tw = 0 : ForEach *this\__columns() : tw + *this\__columns()\Width : Next
        *this\scroll_h_pos = ((mx - *this\X) * (tw - *this\Width)) / *this\Width
        If *this\scroll_h_pos < 0 : *this\scroll_h_pos = 0 : EndIf : If *this\scroll_h_pos > tw - *this\Width : *this\scroll_h_pos = tw - *this\Width : EndIf
      ElseIf *root\ResizingRow : Protected rs_y = (*this\Y + *this\HeaderHeight) + (*root\ResizingRow\Y - *this\scroll_v_pos)
        *root\ResizingRow\Height = my - rs_y : If *root\ResizingRow\Height < 15 : *root\ResizingRow\Height = 15 : EndIf : Row_UpdateLayout(*this)
      ElseIf *root\ResizingColumn : *root\ResizingColumn\Width = (mx + *this\scroll_h_pos) - (*this\X + *root\ResizingColumn\X) : Column_UpdateLayout(*this)
      ElseIf *root\DragColumn Or *root\DragItem : Column_HandleSwap(*this, mx, my) 
        If *root\DragItem : If my < *this\Y + *this\HeaderHeight + 20 : *this\scroll_v_pos - 10 : ElseIf my > *this\Y + *this\Height - 25 : *this\scroll_v_pos + 10 : EndIf
          If *this\scroll_v_pos < 0 : *this\scroll_v_pos = 0 : EndIf : EndIf : EndIf
      If *this\HoverItem And *this\RowHeight = 0 : Protected hb = (*this\Y + *this\HeaderHeight) + (*this\HoverItem\Y + *this\HoverItem\Height - *this\scroll_v_pos)
        If Abs(my - hb) < 5 : SetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_Cursor, #PB_Cursor_UpDown) : Else : SetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_Cursor, #PB_Cursor_Default) : EndIf : EndIf
    Case #PB_EventType_LeftButtonUp : *root\ResizingColumn = 0 : *root\DragColumn = 0 : *root\DragItem = 0 : *root\ResizingRow = 0 : *this\IsScrollingH = #False
    Case #PB_EventType_MouseWheel : *this\scroll_v_pos - (GetGadgetAttribute(*root\CanvasGadget, #PB_Canvas_WheelDelta) * 40)
      If *this\scroll_v_pos < 0 : *this\scroll_v_pos = 0 : EndIf
  EndSelect
  ReDraw(*root)
EndProcedure

Procedure Column_AddItem(*this._s_WIDGET, Text$, Level=0, isgroup=#False, h=25)
  AddElement(*this\__rows()) : Protected i, tc = ListSize(*this\__columns()) - 1
  ReDim *this\__rows()\Text\Str(tc) : For i = 0 To tc : *this\__rows()\Text\Str(i) = StringField(Text$, i + 1, #LF$) : Next
  *this\__rows()\Level = Level : *this\__rows()\Height = h : *this\__rows()\IsGroup = isgroup : Column_Sync(*this)
EndProcedure

;- --- 5. ЗАПУСК ---
OpenWindow(0, 0, 0, 800, 600, "Hybrid 2D Listicon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
Root\CanvasGadget = CanvasGadget(#PB_Any, 0, 0, 800, 600, #PB_Canvas_Keyboard) : Root\Width = 800 : Root\Height = 600
AddElement(Root\widgets()) : Define *w._s_WIDGET = @Root\widgets() : *w\root = @Root
*w\X = 10 : *w\Y = 10 : *w\Width = 780 : *w\Height = 580 : *w\HeaderHeight = 30 : *w\RowHeight = 0 
AddElement(*w\__columns()) : *w\__columns()\Text\Str(0) = "Файл" : *w\__columns()\Width = 250
AddElement(*w\__columns()) : *w\__columns()\Text\Str(0) = "Высота" : *w\__columns()\Width = 100
Column_UpdateLayout(*w) : Column_AddItem(*w, "Проект" + #LF$ + "-", 0, #True, 35)
Define i : For i = 1 To 20 : Column_AddItem(*w, "Элемент " + Str(i) + #LF$ + "тяни за край", 1, #False, 25 + Random(30)) : Next
Column_Sync(*w) : ReDraw(@Root)
Repeat : Define ev = WaitWindowEvent()
  If ev = #PB_Event_Gadget And EventGadget() = Root\CanvasGadget : Column_HandleEvents(@Root, EventType()) : EndIf
Until ev = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 241
; FirstLine = 218
; Folding = -----------
; EnableXP
; DPIAware