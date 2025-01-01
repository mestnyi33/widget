; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, CountItems=9; количесвто итемов 
  
  ;\\
   Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect 
    
    SetGadgetState(gadget, state)
  EndProcedure
  
  Procedure SetGadgetItemState_(gadget, item, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", item )
        EndIf
    CompilerEndSelect 
    
    SetGadgetItemState(gadget, item, state)
  EndProcedure
  
  ;\\
  Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, Text, imageID, flags)
    
    If GetGadgetState(gadget) >= 0
      SetGadgetItemState_( gadget, CountGadgetItems(gadget) - 1, #PB_Tree_Selected )
    EndIf
  EndProcedure
  
  ;\\
  Procedure TreeGadget_(gadget, X,Y,Width,Height,flag=0)
    Protected g = PB(TreeGadget)(gadget, X,Y,Width,Height,flag)
    If gadget =- 1 : gadget = g : EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define RowHeight.CGFloat = 20
      ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
      CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    CompilerElse
    CompilerEndIf
    
    ProcedureReturn gadget
  EndProcedure
  
  Procedure button_events()
    Protected count
    
    Select widget::WidgetEvent( )
      Case #__event_Up
        
        Select widget::EventWidget( )
          Case *first
            widget::SetItemState(*w1, 0, #PB_Tree_Selected)
            widget::SetItemState(*w2, 0, #PB_Tree_Selected)
            SetGadgetItemState_(*g1, 0, #PB_Tree_Selected)
            SetGadgetItemState_(*g2, 0, #PB_Tree_Selected)
            
            widget::Disable(*reset, 0)
            widget::SetState(*last, 0)
            
          Case *last
            widget::SetItemState(*w1, widget::CountItems( *w1 ) - 1, #PB_Tree_Selected)
            widget::SetItemState(*w2, widget::CountItems( *w2 ) - 1, #PB_Tree_Selected)
            SetGadgetItemState_(*g1, CountGadgetItems(*g1) - 1, #PB_Tree_Selected)
            SetGadgetItemState_(*g2, CountGadgetItems(*g2) - 1, #PB_Tree_Selected)
            
            widget::Disable(*reset, 0)
            widget::SetState(*first, 0)
            
          Case *added
            widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
            widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
            widget::SetState(*last, widget::GetState(*reset))
            widget::SetState(*first, 0)
            
         Case *reset
            widget::Disable(*reset, 1)
            widget::SetState(*first, 0)
            widget::SetState(*last, 0)
            ;
            widget::SetItemState(*w1, count - 1,0); #PB_Tree_Selected)
            widget::SetItemState(*w2, count - 1,0); #PB_Tree_Selected)
            SetGadgetItemState_(*g1, count - 1,0); #PB_Tree_Selected)
            SetGadgetItemState_(*g2, count - 1,0); #PB_Tree_Selected)
            
            
        EndSelect
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEvent( )
      Case #__event_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #__event_Change
        widget::Disable(*reset, 0)
        widget::SetItemState(*w1, widget::GetState(widget::EventWidget( )), #PB_Tree_Selected)
        
    EndSelect
  EndProcedure
  
  Procedure gadget_events()
    Select EventType( )
      Case #PB_EventType_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #PB_EventType_Change
        SetGadgetItemState_(*g1, GetGadgetState(EventGadget()), #PB_Tree_Selected)
        
    EndSelect
  EndProcedure
  
  If Open(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = TreeGadget_(#PB_Any, 10, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
    *g2 = TreeGadget_(#PB_Any, 10, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
    
    For a = 0 To CountItems
      AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
    Next
    
;     SetGadgetState_(*g1, a-1)
;     SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = widget::Tree(265, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines)  ; |#__Flag_GridLines
    *w2 = widget::Tree(265, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines) ; |#__Flag_GridLines
    
    For a = 0 To CountItems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
;     widget::SetState(*w1, a-1)
;     widget::SetState(*w2, a-1) 
    widget::Bind(*w2, @widget_events())
    widget::Bind(*w2, @widget_events(), #__event_RightClick)
    
    *reset = widget::Button( 10, 435, 100, 30, "reset [all] selected")
    *first = widget::Button( 525 - (10+120)*3, 435, 120, 30, "select [first] item", #__flag_ButtonToggle)
    *last = widget::Button( 525 - (10+120)*2, 435, 120, 30, "select [last] item", #__flag_ButtonToggle)
    *added = widget::Button( 525 - (10+120)*1, 435, 120, 30, "add [new] item")
    
    widget::SetState( *reset, 1)
    widget::SetState( *last, 1)
    
    widget::Bind(*reset, @button_events(), #__event_Up)
    widget::Bind(*first, @button_events(), #__event_Up)
    widget::Bind(*last, @button_events(), #__event_Up)
    widget::Bind(*added, @button_events(), #__event_Up)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 121
; FirstLine = 119
; Folding = ----
; EnableXP
; DPIAware