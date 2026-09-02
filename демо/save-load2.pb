; Описываем структуру для человека
Structure Person
  Name.s
  Age.i
EndStructure

; Константы для интерфейса
Enumeration Windows
  #MainWin
EndEnumeration

Enumeration Gadgets
  #TxtName : #InputName
  #TxtAge  : #InputAge
  #BtnAdd  : #BtnSave : #BtnLoad
  #Table
EndEnumeration

Define FileName.s = "database_gui.dat"
Global NewList People.Person() ; Список в памяти для хранения структуры данных

; Функция обновления таблицы на экране
Procedure UpdateTable()
  ClearGadgetItems(#Table)
  ForEach People()
    AddGadgetItem(#Table, -1, People()\Name + Chr(10) + Str(People()\Age))
  Next
EndProcedure

; Функция добавления записи из полей ввода в список
Procedure AddPerson()
  Protected Name.s = Trim(GetGadgetText(#InputName))
  Protected AgeStr.s = Trim(GetGadgetText(#InputAge))
  Protected Age.i = Val(AgeStr)
  
  ; Простая валидация данных
  If Name = ""
    MessageRequester("Предупреждение", "Пожалуйста, введите имя!")
    ProcedureReturn
  EndIf
  
  ; Проверяем, что возраст состоит только из цифр и больше нуля
  If Age <= 0 Or AgeStr <> Str(Age)
    MessageRequester("Предупреждение", "Возраст должен быть числом больше 0!")
    ProcedureReturn
  EndIf
  
  ; Добавляем в структуру
  AddElement(People())
  People()\Name = Name
  People()\Age = Age
  
  ; Обновляем интерфейс и очищаем поля
  UpdateTable()
  SetGadgetText(#InputName, "")
  SetGadgetText(#InputAge, "")
  SetActiveGadget(#InputName) ; Возвращаем фокус на поле ввода имени
EndProcedure

; Функция записи всего списка в файл
Procedure SaveToFile(File.s)
  Protected FileNum = CreateFile(#PB_Any, File)
  If FileNum
    ; Записываем количество элементов
    WriteLong(FileNum, ListSize(People()))
    
    ; Записываем сами данные
    ForEach People()
      WriteStringN(FileNum, People()\Name)
      WriteLong(FileNum, People()\Age)
    Next
    
    CloseFile(FileNum)
    MessageRequester("Успех", "Данные успешно сохранены в файл!")
  Else
    MessageRequester("Ошибка", "Не удалось сохранить файл.")
  EndIf
EndProcedure

; Функция чтения всего списка из файла
Procedure LoadFromFile(File.s)
  Protected FileNum = ReadFile(#PB_Any, File)
  If FileNum
    ClearList(People()) ; Очищаем старые данные в памяти
    
    Protected Count = ReadLong(FileNum)
    Protected i
    
    For i = 1 To Count
      AddElement(People())
      People()\Name = ReadString(FileNum)
      People()\Age = ReadLong(FileNum)
    Next
    
    CloseFile(FileNum)
    UpdateTable()
    MessageRequester("Успех", "Данные успешно загружены!")
  Else
    MessageRequester("Предупреждение", "Файл базы данных не найден.")
  EndIf
EndProcedure


; --- Создание графического интерфейса ---
If OpenWindow(#MainWin, 100, 100, 450, 400, "Управление базой данных", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Поля ввода
  TextGadget(#TxtName, 20, 20, 80, 20, "Имя:")
  StringGadget(#InputName, 100, 20, 200, 20, "")
  
  TextGadget(#TxtAge, 20, 50, 80, 20, "Возраст:")
  StringGadget(#InputAge, 100, 50, 200, 20, "")
  
  ; Кнопки управления
  ButtonGadget(#BtnAdd, 320, 20, 110, 50, "Добавить" + #LF$ + "в список")
  ButtonGadget(#BtnSave, 20, 90, 195, 30, "Сохранить список в файл")
  ButtonGadget(#BtnLoad, 235, 90, 195, 30, "Загрузить список из файла")
  
  ; Таблица для вывода данных
  ListIconGadget(#Table, 20, 140, 410, 240, "Имя", 250, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#Table, 1, "Возраст", 130) ; Добавляем вторую колонку
  
  ; Главный цикл программы
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #BtnAdd
            AddPerson()
          Case #BtnSave
            SaveToFile(FileName)
          Case #BtnLoad
            LoadFromFile(FileName)
        EndSelect
        
      Case #PB_Event_CloseWindow
        Break
        
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 10
; FirstLine = 37
; Folding = ---
; EnableXP
; DPIAware