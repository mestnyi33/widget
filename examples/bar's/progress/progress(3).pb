;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global s_0, s_1, s_2, s_3, s_4, s_5
  
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
  
  ; first splitter
  ProgressBarGadget(3, 0, 0, 0, 0, 0, 250, 0)
  
  ProgressBarGadget(6, 0, 0, 0, 0, 0, 250, 0)
  SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  ProgressBarGadget(31, 0, 0, 0, 0, 0, 250, 0)
  
  ProgressBarGadget(61, 0, 0, 0, 0, 0, 250, 0)
  SplitterGadget(71, 125, 80, 250, 70, 31, 61, #PB_Splitter_Separator )
  
  SetGadgetState(3, -10)
  SetGadgetState(6, 250-10)
  SetGadgetState(31, 250/2)
  SetGadgetState(61, 10)
  
  
  ; first splitter
  s_0 = widget::Progress(0, 0, 0, 0, 0,250,0)
  s_1 = widget::Progress(0, 0, 0, 0, 0,250,0)
  s_2 = widget::Splitter(125, 170, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  ; first splitter
  s_3 = widget::Progress(0, 0, 0, 0, 0,250,0)
  
  s_4 = widget::Progress(0, 0, 0, 0, 0,250,0)
  s_5 = widget::Splitter(125, 250, 250, 70, s_3, s_4, #PB_Splitter_Separator)
  
  SetState(s_0, -10)
  SetState(s_1, 250-10)
  SetState(s_3, 250/2)
  SetState(s_4, 10)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP