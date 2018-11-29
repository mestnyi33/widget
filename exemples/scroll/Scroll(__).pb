
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
  
  ;- - Mouse_S
  Structure Mouse_S
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
  ;  *Delta.Mouse_S
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
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    Window.i
    Widget.i
    Event.i
    mouse.Mouse_S
    
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
  
  ;-
  ;- - DECLAREs MACROs
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min))*((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\len : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\len : EndIf
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
  
  Macro x(_this_) : _this_\X+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\Width : EndMacro
  Macro y(_this_) : _this_\Y+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\Height : EndMacro
  Macro width(_this_) : Bool(Not _this_\hide[1] And _this_\alpha)*_this_\Width : EndMacro
  Macro height(_this_) : Bool(Not _this_\hide[1] And _this_\alpha)*_this_\Height : EndMacro
  
  ;- - DECLAREs
  Declare.b Draw(*This.Scroll_S)
  Declare.b SetState(*This.Scroll_S, ScrollPos.i)
  Declare.i SetAttribute(*This.Scroll_S, Attribute.i, Value.i)
  Declare.b CallBack(*This.Scroll_S, EventType.i, *mouse.Mouse_S, AutoHide.b=0)
  Declare.i SetColor(*This.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  ;Declare.b Resize(*This.Scroll_S, iX.i,iY.i,iWidth.i,iHeight.i, *That.Scroll_S=#Null)
  
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
    \Back[2] = $C8E89C3D ; $80E89C3D
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
  Procedure.b Draw(*This.Bar_S)
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
        
        If \s\Event
          PostEvent(\s\Event, \s\Window, \s\Widget, #PB_EventType_ScrollChange, Direction) 
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
    ;         ProcedureReturn Resize(*Scroll\v, X.i,Y.i,Width.i,Height.i)
    ;       ElseIf *Scroll\h
    ;         ProcedureReturn Resize(*Scroll\h, X.i,Y.i,Width.i,Height.i)
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
  
  
  Procedure.i Events(*This.Bar_S, EventType.i, Buttons)
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
                  Repaint = SetState(*This, Pos(*This, (\s\mouse\Y-\Thumb\len/2)))
                Else
                  Repaint = SetState(*This, Pos(*This, (\s\mouse\X-\Thumb\len/2)))
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
                  delta = \s\mouse\Y - \Thumb\Pos
                Else
                  delta = \s\mouse\X - \Thumb\Pos
                EndIf
            EndSelect
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = SetState(*This, Pos(*This, (\s\mouse\Y-delta)))
              Else
                Repaint = SetState(*This, Pos(*This, (\s\mouse\X-delta)))
              EndIf
            EndIf
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If Buttons > 0
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ Buttons
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
            EndIf
            
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
  
  Procedure.b CallBack(*This.Bar_S, EventType.i, *mouse.Mouse_S, AutoHide.b=0)
    Protected repaint
    Static Last, Down, *Scroll.Bar_S, *Last.Bar_S
    
    If *This
      With *This
        If \Type = #PB_GadgetType_ScrollBar
          
          ; get at point buttons
          If *mouse\buttons 
          ElseIf (*mouse\x>=\X And *mouse\x<\X+\Width And *mouse\y>\Y And *mouse\y=<\Y+\Height) 
            If (*mouse\x>\X[1] And *mouse\x=<\X[1]+\Width[1] And  *mouse\y>\Y[1] And *mouse\y=<\Y[1]+\Height[1])
              \buttons = 1
            ElseIf (*mouse\x>\X[3] And *mouse\x=<\X[3]+\Width[3] And *mouse\y>\Y[3] And *mouse\y=<\Y[3]+\Height[3])
              \buttons = 3
            ElseIf (*mouse\x>\X[2] And *mouse\x=<\X[2]+\Width[2] And *mouse\y>\Y[2] And *mouse\y=<\Y[2]+\Height[2])
              \buttons = 2
            Else
              \buttons =- 1
            EndIf 
            
            Select EventType 
              Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
              Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
            EndSelect
           
            If \Vertical
              \s\mouse\at = *This
            Else
              \s\mouse\at = *This
            EndIf
          Else
            \buttons = 0
            
            Select EventType 
              Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
                If \Vertical
                  If \s\h\buttons
                    If \s\h\buttons > 0
                      repaint | Events(\s\h, EventType, \s\h\buttons)
                    EndIf
                    repaint | Events(\s\h, EventType, - 1)
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
                  repaint | Events(*Scroll, #PB_EventType_MouseLeave, *Scroll\buttons)
;                   repaint | Events(*Scroll, #PB_EventType_MouseLeave, - 1)
;                   repaint | Events(\s\h, #PB_EventType_MouseEnter, - 1)
                  repaint | Events(\s\h, #PB_EventType_MouseEnter, \s\h\buttons)
                  \Color[2]\State = 0
                EndIf
              Else
                \s\mouse\at = 0
              EndIf
            Else
              If \s\v\buttons
                If \Color[2]\State
                  repaint | Events(*Scroll, #PB_EventType_MouseLeave, *Scroll\buttons)
;                   repaint | Events(*Scroll, #PB_EventType_MouseLeave, - 1)
;                   repaint | Events(\s\v, #PB_EventType_MouseEnter, - 1)
                  repaint | Events(\s\v, #PB_EventType_MouseEnter, \s\v\buttons)
                  \Color[2]\State = 0
                EndIf
              Else
                \s\mouse\at = 0
              EndIf
            EndIf
          EndIf
          
;           If \Vertical
            If *Scroll <> \s\mouse\at And 
               *This = \s\mouse\at
              *Last = *Scroll
              *Scroll = \s\mouse\at
            EndIf
;           Else
;             If *Scroll <> \s\mouse\at And
;                *This = \s\mouse\at
;               *Last = *Scroll
;               *Scroll = \s\mouse\at
;             EndIf
;           EndIf
          
          If *Scroll = *This
            If Last <> *Scroll\Buttons
              ;
               ; Debug ""+Last +" "+ *Scroll\Buttons +" "+ *Scroll +" "+ *Last
              If Last > 0 Or (Last = 2 And *Scroll\Buttons =- 1 And *Last)
                repaint | Events(*Scroll, #PB_EventType_MouseLeave, Last) : *Last = 0
              EndIf
              If Not *Scroll\Buttons Or (Last = 2 And *Scroll\Buttons =- 1 And *Last)
                repaint | Events(*Scroll, #PB_EventType_MouseLeave, - 1) : *Last = 0
              EndIf
              
              If Not last ; Or (Last =- 1 And *Scroll\Buttons = 2 And *Last)
                repaint | Events(*Scroll, #PB_EventType_MouseEnter, - 1)
              EndIf
              If *Scroll\Buttons > 0
                repaint | Events(*Scroll, #PB_EventType_MouseEnter, *Scroll\Buttons)
              EndIf
              
              Last = *Scroll\Buttons
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                If *Scroll\Buttons
                  Down = *Scroll\Buttons
                  repaint | Events(*Scroll, EventType, *Scroll\Buttons)
                EndIf
                
              Case #PB_EventType_LeftButtonUp 
                If Down
                  repaint | Events(*Scroll, EventType, Down)
                EndIf
                
              Case #PB_EventType_LeftDoubleClick, 
                   #PB_EventType_LeftButtonDown, 
                   #PB_EventType_MouseMove
                
                If *Scroll\Buttons
                  repaint | Events(*Scroll, EventType, *Scroll\Buttons)
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
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    ; 
    Protected Vertical = Bool(Flag=#PB_ScrollBar_Vertical)
    
    If Vertical
      *Scroll\v.Bar_S = *This
      *Scroll\v\s.Scroll_S = AllocateStructure(Scroll_S)
      *Scroll\v\s = *Scroll
;       *Scroll\v\h = *Scroll\h
;       If *Scroll\h
;         *Scroll\h\v = *Scroll\v
;       EndIf
    Else
      *Scroll\h.Bar_S = *This
      *Scroll\h\s.Scroll_S = AllocateStructure(Scroll_S)
      *Scroll\h\s = *Scroll
;       *Scroll\h\v = *Scroll\v
;       If *Scroll\v
;         *Scroll\v\h = *Scroll\h
;       EndIf
    EndIf
    
    ; Invisible
    If Flag =- 1
      ProcedureReturn *This
    EndIf
    
    With *This
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
  
  Global *Scroll.Scroll::Scroll_S=AllocateStructure(Scroll::Scroll_S)
  
  Procedure CallBack()
    If EventType() = Scroll::#PB_EventType_ScrollChange ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    
    Protected Repaint, iWidth, iHeight
    Protected Canvas = EventGadget()
    *Scroll\mouse\X = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    *Scroll\mouse\Y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    *Scroll\mouse\Wheel = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    *Scroll\mouse\Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Scroll::Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
    EndSelect
    
    Repaint | Scroll::CallBack(*Scroll\v, EventType(), *Scroll\mouse)
    Repaint | Scroll::CallBack(*Scroll\h, EventType(), *Scroll\mouse)
    
    If *Scroll\v
      iWidth = Scroll::X(*Scroll\v)
    Else
      iWidth = Width
    EndIf
    If *Scroll\h
      iHeight = Scroll::Y(*Scroll\h)
    Else
      iHeight = Height
    EndIf
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      ClipOutput(0,0, iWidth, iHeight)
      DrawImage(ImageID(0), *Scroll\x, *Scroll\y)
      ;DrawImage(ImageID(0), -*Scroll\h\Page\Pos, -*Scroll\v\Page\Pos)
      UnclipOutput()
      
      Scroll::Draw(*Scroll\v)
      Scroll::Draw(*Scroll\h)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Events()
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
    
    ; post event
    *Scroll\Window = 0
    *Scroll\Widget = 1
    *Scroll\Event = #PB_Event_Gadget ; #PB_Event_Widget
    
    ; *Scroll\h.Scroll_S = AllocateStructure(Scroll_S)
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,ImageHeight(0), 0, #PB_ScrollBar_Vertical, 7)
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,ImageWidth(0), 0, 0, 7)
    
    Scroll::SetState(*Scroll\v, 150)
    Scroll::SetState(*Scroll\h, 100)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @CallBack())
    BindGadgetEvent(1, @Events())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------f-0f-0--8-f-------------
; EnableXP