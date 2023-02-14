XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=10,y=10, Width=820, Height=620 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi._s_widget = MDI(x,y, width,height)
  ;a_init( *mdi )
  
  Define *g0._s_widget = AddItem(*mdi, -1, "main") : SetClass(widget(), "main") 
  Button(10,10,80,80,"button_0") : SetClass(widget(), GetText(widget())) 
  
  Define *g1._s_widget = AddItem(*mdi, -1, "Child 1 (Position Attach)") : SetClass(widget(), "form_1") 
  Button(10,10,80,80,"button_1") : SetClass(widget(), GetText(widget())) 
  
  Define *g2._s_widget = AddItem(*mdi, -1, "Child 2 (Frame Magnetic)") : SetClass(widget(), "form_2") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  Define *g3._s_widget = AddItem(*mdi, -1, "SubChild") : SetClass(widget(), "SubChild") 
  Button(10,10,80,80,"button_3") : SetClass(widget(), GetText(widget())) 
  
  ;
  Resize(*g0, 50, 50, 400, 400)
  Resize(*g1, X(*g0, #__c_container)+50, Y(*g0, #__c_container)+50, 200, 300)
  Resize(*g2, X(*g0, #__c_container)+Width(*g0, #__c_Frame), Y(*g0, #__c_container), 200, 300)
  Resize(*g3, X(*g2, #__c_container), Y(*g2, #__c_container)+Height(*g2, #__c_Frame), 200, 100)
  
  
  SetState(*mdi\scroll\h, 120)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP