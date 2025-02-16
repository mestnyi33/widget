Enumeration FormWindow
  #Window_0
EndEnumeration

Enumeration FormGadget
  #Panel_0
EndEnumeration


Global NewMap Gadgets.i()

Procedure OpenTest_Window(x = 0, y = 0, width = 590, height = 350)
  OpenWindow(#Window_0, x, y, width, height, "", #PB_Window_SystemMenu)
  PanelGadget(#Panel_0, 4, 4, 581, 341)
  For i=1 To 6
    AddGadgetItem(#Panel_0, i-1, "Tab "+Str(i));[
      Gadgets(Str(i)+"Container_1") = ContainerGadget(#PB_Any, 5, 5, 280, 150, #PB_Container_Raised);[
        SetGadgetColor(Gadgets(Str(i)+"Container_1"), #PB_Gadget_BackColor,RGB(128,255,128))
        Gadgets(Str(i)+"Button_1") = ButtonGadget(#PB_Any, 10, 10, 126, 32, Str(i)+" Слева вверху 1")
        Gadgets(Str(i)+"Button_2") = ButtonGadget(#PB_Any, 10, 50, 126, 32, Str(i)+" Слева вверху 2")
        CloseGadgetList();]
      Gadgets(Str(i)+"Container_3") = ContainerGadget(#PB_Any, 5, 160, 280, 150, #PB_Container_Double);[
        SetGadgetColor(Gadgets(Str(i)+"Container_3"), #PB_Gadget_BackColor,RGB(128,64,64))
        CloseGadgetList();]
      Gadgets(Str(i)+"Container_4") = ContainerGadget(#PB_Any, 290, 160, 280, 150, #PB_Container_Double);[
        SetGadgetColor(Gadgets(Str(i)+"Container_4"), #PB_Gadget_BackColor,RGB(128,128,255))
        CloseGadgetList();]
      Gadgets(Str(i)+"Container_5") = ContainerGadget(#PB_Any, 290, 5, 280, 150, #PB_Container_Raised);[
        Gadgets(Str(i)+"Container_6") = ContainerGadget(#PB_Any, 140, 9, 134, 130, #PB_Container_Double);[
          SetGadgetColor(Gadgets(Str(i)+"Container_6"), #PB_Gadget_BackColor,RGB(255,255,128))
          Gadgets(Str(i)+"Button_6") = ButtonGadget(#PB_Any, 10, 10, 115, 30, Str(i)+" Влож. 1")
          Gadgets(Str(i)+"Button_7") = ButtonGadget(#PB_Any, 10, 45, 115, 30, Str(i)+" Влож. 2")
          CloseGadgetList();]
        Gadgets(Str(i)+"Button_5") = ButtonGadget(#PB_Any, 10, 10, 125, 35, Str(i)+" Справа вверху 1")
        Gadgets(Str(i)+"Button_6") = ButtonGadget(#PB_Any, 10, 50, 125, 35, Str(i)+" Справа вверху 2")
        CloseGadgetList();]
    Next
    CloseGadgetList();]
  
  OpenGadgetList(Gadgets(Str(2)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "2 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "2 Слева внизу 2")
  
  OpenGadgetList(Gadgets(Str(3)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "3 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "3 Слева внизу 2")
  
  
  OpenGadgetList(Gadgets(Str(1)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "1 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "1 Слева внизу 2")
  CloseGadgetList()
  
  
  OpenGadgetList(Gadgets(Str(4)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "4 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "4 Слева внизу 2")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(5)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "5 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "5 Слева внизу 2")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(6)+"Container_3"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "5 Слева внизу 1")
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "5 Слева внизу 2")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(Random(6, 1))+"Container_4"))
  ButtonGadget(#PB_Any, 10, 10, 126, 32, "Справа внизу 1")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(Random(6, 1))+"Container_4"))
  ButtonGadget(#PB_Any, 10, 50, 126, 32, "Справа внизу 2")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(Random(6, 1))+"Container_4"))
  ButtonGadget(#PB_Any, 120, 10, 126, 32, "Справа внизу 3")
  CloseGadgetList()
  
  OpenGadgetList(Gadgets(Str(Random(6, 1))+"Container_4"))
  ButtonGadget(#PB_Any, 120, 50, 126, 32, "Справа внизу 4")
  CloseGadgetList()
  
EndProcedure


OpenTest_Window()
Repeat
  Event=WaitWindowEvent()
Until Event=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP
; CompileSourceDirectory