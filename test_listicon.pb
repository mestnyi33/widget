;XIncludeFile "listicon3_2.pb"
XIncludeFile "include/tokken.pbi"

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Define *g._s_WIDGET = ListIcon(0, 0, 640, 480, "ID товара", 120)
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   AddColumn(*g, -1, "Наименование", 120, -1)
   AddColumn(*g, -1, "Категория", 120, -1, #__align_Center)
   AddColumn(*g, -1, "Цена", 120, -1, #__align_Right)
   AddColumn(*g, -1, "Остаток", 120, -1, #__align_Right)
   
   ; 2. Заполняем обычные строки с данными (вниз)
   Define r.l
   For r = 1 To 20
      ; Формируем единую строку, разделенную #LF$
      Define rowText$ = "#" + Str(1000 + r) + #LF$ +
                        "Товар " + Str(r) + #LF$ +
      "Электроника" + #LF$ +
      Str(r * 150) + " руб" + #LF$ +
      Str(Random(50, 5)) + " шт"
      
      ; Вызываем вашу новую функцию (добавляем всегда в конец: параметр -1)
      AddItem(*g, -1, rowText$)
   Next
   
   
   ;    Define a, LN=5000000, time = ElapsedMilliseconds() ; 25373 - add widget items time count - 
   ;     For a = 0 To LN
   ;        AddItem (*g, -1, "Item "+Str(a), 0,0) 
   ;        
   ;       If A & $f=$f
   ;         WindowEvent() ; ýòî íóæíî ÷òîáû íåìíîãî îáíîâëÿëñÿ
   ;       EndIf
   ;       If A & $8ff=$8ff
   ;         WindowEvent() ; ýòî ïîçâîëÿåò ïîêàçûâàòü ñêîêî öèêëîâ ïðîéøëî
   ;         Debug a
   ;       EndIf
   ;     Next
   ;     Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " ;+ CountItems(*w)
   
   ReDraw(*g)
   
   SetItemText(*g, 1, 3, "---- руб")
   Debug GetItemText(*g, 1, 3)
   ;    RemoveItem(*g, 1)
   ;    RemoveColumn(*g, 3)
   MoveColumn(*g, 1, 3)
   ;    MoveItem(*g, 1, 3)
   ; ResizeColumn(*g, 2, 240)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; Folding = -
; EnableXP
; DPIAware