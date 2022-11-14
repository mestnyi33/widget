XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_wbuttons()
  Select widgetevent()
    Case #PB_EventType_LeftClick
      Select Eventindex()
        Case 1 : RemoveItem(GetWidget(0), 1)
        Case 2 
          ;OpenList(GetWidget(1))
          AddItem(GetWidget(0), 1, "Sub-Panel 2 (add)")
          ;CloseList()
      EndSelect
  EndSelect
EndProcedure


If Open(OpenWindow(#PB_Any, 0, 0, 322 + 322, 220, "PanelGadget", #PB_Window_SizeGadget| #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  Tab(0,0, 100, 30,0,0)
  SetAlignmentFlag(GetWidget(0), #__flag_AutoSize|#__align_top)
  
  AddItem(GetWidget(0), -1, "Sub-Panel 1")
  AddItem(GetWidget(0), -1, "Sub-Panel 2")
  AddItem(GetWidget(0), -1, "Sub-Panel 3")
  
  Button(10, 145, 80, 24,"remove")
  Button(95, 145, 80, 24,"add")
  
  For i = 1 To 2
    Bind(GetWidget(i), @events_wbuttons())
  Next
  
  WaitClose()
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP