XIncludeFile "../../widgets.pbi" 

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
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Button(10,  10, Width/2-5, 65, "left&top"                     , #__flag_BorderFlat|#__flag_Left |#__flag_Top   )
      Button(10+Width/2+5,  10, Width/2-5, 65, "right&top"          , #__flag_BorderFlat|#__flag_Right|#__flag_Top   )
      Button(10,  10+65+10, Width/2-5, 65, "left&bottom"            , #__flag_BorderFlat|#__flag_Left |#__flag_Bottom)
      Button(10+Width/2+5,  10+65+10, Width/2-5, 65, "right&bottom" , #__flag_BorderFlat|#__flag_Right|#__flag_Bottom)
      
      Button(10, 160, Width/2-5, 65, "left"                         , #__flag_BorderFlat|#__flag_Left  )
      Button(10+Width/2+5, 160, Width/2-5, 65, "right"              , #__flag_BorderFlat|#__flag_Right )
      Button(10, 160+65+10, Width/2-5, 65, "top"                    , #__flag_BorderFlat|#__flag_Top   )
      Button(10+Width/2+5, 160+65+10, Width/2-5, 65, "bottom"       , #__flag_BorderFlat|#__flag_Bottom)
      
      Button(10, 310, Width, 65, "left&center"                      , #__flag_BorderFlat|#__flag_TextLeft  )
      Button(10, 310+65+10, Width, 65, "right&center"               , #__flag_BorderFlat|#__flag_TextRight )
      Button(10, 460, Width, 65, "top&center"                       , #__flag_BorderFlat|#__flag_TextTop   )
      Button(10, 460+65+10, Width, 65, "bottom&center"              , #__flag_BorderFlat|#__flag_TextBottom)
      
      Button(10, 610, Width, 140, "default"                          , #__flag_BorderFlat);|#__flag_ImageCenter)
      
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.46 LTS (MacOS X - x64)
; Folding = -
; EnableXP
; DPIAware