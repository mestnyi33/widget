; Структура данных для человека
Structure Person
  Name.s
  Age.i
EndStructure

; Константы элементов интерфейса
Enumeration Windows
  #MainWin
EndEnumeration

Enumeration Gadgets
  #TxtName : #InputName
  #TxtAge  : #InputAge
  #BtnAdd
  #TxtSearch : #InputSearch
  #Table
EndEnumeration

; Константы для горячих клавиш
Enumeration Shortcuts
  #Shortcut_Delete
EndEnumeration

Define FileName.s = "database_gui.dat"
Global NewList People.Person() ; Основной список данных в памяти

; Функция обновления таблицы (с учетом фильтра поиска)
Procedure UpdateTable(Filter.s = "")
  ClearGadgetItems(#Table)
  Filter = LCase(Trim(Filter)) ; Переводим фильтр в нижний регистр для независимости от регистра
  
  ForEach People()
    ; Если фильтр пустой ИЛИ имя содержит искомую строку
    If Filter = "" Or FindString(LCase(People()\Name), Filter)
      ; Добавляем строку в таблицу. Данные для скрытой колонки (ID элемента) пишем в Data-ячейку строки
      Protected RowText.s = People()\Name + Chr(10) + Str(People()\Age)
      AddGadgetItem(#Table, -1, RowText)
      
      ; Привязываем индекс из списка к текущей строке таблицы, чтобы потом правильно удалить
      SetGadgetItemData(#Table, CountGadgetItems(#Table) - 1, ListIndex(People()))
    EndIf
  Next
EndProcedure

; Функция добавления записи
Procedure AddPerson()
  Protected Name.s = Trim(GetGadgetText(#InputName))
  Protected AgeStr.s = Trim(GetGadgetText(#InputAge))
  Protected Age.i = Val(AgeStr)
  
  If Name = ""
    MessageRequester("Предупреждение", "Пожалуйста, введите имя!")
    ProcedureReturn
  EndIf
  
  If Age <= 0 Or AgeStr <> Str(Age)
    MessageRequester("Предупреждение", "Возраст должен быть числом больше 0!")
    ProcedureReturn
  EndIf
  
  ; Добавляем в список
  AddElement(People())
  People()\Name = Name
  People()\Age = Age
  
  ; Сбрасываем поиск, чтобы увидеть добавленного человека, и обновляем таблицу
  SetGadgetText(#InputSearch, "")
  UpdateTable()
  
  ; Очищаем поля ввода
  SetGadgetText(#InputName, "")
  SetGadgetText(#InputAge, "")
  SetActiveGadget(#InputName)
EndProcedure

; Функция удаления выбранной записи
Procedure DeleteSelected()
  Protected SelectedRow.i = GetGadgetState(#Table)
  
  ; Если ни одна строка не выбрана, ничего не делаем
  If SelectedRow = -1
    ProcedureReturn
  EndIf
  
  ; Получаем реальный индекс элемента в связанном списке People()
  Protected ListIdx.i = GetGadgetItemData(#Table, SelectedRow)
  
  ; Переходим к элементу и удаляем его
  SelectElement(People(), ListIdx)
  DeleteElement(People())
  
  ; Обновляем таблицу с сохранением текущего поискового фильтра
  UpdateTable(GetGadgetText(#InputSearch))
EndProcedure

; Автоматическое сохранение при выходе
Procedure SaveToFile(File.s)
  Protected FileNum = CreateFile(#PB_Any, File)
  If FileNum
    WriteLong(FileNum, ListSize(People()))
    ForEach People()
      WriteStringN(FileNum, People()\Name)
      WriteLong(FileNum, People()\Age)
    Next
    CloseFile(FileNum)
  EndIf
EndProcedure

; Автоматическая загрузка при старте
Procedure LoadFromFile(File.s)
  Protected FileNum = ReadFile(#PB_Any, File)
  If FileNum
    ClearList(People())
    Protected Count = ReadLong(FileNum)
    Protected i
    For i = 1 To Count
      AddElement(People())
      People()\Name = ReadString(FileNum)
      People()\Age = ReadLong(FileNum)
    Next
    CloseFile(FileNum)
    UpdateTable()
  EndIf
EndProcedure


; --- Создание интерфейса ---
If OpenWindow(#MainWin, 100, 100, 450, 460, "Продвинутая База Данных", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Горячая клавиша Delete для удаления строк в таблице
  AddKeyboardShortcut(#MainWin, #PB_Shortcut_Delete, #Shortcut_Delete)
  
  ; Блок ввода данных
  TextGadget(#TxtName, 20, 20, 80, 20, "Имя:")
  StringGadget(#InputName, 100, 20, 200, 20, "")
  
  TextGadget(#TxtAge, 20, 50, 80, 20, "Возраст:")
  StringGadget(#InputAge, 100, 50, 200, 20, "")
  
  ButtonGadget(#BtnAdd, 320, 20, 110, 50, "Добавить")
  
  ; Блок поиска (фильтра)
  TextGadget(#TxtSearch, 20, 95, 80, 20, "Поиск:")
  StringGadget(#InputSearch, 100, 92, 330, 20, "")
  
  ; Таблица данных
  ListIconGadget(#Table, 20, 130, 410, 310, "Имя", 260, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#Table, 1, "Возраст", 120)
  
  ; Загружаем данные, если файл уже существует
  LoadFromFile(FileName)
  
  ; Главный цикл
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #BtnAdd
            AddPerson()
            
          Case #InputSearch
            ; Событие изменения текста в поле поиска (живой фильтр)
            If EventType() = #PB_EventType_Change
              UpdateTable(GetGadgetText(#InputSearch))
            EndIf
        EndSelect
        
      Case #PB_Event_Menu
        Select EventMenu()
          Case #Shortcut_Delete
            ; Проверяем, что фокус активен именно на таблице при нажатии Delete
            If GetActiveGadget() = #Table
              DeleteSelected()
            EndIf
        EndSelect
        
      Case #PB_Event_CloseWindow
        ; Перед закрытием автоматически сохраняем всё в файл
        SaveToFile(FileName)
        Break
        
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 24
; FirstLine = 22
; Folding = ----
; EnableXP
; DPIAware