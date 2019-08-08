;- >>> DECLAREMODULE
DeclareModule Scroll
  EnableExplicit
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  #PB_Bar_ScrollStep = 4
  #PB_Bar_Direction = 5
      
  EnumerationBinary 8
    #PB_Bar_NoButtons 
    #PB_Bar_Inverted 
  EndEnumeration
  
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #Button1 = 1
  #Button2 = 2
  #Thumb = 3
  
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
    direction.l
    scrollstep.l
    
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
  Declare.b Draw(*this._S_widget)
  Declare.l Y(*this._S_widget)
  Declare.l X(*this._S_widget)
  Declare.l Width(*this._S_widget)
  Declare.l Height(*this._S_widget)
  Declare.b Hide(*this._S_widget, State.b=#PB_Default)
  
  Declare.i GetState(*this._S_widget)
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
  
  Declare.b SetState(*this._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this._S_widget, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  Declare.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
  
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
      _this_\button[#Thumb]\height = _this_\thumb\len
    Else
      _this_\button[#Thumb]\width = _this_\thumb\len
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
    If _this_\thumb\pos = _this_\area\pos
      _this_\color[#Button1]\state = #Disabled
    Else
      _this_\color[#Button1]\state = #Normal
    EndIf 
    
    ; _stop_
    If _this_\thumb\pos = _this_\area\end
      _this_\color[#Button2]\state = #Disabled
    Else
      _this_\color[#Button2]\state = #Normal
    EndIf 
    
    If _this_\vertical
      _this_\button[#Thumb]\y = _this_\thumb\pos
    Else
      _this_\button[#Thumb]\x = _this_\thumb\pos
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
Module Scroll
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
    \frame[#Selected] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
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
  
  Procedure.i PagePos(*this._S_widget, State.i)
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
  
  Procedure.i ScrollPos(*this._S_widget, ThumbPos.i)
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
  
  Procedure.b Draw(*this._S_widget)
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
          _box_gradient_(\Vertical,\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Radius,\Radius,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Radius,\Radius,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#Button1]\x+(\button[#Button1]\width-6)/2,\button[#Button1]\y+(\button[#Button1]\height-3)/2, 3, Bool(\Vertical), \Color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          Arrow(\button[#Button2]\x+(\button[#Button2]\width-6)/2,\button[#Button2]\y+(\button[#Button2]\height-3)/2, 3, Bool(\Vertical)+2, \Color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw thumb lines
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2-3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2+3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        Else
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2-3,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2+3,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  ;-
  Procedure.l X(*this._S_widget)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Y(*this._S_widget)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.l Width(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Height(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.b Hide(*this._S_widget, State.b = #PB_Default)
    *this\hide ! Bool(*this\hide <> State And State <> #PB_Default)
    ProcedureReturn *this\hide
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*this._S_widget)
    ProcedureReturn *this\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
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
  Procedure.b SetState(*this._S_widget, ScrollPos.l)
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
      
      If Not (#PB_GadgetType_TrackBar = \type And \vertical)
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
  
  Procedure.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      Select Attribute
        Case #PB_Bar_ScrollStep 
          Result = \scrollstep
          \scrollstep = Value
          
        Case #PB_Bar_NoButtons ;: Resize = 1
          \button\len = Value
          \button[#Button1]\len = Value
          \button[#Button2]\len = Value
          
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
  
  Procedure.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
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
  Procedure.b Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
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
        \button[#Button1]\x = \X + Lines : \button[#Button1]\y = \Y : \button[#Button1]\width = \Width - Lines : \button[#Button1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[#Button2]\x = \X + Lines : \button[#Button2]\width = \Width - Lines : \button[#Button2]\height = \button\len : \button[#Button2]\y = \Y+\Height-\button[#Button2]\height ; Botom button coordinate on scroll bar
        \button[#Thumb]\x = \X + Lines : \button[#Thumb]\width = \Width - Lines : \button[#Thumb]\y = \thumb\pos : \button[#Thumb]\height = \thumb\len                                 ; Thumb coordinate on scroll bar
      Else
        \button[#Button1]\x = \X : \button[#Button1]\y = \Y + Lines : \button[#Button1]\width = \button\len : \button[#Button1]\height = \Height - Lines                  ; Left button coordinate on scroll bar
        \button[#Button2]\y = \Y + Lines : \button[#Button2]\height = \Height - Lines : \button[#Button2]\width = \button\len : \button[#Button2]\x = \X+\Width-\button[#Button2]\width  ; Right button coordinate on scroll bar
        \button[#Thumb]\y = \Y + Lines : \button[#Thumb]\height = \Height - Lines : \button[#Thumb]\x = \thumb\pos : \button[#Thumb]\width = \thumb\len                                ; Thumb coordinate on scroll bar
      EndIf
      
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
            If (MouseX>\button[#Thumb]\x And MouseX=<\button[#Thumb]\x+\button[#Thumb]\width And MouseY>\button[#Thumb]\y And MouseY=<\button[#Thumb]\y+\button[#Thumb]\height)
              from = #Thumb
            ElseIf (MouseX>\button[#Button2]\x And MouseX=<\button[#Button2]\x+\button[#Button2]\Width And MouseY>\button[#Button2]\y And MouseY=<\button[#Button2]\y+\button[#Button2]\height)
              from = #Button2
            ElseIf (MouseX>\button[#Button1]\x And MouseX=<\button[#Button1]\x+\button[#Button1]\Width And  MouseY>\button[#Button1]\y And MouseY=<\button[#Button1]\y+\button[#Button1]\height)
              from = #Button1
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
          If from>0
            If \color[from]\state <> #Disabled
              \color[from]\state = #Entered + Bool(EventType=#PB_EventType_LeftButtonDown)
            EndIf
          ElseIf Not Drag And Not from 
            If \color\state <> #Disabled
              \color\state = #Normal
            EndIf
            If \color[#Button1]\state <> #Disabled
              \color[#Button1]\state = #Normal
            EndIf
            If \color[#Button2]\state <> #Disabled
              \color[#Button2]\state = #Normal
            EndIf
            If \color[#Thumb]\state <> #Disabled
              \color[#Thumb]\state = #Normal
            EndIf
          EndIf
          
          Result = #True
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \scrollstep = 1
      \radius = Radius
      
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
      
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
      
      \color[#Button1] = Color_Default
      \color[#Button2] = Color_Default
      \color[#Thumb] = Color_Default
      
      \type = #PB_GadgetType_ScrollBar
      \vertical = Bool(Flag&#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      If Width = #PB_Ignore
        Width = 0
      EndIf
        
      If Height = #PB_Ignore
        Height = 0
      EndIf
        
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
        
        \button[#Button1]\len = \button\len
        \button[#Button2]\len = \button\len
      EndIf
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      
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




;
; Module name   : TrackBar
; Author        : mestnyi
; Last updated  : Aug 7, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule TrackBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Coordinate
    y.l[4]
    x.l[4]
    Height.l[4]
    Width.l[4]
  EndStructure
  
  Structure Mouse
    X.l
    Y.l
    Buttons.l
  EndStructure
  
  Structure Canvas
    Mouse.Mouse
    Gadget.l
    Window.l
  EndStructure
  
  Structure Gadget Extends Coordinate
    Canvas.Canvas
    
    Text.s[3]
    ImageID.l[3]
    ;Color.Scroll::_s_color[3]
    Color.l[3]
    Ticks.b
    
    Image.Coordinate
    
    fSize.l
    bSize.l
    
    *Scroll.Scroll::_S_widget
    
    Type.l
    InnerCoordinate.Coordinate
    
    Repaint.l
    
    List Items.Gadget()
    List Columns.Gadget()
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.l)
  Declare SetState(Gadget.l, State.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.l=0)
  
EndDeclareModule

Module TrackBar
  
  ;- PROCEDURE
  
  Procedure Re(*This.Gadget)
    If Not *This\Repaint : *This\Repaint = #True : EndIf
    
    Scroll::SetAttribute(*This\Scroll, #PB_ScrollBar_Maximum, *This\Scroll\Max)
    Scroll::SetAttribute(*This\Scroll, #PB_ScrollBar_PageLength, *This\Scroll\Page\Len)
    Scroll::Resize(*This\Scroll, *This\X[2], *This\Y[2], *This\Width[2], *This\Height[2])
    
  EndProcedure
  
  Procedure _Draw(*This.Gadget)
    With *This\Scroll
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          DrawingFont(GetGadgetFont(#PB_Default))
        CompilerEndIf
        
        If Not \Hide
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+1,\Y+(\thumb\pos+\thumb\len-3),2,\Height-(\thumb\pos+\thumb\len-3),$FF00FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+1,\Y,2,\thumb\pos-1,\Color[1]\frame)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+(\thumb\pos+\thumb\len-3),\Y+5+1,\Width-(\thumb\pos+\thumb\len-3),2,\Color[1]\frame)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X,\Y+5+1,\thumb\pos-1,2,$FF00FF)
          EndIf
          
          If *This\Ticks
            Protected i, ii.f
            Protected _thumb_ = (\thumb\len/2-2) 
            Debug "page end "+ \page\end +" area end "+ \area\end +" _thumb_ "+ _thumb_
            
            For i=0 To \page\end
              ii = (\area\pos + Round((i-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(\X+ii,\button[3]\y+\button[3]\height-1,\X+ii,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            Next
          EndIf
          
          
          Protected color_3 = \Color[3]\front[\color[1]\state+\color[2]\state]&$FFFFFF|\color\alpha<<24
          
          If \vertical
            If \direction<0
              color_3  = $FF00FF&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[1]\frame
            EndIf
          Else
            If \direction>0
              color_3  = $FF00FF&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[1]\frame
            EndIf
          EndIf
        
          If \Vertical
            Line(\button[3]\x,\button[3]\y+2,\button[3]\width/2+4,1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height-2-1,\button[3]\width/2+4,1,color_3)
            
            If \thumb\len <> 7
              Line(\button[3]\x,\button[3]\y+\button[3]\height/2,\button[3]\width/2+7,1,color_3)
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
              Line(\button[3]\x+\button[3]\width/2,\button[3]\y,1,\button[3]\height/2+6,color_3)
            EndIf
            
            Line(\button[3]\x,\button[3]\y,\button[3]\width,1,color_3)
            Line(\button[3]\x,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height/2-1,\button[3]\width/2+1,\button[3]\height/2,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2-1,-\button[3]\width/2-1,\button[3]\height/2,color_3)
          EndIf
          
          StopDrawing()
        EndIf
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure Draw(*This.Gadget)
    With *This\Scroll
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          DrawingFont(GetGadgetFont(#PB_Default))
        CompilerEndIf
        
        If Not \Hide
          Protected s = 3, p=0
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+p,\Y+(\thumb\pos+\thumb\len-3),s,\Height-(\thumb\pos+\thumb\len-3),\Color[3]\frame[2])
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+p,\Y,s,\thumb\pos-1,\Color[3]\frame)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+(\thumb\pos+\thumb\len-3),\Y+5+p,\Width-(\thumb\pos+\thumb\len-3),s,\Color[3]\frame)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X,\Y+5+p,\thumb\pos-1,s,\Color[3]\frame[2])
          EndIf
          
;           If \Vertical
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+5+1,\Y+(\thumb\pos+\thumb\len-3),2,\Height-(\thumb\pos+\thumb\len-3),\Color[3]\frame[2])
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+5+1,\Y,2,\thumb\pos-1,\Color[3]\frame)
;           Else
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+(\thumb\pos+\thumb\len-3),\Y+5+1,\Width-(\thumb\pos+\thumb\len-3),2,\Color[3]\frame)
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X,\Y+5+1,\thumb\pos-1,2,\Color[3]\frame[2])
;           EndIf
          
          If *This\Ticks
            Protected i, ii.f, _thumb_ = (\thumb\len/2-2)
            For i=0 To \page\end
              ii = (\area\pos + Round(((i)-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(\X+ii,\button[3]\y+\button[3]\height-1,\X+ii,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            Next
          EndIf
          
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
        
;           If \Vertical
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(\button[3]\x,\button[3]\y,\button[3]\width/2,\button[3]\height,\Color[3]\Back)
;             
;             Line(\button[3]\x,\button[3]\y,1,\button[3]\height,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y,\button[3]\width/2,1,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y+\button[3]\height-1,\button[3]\width/2,1,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width/2,\button[3]\y,\button[3]\width/2,\button[3]\height/2+1,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width/2,\button[3]\y+\button[3]\height-1,\button[3]\width/2,-\button[3]\height/2-1,\Color[3]\Frame)
;             
;           Else
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height/2,\Color[3]\Back)
;             
;             Line(\button[3]\x,\button[3]\y,\button[3]\width,1,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y,1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y+\button[3]\height/2,\button[3]\width/2+1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2,-\button[3]\width/2-1,\button[3]\height/2,\Color[3]\Frame)
;           EndIf
          
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
          
          If \Focus
            For i=0 To \Area\len+\Thumb\len+2 Step 2
              Line(*This\X,*This\Y+i,1,1,\Color[3]\Frame[3])
              Line(*This\X+*This\Width-1,*This\Y+i,1,1,\Color[3]\Frame[3])
              
              Line(*This\X+i,*This\Y,1,1,\Color[3]\Frame[3])
              Line(*This\X+i,*This\Y+*This\Height-1,1,1,\Color[3]\Frame[3])
            Next
          EndIf
          
          StopDrawing()
        EndIf
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure ReDraw(*This.Gadget)
    Re(*This)
    Draw(*This)
  EndProcedure
  
  
  Procedure CallBack()
    Static LastX, LastY
    Protected *This.Gadget = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Re(*This)
          
      EndSelect
      
      *This\Repaint = Scroll::CallBack(*This\Scroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If *This\Repaint 
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
    
    ; Draw(*This)
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetAttribute(*This\Scroll, Attribute, Value)
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.l, Attribute.l)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
        Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
        Case #PB_ScrollBar_PageLength : Result = \Scroll\Page\len
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.l, State.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetState(*This\Scroll, State)
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      ScrollPos = \Scroll\Page\Pos
      ;If (\Scroll\Vertical And \Scroll\Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Scroll\Max-\Scroll\Min)-ScrollPos) : EndIf
      ProcedureReturn ScrollPos
    EndWith
  EndProcedure
  
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.l=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Pagelength.l
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        
        \Type = #PB_GadgetType_TrackBar
        \Ticks = Bool(Flag&#PB_TrackBar_Ticks)
        
        \fSize = 2
        \bSize = \fSize
        
        ; Inner coordinae
        \X[2]=\bSize
        \Y[2]=\bSize
        \Width[2] = \Width-\bSize*2
        \Height[2] = \Height-\bSize*2
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize
        \Y[1]=\Y[2]-\fSize
        \Width[1] = \Width[2]+\fSize*2
        \Height[1] = \Height[2]+\fSize*2
        
        \Color[0] = $FFFFFF
        \Color[1] = $C0C0C0
        \Color[2] = $F0F0F0
        
        *This\Scroll = Scroll::Gadget(0, 0, 0, 0, Min, Max, PageLength, Bool(Flag&#PB_TrackBar_Vertical)|Scroll::#PB_Bar_NoButtons,0)
        If Bool(Flag&#PB_TrackBar_Vertical)
          *This\Scroll\inverted = 1
        EndIf
        
        *This\Scroll\Type = \Type
        *This\Scroll\Button\Len = 15
        ;*This\Scroll\thumb\Len = 25
        Scroll::Resize(*this\Scroll, X,Y,Width,Height)
    
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
Define a,i


Procedure v_GadgetCallBack()
  TrackBar::SetState(12, GetGadgetState(EventGadget()))
EndProcedure

Procedure v_CallBack()
  SetGadgetState(2, TrackBar::GetState(EventGadget()))
EndProcedure

Procedure h_GadgetCallBack()
  TrackBar::SetState(11, GetGadgetState(EventGadget()))
EndProcedure

Procedure h_CallBack()
  SetGadgetState(1, TrackBar::GetState(EventGadget()))
EndProcedure


If OpenWindow(0, 0, 0, 605, 200, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget    (-1, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TrackBarGadget(0, 10,  40, 250, 20, 0, 10000)
  SetGadgetState(0, 5000)
  TextGadget    (-1, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TrackBarGadget(1, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  SetGadgetState(1, 3000)
  TextGadget    (-1,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBarGadget(2, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  SetGadgetState(2, 8000)
  
  TextGadget    (-1, 300+10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TrackBar::Gadget(10, 300+10,  40, 250, 20, 0, 10000)
  TrackBar::SetState(10, 5000)
  TextGadget    (-1, 300+10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TrackBar::Gadget(11, 300+10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  TrackBar::SetState(11, 3000)
  TextGadget    (-1,  300+90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBar::Gadget(12, 300+270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  TrackBar::SetState(12, 8000)
  
  BindGadgetEvent(1,@h_GadgetCallBack())
  BindGadgetEvent(11,@h_CallBack(), #PB_EventType_Change)
  BindGadgetEvent(2,@v_GadgetCallBack())
  BindGadgetEvent(12,@v_CallBack(), #PB_EventType_Change)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 0----------------------4---------
; EnableXP