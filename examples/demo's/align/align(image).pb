IncludePath "../../../" : XIncludeFile "widgets.pbi"
;XIncludeFile "../empty5.pb"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
  ;If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Map.bmp") ;/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  If DesktopResolutionX() > 1
    ResizeImage(0, 32,32)
  EndIf
  
  Macro gadget(_id_, _x_,_y_,_width_,_height_,_text_,_flag_)
   ImageWidget(_x_,_y_,_width_,_height_,0,_flag_)
   ;ButtonImageWidget(_x_,_y_,_width_,_height_,0,_flag_)
  EndMacro
  
  Define m.s = #LF$
  Define Height = 110
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  
  If OpenWindow(0, 0, 0, 908, (Height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;If OpenWindow(0, 0, 0, 458, (height)*3 + 30, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    OpenRoot(0);, 0, 0, 908, (height+5)*5+20+110, "", #__flag_borderless)
    
    Gadget(0, 8,  10, 140, Height, text_h,                        #__image_left|#__image_top);
    Gadget(1, 8,  (Height+5)*1+10, 140, Height, text_h,           #__image_left|#__image_center);
    Gadget(2, 8,  (Height+5)*2+10, 140, Height, text_h,           #__image_left|#__image_bottom);
    
    Gadget(3, 8+150,  10, 140, Height, text_h,                    #__image_center|#__image_top);
    Gadget(4, 8+150,  (Height+5)*1+10, 140, Height, text_h,       #__image_center);
    Gadget(5, 8+150,  (Height+5)*2+10, 140, Height, text_h,       #__image_center|#__image_bottom);
    
    Gadget(6, 8+300,  10, 140, Height, text_h,                    #__image_right|#__image_top);
    Gadget(7, 8+300,  (Height+5)*1+10, 140, Height, text_h,       #__image_right|#__image_center);
    Gadget(8, 8+300,  (Height+5)*2+10, 140, Height, text_h,       #__image_right|#__image_bottom);
    
    ; invert
    Gadget(10, 8+450,  10, 140, Height, text_h,                  #__flag_invert|#__image_left|#__image_top);
    Gadget(11, 8+450,  (Height+5)*1+10, 140, Height, text_h,     #__flag_invert|#__image_left|#__image_center);
    Gadget(12, 8+450,  (Height+5)*2+10, 140, Height, text_h,     #__flag_invert|#__image_left|#__image_bottom);
    
    Gadget(13, 8+150+450,  10, 140, Height, text_h,              #__flag_invert|#__image_center|#__image_top);
    Gadget(14, 8+150+450,  (Height+5)*1+10, 140, Height, text_h, #__flag_invert|#__image_center);
    Gadget(15, 8+150+450,  (Height+5)*2+10, 140, Height, text_h, #__flag_invert|#__image_center|#__image_bottom);
    
    Gadget(16, 8+300+450,  10, 140, Height, text_h,              #__flag_invert|#__image_right|#__image_top);
    Gadget(17, 8+300+450,  (Height+5)*1+10, 140, Height, text_h, #__flag_invert|#__image_right|#__image_center);
    Gadget(18, 8+300+450,  (Height+5)*2+10, 140, Height, text_h, #__flag_invert|#__image_right|#__image_bottom);
    
    
    ; vertical
    Gadget(20, 8,  (Height+5)*3+10, 140, Height, text_h,         #__flag_vertical|#__image_left|#__image_top);
    Gadget(21, 8,  (Height+5)*4+10, 140, Height, text_h,         #__flag_vertical|#__image_left|#__image_center);
    Gadget(22, 8,  (Height+5)*5+10, 140, Height, text_h,         #__flag_vertical|#__image_left|#__image_bottom);
    
    Gadget(23, 8+150,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__image_center|#__image_top);
    Gadget(24, 8+150,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__image_center);
    Gadget(25, 8+150,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__image_center|#__image_bottom);
    
    Gadget(26, 8+300,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__image_right|#__image_top);
    Gadget(27, 8+300,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__image_right|#__image_center);
    Gadget(28, 8+300,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__image_right|#__image_bottom);
    
    ; invert vertical
    Gadget(30, 8+450,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__image_left|#__image_top);
    Gadget(31, 8+450,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__image_left|#__image_center);
    Gadget(32, 8+450,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__image_left|#__image_bottom);
    
    Gadget(33, 8+150+450,  (Height+5)*3+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_center|#__image_top);
    Gadget(34, 8+150+450,  (Height+5)*4+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_center);
    Gadget(35, 8+150+450,  (Height+5)*5+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_center|#__image_bottom);
    
    Gadget(36, 8+300+450,  (Height+5)*3+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_right|#__image_top);
    Gadget(37, 8+300+450,  (Height+5)*4+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_right|#__image_center);
    Gadget(38, 8+300+450,  (Height+5)*5+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__image_right|#__image_bottom);
    
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 21
; FirstLine = 17
; Folding = -
; EnableXP
; DPIAware