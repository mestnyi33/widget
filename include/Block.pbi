EnableExplicit

Structure PathPoint
  X.i
  Y.i
EndStructure


; --- СТРУКТУРЫ ---
Structure PORT Extends PathPoint
   Side.i : Color.i : IsHovered.b
EndStructure

Structure BLOCK Extends PathPoint
  w.i : h.i : Color.i : OffX.i : OffY.i
   List Ports.PORT()
EndStructure

Structure LINK
   *Block.BLOCK[2] ; Массив указателей на блоки
   *Port.PORT[2]   ; Массив указателей на порты
   Ratio.f : Color.i : IsHovered.b 
   
   ; ... ваши существующие поля
  List Path.PathPoint() ; Кэшированные точки пути
  UpdateRequired.b      ; Флаг: нужно ли пересчитать путь
EndStructure

Global NewList Blocks.BLOCK()
Global NewList Links.LINK()
Global *ActivePort.PORT = 0 : Global *ActivePortBlock.BLOCK = 0
Global IsDrawingLine.b = #False
Global PhantomX.i, PhantomY.i, PhantomSide.i, *PhantomBlock.BLOCK = 0
Global *SelectedConn.LINK = 0 

; --- ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ ---

; Расстояние от точки до отрезка (для точного выделения линии)
Procedure.f GetDistToSeg(px, py, x1, y1, x2, y2)
   Protected l2.f = Pow(x2-x1, 2) + Pow(y2-y1, 2)
   Protected t.f, d.f
   If l2 = 0 : ProcedureReturn Sqr(Pow(px-x1, 2) + Pow(py-y1, 2)) : EndIf
   t = ((px-x1)*(x2-x1) + (py-y1)*(y2-y1)) / l2
   If t < 0 : t = 0 : ElseIf t > 1 : t = 1 : EndIf
   d = Sqr(Pow(px - (x1 + t*(x2-x1)), 2) + Pow(py - (y1 + t*(y2-y1)), 2))
   ProcedureReturn d
EndProcedure

Procedure.b IsSegmentBlocked(x1, y1, x2, y2, margin = 10)
  Protected rectX, rectY, rectW, rectH
  ForEach Blocks()
    ; Не проверяем стартовый и конечный блоки (они задаются в Link)
    ; Здесь предполагается, что у вас есть доступ к ID или указателям блоков связи
    
    rectX = Blocks()\x - margin
    rectY = Blocks()\y - margin
    rectW = Blocks()\w + margin * 2
    rectH = Blocks()\h + margin * 2
    
    ; Проверка пересечения отрезка с прямоугольником (AABB)
    If x1 = x2 ; Вертикальный сегмент
      If x1 > rectX And x1 < rectX + rectW
        If (y1 < rectY + rectH And y2 > rectY) Or (y2 < rectY + rectH And y1 > rectY)
          ProcedureReturn #True
        EndIf
      EndIf
    ElseIf y1 = y2 ; Горизонтальный сегмент
      If y1 > rectY And y1 < rectY + rectH
        If (x1 < rectX + rectW And x2 > rectX) Or (x2 < rectX + rectW And x1 > rectX)
          ProcedureReturn #True
        EndIf
      EndIf
    EndIf
  Next
  ProcedureReturn #False
EndProcedure

Procedure CalculateLinkPath(*L.LINK)
  ClearList(*L\Path())
  
  ; Начальные данные
  Protected x1 = Blocks(*L\StartID)\x + Ports(*L\StartPort)\x
  Protected y1 = Blocks(*L\StartID)\y + Ports(*L\StartPort)\y
  Protected x2 = Blocks(*L\EndID)\x + Ports(*L\EndPort)\x
  Protected y2 = Blocks(*L\EndID)\y + Ports(*L\EndPort)\y
  
  Protected midX = x1 + (x2 - x1) * *L\Ratio
  
  ; Добавляем начальную точку
  AddElement(*L\Path()) : *L\Path()\x = x1 : *L\Path()\y = y1
  
  ; Простая проверка: если Z-образный путь перекрыт
  ; Сегмент 1: (x1, y1) -> (midX, y1)
  ; Сегмент 2: (midX, y1) -> (midX, y2)
  ; Сегмент 3: (midX, y2) -> (x2, y2)
  
  If IsSegmentBlocked(x1, y1, midX, y1) Or IsSegmentBlocked(midX, y1, midX, y2) Or IsSegmentBlocked(midX, y2, x2, y2)
    ; Нашли препятствие — ищем обход. 
    ; Для краткости: находим первый мешающий блок и берем его Y + Height + Margin
    ForEach Blocks()
      ; (Здесь логика поиска конкретного блока-препятствия)
      ; Добавляем точки обхода в List *L\Path()
      ; ...
    Next
  Else
    ; Путь чист — стандартные 4 точки (3 сегмента)
    AddElement(*L\Path()) : *L\Path()\x = midX : *L\Path()\y = y1
    AddElement(*L\Path()) : *L\Path()\x = midX : *L\Path()\y = y2
  EndIf
  
  AddElement(*L\Path()) : *L\Path()\x = x2 : *L\Path()\y = y2
EndProcedure

; ОТРИСОВКА С КОРОТКИМ ВЫНОСОМ И ВЫДЕЛЕНИЕМ
Procedure _DrawSmartLine(*L.LINK) 
   Protected x1, y1, x2, y2, color, Ratio.f, hovered.b
   Protected *SB.BLOCK=Links()\Port[0], *EB.BLOCK=Links()\Port[1]
   x1 = Links()\Block[0]\x + Links()\Port[0]\x
   y1 = Links()\Block[0]\y + Links()\Port[0]\y
   x2 = Links()\Block[1]\x + Links()\Port[1]\x
   y2 = Links()\Block[1]\y + Links()\Port[1]\y
   
   color = Links()\Color 
   Ratio = Links()\Ratio
   hovered = Links()\IsHovered
   Protected midX = x1 + (x2 - x1) * Ratio
   Protected margin = 20
   Protected offsetBtn = 0
   
   ; --- ГАРАНТИРОВАННЫЙ ОТСТУП ОТ РОДИТЕЛЬСКИХ БЛОКОВ ---
   ; Если линия выходит вправо, а перелом слева от края блока (и наоборот)
   If midX > *SB\x - margin And midX < *SB\x + *SB\w + margin
      If x1 <= *SB\x : midX = *SB\x - margin : Else : midX = *SB\x + *SB\w + margin : EndIf
   EndIf
   If midX > *EB\x - margin And midX < *EB\x + *EB\w + margin
      If x2 <= *EB\x : midX = *EB\x - margin : Else : midX = *EB\x + *EB\w + margin : EndIf
   EndIf
   
   ; --- ПРОВЕРКА ПРЕПЯТСТВИЙ (ДРУГИЕ БЛОКИ) ---
   ForEach Blocks()
      If @Blocks() <> *SB And @Blocks() <> *EB ; Не проверяем самих себя
         If midX > Blocks()\x - 5 And midX < Blocks()\x + Blocks()\w + 5
            If (y1 < Blocks()\y + Blocks()\h + 5 And y2 > Blocks()\y - 5) Or (y2 < Blocks()\y + Blocks()\h + 5 And y1 > Blocks()\y - 5)
               ; Если на пути чужой блок - обходим (5 сегментов)
               If y1 < Blocks()\y : offsetBtn = Blocks()\y - margin : Else : offsetBtn = Blocks()\y + Blocks()\h + margin : EndIf
               LineXY(x1, y1, midX, y1, color)
               LineXY(midX, y1, midX, offsetBtn, color)
               LineXY(midX, offsetBtn, x2 + (midX-x2), offsetBtn, color) ; Горизонталь обхода
               LineXY(x2 + (midX-x2), offsetBtn, x2 + (midX-x2), y2, color)
               LineXY(x2 + (midX-x2), y2, x2, y2, color)
               ProcedureReturn
            EndIf
         EndIf
      EndIf
   Next
   
   ; Если путь свободен - обычная Z-линия
   LineXY(x1, y1, midX, y1, color)
   LineXY(midX, y1, midX, y2, color)
   LineXY(midX, y2, x2, y2, color)
   
   If hovered ; Подсветка (жирная линия)
      LineXY(x1, y1+1, midX, y1+1, color) : LineXY(midX+1, y1, midX+1, y2, color) : LineXY(midX, y2+1, x2, y2+1, color)
   EndIf
EndProcedure
Procedure DrawSmartLine(*L.LINK)
  Protected color = *L\Color
  
  ; Если путь пуст или требует обновления — вызываем расчет (отдельная процедура)
  If *L\UpdateRequired Or ListSize(*L\Path()) = 0
    CalculateLinkPath(*L)
    *L\UpdateRequired = #False
  EndIf

  ; Отрисовка сегментов
  PushListPosition(*L\Path())
  FirstElement(*L\Path())
  Define px = *L\Path()\x, py = *L\Path()\y
  
  While NextElement(*L\Path())
    LineXY(px, py, *L\Path()\x, *L\Path()\y, color)
    If *L\IsHovered ; Рисуем "жирность" через смещение для 2D Drawing
      LineXY(px, py + 1, *L\Path()\x, *L\Path()\y + 1, color)
    EndIf
    px = *L\Path()\x : py = *L\Path()\y
  Wend
  PopListPosition(*L\Path())
EndProcedure

Procedure AddPort(*b.BLOCK, side.i, customX = -1, customY = -1)
   Protected pCount = 0, Offset
   AddElement(*b\Ports())
   *b\Ports()\Side = side
   If customX <> -1 And customY <> -1
      *b\Ports()\x = customX : *b\Ports()\y = customY
   Else
      PushListPosition(*b\Ports())
      ForEach *b\Ports() : If *b\Ports()\Side = side : pCount + 1 : EndIf : Next
      PopListPosition(*b\Ports())
      Offset = pCount * 12
      Select side
            Case 0 : *b\Ports()\x = 0 : *b\Ports()\y = Offset : Case 1 : *b\Ports()\x = *b\w : *b\Ports()\y = Offset
            Case 2 : *b\Ports()\x = Offset : *b\Ports()\y = 0 : Case 3 : *b\Ports()\x = Offset : *b\Ports()\y = *b\h
      EndSelect
   EndIf
   Select side
         Case 0 : *b\Ports()\Color = #Red : Case 1 : *b\Ports()\Color = #Green
         Case 2 : *b\Ports()\Color = #Blue : Case 3 : *b\Ports()\Color = #Yellow
   EndSelect
EndProcedure

Procedure CreateBlock(X, Y, w=120, h=80, init=#False)
   Protected i
   AddElement(Blocks())
   Blocks()\x = X : Blocks()\y = Y : Blocks()\w = w : Blocks()\h = h
   Blocks()\Color = $F5F5F5
   If init : For i = 0 To 3 : AddPort(@Blocks(), i) : Next : EndIf
EndProcedure

Procedure ReDraw(gad)
   Protected r
   If StartDrawing(CanvasOutput(gad))
      Box(0, 0, GadgetWidth(gad), GadgetHeight(gad), $FFFFFF)
      ForEach Links()
         DrawSmartLine(Links())
      Next
      ForEach Blocks()
         RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 2, 2, Blocks()\Color)
         DrawingMode(#PB_2DDrawing_Outlined) : RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 2, 2, 0) : DrawingMode(#PB_2DDrawing_Default)
         ForEach Blocks()\Ports()
            r = 3 : If Blocks()\Ports()\IsHovered : r = 5 : EndIf 
            Circle(Blocks()\x + Blocks()\Ports()\x, Blocks()\y + Blocks()\Ports()\y, r, Blocks()\Ports()\Color)
         Next
      Next
      If IsDrawingLine
         LineXY(*ActivePortBlock\x + *ActivePort\x, *ActivePortBlock\y + *ActivePort\y, GetGadgetAttribute(gad, #PB_Canvas_MouseX), GetGadgetAttribute(gad, #PB_Canvas_MouseY), *ActivePort\Color)
         If *PhantomBlock : Circle(*PhantomBlock\x + PhantomX, *PhantomBlock\y + PhantomY, 5, $AAAAAA) : EndIf
      EndIf
      StopDrawing()
   EndIf
EndProcedure

Procedure CanvasEvents()
   Protected mx, my, dxL, dxR, dyT, dyB, minD, side, pCount, foundPort, x1, y1, x2, y2, foundB, inside, StepPos
   Static *DragB.BLOCK = 0
   mx = GetGadgetAttribute(0, #PB_Canvas_MouseX) : my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   
   Select EventType()
      Case #PB_EventType_MouseMove
         If *DragB : *DragB\x = mx - *DragB\OffX : *DragB\y = my - *DragB\OffY : EndIf
         If *SelectedConn
            x1 = *SelectedConn\Block[0]\x + *SelectedConn\Port[0]\x : x2 = *SelectedConn\Block[1]\x + *SelectedConn\Port[1]\x
            If Abs(x2 - x1) > 10 : *SelectedConn\Ratio = (mx - x1) / (x2 - x1) : EndIf
         EndIf
         
         *PhantomBlock = 0 : foundPort = #False
         ForEach Blocks()
            ForEach Blocks()\Ports()
               If Abs(mx - (Blocks()\x + Blocks()\Ports()\x)) <= 8 And Abs(my - (Blocks()\y + Blocks()\Ports()\y)) <= 8
                  Blocks()\Ports()\IsHovered = #True : foundPort = #True
                  Else : Blocks()\Ports()\IsHovered = #False : EndIf
            Next
            If IsDrawingLine And @Blocks() <> *ActivePortBlock And Not foundPort
               inside = #False : If mx >= Blocks()\x And mx <= Blocks()\x + Blocks()\w And my >= Blocks()\y And my <= Blocks()\y + Blocks()\h : inside = #True : EndIf
               If Not inside
                  dxL = Abs(mx-Blocks()\x) : dxR = Abs(mx-(Blocks()\x+Blocks()\w)) : dyT = Abs(my-Blocks()\y) : dyB = Abs(my-(Blocks()\y+Blocks()\h))
                  minD = dxL : side = 0 : If dxR < minD : minD = dxR : side = 1 : EndIf : If dyT < minD : minD = dyT : side = 2 : EndIf : If dyB < minD : minD = dyB : side = 3 : EndIf
                  If minD <= 5
                     *PhantomBlock = @Blocks() : PhantomSide = side : pCount = 0
                     ForEach *PhantomBlock\Ports() : If *PhantomBlock\Ports()\Side = side : pCount + 1 : EndIf : Next
                     StepPos = (pCount + 1) * 12
                     Select side
                           Case 0 : PhantomX = 0 : PhantomY = StepPos : Case 1 : PhantomX = *PhantomBlock\w : PhantomY = StepPos
                           Case 2 : PhantomX = StepPos : PhantomY = 0 : Case 3 : PhantomX = StepPos : PhantomY = *PhantomBlock\h
                     EndSelect
                  EndIf
               EndIf
            EndIf
         Next
         
         ; ВЕРНУЛ ВЫДЕЛЕНИЕ ЛИНИЙ
         ForEach Links() : Links()\IsHovered = #False
            x1 = Links()\Block[0]\x + Links()\Port[0]\x : y1 = Links()\Block[0]\y + Links()\Port[0]\y
            x2 = Links()\Block[1]\x + Links()\Port[1]\x : y2 = Links()\Block[1]\y + Links()\Port[1]\y
            If GetDistToSeg(mx, my, x1, y1, x2, y2) < 10 : Links()\IsHovered = #True : EndIf
         Next
         
      Case #PB_EventType_LeftButtonDown
         ForEach Links() : If Links()\IsHovered : *SelectedConn = @Links() : ProcedureReturn : EndIf : Next
         ForEach Blocks()
            ForEach Blocks()\Ports() : If Blocks()\Ports()\IsHovered : *ActivePort = @Blocks()\Ports() : *ActivePortBlock = @Blocks() : IsDrawingLine = #True : ProcedureReturn : EndIf : Next
            If mx >= Blocks()\x And mx <= Blocks()\x + Blocks()\w And my >= Blocks()\y And my <= Blocks()\y + Blocks()\h : *DragB = @Blocks() : *DragB\OffX = mx-Blocks()\x : *DragB\OffY = my-Blocks()\y : Break : EndIf
         Next
      Case #PB_EventType_RightButtonDown
         ForEach Links() : If Links()\IsHovered : DeleteElement(Links()) : Break : EndIf : Next
      Case #PB_EventType_LeftButtonUp
         If IsDrawingLine
            If *PhantomBlock : AddPort(*PhantomBlock, PhantomSide, PhantomX, PhantomY) : LastElement(*PhantomBlock\Ports())
               AddElement(Links()) : Links()\Block[0] = *ActivePortBlock : Links()\Port[0] = *ActivePort : Links()\Block[1] = *PhantomBlock : Links()\Port[1] = @*PhantomBlock\Ports()
               Links()\Ratio = 0.5 : Links()\Color = *ActivePort\Color
               Else : ForEach Blocks() : ForEach Blocks()\Ports() : If Blocks()\Ports()\IsHovered And @Blocks()\Ports() <> *ActivePort
                        AddElement(Links()) : Links()\Block[0] = *ActivePortBlock : Links()\Port[0] = *ActivePort : Links()\Block[1] = @Blocks() : Links()\Port[1] = @Blocks()\Ports()
            Links()\Ratio = 0.5 : Links()\Color = *ActivePort\Color : Break 2 : EndIf : Next : Next : EndIf
         EndIf : IsDrawingLine = #False : *DragB = 0 : *PhantomBlock = 0 : *SelectedConn = 0
      Case #PB_EventType_LeftDoubleClick
         foundB = #False : ForEach Blocks()
            If mx >= Blocks()\x And mx <= Blocks()\x + Blocks()\w And my >= Blocks()\y And my <= Blocks()\y + Blocks()\h
               dxL = Abs(mx-Blocks()\x) : dxR = Abs(mx-(Blocks()\x+Blocks()\w)) : dyT = Abs(my-Blocks()\y) : dyB = Abs(my-(Blocks()\y+Blocks()\h))
               side = 0 : minD = dxL : If dxR < minD : minD = dxR : side = 1 : EndIf : If dyT < minD : minD = dyT : side = 2 : EndIf : If dyB < minD : minD = dyB : side = 3 : EndIf
         AddPort(@Blocks(), side) : foundB = #True : Break : EndIf : Next
         If Not foundB : CreateBlock(mx - 60, my - 40) : EndIf
   EndSelect
   ReDraw(0)
EndProcedure

OpenWindow(0, 0, 0, 800, 600, "Edward Project (Selection & Short Lines)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 800, 600) : CreateBlock(100, 150, 120, 80, #True) : CreateBlock(450, 150, 120, 80, #True) : ReDraw(0)
Repeat : Define Event = WaitWindowEvent() : If Event = #PB_Event_Gadget And EventGadget() = 0 : CanvasEvents() : EndIf : Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 10
; FirstLine = 6
; Folding = --4--------
; EnableXP
; DPIAware