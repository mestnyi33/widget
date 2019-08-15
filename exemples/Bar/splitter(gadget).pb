IncludePath "../../"
XIncludeFile "widgets.pbi"

;
; Module name   : Splitter
; Author        : mestnyi
; Last updated  : Dec 29, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule Splitter
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget Extends Widget::_S_Coordinate
    Canvas.Canvas
    *Bar.Widget::_S_Bar
  EndStructure
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Gadget_1.i, Gadget_2.i, Flag.i=0)
  
EndDeclareModule

Module Splitter
  
  ;- PROCEDURE
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ResizeGadget(_this_\First, 0, _this_\height-(_this_\Thumb\Pos-_this_\y), _this_\width, _this_\Thumb\Pos-_this_\y)
        ResizeGadget(_this_\Second, 0, 0, _this_\width, _this_\height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y))
      CompilerElse
        ResizeGadget(_this_\First, 0, 0, _this_\width, _this_\Thumb\Pos-_this_\y)
        ResizeGadget(_this_\Second, 0, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y))
      CompilerEndIf
    Else
      ResizeGadget(_this_\First, 0, 0, _this_\Thumb\Pos-_this_\x, _this_\height)
      ResizeGadget(_this_\Second, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\Pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Procedure Draw(*This.Gadget)
    With *This\Bar
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
        
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
          Case #PB_EventType_Resize ;: ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
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
          If (\Bar\Change Or \Bar\Resize)
              Resize_Splitter(\Bar)
        
;             Protected *fir.Gadget = GetGadgetData(\Bar\First)
;             Protected *sec.Gadget = GetGadgetData(\Bar\Second)
;             
;             CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;               ResizeGadget(\Bar\First, \Bar\x[1], (\Bar\height-\Bar\height[1])-\Bar\y[1]-Bool(Not *fir), \Bar\width[1], \Bar\height[1]+Bool(Not *fir))
;               ResizeGadget(\Bar\Second, \Bar\x[2], \Bar\y[1]-Bool(Not *sec), \Bar\width[2], \Bar\height[2]+Bool(Not *sec))
;             CompilerElse
;               ResizeGadget(\Bar\First, \Bar\x[1], \Bar\y[1], \Bar\width[1], \Bar\height[1]+Bool(Not *fir))
;               ResizeGadget(\Bar\Second, \Bar\x[2], \Bar\y[2], \Bar\width[2], \Bar\height[2]+Bool(Not *sec))
;             CompilerEndIf
;             
; ;             If *sec
; ;               Widget::Resize(*sec\Bar, #PB_Ignore, #PB_Ignore, \Bar\width[2], \Bar\height[2])
; ;               
; ;             CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
; ;               ResizeGadget(*sec\Bar\First, *sec\Bar\x[1], (*sec\Bar\height-*sec\Bar\height[1])-*sec\Bar\y[1]-Bool(Not *fir), *sec\Bar\width[1], *sec\Bar\height[1]+Bool(Not *fir))
; ;               ResizeGadget(*sec\Bar\Second, *sec\Bar\x[2], *sec\Bar\y[1]-Bool(Not *sec), *sec\Bar\width[2], *sec\Bar\height[2]+Bool(Not *sec))
; ;             CompilerElse
; ;               ResizeGadget(\Bar\First, \Bar\x[1], \Bar\y[1], \Bar\width[1], \Bar\height[1]+Bool(Not *fir))
; ;               ResizeGadget(\Bar\Second, \Bar\x[2], \Bar\y[2], \Bar\width[2], \Bar\height[2]+Bool(Not *sec))
; ;             CompilerEndIf
; ;             EndIf
          EndIf
          
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
    
    With *This\Bar
      Select Attribute
        Case #PB_Splitter_FirstMinimumSize : \Box\Size[1] = Value
        Case #PB_Splitter_SecondMinimumSize : \Box\Size[2] = Value
      EndSelect 
      
      If \Vertical
        \Area\Pos = \Y+\Box\Size[1]
        \Area\len = (\Height-\Box\Size[1]-\Box\Size[2])
      Else
        \Area\Pos = \X+\Box\Size[1]
        \Area\len = (\Width-\Box\Size[1]-\Box\Size[2])
      EndIf
      Draw(*This)
      ProcedureReturn 1
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
;       Select Attribute
;         Case #PB_Splitter_Minimum : Attribute = #PB_ScrollBar_Minimum
;         Case #PB_Splitter_Maximum : Attribute = #PB_ScrollBar_Maximum
;       EndSelect
      
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
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Gadget_1.i, Gadget_2.i, Flag.i=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container) : If Gadget=-1 : Gadget=g : EndIf
    CloseGadgetList()
    
    ;CocoaMessage(0,GadgetID(Gadget), "setParent", GadgetID(Gadget_1)); NSWindowAbove = 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      gtk_widget_reparent_( GadgetID(Gadget_1), GadgetID(Gadget) )
      gtk_widget_reparent_( GadgetID(Gadget_2), GadgetID(Gadget) )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      SetParent_( GadgetID(First), GadgetID(Gadget) )
      SetParent_( GadgetID(Second), GadgetID(Gadget) )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (Gadget_1)) 
      CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (Gadget_2)) 
    CompilerEndIf
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Bar = Widget::Splitter(0,0, Width, Height, 0, 0, Flag)
        
        \Bar\First = Gadget_1
        \Bar\Second = Gadget_2
      
        If \Bar\Change
          Resize_Splitter(\Bar)
        EndIf
        
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
    Splitter::SetState(13, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetWindowTitle(EventWindow(), Str(Splitter::GetState(EventGadget())))
    SetGadgetState(3, Splitter::GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
    Splitter::SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    SetWindowTitle(EventWindow(), Str(Splitter::GetState(EventGadget())))
    SetGadgetState(2, Splitter::GetState(EventGadget()))
  EndProcedure
  
  Define Flag
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux ; 
    LoadFont(0, "monospace", 7)
    SetGadgetFont(-1,FontID(0))
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS ; 
    LoadFont(0, "monospace", 10)
    SetGadgetFont(-1,FontID(0))
  CompilerEndIf
  
  ; Flag = Widget::#PB_Splitter_NoButtons
  
  Global Button_0, Button_1, Button_2, Splitter_0, Splitter_1

If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Separator)
    Splitter_1 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Button_2, Splitter_0, #PB_Splitter_Vertical)

    TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )

    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    Splitter_0 = Splitter::Gadget(#PB_Any, 0, 0, 410, 210, Button_0, Button_1, #PB_Splitter_Separator)
    Splitter_1 = Splitter::Gadget(#PB_Any, 430, 10, 410, 210, Button_2, Splitter_0, #PB_Splitter_Vertical)

    TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )

    
;     BindGadgetEvent(2,@h_GadgetCallBack())
;     BindGadgetEvent(12,@h_CallBack(), #PB_EventType_Change)
;     BindGadgetEvent(3,@v_GadgetCallBack())
;     BindGadgetEvent(13,@v_CallBack(), #PB_EventType_Change)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------
; EnableXP