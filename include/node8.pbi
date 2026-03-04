; =================================================================
; NODE EDITOR: COMPACT START + STEP-BY-STEP EXPAND
; =================================================================

#GridSize = 20
#PortSize = 10 
#StepS = 18    
#Margin = 10   

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro

Structure Port : X.i : Y.i : Color.i : IsHovered.b : Side.i : Index.i : EndStructure
Structure Node : X.i : Y.i : w.i : h.i : color.i : Text.s : List Ports.Port() : EndStructure
Structure Connection : *fromNode.Node : *fromPort.Port : *toNode.Node : *toPort.Port : List Path.Port() : EndStructure

Global NewList Nodes.Node() : Global NewList Links.Connection()

Structure EditorState
  *DragNode.Node : *DragPort.Port : *ActiveSourceNode.Node
  DragOffX.i : DragOffY.i
  *TargetNode.Node : TargetSide.i : TargetIdx.i
EndStructure
Global Editor.EditorState

Procedure UpdatePortsPositions(*n.Node)
  ForEach *n\Ports()
    Select *n\Ports()\Side
      Case 1 : *n\Ports()\X = 0 : *n\Ports()\Y = #Margin + (*n\Ports()\Index * #StepS)
      Case 2 : *n\Ports()\X = #Margin + (*n\Ports()\Index * #StepS) : *n\Ports()\Y = 0
      Case 3 : *n\Ports()\X = *n\w : *n\Ports()\Y = #Margin + (*n\Ports()\Index * #StepS)
      Case 4 : *n\Ports()\X = #Margin + (*n\Ports()\Index * #StepS) : *n\Ports()\Y = *n\h
    EndSelect
  Next
EndProcedure

Procedure UpdateLinkAnchors(*link.Connection)
  If ListSize(*link\Path()) < 2 : ProcedureReturn : EndIf
  FirstElement(*link\Path()) : *link\Path()\X = *link\fromNode\X + *link\fromPort\X : *link\Path()\Y = *link\fromNode\Y + *link\fromPort\Y
  LastElement(*link\Path())  : *link\Path()\X = *link\toNode\X + *link\toPort\X     : *link\Path()\Y = *link\toNode\Y + *link\toPort\Y
EndProcedure

Procedure.i AddNodePort(*n.Node, side.i, Index.i)
  Protected reqS = #Margin + (Index * #StepS) + #StepS + #Margin
  If (side = 1 Or side = 3) And reqS > *n\h : *n\h = reqS : EndIf
  If (side = 2 Or side = 4) And reqS > *n\w : *n\w = reqS : EndIf
  
  UpdatePortsPositions(*n) 
  ForEach *n\Ports() : If *n\Ports()\Side = side And *n\Ports()\Index = Index : ProcedureReturn @*n\Ports() : EndIf : Next

  AddElement(*n\Ports())
  *n\Ports()\Side = side : *n\Ports()\Index = Index
  Select side : Case 1: *n\Ports()\Color = $5050FF : Case 2: *n\Ports()\Color = $FFD700 : Case 3: *n\Ports()\Color = $50FF50 : Case 4: *n\Ports()\Color = $FF50FF : EndSelect
  
  UpdatePortsPositions(*n)
  ProcedureReturn @*n\Ports()
EndProcedure

Procedure CreateEditorNode(X, Y, t.s)
  *n.Node = AddElement(Nodes()) 
  *n\X = X : *n\Y = Y : *n\w = 40 : *n\h = 40 : *n\Text = t
  *n\color = RGB(Random(140, 60), Random(140, 60), Random(140, 60))
  For side = 1 To 4 : For i = 0 To 1 : AddNodePort(*n, side, i) : Next : Next
EndProcedure

Procedure ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    Box(0, 0, OutputWidth(), OutputHeight(), $F3F3F3)
    ; Сетка для красоты
    For X = 0 To OutputWidth() Step #GridSize : Line(X, 0, 1, OutputHeight(), $EEEEEE) : Next
    For Y = 0 To OutputHeight() Step #GridSize : Line(0, Y, OutputWidth(), 1, $EEEEEE) : Next
    
    ForEach Links() : UpdateLinkAnchors(Links())
      Protected first = #True, px, py 
      ForEach Links()\Path()
        If Not first : LineXY(px, py, Links()\Path()\X, Links()\Path()\Y, $888888) : EndIf
        px = Links()\Path()\X : py = Links()\Path()\Y : first = #False 
      Next
    Next
    ForEach Nodes()
      Box(Nodes()\X, Nodes()\Y, Nodes()\w, Nodes()\h, Nodes()\color)
      DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Nodes()\X + (Nodes()\w-TextWidth(Nodes()\Text))/2, Nodes()\Y + (Nodes()\h-TextHeight(Nodes()\Text))/2, Nodes()\Text, $FFFFFF) : DrawingMode(#PB_2DDrawing_Default)
      If Editor\TargetNode = @Nodes()
        Protected fX, fY
        Select Editor\TargetSide
          Case 1 : fX = 0 : fY = #Margin + (Editor\TargetIdx * #StepS)
          Case 2 : fX = #Margin + (Editor\TargetIdx * #StepS) : fY = 0
          Case 3 : fX = Nodes()\w : fY = #Margin + (Editor\TargetIdx * #StepS)
          Case 4 : fX = #Margin + (Editor\TargetIdx * #StepS) : fY = Nodes()\h
        EndSelect
        Circle(Nodes()\X + fX, Nodes()\Y + fY, 6, $AAAAAA) 
      EndIf
      ForEach Nodes()\Ports() : Circle(Nodes()\X + Nodes()\Ports()\X, Nodes()\Y + Nodes()\Ports()\Y, 5 + Bool(Nodes()\Ports()\IsHovered)*3, Nodes()\Ports()\Color) : Next
    Next
    If Editor\DragPort : LineXY(Editor\ActiveSourceNode\X + Editor\DragPort\X, Editor\ActiveSourceNode\Y + Editor\DragPort\Y, GetGadgetAttribute(Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(Canvas, #PB_Canvas_MouseY), $AAAAAA) : EndIf
    StopDrawing()
  EndIf
EndProcedure

Procedure HandleCanvasEvents(Canvas)
  Protected mx = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX), my = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected et = EventType()
  Select et
    Case #PB_EventType_MouseMove
      Editor\TargetNode = #Null : Editor\TargetSide = 0 : Protected IsOverP.b = #False
      ForEach Nodes() : ForEach Nodes()\Ports() : Nodes()\Ports()\IsHovered = #False
          If Abs(mx-(Nodes()\X+Nodes()\Ports()\X)) < 12 And Abs(my-(Nodes()\Y+Nodes()\Ports()\Y)) < 12 : Nodes()\Ports()\IsHovered = #True : IsOverP = #True : EndIf
      Next : Next
      If Editor\DragNode
        Editor\DragNode\X = Round((mx-Editor\DragOffX)/#GridSize, #PB_Round_Nearest)*#GridSize : Editor\DragNode\Y = Round((my-Editor\DragOffY)/#GridSize, #PB_Round_Nearest)*#GridSize
      ElseIf Editor\DragPort And IsOverP = #False
        ForEach Nodes() : If @Nodes() <> Editor\ActiveSourceNode
          If mx >= Nodes()\X And mx <= Nodes()\X + Nodes()\w And my >= Nodes()\Y And my <= Nodes()\Y + Nodes()\h
            Protected dL = Abs(mx-Nodes()\X), dR = Abs(mx-(Nodes()\X+Nodes()\w)), dT = Abs(my-Nodes()\Y), dB = Abs(my-(Nodes()\Y+Nodes()\h))
            Protected minDist = Min(Min(dL, dR), Min(dT, dB))
            If minDist < 15
              If minDist = dL : Editor\TargetSide = 1 : ElseIf minDist = dT : Editor\TargetSide = 2 : ElseIf minDist = dR : Editor\TargetSide = 3 : ElseIf minDist = dB : Editor\TargetSide = 4 : EndIf
              Protected mI = -1 : ForEach Nodes()\Ports() : If Nodes()\Ports()\Side = Editor\TargetSide And Nodes()\Ports()\Index > mI : mI = Nodes()\Ports()\Index : EndIf : Next
              Protected rawI : If Editor\TargetSide = 1 Or Editor\TargetSide = 3 : rawI = Round((my-Nodes()\Y-#Margin)/#StepS, #PB_Round_Nearest) : Else : rawI = Round((mx-Nodes()\X-#Margin)/#StepS, #PB_Round_Nearest) : EndIf
              Editor\TargetIdx = Max(mI + 1, rawI) : Editor\TargetNode = @Nodes() : Break
            EndIf
          EndIf
        EndIf : Next
      EndIf
    Case #PB_EventType_LeftButtonDown
      ForEach Nodes() : ForEach Nodes()\Ports() : If Nodes()\Ports()\IsHovered : Editor\DragPort=@Nodes()\Ports() : Editor\ActiveSourceNode=@Nodes() : Break 2 : EndIf : Next
        If mx>Nodes()\X And mx<Nodes()\X+Nodes()\w And my>Nodes()\Y And my<Nodes()\Y+Nodes()\h : Editor\DragNode=@Nodes() : Editor\DragOffX=mx-Nodes()\X : Editor\DragOffY=my-Nodes()\Y : MoveElement(Nodes(), #PB_List_Last) : Break : EndIf
      Next
    Case #PB_EventType_LeftButtonUp
      If Editor\DragPort : Protected *fP.Port = #Null, *fN.Node = #Null
        ForEach Nodes() : ForEach Nodes()\Ports() : If Nodes()\Ports()\IsHovered And @Nodes() <> Editor\ActiveSourceNode : *fP=@Nodes()\Ports() : *fN=@Nodes() : Break 2 : EndIf : Next : Next
        If *fP = #Null And Editor\TargetNode : *fN = Editor\TargetNode : *fP = AddNodePort(Editor\TargetNode, Editor\TargetSide, Editor\TargetIdx) : EndIf
        If *fP And *fN : AddElement(Links()) : Links()\fromNode = Editor\ActiveSourceNode : Links()\fromPort = Editor\DragPort : Links()\toNode = *fN : Links()\toPort = *fP : ClearList(Links()\Path()) : AddElement(Links()\Path()) : AddElement(Links()\Path()) : EndIf
      EndIf : Editor\DragNode=#Null : Editor\DragPort=#Null : Editor\TargetNode=#Null
  EndSelect
EndProcedure

; --- MAIN LOOP ---
OpenWindow(0, 0, 0, 1000, 750, "Node Editor: Click & Drag to Connect", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 1000, 750, #PB_Canvas_Keyboard)

CreateEditorNode(150, 200, "Node A") 
CreateEditorNode(600, 350, "Node B")

ReDraw(0)
Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget And EventGadget() = 0 
    HandleCanvasEvents(0) 
    ReDraw(0) 
  EndIf 
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 152
; FirstLine = 129
; Folding = -------
; EnableXP
; DPIAware