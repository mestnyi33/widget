; =================================================================
; NODE EDITOR: 4 SIDES DEFAULT PORTS + DYNAMIC ATTACH
; =================================================================

#GridSize = 20
#PortSize = 10 

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Structure Port : X.i : Y.i : Color.i : IsHovered.b : EndStructure

Structure Node
  X.i : Y.i : w.i : h.i : color.i : Text.s
  List Ports.Port() 
EndStructure

Structure Connection
  *fromNode.Node : *fromPort.Port : *toNode.Node : *toPort.Port
  List Path.Port() : IsHovered.b
EndStructure

Global NewList Nodes.Node() : Global NewList Links.Connection()

Structure EditorState
  *DragNode.Node : *DragPort.Port : *ActiveSourceNode.Node
  DragOffX.i : DragOffY.i
  *TargetNode.Node : TargetSide.i : TargetIdx.i
EndStructure
Global Editor.EditorState

; --- ЛОГИКА ПОРТОВ ---

Procedure.i AddNodePort(*n.Node, side.i, Index.i)
  Protected stepSize = #PortSize + 10, margin = 25
  Protected tx, ty
  
  Select side
    Case 1 : tx = 0 : ty = margin + (Index * stepSize)      
    Case 2 : tx = margin + (Index * stepSize) : ty = 0      
    Case 3 : tx = *n\w : ty = margin + (Index * stepSize)   
    Case 4 : tx = margin + (Index * stepSize) : ty = *n\h   
  EndSelect
  
  ForEach *n\Ports()
    If *n\Ports()\X = tx And *n\Ports()\Y = ty : ProcedureReturn @*n\Ports() : EndIf
  Next

  AddElement(*n\Ports())
  *n\Ports()\X = tx : *n\Ports()\Y = ty
  Select side
    Case 1 : *n\Ports()\Color = $5050FF : Case 2 : *n\Ports()\Color = $FFD700
    Case 3 : *n\Ports()\Color = $50FF50 : Case 4 : *n\Ports()\Color = $FF50FF
  EndSelect
  ProcedureReturn @*n\Ports()
EndProcedure

Procedure UpdateLinkAnchors(*link.Connection)
  If ListSize(*link\Path()) < 2 : ProcedureReturn : EndIf
  FirstElement(*link\Path()) : *link\Path()\X = *link\fromNode\X + *link\fromPort\X : *link\Path()\Y = *link\fromNode\Y + *link\fromPort\Y
  LastElement(*link\Path()) : *link\Path()\X = *link\toNode\X + *link\toPort\X : *link\Path()\Y = *link\toNode\Y + *link\toPort\Y
EndProcedure

Procedure InitDefaultPath(*link.Connection)
  ClearList(*link\Path())
  Protected x1 = *link\fromNode\X + *link\fromPort\X, y1 = *link\fromNode\Y + *link\fromPort\Y
  Protected x2 = *link\toNode\X + *link\toPort\X, y2 = *link\toNode\Y + *link\toPort\Y
  AddElement(*link\Path()) : *link\Path()\X = x1 : *link\Path()\Y = y1
  AddElement(*link\Path()) : *link\Path()\X = x1 + (x2-x1)/2 : *link\Path()\Y = y1
  AddElement(*link\Path()) : *link\Path()\X = x1 + (x2-x1)/2 : *link\Path()\Y = y2
  AddElement(*link\Path()) : *link\Path()\X = x2 : *link\Path()\Y = y2
EndProcedure

; --- ОБНОВЛЕНО: Добавление портов ко всем сторонам ---
Procedure CreateEditorNode(X, Y, t.s, color.i)
  *n.Node = AddElement(Nodes())
  *n\X = X : *n\Y = Y : *n\w = 140 : *n\h = 120 : *n\Text = t : *n\color = color
  
  ; Добавляем по 4 порта на каждую из 4 сторон при создании
  Protected i
  For i = 0 To 3
    AddNodePort(*n, 1, i) ; Лево
    AddNodePort(*n, 2, i) ; Верх
    AddNodePort(*n, 3, i) ; Право
    AddNodePort(*n, 4, i) ; Низ
  Next
EndProcedure

Procedure HandleCanvasEvents(Canvas)
  Protected mx = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected my = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected et = EventType()
  
  Select et
    Case #PB_EventType_MouseMove
      Editor\TargetNode = #Null : Editor\TargetSide = 0
      ForEach Nodes() : ForEach Nodes()\Ports() : Nodes()\Ports()\IsHovered = #False : Next : Next
      
      If Editor\DragNode
        Protected oldX = Editor\DragNode\X, oldY = Editor\DragNode\Y
        Editor\DragNode\X = Round((mx-Editor\DragOffX)/#GridSize, #PB_Round_Nearest)*#GridSize 
        Editor\DragNode\Y = Round((my-Editor\DragOffY)/#GridSize, #PB_Round_Nearest)*#GridSize
        Protected dx = Editor\DragNode\X - oldX, dy = Editor\DragNode\Y - oldY
        ForEach Links() : If Links()\fromNode=Editor\DragNode Or Links()\toNode=Editor\DragNode
          Protected cnt=ListSize(Links()\Path()), idx=0
          ForEach Links()\Path() : If idx>0 And idx<cnt-1 : Links()\Path()\X+dx : Links()\Path()\Y+dy : EndIf : idx+1 : Next
          UpdateLinkAnchors(Links())
        EndIf : Next
      Else
        If Editor\DragPort
          ForEach Nodes() : If @Nodes() <> Editor\ActiveSourceNode
            Protected d = 20 
            If mx >= Nodes()\X-d And mx <= Nodes()\X+d And my > Nodes()\Y And my < Nodes()\Y+Nodes()\h : Editor\TargetNode = @Nodes() : Editor\TargetSide = 1 : Editor\TargetIdx = (my-Nodes()\Y-25)/20
            ElseIf my >= Nodes()\Y-d And my <= Nodes()\Y+d And mx > Nodes()\X And mx < Nodes()\X+Nodes()\w : Editor\TargetNode = @Nodes() : Editor\TargetSide = 2 : Editor\TargetIdx = (mx-Nodes()\X-25)/20
            ElseIf mx >= Nodes()\X+Nodes()\w-d And mx <= Nodes()\X+Nodes()\w+d And my > Nodes()\Y And my < Nodes()\Y+Nodes()\h : Editor\TargetNode = @Nodes() : Editor\TargetSide = 3 : Editor\TargetIdx = (my-Nodes()\Y-25)/20
            ElseIf my >= Nodes()\Y+Nodes()\h-d And my <= Nodes()\Y+Nodes()\h+d And mx > Nodes()\X And mx < Nodes()\X+Nodes()\w : Editor\TargetNode = @Nodes() : Editor\TargetSide = 4 : Editor\TargetIdx = (mx-Nodes()\X-25)/20
            EndIf
            If Editor\TargetNode : Break : EndIf
          EndIf : Next
        EndIf
        ForEach Nodes() : ForEach Nodes()\Ports()
          If Abs(mx-(Nodes()\X+Nodes()\Ports()\X)) < 12 And Abs(my-(Nodes()\Y+Nodes()\Ports()\Y)) < 12
            Nodes()\Ports()\IsHovered = #True : Break 2
          EndIf
        Next : Next
      EndIf

    Case #PB_EventType_LeftButtonDown
      ForEach Nodes()
        ForEach Nodes()\Ports() : If Nodes()\Ports()\IsHovered
            Editor\DragPort=@Nodes()\Ports() : Editor\ActiveSourceNode=@Nodes() : Break 2 
        EndIf : Next
        If mx>Nodes()\X And mx<Nodes()\X+Nodes()\w And my>Nodes()\Y And my<Nodes()\Y+Nodes()\h
          Editor\DragNode=@Nodes() : Editor\DragOffX=mx-Nodes()\X : Editor\DragOffY=my-Nodes()\Y : MoveElement(Nodes(), #PB_List_Last) : Break
        EndIf
      Next

    Case #PB_EventType_LeftButtonUp
      If Editor\DragPort And Editor\TargetNode
        Protected *tPort.Port = AddNodePort(Editor\TargetNode, Editor\TargetSide, Max(0, Editor\TargetIdx))
        AddElement(Links())
        Links()\fromNode = Editor\ActiveSourceNode : Links()\fromPort = Editor\DragPort
        Links()\toNode = Editor\TargetNode : Links()\toPort = *tPort
        InitDefaultPath(Links()) : UpdateLinkAnchors(Links())
      EndIf
      Editor\DragNode=#Null : Editor\DragPort=#Null
  EndSelect
EndProcedure

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $FDFDFD)
    ForEach Links()
      Protected first = #True, px, py 
      ForEach Links()\Path()
        If Not first : LineXY(px, py, Links()\Path()\X, Links()\Path()\Y, $888888) : EndIf
        px = Links()\Path()\X : py = Links()\Path()\Y : first = #False 
      Next
    Next
    ForEach Nodes()
      Box(Nodes()\X, Nodes()\Y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\X+10, Nodes()\Y+10, Nodes()\Text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      ForEach Nodes()\Ports() : Protected r = 5 : If Nodes()\Ports()\IsHovered : r + 3 : EndIf
        Circle(Nodes()\X + Nodes()\Ports()\X, Nodes()\Y + Nodes()\Ports()\Y, r, Nodes()\Ports()\Color) 
      Next
      
      If Editor\TargetNode = @Nodes()
        Protected stepS = #PortSize + 10, margin = 25, fX, fY
        Select Editor\TargetSide
          Case 1 : fX = 0 : fY = margin + (Max(0, Editor\TargetIdx) * stepS)
          Case 2 : fX = margin + (Max(0, Editor\TargetIdx) * stepS) : fY = 0
          Case 3 : fX = Nodes()\w : fY = margin + (Max(0, Editor\TargetIdx) * stepS)
          Case 4 : fX = margin + (Max(0, Editor\TargetIdx) * stepS) : fY = Nodes()\h
        EndSelect
        Circle(Nodes()\X + fX, Nodes()\Y + fY, 6, $AAAAAA) 
      EndIf
    Next
    If Editor\DragPort : LineXY(Editor\ActiveSourceNode\X + Editor\DragPort\X, Editor\ActiveSourceNode\Y + Editor\DragPort\Y, GetGadgetAttribute(Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(Canvas, #PB_Canvas_MouseY), $AAAAAA) : EndIf
    StopDrawing()
  EndIf
EndProcedure

OpenWindow(0, 0, 0, 1000, 750, "Node Editor: 16 Default Ports", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750)
CreateEditorNode(100, 100, "Block A", $4A4A4A) 
CreateEditorNode(600, 300, "Block B", $2E2E2E)
ReDraw(0)

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget And EventGadget() = 0 : HandleCanvasEvents(0) : ReDraw(0) : EndIf
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 186
; FirstLine = 167
; Folding = ------
; EnableXP
; DPIAware