; 
; demo state
;
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *added, *reset, *w1, *w2, *g1, *g2, countitems=10; количесвто итемов 
  
  Procedure button_events()
    Protected count
    
    Select this()\event
     Case #PB_EventType_LeftClick
       
       Select this()\widget
         Case *added
           AddItem(*w1, -1, "item " +Str(CountItems(*w1)) +" (added)")
           AddItem(*w2, -1, "item " +Str(CountItems(*w2)) +" (added)")
           ; SetState(*w1, CountItems(*w1) - 1)
           
           AddGadgetItem(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
           AddGadgetItem(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
           ; SetGadgetState(*g1, CountGadgetItems(*g1) - 1)
           
         Case *reset
           If GetState(*reset)
             count = CountItems( *w1 )
           EndIf
           
           SetState(*w1, count - 1)
           SetState(*w2, count - 1)
           SetGadgetState(*g1, count - 1)
           SetGadgetState(*g2, count - 1)
           
       EndSelect
       
   EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select this()\event
      Case #PB_EventType_RightClick
        AddItem(*w1, -1, "item " +Str(CountItems(*w1)) +" (added)")
        AddItem(*w2, -1, "item " +Str(CountItems(*w2)) +" (added)")
           
      Case #PB_EventType_Change
        SetState(*w1, GetState(this()\widget))
    EndSelect
  EndProcedure
  
  Procedure gadget_events()
    Select EventType()
      Case #PB_EventType_Change
        SetGadgetState(*g1, GetGadgetState(EventGadget()))
        
;         CompilerSelect #PB_Compiler_OS
;           CompilerCase #PB_OS_MacOS
;             Protected Range.NSRange\location = Len(GetGadgetText(*g1))
;             CocoaMessage(0, GadgetID(*g1), "scrollRangeToVisible:@", @Range)
;         CompilerEndSelect
        
    EndSelect
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu))
   ; demo gadget
    *g1 = TreeGadget(#PB_Any, 10, 10, 250, 150, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    *g2 = TreeGadget(#PB_Any, 10, 165, 250, 260, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    
    For a = 0 To countitems
      AddGadgetItem(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState(*g1, a-1)
    SetGadgetState(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
     ; demo widget
    *w1 = Tree(265, 10, 250, 150, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
    *w2 = Tree(265, 165, 250, 260, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines) ; |#PB_Flag_MultiSelect
    
    For a = 0 To countitems
      AddItem(*w1, -1, "Item "+Str(a), 0)
      AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    SetState(*w1, a-1)
    SetState(*w2, a-1) 
    Bind(*w2, @widget_events())
    Bind(*w2, @widget_events(), #PB_EventType_RightClick)
    
    *reset = Button( 10, 435, 100, 30, "reset state", #__button_toggle)
    SetState( *reset, 1)
    Bind(*reset, @button_events())
    
    *added = Button( 525 - 10-120, 435, 120, 30, "add new item")
    Bind(*added, @button_events())
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP