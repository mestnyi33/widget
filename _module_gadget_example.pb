;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_gadget.pb"

Macro PB(Function)
  Function
EndMacro

#PB_Tree_Collapse = 16

Procedure events_tree_gadget()
  ;Debug " gadget - "+EventGadget()+" "+EventType()
  Static click
  Protected EventGadget = EventGadget()
  Protected EventType = EventType()
  Protected EventData = EventData()
  Protected EventItem = GetGadgetState(EventGadget)
  Protected State = GetGadgetItemState(EventGadget, EventItem)
  
  Select EventType
      ;     Case #PB_EventType_Focus    : Debug "gadget focus item = " + EventItem +" data "+ EventData
      ;     Case #PB_EventType_LostFocus    : Debug "gadget lfocus item = " + EventItem +" data "+ EventData
    Case #PB_EventType_LeftClick : Debug "gadget lclick item = " + EventItem +" data "+ EventData +" State "+ State
      If EventGadget = 3
        click ! 1
        If click
          SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
        Else
          SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
        EndIf
      EndIf
      If EventGadget = 4
        RemoveGadgetItem(1, GetGadgetState(1))
      EndIf
      If EventGadget = 5
        RemoveGadgetItem(1, 1)
      EndIf
      
    Case #PB_EventType_LeftDoubleClick : Debug "gadget ldclick item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_DragStart : Debug "gadget sdrag item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_RightClick : Debug "gadget rclick item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_RightDoubleClick : Debug "gadget rdclick item = " + EventItem +" data "+ EventData +" State "+ State
  EndSelect 
  
  If EventType = #PB_EventType_LeftClick
    If State & #PB_Tree_Selected
      Debug "Selected "+#PB_Tree_Selected
    EndIf
    If State & #PB_Tree_Expanded
      Debug "Expanded "+#PB_Tree_Expanded
    EndIf
    If State & #PB_Tree_Collapsed
      Debug "Collapsed "+#PB_Tree_Collapsed
    EndIf
    If State & #PB_Tree_Checked
      Debug "Checked "+#PB_Tree_Checked
    EndIf
    If State & #PB_Tree_Inbetween
      Debug "Inbetween "+#PB_Tree_Inbetween
    EndIf
  EndIf

EndProcedure  

If OpenWindow(0, 0, 0, 355, 210, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(0, 10, 10, 160, 160)                                         ; TreeGadget standard
  TreeGadget(1, 180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_Collapse | #PB_Tree_AlwaysShowSelection)    ; TreeGadget with Checkboxes + NoLines
  
  For ID = 0 To 1
    For a = 0 To 10
      AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)           ; These are on the 1st sublevel
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem (ID, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
    Next
    
    Debug " gadget "+ ID +" count items "+ CountGadgetItems(ID) +" "+ GadgetType(ID)
  Next
  
  ButtonGadget(3, 10, 180, 100, 24, "set state Item")
  BindGadgetEvent(3, @events_tree_gadget())
  ButtonGadget(4, 120, 180, 100, 24, "remove Item")
  BindGadgetEvent(4, @events_tree_gadget())
  ButtonGadget(5, 230, 180, 100, 24, "remove Item")
  BindGadgetEvent(5, @events_tree_gadget())
  
  BindGadgetEvent(0, @events_tree_gadget())
  BindGadgetEvent(1, @events_tree_gadget())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP