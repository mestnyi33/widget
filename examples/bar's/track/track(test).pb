; commit 1403 tested
XIncludeFile "../../../widgets.pbi" 
; ; 
Uselib(widget)

; Track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )

Define *g, min = 25, vertical = 0

If vertical
   ;\\ vertical
   If Open(0, 0, 0, 230, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g = Track(45, 50, 20, 250,  0, 30, #PB_TrackBar_Vertical | #__bar_invert | #PB_TrackBar_Ticks)
      SetState(*g, 5)
      
      *g = Track(85, 50, 20, 250,  min, 30, #PB_TrackBar_Vertical | #__bar_invert)
      SetState(*g, 29)
      
      *g = Track(125, 50, 20, 250,  min, 30, #PB_TrackBar_Vertical)
      SetState(*g, 29)
      
      *g = Track(165, 50, 20, 250,  0, 30, #PB_TrackBar_Vertical | #PB_TrackBar_Ticks)
      SetState(*g, 5)
      
      WaitClose( )
   EndIf
Else
   ;\\ horizontal
   If Open(0, 0, 0, 350, 230, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g = Track(50, 45, 250, 20,  0, 30, #__bar_invert | #PB_TrackBar_Ticks)
      SetState(*g, 5)
      
      *g = Track(50, 85, 250, 20,  min, 30, #__bar_invert)
      SetState(*g, 29)
      
      *g = Track(50, 125, 250, 20,  min, 30)
      SetState(*g, 29)
      
      *g = Track(50, 165, 250, 20,  0, 30, #PB_TrackBar_Ticks)
      SetState(*g, 5)
      
      
      WaitClose( )
   EndIf
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 34
; FirstLine = 13
; Folding = -
; EnableXP
; DPIAware