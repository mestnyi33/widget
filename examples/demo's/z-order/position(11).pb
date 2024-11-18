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
  
  MyCanvas = GetCanvasGadget(OpenRoot(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g0 = WindowWidget(10,10,200,200, "form_0", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "form_0")
  
  Define *g1 = WindowWidget(30,30,200,200, "form_1", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "form_1")
  ButtonWidget(10,10,80,30,"button_1_0") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,50,80,30,"button_1_1") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,90,80,30,"button_1_2") : SetWidgetClass(widget(), GetWidgetText(widget()))

  Define *g2 = WindowWidget(50,50,200,200, "form_2", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "form_2")
  ButtonWidget(10,10,80,30,"button_2_0") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,50,80,30,"button_2_1") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,90,80,30,"button_2_2") : SetWidgetClass(widget(), GetWidgetText(widget()))
  
  OpenWidgetList(*g0)
  ButtonWidget(10,10,80,30,"button_0_0") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,50,80,30,"button_0_1") : SetWidgetClass(widget(), GetWidgetText(widget()))
  ButtonWidget(10,90,80,30,"button_0_2") : SetWidgetClass(widget(), GetWidgetText(widget()))
  CloseWidgetList()
  
  ;SortStructuredList(widget(), #PB_Sort_Ascending, OffsetOf(_s_count\index), TypeOf(_s_count\index))
            
           
;   ResizeWidget(*g2, #PB_Ignore, 300, #PB_Ignore, #PB_Ignore)
;   ResizeWidget(*g1, 300, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Debug "---->>"
  ForEach widget()
    Debug "  "+ widget()\class
  Next
  Debug "<<----"
  
  WaitCloseRoot( )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP