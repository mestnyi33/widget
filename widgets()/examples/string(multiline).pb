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
  
  If OpenWindow(0, 0, 0, 615, (height+5)*8+20+110, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *S_0 = GetGadgetData(Gadget(0, 8,  10, 140, height, text_h, #__flag_gridlines|#__string_readonly|#__text_top|#__string_multiline))
    *S_1 = GetGadgetData(Gadget(1, 8,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__string_multiline))
    *S_2 = GetGadgetData(Gadget(2, 8,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__text_bottom|#__string_multiline))
    
    *S_0 = GetGadgetData(Gadget(-1, 8+150,  10, 140, height, text_h, #__flag_gridlines|#__string_readonly|#__text_top|#__string_right|#__string_multiline))
    *S_1 = GetGadgetData(Gadget(-1, 8+150,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__string_right|#__string_multiline))
    *S_2 = GetGadgetData(Gadget(-1, 8+150,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__text_bottom|#__string_right|#__string_multiline))
    
    *S_3 = GetGadgetData(Gadget(3, 8,  (height+5)*3+10, 290, height, text_h,#__flag_gridlines| #__string_uppercase|#__string_center|#__string_multiline))
    *S_4 = GetGadgetData(Gadget(4, 8, (height+5)*4+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__string_lowercase|#__text_top|#__string_multiline))
    *S_5 = GetGadgetData(Gadget(5, 8, (height+5)*5+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__flag_borderless|#__string_multiline))
    *S_6 = GetGadgetData(Gadget(6, 8, (height+5)*6+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__text_bottom|#__string_multiline))
     *S_7 = GetGadgetData(Gadget(7, 8, (height+5)*7+10, 290, height, "", #__flag_gridlines|#__string_password|#__string_multiline))
     *S_8 = GetGadgetData(Gadget(8, 8, (height+5)*8+10, 290, 90+20, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline|#__string_multiline))
                               
    *S_10 = GetGadgetData(Gadget(10, 305+8,  10, 140, height, text_h, #__flag_gridlines|#__string_readonly|#__text_top|#__text_invert|#__string_multiline))
    *S_11 = GetGadgetData(Gadget(11, 305+8,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__text_invert|#__string_multiline))
    *S_12 = GetGadgetData(Gadget(12, 305+8,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__text_bottom|#__text_invert|#__string_multiline))
    
    *S_10 = GetGadgetData(Gadget(-1, 305+8+150,  10, 140, height, text_h, #__flag_gridlines|#__string_readonly|#__text_top|#__string_right|#__text_invert|#__string_multiline))
    *S_11 = GetGadgetData(Gadget(-1, 305+8+150,  (height+5)*1+10, 140, height, text_h, #__flag_gridlines|#__string_right|#__text_invert|#__string_multiline))
    *S_12 = GetGadgetData(Gadget(-1, 305+8+150,  (height+5)*2+10, 140, height, text_h, #__flag_gridlines|#__string_right|#__text_bottom|#__text_invert|#__string_multiline))
    
    *S_13 = GetGadgetData(Gadget(13, 305+8,  (height+5)*3+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__string_lowercase|#__string_center|#__text_invert|#__string_multiline))
    *S_14 = GetGadgetData(Gadget(14, 305+8, (height+5)*4+10, 290, height, text_v,#__flag_gridlines| #__flag_vertical|#__text_top|#__string_right|#__text_invert|#__string_multiline))
    *S_15 = GetGadgetData(Gadget(15, 305+8, (height+5)*5+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__flag_borderless|#__string_right|#__text_invert|#__string_multiline))
    *S_16 = GetGadgetData(Gadget(16, 305+8, (height+5)*6+10, 290, height, text_v, #__flag_gridlines|#__flag_vertical|#__text_bottom|#__string_right|#__text_invert|#__string_multiline))
     *S_17 = GetGadgetData(Gadget(17, 305+8, (height+5)*7+10, 290, height, Text1, #__string_password|#__string_multiline))
     *S_18 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90+20, Text, #__flag_gridlines|#__flag_gridlines|#__flag_numeric|#__text_wordwrap))
                             
    SetText(*S_17, "GaT")
    Debug "Get widget text "+GetText(*S_17)
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP