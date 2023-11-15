; 
; demo state
;
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *added, *reset, *w1, *w2, *g1, *g2, countitems=9; количесвто итемов 
  
  Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If state >= 0
          Protected Range.NSRange\location = state ; Len(GetGadgetText(gadget))
          CocoaMessage(0, GadgetID(gadget), "scrollRangeToVisible:@", @Range)
        ;  CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        ;  CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
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
      Case #__event_LeftClick
        
        Select widget::EventWidget( )
          Case *added
            widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
            widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
          Case *reset
            If widget::GetState(*reset)
              count = widget::CountItems( *w1 )
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
      Case #__event_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #__event_Change
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
  
  If Open(#PB_Any, 100, 50, 525, 435+40, "demo Editor state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = EditorGadget(#PB_Any, 10, 10, 250, 150)
    *g2 = EditorGadget(#PB_Any, 10, 165, 250, 260)
    
    For a = 0 To countitems
      AddGadgetItem(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = widget::Editor(265, 10, 250, 150, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
    *w2 = widget::Editor(265, 165, 250, 260, #__Flag_GridLines) ; |#PB_Flag_MultiSelect
    
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    widget::SetState(*w1, a-1)
    widget::SetState(*w2, a-1) 
    widget::Bind(*w2, @widget_events())
    widget::Bind(*w2, @widget_events(), #__event_RightClick)
    
    *reset = widget::Button( 10, 435, 100, 30, "reset state", #__button_toggle)
    widget::SetState( *reset, 1)
    widget::Bind(*reset, @button_events())
    
    *added = widget::Button( 525 - 10-120, 435, 120, 30, "add new item")
    widget::Bind(*added, @button_events())
    
    widget::WaitClose()
  EndIf
CompilerEndIf


; ; IncludePath "../../../"
; ; XIncludeFile "widgets.pbi"
; ; 
; ; UseLib(widget)
; ; 
; ; LN=1000; количесвто итемов 
; ; Global *w._S_widget
; ; 
; ; If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
; ;   EditorGadget(0, 10, 10, 250, 150)    ;, #PB_ListView_MultiSelect
; ;   
; ;   Open(0, 270, 10, 250, 150)
; ;   *w=Editor(0, 0, 250, 150, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
; ;   
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     AddItem (*w, -1, "Item "+Str(a), 0)
; ;   Next
; ;   Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
; ;   
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     SetState(*w, a-1) ; set (beginning with 0) the tenth item as the active one
; ;   Next
; ;   Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
; ;   
; ;   
; ;   ; HideGadget(0, 1)
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     AddGadgetItem (0, -1, "Item "+Str(a), 0)
; ;   Next
; ;   Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
; ;   
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     SetGadgetState(0, a-1) ; set (beginning with 0) the tenth item as the active one
; ;   Next
; ;   Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
; ;   ; HideGadget(0, 0)
; ;   
; ;   ;Redraw(root())
; ;   
; ;   Debug " -------- "
; ;   
; ;   EditorGadget(10, 10, 170, 250, 520, #PB_ListView_MultiSelect)
; ;   
; ;   Open(0, 270, 170, 250, 520);, "", #__flag_borderless)
; ;   *w=Editor(0, 0, 250, 520, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
; ;   ;
; ;   ;-
; ;   ;
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     AddItem (*w, -1, "Item "+Str(a), 0)
; ;   Next
; ;   Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
; ;   
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     SetItemState(*w, a, 1) ; set (beginning with 0) the tenth item as the active one
; ;   Next
; ;   Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
; ;   
; ;   
; ;   ; HideGadget(0, 1)
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     AddGadgetItem (10, -1, "Item "+Str(a), 0)
; ;   Next
; ;   Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(10)
; ;   
; ;   a=0
; ;   Define time = ElapsedMilliseconds()
; ;   For a = 0 To LN
; ;     SetGadgetItemState(10, a, 1) ; set (beginning with 0) the tenth item as the active one
; ;   Next
; ;   Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
; ;   ; HideGadget(0, 0)
; ;   
; ;   Debug " -------- "
; ;   
; ;   ; Redraw(root())
; ;   
; ;   Repeat : Event=WaitWindowEvent()
; ;   Until  Event= #PB_Event_CloseWindow
; ; EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 96
; FirstLine = 93
; Folding = ---
; EnableXP