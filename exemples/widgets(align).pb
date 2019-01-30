IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global NewMap Widgets.i()
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  
  Procedure ReDraw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      With Widgets()
        ForEach Widgets()
          ;If Canvas = \Canvas\Gadget
          Draw(Widgets())
          ;EndIf
        Next
      EndWith
      
      StopDrawing()
    EndIf
  EndProcedure
  
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
        Resize(Widgets("0"), #PB_Ignore, #PB_Ignore, Width-2, Height-2)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        ; Repaint | CallBack(Widgets("Panel_1"), EventType(), MouseX, MouseY)
        
        With Widgets()
          ForEach Widgets()
            ;           *Widgets = Widgets()
            ;           If *Widgets\Text\String = "Button_0"
            ;            Debug 55
            ;           Else
            Repaint | CallBack(Widgets(), EventType, MouseX, MouseY)
            ;         EndIf
            
          Next
        EndWith
        
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
    ;ProcedureReturn SetAlignment(*This.Widget_S, Mode.i, Type.i)
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
        \Align\x = (\p\Width-\p\bs*2 - (\x-\p\x-\p\bs)) - \Width
        \Align\Right = 1
      EndIf
      If Mode&#PB_Bottom=#PB_Bottom
        \Align\y = (\p\height -\p\bs*2- (\y-\p\y-\p\bs)) - \height
        \Align\Bottom = 1
      EndIf
      If Mode&#PB_Left=#PB_Left
        \Align\Left = 1
        If Mode&#PB_Right=#PB_Right
          \Align\x1 = (\p\Width - \p\bs*2) - \Width
        EndIf
      EndIf
      If Mode&#PB_Top=#PB_Top
        \Align\Top = 1
        If Mode&#PB_Bottom=#PB_Bottom
          \Align\y1 = (\p\height -\p\bs*2)- \height
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
      
      Resize(\p, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    EndWith
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 580, 550, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      Widgets(Str(0)) = Container(50, 50, 280, 200, #PB_Flag_AnchorsGadget)
      
      Widgets(Str(1)) = Button(0, (200-20)/2, 80, 20, "Left_Center_"+Str(1))
      Widgets(Str(2)) = Button((280-80)/2, 0, 80, 20, "Top_Center_"+Str(2))
      Widgets(Str(3)) = Button(280-80, (200-20)/2, 80, 20, Str(3)+"_Center_Right")
      Widgets(Str(4)) = Button((280-80)/2, 200-20, 80, 20, Str(4)+"_Center_Bottom")
      Widgets(Str(5)) = Button(0, 0, 80, 20, "Default_"+Str(5))
      Widgets(Str(6)) = Button(280-80, 0, 80, 20, "Right_"+Str(6))
      Widgets(Str(7)) = Button(280-80, 200-20, 80, 20, "Bottom_"+Str(7))
      Widgets(Str(8)) = Button(0, 200-20, 80, 20, Str(8)+"_Bottom_Right")
      Widgets(Str(9)) = Button((280-80)/2, (200-20)/2, 80, 20, "Bottom_"+Str(9))
      
      CloseList()
      
      _SetAlignment(Widgets(Str(1)), #PB_Vertical)
      _SetAlignment(Widgets(Str(2)), #PB_Horizontal)
      _SetAlignment(Widgets(Str(3)), #PB_Vertical|#PB_Right)
      _SetAlignment(Widgets(Str(4)), #PB_Horizontal|#PB_Bottom)
      _SetAlignment(Widgets(Str(5)), 0)
      _SetAlignment(Widgets(Str(6)), #PB_Right)
      _SetAlignment(Widgets(Str(7)), #PB_Right|#PB_Bottom)
      _SetAlignment(Widgets(Str(8)), #PB_Bottom)
      _SetAlignment(Widgets(Str(9)), #PB_Center)
      
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
; 
; 
; 
; Protected fs=2
;           If \p And \p\clip\x>\x+fs
;             \clip\x = \p\clip\x
;           Else
;             \clip\x = \x+fs
;           EndIf
;           
;           If \p And \p\clip\y>\y+fs
;             \clip\y = \p\clip\y
;           Else
;             \clip\y = \y+fs
;           EndIf
;           
;           If \p And \p\s
;             Protected xl=Bool(Not \p\s\v\Hide And \p\s\v\type = #PB_GadgetType_ScrollBar)*\p\s\v\width
;             Protected yl=Bool(Not \p\s\h\Hide And \p\s\h\type = #PB_GadgetType_ScrollBar)*\p\s\h\height
;           EndIf
;           
;           If \p And \x+\width-fs>\p\clip\x+\p\clip\width-xl
;             \clip\width = \p\clip\width-xl-(\clip\x-\p\clip\x)
;           Else
;             \clip\width = \width-(\clip\x-\x)-fs
;           EndIf
;           
;           If \p And \y+\height-fs>\p\clip\y+\p\clip\height-yl
;             \clip\height = \p\clip\height-yl-(\clip\y-\p\clip\y)
;           Else
;             \clip\height = \height-(\clip\y-\y)-fs
;           EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -0----
; EnableXP