IncludePath "../"
XIncludeFile "widgets.pbi"

;
; Module name   : TrackBar
; Author        : mestnyi
; Last updated  : Dec 29, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule TrackBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget Extends Widget::Coordinate_S
    Canvas.Canvas
    *Bar.Widget::Bar_S
  EndStructure
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Flag.i=0)
  
EndDeclareModule

Module TrackBar
  
  ;- PROCEDURE
  Procedure Draw(*This.Gadget)
    With *This\Bar
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        Widget::Draw(*This\Bar)
        StopDrawing()
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure Canvas_Events(EventGadget.i, EventType.i)
    Protected Repaint.i, Mouse_X.i, Mouse_Y.i, *This.Gadget = GetGadgetData(EventGadget)
    
    If *This 
      With *This
        \Canvas\Window = EventWindow()
        Mouse_X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
        Mouse_Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
        
        Select EventType
          Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            Widget::Resize(*This\Bar, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
            Repaint = 1
       EndSelect
        
        Repaint | Widget::CallBack(\Bar, EventType, Mouse_X, Mouse_Y)
        
        If \Bar\Focus
          \Bar\Color[3]\State = 2
        Else
          \Bar\Color[3]\State = 0
        EndIf
        
        If Repaint 
          If \Bar\Change 
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
          EndIf
          
          Draw(*This)
        EndIf
      EndWith
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
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_TrackBar_Minimum : Attribute = Widget::#PB_Bar_Minimum
        Case #PB_TrackBar_Maximum : Attribute = Widget::#PB_Bar_Maximum
      EndSelect
      
      If Widget::SetAttribute(*This\Bar, Attribute, Value)
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_TrackBar_Minimum : Attribute = Widget::#PB_Bar_Minimum
        Case #PB_TrackBar_Maximum : Attribute = Widget::#PB_Bar_Maximum
      EndSelect
      
      Result = Widget::GetAttribute(*This\Bar, Attribute)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Widget::SetState(*This\Bar, State)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    ProcedureReturn Widget::GetState(*This\Bar)
  EndProcedure
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Flag.i=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        
        \Bar = Widget::Track(0,0, Width, Height, Min, Max, Flag)
        
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
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
    TrackBar::SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetWindowTitle(EventWindow(), Str(TrackBar::GetState(EventGadget())))
    SetGadgetState(2, TrackBar::GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    TrackBar::SetState(11, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    SetGadgetState(1, TrackBar::GetState(EventGadget()))
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605, 200, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget    (-1, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(0, 10,  40, 250, 20, 0, 10000)
    SetGadgetState(0, 5000)
    TextGadget    (-1, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    TrackBarGadget(1, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
    SetGadgetState(1, 3000)
    TextGadget    (-1,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(2, 270, 10, 20, 170, 100, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(2, 8000)
    
    TextGadget    (-1, 300+10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBar::Gadget(10, 300+10,  40, 250, 20, 0, 10000)
    TrackBar::SetState(10, 5000)
    TextGadget    (-1, 300+10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    TrackBar::Gadget(11, 300+10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
    TrackBar::SetState(11, 3000)
    TextGadget    (-1,  300+90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBar::Gadget(12, 300+270, 10, 20, 170, 100, 10000, #PB_TrackBar_Vertical)
    TrackBar::SetState(12, 8000)
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(11,@h_CallBack(), #PB_EventType_Change)
    BindGadgetEvent(2,@v_GadgetCallBack())
    BindGadgetEvent(12,@v_CallBack(), #PB_EventType_Change)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------
; EnableXP