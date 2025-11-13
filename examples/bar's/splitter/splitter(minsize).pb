;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *g1,*g2,*g3,*g4,*g5,*g6,*g7,*g8,*g9
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  ; first splitter
  TextGadget(1, 0, 0, 0, 0, "BTN1", #PB_Text_Border|#PB_Text_Center)
  TextGadget(2, 0, 0, 0, 0, "BTN2", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(3, 125, 10, 250, 40, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  SetGadgetAttribute( 3, #PB_Splitter_FirstMinimumSize, 50 )
  
  TextGadget(4, 0, 0, 0, 0, "BTN4", #PB_Text_Border|#PB_Text_Center)
  TextGadget(5, 0, 0, 0, 0, "BTN5", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(6, 125, 50, 250, 40, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
 
  TextGadget(7, 0, 0, 0, 0, "BTN7", #PB_Text_Border|#PB_Text_Center)
  TextGadget(8, 0, 0, 0, 0, "BTN8", #PB_Text_Border|#PB_Text_Center)
  SplitterGadget(9, 125, 90, 250, 40, 7, 8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  SetGadgetAttribute( 9, #PB_Splitter_SecondMinimumSize, 50 )
  
  If widget::Open(0, 0, 170, 510, 170)
     ; first splitter
     *g1 = widget::Button(0, 0, 0, 0, "BTN1")
     *g2 = widget::Button(0, 0, 0, 0, "BTN2")
     *g3 = widget::Splitter(125, 10, 250, 40, *g1, *g2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
     widget::SetAttribute( *g3, #PB_Splitter_FirstMinimumSize, 50 )
     
     *g4 = widget::Button(0, 0, 0, 0, "BTN4")
     *g5 = widget::Button(0, 0, 0, 0, "BTN5")
     *g6 = widget::Splitter(125, 50, 250, 40, *g4, *g5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
     
     *g7 = widget::Button(0, 0, 0, 0, "BTN7")
     *g8 = widget::Button(0, 0, 0, 0, "BTN8")
     *g9 = widget::Splitter(125, 90, 250, 40, *g7, *g8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
     widget::SetAttribute( *g9, #PB_Splitter_SecondMinimumSize, 50 )
  EndIf
  
  SetGadgetState(3, 30)
  SetGadgetState(6, 30)
  SetGadgetState(9, 250-30)
  
  widget::SetState(*g3, 30)
  widget::SetState(*g6, 30)
  widget::SetState(*g9, 250-30)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 53
; FirstLine = 19
; Folding = -
; EnableXP
; DPIAware