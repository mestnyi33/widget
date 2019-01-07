IncludePath "../../"
XIncludeFile "module_bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Bar
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *Bar_0.Bar_S=AllocateStructure(Bar_S)
  Global *Bar_1.Bar_S=AllocateStructure(Bar_S)
  Global *Scroll_1.Bar_S=AllocateStructure(Bar_S)
  Global *Scroll_2.Bar_S=AllocateStructure(Bar_S)
  Global *Scroll_3.Bar_S=AllocateStructure(Bar_S)
  
  Procedure ReDraw(Gadget.i)
;     With *Bar_1
;       If (\Change Or \Resize)
;         Bar::Resize(\First, \x[1], \y[1], \width[1], \height[1])
;         Bar::Resize(\Second, \x[2], \y[2], \width[2], \height[2])
;       EndIf
;     EndWith
;     
;     With *Bar_0
;       If (\Change Or \Resize)
;         Bar::Resize(\First, \x[1], \y[1], \width[1], \height[1])
;         Bar::Resize(\Second, \x[2], \y[2], \width[2], \height[2])
;       EndIf
;     EndWith
    
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Bar_1)
      Draw(*Bar_0)
      
;       Draw(*Scroll_1)
;       Draw(*Scroll_2)
;       Draw(*Scroll_3)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resize(*Bar_1, x, y, Width-x*2, Height-y*2)  
        Repaint = 1 
    EndSelect
    
    Repaint | CallBack(*Bar_0, EventType, mouseX,mouseY)
    Repaint | CallBack(*Bar_1, EventType, mouseX,mouseY)
    
    If Repaint
      ReDraw(1)
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
    If OpenWindow(0, 0, 0, 400, 400, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   365, 390,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 350, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Scroll_1.Bar_S  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*Scroll_1, 50)
      *Scroll_2.Bar_S  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*Scroll_2, 50)
      *Scroll_3.Bar_S  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*Scroll_3, 50) 
      
      *Bar_0 = Splitter(10, 10, 360,  330, *Scroll_1, *Scroll_2)
      *Bar_1 = Splitter(10, 10, 360,  330, *Scroll_3, *Bar_0, #PB_Splitter_Vertical)
      
;       SetAttribute(*Bar_1, #PB_Splitter_FirstFixed, 120)
;       SetAttribute(*Bar_1, #PB_Splitter_SecondFixed, 80)
;       
;       SetAttribute(*Bar_1, #PB_Splitter_FirstMinimumSize, 120)
;       SetAttribute(*Bar_1, #PB_Splitter_SecondMinimumSize, 80)
;       
;       SetAttribute(*Bar_0, #PB_Splitter_FirstMinimumSize, 100)
;       SetAttribute(*Bar_0, #PB_Splitter_SecondMinimumSize, 50)
      
;       SetState(*Bar_0, 25)
      
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
        If IsStart(*Bar_0)
          direction = 1
        EndIf
        If IsStop(*Bar_0)
          direction =- 1
        EndIf
        
        value + direction
        
        If SetState(*Bar_0, value)
          ;PostEvent(#PB_Event_Gadget, 0, 1, -1)
          ReDraw(1)
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 10
            value = GetState(*Bar_0)
            If GetGadgetState(10)
              AddWindowTimer(0, 1, 10)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEventType() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_Bar_Direction)))
        EndIf
        
        ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 16
; Folding = -8---
; EnableXP