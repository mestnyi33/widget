XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=10,y=10, Width=820, Height=620 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(OpenRootWidget(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi._s_widget = MDIWidget(x,y, width,height)
  a_init( *mdi )
  
  Define *g0._s_widget = AddItem(*mdi, -1, "main") : SetWidgetClass(widget(), "main") 
  ButtonWidget(10,10,80,80,"button_0") : SetWidgetClass(widget(), GetTextWidget(widget())) 
  
  Define *g1._s_widget = AddItem(*mdi, -1, "Child 1 (Position Attach)") : SetWidgetClass(widget(), "form_1") 
  ButtonWidget(10,10,80,80,"button_1") : SetWidgetClass(widget(), GetTextWidget(widget())) 
  
  Define *g2._s_widget = AddItem(*mdi, -1, "Child 2 (Frame Magnetic)") : SetWidgetClass(widget(), "form_2") 
  ButtonWidget(10,10,80,80,"button_2") : SetWidgetClass(widget(), GetTextWidget(widget())) 
  
  Define *g3._s_widget = AddItem(*mdi, -1, "SubChild") : SetWidgetClass(widget(), "SubChild") 
  ButtonWidget(10,10,80,80,"button_3") : SetWidgetClass(widget(), GetTextWidget(widget())) 
  
  ;
  ResizeWidget(*g0, 50, 50, 400, 400)
  ResizeWidget(*g1, WidgetX(*g0, #__c_container)+50, WidgetY(*g0, #__c_container)+50, 200, 300)
  ResizeWidget(*g2, WidgetX(*g0, #__c_container) + WidgetWidth(*g0, #__c_Frame), WidgetY(*g0, #__c_container), 200, 300)
  ResizeWidget(*g3, WidgetX(*g2, #__c_container), WidgetY(*g2, #__c_container) + WidgetHeight(*g2, #__c_Frame), 200, 100)
  
  
  SetState(*mdi\scroll\h, 120)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 11
; Folding = -
; EnableXP