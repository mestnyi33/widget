;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *w_1,*w_2,*w_3,*w_4,*w_5,*w_6,*w_7,*w_8,*w_9,*w_10,*w_11,*w_12,*w_13,*w_14,*w_15
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
    ResizeGadget(15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    Resize(*w_15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::Open(0);, 0, 0, 510, 340)
  
  ; first splitter
  TextGadget(1, 0, 0, 0, 0, "BTN1", #PB_Text_Border|#PB_Text_Center)
  TextGadget(2, 0, 0, 0, 0, "BTN2", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(3, 125, 10, 250, 40, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  TextGadget(4, 0, 0, 0, 0, "BTN4", #PB_Text_Border|#PB_Text_Center)
  TextGadget(5, 0, 0, 0, 0, "BTN5", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(6, 125, 10+40, 250, 40, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  
  TextGadget(7, 0, 0, 0, 0, "BTN7", #PB_Text_Border|#PB_Text_Center)
  TextGadget(8, 0, 0, 0, 0, "BTN8", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(9, 125, 10+80, 250, 40, 7, 8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  
  SplitterGadget(10, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  TextGadget(11, 0, 0, 0, 0, "BTN11", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(12, 125, 10, 250, 70, 10, 9, #PB_Splitter_Separator ) 
  SplitterGadget(13, 125, 10, 250, 150, 11, 12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
;   ; second splitter
;   TextGadget(14, 0, 0, 0, 0, "BTN14", #PB_Text_Border|#PB_Text_Center)
;   SplitterGadget(15, 125, 10, 250, 150, 13, 14, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
;   
; ;   SetGadgetState(12, 43)
SetGadgetState(13, 30)
; ;   SetGadgetState(15, 250-30-9)
 
  ; first splitter
  *w_1 = widget::Button(0, 0, 0, 0, "BTN1")
  *w_2 = widget::Button(0, 0, 0, 0, "BTN2")
  *w_3 = widget::Splitter(125, 170, 250, 40, *w_1, *w_2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)

  *w_4 = widget::Button(0, 0, 0, 0, "BTN4")
  *w_5 = widget::Button(0, 0, 0, 0, "BTN5")
  *w_6 = widget::Splitter(125, 170+40, 250, 40, *w_4, *w_5, #PB_Splitter_Separator | #PB_Splitter_Vertical)

  *w_7 = widget::Button(0, 0, 0, 0, "BTN7")
  *w_8 = widget::Button(0, 0, 0, 0, "BTN8")
  *w_9 = widget::Splitter(125, 170+80, 250, 40, *w_7, *w_8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  
  *w_10 = widget::Splitter(125, 170, 250, 70, *w_3, *w_6, #PB_Splitter_Separator)
  
  ; first splitter
  *w_11 = widget::Button(0, 0, 0, 0, "BTN11")
  *w_12 = widget::Splitter(125, 170, 250, 70, *w_10, *w_9, #PB_Splitter_Separator)
  *w_13 = widget::Splitter(125, 170, 250, 150, *w_11, *w_12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
;   ; second splitter
;   *w_14 = widget::Button(0, 0, 0, 0, "BTN14")
;   *w_15 = widget::Splitter(125, 170, 250, 150, *w_13, *w_14, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  
                  
   widget::SetState(*w_13, 30)
;   
;   ;widget::SetState(*w_15, 250-30-#__splittersize)
;   widget::SetState(*w_12, 43)
;   widget::SetState(*w_15, -30)
  
; ;   Debug GetGadgetState(13)
; ;   Debug GetGadgetState(15)
; ;   
; ;   Debug GadgetWidth(11)
; ;   Debug GadgetWidth(14)
; ;   
; ;   Debug ""
; ;   Debug widget::GetState(*w_13)
; ;   Debug widget::GetState(*w_15)
; ;   
; ;   Debug widget::Width(*w_11)
; ;   Debug widget::Width(*w_14)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 95
; FirstLine = 78
; Folding = -
; Optimizer
; EnableXP
; DPIAware