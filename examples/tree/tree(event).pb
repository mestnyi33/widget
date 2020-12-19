XIncludeFile "../../widgets.pbi" 
Uselib(widget)

Global g,*g._s_widget

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
  ;; ClearDebugOutput()
  
  Select this()\event
    Case #PB_EventType_Up
      Debug  ""+GetIndex(this()\widget)+" - widget Up "+GetState(this()\widget)
      
    Case #PB_EventType_Down
      Debug  ""+GetIndex(this()\widget)+" - widget Down "+GetState(this()\widget)
      
    Case #PB_EventType_ScrollChange
      Debug  ""+GetIndex(this()\widget)+" - widget ScrollChange "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_StatusChange
      Debug  ""+GetIndex(this()\widget)+" - widget StatusChange "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_DragStart
      Debug  ""+GetIndex(this()\widget)+" - widget DragStart "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(this()\widget)+" - widget Change "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(this()\widget)+" - widget LeftClick "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(this()\widget)+" - widget LeftDoubleClick "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(this()\widget)+" - widget RightClick "+GetState(this()\widget) +" "+ this()\item
      
  EndSelect
EndProcedure

#PB_Tree_ClickSelect = #PB_ListView_ClickSelect
#PB_Tree_MultiSelect = #PB_ListView_MultiSelect

If Open(OpenWindow(#PB_Any, 0, 0, 270+260, 160+150+150, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ;{
  Define i,a
  ;
  g = TreeGadget(0, 10, 30, 250, 120, #PB_Tree_CheckBoxes) 
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  For a = 0 To 6
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Tree",0,0) ; define Tree content
    AddGadgetItem (0, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    SetGadgetItemState(0, a, #PB_Tree_Selected) 
  Next
  For i=0 To CountGadgetItems(0) : SetGadgetItemState(0, i, #PB_Tree_Expanded) : Next
  
  SetGadgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  TreeGadget(1, 10, 30+150, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_ClickSelect)
  TextGadget(#PB_Any, 10,10+150, 250,20, "flag = ClickSelect")
  For a = 0 To 6
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Tree long long long long long",0,0) ; define Tree content
    AddGadgetItem (1, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    SetGadgetItemState(1, a, #PB_Tree_Selected) 
  Next
  For i=0 To CountGadgetItems(1) : SetGadgetItemState(1, i, #PB_Tree_Expanded) : Next
  
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  TreeGadget(2, 10, 30+150+150, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_MultiSelect)
  TextGadget(#PB_Any, 10,10+150+150, 250,20, "flag = MultiSelect")
  For a = 0 To 6
    AddGadgetItem (2, -1, "Item " + Str(a) + " of the Tree",0,0) ; define Tree content
    AddGadgetItem (2, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    SetGadgetItemState(2, a, #PB_Tree_Selected) 
  Next
  For i=0 To CountGadgetItems(2) : SetGadgetItemState(2, i, #PB_Tree_Expanded) : Next
  
  SetGadgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  ;}
  ;--------------
  
  *g = Tree(270, 30, 250, 120, #__Flag_GridLines|#__Tree_CheckBoxes)
  For a = 0 To 6
    AddItem (GetWidget(0), -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (GetWidget(0), -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    If a%2
     ; Debug a
    ;  SetItemState(GetWidget(0), a, #PB_Tree_Selected) 
    EndIf
  Next
  
  For a = 0 To 6
    ;AddItem (GetWidget(0), -1, "Item " + Str(a) + " of the Tree") ; define Tree content
    ;AddItem (GetWidget(0), -1, "Subitem " + Str(a) + " of the Tree", 1) ; define Tree content
    If a%2
      Debug a
      SetItemState(GetWidget(0), a, #PB_Tree_Selected) 
    EndIf
  Next
; ; ;   SetState(GetWidget(0), 5) 
; ; ;   SetState(GetWidget(0), 7) 
; ; ;   SetState(GetWidget(0), 9) 
  ;SetItemState(GetWidget(0), 5, 1) 
  
  Tree(270, 30+150, 250, 120, #__Flag_GridLines|#__Tree_CheckBoxes|#__Tree_clickselect)
  For a = 0 To 6
    AddItem (GetWidget(1), -1, "Item " + Str(a) + " of the Tree long long long long long", -1, 0) ; define Tree content
    AddItem (GetWidget(1), -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    If a%2
      SetItemState(GetWidget(1), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(GetWidget(1), 5) 
  SetState(GetWidget(1), 7) 
  SetState(GetWidget(1), 9) 
  
  Tree(270, 30+150+150, 250, 120, #__Flag_GridLines|#__Tree_CheckBoxes|#__Tree_multiselect)
  For a = 0 To 6
    AddItem (GetWidget(2), -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (GetWidget(2), -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    If a%2
      SetItemState(GetWidget(2), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(GetWidget(2), 5) 
  SetState(GetWidget(2), 7) 
  SetState(GetWidget(2), 9) 
  
  Text(270,10, 250,20, "flag = no")
  Text(270,10+150, 250,20, "flag = ClickSelect")
  Text(270,10+150+150, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
  ;  Bind(GetWidget(i), @events_widgets())
  Next
  
  Bind(*g, @events_widgets())
    
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP