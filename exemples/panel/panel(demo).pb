XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  Debug ""+EventGadget() + " - gadget  event - " +EventType()+ "  item - " +GetGadgetState(EventGadget())
EndProcedure

Procedure events_widgets()
  Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  item - " +*event\item ; GetState(*event\widget) ; 
EndProcedure

Procedure events_gbuttons()
  Select EventType()
    Case #PB_EventType_LeftClick
      Select EventGadget()
        Case 2 : RemoveGadgetItem(1, 1)
        Case 3 
          OpenGadgetList(1)
          AddGadgetItem(1, 1, "Sub 2 (add)")
          CloseGadgetList()
      EndSelect
  EndSelect
EndProcedure

Procedure events_wbuttons()
  Select *event\type
    Case #PB_EventType_LeftClick
      Select (*event\widget\index - 1)
        Case 2 : RemoveItem(GetWidget(1), 1)
        Case 3 
          ;OpenList(GetWidget(1))
          AddItem(GetWidget(1), 1, "Sub 2 (add)")
          ;CloseList()
      EndSelect
  EndSelect
EndProcedure



; Shows using of several panels...
If Open(OpenWindow(#PB_Any, 0, 0, 322 + 322, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 322, 0, 322, 220)
  PanelGadget     (0, 8, 8, 306, 203)
  AddGadgetItem (0, -1, "Panel 1")
  PanelGadget (1, 5, 5, 290, 166-30)
  AddGadgetItem(1, -1, "Sub 1")
  AddGadgetItem(1, -1, "Sub 2")
  AddGadgetItem(1, -1, "Sub 3")
  AddGadgetItem(1, -1, "Sub 4")
  CloseGadgetList()
  
  ButtonGadget(2, 10, 145, 80, 24,"remove")
  ButtonGadget(3, 95, 145, 80, 24,"add")
  
  AddGadgetItem (0, -1,"Panel 2")
  ButtonGadget(4, 10, 15, 80, 24,"Button 3")
  ButtonGadget(5, 95, 15, 80, 24,"Button 4")
  CloseGadgetList()
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  For i = 2 To 3
    BindGadgetEvent(i, @events_gbuttons())
  Next
  
  Debug ""+CountGadgetItems(1) +" - count gadget items"
  
  Panel(8, 8, 306, 203)
  AddItem (GetWidget(0), -1, "Panel 1")
  Panel(5, 5, 290, 166-30)
  AddItem(GetWidget(1), -1, "Sub 1")
  AddItem(GetWidget(1), -1, "Sub 2")
  AddItem(GetWidget(1), -1, "Sub 3")
  AddItem(GetWidget(1), -1, "Sub 4")
  CloseList()
  
  Button(10, 145, 80, 24,"remove")
  Button(95, 145, 80, 24,"add")
  
  AddItem (GetWidget(0), -1,"Panel 2")
  Button(10, 15, 80, 24,"Button 3")
  Button(95, 15, 80, 24,"Button 4")
  CloseList()
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  For i = 2 To 3
    Bind(GetWidget(i), @events_wbuttons())
  Next
  
  Debug ""+CountItems(GetWidget(1)) +" - count widget items"
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf


; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 7
; Folding = --
; EnableXP