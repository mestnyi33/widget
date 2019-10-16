IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *window
  
  Procedure.i GetIndex(*This._S_widget, Position.i)
    Protected Result.i
    
    With *This
      If *This And \Parent
        Select Position
          Case #PB_List_First  : Result = FirstElement(\Parent\Childrens())
          Case #PB_List_Before : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = PreviousElement(\Parent\Childrens())
          Case #PB_List_After  : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = NextElement(\Parent\Childrens())
          Case #PB_List_Last   : Result = LastElement(\Parent\Childrens())
        EndSelect
        Result = ListIndex(\Parent\Childrens())
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetIndex(*This._S_widget, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
    With *This\Parent
      If *This And *This\Parent
;         ForEach \Parent\Childrens()
;           If *This = \Parent\Childrens()
;             Break
;           EndIf
;         Next
        ChangeCurrentElement(\Childrens(), Adress(*This))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\Childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\Childrens()) : MoveElement(\Childrens(), #PB_List_After, Adress(\Childrens()))
            Case #PB_List_After  : NextElement(\Childrens())     : MoveElement(\Childrens(), #PB_List_Before, Adress(\Childrens()))
            Case #PB_List_Last   : MoveElement(\Childrens(), #PB_List_Last)
          EndSelect
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\Childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\Childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
      EndIf 
    EndWith
    
  EndProcedure
  
  
  ;-
  ; Получить Z-позицию элемента в окне
  Procedure _GetPosition(*This._S_widget, Position=#PB_Default)
    Protected Result.i
    
    With *This
      If *This And \Parent
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        
        Select Position
          Case #PB_List_First  : Result = FirstElement(\Parent\Childrens())
          Case #PB_List_Before : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = PreviousElement(\Parent\Childrens())
          Case #PB_List_After  : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = NextElement(\Parent\Childrens())
          Case #PB_List_Last   : Result = LastElement(\Parent\Childrens())
          Default              : Result = Adress(*This)
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i _SetPosition(*This._S_widget, Position, *Widget_2 =- 1) ; Ok
    
    With *This
      If *This And \Parent
        ;Debug "Position "+\text\string
        
;         ForEach \Parent\Childrens()
;           If *This = \Parent\Childrens()
;             Break
;           EndIf
;         Next
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        ;Debug "SetPosition "+\Parent\Childrens()\text\string +" "+ ListIndex(\Parent\Childrens())
        
        ChangeCurrentElement(\Parent\Childrens(), Adress(*This))
        Debug *This 
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\Parent\Childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\Parent\Childrens()) : MoveElement(\Parent\Childrens(), #PB_List_After, Adress(\Parent\Childrens()))
            Case #PB_List_After  : NextElement(\Parent\Childrens())     : MoveElement(\Parent\Childrens(), #PB_List_Before, Adress(\Parent\Childrens()))
            Case #PB_List_Last   : MoveElement(\Parent\Childrens(), #PB_List_Last)
          EndSelect
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\Parent\Childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\Parent\Childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
        ;\Parent\Childrens()\Adress = @\Parent\Childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  ; Позиционирование элементов (Positioning This)
  
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This._S_widget
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *window = GetGadgetData(Canvas)
    Static *After
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Resize(*window, #PB_Ignore, #PB_Ignore, Width, Height)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        *This = from(*window, MouseX, MouseY)
        
        If *This
          Repaint | CallBack(*This, EventType(), MouseX, MouseY)
          
          Select EventType
            Case #PB_EventType_LeftButtonDown
              *After = _GetPosition(*This, #PB_List_After)
              
              _SetPosition(*This, #PB_List_Last)
              Repaint = 1
              
            Case #PB_EventType_LeftButtonUp
              _SetPosition(*This, #PB_List_Before, *After)
              Repaint = 1
          EndSelect
        EndIf
        
    EndSelect
    
    If Repaint 
      ReDraw(*window)
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
;       *window = Form(150, 50, 280, 200, "Window_1")
;       SetGadgetData(1, *window)
      
      ;       Widgets(Hex(1)) = Form(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      ;       Widgets(Hex(2)) = Form(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      ;       Widgets(Hex(3)) = Form(20, 150, 280, 200, "Window_3");, #PB_Flag_AnchorsGadget)
      Form(150, 50, 280, 200, "Window_1");, #PB_Flag_AnchorsGadget)
      Form(280, 100, 280, 200, "Window_2");, #PB_Flag_AnchorsGadget)
      Form(20, 150, 280, 200, "Window_3") ;, #PB_Flag_AnchorsGadget)
      
      Panel(100, 20, 80, 80) : CloseList() ; "Button_1");, #PB_Flag_AnchorsGadget)
      ScrollArea(130, 80, 80, 80, 0,100,100) : CloseList() ; "Button_2");, #PB_Flag_AnchorsGadget)
      ScrollArea(70, 80, 80, 80, 0,100,100) : CloseList() ; "Button_3") ;, #PB_Flag_AnchorsGadget)
      
      ;Widgets(Hex(2)) = Button(91, 21, 280-2-182, 200-2-42, "Full_"+Str(5))
      
      CloseList()
      
      
      BindGadgetEvent(1, @Canvas_CallBack())
      
      CloseGadgetList()
      
      ReDraw(*window)
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----0--
; EnableXP