IncludePath "../../../"
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
    
    ButtonWidget(5, 5, 200, 30,"btn0") : SetWidgetClass(widget(), GetTextWidget(widget()))  
    
    If #demo = #before
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetTextWidget(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetTextWidget(widget()))
    EndIf
    
    *c0 = ContainerWidget(5, 40, 200, 100) : SetWidgetClass(widget(), "con0") 
    SetWidgetColor(widget(), #PB_Gadget_BackColor, $ffff00ff)
    ButtonWidget(80, 20, 80, 50,"ctn1") : SetWidgetClass(widget(), GetTextWidget(widget()))  
    CloseList()
    
    ButtonWidget(5, 145, 200, 30,"btn3") : SetWidgetClass(widget(), GetTextWidget(widget()))
    
    If #demo = #after
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetTextWidget(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetTextWidget(widget()))
    EndIf
  
    If #demo = #open
      OpenList(*c0)
      *b1 = ButtonWidget(10,10,80,50,"btn1") : SetWidgetClass(widget(), GetTextWidget(widget()))
      *b2 = ButtonWidget(30,40,80,50,"btn2") : SetWidgetClass(widget(), GetTextWidget(widget()))
      CloseList()
    Else
      SetParent(*b1, *c0)
      SetParent(*b2, *c0)
    EndIf
    
    ;     - 
    ;     - 0 0 none btn0 con0
    ;     - 1 1 btn0 con0 btn3
    ;     - 2 2 none ctn1 btn1
    ;     - 3 4 ctn1 btn1 btn2
    ;     - 4 5 btn1 btn2 none
    ;     - 5 3 con0 btn3 none
    ;     -
    
    
    debug_position(root())
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 20
; FirstLine = 28
; Folding = -
; EnableXP