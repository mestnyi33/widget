    Define m.s = "";#LF$
  Define height = 110
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  Define *g1, *g2, *g3, *g4, *g5
  
  
  Procedure SetAlign(Editor)
    CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      gtk_text_view_set_justification_(GadgetID(Editor), #GTK_JUSTIFY_CENTER)
    CompilerCase #PB_OS_MacOS
      CocoaMessage(0, GadgetID(Editor), "setAlignment:", #NSCenterTextAlignment)
  CompilerEndSelect
EndProcedure

If OpenWindow(0, 0, 0, 908, (height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;     Gadget(0, 8,  10, 140, height, text_h,                        #__text_left|#__text_top);
  *g1 = EditorGadget(-1, 8,  (height+5)*1+10, 140, height)
  SetGadgetText(*g1, text_h);,           #__text_left|#__text_center);
;     Gadget(2, 8,  (height+5)*2+10, 140, height, text_h,           #__text_left|#__text_bottom);
    
;     Gadget(3, 8+150,  10, 140, height, text_h,                    #__text_center|#__text_top);
  *g2 = EditorGadget(-1, 8+150,  (height+5)*1+10, 140, height)
  SetGadgetText(*g2, text_h);,       #__text_center);
;     Gadget(5, 8+150,  (height+5)*2+10, 140, height, text_h,       #__text_center|#__text_bottom);
    
;     Gadget(6, 8+300,  10, 140, height, text_h,                    #__text_right|#__text_top);
  *g3 = EditorGadget(-1, 8+300,  (height+5)*1+10, 140, height)
  SetGadgetText(*g3, text_h);,       #__text_right|#__text_center);
;     Gadget(8, 8+300,  (height+5)*2+10, 140, height, text_h,       #__text_right|#__text_bottom);
;     
  
  CocoaMessage(0,GadgetID(*g2),"setAlignment:", #NSRightTextAlignment)
      CocoaMessage(0,GadgetID(*g3),"setAlignment:", #NSCenterTextAlignment)
      
;      ;*g4 = Splitter(10,10,140*3+10,200, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
;      *g4 = SplitterGadget(-1,0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
;      *g5 = SplitterGadget(-1,10,10,140*3+10,200, *g4,*g3, #PB_Splitter_Vertical)
;      SetGadgetState(*g4, 140)
;      SetGadgetState(*g5, 140*2)
     
     
     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 29
; FirstLine = 15
; Folding = -
; EnableXP