IncludePath "../../"
XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  
  Uselib(widget)
  
  Macro gadget(id, x,y,width,height,text,flag)
    button(x,y,width,height,text,flag)
  EndMacro
  
  Global *S_0._s_widget
  Global *S_1._s_widget
  Global *S_2._s_widget
  Global *S_3._s_widget
  Global *S_4._s_widget
  Global *S_5._s_widget
  Global *S_6._s_widget
  Global *S_7._s_widget
  Global *S_8._s_widget
  Global *S_9._s_widget
  
  Global *S_10._s_widget
  Global *S_11._s_widget
  Global *S_12._s_widget
  Global *S_13._s_widget
  Global *S_14._s_widget
  Global *S_15._s_widget
  Global *S_16._s_widget
  Global *S_17._s_widget
  Global *S_18._s_widget
  Global *S_19._s_widget
  
  Global *S_20._s_widget
  Global *S_21._s_widget
  Global *S_22._s_widget
  Global *S_23._s_widget
  Global *S_24._s_widget
  Global *S_25._s_widget
  Global *S_26._s_widget
  Global *S_27._s_widget
  Global *S_28._s_widget
  Global *S_29._s_widget
  
  Global *S_30._s_widget
  Global *S_31._s_widget
  Global *S_32._s_widget
  Global *S_33._s_widget
  Global *S_34._s_widget
  Global *S_35._s_widget
  Global *S_36._s_widget
  Global *S_37._s_widget
  Global *S_38._s_widget
  
  Define m.s = #LF$
  Define height = 110
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  
  If OpenWindow(0, 0, 0, 908, (height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0);, 0, 0, 908, (height+5)*5+20+110, "", #__flag_borderless)
    
    *S_0 = (Gadget(0, 8,  10, 140, height, text_h,                       #__text_multiline|#__text_left|#__text_top))
    *S_1 = (Gadget(1, 8,  (height+5)*1+10, 140, height, text_h,          #__text_multiline|#__text_left))
    *S_2 = (Gadget(2, 8,  (height+5)*2+10, 140, height, text_h,          #__text_multiline|#__text_left|#__text_bottom))
    
    *S_3 = (Gadget(3, 8+150,  10, 140, height, text_h,                  #__text_multiline|#__text_top))
    *S_4 = (Gadget(4, 8+150,  (height+5)*1+10, 140, height, text_h,     #__text_multiline))
    *S_5 = (Gadget(5, 8+150,  (height+5)*2+10, 140, height, text_h,     #__text_multiline|#__text_bottom))
    
    *S_6 = (Gadget(6, 8+300,  10, 140, height, text_h,                  #__text_multiline|#__text_right|#__text_top))
    *S_7 = (Gadget(7, 8+300,  (height+5)*1+10, 140, height, text_h,     #__text_multiline|#__text_right))
    *S_8 = (Gadget(8, 8+300,  (height+5)*2+10, 140, height, text_h,     #__text_multiline|#__text_right|#__text_bottom))
    
    
    *S_10 = (Gadget(10, 8+450,  10, 140, height, text_h,                   #__text_multiline|#__text_invert|#__text_left|#__text_top))
    *S_11 = (Gadget(11, 8+450,  (height+5)*1+10, 140, height, text_h,      #__text_multiline|#__text_invert|#__text_left))
    *S_12 = (Gadget(12, 8+450,  (height+5)*2+10, 140, height, text_h,      #__text_multiline|#__text_invert|#__text_left|#__text_bottom))
    
    *S_13 = (Gadget(13, 8+150+450,  10, 140, height, text_h,              #__text_multiline|#__text_invert|#__text_top))
    *S_14 = (Gadget(14, 8+150+450,  (height+5)*1+10, 140, height, text_h, #__text_multiline|#__text_invert))
    *S_15 = (Gadget(15, 8+150+450,  (height+5)*2+10, 140, height, text_h, #__text_multiline|#__text_invert|#__text_bottom))
    
    *S_16 = (Gadget(16, 8+300+450,  10, 140, height, text_h,              #__text_multiline|#__text_invert|#__text_right|#__text_top))
    *S_17 = (Gadget(17, 8+300+450,  (height+5)*1+10, 140, height, text_h, #__text_multiline|#__text_invert|#__text_right))
    *S_18 = (Gadget(18, 8+300+450,  (height+5)*2+10, 140, height, text_h, #__text_multiline|#__text_invert|#__text_right|#__text_bottom))
    
    
    
    *S_20 = (Gadget(20, 8,  (height+5)*3+10, 140, height, text_h,          #__text_multiline|#__flag_vertical|#__text_left|#__text_top))
    *S_21 = (Gadget(21, 8,  (height+5)*4+10, 140, height, text_h,          #__text_multiline|#__flag_vertical|#__text_left))
    *S_22 = (Gadget(22, 8,  (height+5)*5+10, 140, height, text_h,          #__text_multiline|#__flag_vertical|#__text_left|#__text_bottom))
    
    *S_23 = (Gadget(23, 8+150,  (height+5)*3+10, 140, height, text_h,     #__text_multiline|#__flag_vertical|#__text_top))
    *S_24 = (Gadget(24, 8+150,  (height+5)*4+10, 140, height, text_h,     #__text_multiline|#__flag_vertical))
    *S_25 = (Gadget(25, 8+150,  (height+5)*5+10, 140, height, text_h,     #__text_multiline|#__flag_vertical|#__text_bottom))
    
    *S_26 = (Gadget(26, 8+300,  (height+5)*3+10, 140, height, text_h,     #__text_multiline|#__flag_vertical|#__text_right|#__text_top))
    *S_27 = (Gadget(27, 8+300,  (height+5)*4+10, 140, height, text_h,     #__text_multiline|#__flag_vertical|#__text_right))
    *S_28 = (Gadget(28, 8+300,  (height+5)*5+10, 140, height, text_h,     #__text_multiline|#__flag_vertical|#__text_right|#__text_bottom))
    
    
    *S_30 = (Gadget(30, 8+450,  (height+5)*3+10, 140, height, text_h,      #__text_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_top))
    *S_31 = (Gadget(31, 8+450,  (height+5)*4+10, 140, height, text_h,      #__text_multiline|#__flag_vertical|#__text_invert|#__text_left))
    *S_32 = (Gadget(32, 8+450,  (height+5)*5+10, 140, height, text_h,      #__text_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_bottom))
    
    *S_33 = (Gadget(33, 8+150+450,  (height+5)*3+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert|#__text_top))
    *S_34 = (Gadget(34, 8+150+450,  (height+5)*4+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert))
    *S_35 = (Gadget(35, 8+150+450,  (height+5)*5+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert|#__text_bottom))
    
    *S_36 = (Gadget(36, 8+300+450,  (height+5)*3+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert|#__text_right|#__text_top))
    *S_37 = (Gadget(37, 8+300+450,  (height+5)*4+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert|#__text_right))
    *S_38 = (Gadget(38, 8+300+450,  (height+5)*5+10, 140, height, text_h, #__text_multiline|#__flag_vertical|#__text_invert|#__text_right|#__text_bottom))
    
    
    redraw(root())
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP