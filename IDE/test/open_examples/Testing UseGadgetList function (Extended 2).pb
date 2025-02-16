Enumeration FormWindow
  #Test
EndEnumeration

Enumeration FormGadget
  #Description
  
  #RedContainer
  #GreenContainer
  #BlueContainer
  #VioletContainer
EndEnumeration


Procedure OpenTest()
  OpenWindow(#Test, 0, 0, 404, 328, "", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  ContainerGadget(#RedContainer, 4, 32, 196, 144, #PB_Container_Single)
  SetGadgetColor(#RedContainer, #PB_Gadget_BackColor,RGB(255,128,128))
  CloseGadgetList()
  ContainerGadget(#GreenContainer, 204, 32, 196, 144, #PB_Container_Single)
  SetGadgetColor(#GreenContainer, #PB_Gadget_BackColor,RGB(128,255,128))
  CloseGadgetList()
  ContainerGadget(#BlueContainer, 4, 180, 196, 144, #PB_Container_Single)
  SetGadgetColor(#BlueContainer, #PB_Gadget_BackColor,RGB(0,128,255))
  CloseGadgetList()
  ContainerGadget(#VioletContainer, 204, 180, 196, 144, #PB_Container_Single)
  SetGadgetColor(#VioletContainer, #PB_Gadget_BackColor,RGB(255,128,255))
  CloseGadgetList()
  TextGadget(#Description, 4, 4, 396, 24, "Надписи гаджетов должны соответствовать цветам контейнеров", #PB_Text_Center | #PB_Text_Border)
  
  
  UseGadgetList(GadgetID(#RedContainer)) 
  TextGadget(#PB_Any, 4, 4, 188, 20, "Красный 1")
  UseGadgetList(GadgetID(#BlueContainer)) 
  TextGadget(#PB_Any, 4, 4, 188, 20, "Синий 1")
  UseGadgetList(GadgetID(#VioletContainer))
  TextGadget(#PB_Any, 4, 4, 188, 20, "Фиолетовый 1")
  UseGadgetList(GadgetID(#GreenContainer)) 
  TextGadget(#PB_Any, 4, 4, 188, 20, "Зелёный 1")
  
  UseGadgetList(GadgetID(#VioletContainer)) 
  TextGadget(#PB_Any, 4, 28, 188, 20, "Фиолетовый 2")
  UseGadgetList(GadgetID(#GreenContainer)) 
  TextGadget(#PB_Any, 4, 28, 188, 20, "Зелёный 2")
  UseGadgetList(GadgetID(#RedContainer)) 
  TextGadget(#PB_Any, 4, 28, 188, 20, "Красный 2")
  UseGadgetList(GadgetID(#BlueContainer)) 
  TextGadget(#PB_Any, 4, 28, 188, 20, "Синий 2")
  
  UseGadgetList(GadgetID(#BlueContainer)) 
  TextGadget(#PB_Any, 4, 52, 188, 20, "Синий 3")
  UseGadgetList(GadgetID(#VioletContainer))
  TextGadget(#PB_Any, 4, 52, 188, 20, "Фиолетовый 3")
  UseGadgetList(GadgetID(#RedContainer)) 
  TextGadget(#PB_Any, 4, 52, 188, 20, "Красный 3")
  UseGadgetList(GadgetID(#GreenContainer)) 
  TextGadget(#PB_Any, 4, 52, 188, 20, "Зелёный 3")
  
  UseGadgetList(GadgetID(#RedContainer)) 
  TextGadget(#PB_Any, 4, 76, 188, 20, "Красный 4")
  UseGadgetList(GadgetID(#GreenContainer))
  TextGadget(#PB_Any, 4, 76, 188, 20, "Зелёный 4")
  UseGadgetList(GadgetID(#BlueContainer)) 
  TextGadget(#PB_Any, 4, 76, 188, 20, "Синий 4")
  UseGadgetList(GadgetID(#VioletContainer)) 
  TextGadget(#PB_Any, 4, 76, 188, 20, "Фиолетовый 4")
EndProcedure

OpenTest()
Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 52
; FirstLine = 4
; Folding = -
; EnableXP
; CompileSourceDirectory