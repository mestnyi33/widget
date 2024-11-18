XIncludeFile "../../../widgets.pbi"

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
  
;   Define *mdi = MDIWidget(x,y,Width, height);, #__flag_autosize)
;   
;   Define *g0 = AddItem(*mdi, -1, "form_0")
;   ButtonWidget(10,10,80,80,"button_0")
;   
;   Define *g1 = AddItem(*mdi, -1, "form_1")
;   ButtonWidget(10,10,80,80,"button_1")
;   
;   Define *g2 = AddItem(*mdi, -1, "form_2")
;   ButtonWidget(10,10,80,80,"button_2")

  WindowWidget(10,10,100,70,"window_1", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "window_1") : CloseWidgetList()
  WindowWidget(120,10,100,70,"window_2", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "window_2") : CloseWidgetList()
  
  WindowWidget(x,y,width, height,"window_3", #PB_Window_SystemMenu) : SetWidgetClass(widget(), "window_3") 
  ;Define *mdi._s_widget = MDIWidget(x,y,Width, height);, #__flag_autosize)
  Define *mdi._s_widget = MDIWidget(10,10, WidgetWidth( widget( ), #__c_inner )-20, WidgetHeight( widget( ), #__c_inner )-20);, #__flag_autosize)
  
  ;Define *mdi._s_widget = MDIWidget(0,0,0,0, #__flag_autosize)
  ;;a_init( *mdi )
  
  Define *g0._s_widget = AddItem(*mdi, -1, "form_0") : SetWidgetClass(widget(), "form_0") 
  ButtonWidget(10,10,80,80,"button_0") : SetWidgetClass(widget(), GetWidgetText(widget())) 
  
  WindowWidget(100,10,100,70,"window_01", #PB_Window_SystemMenu, *g0) : SetWidgetClass(widget(), "window_01") : CloseWidgetList()
  WindowWidget(150,50,100,70,"window_02", #PB_Window_SystemMenu, *g0) : SetWidgetClass(widget(), "window_02") : CloseWidgetList()
  
  Define *g1._s_widget = AddItem(*mdi, -1, "form_1") : SetWidgetClass(widget(), "form_1") 
  ButtonWidget(10,10,80,80,"button_1") : SetWidgetClass(widget(), GetWidgetText(widget())) 
  
  WindowWidget(100,10,100,70,"window_11", #PB_Window_SystemMenu, *g1) : SetWidgetClass(widget(), "window_11") : CloseWidgetList()
  WindowWidget(150,50,100,70,"window_12", #PB_Window_SystemMenu, *g1) : SetWidgetClass(widget(), "window_12") 
  
  ContainerWidget(20,30,60,60)
  widget()\bs = 10 : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ButtonWidget(10,10,80,40,"button_0") : SetWidgetClass(widget(), GetWidgetText(widget())) 
  widget()\bs = 10 : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  CloseWidgetList()
  CloseWidgetList()
  
  Define *g2._s_widget = AddItem(*mdi, -1, "form_2") : SetWidgetClass(widget(), "form_2") 
  ButtonWidget(10,10,80,80,"button_2") : SetWidgetClass(widget(), GetWidgetText(widget())) 
  
  WindowWidget(100,10,100,70,"window_21", #PB_Window_SystemMenu, *g2) : SetWidgetClass(widget(), "window_21") : CloseWidgetList()
  WindowWidget(150,50,100,70,"window_22", #PB_Window_SystemMenu, *g2) : SetWidgetClass(widget(), "window_22") : CloseWidgetList()
  
;   OpenWidgetList(*mdi)
;   ButtonWidget(450,110,80,80,"button_1") : SetWidgetClass(widget(), GetWidgetText(widget())) 
;   CloseWidgetList()
  
  ResizeWidget(*g1, WidgetX(*g0, #__c_container) + WidgetWidth(*g0, #__c_frame) - 15, WidgetY(*g0, #__c_container), #PB_Ignore, #PB_Ignore)
  ResizeWidget(*g2, WidgetX(*g0, #__c_container), WidgetY(*g0, #__c_container) + WidgetHeight(*g0, #__c_frame) - 15, #PB_Ignore, #PB_Ignore)
  
  SetWidgetState(*mdi\scroll\h, 120)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 42
; Folding = -
; EnableXP