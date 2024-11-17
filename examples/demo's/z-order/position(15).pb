XIncludeFile "../../../widgets.pbi"
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
  
  MyCanvas = GetCanvasGadget(OpenRootWidget(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  ; last-root
   Define *w = WindowWidget(10,10,200,200, "window_main", #PB_Window_SystemMenu|#__flag_autosize) : SetWidgetClass(*w, "window_main")
  
  Define *f0 = WindowWidget(10,10,200,200, "form_0", #PB_Window_SystemMenu, *w) : SetWidgetClass(*f0, "form_0")
;   ButtonWidget(10,10,100,30,"button_0_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
;   ButtonWidget(10,50,100,30,"button_0_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
;   ButtonWidget(10,90,100,30,"button_0_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  
  Define *g1 = ContainerWidget(30,10,200,200) : SetWidgetClass(*g1, "container_1")
  ButtonWidget(10,10,100,30,"button_1_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,100,30,"button_1_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,100,30,"button_1_2") : SetWidgetClass(widget(), GetTextWidget(widget()))

  Define *g2 = ContainerWidget(50,10,200,200) : SetWidgetClass(*g2, "container_2")
  ButtonWidget(10,10,100,30,"button_2_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,100,30,"button_2_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,100,30,"button_2_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
;   
  Define *f1 = WindowWidget(120,40,200,200, "form_1", #PB_Window_SystemMenu, *w) : SetWidgetClass(*f1, "form_1")
  ButtonWidget(10,10,80,30,"button_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,80,30,"button_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,80,30,"button_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  
  OpenWidgetList(*f0)
  ButtonWidget(10,10,130,30,"button_0_0") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,50,130,30,"button_0_1") : SetWidgetClass(widget(), GetTextWidget(widget()))
  ButtonWidget(10,90,130,30,"button_0_2") : SetWidgetClass(widget(), GetTextWidget(widget()))
  CloseWidgetList()
  
;   ;SortStructuredList(widget(), #PB_Sort_Ascending, OffsetOf(_s_count\index), TypeOf(_s_count\index))
            
           
;   ResizeWidget(*g2, #PB_Ignore, 300, #PB_Ignore, #PB_Ignore)
;   ResizeWidget(*g1, 300, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Debug "---->>"
  ForEach widgets()
    Debug ""+ Space((widgets()\level-1)*5) +" "+ widgets()\class
  Next
  Debug "<<----"
  
  
; debug >> result 
;   ---->>
;    window_main
;        form_0
;            container_1
;                button_1_0
;                button_1_1
;                button_1_2
;                container_2
;                    button_2_0
;                    button_2_1
;                    button_2_2
;            button_0_0
;            button_0_1
;            button_0_2
;        form_1
;            button_0
;            button_1
;            button_2
;   <<----

  WaitCloseRootWidget( )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 45
; Folding = -
; EnableXP