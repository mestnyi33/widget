; alt & up/down first/last visible scroll
; control & alt & up/down top/bottom scroll 
; up/down top/bottom scroll and selected and post event change
; fn  & up/down first/last visible scroll and selected and post event change
; left/right collapsed\expanded parent item
; spake check/uncheck checkboxes

; flag\multiselect 
; flag\checkboxses
; flag\check

 XIncludeFile "../../widgets.pbi" 
; XIncludeFile "../empty.pb"
 Uselib(widget)

Procedure events_gadgets()
  Select EventType()
    Case #PB_EventType_DragStart
      Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
      
  EndSelect
EndProcedure

Procedure events_widgets()
  Select *event\type
     Case #PB_EventType_DragStart
      Debug  ""+GetIndex(*event\widget)+" - widget DragStart "+GetState(*event\widget) +" "+ *event\item
      
    Case #PB_EventType_Up
      Debug  ""+GetIndex(*event\widget)+" - widget Up "+GetState(*event\widget)
      
    Case #PB_EventType_Down
      Debug  ""+GetIndex(*event\widget)+" - widget Down "+GetState(*event\widget)
      
;     Case #PB_EventType_ScrollChange
;       Debug  ""+GetIndex(*event\widget)+" - widget ScrollChange "+GetState(*event\widget)
;       
;     Case #PB_EventType_StatusChange
;       Debug  ""+GetIndex(*event\widget)+" - widget StatusChange "+GetState(*event\widget)
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(*event\widget)+" - widget Change "+GetState(*event\widget)
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(*event\widget)+" - widget LeftClick "+GetState(*event\widget)
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(*event\widget)+" - widget LeftDoubleClick "+GetState(*event\widget)
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(*event\widget)+" - widget RightClick "+GetState(*event\widget)
      
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 270+270+270, 180+180, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  TreeGadget(0, 10, 10, 160, 160)                                         ; TreeGadget standard
  TreeGadget(1, 180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines); TreeGadget with Checkboxes + NoLines
  
  For ID = 0 To 1
    For a = 0 To 10
      AddGadgetItem(ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddGadgetItem(ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)           ; These are on the 1st sublevel
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem(ID, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
    Next
    
    BindGadgetEvent(id, @events_gadgets())
  Next
  
  SetGadgetState(1, 1)
  
  ;--------------
  
  Tree(10, 10+180, 160, 160, #__Tree_Collapsed)                                         ; TreeGadget standard
  Tree(180, 10+180, 160, 160, #__Tree_CheckBoxes | #__Tree_NoLines | #__Tree_Collapsed) ; TreeGadget with Checkboxes + NoLines
  
  For ID = 0 To 1
    For a = 0 To 10
      AddItem(GetWidget(ID), -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddItem(GetWidget(ID), -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddItem(GetWidget(ID), -1, "Sub-Item 1", 0, 1)          ; These are on the 1st sublevel
      AddItem(GetWidget(ID), -1, "Sub-Item 2", 0, 1)
      AddItem(GetWidget(ID), -1, "Sub-Item 3", 0, 1)
      AddItem(GetWidget(ID), -1, "Sub-Item 4", 0, 1)
      AddItem(GetWidget(ID), -1, "File "+Str(a), 0, 0) ; sublevel 0 again
    Next
    
    Bind(GetWidget(ID), @events_widgets())
  Next
  
  SetState(GetWidget(1), 1)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 7
; EnableXP