DeclareModule Image
   Declare Resize( ImageID, Width, Height )
   Declare Width( ImageID )
   Declare Height( ImageID )
   
   Declare Transform( source_image, flip_mode = 0, rotation_mode = 0, free_source_image = 1 )
EndDeclareModule

Module Image 
   Procedure Transform( source_image, flip_mode = 0, rotation_mode = 0, free_source_image = 1 )
      ; https://www.purebasic.fr/english/viewtopic.php?f=12&t=77720&sid=8511c4e16685f66b2418f5d3b5452d72
      ; Transforms the source image by first flipping and then rotating it as specified.
      ; Note that there's a lot of overlap between flip and rotation operations in terms of the end result. I've kept the operations separate though as it makes them easier to work with conceptually.
      ; Returns a zero on failure or the Purebasic ID of the new rotated image on success.
      ; PARAMETERS:-
      ; source_image - The Purebasic ID of the source image to be rotated.
      ; flip_mode - 0 = Don't flip (default). 1 = Flip vertically. 2 = Flip horizontally. 3 = Flip both vertically and horizontally.
      ; rotation_mode - 0 = Don't rotate (default). 1 = Rotate 90 degrees clockwise (default). 2 = Rotate 180 degrees clockwise. 3 = Rotate 270 degrees clockwise.
      ; free_source_image - 0 = Don't free source image. 1 = Free source image (default).
      
      If IsImage( source_image ) = 0 : ProcedureReturn 0 : EndIf ; The source image was invalid, so abort.
      
      source_image_width = ImageWidth( source_image )
      source_image_height = ImageHeight( source_image )
      
      If ( flip_mode < 0 ) Or ( flip_mode > 3 ) : ProcedureReturn 0 : EndIf ; Abort if the flip mode is invalid.
      
      Select rotation_mode
         Case 0, 2 ; Rotate 0 or 180 degrees clockwise.
            output_image_width = source_image_width
            output_image_height = source_image_height
         Case 1, 3 ; Rotate 90 or 270 degrees clockwise.
            output_image_width = source_image_height
            output_image_height = source_image_width
         Default
            ProcedureReturn 0 ; The rotation mode was invalid, so abort.
      EndSelect
      
      ; Create an array for the pixel data and copy the pixel data to it. This will also perform any flagged flip operations.
      array_max_x = source_image_width - 1
      array_max_y = source_image_height - 1
      Dim TempPixelArray.l( array_max_x, array_max_y )
      StartDrawing( ImageOutput( source_image ) )
      DrawingMode( #PB_2DDrawing_AllChannels )
      For Y = 0 To array_max_y
         For X = 0 To array_max_x
            Select flip_mode
               Case 0 ; Don't flip.
                  TempPixelArray( X, Y ) = Point( X, Y )
               Case 1 ; Flip vertically.
                  TempPixelArray( X, Y ) = Point( X, array_max_y - Y )
               Case 2 ; Flip horizontally.
                  TempPixelArray( X, Y ) = Point( array_max_x - X, Y )
               Case 3 ; Flip both vertically and horizontally.
                  TempPixelArray( X, Y ) = Point( array_max_x - X, array_max_y - Y )
            EndSelect
         Next
      Next
      StopDrawing()
      
      ; Create the output image.
      output_image = CreateImage( #PB_Any, output_image_width, output_image_height, ImageDepth( source_image ) ) : If output_image = 0 : ProcedureReturn 0 : EndIf
      output_image_max_x = output_image_width - 1
      output_image_max_y = output_image_height - 1
      
      ; Copy the pixel data from the pixel array to a new output image.
      StartDrawing( ImageOutput( output_image ) )
      DrawingMode( #PB_2DDrawing_AllChannels )
      
      Select rotation_mode
         Case 0 ; Don't rotate.
            For Y = 0 To array_max_y
               For X = 0 To array_max_x
                  Plot( X, Y , TempPixelArray( X, Y ) )
               Next
            Next
            
         Case 1 ; Rotate 90 degrees clockwise.
            out_x = output_image_max_x
            For Y = 0 To array_max_y
               out_y = 0
               For X = 0 To array_max_x
                  Plot( out_x, out_y , TempPixelArray( X, Y ) )
                  out_y + 1
               Next
               out_x - 1
            Next
            
         Case 2 ; Rotate 180 degrees clockwise.
            out_y = output_image_max_y
            For Y = 0 To array_max_y
               out_x = output_image_max_x
               For X = 0 To array_max_x
                  Plot( out_x, out_y , TempPixelArray( X, Y ) )
                  out_x - 1
               Next
               out_y - 1
            Next
            
         Case 3 ; Rotate 270 degrees clockwise.
            out_x = 0
            For Y = 0 To array_max_y
               out_y = output_image_max_y
               For X = 0 To array_max_x
                  Plot( out_x, out_y , TempPixelArray( X, Y ) )
                  out_y - 1
               Next
               out_x + 1
            Next
            
      EndSelect
      
      StopDrawing()
      
      If free_source_image : FreeImage( source_image ) : EndIf ; Free the source image if it is flagged to be freed.
      
      ProcedureReturn output_image
   EndProcedure
   
   
   ;- >>> [MACOS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      Procedure Resize( ImageID, Width, Height )
         Protected size.NSSize
         size\width = Width
         size\height = Height
         ProcedureReturn CocoaMessage(0, ImageID, "setSize:@", @size)
      EndProcedure
      
      Procedure Width( ImageID )
         Protected size.NSSize
         CocoaMessage(@size, ImageID, "size")
         ProcedureReturn size\width
      EndProcedure
      
      Procedure Height( ImageID )
         Protected size.NSSize
         CocoaMessage(@size, ImageID, "size")
         ProcedureReturn size\height
      EndProcedure
      
      Procedure.i ImageSize( ImageID.i, Width, Height )
         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            Protected size.NSSize
            CocoaMessage(@size, ImageID, "size")
            ; Size\height = CocoaMessage(0, ImageID, "pixelsHigh")
            
            ProcedureReturn size\height
         CompilerEndIf
      EndProcedure
      
   CompilerEndIf
   
   ;- >>> [WINDOWS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Procedure Resize( ImageID, Width, Height )
         
      EndProcedure
      
      Procedure Width( ImageID )
         
      EndProcedure
      
      Procedure Height( ImageID )
         
      EndProcedure
   CompilerEndIf
   
   ;- >>> [LINUX] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      Procedure Resize( ImageID, Width, Height )
         
      EndProcedure
      
      Procedure Width( ImageID )
         
      EndProcedure
      
      Procedure Height( ImageID )
         
      EndProcedure
   CompilerEndIf
   
EndModule

UsePNGImageDecoder()

If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
   End
EndIf

Define imgID = ImageID(1)

CompilerIf #PB_Compiler_IsMainFile
   If OpenWindow(1, 100, 100, 300, 300, "image")
      
      ; imgID = ImageID(Image::Transform(1,2,2))
      
      Image::Resize( imgID, 64,64 )
      Debug Image::Width( imgID )
      
      
      ImageGadget(1, 80,  80, 100, 100, imgID)
      
      Repeat
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      
   EndIf
   
   End   ; All the opened windows are closed automatically by PureBasic
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 196
; FirstLine = 177
; Folding = --8--
; EnableXP