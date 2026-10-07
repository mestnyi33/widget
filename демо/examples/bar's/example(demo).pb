XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure.s get_text(m.s = #LF$)
    Protected Text.s = "This is a long line." + m.s  + 
                       "Who should show." + 
                       m.s  + 
                       m.s  + 
                       m.s  + 
                       m.s  + 
                       "I have to write the text in the box or not." + 
                       m.s  + 
                       m.s  + 
                       m.s  + 
                       m.s  + 
                       "The string must be very long." + m.s  + 
                       "Otherwise it will not work." ; +  m.s;  + 
    
    ProcedureReturn Text
  EndProcedure
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If Open(0, 0, 0, 605 + 30, 140 + 200 + 140 + 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ; example scroll gadget bar
    TextGadget       ( -1,  10, 15, 250,  20, "ScrollBar Standard  (start = 50, page = 30/150)",#PB_Text_Center)
    ScrollBarGadget  (101,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (101,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       ( -1,  10,110, 250,  20, "ScrollBar Vertical  (start = 100, page = 50/300)",#PB_Text_Right)
    ScrollBarGadget  (201, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (201, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ; example scroll widget bar
    Widget::Text(300 + 10, 15, 250,  20, "ScrollBar Standard  (start = 50, page = 30/150)",#__FLAG_TextCenter)
    *w = Widget::Scroll  (300 + 10, 42, 250,  20, 30, 100, 30, 0)
    Widget::SetState    (*w,  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    *w = Widget::Scroll  (300 + 10, 42 + 30, 250,  15, 30, 100, 30, #__FLAG_Invert);|#__FLAG_NoButtons, 7)
    Widget::SetState    (*w,  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    
    *w = Widget::Scroll  (300 + 10, 42 + 30 + 20, 250,  10, 30, 150, 230, #__FLAG_Invert, 7)
    Widget::SetState    (*w,  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    Widget::Text(300 + 10,110, 250,  20, "ScrollBar Vertical  (start = 100, page = 50/300)",#__FLAG_TextRight)
    *w = Widget::Scroll  (300 + 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical|#__FLAG_Invert)
    Widget::SetState    (*w, 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    *w = Widget::Scroll  (300 + 270 + 30, 10,  25, 120 ,0, 300, 50, #__FLAG_Vertical, 7)
    Widget::SetState    (*w, 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    ; example_2 track gadget bar
    TextGadget    ( -1, 10,  140 + 10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(1010, 10,  140 + 40, 250, 20, 0, 10000)
    SetGadgetState(1010, 5000)
    TextGadget    ( -1, 10, 140 + 90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     TrackBarGadget(11, 10, 140 + 120, 250, 20, 0, 30, #PB_trackTicks)
    TrackBarGadget(1111, 10, 140 + 120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetGadgetState(1111, 60)
    TextGadget    ( -1,  60, 140 + 160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(1212, 270, 140 + 10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(1212, 8000)
    
    ; example_2 track widget bar
    Widget::Text(300 + 10,  140 + 10, 250, 20,"TrackBar Standard");, #__FLAG_TextCenter)
    *w = Widget::Track(300 + 10,  140 + 40, 250, 20, 0, 10000, 0)
    Widget::SetState(*w, 5000)
    *w = Widget::Track(300 + 10,  140 + 40 + 20, 250, 20, 0, 10000, #__FLAG_Invert)
    Widget::SetState(*w, 5000)
    Widget::Text(300 + 10, 140 + 90, 250, 20, "TrackBar Ticks", #__FLAG_TextCenter)
    ;     widget::Track(300 + 10, 140 + 120, 250, 20, 0, 30, #__bar_ticks)
    *w = Widget::Track(300 + 10, 140 + 120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    Widget::SetState(*w, 60)
    Widget::Text(300 + 60, 140 + 160, 200, 20, "TrackBar Vertical", #__FLAG_TextRight)
    *w = Widget::Track(300 + 270, 140 + 10, 25, 170, 0, 10000, #PB_TrackBar_Vertical|#__FLAG_Invert)
    ;widget::SetAttribute(*w, #__FLAG_Inverted, 0)
    Widget::SetState(*w, 8000)
    *w = Widget::Track(300 + 270 + 30, 140 + 10, 25, 170, 0, 10000, #__FLAG_Vertical)
    Widget::SetState(*w, 8000)
    
    
    ; example_3 progress gadget bar
    TextGadget       ( -1,  10, 140 + 200 + 10, 250,  20, "ProgressBar Standard  (start = 65, page = 30/100)",#PB_Text_Center)
    ProgressBarGadget  (2121,  10, 140 + 200 + 42, 250,  20, 30, 100)
    SetGadgetState   (2121,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       ( -1,  10,140 + 200 + 100, 250,  20, "ProgressBar Vertical  (start = 100, page = 50/300)",#PB_Text_Right)
    ProgressBarGadget  (2222, 270, 140 + 200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState   (2222, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ; example_3 progress widget bar
    Widget::Text(300 + 10, 140 + 200 + 10, 250,  20, "ProgressBar Standard  (start = 65, page = 30/100)",#__FLAG_TextCenter)
    *w = Widget::Progress  (300 + 10, 140 + 200 + 42, 250,  20, 30, 100, 0)
    Widget::SetState   (*w,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    *w = Widget::Progress  (300 + 10, 140 + 200 + 42 + 30, 250,  20, 30, 100, #__FLAG_Invert, 14)
    Widget::SetState   (*w,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    Widget::Text(300 + 10,140 + 200 + 100, 250,  20, "ProgressBar Vertical  (start = 100, page = 50/300)",#__FLAG_TextRight)
    *w = Widget::Progress  (300 + 270, 140 + 200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical|#__FLAG_Invert, 19)
    ;widget::SetAttribute(*w, #__FLAG_Inverted, 0)
    Widget::SetState   (*w, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    *w = Widget::Progress  (300 + 270 + 30, 140 + 200,  25, 120 ,0, 300, #__FLAG_Vertical)
    Widget::SetState   (*w, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    ;{ PB splitter Gadget
    Button_0 = StringGadget(#PB_Any, 0, 0, 0, 0, "") ; as they will be sized automatically
    
    
    ButtonGadget(1, 0, 0, 0, 0, "BTN1")
    ButtonGadget(2, 0, 0, 0, 0, "BTN2")
    SplitterGadget(3, 125, 10, 250, 70, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_FirstFixed)
    
    ButtonGadget(4, 0, 0, 0, 0, "BTN4")
    ButtonGadget(5, 0, 0, 0, 0, "BTN5")
    SplitterGadget(6, 125, 90, 250, 70, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical)
    
    ButtonGadget(7, 0, 0, 0, 0, "BTN7")
    ButtonGadget(8, 0, 0, 0, 0, "BTN8")
    SplitterGadget(9, 125, 90, 250, 70, 7, 8, #PB_Splitter_Separator | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
    
    SplitterGadget(10, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator )
    
    ; first splitter
    ButtonGadget(11, 0, 0, 0, 0, "BTN1")
    Button_1 = SplitterGadget(#PB_Any, 125, 10, 250, 70, 10, 9, #PB_Splitter_Separator ) 
    SetGadgetState(Button_1, 42)
    ;Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1")  ; as they will be sized automatically
    
    Button_2 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150) : CloseGadgetList(); No need to specify size or coordinates
    Button_3 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 0, 100)                     ; as they will be sized automatically
    Button_4 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 0, 100)                     ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5")                      ; as they will be sized automatically
    
    SetGadgetState(Button_0, 50)
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 20)
    ;     ;SetGadgetState(Splitter_1, 20)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 140 + 200 + 130, 285 + 15, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    ;     SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2 - 5)
    ;     SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2 - 5)
    
    SetGadgetState(Splitter_0, 26)
    SetGadgetState(Splitter_4, 225)
    SetGadgetState(Splitter_3, 55)
    SetGadgetState(Splitter_2, 15)
    
    If OpenGadgetList(Button_2)
      Button_4 = ScrollAreaGadget(#PB_Any, -1, -1, 50, 50, 100, 100, 1);, #__FLAG_nogadgets)
                                                                       ;       Define i
                                                                       ;       For i = 0 To 1000
      ButtonGadget(#PB_Any, 10, 10, 50, 30,"1")
      ;       Next
      CloseGadgetList()
      ButtonGadget(#PB_Any, 100, 10, 50, 30, "2")
      CloseGadgetList()
    EndIf
    
    ;}
    
    Button_0 = Widget::Spin(0, 0, 0, 0, 0, 20) ; No need to specify size or coordinates
    
    
    Button_1 = Widget::Panel(0, 0, 0, 0) 
    AddItem(Button_1, -1, "Panel_0") 
    Define *w2 = Panel (5, 5, 140, 166)
    AddItem(*w2, -1, "Под -  - Панель 1")
    SetState(Option(5, 10, 70, 20, "option_0"), 1)
    Option(5, 32, 100, 20, "option_1")
    SetState(CheckBox(5, 54, 100, 20, "checkbox_0", #PB_CheckBox_ThreeState), #PB_Checkbox_Inbetween)
    Button(75, 10, 60, 20, "button")
    HyperLink(75, 32, 60, 20, "HyperLink", $ffff0000)
    
    AddItem(*w2, -1, "Под -  - Панель 2")
    Button( 5, 5, 55, 22, "кнопка 5")
    Button( 5, 30, 55, 22, "кнопка 30")
    
    AddItem(*w2, -1, "Под -  - Панель 3")
    AddItem(*w2, -1, "Под -  - Панель 4")
    
    AddItem(*w2, 1, "Под -  - Панель  - 2 - ")
    Button( 15, 5, 55, 22, "кнопка 15")
    Button( 20, 30, 55, 22, "кнопка 20")
    CloseList()
    ;SetState(*w2, 2)
    
    AddItem(Button_1, -1, "Panel_1") 
    Widget::Container(20,10,200,100)
    Widget::Button(20, 5, 100, 30, Text)
    
    Define Panel = Widget::Panel(20,30,200,100)
    AddItem(Panel, -1, "Panel_0") 
    Widget::Button(10, 10, 100, 30, Text)
    AddItem(Panel, -1, "Panel_1") 
    Widget::Button(20, 20, 100, 30, Text)
    Widget::CloseList()
    Widget::CloseList()
    
    AddItem(Button_1, -1, "tab_2") 
    Define *Tab = Widget::Tab(0,0,0,0, #__FLAG_autosize|#__FLAG_Vertical); No need to specify size or coordinates
    Widget::AddItem(*Tab, -1, "Tab_0")
    Widget::AddItem(*Tab, -1, "Tab_1 (long)")
    Widget::AddItem(*Tab, -1, "Tab_2")
    Widget::AddItem(*Tab, -1, "Tab_3 (long)")
    Widget::AddItem(*Tab, -1, "Tab_4")
    Widget::AddItem(*Tab, -1, "Tab_5 (long)")
    Widget::AddItem(*Tab, -1, "Tab_6")
    Widget::AddItem(*Tab, -1, "Tab_7 (long)")
    Widget::AddItem(*Tab, -1, "Tab_8")
    SetState(*Tab, 7)
    
    
    AddItem(Button_1, -1, "editor_3") 
    Define *Editor = Widget::Editor(0, 0, 0, 0, #__FLAG_autosize) 
    SetText(*Editor, get_text(#LF$))
    
    AddItem(Button_1, -1, "tree_4") 
    Define *Tree = Widget::Tree(0, 0, 0, 0, #__FLAG_autosize) 
    Widget::AddItem(*Tree, -1, "index_0_level_0")
    Widget::AddItem(*Tree, -1, "index_1_sublevel_1", -1, 1)
    Widget::AddItem(*Tree, -1, "index_2_sublevel_2", -1, 2)
    Widget::AddItem(*Tree, -1, "index_3_level_0")
    Widget::AddItem(*Tree, -1, "index_4_sublevel_1", -1, 1)
    Widget::AddItem(*Tree, -1, "index_5_sublevel_2", -1, 2)
    Widget::AddItem(*Tree, -1, "Form_0")
    Widget::AddItem(*Tree, -1, "Form_0")
    Widget::AddItem(*Tree, -1, "Form_0")
    Widget::AddItem(*Tree, -1, "Form_0")
    Widget::AddItem(*Tree, -1, "Form_0")
    ;SetItemColor(*Tree,  #PB_All, #PB_Gadget_LineColor,  $FF00f000)
    
    AddItem(Button_1, -1, "window_5") 
    Define *window = Widget::Window(0, 0, 330, 0, "form", #__FLAG_autosize|#PB_Window_TitleBar|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget, Button_1) 
    Widget::Container(10,10,100,100)
    Widget::Container(10,10,100,100)
    Widget::Container(10,10,100,100)
    Widget::CloseList()
    Widget::CloseList()
    Widget::CloseList()
    Widget::CloseList() ; *window
    
    CloseList()
    SetState(Button_1, 4)
    
    ;     
    ;     ;     Button_1 = widget::Editor(0, 0, 0, 0) : SetText(Button_1, text)
    ;     ;     Button_1 = widget::Button(0, 0, 0, 0, text) ; No need to specify size or coordinates
    ;     ;Button_1 = widget::Text(0, 0, 0, 0, text, #__FLAG_Textborder) ; No need to specify size or coordinates
    ;     ; ;     Button_1 = widget::MDI(0, 0, 0, 0) ; No need to specify size or coordinates
    ;     ; ;     widget::AddItem(Button_1, -1, "Form_0")
    ;     ; ;     widget::AddItem(Button_1, -1, "Form_1")
    ;     ; ;     widget::AddItem(Button_1, -1, "Form_2")
    ;     
    ;     ;     Define w_1,w_2,w_3,w_4,w_5,w_6,w_7,w_8,w_9,w_10,w_11,w_12,w_13,w_14,w_15
    ;     ;     w_1 = widget::Button(0, 0, 0, 0, "BTN1")
    ;     ;     w_2 = widget::Button(0, 0, 0, 0, "BTN2")
    ;     ;     w_3 = widget::Splitter(125, 170, 250, 40, w_1, w_2, #PB_Splitter_Separator | #PB_Splitter_vertical | #PB_Splitter_FirstFixed)
    ;     ;     
    ;     ;     w_4 = widget::Button(0, 0, 0, 0, "BTN4")
    ;     ;     w_5 = widget::Button(0, 0, 0, 0, "BTN5")
    ;     ;     w_6 = widget::Splitter(125, 170, 250, 40, w_4, w_5, #PB_Splitter_Separator | #PB_Splitter_vertical)
    ;     ;     
    ;     ;     w_7 = widget::Button(0, 0, 0, 0, "BTN7")
    ;     ;     w_8 = widget::Button(0, 0, 0, 0, "BTN8")
    ;     ;     w_9 = widget::Splitter(125, 170 + 80, 250, 40, w_7, w_8, #PB_Splitter_Separator | #PB_Splitter_vertical | #PB_Splitter_SecondFixed)
    ;     ;     
    ;     ;     w_10 = widget::Splitter(125, 170, 250, 70, w_3, w_6, #PB_Splitter_Separator)
    ;     ;     
    ;     ;     w_11 = widget::Button(0, 0, 0, 0, "BTN11")
    ;     ;     Button_1 = widget::Splitter(125, 170, 250, 70, w_10, w_9, #PB_Splitter_Separator)
    ;     ;     widget::SetState(Button_1, 42)
    ;     ;     
    ;     ;     ; ;     ;     Button_10 = widget::Scroll(0, 0, 0, 0, 0, 100, 20) ; No need to specify size or coordinates
    ;     ;     ; ;     ;     Button_1 = widget::Splitter(0, 0, 0, 0, Button_10, Button_1, #PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    
    Button_2 = Widget::ScrollArea(0, 0, 0, 0, 150, 150, 1) : Widget::CloseList()        ; as they will be sized automatically
    Button_3 = Widget::Progress(0, 0, 0, 0, 0, 100, 30)                                 ; as they will be sized automatically
    
    Button_4 = Widget::Spin(0, 0, 0, 0, 50,100, #__FLAG_Vertical) ; as they will be sized automatically
    Button_5 = Widget::Tab(0, 0, 0, 0)                  ; No need to specify size or coordinates
    Widget::AddItem(Button_5, -1, "Tab_0")
    Widget::AddItem(Button_5, -1, "Tab_1 (long)")
    Widget::AddItem(Button_5, -1, "Tab_2")
    
    Widget::SetState(Button_0, 50)
    
    Splitter_0 = Widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed);|#PB_Splitter_Separator)
    Splitter_1 = Widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed);|#PB_Splitter_Separator)
    Widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 20)
    Widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 20)
    ;widget::SetState(Splitter_1, 410/2 - 20)
    Splitter_2 = Widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5);, #PB_Splitter_Separator)
    Splitter_3 = Widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2);, #PB_Splitter_Separator)
    Splitter_4 = Widget::Splitter(300 + 10 + 15, 140 + 200 + 130, 285 + 15, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical);|#PB_Splitter_Separator)
    
    ; widget::SetState(Button_2, 5)
    Widget::SetState(Splitter_0, 26)
    Widget::SetState(Splitter_4, 220)
    Widget::SetState(Splitter_3, 55)
    Widget::SetState(Splitter_2, 15)
    
    If Button_2 And Widget::OpenList(Button_2)
      Button_4 = Widget::ScrollArea( -1, -1, 50, 50, 100, 100, 1);, #__FLAG_nogadgets)
                                                                 ;       Define i
                                                                 ;       For i = 0 To 1000
      Widget::Progress(10, 10, 50, 30, 1, 100, 30)
      ;       Next
      Widget::CloseList()
      Widget::Progress(100, 10, 50, 30, 2, 100, 30)
      Widget::CloseList()
    EndIf
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 307
; FirstLine = 283
; Folding = --
; EnableXP
; DPIAware