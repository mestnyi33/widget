CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_text.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

;-
DeclareModule Button
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, Value.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1) ; .i CallBack(*This.Widget_S, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
EndDeclareModule

Module Button
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure.i GetState(*This.Widget_S)
    ProcedureReturn *This\Toggle
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, Value.i)
    Protected Result
    
    With *This
      If \Toggle And 
         \Checked <> Bool(Value)
        \Checked[1] = \Checked
        \Checked = Bool(Value)
        
        \Color\State = 2
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static LastX, LastY, Last, Drag
    Protected Repaint, Buttons, Widget.i
    
    If *This 
      With *This
        Select EventType
          Case #PB_EventType_MouseEnter    
            \Buttons = \Canvas\Mouse\From
            If Not \Checked : Buttons = \Buttons : EndIf
            
          Case #PB_EventType_LeftButtonDown 
            If \Buttons
              Buttons = \Buttons
              If \Toggle 
                \Checked[1] = \Checked
                \Checked ! 1
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp 
            If \Toggle 
              If Not \Checked
                Buttons = \Buttons
              EndIf
            Else
              Buttons = \Buttons
            EndIf
            
          Case #PB_EventType_LeftClick 
            PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Widget, #PB_EventType_LeftClick)
            
;           Case #PB_EventType_MouseLeave
;             If \Drag[1] 
;               \Checked = \Checked[1]
;             EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseEnter, #PB_EventType_LeftButtonUp, #PB_EventType_LeftButtonDown
            If Buttons : Buttons = 0
              \Color\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              Repaint = #True
            EndIf
            
          Case #PB_EventType_MouseLeave
            If Not \Checked 
              \Color\State = 0
              Repaint = #True
            EndIf
        EndSelect
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Gradient
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Line =- 1
        
        If Bool(Flag&#PB_Text_Vertical)
          If Bool(Flag&#PB_Text_Reverse)
            \Text\Rotate = 90
          Else
            \Text\Rotate = 270
          EndIf
        EndIf
        
        ; Set the default widget flag
        Flag|#PB_Text_ReadOnly
        
        If Bool(Flag&#PB_Text_Left)
          Flag&~#PB_Text_Center
        Else
          Flag|#PB_Text_Center
        EndIf
        
        If Bool(Flag&#PB_Text_Top)
          Flag&~#PB_Text_Middle
        Else
          Flag|#PB_Text_Middle
        EndIf
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Default = Bool(Flag&#PB_Flag_Default)
          \Toggle = Bool(Flag&#PB_Flag_Toggle)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 2
          EndIf
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+10
            Else
              \Text\X = \fSize+10
              \Text\y = \fSize
            EndIf
            
            ;             Define Alpha.CGFloat = 0.6
            ;             CocoaMessage(0, GadgetID(Canvas), "setOpaque:", #NO)
            ;             CocoaMessage(0, GadgetID(Canvas), "setAlphaValue:@", @Alpha)
            ; CocoaMessage(0, GadgetID(Canvas), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor clearColor"))
            ; CocoaMessage(0, CocoaMessage(0, GadgetID(Canvas), "enclosingScrollView"), "setDrawsBackground:", #NO)
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+2
            Else
              \Text\X = \fSize+2
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+6
            Else
              \Text\X = \fSize+6
              \Text\y = \fSize
            EndIf
          CompilerEndIf 
          
          ; Устанавливаем 
          ; цвета по умолчанию
          \Color = Colors
          ;\Color\Front[3] = \Color\Front[1]
          
          SetText(*This, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseModule Button
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Global *Button_0.Widget_S = AllocateStructure(Widget_S)
  Global *Button_1.Widget_S = AllocateStructure(Widget_S)
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Window = EventWindow()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
        Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore)
        
        Result = 1
      Default
        ;         ; First window
        ;         Result | CallBack(*B_0, EventType()) 
        ;         Result | CallBack(*B_1, EventType()) 
        ;         Result | CallBack(*B_2, EventType()) 
        ;         Result | CallBack(*B_3, EventType()) 
        ;         Result | CallBack(*B_4, EventType()) 
        ;         
        ;         ; Second window
        ;         Result | CallBack(*Button_0, EventType()) 
        ;         Result | CallBack(*Button_1, EventType()) 
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          ; If List()\Widget\Canvas\Gadget = GetActiveGadget()
          Result | CallBack(List()\Widget, EventType()) 
          ; EndIf
        Next
        
    EndSelect
    
    If Result Or EventType() = #PB_EventType_Repaint
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $FFF0F0F0)
        
        ForEach List()
          Draw(List()\Widget)
        Next
        
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    CreateImage(0, 64, 64, 32 , #PB_Image_Transparent)
    StartDrawing(ImageOutput(0))
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Circle(32, 32, 30, $ffd0f080)
    StopDrawing()
    
    Application = CocoaMessage(0, 0, "NSApplication sharedApplication")
    CocoaMessage(0, Application, "setApplicationIconImage:", ImageID(0))
    
    LoadFont(0, "Arial", 18)
    ; SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "Times New Roman", 13)))
  CompilerElse
    LoadFont(0, "Arial", 16)
    ; SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 9)))
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 222+222, 205, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
    ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ButtonGadget(3, 10,100, 200, 60, #LF$+"Multiline Button  (longer text gets automatically wrapped)"+#LF$, #PB_Button_MultiLine|#PB_Button_Default)
    CompilerElse
      ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine|#PB_Button_Default)
    CompilerEndIf 
    ButtonGadget(5, 10,170, 200, 25, "Toggle Button", #PB_Button_Toggle)
    SetGadgetState (5,1)
    
    
    CanvasGadget(10,  222, 0, 222, 205+70, #PB_Canvas_Keyboard)
    BindGadgetEvent(10, @CallBacks())
    
    *B_0 = Create(10, -1, 10, 10, 200, 20, "Standard Button", 0,8)
    *B_1 = Create(10, -1, 10, 40, 200, 20, "Left Button", #PB_Text_Left)
    *B_2 = Create(10, -1, 10, 70, 200, 20, "Right Button", #PB_Text_Right)
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      *B_3 = Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_MultiLine|#PB_Flag_Default, 4)
    CompilerElse
      *B_3 = Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_WordWrap|#PB_Flag_Default, 4)
    CompilerEndIf 
    *B_4 = Create(10, -1, 10,170, 200, 25, "Toggle Button", #PB_Flag_Toggle,0)
    SetState (*B_4,1)
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
  EndIf
  
  
  Procedure ResizeCallBack()
    ResizeGadget(11, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  Define Text.s = "Vertical & Horizontal"; + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
  
  If OpenWindow(11, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g=11
    CanvasGadget(g,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Button_0
      *Button_0 = Create(g, -1, 270, 10,  60, 120, "Button (Vertical)", #PB_Text_MultiLine | #PB_Text_Vertical)
      ;       SetColor(*Button_0, #PB_Gadget_BackColor, $FFCCBFB4)
      SetColor(*Button_0, #PB_Gadget_FrontColor, $FFD56F1A)
      SetFont(*Button_0, FontID(0))
    EndWith
    
    With *Button_1
      *Button_1 = Create(g, -1, 10, 42, 250,  60, "Button (Horizontal)", #PB_Text_MultiLine,0)
      ;       SetColor(*Button_1, #PB_Gadget_BackColor, $FFD58119)
      \Cursor = #PB_Cursor_Hand
      SetColor(*Button_1, #PB_Gadget_FrontColor, $FF4919D5)
      SetFont(*Button_1, FontID(0))
    EndWith
    
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
    BindGadgetEvent(g, @CallBacks())
    PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 435
; FirstLine = 427
; Folding = ------------
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---v-f--7------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --v-------
; EnableXP