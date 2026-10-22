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
#_STYLE_Close = 1 << 0
#_STYLE_Minimize = 1 << 1
#_STYLE_Maximize = 1 << 2
#_STYLE_Help     = 1 << 3
#_STYLE_Pin      = 1 << 4
#_STYLE_Menu     = 1 << 5
#_STYLE_Default  = #_STYLE_Minimize | #_STYLE_Maximize|#_STYLE_Close ; Стандартная тройка кнопок

; Маски состояний виджетов
#_MASK_Hover    = 1 << 0
#_MASK_Pressed  = 1 << 1

Structure _s_POINT     : X.l : Y.l : EndStructure
Structure _s_COORDINATE Extends _s_POINT : Width.l : Height.l : EndStructure
Structure _s_IMG        Extends _s_COORDINATE : change.b : Image.i : EndStructure
Structure _s_TXT        Extends _s_COORDINATE : change.b : Text.s : EndStructure

Structure _s_TitleBar_BUTTON Extends _s_COORDINATE
   txt._s_TXT
   img._s_IMG
   type.l       
   mask.l       
EndStructure

Structure _s_TitleBar
   indent.a
   spacing.a 
   
   bar._s_TitleBar_BUTTON
   List btn._s_TitleBar_BUTTON()
   *data
EndStructure


Structure _s_WIDGET Extends _s_COORDINATE
   change.b
   padding.a
   ;    spacing.a             
   ; tab._s_TABS
   
   ; --- ИНТЕГРАЦИЯ ЗАГОЛОВКА ---
   *title._s_TitleBar ; Заголовок теперь является частью виджета!
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
Procedure UpdateTitleBar(*this._s_WIDGET)
   Protected right_x = *this\Width
   Protected *but._s_TitleBar_BUTTON
   
   ; Этот цикл считает ТОЛЬКО кнопки управления. Никаких проверок типов!
   ForEach *this\title\btn()
      *but = @*this\title\btn()
      right_x - *but\Width - *this\title\spacing
      *but\X = *this\X + right_x 
      *but\Y = *this\Y + (*this\Height - *but\Height) / 2
   Next
   
   ; Настраиваем изолированный заголовок напрямую
   If *this\title\bar
      Protected *title._s_TitleBar_BUTTON = *this\title\bar
      If ListSize(*this\title\btn())
         *title\X = *this\X
         *title\Y = *this\Y
         *title\Width = right_x - *this\title\spacing 
         *title\Height = *this\Height
      Else
         *title\X = *this\X + *this\title\spacing 
         *title\Y = *this\Y + *this\title\spacing 
         *title\Width = right_x - *this\title\spacing * 2
         *title\Height = *this\Height - *this\title\spacing * 2
      EndIf
   EndIf
EndProcedure

; Внутренняя процедура добавления элемента значка/кнопки
Procedure AddTitleBar(*t._s_TitleBar, type.l, text.s = "", image.i = 0)
   Protected._s_TitleBar_BUTTON *but
   
   If type = #_BTN_Title
      *but = @*t\bar
   Else
      *but = AddElement(*t\btn())
   EndIf

   *but\type = type
   
   If text <> ""
      *but\txt\Text = text
      *but\txt\Width = DesktopScaledX(10)
      *but\txt\Height = DesktopScaledY(10)
   EndIf
   
   *but\img\Width = DesktopScaledX(10) 
   *but\img\Height = DesktopScaledX(10)
   
   If type = #_BTN_Title
   Else
      *but\Width = DesktopScaledX(40) - *t\spacing*2
      *but\Height = *but\Width
   EndIf
EndProcedure

; Создание и инициализация заголовка окна
Procedure CreateTitleBar(*t._s_TitleBar, text.s, image.i = 0, flags.l = #_STYLE_Default)
    *t\indent = DesktopScaledX(10)
   *t\spacing = DesktopScaledX(10)
   
   ; 1. В списке btn() теперь живут ТОЛЬКО кнопки управления справа
   If flags & #_STYLE_Close :  AddTitleBar(*t, #_BTN_Close): EndIf
   If flags & #_STYLE_Maximize : AddTitleBar(*t, #_BTN_Maximize) : EndIf
   If flags & #_STYLE_Minimize : AddTitleBar(*t, #_BTN_Minimize) : EndIf
   If flags & #_STYLE_Help     : AddTitleBar(*t, #_BTN_Help)     : EndIf
   If flags & #_STYLE_Pin      : AddTitleBar(*t, #_BTN_Pin)      : EndIf
   If flags & #_STYLE_Menu     : AddTitleBar(*t, #_BTN_Menu)     : EndIf
   
   AddTitleBar(*t, #_BTN_Title, text.s, image)
EndProcedure

Procedure DrawTitleBar(*t._s_TitleBar, bgColor.l)
   ; Настройки светлой палитры
   Protected.l crossColor, symbolColor
   Protected.l defaultColor = RGBA(80, 80, 80, 255)      ; Серые значки по умолчанию (хорошая читаемость)
   Protected.l winSymbolColor = RGBA(50, 50, 50, 255)    ; Более темные значки при ховере
   Protected.l textColor = RGBA(30, 30, 30, 255)         ; Почти черный текст заголовка
   
   Protected *btn._s_TitleBar_BUTTON = *t\bar
   Protected size.l, paddingX.l, paddingY.l
   
   ; 1. Отрисовка заголовка
   If *btn\type = #_BTN_Title
      Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      size = DesktopScaledX(7)
      ; Синяя иконка-заглушка (акцентная точка)
      Circle(*btn\X + *t\indent + size, *btn\Y + *btn\Height/2, size, RGBA(0, 120, 215, 255))
      DrawText(*btn\X + *t\indent +  size + DesktopScaledX(16), *btn\Y + (*btn\Height - TextHeight(*btn\txt\Text))/2, *btn\txt\Text, textColor, 0)
   EndIf
   
   ;
   ForEach *t\btn()
      *btn = @*t\btn()
      
      size = *btn\img\Width 
      paddingX = *btn\X + (*btn\Width - size) / 2
      paddingY = *btn\Y + (*btn\Height - size) / 2
      
      Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
           
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
      
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
      Box(*btn\X, *btn\Y, *btn\Width, *btn\Height, RGBA(0, 0, 0, 20))    
      Box(*btn\X+1, *btn\Y+1, *btn\Width-2, *btn\Height-2, RGBA(0, 0, 0, 20))    
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent) 
       
   Next
EndProcedure

Procedure DoEventTitleBar( *btn._s_TitleBar_BUTTON, event )
   Protected windowID = EventWindow()
   
   Select event
      Case #PB_EventType_MouseEnter
         *btn\img\Width = DesktopScaledX(14)
         
      Case #PB_EventType_MouseLeave
         *btn\img\Width = DesktopScaledX(10)
         
      Case #PB_EventType_LeftButtonDown
         Select *btn\type
            Case #_BTN_Close    
               PostEvent(#PB_Event_CloseWindow, windowID, 0)
            Case #_BTN_Maximize 
               If GetWindowState(windowID) = #PB_Window_Maximize : SetWindowState(windowID, #PB_Window_Normal) : Else : SetWindowState(windowID, #PB_Window_Maximize) : EndIf
            Case #_BTN_Minimize : SetWindowState(windowID, #PB_Window_Minimize)
            Case #_BTN_Help     : MessageRequester("Инфо", "Нажата кнопка Справка")
            Case #_BTN_Title     
               CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  SendMessage_(WindowID(windowID), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
               CompilerEndIf
         EndSelect
         
      Case  #PB_EventType_LeftDoubleClick
         If *btn\type = #_BTN_Title
            If GetWindowState(windowID) = #PB_Window_Maximize
               SetWindowState(windowID, #PB_Window_Normal)
            Else
               SetWindowState(windowID, #PB_Window_Maximize)
            EndIf
         EndIf
   EndSelect
EndProcedure

;-
Procedure RedrawCanvas(canvasID.i, List widgets._s_WIDGET())
   Protected gWidth = DesktopScaledX(GadgetWidth(canvasID))
   Protected gHeight = DesktopScaledY(GadgetHeight(canvasID))
   Protected._s_WIDGET *this
   
   If StartDrawing(CanvasOutput(canvasID))
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      ; Заливаем холст общим светлым фоном
      Box(0, 0, gWidth, gHeight, RGBA(255, 255, 255, 255))
      
      ForEach widgets() : *this = widgets()
         If *this\fontID : DrawingFont( *this\fontID) : EndIf
         
         ; 1. Рисуем подложку под панель заголовка
         Box(*this\X, *this\Y, *this\Width, *this\Height, RGBA(230, 235, 240, 255))
         
         DrawTitleBar(*this\title, RGBA(230, 235, 240, 255))
      Next
      
      StopDrawing()
   EndIf
EndProcedure

Procedure DoEvent( *this._s_WIDGET, event, mx, my)
   Protected needRedraw = #False
   Protected *btn._s_TitleBar_BUTTON = *this\title\bar
   Protected shouldHover.b
   Static._s_TitleBar_BUTTON *hoverBTN
   
   Select event
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp
         If Bool(*btn\mask & #_MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
            *btn\mask ! #_MASK_Hover ; Переключаем тумблер ховера (XOR)
         EndIf
         
         ; Меням размеры геометрии значка
         If *btn\mask & #_MASK_Hover
            ; ТРЮК СБРОСА: Если мышь ушла с кнопок управления на главный заголовок,
            ; принудительно гасим маску и размер у старой кнопки из списка
            If *hoverBTN And *hoverBTN <> *btn
               *hoverBTN\mask &~ #_MASK_Hover
               DoEventTitleBar( *hoverBTN, #PB_EventType_MouseLeave )
            EndIf
            
            *hoverBTN = *btn
            needredraw = #True
         Else
            ; Всего ОДИН цикл для поиска и одновременного сброса/включения ховеров
            ForEach *this\title\btn()
               *btn = @*this\title\btn()
               
               ; 2. Если текущее состояние маски кнопки не совпадает с реальностью
               If Bool(*btn\mask & #_MASK_Hover) <> Bool( mx >= *btn\X And mx < *btn\X + *btn\Width And my >= *btn\Y And my < *btn\Y + *btn\Height )
                  *btn\mask ! #_MASK_Hover ; Переключаем тумблер ховера (XOR)
                  
                  ; Меням размеры геометрии значка
                  If *btn\mask & #_MASK_Hover
                     *hoverBTN = *btn
                     DoEventTitleBar( *btn, #PB_EventType_MouseEnter )
                  Else
                     *hoverBTN = 0
                     DoEventTitleBar( *btn, #PB_EventType_MouseLeave )
                  EndIf
                  needredraw = #True
               EndIf
            Next
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If *hoverBTN
            DoEventTitleBar( *hoverBTN, event )
            
            ; Пересчитываем ширину, если окно развернули одинарным кликом:
            If *hoverBTN\type = #_BTN_Maximize
               UpdateTitleBar(*this)
               needRedraw = #True
            EndIf
         EndIf
         
      Case  #PB_EventType_LeftDoubleClick
         If *hoverBTN
            If *hoverBTN\type = #_BTN_Title
               DoEventTitleBar( *hoverBTN, event )
               UpdateTitleBar(*this)
               needRedraw = #True
            EndIf
         EndIf
         
   EndSelect
   
   ProcedureReturn needRedraw
EndProcedure

Procedure Create( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l, text.s, flags.l = #_STYLE_Default, image.i = 0)
   *this\fontID = FontID(0)
   *this\X = DesktopScaledX(X)
   *this\Y = DesktopScaledY(Y)
   *this\Width = DesktopScaledX(Width)
   *this\Height = DesktopScaledY(Height)
   *this\title = AllocateStructure(_s_TitleBar)
   CreateTitleBar(*this\title, text, image, flags)
   UpdateTitleBar(*this)
EndProcedure

; =========================================================================
; 3. ОСНОВНОЙ ЦИКЛ ПРИЛОЖЕНИЯ И ИНИЦИАЛИЗАЦИЯ
; =========================================================================
NewList Windows._s_WIDGET()
; Создаем заголовки процедурно
Create(AddElement(Windows()), 10, 20, 780, 40, "Главное окно программы (Window 1)", #_STYLE_Default, 101)
Create(AddElement(Windows()), 10, 90, 780, 40, "Окно настроек системы (Window 2)", #_STYLE_Help|#_STYLE_Close, 102)
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
               
               ForEach Windows()
                  If DoEvent( @Windows(), EventType(), mx, my )
                     needRedraw = #True
                  EndIf
               Next
               
               If needRedraw 
                  RedrawCanvas(0, Windows()) 
               EndIf
            EndIf
      EndSelect
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 162
; FirstLine = 149
; Folding = ------+--
; EnableXP
; DPIAware