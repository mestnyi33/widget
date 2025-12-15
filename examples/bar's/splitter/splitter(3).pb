;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global b_0,b_1,b_2,b_2,b_3, s_0,s_1,s_2,s_3,s_4,s_5
  
  Procedure resize_window_0()
    Protected Width = WindowWidth(EventWindow())-10
    ; ResizeGadget(GetCanvasGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeGadget(3, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     ResizeGadget(6, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, Width - 250, #PB_Ignore)
    
;     Resize(s_0, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     Resize(s_1, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    If Resize(s_2, #PB_Ignore, #PB_Ignore, Width - 250, #PB_Ignore)
       PostRepaint( )
    EndIf
 EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  Widget::Open(0);, 0, 0, 510, 340)
  
  ; first splitter
  ButtonGadget(1, 0, 0, 0, 0, "BTN1")
  ButtonGadget(2, 0, 0, 0, 0, "BTN2")
  SplitterGadget(3, 0, 0, 0, 0, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  ButtonGadget(4, 0, 0, 0, 0, "BTN3")
  ButtonGadget(5, 0, 0, 0, 0, "BTN4")
  SplitterGadget(6, 0, 0, 0, 0, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  ButtonGadget(11, 0, 0, 0, 0, "BTN1")
  ButtonGadget(21, 0, 0, 0, 0, "BTN2")
  SplitterGadget(31, 0, 0, 0, 0, 11, 21, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  ButtonGadget(41, 0, 0, 0, 0, "BTN3")
  ButtonGadget(51, 0, 0, 0, 0, "BTN4")
  SplitterGadget(61, 0, 0, 0, 0, 41, 51, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  SplitterGadget(71, 125, 80, 250, 70, 31, 61, #PB_Splitter_Separator )
  
  Define max = 250-#__bar_splitter_size
  SetGadgetState(3, -10)
  SetGadgetState(6, max-10)
  SetGadgetState(31, max/2)
  SetGadgetState(61, 10)
  
  
  ; first splitter
  b_0 = Widget::Button(0, 0, 0, 0, "BTN1")
  b_1 = Widget::Button(0, 0, 0, 0, "BTN2")
  s_0 = Widget::Splitter(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  b_2 = Widget::Button(0, 0, 0, 0, "BTN3")
  b_3 = Widget::Button(0, 0, 0, 0, "BTN4")
  s_1 = Widget::Splitter(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  s_2 = Widget::Splitter(125, 170, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  ; first splitter
  b_0 = Widget::Button(0, 0, 0, 0, "BTN1")
  b_1 = Widget::Button(0, 0, 0, 0, "BTN2")
  s_3 = Widget::Splitter(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  b_2 = Widget::Button(0, 0, 0, 0, "BTN3")
  b_3 = Widget::Button(0, 0, 0, 0, "BTN4")
  s_4 = Widget::Splitter(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  s_5 = Widget::Splitter(125, 250, 250, 70, s_3, s_4, #PB_Splitter_Separator)
  
  SetState(s_0, -10)
  SetState(s_1, max-10)
  SetState(s_3, max/2)
  SetState(s_4, 10)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 14
; Folding = -
; EnableXP
; DPIAware