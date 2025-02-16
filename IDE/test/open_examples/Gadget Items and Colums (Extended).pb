Enumeration FormWindow
  #Window
EndEnumeration

Enumeration FormGadget
  #Gadget_Sort
  #Gadget_SortLeft
  #Gadget_SortRight
  #Gadget_Asort
  #Gadget_AsortLeft
  #Gadget_AsortRight
EndEnumeration

Procedure OpenWindow_ItemsAndColums(x = 0, y = 0, width = 510, height = 435)
  OpenWindow(#Window, x, y, width, height, "Тест элементов и колонок", #PB_Window_SystemMenu)
  TextGadget(#Gadget_Sort, 5, 5, 500, 20, "Тест упорядоченных элементов")
  ListIconGadget(#Gadget_SortLeft, 5, 25, 250, 180, "#", 20)
  AddGadgetColumn(#Gadget_SortLeft, 1, "Слева1", 51)
  AddGadgetColumn(#Gadget_SortLeft, 2, "Слева2", 52)
  AddGadgetColumn(#Gadget_SortLeft, 3, "Слева3", 53)
  AddGadgetItem(#Gadget_SortLeft, -1, Str(1)+Chr(10)+"Слева1")
  AddGadgetItem(#Gadget_SortLeft, -1, Str(2)+Chr(10)+"Слева2")
  AddGadgetItem(#Gadget_SortLeft, -1, Str(3)+Chr(10)+"Слева3")
  ListIconGadget(#Gadget_SortRight, 255, 25, 250, 180, "#", 20)
  AddGadgetColumn(#Gadget_SortRight, 1, "Справа1", 61)
  AddGadgetColumn(#Gadget_SortRight, 2, "Справа2", 52)
  AddGadgetColumn(#Gadget_SortRight, 3, "Справа3", 53)
  AddGadgetItem(#Gadget_SortRight, -1, Str(1)+Chr(10)+"Справа1")
  AddGadgetItem(#Gadget_SortRight, -1, Str(2)+Chr(10)+"Справа2")
  AddGadgetItem(#Gadget_SortRight, -1, Str(3)+Chr(10)+"Справа3")
  
  TextGadget(#Gadget_Asort, 5, 225, 500, 20, "Тест элементов в перемешку")
  ListIconGadget(#Gadget_AsortLeft, 5, 250, 250, 180, "#", 20)
  ListIconGadget(#Gadget_AsortRight, 255, 250, 250, 180, "#", 20)
  AddGadgetColumn(#Gadget_AsortLeft, 1, "Слева1", 51)
  AddGadgetColumn(#Gadget_AsortLeft, 2, "Слева2", 52)
  AddGadgetColumn(#Gadget_AsortLeft, 3, "Слева3", 53)
  AddGadgetItem(#Gadget_AsortLeft, -1, Str(1)+Chr(10)+"Слева1")
  AddGadgetItem(#Gadget_AsortLeft, -1, Str(2)+Chr(10)+"Слева2")
  AddGadgetItem(#Gadget_AsortLeft, -1, Str(3)+Chr(10)+"Слева3")
  AddGadgetColumn(#Gadget_AsortRight, 1, "Справа1", 61)
  AddGadgetColumn(#Gadget_AsortRight, 2, "Справа2", 52)
  AddGadgetColumn(#Gadget_AsortRight, 3, "Справа3", 53)
  AddGadgetItem(#Gadget_AsortRight, -1, Str(1)+Chr(10)+"Справа1")
  AddGadgetItem(#Gadget_AsortRight, -1, Str(2)+Chr(10)+"Справа2")
  AddGadgetItem(#Gadget_AsortRight, -1, Str(3)+Chr(10)+"Справа3")
EndProcedure


OpenWindow_ItemsAndColums()
Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow


; IDE Options = PureBasic 5.60 (Windows - x86)
; Folding = -
; EnableXP
; CompileSourceDirectory