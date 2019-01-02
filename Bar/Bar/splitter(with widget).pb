;IncludePath "../../"
XIncludeFile "module_bar(with splitter).pb"

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
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      ;Debug *Scroll_1\width
      
      Draw(*Scroll_1)
      Draw(*Scroll_2)
      Draw(*Scroll_3)
      Draw(*Bar_0)
      Draw(*Bar_1)
      
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
        Repaint | Resize(*Bar_0, x, y, Width-x*2, Height-y*2)                                          ;, *Scroll\h)
                                                                                                       ;  Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
        
    EndSelect
    
    Repaint | CallBack(*Bar_0, EventType, mouseX,mouseY)
    Repaint | CallBack(*Bar_1, EventType, mouseX,mouseY)
    
    If *Bar_1\Change
      Bar::Resize(*Scroll_3, *Bar_1\First\x, *Bar_1\First\y, *Bar_1\First\width, *Bar_1\First\height)
    EndIf
    
    If Not (*Bar_0\at)
      Select EventType
        Case #PB_EventType_LeftButtonDown
          ;SetAttribute(*Bar_0, #PB_ScrollBar_Inverted, *Bar_0\Inverted!1)
          ;Debug "#PB_EventType_LeftButtonDown *Scroll\h\Inverted " + *Bar_0\Inverted
          
          Repaint = 1
      EndSelect
    EndIf
    
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
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 400, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   365, 390,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 350, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Scroll_1.Bar_S  = Progress(0, 0, 0, 0, 0,0,0)
      *Scroll_2.Bar_S  = Progress(0, 0, 0, 0, 0,0,0)
      *Scroll_3.Bar_S  = Progress(0, 0, 0, 0, 0,0,0)
      
      *Bar_0 = Splitter(10, 10, 360,  330, *Scroll_1, *Scroll_2);, #PB_Splitter_Vertical)
      *Bar_1 = Splitter(10, 10, 360,  330, -1, *Bar_0, #PB_Splitter_Vertical)
      
      Bar::Resize(*Scroll_3, *Bar_1\First\x, *Bar_1\First\y, *Bar_1\First\width, *Bar_1\First\height)
      BindGadgetEvent(1, @Canvas_CallBack())
      
      ;SetState(*Bar_0, 25)
      CloseGadgetList()
      
      ReDraw(1)
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
          If WidgetEventType() = #PB_EventType_Change
            PostEvent(#PB_Event_Gadget, 0, 1)
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            value = GetState(*Bar_0)
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEventType() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_ScrollBar_Direction)))
        EndIf
        
        ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----
; EnableXP