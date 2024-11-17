XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  Global canvas_gadget, canvas_window
  Global._s_WIDGET *B_0, *B_1, *B_2, *B_3, *B_4, *B_5, *B_6, *B_7, *B_8
  
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
   ResizeImage(1, DesktopScaledX(ImageWidget(1)),DesktopScaledY(ImageHeight(1)))
   EndIf
  
   Image = 1
   
  Define Width = 200
  test_align = 1
  
  If OpenRootWidget(0, 0, 0, Width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    canvas_gadget = GetCanvasGadget(root())
    canvas_window = GetCanvasWindow(root())
    
    *B_1 = ImageWidget(10,  10, Width, 65, Image);, #__Image_left)
    *B_2 = ImageWidget(10,  10+65+10, Width, 65, Image, #__Image_top)
    *B_3 = ImageWidget(10, 160, Width, 65, Image, #__Image_right)
    *B_4 = ImageWidget(10, 160+65+10, Width, 65, Image, #__Image_bottom)
    
    *B_5 = ImageWidget(10, 310, Width, 65, Image, #__Image_center|#__Image_left)
    *B_6 = ImageWidget(10, 310+65+10, Width, 65, Image, #__Image_center|#__Image_top)
    *B_7 = ImageWidget(10, 460, Width, 65, Image, #__Image_center|#__Image_right)
    *B_8 = ImageWidget(10, 460+65+10, Width, 65, Image, #__Image_center|#__Image_bottom)
    
    *B_9 = ImageWidget(10, 610, Width, 140, Image, #__Image_center)
     
    ;*B_0\flag = 0
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 34
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware