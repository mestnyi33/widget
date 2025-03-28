﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_align = 1
   test_draw_area = 1
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
      ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
   
   Define Image = 1
   Define i, Width = 200
   
   If Open(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonImage(10,  10, Width, 65, Image, #__flag_border_Flat|#__image_Left|#__image_Top)
      ButtonImage(10,  10+65+10, Width, 65, Image, #__flag_border_Flat|#__image_Top|#__image_Right)
      ButtonImage(10, 160, Width, 65, Image, #__flag_border_Flat|#__image_Right|#__image_Bottom)
      ButtonImage(10, 160+65+10, Width, 65, Image, #__flag_border_Flat|#__image_Left|#__image_Bottom)
      
      ButtonImage(10, 310, Width, 65, Image, #__flag_border_Flat|#__image_Center|#__image_Left)
      ButtonImage(10, 310+65+10, Width, 65, Image, #__flag_border_Flat|#__image_Center|#__image_Top)
      ButtonImage(10, 460, Width, 65, Image, #__flag_border_Flat|#__image_Center|#__image_Right)
      ButtonImage(10, 460+65+10, Width, 65, Image, #__flag_border_Flat|#__image_Center|#__image_Bottom)
      
      ButtonImage(10, 610, Width, 140, Image, #__flag_border_Flat);|#__image_Center)
      
      For i=0 To 8
         SetAlign(ID(i), 0, 1,0,1,0)
      Next
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 29
; FirstLine = 17
; Folding = -
; EnableXP
; DPIAware