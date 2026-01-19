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
                       "Who should show." + m.s +
                        m.s +
;                        m.s +
;                        m.s +
                       "I have to write the text in the box or not." + m.s +
                        m.s +
;                        m.s +
;                        m.s +
                       "The string must be very long." + m.s +
                       "Otherwise it will not work." ;+ m.s; +
    
    ProcedureReturn Text
  EndProcedure
  
  Define cr.s = #LF$, Text.s
  Text = get_text( )
  Text = "V & H" + cr + " multiline " + cr + "text"
  ;Text = "text ";
  
  Global *this._s_widget,
         Tree,
         gadget,
         Button_type,
         button_default,
         button_multiline,
         button_left,
         button_right,
         button_toggle,
         button_top,
         button_bottom,
         button_center,
         button_vertical,
         button_invert,
         button_mirror,
         Splitter_0,
         Splitter_1,
         Splitter_2,
         Splitter_3,
         Splitter_4
  
  Define Width = 560, Height = 560, pos = 60
  
  Procedure events_widgets()
    Protected Flag.q, EventWidget = EventWidget( )
    
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
          Case button_default   : Flag = #__flag_button_Default
          Case button_multiline : Flag = #__flag_TextMultiline
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
              Case button_top       : Flag = #__flag_TextTop     
              Case button_left      : Flag = #PB_Button_Left
              Case button_right     : Flag = #PB_Button_Right
              Case button_bottom    : Flag = #__flag_TextBottom
              Case button_center    : Flag = #__flag_TextCenter
            EndSelect
            ;
          Case button_toggle    : Flag = #PB_Button_Toggle
          Case button_invert    : Flag = #__flag_TextInvert
          Case button_vertical  : Flag = #__flag_TextVertical
          Case button_mirror    ;: flag = #__flag_TextMirror
             Debug "ЕЩЕ НЕ РЕАЛИЗОВАНО"
        EndSelect
        
        If Flag
          Flag(*this, Flag, GetState(EventWidget))
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
    *this  = Widget::Button(100, 100, 250, 200, Text, #PB_Button_MultiLine);|)
    
    Define Y  = 10
    Define bh = 24
    Define p = bh+5
    ; flag
    Button_type      = Widget::Button(Width + 45, Y, 100, p, "gadget", #PB_Button_Toggle)
    button_default   = Widget::Button(Width + 45, Y + p * 1, 100, bh, "default", #PB_Button_Toggle)
    button_multiline = Widget::Button(Width + 45, Y + p * 2, 100, bh, "multiline", #PB_Button_Toggle)
    button_top       = Widget::Button(Width + 45, Y + p * 3, 100, bh, "top", #PB_Button_Toggle)
    button_left      = Widget::Button(Width + 45, Y + p * 4, 100, bh, "left", #PB_Button_Toggle)
    button_center    = Widget::Button(Width + 45, Y + p * 5, 100, bh, "center", #PB_Button_Toggle)
    button_right     = Widget::Button(Width + 45, Y + p * 6, 100, bh, "right", #PB_Button_Toggle)
    button_bottom    = Widget::Button(Width + 45, Y + p * 7, 100, bh, "bottom", #PB_Button_Toggle)
    button_toggle    = Widget::Button(Width + 45, Y + p * 8, 100, bh, "toggle", #PB_Button_Toggle)
    button_vertical  = Widget::Button(Width + 45, Y + p * 9, 100, bh, "vertical", #PB_Button_Toggle)
    button_invert    = Widget::Button(Width + 45, Y + p * 10, 100, bh, "invert", #PB_Button_Toggle)
    button_mirror    = Widget::Button(Width + 45, Y + p * 11, 100, bh, "mirror", #PB_Button_Toggle)
    
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
    ;Flag(*this, #__flag_TextMultiline)
    ;Debug _Flag(*this, #__flag_TextMultiline)
    ;\\ set button toggled state
    SetState(button_multiline, Flag(*this, #PB_Button_MultiLine ))
    SetState(button_center, Flag(*this, #__flag_TextCenter))
    Hide(Button_type, 1)
    
    ;\\
    Splitter_0 = Widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = Widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = Widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = Widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
        
;     ;ReDraw(root())
;     ;  Flag(*this, #__flag_TextTop|#PB_Button_left, 1)
;     
    
;     ;\\
;     SetState(Splitter_0, pos)
;     SetState(Splitter_1, pos)
;     SetState(Splitter_3, Width - pos - #__bar_splitter_size)
;     SetState(Splitter_2, Height - pos - #__bar_splitter_size)
;     
; ;     
; ;     Debug ""+*this\scroll_x( )+" "+*this\scroll_width( )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 258
; FirstLine = 239
; Folding = ----
; EnableXP
; DPIAware