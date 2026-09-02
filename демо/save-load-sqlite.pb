EnableExplicit

UseSQLiteDatabase()

; Перечисление всех окон и элементов
Enumeration Windows
   #Main_Window
   #Cat_Window
EndEnumeration

Enumeration Gadgets
   ; Главное окно
   #Txt_Category : #Combo_Category : #Btn_NewCategory
   #Txt_Price    : #Input_Price
   #Txt_Count    : #Input_Count
   #Txt_Custom1  : #Input_Custom1
   #Txt_Custom2  : #Input_Custom2
   #Btn_Add
   #List_Products
   #Btn_Delete
   #Btn_Info
   #Btn_DeleteCategory ; <-- ДОБАВИТЬ СЮДА кнопку удаления категории
   
   ; <-- Поиск
   #Txt_Search 
   #Input_Search
   #Btn_ClearSearch
   
   #Btn_QtyPlus        ; Кнопка +1 к количеству
   #Input_QtyStep
   #Btn_QtyMinus       ; Кнопка -1 к количеству
   #Txt_TotalInventory ; Поле для вывода общей стоимости склада
   
   ; Окно создания категории
   #Txt_NewCatName  : #Input_NewCatName
   #Txt_NewProp1    : #Input_NewProp1
   #Txt_NewProp2    : #Input_NewProp2
   #Btn_SaveCategory
EndEnumeration

Global DB_File.s = "smart_inventory.db"
Global DB.i

; Переменные для хранения структуры текущей выбранной категории
Global Current_Prop1_Name.s = ""
Global Current_Prop2_Name.s = ""

; --- ИНИЦИАЛИЗАЦИЯ И СТРУКТУРА БД ---
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
      ; Таблица категорий
      DatabaseUpdate(DB, "CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, prop1_name TEXT, prop2_name TEXT);")
      ; Таблица товаров
      DatabaseUpdate(DB, "CREATE TABLE IF NOT EXISTS inventory (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, price REAL, count INTEGER, prop1_val TEXT, prop2_val TEXT);")
      
      ; <-- НОВАЯ ТАБЛИЦА: История цен (сохраняет ID товара, старую цену, новую цену и дату/время)
      DatabaseUpdate(DB, "CREATE TABLE IF NOT EXISTS price_history (id INTEGER PRIMARY KEY AUTOINCREMENT, product_id INTEGER, old_price REAL, new_price REAL, change_date TEXT);")
      
      ; Заселение тестовыми данными (если пусто)
      If DatabaseQuery(DB, "SELECT COUNT(*) FROM categories;")
         If NextDatabaseRow(DB) And GetDatabaseLong(DB, 0) = 0
            FinishDatabaseQuery(DB)
            DatabaseUpdate(DB, "INSERT INTO categories (name, prop1_name, prop2_name) VALUES ('Барабан кондиционера', 'Длина (мм)', 'Толщина (мм)');")
            DatabaseUpdate(DB, "INSERT INTO categories (name, prop1_name, prop2_name) VALUES ('Плата управления', 'Тип (Инвертор/Простой)', 'Завод (Gree/Midea)');")
         Else
            FinishDatabaseQuery(DB)
         EndIf
      EndIf
   Else
      MessageRequester("Ошибка", "Не удалось запустить базу данных: " + DatabaseError())
      End
   EndIf
EndProcedure

Procedure UpdateTotalCost()
   ; Запрос считает сумму (Цена * Количество) для абсолютно всех товаров в базе
   Protected query.s = "SELECT SUM(price * count) FROM inventory;"
   Protected total.d = 0.0
   
   If DatabaseQuery(DB, query)
      If NextDatabaseRow(DB)
         total = GetDatabaseFloat(DB, 0)
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
   
   ; Выводим красивый текст внизу окна
   SetGadgetText(#Txt_TotalInventory, "💰 Общая стоимость склада: " + StrD(total, 2) + " руб.")
EndProcedure


; --- ОБНОВЛЕНИЕ СПИСКА КАТЕГОРИЙ В КОМБОБОКСЕ ---
Procedure RefreshCategories()
   ClearGadgetItems(#Combo_Category)
   If DatabaseQuery(DB, "SELECT name FROM categories ORDER BY name ASC;")
      While NextDatabaseRow(DB)
         AddGadgetItem(#Combo_Category, -1, GetDatabaseString(DB, 0))
      Wend
      FinishDatabaseQuery(DB)
   EndIf
   SetGadgetState(#Combo_Category, 0)
EndProcedure

; --- ОБНОВЛЕНИЕ ГЛАВНОЙ ТАБЛИЦЫ ---
Procedure RefreshProductList()
   ClearGadgetItems(#List_Products)
   
   ; Получаем текст из поля поиска и переводим в нижний регистр для удобства
   Protected searchText.s = Trim(GetGadgetText(#Input_Search))
   Protected query.s
   
   ; Если поле поиска пустое — выводим всё. Если заполнено — фильтруем.
   If searchText = ""
      query = "SELECT id, category, price, count FROM inventory ORDER BY id DESC;"
   Else
      ; Экранируем кавычки для безопасности
      searchText = ReplaceString(searchText, "'", "''")
      
      ; Ищем совпадения по категории, свойству 1 или свойству 2
      query = "SELECT id, category, price, count FROM inventory WHERE " +
              "category LIKE '%" + searchText + "%' OR " +
              "prop1_val LIKE '%" + searchText + "%' OR " +
              "prop2_val LIKE '%" + searchText + "%' " +
              "ORDER BY id DESC;"
   EndIf
   
   If DatabaseQuery(DB, query)
      While NextDatabaseRow(DB)
         Protected ID.s       = GetDatabaseString(DB, 0)
         Protected category.s = GetDatabaseString(DB, 1)
         Protected price.s    = StrF(GetDatabaseFloat(DB, 2), 2) + " руб."
         Protected count.s    = GetDatabaseString(DB, 3) + " шт."
         
         AddGadgetItem(#List_Products, -1, ID + Chr(10) + category + Chr(10) + price + Chr(10) + count)
      Wend
      FinishDatabaseQuery(DB)
   EndIf
   
   UpdateTotalCost()
   
EndProcedure

Procedure ClearSearch()
   ; Стираем текст в поле ввода поиска
   SetGadgetText(#Input_Search, "")
   ; Возвращаем фокус ввода (курсор) обратно в поле поиска
   SetActiveGadget(#Input_Search)
   ; Обновляем список, чтобы снова показать абсолютно все товары
   RefreshProductList()
EndProcedure

Procedure.i GetSafeStep()
  ; Считываем то, что реально написано в поле на Mac
  Protected txt.s = Trim(GetGadgetText(#Input_QtyStep))
  Protected value.i = Val(txt)
  
  ; Защита: если там пусто, буквы, ноль или минус — принудительно возвращаем 1
  If value <= 0
    SetGadgetText(#Input_QtyStep, "1") ; Мягко возвращаем визуальную "1" на экран Mac
    ProcedureReturn 1
  EndIf
  
  ProcedureReturn value
EndProcedure

Procedure ChangeProductQuantity(amount.i)
   Protected selectedRow.i = GetGadgetState(#List_Products)
   
   ; Если строка в таблице не выбрана — выходим
   If selectedRow = -1
      MessageRequester("Внимание", "Выберите товар в таблице для изменения его количества!")
      ProcedureReturn
   EndIf
   
   ; Получаем ID товара и текущее количество из базы данных
   Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
   Protected currentCount.i = 0
   
   If DatabaseQuery(DB, "SELECT count FROM inventory WHERE id = " + productID + ";")
      If NextDatabaseRow(DB)
         currentCount = GetDatabaseLong(DB, 0)
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
   
   ; Вычисляем новое количество
   Protected newCount.i = currentCount + amount
   
   ; Защита: количество товара на складе не может быть меньше нуля
   If newCount < 0
      MessageRequester("Внимание", "Невозможно списать товар! Остаток не может быть меньше 0.")
      ProcedureReturn
   EndIf
   
   ; Обновляем базу данных
   If DatabaseUpdate(DB, "UPDATE inventory SET count = " + Str(newCount) + " WHERE id = " + productID + ";")
      ; Обновляем таблицу на экране и общую сумму склада
      RefreshProductList()
      UpdateTotalCost()
      
      ; Возвращаем выделение на ту же строку, которая была выбрана
      SetGadgetState(#List_Products, selectedRow)
   Else
      MessageRequester("Ошибка", "Не удалось изменить количество: " + DatabaseError())
   EndIf
EndProcedure

; --- АДАПТАЦИЯ ИНТЕРФЕЙСА ПОД ВЫБРАННУЮ КАТЕГОРИЮ ---
Procedure OnCategoryChange()
   Protected catName.s = GetGadgetText(#Combo_Category)
   If catName = "" : ProcedureReturn : EndIf
   
   catName = ReplaceString(catName, "'", "''")
   If DatabaseQuery(DB, "SELECT prop1_name, prop2_name FROM categories WHERE name = '" + catName + "';")
      If NextDatabaseRow(DB)
         Current_Prop1_Name = GetDatabaseString(DB, 0)
         Current_Prop2_Name = GetDatabaseString(DB, 1)
         
         ; Меняем надписи над полями ввода на ходу!
         SetGadgetText(#Txt_Custom1, Current_Prop1_Name + ":")
         SetGadgetText(#Txt_Custom2, Current_Prop2_Name + ":")
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
EndProcedure

; --- ОКНО: СОЗДАНИЕ НОВОЙ КАТЕГОРИИ ---
Procedure OpenNewCategoryWindow()
   ; Блокируем главное окно, пока открыто это
   DisableWindow(#Main_Window, #True)
   
   If OpenWindow(#Cat_Window, 0, 0, 300, 240, "Новая категория", #PB_Window_SystemMenu | #PB_Window_WindowCentered, WindowID(#Main_Window))
      TextGadget(#Txt_NewCatName, 10, 15, 280, 20, "Название категории (напр. Компрессор):")
      StringGadget(#Input_NewCatName, 10, 35, 280, 24, "")
      
      TextGadget(#Txt_NewProp1, 10, 75, 280, 20, "Свойство №1 (напр. Мощность BTU):")
      StringGadget(#Input_NewProp1, 10, 95, 280, 24, "")
      
      TextGadget(#Txt_NewProp2, 10, 135, 280, 20, "Свойство №2 (напр. Марка фреона):")
      StringGadget(#Input_NewProp2, 10, 155, 280, 24, "")
      
      ButtonGadget(#Btn_SaveCategory, 10, 195, 280, 35, "💾 Сохранить категорию")
   EndIf
EndProcedure

Procedure SaveNewCategory()
   Protected name.s  = Trim(GetGadgetText(#Input_NewCatName))
   Protected prop1.s = Trim(GetGadgetText(#Input_NewProp1))
   Protected prop2.s = Trim(GetGadgetText(#Input_NewProp2))
   
   If name = "" Or prop1 = "" Or prop2 = ""
      MessageRequester("Внимание", "Заполните имя категории и оба специфических свойства!")
      ProcedureReturn
   EndIf
   
   name = ReplaceString(name, "'", "''")
   prop1 = ReplaceString(prop1, "'", "''")
   prop2 = ReplaceString(prop2, "'", "''")
   
   If DatabaseUpdate(DB, "INSERT INTO categories (name, prop1_name, prop2_name) VALUES ('" + name + "', '" + prop1 + "', '" + prop2 + "');")
      CloseWindow(#Cat_Window)
      DisableWindow(#Main_Window, #False)
      SetActiveWindow(#Main_Window)
      
      RefreshCategories()
      OnCategoryChange()
      MessageRequester("Успех", "Категория '" + name + "' создана и готова к работе!")
   Else
      MessageRequester("Ошибка", "Такая категория уже существует или произошел сбой БД.")
   EndIf
EndProcedure

Procedure DeleteCategory()
   Protected catName.s = GetGadgetText(#Combo_Category)
   
   ; Если в списке пусто, ничего не делаем
   If catName = ""
      MessageRequester("Внимание", "Нет выбранной категории для удаления!")
      ProcedureReturn
   EndIf
   
   ; Проверяем, есть ли уже товары в этой категории, чтобы избежать случайной порчи базы данных
   Protected checkQuery.s = "SELECT COUNT(*) FROM inventory WHERE category = '" + ReplaceString(catName, "'", "''") + "';"
   Protected goodsCount.i = 0
   
   If DatabaseQuery(DB, checkQuery)
      If NextDatabaseRow(DB)
         goodsCount = GetDatabaseLong(DB, 0)
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
   
   ; Если в категории есть товары, предупреждаем пользователя
   If goodsCount > 0
      If MessageRequester("Внимание", "В категории '" + catName + "' находится товаров: " + Str(goodsCount) + " шт." + Chr(13) + 
         "Если вы удалите её, эти товары останутся без привязки к свойствам." + Chr(13) + 
         "Всё равно удалить категорию?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) = #PB_MessageRequester_No
         ProcedureReturn
      EndIf
   Else
      ; Если товаров нет, просто запрашиваем обычное подтверждение
      If MessageRequester("Подтверждение", "Вы уверены, что хотите удалить категорию '" + catName + "'?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_No
         ProcedureReturn
      EndIf
   EndIf
   
   ; Удаляем категорию из базы данных
   Protected deleteQuery.s = "DELETE FROM categories WHERE name = '" + ReplaceString(catName, "'", "''") + "';"
   If DatabaseUpdate(DB, deleteQuery)
      ; Обновляем комбобокс и интерфейс
      RefreshCategories()
      OnCategoryChange()
      MessageRequester("Успех", "Категория '" + catName + "' успешно удалена!")
   Else
      MessageRequester("Ошибка", "Не удалось удалить категорию: " + DatabaseError())
   EndIf
EndProcedure
Procedure DeleteCategory2() ; измененный под каскадное удаление 
   Protected catName.s = GetGadgetText(#Combo_Category)
   
   ; Если в списке пусто, ничего не делаем
   If catName = ""
      MessageRequester("Внимание", "Нет выбранной категории для удаления!")
      ProcedureReturn
   EndIf
   
   ; Проверяем, есть ли товары в этой категории
   Protected checkQuery.s = "SELECT COUNT(*) FROM inventory WHERE category = '" + ReplaceString(catName, "'", "''") + "';"
   Protected goodsCount.i = 0
   
   If DatabaseQuery(DB, checkQuery)
      If NextDatabaseRow(DB)
         goodsCount = GetDatabaseLong(DB, 0)
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
   
   ; Текст предупреждения в зависимости от наличия товаров
   Protected confirmMsg.s
   If goodsCount > 0
      confirmMsg = "⚠️ ВНИМАНИЕ!" + Chr(13) + 
      "В категории '" + catName + "' находится товаров: " + Str(goodsCount) + " шт." + Chr(13) +
      "Они будут НАВСЕГДА УДАЛЕНЫ вместе с категорией!" + Chr(13) + Chr(13) +
      "Вы точно хотите продолжить?"
   Else
      confirmMsg = "Вы уверены, что хотите удалить пустую категорию '" + catName + "'?"
   EndIf
   
   ; Запрос подтверждения у пользователя
   If MessageRequester("Подтверждение удаления", confirmMsg, #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) = #PB_MessageRequester_No
      ProcedureReturn
   EndIf
   
   ; Экранируем кавычки для безопасного SQL-запроса
   Protected safeCatName.s = ReplaceString(catName, "'", "''")
   
   ; Включаем транзакцию, чтобы оба удаления прошли как единое целое
   DatabaseUpdate(DB, "BEGIN TRANSACTION;")
   
   ; 1. Удаляем все связанные товары из инвентаря
   Protected deleteGoodsQuery.s = "DELETE FROM inventory WHERE category = '" + safeCatName + "';"
   Protected successGoods.i = DatabaseUpdate(DB, deleteGoodsQuery)
   
   ; 2. Удаляем саму категорию
   Protected deleteCatQuery.s = "DELETE FROM categories WHERE name = '" + safeCatName + "';"
   Protected successCat.i = DatabaseUpdate(DB, deleteCatQuery)
   
   ; Если оба шага успешны — сохраняем изменения, иначе отменяем
   If successGoods And successCat
      DatabaseUpdate(DB, "COMMIT;")
      
      ; Обновляем списки в интерфейсе программы
      RefreshCategories()
      OnCategoryChange()
      RefreshProductList()
      
      MessageRequester("Успех", "Категория '" + catName + "' и все её товары успешно удалены!")
   Else
      DatabaseUpdate(DB, "ROLLBACK;")
      MessageRequester("Ошибка", "Не удалось выполнить каскадное удаление: " + DatabaseError())
   EndIf
EndProcedure

; --- ДОБАВЛЕНИЕ ТОВАРОВ В ИНВЕНТАРЬ ---
Procedure AddProduct()
   Protected category.s = GetGadgetText(#Combo_Category)
   Protected price.s    = Trim(GetGadgetText(#Input_Price))
   Protected count.s    = Trim(GetGadgetText(#Input_Count))
   Protected p1_val.s   = Trim(GetGadgetText(#Input_Custom1))
   Protected p2_val.s   = Trim(GetGadgetText(#Input_Custom2))
   
   If category = "" : MessageRequester("Внимание", "Сначала создайте категорию!") : ProcedureReturn : EndIf
   If price = "" Or count = "" Or p1_val = "" Or p2_val = ""
      MessageRequester("Внимание", "Заполните цену, количество и тех. характеристики товара!")
      ProcedureReturn
   EndIf
   
   price = ReplaceString(price, ",", ".")
   Protected newPrice.d = ValD(price)
   Protected newCount.i = Val(count)
   
   Protected safeCategory.s = ReplaceString(category, "'", "''")
   Protected safeP1.s       = ReplaceString(p1_val, "'", "''")
   Protected safeP2.s       = ReplaceString(p2_val, "'", "''")
   
   ; Получаем ID, количество и ТЕКУЩУЮ ЦЕНУ для проверки дубликата
   Protected checkQuery.s = "SELECT id, count, price FROM inventory WHERE " +
                            "category = '" + safeCategory + "' AND " +
                            "prop1_val = '" + safeP1 + "' AND " +
                            "prop2_val = '" + safeP2 + "';"
   
   Protected existingID.i = 0
   Protected existingCount.i = 0
   Protected oldPrice.d = 0.0
   Protected isDuplicate.i = #False
   
   If DatabaseQuery(DB, checkQuery)
      If NextDatabaseRow(DB)
         existingID = GetDatabaseLong(DB, 0)
         existingCount = GetDatabaseLong(DB, 1)
         oldPrice = GetDatabaseFloat(DB, 2)
         isDuplicate = #True
      EndIf
      FinishDatabaseQuery(DB)
   EndIf
   
   DatabaseUpdate(DB, "BEGIN TRANSACTION;")
   Protected success.i = #True
   
   If isDuplicate
      Protected finalCount.i = existingCount + newCount
      ; 1. Обновляем товар
      If Not DatabaseUpdate(DB, "UPDATE inventory SET price = " + StrD(newPrice, 2) + ", count = " + Str(finalCount) + " WHERE id = " + Str(existingID) + ";")
         success = #False
      EndIf
      
      ; 2. ЕСЛИ ЦЕНА ИЗМЕНИЛАСЬ — записываем её в историю изменений
      If success And oldPrice <> newPrice
         ; Формируем текущую дату и время (ГГГГ-ММ-ДД ЧЧ:ММ:СС)
         Protected current_time.s = FormatDate("%YYYY-%MM-%DD %HH:%II:%SS", Date())
         Protected historyQuery.s = "INSERT INTO price_history (product_id, old_price, new_price, change_date) VALUES (" +
                                    Str(existingID) + ", " + StrD(oldPrice, 2) + ", " + StrD(newPrice, 2) + ", '" + current_time + "');"
         If Not DatabaseUpdate(DB, historyQuery)
            success = #False
         EndIf
      EndIf
      
      If success
         DatabaseUpdate(DB, "COMMIT;")
         
         ; --- ИСПРАВЛЕНИЕ: Формируем текст уведомления по правилам PureBasic ---
         Protected msg.s = "Товар обновлен. Остаток: " + Str(finalCount) + " шт. "
         If oldPrice <> newPrice
            msg + "Цена изменилась, старая цена сохранена в историю."
         EndIf
         
         MessageRequester("Инфо", msg)
         ; ---------------------------------------------------------------------
         
      Else
         DatabaseUpdate(DB, "ROLLBACK;")
         MessageRequester("Ошибка", "Ошибка при обновлении: " + DatabaseError())
         ProcedureReturn
      EndIf
      
   Else
      ; Для нового уникального товара просто делаем запись в инвентарь
      If DatabaseUpdate(DB, "INSERT INTO inventory (category, price, count, prop1_val, prop2_val) VALUES ('" + safeCategory + "', " + StrD(newPrice, 2) + ", " + Str(newCount) + ", '" + safeP1 + "', '" + safeP2 + "');")
         DatabaseUpdate(DB, "COMMIT;")
         MessageRequester("Успех", "Новый товар добавлен на компьютер!")
      Else
         DatabaseUpdate(DB, "ROLLBACK;")
         MessageRequester("Ошибка", "Ошибка записи: " + DatabaseError())
         ProcedureReturn
      EndIf
   EndIf
   
   SetGadgetText(#Input_Price, "")
   SetGadgetText(#Input_Count, "")
   SetGadgetText(#Input_Custom1, "")
   SetGadgetText(#Input_Custom2, "")
   RefreshProductList()
EndProcedure

; --- ДИНАМИЧЕСКИЙ ПРОСМОТР КАРТОЧКИ ТОВАРА ---
Procedure ShowProductInfo()
   Protected selectedRow.i = GetGadgetState(#List_Products)
   If selectedRow = -1 : MessageRequester("Внимание", "Выберите строку!") : ProcedureReturn : EndIf
   
   Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
   
   Protected query.s = "SELECT i.id, i.category, i.price, i.count, i.prop1_val, i.prop2_val, c.prop1_name, c.prop2_name " +
                       "FROM inventory i " +
                       "INNER JOIN categories c ON i.category = c.name " +
                       "WHERE i.id = " + productID + ";"
   
   If DatabaseQuery(DB, query)
      If NextDatabaseRow(DB)
         Protected ID.s    = GetDatabaseString(DB, 0)
         Protected cat.s   = GetDatabaseString(DB, 1)
         Protected price.d = GetDatabaseFloat(DB, 2)
         Protected count.i = GetDatabaseLong(DB, 3)
         Protected p1_v.s  = GetDatabaseString(DB, 4)
         Protected p2_v.s  = GetDatabaseString(DB, 5)
         Protected p1_n.s  = GetDatabaseString(DB, 6)
         Protected p2_n.s  = GetDatabaseString(DB, 7)
         
         Protected info.s = "📋 УМНАЯ ТЕХНИЧЕСКАЯ КАРТОКА" + Chr(13) +
         "--------------------------------------------------" + Chr(13) +
                                                                "🆔 ID: " + ID + "  |  ⚙️ Категория: " + cat + Chr(13) +
         "💰 Текущая цена: " + StrD(price, 2) + " руб. | 🔢 Остаток: " + Str(count) + " шт." + Chr(13) +
         "💵 Итого по позиции: " + StrD(price * count, 2) + " руб." + Chr(13) +
         "--------------------------------------------------" + Chr(13) +
                                                                "🛠 ТЕХНИЧЕСКИЕ ПАРАМЕТРЫ:" + Chr(13) +
         "🔸 " + p1_n + ": " + p1_v + Chr(13) +
         "🔸 " + p2_n + ": " + p2_v + Chr(13) +
         "--------------------------------------------------" + Chr(13) +
                                                                "📈 ИСТОРИЯ ИЗМЕНЕНИЯ ЦЕН:" + Chr(13)
         
         FinishDatabaseQuery(DB) ; Закрываем первый запрос перед открытием второго
         
         ; Запрашиваем историю цен из базы для этой детали
         Protected historyFound.i = #False
         If DatabaseQuery(DB, "SELECT old_price, new_price, change_date FROM price_history WHERE product_id = " + ID + " ORDER BY id DESC;")
            While NextDatabaseRow(DB)
               historyFound = #True
               Protected oldP.s = StrF(GetDatabaseFloat(DB, 0), 2)
               Protected newP.s = StrF(GetDatabaseFloat(DB, 1), 2)
               Protected dt.s   = GetDatabaseString(DB, 2)
               info + "📅 [" + dt + "] Было: " + oldP + " руб. ➡️ Стало: " + newP + " руб." + Chr(13)
            Wend
            FinishDatabaseQuery(DB)
         EndIf
         
         If Not historyFound
            info + "История чиста (цена не менялась с момента добавления)."
         EndIf
         
         MessageRequester("Свойства товара", info, #PB_MessageRequester_Info)
      Else
         FinishDatabaseQuery(DB)
      EndIf
   EndIf
EndProcedure

Procedure DeleteProduct()
   Protected selectedRow.i = GetGadgetState(#List_Products)
   If selectedRow = -1 : ProcedureReturn : EndIf
   Protected productID.s = GetGadgetItemText(#List_Products, selectedRow, 0)
   If MessageRequester("Удаление", "Удалить?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      If DatabaseUpdate(DB, "DELETE FROM inventory WHERE id = " + productID + ";")
         RefreshProductList()
      EndIf
   EndIf
EndProcedure


; --- ЗАПУСК ГЛАВНОГО ОКНА ПРИЛОЖЕНИЯ ---
InitDatabase()

If OpenWindow(#Main_Window, 0, 0, 750, 440, "Конструктор склада запчастей", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; Замените этот кусочек на вариант с двумя кнопками (➕ и ❌):
   TextGadget(#Txt_Category, 20, 15, 130, 20, "Категория детали:")
   ComboBoxGadget(#Combo_Category, 20, 35, 140, 26)              ; Немного уменьшили ширину (со 170 до 140)
   ButtonGadget(#Btn_NewCategory, 160, 35, 35, 26, "➕")          ; Кнопка добавления
   ButtonGadget(#Btn_DeleteCategory, 200, 35, 35, 26, "❌")       ; Кнопка удаления категории
   
   TextGadget(#Txt_Price, 20, 75, 210, 20, "Цена за 1 шт (руб):")
   StringGadget(#Input_Price, 20, 95, 210, 26, "")
   
   TextGadget(#Txt_Count, 20, 135, 210, 20, "Количество (шт):")
   StringGadget(#Input_Count, 20, 155, 210, 26, "", #PB_String_Numeric)
   ; Динамические подписи (инициализируются функцией OnCategoryChange)
   TextGadget(#Txt_Custom1, 20, 195, 210, 20, "Свойство 1:")
   StringGadget(#Input_Custom1, 20, 215, 210, 26, "")
   TextGadget(#Txt_Custom2, 20, 255, 210, 20, "Свойство 2:")
   StringGadget(#Input_Custom2, 20, 275, 210, 26, "")
   ButtonGadget(#Btn_Add, 20, 335, 210, 45, "📥 Записать на компьютер")
   ; Поиск
   TextGadget(#Txt_Search, 250, 18, 50, 20, "Поиск:")
   StringGadget(#Input_Search, 305, 15, 390, 26, "")        ; Уменьшили ширину с 425 до 390
   ButtonGadget(#Btn_ClearSearch, 700, 15, 35, 26, "❌")    ; Маленькая кнопка-крестик рядом
   
   ; Таблицу опустили чуть ниже (координата Y теперь 50 вместо 15, высоту уменьшили до 310)
   ListIconGadget(#List_Products, 250, 50, 480, 310, "ID", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
   AddGadgetColumn(#List_Products, 1, "Категория запчасти", 200)
   AddGadgetColumn(#List_Products, 2, "Цена", 130)
   AddGadgetColumn(#List_Products, 3, "Наличие", 80)
   
   ; Размещаем кнопки изменения количества под таблицей
     ; Блок изменения количества (Кнопка + , Поле ввода, Кнопка -)
  ButtonGadget(#Btn_QtyPlus, 250, 380, 45, 35, "➕")
  StringGadget(#Input_QtyStep, 300, 380, 40, 35, "1", #PB_String_Numeric) ; Поле по центру с цифрой "1"
  ButtonGadget(#Btn_QtyMinus, 345, 380, 45, 35, "➖")
  
  ; Блок остальных кнопок управления (немного сдвинули координаты X)
  ;ButtonGadget(#Btn_EditPrice, 400, 380, 85, 35, "✏️ Цена")
  ButtonGadget(#Btn_Info, 500, 380, 115, 35, "🔍 Свойства")
  ButtonGadget(#Btn_Delete, 625, 380, 105, 35, "❌ Удалить")

   ; Добавляем строку общей стоимости склада в самый низ левой панели (координата Y = 395)
   TextGadget(#Txt_TotalInventory, 20, 395, 220, 25, "💰 Общая стоимость склада: 0.00 руб.")
   
   ; Первичный сбор данных
   RefreshCategories()
   OnCategoryChange()
   RefreshProductList()
   
   ; --- ЦИКЛ СОБЫТИЙ ДЛЯ ДВУХ ОКОН ---
   Repeat
      Define Event.i = WaitWindowEvent()
      Define EventWindow.i = EventWindow()
      
      If Event = #PB_Event_Gadget
         Select EventGadget()
            Case #Combo_Category ; Действия в главном окне
               If EventType() = #PB_EventType_Change : OnCategoryChange() : EndIf
            Case #Btn_NewCategory
               OpenNewCategoryWindow()
            Case #Btn_DeleteCategory
               DeleteCategory()
            Case #Input_Search ; Если пользователь изменил текст в поле поиска — мгновенно обновляем список
               If EventType() = #PB_EventType_Change : RefreshProductList() : EndIf
            Case #Btn_ClearSearch
               ClearSearch()
            Case #Btn_QtyPlus
               ChangeProductQuantity(GetSafeStep())  
            Case #Btn_QtyMinus
               ChangeProductQuantity(-GetSafeStep()) 
            Case #Btn_Add
               AddProduct()
            Case #Btn_Delete
               DeleteProduct()
            Case #Btn_Info
               ShowProductInfo()
            Case #List_Products
               If EventType() = #PB_EventType_LeftDoubleClick : ShowProductInfo() : EndIf
            Case #Btn_SaveCategory ; Действия в окне категорий
               SaveNewCategory()
         EndSelect
      EndIf
      If Event = #PB_Event_CloseWindow
         If EventWindow = #Cat_Window
            CloseWindow(#Cat_Window)
            DisableWindow(#Main_Window, #False)
            SetActiveWindow(#Main_Window)
         Else
            Break ; Выход из программы
         EndIf
      EndIf
   ForEver
   If IsDatabase(DB) : CloseDatabase(DB) : EndIf
EndIf
End
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 665
; FirstLine = 648
; Folding = --------------
; EnableXP
; DPIAware