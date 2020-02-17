CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
  IncludePath ""
CompilerEndIf


CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "../constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "../structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "../colors.pbi"
CompilerEndIf


CompilerIf Not Defined(Bar, #PB_Module)
  ;- >>>
  DeclareModule bar
    EnableExplicit
    UseModule constants
    UseModule structures
    CompilerIf Defined(fixme, #PB_Module)
      UseModule fixme
    CompilerEndIf
    
    Macro _get_colors_()
      colors::*this\grey
    EndMacro
    
    Macro Root()
      *event\root
    EndMacro
    
    Macro Widget()
      *event\widget
    EndMacro
    
    Macro _is_widget_(_this_)
      Bool(_this_ And _this_\adress) * _this_
    EndMacro
    
    Macro _is_root_(_this_)
      Bool(_this_ And _this_ = _this_\root) * _this_
    EndMacro
    
    
    Macro width(_this_)
      (Bool(Not _this_\hide) * _this_\width)
    EndMacro
    
    Macro height(_this_)
      (Bool(Not _this_\hide) * _this_\height)
    EndMacro
    
    Macro _is_bar_(_this_, _bar_)
      Bool(_this_ And _this_\scroll And (_this_\scroll\v = _bar_ Or _bar_ = _this_\scroll\h))
    EndMacro
    
    Macro _is_scroll_bar_(_this_)
      Bool(_this_\parent And _this_\parent\scroll And (_this_\parent\scroll\v = _this_ Or _this_ = _this_\parent\scroll\h))
    EndMacro
    
    Macro _scrollarea_change_(_this_, _pos_, _len_)
      Bool(Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) < 0 And Bar::SetState(_this_, ((_pos_)+_this_\bar\min))) Or
           Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And Bar::SetState(_this_, ((_pos_)+_this_\bar\min)-(_this_\bar\page\len-(_len_)))))
    EndMacro
    
    Macro _scrollarea_draw_(_this_)
      ; Draw scroll bars
      CompilerIf Defined(Bar, #PB_Module)
        If _this_\scroll
          If Not _this_\scroll\v\hide And _this_\scroll\v\width
            Bar::Draw(_this_\scroll\v)
          EndIf
          If Not _this_\scroll\h\hide And _this_\scroll\h\height
            Bar::Draw(_this_\scroll\h)
          EndIf
          
          If _this_\scroll\v And _this_\scroll\h
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ; Scroll area coordinate
            Box(_this_\scroll\h\x + _this_\scroll\x, _this_\scroll\v\y + _this_\scroll\y, _this_\scroll\width, _this_\scroll\height, $FF0000FF)
            
            ; Debug ""+ _this_\scroll\x +" "+ _this_\scroll\y +" "+ _this_\scroll\width +" "+ _this_\scroll\height
            Box(_this_\scroll\h\x - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FFFF0000)
            
            ; page coordinate
            Box(_this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
          EndIf
        EndIf
      CompilerEndIf
    EndMacro
    
    Macro _scrollarea_update_(_this_)
      Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      _this_\scroll\v\bar\area\change = #False
      _this_\scroll\h\bar\area\change = #False
    EndMacro
    
    Macro _page_pos_(_bar_, _thumb_pos_)
      (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\scroll_increment, #PB_Round_Nearest))
    EndMacro
    
    Macro _thumb_pos_(_bar_, _scroll_pos_)
      (_bar_\area\pos + Round(((_scroll_pos_) - _bar_\min) * _bar_\scroll_increment, #PB_Round_Nearest)) 
      
      If (_bar_\fixed And Not _bar_\page\change)
        If _bar_\thumb\pos < _bar_\area\pos + _bar_\button[#__b_1]\fixed  
          _bar_\thumb\pos = _bar_\area\pos + _bar_\button[#__b_1]\fixed 
        EndIf
        
        If _bar_\thumb\pos > _bar_\area\end - _bar_\button[#__b_2]\fixed 
          _bar_\thumb\pos = _bar_\area\end - _bar_\button[#__b_2]\fixed 
        EndIf
      Else
        If _bar_\thumb\pos < _bar_\area\pos
          _bar_\thumb\pos = _bar_\area\pos
        EndIf
        
        If _bar_\thumb\pos > _bar_\area\end
          _bar_\thumb\pos = _bar_\area\end
        EndIf
      EndIf
      
      ; 
      If _bar_\page\change
        If Not _bar_\direction > 0 
          If _bar_\page\pos = _bar_\min Or _bar_\mode & #PB_TrackBar_Ticks 
            _bar_\button[#__b_3]\arrow\direction = Bool(Not _bar_\vertical) + Bool(_bar_\vertical = _bar_\inverted) * 2
          Else
            _bar_\button[#__b_3]\arrow\direction = Bool(_bar_\vertical) + Bool(_bar_\inverted) * 2
          EndIf
        Else
          If _bar_\page\pos = _bar_\page\end Or _bar_\mode & #PB_TrackBar_Ticks
            _bar_\button[#__b_3]\arrow\direction = Bool(Not _bar_\vertical) + Bool(_bar_\vertical = _bar_\inverted) * 2
          Else
            _bar_\button[#__b_3]\arrow\direction = Bool(_bar_\vertical) + Bool(Not _bar_\inverted ) * 2
          EndIf
        EndIf
      EndIf
    EndMacro
    
    Macro _get_thumb_len_(_bar_)
      ;Round(_bar_\area\len - _bar_\scroll_increment * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
      ;Round(_bar_\area\len - (_bar_\area\len / *this_bar_\max) * (_bar_\max - _bar_\page\len), #PB_Round_Nearest)
      Round(_bar_\area\len - (_bar_\area\len / (_bar_\max-_bar_\min)) * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
      
      If _bar_\thumb\len < _bar_\button[#__b_3]\len 
        If _bar_\area\len > _bar_\button[#__b_3]\len + _bar_\thumb\len
          _bar_\thumb\len = _bar_\button[#__b_3]\len 
        Else
          If _bar_\button[#__b_3]\len > 7
            ; scroll bar
            _bar_\thumb\len = 0
          Else
            ; splitter bar
            _bar_\thumb\len = _bar_\button[#__b_3]\len
          EndIf
        EndIf
      EndIf
    EndMacro
    
    Macro _get_page_height_(_scroll_, _round_ = 0)
      (_scroll_\v\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\h\hide) * (_scroll_\h\height/4)) 
    EndMacro
    
    Macro _get_page_width_(_scroll_, _round_ = 0)
      (_scroll_\h\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\v\hide) * (_scroll_\v\width/4))
    EndMacro
    
    Macro make_area_height(_scroll_, _width_, _height_)
      (_height_ - (Bool((_scroll_\width > _width_) Or Not _scroll_\h\hide) * _scroll_\h\height)) 
    EndMacro
    
    Macro make_area_width(_scroll_, _width_, _height_)
      (_width_ - (Bool((_scroll_\height > _height_) Or Not _scroll_\v\hide) * _scroll_\v\width))
    EndMacro
    
    ; Then scroll bar start position
    Macro _in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
    
    ; Then scroll bar end position
    Macro _in_stop_(_bar_) : Bool(_bar_\page\pos >= _bar_\page\end) : EndMacro
    
    ; Inverted scroll bar position
    Macro _invert_(_bar_, _scroll_pos_, _inverted_=#True)
      (Bool(_inverted_) * (_bar_\page\end - (_scroll_pos_-_bar_\min)) + Bool(Not _inverted_) * (_scroll_pos_))
      ;  (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
    EndMacro
    
    Macro _move_childrens_(_parent_, _change_x_, _change_y_)
      If _parent_\container And _parent_\count\childrens ; And ListSize(_parent_\childrens())
        PushListPosition(*event\childrens())
        ForEach *event\childrens()
          If *event\childrens()\parent = _parent_ 
            ; Debug *event\childrens()\class +" - "+ *event\childrens()\parent\class +" - "+ _parent_\class +" - "+ _parent_\parent\class; Bool(*event\childrens()\type = #PB_GadgetType_Button)
            
            Resize(*event\childrens(), 
                   *event\childrens()\x[#__c_3] + _change_x_,
                   *event\childrens()\y[#__c_3] + _change_y_, 
                   #PB_Ignore, #PB_Ignore)
          EndIf
        Next
        PopListPosition(*event\childrens())
      EndIf
    EndMacro
    
    ;-  DECLAREs
    Declare.b Draw(*this)
    Declare   ReDraw(*this)
    
    Declare.b Update(*this)
    Declare.b Change(*bar, ScrollPos.f)
    Declare.b SetPos(*this, ThumbPos.i)
    
    Declare.f GetState(*this)
    Declare.b SetState(*this, ScrollPos.f)
    Declare.l SetAttribute(*this, Attribute.l, Value.l)
    
    Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
    Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    
    Declare.i Create(type.l, *parent, size.l, *param_1, *param_2, *param_3, flag.i=0, round.l=7, scroll_step.f=1.0)
    Declare.b Events(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
    
    Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
    Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Declare.b Bind(*callBack, *this._s_widget, eventtype.l=#PB_All)
    
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l=0)
    Declare   ScrollArea(X.l,Y.l,Width.l,Height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
    Declare   Open_CanvasWindow(Window, X.l, Y.l, Width.l, Height.l, Title.s, Flag.i, ParentID.i)
  EndDeclareModule
  
  Module bar
    Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
      Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
            _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
    EndMacro
    
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
        If Style > 0 : x-1 : y+1;2
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
        If Style > 0 : y-1 ;: x + 1
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
    
    ;-
    Procedure.b Draw_Scroll(*this._s_widget)
      With *this
        
        If Not \hide And \color\alpha
          If \color\back <> - 1
            ; Draw scroll bar background
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \type = #PB_GadgetType_ScrollBar
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
          EndIf
          
          If (\bar\vertical And \bar\button[#__b_1]\height) Or (Not \bar\vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                                 ; Draw buttons
            If \bar\button[#__b_1]\color\fore <> - 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                             \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_1]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, 
                    \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
            EndIf
          EndIf
          
          If (\bar\vertical And \bar\button[#__b_2]\height) Or (Not \bar\vertical And \bar\button[#__b_2]\width)
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <> - 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                             \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2, 
                    \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
            EndIf
          EndIf
          
          If \bar\thumb\len And \type <> #PB_GadgetType_ProgressBar
            ; Draw thumb
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                           \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
            
            ; Draw thumb frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
            
            If \bar\button[#__b_3]\arrow\type ; \type = #PB_GadgetType_ScrollBar
              If \bar\button[#__b_3]\arrow\size
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Arrow(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2, 
                      \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
              EndIf
            Else
              ; Draw thumb lines
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              If \bar\vertical
                Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2-3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2+3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Else
                Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2-3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2+3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              EndIf
              
            EndIf
          EndIf
          
          
        EndIf
      EndWith 
    EndProcedure
    
    Procedure.i Draw_Spin(*this._s_widget) 
      Draw_Scroll(*this)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\bar\button[#__b_1]\x-2,*this\y[#__c_1],*this\x[2]+*this\width[2] - *this\bar\button[#__b_1]\x+3,*this\height[#__c_1], *this\color\frame[*this\color\state])
      Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
      
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0]) ; *this\color\state])
      EndIf
    EndProcedure
    
    Procedure.b Draw_Track(*this._s_widget)
      *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      *this\bar\button[#__b_3]\color\state = 2
      
      Draw_Scroll(*this)
      
      With *this
        If \type = #PB_GadgetType_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \bar\vertical
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\scroll_increment > 1
                For i=\bar\min To \bar\page\end
                  Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-1, 
                       (\bar\area\pos + _thumb_ + (i-\bar\min) * \bar\scroll_increment),3, 1,\bar\button[#__b_1]\color\frame)
                Next
              Else
                Box(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-1,\bar\area\pos + _thumb_, 3, *this\bar\area\len - *this\bar\thumb\len+1, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3),\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3),\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode & #PB_TrackBar_Ticks
             If \bar\scroll_increment > 1
               For i=0 To \bar\page\end-\bar\min
                Line((\bar\area\pos + _thumb_ + i * \bar\scroll_increment), 
                     \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3+4)-1,1,3,\bar\button[#__b_3]\color\Frame)
              Next
              Else
                Box(\bar\area\pos + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3+4)-1,*this\bar\area\len - *this\bar\thumb\len+1, 3, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3),1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3),1,3,\bar\button[#__b_3]\color\Frame)
          EndIf
        EndIf
      EndWith    
      
    EndProcedure
    
    Procedure.b Draw_Progress(*this._s_widget)
      *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      
      Draw_Scroll(*this)
      
      With *this
        If \type = #PB_GadgetType_ProgressBar 
          
          ;           DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_alphaBlend)
          ;           RoundBox(\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          ;           RoundBox(\bar\thumb\pos+\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          If \bar\button[#__b_1]\round
            If \bar\vertical
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x+\bar\button[#__b_1]\width-1, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x+\bar\button[#__b_2]\width-1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y+\bar\button[#__b_1]\height-1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y+\bar\button[#__b_2]\height-1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            If \bar\vertical
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x+1,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x+1,\bar\thumb\pos,\bar\button[#__b_2]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height-2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_2]\height-2,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            EndIf
          EndIf
          
        EndIf
      EndWith
      
      ; Draw string
      If *this\text And *this\text\string And (*this\height > *this\text\height)
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state])
      EndIf
    EndProcedure
    
    Procedure.b Draw_Splitter(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Outlined);|#PB_2DDrawing_AlphaBlend)
        
        If \bar\mode 
          If Not \splitter\g_first And (Not \splitter\first Or (\splitter\first And Not \splitter\first\splitter))
            Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not \splitter\second Or (\splitter\second And Not \splitter\second\splitter))
            Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          EndIf
        EndIf
        
        If \bar\mode & #PB_Splitter_Separator
          If \bar\vertical ; horisontal
            If \bar\button[#__b_3]\width > 35
              Circle(\bar\button[#__b_3]\X[1]-(\bar\button[#__b_3]\round*2+2)*2-2, \bar\button[#__b_3]\y[1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\X[1]+(\bar\button[#__b_3]\round*2+2)*2+2, \bar\button[#__b_3]\y[1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\width > 20
              Circle(\bar\button[#__b_3]\X[1]-(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\y[1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\X[1]+(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\y[1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            Circle(\bar\button[#__b_3]\X[1], \bar\button[#__b_3]\y[1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
          Else
            
            If \bar\button[#__b_3]\Height > 35
              Circle(\bar\button[#__b_3]\x[1],\bar\button[#__b_3]\Y[1]-(\bar\button[#__b_3]\round*2+2)*2-2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[1],\bar\button[#__b_3]\Y[1]+(\bar\button[#__b_3]\round*2+2)*2+2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\Height > 20
              Circle(\bar\button[#__b_3]\x[1],\bar\button[#__b_3]\Y[1]-(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[1],\bar\button[#__b_3]\Y[1]+(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            Circle(\bar\button[#__b_3]\x[1],\bar\button[#__b_3]\Y[1], \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure Draw_ScrollArea(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Outlined)
       Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
      
      If \scroll 
          ; ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Draw(*this._s_widget)
      Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
        ;If _this_\text\vertical
        If _this_\text\rotate = 90
          If _this_\y<>_y_
            _this_\text\x = _x_ + _this_\y
          Else
            _this_\text\x = _x_ + (_width_-_this_\text\height)/2
          EndIf
          
          If _this_\text\align\right
            _this_\text\y = _y_ +_this_\text\align\height+ _this_\text\_padding+_this_\text\width
          ElseIf _this_\text\align\horizontal
            _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
          Else
            _this_\text\y = _y_ + _height_-_this_\text\_padding
          EndIf
          
        ElseIf _this_\text\rotate = 270
          _this_\text\x = _x_ + (_width_ - 4)
          
          If _this_\text\align\right
            _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\_padding) 
          ElseIf _this_\text\align\horizontal
            _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
          Else
            _this_\text\y = _y_ + _this_\text\_padding 
          EndIf
          
        EndIf
        
        ;Else
        If _this_\text\rotate = 0
          If _this_\x<>_x_
            _this_\text\y = _y_ + _this_\y
          Else
            _this_\text\y = _y_ + (_height_-_this_\text\height)/2
          EndIf
          
          If _this_\text\align\right
            _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width-_this_\text\_padding) 
          ElseIf _this_\text\align\horizontal
            _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
          Else
            _this_\text\x = _x_ + _this_\text\_padding
          EndIf
          
        ElseIf _this_\text\rotate = 180
          _this_\text\y = _y_ + (_height_-_this_\y)
          
          If _this_\text\align\right
            _this_\text\x = _x_ + _this_\text\_padding+_this_\text\width
          ElseIf _this_\text\align\horizontal
            _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
          Else
            _this_\text\x = _x_ + _width_-_this_\text\_padding 
          EndIf
          
        EndIf
        ;EndIf
      EndMacro
      
      With *this
        If *this
          If \text 
            If \text\fontID 
              DrawingFont(\text\fontID)
            EndIf
            
            If \text\change
              *this\text\height = TextHeight("A")
              *this\text\width = TextWidth(*this\text\string)
              
              *this\text\rotate = (Bool(*this\bar\vertical And *this\bar\inverted) * 90) +
                                  (Bool(*this\bar\vertical And Not *this\bar\inverted) * 270)
        
              _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
            EndIf
          EndIf
          
          ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
        
          Select \type
            Case #PB_GadgetType_Spin        : Draw_Spin(*this)
            Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
            Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
            Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
            Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
            Case #PB_GadgetType_ScrollArea  : Draw_ScrollArea(*this)
          EndSelect
          
          If *this\text\change <> 0
            *this\text\change = 0
          EndIf
          
          If *this\bar\page\change <> 0
            *this\bar\page\change = 0
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure   ReDraw(*this._s_widget)
      If StartDrawing(CanvasOutput(*this\root\canvas))
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
        Protected *event._s_event = GetGadgetData(*this\root\canvas)
        
        ; PushListPosition(*event\childrens())
        ForEach *event\childrens()
          ;If *event\childrens()\root And *event\childrens()\root\canvas = *event\root\canvas
          If Not *event\childrens()\hide
            Draw(*event\childrens())
          EndIf
          ; EndIf
        Next
        ; PopListPosition(*event\childrens())
        
        StopDrawing()
      EndIf
    EndProcedure
    
    
    ;-
    Procedure.b Update_Scroll(*this._s_widget)
      With *this
        If *this\type = #PB_GadgetType_ScrollBar 
          If *this\bar\button[#__b_1]\len 
            If *this\bar\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x           + 1 ; white line size
              *this\bar\button[#__b_1]\width = *this\width   - 1 ; white line size
              *this\bar\button[#__b_1]\y = *this\y 
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y           + 1 ; white line size
              *this\bar\button[#__b_1]\height = *this\height - 1 ; white line size
              *this\bar\button[#__b_1]\x = *this\x 
              *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
            EndIf
          EndIf
          
          If *this\bar\button[#__b_2]\len 
            If *this\bar\vertical 
              ; Botom button coordinate on vertical scroll bar
              *this\bar\button[#__b_2]\x = *this\x           + 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\width   - 1 ; white line size
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\y = *this\Y+*this\height-*this\bar\button[#__b_2]\height
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y           + 1 ; white line size
              *this\bar\button[#__b_2]\height = *this\height - 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\x = *this\X+*this\width-*this\bar\button[#__b_2]\width 
            EndIf
          EndIf
          
          ; Thumb coordinate on scroll bar
          If *this\bar\thumb\len
            If *this\bar\vertical
              *this\bar\button[#__b_3]\x = *this\bar\button[#__b_1]\x 
              *this\bar\button[#__b_3]\width = *this\bar\button[#__b_1]\width 
              *this\bar\button[#__b_3]\y = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
            Else
              *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y 
              *this\bar\button[#__b_3]\height = *this\bar\button[#__b_1]\height
              *this\bar\button[#__b_3]\x = *this\bar\thumb\pos 
              *this\bar\button[#__b_3]\width = *this\bar\thumb\len                                  
            EndIf
            
          Else
            ; auto resize buttons
            If *this\bar\vertical
              *this\bar\button[#__b_2]\height = *this\height/2 
              *this\bar\button[#__b_2]\y = *this\y+*this\bar\button[#__b_2]\height+Bool(*this\height%2) 
              
              *this\bar\button[#__b_1]\y = *this\y 
              *this\bar\button[#__b_1]\height = *this\height/2-Bool(Not *this\height%2)
              
            Else
              *this\bar\button[#__b_2]\width = *this\width/2 
              *this\bar\button[#__b_2]\x = *this\x+*this\bar\button[#__b_2]\width+Bool(*this\width%2) 
              
              *this\bar\button[#__b_1]\x = *this\x 
              *this\bar\button[#__b_1]\width = *this\width/2-Bool(Not *this\width%2)
            EndIf
          EndIf
          
          If *this\bar\page\change
            
            If *this\parent And 
               *this\parent\scroll
              ; Debug  ""+*this\type+" "+*this\parent\type
              
              If *this\bar\vertical
                If *this\parent\scroll\v = *this
                  *this\parent\change =- 1
                  *this\parent\scroll\y =- *this\bar\page\pos
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container
                    _move_childrens_(*this\parent, 0, *this\bar\page\change)
                  EndIf
                EndIf
              Else
                If *this\parent\scroll\h = *this
                  *this\parent\change =- 1
                  *this\parent\scroll\x =- *this\bar\page\pos
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container
                    _move_childrens_(*this\parent, *this\bar\page\change, 0)
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;       ; bar change
            ;       Post(#__Event_StatusChange, *this, *this\from, *this\bar\direction)
            ; *this\bar\page\change = 0
          EndIf
        EndIf
        
        
        If \bar\max >= \bar\page\len
          If #PB_GadgetType_ScrollBar = \type And \bar\thumb\pos = \bar\area\end And \bar\page\pos <> \bar\page\end And _in_stop_(\bar)
            ;    Debug " line-" + #PB_compiler_line +" "+  \bar\max 
            ;             If \bar\inverted
            ;              SetState(*this, _invert_(*this\bar, \bar\max, \bar\inverted))
            ;             Else
            SetState(*this, \bar\page\end)
            ;             EndIf
          EndIf
        EndIf
        
        If \type = #PB_GadgetType_ScrollBar
          \bar\hide = Bool(Not (\bar\max > \bar\page\len))
          
          If \bar\hide
            \bar\page\pos = \bar\min
            ;\bar\thumb\pos = ThumbPos(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
            ; ProcedureReturn Update_Scroll(*this)
          EndIf
          ProcedureReturn \bar\hide
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Update_Spin(*this._s_widget)
      With *this
        ;         If *this\bar\button[#__b_3]\len
        ; ;           If *this\bar\vertical
        ;             *this\bar\button[#__b_3]\y      = *this\y[2]
        ;             *this\bar\button[#__b_3]\height = *this\height[2]
        ;             *this\bar\button[#__b_3]\x      = (*this\x[2]+*this\width[2])-*this\bar\button[#__b_3]\len
        ;             *this\bar\button[#__b_3]\width  = *this\bar\button[#__b_3]\len                                  
        ; ;           Else
        ; ;             *this\bar\button[#__b_3]\x      = *this\x[2] 
        ; ;             *this\bar\button[#__b_3]\width  = *this\width[2] 
        ; ;             *this\bar\button[#__b_3]\y      = (*this\y[2]+*this\height[2])-*this\bar\button[#__b_3]\len
        ; ;             *this\bar\button[#__b_3]\height = *this\bar\button[#__b_3]\len                              
        ; ;           EndIf
        ;         EndIf
        
        If *this\bar\vertical      
          ; Top button coordinate
          *this\bar\button[#__b_2]\y      = *this\y[2]+*this\height[2]/2 + Bool(*this\height%2)
          *this\bar\button[#__b_2]\height = *this\height[2]/2 - 1 
          *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len 
          *this\bar\button[#__b_2]\x      = (*this\x[2]+*this\width[2])-*this\bar\button[#__b_2]\len - 1
          
          ; Bottom button coordinate
          *this\bar\button[#__b_1]\y      = *this\y[2] + 1 
          *this\bar\button[#__b_1]\height = *this\height[2]/2 - Bool(Not *this\height%2) - 1
          *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len 
          *this\bar\button[#__b_1]\x      = (*this\x[2]+*this\width[2])-*this\bar\button[#__b_1]\len - 1                               
        Else    
          ; Left button coordinate
          *this\bar\button[#__b_1]\y      = *this\y[2] + 1
          *this\bar\button[#__b_1]\height = *this\height[2] - 2
          *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len/2 - 1
          *this\bar\button[#__b_1]\x      = *this\x+*this\width-*this\bar\button[#__b_1]\len - 1   
          
          ; Right button coordinate
          *this\bar\button[#__b_2]\y      = *this\y[2] + 1 
          *this\bar\button[#__b_2]\height = *this\height[2] - 2
          *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len/2 - 1
          *this\bar\button[#__b_2]\x      = *this\x[2]+*this\width[2]-*this\bar\button[#__b_2]\len/2                             
        EndIf
        
        
        If *this\text
          Protected i
          *this\text\change = 1
          
          For i = 0 To 3
            If *this\bar\scroll_step = ValF(StrF(*this\bar\scroll_step, i))
              *this\text\string = StrF(*this\bar\page\pos, i)
              Break
            EndIf
          Next
        EndIf
        
        ProcedureReturn Bool(\resize & #__resize_change)
      EndWith
    EndProcedure
    
    Procedure.b Update_Track(*this._s_widget)
      With *this
        ; Thumb coordinate on scroll bar
        If *this\bar\thumb\len
          If *this\bar\vertical
            *this\bar\button[#__b_3]\x      = *this\bar\button\x 
            *this\bar\button[#__b_3]\width  = *this\bar\button\width 
            *this\bar\button[#__b_3]\y      = *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
          Else
            *this\bar\button[#__b_3]\y      = *this\bar\button\y 
            *this\bar\button[#__b_3]\height = *this\bar\button\height
            *this\bar\button[#__b_3]\x      = *this\bar\thumb\pos 
            *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
          EndIf
        EndIf
        
        ; draw track bar coordinate
        If *this\bar\vertical
          *this\bar\button[#__b_1]\width    = 4
          *this\bar\button[#__b_2]\width    = 4
          *this\bar\button[#__b_3]\width    = *this\bar\button[#__b_3]\len+(Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
          
          *this\bar\button[#__b_1]\y        = *this\Y
          *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos-*this\y + *this\bar\thumb\len/2
          
          *this\bar\button[#__b_2]\y        = *this\bar\thumb\pos+*this\bar\thumb\len/2
          *this\bar\button[#__b_2]\height   = *this\height-(*this\bar\thumb\pos+*this\bar\thumb\len/2-*this\y)
          
          If *this\bar\inverted
            *this\bar\button[#__b_1]\x      = *this\x+6
            *this\bar\button[#__b_2]\x      = *this\x+6
            *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x-*this\bar\button[#__b_3]\width/4-1- Bool(*this\bar\button[#__b_3]\len>10)
          Else
            *this\bar\button[#__b_1]\x      = *this\x+*this\width-*this\bar\button[#__b_1]\width-6
            *this\bar\button[#__b_2]\x      = *this\x+*this\width-*this\bar\button[#__b_2]\width-6 
            *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x-*this\bar\button[#__b_3]\width/2 + Bool(*this\bar\button[#__b_3]\len>10)
          EndIf
        Else
          *this\bar\button[#__b_1]\height   = 4
          *this\bar\button[#__b_2]\height   = 4
          *this\bar\button[#__b_3]\height   = *this\bar\button[#__b_3]\len+(Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
          
          *this\bar\button[#__b_1]\x        = *this\X
          *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos-*this\x + *this\bar\thumb\len/2
          
          *this\bar\button[#__b_2]\x        = *this\bar\thumb\pos+*this\bar\thumb\len/2
          *this\bar\button[#__b_2]\width    = *this\width-(*this\bar\thumb\pos+*this\bar\thumb\len/2-*this\x)
          
          If *this\bar\inverted
            *this\bar\button[#__b_1]\y      = *this\y+*this\height-*this\bar\button[#__b_1]\height-6
            *this\bar\button[#__b_2]\y      = *this\y+*this\height-*this\bar\button[#__b_2]\height-6 
            *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y-*this\bar\button[#__b_3]\height/2 + Bool(*this\bar\button[#__b_3]\len>10)
          Else
            *this\bar\button[#__b_1]\y      = *this\y+6
            *this\bar\button[#__b_2]\y      = *this\y+6
            *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y-*this\bar\button[#__b_3]\height/4-1- Bool(*this\bar\button[#__b_3]\len>10)
          EndIf
        EndIf
        
        ProcedureReturn Bool(*this\resize & #__resize_change)
      EndWith
    EndProcedure
    
    Procedure.b Update_Progress(*this._s_widget)
      With *this
        *this\bar\button[#__b_1]\x        = *this\X
        *this\bar\button[#__b_1]\y        = *this\Y
        
        If *this\bar\vertical
          *this\bar\button[#__b_1]\width  = *this\width
          *this\bar\button[#__b_1]\height = *this\bar\thumb\pos-*this\y 
        Else
          *this\bar\button[#__b_1]\width  = *this\bar\thumb\pos-*this\x 
          *this\bar\button[#__b_1]\height = *this\height
        EndIf
        
        If *this\bar\vertical
          *this\bar\button[#__b_2]\x      = *this\x
          *this\bar\button[#__b_2]\y      = *this\bar\thumb\pos+*this\bar\thumb\len
          *this\bar\button[#__b_2]\width  = *this\width
          *this\bar\button[#__b_2]\height = *this\height-(*this\bar\thumb\pos+*this\bar\thumb\len-*this\y)
        Else
          *this\bar\button[#__b_2]\x      = *this\bar\thumb\pos+*this\bar\thumb\len
          *this\bar\button[#__b_2]\y      = *this\Y
          *this\bar\button[#__b_2]\width  = *this\width-(*this\bar\thumb\pos+*this\bar\thumb\len-*this\x)
          *this\bar\button[#__b_2]\height = *this\height
        EndIf
        
        If *this\text
          *this\text\change = 1
          *this\text\string = "%" + Str(*this\bar\page\pos)  +" "+ Str(*this\width)
        EndIf
        
        ProcedureReturn Bool(\resize & #__resize_change)
      EndWith
    EndProcedure
    
    Procedure.b Update_Splitter(*this._s_widget) ; Ok
      If *this\type = #PB_GadgetType_Splitter And *this\Splitter 
        If *this\bar\vertical
          *this\bar\button[#__b_1]\width    = *this\width
          *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos - *this\y 
          
          *this\bar\button[#__b_1]\x        = *this\x + (Bool(*this\splitter\g_first)**this\x)
          *this\bar\button[#__b_2]\x        = *this\x + (Bool(*this\splitter\g_second)**this\x)
          If Not ((#PB_Compiler_OS = #PB_OS_MacOS) And *this\splitter\g_first And Not *this\parent)
            *this\bar\button[#__b_1]\y      = *this\y + (Bool(*this\splitter\g_first)**this\y)
            *this\bar\button[#__b_2]\y      = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\splitter\g_second)**this\y)
          Else
            *this\bar\button[#__b_1]\y      = *this\height - *this\bar\button[#__b_1]\height
          EndIf
          
          *this\bar\button[#__b_2]\height   = *this\height - (*this\bar\button[#__b_1]\height + *this\bar\thumb\len)
          *this\bar\button[#__b_2]\width    = *this\width
          
          If *this\bar\thumb\len
            *this\bar\button[#__b_3]\x      = *this\x
            *this\bar\button[#__b_3]\y      = *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
            *this\bar\button[#__b_3]\width  = *this\width 
            
            *this\bar\button[#__b_3]\y[1]   = (*this\bar\button[#__b_3]\y + *this\bar\button[#__b_3]\height/2)
            *this\bar\button[#__b_3]\X[1]   = *this\x + (*this\width-*this\bar\button[#__b_3]\round)/2 + Bool(*this\width%2)
          EndIf
        Else
          *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos - *this\x 
          *this\bar\button[#__b_1]\height   = *this\height
          
          *this\bar\button[#__b_1]\y        = *this\y + (Bool(*this\splitter\g_first)**this\y)
          *this\bar\button[#__b_2]\y        = *this\y + (Bool(*this\splitter\g_second)**this\y)
          *this\bar\button[#__b_1]\x        = *this\x + (Bool(*this\splitter\g_first)**this\x)
          *this\bar\button[#__b_2]\x        = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\splitter\g_second)**this\x)
          
          *this\bar\button[#__b_2]\width    = *this\width - (*this\bar\button[#__b_1]\width + *this\bar\thumb\len)
          *this\bar\button[#__b_2]\height   = *this\height
          
          If *this\bar\thumb\len
            *this\bar\button[#__b_3]\y      = *this\y
            *this\bar\button[#__b_3]\x      = *this\bar\thumb\pos
            *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
            *this\bar\button[#__b_3]\height = *this\height
            
            *this\bar\button[#__b_3]\x[1]   = (*this\bar\button[#__b_3]\x + *this\bar\button[#__b_3]\width/2) ; - *this\x
            *this\bar\button[#__b_3]\y[1]   = *this\y + (*this\height-*this\bar\button[#__b_3]\round)/2 + Bool(*this\height%2)
          EndIf
        EndIf
        
        ; 
        If *this\bar\fixed And *this\bar\page\change
          If *this\bar\vertical
            *this\bar\button[*this\bar\fixed]\fixed = *this\bar\button[*this\bar\fixed]\height - *this\bar\button[*this\bar\fixed]\len
          Else
            *this\bar\button[*this\bar\fixed]\fixed = *this\bar\button[*this\bar\fixed]\width - *this\bar\button[*this\bar\fixed]\len
          EndIf
        EndIf
        
        ; Splitter childrens auto resize       
        If *this\splitter\first
          If *this\splitter\g_first
            ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          Else
            Resize(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          EndIf
        EndIf
        
        If *this\splitter\second
          If *this\splitter\g_second
            ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          Else
            Resize(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          EndIf   
        EndIf   
        
      EndIf
      
      ProcedureReturn Bool(*this\resize & #__resize_change)
    EndProcedure
    
    Procedure.b Update(*this._s_widget)
      Protected _scroll_pos_.f
      
      If Bool(*this\resize & #__resize_change)
        If *this\bar\max And *this\type = #PB_GadgetType_ScrollBar And 
           *this\bar\button[#__b_1]\len =- 1 And *this\bar\button[#__b_2]\len =- 1
          
          If *this\bar\vertical And 
             *this\width[2] > 7 And *this\width[2] < 21
            *this\bar\button[#__b_1]\len = *this\width[2] - 1
            *this\bar\button[#__b_2]\len = *this\width[2] - 1
            
          ElseIf Not *this\bar\vertical And 
                 *this\height[2] > 7 And *this\height[2] < 21
            *this\bar\button[#__b_1]\len = *this\height[2] - 1
            *this\bar\button[#__b_2]\len = *this\height[2] - 1
            
          Else
            *this\bar\button[#__b_1]\len = *this\bar\button[#__b_3]\len
            *this\bar\button[#__b_2]\len = *this\bar\button[#__b_3]\len
          EndIf
          
          If *this\bar\button[#__b_3]\len
            If *this\bar\vertical
              If *this\width = 0
                *this\width = *this\bar\button[#__b_3]\len
              EndIf
            Else
              If *this\height = 0
                *this\height = *this\bar\button[#__b_3]\len
              EndIf
            EndIf
          EndIf
        EndIf
        
        If *this\bar\vertical
          *this\bar\area\pos = *this\y + *this\bar\button[#__b_1]\len
          *this\bar\area\len = *this\height - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
        Else
          *this\bar\area\pos = *this\x + *this\bar\button[#__b_1]\len
          *this\bar\area\len = *this\width - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
        EndIf
        
        If *this\bar\area\len < *this\bar\button[#__b_3]\len 
          *this\bar\area\len = *this\bar\button[#__b_3]\len 
        Else
          ; if SetState(height-value or width-value)
          If *this\bar\button[#__b_3]\fixed < 0 
            *this\bar\page\pos = *this\bar\area\len + *this\bar\button[#__b_3]\fixed
            *this\bar\button[3]\fixed = 0
          EndIf
        EndIf
        
        *this\bar\thumb\len = _get_thumb_len_(*this\bar)
        
        ; one
        If Not *this\bar\max And *this\width And *this\height
          If Not *this\bar\page\pos
            *this\bar\page\pos = (*this\bar\area\len-*this\bar\thumb\len)/2
          EndIf
          
          If *this\bar\fixed And *this\bar\button[#__b_1]\len
            *this\bar\max = *this\bar\area\len + *this\bar\button[#__b_1]\len*2 + Bool(*this\bar\fixed = #__b_1) * 4
          Else
            *this\bar\max = (*this\bar\area\len-*this\bar\thumb\len) - 2
          EndIf
          
          ;if splitter fixed set splitter pos to center
          If *this\bar\fixed = #__b_1
            *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
          EndIf
          If *this\bar\fixed = #__b_2
            *this\bar\button[*this\bar\fixed]\fixed = *this\bar\area\len-*this\bar\thumb\len-*this\bar\page\pos
          EndIf
        EndIf
        
        *this\bar\page\end = (*this\bar\max - *this\bar\page\len)
        *this\bar\area\end = *this\bar\area\pos + (*this\bar\area\len - *this\bar\thumb\len)   
        ; *this\bar\thumb\end = (*this\bar\area\end-*this\bar\area\pos)
        ; (*this\bar\area\len - *this\bar\thumb\len) = (*this\bar\area\end-*this\bar\area\pos)
        ; *this\bar\scroll_increment = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
        *this\bar\scroll_increment = ((*this\bar\area\end-*this\bar\area\pos) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
      EndIf
      
      If *this\bar\fixed And Not *this\bar\page\change
        If *this\bar\button[*this\bar\fixed]\fixed > *this\bar\area\len - *this\bar\thumb\len
          *this\bar\button[*this\bar\fixed]\fixed = *this\bar\area\len - *this\bar\thumb\len
        EndIf
        
        If *this\bar\button[*this\bar\fixed]\fixed < 0
          *this\bar\button[*this\bar\fixed]\fixed = 0
        EndIf
        
        If *this\bar\fixed = #__b_1
          *this\bar\page\pos = 0
        Else
          *this\bar\page\pos = *this\bar\page\end
        EndIf
        _scroll_pos_ = *this\bar\page\pos
      Else
        _scroll_pos_ = _invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted)
      EndIf
      
      *this\bar\thumb\pos = _thumb_pos_(*this\bar, _scroll_pos_)
      
      ; _in_start_
      If *this\bar\button[#__b_1]\len 
        If _scroll_pos_ = *this\bar\min
          *this\bar\button[#__b_1]\color\state = #__s_3
          *this\bar\button[#__b_1]\interact = 0
        Else
          If *this\bar\button[#__b_1]\color\state <> #__s_2
            *this\bar\button[#__b_1]\color\state = #__s_0
          EndIf
          *this\bar\button[#__b_1]\interact = 1
        EndIf 
      EndIf
      
      ; _in_stop_
      If *this\bar\button[#__b_2]\len
        ; Debug ""+ Bool(*this\bar\thumb\pos = *this\bar\area\end) +" "+ Bool(_scroll_pos_ = *this\bar\page\end)
        If _scroll_pos_ = *this\bar\page\end
          *this\bar\button[#__b_2]\color\state = #__s_3
          *this\bar\button[#__b_2]\interact = 0
        Else
          If *this\bar\button[#__b_2]\color\state <> #__s_2
            *this\bar\button[#__b_2]\color\state = #__s_0
          EndIf
          *this\bar\button[#__b_2]\interact = 1
        EndIf 
      EndIf
      
      
      If *this\type = #PB_GadgetType_ScrollBar
        ProcedureReturn Update_Scroll(*this)
      ElseIf *this\type = #PB_GadgetType_ProgressBar
        ProcedureReturn Update_Progress(*this)
      ElseIf *this\type = #PB_GadgetType_TrackBar
        ProcedureReturn Update_Track(*this)
      ElseIf *this\type = #PB_GadgetType_Splitter
        ProcedureReturn Update_Splitter(*this)
      ElseIf *this\type = #PB_GadgetType_Spin
        ProcedureReturn Update_Spin(*this)
      EndIf
    EndProcedure
    
    
    ;-
    Procedure.f GetState(*this._s_widget)
      ProcedureReturn *this\bar\page\pos
    EndProcedure
    
    Procedure.b Change(*bar._s_bar, ScrollPos.f)
      With *bar
        If ScrollPos < \min 
          ; if SetState(height-value or width-value)
          \button[#__b_3]\fixed = ScrollPos
          ScrollPos = \min 
          
        ElseIf \max And ScrollPos > \page\end ; \max-\page\len
          If \max > \page\len 
            ScrollPos = \page\end ; \max-\page\len
          Else
            ScrollPos = \min 
          EndIf
        EndIf
        
        If \page\pos <> ScrollPos
          \page\change = \page\pos - ScrollPos
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
          
          \page\pos = ScrollPos
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b SetPos(*this._s_widget, ThumbPos.i)
      With *this
        If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
        If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
        
        ; \bar\thumb\end = (*this\bar\area\end-*this\bar\area\pos)
        If \bar\thumb\end <> ThumbPos 
          \bar\thumb\end = ThumbPos
          
          ;           If \bar\area\end <> ThumbPos
          ProcedureReturn SetState(*this, _invert_(\bar, _page_pos_(\bar, ThumbPos), \bar\inverted))
          ;           Else
          ;             ProcedureReturn SetState(*this, _invert_(\bar, \bar\page\end, \bar\inverted))
          ;           EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b SetState(*this._s_widget, ScrollPos.f)
      
      If Change(*this\bar, ScrollPos)
        Update(*this)
        
        *this\bar\change = #True
        *this\bar\page\change = #False
        ProcedureReturn #True
      EndIf
      
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
            Case #__bar_minimum
              If \bar\min <> Value
                \bar\area\change = \bar\min - Value
                If \bar\page\pos < Value
                  \bar\page\pos = Value
                EndIf
                \bar\min = Value
                ;Debug  " min "+\bar\min+" max "+\bar\max
                Result = #True
              EndIf
              
            Case #__bar_maximum
              If \bar\max <> Value
                \bar\area\change = \bar\max - Value
                If \bar\min > Value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = Value
                EndIf
                
                If Not \bar\max
                  \bar\page\pos = \bar\max
                EndIf
                ;Debug  "   min "+\bar\min+" max "+\bar\max
                
                ;\bar\page\change = #True
                Result = #True
              EndIf
              
            Case #__bar_pagelength
              If \bar\page\len <> Value
                \bar\area\change = \bar\page\len - Value
                \bar\page\len = Value
                
                If Not \bar\max
                  If \bar\min > Value
                    \bar\max = \bar\min + 1
                  Else
                    \bar\max = Value
                  EndIf
                EndIf
                
                Result = #True
              EndIf
              
            Case #__bar_buttonsize
              If \bar\button[#__b_3]\len <> Value
                \bar\button[#__b_3]\len = Value
                
                If \type = #PB_GadgetType_ScrollBar
                  \bar\button[#__b_1]\len = Value
                  \bar\button[#__b_2]\len = Value
                EndIf
                
                Result = #True
              EndIf
              
            Case #__bar_inverted
              \bar\inverted = Bool(Value)
              ProcedureReturn Update(*this)
              
            Case #__bar_scrollstep 
              \bar\scroll_step = Value
              
          EndSelect
        EndIf
        
        If Result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\page\change = #True
                  ;Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
          \hide = Update(*this)
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    
    ;-
    Procedure.b Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
      With *scroll
        Protected iHeight, iWidth
        
        If Not *scroll\v Or Not *scroll\h
          ProcedureReturn
        EndIf
        
        If y=#PB_Ignore : y = \v\y-\v\parent\y[#__c_2] : EndIf
        If x=#PB_Ignore : x = \h\x-\v\parent\x[#__c_2] : EndIf
        If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
        If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
        
        If Bar::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
          *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, y, #PB_Ignore, _get_page_height_(*scroll, 1))
        EndIf
        
        If Bar::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
          *scroll\h\hide = Bar::Resize(*scroll\h, x, #PB_Ignore, _get_page_width_(*scroll, 1), #PB_Ignore)
        EndIf
        
        If Bar::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
          *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, _get_page_height_(*scroll, 1))
        EndIf
        
        If Bar::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
          *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, _get_page_width_(*scroll, 1), #PB_Ignore)
        EndIf
        
        If Width+x-*scroll\v\width <> *scroll\v\x[#__c_3]
          *scroll\v\hide = Bar::Resize(*scroll\v, Width+x-*scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        If Height+y-*scroll\h\height <> *scroll\v\y[#__c_3]
          *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, Height+y-*scroll\h\height, #PB_Ignore, #PB_Ignore)
        EndIf
        
        ProcedureReturn #True
      EndWith
    EndProcedure
    
    Procedure.b Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
      CompilerIf Defined(widget, #PB_Module)
        ProcedureReturn widget::Resize(*this, X,Y,Width,Height)
      CompilerElse
        Protected.l Change_x, Change_y, Change_width, Change_height
        
        With *this
          If X<>#PB_Ignore 
            If \parent 
              \x[#__c_3] = X 
              X+\parent\x[#__c_2] 
            EndIf 
            
            If \x <> X 
              Change_x = x-\x 
              \x = X 
              \x[#__c_2] = \x+\bs 
              \x[#__c_1] = \x[#__c_2]-\fs 
              
              If \parent 
                If \parent\x[#__c_2] > \x And 
                   \parent\x[#__c_2] > \parent\x[#__c_4]
                  \x[#__c_4] = \parent\x[#__c_2]
                ElseIf \parent\x[#__c_4] > \x 
                  \x[#__c_4] = \parent\x[#__c_4]
                Else
                  \x[#__c_4] = \x
                EndIf
              Else
                \x[#__c_4] = \x
              EndIf
              
              \resize | #__resize_x | #__resize_change
            EndIf 
          EndIf  
          
          If Y<>#PB_Ignore 
            If \parent 
              \y[#__c_3] = y 
              y+\parent\y[#__c_2] 
            EndIf 
            
            If \y <> y 
              Change_y = y-\y 
              \y = y 
              \y[#__c_1] = \y+\bs-\fs 
              \y[#__c_2] = \y+\bs+\__height
              
              If \parent 
                If \parent\y[#__c_2] > \y And 
                   \parent\y[#__c_2] > \parent\y[#__c_4]
                  \y[#__c_4] = \parent\y[#__c_2]
                ElseIf \parent\y[#__c_4] > \y 
                  \y[#__c_4] = \parent\y[#__c_4]
                Else
                  \y[#__c_4] = \y
                EndIf
              Else
                \y[#__c_4] = \y
              EndIf
              
              \resize | #__resize_y | #__resize_change
            EndIf 
          EndIf  
          
          If width <> #PB_Ignore 
            If width < 0 : width = 0 : EndIf
            
            If \width <> width 
              Change_width = width-\width 
              \width = width 
              \width[#__c_2] = \width-\bs*2 
              \width[#__c_1] = \width[#__c_2]+\fs*2 
              If \width[#__c_1] < 0 : \width[#__c_1] = 0 : EndIf
              If \width[#__c_2] < 0 : \width[#__c_2] = 0 : EndIf
              \width[#__c_3] = \width[#__c_2]
              \resize | #__resize_width | #__resize_change
            EndIf 
          EndIf  
          
          If Height <> #PB_Ignore 
            If Height < 0 : Height = 0 : EndIf
            
            If \height <> Height 
              Change_height = height-\height 
              \height = Height 
              \height[#__c_1] = \height-\bs*2+\fs*2 
              \height[#__c_2] = \height-\bs*2-\__height
              If \height[#__c_1] < 0 : \height[#__c_1] = 0 : EndIf
              If \height[#__c_2] < 0 : \height[#__c_2] = 0 : EndIf
              \height[#__c_3] = \height[#__c_2]
              \resize | #__resize_height | #__resize_change
            EndIf 
          EndIf 
          
          
          If \resize & #__resize_change
            If \parent
              If \parent\x[#__c_2]+\parent\width[#__c_3] < \x+\width And 
                 \parent\x[#__c_2]+\parent\width[#__c_3] < \parent\x[#__c_4]+\parent\width[#__c_4]
                \width[#__c_4] = \parent\x[#__c_2]+\parent\width[#__c_3] - \x[#__c_4]
              ElseIf \parent\x[#__c_4]+\parent\width[#__c_4] > \x+\width 
                \width[#__c_4] = \parent\x[#__c_4]+\parent\width[#__c_4] - \x[#__c_4]
              Else
                \width[#__c_4] = \width
              EndIf
              
              If \parent\y[#__c_2]+\parent\height[#__c_3] < \y+\height And 
                 \parent\y[#__c_2]+\parent\height[#__c_3] < \parent\y[#__c_4]+\parent\height[#__c_4]
                \height[#__c_4] = \parent\y[#__c_2]+\parent\height[#__c_3] - \y[#__c_4]
              ElseIf \parent\y[#__c_4]+\parent\height[#__c_4] > \y+\height 
                \height[#__c_4] = \parent\y[#__c_4]+\parent\height[#__c_4] - \y[#__c_4]
              Else
                \height[#__c_4] = \height
              EndIf
              
            Else
              \width[#__c_4] = \width
              \height[#__c_4] = \height
            EndIf
            
            If (Change_x Or Change_y)
              If (*this\scroll And *this\scroll\v And *this\scroll\h)
                Resize(*this\scroll\v, *this\scroll\v\x[#__c_3], *this\scroll\v\y[#__c_3], #PB_Ignore, #PB_Ignore)
                Resize(*this\scroll\h, *this\scroll\h\x[#__c_3], *this\scroll\h\y[#__c_3], #PB_Ignore, #PB_Ignore)
              EndIf
              
              If *this\container And *this\count\childrens
                _move_childrens_(*this, 0,0)
              EndIf
            EndIf
            
            If (Change_width Or Change_height)
              ; Resize vertical&horizontal scrollbars
              If (\scroll And \scroll\v And \scroll\h)
                Resizes(\scroll, 0, 0, \width[#__c_2], \height[#__c_2])
                
                \width[#__c_3] = \scroll\h\bar\page\len
                \height[#__c_3] = \scroll\v\bar\page\len
              EndIf
            EndIf
          EndIf
          
          ProcedureReturn Update(*this)
        EndWith
      CompilerEndIf
    EndProcedure
    
    Procedure SetParent(*this._s_widget, *Parent._s_widget, parent_item.l=0)
      CompilerIf Defined(widget, #PB_Module)
        ProcedureReturn widget::SetParent(*this, *Parent, parent_item)
      CompilerElse
        *event\widget = *this
        *this\parent = *Parent
        
        If *this\parent
          ;Debug Bool(*this\parent\type = #PB_GadgetType_ScrollArea)
          
          *this\root = *this\parent\root
          *this\window = *this\parent\window
          *this\parent\count\childrens + 1
        EndIf
        
;         If *this <> *Parent And *Parent And *Parent\container
;           AddElement(*Parent\childrens()) 
;           *Parent\childrens() = *this
;         EndIf
        
        AddElement(*event\childrens()) : *event\childrens() = *this
      CompilerEndIf
    EndProcedure
    
    
    ;-
    Procedure.i CloseList()
      If Root()\opened And 
         Root()\opened\parent And
         Root()\opened\root\canvas = Root()\canvas 
        
        ; Debug ""+Root()\opened+" - "+Root()\opened\class+" "+Root()\opened\parent+" - "+Root()\opened\parent\class
        Root()\opened = Root()\opened\parent
      Else
        Root()\opened = Root()
      EndIf
    EndProcedure
    
    Procedure.i OpenList(*this._s_widget, Item.l=0)
      Protected result.i = Root()\opened
      
      If *this
        If *this\type = #__Type_Window
          *this\window = *this
        EndIf
        
        Root()\opened = *this
        Root()\opened\tab\opened = Item
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
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
      *this\event = AllocateStructure(_s_event)
      *this\event\type = eventtype
      *this\event\callback = *callBack
    EndProcedure
    
    Procedure.b Events(*this._s_widget, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
      Protected Result, from =- 1 
      Static cursor_change, LastX, LastY, Last, *leave._s_widget, Down
      
      Macro _callback_(_this_, _type_)
        Select _type_
          Case #__Event_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
            _this_\bar\button[_this_\from]\color\state = #__s_0 
            
            If _this_\cursor And cursor_change
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
              cursor_change = 0
            EndIf
            
          Case #__Event_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
            _this_\bar\button[_this_\from]\color\state = #__s_1 
            
            ; Set splitter cursor
            If _this_\from = #__b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
              cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
            EndIf
            
          Case #__Event_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
            _this_\bar\button[_this_\from]\color\state = #__s_1 
            
        EndSelect
      EndMacro
      
      With *this
        ; from the very beginning we'll process 
        ; the splitter children’s widget
        If \splitter And \from <> #__b_3
          If \splitter\first And Not \splitter\g_first ;And _from_point_(mouse_x, mouse_y, \splitter\first)
            If events(\splitter\first, EventType, mouse_x, mouse_y)
              ProcedureReturn 1
            EndIf
          EndIf
          If \splitter\second And Not \splitter\g_second ;And _from_point_(mouse_x, mouse_y, \splitter\second)
            If events(\splitter\second, EventType, mouse_x, mouse_y)
              ProcedureReturn 1
            EndIf
          EndIf
        EndIf
        
        ; todo
        If (\scroll And \scroll\v And \scroll\h)
          If Events(\scroll\v, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
          If Events(\scroll\h, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
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
            
            If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
              Select from
                Case #__b_1, #__b_2
                  from = 0
                  
              EndSelect
              ; ElseIf \type = #PB_GadgetType_ProgressBar
              ;  
            EndIf
          Else
            from =- 1; 0
          EndIf 
          
          If \from <> from And Not Down
            If *leave > 0 And *leave\from >= 0 And *leave\bar\button[*leave\from]\interact And 
               Not _from_point_(mouse_x, mouse_y, *leave\bar\button[*leave\from])
              
              _callback_(*leave, #__Event_MouseLeave)
              *leave\from =- 1; 0
              
              Result = #True
            EndIf
            
            ; If from > 0
            \from = from
            *leave = *this
            ; EndIf
            
            If \from >= 0 And \bar\button[\from]\interact
              _callback_(*this, #__Event_MouseEnter)
              
              Result = #True
            EndIf
          EndIf
          
        Else
          If \from >= 0 And \bar\button[\from]\interact
            If EventType = #__Event_LeftButtonUp
              ; Debug ""+#PB_Compiler_Line +" Мышь up"
              _callback_(*this, #__Event_LeftButtonUp)
            EndIf
            
            ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
            _callback_(*this, #__Event_MouseLeave)
            
            Result = #True
          EndIf 
          
          \from =- 1
          
          If *leave = *this
            *leave = 0
          EndIf
        EndIf
        
        ; get
        Select EventType
          Case #__Event_MouseWheel
            If *This = *event\active
              If \bar\vertical
                Result = SetState(*This, (\bar\page\pos + Wheel_Y))
              Else
                Result = SetState(*This, (\bar\page\pos + Wheel_X))
              EndIf
            EndIf
            
          Case #__Event_MouseLeave 
            If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
            
          Case #__Event_LeftButtonUp : Down = 0 : LastX = 0 : LastY = 0
            
            If \from >= 0 And \bar\button[\from]\interact
              _callback_(*this, #__Event_LeftButtonUp)
              
              If from =- 1
                _callback_(*this, #__Event_MouseLeave)
                \from =- 1
              EndIf
              
              Result = #True
            EndIf
            
          Case #__Event_LeftButtonDown
            If *leave = *this And Not _is_scroll_bar_(*this)
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
              ; Debug "  "+*this +"  "+ *this\parent +" - get parent bar()"
              
              If \bar\button[from]\interact
                \bar\button[\from]\color\state = #__s_2
                
                Select \from
                  Case #__b_1 
                    If \bar\inverted
                      Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scroll_step), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                    Else
                      Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scroll_step), \bar\inverted))
                    EndIf
                    
                  Case #__b_2 
                    If \bar\inverted
                      Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scroll_step), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                    Else
                      Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scroll_step), \bar\inverted))
                    EndIf
                    
                  Case #__b_3 
                    LastX = mouse_x - \bar\thumb\pos 
                    LastY = mouse_y - \bar\thumb\pos
                    Result = #True
                    
                EndSelect
                
                SetWindowTitle(EventWindow(), Str(*this\bar\page\pos) +" "+ Str(*this\bar\thumb\pos-*this\bar\area\pos))
              Else
                Result = #True
              EndIf
            EndIf
            
          Case #__Event_MouseMove
            If Down And *leave = *this And Bool(LastX|LastY) 
              If \bar\vertical
                Result = SetPos(*this, (mouse_y-LastY))
              Else
                Result = SetPos(*this, (mouse_x-LastX))
              EndIf
              
              SetWindowTitle(EventWindow(), Str(*this\bar\page\pos) +" "+ Str(*this\bar\thumb\pos-*this\bar\area\pos))
            EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    
    ;-
    Procedure.i Create(type.l, *parent._s_widget, size.l, *param_1, *param_2, *param_3, flag.i=0, round.l=7, scroll_step.f=1.0)
      Protected x,y,*this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        \x =- 2147483648
        \y =- 2147483648
        \type = type
        \adress = *this
        \class = #PB_Compiler_Procedure
      
        CompilerIf Defined(widget, #PB_Module)
          widget::_set_last_parameters_(*this, *this\type, Flag, *parent)
        CompilerElse
          ;  SetParent(*this, *parent)
          *this\root = *parent\root
        CompilerEndIf
        
        \round = round
        \bar\scroll_step = scroll_step
        
        \color\alpha = 255
        \color\alpha[1] = 0
        \color\state = 0
        \color\back = $FFF9F9F9
        \color\frame = \color\back
        \color\line = $FFFFFFFF
        \color\front = $FFFFFFFF
        
        \bar\button[#__b_1]\color = _get_colors_()
        \bar\button[#__b_2]\color = _get_colors_()
        \bar\button[#__b_3]\color = _get_colors_()
        
        \bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
        
        ;- Create Scroll
        If \type = #PB_GadgetType_ScrollBar
          If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
             Flag & #__Bar_Vertical = #__Bar_Vertical
            \bar\vertical = #True
          EndIf
          
          If Not Flag & #__bar_nobuttons = #__bar_nobuttons
            \bar\button[#__b_3]\len = size
            \bar\button[#__b_1]\len =- 1
            \bar\button[#__b_2]\len =- 1
          EndIf
          
          \bar\button[#__b_1]\interact = #True
          \bar\button[#__b_2]\interact = #True
          \bar\button[#__b_3]\interact = #True
          
          \bar\button[#__b_1]\round = \round
          \bar\button[#__b_2]\round = \round
          \bar\button[#__b_3]\round = \round
          
          \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
          
          \bar\button[#__b_1]\arrow\size = #__arrow_size
          \bar\button[#__b_2]\arrow\size = #__arrow_size
          \bar\button[#__b_3]\arrow\size = 3
        EndIf
        
        ;- Create Track
        If \Type = #PB_GadgetType_TrackBar
          If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or
             Flag & #__Bar_Vertical = #__Bar_Vertical
            \bar\vertical = #True
            \bar\inverted = #True
          EndIf
          
          If flag & #PB_TrackBar_Ticks = #PB_TrackBar_Ticks Or
             Flag & #__bar_ticks = #__bar_ticks
            \bar\mode =  #PB_TrackBar_Ticks
          EndIf
          
          \bar\button[#__b_3]\interact = #True
          
          \bar\button[#__b_1]\len =- 1
          \bar\button[#__b_2]\len =- 1
          \bar\button[#__b_3]\len = 15
          
          \bar\button[#__b_3]\arrow\size = #__arrow_size
          \bar\button[#__b_3]\arrow\type = #__arrow_type
          
          \bar\button[#__b_1]\round = 2
          \bar\button[#__b_2]\round = 2
          \bar\button[#__b_3]\round = \round
          
          If \round < 7
            \bar\button[#__b_3]\len = 9
          EndIf
        EndIf
        
        ;- Create Spin
        If \Type = #PB_GadgetType_Spin
          If Not (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                  Flag & #__Bar_Vertical = #__Bar_Vertical)
            \bar\vertical = #True
            \bar\inverted = #True
          EndIf
          
          \fs = Bool(Not Flag&#__flag_borderless)
          \bs = \fs
          
          ; \text = AllocateStructure(_s_text)
          \text\change = 1
          \text\editable = 1
          \text\align\Vertical = 1
          \text\_padding = #__spin_padding_text
          
          \color = _get_colors_()
          \color\alpha = 255
          \color\back = $FFFFFFFF
          
          ;\bar\button[#__b_3]\len = Size
          \bar\button[#__b_1]\len = Size
          \bar\button[#__b_2]\len = Size
          
          \bar\button[#__b_1]\arrow\size = #__arrow_size
          \bar\button[#__b_2]\arrow\size = #__arrow_size
          
          \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        EndIf
        
        ;- Create Splitter
        If \type = #PB_GadgetType_Splitter
          If (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
              Flag & #__Bar_Vertical = #__Bar_Vertical)
            \cursor = #PB_Cursor_LeftRight
          Else
            \bar\vertical = #True
            \cursor = #PB_Cursor_UpDown
          EndIf
          
          If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
            \bar\fixed = #__b_1 
          ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
            \bar\fixed = #__b_2 
          EndIf
          
          \bar\mode = #PB_Splitter_Separator
          
          \index[#__s_1] =- 1
          \index[#__s_2] = 0
          \container = \type
          
          \bar\button[#__b_3]\len = size
          \bar\button[#__b_3]\round = 2
          \bar\button[#__b_3]\interact = #True
          
          \splitter = AllocateStructure(_s_splitter)
          \splitter\first = *param_1 : *param_1 = 0
          \splitter\second = *param_2 : *param_2 = 0
          
          \splitter\g_first = Bool(IsGadget(\splitter\first))
          \splitter\g_second = Bool(IsGadget(\splitter\second))
          
          If \splitter\first And Not \splitter\g_first
            SetParent(\splitter\first, *this)
          EndIf
          
          If \splitter\second And Not \splitter\g_second
            SetParent(\splitter\second, *this)
          EndIf
        EndIf
        
        ;
      ;  If \type <> #PB_GadgetType_Splitter
          If *param_1 
            SetAttribute(*this, #__bar_minimum, *param_1) 
          EndIf
          If *param_2 
            SetAttribute(*this, #__bar_maximum, *param_2) 
          EndIf
          If *param_3 
            SetAttribute(*this, #__bar_pageLength, *param_3) 
          EndIf
      ;  EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    ;-
    Procedure Area(*scroll._s_scroll, *parent, size.l, round.l, scroll_step.l, mode.l=1, type.l=#PB_GadgetType_ScrollBar)
      
      *scroll\v = Bar::Create(type, *parent, size, 0,0,0, #__bar_vertical, round, scroll_step)
      *scroll\h = Bar::Create(type, *parent, Bool(mode)*size, 0,0,0, 0, round, scroll_step)
      
      ProcedureReturn *scroll
    EndProcedure
    
    Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
      Protected *this._s_widget = Create(#PB_GadgetType_Spin, *event\root\opened, 16, min,max,0, flag, round, Increment)
      *this\class = #PB_Compiler_Procedure
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      Protected *this._s_widget = Create(#PB_GadgetType_ScrollBar, *event\root\opened, #__scroll_buttonsize, min,max,pagelength, flag, round, 1.0)
      *this\class = #PB_Compiler_Procedure
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\round = round
      *this\adress = *this
      *this\bar\scroll_step = 1.0
      *this\class = #PB_Compiler_Procedure
      *this\type = #PB_GadgetType_ProgressBar
      
;       *this\color\alpha = 255
;       *this\color\alpha[1] = 0
;       *this\color\state = 0
;       *this\color\back = $FFF9F9F9
;       *this\color\frame = *this\color\back
;       *this\color\line = $FFFFFFFF
;       *this\color\front = $FFFFFFFF
      
      *this\color = _get_colors_()
      *this\bar\button[#__b_1]\color = _get_colors_()
      *this\bar\button[#__b_2]\color = _get_colors_()
      *this\bar\button[#__b_3]\color = _get_colors_()
      
      *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
      
      If *this\type = #PB_GadgetType_ProgressBar
        If Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or
           Flag & #__Bar_Vertical = #__Bar_Vertical
          *this\bar\vertical = #True
          *this\bar\inverted = #True
        EndIf
        
        *this\bar\button[#__b_1]\round = *this\round
        *this\bar\button[#__b_2]\round = *this\round
        
        *this\text\change = #True
        *this\text\align\vertical = #True
        *this\text\align\horizontal = #True
      EndIf
      
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      
      If Min 
        SetAttribute(*this, #__bar_minimum, Min) 
      EndIf
      If Max 
        SetAttribute(*this, #__bar_maximum, Max) 
      EndIf
      
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
      Protected *this._s_widget = Create(#PB_GadgetType_TrackBar, *event\root\opened, #__scroll_buttonsize, min,max,0, flag, round, 1.0)
      *this\class = #PB_Compiler_Procedure
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i,Second.i, Flag.i=0)
      Protected *this._s_widget = Create(#PB_GadgetType_Splitter, *event\root\opened, #__splitter_buttonsize, first,second,0, flag, 0, 1.0)
      *this\class = #PB_Compiler_Procedure
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      *this\class = #PB_Compiler_Procedure
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, #__Type_ScrollArea, Flag, Root()\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      
      With *this
        ; first change default XY
        \x =- 2147483648
        \y =- 2147483648
        \type = #PB_GadgetType_ScrollArea
        \container = 1
        \index[#__s_1] =- 1
        \index[#__s_2] = 0
        
        \color = _get_colors_()
        \color\back = $FFF9F9F9
        
        \fs = Bool(Not Flag&#__flag_borderless) * #__border_scroll
        \bs = \fs
        
        ;         ; \scroll = AllocateStructure(_s_scroll) 
        \scroll\v = bar::create(#__Type_ScrollBar, *this, Size, 0,Scroll_AreaHeight,Height, #__bar_vertical, 7, scroll_step)
        \scroll\h = bar::create(#__Type_ScrollBar, *this, Size, 0,Scroll_AreaWidth,Width, 0, 7, scroll_step)
        \scroll\v\parent = *this
        \scroll\h\parent = *this
        
        ; SetParent(\scroll\v, *this)
       ; SetParent(\scroll\h, *this)
      ;Area(\scroll, *this, Size, 7)
        
        Resize(*this, X,Y,Width,Height)
        If constants::_check_(flag, #__flag_noGadget, #False)
          OpenList(*this)
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    
    ;- 
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
    
    Procedure Events_CanvasWindow()
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
      Protected *event._s_event = GetGadgetData(Canvas)
      ;     Protected *this._s_widget = GetGadgetData(Canvas)
      ;Protected wheel_X, wheel_Y
      
      If EventType = #__Event_MouseWheel
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          Protected wheel_X.CGFloat = GetWheelDeltaX()
          Protected wheel_Y.CGFloat = GetWheelDeltaY()
        CompilerElse
          Protected wheel_X
          Protected wheel_Y
        CompilerEndIf
      EndIf
      
      Select EventType
        Case #__Event_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                             ;          ForEach *event\childrens()
                             ;            Resize(*event\childrens(), #PB_Ignore, #PB_Ignore, Width, Height)  
                             ;          Next
          Repaint = 1
          
        Case #__Event_LeftButtonDown
          SetActiveGadget(Canvas)
          
      EndSelect
      
      ForEach *event\childrens()
        Repaint | events(*event\childrens(), EventType, MouseX, MouseY, wheel_X, wheel_Y)
        
        If *event\childrens()\bar\change
          ;SetWindowTitle(EventWindow(), Str(*event\childrens()\bar\page\pos)+" - Splitter demo")
          
          *event\childrens()\bar\change = 0
        EndIf
      Next
      
      If Repaint 
        ReDraw(*event\root)
      EndIf
    EndProcedure
    
    Procedure Resize_CanvasWindow()
      ResizeGadget(GetWindowData(EventWindow()), #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()), WindowHeight(EventWindow()))
    EndProcedure
    
    Procedure Open_CanvasWindow(Window, X.l, Y.l, Width.l, Height.l, Title.s, Flag.i, ParentID.i)
      Protected w = OpenWindow(Window, X, Y, Width, Height, Title, Flag, ParentID) : If Window =- 1 : Window = w : EndIf
      Protected g_Canvas = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Container) ;: CloseGadgetList()
      BindGadgetEvent(g_Canvas, @Events_CanvasWindow())
      PostEvent(#PB_Event_Gadget, Window, g_Canvas, #__Event_Resize)
      
      *event\root = AllocateStructure(_s_root)
      *event\root\class = "Root"
      *event\root\opened = *event\root
      *event\root\window = Window
      *event\root\canvas = g_Canvas
      
      *event\active = *event\root
      *event\active\root = *event\root
      
      SetGadgetData(g_Canvas, *event)
      SetWindowData(Window, g_Canvas)
      BindEvent(#PB_Event_SizeWindow, @Resize_CanvasWindow(), Window);, g_Canvas)
      ProcedureReturn g_Canvas
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf

;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
    bar::Open_CanvasWindow(Window, X, Y, Width, Height, Title, Flag, ParentID)
  EndMacro
  
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    ;ProcedureReturn
    ForEach *event\childrens()
      If *event\childrens()\bar\vertical And *event\childrens()\type = GadgetType(EventGadget())
        Repaint | SetState(*event\childrens(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(*event\root)
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    ;ProcedureReturn
    ForEach *event\childrens()
      If Not *event\childrens()\bar\vertical And *event\childrens()\type = GadgetType(EventGadget())
        Repaint | SetState(*event\childrens(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(*event\root)
    EndIf
  EndProcedure
  
  Procedure v_CallBack(GetState, type)
    ;ProcedureReturn
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(2, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(12, GetState)
      Case #PB_GadgetType_ProgressBar
        ;SetGadgetState(22, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_4, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure h_CallBack(GetState, type)
    ;ProcedureReturn
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(1, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(11, GetState)
      Case #PB_GadgetType_ProgressBar
        ;SetGadgetState(21, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_3, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure ev()
    Debug ""+Widget() ;+" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    ;Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ; example scroll gadget bar
    TextGadget       (-1,  10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/150)",#PB_Text_Center)
    ScrollBarGadget  (1,  10, 42, 250,  20, 30, 150, 30)
    SetGadgetState   (1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (2, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (2, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ; example scroll widget bar
    TextGadget       (-1,  300+10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/150)",#PB_Text_Center)
    Bar::Scroll  (300+10, 42, 250,  20, 30, 150, 30, 0)
    Bar::SetState   (Widget(),  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    Bar::Scroll  (300+10, 42+30, 250,  10, 30, 150, 30, #__bar_inverted, 7)
    Bar::SetState   (Widget(),  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    Bar::Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    Bar::SetState   (Widget(), 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    Bar::Scroll  (300+270+30, 10,  25, 120 ,0, 300, 50, #__bar_vertical|#__bar_inverted, 7)
    Bar::SetState   (Widget(), 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(2,@v_GadgetCallBack())
    ; Bind(@ev(), Widget())
    
    
    ; example_2 track gadget bar
    TextGadget    (-1, 10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(10, 10,  140+40, 250, 20, 0, 10000)
    SetGadgetState(10, 5000)
    TextGadget    (-1, 10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     TrackBarGadget(11, 10, 140+120, 250, 20, 0, 30, #PB_TrackTicks)
    TrackBarGadget(11, 10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetGadgetState(11, 60)
    TextGadget    (-1,  60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(12, 270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(12, 8000)
    
    ; example_2 track widget bar
    TextGadget    (-1, 300+10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    Bar::Track(300+10,  140+40, 250, 20, 0, 10000, 0)
    Bar::SetState(Widget(), 5000)
    Bar::Track(300+10,  140+40+20, 250, 20, 0, 10000, #__bar_inverted)
    Bar::SetState(Widget(), 5000)
    TextGadget    (-1, 300+10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     Bar::Track(300+10, 140+120, 250, 20, 0, 30, #__bar_ticks)
    Bar::Track(300+10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    Bar::SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    Bar::Track(300+270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    Bar::SetAttribute(Widget(), #__bar_Inverted, 0)
    Bar::SetState(Widget(), 8000)
    Bar::Track(300+270+30, 140+10, 25, 170, 0, 10000, #__bar_vertical|#__bar_inverted)
    Bar::SetState(Widget(), 8000)
    
    BindGadgetEvent(11,@h_GadgetCallBack())
    BindGadgetEvent(12,@v_GadgetCallBack())
    
    ; example_3 progress gadget bar
    TextGadget       (-1,  10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    ProgressBarGadget  (21,  10, 140+200+42, 250,  20, 30, 100)
    SetGadgetState   (21,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ProgressBarGadget  (22, 270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState   (22, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ; example_3 progress widget bar
    TextGadget       (-1,  300+10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    Bar::Progress  (300+10, 140+200+42, 250,  20, 30, 100, 0)
    Bar::SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    Bar::Progress  (300+10, 140+200+42+30, 250,  10, 30, 100, #__bar_inverted, 4)
    Bar::SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    Bar::Progress  (300+270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical, 19)
    Bar::SetAttribute(Widget(), #__bar_Inverted, 0)
    Bar::SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    Bar::Progress  (300+270+30, 140+200,  25, 120 ,0, 300, #__bar_vertical|#__bar_inverted)
    Bar::SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(21,@h_GadgetCallBack())
    BindGadgetEvent(22,@v_GadgetCallBack())
    
    ;{ PB splitter Gadget
    Button_0 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 0, 100) ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1")  ; as they will be sized automatically
    
    Button_2 = SpinGadget(#PB_Any, 0, 0, 0, 0, 0,20) ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    SetGadgetState(Button_0, 50)
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 20)
    ;     ;SetGadgetState(Splitter_1, 20)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
    SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
    ;}
    
    Button_0 = Bar::Spin(0, 0, 0, 0, 0, 20) ; No need to specify size or coordinates
    Button_1 = Bar::Scroll(0, 0, 0, 0, 10, 100, 50); No need to specify size or coordinates
    Button_2 = Bar::ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    Button_3 = Bar::Progress(0, 0, 0, 0, 0, 100, 30)           ; as they will be sized automatically
    
    Button_4 = Bar::Progress(0, 0, 0, 0, 40,100) ; as they will be sized automatically
    Button_5 = Bar::Spin(0, 0, 0, 0, 50,100, #__bar_vertical) ; as they will be sized automatically
    
    Bar::SetState(Button_0, 50)
    
    Splitter_0 = Bar::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Bar::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    Bar::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 20)
    Bar::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 20)
    ;Bar::SetState(Splitter_1, 410/2-20)
    Splitter_2 = Bar::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Bar::Splitter(300+10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    ; Bar::SetState(Button_2, 5)
    Bar::SetState(Button_5, 65)
    
    If OpenList(Button_2)
      Button_4 = Bar::ScrollArea(-1, -1, 50, 50, 100, 100, 1);, #__flag_noGadget)
;       Define i
;       For i=0 To 1000
        Bar::Progress(10, 10, 50, 30, 11, 100, 30)
;       Next
      CloseList()
      Bar::Progress(100, 10, 50, 30, 1, 100, 30)
      CloseList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---8------------+-V-----------------fv48---v-----f---f--------
; EnableXP