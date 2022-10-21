
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
  ; #PB_Bar_ScrollStep = #PB_ScrollArea_ScrollStep
  
  EnumerationBinary 4
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #Button1 = 1
  #Button2 = 2
  #Thumb = 3
  
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
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1)
  Declare.b Draw(*this._S_widget)
  Declare.l Y(*this._S_widget)
  Declare.l X(*this._S_widget)
  Declare.l Width(*this._S_widget)
  Declare.l Height(*this._S_widget)
  
  Declare.i GetState(*this._S_widget)
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
  
  Declare.b SetState(*this._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this._S_widget, iX.l,iY.l,iWidth.l,iHeight.l)
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
  
  ; Inverted scroll bar position
  Macro _invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ;-
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\Vertical
      _this_\button[#Thumb]\height = _this_\thumb\len
    Else
      _this_\button[#Thumb]\width = _this_\thumb\len
    EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
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
        ThumbPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        
        If #PB_GadgetType_TrackBar = \type And \vertical
          ThumbPos = _invert_(*this, ThumbPos, \inverted)
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
          BoxGradient(\Vertical,\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          BoxGradient(\Vertical,\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
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
      If ScrollPos < \min : ScrollPos = \min : EndIf
      If ScrollPos > (\max-\page\len) : ScrollPos = (\max-\page\len) : EndIf
      
      If #PB_GadgetType_TrackBar = \type And \vertical
        ScrollPos = PagePos(*this, ScrollPos)
      Else
        ScrollPos = PagePos(*this, _invert_(*this, ScrollPos, \inverted))
      EndIf
      
      If \page\pos <> ScrollPos
        \thumb\pos = ThumbPos(*this, _invert_(*this, ScrollPos, \inverted))
        
        If \inverted
          If \page\pos > ScrollPos
            \direction = _invert_(*this, ScrollPos, \inverted)
          Else
            \direction =- _invert_(*this, ScrollPos, \inverted)
          EndIf
        Else
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        EndIf
        
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
          \thumb\pos = ThumbPos(*this, _invert_(*this, \page\pos, \inverted))
          
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
    Protected Result, Lines, ScrollPage
    
    With *this
      ScrollPage = ((\max-\min) - \page\len)
      Lines = Bool(\type=#PB_GadgetType_ScrollBar)
      
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
          \thumb\len = ThumbLength(*this)
          ; area end pos
          \area\end = \area\pos + (\area\len-\thumb\len)
            
          If (\Area\len > \button\len)
            If \button\len
              If (\thumb\len < \button\len)
                \Area\len = Round(\Area\len - (\button\len-\thumb\len), #PB_Round_Nearest)
                \area\end = \area\pos + (\height-\button\len)
                \thumb\len = \button\len 
              EndIf
            Else
              ; TrackBar
              If (\thumb\len < 7)
                \Area\len = Round(\Area\len - (7-\thumb\len), #PB_Round_Nearest)
                \area\end = \area\pos + \Area\Len 
                \thumb\len = 7
              EndIf
            EndIf
          Else
            \area\end = \area\pos + (\height-\area\len)
            \thumb\len = \Area\len 
          EndIf
          
          If \Area\len > 0
            If (\type <> #PB_GadgetType_TrackBar) And (\thumb\pos+\thumb\len) >= (\Area\len+\button\len)
              SetState(*this, ScrollPage)
            EndIf
            
            \thumb\pos = ThumbPos(*this, _invert_(*this, \page\pos, \inverted))
          EndIf
        EndIf
      EndIf
      
      
      \X = X : \Y = Y : \Width = Width : \height = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \button[#Button1]\x = X + Lines : \button[#Button1]\y = Y : \button[#Button1]\width = Width - Lines : \button[#Button1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[#Button2]\x = X + Lines : \button[#Button2]\width = Width - Lines : \button[#Button2]\height = \button\len : \button[#Button2]\y = Y+Height-\button[#Button2]\height ; Botom button coordinate on scroll bar
        \button[#Thumb]\x = X + Lines : \button[#Thumb]\width = Width - Lines : \button[#Thumb]\y = \thumb\pos : \button[#Thumb]\height = \thumb\len                  ; Thumb coordinate on scroll bar
      Else
        \button[#Button1]\x = X : \button[#Button1]\y = Y + Lines : \button[#Button1]\width = \button\len : \button[#Button1]\height = Height - Lines                  ; Left button coordinate on scroll bar
        \button[#Button2]\y = Y + Lines : \button[#Button2]\height = Height - Lines : \button[#Button2]\width = \button\len : \button[#Button2]\x = X+Width-\button[#Button2]\width  ; Right button coordinate on scroll bar
        \button[#Thumb]\y = Y + Lines : \button[#Thumb]\height = Height - Lines : \button[#Thumb]\x = \thumb\pos : \button[#Thumb]\width = \thumb\len                 ; Thumb coordinate on scroll bar
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
                Result = SetState(*this, _invert_(*this, (\page\pos + \scrollstep), \inverted))
              Else
                Result = SetState(*this, _invert_(*this, (\page\pos - \scrollstep), \inverted))
              EndIf
              
            Case 2 
                If \inverted
                Result = SetState(*this, _invert_(*this, (\page\pos - \scrollstep), \inverted))
              Else
                Result = SetState(*this, _invert_(*this, (\page\pos + \scrollstep), \inverted))
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
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule

; Module name   : Editor
; Author        : mestnyi
; Last updated  : Aug 7, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70650
;

EnableExplicit
;-
DeclareModule Editor
  EnableExplicit
 
  EnumerationBinary 4
  ;  #PB_Text_Center
  ;  #PB_Text_Right
    #PB_Text_Bottom
   
    #PB_Text_UpperCase
    #PB_Text_LowerCase
    #PB_Text_Password
   
    #PB_Text_Middle
    #PB_Text_MultiLine
  EndEnumeration
 
  #PB_Text_ReadOnly = #PB_String_ReadOnly
  #PB_Text_Numeric = #PB_String_Numeric
  #PB_Text_WordWrap = #PB_Editor_WordWrap
 
  ;   Debug #PB_Text_Center
  ;   Debug #PB_Text_Right
  ;   Debug #PB_Text_Bottom
  ;   
  ;   Debug #PB_Text_UpperCase
  ;   Debug #PB_Text_LowerCase
  ;   Debug #PB_Text_Password
  ;   
  ;   Debug #PB_Text_Middle
  ;   Debug #PB_Text_MultiLine
  ;   
  ;   Debug #PB_Text_ReadOnly
  ;   Debug #PB_Text_Numeric
  ;   
  ;   Debug #PB_Text_WordWrap
 
 
  ;- STRUCTURE
  Structure Coordinate
    y.l[3]
    x.l[3]
    Height.l[3]
    Width.l[3]
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
   
    Input.c
    Key.l[2]
   
  EndStructure
 
  Structure Text Extends Coordinate
    ;     Char.c
    Len.l
    String.s[2]
    Change.b
   
    XAlign.b
    YAlign.b
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    WordWrap.b
    MultiLine.b
   
   
    Mode.l
  EndStructure
 
  Structure Gadget Extends Coordinate
    FontID.i
    Canvas.Canvas
   
    Pos.l[2] ; 0 = Pos ; 1 = PosFixed
    CaretPos.l[2] ; 0 = Pos ; 1 = PosFixed
    CaretLength.l
   
    Text.Text[4]
    ImageID.l[3]
    Color.l[3]
   
    Image.Coordinate
   
    fSize.l
    bSize.l
    Hide.b[2]
    Disable.b[2]
   
    Scroll.Scroll::_S_scroll
    
    Type.l
    InnerCoordinate.Coordinate
   
    Repaint.l
   
    List Items.Gadget()
    List Columns.Gadget()
  EndStructure
 
 
  ;- DECLARE
  Declare GetState(Gadget.l)
  Declare.s GetText(Gadget.l)
  Declare SetState(Gadget.l, State.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare SetText(Gadget, Text.s, Item.l=0)
  Declare SetFont(Gadget, FontID.i)
  Declare AddItem(Gadget,Item,Text.s,Image.l=-1,Flag.l=0)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
 
EndDeclareModule

Module Editor
 
  ;- PROCEDURE
 
  Procedure.s DrawMultiText(X, Y, Text.s, FontColor = $FFFFFF, BackColor = 0, Flags = 0, Width = 0, Height = 0)
    Protected Text_X, Text_Y
    Protected TxtHeight = TextHeight("A")
    Protected Is_Vcenter.b, Is_Hcenter.b, Is_Right.b, Is_Bottom.b
    Protected String.s, String1.s, String2.s, String3.s, CountString, IT, Start, Count, Break_Y
    ;Protected Time = ElapsedMilliseconds()
    If Width = 0 : Width = OutputWidth() : EndIf
    If Height = 0 : Height = OutputHeight() : EndIf
   
    ; Перевести разрывы строк
    Text = ReplaceString(Text, #LFCR$, #LF$)
    Text = ReplaceString(Text, #CRLF$, #LF$)
    Text = ReplaceString(Text, #CR$, #LF$)
    Text + #LF$
    ;
    CountString = CountString(Text, #LF$)
   
    Is_Right = Bool((Flags & #PB_Text_Right) = #PB_Text_Right)
    Is_Bottom = Bool((Flags & #PB_Text_Bottom) = #PB_Text_Bottom) 
   
    If Is_Right
      Is_Hcenter = Bool((Flags & #PB_Text_Center) = #PB_Text_Center)
    Else
      Is_Vcenter = Bool((Flags & #PB_Text_Center) = #PB_Text_Center)
    EndIf
   
    Is_Hcenter = Bool((Flags & #PB_Text_Middle) = #PB_Text_Middle) 
   
    If CountString
      ; make multi text
      For IT = 1 To CountString : Start = 1
        String = StringField(Text, IT, #LF$)
        Count = CountString(String, " ") + Start
       
        Repeat
          String1 = StringField(String, Start, " ")
         
          While (Count>=Start) : Start+1
            String2 = StringField(String, Start, " ")
           
            If (TextWidth(Trim(String1+" "+String2)) < (Width-Len(Mid(String2,Len(String2)))))
              String1 = Trim(String1+" "+String2)
            Else
              Break
            EndIf
          Wend
         
          String3+String1+#LF$
        Until (Start>Count)
      Next
     
      CountString = CountString(String3, #LF$)
     
      If CountString
        If Is_Hcenter : Text_Y=((Height-(TxtHeight*CountString))/2)
          ElseIf Is_Bottom : Text_Y=(Height-(TxtHeight*CountString)) : EndIf
       
        ; Text тратить
        For IT = 1 To CountString
          String1 = StringField(String3, IT, #LF$)
         
          If Is_Vcenter : Text_X = ((Width-TextWidth(String1))/2)
            ElseIf Is_Right : Text_X=(Width-TextWidth(String1)) : EndIf
          DrawText(X+Text_X, Y+Text_Y, String1, FontColor, BackColor)
         
          Text_Y+TxtHeight
          If Text_Y > (Height-TxtHeight)
            Break
          EndIf
        Next
      EndIf
     
    Else
      If Is_Hcenter : Text_Y=((Height-TxtHeight)/2)
        ElseIf Is_Bottom : Text_Y=(Height-TxtHeight) : EndIf
      If Is_Vcenter : Text_X = ((Width-TextWidth(Text))/2)
        ElseIf Is_Right : Text_X=(Width-TextWidth(Text)) : EndIf
      DrawText(X+Text_X, Y+Text_Y, Text, FontColor, BackColor)
    EndIf
   
    ;Debug "Time "+Str(Time-ElapsedMilliseconds())
   
    ProcedureReturn String3
   
  EndProcedure
 
  Procedure CaretPos(*This.Gadget)
    Protected Result.l =- 1, i.l, Len.l, Text_X.l, String.s,
              CursorX.l, Distance.f, MinDistance.f = Infinity()
   
    With *This
      If ListSize(\Items())
        String.s = \Items()\Text\String.s
        Text_X = \Items()\Text\x
        Len = \Items()\Text\Len
      Else
        String.s = \Text\String.s
        Text_X = \Text\x
        Len = \Text\Len
      EndIf
     
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        If \FontID : DrawingFont(\FontID) : EndIf
       
        For i=0 To Len
          \CaretLength = TextWidth(Left(String.s, i))
          CursorX = Text_X+\CaretLength+1
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
         
          ; Получаем позицию коpректора
          If MinDistance > Distance
            MinDistance = Distance
            Result = i
          EndIf
        Next
       
        StopDrawing()
      EndIf
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  Procedure SelectionText(*This.Gadget)
    Protected CaretPos
   
    With *This\Items()
      If *This\Pos[1]>*This\Pos
        PushListPosition(*This\Items())
        While PreviousElement(*This\Items()) : \Text[2]\Len = 0 : Wend
        PopListPosition(*This\Items())
      Else
        PushListPosition(*This\Items())
        While NextElement(*This\Items()) : \Text[2]\Len = 0 : Wend
        PopListPosition(*This\Items())
      EndIf
     
      ; Если выделяем с верху вниз
      If *This\Pos > *This\Pos[1]
        \Text[2]\Len = *This\CaretPos
      ElseIf *This\Pos[1] > *This\Pos
        CaretPos = *This\CaretPos
        \Text[2]\Len = \Text\Len-CaretPos
      Else
        ; Если выделяем с право на лево
        If *This\CaretPos[1] > *This\CaretPos
          CaretPos = *This\CaretPos
          \Text[2]\Len = (*This\CaretPos[1]-CaretPos)
        Else
          CaretPos = *This\CaretPos[1]
          \Text[2]\Len = (*This\CaretPos-CaretPos)
        EndIf
      EndIf
     
      If \Text[2]\Len
        \Text[1]\String.s = Left(\Text\String.s, CaretPos)
        \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
        ; \Text[3]\String.s = Mid(\Text\String.s, 1 + CaretPos + \Text[2]\Len)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
      Else
        \Text[2]\String.s = ""
      EndIf
    EndWith
   
    ProcedureReturn CaretPos
  EndProcedure
 
  Procedure RemoveText(*This.Gadget)
    With *This\Items()
      ;*This\CaretPos = 0
      If *This\CaretPos > *This\CaretPos[1] : *This\CaretPos = *This\CaretPos[1] : EndIf
      ; Debug "  "+*This\CaretPos +" "+ *This\CaretPos[1]
      ;\Text\String.s = RemoveString(\Text\String.s, Trim(\Text[2]\String.s, #LF$), #PB_String_CaseSensitive, 0, 1) ; *This\CaretPos
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\CaretPos
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\CaretPos
      \Text[2]\String.s[1] = \Text[2]\String.s
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
 
  Procedure Cut(*This.Gadget)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
   
    With *This\Items()
      If ListSize(*This\Items())
        ;If \Text[2]\Len
        If *This\Pos[1] = *This\Pos
          Debug "Cut Black"
          If \Text[2]\Len
            RemoveText(*This)
          Else
            \Text[2]\String.s[1] = Mid(\Text\String.s, *This\CaretPos, 1)
            \Text\String.s = Left(\Text\String.s, *This\CaretPos - 1) + Right(\Text\String.s, \Text\Len-*This\CaretPos)
            \Text\String.s[1] = Left(\Text\String.s[1], *This\CaretPos - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-*This\CaretPos)
            *This\CaretPos - 1
          EndIf
        Else
          Debug " Cut " +*This\CaretPos +" "+ *This\CaretPos[1]+" "+\Text[2]\Len
         
          If \Text[2]\Len
            ;If *This\Pos > *This\Pos[1]
            RemoveText(*This)
            ;EndIf
           
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\Pos)
            EndIf
          EndIf
         
          ; Выделили сверх вниз
          If *This\Pos > *This\Pos[1]
            Debug "  Cut_1_ForEach"
           
            PushListPosition(*This\Items())
            ForEach *This\Items()
              If \Text[2]\Len
                If \Text[2]\Len = \Text\Len
                  DeleteElement(*This\Items(), 1)
                Else
                  RemoveText(*This)
                EndIf
              EndIf
            Next
            PopListPosition(*This\Items())
           
            *This\CaretPos = *This\CaretPos[1]
            ; Выделили снизу верх
          ElseIf *This\Pos[1] > *This\Pos
            *This\Pos[1] = *This\Pos
           
            *This\CaretPos[1] = *This\CaretPos  ; Выделили пос = 0 фикс = 1
           
            ;             Debug "  Cut_21_ForEach"
            ;               
            ;             PushListPosition(*This\Items())
            ;             ForEach *This\Items()
            ;               If \Text[2]\Len
            ;                 If \Text[2]\Len = \Text\Len
            ;                   DeleteElement(*This\Items(), 1)
            ;                 Else
            ;                   RemoveText(*This)
            ;                 EndIf
            ;               EndIf
            ;             Next
            ;             PopListPosition(*This\Items())
           
          EndIf
         
         
          If *This\Pos[1]>=0 And *This\Pos[1]<ListSize(*This\Items())
            ;If *This\Pos > *This\Pos[1]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\Pos[1])
           
            If Not *This\CaretPos
              *This\CaretPos = \Text\Len-Len(#LF$)
            EndIf
           
            ; Выделили сверху вниз
            If *This\Pos > *This\Pos[1]
              *This\Pos = *This\Pos[1]
              *This\CaretPos = *This\CaretPos[1] ; Выделили пос = 0 фикс = 0
              \Text\String.s = String.s + \Text\String.s
            Else
              ;;*This\CaretPos[1] = *This\CaretPos  ; Выделили пос = 0 фикс = 1
              \Text\String.s = \Text\String.s + String.s
            EndIf
           
            \Text\Len = Len(\Text\String.s)
          EndIf
         
          PushListPosition(*This\Items())
          ForEach *This\Items()
            If \Text[2]\Len
              Debug "  Cut_2_ForEach"
              If \Text[2]\Len = \Text\Len
                DeleteElement(*This\Items(), 1)
              Else
                RemoveText(*This)
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items())
         
        EndIf
        ;EndIf 
      EndIf
    EndWith
  EndProcedure
 
  Procedure.s Copy(*This.Gadget)
    Protected String.s
   
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Text[2]\Len
          String.s+\Items()\Text[2]\String.s+#LF$
        EndIf
      Next
      PopListPosition(\Items())
     
      String.s = Trim(String.s, #LF$)
      ; Для совместимости с виндовсовским
      If String.s And Not \CaretPos
        String.s+#LF$+#CR$
      EndIf
    EndWith
   
    ProcedureReturn String.s
  EndProcedure
 
  Procedure.b Back(*This.Gadget)
    Protected Repaint.b, String.s
   
    With *This\Items()
      If ListSize(*This\Items()) And (*This\CaretPos = 0 And *This\CaretPos = *This\CaretPos[1]) And ListIndex(*This\Items()) 
        Debug "Back"
       
        If Not \Text[2]\Len
          If *This\Pos[1] > *This\Pos : *This\Pos[1] = *This\Pos : Else : *This\Pos[1] - 1 : EndIf
          If (*This\Pos[1]>=0 And *This\Pos[1]<ListSize(*This\Items()))
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            SelectElement(*This\Items(), *This\Pos[1])
           
            If *This\CaretPos = *This\CaretPos[1]
              *This\CaretPos = \Text\Len-Len(#LF$)
            EndIf
            If *This\Pos > *This\Pos[1]
              *This\CaretPos[1] = *This\CaretPos
            EndIf
           
            \Text\String.s + String.s
            \Text\Len = Len(\Text\String.s)
          EndIf
        EndIf
       
        ForEach *This\Items()
          If \Text[2]\Len
            If \Text[2]\Len = \Text\Len
              DeleteElement(*This\Items(), 1)
            Else
              RemoveText(*This)
            EndIf
          EndIf
        Next
       
        SelectElement(*This\Items(), *This\Pos[1])
       
        *This\Pos = *This\Pos[1]
        Repaint = #True
      EndIf
    EndWith
   
    ProcedureReturn Repaint
  EndProcedure
 
  Procedure SelectionLimits(*This.Gadget)
    Protected i, char
   
    With *This\Items()
      If \Text\Pass
        *This\CaretPos = \Text\Len
        \Text[2]\Len = *This\CaretPos
        *This\CaretPos[1] = 0
      Else
        char = Asc(Mid(\Text\String.s, *This\CaretPos + 1, 1))
       
        If (char > =  ' ' And char < =  '/') Or
           (char > =  ':' And char < =  '@') Or
           (char > =  '[' And char < =  96) Or
           (char > =  '{' And char < =  '~')
         
          *This\CaretPos[1] = *This\CaretPos : *This\CaretPos + 1
          \Text[2]\Len = *This\CaretPos[1] - *This\CaretPos
        Else
          For i = *This\CaretPos To 0 Step - 1
            char = Asc(Mid(\Text\String.s, i, 1))
            If (char > =  ' ' And char < =  '/') Or
               (char > =  ':' And char < =  '@') Or
               (char > =  '[' And char < =  96) Or
               (char > =  '{' And char < =  '~')
              Break
            EndIf
          Next
         
          If i =- 1 : *This\CaretPos[1] = 0 : Else : *This\CaretPos[1] = i : EndIf
         
          For i = *This\CaretPos + 1 To \Text\Len
            char = Asc(Mid(\Text\String.s, i, 1))
            If (char > =  ' ' And char < =  '/') Or
               (char > =  ':' And char < =  '@') Or
               (char > =  '[' And char < =  96) Or
               (char > =  '{' And char < =  '~')
              Break
            EndIf
          Next
         
          *This\CaretPos = i - 1
          \Text[2]\Len = *This\CaretPos[1] - *This\CaretPos
          If \Text[2]\Len < 0 : \Text[2]\Len = 0 : EndIf
        EndIf
      EndIf
    EndWith           
  EndProcedure
 
  Procedure EditableCallBack(*This.Gadget, EventType.l)
    Static Text$, DoubleClickCaretPos =- 1
    Protected Repaint.b, String.s, StartDrawing, Update_Text_Selected
   
   
    If *This
      With *This\Items()
        If Not *This\Disable
          Protected Item = (*This\Canvas\Mouse\Y-*This\Scroll\Y)/*This\Text\Height
         
          If EventType = #PB_EventType_LeftButtonDown
            *This\Pos[1] = Item : *This\Pos = *This\Pos[1]
           
            PushListPosition(*This\Items())
            ForEach *This\Items() : \Text[2]\Len = 0 : Next
            PopListPosition(*This\Items())
          EndIf
         
          If EventType = #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons
              If *This\Pos>=0 And *This\Pos < ListSize(*This\Items())
                SelectElement(*This\Items(), *This\Pos)
               
                If *This\Pos[1]>Item
                  *This\CaretPos = 0
                Else
                  *This\CaretPos = \Text\Len
                EndIf
               
                SelectionText(*This)
              EndIf
             
              *This\Pos = Item
              If *This\Pos>=0 And *This\Pos < ListSize(*This\Items())
                SelectElement(*This\Items(), *This\Pos)
              EndIf
            EndIf
          Else
            If *This\Pos[1]>=0 And *This\Pos[1] < ListSize(*This\Items())
              SelectElement(*This\Items(), *This\Pos[1])
            EndIf
          EndIf
         
         
          Select EventType
            Case #PB_EventType_MouseEnter
              SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
             
            Case #PB_EventType_LostFocus : Repaint = #True
              If Not Bool(*This\Type = #PB_GadgetType_Editor)
                ; StringGadget
                \Text[2]\Len = 0 ; Убыраем выделение
              EndIf
              *This\CaretPos[1] =- 1 ; Прячем коректор
             
            Case #PB_EventType_Focus : Repaint = #True
              *This\CaretPos[1] = *This\CaretPos ; Показываем коректор
             
            Case #PB_EventType_Input
              If *This\Text\Editable
                Protected Input, Input_2
               
                Select #True
                  Case \Text\Lower : Input = Asc(LCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case \Text\Upper : Input = Asc(UCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case \Text\Pass  : Input = 9679 : Input_2 = *This\Canvas\Input ; "●"
                  Case \Text\Numeric
                    ;                     Debug *This\Canvas\Input
                    Static Dot
                   
                    Select *This\Canvas\Input
                      Case '.','0' To '9' : Input = *This\Canvas\Input : Input_2 = Input
                      Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
                      Default
                        Input_2 = *This\Canvas\Input
                    EndSelect
                   
                    If Not Dot And Input = '.'
                      Dot = 1
                    ElseIf Input <> '.'
                      Dot = 0
                    Else
                      Input = 0
                    EndIf
                   
                  Default
                    Input = *This\Canvas\Input : Input_2 = Input
                EndSelect
               
                If Input_2
                  If Input
                    If \Text[2]\String.s
                      RemoveText(*This)
                    EndIf
                    *This\CaretPos + 1
                    *This\CaretPos[1] = *This\CaretPos
                  EndIf
                 
                  If \Text\Numeric And Input = Input_2
                    \Text\String.s[1] = \Text\String.s
                  EndIf
                 
                  ;\Text\String.s = Left(\Text\String.s, *This\CaretPos-1) + Chr(Input) + Mid(\Text\String.s, *This\CaretPos)
                  \Text\String.s = InsertString(\Text\String.s, Chr(Input), *This\CaretPos)
                  \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), *This\CaretPos)
                 
                  If Input
                    \Text\Len = Len(\Text\String.s)
                    PostEvent(#PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Change)
                  EndIf
                 
                  Repaint = #True
                EndIf
              EndIf
             
            Case #PB_EventType_KeyUp
              If \Text\Numeric
                \Text\String.s[1]=\Text\String.s
              EndIf
              Repaint = #True
             
            Case #PB_EventType_KeyDown
              Select *This\Canvas\Key
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\CaretPos = 0 : *This\CaretPos[1] = *This\CaretPos : Repaint = #True
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\CaretPos = \Text\Len : *This\CaretPos[1] = *This\CaretPos : Repaint = #True
                 
                Case #PB_Shortcut_Left : \Text[2]\String.s = ""
                  If *This\CaretPos > 0 Or ListIndex(*This\Items()) : *This\CaretPos - 1
                   
                    ; Если дошли до начала строки то переходим в конец предыдущего итема
                    If *This\CaretPos =- 1 And *This\Pos[1] : *This\Pos[1]-1
                      SelectElement(*This\Items(), *This\Pos[1])
                      *This\CaretPos = \Text\Len-Len(#LF$)
                    EndIf
                   
                    If *This\CaretPos[1] <> *This\CaretPos
                      If \Text[2]\Len
                        If *This\CaretPos > *This\CaretPos[1]
                          *This\CaretPos = *This\CaretPos[1]
                          *This\CaretPos[1] = *This\CaretPos
                        Else
                          *This\CaretPos[1] = *This\CaretPos + 1
                          *This\CaretPos = *This\CaretPos[1]
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\CaretPos[1] = *This\CaretPos
                      EndIf
                    EndIf
                   
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_Right : \Text[2]\String.s = ""
                  If *This\CaretPos[1] < \Text\Len : *This\CaretPos[1] + 1
                   
                    ; Если дошли в конец строки то переходим на начало следующего итема
                    If *This\CaretPos[1] = \Text\Len And *This\Pos[1] < ListSize(*This\Items()) - 1 : *This\Pos[1] + 1
                      SelectElement(*This\Items(), *This\Pos[1]) : *This\CaretPos[1] = 0
                    EndIf
                   
                    If *This\CaretPos <> *This\CaretPos[1]
                      If \Text[2]\Len
                        If *This\CaretPos > *This\CaretPos[1]
                          *This\CaretPos = *This\CaretPos[1]+\Text[2]\Len - 1
                          *This\CaretPos[1] = *This\CaretPos
                        Else
                          *This\CaretPos = *This\CaretPos[1] - 1
                          *This\CaretPos[1] = *This\CaretPos
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\CaretPos = *This\CaretPos[1]
                      EndIf
                    EndIf
                   
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_Up : \Text[2]\String.s = ""
                  If *This\Pos[1] : *This\Pos[1]-1
                    SelectElement(*This\Items(), *This\Pos[1])
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_Down : \Text[2]\String.s = ""
                  If *This\Pos[1] < ListSize(*This\Items()) - 1 : *This\Pos[1] + 1
                    SelectElement(*This\Items(), *This\Pos[1])
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_Return
                  Debug "Return "+ListIndex(*This\Items())
                  If *This\CaretPos ;: *This\Pos[1]+1
                    *This\CaretPos[1] = \Text\Len
                    SelectionText(*This)
                    String.s = \Text[2]\String.s
                  EndIf
                 
                  If String.s
                    RemoveText(*This)
                  Else
                    String.s = ""
                  EndIf
                  Debug String
                 
                  *This\Pos[1] = AddItem(*This\Canvas\Gadget, *This\Pos[1]+1, String.s+#LF$)
                  *This\CaretPos = 0
                  *This\Text\Len = Len(\Text\String.s)
                  *This\CaretPos[1] = *This\CaretPos
                 
                  ;                   If Not *This\CaretPos
                  ;                     SelectElement(*This\Items(), *This\Pos[1])
                  ;                   ; *This\Pos[1] + 1 
                  ;                   EndIf
                 
                  Scroll::SetState(*This\scroll\v, *This\scroll\v\Max)
                  Repaint = #True
                 
                Case #PB_Shortcut_Back
                  Repaint = Back(*This)
                  If Not Repaint
                    Cut(*This)
                   
                    *This\CaretPos[1] = *This\CaretPos
                    \Text\Len = Len(\Text\String.s)
                   
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_Delete
                  If *This\CaretPos < \Text\Len
                    If \Text[2]\String.s
                      RemoveText(*This)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, (*This\CaretPos+1), 1)
                      \Text\String.s = Left(\Text\String.s, *This\CaretPos) + Right(\Text\String.s, \Text\Len-(*This\CaretPos+1))
                      \Text\String.s[1] = Left(\Text\String.s[1], *This\CaretPos) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(*This\CaretPos+1))
                    EndIf
                   
                    If ListSize(*This\Items())
                      PushListPosition(*This\Items())
                      ForEach *This\Items()
                        If \Text[2]\Len = \Text\Len
                          DeleteElement(*This\Items(), 1)
                        EndIf
                      Next
                      PopListPosition(*This\Items())
                     
                      If *This\CaretPos = Len(\Text\String.s) : *This\Pos[1]+1
                        If *This\Pos[1]>=0 And *This\Pos[1]<ListSize(*This\Items())
                          PushListPosition(*This\Items())
                          SelectElement(*This\Items(), *This\Pos[1])
                          String.s = \Text\String.s
                          DeleteElement(*This\Items(), 1)
                          PopListPosition(*This\Items())
                          \Text\String.s + String.s
                          *This\Pos[1] - 1
                        EndIf
                      EndIf
                    EndIf
                   
                    *This\CaretPos[1] = *This\CaretPos
                    \Text\Len = Len(\Text\String.s)
                   
                    Repaint = #True
                  EndIf
                 
                 
                Case #PB_Shortcut_X
                  If (*This\Canvas\Key[1] & #PB_Canvas_Control)
                    SetClipboardText(Copy(*This))
                   
                    Cut(*This)
                   
                    *This\CaretPos[1] = *This\CaretPos
                    Repaint = #True
                  EndIf
                 
                Case #PB_Shortcut_C ; Ok
                  If (*This\Canvas\Key[1] & #PB_Canvas_Control)
                    SetClipboardText(Copy(*This))
                  EndIf
                 
                Case #PB_Shortcut_V
                  If *This\Text\Editable And (*This\Canvas\Key[1] & #PB_Canvas_Control)
                    Protected CaretPos, ClipboardText.s = Trim(GetClipboardText(), #CR$)
                   
                    If ClipboardText.s
                      If \Text[2]\Len
                        RemoveText(*This)
                       
                        If \Text[2]\Len = \Text\Len
                          ;*This\Pos[1] = *This\Pos
                          ClipboardText.s = Trim(ClipboardText.s, #LF$)
                        EndIf
                        ;                         
                        PushListPosition(*This\Items())
                        ForEach *This\Items()
                          If \Text[2]\Len
                            If \Text[2]\Len = \Text\Len
                              DeleteElement(*This\Items(), 1)
                            Else
                              RemoveText(*This)
                            EndIf
                          EndIf
                        Next
                        PopListPosition(*This\Items())
                      EndIf
                     
                      Select #True
                        Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                        Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                        Case \Text\Numeric
                          If Val(ClipboardText.s)
                            ClipboardText.s = Str(Val(ClipboardText.s))
                          EndIf
                      EndSelect
                     
                      \Text\String.s = InsertString( \Text\String.s, ClipboardText.s, *This\CaretPos + 1)
                     
                      If CountString(\Text\String.s, #LF$)
                        CaretPos = \Text\Len-*This\CaretPos
                        String.s = \Text\String.s
                        DeleteElement(*This\Items(), 1)
                        SetText(*This\Canvas\Gadget, String.s, *This\Pos[1])
                        *This\CaretPos = Len(\Text\String.s)-CaretPos
                        ;                         SelectElement(*This\Items(), *This\Pos)
                        ;                        *This\CaretPos = 0
                      Else
                        *This\CaretPos + Len(ClipboardText.s)
                      EndIf
                     
                      *This\CaretPos[1] = *This\CaretPos
                      \Text\Len = Len(\Text\String.s)
                     
                      Repaint = #True
                    EndIf
                  EndIf
                 
              EndSelect
             
            Case #PB_EventType_LeftDoubleClick
              DoubleClickCaretPos = *This\CaretPos
              SelectionLimits(*This)
              SelectionText(*This)
              Repaint = #True
             
            Case #PB_EventType_LeftButtonDown
              If \Text\Numeric : \Text\String.s[1] = \Text\String.s : EndIf
              *This\CaretPos = CaretPos(*This) : *This\CaretPos[1] = *This\CaretPos
             
              If *This\CaretPos = DoubleClickCaretPos
                DoubleClickCaretPos =- 1
                *This\CaretPos[1] = \Text\Len
                *This\CaretPos = 0
              EndIf
             
              SelectionText(*This)
              Repaint = #True
             
            Case #PB_EventType_MouseMove
              If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                *This\CaretPos = CaretPos(*This)
                SelectionText(*This)
                Repaint = #True
              EndIf
             
          EndSelect
         
        EndIf
       
        ;         If Repaint
        ;          ; *This\CaretLength = \CaretLength
        ;           *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
        ;         EndIf
      EndWith
    EndIf
   
    ProcedureReturn Repaint
  EndProcedure
 
  Procedure Re(*This.Gadget)
    With *This
      If Not *This\Repaint : *This\Repaint = #True : EndIf
    EndWith   
  EndProcedure
 
  Procedure Draw(*This.Gadget)
    Protected Left, Right, r=1
   
    If *This\Repaint And StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      If *This\FontID : DrawingFont(*This\FontID) : EndIf
      Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],*This\Color[0])
     
     
      If *This\fSize
        DrawingMode(#PB_2DDrawing_Outlined)
        ;             If \Active
        ;               Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],$FF8E00)
        ;             Else
        Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],*This\Color[1])
        ;             EndIf
      EndIf
     
     
     
      *This\Text\Height = TextHeight("A")
     
      *This\Scroll\Height = *This\Text\Y
      ;       *This\Scroll\X =- *This\scroll\h\Page\Pos
      *This\Scroll\Y =- *This\scroll\v\Page\Pos
     
      If ListSize(*This\Items())
        *This\CaretLength = TextWidth(Left(*This\Items()\Text\String.s, *This\CaretPos))
      EndIf
     
     
      With *This\Items()
        PushListPosition(*This\Items())
       
        ForEach *This\Items()
          \Text\Height = TextHeight("A")
          \Text\Width = TextWidth(\Text\String.s)
          \Text[1]\Width = TextWidth(\Text[1]\String.s)
          \Text[2]\Width = TextWidth(\Text[2]\String.s)
          \Text[3]\Width = TextWidth(\Text[3]\String.s)
         
          ; Перемещаем корректор
          Select *This\Text\XAlign
            Case 9 : *This\Scroll\X = (*This\Width-*This\Items()\Text\Width)/2
              If *This\Scroll\X<*This\fSize*2 + r : *This\Scroll\X=*This\fSize*2 + r : EndIf
              If *This\CaretPos[1] =- 1
                *This\CaretLength =- *This\Scroll\X + *This\fSize*2 + r
                *This\CaretPos = *This\CaretLength
              EndIf
            Case 2 : *This\Scroll\X = (*This\Width-\Text\Width-*This\fSize*2) - r
          EndSelect
          Select *This\Text\YAlign
            Case 9 : *This\Scroll\Y = (*This\Height-*This\Text\Height)/2
            Case 2 : *This\Scroll\Y = (*This\Height-*This\Text\Height)
          EndSelect
         
          If *This\Text\Editable
            If \Text[2]\String.s[1] And *This\Scroll\X < 0
              *This\Scroll\X + TextWidth(\Text[2]\String.s[1])
              \Text[2]\String.s[1] = ""
            EndIf
           
            Left =- (*This\CaretLength-*This\fSize*2) + r
            Right = (*This\Width-*This\CaretLength-*This\fSize*2) - r
           
            If *This\Scroll\X < Left
              *This\Scroll\X = Left
            ElseIf *This\Scroll\X > Right
              *This\Scroll\X = Right
            EndIf
           
          EndIf
         
          \Text\Y = *This\Scroll\Height+*This\Scroll\Y
          \Text\X = *This\Scroll\X - *This\scroll\h\Page\Pos
         
         
          If *This\Scroll\Width<\Text\Width
            *This\Scroll\Width=\Text\Width
          EndIf
         
          *This\Scroll\Height + \Text\Height
        Next
        PopListPosition(*This\Items())
       
        ; Draw
        ClipOutput(0,0, Scroll::X(*This\scroll\v), Scroll::Y(*This\scroll\h))
       
        PushListPosition(*This\Items())
        ForEach *This\Items()
          If \Text\String.s
            If \Text[2]\Len
              If \Text[1]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
              EndIf
             
              If \Text[2]\String.s
                DrawingMode(#PB_2DDrawing_Default)
                \Text[2]\X = \Text\X+\Text[1]\Width
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
                DrawText(\Text[2]\X, \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
              EndIf
             
              If \Text[3]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(\Text[3]\X, \Text\Y, \Text[3]\String.s, $0B0B0B)
              EndIf
            Else
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
            EndIf
          EndIf
        Next
        PopListPosition(*This\Items())
       
        If ListSize(*This\Items()) And *This\CaretPos=*This\CaretPos[1] ; And Property_GadgetTimer( 300 )
          DrawingMode(#PB_2DDrawing_XOr) 
          Line(*This\Items()\Text\X + *This\CaretLength - Bool(*This\Scroll\X = Right), *This\Items()\Text\y, 1, *This\Text\Height, $FFFFFF)
        EndIf
       
      EndWith 
     
     
      If *This\scroll\v\Page\len And *This\scroll\v\Max<>*This\Scroll\Height
        If Scroll::SetAttribute(*This\scroll\v, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
      If *This\scroll\h\Page\len And *This\scroll\h\Max<>*This\Scroll\Width
        If Scroll::SetAttribute(*This\scroll\h, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
     
      UnclipOutput()
         
      Scroll::Draw(*This\scroll\v)
      Scroll::Draw(*This\scroll\h)
     
      *This\Repaint = #False
      StopDrawing()
    EndIf
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
      \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
      \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
      \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      Protected iHeight = \Height-Scroll::Height(*This\scroll\h)
      Protected iWidth = \Width-Scroll::Width(*This\scroll\v)
     
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
         
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
         
          Scroll::Resizes(*This\Scroll, *This\x[2]+1,*This\Y[2]+1,*This\Width[2]-2,*This\Height[2]-2)
          ReDraw(*This)
         
      EndSelect
     
      *This\Repaint = Scroll::CallBack(*This\scroll\v, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If *This\Repaint
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
     
      *This\Repaint = Scroll::CallBack(*This\scroll\h, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If *This\Repaint
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
     
      ;Debug *This\scroll\h\at
     
      If Not *This\scroll\v\from And Not *This\scroll\h\from
        ;Or (\Canvas\Mouse\X<*This\Width[2]-Scroll::Width(*This\scroll\v) And \Canvas\Mouse\Y<*This\Height[2]-Scroll::Height(*This\scroll\h))
        *This\Repaint = EditableCallBack(*This, EventType())
        If *This\Repaint
          ReDraw(*This)
        EndIf
      EndIf
     
    EndWith
   
    ; Draw(*This)
  EndProcedure
 
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
   
    With *This
     
    EndWith
  EndProcedure
 
  Procedure GetAttribute(Gadget.l, Attribute.l)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
   
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\PageLength
      ;       EndSelect
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  Procedure SetState(Gadget.l, State.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
   
    With *This
     
    EndWith
  EndProcedure
 
  Procedure GetState(Gadget.l)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
   
    With *This
     
    EndWith
  EndProcedure
 
  Procedure.s GetText(Gadget.l)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
   
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
 
  Procedure AddItem(Gadget, Item,Text.s,Image.l=-1,Flag.l=0)
    Protected *This.Gadget = GetGadgetData(Gadget)
   
    With *This\Items()
      If Item = #PB_Any
        LastElement(*This\Items())
        AddElement(*This\Items())
      Else
        If (Item > (ListSize(*This\Items()) - 1))
          LastElement(*This\Items())
          AddElement(*This\Items())
        Else
          SelectElement(*This\Items(), Item)
          InsertElement(*This\Items())
        EndIf
      EndIf
     
      \Text\String.s = Text.s
     
      \Text\X = *This\Text\X
      \Text\Y = *This\Text\Y
     
      \Text\Editable = 1
      \Text\XAlign = *This\Text\XAlign
      \Text\YAlign = *This\Text\YAlign
     
      *This\CaretPos[1] =- 1
      \Text\Len = Len(\Text\String.s)
     
    EndWith
   
    *This\Repaint=1
   
    If *This\Scroll\Height<*This\Height
      Draw(*This)
      ; Scroll::SetState(*This\scroll\v, *This\scroll\v\Max)
    EndIf
   
    ProcedureReturn Item
  EndProcedure
 
  Procedure SetText(Gadget, Text.s, Item.l=0)
    Protected *This.Gadget = GetGadgetData(Gadget)
   
    With *This\Items()
      Protected i,c = CountString(Text.s, #LF$)
     
      For i=0 To c
        Debug "String len - "+Len(StringField(Text.s, i + 1, #LF$))
        AddItem( Gadget, Item+i, StringField(Text.s, i + 1, #LF$))
      Next
    EndWith
  EndProcedure
 
  Procedure SetFont(Gadget, FontID.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
   
    With *This
      \FontID = FontID
      ReDraw(*This)
    EndWith
  EndProcedure
 
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Min.l, Max.l, PageLength.l
   
     With *This
     If *This
        \Canvas\Gadget = Gadget
        \Type = #PB_GadgetType_Editor
        \FontID = GetGadgetFont(#PB_Default)
        ;\FontID = GetGadgetFont(Gadget)
       
        \fSize = Bool(Not Flag&#PB_String_BorderLess)
        \bSize = \fSize
       
        \Width = Width
        \Height = Height
       
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
       
        \Color[1] = $C0C0C0
        \Color[2] = $F0F0F0
       
        ;\Scroll\ButtonLength = 7
        \Text\WordWrap = Bool(Flag&#PB_Editor_WordWrap)
        \Text\Editable = Bool(Not Flag&#PB_Editor_ReadOnly)
        If \Text\Editable
          \Color[0] = $FFFFFF
        Else
          \Color[0] = $F0F0F0
        EndIf
       
        \Text\X = 2
        \Text\y = \fSize
       
        \Text\YAlign = 0
        If Bool(Flag&#PB_Text_Right) : \Text\XAlign = 2 : EndIf
        If Bool(Flag&#PB_Text_Center) : \Text\XAlign = 9 : EndIf
       
       
       *This\scroll\v = Scroll::Gadget(#PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 8)
        *This\scroll\h = Scroll::Gadget(#PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 8)
       
       
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
       
        If Text.s
          SetText(Gadget, Text.s)
        EndIf
       
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
   
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
 
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
 
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
 
  Procedure ResizeCallBack()
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
  EndProcedure
 
  LoadFont(0, "Courier", 14)
  If OpenWindow(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
   
    EditorGadget(0, 8, 8, 306, 133) : SetGadgetText(0, Text.s)
    For a = 0 To 5
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
   
   
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, "") : Editor::SetText(g, Text.s)
    For a = 0 To 5
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::SetFont(g, FontID(0))
   
    SplitterGadget(10,8, 8, 306, 276, 0,g)
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
   
    Repeat
      Define Event = WaitWindowEvent()
     
      Select Event
        Case #PB_Event_LeftClick 
          SetActiveGadget(0)
        Case #PB_Event_RightClick
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------------------------------------------------
; EnableXP