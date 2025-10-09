EnableExplicit

UsePNGImageDecoder( )

Global WINDOW_0 = - 1

Global BUTTON_0 = - 1
Global BUTTON_1 = - 1
Global BUTTON_2 = - 1

Global IMAGE_COPY_48_PNG = LoadImage( #PB_Any, "C:\Users\user\Documents\GitHub\widget\IDE\include\Images\copy_48.png" )

CompilerIf #PB_Compiler_DPIAware
   ResizeImage( IMAGE_COPY_48_PNG, DesktopScaledX( ImageWidth( IMAGE_COPY_48_PNG )), DesktopScaledY( ImageHeight( IMAGE_COPY_48_PNG )), #PB_Image_Raw )
CompilerEndIf

Procedure Open_WINDOW_0( )
   WINDOW_0 = OpenWindow( #PB_Any, 7, 7, 400, 253, "window_0", #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      BUTTON_0 = ButtonImageGadget(-1, 7, 7, 78, 64,0 )
         SetGadgetAttribute( BUTTON_0, #PB_Button_Image, ImageID(IMAGE_COPY_48_PNG) )
      
      BUTTON_1 = ButtonGadget(-1, 91, 112, 211, 29, "button_1" )
      BUTTON_2 = ButtonGadget(-1, 91, 147, 211, 29, "button_2" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   Repeat
      Until WaitWindowEvent(1) = #PB_Event_CloseWindow
   End
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 18
; Folding = -
; EnableXP
; DPIAware