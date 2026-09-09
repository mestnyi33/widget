EnableExplicit

; --- МАКРОСЫ ---
Macro Min(a, b) : (Bool((a) <= (b)) * (a) + Bool((b) < (a)) * (b)) : EndMacro
Macro Max(a, b) : (Bool((a) >= (b)) * (a) + Bool((b) > (a)) * (b)) : EndMacro

Enumeration
   #SIDE_NONE : #SIDE_LEFT : #SIDE_TOP : #SIDE_RIGHT : #SIDE_BOTTOM
EndEnumeration

Enumeration
   #PATH_Z : #PATH_S : #PATH_BYPASS
EndEnumeration

Structure BLOCK
   X.i : Y.i : W.i : H.i : Name.s
   SideCount.i[5]
EndStructure

Structure PORT
   X.i : Y.i : Side.i
EndStructure

Structure LINK
   List Path.Point()
   *Block.BLOCK[2]
   Port.PORT[2]
   MidRatio.f      ; центральная ось
   OffsetStart.i   ; вылет от старта
   OffsetEnd.i     ; вылет до финиша
   OffsetMin.i
   
   BypassOffset.i
   BypassSide.i
   Index.i : Count.i : Color.i : Type.i
EndStructure

Global NewList Blocks.BLOCK()
Global NewList Links.LINK()
Global *DragBlock.BLOCK = #Null
Global OffsetX, OffsetY

Procedure AddPath(*L.LINK, X, Y)
   If ListSize(*L\Path()) = 0
      AddElement(*L\Path()) : *L\Path()\X = X : *L\Path()\Y = Y
      ProcedureReturn
   EndIf
   LastElement(*L\Path())
   If *L\Path()\X = X And *L\Path()\Y = Y : ProcedureReturn : EndIf
   If ListSize(*L\Path()) >= 2
      Protected *p2.Point = *L\Path()
      PushListPosition(*L\Path()) : PreviousElement(*L\Path())
      Protected *p1.Point = *L\Path() : PopListPosition(*L\Path())
      If (*p1\X = *p2\X And *p2\X = X) Or (*p1\Y = *p2\Y And *p2\Y = Y)
         *p2\X = X : *p2\Y = Y : ProcedureReturn
      EndIf
   EndIf
   AddElement(*L\Path()) : *L\Path()\X = X : *L\Path()\Y = Y
EndProcedure

Procedure UpdatePath(*L.LINK)
   ClearList(*L\Path())
   
   Protected baseMargin = 20, lineSpacing = 10
;    Protected sidecount = *L\Block[0]\sideCount[#SIDE_RIGHT]
;    Protected order = *L\Index
   Protected sidecount = *L\Count
   Protected order = *L\Index
   Protected invertedOrder = (sidecount - 1) - order
   Protected totalWidth = (sidecount - 1) * lineSpacing
   
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.i = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   Debug ""+sidecount+" "+order;+" "+sideIdx
   
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
   
   Protected baseMargin = 20, lineSpacing = 10
   Protected sidecount = *L\Count
   Protected order = *L\Index
   Protected invertedOrder = (sidecount - 1) - order
   Protected totalWidth = (sidecount - 1) * lineSpacing
   
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.i = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   
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

Procedure UpdatePath2(*L.LINK)
   ClearList(*L\Path())
   Protected baseMargin = 20, lineSpacing = 10
   
   ; --- ПРАВКА 1: Перенос объявлений вверх ---
   Protected sidecount = *L\Count
   Protected order = *L\Index
   Protected invertedOrder = (sidecount - 1) - order
   Protected totalWidth = (sidecount - 1) * lineSpacing
   
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.i = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   Protected Margin, bypassX, bypassY
   
   
   ; Определяем тип пути
   If Not isVertical
      Protected corridorY = 0
      ; --- ПРАВКА 2: Корректный расчет зазора между блоками ---
      If y2 > y1 : corridorY = *L\Block[1]\Y - (*L\Block[0]\Y + *L\Block[0]\H)
         Else       : corridorY = *L\Block[0]\Y - (*L\Block[1]\Y + *L\Block[1]\H) : EndIf
      
      ; Если x2 далеко впереди -> Z, если есть зазор по вертикали -> S, иначе Bypass
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
         ; 1. Рассчитываем чистое смещение внутри пучка (от центра к краям)
         ; Это позволит пучку линий всегда центрироваться по (x1+x2)/2
         Protected bundleOffset
         If (x2 > x1 And isVertical) Or 
            (y2 > y1 And Not isVertical) 
            bundleOffset = (invertedOrder * lineSpacing) - (totalWidth / 2)
         Else
            bundleOffset = (Order * lineSpacing) - (totalWidth / 2)
         EndIf
         
         If Not isVertical
            Protected dynamicMidX = (x1 + x2) / 2 + bundleOffset
            AddPath(*L, dynamicMidX, y1)
            AddPath(*L, dynamicMidX, y2)
         Else
            Protected dynamicMidY = (y1 + y2) / 2 + bundleOffset
            AddPath(*L, x1, dynamicMidY)
            AddPath(*L, x2, dynamicMidY)
         EndIf
         
      Case #PATH_S
         Protected sMidY, sMidX, sOffA, sOffB, activeOrder, targetOrder
         
         ; 1. Определяем "ведущий" индекс для этого направления
         If (isVertical And x2 > x1) Or (Not isVertical And y2 > y1) 
            activeOrder = invertedOrder
            targetOrder = Order
            sMidX = (*L\Block[0]\X + *L\Block[0]\W + *L\Block[1]\X) / 2
            sMidY = (*L\Block[0]\Y + *L\Block[0]\H + *L\Block[1]\Y) / 2
         Else
            activeOrder = Order
            targetOrder = invertedOrder
            sMidX = (*L\Block[1]\X + *L\Block[1]\W + *L\Block[0]\X) / 2 
            sMidY = (*L\Block[1]\Y + *L\Block[1]\H + *L\Block[0]\Y) / 2 
         EndIf
         
         ; 2. Рассчитываем отступы вылета для обоих плеч
         sOffA = baseMargin + (activeOrder * lineSpacing)
         sOffB = baseMargin + (targetOrder * lineSpacing) 
         
         If Not isVertical
            ; Смещение центральной полки в пучке (всегда относительно инверсии для красоты потока)
            sMidY + (invertedOrder * lineSpacing) - (totalWidth / 2)
            
            AddPath(*L, x1 + sOffA, y1)
            AddPath(*L, x1 + sOffA, sMidY)
            AddPath(*L, x2 - sOffB, sMidY)
            AddPath(*L, x2 - sOffB, y2)
         Else
            sMidX + (invertedOrder * lineSpacing) - (totalWidth / 2)
            
            AddPath(*L, x1, y1 + sOffA)
            AddPath(*L, sMidX, y1 + sOffA)
            AddPath(*L, sMidX, y2 - sOffB)
            AddPath(*L, x2, y2 - sOffB)
         EndIf
         
         
         ;      Case #PATH_S
         ;         Protected sMidY, sMidX, sOffA, sOffB
         ;         
         ;         If (x2 > x1 And isVertical) Or 
         ;            (y2 > y1 And Not isVertical) 
         ;            Margin = (invertedOrder * lineSpacing)
         ;            sMidX = (*L\Block[0]\X + *L\Block[0]\W + *L\Block[1]\X) / 2
         ;            sMidY = (*L\Block[0]\Y + *L\Block[0]\H + *L\Block[1]\Y) / 2
         ;            sOffA = baseMargin + (invertedorder * lineSpacing)
         ;            sOffB = baseMargin + (Order * lineSpacing) 
         ;         Else
         ;            Margin = (Order * lineSpacing)
         ;            sMidX = (*L\Block[1]\X + *L\Block[1]\W + *L\Block[0]\X) / 2 
         ;            sMidY = (*L\Block[1]\Y + *L\Block[1]\H + *L\Block[0]\Y) / 2 
         ;            sOffA = baseMargin + (order * lineSpacing)
         ;            sOffB = baseMargin + (invertedOrder * lineSpacing) 
         ;         EndIf
         ;         
         ;         If Not isVertical
         ;            sMidY + (invertedorder * lineSpacing) - (totalWidth / 2)
         ;            
         ;            AddPath(*L, x1 + sOffA, y1)
         ;            AddPath(*L, x1 + sOffA, sMidY)
         ;            AddPath(*L, x2 - sOffB, sMidY)
         ;            AddPath(*L, x2 - sOffB, y2)
         ;         Else
         ;            sMidX + (invertedorder * lineSpacing) - (totalWidth / 2)
         ;            
         ;            AddPath(*L, x1, y1 + sOffA)
         ;            AddPath(*L, sMidX, y1 + sOffA)
         ;            AddPath(*L, sMidX, y2 - sOffB)
         ;            AddPath(*L, x2, y2 - sOffB)
         ;         EndIf
         
      Case #PATH_BYPASS
         If (x2 > x1 And isVertical) Or 
            (y2 > y1 And Not isVertical) 
            Margin = baseMargin + (invertedOrder * lineSpacing)
            bypassX = Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + Margin
            bypassY = Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + Margin
         Else
            Margin = baseMargin + (Order * lineSpacing)
            bypassX = Min(*L\Block[0]\X, *L\Block[1]\X) - Margin
            bypassY = Min(*L\Block[0]\Y, *L\Block[1]\Y) - Margin 
         EndIf
         
         If Not isVertical
            AddPath(*L, x1 + Margin, y1)
            AddPath(*L, x1 + Margin, bypassY)
            AddPath(*L, x2 - Margin, bypassY)
            AddPath(*L, x2 - Margin, y2)
         Else
            AddPath(*L, x1, y1 + Margin)
            AddPath(*L, bypassX, y1 + Margin)
            AddPath(*L, bypassX, y2 - Margin)
            AddPath(*L, x2, y2 - Margin)
         EndIf
         
   EndSelect
   
   AddPath(*L, x2, y2)
EndProcedure
Procedure UpdatePath1(*L.LINK)
   ClearList(*L\Path())
   Protected baseMargin = 20, lineSpacing = 10
   Protected sidecount = *L\Count, totalWidth = (sidecount - 1) * lineSpacing
   
   Protected x1 = *L\Block[0]\X + *L\Port[0]\X, y1 = *L\Block[0]\Y + *L\Port[0]\Y
   Protected x2 = *L\Block[1]\X + *L\Port[1]\X, y2 = *L\Block[1]\Y + *L\Port[1]\Y
   
   Protected isVertical.b = Bool(*L\Port[0]\Side = #SIDE_TOP Or *L\Port[0]\Side = #SIDE_BOTTOM)
   Protected order = *L\Index
   Protected invertedOrder = (sidecount - 1) - order
   
   ; Определяем тип пути
   If Not isVertical
      Protected corridorY = 0
      If y2 > y1 : corridorY = *L\Block[1]\Y - (*L\Block[0]\Y + *L\Block[0]\H)
         Else       : corridorY = *L\Block[0]\Y - (*L\Block[1]\Y + *L\Block[1]\H) : EndIf
      
      If x2 > (x1 + (baseMargin * 2) + totalWidth) : *L\Type = #PATH_Z
      ElseIf corridorY > baseMargin : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
   Else
      Protected corridorX = 0
      If x2 > x1 : corridorX = *L\Block[1]\X - (*L\Block[0]\X + *L\Block[0]\W)
         Else       : corridorX = *L\Block[0]\X - (*L\Block[1]\X + *L\Block[1]\W) : EndIf
      
      If y2 > (y1 + (baseMargin * 2) + totalWidth) : *L\Type = #PATH_Z
      ElseIf corridorX > baseMargin : *L\Type = #PATH_S
         Else : *L\Type = #PATH_BYPASS : EndIf
   EndIf
   
   AddPath(*L, x1, y1)
   
   Select *L\Type
      Case #PATH_Z
         
         If Not isVertical
            Protected midX = (x1 + x2) / 2
            Protected dynamicMidX = midX + ((sidecount - 1 - order) * lineSpacing) - (totalWidth / 2)
            AddPath(*L, dynamicMidX, y1) : AddPath(*L, dynamicMidX, y2)
         Else
            Protected midY = (y1 + y2) / 2
            Protected dynamicMidY = midY + ((sidecount - 1 - order) * lineSpacing) - (totalWidth / 2)
            AddPath(*L, x1, dynamicMidY) : AddPath(*L, x2, dynamicMidY)
         EndIf
         
      Case #PATH_S
         ; Секрет параллельности: для S-кривой порядок инвертируется на втором плече
         If Not isVertical
            Protected sMidY, sOffA = baseMargin + (order * lineSpacing)
            Protected sOffB = baseMargin + (invertedOrder * lineSpacing) 
            
            If y2 > y1 : sMidY = (*L\Block[0]\Y + *L\Block[0]\H + *L\Block[1]\Y) / 2
               Else       : sMidY = (*L\Block[1]\Y + *L\Block[1]\H + *L\Block[0]\Y) / 2 : EndIf
            
            sMidY + (order * lineSpacing) - (totalWidth / 2)
            
            AddPath(*L, x1 + sOffA, y1)
            AddPath(*L, x1 + sOffA, sMidY)
            AddPath(*L, x2 - sOffB, sMidY)
            AddPath(*L, x2 - sOffB, y2)
         Else
            Protected sMidX, svOffA = baseMargin + (order * lineSpacing)
            Protected svOffB = baseMargin + (invertedOrder * lineSpacing) 
            If x2 > x1 : sMidX = (*L\Block[0]\X + *L\Block[0]\W + *L\Block[1]\X) / 2
               Else       : sMidX = (*L\Block[1]\X + *L\Block[1]\W + *L\Block[0]\X) / 2 : EndIf
            sMidX + (order * lineSpacing) - (totalWidth / 2)
            
            AddPath(*L, x1, y1 + svOffA)
            AddPath(*L, sMidX, y1 + svOffA)
            AddPath(*L, sMidX, y2 - svOffB)
            AddPath(*L, x2, y2 - svOffB)
         EndIf
         
      Case #PATH_BYPASS
         ; Для обхода (Bypass) линии должны "наслаиваться" снаружи
         Protected bMargin = baseMargin + (invertedOrder * lineSpacing)
         If Not isVertical
            Protected bypassY
            If y2 > y1 : bypassY = Max(*L\Block[0]\Y + *L\Block[0]\H, *L\Block[1]\Y + *L\Block[1]\H) + bMargin
               Else       : bypassY = Min(*L\Block[0]\Y, *L\Block[1]\Y) - bMargin : EndIf
            AddPath(*L, x1 + bMargin, y1)
            AddPath(*L, x1 + bMargin, bypassY)
            AddPath(*L, x2 - bMargin, bypassY)
            AddPath(*L, x2 - bMargin, y2)
         Else
            Protected bypassX
            If x2 > x1 : bypassX = Max(*L\Block[0]\X + *L\Block[0]\W, *L\Block[1]\X + *L\Block[1]\W) + bMargin
               Else       : bypassX = Min(*L\Block[0]\X, *L\Block[1]\X) - bMargin : EndIf
            AddPath(*L, x1, y1 + bMargin)
            AddPath(*L, bypassX, y1 + bMargin)
            AddPath(*L, bypassX, y2 - bMargin)
            AddPath(*L, x2, y2 - bMargin)
         EndIf
   EndSelect
   
   AddPath(*L, x2, y2)
EndProcedure

Procedure Draw()
   If StartDrawing(CanvasOutput(0))
      Box(0, 0, 800, 800, $FFFFFF)
      ForEach Links() : UpdatePath(Links()) : Protected lx, ly, first = 1
         ForEach Links()\Path()
            If Not first : LineXY(lx, ly, Links()\Path()\X, Links()\Path()\Y, Links()\Color) : EndIf
            lx = Links()\Path()\X : ly = Links()\Path()\Y : first = 0
         Next
      Next
      ForEach Blocks()
         DrawingMode(#PB_2DDrawing_Default) : Box(Blocks()\X, Blocks()\Y, Blocks()\W, Blocks()\H, $F2F2F2)
         DrawingMode(#PB_2DDrawing_Outlined) : Box(Blocks()\X, Blocks()\Y, Blocks()\W, Blocks()\H, $404040)
         DrawText(Blocks()\X + (Blocks()\W - TextWidth(Blocks()\Name))/2, Blocks()\Y + (Blocks()\H - TextHeight(Blocks()\Name))/2, Blocks()\Name, $000000, $F2F2F2)
      Next
      StopDrawing()
   EndIf
EndProcedure

; --- ИНИЦИАЛИЗАЦИЯ (КАК НА КАРТИНКЕ) ---
AddElement(Blocks()) : Blocks()\X = 200 : Blocks()\Y = 450 : Blocks()\W = 180 : Blocks()\H = 220 : Blocks()\Name = "Блок А" : Define *BA = @Blocks()
AddElement(Blocks()) : Blocks()\X = 300 : Blocks()\Y = 80  : Blocks()\W = 180 : Blocks()\H = 220 : Blocks()\Name = "Блок Б" : Define *BB = @Blocks()

Define i, Dim Clr(3) : Clr(0)=$FF0000 : Clr(1)=$00AA00 : Clr(2)=$0000FF : Clr(3)=$00AAAA
For i = 0 To 3
   ; Горизонтальное S-соединение (Бок А -> Бок Б)
   AddElement(Links()) : Links()\Block[0]=*BA : Links()\Block[1]=*BB : Links()\Index=i : Links()\Count=4 : Links()\Color=Clr(i) : Links()\MidRatio = 0.5
   Links()\Port[0]\X=180 : Links()\Port[0]\Y=40+i*30 : Links()\Port[0]\Side=#SIDE_RIGHT
   Links()\Port[1]\X=0   : Links()\Port[1]\Y=40+i*30 : Links()\Port[1]\Side=#SIDE_LEFT
     ; Вертикальное Bypass-соединение (Низ А -> Верх Б)
     AddElement(Links()) : Links()\Block[0]=*BA : Links()\Block[1]=*BB : Links()\Index=i : Links()\Count=4 : Links()\Color=Clr(i)
     Links()\Port[0]\X=40+i*30 : Links()\Port[0]\Y=220 : Links()\Port[0]\Side=#SIDE_BOTTOM
     Links()\Port[1]\X=40+i*30 : Links()\Port[1]\Y=0   : Links()\Port[1]\Side=#SIDE_TOP
Next
; For i = 0 To 3
;      ; Вертикальное Bypass-соединение (Низ А -> Верх Б)
;      AddElement(Links()) : Links()\Block[0]=*BA : Links()\Block[1]=*BB : Links()\Index=i : Links()\Count=4 : Links()\Color=Clr(i)
;      Links()\Port[0]\X=40+i*30 : Links()\Port[0]\Y=220 : Links()\Port[0]\Side=#SIDE_BOTTOM
;      Links()\Port[1]\X=40+i*30 : Links()\Port[1]\Y=0   : Links()\Port[1]\Side=#SIDE_TOP
; Next

If OpenWindow(0, 0, 0, 800, 800, "Ribbon Routing Fix", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 800, 800)
   Draw()
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow : Break
         Case #PB_Event_Gadget
            If EventGadget() = 0
               Define mx = GetGadgetAttribute(0, #PB_Canvas_MouseX), my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
               Select EventType()
                  Case #PB_EventType_LeftButtonDown
                     ForEach Blocks() : If mx >= Blocks()\X And mx <= Blocks()\X+Blocks()\W And my >= Blocks()\Y And my <= Blocks()\Y+Blocks()\H
                     *DragBlock = @Blocks() : OffsetX = mx - Blocks()\X : OffsetY = my - Blocks()\Y : Break : EndIf : Next
                     Case #PB_EventType_MouseMove : If *DragBlock : *DragBlock\X = mx - OffsetX : *DragBlock\Y = my - OffsetY : Draw() : EndIf
                  Case #PB_EventType_LeftButtonUp : *DragBlock = #Null
               EndSelect
            EndIf
      EndSelect
   ForEver
EndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 603
; FirstLine = 566
; Folding = -------------
; EnableXP
; DPIAware