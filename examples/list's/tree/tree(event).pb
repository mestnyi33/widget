XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

Global g,*g._s_widget

Procedure events_gadgets( )
  Select EventType( )
    Case #PB_EventType_DragStart
      Debug  ""+ EventGadget( ) +" - gadget DragStart "+GetGadgetState(EventGadget( ))
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget( ) +" - gadget Change "+GetGadgetState(EventGadget( ))
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget( ) +" - gadget LeftClick "+GetGadgetState(EventGadget( ))
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget( ) +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget( ))
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget( ) +" - gadget RightClick "+GetGadgetState(EventGadget( ))
      
  EndSelect
EndProcedure

Procedure events_widgets()
  ;; ClearDebugOutput()
  
  Select WidgetEventType()
    Case #__event_Focus
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( FOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
    Case #__event_LostFocus
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LOSTFOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Drop
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DROP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_DragStart
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DRAGSTART ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Up
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( UP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Down
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DOWN ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Change
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( CHANGE ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_ScrollChange
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( SCROLL ) "+GetState(EventWidget()) +" "+ WidgetEventItem() +" "+ WidgetEventData()
      
    Case #__event_StatusChange
      ;Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( STATUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_LeftClick
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LEFTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Left2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LEFT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_RightClick
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( RIGHTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Right2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( RIGHT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
  EndSelect
EndProcedure

#PB_Tree_ClickSelect = 0;#PB_ListView_ClickSelect
#PB_Tree_MultiSelect = 0;#PB_ListView_MultiSelect

If Open(OpenWindow(#PB_Any, 0, 0, 270+260, 160+150+150, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ;{
  Define i,a
  ;
  g = TreeGadget(0, 10, 30, 250, 120, #PB_Tree_CheckBoxes) 
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  For a = 0 To 6
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Tree",0,0) ; define Tree content
    AddGadgetItem (0, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    i = (CountGadgetItems( 0 )-1)
    
    If i%2
      SetGadgetItemState(0, i, #PB_Tree_Selected) 
    EndIf
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
    AddGadgetItem (1, -1, "Subtem " + Str(a) + " of the Tree",0,1)                        ; define Tree content
    i = (CountGadgetItems( 1 )-1)
    
    If i%2
      SetGadgetItemState(1, i, #PB_Tree_Selected) 
    EndIf
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
    
    i = (CountGadgetItems( 2 )-1)
    
    If i%2
      SetGadgetItemState(2, i, #PB_Tree_Selected) 
    EndIf
  Next
  For i=0 To CountGadgetItems(2) : SetGadgetItemState(2, i, #PB_Tree_Expanded) : Next
  
  SetGadgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets( ))
  Next
  ;}
  ;--------------
  
  *g = Tree(270, 30, 250, 120, #__Flag_GridLines|#__tree_CheckBoxes)
  For a = 0 To 6
    AddItem (*g, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (*g, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( *g )-1)
    If i%2
      SetItemState(*g, i, #PB_Tree_Selected) 
    EndIf
  Next
  
  
  Tree(270, 30+150, 250, 120, #__Flag_GridLines|#__tree_CheckBoxes|#__tree_clickselect)
  For a = 0 To 2
    AddItem (GetWidget(1), -1, "Item " + Str(a) + " of the Tree long long long long long", -1, 0) ; define Tree content
    AddItem (GetWidget(1), -1, "Subitem " + Str(a) + " of the Tree", -1, 1)                       ; define Tree content
    
    i = (CountItems( GetWidget(1) )-1)
    
    If i%2
      SetItemState(GetWidget(1), i, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(GetWidget(1), 5) 
  SetState(GetWidget(1), 7) 
  SetState(GetWidget(1), 9) 
  
  
  Tree(270, 30+150+150, 250, 120, #__Flag_GridLines|#__tree_CheckBoxes|#__tree_multiselect)
  For a = 0 To 6
    AddItem (GetWidget(2), -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (GetWidget(2), -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( GetWidget(2) )-1)
    
    If i%2
      SetItemState(GetWidget(2), i, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(GetWidget(2), 5) 
  SetState(GetWidget(2), 7) 
  SetState(GetWidget(2), 9) 
  
  Text(270,10, 250,20, "flag = no")
  Text(270,10+150, 250,20, "flag = ClickSelect")
  Text(270,10+150+150, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets( ))
  Next
  
  Bind(*g, @events_widgets( ))
  
  Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 50
; FirstLine = 40
; Folding = ---
; EnableXP