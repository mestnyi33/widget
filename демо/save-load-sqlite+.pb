EnableExplicit

UseSQLiteDatabase()

Enumeration Windows
  #Main_Window
EndEnumeration

Enumeration Gadgets
  #Txt_Title
  #Input_Name
  #Txt_Price
  #Input_Price
  #Txt_Count
  #Input_Count
  #Btn_Add
  #List_Products
  #Btn_Delete
  #Btn_Info       ; Новая кнопка для вывода информации
EndEnumeration

Global DB_File.s = "shop_inventory.db"
Global DB.i

; --- ИНИЦИАЛИЗАЦИЯ И ОБНОВЛЕНИЕ БД ---
Procedure InitDatabase()
  ; Ваша идеальная логика: создаем файл ТОЛЬКО если его вообще нет на диске
   If FileSize(DB_File) = -1
      If CreateFile(0, DB_File)
         CloseFile(0)
      Else
         MessageRequester("Ошибка", "Нет прав на создание файла базы данных!")
         End
      EndIf
   EndIf
   
  DB = OpenDatabase(#PB_Any, DB_File, "", "", #PB_Database_SQLite)
  If DB
    DatabaseUpdate(DB, "CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, count INTEGER);")
  Else
    MessageRequester("Ошибка", "Не удалось запустить базу данных: " + DatabaseError())
    End
  EndIf
EndProcedure

Procedure RefreshProductList()
  ClearGadgetItems(#List_Products)
  If DatabaseQuery(DB, "SELECT * FROM products ORDER BY id DESC;")
    While NextDatabaseRow(DB)
      Protected ID.s    = GetDatabaseString(DB, 0)
      Protected name.s  = GetDatabaseString(DB, 1)
      Protected price.s = StrF(GetDatabaseFloat(DB, 2), 2)
      Protected count.s = GetDatabaseString(DB, 3)
      AddGadgetItem(#List_Products, -1, ID + Chr(10) + name + Chr(10) + price + " руб." + Chr(10) + count)
    Wend
    FinishDatabaseQuery(DB)
  EndIf
EndProcedure

; --- НОВАЯ ФУНКЦИЯ: ПОЛУЧЕНИЕ ИНФОРМАЦИИ О ТОВАРЕ ---
Procedure ShowProductInfo()
  Protected selectedRow.i = GetGadgetState(#List_Products)
  
  ; Проверяем, выбрана ли строка
  If selectedRow = -1
    MessageRequester("Внимание", "Выберите товар из списка для просмотра информации!")
    ProcedureReturn
  EndIf
  
  ; 1. Получаем ID товара из первой колонки выбранной строки таблицы
  Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
  
  ; 2. Делаем SQL-запрос к БД для поиска товара именно по этому ID
  Protected query.s = "SELECT * FROM products WHERE id = " + productID + ";"
  
  If DatabaseQuery(DB, query)
    If NextDatabaseRow(DB)
      ; Читаем данные из колонок ответа
      Protected ID.s    = GetDatabaseString(DB, 0)
      Protected name.s  = GetDatabaseString(DB, 1)
      Protected price.d = GetDatabaseFloat(DB, 2)
      Protected count.i = GetDatabaseLong(DB, 3)
      
      ; Формируем красивую карточку товара
      Protected infoMessage.s = "📋 КАРТОЧКА ТОВАРА" + Chr(13) +
                                "----------------------------------------" + Chr(13) +
                                "🆔 Системный ID: " + ID + Chr(13) +
                                "📦 Наименование: " + name + Chr(13) +
                                "💰 Цена за единицу: " + StrD(price, 2) + " руб." + Chr(13) +
                                "🔢 Остаток на складе: " + Str(count) + " шт." + Chr(13) +
                                "----------------------------------------" + Chr(13) +
                                "💵 Общая стоимость позиции: " + StrD(price * count, 2) + " руб."
      
      ; Выводим информацию на экран компьютера
      MessageRequester("Информация о товаре", infoMessage, #PB_MessageRequester_Info)
    Else
      MessageRequester("Ошибка", "Товар с таким ID не найден в базе данных.")
    EndIf
    FinishDatabaseQuery(DB)
  Else
    MessageRequester("Ошибка SQL", "Не удалось извлечь данные: " + DatabaseError())
  EndIf
EndProcedure

; --- ДОБАВЛЕНИЕ И УДАЛЕНИЕ ---
Procedure AddProduct()
  Protected name.s  = Trim(GetGadgetText(#Input_Name))
  Protected price.s = Trim(GetGadgetText(#Input_Price))
  Protected count.s = Trim(GetGadgetText(#Input_Count))
  
  If name = "" Or price = "" Or count = ""
    MessageRequester("Внимание", "Пожалуйста, заполните все поля товара!")
    ProcedureReturn
  EndIf
  
  price = ReplaceString(price, ",", ".")
  name = ReplaceString(name, "'", "''")
  Protected query.s = "INSERT INTO products (name, price, count) VALUES ('" + name + "', " + price + ", " + count + ");"
  
  If DatabaseUpdate(DB, query)
    SetGadgetText(#Input_Name, "")
    SetGadgetText(#Input_Price, "")
    SetGadgetText(#Input_Count, "")
    RefreshProductList()
    SetActiveGadget(#Input_Name)
  EndIf
EndProcedure

Procedure DeleteProduct()
  Protected selectedRow.i = GetGadgetState(#List_Products)
  If selectedRow = -1 : MessageRequester("Внимание", "Выберите товар для удаления!") : ProcedureReturn : EndIf
  Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
  
  If MessageRequester("Подтверждение", "Вы уверены, что хотите удалить этот товар?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
    If DatabaseUpdate(DB, "DELETE FROM products WHERE id = " + productID + ";")
      RefreshProductList()
    EndIf
  EndIf
EndProcedure


; --- ЗАПУСК ИНТЕРФЕЙСА ---
InitDatabase()

If OpenWindow(#Main_Window, 0, 0, 650, 420, "Управление товарами на ПК", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Левая панель формы
  TextGadget(#Txt_Title, 20, 20, 200, 20, "Название товара:")
  StringGadget(#Input_Name, 20, 40, 200, 26, "")
  TextGadget(#Txt_Price, 20, 80, 200, 20, "Цена (руб):")
  StringGadget(#Input_Price, 20, 100, 200, 26, "") 
  TextGadget(#Txt_Count, 20, 140, 200, 20, "Количество на складе:")
  StringGadget(#Input_Count, 20, 160, 200, 26, "", #PB_String_Numeric)
  ButtonGadget(#Btn_Add, 20, 210, 200, 40, "📥 Добавить товар")
  
  ; Правая панель (Таблица)
  ListIconGadget(#List_Products, 240, 20, 390, 330, "ID", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#List_Products, 1, "Наименование", 170)
  AddGadgetColumn(#List_Products, 2, "Цена", 90)
  AddGadgetColumn(#List_Products, 3, "Кол-во", 60)
  
  ; Кнопки управления справа
  ButtonGadget(#Btn_Info, 240, 365, 180, 35, "🔍 Инфо о товаре") ; Наша новая кнопка
  ButtonGadget(#Btn_Delete, 480, 365, 150, 35, "❌ Удалить")
  
  RefreshProductList()
  
  ; --- ЦИКЛ СОБЫТИЙ ---
  Repeat
    Define Event.i = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case #Btn_Add
          AddProduct()
          
        Case #Btn_Delete
          DeleteProduct()
          
        Case #Btn_Info
          ShowProductInfo() ; Вызов по нажатию на кнопку "Инфо о товаре"
          
        Case #List_Products
          ; Дополнительно: открываем инфо по двойному клику мыши на элемент списка
          If EventType() = #PB_EventType_LeftDoubleClick
            ShowProductInfo()
          EndIf
          
      EndSelect
    EndIf
    
  Until Event = #PB_Event_CloseWindow

  If IsDatabase(DB) : CloseDatabase(DB) : EndIf
EndIf
End

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 27
; FirstLine = 25
; Folding = ----
; EnableXP
; DPIAware