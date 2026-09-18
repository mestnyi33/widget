; --- ОКНО ПРИЛОЖЕНИЯ ---
XIncludeFile "tokken.pbi"

If Open(0, 100, 100, 640, 480, "PureBasic 2D Grid with Header", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Define *this._s_WIDGET = ListIcon(0, 0, 640, 480, "ID товара", 120)
   ;*this\CanvasID = 0
   
   ; 1. Заполняем ШАПКУ таблицы (тот самый верхний фиксированный ряд)
   ;AddColumn(*this, -1, "ID товара", 120)
   AddColumn(*this, -1, "Наименование", 120)
   AddColumn(*this, -1, "Категория", 120)
   AddColumn(*this, -1, "Цена", 120)
   AddColumn(*this, -1, "Остаток", 120)
   
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
      AddItem(*this, -1, rowText$)
   Next
   
   
   ;    Define a, LN=5000000, time = ElapsedMilliseconds() ; 25373 - add widget items time count - 
   ;     For a = 0 To LN
   ;        AddItem (*this, -1, "Item "+Str(a), 0,0) 
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
   
   ;DrawGrid(*this)
   ReDraw()
   
   SetItemText(*this, 1, 3, "12345")
   Debug GetItemText(*this, 1, 3)
   RemoveItem(*this, 1)
   RemoveColumn(*this, 3)
   MoveColumn(*this, 1, 3)
   MoveItem(*this, 1, 3)
   
   Repeat
   Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 51
; FirstLine = 36
; Folding = -
; EnableXP
; DPIAware