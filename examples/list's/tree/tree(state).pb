; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, countitems=9; количесвто итемов 
  
  ;\\
  Procedure SetGadGetWidgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect 
    
    SetGadGetWidgetState(gadget, state)
  EndProcedure
  
  ;\\
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    If GetGadGetWidgetState(gadget) >= 0
      SetGadGetWidgetState_( gadget, CountGadgetItems(gadget) - 1 )
    EndIf
  EndProcedure
  
  ;\\
  Procedure TreeGadget_(gadget, x,y,width,height,flag=0)
    Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
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
            widget::SetWidgetState(*w1, 0)
            widget::SetWidgetState(*w2, 0)
            SetGadGetWidgetState_(*g1, 0)
            SetGadGetWidgetState_(*g2, 0)
            
            widget::SetWidgetState(*reset, 1)
            widget::SetWidgetState(*last, 0)
            
          Case *last
            widget::SetWidgetState(*w1, widget::CountItems( *w1 ) - 1)
            widget::SetWidgetState(*w2, widget::CountItems( *w2 ) - 1)
            SetGadGetWidgetState_(*g1, CountGadgetItems(*g1) - 1)
            SetGadGetWidgetState_(*g2, CountGadgetItems(*g2) - 1)
            
            widget::SetWidgetState(*reset, 1)
            widget::SetWidgetState(*first, 0)
            
          Case *added
            widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
            widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
            widget::SetWidgetState(*last, widget::GetWidgetState(*reset))
            widget::SetWidgetState(*first, 0)
            
          Case *reset
            If widget::GetWidgetState(*reset)
              count = widget::CountItems( *w1 )
              SetWidgetText(*reset, "reset state")
              widget::SetWidgetState(*last, 1)
            Else
              SetWidgetText(*reset, "set state")
              widget::SetWidgetState(*first, 0)
              widget::SetWidgetState(*last, 0)
            EndIf
            
            widget::SetWidgetState(*w1, count - 1)
            widget::SetWidgetState(*w2, count - 1)
            SetGadGetWidgetState_(*g1, count - 1)
            SetGadGetWidgetState_(*g2, count - 1)
            
            
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
        widget::SetWidgetState(*w1, widget::GetWidgetState(widget::EventWidget( )))
        
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
        SetGadGetWidgetState_(*g1, GetGadGetWidgetState(EventGadget()))
        
    EndSelect
  EndProcedure
  
  If OpenRoot(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = TreeGadget_(#PB_Any, 10, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
    *g2 = TreeGadget_(#PB_Any, 10, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
    
    For a = 0 To countitems
      AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadGetWidgetState_(*g1, a-1)
    SetGadGetWidgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = widget::TreeWidget(265, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines)  ; |#__Flag_GridLines
    *w2 = widget::TreeWidget(265, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines) ; |#__Flag_GridLines
    
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    widget::SetWidgetState(*w1, a-1)
    widget::SetWidgetState(*w2, a-1) 
    widget::BindWidgetEvent(*w2, @widget_events())
    widget::BindWidgetEvent(*w2, @widget_events(), #__event_RightClick)
    
    *reset = widget::ButtonWidget( 10, 435, 100, 30, "reset state", #__flag_ButtonToggle)
    *first = widget::ButtonWidget( 525 - (10+120)*3, 435, 120, 30, "first item state", #__flag_ButtonToggle)
    *last = widget::ButtonWidget( 525 - (10+120)*2, 435, 120, 30, "last item state", #__flag_ButtonToggle)
    *added = widget::ButtonWidget( 525 - (10+120)*1, 435, 120, 30, "add new item")
    
    widget::SetWidgetState( *reset, 1)
    widget::SetWidgetState( *last, 1)
    
    widget::BindWidgetEvent(*reset, @button_events(), #__event_Up)
    widget::BindWidgetEvent(*first, @button_events(), #__event_Up)
    widget::BindWidgetEvent(*last, @button_events(), #__event_Up)
    widget::BindWidgetEvent(*added, @button_events(), #__event_Up)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 47
; Folding = ---
; EnableXP
; DPIAware