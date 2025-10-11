IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  Global Button_6, Button_7, Button_8
  
  Define vert=100, horiz=100, Width=400, Height=440
  
  Procedure.s get_text(m.s=#LF$)
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
      Case #PB_EventType_LeftClick
        Select EventWidget( )
          Case *this
            If Flag(*this, #PB_Button_Toggle)
              SetState(Button_4, GetState(EventWidget( )))
            EndIf
            
          Case Button_type 
            If GetState(EventWidget( ))
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
            
          Case Button_0 : flag = #__flag_button_Default
          Case Button_1 : flag = #__flag_Textmultiline
          Case Button_2 : flag = #__flag_Textleft
          Case Button_3 : flag = #__flag_Textright
          Case Button_4 : flag = #PB_Button_Toggle
          Case Button_5 : flag = #__flag_Texttop
          Case Button_6 : flag = #__flag_Textbottom
          Case Button_7 : flag = #__flag_Textinvert
          Case Button_8 : flag = #__flag_Textvertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget( )))
        EndIf
    EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, Width+180, Height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, Text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    ;*this = widget::Button(100, 100, 250, 250, get_text(), #__flag_Textmultiline);|);|#__flag_Textleft) 
    *this = widget::Editor(100, 100, 250, 250, #__flag_Textwordwrap) : SetText(*this, get_text())
    
    Define Y = 10
    ; flag
    Button_type = widget::Button(Width+45,   Y, 100, 26, "gadget", #PB_Button_Toggle) 
    Button_0 = widget::Button(Width+45, Y+30*1, 100, 26, "default", #PB_Button_Toggle) 
    Button_1 = widget::Button(Width+45, Y+30*2, 100, 26, "multiline", #PB_Button_Toggle) 
    Button_4 = widget::Button(Width+45, Y+30*3, 100, 26, "wordwrap", #PB_Button_Toggle) 
    
    Button_5 = widget::Button(Width+45, Y+30*4, 100, 26, "top", #PB_Button_Toggle) 
    Button_2 = widget::Button(Width+45, Y+30*5, 45, 26, "left", #PB_Button_Toggle) 
    Button_3 = widget::Button(Width+45 + 55, Y+30*5, 45, 26, "right", #PB_Button_Toggle) 
    Button_6 = widget::Button(Width+45, Y+30*6, 100, 26, "bottom", #PB_Button_Toggle) 
    
    Button_8 = widget::Button(Width+45, Y+30*7, 100, 26, "vertical", #PB_Button_Toggle) 
    Button_7 = widget::Button(Width+45, Y+30*8, 100, 26, "invert", #PB_Button_Toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(Button_1, Flag(*this, #__flag_Textmultiline))
    SetState(Button_4, Flag(*this, #__flag_Textwordwrap))
    SetState(Button_5, Flag(*this, #__flag_Texttop))
    SetState(Button_2, Flag(*this, #__flag_Textleft))
    SetState(Button_3, Flag(*this, #__flag_Textright))
    SetState(Button_6, Flag(*this, #__flag_Textbottom))
    Hide(Button_type, 1)
    
        Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
        Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
        Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
        Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
;         SetState(Splitter_0, vert)
;         SetState(Splitter_1, horiz)
         SetState(Splitter_3, width-horiz)
         SetState(Splitter_2, height-vert)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 62
; FirstLine = 52
; Folding = --
; Optimizer
; EnableXP
; DPIAware