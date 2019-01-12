IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *Bar_0.Widget_S=AllocateStructure(Widget_S)
  Global *Bar_1.Widget_S=AllocateStructure(Widget_S)
  Global *Scroll_1.Widget_S=AllocateStructure(Widget_S)
  Global *Scroll_2.Widget_S=AllocateStructure(Widget_S)
  Global *Scroll_3.Widget_S=AllocateStructure(Widget_S)
  Global *child_0.Widget_S=AllocateStructure(Widget_S)
  Global *child_1.Widget_S=AllocateStructure(Widget_S)
  Global *child_2.Widget_S=AllocateStructure(Widget_S)
  Global *ScrollArea.Widget_S=AllocateStructure(Widget_S)
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure ReDraw(Gadget.i)
;     With *Bar_1
;       If (\Change Or \Resize)
;         Bar::Resize(\s\v, \x[1], \y[1], \width[1], \height[1])
;         Bar::Resize(\s\h, \x[2], \y[2], \width[2], \height[2])
;       EndIf
;     EndWith
;     
;     With *Bar_0
;       If (\Change Or \Resize)
;         Bar::Resize(\s\v, \x[1], \y[1], \width[1], \height[1])
;         Bar::Resize(\s\h, \x[2], \y[2], \width[2], \height[2])
;       EndIf
;     EndWith
    
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Bar_1)
      Draw(*Bar_0)
      
;       Draw(*Scroll_1)
;       Draw(*Scroll_2)
     ;  Draw(*Scroll_3)
      
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
    
    Repaint | CallBack(*Bar_1, EventType, mouseX,mouseY)
;     Repaint | CallBack(*child_0, EventType, mouseX,mouseY)
;     Repaint | CallBack(*child_2, EventType, mouseX,mouseY)
;     Repaint | CallBack(*Bar_0, EventType, mouseX,mouseY)
;     Repaint | CallBack(*Scroll_3, EventType, mouseX,mouseY)
;     Repaint | CallBack(*ScrollArea, EventType, mouseX,mouseY)
;     Repaint | CallBack(*Scroll_1, EventType, mouseX,mouseY)
    
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
      
      *Scroll_1.Widget_S  = Image(0, 0, 0, 0, 0); : SetState(*Scroll_1, 1) 
      *Scroll_2.Widget_S  = ScrollArea(0, 0, 0, 0, 250,250) : SetState(*Scroll_2\s\h, 45)
      *Scroll_3.Widget_S  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*Scroll_3, 50)
      
      *Bar_0 = Splitter(10, 10, 360,  330, *Scroll_1, *Scroll_2)
      *Bar_1 = Splitter(10, 10, 360,  330, *Scroll_3, *Bar_0, #PB_Splitter_Vertical)
      
      *child_0.Widget_S  = Scroll(10, 10, 80, 20, 0,200,100) : SetState(*child_0, 20)
      *child_1.Widget_S  = Progress(10, 40, 80, 20, 0,200,100) : SetState(*child_1, 50)
      *child_2.Widget_S  = Scroll(10, 70, 80, 20, 0,200,100) : SetState(*child_2, 80)
      
      *ScrollArea.Widget_S  = ScrollArea(50, 50, 150, 150, 250,250) : SetParent(*ScrollArea, *Scroll_2)
      
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
; Folding = ----
; EnableXP