IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *window
  
  ;-
  ; Получить Z-позицию элемента в окне
  Procedure GetPosition(*This.Widget_S, Position=#PB_Default)
    Protected Result.i
    
;     Select Position
;       Case #PB_List_First  : Result = FirstElement(*List())
;       Case #PB_List_Before : ChangeCurrentElement(*List(), *This\adress) : Result = PreviousElement(*List())
;       Case #PB_List_After  : ChangeCurrentElement(*List(), *This\adress) : Result = NextElement(*List())
;       Case #PB_List_Last   : Result = LastElement(*List())
;       Default
;         ProcedureReturn *This\adress
;     EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  ; Позиционирование элементов (Positioning This)
  
  
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
        
        If *This
          Repaint | CallBack(*This, EventType(), MouseX, MouseY)
          
          Select EventType
            Case #PB_EventType_LeftButtonDown
              ;             Protected *First = FirstElement(*list())
              ;             Protected *last = LastElement(*list())
              
              SetPosition(*This, #PB_List_Last)
              Repaint = 1
          EndSelect
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
      
      CanvasGadget(1, 10,10, 580, 550, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *window = openlist(0, 1)
;       *window = Window(150, 50, 280, 200, "Window_1")
;       SetGadgetData(1, *window)
      
      ;       Widgets(Hex(1)) = Window(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      ;       Widgets(Hex(2)) = Window(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      ;       Widgets(Hex(3)) = Window(20, 150, 280, 200, "Window_3");, #PB_Flag_AnchorsGadget)
      Window(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      Window(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      Window(20, 150, 280, 200, "Window_3") ;, #PB_Flag_AnchorsGadget)
      
      Button(100, 20, 80, 80, "Button_1");, #PB_Flag_AnchorsGadget)
      Button(130, 80, 80, 80, "Button_2");, #PB_Flag_AnchorsGadget)
      Button(70, 80, 80, 80, "Button_3") ;, #PB_Flag_AnchorsGadget)
      
      ;Widgets(Hex(2)) = Button(91, 21, 280-2-182, 200-2-42, "Full_"+Str(5))
      
      CloseList()
      
      
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
; Folding = -8--
; EnableXP