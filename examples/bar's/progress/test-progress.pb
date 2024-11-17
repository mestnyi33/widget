
XIncludeFile "../../../widgets.pbi" 
; ; 

EnableExplicit
UseWidgets( )

Define vertical = 0

; ProgressBarWidget( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
Define min = 25

If vertical
   ;\\ vertical
   If OpenRootWidget(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = ProgressBarWidget(20, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical|#__bar_invert)
      SetState(*spin1, 5)
      
      Define *spin2 = ProgressBarWidget(80, 50, 50, 250,  min, 30, #PB_ProgressBar_Vertical)
      SetState(*spin2, 29)
      
      Define *spin3 = ProgressBarWidget(140, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical, 30)
      SetState(*spin3, 5)
      
      
      WaitCloseRootWidget( )
   EndIf
Else
   
   ;\\ horizontal
   If OpenRootWidget(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = ProgressBarWidget(50, 20, 250, 50,  0, 30, #__bar_invert)
      SetState(*spin1, 5)
      
      Define *spin2 = ProgressBarWidget(50, 80, 250, 50,  min, 30)
      SetState(*spin2, 29)
      
      Define *spin3 = ProgressBarWidget(50, 140, 250, 50,  0, 30)
      SetState(*spin3, 5)
      
      
      WaitCloseRootWidget( )
   EndIf
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 7
; Folding = -
; EnableXP