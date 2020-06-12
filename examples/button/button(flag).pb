IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Define vert=100, horiz=100, width=400, height=400
  
  Procedure events_widgets()
    Protected flag
    
    Select *event\type
      Case #PB_EventType_LeftClick
        Select *event\widget
          Case Button_type 
            If GetState(*event\widget)
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
            
          Case *this
            If Flag(*this, #__button_toggle)
              SetState(Button_4, GetState(*event\widget))
            EndIf
            
          Case Button_0 : flag = #__button_default
          Case Button_1 : flag = #__button_multiline
          Case Button_2 : flag = #__button_left
          Case Button_3 : flag = #__button_right
          Case Button_4 : flag = #__button_toggle
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(*event\widget))
        EndIf
        Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    *this = widget::Button(100, 100, 250, 200, text, #__button_multiline|#__flag_anchorsgadget) 
    
    Define y = 10
    ; flag
    Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
    Button_0 = widget::Button(width+45, y+30*1, 100, 26, "default", #__button_toggle) 
    Button_1 = widget::Button(width+45, y+30*2, 100, 26, "multiline", #__button_toggle) 
    Button_2 = widget::Button(width+45, y+30*3, 100, 26, "left", #__button_toggle) 
    Button_3 = widget::Button(width+45, y+30*4, 100, 26, "right", #__button_toggle) 
    Button_4 = widget::Button(width+45, y+30*5, 100, 26, "toggle", #__button_toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(Button_1, Flag(*this, #__button_multiline))
    Hide(Button_type, 1)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = v-
; EnableXP