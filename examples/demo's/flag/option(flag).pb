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
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  ; cr = "" : text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  text.s = get_text( )
  Global *this._s_widget,
         tree,
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
         Splitter_0,
         Splitter_1,
         Splitter_2,
         Splitter_3,
         Splitter_4
  
  Define width = 560, height = 560, pos = 60
  
  Procedure events_widgets()
    Protected flag, EventWidget = EventWidget( )
    
    Select WidgetEvent( )
      Case #PB_EventType_LeftClick
        Select EventWidget
          Case *this
            If Flag(*this, #__flag_ButtonToggle)
              SetState(button_toggle, GetState(EventWidget))
            EndIf
            
          Case Button_type
            If GetState(EventWidget)
              HideWidget(*this, 1)
              HideGadget(gadget, 0)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
              EndIf
              SetText(Button_type, "widget")
            Else
              HideWidget(*this, 0)
              HideGadget(gadget, 1)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
              EndIf
              SetText(Button_type, "gadget")
            EndIf
            
            ;
          Case button_default   : flag = #PB_Button_Default
          Case button_multiline : flag = #__flag_Textmultiline
            ;
          Case button_top,
               button_left,
               button_right,
               button_bottom,
               button_center
            
            Flag(*this, #__flag_Textleft|#__flag_Textright|#__flag_Texttop|#__flag_Textbottom, 0)
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
              Flag(*this, #PB_CheckBox_Center, 0)
              SetState(button_center,0) 
            EndIf
            
            If GetState(button_left) And GetState(button_bottom)
              Flag(*this, #__flag_Textleft|#__flag_Textbottom, 1)
            ElseIf GetState(button_right) And GetState(button_bottom)
              Flag(*this, #__flag_Textright|#__flag_Textbottom, 1)
            ElseIf GetState(button_left) And GetState(button_top)
              Flag(*this, #__flag_Textleft|#__flag_Texttop, 1)
            ElseIf GetState(button_right) And GetState(button_top)
              Flag(*this, #__flag_Textright|#__flag_Texttop, 1)
            ElseIf GetState(button_left)
              Flag(*this, #__flag_Textleft, 1)
            ElseIf GetState(button_right) 
              Flag(*this, #__flag_Textright, 1)
            ElseIf GetState(button_bottom)
              Flag(*this, #__flag_Textbottom, 1)
            ElseIf GetState(button_top)
              Flag(*this, #__flag_Texttop, 1)
            EndIf
            
            If GetState(button_left)=0 And 
               GetState(button_top)=0 And 
               GetState(button_right)=0 And
               GetState(button_bottom)=0
              SetState(button_center,1) 
              Flag(*this, #__flag_Textcenter, 1)
            EndIf
            
            Select EventWidget
              Case button_top       : flag = #__flag_Texttop     
              Case button_left      : flag = #__flag_Textleft
              Case button_right     : flag = #__flag_Textright
              Case button_bottom    : flag = #__flag_Textbottom
              Case button_center    : flag = #__flag_Textcenter
            EndSelect
            ;
          ;Case button_toggle    : flag = #PB_Option_ThreeState
          Case button_invert    : flag = #__flag_Textinvert
          Case button_vertical  : flag = #__flag_Textvertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget))
        EndIf
        
      Case #PB_EventType_Change
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
  
  If Open(0, 0, 0, width + 180, height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = OptionGadget(#PB_Any, 100, 100, 250, 200, text) : HideGadget(gadget, 1)
    *this  = widget::Option(100, 100, 250, 200, text, #__flag_Textmultiline);|)
    
    Define y  = 10
    Define bh = 24
    Define p = bh+5
    ; flag
    ;Button_type      = widget::Button(width + 45, y, 100, p, "gadget", #__flag_ButtonToggle)
    button_default   = widget::Button(width + 45, y + p * 1, 100, bh, "default", #__flag_ButtonToggle)
    button_multiline = widget::Button(width + 45, y + p * 2, 100, bh, "multiline", #__flag_ButtonToggle)
    button_top       = widget::Button(width + 45, y + p * 3, 100, bh, "top", #__flag_ButtonToggle)
    button_left      = widget::Button(width + 45, y + p * 4, 100, bh, "left", #__flag_ButtonToggle)
    button_center    = widget::Button(width + 45, y + p * 5, 100, bh, "center", #__flag_ButtonToggle)
    button_right     = widget::Button(width + 45, y + p * 6, 100, bh, "right", #__flag_ButtonToggle)
    button_bottom    = widget::Button(width + 45, y + p * 7, 100, bh, "bottom", #__flag_ButtonToggle)
    button_toggle    = widget::Button(width + 45, y + p * 8, 100, bh, "toggle", #__flag_ButtonToggle)
    button_vertical  = widget::Button(width + 45, y + p * 9, 100, bh, "vertical", #__flag_ButtonToggle)
    button_invert    = widget::Button(width + 45, y + p * 10, 100, bh, "invert", #__flag_ButtonToggle)
    
;     ; flag
;     tree = widget::Tree(width + 20, y + bh * 11 + 10, 150, height - (y + bh * 11), #__Tree_NoLines | #__Tree_NoButtons | #__flag_optionboxes | #__tree_Optiones | #__Tree_threestate)
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
    
    ;\\ set button toggled state
    SetState(button_multiline, Flag(*this, #__flag_Textmultiline))
    SetState(button_left, Flag(*this, #__flag_Textleft))
    If Button_type
       HideWidget(Button_type, 1)
    EndIf
    ;\\
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    ;\\
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width - pos - #__splittersize)
    SetState(Splitter_2, height - pos - #__splittersize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 231
; FirstLine = 203
; Folding = ----
; EnableXP
; DPIAware