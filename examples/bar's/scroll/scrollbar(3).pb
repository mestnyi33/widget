;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7
  Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      Debug ""+GetGadgetState(EventGadget()) +" "+ GetGadgetAttribute(EventGadget(), #PB_ScrollBar_Maximum) +" "+ GetGadgetAttribute(EventGadget(), #PB_ScrollBar_PageLength)
;      SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
;      Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
 ; ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Change
      Debug ""+GetState(EventWidget()) +" "+ GetAttribute(EventWidget(), #__Bar_Maximum) +" "+ GetAttribute(EventWidget(), #__Bar_PageLength)
;       SetGadgetState(GetIndex(*event\widget), GetState(*event\widget))
;       Debug  ""+GetIndex(*event\widget)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeGadget(3, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     ResizeGadget(6, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    
;     Resize(s_0, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     Resize(s_1, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    Resize(s_2, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::Open(0);, 0, 0, 510, 340)
  Global fixed = 1
  
  ; first splitter
  ScrollBarGadget(3, 0, 0, 0, 0, 5, -50, 0)
  BindGadgetEvent(3, @events_gadgets())
  
  ScrollBarGadget(6, 0, 0, 0, 0, 0, 250, 0)
  SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  ScrollBarGadget(31, 0, 0, 0, 0, 0, 250, 0)
  
  ScrollBarGadget(61, 0, 0, 0, 0, 0, 250, 0)
  SplitterGadget(71, 125, 80, 250, 70, 31, 61, #PB_Splitter_Separator )
  
  SplitterGadget(66,125, 10, 250, 70, 7, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
  SplitterGadget(77,125, 80, 250, 70, 71, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
  
  SetGadgetState(66, 250)
  SetGadgetState(77, 250)
  
  SetGadgetState(3, -10)
  SetGadgetState(6, 250-10)
  SetGadgetState(31, 250/2)
  SetGadgetState(61, 10)
  
  
  ; first splitter
  s_0 = widget::Scroll(0, 0, 0, 0, 0, -50, 0, #__bar_nobuttons) : widget()\bar\fixed = Bool(fixed)*#__split_1 
  Bind(widget(), @events_widgets())
  s_1 = widget::Scroll(0, 0, 0, 0, 0, 0, 0, #__bar_nobuttons) : widget()\bar\fixed = Bool(fixed)*#__split_2
  s_2 = widget::Splitter(125, 170, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  ; first splitter
  s_3 = widget::Scroll(0, 0, 0, 0, 0,0,0, #__bar_nobuttons) : widget()\bar\fixed = Bool(fixed)*#__split_1 
  s_4 = widget::Scroll(0, 0, 0, 0, 0,0,0, #__bar_nobuttons) : widget()\bar\fixed = Bool(fixed)*#__split_2 
  ;Define *g._s_widget = s_4 : *g\bar\max = 250
   s_5 = widget::Splitter(125, 250, 250, 70, s_3, s_4, #PB_Splitter_Separator)
 
  s_6 = widget::Splitter(125, 170, 250, 70, s_2, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  s_7 = widget::Splitter(125, 250, 250, 70, s_5, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  SetState(s_6, 250)
  SetState(s_7, 250)
  
  SetState(s_0, -10)
  SetState(s_1, 250-10)
;   SetState(s_3, (250)/2)
;   SetState(s_4, 250/2)
 
  
   Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP