XIncludeFile "../string().pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  UseModule constants
  
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
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget"
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget"
      EndIf
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, XAlign.f)
    EndImport
  CompilerEndIf
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
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
  
  If OpenWindow(0, 0, 0, 908, (height+5)*5+20+110, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *S_0 = GetGadgetData(Gadget(0, 8,  10, 140, height, text_h,                        #__flag_gridlines|#__string_multiline|#__text_left|#__text_top))
    *S_1 = GetGadgetData(Gadget(1, 8,  (height+5)*1+10, 140, height, text_h,           #__flag_gridlines|#__string_multiline|#__text_left))
    *S_2 = GetGadgetData(Gadget(2, 8,  (height+5)*2+10, 140, height, text_h,           #__flag_gridlines|#__string_multiline|#__text_left|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(3, 8+150,  10, 140, height, text_h,                    #__flag_gridlines|#__string_multiline|#__string_center|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(4, 8+150,  (height+5)*1+10, 140, height, text_h,       #__flag_gridlines|#__string_multiline|#__string_center))
    *S_2 = GetGadgetData(Gadget(5, 8+150,  (height+5)*2+10, 140, height, text_h,       #__flag_gridlines|#__string_multiline|#__string_center|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(6, 8+300,  10, 140, height, text_h,                    #__flag_gridlines|#__string_multiline|#__string_right|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(7, 8+300,  (height+5)*1+10, 140, height, text_h,       #__flag_gridlines|#__string_multiline|#__string_right))
    *S_2 = GetGadgetData(Gadget(8, 8+300,  (height+5)*2+10, 140, height, text_h,       #__flag_gridlines|#__string_multiline|#__string_right|#__text_bottom))
    
    
    *S_0 = GetGadgetData(Gadget(10, 8+450,  10, 140, height, text_h,                   #__flag_gridlines|#__string_multiline|#__text_invert|#__text_left|#__text_top))
    *S_1 = GetGadgetData(Gadget(11, 8+450,  (height+5)*1+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__text_invert|#__text_left))
    *S_2 = GetGadgetData(Gadget(12, 8+450,  (height+5)*2+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__text_invert|#__text_left|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(13, 8+150+450,  10, 140, height, text_h,               #__flag_gridlines|#__string_multiline|#__text_invert|#__string_center|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(14, 8+150+450,  (height+5)*1+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__text_invert|#__string_center))
    *S_2 = GetGadgetData(Gadget(15, 8+150+450,  (height+5)*2+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__text_invert|#__string_center|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(16, 8+300+450,  10, 140, height, text_h,               #__flag_gridlines|#__string_multiline|#__text_invert|#__string_right|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(17, 8+300+450,  (height+5)*1+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__text_invert|#__string_right))
    *S_2 = GetGadgetData(Gadget(18, 8+300+450,  (height+5)*2+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__text_invert|#__string_right|#__text_bottom))
    
    
    
    *S_0 = GetGadgetData(Gadget(20, 8,  (height+5)*3+10, 140, height, text_h,          #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_left|#__text_top))
    *S_1 = GetGadgetData(Gadget(21, 8,  (height+5)*4+10, 140, height, text_h,          #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_left))
    *S_2 = GetGadgetData(Gadget(22, 8,  (height+5)*5+10, 140, height, text_h,          #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_left|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(23, 8+150,  (height+5)*3+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_center|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(24, 8+150,  (height+5)*4+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_center))
    *S_2 = GetGadgetData(Gadget(25, 8+150,  (height+5)*5+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_center|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(26, 8+300,  (height+5)*3+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_right|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(27, 8+300,  (height+5)*4+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_right))
    *S_2 = GetGadgetData(Gadget(28, 8+300,  (height+5)*5+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__string_right|#__text_bottom))
    
    
    *S_0 = GetGadgetData(Gadget(30, 8+450,  (height+5)*3+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_top))
    *S_1 = GetGadgetData(Gadget(31, 8+450,  (height+5)*4+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__text_left))
    *S_2 = GetGadgetData(Gadget(32, 8+450,  (height+5)*5+10, 140, height, text_h,      #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__text_left|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(33, 8+150+450,  (height+5)*3+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_center|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(34, 8+150+450,  (height+5)*4+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_center))
    *S_2 = GetGadgetData(Gadget(35, 8+150+450,  (height+5)*5+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_center|#__text_bottom))
    
    *S_0 = GetGadgetData(Gadget(36, 8+300+450,  (height+5)*3+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_right|#__text_top|#__string_readonly))
    *S_1 = GetGadgetData(Gadget(37, 8+300+450,  (height+5)*4+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_right))
    *S_2 = GetGadgetData(Gadget(38, 8+300+450,  (height+5)*5+10, 140, height, text_h,  #__flag_gridlines|#__string_multiline|#__flag_vertical|#__text_invert|#__string_right|#__text_bottom))
    
                       
;     SetText(*S_17, "GaT")
;     Debug "Get widget text "+GetText(*S_17)
;     
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP