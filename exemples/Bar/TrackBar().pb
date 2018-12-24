IncludePath "../../"
XIncludeFile "module_bar.pbi"

;
; Module name   : TrackBar
; Author        : mestnyi
; Last updated  : Aug 7, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule TrackBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Coordinate
    y.i[3]
    x.i[3]
    Height.i[3]
    Width.i[3]
  EndStructure
  
  Structure Mouse
    X.i
    Y.i
    Buttons.i
  EndStructure
  
  Structure Canvas
    Mouse.Mouse
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget Extends Coordinate
    Canvas.Canvas
    
    Text.s[3]
    ImageID.i[3]
    Color.i[3]
    Ticks.b
    
    Image.Coordinate
    
    fSize.i
    bSize.i
    
    *Bar.Bar::Bar_S
    
    Type.i
    InnerCoordinate.Coordinate
    
    Repaint.i
    
    List Items.Gadget()
    List Columns.Gadget()
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
  
  Procedure Re(*This.Gadget)
    If Not *This\Repaint : *This\Repaint = #True : EndIf
    
    Bar::SetAttribute(*This\Bar, #PB_ScrollBar_Maximum, *This\Bar\Max)
    Bar::SetAttribute(*This\Bar, #PB_ScrollBar_PageLength, *This\Bar\Page\Len)
    Bar::Resize(*This\Bar, *This\X[2], *This\Y[2], *This\Width[2], *This\Height[2])
    
  EndProcedure
  
  Global PlotStep.i
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%PlotStep
      Color = TargetColor
    Else
      Color = SourceColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure Draw(*This.Gadget)
    With *This\Bar
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        ; DrawingFont(GetGadgetFont(#PB_Default))
        Protected a=3
        
        If Not \Hide
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X[0],*This\Y[0],*This\Width[0],*This\Height[0],\Color[0]\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
             DrawingMode(#PB_2DDrawing_Default)
            Box(\X[0]+5,\Y[0],a,\Height[0],\Color[0]\Line)
            Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,\height-\Thumb\Pos,\Color[3]\Back[2])
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X[0],*This\Y[0],*This\Width[0],*This\Height[0],\Color[0]\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
             DrawingMode(#PB_2DDrawing_Default)
            Box(\X[0],\Y[0]+5,\Width[0],a,\Color[0]\Line)
            Box(\X[0],\Y[0]+5,\Thumb\Pos,a,\Color[3]\Back[2])
          EndIf
          
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(\X[3],\Y[3],\Width[3]/2,\Height[3],\Color[3]\Back[\Color[3]\State])
            
            Line(\X[3],\Y[3],1,\Height[3],\Color[3]\Frame[\Color[3]\State])
            Line(\X[3],\Y[3],\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3],\Y[3]+\Height[3]-1,\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3]+\Width[3]/2,\Y[3],\Width[3]/2,\Height[3]/2+1,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3]+\Width[3]/2,\Y[3]+\Height[3]-1,\Width[3]/2,-\Height[3]/2-1,\Color[3]\Frame[\Color[3]\State])
            
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(\X[3],\Y[3],\Width[3],\Height[3]/2,\Color[3]\Back[\Color[3]\State])
            
            Line(\X[3],\Y[3],\Width[3],1,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3],\Y[3],1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3]+\Width[3]-1,\Y[3],1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3],\Y[3]+\Height[3]/2,\Width[3]/2+1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
            Line(\X[3]+\Width[3]-1,\Y[3]+\Height[3]/2,-\Width[3]/2-1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
            
          
          EndIf
          
          
          
          If *This\Ticks
            PlotStep = \width/\Max
;             Protected i
;             #a=4
;             For i=3 To \Width/2-#a Step #a
;               LineXY(\X+i,\Y[3]+\Height[3]-1,\X+i,\Y[3]+\Height[3]-4,\Color[3]\Frame)
;             Next
;             For i=\Width/2 To \Width Step #a
;               LineXY(\X+i,\Y[3]+\Height[3]-1,\X+i,\Y[3]+\Height[3]-4,\Color[3]\Frame)
;             Next
            
            DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
            Box(\X, \Y[3]+\Height[3]-4, \width, 4, $FF808080)
          
          EndIf
          
          
;           If \Focus
;             For i=0 To \Area\Len+\Thumb\Len+2 Step 2
;               Line(*This\X,*This\Y+i,1,1,\Color[3]\Frame[3])
;               Line(*This\X+*This\Width-1,*This\Y+i,1,1,\Color[3]\Frame[3])
;               
;               Line(*This\X+i,*This\Y,1,1,\Color[3]\Frame[3])
;               Line(*This\X+i,*This\Y+*This\Height-1,1,1,\Color[3]\Frame[3])
;             Next
;           EndIf
          
          StopDrawing()
        EndIf
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure ReDraw(*This.Gadget)
    Re(*This)
    Draw(*This)
  EndProcedure
  
  
  Procedure Canvas_Events(EventGadget.i, EventType.i)
    Static LastX, LastY
    Protected *This.Gadget = GetGadgetData(EventGadget)
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      
      Select EventType
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Re(*This)
          
      EndSelect
      
      \Repaint = Bar::CallBack(\Bar, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If \Repaint 
        ReDraw(*This)
        
        If \Bar\Change 
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
          \Bar\Change = 0
        EndIf
      EndIf
    EndWith
    
    ; Draw(*This)
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
        Case #PB_TrackBar_Minimum : Attribute = #PB_ScrollBar_Minimum
        Case #PB_TrackBar_Maximum : Attribute = #PB_ScrollBar_Maximum
      EndSelect
      
      If Bar::SetAttribute(*This\Bar, Attribute, Value)
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_TrackBar_Minimum : Attribute = #PB_ScrollBar_Minimum
        Case #PB_TrackBar_Maximum : Attribute = #PB_ScrollBar_Maximum
      EndSelect
      
      Result = Bar::GetAttribute(*This\Bar, Attribute)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Bar::SetState(*This\Bar, State)
        ReDraw(*This)
        If \Bar\Change 
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
          \Bar\Change = 0
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
    ProcedureReturn Bar::GetState(*This\Bar)
  EndProcedure
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Flag.i=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Pagelength.i
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        
        \Type = #PB_GadgetType_TrackBar
        \Ticks = Bool(Flag&#PB_TrackBar_Ticks)
        
        \fSize = 2
        \bSize = \fSize
        
        ; Inner coordinae
        \X[2]=\bSize
        \Y[2]=\bSize
        \Width[2] = \Width-\bSize*2
        \Height[2] = \Height-\bSize*2
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize
        \Y[1]=\Y[2]-\fSize
        \Width[1] = \Width[2]+\fSize*2
        \Height[1] = \Height[2]+\fSize*2
        
        \Color[0] = $FFFFFF
        \Color[1] = $C0C0C0
        \Color[2] = $F0F0F0
        
        ;*This\Bar = Bar::Bar(*This\X[2], *This\Y[2], *This\Width[2], *This\Height[2], Min, Max, PageLength, Bool(Flag&#PB_TrackBar_Vertical))
        \Bar = Bar::Bar(0,0, \Width[2], \Height[2], Min, Max, PageLength, Bool(Flag&#PB_TrackBar_Vertical))
        \Bar\Type = \Type
        \Bar\Inverted = Bool(\Bar\Vertical)
        If \Bar\Inverted
          \Bar\Page\Pos = (\Bar\Max-\Bar\Min)
        EndIf
        
        \Bar\Type = \Type
        \Bar\Button\Len = 0
        \Bar\Color\Line[0] = $CBCBCB
        \Bar\Color\Line[1] = \Bar\Color\Line
        \Bar\Color\Line[2] = \Bar\Color\Line
        \Bar\Color\Line[3] = \Bar\Color\Line
        
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
Define a,i


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
  TrackBarGadget(1, 10, 120, 250, 20, 0, 60, #PB_TrackBar_Ticks)
  SetGadgetState(1, 3000)
  TextGadget    (-1,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBarGadget(2, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  SetGadgetState(2, 8000)
  
  TextGadget    (-1, 300+10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TrackBar::Gadget(10, 300+10,  40, 250, 20, 0, 10000)
  TrackBar::SetState(10, 5000)
  TextGadget    (-1, 300+10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TrackBar::Gadget(11, 300+10, 120, 250, 20, 0, 60, #PB_TrackBar_Ticks)
  TrackBar::SetState(11, 3000)
  TextGadget    (-1,  300+90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBar::Gadget(12, 300+270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  TrackBar::SetState(12, 8000)
  
  BindGadgetEvent(1,@h_GadgetCallBack())
  BindGadgetEvent(11,@h_CallBack(), #PB_EventType_Change)
  BindGadgetEvent(2,@v_GadgetCallBack())
  BindGadgetEvent(12,@v_CallBack(), #PB_EventType_Change)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---8-b---
; EnableXP