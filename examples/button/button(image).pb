IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  UsePNGImageDecoder()
  
  If Not LoadImage(#PB_Button_PressedImage,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")    ; change 2nd parameter to the path/filename of your image
    End
  EndIf
  
  If Not LoadImage(#PB_Button_Image,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")    ; change 2nd parameter to the path/filename of your image
    End
  EndIf
  
  If Open(OpenWindow(#PB_Any, 0, 0, 200, 110, "ButtonImageGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    ButtonImageGadget(0, 10, 10, 180, 40, 0)
    
    SetGadgetAttribute(0, #PB_Button_Image, ImageID(#PB_Button_Image))
    SetGadgetAttribute(0, #PB_Button_PressedImage, ImageID(#PB_Button_PressedImage))
    
    ButtonImage(10, 60, 180, 40, - 1)
    
    SetAttribute(widget(), #PB_Button_Image, (#PB_Button_Image))
    SetAttribute(widget(), #PB_Button_PressedImage, (#PB_Button_PressedImage))
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP