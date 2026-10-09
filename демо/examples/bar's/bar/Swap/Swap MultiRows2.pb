EnableExplicit

; Структура для описания каждой вкладки
Structure CustomTab
  Title$         ; Заголовок вкладки
  X            .l  ; Текущая координата X (рассчитывается)
  Y            .l  ; Текущая координата Y (рассчитывается)
  Width        .l  ; Ширина вкладки (зависит от текста)
  Height       .l  ; Высота вкладки
  Row          .l  ; Индекс строки, на которой лежит вкладка
EndStructure

; Структура самого элемента управления
Structure MultiRowTabControl
  CanvasID     .i
  FontID       .i
  ActiveTab    .l
  TabHeight    .l
  PaddingX     .l
  List Tabs    .CustomTab()
EndStructure

Global TabBar.MultiRowTabControl

; Добавление вкладки в список
Procedure AddCustomTab(*Control.MultiRowTabControl, Title$)
  AddElement(*Control\Tabs())
  *Control\Tabs()\Title$ = Title$
EndProcedure

; Расчет позиций вкладок (динамический перенос по строкам)
Procedure RecalculateTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID)
  Protected CurrentX = 4
  Protected CurrentY = 4
  Protected CurrentRow = 0
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    DrawingFont(*Control\FontID)
    
    ForEach *Control\Tabs()
      ; Ширина вкладки = ширина текста + внутренние отступы
      *Control\Tabs()\Width = TextWidth(*Control\Tabs()\Title$) + (*Control\PaddingX * 2)
      *Control\Tabs()\Height = *Control\TabHeight
      
      ; Если вкладка не влезает в текущую строку — переносим на следующую
      If CurrentX + *Control\Tabs()\Width > CanvasW - 4 And CurrentX > 4
        CurrentX = 4
        CurrentRow + 1
        CurrentY + *Control\TabHeight + 2 ; 2 пикселя — зазор между строками
      EndIf
      
      *Control\Tabs()\X = CurrentX
      *Control\Tabs()\Y = CurrentY
      *Control\Tabs()\Row = CurrentRow
      
      CurrentX + *Control\Tabs()\Width + 2 ; 2 пикселя — зазор между вкладками в ряду
    Next
    
    StopDrawing()
  EndIf
EndProcedure

; Отрисовка всего интерфейса на Canvas
Procedure RedrawTabs(*Control.MultiRowTabControl)
  Protected Index = 0
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    ; Очищаем фон (цвет рабочей области под вкладками)
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(240, 240, 240))
    DrawingFont(*Control\FontID)
    
    ; Рисуем вкладки
    ForEach *Control\Tabs()
      If Index = *Control\ActiveTab
        ; Активная вкладка (светлая)
        Box(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, RGB(255, 255, 255))
        ; Рамка вокруг активной
        Box(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, RGB(180, 180, 180))
        Box(*Control\Tabs()\X + 1, *Control\Tabs()\Y + 1, *Control\Tabs()\Width - 2, *Control\Tabs()\Height - 1, RGB(255, 255, 255))
        DrawText(*Control\Tabs()\X + *Control\PaddingX, *Control\Tabs()\Y + 5, *Control\Tabs()\Title$, RGB(0, 0, 0), RGB(255, 255, 255))
      Else
        ; Неактивная вкладка (серая)
        Box(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, RGB(220, 220, 220))
        Box(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, RGB(180, 180, 180))
        Box(*Control\Tabs()\X + 1, *Control\Tabs()\Y + 1, *Control\Tabs()\Width - 2, *Control\Tabs()\Height - 2, RGB(230, 230, 230))
        DrawText(*Control\Tabs()\X + *Control\PaddingX, *Control\Tabs()\Y + 5, *Control\Tabs()\Title$, RGB(50, 50, 50), RGB(230, 230, 230))
      EndIf
      Index + 1
    Next
    
    ; Рисуем разделительную линию под табами (базовая линия панели контента)
    ; В реальном приложении можно высчитать максимальный Y для отрисовки точной границы
    StopDrawing()
  EndIf
EndProcedure

; Обработка кликов мыши
Procedure HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
  Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
  Protected Index = 0
  Protected ClickedTab = -1
  
  If EventType() = #PB_EventType_LeftButtonDown
    ForEach *Control\Tabs()
      ; Проверяем, попал ли клик в границы вкладки
      If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
        If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
          ClickedTab = Index
          Break
        EndIf
      EndIf
      Index + 1
    Next
    
    ; Если выбрали новую вкладку — обновляем состояние и перерисовываем
    If ClickedTab <> -1 And ClickedTab <> *Control\ActiveTab
      *Control\ActiveTab = ClickedTab
      RedrawTabs(*Control)
      Debug "Выбрана вкладка: " + *Control\Tabs()\Title$
    EndIf
  EndIf
EndProcedure


;- --- ДЕМОНСТРАЦИЯ РАБОТЫ ---

Define Event, WindowW = 500, WindowH = 300

If OpenWindow(0, 0, 0, WindowW, WindowH, "Multi-Row Tab Canvas Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  
  ; Настройка параметров контрола
  With TabBar
    \CanvasID  = CanvasGadget(#PB_Any, 0, 0, WindowW, 80) ; Высота с запасом под 3 ряда
    \FontID    = LoadFont(0, "Segoe UI", 10)
    \TabHeight = 26
    \PaddingX  = 12
    \ActiveTab = 0
  EndWith
  
  ; Закидываем тестовые табы разной длины
  AddCustomTab(TabBar, "Главная")
  AddCustomTab(TabBar, "Настройки системы")
  AddCustomTab(TabBar, "Пользователи")
  AddCustomTab(TabBar, "База данных")
  AddCustomTab(TabBar, "Отчеты и аналитика")
  AddCustomTab(TabBar, "Логи")
  AddCustomTab(TabBar, "Плагины")
  AddCustomTab(TabBar, "О программе")
  
  ; Первичный расчет и отрисовка
  RecalculateTabs(TabBar)
  RedrawTabs(TabBar)
  
  ; Главный цикл обработки событий
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        If EventGadget() = TabBar\CanvasID
          HandleTabsEvents(TabBar)
        EndIf
        
      Case #PB_Event_SizeWindow
        ; Пересчитываем табы при изменении размеров окна
        ResizeGadget(TabBar\CanvasID, 0, 0, WindowWidth(0), 80)
        RecalculateTabs(TabBar)
        RedrawTabs(TabBar)
        
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 15
; Folding = ---
; EnableXP
; DPIAware