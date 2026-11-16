; 
; demo state

IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, CountItems=9; количесвто итемов 
  
  ;\\
  Procedure SetGadgetState_(Gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If state >= 0
          CocoaMessage(0, GadgetID(Gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect 
    
    SetGadgetState(Gadget, state)
  EndProcedure
  
  ;\\
  Procedure AddGadgetItem_(Gadget, position, Text.s, imageID=0, flags=0)
    AddGadgetItem(Gadget, position, Text, imageID, flags)
    
    If GetGadgetState(Gadget) >= 0
      SetGadgetState_( Gadget, CountGadgetItems(Gadget) - 1 )
    EndIf
  EndProcedure
  
  ;\\
  Procedure TreeGadget_(Gadget, X,Y,Width,Height,Flag=0)
    Protected g = PB(TreeGadget)(Gadget, X,Y,Width,Height,Flag)
    If Gadget =- 1 : Gadget = g : EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define RowHeight.CGFloat = 20
      ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
      CocoaMessage(0, GadgetID(Gadget), "setRowHeight:@", @RowHeight)
    CompilerElse
    CompilerEndIf
    
    ProcedureReturn Gadget
  EndProcedure
  
  Procedure button_events()
    Protected count
    
    Select WidgetEvent( )
      Case #__event_Up
        
        Select EventWidget( )
          Case *first
            SetState(*w1, 0)
            SetState(*w2, 0)
            SetGadgetState_(*g1, 0)
            SetGadgetState_(*g2, 0)
            
            Disable(*reset, 0)
            SetState(*last, 0)
            
          Case *last
            SetState(*w1, CountItems( *w1 ) - 1)
            SetState(*w2, CountItems( *w2 ) - 1)
            SetGadgetState_(*g1, CountGadgetItems(*g1) - 1)
            SetGadgetState_(*g2, CountGadgetItems(*g2) - 1)
            
            Disable(*reset, 0)
            SetState(*first, 0)
            
          Case *added
            AddItem(*w1, -1, "item " +Str(CountItems(*w1)) +" (added)")
            AddItem(*w2, -1, "item " +Str(CountItems(*w2)) +" (added)")
            ;SetState(*w2, CountItems(*w2)-1)
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            ;SetGadgetState(*g2, CountGadgetItems(*g2)-1)
            
             SetState(*last, Bool(Disable(*reset)=0))
             SetState(*first, 0)
            
         Case *reset
            Disable(*reset, 1)
            SetState(*first, 0)
            SetState(*last, 0)
            ;
            SetState(*w1, count - 1)
            SetState(*w2, count - 1)
            SetGadgetState_(*g1, count - 1)
            SetGadgetState_(*g2, count - 1)
            
            
        EndSelect
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEvent( )
      Case #__event_RightClick
        AddItem(*w1, -1, "item " +Str(CountItems(*w1)) +" (added)")
        AddItem(*w2, -1, "item " +Str(CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
     Case #__event_Change
        Debug "change widget "+GetState(EventWidget( ))
        Disable(*reset, 0)
        SetState(*w1, GetState(EventWidget( )))
        
    EndSelect
  EndProcedure
  
  Procedure gadget_events()
    Select EventType( )
      Case #PB_EventType_RightClick
        AddItem(*w1, -1, "item " +Str(CountItems(*w1)) +" (added)")
        AddItem(*w2, -1, "item " +Str(CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #PB_EventType_Change
        Debug "change gadget "+GetGadgetState(EventGadget( ))
        SetGadgetState_(*g1, GetGadgetState(EventGadget()))
        
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
    
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = Tree(265, 10, 250, 100, #PB_Tree_NoButtons|#PB_Tree_NoLines)  ; |#__Flag_GridLines
    *w2 = Tree(265, 115, 250, 310, #PB_Tree_NoButtons|#PB_Tree_NoLines) ; |#__Flag_GridLines
    
    For a = 0 To CountItems
      AddItem(*w1, -1, "Item "+Str(a), 0)
      AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    SetState(*w1, a-1)
    SetState(*w2, a-1) 
    Bind(*w2, @widget_events())
    Bind(*w2, @widget_events(), #__event_RightClick)
    
    *reset = Button( 10, 435, 100, 30, "reset [all] selected")
    *first = Button( 525 - (10+120)*3, 435, 120, 30, "select [first] item", #PB_Button_Toggle)
    *last = Button( 525 - (10+120)*2, 435, 120, 30, "select [last] item", #PB_Button_Toggle)
    *added = Button( 525 - (10+120)*1, 435, 120, 30, "add [new] item")
    
    SetState( *reset, 1)
    SetState( *last, 1)
    
    Bind(*reset, @button_events(), #__event_Up)
    Bind(*first, @button_events(), #__event_Up)
    Bind(*last, @button_events(), #__event_Up)
    Bind(*added, @button_events(), #__event_Up)
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 175
; FirstLine = 152
; Folding = ---
; EnableXP
; DPIAware