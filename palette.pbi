; --- СТРУКТУРЫ И ЛОГИКА ---
Structure WidgetPalette
   bgNormal.l 
   bgHover.l 
   bgActive.l 
   bgPressed.l
   
   borderNormal.l 
   borderHover.l 
   borderActive.l 
   borderPressed.l
   
   textNormal.l 
   textHover.l
EndStructure

Structure WidgetState
   isHover.b
   isActive.b
   isPressed.b
EndStructure

; Единая структура для всех элементов UI
Structure Widget
   logX.i : logY.i : logW.i : logH.i ; Логические (исходные) координаты
   physX.i : physY.i : physW.i : physH.i : physRadius.i ; Физические (скалированные) координаты
   text.s
   color.l
   state.WidgetState
EndStructure

Procedure.w ClampChannel(value.l)
   If value > 255 : ProcedureReturn 255 : EndIf
   If value < 0   : ProcedureReturn 0   : EndIf
   ProcedureReturn value
EndProcedure

Procedure CalcWidgetPalette(baseColor.l, *p.WidgetPalette)
   Protected.l r = Red(baseColor), g = Green(baseColor), b = Blue(baseColor), a = Alpha(baseColor)
   Protected.l brightness = (r * 299 + g * 587 + b * 114) / 1000
   
   *p\bgNormal     = baseColor
   *p\bgHover      = RGBA(ClampChannel(r + 20), ClampChannel(g + 20), ClampChannel(b + 20), a)
   *p\bgActive     = RGBA(ClampChannel(r + 35), ClampChannel(g + 35), ClampChannel(b + 35), a)
   *p\bgPressed    = RGBA(ClampChannel(r - 30), ClampChannel(g - 30), ClampChannel(b - 30), a)
   *p\borderNormal = RGBA(ClampChannel(r - 40), ClampChannel(g - 40), ClampChannel(b - 40), a)
   *p\borderHover  = RGBA(ClampChannel(r - 10), ClampChannel(g - 10), ClampChannel(b - 10), a)
   *p\borderActive = RGBA(ClampChannel(r + 10), ClampChannel(g + 10), ClampChannel(b + 10), a)
   *p\borderPressed = *p\borderActive
   
   If brightness > 128
      *p\textNormal = RGBA(40, 40, 40, a)
      *p\textHover  = RGBA(0, 0, 0, a)
   Else
      *p\textHover  = RGBA(255, 255, 255, a)
      *p\textNormal = RGBA(240, 240, 240, a)
   EndIf
EndProcedure

; Универсальная функция проверки мыши по физическим координатам структуры
Procedure.b CheckMouseInWidget(*w.Widget, mx.i, my.i)
   ProcedureReturn Bool(mx >= *w\physX And mx <= *w\physX + *w\physW And my >= *w\physY And my <= *w\physY + *w\physH)
EndProcedure

; --- ФУНКЦИИ ОТРИСОВКИ ---
Procedure DrawButton(*w.Widget, *palette.WidgetPalette, fontID.i = 0)
   Protected.l currentBg, currentBorder, currentText
   
   If *w\state\isPressed And *w\state\isHover
      currentBg = *palette\bgPressed : currentBorder = *palette\borderPressed : currentText = *palette\textNormal
   ElseIf *w\state\isHover
      currentBg = *palette\bgHover   : currentBorder = *palette\borderHover   : currentText = *palette\textHover
   ElseIf *w\state\isActive
      currentBg = *palette\bgActive  : currentBorder = *palette\borderActive  : currentText = *palette\textNormal
   Else
      currentBg = *palette\bgNormal  : currentBorder = *palette\borderNormal  : currentText = *palette\textNormal
   EndIf
   
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   RoundBox(*w\physX, *w\physY, *w\physW, *w\physH, *w\physRadius, *w\physRadius, currentBg)
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
   RoundBox(*w\physX, *w\physY, *w\physW, *w\physH, *w\physRadius, *w\physRadius, currentBorder)
   
   DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
   If fontID : DrawingFont(fontID) : EndIf
   
   Protected.i textWidth = TextWidth(*w\text)
   Protected.i textHeight = TextHeight(*w\text)
   DrawText(*w\physX + (*w\physW - textWidth) / 2, *w\physY + (*w\physH - textHeight) / 2, *w\text, currentText)
EndProcedure

; --- ГЛОБАЛЬНЫЕ ДАННЫЕ И ИНИЦИАЛИЗАЦИЯ ---
Global ButtonPalette.WidgetPalette
Global AppFont.i
Global ActiveColorIndex.i = 0

; Главная кнопка
Global MainBtn.Widget
MainBtn\logX = 50 : MainBtn\logY = 30 : MainBtn\logW = 150 : MainBtn\logH = 40 : MainBtn\text = "Тестовый виджет"

; Круглые селекторы цвета (теперь как массив виджетов со своими координатами)
Global Dim Colors.l(2) : Colors(0) = RGBA(52, 152, 219, 200) : Colors(1) = RGBA(46, 204, 113, 200) : Colors(2) = RGBA(231, 76, 60, 200)
Global Dim LogSelX.i(2) : LogSelX(0) = 65  : LogSelX(1) = 105 : LogSelX(2) = 145

Global Dim ColorSels.Widget(2)
Define i
For i = 0 To 2
   ColorSels(i)\logX = LogSelX(i)
   ColorSels(i)\logY = 100
   ColorSels(i)\logW = 24
   ColorSels(i)\logH = 24
   ColorSels(i)\color = Colors(i)
Next

; Процедура пересчета ВСЕХ метрик разом
Procedure ApplyLayoutDPI()
   ; Масштабируем главную кнопку
   MainBtn\physX = DesktopScaledX(MainBtn\logX)
   MainBtn\physY = DesktopScaledY(MainBtn\logY)
   MainBtn\physW = DesktopScaledX(MainBtn\logW)
   MainBtn\physH = DesktopScaledY(MainBtn\logH)
   MainBtn\physRadius = DesktopScaledX(6)
   
   ; Масштабируем селекторы в цикле
   Define i
   For i = 0 To 2
      ColorSels(i)\physX = DesktopScaledX(ColorSels(i)\logX)
      ColorSels(i)\physY = DesktopScaledY(ColorSels(i)\logY)
      ColorSels(i)\physW = DesktopScaledX(ColorSels(i)\logW)
      ColorSels(i)\physH = DesktopScaledY(ColorSels(i)\logH)
      ColorSels(i)\physRadius = ColorSels(i)\physW / 2 ; Радиус окружности
   Next
EndProcedure

; --- ОБНОВЛЕНИЕ ЭКРАНА ---
Procedure RefreshCanvas()
   If StartDrawing(CanvasOutput(0))
      Protected.i canvasW = OutputWidth()
      Protected.i canvasH = OutputHeight()
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, canvasW, canvasH, RGB(245, 245, 245))
      
      Box(0, DesktopScaledY(45), canvasW, DesktopScaledY(10), RGB(220, 220, 220))
      
      ; 1. Рисуем главную кнопку из структуры
      DrawButton(@MainBtn, @ButtonPalette, FontID(AppFont))
      
      ; 2. Рисуем переключатели цвета из массива структур
      Protected.i i
      For i = 0 To 2
         Protected.i radius = ColorSels(i)\physRadius
         Protected.i centerX = ColorSels(i)\physX + radius
         Protected.i centerY = ColorSels(i)\physY + radius
         
         DrawingMode(#PB_2DDrawing_AlphaBlend)
         Circle(centerX, centerY, radius, ColorSels(i)\color)
         
         DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Outlined)
         Circle(centerX, centerY, radius, RGBA(100, 100, 100, 255))
         
         If i = ActiveColorIndex
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Protected.i dotRadius = DesktopScaledX(3)
            Protected.l dotColor
            If i = 1 : dotColor = RGBA(40, 40, 40, 255) : Else : dotColor = RGBA(255, 255, 255, 255) : EndIf
            Circle(centerX, centerY, dotRadius, dotColor)
         EndIf
      Next i
      
      StopDrawing()
   EndIf
EndProcedure

CalcWidgetPalette(ColorSels(ActiveColorIndex)\color, @ButtonPalette)
AppFont = LoadFont(#PB_Any, "Segoe UI", 10, #PB_Font_HighQuality)
ApplyLayoutDPI()

; --- НОМЕРА ГАДЖЕТОВ ДЛЯ УДОБСТВА ---
Enumeration
  #MainCanvas
  #SliderR
  #SliderG
  #SliderB
  #SliderA
  #LabelR
  #LabelG
  #LabelB
  #LabelA
EndEnumeration

If OpenWindow(0, 0, 0, 500, 160, "Structured DPI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   CanvasGadget(0, 0, 0, 250, 160)
   RefreshCanvas()
   ; Переменные для хранения текущих значений каналов цвета
   Global CurrentR.l = 52
   Global CurrentG.l = 152
   Global CurrentB.l = 219
   Global CurrentA.l = 200
   
   ContainerGadget(-1, 260,0,250,160)
   ; Добавляем текстовые подписи и трекбары под холстом
   TextGadget(#LabelR, 10,  10, 60, 20, "R: 52")
   TrackBarGadget(#SliderR, 20,  30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderR, CurrentR)
   
   TextGadget(#LabelG, 70, 10, 60, 20, "G: 152")
   TrackBarGadget(#SliderG, 80, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderG, CurrentG)
   
   TextGadget(#LabelB, 130, 10, 60, 20, "B: 219")
   TrackBarGadget(#SliderB, 140, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderB, CurrentB)
   
   TextGadget(#LabelA, 190, 10, 60, 20, "A: 200")
   TrackBarGadget(#SliderA, 200, 30, 30, 125, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderA, CurrentA)
   CloseGadgetList()
   
   Repeat
      Define Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget And EventGadget() = 0
         Define EventType = EventType()
         Define mx = GetGadgetAttribute(0, #PB_Canvas_MouseX)
         Define my = GetGadgetAttribute(0, #PB_Canvas_MouseY)
         
         Define inBtn.b = CheckMouseInWidget(@MainBtn, mx, my)
         Define needRefresh.b = #False
         
         Select EventType
            Case #PB_EventType_MouseMove
               If inBtn
                  If MainBtn\state\isHover = #False
                     MainBtn\state\isHover = #True
                     needRefresh = #True
                  EndIf
               Else
                  If MainBtn\state\isHover = #True
                     MainBtn\state\isHover = #False
                     needRefresh = #True
                  EndIf
               EndIf
               
            Case #PB_EventType_MouseLeave
               If MainBtn\state\isHover
                  MainBtn\state\isHover = #False
                  needRefresh = #True
               EndIf
               
            Case #PB_EventType_LeftButtonDown
               If inBtn
                  MainBtn\state\isPressed = #True
                  needRefresh = #True
               Else
                  Define i
                  For i = 0 To 2
                     If CheckMouseInWidget(@ColorSels(i), mx, my)
                        If ActiveColorIndex <> i
                           ActiveColorIndex = i
                           CalcWidgetPalette(ColorSels(i)\color, @ButtonPalette)
                           needRefresh = #True
                        EndIf
                        Break
                     EndIf
                  Next i
               EndIf
               
            Case #PB_EventType_LeftButtonUp
               If MainBtn\state\isPressed
                  MainBtn\state\isPressed = #False
                  If inBtn
                     If MainBtn\state\isActive : MainBtn\state\isActive = #False : Else : MainBtn\state\isActive = #True : EndIf
                  EndIf
                  needRefresh = #True
               EndIf
         EndSelect
         
         If needRefresh
            RefreshCanvas()
         EndIf
      EndIf
      
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 192
; FirstLine = 188
; Folding = ------
; EnableXP
; DPIAware