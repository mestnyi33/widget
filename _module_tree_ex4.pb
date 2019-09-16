IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_12.pb"
;XIncludeFile "_module_tree_10_2.pb"
;XIncludeFile "_module_tree_7_1_0.pb"

UseModule Tree
Global *w._s_widget, position =- 1
  
Procedure events_tree_widget()
  ;Debug " widget - "+*event\widget+" "+*event\type
  Protected EventGadget = *event\widget
  Protected EventType = *event\type
  Protected EventData = *event\data
  Protected EventItem = GetState(EventGadget)
  
  Select EventType
    Case #PB_EventType_Change
      ;Debug "change"
      position = GetState(*w)
      SetGadgetText(1, GetText(*w))
      
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 355, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  *w = GetGadgetData(Gadget(0, 10, 10, 160, 160))
  StringGadget(1, 200, 10, 100, 22, "")
  
  For a = 0 To 10
    AddItem (*w, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
    AddItem (*w, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
    AddItem(*w, -1, "Sub-Item 1", 0, 1)           ; These are on the 1st sublevel
    AddItem(*w, -1, "Sub-Item 2", 0, 1)
    AddItem(*w, -1, "Sub-Item 3", 0, 1)
    AddItem(*w, -1, "Sub-Item 4", 0, 1)
    AddItem (*w, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
  Next
  
  Bind(*w, @events_tree_widget())
    
  Repeat
    
    event = WaitWindowEvent()
    
    If event = #PB_Event_Gadget
      
      If EventGadget() = 1 And EventType() = #PB_EventType_Change
        ;Debug "change string"
        SetItemText(*w, position, GetGadgetText(1))
        redraw(*w)
      EndIf
      
    EndIf
    
  Until event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP