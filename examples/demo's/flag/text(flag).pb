IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Enumeration 
    #tree_item_default
    #tree_item_multiline
    #tree_item_text
    #tree_item_top
    #tree_item_left
    #tree_item_center
    #tree_item_right
    #tree_item_bottom
    #tree_item_toggle
    #tree_item_vertical
    #tree_item_invert
  EndEnumeration
  
  Procedure.s get_text(m.s = #LF$)
    Protected Text.s = "This is a long line." + m.s +
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
    
    ProcedureReturn Text
  EndProcedure
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  ; cr = "" : text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Text.s = get_text( )
  Global *this._s_widget,
         Tree,
         gadget,
         Container,
         Button_type,
         button_default,
         button_multiline,
         button_full,
         button_lt,
         button_rt,
         button_lb,
         button_rb,
         button_left,
         button_right,
         button_toggle,
         button_top,
         button_bottom,
         button_center,
         button_vertical,
         button_invert,
         Splitter_0,
         Splitter_1,
         Splitter_2,
         Splitter_3,
         Splitter_4
  
  Define Width = 560, Height = 560, pos = 60
  
  Procedure events_widgets()
    Protected flag.q, EventWidget = EventWidget( )
    
    Select WidgetEvent( )
      Case #__event_LeftClick
        Select EventWidget
          Case *this
            If Flag(*this, #PB_Button_Toggle)
              SetState(button_toggle, GetState(EventWidget))
            EndIf
            
          Case Button_type
            If GetState(EventWidget)
              Hide(*this, 1)
              HideGadget(gadget, 0)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
              EndIf
              SetText(Button_type, "widget")
            Else
              Hide(*this, 0)
              HideGadget(gadget, 1)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
              EndIf
              SetText(Button_type, "gadget")
            EndIf
            
            ;
          Case button_default   : flag = #PB_Button_Default
          Case button_multiline : flag = #PB_Button_MultiLine
            ;
          Case button_top,
               button_left,
               button_right,
               button_bottom,
               button_center
            
            
            Flag(*this, #PB_Button_Left|#PB_Button_Right|#__flag_TextTop|#__flag_TextBottom, 0)
            ;
            If EventWidget <> button_top And EventWidget <> button_left And EventWidget <> button_right
              SetState(button_top,0) 
            EndIf
            If EventWidget <> button_left And EventWidget <> button_top And EventWidget <> button_bottom 
              SetState(button_left,0) 
            EndIf
            If EventWidget <> button_right And EventWidget <> button_top And EventWidget <> button_bottom  
              SetState(button_right,0) 
            EndIf
            If EventWidget <> button_bottom And EventWidget <> button_left And EventWidget <> button_right 
              SetState(button_bottom,0) 
            EndIf
            If EventWidget <> button_center 
              Flag(*this, #__flag_TextCenter, 0)
              SetState(button_center,0) 
            EndIf
            
            If GetState(button_left) And GetState(button_bottom)
              Flag(*this, #PB_Button_Left|#__flag_TextBottom, 1)
            ElseIf GetState(button_right) And GetState(button_bottom)
              Flag(*this, #PB_Button_Right|#__flag_TextBottom, 1)
            ElseIf GetState(button_left) And GetState(button_top)
              Flag(*this, #PB_Button_Left|#__flag_TextTop, 1)
            ElseIf GetState(button_right) And GetState(button_top)
              Flag(*this, #PB_Button_Right|#__flag_TextTop, 1)
            ElseIf GetState(button_left)
              Flag(*this, #PB_Button_Left, 1)
            ElseIf GetState(button_right) 
              Flag(*this, #PB_Button_Right, 1)
            ElseIf GetState(button_bottom)
              Flag(*this, #__flag_TextBottom, 1)
            ElseIf GetState(button_top)
              Flag(*this, #__flag_TextTop, 1)
            EndIf
            
            If GetState(button_left)=0 And 
               GetState(button_top)=0 And 
               GetState(button_right)=0 And
               GetState(button_bottom)=0
              SetState(button_center,1) 
              Flag(*this, #__flag_TextCenter, 1)
            EndIf
            
            ;
            Select EventWidget
              Case button_top       : flag = #__flag_TextTop     
              Case button_left      : flag = #__flag_Textleft
              Case button_right     : flag = #__flag_TextRight
              Case button_bottom    : flag = #__flag_TextBottom
              Case button_center    : flag = #__flag_TextCenter
            EndSelect
            ;
          Case button_toggle    : flag = #PB_Button_Toggle
          Case button_invert    : flag = #__flag_TextInvert
          Case button_vertical  : flag = #__flag_TextVertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget))
        EndIf
        
      Case #__event_Change
;         If EventWidget <> tree
;           SetState(tree, - 1)
;         EndIf
;         
;         Select EventWidget
;           Case button_default   
;           Case button_multiline 
;           Case button_top   
;             SetState(tree, #tree_item_top)
;           Case button_left      
;             SetState(tree, #tree_item_left)
;           Case button_right     
;             SetState(tree, #tree_item_right)
;           Case button_bottom    
;             SetState(tree, #tree_item_bottom)
;           Case button_center   
;             SetState(tree, #tree_item_center)
;           Case button_toggle    
;           Case button_invert    
;           Case button_vertical  
;         EndSelect
        
    EndSelect
    
  EndProcedure
  
  
      
  If Open(0, 0, 0, Width + 180, Height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, Text, #PB_Button_MultiLine) : HideGadget(gadget, 1)
    *this  = widget::Text(100, 100, 250, 200, Text)
    
    Define Y  = 10
    Define bh = 24
    ; flag
    ; Button_type      = widget::Button(width + 45, y, 100, bh, "gadget", #PB_Button_Toggle)
    Container = Container( Width + 45, Y + bh * 1, 100, 100)
    button_full       = widget::Button(0,0,0,0, "full", #PB_Button_Toggle,-1,20)
    button_lt       = widget::Button(0,0,bh,bh, "lt", #PB_Button_Toggle,-1,20)
    button_rt      = widget::Button(0,0,bh,bh, "rt", #PB_Button_Toggle,-1,20)
    button_top       = widget::Button(0,0,bh,bh, "t", #PB_Button_Toggle,-1,20)
    button_left      = widget::Button(0,0,bh,bh, "l", #PB_Button_Toggle,-1,20)
    button_center    = widget::Button(0,0,bh,bh, "c", #PB_Button_Toggle,-1,20)
    button_right     = widget::Button(0,0,bh,bh, "r", #PB_Button_Toggle,-1,20)
    button_bottom    = widget::Button(0,0,bh,bh, "b", #PB_Button_Toggle,-1,20)
    button_lb     = widget::Button(0,0,bh,bh, "lb", #PB_Button_Toggle,-1,20)
    button_rb    = widget::Button(0,0,bh,bh, "rb", #PB_Button_Toggle,-1,20)
    
    SetAlign( button_full, #__align_full, 0,0,0,0)
    SetAlign( button_left, #__align_auto, 1,0,0,0)
    SetAlign( button_top, #__align_auto, 0,1,0,0)
    SetAlign( button_right, #__align_auto, 0,0,1,0)
    SetAlign( button_bottom, #__align_auto, 0,0,0,1)
    SetAlign( button_center, #__align_center, 0,0,0,0)
    SetAlign( button_lt, #__align_auto, 1,1,0,0)
    SetAlign( button_rt, #__align_auto, 0,1,1,0)
    SetAlign( button_rb, #__align_auto, 0,0,1,1)
    SetAlign( button_lb, #__align_auto, 1,0,0,1)
    
    ;Resize(container, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    CloseList( )
    
    ;     button_top       = widget::Button(width + 45, y + bh * 1, 100, bh, "top", #PB_Button_Toggle)
;     button_left      = widget::Button(width + 45, y + bh * 2, 100, bh, "left", #PB_Button_Toggle)
;     button_center    = widget::Button(width + 45, y + bh * 3, 100, bh, "center", #PB_Button_Toggle)
;     button_right     = widget::Button(width + 45, y + bh * 4, 100, bh, "right", #PB_Button_Toggle)
;     button_bottom    = widget::Button(width + 45, y + bh * 5, 100, bh, "bottom", #PB_Button_Toggle)
    
    button_default   = widget::Button(Width + 45, Y + bh * 6, 100, bh, "default", #PB_Button_Toggle)
    button_multiline = widget::Button(Width + 45, Y + bh * 7, 100, bh, "multiline", #PB_Button_Toggle)
    button_toggle    = widget::Button(Width + 45, Y + bh * 8, 100, bh, "toggle", #PB_Button_Toggle)
    button_vertical  = widget::Button(Width + 45, Y + bh * 9, 100, bh, "vertical", #PB_Button_Toggle)
    button_invert    = widget::Button(Width + 45, Y + bh * 10, 100, bh, "invert", #PB_Button_Toggle)
    
;     ; flag
;     tree = widget::Tree(width + 20, y + bh * 11 + 10, 150, height - (y + bh * 11), #__flag_NoLines | #__flag_NoButtons | #__flag_optionboxes | #__flag_CheckBoxes | #__flag_threestate)
;     AddItem(tree, #tree_item_default, "default")
;     AddItem(tree, #tree_item_multiline, "multiline")
;     AddItem(tree, #tree_item_text, "text alignment", -1, 0)
;     AddItem(tree, #tree_item_top, "top", -1, 1)
;     AddItem(tree, #tree_item_left, "left", -1, 1)
;     AddItem(tree, #tree_item_center, "center", -1, 1)
;     AddItem(tree, #tree_item_right, "right", -1, 1)
;     AddItem(tree, #tree_item_bottom, "bottom", -1, 1)
;     AddItem(tree, #tree_item_toggle, "toggle")
;     AddItem(tree, #tree_item_vertical, "vertical")
;     AddItem(tree, #tree_item_invert, "invert")
    
    Bind(#PB_All, @events_widgets())
    ;Flag(*this, #PB_Button_MultiLine)
    ;Debug _Flag(*this, #PB_Button_MultiLine)
    ;\\ set button toggled state
;     SetState(button_multiline, Flag(*this, #PB_Button_MultiLine ))
;     SetState(button_center, Flag(*this, #__flag_TextCenter))
;     Hide(Button_type, 1)
    
    ;\\
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    ;\\
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, Width - pos - #__bar_splitter_size)
    SetState(Splitter_2, Height - pos - #__bar_splitter_size)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 266
; FirstLine = 243
; Folding = ----
; EnableXP
; DPIAware