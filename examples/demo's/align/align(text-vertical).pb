IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
   ; Shows possible flags of ButtonGadget in action...
   EnableExplicit
   Uselib(widget)
   
   Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
      ;Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_textmultiline)
      ;CheckBox(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_textmultiline)
      ;
      ;Text(_x_,_y_,_width_,_height_,_text_,_flag_)
      Button(_x_,_y_,_width_,_height_,_text_,_flag_|#__flag_textmultiline)
      ;Editor(_x_,_y_,_width_,_height_, _flag_|#__flag_textmultiline) : settext(widget(), _text_)
      ;String(_x_,_y_,_width_,_height_,_text_,_flag_)
   EndProcedure
   
   Define m.s = #LF$
   Define width = 90
   Define height = 140
   Define space = 5
   Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
   Define y,x = (width+space)*3 + 5
   
   If Open(0, 0, 0, x+(width+space)*3 + 15, y+(height+space)*3 + 15, "vertical text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor( widget( ), #__color_Back, $FFffffff )
      
      ; vertical
      GadgeCreate(0, 10, 10,                  width, height, text_v,                      #__text_vertical|#__text_left|#__text_top);
      GadgeCreate(1, 10, 10+(height+space)*1, width, height, text_v,                      #__text_vertical|#__text_left|#__text_center) ;
      GadgeCreate(2, 10, 10+(height+space)*2, width, height, text_v,                      #__text_vertical|#__text_left|#__text_bottom) ;
      
      GadgeCreate(3, 10+(width+space), 10,                  width, height, text_v,        #__text_vertical|#__text_center|#__text_top);
      GadgeCreate(4, 10+(width+space), 10+(height+space)*1, width, height, text_v,        #__text_vertical|#__text_center)                ;
      GadgeCreate(5, 10+(width+space), 10+(height+space)*2, width, height, text_v,        #__text_vertical|#__text_center|#__text_bottom) ;
      
      GadgeCreate(6, 10+(width+space)*2, 10,                   width, height, text_v,      #__text_vertical|#__text_right|#__text_top);
      GadgeCreate(7, 10+(width+space)*2, 10+(height+space)*1,  width, height, text_v,      #__text_vertical|#__text_right|#__text_center) ;
      GadgeCreate(10, 10+(width+space)*2, 10+(height+space)*2, width, height, text_v,      #__text_vertical|#__text_right|#__text_bottom);
      
      
      ; vertical invert
      GadgeCreate(20, x+10, y+10,                  width, height, text_v,                      #__text_vertical|#__text_invert|#__text_left|#__text_top);
      GadgeCreate(21, x+10, y+10+(height+space)*1, width, height, text_v,                      #__text_vertical|#__text_invert|#__text_left|#__text_center) ;
      GadgeCreate(22, x+10, y+10+(height+space)*2, width, height, text_v,                      #__text_vertical|#__text_invert|#__text_left|#__text_bottom) ;
      
      GadgeCreate(23, x+10+width+space, y+10,                  width, height, text_v,        #__text_vertical|#__text_invert|#__text_center|#__text_top);
      GadgeCreate(24, x+10+width+space, y+10+(height+space)*1, width, height, text_v,        #__text_vertical|#__text_invert|#__text_center)                ;
      GadgeCreate(25, x+10+width+space, y+10+(height+space)*2, width, height, text_v,        #__text_vertical|#__text_invert|#__text_center|#__text_bottom) ;
      
      GadgeCreate(26, x+10+(width+space)*2, y+10,                   width, height, text_v,      #__text_vertical|#__text_invert|#__text_right|#__text_top);
      GadgeCreate(27, x+10+(width+space)*2, y+10+(height+space)*1,  width, height, text_v,      #__text_vertical|#__text_invert|#__text_right|#__text_center) ;
      GadgeCreate(210, x+10+(width+space)*2, y+10+(height+space)*2, width, height, text_v,      #__text_vertical|#__text_invert|#__text_right|#__text_bottom);
      
   EndIf
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 33
; Folding = -
; Optimizer
; EnableXP
; DPIAware