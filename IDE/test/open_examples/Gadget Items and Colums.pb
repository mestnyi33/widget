If OpenWindow(10, 100, 100, 300, 190, "Пример гаджета Список со значками", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListIconGadget(20, 5, 95, 290, 90, "Name", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  ButtonGadget(5, 5, 5, 75, 82,"кнопка 5")
  AddGadgetColumn(20, 1, "Address", 250)
  ListIconGadget(15, 90, 5, 120, 82,"ListIcon 15", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetItem(20, -1, "Harry Rannit"+Chr(10)+"12 Parliament Way, Battle Street, By the Bay")
  ButtonGadget(115, 220, 5, 75, 82,"кнопка 115")
  AddGadgetItem(20, -1, "Ginger Brokeit"+Chr(10)+"130 PureBasic Road, BigTown, CodeCity")
  
  Repeat
     Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
 EndIf

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 13
; EnableXP
; CompileSourceDirectory