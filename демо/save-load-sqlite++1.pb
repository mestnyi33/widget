; 1. Включаем движок SQLite
UseSQLiteDatabase()

Global DBFile$ = "my_products.db"
Global DB = 0 ; Сюда запишется динамический ID от #PB_Any

Enumeration Windows
  #Main_Window
EndEnumeration

Enumeration Gadgets
  #Txt_Name
  #Inp_Name
  #Txt_Count
  #Inp_Count
  #Txt_Price
  #Inp_Price
  #Btn_Add
  #Btn_Delete
  #Txt_Search
  #Inp_Search
  #List_Products
EndEnumeration

; --- ИНИЦИАЛИЗАЦИЯ БАЗЫ ДАННЫХ ---
Procedure InitDatabase()
   ; Ваша идеальная логика: создаем файл ТОЛЬКО если его вообще нет на диске
   If FileSize(DBFile$) = -1
      If CreateFile(0, DBFile$)
         CloseFile(0)
      Else
         MessageRequester("Ошибка", "Нет прав на создание файла базы данных!")
         End
      EndIf
   EndIf
   
  ; 2. Теперь файл ГАРАНТИРОВАННО существует на диске и это НЕ папка.
  ; Открываем его движком SQLite через #PB_Any
  DB = OpenDatabase(#PB_Any, DBFile$, "", "", #PB_Database_SQLite)
  
  If IsDatabase(DB)
    ; Создаем таблицу, если её еще нет (встроенная магия SQL)
    Protected SQL$ = "CREATE TABLE IF NOT EXISTS items (" +
                     "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                     "name TEXT, " +
                     "count INTEGER, " +
                     "price REAL)"
    
    If DatabaseUpdate(DB, SQL$)
      ProcedureReturn #True ; База полностью готова к работе!
    EndIf
  Else
    MessageRequester("Ошибка SQLite", "Не удалось запустить движок БД: " + DatabaseError(), #PB_MessageRequester_Error)
    ProcedureReturn #False
  EndIf
EndProcedure

; --- ОБНОВЛЕНИЕ ТАБЛИЦЫ ---
Procedure RefreshGrid(SearchQuery$ = "")
  ClearGadgetItems(#List_Products)
  
  If IsDatabase(DB)
    Protected SQL$
    
    If SearchQuery$ = ""
      SQL$ = "SELECT id, name, count, price FROM items ORDER BY id DESC"
    Else
      SearchQuery$ = ReplaceString(SearchQuery$, "'", "''")
      SQL$ = "SELECT id, name, count, price FROM items WHERE name LIKE '%" + SearchQuery$ + "%' ORDER BY id DESC"
    EndIf
    
    If DatabaseQuery(DB, SQL$)
      While NextDatabaseRow(DB)
        Protected ID$    = GetDatabaseString(DB, 0)
        Protected Name$  = GetDatabaseString(DB, 1)
        Protected Count$ = Str(GetDatabaseLong(DB, 2))
        Protected Price$ = StrF(GetDatabaseFloat(DB, 3), 2)
        
        Protected RowData$ = ID$ + Chr(10) + Name$ + Chr(10) + Count$ + Chr(10) + Price$
        AddGadgetItem(#List_Products, -1, RowData$)
      Wend
      FinishDatabaseQuery(DB)
    EndIf
  EndIf
EndProcedure


; --- ЗАПУСК ИНТЕРФЕЙСА ---
If OpenWindow(#Main_Window, 100, 100, 560, 460, "SQLite с динамическим #PB_Any", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#Txt_Name, 20, 20, 100, 20, "Название товара:")
  StringGadget(#Inp_Name, 130, 17, 200, 24, "")
  TextGadget(#Txt_Count, 20, 55, 100, 20, "Количество:")
  StringGadget(#Inp_Count, 130, 52, 200, 24, "", #PB_String_Numeric)
  TextGadget(#Txt_Price, 20, 90, 100, 20, "Цена:")
  StringGadget(#Inp_Price, 130, 87, 200, 24, "")
  
  ButtonGadget(#Btn_Add, 350, 17, 190, 44, "📥 Добавить товар")
  ButtonGadget(#Btn_Delete, 350, 67, 190, 44, "❌ Удалить выбранный")
  TextGadget(#Txt_Search, 20, 135, 100, 20, "Быстрый поиск:")
  StringGadget(#Inp_Search, 130, 132, 410, 24, "")
  
  ListIconGadget(#List_Products, 20, 170, 520, 270, "ID", 0, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#List_Products, 1, "Название товара", 240)
  AddGadgetColumn(#List_Products, 2, "Кол-во", 110)
  AddGadgetColumn(#List_Products, 3, "Цена", 140)

  ; Запускаем инициализацию базы данных
  If InitDatabase()
    RefreshGrid()
  EndIf

  ; --- ОСНОВНОЙ ЦИКЛ ОБРАБОТКИ СОБЫТИЙ ---
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case #Inp_Search
            RefreshGrid(GetGadgetText(#Inp_Search))
            
          Case #Btn_Add
            Name$  = GetGadgetText(#Inp_Name)
            Count$ = GetGadgetText(#Inp_Count)
            Price$ = GetGadgetText(#Inp_Price)
            
            If Name$ = "" Or Count$ = "" Or Price$ = ""
              MessageRequester("Ошибка", "Пожалуйста, заполните все поля!", #PB_MessageRequester_Error)
            Else
              If IsDatabase(DB)
                CleanName$ = ReplaceString(Name$, "'", "''")
                SQL$ = "INSERT INTO items (name, count, price) VALUES (" +
                       "'" + CleanName$ + "', " +
                       Str(Val(Count$)) + ", " +
                       StrF(ValF(Price$), 2) + ")"
                
                If DatabaseUpdate(DB, SQL$)
                  SetGadgetText(#Inp_Search, "")
                  RefreshGrid()
                  SetGadgetText(#Inp_Name, "")
                  SetGadgetText(#Inp_Count, "")
                  SetGadgetText(#Inp_Price, "")
                  SetActiveGadget(#Inp_Name)
                EndIf
              EndIf
            EndIf
            
          Case #Btn_Delete
            SelectedLine = GetGadgetState(#List_Products)
            
            If SelectedLine = -1
              MessageRequester("Информация", "Выберите товар для удаления!", #PB_MessageRequester_Info)
            Else
              If IsDatabase(DB)
                ItemID$ = GetGadgetItemText(#List_Products, SelectedLine, 0)
                SQL$ = "DELETE FROM items WHERE id = " + ItemID$
                
                If DatabaseUpdate(DB, SQL$)
                  SetGadgetText(#Inp_Search, "")
                  RefreshGrid()
                EndIf
              EndIf
            EndIf
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        If IsDatabase(DB) 
          CloseDatabase(DB) 
        EndIf
        End 
        
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 176
; FirstLine = 159
; Folding = ----
; EnableXP
; DPIAware