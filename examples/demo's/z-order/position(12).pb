XIncludeFile "../../../-widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=420, Height=420 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g = window(10,10,200,200, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetWidgetClass(widget(), "window")
  
  Define *g0 = ContainerWidget(10,10,200,200) : SetWidgetClass(widget(), "form_0")
  CloseList()
  
  Define *g1 = ContainerWidget(30,30,200,200) : SetWidgetClass(widget(), "form_1")
  ButtonWidget(10,10,80,30,"button_1_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,80,30,"button_1_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,80,30,"button_1_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  CloseList()
  
  Define *g2 = ContainerWidget(50,50,200,200) : SetWidgetClass(widget(), "form_2")
  ButtonWidget(10,10,80,30,"button_2_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,80,30,"button_2_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,80,30,"button_2_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  CloseList()
  
  OpenList(*g0)
  ButtonWidget(10,10,80,30,"button_0_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,80,30,"button_0_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,80,30,"button_0_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  CloseList()
  
  ;SortStructuredList(widget(), #PB_Sort_Ascending, OffsetOf(_s_count\index), TypeOf(_s_count\index))
            
           
;   ResizeWidget(*g2, #PB_Ignore, 300, #PB_Ignore, #PB_Ignore)
;   ResizeWidget(*g1, 300, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Debug "---->>"
  ForEach widget()
    Debug "  "+ widget()\class
  Next
  Debug "<<----"
  
  WaitClose( )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP