EnableExplicit

; Структура вкладки (с суффиксом $ и типами .i)
Structure CustomTab
  Title$       
  X            .i  
  Y            .i
  Width        .i
  Height       .i
  Row          .i
  ContainerID  .i ; ID контейнера, привязанного к этой вкладке
EndStructure

; Структура контрола
Structure MultiRowTabControl
  CanvasID     .i  
  FontID       .i  
  *active   .CustomTab 
  TabHeight    .i
  PaddingX     .i
  List Tabs    .CustomTab()
EndStructure

Global TabBar.MultiRowTabControl
Global Slant = 20 
Global bottom_size = 2

; Добавление вкладки и автоматическое создание её контейнера под холстом
Procedure AddCustomTab(*Control.MultiRowTabControl, Title$, WindowID, CanvasHeight)
  AddElement(*Control\Tabs())
  *Control\Tabs()\Title$ = Title$
  
  ; Создаем скрытый контейнер под размеры окна (ниже холста)
  ; Внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
  *Control\Tabs()\ContainerID = ContainerGadget(#PB_Any, 0, CanvasHeight, WindowWidth(WindowID), WindowHeight(WindowID) - CanvasHeight, #PB_Container_BorderLess)
    ; Для наглядности покрасим фоны контейнеров в разные случайные цвета
    SetGadgetColor(*Control\Tabs()\ContainerID, #PB_Gadget_BackColor, RGB(Random(50)+200, Random(50)+200, Random(50)+200))
  CloseGadgetList()
  
  
  ; Самая первая вкладка становится активной
  If *Control\active = 0
     *Control\active = @*Control\Tabs()
     HideGadget(*Control\Tabs()\ContainerID, #False) ; Показываем первый контейнер
  Else
     ; По умолчанию скрываем все контейнеры
     HideGadget(*Control\Tabs()\ContainerID, #True)
  EndIf
EndProcedure

Procedure _DrawOldChromeTab(X, Y, W, H, IsActive, color.l)
  Protected i, dy
  Protected OuterBorder = RGB(130, 140, 150)
  Protected InnerHighlight = RGB(255, 255, 255)
  Protected LocalSlant = Slant
  
  If LocalSlant > H: LocalSlant = H: EndIf
  
  If IsActive
    FrontColor(color)
    For dy = 0 To H - 1
      Protected CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy)
    Next
  Else
    For dy = 0 To H - 1
      Protected Factor.f = dy / (H - 1)
      Protected R = 215 + (190 - 215) * Factor
      Protected G = 225 + (205 - 225) * Factor
      Protected B = 240 + (220 - 240) * Factor
      
      CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy, RGB(R, G, B))
    Next
  EndIf
  
  FrontColor(OuterBorder)
  LineXY(X, Y + H - 1, X + LocalSlant, Y)             
  LineXY(X + LocalSlant, Y, X + W - LocalSlant, Y)         
  LineXY(X + W - LocalSlant, Y, X + W, Y + H - 1)     
  
  If IsActive
    FrontColor(InnerHighlight)
    LineXY(X + 2, Y + H - 1, X + LocalSlant + 1, Y + 1)
    LineXY(X + LocalSlant + 1, Y + 1, X + W - LocalSlant - 1, Y + 1)
    LineXY(X + W - LocalSlant - 1, Y + 1, X + W - 2, Y + H - 1)
  EndIf
  
  If Not IsActive
    LineXY(X, Y + H - 1, X + W, Y + H - 1, OuterBorder)
  EndIf
EndProcedure

; Полностью адаптивная процедура рендеринга ретро-трапеции
Procedure DrawOldChromeTab(X, Y, W, H, IsActive, ActiveColor.i, NonActiveColor.i = -1)
  Protected i, dy
  Protected LocalSlant = Slant
  
  If LocalSlant > H: LocalSlant = H: EndIf
  
  ; Выбираем базовый цвет для расчета адаптивных рамок
  Protected CurrentColor.i
  If IsActive
    CurrentColor = ActiveColor
  Else
    If NonActiveColor = -1 : NonActiveColor = RGB(215, 225, 240) : EndIf
    CurrentColor = NonActiveColor
  EndIf
  
  ; Раскладываем цвет на RGB составляющие
  Protected BaseR = Red(CurrentColor)
  Protected BaseG = Green(CurrentColor)
  Protected BaseB = Blue(CurrentColor)
  
  ; МАТЕМАТИКА АДАПТИВНЫХ РАМОК ПОД ЛЮБОЙ ЦВЕТ
  ; Внешний контур на 40% темнее базового цвета
  Protected OuterBorder = RGB(BaseR * 0.6, BaseG * 0.6, BaseB * 0.6)
  ; Внутренний блик объема на 30% светлее базового цвета
  Protected InnerHighlight = RGB(BaseR + (255 - BaseR) * 0.3, BaseG + (255 - BaseG) * 0.3, BaseB + (255 - BaseB) * 0.3)
  
  ; 1. Заливка тела вкладки
  If IsActive
    FrontColor(ActiveColor)
    For dy = 0 To H - 1
      Protected CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy)
    Next
  Else
    ; Для неактивной строим мягкий вертикальный градиент с затемнением к низу
    For dy = 0 To H - 1
      Protected Factor.f = dy / (H - 1)
      
      Protected R = BaseR + ((BaseR - 25) - BaseR) * Factor
      Protected G = BaseG + ((BaseG - 20) - BaseG) * Factor
      Protected B = BaseB + ((BaseB - 20) - BaseB) * Factor
      
      ; Защита от переполнения байта
      If R < 0 : R = 0 : EndIf : If G < 0 : G = 0 : EndIf : If B < 0 : B = 0 : EndIf
      
      CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy, RGB(R, G, B))
    Next
  EndIf
  
  ; 2. Отрисовка внешних адаптивных рамок
  FrontColor(OuterBorder)
  LineXY(X, Y + H - 1, X + LocalSlant, Y)             
  LineXY(X + LocalSlant, Y, X + W - LocalSlant, Y)         
  LineXY(X + W - LocalSlant, Y, X + W, Y + H - 1)     
  
  ; Внутренний блик (только для активной)
  If IsActive
    FrontColor(InnerHighlight)
    LineXY(X + 2, Y + H - 1, X + LocalSlant + 1, Y + 1)
    LineXY(X + LocalSlant + 1, Y + 1, X + W - LocalSlant - 1, Y + 1)
    LineXY(X + W - LocalSlant - 1, Y + 1, X + W - 2, Y + H - 1)
  EndIf
  
  ; Нижняя замыкающая линия для неактивных
  If Not IsActive
    LineXY(X, Y + H - 1, X + W, Y + H - 1, OuterBorder)
  EndIf
EndProcedure

Procedure.i RecalculateTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID)
  Protected CurrentX = 4
  Protected CurrentY = bottom_size+4
  Protected CurrentRow = 0
  Protected MaxHeight = 0
  Protected s = (Slant * 4 / 3)
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    DrawingFont(*Control\FontID)
    
    ForEach *Control\Tabs()
      *Control\Tabs()\Width = TextWidth(*Control\Tabs()\Title$) + (*Control\PaddingX * 2) + (Slant * 2)
      *Control\Tabs()\Height = *Control\TabHeight
      
      If CurrentX + *Control\Tabs()\Width > CanvasW - 10 And CurrentX > 4
        CurrentX = 4
        ;CurrentRow + 1
        CurrentY + *Control\TabHeight - 4
      EndIf
      
      *Control\Tabs()\X = CurrentX
      *Control\Tabs()\Y = CurrentY
      *Control\Tabs()\Row = CurrentRow
      
      If CurrentY + *Control\Tabs()\Height > MaxHeight
        MaxHeight = CurrentY + *Control\Tabs()\Height
      EndIf
      
      CurrentX + *Control\Tabs()\Width - s
    Next
    StopDrawing()
  EndIf
  
  If MaxHeight = 0
    ProcedureReturn *Control\TabHeight + 10
  Else
    ProcedureReturn MaxHeight + bottom_size
  EndIf
EndProcedure

Procedure RedrawTabs(*Control.MultiRowTabControl)
  Protected CanvasW = GadgetWidth(*Control\CanvasID)
  Protected CanvasH = GadgetHeight(*Control\CanvasID)
  Protected TabColor.i ; Для x64 лучше использовать .i (Integer) для цвета
  Protected backcolor = RGB(200, 195, 215)
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    ; Заливаем общую подложку холста
    Box(0, 0, CanvasW, CanvasH, backcolor)
    DrawingFont(*Control\FontID)
    
    ; Рисуем линию пола на самом низу холста
    LineXY(0, CanvasH - 1, CanvasW, CanvasH - 1, RGB(130, 140, 150))
    
    ; 1. Отрисовка неактивных вкладок (передаем 0 или дефолтный цвет в последний параметр)
    ForEach *Control\Tabs()
      If @*Control\Tabs() <> *Control\active
        DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False, 0, backcolor)
        DrawText(*Control\Tabs()\X + *Control\PaddingX + Slant, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, RGB(60, 70, 80), backcolor)
      EndIf
    Next
    
    ; 2. Отрисовка активной вкладки
    If *Control\active <> 0
      ; ИСПРАВЛЕНИЕ: Берем ContainerID строго у АКТИВНОЙ вкладки через указатель, а не из списка!
      TabColor = GetGadgetColor(*Control\active\ContainerID, #PB_Gadget_BackColor)
      
      ; Если цвет не задан (вернуло -1), используем дефолтный белый
      If TabColor = -1 : TabColor = RGB(255, 255, 255) : EndIf
      
      ; Отрисовываем активную вкладку цветом её контейнера. Она накроет линию пола до самого низа.
      DrawOldChromeTab(*Control\active\X, *Control\active\Y, *Control\active\Width, *Control\active\Height + bottom_size, #True, TabColor)
      DrawText(*Control\active\X + *Control\PaddingX + Slant, *Control\active\Y + 6, *Control\active\Title$, RGB(0, 0, 0), TabColor)
    EndIf
    
    StopDrawing()
  EndIf
EndProcedure

Procedure _HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
  Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
  
  If EventType() = #PB_EventType_LeftButtonDown
    LastElement(*Control\Tabs())
    Repeat
      If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
        If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
          ; Твой наглядный вариант проверки
          If *Control\active <> @*Control\Tabs()
            ; Скрываем старый активный контейнер перед переключением
            If *Control\active <> 0
              HideGadget(*Control\active\ContainerID, #True)
            EndIf
            
            ; Переключаем указатель
            *Control\active = @*Control\Tabs()
            
            ; Показываем новый активный контейнер
            HideGadget(*Control\active\ContainerID, #False)
            
            RedrawTabs(*Control)
          EndIf
          Break
        EndIf
      EndIf
    Until PreviousElement(*Control\Tabs()) = 0
  EndIf
EndProcedure
Procedure HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
  Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
  Protected LocalSlant = Slant
  Protected InsideTab.i
  Protected RelX.i, RelY.i
  
  If EventType() = #PB_EventType_LeftButtonDown
    ; Начинаем проверку с конца списка (верхние/правые вкладки визуально лежат над предыдущими)
    LastElement(*Control\Tabs())
    Repeat
      InsideTab = #False
      
      ; Проверяем базовый Y-диапазон (строго в границах высоты строки)
      If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
        
        ; Проверяем X-диапазон всей трапеции целиком
        If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
          
          ; Вычисляем локальные координаты клика относительно левого верхнего угла ТЕКУЩЕЙ вкладки
          RelX = MX - *Control\Tabs()\X
          RelY = MY - *Control\Tabs()\Y
          
          ; Ограничиваем локальный Slant под высоту, как в отрисовке
          If LocalSlant > *Control\Tabs()\Height: LocalSlant = *Control\Tabs()\Height: EndIf
          
          ; --- МАТЕМАТИКА ХИТ-ТЕСТА ТРАПЕЦИИ ---
          
          If RelX < LocalSlant
            ; 1. Клик попал в зону ЛЕВОГО скоса.
            ; Линия скоса идет от (0, Height) до (LocalSlant, 0). 
            ; Уравнение линии определяет, находится ли мышь ПОД наклоном:
            If RelX >= LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height))
              InsideTab = #True
            EndIf
            
          ElseIf RelX > *Control\Tabs()\Width - LocalSlant
            ; 2. Клик попал в зону ПРАВОГО скоса.
            ; Линия идет от (Width - LocalSlant, 0) до (Width, Height).
            If RelX <= *Control\Tabs()\Width - (LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height)))
              InsideTab = #True
            EndIf
            
          Else
            ; 3. Клик попал в ЦЕНТРАЛЬНЫЙ прямоугольник вкладки (тут проверка стопроцентная)
            InsideTab = #True
          EndIf
          
        EndIf
      EndIf
      
      ; Если геометрический хит-тест подтвердил попадание:
      If InsideTab
        If *Control\active <> @*Control\Tabs()
          ; Скрываем старый контейнер
          If *Control\active <> 0
            HideGadget(*Control\active\ContainerID, #True)
          EndIf
          
          ; Меняем активный таб
          *Control\active = @*Control\Tabs()
          
          ; Показываем новый контейнер
          HideGadget(*Control\active\ContainerID, #False)
          
          RedrawTabs(*Control)
        EndIf
        Break ; Прерываем цикл, вкладка успешно найдена!
      EndIf
      
    Until PreviousElement(*Control\Tabs()) = 0
  EndIf
EndProcedure

; Обновление размеров холста и всех контейнеров под размеры окна
Procedure ResizeTabControl(*Control.MultiRowTabControl, WindowID)
  ResizeGadget(*Control\CanvasID, 0, 0, WindowWidth(WindowID), #PB_Ignore)
  Protected NewHeight = RecalculateTabs(*Control)
  ResizeGadget(*Control\CanvasID, #PB_Ignore, #PB_Ignore, #PB_Ignore, NewHeight)
  
  ; Корректируем размеры всех контейнеров в зависимости от новой высоты холста
  ForEach *Control\Tabs()
    ResizeGadget(*Control\Tabs()\ContainerID, 0, NewHeight, WindowWidth(WindowID), WindowHeight(WindowID) - NewHeight)
  Next
  
  RedrawTabs(*Control)
EndProcedure


;- --- ДЕМО ЗАПУСК ---
Define Event, WindowW = 600, WindowH = 350, RealCanvasHeight

If OpenWindow(0, 0, 0, WindowW, WindowH, "Chrome Tabs with Container Logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  
  With TabBar
    \CanvasID  = CanvasGadget(#PB_Any, 0, 0, WindowW, 40)
    \FontID    = LoadFont(0, "Tahoma", 12)
    \TabHeight = 29
    \PaddingX  = 6
  EndWith
  
  ; Добавляем вкладки, передавая ID окна и начальную высоту холста
  AddCustomTab(TabBar, "Вкладка 1", 0, 40)
  AddCustomTab(TabBar, "Вкладка с длинным текстом 2", 0, 40)
  AddCustomTab(TabBar, "Опции 3", 0, 40)
  AddCustomTab(TabBar, "Система 4", 0, 40)
  AddCustomTab(TabBar, "Логи работы 5", 0, 40)
  
  ; Настраиваем начальные размеры всего интерфейса
  ResizeTabControl(TabBar, 0)
  
  ; Наполним первый и второй контейнер чем-нибудь для теста
  ; Для этого временно переключаемся на нужный контейнер через OpenGadgetList
  SelectElement(TabBar\Tabs(), 0)
  OpenGadgetList(TabBar\Tabs()\ContainerID)
    ButtonGadget(#PB_Any, 20, 20, 150, 30, "Кнопка на вкладке 1")
    StringGadget(#PB_Any, 20, 60, 200, 25, "Текст на вкладке 1")
  CloseGadgetList()
  
  SelectElement(TabBar\Tabs(), 1)
  OpenGadgetList(TabBar\Tabs()\ContainerID)
    CheckBoxGadget(#PB_Any, 20, 20, 200, 20, "Галочка на второй вкладке")
  CloseGadgetList()
  
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        If EventGadget() = TabBar\CanvasID: HandleTabsEvents(TabBar): EndIf
        
      Case #PB_Event_SizeWindow
        ; Вызываем единую процедуру ресайза для холста и дочерних контейнеров
        ResizeTabControl(TabBar, 0)
        
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 209
; FirstLine = 152
; Folding = v--------
; EnableXP
; DPIAware