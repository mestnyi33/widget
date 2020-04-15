IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
 
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Define vert=100, horiz=100, width=400, height=400
  
  Procedure GetFlag(*this._s_widget)
    Protected flag.i
    
    If *this\type = #PB_GadgetType_Button
      If *this\text\align\left ;= 1
        flag | #__button_left
      EndIf
      If *this\text\align\right ;= 1
        flag | #__button_right
      EndIf
      If *this\text\multiline ;= 1
        flag | #__button_multiline
      EndIf
      If *this\_flag & #__button_toggle
        ;         *this\_state | #__s_toggled
        ;         *this\color\state = #__s_2
        flag | #__button_toggle
      EndIf
    EndIf
    
    ProcedureReturn flag
  EndProcedure
  
  Procedure SetFlag(*this._s_widget, flag.i)
    If *this\type = #PB_GadgetType_Button
      If flag & #__button_left
        *this\text\align\left = 1
      EndIf
      If flag & #__button_right
        *this\text\align\right = 1
      EndIf
      If flag & #__button_multiline
        *this\text\multiline = 1
      EndIf
      If flag & #__button_toggle
        *this\_flag | #__button_toggle
        *this\_state | #__s_toggled
        *this\color\state = #__s_2
      EndIf
    EndIf
  EndProcedure
  
  Procedure RemoveFlag(*this._s_widget, flag.i)
    If *this\type = #PB_GadgetType_Button
      If flag & #__button_left
        *this\text\align\left = 0
      EndIf
      If flag & #__button_right
        *this\text\align\right = 0
      EndIf
      If flag & #__button_multiline
        *this\text\multiline = 0
        *this\text\string = RemoveString(*this\text\string, #LF$)
      EndIf
      If flag & #__button_toggle
        *this\_flag &~ #__button_toggle
        *this\_state &~ #__s_toggled
        *this\color\state = #__s_0
      EndIf
    EndIf
  EndProcedure
  
  Procedure events_widgets()
    Select *event\type
      Case #PB_EventType_LeftClick
        Select *event\widget
          Case Button_1
            *this\text\multiline = GetState(*event\widget)
            
            If Not *this\text\multiline
              *this\text\string = RemoveString(*this\text\string, #LF$)
            EndIf
            
          Case Button_2
            *this\text\align\left = GetState(*event\widget)
            
          Case Button_3
            *this\text\align\right = GetState(*event\widget)
            
          Case Button_4
            If GetState(*event\widget)
              *this\_flag | #__button_toggle
              *this\_state | #__s_toggled
              *this\color\state = #__s_2
            Else
              *this\_flag &~ #__button_toggle
              *this\_state &~ #__s_toggled
              *this\color\state = #__s_0
            EndIf
            
        EndSelect
        
        Post(#__event_repaint, #PB_All)
    EndSelect
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+230, height+60, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    *this = widget::Button(10, 10, 250, 200, text, #__button_multiline) 
    
    Button_0 = widget::Button(width+50, 30,   100, 30, "default", #__button_toggle) 
    Button_1 = widget::Button(width+50, 30*2, 100, 30, "multiline", #__button_toggle) 
    Button_2 = widget::Button(width+50, 30*3, 100, 30, "left", #__button_toggle) 
    Button_3 = widget::Button(width+50, 30*4, 100, 30, "right", #__button_toggle) 
    Button_4 = widget::Button(width+50, 30*5, 100, 30, "toggle", #__button_toggle) 
    Bind(#PB_All, @events_widgets())
    
    If GetFlag(*this) & #__button_multiline
      SetState(Button_1, 1)
    EndIf
    
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(30, 30, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    SetState(Splitter_3, width-40-horiz)
    SetState(Splitter_2, height-40-vert)
    SetState(Splitter_0, vert)
    SetState(Splitter_1, horiz)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----
; EnableXP