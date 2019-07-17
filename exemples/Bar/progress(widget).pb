IncludePath "../../"
XIncludeFile "widgets.pbi"

;
; Module name   : ProgressBar
; Author        : mestnyi
; Last updated  : Dec 29, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  If OpenWindow(0, 0, 0, 605, 200, "ProgressBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget    (-1, 10,  20, 250, 20,"ProgressBar Standard  (50/100)", #PB_Text_Center)
    ProgressBarGadget(0, 10,  40, 250, 33, 0, 100)
    SetGadgetState(0, 50)
    TextGadget    (-1, 10, 100, 250, 20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
    ProgressBarGadget(1, 10, 120, 250, 20, 0, 200, #PB_ProgressBar_Smooth)
    SetGadgetState(1, 50)
    TextGadget    (-1,  50, 180, 240, 20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
    ProgressBarGadget(2, 270, 10, 20, 170, 0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState(2, 100)
    
    Open(0, 300,  5, 300, 190)
    
    TextGadget    (-1, 300+10,  20, 250, 20,"ProgressBar Standard  (50/100)", #PB_Text_Center)
    *p = Progress(10,  40, 250, 33, 0, 100)
    SetState(*p, 50)
    ;SetState(10, 100)
    TextGadget    (-1, 300+10, 100, 250, 20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
    *p1 = Progress(10, 120, 250, 20, 0, 200, #PB_ProgressBar_Smooth)
    SetState(*p1, 50)
    TextGadget    (-1,  300+50, 180, 240, 20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
    *p2.Widget_S = Progress(270, 10, 20, 170, 0, 300, #PB_ProgressBar_Vertical)
    SetState(*p2, 100)
    
    ReDraw(Root())
    
     Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If _scroll_in_start_(*p2)
          direction = 1
        EndIf
        If _scroll_in_stop_(*p2)
          direction =- 1
        EndIf
        
        value + direction
        
        If SetState(*p2, value)
          ReDraw(Root())
        EndIf
    EndSelect
    
  Until gQuit
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP