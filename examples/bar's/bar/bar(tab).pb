XIncludeFile "../../../widgets.pbi" : Uselib(widget)

Macro WidgetID( _index_ )
   GetWidget(_index_)
EndMacro

Procedure events_wbuttons()
  Select widgeteventtype()
    Case #PB_EventType_LeftClick
      Select Eventindex()
        Case 1 : RemoveItem(WidgetID(0), 1)
        Case 2 
          ;OpenList(WidgetID(1))
          AddItem(WidgetID(0), 1, "Sub-Panel 2 (add)")
          ;CloseList()
      EndSelect
  EndSelect
EndProcedure


If Open(0, 0, 0, 322 + 322, 220, "PanelGadget", #PB_Window_SizeGadget| #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  Tab(10,10, 600, 30)
  
  AddItem(WidgetID(0), -1, "Sub-Panel 1")
  AddItem(WidgetID(0), -1, "Sub-Panel 2")
  AddItem(WidgetID(0), -1, "Sub-Panel 3")
  
  Button(10, 145, 80, 24,"remove")
  Button(95, 145, 80, 24,"add")
  
  For i = 1 To 2
    Bind(WidgetID(i), @events_wbuttons())
  Next
  
  WaitClose()
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 16
; Folding = -
; EnableXP