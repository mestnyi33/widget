;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_gadget.pb"

UseModule Gadget

Macro PB(Function)
  Function
EndMacro

#PB_Tree_Collapse = 16
UsePNGImageDecoder()
  
If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") 
  End
  EndIf
  
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
    Case #PB_EventType_LeftClick : Debug "gadget " +EventGadget+ " lclick item = " + EventItem +" data "+ EventData +" State "+ State
      If EventGadget = 3
        click ! 1
        If click
          SetGadgetItemState(0, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
          SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
        Else
          SetGadgetItemState(0, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
          SetGadgetItemState(1, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
        EndIf
      EndIf
      
      If EventGadget = 4
        AddGadgetItem(0, 1, "added item "+Str(CountGadgetItems(0)))
        AddGadgetItem(1, 1, "added item "+Str(CountGadgetItems(1)))
      EndIf
      If EventGadget = 5
        RemoveGadgetItem(0, 1)
        RemoveGadgetItem(1, 1)
      EndIf
      If EventGadget = 6
        SetGadgetItemImage(0, GetGadgetState(0), ImageID(0))
        SetGadgetItemImage(1, GetGadgetState(1), ImageID(0))
      EndIf
      If EventGadget = 7
        SetGadgetState(0, 0)
        SetGadgetState(1, 0)
      EndIf
      If EventGadget = 8
        SetGadgetState(0, -1)
        SetGadgetState(1, -1)
      EndIf
      If EventGadget = 9
        SetGadgetState(0, CountGadgetItems(0)-1)
        SetGadgetState(1, CountGadgetItems(1)-1)
      EndIf
      If EventGadget = 10
        ClearGadgetItems(0)
        ClearGadgetItems(1)
      EndIf
      
     ; Tree::Redraw(GetGadgetData(1))
      
    Case #PB_EventType_LeftDoubleClick : Debug "gadget " +EventGadget+ " ldclick item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_DragStart : Debug "gadget " +EventGadget+ " sdrag item = " + EventItem +" Data "+ EventData +" State "+ State
    Case #PB_EventType_Change    : Debug "gadget " +EventGadget+ " change item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_RightClick : Debug "gadget " +EventGadget+ " rclick item = " + EventItem +" data "+ EventData +" State "+ State
    Case #PB_EventType_RightDoubleClick : Debug "gadget " +EventGadget+ " rdclick item = " + EventItem +" data "+ EventData +" State "+ State
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

If OpenWindow(0, 0, 0, 355, 240, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;ListViewGadget(0, 10, 10, 160, 160) 
  PB(TreeGadget)(0, 10, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_AlwaysShowSelection)                                         ; TreeGadget standard
  TreeGadget(1, 180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_Collapse | #PB_Tree_GridLines | #PB_Tree_AlwaysShowSelection)    ; TreeGadget with Checkboxes + NoLines
  
  For ID = 0 To 1
    For a = 0 To 10
      AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)           ; These are on the 1st sublevel
      AddGadgetItem(ID, -1, "Sub-Item 1_2", 0, 2)           ; These are on the 1st sublevel
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem (ID, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
    Next
    
    Debug " gadget "+ ID +" count items "+ CountGadgetItems(ID) +" "+ GadgetType(ID)
  Next
  
  ButtonGadget(3, 10, 180, 100, 24, "set state Item")
  BindGadgetEvent(3, @events_tree_gadget())
  ButtonGadget(4, 120, 180, 100, 24, "add Item")
  BindGadgetEvent(4, @events_tree_gadget())
  ButtonGadget(5, 230, 180, 100, 24, "remove Item")
  BindGadgetEvent(5, @events_tree_gadget())
  
  ButtonGadget(6, 10, 210, 100, 24, "set image Item")
  BindGadgetEvent(6, @events_tree_gadget())
  ButtonGadget(7, 120, 210, 35, 24, "<")
  BindGadgetEvent(7, @events_tree_gadget())
  ButtonGadget(8, 155, 210, 30, 24, "0")
  BindGadgetEvent(8, @events_tree_gadget())
  ButtonGadget(9, 185, 210, 35, 24, ">")
  BindGadgetEvent(9, @events_tree_gadget())
  ButtonGadget(10, 230, 210, 100, 24, "clears Items")
  BindGadgetEvent(10, @events_tree_gadget())
  
  BindGadgetEvent(0, @events_tree_gadget())
  BindGadgetEvent(1, @events_tree_gadget())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP