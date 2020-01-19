IncludePath "../"
XIncludeFile "widgets().pbi"
;XIncludeFile "widgets(_align_0_0_0).pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  
  UseModule widget
  UseModule constants
  ;   UseModule structures
  
  Macro gadget(id, x,y,width,height,text,flag)
    button(x,y,width,height,text,flag)
  EndMacro
  
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._s_widget
  Global *Button_1._s_widget
  
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
  
  Define height=110, Text1.s = " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
  
  Define Text.s, m.s=#LF$
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s; +
  
  Define text_v.s = "Standard"+ m.s +"Button Button"+ m.s +"(Vertical)"
  Define text_h.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4)
  
  If Open(0, 0, 0, 908, (height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *S_0 = (Gadget(0, 8,  10, 140, height, text_h,                       #__flag_gridlines|#__button_multiline|#__text_left|#__text_top))
    *S_1 = (Gadget(1, 8,  (height+5)*1+10, 140, height, text_h,          #__flag_gridlines|#__button_multiline|#__text_left))
    *S_2 = (Gadget(2, 8,  (height+5)*2+10, 140, height, text_h,          #__flag_gridlines|#__button_multiline|#__text_left|#__text_bottom))
    
    *S_0 = (Gadget(3, 8+150,  10, 140, height, text_h,                  #__flag_gridlines|#__button_multiline|#__string_center|#__text_top|#__string_readonly))
    *S_1 = (Gadget(4, 8+150,  (height+5)*1+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__string_center))
    *S_2 = (Gadget(5, 8+150,  (height+5)*2+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__string_center|#__text_bottom))
    
    *S_0 = (Gadget(6, 8+300,  10, 140, height, text_h,                  #__flag_gridlines|#__button_multiline|#__string_right|#__text_top|#__string_readonly))
    *S_1 = (Gadget(7, 8+300,  (height+5)*1+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__string_right))
    *S_2 = (Gadget(8, 8+300,  (height+5)*2+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__string_right|#__text_bottom))
    
    
    *S_0 = (Gadget(10, 8+450,  10, 140, height, text_h,                   #__flag_gridlines|#__button_multiline|#__text_invert|#__text_left|#__text_top))
    *S_1 = (Gadget(11, 8+450,  (height+5)*1+10, 140, height, text_h,      #__flag_gridlines|#__button_multiline|#__text_invert|#__text_left))
    *S_2 = (Gadget(12, 8+450,  (height+5)*2+10, 140, height, text_h,      #__flag_gridlines|#__button_multiline|#__text_invert|#__text_left|#__text_bottom))
    
    *S_0 = (Gadget(13, 8+150+450,  10, 140, height, text_h,              #__flag_gridlines|#__button_multiline|#__text_invert|#__string_center|#__text_top|#__string_readonly))
    *S_1 = (Gadget(14, 8+150+450,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__text_invert|#__string_center))
    *S_2 = (Gadget(15, 8+150+450,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__text_invert|#__string_center|#__text_bottom))
    
    *S_0 = (Gadget(16, 8+300+450,  10, 140, height, text_h,              #__flag_gridlines|#__button_multiline|#__text_invert|#__string_right|#__text_top|#__string_readonly))
    *S_1 = (Gadget(17, 8+300+450,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__text_invert|#__string_right))
    *S_2 = (Gadget(18, 8+300+450,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__text_invert|#__string_right|#__text_bottom))
    
    
    
    *S_0 = (Gadget(20, 8,  (height+5)*3+10, 140, height, text_h,          #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_left|#__text_top))
    *S_1 = (Gadget(21, 8,  (height+5)*4+10, 140, height, text_h,          #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_left))
    *S_2 = (Gadget(22, 8,  (height+5)*5+10, 140, height, text_h,          #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_left|#__text_bottom))
    
    *S_0 = (Gadget(23, 8+150,  (height+5)*3+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_center|#__text_top|#__string_readonly))
    *S_1 = (Gadget(24, 8+150,  (height+5)*4+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_center))
    *S_2 = (Gadget(25, 8+150,  (height+5)*5+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_center|#__text_bottom))
    
    *S_0 = (Gadget(26, 8+300,  (height+5)*3+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_right|#__text_top|#__string_readonly))
    *S_1 = (Gadget(27, 8+300,  (height+5)*4+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_right))
    *S_2 = (Gadget(28, 8+300,  (height+5)*5+10, 140, height, text_h,     #__flag_gridlines|#__button_multiline|#__flag_vertical|#__string_right|#__text_bottom))
    
    
    *S_0 = (Gadget(30, 8+450,  (height+5)*3+10, 140, height, text_h,      #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_top))
    *S_1 = (Gadget(31, 8+450,  (height+5)*4+10, 140, height, text_h,      #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__text_left))
    *S_2 = (Gadget(32, 8+450,  (height+5)*5+10, 140, height, text_h,      #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_bottom))
    
    *S_0 = (Gadget(33, 8+150+450,  (height+5)*3+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_center|#__text_top|#__string_readonly))
    *S_1 = (Gadget(34, 8+150+450,  (height+5)*4+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_center))
    *S_2 = (Gadget(35, 8+150+450,  (height+5)*5+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_center|#__text_bottom))
    
    *S_0 = (Gadget(36, 8+300+450,  (height+5)*3+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_right|#__text_top|#__string_readonly))
    *S_1 = (Gadget(37, 8+300+450,  (height+5)*4+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_right))
    *S_2 = (Gadget(38, 8+300+450,  (height+5)*5+10, 140, height, text_h, #__flag_gridlines|#__button_multiline|#__flag_vertical|#__text_invert|#__string_right|#__text_bottom))
    
    
    redraw(root())
  EndIf
  
  
  Global c2
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate) 
    Protected Height = WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)
    
    Resize(*Button_0, Width-90, #PB_Ignore, #PB_Ignore, Height-40)
    Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-110, Height-40)
    ResizeGadget(c2, 10, 10, Width-20, Height-20)
    SetWindowTitle(EventWindow(), Str(*Button_1\width))
  EndProcedure
  
  If Open(11, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    c2 = GetGadget(Root())
    
    Define m.s = #LF$, Text.s = "This is a long line." + m.s +
                                "Who should show." + 
                                m.s +
                                m.s +
                                m.s +
                                m.s +
                                "I have to write the text in the box or not." + 
                                m.s +
                                m.s +
                                m.s +
                                m.s +
                                "The string must be very long." + m.s +
                                "Otherwise it will not work." ;+ m.s +
    
    
    With *Button_1
      ResizeImage(0, 32,32)
      *Button_1 = Editor(10, 10, 180,  120);, #__text_multiline)
      SetText(*Button_1, Text)
      ;\Cursor = #PB_cursor_hand
      ;SetColor(*Button_1, #PB_Gadget_frontColor, $4919D5)
      ;SetFont(*Button_1, FontID(0))
    EndWith
    
    With *Button_0
      *Button_0 = Editor(200, 10,  180, 120, #__editor_wordwrap)
      SetText(*Button_0, Text)
      ;       SetColor(*Button_0, #PB_Gadget_backColor, $CCBFB4)
      ;SetColor(*Button_0, #PB_Gadget_frontColor, $D56F1A)
      ;SetFont(*Button_0, FontID(0))
    EndWith
    
    ;     With *Button_1
    ;       ResizeImage(0, 32,32)
    ;       *Button_1 = Button(10, 42, 250,  60, "Button (Horisontal)", #__text_multiline,-1)
    ;       ;       SetColor(*Button_1, #PB_Gadget_backColor, $D58119)
    ;       \Cursor = #PB_cursor_hand
    ;       SetColor(*Button_1, #PB_Gadget_frontColor, $4919D5)
    ;       ;SetFont(*Button_1, FontID(0))
    ;     EndWith
    
    ;     With *Button_0
    ;       *Button_0 = Button(270, 10,  60, 120, "Button (Vertical)", #__text_multiline | #__flag_vertical)
    ;       ;       SetColor(*Button_0, #PB_Gadget_backColor, $CCBFB4)
    ;       SetColor(*Button_0, #PB_Gadget_frontColor, $D56F1A)
    ;       ;SetFont(*Button_0, FontID(0))
    ;     EndWith
    
    redraw(root())
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    ;PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
    ;     BindGadgetEvent(g, @CallBacks())
    ;     PostEvent(#PB_Event_gadget, 11,11, #PB_EventType_resize)
    ;     
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP