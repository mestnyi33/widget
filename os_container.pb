
If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
  
  ContainerGadget(1,20, 20, 180, 180, #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "1")
  
  ContainerGadget(9,70, 10, 70, 180,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "9") : CloseGadgetList() ;
  
  ContainerGadget(2,20, 20, 180, 180, #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "2")
  ContainerGadget(3,20, 20, 180, 180, #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "3")
  
  ContainerGadget(4,0, 20, 180, 30,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "4") : CloseGadgetList()
  ContainerGadget(5,0, 35, 180, 30,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "5") : CloseGadgetList() 
  ContainerGadget(6,0, 50, 180, 30,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "6") : CloseGadgetList() 
  ContainerGadget(7,20, 70, 180, 180,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "7") : CloseGadgetList()
  
  CloseGadgetList()
  CloseGadgetList()
  ContainerGadget(8,10, 70, 70, 180,  #PB_Container_Flat) : TextGadget(-1, 0,0,20,20, "8") : CloseGadgetList()
  
  For i=1 To 9
    SetGadgetColor(i, #PB_Gadget_BackColor, $FFFF00FF)
  Next
  
  Repeat
    Event = WaitWindowEvent()
    
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP