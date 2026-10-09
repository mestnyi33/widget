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
  IsHovered    .a ; Флаг наведения мыши (0 или 1)
  ImageID      .i ; <--- Добавляем ID иконки PureBasic (если 0 — вкладка без иконки)
EndStructure

; Структура контрола
Structure MultiRowTabControl
  CanvasID     .i  
  FontID       .i  
  *active   .CustomTab 
  BgColor      .l ; <--- Добавь это поле для управления общим фоном холста
  TabHeight    .i
  PaddingX     .i
  List Tabs    .CustomTab()
EndStructure

Global TabBar.MultiRowTabControl
Global Slant = 20 
Global bottom_size = 2

; Добавление вкладки и автоматическое создание её контейнера под холстом
Procedure AddCustomTab(*Control.MultiRowTabControl, Title$, WindowID, CanvasHeight, ImageID.i = 0, TabColor.l=0)
  AddElement(*Control\Tabs())
  *Control\Tabs()\Title$ = Title$
  *Control\Tabs()\ImageID = ImageID ; Записываем ID картинки
  If Not TabColor
     TabColor = RGB(Random(50)+200, Random(50)+200, Random(50)+200)
  EndIf
  
  ; Создаем скрытый контейнер под размеры окна (ниже холста)
  ; Внутри него ты сможешь создавать любые кнопки, строки ввода и т.д.
  *Control\Tabs()\ContainerID = ContainerGadget(#PB_Any, 0, CanvasHeight, WindowWidth(WindowID), WindowHeight(WindowID) - CanvasHeight, #PB_Container_BorderLess)
    ; Для наглядности покрасим фоны контейнеров в разные случайные цвета
    SetGadgetColor(*Control\Tabs()\ContainerID, #PB_Gadget_BackColor, TabColor)
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

; Полностью адаптивная процедура рендеринга ретро-трапеции
Procedure DrawOldChromeTab(X, Y, W, H, IsActive, ActiveColor.l, NonActiveColor.l = -1, OuterBorderColor.l = -1, InnerHighlightColor.l = -1)
  Protected i, dy
  Protected LocalSlant = Slant
  
  If LocalSlant > H: LocalSlant = H: EndIf
  
  ; 1. ВЫБОР БАЗОВОГО ЦВЕТА ДЛЯ ТЕЛА
  Protected CurrentColor.i
  If IsActive
    CurrentColor = ActiveColor
  Else
    If NonActiveColor = -1 : NonActiveColor = RGB(215, 225, 240) : EndIf
    CurrentColor = NonActiveColor
  EndIf
  
  ; 2. РАСЧЕТ ИЛИ НАЗНАЧЕНИЕ ЦВЕТА РАМОК
  ; Если параметры переданы (не равны -1), берем их. Иначе — считаем автоматом.
  If OuterBorderColor = -1
    OuterBorderColor = RGB(Red(CurrentColor) * 0.6, Green(CurrentColor) * 0.6, Blue(CurrentColor) * 0.6)
  EndIf
  
  If InnerHighlightColor = -1
    Protected.a R = Red(CurrentColor), G = Green(CurrentColor), B = Blue(CurrentColor)
    InnerHighlightColor = RGB(R + (255 - R) * 0.3, G + (255 - G) * 0.3, B + (255 - B) * 0.3)
  EndIf
  
  ; 3. ЗАЛИВКА ТЕЛА ВКЛАДКИ
  If IsActive
    FrontColor(ActiveColor)
    For dy = 0 To H - 1
      Protected CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy)
    Next
  Else
    Protected BaseR = Red(NonActiveColor)
    Protected BaseG = Green(NonActiveColor)
    Protected BaseB = Blue(NonActiveColor)
    
    For dy = 0 To H - 1
      Protected Factor.f = dy / (H - 1)
      R = BaseR + ((BaseR - 25) - BaseR) * Factor
      G = BaseG + ((BaseG - 20) - BaseG) * Factor
      B = BaseB + ((BaseB - 20) - BaseB) * Factor
      
      CurrentSlant = LocalSlant * (1.0 - (dy / H))
      LineXY(X + CurrentSlant, Y + dy, X + W - CurrentSlant, Y + dy, RGB(R, G, B))
    Next
  EndIf
  
  ; 4. ОТРИСОВКА КОНТУРОВ
  ; Внешняя рамка
  FrontColor(OuterBorderColor)
  LineXY(X, Y + H - 1, X + LocalSlant, Y)             
  LineXY(X + LocalSlant, Y, X + W - LocalSlant, Y)         
  LineXY(X + W - LocalSlant, Y, X + W, Y + H - 1)     
  
  If IsActive
     ; Внутренний светлый блик (только для активной)
     FrontColor(InnerHighlightColor)
     LineXY(X + 2, Y + H - 1, X + LocalSlant + 1, Y + 1)
     LineXY(X + LocalSlant + 1, Y + 1, X + W - LocalSlant - 1, Y + 1)
     LineXY(X + W - LocalSlant - 1, Y + 1, X + W - 2, Y + H - 1)
  Else
     ; Нижняя замыкающая линия для неактивных
     LineXY(X, Y + H - 1, X + W, Y + H - 1);, OuterBorderColor)
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
            ; Базовая ширина: текст + скосы + падинги
      Protected TabWidth = TextWidth(*Control\Tabs()\Title$) + (*Control\PaddingX * 2) + (Slant * 2)
      
      ; Если у вкладки задана иконка, накидываем место под неё
      If *Control\Tabs()\ImageID <> 0
        TabWidth + 20
      EndIf
      
      *Control\Tabs()\Width = TabWidth
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
  Protected TabColor.l 
  Protected CanvasBgColor.l
  Protected NonActiveColor.l
  
  If *Control\BgColor <> 0
    CanvasBgColor = *Control\BgColor
  Else
    CanvasBgColor = RGB(180, 195, 215)
  EndIf
  
  If StartDrawing(CanvasOutput(*Control\CanvasID))
    Box(0, 0, CanvasW, CanvasH, CanvasBgColor)
    DrawingFont(*Control\FontID)
    
    ; Линия пола
    Protected FloorColor = RGB(Red(CanvasBgColor) * 0.7, Green(CanvasBgColor) * 0.7, Blue(CanvasBgColor) * 0.7)
    LineXY(0, CanvasH - 1, CanvasW, CanvasH - 1, FloorColor)
    
;     ; 1. Отрисовка неактивных вкладок
;     ForEach *Control\Tabs()
;       If @*Control\Tabs() <> *Control\active
;         
;         Protected NABaseR = Red(CanvasBgColor) + 25
;         Protected NABaseG = Green(CanvasBgColor) + 20
;         Protected NABaseB = Blue(CanvasBgColor) + 20
;         
;         ; ЭФФЕКТ HOVER: Если мышь наведена, делаем вкладку еще светвее
;         If *Control\Tabs()\IsHovered
;           NABaseR + 30 : NABaseG + 30 : NABaseB + 30
;         EndIf
;         
;         If NABaseR > 255 : NABaseR = 255 : EndIf
;         If NABaseG > 255 : NABaseG = 255 : EndIf
;         If NABaseB > 255 : NABaseB = 255 : EndIf
;         
;         NonActiveColor = RGB(NABaseR, NABaseG, NABaseB)
;         
;         DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False, 0, NonActiveColor)
;         
;         Protected TextBgR = NABaseR - (25 * 0.2)
;         Protected TextBgG = NABaseG - (20 * 0.2)
;         Protected TextBgB = NABaseB - (20 * 0.2)
;         
;         Protected TextColor = RGB(Red(CanvasBgColor) * 0.3, Green(CanvasBgColor) * 0.3, Blue(CanvasBgColor) * 0.3)
;         DrawText(*Control\Tabs()\X + *Control\PaddingX + Slant, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, TextColor, RGB(TextBgR, TextBgG, TextBgB))
;       EndIf
;     Next
;     
;     ; 2. Отрисовка активной вкладки
;     If *Control\active <> 0
;       TabColor = GetGadgetColor(*Control\active\ContainerID, #PB_Gadget_BackColor)
;       If TabColor = -1 : TabColor = RGB(255, 255, 255) : EndIf
;       
;       DrawOldChromeTab(*Control\active\X, *Control\active\Y, *Control\active\Width, *Control\active\Height + bottom_size, #True, TabColor)
;       DrawText(*Control\active\X + *Control\PaddingX + Slant, *Control\active\Y + 6, *Control\active\Title$, RGB(0, 0, 0), TabColor)
;     EndIf
        ; 1. Отрисовка неактивных вкладок
    ForEach *Control\Tabs()
      If @*Control\Tabs() <> *Control\active
        
        Protected NABaseR = Red(CanvasBgColor) + 25
        Protected NABaseG = Green(CanvasBgColor) + 20
        Protected NABaseB = Blue(CanvasBgColor) + 20
        
        If *Control\Tabs()\IsHovered : NABaseR + 30 : NABaseG + 30 : NABaseB + 30 : EndIf
        If NABaseR > 255 : NABaseR = 255 : EndIf : If NABaseG > 255 : NABaseG = 255 : EndIf : If NABaseB > 255 : NABaseB = 255 : EndIf
        NonActiveColor = RGB(NABaseR, NABaseG, NABaseB)
        
        DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False, 0, NonActiveColor)
        
        ; Вычисляем X-координату для старта контента внутри вкладки
        Protected IconX = *Control\Tabs()\X + *Control\PaddingX + Slant
        Protected TextShift = 0
        
        ; РИСУЕМ ИКОНКУ НЕАКТИВНОЙ ВКЛАДКИ
        If *Control\Tabs()\ImageID <> 0
          ; Центрируем иконку 16x16 по высоте таба
          Protected IconY = *Control\Tabs()\Y + (*Control\Tabs()\Height - 16) / 2
          DrawImage(ImageID(*Control\Tabs()\ImageID), IconX, IconY);, 16, 16)
          TextShift = 20 ; Сдвигаем текст вправо, чтобы он не налез на иконку
        EndIf
        
        Protected TextBgR = NABaseR - (25 * 0.2)
        Protected TextBgG = NABaseG - (20 * 0.2)
        Protected TextBgB = NABaseB - (20 * 0.2)
        Protected TextColor = RGB(Red(CanvasBgColor) * 0.3, Green(CanvasBgColor) * 0.3, Blue(CanvasBgColor) * 0.3)
        
        DrawText(IconX + TextShift, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, TextColor, RGB(TextBgR, TextBgG, TextBgB))
      EndIf
    Next
    
    ; 2. Отрисовка активной вкладки
    If *Control\active <> 0
      TabColor = GetGadgetColor(*Control\active\ContainerID, #PB_Gadget_BackColor)
      If TabColor = -1 : TabColor = RGB(255, 255, 255) : EndIf
      
      DrawOldChromeTab(*Control\active\X, *Control\active\Y, *Control\active\Width, *Control\active\Height + bottom_size, #True, TabColor)
      
      IconX = *Control\active\X + *Control\PaddingX + Slant
      TextShift = 0
      
      ; РИСУЕМ ИКОНКУ АКТИВНОЙ ВКЛАДКИ
      If *Control\active\ImageID <> 0
         IconY = *Control\active\Y + (*Control\active\Height - 16) / 2
         DrawImage(ImageID(*Control\active\ImageID), IconX, IconY);, 16, 16)
        TextShift = 20
      EndIf
      
      DrawText(IconX + TextShift, *Control\active\Y + 6, *Control\active\Title$, RGB(0, 0, 0), TabColor)
    EndIf

    StopDrawing()
  EndIf
EndProcedure

Procedure HandleTabsEvents(*Control.MultiRowTabControl)
  Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
  Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
  Protected LocalSlant = Slant
  Protected InsideTab.i, RelX.i, RelY.i
  Protected *HoveredTab.CustomTab = 0
  Protected NeedRedraw.i = #False
  
  Protected EType = EventType()
  
  ; --- ОБРАБОТКА ДВИЖЕНИЯ МЫШИ И КЛИКА ---
  If EType = #PB_EventType_MouseMove Or EType = #PB_EventType_LeftButtonDown
    
    ; Запускаем точный хит-тест трапеций
    If ListSize(*Control\Tabs()) > 0
      LastElement(*Control\Tabs())
      Repeat
        InsideTab = #False
        
        If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
          If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
            
            RelX = MX - *Control\Tabs()\X
            RelY = MY - *Control\Tabs()\Y
            
            If LocalSlant > *Control\Tabs()\Height: LocalSlant = *Control\Tabs()\Height: EndIf
            
            ; Твой точный геометрический тест
            If RelX < LocalSlant
              If RelX >= LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height)) : InsideTab = #True : EndIf
            ElseIf RelX > *Control\Tabs()\Width - LocalSlant
              If RelX <= *Control\Tabs()\Width - (LocalSlant * (1.0 - (RelY / *Control\Tabs()\Height))) : InsideTab = #True : EndIf
            Else
              InsideTab = #True
            EndIf
          EndIf
        EndIf
        
        If InsideTab
          *HoveredTab = @*Control\Tabs()
          Break ; Нашли таб, над которым мышь!
        EndIf
        
      Until PreviousElement(*Control\Tabs()) = 0
    EndIf
    
    ; ЛОГИКА КЛИКА
    If EType = #PB_EventType_LeftButtonDown And *HoveredTab <> 0
      If *Control\active <> *HoveredTab
        If *Control\active <> 0
          HideGadget(*Control\active\ContainerID, #True)
        EndIf
        *Control\active = *HoveredTab
        HideGadget(*Control\active\ContainerID, #False)
        NeedRedraw = #True
      EndIf
    
    ; ЛОГИКА ПОДСВЕТКИ (HOVER)
    ElseIf EType = #PB_EventType_MouseMove
      ; Проверяем все табы: обновляем их статус IsHovered
      ForEach *Control\Tabs()
        ; Активный таб не подсвечиваем (он и так белый/яркий)
        If @*Control\Tabs() = *Control\active
          If *Control\Tabs()\IsHovered <> 0 : *Control\Tabs()\IsHovered = 0 : NeedRedraw = #True : EndIf
        Else
          ; Для неактивных табов проверяем, изменилось ли состояние наведения
          Protected ShouldHover = 0
          If @*Control\Tabs() = *HoveredTab : ShouldHover = 1 : EndIf
          
          If *Control\Tabs()\IsHovered <> ShouldHover
            *Control\Tabs()\IsHovered = ShouldHover
            NeedRedraw = #True ; Перерисовываем холст только если мышь реально перешла на другой таб!
          EndIf
        EndIf
      Next
    EndIf
    
    ; Если что-то изменилось (клик или ховер) — обновляем экран
    If NeedRedraw
      RedrawTabs(*Control)
    EndIf
    
  ; МЫШЬ УШЛА С ХОЛСТА — убираем всю подсветку
  ElseIf EType = #PB_EventType_MouseLeave
    ForEach *Control\Tabs()
      If *Control\Tabs()\IsHovered <> 0
        *Control\Tabs()\IsHovered = 0
        NeedRedraw = #True
      EndIf
    Next
    If NeedRedraw : RedrawTabs(*Control) : EndIf
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
Define Event, WindowW = 900, WindowH = 350, RealCanvasHeight

If OpenWindow(0, 0, 0, WindowW, WindowH, "Chrome Tabs with Container Logic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  
  With TabBar
    \CanvasID  = CanvasGadget(#PB_Any, 0, 0, WindowW, 40)
    \FontID    = LoadFont(0, "Tahoma", 12)
    \TabHeight = 29
    \PaddingX  = 6
    ;\BgColor     = RGB(Random(255), Random(255), Random(255)) ; Твой любимый цвет. Сделай его зеленым или серым — и весь интерфейс сам перестроится!
EndWith
  
    ; Создаем две тестовые цветные иконки 16x16
  CreateImage(1, 16, 16)
  If StartDrawing(ImageOutput(1)) : Box(0,0,16,16, RGB(255, 50, 50)) : StopDrawing() : EndIf ; Красный квадрат
  
  CreateImage(2, 16, 16)
  If StartDrawing(ImageOutput(2)) : Box(0,0,16,16, RGB(50, 150, 255)) : StopDrawing() : EndIf ; Синий квадрат

  ; Добавляем вкладки (последним параметром передаем ID созданных картинок)
  AddCustomTab(TabBar, "Google (С иконкой)", 0, 40, 1, RGB(255, 255, 255))
  AddCustomTab(TabBar, "Код проекта (С иконкой)", 0, 40, 2, RGB(210, 245, 225))
  AddCustomTab(TabBar, "Без иконки", 0, 40, 0, RGB(255, 220, 230))
; Добавляем вкладки, передавая ID окна и начальную высоту холста
  AddCustomTab(TabBar, "Вкладка 1", 0, 40)
  ;AddCustomTab(TabBar, "Вкладка с длинным текстом 2", 0, 40)
  AddCustomTab(TabBar, "Опции 3", 0, 40)
  AddCustomTab(TabBar, "Система 4", 0, 40)
  AddCustomTab(TabBar, "Логи работы 5", 0, 40)
;   
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
; CursorPosition = 428
; FirstLine = 419
; Folding = ----------
; EnableXP
; DPIAware