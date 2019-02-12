IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *window, NewMap Widget.i()
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This.Widget_S
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Resize(*window, #PB_Ignore, #PB_Ignore, Width, Height)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        *This = at(*window, MouseX, MouseY)
        
        ;  If *This
        ;           If *This\Text
        ;             Debug " "+*This\Type +" "+ *This\Text\String +" "+ *This
        ;           Else
        ;             Debug " "+*This\Type +" "+ *This
        ;           EndIf
        
        Repaint | CallBack(*This, EventType(), MouseX, MouseY)
        ; EndIf
        
    EndSelect
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
    
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 900, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 890,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 880, 550, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *window = openlist(0, 1)
      Define editable ;= #PB_Flag_AnchorsGadget
      
      If *window
        Widget(Hex(100)) = Window(520, 140, 200+2, 260+26+2, "Window_100", #PB_Window_ScreenCentered) : SetData(Widget(Hex(100)), 100)
        Widget(Hex(500)) = Panel(0,0, 200+2, 260+26+2)
        AddItem(Widget(Hex(500)),-1,"Panel")
        
        Widget(Hex(101)) = Button(10, 10, 180, 20, "101 Active window - 0") : SetData(Widget(Hex(101)), 101)
        Widget(Hex(102)) = Button(10, 35, 180, 20, "102 Focus gadget - 1") : SetData(Widget(Hex(102)), 102)
        Widget(Hex(103)) = Button(10, 60, 180, 20, "103 Focus gadget - 2") : SetData(Widget(Hex(103)), 103)
        
        Widget(Hex(104)) = Button(10, 85+10, 180, 20, "104 Active window - 10") : SetData(Widget(Hex(104)), 104)
        Widget(Hex(105)) = Button(10, 85+35, 180, 20, "105 Focus gadget - 11") : SetData(Widget(Hex(105)), 105)
        Widget(Hex(106)) = Button(10, 85+60, 180, 20, "106 Focus gadget - 12") : SetData(Widget(Hex(106)), 106)
        
        Widget(Hex(107)) = Button(10, 85+85+10, 180, 20, "107 Active window - 20") : SetData(Widget(Hex(107)), 107)
        Widget(Hex(108)) = Button(10, 85+85+35, 180, 20, "108 Focus gadget - 21") : SetData(Widget(Hex(108)), 108)
        Widget(Hex(109)) = Button(10, 85+85+60, 180, 20, "109 Focus gadget - 22") : SetData(Widget(Hex(109)), 109)
        CloseList()
        
        Widget(Hex(0)) = Window(100, 100, 200, 200, "Window_0", #PB_Window_SystemMenu) : SetData(Widget(Hex(0)), 0)
        Widget(Hex(1)) = String(10, 10, 180, 85, "String_1") : SetData(Widget(Hex(1)), 1)
        Widget(Hex(2)) = String(10, 105, 180, 85, "String_2") : SetData(Widget(Hex(2)), 2) 
        
        Widget(Hex(10)) = Window(160, 120, 200, 200, "Window_10", #PB_Window_SystemMenu) : SetData(Widget(Hex(10)), 10)
        Widget(Hex(11)) = String(10, 10, 180, 85, "String_11") : SetData(Widget(Hex(11)), 11)
        Widget(Hex(12)) = String(10, 105, 180, 85, "String_12") : SetData(Widget(Hex(12)), 12)
        
        Widget(Hex(20)) = Window(220, 140, 200, 200, "Window_20", #PB_Window_SystemMenu) : SetData(Widget(Hex(20)), 20)
        Widget(Hex(21)) = String(10, 10, 180, 85, "String_21") : SetData(Widget(Hex(21)), 21)
        Widget(Hex(22)) = String(10, 105, 180, 85, "String_22") : SetData(Widget(Hex(22)), 22)

        
; ;         Window(150, 50, 280, 200, "Window_1", editable)
; ;         Window(280, 100, 280, 200, "Window_2", editable)
; ;         Scroll(50, 20, 180, 80, 0, 100, 30, editable)
; ;         
; ;         Window(20, 150, 280, 200, "Window_3", editable)
; ;         
; ;         Container(30, 30, 220, 140)
; ;         Container(30, 30, 220, 140)
; ;         
; ;         Button(100, 20, 80, 80, "Button_1", editable)
; ;         Button(130, 80, 80, 80, "Button_2", editable)
; ;         Button(70, 80, 80, 80, "Button_3", editable)
; ;         
; ;         CloseList()
; ;         CloseList()
      EndIf
      
      BindGadgetEvent(1, @Canvas_CallBack())
      
      CloseGadgetList()
      
      ReDraw(1)
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  direction = 1
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        ;         If IsStart(*Bar_0)
        ;           direction = 1
        ;         EndIf
        ;         If IsStop(*Bar_0)
        ;           direction =- 1
        ;         EndIf
        ;         
        ;         value + direction
        ;         
        ;         If SetState(*Bar_0, value)
        ;           ;PostEvent(#PB_Event_Gadget, 0, 1, -1)
        ;           ReDraw(1)
        ;         EndIf
        
      Case #PB_Event_Gadget
        
        Select EventType()
          Case #PB_EventType_LeftClick
            Debug ""
;           Debug  GetData(at(*window, GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX), GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)));""
;           Debug  GetData(EventWidget());""
          
          Select GetData(at(*window, GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX), GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)))
            Case 101
              SetActive(Widget(Hex(0)))
            Case 102
              SetActive(Widget(Hex(1)))
            Case 103
              SetActive(Widget(Hex(2)))
              
            Case 104
              SetActive(Widget(Hex(10)))
            Case 105
              SetActive(Widget(Hex(11)))
            Case 106
              SetActive(Widget(Hex(12)))
              
            Case 107
              SetActive(Widget(Hex(20)))
              
            Case 108
              SetActive(Widget(Hex(21)))
            Case 109
              SetActive(Widget(Hex(22)))
          EndSelect
          
                   ReDraw(EventGadget())
        
      EndSelect
      
        ;         Select EventGadget()
        ;           Case 10
        ;             value = GetState(*Bar_0)
        ;             If GetGadgetState(10)
        ;               AddWindowTimer(0, 1, 10)
        ;             Else
        ;               RemoveWindowTimer(0, 1)
        ;             EndIf
        ;         EndSelect
        ;         
        ;         ; Get interaction with the scroll bar
        ;         CallBack(*Bar_0, EventType())
        ;         
        ;         If WidgetEventType() = #PB_EventType_Change
        ;           SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_Bar_Direction)))
        ;         EndIf
        ;         
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP