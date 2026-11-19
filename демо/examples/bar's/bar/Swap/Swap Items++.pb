EnableExplicit

; ============================================================================
; 1. КОНСТАНТЫ И СТРУКТУРЫ
; ============================================================================
Enumeration
   #Win
   #Canvas
   #TestImg
EndEnumeration

#__MASK_Left            = 1 << 0
#__MASK_Center          = 1 << 1
#__MASK_Right           = 1 << 2
#__MASK_Bottom          = 1 << 3
#__MASK_Hover           = 1 << 4
#__MASK_UpdateTotalSize = 1 << 5
#__MASK_Redraw          = 1 << 6

Global BottomSpacing.i = 4

Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure

Structure _s_TXT Extends _s_COORDINATE
   Text.s
   change.b
EndStructure

Structure _s_IMG Extends _s_COORDINATE
   Image.i
   change.b
EndStructure

Structure _s_BOX Extends _s_COORDINATE
   size.l
   round.a
   checked.b
   mask.q
EndStructure

Structure _s_TAB Extends _s_BOX
   ID.i
   pos.l
   offset.l
   minOffset.l
   maxOffset.l
   txt._s_TXT
   img._s_IMG
   StructureUnion
      *data
      ContainerID.i
   EndStructureUnion
EndStructure

Structure _s_TABS
   *active._s_TAB
   *press._s_TAB
   *hover._s_TAB    ; Перенесено из Static для безопасности при ClearTabs()
   plus._s_TAB
   slant.a
   align.a
   indent.a
   spacing.a
   vertical.b
   TotalSize.l
   List _s._s_TAB()
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   mask.q
   change.b
   Tab._s_TABS
   dragOffSet.i
   canvasid.i
   fontid.i
   bgcolor.l
EndStructure

; ============================================================================
; 2. ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ЗАГЛУШКА CHROMEBOX
; ============================================================================
Procedure.i MakeColor(color.l, delta.i)
   Protected r.i = Red(color) + delta
   Protected g.i = Green(color) + delta
   Protected b.i = Blue(color) + delta
   If r < 0 : r = 0 : ElseIf r > 255 : r = 255 : EndIf
   If g < 0 : g = 0 : ElseIf g > 255 : g = 255 : EndIf
   If b < 0 : b = 0 : ElseIf b > 255 : b = 255 : EndIf
   ProcedureReturn RGBA(r, g, b, Alpha(color))
EndProcedure

Procedure.l _MakeColor(bgColor.l, value.l = 0)
   ; Извлекаем каналы с помощью побитового "И" (&) и сдвигов (>>)
   Protected.l r = (bgColor & $FF) +  value 
   Protected.l g = ((bgColor >> 8) & $FF) + value
   Protected.l b = ((bgColor >> 16) & $FF) + value
   Protected.l a = (bgColor >> 24) & $FF ; Альфа-канал просто двигаем
   
   ; Быстрое ограничение (Clamp) от 0 до 255
   If r > 255 : r = 255 : ElseIf r < 0 : r = 0 : EndIf
   If g > 255 : g = 255 : ElseIf g < 0 : g = 0 : EndIf
   If b > 255 : b = 255 : ElseIf b < 0 : b = 0 : EndIf
   
   ; Собираем цвет обратно в один Long
   ProcedureReturn r | (g << 8) | (b << 16) | (a << 24)
EndProcedure

; Заглушка для отрисовки трапеций (замени на свою оригинальную ChromeBox)
Procedure ChromeBox(vertical.b, X, Y, w, h, isactive, currentcolor.l, localslant.a, GradientDepth = 65, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
   Protected dy, dh = h - 1, dw = w - 1
   If h <= 0 Or w <= 0 : ProcedureReturn : EndIf 
   
   ; Корректируем скос в зависимости от режима
   If vertical
      If localslant > w : localslant = w : EndIf
   Else
      If localslant > h : localslant = h : EndIf
   EndIf
   
   ; 1. Выбор базового цвета
   Protected.a currentalpha = Alpha(currentcolor)
   
   ; 2. Расчет цветов рамок
   If outerbordercolor = -1
      outerbordercolor = RGBA(Red(currentcolor) * 0.6, Green(currentcolor) * 0.6, Blue(currentcolor) * 0.6, currentalpha)
   EndIf
   If innerhighlightcolor = -1
      Protected.a r = Red(currentcolor), g = Green(currentcolor), b = Blue(currentcolor)
      innerhighlightcolor = RGBA(r + (255 - r) * 0.3, g + (255 - g) * 0.3, b + (255 - b) * 0.3, currentalpha)
   EndIf
   
   ; 3. Заливка тела вкладки
   If isactive : GradientDepth = 0 : EndIf
   Protected baser = Red(currentcolor), baseg = Green(currentcolor), bgb = Blue(currentcolor)
   
   ; Защита цвета от Underflow
   Protected MaxDrop = baser
   If baseg < MaxDrop : MaxDrop = baseg : EndIf
   If bgb < MaxDrop : MaxDrop = bgb : EndIf
   If GradientDepth > MaxDrop : GradientDepth = MaxDrop : EndIf 
   
   ; Настройка шагов для циклов fixed-point (в зависимости от ориентации)
   Protected Steps = dh
   If vertical : Steps = dw : EndIf
   
   Protected ColorStepFixed = (GradientDepth << 16) / Steps
   Protected SlantStepFixed = (localslant << 16) / Steps
   
   Protected ColorAccum = 0
   Protected SlantAccum = localslant << 16
   
   Protected stepVar
   For stepVar = 0 To Steps
      Protected currentSlantVal = (SlantAccum + $8000) >> 16
      
      ; Вычисляем динамический размер линии (для горизонтальной — это длина, для вертикальной — высота)
      Protected currentLength = w - (currentSlantVal << 1)
      If vertical : currentLength = h - (currentSlantVal << 1) : EndIf
      
      If currentLength <= 0 : Break : EndIf 
      
      Protected currentColorStep = ColorAccum >> 16
      Protected color = RGBA(baser - currentColorStep, baseg - currentColorStep, bgb - currentColorStep, currentalpha)
      
      ; Отрисовка линии в зависимости от направления
      If vertical
         ; Рисуем вертикальные полоски слева направо
         Line(X + stepVar, Y + currentSlantVal, 1, currentLength, color)
      Else
         ; Рисуем горизонтальные полоски сверху вниз
         Line(X + currentSlantVal, Y + stepVar, currentLength, 1, color)
      EndIf
      
      ColorAccum + ColorStepFixed
      SlantAccum - SlantStepFixed
   Next
   
   ; 4. Отрисовка контуров
   If vertical
      ; === ВЕРТИКАЛЬНЫЙ РЕЖИМ (Вкладка «смотрит» вверх, основание справа) ===
      LineXY(X + dw, Y, X, Y + localslant, outerbordercolor)             
      LineXY(X, Y + localslant, X, Y + h - 1 - localslant, outerbordercolor)         
      LineXY(X, Y + h - 1 - localslant, X + dw, Y + h - 1, outerbordercolor)     
      
      If isactive
         LineXY(X + dw, Y + 1, X + 1, Y + localslant + 1, innerhighlightcolor)
         LineXY(X + 1, Y + localslant + 1, X + 1, Y + h - 1 - localslant - 1, innerhighlightcolor)
         LineXY(X + 1, Y + h - 1 - localslant - 1, X + dw, Y + h - 2, innerhighlightcolor)
      Else
         ; Замыкающая линия справа (стык с панелью)
         LineXY(X + dw, Y, X + dw, Y + h - 1, outerbordercolor)
      EndIf
   Else
      ; === ГОРИЗОНТАЛЬНЫЙ РЕЖИМ (Классический Chrome) ===
      LineXY(X, Y + dh, X + localslant, Y, outerbordercolor)             
      LineXY(X + localslant, Y, X + w - 1 - localslant, Y, outerbordercolor)         
      LineXY(X + w - 1 - localslant, Y, X + w - 1, Y + dh, outerbordercolor)     
      
      If isactive
         LineXY(X + 1, Y + dh, X + localslant + 1, Y + 1, innerhighlightcolor)
         LineXY(X + localslant + 1, Y + 1, X + w - 1 - localslant - 1, Y + 1, innerhighlightcolor)
         LineXY(X + w - 1 - localslant - 1, Y + 1, X + w - 2, Y + dh, innerhighlightcolor)
      Else
         ; Замыкающая линия снизу
         LineXY(X, Y + dh, X + w - 1, Y + dh, outerbordercolor)
      EndIf
   EndIf
EndProcedure

Procedure.i MakeAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__MASK_Center
      ProcedureReturn (contentSize - objectSize) >> 1
   ElseIf alignFlags & (#__MASK_Right | #__MASK_Bottom)
      ProcedureReturn contentSize - objectSize - Offset
   Else
      ProcedureReturn Offset
   EndIf
EndProcedure

;-
Procedure UpdateContentSize(*tab._s_TAB, forceUpdate.b = #False)
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   
   If *txt\change Or forceUpdate
      *txt\change = #False
      If *txt\Text <> ""
         *txt\width  = TextWidth(*txt\Text)
         *txt\height = TextHeight(*txt\Text)
      Else
         *txt\width = 0 : *txt\height = 0
      EndIf
   EndIf
   
   If *img\change Or forceUpdate
      *img\change = #False
      If IsImage(*img\Image)
         *img\width  = ImageWidth(*img\Image)
         *img\height = ImageHeight(*img\Image)
      Else
         *img\width = 0 : *img\height = 0
      EndIf
   EndIf
EndProcedure

Procedure UpdateContentPos(*tab._s_TAB, indent.a, Spacing.a, vertical.b)
   Protected contentPos.l
   Protected._s_TXT *txt = *tab\txt
   Protected._s_IMG *img = *tab\img
   
   If vertical
      If Not (*img\height And *txt\height) : Spacing = 0 : EndIf
      *txt\x = (*tab\width - *txt\width) >> 1
      *img\x = (*tab\width - *img\width) >> 1
      
      contentPos = MakeAlignPosition(*tab\mask, *tab\Height, *img\height + *txt\height + Spacing, indent)
      *txt\y = contentPos
      *img\y = contentPos
      
      If Not (*tab\mask & #__MASK_Bottom)
         If *img\height > 0 : *txt\y + *img\height + Spacing : EndIf
      Else
         If *txt\height > 0 : *img\y + *txt\height + Spacing : EndIf
      EndIf
   Else
      If Not (*img\width And *txt\width) : Spacing = 0 : EndIf
      *txt\y = (*tab\height - *txt\height) >> 1
      *img\y = (*tab\height - *img\height) >> 1
      
      contentPos = MakeAlignPosition(*tab\mask, *tab\Width, *img\width + *txt\width + Spacing, indent)
      *txt\x = contentPos
      *img\x = contentPos
      
      If Not (*tab\mask & #__MASK_Right)
         If *img\width > 0 : *txt\x + *img\width + Spacing : EndIf
      Else
         If *txt\width > 0 : *img\x + *txt\width + Spacing : EndIf
      EndIf
   EndIf
EndProcedure

Procedure UpdateTabsLayout(*this._s_WIDGET)
   Protected position.i, widgetChanged.b, recalcLayout.b
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   Protected indent.a = *this\tab\slant
   Protected Spacing.i, Tab_size.i
   Protected defaultSpacing.i = DesktopScaledX(6)
   
   If StartDrawing(CanvasOutput(*this\canvasid))
      If *this\fontid : DrawingFont(*this\fontid) : EndIf
      
      If *this\change
         widgetChanged = #True
         *this\change = 0
      EndIf
      
;       If *this\mask & #__MASK_UpdateTotalSize
;          *this\mask &~ #__MASK_UpdateTotalSize
         recalcLayout = #True
;       EndIf
      
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         
         If *tab\txt\change Or *tab\img\change Or widgetChanged
            UpdateContentSize(*tab, widgetChanged)
            recalcLayout = #True
         EndIf
         
         If recalcLayout
            *tab\pos = position
            Spacing = 0
            If (*tab\img\width And *tab\txt\width) Or (*tab\img\height And *tab\txt\height)
               Spacing = defaultSpacing
            EndIf
            
            Tab_size = Spacing + indent * 2
            If vertical
               Tab_size + *tab\img\height + *tab\txt\height
            Else
               Tab_size + *tab\img\width + *tab\txt\width
            EndIf
            
            If *tab\size < Tab_size : *tab\size = Tab_size : EndIf
            
            If vertical
               *tab\x = *this\x
               *tab\y = *this\y + *this\tab\indent + position
               *tab\width = *this\Width - BottomSpacing
               *tab\height = *tab\size
            Else
               *tab\y = *this\y
               *tab\x = *this\x + *this\tab\indent + position
               *tab\width = *tab\size
               *tab\height = *this\Height - BottomSpacing
            EndIf
            
            UpdateContentPos(*tab, indent, Spacing, vertical)
         EndIf
         
         position + (*tab\size - indent) + *this\tab\spacing
      Next
      
      If recalcLayout
         If ListSize(*this\tab\_s()) > 0
            *this\tab\TotalSize = position + indent - *this\tab\spacing
         Else
            *this\tab\TotalSize = 0
         EndIf
         
         If vertical
            *this\Height = *this\tab\TotalSize + *this\tab\indent * 2
         Else
            *this\Width = *this\tab\TotalSize + *this\tab\indent * 2
         EndIf
      EndIf
      
      StopDrawing() ; Обязательно закрываем ДО изменения размера!
   EndIf
   
EndProcedure

;-
Procedure DrawTab(*tab._s_TAB, slant.a, bgColor.l = $FF808080, vertical.b = 0, isActive.b = 0)
   Protected txColor.l
   Protected w.l = *tab\width
   Protected h.l = *tab\height
   
   If isActive Or (*tab\mask & #__MASK_Hover)
      txColor = $FF000000
      If vertical : w + BottomSpacing : Else : h + BottomSpacing : EndIf
      ChromeBox(vertical, *tab\x, *tab\y, w, h, 1, bgColor, slant)
   Else
      txColor = $FFFFFFFF
      ChromeBox(vertical, *tab\x, *tab\y, w, h, 0, bgColor, slant)
   EndIf
   
   If IsImage(*tab\img\Image) And (*tab\img\Width Or *tab\img\Height)
      DrawAlphaImage(ImageID(*tab\img\Image), *tab\x + *tab\img\x, *tab\y + *tab\img\y)
   EndIf
   
   If *tab\txt\Text <> "" And (*tab\txt\Width Or *tab\txt\Height)
      DrawText(*tab\x + *tab\txt\x, *tab\y + *tab\txt\y, *tab\txt\Text, txColor, bgColor)
   EndIf
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB)
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   Protected bgColor.l = *this\bgcolor
   Protected floorcolor.l = $FF000000
   Protected lineX.i, lineY.i
   
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *current_tab
         DrawTab(*tab, *this\tab\slant, bgColor, vertical, 0)
      EndIf
   Next
   
   If *current_tab
      DrawTab(*current_tab, *this\tab\slant, *current_tab\data, vertical, 1)
      If vertical
         lineX = *current_tab\x + *current_tab\Width + BottomSpacing - 1
         lineY = *current_tab\y + *current_tab\Height
         Line(lineX, *this\y, 1, *current_tab\y - *this\y, floorcolor)
         Line(lineX, lineY, 1, (*this\y + *this\Height) - lineY, floorcolor)
      Else
         lineX = *current_tab\x + *current_tab\Width
         lineY = *current_tab\y + *current_tab\Height + BottomSpacing - 1
         Line(*this\x, lineY, *current_tab\x - *this\x, 1, floorcolor)
         Line(lineX, lineY, (*this\x + *this\Width) - lineX, 1, floorcolor)
      EndIf
   EndIf
EndProcedure

Procedure ReDraw(*this._s_WIDGET)
   If StartDrawing(CanvasOutput(*this\canvasid))
      If *this\fontid : DrawingFont(*this\fontid) : EndIf
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFFFF)
      Box(*this\x, *this\y, *this\Width, *this\Height, *this\bgcolor)
      DrawTabs(*this, *this\tab\active)
      StopDrawing()
   EndIf
EndProcedure

;-
Procedure.b DoEventTAB(*this._s_WIDGET, *hoverTAB._s_TAB, event.i, mousePos.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected stepSize.i, denom.i
   Protected slant.i = *this\tab\slant
   Protected accumulatedSize.i = 0
   Protected isBeforeDragged.b = #True
   mousePos - *this\tab\indent
   Select event
      Case #PB_EventType_MouseMove
         *current_tab = *this\tab\press
         If *current_tab
            stepSize = (*current_tab\size - slant) + *this\tab\spacing
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If *tab = *current_tab
                  *tab\offset = mousePos - *this\dragOffSet
               Else
                  *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
                  *tab\offset - stepSize
                  denom = (*tab\size - slant) + *this\tab\spacing
                  If denom > 0
                     *tab\offset = (*tab\offset * stepSize) / denom
                  EndIf
               EndIf
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
               If *this\tab\vertical
                  *tab\y = *this\y + *this\tab\indent + *tab\pos + *tab\offset
               Else
                  *tab\x = *this\x + *this\tab\indent + *tab\pos + *tab\offset
               EndIf
            Next
            ;*this\mask | #__MASK_Redraw
            ProcedureReturn #True
         EndIf
      Case #PB_EventType_LeftButtonDown
         *this\dragOffSet = mousePos
         ; Если вкладка еще не определена ховером, ищем её
         If Not *hoverTAB
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If mousePos >= *tab\pos And mousePos < *tab\pos + *tab\size
                  *hoverTAB = *tab
                  Break
               EndIf
            Next
         EndIf
         *this\tab\active = *hoverTAB
         *this\tab\press  = *hoverTAB
         If *hoverTAB
            stepSize = (*hoverTAB\size - slant) + *this\tab\spacing
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               If *tab = *hoverTAB
                  isBeforeDragged = #False
                  *tab\offset = mousePos - *this\dragOffSet
                  Continue
               EndIf
               If isBeforeDragged
                  *tab\pos + stepSize
               EndIf
               *tab\minOffset = accumulatedSize - *tab\pos
               *tab\maxOffset = accumulatedSize - *tab\pos + stepSize
               accumulatedSize + (*tab\size - slant) + *this\tab\spacing
               *tab\offset = *tab\pos - *hoverTAB\pos - *hoverTAB\offset
               *tab\offset - stepSize
               denom = (*tab\size - slant) + *this\tab\spacing
               If denom > 0
                  *tab\offset = (*tab\offset * stepSize) / denom
               EndIf
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            *hoverTAB\minOffset = -*hoverTAB\pos
            *hoverTAB\maxOffset = -*hoverTAB\pos + accumulatedSize
            If *hoverTAB\offset < *hoverTAB\minOffset : *hoverTAB\offset = *hoverTAB\minOffset : EndIf
            If *hoverTAB\offset > *hoverTAB\maxOffset : *hoverTAB\offset = *hoverTAB\maxOffset : EndIf
            ;*this\mask | #__MASK_Redraw
            ProcedureReturn #True
         EndIf
      Case #PB_EventType_LeftButtonUp
         *current_tab = *this\tab\press
         If *current_tab
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               *tab\pos + *tab\offset
               *tab\offset = 0
            Next
            SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_TAB\pos), TypeOf(_s_TAB\pos))
            *this\tab\press = #Null
            *this\mask | #__MASK_UpdateTotalSize
            UpdateTabsLayout(*this)
            ProcedureReturn #True
         EndIf
   EndSelect
   ProcedureReturn #False
EndProcedure

Procedure.b DoEvent(*this._s_WIDGET, event.i, mx.i, my.i)
   Protected *tab._s_TAB
   Protected localslant.i = *this\Tab\slant
   Protected vertical.b = *this\tab\vertical
   Protected atPoint.b, dPos.i, currentSlant.i
   ;
   Select event
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            atPoint = #False
            ;
            If my >= *tab\Y And my < *tab\Y + *tab\Height And mx >= *tab\X And mx < *tab\X + *tab\Width
               If localslant > 0
                  If vertical
                     dPos = mx - *tab\X
                     If *tab\Width > 0
                        currentSlant = ((*tab\Width - 1 - dPos) * localslant) / *tab\Width
                     EndIf
                     If my >= (*tab\Y + currentSlant) And my < (*tab\Y + *tab\Height - currentSlant)
                        atPoint = #True
                     EndIf
                  Else
                     dPos = my - *tab\Y
                     If *tab\Height > 0
                        currentSlant = ((*tab\Height - 1 - dPos) * localslant) / *tab\Height
                     EndIf
                     If mx >= (*tab\X + currentSlant) And mx < (*tab\X + *tab\Width - currentSlant)
                        atPoint = #True
                     EndIf
                  EndIf
               Else
                  atPoint = #True
               EndIf
            EndIf
            ;
            If Bool(*tab\mask & #__MASK_Hover) <> atPoint
               *tab\mask ! #__MASK_Hover
               If *tab\mask & #__MASK_Hover
                  If *this\tab\hover And *this\tab\hover <> *tab And (*this\tab\hover\mask & #__MASK_Hover)
                     *this\tab\hover\mask &~ #__MASK_Hover
                     DoEventTAB(*this, *this\tab\hover, #PB_EventType_MouseLeave, 0)
                  EndIf
                  *this\tab\hover = *tab
                  DoEventTAB(*this, *tab, #PB_EventType_MouseEnter, 0)
               Else
                  DoEventTAB(*this, *tab, #PB_EventType_MouseLeave, 0)
                  If *this\tab\hover = *tab
                     *this\tab\hover = #Null
                  EndIf
               EndIf
               *this\mask | #__MASK_Redraw
            EndIf
         Next
   EndSelect
   
   Protected rawPos.i : If vertical : rawPos = my : Else : rawPos = mx : EndIf
   If DoEventTAB(*this, *this\tab\hover, event, rawPos)
      *this\mask | #__MASK_Redraw
   EndIf
   
   If *this\mask & #__MASK_Redraw
      *this\mask &~ #__MASK_Redraw
      ReDraw(*this)
      ProcedureReturn #True
   EndIf
   ProcedureReturn #False
EndProcedure

;-
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, Image.i = 0, align.a = #__MASK_Left)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   *tab\ID   = ID
   *tab\mask = align
   If *this\tab\vertical
      *tab\size = DesktopScaledY(size)
   Else
      *tab\size = DesktopScaledX(size)
   EndIf
   If Text <> ""
      *tab\txt\text   = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image  = Image
      *tab\img\change = 1
   EndIf
   If ListSize(*this\tab\_s()) = 1
      *this\tab\active = *tab
   EndIf
   *tab\data = RGBA(Random(50) + 200, Random(50) + 200, Random(50) + 200, 255)
   ;*this\mask | #__MASK_UpdateTotalSize
   ProcedureReturn *tab
EndProcedure
Procedure ClearTabs(*this._s_WIDGET)
   ClearList(*this\tab\_s())
   *this\tab\active = #Null
   *this\tab\press  = #Null
   *this\tab\hover  = #Null
   *this\tab\TotalSize = 0
   ;*this\mask | #__MASK_UpdateTotalSize
EndProcedure
Procedure CreateTab(Canvas.i, X.l, Y.l, Width.l, Height.l)
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\tab\vertical = 0
   *this\canvasid     = Canvas
   *this\X            = DesktopScaledX(X)
   *this\y            = DesktopScaledY(Y)
   *this\Width        = DesktopScaledX(Width)
   *this\Height       = DesktopScaledY(Height)
   *this\tab\slant    = DesktopScaledX(20)
   *this\tab\indent   = DesktopScaledX(50)
   *this\tab\spacing  = DesktopScaledX(2)
   *this\fontid       = LoadFont(0, "Tahoma", 12)
   *this\bgcolor      = RGBA(180, 195, 215, 160)
   ProcedureReturn *this
EndProcedure

;-
Procedure ResizeCanvas(*this._s_WIDGET)
   ; 1. Открываем контекст ТОЛЬКО для замера шрифта и расчета размеров
   UpdateTabsLayout(*this)
   
   ; 2. Меняем размеры окна и канваса (буфер канваса пересоздается под новый размер)
   Protected w.i = DesktopUnscaledX(*this\Width)
   Protected h.i = DesktopUnscaledY(*this\Height)
   ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 40, h + 40)
   ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
   HideWindow(#Win, 0, #PB_Window_ScreenCentered)
   
   ; 3. Рисуем уже в новый, увеличенный буфер
   ReDraw(*this)
EndProcedure



; ============================================================================
; 6. ТЕСТОВЫЙ ЗАПУСК (ПКМ - смена ориентации, ЛКМ - перетаскивание)
; ============================================================================
; Создаем тестовую иконку 16x16
CreateImage(#TestImg, 16, 16, 32, #PB_Image_Transparent)
If StartDrawing(ImageOutput(#TestImg))
   DrawingMode(#PB_2DDrawing_AlphaChannel)
   Box(0, 0, 16, 16, RGBA(0, 0, 0, 0))
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Circle(8, 8, 6, RGBA(220, 60, 60, 255))
   StopDrawing()
EndIf
If OpenWindow(#Win, 0, 0, 0, 0, "Наглядный Демо-Пример (ЛКМ - тащить, ПКМ - поворот)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, 0, 0)
   Define *this._s_WIDGET = CreateTab(#Canvas, 10, 10, 240, 40)
   AddTab(*this, 0, "0 - 60", 0)
   AddTab(*this, 1, "1 - 160", 160, #TestImg, #__MASK_Center)
   AddTab(*this, 2, "2 - 150", 150, #TestImg, #__MASK_Right)
   AddTab(*this, 3, "3 - 90", 90, #TestImg)
   ResizeCanvas(*this)
   Repeat
      Define Event.i = WaitWindowEvent()
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_RightClick
            HideWindow(#Win, 1)
            *this\tab\vertical ! 1
            Swap *this\Width, *this\Height
            ClearTabs(*this)
            AddTab(*this, 0, "0 - 60", 60)
            AddTab(*this, 1, "1 - 160", 160, #TestImg, #__MASK_Center)
            AddTab(*this, 2, "2 - 150", 150, #TestImg, #__MASK_Right)
            AddTab(*this, 3, "3 - 90", 90, #TestImg)
            ResizeCanvas(*this)
         EndIf
         DoEvent(*this, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 597
; FirstLine = 425
; Folding = ------------v--f---4-
; EnableXP
; DPIAware