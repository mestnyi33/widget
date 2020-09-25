IncludePath "../../"
XIncludeFile "widgets.pbi"


 
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *s1._s_widget, *s2._s_widget, *p1._s_widget,*b1._s_widget, *b2._s_widget,*b3._s_widget
    
  If Open(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *p1 = Panel (5, 30, 340, 166)
    AddItem(*p1, -1, "Под-Панель 1")
    
    AddItem(*p1, -1, "Под-Панель 3") 
;     *b1 = Button(0, 0, 0, 0,"кнопка_1") : SetClass(widget(), GetText(widget()))  
;     *b2 = Button(0, 0, 0, 0,"кнопка_2") : SetClass(widget(), GetText(widget()))
    *s1 = Splitter(5,5, 300, 152, *b1, *b2) : SetClass(widget(), "split_1")
;     *b3 = Button(0, 0, 0, 0,"кнопка_3") : SetClass(widget(), GetText(widget()))
    *s2 = Splitter(10, 5, 300, 152, *s1, *b3, #PB_Splitter_Vertical) : SetClass(widget(), "split_2") 
    
    Debug widget()\class
     ;;Debug *s1\class
     Debug *s2\class
    ;  - 
    ;  - none splitter_2 кнопка_5
    ;  - кнопка_1 Splitter кнопка_3
    ;  - Splitter кнопка_3 Splitter
    ;  - кнопка_3 Splitter none
    ;  - splitter_2 кнопка_5 none
    ;  - none кнопка_2 кнопка_1
    ;  - кнопка_2 кнопка_1 Splitter
    ; 
    
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