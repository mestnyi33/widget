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
Structure _s_TXT Extends _s_COORDINATE
   Text.s
   change.b
EndStructure

Structure _s_IMG Extends _s_COORDINATE
   Image.i
   change.b
EndStructure

Structure _s_TAB ; Extends _s_COORDINATE
   ID.i          ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT    ; Имя поля заголовка
   img._s_IMG
   
   x.l
   width.l
   height.l
   y.l
   
   ishovered.a ; флаг наведения мыши (0 или 1)
   close_ishovered.a
   ; mask.q           ; Маска конкретной вкладки
   
   ;
   pos.l
   size.l
   align.a          ; Выравнивание
   
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
   Plus._s_TAB    ; <--- Одиночная структура кнопки ПЛЮС
   
   vertical.b
   
   align.a               
   indent.a 
   spacing.a             
   
   size.l
   ; TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
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

Procedure.i GetAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure

Procedure UpdateTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b=0)
   Protected contentX.i, contentY.i, rx.i, rw.i , ry.i, rh.i
   Protected txt_X.i, txt_Y.i, img_X.i, img_Y.i
   
   ; Считываем размеры сразу на старте — теперь это работает идеально!
   Protected txt_w = *tab\txt\width  
   Protected txt_h = *tab\txt\height
   Protected img_w = *tab\img\width  
   Protected img_h = *tab\img\height 
   
   ; UPDATE ROW
   Protected padding.i = DesktopScaledX(8)
   
   ; 1. Замеры метрик (Пересчитываем только то, что реально изменилось)
   If *tab\txt\change 
      *tab\txt\change = #False
      If *tab\txt\Text <> ""
         txt_w = TextWidth(*tab\txt\Text)
         txt_h = TextHeight(*tab\txt\Text)
      Else
         txt_w = 0 : txt_h = 0
      EndIf
   EndIf
   
   If *tab\img\change
      *tab\img\change = #False
      If IsImage(*tab\img\Image)
         img_w = ImageWidth(*tab\img\Image)
         img_h = ImageHeight(*tab\img\Image)
      Else
         img_w = 0 : img_h = 0
      EndIf
   EndIf
   
   ; 2. Расчет отступа, если присутствуют оба элемента
   If img_w > 0 And txt_w > 0
      Protected iconSpacing = DesktopScaledX(6)
   EndIf
   
   ; 3. ЕДИНОВРЕМЕННОЕ ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ
   If vertical
      ; Центрируем по горизонтали
      txt_x = (gWidth - txt_w) >> 1
      img_x = (gWidth - img_w) >> 1
      
      ; Вертикальный режим: складываем высоты, по ширине берем максимум
      contentY = GetAlignPosition(*tab\align, *tab\height, img_h + txt_h + iconSpacing, padding)
      
      ; Базовое распределение по вертикали
      txt_y = contentY
      img_y = contentY
      
      If Not (*tab\align & #__flag_Bottom)
         ; Если картинка сверху, текст снизу: сдвигаем текст вниз
         If img_h > 0 : txt_y + img_h + iconSpacing : EndIf
      Else
         ; Если текст сверху, картинка снизу: сдвигаем картинку вниз
         If txt_h > 0 : img_y + txt_h + iconSpacing : EndIf
      EndIf
   Else
      ; Центрируем по вертикали
      txt_y = (gHeight - txt_h) >> 1
      img_y = (gHeight - img_h) >> 1
      
      ; Горизонтальный режим: складываем ширину, по высоте берем максимум
      contentX = GetAlignPosition(*tab\align, *tab\width,  img_w + txt_w + iconSpacing, padding)
      
      ; Базовое распределение по горизонтали
      txt_x = contentX
      img_x = contentX
      
      If Not (*tab\align & #__flag_Right)
         ; Если картинка слева, текст справа: сдвигаем текст вправо
         If img_w > 0 : txt_x + img_w + iconSpacing : EndIf
      Else
         ; Если текст слева, картинка справа: сдвигаем картинку вправо
         If txt_w > 0 : img_x + txt_w + iconSpacing : EndIf
      EndIf
   EndIf
   
   ; 4. ЗАПИСЬ ВСЕХ ОБНОВЛЕННЫХ ДАННЫХ В СТРУКТУРУ 
   *tab\img\x = img_x
   *tab\img\y = img_y
   *tab\img\width = img_w
   *tab\img\height = img_h
   
   *tab\txt\x = txt_x
   *tab\txt\y = txt_y
   *tab\txt\width = txt_w
   *tab\txt\height = txt_h
   
   ; Общие размеры самой вкладки
   If vertical
      *tab\x = 0
      *tab\y = *tab\pos + *tab\offset
      *tab\width = gWidth
      *tab\height = *tab\size
   Else
      *tab\x = *tab\pos + *tab\offset
      *tab\y = 0
      *tab\width = *tab\size
      *tab\height = gHeight
   EndIf 
EndProcedure


; добавление вкладки и автоматическое создание её контейнера под холстом
Procedure AddTab(*this._s_WIDGET, title$, windowid, canvasheight, imageid.i = 0, tabcolor.l=0)
   AddElement(*this\tab\_s())
   *this\tab\_s()\txt\text = title$
   *this\tab\_s()\img\image = imageid ; записываем id картинки
   If Not tabcolor
      tabcolor = RGB(Random(50)+200, Random(50)+200, Random(50)+200)
   EndIf
   
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
Procedure _DrawTabChrome(vertical.b,x, y, w, h, isactive, activecolor.l, nonactivecolor.l = -1, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
   Protected i, dy, dh = (h); - 1)
   Protected localslant = slant
   
   If localslant > h: localslant = h: EndIf
   
   ; 1. выбор базового цвета для тела
   Protected currentcolor.i
   If isactive
      currentcolor = activecolor
   Else
      If nonactivecolor = -1 : nonactivecolor = RGB(215, 225, 240) : EndIf
      currentcolor = nonactivecolor
   EndIf
   
   ; 2. расчет или назначение цвета рамок
   ; если параметры переданы (не равны -1), берем их. иначе — считаем автоматом.
   If outerbordercolor = -1
      outerbordercolor = RGB(Red(currentcolor) * 0.6, Green(currentcolor) * 0.6, Blue(currentcolor) * 0.6)
   EndIf
   
   If innerhighlightcolor = -1
      Protected.a r = Red(currentcolor), g = Green(currentcolor), b = Blue(currentcolor)
      innerhighlightcolor = RGB(r + (255 - r) * 0.3, g + (255 - g) * 0.3, b + (255 - b) * 0.3)
   EndIf
   
   ; 3. заливка тела вкладки
   If isactive
      FrontColor(activecolor)
      For dy = 0 To dh
         Protected currentslant = localslant * (1.0 - (dy / h))
         LineXY(x + currentslant, y + dy, x + w - currentslant, y + dy)
      Next
   Else
      Protected baser = Red(nonactivecolor)
      Protected baseg = Green(nonactivecolor)
      Protected baseb = Blue(nonactivecolor)
      
      For dy = 0 To dh
         Protected factor.f = dy / dh
         r = baser + ((baser - 25) - baser) * factor
         g = baseg + ((baseg - 20) - baseg) * factor
         b = baseb + ((baseb - 20) - baseb) * factor
         
         currentslant = localslant * (1.0 - (dy / h))
         LineXY(x + currentslant, y + dy, x + w - currentslant, y + dy, RGB(r, g, b))
      Next
   EndIf
   
   ; 4. отрисовка контуров
   ; внешняя рамка
   FrontColor(outerbordercolor)
   LineXY(x, y-1 + h, x + localslant, y)             
   LineXY(x + localslant, y-1, x + w - localslant, y-1)         
   LineXY(x + w - localslant, y, x + w, y-1 + h)     
   
   If isactive > 0
      ; внутренний светлый блик (только для активной)
      FrontColor(innerhighlightcolor)
      LineXY(x + 2, y + dh, x + localslant + 1, y + 1)
      LineXY(x + localslant + 1, y + 1, x + w - localslant - 1, y + 1)
      LineXY(x + w - localslant - 1, y + 1, x + w - 2, y + dh)
   Else
      ; нижняя замыкающая линия для неактивных
      LineXY(x, y + h-1, x + w, y + h-1);, outerbordercolor)
   EndIf
EndProcedure
Procedure DrawTabChrome(vertical.b, x, y, w, h, isactive, activecolor.l, nonactivecolor.l = -1, outerbordercolor.l = -1, innerhighlightcolor.l = -1, localslant.l=-1)
   ProcedureReturn _DrawTabChrome(vertical, x, y, w, h, isactive, activecolor, nonactivecolor, outerbordercolor, innerhighlightcolor)
  ; ProcedureReturn _DrawTabChrome(x, y, w, h, isactive, activecolor, nonactivecolor, outerbordercolor, innerhighlightcolor, localslant, vertical, 1)
   If Not w And h
    ;  ProcedureReturn
   EndIf
   
   ; Выбираем базовый лимит для скоса в зависимости от ориентации
   Protected base_dim = h
   If vertical : base_dim = w : EndIf
   
   Protected i, dy, dx, dh = h, dw = w
   If localslant = -1
      localslant = slant
   EndIf
   
   If localslant > base_dim: localslant = base_dim: EndIf
   
   ; 1. выбор базового цвета для тела
   Protected currentcolor.i
   If isactive
      currentcolor = activecolor
   Else
      If nonactivecolor = -1 : nonactivecolor = RGBA(215, 225, 240, 255) : EndIf
      currentcolor = nonactivecolor
   EndIf
   
   Protected.a currentalpha = Alpha(currentcolor)
   
   ; 2. расчет или назначение цвета рамок
   If outerbordercolor = -1
      outerbordercolor = RGBA(Red(currentcolor) * 0.6, Green(currentcolor) * 0.6, Blue(currentcolor) * 0.6, currentalpha)
   EndIf
   
   If innerhighlightcolor = -1
      Protected.a r = Red(currentcolor), g = Green(currentcolor), b = Blue(currentcolor)
      innerhighlightcolor = RGBA(r + (255 - r) * 0.3, g + (255 - g) * 0.3, b + (255 - b) * 0.3, currentalpha)
   EndIf
   
   ; 3. заливка тела вкладки
   If isactive
      If vertical
         ; Вертикальная активная вкладка
         For dx = 0 To dw
            Protected currentslant = localslant * (1.0 - (dx / w))
            LineXY(x + dx, y + currentslant, x + dx, y + h - currentslant, activecolor)
         Next
      Else
         ; Горизонтальная активная вкладка
         For dy = 0 To dh
            currentslant = localslant * (1.0 - (dy / h))
            LineXY(x + currentslant, y + dy, x + w - currentslant, y + dy, activecolor)
         Next
      EndIf
   Else
      Protected baser = Red(nonactivecolor)
      Protected baseg = Green(nonactivecolor)
      Protected baseb = Blue(nonactivecolor)
      
      If vertical
         ; Вертикальная неактивная вкладка (градиент слева направо)
         For dx = 0 To dw
            Protected factor.f = dx / dw
            r = baser + ((baser - 25) - baser) * factor
            g = baseg + ((baseg - 20) - baseg) * factor
            b = baseb + ((baseb - 20) - baseb) * factor
            
            currentslant = localslant * (1.0 - (dx / w))
            LineXY(x + dx, y + currentslant, x + dx, y + h - currentslant, RGBA(r, g, b, currentalpha))
         Next
      Else
         ; Горизонтальная неактивная вкладка (градиент сверху вниз)
         For dy = 0 To dh
            factor.f = dy / dh
            r = baser + ((baser - 25) - baser) * factor
            g = baseg + ((baseg - 20) - baseg) * factor
            b = baseb + ((baseb - 20) - baseb) * factor
            
            currentslant = localslant * (1.0 - (dy / h))
            LineXY(x + currentslant, y + dy, x + w - currentslant, y + dy, RGBA(r, g, b, currentalpha))
         Next
      EndIf
   EndIf
   
   ; 4. отрисовка контуров
   If vertical
      ; --- ВЕРТИКАЛЬНЫЕ КОНТУРЫ ---
      ; внешняя рамка (трапеция повернута набок, основание у оси Y)
      LineXY(x + w, y, x, y + localslant, outerbordercolor)             
      LineXY(x, y + localslant, x, y + h - localslant, outerbordercolor)         
      LineXY(x, y + h - localslant, x + w, y + h, outerbordercolor)     
      
      If isactive > 0
         ; внутренний светлый блик (только для активной)
         LineXY(x + dw - 1, y + 2, x + 1, y + localslant + 1, innerhighlightcolor)
         LineXY(x + 1, y + localslant + 1, x + 1, y + h - localslant - 1, innerhighlightcolor)
         LineXY(x + 1, y + h - localslant - 1, x + dw - 1, y + h - 2, innerhighlightcolor)
      Else
         ; правая замыкающая линия основания для неактивных
         LineXY(x + w - 1, y, x + w - 1, y + h, outerbordercolor)
      EndIf
   Else
      ; --- ГОРИЗОНТАЛЬНЫЕ КОНТУРЫ ---
      ; внешняя рамка
      LineXY(x, y + h, x + localslant, y, outerbordercolor)             
      LineXY(x + localslant, y, x + w - localslant, y, outerbordercolor)         
      LineXY(x + w - localslant, y, x + w, y + h, outerbordercolor)     
      
      If isactive > 0
         ; внутренний светлый блик (только для активной)
         LineXY(x + 2, y + dh - 1, x + localslant + 1, y + 1, innerhighlightcolor)
         LineXY(x + localslant + 1, y + 1, x + w - localslant - 1, y + 1, innerhighlightcolor)
         LineXY(x + w - localslant - 1, y + 1, x + w - 2, y + dh - 1, innerhighlightcolor)
      Else
         ; нижняя замыкающая линия для неактивных
         LineXY(x, y + h - 1, x + w, y + h - 1, outerbordercolor)
      EndIf
   EndIf
EndProcedure


Procedure.i RecalculateTabs(*control._s_WIDGET)
  Protected indent = DesktopScaledX(4)
  Protected canvasw = DesktopScaledX(GadgetWidth(*control\canvasid))
  Protected currentx = indent
  Protected currenty = TopSpacing
  Protected currentrow = 0
  Protected maxheight = 0
  Protected maxwidth = canvasw - indent
  Protected i.i, k.i, startidx.i, endidx.i
  Protected totalrowwidth.i, extraspace.i, addpixels.i, remainder.i
  Protected tabcount = ListSize(*control\tab\_s())
  
  ; Предварительный расчет шагов
  Protected RowStep = *control\tab\size + RowSpacing
  Protected SlantOffset = slant * 4 / 3
  
  If tabcount = 0 : ProcedureReturn DesktopUnscaledY(*control\tab\size + BottonSpacing) : EndIf
  
  If StartDrawing(CanvasOutput(*control\canvasid))
    DrawingFont(*control\fontid)
    
    Dim *rowtabs._s_TAB(tabcount - 1)
    i = 0
    ForEach *control\tab\_s()
      *rowtabs(i) = @*control\tab\_s()
      Protected basewidth = TextWidth(*rowtabs(i)\txt\text) + (*control\padding * 2) + (slant * 2)
      If *rowtabs(i)\img\image <> 0
        basewidth + DesktopScaledX(20)
      EndIf
      basewidth + DesktopScaledX(16)
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
    *control\tab\plus\width = (slant * 2)
   *control\tab\plus\y = TopSpacing + TotalRows * RowStep
    *control\tab\plus\x = canvasw - *control\tab\plus\width - indent
    
    maxheight = *control\tab\plus\y + *control\tab\size
    
    StopDrawing()
  EndIf
  
  ProcedureReturn DesktopUnscaledY(maxheight + BottonSpacing)
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

Procedure draw_plusButton(*this._s_WIDGET, bgcolor.l)
   ; Высчитываем цвет точно так же, как для неактивного таба
   Protected.l nabaser = Red(bgcolor) + 15
   Protected.l nabaseg = Green(bgcolor) + 10
   Protected.l nabaseb = Blue(bgcolor) + 10
   
   If *this\tab\plus\ishovered 
      nabaser + 30 : nabaseg + 30 : nabaseb + 30 
   EndIf
   If nabaser > 255 : nabaser = 255 : EndIf 
   If nabaseg > 255 : nabaseg = 255 : EndIf 
   If nabaseb > 255 : nabaseb = 255 : EndIf
   Protected.l pluscolor = RGB(nabaser, nabaseg, nabaseb)
   
   ; Трюк со Slant: подменяем его локально только на время отрисовки этой кнопки
   Protected OldSlant = Slant : Slant = 8
   DrawTabChrome(*this\tab\plus\x, *this\tab\plus\y, *this\tab\plus\width, *this\tab\size, 0, 0, pluscolor)
   Slant = OldSlant ; Сразу возвращаем обратно
   
   ; Выводим символ "+" ровно по центру
   Protected textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
   Protected textBgcolor = RGB(nabaser - 5, nabaseg - 4, nabaseb - 4)
   Protected plus_x = *this\tab\plus\x + (*this\tab\plus\width - TextWidth("+")) / 2
   
   DrawText(plus_x, *this\tab\plus\y + 6, "+", textcolor, textBgcolor)
EndProcedure

Procedure DrawTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b, bgColor.l=$FF808080, isResize.b=0)
   Protected txt_change = *tab\txt\change 
   Protected img_change = *tab\img\change
   If txt_change Or img_change Or isResize
      UpdateTab(*tab._s_TAB, gWidth, gHeight, vertical)
   EndIf

  
   ; DRAW ROW
   ; 1. ОТРИСОВКА ФОНА
   Box(*tab\x, *tab\y, *tab\Width, *tab\Height, bgColor)
   
   ; 2. ОТРИСОВКА ИКОНКИ
   If *tab\img\Width Or *tab\img\Height
      DrawAlphaImage(ImageID(*tab\img\Image), *tab\x + *tab\img\x, *tab\y + *tab\img\y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Width Or *tab\txt\Height
      DrawText(*tab\x + *tab\txt\x, *tab\y + *tab\txt\y, *tab\txt\Text, $FFFFFFFF)
   EndIf
EndProcedure

Procedure draw_tab(isactive, *tab._s_TAB, h, bgcolor.l, max_row_index.i = -1)
   Protected.l textcolor, nonactivecolor, textBgcolor
   If isactive
      textcolor = RGB(0, 0, 0)
      textBgcolor = bgcolor
      If *tab\ID = max_row_index
         DrawTabChrome(0,*tab\x, *tab\y, *tab\width, h + BottonSpacing, 1, bgcolor)
      Else
         DrawTabChrome(0,*tab\x, *tab\y, *tab\width, h,  -1, bgcolor)
      EndIf
   Else
      Protected.l nabaser = Red(bgcolor) + 25
      Protected.l nabaseg = Green(bgcolor) + 20
      Protected.l nabaseb = Blue(bgcolor) + 20
      If *tab\ishovered 
         nabaser + 30 
         nabaseg + 30 
         nabaseb + 30 
      EndIf
      If nabaser > 255 : nabaser = 255 : EndIf 
      If nabaseg > 255 : nabaseg = 255 : EndIf 
      If nabaseb > 255 : nabaseb = 255 : EndIf
      nonactivecolor = RGB(nabaser, nabaseg, nabaseb)
      
      DrawTabChrome(*tab\x, *tab\y, *tab\width, h, 0, 0, nonactivecolor)
      
      textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
      
      textBgcolor = RGB(nabaser - (25 * 0.2), nabaseg - (20 * 0.2), nabaseb - (20 * 0.2))
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
   
   DrawText(startx, *tab\y + 6, *tab\txt\text, textcolor, textBgcolor)
   
   draw_closeButton( *tab, h )
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB, gWidth, gHeight, bgColor.l )
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   
   ;DrawingMode(#PB_2DDrawing_Gradient); | #PB_2DDrawing_Transparent)
   ; линия пола
   Protected floorcolor = RGB(Red(bgColor) * 0.7, Green(bgColor) * 0.7, Blue(bgColor) * 0.7)
   LineXY(0, gHeight - 1, gWidth, gHeight - 1, floorcolor)
   
   ; 1. отрисовка неактивных вкладок
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *current_tab
         draw_tab(#False, *tab,*this\tab\size, bgColor, *this\tab\plus\ID )
         ; DrawTab(*tab, gWidth, gHeight, $FF808080)
      EndIf
   Next
   
   ; 2. отрисовка активной вкладки
   If *current_tab <> 0
      Protected tabcolor = GetGadgetColor(*current_tab\containerid, #PB_Gadget_BackColor)
      If tabcolor = -1 : tabcolor = RGB(255, 255, 255) : EndIf
      
      draw_tab(#True,*current_tab, *this\tab\size, tabcolor, *this\tab\plus\ID )
      ; DrawTab(*current_tab, gWidth, gHeight, $A00000FF)
   EndIf
   
   ; 2. Отрисовка кнопки ПЛЮС (вызываем её личную изолированную процедуру)
   draw_plusButton(*this, bgColor)
EndProcedure

Procedure ReDrawTabs(*this._s_WIDGET)
   Protected gWidth = DesktopScaledX(GadgetWidth(*this\canvasid))
   Protected gHeight = DesktopScaledY(GadgetHeight(*this\canvasid))
   Protected tabcolor.l 
   Protected bgColor.l
   Protected nonactivecolor.l
   
   If *this\bgcolor <> 0
      bgColor = *this\bgcolor
   Else
      bgColor = RGB(180, 195, 215)
   EndIf
   
   If StartDrawing(CanvasOutput(*this\canvasid))
      Box(0, 0, gWidth, gHeight, bgColor)
      DrawingFont(*this\fontid)
      
      DrawTabs(*this, *this\tab\active, gWidth, gHeight, bgColor)
      
      StopDrawing()
   EndIf
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
   
   ; 5. Полный адаптивный пересчет геометрии (Твой рабочий код)
   ResizeGadget(*this\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*this)
   ResizeGadget(*this\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; Подтягиваем размеры всех оставшихся контейнеров окон
   ForEach *this\tab\_s()
      ResizeGadget(*this\tab\_s()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   ; Перерисовываем очищенный холст
   ReDrawTabs(*this)
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
      If my >= *this\tab\plus\y And my <= *this\tab\plus\y + *this\tab\size
         If mx >= *this\tab\plus\x And mx <= *this\tab\plus\x + *this\tab\plus\width
            *hoveredtab = @*this\tab\plus
         EndIf
      EndIf
      
      ; 2. ТЕСТ ОБЫЧНЫХ ВКЛАДОК: Если мышь не над плюсом — делаем точный хит-тест трапеций
      If *hoveredtab = 0 And ListSize(*this\tab\_s()) > 0
         LastElement(*this\tab\_s())
         Repeat
            insidetab = #False
            If my >= *this\tab\_s()\y And my <= *this\tab\_s()\y + *this\tab\size
               If mx >= *this\tab\_s()\x And mx <= *this\tab\_s()\x + *this\tab\_s()\width
                  relx = mx - *this\tab\_s()\x
                  rely = my - *this\tab\_s()\y
                  If localslant > *this\tab\size: localslant = *this\tab\size: EndIf
                  
                  If relx < localslant
                     If relx >= localslant * (1.0 - (rely / *this\tab\size)) : insidetab = #True : EndIf
                  ElseIf relx > *this\tab\_s()\width - localslant
                     If relx <= *this\tab\_s()\width - (localslant * (1.0 - (rely / *this\tab\size))) : insidetab = #True : EndIf
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
            If my >= *hoveredtab\y + (*this\tab\size - h_12)/2 And my <= *hoveredtab\y + (*this\tab\size + h_12)/2 
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
            
            ; Полный адаптивный пересчет геометрии окна под новые размеры холста
            ResizeGadget(*this\canvasid, 0, 0, WindowWidth(WindowID), #PB_Ignore)
            Protected NewH = RecalculateTabs(*this)
            ResizeGadget(*this\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, NewH)
            
            ForEach *this\tab\_s()
               ResizeGadget(*this\tab\_s()\containerid, 0, NewH, WindowWidth(WindowID), WindowHeight(WindowID) - NewH)
            Next
            needredraw = #True
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
Procedure DoTabResize(*this._s_WIDGET, windowid)
   ResizeGadget(*this\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*this)
   ResizeGadget(*this\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; корректируем размеры всех контейнеров в зависимости от новой высоты холста
   ForEach *this\tab\_s()
      ResizeGadget(*this\tab\_s()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   ReDrawTabs(*this)
EndProcedure


;- --- демо запуск ---
Define event, windoww = 900, windowh = 350

If OpenWindow(0, 0, 0, windoww, windowh, "chrome tabs with container logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   
   With MyThis
      \canvasid  = CanvasGadget(#PB_Any, 0, 0, windoww, 40)
      \fontid    = LoadFont(0, "tahoma", 12)
      \tab\size = DesktopScaledY(29)
      \padding  = DesktopScaledX(6)
      ;\bgcolor     = rgb(random(255), random(255), random(255)) ; твой любимый цвет. сделай его зеленым или серым — и весь интерфейс сам перестроится!
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
; CursorPosition = 653
; FirstLine = 517
; Folding = ----8---------48------
; EnableXP
; DPIAware