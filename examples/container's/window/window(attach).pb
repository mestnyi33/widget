XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile 
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=10,y=10, Width=820, Height=620 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Window Attachments", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  Procedure CustomEvents( )
    
    Select WidgetEvent( )
      Case #__event_LeftClick
        Debug "open - Title"
        Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info) 
        Debug " close - Title " + Result
        
        Define flag, a$ = "Result of the previously requester was: "
        
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
        
        Debug "open - Information"
        Result = Message("Information", a$, flag)
        Debug "close - Information "+Result
        
      Case #__event_Draw
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        Box(EventWidget()\x,EventWidget()\y,EventWidget()\width,EventWidget()\height, $ffff0000)
        Box(EventWidget()\x[#__c_draw],EventWidget()\y[#__c_draw],EventWidget()\width[#__c_draw],EventWidget()\height[#__c_draw], $ff0000ff)
        
    EndSelect
  EndProcedure
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  ;Define *mdi._s_widget = Container(x,y,Width, height)
  Define *mdi._s_widget = MDI(x,y,Width, height)
  ;Define *mdi._s_widget = Window(x,y,Width, height, "container",0,*mdi) : SetClass(widget(), "container") 
  a_init( *mdi, 0 )
  OpenList(*mdi)
  Button(10,50,80,80,"mdi-top")
  Button(10,400+50,80,80,"mdi-bottom")
  CloseList()
  
  Define flag = #__window_systemmenu | #__window_sizegadget | #__window_maximizegadget | #__window_minimizegadget ;| #__window_child ;|#__flag_borderless
  Define vfs ;= #__window_CaptionHeight+#__window_FrameSize*2
  
  Define *g0._s_widget = Window(50, 50, 400, 400-vfs, "main",flag|#__window_child, *mdi) : SetClass(widget(), "main") 
  Button(10,10,80,80,"button_0") : SetClass(widget(), GetText(widget())) 
  
  Define *g1._s_widget =  Window(X(*g0, #__c_container)+50, WidgetY(*g0, #__c_container)+50, 200, 300, "Child 1 (Position Attach)",flag,*g0) : SetClass(widget(), "form_1") 
  Define *g1b = Button(10,10,80,80,"message") : SetClass(widget(), GetText(widget())) 
  ; Sticky(*g1, 1)
  
  Define *g2._s_widget = Window(X(*g0, #__c_container)+Width(*g0, #__c_Frame), WidgetY(*g0, #__c_container), 200, 300-vfs, "Child 2 (Frame Magnetic)",flag,*g0) : SetClass(widget(), "form_2") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  Define *g3._s_widget = Window(X(*g2, #__c_container), WidgetY(*g2, #__c_container)+Height(*g2, #__c_Frame), 200, 100-vfs, "SubChild",flag,*g2) : SetClass(widget(), "SubChild") 
  Button(10,10,80,80,"button_2") : SetClass(widget(), GetText(widget())) 
  
  Bind(*g1b, @CustomEvents(), #__event_LeftClick )
  
;   Bind(*g0, @CustomEvents(), #__event_Draw)
;   Bind(*g1, @CustomEvents(), #__event_Draw)
;   Bind(*g2, @CustomEvents(), #__event_Draw)
;   Bind(*g3, @CustomEvents(), #__event_Draw)
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 74
; FirstLine = 54
; Folding = -
; EnableXP
; DPIAware