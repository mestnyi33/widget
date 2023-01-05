IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
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
  Global *this._s_widget, *this_container._s_widget,
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
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick
        Select EventWidget
          Case button_default   : flag = #PB_Button_Default
          Case button_top,
               button_left,
               button_right,
               button_bottom,
               button_center
            
            
;             ; Flag(*this, #PB_Button_Left|#PB_Button_Right|#__text_top|#__text_bottom, 0)
;             ;
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
            ;  Flag(*this, #__text_center, 0)
              SetState(button_center,0) 
            EndIf
;             
;             If GetState(button_left) And GetState(button_bottom)
;              ; Flag(*this, #PB_Button_Left|#__text_bottom, 1)
;             ElseIf GetState(button_right) And GetState(button_bottom)
;              ; Flag(*this, #PB_Button_Right|#__text_bottom, 1)
;             ElseIf GetState(button_left) And GetState(button_top)
;              ; Flag(*this, #PB_Button_Left|#__text_top, 1)
;             ElseIf GetState(button_right) And GetState(button_top)
;              ; Flag(*this, #PB_Button_Right|#__text_top, 1)
;             ElseIf GetState(button_left)
;              ; Flag(*this, #PB_Button_Left, 1)
;             ElseIf GetState(button_right) 
;              ; Flag(*this, #PB_Button_Right, 1)
;             ElseIf GetState(button_bottom)
;              ; Flag(*this, #__text_bottom, 1)
;             ElseIf GetState(button_top)
;              ; Flag(*this, #__text_top, 1)
;             EndIf
;             
            If GetState(button_left)=0 And 
               GetState(button_top)=0 And 
               GetState(button_right)=0 And
               GetState(button_bottom)=0
              SetState(button_center,1) 
             ; Flag(*this, #__text_center, 1)
            EndIf
            
            Protected left = 0, top = 0, right = 0, bottom = 0, center = 0, mode
            ;
            Select EventWidget
              Case button_top       : top = 1   
              Case button_left      : Left = 1
              Case button_right     : right = 1
              Case button_bottom    : bottom = 1
              Case button_center    : center = 1
                mode = #__align_auto
            EndSelect
            
            SetAlignment(*this, mode, Left, top, right, bottom )
        EndSelect
         
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width + 180, height + 20, "change button flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    *this_container  = widget::Container(100, 100, 250, 200)
    *this  = widget::Button(100, 100, 250, 200, text, #PB_Button_MultiLine) : Closelist( )
    
    Define y  = 10
    Define bh = 24
    ; flag
    Button_type      = widget::Button(width + 45, y, 100, 26, "gadget", #PB_Button_Toggle)
    button_default   = widget::Button(width + 45, y + bh * 1, 100, 26, "default", #PB_Button_Toggle)
    button_top       = widget::Button(width + 45, y + bh * 3, 100, 26, "top", #PB_Button_Toggle)
    button_left      = widget::Button(width + 45, y + bh * 4, 100, 26, "left", #PB_Button_Toggle)
    button_center    = widget::Button(width + 45, y + bh * 5, 100, 26, "center", #PB_Button_Toggle)
    button_right     = widget::Button(width + 45, y + bh * 6, 100, 26, "right", #PB_Button_Toggle)
    button_bottom    = widget::Button(width + 45, y + bh * 7, 100, 26, "bottom", #PB_Button_Toggle)
    
;     ; flag
;     tree = widget::Tree(width + 20, y + bh * 11 + 10, 150, height - (y + bh * 11), #__Tree_NoLines | #__Tree_NoButtons | #__tree_OptionBoxes | #__tree_CheckBoxes | #__Tree_threestate)
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
    SetState(button_center, 1)
    Hide(Button_type, 1)
    
    ;\\
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this_container, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    ;\\
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, width - pos - #__splitter_buttonsize)
    SetState(Splitter_2, height - pos - #__splitter_buttonsize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP