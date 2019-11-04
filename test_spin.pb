;IncludePath "../"
XIncludeFile "widgets().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  Define Event
  
  If Open(-1, 330, 220, 140, 70, "SpinGadget", #PB_Flag_BorderLess|#PB_Window_SystemMenu )
    Spin     (20, 20, 100, 25, 0, 20)
    SetState (widget(), 5) ;: SetText(widget(), "5")   ; set initial value
    
    redraw(root())
  EndIf
  
  If OpenWindow(0, 0, 0, 140, 70, "SpinGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SpinGadget     (0, 20, 20, 100, 25, 0, 20)
    SetGadgetState (0, 5) : SetGadgetText(0, "5")   ; set initial value
    Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
        If EventGadget() = 0
          SetGadgetText(0, Str(GetGadgetState(0)))
        EndIf
      EndIf
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP