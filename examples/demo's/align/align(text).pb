IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
   ; Shows possible flags of ButtonGadget in action...
   EnableExplicit
   UseWidgets( )
   
    test_draw_area = 1
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
   Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
      ;Button(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;
      ;Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;CheckBox(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_Textmultiline)
      ;
      ;Text(_x_,_y_,_width_,_height_,_text_,_flag_)
      Editor(_x_,_y_,_width_,_height_, _flag_|#__flag_Textmultiline) : SetText(widget(), _text_)
      ;String(_x_,_y_,_width_,_height_,_text_,_flag_)
   EndProcedure
   
   Define m.s = #LF$
   Define Width = 140
   Define Height = 90
   Define space = 5
   Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
   Define X,Y = (Height+space)*3 + 5
   
   
   If Open(0, 0, 0, X+(Width+space)*3 + 15, Y+(Height+space)*3 + 15, "vertical text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor( widget( ), #__color_Back, $FFffffff )
      a_init( widget() )
      
      ; horizontal
      GadgeCreate(0, 10, 10,                      Width, Height, text_h,                      #__flag_Textleft|#__flag_Texttop);
      GadgeCreate(1, 10, 10+(Height+space)*1, Width, Height, text_h,                      #__flag_Textleft|#__flag_Textcenter) ;
      GadgeCreate(2, 10, 10+(Height+space)*2, Width, Height, text_h,                      #__flag_Textleft|#__flag_Textbottom) ;
      
      GadgeCreate(3, 10+(Width+space), 10,                      Width, Height, text_h,        #__flag_Textcenter|#__flag_Texttop);
      GadgeCreate(4, 10+(Width+space), 10+(Height+space)*1, Width, Height, text_h,        #__flag_Textcenter)                ;
      GadgeCreate(5, 10+(Width+space), 10+(Height+space)*2, Width, Height, text_h,        #__flag_Textcenter|#__flag_Textbottom) ;
      
      GadgeCreate(6, 10+(Width+space)*2, 10,                      Width, Height, text_h,      #__flag_Textright|#__flag_Texttop);
      GadgeCreate(7, 10+(Width+space)*2, 10+(Height+space)*1, Width, Height, text_h,      #__flag_Textright|#__flag_Textcenter) ;
      GadgeCreate(10, 10+(Width+space)*2, 10+(Height+space)*2, Width, Height, text_h,      #__flag_Textright|#__flag_Textbottom);
      
      
      ; horizontal invert
      GadgeCreate(20, X+10, Y+10,                      Width, Height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Texttop);
      GadgeCreate(21, X+10, Y+10+(Height+space)*1, Width, Height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Textcenter) ;
      GadgeCreate(22, X+10, Y+10+(Height+space)*2, Width, Height, text_h,                      #__flag_Textinvert|#__flag_Textleft|#__flag_Textbottom) ;
      
      GadgeCreate(23, X+10+Width+space, Y+10,                      Width, Height, text_h,        #__flag_Textinvert|#__flag_Textcenter|#__flag_Texttop);
      GadgeCreate(24, X+10+Width+space, Y+10+(Height+space)*1, Width, Height, text_h,        #__flag_Textinvert|#__flag_Textcenter)                ;
      GadgeCreate(25, X+10+Width+space, Y+10+(Height+space)*2, Width, Height, text_h,        #__flag_Textinvert|#__flag_Textcenter|#__flag_Textbottom) ;
      
      GadgeCreate(26, X+10+(Width+space)*2, Y+10,                      Width, Height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Texttop);
      GadgeCreate(27, X+10+(Width+space)*2, Y+10+(Height+space)*1, Width, Height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Textcenter) ;
      GadgeCreate(210, X+10+(Width+space)*2, Y+10+(Height+space)*2, Width, Height, text_h,      #__flag_Textinvert|#__flag_Textright|#__flag_Textbottom);
      
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 9
; Folding = -
; EnableXP
; DPIAware