EnableExplicit

; Структура для хранения данных каждого конкретного холста
Structure MyCanvasData
  ViewId.i      ; Ссылка на NSView объект Apple
  Width.l       ; Ширина
  Height.l      ; Высота
  ImageBuffer.i ; Скрытый буфер в ОЗУ (нативный NSImage), как у Фреда!
EndStructure

Global MyCanvasClass.i
Global CurrentContextRef.i = 0         ; Сюда сохраняется контекст при StartDrawing_
Global *CurrentCanvas.MyCanvasData = 0 ; Указатель на текущий активный холст, на котором рисуем в ОЗУ

; Объявляем глобальные переменные для двух независимых холстов
Global Canvas1.MyCanvasData
Global Canvas2.MyCanvasData

ImportC ""
  sel_registerName(str.p-ascii)
  objc_allocateClassPair(superclass.i, name.p-ascii, extraBytes.i)
  objc_registerClassPair(class.i)
  class_addMethod(class.i, selector.i, *implementation, types.p-ascii)
  objc_lookUpClass(name.p-ascii)
  
  ; CoreGraphics функции
  CGContextSetRGBStrokeColor(context.i, red.f, green.f, blue.f, alpha.f)
  CGContextSetRGBFillColor(context.i, red.f, green.f, blue.f, alpha.f)
  CGContextStrokeRectWithWidth(context.i, *rect.CGRect, Width.f)
  CGContextFillRect(context.i, *rect.CGRect)
  CGContextBeginPath(context.i)
  CGContextMoveToPoint(context.i, X.f, Y.f)
  CGContextAddLineToPoint(context.i, X.f, Y.f)
  CGContextStrokePath(context.i)
  CGContextSetLineWidth(context.i, Width.f)
  CGContextSetLineCap(context.i, cap.i)
EndImport

;- --- СИСТЕМА УПРАВЛЕНИЯ КОНТЕКСТОМ (КАК У ФРЕДА) ---

; Активирует рисование на конкретном холсте в любой момент времени
Procedure.b StartDrawing_(*Canvas.MyCanvasData)
  If *Canvas = 0 : ProcedureReturn #False : EndIf
  
  ; Если буфера в памяти еще нет — создаем его под точный размер холста
  If *Canvas\ImageBuffer = 0
    Protected size.CGSize
    size\width = *Canvas\Width : size\height = *Canvas\Height
    *Canvas\ImageBuffer = CocoaMessage(0, CocoaMessage(0, objc_lookUpClass("NSImage"), "alloc"), "initWithSize:@", @size)
  EndIf
  
  ; Перенаправляем всё последующее рисование во внутренний буфер картинки в ОЗУ
  CocoaMessage(0, *Canvas\ImageBuffer, "lockFocus")
  
  ; Получаем контекст CoreGraphics для этой картинки
  Protected currentContext.i = CocoaMessage(0, objc_lookUpClass("NSGraphicsContext"), "currentContext")
  CurrentContextRef = CocoaMessage(0, currentContext, "CGContext")
  
  If CurrentContextRef
    *CurrentCanvas = *Canvas ; Запоминаем текущий холст
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; Закрывает контекст рисования и принудительно обновляет экран
Procedure StopDrawing_()
  If *CurrentCanvas And *CurrentCanvas\ImageBuffer
    ; Закрываем контекст картинки в памяти
    CocoaMessage(0, *CurrentCanvas\ImageBuffer, "unlockFocus")
    
    ; Магия Фреда: посылаем ОС сигнал drawRect:, чтобы скопировать буфер на экран!
    CocoaMessage(0, *CurrentCanvas\ViewId, "setNeedsDisplay:", #True)
  EndIf
  CurrentContextRef = 0
  *CurrentCanvas = 0
EndProcedure


;- --- ВАШИ ФУНКЦИИ РИСОВАНИЯ ---

Procedure DrawingClear_(Color.l, Width.l, Height.l)
  If CurrentContextRef = 0 : ProcedureReturn : EndIf
  Protected rect.CGRect
  rect\origin\x = 0 : rect\origin\y = 0
  rect\size\width = Width : rect\size\height = Height
  CGContextSetRGBFillColor(CurrentContextRef, Red(Color)/255.0, Green(Color)/255.0, Blue(Color)/255.0, 1.0)
  CGContextFillRect(CurrentContextRef, @rect)
EndProcedure

Procedure DrawingLine_(X1.f, Y1.f, X2.f, Y2.f, Color.l, Thickness.l = 1)
  If CurrentContextRef = 0 : ProcedureReturn : EndIf
  CGContextBeginPath(CurrentContextRef)
  CGContextSetRGBStrokeColor(CurrentContextRef, Red(Color)/255.0, Green(Color)/255.0, Blue(Color)/255.0, 1.0)
  CGContextSetLineWidth(CurrentContextRef, Thickness)
  CGContextSetLineCap(CurrentContextRef, 1)
  CGContextMoveToPoint(CurrentContextRef, X1, Y1)
  CGContextAddLineToPoint(CurrentContextRef, X2, Y2)
  CGContextStrokePath(CurrentContextRef)
EndProcedure

Procedure DrawingBox_(X.l, Y.l, Width.l, Height.l, Color.l, Thickness.l = 1)
  If CurrentContextRef = 0 : ProcedureReturn : EndIf
  Protected rect.CGRect
  rect\origin\x = X + (Thickness / 2.0)
  rect\origin\y = Y + (Thickness / 2.0)
  rect\size\width = Width - Thickness
  rect\size\height = Height - Thickness
  CGContextSetRGBStrokeColor(CurrentContextRef, Red(Color)/255.0, Green(Color)/255.0, Blue(Color)/255.0, 1.0)
  CGContextStrokeRectWithWidth(CurrentContextRef, @rect, Thickness)
EndProcedure

Procedure DrawingText_(X.f, Y.f, Text.s, Color.l, Size.l = 13)
  If CurrentContextRef = 0 : ProcedureReturn : EndIf
  
  ; Используем ваш обходной синтаксис для парсера массивов PureBasic
  Protected nsString.i = CocoaMessage(0, 0, "NSString stringWithString:$", @Text) 
  Protected nsColor.i = CocoaMessage(0, objc_lookUpClass("NSColor"), "colorWithDeviceRed:", Red(Color)/255.0, "green:", Green(Color)/255.0, "blue:", Blue(Color)/255.0, "alpha:", 1.0)
  Protected nsFont.i = CocoaMessage(0, objc_lookUpClass("NSFont"), "systemFontOfSize:", Size)
  
  Protected keyFont.i = CocoaMessage(0, 0, "NSString stringWithString:$", @"NSFont")
  Protected keyColor.i = CocoaMessage(0, 0, "NSString stringWithString:$", @"NSForegroundColor")
  
  Dim objects.i(1)
  Dim keys.i(1)
  
  objects(0) = nsFont
  objects(1) = nsColor
  
  keys(0) = keyFont
  keys(1) = keyColor
  
  Protected attributes.i = CocoaMessage(0, objc_lookUpClass("NSDictionary"), "dictionaryWithObjects:", @objects(), "forKeys:", @keys(), "count:", 2)
  
  Protected point.CGPoint : point\x = X : point\y = Y
  CocoaMessage(0, nsString, "drawAtPoint:@", @point, "withAttributes:", attributes)
EndProcedure


;- --- ЕДИНЫЙ КОЛЛБЭК ОТРИСОВКИ МАК ОС (drawRect) ---

ProcedureC DrawRectCallback(vSelf.i, sel.i, rect_x.d, rect_y.d, rect_w.d, rect_h.d)
  Protected rect.CGRect
  rect\origin\x = rect_x : rect\origin\y = rect_y : rect\size\width = rect_w : rect\size\height = rect_h
  
;   ; Единственная задача коллбэка — мгновенно вывести на экран уже готовый ImageBuffer
;   If vSelf = Canvas1\ViewId And Canvas1\ImageBuffer
;     CocoaMessage(0, Canvas1\ImageBuffer, "drawInRect:@", @rect)
;   ElseIf vSelf = Canvas2\ViewId And Canvas2\ImageBuffer
;     CocoaMessage(0, Canvas2\ImageBuffer, "drawInRect:@", @rect)
;   EndIf
  
  ; Проверяем первый холст
  If StartDrawing_(@Canvas1)
    Debug "   [Успех] Рисуем на ПЕРВОМ холсте"
    DrawingClear_(RGB(255, 255, 255), Canvas1\Width, Canvas1\Height) 
    DrawingBox_(0, 0, Canvas1\Width, Canvas1\Height, RGB(0, 0, 0), 2) 
    DrawingLine_(0, 0, 300, 380, RGB(0, 100, 255), 4)
    DrawingText_(40, 150, "ПЕРВЫЙ ХОЛСТ", RGB(255, 100, 0), 16)
    StopDrawing_()
  Else
    Debug "   [Пропуск] StartDrawing для ПЕРВОГО холста вернул False"
  EndIf
  
  ; Проверяем второй холст
  If StartDrawing_(@Canvas2)
    Debug "   [Успех] Рисуем на ВТОРОМ холсте"
    DrawingClear_(RGB(40, 44, 52), Canvas2\Width, Canvas2\Height) 
    DrawingBox_(0, 0, Canvas2\Width, Canvas2\Height, RGB(0, 255, 0), 2) 
    DrawingLine_(0, Canvas2\Height, Canvas2\Width, 0, RGB(255, 200, 0), 2)
    DrawingText_(40, 150, "ВТОРОЙ ХОЛСТ", RGB(0, 255, 100), 16)
    StopDrawing_()
  Else
    Debug "   [Пропуск] StartDrawing для ВТОРОГО холста вернул False"
  EndIf
EndProcedure


;- --- АВТОМАТИЧЕСКАЯ РЕГИСТРАЦИЯ И СОЗДАНИЕ ---

Procedure.i CreateCustomCanvas(*Canvas.MyCanvasData, X.i, Y.i, Width.i, Height.i, parentWindowId.i)
  If MyCanvasClass = 0
    Protected NSViewClass.i = objc_lookUpClass("NSView")
    MyCanvasClass = objc_allocateClassPair(NSViewClass, "MyUniversalCanvas", 0)
    Protected drawRectSignature.s = "v@:{CGRect={CGPoint=dd}{CGSize=dd}}"
    class_addMethod(MyCanvasClass, sel_registerName("drawRect:"), @DrawRectCallback(), drawRectSignature)
    objc_registerClassPair(MyCanvasClass)
  EndIf
  
  *Canvas\Width = Width
  *Canvas\Height = Height
  *Canvas\ImageBuffer = 0 ; Изначально буфер пуст
  
  Protected Frame.CGRect
  Frame\origin\x = X : Frame\origin\y = Y : Frame\size\width = Width : Frame\size\height = Height
  
  *Canvas\ViewId = CocoaMessage(0, objc_lookUpClass("MyUniversalCanvas"), "alloc")
  CocoaMessage(0, *Canvas\ViewId, "initWithFrame:@", @Frame)
  
  Protected contentView.i = WindowID(parentWindowId)
  Protected mainContentView.i = CocoaMessage(0, contentView, "contentView")
  CocoaMessage(0, mainContentView, "addSubview:", *Canvas\ViewId)
  
  ProcedureReturn *Canvas\ViewId
EndProcedure


;- --- ЗАПУСК ПРИЛОЖЕНИЯ ---

If OpenWindow(0, 0, 0, 750, 460, "Два независимых Canvas через StartDrawing_", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Создаем первый холст (слева)
  CreateCustomCanvas(@Canvas1, 40, 30, 320, 400, 0)
  
  ; Создаем второй холст (справа)
  CreateCustomCanvas(@Canvas2, 390, 30, 320, 400, 0)
  
  
  ; --- ТЕПЕРЬ РАБОТАЕТ В ЛЮБОЙ МОМЕНТ ВРЕМЕНИ! ---
  
  ; Рисуем на ПЕРВОМ холсте до начала цикла событий
  If StartDrawing_(@Canvas1)
    DrawingClear_(RGB(255, 255, 255), Canvas1\Width, Canvas1\Height) ; Чистим фон белым
    DrawingBox_(0, 0, Canvas1\Width, Canvas1\Height, RGB(0, 0, 0), 2) ; Черная рамка
    
    DrawingLine_(0, 0, 300, 380, RGB(0, 100, 255), 4)
    DrawingText_(40, 150, "ПЕРВЫЙ ХОЛСТ", RGB(255, 100, 0), 16)
    StopDrawing_()
  EndIf
  
  ; Рисуем на ВТОРОМ холсте (демонстрация независимости)
  If StartDrawing_(@Canvas2)
    DrawingClear_(RGB(40, 44, 52), Canvas2\Width, Canvas2\Height) ; Тёмная тема
    DrawingBox_(0, 0, Canvas2\Width, Canvas2\Height, RGB(0, 255, 0), 2) ; Зеленая рамка
    
    DrawingLine_(0, Canvas2\Height, Canvas2\Width, 0, RGB(255, 200, 0), 2)
    DrawingText_(40, 150, "ВТОРОЙ ХОЛСТ СРАЗУ", RGB(0, 255, 100), 16)
    StopDrawing_()
  EndIf
  
  ;- Главный цикл событий
  Repeat
    Define Event.i = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 245
; FirstLine = 224
; Folding = ----
; EnableXP
; DPIAware