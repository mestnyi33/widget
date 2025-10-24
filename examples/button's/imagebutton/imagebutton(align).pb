XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_align = 1
   test_draw_area = 1
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
   
   Define Image = 1
   Define i, Width = 250
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonImage(10,  10, Width/2-5, 65, (1)                 , #__flag_BorderFlat|#__flag_Left |#__flag_Top)
      ButtonImage(10+Width/2+5,  10, Width/2-5, 65, (1)       , #__flag_BorderFlat|#__flag_Right|#__flag_Top)
      ButtonImage(10,  10+65+10, Width/2-5, 65, (1)           , #__flag_BorderFlat|#__flag_Left |#__flag_Bottom)
      ButtonImage(10+Width/2+5,  10+65+10, Width/2-5, 65, (1) , #__flag_BorderFlat|#__flag_Right|#__flag_Bottom)
      
      ButtonImage(10, 160, Width/2-5, 65, (1)                 , #__flag_BorderFlat|#__flag_Left  )
      ButtonImage(10+Width/2+5, 160, Width/2-5, 65, (1)       , #__flag_BorderFlat|#__flag_Right )
      ButtonImage(10, 160+65+10, Width/2-5, 65, (1)           , #__flag_BorderFlat|#__flag_Top   )
      ButtonImage(10+Width/2+5, 160+65+10, Width/2-5, 65, (1) , #__flag_BorderFlat|#__flag_Bottom)
      
      ButtonImage(10, 310, Width, 65, (1)                     , #__flag_BorderFlat|#__flag_ImageLeft  )
      ButtonImage(10, 310+65+10, Width, 65, (1)               , #__flag_BorderFlat|#__flag_ImageRight )
      ButtonImage(10, 460, Width, 65, (1)                     , #__flag_BorderFlat|#__flag_ImageTop   )
      ButtonImage(10, 460+65+10, Width, 65, (1)               , #__flag_BorderFlat|#__flag_ImageBottom)
      
      ButtonImage(10, 610, Width, 140, (1)                    , #__flag_BorderFlat);|#__flag_ImageCenter)
      
      
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 43
; FirstLine = 6
; Folding = -
; EnableXP
; DPIAware