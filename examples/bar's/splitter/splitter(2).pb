;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *w_1,*w_2,*w_3,*w_4,*w_5,*w_6,*w_7
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
;     ResizeGadget(3, #pb_Ignore, #pb_Ignore, width - 250, #pb_Ignore)
;     ResizeGadget(6, #pb_Ignore, #pb_Ignore, width - 250, #pb_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    
    ResizeGadget(GetCanvasGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeWidget(*w_3, #pb_Ignore, #pb_Ignore, width - 250, #pb_Ignore)
;     ResizeWidget(*w_6, #pb_Ignore, #pb_Ignore, width - 250, #pb_Ignore)
    ResizeWidget(*w_7, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  widget::OpenRoot(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  ; first splitter
  ButtonGadget(1, 0,0,0,0, "BTN1")
  ButtonGadget(2, 0,0,0,0, "BTN2")
  SplitterGadget(3, 0,0,0,0, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  ButtonGadget(4, 0,0,0,0, "BTN4")
  ButtonGadget(5, 0,0,0,0, "BTN5")
  SplitterGadget(6, 0,0,0,0, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  
  
  
  ; first splitter
  *w_1 = widget::ButtonWidget(0,0,0,0, "BTN1")
  *w_2 = widget::ButtonWidget(0,0,0,0, "BTN2")
  *w_3 = widget::SplitterWidget(0,0,0,0, *w_1, *w_2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)

  *w_4 = widget::ButtonWidget(0,0,0,0, "BTN4")
  *w_5 = widget::ButtonWidget(0,0,0,0, "BTN5")
  *w_6 = widget::SplitterWidget(0,0,0,0, *w_4, *w_5, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;
  *w_7 = widget::SplitterWidget(125, 170, 250, 70, *w_3, *w_6, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  
  
  WaitCloseRoot( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9
; FirstLine = 5
; Folding = -
; EnableXP