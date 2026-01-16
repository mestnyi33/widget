IncludePath "../../" : XIncludeFile "widgets.pbi"
;XIncludeFile "../empty5.pb"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  UseWidgets( )
  test_draw_area = 1
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
  ;If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Map.bmp") ;/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  If DesktopResolutionX() > 1
    ResizeImage(0, 32,32)
  EndIf
  
  Macro gadget(_id_, _x_,_y_,_width_,_height_,_text_,_flag_)
    ;ComboBox(_x_,_y_,_width_,_height_,_flag_|#__flag_Textmultiline) : AddItem(widget( ), -1,"combo") : SetState(widget( ), 0) : SetImage(widget( ), 0)
    ;   Image(_x_,_y_,_width_,_height_,(0),_flag_) : SetBackColor( widget( ), $FFB3FDFF )
         
   ; ButtonImage(_x_,_y_,_width_,_height_,(0),(_flag_&~#__align_image));|#__flag_BorderLess)
     Button(_x_,_y_,_width_,_height_,_text_, _flag_|#__flag_textmultiline )
     SetImage( Widget(), (0))
  EndMacro
  
  Define m.s = #LF$
  Define Height = 110
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  
  If OpenWindow(0, 0, 0, 908, (Height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;If OpenWindow(0, 0, 0, 458, (height)*3 + 30, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0);, 0, 0, 908, (height+5)*5+20+110, "", #__flag_Borderless)
    
    Gadget(0, 8,  10, 140, Height, text_h,                        #__flag_ImageLeft|#__flag_ImageTop);
    Gadget(1, 8,  (Height+5)*1+10, 140, Height, text_h,           #__flag_ImageLeft|#__flag_ImageCenter);
    Gadget(2, 8,  (Height+5)*2+10, 140, Height, text_h,           #__flag_ImageLeft|#__flag_ImageBottom);
    
    Gadget(3, 8+150,  10, 140, Height, text_h,                    #__flag_ImageCenter|#__flag_ImageTop);
    Gadget(4, 8+150,  (Height+5)*1+10, 140, Height, text_h,       #__flag_ImageCenter);
    Gadget(5, 8+150,  (Height+5)*2+10, 140, Height, text_h,       #__flag_ImageCenter|#__flag_ImageBottom);
    
    Gadget(6, 8+300,  10, 140, Height, text_h,                    #__flag_ImageRight|#__flag_ImageTop);
    Gadget(7, 8+300,  (Height+5)*1+10, 140, Height, text_h,       #__flag_ImageRight|#__flag_ImageCenter);
    Gadget(8, 8+300,  (Height+5)*2+10, 140, Height, text_h,       #__flag_ImageRight|#__flag_ImageBottom);
    
    ; invert
    Gadget(10, 8+450,  10, 140, Height, text_h,                  #__flag_invert|#__flag_ImageLeft|#__flag_ImageTop);
    Gadget(11, 8+450,  (Height+5)*1+10, 140, Height, text_h,     #__flag_invert|#__flag_ImageLeft|#__flag_ImageCenter);
    Gadget(12, 8+450,  (Height+5)*2+10, 140, Height, text_h,     #__flag_invert|#__flag_ImageLeft|#__flag_ImageBottom);
    
    Gadget(13, 8+150+450,  10, 140, Height, text_h,              #__flag_invert|#__flag_ImageCenter|#__flag_ImageTop);
    Gadget(14, 8+150+450,  (Height+5)*1+10, 140, Height, text_h, #__flag_invert|#__flag_ImageCenter);
    Gadget(15, 8+150+450,  (Height+5)*2+10, 140, Height, text_h, #__flag_invert|#__flag_ImageCenter|#__flag_ImageBottom);
    
    Gadget(16, 8+300+450,  10, 140, Height, text_h,              #__flag_invert|#__flag_ImageRight|#__flag_ImageTop);
    Gadget(17, 8+300+450,  (Height+5)*1+10, 140, Height, text_h, #__flag_invert|#__flag_ImageRight|#__flag_ImageCenter);
    Gadget(18, 8+300+450,  (Height+5)*2+10, 140, Height, text_h, #__flag_invert|#__flag_ImageRight|#__flag_ImageBottom);
    
    
    ; vertical
    Gadget(20, 8,  (Height+5)*3+10, 140, Height, text_h,         #__flag_vertical|#__flag_ImageLeft|#__flag_ImageTop);
    Gadget(21, 8,  (Height+5)*4+10, 140, Height, text_h,         #__flag_vertical|#__flag_ImageLeft|#__flag_ImageCenter);
    Gadget(22, 8,  (Height+5)*5+10, 140, Height, text_h,         #__flag_vertical|#__flag_ImageLeft|#__flag_ImageBottom);
    
    Gadget(23, 8+150,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageCenter|#__flag_ImageTop);
    Gadget(24, 8+150,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageCenter);
    Gadget(25, 8+150,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageCenter|#__flag_ImageBottom);
    
    Gadget(26, 8+300,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageRight|#__flag_ImageTop);
    Gadget(27, 8+300,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageRight|#__flag_ImageCenter);
    Gadget(28, 8+300,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__flag_ImageRight|#__flag_ImageBottom);
    
    ; invert vertical
    Gadget(30, 8+450,  (Height+5)*3+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__flag_ImageLeft|#__flag_ImageTop);
    Gadget(31, 8+450,  (Height+5)*4+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__flag_ImageLeft|#__flag_ImageCenter);
    Gadget(32, 8+450,  (Height+5)*5+10, 140, Height, text_h,     #__flag_vertical|#__flag_invert|#__flag_ImageLeft|#__flag_ImageBottom);
    
    Gadget(33, 8+150+450,  (Height+5)*3+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageCenter|#__flag_ImageTop);
    Gadget(34, 8+150+450,  (Height+5)*4+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageCenter);
    Gadget(35, 8+150+450,  (Height+5)*5+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageCenter|#__flag_ImageBottom);
    
    Gadget(36, 8+300+450,  (Height+5)*3+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageRight|#__flag_ImageTop);
    Gadget(37, 8+300+450,  (Height+5)*4+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageRight|#__flag_ImageCenter);
    Gadget(38, 8+300+450,  (Height+5)*5+10, 140, Height, text_h, #__flag_vertical|#__flag_invert|#__flag_ImageRight|#__flag_ImageBottom);
    
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 96
; Folding = -
; EnableXP
; DPIAware