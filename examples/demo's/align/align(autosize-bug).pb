IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  
  If Not LoadImage(0,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png")   
    End
  EndIf
  
  If Not LoadImage(#PB_Button_Image,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")   
    End
  EndIf
  
  If Not LoadImage(#PB_Button_PressedImage,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")  
    End
  EndIf
  
  If OpenWindow(0, 0, 0, 200, 110, "Image Button Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonImageGadget(0, 10, 10, 180, 40, ImageID(0))
    
    ; SetGadgetAttribute(0, #PB_Button_Image, ImageID(#PB_Button_Image))
    SetGadgetAttribute(0, #PB_Button_PressedImage, ImageID(#PB_Button_PressedImage))
    
    Open( 0, 10, 60, 180, 40 )
    ;Image(0, 0, 180, 40, (0))
    
    ;Image(0, 0, 180, 40, (0), #__flag_autosize)
    Image(0, 0, 0, 0, (0), #__flag_autosize)
    ;Debug widget()\parent
    ;String(0, 0, 0, 0, "text", #__flag_autosize)
    ;SetBackColor(widget(), $FFB3FDFF)
    
    ; SetAttribute(widget(), #PB_Button_Image, (#PB_Button_Image))
    SetAttribute(widget(), #PB_Button_PressedImage, (#PB_Button_PressedImage))
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 33
; FirstLine = 5
; Folding = -
; EnableXP