XIncludeFile "../../../widgets-bar.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Procedure events_gadgets()
    ClearDebugOutput()
    ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
    
    Select EventType()
      Case #PB_EventType_LeftClick
        SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
        Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
    EndSelect
  EndProcedure
  
  Procedure events_widgets()
    ClearDebugOutput()
    ; Debug ""+Str(This()\widget\index - 1)+ " - widget  event - " +This()\type+ "  state - " GetState(This()\widget) ; 
    
    Select This()\event
      Case #PB_EventType_Change
        SetGadgetState((This()\widget\index - 1), GetState(This()\widget))
        Debug  Str(This()\widget\index - 1)+" - widget change " + GetState(This()\widget)
    EndSelect
  EndProcedure
  
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
    If Open(OpenWindow(#PB_Any, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
    
    Button_0 = widget::Tab(0, 0, 0, 0, 0, 0, 0)                  ; No need to specify size or coordinates
    widget::AddItem(Button_0, -1, "Tab_0")
    widget::AddItem(Button_0, -1, "Tab_1 (long)")
    widget::AddItem(Button_0, -1, "Tab_2")
    widget::AddItem(Button_0, -1, "Tab_3 (long)")
    widget::AddItem(Button_0, -1, "Tab_4")
    widget::AddItem(Button_0, -1, "Tab_5 (long)")
    
    widget::SetState(Button_0, 5)
    
    Button_1 = widget::Tab(0, 0, 0, 0, 0, 0, 0, #__bar_vertical)                  ; No need to specify size or coordinates
    widget::AddItem(Button_1, -1, "Tab_0")
    widget::AddItem(Button_1, -1, "Tab_1 (long)")
    widget::AddItem(Button_1, -1, "Tab_2")
    widget::AddItem(Button_1, -1, "Tab_3 (long)")
    widget::AddItem(Button_1, -1, "Tab_4")
    widget::AddItem(Button_1, -1, "Tab_5 (long)")
    
    widget::SetState(Button_1, 3)
    
    Button_5 = widget::Tab(0, 0, 0, 0, 0, 0, 0)                  ; No need to specify size or coordinates
    widget::AddItem(Button_5, -1, "Tab_0")
    widget::AddItem(Button_5, -1, "Tab_1 (long)")
    widget::AddItem(Button_5, -1, "Tab_2")
    
    widget::SetState(Button_5, 1)
    
    
    ;Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed);|#PB_Splitter_Separator)
    Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_1, Button_5);, #PB_Splitter_Separator)
    Splitter_4 = widget::Splitter(10, 10, 400, 300, Button_0, Splitter_3, #PB_Splitter_Vertical);|#PB_Splitter_Separator)
    
    ;     ; widget::SetState(Button_2, 5)
    ;     widget::SetState(Splitter_0, 26)
    ;     widget::SetState(Splitter_4, 220)
    ;     widget::SetState(Splitter_3, 55)
    ;     widget::SetState(Splitter_2, 15)
    
    Define *panel_1 = Panel(8, 8+350, 306, 203, #__bar_vertical)
    AddItem (*panel_1, -1, "Panel 1")
    Define *panel_2 = Panel(5, 5, 290, 166-30)
    AddItem(*panel_2, -1, "Sub 1")
    AddItem(*panel_2, -1, "Sub 2")
    AddItem(*panel_2, -1, "Sub 3")
    AddItem(*panel_2, -1, "Sub 4")
    SetState(*panel_2, 2)
    CloseList()
    
    Button(10, 145, 80, 24,"remove")
    Button(95, 145, 80, 24,"add")
    Button(95+85, 145, 80, 24,"clear")
    
    AddItem (*panel_1, -1,"Panel 2")
    Button(10, 15, 80, 24,"Button 3")
    Button(95, 15, 80, 24,"Button 4")
    
    AddItem (*panel_1, -1,"Panel 3")
    Button(10, 35, 80, 24,"Button 5")
    Button(95, 35, 80, 24,"Button 6")
    CloseList()
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      LoadFont(5, "Arial", 18)
      LoadFont(6, "Arial", 25)
      
    CompilerElse
      LoadFont(5, "Arial", 14)
      LoadFont(6, "Arial", 21)
      
    CompilerEndIf
    
    SetItemFont(*panel_1, 1, 6)
  SetItemFont(*panel_2, 1, 6)
  
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = +-
; EnableXP