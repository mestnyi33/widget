IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *w._S_widget=AllocateStructure(_S_widget)
  Global *Bar_0._S_widget=AllocateStructure(_S_widget)
  Global *Bar_1._S_widget=AllocateStructure(_S_widget)
  Global *Scroll_1._S_widget=AllocateStructure(_S_widget)
  Global *Scroll_2._S_widget=AllocateStructure(_S_widget)
  Global *Scroll_3._S_widget=AllocateStructure(_S_widget)
  Global *child_0._S_widget=AllocateStructure(_S_widget)
  Global *child_1._S_widget=AllocateStructure(_S_widget)
  Global *child_2._S_widget=AllocateStructure(_S_widget)
  Global *ScrollArea._S_widget=AllocateStructure(_S_widget)
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resize(*w, x, y, Width-x*2, Height-y*2)  
        Repaint = 1 
    EndSelect
    
    Protected *this = from(*w, mouseX, mouseY)
    Repaint | CallBack(*this, EventType, mouseX,mouseY)
    
    If Repaint
      ReDraw()
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
      
;       CanvasGadget(1, 10,10, 380, 350, #PB_Canvas_Keyboard)
;       SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      *w=open(0,10,10, 380, 350)
      
      *Scroll_1._S_widget  = Image(0, 0, 0, 0, 0); : SetState(*Scroll_1, 1) 
      *Scroll_2._S_widget  = ScrollArea(0, 0, 0, 0, 250,250) : closelist() : SetState(*Scroll_2\scroll\h, 45)
      *Scroll_3._S_widget  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*Scroll_3, 50)
      
      *Bar_0 = Splitter(10, 10, 360,  330, *Scroll_1, *Scroll_2)
      *Bar_1 = Splitter(10, 10, 360,  330, *Scroll_3, *Bar_0, #PB_Splitter_Vertical)
      
      *child_0._S_widget  = Scroll(10, 10, 80, 20, 0,200,100) : SetState(*child_0, 20)
      *child_1._S_widget  = Progress(10, 40, 80, 20, 0,200,100) : SetState(*child_1, 50)
      *child_2._S_widget  = Scroll(10, 70, 80, 20, 0,200,100) : SetState(*child_2, 80)
      
      *ScrollArea._S_widget  = ScrollArea(50, 50, 150, 150, 250,250) : closelist() : SetParent(*ScrollArea, *Scroll_2)
      
      SetParent(*child_0, *ScrollArea)
      SetParent(*child_1, *ScrollArea)
      SetParent(*child_2, *ScrollArea)
      
      ;
      ;   SetAttribute(*Scroll_1, #PB_DisplayMode, 0)
        
;       SetAttribute(*Bar_1, #PB_Splitter_FirstFixed, 120)
;       SetAttribute(*Bar_1, #PB_Splitter_SecondFixed, 80)
;       
;       SetAttribute(*Bar_1, #PB_Splitter_FirstMinimumSize, 120)
;       SetAttribute(*Bar_1, #PB_Splitter_SecondMinimumSize, 80)
;       
;       SetAttribute(*Bar_0, #PB_Splitter_FirstMinimumSize, 100)
;       SetAttribute(*Bar_0, #PB_Splitter_SecondMinimumSize, 50)
      
;       SetState(*Bar_0, 25)
      
      BindGadgetEvent(_gadget(), @Canvas_CallBack())
      ReDraw()
      
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
; Folding = ----
; EnableXP