
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
    
    ; splitter bar
    *First.Bar_S 
    *Second.Bar_S
    
    ; track bar
    Ticks.b
    
    ; progress bar
    Smooth.b
    
    at.b
    Type.i[3] ; [2] for splitter
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
    ButtonLen.i[4]
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
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
    ;Post.Post_S
    
    *v.Bar_S
    *h.Bar_S
  EndStructure
  
  ;-
  ;- - DECLAREs CONSTANTs
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #PB_Gadget_FrameColor = 10
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Direction = 1<<2
  #PB_Bar_NoButtons = 1<<3
  #PB_Bar_Inverted = 1<<4
  #PB_Bar_Ticks = 1<<5
  #PB_Bar_Smooth = 1<<6
  
  #PB_Bar_First = 1<<7
  #PB_Bar_Second = 1<<8
  #PB_Bar_FirstFixed = 1<<9
  #PB_Bar_SecondFixed = 1<<10
  #PB_Bar_FirstMinimumSize = 1<<11
  #PB_Bar_SecondMinimumSize = 1<<12
  
  ;- - DECLAREs GLOBALs
  Global *Bar.Post_S
  
  Prototype.i Resize(*This, iX.i,iY.i,iWidth.i,iHeight.i) 
  
  ;- - DECLAREs MACROs
  Macro IsBar(_this_)
    Bool(_this_ And (_this_\Type = #PB_GadgetType_ScrollBar Or _this_\Type = #PB_GadgetType_TrackBar Or _this_\Type = #PB_GadgetType_ProgressBar Or _this_\Type = #PB_GadgetType_Splitter))
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
  Macro ResizeSplitter(_this_)
    
    If _this_\Vertical
      _this_\x[1] = _this_\x
      _this_\y[1] = _this_\y
      _this_\width[1] = _this_\width
      _this_\height[1] = _this_\Thumb\Pos-_this_\y
      
      _this_\x[2] = _this_\x
      _this_\y[2] = _this_\Thumb\Pos+_this_\Thumb\len
      _this_\width[2] = _this_\width
      _this_\height[2] = _this_\Height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y)
    Else
      _this_\x[1] = _this_\x
      _this_\y[1] = _this_\y
      _this_\width[1] = _this_\Thumb\Pos-_this_\x
      _this_\height[1] = _this_\height
      
      _this_\x[2] = _this_\Thumb\Pos+_this_\Thumb\len
      _this_\y[2] = _this_\y
      _this_\width[2] = _this_\width-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x)
      _this_\height[2] = _this_\height
    EndIf
    
    If _this_\Type[1]
      Resize(_this_\First, _this_\x[1], _this_\y[1], _this_\width[1], _this_\height[1])
    EndIf
    If _this_\Type[2]
      Resize(_this_\Second, _this_\x[2], _this_\y[2], _this_\width[2], _this_\height[2])
    EndIf
    
  EndMacro
  
  Procedure.i DrawProgress(*This.Bar_S)
    With *This 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\y,\Width-4,\Thumb\Pos, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X+2,\y+2,\Width-4,\Thumb\Pos-2, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,\height-\Thumb\Pos, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x)-2,\height-4, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,\Thumb\Pos-\x,\height-4, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),0)
      EndIf
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X+1, \Y+1, \Width-2, \Height-2, \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color[3]\Frame)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i DrawSplitter(*This.Bar_S)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *This
      If *This > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        ; Позиция сплиттера 
        Size = \Thumb\len
        
        If \Vertical
          Pos = \Thumb\Pos-y
        Else
          Pos = \Thumb\Pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \Area\len)
          fColor = 0;\Color[3]\Frame[0]
          DrawingMode(#PB_2DDrawing_Outlined) 
          If \Vertical
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Width,Pos,fColor) 
            EndIf
            If \Type[2]<>#PB_GadgetType_Splitter
              Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),fColor)
            EndIf
          Else
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Pos,Height,fColor) 
            EndIf 
            If \Type[2]<>#PB_GadgetType_Splitter
              Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = 0;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined) 
          If \Vertical ; horisontal
            ClipOutput(\x[3], \y[3]+\height[3]-\Thumb\len, \width[3], \Thumb\len);, $0000FF)
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            UnclipOutput()
          Else
            ClipOutput(\x[3]+\width[3]-\Thumb\len, \y[3], \Thumb\len, \height[3]);, $0000FF)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
            UnclipOutput()
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined) 
          If \Vertical
            ;Box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,Color)
          Else
            ;Box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,Color)
          EndIf
        EndIf
        
        ;         If \Vertical
        ;           ;Box(\x[3], \y[3]+\height[3]-\Thumb\len, \width[3], \Thumb\len, $FF0000)
        ;           Box(X,Y,Width,Height/2,$0000FF)
        ;         Else
        ;           ;Box(\x[3]+\width[3]-\Thumb\len, \y[3], \Thumb\len, \height[3], $FF0000)
        ;           Box(X,Y,Width/2,Height,$0000FF)
        ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i DrawScroll(*This.Bar_S)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \x[2]
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Y[2]
      
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
      
      If \ButtonLen
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
      
      If \Thumb\len And \Color[3]\Fore[State_3]  ; Draw thumb lines
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
        Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,(\y+\height)-\Thumb\Pos,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0],\Y[0]+5,\Width[0],a,\Color[3]\Frame)
        Box(\X[0],\Y[0]+5,\Thumb\Pos-\x,a,\Color[3]\Back[2])
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
        If *This>0 And *This\Type And Not \hide And \color\alpha And \Height>0 And \width>0
          Select \Type
            Case #PB_GadgetType_TrackBar : DrawTrack(*This)
            Case #PB_GadgetType_ScrollBar : DrawScroll(*This)
            Case #PB_GadgetType_Splitter : DrawSplitter(*This)
            Case #PB_GadgetType_ProgressBar : DrawProgress(*This)
          EndSelect
          
          If \Type = #PB_GadgetType_Splitter
            If \Type[1]
              Draw(\First)
            EndIf
            If \Type[2]
              Draw(\Second)
            EndIf
          EndIf
        EndIf
        
        ; reset 
        \Change = 0
        \Resize = 0
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
      
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  ;-
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
            ResizeSplitter(*This)
          EndIf
          
          If \s
            If \Vertical
              \s\y =- \Page\Pos
            Else
              \s\x =- \Page\Pos
            EndIf
          EndIf
          
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
          Case #PB_Bar_Minimum : Result = \Min
          Case #PB_Bar_Maximum : Result = \Max
          Case #PB_Bar_Inverted : Result = \Inverted
          Case #PB_Bar_PageLength : Result = \Page\len
          Case #PB_Bar_NoButtons : Result = \ButtonLen
          Case #PB_Bar_Direction : Result = \Direction
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
    Protected Resize.i
    
    With *This
      If *This > 0
        If \Type = #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : \ButtonLen[1] = Value
            Case #PB_Splitter_SecondMinimumSize : \ButtonLen[2] = \ButtonLen[3] + Value
          EndSelect 
          
          If \Vertical
            \Area\Pos = \Y+\ButtonLen[1]
            \Area\len = (\Height-\ButtonLen[1]-\ButtonLen[2])
          Else
            \Area\Pos = \X+\ButtonLen[1]
            \Area\len = (\Width-\ButtonLen[1]-\ButtonLen[2])
          EndIf
          
          ProcedureReturn 1
        EndIf
        
        Select Attribute
          Case #PB_Bar_NoButtons : Resize = 1
            \ButtonLen[0] = Value
            \ButtonLen[1] = Value
            \ButtonLen[2] = Value
            
          Case #PB_Bar_Inverted
            \Inverted = Bool(Value)
            \Page\Pos = Invert(*This, \Page\Pos)
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
            ProcedureReturn 1
            
          Case #PB_Bar_Minimum ; 1 -m&l
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
              
              Resize = 1
            EndIf
            
          Case #PB_Bar_Maximum ; 2 -m&l
            If \Max <> Value
              \Max = Value
              
              If \Page\len > \Max 
                \Page\Pos = \Min
              EndIf
              
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              
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
              
              Resize = 1
            EndIf
            
          Case #PB_Bar_PageLength ; 3 -m&l
            If \Page\len <> Value
              If Value > (\Max-\Min)
                If \Max = 0 
                  \Max = Value 
                EndIf
                Value = (\Max-\Min)
                \Page\Pos = \Min
              EndIf
              \Page\len = Value
              
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              
              If \Page\len > \Min
                \Thumb\len = ThumbLength(*This)
              Else
                \Thumb\len = \ButtonLen[3]
              EndIf
              
              If \Step = 0
                \Step = 1
              EndIf
              If \Step < 2 And \Page\len
                \Step = (\Max-\Min) / \Page\len 
              EndIf
              
              Resize = 1
            EndIf
            
        EndSelect
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
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
    Protected Lines.i
    
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
        
        
        ; Set scroll bar coordinate
        If X=#PB_Ignore : X = \X : Else : If \X <> X : \X = X : \Resize | 1<<1 : EndIf : EndIf  
        If Y=#PB_Ignore : Y = \Y : Else : If \Y <> Y : \Y = Y : \Resize | 1<<2 : EndIf : EndIf  
        If Width=#PB_Ignore : Width = \Width : Else : If \Width <> Width : \Width = Width : \Resize | 1<<3 : EndIf : EndIf  
        If Height=#PB_Ignore : Height = \Height : Else : If \Height <> Height : \Height = Height : \Resize | 1<<4 : EndIf : EndIf 
        
        If \Resize
          Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
          \hide[1] = Bool(Not ((\Max-\Min) > \Page\Len))
          
          If \ButtonLen
            \ButtonLen[1] = \ButtonLen
            \ButtonLen[2] = \ButtonLen
          EndIf
          
          If \Vertical
            \Area\Pos = \Y+\ButtonLen[1]
            \Area\len = \Height-(\ButtonLen[1]+\ButtonLen[2])
          Else
            \Area\Pos = \X+\ButtonLen[1]
            \Area\len = \width-(\ButtonLen[1]+\ButtonLen[2])
          EndIf
          
          If Bool(\Resize & (1<<4 | 1<<3))
            If Not \hide And \Area\len
              \Thumb\len = ThumbLength(*This)
              
              If (\Area\len > \ButtonLen)
                If \ButtonLen
                  If (\Thumb\len < \ButtonLen)
                    \Area\len = Round(\Area\len - (\ButtonLen-\Thumb\len), #PB_Round_Nearest)
                    \Thumb\len = \ButtonLen 
                  EndIf
                Else
                  If (\Thumb\len < \ButtonLen[3]) And (\Type <> #PB_GadgetType_ProgressBar)
                    \Area\len = Round(\Area\len - (\ButtonLen[3]-\Thumb\len), #PB_Round_Nearest)
                    \Thumb\len = \ButtonLen[3]
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
            If \ButtonLen
              \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \ButtonLen[1]                       ; Top button coordinate on scroll bar
              \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \ButtonLen[2] : \Y[2] = (\Area\Pos+\Area\len)   ; Bottom button coordinate on scroll bar
            EndIf
            \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len                   ; Thumb coordinate on scroll bar
          Else
            If \ButtonLen
              \X[1] = X : \Y[1] = Y + Lines : \Height[1] = Height - Lines : \Width[1] = \ButtonLen[1]                      ; Left button coordinate on scroll bar
              \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \ButtonLen[2] : \X[2] = (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
            EndIf
            \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len                  ; Thumb coordinate on scroll bar
          EndIf
          
          If (\Type = #PB_GadgetType_Splitter)
            ResizeSplitter(*This)
          EndIf
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v)-(\v\Width-\v\Radius/2)+1, iHeight = Y(\h)-(\h\Height-\h\Radius/2)+1
      Static hPos, vPos : vPos = \v\Page\Pos : hPos = \h\Page\Pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\Page\Pos+iWidth 
        ScrollArea_Width=\h\Page\Pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\Page\Pos And
             ScrollArea_Width=\h\Page\Pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\Page\Pos+iHeight
        ScrollArea_Height=\v\Page\Pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\Page\Pos And
             ScrollArea_Height=\v\Page\Pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\Page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\Page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;     \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;     \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\Hide = Bar::Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\Y + Bool(\h\Hide) * \h\Height) - \v\Y) ; #PB_Ignore, \h) 
      \h\Hide = Bar::Resize(\h, #PB_Ignore, #PB_Ignore, (\v\X + Bool(\v\Hide) * \v\Width) - \h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\Page\Pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\Page\Pos = vPos : \h\Width = iWidth+\v\Width : EndIf
      If \h\hide : \h\Page\Pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\Page\Pos = hPos : \v\Height = iHeight+\h\Height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    
    With *Scroll
      ;     If Width=#PB_Ignore : Width = \v\X : Else : Width+x-\v\Width : EndIf
      ;       If Height=#PB_Ignore : Height = \h\Y : Else : Height+y-\h\Height : EndIf
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, (\h\Y+Bool(\h\Hide) * \h\Height)-\v\y)
      ;       SetAttribute(\h, #PB_Bar_PageLength, (\v\X+Bool(\v\Hide) * \v\width)-\h\x)
      ;       
      ;       \v\Hide = Resize(\v, Width, Y, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y)) 
      ;       \h\Hide = Resize(\h, X, Height, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore) 
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, (\h\Y+Bool(\h\Hide) * \h\Height)-\v\y)
      ;       SetAttribute(\h, #PB_Bar_PageLength, (\v\X+Bool(\v\Hide) * \v\width)-\h\x)
      ;       
      ;       ; 
      ;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore)
      ;       
      ;       If Not \v\Hide 
      ;         Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      ;       EndIf
      ;       If Not \h\Hide 
      ;         Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      ;       EndIf
      ;       
      ;      Debug ""+Width +" "+ \h\Page\len
      ;        \Width[2] = x(\v)-\h\x ; \h\Page\len ;
      ;     \Height[2] = y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
      ;     ProcedureReturn 1
      
      If y=#PB_Ignore : y = \v\Y : EndIf
      If x=#PB_Ignore : x = \h\X : EndIf
      If Width=#PB_Ignore : Width = \v\X-\h\X+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\Y-\v\Y+\h\height : EndIf
      
;       \v\Page\len = Height - Bool(Not \h\hide) * \h\height
;       \h\Page\len = Width - Bool(Not \v\hide) * \v\width
;       
;       \v\Hide = Resize(\v, Width+x-\v\Width, y, #PB_Ignore, \v\Page\len)
;       \h\Hide = Resize(\h, x, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
;       
;       \v\Page\len = Height - Bool(Not \h\hide) * \h\height
;       \h\Page\len = Width - Bool(Not \v\hide) * \v\width
;       
;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len + Bool(\v\Radius And Not \h\Hide And Not \v\Hide)*4)
;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len + Bool(\h\Radius And Not \v\Hide And Not \h\hide)*4, #PB_Ignore)
;       
;       \Width[2] = \h\Page\len ;  x(\v)-\h\x ; 
;       \Height[2] =\v\Page\len ;  y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
;       ProcedureReturn 1
      
      
      ;       If \h\Max < \width ; Width-Bool(Not \v\Hide) * \v\width
      ;         \h\Max = \width ; Width-Bool(Not \v\Hide) * \v\width
      ;       EndIf
      ;       If \v\Max < Height-Bool(Not \h\Hide) * \h\height
      ;         \v\Max = Height-Bool(Not \h\Hide) * \h\height
      ;       EndIf
      
      ;       ; Debug ""+Width +" "+ Str(\v\X-\h\X+\v\width)
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, Height - Bool(Not \h\hide) * \h\height) 
      ;       SetAttribute(\h, #PB_Bar_PageLength, Width - Bool(Not \v\hide) * \v\width)  
      ;       
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, \v\Page\len)
      ;       \h\Hide = Resize(\h, x, y+\v\Page\len, \h\Page\len, #PB_Ignore)
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, Height - Bool(Not \h\hide) * \h\height)
      ;       SetAttribute(\h, #PB_Bar_PageLength, Width - Bool(Not \v\hide) * \v\width)
      ;       
      ;       \v\Hide = Resize(\v, x+\h\Page\len, #PB_Ignore, #PB_Ignore, \v\Page\len + Bool(\v\Radius And Not \h\Hide)*4)
      ;       \h\Hide = Resize(\h, #PB_Ignore, y+\v\Page\len, \h\Page\len + Bool(\h\Radius And Not \v\Hide)*4, #PB_Ignore)
      ;       
      ;       \Width[2] = \h\Page\len ;  x(\v)-\h\x ; 
      ;       \Height[2] =\v\Page\len ;  y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
      ;       ProcedureReturn 1
      
      ;       If Width=#PB_Ignore 
      ;         Width = \v\X+\v\Width
      ;       EndIf
      ;       If Height=#PB_Ignore 
      ;         Height = \h\Y+\h\Height
      ;       EndIf
      
      SetAttribute(\v, #PB_Bar_PageLength, Height-Bool(Not \h\Hide) * \h\height)
      SetAttribute(\h, #PB_Bar_PageLength, Width-Bool(Not \v\Hide) * \v\width)
      
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, \v\Page\len)
      ;      \h\Hide = Resize(\h, x, y+\v\Page\len, \h\Page\len, #PB_Ignore)
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, (\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y)
      ;       \h\Hide = Resize(\h, x, y+\v\Page\len, (\v\X+Bool(\v\Hide) * \v\width) - \h\X, #PB_Ignore)
      
      \v\Hide = Resize(\v, Width+x-\v\Width, Y, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, X, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
      ;       \v\Hide = Resize(\v, Width+x-\v\Width, Y, #PB_Ignore, (\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y)
      ;       \h\Hide = Resize(\h, X, Height+y-\h\Height, (\v\X+Bool(\v\Hide) * \v\width) - \h\X, #PB_Ignore)
      
      SetAttribute(\v, #PB_Bar_PageLength, Height-Bool(Not \h\Hide) * \h\height)
      SetAttribute(\h, #PB_Bar_PageLength, Width-Bool(Not \v\Hide) * \v\width)
      
      ;        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y) + Bool(\v\Radius And Not \h\Hide)*4)
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X) + Bool(\h\Radius And Not \v\Hide)*4, #PB_Ignore)
      ;      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X), #PB_Ignore)
      
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len, #PB_Ignore)
      
      ;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore)
      
      If Not \v\Hide 
        \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not \h\Hide 
        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      EndIf
      ;;; Debug \v\Page\len
      
      ;       SetAttribute(\v, #PB_Bar_PageLength, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y))
      ;       SetAttribute(\h, #PB_Bar_PageLength, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X))
      
      
      ProcedureReturn 1
    EndWith
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
            If \Type = #PB_GadgetType_ScrollBar
              Select at
                Case - 1
                  If \Vertical
                    Repaint = (MouseScreenY-\Thumb\len/2)
                  Else
                    Repaint = (MouseScreenX-\Thumb\len/2)
                  EndIf
                  
                  Repaint = SetState(*This, Pos(*This, Repaint))
              EndSelect
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            If \Type = #PB_GadgetType_ScrollBar
              Select at
                Case 1 : Repaint = SetState(*This, (\Page\Pos - \Step)) ; Up button
                Case 2 : Repaint = SetState(*This, (\Page\Pos + \Step)) ; Down button
              EndSelect
            EndIf
            
            Select at
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
  
  ;-
  Procedure.i Bar(Type.i, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7)
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = Type
      \Radius = Radius
      \ButtonLen[3] = SliderLen ; min thumb size
      \Ticks = Bool(Flag&#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth)
      \Vertical = Bool(Flag&#PB_Bar_Vertical)
      
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
      
      If Not Bool(Flag&#PB_Bar_NoButtons)
        If \Vertical
          If width < 21
            \ButtonLen = width - 1
          Else
            \ButtonLen = 17
          EndIf
        Else
          If height < 21
            \ButtonLen = height - 1
          Else
            \ButtonLen = 17
          EndIf
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    ProcedureReturn Bar(#PB_GadgetType_ScrollBar, X,Y,Width,Height, Min, Max, PageLength, Flag, Radius)
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Bar_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_ProgressBar, X,Y,Width,Height, Min, Max, 0, Smooth|Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Bar_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_TrackBar, X,Y,Width,Height, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected *Bar.Bar_S
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Bar_Vertical
    Protected *This.Bar_S, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    *This = Bar(0, X,Y,Width,Height, 0, Max, 0, Vertical|#PB_Bar_NoButtons, 0, 7)
    
    With *This
      \First = First
      \Second = Second
      
      \Type = #PB_GadgetType_Splitter
      
      *Bar = \First 
      ; thisis bar
      If Not IsGadget(First) And IsBar(*Bar)
        \Type[1] = *Bar\Type
      EndIf
      
      *Bar = \Second 
      ; thisis bar
      If Not IsGadget(Second) And IsBar(*Bar)
        \Type[2] = *Bar\Type
      EndIf
      
      If \Vertical
        SetState(*This, \height/2-1)
      Else
        SetState(*This, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
    With *Scroll     
      \v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_Bar_Vertical, Radius)
      \v\hide = \v\hide[1]
      \v\s = *Scroll
      
      If Both
        \h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
        \h\hide = \h\hide[1]
      Else
        \h.Bar_S = AllocateStructure(Bar_S)
        \h\hide = 1
      EndIf
      \h\s = *Scroll
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
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  EnableExplicit
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
  
  
  Global v, h, g_container, g_value, g_is_vertical, g_min, g_max, g_pos, g_len, g_set, g_page_pos, g_page_len, g_area_pos, g_area_len, g_Canvas
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=151,y=151, Width=790, Height=600 , focus
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
  Macro GetScrollCoordinate()
    ;  *Scroll\y =- *Scroll\v\Page\Pos 
    If focus
      ;       Scroll_x = *Scroll\x
      ;       Scroll_y = *Scroll\y
      PushListPosition(Images())
      ForEach Images()
        Debug Images()\y 
        ;         If Scroll_y > Images()\y 
        ;           Scroll_y = Images()\y
        ;         EndIf
        ;         
        ;         If Scroll_x > Images()\x 
        ;           Scroll_x = Images()\x
        ;         EndIf
      Next
      PopListPosition(Images())
      ;       Scroll_x = *Scroll\x
      ;       Scroll_y = *Scroll\y
    EndIf
    
    *Scroll\Width = *Scroll\x+Images()\width
    *Scroll\Height = *Scroll\y+Images()\height 
    
    PushListPosition(Images())
    ForEach Images()
      If *Scroll\y > Images()\y 
        *Scroll\y = Images()\y
      EndIf
      
      If *Scroll\x > Images()\x 
        *Scroll\x = Images()\x
      EndIf
      
      If *Scroll\Width < Images()\x+Images()\width
        *Scroll\Width = Images()\width+Images()\x
      EndIf
      
      If *Scroll\height < Images()\Y+Images()\height 
        *Scroll\height = Images()\height+Images()\Y
      EndIf 
    Next
    PopListPosition(Images())
    
    ;     If *Scroll\y < Images()\y 
    ;         *Scroll\y = Images()\y
    ;       EndIf
    ;       
    ;       If *Scroll\x > Images()\x 
    ;         *Scroll\x = Images()\x
    ;       EndIf
    
    ;     If *Scroll\x > 0
    ;       *Scroll\x = 0
    ;     EndIf
    ; ;     If *Scroll\y > 0
    ; ;       *Scroll\y =- *Scroll\v\Page\Pos
    ; ;     EndIf
    ; ;     
    ;     ;                                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;     ;                                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;     ;                                 EndIf
    ;     
    ;     If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;       *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;     EndIf
    ;     
    ;     *Scroll\Width-*Scroll\x
    ;     *Scroll\height-*Scroll\y
    
  EndMacro
  
  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images()) And img
      Images()\img    = img
      Images()\x      = x
      Images()\y      = y
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
  
  Procedure ReDraw (canvas.i, List Images.canvasitem())
    With *Scroll
      SetGadgetState(v, GetState(\v))
      SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(\v, #PB_ScrollBar_Minimum))
      SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(\v, #PB_ScrollBar_Maximum))
      SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(\v, #PB_ScrollBar_PageLength))
      ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\height)
      
      If StartDrawing(CanvasOutput(canvas))
        
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
        
        ; ClipOutput(\h\x, \v\y, \h\Page\len, \v\Page\len)
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;       If focus And ChangeCurrentElement(Images(), focus)
        ;         DrawImage(ImageID(Images()\img),x+(Images()\x - \h\Page\Pos), y+(Images()\y)) ; draw all images with z-order
        ;       Else
        ForEach Images()
          ;  DrawImage(ImageID(Images()\img),x+(Images()\x - \h\Page\Pos), y+(Images()\y - \v\Page\Pos)) ; draw all images with z-order
          DrawImage(ImageID(Images()\img),x+(Images()\x - Bool(Not focus) * \h\Page\Pos), y+(Images()\y - Bool(Not focus) * \v\Page\Pos)) ; draw all images with z-order
        Next
        ;       EndIf
        ;UnclipOutput()
        
        Bar::Draw(\v)
        Bar::Draw(\h)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width-x*2+2, Height-y*2+2, $0000FF)
        
        ; Scroll area coordinate
        Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
        
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
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
    
    With *Scroll
      If LastElement(Images()) ; search for hit, starting from end (z-order)
        Repeat
          If mouse_x >= x+Images()\x - \h\Page\Pos And mouse_x < x+Images()\x - \h\Page\Pos + Images()\width
            If mouse_y >= y+Images()\y - \v\Page\Pos And mouse_y < y+Images()\y - \v\Page\Pos + Images()\height
              alpha = 255
              
              If Images()\alphatest And ImageDepth(Images()\img)>31
                If StartDrawing(ImageOutput(Images()\img))
                  DrawingMode(#PB_2DDrawing_AlphaChannel)
                  
                  alpha = Alpha(Point(mouse_x-Images()\x, mouse_y-Images()\y)) ; get alpha
                  StopDrawing()
                EndIf
              EndIf
              
              If alpha
                MoveElement(Images(), #PB_List_Last)
                isCurrentItem = #True
                currentItemXOffset = mouse_x - Images()\x
                currentItemYOffset = mouse_y - Images()\y
                Break
              EndIf
            EndIf
          EndIf
        Until PreviousElement(Images()) = 0
      EndIf
    EndWith
    
    ProcedureReturn isCurrentItem
  EndProcedure
  
  AddImage(Images(),  10,  10, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100, 60, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp"))
  AddImage(Images(),  50, 160, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  
  ;   hole = CreateImage(#PB_Any,100,100,32)
  ;   If StartDrawing(ImageOutput(hole))
  ;     DrawingMode(#PB_2DDrawing_AllChannels)
  ;     Box(0,0,100,100,RGBA($00,$00,$00,$00))
  ;     Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  ;     Circle(50,50,30,RGBA($00,$00,$00,$00))
  ;     StopDrawing()
  ;   EndIf
  ;   AddImage(Images(),170,70,hole,1)
  
  
  Procedure BarUpdates(*v.Bar::Bar_S, *h.Bar::Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height) ; Ok
    Protected iWidth = (*v\X-*h\X)+ Bool(*v\Hide) * *v\Width                                                          ; Bar::X(*v)
    Protected iHeight = (*h\Y-*v\Y)+ Bool(*h\Hide) * *h\height                                                        ; Bar::Y(*h)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
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
    
    If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y-*v\Page\Pos : EndIf
    If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X-*h\Page\Pos : EndIf
    
    Bar::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height)
    Bar::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width)
    
    If *v\Page\Len<>iHeight : Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Len<>iWidth : Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<>*v\Page\Pos 
      Bar::SetState(*v, -ScrollArea_Y);(ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) 
    EndIf
    
    ;If ScrollArea_X<0 : Bar::SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    If ScrollArea_X<>*h\Page\Pos 
      Bar::SetState(*h, -ScrollArea_X) 
    EndIf
    
    *v\Hide = Bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) 
    *h\Hide = Bar::Resize(*h, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, *v)
    
    *Scroll\Y =- *v\Page\Pos
    *Scroll\X =- *h\Page\Pos
    *Scroll\width = *v\Max
    *Scroll\height = *h\Max
    
    ;   If *v\Hide : *v\Page\Pos = 0 : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\Page\Pos = 0 : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ;   If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure BarResize(*v.Bar::Bar_s, X,Y,Width,Height, *h.Bar::Bar_s )
    
    ; ; ;     
    ; ; ;       If y=#PB_Ignore : y = *v\Y : EndIf
    ; ; ;       If x=#PB_Ignore : x = *h\X : EndIf
    ; ; ;       If Width=#PB_Ignore : Width = *v\X-*h\X+*v\width : EndIf
    ; ; ;       If Height=#PB_Ignore : Height = *h\Y-*v\Y+*h\height : EndIf
    ; ; ;       
    ; ; ;       ; Debug ""+Width +" "+ Str(*v\X-*h\X+*v\width)
    ; ; ;       
    ; ; ;       Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(*h\hide) * *h\height) 
    ; ; ;       Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, Width - Bool(*v\hide) * *v\width)  
    ; ; ;       
    ; ; ;       *v\Hide = Bar::Resize(*v, x+*h\Page\Len, y, #PB_Ignore, Height)
    ; ; ;       *h\Hide = Bar::Resize(*h, x, y+*v\Page\len, Width, #PB_Ignore)
    ; ; ;       
    ; ; ; ; ;       Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(Not *h\hide) * *h\height)
    ; ; ; ; ;       Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, Width - Bool(Not *v\hide) * *v\width)
    ; ; ; ;        Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(Not *h\hide) * *h\height) 
    ; ; ; ;       Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, Width -  Bool(Not *v\hide) * *v\width)  
    ; ; ; ;      
    ; ; ; ;       *v\Hide = Bar::Resize(*v, x+*h\Page\len, #PB_Ignore, #PB_Ignore, Height + Bool(*v\Radius And Not *h\Hide)*4)
    ; ; ; ;       *h\Hide = Bar::Resize(*h, #PB_Ignore, y+*v\Page\len, Width + Bool(*h\Radius And Not *v\Hide)*4, #PB_Ignore)
    
    If Width=#PB_Ignore 
      Width = *v\X+*v\Width
    EndIf
    If Height=#PB_Ignore 
      Height = *h\Y+*h\Height
    EndIf
    
    Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Bar::Resize(*v, (x+Width)-*v\Width, Y, #PB_Ignore, (*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y)
    *h\Hide = Bar::Resize(*h, X, (y+Height)-*h\Height, (*v\X+Bool(*v\Hide) * *v\width) - *h\X, #PB_Ignore)
    
    Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y) + Bool(*v\Radius And Not *h\Hide)*4)
    *h\Hide = Bar::Resize(*h, #PB_Ignore, #PB_Ignore, ((*v\X+Bool(*v\Hide) * *v\width) - *h\X) + Bool(*h\Radius And Not *v\Hide)*4, #PB_Ignore)
    ProcedureReturn 1
    
    
    ; ;     ; ;     Static.l w,h
    ; ;     ;     
    ; ;     ; ;     If Width=#PB_Ignore 
    ; ;     ; ;       Width = *v\X+*v\Width
    ; ;     ; ;       If Not *v\Hide And w 
    ; ;     ; ;         Width+w : w=0 
    ; ;     ; ;       EndIf
    ; ;     ; ;     Else
    ; ;     ; ;       Width+*h\x 
    ; ;     ; ;       w=X
    ; ;     ; ;     EndIf
    ; ;     ; ;     If Height=#PB_Ignore 
    ; ;     ; ;       Height = *h\Y+*h\Height
    ; ;     ; ;       If Not *h\Hide And h
    ; ;     ; ;         Height+h : h=0
    ; ;     ; ;       EndIf
    ; ;     ; ;     Else
    ; ;     ; ;       Height+*v\y 
    ; ;     ; ;       h=Y
    ; ;     ; ;     EndIf
    ; ;     
    ; ;     If Width=#PB_Ignore 
    ; ;       Width = *v\X+*v\Width
    ; ;     EndIf
    ; ;     If Height=#PB_Ignore 
    ; ;       Height = *h\Y+*h\Height
    ; ;     EndIf
    ; ;     
    ; ;     Protected iWidth = Width-Width(*v), iHeight = Height-Height(*h)
    ; ;     
    ; ;     If *v\width And *v\Page\Len<>iHeight : Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\Page\Len<>iWidth : Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     *v\Hide = Bar::Resize(*v, Width+x-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = Width-Width(*v)
    ; ;     *h\Hide = Bar::Resize(*h, X, Height+y-*h\Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = Height-Height(*h)
    ; ;     
    ; ;     If *v\width And *v\Page\Len<>iHeight : Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\Page\Len<>iWidth : Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     If *v\width
    ; ;       *v\Hide = Bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) ;
    ; ;     EndIf
    ; ;     If *h\height
    ; ;       *h\Hide = Bar::Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore) ; #PB_Ignore, #PB_Ignore, *v) ;
    ; ;     EndIf
    ; ;     
    ; ; ;     If *v\Hide 
    ; ; ;       *v\Page\Pos = 0 
    ; ; ;     Else
    ; ; ;       ; Если есть вертикальная и горизонтальная полоса,
    ; ; ;       ; то окрашиваем прамоугольник между ними
    ; ; ;      ; *h\Width = Width
    ; ; ;     EndIf
    ; ; ;     If *h\Hide 
    ; ; ;       *h\Page\Pos = 0 
    ; ; ;     Else
    ; ; ;       ; Если есть вертикальная и горизонтальная полоса,
    ; ; ;       ; то окрашиваем прамоугольник между ними
    ; ; ;       ;*v\Height = Height
    ; ; ;     EndIf
    ; ;     
    ; ;     ProcedureReturn Bool(*v\Hide|*h\Hide)
    ; ;     
    ProcedureReturn 1
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, Event.i)
    Protected Repaint
    ;Protected Event = EventType()
    ;Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Repaint | Bar::CallBack(*Scroll\v, Event, MouseX, MouseY) 
    Repaint | Bar::CallBack(*Scroll\h, Event, MouseX, MouseY) 
    
    
    ;     If *Scroll\v\Change Or *Scroll\h\Change 
    ;       *Scroll\X =- *Scroll\h\Page\Pos
    ;       *Scroll\Y =- *Scroll\v\Page\Pos
    ;       GetScrollCoordinate()
    ;       
    ;       ;                 If *Scroll\x > 0
    ;       ;                   *Scroll\x = 0
    ;       ;                 EndIf
    ;       ;                 If *Scroll\y > 0
    ;       ;                   *Scroll\y =- *Scroll\v\Page\Pos
    ;       ;                 EndIf
    ;       ;                 
    ;       ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;       ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;       ;                 EndIf
    ;       ;                 
    ;       ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;       ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;       ;                 EndIf
    ;       ;                 
    ;       ;                 *Scroll\Width-*Scroll\x
    ;       ;                 *Scroll\height-*Scroll\y
    ;       
    ;       
    ;       BarUpdates(*Scroll\v, *Scroll\h, *Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
    ;     EndIf
    
    ;     
    Select Event
      Case #PB_EventType_LeftButtonUp
        If focus
          ;   GetScrollCoordinate()
          ;           
          ;           
          ;                 If *Scroll\x > 0
          ;                   *Scroll\x =- *Scroll\h\Page\Pos
          ;                 EndIf
          ;                 If *Scroll\y > 0
          ;                   *Scroll\y =- *Scroll\v\Page\Pos
          ;                 EndIf
          ;                 
          ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;                 EndIf
          ;                 
          ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;                 EndIf
          ;                 
          ;                 *Scroll\Width-*Scroll\x
          ;                 *Scroll\height-*Scroll\y
          ;                 
          ;                 
          ; ;         *Scroll\v\Page\Pos =- *Scroll\Y
          ; ;         *Scroll\h\Page\Pos =- *Scroll\X
          ;         
          ;         
          ;         Debug "up "+Images()\X
          ;         
          ;         ;If (*Scroll\X<0 Or *Scroll\Y<0)
          ;           PushListPosition(Images())
          ;           ForEach Images()
          ;             If *Scroll\X<0
          ;               ;*Scroll\h\Page\Pos =- *Scroll\X
          ;               Images()\X-*Scroll\X
          ;             EndIf
          ;             If *Scroll\Y<0
          ;               ;*Scroll\v\Page\Pos =- *Scroll\Y
          ;               Images()\Y-*Scroll\Y
          ;             EndIf
          ;           Next
          ;           PopListPosition(Images())
          ;         ;EndIf
          
          Debug "up "+Images()\X
        EndIf
        
        focus = 0
        Repaint = #True
    EndSelect     
    
    If Not Bool(*Scroll\h\at Or *Scroll\v\at)
      Select Event
        Case #PB_EventType_LeftButtonUp : Drag = #False
          
        Case #PB_EventType_LeftButtonDown
          isCurrentItem = HitTest(Images(), Mousex, Mousey)
          If isCurrentItem 
            Repaint = #True 
            Drag = #True
          EndIf
          
        Case #PB_EventType_MouseMove
          If Drag = #True
            If isCurrentItem
              If LastElement(Images())
                Images()\x = Mousex - currentItemXOffset
                Images()\y = Mousey - currentItemYOffset
                SetWindowTitle(EventWindow(), Str(Images()\x))
                
                If Images()\x < *Scroll\x
                  focus = @Images()
                EndIf
                If Images()\y < *Scroll\y
                  focus = @Images()
                EndIf
                
                GetScrollCoordinate()
                
                ;                 If *Scroll\x > 0
                ;                   *Scroll\x = 0
                ;                 EndIf
                ;                 If *Scroll\y > 0
                ;                   *Scroll\y =- *Scroll\v\Page\Pos
                ;                 EndIf
                ;                 
                ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
                ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
                ;                 EndIf
                ;                 
                ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
                ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
                ;                 EndIf
                ;                 
                ;                 *Scroll\Width-*Scroll\x
                ;                 *Scroll\height-*Scroll\y
                
                
                BarUpdates(*Scroll\v, *Scroll\h, *Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
                ;                 
                ;                 Debug *Scroll\v\Max
                ;                 Debug *Scroll\v\Page\len
                
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          
          ;           If *Scroll\x > 0
          ;             *Scroll\x = 0
          ;           EndIf
          ;           If *Scroll\y > 0
          ;             *Scroll\y = 0
          ;           EndIf
          ;           
          ;           If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;             *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;           EndIf
          ;           
          ;           If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;             *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;           EndIf
          ;           
          ;           *Scroll\Width-*Scroll\x
          ;           *Scroll\height-*Scroll\y
          
          
          
          Protected vMax, hMax
          Protected iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          Protected iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          If *Scroll\Height>Height-y*2
            vMax = *Scroll\Height
          Else
            vMax = Height-y*2
          EndIf
          
          If *Scroll\width>Width-x*2
            hmax = *Scroll\width
          Else
            hmax = Width-x*2
          EndIf
          
          Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, vMax)
          Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, hMax)
          
          
          ;            BarResize(*Scroll\v, x, y, Width-x*2, Height-y*2, *Scroll\h)
          
          Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, vMax)
          Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, hMax)
          
          
          
          *Scroll\v\Hide = Bar::Resize(*Scroll\v, Width-x-*Scroll\v\Width, Y, #PB_Ignore, iHeight)
          *Scroll\h\Hide = Bar::Resize(*Scroll\h, X, Height-y-*Scroll\h\Height, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight)
          Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth)
          
          *Scroll\v\Hide = Bar::Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight)
          *Scroll\h\Hide = Bar::Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight)
          Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth)
          
          Bar::Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v\Page\len)
          Bar::Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, *Scroll\h\Page\len, #PB_Ignore)
          
          Repaint = #True
          
      EndSelect
    EndIf 
    
    If Repaint : ReDraw(g_Canvas, Images()) : EndIf
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
    g_container = ContainerGadget(#PB_Any, 10, 10, 180, 240, #PB_Container_Flat)
    
    g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
    g_value = StringGadget(#PB_Any, 10, 40, 120, 20, "100", #PB_String_Numeric)
    g_set = ButtonGadget(#PB_Any, 140, 40, 30, 20, "set")
    
    g_min = OptionGadget(#PB_Any, 10, 70, 160, 20, "Min")
    g_max = OptionGadget(#PB_Any, 10, 90, 160, 20, "Max") : SetGadgetState(g_max, 1)
    g_pos = OptionGadget(#PB_Any, 10, 110, 160, 20, "pos")
    g_len = OptionGadget(#PB_Any, 10, 130, 160, 20, "len")
    g_page_pos = OptionGadget(#PB_Any, 10, 150, 160, 20, "Page pos")
    g_page_len = OptionGadget(#PB_Any, 10, 170, 160, 20, "Page len")
    g_area_pos = OptionGadget(#PB_Any, 10, 190, 160, 20, "Area pos")
    g_area_len = OptionGadget(#PB_Any, 10, 210, 160, 20, "Area len")
    
    CloseGadgetList()
    
    ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
    g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    Width = GadgetWidth(g_Canvas)
    Height = GadgetHeight(g_Canvas)
    v = ScrollBarGadget(-1, x-17, y, 16, Height-y*2, 0,0,0, #PB_ScrollBar_Vertical)
    CloseGadgetList()
    
    ; Create both scroll bars
    ;     *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
    ;     *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
    Bars(*Scroll, 16, 7, 1)
    ;     Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
    ;     Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
    
    ; Set scroll page position
    SetState(*Scroll\v, 70)
    SetState(*Scroll\h, 55)
    
    Resizes(*Scroll, x, y, Width-x*2, Height-y*2)
    ReDraw(g_Canvas, Images())
    
    ;PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
    BindGadgetEvent(g_Canvas, @Canvas_CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    
    Define value
    
    Repeat 
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          
          Select EventGadget()
            Case g_min
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum)))
                Case 0
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_Minimum)))
              EndSelect
              
            Case g_max 
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum)))
                Case 0
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_Maximum)))
              EndSelect
              
            Case g_page_len
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)))
                Case 0
                  SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_PageLength)))
              EndSelect
              
            Case g_page_pos
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(GetState(*Scroll\v)))
                Case 0
                  SetGadgetText(g_value, Str(GetState(*Scroll\h)))
              EndSelect
              
            Case g_pos
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(*Scroll\v\y))
                Case 0
                  SetGadgetText(g_value, Str(*Scroll\h\x))
              EndSelect
              
            Case g_len
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(*Scroll\v\height))
                Case 0
                  SetGadgetText(g_value, Str(*Scroll\h\width))
              EndSelect
              
            Case g_area_len 
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(*Scroll\v\Area\len))
                Case 0
                  SetGadgetText(g_value, Str(*Scroll\h\Area\len))
              EndSelect
              
            Case g_area_pos 
              Select GetGadgetState(g_is_vertical)
                Case 1
                  SetGadgetText(g_value, Str(*Scroll\v\Area\Pos))
                Case 0
                  SetGadgetText(g_value, Str(*Scroll\h\Area\Pos))
              EndSelect
              
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
                  
                Case GetGadgetState(g_pos) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      Resize(*Scroll\v, #PB_Ignore, value, #PB_Ignore, #PB_Ignore)
                    Case 0
                      Resize(*Scroll\h, value, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                  EndSelect
                  
                Case GetGadgetState(g_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
                    Case 0
                      Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
                  EndSelect
                  
                Case GetGadgetState(g_page_pos) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      SetState(*Scroll\v, value)
                    Case 0
                      SetState(*Scroll\h, value)
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
                  
                Case GetGadgetState(g_area_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      *Scroll\v\Area\Pos = value
                    Case 0
                      *Scroll\h\Area\Pos = value
                  EndSelect
                  
                  
              EndSelect
              
              Debug "vmi "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)
              
              ReDraw(g_Canvas, Images())
          EndSelect
          
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf


; ; ; ;-
; ; ; ;- EXAMPLE
; ; ; ;-
; ; ; CompilerIf #PB_Compiler_IsMainFile
; ; ;   UseModule Bar
; ; ;   
; ; ;   Global Window_demo, v, h
; ; ;   
; ; ;   Global g_container, g_min, g_max, g_page_pos, g_area_pos, g_len, g_value, g_is_vertical, g_set, g_page_len, g_area_len, g_Canvas
; ; ;   
; ; ;   
; ; ;   Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
; ; ;   Global x=101,y=101, Width=790, Height=600 
; ; ;   
; ; ;   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
; ; ;     ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
; ; ;     
; ; ;     ; draw frame on the image
; ; ;     If StartDrawing(ImageOutput(0))
; ; ;       DrawingMode(#PB_2DDrawing_Outlined)
; ; ;       Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
; ; ;       *Scroll\width = OutputWidth()
; ; ;       *Scroll\height = OutputHeight()
; ; ;       StopDrawing()
; ; ;     EndIf
; ; ;   EndIf
; ; ;   
; ; ;   Procedure ReDraw(Canvas)
; ; ;     With *Scroll
; ; ;       If StartDrawing(CanvasOutput(Canvas))
; ; ;         ; back ground
; ; ;         DrawingMode(#PB_2DDrawing_Default)
; ; ;         Box(0,0,Width,Height, $FFFFFF)
; ; ;         
; ; ;         ;       ;       
; ; ;         ;       If IsStop(\v)
; ; ;         ;         \h\Color\Line = 0
; ; ;         ;       Else
; ; ;         ;         \h\Color\Line = $FFFFFF
; ; ;         ;       EndIf
; ; ;         ;       
; ; ;         ;       If IsStop(\h)
; ; ;         ;         \v\Color\Line = 0
; ; ;         ;       Else
; ; ;         ;         \v\Color\Line = $FFFFFF
; ; ;         ;       EndIf
; ; ;         
; ; ;         ClipOutput(\h\x, \v\y, \h\Page\len, \v\Page\len)
; ; ;         ;DrawImage(ImageID(0), \h\x-\h\Page\Pos, \v\y-\v\Page\Pos)
; ; ;         DrawImage(ImageID(0), \h\x-GetState(\h), \v\y-GetState(\v))
; ; ;         UnclipOutput()
; ; ;         
; ; ;         Draw(\v)
; ; ;         Draw(\h)
; ; ;         
; ; ;         ; frame 
; ; ;         DrawingMode(#PB_2DDrawing_Outlined)
; ; ;         Box(\h\x-1,\v\y-1,
; ; ;             2 + Bool(\v\hide) * \h\Page\len + Bool(Not \v\hide) * ((\v\X+\v\width)-\h\x),
; ; ;             2 + Bool(\h\hide) * \v\Page\len + Bool(Not \h\hide) * ((\h\Y+\h\height)-\v\y), $0000FF)
; ; ;         ;       ; 
; ; ;         ;       Box(x, y, Width-x*2, Height-y*2, $0000FF)
; ; ;         
; ; ;         ; Scroll area coordinate ; (\v\x-\h\x)
; ; ;         ;Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
; ; ;         ;Debug Str(((\h\Max-\h\Page\len)-\h\Page\Pos))
; ; ;         
; ; ;         Box(\h\x-GetState(\h), \v\y-GetState(\v), \h\Max, \v\Max, $FF0000)
; ; ;         
; ; ;         ; page coordinate
; ; ;         Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
; ; ;         
; ; ;         ; area coordinate
; ; ;         Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
; ; ;         
; ; ;         ; scroll coordinate
; ; ;         Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
; ; ;         
; ; ;         ; frame coordinate
; ; ;         Box(\h\x, \v\y, 
; ; ;             \h\Page\len + (Bool(Not \v\hide) * \v\width),
; ; ;             \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
; ; ;         
; ; ;         StopDrawing()
; ; ;         
; ; ;         SetGadgetState(v, GetState(*Scroll\v))
; ; ;         SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum))
; ; ;         SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum))
; ; ;         SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength))
; ; ;         
; ; ;       EndIf
; ; ;     EndWith
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure Canvas_Events(Canvas.i, EventType.i)
; ; ;     Protected Repaint, iWidth, iHeight
; ; ;     Width = GadgetWidth(Canvas)
; ; ;     Height = GadgetHeight(Canvas)
; ; ;     Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
; ; ;     Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
; ; ;     
; ; ;     
; ; ;     Select EventType
; ; ;       Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
; ; ;         Repaint | Resizes(*Scroll, x, y, Width-x*2, Height-y*2)                                        ;, *Scroll\h)
; ; ;                                                                                                        ;  Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
; ; ;         ResizeGadget(v,  *Scroll\v\x+20, *Scroll\v\y, *Scroll\v\Width, *Scroll\v\Height)
; ; ;     EndSelect
; ; ;     
; ; ;     Repaint | CallBack(*Scroll\v, EventType, mouseX,mouseY)
; ; ;     Repaint | CallBack(*Scroll\h, EventType, mouseX,mouseY)
; ; ;     
; ; ;     If Not (*Scroll\v\at Or *Scroll\h\at)
; ; ;       Select EventType
; ; ;         Case #PB_EventType_LeftButtonDown
; ; ;           SetAttribute(*Scroll\h, #PB_Bar_Inverted, *Scroll\h\Inverted!1)
; ; ;           Debug "#PB_EventType_LeftButtonDown *Scroll\h\Inverted " + *Scroll\h\Inverted
; ; ;           
; ; ;           Repaint = 1
; ; ;       EndSelect
; ; ;     EndIf
; ; ;     
; ; ;     If Repaint
; ; ;       ReDraw(g_Canvas)
; ; ;     EndIf
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure Canvas_CallBack()
; ; ;     ; Canvas events bug fix
; ; ;     Protected Result.b
; ; ;     Static MouseLeave.b
; ; ;     Protected EventGadget.i = EventGadget()
; ; ;     Protected EventType.i = EventType()
; ; ;     Protected Width = GadgetWidth(EventGadget)
; ; ;     Protected Height = GadgetHeight(EventGadget)
; ; ;     Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
; ; ;     Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
; ; ;     
; ; ;     ; Это из за ошибки в мак ос и линукс
; ; ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
; ; ;       Select EventType 
; ; ;         Case #PB_EventType_MouseEnter 
; ; ;           If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
; ; ;             EventType = #PB_EventType_MouseMove
; ; ;             MouseLeave = 0
; ; ;           EndIf
; ; ;           
; ; ;         Case #PB_EventType_MouseLeave 
; ; ;           If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
; ; ;             EventType = #PB_EventType_MouseMove
; ; ;             MouseLeave = 1
; ; ;           EndIf
; ; ;           
; ; ;         Case #PB_EventType_LeftButtonDown
; ; ;           If GetActiveGadget()<>EventGadget
; ; ;             SetActiveGadget(EventGadget)
; ; ;           EndIf
; ; ;           
; ; ;         Case #PB_EventType_LeftButtonUp
; ; ;           If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
; ; ;             MouseLeave = 0
; ; ;             CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
; ; ;               Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
; ; ;               EventType = #PB_EventType_MouseLeave
; ; ;             CompilerEndIf
; ; ;           Else
; ; ;             MouseLeave =- 1
; ; ;             Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
; ; ;             EventType = #PB_EventType_LeftClick
; ; ;           EndIf
; ; ;           
; ; ;         Case #PB_EventType_LeftClick : ProcedureReturn 0
; ; ;       EndSelect
; ; ;     CompilerEndIf
; ; ;     
; ; ;     Result | Canvas_Events(EventGadget, EventType)
; ; ;     
; ; ;     ProcedureReturn Result
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure Widget_Events()
; ; ;     Select EventType()
; ; ;       Case #PB_EventType_ScrollChange
; ; ;         Debug EventData()
; ; ;     EndSelect
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure ResizeCallBack()
; ; ;     ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
; ; ;   EndProcedure
; ; ;   
; ; ;   If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
; ; ;     g_container = ContainerGadget(#PB_Any, 10, 10, 180, 220, #PB_Container_Flat)
; ; ;     
; ; ;     g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
; ; ;     g_value = StringGadget(#PB_Any, 10, 40, 120, 20, "100", #PB_String_Numeric)
; ; ;     g_set = ButtonGadget(#PB_Any, 140, 40, 30, 20, "set")
; ; ;     
; ; ;     g_min = OptionGadget(#PB_Any, 10, 70, 160, 20, "Min")
; ; ;     g_max = OptionGadget(#PB_Any, 10, 90, 160, 20, "Max") : SetGadgetState(g_max, 1)
; ; ;     g_len = OptionGadget(#PB_Any, 10, 110, 160, 20, "len")
; ; ;     g_page_len = OptionGadget(#PB_Any, 10, 130, 160, 20, "Page len")
; ; ;     g_area_len = OptionGadget(#PB_Any, 10, 150, 160, 20, "Area len")
; ; ;     g_page_pos = OptionGadget(#PB_Any, 10, 170, 160, 20, "Page pos")
; ; ;     g_area_pos = OptionGadget(#PB_Any, 10, 190, 160, 20, "Area pos")
; ; ;     
; ; ;     CloseGadgetList()
; ; ;     
; ; ;     ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
; ; ;     g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
; ; ;     SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
; ; ;     v = ScrollBarGadget(-1, #PB_Ignore, #PB_Ignore, 1, 1, 0,0,0, #PB_ScrollBar_Vertical)
; ; ;     CloseGadgetList()
; ; ;     
; ; ;     ; Create both scroll bars
; ; ;     ;     *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
; ; ;     ;     *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
; ; ;     Bars(*Scroll, 16, 7, 1)
; ; ;     Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
; ; ;     Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
; ; ;     
; ; ;     ; Set scroll page position
; ; ;     SetState(*Scroll\v, 70)
; ; ;     SetState(*Scroll\h, 55)
; ; ;     
; ; ;     PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
; ; ;     BindGadgetEvent(g_Canvas, @Canvas_CallBack())
; ; ;     
; ; ;     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
; ; ;     
; ; ;     Define Event, value
; ; ;     Repeat 
; ; ;       Event = WaitWindowEvent()
; ; ;       Select Event
; ; ;         Case #PB_Event_Gadget
; ; ;           
; ; ;           Select EventGadget()
; ; ;             Case g_set
; ; ;               value = Val(GetGadgetText(g_value))
; ; ;               
; ; ;               Select 1
; ; ;                 Case GetGadgetState(g_min) 
; ; ;                   Select GetGadgetState(g_is_vertical)
; ; ;                     Case 1
; ; ;                       SetAttribute(*Scroll\v, #PB_ScrollBar_Minimum, value)
; ; ;                     Case 0
; ; ;                       SetAttribute(*Scroll\h, #PB_ScrollBar_Minimum, value)
; ; ;                   EndSelect
; ; ;                   
; ; ;                 Case GetGadgetState(g_max) 
; ; ;                   Select GetGadgetState(g_is_vertical)
; ; ;                     Case 1
; ; ;                       SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, value)
; ; ;                     Case 0
; ; ;                       SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, value)
; ; ;                   EndSelect
; ; ;                   
; ; ;                 Case GetGadgetState(g_len) 
; ; ;                   Select GetGadgetState(g_is_vertical)
; ; ;                     Case 1
; ; ;                       Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
; ; ;                     Case 0
; ; ;                       Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
; ; ;                   EndSelect
; ; ;                   
; ; ;                 Case GetGadgetState(g_page_len) 
; ; ;                   Select GetGadgetState(g_is_vertical)
; ; ;                     Case 1
; ; ;                       SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, value)
; ; ;                     Case 0
; ; ;                       SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, value)
; ; ;                   EndSelect
; ; ;                   
; ; ;                 Case GetGadgetState(g_area_len) 
; ; ;                   Select GetGadgetState(g_is_vertical)
; ; ;                     Case 1
; ; ;                       *Scroll\v\Area\len = value
; ; ;                     Case 0
; ; ;                       *Scroll\h\Area\len = value
; ; ;                   EndSelect
; ; ;                   
; ; ;                   
; ; ;               EndSelect
; ; ;               
; ; ;               Debug "vmi "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)
; ; ;               
; ; ;               ReDraw(g_Canvas)
; ; ;           EndSelect
; ; ;           
; ; ;       EndSelect
; ; ;     Until Event = #PB_Event_CloseWindow
; ; ;   EndIf
; ; ; CompilerEndIf
; ; ; 
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ------------------------4-----------------0------------
; EnableXP