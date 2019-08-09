;- >>> DECLAREMODULE
DeclareModule Bar
  EnableExplicit
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_1 = 1
  #_2 = 2
  #_3 = 3
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ; Debug #PB_ScrollArea_ScrollStep = 5 ; mac os
  ; Debug #PB_Bar_ScrollStep
  
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
    change.l
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _S_button
  Structure _S_button
    x.l
    y.l
    width.l
    height.l
    len.l
  EndStructure
  
  ;- - _S_bar
  Structure _S_bar
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
    direction.l
    scrollstep.l
    ticks.b
    
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
    
    *v._S_bar
    *h._S_bar
  EndStructure
  
  ;-
  ;- DECLAREs
  Declare.b Draw(*this._S_bar)
  Declare.l Y(*this._S_bar)
  Declare.l X(*this._S_bar)
  Declare.l Width(*this._S_bar)
  Declare.l Height(*this._S_bar)
  Declare.b Hide(*this._S_bar, State.b=#PB_Default)
  
  Declare.i GetState(*this._S_bar)
  Declare.i GetAttribute(*this._S_bar, Attribute.i)
  
  Declare.b SetState(*this._S_bar, ScrollPos.l)
  Declare.l SetAttribute(*this._S_bar, Attribute.l, Value.l)
  Declare.b SetColor(*this._S_bar, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this._S_bar, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this._S_bar, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l, Radius.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l, Radius.l=0)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l, Radius.l=0)
  
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
  Declare   Arrow(X,Y, Size, Direction, Color, Thickness = 1)
  
  ; Extract thumb len from (max area page) len
  Macro _thumb_len_(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\Vertical
      _this_\button[#_3]\height = _this_\thumb\len
    Else
      _this_\button[#_3]\width = _this_\thumb\len
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    ; _start_
    If _this_\button[#_1]\len
      If _this_\thumb\pos = _this_\area\pos
        _this_\color[#_1]\state = #Disabled
      Else
        _this_\color[#_1]\state = #Normal
      EndIf 
    EndIf
    
    ; _stop_
    If _this_\button[#_2]\len
      If _this_\thumb\pos = _this_\area\end
        _this_\color[#_2]\state = #Disabled
      Else
        _this_\color[#_2]\state = #Normal
      EndIf 
    EndIf
  
    If Not _this_\button[#_1]\len
      _this_\button[#_1]\x = _this_\X
      _this_\button[#_1]\y = _this_\Y
      
      If _this_\Vertical
        _this_\button[#_1]\width = _this_\width
        _this_\button[#_1]\height = _this_\thumb\pos-_this_\y
      Else
        _this_\button[#_1]\width = _this_\thumb\pos-_this_\x
        _this_\button[#_1]\height = _this_\height
      EndIf
    EndIf
    
    If Not _this_\button[#_2]\len
      If _this_\Vertical
        _this_\button[#_2]\x = _this_\x
        _this_\button[#_2]\y = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_2]\width = _this_\Width
        _this_\button[#_2]\height = _this_\height-(_this_\thumb\pos+_this_\thumb\len-_this_\y)
      Else
        _this_\button[#_2]\x = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_2]\y = _this_\Y
        _this_\button[#_2]\width = _this_\Width-(_this_\thumb\pos+_this_\thumb\len-_this_\x)
        _this_\button[#_2]\height = _this_\height
      EndIf
    EndIf
    
    _this_\button[#_3]\len = _this_\thumb\len
    
    If _this_\vertical
      _this_\button[#_3]\y = _this_\thumb\pos
      _this_\button[#_3]\height = _this_\thumb\len
    Else
      _this_\button[#_3]\x = _this_\thumb\pos
      _this_\button[#_3]\width = _this_\thumb\len
    EndIf
    
    _this_\page\end = (_this_\min + Round((_this_\area\end - _this_\area\pos) / (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
  EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ; Draw gradient box
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  
  
EndDeclareModule

;- >>> MODULE
Module Bar
  ;- GLOBALs
  Global Color_Default._S_color
  
  With Color_Default                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#Normal] = $FFE2E2E2 ; $80E2E2E2
    \frame[#Normal] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFEAEAEA ; $FFFAF8F8
    \back[#Entered] = $FFCECECE ; $80FCEADA
    \frame[#Entered] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#Selected] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#Selected] = $FF6F6F6F ; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    ; ;     ; - Синие цвета
    ; ;     ; Цвета по умолчанию
    ; ;     \front[#Normal] = $80000000
    ; ;     \fore[#Normal] = $FFF6F6F6 ; $FFF8F8F8 
    ; ;     \back[#Normal] = $FFE2E2E2 ; $80E2E2E2
    ; ;     \frame[#Normal] = $FFBABABA; $80C8C8C8
    ; ;     
    ; ;     ; Цвета если мышь на виджете
    ; ;     \front[#Entered] = $80000000
    ; ;     \fore[#Entered] = $FFFAF8F8  ; $FFEAEAEA ; 
    ; ;     \back[#Entered] = $80FCEADA  ; $FFCECECE ; 
    ; ;     \frame[#Entered] = $80FFC288 ; $FF8F8F8F; 
    ; ;     
    ; ;     ; Цвета если нажали на виджет
    ; ;     \front[#Selected] = $FFFEFEFE
    ; ;     \fore[#Selected] = $C8E9BA81 ; $FFE2E2E2 ; $C8FFFCFA
    ; ;     \back[#Selected] = $C8E89C3D ; $FFB4B4B4 ; $80E89C3D
    ; ;     \frame[#Selected] = $C8DC9338 ; $FF6F6F6F; $80DC9338
    ; ;     
    ; ;     ; Цвета если дисабле виджет
    ; ;     \front[#Disabled] = $FFBABABA
    ; ;     \fore[#Disabled] = $FFF6F6F6 
    ; ;     \back[#Disabled] = $FFE2E2E2 
    ; ;     \frame[#Disabled] = $FFBABABA
  EndWith
  
  Procedure.i PagePos(*this._S_bar, State.i)
    With *this
      If State < \min : State = \min : EndIf
      
      If \max And State > \max-\page\len
        If \max > \page\len 
          State = \max-\page\len
        Else
          State = \min 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn State
  EndProcedure
  
  Procedure.i ScrollPos(*this._S_bar, ThumbPos.i)
    Static ScrollPos.i
    Protected Result.i
    
    With *this
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If ScrollPos <> ThumbPos 
        ; from thumb_pos get scroll_pos 
        ; Gadget(5, 10, 370, 30, 20, 50, 8, #PB_Bar_Inverted) ; #PB_Round_Down с ним не работает
        ThumbPos =   (\min + Round(((ThumbPos) - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)) 
        
        If #PB_GadgetType_TrackBar = \type And \vertical
          ThumbPos = _scroll_invert_(*this, ThumbPos, \inverted)
        EndIf
        
        Result = SetState(*this, ThumbPos)
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
  
  Procedure.b Draw_Progress(*this._S_bar)
    With *this 
      If \Vertical
        ; Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\width,\thumb\pos-\y,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        Line(\X,\Y,1,\thumb\pos-\y,\Color[#_1]\frame[\color[#_1]\state])
        Line(\X,\Y,\width,1,\Color[#_1]\frame[\color[#_1]\state])
        Line(\X+\width-1,\Y,1,\thumb\pos-\y,\Color[#_1]\frame[\color[#_1]\state])
        
        
        ; Back 
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical,\x, \thumb\pos+\thumb\len,\width,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        Line(\x,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\frame[\color[#_2]\state])
        Line(\x,\Y+\height,\width,1,\Color[#_2]\frame[\color[#_2]\state])
        Line(\x+\width-1,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\frame[\color[#_2]\state])
        
      Else
        ; Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\thumb\pos-\x,\height,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        Line(\X,\Y,\thumb\pos-\x,1,\Color[#_1]\frame[\color[#_1]\state])
        Line(\X,\Y,1,\height,\Color[#_1]\frame[\color[#_1]\state])
        Line(\X,\Y+\height-1,\thumb\pos-\x,1,\Color[#_1]\frame[\color[#_1]\state])
        
        ; Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),\height,\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        Line(\thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_2]\frame[\color[#_2]\state])
        Line(\x+\width,\Y,1,\height,\Color[#_2]\frame[\color[#_2]\state])
        Line(\thumb\pos+\thumb\len,\Y+\height-1,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_2]\frame[\color[#_2]\state])
      EndIf
      
      ; Text
      If \ticks
        If \vertical
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawRotatedText(\x+(\width-TextHeight("A")-2)/2, \y+(\height+TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 90, \Color[3]\frame)
          ;DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, \Color[3]\frame)
        Else
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),\Color[3]\frame)
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._S_bar)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, f2Color, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *this
      Protected Alpha = \color\alpha<<24
      
      If *this > 0
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
        
        DrawingMode(#PB_2DDrawing_Outlined)
      Box(\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Color[3]\frame[\color[1]\state])
      Box(\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Color[3]\frame[\color[2]\state])
 
;         ;         If Border And (Pos > 0 And pos < \Area\len)
;         fColor = \Color[3]\Frame[2]&$FFFFFF|Alpha;\Color[3]\Frame[0]
;         f2Color = \Color[3]\Frame&$FFFFFF|Alpha  ;\Color[3]\Frame[0]
;         
;         DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
;         If \Vertical
;           ;             If \Type[1]<>#PB_GadgetType_Splitter
;           Box(X,Y,Width,Pos,fColor) 
;           ;             EndIf
;           ;             If \Type[2]<>#PB_GadgetType_Splitter
;           Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),f2Color)
;           ;             EndIf
;         Else
;           ;             If \Type[1]<>#PB_GadgetType_Splitter
;           Box(X,Y,Pos,Height,fColor) 
;           ;             EndIf 
;           ;             If \Type[2]<>#PB_GadgetType_Splitter
;           Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,f2Color)
;           ;             EndIf
;         EndIf
;         ;         EndIf
        
        If Circle
          Color = $FF000000;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          Else
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            ;box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,\Color\Frame&$FFFFFF|Alpha)
          Else
            ;box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\Color\Frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \Vertical
        ; ;           ;box(\box\x[3], \box\y[3]+\box\Height[3]-\Thumb\len, \box\Width[3], \Thumb\len, $FF0000)
        ; ;           box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;box(\box\x[3]+\box\Width[3]-\Thumb\len, \box\y[3], \Thumb\len, \box\Height[3], $FF0000)
        ; ;           box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw_Track(*this._S_bar)
    With *This
      
      If Not \Hide
        Protected s = 4, p=6
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X,\Y,\Width,\Height,\Color\Back)
        
        If \Vertical
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+p,\thumb\pos+\thumb\len,s,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X+p,\thumb\pos+\thumb\len,s,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\frame[\color[#_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+p,\Y,s,\thumb\pos-\y,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X+p,\Y,s,\thumb\pos-\y,\Color[#_1]\frame[\color[#_1]\state])
        Else
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X,\Y+p,\thumb\pos-\x,s,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X,\Y+p,\thumb\pos-\x,s,\Color[#_1]\frame[\color[#_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len,\Y+p,\Width-(\thumb\pos+\thumb\len-\x),s,\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\thumb\pos+\thumb\len,\Y+p,\Width-(\thumb\pos+\thumb\len-\x),s,\Color[#_2]\frame[\color[#_2]\state])
        EndIf
        
        Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
        
        If \vertical
          If \Ticks
            For i=0 To \page\end
              track_pos = (\area\pos + Round((i-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(\button[3]\x+\button[3]\width-1,track_pos,\button[3]\x+\button[3]\width-4,track_pos,\Color[3]\Frame)
            Next
          Else
            track_pos = (\area\pos + Round((0-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
            LineXY(\button[3]\x+\button[3]\width-1,track_pos,\button[3]\x+\button[3]\width-4,track_pos,\Color[3]\Frame)
            track_pos = (\area\pos + Round((\page\end-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
            LineXY(\button[3]\x+\button[3]\width-1,track_pos,\button[3]\x+\button[3]\width-4,track_pos,\Color[3]\Frame)
          EndIf
        Else
          If \Ticks
            For i=0 To \page\end
              track_pos = (\area\pos + Round((i-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(track_pos,\button[3]\y+\button[3]\height-1,track_pos,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            Next
          Else
            track_pos = (\area\pos + Round((0-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
            LineXY(track_pos,\button[3]\y+\button[3]\height-1,track_pos,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            track_pos = (\area\pos + Round((\page\end-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
            LineXY(track_pos,\button[3]\y+\button[3]\height-1,track_pos,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
          EndIf
        EndIf
        
      
        If \thumb\len
          Protected color_3 = \Color[3]\front[\color[1]\state+\color[2]\state]&$FFFFFF|\color\alpha<<24
          
          If \vertical
            If \direction<0
              color_3  = \Color[3]\frame[2]&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[3]\frame&$FFFFFF|\color\alpha<<24
            EndIf
          Else
            If \direction>0
              color_3  = \Color[3]\frame[2]&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[3]\frame&$FFFFFF|\color\alpha<<24
            EndIf
          EndIf
          
          
          If \Vertical
            Line(\button[3]\x,\button[3]\y+2,\button[3]\width/2+4,1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height-2-1,\button[3]\width/2+4,1,color_3)
            
            If \thumb\len <> 7
              Line(\button[3]\x,\button[3]\y+\button[3]\height/2,\button[3]\width/2+9,1,color_3)
            EndIf
            
            Line(\button[3]\x,\button[3]\y,1,\button[3]\height,color_3)
            Line(\button[3]\x,\button[3]\y,\button[3]\width/2,1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height-1,\button[3]\width/2,1,color_3)
            Line(\button[3]\x+\button[3]\width/2,\button[3]\y,\button[3]\width/2,\button[3]\height/2+1,color_3)
            Line(\button[3]\x+\button[3]\width/2,\button[3]\y+\button[3]\height-1,\button[3]\width/2,-\button[3]\height/2-1,color_3)
            
          Else
            Line(\button[3]\x+2,\button[3]\y,1,\button[3]\height/2+3,color_3)
            Line(\button[3]\x+\button[3]\width-2-1,\button[3]\y,1,\button[3]\height/2+3,color_3)
            
            If \thumb\len <> 7
              Line(\button[3]\x+\button[3]\width/2,\button[3]\y,1,\button[3]\height/2+8,color_3)
            EndIf
            
            Line(\button[3]\x,\button[3]\y,\button[3]\width,1,color_3)
            Line(\button[3]\x,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height/2-1,\button[3]\width/2+1,\button[3]\height/2,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2-1,-\button[3]\width/2-1,\button[3]\height/2,color_3)
          EndIf
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Scroll(*this._S_bar)
    With *this
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\Width,\height,\Radius,\Radius,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_3]\x,\button[#_3]\y,\button[#_3]\width,\button[#_3]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_3]\x,\button[#_3]\y,\button[#_3]\width,\button[#_3]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Radius,\Radius,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Radius,\Radius,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_1]\x+(\button[#_1]\width-6)/2,\button[#_1]\y+(\button[#_1]\height-3)/2, 3, Bool(\Vertical), \Color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          Arrow(\button[#_2]\x+(\button[#_2]\width-6)/2,\button[#_2]\y+(\button[#_2]\height-3)/2, 3, Bool(\Vertical)+2, \Color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw thumb lines
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line(\button[#_3]\x+(\button[#_3]\width-8)/2,\button[#_3]\y+\button[#_3]\height/2-3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#_3]\x+(\button[#_3]\width-8)/2,\button[#_3]\y+\button[#_3]\height/2,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#_3]\x+(\button[#_3]\width-8)/2,\button[#_3]\y+\button[#_3]\height/2+3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        Else
          Line(\button[#_3]\x+\button[#_3]\width/2-3,\button[#_3]\y+(\button[#_3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#_3]\x+\button[#_3]\width/2,\button[#_3]\y+(\button[#_3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#_3]\x+\button[#_3]\width/2+3,\button[#_3]\y+(\button[#_3]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw(*this._S_bar)
    With *this
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      Select \type
        Case #PB_GadgetType_ProgressBar
          Draw_Progress(*this)
        Case #PB_GadgetType_ScrollBar
          Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter
          Draw_Splitter(*this)
        Case #PB_GadgetType_TrackBar
          Draw_Track(*this)
      EndSelect
    EndWith
  EndProcedure
  
  ;-
  Procedure.l X(*this._S_bar)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Y(*this._S_bar)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.l Width(*this._S_bar)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Height(*this._S_bar)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.b Hide(*this._S_bar, State.b = #PB_Default)
    *this\hide ! Bool(*this\hide <> State And State <> #PB_Default)
    ProcedureReturn *this\hide
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*this._S_bar)
    ProcedureReturn *this\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_bar, Attribute.i)
    Protected Result.i
    
    With *this
      Select Attribute
        Case #PB_Bar_Minimum : Result = \min  ; 1
        Case #PB_Bar_Maximum : Result = \max  ; 2
        Case #PB_Bar_PageLength : Result = \page\len
        Case #PB_Bar_Inverted : Result = \inverted
        Case #PB_Bar_Direction : Result = \direction
        Case #PB_Bar_NoButtons : Result = \button\len 
        Case #PB_Bar_ScrollStep : Result = \scrollstep
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.b SetState(*this._S_bar, ScrollPos.l)
    Protected Result.b
    
    With *this
      ;       If #PB_GadgetType_TrackBar = \type And \vertical
      ;         ScrollPos = PagePos(*this, ScrollPos)
      ;       Else
      ;         ScrollPos = PagePos(*this, _scroll_invert_(*this, ScrollPos, \inverted))
      ;       EndIf
      
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
      EndIf
      
      If \page\pos <> ScrollPos
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, ScrollPos, \inverted))
        
       If \inverted
          If \page\pos > ScrollPos
            \direction = _scroll_invert_(*this, ScrollPos, \inverted)
          Else
            \direction =- _scroll_invert_(*this, ScrollPos, \inverted)
          EndIf
        Else
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        EndIf
        
        \page\change = \page\pos - ScrollPos
        \page\pos = ScrollPos
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._S_bar, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      Select Attribute
        Case #PB_Bar_ScrollStep 
          Result = \scrollstep
          \scrollstep = Value
          
        Case #PB_Bar_NoButtons ;: Resize = 1
          \button\len = Value
          \button[#_1]\len = Value
          \button[#_2]\len = Value
          
          ;\Resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;\Resize = 0
          
        Case #PB_Bar_Inverted
          \inverted = Bool(Value)
          \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          
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
  
  Procedure.b SetColor(*this._S_bar, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *this
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
    
    ; ResetColor(*this)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  ;-
  Procedure.b Resize(*this._S_bar, X.l,Y.l,Width.l,Height.l)
    ; Исправляет пример scroll_new000____bar_e вертикальный скролл
    ; только конец прокрутки не определяеть
    Protected Result, Lines, ScrollPage
    
    With *this
      ScrollPage = ((\max-\min) - \page\len)
      Lines = Bool(\type=#PB_GadgetType_ScrollBar)
      
      ;
      If X<>#PB_Ignore 
        \X = X 
      EndIf 
      If Y<>#PB_Ignore 
        \Y = Y 
      EndIf 
      If Width<>#PB_Ignore 
        \Width = Width 
      EndIf 
      If Height<>#PB_Ignore 
        \Height = height 
      EndIf
      
      ;
      If ((\max-\min) >= \page\len)
        If \Vertical
          \Area\pos = \Y + \button[1]\len
          \Area\len = \Height - (\button[1]\len + \button[2]\len)
        Else
          \Area\pos = \X + \button[1]\len
          \Area\len = \Width - (\button[1]\len + \button[2]\len)
        EndIf
        
        If \Area\len > \button\len
          \thumb\len = _thumb_len_(*this)
          
          If Not (\thumb\len > \button\len) 
            \area\len = Round(\Area\len - (\button\len-\thumb\len), #PB_Round_Nearest)
            \area\end = \area\pos + (\area\len-\thumb\len)
            \thumb\len = \button\len
          EndIf
          
        ElseIf \Area\len > 0
          \area\end = \area\pos + (\height-\area\len)
          \thumb\len = \Area\len 
        EndIf
        
        If \Area\len > 0
          \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          
          If \type <> #PB_GadgetType_TrackBar And \thumb\pos = \area\end
            SetState(*this, \max)
          EndIf
        EndIf
      EndIf
      
      If \Vertical
        \button[#_3]\x = \X + Lines : \button[#_3]\width = \Width - Lines : \button[#_3]\y = \thumb\pos : \button[#_3]\height = \thumb\len                                   ; Thumb coordinate on scroll bar
      Else
        \button[#_3]\y = \Y + Lines : \button[#_3]\height = \Height - Lines : \button[#_3]\x = \thumb\pos : \button[#_3]\width = \thumb\len                                  ; Thumb coordinate on scroll bar
      EndIf
      
      Select \type
         Case #PB_GadgetType_ScrollBar
          If \Vertical
            \button[#_1]\x = \X + Lines : \button[#_1]\y = \Y : \button[#_1]\width = \Width - Lines : \button[#_1]\height = \button\len                   ; Top button coordinate on scroll bar
            \button[#_2]\x = \X + Lines : \button[#_2]\width = \Width - Lines : \button[#_2]\height = \button\len : \button[#_2]\y = \Y+\Height-\button[#_2]\height ; Botom button coordinate on scroll bar
          ;  \button[#_3]\x = \X + Lines : \button[#_3]\width = \Width - Lines : \button[#_3]\y = \thumb\pos : \button[#_3]\height = \thumb\len                                   ; Thumb coordinate on scroll bar
          Else
            \button[#_1]\x = \X : \button[#_1]\y = \Y + Lines : \button[#_1]\width = \button\len : \button[#_1]\height = \Height - Lines                  ; Left button coordinate on scroll bar
            \button[#_2]\y = \Y + Lines : \button[#_2]\height = \Height - Lines : \button[#_2]\width = \button\len : \button[#_2]\x = \X+\Width-\button[#_2]\width  ; Right button coordinate on scroll bar
           ; \button[#_3]\y = \Y + Lines : \button[#_3]\height = \Height - Lines : \button[#_3]\x = \thumb\pos : \button[#_3]\width = \thumb\len                                  ; Thumb coordinate on scroll bar
          EndIf
;        Case #PB_GadgetType_ProgressBar
;           If \Vertical
;             \button[#_1]\x = \X
;             \button[#_1]\y = \Y
;             \button[#_1]\width = \width
;             \button[#_1]\height = \thumb\pos-\y
;             
;             \button[#_2]\x = \x
;             \button[#_2]\y = \thumb\pos+\thumb\len
;             \button[#_2]\width = \Width
;             \button[#_2]\height = \height-(\thumb\pos+\thumb\len-\y)
;           Else
;             \button[#_1]\x = \X
;             \button[#_1]\y = \Y
;             \button[#_1]\width = \thumb\pos-\x
;             \button[#_1]\height = \height
;             
;             \button[#_2]\x = \thumb\pos+\thumb\len
;             \button[#_2]\y = \Y
;             \button[#_2]\width = \Width-(\thumb\pos+\thumb\len-\x)
;             \button[#_2]\height = \height
;           EndIf
          
      EndSelect
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
    With *scroll
      Protected iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x, iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      ;Protected iWidth = \h\page\len, iHeight = \v\page\len
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
      
      If -\v\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If -\h\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      
      
      \v\page\end = \v\page\pos
      \h\page\end = \h\page\pos
      
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
  Procedure.b CallBack(*this._S_bar, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static LastX, LastY, Last, *thisis._S_bar, Cursor, Drag, Down
    
    With *this
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If (MouseX>\button[#_3]\x And MouseX=<\button[#_3]\x+\button[#_3]\width And MouseY>\button[#_3]\y And MouseY=<\button[#_3]\y+\button[#_3]\height)
              from = #_3
            ElseIf (MouseX>\button[#_2]\x And MouseX=<\button[#_2]\x+\button[#_2]\Width And MouseY>\button[#_2]\y And MouseY=<\button[#_2]\y+\button[#_2]\height)
              from = #_2
            ElseIf (MouseX>\button[#_1]\x And MouseX=<\button[#_1]\x+\button[#_1]\Width And  MouseY>\button[#_1]\y And MouseY=<\button[#_1]\y+\button[#_1]\height)
              from = #_1
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
            Case 1 
              If \inverted
                Result = SetState(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
              Else
                Result = SetState(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
              EndIf
              
            Case 2 
              If \inverted
                Result = SetState(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
              Else
                Result = SetState(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
              EndIf
              
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
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_LeftButtonUp, 
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave
          Static cursor_change
          
          If from>0
            If \button[from]\len And \color[from]\state <> #Disabled
              \color[from]\state = #Entered + Bool(EventType=#PB_EventType_LeftButtonDown)
              
              ; Set splitter cursor
              If from = #_3 And \type = #PB_GadgetType_Splitter
                cursor_change = 1
                If \vertical
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_UpDown)
                Else
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
                EndIf
              EndIf
            EndIf
            
          ElseIf Not Drag And Not from 
            If \color\state <> #Disabled
              \color\state = #Normal
            EndIf
            If \button[#_1]\len And \color[#_1]\state <> #Disabled
              \color[#_1]\state = #Normal
            EndIf
            If \button[#_2]\len And \color[#_2]\state <> #Disabled
              \color[#_2]\state = #Normal
            EndIf
            If \button[#_3]\len And \color[#_3]\state <> #Disabled
              \color[#_3]\state = #Normal
            EndIf
            
            ; Reset splitter cursor
            If cursor_change : cursor_change = 0
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
          EndIf
          
          Result = #True
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Bar(Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    
    With *this
      \scrollstep = 1
      \radius = Radius
      
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
      
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
      
      \color[#_1] = Color_Default
      \color[#_2] = Color_Default
      \color[#_3] = Color_Default
      
      \ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *this._S_bar = bar(min, max, PageLength, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If \vertical
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
        
        \button[#_1]\len = \button\len
        \button[#_2]\len = \button\len
      EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l, Radius.l=0)
    Protected *this._S_bar = bar(min, max, 0, Flag|#PB_Bar_NoButtons, Radius)
    
    With *this
      \type = #PB_GadgetType_ProgressBar
      \inverted = \vertical
      \color[1]\state = Bool(Not \vertical) * #Selected
      \color[2]\state = Bool(\vertical) * #Selected
      \ticks = 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l, Radius.l=0)
    Protected *this._S_bar = bar(min, max, 0, Flag|#PB_Bar_NoButtons, Radius)
    
    With *this
      \type = #PB_GadgetType_TrackBar
      \color[1]\state = Bool(Not \vertical) * #Selected
      \color[2]\state = Bool(\vertical) * #Selected
      \inverted = \vertical
      \button\len = 7
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l, Radius.l=0)
    Protected max.l, *this._S_bar = bar(0, 0, 0, Flag|#PB_Bar_NoButtons, Radius)
    
    With *this
      \type = #PB_GadgetType_Splitter
      \vertical = Bool(Flag&#PB_Bar_Vertical=0)
      \button\len = 7
      
      If \vertical
        max = Height-\button\len
      Else
        max = Width-\button\len
      EndIf
      
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule bar
  EnableExplicit
  
  Global *Scroll._S_scroll=AllocateStructure(_S_scroll)
  Global Window_demo, v, h, x=151,y=151, Width=790, Height=600 , focus
  Global g_container, g_value, g_value_, g_is_vertical, g_min, g_max, g_draw_pos, g_draw_len, g_set, g_page_pos, g_page_len, g_area_pos, g_area_len, g_Canvas
  
  Procedure pb_scroll_update()
    With *Scroll
      SetGadgetState(v, GetState(\v))
      SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(\v, #PB_ScrollBar_Minimum))
      SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(\v, #PB_ScrollBar_Maximum))
      SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(\v, #PB_ScrollBar_PageLength))
      ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\height)
      
      SetGadgetState(h, GetState(\h))
      SetGadgetAttribute(h, #PB_ScrollBar_Minimum, GetAttribute(\h, #PB_ScrollBar_Minimum))
      SetGadgetAttribute(h, #PB_ScrollBar_Maximum, GetAttribute(\h, #PB_ScrollBar_Maximum))
      SetGadgetAttribute(h, #PB_ScrollBar_PageLength, GetAttribute(\h, #PB_ScrollBar_PageLength))
      ResizeGadget(h, #PB_Ignore, #PB_Ignore, \h\width, #PB_Ignore)
    EndWith
  EndProcedure
 
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
  Macro _scroll_pos_(_this_)
    (_this_\min + Round((_this_\thumb\pos - _this_\area\pos) / (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Down)) 
  EndMacro
  
  Procedure ReDraw(canvas.i)
    With *Scroll
      pb_scroll_update()
      
      If StartDrawing(CanvasOutput(canvas))
      ; ClipOutput(0,0, X(\v), Y(\h))
      ClipOutput(\h\x, \v\y, \h\page\len, \v\page\len)
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
     ; Debug " "+Str(_scroll_pos_(\h)) +" "+ \h\page\pos
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        DrawImage(ImageID(Images()\img), Images()\x - \h\page\pos + \h\x, Images()\y - \v\page\pos + \v\y) ; draw all images with z-order
      Next
      
      UnclipOutput()
      
;       If Not Hide(*scroll\v) : Draw(*scroll\v) : EndIf
;       If Not Hide(*scroll\v) : Draw(*scroll\h) : EndIf
      If Not *scroll\v\hide : Draw(*scroll\v) : EndIf
      If Not *scroll\h\hide : Draw(*scroll\h) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width-x*2-190+2, Height-y*2+2, $0000FF)
        
        ; Scroll area coordinate
        ; Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
         Box(\h\x-\h\Page\end, \v\y-\v\Page\end, \h\Max, \v\Max, $FF0000)
        ;Box(\h\x-_scroll_pos_(\h), \v\y-_scroll_pos_(\v), \h\Max, \v\Max, $FF0000)
        
        ; page coordinate
        Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        
        ; area coordinate
        Box(\h\area\pos, \v\area\pos, \h\area\Len, \v\area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        
;         ; frame coordinate
;         Box(\h\x, \v\y, 
;             \h\Page\len + (Bool(Not \v\hide) * \v\width),
;             \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
      StopDrawing()
    EndIf
    
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, image_x, image_y, isCurrentItem.i = #False
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        image_x = *scroll\h\x + Images()\x - *scroll\h\page\pos
        image_y = *scroll\v\y + Images()\y - *scroll\v\page\pos
        
        If mouse_x > image_x And mouse_x =< image_x+Images()\width And ; Images()\x + Images()\width - *scroll\h\page\pos  ;  
           mouse_y > image_y And mouse_y =< image_y+Images()\height    ; Images()\y + Images()\height - *scroll\v\page\pos  ;   
          
          If Images()\alphatest And 
             ImageDepth(Images()\img)>31 And 
             StartDrawing(ImageOutput(Images()\img))
            DrawingMode(#PB_2DDrawing_AlphaChannel)
            alpha = Alpha( Point(mouse_x-image_x, mouse_y-image_y)) ; get alpha
            StopDrawing()
          Else
            alpha = 255
          EndIf
          
          If alpha
            MoveElement(Images(), #PB_List_Last)
            isCurrentItem = #True
            currentItemXOffset = mouse_x - Images()\x
            currentItemYOffset = mouse_y - Images()\y
            Break
          EndIf
        EndIf
      Until PreviousElement(Images()) = 0
    EndIf
    
    ProcedureReturn isCurrentItem
  EndProcedure
  
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
  
;   AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
   AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
;  AddImage(Images(), 50,150, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
  
;   hole = CreateImage(#PB_Any,100,100,32)
;   If StartDrawing(ImageOutput(hole))
;     DrawingMode(#PB_2DDrawing_AllChannels)
;     Box(0,0,100,100,RGBA($00,$00,$00,$00))
;     Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
;     Circle(50,50,30,RGBA($00,$00,$00,$00))
;     StopDrawing()
;   EndIf
;   AddImage(Images(),170,70,hole,1)
  
  
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
    With *scroll
      ;ProcedureReturn 
      
      ;Protected iWidth = X(\v), iHeight = Y(\h)
      Protected iWidth = \h\page\len, iHeight = \v\page\len
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
      
      If ScrollArea_X > 0 : ScrollArea_X = 0 : EndIf
      If ScrollArea_Y > 0 : ScrollArea_Y = 0 : EndIf
      
      If ScrollArea_X < 0 : ScrollArea_Width-ScrollArea_X : EndIf
      ;If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \h\max <> ScrollArea_Width 
        SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) 
      EndIf
      If \v\max <> ScrollArea_Height 
        SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) 
      EndIf
      
;       If \v\page\len <> iHeight 
;         SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) 
;       EndIf
;       If \h\page\len <> iWidth 
;         SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) 
;       EndIf
      
      If -\h\page\pos > ScrollArea_X
        SetState(\h, _scroll_invert_(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width, \h\inverted)) 
      EndIf
      If -\v\page\pos > ScrollArea_Y
        SetState(\v, _scroll_invert_(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height, \v\inverted)) 
      EndIf
      
      \h\thumb\len = _thumb_len_(\h)
      \h\thumb\pos = _thumb_pos_(\h, _scroll_invert_(\h, \h\page\pos, \h\inverted))
      
      \v\thumb\len = _thumb_len_(\v)
      \v\thumb\pos = _thumb_pos_(\v, _scroll_invert_(\v, \v\page\pos, \v\inverted))
      
      \h\hide[1] = Bool(Not ((\h\max-\h\min) > \h\page\len))
      \v\hide[1] = Bool(Not ((\v\max-\v\min) > \v\page\len))
      \h\hide = \h\hide[1]
      \v\hide = \v\hide[1]
      
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      If \v\hide 
        \v\page\pos = 0 
        
        If vPos 
          \v\hide = Bool(vPos) 
        EndIf 
      Else 
        \v\page\pos = vPos
      EndIf
      
      If \h\hide 
        \h\page\pos = 0 
        
        If hPos 
          \h\hide = Bool(hPos)
        EndIf
      Else 
        \h\page\pos = hPos 
      EndIf
      
      Debug " pp-"+\h\page\pos +" pl-"+ \h\page\len +" tp-"+ \h\thumb\pos +" tl-"+ \h\thumb\len +" ap-"+ \h\area\pos +" al-"+ \h\area\len +" m-"+ \h\max
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Canvas_CallBack() ; Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    If CallBack(*scroll\v, EventType, MouseX, MouseY, WheelDelta) 
      Repaint = #True 
    EndIf
    If CallBack(*scroll\h, EventType, MouseX, MouseY, WheelDelta) 
      Repaint = #True 
    EndIf
    
    Select EventType
      Case #PB_EventType_LeftButtonUp
        GetScrollCoordinate()
        
        If (ScrollX<0 Or ScrollY<0)
          PushListPosition(Images())
          ForEach Images()
            If ScrollX<0
              Images()\X-ScrollX
            EndIf
            If ScrollY<0
              Images()\Y-ScrollY
            EndIf
          Next
          PopListPosition(Images())
          
          If ScrollX<0
            *scroll\h\page\pos =- ScrollX+*scroll\h\page\pos
          EndIf
          If ScrollY<0
            *scroll\v\page\pos =- ScrollY+*scroll\v\page\pos
          EndIf
        EndIf
        
          
          GetScrollCoordinate()
        Repaint = Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        
    EndSelect     
    
    
    If (*scroll\h\from Or *scroll\v\from)
      Select EventType
        Case #PB_EventType_LeftButtonUp
          Debug "----------Up---------"
          GetScrollCoordinate()
          Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
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
      Select EventType
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
          
          Resizes(*scroll, x, y, Width-x*2, Height-y*2)
          Repaint = #True
          
      EndSelect
    EndIf 
    
    If Repaint 
      
      ReDraw(Canvas) 
    EndIf
  EndProcedure
  
  
  ;-
  ;- EXAMPLE
  ;-
  CompilerIf #PB_Compiler_IsMainFile
    
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
    
    ;-
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
      g_container = ContainerGadget(#PB_Any, 10, 10, 180, 250, #PB_Container_Flat)
      
      g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
      g_value = StringGadget(#PB_Any, 10, 32, 120, 20, "100", #PB_String_Numeric) : g_set = ButtonGadget(#PB_Any, 140, 32, 30, 20, "set")
      g_value_ = TrackBarGadget(#PB_Any, 5, 55, 170, 20, -150, 500);, #PB_TrackBar_Ticks)
      SetGadgetState(g_value_, 100)
      
      g_min = OptionGadget(#PB_Any, 10, 70+10, 160, 20, "")
      g_max = OptionGadget(#PB_Any, 10, 90+10, 160, 20, "") : SetGadgetState(g_max, 1)
      g_draw_pos = OptionGadget(#PB_Any, 10, 110+10, 160, 20, "")
      g_draw_len = OptionGadget(#PB_Any, 10, 130+10, 160, 20, "")
      g_page_pos = OptionGadget(#PB_Any, 10, 150+10, 160, 20, "")
      g_page_len = OptionGadget(#PB_Any, 10, 170+10, 160, 20, "")
      g_area_pos = OptionGadget(#PB_Any, 10, 190+10, 160, 20, "")
      g_area_len = OptionGadget(#PB_Any, 10, 210+10, 160, 20, "")
      
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+70+10, 160, 20, "Min"), #PB_Gadget_FrontColor, $FF0000)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+90+10, 160, 20, "Max"), #PB_Gadget_FrontColor, $FF0000)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+110+10, 160, 20, "Draw pos"), #PB_Gadget_FrontColor, $FFFF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+130+10, 160, 20, "Draw len"), #PB_Gadget_FrontColor, $FFFF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+150+10, 160, 20, "Page pos"), #PB_Gadget_FrontColor, $00FF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+170+10, 160, 20, "Page len"), #PB_Gadget_FrontColor, $00FF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+190+10, 160, 20, "Area pos"), #PB_Gadget_FrontColor, $00FFFF)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+210+10, 160, 20, "Area len"), #PB_Gadget_FrontColor, $00FFFF)
      CloseGadgetList()
      
      g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
      v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
;       ; Set scroll page position
;       SetGadgetState(v, 70)
;       SetGadgetState(h, 55)
      CloseGadgetList()
      
      ; Create both scroll bars
      *Scroll\v = Scroll(0, 0,  16, 0 ,0, 0, 0, #PB_ScrollBar_Vertical,7)
      *Scroll\h = Scroll(0, 0,  0, 16 ,0, 0, 0, 0, 7)
      
      ;     SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
;       ; Set scroll page position
;       SetState(*Scroll\v, 70)
;       SetState(*Scroll\h, 55)
      
      PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
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
                
              Case g_draw_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\y))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\x))
                EndSelect
                
              Case g_draw_len
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
                
              Case g_set, g_value_, g_value
                
                If g_value_ = EventGadget()
                  SetGadgetText(g_value, Str(GetGadgetState(g_value_)))
                EndIf
                If g_value = EventGadget()
                  SetGadgetState(g_value_, Val(GetGadgetText(g_value)))
                EndIf
                value = Val(GetGadgetText(g_value))
                
                Select #True
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
                    
                  Case GetGadgetState(g_draw_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*Scroll\v, #PB_Ignore, value, #PB_Ignore, #PB_Ignore)
                      Case 0
                        Resize(*Scroll\h, value, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_draw_len) 
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
                
                ReDraw(g_Canvas)
            EndSelect
            
        EndSelect
      Until Event = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS beta 4 (Windows - x64)
; CursorPosition = 1458
; FirstLine = 1445
; Folding = ---------------------------------------------
; EnableXP