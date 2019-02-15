; Windows 
; Tree
; Нажал итем выделился визуально, переместил курсор потерял фокус выделение.
; Нажал на месте отпустил первый раз ->> change/leftclick, последующие ->> leftclick (на одном и тоже)
; Нажал переместил первый раз ->> change/dragstart, последующие ->> dragstart (на одном и тоже)
;
; ListView
; Нажал итем выделился визуально, переместил курсор фокус осталя.
; Нажал на месте отпустил первый раз ->> leftclick, последующие ->> leftclick (на одном и тоже)
; Нажал переместил первый раз ->> dragstart, последующие ->> dragstart (на одном и тоже)
; 
; Mac os 
; Tree
; Нажал итем выделился визуально, переместил курсор фокус перемещается за ним.
; Нажал на месте отпустил первый раз ->> change/leftclick, последующие ->> leftclick (на одном и тоже)
;
; ListView
; Нажал итем выделился визуально, переместил курсор фокус перемещается за ним.
; Нажал на месте отпустил первый раз ->> leftclick, последующие ->> leftclick (на одном и тоже)
;
; Linux 
; Tree
; Нажал итем выделился визуально, переместил курсор фокус осталя.
; Нажал на месте первый раз ->> change
; Нажал на месте отпустил первый раз ->> leftclick, последующие ->> leftclick (на одном и тоже)
; Нажал переместил первый раз ->> dragstart, последующие ->> dragstart (на одном и тоже)
;
; ListView
; Нажал итем выделился визуально, переместил курсор фокус осталя.
; Нажал на месте отпустил первый раз ->> leftclick, последующие ->> leftclick (на одном и тоже)
; Нажал на месте отпустил первый раз ->> leftclick, последующие ->> leftclick (на одном и тоже)
; Нажал переместил первый раз ->> dragstart, последующие ->> dragstart (на одном и тоже)
; 

Procedure Gadgets_Events()
  Debug ""+EventGadget() +" "+ EventType()
EndProcedure



If OpenWindow(0, 0, 0, 1030, 680, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TreeGadget(0, 10, 10, 160, 160, #PB_Tree_AlwaysShowSelection)                                         
  TreeGadget(1, 10+170, 10, 160, 160, #PB_Tree_CheckBoxes)  
  TreeGadget(2, 10+170*2, 10, 160, 160, #PB_Tree_NoLines)
  TreeGadget(3, 10+170*3, 10, 160, 160, #PB_Tree_NoButtons)
  TreeGadget(4, 10+170*4, 10, 160, 160, #PB_Tree_ThreeState)
  TreeGadget(5, 10+170*5, 10, 160, 160, #PB_Tree_NoLines|#PB_Tree_NoButtons)
  
  For ID = 0 To 5
    For a = 0 To 5
      AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0)
      AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)           
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem (ID, -1, "File "+Str(a), 0, 0) 
    Next
    
    BindGadgetEvent(ID, @Gadgets_Events())
  Next
  
  ListViewGadget(10, 10, 10+170, 160, 160) 
  ListViewGadget(11, 10+170, 10+170, 160, 160, #PB_ListView_ClickSelect) : AddGadgetItem (11, -1, "ClickSelect", 0, 0)
  ListViewGadget(12, 10+170*2, 10+170, 160, 160, #PB_ListView_MultiSelect) : AddGadgetItem (12, -1, "MultiSelect", 0, 0)
  ListViewGadget(13, 10+170*3, 10+170, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines)
  ListViewGadget(14, 10+170*4, 10+170, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines)
  ListViewGadget(15, 10+170*5, 10+170, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines)
  
  For ID = 10 To 15
    For a = 1 To 5
      AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0) 
      AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)          
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem (ID, -1, "File "+Str(a), 0, 0) 
    Next
    
     BindGadgetEvent(ID, @Gadgets_Events())
 Next
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP