
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
  ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   If MapSize( Root( ) ) > 0
      ;ForEach Root( )
         Free( Root( ) )
      ;Next
      
      Debug Root( )
      End
   Else
      End
   EndIf
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 3
; Folding = -
; EnableXP