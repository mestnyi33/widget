
XIncludeFile "../../../widgets.pbi" 
; ; 
Uselib(widget)
Define vertical = 1

; Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )

If vertical
   ;\\ vertical
   If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = Track(20, 50, 50, 250,  0, 30, #PB_TrackBar_Vertical|#__flag_invert)
      SetState(*spin1, 5)
      
      Define *spin2 = Track(80, 50, 50, 250,  25, 30, #PB_TrackBar_Vertical)
      SetState(*spin2, 10)
      
      Define *spin3 = Track(140, 50, 50, 250,  0, 30, #PB_TrackBar_Vertical)
      SetState(*spin3, 5)
      
      
      WaitClose( )
   EndIf
Else
   
   ;\\ horizontal
   If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = Track(50, 20, 250, 50,  0, 30, #__flag_invert)
      SetState(*spin1, 5)
      
      Define *spin2 = Track(50, 80, 250, 50,  5, 30)
      SetState(*spin2, 10)
      
      Define *spin3 = Track(50, 140, 250, 50,  0, 30)
      SetState(*spin3, 5)
      
      
      WaitClose( )
   EndIf
EndIf


; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP