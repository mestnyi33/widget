;
; example demo resize draw splitter - OS gadgets
; 

;XIncludeFile "../../../widgets.pbi"
XIncludeFile "../../../widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global w_1,w_2,w_3,w_4,w_5,w_6,w_7,w_8,w_9,w_10,w_11,w_12,w_13,w_14,w_15
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
    ResizeGadget(15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    Resize(w_15, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  Define auto = 1
  widget::Open(0);, 0, 0, 510, 340)
  
  ; first splitter
  ButtonGadget(1, 0, 0, 0, 0, "BTN1")
  ButtonGadget(2, 0, 0, 0, 0, "BTN2")
  If auto
    SplitterGadget(3, 0, 0, 0, 0, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  Else
    SplitterGadget(3, 125, 10, 250, 70, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  EndIf
  
  ButtonGadget(4, 0, 0, 0, 0, "BTN4")
  ButtonGadget(5, 0, 0, 0, 0, "BTN5")
  If auto
    SplitterGadget(6, 0, 0, 0, 0, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  Else
    SplitterGadget(6, 125, 90, 250, 70, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  EndIf
  
  ButtonGadget(7, 0, 0, 0, 0, "BTN7")
  ButtonGadget(8, 0, 0, 0, 0, "BTN8")
  If auto
    SplitterGadget(9, 0, 0, 0, 0, 7, 8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  Else
    SplitterGadget(9, 125, 90, 250, 70, 7, 8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  EndIf
  
  If auto
    SplitterGadget(10, 0, 0, 0, 0, 3, 6, #PB_Splitter_Separator )
  Else
    SplitterGadget(10, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
  EndIf
  
  ; first splitter
  ButtonGadget(11, 0, 0, 0, 0, "BTN1")
  SplitterGadget(12, 0, 0, 0, 0, 10, 9, #PB_Splitter_Separator ) 
  If auto
    SplitterGadget(13, 0, 0, 0, 0, 11, 12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  Else
    SplitterGadget(13, 0, 0, 250, 150, 11, 12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  EndIf
  ;SetGadgetState(12, 43)
  ;SetGadgetState(13, 30)
  
  ; second splitter
  ButtonGadget(14, 0, 0, 0, 0, "BTN14")
  SplitterGadget(15, 125, 10, 250, 150, 13, 14, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  ;   SplitterGadget(30,125, 10, 250, 150, 15, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator | #PB_Splitter_Vertical)
  ;   SetGadgetState(30, 250)
  
  SetGadgetState(15, 250-30-#__splitter_buttonsize)
  SetGadgetState(13, 30)
  
  
  ; first splitter
  w_1 = widget::Button(0, 0, 0, 0, "BTN1")
  w_2 = widget::Button(0, 0, 0, 0, "BTN2")
  If auto
    w_3 = widget::Splitter(0, 0, 0, 0, w_1, w_2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  Else
    w_3 = widget::Splitter(125, 170, 250, 40, w_1, w_2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  EndIf
  
  w_4 = widget::Button(0, 0, 0, 0, "BTN4")
  w_5 = widget::Button(0, 0, 0, 0, "BTN5")
  If auto
    w_6 = widget::Splitter(0, 0, 0, 0, w_4, w_5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  Else
    w_6 = widget::Splitter(125, 170+40, 250, 40, w_4, w_5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  EndIf
  
  w_7 = widget::Button(0, 0, 0, 0, "BTN7")
  w_8 = widget::Button(0, 0, 0, 0, "BTN8")
  If auto
    w_9 = widget::Splitter(0, 0, 0, 0, w_7, w_8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  Else
    w_9 = widget::Splitter(125, 170+80, 250, 40, w_7, w_8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  EndIf
  
  If auto
    w_10 = widget::Splitter(0, 0, 0, 0, w_3, w_6, #PB_Splitter_Separator)
  Else
    w_10 = widget::Splitter(125, 170, 250, 70, w_3, w_6, #PB_Splitter_Separator)
  EndIf
  
  ; first splitter
  w_11 = widget::Button(0, 0, 0, 0, "BTN11")
  If auto
    w_12 = widget::Splitter(0, 0, 0, 0, w_10, w_9, #PB_Splitter_Separator)
  Else
    w_12 = widget::Splitter(125, 170, 250, 70, w_10, w_9, #PB_Splitter_Separator)
  EndIf
  If auto
    w_13 = widget::Splitter(0, 0, 0, 0, w_11, w_12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  Else
    w_13 = widget::Splitter(0, 0, 250, 150, w_11, w_12, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  EndIf
  ;SetState(w_9, 43)
  
  ; second splitter
  w_14 = widget::Button(0, 0, 0, 0, "BTN14")
  w_15 = widget::Splitter(125, 170, 250, 150, w_13, w_14, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  
  ;   widget::Splitter(125, 170, 250, 150, w_15, 0, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  ;   widget::SetState(widget(), 250)
  ;   
  Define *this._s_widget = w_13
  ;*this\bar\max = 0
  Debug "max - "+*this\bar\max +" "+ *this\bar\page\pos +" "+ *this\bar\area\len +" "+ *this\bar\thumb\pos +" "+ Bool(*this\resize & #__resize_change)
  ;   *this\resize &~ #__resize_change
  ;   *this\bar\max = (*this\bar\area\len-*this\bar\thumb\len)
  ;   *this\bar\scroll_increment = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
  
  widget::SetState(w_13, 30)
  Debug "max - "+*this\bar\max +" "+ *this\bar\page\pos +" "+ *this\bar\area\len +" "+ *this\bar\thumb\pos +" "+ Bool(*this\resize & #__resize_change)
  ;widget::SetState(w_15, 250-30-#__splitter_buttonsize)
  widget::SetState(w_15, 250-30-#__splitter_buttonsize)
  
  
  
  Debug "get 13 state - "+GetGadgetState(13)
  Debug "get 15 state - "+GetGadgetState(15)
  
  Debug "get 11 width - "+GadgetWidth(11)
  Debug "get 14 width - "+GadgetWidth(14)
  
  Debug ""
  Debug "get 13 state - "+widget::GetState(w_13)
  Debug "get 15 state - "+widget::GetState(w_15)
  
  Debug "get 11 width - "+widget::Width(w_11)
  Debug "get 14 width - "+widget::Width(w_14)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP