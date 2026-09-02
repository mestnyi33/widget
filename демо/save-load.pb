; Объявляем константы для элементов интерфейса
Enumeration Windows
  #MainWin
EndEnumeration

Enumeration Gadgets
  #TxtName : #InputName
  #TxtAge  : #InputAge
  #BtnSave : #BtnLoad
EndEnumeration

Define FileName.s = "gui_data.txt"

; Функция для сохранения данных
Procedure SaveData(File.s)
  Protected FileNum = CreateFile(#PB_Any, File)
  If FileNum
    ; Записываем текст из полей ввода в файл
    WriteStringN(FileNum, GetGadgetText(#InputName))
    WriteStringN(FileNum, GetGadgetText(#InputAge))
    CloseFile(FileNum)
    MessageRequester("Успех", "Данные успешно сохранены!")
  Else
    MessageRequester("Ошибка", "Не удалось создать файл.")
  EndIf
EndProcedure

; Функция для загрузки данных
Procedure LoadData(File.s)
  Protected FileNum = ReadFile(#PB_Any, File)
  If FileNum
    ; Читаем строки и заполняем поля ввода
    SetGadgetText(#InputName, ReadString(FileNum))
    SetGadgetText(#InputAge, ReadString(FileNum))
    CloseFile(FileNum)
    MessageRequester("Успех", "Данные успешно загружены!")
  Else
    MessageRequester("Ошибка", "Файл данных не найден.")
  EndIf
EndProcedure

; Создаем главное окно
If OpenWindow(#MainWin, 100, 100, 300, 170, "Ввод и чтение данных", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Создаем элементы GUI (текст, поля ввода, кнопки)
  TextGadget(#TxtName, 20, 20, 80, 20, "Имя:")
  StringGadget(#InputName, 100, 20, 180, 20, "")
  
  TextGadget(#TxtAge, 20, 50, 80, 20, "Возраст:")
  StringGadget(#InputAge, 100, 50, 180, 20, "")
  
  ButtonGadget(#BtnSave, 20, 100, 120, 30, "Сохранить данные")
  ButtonGadget(#BtnLoad, 160, 100, 120, 30, "Загрузить данные")
  
  ; Главный цикл обработки событий (ожидание действий пользователя)
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        ; Проверяем, на какой элемент кликнули
        Select EventGadget()
          Case #BtnSave
            SaveData(FileName)
          Case #BtnLoad
            LoadData(FileName)
        EndSelect
        
      Case #PB_Event_CloseWindow
        ; Выход из программы при закрытии окна
        Break
        
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 74
; FirstLine = 27
; Folding = --
; EnableXP
; DPIAware