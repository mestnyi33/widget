﻿; Показывает использование нескольких Панелей...
If OpenWindow(10, 0, 0, 422, 220, "Гаджет Панель", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   PanelGadget     (50, 8, 8, 356, 203)
      ;AddGadgetItem (50, -1, "Панель 1")
      AddGadgetItem (50, -1, "Панель 2")
         PanelGadget (51, 5, 30, 340, 166)
            AddGadgetItem(51, -1, "Под-Панель 1")
            PanelGadget (151, 5, 30, 340, 166)
               AddGadgetItem(151, -1, "Под-Под-Панель 1")
          
               AddGadgetItem(151, -1, "Под-Под-Панель 2")
               ButtonGadget(115, 5, 5, 155, 22,"Под-Под-Панель 2")
          
               AddGadgetItem(151, -1, "Под-Под-Панель 3")
            CloseGadgetList()
        
            AddGadgetItem(51, -1, "Под-Панель 2")
            ButtonGadget(15, 5, 25, 155, 22,"Под-Панель 2")
         
            AddGadgetItem(51, -1, "Под-Панель 3")
         CloseGadgetList()
         
      ButtonGadget(5, 5, 5, 155, 22,"Панель 2 1")
        
      AddGadgetItem (50, -1,"Панель 3")
      ButtonGadget(2, 10, 15, 80, 24,"Панель 3 1")
      ButtonGadget(3, 95, 15, 80, 24,"Панель 3 2")
   CloseGadgetList()
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; Folding = -
; EnableXP
; CompileSourceDirectory