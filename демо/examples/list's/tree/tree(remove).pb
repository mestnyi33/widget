
; widget add / remove visual test
; gadget add / remove visual test

XIncludeFile "../../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets()
  
  ; Уменьшим количество для наглядности (чтобы не ждать слишком долго анимацию)
  #ItemsCount = 200 
  
  Global g, *w._S_widget
  Global time, t_w_add, t_g_add, t_w_rem, t_g_rem
  Global w_count, g_count
  Global a
  
  Procedure TreeGadget_(gadget, X,Y,Width,Height,Flag=0)
    Protected g_id = PB(TreeGadget)(gadget, X,Y,Width,Height,Flag)
    If gadget = -1 : gadget = g_id : EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define RowHeight.CGFloat = 19
      CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    CompilerEndIf
    
    ProcedureReturn gadget
  EndProcedure
  
  Procedure ProcessEvents(DelayTime = 5)
    ; Функция обрабатывает очередь событий ОС, чтобы окно перерисовывалось «на лету»
    ; While WindowEvent() : Wend : Delay(DelayTime) ; Небольшая пауза для визуального эффекта замедления
  EndProcedure
  
  If OpenWindow(0, 100, 50, 650, 700, "Тест: Ожидание запуска...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    g = TreeGadget_(-1, 10, 10, 310, 680)
    Open(0, 330, 10, 310, 680)
    *w = Tree(0, 0, 310, 680)
    
    SetWindowTitle(0, "ЭТАП 1: Идет добавление элементов...")
    ProcessEvents(500) ; Пауза перед стартом
    
    ; ==========================================================
    ; 1. НАГЛЯДНОЕ ДОБАВЛЕНИЕ ЭЛЕМЕНТОВ
    ; ==========================================================
    
    time = ElapsedMilliseconds()
    For a = 0 To #ItemsCount Step 5 
       AddItem(*w, a, "Item_"+Str(a), -1) 
       AddItem(*w, a+1, "Item_"+Str(a+1), -1, 1) 
       AddItem(*w, a+2, "Item_"+Str(a+2), -1, 2) 
       AddItem(*w, a+3, "Item_"+Str(a+3), -1, 3) 
       AddItem(*w, a+4, "Item_"+Str(a+4), -1, 4) 
       
       ; Принудительно обновляем виджет на экране
       ProcessEvents(2) 
    Next
    t_w_add = ElapsedMilliseconds() - time
    w_count = CountItems(*w)
    
    time = ElapsedMilliseconds()
    For a = 0 To #ItemsCount Step 5 
       AddGadgetItem(g, a, "Item_"+Str(a), 0) 
       AddGadgetItem(g, a+1, "Item_"+Str(a+1), 0, 1) 
       AddGadgetItem(g, a+2, "Item_"+Str(a+2), 0, 2) 
       AddGadgetItem(g, a+3, "Item_"+Str(a+3), 0, 3) 
       AddGadgetItem(g, a+4, "Item_"+Str(a+4), 0, 4) 
       
       ; Принудительно обновляем стандартный гаджет на экране
       ProcessEvents(2) 
    Next
    
    ; Разворачиваем дерево гаджета
    For a = 0 To CountGadgetItems(g) 
      SetGadgetItemState(g, a, #PB_Tree_Expanded) 
    Next
    t_g_add = ElapsedMilliseconds() - time
    g_count = CountGadgetItems(g)
    
    SetGadgetState(g, 2)
    SetState(*w, 2)
    
    ; ==========================================================
    ; ПАУЗА МЕЖДУ СТДИЯМИ
    ; ==========================================================
    SetWindowTitle(0, "ДОБАВЛЕНО! Ожидание 2 секунды перед удалением...")
    ProcessEvents(2000) ; Замрем на 2 секунды, чтобы увидеть заполненные деревья
    
    ; ==========================================================
    ; 2. НАГЛЯДНОЕ УДАЛЕНИЕ ЭЛЕМЕНТОВ
    ; ==========================================================
    SetWindowTitle(0, "ЭТАП 2: Идет поштучное удаление...")
    
    time = ElapsedMilliseconds()
    For a = 0 To w_count 
      RemoveItem(*w, a) 
      ProcessEvents(5) ; Показываем процесс удаления из виджета
    Next 
    t_w_rem = ElapsedMilliseconds() - time
    
    time = ElapsedMilliseconds()
    For a = 0 To g_count 
      RemoveGadgetItem(g, a) 
      ProcessEvents(5) ; Показываем процесс удаления из гаджета
    Next 
    t_g_rem = ElapsedMilliseconds() - time
    
    ; ==========================================================
    ; ИТОГОВЫЙ РЕЗУЛЬТАТ
    ; ==========================================================
    Define title.s = "ГОТОВО! Добавление: W=" + Str(t_w_add) + "мс, G=" + Str(t_g_add) + "мс | " +
                        "Удаление: W=" + Str(t_w_rem) + "мс, G=" + Str(t_g_rem) + "мс"
    SetWindowTitle(0, title)
    
    Define title.s = "ДОБАВЛЕНИЕ:" + #LF$ +"   " + Str(t_w_add) + "мс - [W]" + #LF$ +"   " + Str(t_g_add) + "мс - [G]" + #LF$ +
                        "УДАЛЕНИЕ:" + #LF$ +"   " + Str(t_w_rem) + "мс - [W]" + #LF$ +"   " + Str(t_g_rem) + "мс - [G]"
    Debug "[РЕЗУЛЬТАТ] " +  #LF$ + title
    WaitClose()
  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 121
; FirstLine = 97
; Folding = --
; EnableXP