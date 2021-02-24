;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global s_1, s_2, s_3, s_4
  
  widget::Open(OpenWindow( #PB_Any, 10, 10, 510, 340, "TRACK-BAR", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu ))
  Define max = 30
  TrackBarGadget(1, 125, 40, 250, 20, 0, max, #PB_TrackBar_Ticks)
  TrackBarGadget(2, 125, 10+60, 250, 20, 0, max/2, #PB_TrackBar_Ticks)
  TrackBarGadget(3, 125, 10+90, 250, 20, 0, max, #PB_TrackBar_Ticks)
  TrackBarGadget(4, 125, 10+120, 250, 20, 0, max*2, #PB_TrackBar_Ticks)
  
  SetGadgetState(1, -10)
  SetGadgetState(2, max/2-10)
  SetGadgetState(3, max/2)
  SetGadgetState(4, 10)
  
  
  s_1 = widget::Track(125, 150+40, 250, 20,0,max, #PB_TrackBar_Ticks|#__bar_invert)
  s_2 = widget::Track(125, 150+10+60, 250, 20,0,max/2, #PB_TrackBar_Ticks)
  s_3 = widget::Track(125, 150+10+90, 250, 20,0,max, #PB_TrackBar_Ticks)
  s_4 = widget::Track(125, 150+10+120, 250, 20,0,max*2, #PB_TrackBar_Ticks)
  
  SetState(s_1, -10)
  SetState(s_2, max/2-10)
  SetState(s_3, max/2)
  SetState(s_4, 10)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP