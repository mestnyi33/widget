XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib(widget)

Procedure events_widgets()
   If WidgetEventType() = #__event_LeftClick
      Select GetText(EventWidget())
         Case "Page 1"
            SetState(GetData(EventWidget()), 1 )
         Case "Page 2"
            SetState(GetData(EventWidget()), 2 )
      EndSelect
   EndIf
EndProcedure

Procedure AddButtons( *this, x,y,text.s )
   Button(x, y, 80, 24, text)
   SetData(widget( ), *this )
   Bind(widget(), @events_widgets() )
EndProcedure

;\\
If Open(0, 0, 0, 300, 200, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Define *container._s_WIDGET = Panel(8, 8, 284, 184-32, #__flag_nobuttons)
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
  AddButtons(*container, 300-196, 200-32,"Page 1")
  AddButtons(*container, 300-88, 200-32,"Page 2")
  ;
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 36
; Folding = -
; EnableXP