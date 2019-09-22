;
; Os              : All
; Version         : 1.4
; License         : Free
; Module name     : Scroll
; Author          : mestnyi
; PB version:     : 5.46 =< 5.62
; Last updated    : 22 Sep 2018
; Topic           : https://www.purebasic.fr/english/posting.php?mode=edit&f=12&p=521603
;

CompilerIf #PB_Compiler_IsMainFile
  DeclareModule Constant
    CompilerIf #PB_Compiler_Version =< 546
      Enumeration #PB_EventType_FirstCustomValue
        #PB_EventType_Resize
      EndEnumeration
    CompilerEndIf
  EndDeclareModule 
  Module Constant : EndModule : UseModule Constant
CompilerEndIf

DeclareModule Scroll
  EnableExplicit
  #Vertical = #PB_ScrollBar_Vertical
  
  ;- STRUCTUREs
  ;- - _S_color
  Structure _S_color
    state.b
    Front.l[4]
    Fore.l[4]
    Back.l[4]
    Line.l[4]
    Frame.l[4]
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    pos.l
    len.l
    scroll_step.l
  EndStructure
  
  ;- - _S_button
  Structure _S_button
    x.l
    y.l
    width.l
    height.l
    len.l
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget
    x.l
    y.l
    width.l
    height.l
    
    Max.l
    Min.l
    
    Type.l
    from.l
    Focus.l
    Radius.l
    
    Hide.b[2]
    Alpha.a[2]
    ; Disable.b[2]
    Vertical.b
    inverted.b
    
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    button._S_button[4] 
  EndStructure
  
  ;- - _S_scroll
  Structure _S_scroll
    x.l
    y.l
    width.l
    height.l
    
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;-
  ;- - DECLAREs
  Declare.b Draw(*Scroll._S_widget)
  Declare.l Y(*Scroll._S_widget)
  Declare.l X(*Scroll._S_widget)
  Declare.l Width(*Scroll._S_widget)
  Declare.l Height(*Scroll._S_widget)
  Declare.b SetState(*Scroll._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*Scroll._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*Scroll._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  Declare.b Resize(*This._S_widget, iX.l,iY.l,iWidth.l,iHeight.l, *Scroll._S_widget=#Null)
  Declare.b Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0, AutoHide.b=0, *Scroll._S_widget=#Null)
  Declare.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
  
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1)
EndDeclareModule

Module Scroll
  ;- GLOBALs
  Global Color_Default._S_color
  
   With Color_Default                          
    \state = 0
    ;\alpha = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[0] = $FFE2E2E2 ; $80E2E2E2
    \frame[0] = $FFBABABA ; $80C8C8C8
    \Line[0] = \front[0] 
  
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFEAEAEA ; $FFFAF8F8
    \back[1] = $FFCECECE ; $80FCEADA
    \frame[1] = $FF8F8F8F ; $80FFC288
    \Line[1] = \front[1] 
  
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[2] = $FF6F6F6F ; $C8DC9338 ; $80DC9338
    \Line[2] = \front[2] 
  EndWith
  
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
  
  ;-
  Macro _scroll_in_start_(_this_) : Bool(_this_\page\pos =< _this_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\page\pos >= (_this_\max-_this_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\Vertical ; And Bool(_this_\type <> #PB_GadgetType_Spin) 
      _this_\button[3]\height = _this_\Thumb\len
    Else
      _this_\button[3]\width = _this_\Thumb\len
    EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\pos+_this_\area\len 
      _this_\thumb\pos = (_this_\area\pos+_this_\area\len)-_this_\thumb\len 
    EndIf 
    
    If _this_\Vertical ; And Bool(_this_\type <> #PB_GadgetType_Spin) 
      _this_\button[3]\y = _this_\Thumb\Pos
    Else
      _this_\button[3]\x = _this_\Thumb\Pos
    EndIf
  EndMacro
  
  Procedure.i PagePos(*this._S_widget, State.i)
    With *this
      If State < \min : State = \min : EndIf
      
      If State > \max-\page\len
        If \max > \page\len 
          State = \max-\page\len
        Else
          State = \min 
        EndIf
      EndIf
      
      ;       ; 77777777777
      ;       If \vertical
      ;         State - \y
      ;       Else
      ;         State - \x
      ;       EndIf
      
    EndWith
    
    ProcedureReturn State
  EndProcedure
  
  Procedure.i ScrollPos(*this._S_widget, ThumbPos.i)
    Static ScrollPos.i
    Protected Result.i
    Protected min.i, max.i
    
    With *this
      min = \area\pos + \min
      max = \area\pos + Round(((\max-\min) - \area\len) * (\area\len / (\max-\min)), #PB_Round_Nearest)
      
      If ThumbPos < min : ThumbPos = min : EndIf
      If ThumbPos > max : ThumbPos = max : EndIf
      
      If ScrollPos <> ThumbPos 
        ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        If \page\scroll_step > 1
          ScrollPos = Round(ScrollPos / \page\scroll_step, #PB_Round_Nearest) * \page\scroll_step
        EndIf
        If #PB_GadgetType_TrackBar = \type And \vertical 
          ScrollPos = Invert(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
        ScrollPos = ThumbPos
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1)
    Protected I
    
    
    If Direction = 1
      For i = 0 To Size 
        ; в верх
        LineXY((X+i)+Size,(Y+i-1)-(Thickness),(X+i)+Size,(Y+i-1)+(Thickness),Color) ; Левая линия
        LineXY(((X+(Size))-i),(Y+i-1)-(Thickness),((X+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
      Next
    ElseIf Direction = 3
      For i = 0 To Size
        ; в низ
        LineXY((X+i),(Y+i)-(Thickness),(X+i),(Y+i)+(Thickness),Color) ; Левая линия
        LineXY(((X+(Size*2))-i),(Y+i)-(Thickness),((X+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
      Next
    ElseIf Direction = 0 ; в лево
      For i = 0 To Size  
        ; в лево
        LineXY(((X+1)+i)-(Thickness),(((Y-2)+(Size))-i),((X+1)+i)+(Thickness),(((Y-2)+(Size))-i),Color) ; правая линия
        LineXY(((X+1)+i)-(Thickness),((Y-2)+i)+Size,((X+1)+i)+(Thickness),((Y-2)+i)+Size,Color)         ; Левая линия
      Next
    ElseIf Direction = 2 ; в право
      For i = 0 To Size
        ; в право
        LineXY(((X+2)+i)-(Thickness),((Y-2)+i),((X+2)+i)+(Thickness),((Y-2)+i),Color) ; Левая линия
        LineXY(((X+2)+i)-(Thickness),(((Y-2)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y-2)+(Size*2))-i),Color) ; правая линия
      Next
    EndIf
    
  EndProcedure
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid : If (Value>Max) : Value=Max : EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.l Pos(*This._S_widget, ThumbPos.l)
    Protected ScrollPos.l
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\len / (\Max-\Min)), #PB_Round_Nearest), \Page\scroll_step)
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll._S_widget)
    With *Scroll
      If Not \Hide And \Alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\Width,\Height,\Radius,\Radius,\Color[0]\Back&$FFFFFF|\Alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\line&$FFFFFF|\Alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\line&$FFFFFF|\Alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \Thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height,\Color[3]\Fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \Alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height,\Radius,\Radius,\Color[3]\Frame[\color[3]\state]&$FFFFFF|\Alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[1]\x,\button[1]\y,\button[1]\width,\button[1]\height,\Color[1]\Fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \Alpha)
          BoxGradient(\Vertical,\button[2]\x,\button[2]\y,\button[2]\width,\button[2]\height,\Color[2]\Fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \Alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[1]\x,\button[1]\y,\button[1]\width,\button[1]\height,\Radius,\Radius,\Color[1]\Frame[\color[1]\state]&$FFFFFF|\Alpha<<24)
          RoundBox(\button[2]\x,\button[2]\y,\button[2]\width,\button[2]\height,\Radius,\Radius,\Color[2]\Frame[\color[2]\state]&$FFFFFF|\Alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[1]\x+(\button[1]\width-6)/2,\button[1]\y+(\button[1]\height-3)/2, 3, Bool(\Vertical), \Color[1]\Line[\color[1]\state]&$FFFFFF|\Alpha<<24)
          Arrow(\button[2]\x+(\button[2]\width-6)/2,\button[2]\y+(\button[2]\height-3)/2, 3, Bool(\Vertical)+2, \Color[2]\Line[\color[2]\state]&$FFFFFF|\Alpha<<24)
        EndIf
        
        ; Draw thumb lines
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2-3,9,1,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2,9,1,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2+3,9,1,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
        Else
          Line(\button[3]\x+\button[3]\width/2-3,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
          Line(\button[3]\x+\button[3]\width/2,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
          Line(\button[3]\x+\button[3]\width/2+3,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\Line[\color[3]\state]&$FFFFFF|\Alpha<<24)
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.l X(*Scroll._S_widget)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Y(*Scroll._S_widget)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Width(*Scroll._S_widget)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Width And \Alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Height(*Scroll._S_widget)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Height And \Alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*Scroll._S_widget, ScrollPos.l)
    Protected Result.b
    
    With *Scroll
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
      
      If ScrollPos < \Min : ScrollPos = \Min : EndIf
      If ScrollPos > (\Max-\Page\len)
        ScrollPos = (\Max-\Page\len)
      EndIf
      
      If \Page\Pos<>ScrollPos : \Page\Pos=ScrollPos
        \Thumb\Pos = ThumbPos(*Scroll, ScrollPos)
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*Scroll._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *Scroll
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
            
            \Page\scroll_step = (\Max-\Min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \Page\len <> Value
            If Value > (\Max-\Min) : \Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \Page\len = (\Max-\Min)
            Else
              \Page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*Scroll._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *Scroll
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\Line[State] = Color
          Else
            \Color[Item]\Line[State] = Color
          EndIf
          
        Case #PB_Gadget_BackColor
          If Item=- 1
            \Color\Back[State] = Color
          Else
            \Color[Item]\Back[State] = Color
          EndIf
          
        Case #PB_Gadget_FrontColor
        Default ; Case #PB_Gadget_FrameColor
          If Item=- 1
            \Color\Frame[State] = Color
          Else
            \Color[Item]\Frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
   ; ResetColor(*Scroll)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  Procedure.b Resize(*This._S_widget, X.l,Y.l,Width.l,Height.l, *Scroll._S_widget=#Null)
    Protected Result, Lines, ScrollPage
    
    With *This
      ScrollPage = ((\Max-\Min) - \Page\len)
      Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
      
      If *Scroll
        If \Vertical
          If Height=#PB_Ignore : If *Scroll\Hide : Height=(*Scroll\Y+*Scroll\Height)-\Y : Else : Height = *Scroll\Y-\Y+Bool(*Scroll\Radius And *Scroll\Radius)*(*Scroll\button\len/4+1) : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *Scroll\Hide : Width=(*Scroll\X+*Scroll\Width)-\X : Else : Width = *Scroll\X-\X+Bool(*Scroll\Radius And *Scroll\Radius)*(*Scroll\button\len/4+1) : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X : EndIf : If Y=#PB_Ignore : Y = \Y : EndIf 
      If Width=#PB_Ignore : Width = \Width : EndIf : If Height=#PB_Ignore : Height = \Height : EndIf
      
      ;
      If ((\Max-\Min) >= \Page\len)
        If \Vertical
          \Area\Pos = Y+\button\len
          \Area\len = (Height-\button\len*2)
        Else
          \Area\Pos = X+\button\len
          \Area\len = (Width-\button\len*2)
        EndIf
        
        If \Area\len
          \Thumb\len = ThumbLength(*This)
          
          If (\Area\len > \button\len)
            If \button\len
              If (\Thumb\len < \button\len)
                \Area\len = Round(\Area\len - (\button\len-\Thumb\len), #PB_Round_Nearest)
                \Thumb\len = \button\len 
              EndIf
            Else
              If (\Thumb\len < 7)
                \Area\len = Round(\Area\len - (7-\Thumb\len), #PB_Round_Nearest)
                \Thumb\len = 7
              EndIf
            EndIf
          Else
            \Thumb\len = \Area\len 
          EndIf
          
          If \Area\len > 0
            If (\Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\len) >= (\Area\len+\button\len)
              SetState(*This, ScrollPage)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
        EndIf
      EndIf
      
      
      \X = X : \Y = Y : \Width = Width : \Height = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \button[1]\x = X + Lines : \button[1]\y = Y : \button[1]\width = Width - Lines : \button[1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[2]\x = X + Lines : \button[2]\width = Width - Lines : \button[2]\height = \button\len : \button[2]\y = Y+Height-\button[2]\height ; Botom button coordinate on scroll bar
        \button[3]\x = X + Lines : \button[3]\width = Width - Lines : \button[3]\y = \Thumb\Pos : \button[3]\height = \Thumb\len            ; Thumb coordinate on scroll bar
      Else
        \button[1]\x = X : \button[1]\y = Y + Lines : \button[1]\width = \button\len : \button[1]\height = Height - Lines                  ; Left button coordinate on scroll bar
        \button[2]\y = Y + Lines : \button[2]\height = Height - Lines : \button[2]\width = \button\len : \button[2]\x = X+Width-\button[2]\width  ; Right button coordinate on scroll bar
        \button[3]\y = Y + Lines : \button[3]\height = Height - Lines : \button[3]\x = \Thumb\Pos : \button[3]\width = \Thumb\len           ; Thumb coordinate on scroll bar
      EndIf
      
      \Hide[1] = Bool(Not ((\Max-\Min) > \Page\len))
      ProcedureReturn \Hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v), iHeight = Y(\h)
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
      
      If \v\Max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\Max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\Page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\Page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      
      If \v\Hide : \v\Page\Pos = 0 : If vPos : \v\Hide = vPos : EndIf : Else : \v\Page\Pos = vPos : EndIf
      If \h\Hide : \h\Page\Pos = 0 : If hPos : \h\Hide = hPos : EndIf : Else : \h\Page\Pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b _Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *Scroll
      If Width=#PB_Ignore : Width = \v\X+\v\Width : Else : Width+x : EndIf
      If Height=#PB_Ignore : Height = \h\Y+\h\Height : Else : Height+y : EndIf
      
      Protected iWidth = Width-Width(\v), iHeight = Height-Height(\h)
      
      If \v\width And \v\Page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\Page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\Hide = Resize(\v, Width-\v\Width, Y, #PB_Ignore, #PB_Ignore, \h) : iWidth = Width-Width(\v)
      \h\Hide = Resize(\h, X, Height-\h\Height, #PB_Ignore, #PB_Ignore, \v) : iHeight = Height-Height(\h)
      
      If \v\width And \v\Page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\Page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\width : \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) : EndIf
      If \h\height : \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v) : EndIf
      
      ;      If \v\width : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1)) : EndIf
      ;      If \h\height : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore) : EndIf
      
      
      ;       ; Do we see both scrolbars?
      ;       If \v\Hide : \v\Page\Pos = 0 : Else
      ;         If Not \v\hide And \v\width 
      ;           \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      ;         EndIf
      ;       EndIf
      ;       If \h\Hide : \h\Page\Pos = 0 : Else
      ;         If Not \h\hide And \h\height
      ;           \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\v\Radius And \h\Radius)*(\h\button\len/4+1))
      ;         EndIf
      ;       EndIf
      
      ProcedureReturn Bool(\v\Hide|\h\Hide)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*Scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *Scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\Page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\Page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\Page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\Page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Procedure.b CallBack(*This._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0, AutoHide.b=0, *Scroll._S_widget=#Null)
    ; Protected MouseX.i=MouseScreenX, MouseY.i=MouseScreenY, WheelDelta.l=0, AutoHide.b=0, *Scroll._S_widget=#Null;)
    Protected Result, from
    Static LastX, LastY, Last, *Thisis._S_widget, Cursor, Drag, Down
    
    With *This
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
          If \button 
            If (MouseX>\button[3]\x And MouseX=<\button[3]\x+\button[3]\width And MouseY>\button[3]\y And MouseY=<\button[3]\y+\button[3]\height)
              from = 3
            ElseIf (MouseX>\button[2]\x And MouseX=<\button[2]\x+\button[2]\Width And MouseY>\button[2]\y And MouseY=<\button[2]\y+\button[2]\Height)
              from = 2
            ElseIf (MouseX>\button[1]\x And MouseX=<\button[1]\x+\button[1]\Width And  MouseY>\button[1]\y And MouseY=<\button[1]\y+\button[1]\Height)
              from = 1
            ElseIf (MouseX>\button[0]\x And MouseX=<\button[0]\x+\button[0]\Width And MouseY>\button[0]\y And MouseY=<\button[0]\y+\button[0]\Height)
              from = 0
            Else
              from =- 1
            EndIf
          Else
            from =- 1
          EndIf 
        EndIf 
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *Thisis = *This
            Select WheelDelta
              Case-1 : Result = SetState(*This, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*This, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *Thisis = *This : EndIf
          
          Select from
            Case - 1
              If *Thisis = *This
                If \Vertical
                  Result = ScrollPos(*This, (MouseY-\thumb\len/2))
                Else
                  Result = ScrollPos(*This, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 : Result = SetState(*This, (\page\pos - \page\scroll_step))
            Case 2 : Result = SetState(*This, (\page\pos + \page\scroll_step))
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            If *Thisis = *This And Bool(LastX|LastY) 
              If \Vertical
                Result = ScrollPos(*This, (MouseY-LastY))
              Else
                Result = ScrollPos(*This, (MouseX-LastX))
              EndIf
            EndIf
          Else
            If from
              If \from <> from
                If *Thisis > 0 
                  CallBack(*Thisis, #PB_EventType_MouseLeave, MouseX, MouseY) 
                EndIf
                
                If *Thisis <> *This 
                  Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *Thisis = *This
                EndIf
                
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *Thisis = *This
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *Thisis = 0
              ;               Last = 0
            EndIf
          EndIf
          
      EndSelect
      
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \focus = 1 : Result = #True
        Case #PB_EventType_LostFocus : \focus = 0 : Result = #True
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
          If from>0
            \color[from]\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
            
            ;             \color[from]\fore = \color[from]\fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\back = \color[from]\back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\frame = \color[from]\frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\line = \color[from]\line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
          ElseIf Not Drag And Not from 
            ; ResetColor(*This)
            
            \color[0]\state = 0
            \color[1]\state = 0
            \color[2]\state = 0
            \color[3]\state = 0
          EndIf
          
          Result = #True
      EndSelect
      
      ;       If AutoHide =- 1 : *Scroll = 0
      ;         If Not *Thisis : *Thisis =- 1 : EndIf
      ;         AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
      ;       ElseIf AutoHide And *Thisis = *This
      ;         *Thisis =- 1
      ;       EndIf
      ;       
      ;       ; Auto hides
      ;       If (AutoHide And Not Drag And Not from) 
      ;         If \alpha <> \alpha[1] : \alpha = \alpha[1] 
      ;           Result =- 1
      ;         EndIf 
      ;       EndIf
      ;       If EventType = #PB_EventType_MouseEnter And *Thisis =- 1
      ;         If \alpha < 255 : \alpha = 255
      ;           
      ;           If *Scroll
      ;             If \Vertical
      ;               Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
      ;             Else
      ;               Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
      ;             EndIf
      ;           EndIf
      ;           
      ;           Result =- 2
      ;         EndIf 
      ;       EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b _CallBack(*This._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0, AutoHide.b=0, *Scroll._S_widget=#Null)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis._S_widget, Cursor, Drag, Down
    
    With *This
      ;       If \Hide
      ;         If *This = *Thisis
      ;           \from = 0
      ;           \Focus = 0
      ;         EndIf
      ;       EndIf
      
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        Buttons = \from 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
          If (Mousex>\button[1]\x And Mousex=<\button[1]\x+\button[1]\width And  Mousey>\button[1]\y And Mousey=<\button[1]\y+\button[1]\height)
            Buttons = 1
          ElseIf (Mousex>\button[3]\x And Mousex=<\button[3]\x+\button[3]\width And Mousey>\button[3]\y And Mousey=<\button[3]\y+\button[3]\height)
            Buttons = 3
          ElseIf (Mousex>\button[2]\x And Mousex=<\button[2]\x+\button[2]\width And Mousey>\button[2]\y And Mousey=<\button[2]\y+\button[2]\height)
            Buttons = 2
          Else
            Buttons =- 1
          EndIf
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *Thisis = *This
            Select WheelDelta
              Case-1 : Result = SetState(*This, \Page\Pos - (\Max-\Min)/30)
              Case 1 : Result = SetState(*This, \Page\Pos + (\Max-\Min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : Buttons = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If Buttons : \from = Buttons : Drag = 1 : *Thisis = *This : EndIf
          
          Select Buttons
            Case - 1
              If *Thisis = *This Or (\Height>(\button[2]\y+\button[2]\height) And \from =- 1) 
                If \Vertical
                  Result = SetState(*This, Pos(*This, (MouseY-\Thumb\len/2)))
                Else
                  Result = SetState(*This, Pos(*This, (MouseX-\Thumb\len/2)))
                EndIf
              EndIf
            Case 1 : Result = SetState(*This, (\Page\Pos - \Page\scroll_step))
            Case 2 : Result = SetState(*This, (\Page\Pos + \Page\scroll_step))
            Case 3 : LastX = MouseX - \Thumb\Pos : LastY = MouseY - \Thumb\Pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            If Bool(LastX|LastY) 
              If *Thisis = *This
                If \Vertical
                  Result = SetState(*This, Pos(*This, (MouseY-LastY)))
                Else
                  Result = SetState(*This, Pos(*This, (MouseX-LastX)))
                EndIf
              EndIf
            EndIf
          Else
            If Buttons
              If Last <> Buttons
                If *Thisis>0 : CallBack(*Thisis, #PB_EventType_MouseLeave, MouseX, MouseY, WheelDelta) : EndIf
                EventType = #PB_EventType_MouseEnter
                Last = Buttons
              EndIf
              
              If *Thisis <> *This 
                ; Debug "Мышь находится внутри"
                Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                *Thisis = *This
              EndIf
              
              \from = Buttons
            ElseIf *Thisis = *This
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                ; Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *Thisis = 0
              Last = 0
            EndIf
          EndIf
          
      EndSelect
      
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \Focus = #True : Result = #True
        Case #PB_EventType_LostFocus : \Focus = #False : Result = #True
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
          If Buttons>0
            \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            \Color[Buttons]\Line = \Color[Buttons]\Line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
          ElseIf Not Drag And Not Buttons 
          ;  ResetColor(*This)
          EndIf
          
          Result = #True
          
      EndSelect
      
      If AutoHide =- 1 : *Scroll = 0
        If Not *Thisis : *Thisis =- 1 : EndIf
        AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
      ElseIf AutoHide And *Thisis = *This
        *Thisis =- 1
      EndIf
      
      ; Auto hides
      If (AutoHide And Not Drag And Not Buttons) 
        If \Alpha <> \Alpha[1] : \Alpha = \Alpha[1] 
          Result =- 1
        EndIf 
      EndIf
      If EventType = #PB_EventType_MouseEnter And *Thisis =- 1
        If \Alpha < 255 : \Alpha = 255
          
          If *Scroll
            If \Vertical
              Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
            Else
              Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
            EndIf
          EndIf
          
          Result =- 2
        EndIf 
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *Scroll._S_widget = AllocateStructure(_S_widget)
    
    With *Scroll
      \Alpha = 255
      \Alpha[1] = 0
      \Radius = Radius
      
      ; Цвет фона скролла
;       \color[0]\alpha = 255
;       \color\alpha[1] = 0
      \color\state = 0
      \color\fore = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      
      \color[1] = Color_Default
      \color[2] = Color_Default
      \color[3] = Color_Default
      
;       \color[1]\alpha = 255
;       \color[2]\alpha = 255
;       \color[3]\alpha = 255
;       \color[1]\alpha[1] = 128
;       \color[2]\alpha[1] = 128
;       \color[3]\alpha[1] = 128
      
      
      \Type = #PB_GadgetType_ScrollBar
      \Vertical = Bool(Flag&#PB_ScrollBar_Vertical)
      
      If \Vertical
        If width < 21
          \button\len = width - 1
        Else
          \button\len = 17
        EndIf
      Else
        If height < 21
          \button\len = height - 1
        Else
          \button\len = 17
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*Scroll, #PB_ScrollBar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*Scroll, #PB_ScrollBar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*Scroll, #PB_ScrollBar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*Scroll, X,Y,Width,Height)
    
    ProcedureReturn *Scroll
  EndProcedure
  
EndModule

;- EXAMPLE
; IncludePath "C:\Users\as\Documents\GitHub\"
; XIncludeFile "module_scroll.pbi"

EnableExplicit
UseModule Scroll

Structure canvasitem
  img.i
  x.i
  y.i
  width.i
  height.i
  alphatest.i
EndStructure

Enumeration
  #MyCanvas = 1   ; just to test whether a number different from 0 works now
EndEnumeration

Global *Scroll._S_scroll=AllocateStructure(_S_scroll)

Global isCurrentItem=#False
Global currentItemXOffset.i, currentItemYOffset.i
Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
Global NewList Images.canvasitem()

Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
  If AddElement(Images())
    Images()\img    = img
    Images()\x      = x
    Images()\y      = y
    Images()\width  = ImageWidth(img)
    Images()\height = ImageHeight(img)
    Images()\alphatest = alphatest
  EndIf
EndProcedure

Procedure _Draw (canvas.i)
  Protected iWidth = X(*Scroll\v), iHeight = Y(*Scroll\h)
  
  If StartDrawing(CanvasOutput(canvas))
    
    ClipOutput(0,0, iWidth, iHeight)
    
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img),Images()\x - *Scroll\h\Page\Pos,Images()\y - *Scroll\v\Page\Pos) ; draw all images with z-order
    Next
    
    UnclipOutput()
    
    If Not *Scroll\v\hide
      Draw(*Scroll\v)
    EndIf
    If Not *Scroll\h\hide
      Draw(*Scroll\h)
    EndIf
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - *Scroll\h\Page\Pos And x < Images()\x - *Scroll\h\Page\Pos + Images()\width
        If y >= Images()\y - *Scroll\v\Page\Pos And y < Images()\y - *Scroll\v\Page\Pos + Images()\height
          alpha = 255
          
          If Images()\alphatest And ImageDepth(Images()\img)>31
            If StartDrawing(ImageOutput(Images()\img))
              DrawingMode(#PB_2DDrawing_AlphaChannel)
              alpha = Alpha(Point(x-Images()\x, y-Images()\y)) ; get alpha
              StopDrawing()
            EndIf
          EndIf
          
          If alpha
            MoveElement(Images(), #PB_List_Last)
            isCurrentItem = #True
            currentItemXOffset = x - Images()\x
            currentItemYOffset = y - Images()\y
            Break
          EndIf
        EndIf
      EndIf
    Until PreviousElement(Images()) = 0
  EndIf
  
  ProcedureReturn isCurrentItem
EndProcedure

AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
AddImage(Images(),  50,200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,100,100,RGBA($00,$00,$00,$00))
  Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),170,70,hole,1)


Macro GetScrollCoordinate()
  ScrollX = Images()\x
  ScrollY = Images()\Y
  ScrollWidth = Images()\x+Images()\width
  ScrollHeight = Images()\Y+Images()\height
  
  PushListPosition(Images())
  ForEach Images()
    If ScrollX > Images()\x : ScrollX = Images()\x : EndIf
    If ScrollY > Images()\Y : ScrollY = Images()\Y : EndIf
    If ScrollWidth < Images()\x+Images()\width : ScrollWidth = Images()\x+Images()\width : EndIf
    If ScrollHeight < Images()\Y+Images()\height : ScrollHeight = Images()\Y+Images()\height : EndIf
  Next
  PopListPosition(Images())
EndMacro

Procedure ScrollUpdates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
  
  If *Scroll\v\Max<>ScrollArea_Height : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
  If *Scroll\h\Max<>ScrollArea_Width : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
  
  If *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  If *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollArea_Y<0 : SetState(*Scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
  If ScrollArea_X<0 : SetState(*Scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
  
  *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
  *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
  
  ;   If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = iWidth+*Scroll\v\Width : EndIf
  ;   If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = iHeight+*Scroll\h\Height : EndIf
  
  If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : If vPos : *Scroll\v\Hide = vPos : EndIf : Else : *Scroll\v\Page\Pos = vPos : EndIf
  If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : If hPos : *Scroll\h\Hide = hPos : EndIf : Else : *Scroll\h\Page\Pos = hPos : EndIf
  
  ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
EndProcedure

Procedure _CallBack()
  Protected Repaint
  Protected Event = EventType()
  Protected Canvas = EventGadget()
  Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
  Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
  Protected Width = GadgetWidth(Canvas)
  Protected Height = GadgetHeight(Canvas)
  Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
  
  If CallBack(*Scroll\v, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  If CallBack(*Scroll\h, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  
  Select Event
    Case #PB_EventType_LeftButtonUp
      GetScrollCoordinate()
      
      If (ScrollX<0 Or ScrollY<0)
        PushListPosition(Images())
        ForEach Images()
          If ScrollX<0
            *Scroll\h\Page\Pos =- ScrollX
            Images()\X-ScrollX
          EndIf
          If ScrollY<0
            *Scroll\v\Page\Pos =- ScrollY
            Images()\Y-ScrollY
          EndIf
        Next
        PopListPosition(Images())
      EndIf
      
  EndSelect     
  
  
  If (*Scroll\h\from Or *Scroll\v\from)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        GetScrollCoordinate()
        ScrollUpdates(*Scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        ;           Protected iWidth = Width-Width(*Scroll\v), iHeight = Height-Height(*Scroll\h)
        ;   
        ;         Debug ""+*Scroll\h\Hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
        ;         Debug ""+*Scroll\v\Hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
        
        PushListPosition(Images())
        ForEach Images()
          ;           If *Scroll\h\Hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
          ;           If *Scroll\v\Hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
          If *Scroll\h\Hide>1 : Images()\X-*Scroll\h\Hide : EndIf
          If *Scroll\v\Hide>1 : Images()\Y-*Scroll\v\Hide : EndIf
        Next
        PopListPosition(Images())
        
        
    EndSelect
  Else
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
              
              GetScrollCoordinate()
              Repaint = Updates(*Scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *Scroll\h\Max<>ScrollWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
        If *Scroll\v\Max<>ScrollHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
        
        Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint 
    _Draw(#MyCanvas) 
  EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
EndProcedure


If Not OpenWindow(0, 0, 0, 420, 420, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
CanvasGadget(#MyCanvas, 10, 10, 400, 400)

*Scroll\v = Gadget(380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical, 9)
*Scroll\h = Gadget(0, 380, 380,  20, 0, 0, 0, 0, 9)

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @_CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----------------------------------------
; EnableXP