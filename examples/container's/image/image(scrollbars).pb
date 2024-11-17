IncludePath "../../../"
XIncludeFile "widgets.pbi"

UseWidgets( )

Global *w._S_widget

If Open(0, 100, 50, 400, 500, "ListViewGadget", #PB_Window_SystemMenu)
  LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
  
  *w = Image(10, 10, 380, 380, (0)) 
  
  ; Debug " - test show and size scroll bars - "
  ; ResizeWidget(*w,#PB_Ignore,#PB_Ignore,256,256 )
  ; ResizeWidget(*w,#PB_Ignore,#PB_Ignore,#PB_Ignore,255 )
  ; ResizeWidget(*w,#PB_Ignore,#PB_Ignore,255,#PB_Ignore )
  ; ResizeWidget(*w,#PB_Ignore,#PB_Ignore,255,255 )
  
  WaitClose()
EndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware