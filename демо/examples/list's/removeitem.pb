; macos / windows - Наглядный тест с учетом каскадного удаления
XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets()
  
  #ItemsCount = 150 ; Небольшое число для красивой визуализации процесса
  Global g, *w._S_widget
  Global a, w_count, g_count
  Global btnStart, isTesting = #False
  
  Procedure TreeGadget_(gadget, X,Y,Width,Height,Flag=0)
    Protected g_id = PB(TreeGadget)(gadget, X,Y,Width,Height,Flag)
    If gadget = -1 : gadget = g_id : EndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define RowHeight.CGFloat = 19
      CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    CompilerEndIf
    ProcedureReturn gadget
  EndProcedure

  ; Создаем окно с кнопкой для пошагового контроля
  If OpenWindow(0, 100, 50, 530, 740, "Тест каскадного удаления", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    g = TreeGadget_(-1, 10, 10, 250, 640)
    Open(0, 270, 10, 250, 640)
    *w = Tree(0, 0, 250, 640)
    
    ; Кнопка запуска, чтобы пользователь успел подготовиться к просмотру
    btnStart = ButtonGadget(-1, 10, 660, 510, 40, "Запустить визуальный тест добавления и удаления")
    
    ; Заполнение (сразу при старте или по клику)
    For a = 0 To #ItemsCount Step 5 
       AddItem(*w, a, "Item_"+Str(a), -1) 
       AddItem(*w, a+1, "Item_"+Str(a+1), -1, 1) 
       AddItem(*w, a+2, "Item_"+Str(a+2), -1, 2) 
       AddItem(*w, a+3, "Item_"+Str(a+3), -1, 3) 
       AddItem(*w, a+4, "Item_"+Str(a+4), -1, 4) 
       
       AddGadgetItem(g, a, "Item_"+Str(a), 0) 
       AddGadgetItem(g, a+1, "Item_"+Str(a+1), 0, 1) 
       AddGadgetItem(g, a+2, "Item_"+Str(a+2), 0, 2) 
       AddGadgetItem(g, a+3, "Item_"+Str(a+3), 0, 3) 
       AddGadgetItem(g, a+4, "Item_"+Str(a+4), 0, 4) 
    Next
    
    For a = 0 To CountGadgetItems(g) : SetGadgetItemState(g, a, #PB_Tree_Expanded) : Next
    w_count = CountItems(*w)
    g_count = CountGadgetItems(g)
    
    SetGadgetState(g, 0)
    SetState(*w, 0)
    
    Define event, widget_idx = 0, gadget_idx = 0
    
    Repeat
      event = WaitWindowEvent()
      
      ; Логика работы по таймеру (пошаговое удаление)
      If event = #PB_Event_Timer
        If EventTimer() = 1
          
          ; Удаляем по одному шагу в виджете
          If widget_idx <= w_count
            RemoveItem(*w, widget_idx)
            widget_idx + 1 ; Индекс растет, как в вашем цикле For
          EndIf
          
          ; Удаляем по одному шагу в гаджете ОС
          If gadget_idx <= g_count
            RemoveGadgetItem(g, gadget_idx)
            gadget_idx + 1 ; Индекс растет, как в вашем цикле For
          EndIf
          
          ; Обновляем заголовок текущим остатком элементов
          SetWindowTitle(0, "Осталось элементов: Виджет = " + Str(CountItems(*w)) + " | Гаджет = " + Str(CountGadgetItems(g)))
          
          ; Если всё удалили — останавливаем таймер
          If CountItems(*w) = 0 And CountGadgetItems(g) = 0
            RemoveWindowTimer(0, 1)
            SetWindowTitle(0, "Тест завершен! Оба дерева пустые.")
            DisableGadget(btnStart, #False)
          EndIf
        EndIf
      EndIf
      
      If event = #PB_Event_Gadget And EventGadget() = btnStart
        DisableGadget(btnStart, #True)
        widget_idx = 0
        gadget_idx = 0
        ; Запускаем таймер: шаг удаления каждые 50 миллисекунд для плавной анимации
        AddWindowTimer(0, 1, 50) 
      EndIf
      
    Until event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 65
; FirstLine = 60
; Folding = --
; EnableXP
; DPIAware