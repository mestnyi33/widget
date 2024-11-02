IncludePath "../../../"
XIncludeFile "-widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *s1, *s2, *p1, *b0,*b1,*b2,*b3, *b4, *b5
  
  If Open(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *p1 = Panel (5, 30, 340, 266)
    AddItem(*p1, -1, "Под-Панель 1")
    
    AddItem(*p1, -1, "Под-Панель 3") 
    *b0 = Button(5, 5, 80, 20,"кнопка_0") : SetClass(widget(), GetText(widget()))  
    *b1 = Button(0,0,0,0,"кнопка_1") : SetClass(widget(), GetText(widget()))
    *b2 = Button(0,0,0,0,"кнопка_2") : SetClass(widget(), GetText(widget()))
    *b3 = Button(5, 30, 80, 20,"кнопка_3") : SetClass(widget(), GetText(widget()))  
    
    *s1 = Splitter(0,0,0,0, *b1, *b2) : SetClass(widget(), "split_1")
    *b4 = Button(0,0,0,0,"кнопка_4") : SetClass(widget(), GetText(widget()))
    *s2 = Splitter(5, 55, 300, 150, *s1,*b4,  #PB_Splitter_Vertical) : SetClass(widget(), "split_2") 
    *b5 = Button(5, 55+155, 80, 20,"кнопка_5") : SetClass(widget(), GetText(widget()))
    
    ;     - 
    ;     - 0 0 none Panel кнопка_6
    ;     - 1 1 none кнопка_0 кнопка_3
    ;     - 2 4 кнопка_0 кнопка_3 split_2
    ;     - 3 7 кнопка_3 split_2 кнопка_5
    ;     - 4 5 none split_1 кнопка_4
    ;     - 5 2 none кнопка_1 кнопка_2
    ;     - 6 3 кнопка_1 кнопка_2 none
    ;     - 7 6 split_1 кнопка_4 none
    ;     - 8 8 split_2 кнопка_5 none
    ;     - 9 9 Panel кнопка_6 none
    ;     -
    
    CloseList()
    Button(5, 30+266+5, 55, 22,"кнопка_6") : SetClass(widget(), GetText(widget()))
    
    SetState(*p1,1)
    
    debug_position(root())
    
    WaitClose()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP