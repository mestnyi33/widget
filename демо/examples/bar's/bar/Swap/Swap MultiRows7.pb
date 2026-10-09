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
   List tabs    .customtab()
EndStructure

Global tabbar.multirowtabcontrol
Global slant = 20 
Global bottom_size = 2

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
   Protected i, dy
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
      For dy = 0 To h - 1
         Protected currentslant = localslant * (1.0 - (dy / h))
         LineXY(x + currentslant, y + dy, x + w - currentslant, y + dy)
      Next
   Else
      Protected baser = Red(nonactivecolor)
      Protected baseg = Green(nonactivecolor)
      Protected baseb = Blue(nonactivecolor)
      
      For dy = 0 To h - 1
         Protected factor.f = dy / (h - 1)
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
   LineXY(x, y + h - 1, x + localslant, y)             
   LineXY(x + localslant, y, x + w - localslant, y)         
   LineXY(x + w - localslant, y, x + w, y + h - 1)     
   
   If isactive
      ; внутренний светлый блик (только для активной)
      FrontColor(innerhighlightcolor)
      LineXY(x + 2, y + h - 1, x + localslant + 1, y + 1)
      LineXY(x + localslant + 1, y + 1, x + w - localslant - 1, y + 1)
      LineXY(x + w - localslant - 1, y + 1, x + w - 2, y + h - 1)
   Else
      ; нижняя замыкающая линия для неактивных
      LineXY(x, y + h - 1, x + w, y + h - 1);, outerbordercolor)
   EndIf
EndProcedure

Procedure.i recalculatetabs(*control.multirowtabcontrol)
   Protected canvasw = GadgetWidth(*control\canvasid)
   Protected currentx = 4
   Protected currenty = 6
   Protected currentrow = 0
   Protected maxheight = 0
   Protected maxwidth = canvasw - 4
   Protected i.i, k.i, startidx.i, endidx.i
   Protected totalrowwidth.i, extraspace.i, addpixels.i, remainder.i
   Protected tabcount = ListSize(*control\tabs())
   
   If tabcount = 0 : ProcedureReturn *control\tabheight + bottom_size : EndIf
   
   If StartDrawing(CanvasOutput(*control\canvasid))
      DrawingFont(*control\fontid)
      ; 1. заполняем массив указателей и вычисляем начальную базовую ширину табов по тексту
      Dim *rowtabs.customtab(tabcount - 1)
      i = 0
      ForEach *control\tabs()
         *rowtabs(i) = @*control\tabs()
         *rowtabs(i)\height = *control\tabheight
         
         Protected basewidth = TextWidth(*rowtabs(i)\title$) + (*control\paddingx * 2) + (slant * 2)
         If *rowtabs(i)\imageid <> 0
            basewidth + 20
         EndIf
         basewidth + 16 ; <--- добавляем место под крестик закрытия
         *rowtabs(i)\width = basewidth
         i + 1
      Next
      
      startidx = 0
      currentx = 4
      
      ; 2. цикл распределения по координатам и точечного растяжения
      For i = 0 To tabcount - 1
         Protected tabw = *rowtabs(i)\width
         
         ; условие переноса: текущий таб не влезает в границы холста
         If currentx + tabw > maxwidth And i > startidx
            endidx = i - 1 ; ряд формируют табы от startidx до предыдущего (влезшего)
            
            ; считаем, какую ширину этот ряд сейчас занимает
            totalrowwidth = 4
            For k = startidx To endidx
               totalrowwidth + *rowtabs(k)\width
               If k < endidx : totalrowwidth - (slant * 4 / 3) : EndIf
            Next
            
            ; вычисляем дыру справа
            extraspace = (maxwidth) - totalrowwidth
            
            ; растягиваем только этот ряд (так как из него улетел элемент i)
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
            
            ; записываем финальные координаты для растянутого ряда
            Protected tempx = 4
            For k = startidx To endidx
               *rowtabs(k)\x = tempx
               *rowtabs(k)\y = currenty
               *rowtabs(k)\row = currentrow
               
               If currenty + *rowtabs(k)\height > maxheight
                  maxheight = currenty + *rowtabs(k)\height
               EndIf
               tempx + *rowtabs(k)\width - (slant * 4 / 3)
            Next
            
            ; переходим на следующую строку для оставшихся табов
            currentrow + 1
            currenty + *control\tabheight + 2
            currentx = 4
            startidx = i ; новый ряд начнется с невлезшего таба
         EndIf
         
         ; шагаем по оси x для следующей проверки
         currentx + *rowtabs(i)\width - (slant * 4 / 3)
      Next
      
      ; 3. обработка последнего ряда (в котором переноса не было)
      ; он просто выстраивается слева по своей базовой ширине текста, без какого-либо растягивания!
      currentx = 4
      For k = startidx To tabcount - 1
         *rowtabs(k)\x = currentx
         *rowtabs(k)\y = currenty
         *rowtabs(k)\row = currentrow
         
         If currenty + *rowtabs(k)\height > maxheight
            maxheight = currenty + *rowtabs(k)\height
         EndIf
         currentx + *rowtabs(k)\width - (slant * 4 / 3)
      Next
      
      StopDrawing()
   EndIf
   
   ProcedureReturn maxheight + bottom_size
EndProcedure

Procedure redrawtabs(*control.multirowtabcontrol)
   Protected canvasw = GadgetWidth(*control\canvasid)
   Protected canvash = GadgetHeight(*control\canvasid)
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
            
            Protected nabaser = Red(canvasbgcolor) + 25
            Protected nabaseg = Green(canvasbgcolor) + 20
            Protected nabaseb = Blue(canvasbgcolor) + 20
            
            If *control\tabs()\ishovered : nabaser + 30 : nabaseg + 30 : nabaseb + 30 : EndIf
            If nabaser > 255 : nabaser = 255 : EndIf : If nabaseg > 255 : nabaseg = 255 : EndIf : If nabaseb > 255 : nabaseb = 255 : EndIf
            nonactivecolor = RGB(nabaser, nabaseg, nabaseb)
            
            drawoldchrometab(*control\tabs()\x, *control\tabs()\y, *control\tabs()\width, *control\tabs()\height, #False, 0, nonactivecolor)
            
            ; расчет центрирования контента (текст + иконка + крестик)
            Protected txtw = TextWidth(*control\tabs()\title$)
            Protected contentw = txtw + 16 ; текст + крестик
            If *control\tabs()\imageid <> 0 : contentw + 20 : EndIf
            
            Protected startx = *control\tabs()\x + (*control\tabs()\width - contentw) / 2
            
            ; рисуем иконку
            If *control\tabs()\imageid <> 0
               Protected icony = *control\tabs()\y + (*control\tabs()\height - 16) / 2
               DrawImage(ImageID(*control\tabs()\imageid), startx, icony, 16, 16)
               startx + 20
            EndIf
            
            Protected textbgr = nabaser - (25 * 0.2)
            Protected textbgg = nabaseg - (20 * 0.2)
            Protected textbgb = nabaseb - (20 * 0.2)
            Protected textcolor = RGB(Red(canvasbgcolor) * 0.3, Green(canvasbgcolor) * 0.3, Blue(canvasbgcolor) * 0.3)
            
            ; рисуем текст
            DrawText(startx, *control\tabs()\y + 6, *control\tabs()\title$, textcolor, RGB(textbgr, textbgg, textbgb))
            
            ; --- рисуем крестик для неактивной вкладки (справа) ---
            ; от правого края вкладки отступаем на величину скоса slant + 14 пикселей
            Protected closex = *control\tabs()\x + *control\tabs()\width - slant - 14
            Protected closey = *control\tabs()\y + (*control\tabs()\height - 3) / 2
            If *control\tabs()\close_ishovered 
            Circle(closex + 4, closey + 4, 7, RGB(240, 70, 70)) 
            LineXY(closex, closey, closex + 8, closey + 8, RGB(255, 255, 255)) 
            LineXY(closex + 8, closey, closex, closey + 8, RGB(255, 255, 255)) 
         Else 
            LineXY(closex, closey, closex + 8, closey + 8, RGB(160, 50, 50)) 
            LineXY(closex + 8, closey, closex, closey + 8, RGB(160, 50, 50)) 
         EndIf
         EndIf
      Next
      
      ; 2. отрисовка активной вкладки
      If *control\active <> 0
         tabcolor = GetGadgetColor(*control\active\containerid, #PB_Gadget_BackColor)
         If tabcolor = -1 : tabcolor = RGB(255, 255, 255) : EndIf
         
         drawoldchrometab(*control\active\x, *control\active\y, *control\active\width, *control\active\height + bottom_size, #True, tabcolor)
         
         txtw = TextWidth(*control\active\title$)
         contentw = txtw + 16
         If *control\active\imageid <> 0 : contentw + 20 : EndIf
         
         startx = *control\active\x + (*control\active\width - contentw) / 2
         
         If *control\active\imageid <> 0
            icony = *control\active\y + (*control\active\height - 16) / 2
            DrawImage(ImageID(*control\active\imageid), startx, icony, 16, 16)
            startx + 20
         EndIf
         
         DrawText(startx, *control\active\y + 6, *control\active\title$, RGB(0, 0, 0), tabcolor)
         
         ; --- рисуем крестик для активной вкладки (справа) ---
         closex = *control\active\x + *control\active\width - slant - 14
         closey = *control\active\y + (*control\active\height - 8) / 2
         If *control\active\close_ishovered 
            Circle(closex + 4, closey + 4, 7, RGB(240, 70, 70)) 
            LineXY(closex, closey, closex + 8, closey + 8, RGB(255, 255, 255)) 
            LineXY(closex + 8, closey, closex, closey + 8, RGB(255, 255, 255)) 
         Else 
            LineXY(closex, closey, closex + 8, closey + 8, RGB(160, 50, 50)) 
            LineXY(closex + 8, closey, closex, closey + 8, RGB(160, 50, 50)) 
         EndIf
      EndIf
      
      StopDrawing()
   EndIf
EndProcedure

Procedure closecustomtab(*control.multirowtabcontrol, *tabtoclose.customtab, windowid.i)
   ; переводим список на удаляемую вкладку, чтобы безопасно работать с ней
   ChangeCurrentElement(*control\tabs(), *tabtoclose)
   
   ; 1. уничтожаем привязанный containergadget и все элементы внутри него
   If IsGadget(*tabtoclose\containerid)
      FreeGadget(*tabtoclose\containerid)
   EndIf
   
   ; 2. если закрываем текущий активный таб — ищем ему замену
   If *control\active = *tabtoclose
      ; пробуем переключиться на предыдущую (левее)
      If PreviousElement(*control\tabs())
         *control\active = @*control\tabs()
      Else
         ; если левее ничего нет, возвращаемся и пробуем взять следующую (правее)
         NextElement(*control\tabs())
         If NextElement(*control\tabs())
            *control\active = @*control\tabs()
            PreviousElement(*control\tabs()) ; возвращаем внутренний указатель списка назад
         Else
            ; вкладок больше вообще не осталось
            *control\active = 0
         EndIf
      EndIf
   EndIf
   
   ; 3. удаляем элемент из связанного списка purebasic
   DeleteElement(*control\tabs())
   
   ; 4. если нашли новый активный таб — делаем его контейнер видимым
   If *control\active <> 0
      HideGadget(*control\active\containerid, #False)
   EndIf
   
   ; 5. полный адаптивный пересчет геометрии
   ; из-за удаления вкладки ряды могли схлопнуться, поэтому пересчитываем высоту холста
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = recalculatetabs(*control)
   ResizeGadget(*control\canvasid, #PB_Ignore, #PB_Ignore, #PB_Ignore, newheight)
   
   ; подтягиваем вверх/вниз координаты и размеры всех оставшихся контейнеров окон
   ForEach *control\tabs()
      ResizeGadget(*control\tabs()\containerid, 0, newheight, WindowWidth(windowid), WindowHeight(windowid) - newheight)
   Next
   
   ; перерисовываем очищенный холст
   redrawtabs(*control)
EndProcedure

Procedure handletabsevents(*control.multirowtabcontrol)
   Protected mx = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseX)
   Protected my = GetGadgetAttribute(*control\canvasid, #PB_Canvas_MouseY)
   Protected localslant = slant
   Protected insidetab.i, relx.i, rely.i
   Protected *hoveredtab.customtab = 0
   Protected needredraw.i = #False
   Protected etype = EventType()
   
   If etype = #PB_EventType_MouseMove Or etype = #PB_EventType_LeftButtonDown
      
      ; 1. Точный хит-тест трапеций
      If ListSize(*control\tabs()) > 0
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
      
      ; 2. Вычисляем — находится ли мышь над крестиком hovered-таба прямо сейчас
      Protected ShouldCloseHover.a = 0
      If *hoveredtab <> 0 
         Protected closex = *hoveredtab\x + *hoveredtab\width - localslant - 14 
         If mx >= closex - 2 And mx <= closex + 10 
            If my >= *hoveredtab\y + (*hoveredtab\height - 12)/2 And my <= *hoveredtab\y + (*hoveredtab\height + 12)/2 
               ShouldCloseHover = 1
            EndIf 
         EndIf 
      EndIf
      
      ; 3. ЛОГИКА КЛИКА
      If etype = #PB_EventType_LeftButtonDown And *hoveredtab <> 0
         ; Запрос флага идет напрямую из структуры таба, как ты и сделал
         If *hoveredtab\close_ishovered
            closecustomtab(*control, *hoveredtab, EventWindow())
         Else
            If *control\active <> *hoveredtab
               If *control\active <> 0 : HideGadget(*control\active\containerid, #True) : EndIf
               *control\active = *HoveredTab
               HideGadget(*control\active\containerid, #False)
               redrawtabs(*control)
            EndIf
         EndIf
         
      ; 4. ЛОГИКА ДВИЖЕНИЯ МЫШИ (Синхронный и чистый пересчет всех флагов)
      ElseIf etype = #PB_EventType_MouseMove
         ForEach *control\tabs()
            Protected TargetHover = 0
            Protected TargetCloseHover = 0
            
            ; Активный таб не имеет общего ховера, но может иметь ховер крестика!
            If @*control\tabs() = *control\active
               TargetHover = 0
               If @*control\tabs() = *hoveredtab : TargetCloseHover = ShouldCloseHover : EndIf
            Else
               ; Для неактивных табов проверяем и ховер тела, и ховер крестика
               If @*control\tabs() = *hoveredtab
                  TargetHover = 1
                  TargetCloseHover = ShouldCloseHover
               EndIf
            EndIf
            
            ; Проверяем изменение состояния тела вкладки
            If *control\tabs()\ishovered <> TargetHover
               *control\tabs()\ishovered = TargetHover
               needredraw = #True
            EndIf
            
            ; Проверяем изменение состояния крестика (Защита от мерцания)
            If *control\tabs()\close_ishovered <> TargetCloseHover
               *control\tabs()\close_ishovered = TargetCloseHover
               needredraw = #True
            EndIf
         Next
      EndIf
      
      If needredraw : redrawtabs(*control) : EndIf
      
   ; 5. МЫШЬ УШЛА С ХОЛСТА (Полная тотальная очистка всех флагов)
   ElseIf etype = #PB_EventType_MouseLeave
      ForEach *control\tabs()
         If *control\tabs()\ishovered <> 0 : *control\tabs()\ishovered = 0 : needredraw = #True : EndIf
         If *control\tabs()\close_ishovered <> 0 : *control\tabs()\close_ishovered = 0 : needredraw = #True : EndIf
      Next
      If needredraw : redrawtabs(*control) : EndIf
   EndIf
EndProcedure

; обновление размеров холста и всех контейнеров под размеры окна
Procedure resizetabcontrol(*control.multirowtabcontrol, windowid)
   ResizeGadget(*control\canvasid, 0, 0, WindowWidth(windowid), #PB_Ignore)
   Protected newheight = recalculatetabs(*control)
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
      \tabheight = 29
      \paddingx  = 6
      ;\bgcolor     = rgb(random(255), random(255), random(255)) ; твой любимый цвет. сделай его зеленым или серым — и весь интерфейс сам перестроится!
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
            If EventGadget() = tabbar\canvasid: handletabsevents(tabbar): EndIf
            
         Case #PB_Event_SizeWindow
            ; вызываем единую процедуру ресайза для холста и дочерних контейнеров
            resizetabcontrol(tabbar, 0)
            
         Case #PB_Event_CloseWindow
            End
      EndSelect
   ForEver
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 498
; FirstLine = 486
; Folding = -------------
; EnableXP
; DPIAware