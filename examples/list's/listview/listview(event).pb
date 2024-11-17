; keyboard events
; flag = none
; up/down selected item 
; up/down post event leftclick

; flag = clickselect
; spake & up/down selected item
; spake post event leftclick

; flag = multiselect
; shift & up/down selected item 
; up/down post event leftclick

; qt 
; flag = none 
; up/down selected item 
; up/down post event leftclick
; fn left/right first-last item and selected 
; fn up/down first-last visible item and selected 


XIncludeFile "../../../widgets.pbi" 
;XIncludeFile "../empty.pb"
UseWidgets( )
 
 Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
  Protected g = ListViewGadget(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 20
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    CocoaMessage(0, GadgetID(gadget), "setUsesAlternatingRowBackgroundColors:", #YES)
    
    CocoaMessage(0, GadgetID(gadget), "sizeLastColumnToFit")
 
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure


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
  Select WidgetEvent( )
    Case #__event_DragStart
      Debug  ""+IDWidget(EventWidget( ))+" - widget DragStart "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_Change
      Debug  ""+IDWidget(EventWidget( ))+" - widget Change "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_LeftClick
      Debug  ""+IDWidget(EventWidget( ))+" - widget LeftClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_Left2Click
      Debug  ""+IDWidget(EventWidget( ))+" - widget LeftDoubleClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #__event_RightClick
      Debug  ""+IDWidget(EventWidget( ))+" - widget RightClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
;       
;     Case #__event_Up
;       Debug  ""+IDWidget(EventWidget( ))+" - widget Up "+GetState(EventWidget( ))
;       
;     Case #__event_Down
;       Debug  ""+IDWidget(EventWidget( ))+" - widget Down "+GetState(EventWidget( ))
;       
;     Case #__event_ScrollChange
;       Debug  ""+IDWidget(EventWidget( ))+" - widget ScrollChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
;       
;     Case #__event_StatusChange
;       Debug  ""+IDWidget(EventWidget( ))+" - widget StatusChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
  EndSelect
EndProcedure

If Open(0, 0, 0, 270+260, 160+150+150, "listviewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;{
  Define i,a
  ;
  ListViewGadget_(0, 10, 30, 250, 120);, #PB_ListView_ClickSelect|#PB_ListView_MultiSelect) 
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  For a = 0 To 12
    AddGadgetItem (0, -1, "listview item " + Str(a)) ; define listview content
    SetGadgetItemState(0, a, #PB_Tree_Selected) 
  Next
  SetGadgetState(0, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  ListViewGadget_(1, 10, 30+150, 250, 120, #PB_ListView_ClickSelect)
  TextGadget(#PB_Any, 10,10+150, 250,20, "flag = ClickSelect")
  For a = 0 To 12
    AddGadgetItem (1, -1, "listview item " + Str(a) + " 1long 2long 3long 4long 5long 6long 7long 8long") ; define listview content
    SetGadgetItemState(1, a, #PB_Tree_Selected) 
  Next
  SetGadgetState(1, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  ListViewGadget_(2, 10, 30+150+150, 250, 120, #PB_ListView_MultiSelect)
  TextGadget(#PB_Any, 10,10+150+150, 250,20, "flag = MultiSelect")
  For a = 0 To 12
    AddGadgetItem (2, -1, "listview item " + Str(a)) ; define listview content
    SetGadgetItemState(2, a, #PB_Tree_Selected) 
  Next
  SetGadgetState(2, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  ;}
  ;--------------
  
  ListView(270, 30, 250, 120) : SetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(0), -1, "listview item " + Str(a)) ; define listview content
    SetItemState(ID(0), a, #PB_Tree_Selected) 
  Next
  SetState(ID(0), 5) 
  SetState(ID(0), 7) 
  SetState(ID(0), 9) 
  
  ListView(270, 30+150, 250, 120, #PB_ListView_ClickSelect) : SetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(1), -1, "listview item " + Str(a) + " 1long 2long 3long 4long 5long 6long 7long 8long") ; define listview content
    If a%2
      SetItemState(ID(1), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(ID(1), 5) 
  SetState(ID(1), 7) 
  SetState(ID(1), 9) 
  
  ListView(270, 30+150+150, 250, 120, #PB_ListView_MultiSelect) : SetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(2), -1, "listview item " + Str(a)) ; define listview content
    If a%2
      SetItemState(ID(2), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetState(ID(2), 5) 
  SetState(ID(2), 7) 
  SetState(ID(2), 9) 
  
  Text(270,10, 250,20, "flag = no")
  Text(270,10+150, 250,20, "flag = ClickSelect")
  Text(270,10+150+150, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    Bind(ID(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 174
; FirstLine = 149
; Folding = --
; EnableXP
; DPIAware