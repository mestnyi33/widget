; =========================================================================
; 1. КОНСТАНТЫ, ПЕРЕЧИСЛЕНИЯ И СТРУКТУРЫ
; =========================================================================

Enumeration
   #_BTN_Title    ; Сам заголовок (Иконка + Текст). Занимает всё свободное место!
                  ; --- Кнопки управления (выстраиваются справа) ---
   #_BTN_Close
   #_BTN_Maximize
   #_BTN_Minimize
   #_BTN_Help        
   #_BTN_Pin         
   #_BTN_Menu        
EndEnumeration

; Битовые флаги для процедурного создания заголовка
#_STYLE_Minimize = 1 << 0
#_STYLE_Maximize = 1 << 1
#_STYLE_Help     = 1 << 2
#_STYLE_Pin      = 1 << 3
#_STYLE_Menu     = 1 << 4
#_STYLE_Default  = #_STYLE_Minimize | #_STYLE_Maximize ; Стандартная тройка кнопок

; Маски состояний виджетов
#_MASK_Hover    = 1 << 0
#_MASK_Pressed  = 1 << 1

Structure _s_POINT     : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_IMG        Extends _s_COORDINATE : change.b : Image.i : EndStructure
Structure _s_TXT        Extends _s_COORDINATE : change.b : Text.s : EndStructure

Structure _s_TITLEBAR_BUTTON Extends _s_COORDINATE
   txt._s_TXT
   img._s_IMG
   type.l       
   mask.l       
EndStructure

Structure _s_TITLEBAR
   indent.a
   spacing.a 
   
   ;*bar._s_TITLEBAR_BUTTON
   List btn._s_TITLEBAR_BUTTON()
   *data
EndStructure


Structure _s_WIDGET Extends _s_COORDINATE
   change.b
   padding.a
   ;    spacing.a             
  ; tab._s_TABS
   
   ; --- ИНТЕГРАЦИЯ ЗАГОЛОВКА ---
   *title._s_TITLEBAR ; Заголовок теперь является частью виджета!
   ; ----------------------------
   
   dragOffSet.i     ; Точка захвата мыши
   canvasID     .i  
   fontID       .i  
   bgcolor      .l  ; Наш фон холста
EndStructure

LoadFont(0, "tahoma", 12)
   
; =========================================================================
; 2. ПРОЦЕДУРНЫЙ ДВИЖОК ЗАГОЛОВКА (СВЕТЛАЯ ПАЛИТРА)
; =========================================================================

; Расчет геометрии (расстановка элементов)
Procedure UpdateTitlebar(*this._s_WIDGET)
   Protected right_x = *this\Width ;+ *this\title\spacing - *this\title\indent   
   Protected *title._s_TITLEBAR_BUTTON = 0
   Protected *but._s_TITLEBAR_BUTTON
   
   ForEach *this\title\btn()
      *but = @*this\title\btn()
      
      If *but\type = #_BTN_Title
         *title = *but 
      Else
         right_x - *but\Width - *this\title\spacing
         *but\X = *this\X + right_x 
         *but\Y = *this\Y + (*this\Height - *but\Height) / 2
      EndIf
   Next
   
   If *title
      *title\X = *this\X + *this\title\indent - *this\title\spacing
      *title\Y = *this\Y
      *title\Width = right_x - *this\title\indent 
      *title\Height = *this\Height
   EndIf
EndProcedure

; Внутренняя процедура добавления элемента значка/кнопки
Procedure AddTitlebarElement(*titlebar._s_TITLEBAR, type.l, text.s = "", image.i = 0)
   Protected._s_TITLEBAR_BUTTON *but = AddElement(*titlebar\btn())
   
   *but\type = type
    
   If text <> ""
      *but\txt\Text = text
      *but\txt\Width = DesktopScaledX(10)
      *but\txt\Height = DesktopScaledY(10)
   EndIf
   
   If type = #_BTN_Title
      *but\img\Width = DesktopScaledX(10) 
      *but\img\Height = DesktopScaledX(10)
   Else
      *but\Width = DesktopScaledX(40) - *titlebar\spacing
      *but\Height = *but\Width
      *but\img\Width = DesktopScaledX(10) 
      *but\img\Height = DesktopScaledX(10)
   EndIf
EndProcedure

; Создание и инициализация заголовка окна
Procedure CreateTitlebar(*titlebar._s_TITLEBAR, text.s, image.i = 0, flags.l = #_STYLE_Default)
   ;*titlebar\indent = DesktopScaledX(6)
   *titlebar\spacing = DesktopScaledX(4)
   
   ; 1. Кнопка закрытия окна — добавляется первой, чтобы встать на самый край справа
   AddTitlebarElement(*titlebar, #_BTN_Close)
   
   ; 2. Системные кнопки добавляются в порядке справа налево (ближе к центру)
   If flags & #_STYLE_Maximize : AddTitlebarElement(*titlebar, #_BTN_Maximize) : EndIf
   If flags & #_STYLE_Minimize : AddTitlebarElement(*titlebar, #_BTN_Minimize) : EndIf
   If flags & #_STYLE_Help     : AddTitlebarElement(*titlebar, #_BTN_Help)     : EndIf
   If flags & #_STYLE_Pin      : AddTitlebarElement(*titlebar, #_BTN_Pin)      : EndIf
   If flags & #_STYLE_Menu     : AddTitlebarElement(*titlebar, #_BTN_Menu)     : EndIf
   
   ; 3. Сам заголовок добавляется последним — он заберет всё оставшееся место слева
   AddTitlebarElement(*titlebar, #_BTN_Title, text, image)
EndProcedure

Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, text.s, flags.l = #_STYLE_Default, image.i = 0)
   *this\fontID = FontID(0)
   *this\X = DesktopScaledX(X)
   *this\Y = DesktopScaledY(Y)
   *this\Width = DesktopScaledX(Width)
   *this\Height = DesktopScaledY(Height)
   *this\title = AllocateStructure(_s_TITLEBAR)
   CreateTitlebar(*this\title, text, image, flags)
   UpdateTitlebar(*this)
EndProcedure

; Обработка мыши (Ховер + Изменение размеров значков)
Procedure.b TitlebarMouseMove(*titlebar._s_TITLEBAR, mx.i, my.i)
   Protected needredraw.b = #False
   Protected *btn._s_TITLEBAR_BUTTON
   Protected shouldHover.b
   
   ; Всего ОДИН цикл для поиска и одновременного сброса/включения ховеров
   ForEach *titlebar\btn()
      *btn = @*titlebar\btn()
      ; Debug ""+*btn\X +" "+ *btn\Y +" "+ *btn\Width +" "+ *btn\Height
      
      ; 1. Проверяем, находится ли мышь над ЭТОЙ конкретной кнопкой (исключая заголовок)
      If mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height And *btn\type <> #_BTN_Title
         shouldHover = #True
      Else
         shouldHover = #False
      EndIf
      
      ; 2. Если текущее состояние маски кнопки не совпадает с реальностью
      If Bool(*btn\mask & #_MASK_Hover) <> shouldHover
         *btn\mask ! #_MASK_Hover ; Переключаем тумблер ховера (XOR)
         needredraw = #True
        
         ; Меням размеры геометрии значка
         If shouldHover
            *btn\img\Width = DesktopScaledX(14)
         Else
            *btn\img\Width = DesktopScaledX(10)
         EndIf
      EndIf
   Next
   
   ProcedureReturn needredraw
EndProcedure

; Обработчик кликов и драга окна
Procedure TitlebarInput(*titlebar._s_TITLEBAR, windowID.i, eventType.l, mx.i, my.i)
   Protected *pressed_btn._s_TITLEBAR_BUTTON = 0
   Protected *btn._s_TITLEBAR_BUTTON
   
   ForEach *titlebar\btn()
      *btn = @*titlebar\btn()
      If mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height
         *pressed_btn = *btn
         Break
      EndIf
   Next
   
   If *pressed_btn
      If *pressed_btn\type = #_BTN_Title
         If eventType = #PB_EventType_LeftDoubleClick
            If GetWindowState(windowID) = #PB_Window_Maximize
               SetWindowState(windowID, #PB_Window_Normal)
            Else
               SetWindowState(windowID, #PB_Window_Maximize)
            EndIf
         ElseIf eventType = #PB_EventType_LeftButtonDown
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
               SendMessage_(WindowID(windowID), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
            CompilerEndIf
         EndIf
      ElseIf eventType = #PB_EventType_LeftButtonDown
         Select *pressed_btn\type
            Case #_BTN_Close    : PostEvent(#PB_Event_CloseWindow, windowID, 0)
               Case #_BTN_Maximize : If GetWindowState(windowID) = #PB_Window_Maximize : SetWindowState(windowID, #PB_Window_Normal) : Else : SetWindowState(windowID, #PB_Window_Maximize) : EndIf
            Case #_BTN_Minimize : SetWindowState(windowID, #PB_Window_Minimize)
            Case #_BTN_Help     : MessageRequester("Инфо", "Нажата кнопка Справка")
         EndSelect
      EndIf
   EndIf
EndProcedure

; Глобальная отрисовка Canvas (СВЕТЛЫЙ фон)
Procedure DrawTitlebarButton(*btn._s_TITLEBAR_BUTTON, bgColor.l)
   ; Настройки светлой палитры
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(140, 140, 140, 255)   ; Серые значки по умолчанию
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Темные значки при ховере
   
   Protected size.l, paddingX.l, paddingY.l
   
   size = *btn\img\Width 
   paddingX = *btn\X + (*btn\Width - size) / 2
   paddingY = *btn\Y + (*btn\Height - size) / 2
   
   ; 1. Обработка фона кнопок при наведении (Ховер)
   If *btn\mask & #_MASK_Hover
      If *btn\type = #_BTN_Close
         Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) ; Красный ховер закрытия
         crossColor = RGBA(255, 255, 255, 255) 
      Else
         Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    ; Мягкое затемнение
         symbolColor = winSymbolColor
      EndIf
   Else
      crossColor = defaultColor
      symbolColor = defaultColor
   EndIf
   
   ; 2. Отрисовка значков по вашему 2D-методу со смещением пикселей
   Select *btn\type
      Case #_BTN_Title
         Protected textColor = RGBA(30, 30, 30, 255) ; Почти черный текст заголовка
         
         ; Рисуем заглушку «иконки приложения» (акцентный синий кружок)
         Circle(*btn\X + DesktopScaledX(10), *btn\Y + *btn\Height / 2, DesktopScaledX(7), RGBA(0, 120, 215, 255))
         
         ; Начисто выводим текст окна, центрируя его по вертикали
         DrawText(*btn\X + DesktopScaledX(24), *btn\Y + (*btn\Height - TextHeight(*btn\txt\Text)) / 2, *btn\txt\Text, textColor, 0)
         
      Case #_BTN_Close
         LineXY(paddingX,        paddingY, paddingX + size,     paddingY + size, crossColor)
         LineXY(paddingX + 1,    paddingY, paddingX + size + 1, paddingY + size, crossColor)
         LineXY(paddingX + size,     paddingY, paddingX,        paddingY + size, crossColor)
         LineXY(paddingX + size - 1, paddingY, paddingX - 1,    paddingY + size, crossColor)
         
      Case #_BTN_Minimize
         LineXY(paddingX, paddingY + size - 1, paddingX + size, paddingY + size - 1, symbolColor)
         LineXY(paddingX, paddingY + size,     paddingX + size, paddingY + size,     symbolColor)
         
      Case #_BTN_Maximize
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         Box(paddingX, paddingY, size, size, symbolColor)
         Box(paddingX + 1, paddingY + 1, size - 2, size - 2, symbolColor) 
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
         
      Case #_BTN_Help
         DrawText(paddingX + 1, paddingY - 2, "?", symbolColor, 0)
   EndSelect
EndProcedure

Procedure DrawTitlebarButtons(*titlebar._s_TITLEBAR, bgColor.l)
   ; Настройки светлой палитры
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(80, 80, 80, 255)      ; Серые значки по умолчанию (хорошая читаемость)
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Более темные значки при ховере
   Protected.l textColor = RGBA(30, 30, 30, 255)         ; Почти черный текст заголовка
   
   Protected *btn._s_TITLEBAR_BUTTON
   Protected size.l, paddingX.l, paddingY.l
   
   ForEach *titlebar\btn()
      *btn = @*titlebar\btn()
      
      size = *btn\img\Width 
      paddingX = *btn\X + (*btn\Width - size) / 2
      paddingY = *btn\Y + (*btn\Height - size) / 2
      
      Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      
      ; 1. Отрисовка текста заголовка
      If *btn\type = #_BTN_Title
         ; Синяя иконка-заглушка (акцентная точка)
         Circle(*btn\X + DesktopScaledX(10), *btn\Y + *btn\Height/2, DesktopScaledX(7), RGBA(0, 120, 215, 255))
         DrawText(*btn\X + DesktopScaledX(24), *btn\Y + (*btn\Height - TextHeight(*btn\txt\Text))/2, *btn\txt\Text, textColor, 0)
         Continue
      EndIf
      
      
      ; 2. Обработка фона кнопок при наведении (Ховер в светлой теме)
      If *btn\mask & #_MASK_Hover
         If *btn\type = #_BTN_Close
            ; Классический красный ховер закрытия (не меняется, но крестик становится белым)
            Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(232, 17, 35, 255)) 
            crossColor = RGBA(255, 255, 255, 255) 
         Else
            ; Мягкий полупрозрачный серый ховер для остальных кнопок под светлую тему
            Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
            symbolColor = winSymbolColor
         EndIf
      Else
         crossColor = defaultColor
         symbolColor = defaultColor
      EndIf
      
      ; 3. Отрисовка значков
      Select *btn\type
         Case #_BTN_Close ; Жирный крестик со смещением
            LineXY(paddingX,        paddingY, paddingX + size,     paddingY + size, crossColor)
            LineXY(paddingX + 1,    paddingY, paddingX + size + 1, paddingY + size, crossColor)
            LineXY(paddingX + size,     paddingY, paddingX,        paddingY + size, crossColor)
            LineXY(paddingX + size - 1, paddingY, paddingX - 1,    paddingY + size, crossColor)
            
         Case #_BTN_Minimize ; Черточка
            LineXY(paddingX, paddingY + size - 1, paddingX + size, paddingY + size - 1, symbolColor)
            LineXY(paddingX, paddingY + size,     paddingX + size, paddingY + size,     symbolColor)
            
         Case #_BTN_Maximize ; Квадрат
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
            Box(paddingX, paddingY, size, size, symbolColor)
            Box(paddingX + 1, paddingY + 1, size - 2, size - 2, symbolColor) 
            DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
            
         Case #_BTN_Help ; Знак вопроса
            DrawText(paddingX + DesktopScaledX(1), paddingY - DesktopScaledY(2), "?", symbolColor, 0)
      EndSelect
   Next
EndProcedure

Procedure RedrawCanvas(canvasID.i, List widgets._s_WIDGET())
   Protected gWidth = DesktopScaledX(GadgetWidth(canvasID))
   Protected gHeight = DesktopScaledY(GadgetHeight(canvasID))
   Protected._s_WIDGET *this
   
   If StartDrawing(CanvasOutput(canvasID))
      ; Общий фон приложения — светлый (белый или почти белый)
      Box(0, 0, gWidth, gHeight, RGBA(245, 245, 245, 255))
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      
      ForEach widgets() : *this = widgets()
         If *this\fontID : DrawingFont( *this\fontID) : EndIf
         
         ; Сами плашки заголовков — аккуратного светло-серого цвета
         Box(*this\X, *this\Y, *this\Width, *this\Height, RGBA(230, 235, 240, 255))
         DrawTitlebarButtons(*this\title, RGBA(230, 235, 240, 255))
            
;          ; 2. Отрисовываем сам текст заголовка и иконку из изолированного *bar
;          DrawTitlebarButton(@*this\title\bar, RGBA(230, 235, 240, 255))
;          
;          ; 3. Отрисовываем системные кнопки, передавая список напрямую из структуры виджета
;          ForEach *this\title\btn()
;             DrawTitlebarButton(@*this\title\btn(), RGBA(230, 235, 240, 255))
;          Next
Next
      
      StopDrawing()
   EndIf
EndProcedure

; =========================================================================
; 3. ОСНОВНОЙ ЦИКЛ ПРИЛОЖЕНИЯ И ИНИЦИАЛИЗАЦИЯ
; =========================================================================
NewList Windows._s_WIDGET()
; Создаем заголовки процедурно
Create(AddElement(Windows()), 10, 20, 780, 40, "Главное окно программы (Window 1)", #_STYLE_Default, 101)
Create(AddElement(Windows()), 10, 90, 780, 40, "Окно настроек системы (Window 2)", #_STYLE_Help, 102)
Create(AddElement(Windows()), 10, 160, 780, 40, "Информационное сообщение (Window 3)", 0, 103)

Define Event.i, mx.i, my.i, needRedraw.b
If OpenWindow(0, 0, 0, 800, 230, "Light Titlebar Custom UI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 800, 230)
   RedrawCanvas(0, Windows())
   Repeat
      Event = WaitWindowEvent()
      Select Event
         Case #PB_Event_Gadget
            If EventGadget() = 0
               mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
               my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
               Select EventType()
                  Case #PB_EventType_MouseMove
                     needRedraw = #False
                     ForEach Windows()
                        If TitlebarMouseMove(Windows()\title, mx, my)
                           needRedraw = #True
                        EndIf
                     Next
                     If needRedraw : RedrawCanvas(0, Windows()) : EndIf
                  Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftDoubleClick
                     ForEach Windows()
                        TitlebarInput(Windows()\title, 0, EventType(), mx, my)
                     Next
                     ForEach Windows() : UpdateTitlebar(Windows()) : Next
                     RedrawCanvas(0, Windows())
               EndSelect
            EndIf
      EndSelect
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 281
; FirstLine = 260
; Folding = ------0--
; EnableXP
; DPIAware