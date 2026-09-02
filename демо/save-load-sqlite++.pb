EnableExplicit

UseSQLiteDatabase()

Enumeration Windows
  #Main_Window
EndEnumeration

Enumeration Gadgets
  ; Базовые поля
  #Txt_Category : #Combo_Category
  #Txt_Price    : #Input_Price
  #Txt_Count    : #Input_Count
  
  ; Динамические поля (меняют смысл в зависимости от категории)
  #Txt_Custom1  : #Input_Custom1
  #Txt_Custom2  : #Input_Custom2
  
  ; Кнопки и списки
  #Btn_Add
  #List_Products
  #Btn_Delete
  #Btn_Info
EndEnumeration

Global DB_File.s = "conditioner_parts.db"
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
    ; Создаем таблицу. Свойства 1 и 2 будут хранить уникальные данные для каждого типа товара
    Protected sql.s = "CREATE TABLE IF NOT EXISTS inventory (" +
                      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                      "category TEXT, " +
                      "price REAL, " +
                      "count INTEGER, " +
                      "prop1 TEXT, " +
                      "prop2 TEXT);"
    DatabaseUpdate(DB, sql)
  Else
    MessageRequester("Ошибка", "Не удалось запустить базу данных: " + DatabaseError())
    End
  EndIf
EndProcedure

Procedure RefreshProductList()
  ClearGadgetItems(#List_Products)
  ; Загружаем краткую информацию для главной таблицы
  If DatabaseQuery(DB, "SELECT id, category, price, count FROM inventory ORDER BY id DESC;")
    While NextDatabaseRow(DB)
      Protected ID.s       = GetDatabaseString(DB, 0)
      Protected category.s = GetDatabaseString(DB, 1)
      Protected price.s    = StrF(GetDatabaseFloat(DB, 2), 2) + " руб."
      Protected count.s    = GetDatabaseString(DB, 3) + " шт."
      
      AddGadgetItem(#List_Products, -1, ID + Chr(10) + category + Chr(10) + price + Chr(10) + count)
    Wend
    FinishDatabaseQuery(DB)
  EndIf
EndProcedure

; --- ПЕРЕКЛЮЧЕНИЕ ИНТЕРФЕЙСА ПОД ТИП ТОВАРА ---
Procedure OnCategoryChange()
  Protected selected.i = GetGadgetState(#Combo_Category)
  
  ; Очищаем текстовые поля дополнительных свойств при смене категории
  SetGadgetText(#Input_Custom1, "")
  SetGadgetText(#Input_Custom2, "")
  
  Select selected
    Case 0 ; Барабан
      SetGadgetText(#Txt_Custom1, "Длина (мм):")
      SetGadgetText(#Txt_Custom2, "Толщина (мм):")
      HideGadget(#Input_Custom2, #False) : HideGadget(#Txt_Custom2, #False) ; Показываем оба поля
      
    Case 1 ; Плата управления
      SetGadgetText(#Txt_Custom1, "Тип (Инвертор / Простой):")
      SetGadgetText(#Txt_Custom2, "Завод (Gree / Midea / др.):")
      HideGadget(#Input_Custom2, #False) : HideGadget(#Txt_Custom2, #False) ; Показываем оба поля
  EndSelect
EndProcedure

; --- ДЕТАЛЬНАЯ ИНФОРМАЦИЯ ИЗ БАЗЫ ---
Procedure ShowProductInfo()
  Protected selectedRow.i = GetGadgetState(#List_Products)
  If selectedRow = -1
    MessageRequester("Внимание", "Выберите деталь из списка для просмотра тех. характеристик!")
    ProcedureReturn
  EndIf
  
  Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
  Protected query.s = "SELECT * FROM inventory WHERE id = " + productID + ";"
  
  If DatabaseQuery(DB, query)
    If NextDatabaseRow(DB)
      Protected ID.s       = GetDatabaseString(DB, 0)
      Protected category.s = GetDatabaseString(DB, 1)
      Protected price.d    = GetDatabaseFloat(DB, 2)
      Protected count.i    = GetDatabaseLong(DB, 3)
      Protected prop1.s    = GetDatabaseString(DB, 4)
      Protected prop2.s    = GetDatabaseString(DB, 5)
      
      ; Формируем базовый текст
      Protected infoMessage.s = "📋 ТЕХНИЧЕСКАЯ КАРТОЧКА ДЕТАЛИ" + Chr(13) +
                                "--------------------------------------------------" + Chr(13) +
                                "🆔 Системный номер: " + ID + Chr(13) +
                                "⚙️ Категория: " + category + Chr(13) +
                                "💰 Цена за 1 шт: " + StrD(price, 2) + " руб." + Chr(13) +
                                "🔢 Наличие на складе: " + Str(count) + " шт." + Chr(13) +
                                "💵 Общая стоимость позиции: " + StrD(price * count, 2) + " руб." + Chr(13) +
                                "--------------------------------------------------" + Chr(13) +
                                "🛠 СПЕЦИФИКАЦИИ ДЕТАЛИ:" + Chr(13)
      
      ; Добавляем уникальные свойства в зависимости от того, ЧТО это за товар
      If category = "Барабан кондиционера"
        infoMessage + "📏 Длина окружности: " + prop1 + Chr(13) +
                      "📐 Толщина стенок: " + prop2
      ElseIf category = "Плата управления"
        infoMessage + "⚡ Технология платы: " + prop1 + Chr(13) +
                      "🏭 Завод-изготовитель: " + prop2
      EndIf
      
      MessageRequester("Подробная информация", infoMessage, #PB_MessageRequester_Info)
    EndIf
    FinishDatabaseQuery(DB)
  EndIf
EndProcedure

; --- ДОБАВЛЕНИЕ ТОВАРОВ ---
Procedure AddProduct()
  Protected category.s = GetGadgetText(#Combo_Category)
  Protected price.s    = Trim(GetGadgetText(#Input_Price))
  Protected count.s    = Trim(GetGadgetText(#Input_Count))
  Protected prop1.s    = Trim(GetGadgetText(#Input_Custom1))
  Protected prop2.s    = Trim(GetGadgetText(#Input_Custom2))
  
  If price = "" Or count = "" Or prop1 = "" Or prop2 = ""
    MessageRequester("Внимание", "Пожалуйста, заполните все базовые и технические поля!")
    ProcedureReturn
  EndIf
  
  price = ReplaceString(price, ",", ".")
  prop1 = ReplaceString(prop1, "'", "''")
  prop2 = ReplaceString(prop2, "'", "''")
  
  Protected query.s = "INSERT INTO inventory (category, price, count, prop1, prop2) VALUES (" +
                      "'" + category + "', " + price + ", " + count + ", '" + prop1 + "', '" + prop2 + "');"
  
  If DatabaseUpdate(DB, query)
    SetGadgetText(#Input_Price, "")
    SetGadgetText(#Input_Count, "")
    SetGadgetText(#Input_Custom1, "")
    SetGadgetText(#Input_Custom2, "")
    RefreshProductList()
    MessageRequester("Успех", "Компонент добавлен на компьютер!")
  Else
    MessageRequester("Ошибка", "Ошибка сохранения: " + DatabaseError())
  EndIf
EndProcedure

Procedure DeleteProduct()
  Protected selectedRow.i = GetGadgetState(#List_Products)
  If selectedRow = -1 : ProcedureReturn : EndIf
  Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
  
  If MessageRequester("Удаление", "Удалить выбранную позицию?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
    If DatabaseUpdate(DB, "DELETE FROM inventory WHERE id = " + productID + ";")
      RefreshProductList()
    EndIf
  EndIf
EndProcedure


; --- ЗАПУСК ОKHA ПРИЛОЖЕНИЯ ---
InitDatabase()

If OpenWindow(#Main_Window, 0, 0, 700, 440, "Склад запчастей кондиционеров", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Левая часть: Динамическая форма ввода
  TextGadget(#Txt_Category, 20, 20, 220, 20, "Выберите тип детали:")
  ComboBoxGadget(#Combo_Category, 20, 40, 220, 26)
  AddGadgetItem(#Combo_Category, 0, "Барабан кондиционера")
  AddGadgetItem(#Combo_Category, 1, "Плата управления")
  SetGadgetState(#Combo_Category, 0) ; По умолчанию выбран Барабан
  
  TextGadget(#Txt_Price, 20, 80, 220, 20, "Цена за штуку (руб):")
  StringGadget(#Input_Price, 20, 100, 220, 26, "")
  
  TextGadget(#Txt_Count, 20, 140, 220, 20, "Количество (шт):")
  StringGadget(#Input_Count, 20, 160, 220, 26, "", #PB_String_Numeric)
  
  ; Сюда будут подставляться разные названия параметров
  TextGadget(#Txt_Custom1, 20, 200, 220, 20, "")
  StringGadget(#Input_Custom1, 20, 220, 220, 26, "")
  
  TextGadget(#Txt_Custom2, 20, 260, 220, 20, "")
  StringGadget(#Input_Custom2, 20, 280, 220, 26, "")
  
  ButtonGadget(#Btn_Add, 20, 340, 220, 45, "📥 Записать на ПК")
  
  ; Правая часть: Общая таблица
  ListIconGadget(#List_Products, 260, 20, 420, 340, "ID", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#List_Products, 1, "Тип компонента", 180)
  AddGadgetColumn(#List_Products, 2, "Цена за ед.", 110)
  AddGadgetColumn(#List_Products, 3, "Остаток", 70)
  
  ButtonGadget(#Btn_Info, 260, 380, 200, 35, "🔍 Подробное инфо")
  ButtonGadget(#Btn_Delete, 530, 380, 150, 35, "❌ Удалить")
  
  ; Первичная настройка подписей и вывод данных
  OnCategoryChange()
  RefreshProductList()
  
  ; --- ГЛАВНЫЙ ЦИКЛ СОБЫТИЙ ---
  Repeat
    Define Event.i = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case #Combo_Category
          ; Изменяем интерфейс "на лету" при переключении выпадающего списка
          If EventType() = #PB_EventType_Change
            OnCategoryChange()
          EndIf
          
        Case #Btn_Add
          AddProduct()
          
        Case #Btn_Delete
          DeleteProduct()
          
        Case #Btn_Info
          ShowProductInfo()
          
        Case #List_Products
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
; CursorPosition = 31
; FirstLine = 28
; Folding = -----
; EnableXP
; DPIAware