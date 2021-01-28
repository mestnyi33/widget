;
; example demo resize draw splitter - OS gadgets
; 

;XIncludeFile "../../../widgets.pbi"
XIncludeFile "../../../widgets-bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global s_1, s_2, s_3, s_4
  
  widget::Open(OpenWindow( #PB_Any, 10, 10, 510, 340, "TRACK-BAR", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu ))
  
  TrackBarGadget(1, 125, 40, 250, 20, 0, 250)
  TrackBarGadget(2, 125, 10+60, 250, 20, 0, 250)
  TrackBarGadget(3, 125, 10+90, 250, 20, 0, 250)
  TrackBarGadget(4, 125, 10+120, 250, 20, 0, 250)
  
  SetGadgetState(1, -10)
  SetGadgetState(2, 250-10)
  SetGadgetState(3, 250/2)
  SetGadgetState(4, 10)
  
  
  s_1 = widget::Track(125, 150+40, 250, 20,0,250)
  s_2 = widget::Track(125, 150+10+60, 250, 20,0,250)
  s_3 = widget::Track(125, 150+10+90, 250, 20,0,250)
  s_4 = widget::Track(125, 150+10+120, 250, 20,0,250)
  
  SetState(s_1, -10)
  SetState(s_2, 250-10)
  SetState(s_3, 250/2)
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