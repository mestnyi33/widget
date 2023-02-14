XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=420, Height=420 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
;   Define *mdi = MDI(x,y,Width, height);, #__flag_autosize)
;   
;   Define *g0 = AddItem(*mdi, -1, "form_0")
;   Button(10,10,80,80,"button_0")
;   
;   Define *g1 = AddItem(*mdi, -1, "form_1")
;   Button(10,10,80,80,"button_1")
;   
;   Define *g2 = AddItem(*mdi, -1, "form_2")
;   Button(10,10,80,80,"button_2")

  Window(10,10,100,70,"window_1", #PB_Window_SystemMenu) : SetClass(widget(), "window_1") : CloseList()
  Window(120,10,100,70,"window_2", #PB_Window_SystemMenu) : SetClass(widget(), "window_2") : CloseList()
  
  Window(x,y,width, height,"window_3", #PB_Window_SystemMenu) : SetClass(widget(), "window_3") 
  ;Define *mdi._s_widget = MDI(x,y,Width, height);, #__flag_autosize)
  Define *mdi._s_widget = MDI(10,10, width( widget( ), #__c_inner )-20, height( widget( ), #__c_inner )-20);, #__flag_autosize)
  
  ;Define *mdi._s_widget = MDI(0,0,0,0, #__flag_autosize)
  ;;a_init( *mdi )
  
  Define *g0._s_widget = AddItem(*mdi, -1, "form_0") : SetClass(widget(), "form_0") 
  Button(10,10,80,80,"button_0") : SetClass(widget(), GetText(widget())) 
  
  Window(100,10,100,70,"window_01", #PB_Window_SystemMenu, *g0) : SetClass(widget(), "window_01") : CloseList()
  Window(150,50,100,70,"window_02", #PB_Window_SystemMenu, *g0) : SetClass(widget(), "window_02") : CloseList()
  
  Define *g1._s_widget = AddItem(*mdi, -1, "form_1") : SetClass(widget(), "form_1") 
  Button(10,10,80,80,"button_1") : SetClass(widget(), GetText(widget())) 
  
  Window(100,10,100,70,"window_11", #PB_Window_SystemMenu, *g1) : SetClass(widget(), "window_11") : CloseList()
  Window(150,50,100,70,"window_12", #PB_Window_SystemMenu, *g1) : SetClass(widget(), "window_12") 
  
  Container(20,30,60,60)
  widget()\bs = 10 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Button(10,10,80,40,"button_0") : SetClass(widget(), GetText(widget())) 
  widget()\bs = 10 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  CloseList()
  CloseList()
  
  Define *g2._s_widget = AddItem(*mdi, -1, "form_2") : SetClass(widget(), "form_2") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  Window(100,10,100,70,"window_21", #PB_Window_SystemMenu, *g2) : SetClass(widget(), "window_21") : CloseList()
  Window(150,50,100,70,"window_22", #PB_Window_SystemMenu, *g2) : SetClass(widget(), "window_22") : CloseList()
  
;   OpenList(*mdi)
;   Button(450,110,80,80,"button_1") : SetClass(widget(), GetText(widget())) 
;   CloseList()
  
  Resize(*g1, X(*g0, #__c_container) + Width(*g0, #__c_frame) - 15, Y(*g0, #__c_container), #PB_Ignore, #PB_Ignore)
  Resize(*g2, X(*g0, #__c_container), Y(*g0, #__c_container) + Height(*g0, #__c_frame) - 15, #PB_Ignore, #PB_Ignore)
  
  SetState(*mdi\scroll\h, 120)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP