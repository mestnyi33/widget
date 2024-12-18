IncludePath "../../../../"
XIncludeFile "widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  
  Enumeration 
    #before
    #after
    #open
  EndEnumeration
  
  #demo = #after
  Global *c0,*b1,*b2
  
  If Open(0, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    Button(5, 5, 200, 30,"btn0") : SetClass(widget(), GetText(widget()))  
    
    If #demo = #before
      *b1 = Button(10,10,80,50,"btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(30,40,80,50,"btn2") : SetClass(widget(), GetText(widget()))
    EndIf
    
    *c0 = Container(5, 40, 200, 100) : SetClass(widget(), "con0") 
    SetColor(widget(), #PB_Gadget_BackColor, $ffff00ff)
    Button(80, 20, 80, 50,"ctn1") : SetClass(widget(), GetText(widget()))  
    CloseList()
    
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
      SetParent(*b1, *c0)
      SetParent(*b2, *c0)
    EndIf
    
    ;     - 
    ;     - 0 0 --- btn0 con0
    ;     - 1 1 btn0 con0 btn3
    ;     - 2 2 --- ctn1 btn1
    ;     - 3 4 ctn1 btn1 btn2
    ;     - 4 5 btn1 btn2 ---
    ;     - 5 3 con0 btn3 ---
    ;     -
    
    
    debug_position(root())
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = -
; EnableXP