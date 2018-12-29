; CompilerIf #PB_Compiler_IsMainFile
;   XIncludeFile "module_draw.pbi"
;   
;   XIncludeFile "module_macros.pbi"
;   XIncludeFile "module_constants.pbi"
;   XIncludeFile "module_structures.pbi"
;   
;   CompilerIf #VectorDrawing
;     UseModule Draw
;   CompilerEndIf
; CompilerEndIf


DeclareModule Bar
  EnableExplicit
  ;   UseModule Macros
  ;   UseModule Constants
  ;   UseModule Structures
  ;   
  ;   CompilerIf #VectorDrawing
  ;     UseModule Draw
  ;   CompilerEndIf
  
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
  
  Global *Bar.Post_S
  
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
  
  ;-
  ;- - DECLAREs MACROs
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
  
  Macro is(_scroll_) : Bool(((_scroll_\v And _scroll_\v\at) Or (_scroll_\h And _scroll_\h\at))) : EndMacro
  ;Macro is(_scroll_) : Bool((((_scroll_\v And Not _scroll_\v\at) Or Not _scroll_\v) And ((_scroll_\h And Not _scroll_\h\at) Or Not _scroll_\h))) : EndMacro
  ;Macro is(_scroll_) : Bool( Bool((_scroll_\v And Not _scroll_\v\at) And (_scroll_\h And Not _scroll_\h\at)) Or Not Bool(_scroll_\v And _scroll_\h)) : EndMacro
  ;   Macro x(_this_) : _this_\X+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\Width : EndMacro
  ;   Macro y(_this_) : _this_\Y+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\Height : EndMacro
  Macro width(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\Width : EndMacro
  Macro height(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\Height : EndMacro
  
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
  
  ;- - DECLAREs
  Declare.i Draw(*This.Bar_S)
  Declare.i Y(*This.Bar_S)
  Declare.i X(*This.Bar_S)
  ;   Declare.i Width(*This.Bar_S)
  ;   Declare.i Height(*This.Bar_S)
  Declare.i GetState(*This.Bar_S)
  Declare.i SetState(*This.Bar_S, ScrollPos.i)
  Declare.i GetAttribute(*This.Bar_S, Attribute.i)
  Declare.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
  Declare.i CallBack(*This.Bar_S, EventType.i, mouseX=0, mouseY=0)
  Declare.i Draws(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
  Declare.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This.Bar_S, iX.i,iY.i,iWidth.i,iHeight.i, *That.Bar_S=#Null)
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  
  Declare.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
  Declare.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Bar
  #PB_Bar_Ticks = 1<<5
  #PB_Bar_Smooth = 1<<6
  
  *Bar = AllocateStructure(Post_S)
  *Bar\Type =- 1
   
  Global Colors.Color_S
  
  With Colors                          
    \State = 0
    ;- Синие цвета
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
  Procedure.i X(*This.Bar_S)
    Protected Result.l
    
    If *This
      With *This
        If Not \Hide[1] And \color\Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*This.Bar_S)
    Protected Result.l
    
    If *This
      With *This
        If Not \Hide[1] And \color\Alpha
          Result = \Y ; -(\Height-\Radius/2)+1
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Draw(*This.Bar_S)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This
      \Change = 0
      *Bar\Type =- 1 
      *Bar\Widget = 0
      
      If *This And Not \hide And \color\alpha
        State_0 = \Color[0]\State
        State_1 = \Color[1]\State
        State_2 = \Color[2]\State
        State_3 = \Color[3]\State
        Alpha = \color\alpha<<24
        LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
        
        Select \Type
          Case #PB_GadgetType_TrackBar
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
          
          Case #PB_GadgetType_ProgressBar
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
            
          Case #PB_GadgetType_ScrollBar
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
            
        EndSelect
      EndIf
    EndWith 
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
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i GetState(*This.Bar_S)
    ProcedureReturn Invert(*This, *This\Page\Pos, *This\Inverted)
  EndProcedure
  
  Procedure.i SetState(*This.Bar_S, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
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
          
          *Bar\Widget = *This
          *Bar\Type = #PB_EventType_Change
          \Thumb\Pos = ThumbPos(*This, ScrollPos)
          \Page\Pos = ScrollPos
          \Change = 1
          
          If \s
            If \Vertical
              \s\y =- \Page\Pos
            Else
              \s\x =- \Page\Pos
            EndIf
            
            If \s\Post\event
              If \s\Post\widget
                PostEvent(\s\Post\event, \s\Post\window, \s\Post\widget, #PB_EventType_ScrollChange, \Direction) 
              Else
                PostEvent(\s\Post\event, \s\Post\window, \s\Post\gadget, #PB_EventType_ScrollChange, \Direction) 
              EndIf
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
  
  Procedure.i Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i, *That.Bar_S=#Null)
    Protected Lines.i, ScrollPage.i
;     If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And
;                   Width=#PB_Ignore And Height=#PB_Ignore)
;         *Bar\Handle = *This
;         *Bar\Event = #PB_EventType_Resize
;       EndIf
      
    With *This
      If *This <> *That And *That And *That\hide
        If \Vertical
          If Height=#PB_Ignore 
            Height=(*That\Y+*That\Height)-\Y 
          EndIf
        Else
          If Width=#PB_Ignore
            Width=(*That\X+*That\Width)-\X 
          EndIf
        EndIf
      EndIf
      
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
      
      
; ;       ScrollPage = ((\Max-\Min) - \Page\len)
; ;       Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
; ;       
; ;       ;
; ;       If X=#PB_Ignore : X = \X[0] : EndIf 
; ;       If Y=#PB_Ignore : Y = \Y[0] : EndIf 
; ;       If Width=#PB_Ignore : Width = \Width[0] : EndIf 
; ;       If Height=#PB_Ignore : Height = \Height[0] : EndIf
; ;       
; ;       ; 
; ;       \hide[1] = Bool(Not (\Page\Len And (\Max-\Min) > \Page\len))
; ;       
; ;       If Not \hide[1]
; ;         If \Vertical
; ;           \Area\Pos = Y+\Button\len
; ;           \Area\len = (Height-\Button\len*2)
; ;         Else
; ;           \Area\Pos = X+\Button\len
; ;           \Area\len = (Width-\Button\len*2)
; ;         EndIf
; ;         
; ;         If \Area\len
; ;           \Thumb\len = ThumbLength(*This)
; ;           
; ;           If (\Area\len > \Button\len)
; ;             If \Button\len
; ;               If (\Thumb\len < \Button\len)
; ;                 \Area\len = Round( \Area\len - ( \Button\len-\Thumb\len), #PB_Round_Nearest)
; ;                 \Thumb\len = \Button\len 
; ;               EndIf
; ;             Else
; ;               If ( \Thumb\len < 7)
; ;                 \Area\len = Round( \Area\len - (7-\Thumb\len), #PB_Round_Nearest)
; ;                 \Thumb\len = 7
; ;               EndIf
; ;             EndIf
; ;           Else
; ;             \Thumb\len = \Area\len 
; ;           EndIf
; ;           
; ;           If \Area\len > 0
; ;             ; Debug " scroll set state "+\Max+" "+\Page\len+" "+Str( \Thumb\Pos+\Thumb\len) +" "+ Str( \Area\len+\Button\len)
; ;             If (\Page\Pos >= (\Max-\Min) - \Page\len) And (\Type <> #PB_GadgetType_TrackBar) 
; ;               SetState(*This, (\Max-\Min))
; ;               ;             If ( \Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\len) >= (\Area\Pos+\Area\len)
; ;               ;               SetState(*This, ScrollPage)
; ;             EndIf
; ;             
; ;             \Thumb\Pos = ThumbPos(*This, \Page\Pos)
; ;           EndIf
; ;         EndIf
; ;       EndIf
; ;       
; ;       \X[0] = X : \Y[0] = Y : \Width[0] = Width : \Height[0] = Height                                          ; Set scroll bar coordinate
; ;       
; ;       If \Vertical
; ;         \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\len                   ; Top button coordinate on scroll bar
; ;         \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\len : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
; ;         \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len           ; Thumb coordinate on scroll bar
; ;       Else
; ;         \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\len : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
; ;         \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\len : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
; ;         \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len          ; Thumb coordinate on scroll bar
; ;       EndIf
; ;       
; ;       ProcedureReturn \hide[1]
; ;     EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
    
    *Scroll\v\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
    *Scroll\h\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
    
    If *Scroll\v\hide : *Scroll\v\Page\Pos = 0 : If vPos : *Scroll\v\hide = vPos : EndIf : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = iWidth+*Scroll\v\Width : EndIf
    If *Scroll\h\hide : *Scroll\h\Page\Pos = 0 : If hPos : *Scroll\h\hide = hPos : EndIf : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = iHeight+*Scroll\h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    If Width=#PB_Ignore : Width = *Scroll\v\X : Else : Width+x-*Scroll\v\Width : EndIf
      If Height=#PB_Ignore : Height = *Scroll\h\Y : Else : Height+y-*Scroll\h\Height : EndIf
      
      SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height)-*Scroll\v\y)
      SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width)-*Scroll\h\x)
      
      *Scroll\v\Hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, Bool(*Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\Height)-*Scroll\v\Y)) 
      *Scroll\h\Hide = Resize(*Scroll\h, X, Height, Bool(*Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\Width)-*Scroll\h\X), #PB_Ignore) 
      
      SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, (*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height)-*Scroll\v\y)
      SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, (*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width)-*Scroll\h\x)
      
      ; 
      *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(*Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\Height)-*Scroll\v\Y))
      *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, Bool(*Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\Width)-*Scroll\h\X), #PB_Ignore)
      
      If Not *Scroll\v\Hide 
        Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not *Scroll\h\Hide 
        Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4)
      EndIf
      
      *Scroll\Width[2] = x(*Scroll\v)-*Scroll\h\x ; *Scroll\h\Page\len ;
    *Scroll\Height[2] = y(*Scroll\h)-*Scroll\v\y  ; *Scroll\v\Page\len ;(*Scroll\h\Y + Bool(Not *Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\y;
    ProcedureReturn 1
      
      If y=#PB_Ignore : y = *Scroll\v\Y : EndIf
      If x=#PB_Ignore : x = *Scroll\h\X : EndIf
      If Width=#PB_Ignore : Width = *Scroll\v\X-*Scroll\h\X+*Scroll\v\width : EndIf
      If Height=#PB_Ignore : Height = *Scroll\h\Y-*Scroll\v\Y+*Scroll\h\height : EndIf
      
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
      
      *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*Scroll\h\Y+Bool(*Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\Y) + Bool(*Scroll\v\Radius And Not *Scroll\h\Hide)*4)
      *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, ((*Scroll\v\X+Bool(*Scroll\v\Hide) * *Scroll\v\width) - *Scroll\h\X) + Bool(*Scroll\h\Radius And Not *Scroll\v\Hide)*4, #PB_Ignore)
      
      *Scroll\Width[2] = x(*Scroll\v)-*Scroll\h\x ; *Scroll\h\Page\len ; 
      *Scroll\Height[2] = y(*Scroll\h)-*Scroll\v\y ; *Scroll\v\Page\len ;  ; *Scroll\v\Page\len ;(*Scroll\h\Y + Bool(Not *Scroll\h\Hide) * *Scroll\h\Height) - *Scroll\v\y;
      ProcedureReturn 1
  EndProcedure
  Procedure.b _Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    If Not Bool(*Scroll\v And *Scroll\h) 
      If *Scroll\v
        If Width<>#PB_Ignore
          X = Width-*Scroll\v\Width
        EndIf
        ProcedureReturn Resize(*Scroll\v, X,#PB_Ignore,#PB_Ignore,Height.i)
      ElseIf *Scroll\h
        If Height<>#PB_Ignore
          Y = Height-*Scroll\h\Height
        EndIf
        ProcedureReturn Resize(*Scroll\h, #PB_Ignore,Y,Width.i,#PB_Ignore)
      Else
        *Scroll\Width[2] = Width
        *Scroll\Height[2] = Height
        ProcedureReturn - 1
      EndIf
    EndIf
    
    If *Scroll\v And Y<>#PB_Ignore And *Scroll\v\Max <> *Scroll\Height
      SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, *Scroll\Height)
    EndIf
    If *Scroll\h And X<>#PB_Ignore And *Scroll\h\Max <> *Scroll\Width
      SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, *Scroll\Width)
    EndIf
    
    If Width=#PB_Ignore : Width = *Scroll\v\X : Else : Width+x-*Scroll\v\Width : EndIf
    If Height=#PB_Ignore : Height = *Scroll\h\Y : Else : Height+y-*Scroll\h\Height : EndIf
    
    Protected iWidth = x(*Scroll\v)-*Scroll\h\x, iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    *Scroll\v\Hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, #PB_Ignore, *Scroll\h) : iWidth = x(*Scroll\v)-*Scroll\h\x
    *Scroll\h\Hide = Resize(*Scroll\h, X, Height, #PB_Ignore, #PB_Ignore, *Scroll\v) : iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If *Scroll\v\width : *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) : EndIf
    If *Scroll\h\height : *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v) : EndIf
    
    If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : *Scroll\Y = 0 : Else
      If *Scroll\h\Radius : Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore) : EndIf
    EndIf
    If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : *Scroll\X = 0 : Else
      If *Scroll\v\Radius : Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4) : EndIf
    EndIf
    
    *Scroll\Width[2] = x(*Scroll\v)-*Scroll\h\x
    *Scroll\Height[2] = y(*Scroll\h)-*Scroll\v\y
    
    ProcedureReturn Bool(Not Bool(*Scroll\v\Hide|*Scroll\h\Hide))
  EndProcedure
  
  
  Procedure.i Events(*This.Bar_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    If *This
      
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
      If *This And Not \hide And \color\alpha ; And \Type = #PB_GadgetType_ScrollBar
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
  
  Procedure.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Radius = Radius
      \Vertical = Bool(Flag&#PB_ScrollBar_Vertical)
      \Ticks = Bool(Flag&#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth)
      
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
      
      If Bool(Flag&#PB_ScrollBar_Inverted)
        SetAttribute(*This, #PB_ScrollBar_Inverted, 1) 
      EndIf
      
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *This.Bar_S = Bar(X,Y,Width,Height, Min, Max, PageLength, Flag, Radius)
    
    With *This
      \Type = #PB_GadgetType_ScrollBar
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_ScrollBar_Vertical|#PB_ScrollBar_Inverted)
    Protected *This.Bar_S = Bar(X,Y,Width,Height, Min, Max, 0, Smooth|Vertical|#PB_ScrollBar_NoButtons, 0)
    
    With *This
      \Type = #PB_GadgetType_ProgressBar
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_ScrollBar_Vertical|#PB_ScrollBar_Inverted)
    Protected *This.Bar_S = Bar(X,Y,Width,Height, Min, Max, 0, Ticks|Vertical|#PB_ScrollBar_NoButtons, 0)
    
    With *This
      \Type = #PB_GadgetType_TrackBar
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

Macro GetActiveWidget()
  Bar::*Bar\Active
EndMacro

Macro EventWidget()
  Bar::*Bar\Widget
EndMacro

Macro WidgetEventType()
  Bar::*Bar\Type
EndMacro

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Bar
  
  Global.i gEvent, gQuit, value, direction
  Global *Bar_0.Bar_S=AllocateStructure(Bar_S)
  
  Procedure ReDraw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Window_0()
      Protected y=50
    If OpenWindow(0, 0, 0, 400, 100+y, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ProgressBarGadget(2, 15, 10, 370,  30, 0,  100)
      
      ButtonGadget   (0,    5,   y+65, 390,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,y+10, 380, 50, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      *Bar_0 = Progress(5, 10, 370,  30, 0,  100)
      
;        SetGadgetState(2, 1)
;          SetState(*Bar_0, 1)
      ;ProgressBar::Gadget(1, 5, 10, 370,  30, 20,  50, #PB_ScrollBar_NoButtons)
      
      ReDraw(1)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If IsStart(*Bar_0)
          direction = 1
        EndIf
        If IsStop(*Bar_0)
          direction =- 1
        EndIf
        
        value + direction
        
        SetGadgetState(2, value)
        If SetState(*Bar_0, value)
          If WidgetEventType() = #PB_EventType_Change
            PostEvent(#PB_Event_Gadget, 0, 1)
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            value = GetState(*Bar_0)
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEventType() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_ScrollBar_Direction)))
        EndIf
        
        ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=50,y=50
  
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
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    If EventType = #PB_EventType_ScrollChange ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Bar::Resizes(*Scroll, x, y, Width-x*2, Height-y*2)
        Bar::Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; проверка
    EndSelect
    
    Repaint | Bar::CallBack(*Scroll\v, EventType)
    Repaint | Bar::CallBack(*Scroll\h, EventType)
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      
      ClipOutput(x,y, *Scroll\Width[2], *Scroll\Height[2])
      DrawImage(ImageID(0), x+*Scroll\x, y+*Scroll\y)
      UnclipOutput()
      
      Bar::Draws(*Scroll, *Scroll\Width, *Scroll\Height)
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
        Debug EventData()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 425, 260, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1, 10,10,405,240, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    ;Debug SizeOf(*Scroll)
    
    ; post event
    *Scroll\Post\window = 0
    *Scroll\Post\gadget = 1
    *Scroll\Post\Function = @Widget_Events()
    *Scroll\Post\event = #PB_Event_Widget
    
    Bar::Bars(*Scroll, 16, 7, 1)
    Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
    Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
    
    Bar::SetState(*Scroll\v, 150)
    Bar::SetState(*Scroll\h, 100)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @Canvas_CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --f-v---fd-+--v0f-0--8-----------------------------
; EnableXP