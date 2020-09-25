IncludePath "../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *s1, *s2, *p1, *b0,*b1,*b2,*b3, *b4
  
  If Open(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *p1 = Panel (5, 30, 340, 166)
    AddItem(*p1, -1, "Под-Панель 1")
    
    AddItem(*p1, -1, "Под-Панель 3") 
    *b0 = Button(0, 0, 0, 0,"кнопка_0") : SetClass(widget(), GetText(widget()))  
    
    *b1 = Container(0,0,0,0)
    SetClass(widget(), "container_1")  
    Button(10, 10, 80, 20,"кнопка_21") 
    Button(10, 40, 80, 20,"кнопка_22") 
    CloseList()
    *b2 = Button(0, 0, 0, 0,"кнопка_2") : SetClass(widget(), GetText(widget()))
    
    *b3 = Button(0, 0, 0, 0,"кнопка_3") : SetClass(widget(), GetText(widget()))  
    
    ;; *s1 = Splitter(5,5, 300, 152, 0, 0) : SetClass(widget(), "split_1")
   
     *s1 = Splitter(5,5, 300, 152, *b1, *b2) : SetClass(widget(), "split_1")
     *b4 = Button(0, 0, 0, 0,"кнопка_4") : SetClass(widget(), GetText(widget()))
     *s2 = Splitter(10, 5, 300, 152, *s1,*b4,  #PB_Splitter_Vertical) : SetClass(widget(), "split_2") 
;     ; Debug widget()\class
;     ;    
; ;     - 
; ;     - none Panel кнопка_5
; ;     - кнопка_1 split_2 кнопка_3
; ;     - split_2 кнопка_3 split_1
; ;     - кнопка_3 split_1 none
; ;     - Panel кнопка_5 none
; ;     - none кнопка_2 кнопка_1
; ;     - кнопка_2 кнопка_1 split_2
;     
; ;     - 
; ;     - none Panel кнопка_5
; ;     - кнопка_1 split_2 split_1
; ;     - split_2 split_1 кнопка_3
; ;     - none кнопка_2 кнопка_1
; ;     - кнопка_2 кнопка_1 split_2
; ;     - split_1 кнопка_3 none
; ;     - Panel кнопка_5 none
;     
;     
; ;     - 
; ;     - none Panel кнопка_5
; ;     - кнопка_3 split_2 none
; ;     - split_1 кнопка_3 split_2
; ;     - кнопка_2 split_1 кнопка_3
; ;     - кнопка_1 кнопка_2 split_1
; ;     - none кнопка_1 кнопка_2
; ;     - Panel кнопка_5 none
 
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