
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
  ;\\
   Open(1, 0, 0, 300, 200, "window_1", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   ;\\
   Open(2, 200, 100, 300, 200, "window_2", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   ;\\
   Open(3, 400, 200, 300, 200, "window_3", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 4
; Folding = -
; EnableXP