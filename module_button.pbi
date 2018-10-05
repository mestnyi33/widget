CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_Text.pbi"
CompilerEndIf

;-
DeclareModule Button
  
  EnableExplicit
  UseModule Constants
  UseModule Structures
  
  ;- DECLAREs
  Declare.i Draw(*This.Widget)
  Declare.s GetText(*This.Widget)
  Declare.i SetText(*This.Widget, Text.s)
  Declare.i SetFont(*This.Widget, FontID.i)
  Declare.i GetColor(*This.Widget, ColorType.i)
  Declare.i SetColor(*This.Widget, ColorType.i, Color.i)
  Declare.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i)
  Declare.i CallBack(*This.Widget, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
EndDeclareModule

Module Button
  
  ;- MACROS
  Macro Colors(_this_, _i_, _ii_, _iii_)
    If _this_\Color[_i_]\Line[_ii_]
      _this_\Color[_i_]\Line[_iii_] = _this_\Color[_i_]\Line[_ii_]
    Else
      _this_\Color[_i_]\Line[_iii_] = _this_\Color[0]\Line[_ii_]
    EndIf
    
    If _this_\Color[_i_]\Fore[_ii_]
      _this_\Color[_i_]\Fore[_iii_] = _this_\Color[_i_]\Fore[_ii_]
    Else
      _this_\Color[_i_]\Fore[_iii_] = _this_\Color[0]\Fore[_ii_]
    EndIf
    
    If _this_\Color[_i_]\Back[_ii_]
      _this_\Color[_i_]\Back[_iii_] = _this_\Color[_i_]\Back[_ii_]
    Else
      _this_\Color[_i_]\Back[_iii_] = _this_\Color[0]\Back[_ii_]
    EndIf
    
    If _this_\Color[_i_]\Frame[_ii_]
      _this_\Color[_i_]\Frame[_iii_] = _this_\Color[_i_]\Frame[_ii_]
    Else
      _this_\Color[_i_]\Frame[_iii_] = _this_\Color[0]\Frame[_ii_]
    EndIf
  EndMacro
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Macro ResetColor(This)
    
    Colors(This, 0, 1, 0)
    Colors(This, 1, 1, 0)
    Colors(This, 2, 1, 0)
    Colors(This, 3, 1, 0)
    
    
    Colors(This, 1, 1, 1)
    Colors(This, 2, 1, 1)
    Colors(This, 3, 1, 1)
    
    Colors(This, 1, 2, 2)
    Colors(This, 2, 2, 2)
    Colors(This, 3, 2, 2)
    
    Colors(This, 1, 3, 3)
    Colors(This, 2, 3, 3)
    Colors(This, 3, 3, 3)
    
  EndMacro
  
  
  ;- PROCEDUREs
  Procedure.i Draw(*This.Widget)
    With *This
      If Not \Hide
        If \FontID : DrawingFont(\FontID) : EndIf
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore,\Color[1]\Back)
        Protected String.s, StringWidth
        Protected IT,Text_Y,Text_X,TxtHeight,Width,Height
        
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          TxtHeight=\Text\Height
          
          If \Vertical
            Width = \Height[1]-\Text\X*2
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \Resize
            If \Text\MultiLine
              \Text\String.s[1] = Text::Wrap(\Text\String.s, Width)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            ElseIf \Text\WordWrap
              \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, 0)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            Else
              \Text\String.s[1] = \Text\String.s
              \Text\CountString = 1
            EndIf
            \Resize = #False
          EndIf
          
          If \Text\CountString
            If \Text\Align_Bottom ; Bool((\Text\Align & #PB_Text_Bottom) = #PB_Text_Bottom) 
              Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
            ElseIf \Text\Align_Vertical ; Bool((\Text\Align & #PB_Text_Middle) = #PB_Text_Middle) 
              Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
            EndIf
            
            
            For IT = 1 To \Text\CountString
              If \Text\Y+Text_Y < \bSize : Text_Y+TxtHeight : Continue : EndIf
              
              String = StringField(\Text\String.s[1], IT, #LF$)
              StringWidth = TextWidth(RTrim(String))
              
              If \Text\Align_Right ; Bool((\Text\Align & #PB_Text_Right) = #PB_Text_Right) 
                Text_X=(Width-StringWidth-\Text\X) 
              ElseIf \Text\Align_Horisontal ; Bool((\Text\Align & #PB_Text_Center) = #PB_Text_Center) 
                Text_X=(Width-StringWidth)/2 
              EndIf
              
              
              ;               DrawingMode(#PB_2DDrawing_Outlined)
              ;               Box(\X[1],Text_Y,\Width[1],\Text\Height,0)
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Vertical
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Width) : Break : EndIf
              Else
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Height-TxtHeight) : Break : EndIf
              EndIf
              
            Next
          EndIf
          
        EndIf
        
        
        ;         DrawingMode(\DrawingMode)
        ;         If \Width > \Text\X
        ;           BoxGradient(\Vertical,\X[1],\Y[1]+\Text\Y,\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Width[1]-\Text\X,\Y[1],\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;         If \Height > \Text\Y
        ;           BoxGradient(\Vertical,\X[1],\Y[1],\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Text\X,\Y[1]+\Height[1]-\Text\Y,\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;       
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Frame)
        EndIf
        
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure.s GetText(*This.Widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(*This.Widget, Text.s)
    Protected Result
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This.Widget, FontID.i)
    Protected Result
    
    If *This\FontID <> FontID
      *This\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget, ColorType.i, Color.i)
    Protected Result
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_BackColor
          If \Color\Back <> Color 
            \Color\Back = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrontColor
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrameColor
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This.Widget, ColorType.i)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line
        Case #PB_Gadget_BackColor  : Color = \Color\Back
        Case #PB_Gadget_FrontColor : Color = \Color\Front
        Case #PB_Gadget_FrameColor : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i)
    Protected Result
    
    With *This
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        Result = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        Result = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        Result = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        Result = 4
      EndIf
      
      If Result
        \Resize = #True
      EndIf
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure.i CallBack(*This.Widget, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Scroll.Widget, Cursor, Drag
    
    With *This
      If \Hide
        If *This = *Scroll
          \Focus = 0
          \Buttons = 0
        EndIf
      Else
        If Drag
          If \Buttons>0 : Buttons = \Buttons : EndIf
        Else
          If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
            If (Mousex>\x[1] And Mousex=<\x[1]+\Width[1] And  Mousey>\y[1] And Mousey=<\y[1]+\Height[1])
              \Buttons = 1
            ElseIf (Mousex>\x[3] And Mousex=<\x[3]+\Width[3] And Mousey>\y[3] And Mousey=<\y[3]+\Height[3])
              \Buttons = 3
            ElseIf (Mousex>\x[2] And Mousex=<\x[2]+\Width[2] And Mousey>\y[2] And Mousey=<\y[2]+\Height[2])
              \Buttons = 2
            Else
              \Buttons =- 1
            EndIf
            
            If \Buttons>0 : Buttons = \Buttons : EndIf
          Else
            \Buttons = 0
          EndIf
        EndIf
        
        Select EventType
          Case #PB_EventType_MouseLeave : Buttons = 0 : LastX = 0 : LastY = 0
          Case #PB_EventType_LeftButtonUp : Drag = 0 :  LastX = 0 : LastY = 0
          Case #PB_EventType_LeftButtonDown : Drag = 1
            If Buttons : *Scroll = *This : EndIf
            
          Case #PB_EventType_MouseMove
            If Drag
              If Bool(LastX|LastY) 
                If *Scroll = *This
                  
                EndIf
              EndIf
            Else
              If \Buttons
                If Last<>Buttons
                  If *Scroll : CallBack(*Scroll, #PB_EventType_MouseLeave, MouseX, MouseY, WheelDelta) : EndIf
                  EventType = #PB_EventType_MouseEnter
                  Last = Buttons
                EndIf
                
                If *Scroll <> *This 
                  ; Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *Scroll = *This
                EndIf
              ElseIf *Scroll = *This
                If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  ; Debug "Мышь находится снаружи"
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
                EndIf
                
                EventType = #PB_EventType_MouseLeave
                *Scroll = 0
                Last = 0
              EndIf
            EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
            If Buttons
              \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Line = \Color[Buttons]\Line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            Else
              ResetColor(*This)
            EndIf
            
            Result = #True
        EndSelect 
        
        Select EventType
          Case #PB_EventType_Focus
            \Focus = #True
            Result = #True
          Case #PB_EventType_LostFocus
            \Focus = #False
            Result = #True
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure Widget(*This.Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \fSize = Bool(Flag&#PB_Text_Border)
        \bSize = \fSize
        
        
        If Resize(*This, X,Y,Width,Height)
          \Color\Frame = $C0C0C0
          \Color\Back = $F0F0F0
          
          \DrawingMode = #PB_2DDrawing_Gradient
          \Vertical = Bool(Flag&#PB_Text_Vertical)
          
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          If Not \Text\WordWrap
            \Text\MultiLine = 1
          EndIf
          
          If \Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+12 ; 2,6,1
          Else
            \Text\X = \fSize+12 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          \Color[0]\Fore[1] = $F6F6F6 
          \Color[0]\Frame[1] = $BABABA
          
          \Color[0]\Back[1] = $F0F0F0 
          \Color[1]\Back[1] = $E2E2E2  
          \Color[2]\Back[1] = $E2E2E2 
          \Color[3]\Back[1] = $E2E2E2 
          
          \Color[0]\Line[1] = $FFFFFF
          \Color[1]\Line[1] = $5B5B5B
          \Color[2]\Line[1] = $5B5B5B
          \Color[3]\Line[1] = $5B5B5B
          
          ;
          \Color[0]\Fore[2] = $EAEAEA
          \Color[0]\Back[2] = $CECECE
          \Color[0]\Line[2] = $5B5B5B
          \Color[0]\Frame[2] = $8F8F8F
          
          ;
          \Color[0]\Fore[3] = $E2E2E2
          \Color[0]\Back[3] = $B4B4B4
          \Color[0]\Line[3] = $FFFFFF
          \Color[0]\Frame[3] = $6F6F6F
          
          ResetColor(*This)
          
          If Bool(Flag&#PB_Text_Center) : \Text\Align_Horisontal=1 : EndIf
          If Bool(Flag&#PB_Text_Middle) : \Text\Align_Vertical=1 : EndIf
          If Bool(Flag&#PB_Text_Right)  : \Text\Align_Right=1 : EndIf
          If Bool(Flag&#PB_Text_Bottom) : \Text\Align_Bottom=1 : EndIf
          
          If Bool(Flag&#PB_Text_Center) : \Text\Align | #PB_Text_Center : EndIf
          If Bool(Flag&#PB_Text_Middle) : \Text\Align | #PB_Text_Middle : EndIf
          If Bool(Flag&#PB_Text_Right)  : \Text\Align | #PB_Text_Right : EndIf
          If Bool(Flag&#PB_Text_Bottom) : \Text\Align | #PB_Text_Bottom : EndIf
          
          \Text\String.s = Text.s
          \Text\Change = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Button
  Global *Button_0.Widget = AllocateStructure(Widget)
  Global *Button_1.Widget = AllocateStructure(Widget)
  
  Procedure Canvas_CallBack()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        If Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
          Result = 1
        EndIf
        If Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore)
          Result = 1
        EndIf
      Default
        
        If CallBack(*Button_0, EventType(), MouseX, MouseY, WheelDelta) 
          Result = 1
        EndIf
        If CallBack(*Button_1, EventType(), MouseX, MouseY, WheelDelta) 
          Result = 1
        EndIf
        
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height)
        Draw(*Button_0)
        Draw(*Button_1)
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(0, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g=1
    CanvasGadget(g,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Button_0
      \Canvas\Gadget = g
      \Type = #PB_GadgetType_Text
      \FontID = GetGadgetFont(#PB_Default)
      
      Widget(*Button_0, 270, 10,  60, 120, "Button (Vertical)", #PB_Text_Center|#PB_Text_Middle|#PB_Text_Border | #PB_Text_Vertical)
      SetColor(*Button_0, #PB_Gadget_BackColor, $CCBFB4)
      SetColor(*Button_0, #PB_Gadget_FrontColor, $D56F1A)
      SetFont(*Button_0, FontID(0))
    EndWith
    
    With *Button_1
      \Canvas\Gadget = g
      \Type = #PB_GadgetType_Text
      \FontID = GetGadgetFont(#PB_Default)
      
      Widget(*Button_1, 10, 42, 250,  60, "Button (Horisontal)", #PB_Text_Center|#PB_Text_Middle|#PB_Text_Border)
      SetColor(*Button_1, #PB_Gadget_BackColor, $CCBFB4)
      SetColor(*Button_1, #PB_Gadget_FrontColor, $4919D5)
      SetFont(*Button_1, FontID(0))
    EndWith
    
    BindGadgetEvent(g, @Canvas_CallBack())
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 140
; FirstLine = 130
; Folding = ---------------
; EnableXP