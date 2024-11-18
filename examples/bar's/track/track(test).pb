; commit 1403 tested
XIncludeFile "../../../widgets.pbi" 
; ; 
UseWidgets( )

; TrackBarWidget( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )

Define *g, min = 25, vertical = 0

If vertical
   ;\\ vertical
   If OpenRoot(0, 0, 0, 230, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g = TrackBarWidget(45, 50, 20, 250,  0, 30, #PB_TrackBar_Vertical | #__bar_invert | #PB_TrackBar_Ticks)
      SetWidgetState(*g, 5)
      
      *g = TrackBarWidget(85, 50, 20, 250,  min, 30, #PB_TrackBar_Vertical | #__bar_invert)
      SetWidgetState(*g, 29)
      
      *g = TrackBarWidget(125, 50, 20, 250,  min, 30, #PB_TrackBar_Vertical)
      SetWidgetState(*g, 29)
      
      *g = TrackBarWidget(165, 50, 20, 250,  0, 30, #PB_TrackBar_Vertical | #PB_TrackBar_Ticks)
      SetWidgetState(*g, 5)
      
      WaitCloseRoot( )
   EndIf
Else
   ;\\ horizontal
   If OpenRoot(0, 0, 0, 350, 230, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g = TrackBarWidget(50, 45, 250, 20,  0, 30, #__bar_invert | #PB_TrackBar_Ticks)
      SetWidgetState(*g, 5)
      
      *g = TrackBarWidget(50, 85, 250, 20,  min, 30, #__bar_invert)
      SetWidgetState(*g, 29)
      
      *g = TrackBarWidget(50, 125, 250, 20,  min, 30)
      SetWidgetState(*g, 29)
      
      *g = TrackBarWidget(50, 165, 250, 20,  0, 30, #PB_TrackBar_Ticks)
      SetWidgetState(*g, 5)
      
      
      WaitCloseRoot( )
   EndIf
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware