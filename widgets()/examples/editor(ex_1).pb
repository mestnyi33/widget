; если в первом гаджете и во втором строки одинаковы то не рисует второй едитор
; поэтому полученный текст из первого не рисуется во втором
; теперь исправилено 

IncludePath "../"
;XIncludeFile "editor.pb"
;XIncludeFile "editor.pbi"
XIncludeFile "string().pbi"
;XIncludeFile "editor().pbi" ; ok
;;XIncludeFile "widgets().pbi"

UseModule editor
UseModule constants
UseModule structures

Global *w._s_widget, *w1

#MaxLines = 10

Define LastLine.I

If OpenWindow(0, 0, 0, 316, 350, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(-1, 8,8, 146, 20, "add")
  TextGadget(-1, 162,8, 146, 20, "set&get")
  
  Gadget(0, 8, 30, 186, 111) : *w = GetGadgetData(0)
  For a = 0 To 5
    AddItem(*w, a, "Line "+Str(a))
  Next
  
  ;redraw(*w)
  
  Gadget(1, 8, 150, 186, 111, #__flag_gridlines) : *w1 = GetGadgetData(1)
  ;   Define text.s = "Line 0" +#LF$+ 
  ;                   "Line 1" +#LF$+ 
  ;                   "Line 2" +#LF$+ 
  ;                   "Line 3" +#LF$+ 
  ;                   "Line 4" +#LF$+ "Line 5"  +#LF$ ; GetText(*w) 
  
   text.s = GetText(*w)
   SetText(*w1, text)
  ;SetText(*w1, "The" + #LF$ + "quick" + #LF$ + "brown" + #LF$ + "fox" + #LF$ + "jumps" + #LF$ + "over" + #LF$ + "the" + #LF$ + "lazy" + #LF$ + "dog.")
   
   SetActive(*w1)
   SetState(*w1, -1)
  
  AddWindowTimer(0, 0, 500)

  Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Timer
      If LastLine < #MaxLines
        LastLine + 1
        
        AddItem(*w1, LastLine, "Line "+Str(LastLine))
        SetItemState(*w1, LastLine, -1)
        
        redraw(*w1)
      Else
        RemoveWindowTimer(0, 0)
      EndIf
  EndSelect
ForEver
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