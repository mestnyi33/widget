; Включаем поддержку JSON в PureBasic
;UseJSON(0)

; Описываем гибкую структуру товара
Structure Product
  Name.s
  Price.f
  ; Хранилище Ключ-Значение для абсолютно любых динамических свойств
  Map ExtraProperties.s() 
EndStructure

; Наша NoSQL база данных в памяти
Global NewList NoSQL_Database.Product()
Global SaveFile$ = "products_dynamic.json"

Enumeration Windows
  #Main_Window
EndEnumeration

Enumeration Gadgets
  #Txt_Name
  #Inp_Name
  #Txt_Price
  #Inp_Price
  
  #Txt_PropKey   ; Поле для имени свойства (например: Вес, Размер, Бренд)
  #Inp_PropKey
  #Txt_PropVal   ; Поле для значения свойства (например: 5кг, XL, Sony)
  #Inp_PropVal
  
  #Btn_Add
  #Btn_Delete
  #List_Products
EndEnumeration

; --- ФУНКЦИИ ХРАНЕНИЯ (JSON) ---
Procedure SaveToJSON()
  If CreateJSON(0)
    InsertJSONList(JSONValue(0), NoSQL_Database())
    SaveJSON(0, SaveFile$, #PB_JSON_PrettyPrint)
    FreeJSON(0)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure LoadFromJSON()
  ClearList(NoSQL_Database())
  If FileSize(SaveFile$) > 0
    If LoadJSON(0, SaveFile$)
      ExtractJSONList(JSONValue(0), NoSQL_Database())
      FreeJSON(0)
    EndIf
  EndIf
EndProcedure

; --- ОБНОВЛЕНИЕ ТАБЛИЦЫ ---
Procedure RefreshGrid()
  ClearGadgetItems(#List_Products)
  
  ForEach NoSQL_Database()
    ; Собираем все динамические свойства товара в одну красивую строку
    Protected AllProps$ = ""
    
    ForEach NoSQL_Database()\ExtraProperties()
      ; MapKey() возвращает имя свойства (например, "Вес"), а текущий элемент — его значение
      AllProps$ + MapKey(NoSQL_Database()\ExtraProperties()) + ": " + NoSQL_Database()\ExtraProperties() + " | "
    Next
    
    ; Убираем лишний разделитель " | " на конце строки, если свойства были найдены
    If AllProps$ <> ""
      AllProps$ = Left(AllProps$, Len(AllProps$) - 3)
    Else
      AllProps$ = "(нет свойств)"
    EndIf
    
    ; Формируем строку таблицы (Название, Динамические свойства, Цена)
    RowData$ = NoSQL_Database()\Name + Chr(10) + 
               AllProps$ + Chr(10) + 
               StrF(NoSQL_Database()\Price, 2)
               
    AddGadgetItem(#List_Products, -1, RowData$)
  Next
EndProcedure


; --- ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ---
If OpenWindow(#Main_Window, 100, 100, 560, 430, "Динамический NoSQL на PureBasic", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ; Основные поля
  TextGadget(#Txt_Name, 20, 20, 110, 20, "Название товара:")
  StringGadget(#Inp_Name, 140, 17, 190, 24, "")
  
  TextGadget(#Txt_Price, 20, 55, 110, 20, "Цена товара:")
  StringGadget(#Inp_Price, 140, 52, 190, 24, "")
  
  ; Универсальные динамические поля (Ключ -> Значение)
  TextGadget(#Txt_PropKey, 20, 90, 110, 20, "Доп. свойство:")
  StringGadget(#Inp_PropKey, 140, 87, 85, 24, "", #PB_String_NoCase) ; Поле для Ключа (например: Цвет)
  SetGadgetAttribute(#Inp_PropKey, #PB_String_MaximumLength, 15)
  
  TextGadget(#Txt_PropVal, 235, 90, 15, 20, "=")
  StringGadget(#Inp_PropVal, 250, 87, 80, 24, "")                    ; Поле для Значения (например: Синий)
  
  ; Кнопки управления
  ButtonGadget(#Btn_Add, 350, 17, 180, 44, "Добавить документ")
  ButtonGadget(#Btn_Delete, 350, 67, 180, 44, "Удалить выбранный")
  
  ; Таблица отображения
  ListIconGadget(#List_Products, 20, 130, 510, 280, "Название", 160, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#List_Products, 1, "Характеристики (Динамические)", 230)
  AddGadgetColumn(#List_Products, 2, "Цена", 100)

  ; Стартовая загрузка
  LoadFromJSON()
  RefreshGrid()

  ; --- ОСНОВНОЙ ЦИКЛ СОБЫТИЙ ---
  Repeat
    Select WaitWindowEvent()
        
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case #Btn_Add ; --- ДОБАВЛЕНИЕ ---
            Name$  = GetGadgetText(#Inp_Name)
            Price$ = GetGadgetText(#Inp_Price)
            Key$   = Trim(GetGadgetText(#Inp_PropKey))
            ;Val$   = Trim(GetGadgetText(#Inp_Value)) ; Внимание: проверим имя гаджета
            Val$   = Trim(GetGadgetText(#Inp_PropVal))
            
            If Name$ = "" Or Price$ = ""
              MessageRequester("Ошибка", "Заполните Название и Цену!", #PB_MessageRequester_Error)
            Else
              ; Создаем новый NoSQL-документ
              AddElement(NoSQL_Database())
              NoSQL_Database()\Name  = Name$
              NoSQL_Database()\Price = ValF(Price$)
              
              ; Если пользователь заполнил динамическое свойство, добавляем его в Map
              If Key$ <> "" And Val$ <> ""
                NoSQL_Database()\ExtraProperties(Key$) = Val$
              EndIf
              
              SaveToJSON()
              RefreshGrid()
              
              ; Очищаем все поля ввода
              SetGadgetText(#Inp_Name, "")
              SetGadgetText(#Inp_Price, "")
              SetGadgetText(#Inp_PropKey, "")
              SetGadgetText(#Inp_PropVal, "")
              SetActiveGadget(#Inp_Name)
            EndIf
            
          Case #Btn_Delete ; --- УДАЛЕНИЕ ---
            SelectedLine = GetGadgetState(#List_Products)
            
            If SelectedLine = -1
              MessageRequester("Инфо", "Выберите строку для удаления!", #PB_MessageRequester_Info)
            Else
              SelectElement(NoSQL_Database(), SelectedLine)
              DeleteElement(NoSQL_Database())
              
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
; CursorPosition = 128
; FirstLine = 114
; Folding = ---
; EnableXP
; DPIAware