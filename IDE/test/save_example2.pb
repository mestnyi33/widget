EnableExplicit

CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "C:\Users\user\Documents\GitHub\widget\widgets.pbi"
CompilerEndIf

UseWidgets( )
UsePNGImageDecoder( )

Global WINDOW_0 = - 1

Global BUTTON_0 = - 1
Global BUTTON_1 = - 1
Global BUTTON_2 = - 1

Global IMAGE_COPY_48_PNG = Loadimage( #PB_Any, "C:\Users\user\Documents\GitHub\widget\IDE\include\Images\copy_48.png" )

CompilerIf #PB_Compiler_DPIAware
   ResizeImage( IMAGE_COPY_48_PNG, DesktopScaledX( ImageWidth( IMAGE_COPY_48_PNG )), DesktopScaledY( ImageHeight( IMAGE_COPY_48_PNG )), #PB_Image_Raw )
CompilerEndIf

Procedure Open_WINDOW_0( )
   WINDOW_0 = Open( #PB_Any, 7, 7, 400, 253, "window_0", #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      BUTTON_0 = Button( 7, 7, 78, 64, "button_0" )
         SetImage( BUTTON_0, IMAGE_COPY_48_PNG )
      
      BUTTON_1 = Button( 91, 112, 211, 29, "button_1" )
      BUTTON_2 = Button( 91, 147, 211, 29, "button_2" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   WaitClose( )
   End
CompilerEndIf