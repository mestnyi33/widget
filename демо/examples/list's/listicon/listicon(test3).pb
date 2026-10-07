
  
;XIncludeFile "../../../../widgets.pbi"
XIncludeFile "../../../../widgets_tokken.pbi"
;XIncludeFile "../../../../include/tokken.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global Steps = 0

   Define i
   Open(0, 0,0, 530,460, "Demo ListIcon") 
   Define g = ListIconGadget(#PB_Any,10,10,508,200, "Элементы дерева (Узел)", 250, #PB_ListIcon_CheckBoxes|#PB_ListIcon_AlwaysShowSelection);|#PB_ListIcon_HeaderDragDrop)           
  ;  Добавляем колонки (Первая колонка держит Дерево, остальные — свойства ListIcon)
  AddGadgetColumn(g, 2, "Размер файла", 120)
  AddGadgetColumn(g, 3, "Тип данных", 120)
  AddGadgetColumn(g, 4, "Описание", 120)
  
  ;  Заполнение структуры (Текст колонок через Chr(10), затем Level, затем флаг HasChildren)
  AddGadgetItem(g, -1, "Мой компьютер" + Chr(10) + "" + Chr(10) + "Система" + Chr(10) + "Корневой узел", 0, 0);, #True)
    AddGadgetItem(g, -1, "Диск C:" + Chr(10) + "119 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Системный диск", 0, 1);, #True)
      AddGadgetItem(g, -1, "PureBasic" + Chr(10) + "45 МБ" + Chr(10) + "Папка" + Chr(10) + "Среда разработки", 0, 2);, #True)
        AddGadgetItem(g, -1, "PureBasic.exe" + Chr(10) + "4.2 МБ" + Chr(10) + "Программа" + Chr(10) + "Исполняемый файл", 0, 3);, #False)
        AddGadgetItem(g, -1, "History.txt" + Chr(10) + "12 КБ" + Chr(10) + "Документ" + Chr(10) + "Лог изменений", 0, 3);, #False)
      AddGadgetItem(g, -1, "Windows" + Chr(10) + "24 ГБ" + Chr(10) + "Папка" + Chr(10) + "ОС", 0, 2);, #False)
    AddGadgetItem(g, -1, "Диск D:" + Chr(10) + "931 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Данные", 0, 1);, #True)
      AddGadgetItem(g, -1, "Фильмы" + Chr(10) + "450 ГБ" + Chr(10) + "Папка" + Chr(10) + "Медиа",0,  2);, #False)
      AddGadgetItem(g, -1, "Проекты PB" + Chr(10) + "2 МБ" + Chr(10) + "Папка" + Chr(10) + "Исходный код",0,  2);, #False)
  AddGadgetItem(g, -1, "Сетевое окружение" + Chr(10) + "" + Chr(10) + "Сеть" + Chr(10) + "Устройства в сети",0,  0);, #False)
  
  
   
   Debug "------------------------------------"
   Define *g._s_WIDGET = ListIcon(10-3,220-3,508+6,200+6+20, "Элементы дерева (Узел)", 250,#__Flag_CheckBoxes|#__Flag_ThreeState);|#__Flag_SizeGadget) 
    ;  Добавляем колонки (Первая колонка держит Дерево, остальные — свойства ListIcon)
  AddColumn(*g, -1, "Размер файла", 120)
  AddColumn(*g, -1, "Тип данных", 120)
  AddColumn(*g, -1, "Описание", 120)
 
   ;  Заполнение структуры (Текст колонок через Chr(10), затем Level, затем флаг HasChildren)
  AddItem(*g, -1, "Мой компьютер" + Chr(10) + "" + Chr(10) + "Система" + Chr(10) + "Корневой узел", -1, 0);, #True)
    AddItem(*g, -1, "Диск C:" + Chr(10) + "119 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Системный диск", -1, 1);, #True)
      AddItem(*g, -1, "PureBasic" + Chr(10) + "45 МБ" + Chr(10) + "Папка" + Chr(10) + "Среда разработки",-1,  2);, #True)
        AddItem(*g, -1, "PureBasic.exe" + Chr(10) + "4.2 МБ" + Chr(10) + "Программа" + Chr(10) + "Исполняемый файл",-1,  3);, #False)
        AddItem(*g, -1, "History.txt" + Chr(10) + "12 КБ" + Chr(10) + "Документ" + Chr(10) + "Лог изменений", -1, 3);, #False)
      AddItem(*g, -1, "Windows" + Chr(10) + "24 ГБ" + Chr(10) + "Папка" + Chr(10) + "ОС",-1,  2);, #False)
    AddItem(*g, -1, "Диск D:" + Chr(10) + "931 ГБ" + Chr(10) + "Раздел NTFS" + Chr(10) + "Данные", -1, 1);, #True)
      AddItem(*g, -1, "Фильмы" + Chr(10) + "450 ГБ" + Chr(10) + "Папка" + Chr(10) + "Медиа", -1, 2);, #False)
      AddItem(*g, -1, "Проекты PB" + Chr(10) + "2 МБ" + Chr(10) + "Папка" + Chr(10) + "Исходный код", -1, 2);, #False)
  AddItem(*g, -1, "Сетевое окружение" + Chr(10) + "" + Chr(10) + "Сеть" + Chr(10) + "Устройства в сети", -1, 0);, #False)
  
  

   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 2
; Folding = -
; EnableXP
; DPIAware