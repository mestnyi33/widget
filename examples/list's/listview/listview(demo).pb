; keyboard events
; flag = none
; up/down selected item and post event change

; flag = multiselect
; up/down selected item and post event change
; shift & up/down selected items and post event change

; flag = clickselect
; up/down entered item
; spake selected item and post event change

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

XIncludeFile "../../../widgets.pbi" 

UseWidgets( )
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  ImportC ""
    RevealDataBrowserItem(ControlRef.L, ItemID.L, PropertyID.L, RevealOptions.L)
  EndImport
CompilerEndIf

; Procedure GoToListItem(gad,i)
;   SetGadGetWidgetState(gad,-1) ; De-select any selected items.
;   SetGadGetWidgetState(gad,i-1) ; Now select the wanted item.
;   SendMessage_(GadgetID(gad),#LVM_ENSUREVISIBLE,i-1,0) ; And scroll to it.
; EndProcedure
Procedure scroll_to_point(Gadget,Item)
   ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=60533&view=unread#unread
   CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      gtk_tree_view_scroll_to_point_(GadgetID(Gadget), -1, (Item - 1) * 22 - 20)
    CompilerCase #PB_OS_MacOS
      RevealDataBrowserItem(GadgetID(Gadget), Item, 0, 1)
      ;CocoaMessage(0, GadgetID(Gadget), "scrollRowToVisible:", item-1)
    CompilerCase #PB_OS_Windows
      SendMessage_(GadgetID(Gadget), #LVM_ENSUREVISIBLE, (Item - 1), #True)
  CompilerEndSelect
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

Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
  Protected g = ListViewGadget(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 19
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    CocoaMessage(0, GadgetID(gadget), "setUsesAlternatingRowBackgroundColors:", #YES)
    
    If gadget <> 1
      CocoaMessage(0, GadgetID(gadget), "sizeLastColumnToFit")
    EndIf
    
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

If OpenRoot(1, 0, 0, 270+270+270, 160+160, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget_(0, 10, 30, 250, 120)
  For a = 0 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadGetWidgetState(0, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(0, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget_(1, 10+270, 30, 250, 120, #PB_ListView_ClickSelect)
  For a = 0 To 12
    AddGadgetItem (1, -1, "Item " + Str(a) + " of the Listview long long long long long") ; define listview content
  Next
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(1, 9) ; set (beginning with 0) the tenth item as the active one
  
  ListViewGadget_(2, 10+270+270, 30, 250, 120, #PB_ListView_MultiSelect)
  For a = 0 To 12
    AddGadgetItem (2, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadGetWidgetState(2, 7) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 8) ; set (beginning with 0) the tenth item as the active one
  SetGadGetWidgetState(2, 9) ; set (beginning with 0) the tenth item as the active one
  
  TextGadget(#PB_Any, 10,10, 250,20, "flag = no")
  TextGadget(#PB_Any, 10+270,10, 250,20, "flag = ClickSelect")
  TextGadget(#PB_Any, 10+270+270,10, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  
  ;\\
  ListViewWidget(10, 190, 250, 120)
  For a = 0 To 12
    AddItem (ID(0), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetWidgetState(ID(0), 5) 
  SetWidgetState(ID(0), 7) 
  SetWidgetState(ID(0), 9) 
  ;SetWidgetItemState(ID(0), 5, 1) 
  
  ListViewWidget(10+270, 190, 250, 120, #__flag_RowClickSelect)
  For a = 0 To 12
    AddItem (ID(1), -1, "Item " + Str(a) + " of the Listview long long long long long") ; define listview content
  Next
  SetWidgetState(ID(1), 5) 
  SetWidgetState(ID(1), 7) 
  SetWidgetState(ID(1), 9) 
  
  ListViewWidget(10+270+270, 190, 250, 120, #__flag_RowMultiSelect)
  For a = 0 To 12
    AddItem (ID(2), -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetWidgetState(ID(2), 5) 
  SetWidgetState(ID(2), 7) 
  SetWidgetState(ID(2), 9) 
  
  ;   TextWidget(10,170, 250,20, "flag = no")
  ;   TextWidget(10+270,170, 250,20, "flag = ClickSelect")
  ;   TextWidget(10+270+270,170, 250,20, "flag = MultiSelect")
  ;   TextGadget(#PB_Any, 10,170, 250,20, "flag = no")
  ;   TextGadget(#PB_Any, 10+270,170, 250,20, "flag = ClickSelect")
  ;   TextGadget(#PB_Any, 10+270+270,170, 250,20, "flag = MultiSelect")
  
  For i = 0 To 2
    BindWidgetEvent(ID(i), @events_widgets())
  Next
  
  SetActiveWidget(ID(1))
  SetActiveGadget(1)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 195
; FirstLine = 170
; Folding = --
; EnableXP
; DPIAware