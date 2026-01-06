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
   Define i, Width = 200
   
   Procedure TestAlign( X,Y,Width,Height, img, flags=0 )
      Protected._s_WIDGET *g
      Protected txt$ = "text"
      
      If flags & #__flag_Center
         flags &~ #__flag_Center
         flags | #__align_image
      EndIf
      
      *g = Button( X,Y,Width,Height, txt$, flags) : Setimage( *g, img )
      ;*g = ButtonImage( X,Y,Width,Height, img, flags) : SetText( *g, txt$ )
      ;*g = Image( X,Y,Width,Height, img, flags) : SetText( *g, txt$ )
      
      Alignment( *g, #__align_left|#__align_right)
   EndProcedure
   
   
   If Open(0, 0, 0, Width + 20, 535, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;
      TestAlign(10, 10,  Width, 65, Image , #__flag_Left  )
      ;
      TestAlign(10, 85,  Width, 65, Image , #__flag_Center|#__flag_Left  )
      TestAlign(10, 160, Width, 65, Image , #__flag_Center|#__flag_Top   )
      TestAlign(10, 235, Width, 65, Image , #__flag_Center|#__flag_Bottom)
      TestAlign(10, 310, Width, 65, Image , #__flag_Center|#__flag_Right )
      ;
      TestAlign(10, 385, Width, 65, Image , #__flag_Right )
      TestAlign(10, 460, Width, 65, Image )
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 27
; FirstLine = 20
; Folding = --
; EnableXP
; DPIAware