;IncludePath "../"
XIncludeFile "editor().pb"
;XIncludeFile "widgets().pbi"

DeclareModule String
  UseModule constants
  
  Structure _struct_ Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module String
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._struct_
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_String
    *this\text\multiline = Bool(Flag&#__string_multiline)
    *this\text\Numeric = Bool(Flag&#__string_numeric)
    *this\row\margin\level = 0
    ;*this\text\align\Vertical = 1
    
    If Text.s
      Editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  UseModule constants
  
  Global *S_0._struct_
  Global *S_1._struct_
  Global *S_2._struct_
  Global *S_3._struct_
  Global *S_4._struct_
  Global *S_5._struct_
  Global *S_6._struct_
  Global *S_7._struct_
  Global *S_8._struct_
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_struct_; _struct_
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget"
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
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
  
  Define height=60, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  If OpenWindow(0, 0, 0, 615, (height+5)*8+20+90, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
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
    StringGadget(1, 8,  (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  (height+5)*2+10, 290, height, "Right-text StringGadget")
    StringGadget(3, 8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, (height+5)*6+10, 290, height, "Password", #PB_String_Password)
    StringGadget(7, 8, (height+5)*7+10, 290, height, "")
    StringGadget(8, 8, (height+5)*8+10, 290, 90, Text)
    
    Define i
    For i=0 To 7
      BindGadgetEvent(i, @Events())
    Next
    
    SetTextAlignment()
    SetGadgetText(6, "GaT")
    Debug "Get gadget text "+GetGadgetText(6)
    
    *S_0 = GetGadgetData(Gadget(10, 305+8,  10, 290, height, "Read-only StringGadget...", #__string_readonly))
    *S_1 = GetGadgetData(Gadget(11, 305+8,  (height+5)*1+10, 290, height, "123-only-4567", #__string_numeric|#__string_center))
    *S_2 = GetGadgetData(Gadget(12, 305+8,  (height+5)*2+10, 290, height, "Right-text StringGadget", #__string_right))
    *S_3 = GetGadgetData(Gadget(13, 305+8,  (height+5)*3+10, 290, height, "LOWERCASE...", #__string_lowercase))
    *S_4 = GetGadgetData(Gadget(14, 305+8, (height+5)*4+10, 290, height, "uppercase...", #__string_uppercase))
    *S_5 = GetGadgetData(Gadget(15, 305+8, (height+5)*5+10, 290, height, "Borderless StringGadget", #__flag_borderless))
    *S_6 = GetGadgetData(Gadget(16, 305+8, (height+5)*6+10, 290, height, "Password", #__string_password))
    *S_7 = GetGadgetData(Gadget(17, 305+8, (height+5)*7+10, 290, height, ""))
    *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90, Text))
    
    SetText(*S_6, "GaT")
    Debug "Get widget text "+GetText(*S_6)
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -4z-
; EnableXP