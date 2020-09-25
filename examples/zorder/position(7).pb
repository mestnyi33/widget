IncludePath "../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *s1, *s2, *p1,*b1, *b2,*b3
  
  If Open(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *p1 = Panel (5, 30, 340, 166)
    AddItem(*p1, -1, "Под-Панель 1")
    
    AddItem(*p1, -1, "Под-Панель 3") 
    *b1 = Button(0, 0, 0, 0,"кнопка_1") : SetClass(widget(), GetText(widget()))  
    *b2 = Button(0, 0, 0, 0,"кнопка_2") : SetClass(widget(), GetText(widget()))
    *s1 = Splitter(5,5, 300, 152, *b1, *b2) : SetClass(widget(), "split_1")
    *b3 = Button(0, 0, 0, 0,"кнопка_3") : SetClass(widget(), GetText(widget()))
    *s2 = Splitter(10, 5, 300, 152, *s1,*b3,  #PB_Splitter_Vertical) : SetClass(widget(), "split_2") 
    ; Debug widget()\class
    ;    
;     - 
;     - none Panel кнопка_5
;     - кнопка_1 split_2 кнопка_3
;     - split_2 кнопка_3 split_1
;     - кнопка_3 split_1 none
;     - Panel кнопка_5 none
;     - none кнопка_2 кнопка_1
;     - кнопка_2 кнопка_1 split_2
    
;     - 
;     - none Panel кнопка_5
;     - кнопка_1 split_2 split_1
;     - split_2 split_1 кнопка_3
;     - none кнопка_2 кнопка_1
;     - кнопка_2 кнопка_1 split_2
;     - split_1 кнопка_3 none
;     - Panel кнопка_5 none
    
    
;     - 
;     - none Panel кнопка_5
;     - кнопка_3 split_2 none
;     - split_1 кнопка_3 split_2
;     - кнопка_2 split_1 кнопка_3
;     - кнопка_1 кнопка_2 split_1
;     - none кнопка_1 кнопка_2
;     - Panel кнопка_5 none
 
    CloseList()
    Button(5, 5, 55, 22,"кнопка_5") : SetClass(widget(), GetText(widget()))
    
    SetState(*p1,1)
    
    Debug " - "
    ForEach widget( ) 
      If widget( )\before And widget( )\after
        Debug " - "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\after
        Debug " - none "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\before
        Debug " - "+ widget( )\before\class +" "+ widget( )\class +" none"
      Else
        Debug " - "+ widget( )\class 
      EndIf
    Next
    Debug ""
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP