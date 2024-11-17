IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  Global Button_6, Button_7, Button_8
  
  Define vert=100, horiz=100, width=400, height=440
  
  Procedure.s get_TextWidget(m.s=#LF$)
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
  
  Procedure events_widgets()
    Protected flag
    
    Select WidgetEvent( )
      Case #__event_LeftClick
        Select EventWidget( )
          Case *this
            If Flag(*this, #__flag_ButtonToggle)
              SetState(Button_4, GetState(EventWidget( )))
            EndIf
            
          Case Button_type 
            If GetState(EventWidget( ))
              Hide(*this, 1)
              HideGadget(gadget, 0)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
              EndIf
              SetTextWidget(Button_type, "widget")
            Else
              Hide(*this, 0)
              HideGadget(gadget, 1)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
              EndIf
              SetTextWidget(Button_type, "gadget")
            EndIf
            
          Case Button_0 : flag = #__flag_ButtonDefault
          Case Button_1 : flag = #__flag_Textmultiline
          Case Button_2 : flag = #__flag_TextLeft
          Case Button_3 : flag = #__flag_TextRight
          Case Button_4 : flag = #__flag_ButtonToggle
          Case Button_5 : flag = #__flag_Texttop
          Case Button_6 : flag = #__flag_Textbottom
          Case Button_7 : flag = #__flag_Textinvert
          Case Button_8 : flag = #__flag_Textvertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget( )))
        EndIf
        ; Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(#PB_Any, 0, 0, width+180, height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, Text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    ;*this = widget::ButtonWidget(100, 100, 250, 250, get_TextWidget(), #__flag_Textmultiline);|);|#__flag_Textleft) 
    ContainerWidget(10, 10, width, height) : a_init( widget( ))
    *this = widget::EditorWidget(10, 10, 250, 250);, #__flag_Textwordwrap) 
    CloseList( )
    SetTextWidget(*this, get_TextWidget())
    
    Define y = 10
    ; flag
    Button_type = widget::ButtonWidget(width+45,   y, 100, 26, "gadget", #__flag_ButtonToggle) 
    Button_0 = widget::ButtonWidget(width+45, y+30*1, 100, 26, "default", #__flag_ButtonToggle) 
    Button_1 = widget::ButtonWidget(width+45, y+30*2, 100, 26, "multiline", #__flag_ButtonToggle) 
    Button_4 = widget::ButtonWidget(width+45, y+30*3, 100, 26, "wordwrap", #__flag_ButtonToggle) 
    
    Button_5 = widget::ButtonWidget(width+45, y+30*4, 100, 26, "top", #__flag_ButtonToggle) 
    Button_2 = widget::ButtonWidget(width+45, y+30*5, 45, 26, "left", #__flag_ButtonToggle) 
    Button_3 = widget::ButtonWidget(width+45 + 55, y+30*5, 45, 26, "right", #__flag_ButtonToggle) 
    Button_6 = widget::ButtonWidget(width+45, y+30*6, 100, 26, "bottom", #__flag_ButtonToggle) 
    
    Button_8 = widget::ButtonWidget(width+45, y+30*7, 100, 26, "vertical", #__flag_ButtonToggle) 
    Button_7 = widget::ButtonWidget(width+45, y+30*8, 100, 26, "invert", #__flag_ButtonToggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(Button_1, Flag(*this, #__flag_Textmultiline))
    SetState(Button_4, Flag(*this, #__flag_Textwordwrap))
    SetState(Button_5, Flag(*this, #__flag_Texttop))
    SetState(Button_2, Flag(*this, #__flag_Textleft))
    SetState(Button_3, Flag(*this, #__flag_Textright))
    SetState(Button_6, Flag(*this, #__flag_Textbottom))
    If Button_type
       Hide(Button_type, 1)
    EndIf

;         Splitter_0 = widget::SplitterWidget(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
;         Splitter_1 = widget::SplitterWidget(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
;         Splitter_2 = widget::SplitterWidget(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
;         Splitter_3 = widget::SplitterWidget(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
; ;         SetState(Splitter_0, vert)
; ;         SetState(Splitter_1, horiz)
;          SetState(Splitter_3, width-horiz)
;          SetState(Splitter_2, height-vert)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 111
; FirstLine = 84
; Folding = ---
; EnableXP
; DPIAware