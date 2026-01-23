; 
; demo state
;
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *added, *reset, *w1, *w2, *g1, *g2,CountItems =9; количесвто итемов 
  
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
  
  Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, Text, imageID, flags)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If GetGadgetState(gadget) >= 0
          SetGadgetState_(gadget, CountGadgetItems(gadget) - 1)
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure button_events()
    Protected count
    
    Select Widget::WidgetEvent( )
      Case #__event_LeftClick
        
        Select Widget::EventWidget( )
          Case *added
            Widget::AddItem(*w1, -1, "item " +Str(Widget::CountItems(*w1)) +" (added)")
            Widget::AddItem(*w2, -1, "item " +Str(Widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
          Case *reset
            If Widget::GetState(*reset)
              count = Widget::CountItems( *w1 )
            EndIf
            
            Widget::SetState(*w1, count - 1)
            Widget::SetState(*w2, count - 1)
            SetGadgetState_(*g1, count - 1)
            SetGadgetState_(*g2, count - 1)
            
        EndSelect
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEvent( )
      Case #__event_RightClick
        Widget::AddItem(*w1, -1, "item " +Str(Widget::CountItems(*w1)) +" (added)")
        Widget::AddItem(*w2, -1, "item " +Str(Widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #__event_Change
        Widget::SetState(*w1, Widget::GetState(Widget::EventWidget( )))
        
    EndSelect
  EndProcedure
  
  Procedure gadget_events()
    Select EventType( )
      Case #PB_EventType_RightClick
        Widget::AddItem(*w1, -1, "item " +Str(Widget::CountItems(*w1)) +" (added)")
        Widget::AddItem(*w2, -1, "item " +Str(Widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #PB_EventType_Change
        SetGadgetState_(*g1, GetGadgetState(EventGadget()))
        
    EndSelect
  EndProcedure
  
  If OpenWindow(0, 100, 50, 525, 435+40, "demo Editor state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = EditorGadget(#PB_Any, 10, 10, 250, 150)
    *g2 = EditorGadget(#PB_Any, 10, 165, 250, 260)
    
    For a = 0 To CountItems
      AddGadgetItem(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
      
    SetGadgetFont(#PB_All, GetGadgetFont(*g1))
    Open(0, 265, 0, 525-265, 435+40)
        
    ; demo widget
    *w1 = Widget::Editor(0, 10, 250, 150, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
    *w2 = Widget::Editor(0, 165, 250, 260, #__Flag_GridLines) ; |#PB_Flag_MultiSelect
    
;     SetFont(*w1, Font::ID(GetGadgetFont(*g1)))
;     SetFont(*w2, Font::ID(GetGadgetFont(*g2)))
    
    For a = 0 To CountItems
      Widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      Widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    Widget::SetState(*w1, a-1)
    Widget::SetState(*w2, a-1) 
    Widget::Bind(*w2, @widget_events())
    Widget::Bind(*w2, @widget_events(), #__event_RightClick)
    
    *reset = Widget::Button( 10, 435, 100, 30, "reset state", #PB_Button_Toggle)
    Widget::SetState( *reset, 1)
    Widget::Bind(*reset, @button_events())
    
    *added = Widget::Button( 525-265 - 10-120, 435, 120, 30, "add new item")
    Widget::Bind(*added, @button_events())
    
    Widget::WaitClose()
  EndIf
CompilerEndIf


; ; IncludePath "../../../"
; ; XIncludeFile "widgets.pbi"
; ; 
; ; UseWidgets( )
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
; ;   Debug " -------- "
; ;   
; ;   EditorGadget(10, 10, 170, 250, 520, #PB_ListView_MultiSelect)
; ;   
; ;   Open(0, 270, 170, 250, 520);, "", #__flag_Borderless)
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
; ;   ; ;   
; ;   Repeat : Event=WaitWindowEvent()
; ;   Until  Event= #PB_Event_CloseWindow
; ; EndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 135
; FirstLine = 123
; Folding = ---
; EnableXP
; DPIAware