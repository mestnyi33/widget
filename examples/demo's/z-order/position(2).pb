IncludePath "../../../"
XIncludeFile "-widgets.pbi"



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
  
  If OpenRoot(OpenWindow(#PB_Any, 0, 0, 240, 205, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    ButtonWidget(5, 5, 200, 30,"btn0") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    
    If #demo = #before
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
    EndIf
    
    *c0 = SplitterWidget(5, 40, 200, 100, 0, 0) 
    SetWidgetClass(widget(), "con0")
    ButtonWidget(5, 145, 200, 30,"btn3") : SetWidgetClass(widget(), GetWidgetText(widget()))
    
    If #demo = #after
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
    EndIf
    
    If #demo = #open
      OpenWidgetList(*c0)
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
      CloseWidgetList()
    Else
      ;     SetWidgetAttribute(*c0, #PB_Splitter_FirstGadget, *b1)
      ;     SetWidgetAttribute(*c0, #PB_Splitter_SecondGadget, *b2)
      
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
    
    
    debug_position(root())
    
    WaitCloseRoot()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP