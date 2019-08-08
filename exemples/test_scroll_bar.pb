;- >>> DECLAREMODULE
DeclareModule Scroll
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
  
  Procedure.b Draw_Track(*this._S_widget)
    With *This
        
        If Not \Hide
          Protected s = 3, p=5
          
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+p,\thumb\pos+\thumb\len,s,\Height-(\thumb\pos+\thumb\len-\y),\Color[3]\frame[2])
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+p,\Y,s,\thumb\pos-\y,\Color[3]\frame)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X,\Y+p,\thumb\pos-\x,s,\Color[3]\frame[2])
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\thumb\pos+\thumb\len,\Y+p,\Width-(\thumb\pos+\thumb\len-\x),s,\Color[3]\frame)
          EndIf
          
          If \Ticks
            Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
            For i=0 To \page\end
              track_pos = (\area\pos + Round((i-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(track_pos,\button[3]\y+\button[3]\height-1,track_pos,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            Next
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
              
              Line(\thumb\pos,\button[3]\y,\thumb\len,1,color_3)
              Line(\thumb\pos,\button[3]\y,1,\button[3]\height/2-1,color_3)
              Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2-1,color_3)
              Line(\button[3]\x,\button[3]\y+\button[3]\height/2-1,\button[3]\width/2+1,\button[3]\height/2,color_3)
              Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2-1,-\button[3]\width/2-1,\button[3]\height/2,color_3)
            EndIf
          EndIf
          
        EndIf
        
      EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Scroll(*this._S_widget)
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
  
  Procedure.b Draw(*this._S_widget)
    With *this
      Select \type
        Case #PB_GadgetType_ScrollBar
          Draw_Scroll(*this)
        Case #PB_GadgetType_TrackBar
          Draw_Track(*this)
      EndSelect
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
      
      If \type = #PB_GadgetType_TrackBar
        \inverted = Bool(Flag&#PB_Bar_Vertical)
        Flag|#PB_Bar_NoButtons
      EndIf
      
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


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Scroll
  Global g_Canvas, *w_1._S_widget, *w_2._S_widget
  Global NewList *List._S_widget()
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        ForEach *List()
          If Not *List()\hide
            Draw(*List())
          EndIf
        Next
        
        StopDrawing()
      EndIf
  EndProcedure
  
  Procedure v_GadgetCallBack()
    SetState(*w_2, GetGadgetState(EventGadget()))
    ReDraw(g_Canvas)
  EndProcedure
  
  Procedure v_CallBack(GetState)
    SetGadgetState(3, GetState)
  EndProcedure
  
  Procedure h_GadgetCallBack()
    SetState(*w_1, GetGadgetState(EventGadget()))
    ReDraw(g_Canvas)
  EndProcedure
  
  Procedure h_CallBack(GetState)
    SetGadgetState(2, GetState)
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._S_widget = GetGadgetData(Canvas)
    ;     
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Default
        
        If EventType = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        ForEach *List()
          Repaint | CallBack(*List(), EventType, MouseX, MouseY)
          
          If *List()\page\change
            
            If *List()\vertical
              v_CallBack(*List()\page\pos)
            Else
              h_CallBack(*List()\page\pos)
            EndIf
            
            *List()\page\change = 0
          EndIf
        Next
        
        
    EndSelect
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  

  If OpenWindow(0, 0, 0, 605, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget       (-1,  10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (2,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (2,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (3, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (3, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    g_Canvas = CanvasGadget(-1, 305, 0, 300, 140)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    TextGadget       (-1,  300+10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    *w_1 = Gadget  (10, 42, 250,  20, 30, 100, 30, 0)
    SetState   (*w_1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    *w_2 = Gadget  (270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetState   (*w_2, 300)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    AddElement(*List()) : *List() = *w_1
    AddElement(*List()) : *List() = *w_2
    
    BindGadgetEvent(2,@h_GadgetCallBack())
    BindGadgetEvent(3,@v_GadgetCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -----------------------------
; EnableXP