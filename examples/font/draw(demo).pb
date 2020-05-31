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
  Debug ""+Str(GetIndex(*event\widget))+ " - widget  event - " +*event\type+ "  item - " +*event\item ; GetState(*event\widget) ; 
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
          
        Case 5 : ClearGadgetItems(1)
          Debug ""+CountGadgetItems(1) +" - count gadget items"
          
        Case 3, 4
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
          
;           If EventGadget() = 3
;             SetGadgetItemFont(1, 2, 5)
;           ElseIf EventGadget() = 4
;             SetGadgetItemFont(1, 2, 6)
;           EndIf
          
      EndSelect
  EndSelect
EndProcedure

Procedure events_wbuttons()
  Select *event\type
    Case #PB_EventType_LeftClick
      Select GetIndex(*event\widget)
        Case 2 
          If CountItems(GetWidget(1)) > 1
            RemoveItem(GetWidget(1), 1)
            Debug ""+CountItems(GetWidget(1)) +" - count widget items"
          EndIf
          
        Case 5 : ClearItems(GetWidget(1))
          Debug ""+CountItems(GetWidget(1)) +" - count widget items"
          
        Case 3, 4
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
          
          If GetIndex(*event\widget) = 3
            SetItemFont(GetWidget(1), 2, 5)
          ElseIf GetIndex(*event\widget) = 4
            SetItemFont(GetWidget(1), 2, 6)
          EndIf
          
      EndSelect
  EndSelect
EndProcedure

; Shows using of several panels...
If Open(OpenWindow(#PB_Any, 0, 0, 322 + 322 + 100, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 322+50, 0, 322+50, 220)
  LoadFont(5, "Arial", 18)
  LoadFont(6, "Arial", 25)
  
  PanelGadget     (0, 8, 8, 306+50, 203)
  AddGadgetItem (0, -1, "Panel 1")
  PanelGadget (1, 5, 5, 290, 166-30)
  AddGadgetItem(1, -1, "Sub 1")
  AddGadgetItem(1, -1, "Sub 2")
  AddGadgetItem(1, -1, "Sub 3")
  AddGadgetItem(1, -1, "Sub 4")
  SetGadgetState(1, 2)
  CloseGadgetList()
  
  ButtonGadget(2, 10, 145, 80, 24,"remove")
  ButtonGadget(3, 95, 145, 80, 24,"add (18)")
  ButtonGadget(4, 95, 145, 80, 24,"add (25)")
  ButtonGadget(5, 95+85, 145, 80, 24,"clear")
  
  AddGadgetItem (0, -1,"Panel 2")
  ButtonGadget(6, 10, 15, 80, 24,"Button 6")
  ButtonGadget(7, 95, 15, 80, 24,"Button 7")
  CloseGadgetList()
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  For i = 2 To 5
    BindGadgetEvent(i, @events_gbuttons())
  Next
  
  Debug ""+CountGadgetItems(1) +" - count gadget items"
  
  Panel(8, 8, 306+50, 203)
  AddItem (GetWidget(0), -1, "Panel 1")
  
  Define text.s, *g
  *g = Panel(10, 10, 334, 130)
  ;*g = Tree(10, 10, 286-2+50, 130, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__tree_GridLines | #__tree_ThreeState | #__tree_OptionBoxes)                            
  
  If GetType(*g) = #PB_GadgetType_Panel
    text = "Sub"
  ElseIf GetType(*g) = #PB_GadgetType_Tree
    text = "Tree"
  EndIf
  
  AddItem (*g, 0, text+"_0", 0)                                    
  For i=1 To 6
    If i=5 
      AddItem(*g, -1, text+"_"+Str(i), -1, 0) 
    Else
      AddItem(*g, -1, text+"_"+Str(i), 0, -1) 
    EndIf
  Next 
  
  SetState(*g, 2)
  If GetType(*g) = #PB_GadgetType_Panel
    CloseList()
  EndIf
  
  SetItemFont(*g, 2, 5)
  SetItemText(*g, 2, text+"_2 (18)")
  
  SetItemFont(*g, 4, 6)
  SetItemText(*g, 4, text+"_4 (25)")
  
  Button(10, 145, 60, 24,"remove")
  
  SetFont(Button(75, 145, 100, 24,"add (18)"), FontID(5))
  SetFont(Button(180, 145, 100, 24,"add (25)"), FontID(6))
  Button(285, 145, 60, 24,"clear")
  
  AddItem (GetWidget(0), -1,"Panel 2")
  SetFont(Button(10, 15, 100, 24,"Button 3"), FontID(6))
  Button(115, 15, 100, 24,"Button 4")
  CloseList()
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  For i = 2 To 5
    Bind(GetWidget(i), @events_wbuttons())
  Next
  
  Debug ""+CountItems(GetWidget(1)) +" - count widget items"
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 8--
; EnableXP