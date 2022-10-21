; 
; demo state
;
IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *added, *reset, *w1, *w2, *g1, *g2, countitems=9; количесвто итемов 
  
  Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect
    
    SetGadgetState(gadget, state)
  EndProcedure
  
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If GetGadgetState(gadget) >= 0
          SetGadgetState_(gadget, CountGadgetItems(gadget) - 1)
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure button_events()
    Protected count
    
    Select widget::WidgetEventType( )
      Case #PB_EventType_LeftClick
        
        Select widget::EventWidget( )
          Case *added
            widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
            widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
          Case *reset
            If widget::GetState(*reset)
              count = widget::CountItems( *w1 )
              SetText(*reset, "reset state")
            Else
              SetText(*reset, "set state")
            EndIf
            
            widget::SetState(*w1, count - 1)
            widget::SetState(*w2, count - 1)
            SetGadgetState_(*g1, count - 1)
            SetGadgetState_(*g2, count - 1)
            
            
        EndSelect
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEventType( )
      Case #PB_EventType_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #PB_EventType_Change
        widget::SetState(*w1, widget::GetState(widget::EventWidget( )))
        
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
        SetGadgetState_(*g1, GetGadgetState(EventGadget()))
        
    EndSelect
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu))
    ; demo gadget
    *g1 = TreeGadget(#PB_Any, 10, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    *g2 = TreeGadget(#PB_Any, 10, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    
    For a = 0 To countitems
      AddGadgetItem(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = widget::Tree(265, 10, 250, 100, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
    *w2 = widget::Tree(265, 115, 250, 310, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines) ; |#PB_Flag_MultiSelect
    
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    widget::SetState(*w1, a-1)
    widget::SetState(*w2, a-1) 
    widget::Bind(*w2, @widget_events())
    widget::Bind(*w2, @widget_events(), #PB_EventType_RightClick)
    
    *reset = widget::Button( 10, 435, 100, 30, "reset state", #__button_toggle)
    widget::SetState( *reset, 1)
    widget::Bind(*reset, @button_events())
    
    *added = widget::Button( 525 - 10-120, 435, 120, 30, "add new item")
    widget::Bind(*added, @button_events())
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP