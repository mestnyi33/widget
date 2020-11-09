XIncludeFile "../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=10,y=10, Width=820, Height=620 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  Procedure events_()
    
    Select This()\event
      Case #PB_EventType_LeftClick
        Define flag
        Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info) 
        Define a$ = "Result of the previously requester was: "
        
        If Result = #PB_MessageRequester_Yes       ; pressed Yes button
          flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
          a$ +#LF$+ "Yes"
        ElseIf Result = #PB_MessageRequester_No    ; pressed No button
          flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
          a$ +#LF$+ "No"
        Else                                       ; pressed Cancel button or Esc
          flag = #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning
          a$ +#LF$+ "Cancel"
        EndIf
        
        Message("Information", a$, flag)
  
    EndSelect
    
  EndProcedure
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi._s_widget = Container(x,y,Width, height)
  ;;a_init( *mdi )
  Define flag = #__window_systemmenu | #__window_sizegadget | #__window_maximizegadget | #__window_minimizegadget ;| #__window_child
  
  Define *g0._s_widget = Window(50, 50, 400, 400, "main",flag,*mdi) : SetClass(widget(), "main") 
  Button(10,10,80,80,"button_0") : SetClass(widget(), GetText(widget())) 
  
  Define *g1._s_widget =  Window(X(*g0, #__c_container)+50, Y(*g0, #__c_container)+50, 200, 300, "Child 1 (Position Attach)",flag,*mdi) : SetClass(widget(), "form_1") 
  Define *g1b = Button(10,10,80,80,"message") : SetClass(widget(), GetText(widget())) 
  
  Define *g2._s_widget = Window(X(*g0, #__c_container)+Width(*g0, #__c_Frame), Y(*g0, #__c_container), 200, 300, "Child 2 (Frame Magnetic)",flag,*mdi) : SetClass(widget(), "form_2") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  Define *g3._s_widget = Window(X(*g2, #__c_container), Y(*g2, #__c_container)+Height(*g2, #__c_Frame), 200, 100, "SubChild",flag,*mdi) : SetClass(widget(), "SubChild") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  bind(*g1b, @events_())
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP