; Включаем поддержку JSON в PureBasic
;UseJSON(0)

; Описываем структуру товара в стиле NoSQL (Документ)
Structure Product
  Name.s
  Price.f
  ; Map позволяет добавлять любые динамические свойства товару (Цвет, Вес, Производитель и т.д.)
  Map ExtraProperties.s() 
EndStructure

; Связный список документов в оперативной памяти
Global NewList NoSQL_Database.Product()

Global SaveFile$ = "products.json"

Enumeration Windows
  #Main_Window
EndEnumeration

Enumeration Gadgets
  #Txt_Name
  #Inp_Name
  #Txt_Price
  #Inp_Price
  #Txt_Color     ; Новое динамическое поле для примера
  #Inp_Color
  #Btn_Add
  #Btn_Delete
  #List_Products
EndEnumeration

; --- ФУНКЦИЯ СОХРАНЕНИЯ (NoSQL JSON) ---
Procedure SaveToJSON()
  ; Создаем пустой JSON-объект в памяти
  If CreateJSON(0)
    ; Магия PureBasic: переносим весь связный список структур в JSON одной командой
    InsertJSONList(JSONValue(0), NoSQL_Database())
    
    ; Сохраняем красиво отформатированный JSON на диск
    SaveJSON(0, SaveFile$, #PB_JSON_PrettyPrint)
    FreeJSON(0) ; Освобождаем память JSON-объекта
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; --- ФУНКЦИЯ ЧТЕНИЯ (NoSQL JSON) ---
Procedure LoadFromJSON()
  ClearList(NoSQL_Database())
  
  ; Если файл существует, загружаем его
  If FileSize(SaveFile$) > 0
    If LoadJSON(0, SaveFile$)
      ; Магия PureBasic: разворачиваем JSON-файл обратно в связный список структур
      ExtractJSONList(JSONValue(0), NoSQL_Database())
      FreeJSON(0)
    EndIf
  EndIf
EndProcedure

; --- ФУНКЦИЯ ОБНОВЛЕНИЯ ВИЗУАЛЬНОЙ ТАБЛИЦЫ ---
Procedure RefreshGrid()
  ClearGadgetItems(#List_Products)
  
  ForEach NoSQL_Database()
    ; Извлекаем динамическое свойство "Цвет", если оно есть у этого документа
    Protected Color$ = NoSQL_Database()\ExtraProperties("Цвет")
    If Color$ = "" : Color$ = "-" : EndIf
    
    ; Формируем строку таблицы
    RowData$ = NoSQL_Database()\Name + Chr(10) + 
               Color$ + Chr(10) + 
               StrF(NoSQL_Database()\Price, 2)
               
    AddGadgetItem(#List_Products, -1, RowData$)
  Next
EndProcedure


; --- ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ---
If OpenWindow(#Main_Window, 100, 100, 540, 420, "NoSQL (JSON) Управление товарами", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#Txt_Name, 20, 20, 100, 20, "Название товара:")
  StringGadget(#Inp_Name, 140, 17, 190, 24, "")
  
  TextGadget(#Txt_Color, 20, 55, 100, 20, "Цвет (Доп. свойство):")
  StringGadget(#Inp_Color, 140, 52, 190, 24, "")
  
  TextGadget(#Txt_Price, 20, 90, 100, 20, "Цена:")
  StringGadget(#Inp_Price, 140, 87, 190, 24, "")
  
  ButtonGadget(#Btn_Add, 350, 17, 160, 44, "Добавить документ")
  ButtonGadget(#Btn_Delete, 350, 67, 160, 44, "Удалить выбранный")
  
  ; Визуальная таблица
  ListIconGadget(#List_Products, 20, 130, 490, 270, "Название", 200, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#List_Products, 1, "Цвет (Динамич.)", 140)
  AddGadgetColumn(#List_Products, 2, "Цена", 120)

  ; Первичная загрузка базы данных из JSON
  LoadFromJSON()
  RefreshGrid()

  ; --- ОСНОВНОЙ ЦИКЛ СОБЫТИЙ ---
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case #Btn_Add ; --- ДОБАВЛЕНИЕ ---
            Name$  = GetGadgetText(#Inp_Name)
            Color$ = GetGadgetText(#Inp_Color)
            Price$ = GetGadgetText(#Inp_Price)
            
            If Name$ = "" Or Price$ = ""
              MessageRequester("Ошибка", "Заполните хотя бы Название и Цену!", #PB_MessageRequester_Error)
            Else
              ; Создаем новый NoSQL документ в списке
              AddElement(NoSQL_Database())
              NoSQL_Database()\Name  = Name$
              NoSQL_Database()\Price = ValF(Price$)
              
              ; Добавляем динамическое свойство в Map (его могло и не быть вовсе!)
              If Color$ <> ""
                NoSQL_Database()\ExtraProperties("Цвет") = Color$
              EndIf
              
              ; Сохраняем всю базу в JSON и обновляем экран
              SaveToJSON()
              RefreshGrid()
              
              ; Очищаем поля ввода
              SetGadgetText(#Inp_Name, "")
              SetGadgetText(#Inp_Color, "")
              SetGadgetText(#Inp_Price, "")
              SetActiveGadget(#Inp_Name)
            EndIf
            
          Case #Btn_Delete ; --- УДАЛЕНИЕ ---
            SelectedLine = GetGadgetState(#List_Products)
            
            If SelectedLine = -1
              MessageRequester("Инфо", "Выберите товар для удаления!", #PB_MessageRequester_Info)
            Else
              ; Переходим на нужный документ в списке памяти по индексу строки
              SelectElement(NoSQL_Database(), SelectedLine)
              DeleteElement(NoSQL_Database())
              
              ; Пересохраняем JSON и обновляем таблицу
              SaveToJSON()
              RefreshGrid()
            EndIf
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        End 
        
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 40
; FirstLine = 45
; Folding = ---
; EnableXP
; DPIAware