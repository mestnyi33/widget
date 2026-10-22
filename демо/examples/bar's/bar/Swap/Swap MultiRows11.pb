EnableExplicit

; =====================================================================
; 1. КОНСТАНТЫ И ФЛАГИ
; =====================================================================
#__flag_Left   = 0
#__flag_Top  = 1
#__flag_Right  = 2
#__flag_Bottom  = 3
#__flag_Center = 4

; =====================================================================
; 2. СТРУКТУРЫ ДАННЫХ
; =====================================================================
Structure _s_POINT : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_IMG Extends _s_COORDINATE
   change.b
   Image.i
EndStructure
Structure _s_TXT Extends _s_COORDINATE
   change.b
   Text.s
EndStructure

Structure _s_TAB  Extends _s_COORDINATE
   ID.i          ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT    ; Имя поля заголовка
   img._s_IMG
   
   pos.l
   size.l
   
   ;
   align.a          ; Выравнивание
   ishovered.a      ; флаг наведения мыши (0 или 1)
   close_ishovered.a
   ; mask.q           ; Маска конкретной вкладки
   
   ; Поля для идеальной математики плавного сдвига
   offset.l        ; Динамический визуальный сдвиг
   minOffset.l     ; Левый ограничитель хода
   maxOffset.l     ; Правый ограничитель хода
   
   StructureUnion
      *data 
      containerid  .i ; id контейнера, привязанного к этой вкладке
   EndStructureUnion
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *press._s_TAB  ; Указатель на перетаскиваемую вкладку
   plus._s_TAB    ; <--- Одиночная структура кнопки ПЛЮС
   
   align.a               
   indent.a 
   spacing.a             
   
   vertical.b
   TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET Extends _s_COORDINATE
   change.b
   padding.a
   ;    spacing.a             
   tab._s_TABS
   dragOffSet.i     ; Точка захвата мыши
   
   canvasid     .i  
   fontid       .i  
   bgcolor      .l ; <--- добавь это поле для управления общим фоном холста
EndStructure

Global MyThis._s_WIDGET
Global slant = DesktopScaledX(20)
Global TopSpacing = DesktopScaledX(6)
Global RowSpacing = DesktopScaledX(2)
Global BottonSpacing = RowSpacing

Procedure.l MakeColor(bgColor.l, value.l = 0)
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

Procedure.i MakeAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

Procedure.i RecalculateTabs(*this._s_WIDGET, gWidth)
   gWidth = DesktopScaledX(gWidth)
   Protected indent = DesktopScaledX(4)
   Protected currentx = indent
   Protected currenty = TopSpacing
   Protected currentrow = 0
   Protected maxheight = 0
   Protected maxwidth = gWidth - indent
   Protected i.i, k.i, startidx.i, endidx.i
   Protected totalrowwidth.i, extraspace.i, addpixels.i, remainder.i
   Protected tabcount = ListSize(*this\tab\_s())
   
   ; Предварительный расчет шагов
   Protected RowStep = *this\tab\TotalSize + RowSpacing
   Protected SlantOffset = slant * 4 / 3
   
   If tabcount = 0 : ProcedureReturn DesktopUnscaledY(*this\tab\TotalSize + BottonSpacing) : EndIf
   
   If StartDrawing(CanvasOutput(*this\canvasid))
      DrawingFont(*this\fontid)
      
      Dim *rowtabs._s_TAB(tabcount - 1)
      i = 0
      ForEach *this\tab\_s()
         *rowtabs(i) = @*this\tab\_s()
         Protected basewidth = TextWidth(*rowtabs(i)\txt\text) + (*this\padding * 2) + (slant * 2)
         If *rowtabs(i)\img\image <> 0
            basewidth + DesktopScaledX(20)
         EndIf
         basewidth + DesktopScaledX(16)
         *rowtabs(i)\Height = *this\tab\TotalSize 
         *rowtabs(i)\width = basewidth
         i + 1
      Next
      
      startidx = 0
      currentx = indent
      
      ; --- ОБЪЕДИНЕННЫЙ ЦИКЛ (Идем до tabcount включительно, чтобы обработать хвост) ---
      For i = 0 To tabcount
         Protected tabw = 0
         If i < tabcount
            tabw = *rowtabs(i)\width
         EndIf
         
         ; Условие срабатывает, если вкладка не влезает ИЛИ если это самый конец списка (i = tabcount)
         If (i = tabcount) Or (currentx + tabw > maxwidth And i > startidx)
            endidx = i - 1
            
            ; Растягиваем по ширине (Justify) ТОЛЬКО полные ряды. Последний «хвост» не трогаем!
            If i < tabcount
               totalrowwidth = indent + (slant * 2)
               For k = startidx To endidx
                  totalrowwidth + *rowtabs(k)\width
                  If k < endidx : totalrowwidth - SlantOffset : EndIf
               Next
               
               extraspace = maxwidth - totalrowwidth
               Protected tabsinrow = (endidx - startidx) + 1
               If extraspace > 0 And tabsinrow > 0
                  addpixels = extraspace / tabsinrow
                  remainder = extraspace % tabsinrow
                  For k = startidx To endidx
                     *rowtabs(k)\width + addpixels
                     If remainder > 0
                        *rowtabs(k)\width + 1
                        remainder - 1
                     EndIf
                  Next
               EndIf
            EndIf
            
            ; ЕДИНЫЙ ЦИКЛ ЗАПИСИ КООРДИНАТ (Работает и для обычных рядов, и для хвоста)
            Protected tempx = indent
            For k = startidx To endidx
               *rowtabs(k)\x = tempx
               *rowtabs(k)\ID = currentrow
               tempx + *rowtabs(k)\width - SlantOffset
            Next
            
            ; Подготовка к следующему ряду (если мы еще не дошли до финала)
            currentrow + 1
            currenty + RowStep
            currentx = indent
            startidx = i
         EndIf
         
         ; Накапливаем ширину, пока не вышли за границы списка
         If i < tabcount
            currentx + *rowtabs(i)\width - SlantOffset
         EndIf
      Next
      
      Protected TotalRows = currentrow - 1
      
      ; --- ИНВЕРСИЯ РЯДОВ ---
      For k = 0 To tabcount - 1
         Protected InvertedRow = TotalRows - *rowtabs(k)\ID
         *rowtabs(k)\y = TopSpacing + InvertedRow * RowStep
      Next
      
      ; --- КОРРЕКТИРОВКА ПЛЮСА И ФИНАЛЬНЫЙ РАСЧЕТ ВЫСОТЫ ---
      *this\tab\plus\width = (slant * 2)
      *this\tab\plus\Height = *this\tab\TotalSize 
      *this\tab\plus\y = TopSpacing + TotalRows * RowStep
      *this\tab\plus\x = gWidth - *this\tab\plus\width - indent
      
      maxheight = *this\tab\plus\y + *this\tab\TotalSize
      
      StopDrawing()
   EndIf
   
   *this\Width = gWidth
   *this\Height = maxheight + BottonSpacing
   
   ProcedureReturn DesktopUnscaledY(maxheight + BottonSpacing)
EndProcedure


;-
; добавление вкладки и автоматическое создание её контейнера под холстом
Procedure AddTab(*this._s_WIDGET, title$, windowid, canvasheight, imageid.i = 0, tabcolor.l=0)
   AddElement(*this\tab\_s())
   *this\tab\_s()\txt\text = title$
   *this\tab\_s()\img\image = imageid ; записываем id картинки
   If Not tabcolor
      tabcolor = RGB(Random(50)+200, Random(50)+200, Random(50)+200)
   EndIf
   tabcolor & $FFFFFF | 238 << 24
   ; создаем скрытый контейнер под размеры окна (ниже холста)
   ; внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
   *this\tab\_s()\containerid = ContainerGadget(#PB_Any, 0, canvasheight, WindowWidth(windowid), WindowHeight(windowid) - canvasheight, #PB_Container_BorderLess)
   ; для наглядности покрасим фоны контейнеров в разные случайные цвета
   SetGadgetColor(*this\tab\_s()\containerid, #PB_Gadget_BackColor, tabcolor)
   CloseGadgetList()
   
   
   ; самая первая вкладка становится активной
   If *this\tab\active = 0
      *this\tab\active = @*this\tab\_s()
      HideGadget(*this\tab\_s()\containerid, #False) ; показываем первый контейнер
   Else
      ; по умолчанию скрываем все контейнеры
      HideGadget(*this\tab\_s()\containerid, #True)
   EndIf
EndProcedure

; полностью адаптивная процедура рендеринга ретро-трапеции
Procedure DrawTabChrome(vertical.b, x, y, w, h, isactive, currentcolor.l, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
  Protected dy, dh = h - 1, dw = w - 1
   Protected localslant = slant
  ; dh = h
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
   Protected GradientDepth = 0
   If Not isactive : GradientDepth = 25 : EndIf
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
         Line(x + stepVar, y + currentSlantVal, 1, currentLength, color)
      Else
         ; Рисуем горизонтальные полоски сверху вниз
         Line(x + currentSlantVal, y + stepVar, currentLength, 1, color)
      EndIf
      
      ColorAccum + ColorStepFixed
      SlantAccum - SlantStepFixed
   Next
   
   ; 4. Отрисовка контуров
   If vertical
      ; === ВЕРТИКАЛЬНЫЙ РЕЖИМ (Вкладка «смотрит» вверх, основание справа) ===
      LineXY(x + dw, y, x, y + localslant, outerbordercolor)             
      LineXY(x, y + localslant, x, y + h - 1 - localslant, outerbordercolor)         
      LineXY(x, y + h - 1 - localslant, x + dw, y + h - 1, outerbordercolor)     
      
      If isactive
         LineXY(x + dw, y + 1, x + 1, y + localslant + 1, innerhighlightcolor)
         LineXY(x + 1, y + localslant + 1, x + 1, y + h - 1 - localslant - 1, innerhighlightcolor)
         LineXY(x + 1, y + h - 1 - localslant - 1, x + dw, y + h - 2, innerhighlightcolor)
      Else
         ; Замыкающая линия справа (стык с панелью)
         LineXY(x + dw, y, x + dw, y + h - 1, outerbordercolor)
      EndIf
   Else
      ; === ГОРИЗОНТАЛЬНЫЙ РЕЖИМ (Классический Chrome) ===
      LineXY(x, y + dh, x + localslant, y, outerbordercolor)             
      LineXY(x + localslant, y, x + w - 1 - localslant, y, outerbordercolor)         
      LineXY(x + w - 1 - localslant, y, x + w - 1, y + dh, outerbordercolor)     
      
      If isactive
         LineXY(x + 1, y + dh, x + localslant + 1, y + 1, innerhighlightcolor)
         LineXY(x + localslant + 1, y + 1, x + w - 1 - localslant - 1, y + 1, innerhighlightcolor)
         LineXY(x + w - 1 - localslant - 1, y + 1, x + w - 2, y + dh, innerhighlightcolor)
      Else
         ; Замыкающая линия снизу
         LineXY(x, y + dh, x + w - 1, y + dh, outerbordercolor)
      EndIf
   EndIf
EndProcedure



;-
Procedure draw_closeButton(*tab._s_TAB , h)
   Protected h_8 = DesktopScaledX(8)
   ; --- рисуем крестик для активной вкладки (справа) ---
   Protected closex = *tab\x + *tab\width - slant - DesktopScaledX(14)
   Protected closey = *tab\y + (h - h_8) / 2
   If *tab\close_ishovered 
      Circle(closex + h_8/2, closey + h_8/2, DesktopScaledX(7), RGB(240, 70, 70)) 
      LineXY(closex, closey, closex + h_8, closey + h_8, RGB(255, 255, 255)) 
      LineXY(closex + h_8, closey, closex, closey + h_8, RGB(255, 255, 255)) 
   Else 
      LineXY(closex, closey, closex + h_8, closey + h_8, RGB(160, 50, 50)) 
      LineXY(closex + h_8, closey, closex, closey + h_8, RGB(160, 50, 50)) 
   EndIf
EndProcedure

Procedure draw_Button(*tab._s_TAB, bgcolor.l)
   ; Высчитываем цвет точно так же, как для неактивного таба
   Protected.l pluscolor = MakeColor(bgcolor, 10 + *tab\ishovered *30) ; RGB(nabaser, nabaseg, nabaseb)
   
   ; Трюк со Slant: подменяем его локально только на время отрисовки этой кнопки
   Protected OldSlant = Slant : Slant = 8
   DrawTabChrome(0, *tab\x, *tab\y, *tab\width, *tab\Height, 0, pluscolor)
   Slant = OldSlant ; Сразу возвращаем обратно
   
   ; Выводим символ "+" ровно по центру
   Protected textcolor = RGBA(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3, 255)
   Protected textBgcolor = MakeColor( pluscolor, -8)
   Protected plus_x = *tab\x + (*tab\width - TextWidth("+")) / 2
   
   DrawText(plus_x, *tab\y + 6, *tab\txt\Text, textcolor, textBgcolor)
EndProcedure

;-
Procedure draw_tab(isactive, *tab._s_TAB, h, bgcolor.l, max_row_index.i = -1)
   Protected.l textcolor, nonactivecolor, textBgcolor
   h = *tab\Height
   If isactive
      textcolor = RGBA(0, 0, 0, 255)
      textBgcolor = bgcolor
       If *tab\ID = max_row_index
         DrawTabChrome(0,*tab\x, *tab\y, *tab\width, h + BottonSpacing, 1, bgcolor)
      Else
         DrawTabChrome(0,*tab\x, *tab\y, *tab\width, h,  -1, bgcolor)
      EndIf
   Else
      textcolor = RGBA(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3, 255)
      bgcolor = MakeColor(bgcolor,- 30+*tab\ishovered*30)
      textBgcolor = MakeColor(bgcolor,  -8)
      DrawTabChrome(0, *tab\x, *tab\y, *tab\width, h, 0, bgcolor)
   EndIf
   
   Protected txtw = TextWidth(*tab\txt\text)
   Protected contentw = txtw + 16
   If *tab\img\image <> 0 : contentw + 20 : EndIf
   
   Protected startx = *tab\x + (*tab\width - contentw) / 2
   
   If *tab\img\image <> 0
      Protected icony = *tab\y + (h - 16) / 2
      DrawImage(ImageID(*tab\img\image), startx, icony, 16, 16)
      startx + 20
   EndIf
   
   ; DrawingMode(#PB_2DDrawing_Transparent)
   DrawText(startx, *tab\y + 6, *tab\txt\text, textcolor, textBgcolor)
   
   draw_closeButton( *tab, h )
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB, gWidth, gHeight, bgColor.l )
   Protected position.l
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   
   DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
   ; линия пола
   Protected floorcolor = RGB(Red(bgColor) * 0.7, Green(bgColor) * 0.7, Blue(bgColor) * 0.7)
   LineXY(0, gHeight - 1, gWidth, gHeight - 1, floorcolor)
   
   ; 1. отрисовка неактивных вкладок
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      ;
      ;       If *tab\txt\change  Or *tab\img\change  Or *this\change
      ;          
      ;          UpdateTab(*tab, *this\Width, *this\Height, vertical)
      ;          *tab\pos = position 
      ;          
      ;          If *this\tab\vertical
      ;             ;*tab\x = *this\x
      ;             *tab\y =  *this\y + *this\tab\indent  + *tab\pos ;  
      ;          Else
      ;             ;*tab\y = *this\y
      ;             *tab\x =  *this\x + *this\tab\indent  + *tab\pos ; 
      ;          EndIf
      ;          
      ;          position + (*tab\size - slant) + *this\tab\spacing
      ;       EndIf
      
      If *tab <> *current_tab
         draw_tab(#False, *tab,*this\tab\TotalSize, bgColor, *this\tab\plus\ID )
      EndIf
   Next
   *this\change = 0
   ; 2. отрисовка активной вкладки
   If *current_tab <> 0
      Protected tabcolor = GetGadgetColor(*current_tab\containerid, #PB_Gadget_BackColor)
      draw_tab(#True,*current_tab, *this\tab\TotalSize, tabcolor, *this\tab\plus\ID )
   EndIf
   
   ; 2. Отрисовка кнопки ПЛЮС (вызываем её личную изолированную процедуру)
   draw_Button(*this\tab\plus, bgColor)
EndProcedure

Procedure ReDrawTabs(*this._s_WIDGET)
   Protected gWidth = DesktopScaledX(GadgetWidth(*this\canvasid))
   Protected gHeight = DesktopScaledY(GadgetHeight(*this\canvasid))
   Protected tabcolor.l 
   Protected bgColor.l
   Protected nonactivecolor.l
   
    If StartDrawing(CanvasOutput(*this\canvasid))
      DrawingFont(*this\fontid)
      
      Box(0, 0, gWidth, gHeight, *this\bgcolor)
      
      DrawTabs(*this, *this\tab\active, gWidth, gHeight, *this\bgcolor)
      
      StopDrawing()
   EndIf
EndProcedure

;-
Procedure DoTabResize(*this._s_WIDGET, windowid)
   Protected gWidth = WindowWidth(windowid)
   Protected gHeight = WindowHeight(windowid) 
   Protected newheight = RecalculateTabs(*this, gWidth)
   ResizeGadget(*this\canvasid, #PB_Ignore, #PB_Ignore, gWidth, newheight)
   
   ; корректируем размеры всех контейнеров в зависимости от новой высоты холста
   ForEach *this\tab\_s()
      ResizeGadget(*this\tab\_s()\containerid, 0, newheight, gWidth, gHeight- newheight)
   Next
   
   ReDrawTabs(*this)
EndProcedure

Procedure CloseTab(*this._s_WIDGET, *tabtoclose._s_TAB, windowid.i)
   ; 1. Переводим список на удаляемую вкладку
   ChangeCurrentElement(*this\tab\_s(), *tabtoclose)
   
   ; 2. Уничтожаем привязанный containergadget
   If IsGadget(*tabtoclose\containerid)
      FreeGadget(*tabtoclose\containerid)
   EndIf
   
   ; 3. УДАЛЕНИЕ И АВТОМАТИЧЕСКИЙ ПОИСК ЗАМЕНЫ
   If *this\tab\active = *tabtoclose
      ; Флаг 1 заставляет PureBasic перешагнуть на следующую вкладку (или на предыдущую, если этой не стало)
      If DeleteElement(*this\tab\_s(), 1)
         *this\tab\active = @*this\tab\_s() ; Новая вкладка успешно подхвачена!
      Else
         *this\tab\active = 0 ; Вкладок больше вообще не осталось
      EndIf
   Else
      ; Если закрыли неактивную вкладку, просто удаляем её без смены активности
      DeleteElement(*this\tab\_s())
   EndIf
   
   ; 4. Если нашли новый активный таб — показываем его контейнер
   If *this\tab\active <> 0
      HideGadget(*this\tab\active\containerid, #False)
   EndIf
   
   DoTabResize( *this, windowid)
EndProcedure

Procedure ActivateTab(*this._s_WIDGET, *Newactive._s_TAB)
   If *this\tab\active <> *Newactive
      ; Прячем старый контейнер
      If *this\tab\active
         HideGadget(*this\tab\active\ContainerID, #True)
      EndIf
      
      ; Переключаем простой указатель
      *this\tab\active = *Newactive
      
      ; Показываем новый контейнер
      HideGadget(*this\tab\active\ContainerID, #False)
      
      ; Перерисовываем холст — ховеры автоматически окажутся на своих местах!
      ReDrawTabs(*this)
   EndIf
EndProcedure

Procedure DoTabEvents(*this._s_WIDGET)
   Protected mx = GetGadgetAttribute(*this\canvasid, #PB_Canvas_MouseX)
   Protected my = GetGadgetAttribute(*this\canvasid, #PB_Canvas_MouseY)
   Protected localslant = slant
   Protected insidetab.i, relx.i, rely.i
   Protected *hoveredtab._s_TAB = 0
   Protected needredraw.i = #False
   Protected etype = EventType()
   Protected WindowID = EventWindow()
   
   If etype = #PB_EventType_MouseMove Or etype = #PB_EventType_LeftButtonDown
      
      ; 1. ТЕСТ КНОПКИ ПЛЮС (+): Так как она закреплена справа над контейнером, проверяем её первой
      If my >= *this\tab\plus\y And my <= *this\tab\plus\y + *this\tab\TotalSize
         If mx >= *this\tab\plus\x And mx <= *this\tab\plus\x + *this\tab\plus\width
            *hoveredtab = @*this\tab\plus
         EndIf
      EndIf
      
      ; 2. ТЕСТ ОБЫЧНЫХ ВКЛАДОК: Если мышь не над плюсом — делаем точный хит-тест трапеций
      If *hoveredtab = 0 And ListSize(*this\tab\_s()) > 0
         LastElement(*this\tab\_s())
         Repeat
            insidetab = #False
            If my >= *this\tab\_s()\y And my <= *this\tab\_s()\y + *this\tab\TotalSize
               If mx >= *this\tab\_s()\x And mx <= *this\tab\_s()\x + *this\tab\_s()\width
                  relx = mx - *this\tab\_s()\x
                  rely = my - *this\tab\_s()\y
                  If localslant > *this\tab\TotalSize: localslant = *this\tab\TotalSize: EndIf
                  
                  If relx < localslant
                     If relx >= localslant * (1.0 - (rely / *this\tab\TotalSize)) : insidetab = #True : EndIf
                  ElseIf relx > *this\tab\_s()\width - localslant
                     If relx <= *this\tab\_s()\width - (localslant * (1.0 - (rely / *this\tab\TotalSize))) : insidetab = #True : EndIf
                  Else
                     insidetab = #True
                  EndIf
               EndIf
            EndIf
            
            If insidetab
               *hoveredtab = @*this\tab\_s()
               Break 
            EndIf
         Until PreviousElement(*this\tab\_s()) = 0
      EndIf
      
      ; 3. Вычисляем флаг наведения на крестик закрытия (только для обычных вкладок)
      Protected ShouldCloseHover.a = 0
      Protected h_12 = DesktopScaledX(12)
      Protected h_2 = DesktopScaledX(2)
      If *hoveredtab <> 0 And *hoveredtab <> *this\tab\plus
         Protected closex = *hoveredtab\x + *hoveredtab\width - localslant - DesktopScaledX(14)
         If mx >= closex - h_2 And mx <= closex + h_12 - h_2
            If my >= *hoveredtab\y + (*this\tab\TotalSize - h_12)/2 And my <= *hoveredtab\y + (*this\tab\TotalSize + h_12)/2 
               ShouldCloseHover = 1
            EndIf 
         EndIf 
      EndIf
      
      ; --- 4. ЛОГИКА КЛИКА МЫШИ ---
      If etype = #PB_EventType_LeftButtonDown And *hoveredtab <> 0
         If *hoveredtab = *this\tab\plus
            ; КЛИК ПО ПЛЮСУ: Добавляем новую вкладку
            Protected NewIdx = ListSize(*this\tab\_s()) + 1
            AddTab(*this, "Вкладка " + Str(NewIdx), WindowID, GadgetHeight(*this\canvasid))
            
            DoTabResize( *this, windowid)
            needredraw = #False
         Else
            ; КЛИК ПО ОБЫЧНОМУ ТАБУ: Проверяем крестик или переключаем активность
            If *hoveredtab\close_ishovered
               CloseTab(*this, *hoveredtab, WindowID)
            Else
               ActivateTab(*this, *hoveredtab)
            EndIf
         EndIf
         
         ; --- 5. ЛОГИКА ДВИЖЕНИЯ МЫШИ (Ховеры) ---
      ElseIf etype = #PB_EventType_MouseMove
         ; Защищенный ховер кнопки ПЛЮС
         Protected TargetPlusHover = 0
         If *hoveredtab = @*this\tab\plus
            TargetPlusHover = 1
         EndIf
         
         If *this\tab\plus\ishovered <> TargetPlusHover
            *this\tab\plus\ishovered = TargetPlusHover
            needredraw = #True
         EndIf
         
         ; Синхронный ховер всех обычных вкладок и их крестиков
         ForEach *this\tab\_s()
            Protected TargetHover = 0
            Protected TargetCloseHover = 0
            
            If @*this\tab\_s() = *this\tab\active
               TargetHover = 0
               If @*this\tab\_s() = *hoveredtab
                  TargetCloseHover = ShouldCloseHover
               EndIf
            Else
               If @*this\tab\_s() = *hoveredtab
                  TargetHover = 1
                  TargetCloseHover = ShouldCloseHover
               EndIf
            EndIf
            
            If *this\tab\_s()\ishovered <> TargetHover
               *this\tab\_s()\ishovered = TargetHover
               needredraw = #True
            EndIf
            
            If *this\tab\_s()\close_ishovered <> TargetCloseHover
               *this\tab\_s()\close_ishovered = TargetCloseHover
               needredraw = #True
            EndIf
         Next
      EndIf
      
      If needredraw
         ReDrawTabs(*this)
      EndIf
      
      ; --- 6. КУРСОР УШЕЛ С ХОЛСТА (Тотальный сброс подсветки) ---
   ElseIf etype = #PB_EventType_MouseLeave
      *this\tab\plus\ishovered = 0
      ForEach *this\tab\_s()
         If *this\tab\_s()\ishovered <> 0
            *this\tab\_s()\ishovered = 0
            needredraw = #True
         EndIf
         If *this\tab\_s()\close_ishovered <> 0
            *this\tab\_s()\close_ishovered = 0
            needredraw = #True
         EndIf
      Next
      If needredraw
         ReDrawTabs(*this)
      EndIf
   EndIf
EndProcedure

; обновление размеров холста и всех контейнеров под размеры окна


;- --- демо запуск ---
Define event, windoww = 900, windowh = 350

If OpenWindow(0, 0, 0, windoww, windowh, "chrome tabs with container logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   
   With MyThis
      \canvasid  = CanvasGadget(#PB_Any, 0, 0, windoww, 40)
      \fontid    = LoadFont(0, "tahoma", 12)
      \tab\TotalSize = DesktopScaledY(29)
      \padding  = DesktopScaledX(6)
      \change = 1
      \bgcolor     = RGBA(180, 195, 215, 160) ; RGB(Random(255), Random(255), Random(255)) ; твой любимый цвет. сделай его зеленым или серым — и весь интерфейс сам перестроится!
      \tab\plus\txt\text = "+"
   EndWith
   
   ; создаем две тестовые цветные иконки 16x16
   CreateImage(1, 16, 16)
   If StartDrawing(ImageOutput(1)) : Box(0,0,16,16, RGB(255, 50, 50)) : StopDrawing() : EndIf ; красный квадрат
   
   CreateImage(2, 16, 16)
   If StartDrawing(ImageOutput(2)) : Box(0,0,16,16, RGB(50, 150, 255)) : StopDrawing() : EndIf ; синий квадрат
   
   ; добавляем вкладки (последним параметром передаем id созданных картинок)
   AddTab(@MyThis, "google (с иконкой)", 0, 40, 1, RGB(255, 255, 255))
   AddTab(@MyThis, "код проекта (с иконкой)", 0, 40, 2, RGB(210, 245, 225))
   AddTab(@MyThis, "без иконки", 0, 40, 0, RGB(255, 220, 230))
   ; добавляем вкладки, передавая id окна и начальную высоту холста
   AddTab(@MyThis, "вкладка 1", 0, 40)
   ;AddTab(@MyThis, "вкладка с длинным текстом 2", 0, 40)
   AddTab(@MyThis, "опции 3", 0, 40)
   AddTab(@MyThis, "система 4", 0, 40)
   AddTab(@MyThis, "логи работы 5", 0, 40)
   ;   
   ; настраиваем начальные размеры всего интерфейса
   DoTabResize(@MyThis, 0)
   
   ; наполним первый и второй контейнер чем-нибудь для теста
   ; для этого временно переключаемся на нужный контейнер через opengadgetlist
   SelectElement(MyThis\tab\_s(), 0)
   OpenGadgetList(MyThis\tab\_s()\containerid)
   ButtonGadget(#PB_Any, 20, 20, 150, 30, "кнопка на вкладке 1")
   StringGadget(#PB_Any, 20, 60, 200, 25, "текст на вкладке 1")
   CloseGadgetList()
   
   SelectElement(MyThis\tab\_s(), 1)
   OpenGadgetList(MyThis\tab\_s()\containerid)
   CheckBoxGadget(#PB_Any, 20, 20, 200, 20, "галочка на второй вкладке")
   CloseGadgetList()
   
   Repeat
      event = WaitWindowEvent()
      Select event
         Case #PB_Event_Gadget
            If EventGadget() = MyThis\canvasid
               DoTabEvents(@MyThis)
            EndIf
            
         Case #PB_Event_SizeWindow
            ; вызываем единую процедуру ресайза для холста и дочерних контейнеров
            DoTabResize(@MyThis, 0)
            
         Case #PB_Event_CloseWindow
            End
      EndSelect
   ForEver
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 474
; FirstLine = 465
; Folding = -----------------
; EnableXP
; DPIAware