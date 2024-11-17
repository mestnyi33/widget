IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
   ; Shows possible flags of ButtonGadget in action...
   EnableExplicit
   UseWidgets( )
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
   Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
      ;ButtonWidget(_x_,_y_,_width_,_height_,_text_, _flag_|#__flag_Textmultiline, 0) ; image & text
      ButtonWidget(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;
      ;Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;CheckBoxWidget(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;
      ;TextWidget(_x_,_y_,_width_,_height_,_text_,_flag_)
      ;EditorWidget(_x_,_y_,_width_,_height_, _flag_|#__flag_Textmultiline) : setTextWidget(widget(), _text_)
      ;StringWidget(_x_,_y_,_width_,_height_,_text_,_flag_)
   EndProcedure
   
   Define m.s = #LF$
   Define width = 140
   Define height = 90
   Define space = 5
   Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
   Define x,y = (height+space)*3 + 5
   
   
   If Open(0, 0, 0, x+(width+space)*3 + 15, y+(height+space)*3 + 15, "vertical text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetWidgetColor( widget( ), #__color_Back, $FFffffff )
      
      ; horizontal
      GadgeCreate(0, 10, 10,                      width, height, text_h,                      #__flag_Textleft|#__flag_Texttop);
      GadgeCreate(1, 10, 10+(height+space)*1, width, height, text_h,                      #__flag_Textleft|#__flag_Textcenter) ;
      GadgeCreate(2, 10, 10+(height+space)*2, width, height, text_h,                      #__flag_Textleft|#__flag_Textbottom) ;
      
      GadgeCreate(3, 10+(width+space), 10,                      width, height, text_h,        #__flag_Textcenter|#__flag_Texttop);
      GadgeCreate(4, 10+(width+space), 10+(height+space)*1, width, height, text_h,        #__flag_Textcenter)                ;
      GadgeCreate(5, 10+(width+space), 10+(height+space)*2, width, height, text_h,        #__flag_Textcenter|#__flag_Textbottom) ;
      
      GadgeCreate(6, 10+(width+space)*2, 10,                      width, height, text_h,      #__flag_Textright|#__flag_Texttop);
      GadgeCreate(7, 10+(width+space)*2, 10+(height+space)*1, width, height, text_h,      #__flag_Textright|#__flag_Textcenter) ;
      GadgeCreate(10, 10+(width+space)*2, 10+(height+space)*2, width, height, text_h,      #__flag_Textright|#__flag_Textbottom);
      
      
      ; horizontal invert
      GadgeCreate(20, x+10, y+10,                      width, height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Texttop);
      GadgeCreate(21, x+10, y+10+(height+space)*1, width, height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Textcenter) ;
      GadgeCreate(22, x+10, y+10+(height+space)*2, width, height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Textbottom) ;
      
      GadgeCreate(23, x+10+width+space, y+10,                      width, height, text_h,        #__flag_Textinvert|#__flag_Textcenter|#__flag_Texttop);
      GadgeCreate(24, x+10+width+space, y+10+(height+space)*1, width, height, text_h,        #__flag_Textinvert|#__flag_Textcenter)                ;
      GadgeCreate(25, x+10+width+space, y+10+(height+space)*2, width, height, text_h,        #__flag_Textinvert|#__flag_Textcenter|#__flag_Textbottom) ;
      
      GadgeCreate(26, x+10+(width+space)*2, y+10,                      width, height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Texttop);
      GadgeCreate(27, x+10+(width+space)*2, y+10+(height+space)*1, width, height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Textcenter) ;
      GadgeCreate(210, x+10+(width+space)*2, y+10+(height+space)*2, width, height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Textbottom);
      
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware