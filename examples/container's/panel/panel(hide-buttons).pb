XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )
Global *container._s_WIDGET

Procedure events_widgets()
   If WidgetEvent() = #__event_LeftClick
      SetState(*container, GetData(EventWidget()))
   EndIf
EndProcedure

Procedure AddButtons( item, x,y,Text.s )
   ButtonWidget(x, y, 80, 24, Text)
   SetData(widget( ), item )
   Bind(widget(), @events_widgets() )
EndProcedure

;\\
If Open(0, 0, 0, 300, 200, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  *container = PanelWidget(8, 8, 284, 184-32, #__flag_nobuttons)
  AddItem( *container, -1, "Panel 0")
  TextWidget( 10,10,100,20,"Page 0")
  ;
  AddItem( *container, -1, "Panel 1")
  Define h = WidgetHeight( *container, #__c_inner )
  TextWidget( 10,10,100,20,"Page 1")
  
  ButtonWidget(10, h-34*2, 80, 24,"remove")
  ButtonWidget(10, h-34*3, 80, 24,"add")
  ButtonWidget(10, h-34*1, 80, 24,"clear")
  ;
  AddItem ( *container, -1,"Panel 2")
  TextWidget( 10,10,100,20,"Page 2")
  ButtonWidget(10, 50, 80, 24,"Button 3")
  ButtonWidget(95, 50, 80, 24,"Button 4")
  ;
  CloseList( )
  
  ;\\ 
  AddButtons(1, 300-196, 200-32,"Page 1")
  AddButtons(2, 300-88, 200-32,"Page 2")
  ;
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 25
; FirstLine = 19
; Folding = -
; EnableXP