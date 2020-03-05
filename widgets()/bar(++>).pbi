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
      structures::*event\root
    EndMacro
    
    Macro Widget()
      structures::*event\widget
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
      ;Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;Bar::Resizes(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      ;Bar::Updates(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      _this_\scroll\v\bar\area\change = #False
      _this_\scroll\h\bar\area\change = #False
    EndMacro
    
    Macro _page_pos_(_bar_, _thumb_pos_)
      (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\scroll_increment, #PB_Round_Nearest))
    EndMacro
    
    Macro _thumb_pos_(_bar_, _scroll_pos_)
      (_bar_\area\pos + Round(((_scroll_pos_) - _bar_\min) * _bar_\scroll_increment, #PB_Round_Nearest)) 
      
      If (_bar_\fixed And Not _bar_\thumb\change)
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
      If _bar_\thumb\change
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
                   *event\childrens()\x[#__c_3] + (_change_x_),
                   *event\childrens()\y[#__c_3] + (_change_y_), 
                   #PB_Ignore, #PB_Ignore)
          EndIf
        Next
        PopListPosition(*event\childrens())
      EndIf
    EndMacro
    
    Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
      Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
            _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
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
    Declare.l GetAttribute(*this._s_widget, Attribute.l)
    
    Declare.i Track(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Declare.i Progress(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Declare.i Spin(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
    Declare.i Scroll(x.l, y.l, width.l, height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Splitter(x.l, y.l, width.l, height.l, First.i, Second.i, Flag.i=0)
    
    Declare.i _create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scroll_step.f=1.0)
    Declare.i  Create(type.l, *parent, size.l, *param_1, *param_2, *param_3, flag.i=0, round.l=7, scroll_step.f=1.0)
    
    Declare.b Events(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
    Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
    
    Declare   Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
    Declare   Resizes(*scroll._S_scroll, x.l, y.l, width.l, height.l)
    Declare   AddItem(*this, Item.i, Text.s, Image.i=-1, sublevel.i=0)
    
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Declare.b Bind(*callBack, *this._s_widget, eventtype.l=#PB_All)
    
    Declare   Tab(x.l, y.l, width.l, height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare   Canvas(Window, X.l, Y.l, Width.l, Height.l, Flag.i=#Null, *CallBack=#Null)
    
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l=0)
    Declare   ScrollArea(x.l, y.l, width.l, height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
    Declare   Open_Window(Window, X.l, Y.l, Width.l, Height.l, Title.s, Flag.i, ParentID.i)
  EndDeclareModule
  
  Module bar
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
        
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4], $FF00FF00)
        
      EndWith 
    EndProcedure
    
    Procedure.b Draw_Tab(*this._s_widget)
      With *this
        
        If Not \hide And \color\alpha
          If \color\back <> - 1
            ; Draw scroll bar background
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ForEach \tab\_s()
            If \tab\_s()\text\change
              \tab\_s()\x = \bar\max + 1
              \tab\_s()\text\width = 40;TextWidth(\tab\_s()\text\string)
              \tab\_s()\text\height = TextHeight("A")
              \tab\_s()\text\x = \tab\_s()\x + 4
              \tab\_s()\text\y = \tab\_s()\y + (\tab\_s()\height - \tab\_s()\text\height)/2
              
              \tab\_s()\width = \tab\_s()\text\width
              \bar\max + \tab\_s()\width + Bool(\tab\_s()\index <> \count\items - 1) + Bool(\tab\_s()\index = \count\items - 1)*2
              \tab\_s()\text\change = 0
            EndIf
          Next
          
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          ForEach \tab\_s()
            ; Draw thumb
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,x+\tab\_s()\x,\bar\button[#__b_3]\y,\tab\_s()\width,\bar\button[#__b_3]\height,
                           \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
            
            ; Draw thumb frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(x+\tab\_s()\x,\bar\button[#__b_3]\y,\tab\_s()\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(x+\tab\_s()\text\x, y+\tab\_s()\text\y,\tab\_s()\text\string, $FF000000)
          Next
          
          ;         ; Draw thumb
          ;           DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          ;           _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+20,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
          ;                          \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
          ;           
          ;           ; Draw thumb frame
          ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ;           RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+20,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
          
          
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
          
          
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4], $FF00FF00)
        
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
        If \width[#__c_4] > 0 And \height[#__c_4] > 0
          ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          
          If \text 
            If \text\fontID 
              DrawingFont(\text\fontID)
            EndIf
            
            If \text\change
              *this\text\height = TextHeight("A")
              *this\text\width = TextWidth(*this\text\string)
              
              If *this\type = #PB_GadgetType_ProgressBar
                *this\text\rotate = (Bool(*this\bar\vertical And *this\bar\inverted) * 90) +
                                    (Bool(*this\bar\vertical And Not *this\bar\inverted) * 270)
              EndIf
              
              _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
            EndIf
          EndIf
          
          Select \type
            Case #PB_GadgetType_Spin        : Draw_Spin(*this)
            Case #PB_GadgetType_TabBar    : Draw_Tab(*this)
            Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
            Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
            Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
            Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
            Case #PB_GadgetType_ScrollArea  : Draw_ScrollArea(*this)
          EndSelect
          
          ;           DrawingMode(#PB_2DDrawing_Outlined)
          ;           Box(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4], $FF00FF00)
          ;           
          If *this\text\change <> 0
            *this\text\change = 0
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure   ReDraw(*this._s_widget)
      If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
        Protected *event._s_event = GetGadgetData(*this\root\canvas\gadget)
        
        ; PushListPosition(*event\childrens())
        ForEach *event\childrens()
          ;If *event\childrens()\root And *event\childrens()\root\canvas\gadget = *event\root\canvas\gadget
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
    Procedure Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
      Static v_max, h_max
      Protected sx, sy, round
      
      If *scroll\v\bar\page\len <> height - Bool(*scroll\width > width) * *scroll\h\height
        *scroll\v\bar\page\len = height - Bool(*scroll\width > width) * *scroll\h\height
      EndIf
      
      If *scroll\h\bar\page\len <> width - Bool(*scroll\height > height) * *scroll\v\width
        *scroll\h\bar\page\len = width - Bool(*scroll\height > height) * *scroll\v\width
      EndIf
      
      If *scroll\x < x
        ; left set state
        *scroll\v\bar\page\len = height - *scroll\h\height
      Else
        sx = (*scroll\x-x) 
        *scroll\width + sx
        *scroll\x = x
      EndIf
      
      If *scroll\y < y
        ; top set state
        *scroll\h\bar\page\len = width - *scroll\v\width
      Else
        sy = (*scroll\y-y)
        *scroll\height + sy
        *scroll\y = y
      EndIf
      
      If *scroll\width > *scroll\h\bar\page\len - (*scroll\x-x)
        If *scroll\width-sx =< width And *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
          ;Debug "w - "+Str(*scroll\height-sx)
          
          ; if on the h-scroll
          If *scroll\v\bar\max > height - *scroll\h\height
            *scroll\v\bar\page\len = height - *scroll\h\height
            *scroll\h\bar\page\len = width - *scroll\v\width 
            *scroll\height = *scroll\v\bar\max
            Debug "w - "+*scroll\v\bar\max +" "+ *scroll\v\height +" "+ *scroll\v\bar\page\len
          Else
            *scroll\height = *scroll\v\bar\page\len - (*scroll\x-x) - *scroll\h\height
          EndIf
        EndIf
        
        *scroll\v\bar\page\len = height - *scroll\h\height 
      Else
        *scroll\h\bar\max = *scroll\width
        *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
      EndIf
      
      If *scroll\height > *scroll\v\bar\page\len - (*scroll\y-y)
        If *scroll\height-sy =< Height And *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
          ;Debug " h - "+Str(*scroll\height-sy)
          
          ; if on the v-scroll
          If *scroll\h\bar\max > width - *scroll\v\width
            *scroll\h\bar\page\len = width - *scroll\v\width
            *scroll\v\bar\page\len = height - *scroll\h\height 
            *scroll\width = *scroll\h\bar\max
            Debug "h - "+*scroll\h\bar\max +" "+ *scroll\h\width +" "+ *scroll\h\bar\page\len
          Else
            *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x) - *scroll\v\width
          EndIf
        EndIf
        
        *scroll\h\bar\page\len = width - *scroll\v\width
      Else
        *scroll\v\bar\max = *scroll\height
        *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
      EndIf
      
      If *scroll\h\round And
         *scroll\v\round And
         *scroll\h\bar\page\len < width And 
         *scroll\v\bar\page\len < height
        round = (*scroll\h\height/4)
      EndIf
      
      If *scroll\width >= *scroll\h\bar\page\len  
        If *scroll\h\bar\Max <> *scroll\width 
          *scroll\h\bar\Max = *scroll\width
          
          If *scroll\x =< x 
            *scroll\h\bar\page\pos =- (*scroll\x-x)
            *scroll\h\bar\change = 0
          EndIf
        EndIf
        
        If *scroll\h\width <> *scroll\h\bar\page\len + round
          ; Debug  "h "+*scroll\h\bar\page\len
          *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len + round, #PB_Ignore)
        EndIf
      EndIf
      
      If *scroll\height >= *scroll\v\bar\page\len  
        If *scroll\v\bar\Max <> *scroll\height  
          *scroll\v\bar\Max = *scroll\height
          
          If *scroll\y =< y 
            *scroll\v\bar\page\pos =- (*scroll\y-y)
            *scroll\v\bar\change = 0
          EndIf
        EndIf
        
        If *scroll\v\height <> *scroll\v\bar\page\len + round
          ; Debug  "v "+*scroll\v\bar\page\len
          *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len + round)
        EndIf
      EndIf
      
      If Not *scroll\h\hide 
        If *scroll\h\y[#__c_3] <> y+height - *scroll\h\height
          ; Debug "y"
          *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+height - *scroll\h\height, #PB_Ignore, #PB_Ignore)
        EndIf
        If *scroll\h\x[#__c_3] <> x
          ; Debug "y"
          *scroll\h\hide = Bar::Resize(*scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
      
      If Not *scroll\v\hide 
        If *scroll\v\x[#__c_3] <> x+width - *scroll\v\width
          ; Debug "x"
          *scroll\v\hide = Bar::Resize(*scroll\v, x+width - *scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        If *scroll\v\y[#__c_3] <> y
          ; Debug "y"
          *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
      
      If v_max <> *scroll\v\bar\Max
        v_max = *scroll\v\bar\Max
        *scroll\v\hide = Bar::Update(*scroll\v) 
      EndIf
      
      If h_max <> *scroll\h\bar\Max
        h_max = *scroll\h\bar\Max
        *scroll\h\hide = Bar::Update(*scroll\h) 
      EndIf
      
      ProcedureReturn Bool(*scroll\v\bar\area\change Or *scroll\h\bar\area\change)
    EndProcedure
    
    Procedure Resizes(*scroll._s_scroll, x.l, y.l, width.l, height.l)
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
        Else
          *scroll\v\hide = Update(*scroll\v)
        EndIf
        If Height+y-*scroll\h\height <> *scroll\h\y[#__c_3]
          *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, Height+y-*scroll\h\height, #PB_Ignore, #PB_Ignore)
        Else
          *scroll\h\hide = Update(*scroll\h)
        EndIf
        
        *scroll\v\hide = *scroll\v\bar\hide ; Bool(*scroll\v\bar\min = *scroll\v\bar\page\end)
        *scroll\h\hide = *scroll\h\bar\hide ; Bool(*scroll\h\bar\min = *scroll\h\bar\page\end)
        
        ProcedureReturn Bool(*scroll\v\bar\area\change Or *scroll\h\bar\area\change)
      EndWith
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
          
          If *this\bar\thumb\change 
            
            If *this\parent And 
               *this\parent\scroll
              ; Debug  ""+*this\type+" "+*this\parent\type
              
              If *this\bar\vertical
                If *this\parent\scroll\v = *this
                  *this\parent\change =- 1
                  *this\parent\scroll\y =- *this\bar\page\pos
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    _move_childrens_(*this\parent, 0, *this\bar\thumb\change)
                  EndIf
                EndIf
              Else
                If *this\parent\scroll\h = *this
                  *this\parent\change =- 1
                  *this\parent\scroll\x =- *this\bar\page\pos
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    _move_childrens_(*this\parent, *this\bar\thumb\change, 0)
                  EndIf
                EndIf
              EndIf
            EndIf
            
            ;       ; bar change
            ;       Post(#__Event_StatusChange, *this, *this\bar\from, *this\bar\direction)
            ; *this\bar\thumb\change = 0
          EndIf
          
          \bar\hide = Bool(Not (\bar\max > \bar\page\len)) ; Bool(\bar\min = \bar\page\end) ; 
          
          If \bar\hide
            \bar\page\pos = \bar\min
            ;\bar\thumb\pos = ThumbPos(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
            ; ProcedureReturn Update_Scroll(*this)
          EndIf
          
          ProcedureReturn \bar\hide
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Update_Tab(*this._s_widget)
      With *this
        If *this\type = #PB_GadgetType_TabBar 
          If *this\bar\button[#__b_1]\len 
            If *this\bar\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x           + 1 ; white line size
              *this\bar\button[#__b_1]\width = *this\__height    ; *this\width   - 1 ; white line size
              *this\bar\button[#__b_1]\y = *this\y 
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y           + 1 ; white line size
              *this\bar\button[#__b_1]\height = *this\__height   ; *this\height - 1 ; white line size
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
              *this\bar\button[#__b_2]\height = *this\__height   ; *this\height - 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\x = *this\X+*this\width-*this\bar\button[#__b_2]\width 
            EndIf
          EndIf
          
          
          ;If *this\bar\thumb\len
          If *this\bar\vertical
            *this\bar\button[#__b_3]\x = *this\bar\button[#__b_1]\x 
            *this\bar\button[#__b_3]\width = *this\bar\button[#__b_1]\width 
            *this\bar\button[#__b_3]\y = *this\bar\thumb\pos
            *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
          Else
            *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y 
            *this\bar\button[#__b_3]\height = *this\__height;*this\bar\button[#__b_1]\height
            *this\bar\button[#__b_3]\width = *this\bar\max
            *this\bar\button[#__b_3]\x = (*this\bar\area\pos + _page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
            ;*this\bar\button[#__b_3]\x = (*this\bar\area\pos + *this\bar\area\len + _page_pos_(*this\bar, *this\bar\thumb\pos)) - *this\bar\max
            ;*this\bar\button[#__b_3]\x = (*this\bar\area\pos + *this\bar\min + Round(((*this\bar\thumb\pos-*this\bar\area\pos) / *this\bar\scroll_increment) , #PB_Round_Nearest)) - *this\bar\max
            ; *this\bar\button[#__b_3]\x = *this\bar\area\pos+_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\button[#__b_3]\width; *this\bar\page\pos + (*this\bar\button[#__b_3]\width) ; (*this\bar\thumb\pos+*this\bar\button[#__b_1]\len-(*this\bar\button[#__b_3]\width-*this\bar\thumb\len)/2); + *this\bar\max)
          EndIf
          ;EndIf
          
          If *this\bar\thumb\change
            
            ;             If *this\parent And 
            ;                *this\parent\scroll
            ;               ; Debug  ""+*this\type+" "+*this\parent\type
            ;               
            ;               If *this\bar\vertical
            ;                 If *this\parent\scroll\v = *this
            ;                   *this\parent\change =- 1
            ;                   *this\parent\scroll\y =- *this\bar\page\pos
            ;                   ; ScrollArea childrens auto resize 
            ;                   If *this\parent\container
            ;                     _move_childrens_(*this\parent, 0, *this\bar\thumb\change)
            ;                   EndIf
            ;                 EndIf
            ;               Else
            ;                 If *this\parent\scroll\h = *this
            ;                   *this\parent\change =- 1
            ;                   *this\parent\scroll\x =- *this\bar\page\pos
            ;                   ; ScrollArea childrens auto resize 
            ;                   If *this\parent\container
            ;                     _move_childrens_(*this\parent, *this\bar\thumb\change, 0)
            ;                   EndIf
            ;                 EndIf
            ;               EndIf
            ;             EndIf
            
            ;       ; bar change
            ;       Post(#__Event_StatusChange, *this, *this\bar\from, *this\bar\direction)
            ; *this\bar\thumb\change = 0
          EndIf
        EndIf
        
        
        If \type = #PB_GadgetType_TabBar
          ;Debug  ""+\bar\max +" "+ \bar\page\len
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
        If *this\bar\fixed And *this\bar\thumb\change
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
      Protected result.b, _scroll_pos_.f
      
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
        
        ; one
        If Not *this\bar\max And *this\width And *this\height And *this\type <> #PB_GadgetType_TabBar
          *this\bar\thumb\len = *this\bar\button[#__b_3]\len
          
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
        
        If *this\type = #PB_GadgetType_ScrollBar
          *this\bar\thumb\len = Round((*this\bar\area\len / (*this\bar\max-*this\bar\min)) * (*this\bar\page\len), #PB_Round_Nearest)
          ; *this\bar\thumb\len = Round(*this\bar\area\len - (*this\bar\area\len / (*this\bar\max-*this\bar\min)) * ((*this\bar\max-*this\bar\min) - *this\bar\page\len), #PB_Round_Nearest)
          
          If *this\bar\thumb\len > *this\bar\area\len
            *this\bar\thumb\len = *this\bar\area\len
          EndIf
          
          If *this\bar\thumb\len < *this\bar\button[#__b_3]\len 
            If *this\bar\area\len > *this\bar\button[#__b_3]\len + *this\bar\thumb\len
              *this\bar\thumb\len = *this\bar\button[#__b_3]\len 
            Else
              If *this\bar\button[#__b_3]\len > 7
                ; scroll bar
                *this\bar\thumb\len = 0
              Else
                ; splitter bar
                *this\bar\thumb\len = *this\bar\button[#__b_3]\len
              EndIf
            EndIf
          EndIf
          
        Else
          If *this\type = #PB_GadgetType_TabBar
            *this\bar\page\len = *this\bar\area\len
          EndIf
          
          *this\bar\thumb\len = *this\bar\button[#__b_3]\len
        EndIf
        
        *this\bar\page\end = *this\bar\min + ((*this\bar\max-*this\bar\min) - *this\bar\page\len)
        ;*this\bar\page\end = *this\bar\min + Bool(*this\bar\max > *this\bar\page\Len) * ((*this\bar\max-*this\bar\min) - *this\bar\page\len)
        *this\bar\area\end = *this\bar\area\pos + (*this\bar\area\len - *this\bar\thumb\len)  
        ; *this\bar\thumb\end = (*this\bar\area\end-*this\bar\area\pos)
        ; (*this\bar\area\len - *this\bar\thumb\len) = (*this\bar\area\end-*this\bar\area\pos)
        *this\bar\scroll_increment = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
        ; *this\bar\scroll_increment = ((*this\bar\area\end-*this\bar\area\pos) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
      EndIf
      
      If Not *this\bar\area\len < 0
        
        If *this\bar\fixed And Not *this\bar\thumb\change
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
          ; for the scrollarea childrens
          If *this\bar\page\end And *this\bar\page\pos > *this\bar\page\end And ; *this\bar\thumb\pos = *this\bar\area\end
             *this\parent And *this\parent\scroll And *this\parent\scroll\v And *this\parent\scroll\h
            Debug  ""+*this\bar\page\pos +" "+ *this\bar\page\end
            *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
            *this\bar\page\pos = *this\bar\page\end
          EndIf
          _scroll_pos_ = _invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted)
        EndIf
        
        *this\bar\thumb\pos = _thumb_pos_(*this\bar, _scroll_pos_)
        
        ; _in_start_
        If *this\bar\button[#__b_1]\len 
          If *this\bar\min >= _scroll_pos_
            *this\bar\button[#__b_1]\color\state = #__s_3
            ; *this\bar\button[#__b_1]\interact = #False
          Else
            If *this\bar\button[#__b_1]\color\state <> #__s_2
              *this\bar\button[#__b_1]\color\state = #__s_0
            EndIf
            ; *this\bar\button[#__b_1]\interact = #True
          EndIf 
        EndIf
        
        ; _in_stop_
        If *this\bar\button[#__b_2]\len
          If _scroll_pos_ >= *this\bar\page\end
            *this\bar\button[#__b_2]\color\state = #__s_3
            ; *this\bar\button[#__b_2]\interact = #False
          Else
            If *this\bar\button[#__b_2]\color\state <> #__s_2
              *this\bar\button[#__b_2]\color\state = #__s_0
            EndIf
            ; *this\bar\button[#__b_2]\interact = #True
          EndIf 
        EndIf
        
        ; disable thumb button
        ; If *this\bar\button[#__b_3]\len
        ; Debug   ""+ *this\bar\min +" "+ *this\bar\page\end
        If *this\bar\min >= *this\bar\page\end
          *this\bar\button[#__b_3]\color\state = #__s_3
        ElseIf *this\bar\button[#__b_3]\color\state <> #__s_2
          *this\bar\button[#__b_3]\color\state = #__s_0
        EndIf
        ; EndIf
        
        If *this\type = #PB_GadgetType_ScrollBar
          result = Update_Scroll(*this)
        ElseIf *this\type = #PB_GadgetType_TabBar
          result = Update_Tab(*this)
        ElseIf *this\type = #PB_GadgetType_ProgressBar
          result = Update_Progress(*this)
        ElseIf *this\type = #PB_GadgetType_TrackBar
          result = Update_Track(*this)
        ElseIf *this\type = #PB_GadgetType_Splitter
          result = Update_Splitter(*this)
        ElseIf *this\type = #PB_GadgetType_Spin
          result = Update_Spin(*this)
        EndIf
        
        If *this\bar\thumb\change <> 0
          *this\bar\thumb\change = 0
        EndIf  
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure.l GetAttribute(*this._s_widget, Attribute.l)
      Protected Result.l
      
      With *this
        Select Attribute
          Case #__bar_minimum    : Result = \bar\min          ; 1
          Case #__bar_maximum    : Result = \bar\max          ; 2
          Case #__bar_pagelength : Result = \bar\page\len     ; 3
          Case #__bar_nobuttons  : Result = \bar\button\len   ; 4
          Case #__bar_inverted   : Result = \bar\inverted
          Case #__bar_direction  : Result = \bar\direction
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.f GetState(*this._s_widget)
      ProcedureReturn *this\bar\page\pos
    EndProcedure
    
    Procedure.b Change(*bar._s_bar, ScrollPos.f)
      With *bar
        ;Debug  ScrollPos
        If ScrollPos < \min 
          ; if SetState(height-value or width-value)
          \button[#__b_3]\fixed = ScrollPos
          ScrollPos = \min 
          
        ElseIf \max And ScrollPos > \page\end ;= (\max-\page\len)
          If \max >= \page\len 
            ScrollPos = \page\end
          Else
            ScrollPos = \min 
          EndIf
          ;         ElseIf ScrollPos > \page\end
          ;           ScrollPos = \page\end
        EndIf
        ;Debug  "  "+ScrollPos +" "+ \page\pos +" "+ \page\end
        
        If \page\pos <> ScrollPos 
          \page\change = \page\pos - ScrollPos
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
          
          \thumb\change = \page\change
          \page\pos = ScrollPos
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b SetPos(*this._s_widget, ThumbPos.i)
      If ThumbPos < *this\bar\area\pos : ThumbPos = *this\bar\area\pos : EndIf
      If ThumbPos > *this\bar\area\end : ThumbPos = *this\bar\area\end : EndIf
      
      If *this\bar\thumb\end <> ThumbPos : *this\bar\thumb\end = ThumbPos
        ProcedureReturn SetState(*this, _invert_(*this\bar, _page_pos_(*this\bar, ThumbPos), *this\bar\inverted))
      EndIf
    EndProcedure
    
    Procedure.b SetState(*this._s_widget, ScrollPos.f)
      If Change(*this\bar, ScrollPos) : Update(*this)
        *this\bar\thumb\change = #False
        *this\bar\change = #True
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
              If \bar\min <> Value And Not Value < 0
                \bar\area\change = \bar\min - Value
                If \bar\page\pos < Value
                  \bar\page\pos = Value
                EndIf
                \bar\min = Value
                ;Debug  " min "+\bar\min+" max "+\bar\max
                Result = #True
              EndIf
              
            Case #__bar_maximum
              If \bar\max <> Value And Not Value < 0
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
                
                ;\bar\thumb\change = #True
                Result = #True
              EndIf
              
            Case #__bar_pagelength
              If \bar\page\len <> Value And Not Value < 0
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
                
                If \type = #PB_GadgetType_TabBar
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
                  ;\bar\thumb\change = #True
                  ;Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
          Update(*this) ; \hide = 
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    ;-
    Procedure.b Resize(*this._s_widget, x.l, y.l, width.l, height.l)
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
              
              If \parent And \parent\x[#__c_2] > \x And 
                 \parent\x[#__c_2] > \parent\x[#__c_4]
                \x[#__c_4] = \parent\x[#__c_2]
              ElseIf \parent And \parent\x[#__c_4] > \x 
                \x[#__c_4] = \parent\x[#__c_4]
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
              
              If \parent And \parent\y[#__c_2] > \y And 
                 \parent\y[#__c_2] > \parent\y[#__c_4]
                \y[#__c_4] = \parent\y[#__c_2]
              ElseIf \parent And \parent\y[#__c_4] > \y 
                \y[#__c_4] = \parent\y[#__c_4]
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
            ; then move and size parent set clip (width&height)
            Protected parent_x2 = \parent\x[#__c_2]+\parent\width[#__c_3]
            Protected parent_x4 = \parent\x[#__c_4]+\parent\width[#__c_4]
            Protected parent_y2 = \parent\y[#__c_2]+\parent\height[#__c_3]
            Protected parent_y4 = \parent\y[#__c_4]+\parent\height[#__c_4]
            
            If \parent And parent_x4 > 0 And parent_x4 < \x+\width And parent_x2 > parent_x4 
              \width[#__c_4] = parent_x4 - \x[#__c_4]
            ElseIf \parent And parent_x2 > 0 And parent_x2 < \x+\width
              \width[#__c_4] = parent_x2 - \x[#__c_4]
            Else
              \width[#__c_4] = (\x+\width) - \x[#__c_4]
            EndIf
            
            If \parent And parent_y4 > 0 And parent_y4 < \y+\height And parent_y2 > parent_y4 
              \height[#__c_4] = parent_y4 - \y[#__c_4]
            ElseIf \parent And parent_y2 > 0 And parent_y2 < \y+\height
              \height[#__c_4] = parent_y2 - \y[#__c_4]
            Else
              \height[#__c_4] = (\y+\height) - \y[#__c_4]
            EndIf
            
            ; resize vertical&horizontal scrollbars
            If (*this\scroll And *this\scroll\v And *this\scroll\h)
              \width[#__c_3] = \width[#__c_2]
              \height[#__c_3] = \height[#__c_2]
              
              If (Change_x Or Change_y)
                Resize(*this\scroll\v, *this\scroll\v\x[#__c_3], *this\scroll\v\y[#__c_3], #PB_Ignore, #PB_Ignore)
                Resize(*this\scroll\h, *this\scroll\h\x[#__c_3], *this\scroll\h\y[#__c_3], #PB_Ignore, #PB_Ignore)
              EndIf
              
              If (Change_width Or Change_height)
                Resizes(\scroll, 0, 0, \width[#__c_2], \height[#__c_2])
              EndIf
              
              \width[#__c_3] = \width[#__c_2] - Bool(Not \scroll\v\hide) * \scroll\v\width ; \scroll\h\bar\page\len
              \height[#__c_3] = \height[#__c_2] - Bool(Not \scroll\h\hide) * \scroll\h\height ; \scroll\v\bar\page\len
            EndIf
            
            ; then move and size parent
            If *this\container And *this\count\childrens
              _move_childrens_(*this, 0,0)
            EndIf
          EndIf
          
          Protected result = Update(*this)
          
          ProcedureReturn result
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
    
    Procedure AddItem(*this._s_widget, Item.i, Text.s, Image.i=-1, sublevel.i=0)
      With *this
        If (Item =- 1 Or Item > ListSize(\tab\_s()) - 1)
          LastElement(\tab\_s())
          AddElement(\tab\_s()) 
          Item = ListIndex(\tab\_s())
        Else
          SelectElement(\tab\_s(), Item)
          InsertElement(\tab\_s())
          
          PushListPosition(\tab\_s())
          While NextElement(\tab\_s())
            \tab\_s()\index = ListIndex(\tab\_s())
          Wend
          PopListPosition(\tab\_s())
        EndIf
        
        \tab\_s()\color = _get_colors_()
        \tab\_s()\index = Item
        \tab\_s()\text\change = 1
        \tab\_s()\text\string = Text.s
        \tab\_s()\height = \__height
        
        ;         ; last opened item of the parent
        ;         \tab\opened = \tab\_s()\index
        \count\items + 1 
        
        ; _set_image_(*this, \tab\_s(), Image)
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    ;-
    Procedure.i CloseList()
      If Root()\opened And 
         Root()\opened\parent And
         Root()\opened\root\canvas\gadget = Root()\canvas\gadget 
        
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
    
    Macro _entered_(_button_)
      Bool(*this\bar\from = _button_ And *this\bar\button[_button_]\color\state <> #__s_0)
    EndMacro
    
    Procedure _events_button_(*this._s_widget, _event_type_, _mouse_x_, _mouse_y_)
      Protected Repaint
      
      If _event_type_ = #__Event_MouseMove Or
         _event_type_ = #__Event_MouseEnter Or
         _event_type_ = #__Event_MouseLeave Or
         _event_type_ = #__Event_LeftButtonUp
        
        If _event_type_ = #__Event_LeftButtonUp 
          If *this\bar\state >= 0
            If *this\bar\button[*this\bar\state]\color\state = #__s_2
              ;Debug " up button - " + *this\bar\state
              *this\bar\button[*this\bar\state]\color\state = #__s_1
            EndIf
            
            ;Debug ""+*this\bar\state +" "+ *this\bar\from
            
            If *this\bar\state <> *this\bar\from
              If *this\bar\button[*this\bar\state]\color\state = #__s_1
                Debug " leave button - " + *this\bar\state
                *this\bar\button[*this\bar\state]\color\state = #__s_0
                
                If *this\bar\state = #__b_3
                  If *this\root\canvas\gadget_set_cursor_widget = *this And *this\cursor : *this\root\canvas\gadget_set_cursor_widget = 0
                    ;                 set_cursor(*this, #PB_Cursor_Default)
                    SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  EndIf
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          Repaint = #True
        EndIf
        
        If *this\bar\button[#__b_3]\interact And
           *this\bar\button[#__b_3]\color\state <> #__s_3 And
           _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_3])
          
          If *this\bar\from <> #__b_3
            If *this\bar\button[#__b_3]\color\state = #__s_0
              *this\bar\button[#__b_3]\color\state = #__s_1
              
              If *this\bar\from = #__b_1
                Debug " leave button - (1 >> 3)"
                If *this\bar\button[#__b_1]\color\state = #__s_1
                  *this\bar\button[#__b_1]\color\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_2
                Debug " leave button - (2 >> 3)"
                If *this\bar\button[#__b_2]\color\state = #__s_1  
                  *this\bar\button[#__b_2]\color\state = #__s_0
                EndIf
              EndIf
              
              If  Not *this\root\canvas\gadget_set_cursor_widget And *this\cursor 
                *this\root\canvas\gadget_set_cursor_widget = *this
                ; set_cursor(*this, *this\cursor)
                SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
              EndIf
              
              *this\bar\from = #__b_3
              Debug " enter button - 3"
              Repaint = #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_2]\interact And
               *this\bar\button[#__b_2]\color\state <> #__s_3 And 
               _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_2])
          
          If *this\bar\from <> #__b_2
            If *this\bar\button[#__b_2]\color\state = #__s_0
              *this\bar\button[#__b_2]\color\state = #__s_1
              
              If *this\bar\from = #__b_1
                Debug " leave button - (1 >> 2)"
                If *this\bar\button[#__b_1]\color\state = #__s_1
                  *this\bar\button[#__b_1]\color\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                Debug " leave button - (3 >> 2)"
                If *this\bar\button[#__b_3]\color\state = #__s_1  
                  *this\bar\button[#__b_3]\color\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_2
              Debug " enter button - 2"
              Repaint = #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_1]\interact And 
               *this\bar\button[#__b_1]\color\state <> #__s_3 And 
               _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_1])
          
          If *this\bar\from <> #__b_1
            If *this\bar\button[#__b_1]\color\state = #__s_0
              *this\bar\button[#__b_1]\color\state = #__s_1
              
              If *this\bar\from = #__b_2
                Debug " leave button - (2 >> 1)"
                If *this\bar\button[#__b_2]\color\state = #__s_1  
                  *this\bar\button[#__b_2]\color\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                Debug " leave button - (3 >> 1)"
                If *this\bar\button[#__b_3]\color\state = #__s_1  
                  *this\bar\button[#__b_3]\color\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_1
              Debug " enter button - 1"
              Repaint = #True
            EndIf
          EndIf
          
        Else
          If *this\bar\from <>- 1
            If *this\bar\from = #__b_1
              If *this\bar\button[#__b_1]\color\state = #__s_1
                Debug " leave button - 1"
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
            EndIf
            
            If *this\bar\from = #__b_2
              If *this\bar\button[#__b_2]\color\state = #__s_1
                Debug " leave button - 2"
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
            EndIf
            
            If *this\bar\from = #__b_3
              If *this\bar\button[#__b_3]\color\state = #__s_1 
                Debug " leave button - 3"
                *this\bar\button[#__b_3]\color\state = #__s_0
                
                Debug  ""+*this\root\canvas\gadget_set_cursor_widget +" "+ *this
                
                If *this\root\canvas\gadget_set_cursor_widget = *this And *this\cursor : *this\root\canvas\gadget_set_cursor_widget = 0
                  ;                 set_cursor(*this, #PB_Cursor_Default)
                  SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                EndIf
              EndIf
            EndIf
            
            *this\bar\from =- 1
            Repaint = #True
          EndIf
          
          If *this\count\items
            ForEach *this\tab\_s()
              If *this\tab\_s()\draw
                If _from_point_(_mouse_x_, _mouse_y_, *this\tab\_s()) And
                   _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_3])
                  
                  If *this\index[#__s_1] <> *this\tab\_s()\index
                    If *this\index[#__s_1] >= 0
                      Debug " leave tab - " + *this\index[#__s_1]
                    EndIf
                    
                    *this\index[#__s_1] = *this\tab\_s()\index
                    Debug " enter tab - " + *this\index[#__s_1]
                  EndIf
                  Break
                  
                ElseIf *this\index[#__s_1] = *this\tab\_s()\index
                  Debug " leave tab - " + *this\index[#__s_1]
                  *this\index[#__s_1] =- 1
                  Break
                EndIf
              EndIf
            Next
          EndIf
        EndIf
        ;EndIf
        
      ElseIf _event_type_ = #__Event_LeftButtonDown
        ;       If *this\index[#__s_1] =- 1
        Select *this\bar\from ; #__s_1
          Case #__b_1         ; *this\bar\button[#__b_1]\color\state
            If Bar::Change(*this\bar, *this\bar\page\pos + (Bool(*this\bar\inverted) * *this\bar\scroll_step) - (Bool(Not *this\bar\inverted) * *this\bar\scroll_step))
              If Not Bar::_in_start_(*this\bar) And 
                 *this\bar\button[#__b_2]\color\state = #__s_3 
                
                Debug " enable tab button - right"
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              
              *this\bar\button[#__b_1]\color\state = #__s_2
              If *this\type = #__Type_ScrollBar Or
                 *this\type = #__Type_Spin
                Bar::Update(*this) ; *this\bar\thumb\pos = _bar_ThumbPos(*this, _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted))
              EndIf
              Repaint = #True
            EndIf
            
          Case #__b_2 ; *this\bar\button[#__b_2]\color\state 
            If Bar::Change(*this\bar, Bool(*this\bar\inverted) * (*this\bar\page\pos - *this\bar\scroll_step) + Bool(Not *this\bar\inverted) * (*this\bar\page\pos + *this\bar\scroll_step))
              If Not Bar::_in_stop_(*this\bar) And 
                 *this\bar\button[#__b_1]\color\state = #__s_3 
                
                Debug " enable tab button - left"
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              
              *this\bar\button[#__b_2]\color\state = #__s_2 
              If *this\type = #__Type_ScrollBar Or
                 *this\type = #__Type_Spin
                Bar::Update(*this) ; *this\bar\thumb\pos = _bar_ThumbPos(*this, _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted))
              EndIf
              Repaint = #True
            EndIf
            
          Case #__b_3 ; *this\bar\button[#__b_3]\color\state
            Static delta
            ;If *this\bar\button[#__b_3]\color\state <> #__s_2 
            *this\bar\button[#__b_3]\color\state = #__s_2
            If *this\bar\vertical
              delta = _mouse_y_ - *this\bar\thumb\pos
            Else
              delta = _mouse_x_ - *this\bar\thumb\pos
            EndIf
            
            Repaint = delta
            ;EndIf
            
        EndSelect
        
        *this\bar\state = *this\bar\from
        
        ;       Else
        ;         Repaint = SetState(*this, *this\index[#__s_1])
        ;       EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure.b Events(*this._s_widget, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
      ProcedureReturn _events_button_(*this, EventType, mouse_x, mouse_y)
      
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
            
            *event\root\entered = _this_
            
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
          If _from_point_(mouse_x-*this\x, mouse_y-*this\y, *this, [#__c_3])
            If EventType = #__Event_LeftButtonDown
              Down = 1
              LastX = mouse_x - *this\scroll\h\bar\thumb\pos ; - *this\x[3] ;  
              LastY = mouse_y - *this\scroll\v\bar\thumb\pos
            EndIf
            
            If EventType = #__Event_LeftButtonup
              Down = 0
            EndIf
            
            If EventType = #__Event_mousemove
              If Down And Bool(LastX|LastY) 
                ;  Debug ""+Str(mouse_x-LastX)
                
                ;                 If \bar\vertical
                Result | SetPos(*this\scroll\v, (mouse_y-LastY))
                ;                 Else
                Result | SetPos(*this\scroll\h, (mouse_x-LastX))
                ;                 EndIf
                
                SetWindowTitle(EventWindow(), Str(*this\bar\page\pos) +" "+ Str(*this\bar\thumb\pos-*this\bar\area\pos))
              EndIf
            EndIf
          EndIf
          
          If Events(\scroll\v, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
          If Events(\scroll\h, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
        
        ; get at point buttons
        If Not \hide And (_from_point_(mouse_x, mouse_y, *this, [#__c_4]) Or Down)
          If \bar\button 
            If \bar\button[#__b_3]\interact And *this\bar\button[#__b_3]\color\state <> #__s_3 And _from_point_(mouse_x, mouse_y, \bar\button[#__b_3])
              from = #__b_3
            ElseIf \bar\button[#__b_2]\interact And *this\bar\button[#__b_2]\color\state <> #__s_3 And _from_point_(mouse_x, mouse_y, \bar\button[#__b_2])
              from = #__b_2
            ElseIf \bar\button[#__b_1]\interact And *this\bar\button[#__b_1]\color\state <> #__s_3 And _from_point_(mouse_x, mouse_y, \bar\button[#__b_1])
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
            If *leave > 0 And *leave\from >= 0 And
               *leave\bar\button[*leave\from]\interact And
               *leave\bar\button[*leave\from]\color\state <> #__s_3 And  
               Not _from_point_(mouse_x, mouse_y, *leave\bar\button[*leave\from])
              
              _callback_(*leave, #__Event_MouseLeave)
              *leave\from =- 1; 0
              
              Result = #True
            EndIf
            
            ; If from > 0
            \from = from
            *leave = *this
            ; EndIf
            
            If \from >= 0 And 
               \bar\button[\from]\interact And
               \bar\button[\from]\color\state <> #__s_3
              _callback_(*this, #__Event_MouseEnter)
              
              Result = #True
            EndIf
          EndIf
          
        Else
          If \from >= 0 And
             \bar\button[\from]\interact And
             \bar\button[\from]\color\state <> #__s_3
            
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
            
            If \from >= 0 And 
               \bar\button[\from]\interact And
               \bar\button[\from]\color\state <> #__s_3
              
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
            
            If from = 0 And 
               \bar\button[#__b_3]\interact And
               \bar\button[#__b_3]\color\state <> #__s_3
              
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
                      Result = SetState(*this, \bar\page\pos + \bar\scroll_step)
                    Else
                      Result = SetState(*this, \bar\page\pos - \bar\scroll_step)
                    EndIf
                    
                  Case #__b_2 
                    If \bar\inverted
                      Result = SetState(*this, \bar\page\pos - \bar\scroll_step)
                    Else
                      Result = SetState(*this, \bar\page\pos + \bar\scroll_step)
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
              ;Debug ""+*event\root\mouse\delta\x +" "+ LastX
              
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
    Procedure.i _create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scroll_step.f=1.0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        *event\widget = *this
        \x =- 1
        \y =- 1
        
        ;\hide = Bool(Not pagelength)  ; add
        
        \type = Type
        \adress = *this
        
        \parent = parent
        If \parent
          \root = \parent\root
          \window = \parent\window
        EndIf
        
        \round = round
        \bar\scroll_step = scroll_step
        
        ; ???? ???? ???????
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
        
        \bar\vertical = Bool(Type = #PB_GadgetType_ScrollBar And 
                             (Bool(Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical) Or
                              Bool(Flag & #__Bar_Vertical = #__Bar_Vertical)))
        
        If Not Bool(Flag&#__bar_nobuttons)
          If \bar\vertical
            \width = Size
          Else
            \height = Size
          EndIf
          
          If Size < 21
            Size - 1
          Else
            size = 17
          EndIf
        EndIf
        
        
        ; min thumb size
        \bar\button[#__b_3]\len = size
        
        If Type = #PB_GadgetType_ScrollBar
          \bar\inverted = Bool(Flag & #__bar_inverted = #__bar_inverted)
          
          \bar\button[#__b_1]\interact = #True
          \bar\button[#__b_2]\interact = #True
          \bar\button[#__b_3]\interact = #True
          
          \bar\button[#__b_1]\len = size
          \bar\button[#__b_2]\len = size
          
          \bar\button[#__b_1]\arrow\size = 4
          \bar\button[#__b_2]\arrow\size = 4
          \bar\button[#__b_3]\arrow\size = 3
          
          \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
          
          \bar\button[#__b_1]\round = \round
          \bar\button[#__b_2]\round = \round
          \bar\button[#__b_3]\round = \round
        EndIf
        
        If Type = #PB_GadgetType_ProgressBar
          \bar\vertical = Bool(Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or
                               Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
          \bar\inverted = \bar\vertical
          
          ; \text = AllocateStructure(_s_text)
          \text\change = 1
          
          \text\align\vertical = 1
          \text\align\horizontal = 1
          \text\rotate = \bar\vertical * 90 ; 270
          
          \bar\button[#__b_1]\interact = #False
          \bar\button[#__b_2]\interact = #False
          
          \bar\button[#__b_1]\round = \round
          \bar\button[#__b_2]\round = \round
        EndIf
        
        If Type = #PB_GadgetType_TrackBar
          \bar\vertical = Bool(Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical); Or Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
          \bar\inverted = \bar\vertical
          
          \bar\button[#__b_1]\interact = #False
          \bar\button[#__b_2]\interact = #False
          \bar\button[#__b_3]\interact = #True
          
          
          
          \bar\button[#__b_1]\len = 1
          \bar\button[#__b_2]\len = 1
          
          \bar\button[#__b_3]\arrow\size = 4
          \bar\button[#__b_3]\arrow\type = #__arrow_type
          
          \bar\button[#__b_1]\round = 2
          \bar\button[#__b_2]\round = 2
          \bar\button[#__b_3]\round = \round
          
          If \round < 7
            \bar\button[#__b_3]\len = 9
          EndIf
          
          \bar\mode = Bool(flag & #PB_TrackBar_Ticks) * #PB_TrackBar_Ticks
        EndIf
        
        If Type = #PB_GadgetType_Spin
          \bar\vertical = Bool(Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
          \bar\inverted = \bar\vertical
          
          ; \text = AllocateStructure(_s_text)
          \text\change = 1
          \text\editable = 1
          \text\align\Vertical = 1
          \text\_padding = #__spin_padding_text
          
          ; ???? ???? ???????
          \color = _get_colors_()
          \color\alpha = 255
          \color\back = $FFFFFFFF
          
          \bar\button\len = #__spin_buttonsize
          
          \bar\button[#__b_3]\len = 0
          \bar\button[#__b_1]\len = Size
          \bar\button[#__b_2]\len = Size
          
          \bar\button[#__b_1]\arrow\size = 4
          \bar\button[#__b_2]\arrow\size = 4
          
          \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        EndIf
        
        If Type = #PB_GadgetType_Splitter
          \container = #PB_GadgetType_Splitter
          \bar\vertical = Bool(Not Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
          
          \bar\button[#__b_1]\interact = #False
          \bar\button[#__b_2]\interact = #False
          \bar\button[#__b_3]\interact = #True
          
          \bar\button\len = 7
          \bar\thumb\len = 7
          \bar\mode = #PB_Splitter_Separator
          
          \splitter = AllocateStructure(_s_splitter)
          If Flag & #PB_Splitter_FirstFixed 
            \bar\fixed = #__b_1 
          ElseIf Flag & #PB_Splitter_SecondFixed 
            \bar\fixed = #__b_2 
          EndIf
        EndIf
        
        
        
        If \bar\min <> Min : SetAttribute(*this, #__bar_minimum, Min) : EndIf
        If \bar\max <> Max : SetAttribute(*this, #__bar_maximum, Max) : EndIf
        If \bar\page\len <> Pagelength : SetAttribute(*this, #__bar_pageLength, Pagelength) : EndIf
        If \bar\inverted : SetAttribute(*this, #__bar_inverted, #True) : EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    Procedure.i Create(type.l, *parent._s_widget, size.l, *param_1, *param_2, *param_3, flag.i=0, round.l=7, scroll_step.f=1.0)
      Protected x,y,*this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        \x =- 2147483648
        \y =- 2147483648
        \type = type
        \adress = *this
        \bar\from =- 1
        \bar\state =- 1
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
    
    Procedure.i Spin(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
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
    
    Procedure.i Scroll(x.l, y.l, width.l, height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
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
    
    Procedure.i Tab(x.l, y.l, width.l, height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\round = round
      *this\adress = *this
      *this\bar\from =- 1
      *this\bar\state =- 1
      *this\bar\scroll_step = 1.0
      *this\class = #PB_Compiler_Procedure
      *this\type = #PB_GadgetType_TabBar
      
      *this\color = _get_colors_()
      *this\color\back =- 1 
      
      *this\bar\button[#__b_1]\color = _get_colors_()
      *this\bar\button[#__b_2]\color = _get_colors_()
      *this\bar\button[#__b_3]\color = _get_colors_()
      
      *this\bar\inverted = Bool(Flag & #__bar_Inverted = 0)
      
      If *this\type = #PB_GadgetType_TabBar
        If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
           Flag & #__Bar_Vertical = #__Bar_Vertical
          *this\bar\vertical = #True
        EndIf
        
        If Not Flag & #__bar_nobuttons = #__bar_nobuttons
          *this\bar\button[#__b_3]\len = 0
          *this\bar\button[#__b_1]\len = 10
          *this\bar\button[#__b_2]\len = 10
        EndIf
        
        *this\__height = 40
        
        *this\bar\button[#__b_1]\interact = #True
        *this\bar\button[#__b_2]\interact = #True
        ;*this\bar\button[#__b_3]\interact = #True
        
        *this\bar\button[#__b_1]\round = *this\round
        *this\bar\button[#__b_2]\round = *this\round
        *this\bar\button[#__b_3]\round = *this\round
        
        *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
        *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        
        *this\bar\button[#__b_1]\arrow\size = #__arrow_size
        *this\bar\button[#__b_2]\arrow\size = #__arrow_size
        *this\bar\button[#__b_3]\arrow\size = 3
      EndIf
      
      If Min 
        SetAttribute(*this, #__bar_minimum, Min) 
      EndIf
      If Max 
        SetAttribute(*this, #__bar_maximum, Max) 
      EndIf
      If PageLength 
        SetAttribute(*this, #__bar_pageLength, PageLength) 
      EndIf
      
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Progress(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\round = round
      *this\adress = *this
      *this\bar\from =- 1
      *this\bar\state =- 1
      *this\bar\scroll_step = 1.0
      *this\class = #PB_Compiler_Procedure
      *this\type = #PB_GadgetType_ProgressBar
      
      *this\color = _get_colors_()
      *this\color\back =- 1 
      
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
      
      If Min 
        SetAttribute(*this, #__bar_minimum, Min) 
      EndIf
      If Max 
        SetAttribute(*this, #__bar_maximum, Max) 
      EndIf
      
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Track(x.l, y.l, width.l, height.l, Min.l,Max.l, Flag.i=0, round.l=7)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\round = round
      *this\adress = *this
      *this\bar\from =- 1
      *this\bar\state =- 1
      *this\bar\scroll_step = 1.0
      *this\class = #PB_Compiler_Procedure
      *this\type = #PB_GadgetType_TrackBar
      
      *this\color = _get_colors_()
      *this\color\back =- 1 
      
      *this\bar\button[#__b_1]\color = _get_colors_()
      *this\bar\button[#__b_2]\color = _get_colors_()
      *this\bar\button[#__b_3]\color = _get_colors_()
      
      *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
      
      If *this\Type = #PB_GadgetType_TrackBar
        If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or
           Flag & #__Bar_Vertical = #__Bar_Vertical
          *this\bar\vertical = #True
          *this\bar\inverted = #True
        EndIf
        
        If flag & #PB_TrackBar_Ticks = #PB_TrackBar_Ticks Or
           Flag & #__bar_ticks = #__bar_ticks
          *this\bar\mode =  #PB_TrackBar_Ticks
        EndIf
        
        *this\bar\button[#__b_1]\interact = #True
        *this\bar\button[#__b_2]\interact = #True
        *this\bar\button[#__b_3]\interact = #True
        
        *this\bar\button[#__b_3]\arrow\size = #__arrow_size
        *this\bar\button[#__b_3]\arrow\type = #__arrow_type
        
        *this\bar\button[#__b_1]\round = 2
        *this\bar\button[#__b_2]\round = 2
        *this\bar\button[#__b_3]\round = *this\round
        
        If *this\round < 7
          *this\bar\button[#__b_3]\len = 9
        Else
          *this\bar\button[#__b_3]\len = 15
        EndIf
      EndIf
      
      If Min 
        SetAttribute(*this, #__bar_minimum, Min) 
      EndIf
      If Max 
        SetAttribute(*this, #__bar_maximum, Max) 
      EndIf
      
      CompilerIf Defined(widget, #PB_Module)
        widget::_set_last_parameters_(*this, *this\type, Flag, *event\root\opened)
      CompilerElse
        SetParent(*this, *event\root\opened)
      CompilerEndIf
      
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Splitter(x.l, y.l, width.l, height.l, First.i,Second.i, Flag.i=0)
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
    
    Procedure.i ScrollArea(x.l, y.l, width.l, height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
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
      Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
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
      
      ;       If EventType = #__Event_leftbuttondown
      ;         If *event\root\entered
      ;           Debug *event\root\entered\from
      ;           *event\root\mouse\delta\x = mouse_x - *event\root\entered\x[#__c_3]
      ;           *event\root\mouse\delta\y = mouse_y - *event\root\entered\y[#__c_3]
      ;         EndIf
      ;       EndIf  
      
      ForEach *event\childrens()
        Repaint | events(*event\childrens(), EventType, mouse_x, mouse_y, wheel_X, wheel_Y)
        
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
      Protected canvas = GetWindowData(EventWindow())
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-GadgetX(canvas)*2, WindowHeight(EventWindow())-GadgetY(canvas)*2)
    EndProcedure
    
    Procedure Canvas(Window, X.l, Y.l, Width.l, Height.l, Flag.i=#Null, *CallBack=#Null)
      Protected Canvas = CanvasGadget(#PB_Any, X, Y, Width, Height, Flag)
      *event\root = AllocateStructure(_s_root)
      *event\root\class = "Root"
      *event\root\opened = *event\root
      *event\root\window = Window
      *event\root\canvas\gadget = Canvas
      
      *event\active = *event\root
      *event\active\root = *event\root
      
      SetGadgetData(Canvas, *event)
      SetWindowData(Window, Canvas)
      
      If Not *CallBack
        *CallBack = @Events_CanvasWindow()
      EndIf
      
      BindGadgetEvent(Canvas, *CallBack)
      PostEvent(#PB_Event_Gadget, Window, Canvas, #__Event_Resize)
      
      BindEvent(#PB_Event_SizeWindow, @Resize_CanvasWindow(), Window);, Canvas)
      ProcedureReturn Canvas
    EndProcedure
    
    Procedure Open_Window(Window, X.l, Y.l, Width.l, Height.l, Title.s, Flag.i, ParentID.i)
      Protected w = OpenWindow(Window, X, Y, Width, Height, Title, Flag, ParentID) : If Window =- 1 : Window = w : EndIf
      Protected Canvas = Canvas(Window, 0, 0, Width, Height, #PB_Canvas_Container, @Events_CanvasWindow()) ;: CloseGadgetList()
      ProcedureReturn w
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf

;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
  
  Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
    bar::Open_Window(Window, X, Y, Width, Height, Title, Flag, ParentID)
  EndMacro
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  
  
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
    ScrollBarGadget  (1,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (2, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (2, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ; example scroll widget bar
    TextGadget       (-1,  300+10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/150)",#PB_Text_Center)
    Bar::Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    Bar::SetState   (Widget(),  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    Bar::Scroll  (300+10, 42+30, 250,  10, 30, 150, 230, #__bar_inverted, 7)
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
    Button_0 = SpinGadget(#PB_Any, 0, 0, 0, 0, 0,20) ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1")  ; as they will be sized automatically
    
    Button_2 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150) : CloseGadgetList(); No need to specify size or coordinates
    Button_3 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 0, 100)                     ; as they will be sized automatically
    Button_4 = ProgressBarGadget(#PB_Any, 0, 0, 0, 0, 0, 100)                     ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5")                      ; as they will be sized automatically
    
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
    
    SetGadgetState(Splitter_0, 40)
    SetGadgetState(Splitter_4, 225)
    
    If OpenGadgetList(Button_2)
      Button_4 = ScrollAreaGadget(#PB_Any, -1, -1, 50, 50, 100, 100, 1);, #__flag_noGadget)
                                                                       ;       Define i
                                                                       ;       For i=0 To 1000
      ButtonGadget(#PB_Any, 10, 10, 50, 30,"1")
      ;       Next
      CloseGadgetList()
      ButtonGadget(#PB_Any, 100, 10, 50, 30, "2")
      CloseGadgetList()
    EndIf
    
    ;}
    
    Button_0 = Bar::Spin(0, 0, 0, 0, 0, 20) ; No need to specify size or coordinates
    
    Button_1 = Bar::Tab(0, 0, 0, 0, 0, 0, 0); No need to specify size or coordinates
                                            ;                                          Button_1 = Bar::Scroll(0, 0, 0, 0, 10, 100, 50); No need to specify size or coordinates
    
    AddItem(Button_1, -1, "Tab_0")
    AddItem(Button_1, -1, "Tab_1")
    AddItem(Button_1, -1, "Tab_2")
    
    Button_2 = Bar::ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    Button_3 = Bar::Progress(0, 0, 0, 0, 0, 100, 30)                         ; as they will be sized automatically
    
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
    Bar::SetState(Splitter_0, 40)
    Bar::SetState(Splitter_4, 225)
    
    If OpenList(Button_2)
      Button_4 = Bar::ScrollArea(-1, -1, 50, 50, 100, 100, 1);, #__flag_noGadget)
                                                             ;       Define i
                                                             ;       For i=0 To 1000
      Bar::Progress(10, 10, 50, 30, 1, 100, 30)
      ;       Next
      CloseList()
      Bar::Progress(100, 10, 50, 30, 2, 100, 30)
      CloseList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -------------------------------------------------------vv--------------+--8vv--------
; EnableXP