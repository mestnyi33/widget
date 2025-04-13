XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   UseWidgets( )
   
   If Open(0, 0, 0, 300, 200, "Option", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetBackColor(root(), $FFFFFF)
      ;SetWindowColor(0, $FFFFFF)
   
      frm_10 = Frame(10, 5, 130, 100, "Grp1", #__flag_transparent)
      opt_1 = Option(30, 25, 80, 20, "Option 1")
      opt_2 = Option(30, 50, 80, 20, "Option 2")
      opt_3 = Option(30, 75, 80, 20, "Option 3")
      
      frm_11 = Frame(150, 5, 130, 100, "Grp2")
      opt_4 = Option(170, 25, 80, 20, "Option 4")
      opt_5 = Option(170, 50, 80, 20, "Option 5")
      opt_6 = Option(170, 75, 80, 20, "Option 6")
      
      SetState(opt_2, 1)   ; set second option as active one
      SetActive(opt_2)
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware