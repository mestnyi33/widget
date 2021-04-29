;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global i, s_0, s_1, s_2, s_3, s_4, s_5, s_6,s_7
  
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
  
  OpenWindow(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::Open(0);, 0, 0, 510, 340)
  
  ; first splitter
  s_0 = widget::Tab(0, 0, 0, 0)
  For i=0 To 3
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  s_1 = widget::Tab(0, 0, 0, 0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  s_2 = widget::Splitter(300, 30, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  ; first splitter
  s_3 = widget::Tab(0, 0, 0, 0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_rrrrrrrr"+Str(i))
  Next
  
  s_4 = widget::Tab(0, 0, 0, 0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  s_5 = widget::Splitter(300, 110, 250, 70, s_3, s_4, #PB_Splitter_Separator)
  
  
  s_6 = widget::Splitter(300, 30, 250, 70, s_2, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  s_7 = widget::Splitter(300, 110, 250, 70, s_5, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  SetState(s_6, 250)
  SetState(s_7, 250)
  
   
  widget::Tab(30, 30, 250, 30)
  For i=0 To 10
    widget::AddItem(widget( ), -1, "Tab "+Str(i))
  Next
  widget::Tab_SetState(widget(), 6)
  
  widget::Panel(30, 70, 250, 110)
  For i=0 To 10
    widget::AddItem(widget(), -1, "Sub "+Str(i))
  Next
  widget::CloseList()
  widget::SetState(widget(), 6)
  
  ;   SetState(s_0, -10)
  ;   SetState(s_1, 250-10)
  ;   SetState(s_3, 250/2)
  ;   SetState(s_4, 10)
  
  Tab_SetState(s_0, -1)
  Tab_SetState(s_1, 9)
  Tab_SetState(s_3, 6)
  Tab_SetState(s_4, 1)
  
  WaitClose( )
;   Define event
;   Repeat
;     event = WaitWindowEvent()
;   Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP