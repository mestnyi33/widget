﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define min = 25 ; bug fixed
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root( ), #pb_gadget_backcolor, $FFEFEFEF )
      a_init(root( ))
      
      Define *spin1 = SpinGadget(#PB_Any, 50, 20, 250, 50, -30, 30, #PB_Spin_Numeric|#PB_Spin_ReadOnly )
      ;SetGadgetState(*spin1, 0)
      
      Define *spin2 = Spin(50, 80, 250, 50, -30, 30, #__flag_text_Right)
      ;SetState(*spin2, 0)
      
      WaitClose( )
   EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; Folding = -
; EnableXP
; DPIAware