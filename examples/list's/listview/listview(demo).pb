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

; OS
; windows 
; multi-select 
;   mouse
;      button down and mouse-moved 
;   keyboard
;      shift and up/down-key
; reset then button down no-selected item
; не приятное поведение когда выбран один итем при нажатии на нем
; и попытке выделить еще несколько итемов не происходит выделение,
; так как при нажатии на выделеном итеме не сбрасываются выделение

;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

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
  Select WidgetEventType( )
      ;     Case #PB_EventType_Up
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Up "+GetState(EventWidget( ))
      ;       
      ;     Case #PB_EventType_Down
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget Down "+GetState(EventWidget( ))
      ;       
      ;     Case #PB_EventType_ScrollChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget ScrollChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;       
      ;     Case #PB_EventType_StatusChange
      ;       Debug  ""+GetIndex(EventWidget( ))+" - widget StatusChange "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      ;       
    Case #PB_EventType_DragStart
      Debug  ""+GetIndex(EventWidget( ))+" - widget DragStart "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(EventWidget( ))+" - widget Change "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget LeftDoubleClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(EventWidget( ))+" - widget RightClick "+GetState(EventWidget( )) +" "+ WidgetEventItem( )
      
  EndSelect
EndProcedure

Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
  Protected g = ListViewGadget(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 19
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 270+270+270, 160+160, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  ListViewGadget_(0, 10, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget_(1, 10+270, 30, 250, 120, #PB_ListView_ClickSelect)
  For a = 0 To 12
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Listview long long long long long") ; define listview content
  Next
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget_(2, 10+270+270, 30, 250, 120, #PB_ListView_MultiSelect)
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
  
  
  ;\\
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
    AddItem (GetWidget(1), -1, "Item " + Str(a) + " of the Listview long long long long long") ; define listview content
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
  
  ;   Text(10,170, 250,20, "flag = no")
  ;   Text(10+270,170, 250,20, "flag = ClickSelect")
  ;   Text(10+270+270,170, 250,20, "flag = MultiSelect")
  ;   TextGadget(#PB_Any, 10,170, 250,20, "flag = no")
  ;   TextGadget(#PB_Any, 10+270,170, 250,20, "flag = ClickSelect")
  ;   TextGadget(#PB_Any, 10+270+270,170, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP