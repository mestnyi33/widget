; _s_module_bar_4_ orig
; Os              : All
; Version         : 3
; License         : Free
; Module name     : Scroll
; Author          : mestnyi
; PB version:     : 5.46 =< 5.62
; Last updated    : 3 Aug 2019
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
DeclareModule Bar
  EnableExplicit
  
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
    
    #PB_Bar_First
    #PB_Bar_Second
    #PB_Bar_FirstFixed
    #PB_Bar_SecondFixed
    #PB_Bar_FirstMinimumSize
    #PB_Bar_SecondMinimumSize
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  Prototype pFunc2()
  
  ;- STRUCTUREs
  ;- - _S_event
  Structure _S_event
    widget.i
    type.l
    item.l
    *data
    *callback.pFunc2
  EndStructure
  
  ;- - _S_coordinate
  Structure _S_coordinate
    x.l
    y.l
    width.l
    height.l
  EndStructure
  
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
  Structure _S_button Extends _S_coordinate
    len.a
    interact.b
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_scroll
  Structure _S_scroll Extends _S_coordinate
    *v._S_bar
    *h._S_bar
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._S_bar
    *second;._S_bar
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_Text
  Structure _S_text Extends _S_coordinate
    fontID.i
    string.s
    change.b
    rotate.f
  EndStructure
  
  ;- - _S_bar
  Structure _S_bar Extends _S_coordinate
    type.l
    from.l
    focus.l
    radius.l
    
    mode.l
    change.l
    cursor.l
    hide.b[2]
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    
    max.l
    min.l
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    button._S_button[4] 
    
    *text._S_text
    *event._S_event 
    *splitter._S_splitter
  EndStructure
  
  Global *event._S_event = AllocateStructure(_S_event)
  
  ;-
  ;- DECLAREs
  Declare.b Draw(*this)
  Declare.l Y(*this)
  Declare.l X(*this)
  Declare.l Width(*this)
  Declare.l Height(*this)
  Declare.b Hide(*this, State.b=#PB_Default)
  
  Declare.i GetState(*this)
  Declare.i GetAttribute(*this, Attribute.i)
  
  Declare.b SetState(*this, ScrollPos.l)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  Declare.b SetColor(*this, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
  
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
  Declare.b Bind(*callBack, *this, eventtype.l=#PB_All)
  
  ;- MACROs
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Type()
    *event\type
  EndMacro
  
  Macro Item()
    *event\item
  EndMacro
  
  Macro Data()
    *event\data
  EndMacro
  
  ; Extract thumb len from (max area page) len
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
  Global def_colors._S_color
  
  With def_colors                          
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
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    If _this_\Vertical 
      _this_\button\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\y = _this_\area\pos
      _this_\button\width = _this_\width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\height = _this_\area\len               
    Else 
      _this_\button\x = _this_\area\pos
      _this_\button\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\width = _this_\area\len
      _this_\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\button[#_b_1]\len And _this_\page\len
      If _scroll_pos_ = _this_\min
        _this_\color[#_b_1]\state = #Disabled
        _this_\button[#_b_1]\interact = 0
      Else
        _this_\color[#_b_1]\state = #Normal
        _this_\button[#_b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\button[#_b_1]\x = _this_\button\x
        _this_\button[#_b_1]\y = _this_\Y 
        _this_\button[#_b_1]\width = _this_\button\width
        _this_\button[#_b_1]\height = _this_\button[#_b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\button[#_b_1]\x = _this_\X 
        _this_\button[#_b_1]\y = _this_\button\y
        _this_\button[#_b_1]\width = _this_\button[#_b_1]\len 
        _this_\button[#_b_1]\height = _this_\button\height 
      EndIf
    Else
      _this_\button[#_b_1]\x = _this_\X
      _this_\button[#_b_1]\y = _this_\Y
      
      If _this_\Vertical
        _this_\button[#_b_1]\width = _this_\width
        _this_\button[#_b_1]\height = _this_\thumb\pos-_this_\y
      Else
        _this_\button[#_b_1]\width = _this_\thumb\pos-_this_\x
        _this_\button[#_b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\button[#_b_2]\len And _this_\page\len
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_b_2]\state = #Disabled
        _this_\button[#_b_2]\interact = 0
      Else
        _this_\color[#_b_2]\state = #Normal
        _this_\button[#_b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\button[#_b_2]\x = _this_\button\x
        _this_\button[#_b_2]\width = _this_\button\width
        _this_\button[#_b_2]\height = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\y = _this_\Y+_this_\Height-_this_\button[#_b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\button[#_b_2]\y = _this_\button\y
        _this_\button[#_b_2]\height = _this_\button\height
        _this_\button[#_b_2]\width = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\x = _this_\X+_this_\width-_this_\button[#_b_2]\width 
      EndIf
      
    Else
      If _this_\Vertical
        _this_\button[#_b_2]\x = _this_\x
        _this_\button[#_b_2]\y = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\width = _this_\width
        _this_\button[#_b_2]\height = _this_\height-(_this_\thumb\pos+_this_\thumb\len-_this_\y)
      Else
        _this_\button[#_b_2]\x = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\y = _this_\Y
        _this_\button[#_b_2]\width = _this_\width-(_this_\thumb\pos+_this_\thumb\len-_this_\x)
        _this_\button[#_b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\thumb\len
      If _this_\button[#_b_3]\len <> _this_\thumb\len
        _this_\button[#_b_3]\len = _this_\thumb\len
      EndIf
      
      If _this_\Vertical
        _this_\button[#_b_3]\x = _this_\button\x 
        _this_\button[#_b_3]\width = _this_\button\width 
        _this_\button[#_b_3]\y = _this_\thumb\pos
        _this_\button[#_b_3]\height = _this_\thumb\len                              
      Else
        _this_\button[#_b_3]\y = _this_\button\y 
        _this_\button[#_b_3]\height = _this_\button\height
        _this_\button[#_b_3]\x = _this_\thumb\pos 
        _this_\button[#_b_3]\width = _this_\thumb\len                                  
      EndIf
      
    Else
      If _this_\type <> #PB_GadgetType_ProgressBar
        ; Эфект спин гаджета
        If _this_\Vertical
          _this_\button[#_b_2]\Height = _this_\Height/2 
          _this_\button[#_b_2]\y = _this_\y+_this_\button[#_b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\button[#_b_1]\y = _this_\y 
          _this_\button[#_b_1]\Height = _this_\Height/2
          
        Else
          _this_\button[#_b_2]\width = _this_\width/2 
          _this_\button[#_b_2]\x = _this_\x+_this_\button[#_b_2]\width+Bool(_this_\width%2) 
          
          _this_\button[#_b_1]\x = _this_\x 
          _this_\button[#_b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\text
      _this_\text\change = 1
    EndIf
    
    ; Splitter childrens auto resize       
    If _this_\Splitter
      splitter_size(_this_)
    EndIf
    
    If _this_\change
      Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\direction)
    EndIf
  EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\vertical
      _this_\area\pos = _this_\y + _this_\button[#_b_1]\len
      _this_\area\len = _this_\height - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    Else
      _this_\area\pos = _this_\x + _this_\button[#_b_1]\len
      _this_\area\len = _this_\width - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  Procedure.b splitter_size(*this._S_bar)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, (*this\button[#_b_2]\height+*this\thumb\len)-*this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, (*this\button[#_b_1]\height+*this\thumb\len)-*this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  ;-
  ;- - DRAW
  Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
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
      If Style > 0 : y-1 : x + 1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
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
  
  Procedure.b Draw_Scroll(*this._S_bar)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\width,\height,\Radius,\Radius,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          If (\page\len+Bool(\Radius)*(\width/4)) = \height
            Line( \x, \y, 1, \page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        Else
          If (\page\len+Bool(\Radius)*(\height/4)) = \width
            Line( \x, \y, \page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2-3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2+3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2-3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2+3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\Back[\color[#_b_1]\state], \Radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\Back[\color[#_b_2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Radius,\Radius,\Color[#_b_1]\frame[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Radius,\Radius,\Color[#_b_2]\frame[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_1]\x+(\button[#_b_1]\width-\button[#_b_1]\arrow_size)/2,\button[#_b_1]\y+(\button[#_b_1]\height-\button[#_b_1]\arrow_size)/2, \button[#_b_1]\arrow_size, Bool(\Vertical), \Color[#_b_1]\front[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_1]\arrow_type)
          Arrow(\button[#_b_2]\x+(\button[#_b_2]\width-\button[#_b_2]\arrow_size)/2,\button[#_b_2]\y+(\button[#_b_2]\height-\button[#_b_2]\arrow_size)/2, \button[#_b_2]\arrow_size, Bool(\Vertical)+2, \Color[#_b_2]\front[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_Track(*this._S_bar)
    With *This
      
      If Not \Hide
        Protected _pos_ = 6, _size_ = 4
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X,\Y,\Width,\Height,\Color\Back)
        
        If \Vertical
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
          
        Else
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        
        If \thumb\len
          Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(\button[3]\x+\button[3]\width-4,track_pos,4, 1,\Color[3]\Frame)
              Next
            Else
              Line(\button[3]\x+\button[3]\width-4,\area\pos + _thumb_,4, 1,\Color[3]\Frame)
              Line(\button[3]\x+\button[3]\width-4,\area\pos + \area\len + _thumb_,4, 1,\Color[3]\Frame)
            EndIf
          Else
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Next
            Else
              Line(\area\pos + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Line(\area\pos + \area\len + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Color[3]\fore[#_b_2],\Color[3]\Back[#_b_2], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Radius,\Radius,\Color[3]\frame[#_b_2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_3]\x+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(\Vertical),\button[#_b_3]\y+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(Not \Vertical), 
                \button[#_b_3]\arrow_size, Bool(\Vertical)+Bool(Not \inverted And \direction>0)*2+Bool(\inverted And \direction=<0)*2, \Color[#_b_3]\frame[\color[#_b_3]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_3]\arrow_type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Progress(*this._S_bar)
    
    ; Selected Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,*this\button[#_b_1]\height,*this\color[#_b_1]\fore[*this\color[#_b_1]\state],*this\color[#_b_1]\back[*this\color[#_b_1]\state])
    
    ; Normal Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_2]\x, *this\button[#_b_2]\y,*this\button[#_b_2]\width,*this\button[#_b_2]\height,*this\color[#_b_2]\fore[*this\color[#_b_2]\state],*this\color[#_b_2]\back[*this\color[#_b_2]\state])
    
    If *this\vertical
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X+*this\button[#_b_1]\width-1,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
      
    Else
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y+*this\button[#_b_1]\height-1,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\Y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\Y,1,*this\button[#_b_2]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
    EndIf
    
    ; Text
    If *this\text
      If *this\text\change 
        *this\text\change = 0
        *this\text\string = "%"+Str(*this\Page\Pos)
        *this\text\width = TextWidth(*this\text\string)
        *this\text\height = TextHeight("A")
        
        If *this\vertical
          If *this\text\rotate = 90
            *this\text\x = *this\x+(*this\width-*this\text\height)/2
            *this\text\y = *this\y+(*this\height+*this\text\width)/2
          ElseIf *this\text\rotate = 270
            *this\text\x = *this\x+(*this\width+*this\text\height)/2  + Bool(#PB_Compiler_OS = #PB_OS_MacOS)*1
            *this\text\y = *this\y+(*this\height-*this\text\width)/2
          EndIf
        Else
          *this\text\x = *this\x+(*this\width-*this\text\width)/2
          *this\text\y = *this\y+(*this\height-*this\text\height)/2
        EndIf
      EndIf
      
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color[3]\frame)
    EndIf
    
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._S_bar)
    Protected Pos, Size, Radius.d = 2
    
    With *this
      If *this > 0
        DrawingMode(#PB_2DDrawing_Outlined)
        If \mode
          Protected *first._S_bar = \splitter\first
          Protected *second._S_bar = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Color[3]\frame[\color[#_b_1]\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Color[3]\frame[\color[#_b_2]\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \Thumb\len/2
          Pos = \Thumb\Pos+Size
          
          If \Vertical ; horisontal
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2-((Radius*2+2)*2+2)), Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2-(Radius*2+2)),       Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2),                    Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2+(Radius*2+2)),       Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2+((Radius*2+2)*2+2)), Pos,Radius,\Color[#_b_3]\Frame[#Selected])
          Else
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2-((Radius*2+2)*2+2)),Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2-(Radius*2+2)),      Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2),                   Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2+(Radius*2+2)),      Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2+((Radius*2+2)*2+2)),Radius,\Color[#_b_3]\Frame[#Selected])
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw(*this._S_bar)
    With *this
      If \text And \text\fontID 
        DrawingFont(\text\fontID)
      EndIf
      
      Select \type
        Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
        Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
        Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
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
  Procedure.i SetPos(*this._S_bar, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _set_area_coordinate_(*this)
      EndIf
      
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If \thumb\end <> ThumbPos 
        \thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \area\end <> ThumbPos
          ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical
          ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._S_bar, ScrollPos.l)
    Protected Result.b
    
    With *this
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      ;       If ScrollPos > \page\end 
      ;         ScrollPos = \page\end 
      ;         Debug \page\end
      ;       EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
      EndIf
      
      If \page\pos <> ScrollPos
        \change = \page\pos - ScrollPos
        
        If \type = #PB_GadgetType_TrackBar Or 
           \type = #PB_GadgetType_ProgressBar
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        Else
          If \page\pos > ScrollPos
            If \inverted
              \direction = _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, ScrollPos, \inverted))
        
        If \splitter And \splitter\fixed = #_b_1
          \splitter\fixed[\splitter\fixed] = \thumb\pos - \area\pos
          \page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #_b_2
          \splitter\fixed[\splitter\fixed] = \area\len - ((\thumb\pos+\thumb\len)-\area\pos)
          \page\pos = \max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._S_bar, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize : Attribute = #PB_Bar_FirstMinimumSize
          Case #PB_Splitter_SecondMinimumSize : Attribute = #PB_Bar_SecondMinimumSize
        EndSelect
      EndIf
      
      Select Attribute
        Case #PB_Bar_ScrollStep 
          \scrollstep = Value
          
        Case #PB_Bar_FirstMinimumSize
          \button[#_b_1]\len = Value
          Result = Bool(\max)
          
        Case #PB_Bar_SecondMinimumSize
          \button[#_b_2]\len = Value
          Result = Bool(\max)
          
        Case #PB_Bar_NoButtons
          If \button\len <> Value
            \button\len = Value
            \button[#_b_1]\len = Value
            \button[#_b_2]\len = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Inverted
          If \inverted <> Bool(Value)
            \inverted = Bool(Value)
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          EndIf
          
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
            If Value > (\max-\min) 
              \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
      
      If Result
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
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
    With *this
      If X <> #PB_Ignore : \X = X : EndIf 
      If Y <> #PB_Ignore : \Y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \Height = height : EndIf
      
      ;
      If (\max-\min) >= \page\len
        ; Get area screen coordinate pos (x&y) and len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \max And \width And \height
          \max = \area\len-\button\len
          
          If Not \page\pos
            \page\pos = \max/2
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #_b_1
          ;             \splitter\fixed[\splitter\fixed] = \page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #_b_2
          ;             \splitter\fixed[\splitter\fixed] = \area\len-\page\pos-\button\len
          ;           EndIf
        EndIf
        
        ;
        If \splitter 
          If \splitter\fixed
            If \area\len - \button\len > \splitter\fixed[\splitter\fixed] 
              \page\pos = Bool(\splitter\fixed = 2) * \max
              
              If \splitter\fixed[\splitter\fixed] > \button\len
                \area\pos + \splitter\fixed[1]
                \area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \area\len - \button\len
              \page\pos = Bool(\splitter\fixed = 1) * \max
            EndIf
          EndIf
          
          ; Debug ""+\area\len +" "+ Str(\button[#_b_1]\len + \button[#_b_2]\len)
          
          If \area\len =< \button\len
            \page\pos = \max/2
            
            If \Vertical
              \area\pos = \Y 
              \area\len = \Height
            Else
              \area\pos = \X
              \area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \area\len > \button\len
          \thumb\len = Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest)
          
          If \thumb\len > \area\len 
            \thumb\len = \area\len 
          EndIf 
          
          If \thumb\len > \button\len
            \area\end = \area\pos + (\area\len-\thumb\len)
          Else
            \area\len = \area\len - (\button\len-\thumb\len)
            \area\end = \area\pos + (\area\len-\thumb\len)                              
            \thumb\len = \button\len
          EndIf
          
        Else
          If \splitter
            \thumb\len = \width
          Else
            \thumb\len = 0
          EndIf
          
          If \Vertical
            \area\pos = \Y
            \area\len = \Height
          Else
            \area\pos = \X
            \area\len = \width 
          EndIf
          
          \area\end = \area\pos + (\area\len - \thumb\len)
        EndIf
        
        \page\end = \max - \page\len
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
        
        If \thumb\pos = \area\end And \type = #PB_GadgetType_ScrollBar
          ; Debug " line-" + #PB_Compiler_Line +" "+  \type 
          SetState(*this, \max)
        EndIf
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
      
      ;       If -\v\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      ;       If -\h\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      If -\v\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\Page\Pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\page\pos > ScrollArea_X And ScrollArea_X<>\h\Page\Pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      *Scroll\Y =- \v\Page\Pos
      *Scroll\X =- \h\Page\Pos
      *Scroll\width = \v\Max
      *Scroll\height = \h\Max
      
      
      
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
  Macro _bar_(_this_, _min_, _max_, _page_length_, _flag_, _radius_=0)
    *event\widget = _this_
    _this_\scrollstep = 1
    _this_\radius = _radius_
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\color[#_b_1] = def_colors
    _this_\color[#_b_2] = def_colors
    _this_\color[#_b_3] = def_colors
    
    _this_\vertical = Bool(_flag_&#PB_Bar_Vertical=#PB_Bar_Vertical)
    _this_\inverted = Bool(_flag_&#PB_Bar_Inverted=#PB_Bar_Inverted)
    
    If _this_\min <> _min_ : SetAttribute(_this_, #PB_Bar_Minimum, _min_) : EndIf
    If _this_\max <> _max_ : SetAttribute(_this_, #PB_Bar_Maximum, _max_) : EndIf
    If _this_\page\len <> _page_length_ : SetAttribute(_this_, #PB_Bar_PageLength, _page_length_) : EndIf
  EndMacro
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, PageLength, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      \button[#_b_1]\arrow_type = 1
      \button[#_b_2]\arrow_type = 1
      \button[#_b_1]\arrow_size = 6
      \button[#_b_2]\arrow_size = 6
      ;\interact = 1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      \from =- 1
      
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
        
        \button[#_b_1]\len = \button\len
        \button[#_b_2]\len = \button\len
      EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_TrackBar
      \inverted = \vertical
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks) * #PB_Bar_Ticks
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      \button\len = 15
      \button[#_b_1]\len = 1
      \button[#_b_2]\len = 1
      
      \button[#_b_3]\interact = 1
      \button[#_b_3]\arrow_size = 6
      \button[#_b_3]\arrow_type = 0
      
      \cursor = #PB_Cursor_Hand
      \from =- 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ProgressBar
      \inverted = \vertical
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      
      \button[#_b_3]\interact = 1
      \text = AllocateStructure(_S_text)
      \text\change = 1
      \text\rotate = \vertical * 90 ; 270
      
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        \text\fontID = GetGadgetFont(#PB_Default)
      CompilerEndIf
      \from =- 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, 0, 0, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_Splitter
      \vertical ! 1 ; = Bool(Flag&#PB_Splitter_Vertical=0)
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If \vertical
        \cursor = #PB_Cursor_UpDown
      Else
        \cursor = #PB_Cursor_LeftRight
      EndIf
      
      \Splitter = AllocateStructure(_S_splitter)
      \Splitter\first = First
      \Splitter\second = Second
      \splitter\g_first = IsGadget(First)
      \splitter\g_second = IsGadget(Second)
      \button[#_b_3]\interact = 1
      \from =- 1
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      If Bool(Flag&#PB_Splitter_Separator)
        \mode = #PB_Splitter_Separator
        \button\len = 7
      Else
        \mode = 1
        \button\len = 3
      EndIf
      
      ;\thumb\len=\button\len
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._S_bar, item.l=#PB_All, *data=0)
    If *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\callback()
      ;EndIf
    EndIf
  EndProcedure
  
  Procedure.b Bind(*callBack, *this._S_bar, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  
  Procedure.b CallBack(*this._S_bar, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._S_bar, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave
          ;If _this_\from = 3
          Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          ;EndIf
          _this_\color[_this_\from]\state = #Normal 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          Result = #True
          
        Case #PB_EventType_MouseEnter
          ;If _this_\from = 3
          Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          ;EndIf
          _this_\color[_this_\from]\state = #Entered 
          
          ; Set splitter cursor
          If _this_\from = #_b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          Result = #True
          
        Case #PB_EventType_LeftButtonDown
          ; Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          Select _this_\from
            Case 1 
              If _this_\inverted
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 2 
              If _this_\inverted
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 3 
              LastX = MouseX - _this_\thumb\pos 
              LastY = MouseY - _this_\thumb\pos
              
            Default
              Result = #True
              
          EndSelect
          
          _this_\color[_this_\from]\state = #Selected
          
        Case #PB_EventType_LeftButtonUp
          ; Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          Result = #True
          
      EndSelect
    EndMacro
    
    With *this
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #_b_3
        If \splitter\first And Not \splitter\g_first
          If CallBack(\splitter\first, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack(\splitter\second, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Not \hide And ((Mousex>=\x And Mousex=<\x+\width And Mousey>\y And Mousey=<\y+\height) Or Down)
        If \button 
          If \button[#_b_3]\len And (MouseX>\button[#_b_3]\x And MouseX=<\button[#_b_3]\x+\button[#_b_3]\width And 
                                     MouseY>\button[#_b_3]\y And MouseY=<\button[#_b_3]\y+\button[#_b_3]\height)
            from = #_b_3
          ElseIf \button[#_b_2]\len And (MouseX>\button[#_b_2]\x And MouseX=<\button[#_b_2]\x+\button[#_b_2]\width And 
                                         MouseY>\button[#_b_2]\y And MouseY=<\button[#_b_2]\y+\button[#_b_2]\height)
            from = #_b_2
          ElseIf \button[#_b_1]\len And (MouseX>\button[#_b_1]\x And MouseX=<\button[#_b_1]\x+\button[#_b_1]\width And 
                                         MouseY>\button[#_b_1]\y And MouseY=<\button[#_b_1]\y+\button[#_b_1]\height)
            from = #_b_1
          ElseIf (MouseX>\button\x And MouseX=<\button\x+\button\width And 
                  MouseY>\button\y And MouseY=<\button\y+\button\height)
            from = 0
          EndIf
          
          If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
            Select from
              Case #_b_1, #_b_2
                from = 0
                
            EndSelect
            ; ElseIf \type = #PB_GadgetType_ProgressBar
            ;  
          EndIf
        Else
          from = 0
        EndIf 
        
      Else
        If \from >= 0 ;And \button[\from]\interact
          If EventType = #PB_EventType_LeftButtonUp
            _callback_(*this, #PB_EventType_LeftButtonUp)
          EndIf
          
          Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
          _callback_(*this, #PB_EventType_MouseLeave)
        EndIf 
        
        \from =- 1
        
      EndIf
      
      If from > 0
        If \from <> from And Not Down
          If *leave > 0 And *leave\from >= 0
            If *leave\button[*leave\from]\interact And Not (MouseX>*leave\button[*leave\from]\x And MouseX=<*leave\button[*leave\from]\x+*leave\button[*leave\from]\width And 
                    MouseY>*leave\button[*leave\from]\y And MouseY=<*leave\button[*leave\from]\y+*leave\button[*leave\from]\height)
              
              _callback_(*leave, #PB_EventType_MouseLeave)
                *leave\from = 0
            EndIf
          EndIf
          
          \from = from
          *leave = *this
          
          If \from >= 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_MouseEnter)
          EndIf
        EndIf
        
      Else
        If \from >= 0 And \button[\from]\interact
          ; Debug ""+#PB_Compiler_Line +" Мышь перешел с итем"
          _callback_(*this, #PB_EventType_MouseLeave)
        EndIf 
        
        \from =- 1
        If *leave = *this
          *leave = 0
        EndIf
      EndIf
      
      
      ; get
      Select EventType
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp 
          Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If Not from >= 0
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If from = 0 And \button[#_b_3]\interact 
            If \Vertical
              Result = SetPos(*this, (MouseY-\thumb\len/2))
            Else
              Result = SetPos(*this, (MouseX-\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from >= 0
            Down = 1
            \from = from 
            *leave = *this
            
            If \button[from]\interact
              _callback_(*this, #PB_EventType_LeftButtonDown)
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down
            
            If *leave = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = SetPos(*this, (MouseY-LastY))
              Else
                Result = SetPos(*this, (MouseX-LastX))
              EndIf
            EndIf
            
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  Global g_Canvas, NewList *List._S_bar()
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    
    ForEach *List()
      If *List()\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    ForEach *List()
      If Not *List()\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure v_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(2, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(12, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(22, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_4, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure h_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(1, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(11, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(21, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_3, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
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
    ;     Protected *this._S_bar = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | CallBack(*List(), EventType, MouseX, MouseY)
      
      If *List()\change
        
        If *List()\vertical
          v_CallBack(*List()\page\pos, *List()\type)
        Else
          h_CallBack(*List()\page\pos, *List()\type)
        EndIf
        
        *List()\change = 0
      EndIf
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ev()
    Debug ""+Widget() +" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g_Canvas = CanvasGadget(-1, 0, 0, 605, 140+200+140+140, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    TextGadget       (-1,  10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (1,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (2, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    ;ScrollBarGadget  (2, 270, 10,  25, 100 ,0, 521, 96, #PB_ScrollBar_Vertical)
    SetGadgetState   (2, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    TextGadget       (-1,  300+10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical);|#PB_Bar_Inverted)
                                                                                                       ;AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 100 ,0, 521, 96, #PB_ScrollBar_Vertical)
    SetState   (Widget(), 100)                                                                         ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(2,@v_GadgetCallBack())
    Bind(@ev(), Widget())
    
    
    ; example_2
    TextGadget    (-1, 10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(10, 10,  140+40, 250, 20, 0, 10000)
    SetGadgetState(10, 5000)
    TextGadget    (-1, 10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     TrackBarGadget(11, 10, 140+120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
    TrackBarGadget(11, 10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetGadgetState(11, 60)
    TextGadget    (-1,  60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(12, 270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(12, 8000)
    
    
    TextGadget    (-1, 300+10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    AddElement(*List()) : *List() = Track(300+10,  140+40, 250, 20, 0, 10000, 0)
    SetState(Widget(), 5000)
    TextGadget    (-1, 300+10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 0, 30, #PB_Bar_Ticks)
    AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 30, 60, #PB_Bar_Ticks)
    SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    AddElement(*List()) : *List() = Track(300+270, 140+10, 25, 170, 0, 10000, #PB_Bar_Vertical)
    SetState(Widget(), 8000)
    
    BindGadgetEvent(11,@h_GadgetCallBack())
    BindGadgetEvent(12,@v_GadgetCallBack())
    
    ;
    ; example_3
    TextGadget       (-1,  10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    ProgressBarGadget  (21,  10, 140+200+42, 250,  20, 30, 100)
    SetGadgetState   (21,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ProgressBarGadget  (22, 270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState   (22, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    TextGadget       (-1,  300+10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Progress  (300+10, 140+200+42, 250,  20, 30, 100, 0)
    SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Progress  (300+270, 140+200,  25, 120 ,0, 300, #PB_Bar_Vertical)
    SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(21,@h_GadgetCallBack())
    BindGadgetEvent(22,@v_GadgetCallBack())
    
    
    ; example_4
    ;     TextGadget       (-1,  10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     ScrollBarGadget(100, 0, 0, 0, 0, 30,71, 0) ; No need to specify size or coordinates
    ;     ProgressBarGadget(200, 0, 0, 0, 0, 30,100) ; as they will be sized automatically
    ;     SetGadgetState   (100, 30)
    ;     SetGadgetState   (200, 50)
    ;     SplitterGadget  (31,  10, 140+200+140+42, 230,  60, 100, 200, #PB_Splitter_Vertical)
    ;     SetGadgetState   (31,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     TextGadget       (-1,  10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     TrackBarGadget(300, 0, 0, 250,  20, 30, 100) ; No need to specify size or coordinates
    ;     ProgressBarGadget(400, 0, 0, 0, 0, 30,100)   ; as they will be sized automatically
    ;     SetGadgetState   (300, 30)
    ;     SetGadgetState   (400, 50)
    ;     SplitterGadget  (32, 250, 140+200+140+10,  45, 120 ,300, 400, 0)
    ;     SetGadgetState   (32, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ;     TextGadget       (-1,  300+10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     *b1 = Splitter  (0, 0, 0, 0, 0, 0, #PB_Splitter_Vertical|#PB_Splitter_Separator);|#PB_Splitter_FirstFixed)
    ;     *b2 = Progress  (0, 0, 0, 0, 30, 100, 0)
    ;     ;SetState   (*b1, 30) 
    ;     SetState   (*b2, 50) 
    ;     AddElement(*List()) : *List() = *b1
    ;     AddElement(*List()) : *List() = *b2
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+10, 140+200+140+42, 230,  60, *b1, *b2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;     SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     SetAttribute(Widget(), #PB_Bar_FirstMinimumSize, 20)
    ;     SetAttribute(Widget(), #PB_Bar_SecondMinimumSize, 20)
    ;     TextGadget       (-1,  300+10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     
    ;     *b3 = Track  (0, 0, 0, 0, 30, 60)
    ;     *b4 = Progress  (0, 0, 0, 0, 30, 100)
    ;     SetState   (*b3, 30) 
    ;     SetState   (*b4, 50) 
    ;     AddElement(*List()) : *List() = *b3
    ;     AddElement(*List()) : *List() = *b4
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+250, 140+200+140+10,  45, 120 ,*b3, *b4, #PB_Splitter_Separator)
    ;     ;SetState   (*List(), 40)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    ;     
    ;     BindGadgetEvent(31,@h_GadgetCallBack())
    ;     BindGadgetEvent(32,@v_GadgetCallBack())
    ;     
    ;     Post(333, Widget())
    ;     Bind(@ev2(), Widget(), #PB_EventType_StatusChange)
    
    
    
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;     ;SetGadgetState(Splitter_1, 20)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    
    Button_0 = Bar::Progress(0, 0, 0, 0, 0,100) ; No need to specify size or coordinates
    Button_1 = Bar::Progress(0, 0, 0, 0, 10,100); No need to specify size or coordinates
    Button_2 = Bar::Progress(0, 0, 0, 0, 20,100); as they will be sized automatically
    Button_3 = Bar::Progress(0, 0, 0, 0, 30,100); as they will be sized automatically
    Button_4 = Bar::Progress(0, 0, 0, 0, 40,100); as they will be sized automatically
    Button_5 = Bar::Progress(0, 0, 0, 0, 50,100); as they will be sized automatically
    
    Splitter_0 = Bar::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Bar::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;SetState(Splitter_1, 410/2-20)
    Splitter_2 = Bar::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Bar::Splitter(300+10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    
    AddElement(*List()) : *List() = Button_0
    AddElement(*List()) : *List() = Button_1
    AddElement(*List()) : *List() = Button_2
    AddElement(*List()) : *List() = Button_3
    AddElement(*List()) : *List() = Button_4
    AddElement(*List()) : *List() = Button_5
    
    AddElement(*List()) : *List() = Splitter_0
    *List()\focus = 10
    AddElement(*List()) : *List() = Splitter_1
    *List()\focus = 11
    AddElement(*List()) : *List() = Splitter_2
    AddElement(*List()) : *List() = Splitter_3
    AddElement(*List()) : *List() = Splitter_4
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---------------------------------8---7-----
; EnableXP