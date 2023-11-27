
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   ;\\ test 1
   If Open(0, 0, 0, 350, 210, "Spin", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *spin1 = Spin(50, 20, 250, 50, 0, 30)
      Debug " ------ SetState"
      SetState(*spin1, 0)
      
      Define *spin2 = Spin(50, 80, 250, 50, 0, 30, #__flag_textcenter)
      SetState(*spin2, 15)
      
      Define *spin3 = Spin(50, 140, 250, 50, 0, 30, #__flag_textright)
      SetState(*spin3, 30)
      
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 11
; Folding = -
; EnableXP