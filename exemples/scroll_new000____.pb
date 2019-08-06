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

;- >>> DECLAREMODULE
DeclareModule Scroll
  EnableExplicit
  
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Smooth 
    #PB_Bar_Ticks 
  EndEnumeration
  
  ;- STRUCTUREs
  ;- - _S_color
  Structure _S_color
    state.b
    alpha.a[2]
    front.l[4]
    fore.l[4]
    back.l[4]
    frame.l[4]
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    pos.l
    len.l
    *step
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
    
    max.l
    min.l
    
    type.l
    from.l
    focus.l
    radius.l
    
    hide.b[2]
    ; disable.b[2]
    vertical.b
    inverted.b
    direction.i
    
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
  ;- DECLAREs
  Declare.b Draw(*scroll._S_widget)
  Declare.l Y(*scroll._S_widget)
  Declare.l X(*scroll._S_widget)
  Declare.l Width(*scroll._S_widget)
  Declare.l Height(*scroll._S_widget)
  
  Declare.i GetState(*scroll._S_widget)
  Declare.i GetAttribute(*scroll._S_widget, Attribute.i)
  
  Declare.b SetState(*scroll._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*scroll._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*scroll._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this._S_widget, iX.l,iY.l,iWidth.l,iHeight.l, *scroll._S_widget=#Null)
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  Declare.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
EndDeclareModule

;- >>> MODULE
Module Scroll
  ;- GLOBALs
  Global Color_Default._S_color
  
  With Color_Default                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[0] = $FFE2E2E2 ; $80E2E2E2
    \frame[0] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFEAEAEA ; $FFFAF8F8
    \back[1] = $FFCECECE ; $80FCEADA
    \frame[1] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
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
  
  Macro _scroll_in_start_(_this_) : Bool(_this_\page\pos =< _this_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\page\pos >= (_this_\max-_this_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ;-
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
      _this_\button[3]\y = _this_\Thumb\pos
    Else
      _this_\button[3]\x = _this_\Thumb\pos
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
        If \page\step > 1
          ScrollPos = Round(ScrollPos / \page\step, #PB_Round_Nearest) * \page\step
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
  
  ;-
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
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If (Value>Max) : Value=Max : EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  ;-
  Procedure.b Draw(*scroll._S_widget)
    With *scroll
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\Width,\height,\Radius,\Radius,\Color[0]\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \Thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[1]\x,\button[1]\y,\button[1]\width,\button[1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          BoxGradient(\Vertical,\button[2]\x,\button[2]\y,\button[2]\width,\button[2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[1]\x,\button[1]\y,\button[1]\width,\button[1]\height,\Radius,\Radius,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[2]\x,\button[2]\y,\button[2]\width,\button[2]\height,\Radius,\Radius,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[1]\x+(\button[1]\width-6)/2,\button[1]\y+(\button[1]\height-3)/2, 3, Bool(\Vertical), \Color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          Arrow(\button[2]\x+(\button[2]\width-6)/2,\button[2]\y+(\button[2]\height-3)/2, 3, Bool(\Vertical)+2, \Color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw thumb lines
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2-3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[3]\x+(\button[3]\width-8)/2,\button[3]\y+\button[3]\height/2+3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        Else
          Line(\button[3]\x+\button[3]\width/2-3,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[3]\x+\button[3]\width/2,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[3]\x+\button[3]\width/2+3,\button[3]\y+(\button[3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.l X(*scroll._S_widget)
    Protected Result.l
    
    If *scroll
      With *scroll
        If Not \hide[1] And \color\alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Y(*scroll._S_widget)
    Protected Result.l
    
    If *scroll
      With *scroll
        If Not \hide[1] And \color\alpha
          Result = \Y
        Else
          Result = \Y+\height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Width(*scroll._S_widget)
    Protected Result.l
    
    If *scroll
      With *scroll
        If Not \hide[1] And \Width And \color\alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Height(*scroll._S_widget)
    Protected Result.l
    
    If *scroll
      With *scroll
        If Not \hide[1] And \height And \color\alpha
          Result = \height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*scroll._S_widget)
    Protected Result.i
    
    With *scroll
      Result = \page\pos ; Invert(*this, \page\pos, \inverted)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*scroll._S_widget, Attribute.i)
    Protected Result.i
    
    With *scroll
      Select Attribute
        Case #PB_Bar_Minimum : Result = \min  ; 1
        Case #PB_Bar_Maximum : Result = \max  ; 2
        Case #PB_Bar_Inverted : Result = \inverted
        Case #PB_Bar_NoButtons : Result = \button\len ; 4
        Case #PB_Bar_Direction : Result = \direction
        Case #PB_Bar_PageLength : Result = \page\len ; 3
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.b SetState(*scroll._S_widget, ScrollPos.l)
    Protected Result.b
    
    With *scroll
      ScrollPos = PagePos(*scroll, Invert(*scroll, ScrollPos, \inverted))
      
      If \page\pos<>ScrollPos : \page\pos=ScrollPos
        \Thumb\pos = ThumbPos(*scroll, Invert(*scroll, ScrollPos, \inverted))
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*scroll._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *scroll
      Select Attribute
        Case #PB_Bar_NoButtons ;: Resize = 1
          \button\len = Value
          \button[1]\len = Value
          \button[2]\len = Value
          
          ;\Resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;\Resize = 0
          
        Case #PB_Bar_Inverted
          \inverted = Bool(Value)
          \thumb\pos = ThumbPos(*scroll, Invert(*scroll, \page\pos, \inverted))
          
        Case #PB_Bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            \page\step = (\max-\min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_Bar_PageLength
          If \page\len <> Value
            If Value > (\max-\min) : \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*scroll._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *scroll
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\front[State] = Color
          Else
            \Color[Item]\front[State] = Color
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
            \Color\frame[State] = Color
          Else
            \Color[Item]\frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ; ResetColor(*scroll)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  ;-
  Procedure.b Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l, *scroll._S_widget=#Null)
    Protected Result, Lines, ScrollPage
    
    With *this
      ScrollPage = ((\max-\min) - \page\len)
      Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
      
      If *scroll
        If \Vertical
          If Height=#PB_Ignore : If *scroll\hide : Height=(*scroll\Y+*scroll\height)-\Y : Else : Height = *scroll\Y-\Y+Bool(*scroll\Radius And *scroll\Radius)*(*scroll\button\len/4+1) : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *scroll\hide : Width=(*scroll\X+*scroll\Width)-\X : Else : Width = *scroll\X-\X+Bool(*scroll\Radius And *scroll\Radius)*(*scroll\button\len/4+1) : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X : EndIf : If Y=#PB_Ignore : Y = \Y : EndIf 
      If Width=#PB_Ignore : Width = \Width : EndIf : If Height=#PB_Ignore : Height = \height : EndIf
      
      ;
      If ((\max-\min) >= \page\len)
        If \Vertical
          \Area\pos = Y+\button\len
          \Area\len = (Height-\button\len*2)
        Else
          \Area\pos = X+\button\len
          \Area\len = (Width-\button\len*2)
        EndIf
        
        If \Area\len
          \Thumb\len = ThumbLength(*this)
          
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
            If (\Type <> #PB_GadgetType_TrackBar) And (\Thumb\pos+\Thumb\len) >= (\Area\len+\button\len)
              SetState(*this, ScrollPage)
            EndIf
            
            \Thumb\pos = ThumbPos(*this, Invert(*this, \page\pos, \inverted))
          EndIf
        EndIf
      EndIf
      
      
      \X = X : \Y = Y : \Width = Width : \height = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \button[1]\x = X + Lines : \button[1]\y = Y : \button[1]\width = Width - Lines : \button[1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[2]\x = X + Lines : \button[2]\width = Width - Lines : \button[2]\height = \button\len : \button[2]\y = Y+Height-\button[2]\height ; Botom button coordinate on scroll bar
        \button[3]\x = X + Lines : \button[3]\width = Width - Lines : \button[3]\y = \Thumb\pos : \button[3]\height = \Thumb\len                  ; Thumb coordinate on scroll bar
      Else
        \button[1]\x = X : \button[1]\y = Y + Lines : \button[1]\width = \button\len : \button[1]\height = Height - Lines                  ; Left button coordinate on scroll bar
        \button[2]\y = Y + Lines : \button[2]\height = Height - Lines : \button[2]\width = \button\len : \button[2]\x = X+Width-\button[2]\width  ; Right button coordinate on scroll bar
        \button[3]\y = Y + Lines : \button[3]\height = Height - Lines : \button[3]\x = \Thumb\pos : \button[3]\width = \Thumb\len                 ; Thumb coordinate on scroll bar
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *scroll
      Protected iWidth = X(\v), iHeight = Y(\h)
      Static hPos, vPos : vPos = \v\page\pos : hPos = \h\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\page\pos+iWidth 
        ScrollArea_Width=\h\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\page\pos And
             ScrollArea_Width=\h\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\page\pos+iHeight
        ScrollArea_Height=\v\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\page\pos And
             ScrollArea_Height=\v\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
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
  Procedure.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static LastX, LastY, Last, *thisis._S_widget, Cursor, Drag, Down
    
    With *this
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If (MouseX>\button[3]\x And MouseX=<\button[3]\x+\button[3]\width And MouseY>\button[3]\y And MouseY=<\button[3]\y+\button[3]\height)
              from = 3
            ElseIf (MouseX>\button[2]\x And MouseX=<\button[2]\x+\button[2]\Width And MouseY>\button[2]\y And MouseY=<\button[2]\y+\button[2]\height)
              from = 2
            ElseIf (MouseX>\button[1]\x And MouseX=<\button[1]\x+\button[1]\Width And  MouseY>\button[1]\y And MouseY=<\button[1]\y+\button[1]\height)
              from = 1
            ElseIf (MouseX>\button[0]\x And MouseX=<\button[0]\x+\button[0]\Width And MouseY>\button[0]\y And MouseY=<\button[0]\y+\button[0]\height)
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
          If *thisis = *this
            Select WheelDelta
              Case-1 : Result = SetState(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*this, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *thisis = *this : EndIf
          
          Select from
            Case - 1
              If *thisis = *this
                If \Vertical
                  Result = ScrollPos(*this, (MouseY-\thumb\len/2))
                Else
                  Result = ScrollPos(*this, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 : Result = SetState(*this, (\page\pos - \page\step))
            Case 2 : Result = SetState(*this, (\page\pos + \page\step))
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            If *thisis = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = ScrollPos(*this, (MouseY-LastY))
              Else
                Result = ScrollPos(*this, (MouseX-LastX))
              EndIf
            EndIf
          Else
            If from
              If \from <> from
                If *thisis > 0 
                  CallBack(*thisis, #PB_EventType_MouseLeave, MouseX, MouseY) 
                EndIf
                
                If *thisis <> *this 
                  Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *thisis = *this
                EndIf
                
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *thisis = *this
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *thisis = 0
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
          ElseIf Not Drag And Not from 
            \color[0]\state = 0
            \color[1]\state = 0
            \color[2]\state = 0
            \color[3]\state = 0
          EndIf
          
          Result = #True
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *scroll._S_widget = AllocateStructure(_S_widget)
    
    With *scroll
      \Radius = Radius
      
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
      
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
      
      \color[1] = Color_Default
      \color[2] = Color_Default
      \color[3] = Color_Default
      
      \Type = #PB_GadgetType_ScrollBar
      \Vertical = Bool(Flag&#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
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
      
      If \min <> Min : SetAttribute(*scroll, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*scroll, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*scroll, #PB_Bar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*scroll, X,Y,Width,Height)
    
    ProcedureReturn *scroll
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
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

Global *scroll._S_scroll=AllocateStructure(_S_scroll)

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
  Protected iWidth = X(*scroll\v), iHeight = Y(*scroll\h)
  
  If StartDrawing(CanvasOutput(canvas))
    
    ClipOutput(0,0, iWidth, iHeight)
    
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img),Images()\x - *scroll\h\page\pos,Images()\y - *scroll\v\page\pos) ; draw all images with z-order
    Next
    
    UnclipOutput()
    
    If Not *scroll\v\hide
      Draw(*scroll\v)
    EndIf
    If Not *scroll\h\hide
      Draw(*scroll\h)
    EndIf
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - *scroll\h\page\pos And x < Images()\x - *scroll\h\page\pos + Images()\width
        If y >= Images()\y - *scroll\v\page\pos And y < Images()\y - *scroll\v\page\pos + Images()\height
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
AddImage(Images(),  250,350, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

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

Procedure ScrollUpdates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Protected iWidth = X(*scroll\v), iHeight = Y(*scroll\h)
  Static hPos, vPos : vPos = *scroll\v\page\pos : hPos = *scroll\h\page\pos
  
  ; Вправо работает как надо
  If ScrollArea_Width<*scroll\h\page\pos+iWidth 
    ScrollArea_Width=*scroll\h\page\pos+iWidth
    ; Влево работает как надо
  ElseIf ScrollArea_X>*scroll\h\page\pos And
         ScrollArea_Width=*scroll\h\page\pos+iWidth 
    ScrollArea_Width = iWidth 
  EndIf
  
  ; Вниз работает как надо
  If ScrollArea_Height<*scroll\v\page\pos+iHeight
    ScrollArea_Height=*scroll\v\page\pos+iHeight 
    ; Верх работает как надо
  ElseIf ScrollArea_Y>*scroll\v\page\pos And
         ScrollArea_Height=*scroll\v\page\pos+iHeight 
    ScrollArea_Height = iHeight 
  EndIf
  
  If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
  If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
  
  If ScrollArea_X<*scroll\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
  If ScrollArea_Y<*scroll\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
  
  If *scroll\v\max<>ScrollArea_Height : SetAttribute(*scroll\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
  If *scroll\h\max<>ScrollArea_Width : SetAttribute(*scroll\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
  
  If *scroll\v\page\len<>iHeight : SetAttribute(*scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  If *scroll\h\page\len<>iWidth : SetAttribute(*scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollArea_Y<0 : SetState(*scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
  If ScrollArea_X<0 : SetState(*scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
  
  *scroll\v\hide = Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\h) 
  *scroll\h\hide = Resize(*scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v)
  
  ;   If *scroll\v\hide : *scroll\v\page\pos = 0 : Else : *scroll\v\page\pos = vPos : *scroll\h\Width = iWidth+*scroll\v\Width : EndIf
  ;   If *scroll\h\hide : *scroll\h\page\pos = 0 : Else : *scroll\h\page\pos = hPos : *scroll\v\height = iHeight+*scroll\h\height : EndIf
  
  If *scroll\v\hide : *scroll\v\page\pos = 0 : If vPos : *scroll\v\hide = vPos : EndIf : Else : *scroll\v\page\pos = vPos : EndIf
  If *scroll\h\hide : *scroll\h\page\pos = 0 : If hPos : *scroll\h\hide = hPos : EndIf : Else : *scroll\h\page\pos = hPos : EndIf
  
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
  
  If CallBack(*scroll\v, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  If CallBack(*scroll\h, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  
  Select Event
    Case #PB_EventType_LeftButtonUp
      GetScrollCoordinate()
      
      If (ScrollX<0 Or ScrollY<0)
        PushListPosition(Images())
        ForEach Images()
          If ScrollX<0
            *scroll\h\page\pos =- ScrollX
            Images()\X-ScrollX
          EndIf
          If ScrollY<0
            *scroll\v\page\pos =- ScrollY
            Images()\Y-ScrollY
          EndIf
        Next
        PopListPosition(Images())
      EndIf
      
  EndSelect     
  
  
  If (*scroll\h\from Or *scroll\v\from)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        GetScrollCoordinate()
        ScrollUpdates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        ;           Protected iWidth = Width-Width(*scroll\v), iHeight = Height-Height(*scroll\h)
        ;   
        ;         Debug ""+*scroll\h\hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
        ;         Debug ""+*scroll\v\hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
        
        PushListPosition(Images())
        ForEach Images()
          ;           If *scroll\h\hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
          ;           If *scroll\v\hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
          If *scroll\h\hide>1 : Images()\X-*scroll\h\hide : EndIf
          If *scroll\v\hide>1 : Images()\Y-*scroll\v\hide : EndIf
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
              Repaint = Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *scroll\h\max<>ScrollWidth : SetAttribute(*scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
        If *scroll\v\max<>ScrollHeight : SetAttribute(*scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
        
        Resizes(*scroll, 0, 0, Width, Height)
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


If Not OpenWindow(0, 0, 0, 420, 420+100, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
CheckBoxGadget(3, 10, 30, 80,20, "invert")
CheckBoxGadget(4, 10, 50, 80,20, "noButtons")

CanvasGadget(#MyCanvas, 10, 110, 400, 400)

*Scroll\v = Gadget(380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical|#PB_Bar_Inverted, 9)
*Scroll\h = Gadget(0, 380, 380,  20, 0, 0, 0, 0, 9)

If GetGadgetState(2)
  SetGadgetState(3, GetAttribute(*Scroll\v, #PB_Bar_Inverted))
Else
  SetGadgetState(3, GetAttribute(*Scroll\h, #PB_Bar_Inverted))
EndIf

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @_CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 2
          If GetGadgetState(2)
            SetGadgetState(3, GetAttribute(*Scroll\v, #PB_Bar_Inverted))
          Else
            SetGadgetState(3, GetAttribute(*Scroll\h, #PB_Bar_Inverted))
          EndIf
          
        Case 3
          If GetGadgetState(2)
            SetAttribute(*Scroll\v, #PB_Bar_Inverted, Bool(GetGadgetState(3))) ; *Scroll\v\box\size = 0
            SetWindowTitle(0, Str(GetState(*Scroll\v)) +" "+ Str(*Scroll\v\page\pos))
          Else
            SetAttribute(*Scroll\h, #PB_Bar_Inverted, Bool(GetGadgetState(3))) ; *Scroll\v\box\size = 0
            SetWindowTitle(0, Str(GetState(*Scroll\h)) +" "+ Str(*Scroll\v\page\pos))
          EndIf
          _Draw(#MyCanvas) 
          
        Case 4
          If GetGadgetState(2)
            SetAttribute(*Scroll\v, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * 20) ; *Scroll\v\box\size = 0
            SetWindowTitle(0, Str(GetState(*Scroll\v)))
          Else
            SetAttribute(*Scroll\h, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * 20) ; *Scroll\v\box\size = 0
            SetWindowTitle(0, Str(GetState(*Scroll\h)))
          EndIf
          _Draw(#MyCanvas) 
      EndSelect
  EndSelect
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----------------------------------
; EnableXP