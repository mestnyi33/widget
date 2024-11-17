XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = 25 ; bug fixed
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetWidgetColor(root( ), #__color_back, $FFEFEFEF )
      a_init(root( ))
      
      Define *spin1 = SpinWidget(50, 20, 250, 50, 0, 30)
      SetState(*spin1, 0)
      
      Define *spin2 = SpinWidget(50, 80, 250, 50, min, 30, #__flag_Textcenter);|#__bar_invert)
      SetState(*spin2, 15)
      
      Define *spin3 = SpinWidget(50, 140, 250, 50, 0, 30, #__flag_Textright)
      SetState(*spin3, 30)
      
      WaitClose( )
   EndIf
   
   ;    ;\\ 
   ;    Define vertical = 0
   
   ;    ; SpinWidget( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
   ;    
   ;    If vertical
   ;       #PB_SpinBar_Vertical = #__bar_vertical
   ;       ;\\ vertical
   ;       If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;          
   ;          Define *spin1 = SpinWidget(20, 50, 50, 250,  0, 30, #PB_SpinBar_Vertical|#__bar_invert)
   ;          SetState(*spin1, 5)
   ;          
   ;          Define *spin2 = SpinWidget(80, 50, 50, 250,  5, 30, #PB_SpinBar_Vertical|#__flag_Textcenter)
   ;          SetState(*spin2, 10)
   ;          
   ;          Define *spin3 = SpinWidget(140, 50, 50, 250,  0, 30, #PB_SpinBar_Vertical)
   ;          SetState(*spin3, 5)
   ;          
   ;          
   ;          WaitClose( )
   ;       EndIf
   ;    Else
   ;       
   ;       ;\\ horizontal
   ;       If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ;          
   ;          Define *spin1 = SpinWidget(50, 20, 250, 50,  0, 30, #__bar_invert)
   ;          SetState(*spin1, 5)
   ;          
   ;          Define *spin2 = SpinWidget(50, 80, 250, 50,  5, 30, #__flag_Textcenter)
   ;          SetState(*spin2, 10)
   ;          
   ;          Define *spin3 = SpinWidget(50, 140, 250, 50,  0, 30, #__flag_Textright)
   ;          SetState(*spin3, 5)
   ;          
   ;          
   ;          WaitClose( )
   ;       EndIf
   ;    EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 4
; Folding = -
; EnableXP