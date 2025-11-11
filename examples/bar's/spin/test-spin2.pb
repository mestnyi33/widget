XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
  
   ;\\ 
   Define vertical = 1
   
   ; Spin( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
   
   If vertical
      ;\\ vertical
      If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         Define *spin1 = Spin(20, 50, 50, 250,  0, 30, #__flag_Vertical|#__flag_Invert)
         SetState(*spin1, 5)
         
         Define *spin2 = Spin(80, 50, 50, 250,  5, 30, #__flag_Vertical|#__flag_TextCenter)
         SetState(*spin2, 10)
         
         Define *spin3 = Spin(140, 50, 50, 250,  0, 30, #__flag_Vertical)
         SetState(*spin3, 5)
         
         
         WaitClose( )
      EndIf
   Else
      
      ;\\ horizontal
      If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         Define *spin1 = Spin(50, 20, 250, 50,  0, 30, #__flag_Invert)
         SetState(*spin1, 5)
         
         Define *spin2 = Spin(50, 80, 250, 50,  5, 30, #__flag_Vertical|#__flag_TextCenter)
         SetState(*spin2, 10)
         
         Define *spin3 = Spin(50, 140, 250, 50,  0, 30, #__flag_TextRight)
         SetState(*spin3, 5)
         
         
         WaitClose( )
      EndIf
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 7
; FirstLine = 7
; Folding = -
; EnableXP
; DPIAware