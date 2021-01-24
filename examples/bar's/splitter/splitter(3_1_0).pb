;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  Global len = 250
  Global b_0,b_1,b_2,b_2,b_3,s_0,s_1,s_2,s_3,s_4,s_5,s_6,s_7,s_8,s_9,s_10,s_11
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeGadget(3, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
;     ResizeGadget(6, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
    
;     Resize(s_0, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
;     Resize(s_1, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
    Resize(s_2, #PB_Ignore, #PB_Ignore, width - len, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340+140, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::Open(0);, 0, 0, 510, 340)
  Define fixed = 0
  
  ; first splitter
  ButtonGadget(1, 0, 0, 0, 0, "BTN1")
  ButtonGadget(2, 0, 0, 0, 0, "BTN2")
  SplitterGadget(3, 0, 0, 0, 0, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
  
  ButtonGadget(4, 0, 0, 0, 0, "BTN3")
  ButtonGadget(5, 0, 0, 0, 0, "BTN4")
  SplitterGadget(6, 0, 0, 0, 0, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
  SplitterGadget(7, 125, 10, len, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  ButtonGadget(11, 0, 0, 0, 0, "BTN1")
  ButtonGadget(21, 0, 0, 0, 0, "BTN2")
  SplitterGadget(31, 0, 0, 0, 0, 11, 21, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
  
  ButtonGadget(41, 0, 0, 0, 0, "BTN3")
  ButtonGadget(51, 0, 0, 0, 0, "BTN4")
  SplitterGadget(61, 0, 0, 0, 0, 41, 51, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
  SplitterGadget(71, 125, 80, len, 70, 31, 61, #PB_Splitter_Separator )
  
  ButtonGadget(111, 0, 0, 0, 0, "BTN1")
  ButtonGadget(211, 0, 0, 0, 0, "BTN2")
  SplitterGadget(311, 0, 0, 0, 0, 111, 211, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
  
  ButtonGadget(411, 0, 0, 0, 0, "BTN3")
  ButtonGadget(511, 0, 0, 0, 0, "BTN4")
  SplitterGadget(611, 0, 0, 0, 0, 411, 511, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
  SplitterGadget(711, 125, 80, len, 70, 311, 611, #PB_Splitter_Separator )
  
  SplitterGadget(66,125, 10, len, 70, 7, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
  SplitterGadget(77,125, 80, len, 70, 71, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
  SplitterGadget(88,125, 150, len, 70, 711, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
  
  SetGadgetAttribute( 31, #PB_Splitter_FirstMinimumSize, len/2 )
  SetGadgetAttribute( 61, #PB_Splitter_SecondMinimumSize, len/2 )
  
  SetGadgetState(66, len)
  SetGadgetState(77, len)
  SetGadgetState(88, len)
  
  
  SetGadgetState(3, -10)
  SetGadgetState(6, len-10)
  SetGadgetState(31, len/2)
  SetGadgetState(61, len/2)
  
  
  ; first splitter
  b_0 = widget::Button(0, 0, 0, 0, "BTN1")
  b_1 = widget::Button(0, 0, 0, 0, "BTN2")
  s_0 = widget::Splitter(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
  
  b_2 = widget::Button(0, 0, 0, 0, "BTN3")
  b_3 = widget::Button(0, 0, 0, 0, "BTN4")
  s_1 = widget::Splitter(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
  s_2 = widget::Splitter(125, 240, len, 70, s_0, s_1, #PB_Splitter_Separator)
  
; ;   ; first splitter
; ;   b_0 = widget::Button(0, 0, 0, 0, "BTN1")
; ;   b_1 = widget::Button(0, 0, 0, 0, "BTN2")
; ;   s_3 = widget::Splitter(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   
; ;   b_2 = widget::Button(0, 0, 0, 0, "BTN3")
; ;   b_3 = widget::Button(0, 0, 0, 0, "BTN4")
; ;   s_4 = widget::Splitter(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   s_5 = widget::Splitter(125, 320, len, 70, s_3, s_4, #PB_Splitter_Separator)
; ;   
; ;   ; first splitter
; ;   b_0 = widget::Button(0, 0, 0, 0, "BTN1")
; ;   b_1 = widget::Button(0, 0, 0, 0, "BTN2")
; ;   s_6 = widget::Splitter(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   
; ;   b_2 = widget::Button(0, 0, 0, 0, "BTN3")
; ;   b_3 = widget::Button(0, 0, 0, 0, "BTN4")
; ;   s_7 = widget::Splitter(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical | (Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   s_8 = widget::Splitter(125, 400, len, 70, s_6, s_7, #PB_Splitter_Separator)
  
  s_9 = widget::Splitter(125, 240, len, 70, s_2, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
; ;   s_10 = widget::Splitter(125, 320, len, 70, s_5, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
; ;   s_11 = widget::Splitter(125, 400, len, 70, s_8, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
; ;   
; ;   widget::SetAttribute( s_3, #PB_Splitter_FirstMinimumSize, len/2 )
; ;   widget::SetAttribute( s_4, #PB_Splitter_SecondMinimumSize, len/2 )
    
 ; ;   SetState(s_10, len)
; ;   SetState(s_11, len)
  SetState(s_9, len)
 
  SetState(s_0, -10)
  SetState(s_1, len-10-9)
  
; ;   SetState(s_3, 50)
; ;   SetState(s_4, -50)
  
; ;   SetState(s_6, len/2)
; ;   SetState(s_7, len/2)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP