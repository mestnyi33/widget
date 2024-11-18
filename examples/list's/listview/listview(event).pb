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
      Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadGetWidgetState(EventGadget())
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget() +" - gadget Change "+GetGadGetWidgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadGetWidgetState(EventGadget())
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadGetWidgetState(EventGadget())
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadGetWidgetState(EventGadget())
      
  EndSelect
EndProcedure

Procedure events_widgets()
  Select WidgetEvent( )
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
;       
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
      
  EndSelect
EndProcedure

If OpenRoot(0, 0, 0, 270+260, 160+150+150, "listviewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;{
  Define i,a
  ;
  ListViewGadget_(0, 10, 30, 250, 120);, #PB_ListView_ClickSelect|#PB_ListView_MultiSelect) 
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  For a = 0 To 12
    AddGadgetItem (0, -1, "listview item " + Str(a)) ; define listview content
    SetGadGetWidgetItemState(0, a, #PB_Tree_Selected) 
  Next
  SetGadGetWidgetState(0, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  ListViewGadget_(1, 10, 30+150, 250, 120, #PB_ListView_ClickSelect)
  TextGadget(#PB_Any, 10,10+150, 250,20, "flag = ClickSelect")
  For a = 0 To 12
    AddGadgetItem (1, -1, "listview item " + Str(a) + " 1long 2long 3long 4long 5long 6long 7long 8long") ; define listview content
    SetGadGetWidgetItemState(1, a, #PB_Tree_Selected) 
  Next
  SetGadGetWidgetState(1, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ;
  ListViewGadget_(2, 10, 30+150+150, 250, 120, #PB_ListView_MultiSelect)
  TextGadget(#PB_Any, 10,10+150+150, 250,20, "flag = MultiSelect")
  For a = 0 To 12
    AddGadgetItem (2, -1, "listview item " + Str(a)) ; define listview content
    SetGadGetWidgetItemState(2, a, #PB_Tree_Selected) 
  Next
  SetGadGetWidgetState(2, 5) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  ;}
  ;--------------
  
  ListViewWidget(270, 30, 250, 120) : SetWidgetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(0), -1, "listview item " + Str(a)) ; define listview content
    SetWidgetItemState(ID(0), a, #PB_Tree_Selected) 
  Next
  SetWidgetState(ID(0), 5) 
  SetWidgetState(ID(0), 7) 
  SetWidgetState(ID(0), 9) 
  
  ListViewWidget(270, 30+150, 250, 120, #PB_ListView_ClickSelect) : SetWidgetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(1), -1, "listview item " + Str(a) + " 1long 2long 3long 4long 5long 6long 7long 8long") ; define listview content
    If a%2
      SetWidgetItemState(ID(1), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetWidgetState(ID(1), 5) 
  SetWidgetState(ID(1), 7) 
  SetWidgetState(ID(1), 9) 
  
  ListViewWidget(270, 30+150+150, 250, 120, #PB_ListView_MultiSelect) : SetWidgetFrame( widget( ), 2)
  For a = 0 To 12
    AddItem (ID(2), -1, "listview item " + Str(a)) ; define listview content
    If a%2
      SetWidgetItemState(ID(2), a, #PB_Tree_Selected) 
    EndIf
  Next
  SetWidgetState(ID(2), 5) 
  SetWidgetState(ID(2), 7) 
  SetWidgetState(ID(2), 9) 
  
  TextWidget(270,10, 250,20, "flag = no")
  TextWidget(270,10+150, 250,20, "flag = ClickSelect")
  TextWidget(270,10+150+150, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    BindWidgetEvent(ID(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 174
; FirstLine = 149
; Folding = --
; EnableXP
; DPIAware