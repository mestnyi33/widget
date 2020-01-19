;IncludePath "../"
XIncludeFile "string().pbi"

CompilerIf Not Defined(editor, #PB_Module)
DeclareModule editor
  UseModule constants
  
  Structure _s_widget Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module editor
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected *this._s_widget = editor::create(#PB_GadgetType_Editor, X, Y, Width, Height, "", Flag)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._s_widget
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_Editor
    
    If Flag&#__string_multiline
      *this\text\multiline = 1
    ElseIf Flag&#__text_wordwrap
      *this\text\multiline =- 1
    Else
      *this\text\multiline = 0
    EndIf
  
    If *this\text\multiline
      *this\row\margin\hide = 0;Bool(Not Flag&#__string_numeric)
      *this\row\margin\color\front = $C8000000 ; \color\back[0] 
      *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
    Else
      *this\row\margin\hide = 1
      *this\text\numeric = Bool(Flag&#__string_numeric)
    EndIf
    
    ;*this\text\align\left = Bool(Not Flag&#__string_center)
    
    *this\text\align\vertical = Bool(Not *this\text\align\bottom And Not *this\text\align\top)
    *this\text\x = 2
    *this\text\y = 2
    
    If Text.s
      Editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule
CompilerEndIf


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule editor
  UseModule constants
  
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
  
  Procedure resize_splitter()
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 616, 316, "editor on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    EditorGadget(21, 0,0,0,0)
    EditorGadget(22, 0,0,0,0, #PB_Editor_WordWrap)
   
    editor::Gadget(211, 0,0,0,0, #__flag_gridlines)
    editor::Gadget(212, 0,0,0,0, #__flag_gridlines|#__editor_wordwrap)
    
    SetGadgetText(21, get_text(#LF$))
    SetGadgetText(22, get_text(""))
    
    editor::SetText(GetGadgetData(211), get_text(#LF$))
    editor::SetText(GetGadgetData(212), get_text(""))
    
    SplitterGadget(23, 0,0,0,0, 21,211 )
    SplitterGadget(213, 0,0,0,0, 22,212 )
    
    SplitterGadget(25, 8,8,600, 300, 213,23, #PB_Splitter_Vertical )
    ;SetGadgetState(25, 30)
    ;SetGadgetState(25, 97)
    ;SetGadgetState(25, 82)
    ;SetGadgetState(25, 99)
    SetGadgetState(25, 120)
    BindGadgetEvent(25, @resize_splitter())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --9
; EnableXP