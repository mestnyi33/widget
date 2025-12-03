
XIncludeFile "../../../widgets.pbi" 
EnableExplicit
UseWidgets( )

;
; example demo resize draw splitter - OS gadgets   -bar
; 
CompilerIf #PB_Compiler_IsMainFile
   Define vertical = 0
   
   ; Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
   
   If vertical
      ;\\ vertical
      If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         Define *scroll1 = Scroll(20, 50, 50, 250,  0, 30, 0, #PB_ScrollBar_Vertical|#__flag_Invert)
         SetState(*scroll1, 5)
         
         Define *scroll2 = Scroll(80, 50, 50, 250,  5, 30, 15, #PB_ScrollBar_Vertical)
         SetState(*scroll2, 10)
         
         Define *scroll3 = Scroll(140, 50, 50, 250,  0, 30, 0, #PB_ScrollBar_Vertical)
         SetState(*scroll3, 5)
         
         
         WaitClose( )
      EndIf
   Else
      
      ;\\ horizontal
      If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         Define *scroll1 = Scroll(50, 20, 250, 50,  0, 30, 0, #__flag_Invert)
         SetState(*scroll1, 5)
         
         Define *scroll2 = Scroll(50, 80, 250, 50,  5, 30, 15, 0, 55)
         SetState(*scroll2, 10)
         
         Define *scroll3 = Scroll(50, 140, 250, 50,  0, 30, 0)
         SetState(*scroll3, 5)
         
         
         WaitClose( )
      EndIf
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware