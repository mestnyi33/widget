DeclareModule Bar
  EnableExplicit
  
  ;- - STRUCTUREs
  ;- - Coordinate_S
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - Color_S
  Structure Color_S
    State.b ; entered; selected; focused; lostfocused
    Front.i[4]
    Line.i[4]
    Fore.i[4]
    Back.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
  EndStructure
  
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    *s.Scroll_S
    
    at.b
    Type.i
    Radius.a
    ArrowSize.a[3]
    ArrowType.b[3]
    
    Max.i
    Min.i
    *Step
    Hide.b[2]
    
    Focus.b
    Change.b
    Vertical.b
    Inverted.b
    Direction.i
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Var_S
  Structure Var_S
    Event.i
    *Handle.Bar_S
    *Focus.Bar_S
    Color.Color_S
  EndStructure
  
  Global *Bar.Var_S
  
  ;-
  ;- - CONSTANTs
  #PB_Gadget_FrameColor = 10
  #PB_ScrollBar_Direction = 1<<2
  #PB_ScrollBar_NoButtons = 1<<3
  #PB_ScrollBar_Inverted = 1<<4
  
  ;-
  ;- - DECLAREs
  ; Then scroll bar begining position
  Macro IsStart(_this_)
    Bool(_this_\Page\Pos =< _this_\Min)
  EndMacro
  
  ; Then scroll bar end position
  Macro IsStop(_this_)
    Bool(_this_\Page\Pos >= (_this_\Max-_this_\Page\len))
  EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=1)
    (Bool(_inverted_) * ((_this_\Min + (_this_\Max - _this_\Page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Declare.i Draw(*This.Bar_S)
  Declare.i GetState(*This.Bar_S)
  Declare.i SetState(*This.Bar_S, ScrollPos.i)
  Declare.i GetAttribute(*This.Bar_S, Attribute.i)
  Declare.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
  Declare.i CallBack(*This.Bar_S, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
  Declare.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i, *That.Bar_S=0)
  Declare.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  
  Declare.i Updates(*v.Bar_S, *h.Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Bar
  *Bar = AllocateStructure(Var_S)
  
  ; Default values
  With *Bar                         
   *Bar\Event =- 1
   
   \Color\State = 0
    ; Цвета по умолчанию
    \Color\Front[0] = $80000000
    \Color\Fore[0] = $FFF8F8F8 
    \Color\Back[0] = $80E2E2E2
    \Color\Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Color\Front[1] = $80000000
    \Color\Fore[1] = $FFFAF8F8
    \Color\Back[1] = $80FCEADA
    \Color\Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Color\Front[2] = $FFFEFEFE
    \Color\Fore[2] = $C8E9BA81;$C8FFFCFA
    \Color\Back[2] = $C8E89C3D; $80E89C3D
    \Color\Frame[2] = $C8DC9338; $80DC9338
  EndWith
  
  ;-
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
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min)) * ((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\len : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\len : EndIf
  EndMacro
  
  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i Pos(*This.Bar_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = \Min + Round((ThumbPos - \Area\Pos) / (\Area\len / (\Max-\Min)), #PB_Round_Nearest)
      ScrollPos = Round(ScrollPos/(\Step + Bool(Not \Step)), #PB_Round_Nearest) * \Step
      If (\Vertical And \Type = #PB_GadgetType_TrackBar)
        ScrollPos = Invert(*This, ScrollPos, \Inverted)
      EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.i Draw(*This.Bar_S)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This
      \Change = 0
      *Bar\Event =- 1 
      *Bar\Handle = 0
      
      If *This And Not \hide And \color\alpha
        State_0 = \Color[0]\State
        State_1 = \Color[1]\State
        State_2 = \Color[2]\State
        State_3 = \Color[3]\State
        Alpha = \color\alpha<<24
        LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
          
        ; Draw scroll bar background
        If \Color\Back[State_0]<>-1
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw line
        If \Color\Line[State_0]<>-1
          If \Vertical
            Line( \X, \Y, 1, \Page\len + Bool(\height<>\Page\len), \Color\Line[State_0]&$FFFFFF|Alpha)
          Else
            Line( \X, \Y, \Page\len + Bool(\width<>\Page\len), 1, \Color\Line[State_0]&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        If \Thumb\len 
          ; Draw thumb  
          If \Color[3]\back[State_3]<>-1
            If \Color[3]\Fore[State_3]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[3], \Y[3], \Width[3], \Height[3], \Color[3]\Fore[State_3], \Color[3]\Back[State_3], \Radius, \color\alpha)
          EndIf
          
          ; Draw thumb frame
          If \Color[3]\Frame[State_3] 
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[3], \Y[3], \Width[3], \Height[3], \Radius, \Radius, \Color[3]\Frame[State_3]&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        If \Button\len
          ; Draw buttons
          If \Color[1]\back[State_1]<>-1
            If \Color[1]\Fore[State_1]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[1], \Y[1], \Width[1], \Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], \Radius, \color\alpha)
          EndIf
          If \Color[2]\back[State_2]<>-1
            If \Color[2]\Fore[State_2]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], \Radius, \color\alpha)
          EndIf
          
          ; Draw buttons frame
          If \Color[1]\Frame[State_1]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
          EndIf
          If \Color[2]\Frame[State_2]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Arrow( \X[1]+( \Width[1]-\ArrowSize[1])/2, \Y[1]+( \Height[1]-\ArrowSize[1])/2, \ArrowSize[1], Bool( \Vertical),
                 (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \ArrowType[1])
          
          Arrow( \X[2]+( \Width[2]-\ArrowSize[2])/2, \Y[2]+( \Height[2]-\ArrowSize[2])/2, \ArrowSize[2], Bool( \Vertical)+2, 
                 (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \ArrowType[2])
          
        EndIf
        
        If \Color[3]\Fore[State_3]  ; Draw thumb lines
          If \Focus And Not State_3 = 2
            LinesColor = $FF0000FF
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2-3,9,1, LinesColor)
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2,9,1, LinesColor)
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2+3,9,1, LinesColor)
          Else
            Line( \X[3]+\Width[3]/2-3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
            Line( \X[3]+\Width[3]/2, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
            Line( \X[3]+\Width[3]/2+3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i _Draw(*This.Bar_S)
    With *This
      \Change = 0
      *Bar\Event =- 1 
      *Bar\Handle = 0
      
      If *This And Not \hide And \color\alpha
        Protected LinesColor.i = \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24
          
        ; Draw scroll bar background
        If \Color\Back[\Color\State]<>-1
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back[\Color\State]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw line
        If \Color\Line[\Color\State]<>-1
          If \Vertical
            Line( \X, \Y, 1, \Page\len + Bool(\height<>\Page\len), \Color\Line[\Color\State]&$FFFFFF|\color\alpha<<24)
          Else
            Line( \X, \Y, \Page\len + Bool(\width<>\Page\len), 1, \Color\Line[\Color\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \Thumb\len 
          ; Draw thumb  
          If \Color[3]\back[\Color[3]\State]<>-1
            If \Color[3]\Fore[\Color[3]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[3], \Y[3], \Width[3], \Height[3], \Color[3]\Fore[\Color[3]\State], \Color[3]\Back[\Color[3]\State], \Radius, \color\alpha)
          EndIf
          
          ; Draw thumb frame
          If \Color[3]\Frame[\Color[3]\State] 
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[3], \Y[3], \Width[3], \Height[3], \Radius, \Radius, \Color[3]\Frame[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \Button\len
          ; Draw buttons
          If \Color[1]\back[\Color[1]\State]<>-1
            If \Color[1]\Fore[\Color[1]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[1], \Y[1], \Width[1], \Height[1], \Color[1]\Fore[\Color[1]\State], \Color[1]\Back[\Color[1]\State], \Radius, \color\alpha)
          EndIf
          If \Color[2]\back[\Color[2]\State]<>-1
            If \Color[2]\Fore[\Color[2]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color[2]\Fore[\Color[2]\State], \Color[2]\Back[\Color[2]\State], \Radius, \color\alpha)
          EndIf
          
          ; Draw buttons frame
          If \Color[1]\Frame[\Color[1]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color[1]\Frame[\Color[1]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
          If \Color[2]\Frame[\Color[2]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color[2]\Frame[\Color[2]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Arrow( \X[1]+( \Width[1]-\ArrowSize[1])/2, \Y[1]+( \Height[1]-\ArrowSize[1])/2, \ArrowSize[1], 
                 Bool( \Vertical), (Bool(Not IsStart(*This)) * \Color[1]\Front[\Color[1]\State] + Bool(IsStart(*This)) * \Color[1]\Frame[0])&$FFFFFF|\color\alpha<<24, \ArrowType[1])
          
          Arrow( \X[2]+( \Width[2]-\ArrowSize[2])/2, \Y[2]+( \Height[2]-\ArrowSize[2])/2, \ArrowSize[2],
                 Bool( \Vertical)+2, (Bool(Not IsStop(*This)) * \Color[2]\Front[\Color[2]\State] + Bool(IsStop(*This)) * \Color[2]\Frame[0])&$FFFFFF|\color\alpha<<24, \ArrowType[2])
          
        EndIf
        
        If \Color[3]\Fore[\Color[3]\State]  ; Draw thumb lines
          If \Focus And Not \Color[3]\State = 2
            LinesColor = $FF0000FF
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2-3,9,1, LinesColor)
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2,9,1, LinesColor)
            Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2+3,9,1, LinesColor)
          Else
            Line( \X[3]+\Width[3]/2-3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
            Line( \X[3]+\Width[3]/2, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
            Line( \X[3]+\Width[3]/2+3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  Procedure.i GetData()
    If *Bar\Handle
      ProcedureReturn *Bar\Handle\Direction
    EndIf
  EndProcedure
  
  Procedure.i GetState(*This.Bar_S)
    ProcedureReturn Invert(*This, *This\Page\Pos, *This\Inverted)
  EndProcedure
  
  Procedure.i SetState(*This.Bar_S, ScrollPos.i)
    Protected Result.i, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This
        If (\Vertical And \Type = #PB_GadgetType_TrackBar)
           ScrollPos = Invert(*This, ScrollPos, \Inverted)
        EndIf
        
        If ScrollPos < \Min
          ScrollPos = \Min 
        EndIf
        
        If ScrollPos > (\Max-\Page\len)
          ScrollPos = (\Max-\Page\len)
        EndIf
        
        If \Page\Pos <> ScrollPos 
          If \Inverted
            If \Page\Pos > ScrollPos
              \Direction = Invert(*This, ScrollPos, \Inverted)
            Else
              \Direction =- Invert(*This, ScrollPos, \Inverted)
            EndIf
          Else
            If \Page\Pos > ScrollPos
              \Direction =- ScrollPos
            Else
              \Direction = ScrollPos
            EndIf
          EndIf
        
          *Bar\Handle = *This
          *Bar\Event = #PB_EventType_Change
          \Thumb\Pos = ThumbPos(*This, ScrollPos)
          \Page\Pos = ScrollPos
          \Change = 1
          Result = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*This.Bar_S, Attribute.i)
    Protected Result.i
    
    With *This
      If *This
        Select Attribute
          Case #PB_ScrollBar_Minimum : Result = \Min
          Case #PB_ScrollBar_Maximum : Result = \Max
          Case #PB_ScrollBar_Inverted : Result = \Inverted
          Case #PB_ScrollBar_PageLength : Result = \Page\len
          Case #PB_ScrollBar_NoButtons : Result = \Button\len
          Case #PB_ScrollBar_Direction : Result = \Direction
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
    With *This
      If *This
        Select Attribute
          Case #PB_ScrollBar_NoButtons 
            \Button\len = Value
            Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ProcedureReturn 1
            
          Case #PB_ScrollBar_Inverted
            \Inverted = Bool(Value)
            \Page\Pos = Invert(*This, \Page\Pos)
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
            ProcedureReturn 1
            
          Case #PB_ScrollBar_Minimum ; 1 -m
            If \Min <> Value 
              \Min = Value
              \Page\Pos = Value
              ProcedureReturn 1
            EndIf
            
          Case #PB_ScrollBar_Maximum ; 2 -m
            If \Max <> Value
              If \Min > Value
                Value = \Min + 1
              EndIf
              \Max = Value
              
              \Step = (\Max-\Min) / 100
              If Not \Step
                \Step = Bool(\Page\len) * ((\Max-\Min) / (Bool(\Page\len) * \Page\len + 1)) + 1
              EndIf
              ProcedureReturn 1
            EndIf
            
          Case #PB_ScrollBar_PageLength ; 3 -m
            If \Page\len <> Value
              If Value > (\Max-\Min)
                If \Max = 0 
                  ; In case the maximum
                  ; is not yet set 
                  \Max = Value 
                EndIf
                Value = (\Max-\Min)
              EndIf
              \Page\len = Value
              ProcedureReturn 1
            EndIf
            
        EndSelect
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *This
      If State =- 1
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*This.Bar_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    If *This
      
      *Bar\Handle = *This
      *Bar\Event = EventType
      
      With *This
        Select EventType
          Case #PB_EventType_Focus : \Focus = 1 : Repaint = 1
          Case #PB_EventType_LostFocus : \Focus = 0 : Repaint = 1
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0
          Case #PB_EventType_LeftDoubleClick 
            Select at
              Case - 1
                If \Vertical
                  Repaint = (MouseScreenY-\Thumb\len/2)
                Else
                  Repaint = (MouseScreenX-\Thumb\len/2)
                EndIf
                
                Repaint = SetState(*This, Pos(*This, Repaint))
            EndSelect
            
          Case #PB_EventType_LeftButtonDown
            Select at
              Case 1 : Repaint = SetState(*This, (\Page\Pos - \Step)) ; Up button
              Case 2 : Repaint = SetState(*This, (\Page\Pos + \Step)) ; Down button
              Case 3                                                                 ; Thumb button
                If \Vertical
                  delta = MouseScreenY - \Thumb\Pos
                Else
                  delta = MouseScreenX - \Thumb\Pos
                EndIf
            EndSelect
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = (MouseScreenY-delta)
              Else
                Repaint = (MouseScreenX-delta)
              EndIf
              
              Repaint = SetState(*This, Pos(*This, Repaint))
            EndIf
            
          Case #PB_EventType_MouseWheel
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \Step = 1
                  Repaint + ((\Max-\Min) / 100)
                Else
                  Repaint + \Step
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \Step = 1
                  Repaint - ((\Max-\Min) / 100)
                Else
                  Repaint - \Step
                EndIf
              EndIf
              
              Repaint = SetState(*This, (\Page\Pos + Repaint))
            EndIf  
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If at > 0
              \Color[at]\State = 0
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            If ((at = 1 And IsStart(*This)) Or (at = 2 And IsStop(*This)))
              \Color[at]\State = 0
              at = 0
            EndIf
            
            If at>0
              \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If Not cursor
                cursor = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
              
            EndIf
        EndSelect
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Bar_S, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected repaint.i
    Static Last.i, Down.i, *Scroll.Bar_S, *Last.Bar_S, mouseB.i, mouseat.i, Buttons
    
    With *This
      Select EventType 
        Case #PB_EventType_LeftButtonDown, 
             #PB_EventType_MiddleButtonDown, 
             #PB_EventType_RightButtonDown
          Buttons = 1
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonUp
          Buttons = 0
      EndSelect
      
      If *This And Not \hide And \color\alpha
        If Not MouseScreenX
          MouseScreenX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
        EndIf
        If Not MouseScreenY
          MouseScreenY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
        EndIf
        
        ; get at point buttons
        If mouseB Or Buttons
        ElseIf (MouseScreenX>=\X And MouseScreenX<\X+\Width And MouseScreenY>\Y And MouseScreenY=<\Y+\Height) 
          If (MouseScreenX>\X[1] And MouseScreenX=<\X[1]+\Width[1] And  MouseScreenY>\Y[1] And MouseScreenY=<\Y[1]+\Height[1])
            \at = 1
          ElseIf (MouseScreenX>\X[3] And MouseScreenX=<\X[3]+\Width[3] And MouseScreenY>\Y[3] And MouseScreenY=<\Y[3]+\Height[3])
            \at = 3
          ElseIf (MouseScreenX>\X[2] And MouseScreenX=<\X[2]+\Width[2] And MouseScreenY>\Y[2] And MouseScreenY=<\Y[2]+\Height[2])
            \at = 2
          Else
            \at =- 1
          EndIf 
          
          Select EventType 
            Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
            Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = *This
        Else
          \at = 0
          
          Select EventType 
            Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
              EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = 0
        EndIf
        
        If *Scroll <> mouseat And 
           *This = mouseat
          *Last = *Scroll
          *Scroll = mouseat
        EndIf
        
        Select EventType 
          Case #PB_EventType_Focus
            If \at       
              *Bar\Focus = *This
              repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
            EndIf
            
          Case #PB_EventType_LostFocus 
            If *Bar\Focus
              *Bar\Focus = 0 
              repaint | Events(*This, - 1, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
            EndIf
            
        EndSelect
        
        If *Scroll = *This
          If Last <> \at
            ;
            ; Debug ""+Last +" "+ *This\at +" "+ *This +" "+ *Last
            If Last > 0 Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, Last, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            If Not \at Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            
            If Not last ; Or (Last =- 1 And \at = 2 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
            If \at > 0
              repaint | Events(*This, \at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
            
            Last = \at
          EndIf
          
          Select EventType 
            Case #PB_EventType_MouseWheel
              Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta) ; bug in mac os
              
              If \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY, -WheelDelta)
              ElseIf *Bar\Focus
                repaint | Events(*Bar\Focus, - 1, EventType, MouseScreenX, MouseScreenY, WheelDelta)
              EndIf
              
            Case #PB_EventType_LeftButtonDown : mouseB = 1
              If \at
                If *Bar\Focus <> *This
                  If *Bar\Focus
                    repaint | Events(*Bar\Focus, \at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
                  EndIf
                  repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
                  *Bar\Focus = *This
                EndIf
                
                Down = \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
              
            Case #PB_EventType_LeftButtonUp : mouseB = 0
              If Down
                repaint | Events(*This, Down, EventType, MouseScreenX, MouseScreenY)
                Down = 0
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
          EndSelect
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i Updates(*v.Bar_S, *h.Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    
    Protected iWidth, iHeight
    
    If *v\Hide
      iWidth = *v\X+*v\Width
    Else
      iWidth = *v\X
    EndIf
    
    If *h\Hide 
      iHeight = *h\Y+*h\Height
    Else
      iHeight = *h\Y
    EndIf
    
    ; Вправо работает как надо
    If ScrollArea_Width<*h\Page\Pos+iWidth 
      ScrollArea_Width=*h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*h\Page\Pos And
           ScrollArea_Width=*h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*v\Page\Pos+iHeight
      ScrollArea_Height=*v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*v\Page\Pos And
           ScrollArea_Height=*v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *v\Max<>ScrollArea_Height : SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
    If *h\Max<>ScrollArea_Width : SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
    
    If *v\Page\Len<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Len<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    If *h\Hide
      *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + *h\Height) - *v\Y) 
    Else
      *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h\Y - *v\Y) 
    EndIf
    
    If *v\Hide
      *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, (*v\X + *v\Width) - *h\X, #PB_Ignore)
    Else
      *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, *v\X - *h\X, #PB_Ignore)
    EndIf
    
    If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.i Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i, *That.Bar_S=0)
    Protected Lines.i, ScrollPage.i
    
    If *That
      If Width=#PB_Ignore : Width = *This\X : Else : Width+x-*This\Width : EndIf
      If Height=#PB_Ignore : Height = *That\Y : Else : Height+y-*That\Height : EndIf
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, (*That\Y+Bool(*That\Hide) * *That\Height)-*This\y)
      SetAttribute(*That, #PB_ScrollBar_PageLength, (*This\X+Bool(*This\Hide) * *This\width)-*That\x)
      
      *This\Hide = Resize(*This, Width, Y, #PB_Ignore, Bool(*That\hide) * ((*That\Y+*That\Height)-*This\Y)) 
      *That\Hide = Resize(*That, X, Height, Bool(*This\hide) * ((*This\X+*This\Width)-*That\X), #PB_Ignore) 
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, (*That\Y+Bool(*That\Hide) * *That\Height)-*This\y)
      SetAttribute(*That, #PB_ScrollBar_PageLength, (*This\X+Bool(*This\Hide) * *This\width)-*That\x)
      
      ; 
      *This\Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(*That\hide) * ((*That\Y+*That\Height)-*This\Y))
      *That\Hide = Resize(*That, #PB_Ignore, #PB_Ignore, Bool(*This\hide) * ((*This\X+*This\Width)-*That\X), #PB_Ignore)
      
      If Not *This\Hide 
        Resize(*That, #PB_Ignore, #PB_Ignore, (*This\x-*That\x)+Bool(*This\Radius)*4, #PB_Ignore)
      EndIf
      If Not *That\Hide 
        Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*That\y-*This\y)+Bool(*That\Radius)*4)
      EndIf
      ProcedureReturn 1
      
      If y=#PB_Ignore : y = *This\Y : EndIf
      If x=#PB_Ignore : x = *That\X : EndIf
      If Width=#PB_Ignore : Width = *This\X-*That\X+*This\width : EndIf
      If Height=#PB_Ignore : Height = *That\Y-*This\Y+*That\height : EndIf
      
      ; Debug ""+Width +" "+ Str(*This\X-*That\X+*This\width)
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, Height - Bool(Not *That\hide) * *That\height) 
      SetAttribute(*That, #PB_ScrollBar_PageLength, Width - Bool(Not *This\hide) * *This\width)  
      
      ;       *This\Hide = Resize(*This, x+*That\Page\Len, #PB_Ignore, #PB_Ignore, *This\Page\len)
      ;       *That\Hide = Resize(*That, #PB_Ignore, y+*This\Page\len, *That\Page\len, #PB_Ignore)
      
      *This\Hide = Resize(*This, x+*That\Page\Len, y, #PB_Ignore, *This\Page\len)
      *That\Hide = Resize(*That, x, y+*This\Page\len, *That\Page\len, #PB_Ignore)
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, Height - Bool(Not *That\hide) * *That\height)
      SetAttribute(*That, #PB_ScrollBar_PageLength, Width - Bool(Not *This\hide) * *This\width)
      
      *This\Hide = Resize(*This, x+*That\Page\len, #PB_Ignore, #PB_Ignore, *This\Page\len + Bool(*This\Radius And Not *That\Hide)*4)
      *That\Hide = Resize(*That, #PB_Ignore, y+*This\Page\len, *That\Page\len + Bool(*That\Radius And Not *This\Hide)*4, #PB_Ignore)
      ProcedureReturn 1
      
      ;       If Width=#PB_Ignore 
      ;         Width = *This\X+*This\Width
      ;       EndIf
      ;       If Height=#PB_Ignore 
      ;         Height = *That\Y+*That\Height
      ;       EndIf
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, Height-Bool(Not *That\Hide) * *That\height)
      SetAttribute(*That, #PB_ScrollBar_PageLength, Width-Bool(Not *This\Hide) * *This\width)
      
      
      ;       *This\Hide = Resize(*This, x+*That\Page\Len, y, #PB_Ignore, *This\Page\len)
      ;      *That\Hide = Resize(*That, x, y+*This\Page\len, *That\Page\len, #PB_Ignore)
      ;       *This\Hide = Resize(*This, x+*That\Page\Len, y, #PB_Ignore, (*That\Y+Bool(*That\Hide) * *That\Height) - *This\Y)
      ;       *That\Hide = Resize(*That, x, y+*This\Page\len, (*This\X+Bool(*This\Hide) * *This\width) - *That\X, #PB_Ignore)
      
      *This\Hide = Resize(*This, Width+x-*This\Width, Y, #PB_Ignore, *This\Page\len)
      *That\Hide = Resize(*That, X, Height+y-*That\Height, *That\Page\len, #PB_Ignore)
      ;       *This\Hide = Resize(*This, Width+x-*This\Width, Y, #PB_Ignore, (*That\Y+Bool(*That\Hide) * *That\Height) - *This\Y)
      ;       *That\Hide = Resize(*That, X, Height+y-*That\Height, (*This\X+Bool(*This\Hide) * *This\width) - *That\X, #PB_Ignore)
      
      SetAttribute(*This, #PB_ScrollBar_PageLength, Height-Bool(Not *That\Hide) * *That\height)
      SetAttribute(*That, #PB_ScrollBar_PageLength, Width-Bool(Not *This\Hide) * *This\width)
      
      *This\Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*That\Y+Bool(*That\Hide) * *That\Height) - *This\Y) + Bool(*This\Radius And Not *That\Hide)*4)
      *That\Hide = Resize(*That, #PB_Ignore, #PB_Ignore, ((*This\X+Bool(*This\Hide) * *This\width) - *That\X) + Bool(*That\Radius And Not *This\Hide)*4, #PB_Ignore)
      
      
      
      ;     If Not *This\Hide 
      ;       ; Если есть вертикальная и горизонтальная полоса,
      ;       ; то окрашиваем прамоугольник между ними
      ;       *That\Width = Width
      ;     EndIf
      ;     If Not *That\Hide 
      ;       ; Если есть вертикальная и горизонтальная полоса,
      ;       ; то окрашиваем прамоугольник между ними
      ;       *This\Height = Height
      ;     EndIf
      
      
      ProcedureReturn 1
    Else
      If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And
                  Width=#PB_Ignore And Height=#PB_Ignore)
        *Bar\Handle = *This
        *Bar\Event = #PB_EventType_Resize
      EndIf
      
      With *This
        \hide[1] = Bool(Not ((\Max-\Min) > \Page\Len))
        Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
        
        ; Set scroll bar coordinate
        If X=#PB_Ignore : X = \X : Else : \X = X : EndIf 
        If Y=#PB_Ignore : Y = \Y : Else : \Y = Y : EndIf 
        If Width=#PB_Ignore : Width = \Width : Else : \Width = Width : EndIf 
        If Height=#PB_Ignore : Height = \Height : Else : \Height = Height : EndIf
        
        If Not \hide
          If \Vertical
            \Area\Pos = Y+\Button\len
            \Area\len = (Height-\Button\len*2)
          Else
            \Area\Pos = X+\Button\len
            \Area\len = (Width-\Button\len*2)
          EndIf
          
          If \Area\len
            \Thumb\len = ThumbLength(*This)
            
            If (\Area\len > \Button\len)
              If \Button\len
                If (\Thumb\len < \Button\len)
                  \Area\len = Round(\Area\len - (\Button\len-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \Button\len 
                EndIf
              Else
                If ( \Thumb\len < 7)
                  \Area\len = Round( \Area\len - (7-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = 7
                EndIf
              EndIf
            Else
              \Thumb\len = \Area\len 
            EndIf
            
            If \Area\len > 0
              If IsStop(*This) And Bool(\Type <> #PB_GadgetType_TrackBar)
                SetState(*This, \Max)
              EndIf
              
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
            EndIf
          EndIf
        EndIf
        
        If \Vertical
          \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\len                   ; Top button coordinate on scroll bar
          \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\len : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
          \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len           ; Thumb coordinate on scroll bar
        Else
          \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\len : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
          \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\len : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
          \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len          ; Thumb coordinate on scroll bar
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
      
    EndIf
  EndProcedure
  
  Procedure.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Radius = Radius
      \Type = #PB_GadgetType_ScrollBar
      \Vertical = Bool(Flag&#PB_ScrollBar_Vertical)
      
      \ArrowSize[1] = 4
      \ArrowSize[2] = 4
      \ArrowType[1] =- 1 ; -1 0 1
      \ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \Color\State = 0
      \Color\Back = $FFF9F9F9
      \Color\Frame = \Color\Back
      \Color\Line = $FFFFFFFF
      
      \Color[1] = *Bar\Color 
      \Color[2] = *Bar\Color 
      \Color[3] = *Bar\Color 
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      
      If Not Bool(Flag&#PB_ScrollBar_NoButtons)
        If \Vertical
          If width < 21
            \Button\len = width - 1
          Else
            \Button\len = 17
          EndIf
        Else
          If height < 21
            \Button\len = height - 1
          Else
            \Button\len = 17
          EndIf
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #PB_ScrollBar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_ScrollBar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_ScrollBar_PageLength, Pagelength) : EndIf
      
      If Bool(Flag&#PB_ScrollBar_Inverted)
        SetAttribute(*This, #PB_ScrollBar_Inverted, 1) 
      EndIf
      
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
EndModule

Macro EventWidget()
  Bar::*Bar\Handle
EndMacro

Macro WidgetEvent()
  Bar::*Bar\Event
EndMacro


;-
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
    Structure Scroll_S 
      *v.Bar::Bar_S
      *h.Bar::Bar_S
    EndStructure
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=101,y=101, Width=600, Height=600 
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FFFFFF)
      StopDrawing()
    EndIf
  EndIf
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Bar::Resize(*Scroll\v, x, y, Width-x*2, Height-y*2, *Scroll\h)
        ;  Bar::Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
        
    EndSelect
    
    Repaint | Bar::CallBack(*Scroll\v, EventType, mouseX,mouseY)
    Repaint | Bar::CallBack(*Scroll\h, EventType, mouseX,mouseY)
    
    If Not (*Scroll\v\at Or *Scroll\h\at)
      Select EventType
        Case #PB_EventType_LeftButtonDown
          Debug "#PB_EventType_LeftButtonDown "
          Bar::SetAttribute(*Scroll\h, Bar::#PB_ScrollBar_Inverted, *Scroll\h\Inverted!1)
          
          Repaint = 1
      EndSelect
    EndIf
    
    If *Scroll\v\Change
      ; An example showing the sending of messages in a vertical scrollbar.
      PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\v, #PB_EventType_ScrollChange, *Scroll\v\Direction) 
      
      ; An example showing the sending of messages to the gadget of both scrollbars.
      PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\v\Direction) 
;       *Scroll\v\Change = 0
    EndIf
    
    If *Scroll\h\Change
      ; An example showing the sending of messages in a horizontal scrollbar.
      PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\h, #PB_EventType_ScrollChange, *Scroll\h\Direction) 
      
      ; An example showing the sending of messages to the gadget of both scrollbars.
      PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\h\Direction) 
;       *Scroll\h\Change = 0
    EndIf
    
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      ; back ground
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,Width,Height, $FFFFFF)
      
      ;       
      If Bar::IsStop(*Scroll\v)
        *Scroll\h\Color\Line = 0
      Else
        *Scroll\h\Color\Line = $FFFFFF
      EndIf
      
      If Bar::IsStop(*Scroll\h)
        *Scroll\v\Color\Line = 0
      Else
        *Scroll\v\Color\Line = $FFFFFF
      EndIf
      
      ClipOutput(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Page\len, *Scroll\v\Page\len)
      ;DrawImage(ImageID(0), *Scroll\h\x-*Scroll\h\Page\Pos, *Scroll\v\y-*Scroll\v\Page\Pos)
      DrawImage(ImageID(0), *Scroll\h\x-Bar::GetState(*Scroll\h), *Scroll\v\y-Bar::GetState(*Scroll\v))
      UnclipOutput()
      
      Bar::Draw(*Scroll\v)
      Bar::Draw(*Scroll\h)
      
      ; frame 
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*Scroll\h\x-1,*Scroll\v\y-1,
          2 + Bool(*Scroll\v\hide) * *Scroll\h\Page\len + Bool(Not *Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\width)-*Scroll\h\x),
          2 + Bool(*Scroll\h\hide) * *Scroll\v\Page\len + Bool(Not *Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\height)-*Scroll\v\y), $0000FF)
      ;       ; 
      ;       Box(x, y, Width-x*2, Height-y*2, $0000FF)
      
      ; Scroll area coordinate ; (*Scroll\v\x-*Scroll\h\x)
      ;Box(*Scroll\h\x-*Scroll\h\Page\Pos, *Scroll\v\y-*Scroll\v\Page\Pos, *Scroll\h\Max, *Scroll\v\Max, $FF0000)
      ;Debug Str(((*Scroll\h\Max-*Scroll\h\Page\len)-*Scroll\h\Page\Pos))
      Box(*Scroll\h\x-Bar::GetState(*Scroll\h), *Scroll\v\y-Bar::GetState(*Scroll\v), *Scroll\h\Max, *Scroll\v\Max, $FF0000)
      
      ; area coordinate
      Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Page\Len, *Scroll\v\Page\Len, $00FF00)
      
      StopDrawing()
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
  
  Procedure Widget_Events()
    Select EventType()
      Case #PB_EventType_ScrollChange
        Debug ""+EventData() +" - "+ EventGadget()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1, 10,10, Width, Height, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
    ; Create both scroll bars
    *Scroll\v = Bar::Bar(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
    *Scroll\h = Bar::Bar(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
    
    ;Bar::SetAttribute(*Scroll\v, Bar::#PB_ScrollBar_Inverted, 1)
    
    ; Set scroll page position
    Bar::SetState(*Scroll\v, 70)
    Bar::SetState(*Scroll\h, 55)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @Canvas_CallBack())
    
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, *Scroll\v)
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, *Scroll\h)
    
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, 1)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ----8------+v---0------v--------------
; EnableXP