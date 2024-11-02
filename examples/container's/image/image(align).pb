XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  Global canvas_gadget, canvas_window
  Global._s_WIDGET *B_0, *B_1, *B_2, *B_3, *B_4, *B_5, *B_6, *B_7, *B_8
  
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DesktopResolutionX() > 1
    ResizeImage(1, 32,32)
  EndIf
  
   Image = 1
   
  Define width = 200
  test_align = 1
  
  If Open(0, 0, 0, width+20, 760, "test alignment Image", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    canvas_gadget = GetGadget(Root())
    canvas_window = GetWindow(Root())
    
    *B_0 = Image(10,  10, width, 65, Image, #__Image_left)
    *B_5 = Image(10,  10+65+10, width, 65, Image, #__Image_top)
    *B_1 = Image(10, 160, width, 65, Image, #__Image_right)
    *B_1 = Image(10, 160+65+10, width, 65, Image, #__Image_bottom)
    
    *B_2 = Image(10, 310, width, 65, Image, #__Image_center|#__Image_left)
    *B_2 = Image(10, 310+65+10, width, 65, Image, #__Image_center|#__Image_top)
    *B_3 = Image(10, 460, width, 65, Image, #__Image_center|#__Image_right)
    *B_3 = Image(10, 460+65+10, width, 65, Image, #__Image_center|#__Image_bottom)
    
    *B_4 = Image(10, 610, width, 140, Image, #__Image_center)
     
    ;*B_0\flag = 0
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; Folding = -
; EnableXP
; DPIAware