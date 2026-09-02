; Перечисление для ID гаджетов
Enumeration
  #WinMain
  #Canvas
  #FrameStyle
  #OptStyle1
  #OptStyle2
  #OptStyle3
  #FrameDir
  #OptUp
  #OptDown
  #OptLeft
  #OptRight
  
  ; Слайдеры
  #TxtSize : #TrkSize
  #TxtThick : #TrkThick
  
  ; Выбор цветов (Обычные кнопки + ColorRequester)
  #FrameColor
  #TxtColBg : #ColBg
  #TxtColInside : #ColInside
  #TxtColOutline : #ColOutline
EndEnumeration

; Перечисление стилей стрелок
Enumeration
  #StyleChevron    ; Объемный замкнутый уголок
  #StyleClassic    ; Классическая с ножкой
  #StyleTriangle   ; Треугольник
EndEnumeration

; Глобальные переменные для хранения цветов (RGB)
Global G_ColorBg.l      = RGB(70, 130, 180)  ; Синий фон
Global G_ColorInside.l  = RGB(255, 255, 255); Белая стрелка
Global G_ColorOutline.l = RGB(0, 0, 0)        ; Черный контур

; Константы для тестирования (замените своими, если необходимо)
#StyleChevron  = 0
#StyleClassic  = 1
#StyleTriangle = 2

; Константы стилей
#StyleChevron  = 0
#StyleClassic  = 1
#StyleTriangle = 2

; Константы стилей
#StyleChevron  = 0
#StyleClassic  = 1
#StyleTriangle = 2

Procedure DrawSingleArrowLayer(style.i, dir.i, cx.i, cy.i, size.i, color.l, sharpness.f = 1.0, thickness.i = -1)
  Protected half.i = size / 2
  Protected qtr.i  = size / 4
  Protected i.i, currentThickness.i
  
  ; Если толщина не задана, рассчитываем её автоматически (1/4 от размера)
  If thickness < 0
    currentThickness = qtr
  Else
    currentThickness = thickness
  EndIf
  If currentThickness < 1 : currentThickness = 1 : EndIf ; Защита от нулевой толщины
  
  ; Вычисляем динамический вылет (высоту) стрелки на основе остроты
  Protected nose.i = half * sharpness
  If nose < 2 : nose = 2 : EndIf
  
  ; Пропорции для классической стрелки
  Protected stemWidth.i = size / 5
  If stemWidth < 2 : stemWidth = 2 : EndIf
  ; Длина ножки подстраивается, чтобы вся стрелка вписывалась в размер
  Protected stemHeight.i = size - nose
  If stemHeight < 2 : stemHeight = 2 : EndIf
  
  Select style
      
    Case #StyleChevron ; 1. ОБЪЕМНЫЙ УГОЛОК c регулировкой остроты и толщины
      Select dir
        Case 0 ; Вверх
          For i = 0 To currentThickness - 1
            LineXY(cx - half, cy + nose - qtr - i, cx, cy - nose - i, color)
            LineXY(cx, cy - nose - i, cx + half, cy + nose - qtr - i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To currentThickness - 1
            LineXY(cx - half, cy - nose + qtr + i, cx, cy + nose + i, color)
            LineXY(cx, cy + nose + i, cx + half, cy - nose + qtr + i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To currentThickness - 1
            LineXY(cx + nose - qtr - i, cy - half, cx - nose - i, cy, color)
            LineXY(cx - nose - i, cy, cx + nose - qtr - i, cy + half, color)
          Next i
        Case 3 ; Вправо
          For i = 0 To currentThickness - 1
            LineXY(cx - nose + qtr + i, cy - half, cx + nose + i, cy, color)
            LineXY(cx + nose + i, cy, cx - nose + qtr + i, cy + half, color)
          Next i
      EndSelect
      
    Case #StyleClassic ; 2. КЛАССИЧЕСКАЯ СТРЕЛКА c регулировкой остроты шляпки
      Select dir
        Case 0 ; Вверх
          For i = 0 To nose
            LineXY(cx - (half * i / nose), cy - nose + i, cx + (half * i / nose), cy - nose + i, color)
          Next i
          Box(cx - stemWidth / 2, cy, stemWidth, stemHeight, color) 
        Case 1 ; Вниз
          For i = 0 To nose
            LineXY(cx - (half * i / nose), cy + nose - i, cx + (half * i / nose), cy + nose - i, color)
          Next i
          Box(cx - stemWidth / 2, cy - stemHeight, stemWidth, stemHeight, color)
        Case 2 ; Влево
          For i = 0 To nose
            LineXY(cx - nose + i, cy - (half * i / nose), cx - nose + i, cy + (half * i / nose), color)
          Next i
          Box(cx, cy - stemWidth / 2, stemHeight, stemWidth, color)
        Case 3 ; Вправо
          For i = 0 To nose
            LineXY(cx + nose - i, cy - (half * i / nose), cx + nose - i, cy + (half * i / nose), color)
          Next i
          Box(cx - stemHeight, cy - stemWidth / 2, stemHeight, stemWidth, color)
      EndSelect
      
    Case #StyleTriangle ; 3. МОНОЛИТНЫЙ ТРЕУГОЛЬНИК c регулировкой остроты
      Select dir
        Case 0 ; Вверх
          For i = 0 To nose * 2
            LineXY(cx - (half * i / (nose * 2)), cy - nose + i, cx + (half * i / (nose * 2)), cy - nose + i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To nose * 2
            LineXY(cx - (half * i / (nose * 2)), cy + nose - i, cx + (half * i / (nose * 2)), cy + nose - i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To nose * 2
            LineXY(cx - nose + i, cy - (half * i / (nose * 2)), cx - nose + i, cy + (half * i / (nose * 2)), color)
          Next i
        Case 3 ; Вправо
          For i = 0 To nose * 2
            LineXY(cx + nose - i, cy - (half * i / (nose * 2)), cx + nose - i, cy + (half * i / (nose * 2)), color)
          Next i
      EndSelect
      
  EndSelect
EndProcedure

Procedure DrawSingleArrowLayer5(style.i, dir.i, cx.i, cy.i, size.i, color.l, sharpness.f = 1.0)
  Protected half.i = size / 2
  Protected qtr.i  = size / 4
  Protected i.i, thickness.i
  
  ; Вычисляем динамический вылет (высоту) стрелки на основе остроты
  Protected nose.i = half * sharpness
  If nose < 2 : nose = 2 : EndIf
  
  ; Пропорции для классической стрелки
  Protected stemWidth.i = size / 5
  If stemWidth < 2 : stemWidth = 2 : EndIf
  ; Длина ножки подстраивается, чтобы вся стрелка вписывалась в размер
  Protected stemHeight.i = size - nose
  If stemHeight < 2 : stemHeight = 2 : EndIf
  
  Select style
      
    Case #StyleChevron ; 1. ОБЪЕМНЫЙ УГОЛОК c регулировкой остроты
      thickness = qtr
      If thickness < 2 : thickness = 2 : EndIf
      
      Select dir
        Case 0 ; Вверх
          For i = 0 To thickness
            LineXY(cx - half, cy + nose - qtr - i, cx, cy - nose - i, color)
            LineXY(cx, cy - nose - i, cx + half, cy + nose - qtr - i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To thickness
            LineXY(cx - half, cy - nose + qtr + i, cx, cy + nose + i, color)
            LineXY(cx, cy + nose + i, cx + half, cy - nose + qtr + i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To thickness
            LineXY(cx + nose - qtr - i, cy - half, cx - nose - i, cy, color)
            LineXY(cx - nose - i, cy, cx + nose - qtr - i, cy + half, color)
          Next i
        Case 3 ; Вправо
          For i = 0 To thickness
            LineXY(cx - nose + qtr + i, cy - half, cx + nose + i, cy, color)
            LineXY(cx + nose + i, cy, cx - nose + qtr + i, cy + half, color)
          Next i
      EndSelect
      
    Case #StyleClassic ; 2. КЛАССИЧЕСКАЯ СТРЕЛКА c регулировкой остроты шляпки
      Select dir
        Case 0 ; Вверх
          For i = 0 To nose
            LineXY(cx - (half * i / nose), cy - nose + i, cx + (half * i / nose), cy - nose + i, color)
          Next i
          Box(cx - stemWidth / 2, cy, stemWidth, stemHeight, color) 
        Case 1 ; Вниз
          For i = 0 To nose
            LineXY(cx - (half * i / nose), cy + nose - i, cx + (half * i / nose), cy + nose - i, color)
          Next i
          Box(cx - stemWidth / 2, cy - stemHeight, stemWidth, stemHeight, color)
        Case 2 ; Влево
          For i = 0 To nose
            LineXY(cx - nose + i, cy - (half * i / nose), cx - nose + i, cy + (half * i / nose), color)
          Next i
          Box(cx, cy - stemWidth / 2, stemHeight, stemWidth, color)
        Case 3 ; Вправо
          For i = 0 To nose
            LineXY(cx + nose - i, cy - (half * i / nose), cx + nose - i, cy + (half * i / nose), color)
          Next i
          Box(cx - stemHeight, cy - stemWidth / 2, stemHeight, stemWidth, color)
      EndSelect
      
    Case #StyleTriangle ; 3. МОНОЛИТНЫЙ ТРЕУГОЛЬНИК c регулировкой остроты
      Select dir
        Case 0 ; Вверх
          For i = 0 To nose * 2
            LineXY(cx - (half * i / (nose * 2)), cy - nose + i, cx + (half * i / (nose * 2)), cy - nose + i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To nose * 2
            LineXY(cx - (half * i / (nose * 2)), cy + nose - i, cx + (half * i / (nose * 2)), cy + nose - i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To nose * 2
            LineXY(cx - nose + i, cy - (half * i / (nose * 2)), cx - nose + i, cy + (half * i / (nose * 2)), color)
          Next i
        Case 3 ; Вправо
          For i = 0 To nose * 2
            LineXY(cx + nose - i, cy - (half * i / (nose * 2)), cx + nose - i, cy + (half * i / (nose * 2)), color)
          Next i
      EndSelect
      
  EndSelect
EndProcedure

Procedure DrawSingleArrowLayer4(style.i, dir.i, cx.i, cy.i, size.i, color.l)
  Protected half.i = size / 2
  Protected qtr.i  = size / 4
  Protected i.i, thickness.i
  
  ; Динамические пропорции для классической стрелки
  Protected stemWidth.i = size / 5
  If stemWidth < 2 : stemWidth = 2 : EndIf
  Protected stemHeight.i = half
  
  Select style
      
    Case #StyleChevron ; 1. ОБЪЕМНЫЙ УГОЛОК (Отрисовка со смещением для исключения дыр)
      thickness = qtr
      If thickness < 2 : thickness = 2 : EndIf
      
      Select dir
        Case 0 ; Вверх
           For i = 0 To thickness
              LineXY(cx - half, cy + qtr - i, cx, cy - half - i, color)
              LineXY(cx, cy - half - i, cx + half, cy + qtr - i, color)
           Next i
           
;            ; Пример для ОСТРОГО шеврона вверх
;            Protected wing.i = size / 3 ; Узкие крылья
;            For i = 0 To thickness
;               ; Вершина уходит далеко вперед (cy - half), а крылья узкие (cx - wing)
;               LineXY(cx - wing, cy + qtr - i, cx, cy - half - i, color)
;               LineXY(cx, cy - half - i, cx + wing, cy + qtr - i, color)
;            Next i

        Case 1 ; Вниз
          For i = 0 To thickness
            LineXY(cx - half, cy - qtr + i, cx, cy + half + i, color)
            LineXY(cx, cy + half + i, cx + half, cy - qtr + i, color)
         Next i
         
;          ; Пример для ТУПОГО шеврона вверх
;            Protected nose.i = size / 6 ; Короткий носик
;            For i = 0 To thickness
;               ; Вершина близко к центру (cy - nose), а крылья широкие (cx - half)
;               LineXY(cx - half, cy + qtr - i, cx, cy - nose - i, color)
;               LineXY(cx, cy - nose - i, cx + half, cy + qtr - i, color)
;            Next i
           
        Case 2 ; Влево
           For i = 0 To thickness
            LineXY(cx + qtr - i, cy - half, cx - half - i, cy, color)
            LineXY(cx - half - i, cy, cx + qtr - i, cy + half, color)
          Next i
        Case 3 ; Вправо
          For i = 0 To thickness
            LineXY(cx - qtr + i, cy - half, cx + half + i, cy, color)
            LineXY(cx + half + i, cy, cx - qtr + i, cy + half, color)
          Next i
      EndSelect
      
    Case #StyleClassic ; 2. КЛАССИЧЕСКАЯ СТРЕЛКА (Идеальное центрирование и стыковка)
      Select dir
        Case 0 ; Вверх
          ; Шляпка занимает верхнюю половину (от cy - half до cy)
          For i = 0 To half
            LineXY(cx - i, cy - half + i, cx + i, cy - half + i, color)
          Next i
          ; Ножка занимает нижнюю половину (от cy до cy + half)
          Box(cx - stemWidth / 2, cy, stemWidth, stemHeight, color) 
          
        Case 1 ; Вниз
          ; Шляпка занимает нижнюю половину (от cy + half до cy)
          For i = 0 To half
            LineXY(cx - i, cy + half - i, cx + i, cy + half - i, color)
          Next i
          ; Ножка занимает верхнюю половину (от cy - half до cy)
          Box(cx - stemWidth / 2, cy - stemHeight, stemWidth, stemHeight, color)
          
        Case 2 ; Влево
          ; Шляпка занимает левую половину (от cx - half до cx)
          For i = 0 To half
            LineXY(cx - half + i, cy - i, cx - half + i, cy + i, color)
          Next i
          ; Ножка занимает правую половину (от cx до cx + half)
          Box(cx, cy - stemWidth / 2, stemHeight, stemWidth, color)
          
        Case 3 ; Вправо
          ; Шляпка занимает правую половину (от cx + half до cx)
          For i = 0 To half
            LineXY(cx + half - i, cy - i, cx + half - i, cy + i, color)
          Next i
          ; Ножка занимает левую половину (от cx - half до cx)
          Box(cx - stemHeight, cy - stemWidth / 2, stemHeight, stemWidth, color)
      EndSelect
      
    Case #StyleTriangle ; 3. МОНОЛИТНЫЙ ТРЕУГОЛЬНИК (Исправлены направления и центрирование)
      Select dir
        Case 0 ; Вверх (Вершина строго в cx, cy - half; основание на cy + half)
          For i = 0 To size
            LineXY(cx - i / 2, cy - half + i, cx + i / 2, cy - half + i, color)
          Next i
        Case 1 ; Вниз (Вершина строго в cx, cy + half; основание на cy - half)
          For i = 0 To size
            LineXY(cx - i / 2, cy + half - i, cx + i / 2, cy + half - i, color)
          Next i
        Case 2 ; Влево (Вершина строго в cx - half, cy; основание на cx + half)
          For i = 0 To size
            LineXY(cx - half + i, cy - i / 2, cx - half + i, cy + i / 2, color)
          Next i
        Case 3 ; Вправо (Вершина строго в cx + half, cy; основание на cx - half)
          For i = 0 To size
            LineXY(cx + half - i, cy - i / 2, cx + half - i, cy + i / 2, color)
          Next i
      EndSelect
      
  EndSelect
EndProcedure
Procedure DrawSingleArrowLayer3(style.i, dir.i, cx.i, cy.i, size.i, color.l)
  Protected half.i = size / 2
  Protected qtr.i  = size / 4
  Protected i.i
  
  ; Рассчитываем пропорции для классической стрелки динамически
  Protected stemWidth.i = size / 5  ; Толщина ножки (всегда 1/5 от размера стрелки)
  If stemWidth < 2 : stemWidth = 2 : EndIf ; Защита от слишком тонкой линии
  Protected stemHeight.i = half     ; Высота ножки
  
  Select style
      
    Case #StyleChevron ; 1. ОБЪЕМНЫЙ УГОЛОК
      Select dir
        Case 0 ; Вверх
          For i = 0 To qtr
            LineXY(cx - half + i, cy + qtr + i, cx, cy - half + i, color)
            LineXY(cx, cy - half + i, cx + half - i, cy + qtr + i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To qtr
            LineXY(cx - half + i, cy - qtr - i, cx, cy + half - i, color)
            LineXY(cx, cy + half - i, cx + half - i, cy - qtr - i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To qtr
            LineXY(cx + qtr + i, cy - half + i, cx - half + i, cy, color)
            LineXY(cx - half + i, cy, cx + qtr + i, cy + half - i, color)
          Next i
        Case 3 ; Вправо
          For i = 0 To qtr
            LineXY(cx - qtr - i, cy - half + i, cx + half - i, cy, color)
            LineXY(cx + half - i, cy, cx - qtr - i, cy + half - i, color)
          Next i
      EndSelect
      
    Case #StyleClassic ; 2. КЛАССИЧЕСКАЯ СТРЕЛКА (Теперь с динамической ножкой)
      Select dir
        Case 0 ; Вверх
          ; Шляпка (треугольник)
          For i = 0 To half : LineXY(cx - i, cy - half + i, cx + i, cy - half + i, color) : Next 
          ; Ножка (центрированный прямоугольник снизу)
          Box(cx - stemWidth / 2, cy, stemWidth, stemHeight, color) 
        Case 1 ; Вниз
          For i = 0 To half : LineXY(cx - i, cy + half - i, cx + i, cy + half - i, color) : Next
          Box(cx - stemWidth / 2, cy - stemHeight, stemWidth, stemHeight, color)
        Case 2 ; Влево
          For i = 0 To half : LineXY(cx - half + i, cy - i, cx - half + i, cy + i, color) : Next
          Box(cx, cy - stemWidth / 2, stemHeight, stemWidth, color)
        Case 3 ; Вправо
          For i = 0 To half : LineXY(cx + half - i, cy - i, cx + half - i, cy + i, color) : Next
          Box(cx - stemHeight, cy - stemWidth / 2, stemHeight, stemWidth, color)
      EndSelect
      
    Case #StyleTriangle ; 3. МОНОЛИТНЫЙ ТРЕУГОЛЬНИК
      Select dir
        Case 0 ; Вверх
          For i = 0 To half : LineXY(cx - i, cy + half - i, cx + i, cy + half - i, color) : Next
        Case 1 ; Вниз
          For i = 0 To half : LineXY(cx - i, cy - half + i, cx + i, cy - half + i, color) : Next
        Case 2 ; Влево
          For i = 0 To half : LineXY(cx + half - i, cy - i, cx + half - i, cy + i, color) : Next
        Case 3 ; Вправо
          For i = 0 To half : LineXY(cx - half + i, cy - i, cx - half + i, cy + i, color) : Next
      EndSelect
      
  EndSelect
EndProcedure

; Функция, которая рисует ОДИН СЛОЙ стрелки (без тригонометрии)
Procedure DrawSingleArrowLayer2(style.i, dir.i, cx.i, cy.i, size.i, color.l)
  Protected half.i = size / 2
  Protected qtr.i  = size / 4
  Protected i.i
  
  ; Базовые точки для отрисовки (строятся относительно центра cx, cy)
  Select style
      
    Case #StyleChevron ; 1. ОБЪЕМНЫЙ УГОЛОК (Послойная заливка линиями)
      Select dir
        Case 0 ; Вверх
          For i = 0 To qtr
            LineXY(cx - half + i, cy + qtr + i, cx, cy - half + i, color)
            LineXY(cx, cy - half + i, cx + half - i, cy + qtr + i, color)
          Next i
        Case 1 ; Вниз
          For i = 0 To qtr
            LineXY(cx - half + i, cy - qtr - i, cx, cy + half - i, color)
            LineXY(cx, cy + half - i, cx + half - i, cy - qtr - i, color)
          Next i
        Case 2 ; Влево
          For i = 0 To qtr
            LineXY(cx + qtr + i, cy - half + i, cx - half + i, cy, color)
            LineXY(cx - half + i, cy, cx + qtr + i, cy + half - i, color)
          Next i
        Case 3 ; Вправо
          For i = 0 To qtr
            LineXY(cx - qtr - i, cy - half + i, cx + half - i, cy, color)
            LineXY(cx + half - i, cy, cx - qtr - i, cy + half - i, color)
          Next i
      EndSelect
      
    Case #StyleClassic ; 2. КЛАССИЧЕСКАЯ СТРЕЛКА (Шляпка + Ножка)
      Select dir
        Case 0 ; Вверх
          For i = 0 To half : LineXY(cx - i, cy + i, cx + i, cy + i, color) : Next ; Шляпка
          Box(cx - qtr, cy, half, half, color) ; Ножка
        Case 1 ; Вниз
          For i = 0 To half : LineXY(cx - i, cy - i, cx + i, cy - i, color) : Next
          Box(cx - qtr, cy - half, half, half, color)
        Case 2 ; Влево
          For i = 0 To half : LineXY(cx + i, cy - i, cx + i, cy + i, color) : Next
          Box(cx, cy - qtr, half, half, color)
        Case 3 ; Вправо
          For i = 0 To half : LineXY(cx - i, cy - i, cx - i, cy + i, color) : Next
          Box(cx - half, cy - qtr, half, half, color)
      EndSelect
      
    Case #StyleTriangle ; 3. МОНОЛИТНЫЙ ТРЕУГОЛЬНИК
      Select dir
        Case 0 ; Вверх
          For i = 0 To half : LineXY(cx - i, cy + half - i, cx + i, cy + half - i, color) : Next
        Case 1 ; Вниз
          For i = 0 To half : LineXY(cx - i, cy - half + i, cx + i, cy - half + i, color) : Next
        Case 2 ; Влево
          For i = 0 To half : LineXY(cx + half - i, cy - i, cx + half - i, cy + i, color) : Next
        Case 3 ; Вправо
          For i = 0 To half : LineXY(cx - half + i, cy - i, cx - half + i, cy + i, color) : Next
      EndSelect
      
  EndSelect
EndProcedure

; Главная процедура отрисовки с круговым контуром
Procedure Redraw2DArrow()
  Protected style.i, dir.i, size.i, thick.i
  Protected cx.i = 150, cy.i = 150
  Protected offsetX.i, offsetY.i
  
  ; Считываем состояние чекбоксов
  If GetGadgetState(#OptStyle1) : style = #StyleChevron
  ElseIf GetGadgetState(#OptStyle2) : style = #StyleClassic
  Else : style = #StyleTriangle
  EndIf
  
  If GetGadgetState(#OptUp) : dir = 0
  ElseIf GetGadgetState(#OptDown) : dir = 1
  ElseIf GetGadgetState(#OptLeft) : dir = 2
  Else : dir = 3
  EndIf
  
  size  = GetGadgetState(#TrkSize)
  thick = GetGadgetState(#TrkThick)
  
  If StartDrawing(CanvasOutput(#Canvas))
    ; 1. Заливаем общий фон холста
    Box(0, 0, 300, 400, G_ColorBg)
    
    ; 2. РИСУЕМ КОНТУР СО ВСЕХ СТОРОН (Трафаретный сдвиг по кругу)
    ; Сдвигаем базовую форму стрелки во всех направлениях на величину толщины (thick)
    For offsetX = -thick To thick
      For offsetY = -thick To thick
        ; Делаем скругление контура (чтобы углы обводки не были квадратными)
        If (offsetX * offsetX + offsetY * offsetY) <= (thick * thick)
          DrawSingleArrowLayer(style, dir, cx + offsetX, cy + offsetY, size, G_ColorOutline)
        EndIf
      Next offsetY
    Next offsetX
    
    ; 3. РИСУЕМ СЕРДЦЕВИНУ СТРЕЛКИ (Поверх контура строго по центру)
    DrawSingleArrowLayer(style, dir, cx, cy, size, G_ColorInside)
    
    StopDrawing()
  EndIf
EndProcedure

; Функция для синхронизации цветов кнопок
Procedure UpdateButtonColors()
  SetGadgetColor(#ColBg, #PB_Gadget_BackColor, G_ColorBg)
  SetGadgetColor(#ColInside, #PB_Gadget_BackColor, G_ColorInside)
  SetGadgetColor(#ColOutline, #PB_Gadget_BackColor, G_ColorOutline)
EndProcedure

; Создание окна
If OpenWindow(#WinMain, 100, 100, 520, 420, "2DDrawing Скроллбар Стрелки", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CanvasGadget(#Canvas, 10, 10, 300, 400)
  
  ; Панель форм
  FrameGadget(#FrameStyle, 320, 10, 190, 85, "Форма / Вид")
  OptionGadget(#OptStyle1, 330, 25, 170, 20, "Объемный уголок")
  OptionGadget(#OptStyle2, 330, 45, 170, 20, "Классическая")
  OptionGadget(#OptStyle3, 330, 65, 170, 20, "Треугольник")
  SetGadgetState(#OptStyle1, 1)
  
  ; Панель поворотов
  FrameGadget(#FrameDir, 320, 105, 190, 105, "Направление")
  OptionGadget(#OptUp, 330, 120, 170, 20, "Вверх (0°)")
  OptionGadget(#OptDown, 330, 140, 170, 20, "Вниз (180°)")
  OptionGadget(#OptLeft, 330, 160, 170, 20, "Влево (90°L)")
  OptionGadget(#OptRight, 330, 180, 170, 20, "Вправо (90°R)")
  SetGadgetState(#OptUp, 1)
  
  ; Ползунки
  TextGadget(#TxtSize, 320, 220, 190, 15, "Размер стрелки:")
  TrackBarGadget(#TrkSize, 320, 235, 190, 25, 5, 100)
  SetGadgetState(#TrkSize, 50)
  
  TextGadget(#TxtThick, 320, 265, 190, 15, "Толщина контура:")
  TrackBarGadget(#TrkThick, 320, 280, 190, 25, 1, 20)
  SetGadgetState(#TrkThick, 3)
  
  ; Цветовая схема
  FrameGadget(#FrameColor, 320, 310, 190, 100, "Цветовая схема")
  TextGadget(#TxtColBg, 330, 330, 110, 20, "Цвет фона:")
  ButtonGadget(#ColBg, 460, 328, 40, 18, "") 
  TextGadget(#TxtColInside, 330, 355, 110, 20, "Цвет стрелки:")
  ButtonGadget(#ColInside, 460, 353, 40, 18, "") 
  TextGadget(#TxtColOutline, 330, 380, 110, 20, "Цвет контура:")
  ButtonGadget(#ColOutline, 460, 378, 40, 18, "") 
  
  UpdateButtonColors()
  Redraw2DArrow()
  
  ; Цикл событий
  Repeat
    Define Event = WaitWindowEvent()
    If Event = #PB_Event_Gadget
      Define Gadget = EventGadget()
      
      Select Gadget
        Case #ColBg
          Define TempColor = ColorRequester(G_ColorBg)
          If TempColor <> -1 : G_ColorBg = TempColor : UpdateButtonColors() : Redraw2DArrow() : EndIf
        Case #ColInside
          TempColor = ColorRequester(G_ColorInside)
          If TempColor <> -1 : G_ColorInside = TempColor : UpdateButtonColors() : Redraw2DArrow() : EndIf
        Case #ColOutline
          TempColor = ColorRequester(G_ColorOutline)
          If TempColor <> -1 : G_ColorOutline = TempColor : UpdateButtonColors() : Redraw2DArrow() : EndIf
        Case #OptStyle1, #OptStyle2, #OptStyle3, #OptUp, #OptDown, #OptLeft, #OptRight, #TrkSize, #TrkThick
          Redraw2DArrow()
      EndSelect
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 149
; FirstLine = 132
; Folding = ---------
; EnableXP
; DPIAware