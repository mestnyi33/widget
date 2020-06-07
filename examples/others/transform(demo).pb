IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Define vert=100, horiz=100, width=400, height=400
  
  Procedure events_widgets()
    Static text.s
    
    Select *event\widget
      Case Button_0
        Select *event\type
          Case #PB_EventType_LeftButtonDown
            text.s = "button"
        EndSelect
      Default
        
        Select *event\type
          Case #PB_EventType_LeftButtonDown
            
            
          Case #PB_EventType_Focus
            Debug "focus"
            
          Case #PB_EventType_LostFocus
            Debug "lostfocus"
            
          Case #PB_EventType_LeftClick
            
            ; Post(#__event_repaint, #PB_All)
        EndSelect
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    ;Root()\mode\transform = 1
    ;a_add(Root())
    
    ;*this = widget::Button(100, 100, 250, 200, text, #__button_multiline|#__flag_anchorsgadget) 
    widget::Button(10, 10, 150, 100, text, #__button_multiline|#__flag_anchorsgadget) 
    *this = widget::Window(100, 100, 250, 200, text,#__window_nogadgets|#__flag_anchorsgadget) 
    ;*this = widget::ScrollArea(100, 100, 250, 200, 300,300,1,#__window_nogadgets|#__flag_anchorsgadget) 
    ;*this = widget::Container(100, 100, 250, 200, #__flag_anchorsgadget) 
    OpenList(*this)
    widget::Button(10, 10, 150, 100, text, #__button_multiline) 
    widget::Container(100, 100, 150, 100) 
    ;widget::Panel(100, 100, 150, 100,#__flag_anchorsgadget) : AddItem(widget(), -1, "Panel")
    ;widget::ScrollArea(100, 100, 250, 200, 300,300,1, #__flag_anchorsgadget) 
    widget::Button(0, 0, 100, 50, "button", #__button_multiline) 
    CloseList()
    CloseList()
    
         Define y = 10
    ;     ; flag
    ;     Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
         Button_0 = widget::Button(width+45, y+30*1, 100, 26, "default");, #__button_toggle) 
    ;     Button_1 = widget::Button(width+45, y+30*2, 100, 26, "multiline", #__button_toggle) 
    ;     Button_2 = widget::Button(width+45, y+30*3, 100, 26, "left", #__button_toggle) 
    ;     Button_3 = widget::Button(width+45, y+30*4, 100, 26, "right", #__button_toggle) 
    ;     Button_4 = widget::Button(width+45, y+30*5, 100, 26, "toggle", #__button_toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    ;SetState(Button_1, Flag(*this, #__button_multiline))
    
    ;     Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    ;     Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    ;     Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    ;     Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    ;     SetState(Splitter_3, width-40-horiz)
    ;     SetState(Splitter_2, height-40-vert)
    ;     SetState(Splitter_0, vert)
    ;     SetState(Splitter_1, horiz)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP