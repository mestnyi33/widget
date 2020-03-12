CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget";/widgets()"
  XIncludeFile "fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget/widgets()"
CompilerEndIf

XIncludeFile "elements.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(bar)
  
  Global b_0,b_1,b_2,s_0,s_1
  
  OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  
  Canvas(0);, 0, 0, 510, 340)
  
  ; first splitter
  ButtonGadget(11, 0, 0, 0, 0, "BTN1")
  ButtonGadget(22, 0, 0, 0, 0, "BTN2")
  SplitterGadget(99, 0, 0, 250, 150, 11, 22, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
  
  ; second splitter
  ButtonGadget(33, 0, 0, 0, 0, "BTN3")
  SplitterGadget(98, 125, 10, 250, 150, 99, 33, #PB_Splitter_Separator | #PB_Splitter_Vertical)
  
  SetGadgetState(99, 30)
  SetGadgetState(98, 250-30-9)
  
  
  ; first splitter
  b_0 = Button(0, 0, 0, 0, "BTN1")
  b_1 = Button(0, 0, 0, 0, "BTN2")
  s_0 = Splitter(0, 0, 250, 150, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_FirstFixed)
  
  ; second splitter
  b_2 = Button(0, 0, 0, 0, "BTN3")
  s_1 = Splitter(125, 170, 250, 150, s_0, b_2, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_SecondFixed)
  
;   SetState(s_0, 30+7/2)
;   SetState(s_1, 250-30-7-7/2+2)
  SetState(s_1, 250-30-#__splitter_buttonsize)
  SetState(s_0, 30)
  
  Debug GetGadgetState(99)
  Debug GetGadgetState(98)
  
  Debug GetState(s_0)
  Debug GetState(s_1)
  
  Debug ""
  Debug GadgetWidth(11)
  Debug GadgetWidth(33)
  
  Debug Width(b_0)
  Debug Width(b_2)
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP