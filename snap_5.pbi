EnableExplicit

; --- МАСКИ И КОНСТАНТЫ СЛОЕВ ---
#_SNAP_BACK  = 0
#_SNAP_FRONT = 1

#_mask_update = 1 << 0
#_mask_redraw = 1 << 1
#_mask_hidden = 1 << 2

; --- СТРУКТУРЫ ДВИЖКА ---
Structure _s_COORDINATE
  X.l : Y.l : Width.l : Height.l
EndStructure

Structure _s_SNAP
  img.i[2]           ; Статичный массив в PB объявляется через круглые скобки
  *active._s_WIDGET  ; Убран ошибочный префикс 'struct'
  drag_offset_x.l
  drag_offset_y.l
EndStructure

Structure _s_CANVAS Extends _s_COORDINATE
  dpi.f
  gadget.i
  window.i
  *next._s_ROOT      ; Убран ошибочный префикс 'struct'
  *prev._s_ROOT      ; Убран ошибочный префикс 'struct'
  snap._s_SNAP
EndStructure


; Предварительное объявление базового виджета
Structure _s_WIDGET Extends _s_COORDINATE
  *root._s_ROOT
  *parent._s_WIDGET
  *first._s_WIDGET    
  *next._s_WIDGET     
  
  color.l
  Text.s
  mask.l
  tabindex.l
  
  real._s_COORDINATE
EndStructure

Structure _s_ROOT Extends _s_WIDGET
  Canvas._s_CANVAS
EndStructure

; Глобальный плоский список всех виджетов
Global NewList widgets._s_WIDGET()

; Состояния для обработки ховера
Global *EnteredWidget._s_WIDGET = 0

; --- ФУНКЦИЯ ПОИСКА ВИДЖЕТА ПО КООРДИНАТАМ ---
; --- ИСПРАВЛЕННАЯ ФУНКЦИЯ ПОИСКА ВИДЖЕТА ---
Procedure.i FindWidget(mx.l, my.l)
  PushListPosition(widgets())
  If LastElement(widgets())
    Repeat
      If (widgets()\mask & #_mask_hidden) Or widgets()\parent = 0
        Continue
      EndIf
      If mx >= widgets()\real\x And mx <= widgets()\real\x + widgets()\width And
         my >= widgets()\real\y And my <= widgets()\real\y + widgets()\height
        Protected *found._s_WIDGET = @widgets()
        PopListPosition(widgets())
        ProcedureReturn *found
      EndIf
    Until Not PreviousElement(widgets())
  EndIf
  PopListPosition(widgets())
  ProcedureReturn 0
EndProcedure

; --- МОДИФИЦИРОВАННАЯ ПРОЦЕДУРА DRAW (ТВОЙ ОРИГИНАЛ + НАШИ ОПТИМИЗАЦИИ) ---
Declare Draw(*this._s_WIDGET)

Procedure Draw(*this._s_WIDGET)
  Protected *root._s_ROOT
    If *this
    
    If *this\parent
       *root = *this\root
      ; =========================================================================
      ; ВЕТКА А: ОДИНОЧНАЯ ЛОКАЛЬНАЯ ОТРИСОВКА ВИДЖЕТА
      ; =========================================================================
      If *this\mask & #_mask_redraw
        
        ; Если у рута НЕТ маски перерисовки — включаем локальный режим через буфер
        If *root And (*root\mask & #_mask_redraw) = 0
          If StartDrawing(CanvasOutput(*root\Canvas\gadget))
            
            ; 1. Накатываем сохраненный чистый бэкграунд всего окна
            If IsImage(*root\Canvas\snap\img[#_SNAP_BACK])
              DrawImage(ImageID(*root\Canvas\snap\img[#_SNAP_BACK]), 0, 0)
            EndIf
            
            ; 2. Ограничиваем рисование областью виджета (Твой Clip)
            ClipOutput(*this\real\x, *this\real\y, *this\width, *this\height)
            
            Protected color.l = *this\color
            If *EnteredWidget = *this
              color = $00FF00 ; Подсветка ховера (зеленый)
            EndIf
            
            Box(*this\real\x, *this\real\y, *this\width, *this\height, color)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*this\real\x, *this\real\y, *this\width, *this\height, $CCCCCC)
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(*this\real\x + 10, *this\real\y + 12, *this\text, $000000)
            
            UnclipOutput()
            
            ; 3. Фиксируем изменения в фоновый снимок, чтобы закрепить результат
            GrabDrawingImage(*root\Canvas\snap\img[#_SNAP_BACK], 0, 0, OutputWidth(), OutputHeight())
            
            StopDrawing()
          EndIf
          *this\mask &~ #_mask_redraw
          ProcedureReturn 0
        EndIf
        
        ; --- РЕНДЕР ВИДЖЕТА ВНУТРИ ПОЛНОГО ЦИКЛА КОРНЯ ---
        ClipOutput(*this\real\x, *this\real\y, *this\width, *this\height)
        
        Protected draw_color.l = *this\color
        If *EnteredWidget = *this
          draw_color = $00FF00
        EndIf
        
        Box(*this\real\x, *this\real\y, *this\width, *this\height, draw_color)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*this\real\x, *this\real\y, *this\width, *this\height, $CCCCCC)
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(*this\real\x + 10, *this\real\y + 12, *this\text, $000000)
        
        UnclipOutput()
        *this\mask &~ #_mask_redraw
      EndIf
      
    Else
      ; =========================================================================
      ; ВЕТКА Б: ТВОЙ ОРИГИНАЛЬНЫЙ ЦИКЛ РУТА (Работает, только если есть *this\first)
      ; =========================================================================
      If *this\first
        *root = *this
        
        ; 1. Режим Перемещения (Drag) — Отрисовка по сверхбыстрой схеме готовых слоев
        If *root\canvas\snap\active
          If StartDrawing(CanvasOutput(*root\canvas\gadget))
            ; Выводим чистую подложку
            DrawImage(ImageID(*root\canvas\snap\img[#_SNAP_BACK]), 0, 0)
            
            ; Выводим активный виджет по новым координатам мыши
            Protected *drag._s_WIDGET = *root\canvas\snap\active
            ClipOutput(*drag\real\x, *drag\real\y, *drag\width, *drag\height)
            Box(*drag\real\x, *drag\real\y, *drag\width, *drag\height, $0000FF) ; Синий при драге
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*drag\real\x, *drag\real\y, *drag\width, *drag\height, $CCCCCC)
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(*drag\real\x + 10, *drag\real\y + 12, *drag\text, $FFFFFF)
            UnclipOutput()
            
            StopDrawing()
          EndIf
          ProcedureReturn 0
        EndIf
        
        ; 2. Обычный штатный режим — Полный проход по дереву виджетов
        If *this\mask & #_mask_redraw
           ;Debug *root\canvas\gadget
           If StartDrawing(CanvasOutput(*root\canvas\gadget))
            ; Фон всего холста
            Box(0, 0, OutputWidth(), OutputHeight(), *this\color) 
            
            ; Твой цикл итератора один в один
            ChangeCurrentElement(widgets(), *this\first)
            Repeat 
              If widgets() = *this\next
                Break
              EndIf
              
              If widgets()\tabindex = -1 : Continue : EndIf
              If widgets()\mask & #_mask_hidden : Continue : EndIf
              
              widgets()\mask | #_mask_redraw
              Draw(@widgets())
            Until Not NextElement(widgets())
            
            ; Захватываем получившуюся сцену в кэш-снимок фонового слоя
            If Not IsImage(*root\canvas\snap\img[#_SNAP_BACK])
              CreateImage(*root\canvas\snap\img[#_SNAP_BACK], OutputWidth(), OutputHeight())
            EndIf
            GrabDrawingImage(*root\canvas\snap\img[#_SNAP_BACK], 0, 0, OutputWidth(), OutputHeight())
            
            StopDrawing()
          EndIf
          *this\mask &~ #_mask_redraw
          ProcedureReturn 0
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

; --- ОБРАБОТЧИК СОБЫТИЙ МЫШИ НА КАНВАСЕ ---
Procedure CanvasCallback()
  Protected gadget = EventGadget()
  Protected etype  = EventType()
  Protected mx     = GetGadgetAttribute(gadget, #PB_Canvas_MouseX)
  Protected my     = GetGadgetAttribute(gadget, #PB_Canvas_MouseY)
  Protected *root._s_ROOT = GetGadgetData(gadget)
  
  Select etype
      
    Case #PB_EventType_MouseMove
      If *root\Canvas\snap\active
        Protected *dW._s_WIDGET = *root\Canvas\snap\active
        *dW\real\x = mx - *root\Canvas\snap\drag_offset_x
        *dW\real\y = my - *root\Canvas\snap\drag_offset_y
        Draw(*root) ; Отрисовка по слоям без перебора списка
      Else
        Protected *hover._s_WIDGET = FindWidget(mx, my)
        If *hover <> *EnteredWidget
          If *EnteredWidget
            *EnteredWidget\mask | #_mask_redraw
            Draw(*EnteredWidget) ; Снимаем подсветку
          EndIf
          *EnteredWidget = *hover
          If *EnteredWidget
            *EnteredWidget\mask | #_mask_redraw
            Draw(*EnteredWidget) ; Ставим подсветку
          EndIf
        EndIf
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      Protected *clicked._s_WIDGET = FindWidget(mx, my)
      If *clicked
        *clicked\mask | #_mask_hidden
        *root\mask | #_mask_redraw
        Draw(*root) ; Снимок фона без этого виджета
        *clicked\mask &~ #_mask_hidden
        
        *root\Canvas\snap\active = *clicked
        *root\Canvas\snap\drag_offset_x = mx - *clicked\real\x
        *root\Canvas\snap\drag_offset_y = my - *clicked\real\y
      EndIf
      
    Case #PB_EventType_LeftButtonUp
      If *root\Canvas\snap\active
        *root\Canvas\snap\active = 0
        *root\mask | #_mask_redraw
        Draw(*root) ; Восстанавливаем обычный живой рендер
      EndIf
  EndSelect
EndProcedure

; --- ДЕМОНСТРАЦИОННЫЙ ЗАПУСК ОКНА ---
; --- ИСПРАВЛЕННЫЙ ЗАПУСК ОКНА И ГАДЖЕТА ---
If OpenWindow(0, 0, 0, 800, 600, "Тест инкрементального GUI", #PB_Window_SystemMenu | #PB_Window_WindowCentered)
  Define cv = CanvasGadget(#PB_Any, 0, 0, 800, 600)
  
  ; 2. Создаем уникальный Рут отдельно от списка
Define Root._s_ROOT
   Define *Root._s_ROOT = @root
; Инициализируем его поля напрямую, без AddElement
Root\root = @root
Root\parent = 0
Root\color = $F5F5F5
Root\mask = #_mask_redraw
Root\Canvas\gadget = cv
SetGadgetData(cv, @root)

  Define  i
  For i = 1 To 10
    AddElement(widgets())
   widgets()\root = *root
    widgets()\parent = *root
    widgets()\real\x = 60 + (i * 35)
    widgets()\real\y = 60 + (i * 40)
    widgets()\width = 130
    widgets()\height = 45
    widgets()\color = $E0E0E0
    widgets()\text = "Элемент " + Str(i)
    widgets()\mask = #_mask_redraw
    If Not *Root\first 
       *root\first = *root
  EndIf
Next
  *root\next = 0
  
  Draw(*root)
  
  BindGadgetEvent(cv, @CanvasCallback())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  If IsImage(*root\Canvas\snap\img[#_SNAP_BACK]) : FreeImage(*root\Canvas\snap\img[#_SNAP_BACK]) : EndIf
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 174
; FirstLine = 153
; Folding = ----4--
; EnableXP
; DPIAware