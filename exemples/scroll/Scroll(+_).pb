
DeclareModule Scroll
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
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
    ScrollStep.i
  EndStructure
  
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    *s.Scroll_S
    Type.i
    Widget.i
    Radius.i
    ArrowSize.b[3]
    ArrowType.b[3]
    
    Buttons.i
    Both.b ; we see both scrolbars
    
    Hide.b[2]
    Alpha.a[2]
    Disable.b[2]
    Vertical.b
    
    Max.i
    Min.i
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
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    Post.Post_S
    
    v.Bar_S
    h.Bar_S
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
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min))*((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
  EndMacro
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\len : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\len : EndIf
  EndMacro
  
  Macro x(_this_) : _this_\X+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\Width : EndMacro
  Macro y(_this_) : _this_\Y+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\Height : EndMacro
  Macro width(_this_) : Bool(Not _this_\hide[1] And _this_\alpha)*_this_\Width : EndMacro
  Macro height(_this_) : Bool(Not _this_\hide[1] And _this_\alpha)*_this_\Height : EndMacro
  
  ;- - DECLAREs
  Declare.i Draw(*This.Bar_S)
  ; ; ;   Declare.i Draws(*Scroll.Scroll_S)
  Declare.b SetState(*This.Bar_S, ScrollPos.i)
  Declare.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
  Declare.b CallBack(*This.Bar_S, EventType.i, MouseX.i, MouseY.i)
  Declare.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  ; ; ;   Declare.b Resize(*This.Bar_S, iX.i,iY.i,iWidth.i,iHeight.i, *That.Bar_S=#Null)
  
  Declare.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
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
      ScrollPos = Match( \Min + Round((ThumbPos - \Area\Pos) / ( \Area\len / ( \Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep) 
      If ( \Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.i Draw(*This.Bar_S)
    With *This
      If Not \hide And \Alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[0], \Y[0], \Width[0], \Height[0], \Radius, \Radius, \Color[0]\Back[\Color[0]\State]&$FFFFFF|\Alpha<<24)
        
        If \Vertical
          ; Draw left line
          If \Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \Radius : Box( \X[2], \Y[2]+\Height[2]+1, \Width[2], \Height[2], \Color[0]\Back[\Color[0]\State]&$FFFFFF|\Alpha<<24) : EndIf
            Line( \X[0], \Y[0],1, \Height[0]-\Radius/2,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line( \X[0], \Y[0],1, \Height[0],$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        Else
          ; Draw top line
          If \Both
            Line( \X[0], \Y[0], \Width[0]-\Radius/2,1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line( \X[0], \Y[0], \Width[0],1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Thumb\len
          ; Draw thumb
          If \Color[3]\Fore[\Color[3]\State]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \X[3], \Y[3], \Width[3], \Height[3], \Color[3]\Fore[\Color[3]\State], \Color[3]\Back[\Color[3]\State], \Radius, \Alpha)
          
          ; Draw thumb frame
          If \Color[3]\Frame[\Color[3]\State] 
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[3], \Y[3], \Width[3], \Height[3], \Radius, \Radius, \Color[3]\Frame[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Button\len
          ; Draw buttons
          If \Color[1]\Fore[\Color[1]\State]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \X[1], \Y[1], \Width[1], \Height[1], \Color[1]\Fore[\Color[1]\State], \Color[1]\Back[\Color[1]\State], \Radius, \Alpha)
          If \Color[2]\Fore[\Color[2]\State]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color[2]\Fore[\Color[2]\State], \Color[2]\Back[\Color[2]\State], \Radius, \Alpha)
          
          ; Draw buttons frame
          If \Color[1]\Frame[\Color[1]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color[1]\Frame[\Color[1]\State]&$FFFFFF|\Alpha<<24)
          EndIf
          If \Color[2]\Frame[\Color[2]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color[2]\Frame[\Color[2]\State]&$FFFFFF|\Alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow( \X[1]+( \Width[1]-\ArrowSize[1])/2, \Y[1]+( \Height[1]-\ArrowSize[1])/2, \ArrowSize[1], Bool( \Vertical), \Color[1]\Front[\Color[1]\State]&$FFFFFF|\Alpha<<24, \ArrowType[1])
          Arrow( \X[2]+( \Width[2]-\ArrowSize[2])/2, \Y[2]+( \Height[2]-\ArrowSize[2])/2, \ArrowSize[2], Bool( \Vertical)+2, \Color[2]\Front[\Color[2]\State]&$FFFFFF|\Alpha<<24, \ArrowType[2])
        EndIf
        
        If \Color[3]\Fore[\Color[3]\State]  ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2-3,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2+3,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          Else
            Line( \X[3]+\Width[3]/2-3, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line( \X[3]+\Width[3]/2, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line( \X[3]+\Width[3]/2+3, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  ; ; ;   Procedure.i Draws(*Scroll.Scroll_S)
  ; ; ;     If Not *Scroll\v\hide
  ; ; ;       Draw(*Scroll\v)
  ; ; ;     EndIf
  ; ; ;     If Not *Scroll\h\hide
  ; ; ;       Draw(*Scroll\h)
  ; ; ;     EndIf
  ; ; ;   EndProcedure
  ; ; ;   
  ; ; ;   Procedure.i ReDraw(*This.Bar_S)
  ; ; ;     If StartDrawing(CanvasOutput(*This\s\Gadget))
  ; ; ;       Draw(*This)
  ; ; ;       StopDrawing()
  ; ; ;     EndIf
  ; ; ;   EndProcedure
  
  Procedure.b SetState(*This.Bar_S, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    ;If *This
    With *This
      If ( \Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \Max-\Min)-ScrollPos) : EndIf
      
      If ScrollPos < \Min : ScrollPos = \Min : EndIf
      If ScrollPos > ( \Max-\Page\len)
        ScrollPos = ( \Max-\Page\len)
      EndIf
      
      If \Page\Pos <> ScrollPos 
        If \Page\Pos > ScrollPos
          Direction =- ScrollPos
        Else
          Direction = ScrollPos
        EndIf
        \Page\Pos = ScrollPos
        
        \Thumb\Pos = ThumbPos(*This, ScrollPos)
        
        If \Vertical
          \s\y =- \Page\Pos
        Else
          \s\x =- \Page\Pos
        EndIf
        
        If \s\Post\event
          If \widget
            PostEvent(\s\Post\event, \s\Post\window, \widget, #PB_EventType_ScrollChange, Direction) 
          Else
            PostEvent(\s\Post\event, \s\Post\window, \s\Post\gadget, #PB_EventType_ScrollChange, Direction) 
          EndIf
        EndIf
        
        Result = #True
      EndIf
    EndWith
    ;EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
    Protected Result.i
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum
          If \Min <> Value 
            \Min = Value
            \Page\Pos = Value
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_Maximum
          If \Max <> Value
            If \Min > Value
              \Max = \Min + 1
            Else
              \Max = Value
            EndIf
            
            If \Vertical
              \s\height = \Max
            Else
              \s\width = \Max
            EndIf
            
            \Page\ScrollStep = ( \Max-\Min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \Page\len <> Value
            If Value > ( \Max-\Min) 
              If Not \Max 
                \Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает 
              EndIf
              
              If \Vertical
                \s\height = \Max
              Else
                \s\width = \Max
              EndIf
              
              \Page\len = ( \Max-\Min)
            Else
              \Page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
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
  
  Procedure.b Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i, *That.Bar_S=#Null)
    Protected Result, Lines, ScrollPage
    
    With *This
      ScrollPage = (( \Max-\Min) - \Page\len)
      Lines = Bool( \Type=#PB_GadgetType_ScrollBar)
      
      If *That
        If \Vertical
          If Height=#PB_Ignore : If *That\hide : Height=(*That\Y+*That\Height)-\Y : Else : Height = *That\Y-\Y : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *That\hide : Width=(*That\X+*That\Width)-\X : Else : Width = *That\X-\X : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X[0] : EndIf 
      If Y=#PB_Ignore : Y = \Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \Width[0] : EndIf 
      If Height=#PB_Ignore : Height = \Height[0] : EndIf
      
      ;
      If (( \Max-\Min) > \Page\len) ; = 
        If \Vertical
          \Area\Pos = Y+\Button\len
          \Area\len = (Height-\Button\len*2)
        Else
          \Area\Pos = X+\Button\len
          \Area\len = (Width-\Button\len*2)
        EndIf
        
        If \Area\len
          \Thumb\len = ThumbLength(*This)
          
          If ( \Area\len > \Button\len)
            If \Button\len
              If ( \Thumb\len < \Button\len)
                \Area\len = Round( \Area\len - ( \Button\len-\Thumb\len), #PB_Round_Nearest)
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
            ; Debug " scroll set state "+\Max+" "+\Page\len+" "+Str( \Thumb\Pos+\Thumb\len) +" "+ Str( \Area\len+\Button\len)
            If ( \Type <> #PB_GadgetType_TrackBar) And ( \Thumb\Pos+\Thumb\len) >= ( \Area\Pos+\Area\len)
              SetState(*This, ScrollPage)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
        EndIf
      EndIf
      
      
      \X[0] = X : \Y[0] = Y : \Width[0] = Width : \Height[0] = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\len                   ; Top button coordinate on scroll bar
        \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\len : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
        \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len           ; Thumb coordinate on scroll bar
      Else
        \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\len : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\len : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
        \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len          ; Thumb coordinate on scroll bar
      EndIf
      
      \hide[1] = Bool(Not (( \Max-\Min) > \Page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*Scroll\v), iHeight = Y(*Scroll\h)
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
    ;     If Not Bool(*Scroll\v And *Scroll\h) 
    ;       If *Scroll\v
    ;         ProcedureReturn Resize(*Scroll\v, Width-*Scroll\v\Width,#PB_Ignore,#PB_Ignore,Height.i)
    ;       ElseIf *Scroll\h
    ;         ProcedureReturn Resize(*Scroll\h, #PB_Ignore,Height-*Scroll\h\Height,Width.i,#PB_Ignore)
    ;       EndIf
    ;     EndIf
    
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
    
    ; Do we see both scrolbars?
    *Scroll\v\Both = Bool(Not *Scroll\h\Hide) : *Scroll\h\Both = Bool(Not *Scroll\v\Hide) 
    
    If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : Else
      If *Scroll\h\Radius : Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore) : EndIf
    EndIf
    If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : Else
      If *Scroll\v\Radius : Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4) : EndIf
    EndIf
    
    ProcedureReturn Bool(*Scroll\v\Hide|*Scroll\h\Hide)
  EndProcedure
  
  
  Procedure.i Events(*This.Bar_S, EventType.i, MouseX.i, MouseY.i, Buttons.i)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    
    If *This
      With *This
        Select EventType
          Case #PB_EventType_LeftDoubleClick 
            Select Buttons
              Case - 1
                ; If \Height > ( \Y[2]+\Height[2])
                If \Vertical
                  Repaint = SetState(*This, Pos(*This, (MouseY-\Thumb\len/2)))
                Else
                  Repaint = SetState(*This, Pos(*This, (MouseX-\Thumb\len/2)))
                EndIf
                ; EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonUp : delta = 0
          Case #PB_EventType_LeftButtonDown 
            Select Buttons
              Case 1 : Repaint = SetState(*This, ( \Page\Pos - \Page\ScrollStep))
              Case 2 : Repaint = SetState(*This, ( \Page\Pos + \Page\ScrollStep))
              Case 3 
                If \Vertical
                  delta = MouseY - \Thumb\Pos
                Else
                  delta = MouseX - \Thumb\Pos
                EndIf
            EndSelect
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = SetState(*This, Pos(*This, (MouseY-delta)))
              Else
                Repaint = SetState(*This, Pos(*This, (MouseX-delta)))
              EndIf
            EndIf
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If Buttons > 0
              \Color[Buttons]\State = 0
            Else
              ; Debug ""+*This +" "+ EventType +" "+ Buttons
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
            EndIf
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            If Buttons>0
              \Color[Buttons]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ Buttons
              
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
  
  Procedure.b CallBack(*This.Bar_S, EventType.i, MouseX.i, MouseY.i);, WheelDelta.i=0, AutoHide.b=0, *Scrol1l.Scroll_S=#Null, Window=-1, Gadget=-1)
    Protected repaint
    Static Last, Down, *Scroll.Bar_S, *Last.Bar_S, *Mouseat.Bar_S, Mousebuttons
    
    If *This
      With *This
        If \Type = #PB_GadgetType_ScrollBar
          
          ; get at point buttons
          If Mousebuttons 
          ElseIf (Mousex>=\X And Mousex<\X+\Width And Mousey>\Y And Mousey=<\Y+\Height) 
            If (Mousex>\X[1] And Mousex=<\X[1]+\Width[1] And  Mousey>\Y[1] And Mousey=<\Y[1]+\Height[1])
              \buttons = 1
            ElseIf (Mousex>\X[3] And Mousex=<\X[3]+\Width[3] And Mousey>\Y[3] And Mousey=<\Y[3]+\Height[3])
              \buttons = 3
            ElseIf (Mousex>\X[2] And Mousex=<\X[2]+\Width[2] And Mousey>\Y[2] And Mousey=<\Y[2]+\Height[2])
              \buttons = 2
            Else
              \buttons =- 1
            EndIf 
            
            Select EventType 
              Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
              Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
            EndSelect
            
            *Mouseat = *This
          Else
            \buttons = 0
            
            Select EventType 
              Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
                If \Vertical
                  If \s\h\buttons
                    If \s\h\buttons > 0
                      repaint | Events(\s\h, EventType, Mousex, Mousey, \s\h\buttons)
                    EndIf
                    repaint | Events(\s\h, EventType, Mousex, Mousey, - 1)
                    If EventType = #PB_EventType_MouseLeave
                      *Scroll = 0
                    EndIf
                    
                    \s\h\buttons = 0
                  EndIf
                EndIf     
                
                EventType = #PB_EventType_MouseMove
            EndSelect
            
            If \Vertical
              If \s\h\buttons
                If \Color[2]\State
                  repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, \buttons)
                  ;                   repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, - 1)
                  ;                   repaint | Events(\s\h, #PB_EventType_MouseEnter, Mousex, Mousey, - 1)
                  repaint | Events(\s\h, #PB_EventType_MouseEnter, Mousex, Mousey, \s\h\buttons)
                  \Color[2]\State = 0
                EndIf
              Else
                *Mouseat = 0
              EndIf
            Else
              If \s\v\buttons
                If \Color[2]\State
                  repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, \buttons)
                  ;                   repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, - 1)
                  ;                   repaint | Events(\s\v, #PB_EventType_MouseEnter, Mousex, Mousey, - 1)
                  repaint | Events(\s\v, #PB_EventType_MouseEnter, Mousex, Mousey, \s\v\buttons)
                  \Color[2]\State = 0
                EndIf
              Else
                *Mouseat = 0
              EndIf
            EndIf
            
          EndIf
          
          If *Scroll <> *Mouseat And 
             *This = *Mouseat
            *Last = *Scroll
            *Scroll = *Mouseat
          EndIf
          
          If *Scroll = *This
            If Last <> \Buttons
              ;
              ; Debug ""+Last +" "+ *This\Buttons +" "+ *This +" "+ *Last
              If Last > 0 Or (Last = 2 And \Buttons =- 1 And *Last)
                repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, Last) : *Last = 0
              EndIf
              If Not \Buttons Or (Last = 2 And \Buttons =- 1 And *Last)
                repaint | Events(*This, #PB_EventType_MouseLeave, Mousex, Mousey, - 1) : *Last = 0
              EndIf
              
              If Not last ; Or (Last =- 1 And \Buttons = 2 And *Last)
                repaint | Events(*This, #PB_EventType_MouseEnter, Mousex, Mousey, - 1)
              EndIf
              If \Buttons > 0
                repaint | Events(*This, #PB_EventType_MouseEnter, Mousex, Mousey, \Buttons)
              EndIf
              
              Last = \Buttons
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                Mousebuttons=1
                If \Buttons
                  Down = \Buttons
                  repaint | Events(*This, EventType, Mousex, Mousey, \Buttons)
                EndIf
                
              Case #PB_EventType_LeftButtonUp 
                Mousebuttons=0
                If Down
                  repaint | Events(*This, EventType, Mousex, Mousey, Down)
                EndIf
                
              Case #PB_EventType_LeftDoubleClick, 
                   #PB_EventType_LeftButtonDown, 
                   #PB_EventType_MouseMove
                
                If \Buttons
                  repaint | Events(*This, EventType, Mousex, Mousey, \Buttons)
                EndIf
            EndSelect
          EndIf
          
          ; ; ;           If AutoHide =- 1 : *Scroll = 0
          ; ; ;             AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
          ; ; ;           EndIf
          ; ; ;           
          ; ; ;           ; Auto hides
          ; ; ;           If (AutoHide And Not Drag And Not Buttons) 
          ; ; ;             If \Alpha <> \Alpha[1] : \Alpha = \Alpha[1] 
          ; ; ;               repaint =- 1
          ; ; ;             EndIf 
          ; ; ;           EndIf
          ; ; ;           If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
          ; ; ;             If \Alpha < 255 : \Alpha = 255
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
    EndIf
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *This.Bar_S, Vertical = Bool(Flag=#PB_ScrollBar_Vertical)
    
    If Vertical
      *This = *Scroll\v
    Else
      *This = *Scroll\h
    EndIf
    
    If Not *Scroll\v\s
      *Scroll\v\s = *Scroll
    EndIf
    If Not *Scroll\h\s
      *Scroll\h\s = *Scroll
    EndIf
    
    With *This
      ; \Widget = *This
      \Alpha = 255
      \Alpha[1] = 0
      \Radius = Radius
      \ArrowType[1] =- 1 ; -1 0 1
      \ArrowType[2] =- 1 ; -1 0 1
      \ArrowSize[1] = 4
      \ArrowSize[2] = 4
      \X =- 1
      \Y =- 1
      
      ; Цвет фона скролла
      \Color[0]\State = 0
      \Color[0]\Back[0] = $FFF9F9F9
      \Color[0]\Frame[0] = \Color\Back[0]
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
      \Type = #PB_GadgetType_ScrollBar
      \Vertical = Vertical
      
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
      
      If \Min <> Min : SetAttribute(*This, #PB_ScrollBar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_ScrollBar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_ScrollBar_PageLength, Pagelength) : EndIf
      
      If \s\Post\Function And \s\Post\Event
        UnbindEvent(\s\Post\Event, \s\Post\Function, \s\Post\Window, \s\Post\Gadget)
        BindEvent(\s\Post\Event, \s\Post\Function, \s\Post\Window, \s\Post\Gadget)
      EndIf
    EndWith
    
    ProcedureReturn Resize(*This, X,Y,Width,Height)
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  ; UseModule Scroll
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
      StopDrawing()
    EndIf
  EndIf
  
  Global *Scroll.Scroll::Scroll_S = AllocateStructure(Scroll::Scroll_S)
  
  Procedure Events(Canvas.i, EventType.i)
    If EventType = Scroll::#PB_EventType_ScrollChange ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    
    Protected Repaint, iWidth, iHeight
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Scroll::Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
    EndSelect
    
    Repaint | Scroll::CallBack(*Scroll\v, EventType, mousex, mousey)
    Repaint | Scroll::CallBack(*Scroll\h, EventType, mousex, mousey)
    
    iWidth = Scroll::X(*Scroll\v)
    iHeight = Scroll::Y(*Scroll\h)
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      
      ClipOutput(0,0, iWidth, iHeight)
      DrawImage(ImageID(0), *Scroll\x, *Scroll\y)
      UnclipOutput()
      
      Scroll::Draw(*Scroll\v)
      Scroll::Draw(*Scroll\h)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    
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
              Result | Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget_Events()
    Select EventType()
      Case Scroll::#PB_EventType_ScrollChange
        Debug EventData()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 325, 160, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1, 10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    Debug SizeOf(*Scroll)
    
    ; post event
    *Scroll\Post\window = 0
    *Scroll\Post\gadget = 1
    *Scroll\Post\Function = @Widget_Events()
    *Scroll\Post\event = Scroll::#PB_Event_Widget
    
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,ImageHeight(0), 0, #PB_ScrollBar_Vertical, 7)
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,ImageWidth(0), 0, 0, 7)
    
    Scroll::SetState(*Scroll\v, 150)
    Scroll::SetState(*Scroll\h, 100)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @Canvas_CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 beta 1 (MacOS X - x64)
; Folding = ---------------------------------
; EnableXP