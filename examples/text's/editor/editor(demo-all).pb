IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global *S_0._s_widget
  Global *S_1._s_widget
  Global *S_2._s_widget
  Global *S_3._s_widget
  Global *S_4._s_widget
  Global *S_5._s_widget
  Global *S_6._s_widget
  Global *S_7._s_widget
  Global *S_8._s_widget
  Global *S_9._s_widget
  
  Global *S_21._s_widget
  Global *S_22._s_widget
  
  Global *S_23._s_widget
  Global *S_213._s_widget
  Global *S_25._s_widget
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Events()
    Protected String.s
    
    Select EventType()
      Case #__Event_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #__Event_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #__Event_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #__Event_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget"
      EndIf
    Else
      If EventType() = #__Event_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget"
      EndIf
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, XAlign.f)
    EndImport
  CompilerEndIf
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define height=60, Text1.s = "Borderless StringGadget" + #LF$ + " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  
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
  Define Text.s = get_text(#LF$)
  ;     
  Procedure resize_splitter()
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, (height+5)*7+20+90+160, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open( 0);, 0, 0, 615, (height+5)*7+20+90+160)
    ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    ;       height = 20
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
    ;       height = 18
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    ;       height = 20
    ;       LoadFont(0, "monospace", 9)
    ;       SetGadgetFont(-1,FontID(0))
    ;     CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Read-only StringGadget...", #PB_String_ReadOnly)
    StringGadget(1, 8,  (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric|Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Center)
    StringGadget(2, 8,  (height+5)*2+10, 290, height, "Right-text StringGadget", Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Right)
    StringGadget(3, 8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, Text1, #PB_String_BorderLess)
    StringGadget(6, 8, (height+5)*6+10, 140, height, "")
    StringGadget(7, 150+8, (height+5)*6+10, 140, height, "Password", #PB_String_Password)
    ;     StringGadget(8, 8, (height+5)*8+10, 290, 90, Text)
    
    ;     Define i
    ;     For i=0 To 7
    ;       BindGadgetEvent(i, @Events())
    ;     Next
    
    SetTextAlignment()
    SetGadgetText(7, "GaT")
    Debug "Get gadget text "+GetGadgetText(7)
    
    *S_0 = String( 305+8,  10, 290, height, "Read-only StringGadget...", #PB_String_ReadOnly|#__flag_Texttop)
    *S_1 = String( 305+8,  (height+5)*1+10, 290, height, "123-only-4567", #PB_String_Numeric|#__flag_Textcenter)
    *S_2 = String( 305+8,  (height+5)*2+10, 290, height, "Right-text StringGadget", #__flag_Textright|#__flag_Textbottom)
    *S_3 = String( 305+8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    *S_4 = String( 305+8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    *S_5 = String( 305+8, (height+5)*5+10, 290, height, Text1, #PB_String_BorderLess)
    *S_6 = String( 305+8, (height+5)*6+10, 140, height, "")
    *S_7 = String( 305+150+8, (height+5)*6+10, 140, height, "Password", #PB_String_Password )
    ;     ; *S_8 = String( 305+8, (height+5)*8+10, 290, 90+150, Text, #__flag_gridlines|#__flag_Textnumeric|#__flag_Textmultiline)
    ;     *S_8 = String( 305+8, (height+5)*8+10, 290, 90+30, Text, #__flag_gridlines|#__flag_Textnumeric|#__flag_Textmultiline)
    ;     *S_9 = String( 305+8, (height+5)*9+10+60, 290, 90+30, Text, #__flag_gridlines|#__flag_Textnumeric|#__flag_Textwordwrap)
    
    SetText(*S_7, "GaT")
    Debug "Get widget text "+GetText(*S_7)
    
    
    EditorGadget(21, 0,0,0,0)
    EditorGadget(22, 0,0,0,0, #PB_Editor_WordWrap)
    
    *S_21 = Editor( 0,0,0,0);, #__flag_gridlines)
    *S_22 = Editor( 0,0,0,0, #PB_Editor_WordWrap)  ;#__flag_gridlines|
    
    SetGadgetText(21, get_text(#LF$))
    SetGadgetText(22, get_text(""))
    
    SetText(*S_21, get_text(#LF$))
    SetText(*S_22, get_text(""))
    
    For a = 0 To 2
      AddGadgetItem((21), a, "Line "+Str(a))
      AddItem(*S_21, a, "Line "+Str(a))
    Next
    AddGadgetItem((21), 7+a, "_")
    AddItem(*S_21, 7+a, "_")
    For a = 4 To 6
      AddGadgetItem((21), a, "Line "+Str(a))
      AddItem(*S_21, a, "Line "+Str(a))
    Next
    
    *S_23 = Splitter( 0,0,0,0,*S_22,*S_21 )
    *S_213 = Splitter( 0,0,0,0, 22, 21 )
    
    *S_25 = Splitter( 8,(height+5)*7+10,600-6, 250, *S_213,*S_23, #PB_Splitter_Vertical )
    ;SetGadgetState(25, 30)
    ;SetGadgetState(25, 97)
    ;SetGadgetState(25, 82)
    ;SetGadgetState(25, 99)
    ;SetGadgetState(25, 126)
    ;BindGadgetEvent(25, @resize_splitter())
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #__Event_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; CompilerIf #PB_Compiler_IsMainFile 
;   UseWidgets( )
;   
;   Global *S_0._s_widget
;   Global *S_1._s_widget
;   Global *S_2._s_widget
;   Global *S_3._s_widget
;   Global *S_4._s_widget
;   Global *S_5._s_widget
;   Global *S_6._s_widget
;   Global *S_7._s_widget
;   Global *S_8._s_widget
;   Global *S_9._s_widget
;   
;   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;     LoadFont(0, "Arial", 16)
;   CompilerElse
;     LoadFont(0, "Arial", 11)
;   CompilerEndIf 
;   SetGadgetFont( -1, FontID(0))
;   
;   ;   *this._const_
;   ;   
;   ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
;   
;   UsePNGImageDecoder()
;   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
;     End
;   EndIf
;   
;   Procedure _Events()
;     Protected String.s
;     
;     Select EventType()
;       Case #__Event_Focus
;         String.s = "focus "+EventGadget()+" "+EventType()
;       Case #__Event_LostFocus
;         String.s = "lostfocus "+EventGadget()+" "+EventType()
;       Case #__Event_Change
;         String.s = "change "+EventGadget()+" "+EventType()
;     EndSelect
;     
;     If IsGadget(EventGadget())
;       If EventType() = #__Event_Focus
;         Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
;       Else
;         Debug String.s +" - gadget"
;       EndIf
;     Else
;       If EventType() = #__Event_Focus
;         Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
;       Else
;         Debug String.s +" - widget"
;       EndIf
;     EndIf
;     
;   EndProcedure
;   
;   ; Alignment text
;   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
;     ImportC ""
;       gtk_entry_set_alignment(Entry.i, XAlign.f)
;     EndImport
;   CompilerEndIf
;   
;   Procedure SetTextAlignment()
;     ; Alignment text
;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;       CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
;       CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
;       
;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
;       If OSVersion() > #PB_OS_Windows_XP
;         SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
;         SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
;       Else
;         SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
;         SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
;       EndIf
;       
;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
;       ;       ImportC ""
;       ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
;       ;       EndImport
;       
;       gtk_entry_set_alignment(GadgetID(1), 0.5)
;       gtk_entry_set_alignment(GadgetID(2), 1)
;     CompilerEndIf
;   EndProcedure
;   
;   Define height=60, Text1.s = "Borderless StringGadget" + #LF$ + " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
;   
;   
;   Procedure.s get_text(m.s=#LF$)
;     Protected Text.s = "This is a long line." + m.s +
;                        "Who should show." + 
;                        m.s +
;                        m.s +
;                        m.s +
;                        m.s +
;                        "I have to write the text in the box or not." + 
;                        m.s +
;                        m.s +
;                        m.s +
;                        m.s +
;                        "The string must be very long." + m.s +
;                        "Otherwise it will not work." ;+ m.s; +
;     
;     ProcedureReturn Text
;   EndProcedure
;   Define Text.s = get_text(#LF$)
;   ;     
;   Procedure resize_splitter()
;     SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
;   EndProcedure
;   
;   If Open(OpenWindow(#PB_Any, 0, 0, 615, 270, "Editor on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
;     EditorGadget(21, 0,0,0,0)
;     EditorGadget(22, 0,0,0,0, #PB_Editor_WordWrap)
;     
;     *w_211 = Editor(0,0,0,0)
;     *w_212 = Editor(0,0,0,0, #__editor_wordwrap)
;     SetFrame( *w_211, 2)
;     SetFrame( *w_212, 2)
;     
;     SetGadgetText(21, get_text(#LF$))
;     SetGadgetText(22, get_text(""))
;     
;     SetText(*w_211, get_text(#LF$))
;     SetText(*w_212, get_text(""))
;     
;     For a = 0 To 2
;       AddGadgetItem((21), a, "Line "+Str(a))
;       AddItem(*w_211, a, "Line "+Str(a))
;     Next
;     
;     AddGadgetItem((21), 7+a, "_")
;     AddItem(*w_211, 7+a, "_")
;     
;     For a = 4 To 6
;       AddGadgetItem((21), a, "Line "+Str(a))
;       AddItem(*w_211, a, "Line "+Str(a))
;     Next
;     
;     *s_1 = Splitter(0,0,0,0, *w_211,21 )
;     *s_2 = Splitter(0,0,0,0, *w_212,22 )
;     
;     *s_3 = Splitter(8,10,600, 250, *S_2,*S_1, #PB_Splitter_Vertical )
;     ;SetState(*s_3, 30)
;     ;SetState(*s_3, 97)
;     ;SetState(*s_3, 82)
;     ;SetState(*s_3, 99)
;     ;SetState(*s_3, 126)
;     Bind(*s_3, @resize_splitter())
;     
;     ;     BindEvent(#PB_Event_Widget, @Events())
;     ;     PostEvent(#PB_Event_Gadget, 0,10, #__Event_Resize)
;     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
;   EndIf
; CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 160
; FirstLine = 156
; Folding = ---
; EnableXP