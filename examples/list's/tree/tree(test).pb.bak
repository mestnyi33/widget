IncludePath "../../../"
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
  
  Procedure events_tree_widget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Static click
    Protected Text$
    Protected EventGadget = EventWidget()
    Protected EventType = WidgetEvent()
    Protected EventData = WidgetEventData()
    Protected EventItem = GetState(EventGadget)
    Protected State = GetItemState(EventGadget, EventItem)
    
    Select EventType
        ;     Case #__event_Focus    : Debug "gadget focus item = " + EventItem +" data "+ EventData
        ;     Case #__event_LostFocus    : Debug "gadget lfocus item = " + EventItem +" data "+ EventData
      Case #__event_LeftClick : Debug "gadget " +EventGadget+ " lclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #__event_LeftDoubleClick : Debug "gadget " +EventGadget+ " ldclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #__event_Change    : Debug "gadget " +EventGadget+ " change item = " + EventItem +" data "+ EventData +" State "+ State
      Case #__event_RightClick : Debug "gadget " +EventGadget+ " rclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #__event_RightDoubleClick : Debug "gadget " +EventGadget+ " rdclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #__event_DragStart : Debug "gadget " +EventGadget+ " sdrag item = " + EventItem +" Data "+ EventData +" State "+ State
      Case #__event_Drop
    EndSelect 
    
    If EventType = #__event_LeftClick
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
;           If GetGadgetItemImage(tree, GetGadgetState(tree))
;             SetGadgetItemImage(tree, GetGadgetState(tree), 0)
;           Else
;             SetGadgetItemImage(tree, GetGadgetState(tree), ImageID(0))
;           EndIf
          If GetItemImage(*tree, GetState(*tree) ) <> #PB_Default
            SetItemImage(*tree, GetState(*tree), #PB_Default)
            SetGadgetItemImage(tree, GetGadgetState(tree), #NUL)
          Else
            SetItemImage(*tree, GetState(*tree), 0)
            SetGadgetItemImage(tree, GetGadgetState(tree), ImageID(0))
          EndIf
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
        
        
      Case #PB_EventType_LeftDoubleClick : Debug "gadget " +EventGadget+ " ldclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_Change    : Debug "gadget " +EventGadget+ " change item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_RightClick : Debug "gadget " +EventGadget+ " rclick item = " + EventItem +" data "+ EventData +" State "+ State
      Case #PB_EventType_RightDoubleClick : Debug "gadget " +EventGadget+ " rdclick item = " + EventItem +" data "+ EventData +" State "+ State
        
      Case #PB_EventType_DragStart : Debug "gadget " +EventGadget+ " sdrag item = " + EventItem +" Data "+ EventData +" State "+ State
        Text$ = GetGadgetItemText(EventGadget, GetGadgetState(EventGadget))
        DragText(Text$)
        
      Case #__event_Drop
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
    
    ;Repaints()
  EndProcedure  
  
  Procedure TreeGadget_(gadget, x,y,width,height,flag=0)
  Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 19
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

Define a
    
  If Open(0, 0, 0, 370, 240, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;ListViewGadget(0, 10, 10, 160, 160) 
    tree = PB(TreeGadget_)(#PB_Any, 10, 10, 170, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState | #PB_Tree_AlwaysShowSelection)                                         ; TreeGadget standard
    *tree = Tree(190, 10, 170, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_ThreeState );| #__flag_GridLines | #PB_Tree_Collapsed)                                                     ; | | #PB_Tree_AlwaysShowSelection #PB_Tree_GridLines)   ; TreeGadget with Checkboxes + NoLines
    
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
    
    Debug " gadget "+ tree +" count items "+ PB(CountGadgetItems)(tree) +" "+ PB(GadgetType)(tree)
    PB(EnableGadgetDrop)(tree, #PB_Drop_Text, #PB_Drag_Copy)
    
    For a = 0 To 10
      AddItem(*tree, -1, "Normal Item "+Str(a), img, 0) ; if you want to add an image, use
      AddItem(*tree, -1, "Node "+Str(a), img, 0)        ; ImageID(x) as 4th parameter
      AddItem(*tree, -1, Str(a)+" Sub-Item 1", img, 1)          ; These are on the 1st sublevel
      AddItem(*tree, -1, Str(a)+" Sub-Item 1_2", img, 2)        ; These are on the 1st sublevel
      AddItem(*tree, -1, Str(a)+" Sub-Item 2", img, 1)
      AddItem(*tree, -1, Str(a)+" Sub-Item 3", img, 1)
      AddItem(*tree, -1, Str(a)+" Sub-Item 4", img, 1)
      AddItem(*tree, -1, "File "+Str(a), img, 0) ; sublevel 0 again
    Next
    
    ;         Debug " widget "+ *tree +" count items "+ CountItems(*tree) +" "+ WidgetType(*tree)
    EnableDrop(*tree, #PB_Drop_Text, #PB_Drag_Copy)
    
    ;\\
    For a=0 To CountItems(*tree) : SetItemState(*tree, a, #PB_Tree_Collapsed) : Next
    ;For a=0 To CountGadgetItems(tree) : SetGadgetItemState(tree, a, #PB_Tree_Expanded) : Next
    
    ;\\
    PB(ButtonGadget)(3, 10, 180, 110, 24, "change Item state")
    BindGadgetEvent(3, @events_tree_gadget())
    PB(ButtonGadget)(4, 130, 180, 110, 24, "add Item")
    BindGadgetEvent(4, @events_tree_gadget())
    PB(ButtonGadget)(5, 250, 180, 110, 24, "remove Item")
    BindGadgetEvent(5, @events_tree_gadget())
    
    PB(ButtonGadget)(6, 10, 210, 110, 24, "change Item image")
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
    Bind(*tree, @events_tree_widget())
    
    ;\\
    WaitClose( )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 18
; Folding = --yC--
; EnableXP
; DPIAware