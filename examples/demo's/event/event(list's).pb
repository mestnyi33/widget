
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
UseWidgets( )

Procedure events_gadgets()
  ;  Debug  ""+EventType()+" "+ EventGadget() +" - gadget "+ GetGadGetWidgetState(EventGadget())
  Select Event()
    Case #PB_Event_GadgetDrop
      Debug ""+ EventGadget() +" - gadget Drop "+GetGadGetWidgetState(EventGadget()) ; "drop - "+EventDropTextWidget()
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_DragStart
          Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadGetWidgetState(EventGadget())
          
          ; 
          DragTextWidget(GetGadGetWidgetItemText(EventGadget(), GetGadGetWidgetState(EventGadget())))
          
        Case #PB_EventType_Change
          Debug  ""+ EventGadget() +" - gadget Change "+GetGadGetWidgetState(EventGadget())
          
        Case #PB_EventType_LeftClick
          Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadGetWidgetState(EventGadget())
          
        Case #PB_EventType_LeftDoubleClick
          Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadGetWidgetState(EventGadget())
          
        Case #PB_EventType_RightClick
          Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadGetWidgetState(EventGadget())
          
      EndSelect
  EndSelect
EndProcedure

Procedure events_widgets()
  Select WidgetEvent( )
    Case #__event_Drop
      Debug  ""+GetIndex(EventWidget( ))+" - widget Drop "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
      ;     Case #__event_Up
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Up "+GetWidgetState(EventWidget( ))
      ;       
      ;     Case #__event_Down
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Down "+GetWidgetState(EventWidget( ))
      ;       
      ;     Case #__event_ScrollChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget ScrollChange "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;       
      ;     Case #__event_StatusChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget StatusChange "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;      
    Case #__event_DragStart
      Debug  ""+GetIndex(EventWidget( ))+" - widget DragStart "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_Change
      Debug  ""+GetIndex(EventWidget( ))+" - widget Change "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_LeftClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftClick "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_Left2Click
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftDoubleClick "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_RightClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget RightClick "+GetWidgetState(EventWidget( )) +" "+ WidgetEventItem( )
      
  EndSelect
EndProcedure

If OpenRoot(0, 0, 0, 270+270+270, 160+160, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(0, 10, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadGetWidgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  TreeGadget(1, 10+270, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  EditorGadget(2, 10+270+270, 30, 250, 120) ; ListIconGadget(2, 10+270+270, 30, 250, 120, "column_0", 80) : AddGadgetColumn(2, 1, "column_1", 80)
  For a = 0 To 12
    AddGadgetItem (2, -1, "Item " + Str(a) +Chr(10)+ " of the Listview") ; define listview content
  Next
  SetGadGetWidgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  TextGadget(#PB_Any, 10,10, 250,20, "list")
  TextGadget(#PB_Any, 10+270,10, 250,20, "tree")
  TextGadget(#PB_Any, 10+270+270,10, 250,20, "editor")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
    EnableGadgetDrop(i, #PB_Drop_Text, #PB_Drag_Copy)
  Next
  
  BindEvent(#PB_Event_GadgetDrop, @events_gadgets())
  
  ;--------------
  
  ListViewWidget(10, 190, 250, 120)
  For a = 0 To 12
    AddItem (ID(0), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetWidgetState(ID(0), 7) ; set (beginning with 0) the tenth item as the active one
  SetWidgetState(ID(0), 8) ; set (beginning with 0) the tenth item as the active one
  SetWidgetState(ID(0), 9) ; set (beginning with 0) the tenth item as the active one
  
  TreeWidget(10+270, 190, 250, 120)
  For a = 0 To 12
    AddItem (ID(1), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetWidgetState(ID(1), 8) ; set (beginning with 0) the tenth item as the active one
  SetWidgetState(ID(1), 7) ; set (beginning with 0) the tenth item as the active one
  SetWidgetState(ID(1), 8) ; set (beginning with 0) the tenth item as the active one
  SetWidgetState(ID(1), 9) ; set (beginning with 0) the tenth item as the active one
  
  EditorWidget(10+270+270, 190, 250, 120) ; ListIconWidget(10+270+270, 190, 250, 120, "column_0", 80) : AddColumn(ID(2), 1, "column_1", 80)
  For a = 0 To 12
    AddItem(ID(2), -1, "Item " + Str(a) +Chr(10)+ " of the Listview") ; define listview content
  Next
  ;   ResizeWidget(ID(2), #PB_Ignore, #PB_Ignore, #PB_Ignore, 121)
  ;   ResizeWidget(ID(2), #PB_Ignore, #PB_Ignore, #PB_Ignore, 120)
  ;   SetWidgetState(ID(2), 7) ; set (beginning with 0) the tenth item as the active one
  ;   SetWidgetState(ID(2), 8) ; set (beginning with 0) the tenth item as the active one
  ;   SetWidgetState(ID(2), 9) ; set (beginning with 0) the tenth item as the active one
  
  TextWidget(10,170, 250,20, "list")
  TextWidget(10+270,170, 250,20, "tree")
  TextWidget(10+270+270,170, 250,20, "editor")
  
  For i = 0 To 2
    BindWidgetEvent(ID(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 144
; FirstLine = 137
; Folding = --
; EnableXP
; DPIAware