XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib(widget)
Global *container._s_WIDGET

Procedure events_widgets()
   If WidgetEventType() = #__event_LeftClick
      Select GetText(EventWidget())
         Case "Page 1"
            SetState(*container, GetData(EventWidget()))
         Case "Page 2"
            SetState(*container, GetData(EventWidget()))
      EndSelect
   EndIf
EndProcedure

Procedure AddButtons( item, x,y,text.s )
   Button(x, y, 80, 24, text)
   SetData(widget( ), item )
   Bind(widget(), @events_widgets() )
EndProcedure

;\\
If Open(0, 0, 0, 300, 200, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  *container = Panel(8, 8, 284, 184-32, #__flag_nobuttons)
  AddItem( *container, -1, "Panel 0")
  ;
  AddItem( *container, -1, "Panel 1")
  Define h = height( *container, #__c_inner )
  
  Button(10, h-34*2, 80, 24,"remove")
  Button(10, h-34*3, 80, 24,"add")
  Button(10, h-34*1, 80, 24,"clear")
  ;
  AddItem ( *container, -1,"Panel 2")
  Button(10, 10, 80, 24,"Button 3")
  Button(95, 10, 80, 24,"Button 4")
  ;
  CloseList( )
  
  ;\\ 
  AddButtons(1, 300-196, 200-32,"Page 1")
  AddButtons(2, 300-88, 200-32,"Page 2")
  ;
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 12
; Folding = -
; EnableXP