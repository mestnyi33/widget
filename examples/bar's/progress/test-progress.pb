
XIncludeFile "../../../widgets.pbi" 
; ; 

EnableExplicit
UseWidgets( )

Define vertical = 0

; Progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
Define min = 25

If vertical
   ;\\ vertical
   If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = Progress(20, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical|#__flag_Invert)
      SetState(*spin1, 5)
      
      Define *spin2 = Progress(80, 50, 50, 250,  min, 30, #PB_ProgressBar_Vertical)
      SetState(*spin2, 29)
      
      Define *spin3 = Progress(140, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical, 30)
      SetState(*spin3, 5)
      
      
      WaitClose( )
   EndIf
Else
   
   ;\\ horizontal
   If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = Progress(50, 20, 250, 50,  0, 30, #__flag_Invert)
      SetState(*spin1, 5)
      
      Define *spin2 = Progress(50, 80, 250, 50,  min, 30)
      SetState(*spin2, 29)
      
      Define *spin3 = Progress(50, 140, 250, 50,  0, 30)
      SetState(*spin3, 5)
      
      
      WaitClose( )
   EndIf
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 33
; FirstLine = 12
; Folding = -
; EnableXP