; =================================================================
; ГРАФИЧЕСКИЙ РЕДАКТОР УЗЛОВ (NODE EDITOR)
; ОСОБЕННОСТЬ: Отрисовка связей под прямым углом (Manhattan Routing)
; =================================================================

; --- СТРУКТУРЫ ---

Structure Port
  X.f : Y.f : color.i : Active.b
EndStructure

Structure Node
  X.f : Y.f : w.f : h.f : color.i : Text.s
  List Ports.Port() 
EndStructure

Structure Connection
  *fromNode.Node : *fromPort.Port : *toNode.Node : *toPort.Port : color.i
EndStructure

; --- ГЛОБАЛЬНЫЕ ОБЪЕКТЫ ---

Global NewList Nodes.Node()
Global NewList Links.Connection()
Global *DragNode.Node = #Null, *DragPort.Port = #Null, *ActiveSourceNode.Node = #Null
Global *HoverEdgeNode.Node = #Null, HoverSide.i = 0, HoverPos.f = 0.0
Global DragOffX.f = 0, DragOffY.f = 0
Global *TargetTempPort.Port = #Null, *TargetTempNode.Node = #Null

; --- МАКРОСЫ ---

Macro IsMouseOnPort(mx, my, nodePtr, portPtr)
  (Bool(nodePtr <> #Null And portPtr <> #Null And mx > (nodePtr\x + portPtr\x - 12) And mx < (nodePtr\x + portPtr\x + 12) And my > (nodePtr\y + portPtr\y - 12) And my < (nodePtr\y + portPtr\y + 12)))
EndMacro

Macro IsMouseOnNode(mx, my, nodePtr)
  (Bool(nodePtr <> #Null And mx > nodePtr\x And mx < (nodePtr\x + nodePtr\w) And my > nodePtr\y And my < (nodePtr\y + nodePtr\h)))
EndMacro

; --- ПРОЦЕДУРЫ ---

Procedure.i AddNotePoint(*n.Node, side, position.f, color = $00FF00)
  AddElement(*n\Ports()) : *n\Ports()\color = color
  Select side
    Case 1 : *n\Ports()\x = 0 : *n\Ports()\y = *n\h * position      ; Лево
    Case 2 : *n\Ports()\x = *n\w * position : *n\Ports()\y = 0      ; Верх
    Case 3 : *n\Ports()\x = *n\w : *n\Ports()\y = *n\h * position   ; Право
    Case 4 : *n\Ports()\x = *n\w * position : *n\Ports()\y = *n\h   ; Низ
  EndSelect
  ProcedureReturn @*n\Ports()
EndProcedure

; УЛУЧШЕНО: Рисование линии под прямым углом
Procedure DrawSteppedLine(x1, y1, x2, y2, color)
  Protected midX = x1 + (x2 - x1) / 2
  ; Рисуем Z-образную ступенчатую линию
  LineXY(x1, y1, midX, y1, color)   ; Горизонталь 1
  LineXY(midX, y1, midX, y2, color) ; Вертикаль
  LineXY(midX, y2, x2, y2, color)   ; Горизонталь 2
EndProcedure

Procedure UpdateDynamicTarget(mx, my, *sourceNode.Node)
  If *HoverEdgeNode And *HoverEdgeNode <> *sourceNode
    If *TargetTempPort = #Null
      *TargetTempPort = AddNotePoint(*HoverEdgeNode, HoverSide, HoverPos, $A0A0A0)
      *TargetTempNode = *HoverEdgeNode
    Else
      Select HoverSide
        Case 2, 4 : *TargetTempPort\x = *TargetTempNode\w * HoverPos
        Case 1, 3 : *TargetTempPort\y = *TargetTempNode\h * HoverPos
      EndSelect
    EndIf
  ElseIf *TargetTempPort
    ChangeCurrentElement(*TargetTempNode\Ports(), *TargetTempPort)
    DeleteElement(*TargetTempNode\Ports())
    *TargetTempPort = #Null : *TargetTempNode = #Null
  EndIf
EndProcedure

Procedure CreateNewNode(X, Y, label.s = "Блок", w = 120, h = 80)
  *n.Node = AddElement(Nodes())
  *n\x = X - w/2 : *n\y = Y - h/2 : *n\w = w : *n\h = h : *n\text = label
  *n\color = RGB(Random(180, 80), Random(180, 80), Random(180, 80))
  AddNotePoint(*n, 1, 0.5, $00FF00) : AddNotePoint(*n, 3, 0.5, $FF0000)
  ProcedureReturn *n
EndProcedure

Procedure ReDraw(Canvas)
  StartDrawing(CanvasOutput(Canvas))
  Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
  
  ; Рисуем связи (Ступенчатые)
  ForEach Links()
    DrawSteppedLine(Links()\fromNode\x + Links()\fromPort\x, Links()\fromNode\y + Links()\fromPort\y, 
                    Links()\toNode\x + Links()\toPort\x, Links()\toNode\y + Links()\toPort\y, Links()\color)
  Next
  
  ; Линия при перетаскивании (Ступенчатая)
  If *DragPort
    DrawSteppedLine(*ActiveSourceNode\x + *DragPort\x, *ActiveSourceNode\y + *DragPort\y, 
                    GetGadgetAttribute(0, #PB_Canvas_MouseX), GetGadgetAttribute(0, #PB_Canvas_MouseY), $AAAAAA)
  EndIf
  
  ; Узлы и порты
  ForEach Nodes()
    Box(Nodes()\x, Nodes()\y, Nodes()\w, Nodes()\h, Nodes()\color)
    If *HoverEdgeNode = @Nodes() : DrawingMode(#PB_2DDrawing_Outlined) : Box(Nodes()\x-1, Nodes()\y-1, Nodes()\w+2, Nodes()\h+2, $00D7FF) : DrawingMode(#PB_2DDrawing_Default) : EndIf
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(Nodes()\x + (Nodes()\w - TextWidth(Nodes()\text))/2, Nodes()\y + (Nodes()\h - TextHeight(Nodes()\text))/2, Nodes()\text, $FFFFFF)
    ForEach Nodes()\Ports()
      c = Nodes()\Ports()\color : r = 4
      If Nodes()\Ports()\active : c = $FF00FF : r = 6 : EndIf
      Circle(Nodes()\x + Nodes()\Ports()\x, Nodes()\y + Nodes()\Ports()\y, r, c)
    Next
  Next
  StopDrawing()
EndProcedure

Procedure.i IsMouseOnSide(mx, my, *node.Node, sidesize)
  If mx >= *node\x - sidesize And mx <= *node\x + *node\w + sidesize And my >= *node\y - sidesize And my <= *node\y + *node\h + sidesize
    If Abs(mx - *node\x) <= sidesize : HoverSide = 1 : HoverPos = (my - *node\y) / *node\h : ProcedureReturn @*node
    ElseIf Abs(my - *node\y) <= sidesize : HoverSide = 2 : HoverPos = (mx - *node\x) / *node\w : ProcedureReturn @*node
    ElseIf Abs(mx - (*node\x + *node\w)) <= sidesize : HoverSide = 3 : HoverPos = (my - *node\y) / *node\h : ProcedureReturn @*node
    ElseIf Abs(my - (*node\y + *node\h)) <= sidesize : HoverSide = 4 : HoverPos = (mx - *node\x) / *node\w : ProcedureReturn @*node
    EndIf
  EndIf
  ProcedureReturn #Null
EndProcedure

; --- ОСНОВНОЙ ЦИКЛ ---

OpenWindow(0, 0, 0, 1000, 700, "Node Editor Orthogonal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 700)
CreateNewNode(300, 350, "Блок 1") : CreateNewNode(700, 350, "Блок 2")

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget And EventGadget() = 0
    mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
    Select EventType()
      Case #PB_EventType_MouseMove
        *HoverEdgeNode = #Null
        ForEach Nodes()
          ForEach Nodes()\Ports() : Nodes()\Ports()\active = IsMouseOnPort(mx, my, Nodes(), Nodes()\Ports()) : Next
          If IsMouseOnSide(mx, my, Nodes(), 6) : *HoverEdgeNode = @Nodes() : EndIf
        Next
        If *DragPort : UpdateDynamicTarget(mx, my, *ActiveSourceNode) : EndIf
        If *DragNode : *DragNode\x = mx - DragOffX : *DragNode\y = my - DragOffY : EndIf
        ReDraw(0)
      Case #PB_EventType_LeftButtonDown
        *DragPort = #Null : *DragNode = #Null
        ForEach Nodes()
          ForEach Nodes()\Ports() : If Nodes()\Ports()\active : *DragPort = @Nodes()\Ports() : *ActiveSourceNode = @Nodes() : Break 2 : EndIf : Next
        Next
        If *DragPort = #Null
          If *HoverEdgeNode
            *DragPort = AddNotePoint(*HoverEdgeNode, HoverSide, HoverPos, $A0A0A0) : *ActiveSourceNode = *HoverEdgeNode : *TargetTempPort = #Null
          Else 
            ForEach Nodes() : If IsMouseOnNode(mx, my, Nodes()) : *DragNode = @Nodes() : DragOffX = mx - *DragNode\x : DragOffY = my - *DragNode\y : MoveElement(Nodes(), #PB_List_Last) : Break : EndIf : Next
          EndIf
        EndIf
      Case #PB_EventType_LeftButtonUp
        If *DragPort And *TargetTempPort
          AddElement(Links()) : Links()\fromNode = *ActiveSourceNode : Links()\fromPort = *DragPort : Links()\toNode = *TargetTempNode : Links()\toPort = *TargetTempPort : Links()\color = *DragPort\color
          *TargetTempPort = #Null : *TargetTempNode = #Null
        EndIf
        *DragPort = #Null : *DragNode = #Null : ReDraw(0)
      Case #PB_EventType_RightButtonDown
        ForEach Nodes() : ForEach Nodes()\Ports() : If Nodes()\Ports()\active
          ForEach Links() : If Links()\fromPort = @Nodes()\Ports() Or Links()\toPort = @Nodes()\Ports() : DeleteElement(Links()) : EndIf : Next
        EndIf : Next : Next : ReDraw(0)
      Case #PB_EventType_LeftDoubleClick : CreateNewNode(mx, my) : ReDraw(0)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 175
; FirstLine = 147
; Folding = ------
; EnableXP
; DPIAware