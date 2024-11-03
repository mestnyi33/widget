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
  
  If Open(OpenWindow(#PB_Any, 0, 0, 240,205, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    Button(5, 5, 200, 30,"btn0") : SetClass(widget(), GetText(widget()))  
    If #demo = #before
      *b1 = Button( 5, 5,80,30, "btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(25,25,80,30, "btn2") : SetClass(widget(), GetText(widget()))
    EndIf
    
    *c0 = Panel(5, 40, 200, 100) : SetClass(widget(), "con0") 
    SetColor(widget(), #PB_Gadget_BackColor, $ffff00ff)
    
    AddItem(*c0, -1, "1")
    Button(105,  5, 50, 30,"101") : SetClass(widget(), GetText(widget()))  
    Button(115, 25, 50, 30,"102") : SetClass(widget(), GetText(widget()))  
    Button(125, 45, 50, 30,"103") : SetClass(widget(), GetText(widget()))  
    AddItem(*c0, -1, "2")
    ;Define *b201 = Button(105,  5, 50, 30,"201") : SetClass(*b201, GetText(*b201))  
    Button(105,  5, 50, 30,"201") : SetClass(widget(), GetText(widget()))  
    Button(115, 25, 50, 30,"202") : SetClass(widget(), GetText(widget()))  
    Button(125, 45, 50, 30,"203") : SetClass(widget(), GetText(widget()))  
    AddItem(*c0, -1, "3")
    ;Define *b301 = Button(105,  5, 50, 30,"301") : SetClass(*b301, GetText(*b301))  
    Button(105,  5, 50, 30,"301") : SetClass(widget(), GetText(widget()))  
    Button(115, 25, 50, 30,"302") : SetClass(widget(), GetText(widget()))  
    Button(125, 45, 50, 30,"303") : SetClass(widget(), GetText(widget()))  
    CloseList()
    
    Button(5, 145, 200, 30, "btn3") : SetClass(widget(), GetText(widget()))
    
    If #demo = #after
      *b1 = Button( 5, 5,80,50, "btn1") : SetClass(widget(), GetText(widget()))
      *b2 = Button(25,25,80,50, "btn2") : SetClass(widget(), GetText(widget()))
    EndIf
    
    If #demo = #open
      OpenList(*c0, 0)
      *b1 = Button(5,5,80,50,"btn1") : SetClass(widget(), GetText(widget()))
      CloseList()
      OpenList(*c0, 1)
      *b2 = Button(25,25,80,50, "btn2") : SetClass(widget(), GetText(widget()))
      CloseList()
    Else
      SetParent(*b1, *c0, 0)
      SetParent(*b2, *c0, 1)
    EndIf
    
;     - #after
;     - 0 0 none btn0 con0
;     - 1 1 btn0 con0 btn3
;     - 2 2 none 101 102
;     - 3 3 101 102 103
;     - 4 4 102 103 btn1
;     - 5 12 103 btn1 201
;     - 6 5 btn1 201 202
;     - 7 6 201 202 203
;     - 8 7 202 203 btn2
;     - 9 13 203 btn2 301
;     - 10 8 btn2 301 302
;     - 11 9 301 302 303
;     - 12 10 302 303 none
;     - 13 11 con0 btn3 none
;     -
;     - last
;     - window - btn3
;     - panel 
;     -    (1) - btn1
;     -    (2) - btn2
;     -    (3) - 303
    
    debug_position(root())
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP