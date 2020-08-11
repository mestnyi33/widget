XIncludeFile "../../widgets.pbi" : Uselib(widget)

; - AddItem(): Add a panel. 
; - RemoveItem(): Remove a panel. 
; - CountItems(): Count the number of panels. 
; - ClearItems(): Remove all panels. 
; - GetItemText(): Retrieve the text of the specified item. 
; - SetItemText(): Change the text of the specified item. 
; - SetItemImage(): Change the image of the specified item. ;;;;;;;;;;;(Not supported on OS X) 
; - GetItemData(): Retrieve the value associated With the specified item. 
; - SetItemData(): Associate a value With the specified item. 
; 
; - SetState(): Change the active panel. 
; - GetState(): Get the index of the current panel. 
; - GetAttribute(): With one of the following attributes: (there must be at least 1 item For this To work) 

Procedure events_gadgets()
  Debug ""+EventGadget() + " - gadget  event - " +EventType()+ "  item - " +GetGadgetState(EventGadget())
EndProcedure

Procedure events_widgets()
  Debug ""+Str(GetIndex(this()\widget))+ " - widget event - " +this()\event+ "  item - " +this()\item ; GetState(this()\widget) ; 
EndProcedure

Procedure events_gbuttons()
  Select EventType()
    Case #PB_EventType_LeftClick
      Select EventGadget()
        Case 2 
          If CountGadgetItems(1) > 1
            RemoveGadgetItem(1, 1)
            Debug ""+CountGadgetItems(1) +" - count gadget items"
          EndIf
          
        Case 4 : ClearGadgetItems(1)
          Debug ""+CountGadgetItems(1) +" - count gadget items"
          
        Case 3 
          OpenGadgetList(1)
          AddGadgetItem(1, 1, "Sub 2 (add)")
          If CountGadgetItems(1) > 1
            SetGadgetItemText(1, 1, "Sub 2 (add&set)")
            Debug GetGadgetItemText(1, 1) + " - get item text"
          Else
            SetGadgetItemText(1, 0, "Sub 1 (add&set)")
            Debug GetGadgetItemText(1, 0) + " - get item text"
          EndIf
          CloseGadgetList()
      EndSelect
  EndSelect
EndProcedure

Procedure events_wbuttons()
  Select this()\event
    Case #PB_EventType_LeftClick
      Select GetIndex(this()\widget)
        Case 2 
          If CountItems(GetWidget(1)) > 1
            RemoveItem(GetWidget(1), 1)
            Debug ""+CountItems(GetWidget(1)) +" - count widget items"
          EndIf
          
        Case 4 : ClearItems(GetWidget(1))
          Debug ""+CountItems(GetWidget(1)) +" - count widget items"
          
        Case 3 
          ;OpenList(GetWidget(1))
          AddItem(GetWidget(1), 1, "Sub 2 (add)")
          If CountItems(GetWidget(1)) > 1
            SetItemText(GetWidget(1), 1, "Sub 2 (add&set)")
            Debug GetItemText(GetWidget(1), 1) + " - get item text"
          Else
            SetItemText(GetWidget(1), 0, "Sub 1 (add&set)")
            Debug GetItemText(GetWidget(1), 0) + " - get item text"
          EndIf
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
  SetGadgetState(1, 2)
  CloseGadgetList()
  
  ButtonGadget(2, 10, 145, 80, 24,"remove")
  ButtonGadget(3, 95, 145, 80, 24,"add")
  ButtonGadget(4, 95+85, 145, 80, 24,"clear")
  
  AddGadgetItem (0, -1,"Panel 2")
  ButtonGadget(5, 10, 15, 80, 24,"Button 3")
  ButtonGadget(6, 95, 15, 80, 24,"Button 4")
  CloseGadgetList()
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  For i = 2 To 4
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
  SetState(GetWidget(1), 2)
  CloseList()
  
  Button(10, 145, 80, 24,"remove")
  Button(95, 145, 80, 24,"add")
  Button(95+85, 145, 80, 24,"clear")
  
  AddItem (GetWidget(0), -1,"Panel 2")
  Button(10, 15, 80, 24,"Button 3")
  Button(95, 15, 80, 24,"Button 4")
  CloseList()
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  For i = 2 To 4
    Bind(GetWidget(i), @events_wbuttons())
  Next
  
  Debug ""+CountItems(GetWidget(1)) +" - count widget items"
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP