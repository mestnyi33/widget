IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"

UseModule Tree
Global *w._S_widget

If OpenWindow(0, 216, 0, 550, 530, "",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
  TreeGadget(1, 30, 30, 230, 380)
  AddGadgetItem(1,-1,"2010",0,0)
  AddGadgetItem(1,-1,"2011",0,0)
  AddGadgetItem(1,-1,"2012",0,2)
  AddGadgetItem(1,-1,"2013",0,0)
  AddGadgetItem(1,-1,"2014",0,2)
  AddGadgetItem(1,-1,"2015",0,2)
  AddGadgetItem(1,-1,"2016",0,2) 
  
  Debug CountGadgetItems (1)
  
  *w = GetGadgetData(Gadget(2, 290, 30, 230, 380))
  
  AddItem(*w,-1,"2010",0,0)
  AddItem(*w,-1,"2011",0,0)
  AddItem(*w,-1,"2012",0,2)
  AddItem(*w,-1,"2013",0,0)
  AddItem(*w,-1,"2014",0,2)
  AddItem(*w,-1,"2015",0,2)
  AddItem(*w,-1,"2016",0,2) 
  
  Debug CountItems (*w)
  ;redraw(*w)
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf
End
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP