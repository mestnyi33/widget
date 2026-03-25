EnableExplicit

; --- КОНСТАНТЫ ---
Enumeration
   #SIDE_NONE   = 0
   #SIDE_LEFT   = 1
   #SIDE_TOP    = 2
   #SIDE_RIGHT  = 3
   #SIDE_BOTTOM = 4
   
   #SIDE_TOP_LEFT     = 5
   #SIDE_TOP_RIGHT    = 6
   #SIDE_BOTTOM_LEFT  = 7
   #SIDE_BOTTOM_RIGHT = 8
EndEnumeration

Enumeration
   #PATH_Z       ; 4 точки
   #PATH_S       ; 6 точек (между блоками)
   #PATH_BYPASS  ; 6 точек (обход снаружи)
EndEnumeration


#GRID_SIZE = 10 

;-
CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
   Structure POINT
      X.i : Y.i
   EndStructure
   
   Structure RECT
      left.i
      top.i
      right.i
      bottom.i
   EndStructure
CompilerEndIf

Structure PORT Extends POINT
   Side.i : Color.i : Radius.i : Index.i
EndStructure

Structure BLOCK Extends POINT
   w.i : h.i : Color.i : OffX.i : OffY.i 
   ; Счетчики портов: 0-Left, 1-Right, 2-Top, 3-Bottom
   SideCount.i[4] 
   Title.s
   List Ports.PORT()
EndStructure

Structure LINK
   *Block.BLOCK[2] ; Массив указателей на блоки
   *Port.PORT[2]   ; Массив указателей на порты
   
   MidRatio.f      ; центральная ось
   OffsetStart.i   ; вылет от старта
   OffsetEnd.i     ; вылет до финиша
   OffsetMin.i
   
   BypassOffset.i
   BypassSide.i
   
   Type.i
   segment.i
   
   Color.i
   thick.b
   List Path.POINT() ; Список точек маршрута
EndStructure

;-
Global NewList Blocks.BLOCK(), NewList Links.LINK()
Global *EnteredPort.PORT = 0, *EnteredBlock.BLOCK = 0 , *DragBlock.BLOCK = 0
Global *SelectedPort.PORT = 0, *SelectedBlock.BLOCK = 0 
Global *EnteredLink.LINK = 0, *SelectLink.LINK = 0
Global *EnteredPath.POINT = 0, *SelectPath.POINT = 0

Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Macro IsMouseOver(mx, my, _ptr_)
   ((mx) >= _ptr_\x And (mx) <= _ptr_\x + _ptr_\w And (my) >= _ptr_\y And (my) <= _ptr_\y + _ptr_\h)
EndMacro

Macro IsMouseOverPort(mx, my, _blk_, _prt_, _dist_)
   (Abs((_blk_\x + _prt_\x) - (mx)) < (_dist_) And Abs((_blk_\y + _prt_\y) - (my)) < (_dist_))
EndMacro

;-
Procedure GetSideColor(Side.i)
   Select Side
         Case #SIDE_TOP : ProcedureReturn $00D7FF : Case #SIDE_RIGHT : ProcedureReturn $0000FF
         Case #SIDE_BOTTOM : ProcedureReturn $00FF00 : Case #SIDE_LEFT : ProcedureReturn $FF0000
   EndSelect
EndProcedure

Procedure.i EnteredSide(*B.BLOCK, mx.l, my.l, t.l = 5)
   Protected dxL, dxR, dyT, dyB, minD, side
   Protected  cOff.i = t
   
   
   ;   ;1 Проверка: находится ли мышь внутри блока
   ;   If mx < *B\x Or mx > *B\x + *B\w Or 
   ;      my < *B\y Or my > *B\y + *B\h
   ;     ProcedureReturn #SIDE_NONE
   ;   EndIf
   ;   
   ; Считаем дистанции до границ
   dxL = Abs(mx - *B\x) 
   dxR = Abs(mx - (*B\x + *B\w)) 
   dyT = Abs(my - *B\y) 
   dyB = Abs(my - (*B\y + *B\h))
   ;   
   ;   ; Ищем ближайшую сторону
   ;   minD = dxL : side = #SIDE_LEFT
   ;   If dxR < minD : minD = dxR : side = #SIDE_RIGHT : EndIf 
   ;   If dyT < minD : minD = dyT : side = #SIDE_TOP   : EndIf 
   ;   If dyB < minD : minD = dyB : side = #SIDE_BOTTOM : EndIf 
   
   ;   ; Если до ближайшей стороны дальше порога — значит мы в центре
   ;   If minD > t
   ;     ProcedureReturn #SIDE_NONE
   ;   EndIf
   
   
   ;   ; 2. Битовая сборка стороны (проверяем близость к каждой грани)
   ;   If mx <= *b\x + t        : side = #SIDE_LEFT   : EndIf
   ;   If mx >= *b\x + *b\w - t : side = #SIDE_RIGHT  : EndIf
   ;   If my <= *b\y + t        : side = #SIDE_TOP    : EndIf
   ;   If my >= *b\y + *b\h - t : side = #SIDE_BOTTOM : EndIf
   
   ;Procedure.i GetMouseSideStrict(*b.RectBlock, mx.i, my.i, t.i = 6, cOff.i = 15)
   ;   Protected dxL, dxR, dyT, dyB
   ;   
   ;   ; 1. Быстрая проверка границ
   ;   If mx < *b\x Or mx > *b\x + *b\w Or my < *b\y Or my > *b\y + *b\h
   ;     ProcedureReturn #SIDE_NONE
   ;   EndIf
   
   ;   ; 2. Дистанции (уже без Abs, так как мы внутри)
   ;   dxL = mx - *b\x
   ;   dxR = (*b\x + *b\w) - mx
   ;   dyT = my - *b\y
   ;   dyB = (*b\y + *b\h) - my
   
   ; 3. ПРОВЕРКА УГЛОВ (Приоритет №1)
   ; Если мышь в квадрате cOff x cOff в любом из углов
   If dxL <= cOff And dyT <= cOff : ProcedureReturn #SIDE_TOP_LEFT     : EndIf
   If dxR <= cOff And dyT <= cOff : ProcedureReturn #SIDE_TOP_RIGHT    : EndIf
   If dxL <= cOff And dyB <= cOff : ProcedureReturn #SIDE_BOTTOM_LEFT  : EndIf
   If dxR <= cOff And dyB <= cOff : ProcedureReturn #SIDE_BOTTOM_RIGHT : EndIf
   
   ; 4. ПРОВЕРКА СТОРОН (Приоритет №2)
   ; Сработает только если мы ВНЕ угловых зон
   If dxL <= t : ProcedureReturn #SIDE_LEFT   : EndIf
   If dxR <= t : ProcedureReturn #SIDE_RIGHT  : EndIf
   If dyT <= t : ProcedureReturn #SIDE_TOP    : EndIf
   If dyB <= t : ProcedureReturn #SIDE_BOTTOM : EndIf
   
   ProcedureReturn #SIDE_NONE
   
   ProcedureReturn side
EndProcedure

;-
Procedure.i EnterPath(mx, my, *L.LINK)
   ; Возвращает индекс сегмента (с 1) или 0, если не наведен
   If ListSize(*L\Path()) < 2 : ProcedureReturn 0 : EndIf
   
   PushListPosition(*L\Path())
   FirstElement(*L\Path())
   
   Protected result.i = 0
   Protected segment.i = 0
   Protected thick = *L\thick + 2
   Protected x1 = *L\Path()\X, y1 = *L\Path()\Y
   
   While NextElement(*L\Path())
      Protected x2 = *L\Path()\X, y2 = *L\Path()\Y
      segment + 1
      
      If x1 = x2 ; Вертикаль
         If mx >= x1-thick And mx <= x1+thick And my >= Min(y1,y2)-thick And my <= Max(y1,y2)+thick
            result = segment
            Break
         EndIf
      Else ; Горизонталь
         If my >= y1-thick And my <= y1+thick And mx >= Min(x1,x2)-thick And mx <= Max(x1,x2)+thick
            result = segment
            Break
         EndIf
      EndIf
      
      x1 = x2 : y1 = y2
   Wend
   
   PopListPosition(*L\Path())
   ProcedureReturn result
EndProcedure

Procedure AddPath(*L.LINK, X.i, Y.i)
   If ListSize(*L\Path()) = 0
      AddElement(*L\Path()) : *L\Path()\X = X : *L\Path()\Y = Y
      ProcedureReturn
   EndIf
   
   LastElement(*L\Path())
   Protected curX = *L\Path()\X
   Protected curY = *L\Path()\Y
   
   ; 1. Если точка совпадает — выходим
   If curX = X And curY = Y : ProcedureReturn : EndIf
   
   ; 2. УМНЫЙ SNAP: Если линия идет по диагонали, принудительно создаем Г-образный изгиб
   ; Это гарантирует ортогональность БЕЗ потери точности финальной точки.
   If curX <> X And curY <> Y
      AddElement(*L\Path())
      ; Выбираем, как повернуть: по длинной стороне или по логике портов.
      ; Чаще всего для ортогональных сетей лучше сначала дотянуть до нужной оси.
      If Abs(X - curX) > Abs(Y - curY)
         *L\Path()\X = X : *L\Path()\Y = curY
      Else
         *L\Path()\X = curX : *L\Path()\Y = Y
      EndIf
      ; Теперь curX/curY обновляются, так как мы добавили "колено"
      curX = *L\Path()\X : curY = *L\Path()\Y
   EndIf
   
   ; 3. ОПТИМИЗАЦИЯ (склейка трех точек на одной прямой)
   If ListSize(*L\Path()) >= 2
      PushListPosition(*L\Path())
      PreviousElement(*L\Path())
      Protected *p1.Point = *L\Path() ; Предпоследняя
      PopListPosition(*L\Path())
      
      If (*p1\X = curX And curX = X) Or (*p1\Y = curY And curY = Y)
         *L\Path()\X = X : *L\Path()\Y = Y
         ProcedureReturn
      EndIf
   EndIf
   
   ; 4. Финальное добавление точки
   AddElement(*L\Path())
   *L\Path()\X = X : *L\Path()\Y = Y
   ProcedureReturn @*L\Path()
EndProcedure

Procedure UpdatePath(*L.LINK)
   ClearList(*L\Path())
   
   ; --- 1. ДАННЫЕ И ПАРАМЕТРЫ ---
   Protected lineSpacing.i = 14 
   Protected baseMargin.i  = 25 
   Protected sideIdx.i    = *L\Port[0]\Side - 1
   Protected totalPorts.i = *L\Block[0]\SideCount[sideIdx]
   Protected myIndex.i    = *L\Port[0]\Index
   
   ; Центрирование пучка
   Protected bundleOffset.i = (myIndex * lineSpacing) - ((totalPorts - 1) * lineSpacing) / 2
   
   ; Координаты портов с учетом смещения в пучке
   Protected x1.i = *L\Block[0]\X + *L\Port[0]\X, y1.i = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2.i = *L\Block[1]\X + *L\Port[1]\X, y2.i = *L\Block[1]\Y + *L\Port[1]\Y
   
   If *L\Port[0]\Side < 3 : y1 + bundleOffset : Else : x1 + bundleOffset : EndIf
   
   Protected isVertical.b = Bool(*L\Port[0]\Side >= 3)
   Protected m1.i = *L\OffsetStart, m2.i = *L\OffsetEnd
   
   ; Точки вылета (Fly-points)
   Protected tx1.i = x1, ty1.i = y1, tx2.i = x2, ty2.i = y2
   Select *L\Port[0]\Side
      Case 1 : tx1 - m1 : Case 2 : tx1 + m1 : Case 3 : ty1 - m1 : Case 4 : ty1 + m1
   EndSelect
   Select *L\Port[1]\Side
      Case 1 : tx2 - m2 : Case 2 : tx2 + m2 : Case 3 : ty2 - m2 : Case 4 : ty2 + m2
   EndSelect
   
   ; --- 2. ВЫБОР ТИПА ПУТИ (Логика коридоров) ---
   Protected gap.i
   If Not isVertical
      gap = tx2 - tx1
      ; Проверка Z-пути (порты смотрят друг на друга и есть зазор)
      If (*L\Port[0]\Side = 2 And *L\Port[1]\Side = 1 And gap > 0) Or 
         (*L\Port[0]\Side = 1 And *L\Port[1]\Side = 2 And gap < 0)
         *L\Type = #PATH_Z
      Else
         ; Проверка S-пути (есть ли коридор по вертикали между блоками)
         Protected corridorY = 0
         If y2 > y1 : corridorY = *L\Block[1]\Y - (*L\Block[0]\Y + *L\Block[0]\H)
         Else       : corridorY = *L\Block[0]\Y - (*L\Block[1]\Y + *L\Block[1]\H) : EndIf
         
         If corridorY > (baseMargin + (totalPorts * lineSpacing)) : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
      EndIf
   Else
      ; Вертикальная логика (аналогично)
      gap = ty2 - ty1
      If (*L\Port[0]\Side = 4 And *L\Port[1]\Side = 3 And gap > 0) Or 
         (*L\Port[0]\Side = 3 And *L\Port[1]\Side = 4 And gap < 0)
         *L\Type = #PATH_Z
      Else
         Protected corridorX = 0
         If x2 > x1 : corridorX = *L\Block[1]\X - (*L\Block[0]\X + *L\Block[0]\W)
         Else       : corridorX = *L\Block[0]\X - (*L\Block[1]\X + *L\Block[1]\W) : EndIf
         
         If corridorX > (baseMargin + (totalPorts * lineSpacing)) : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
      EndIf
   EndIf

   ; --- 3. ПОСТРОЕНИЕ ТОЧЕК ---
   AddElement(*L\Path()) : *L\Path()\X = x1 : *L\Path()\Y = y1
   AddElement(*L\Path()) : *L\Path()\X = tx1 : *L\Path()\Y = ty1
   
   Select *L\Type
      Case #PATH_Z
         If Not isVertical
            Protected midX = tx1 + (tx2 - tx1) * *L\MidRatio
            AddElement(*L\Path()) : *L\Path()\X = midX : *L\Path()\Y = y1
            AddElement(*L\Path()) : *L\Path()\X = midX : *L\Path()\Y = y2
         Else
            Protected midY = ty1 + (ty2 - ty1) * *L\MidRatio
            AddElement(*L\Path()) : *L\Path()\X = x1 : *L\Path()\Y = midY
            AddElement(*L\Path()) : *L\Path()\X = x2 : *L\Path()\Y = midY
         EndIf
         
      Case #PATH_S
         If Not isVertical
            Protected sMidY = (ty1 + ty2) / 2 + bundleOffset
            AddElement(*L\Path()) : *L\Path()\X = tx1 : *L\Path()\Y = sMidY
            AddElement(*L\Path()) : *L\Path()\X = tx2 : *L\Path()\Y = sMidY
         Else
            Protected sMidX = (tx1 + tx2) / 2 + bundleOffset
            AddElement(*L\Path()) : *L\Path()\X = sMidX : *L\Path()\Y = ty1
            AddElement(*L\Path()) : *L\Path()\X = sMidX : *L\Path()\Y = ty2
         EndIf
         
      Case #PATH_BYPASS
         Protected bMargin = baseMargin + (myIndex * 6) + *L\BypassOffset
         If Not isVertical
            Protected bY = 0
            If y2 > y1 : bY = Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + bMargin
            Else       : bY = Min(*L\Block[0]\Y, *L\Block[1]\Y) - bMargin : EndIf
            AddElement(*L\Path()) : *L\Path()\X = tx1 : *L\Path()\Y = bY
            AddElement(*L\Path()) : *L\Path()\X = tx2 : *L\Path()\Y = bY
         Else
            Protected bX = 0
            If x2 > x1 : bX = Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + bMargin
            Else       : bX = Min(*L\Block[0]\X, *L\Block[1]\X) - bMargin : EndIf
            AddElement(*L\Path()) : *L\Path()\X = bX : *L\Path()\Y = ty1
            AddElement(*L\Path()) : *L\Path()\X = bX : *L\Path()\Y = ty2
         EndIf
   EndSelect
   
   AddElement(*L\Path()) : *L\Path()\X = tx2 : *L\Path()\Y = ty2
   AddElement(*L\Path()) : *L\Path()\X = x2 : *L\Path()\Y = y2
EndProcedure

Procedure UpdatePath1(*L.LINK)
   ClearList(*L\Path())
   
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.i = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   ; --- 1. ПОДГОТОВКА ДАННЫХ ИЗ ВАШИХ СТРУКТУР ---
   Protected sideIdx.i = *L\Port[0]\Side - 1  ; Индекс 0-3 из Side 1-4
   Protected order.i = *L\Port[0]\Index   ; Порядковый номер порта на этой стороне
   Protected sidecount.i = *L\Block[0]\SideCount[sideIdx]
   
   Protected baseMargin = 20, lineSpacing = 10
   Protected invertedOrder = (sidecount - 1) - order
   Protected totalWidth = (sidecount - 1) * lineSpacing
   
   ;Debug ""+sidecount+" "+order +" "+*L\Port[1]\Index+" "+sideIdx
   
   ; --- ГЛОБАЛЬНОЕ ОПРЕДЕЛЕНИЕ НАПРАВЛЕНИЯ ---
   Protected activeOrder, targetOrder, isForward.b
   If (x2 > x1 And isVertical) Or (y2 > y1 And Not isVertical) 
      activeOrder = invertedOrder
      targetOrder = order
      isForward = #True
   Else
      activeOrder = order
      targetOrder = invertedOrder
      isForward = #False
   EndIf
   
   ; --- ОПРЕДЕЛЕНИЕ ТИПА ПУТИ ---
   If Not isVertical
      Protected corridorY = 0
      If y2 > y1 : corridorY = *L\Block[1]\Y - (*L\Block[0]\Y + *L\Block[0]\H)
         Else       : corridorY = *L\Block[0]\Y - (*L\Block[1]\Y + *L\Block[1]\H) : EndIf
      
      If x2 > (x1 + (baseMargin * 2) + totalWidth) : *L\Type = #PATH_Z
      ElseIf corridorY > (baseMargin + totalWidth) : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
   Else
      Protected corridorX = 0
      If x2 > x1 : corridorX = *L\Block[1]\X - (*L\Block[0]\X + *L\Block[0]\W)
         Else       : corridorX = *L\Block[0]\X - (*L\Block[1]\X + *L\Block[1]\W) : EndIf
      
      If y2 > (y1 + (baseMargin * 2) + totalWidth) : *L\Type = #PATH_Z
      ElseIf corridorX > (baseMargin + totalWidth) : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
   EndIf
   
   AddPath(*L, x1, y1)
   
   Select *L\Type
      Case #PATH_Z
         Protected bundleOffset = (activeOrder * lineSpacing) - (totalWidth / 2)
         If Not isVertical
            Protected dynamicMidX = x1 + (x2 - x1) * *L\MidRatio + bundleOffset
            ; Protected dynamicMidX = (x1 + x2) / 2 + bundleOffset
            AddPath(*L, dynamicMidX, y1) : AddPath(*L, dynamicMidX, y2)
         Else
            Protected dynamicMidY = y1 + (y2 - y1) * *L\MidRatio + bundleOffset
            ; Protected dynamicMidY = (y1 + y2) / 2 + bundleOffset
            AddPath(*L, x1, dynamicMidY) : AddPath(*L, x2, dynamicMidY)
         EndIf
         ;         
      Case #PATH_S
         Protected sMid, sOffA, sOffB
         sOffA = baseMargin + (activeOrder * lineSpacing)
         sOffB = baseMargin + (targetOrder * lineSpacing) 
         
         If Not isVertical
            If isForward : sMid = (*L\Block[0]\Y + *L\Block[0]\H + *L\Block[1]\Y) / 2
               Else         : sMid = (*L\Block[1]\Y + *L\Block[1]\H + *L\Block[0]\Y) / 2 : EndIf
            
            sMid + (invertedOrder * lineSpacing) - (totalWidth / 2)
            ; sMid = y1 + ((y2 - y1) * *L\MidRatio) + (invertedOrder * lineSpacing) - (totalWidth / 2)
            AddPath(*L, x1 + sOffA, y1)
            AddPath(*L, x1 + sOffA, sMid)
            AddPath(*L, x2 - sOffB, sMid)
            AddPath(*L, x2 - sOffB, y2)
         Else
            If isForward : sMid = (*L\Block[0]\X + *L\Block[0]\W + *L\Block[1]\X) / 2
               Else         : sMid = (*L\Block[1]\X + *L\Block[1]\W + *L\Block[0]\X) / 2 : EndIf
            
            sMid + (invertedOrder * lineSpacing) - (totalWidth / 2)
            ;sMid = x1 + (x2 - x1) * *L\MidRatio + (invertedOrder * lineSpacing) - (totalWidth / 2)
            AddPath(*L, x1, y1 + sOffA)
            AddPath(*L, sMid, y1 + sOffA)
            AddPath(*L, sMid, y2 - sOffB)
            AddPath(*L, x2, y2 - sOffB)
         EndIf
         
      Case #PATH_BYPASS
         Protected Margin = baseMargin + (activeOrder * lineSpacing) + *L\BypassOffset
         Protected bypassX, bypassY
         If isForward
            bypassX = Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + Margin
            bypassY = Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + Margin
         Else
            bypassX = Min(*L\Block[0]\X, *L\Block[1]\X) - Margin
            bypassY = Min(*L\Block[0]\Y, *L\Block[1]\Y) - Margin 
         EndIf
         
         If Not isVertical
            AddPath(*L, x1 + Margin, y1) : AddPath(*L, x1 + Margin, bypassY)
            AddPath(*L, x2 - Margin, bypassY) : AddPath(*L, x2 - Margin, y2)
         Else
            AddPath(*L, x1, y1 + Margin) : AddPath(*L, bypassX, y1 + Margin)
            AddPath(*L, bypassX, y2 - Margin) : AddPath(*L, x2, y2 - Margin)
         EndIf
   EndSelect
   
   AddPath(*L, x2, y2)
EndProcedure

Procedure UpdatePath3(*L.LINK)
   ClearList(*L\Path())
   
   ; Параметры из второго кода
   Protected baseMargin.i  = 25
   Protected lineSpacing.i = 8
;    Protected Count.i = *L\Count ; Общее кол-во связей между этими портами
;    Protected order.i = *L\Index ; Порядковый номер текущей связи
   Protected sideIdx.i = *L\Port[0]\Side - 1  ; Индекс 0-3 из Side 1-4
   Protected count.i = *L\Block[0]\SideCount[sideIdx]
   Protected Index.i = *L\Port[0]\Index   ; Порядковый номер порта на этой стороне
   Protected order.i = *L\Port[0]\Index   ; Порядковый номер порта на этой стороне
   
   ; Координаты портов (используем структуру из первого кода)
   Protected x1.i = *L\Block[0]\X + *L\Port[0]\X
   Protected y1.i = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2.i = *L\Block[1]\X + *L\Port[1]\X
   Protected y2.i = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.b = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   
   ; 1. УНИВЕРСАЛЬНАЯ ИНВЕРСИЯ ПОРЯДКА (из кода №2)
   ; Предотвращает пересечение линий при смене направления
   If isVertical
      If x2 < x1 : order = (Count - 1) - Index : EndIf
   Else
      If y2 < y1 : order = (Count - 1) - Index : EndIf
   EndIf
   
   AddPath(*L, x1, y1)
   
   If Not isVertical
      ; ==========================================
      ;   ГОРИЗОНТАЛЬНЫЕ ПОРТЫ (LEFT/RIGHT)
      ; ==========================================
      ; Проверка на свободный Z-путь (лесенка)
      If (*L\Port[0]\Side = #SIDE_RIGHT And *L\Port[1]\Side = #SIDE_LEFT And x2 > (x1 + (baseMargin * 2)))
         
         Protected midX = (x1 + x2) / 2
         ; Расчет динамического центра для группы линий
         Protected zOrderH = (Count - 1) - order 
         Protected dynamicMidX = midX + (zOrderH * lineSpacing) - ((Count * lineSpacing) / 2)
         
         AddPath(*L, dynamicMidX, y1)
         AddPath(*L, dynamicMidX, y2)
         *L\Type = #PATH_Z
         
      Else
         ; --- BYPASS / S-ОБРАЗНЫЙ ПУТЬ (из кода №2) ---
         Protected bOrderH = (Count - 1) - order
         Protected bOffsetH = baseMargin + (bOrderH * lineSpacing)
         
         Protected bypassY.i
         If y2 > y1
            bypassY = Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + bOffsetH
         Else
            bypassY = Min(*L\Block[0]\Y, *L\Block[1]\Y) - bOffsetH
         EndIf
         
         ; Определяем точки вылета в зависимости от стороны порта
         Protected sideOff1 = bOffsetH : If *L\Port[0]\Side = #SIDE_LEFT : sideOff1 = -bOffsetH : EndIf
         Protected sideOff2 = bOffsetH : If *L\Port[1]\Side = #SIDE_RIGHT : sideOff2 = -bOffsetH : EndIf
         
         AddPath(*L, x1 + sideOff1, y1)
         AddPath(*L, x1 + sideOff1, bypassY)
         AddPath(*L, x2 - sideOff2, bypassY)
         AddPath(*L, x2 - sideOff2, y2)
         *L\Type = #PATH_BYPASS
      EndIf
      
   Else
      ; ==========================================
      ;   ВЕРТИКАЛЬНЫЕ ПОРТЫ (TOP/BOTTOM)
      ; ==========================================
      ; Проверка на свободный Z-путь
      If (*L\Port[0]\Side = #SIDE_BOTTOM And *L\Port[1]\Side = #SIDE_TOP And y2 > (y1 + (baseMargin * 2)))
         
         Protected midY = (y1 + y2) / 2
         Protected zOrderV = (Count - 1) - order 
         Protected dynamicMidY = midY + (zOrderV * lineSpacing) - ((Count * lineSpacing) / 2)
         
         AddPath(*L, x1, dynamicMidY)
         AddPath(*L, x2, dynamicMidY)
         *L\Type = #PATH_Z
         
      Else
         ; --- BYPASS / S-ОБРАЗНЫЙ ПУТЬ ---
         Protected bOrderV = (Count - 1) - order
         Protected bOffsetV = baseMargin + (bOrderV * lineSpacing)
         
         Protected bypassX.i
         If x2 > x1
            bypassX = Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + bOffsetV
         Else
            bypassX = Min(*L\Block[0]\X, *L\Block[1]\X) - bOffsetV
         EndIf
         
         ; Определяем точки вылета
         Protected vSideOff1 = bOffsetV : If *L\Port[0]\Side = #SIDE_TOP : vSideOff1 = -bOffsetV : EndIf
         Protected vSideOff2 = bOffsetV : If *L\Port[1]\Side = #SIDE_BOTTOM : vSideOff2 = -bOffsetV : EndIf
         
         AddPath(*L, x1, y1 + vSideOff1)
         AddPath(*L, bypassX, y1 + vSideOff1)
         AddPath(*L, bypassX, y2 - vSideOff2)
         AddPath(*L, x2, y2 - vSideOff2)
         *L\Type = #PATH_BYPASS
      EndIf
   EndIf
   
   AddPath(*L, x2, y2)
EndProcedure


Procedure MovePath(mx, my, *L.LINK)
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   Protected IsHor.b = Bool(*L\Port[0]\Side = #SIDE_LEFT Or *L\Port[0]\Side = #SIDE_RIGHT)
   Protected minOff = *L\OffsetMin
   
   Select *L\segment
         Case 2 : If IsHor : *L\OffsetStart = Abs(mx - x1) : Else : *L\OffsetStart = Abs(my - y1) : EndIf
         Case 4, 5 : If IsHor : *L\OffsetEnd = Abs(mx - x2) : Else : *L\OffsetEnd = Abs(my - y2) : EndIf
      Case 3 : ; Центральная полка
         If *L\Type = #PATH_BYPASS
            If IsHor
               If *L\BypassSide = #SIDE_BOTTOM
                  *L\BypassOffset = my - (Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + minOff)
               Else
                  *L\BypassOffset = (Min(*L\Block[0]\Y, *L\Block[1]\Y) - minOff) - my
               EndIf
            Else
               If *L\BypassSide = #SIDE_RIGHT
                  *L\BypassOffset = mx - (Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + minOff)
               Else
                  *L\BypassOffset = (Min(*L\Block[0]\X, *L\Block[1]\X) - minOff) - mx
               EndIf
            EndIf
         Else
            ; S-путь / Z-путь
            If IsHor : If (y2-y1)<>0 : *L\MidRatio = (my - y1) / (y2 - y1) : EndIf
            Else     : If (x2-x1)<>0 : *L\MidRatio = (mx - x1) / (x2 - x1) : EndIf : EndIf
            *L\BypassOffset = 0 ; Сброс для плавного перехода в Bypass
         EndIf
   EndSelect
   
   UpdatePath(*L) 
EndProcedure
Procedure MovePath1(mx, my, *L.LINK)
   Protected x1.i = *L\Block[0]\X + *L\Port[0]\X
   Protected y1.i = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2.i = *L\Block[1]\X + *L\Port[1]\X
   Protected y2.i = *L\Block[1]\Y + *L\Port[1]\Y
   Protected minOff = *L\OffsetMin + *L\thick
   
   ; Определяем ориентацию портов (Горизонтальные или Вертикальные)
   Protected IsHorizontalPorts.b = Bool(*L\Port[0]\Side = #SIDE_LEFT Or *L\Port[0]\Side = #SIDE_RIGHT)
   
   If ListSize(*L\Path( )) = 4
      ; ЦЕНТРАЛЬНАЯ ПЕРЕМЫЧКА (в Z-пути)
      If *L\segment = 2 
         If IsHorizontalPorts
            ; Для горизонтальных портов центральная полка — ВЕРТИКАЛЬНАЯ. 
            ; Двигаем влево-вправо по X.
            If (x2 - x1) <> 0
               *L\MidRatio = (Mx - x1) / (x2 - x1)
            EndIf
         Else
            ; Для вертикальных портов центральная полка — ГОРИЗОНТАЛЬНАЯ.
            ; Двигаем её вверх-вниз по Y.
            If (y2 - y1) <> 0
               *L\MidRatio = (My - y1) / (y2 - y1)
            EndIf
         EndIf
      EndIf
   Else
      Protected gapX.i = Abs(x2 - x1) - minOff*2
      Protected gapY.i = Abs(y2 - y1) - minOff*2
      
      ; ДЛЯ S-ПУТИ (6 точек)
      Select *L\segment
         Case 2 ; Первый вылет
                ;            If IsHorizontalPorts
                ;               *L\OffsetStart = Abs(Mx - x1)
                ;            Else
                ;               *L\OffsetStart = Abs(My - y1) 
                ;            EndIf
            If IsHorizontalPorts
               *L\OffsetStart = Max(0, Abs(Mx - x1) - minOff)
               ; Ограничиваем, чтобы не зайти за край второго вылета
               If gapX > 0 : *L\OffsetStart = Min(*L\OffsetStart, gapX - *L\OffsetEnd) : EndIf
            Else
               *L\OffsetStart = Max(0, Abs(My - y1) - minOff)
               If gapY > 0 : *L\OffsetStart = Min(*L\OffsetStart, gapY - *L\OffsetEnd) : EndIf
            EndIf
            
         Case 3 ; ЦЕНТРАЛЬНАЯ ПЕРЕМЫЧКА (Строго МЕЖДУ блоками)
            Protected minY.i, maxY.i
            
            If IsHorizontalPorts
               ; 1. Определяем границы "коридора" между блоками
               ; Это пространство от низа верхнего блока до верха нижнего
               If y2 > y1
                  minY = *L\Block[0]\Y + *L\Block[0]\H + minOff
                  maxY = *L\Block[1]\Y - minOff
               Else
                  minY = *L\Block[1]\Y + *L\Block[1]\H + minOff
                  maxY = *L\Block[0]\Y - minOff
               EndIf
               
               ; 2. Если коридор существует (блоки не перекрывают друг друга)
               If maxY > minY
                  ; Ограничиваем координату мыши My этим коридором
                  Protected clampedY = My
                  If clampedY < minY : clampedY = minY : EndIf
                  If clampedY > maxY : clampedY = maxY : EndIf
                  
                  ; Рассчитываем Ratio только внутри этого свободного пространства
                  If (y2 - y1) <> 0
                     *L\MidRatio = (clampedY - y1) / (y2 - y1)
                  EndIf
               Else
                  ; Если блоки перекрывают друг друга - полка заблокирована (S-путь невозможен)
                  ; В этом случае можно либо не менять MidRatio, либо оставить 0.5
               EndIf
               
            Else
               ; Аналогично для ВЕРТИКАЛЬНЫХ портов (ограничиваем по X)
               If x2 > x1
                  Protected minX = *L\Block[0]\X + *L\Block[0]\W + minOff
                  Protected maxX = *L\Block[1]\X - minOff
               Else
                  minX = *L\Block[1]\X + *L\Block[1]\W + minOff
                  maxX = *L\Block[0]\X - minOff
               EndIf
               
               If maxX > minX
                  Protected clampedX = Mx
                  If clampedX < minX : clampedX = minX : EndIf
                  If clampedX > maxX : clampedX = maxX : EndIf
                  If (x2 - x1) <> 0
                     *L\MidRatio = (clampedX - x1) / (x2 - x1)
                  EndIf
               EndIf
            EndIf
            
            ;         Case 3 ; ЦЕНТРАЛЬНАЯ ПЕРЕМЫЧКА
            ;            ; Исправляем расчет Ratio, чтобы он не "прыгал" к портам
            ;            If IsHorizontalPorts
            ;               ; Двигаем по Y. Используем зазор между портами y2-y1
            ;               If Abs(y2 - y1) > 5 ; Защита от деления на ноль, если блоки на одной линии
            ;                  *L\MidRatio = (My - y1) / (y2 - y1)
            ;               EndIf
            ;            Else
            ;               ; Двигаем по X. Используем зазор x2-x1
            ;               If Abs(x2 - x1) > 5
            ;                  *L\MidRatio = (Mx - x1) / (x2 - x1)
            ;               EndIf
            ;            EndIf
            
         Case 4 ; Второй вылет
                ;            If IsHorizontalPorts
                ;               *L\OffsetEnd = Abs(Mx - x2)
                ;            Else
                ;               *L\OffsetEnd = Abs(My - y2)
                ;            EndIf
            
            If IsHorizontalPorts
               *L\OffsetEnd = Max(0, Abs(Mx - x2) - minOff)
               ; Ограничиваем, чтобы не столкнуться с первым вылетом
               If gapX > 0 : *L\OffsetEnd = Min(*L\OffsetEnd, gapX - *L\OffsetStart) : EndIf
            Else
               *L\OffsetEnd = Max(0, Abs(My - y2) - minOff)
               If gapY > 0 : *L\OffsetEnd = Min(*L\OffsetEnd, gapY - *L\OffsetStart) : EndIf
            EndIf
      EndSelect
      
      
      ;       ; Debug ""+ *L\segment +" "+ IsHorizontalPorts
      ;       ; ДЛЯ (в S-пути)
      ;       Select *L\segment
      ;          Case 2 
      ;             If IsHorizontalPorts
      ;                *L\OffsetStart   = Abs(Mx - x1)
      ;             Else
      ;                *L\OffsetStart   = Abs(My - y1) 
      ;             EndIf
      ;             
      ;          Case 3 ; ЦЕНТРАЛЬНАЯ ПЕРЕМЫЧКА (в S-пути)
      ;                 ; Проверка: находимся ли мы сейчас в режиме Bypass (огибание)
      ;                 ; (Логика определения берется из вашей UpdatePath)
      Protected isBypass.b = #False
      ;             Protected midVal = y1 + (y2 - y1) * *L\MidRatio
      ;             If IsHorizontalPorts
      ;                If midVal > *L\Block[1]\Y - 10 And midVal < (*L\Block[1]\Y + *L\Block[1]\H) + 10 : isBypass = #True : EndIf
      ;             EndIf
      ;             
      ;             If isBypass
      ;                ; Двигаем BypassOffset (внешний отступ)
      ;                If IsHorizontalPorts
      ;                   If my > y1 
      ;                      *L\BypassOffset = my - (Max(*L\Block[0]\Y+*L\Block[0]\H, *L\Block[1]\Y+*L\Block[1]\H))
      ;                   Else 
      ;                      *L\BypassOffset = (Min(*L\Block[0]\Y, *L\Block[1]\Y)) - my 
      ;                   EndIf
      ;                EndIf
      ;             Else
      ;                If IsHorizontalPorts
      ;                   ; Для горизонтальных портов центральная полка — ГОРИЗОНТАЛЬНАЯ. 
      ;                   ; Двигаем её вверх-вниз по Y.
      ;                   If (y2 - y1) <> 0
      ;                      *L\MidRatio = (My - y1) / (y2 - y1)
      ;                   EndIf
      ;                Else
      ;                   ; Для вертикальных портов центральная полка — ВЕРТИКАЛЬНАЯ.
      ;                   ; Двигаем влево-вправо по X.
      ;                   If (x2 - x1) <> 0
      ;                      *L\MidRatio = (Mx - x1) / (x2 - x1)
      ;                   EndIf
      ;                EndIf
      ;             EndIf
      ;             ;       
      ;          Case 4 
      ;             If IsHorizontalPorts
      ;                *L\OffsetEnd = Abs(Mx - x2)
      ;             Else
      ;                *L\OffsetEnd = Abs(My - y2)
      ;             EndIf
      ;       EndSelect
      ;       
   EndIf
   
   
   ; Магнит к 0.5 (только если не в Bypass)
   If Not isBypass 
      If Abs(*L\MidRatio - 0.5) < 0.03 : *L\MidRatio = 0.5 : EndIf
      ; Опционально: чистим хвосты
      *L\BypassOffset = 0 
   EndIf
   
   ; Ограничиваем значения, чтобы не уходить в минус
   If *L\OffsetStart < minOff : *L\OffsetStart = minOff : EndIf
   If *L\OffsetEnd < minOff : *L\OffsetEnd = minOff : EndIf
   If *L\MidRatio < 0 : *L\MidRatio = 0 : EndIf
   If *L\MidRatio > 1 : *L\MidRatio = 1 : EndIf
   
   ; Защита от "ныряния" линии внутрь блока
   If *L\BypassOffset < 0 : *L\BypassOffset = 0 : EndIf 
   
   UpdatePath(*L) ; Пересчитываем точки с новыми Ratio
EndProcedure

Procedure DrawPath(x1, y1, x2, y2, thick, color)
   Protected i, offset = thick / 2
   ; Рисуем сегмент с учетом толщины (ваша логика из Case)
   If x1 = x2 ; Вертикаль
      For i = -offset To thick - 1 - offset
         LineXY(x1 + i, y1, x1 + i, y2, color)
      Next
   ElseIf y1 = y2 ; Горизонталь
      For i = -offset To thick - 1 - offset
         LineXY(x1, y1 + i, x2, y2 + i, color)
      Next
   EndIf
EndProcedure


;-
; Внутренняя процедура пересчета размеров и позиций
Procedure UpdatePort(*B.BLOCK)
   Protected stepSize.i, minW = 90, minH = 60
   Protected maxL.i = 0, maxT.i = 0, maxR.i = 0, maxB.i = 0
   Protected countL = 0, countT = 0, countR = 0, countB = 0
   
   ; 1. Сначала считаем порядковые номера и позиции
   PushListPosition(*B\Ports())
   ForEach *B\Ports()
      stepSize = *B\Ports()\Radius * 2 + 2
      
      Select *B\Ports()\Side
         Case #SIDE_LEFT
            countL + 1 : *B\Ports()\y = countL * stepSize : *B\Ports()\x = 0
            If *B\Ports()\y > maxL : maxL = *B\Ports()\y : EndIf
            
         Case #SIDE_TOP
            countT + 1 : *B\Ports()\x = countT * stepSize : *B\Ports()\y = 0
            If *B\Ports()\x > maxT : maxT = *B\Ports()\x : EndIf
            
         Case #SIDE_RIGHT
            countR + 1 : *B\Ports()\y = countR * stepSize : *B\Ports()\x = *B\w
            If *B\Ports()\y > maxR : maxR = *B\Ports()\y : EndIf
            
         Case #SIDE_BOTTOM
            countB + 1 : *B\Ports()\x = countB * stepSize : *B\Ports()\y = *B\h
            If *B\Ports()\x > maxB : maxB = *B\Ports()\x : EndIf
      EndSelect
   Next
   
   ; 2. Определяем новые размеры с "запасом" для одного порта
   ; Берем максимум между текущим размером, портами и минимальным порогом (например, 60)
   Protected newH = maxL : If maxR > newH : newH = maxR : EndIf
   newH + (stepSize * 2) ; Добавляем свободное место снизу
   If newH < minH : newH = minH : EndIf
   
   Protected newW = maxT : If maxB > newW : newW = maxB : EndIf
   newW + (stepSize * 2) ; Добавляем свободное место справа
   If newW < minW : newW = minW : EndIf
   
   *B\h = newH
   *B\w = newW
   
   ; 3. Финальная привязка портов к динамическим краям (Право и Низ)
   ForEach *B\Ports()
      If *B\Ports()\Side = #SIDE_RIGHT  : *B\Ports()\x = *B\w : EndIf
      If *B\Ports()\Side = #SIDE_BOTTOM : *B\Ports()\y = *B\h : EndIf
   Next
   PopListPosition(*B\Ports())
EndProcedure

Procedure RemovePort(*B.BLOCK, *P.PORT)
   ForEach Links()
      If Links()\Port[0] = *P Or 
         Links()\Port[1] = *P 
         DeleteElement(Links()) 
      EndIf
   Next
   
   ChangeCurrentElement(*B\Ports(), *P)
   DeleteElement(*B\Ports())
   
   UpdatePort(*B)
EndProcedure

Procedure AddPort(*B.BLOCK, side.i, radius.i = 5)
   If side > 0 And side < 5
      AddElement(*B\Ports()) 
      *B\Ports()\Side = side 
      *B\Ports()\Radius = radius 
      *B\Ports()\Color = RGB(Random(255), Random(255), Random(255)) ;GetSideColor(side)
      *B\SideCount[side-1] = 1
      ;*B\Ports()\Index = *B\SideCount[side-1]
      ;*B\SideCount[side-1] + 1
      UpdatePort(*B)
      ProcedureReturn @*B\Ports()
   EndIf
EndProcedure

;-
Procedure RemoveLink(*L.LINK)
   ChangeCurrentElement(Links(), *L)
   DeleteElement(Links())
EndProcedure

Procedure AddLink( *SelectedBlock.BLOCK, *SelectedPort.PORT, *EnteredBlock.BLOCK, *EnteredPort.PORT, Ratio.f = 0.5, thick.b = 3 )
   ; Проверяем, что переданы корректные указатели
   If *SelectedPort And *EnteredPort
      
      AddElement(Links())
;       Links()\index = ListIndex(Links())
;       Links()\Count = ListSize(Links())
      
      ; Устанавливаем связи для обоих концов (индексы 0 и 1)
      Links()\Block[0] = *SelectedBlock
      Links()\Port[0]  = *SelectedPort
      
      Links()\Block[1] = *EnteredBlock
      Links()\Port[1]  = *EnteredPort
      
      ; Наследуем визуальные свойства
      Links()\Color        = *SelectedPort\Color
      Links()\OffsetMin    = 20
      Links()\thick        = thick
      Links()\OffsetStart  = Links()\OffsetMin+Links()\thick
      Links()\MidRatio     = Ratio
      Links()\OffsetEnd    = Links()\OffsetMin+Links()\thick
      
      
      UpdatePath(@Links())
      
      ProcedureReturn @Links()
   EndIf
   
   ProcedureReturn #False
EndProcedure

Procedure DrawLink(*L.LINK)
   ; Если в списке уже есть хотя бы 2 точки то рисуем
   If ListSize(*L\Path()) >= 2
      ; Фиксируем текущий элемент, чтобы не сбить цикл извне
      PushListPosition(*L\Path())
      
      FirstElement(*L\Path())
      Protected px = *L\Path()\x
      Protected py = *L\Path()\y
      
      ; Перебираем все точки и рисуем сегменты
      While NextElement(*L\Path())
         ; Debug "Рисую сегмент: " + Str(px) + "," + Str(py) + " -> " + Str(*L\Path()\x) + "," + Str(*L\Path()\y)
         
         ; Вызываем вашу процедуру рисования сегмента
         If *L = *EnteredLink And Not *SelectedPort
            DrawPath(px, py, *L\Path()\x, *L\Path()\y, *L\thick, *L\Color) 
            Circle(px, py, *L\thick, *L\Color) 
         Else
            DrawPath(px, py, *L\Path()\x, *L\Path()\y, 1, *L\Color) 
         EndIf
         
         ; Обновляем предыдущую точку
         px = *L\Path()\x
         py = *L\Path()\y
      Wend
      
      PopListPosition(*L\Path())
   EndIf
EndProcedure


;-
Procedure RemoveBlock(*B.BLOCK)
   ForEach Links()
      If Links()\Block[0] = *B Or
         Links()\Block[1] = *B 
         DeleteElement(Links()) 
      EndIf
   Next
   
   ChangeCurrentElement(Blocks(), *B)
   DeleteElement(Blocks())
EndProcedure

Procedure AddBlock(X, Y, Title.s = "Block")
   AddElement(Blocks()) : Blocks()\x = X : Blocks()\y = Y : Blocks()\w = 80 : Blocks()\h = 60
   Blocks()\Color = $F9F9F9 : Blocks()\Title = Title +" "+ ListSize(Blocks())
   AddPort(@Blocks(), #SIDE_LEFT) 
   AddPort(@Blocks(), #SIDE_TOP) 
   AddPort(@Blocks(), #SIDE_RIGHT) 
   AddPort(@Blocks(), #SIDE_BOTTOM)
       
   ProcedureReturn @Blocks()
EndProcedure

;-
; --- 1. ВАША ЛОГИКА ОТРИСОВКИ СЕГМЕНТА (вынесена для удобства) ---
; 2. Процедура ОТРИСОВКИ (вызывать в цикле рендера)
Procedure ReDraw(gad)
   Protected X, Y, ww = GadgetWidth(gad), hh = GadgetHeight(gad)
   If StartDrawing(CanvasOutput(gad))
      Box(0, 0, ww, hh, $FFFFFF)
      X = 0 : While X <= ww : Line(X, 0, 1, hh, $F3F3F3) : X + #GRID_SIZE : Wend
      Y = 0 : While Y <= hh : Line(0, Y, ww, 1, $F3F3F3) : Y + #GRID_SIZE : Wend
      
      ForEach Links()
         DrawLink(@Links())
      Next
      
      ForEach Blocks()
         RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 4, 4, Blocks()\Color)
         DrawingMode(#PB_2DDrawing_Outlined) : RoundBox(Blocks()\x, Blocks()\y, Blocks()\w, Blocks()\h, 4, 4, $CCCCCC)
         DrawingMode(#PB_2DDrawing_Transparent) : DrawText(Blocks()\x + 10, Blocks()\y + 8, Blocks()\Title, $444444)
         DrawingMode(#PB_2DDrawing_Default)
         ForEach Blocks()\Ports()
            Protected r = Blocks()\Ports()\Radius : If @Blocks()\Ports() = *EnteredPort : r + 2 : EndIf
            Circle(Blocks()\x + Blocks()\Ports()\x, Blocks()\y + Blocks()\Ports()\y, r, Blocks()\Ports()\Color)
         Next
      Next
      
      If *SelectedPort
         LineXY(*SelectedBlock\x + *SelectedPort\x, *SelectedBlock\y + *SelectedPort\y, GetGadgetAttribute(gad, #PB_Canvas_MouseX), GetGadgetAttribute(gad, #PB_Canvas_MouseY), *SelectedPort\Color)
      EndIf
      StopDrawing()
   EndIf
EndProcedure

;-
Procedure CanvasEvents()
   Protected mx = GetGadgetAttribute(0, #PB_Canvas_MouseX), my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
   Select EventType()
      Case #PB_EventType_MouseMove
         *EnteredPort = 0 : *EnteredBlock = 0 : *EnteredLink = 0
         
         ForEach Blocks()
            ForEach Blocks()\Ports()
               If IsMouseOverPort(mx, my, Blocks(), Blocks()\Ports(), 10)
                  *EnteredPort = @Blocks()\Ports() 
                  *EnteredBlock = @Blocks()
                  
                  ForEach Links() 
                     If Links()\Port[0] = *EnteredPort Or Links()\Port[1] = *EnteredPort
                        *EnteredLink = @Links() 
                        Break 2
                     EndIf 
                  Next
                  Break 2
               EndIf
            Next
            If IsMouseOver(mx, my, Blocks())
               *EnteredBlock = @Blocks()
            EndIf
         Next
         
         If Not *EnteredBlock And Not *SelectedBlock And Not *EnteredPort And Not *SelectedPort And Not *DragBlock
            ForEach Links() 
               If EnterPath(mx, my, @Links()) 
                  *EnteredLink = @Links() 
                  Break 
               EndIf 
            Next
         EndIf
         
         If *SelectLink
            ; Логика перемещения излома линии (MoveLink)
            ; Предположим, функция принимает координаты мыши и обновляет внутренний коэффициент Ratio
            MovePath(mx, my, *SelectLink) 
         ElseIf *DragBlock
            *DragBlock\x = Round((mx - *DragBlock\OffX) / #GRID_SIZE, #PB_Round_Nearest) * #GRID_SIZE
            *DragBlock\y = Round((my - *DragBlock\OffY) / #GRID_SIZE, #PB_Round_Nearest) * #GRID_SIZE
            
            ; 2. ОБНОВЛЯЕМ ПУТИ всех линий, связанных с этим блоком
            ForEach Links()
               If Links()\Block[0] = *DragBlock Or Links()\Block[1] = *DragBlock
                  UpdatePath(@Links())
               EndIf
            Next
            ;          ElseIf *DragLink
            ;             Global DragOffX.f = 0
            ;             Global DragOffY.f = 0
            ;             Define dx = mx - DragOffX 
            ;             Define dy = my - DragOffY
            ;             Define i = 0, count = ListSize(*DragLink\Path())
            ;             ForEach *DragLink\Path()
            ;                ; Двигаем только если это НЕ первая и НЕ последняя точка пути
            ;                If i > 1 And i < count - 2
            ;                   *DragLink\Path()\X + dx
            ;                   *DragLink\Path()\Y + dy
            ;                EndIf
            ;                i + 1
            ;             Next
            ;             DragOffX = mx : DragOffY = my
         EndIf
         
         ReDraw(0)
         
      Case #PB_EventType_LeftButtonDown
         ; Сначала проверяем порты (у них приоритет над телом блока)
         If *EnteredPort
            ForEach Links()
               If Links()\Port[0] = *EnteredPort And Links()\Block[0] = *EnteredBlock
                  *SelectedPort = Links()\Port[1] : *SelectedBlock = Links()\Block[1] : DeleteElement(Links()) : Break 
               EndIf
               If Links()\Port[1] = *EnteredPort And Links()\Block[1] = *EnteredBlock
                  *SelectedPort = Links()\Port[0] : *SelectedBlock = Links()\Block[0] : DeleteElement(Links()) : Break 
               EndIf
            Next
            If Not *SelectedPort : *SelectedPort = *EnteredPort : *SelectedBlock = *EnteredBlock : EndIf
            
         ElseIf *EnteredLink
            ForEach Links() 
               *EnteredLink\segment = EnterPath(mx, my, @Links()) 
               If *EnteredLink\segment
                  Break 
               EndIf 
            Next
            *SelectLink = *EnteredLink
         Else
            ; Ищем блок, по которому кликнули (перебираем с конца, чтобы выбрать верхний)
            LastElement(Blocks())
            Repeat
               If IsMouseOver(mx, my, Blocks())
                  *DragBlock = @Blocks()
                  ; Запоминаем, за какое место схватили блок
                  *DragBlock\OffX = mx - Blocks()\x
                  *DragBlock\OffY = my - Blocks()\y
                  
                  ; Выносим блок на передний план (Z-order)
                  MoveElement(Blocks(), #PB_List_Last)
                  Break
               EndIf
            Until PreviousElement(Blocks()) = 0
         EndIf
         ReDraw(0)
         
      Case #PB_EventType_LeftButtonUp
         If *SelectedPort And *EnteredPort And *EnteredPort <> *SelectedPort
            ; Соединяем только если порты "смотрят" друг на друга
            If Abs(*SelectedPort\Side - *EnteredPort\Side) = 2
               If *SelectedPort\Side = #SIDE_LEFT Or *SelectedPort\Side = #SIDE_RIGHT
                  AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort, 0.5 )
               Else
                  AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort, 0.5 )
               EndIf
            EndIf
         EndIf
         *SelectLink = 0 : *SelectedPort = 0 : *SelectedBlock = 0 : *DragBlock = 0 
         ReDraw(0)
         
      Case #PB_EventType_LeftDoubleClick ; CREATE
         If *EnteredBlock 
            Protected side = EnteredSide( *EnteredBlock, mx, my, 5 )
            If side
               AddPort(*EnteredBlock, side, 5 ) 
            EndIf
         Else
            AddBlock(mx, my)
         EndIf
         ReDraw(0)
         
      Case #PB_EventType_RightButtonDown ; DELETE
         If *EnteredBlock 
            ; ClearLinks( *EnteredBlock, *EnteredPort )
            
            If *EnteredPort
               RemovePort(*EnteredBlock, *EnteredPort)
               *EnteredPort = 0 
               *SelectedPort = 0
            Else
               RemoveBlock(*EnteredBlock) 
               *EnteredBlock = 0 
               *SelectedBlock = 0
            EndIf  
            
         ElseIf *EnteredLink 
            RemoveLink(*EnteredLink) 
            *EnteredLink = 0 
            *SelectLink = 0
            
         EndIf
         ReDraw(0)
         
   EndSelect
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile
   If OpenWindow(0, 0, 0, 900, 700, "Node Editor Final", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      CanvasGadget(0, 0, 0, 900, 700, #PB_Canvas_Keyboard)
      
      RandomSeed(50)
      
      *SelectedBlock = AddBlock(300, 250, "Source") 
      *EnteredBlock = AddBlock(300, 80, "Target") 
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_LEFT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_RIGHT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_RIGHT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_LEFT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedBlock = 0
      *EnteredBlock = 0
      *SelectedPort = 0
      *EnteredPort = 0
      
      ReDraw(0)
      Repeat : Define Event = WaitWindowEvent() : If Event = #PB_Event_Gadget And EventGadget() = 0 : CanvasEvents() : EndIf : Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
   If OpenWindow(0, 0, 0, 900, 700, "Node Editor Final", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      CanvasGadget(0, 0, 0, 900, 700, #PB_Canvas_Keyboard)
      
      RandomSeed(50)
      
      *SelectedBlock = AddBlock(280, 260, "Source") 
      *EnteredBlock = AddBlock(400, 260, "Target") 
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_LEFT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_RIGHT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = SelectElement(*SelectedBlock\Ports(), #SIDE_RIGHT-1)
      *EnteredPort = SelectElement(*EnteredBlock\Ports(), #SIDE_LEFT-1)
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedPort = AddPort( *SelectedBlock, #SIDE_RIGHT )
      *EnteredPort = AddPort( *EnteredBlock, #SIDE_LEFT )
      AddLink( *SelectedBlock, *SelectedPort, *EnteredBlock, *EnteredPort )
      
      *SelectedBlock = 0
      *EnteredBlock = 0
      *SelectedPort = 0
      *EnteredPort = 0
      
      ReDraw(0)
      Repeat : Define Event = WaitWindowEvent() : If Event = #PB_Event_Gadget And EventGadget() = 0 : CanvasEvents() : EndIf : Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 256
; FirstLine = 252
; Folding = ------------f-4--------------+
; EnableXP