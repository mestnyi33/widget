Enumeration FormWindow
  #Window_0
EndEnumeration
 
Enumeration FormGadget
  #Text_0
  #Text_1
  #Frame_0
  #Text_Bits
  #Frame_1
  #Text_Kerio
  #Btn_v32
  #Btn_v64
  #Frame_2
  #Text_Kerio3
  #Btn_Kerio_Start
  #Frame_3
  #Text_Kerio2
  #Editor_0
  #Frame_4
  #Text_Kerio4
  #Btn_RDP_Start
  #Editor_4
  #Editor_3
  #Frame_2_Copy1
  #Text_Kerio5
  #Btn_AA_Start
  #Editor_5
  #Btn_PDF_Start
EndEnumeration
 
Enumeration FormFont
  #Font_Window_0_0
  #Font_Window_0_1
EndEnumeration
 
LoadFont(#Font_Window_0_0,"Arial", 10, #PB_Font_Bold)
LoadFont(#Font_Window_0_1,"Arial", 12, #PB_Font_Bold)
 
 
Procedure OpenWindow_0(x = 0, y = 0, width = 800, height = 636)
  OpenWindow(#Window_0, x, y, width, height, "software installation assistant @ Sadstar (FreeWare)", #PB_Window_SystemMenu)
  SetWindowColor(#Window_0, RGB(128,255,255))
  TextGadget(#Text_0, 4, 4, 792, 20, "Помощник по установке дистанционного доступа к рабочему компьютеру", #PB_Text_Center)
  SetGadgetColor(#Text_0, #PB_Gadget_FrontColor,RGB(0,0,255))
  SetGadgetColor(#Text_0, #PB_Gadget_BackColor,RGB(255,255,128))
  SetGadgetFont(#Text_0, FontID(#Font_Window_0_0))
  TextGadget(#Text_1, 4, 28, 792, 20, " для сотрудников ООО ТРБ-Ванино", #PB_Text_Center)
  SetGadgetColor(#Text_1, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_1, FontID(#Font_Window_0_0))
  FrameGadget(#Frame_0, 8, 48, 788, 48, "", #PB_Frame_Double)
  TextGadget(#Text_Bits, 16, 64, 772, 24, "")
  SetGadgetColor(#Text_Bits, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Bits, FontID(#Font_Window_0_1))
  FrameGadget(#Frame_1, 8, 100, 788, 52, "")
  TextGadget(#Text_Kerio, 16, 116, 216, 24, "1. Установить Kerio VPN Client")
  SetGadgetColor(#Text_Kerio, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Kerio, FontID(#Font_Window_0_0))
  ButtonGadget(#Btn_v32, 244, 116, 208, 28, "Установить 32-битную версию")
  ButtonGadget(#Btn_v64, 472, 116, 208, 28, "Установить 64-битную версию")
  FrameGadget(#Frame_2, 8, 236, 788, 80, "")
  TextGadget(#Text_Kerio3, 16, 248, 244, 24, "3. Запустить Kerio VPN Client")
  SetGadgetColor(#Text_Kerio3, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Kerio3, FontID(#Font_Window_0_0))
  ButtonGadget(#Btn_Kerio_Start, 16, 280, 272, 28, "Запустить Kerio VPN client")
  FrameGadget(#Frame_3, 8, 156, 788, 80, "")
  TextGadget(#Text_Kerio2, 16, 172, 188, 24, "2. Получить коды доступа")
  SetGadgetColor(#Text_Kerio2, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Kerio2, FontID(#Font_Window_0_0))
  EditorGadget(#Editor_0, 212, 172, 580, 56, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  SetGadgetFont(#Editor_0, FontID(#Font_Window_0_0))
  FrameGadget(#Frame_4, 8, 316, 788, 156, "")
  TextGadget(#Text_Kerio4, 16, 328, 388, 24, "4. Запустить Подключение к удаленному рабочему столу")
  SetGadgetColor(#Text_Kerio4, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Kerio4, FontID(#Font_Window_0_0))
  ButtonGadget(#Btn_RDP_Start, 412, 328, 272, 28, "Подключение к удаленному рабочему столу")
  EditorGadget(#Editor_4, 12, 360, 780, 108, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  SetGadgetFont(#Editor_4, FontID(#Font_Window_0_0))
  EditorGadget(#Editor_3, 304, 248, 488, 60, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  SetGadgetFont(#Editor_3, FontID(#Font_Window_0_0))
  FrameGadget(#Frame_2_Copy1, 8, 472, 788, 160, "")
  TextGadget(#Text_Kerio5, 16, 488, 160, 24, "5. Аварийный вариант")
  SetGadgetColor(#Text_Kerio5, #PB_Gadget_BackColor,RGB(128,255,255))
  SetGadgetFont(#Text_Kerio5, FontID(#Font_Window_0_0))
  ButtonGadget(#Btn_AA_Start, 28, 520, 128, 56, "программа дистанционного администрирования", #PB_Button_Default | #PB_Button_MultiLine)
  EditorGadget(#Editor_5, 176, 484, 616, 140, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
  SetGadgetFont(#Editor_5, FontID(#Font_Window_0_0))
  ButtonGadget(#Btn_PDF_Start, 28, 592, 128, 28, "  PDF инструкция", #PB_Button_Default | #PB_Button_MultiLine)
EndProcedure

OpenWindow_0()
Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
  
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP