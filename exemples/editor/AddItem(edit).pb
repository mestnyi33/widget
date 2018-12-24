CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_procedures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"

LN=15000; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 680)
  editor::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection) : *w.Widget_S=GetGadgetData(1)
  ;; Debug Procedures::IsHideGadget(1)
  
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    editor::AddItem (*w, -1, "Item "+Str(a), 0,1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(*w)
  
;   If Not *w\Repaint : *w\Repaint = 1
;     PostEvent(#PB_Event_Gadget, 
;               *w\Canvas\Window, 
;               *w\Canvas\Gadget,
;               #PB_EventType_Repaint)
;     ; While WindowEvent() : Wend
;   EndIf
   Text::Redraw(*w)
  ; Editor::SetFont(*w, FontID(LoadFont(#PB_Any, "Impact", 18 , #PB_Font_HighQuality)))
    
  ; HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP