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
  Macro Parent(_adress_, _canvas_) : Bool(_adress_\Canvas\Gadget = _canvas_) : EndMacro
  
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  ;Declare.i Draw(*This.Widget_S, Canvas.i=-1)
  
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, Value.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Image.i=-1, Flag.i=0, Radius.i=0, ImageWidth.i=0, ImageHeight.i=0)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1) ; .i CallBack(*This.Widget_S, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1, ImageWidth.i=0, ImageHeight.i=0)
  
EndDeclareModule

Module Button
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure.i GetState(*This.Widget_S)
    ProcedureReturn *This\Toggle
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, Value.i)
    Protected Result
    
    If *This\Toggle <> Bool(Value)
      *This\Toggle = Bool(Value)
      Result = #True
    EndIf
    
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
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1, ImageWidth.i=0, ImageHeight.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Gradient
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Text\Rotate = 270 ; 90;
        \Alpha = 255
        \Interact = 1
        \Line =- 1
        
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
        
        If IsImage(Image)
          If ImageWidth And ImageHeight
            \Image\handle[1] = CreateImage(#PB_Any, ImageWidth, ImageHeight, 32, #PB_Image_Transparent)
            \Image\handle = ImageID(\Image\handle[1])
            \Image\width = ImageWidth
            \Image\height = ImageHeight
            
            If StartDrawing(ImageOutput(\Image\handle[1]))
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawImage(ImageID(Image),0,0,ImageWidth, ImageHeight)
              StopDrawing()
            EndIf
          Else   
            \Image\handle[1] = Image
            \Image\handle = ImageID(Image)
            \Image\width = ImageWidth(Image)
            \Image\height = ImageHeight(Image)
          EndIf
        EndIf
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Default = Bool(Flag&#PB_Flag_Default)
          \Toggle = Bool(Flag&#PB_Flag_Toggle)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          \Flag\InLine = Bool(Flag&#PB_Text_InLine)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+10
            Else
              \Text\X = \fSize+10
              \Text\y = \fSize
            EndIf
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
          \Color[0] = Colors
          
          SetText(*This, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Image.i=-1, Flag.i=0, Radius.i=0, ImageWidth.i=0, ImageHeight.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius, Image, ImageWidth, ImageHeight)
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
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
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
        ForEach List()
          Resize(List()\Widget, #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore)
        Next
        
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
    LoadFont(0, "Arial", 18)
    ;  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 12)))
  CompilerElse
    LoadFont(0, "Arial", 16)
    ; SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 9)))
  CompilerEndIf 
  
  Procedure ResizeCallBack()
    ResizeGadget(11, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate), WindowHeight(EventWindow(), #PB_Window_InnerCoordinate))
  EndProcedure
  
  If OpenWindow(11, 0, 0, 250, 235, "ImageButton", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
    WindowBounds(11,150,235,#PB_Ignore,315)
    
    CanvasGadget(11,  0, 0, 150, 515, #PB_Canvas_Keyboard)
    BindGadgetEvent(11, @CallBacks())
    ;ResizeImage(10, 32, 32)
    
    Create(11,#PB_Any, 10,10,130,25,"text_right",0, #PB_Text_InLine)
    Create(11,#PB_Any, 10,40,130,25,"text_left",10,#PB_Text_InLine|#PB_Text_Right)
    Create(11,#PB_Any, 10,70,130,75,"text_top",0,#PB_Text_Bottom);,32,32)
    Create(11,#PB_Any, 10,150,130,75,"text_bottom",10,0,0,32,32)
    
    ; ;       ;Create(11,#PB_Any, 10,230,130,75,"",10)
    ; ;       
    ; ;       Create(11,#PB_Any, 10,310,130,35,"text_center",0)
    ; ;       Create(11,#PB_Any, 10,350,130,35,"text_left",0,#PB_Text_Left)
    ; ;       Create(11,#PB_Any, 10,390,130,35,"text_right",0,#PB_Text_Right)
    ; ;       Create(11,#PB_Any, 10,430,130,35,"text_top",0,#PB_Text_Top)
    ; ;       Create(11,#PB_Any, 10,470,130,35,"text_bottom",0,#PB_Text_Bottom)
    
    
    ;     ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    PostEvent(#PB_Event_SizeWindow, 11, 11)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    
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
; Folding = ----------
; EnableXP