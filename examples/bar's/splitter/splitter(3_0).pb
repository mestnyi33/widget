;
; example demo resize draw splitter - OS gadgets
; 
XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global b_0,b_1,b_2,s_0,b_2,b_3,s_1, s_2
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetCanvasGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeGadget(3, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     ResizeGadget(6, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    
;     ResizeWidget(s_0, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     ResizeWidget(s_1, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    ResizeWidget(s_2, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::OpenRoot(0);, 0, 0, 510, 340)
  
  ; first splitter
  ButtonGadget(1, 0, 0, 0, 0, "BTN1")
  ButtonGadget(2, 0, 0, 0, 0, "BTN2")
  SplitterGadget(3, 0, 0, 0, 0, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  
  ButtonGadget(4, 0, 0, 0, 0, "BTN3")
  ButtonGadget(5, 0, 0, 0, 0, "BTN4")
  SplitterGadget(6, 0, 0, 0, 0, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  
  ; first splitter
  ButtonGadget(11, 0, 0, 0, 0, "BTN1")
  ButtonGadget(21, 0, 0, 0, 0, "BTN2")
  SplitterGadget(31, 0, 0, 0, 0, 11, 21, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  
  ButtonGadget(41, 0, 0, 0, 0, "BTN3")
  ButtonGadget(51, 0, 0, 0, 0, "BTN4")
  SplitterGadget(61, 0, 0, 0, 0, 41, 51, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SplitterGadget(71, 125, 80, 250, 70, 31, 61, #PB_Splitter_Separator )
  
  SetGadGetWidgetState(3, -10)
  SetGadGetWidgetState(6, 250-10)
  SetGadGetWidgetState(31, 250/2)
  SetGadGetWidgetState(61, 10)
  
  
  ; first splitter
  b_0 = widget::ButtonWidget(0, 0, 0, 0, "BTN1")
  b_1 = widget::ButtonWidget(0, 0, 0, 0, "BTN2")
  s_0 = widget::SplitterWidget(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SetWidgetState(s_0, -10)
  
  b_2 = widget::ButtonWidget(0, 0, 0, 0, "BTN3")
  b_3 = widget::ButtonWidget(0, 0, 0, 0, "BTN4")
  s_1 = widget::SplitterWidget(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SetWidgetState(s_1, 250-10)
  s_2 = widget::SplitterWidget(125, 170, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  ; first splitter
  b_0 = widget::ButtonWidget(0, 0, 0, 0, "BTN1")
  b_1 = widget::ButtonWidget(0, 0, 0, 0, "BTN2")
  s_0 = widget::SplitterWidget(0, 0, 0, 0, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SetWidgetState(s_0, 250/2)
  
  b_2 = widget::ButtonWidget(0, 0, 0, 0, "BTN3")
  b_3 = widget::ButtonWidget(0, 0, 0, 0, "BTN4")
  s_1 = widget::SplitterWidget(0, 0, 0, 0, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical )
  SetWidgetState(s_1, 10)
  s_2 = widget::SplitterWidget(125, 250, 250, 70, s_0, s_1, #PB_Splitter_Separator)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; FirstLine = 4
; Folding = -
; EnableXP