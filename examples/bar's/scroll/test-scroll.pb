
XIncludeFile "../../../widgets.pbi" 
; ; 
Uselib(widget)

; Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )

;\\
If Open(0, 0, 0, 210, 350, "ScrollGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

  Define *spin1 = Scroll(20, 50, 50, 250,  0, 30, 0, #PB_ScrollBar_Vertical|#__flag_invert)
  SetState(*spin1, 0)
  
  Define *spin2 = Scroll(80, 50, 50, 250,  5, 30, 15, #PB_ScrollBar_Vertical)
  SetState(*spin2, 15)
  
  Define *spin3 = Scroll(140, 50, 50, 250,  30, 30, 0, #PB_ScrollBar_Vertical)
  SetState(*spin3, 30)
  
  
  WaitClose( )
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 16
; Folding = -
; EnableXP