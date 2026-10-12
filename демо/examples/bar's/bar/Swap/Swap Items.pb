EnableExplicit

;-
UsePNGImageDecoder()
If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
   End
EndIf
If DesktopResolutionX() > 1
   ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
EndIf

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

Structure _s_TAB Extends _s_COORDINATE
   ID.i             ; Номер элемента в списке данных строки (0, 1, 2...) 
   txt._s_TXT       ; Имя поля заголовка
   img._s_IMG
   
   ;
   pos.l
   size.l
   align.a          ; Выравнивание
                    ; mask.q           ; Маска конкретной вкладки
   
   ; Поля для идеальной математики плавного сдвига
   offset.l        ; Динамический визуальный сдвиг
   minOffset.l     ; Левый ограничитель хода
   maxOffset.l     ; Правый ограничитель хода
EndStructure

Structure _s_TABS
   *active._s_TAB   
   *press._s_TAB  ; Указатель на перетаскиваемую вкладку
   
   vertical.b
   
   align.a               
   indent.a 
   spacing.a             
   
   TotalSize.l          
   List _s._s_TAB()  ; Заголовки вкладок
EndStructure

Structure _s_WIDGET
   ;    padding.a
   ;    spacing.a             
   Tab._s_TABS
   dragOffSet.i     ; Точка захвата мыши
   
   canvasid     .i  
   fontid       .i  
   bgcolor      .l ; <--- добавь это поле для управления общим фоном холста
   
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================
 Global slant.i = DesktopScaledX(20)
   
 
Procedure.i GetAlignPosition(alignFlags.l, contentSize.i, objectSize.i, Offset.i = 10)
   If alignFlags & #__flag_Center
      ProcedureReturn (contentSize - objectSize) / 2
   ElseIf alignFlags & #__flag_Right
      ProcedureReturn contentSize - objectSize - Offset
   Else ; #__flag_Left
      ProcedureReturn Offset
   EndIf
EndProcedure


; Функция линейного расчета базовых координат X
Procedure _TotalSize(*this._s_WIDGET)
   Protected position.i = *this\tab\indent
   Protected *tab._s_TAB
   
   If *this\tab\press = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         *tab\pos = position
         ;*tab\offset = 0
         
         ; ИСПРАВЛЕНИЕ: Принудительно обновляем x/y для новой отрисовки
         If *this\tab\vertical
            *tab\y = *tab\pos
         Else
            *tab\x = *tab\pos
         EndIf
         
         ;position + *tab\size + *this\tab\spacing
         position + (*tab\size - slant) + *this\tab\spacing
      Next
      *this\tab\TotalSize = position - *this\tab\spacing + slant
   EndIf
EndProcedure
Procedure TotalSize(*this._s_WIDGET)
  Protected position.i = 0 ; Стартуем с 0, чтобы получить ЧИСТУЮ длину блока табов
  Protected *tab._s_TAB
  
  If *this\tab\press = #Null
    ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      
      ; Записываем локальную позицию вкладки относительно НАЧАЛА блока табов
      *tab\pos = position 
      
      If *this\tab\vertical
        *tab\y = *this\tab\indent  + *tab\pos
      Else
        *tab\x = *this\tab\indent  + *tab\pos
      EndIf
      
      position + (*tab\size - slant) + *this\tab\spacing
    Next
    
    ; Чистый размер блока вкладок с учетом финального скоса
    *this\tab\TotalSize = position - *this\tab\spacing + slant
  EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания
Procedure AddTab(*this._s_WIDGET, ID.i, Text.s, size.i, align.a = #__flag_Left, Image.i = 0)
   Protected *tab._s_TAB = AddElement(*this\tab\_s())
   
   *tab\ID        = ID
   *tab\align     = align
   *tab\size      = DesktopScaledY(size)
   If Text
      *tab\txt\text  = Text
      *tab\txt\change = 1
   EndIf
   If IsImage(Image)
      *tab\img\image = Image 
      *tab\img\change = 1
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
   Protected padding.i = slant
   ; UPDATE ROW
    ; Общие размеры самой вкладки
   If vertical
     ; *tab\x = 0
     ; *tab\y = *tab\pos + *tab\offset
      *tab\width = gWidth
      *tab\height = *tab\size
   Else
    ;  *tab\x = *tab\pos + *tab\offset
     ; *tab\y = 0
      *tab\width = *tab\size
      *tab\height = gHeight
   EndIf 

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
      txt_x = (*tab\width - txt_w) >> 1
      img_x = (*tab\width - img_w) >> 1
      
      ; Вертикальный режим: складываем высоты, по ширине берем максимум
      contentY = GetAlignPosition(*tab\align, *tab\size, img_h + txt_h + iconSpacing, padding)
      
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
      txt_y = (*tab\height - txt_h) >> 1
      img_y = (*tab\height - img_h) >> 1
      
      ; Горизонтальный режим: складываем ширину, по высоте берем максимум
      contentX = GetAlignPosition(*tab\align, *tab\size,  img_w + txt_w + iconSpacing, padding)
      
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
EndProcedure

Procedure DrawTabChrome(x, y, w, h, isactive, activecolor.l, nonactivecolor.l = -1, outerbordercolor.l = -1, innerhighlightcolor.l = -1, localslant=-1)
   Protected i, dy, dh = (h); - 1)
   If localslant =-1
      localslant = slant
   EndIf
   
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

Procedure DrawTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b, bgColor.l=$FF808080, isResize.b=0)
   Protected txt_change = *tab\txt\change 
   Protected img_change = *tab\img\change
   If txt_change Or img_change Or isResize
      UpdateTab(*tab._s_TAB, gWidth, gHeight, vertical)
   EndIf
   
   ; DRAW ROW
   ; 1. ОТРИСОВКА ФОНА
   ;Box(*tab\x, *tab\y, *tab\Width, *tab\Height, bgColor)
   ;If bgColor.l=$FF808080
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawTabChrome(*tab\x, *tab\y, *tab\width, *tab\Height, 0, 0, bgColor)
   ;EndIf   
   
   ; 2. ОТРИСОВКА ИКОНКИ
   If *tab\img\Width Or *tab\img\Height
      DrawAlphaImage(ImageID(*tab\img\Image), *tab\x + *tab\img\x, *tab\y + *tab\img\y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Width Or *tab\txt\Height
      ; DrawingMode(#PB_2DDrawing_Transparent)
     DrawText(*tab\x + *tab\txt\x, *tab\y + *tab\txt\y, *tab\txt\Text, $FFFFFFFF)
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
         DrawTab(*tab, gWidth, gHeight, vertical)
      EndIf
   Next
   
   ; Слой 2: Летящая поверх
   If *current_tab
      DrawTab(*current_tab, gWidth, gHeight, vertical, $A00000FF)
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(*this._s_WIDGET)
   Protected Gadget.i = *this\canvasid
   Protected gWidth.i = DesktopScaledX(GadgetWidth(Gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(Gadget))
   
   If Not StartDrawing(CanvasOutput(Gadget))
      ProcedureReturn
   EndIf
   
   If *this\fontid
      DrawingFont(*this\fontid)
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawTabs(*this, *this\tab\press, gWidth, gHeight)
   
   StopDrawing()
EndProcedure

Procedure DoTabEvents(*this._s_WIDGET, event.i, mousePos.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected accumulatedSize.i = 0
   Protected isBeforeDragged.b = #True 
   Protected stepSize.i
   mousePos - *this\tab\indent 
   
   Select event
      Case #PB_EventType_LeftButtonDown
         
         *this\dragOffSet = mousePos
         
         ; ЦИКЛ 1: Находим вкладку, на которую кликнули (с учетом наложения скосов)
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            If mousePos >= *tab\pos And mousePos < *tab\pos + (*tab\size - slant)
               *current_tab = *tab
               Break
            EndIf
         Next
         
         *this\tab\press = *current_tab
         
         ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offset за один проход
         If *current_tab
            ; Шаг сдвига уменьшен на величину наложения скоса (slant)
            stepSize = (*current_tab\size - slant) + *this\tab\spacing
            
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  isBeforeDragged = #False 
                  *tab\offset = mousePos - *this\dragOffSet
                  Continue ; Лимиты для dragged запишем сразу после цикла
               EndIf
               
               ; 1. Сдвигаем базовый X только для вкладок левее нажатой
               If isBeforeDragged
                  *tab\pos + stepSize
               EndIf
               
               ; 2. Расчет лимитов хода (использует уже обновленный *tab\pos)
               *tab\minOffset = accumulatedSize - *tab\pos
               *tab\maxOffset = accumulatedSize - *tab\pos + stepSize
               accumulatedSize + (*tab\size - slant) + *this\tab\spacing
               
               ; 3. Пропорция инициализации offset (модифицирована под размер с учетом наложения)
               *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
               *tab\offset - stepSize
               *tab\offset * stepSize / ((*tab\size - slant) + *this\tab\spacing)
               
               ; Ограничители хода
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            
            ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
            *current_tab\minOffset = -*current_tab\pos 
            *current_tab\maxOffset = -*current_tab\pos + accumulatedSize 
            
            If *current_tab\offset < *current_tab\minOffset : *current_tab\offset = *current_tab\minOffset : EndIf
            If *current_tab\offset > *current_tab\maxOffset : *current_tab\offset = *current_tab\maxOffset : EndIf
            
            ProcedureReturn #True
         EndIf
         
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
                  *tab\offset * stepSize / ((*tab\size - slant) + *this\tab\spacing)
               EndIf
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
               
               ; Применяем координаты визуального отображения
               If *this\tab\vertical
                  *tab\y = *this\tab\indent  + *tab\pos + *tab\offset
               Else
                  *tab\x = *this\tab\indent  + *tab\pos + *tab\offset
               EndIf
            Next
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         *current_tab = *this\tab\press
         If *current_tab
            ; Переносим визуальный сдвиг в постоянную координату X и обнуляем offset
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               *tab\pos + *tab\offset
               *tab\offset = 0
            Next
            
            ; Сортируем список вкладок в памяти по их новым физическим координатам X
            SortStructuredList(*this\tab\_s(), #PB_Sort_Ascending, OffsetOf(_s_tab\pos), TypeOf(_s_tab\pos))
            
            ; Сбрасываем указатель перетаскивания
            *this\tab\press = #Null
            
            ; Вызываем внутренние процедуры обновления состояния и перерисовки
            TotalSize(*this)
            ProcedureReturn #True
         EndIf
         
   EndSelect
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

Define MyThis._s_WIDGET
MyThis\tab\vertical = 0
MyThis\tab\indent = DesktopScaledX(50) ; Отступ панели слева
MyThis\tab\spacing = DesktopScaledX(2) ; Расстояние между вкладками

; Наполняем вашим тестовым набором
AddTab(@MyThis, 0, "0 - 60", 60)
AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
;
TotalSize(@MyThis)

If MyThis\tab\vertical
   Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent*2)
   Define w = 240
Else
   Define h = 40
   Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent*2)
EndIf

#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   MyThis\canvasid  = #Canvas
   MyThis\fontid    = LoadFont(0, "tahoma", 12)
   
   ReDrawTabs(@MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_RightClick
            HideWindow(#Win, 1)
            MyThis\tab\vertical ! 1
            ClearList(MyThis\Tab\_s())
            AddTab(@MyThis, 0, "0 - 60", 60)
            AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
            AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
            AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
            TotalSize(@MyThis)
            If MyThis\tab\vertical
               Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent*2)
               Define w = 240
            Else
               Define h = 40
               Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent*2)
            EndIf
            ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
            ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w, h)
            ReDrawTabs( @MyThis)
            HideWindow(#Win, 0, #PB_Window_ScreenCentered)
         EndIf
         
         If MyThis\tab\vertical
            If DoTabEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
               ReDrawTabs(@MyThis)
            EndIf
         Else
            If DoTabEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
               ReDrawTabs( @MyThis)
            EndIf
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 464
; FirstLine = 432
; Folding = --f----------
; EnableXP
; EnableOnError
; EnableUnicode