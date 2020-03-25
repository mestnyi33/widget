XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_wbuttons()
  Select *event\type
    Case #PB_EventType_LeftClick
      Select (*event\widget\index - 1)
        Case 1 : RemoveItem(GetWidget(0), 1)
        Case 2 
          ;OpenList(GetWidget(1))
          AddItem(GetWidget(0), 1, "Sub-Panel 2 (add)")
          ;CloseList()
      EndSelect
  EndSelect
EndProcedure


If OpenWindow(0, 0, 0, 322 + 322, 220, "PanelGadget", #PB_Window_SizeGadget| #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Open(0)
  Tab(0,0, 100, 30,0,0,0)
  SetAlignment(GetWidget(0), #__flag_AutoSize|#__align_top)
  
  AddItem(GetWidget(0), -1, "Sub-Panel 1")
  AddItem(GetWidget(0), -1, "Sub-Panel 2")
  AddItem(GetWidget(0), -1, "Sub-Panel 3")
  
  Button(10, 145, 80, 24,"remove")
  Button(95, 145, 80, 24,"add")
  
  For i = 1 To 2
    Bind(GetWidget(i), @events_wbuttons())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf



; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 16
; FirstLine = 6
; Folding = -
; EnableXP