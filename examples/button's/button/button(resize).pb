XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define h = 80
  Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = Button(    30, 30, 200, h, "butt_left", #__button_left)
    *g2 = Button(30+210, 30, 200, h, "butt" + #LF$ + "center" + #LF$ + "multi", #__button_multiline)
    *g3 = Button(30+420, 30, 200, h, "right_butt", #__button_right)
    
    *g4 = Splitter(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = Splitter(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = Splitter(30,30,620,h, *g5,#Null)
    
    SetState(*g4, 200)
    SetState(*g5, 200*2)
    SetState(*g6, h)
   
    WaitClose( )
  EndIf
CompilerEndIf

; IncludePath "../../../"
; XIncludeFile "widgets.pbi"
; 
; CompilerIf #PB_Compiler_IsMainFile
;   EnableExplicit
;   Uselib(widget)
;   
;   Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
;   Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
;   
;   Define vert=100, horiz=100, width=400, height=400
;   
;   Procedure events_widgets()
;     Protected flag
;     
;     Select this()\event
;       Case #PB_EventType_LeftClick
;         Select this()\widget
;           Case *this
;             If Flag(*this, #__button_toggle)
;               SetState(Button_4, GetState(this()\widget))
;             EndIf
;             
;           Case Button_type 
;             If GetState(this()\widget)
;               Hide(*this, 1)
;               HideGadget(gadget, 0)
;               If Splitter_0
;                 SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
;               EndIf
;               SetText(Button_type, "widget")
;             Else
;               Hide(*this, 0)
;               HideGadget(gadget, 1)
;               If Splitter_0
;                 SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
;               EndIf
;               SetText(Button_type, "gadget")
;             EndIf
;             
;           Case Button_1 : flag = #__button_multiline
;           Case Button_2 : flag = #__button_left
;           Case Button_3 : flag = #__button_right
;           Case Button_4 : flag = #__button_toggle
;         EndSelect
;         
;         If flag
;           Flag(*this, flag, GetState(this()\widget))
;         EndIf
;         Post(#__event_repaint, #PB_All)
;     EndSelect
;     
;   EndProcedure
;   
;   If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+20, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
;     gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
;     HideGadget(gadget,1)
;    ; *this = widget::Button(100, 100, 250, 200, text, #__button_multiline) 
;    *this = widget::Editor(100, 100, 250, 200, #__text_wordwrap) : SetText(*this, text)
;    
;     Define y = 10
;     ; flag
;     Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
;     Button_0 = widget::Button(width+45, y+30*1, 100, 26, "default", #__button_toggle) 
;     Button_1 = widget::Button(width+45, y+30*2, 100, 26, "multiline", #__button_toggle) 
;     Button_2 = widget::Button(width+45, y+30*3, 100, 26, "left", #__button_toggle) 
;     Button_3 = widget::Button(width+45, y+30*4, 100, 26, "right", #__button_toggle) 
;     Button_4 = widget::Button(width+45, y+30*5, 100, 26, "toggle", #__button_toggle) 
;     Bind(#PB_All, @events_widgets())
;     
;     ; set button toggled state
;     SetState(Button_1, Flag(*this, #__button_multiline))
;     
;     Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
;     Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
;     Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
;     Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
;     SetState(Splitter_3, width-40-horiz)
;     SetState(Splitter_2, height-40-vert)
;     SetState(Splitter_0, vert)
;     SetState(Splitter_1, horiz)
;     
;     WaitClose( ) ;Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
;   EndIf
; CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP