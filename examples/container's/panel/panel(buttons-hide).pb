; 1750 commit Ok
XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )
Global *container._s_WIDGET

Procedure event_button_click()
   Define *g, *panel = WidgetEventData()
   *g = GetItemData( *panel, GetState( *panel))
   SetState(*panel, GetData(EventWidget()))
   
   If *g
      Disable( *g, #False)
   EndIf
   Disable(EventWidget(), #True)
EndProcedure

Procedure event_panel_change( )
   Debug ""+ WidgetEventItem() +" change "+ GetItemData(widget(), WidgetEventItem())
EndProcedure

Procedure AddButtons( item, X,Y,Text.s, *data )
   Button(X, Y, 80, 24, Text)
   SetData(widget( ), item )
   If *data
      SetItemData(*data, item, widget())
      If item = GetState( *data)
         Post( widget( ), #__event_LeftClick )
      EndIf
   EndIf
   Bind(widget(), @event_button_click(), #__event_LeftClick, #PB_All, *data )
EndProcedure

;\\
If Open(0, 0, 0, 300, 200, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *container = Panel(8, 8, 284, 184-32, #__flag_nobuttons)
  AddItem( *container, -1, "Panel 0")
  Text( 10,10,100,20,"Page 0")
  ;
  AddItem( *container, -1, "Panel 1")
  Define h = Height( *container, #__c_inner )
  Text( 10,10,100,20,"Page 1")
  
  Button(10, h-34*2, 80, 24,"remove")
  Button(10, h-34*3, 80, 24,"add")
  Button(10, h-34*1, 80, 24,"clear")
  ;
  AddItem ( *container, -1,"Panel 2")
  Text( 10,10,100,20,"Page 2")
  Button(10, 50, 80, 24,"Button 3")
  Button(95, 50, 80, 24,"Button 4")
  ;
  CloseList( )
  Bind(*container, @event_panel_change(), #__event_Change )
  
  ; TEST
  ; SetState( *container, 1)
  
  ;\\ 
  AddButtons(0, 300-285, 200-32,"Page 0", *container) 
  AddButtons(1, 300-190, 200-32,"Page 1", *container)
  AddButtons(2, 300-95, 200-32,"Page 2", *container)
  
  ;
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 8
; FirstLine = 2
; Folding = --
; EnableXP