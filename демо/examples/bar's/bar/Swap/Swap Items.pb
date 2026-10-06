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

Structure _s_TAB
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
EndStructure

; =====================================================================
; 3. ЛОГИКА АЛГОРИТМА И ОТРИСОВКИ
; =====================================================================

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
Procedure TotalSize(*this._s_WIDGET)
   Protected position.i = *this\tab\indent
   Protected *tab._s_TAB
   
   If *this\tab\press = #Null
      ForEach *this\tab\_s()
         *tab = @*this\tab\_s()
         *tab\pos = position : position + *tab\size + *this\tab\spacing
         *tab\offset = 0
      Next
      *this\tab\TotalSize = position - *this\tab\spacing
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

; Будущая рабочая процедура (когда все метрики уже посчитаны при создании)
Procedure _DrawTab(*tab._s_TAB, gWidth.i, gHeight.i, vertical.b, isDragged.b, isResize.b=0)
   Protected contentX.i, contentY.i, contentW.i, contentH.i
   Protected rx.i, rw.i 
   Protected ry.i, rh.i
   
   ; UPDATE ROW
   If *tab\txt\change Or *tab\img\change Or isResize
      Protected padding.i = DesktopScaledX(8)
      Protected iconSpacing.i = 0
      
      ; 1. Замеры метрик
      If *tab\txt\change
         If *tab\txt\Text <> ""
            *tab\txt\Width = TextWidth(*tab\txt\Text)
            *tab\txt\height = TextHeight(*tab\txt\Text)
         Else
            *tab\txt\Width = 0 : *tab\txt\height = 0
         EndIf
      EndIf
      
      If *tab\img\change
         If IsImage(*tab\img\Image)
            *tab\img\width = ImageWidth(*tab\img\Image)
            *tab\img\height = ImageHeight(*tab\img\Image)
         Else
            *tab\img\width = 0 : *tab\img\height = 0
         EndIf
      EndIf
      
      ; Расчет отступа, если присутствуют оба элемента
      If (*tab\img\width Or *tab\img\height) And 
         (*tab\txt\Width Or *tab\txt\height)
         iconSpacing = DesktopScaledX(6)
      EndIf
      
      ; 2. ВНЕШНЕЕ ПОЗИЦИОНИРОВАНИЕ ВСЕГО БЛОКА
      If vertical
         ; Вертикальный режим: складываем высоты, по ширине берем максимум
         contentH = *tab\img\height + *tab\txt\height + iconSpacing
         If *tab\img\width > *tab\txt\width
            contentW = *tab\img\width
         Else
            contentW = *tab\txt\width
         EndIf
         contentY = GetAlignPosition(*tab\align, *tab\size, contentH, padding)
      Else
         ; Горизонтальный режим: складываем ширину, по высоте берем максимум
         contentW = *tab\img\width + *tab\txt\width + iconSpacing
         If *tab\img\height > *tab\txt\height
            contentH = *tab\img\height
         Else
            contentH = *tab\txt\height
         EndIf
         contentX = GetAlignPosition(*tab\align, *tab\size, contentW, padding)
      EndIf
      
      ; 3. ВНУТРЕННЕЕ ПЕРЕСТРОЕНИЕ
      If *tab\txt\change Or isResize
         If vertical
            *tab\txt\x = (gWidth - *tab\txt\width) >> 1
            If *tab\align & #__flag_Bottom
               *tab\txt\y = contentY
            Else
               *tab\txt\y = contentY + *tab\img\height
               If *tab\img\height : *tab\txt\y + iconSpacing : EndIf
            EndIf
         Else
            *tab\txt\y = (gHeight - *tab\txt\height) >> 1
            If *tab\align & #__flag_Right
               *tab\txt\x = contentX
            Else
               *tab\txt\x = contentX + *tab\img\width
               If *tab\img\width : *tab\txt\x + iconSpacing : EndIf
            EndIf
         EndIf
         *tab\txt\change = 0
      EndIf
      
      If *tab\img\change Or isResize
         If vertical
            *tab\img\x = (gWidth - *tab\img\width) >> 1
            If *tab\align & #__flag_Bottom
               *tab\img\y = contentY + *tab\txt\height
               If *tab\txt\height : *tab\img\y + iconSpacing : EndIf
            Else
               *tab\img\y = contentY
            EndIf
         Else
            *tab\img\y = (gHeight - *tab\img\height) >> 1
            If *tab\align & #__flag_Right
               *tab\img\x = contentX + *tab\txt\width
               If *tab\txt\width : *tab\img\x + iconSpacing : EndIf
            Else
               *tab\img\x = contentX
            EndIf
         EndIf
         *tab\img\change = 0
      EndIf
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
   If *tab\img\width Or *tab\img\height
      DrawAlphaImage(ImageID(*tab\img\Image), rx + *tab\img\X, ry + *tab\img\Y)
   EndIf
   
   ; 3. ОТРИСОВКА ТЕКСТА
   If *tab\txt\Text <> ""
      DrawText(rx + *tab\txt\X, ry + *tab\txt\Y, *tab\txt\Text, $FFFFFFFF)
   EndIf
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
   
   img_x = *tab\img\x 
   img_y = *tab\img\y
   img_w = *tab\img\width
   img_h = *tab\img\height
   
   txt_x = *tab\txt\x 
   txt_y = *tab\txt\y
   txt_w = *tab\txt\width
   txt_h = *tab\txt\height
   
 
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

; Главная циклическая процедура отрисовки Canvas панели
Procedure ReDrawTabs(gadget.i, *this._s_WIDGET)
   Protected gWidth.i = DesktopScaledX(GadgetWidth(gadget))
   Protected gHeight.i = DesktopScaledY(GadgetHeight(gadget))
   
   If Not StartDrawing(CanvasOutput(gadget))
      ProcedureReturn
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255)) 
   
   DrawTabs(*this, *this\tab\press, gWidth, gHeight)
   
   StopDrawing()
EndProcedure

Procedure DoTabEvents(*this._s_WIDGET, event.i, mousePos.i)
   Protected *current_tab._s_TAB
   Protected *tab._s_TAB
   Protected accumulatedSize.i = *this\tab\indent 
   Protected isBeforeDragged.b = #True 
   Protected stepSize.i
   
   Select event
         
      Case #PB_EventType_LeftButtonDown
         *this\dragOffSet = mousePos
         
         ; ЦИКЛ 1: Находим вкладку, на которую кликнули
         ForEach *this\tab\_s()
            *tab = @*this\tab\_s()
            If mousePos >= *tab\pos And mousePos < *tab\pos + *tab\size
               *current_tab = *tab
               Break
            EndIf
         Next
         
         *this\tab\press = *current_tab
         
         ; ЦИКЛ 2: Выполняем раздвижку, лимиты и расчет стартового offset за один проход
         If *current_tab
            stepSize = *current_tab\size + *this\tab\spacing
            
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
               accumulatedSize + *tab\size + *this\tab\spacing
               
               ; 3. Ваша оригинальная пропорция инициализации offset (использует обновленный *tab\pos)
               *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
               *tab\offset - stepSize
               *tab\offset * stepSize / (*tab\size + *this\tab\spacing)
               
               ; Ограничители хода
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
            Next
            
            ; Финальная запись лимитов и проверка границ для самой перетаскиваемой вкладки
            *current_tab\minOffset = *this\tab\indent - *current_tab\pos
            *current_tab\maxOffset = -*current_tab\pos + accumulatedSize
            
            If *current_tab\offset < *current_tab\minOffset : *current_tab\offset = *current_tab\minOffset : EndIf
            If *current_tab\offset > *current_tab\maxOffset : *current_tab\offset = *current_tab\maxOffset : EndIf
            
            ProcedureReturn #True
         EndIf
         
      Case #PB_EventType_MouseMove
         *current_tab = *this\tab\press
         If *current_tab
            ForEach *this\tab\_s()
               *tab = @*this\tab\_s()
               
               If *tab = *current_tab
                  *tab\offset = mousePos - *this\dragOffSet
               Else
                  *tab\offset = *tab\pos - *current_tab\pos - *current_tab\offset
                  *tab\offset - (*current_tab\size + *this\tab\spacing)
                  *tab\offset * (*current_tab\size + *this\tab\spacing) / (*tab\size + *this\tab\spacing)
               EndIf
               
               If *tab\offset < *tab\minOffset : *tab\offset = *tab\minOffset : EndIf
               If *tab\offset > *tab\maxOffset : *tab\offset = *tab\maxOffset : EndIf
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
            
            ; Вызываем ваши внутренние процедуры обновления состояния и перерисовки
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
   Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
   Define w = 240
Else
   Define h = 40
   Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
EndIf
 
#Win = 0
#Canvas = 0

If OpenWindow(#Win, 0, 0, w + 20, h + 20, "Наглядный Демо-Пример", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(#Canvas, 10, 10, w, h)
   
   ReDrawTabs(#Canvas, @MyThis)
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = #Canvas
         If EventType() = #PB_EventType_LeftDoubleClick
            HideWindow(#Win, 1)
            MyThis\tab\vertical ! 1
            ClearList(MyThis\Tab\_s())
            AddTab(@MyThis, 0, "0 - 60", 60)
            AddTab(@MyThis, 1, "1 - 160", 160, #__flag_Center, 1)
            AddTab(@MyThis, 2, "2 - 150", 150, #__flag_Right, 1)
            AddTab(@MyThis, 3, "3 - 90", 90,0, 1)
            TotalSize(@MyThis)
            If MyThis\tab\vertical
               Define h = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
               Define w = 240
            Else
               Define h = 40
               Define w = DesktopUnscaledX(MyThis\tab\TotalSize + MyThis\tab\indent)
            EndIf
            ResizeWindow(#Win, #PB_Ignore, #PB_Ignore, w + 20, h + 20)
            ResizeGadget(#Canvas, #PB_Ignore, #PB_Ignore, w, h)
            ReDrawTabs(#Canvas, @MyThis)
            HideWindow(#Win, 0, #PB_Window_ScreenCentered)
         EndIf
         
         If MyThis\tab\vertical
            If DoTabEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY))
               ReDrawTabs(#Canvas, @MyThis)
            EndIf
         Else
            If DoTabEvents( @MyThis, EventType(), GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX))
               ReDrawTabs(#Canvas, @MyThis)
            EndIf
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 383
; FirstLine = 208
; Folding = --t------f-------
; EnableXP
; EnableOnError
; EnableUnicode