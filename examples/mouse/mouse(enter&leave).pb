; #__from_mouse_state = 1

XIncludeFile "../../widgets.pbi" 
Uselib(widget)

Define editable = #__flag_anchorsgadget

Procedure events_widgets()
  Protected repaint
  
  Select *event\type
    Case #PB_EventType_MouseEnter : *event\widget\color\back = $ff0000ff : repaint = 1
    Case #PB_EventType_MouseLeave : *event\widget\color\back = $ff00ff00 : repaint = 1
  EndSelect
  
  If repaint
     ; ReDraw(*event\widget\root)
     Post(#PB_EventType_Repaint, *event\widget\root)
  EndIf
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 220, 220, "enter&leave demo",
                   #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  SetData(Container(20, 20, 180, 180, editable), 1)
  SetData(Container(70, 10, 70, 180, #__Flag_NoGadget|editable), 2) 
  SetData(Container(40, 20, 180, 180, editable), 3)
  SetData(Container(20, 20, 180, 180, editable), 4)
  
  SetData(Container(5, 30, 180, 30, #__Flag_NoGadget|editable), 5) 
  SetData(Container(5, 45, 180, 30, #__Flag_NoGadget|editable), 6) 
  SetData(Container(5, 60, 180, 30, #__Flag_NoGadget|editable), 7) 
  
  SetData(Splitter(5, 80, 180, 50, 
                   Container(0,0,0,0, #__Flag_NoGadget|editable), 
                   Container(0,0,0,0, #__Flag_NoGadget|editable),
                   #PB_Splitter_Vertical|editable), 8) 
  
  CloseList()
  CloseList()
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadget|editable), 12) 
  SetData(Container(10, 20, 70, 30, #__Flag_NoGadget|editable), 13) 
  SetData(Container(10, 30, 170, 130, #__Flag_NoGadget|editable), 14) 
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadget|editable), 12) 
  CloseList()
  CloseList()
  CloseList()
  CloseList()
  
  
  Bind(#PB_All, @events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP