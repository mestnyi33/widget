; Подключаем движок по вашему абсолютному пути
XIncludeFile "/Users/as/Documents/GitHub/widget/widgets.pbi"

EnableExplicit
UseWidgets()

Structure TCursorItem
   ID.a
   Name.s
EndStructure

Global NewList Cursors.TCursorItem()

; МАКРОС: Передаем константу и готовую строку для обхода багов препроцессора
Macro AddCursor(ConstantName, StringName)
   AddElement(Cursors())
   Cursors()\ID = ConstantName
   Cursors()\Name = StringName
EndMacro

; Наполняем список всеми 27 комбинациями курсоров
AddCursor(Cursor::#__cursor_Default, "Default")
AddCursor(Cursor::#__cursor_Hand, "Hand")
AddCursor(Cursor::#__cursor_IBeam, "IBeam")
AddCursor(Cursor::#__cursor_Cross, "Cross")
AddCursor(Cursor::#__cursor_Busy, "Busy")
AddCursor(Cursor::#__cursor_Denied, "Denied")
;AddCursor(Cursor::#__cursor_Invisible, "Invisible")
AddCursor(Cursor::#__cursor_Arrows, "Arrows")
AddCursor(Cursor::#__cursor_UpDown, "UpDown")
AddCursor(Cursor::#__cursor_LeftRight, "LeftRight")
AddCursor(Cursor::#__cursor_Diagonal1, "Diagonal1")
AddCursor(Cursor::#__cursor_Diagonal2, "Diagonal2")
AddCursor(Cursor::#__cursor_SplitUp, "SplitUp")
AddCursor(Cursor::#__cursor_SplitDown, "SplitDown")
AddCursor(Cursor::#__cursor_SplitLeft, "SplitLeft")
AddCursor(Cursor::#__cursor_SplitRight, "SplitRight")
AddCursor(Cursor::#__cursor_SplitUpDown, "SplitUpDown")
AddCursor(Cursor::#__cursor_SplitLeftRight, "SplitLeftRight")
AddCursor(Cursor::#__cursor_LeftUp, "LeftUp")
AddCursor(Cursor::#__cursor_RightUp, "RightUp")
AddCursor(Cursor::#__cursor_LeftDown, "LeftDown")
AddCursor(Cursor::#__cursor_RightDown, "RightDown")
AddCursor(Cursor::#__cursor_Drag, "Drag")
AddCursor(Cursor::#__cursor_Drop, "Drop")
AddCursor(Cursor::#__cursor_Grab, "Grab")
AddCursor(Cursor::#__cursor_Grabbing, "Grabbing")
;AddCursor(Cursor::#__cursor_VIBeam, "VIBeam")

; НАША ОПТИМИЗИРОВАННАЯ ПРОЦЕДУРА (Использует встроенные макросы автора)
Procedure OnTableMouseMove()
   Protected WidgetID = EventWidget()
   
   ; Узнаем, над каким именно итемом (строкой) сейчас находится мышь.
   Protected HoveredItem = WidgetEventItem()
   ; Используем макросы автора для проверки реального состояния Drag-and-Drop!
   ; Проверяем, зажата ли ЛЕВАЯ кнопка мыши И идет ли процесс перетаскивания (Drag)
   If MouseDrag() And MouseButtons() = #PB_Canvas_LeftButton
      
      ; --- РЕЖИМ DRAG-AND-DROP ---
      ; Имитируем логику "Принять/Запретить": 
      ; Четные строки разрешают сброс (Drop), нечетные — запрещают (Denied)
      If HoveredItem % 2 = 0
         SetCursor(WidgetID, Cursor::#__cursor_Drop)
      Else
         SetCursor(WidgetID, Cursor::#__cursor_Denied)
      EndIf
      
   Else
      
      If GetState(WidgetID) <> HoveredItem
         If HoveredItem >= 0
            
            ; --- ОБЫЧНЫЙ РЕЖИМ ПРОСМОТРА ---
            ; Извлекаем стандартный ID курсора, сохраненный в итеме через SetItemData
            Protected ItemCursorID = GetItemData(WidgetID, HoveredItem)
            SetCursor(WidgetID, ItemCursorID)
            
         Else
            ; Если мышь ушла со строк — возвращаем дефолтный курсор
            SetCursor(WidgetID, Cursor::#__cursor_Default)
         EndIf
         
         ; Подсвечиваем строку, над которой зависла мышь
         SetState(WidgetID, HoveredItem)
      EndIf
   EndIf
EndProcedure

Procedure TestListIcon( X,Y,Width,Height, title.s, titleWidth, Flag=0 )
   ; ProcedureReturn ListIcon(x,y,width,height, title.s, titleWidth)
   
   ;\\
   Text(X,Y,Width,20,title, #__flag_Textinline) : SetColor( Widget( ), #PB_Gadget_BackColor, $FFC2C2C2)
   
   ProcedureReturn Tree(X,Y+20,Width,Height-20)
EndProcedure

; Создаем интерфейс витрины
If Open(0, 0, 0, 420, 630, "Динамический тест курсоров в ListIcon", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; Создаем один виджет-таблицу
   Global ListTable = TestListIcon(5, 5, 410, 620, "Обычный просмотр / Зажмите мышь для Drag:", 380, #PB_ListIcon_FullRowSelect)
   
   Define  RowIndex = 0
   ForEach Cursors()
      ; 1. Добавляем строку в ListIcon
      AddItem(ListTable, RowIndex, Str(RowIndex + 1) + ". " + Cursors()\Name)
      
      ; 2. Привязываем ID курсора НАПРЯМУЮ к этой строке
      SetItemData(ListTable, RowIndex, Cursors()\ID)
      
      RowIndex + 1
   Next
   
   ; Нам достаточно привязать ВСЕГО ОДНО событие перемещения мыши!
   Bind(ListTable, @OnTableMouseMove(), #__event_MouseEnter)
   Bind(ListTable, @OnTableMouseMove(), #__event_MouseLeave)
   Bind(ListTable, @OnTableMouseMove(), #__event_MouseMove)
   
   WaitClose()
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 109
; FirstLine = 101
; Folding = --
; EnableXP
; DPIAware