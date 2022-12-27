IncludePath "../../../" : XIncludeFile "widget-events.pbi"
;XIncludeFile "../empty5.pb"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  Uselib(widget)
  
  Procedure  GadgeCreate(_id_, _x_,_y_,_width_,_height_,_text_.s,_flag_)
    Protected vertical
    ;_flag_ | #__flag_vertical
    ;_flag_ &~ #__text_invert
    
   ; _text_ +#LF$+ _text_
    
  ;  Text(_x_,_y_,_width_,_height_,_text_,_flag_)
  ;   Button(_x_,_y_,_width_,_height_,_text_,_flag_|#__text_multiline)
  ;  Option(_x_,_y_,_width_,_height_,_text_,_flag_|#__text_multiline)
  ;  CheckBox(_x_,_y_,_width_,_height_,_text_,_flag_|#__text_multiline)
  ; Editor(_x_,_y_,_width_,_height_, _flag_|#__text_multiline) : settext(widget(), _text_)
    String(_x_,_y_,_width_,_height_,_text_,_flag_)
     
  ;  widget()\text\vertical = 1
  
EndProcedure
  
  Define m.s = #LF$
  Define height = 80
  Define hor_space = 80
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  
  If OpenWindow(0, 0, 0, 908, (height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;If OpenWindow(0, 0, 0, 458, (height)*3 + 30, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0);, 0, 0, 908, (height+5)*5+20+110, "", #__flag_borderless)
    
    GadgeCreate(0, 8,  10, 140, height, text_h,                        #__text_left|#__text_top);
    GadgeCreate(1, 8,  (height+hor_space)*1+10, 140, height, text_h,           #__text_left|#__text_center);
    GadgeCreate(2, 8,  (height+hor_space)*2+10, 140, height, text_h,           #__text_left|#__text_bottom);
    
    GadgeCreate(3, 8+150,  20+height, 140, height, text_h,                    #__text_center|#__text_top);
    GadgeCreate(4, 8+150,  (height+hor_space)*1+20+height, 140, height, text_h,       #__text_center);
    GadgeCreate(5, 8+150,  (height+hor_space)*2+20+height, 140, height, text_h,       #__text_center|#__text_bottom);
    
    GadgeCreate(6, 8+300,  10, 140, height, text_h,                    #__text_right|#__text_top);
    GadgeCreate(7, 8+300,  (height+hor_space)*1+10, 140, height, text_h,       #__text_right|#__text_center);
    GadgeCreate(8, 8+300,  (height+hor_space)*2+10, 140, height, text_h,       #__text_right|#__text_bottom);
    
    ; invert
    GadgeCreate(10, 8+450,  10, 140, height, text_h,                  #__text_invert|#__text_left|#__text_top);
    GadgeCreate(11, 8+450,  (height+hor_space)*1+10, 140, height, text_h,     #__text_invert|#__text_left|#__text_center);
    GadgeCreate(12, 8+450,  (height+hor_space)*2+10, 140, height, text_h,     #__text_invert|#__text_left|#__text_bottom);
    
    GadgeCreate(13, 8+150+450,  20+height, 140, height, text_h,              #__text_invert|#__text_center|#__text_top);
    GadgeCreate(14, 8+150+450,  (height+hor_space)*1+20+height, 140, height, text_h, #__text_invert|#__text_center);
    GadgeCreate(15, 8+150+450,  (height+hor_space)*2+20+height, 140, height, text_h, #__text_invert|#__text_center|#__text_bottom);
    
    GadgeCreate(16, 8+300+450,  10, 140, height, text_h,              #__text_invert|#__text_right|#__text_top);
    GadgeCreate(17, 8+300+450,  (height+hor_space)*1+10, 140, height, text_h, #__text_invert|#__text_right|#__text_center);
    GadgeCreate(18, 8+300+450,  (height+hor_space)*2+10, 140, height, text_h, #__text_invert|#__text_right|#__text_bottom);
    
;     
;     ; vertical
;     GadgeCreate(20, 8,  (height+5)*3+10, 140, height, text_h,         #__flag_vertical|#__text_left|#__text_top);
;     GadgeCreate(21, 8,  (height+5)*4+10, 140, height, text_h,         #__flag_vertical|#__text_left|#__text_center);
;     GadgeCreate(22, 8,  (height+5)*5+10, 140, height, text_h,         #__flag_vertical|#__text_left|#__text_bottom);
;     
;     GadgeCreate(23, 8+150,  (height+5)*3+10, 140, height, text_h,     #__flag_vertical|#__text_center|#__text_top);
;     GadgeCreate(24, 8+150,  (height+5)*4+10, 140, height, text_h,     #__flag_vertical|#__text_center);
;     GadgeCreate(25, 8+150,  (height+5)*5+10, 140, height, text_h,     #__flag_vertical|#__text_center|#__text_bottom);
;     
;     GadgeCreate(26, 8+300,  (height+5)*3+10, 140, height, text_h,     #__flag_vertical|#__text_right|#__text_top);
;     GadgeCreate(27, 8+300,  (height+5)*4+10, 140, height, text_h,     #__flag_vertical|#__text_right|#__text_center);
;     GadgeCreate(28, 8+300,  (height+5)*5+10, 140, height, text_h,     #__flag_vertical|#__text_right|#__text_bottom);
;     
;     ; invert vertical
;     GadgeCreate(30, 8+450,  (height+5)*3+10, 140, height, text_h,     #__flag_vertical|#__text_invert|#__text_left|#__text_top);
;     GadgeCreate(31, 8+450,  (height+5)*4+10, 140, height, text_h,     #__flag_vertical|#__text_invert|#__text_left|#__text_center);
;     GadgeCreate(32, 8+450,  (height+5)*5+10, 140, height, text_h,     #__flag_vertical|#__text_invert|#__text_left|#__text_bottom);
;     
;     GadgeCreate(33, 8+150+450,  (height+5)*3+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_center|#__text_top);
;     GadgeCreate(34, 8+150+450,  (height+5)*4+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_center);
;     GadgeCreate(35, 8+150+450,  (height+5)*5+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_center|#__text_bottom);
;     
;     GadgeCreate(36, 8+300+450,  (height+5)*3+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_right|#__text_top);
;     GadgeCreate(37, 8+300+450,  (height+5)*4+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_right|#__text_center);
;     GadgeCreate(38, 8+300+450,  (height+5)*5+10, 140, height, text_h, #__flag_vertical|#__text_invert|#__text_right|#__text_bottom);
    
    
    redraw(root());
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP