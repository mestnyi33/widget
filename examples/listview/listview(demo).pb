; keyboard events
; flag = none
; up/down selected item 
; up/down post event leftclick

; flag = multiselect
; shift & up/down selected item 
; up/down post event leftclick

; flag = clickselect
; spake & up/down selected item
; spake post event leftclick


XIncludeFile "../../widgets.pbi" 
;XIncludeFile "../empty.pb"
Uselib(widget)

Procedure events_gadgets()
  Select EventType()
    Case #PB_EventType_DragStart
      Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
      
  EndSelect
EndProcedure

Procedure events_widgets()
  Select *event\type
;     Case #PB_EventType_Up
;       Debug  ""+GetIndex(*event\widget)+" - widget Up "+GetState(*event\widget)
;       
;     Case #PB_EventType_Down
;       Debug  ""+GetIndex(*event\widget)+" - widget Down "+GetState(*event\widget)
;       
;     Case #PB_EventType_ScrollChange
;       Debug  ""+GetIndex(*event\widget)+" - widget ScrollChange "+GetState(*event\widget) +" "+ *event\item
;       
;     Case #PB_EventType_StatusChange
;       Debug  ""+GetIndex(*event\widget)+" - widget StatusChange "+GetState(*event\widget) +" "+ *event\item
;       
    Case #PB_EventType_DragStart
      Debug  ""+GetIndex(*event\widget)+" - widget DragStart "+GetState(*event\widget) +" "+ *event\item
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(*event\widget)+" - widget Change "+GetState(*event\widget) +" "+ *event\item
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(*event\widget)+" - widget LeftClick "+GetState(*event\widget) +" "+ *event\item
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(*event\widget)+" - widget LeftDoubleClick "+GetState(*event\widget) +" "+ *event\item
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(*event\widget)+" - widget RightClick "+GetState(*event\widget) +" "+ *event\item
      
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 270+270+270, 160+160, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ListViewGadget(0, 10, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget(1, 10+270, 30, 250, 120, #PB_ListView_ClickSelect)
  For a = 0 To 12
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget(2, 10+270+270, 30, 250, 120, #PB_ListView_MultiSelect)
  For a = 0 To 12
    AddGadgetItem (2, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  TextGadget(#PB_Any, 10+270,10, 250,20, "flag = ClickSelect")
  TextGadget(#PB_Any, 10+270+270,10, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  ;--------------
  
  ListView(10, 190, 250, 120)
  For a = 0 To 12
    AddItem (GetWidget(0), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(GetWidget(0), 5) 
  SetState(GetWidget(0), 7) 
  SetState(GetWidget(0), 9) 
  ;SetItemState(GetWidget(0), 5, 1) 
  
  ListView(10+270, 190, 250, 120, #__listview_clickselect)
  For a = 0 To 12
    AddItem (GetWidget(1), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(GetWidget(1), 5) 
  SetState(GetWidget(1), 7) 
  SetState(GetWidget(1), 9) 
  
  ListView(10+270+270, 190, 250, 120, #__listview_multiselect)
  For a = 0 To 12
    AddItem (GetWidget(2), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(GetWidget(2), 5) 
  SetState(GetWidget(2), 7) 
  SetState(GetWidget(2), 9) 
  
  Text(10,170, 250,20, "flag = no")
  Text(10+270,170, 250,20, "flag = ClickSelect")
  Text(10+270+270,170, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP