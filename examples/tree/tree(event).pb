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
   Select Event()
    Case #PB_Event_GadgetDrop
      Debug "drop - "+EventDropText()

    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_DragStart
          Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
          
          DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
        
        Case #PB_EventType_Change
          Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_LeftClick
          Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_LeftDoubleClick
          Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
          
        Case #PB_EventType_RightClick
          Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
          
      EndSelect
  EndSelect
EndProcedure

Procedure events_widgets()
  Select this()\event
     Case #PB_EventType_DragStart
      Debug  ""+GetIndex(this()\widget)+" - widget DragStart "+GetState(this()\widget) +" "+ this()\item
      
    Case #PB_EventType_Up
      Debug  ""+GetIndex(this()\widget)+" - widget Up "+GetState(this()\widget)
      
    Case #PB_EventType_Down
      Debug  ""+GetIndex(this()\widget)+" - widget Down "+GetState(this()\widget)
      
;     Case #PB_EventType_ScrollChange
;       Debug  ""+GetIndex(this()\widget)+" - widget ScrollChange "+GetState(this()\widget)
;       
;     Case #PB_EventType_StatusChange
;       Debug  ""+GetIndex(this()\widget)+" - widget StatusChange "+GetState(this()\widget)
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(this()\widget)+" - widget Change "+GetState(this()\widget)
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(this()\widget)+" - widget LeftClick "+GetState(this()\widget)
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(this()\widget)+" - widget LeftDoubleClick "+GetState(this()\widget)
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(this()\widget)+" - widget RightClick "+GetState(this()\widget)
      
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
    EnableGadgetDrop(id, #PB_Drop_Text, #PB_Drag_Copy)
  Next
  
  BindEvent(#PB_Event_GadgetDrop, @events_gadgets())
 
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
; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 18
; Folding = --
; EnableXP