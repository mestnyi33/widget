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
  
  If OpenRoot(OpenWindow(#PB_Any, 0, 0, 240,205, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    ButtonWidget(5, 5, 200, 30,"btn0") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    If #demo = #before
      *b1 = ButtonWidget( 5, 5,80,30, "btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      *b2 = ButtonWidget(25,25,80,30, "btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
    EndIf
    
    *c0 = PanelWidget(5, 40, 200, 100) : SetWidgetClass(widget(), "con0") 
    SetWidgetColor(widget(), #PB_Gadget_BackColor, $ffff00ff)
    
    AddItem(*c0, -1, "1")
    ButtonWidget(105,  5, 50, 30,"101") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(115, 25, 50, 30,"102") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(125, 45, 50, 30,"103") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    AddItem(*c0, -1, "2")
    ;Define *b201 = ButtonWidget(105,  5, 50, 30,"201") : SetWidgetClass(*b201, GetWidgetText(*b201))  
    ButtonWidget(105,  5, 50, 30,"201") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(115, 25, 50, 30,"202") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(125, 45, 50, 30,"203") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    AddItem(*c0, -1, "3")
    ;Define *b301 = ButtonWidget(105,  5, 50, 30,"301") : SetWidgetClass(*b301, GetWidgetText(*b301))  
    ButtonWidget(105,  5, 50, 30,"301") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(115, 25, 50, 30,"302") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    ButtonWidget(125, 45, 50, 30,"303") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    CloseWidgetList()
    
    ButtonWidget(5, 145, 200, 30, "btn3") : SetWidgetClass(widget(), GetWidgetText(widget()))
    
    If #demo = #after
      *b1 = ButtonWidget( 5, 5,80,50, "btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      *b2 = ButtonWidget(25,25,80,50, "btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
    EndIf
    
    If #demo = #open
      OpenWidgetList(*c0, 0)
      *b1 = ButtonWidget(5,5,80,50,"btn1") : SetWidgetClass(widget(), GetWidgetText(widget()))
      CloseWidgetList()
      OpenWidgetList(*c0, 1)
      *b2 = ButtonWidget(25,25,80,50, "btn2") : SetWidgetClass(widget(), GetWidgetText(widget()))
      CloseWidgetList()
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
    
    WaitCloseRoot()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP