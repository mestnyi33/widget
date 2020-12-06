; 
; demo 
;
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *w1, *w2, *g1, *g2, countitems=12; количесвто итемов 
  
  Procedure widget_events()
    Select this()\event
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
  
  If Open(OpenWindow(#PB_Any, 100, 50, 525, 435, "demo tree state", #PB_Window_SystemMenu))
    ; demo widget
    *w1 = Tree(10, 10, 250, 150, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
    *w2 = Tree(10, 165, 250, 260, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines) ; |#PB_Flag_MultiSelect
    
    For a = 0 To countitems
      AddItem(*w1, -1, "Item "+Str(a), 0)
      AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    SetState(*w1, a-1)
    SetState(*w2, a-1) 
    Bind(*w2, @widget_events())
    
    ; demo gadget
    *g1 = TreeGadget(#PB_Any, 265, 10, 250, 150, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    *g2 = TreeGadget(#PB_Any, 265, 165, 250, 260, #PB_Tree_NoButtons|#PB_Tree_NoLines)
    
    For a = 0 To countitems
      AddGadgetItem(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState(*g1, a-1)
    SetGadgetState(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP