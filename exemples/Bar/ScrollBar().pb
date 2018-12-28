IncludePath "../../"
XIncludeFile "module_bar.pbi"
;
; Module name   : ScrollBar
; Author        : mestnyi
; Last updated  : Sep 20, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

DeclareModule ScrollBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget Extends Bar::Coordinate_S
    Type.i
    fSize.i
    bSize.i
    
    Canvas.Canvas
    Color.Bar::Color_S
    *Bar.Bar::Bar_S
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Pagelength.i, Flag.i=0)
  
EndDeclareModule

Module ScrollBar
  
  ;- PROCEDURE
  
  Procedure Draw(*This.Gadget)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        
        If \fSize
          DrawingMode(#PB_2DDrawing_Default)
          If \Bar\Vertical
            Line(\X[1],\Y[1]-1,\Width,1,\Color\Frame)
            Line(\X[1]+\Width[1],\Y[1],1,\Height,\Color\Frame)
            Line(\X[1],\Y[1]+\Height[1],\Width,1,\Color\Frame)
          Else
            Line(\X[1]-1,\Y[1],1,\Height,\Color\Frame)
            Line(\X[1],\Y[1]+\Height[1],\Width,1,\Color\Frame)
            Line(\X[1]+\Width[1],\Y[1],1,\Height,\Color\Frame)
          EndIf
        EndIf
        
        Bar::Draw(\Bar)
        StopDrawing()
      EndIf
    EndWith  
  EndProcedure
  
  Procedure Canvas_Events(EventGadget.i, EventType.i)
    Protected WheelDelta.i, Mouse_X.i, Mouse_Y.i, *This.Gadget = GetGadgetData(EventGadget)
    
    With *This
      \Canvas\Window = EventWindow()
      Mouse_X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      Mouse_Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      WheelDelta = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_WheelDelta)
      
      Select EventType
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
          
            ; Inner coordinae
          If \Bar\Vertical
            \X[2]=\bSize
            \Y[2]=\bSize*2
            \Width[2] = \Width-\bSize*3
            \Height[2] = \Height-\bSize*4
          Else
            \X[2]=\bSize*2
            \Y[2]=\bSize
            \Width[2] = \Width-\bSize*4
            \Height[2] = \Height-\bSize*3
          EndIf
          
          ; Frame coordinae
          \X[1]=\X[2]-\fSize
          \Y[1]=\Y[2]-\fSize
          \Width[1] = \Width[2]+\fSize*2
          \Height[1] = \Height[2]+\fSize*2
          
         ; Bar::Resize(\Bar, \X[2], \Y[2], \Width[2], \Height[2]) : Draw(*This)
      EndSelect
      
      If Bar::CallBack(\Bar, EventType, Mouse_X, Mouse_Y) 
        Draw(*This)
        If \Bar\Change 
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
          \Bar\Change = 0
        EndIf
      EndIf
    EndWith
    
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
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Bar::SetAttribute(*This\Bar, Attribute, Value)
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum    : Result = \Bar\Min
        Case #PB_ScrollBar_Maximum    : Result = \Bar\Max
        Case #PB_ScrollBar_PageLength : Result = \Bar\Page\len
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Bar::SetState(*This\Bar, State) : Draw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
    ProcedureReturn Bar::GetState(*This\Bar)
  EndProcedure
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Pagelength.i, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected *This.Gadget = AllocateStructure(Gadget)
    
    If *This
      With *This
        \Type = #PB_GadgetType_ScrollBar
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        
        \fSize = 0
        \bSize = \fSize
        
        ; Inner coordinae
        If Flag&#PB_ScrollBar_Vertical
          \X[2]=\bSize
          \Y[2]=\bSize*2
          \Width[2] = \Width-\bSize*3
          \Height[2] = \Height-\bSize*4
        Else
          \X[2]=\bSize*2
          \Y[2]=\bSize
          \Width[2] = \Width-\bSize*4
          \Height[2] = \Height-\bSize*3
        EndIf
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize
        \Y[1]=\Y[2]-\fSize
        \Width[1] = \Width[2]+\fSize*2
        \Height[1] = \Height[2]+\fSize*2
        
        \Color\Frame = $C0C0C0
        
        \Bar = Bar::Bar(0, 0, \Width[2], \Height[2], Min, Max, PageLength, Flag, 0)
        \Bar\ArrowType[1]=1 
        \Bar\ArrowType[2]=1
        \Bar\ArrowSize[1]=6 
        \Bar\ArrowSize[2]=6
        
        Draw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure v_GadgetCallBack()
    ScrollBar::SetState(13, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetGadgetState(3, ScrollBar::GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    ScrollBar::SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    SetGadgetState(2, ScrollBar::GetState(EventGadget()))
  EndProcedure
  
  Define Flag
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux ; 
    LoadFont(0, "monospace", 7)
    SetGadgetFont(-1,FontID(0))
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS ; 
    LoadFont(0, "monospace", 10)
    SetGadgetFont(-1,FontID(0))
  CompilerEndIf
  
  ; Flag = Bar::#PB_ScrollBar_NoButtons
  
  If OpenWindow(0, 0, 0, 605, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget       (-1,  10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (2,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (2,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (3, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (3, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    TextGadget       (-1,  300+10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBar::Gadget  (12,  300+10, 42, 250,  20, 30, 100+1, 30, Flag)
    ScrollBar::SetState   (12,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBar::Gadget  (13, 300+270, 10,  25, 120 ,0, 300+1, 50, #PB_ScrollBar_Vertical|Flag)
    ScrollBar::SetState   (13, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    BindGadgetEvent(2,@h_GadgetCallBack())
    BindGadgetEvent(12,@h_CallBack(), #PB_EventType_Change)
    BindGadgetEvent(3,@v_GadgetCallBack())
    BindGadgetEvent(13,@v_CallBack(), #PB_EventType_Change)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------
; EnableXP