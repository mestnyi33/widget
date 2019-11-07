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
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ;color state
  Enumeration
    #__s_0
    #__s_1
    #__s_2
    #__s_3
  EndEnumeration
  
  ;bar buttons
  Enumeration
    #__b_0 = 0
    #__b_1 = 1
    #__b_2 = 2
    #__b_3 = 3
  EndEnumeration
  
  Enumeration 1
    #__Color_Front
    #__Color_Back
    #__Color_Line
    #__Color_TitleFront
    #__Color_TitleBack
    #__Color_GrayText 
    #__Color_Frame
  EndEnumeration
  
  #__bar_Minimum = 1
  #__bar_Maximum = 2
  #__bar_PageLength = 3
  
  EnumerationBinary 16
    #__bar_Vertical
    
    ;#__bar_ArrowSize 
    #__bar_ButtonSize 
    #__bar_ScrollStep
    #__bar_Direction 
    #__bar_Inverted 
    #__bar_Ticks
  EndEnumeration
  Prototype pFunc()
  
  ;- STRUCTUREs
  ;- - _S_point
  Structure _S_point
    y.l
    x.l
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
  
  ;- - _S_align
  Structure _S_align 
    width.l
    height.l
    
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    pos.f
    len.l
    *end
  EndStructure
  
  ;- - _S_arrow
  Structure _S_arrow
    size.a
    type.b
    direction.b
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    hide.b
    round.a
    interact.b
    arrow._S_arrow
    color._s_color
  EndStructure
  
  ;- - _S_scroll
  Structure _S_scroll Extends _S_coordinate
    *v._s_widget
    *h._s_widget
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._s_widget
    *second;._s_widget
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_text
  Structure _S_text Extends _S_coordinate
    fontID.i
    string.s
    change.b
    rotate.f
    
    padding.b
    align._S_align
  EndStructure
  
  ;- - _s_bar
  Structure _S_bar ;Extends _S_coordinate
    max.l
    min.l
    type.l
    hide.b
    change.l
    vertical.b
    inverted.b
    direction.l
    scrollstep.f
    page._S_page
    area._S_page
    thumb._S_page
    button._S_button[4] 
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget Extends _S_coordinate
    *root._S_widget
    *parent._S_widget
    *window._S_widget
    
    bar._S_bar
    __width.l
    ;type.l
    from.l
    focus.l
    round.l
    
    mode.l
    change.b 
    cursor.l
    hide.b
    
    color._S_color
    
    *text._S_text
    *event._S_event 
    *splitter._S_splitter
  EndStructure
  
  ;- - _S_event
  Structure _S_event
    *widget._s_widget
    type.l
    item.l
    *data
    *callback.pFunc
    *active._s_widget
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
  
  Declare.f GetState(*this)
  Declare.i GetAttribute(*this, Attribute.i)
  
  Declare.b SetState(*this, ScrollPos.f)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  Declare.b SetColor(*this, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, round.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, round.l=0)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, round.l=7)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Increment.f=1, Round.l=7)
  
  Declare.b Update(*this)
  Declare.b ChangePos(*bar, ScrollPos.f)
  Declare.b UpdatePos(*this, position.l, size.l)
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
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
EndDeclareModule

;- >>> MODULE
Module Bar
  ;- GLOBALs
  Global def_colors._S_color
  Global *event\active._s_widget
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#__s_0] = $80000000
    \fore[#__s_0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#__s_0] = $FFE2E2E2 ; $80E2E2E2
    \frame[#__s_0] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#__s_1] = $80000000
    \fore[#__s_1] = $FFEAEAEA ; $FFFAF8F8
    \back[#__s_1] = $FFCECECE ; $80FCEADA
    \frame[#__s_1] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#__s_2] = $FFFEFEFE
    \fore[#__s_2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#__s_2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#__s_2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#__s_3] = $FFBABABA
    \fore[#__s_3] = $FFF6F6F6 
    \back[#__s_3] = $FFE2E2E2 
    \frame[#__s_3] = $FFBABABA
    
  EndWith
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _bar_thumb_pos_(_bar_, _scroll_pos_)
    (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * (_bar_\area\len / (_bar_\max-_bar_\min)), #PB_Round_Nearest)) 
  EndMacro
  
  Macro _bar_thumb_len_(_bar_)
    Round(_bar_\area\len - (_bar_\area\len / (_bar_\max-_bar_\min)) * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro _bar_in_start_(_bar_) 
    Bool(_bar_\page\pos =< _bar_\min) 
  EndMacro
  
  ; Then scroll bar end position
  Macro _bar_in_stop_(_bar_) 
    Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) 
  EndMacro
  
  ; Inverted scroll bar position
  Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _bar_pos_(_this_, _scroll_pos_)
    _bar_thumb_pos_(_this_\bar, _scroll_pos_)
    
    If _this_\bar\thumb\pos < _this_\bar\area\pos 
      _this_\bar\thumb\pos = _this_\bar\area\pos 
    EndIf 
    
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
    
    If _this_\bar\type=#PB_GadgetType_Spin
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + _this_\width - 15
        _this_\bar\button\width = 15
      Else 
        _this_\bar\button\y = _this_\Y + _this_\Height - 15 
        _this_\bar\button\height = 15 
      EndIf
    Else
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\y = _this_\bar\area\pos
        _this_\bar\button\width = _this_\width - Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\height = _this_\bar\area\len               
      Else 
        _this_\bar\button\x = _this_\bar\area\pos
        _this_\bar\button\y = _this_\Y + Bool(_this_\bar\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\width = _this_\bar\area\len
        _this_\bar\button\height = _this_\Height - Bool(_this_\bar\type=#PB_GadgetType_ScrollBar)  
      EndIf
    EndIf
    
    ; _start_
    If _this_\bar\button[#__b_1]\len 
      If _scroll_pos_ = _this_\bar\min
        _this_\bar\button[#__b_1]\color\state = #__s_3
        _this_\bar\button[#__b_1]\interact = 0
      Else
        If _this_\bar\button[#__b_1]\color\state <> #__s_2
          _this_\bar\button[#__b_1]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type=#PB_GadgetType_ScrollBar Or 
       _this_\bar\type=#PB_GadgetType_Spin
      
      If _this_\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\bar\button[#__b_1]\x = _this_\bar\button\x
        _this_\bar\button[#__b_1]\y = _this_\Y 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\width
        _this_\bar\button[#__b_1]\height = _this_\bar\button[#__b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_1]\x = _this_\X 
        _this_\bar\button[#__b_1]\y = _this_\bar\button\y
        _this_\bar\button[#__b_1]\width = _this_\bar\button[#__b_1]\len 
        _this_\bar\button[#__b_1]\height = _this_\bar\button\height 
      EndIf
    Else
      _this_\bar\button[#__b_1]\x = _this_\X
      _this_\bar\button[#__b_1]\y = _this_\Y
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_1]\width = _this_\width
        _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y
      Else
        _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x
        _this_\bar\button[#__b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\bar\button[#__b_2]\len
      ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
      If _scroll_pos_ = _this_\bar\page\end
        _this_\bar\button[#__b_2]\color\state = #__s_3
        _this_\bar\button[#__b_2]\interact = 0
      Else
        If _this_\bar\button[#__b_2]\color\state <> #__s_2
          _this_\bar\button[#__b_2]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type = #PB_GadgetType_ScrollBar Or 
       _this_\bar\type=#PB_GadgetType_Spin
      If _this_\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\bar\button[#__b_2]\x = _this_\bar\button\x
        _this_\bar\button[#__b_2]\width = _this_\bar\button\width
        _this_\bar\button[#__b_2]\height = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#__b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_2]\y = _this_\bar\button\y
        _this_\bar\button[#__b_2]\height = _this_\bar\button\height
        _this_\bar\button[#__b_2]\width = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\x = _this_\X+_this_\width-_this_\bar\button[#__b_2]\width 
      EndIf
      
    Else
      If _this_\bar\vertical
        _this_\bar\button[#__b_2]\x = _this_\x
        _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\width = _this_\width
        _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
      Else
        _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\y = _this_\Y
        _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
        _this_\bar\button[#__b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\bar\thumb\len
      ;       If _this_\bar\button[#__b_3]\len <> _this_\bar\thumb\len
      ;         _this_\bar\button[#__b_3]\len = _this_\bar\thumb\len
      ;       EndIf
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_3]\x = _this_\bar\button\x 
        _this_\bar\button[#__b_3]\width = _this_\bar\button\width 
        _this_\bar\button[#__b_3]\y = _this_\bar\thumb\pos
        _this_\bar\button[#__b_3]\height = _this_\bar\thumb\len                              
      Else
        _this_\bar\button[#__b_3]\y = _this_\bar\button\y 
        _this_\bar\button[#__b_3]\height = _this_\bar\button\height
        _this_\bar\button[#__b_3]\x = _this_\bar\thumb\pos 
        _this_\bar\button[#__b_3]\width = _this_\bar\thumb\len                                  
      EndIf
      
    Else
      If _this_\bar\type = #PB_GadgetType_Spin Or 
         _this_\bar\type = #PB_GadgetType_ScrollBar
        ; Эфект спин гаджета
        If _this_\bar\vertical
          _this_\bar\button[#__b_2]\Height = _this_\Height/2 
          _this_\bar\button[#__b_2]\y = _this_\y+_this_\bar\button[#__b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\bar\button[#__b_1]\y = _this_\y 
          _this_\bar\button[#__b_1]\Height = _this_\Height/2 ; + Bool(_this_\Height%2); -_this_\bar\button[#__b_3]\len
          
        Else
          _this_\bar\button[#__b_2]\width = _this_\width/2 
          _this_\bar\button[#__b_2]\x = _this_\x+_this_\bar\button[#__b_2]\width+Bool(_this_\width%2) 
          
          _this_\bar\button[#__b_1]\x = _this_\x 
          _this_\bar\button[#__b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\bar\type = #PB_GadgetType_Spin
      If _this_\bar\vertical      
        ; Top button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y+_this_\height/2 + Bool(_this_\height%2) 
        _this_\bar\button[#__b_2]\height = _this_\height/2 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len
        
        ; Bottom button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height/2 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len                                 
      Else    
        ; Left button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len    
        
        ; Right button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y 
        _this_\bar\button[#__b_2]\height = _this_\height 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len/2                               
      EndIf
    EndIf
    
    If _this_\text
      _this_\text\change = 1
    EndIf
    
    If _this_\Splitter 
      ; Splitter childrens auto resize       
      _bar_size_splitter_(_this_)
      ;_bar_splitter_size_(_this_)
    EndIf
    If _this_\bar\change
      
      ;       ; ScrollArea childrens auto resize 
      ;       If _this_\parent\scroll
      ;         _this_\parent\change =- 1
      ;         
      ;         If _this_\bar\vertical
      ;           _this_\parent\scroll\y =- _this_\bar\page\pos 
      ;           _childrens_move_(_this_\parent, 0, _this_\bar\change)
      ;         Else
      ;           _this_\parent\scroll\x =- _this_\bar\page\pos
      ;           _childrens_move_(_this_\parent, _this_\bar\change, 0)
      ;         EndIf
      ;       EndIf
      
      ; bar change
      Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\bar\direction)
    EndIf
    
  EndMacro
  
  Macro _bar_area_pos_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#__b_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
    Else
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#__b_1]\len
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len-_this_\bar\thumb\len)
  EndMacro
  
  Macro _bar_size_splitter_(_this_)
    If _this_\splitter
      If _this_\splitter\first
        If _this_\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, (_this_\bar\button[#__b_2]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          Else
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          EndIf
        Else
          Resize(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
        EndIf
      EndIf
      
      If _this_\splitter\second
        If _this_\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, (_this_\bar\button[#__b_1]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          Else
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          EndIf
        Else
          Resize(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndMacro
  
  Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
    If _this_\text\rotate = 0
      If _this_\text\align\horizontal
        _this_\text\x = _x_+(_width_-_this_\text\align\width -_this_\text\width)/2
      ElseIf _this_\text\align\right
        _this_\text\x = _x_+_width_-_this_\text\align\width -_this_\text\width - _this_\text\padding
      Else
        _this_\text\x = _x_ + _this_\text\padding
      EndIf
      
      If _this_\text\align\vertical
        _this_\text\y = _y_+(_height_-_this_\text\height)/2
      ElseIf _this_\text\align\bottom
        _this_\text\y = _y_+_height_-_this_\text\height
      Else
        _this_\text\y = _y_
      EndIf
      
    ElseIf _this_\text\rotate = 90
      ;         _this_\text\x = _x_+(_width_-_this_\text\height)/2
      ;         _this_\text\y = _y_+(_height_+_this_\text\width)/2
      If _this_\text\align\horizontal
        _this_\text\x = _x_+(_width_-_this_\text\height)/2
      ElseIf _this_\text\align\right
        _this_\text\x = _x_+(_width_-_this_\text\height) - _this_\text\padding
      Else
        _this_\text\x = _x_ + _this_\text\padding
      EndIf
      
      If _this_\text\align\vertical
        _this_\text\y = _y_+(_height_+_this_\text\align\height+_this_\text\width)/2
      ElseIf _this_\text\align\bottom
        _this_\text\y = _y_+(_height_+_this_\text\align\height+_this_\text\width) - _this_\text\padding
      Else
        _this_\text\y = _y_ + _this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 270
      _this_\text\x = _x_+(_width_+_this_\text\height)/2  + Bool(#PB_Compiler_OS = #PB_OS_MacOS)*1
      _this_\text\y = _y_+(_height_-_this_\text\width)/2
    EndIf
  EndMacro
  
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
  
  Procedure.b Draw_Spin(*this._s_widget)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        RoundBox(\bar\button\X,\Y,\bar\button\width,\height,\round,\round,\bar\button[#__b_3]\Color\Back&$FFFFFF|\color\alpha<<24)
        Box(\bar\button\X,\Y,\bar\button\width/2,\height,\bar\button[#__b_3]\Color\Back&$FFFFFF|\color\alpha<<24)
        Line( \bar\button\X, \y, 1, \height, \bar\button[#__b_3]\color\frame&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
        
        If \bar\button[#__b_1]\len Or \bar\button[#__b_1]\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\Color\fore[\bar\button[#__b_1]\Color\state],\bar\button[#__b_1]\Color\Back[\bar\button[#__b_1]\Color\state], \round, \color\alpha)
          _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\Color\fore[\bar\button[#__b_2]\Color\state],\bar\button[#__b_2]\Color\Back[\bar\button[#__b_2]\Color\state], \round, \color\alpha)
          
          If Not \bar\vertical
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\round,\round,\bar\button[#__b_1]\Color\frame[\bar\button[#__b_1]\Color\state]&$FFFFFF|\color\alpha<<24)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\round,\round,\bar\button[#__b_2]\Color\frame[\bar\button[#__b_2]\Color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\Color\front[\bar\button[#__b_1]\Color\state]&$FFFFFF|\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
          Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2-Bool(\bar\vertical)*2, \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\Color\front[\bar\button[#__b_2]\Color\state]&$FFFFFF|\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
        EndIf
        
        ; Text
        If *this\text
          If *this\text\change 
            *this\text\change = 0
            Protected i
            
            ;*this\bar\scrollstep = 1.19
            For i=0 To 3
              If *this\bar\scrollstep = ValF(StrF(*this\bar\scrollstep, i))
                *this\text\string = StrF(*this\bar\page\Pos, i)
                Break
              EndIf
            Next
            
            ;*this\text\string = StrF(*this\bar\page\Pos, Len(text))
            *this\text\width = TextWidth(*this\text\string)
            *this\text\height = TextHeight("A")
            
            _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
          EndIf
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button\color\frame)
        EndIf
        
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\width,\height,\round,\round,\bar\button[#__b_1]\Color\frame&$FFFFFF|\color\alpha<<24)
        
        If \bar\vertical
          Line( \bar\button[#__b_1]\X, \y, 1, \height, \bar\button[#__b_1]\color\frame&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Line( \bar\button[#__b_1]\X, \bar\button[#__b_2]\y-1, \bar\button[#__b_1]\width, 1, \bar\button[#__b_1]\color\frame&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_Scroll(*this._s_widget)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \bar\vertical
          If (\bar\page\len+Bool(\round)*(\width/4)) = \height
            Line( \x, \y, 1, \bar\page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        Else
          If (\bar\page\len+Bool(\round)*(\height/4)) = \width
            Line( \x, \y, \bar\page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        EndIf
        
        If \bar\thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                         \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \round, \bar\button[#__b_3]\color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\round,\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
          
          Protected h=5
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \bar\vertical
            Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-h)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2-3,h,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-h)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,h,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-h)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2+3,h,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2-3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-h)/2,1,h,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-h)/2,1,h,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2+3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-h)/2,1,h,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \bar\button[#__b_1]\len Or \bar\button[#__b_1]\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                         \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \round, \bar\button[#__b_1]\color\alpha)
          
          _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                         \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \round, \bar\button[#__b_2]\color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\round,\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\round,\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, 
                \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
          
          Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2, 
                \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_Track(*this._s_widget)
    With *This
      
      If Not \Hide
        Protected _pos_ = 6, _size_ = 4
        
        If \Color\Back <>- 1
          DrawingMode(#PB_2DDrawing_Default)
          Box(\X,\Y,\Width,\Height,\Color\Back)
        EndIf
        
        If \bar\vertical
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\bar\vertical, \X+_pos_,\bar\thumb\pos+\bar\thumb\len-\bar\button[#__b_2]\len,_size_,\Height-(\bar\thumb\pos+\bar\thumb\len-\y),\bar\button[#__b_2]\color\fore[#__s_2],\bar\button[#__b_2]\color\back[#__s_2], Bool(\round))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\bar\thumb\pos+\bar\thumb\len-\bar\button[#__b_2]\len,_size_,\Height-(\bar\thumb\pos+\bar\thumb\len-\y),Bool(\round),Bool(\round),\bar\button[#__b_2]\color\frame[#__s_2])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\bar\vertical, \X+_pos_,\Y+\bar\button[#__b_1]\len,_size_,\bar\thumb\pos-\y,\bar\button[#__b_1]\color\fore[#__s_0],\bar\button[#__b_1]\color\back[#__s_0], Bool(\round))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\Y+\bar\button[#__b_1]\len,_size_,\bar\thumb\pos-\y,Bool(\round),Bool(\round),\bar\button[#__b_1]\color\frame[#__s_0])
          
        Else
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\bar\vertical, \X+\bar\button[#__b_1]\len,\Y+_pos_,\bar\thumb\pos-\x,_size_,\bar\button[#__b_1]\color\fore[#__s_2],\bar\button[#__b_1]\color\back[#__s_2], Bool(\round))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+\bar\button[#__b_1]\len,\Y+_pos_,\bar\thumb\pos-\x,_size_,Bool(\round),Bool(\round),\bar\button[#__b_1]\color\frame[#__s_2])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\bar\vertical, \bar\thumb\pos+\bar\thumb\len-\bar\button[#__b_2]\len,\Y+_pos_,\Width-(\bar\thumb\pos+\bar\thumb\len-\x),_size_,\bar\button[#__b_2]\color\fore[#__s_0],\bar\button[#__b_2]\color\back[#__s_0], Bool(\round))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\bar\thumb\pos+\bar\thumb\len-\bar\button[#__b_2]\len,\Y+_pos_,\Width-(\bar\thumb\pos+\bar\thumb\len-\x),_size_,Bool(\round),Bool(\round),\bar\button[#__b_2]\color\frame[#__s_0])
        EndIf
        
        
        If \bar\thumb\len
          Protected i, track_pos.f, _thumb_ = (\bar\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \bar\vertical
            If \mode = #__bar_Ticks
              For i=0 To \bar\page\end-\bar\min
                track_pos = (\bar\area\pos + Round(i * (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)) + _thumb_
                Line(\bar\button[3]\x+\bar\button[3]\width-4,track_pos,4, 1,\bar\button[#__b_3]\color\Frame)
              Next
            Else
              Line(\bar\button[3]\x+\bar\button[3]\width-4,\bar\area\pos + _thumb_,4, 1,\bar\button[#__b_3]\color\Frame)
              Line(\bar\button[3]\x+\bar\button[3]\width-4,\bar\area\pos + \bar\area\len + _thumb_,4, 1,\bar\button[#__b_3]\color\Frame)
            EndIf
          Else
            If \mode = #__bar_Ticks
              For i=0 To \bar\page\end-\bar\min
                track_pos = (\bar\area\pos + Round(i * (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \bar\button[3]\y+\bar\button[3]\height-4,1,4,\bar\button[#__b_3]\color\Frame)
              Next
            Else
              Line(\bar\area\pos + _thumb_, \bar\button[3]\y+\bar\button[3]\height-4,1,4,\bar\button[#__b_3]\color\Frame)
              Line(\bar\area\pos + \bar\area\len + _thumb_, \bar\button[3]\y+\bar\button[3]\height-4,1,4,\bar\button[#__b_3]\color\Frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x+Bool(\bar\vertical),\bar\button[#__b_3]\y+Bool(Not \bar\vertical),\bar\button[#__b_3]\len,\bar\button[#__b_3]\len,\bar\button[#__b_3]\color\fore[#__b_2],\bar\button[#__b_3]\color\Back[#__b_2], \round, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_3]\x+Bool(\bar\vertical),\bar\button[#__b_3]\y+Bool(Not \bar\vertical),\bar\button[#__b_3]\len,\bar\button[#__b_3]\len,\round,\round,\bar\button[#__b_3]\color\frame[#__b_2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\len-\bar\button[#__b_3]\arrow\size)/2+Bool(\bar\vertical),\bar\button[#__b_3]\y+(\bar\button[#__b_3]\len-\bar\button[#__b_3]\arrow\size)/2+Bool(Not \bar\vertical), 
                \bar\button[#__b_3]\arrow\size, Bool(\bar\vertical)+Bool(Not \bar\inverted And \bar\direction>0)*2+Bool(\bar\inverted And \bar\direction=<0)*2, \bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Progress(*this._s_widget)
    
    ; Selected Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\bar\vertical, *this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,*this\bar\button[#__b_1]\width,*this\bar\button[#__b_1]\height,*this\bar\button[#__b_1]\color\fore[*this\bar\button[#__b_1]\color\state],*this\bar\button[#__b_1]\color\back[*this\bar\button[#__b_1]\color\state])
    
    ; Normal Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\bar\vertical, *this\bar\button[#__b_2]\x, *this\bar\button[#__b_2]\y,*this\bar\button[#__b_2]\width,*this\bar\button[#__b_2]\height,*this\bar\button[#__b_2]\color\fore[*this\bar\button[#__b_2]\color\state],*this\bar\button[#__b_2]\color\back[*this\bar\button[#__b_2]\color\state])
    
    If *this\bar\vertical
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\bar\thumb\pos <> *this\bar\area\pos
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,1,*this\bar\button[#__b_1]\height,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,*this\bar\button[#__b_1]\width,1,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
        Line(*this\bar\button[#__b_1]\X+*this\bar\button[#__b_1]\width-1,*this\bar\button[#__b_1]\Y,1,*this\bar\button[#__b_1]\height,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
      Else
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,*this\bar\button[#__b_1]\width,1,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\bar\thumb\pos <> *this\bar\area\end
        Line(*this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\y,1,*this\bar\button[#__b_2]\height,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
        Line(*this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\Y+*this\bar\button[#__b_2]\height-1,*this\bar\button[#__b_2]\width,1,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
        Line(*this\bar\button[#__b_2]\x+*this\bar\button[#__b_2]\width-1,*this\bar\button[#__b_2]\y,1,*this\bar\button[#__b_2]\height,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
      Else
        Line(*this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\Y+*this\bar\button[#__b_2]\height-1,*this\bar\button[#__b_2]\width,1,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
      EndIf
      
    Else
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\bar\thumb\pos <> *this\bar\area\pos
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,*this\bar\button[#__b_1]\width,1,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,1,*this\bar\button[#__b_1]\height,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y+*this\bar\button[#__b_1]\height-1,*this\bar\button[#__b_1]\width,1,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
      Else
        Line(*this\bar\button[#__b_1]\X,*this\bar\button[#__b_1]\Y,1,*this\bar\button[#__b_1]\height,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\bar\thumb\pos <> *this\bar\area\end
        Line(*this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\Y,*this\bar\button[#__b_2]\width,1,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
        Line(*this\bar\button[#__b_2]\x+*this\bar\button[#__b_2]\width-1,*this\bar\button[#__b_2]\Y,1,*this\bar\button[#__b_2]\height,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
        Line(*this\bar\button[#__b_2]\x,*this\bar\button[#__b_2]\Y+*this\bar\button[#__b_2]\height-1,*this\bar\button[#__b_2]\width,1,*this\bar\button[#__b_2]\color\frame[*this\bar\button[#__b_2]\color\state])
      Else
        Line(*this\bar\button[#__b_2]\x+*this\bar\button[#__b_2]\width-1,*this\bar\button[#__b_2]\Y,1,*this\bar\button[#__b_2]\height,*this\bar\button[#__b_1]\color\frame[*this\bar\button[#__b_1]\color\state])
      EndIf
    EndIf
    
    ; Text
    If *this\text
      If *this\text\change 
        *this\text\change = 0
        *this\text\string = "%"+Str(*this\bar\page\Pos)
        *this\text\width = TextWidth(*this\text\string)
        *this\text\height = TextHeight("A")
        
        ;         If *this\bar\vertical
        ;           If *this\text\rotate = 90
        ;             *this\text\x = *this\x+(*this\width-*this\text\height)/2
        ;             *this\text\y = *this\y+(*this\height+*this\text\width)/2
        ;           ElseIf *this\text\rotate = 270
        ;             *this\text\x = *this\x+(*this\width+*this\text\height)/2  + Bool(#PB_Compiler_OS = #PB_OS_MacOS)*1
        ;             *this\text\y = *this\y+(*this\height-*this\text\width)/2
        ;           EndIf
        ;         Else
        ;           *this\text\x = *this\x+(*this\width-*this\text\width)/2
        ;           *this\text\y = *this\y+(*this\height-*this\text\height)/2
        ;         EndIf
        
        _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
        
      EndIf
      
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame)
    EndIf
    
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._s_widget)
    Protected Pos, Size, round.d = 2
    
    With *this
      DrawingMode(#PB_2DDrawing_Outlined)
      
      If \mode
        Protected *first._s_widget = \splitter\first
        Protected *second._s_widget = \splitter\second
        
        If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
          Box(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_3]\color\frame[\bar\button[#__b_1]\color\state])
        EndIf
        If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
          Box(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_3]\color\frame[\bar\button[#__b_2]\color\state])
        EndIf
      EndIf
      
      If \bar\button[#__b_3]\len
        ; Позиция сплиттера 
        Size = \bar\thumb\len/2
        Pos = \bar\thumb\Pos+Size
        
        If \bar\vertical ; horisontal
                         ;             Circle(\bar\button[#__b_3]\X+((\bar\button[#__b_3]\Width-round)/2-((round*2+2)*2+2)), Pos,round,\bar\button[#__b_3]\color\Frame[#__s_2])
                         ;             Circle(\bar\button[#__b_3]\X+((\bar\button[#__b_3]\Width-round)/2-(round*2+2)),       Pos,round,\bar\button[#__b_3]\color\Frame[#__s_2])
          Circle(\bar\button[#__b_3]\X+((\bar\button[#__b_3]\Width-round)/2),                    Pos,round,\bar\button[#__b_3]\color\Frame[#__s_2])
          ;             Circle(\bar\button[#__b_3]\X+((\bar\button[#__b_3]\Width-round)/2+(round*2+2)),       Pos,round,\bar\button[#__b_3]\color\Frame[#__s_2])
          ;             Circle(\bar\button[#__b_3]\X+((\bar\button[#__b_3]\Width-round)/2+((round*2+2)*2+2)), Pos,round,\bar\button[#__b_3]\color\Frame[#__s_2])
        Else
          ;             Circle(Pos,\bar\button[#__b_3]\Y+((\bar\button[#__b_3]\Height-round)/2-((round*2+2)*2+2)),round,\bar\button[#__b_3]\color\Frame[#__s_2])
          ;             Circle(Pos,\bar\button[#__b_3]\Y+((\bar\button[#__b_3]\Height-round)/2-(round*2+2)),      round,\bar\button[#__b_3]\color\Frame[#__s_2])
          Circle(Pos,\bar\button[#__b_3]\Y+((\bar\button[#__b_3]\Height-round)/2),                   round,\bar\button[#__b_3]\color\Frame[#__s_2])
          ;             Circle(Pos,\bar\button[#__b_3]\Y+((\bar\button[#__b_3]\Height-round)/2+(round*2+2)),      round,\bar\button[#__b_3]\color\Frame[#__s_2])
          ;             Circle(Pos,\bar\button[#__b_3]\Y+((\bar\button[#__b_3]\Height-round)/2+((round*2+2)*2+2)),round,\bar\button[#__b_3]\color\Frame[#__s_2])
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw(*this._s_widget)
    With *this
      If \text And \text\fontID 
        DrawingFont(\text\fontID)
      EndIf
      
      Select \bar\type
        Case #PB_GadgetType_Spin        : Draw_Spin(*this)
        Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
        Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
        Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
      EndSelect
      
    EndWith
  EndProcedure
  
  ;-
  Procedure.l X(*this._s_widget)
    ProcedureReturn *this\x + Bool(*this\bar\hide) * *this\width
  EndProcedure
  
  Procedure.l Y(*this._s_widget)
    ProcedureReturn *this\y + Bool(*this\bar\hide) * *this\height
  EndProcedure
  
  Procedure.l Width(*this._s_widget)
    ProcedureReturn Bool(Not *this\bar\hide) * *this\width
  EndProcedure
  
  Procedure.l Height(*this._s_widget)
    ProcedureReturn Bool(Not *this\bar\hide) * *this\height
  EndProcedure
  
  Procedure.b Hide(*this._s_widget, State.b = #PB_Default)
    *this\hide ! Bool(*this\hide <> State And State <> #PB_Default)
    ProcedureReturn *this\hide
  EndProcedure
  
  ;- GET
  Procedure.f GetState(*this._s_widget)
    ProcedureReturn *this\bar\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._s_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select Attribute
        Case #__bar_Minimum : Result = \bar\min  ; 1
        Case #__bar_Maximum : Result = \bar\max  ; 2
        Case #__bar_PageLength : Result = \bar\page\len
        Case #__bar_Inverted : Result = \bar\inverted
        Case #__bar_Direction : Result = \bar\direction
        Case #__bar_ButtonSize : Result = \bar\button\len 
        Case #__bar_ScrollStep : Result = \bar\scrollstep
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure.b Update(*this._s_widget)
    With *this
      If (\bar\max-\bar\min) >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _bar_area_pos_(*this)
        
        ;
        If Not \bar\max And \width And \height And (\splitter Or \bar\page\pos) 
          \bar\max = \bar\area\len-\bar\button[#__b_3]\len
          
          If Not \bar\page\pos
            \bar\page\pos = (\bar\max)/2 - Bool(  (\splitter And \splitter\fixed=#__b_1))
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #__b_1
          ;             \splitter\fixed[\splitter\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #__b_2
          ;             \splitter\fixed[\splitter\fixed] = \bar\area\len-\bar\page\pos-\bar\button[#__b_3]\len  + 1
          ;           EndIf
        EndIf
        
        If \splitter 
          If \splitter\fixed
            If \bar\area\len - \bar\button[#__b_3]\len > \splitter\fixed[\splitter\fixed] 
              \bar\page\pos = Bool(\splitter\fixed = 2) * \bar\max
              
              If \splitter\fixed[\splitter\fixed] > \bar\button[#__b_3]\len
                \bar\area\pos + \splitter\fixed[1]
                \bar\area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \bar\area\len - \bar\button[#__b_3]\len
              \bar\page\pos = Bool(\splitter\fixed = 1) * \bar\max
            EndIf
          EndIf
          
          ; Debug ""+\bar\area\len +" "+ Str(\bar\button[#__b_1]\len + \bar\button[#__b_2]\len)
          
          If \bar\area\len =< \bar\button[#__b_3]\len
            \bar\page\pos = \bar\max/2
            
            If \bar\vertical
              \bar\area\pos = \Y 
              \bar\area\len = \Height
            Else
              \bar\area\pos = \X
              \bar\area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \bar\area\len > \bar\button[#__b_3]\len
          \bar\thumb\len = _bar_thumb_len_(\bar)
          
          If \bar\thumb\len > \bar\area\len 
            \bar\thumb\len = \bar\area\len 
          EndIf 
          
          If \bar\thumb\len > \bar\button[#__b_3]\len
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
          Else
            \bar\area\len = \bar\area\len - (\bar\button[#__b_3]\len-\bar\thumb\len)
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)                              
            \bar\thumb\len = \bar\button[#__b_3]\len
          EndIf
          
        Else
          If \splitter
            \bar\thumb\len = \width
          Else
            \bar\thumb\len = 0
          EndIf
          
          If \bar\vertical
            \bar\area\pos = \Y
            \bar\area\len = \Height
          Else
            \bar\area\pos = \X
            \bar\area\len = \width 
          EndIf
          
          \bar\area\end = \bar\area\pos + (\bar\area\len - \bar\thumb\len)
        EndIf
        
        \bar\page\end = \bar\max - \bar\page\len
        \bar\thumb\pos = _bar_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
        If \bar\thumb\pos = \bar\area\end And \bar\type = #PB_GadgetType_ScrollBar
          ; Debug " line-" + #PB_Compiler_Line +" "+  \bar\type 
          SetState(*this, \bar\max)
        EndIf
      EndIf
      
      If \bar\type = #PB_GadgetType_ScrollBar
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.b UpdatePos(*this._s_widget, position.l, size.l)
    ; size = bottom visible 
    Protected.b result
    
    With *this
      position - \y
      size = (\bar\page\len-size)
      result | Bool((position-\bar\page\pos) < 0 And SetState(*this, position))
      result | Bool((position-\bar\page\pos) > size And SetState(*this, position-size))
      \bar\change = 0
    EndWith
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.b ChangePos(*bar._s_bar, ScrollPos.f)
    With *bar
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
      
      If Not ((#PB_GadgetType_TrackBar = \type Or 
               \type = #PB_GadgetType_ProgressBar Or
               \type = #PB_GadgetType_Spin) And \vertical)
        ScrollPos = _bar_invert_(*bar, ScrollPos, \inverted)
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
              \direction = _bar_invert_(*bar, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _bar_invert_(*bar, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        ProcedureReturn #True
      EndIf
    EndWith
  EndProcedure
  
  ;- SET
  Procedure.i SetPos(*this._s_widget, ThumbPos.i)
    Protected ScrollPos.f, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _bar_area_pos_(*this)
      EndIf
      
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
      
      If \bar\thumb\end <> ThumbPos 
        \bar\thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \bar\area\end <> ThumbPos
          ScrollPos = \bar\min + Round((ThumbPos - \bar\area\pos) / (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \bar\page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \bar\type Or 
            \bar\type = #PB_GadgetType_ProgressBar Or 
            \bar\type = #PB_GadgetType_Spin) And \bar\vertical
          ScrollPos = _bar_invert_(*this\bar, ScrollPos, \bar\inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._s_widget, ScrollPos.f)
    Protected Result.b
    
    With *this
      If ChangePos(*this\bar, ScrollPos)
        \bar\thumb\pos = _bar_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
        If \splitter And \splitter\fixed = #__b_1
          \splitter\fixed[\splitter\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #__b_2
          \splitter\fixed[\splitter\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        \bar\change = #False
        \change = #True
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._s_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#__b_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#__b_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
      Else
        Select Attribute
          Case #__bar_Minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              Result = #True
            EndIf
            
          Case #__bar_Maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If \bar\max = 0
                \bar\page\pos = 0
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_PageLength
            If \bar\page\len <> Value
              If Value > (\bar\max-\bar\min) 
                ;\bar\max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
                If \bar\max = 0 
                  \bar\max = Value 
                EndIf
                \bar\page\len = (\bar\max-\bar\min)
              Else
                \bar\page\len = Value
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_ScrollStep 
            \bar\scrollstep = Value
            
          Case #__bar_ButtonSize
            If \bar\button\len <> Value
              \bar\button\len = Value
              \bar\button[#__b_1]\len = Value
              \bar\button[#__b_2]\len = Value
              Result = #True
            EndIf
            
          Case #__bar_Inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _bar_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
            EndIf
            
        EndSelect
      EndIf
      
      If Result
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*this._s_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *this
      Select ColorType
        Case #__Color_Line
          If Item=- 1
            \Color\front[State] = Color
          Else
            \bar\button[Item]\Color\front[State] = Color
          EndIf
          
        Case #__Color_Back
          If Item=- 1
            \Color\Back[State] = Color
          Else
            \bar\button[Item]\Color\Back[State] = Color
          EndIf
          
        Case #__Color_Front
          
        Case #__Color_Frame
          If Item=- 1
            \Color\frame[State] = Color
          Else
            \bar\button[Item]\Color\frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ; ResetColor(*this)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  ;-
  Procedure.b Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \X = X : EndIf 
      If Y <> #PB_Ignore : \Y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \Height = height : EndIf
      
      ProcedureReturn Update(*this)
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
    With *scroll
      Protected iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x, iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      ;Protected iWidth = \h\bar\page\len, iHeight = \v\bar\page\len
      Static hPos, vPos : vPos = \v\bar\page\pos : hPos = \h\bar\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\bar\page\pos+iWidth 
        ScrollArea_Width=\h\bar\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\bar\page\pos And
             ScrollArea_Width=\h\bar\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\bar\page\pos+iHeight
        ScrollArea_Height=\v\bar\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\bar\page\pos And
             ScrollArea_Height=\v\bar\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\bar\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\bar\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\bar\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\bar\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      ;       If -\v\bar\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      ;       If -\h\bar\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      If -\v\bar\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\bar\page\Pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\bar\page\pos > ScrollArea_X And ScrollArea_X<>\h\bar\page\Pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\round And \h\round)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\round And \h\round)*(\h\height/4), #PB_Ignore)
      
      *Scroll\Y =- \v\bar\page\Pos
      *Scroll\X =- \h\bar\page\Pos
      *Scroll\width = \v\bar\max
      *Scroll\height = \h\bar\max
      
      
      
      If \v\hide : \v\bar\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\bar\page\pos = vPos : EndIf
      If \h\hide : \h\bar\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\bar\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If Not *scroll\v Or Not *scroll\h
        ProcedureReturn
      EndIf
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\bar\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len) : EndIf
      If \h\bar\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\bar\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Macro _bar_(_this_, _min_, _max_, _page_length_, _flag_, _round_=0)
    _this_\from =- 1
    *event\widget = _this_
    _this_\round = _round_
    _this_\bar\scrollstep = 1
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\bar\button[#__b_1]\color = def_colors
    _this_\bar\button[#__b_2]\color = def_colors
    _this_\bar\button[#__b_3]\color = def_colors
    
    _this_\bar\vertical = Bool(_flag_&#__bar_Vertical=#__bar_Vertical)
    _this_\bar\inverted = Bool(_flag_&#__bar_Inverted=#__bar_Inverted)
    
    If _this_\bar\min <> _min_ : SetAttribute(_this_, #__bar_Minimum, _min_) : EndIf
    If _this_\bar\max <> _max_ : SetAttribute(_this_, #__bar_Maximum, _max_) : EndIf
    If _this_\bar\page\len <> _page_length_ : SetAttribute(_this_, #__bar_PageLength, _page_length_) : EndIf
  EndMacro
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    If Flag&#PB_ScrollBar_Vertical
      Flag&~#PB_ScrollBar_Vertical
      Flag|#__bar_Vertical
    EndIf
    
    _bar_(*this, min, max, PageLength, Flag, round)
    
    With *this
      \bar\type = #PB_GadgetType_ScrollBar
      
      \bar\button[#__b_1]\arrow\type = 1
      \bar\button[#__b_2]\arrow\type = 1
      
      \bar\button[#__b_1]\arrow\size = 6
      \bar\button[#__b_2]\arrow\size = 6
      
      \bar\button[#__b_1]\interact = 1
      \bar\button[#__b_2]\interact = 1
      \bar\button[#__b_3]\interact = 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#__bar_ButtonSize=#__bar_ButtonSize)
        If \bar\vertical
          If width < 21
            \bar\button\len = width - 1
          Else
            \bar\button\len = 17
          EndIf
        Else
          If height < 21
            \bar\button\len = height - 1
          Else
            \bar\button\len = 17
          EndIf
        EndIf
        
        \bar\button[#__b_1]\len = \bar\button\len
        \bar\button[#__b_2]\len = \bar\button\len
      EndIf
      
      \bar\button[#__b_3]\len = \bar\button\len 
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, round.l=7)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    If Flag&#PB_TrackBar_Vertical
      Flag&~#PB_TrackBar_Vertical
      Flag|#__bar_Vertical
    EndIf
    
    If Flag&#PB_TrackBar_Ticks
      Flag&~#PB_TrackBar_Ticks
      Flag|#__bar_Ticks
    EndIf
    
    _bar_(*this, min, max, 0, Flag, round)
    
    With *this
      \bar\inverted = \bar\vertical
      \bar\button[#__b_3]\interact = 1
      
      \bar\type = #PB_GadgetType_TrackBar
      \mode = Bool(Flag&#__bar_Ticks) * #__bar_Ticks
      \bar\button[#__b_1]\color\state = Bool(Not \bar\vertical) * #__s_2
      \bar\button[#__b_2]\color\state = Bool(\bar\vertical) * #__s_2
      
      \bar\button[#__b_3]\len = 15
      \bar\button[#__b_1]\len = 1
      \bar\button[#__b_2]\len = 1
      
      \bar\button[#__b_3]\arrow\type = 0
      \bar\button[#__b_3]\arrow\size = 6
      
      \cursor = #PB_Cursor_Hand
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, round.l=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    If Flag&#PB_ProgressBar_Vertical
      Flag&~#PB_ProgressBar_Vertical
      Flag|#__bar_Vertical
    EndIf
    
    _bar_(*this, min, max, 0, Flag, round)
    
    With *this
      \bar\inverted = \bar\vertical
      \bar\button[#__b_3]\interact = 1
      
      \bar\type = #PB_GadgetType_ProgressBar
      \bar\button[#__b_1]\color\state = Bool(Not \bar\vertical) * #__s_2
      \bar\button[#__b_2]\color\state = Bool(\bar\vertical) * #__s_2
      
      \text = AllocateStructure(_S_text)
      \text\change = 1
      
      \text\align\vertical = 1
      \text\align\horizontal = 1
      \text\rotate = \bar\vertical * 90 ; 270
      
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
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, round.l=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If Flag&#PB_Splitter_Vertical
      Flag&~#PB_Splitter_Vertical
      Flag|#__bar_Vertical
    EndIf
    
    _bar_(*this, 0, 0, 0, Flag, round)
    
    With *this
      \bar\vertical ! 1
      
      \bar\type = #PB_GadgetType_Splitter
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If \bar\vertical
        \cursor = #PB_Cursor_UpDown
      Else
        \cursor = #PB_Cursor_LeftRight
      EndIf
      
      \Splitter = AllocateStructure(_S_splitter)
      \Splitter\first = First
      \Splitter\second = Second
      \splitter\g_first = IsGadget(First)
      \splitter\g_second = IsGadget(Second)
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      If Bool(Flag&#PB_Splitter_Separator)
        \mode = #PB_Splitter_Separator
        \bar\button[#__b_3]\len = 7
      Else
        \mode = 1
        \bar\button[#__b_3]\len = 3
      EndIf
      \bar\button[#__b_3]\interact = 1
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Increment.f=1.0, Round.l=7)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If Flag&#__bar_Vertical
      Flag&~#__bar_Vertical
    Else
      Flag|#__bar_Vertical
      Flag|#__bar_Inverted
    EndIf
    
    Round=2
    ;Increment=0.5
    
    _bar_(*this, min, max, 0, Flag, round)
    
    With *this
      \bar\button[#__b_1]\interact = 1
      \bar\button[#__b_2]\interact = 1
      
      \color\back = $FFFFFFFF
      \bar\scrollstep = Increment
      \bar\type = #PB_GadgetType_Spin
      
      \bar\button[#__b_1]\arrow\type = 1
      \bar\button[#__b_2]\arrow\type = 1
      
      \bar\button[#__b_1]\arrow\size = 4
      \bar\button[#__b_2]\arrow\size = 4
      
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#__bar_ButtonSize=#__bar_ButtonSize)
        \bar\button\len = 17
        \bar\button[#__b_1]\len = \bar\button\len
        \bar\button[#__b_2]\len = \bar\button\len
        \bar\button[#__b_3]\len = \bar\button\len
      EndIf
      
      \text = AllocateStructure(_S_text)
      \text\align\vertical = 1
      
      \text\align\width = \bar\button\len
      
      \text\align\right = 1
      
      \text\padding = 5
      \text\rotate = 0;\bar\vertical * 90 ; 270
      \text\change = 1
      
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        \text\fontID = GetGadgetFont(#PB_Default)
      CompilerEndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._s_widget, item.l=#PB_All, *data=0)
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
  
  Procedure.b Bind(*callBack, *this._s_widget, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure.b CallBack(*this._s_widget, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._s_widget, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_0 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
          ; Set splitter cursor
          If _this_\from = #__b_3 And _this_\bar\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
      EndSelect
    EndMacro
    
    With *this
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #__b_3
        If \splitter\first And Not \splitter\g_first
          If CallBack(\splitter\first, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack(\splitter\second, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Not \hide And (_from_point_(mouse_x, mouse_y, *this) Or Down)
        If \bar\button 
          If \bar\button[#__b_3]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_3])
            from = #__b_3
          ElseIf \bar\button[#__b_2]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_2])
            from = #__b_2
          ElseIf \bar\button[#__b_1]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_1])
            from = #__b_1
          ElseIf _from_point_(mouse_x, mouse_y, \bar\button[0])
            from = 0
          EndIf
          
          If \bar\type = #PB_GadgetType_TrackBar ;Or \bar\type = #PB_GadgetType_ProgressBar
            Select from
              Case #__b_1, #__b_2
                from = 0
                
            EndSelect
            ; ElseIf \bar\type = #PB_GadgetType_ProgressBar
            ;  
          EndIf
        Else
          from =- 1; 0
        EndIf 
        
        If \from <> from And Not Down
          If *leave > 0 And *leave\from >= 0 And *leave\bar\button[*leave\from]\interact And 
             Not _from_point_(mouse_x, mouse_y, *leave\bar\button[*leave\from])
            
            _callback_(*leave, #PB_EventType_MouseLeave)
            *leave\from =- 1; 0
            
            Result = #True
          EndIf
          
          ; If from > 0
          \from = from
          *leave = *this
          ; EndIf
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_MouseEnter)
            
            Result = #True
          EndIf
        EndIf
        
      Else
        If \from >= 0 And \bar\button[\from]\interact
          If EventType = #PB_EventType_LeftButtonUp
            ; Debug ""+#PB_Compiler_Line +" Мышь up"
            _callback_(*this, #PB_EventType_LeftButtonUp)
          EndIf
          
          ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
          _callback_(*this, #PB_EventType_MouseLeave)
          
          Result = #True
        EndIf 
        
        \from =- 1
        
        If *leave = *this
          *leave = 0
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel
          If *This = *event\active
            If \bar\vertical
              Result = SetState(*This, (\bar\page\pos + Wheel_Y))
            Else
              Result = SetState(*This, (\bar\page\pos + Wheel_X))
            EndIf
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp : Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If from =- 1
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          Macro _set_active_(_this_)
            If *event\active <> _this_
              If *event\active 
                ;                 If *event\active\row\selected 
                ;                   *event\active\row\selected\color\state = 3
                ;                 EndIf
                
                *event\active\color\state = 0
              EndIf
              
              ;               If _this_\row\selected And _this_\row\selected\color\state = 3
              ;                 _this_\row\selected\color\state = 2
              ;               EndIf
              
              _this_\color\state = 2
              *event\active = _this_
              Result = #True
            EndIf
          EndMacro
          
          If *leave = *this
            _set_active_(*this)
          EndIf
          
          If from = 0 And \bar\button[#__b_3]\interact 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-\bar\thumb\len/2))
            Else
              Result = SetPos(*this, (mouse_x-\bar\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from >= 0 And *this = *leave
            Down = *this
            \from = from 
            Debug *this
            
            If \bar\button[from]\interact
              \bar\button[\from]\color\state = #__s_2
              
              Select \from
                Case #__b_1 
                  If \bar\inverted
                    Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), Bool(\bar\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_2 
                  If \bar\inverted
                    Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), Bool(\bar\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_3 
                  LastX = mouse_x - \bar\thumb\pos 
                  LastY = mouse_y - \bar\thumb\pos
                  Result = #True
                  
              EndSelect
              
            Else
              Result = #True
            EndIf
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down And *leave = *this And Bool(LastX|LastY) 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-LastY))
            Else
              Result = SetPos(*this, (mouse_x-LastX))
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
  Global g_Canvas, NewList *List._s_widget()
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure GetCurrentEvent()
      Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
      If app
        ProcedureReturn CocoaMessage(0,app,"currentEvent")
      EndIf
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaX()
      Protected wheelDeltaX.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
      EndIf
      ProcedureReturn wheelDeltaX
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaY()
      Protected wheelDeltaY.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
      EndIf
      ProcedureReturn wheelDeltaY
    EndProcedure
  CompilerEndIf
  
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
      If *List()\bar\vertical And *List()\bar\type = GadgetType(EventGadget())
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
      If Not *List()\bar\vertical And *List()\bar\type = GadgetType(EventGadget())
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
    Protected WheelDelta ; = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._s_widget = GetGadgetData(Canvas)
    
    If EventType = #PB_EventType_MouseWheel
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected wheel_X.CGFloat = GetWheelDeltaX()
        Protected wheel_Y.CGFloat = GetWheelDeltaY()
      CompilerElse
        Protected wheel_X
        Protected wheel_Y
      CompilerEndIf
    EndIf
    
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
      Repaint | CallBack(*List(), EventType, MouseX, MouseY, wheel_X, wheel_Y)
      
      If *List()\bar\change
        
        If *List()\bar\vertical
          v_CallBack(*List()\bar\page\pos, *List()\bar\type)
        Else
          h_CallBack(*List()\bar\page\pos, *List()\bar\type)
        EndIf
        
        *List()\bar\change = 0
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
    AddElement(*List()) : *List() = Spin  (300+10, 72, 250,  21, 0, 10, 0)
    SetState   (Widget(),  5)   ; set 1st scrollbar (ID = 0) to 50 of 100
    AddElement(*List()) : *List() = Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #__bar_Vertical);|#__bar_Inverted)
                                                                                              ;AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 100 ,0, 521, 96, #PB_ScrollBar_Vertical)
    SetState   (Widget(), 100)                                                                ; set 2nd scrollbar (ID = 1) to 100 of 300
    
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
    ;     AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 0, 30, #__bar_Ticks)
    AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    AddElement(*List()) : *List() = Track(300+270, 140+10, 25, 170, 0, 10000, #__bar_Vertical)
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
    AddElement(*List()) : *List() = Progress  (300+270, 140+200,  25, 120 ,0, 300, #__bar_Vertical)
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
    ;     SetAttribute(Widget(), #__bar_FirstMinimumSize, 20)
    ;     SetAttribute(Widget(), #__bar_SecondMinimumSize, 20)
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
    
    Button_2 = SpinGadget(#PB_Any, 0, 0, 0, 0, 0,20) ; No need to specify size or coordinates
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
    Button_1 = Bar::Progress(0, 0, 0, 0, 10, 100); No need to specify size or coordinates
    Button_2 = Bar::Spin(0, 0, 0, 0, 0,20)       ; as they will be sized automatically
    Button_3 = Bar::Scroll(0, 0, 0, 0, 0, 100, 30, #__bar_Vertical|#__bar_Inverted) ; as they will be sized automatically
    
    Button_4 = Bar::Progress(0, 0, 0, 0, 40,100) ; as they will be sized automatically
    Button_5 = Bar::Spin(0, 0, 0, 0, 50,100, #__bar_Vertical) ; as they will be sized automatically
    
    Splitter_0 = Bar::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Bar::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;SetState(Splitter_1, 410/2-20)
    Splitter_2 = Bar::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Bar::Splitter(300+10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    SetState(Button_2, 5)
    SetState(Button_5, 65)
    
;     Widget() = Button_3
;     Widget()\height = 30
;     Widget()\width = 30
;     Widget()\bar\button[#__b_3]\len = 30
;     Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
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
; Folding = -----4------------4y--------f---------------------
; EnableXP