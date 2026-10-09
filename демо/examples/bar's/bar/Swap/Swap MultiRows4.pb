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
   *ActiveTab    .CustomTab
   TabHeight    .l
   PaddingX     .l
   List Tabs    .CustomTab()
EndStructure

Global TabBar.MultiRowTabControl
Global Slant = 14 ; Твой экстремальный наклон боковин
Global bott = 2

Procedure AddCustomTab(*Control.MultiRowTabControl, Title$)
   AddElement(*Control\Tabs())
   *Control\Tabs()\Title$ = Title$
   ProcedureReturn @*Control\Tabs()
EndProcedure

Procedure.l RecalculateTabs(*Control.MultiRowTabControl)
   Protected CanvasW = GadgetWidth(*Control\CanvasID)
   Protected CurrentX = 4
   Protected CurrentY = 6
   Protected CurrentRow = 0
   Protected MaxHeight = 0 ; Переменная для расчета общей высоты
   
   If StartDrawing(CanvasOutput(*Control\CanvasID))
      DrawingFont(*Control\FontID)
      
      ForEach *Control\Tabs()
         *Control\Tabs()\Width = TextWidth(*Control\Tabs()\Title$) + (*Control\PaddingX * 2) + (Slant * 2)
         *Control\Tabs()\Height = *Control\TabHeight
         
         If CurrentX + *Control\Tabs()\Width > CanvasW - 10 And CurrentX > 4
            CurrentX = 4
            CurrentRow + 1
            CurrentY + *Control\TabHeight + 2
         EndIf
         
         *Control\Tabs()\X = CurrentX
         *Control\Tabs()\Y = CurrentY;+bott
         *Control\Tabs()\Row = CurrentRow
         
         ; Фиксируем самую нижнюю точку табов
         If CurrentY + *Control\Tabs()\Height > MaxHeight
            MaxHeight = CurrentY + *Control\Tabs()\Height
         EndIf
         
         CurrentX + *Control\Tabs()\Width - (Slant * 4 / 3)
      Next
      
      StopDrawing()
   EndIf
   
   ; Возвращаем реальную высоту +небольшой отступ снизу под линию (например, 4 пикселя)
   If MaxHeight = 0
      ProcedureReturn *Control\TabHeight ;+ 10
   Else
      ProcedureReturn MaxHeight + bott
   EndIf
EndProcedure

Procedure DrawOldChromeTab(X, Y, W, H, IsActive)
   Protected i, dy
   Protected OuterBorder = RGB(130, 140, 150) ; Внешняя темная рамка
   Protected InnerHighlight = RGB(255, 255, 255) ; Светлый блик
   Protected LocalSlant = Slant
   
   ; Проверка пропорций
   If LocalSlant > H: LocalSlant = H: EndIf
   
   ; 1. Заливка тела вкладки
   If IsActive
      FrontColor(RGB(255, 255, 255))
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
   
   ; 2. Рисуем рамки и блики для придания объема
   FrontColor(OuterBorder)
   LineXY(X, Y + H - 1, X + LocalSlant, Y)             ; Левый пологий скос
   LineXY(X + LocalSlant, Y, X + W - LocalSlant, Y)    ; Верх
   LineXY(X + W - LocalSlant, Y, X + W, Y + H - 1)     ; Правый пологий скос
   
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

Procedure RedrawTabs(*Control.MultiRowTabControl)
   Protected Index = 0
   Protected CanvasW = GadgetWidth(*Control\CanvasID)
   Protected CanvasH = GadgetHeight(*Control\CanvasID)
   
   If StartDrawing(CanvasOutput(*Control\CanvasID))
      ; Фирменный серо-голубой фон панели Windows XP / Vista тех времен
      Box(0, 0, CanvasW, CanvasH, RGB(180, 195, 215))
      DrawingFont(*Control\FontID)
      
      ; --- ШАГ 1: Рисуем базовую линию ("пол") ЗАРАНЕЕ ---
      ; Теперь она лежит под активным табом, и он сможет её перекрыть
      LineXY(0, CanvasH - 1, CanvasW, CanvasH - 1, RGB(130, 140, 150))
      
      ; --- ШАГ 2: Отрисовка неактивных вкладок ---
      Index = 0
      ForEach *Control\Tabs()
         If Index <> *Control\ActiveTab
            DrawOldChromeTab(*Control\Tabs()\X, *Control\Tabs()\Y, *Control\Tabs()\Width, *Control\Tabs()\Height, #False)
            ; Текст неактивной вкладки
            DrawText(*Control\Tabs()\X + *Control\PaddingX + Slant, *Control\Tabs()\Y + 6, *Control\Tabs()\Title$, RGB(60, 70, 80), RGB(205, 215, 230))
         EndIf
         Index + 1
      Next
      
      ; --- ШАГ 3: Отрисовка активной вкладки ПОВЕРХ ВСЕГО ---
      If *Control\ActiveTab
         ; Трюк: передаем высоту на 1 пиксель больше (Height + 1), 
         ; чтобы трапеция «наступила» на нижнюю линию холста и стёрла её своим белым цветом
         DrawOldChromeTab(*Control\ActiveTab\X, *Control\ActiveTab\Y, *Control\ActiveTab\Width, *Control\ActiveTab\Height + bott, #True)
         ; Текст активной вкладки
         DrawText(*Control\ActiveTab\X + *Control\PaddingX + Slant, *Control\ActiveTab\Y + 6, *Control\ActiveTab\Title$, RGB(0, 0, 0), RGB(255, 255, 255))
      EndIf
      
      StopDrawing()
   EndIf
EndProcedure

Procedure HandleTabsEvents(*Control.MultiRowTabControl)
   Protected MX = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseX)
   Protected MY = GetGadgetAttribute(*Control\CanvasID, #PB_Canvas_MouseY)
   
   If EventType() = #PB_EventType_LeftButtonDown
      LastElement(*Control\Tabs())
      Repeat
         If MX >= *Control\Tabs()\X And MX <= *Control\Tabs()\X + *Control\Tabs()\Width
            If MY >= *Control\Tabs()\Y And MY <= *Control\Tabs()\Y + *Control\Tabs()\Height
               ; Защита: перерисовываем только если кликнули по ДРУГОЙ вкладке
               If *Control\ActiveTab <> @*Control\Tabs()
                  *Control\ActiveTab = @*Control\Tabs()
                  RedrawTabs(*Control)
               EndIf
               Break
            EndIf
         EndIf
      Until PreviousElement(*Control\Tabs()) = 0
  EndIf
EndProcedure

Procedure UpdateTabs(*Control.MultiRowTabControl)
   ; 2. Пересчитываем табы и узнаем новую необходимую высоту
   Protected RealCanvasHeight = RecalculateTabs(*Control)
   ; 3. Изменяем высоту холста на реальную
   ResizeGadget(*Control\CanvasID, #PB_Ignore, #PB_Ignore, #PB_Ignore, RealCanvasHeight)
   ; 4. Перерисовываем
   RedrawTabs(*Control)
EndProcedure

;- --- ДЕМО ЗАПУСК ---
Define Event, WindowW = 600, WindowH = 350

If OpenWindow(0, 0, 0, WindowW, WindowH, "Chrome 1.0 Style Adaptive Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   SetWindowColor(0, RGB(255, 255, 255))
   
   With TabBar
      \CanvasID  = CanvasGadget(#PB_Any, 0, 0, WindowW, 70)
      \FontID    = LoadFont(0, "Tahoma", 11)
      \TabHeight = 30
      \PaddingX  = 6
      
      \ActiveTab = AddCustomTab(@TabBar, "Google Chrome 1.0")
      AddCustomTab(@TabBar, "Добро пожаловать в Интернет")
      AddCustomTab(@TabBar, "Habrahabr.ru")
      AddCustomTab(@TabBar, "Скачать Winamp")
      AddCustomTab(@TabBar, "ВКонтакте")
      
      ; --- Замени старый блок инициализации перед циклом на этот: ---
      UpdateTabs(@TabBar)
   EndWith
  
   ; Главный цикл обработки событий
   Repeat
      Event = WaitWindowEvent()
      Select Event
         Case #PB_Event_Gadget
            If EventGadget() = TabBar\CanvasID: HandleTabsEvents(@TabBar): EndIf
            
         Case #PB_Event_SizeWindow
            ; --- Замени старый Case на этот: ---
            ; 1. Сначала подгоняем ширину холста под окно
            ResizeGadget(TabBar\CanvasID, 0, 0, WindowWidth(0), #PB_Ignore)
            UpdateTabs(@TabBar)
            
         Case #PB_Event_CloseWindow
            End
      EndSelect
   ForEver
   
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 170
; FirstLine = 190
; Folding = -----
; EnableXP
; DPIAware