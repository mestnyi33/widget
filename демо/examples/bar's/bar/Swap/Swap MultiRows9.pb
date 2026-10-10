EnableExplicit

; структура вкладки (с суффиксом $ и типами .i)
Structure customtab
   title$       
   x            .i  
   y            .i
   width        .i
   height       .i
   row          .i
   containerid  .i ; id контейнера, привязанного к этой вкладке
   imageid      .i ; <--- добавляем id иконки purebasic (если 0 — вкладка без иконки)
   ishovered    .a ; флаг наведения мыши (0 или 1)
   close_ishovered.a
EndStructure

; структура контрола
Structure multirowtabcontrol
   canvasid     .i  
   fontid       .i  
   *active   .customtab 
   bgcolor      .l ; <--- добавь это поле для управления общим фоном холста
   tabheight    .i
   paddingx     .i
   PlusTab      .CustomTab ; <--- Одиночная структура кнопки ПЛЮС
   List tabs    .customtab()
EndStructure

Global tabbar.multirowtabcontrol
Global slant = DesktopScaledX(20)
Global TopSpacing = DesktopScaledX(6)
Global RowSpacing = DesktopScaledX(2)
Global BottonSpacing = RowSpacing
   
; добавление вкладки и автоматическое создание её контейнера под холстом
Procedure addcustomtab(*control.multirowtabcontrol, title$, windowid, canvasheight, imageid.i = 0, tabcolor.l=0)
   AddElement(*control\tabs())
   *control\tabs()\title$ = title$
   *control\tabs()\imageid = imageid ; записываем id картинки
   If Not tabcolor
      tabcolor = RGB(Random(50)+200, Random(50)+200, Random(50)+200)
   EndIf
   
   ; создаем скрытый контейнер под размеры окна (ниже холста)
   ; внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
   *control\tabs()\containerid = ContainerGadget(#PB_Any, 0, canvasheight, WindowWidth(windowid), WindowHeight(windowid) - canvasheight, #PB_Container_BorderLess)
   ; для наглядности покрасим фоны контейнеров в разные случайные цвета
   SetGadgetColor(*control\tabs()\containerid, #PB_Gadget_BackColor, tabcolor)
   CloseGadgetList()
   
   
   ; самая первая вкладка становится активной
   If *control\active = 0
      *control\active = @*control\tabs()
      HideGadget(*control\tabs()\containerid, #False) ; показываем первый контейнер
   Else
      ; по умолчанию скрываем все контейнеры
      HideGadget(*control\tabs()\containerid, #True)
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

Procedure.i RecalculateTabs(*control.multirowtabcontrol)
   Protected canvasw = DesktopScaledX(GadgetWidth(*control\canvasid))
   Protected currentx = DesktopScaledX(4)
   Protected currenty = TopSpacing
   Protected currentrow = 0
   Protected maxheight = 0
   Protected maxwidth = canvasw - DesktopScaledX(4)
   Protected i.i, k.i, startidx.i, endidx.i
   Protected totalrowwidth.i, extraspace.i, addpixels.i, remainder.i
   Protected tabcount = ListSize(*control\tabs())
   
   If tabcount = 0 : ProcedureReturn DesktopUnscaledY(*control\tabheight + BottonSpacing) : EndIf
   
   If StartDrawing(CanvasOutput(*control\canvasid))
      DrawingFont(*control\fontid)
      
      Dim *rowtabs.customtab(tabcount - 1)
      i = 0
      ForEach *control\tabs()
         *rowtabs(i) = @*control\tabs()
         *rowtabs(i)\height = *control\tabheight
         
         Protected basewidth = TextWidth(*rowtabs(i)\title$) + (*control\paddingx * 2) + (slant * 2)
         If *rowtabs(i)\imageid <> 0
            basewidth + DesktopScaledX(20)
         EndIf
         basewidth + DesktopScaledX(16) 
         *rowtabs(i)\width = basewidth
         i + 1
      Next
      
      startidx = 0
      currentx = DesktopScaledX(4)
      
      For i = 0 To tabcount - 1
         Protected tabw = *rowtabs(i)\width
         
         If currentx + tabw > maxwidth And i > startidx
            endidx = i - 1 
            
            totalrowwidth = DesktopScaledX(4)
            For k = startidx To endidx
               totalrowwidth + *rowtabs(k)\width
               If k < endidx : totalrowwidth - (slant * 4 / 3) : EndIf
            Next
            
            extraspace = (maxwidth) - totalrowwidth
            
            Protected tabsinrow = (endidx - startidx) + 1
            If extraspace > 0 And tabsinrow > 0
               addpixels = extraspace / tabsinrow
               remainder = extraspace % tabsinrow
               
               For k = startidx To endidx
                  *rowtabs(k)\width + addpixels
                  If remainder > 0
                     *rowtabs(k)\width + DesktopScaledX(1)
                     remainder - 1
                  EndIf
               Next
            EndIf
            
            Protected tempx = DesktopScaledX(4)
            For k = startidx To endidx
               *rowtabs(k)\x = tempx
               ; Временно пишем дефолтный Y, в конце мы его перевернем
               *rowtabs(k)\y = currenty
               *rowtabs(k)\row = currentrow
               
               tempx + *rowtabs(k)\width - (slant * 4 / 3)
            Next
            
            currentrow + 1
            currenty + (*control\tabheight + RowSpacing);-DesktopScaledX(1))
            currentx = DesktopScaledX(4)
            startidx = i 
         EndIf
         
         currentx + *rowtabs(i)\width - (slant * 4 / 3)
      Next
      
      ; Последний ряд (в который упал неполный хвост)
      currentx = DesktopScaledX(4)
      For k = startidx To tabcount - 1
         *rowtabs(k)\x = currentx
         *rowtabs(k)\y = currenty
         *rowtabs(k)\row = currentrow
         currentx + *rowtabs(k)\width - (slant * 4 / 3)
      Next
      
      ; --- ИДЕАЛЬНОЕ И ПРОСТОЕ ИСПРАВЛЕНИЕ: ПЕРЕВОРАЧИВАЕМ ЭТАЖИ ---
      ; Общее количество созданных рядов равно currentrow
      Protected TotalRows = currentrow
      
      ; Проходим по всем рассчитанным табам и инвертируем их координаты Y
      For k = 0 To tabcount - 1
         ; Финальный номер строки (теперь ряд 0 станет верхним, а последний - нижним)
         Protected InvertedRow = TotalRows - *rowtabs(k)\row
         
         ; Вычисляем чистый Y на основе инвертированного ряда
         *rowtabs(k)\y = TopSpacing + InvertedRow * (*control\tabheight + RowSpacing);-DesktopScaledX(1))
         *rowtabs(k)\row = InvertedRow
         
         ; Считаем maxheight на основе новых, правильных координат Y
         If maxheight < *rowtabs(k)\y + *rowtabs(k)\height  
            maxheight = *rowtabs(k)\y + *rowtabs(k)\height
         EndIf
      Next
      
      ; --- КОРРЕКТИРОВКА ПЛЮСА ---
      ; Кнопка Плюс теперь гарантированно получает координаты самого НИЖНЕГО этажа (TotalRows)
      *control\PlusTab\width = (slant * 2) 
      *control\PlusTab\height = *control\tabheight
      *control\PlusTab\y = TopSpacing + TotalRows * (*control\tabheight + RowSpacing);-DesktopScaledX(1))
      *control\PlusTab\x = canvasw - *control\PlusTab\width - DesktopScaledX(4)
      *control\PlusTab\row = TotalRows
      
      If maxheight < *control\PlusTab\y + *control\PlusTab\height
         maxheight = *control\PlusTab\y + *control\PlusTab\height
      EndIf
      
      StopDrawing()
   EndIf
   
   ProcedureReturn DesktopUnscaledY(maxheight + BottonSpacing)
EndProcedure

Procedure draw_closeButton(*tab.customtab )
   Protected h_8 = DesktopScaledX(8)
   ; --- рисуем крестик для активной вкладки (справа) ---
   Protected closex = *tab\x + *tab\width - slant - DesktopScaledX(14)
   Protected closey = *tab\y + (*tab\height - h_8) / 2
   If *tab\close_ishovered 
      Circle(closex + h_8/2, closey + h_8/2, DesktopScaledX(7), RGB(240, 70, 70)) 
      LineXY(closex, closey, closex + h_8, closey + h_8, RGB(255, 255, 255)) 
      LineXY(closex + h_8, closey, closex, closey + h_8, RGB(255, 255, 255)) 
   Else 
      LineXY(closex, closey, closex + h_8, closey + h_8, RGB(160, 50, 50)) 
      LineXY(closex + h_8, closey, closex, closey + h_8, RGB(160, 50, 50)) 
   EndIf
EndProcedure

Procedure draw_plusButton(*control.multirowtabcontrol, bgcolor.l)
   ; Высчитываем цвет точно так же, как для неактивного таба
   Protected.l nabaser = Red(bgcolor) + 15
   Protected.l nabaseg = Green(bgcolor) + 10
   Protected.l nabaseb = Blue(bgcolor) + 10
   
   If *control\PlusTab\ishovered 
      nabaser + 30 : nabaseg + 30 : nabaseb + 30 
   EndIf
   If nabaser > 255 : nabaser = 255 : EndIf 
   If nabaseg > 255 : nabaseg = 255 : EndIf 
   If nabaseb > 255 : nabaseb = 255 : EndIf
   Protected.l pluscolor = RGB(nabaser, nabaseg, nabaseb)
   
   ; Трюк со Slant: подменяем его локально только на время отрисовки этой кнопки
   Protected OldSlant = Slant : Slant = 8
   drawoldchrometab(*control\PlusTab\x, *control\PlusTab\y, *control\PlusTab\width, *control\PlusTab\height, 0, 0, pluscolor)
   Slant = OldSlant ; Сразу возвращаем обратно
   
   ; Выводим символ "+" ровно по центру
   Protected textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
   Protected textBgcolor = RGB(nabaser - 5, nabaseg - 4, nabaseb - 4)
   Protected plus_x = *control\PlusTab\x + (*control\PlusTab\width - TextWidth("+")) / 2
   
   DrawText(plus_x, *control\PlusTab\y + 6, "+", textcolor, textBgcolor)
EndProcedure

Procedure draw_tab(isactive, *tab.customtab, bgcolor.l, max_row_index.i = -1)
   Protected.l textcolor, nonactivecolor, textBgcolor
   If isactive
      textcolor = RGB(0, 0, 0)
      textBgcolor = bgcolor
      If *tab\row = max_row_index
         drawoldchrometab(*tab\x, *tab\y, *tab\width, *tab\height + BottonSpacing, 1, bgcolor)
      Else
         drawoldchrometab(*tab\x, *tab\y, *tab\width, *tab\height, -1, bgcolor)
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
      
      drawoldchrometab(*tab\x, *tab\y, *tab\width, *tab\height, 0, 0, nonactivecolor)
      
      textcolor = RGB(Red(bgcolor) * 0.3, Green(bgcolor) * 0.3, Blue(bgcolor) * 0.3)
      
      textBgcolor = RGB(nabaser - (25 * 0.2), nabaseg - (20 * 0.2), nabaseb - (20 * 0.2))
   EndIf
   
   Protected txtw = TextWidth(*tab\title$)
   Protected contentw = txtw + 16
   If *tab\imageid <> 0 : contentw + 20 : EndIf
   
   Protected startx = *tab\x + (*tab\width - contentw) / 2
   
   If *tab\imageid <> 0
      Protected icony = *tab\y + (*tab\height - 16) / 2
      DrawImage(ImageID(*tab\imageid), startx, icony, 16, 16)
      startx + 20
   EndIf
   
   DrawText(startx, *tab\y + 6, *tab\title$, textcolor, textBgcolor)
   
   draw_closeButton( *tab )
EndProcedure

Procedure redrawtabs(*control.multirowtabcontrol)
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
      ForEach *control\tabs()
         If @*control\tabs() <> *control\active
             draw_tab(#False, @*control\tabs(), canvasbgcolor, *control\PlusTab\row )
         EndIf
      Next
      
      ; 2. Отрисовка кнопки ПЛЮС (вызываем её личную изолированную процедуру)
      draw_plusButton(*control, canvasbgcolor)
      
      ; 2. отрисовка активной вкладки
      If *control\active <> 0
         tabcolor = GetGadgetColor(*control\active\containerid, #PB_Gadget_BackColor)
         If tabcolor = -1 : tabcolor = RGB(255, 255, 255) : EndIf
         
         draw_tab(#True,*control\active, tabcolor, *control\PlusTab\row )
      EndIf
      
      StopDrawing()
   EndIf
EndProcedure

Procedure CloseTab(*control.multirowtabcontrol, *tabtoclose.customtab, windowid.i)
   ; 1. Переводим список на удаляемую вкладку
   ChangeCurrentElement(*control\tabs(), *tabtoclose)
   
   ; 2. Уничтожаем привязанный containergadget
   If IsGadget(*tabtoclose\containerid)
      FreeGadget(*tabtoclose\containerid)
   EndIf
   
   ; 3. УДАЛЕНИЕ И АВТОМАТИЧЕСКИЙ ПОИСК ЗАМЕНЫ
   If *control\active = *tabtoclose
      ; Флаг 1 заставляет PureBasic перешагнуть на следующую вкладку (или на предыдущую, если этой не стало)
      If DeleteElement(*control\tabs(), 1)
         *control\active = @*control\tabs() ; Новая вкладка успешно подхвачена!
      Else
         *control\active = 0 ; Вкладок больше вообще не осталось
      EndIf
   Else
      ; Если закрыли неактивную вкладку, просто удаляем её без смены активности
      DeleteElement(*control\tabs())
   EndIf
   
   ; 4. Если нашли новый активный таб — показываем его контейнер
   If *control\active <> 0
      HideGadget(*control\active\containerid, #False)
   EndIf
   
   ; 5. Полный адаптивный пересчет геометрии (Твой рабочий код)
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*control)
   ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; Подтягиваем размеры всех оставшихся контейнеров окон
   ForEach *control\tabs()
      ResizeGadget(*control\tabs()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   ; Перерисовываем очищенный холст
   redrawtabs(*control)
EndProcedure

Procedure ActivateTab(*Control.MultiRowTabControl, *Newactive.CustomTab)
  If *Control\active <> *Newactive
    ; Прячем старый контейнер
    If *Control\active
      HideGadget(*Control\active\ContainerID, #True)
    EndIf
    
    ; Переключаем простой указатель
    *Control\active = *Newactive
    
    ; Показываем новый контейнер
    HideGadget(*Control\active\ContainerID, #False)
    
    ; Перерисовываем холст — ховеры автоматически окажутся на своих местах!
    redrawtabs(*control)
  EndIf
EndProcedure

Procedure DoTabEvents(*control.multirowtabcontrol)
   Protected mx = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseX)
   Protected my = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseY)
   Protected localslant = slant
   Protected insidetab.i, relx.i, rely.i
   Protected *hoveredtab.customtab = 0
   Protected needredraw.i = #False
   Protected etype = EventType()
   Protected WindowID = EventWindow()
   
   If etype = #PB_EventType_MouseMove Or etype = #PB_EventType_LeftButtonDown
      
      ; 1. ТЕСТ КНОПКИ ПЛЮС (+): Так как она закреплена справа над контейнером, проверяем её первой
      If my >= *control\PlusTab\y And my <= *control\PlusTab\y + *control\PlusTab\height
         If mx >= *control\PlusTab\x And mx <= *control\PlusTab\x + *control\PlusTab\width
            *hoveredtab = @*control\PlusTab
         EndIf
      EndIf
      
      ; 2. ТЕСТ ОБЫЧНЫХ ВКЛАДОК: Если мышь не над плюсом — делаем точный хит-тест трапеций
      If *hoveredtab = 0 And ListSize(*control\tabs()) > 0
         LastElement(*control\tabs())
         Repeat
            insidetab = #False
            If my >= *control\tabs()\y And my <= *control\tabs()\y + *control\tabs()\height
               If mx >= *control\tabs()\x And mx <= *control\tabs()\x + *control\tabs()\width
                  relx = mx - *control\tabs()\x
                  rely = my - *control\tabs()\y
                  If localslant > *control\tabs()\height: localslant = *control\tabs()\height: EndIf
                  
                  If relx < localslant
                     If relx >= localslant * (1.0 - (rely / *control\tabs()\height)) : insidetab = #True : EndIf
                  ElseIf relx > *control\tabs()\width - localslant
                     If relx <= *control\tabs()\width - (localslant * (1.0 - (rely / *control\tabs()\height))) : insidetab = #True : EndIf
                  Else
                     insidetab = #True
                  EndIf
               EndIf
            EndIf
            
            If insidetab
               *hoveredtab = @*control\tabs()
               Break 
            EndIf
         Until PreviousElement(*control\tabs()) = 0
      EndIf
      
      ; 3. Вычисляем флаг наведения на крестик закрытия (только для обычных вкладок)
      Protected ShouldCloseHover.a = 0
      Protected h_12 = DesktopScaledX(12)
      Protected h_2 = DesktopScaledX(2)
      If *hoveredtab <> 0 And *hoveredtab <> *control\PlusTab
         Protected closex = *hoveredtab\x + *hoveredtab\width - localslant - DesktopScaledX(14)
         If mx >= closex - h_2 And mx <= closex + h_12 - h_2
            If my >= *hoveredtab\y + (*hoveredtab\height - h_12)/2 And my <= *hoveredtab\y + (*hoveredtab\height + h_12)/2 
               ShouldCloseHover = 1
            EndIf 
         EndIf 
      EndIf
      
      ; --- 4. ЛОГИКА КЛИКА МЫШИ ---
      If etype = #PB_EventType_LeftButtonDown And *hoveredtab <> 0
         If *hoveredtab = *control\PlusTab
            ; КЛИК ПО ПЛЮСУ: Добавляем новую вкладку
            Protected NewIdx = ListSize(*control\tabs()) + 1
            AddCustomTab(*control, "Вкладка " + Str(NewIdx), WindowID, GadgetHeight(*control\canvasid))
            
            ; Полный адаптивный пересчет геометрии окна под новые размеры холста
            ResizeGadget(*control\canvasid, 0, 0, WindowWidth(WindowID), #PB_Ignore)
            Protected NewH = RecalculateTabs(*control)
            ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, NewH)
            
            ForEach *control\tabs()
               ResizeGadget(*control\tabs()\containerid, 0, NewH, WindowWidth(WindowID), WindowHeight(WindowID) - NewH)
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
         If *hoveredtab = @*control\PlusTab
            TargetPlusHover = 1
         EndIf
         
         If *control\PlusTab\ishovered <> TargetPlusHover
            *control\PlusTab\ishovered = TargetPlusHover
            needredraw = #True
         EndIf
         
         ; Синхронный ховер всех обычных вкладок и их крестиков
         ForEach *control\tabs()
            Protected TargetHover = 0
            Protected TargetCloseHover = 0
            
            If @*control\tabs() = *control\active
               TargetHover = 0
               If @*control\tabs() = *hoveredtab
                  TargetCloseHover = ShouldCloseHover
               EndIf
            Else
               If @*control\tabs() = *hoveredtab
                  TargetHover = 1
                  TargetCloseHover = ShouldCloseHover
               EndIf
            EndIf
            
            If *control\tabs()\ishovered <> TargetHover
               *control\tabs()\ishovered = TargetHover
               needredraw = #True
            EndIf
            
            If *control\tabs()\close_ishovered <> TargetCloseHover
               *control\tabs()\close_ishovered = TargetCloseHover
               needredraw = #True
            EndIf
         Next
      EndIf
      
      If needredraw
         redrawtabs(*control)
      EndIf
      
   ; --- 6. КУРСОР УШЕЛ С ХОЛСТА (Тотальный сброс подсветки) ---
   ElseIf etype = #PB_EventType_MouseLeave
      *control\PlusTab\ishovered = 0
      ForEach *control\tabs()
         If *control\tabs()\ishovered <> 0
            *control\tabs()\ishovered = 0
            needredraw = #True
         EndIf
         If *control\tabs()\close_ishovered <> 0
            *control\tabs()\close_ishovered = 0
            needredraw = #True
         EndIf
      Next
      If needredraw
         redrawtabs(*control)
      EndIf
   EndIf
EndProcedure

; обновление размеров холста и всех контейнеров под размеры окна
Procedure resizetabcontrol(*control.multirowtabcontrol, windowid)
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = RecalculateTabs(*control)
   ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; корректируем размеры всех контейнеров в зависимости от новой высоты холста
   ForEach *control\tabs()
      ResizeGadget(*control\tabs()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   redrawtabs(*control)
EndProcedure


;- --- демо запуск ---
Define event, windoww = 900, windowh = 350, realcanvasheight

If OpenWindow(0, 0, 0, windoww, windowh, "chrome tabs with container logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   
   With tabbar
      \canvasid  = CanvasGadget(#PB_Any, 0, 0, windoww, 40)
      \fontid    = LoadFont(0, "tahoma", 12)
      \tabheight = DesktopScaledY(29)
      \paddingx  = DesktopScaledX(6)
      ;\bgcolor     = rgb(random(255), random(255), random(255)) ; твой любимый цвет. сделай его зеленым или серым — и весь интерфейс сам перестроится!
      \PlusTab\title$ = "+"
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
   SelectElement(tabbar\tabs(), 0)
   OpenGadgetList(tabbar\tabs()\containerid)
   ButtonGadget(#PB_Any, 20, 20, 150, 30, "кнопка на вкладке 1")
   StringGadget(#PB_Any, 20, 60, 200, 25, "текст на вкладке 1")
   CloseGadgetList()
   
   SelectElement(tabbar\tabs(), 1)
   OpenGadgetList(tabbar\tabs()\containerid)
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
; CursorPosition = 258
; FirstLine = 227
; Folding = 8--------------
; EnableXP
; DPIAware