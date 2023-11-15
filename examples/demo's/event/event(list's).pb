
;-
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


XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

Procedure events_gadgets()
  ;  Debug  ""+EventType()+" "+ EventGadget() +" - gadget "+ GetGadgetState(EventGadget())
  Select Event()
    Case #PB_Event_GadgetDrop
      Debug ""+ EventGadget() +" - gadget Drop "+GetGadgetState(EventGadget()) ; "drop - "+EventDropText()
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_DragStart
          Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
          
          ; 
          DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
          
        Case #PB_EventType_Change
          Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_LeftClick
          Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_LeftDoubleClick
          Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_RightClick
          Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
          
      EndSelect
  EndSelect
EndProcedure

Procedure events_widgets()
  Select WidgetEventType( )
    Case #__event_Drop
      Debug  ""+GetIndex(EventWidget( ))+" - widget Drop "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
      ;     Case #__event_Up
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Up "+GetState(EventWidget( ))
      ;       
      ;     Case #__event_Down
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Down "+GetState(EventWidget( ))
      ;       
      ;     Case #__event_ScrollChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget ScrollChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;       
      ;     Case #__event_StatusChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget StatusChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;      
    Case #__event_DragStart
      Debug  ""+GetIndex(EventWidget( ))+" - widget DragStart "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_Change
      Debug  ""+GetIndex(EventWidget( ))+" - widget Change "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_LeftClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_LeftDoubleClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftDoubleClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_RightClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget RightClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
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
  
  TreeGadget(1, 10+270, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  EditorGadget(2, 10+270+270, 30, 250, 120) ; ListIconGadget(2, 10+270+270, 30, 250, 120, "column_0", 80) : AddGadgetColumn(2, 1, "column_1", 80)
  For a = 0 To 12
    AddGadgetItem (2, -1, "Item " + Str(a) +Chr(10)+ " of the Listview") ; define listview content
  Next
  SetGadgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  TextGadget(#PB_Any, 10,10, 250,20, "list")
  TextGadget(#PB_Any, 10+270,10, 250,20, "tree")
  TextGadget(#PB_Any, 10+270+270,10, 250,20, "editor")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
    EnableGadgetDrop(i, #PB_Drop_Text, #PB_Drag_Copy)
  Next
  
  BindEvent(#PB_Event_GadgetDrop, @events_gadgets())
  
  ;--------------
  
  ListView(10, 190, 250, 120)
  For a = 0 To 12
    AddItem (GetWidget(0), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(GetWidget(0), 7) ; set (beginning with 0) the tenth item as the active one
  SetState(GetWidget(0), 8) ; set (beginning with 0) the tenth item as the active one
  SetState(GetWidget(0), 9) ; set (beginning with 0) the tenth item as the active one
  
  Tree(10+270, 190, 250, 120)
  For a = 0 To 12
    AddItem (GetWidget(1), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(GetWidget(1), 8) ; set (beginning with 0) the tenth item as the active one
  SetState(GetWidget(1), 7) ; set (beginning with 0) the tenth item as the active one
  SetState(GetWidget(1), 8) ; set (beginning with 0) the tenth item as the active one
  SetState(GetWidget(1), 9) ; set (beginning with 0) the tenth item as the active one
  
  Editor(10+270+270, 190, 250, 120) ; ListIcon(10+270+270, 190, 250, 120, "column_0", 80) : AddColumn(GetWidget(2), 1, "column_1", 80)
  For a = 0 To 12
    AddItem(GetWidget(2), -1, "Item " + Str(a) +Chr(10)+ " of the Listview") ; define listview content
  Next
  ;   Resize(GetWidget(2), #PB_Ignore, #PB_Ignore, #PB_Ignore, 121)
  ;   Resize(GetWidget(2), #PB_Ignore, #PB_Ignore, #PB_Ignore, 120)
  ;   SetState(GetWidget(2), 7) ; set (beginning with 0) the tenth item as the active one
  ;   SetState(GetWidget(2), 8) ; set (beginning with 0) the tenth item as the active one
  ;   SetState(GetWidget(2), 9) ; set (beginning with 0) the tenth item as the active one
  
  Text(10,170, 250,20, "list")
  Text(10+270,170, 250,20, "tree")
  Text(10+270+270,170, 250,20, "editor")
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 78
; FirstLine = 75
; Folding = --
; EnableXP