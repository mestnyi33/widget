EnableExplicit

; Структура для настроек
Structure ProgramSettings
  KeyType.i     ; 0 = CapsLock, 1 = Left Shift, 2 = Right Shift
  HoldTime.i    ; Время зажима в мс
EndStructure

Global hHook.i
Global IsPressed.b = #False
Global OtherKeyPressed.b = #False
Global KeyPressTime.q = 0
Global Settings.ProgramSettings

; Константы для интерфейса
Enumeration Windows
  #MainWin
EndEnumeration

Enumeration Gadgets
  #TxtKey : #ComboKey
  #TxtTime : #TrackTime : #LblTimeValue
  #BtnSave : #BtnHide
EndEnumeration

Enumeration TrayMenu
  #TrayIcon
  #MenuShow
  #MenuExit
EndEnumeration

; Процедура загрузки настроек
Procedure LoadSettings()
  OpenPreferences(GetCurrentDirectory() + "settings.ini")
  Settings\KeyType = ReadPreferenceInteger("KeyType", 0)   ; По умолчанию CapsLock
  Settings\HoldTime = ReadPreferenceInteger("HoldTime", 250) ; По умолчанию 250 мс
  ClosePreferences()
EndProcedure

; Процедура сохранения настроек
Procedure SaveSettings()
  If CreatePreferences(GetCurrentDirectory() + "settings.ini")
    WritePreferenceInteger("KeyType", Settings\KeyType)
    WritePreferenceInteger("HoldTime", Settings\HoldTime)
    ClosePreferences()
  EndIf
EndProcedure

; Функция определения текущей выбранной системной клавиши
Procedure.i GetTargetVK()
  Select Settings\KeyType
    Case 0 : ProcedureReturn #VK_CAPITAL
    Case 1 : ProcedureReturn #VK_LSHIFT
    Case 2 : ProcedureReturn #VK_RSHIFT
  EndSelect
  ProcedureReturn #VK_CAPITAL
EndProcedure

; Процедура хука клавиатуры
Procedure.i _KeyboardProc(nCode.l, wParam.i, lParam.i)
  Protected *pkbs.KBDLLHOOKSTRUCT = lParam
  Protected HoldDuration.q
  Protected TargetVK.i = GetTargetVK()
  
  If nCode = #HC_ACTION
    If *pkbs\vkCode = TargetVK
      
      If wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN
         If Not IsPressed
            Debug 111
            IsPressed = #True
            OtherKeyPressed = #False
            KeyPressTime = ElapsedMilliseconds()
            ProcedureReturn 1
         EndIf
         
     ElseIf wParam = #WM_KEYUP Or wParam = #WM_SYSKEYUP
        If IsPressed
           IsPressed = #False
           HoldDuration = ElapsedMilliseconds() - KeyPressTime
           Debug 222
           If Not OtherKeyPressed
              If HoldDuration < Settings\HoldTime
                 Debug 44
                 ; Короткое нажатие -> Переключение языка (Win + Space)
                 keybd_event_(#VK_LWIN, 0, 0, 0)
                 keybd_event_(#VK_SPACE, 0, 0, 0)
                 keybd_event_(#VK_SPACE, 0, #KEYEVENTF_KEYUP, 0)
                 keybd_event_(#VK_LWIN, 0, #KEYEVENTF_KEYUP, 0)
              ProcedureReturn 1
        Else
                 Debug 333
               ; Долгое нажатие -> Стандартное действие выбранной клавиши
                 IsPressed = 1
                 keybd_event_(TargetVK, 0, 0, 0)
                 IsPressed = 0
                 keybd_event_(TargetVK, 0, #KEYEVENTF_KEYUP, 0)
               ;  ProcedureReturn CallNextHookEx_(hHook, nCode, #WM_KEYDOWN, lParam)
              EndIf
           EndIf
        EndIf
     EndIf
     
    Else
      If IsPressed And (wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN)
        OtherKeyPressed = #True
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn CallNextHookEx_(hHook, nCode, wParam, lParam)
EndProcedure
Procedure.i KeyboardProc(nCode.l, wParam.i, lParam.i)
  Protected *pkbs.KBDLLHOOKSTRUCT = lParam
  Protected HoldDuration.q
  Protected TargetVK.i = GetTargetVK()
  
  If nCode = #HC_ACTION
    ; Игнорируем клавиши, которые мы сами сгенерировали программно,
    ; чтобы избежать бесконечного цикла/рекурсии
    If (*pkbs\flags & #LLKHF_INJECTED)
      ProcedureReturn CallNextHookEx_(hHook, nCode, wParam, lParam)
    EndIf
    
    If *pkbs\vkCode = TargetVK
      
      If wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN
        If Not IsPressed
         ; Debug "Начало удержания целевой клавиши"
          IsPressed = #True
          OtherKeyPressed = #False
          KeyPressTime = ElapsedMilliseconds()
          ProcedureReturn 1 ; Блокируем системное нажатие, ждем отпускания
        EndIf
        ProcedureReturn 1 ; Блокируем автоповтор (системный зажим)
         
      ElseIf wParam = #WM_KEYUP Or wParam = #WM_SYSKEYUP
        If IsPressed
          IsPressed = #False
          HoldDuration = ElapsedMilliseconds() - KeyPressTime
          
          If Not OtherKeyPressed
            If HoldDuration < Settings\HoldTime
             ; Debug "Короткое нажатие -> Переключение языка (Win + Space)"
              keybd_event_(#VK_LWIN, 0, 0, 0)
              keybd_event_(#VK_SPACE, 0, 0, 0)
              keybd_event_(#VK_SPACE, 0, #KEYEVENTF_KEYUP, 0)
              keybd_event_(#VK_LWIN, 0, #KEYEVENTF_KEYUP, 0)
            Else
             ; Debug "Долгое нажатие -> Стандартное действие целевой клавиши"
              ; Теперь keybd_event_ безопасен, так как LLKHF_INJECTED отсекается выше
              keybd_event_(TargetVK, 0, 0, 0)
              keybd_event_(TargetVK, 0, #KEYEVENTF_KEYUP, 0)
            EndIf
          EndIf
          ProcedureReturn 1 ; Блокируем оригинальный UP, так как мы его обработали
        EndIf
      EndIf
     
    Else
      ; Если зажата целевая клавиша, но нажата ДРУГАЯ клавиша — взводим флаг комбо-нажатия
      If IsPressed And (wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN)
       ; Debug "Была нажата другая клавиша во время удержания целевой"
        OtherKeyPressed = #True
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn CallNextHookEx_(hHook, nCode, wParam, lParam)
EndProcedure

; Инициализация
LoadSettings()
hHook = SetWindowsHookEx_(#WH_KEYBOARD_LL, @KeyboardProc(), GetModuleHandle_(#Null), 0)

; Создаем стандартную иконку для трея (белый квадрат для теста)
CreateImage(0, 16, 16)
StartDrawing(ImageOutput(0))
Box(0, 0, 16, 16, RGB(0, 150, 255))
StopDrawing()

; Меню для иконки в трее
CreatePopupMenu(0)
MenuItem(#MenuShow, "Настройки")
MenuItem(#MenuExit, "Выход")

; Создаем скрытое окно настроек
If OpenWindow(#MainWin, 0, 0, 320, 210, "LangSwitcher Настройки", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)
  
  TextGadget(#TxtKey, 20, 20, 280, 20, "Выберите клавишу для переключения:")
  ComboBoxGadget(#ComboKey, 20, 40, 280, 25)
  AddGadgetItem(#ComboKey, 0, "Caps Lock")
  AddGadgetItem(#ComboKey, 1, "Левый Shift (Left Shift)")
  AddGadgetItem(#ComboKey, 2, "Правый Shift (Right Shift)")
  SetGadgetState(#ComboKey, Settings\KeyType)
  
  TextGadget(#TxtTime, 20, 85, 280, 20, "Время долгого зажима (мс):")
  TrackBarGadget(#TrackTime, 20, 105, 220, 25, 100, 1000)
  SetGadgetState(#TrackTime, Settings\HoldTime)
  TextGadget(#LblTimeValue, 250, 107, 50, 20, Str(Settings\HoldTime))
  
  ButtonGadget(#BtnSave, 20, 160, 130, 30, "Применить")
  ButtonGadget(#BtnHide, 170, 160, 130, 30, "Свернуть в трей")
  
  ; Добавляем иконку в системный трей
  AddSysTrayIcon(#TrayIcon, WindowID(#MainWin), ImageID(0))
  SysTrayIconToolTip(#TrayIcon, "LangSwitcher")
  
  ; Главный цикл обработки событий
  Define Event, EventGadget, EventMenu
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_SysTray
        If EventType() = #PB_EventType_LeftClick Or EventType() = #PB_EventType_RightClick
          DisplayPopupMenu(0, WindowID(#MainWin))
        EndIf
        
      Case #PB_Event_Menu
        Select EventMenu()
          Case #MenuShow
            HideWindow(#MainWin, #False) ; Показываем окно
          Case #MenuExit
            Break ; Выход из программы
        EndSelect
        
      Case #PB_Event_Gadget
        EventGadget = EventGadget()
        Select EventGadget
          Case #TrackTime
            ; Обновляем текст с миллисекундами при движении ползунка
            SetGadgetText(#LblTimeValue, Str(GetGadgetState(#TrackTime)))
            
          Case #BtnSave
            ; Сохраняем новые настройки
            Settings\KeyType = GetGadgetState(#ComboKey)
            Settings\HoldTime = GetGadgetState(#TrackTime)
            SaveSettings()
            MessageRequester("Успех", "Настройки сохранены и применены!", #PB_MessageRequester_Info)
            HideWindow(#MainWin, #True) ; Прячем после сохранения
            
          Case #BtnHide
            HideWindow(#MainWin, #True)
        EndSelect
        
      Case #PB_Event_CloseWindow
        HideWindow(#MainWin, #True) ; При нажатии на крестик окно просто прячется в трей, а не закрывается
    EndSelect
  ForEver
  
EndIf

; Корректное завершение работы
RemoveSysTrayIcon(#TrayIcon)
If hHook : UnhookWindowsHookEx_(hHook) : EndIf
End

; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 134
; FirstLine = 129
; Folding = ------
; EnableXP
; DPIAware