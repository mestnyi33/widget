
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  Declare CallBack( )
  
  ;\\
  Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_0_root" )
  Button(10,10,200,50,"Button_0")
  SetClass(widget( ), "Button_0" )
  
  ;\\
  Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_1_root" )
  Button(10,10,200,50,"Button_1")
  SetClass(widget( ), "Button_1" )
  
  ;\\
  Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_2_root" )
  Button(10,10,200,50,"Button_2")
  SetClass(widget( ), "Button_2" )
  
  
  ;\\
  ForEach enumRoot( )
     Debug enumRoot( )\class
  Next
  
  ; Close( #PB_All )
  
  ;\\
  WaitClose( Root( ) )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 46
; FirstLine = 10
; Folding = -
; EnableXP