OpenWindow(0, 200, 100, 430, 145, "ListIcon Example")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 50, "Name", 110, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
AddGadgetColumn(0, 1, "Возраст", 100)

; Сначала добавим данные
AddGadgetItem(0, -1, "Иван" + Chr(10) + "25")
AddGadgetItem(0, -1, "Мария" + Chr(10) + "22")

; А ТЕПЕРЬ добавим колонку в уже заполненную таблицу!
; Благодаря тому блоку кода в AddColumn, она не будет пустой.
AddGadgetColumn(0, 2, "Город", 150)

; AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
; AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
; AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
; AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")
ButtonGadget(1, WindowWidth(0) / 2 - 70, WindowHeight(0) - 30, 140, 25, "Hide title header")

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 1 And EventType() = #PB_EventType_LeftClick
        ;CocoaMessage(0, GadgetID(0), "setHeaderView:", 0)
        DisableGadget(1, #True)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP