;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global w_1,w_2,w_3,w_4,w_5,w_6,w_7,w_8,w_9,w_10,w_11,w_12,w_13,w_14,w_15
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetCanvasGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
    ResizeGadget(15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    Resize(w_15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
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
 
  ; first splitter
  w_1 = widget::Button(0, 0, 0, 0, "BTN1")
  w_2 = widget::Button(0, 0, 0, 0, "BTN2")
  w_3 = widget::Splitter(125, 140, 250, 40, w_1, w_2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)

  w_4 = widget::Button(0, 0, 0, 0, "BTN4")
  w_5 = widget::Button(0, 0, 0, 0, "BTN5")
  w_6 = widget::Splitter(125, 140+40, 250, 40, w_4, w_5, #PB_Splitter_Separator | #PB_Splitter_Vertical)

  w_7 = widget::Button(0, 0, 0, 0, "BTN7")
  w_8 = widget::Button(0, 0, 0, 0, "BTN8")
  w_9 = widget::Splitter(125, 140+80, 250, 40, w_7, w_8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  
  SetGadgetAttribute( 3, #PB_Splitter_FirstMinimumSize, 50 )
  SetGadgetAttribute( 9, #PB_Splitter_SecondMinimumSize, 50 )
  SetGadgetState(3, 30)
  SetGadgetState(6, 30)
  SetGadgetState(9, 250-30)
  
  widget::SetAttribute( w_3, #PB_Splitter_FirstMinimumSize, 50 )
  widget::SetAttribute( w_9, #PB_Splitter_SecondMinimumSize, 50 )
  widget::SetState(w_3, 30)
  widget::SetState(w_6, 30)
  widget::SetState(w_9, 250-30)
  

  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9
; FirstLine = 5
; Folding = -
; EnableXP