XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib(widget)
Global *container._s_WIDGET

Procedure events_widgets()
   If WidgetEventType() = #__event_LeftClick
      Select GetText(EventWidget())
         Case "Page 1"
            SetState(*container, 1 )
         Case "Page 2"
            SetState(*container, 2 )
      EndSelect
   EndIf
EndProcedure

; Shows using of several panels...
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
  
  Button(300-196, 200-32, 80, 24,"Page 1")
  Button(300-88, 200-32, 80, 24,"Page 2")
  
  Bind(root(), @events_widgets() )
  ;
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 20
; FirstLine = 2
; Folding = -
; EnableXP