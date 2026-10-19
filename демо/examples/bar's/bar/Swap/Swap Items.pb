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

; ==============================================================================
; МАСКИ - Единые битовые константы (Quad)
; ==============================================================================
#__MASK_none      = 0
#__MASK_update    = 1 << 0         ; Флаг: Требуется пересчет геометрии (для всех) (TextWidth и т.д.) нужно пересчитать координаты X для каретки/выделения.

#__MASK_left      = 1 << 1   ; 2   move to left
#__MASK_top       = 1 << 2   ; 4   move to top
#__MASK_right     = 1 << 3   ; 8   move to right
#__MASK_bottom    = 1 << 4   ; 16  move to bottom
#__MASK_center    = 1 << 5

#__MASK_hover     = 1 << 6
#__MASK_press     = 1 << 7         ; 64  button press
#__MASK_release   = 1 << 8         ; 128 button release
#__MASK_dragstart = 1 << 9         ; 256
#__MASK_drag      = 1 << 10        ; Состояние перетаскивания Объект в процессе перетаскивания
#__MASK_active    = 1 << 11        ; Виджет в фокусе / Строка выбрана / Окно активно
#__MASK_redraw    = 1 << 12        ; Флаг: Требуется перерисовка

#__MASK_hidden    = 1 << 16        ; Объект полностью скрыт
#__MASK_disabled   = 1 << 17       ; Объект заблокирован
#__MASK_cursor    = 1 << 21
#__MASK_resize    = 1 << 22
;
#__maskflag_wordwrap  = 1 << 25
#__maskflag_tokken    = 1 << 18
;
#__maskrow_change    = 1 << 20        ; текст изменился, надо перепарсить токены.
#__maskrow_edit      = 1 << 19        ; Выделение (Строка)
#__maskrow_node      = 1 << 23        ; Является узлом (Строка) / Деревом (Виджет)
#__maskrow_collapsed = 1 << 24        ; Свернуто (Узел/Ветка)

#__MASK_change    = #__maskrow_change

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

Structure _s_WIDGET Extends _s_COORDINATE
   change.b
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
Global bottomSpaking.i = DesktopScaledX(8) 

Procedure.l MakeColor( bgColor.l , isHover=0, isActive=0, isPress=0)
  Protected.l nabaser = Red(bgColor) + 25
  Protected.l nabaseg = Green(bgColor) + 20
  Protected.l nabaseb = Blue(bgColor) + 20
  Protected.l nabasea = Alpha(bgColor) ; Извлекаем альфа-канал
  
  If isHover
    nabaser + 30
    nabaseg + 30
    nabaseb + 30
  EndIf
  
  If isActive
    nabaser + 10
    nabaseg + 10
    nabaseb + 10
  EndIf
  
  If isPress
    nabaser - 30
    nabaseg - 30
    nabaseb - 30
  EndIf
  
  ; Ограничение сверху (чтобы не превысить 255)
  If nabaser > 255 : nabaser = 255 : EndIf
  If nabaseg > 255 : nabaseg = 255 : EndIf
  If nabaseb > 255 : nabaseb = 255 : EndIf
  
  ; Дополнительное ограничение снизу (защита от отрицательных значений при исPress)
  If nabaser < 0 : nabaser = 0 : EndIf
  If nabaseg < 0 : nabaseg = 0 : EndIf
  If nabaseb < 0 : nabaseb = 0 : EndIf
  
  ; Возвращаем цвет с сохранением альфа-канала
  ProcedureReturn RGBA(nabaser, nabaseg, nabaseb, nabasea)
EndProcedure


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
   Protected padding.i = slant
   ; UPDATE ROW
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
   
   If Not *tab\size 
      If vertical
         *tab\size = img_H + txt_H
      Else
         *tab\size = img_W + txt_W
      EndIf
      *tab\size + iconSpacing + slant * 2
   EndIf
   
   ; Общие размеры самой вкладки
   If vertical
      ; *tab\x = 0
      ; *tab\y = *tab\pos + *tab\offset
      *tab\width = gWidth-bottomSpaking
      *tab\height = *tab\size
   Else
      ;  *tab\x = *tab\pos + *tab\offset
      ; *tab\y = 0
      *tab\width = *tab\size
      *tab\height = gHeight-bottomSpaking
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

; Функция линейного расчета базовых координат X
Procedure TotalSize(*this._s_WIDGET)
   Protected position.i
   Protected *tab._s_TAB
   
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      *tab\pos = position 
      
      If *this\tab\vertical
         *tab\x = *this\x
         *tab\y =  *this\y + *this\tab\indent  + *tab\pos
      Else
         *tab\y = *this\y
         *tab\x =  *this\x + *this\tab\indent  + *tab\pos
      EndIf
      
      position + (*tab\size - slant) + *this\tab\spacing
   Next
   
   ; Чистый размер блока вкладок с учетом финального скоса
   *this\tab\TotalSize = position + slant - *this\tab\spacing
   If *this\tab\vertical
      *this\Height =  *this\tab\TotalSize +  *this\tab\indent * 2
   Else
      *this\Width =  *this\tab\TotalSize +  *this\tab\indent * 2
   EndIf
EndProcedure

; Процедура добавления вкладки
; Обновленная процедура добавления вкладки с поддержкой иконок и выравнивания

Procedure DrawTabChrome(vertical.b, x, y, w, h, isactive, activecolor.l, nonactivecolor.l = -1, outerbordercolor.l = -1, innerhighlightcolor.l = -1, localslant.l=-1, invert.b = 0)
   If Not w And h
    ;  ProcedureReturn
   EndIf
   
   Protected base_dim = h
   If vertical : base_dim = w : EndIf
   
   If localslant = -1
      localslant = slant
   EndIf
   If localslant > base_dim: localslant = base_dim: EndIf
   
   ; 1. выбор базового цвета для тела
   Protected currentcolor.l
   If isactive
      currentcolor = activecolor
   Else
      If nonactivecolor = -1 : nonactivecolor =  RGBA(215, 225, 240, 255) : EndIf
      currentcolor = nonactivecolor
   EndIf
   Protected.a currentalpha = Alpha(currentcolor)
   
   ; 2. расчет цвета рамок
   If outerbordercolor = -1
      outerbordercolor = RGBA(Red(currentcolor) * 0.6, Green(currentcolor) * 0.6, Blue(currentcolor) * 0.6, currentalpha)
   EndIf
   If innerhighlightcolor = -1
      Protected.a r = Red(currentcolor), g = Green(currentcolor), b = Blue(currentcolor)
      innerhighlightcolor = RGBA(r + (255 - r) * 0.3, g + (255 - g) * 0.3, b + (255 - b) * 0.3, currentalpha)
   EndIf
   
   ; 3. Заливка тела и отрисовка контуров через единый цикл
   Protected step_max = h - 1
   If vertical : step_max = w - 1 : EndIf
   
   Protected i, slant_cur, x1, y1, x2, y2
   Protected.f factor
   
   For i = 0 To step_max
      ; Вычисляем коэффициент прогресса (от 0.0 до 1.0)
      If invert
         factor = i / step_max
      Else
         factor = 1.0 - (i / step_max)
      EndIf
      
      ; Текущий сдвиг (скос) для этой линии
      slant_cur = localslant * factor
      
      ; Определяем координаты линии закраски в зависимости от ориентации
      If vertical
         x1 = x + i
         y1 = y + slant_cur
         x2 = x + i
         y2 = y + h - slant_cur
      Else
         x1 = x + slant_cur
         y1 = y + i
         x2 = x + w - slant_cur
         y2 = y + i
      EndIf
      
      ; Рисуем тело вкладки
      If isactive
         LineXY(x1, y1, x2, y2, activecolor)
      Else
         Protected baser = Red(nonactivecolor)
         Protected baseg = Green(nonactivecolor)
         Protected baseb = Blue(nonactivecolor)
         Protected.f grad_factor = i / step_max
         r = baser + ((baser - 25) - baser) * grad_factor
         g = baseg + ((baseg - 20) - baseg) * grad_factor
         b = baseb + ((baseb - 20) - baseb) * grad_factor
         LineXY(x1, y1, x2, y2, RGBA(r, g, b, currentalpha))
      EndIf
      
      ; Отрисовка внешнего контура (границ) по краям линий закраски
      If i = 0
         ; Задняя (широкая/узкая) крышка основания
         If Not isactive
            LineXY(x1, y1, x2, y2, outerbordercolor)
         EndIf
      ElseIf i = step_max
         ; Передняя крышка вкладки
         LineXY(x1, y1, x2, y2, outerbordercolor)
         ; Блик на передней крышке активной вкладки
         If isactive
            If vertical
               If invert : LineXY(x1 - 1, y1 + 1, x2 - 1, y2 - 1, innerhighlightcolor)
               Else : LineXY(x1 + 1, y1 + 1, x2 + 1, y2 - 1, innerhighlightcolor) : EndIf
            Else
               If invert : LineXY(x1 + 1, y1 - 1, x2 - 1, y2 - 1, innerhighlightcolor)
               Else : LineXY(x1 + 1, y1 + 1, x2 - 1, y2 + 1, innerhighlightcolor) : EndIf
            EndIf
         EndIf
      EndIf
      
      ; Отрисовываем боковые наклонные ребра (левое и правое)
      If i > 0
         LineXY(x1, y1, x1, y1, outerbordercolor)
         LineXY(x2, y2, x2, y2, outerbordercolor)
      EndIf
   Next i
EndProcedure

Procedure DrawTab(*tab._s_TAB, bgColor.l=$FF808080, vertical.b=0, isActive.b=0)
   Protected txColor 
   
   ; Включаем альфа-смешивание для отрисовки тела вкладки Chrome
    DrawingMode(#PB_2DDrawing_AlphaBlend) 
   
   If isActive ; *tab\mask & #__MASK_active
      txColor = $FF000000
      ; Передаем bgColor, который теперь должен содержать альфа-канал
      DrawTabChrome(vertical, *tab\x, *tab\y, *tab\width, *tab\Height+bottomSpaking, 1, bgColor)
   Else
      txColor = $FFFFFFFF
      DrawTabChrome(vertical, *tab\x, *tab\y, *tab\width, *tab\Height, 0, 0, MakeColor(bgColor,1,0,0))
   EndIf
   
   ; 2. ОТРИСОВКА ИКОНКИ
   If *tab\img\Width Or *tab\img\Height
      DrawAlphaImage(ImageID(*tab\img\Image), *tab\x + *tab\img\x, *tab\y + *tab\img\y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Width Or *tab\txt\Height
      ; Для текста совмещаем прозрачность фона текста и альфа-канал самого текста
      DrawingMode(#PB_2DDrawing_Transparent | #PB_2DDrawing_AlphaBlend)
      DrawText(*tab\x + *tab\txt\x, *tab\y + *tab\txt\y, *tab\txt\Text, txColor)
   EndIf
EndProcedure

Procedure DrawTabs(*this._s_WIDGET, *current_tab._s_TAB)
   Protected position.i
   Protected *tab._s_TAB
   Protected vertical.b = *this\tab\vertical
   Protected bgColor.l = *this\bgcolor
   ; линия пола
   Protected floorcolor = RGB(Red(bgColor) * 0.7, Green(bgColor) * 0.7, Blue(bgColor) * 0.7)
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   LineXY(*this\x, *this\y+*this\Height - 1, *this\x+*this\Width, *this\y+*this\Height - 1, $ff000000);floorcolor)
   
   ForEach *this\tab\_s()
      *tab = @*this\tab\_s()
      ;
      If *tab\txt\change  Or *tab\img\change Or *this\change
         UpdateTab(*tab._s_TAB, *this\Width, *this\Height, vertical)
         *tab\pos = position 
         
         If *this\tab\vertical
            ;*tab\x = *this\x
            *tab\y =  *this\y + *this\tab\indent  + *tab\pos
         Else
            ;*tab\y = *this\y
            *tab\x =  *this\x + *this\tab\indent  + *tab\pos
         EndIf
         
         position + (*tab\size - slant) + *this\tab\spacing
      EndIf
      
      ; Слой 1: Статичные
      If *tab <> *current_tab
         DrawTab(*tab, bgColor, vertical, 0)
      EndIf
   Next
   *this\change = 0
   
   ; Слой 2: Летящая поверх
   If *current_tab
      DrawTab(*current_tab, RGBA(255, 255, 255, 160), vertical, 1)
   EndIf
EndProcedure

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(*this._s_WIDGET)
   Protected Gadget.i = *this\canvasid
   Protected gWidth.i = *this\Width ; DesktopScaledX(GadgetWidth(Gadget))
   Protected gHeight.i = *this\Height ; DesktopScaledY(GadgetHeight(Gadget))
   
   If StartDrawing(CanvasOutput(Gadget))
      If *this\fontid : DrawingFont(*this\fontid) :  EndIf
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(0, 0, OutputWidth(), OutputHeight(), $ffffffff) 
      Box(*this\x, *this\y, gWidth, gHeight, *this\bgcolor) 
      
      DrawTabs(*this, *this\tab\active)
      StopDrawing()
   EndIf
EndProcedure

Procedure DoTabEvents(*this._s_WIDGET, event.i, mousePos.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected stepSize.i
   Protected accumulatedSize.i = 0
   Protected isBeforeDragged.b = #True 
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
         
         *this\tab\active = *current_tab
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
            ;
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
                  *tab\y =  *this\y + *this\tab\indent  + *tab\pos + *tab\offset
               Else
                  *tab\x =  *this\x + *this\tab\indent  + *tab\pos + *tab\offset
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
   
   If ListSize(*this\Tab\_s()) = 1
      *this\tab\active = *tab
   EndIf
   ProcedureReturn *tab
EndProcedure

Procedure CreateTab( Canvas, x.l,y.l,width.l,height.l )
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   *this\tab\vertical = 0
   *this\canvasid  = Canvas
   *this\X = DesktopScaledX(x)
   *this\y = DesktopScaledY(y)
   *this\Width = DesktopScaledX(width)
   *this\Height = DesktopScaledY(height)
   
   *this\tab\indent = DesktopScaledX(50) ; Отступ панели слева
   *this\tab\spacing = DesktopScaledX(2) ; Расстояние между вкладками
   *this\fontid  = LoadFont(0, "tahoma", 12)
   *this\bgcolor = RGBA(180, 195, 215, 160)
   ProcedureReturn *this
EndProcedure

; =====================================================================
; 4. ДЕМОНСТРАЦИОННЫЙ ЗАПУСК
; =====================================================================

#Win = 0
#Canvas = 0

Procedure Resize_(*this._s_WIDGET)
   *this\change = 1
   *this\Width = 240
   *this\Height = 40
   TotalSize(*this)
   Define w = *this\Width
   Define h = *this\Height
   ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 40, h + 40)
   ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
   HideWindow(#Win, 0, #PB_Window_ScreenCentered)
   ReDrawTabs( *this)
EndProcedure

If OpenWindow(#Win, 0,0,0,0, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, 0, 0)
   
   Define *this._s_WIDGET = CreateTab(#Canvas, 10,10,240,40 )
   ; Наполняем вашим тестовым набором
   AddTab(*this, 0, "0 - 60", 0)
   AddTab(*this, 1, "1 - 160", 160, #__flag_Center, 1)
   AddTab(*this, 2, "2 - 150", 150, #__flag_Right, 1)
   AddTab(*this, 3, "3 - 90", 90,0, 1)
   ;
   ReDrawTabs(*this)
   Resize_(*this)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_RightClick
            HideWindow(#Win, 1)
            *this\tab\vertical ! 1
            ClearList(*this\Tab\_s())
            AddTab(*this, 0, "0 - 60", 60)
            AddTab(*this, 1, "1 - 160", 160, #__flag_Center, 1)
            AddTab(*this, 2, "2 - 150", 150, #__flag_Right, 1)
            AddTab(*this, 3, "3 - 90", 90,0, 1)
            ;
            ReDrawTabs(*this)
            Resize_( *this )
         EndIf
         
         If *this\tab\vertical
            If DoTabEvents( *this, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
               ReDrawTabs(*this)
            EndIf
         Else
            If DoTabEvents( *this, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
               ReDrawTabs( *this)
            EndIf
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 432
; FirstLine = 394
; Folding = ------0----------
; EnableXP
; EnableOnError
; EnableUnicode