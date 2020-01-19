IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
XIncludeFile "string().pbi"


DeclareModule button
  UseModule constants
  
  Structure _s_widget Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  Macro SetFont(_this_, _font_id_) : Editor::SetFont(_this_, _font_id_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module button
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected *this._s_widget = editor::create(#PB_GadgetType_Button, X, Y, Width, Height, "", Flag)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._s_widget
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag|#__text_readonly)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_Button
    *this\color = colors::*this\blue
        
    ;*this\text\multiline =- 1
    *this\text\x = 0
    *this\text\y = 0
    *this\text\editable = 0
    *this\text\padding = 5
    *this\row\margin\hide = 1
    
    *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
    *this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
    
    If Text.s
      SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  UseModule Button
  UseModule constants
  
  If Not LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*4)
    End
  EndIf
  
  If OpenWindow(0, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    gadget(-1,10, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline)
    gadget(-1,30, 100, 80, 100, "Standard Button Button (Vertical)", #__flag_vertical|#__button_multiline)
    gadget(-1,120, 10, 100, 80, "Standard Button Button (horizontal)", #__button_multiline|#__text_invert)
    gadget(-1,120, 100, 80, 100, "Standard Button Button (Vertical)", #__flag_vertical|#__button_multiline|#__text_invert)
    
    SetFont(GetGadgetData(gadget(-1,10,  210, 210, 55, "change button font", 0)), FontID(0))
    
    gadget(-1,230, 10, 200, 20, "Standard Button", 0)
    gadget(-1,230, 40, 200, 20, "Left Button", #__text_left)
    gadget(-1,230, 70, 200, 20, "Right Button", #__text_right)
    gadget(-1,230,100, 200, 60, "multiline Button  (longer text gets automatically wrapped)", #__text_wordwrap|#__button_Default)
    gadget(-1,230,170, 200, 60, "multiline Button  (longer text gets automatically multiline)", #__button_multiline)
    gadget(-1,230,170+70, 200, 25, "Toggle Button", #__button_toggle)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP