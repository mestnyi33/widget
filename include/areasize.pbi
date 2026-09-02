Structure screen
   Width.i
   Height.i
EndStructure

; Объявляем структуру GdkRectangle для Linux, если она не объявлена в системе
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
   Structure GdkRectangle
      X.l
      Y.l
      Width.l
      Height.l
   EndStructure
   
   ; Если используется подсистема Qt, импортируем функции обертки PureBasic для Qt
   CompilerIf Subsystem("qt")
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x64 Or #PB_Processor_x86
         ; Большинство функций Qt-биндингов в PB имеют схожие C-экспорты.
         ; Для точного определения рабочей области используется QGuiApplication::primaryScreen()->availableGeometry()
         ImportC ""
            Qt_QGuiApplication_primaryScreen() ; Получаем указатель на главный QScreen
            Qt_QScreen_availableGeometry(*screen, *rect.GdkRectangle) ; Записываем доступную геометрию в рект
         EndImport
      CompilerEndIf
   CompilerEndIf
CompilerEndIf

Define ScreenSize.screen

Procedure GetScreenWorkAreaSize(*size.screen)
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         ; A check for the 'working area' on the Windows desktop, being aware of the size/position of the task bar:
         ; (see my question / answer by netmaestro here: https://www.purebasic.fr/english/viewtopic.php?f=13&t=75410)
         SystemParametersInfo_(#SPI_GETWORKAREA,0,@wr.RECT,0)
         *size\width = wr\right-wr\left-GetSystemMetrics_(#SM_CXBORDER)*2
         *size\height = wr\bottom-wr\top-(GetSystemMetrics_(#SM_CYCAPTION)+GetSystemMetrics_(#SM_CYBORDER)*2)
         
      CompilerCase #PB_OS_MacOS
         Protected MenuBarHeight.CGFloat
         Protected UsableDesktopArea.NSRect
         Protected ActiveScreen.i, MaxWindowHeight.i, MaxWindowWidth.i
         ; ----- Get screen area with subtracted dock size:
         ActiveScreen = CocoaMessage(0, 0, "NSScreen mainScreen")
         CocoaMessage(@UsableDesktopArea, ActiveScreen, "visibleFrame")
         MaxWindowHeight = UsableDesktopArea\size\height
         MaxWindowWidth = UsableDesktopArea\size\width
         ; ----- Get height of MenuBar:
         CocoaMessage(@MenuBarHeight, CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "mainMenu"), "menuBarHeight")
         ; ----- Subtract height of MenuBar
         MaxWindowHeight - MenuBarHeight
         *size\Width = MaxWindowWidth
         *size\Height = MaxWindowHeight
         
      CompilerCase #PB_OS_Linux
         ; Проверяем с помощью встроенной макро-функции PureBasic, какая подсистема активна
         CompilerIf Subsystem("qt")
            ; === Вариант для подсистемы Qt ===
            Protected *qtScreen, qtWorkArea.GdkRectangle
            
            *qtScreen = Qt_QGuiApplication_primaryScreen()
            If *qtScreen
               ; Получаем Rect без учета доков и панелей (в Qt это доступная геометрия)
               Qt_QScreen_availableGeometry(*qtScreen, @qtWorkArea)
               *size\width = qtWorkArea\Width
               *size\height = qtWorkArea\Height
            Else
               ; Резервный вариант
               *size\width = DesktopWidth(0)
               *size\height = DesktopHeight(0)
            EndIf
            
         CompilerElse
            ; === Вариант для подсистемы GTK (по умолчанию) ===
            Protected *display, *monitor
            Protected workarea.GdkRectangle
            
            ; Получаем доступ к текущему дисплею GDK
            *display = gdk_display_get_default_()
            If *display
               ; Получаем основной монитор системы
               *monitor = gdk_display_get_primary_monitor_(*display)
               If *monitor
                  ; Запрашиваем рабочую область (без учета панелей задач/доков)
                  gdk_monitor_get_workarea_(*monitor, @workarea)
                  *size\width = workarea\width
                  *size\height = workarea\height
               Else
                  ; Резервный вариант, если главный монитор не определился
                  *size\width = DesktopWidth(0)
                  *size\height = DesktopHeight(0)
               EndIf
            Else
               ; Резервный вариант, если графический сервер недоступен
               *size\width = DesktopWidth(0)
               *size\height = DesktopHeight(0)
            EndIf
         CompilerEndIf
         
   CompilerEndSelect
EndProcedure 

; Example - fill the pre-defined variable with the width/height values:
GetScreenWorkAreaSize(@ScreenSize)
Debug "Working area size = " + ScreenSize\width + "x" + ScreenSize\height

; Test output on my PC with Win10, FullHD (1440x900) and 125% DPI setting:
; -------------------------------------------------------------------------
; compiled with PB compiler options =
; a) DPI-aware off: 1534x799
; b) DPI-aware on:  1918x999
;
; (Please note, that the PB functions DesktopWidth()/DesktopHeight() always output 1920x1024 independent of the DPI-aware option!)
;
; Test output on my Mac:
; 1440x830
; -------------------------------------------------------------------------
; TODO!
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 56
; FirstLine = 44
; Folding = --
; EnableXP