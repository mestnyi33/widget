; Показывает использование нескольких Панелей...
If OpenWindow(10, 0, 0, 422, 220, "Гаджет Панель", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   PanelGadget(50, 8, 8, 356, 203)
   AddGadgetItem(50, -1, "Панель 1")
      PanelGadget(51, 5, 30, 340, 166)
      AddGadgetItem(51, -1, "Под-Панель 1")
         PanelGadget(151, 5, 30, 340, 166)
         AddGadgetItem(151, -1, "Под-Под-Панель 1")
          
               
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DPIAware