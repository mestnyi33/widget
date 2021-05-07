IncludePath "../../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Enumeration 
    #before
    #after
    #open
  EndEnumeration
  
  #demo = #after
  Global *c0,*b1,*b2
  
  If Open(OpenWindow(#PB_Any, 0, 0, 240, 205, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    Button(5, 5, 200, 30,"btn0") : SetClass(widget(), GetText(widget()))  
    
    If #demo = #before
      *b1 = Button(10,10,80,50,"btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(30,40,80,50,"btn2") : SetClass(widget(), GetText(widget()))
    EndIf
    
    *c0 = Splitter(5, 40, 200, 100, 0, 0) 
    SetClass(widget(), "con0")
    Button(5, 145, 200, 30,"btn3") : SetClass(widget(), GetText(widget()))
    
    If #demo = #after
      *b1 = Button(10,10,80,50,"btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(30,40,80,50,"btn2") : SetClass(widget(), GetText(widget()))
    EndIf
    
    If #demo = #open
      OpenList(*c0)
      *b1 = Button(10,10,80,50,"btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(30,40,80,50,"btn2") : SetClass(widget(), GetText(widget()))
      CloseList()
    Else
      ;     SetAttribute(*c0, #PB_Splitter_FirstGadget, *b1)
      ;     SetAttribute(*c0, #PB_Splitter_SecondGadget, *b2)
      
      SetParent(*b1, *c0, #PB_Splitter_FirstGadget)
      SetParent(*b2, *c0, #PB_Splitter_SecondGadget)
    EndIf
    
    ;     - 
    ;     - 0 0 none btn0 con0
    ;     - 1 1 btn0 con0 btn3
    ;     - 2 3 none btn1 btn2
    ;     - 3 4 btn1 btn2 none
    ;     - 4 2 con0 btn3 none
    ;     -
    
    
    debug_position()
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP