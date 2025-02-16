Enumeration FormWindow
  #Window_1
  #Window_2
EndEnumeration

Enumeration FormGadget
  #Gadget_1_1
  #Gadget_1_2
  #Gadget_2_1
  #Gadget_2_2
EndEnumeration

Global Window_3, Window_4
Global Gadget_3_1, Gadget_3_2
Global Gadget_4_1, Gadget_4_2

OpenWindow(#Window_1, 0, 0, 200, 200, "Первое окно")
TextGadget(#Gadget_1_1, 0, 0, 200, 30, "Текст в первом окне")
StringGadget(#Gadget_1_2, 0, 34, 200, 30, "Строка в первом окне")

OpenWindow(#Window_2, 200, 0, 200, 200, "Второе окно")
TextGadget(#Gadget_2_1, 0, 0, 200, 30, "Текст во втором окне")
StringGadget(#Gadget_2_2, 0, 34, 200, 30, "Строка во втором окне")

Window_3=OpenWindow(#PB_Any, 400, 0, 200, 200, "Третье окно")
Gadget_3_1=TextGadget(#PB_Any, 0, 0, 200, 30, "Текст в третьем окне")
Gadget_3_2=StringGadget(#PB_Any, 0, 34, 200, 30, "Строка в третьем окне")

Window_4=OpenWindow(#PB_Any, 0, 200, 600, 200, "Четвёртое окно")
Gadget_4_1=TextGadget(#PB_Any, 0, 0, 600, 30, "Текст в четвёртом окне", #PB_Text_Center)
Gadget_4_2=StringGadget(#PB_Any, 0, 34, 600, 30, "Строка в четвёртом окне", #PB_String_UpperCase)


Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 12
; EnableXP
; CompileSourceDirectory