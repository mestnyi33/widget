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
  
  Define Width = 560, Height = 560, pos = 60
  
  Procedure events_widgets()
    Protected Flag, EventWidget = EventWidget( )
    
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
          Case button_default   : Flag = #PB_Button_Default
          Case button_multiline : Flag = #__flag_Textmultiline
            ;
          Case button_top,
               button_left,
               button_right,
               button_bottom,
               button_center
            
            ;
            If EventWidget <> button_top 
              Flag(*this, #__flag_TextTop, 0)
              SetState(button_top,0) 
            EndIf
            If EventWidget <> button_left 
              Flag(*this, #__flag_Textleft, 0)
              SetState(button_left,0) 
            EndIf
            If EventWidget <> button_right 
              Flag(*this, #__flag_TextRight, 0)
              SetState(button_right,0) 
            EndIf
            If EventWidget <> button_bottom 
              Flag(*this, #__flag_TextBottom, 0)
              SetState(button_bottom,0) 
            EndIf
            If EventWidget <> button_center 
              Flag(*this, #__flag_TextCenter, 0)
              SetState(button_center,0) 
            EndIf
            
            Select EventWidget
              Case button_top       : Flag = #__flag_TextTop     
              Case button_left      : Flag = #__flag_Textleft
              Case button_right     : Flag = #__flag_TextRight
              Case button_bottom    : Flag = #__flag_TextBottom
              Case button_center    : Flag = #__flag_TextCenter
            EndSelect
            ;
          ;Case button_toggle    : flag = #PB_ComboBox_ThreeState
          Case button_invert    : Flag = #__flag_TextInvert
          Case button_vertical  : Flag = #__flag_TextVertical
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
    gadget = ComboBoxGadget(#PB_Any, 100, 100, 250, 200) : HideGadget(gadget, 1)
    *this  = Widget::ComboBox(100, 100, 250, 200 );, #__flag_Textmultiline);|)
    AddItem( *this, -1, Text )
    
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
    
    ; flag
    Tree = Widget::Tree(Width + 20, Y + bh * 11 + 60, 150, Height - (Y + bh * 11)-50, #__flag_NoLines | #__flag_NoButtons | #__flag_OptionBoxes | #__flag_CheckBoxes | #__flag_threestate)
    AddItem(Tree, #tree_item_default, "default")
    AddItem(Tree, #tree_item_multiline, "multiline")
    AddItem(Tree, #tree_item_text, "text alignment", -1, 0)
    AddItem(Tree, #tree_item_top, "top", -1, 1)
    AddItem(Tree, #tree_item_left, "left", -1, 1)
    AddItem(Tree, #tree_item_center, "center", -1, 1)
    AddItem(Tree, #tree_item_right, "right", -1, 1)
    AddItem(Tree, #tree_item_bottom, "bottom", -1, 1)
    AddItem(Tree, #tree_item_toggle, "toggle")
    AddItem(Tree, #tree_item_vertical, "vertical")
    AddItem(Tree, #tree_item_invert, "invert")
    
    Bind(#PB_All, @events_widgets())
    
    ;\\ set button toggled state
    SetState(button_multiline, Flag(*this, #__flag_Textmultiline))
    SetState(button_center, Flag(*this, #__flag_TextCenter))
    If Button_type
       Hide(Button_type, 1)
    EndIf
 
    ;\\
    Splitter_0 = Widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = Widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical)
    Splitter_2 = Widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = Widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    ;\\
    SetState(Splitter_0, pos)
    SetState(Splitter_1, pos)
    SetState(Splitter_3, Width - pos - #__bar_splitter_size)
    SetState(Splitter_2, Height - pos - #__bar_splitter_size)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 190
; FirstLine = 172
; Folding = ----
; Optimizer
; EnableXP
; DPIAware