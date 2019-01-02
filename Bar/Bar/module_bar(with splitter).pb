
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
  
;   ;- - Splitter_S
;   Structure Splitter_S Extends Coordinate_S
;     Type.i
;   EndStructure
  
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    *s.Scroll_S
    
    ; for splitter
    *First.Bar_S 
    *Second.Bar_S
    
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
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    Ticks.b
    Smooth.b
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Event_S
  Structure Post_S
    Gadget.i
    Window.i
    Type.i
    Event.i
    *Function
    *Widget.Bar_S
    *Active.Bar_S
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    Post.Post_S
    
    *v.Bar_S
    *h.Bar_S
  EndStructure
  
  ;-
  ;- - CONSTANTs
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #PB_Gadget_FrameColor = 10
  
  #PB_ScrollBar_Direction = 1<<2
  #PB_ScrollBar_NoButtons = 1<<3
  #PB_ScrollBar_Inverted = 1<<4
  
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
  
  
  Global *Bar.Post_S
  
  ;-
  ;- - DECLAREs MACROs
  Macro X(_this_) 
    (_this_\X + Bool(_this_\hide[1] Or Not _this_\color\alpha) * _this_\Width) 
  EndMacro
  Macro Y(_this_) 
    (_this_\Y + Bool(_this_\hide[1] Or Not _this_\color\alpha) * _this_\Height) 
  EndMacro
  Macro Width(_this_) 
    (Bool(Not _this_\hide[1] And _this_\color\alpha) * _this_\Width) 
  EndMacro
  Macro Height(_this_) 
    (Bool(Not _this_\hide[1] And _this_\color\alpha) * _this_\Height) 
  EndMacro
  
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
  
  ;-
  ;- - DECLAREs
  Declare.i Draw(*This.Bar_S)
  Declare.i GetState(*This.Bar_S)
  Declare.i SetState(*This.Bar_S, ScrollPos.i)
  Declare.i GetAttribute(*This.Bar_S, Attribute.i)
  Declare.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
  Declare.i CallBack(*This.Bar_S, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This.Bar_S, iX.i,iY.i,iWidth.i,iHeight.i);, *That.Bar_S=#Null)
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
  
  Declare.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
  Declare.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.i Draws(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
  Declare.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
EndDeclareModule

Module Bar
  ;- MODULE
  #PB_Bar_Ticks = 1<<5
  #PB_Bar_Smooth = 1<<6
  
  *Bar = AllocateStructure(Post_S)
  *Bar\Type =- 1
  
  Global Colors.Color_S
  
  With Colors                          
    \State = 0
    ; - Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
  EndWith
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min)) * ((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest) : If _this_\Thumb\Len > _this_\Area\Len : _this_\Thumb\Len = _this_\Area\Len : EndIf : If _this_\Vertical : _this_\Height[3] = _this_\Thumb\len : Else : _this_\Width[3] = _this_\Thumb\len : EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Thumb\Pos < _this_\Area\Pos : _this_\Thumb\Pos = _this_\Area\Pos : EndIf : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : Else : _this_\X[3] = _this_\Thumb\Pos : EndIf
  EndMacro
  
  Procedure.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Style.b = 1, Length.i = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Style),((Y+1)+i),((X+2)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Style),(((Y+1)+(Size*2))-i),((X+2)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
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
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If Value>Max 
        Value=Max 
      EndIf
    EndIf
    
    ProcedureReturn Value
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
  Procedure.i ResizeSplitter(*This.Bar_S, First, Second)
    With *This
      If \Vertical
        If First > 0 And IsGadget(First)
          ResizeGadget(First, \x, \y, \width, \Thumb\Pos-\y)
        Else
          Resize(First, \x, \y, \width, \Thumb\Pos-\y)
        EndIf
        If Second > 0 And IsGadget(Second)
          ResizeGadget(Second, \x, \Thumb\Pos+\Thumb\len, \width, \Height-((\Thumb\Pos+\Thumb\len)-\y))
        Else
          Resize(Second, \x, \Thumb\Pos+\Thumb\len, \width, \Height-((\Thumb\Pos+\Thumb\len)-\y))
        EndIf
      Else
        If First > 0 And IsGadget(First)
          ResizeGadget(First, \x, \y, \Thumb\Pos-\x, \height)
        Else
          Resize(First, \x, \y, \Thumb\Pos-\x, \height)
        EndIf
        If Second > 0 And IsGadget(Second)
          ResizeGadget(Second, \Thumb\Pos+\Thumb\len, \y, \width-((\Thumb\Pos+\Thumb\len)-\x), \height)
        Else
          Resize(Second, \Thumb\Pos+\Thumb\len, \y, \width-((\Thumb\Pos+\Thumb\len)-\x), \height)
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i DrawProgress(*This.Bar_S)
    Protected Alpha.i
    
    With *This 
      Alpha = \color\alpha<<24
      
      ; draw background
      If \Color[3]\Back<>-1
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+3,\Y+3,\Width-6,\height-6, \Radius, \Radius,\Color[3]\Back&$FFFFFF|Alpha)
      EndIf
      
      ; 3 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X+2, \Y+2, \Width-4, \Height-4, \Radius, \Radius, \Color[3]\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw progress
      ;If \Thumb\Pos
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,\height-\Thumb\Pos, \Radius, \Radius,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,\Thumb\Pos-\x,\height-4, \Radius, \Radius,\Color[3]\Back[2])
      EndIf
      ;EndIf
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X+1, \Y+1, \Width-2, \Height-2, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      EndIf
      ; 1 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color[3]\Frame&$FFFFFF|Alpha)
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i DrawSplitter(*This.Bar_S)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor = $686868, Color = $686868
    
    With *This
      If *This > 0
        If Not IsGadget(\First)
          Protected Splitter1 = Bool(\First\Type = #PB_GadgetType_Splitter)
        EndIf
        If Not IsGadget(\Second)
          Protected Splitter2 = Bool(\Second\Type = #PB_GadgetType_Splitter)
        EndIf
        
        IsVertical = Bool(Not \Vertical)
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        ; Позиция сплиттера 
        Size = \Thumb\len-2
        If IsVertical
          Pos = \Thumb\Pos-x+1
        Else
          Pos = \Thumb\Pos-y+1
        EndIf
        ;       If IsVertical
        ;         If (Pos<Width/2) : Pos+1 : EndIf
        ;       Else
        ;         If (Pos<Height/2) : Pos+1 : EndIf
        ;       EndIf
        
        Protected Radius.d = 2.0 ; Size/2
        DrawingMode(#PB_2DDrawing_Outlined) 
        ;Box(X,Y,Width,Height,Color)
        Protected Border=1, Circle=1, Separator=0
        
        fColor = 0;\Color[3]\Frame[0]
        If Border
          If IsVertical
            If Not Splitter1
              Box(X,Y,Pos-1,Height,fColor) 
            EndIf 
            If Not Splitter2
              Box(X+(Pos+Size+1), Y,(Width-(Pos+Size))-1,Height,fColor)
            EndIf
          Else
            If Not Splitter1
              Box(X,Y,Width,Pos-1,fColor) 
            EndIf
            If Not Splitter2
              Box( X,Y+(Pos+Size+1),Width,(Height-(Pos+Size))-1,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = 0;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined) 
          If IsVertical
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          Else
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined) 
          If IsVertical
            ;Box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,Color)
          Else
            ;Box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,Color)
          EndIf
        EndIf
        
        ;       If \Vertical
        ;         Box(X,Y,Width,Height/2,$0000FF)
        ;       Else
        ;         Box(X,Y,Width/2,Height,$0000FF)
        ;       EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i DrawScroll(*This.Bar_S)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
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
      
    EndWith
  EndProcedure
  
  Procedure.i DrawTrack(*This.Bar_S)
    With *This 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\X[0],*This\Y[0],*This\Width[0],*This\Height[0],\Color[0]\Back)
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0]+5,\Y[0],a,\Height[0],\Color[3]\Frame)
        Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,\height-\Thumb\Pos,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0],\Y[0]+5,\Width[0],a,\Color[3]\Frame)
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
      
      If \Ticks
        Protected PlotStep = (\width)/(\Max-\Min)
        
        For i=3 To (\Width-PlotStep)/2 
          If Not ((\X+i-3)%PlotStep)
            Box(\X+i, \Y[3]+\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
        For i=\Width To (\Width-PlotStep)/2+3 Step - 1
          If Not ((\X+i-6)%PlotStep)
            Box(\X+i, \Y[3]+\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw(*This.Bar_S)
    If *This > 0
      With *This
        If *This > 0 And Not \hide And \color\alpha
          Select \Type
            Case #PB_GadgetType_TrackBar : DrawTrack(*This)
            Case #PB_GadgetType_ScrollBar : DrawScroll(*This)
            Case #PB_GadgetType_Splitter : DrawSplitter(*This)
            Case #PB_GadgetType_ProgressBar : DrawProgress(*This)
          EndSelect
        EndIf
        
        ; reset 
        \Change = 0
        *Bar\Type =- 1 
        *Bar\Widget = 0
      EndWith 
    EndIf
  EndProcedure
  
  Procedure.i Draws(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
    ;     Protected Repaint
    
    With *Scroll
      UnclipOutput()
      If \v And \v\page\len And \v\max<>ScrollHeight And 
         SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollHeight)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      If \h And \h\page\len And \h\max<>ScrollWidth And
         SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollWidth)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \v And Not \v\hide
        Draw(\v)
      EndIf
      If \h And Not \h\hide
        Draw(\h)
      EndIf
      
      
      DrawingMode(#PB_2DDrawing_Outlined)
      ; max coordinate
      Box(*Scroll\h\x-GetState(*Scroll\h), *Scroll\v\y-GetState(*Scroll\v), *Scroll\h\Max, *Scroll\v\Max, $FF0000)
      
      ; page coordinate
      Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Page\Len, *Scroll\v\Page\Len, $00FF00)
      
      ; area coordinate
      Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Area\Len, *Scroll\v\Area\Len, $00FFFF)
      
      ; scroll coordinate
      Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\width, *Scroll\v\height, $FF00FF)
      
      ; frame coordinate
      Box(*Scroll\h\x, *Scroll\v\y, 
          *Scroll\h\Page\len + (Bool(Not *Scroll\v\hide) * *Scroll\v\width),
          *Scroll\v\Page\len + (Bool(Not *Scroll\h\hide) * *Scroll\h\height), $FFFF00)
      
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  ;-
;   Procedure.i ResizeWidget(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
;     
;     With *This
;       If X<>#PB_Ignore And 
;          \X[0] <> X
;         \X[0] = X 
;         \X[2]=\X[0]+\bSize
;         \X[1]=\X[2]-\fSize
;         \Resize = 1<<1
;       EndIf
;       If Y<>#PB_Ignore And 
;          \Y[0] <> Y
;         \Y[0] = Y
;         \Y[2]=\Y[0]+\bSize
;         \Y[1]=\Y[2]-\fSize
;         \Resize = 1<<2
;       EndIf
;       If Width<>#PB_Ignore And
;          \Width[0] <> Width 
;         \Width[0] = Width 
;         \Width[2] = \Width[0]-\bSize*2
;         \Width[1] = \Width[2]+\fSize*2
;         \Resize = 1<<3
;       EndIf
;       If Height<>#PB_Ignore And 
;          \Height[0] <> Height
;         \Height[0] = Height 
;         \Height[2] = \Height[0]-\bSize*2
;         \Height[1] = \Height[2]+\fSize*2
;         \Resize = 1<<4
;       EndIf
;       
;       ProcedureReturn \Resize
;     EndWith
;   EndProcedure
  
  Procedure.i GetState(*This.Bar_S)
    ProcedureReturn Invert(*This, *This\Page\Pos, *This\Inverted)
  EndProcedure
  
  Procedure.i SetState(*This.Bar_S, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This > 0
        If (\Vertical And \Type = #PB_GadgetType_TrackBar)
          ScrollPos = Invert(*This, ScrollPos, \Inverted)
        EndIf
        
        If ScrollPos < \Min
          ScrollPos = \Min 
        EndIf
        
        If ScrollPos > \Max-\Page\len
          If \Max > \Page\len 
            ScrollPos = \Max-\Page\len
          Else
            ScrollPos = \Min 
          EndIf
        EndIf
        
        If \Page\Pos <> ScrollPos 
          \Thumb\Pos = ThumbPos(*This, ScrollPos)
          
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
          
          *Bar\Widget = *This
          *Bar\Type = #PB_EventType_Change
          \Page\Pos = ScrollPos
          \Change = 1
          
          If \Type = #PB_GadgetType_Splitter
            ResizeSplitter(*This, \First, \Second)
          EndIf
          
          ;           If \s
          ;             Debug \s
          ;             If \Vertical
          ;               \s\y =- \Page\Pos
          ;             Else
          ;               \s\x =- \Page\Pos
          ;             EndIf
          ;             
          ;             If \s\Post\event
          ;               If \s\Post\widget
          ;                 PostEvent(\s\Post\event, \s\Post\window, \s\Post\widget, #PB_EventType_ScrollChange, \Direction) 
          ;               Else
          ;                 PostEvent(\s\Post\event, \s\Post\window, \s\Post\gadget, #PB_EventType_ScrollChange, \Direction) 
          ;               EndIf
          ;             EndIf
          ;           EndIf
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*This.Bar_S, Attribute.i)
    Protected Result.i
    
    With *This
      If *This > 0
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
      If *This > 0
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
            
          Case #PB_ScrollBar_Minimum ; 1 -m&l
            If \Min <> Value 
              \Min = Value
              \Page\Pos + Value
              
              If \Page\Pos > \Max-\Page\len
                If \Max > \Page\len 
                  \Page\Pos = \Max-\Page\len
                Else
                  \Page\Pos = \Min 
                EndIf
              EndIf
              
              If \Max > \Min
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                \Thumb\len = ThumbLength(*This)
              Else
                \Thumb\Pos = \Area\Pos
                \Thumb\len = \Area\len
                
                If \Vertical 
                  \Y[3] = \Thumb\Pos  
                  \Height[3] = \Thumb\len
                Else 
                  \X[3] = \Thumb\Pos 
                  \Width[3] = \Thumb\len
                EndIf
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_ScrollBar_Maximum ; 2 -m&l
            If \Max <> Value
              \Max = Value
              
              If \Page\len > \Max 
                \Page\Pos = \Min
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              EndIf
              
              If \Max > \Min
                \Thumb\len = ThumbLength(*This)
              Else
                \Thumb\len = \Area\len
                
                If \Vertical 
                  \Height[3] = \Thumb\len
                Else 
                  \Width[3] = \Thumb\len
                EndIf
              EndIf
              
              If \Step = 0
                \Step = 1
              EndIf
              ProcedureReturn 1
            EndIf
            
          Case #PB_ScrollBar_PageLength ; 3 -m&l
            If \Page\len <> Value
              If Value > (\Max-\Min)
                If \Max = 0 
                  \Max = Value 
                EndIf
                Value = (\Max-\Min)
                
                \Page\Pos = \Min
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              EndIf
              \Page\len = Value
              
              \Thumb\len = ThumbLength(*This)
              
              If \Step = 0
                \Step = 1
              EndIf
              If \Step < 2 And \Page\len
                \Step = (\Max-\Min) / \Page\len 
              EndIf
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
  
  Procedure.i Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i);, *That.Bar_S=#Null)
    Protected Lines.i, ScrollPage.i
    
    If *This > 0
      If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And Width=#PB_Ignore And Height=#PB_Ignore)
        *Bar\Widget = *This
        *Bar\Type = #PB_EventType_Resize
      EndIf
      
      With *This
;         If *This <> *That And *That And *That\hide
;           If \Vertical
;             If Height=#PB_Ignore 
;               Height=(*That\Y+*That\Height)-\Y 
;             EndIf
;           Else
;             If Width=#PB_Ignore
;               Width=(*That\X+*That\Width)-\X 
;             EndIf
;           EndIf
;         EndIf
        
        \hide[1] = Bool(Not ((\Max-\Min) > \Page\Len)) ; Bool(Not (\Page\Len And (\Max-\Min) > \Page\len));
        Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
        
        ; Set scroll bar coordinate
        If X=#PB_Ignore : X = \X : Else : \X = X : \Resize = 1<<1 : EndIf 
        If Y=#PB_Ignore : Y = \Y : Else : \Y = Y : \Resize = 1<<2 : EndIf 
        If Width=#PB_Ignore : Width = \Width : Else : \Width = Width : \Resize = 1<<3 : EndIf 
        If Height=#PB_Ignore : Height = \Height : Else : \Height = Height : \Resize = 1<<4 : EndIf
        
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
                If (\Thumb\len < 7) And (\Type <> #PB_GadgetType_ProgressBar)
                  \Area\len = Round(\Area\len - (7-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = 7
                EndIf
              EndIf
            Else
              \Thumb\len = \Area\len 
            EndIf
            
            If \Area\len > 0
              If IsStop(*This) And (\Type <> #PB_GadgetType_TrackBar)
                SetState(*This, \Max)
              EndIf
              
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
            EndIf
          EndIf
        EndIf
        
        If \Vertical
          If \Button\len
            \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\len                   ; Top button coordinate on scroll bar
            \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\len : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
          EndIf
          \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len           ; Thumb coordinate on scroll bar
        Else
          If \Button\len
            \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\len : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
            \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\len : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
          EndIf
          \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len          ; Thumb coordinate on scroll bar
        EndIf
        
        If \Type = #PB_GadgetType_Splitter
          ResizeSplitter(*This, \First, \Second)
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*Scroll\v)-(*Scroll\v\Width-*Scroll\v\Radius/2)+1, iHeight = Y(*Scroll\h)-(*Scroll\h\Height-*Scroll\h\Radius/2)+1
    Static hPos, vPos : vPos = *Scroll\v\Page\Pos : hPos = *Scroll\h\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*Scroll\h\Page\Pos+iWidth 
      ScrollArea_Width=*Scroll\h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*Scroll\h\Page\Pos And
           ScrollArea_Width=*Scroll\h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*Scroll\v\Page\Pos+iHeight
      ScrollArea_Height=*Scroll\v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*Scroll\v\Page\Pos And
           ScrollArea_Height=*Scroll\v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*Scroll\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*Scroll\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *Scroll\v\max<>ScrollArea_Height : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
    If *Scroll\h\max<>ScrollArea_Width : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
    
    If *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*Scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*Scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
;     *Scroll\v\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
;     *Scroll\h\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
    *Scroll\v\Hide = Bar::Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\Y + Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y) ; #PB_Ignore, *Scroll\h) 
    *Scroll\h\Hide = Bar::Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\X + Bool(*Scroll\v\Hide) * *Scroll\v\Width) - *Scroll\h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, *Scroll\v)
    
    If *Scroll\v\hide : *Scroll\v\Page\Pos = 0 : If vPos : *Scroll\v\hide = vPos : EndIf : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = iWidth+*Scroll\v\Width : EndIf
    If *Scroll\h\hide : *Scroll\h\Page\Pos = 0 : If hPos : *Scroll\h\hide = hPos : EndIf : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = iHeight+*Scroll\h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    
    ;     If Width=#PB_Ignore : Width = *Scroll\v\X : Else : Width+x-*Scroll\v\Width : EndIf
    ;       If Height=#PB_Ignore : Height = *Scroll\h\Y : Else : Height+y-*Scroll\h\Height : EndIf
    ;       
    ;       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height)-*Scroll\v\y)
    ;       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width)-*Scroll\h\x)
    ;       
    ;       *Scroll\v\Hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, Bool(*Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\Height)-*Scroll\v\Y)) 
    ;       *Scroll\h\Hide = Resize(*Scroll\h, X, Height, Bool(*Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\Width)-*Scroll\h\X), #PB_Ignore) 
    ;       
    ;       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height)-*Scroll\v\y)
    ;       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width)-*Scroll\h\x)
    ;       
    ;       ; 
    ;       *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(*Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\Height)-*Scroll\v\Y))
    ;       *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, Bool(*Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\Width)-*Scroll\h\X), #PB_Ignore)
    ;       
    ;       If Not *Scroll\v\Hide 
    ;         Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore)
    ;       EndIf
    ;       If Not *Scroll\h\Hide 
    ;         Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4)
    ;       EndIf
    ;       
    ;      Debug ""+Width +" "+ *Scroll\h\Page\len
    ;        *Scroll\Width[2] = x(*Scroll\v)-*Scroll\h\x ; *Scroll\h\Page\len ;
    ;     *Scroll\Height[2] = y(*Scroll\h)-*Scroll\v\y  ; *Scroll\v\Page\len ;(*Scroll\h\Y + Bool(Not *Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\y;
    ;     ProcedureReturn 1
    
    If y=#PB_Ignore : y = *Scroll\v\Y : EndIf
    If x=#PB_Ignore : x = *Scroll\h\X : EndIf
    If Width=#PB_Ignore : Width = *Scroll\v\X-*Scroll\h\X+*Scroll\v\width : EndIf
    If Height=#PB_Ignore : Height = *Scroll\h\Y-*Scroll\v\Y+*Scroll\h\height : EndIf
    
    ;       If *Scroll\h\Max < *Scroll\width ; Width-Bool(Not *Scroll\v\Hide) * *Scroll\v\width
    ;         *Scroll\h\Max = *Scroll\width ; Width-Bool(Not *Scroll\v\Hide) * *Scroll\v\width
    ;       EndIf
    ;       If *Scroll\v\Max < Height-Bool(Not *Scroll\h\Hide) * *Scroll\h\height
    ;         *Scroll\v\Max = Height-Bool(Not *Scroll\h\Hide) * *Scroll\h\height
    ;       EndIf
    
    ;       ; Debug ""+Width +" "+ Str(*Scroll\v\X-*Scroll\h\X+*Scroll\v\width)
    ;       
    ;       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, Height - Bool(Not *Scroll\h\hide) * *Scroll\h\height) 
    ;       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, Width - Bool(Not *Scroll\v\hide) * *Scroll\v\width)  
    ;       
    ;       *Scroll\v\Hide = Resize(*Scroll\v, x+*Scroll\h\Page\Len, y, #PB_Ignore, *Scroll\v\Page\len)
    ;       *Scroll\h\Hide = Resize(*Scroll\h, x, y+*Scroll\v\Page\len, *Scroll\h\Page\len, #PB_Ignore)
    ;       
    ;       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, Height - Bool(Not *Scroll\h\hide) * *Scroll\h\height)
    ;       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, Width - Bool(Not *Scroll\v\hide) * *Scroll\v\width)
    ;       
    ;       *Scroll\v\Hide = Resize(*Scroll\v, x+*Scroll\h\Page\len, #PB_Ignore, #PB_Ignore, *Scroll\v\Page\len + Bool(*Scroll\v\Radius And Not *Scroll\h\Hide)*4)
    ;       *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, y+*Scroll\v\Page\len, *Scroll\h\Page\len + Bool(*Scroll\h\Radius And Not *Scroll\v\Hide)*4, #PB_Ignore)
    ;       
    ;       *Scroll\Width[2] = *Scroll\h\Page\len ;  x(*Scroll\v)-*Scroll\h\x ; 
    ;       *Scroll\Height[2] =*Scroll\v\Page\len ;  y(*Scroll\h)-*Scroll\v\y  ; *Scroll\v\Page\len ;(*Scroll\h\Y + Bool(Not *Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\y;
    ;       ProcedureReturn 1
    
    ;       If Width=#PB_Ignore 
    ;         Width = *Scroll\v\X+*Scroll\v\Width
    ;       EndIf
    ;       If Height=#PB_Ignore 
    ;         Height = *Scroll\h\Y+*Scroll\h\Height
    ;       EndIf
    
    SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, Height-Bool(Not *Scroll\h\Hide) * *Scroll\h\height)
    SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, Width-Bool(Not *Scroll\v\Hide) * *Scroll\v\width)
    
    ;       *Scroll\v\Hide = Resize(*Scroll\v, x+*Scroll\h\Page\Len, y, #PB_Ignore, *Scroll\v\Page\len)
    ;      *Scroll\h\Hide = Resize(*Scroll\h, x, y+*Scroll\v\Page\len, *Scroll\h\Page\len, #PB_Ignore)
    ;       *Scroll\v\Hide = Resize(*Scroll\v, x+*Scroll\h\Page\Len, y, #PB_Ignore, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y)
    ;       *Scroll\h\Hide = Resize(*Scroll\h, x, y+*Scroll\v\Page\len, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X, #PB_Ignore)
    
    *Scroll\v\Hide = Resize(*Scroll\v, Width+x-*Scroll\v\Width, Y, #PB_Ignore, *Scroll\v\Page\len)
    *Scroll\h\Hide = Resize(*Scroll\h, X, Height+y-*Scroll\h\Height, *Scroll\h\Page\len, #PB_Ignore)
    ;       *Scroll\v\Hide = Resize(*Scroll\v, Width+x-*Scroll\v\Width, Y, #PB_Ignore, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y)
    ;       *Scroll\h\Hide = Resize(*Scroll\h, X, Height+y-*Scroll\h\Height, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X, #PB_Ignore)
    
    SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, Height-Bool(Not *Scroll\h\Hide) * *Scroll\h\height)
    SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, Width-Bool(Not *Scroll\v\Hide) * *Scroll\v\width)
    
    ;        *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y) + Bool(*Scroll\v\Radius And Not *Scroll\h\Hide)*4)
    ;       *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, ((*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X) + Bool(*Scroll\h\Radius And Not *Scroll\v\Hide)*4, #PB_Ignore)
    ;      *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y))
    ;       *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, ((*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X), #PB_Ignore)
    
    *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v\Page\len)
    *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, *Scroll\h\Page\len, #PB_Ignore)
    
    ;       *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(*Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\Height)-*Scroll\v\Y))
    ;       *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, Bool(*Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\Width)-*Scroll\h\X), #PB_Ignore)
    
    If Not *Scroll\v\Hide 
      *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore)
    EndIf
    If Not *Scroll\h\Hide 
      *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4)
    EndIf
    ;;; Debug *Scroll\v\Page\len
    
    ;       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, ((*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y))
    ;       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, ((*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X))
    
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i Events(*This.Bar_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    If *This > 0
      
      *Bar\Widget = *This
      *Bar\Type = EventType
      
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
              Case 3                                                  ; Thumb button
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
            Else
              If \Type = #PB_GadgetType_Splitter And at <> 3
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
              EndIf
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
              
              If \Type = #PB_GadgetType_Splitter And at = 3
                If Not \Vertical
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
                Else
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_UpDown)
                EndIf
              EndIf
              
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
      
      If *This > 0 And Not \hide And \color\alpha
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
              *Bar\Active = *This
              repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
            EndIf
            
          Case #PB_EventType_LostFocus 
            If *Bar\Active
              *Bar\Active = 0 
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
              ElseIf *Bar\Active
                repaint | Events(*Bar\Active, - 1, EventType, MouseScreenX, MouseScreenY, WheelDelta)
              EndIf
              
            Case #PB_EventType_LeftButtonDown : mouseB = 1
              If \at
                If *Bar\Active <> *This
                  If *Bar\Active
                    repaint | Events(*Bar\Active, \at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
                  EndIf
                  repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
                  *Bar\Active = *This
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
  
  Procedure.i _CallBack(*This.Bar_S, EventType.i, mouseX=0, mouseY=0) ; scroll
    Protected repaint
    Static Last, Down, *Scroll.Bar_S, *Last.Bar_S, mouseB, mouseat, Buttons
    
    With *This
      If *This > 0 And Not \hide And \color\alpha ; And \Type = #PB_GadgetType_ScrollBar
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
        
        If Not mouseX
          mouseX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
        EndIf
        If Not mouseY
          mouseY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
        EndIf
        
        ; get at point buttons
        If mouseB Or Buttons
        ElseIf (mouseX>=\X And mouseX<\X+\Width And mouseY>\Y And mouseY=<\Y+\Height) 
          If (mouseX>\X[1] And mouseX=<\X[1]+\Width[1] And  mouseY>\Y[1] And mouseY=<\Y[1]+\Height[1])
            \at = 1
          ElseIf (mouseX>\X[3] And mouseX=<\X[3]+\Width[3] And mouseY>\Y[3] And mouseY=<\Y[3]+\Height[3])
            \at = 3
          ElseIf (mouseX>\X[2] And mouseX=<\X[2]+\Width[2] And mouseY>\Y[2] And mouseY=<\Y[2]+\Height[2])
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
              If \Vertical
                If \s And \s\h And \s\h\at
                  If \s\h\at > 0
                    repaint | Events(\s\h, \s\h\at, EventType, mouseX, mouseY)
                  EndIf
                  repaint | Events(\s\h, - 1, EventType, mouseX, mouseY)
                  If EventType = #PB_EventType_MouseLeave
                    *Scroll = 0
                  EndIf
                  
                  \s\h\at = 0
                EndIf
              EndIf     
              
              EventType = #PB_EventType_MouseMove
          EndSelect
          
          If \Vertical
            If \s And \s\h And \s\h\at
              If \Color[2]\State
                repaint | Events(*This, \at, #PB_EventType_MouseLeave, mouseX, mouseY)
                ;                   repaint | Events(*This, - 1, #PB_EventType_MouseLeave)
                ;                   repaint | Events(\s\h, - 1, #PB_EventType_MouseEnter)
                repaint | Events(\s\h, \s\h\at, #PB_EventType_MouseEnter, mouseX, mouseY)
                \Color[2]\State = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          Else
            If \s And \s\v And \s\v\at
              If \Color[2]\State
                repaint | Events(*This, \at, #PB_EventType_MouseLeave, mouseX, mouseY)
                ;                   repaint | Events(*This, - 1, #PB_EventType_MouseLeave)
                ;                   repaint | Events(\s\v, - 1, #PB_EventType_MouseEnter)
                repaint | Events(\s\v, \s\v\at, #PB_EventType_MouseEnter, mouseX, mouseY)
                \Color[2]\State = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          EndIf
          
        EndIf
        
        If *Scroll <> mouseat And 
           *This = mouseat
          *Last = *Scroll
          *Scroll = mouseat
        EndIf
        
        Select EventType 
          Case #PB_EventType_Focus
            If \at       
              *Bar\Active = *This
              repaint | Events(*This, \at, #PB_EventType_Focus, mouseX, mouseY)
            EndIf
            
          Case #PB_EventType_LostFocus 
            If *Bar\Active
              *Bar\Active = 0 
              repaint | Events(*This, - 1, #PB_EventType_LostFocus, mouseX, mouseY)
            EndIf
            
        EndSelect
        
        If *Scroll = *This
          If Last <> \at
            ;
            ; Debug ""+Last +" "+ *This\at +" "+ *This +" "+ *Last
            If Last > 0 Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, Last, #PB_EventType_MouseLeave, mouseX, mouseY) : *Last = 0
            EndIf
            If Not \at Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseLeave, mouseX, mouseY) : *Last = 0
            EndIf
            
            If Not last ; Or (Last =- 1 And \at = 2 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseEnter, mouseX, mouseY)
            EndIf
            If \at > 0
              repaint | Events(*This, \at, #PB_EventType_MouseEnter, mouseX, mouseY)
            EndIf
            
            Last = \at
          EndIf
          
          Select EventType 
            Case #PB_EventType_MouseWheel
              Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta) ; bug in mac os
              
              If \at
                repaint | Events(*This, \at, EventType, mouseX, mouseY, -WheelDelta)
              ElseIf *Bar\Active
                repaint | Events(*Bar\Active, - 1, EventType, mouseX, mouseY, WheelDelta)
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              mouseB = 1
              If \at
                If *Bar\Active <> *This
                  If *Bar\Active
                    repaint | Events(*Bar\Active, \at, #PB_EventType_LostFocus, mouseX, mouseY)
                  EndIf
                  repaint | Events(*This, \at, #PB_EventType_Focus, mouseX, mouseY)
                  *Bar\Active = *This
                EndIf
                
                Down = \at
                repaint | Events(*This, \at, EventType, mouseX, mouseY)
              EndIf
              
            Case #PB_EventType_LeftButtonUp 
              mouseB = 0
              If Down
                repaint | Events(*This, Down, EventType, mouseX, mouseY)
                Down = 0
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \at
                repaint | Events(*This, \at, EventType, mouseX, mouseY)
              EndIf
          EndSelect
        EndIf
        
        ; ; ;           If AutoHide =- 1 : *Scroll = 0
        ; ; ;             AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
        ; ; ;           EndIf
        ; ; ;           
        ; ; ;           ; Auto hides
        ; ; ;           If (AutoHide And Not Drag And Not at) 
        ; ; ;             If \color\alpha <> \color\alpha[1] : \color\alpha = \color\alpha[1] 
        ; ; ;               repaint =- 1
        ; ; ;             EndIf 
        ; ; ;           EndIf
        ; ; ;           If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
        ; ; ;             If \color\alpha < 255 : \color\alpha = 255
        ; ; ;               
        ; ; ;               If *Scroll
        ; ; ;                 If \Vertical
        ; ; ;                   Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\Y+*Scroll\Height)-\Y) 
        ; ; ;                 Else
        ; ; ;                   Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\X+*Scroll\Width)-\X, #PB_Ignore) 
        ; ; ;                 EndIf
        ; ; ;               EndIf
        ; ; ;               
        ; ; ;               repaint =- 2
        ; ; ;             EndIf 
        ; ; ;           EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  ;-
  Procedure.i Bar(Type.i, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = Type
      \Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth)
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
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
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
      If Bool(Flag&#PB_ScrollBar_Inverted) : SetAttribute(*This, #PB_ScrollBar_Inverted, #True) : EndIf
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    ProcedureReturn Bar(#PB_GadgetType_ScrollBar, X,Y,Width,Height, Min, Max, PageLength, Flag, Radius)
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_ScrollBar_Vertical|#PB_ScrollBar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_ProgressBar, X,Y,Width,Height, Min, Max, 0, Smooth|Vertical|#PB_ScrollBar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_ScrollBar_Vertical|#PB_ScrollBar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_TrackBar, X,Y,Width,Height, Min, Max, 0, Ticks|Vertical|#PB_ScrollBar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected max, Ticks ;= Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_ScrollBar_Vertical
    
    If Vertical
      max = Width
    Else
      max = Height
    EndIf
    
    Protected *This.Bar_S = Bar(#PB_GadgetType_Splitter, X,Y,Width,Height, 0, max, 0, Ticks|Vertical|#PB_ScrollBar_NoButtons, 0)
    
    With *This
      If First > 0
        \First = First
      Else
        \First = AllocateStructure(Bar_S)
      EndIf
      
      If Second > 0
        \Second = Second
      Else
        \Second = AllocateStructure(Bar_S)
      EndIf
      
      If \Vertical
        SetState(*This,  y+(Height+\Thumb\len)/2+1)
      Else
        SetState(*This,  x+(Width+\Thumb\len)/2+1)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
    *Scroll\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, Radius)
    *Scroll\v\hide = *Scroll\v\hide[1]
    *Scroll\v\s = *Scroll
    
    If Both
      *Scroll\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
      *Scroll\h\hide = *Scroll\h\hide[1]
    Else
      *Scroll\h.Bar_S = AllocateStructure(Bar_S)
      *Scroll\h\hide = 1
    EndIf
    *Scroll\h\s = *Scroll
    
    With *Scroll     
      If \Post\Function And \Post\Event
        UnbindEvent(\Post\Event, \Post\Function, \Post\Window, \Post\Gadget)
        BindEvent(\Post\Event, \Post\Function, \Post\Window, \Post\Gadget)
      EndIf
    EndWith
    
    ProcedureReturn *Scroll
  EndProcedure
EndModule

;-
Macro GetActiveWidget()
  Bar::*Bar\Active
EndMacro

Macro EventWidget()
  Bar::*Bar\Widget
EndMacro

Macro WidgetEventType()
  Bar::*Bar\Type
EndMacro


;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  
  Global Window_demo, v, h
  
  Global g_container, g_min, g_max, g_page_pos, g_area_pos, g_len, g_value, g_is_vertical, g_set, g_page_len, g_area_len, g_Canvas
  
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=101,y=101, Width=790, Height=600 
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
      *Scroll\width = OutputWidth()
      *Scroll\height = OutputHeight()
      StopDrawing()
    EndIf
  EndIf
  
  Procedure ReDraw(Canvas)
    With *Scroll
      If StartDrawing(CanvasOutput(Canvas))
        ; back ground
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,Width,Height, $FFFFFF)
        
        ;       ;       
        ;       If IsStop(\v)
        ;         \h\Color\Line = 0
        ;       Else
        ;         \h\Color\Line = $FFFFFF
        ;       EndIf
        ;       
        ;       If IsStop(\h)
        ;         \v\Color\Line = 0
        ;       Else
        ;         \v\Color\Line = $FFFFFF
        ;       EndIf
        
        ClipOutput(\h\x, \v\y, \h\Page\len, \v\Page\len)
        ;DrawImage(ImageID(0), \h\x-\h\Page\Pos, \v\y-\v\Page\Pos)
        DrawImage(ImageID(0), \h\x-GetState(\h), \v\y-GetState(\v))
        UnclipOutput()
        
        Draw(\v)
        Draw(\h)
        
        ; frame 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\h\x-1,\v\y-1,
            2 + Bool(\v\hide) * \h\Page\len + Bool(Not \v\hide) * ((\v\X+\v\width)-\h\x),
            2 + Bool(\h\hide) * \v\Page\len + Bool(Not \h\hide) * ((\h\Y+\h\height)-\v\y), $0000FF)
        ;       ; 
        ;       Box(x, y, Width-x*2, Height-y*2, $0000FF)
        
        ; Scroll area coordinate ; (\v\x-\h\x)
        ;Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
        ;Debug Str(((\h\Max-\h\Page\len)-\h\Page\Pos))
        
        Box(\h\x-GetState(\h), \v\y-GetState(\v), \h\Max, \v\Max, $FF0000)
        
        ; page coordinate
        Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        
        ; area coordinate
        Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        
        ; frame coordinate
        Box(\h\x, \v\y, 
            \h\Page\len + (Bool(Not \v\hide) * \v\width),
            \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
        StopDrawing()
        
        SetGadgetState(v, GetState(*Scroll\v))
        SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum))
        SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum))
        SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength))
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Resizes(*Scroll, x, y, Width-x*2, Height-y*2)                                        ;, *Scroll\h)
                                                                                                       ;  Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
        ResizeGadget(v,  *Scroll\v\x+20, *Scroll\v\y, *Scroll\v\Width, *Scroll\v\Height)
    EndSelect
    
    Repaint | CallBack(*Scroll\v, EventType, mouseX,mouseY)
    Repaint | CallBack(*Scroll\h, EventType, mouseX,mouseY)
    
    If Not (*Scroll\v\at Or *Scroll\h\at)
      Select EventType
        Case #PB_EventType_LeftButtonDown
          SetAttribute(*Scroll\h, #PB_ScrollBar_Inverted, *Scroll\h\Inverted!1)
          Debug "#PB_EventType_LeftButtonDown *Scroll\h\Inverted " + *Scroll\h\Inverted
          
          Repaint = 1
      EndSelect
    EndIf
    
    If Repaint
      ReDraw(g_Canvas)
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
        Debug EventData()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g_container = ContainerGadget(#PB_Any, 10, 10, 180, 220, #PB_Container_Flat)
    
    g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
    g_value = StringGadget(#PB_Any, 10, 40, 120, 20, "100", #PB_String_Numeric)
    g_set = ButtonGadget(#PB_Any, 140, 40, 30, 20, "set")
    
    g_min = OptionGadget(#PB_Any, 10, 70, 160, 20, "Min")
    g_max = OptionGadget(#PB_Any, 10, 90, 160, 20, "Max") : SetGadgetState(g_max, 1)
    g_len = OptionGadget(#PB_Any, 10, 110, 160, 20, "len")
    g_page_len = OptionGadget(#PB_Any, 10, 130, 160, 20, "Page len")
    g_area_len = OptionGadget(#PB_Any, 10, 150, 160, 20, "Area len")
    g_page_pos = OptionGadget(#PB_Any, 10, 170, 160, 20, "Page pos")
    g_area_pos = OptionGadget(#PB_Any, 10, 190, 160, 20, "Area pos")
    
    CloseGadgetList()
    
    ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
    g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    v = ScrollBarGadget(-1, #PB_Ignore, #PB_Ignore, 1, 1, 0,0,0, #PB_ScrollBar_Vertical)
    CloseGadgetList()
    
    ; Create both scroll bars
    ;     *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
    ;     *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
    Bars(*Scroll, 16, 7, 1)
    Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
    Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
    
    ; Set scroll page position
    SetState(*Scroll\v, 70)
    SetState(*Scroll\h, 55)
    
    PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
    BindGadgetEvent(g_Canvas, @Canvas_CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    
    Define Event, value
    Repeat 
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          
          Select EventGadget()
            Case g_set
              value = Val(GetGadgetText(g_value))
              
              Select 1
                Case GetGadgetState(g_min) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      SetAttribute(*Scroll\v, #PB_ScrollBar_Minimum, value)
                    Case 0
                      SetAttribute(*Scroll\h, #PB_ScrollBar_Minimum, value)
                  EndSelect
                  
                Case GetGadgetState(g_max) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, value)
                    Case 0
                      SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, value)
                  EndSelect
                  
                Case GetGadgetState(g_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
                    Case 0
                      Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
                  EndSelect
                  
                Case GetGadgetState(g_page_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, value)
                    Case 0
                      SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, value)
                  EndSelect
                  
                Case GetGadgetState(g_area_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      *Scroll\v\Area\len = value
                    Case 0
                      *Scroll\h\Area\len = value
                  EndSelect
                  
                  
              EndSelect
              
              Debug "vmi "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)
              
              ReDraw(g_Canvas)
          EndSelect
          
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----------------------------------------------------
; EnableXP