IncludePath "../../"
XIncludeFile "widgets.pbi"

UseLib(widget)

CompilerIf #PB_Compiler_IsMainFile
  ;     Macro PB(Function)
  ;       Function
  ;     EndMacro
  Global *tree, tree, img =- 1
  
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
    Protected Text$
    
    Select EventType
        ;     Case #PB_EventType_Focus    : Debug "gadget focus item = " + EventItem +" data "+ EventData
        ;     Case #PB_EventType_LostFocus    : Debug "gadget lfocus item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget " +EventGadget+ " lclick item = " + EventItem +" data "+ EventData +" State "+ State
        If EventGadget = 3
          click ! 1
          If click
            SetGadgetItemState(tree, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
            SetItemState(*tree, 1, #PB_Tree_Selected|#PB_Tree_Expanded|#PB_Tree_Inbetween)
          Else
            SetGadgetItemState(tree, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
            SetItemState(*tree, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Inbetween)
          EndIf
        EndIf
        
        If EventGadget = 4
          AddGadgetItem(tree, 1, "added item "+Str(CountGadgetItems(tree)))
          AddItem(*tree, 1, "added item "+Str(CountItems(*tree)))
          ;             widget()\change = 1
          ;             Debug widget()\change
          ;             Repaints()
        EndIf
        If EventGadget = 5
          If GetGadgetState(tree) =- 1
            RemoveGadgetItem(tree, 1)
          Else
            RemoveGadgetItem(tree, GetGadgetState(tree))
          EndIf
          
          If GetState(*tree) =- 1
            RemoveItem(*tree, 1)
          Else
            RemoveItem(*tree, GetState(*tree))
          EndIf
        EndIf
        If EventGadget = 6
          SetGadgetItemImage(tree, GetGadgetState(tree), ImageID(0))
          SetItemImage(*tree, GetState(*tree), 0)
        EndIf
        If EventGadget = 7 ; <<
                           ;         FreeGadget(tree)
                           ;         Free(*tree)
          
          SetGadgetState(tree, 0)
          SetState(*tree, 0)
        EndIf
        If EventGadget = 8 ; 0
          SetGadgetState(tree, -1)
          SetState(*tree, -1)
        EndIf
        If EventGadget = 9 ; >>
          SetGadgetState(tree, CountGadgetItems(tree)-1)
          SetState(*tree, CountItems(*tree)-1)
        EndIf
        If EventGadget = 10
          ClearGadgetItems(tree)
          ClearItems(*tree)
        EndIf
        
        ; widget::Redraw(GetGadgetData(1))
        
      Case #PB_EventType_LeftDoubleClick : Debug "gadget " +EventGadget+ " ldclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_Change    : Debug "gadget " +EventGadget+ " change item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_RightClick : Debug "gadget " +EventGadget+ " rclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_RightDoubleClick : Debug "gadget " +EventGadget+ " rdclick item = " + EventItem +" data "+ EventData +" State "+ State
        
      Case #PB_EventType_DragStart : Debug "gadget " +EventGadget+ " sdrag item = " + EventItem +" Data "+ EventData +" State "+ State
        Text$ = GetGadgetItemText(EventGadget, GetGadgetState(EventGadget))
        DragText(Text$)
        
      Case #PB_EventType_Drop
        AddGadgetItem(EventGadget, -1, EventDropText())
        
        
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
    
    Repaints()
  EndProcedure  
  
  If Open(OpenWindow(#PB_Any, 0, 0, 370, 240, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    ;ListViewGadget(0, 10, 10, 160, 160) 
    tree = PB(TreeGadget)(#PB_Any, 10, 10, 170, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_AlwaysShowSelection)                                         ; TreeGadget standard
    *tree = Tree(190, 10, 170, 160, #__Tree_GridLines | #__Tree_CheckBoxes | #__Tree_NoLines | #__Tree_ThreeState | #__Tree_Collapse)                                                     ; | | #__Tree_AlwaysShowSelection #__Tree_GridLines)   ; TreeGadget with Checkboxes + NoLines
    Define a
    
    For a = 0 To 10
      AddGadgetItem(tree, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddGadgetItem(tree, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(tree, -1, Str(a)+" Sub-Item 1", 0, 1)          ; These are on the 1st sublevel
      AddGadgetItem(tree, -1, Str(a)+" Sub-Item 1_2", 0, 2)        ; These are on the 1st sublevel
      AddGadgetItem(tree, -1, Str(a)+" Sub-Item 2", 0, 1)
      AddGadgetItem(tree, -1, Str(a)+" Sub-Item 3", 0, 1)
      AddGadgetItem(tree, -1, Str(a)+" Sub-Item 4", 0, 1)
      AddGadgetItem(tree, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
    Next
    
    Debug " gadget "+ tree +" count items "+ CountGadgetItems(tree) +" "+ GadgetType(tree)
    EnableGadgetDrop(tree, #PB_Drop_Text, #PB_Drag_Copy)
    
    
    For a = 0 To 1;0
      AddItem(*tree, -1, "Normal Item "+Str(a), img, 0) ; if you want to add an image, use
      AddItem(*tree, -1, "Node "+Str(a), img, 0)        ; ImageID(x) as 4th parameter
      AddItem(*tree, -1, Str(a)+" Sub-Item 1", img, 1)          ; These are on the 1st sublevel
      AddItem(*tree, -1, Str(a)+" Sub-Item 1_2", img, 2)        ; These are on the 1st sublevel
      AddItem(*tree, -1, Str(a)+" Sub-Item 2", img, 1)
      AddItem(*tree, -1, Str(a)+" Sub-Item 3", img, 1)
      AddItem(*tree, -1, Str(a)+" Sub-Item 4", img, 1)
      AddItem(*tree, -1, "File "+Str(a), img, 0) ; sublevel 0 again
    Next
    
    ;         Debug " widget "+ *tree +" count items "+ CountItems(*tree) +" "+ Type(*tree)
    ;         EnableGadgetDrop(*tree, #PB_Drop_Text, #PB_Drag_Copy)
    
    PB(ButtonGadget)(3, 10, 180, 110, 24, "set state Item")
    BindGadgetEvent(3, @events_tree_gadget())
    PB(ButtonGadget)(4, 130, 180, 110, 24, "add Item")
    BindGadgetEvent(4, @events_tree_gadget())
    PB(ButtonGadget)(5, 250, 180, 110, 24, "remove Item")
    BindGadgetEvent(5, @events_tree_gadget())
    
    PB(ButtonGadget)(6, 10, 210, 110, 24, "set image Item")
    BindGadgetEvent(6, @events_tree_gadget())
    PB(ButtonGadget)(7, 130, 210, 40, 24, "<")
    BindGadgetEvent(7, @events_tree_gadget())
    PB(ButtonGadget)(8, 170, 210, 30, 24, "0")
    BindGadgetEvent(8, @events_tree_gadget())
    PB(ButtonGadget)(9, 200, 210, 40, 24, ">")
    BindGadgetEvent(9, @events_tree_gadget())
    PB(ButtonGadget)(10, 250, 210, 110, 24, "clears Items")
    BindGadgetEvent(10, @events_tree_gadget())
    
    BindGadgetEvent(tree, @events_tree_gadget())
    ;       BindGadgetEvent(1, @events_tree_gadget())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ----
; EnableXP