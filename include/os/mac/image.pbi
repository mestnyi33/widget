DeclareModule Image
   Declare Resize( ImageID, Width, Height )
   Declare Width( ImageID )
   Declare Height( ImageID )
EndDeclareModule

Module Image 
   ;- >>> [MACOS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      Procedure Resize( ImageID, Width, Height )
         Protected img_size.NSSize
         img_size\width = Width
         img_size\height = Height
         ProcedureReturn CocoaMessage(0, ImageID, "setSize:@", @img_size)
      EndProcedure
      
      Procedure Width( ImageID )
         
      EndProcedure
      
      Procedure Height( ImageID )
         
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
      
      Image::Resize( imgID, 64,64 )
      Debug Image::Width( imgID )
      
      ImageGadget(1, 80,  80, 100, 100, imgID)
      
      Repeat
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      
   EndIf
   
   End   ; All the opened windows are closed automatically by PureBasic
CompilerEndIf

; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 66
; FirstLine = 53
; Folding = ---
; EnableXP