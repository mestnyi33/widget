IncludePath "../../../"
XIncludeFile "-widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *s1, *s2, *p1, *b0,*b1,*b2,*b3, *b4, *b5
  
  If OpenRoot(OpenWindow(#PB_Any, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    *p1 = Panel (5, 30, 340, 266)
    AddItem(*p1, -1, "Под-Панель 1")
    
    AddItem(*p1, -1, "Под-Панель 3") 
    *b0 = ButtonWidget(5, 5, 80, 20,"кнопка_0") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    *b1 = ButtonWidget(0,0,0,0,"кнопка_1") : SetWidgetClass(widget(), GetWidgetText(widget()))
    *b2 = ButtonWidget(0,0,0,0,"кнопка_2") : SetWidgetClass(widget(), GetWidgetText(widget()))
    *b3 = ButtonWidget(5, 30, 80, 20,"кнопка_3") : SetWidgetClass(widget(), GetWidgetText(widget()))  
    
    *s1 = SplitterWidget(0,0,0,0, *b1, *b2) : SetWidgetClass(widget(), "split_1")
    *b4 = ButtonWidget(0,0,0,0,"кнопка_4") : SetWidgetClass(widget(), GetWidgetText(widget()))
    *s2 = SplitterWidget(5, 55, 300, 150, *s1,*b4,  #PB_Splitter_Vertical) : SetWidgetClass(widget(), "split_2") 
    *b5 = ButtonWidget(5, 55+155, 80, 20,"кнопка_5") : SetWidgetClass(widget(), GetWidgetText(widget()))
    
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
    
    CloseWidgetList()
    ButtonWidget(5, 30+266+5, 55, 22,"кнопка_6") : SetWidgetClass(widget(), GetWidgetText(widget()))
    
    SetWidgetState(*p1,1)
    
    debug_position(root())
    
    WaitCloseRoot()
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP