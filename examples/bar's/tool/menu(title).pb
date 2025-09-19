XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   If Open(0, 200, 200, 300, 150, " Пример ёак изменить текст зоголовка ")
      ButtonGadget(0, 25, 60, 250, 45, "Изменить текст заголовка Проект2")
      
      Define g = CreateMenu(#PB_Any, WindowID(0))
      If g 
         MenuTitle("Проект1")
         MenuItem(1, "Открыть")
         MenuItem(2, "Закрыть")
         MenuTitle("Проект2")
         MenuItem(1, "Открыть")
         MenuItem(3, "Закрыть")
      EndIf
      
      Define *g = CreateBar(root( ))
      If *g
         BarTitle("Проект1")
         BarItem(1, "Открыть")
         BarItem(2, "Закрыть")
         BarTitle("Проект2")
         BarItem(1, "Открыть")
         BarItem(3, "Закрыть")
      EndIf
      
      Define Event
      Repeat
         Event = WaitWindowEvent()
         If Event = #PB_Event_Gadget
            Select EventGadget()
               Case 0
                  SetMenuTitleText(g, 1, "Файл") 
                  SetMenuItemText(g, 1, "change")
                  SetMenuItemText(g, 3, "change")
                  
                  SetBarTitleText(*g, 1, "Файл") 
                  SetBarItemText(*g, 1, "change") 
                  SetBarItemText(*g, 3, "change")
                  
                  ReDraw( GetRoot(*g) )
            EndSelect
         EndIf
      Until Event = #PB_Event_CloseWindow
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 6
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware