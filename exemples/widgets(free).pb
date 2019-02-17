IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *window.Widget_S
  
  Procedure.i _Free(*This.Widget_S)
    Protected Result.i
    
    With *This
      If *This
        If \s
          If \s\v
            FreeStructure(\s\v) : \s\v = 0
          EndIf
          If \s\h
            FreeStructure(\s\h)  : \s\h = 0
          EndIf
          FreeStructure(\s) : \s = 0
        EndIf
        
        If \Box
          FreeStructure(\Box) : \Box = 0
        EndIf
        
        If \Image
          FreeStructure(\Image) : \Image = 0
        EndIf
        
        If \Image[1]
          FreeStructure(\Image[1]) : \Image[1] = 0
        EndIf
        
        If \Text
          FreeStructure(\Text) : \Text = 0
        EndIf
        
        FreeStructure(*This) 
        *Value\Active = 0
        *Value\Focus = 0
        
        If \Parent And ListSize(\Parent\Childrens()) : \Parent\CountItems - 1
          ChangeCurrentElement(\Parent\Childrens(), Adress(*This))
          Result = DeleteElement(\Parent\Childrens())
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This.Widget_S
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Static *After
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Resize(*window, #PB_Ignore, #PB_Ignore, Width, Height)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        *This = at(*window, MouseX, MouseY)
        
        Select EventType
            Case #PB_EventType_LeftButtonDown
              ; *After = _GetPosition(*This, #PB_List_After)
              
              *This = Free(*This)
              Repaint = 1
              ;*This = at(*window, MouseX, MouseY)
        
            Case #PB_EventType_LeftButtonUp
              Debug "free "+ *This; SetPosition(*This, #PB_List_Before, *After)
              Debug CountItems(*window) ; ListSize(*window\Childrens())
              Repaint = 1
          EndSelect
          
          
         If *This
          ; Debug *This
          ; Repaint | CallBack(*This, EventType(), MouseX, MouseY)
         EndIf
        
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
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 580, 550, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *window = openlist(0, 1)
      
      Window(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      Window(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      Window(20, 150, 280, 200, "Window_3") ;, #PB_Flag_AnchorsGadget)
      
      Panel(100, 20, 80, 80) : CloseList() ; "Button_1");, #PB_Flag_AnchorsGadget)
      ScrollArea(130, 80, 80, 80, 0,100,100) : CloseList() ; "Button_2");, #PB_Flag_AnchorsGadget)
      ScrollArea(70, 80, 80, 80, 0,100,100) : CloseList() ; "Button_3") ;, #PB_Flag_AnchorsGadget)
      
      
      
      BindGadgetEvent(1, @Canvas_CallBack())
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
        ;         ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 0ff-0
; EnableXP