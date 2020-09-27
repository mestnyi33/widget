IncludePath "../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *s1, *s2, *p1, *b0,*b1,*b2,*b3, *b4, *b5
  
  If Open(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *b0 = Button(5, 5, 200, 30,"btn0") : SetClass(widget(), GetText(widget()))  
    *b1 = Button(10,10,80,30,"btn1") : SetClass(widget(), GetText(widget()))
    *b2 = Button(10,40,80,30,"btn2") : SetClass(widget(), GetText(widget()))
    
    *s1 = Splitter(5, 40, 200, 100, *b1, *b2) : SetClass(widget(), "con1")
    *b3 = Button(5, 145, 200, 30,"btn3") : SetClass(widget(), GetText(widget()))
    
    
    ;     - 
    ;     - 0 0 none btn0 con1
    ;     - 1 3 btn0 con1 btn3
    ;     - 2 1 none btn1 btn2
    ;     - 3 2 btn1 btn2 none
    ;     - 4 4 con1 btn3 none
    ;     -
    
    
    Debug " - "
    ForEach widget( ) 
      If widget( )\before And widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\before
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" none"
      Else
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class + " none " 
      EndIf
    Next
    Debug ""
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP