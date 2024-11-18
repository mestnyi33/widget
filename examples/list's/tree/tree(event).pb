XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Global g,*g._s_widget

Procedure events_gadgets( )
  Select EventType( )
    Case #PB_EventType_DragStart
      Debug  ""+ EventGadget( ) +" - gadget DragStart "+GetGadGetWidgetState(EventGadget( ))
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget( ) +" - gadget Change "+GetGadGetWidgetState(EventGadget( ))
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget( ) +" - gadget LeftClick "+GetGadGetWidgetState(EventGadget( ))
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget( ) +" - gadget LeftDoubleClick "+GetGadGetWidgetState(EventGadget( ))
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget( ) +" - gadget RightClick "+GetGadGetWidgetState(EventGadget( ))
      
  EndSelect
EndProcedure

Procedure events_widgets()
  ;; ClearDebugOutput()
  
  Select WidgetEvent()
    Case #__event_Focus
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( FOCUS ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
    Case #__event_LostFocus
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LOSTFOCUS ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Drop
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DROP ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_DragStart
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DRAGSTART ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Up
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( UP ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Down
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DOWN ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Change
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( CHANGE ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_ScrollChange
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( SCROLL ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem() +" "+ WidgetEventData()
      
    Case #__event_StatusChange
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( STATUS ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_LeftClick
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LEFTCLICK ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Left2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LEFT2CLICK ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_RightClick
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( RIGHTCLICK ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Right2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( RIGHT2CLICK ) "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
      
  EndSelect
EndProcedure

#PB_Tree_ClickSelect = 0;#PB_ListView_ClickSelect
#PB_Tree_MultiSelect = 0;#PB_ListView_MultiSelect
Define i,a
  
If OpenRoot(0, 0, 0, 270+260, 160+150+150, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;{
  ;
  g = TreeGadget(0, 10, 30, 250, 120, #PB_Tree_CheckBoxes) 
  For a = 0 To 6
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Tree",0,0) ; define Tree content
    AddGadgetItem (0, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    i = (CountGadgetItems( 0 )-1)
    
    If i%2
      SetGadGetWidgetItemState(0, i, #PB_Tree_Selected) 
    EndIf
  Next
  For i=0 To CountGadgetItems(0) : SetGadGetWidgetItemState(0, i, #PB_Tree_Expanded) : Next
  
  SetGadGetWidgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  TreeGadget(1, 10, 30+150, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_ClickSelect)
  For a = 0 To 6
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Tree long long long long long",0,0) ; define Tree content
    AddGadgetItem (1, -1, "Subtem " + Str(a) + " of the Tree",0,1)                        ; define Tree content
    i = (CountGadgetItems( 1 )-1)
    
    If i%2
      SetGadGetWidgetItemState(1, i, #PB_Tree_Selected) 
    EndIf
  Next
  For i=0 To CountGadgetItems(1) : SetGadGetWidgetItemState(1, i, #PB_Tree_Expanded) : Next
  
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  TreeGadget(2, 10, 30+150+150, 250, 120, #PB_Tree_CheckBoxes|#PB_Tree_MultiSelect)
  For a = 0 To 6
    AddGadgetItem (2, -1, "Item " + Str(a) + " of the Tree",0,0) ; define Tree content
    AddGadgetItem (2, -1, "Subtem " + Str(a) + " of the Tree",0,1) ; define Tree content
    
    i = (CountGadgetItems( 2 )-1)
    
    If i%2
      SetGadGetWidgetItemState(2, i, #PB_Tree_Selected) 
    EndIf
  Next
  For i=0 To CountGadgetItems(2) : SetGadGetWidgetItemState(2, i, #PB_Tree_Expanded) : Next
  
  SetGadGetWidgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets( ))
  Next
  
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  TextGadget(#PB_Any, 10,10+150, 250,20, "flag = ClickSelect")
  TextGadget(#PB_Any, 10,10+150+150, 250,20, "flag = MultiSelect")
  ;}
  ;--------------
  
  *g = TreeWidget(270, 30, 250, 120, #__tree_CheckBoxes|#__Flag_GridLines)
  For a = 0 To 6
    AddItem (*g, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (*g, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( *g )-1)
    If i%2
      SetWidgetItemState(*g, i, #PB_Tree_Selected) 
    EndIf
  Next
  
  
  TreeWidget(270, 30+150, 250, 120, #__tree_CheckBoxes|#__flag_RowClickSelect|#__Flag_GridLines)
  For a = 0 To 2
    AddItem ( WidgetID(1), -1, "Item " + Str(a) + " of the Tree long long long long long", -1, 0) ; define Tree content
    AddItem ( WidgetID(1), -1, "Subitem " + Str(a) + " of the Tree", -1, 1)                       ; define Tree content
    
    i = (CountItems( WidgetID(1) )-1)
    
    If i%2
      SetWidgetItemState( WidgetID(1), i, #PB_Tree_Selected) 
    EndIf
  Next
  SetWidgetState( WidgetID(1), 5) 
  SetWidgetState( WidgetID(1), 7) 
  SetWidgetState( WidgetID(1), 9) 
  
  
  TreeWidget(270, 30+150+150, 250, 120, #__tree_CheckBoxes|#__flag_RowMultiSelect|#__Flag_GridLines)
  For a = 0 To 6
    AddItem ( WidgetID(2), -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem ( WidgetID(2), -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( WidgetID(2) )-1)
    
    If i%2
      SetWidgetItemState( WidgetID(2), i, #PB_Tree_Selected) 
    EndIf
  Next
  SetWidgetState( WidgetID(2), 5) 
  SetWidgetState( WidgetID(2), 7) 
  SetWidgetState( WidgetID(2), 9) 
  
  For i = 0 To 2
    BindWidgetEvent( WidgetID(i), @events_widgets( ))
  Next
  ;BindWidgetEvent(*g, @events_widgets( ))
  
  TextWidget(270,10, 250,20, "flag = no")
  TextWidget(270,10+150, 250,20, "flag = ClickSelect")
  TextWidget(270,10+150+150, 250,20, "flag = MultiSelect")
  
  
  Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 183
; FirstLine = 137
; Folding = ---
; EnableXP
; DPIAware