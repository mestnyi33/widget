EnableExplicit

Structure CustomTab
  Title$       ;.s
  X            .l
  Y            .l
  Width        .l
  Height       .l
  Row          .l
EndStructure

Structure MultiRowTabControl
  CanvasID     .i
  FontID       .i
  ActiveTab    .l
  TabHeight    .l
  PaddingX     .l
  List Tabs    .CustomTab()
EndStructure

Global TabBar.MultiRowTabControl

Procedure AddCustomTab(*Control.MultiRowTabControl, Title$)
  AddElement(*Control\Tabs())
  *Control\Tabs()\Title$ = Title$
EndProcedure

Global Slant = 20 ; Экстремальный наклон боковин
  
Procedure RecalculateTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID)
  Protected CurrentX = 4
  Protected CurrentY = 6
  Protected CurrentRow = 0
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    DrawingFont(*Control\FontID)
    
    ForEach *Control\Tabs()
      ; Для стиля Chrome 1.0 нужен большой запас под пологие скосы (20 пикселей с каждой стороны)
      *Control\Tabs()\Width = TextWidth(*Control\Tabs()\Title$) + (*Control\PaddingX * 2) + 40
      *Control\Tabs()\Height = *Control\TabHeight
      
      ; Если не влезает в ряд — перенос
      If CurrentX + *Control\Tabs()\Width > CanvasW - 10 And CurrentX > 4
        CurrentX = 4
        CurrentRow + 1
        CurrentY + *Control\TabHeight + 2
      EndIf
      
      *Control\Tabs()\X = CurrentX
      *Control\Tabs()\Y = CurrentY
      *Control\Tabs()\Row = CurrentRow
      
      ; Вкладки старого Chrome сильно перекрывали друг друга в основании (нахлёст 18 пикселей)
      CurrentX + *Control\Tabs()\Width - Slant/3*4
    Next
    
    StopDrawing()
  EndIf
EndProcedure

; Процедура отрисовки культовой трапеции Chrome 2008 года
Procedure DrawOldChromeTab(X, Y, W, H, IsActive)
  Protected i, dy
  Protected OuterBorder = RGB(130, 140, 150) ; Внешняя темная рамка
  Protected InnerHighlight = RGB(255, 255, 255) ; Светлый блик
  
  ; Наклон не может быть больше высоты для корректного попиксельного расчета
  If Slant > H: Slant = H: EndIf
  
  ; 1. Заливка тела вкладки
  If IsActive
    ; Активная вкладка — чисто белая
    FrontColor(RGB(255, 255, 255))
    ; Заливаем построчно сверху вниз по всей высоте H
    For dy = 0 To H - 1
      ; Вычисляем сдвиг для текущей строки в зависимости от высоты
      Protected CurrentSlant = Slant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy)
    Next
  Else
    ; Неактивная вкладка — ретро серо-голубой вертикальный градиент
    For dy = 0 To H - 1
      Protected Factor.f = dy / (H - 1)
      ; Градиент от светлого к чуть более темному
      Protected R = 215 + (190 - 215) * Factor
      Protected G = 225 + (205 - 225) * Factor
      Protected B = 240 + (220 - 240) * Factor
      
      ; Вычисляем сдвиг под наклон
      CurrentSlant = Slant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy, RGB(R, G, B))
    Next
  EndIf
  
  ; 2. Рисуем рамки и блики для придания объема
  ; Внешний темный контур
  FrontColor(OuterBorder)
  LineXY(X, Y + H - 1, X + Slant, Y)             ; Левый пологий скос
  LineXY(X + Slant, Y, X + W - Slant, Y)         ; Верх
  LineXY(X + W - Slant, Y, X + W, Y + H - 1)     ; Правый пологий скос
  
  ; Внутренний светлый контур (только для активной, добавляет объем)
  If IsActive
    FrontColor(InnerHighlight)
    LineXY(X + 2, Y + H - 1, X + Slant + 1, Y + 1)
    LineXY(X + Slant + 1, Y + 1, X + W - Slant - 1, Y + 1)
    LineXY(X + W - Slant - 1, Y + 1, X + W - 2, Y + H - 1)
  EndIf
  
  ; Нижнее замыкание рамки для неактивных табов
  If Not IsActive
    LineXY(X, Y + H - 1, X + W, Y + H - 1, OuterBorder)
  EndIf
EndProcedure
Procedure _DrawOldChromeTab(X, Y, W, H, IsActive)
  Protected Slant = 28 ; Экстремальный наклон боковин
  Protected i, dy
  Protected OuterBorder = RGB(130, 140, 150) ; Внешняя темная рамка
  Protected InnerHighlight = RGB(255, 255, 255) ; Светлый блик
  
  ; 1. Заливка тела вкладки
  If IsActive
    ; Активная вкладка — чисто белая
    FrontColor(RGB(255, 255, 255))
    For i = 0 To Slant
      LineXY(X + Slant - i, Y + i, X + W - Slant + i, Y + i)
    Next
    Box(X, Y + Slant, W, H - Slant, RGB(255, 255, 255))
  Else
    ; Неактивная вкладка — ретро серо-голубой вертикальный градиент
    For dy = 0 To H
      Protected Factor.f = dy / H
      ; Градиент от светлого к чуть более темному
      Protected R = 215 + (190 - 215) * Factor
      Protected G = 225 + (205 - 225) * Factor
      Protected B = 240 + (220 - 240) * Factor
      
      ; Распрямляем ширину строки градиента в зависимости от высоты (по форме трапеции)
      If dy < Slant
        LineXY(X + Slant - dy, Y + dy, X + W - Slant + dy, Y + dy, RGB(R, G, B))
      Else
        LineXY(X, Y + dy, X + W, Y + dy, RGB(R, G, B))
      EndIf
    Next
  EndIf
  
  ; 2. Рисуем рамки и блики для придания объема
  ; Внешний темный контур
  FrontColor(OuterBorder)
  LineXY(X, Y + H - 1, X + Slant, Y)             ; Левый пологий скос
  LineXY(X + Slant, Y, X + W - Slant, Y)         ; Верх
  LineXY(X + W - Slant, Y, X + W, Y + H - 1)     ; Правый пологий скос
  
  ; Внутренний светлый контур (только для активной или верхней части неактивной для объема)
  If IsActive
    FrontColor(InnerHighlight)
    LineXY(X + 1, Y + H - 1, X + Slant + 1, Y + 1)
    LineXY(X + Slant + 1, Y + 1, X + W - Slant - 1, Y + 1)
    LineXY(X + W - Slant - 1, Y + 1, X + W - 1, Y + H - 1)
  EndIf
  
  ; Нижнее замыкание
  If Not IsActive
    LineXY(X, Y + H - 1, X + W, Y + H - 1, OuterBorder)
  EndIf
EndProcedure

Procedure RedrawTabs(*Control.MultiRowTabControl)
  Protected Index = 0
  Protected CanvasW = GadgetWidth(*Control\CanvasID)
  Protected CanvasH = GadgetHeight(*Control\CanvasID)
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    ; Фирменный серо-голубой фон панели Windows XP / Vista тех времен
    Box(0, 0, CanvasW, CanvasH, RGB(180, 195, 215))
    DrawingFont(*Control\FontID)
    
    ; Шаг 1: Отрисовка неактивных вкладок
    Index = 0
    ForEach *Control\Tabs()
      If Index <> *Control\ActiveTab
        DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False)
        ; Текст неактивной вкладки (с легким размытием фона под ним)
        DrawText(*Control\Tabs()\X + *Control\PaddingX + 20, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, RGB(60, 70, 80), RGB(205, 215, 230))
      EndIf
      Index + 1
    Next
    
    ; Шаг 2: Отрисовка активной вкладки поверх
    Index = 0
    ForEach *Control\Tabs()
      If Index = *Control\ActiveTab
        DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #True)
        ; Текст активной вкладки (четкий черный на белом)
        DrawText(*Control\Tabs()\X + *Control\PaddingX + 20, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, RGB(0, 0, 0), RGB(255, 255, 255))
        Break
      EndIf
      Index + 1
    Next
    
    ; Базовая линия под всеми табами, отделяющая их от контента (белая, так как активный таб белый)
    LineXY(0, CanvasH - 1, CanvasW, CanvasH - 1, RGB(130, 140, 150))
    
    StopDrawing()
  EndIf
EndProcedure

Procedure HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
  Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
  Protected Index = 0
  Protected ClickedTab = -1
  
  If EventType() = #PB_EventType_LeftButtonDown
    ; Перебор с конца списка для корректного отслеживания наложения
    LastElement(*Control\Tabs())
    Index = ListSize(*Control\Tabs()) - 1
    
    Repeat
      ; Простая прямоугольная проверка для клика (для идеальной точности пологих скосов 
      ; можно добавить проверку попадания в треугольники, но для табов обычно хватает и этого)
      If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
        If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
          ClickedTab = Index
          Break
        EndIf
      EndIf
      Index - 1
    Until PreviousElement(*Control\Tabs()) = 0
    
    If ClickedTab <> -1 And ClickedTab <> *Control\ActiveTab
      *Control\ActiveTab = ClickedTab
      RedrawTabs(*Control)
    EndIf
  EndIf
EndProcedure


;- --- ТЕСТОВЫЙ СТЕНД ---

Define Event, WindowW = 600, WindowH = 350

If OpenWindow(0, 0, 0, WindowW, WindowH, "Google Chrome 1.0 (2008) Multi-Row Canvas Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  
  With TabBar
    \CanvasID  = CanvasGadget(#PB_Any, 0, 0, WindowW, 70) ; Панель вкладок
    \FontID    = LoadFont(0, "Tahoma", 12) ; В первом хроме на Windows использовалась Tahoma/Segoe UI
    \TabHeight = 29
    \PaddingX  = 6
    \ActiveTab = 0
  EndWith
  
  ; Добавляем вкладки из эпохи 2008 года :)
  AddCustomTab(TabBar, "Google Chrome 1.0")
  AddCustomTab(TabBar, "Добро пожаловать в Интернет")
  AddCustomTab(TabBar, "Habrahabr.ru")
  AddCustomTab(TabBar, "Скачать Winamp")
  AddCustomTab(TabBar, "YouTube: Evolution of Dance")
  AddCustomTab(TabBar, "ВКонтакте (vkontakte.ru)")
  AddCustomTab(TabBar, "BASH.ORG.RU")
  
  RecalculateTabs(TabBar)
  RedrawTabs(TabBar)
  
  ; Зальем рабочую область под табами белым цветом, чтобы активный таб с ней сливался
  SetWindowColor(0, RGB(255, 255, 255))
  
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        If EventGadget() = TabBar\CanvasID
          HandleTabsEvents(TabBar)
        EndIf
        
      Case #PB_Event_SizeWindow
        ResizeGadget(TabBar\CanvasID, 0, 0, WindowWidth(0), 70)
        RecalculateTabs(TabBar)
        RedrawTabs(TabBar)
        
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 116
; FirstLine = 12
; Folding = 4e---
; EnableXP