
IncludePath "../"
XIncludeFile "editor().pb"
;XIncludeFile "widgets().pbi"

Global *w, *w1
UseModule editor

If OpenWindow(0, 0, 0, 316, 350, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget(-1, 8,8, 146, 20, "add")
    TextGadget(-1, 162,8, 146, 20, "set&get")
  
    Gadget(0, 8, 30, 146, 111) : *w = GetGadgetData(0)
;     For a = 0 To 5
;       AddItem(*w, a, "Line "+Str(a))
;     Next
;     ;redraw(*w)
    
    Gadget(1, 8, 150, 146, 111) : *w1 = GetGadgetData(1)
;     SetText(*w1, GetText(*w))
;     redraw(*w1)
    
    ;SetWindowTitle(0, GetItemText(*w, 2)+ " - get tex item 2")
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
  ; 
; IncludePath "../"
; XIncludeFile "editor().pb"
; ;XIncludeFile "widgets().pbi"
; 
; Global *w, *w1
; UseModule editor
; 
; If OpenWindow(0, 0, 0, 316, 150, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     TextGadget(-1, 8,8, 146, 20, "add")
;     TextGadget(-1, 162,8, 146, 20, "set&get")
;   
;     Gadget(0, 8, 30, 146, 111) : *w = GetGadgetData(0)
; ;     For a = 0 To 5
; ;       AddItem(*w, a, "Line "+Str(a))
; ;     Next
; ;     ;redraw(*w)
;     
;     Gadget(1, 162, 30, 146, 111) : *w1 = GetGadgetData(1)
; ;     SetText(*w1, GetText(*w))
; ;     redraw(*w1)
;     
;     ;SetWindowTitle(0, GetItemText(*w, 2)+ " - get tex item 2")
;     
;     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
;   EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP