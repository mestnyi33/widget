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
   ID.i             ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   
   ;height.l
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
    Plus._s_TAB ; <--- Одиночная структура кнопки ПЛЮС

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

Global tabbar._s_WIDGET
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

; добавление вкладки и автоматическое создание её контейнера под холстом
Procedure addcustomtab(*control._s_WIDGET, title$, windowid, canvasheight, imageid.i = 0, tabcolor.l=0)
   AddElement(*control\tab\_s())
   *control\tab\_s()\txt\text = title$
   *control\tab\_s()\img\image = imageid ; записываем id картинки
   If Not tabcolor
      tabcolor = RGB(Random(50)+200, Random(50)+200, Random(50)+200)
   EndIf
   
   ; создаем скрытый контейнер под размеры окна (ниже холста)
   ; внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
   *control\tab\_s()\containerid = ContainerGadget(#PB_Any, 0, canvasheight, WindowWidth(windowid), WindowHeight(windowid) - canvasheight, #PB_Container_BorderLess)
   ; для наглядности покрасим фоны контейнеров в разные случайные цвета
   SetGadgetColor(*control\tab\_s()\containerid, #PB_Gadget_BackColor, tabcolor)
   CloseGadgetList()
   
   
   ; самая первая вкладка становится активной
   If *control\tab\active = 0
      *control\tab\active = @*control\tab\_s()
      HideGadget(*control\tab\_s()\containerid, #False) ; показываем первый контейнер
   Else
      ; по умолчанию скрываем все контейнеры
      HideGadget(*control\tab\_s()\containerid, #True)
   EndIf
EndProcedure

; полностью адаптивная процедура рендеринга ретро-трапеции
Procedure drawoldchrometab(x, y, w, h, isactive, activecolor.l, nonactivecolor.l = -1, outerbordercolor.l = -1, innerhighlightcolor.l = -1)
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
      *rowtabs(i)\size = basewidth
      i + 1
    Next
    
    startidx = 0
    currentx = indent
    
    ; --- ОБЪЕДИНЕННЫЙ ЦИКЛ (Идем до tabcount включительно, чтобы обработать хвост) ---
    For i = 0 To tabcount
      Protected tabw = 0
      If i < tabcount
        tabw = *rowtabs(i)\size
      EndIf
      
      ; Условие срабатывает, если вкладка не влезает ИЛИ если это самый конец списка (i = tabcount)
      If (i = tabcount) Or (currentx + tabw > maxwidth And i > startidx)
        endidx = i - 1
        
        ; Растягиваем по ширине (Justify) ТОЛЬКО полные ряды. Последний «хвост» не трогаем!
        If i < tabcount
          totalrowwidth = indent + (slant * 2)
          For k = startidx To endidx
            totalrowwidth + *rowtabs(k)\size
            If k < endidx : totalrowwidth - SlantOffset : EndIf
          Next
          
          extraspace = maxwidth - totalrowwidth
          Protected tabsinrow = (endidx - startidx) + 1
          If extraspace > 0 And tabsinrow > 0
            addpixels = extraspace / tabsinrow
            remainder = extraspace % tabsinrow
            For k = startidx To endidx
              *rowtabs(k)\size + addpixels
              If remainder > 0
                *rowtabs(k)\size + 1
                remainder - 1
              EndIf
            Next
          EndIf
        EndIf
        
        ; ЕДИНЫЙ ЦИКЛ ЗАПИСИ КООРДИНАТ (Работает и для обычных рядов, и для хвоста)
        Protected tempx = indent
        For k = startidx To endidx
          *rowtabs(k)\pos = tempx
          *rowtabs(k)\ID = currentrow
          tempx + *rowtabs(k)\size - SlantOffset
       Next
        
        ; Подготовка к следующему ряду (если мы еще не дошли до финала)
        currentrow + 1
        currenty + RowStep
        currentx = indent
        startidx = i
      EndIf
      
      ; Накапливаем ширину, пока не вышли за границы списка
      If i < tabcount
        currentx + *rowtabs(i)\size - SlantOffset
      EndIf
    Next
    
    Protected TotalRows = currentrow - 1
    
    ; --- ИНВЕРСИЯ РЯДОВ ---
    For k = 0 To tabcount - 1
      Protected InvertedRow = TotalRows - *rowtabs(k)\ID
      *rowtabs(k)\y = TopSpacing + InvertedRow * RowStep
    Next
    
    ; --- КОРРЕКТИРОВКА ПЛЮСА И ФИНАЛЬНЫЙ РАСЧЕТ ВЫСОТЫ ---
    *control\tab\plus\size = (slant * 2)
   *control\tab\plus\y = TopSpacing + TotalRows * RowStep
    *control\tab\plus\pos = canvasw - *control\tab\plus\size - indent
    
    maxheight = *control\tab\plus\y + *control\tab\size
    
    StopDrawing()
  EndIf
  
  ProcedureReturn DesktopUnscaledY(maxheight + BottonSpacing)
EndProcedure

Procedure draw_closeButton(*tab._s_TAB , h)
   Protected h_8 = DesktopScaledX(8)
   ; --- рисуем крестик для активной вкладки (справа) ---
   Protected closex = *tab\pos + *tab\size - slant - DesktopScaledX(14)
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

Procedure draw_plusButton(*control._s_WIDGET, bgcolor.l)
   ; Высчитываем цвет точно так же, как для неактивного таба
   Protected.l nabaser = Red(bgcolor) + 15
   Protected.l nabaseg = Green(bgcolor) + 10
   Protected.l nabaseb = Blue(bgcolor) + 10
   
   If *control\tab\plus\ishovered 
      nabaser + 30 : nabaseg + 30 : nabaseb + 30 
   EndIf
   If nabaser > 255 : nabaser = 255 : EndIf 
   If nabaseg > 255 : nabaseg = 255 : EndIf 
   If nabaseb > 255 : nabaseb = 255 : EndIf
   Protected.l pluscolor = RGB(nabaser, nabaseg, nabaseb)
   
   ; Трюк со Slant: подменяем его локально только на время отрисовки этой кнопки
   Protected OldSlant = Slant : Slant = 8
   drawoldchrometab(*control\tab\plus\pos, *control\tab\plus\y, *control\tab\plus\size, *control\tab\size, 0, 0, pluscolor)
   Slant = OldSlant ; Сразу возвращаем обратно
   
   ; Выводим символ "+" ровно по центру
   Protected textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
   Protected textBgcolor = RGB(nabaser - 5, nabaseg - 4, nabaseb - 4)
   Protected plus_x = *control\tab\plus\pos + (*control\tab\plus\size - TextWidth("+")) / 2
   
   DrawText(plus_x, *control\tab\plus\y + 6, "+", textcolor, textBgcolor)
EndProcedure

Procedure draw_tab(isactive, *tab._s_TAB, h, bgcolor.l, max_row_index.i = -1)
   Protected.l textcolor, nonactivecolor, textBgcolor
   If isactive
      textcolor = RGB(0, 0, 0)
      textBgcolor = bgcolor
      If *tab\ID = max_row_index
         drawoldchrometab(*tab\pos, *tab\y, *tab\size, h + BottonSpacing, 1, bgcolor)
      Else
         drawoldchrometab(*tab\pos, *tab\y, *tab\size, h,  -1, bgcolor)
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
      
      drawoldchrometab(*tab\pos, *tab\y, *tab\size, h, 0, 0, nonactivecolor)
      
      textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
      
      textBgcolor = RGB(nabaser - (25 * 0.2), nabaseg - (20 * 0.2), nabaseb - (20 * 0.2))
   EndIf
   
   Protected txtw = TextWidth(*tab\txt\text)
   Protected contentw = txtw + 16
   If *tab\img\image <> 0 : contentw + 20 : EndIf
   
   Protected startx = *tab\pos + (*tab\size - contentw) / 2
   
   If *tab\img\image <> 0
      Protected icony = *tab\y + (h - 16) / 2
      DrawImage(ImageID(*tab\img\image), startx, icony, 16, 16)
      startx + 20
   EndIf
   
   DrawText(startx, *tab\y + 6, *tab\txt\text, textcolor, textBgcolor)
   
   draw_closeButton( *tab, h )
EndProcedure

Procedure DrawTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b, isDragged.b, isResize.b=0)
   Protected contentX.i, contentY.i, contentW.i, contentH.i
   Protected txt_X.i, txt_Y.i, txt_W.i, txt_H.i
   Protected img_X.i, img_Y.i, img_W.i, img_H.i
   Protected rx.i, rw.i 
   Protected ry.i, rh.i
   Protected txt_change = *tab\txt\change 
   Protected img_change = *tab\img\change
   
   ; UPDATE ROW
   If txt_change Or img_change Or isResize
      Protected padding.i = DesktopScaledX(8)
      Protected iconSpacing.i = 0
      
      ; 1. Замеры метрик
      If txt_change
         If *tab\txt\Text <> ""
            txt_w = TextWidth(*tab\txt\Text)
            txt_h = TextHeight(*tab\txt\Text)
         Else
            txt_w = 0 : txt_h = 0
         EndIf
      EndIf
      
      If img_change
         If IsImage(*tab\img\Image)
            img_w = ImageWidth(*tab\img\Image)
            img_h = ImageHeight(*tab\img\Image)
         Else
            img_w = 0 : img_h = 0
         EndIf
      EndIf
      
      ; Расчет отступа, если присутствуют оба элемента
      If (img_w Or img_h) And 
         (txt_w Or txt_h)
         iconSpacing = DesktopScaledX(6)
      EndIf
      
      ; 2. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА
      If vertical
         ; Вертикальный режим: складываем высоты, по ширине берем максимум
         contentH = img_h + txt_h + iconSpacing
         If img_w > txt_w
            contentW = img_w
         Else
            contentW = txt_w
         EndIf
         contentY = GetAlignPosition(*tab\align, *tab\size, contentH, padding)
      Else
         ; Горизонтальный режим: складываем ширину, по высоте берем максимум
         contentW = img_w + txt_w + iconSpacing
         If img_h > txt_h
            contentH = img_h
         Else
            contentH = txt_h
         EndIf
         contentX = GetAlignPosition(*tab\align, *tab\size, contentW, padding)
      EndIf
      
      ; 3. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ
      If txt_change Or isResize
         If vertical
            txt_x = (gWidth - txt_w) >> 1
            If *tab\align & #__flag_Bottom
               txt_y = contentY
            Else
               txt_y = contentY + img_h
               If img_h : txt_y + iconSpacing : EndIf
            EndIf
         Else
            txt_y = (gHeight - txt_h) >> 1
            If *tab\align & #__flag_Right
               txt_x = contentX
            Else
               txt_x = contentX + img_w
               If img_w : txt_x + iconSpacing : EndIf
            EndIf
         EndIf
      EndIf
      
      If img_change Or isResize
         If vertical
            img_x = (gWidth - img_w) >> 1
            If *tab\align & #__flag_Bottom
               img_y = contentY + txt_h
               If txt_h : img_y + iconSpacing : EndIf
            Else
               img_y = contentY
            EndIf
         Else
            img_y = (gHeight - img_h) >> 1
            If *tab\align & #__flag_Right
               img_x = contentX + txt_w
               If txt_w : img_x + iconSpacing : EndIf
            Else
               img_x = contentX
            EndIf
         EndIf
      EndIf
      
      If img_change
         *tab\img\x = img_x
         *tab\img\y = img_y
         *tab\img\width = img_w
         *tab\img\height = img_h
         *tab\img\change = #False
      EndIf
      
      If txt_change
         *tab\txt\x = txt_x
         *tab\txt\y = txt_y
         *tab\txt\width = txt_w
         *tab\txt\height = txt_h
         *tab\txt\change = #False
      EndIf
    Else
      img_x = *tab\img\x 
      img_y = *tab\img\y
      img_w = *tab\img\width
      img_h = *tab\img\height
      
      txt_x = *tab\txt\x 
      txt_y = *tab\txt\y
      txt_w = *tab\txt\width
      txt_h = *tab\txt\height
   EndIf
   
   ;
   If vertical
      rx = 0
      ry = *tab\pos + *tab\offset
      rw = gWidth
      rh = *tab\size
   Else
      rx = *tab\pos + *tab\offset
      ry = 0
      rw = *tab\size
      rh = gHeight
   EndIf
   
   ; DRAW ROW
   ; 1. ОТРИСОВКА ФОНА
   If isDragged
      Box(rx, ry, rw, rh, $A00000FF)
   Else
      Box(rx, ry, rw, rh, $FF808080)
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ
   If img_w Or img_h
      DrawAlphaImage(ImageID(*tab\img\Image), rx + img_x, ry + img_y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Text <> ""
      DrawText(rx + txt_x, ry + txt_y, *tab\txt\Text, $FFFFFFFF)
   EndIf
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB, gWidth, gHeight)
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   
   ; Слой 1: Статичные
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      If *tab <> *current_tab
         DrawTab(*tab, gWidth, gHeight, vertical, #False)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *current_tab
      DrawTab(*current_tab, gWidth, gHeight, vertical, #True)
   EndIf
EndProcedure

Procedure redrawtabs(*control._s_WIDGET)
   Protected canvasw = DesktopScaledX(GadgetWidth(*control\canvasid))
   Protected canvash = DesktopScaledY(GadgetHeight(*control\canvasid))
   Protected tabcolor.l 
   Protected canvasbgcolor.l
   Protected nonactivecolor.l
   
   If *control\bgcolor <> 0
      canvasbgcolor = *control\bgcolor
   Else
      canvasbgcolor = RGB(180, 195, 215)
   EndIf
   
   If StartDrawing(CanvasOutput(*control\canvasid))
      Box(0, 0, canvasw, canvash, canvasbgcolor)
      DrawingFont(*control\fontid)
      
      ; линия пола
      Protected floorcolor = RGB(Red(canvasbgcolor) * 0.7, Green(canvasbgcolor) * 0.7, Blue(canvasbgcolor) * 0.7)
      LineXY(0, canvash - 1, canvasw, canvash - 1, floorcolor)
      
      ; 1. отрисовка неактивных вкладок
      ForEach *control\tab\_s()
         If @*control\tab\_s() <> *control\tab\active
            draw_tab(#False, @*control\tab\_s(),*control\tab\size, canvasbgcolor, *control\tab\plus\ID )
         EndIf
      Next
      
      ; 2. отрисовка активной вкладки
      If *control\tab\active <> 0
         tabcolor = GetGadgetColor(*control\tab\active\containerid, #PB_Gadget_BackColor)
         If tabcolor = -1 : tabcolor = RGB(255, 255, 255) : EndIf
         
         draw_tab(#True,*control\tab\active, *control\tab\size, tabcolor, *control\tab\plus\ID )
      EndIf
      
      ; 2. Отрисовка кнопки ПЛЮС (вызываем её личную изолированную процедуру)
      draw_plusButton(*control, canvasbgcolor)
      
      StopDrawing()
   EndIf
EndProcedure

Procedure CloseTab(*control._s_WIDGET, *tabtoclose._s_TAB, windowid.i)
   ; 1. Переводим список на удаляемую вкладку
   ChangeCurrentElement(*control\tab\_s(), *tabtoclose)
   
   ; 2. Уничтожаем привязанный containergadget
   If IsGadget(*tabtoclose\containerid)
      FreeGadget(*tabtoclose\containerid)
   EndIf
   
   ; 3. УДАЛЕНИЕ И АВТОМАТИЧЕСКИЙ ПОИСК ЗАМЕНЫ
   If *control\tab\active = *tabtoclose
      ; Флаг 1 заставляет PureBasic перешагнуть на следующую вкладку (или на предыдущую, если этой не стало)
      If DeleteElement(*control\tab\_s(), 1)
         *control\tab\active = @*control\tab\_s() ; Новая вкладка успешно подхвачена!
      Else
         *control\tab\active = 0 ; Вкладок больше вообще не осталось
      EndIf
   Else
      ; Если закрыли неактивную вкладку, просто удаляем её без смены активности
      DeleteElement(*control\tab\_s())
   EndIf
   
   ; 4. Если нашли новый активный таб — показываем его контейнер
   If *control\tab\active <> 0
      HideGadget(*control\tab\active\containerid, #False)
   EndIf
   
   ; 5. Полный адаптивный пересчет геометрии (Твой рабочий код)
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*control)
   ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; Подтягиваем размеры всех оставшихся контейнеров окон
   ForEach *control\tab\_s()
      ResizeGadget(*control\tab\_s()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   ; Перерисовываем очищенный холст
   redrawtabs(*control)
EndProcedure

Procedure ActivateTab(*Control._s_WIDGET, *Newactive._s_TAB)
   If *Control\tab\active <> *Newactive
      ; Прячем старый контейнер
      If *Control\tab\active
         HideGadget(*Control\tab\active\ContainerID, #True)
      EndIf
      
      ; Переключаем простой указатель
      *Control\tab\active = *Newactive
      
      ; Показываем новый контейнер
      HideGadget(*Control\tab\active\ContainerID, #False)
      
      ; Перерисовываем холст — ховеры автоматически окажутся на своих местах!
      redrawtabs(*control)
   EndIf
EndProcedure

Procedure DoTabEvents(*control._s_WIDGET)
   Protected mx = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseX)
   Protected my = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseY)
   Protected localslant = slant
   Protected insidetab.i, relx.i, rely.i
   Protected *hoveredtab._s_TAB = 0
   Protected needredraw.i = #False
   Protected etype = EventType()
   Protected WindowID = EventWindow()
   
   If etype = #PB_EventType_MouseMove Or etype = #PB_EventType_LeftButtonDown
      
      ; 1. ТЕСТ КНОПКИ ПЛЮС (+): Так как она закреплена справа над контейнером, проверяем её первой
      If my >= *control\tab\plus\y And my <= *control\tab\plus\y + *control\tab\size
         If mx >= *control\tab\plus\pos And mx <= *control\tab\plus\pos + *control\tab\plus\size
            *hoveredtab = @*control\tab\plus
         EndIf
      EndIf
      
      ; 2. ТЕСТ ОБЫЧНЫХ ВКЛАДОК: Если мышь не над плюсом — делаем точный хит-тест трапеций
      If *hoveredtab = 0 And ListSize(*control\tab\_s()) > 0
         LastElement(*control\tab\_s())
         Repeat
            insidetab = #False
            If my >= *control\tab\_s()\y And my <= *control\tab\_s()\y + *control\tab\size
               If mx >= *control\tab\_s()\pos And mx <= *control\tab\_s()\pos + *control\tab\_s()\size
                  relx = mx - *control\tab\_s()\pos
                  rely = my - *control\tab\_s()\y
                  If localslant > *control\tab\size: localslant = *control\tab\size: EndIf
                  
                  If relx < localslant
                     If relx >= localslant * (1.0 - (rely / *control\tab\size)) : insidetab = #True : EndIf
                  ElseIf relx > *control\tab\_s()\size - localslant
                     If relx <= *control\tab\_s()\size - (localslant * (1.0 - (rely / *control\tab\size))) : insidetab = #True : EndIf
                  Else
                     insidetab = #True
                  EndIf
               EndIf
            EndIf
            
            If insidetab
               *hoveredtab = @*control\tab\_s()
               Break 
            EndIf
         Until PreviousElement(*control\tab\_s()) = 0
      EndIf
      
      ; 3. Вычисляем флаг наведения на крестик закрытия (только для обычных вкладок)
      Protected ShouldCloseHover.a = 0
      Protected h_12 = DesktopScaledX(12)
      Protected h_2 = DesktopScaledX(2)
      If *hoveredtab <> 0 And *hoveredtab <> *control\tab\plus
         Protected closex = *hoveredtab\pos + *hoveredtab\size - localslant - DesktopScaledX(14)
         If mx >= closex - h_2 And mx <= closex + h_12 - h_2
            If my >= *hoveredtab\y + (*control\tab\size - h_12)/2 And my <= *hoveredtab\y + (*control\tab\size + h_12)/2 
               ShouldCloseHover = 1
            EndIf 
         EndIf 
      EndIf
      
      ; --- 4. ЛОГИКА КЛИКА МЫШИ ---
      If etype = #PB_EventType_LeftButtonDown And *hoveredtab <> 0
         If *hoveredtab = *control\tab\plus
            ; КЛИК ПО ПЛЮСУ: Добавляем новую вкладку
            Protected NewIdx = ListSize(*control\tab\_s()) + 1
            AddCustomTab(*control, "Вкладка " + Str(NewIdx), WindowID, GadgetHeight(*control\canvasid))
            
            ; Полный адаптивный пересчет геометрии окна под новые размеры холста
            ResizeGadget(*control\canvasid, 0, 0, WindowWidth(WindowID), #PB_Ignore)
            Protected NewH = RecalculateTabs(*control)
            ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, NewH)
            
            ForEach *control\tab\_s()
               ResizeGadget(*control\tab\_s()\containerid, 0, NewH, WindowWidth(WindowID), WindowHeight(WindowID) - NewH)
            Next
            needredraw = #True
         Else
            ; КЛИК ПО ОБЫЧНОМУ ТАБУ: Проверяем крестик или переключаем активность
            If *hoveredtab\close_ishovered
               CloseTab(*control, *hoveredtab, WindowID)
            Else
               ActivateTab(*control, *hoveredtab)
            EndIf
         EndIf
         
         ; --- 5. ЛОГИКА ДВИЖЕНИЯ МЫШИ (Ховеры) ---
      ElseIf etype = #PB_EventType_MouseMove
         ; Защищенный ховер кнопки ПЛЮС
         Protected TargetPlusHover = 0
         If *hoveredtab = @*control\tab\plus
            TargetPlusHover = 1
         EndIf
         
         If *control\tab\plus\ishovered <> TargetPlusHover
            *control\tab\plus\ishovered = TargetPlusHover
            needredraw = #True
         EndIf
         
         ; Синхронный ховер всех обычных вкладок и их крестиков
         ForEach *control\tab\_s()
            Protected TargetHover = 0
            Protected TargetCloseHover = 0
            
            If @*control\tab\_s() = *control\tab\active
               TargetHover = 0
               If @*control\tab\_s() = *hoveredtab
                  TargetCloseHover = ShouldCloseHover
               EndIf
            Else
               If @*control\tab\_s() = *hoveredtab
                  TargetHover = 1
                  TargetCloseHover = ShouldCloseHover
               EndIf
            EndIf
            
            If *control\tab\_s()\ishovered <> TargetHover
               *control\tab\_s()\ishovered = TargetHover
               needredraw = #True
            EndIf
            
            If *control\tab\_s()\close_ishovered <> TargetCloseHover
               *control\tab\_s()\close_ishovered = TargetCloseHover
               needredraw = #True
            EndIf
         Next
      EndIf
      
      If needredraw
         redrawtabs(*control)
      EndIf
      
      ; --- 6. КУРСОР УШЕЛ С ХОЛСТА (Тотальный сброс подсветки) ---
   ElseIf etype = #PB_EventType_MouseLeave
      *control\tab\plus\ishovered = 0
      ForEach *control\tab\_s()
         If *control\tab\_s()\ishovered <> 0
            *control\tab\_s()\ishovered = 0
            needredraw = #True
         EndIf
         If *control\tab\_s()\close_ishovered <> 0
            *control\tab\_s()\close_ishovered = 0
            needredraw = #True
         EndIf
      Next
      If needredraw
         redrawtabs(*control)
      EndIf
   EndIf
EndProcedure

; обновление размеров холста и всех контейнеров под размеры окна
Procedure resizetabcontrol(*control._s_WIDGET, windowid)
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*control)
   ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; корректируем размеры всех контейнеров в зависимости от новой высоты холста
   ForEach *control\tab\_s()
      ResizeGadget(*control\tab\_s()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   redrawtabs(*control)
EndProcedure


;- --- демо запуск ---
Define event, windoww = 900, windowh = 350, realcanvasheight

If OpenWindow(0, 0, 0, windoww, windowh, "chrome tabs with container logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   
   With tabbar
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
   addcustomtab(tabbar, "google (с иконкой)", 0, 40, 1, RGB(255, 255, 255))
   addcustomtab(tabbar, "код проекта (с иконкой)", 0, 40, 2, RGB(210, 245, 225))
   addcustomtab(tabbar, "без иконки", 0, 40, 0, RGB(255, 220, 230))
   ; добавляем вкладки, передавая id окна и начальную высоту холста
   addcustomtab(tabbar, "вкладка 1", 0, 40)
   ;addcustomtab(tabbar, "вкладка с длинным текстом 2", 0, 40)
   addcustomtab(tabbar, "опции 3", 0, 40)
   addcustomtab(tabbar, "система 4", 0, 40)
   addcustomtab(tabbar, "логи работы 5", 0, 40)
   ;   
   ; настраиваем начальные размеры всего интерфейса
   resizetabcontrol(tabbar, 0)
   
   ; наполним первый и второй контейнер чем-нибудь для теста
   ; для этого временно переключаемся на нужный контейнер через opengadgetlist
   SelectElement(tabbar\tab\_s(), 0)
   OpenGadgetList(tabbar\tab\_s()\containerid)
   ButtonGadget(#PB_Any, 20, 20, 150, 30, "кнопка на вкладке 1")
   StringGadget(#PB_Any, 20, 60, 200, 25, "текст на вкладке 1")
   CloseGadgetList()
   
   SelectElement(tabbar\tab\_s(), 1)
   OpenGadgetList(tabbar\tab\_s()\containerid)
   CheckBoxGadget(#PB_Any, 20, 20, 200, 20, "галочка на второй вкладке")
   CloseGadgetList()
   
   Repeat
      event = WaitWindowEvent()
      Select event
         Case #PB_Event_Gadget
            If EventGadget() = tabbar\canvasid
               DoTabEvents(tabbar)
            EndIf
            
         Case #PB_Event_SizeWindow
            ; вызываем единую процедуру ресайза для холста и дочерних контейнеров
            resizetabcontrol(tabbar, 0)
            
         Case #PB_Event_CloseWindow
            End
      EndSelect
   ForEver
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 14
; Folding = ----------------------
; EnableXP
; DPIAware