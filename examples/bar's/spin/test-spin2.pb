XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = 25 ; bug fixed
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #pb_gadget_backcolor, $FFEFEFEF )
      a_init(root( ))
      
      Define *spin1 = Spin(50, 20, 250, 50, 0, 30, #__flag_invert)
      SetState(*spin1, 0)
      
      Define *spin2 = Spin(50, 80, 250, 50, min, 30, #__flag_vertical);|#__flag_invert)
       ;Define *spin2 = Create( root( ), "Spin", #__type_Spin, 0, 0, 0, 0, #Null$, #__flag_vertical|#__flag_invert, -1000, 1000, 0, #__bar_button_size, 0, 7 )
      SetState(*spin2, 15)
      
      Define *spin3 = Spin(50, 140, 250, 50, 0, 30, #__text_Right)
      SetState(*spin3, 30)
      
      WaitClose( )
   EndIf

CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; Folding = -
; EnableXP
; DPIAware