XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Open(0, 0, 0, 400, 150, "ListIcon - Add Columns", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Define._s_WIDGET *g = ListIcon(10, 10, 380, 100, "Standard Column", 150, #PB_ListIcon_GridLines)
   ButtonGadget(1, 10, 120, 150, 20, "Add new column")
   
   AddColumn(*g, -1, "Возраст", 100)
   
   ; Сначала добавим данные
   AddItem(*g, -1, "Иван" + Chr(10) + "25")
   AddItem(*g, -1, "Мария" + Chr(10) + "22")
   
   ; А ТЕПЕРЬ добавим колонку в уже заполненную таблицу!
   ; Благодаря тому блоку кода в AddColumn, она не будет пустой.
   AddColumn(*g, -1, "Город", 150)

   Define event, Index = 1     ; "Standard column" has already index 0
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventGadget() = 1
            Debug Index
            AddColumn(*g, Index, "Column " + Str(Index), 80)
            
           ; AddItem(*g, Index - 1, "Row" + Str(Index))
;             
;             SetItemText(*g, Index - 1, Str(Index), Index)
;             
            Index + 1
            Repaint( )
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware