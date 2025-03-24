CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../ide.pb"
   XIncludeFile "../../code.pbi"
CompilerEndIf

DisableExplicit

UsePNGImageDecoder()

If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   End
EndIf

If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png")
   End
EndIf

If Not LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")
   End
EndIf

If Not LoadImage(3, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png")
   End
EndIf

Global img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
If Not img
   End
EndIf

; CompilerIf #PB_Compiler_DPIAware
;    ResizeImage(0, DesktopScaledX(ImageWidth(0)), DesktopScaledY(ImageHeight(0)), #PB_Image_Raw )
;    ResizeImage(1, DesktopScaledX(ImageWidth(1)), DesktopScaledY(ImageHeight(1)), #PB_Image_Raw )
;    ResizeImage(2, DesktopScaledX(ImageWidth(2)), DesktopScaledY(ImageHeight(2)), #PB_Image_Raw )
;    ResizeImage(3, DesktopScaledX(ImageWidth(3)), DesktopScaledY(ImageHeight(3)), #PB_Image_Raw )
;    ResizeImage(img, DesktopScaledX(ImageWidth(img)), DesktopScaledY(ImageHeight(img)), #PB_Image_Raw )
; CompilerEndIf

Global my_font_2 = LoadFont(#PB_Any, "Consolas", 13, #PB_Font_Bold|#PB_Font_Underline )

If Open( 0, 0, 0, 592, 532, "Редактор изображения", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
   
   WINDOW_1 = Window( 10, 10, 392, 232, "Редактор изображения", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
   IMAGE_VIEW = Image(7, 7, 253, 218, (0), #__flag_border_flat|#__image_center )
   BUTTON_OPEN = Button(266, 7, 119, 22, "Открыть", #__image_left )
   button_SAVE = Button(266, 35, 119, 22, "Сохранить", #__image_left )
   BUTTON_COPY = Button(266, 77, 119, 22, "Копировать", #__image_left )
   button_CUT = Button(266, 105, 119, 22, "Вырезать", #__image_left )
   BUTTON_PASTE = Button(266, 133, 119, 22, "Вставить", #__image_left )
   BUTTON_OK = Button(266, 175, 119, 22, "Ок", #__image_left )
   BUTTON_CANCEL = Button(266, 203, 119, 22, "Отмена", #__image_left )
   
   ;
   SetImage(BUTTON_OPEN, (0))
   SetImage(button_SAVE, (1))
   SetImage(BUTTON_COPY, (2))
   SetImage(BUTTON_CUT, (3))
   SetImage(BUTTON_PASTE, (img))
   
   SetFont( BUTTON_OK, (my_font_2))
  
   ;SetImage( IMAGE_VIEW, (0))
   SetColor( IMAGE_VIEW, #PB_Gadget_BackColor, RGBA(222, 237, 84, 186) )
EndIf

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 42
; FirstLine = 27
; Folding = --
; EnableXP
; DPIAware