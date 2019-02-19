IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, x=10,y=10
  Global NewMap Widgets.i()
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This.Widget_S
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Protected *Window.Widget_s = GetGadgetData(Canvas)
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Resize(*Window, #PB_Ignore, #PB_Ignore, Width-2, Height-2)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        *This  = at(*Window, MouseX, MouseY)
        If *This
          Repaint | CallBack(*This, EventType, MouseX, MouseY)
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
  
  Procedure.i _SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
    ProcedureReturn SetAlignment(*This.Widget_S, Mode.i, Type.i)
    With *This
      Select Type
        Case 1 ; widget
        Case 2 ; text
        Case 3 ; image
      EndSelect
      
      \Align.Align_S = AllocateStructure(Align_S)
      
      \Align\Right = 0
      \Align\Bottom = 0
      \Align\Left = 0
      \Align\Top = 0
      \Align\Horizontal = 0
      \Align\Vertical = 0
      
      If Mode&#PB_Right=#PB_Right
        \Align\x = (\Parent\Width-\Parent\bs*2 - (\x-\Parent\x-\Parent\bs)) - \Width
        \Align\Right = 1
      EndIf
      If Mode&#PB_Bottom=#PB_Bottom
        \Align\y = (\Parent\height-\Parent\bs*2 - (\y-\Parent\y-\Parent\bs)) - \height
        \Align\Bottom = 1
      EndIf
      If Mode&#PB_Left=#PB_Left
        \Align\Left = 1
        If Mode&#PB_Right=#PB_Right
          \Align\x1 = (\Parent\Width - \Parent\bs*2) - \Width
        EndIf
      EndIf
      If Mode&#PB_Top=#PB_Top
        \Align\Top = 1
        If Mode&#PB_Bottom=#PB_Bottom
          \Align\y1 = (\Parent\height -\Parent\bs*2)- \height
        EndIf
      EndIf
      
      If Mode&#PB_Center=#PB_Center
        \Align\Vertical = 1
        \Align\Horizontal = 1
      EndIf
      If Mode&#PB_Vertical=#PB_Vertical
        \Align\Vertical = 1
      EndIf
      If Mode&#PB_Horizontal=#PB_Horizontal
        \Align\Horizontal = 1
      EndIf
      
      Resize(\Parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    EndWith
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo docking widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
       
       Define *w.Widget_s = Open(0, 10, 10, 580, 600-50, "")
      Define canvas = *w\Canvas\Gadget
      
      ;Widgets(Str(50)) = Window(50, 50, 280, 200, "Demo dock widgets", #PB_Flag_AnchorsGadget)
      Widgets(Str(0)) = Container(50, 50, 280, 200, #PB_Flag_AnchorsGadget);#PB_Flag_AutoSize)
      
      Widgets(Str(5)) = Button(91, 21, 280-2-182, 200-2-42, "Full_"+Str(5))
      Widgets(Str(1)) = Button(0, 21, 91, 200-2-42, "Left_"+Str(1))
      Widgets(Str(2)) = Button(0, 0, 280-2, 21, "Top_"+Str(2))
      Widgets(Str(3)) = Button(280-2-91, 21, 91, 200-2-42, Str(3)+"_Right")
      Widgets(Str(4)) = Button(0, 200-2-21, 280-2, 21, Str(4)+"_Bottom")
      
      CloseList()
      
      _SetAlignment(Widgets(Str(5)), #PB_Full)
      _SetAlignment(Widgets(Str(1)), #PB_Top|#PB_Bottom)
      _SetAlignment(Widgets(Str(2)), #PB_Left|#PB_Right)
      _SetAlignment(Widgets(Str(3)), #PB_Top|#PB_Bottom|#PB_Right)
      _SetAlignment(Widgets(Str(4)), #PB_Left|#PB_Bottom|#PB_Right)
      
      BindGadgetEvent(canvas, @Canvas_CallBack())
      ReDraw(canvas)
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Define direction = 1
  Define Width, Height
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Width = 100
           direction = 1
        EndIf
        If Width = Width(Root())-100
          direction =- 1
        EndIf
;         
        Width + direction
        Height + direction
        
        If Resize(Widgets(Str(0)), #PB_Ignore, #PB_Ignore, Width, Height)
          ; SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(*Bar_0, #PB_Bar_Direction)))
        EndIf
        ReDraw(Display())
    
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Width = Width(Widgets(Str(0)))
            Height = Height(Widgets(Str(0)))
            
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 10)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 48f----
; EnableXP