IncludePath "../"
XIncludeFile "bar().pb"
;XIncludeFile "widgets(_align_0_0_0).pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule constants
  UseModule structures
  
  Global g_Canvas, NewList *List._s_widget()
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure GetCurrentEvent()
      Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
      If app
        ProcedureReturn CocoaMessage(0,app,"currentEvent")
      EndIf
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaX()
      Protected wheelDeltaX.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
      EndIf
      ProcedureReturn wheelDeltaX
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaY()
      Protected wheelDeltaY.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
      EndIf
      ProcedureReturn wheelDeltaY
    EndProcedure
  CompilerEndIf
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    
    ForEach *List()
      If *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    ForEach *List()
      If Not *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure v_CallBack(GetState, type)
    ;     Select type
    ;       Case #PB_GadgetType_ScrollBar
    ;         SetGadgetState(2, GetState)
    ;       Case #PB_GadgetType_TrackBar
    ;         SetGadgetState(12, GetState)
    ;       Case #PB_GadgetType_ProgressBar
    ;         SetGadgetState(22, GetState)
    ;       Case #PB_GadgetType_Splitter
    ;         ; SetGadgetState(Splitter_4, GetState)
    ;     EndSelect
    ;     
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure h_CallBack(GetState, type)
    ;     Select type
    ;       Case #PB_GadgetType_ScrollBar
    ;         SetGadgetState(1, GetState)
    ;       Case #PB_GadgetType_TrackBar
    ;         SetGadgetState(11, GetState)
    ;       Case #PB_GadgetType_ProgressBar
    ;         SetGadgetState(21, GetState)
    ;       Case #PB_GadgetType_Splitter
    ;         ; SetGadgetState(Splitter_3, GetState)
    ;     EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta ; = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._s_widget = GetGadgetData(Canvas)
    
    If EventType = #PB_EventType_MouseWheel
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected wheel_X.CGFloat = GetWheelDeltaX()
        Protected wheel_Y.CGFloat = GetWheelDeltaY()
      CompilerElse
        Protected wheel_X
        Protected wheel_Y
      CompilerEndIf
    EndIf
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | Events(*List(), EventType, MouseX, MouseY, wheel_X, wheel_Y)
      
      If *List()\change
        
        If *List()\bar\vertical
          v_CallBack(*List()\bar\page\pos, *List()\type)
        Else
          h_CallBack(*List()\bar\page\pos, *List()\type)
        EndIf
        
        *List()\change = 0
      EndIf
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ev()
    Debug ""+Widget() ; +" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    Debug "  "+Widget() ; +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 475+160, 160, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g_Canvas = CanvasGadget(-1, 0, 0, 475+170, 160, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    Spin(5, 5, 150, 30, 0, 20) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Spin(5, 40, 150, 30, 0, 20, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Spin(5, 75, 150, 30, 0, 20, #__bar_Reverse) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    
    Scroll(160, 5, 150, 20, 0, 50, 30) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Scroll(160, 5+25, 150, 10, 0, 50, 30, #__bar_Inverted) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    
    Track(160, 5+53, 150, 20, 0, 20) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Track(160, 5+53+25, 150, 20, 0, 20, #__bar_Inverted) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 1)
    
    Progress(160, 5+105, 150, 20, 0, 20) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Progress(160, 5+105+25, 150, 20, 0, 20, #__bar_Inverted) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 1)
    
    Scroll(320, 5, 20, 150, 0, 50, 30, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    Scroll(320+25, 5, 10, 150, 0, 50, 30, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 1)
    
    Track(320+53, 5, 20, 150, 0, 20, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 0)
    Track(320+53+25, 5, 20, 150, 0, 20, #__bar_Vertical|#__bar_Inverted) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    
    Progress(320+105, 5, 20, 150, 0, 20, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 0)
    Progress(320+105+25, 5, 20, 150, 0, 20, #__bar_Vertical|#__bar_Inverted) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 5)
    
    Define *w1, *w2
    *w1 = Progress(0, 0, 0, 0,0, 10) : AddElement(*List()) : *List() = Widget() 
    SetState(Widget(), 5)
    *w2 = Progress(0, 0, 0, 0,0, 20) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 10)
    *w1 = Splitter(0, 0, 0, 0, *w1, *w2) : AddElement(*List()) : *List() = Widget()
    *w2 = Progress(0, 0, 0, 0,0, 30) : AddElement(*List()) : *List() = Widget()
    SetState(Widget(), 15)
    Splitter(320+155, 5, 150, 150, *w1, *w2, #__bar_Vertical) : AddElement(*List()) : *List() = Widget()
    
    ;     Widget() = Button_3
    ;     Widget()\height = 30
    ;     Widget()\width = 30
    ;     Widget()\bar\button[#__b_3]\len = 30
    ;     Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----
; EnableXP