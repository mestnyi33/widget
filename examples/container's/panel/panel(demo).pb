XIncludeFile "../../../widgets.pbi" : UseWidgets( )
; #NSTopTabsBezelBorder    = 0
; #NSLeftTabsBezelBorder   = 1
; #NSBottomTabsBezelBorder = 2
; #NSRightTabsBezelBorder  = 3
; CocoaMessage(0, GadgetID( Panel ), "setTabViewType:", #NSTopTabsBezelBorder ) ; положение итемов
            
; - AddItem(): Add a panel. 
; - RemoveItem(): Remove a panel. 
; - CountItems(): Count the number of panels. 
; - ClearItems(): Remove all panels. 
; - GetItemTextWidget(): Retrieve the text of the specified item. 
; - SetItemTextWidget(): Change the text of the specified item. 
; - SetWidgetItemImage(): Change the image of the specified item. ;;;;;;;;;;;(Not supported on OS X) 
; - GetItemData(): Retrieve the value associated With the specified item. 
; - SetItemData(): Associate a value With the specified item. 
; 
; - SetState(): Change the active panel. 
; - GetState(): Get the index of the current panel. 
; - GetAttribute(): With one of the following attributes: (there must be at least 1 item For this To work) 

Procedure events_gadgets()
  Debug ""+EventGadget() + " - gadget  event - " +EventType()+ "  item - " +GetGadgetState(EventGadget())
EndProcedure

Procedure events_widgets()
  If WidgetEvent( ) <> #__event_MouseMove And WidgetEvent( ) <> #__event_Draw
    Debug ""+Str(IDWidget(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ "  item - " +WidgetEventItem( ) ; GetState(EventWidget( )) ; 
  EndIf
EndProcedure

Procedure events_gbuttons()
  Select EventType()
    Case #PB_EventType_LeftClick
      Select EventGadget()
        Case 2 
          If CountGadgetItems(1) > 1
            RemoveGadgetItem(1, 1)
            Debug ""+CountGadgetItems(1) +" - count gadget items"
          EndIf
          
        Case 4 : ClearGadgetItems(1)
          Debug ""+CountGadgetItems(1) +" - count gadget items"
          
        Case 3 
          OpenGadgetList(1)
          AddGadgetItem(1, 1, "Sub 2 (add)")
          If CountGadgetItems(1) > 1
            SetGadgetItemTextWidget(1, 1, "Sub 2 (add&set)")
            Debug GetGadgetItemTextWidget(1, 1) + " - get item text"
          Else
            SetGadgetItemTextWidget(1, 0, "Sub 1 (add&set)")
            Debug GetGadgetItemTextWidget(1, 0) + " - get item text"
          EndIf
          CloseGadgetList()
      EndSelect
  EndSelect
EndProcedure

Procedure events_wbuttons()
  Select WidgetEvent( )
    Case #__event_LeftClick
      Select IDWidget( EventWidget( ) )
        Case 2 
          If CountItems( WidgetID(1)) > 1
            RemoveItem( WidgetID(1), 1)
            Debug ""+CountItems( WidgetID(1)) +" - count widget items"
          EndIf
          
        Case 4 : ClearItems( WidgetID(1))
          Debug ""+CountItems( WidgetID(1)) +" - count widget items"
          
        Case 3 
          ;OpenWidgetList( WidgetID(1))
          AddItem( WidgetID(1), 1, "Sub 2 (add)")
          If CountItems( WidgetID(1)) > 1
            SetItemTextWidget( WidgetID(1), 1, "Sub 2 (add&set)")
            Debug GetItemTextWidget( WidgetID(1), 1) + " - get item text"
          Else
            SetItemTextWidget( WidgetID(1), 0, "Sub 1 (add&set)")
            Debug GetItemTextWidget( WidgetID(1), 0) + " - get item text"
          EndIf
          ;CloseWidgetList()
      EndSelect
      
  EndSelect
EndProcedure

; Shows using of several panels...
If OpenWindow(0, 0, 0, 322 + 322, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  PanelGadget (0, 8, 8, 300, 200)
  Define h = 200;GetGadgetAttribute(0, #PB_Panel_ItemHeight )
  Define w = 300;GetGadgetAttribute(0, #PB_Panel_ItemWidth )
  
  AddGadgetItem(0, -1, "Panel 1")
  PanelGadget (1, 10, 10, w-20, h-20-34*3)
  AddGadgetItem(1, -1, "Sub 1")
  AddGadgetItem(1, -1, "Sub 2")
  AddGadgetItem(1, -1, "Sub 3")
  AddGadgetItem(1, -1, "Sub 4")
  AddGadgetItem(1, -1, "Sub 5")
  AddGadgetItem(1, -1, "Sub 6")
  AddGadgetItem(1, -1, "Sub 7")
  AddGadgetItem(1, -1, "Sub 8")
  AddGadgetItem(1, -1, "Sub 9")
  SetGadgetState(1, 5)
  CloseGadgetList()
  
  ButtonGadget(2, 10, h-34*2, 80, 24,"remove")
  ButtonGadget(3, 10, h-34*3, 80, 24,"add")
  ButtonGadget(4, 10, h-34*1, 80, 24,"clear")
  
  AddGadgetItem (0, -1,"Panel 2")
  ButtonGadget(5, 10, 15, 80, 24,"Button 3")
  ButtonGadget(6, 95, 15, 80, 24,"Button 4")
  CloseGadgetList()
  
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  For i = 2 To 4
    BindGadgetEvent(i, @events_gbuttons())
  Next
  
  Debug ""+CountGadgetItems(1) +" - count gadget items"
  
  OpenRootWidget(0, 322, 0, 322, 220)
  PanelWidget(8, 8, 300, 200)
  Define h = WidgetHeight( WidgetID(0), #__c_inner )
  Define w = WidgetWidth( WidgetID(0), #__c_inner )
  
  AddItem( WidgetID(0), -1, "Panel 1")
  PanelWidget(10, 10, w-20, h-20-34*3)
  AddItem( WidgetID(1), -1, "Sub 1")
  AddItem( WidgetID(1), -1, "Sub 2")
  AddItem( WidgetID(1), -1, "Sub 3")
  AddItem( WidgetID(1), -1, "Sub 4")
  AddItem( WidgetID(1), -1, "Sub 5")
  AddItem( WidgetID(1), -1, "Sub 6")
  AddItem( WidgetID(1), -1, "Sub 7")
  AddItem( WidgetID(1), -1, "Sub 8")
  AddItem( WidgetID(1), -1, "Sub 9")
  SetState( WidgetID(1), 5)
  CloseWidgetList( )
  
  ButtonWidget(10, h-34*2, 80, 24,"remove")
  ButtonWidget(10, h-34*3, 80, 24,"add")
  ButtonWidget(10, h-34*1, 80, 24,"clear")
  
  AddItem ( WidgetID(0), -1,"Panel 2")
  ButtonWidget(10, 10, 80, 24,"Button 3")
  ButtonWidget(95, 10, 80, 24,"Button 4")
  CloseWidgetList()
  
  For i = 0 To 1
    BindWidgetEvent( WidgetID(i), @events_widgets())
  Next
  For i = 2 To 4
    BindWidgetEvent( WidgetID(i), @events_wbuttons())
  Next
  
  
  ;SetState( WidgetID(1), 6)
  
  Debug ""+CountItems( WidgetID(1)) +" - count widget items"
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 127
; FirstLine = 108
; Folding = ---
; Optimizer
; EnableXP
; DPIAware