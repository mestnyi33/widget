CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget"
CompilerEndIf


CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "colors.pbi"
CompilerEndIf


CompilerIf Not Defined(widget, #PB_Module)
  ;- >>>
  DeclareModule widget
    EnableExplicit
    UseModule constants
    UseModule structures
    
    CompilerIf Defined(fixme, #PB_Module)
      UseModule fixme
    CompilerEndIf
    
    Macro _get_colors_()
      colors::*this\grey
    EndMacro
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro Root()
      structures::*event\root
    EndMacro
    
    Macro Widget()
      structures::*event\widget
    EndMacro
    
    Macro GetActive() ; Returns active window
      structures::*event\active
    EndMacro
    
    Macro GetChildrens(_this_) ; Returns active window
      _this_\root\_childrens()
    EndMacro
    
    ;-
    Macro _is_root_(_this_)
      Bool(_this_ And _this_ = _this_\root) ; * _this_\root
    EndMacro
    
    Macro _is_widget_(_this_)
      Bool(_this_ And _this_\adress) ; * _this_\adress
    EndMacro
    
    Macro _is_scrollbar_(_this_)
      Bool(_this_\parent And _this_\parent\scroll And (_this_\parent\scroll\v = _this_ Or _this_ = _this_\parent\scroll\h))
    EndMacro
    
    ;-
    Macro _scrollarea_change_(_this_, _pos_, _len_)
      Bool(Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) < 0 And widget::SetState(_this_, ((_pos_)+_this_\bar\min))) Or
           Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And widget::SetState(_this_, ((_pos_)+_this_\bar\min)-(_this_\bar\page\len-(_len_)))))
    EndMacro
    
    Macro _scrollarea_draw_(_this_)
      ; Draw scroll bars
      CompilerIf Defined(Bar, #PB_Module)
        If _this_\scroll
          If Not _this_\scroll\v\hide And _this_\scroll\v\width
            widget::Draw(_this_\scroll\v)
          EndIf
          If Not _this_\scroll\h\hide And _this_\scroll\h\height
            widget::Draw(_this_\scroll\h)
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
      widget::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;widget::Resizes(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      ;widget::Updates(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      _this_\scroll\v\bar\area\change = #False
      _this_\scroll\h\bar\area\change = #False
    EndMacro
    
    ;-
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
    
    ;-
    Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
      Bool(_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
           _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
    EndMacro
    
    Macro _bar_in_start_(_bar_) 
      Bool(_bar_\page\pos =< _bar_\min) 
    EndMacro
    
    Macro _bar_in_stop_(_bar_) 
      Bool(_bar_\page\pos >= _bar_\page\end) 
    EndMacro
    
    Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_ = #True)
      (Bool(_inverted_) * (_bar_\page\end - (_scroll_pos_-_bar_\min)) + Bool(Not _inverted_) * (_scroll_pos_))
    EndMacro
    
    Macro _bar_page_pos_(_bar_, _thumb_pos_)
      (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\scroll_increment, #PB_Round_Nearest))
    EndMacro
    
    Macro _bar_thumb_pos_(_bar_, _scroll_pos_)
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
    
    ;-
    ;-
    ;-  DECLAREs
    Declare  Child(*this, *parent)
    Declare.l Width(*this, mode.l=#__c_0)
    Declare.l Height(*this, mode.l=#__c_0)
    
    Declare.b Draw(*this)
    Declare   ReDraw(*this)
    
    Declare.l GetType(*this)
    Declare.i GetRoot(*this)
    Declare.i GetData(*this)
    Declare.i GetGadget(*this)
    Declare.i GetWindow(*this)
    Declare.i GetParent(*this, mode.l=0)
    
    Declare.i SetActive(*this)
    
    Declare.b Update(*this)
    Declare.b SetPos(*this, ThumbPos.i)
    Declare.b Change(*bar, ScrollPos.f)
    Declare.b Resize(*this, ix.l,iy.l,iwidth.l,iheight.l)
    
    Declare.s GetText(*this)
    Declare SetText(*this, text.s)
    
    Declare.f GetState(*this)
    Declare.b SetState(*this, state.f)
    
    Declare.l GetAttribute(*this, Attribute.l)
    Declare.l SetAttribute(*this, Attribute.l, Value.l)
    
    Declare.i SetAlignment(*this, Mode.l, Type.l=1)
    Declare.i SetData(*this, *data)
    Declare   SetParent(*this, *parent, parent_item.l=0)
    
    Declare   GetPosition(*this, position.l)
    Declare   SetPosition(*this, position.l, *widget_2=#Null)
    
    ; button
    Declare.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
    Declare.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
    
    ; bar
    Declare.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
    Declare.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Declare.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Declare.i Splitter(x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i=0)
    
    ; container
    Declare.i Panel(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i Container(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i=0)
    Declare.i Form(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, *parent=0)
    Declare.i ScrollArea(x.l,y.l,width.l,height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
    
    Declare   CallBack()
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l=0)
    
    Declare   Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
    Declare   Resizes(*scroll._S_scroll, x.l,y.l,width.l,height.l)
    Declare   AddItem(*this, Item.i, Text.s, Image.i=-1, sublevel.i=0)
    
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    
    Declare   Free(*this)
    Declare.i Bind(*callback, *this=#PB_All, eventtype.l=#PB_All)
    Declare.i Post(eventtype.l, *this, eventitem.l=#PB_All, *data=0)
    
    Declare   Events(*this, _event_type_.l, _mouse_x_.l, _mouse_y_.l, _wheel_x_.b=0, _wheel_y_.b=0)
    Declare   Canvas(Window, x.l=0,y.l=0,width.l=#PB_Ignore,height.l=#PB_Ignore, Flag.i=#Null, *callback=#Null)
    Declare   OpenWindow_(Window, x.l,y.l,width.l,height.l, Title.s, Flag.i=#Null, ParentID.i=#Null)
    Declare.i Create(type.l, *parent, x.l,y.l,width.l,height.l, *param_1,*param_2,*param_3, size.l, flag.i=0, round.l=7, scroll_step.f=1.0)
  EndDeclareModule
  
  Module widget
    ;-
    ;- PRIVATEs
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
    
    
    ;- TEXTs
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
    
    Macro _set_text_flag_(_this_, _flag_, _x_=0, _y_=0)
      ;     If Not _this_\text
      ;       _this_\text = AllocateStructure(_s_text)
      ;     EndIf
      
      If _this_\text
        _this_\text\x = _x_
        _this_\text\y = _y_
        ; _this_\text\_padding = 5
        _this_\text\change = #True
        
        _this_\text\editable = Bool(Not constants::_check_(_flag_, #__text_readonly))
        _this_\text\lower = constants::_check_(_flag_, #__text_lowercase)
        _this_\text\upper = constants::_check_(_flag_, #__text_uppercase)
        _this_\text\pass = constants::_check_(_flag_, #__text_password)
        _this_\text\invert = constants::_check_(_flag_, #__text_invert)
        
        If constants::_check_(_flag_, #__align_text)
          _this_\text\align\top = constants::_check_(_flag_, #__text_top)
          _this_\text\align\left = constants::_check_(_flag_, #__text_left)
          _this_\text\align\right = constants::_check_(_flag_, #__text_right)
          _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
          
          If constants::_check_(_flag_, #__text_center)
            _this_\text\align\horizontal = Bool(Not _this_\text\align\right And Not _this_\text\align\left)
            _this_\text\align\vertical = Bool(Not _this_\text\align\bottom And Not _this_\text\align\top)
          EndIf
        EndIf
        
        If constants::_check_(_flag_, #__text_wordwrap)
          _this_\text\multiLine =- 1
        ElseIf constants::_check_(_flag_, #__text_multiline)
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0 
        EndIf
        
        If _this_\text\invert 
          _this_\text\Rotate = Bool(_this_\vertical)*270 + Bool(Not _this_\vertical)*180
        Else
          _this_\text\Rotate = Bool(_this_\vertical)*90
        EndIf
        
        If _this_\type = #__Type_Editor Or
           _this_\type = #__Type_String
          
          _this_\color\fore = 0
          _this_\text\caret\pos[1] =- 1
          _this_\text\caret\pos[2] =- 1
          _this_\cursor = #PB_Cursor_IBeam
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0] = $FFFFFFFF 
          Else
            _this_\color\back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
          ;                     \text\fontID = GetGadgetFont(TextGadget) 
          ;                     FreeGadget(TextGadget)
          ;Protected FontSize.CGFloat = 12.0 ; boldSystemFontOfSize  fontWithSize
          ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
          ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
          
          ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
          ;\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
          _this_\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
          ;
          ;           \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
          ;           CocoaMessage(@FontSize, \text\fontID, "pointSize")
          ;           
          ;           ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
          
          ;  Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
          
        CompilerElse
          _this_\text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        CompilerEndIf
      EndIf
      
    EndMacro
    
    ;-
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
    ;- PUBLICs
    Procedure Child(*this._s_widget, *parent._s_widget)
      Protected result, *next._s_widget
      
      If *this
        *next = *this\parent
        
        If *parent = *next
          result = #True
        Else
          If *parent
            While *next\root <> *next
              If *parent = *next
                result = #True
                Break
              EndIf
              
              *next = *next\parent
            Wend
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure.i GetData(*this._s_widget)
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure.l GetType(*this._s_widget)
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.i GetRoot(*this._s_widget)
      ProcedureReturn *this\root ; Returns root element
    EndProcedure
    
    Procedure.i GetParent(*this._s_widget, mode.l=0)
      If mode
        ProcedureReturn *this\tab\index
      Else
        ProcedureReturn *this\parent
      EndIf
    EndProcedure
    
    Procedure.i GetGadget(*this._s_widget)
      If _is_root_(*this)
        ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow(*this._s_widget)
      If _is_root_(*this)
        ProcedureReturn *this\root\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\window ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParentLast(*parent._s_widget)
      Protected Result.i
      
      While *parent
        Result = *parent
        *parent = *parent\last
      Wend
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i GetPosition(*this._s_widget, Position.l)
      Protected Result.i, *last._s_widget
      
      If *this
        Select Position
          Case #PB_List_First  
            Result = *this\parent\first
            
          Case #PB_List_Before 
            Result = *this\before
            
          Case #PB_List_After  
            Result = *this\after
            
          Case #PB_List_Last 
            Result = *this\parent\last
            
        EndSelect
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
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
    
    Procedure.s GetText(*this._s_widget)
      If *this\text\pass
        ProcedureReturn *this\text\edit\string
      Else
        ProcedureReturn *this\text\string
      EndIf
    EndProcedure
    
  
    ;-
    Procedure  Draw_Window(*this._s_widget)
      With *this 
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Protected i=1
          
          If \fs = 1 
            For i=1 To \round
              Line(\x[#__c_1]+i-1,\y[#__c_1]+\caption\height-1,1,Bool(\round)*(i-\round),\caption\color\back[\color\state])
              Line(\x[#__c_1]+\width[#__c_1]+i-\round-1,\y[#__c_1]+\caption\height-1,1,-Bool(\round)*(i),\caption\color\back[\color\state])
            Next
          Else
            For i=1 To \fs
              RoundBox(\x[#__c_1]+i-1, \y[#__c_2]-\fs+i-1, \width[#__c_1]-i*2+2, Bool(\height[#__c_1]-\__height>0)*(\height[#__c_1]-\__height)-i*2+2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
              RoundBox(\x[#__c_1]+i-1, \y[#__c_2]-\fs+i, \width[#__c_1]-i*2+2, Bool(\height[#__c_1]-\__height>0)*(\height[#__c_1]-\__height)-i*2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
            Next
          EndIf
        EndIf 
        
        ; Draw back
        If \color\back[\interact * \color\state]
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          ;  RoundBox(\x[#__c_2]-Bool(\fs),\y[#__c_2]-Bool(\fs),\width[#__c_2]+Bool(\fs),Bool(\height[#__c_1]-\__height-\fs*2+Bool(\fs)*2>0) * (\height[#__c_1]-\__height-\fs*2+Bool(\fs)),Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          RoundBox(\x[#__c_2],\y[#__c_2],\width[#__c_2],\height[#__c_2], Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          ;  RoundBox(\x[#__c_2]-1,\y[#__c_2]-1,\width[#__c_2]+2,\height[#__c_2]+2, Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
        EndIf
        
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          If \fs = 1 
            RoundBox(\x[#__c_1], \y[#__c_1]+\__height, \width[#__c_1], Bool(\height[#__c_1]-\__height>0) * (\height[#__c_1]-\__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
          Else
            ; draw out frame
            RoundBox(\x[#__c_1], \y[#__c_1]+\__height, \width[#__c_1], Bool(\height[#__c_1]-\__height>0) * (\height[#__c_1]-\__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            
            ; draw inner frame 
            If \type = #__Type_ScrollArea ; \scroll And \scroll\v And \scroll\h
              RoundBox(\x[#__c_2]-1, \y[#__c_2]-1, Bool(\width[#__c_1]-\fs*2>-2)*(\width[#__c_1]-\fs*2+2), 
                       Bool(\height[#__c_1]-\fs*2-\__height>-2)*(\height[#__c_1]-\fs*2-\__height+2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \scroll\v\color\line)
            Else
              RoundBox(\x[#__c_2]-1, \y[#__c_2]-1, Bool(\width[#__c_1]-\fs*2>-2)*(\width[#__c_1]-\fs*2+2), 
                       Bool(\height[#__c_1]-\fs*2-\__height>-2)*(\height[#__c_1]-\fs*2-\__height+2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            EndIf
          EndIf
        EndIf
        
        
        
        If \__height
          ; Draw caption back
          If \caption\color\back 
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_( 0, \caption\x, \caption\y, \caption\width, \caption\height-1, \caption\color\fore[\color\state], \caption\color\back[\color\state], \round, \caption\color\alpha)
          EndIf
          
          ; Draw caption frame
          If \fs
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\caption\x, \caption\y, \caption\width, \caption\height-1,\round,\round,\color\frame[\color\state])
            
            ; erase the bottom edge of the frame
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            BackColor(\caption\color\fore[\color\state])
            FrontColor(\caption\color\back[\color\state])
            
            ;Protected i
            For i=\round/2+2 To \caption\height-2
              Line(\x[#__c_1],\y[#__c_1]+i,\width[#__c_1],1, \caption\color\back[\color\state])
            Next
            
            ; two edges of the frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Line(\x[#__c_1],\y[#__c_1]+\round/2+2,1,\caption\height-\round/2,\color\frame[\color\state])
            Line(\x[#__c_1]+\width[#__c_1]-1,\y[#__c_1]+\round/2+2,1,\caption\height-\round/2,\color\frame[\color\state])
          EndIf
          
          ;         ; Draw image
          ;         If \caption\image\handle
          ;           DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          ;           DrawAlphaImage(\caption\image\handle, \caption\image\x, \caption\image\y, \caption\color\alpha)
          ;         EndIf
          
          If \caption\text\string
            ;ClipOutput(\caption\x[#__c_4], \caption\y[#__c_4], \caption\width[#__c_4], \caption\height[#__c_4])
            ClipOutput(\caption\x[#__c_2], \caption\y[#__c_2], \caption\width[#__c_2], \caption\height[#__c_2])
            ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ;           RoundBox(\caption\x[#__c_2], \caption\y[#__c_2], \caption\width[#__c_2], \caption\height[#__c_2], \round, \round, $FF000000)
            ; Draw string
            If \resize & #__resize_change
              \caption\text\x = \caption\x[#__c_2] + \caption\text\_padding
              \caption\text\y = \caption\y[#__c_2] + (\caption\height[#__c_2]-TextHeight("A"))/2
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          
          ; draw button back
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If Not \caption\button[0]\hide
            RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, 
                     \caption\button[0]\round, \caption\button[0]\round, \caption\button[0]\color\back[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
          EndIf
          If Not \caption\button[1]\hide
            RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height,
                     \caption\button[1]\round, \caption\button[1]\round, \caption\button[1]\color\back[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
          EndIf
          If Not \caption\button[2]\hide
            RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, 
                     \caption\button[2]\round, \caption\button[2]\round, \caption\button[2]\color\back[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
          EndIf
          If Not \caption\button[3]\hide
            RoundBox(\caption\button[3]\x, \caption\button[3]\y, \caption\button[3]\width, \caption\button[3]\height, 
                     \caption\button[3]\round, \caption\button[3]\round, \caption\button[3]\color\back[\caption\button[3]\color\state]&$FFFFFF|\caption\button[3]\color\alpha<<24)
          EndIf
          
          ; draw button frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          If Not \caption\button[0]\hide
            If \caption\button[0]\color\state
              Line(\caption\button[0]\x+1+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              Line(\caption\button[0]\x+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              
              Line(\caption\button[0]\x-1+6+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, -6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              Line(\caption\button[0]\x+6+(\caption\button[0]\width-6)/2, \caption\button[0]\y+(\caption\button[0]\height-6)/2, -6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
            EndIf
            
            RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, 
                     \caption\button[0]\round, \caption\button[0]\round, \caption\button[0]\color\frame[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
          EndIf
          If Not \caption\button[1]\hide
            If \caption\button[1]\color\state
              Line(\caption\button[1]\x+2+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              Line(\caption\button[1]\x+1+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              
              Line(\caption\button[1]\x+1+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, -4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              Line(\caption\button[1]\x+2+(\caption\button[1]\width-4)/2, \caption\button[1]\y+(\caption\button[1]\height-4)/2, -4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
            EndIf
            
            RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height,
                     \caption\button[1]\round, \caption\button[1]\round, \caption\button[1]\color\frame[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
          EndIf
          If Not \caption\button[2]\hide
            If \caption\button[2]\color\state
              Line(\caption\button[2]\x-2+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              Line(\caption\button[2]\x-1+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              
              Line(\caption\button[2]\x-1+6+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, -4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              Line(\caption\button[2]\x-2+6+(\caption\button[2]\width-4)/2, \caption\button[2]\y+(\caption\button[2]\height-4)/2, -4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
            EndIf
            
            RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, 
                     \caption\button[2]\round, \caption\button[2]\round, \caption\button[2]\color\frame[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
          EndIf
          If Not \caption\button[3]\hide
            RoundBox(\caption\button[3]\x, \caption\button[3]\y, \caption\button[3]\width, \caption\button[3]\height, 
                     \caption\button[3]\round, \caption\button[3]\round, \caption\button[3]\color\frame[\caption\button[3]\color\state]&$FFFFFF|\caption\button[3]\color\alpha<<24)
          EndIf
          
        EndIf
        
        
      EndWith
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
          
          *this\text\x = 6
          *this\text\height = TextHeight("A")
          
          ForEach \tab\_s()
            If \tab\_s()\text\change
              \tab\_s()\x = \bar\max + 1
              
              \tab\_s()\text\width = *this\text\x*2 + TextWidth(\tab\_s()\text\string)
              \tab\_s()\text\height = *this\text\height
              \tab\_s()\text\x = *this\text\x + \tab\_s()\x
              \tab\_s()\text\y = *this\text\y + \tab\_s()\y + (\tab\_s()\height - \tab\_s()\text\height)/2
              
              \tab\_s()\width = \tab\_s()\text\width
              \bar\max + \tab\_s()\width + Bool(\tab\_s()\index <> \count\items - 1) + Bool(\tab\_s()\index = \count\items - 1)*2
              \tab\_s()\text\change = 0
            EndIf
          Next
          
          Static max
          If max <> \bar\max
            ; Debug \bar\max
            ; *this\resize | #__resize_change
            Update(*this)
            ; *this\resize &~ #__resize_change
            max = \bar\max
          EndIf
          
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
      Box(*this\bar\button[#__b_1]\x-2,*this\y[#__c_1],*this\x[#__c_2]+*this\width[#__c_3] - *this\bar\button[#__b_1]\x+3,*this\height[#__c_1], *this\color\frame[*this\color\state])
      Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
      
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0]) ; *this\color\state])
      EndIf
    EndProcedure
    
    Procedure.b Draw_Track(*this._s_widget)
      ;       *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      ;        *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      ;       *this\bar\button[#__b_3]\color\state = #__s_2
      
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
    
    Procedure Draw_Text(*this._s_widget)
      ; draw text
      If *this\text\string
        ForEach *this\row\_s()
          If *this\row\_s()\text\string
            If (*this\text\change Or *this\resize & #__resize_change)
              *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\scroll\x
              *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\scroll\y
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(*this\row\_s()\text\x, *this\row\_s()\text\y, *this\row\_s()\text\string, *this\text\rotate, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
          EndIf
        Next
      EndIf
    EndProcedure
    
    Procedure Draw_Button(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Default)
        Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\back[*this\color\state])
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(*this\x[#__c_1]+20,*this\y[#__c_1], Str(\index)+"_"+Str(\level), $ff000000)
        
        If *this\text\string
          If *this\count\items
            Draw_Text(*this)
          Else
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
          EndIf
        EndIf
        
        If \scroll 
          ; ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure Draw_ScrollArea(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Default)
        Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\back[*this\color\state])
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(*this\x[#__c_1]+20,*this\y[#__c_1], Str(\index)+"_"+Str(\level), $ff000000)
        
        If \scroll 
          ; ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Draw(*this._s_widget)
      With *this
        If \width[#__c_4] > 0 And \height[#__c_4] > 0
          CompilerIf Not (#PB_Compiler_OS = #PB_OS_MacOS And Not Defined(fixme, #PB_Module))
            ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          CompilerEndIf
          
          If \text\string 
            If \text\fontID 
              DrawingFont(\text\fontID)
            EndIf
            
            If \text\change Or *this\resize & #__resize_change
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
            Case #__Type_Window      : Draw_Window(*this)
            Case #__Type_Spin        : Draw_Spin(*this)
            Case #__Type_TabBar      : Draw_Tab(*this)
            Case #__Type_TrackBar    : Draw_Track(*this)
            Case #__Type_ScrollBar   : Draw_Scroll(*this)
            Case #__Type_ProgressBar : Draw_Progress(*this)
            Case #__Type_Splitter    : Draw_Splitter(*this)
              
            Case #__Type_Container   : Draw_ScrollArea(*this)
            Case #__Type_ScrollArea  : Draw_ScrollArea(*this)
            Case #__Type_Button      : Draw_Button(*this)
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
        
        ; Protected count
        ; PushListPosition(GetChildrens(*this))
        ForEach GetChildrens(*this)
          If Not GetChildrens(*this)\hide And GetChildrens(*this)\draw
            ; Debug ""+count +" "+ GetChildrens(*this)\width[#__c_4] : count + 1
            Draw(GetChildrens(*this))
          EndIf
        Next
        ; PopListPosition(GetChildrens(*this))
        
        StopDrawing()
      EndIf
    EndProcedure
    
    
    ;-
    Procedure.l Width(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\width[mode])
    EndProcedure
    
    Procedure.l Height(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\height[mode])
    EndProcedure
    
    Procedure Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
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
            ;  Debug "w - "+*scroll\v\bar\max +" "+ *scroll\v\height +" "+ *scroll\v\bar\page\len
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
            ;  Debug "h - "+*scroll\h\bar\max +" "+ *scroll\h\width +" "+ *scroll\h\bar\page\len
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
          *scroll\h\hide = widget::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len + round, #PB_Ignore)
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
          *scroll\v\hide = widget::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len + round)
        EndIf
      EndIf
      
      If Not *scroll\h\hide 
        If *scroll\h\y[#__c_3] <> y+height - *scroll\h\height
          ; Debug "y"
          *scroll\h\hide = widget::Resize(*scroll\h, #PB_Ignore, y+height - *scroll\h\height, #PB_Ignore, #PB_Ignore)
        EndIf
        If *scroll\h\x[#__c_3] <> x
          ; Debug "y"
          *scroll\h\hide = widget::Resize(*scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
      
      If Not *scroll\v\hide 
        If *scroll\v\x[#__c_3] <> x+width - *scroll\v\width
          ; Debug "x"
          *scroll\v\hide = widget::Resize(*scroll\v, x+width - *scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        If *scroll\v\y[#__c_3] <> y
          ; Debug "y"
          *scroll\v\hide = widget::Resize(*scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
      
      If v_max <> *scroll\v\bar\Max
        v_max = *scroll\v\bar\Max
        *scroll\v\hide = widget::Update(*scroll\v) 
      EndIf
      
      If h_max <> *scroll\h\bar\Max
        h_max = *scroll\h\bar\Max
        *scroll\h\hide = widget::Update(*scroll\h) 
      EndIf
      
      ProcedureReturn Bool(*scroll\v\bar\area\change Or *scroll\h\bar\area\change)
    EndProcedure
    
    Procedure Resizes(*scroll._s_scroll, x.l,y.l,width.l,height.l)
      ;       *scroll\width = *scroll\h\bar\max
      ;       *scroll\height = *scroll\v\bar\max
      ;       
      ;       ProcedureReturn Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
      
      With *scroll
        Protected iHeight, iWidth
        
        If Not *scroll\v Or Not *scroll\h
          ProcedureReturn
        EndIf
        
        If y=#PB_Ignore : y = \v\y-\v\parent\y[#__c_2] : EndIf
        If x=#PB_Ignore : x = \h\x-\v\parent\x[#__c_2] : EndIf
        If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
        If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
        
        If widget::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
          *scroll\v\hide = widget::Resize(*scroll\v, #PB_Ignore, y, #PB_Ignore, _get_page_height_(*scroll, 1))
        EndIf
        
        If widget::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
          *scroll\h\hide = widget::Resize(*scroll\h, x, #PB_Ignore, _get_page_width_(*scroll, 1), #PB_Ignore)
        EndIf
        
        If widget::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
          *scroll\v\hide = widget::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, _get_page_height_(*scroll, 1))
        EndIf
        
        If widget::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
          *scroll\h\hide = widget::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, _get_page_width_(*scroll, 1), #PB_Ignore)
        EndIf
        
        If Width+x-*scroll\v\width <> *scroll\v\x[#__c_3]
          *scroll\v\hide = widget::Resize(*scroll\v, Width+x-*scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Else
          *scroll\v\hide = Update(*scroll\v)
        EndIf
        If Height+y-*scroll\h\height <> *scroll\h\y[#__c_3]
          *scroll\h\hide = widget::Resize(*scroll\h, #PB_Ignore, Height+y-*scroll\h\height, #PB_Ignore, #PB_Ignore)
        Else
          *scroll\h\hide = Update(*scroll\h)
        EndIf
        
        *scroll\v\hide = *scroll\v\bar\hide ; Bool(*scroll\v\bar\min = *scroll\v\bar\page\end)
        *scroll\h\hide = *scroll\h\bar\hide ; Bool(*scroll\h\bar\min = *scroll\h\bar\page\end)
        
        ProcedureReturn Bool(*scroll\v\bar\area\change Or *scroll\h\bar\area\change)
      EndWith
    EndProcedure
    
    
    ;-
    Procedure.b Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      If Bool(*this\resize & #__resize_change)
        If *this\type = #PB_GadgetType_ScrollBar 
          If *this\bar\max And *this\bar\button[#__b_1]\len =- 1 And *this\bar\button[#__b_2]\len =- 1
            
            If *this\bar\vertical And *this\width[2] > 7 And *this\width[2] < 21
              *this\bar\button[#__b_1]\len = *this\width[2] - 1
              *this\bar\button[#__b_2]\len = *this\width[2] - 1
              
            ElseIf Not *this\bar\vertical And *this\height[2] > 7 And *this\height[2] < 21
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
          
        ElseIf *this\type <> #PB_GadgetType_TabBar
          ; if SetState(height-value or width-value)
          If *this\bar\button[#__b_3]\fixed < 0 
            Debug  "if SetState(height-value or width-value)"
            *this\bar\page\pos = *this\bar\area\len + *this\bar\button[#__b_3]\fixed
            *this\bar\button[#__b_3]\fixed = 0
          EndIf
        EndIf
        
        ; one (set max)
        If *this\type = #PB_GadgetType_Splitter 
          If Not *this\bar\max And *this\width And *this\height ; And *this\type <> #PB_GadgetType_TabBar
                                                                ; Debug  "one - Not *this\bar\max And *this\width And *this\height"
            
            *this\bar\thumb\len = *this\bar\button[#__b_3]\len
            
            If Not *this\bar\page\pos
              *this\bar\page\pos = (*this\bar\area\len-*this\bar\thumb\len)/2
            EndIf
            
            ;             If *this\bar\fixed And *this\bar\button[#__b_1]\len
            ;               *this\bar\max = *this\bar\area\len + *this\bar\button[#__b_1]\len*2 + Bool(*this\bar\fixed = #__b_1) * 4
            ;             Else
            *this\bar\max = (*this\bar\area\len-*this\bar\thumb\len)
            ;             EndIf            
            
            ;if splitter fixed set splitter pos to center
            If *this\bar\fixed = #__b_1
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
            EndIf
            If *this\bar\fixed = #__b_2
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\area\len-*this\bar\thumb\len-*this\bar\page\pos
            EndIf
          EndIf
        EndIf
        
        ; get page end
        If *this\type = #PB_GadgetType_TabBar
          *this\bar\page\end = *this\bar\max - *this\bar\area\len
          ;         ElseIf *this\type = #PB_GadgetType_Splitter
          ;           *this\bar\page\end = (*this\bar\max+*this\bar\min) - *this\bar\page\len
        Else
          *this\bar\page\end = *this\bar\max - *this\bar\page\len
        EndIf
        If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        
        ; get thumb len
        If *this\type = #PB_GadgetType_TabBar
          *this\bar\thumb\len = *this\bar\area\len - *this\bar\page\end
          
        ElseIf *this\type = #PB_GadgetType_ScrollBar
          *this\bar\thumb\len = Round((*this\bar\area\len / (*this\bar\max-*this\bar\min)) * (*this\bar\page\len), #PB_Round_Nearest)
          
          If *this\bar\thumb\len > *this\bar\area\len
            *this\bar\thumb\len = *this\bar\area\len
          EndIf
          
          If *this\bar\thumb\len < *this\bar\button[#__b_3]\len 
            If *this\bar\area\len > *this\bar\button[#__b_3]\len + *this\bar\thumb\len
              *this\bar\thumb\len = *this\bar\button[#__b_3]\len 
            ElseIf *this\bar\button[#__b_3]\len > 7
              *this\bar\thumb\len = 0
            EndIf
          EndIf
          
        Else
          *this\bar\thumb\len = *this\bar\button[#__b_3]\len
        EndIf
        
        ; get area end
        ; *this\bar\thumb\end = (*this\bar\area\len - *this\bar\thumb\len)
        *this\bar\area\end = *this\bar\area\pos + (*this\bar\area\len - *this\bar\thumb\len)  
        
        ; get increment size
        If *this\bar\area\len > *this\bar\thumb\len
          If *this\type = #PB_GadgetType_TabBar
            *this\bar\scroll_increment = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\area\len)) 
            ;           ElseIf *this\type = #PB_GadgetType_Splitter
            ;             *this\bar\scroll_increment =  Round((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len), #PB_Round_Nearest) 
          Else
            *this\bar\scroll_increment = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
          EndIf 
          
          If *this\type = #PB_GadgetType_Splitter
            If *this\bar\scroll_increment < 1.0 
              *this\bar\scroll_increment = 1.0
            EndIf
          EndIf  
        Else
          *this\bar\scroll_increment = 1.0
        EndIf
      EndIf
      
      If Not *this\bar\area\len < 0
        If *this\bar\fixed And Not *this\bar\thumb\change
          If *this\bar\button[*this\bar\fixed]\fixed > *this\bar\area\len - *this\bar\thumb\len
            *this\bar\button[*this\bar\fixed]\fixed = *this\bar\area\len - *this\bar\thumb\len
          EndIf
          
          If *this\bar\button[*this\bar\fixed]\fixed < 0
            *this\bar\button[*this\bar\fixed]\fixed = 0
          EndIf
          
          ;           ;           If *this\bar\fixed = #__b_1
          ;           ;             *this\bar\thumb\pos = _bar_thumb_pos_(*this\bar, 0)
          ;           ;           Else
          ;           *this\bar\thumb\pos = _bar_thumb_pos_(*this\bar, Bool(*this\bar\fixed = #__b_2) * *this\bar\page\end)
          ;           ;           EndIf
          
          If *this\bar\fixed = #__b_1
            *this\bar\thumb\pos = *this\bar\area\pos + *this\bar\button[*this\bar\fixed]\fixed 
          Else
            *this\bar\thumb\pos = *this\bar\area\end - *this\bar\button[*this\bar\fixed]\fixed 
          EndIf
        Else
          ; for the scrollarea childrens
          ;If *this\type = #PB_GadgetType_TabBar Or *this\type = #PB_GadgetType_ScrollBar
          If *this\bar\page\end And *this\bar\page\pos > *this\bar\page\end ;And *this\parent And *this\parent\scroll And *this\parent\scroll\v And *this\parent\scroll\h
            
            ; Debug  " "+*this\bar\page\pos +" "+ *this\bar\page\end
            
            *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
            *this\bar\page\pos = *this\bar\page\end
          EndIf
          ;EndIf
          
          _scroll_pos_ = _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted)
          *this\bar\thumb\pos = _bar_thumb_pos_(*this\bar, _scroll_pos_)
          
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
        EndIf
        
        ; disable thumb button
        If *this\type = #PB_GadgetType_ScrollBar
          If *this\bar\thumb\len
            ; Debug   ""+ *this\bar\min +" "+ *this\bar\page\end
            If *this\bar\min >= *this\bar\page\end
              *this\bar\button[#__b_3]\color\state = #__s_3
            ElseIf *this\bar\button[#__b_3]\color\state <> #__s_2
              *this\bar\button[#__b_3]\color\state = #__s_0
            EndIf
          EndIf
        EndIf
        
        
        ; update draw coordinate
        If *this\draw
          If *this\type = #__Type_Option
            *this\option_box\x = *this\x[#__c_2] + *this\text\_padding
            *this\option_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\option_box\height)/2
          EndIf
          
          If *this\type = #__Type_CheckBox
            *this\check_box\x = *this\x[#__c_2] + *this\text\_padding
            *this\check_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\check_box\height)/2
          EndIf
          
          ;       If *this\type = #__Type_Panel
          ;         _resize_panel_(*this, *this\tab\bar\button[#__b_1], *this\x[#__c_2])
          ;         
          ;         If _bar_in_stop_(*this\tab\bar)
          ;           If *this\tab\bar\max < *this\tab\bar\min : *this\tab\bar\max = *this\tab\bar\min : EndIf
          ;           
          ;           If *this\tab\bar\max > *this\tab\bar\max-*this\tab\bar\page\len
          ;             If *this\tab\bar\max > *this\tab\bar\page\len
          ;               *this\tab\bar\max = *this\tab\bar\max-*this\tab\bar\page\len
          ;             Else
          ;               *this\tab\bar\max = *this\tab\bar\min 
          ;             EndIf
          ;           EndIf
          ;           
          ;           *this\tab\bar\page\pos = *this\tab\bar\max
          ;           *this\tab\bar\thumb\pos = _bar_thumb_pos_(*this\tab\bar, *this\tab\bar\page\pos)
          ;         EndIf
          ;       EndIf  
          
          If *this\type = #__Type_Window
            ; caption title bar
            If Not *this\caption\hide
              *this\caption\x = *this\x[#__c_1]
              *this\caption\y = *this\y[#__c_1]
              *this\caption\width = *this\width[#__c_1]
              *this\caption\height = *this\__height + *this\fs ; *this\height[#__c_1]-*this\height[#__c_2]-*this\fs ; 
              
              ; 
              *this\caption\x[#__c_2] = *this\x[#__c_1] + *this\fs
              *this\caption\y[#__c_2] = *this\y[#__c_1] + *this\fs
              *this\caption\height[#__c_2] = *this\__height - *this\fs
              
              If *this\caption\height > *this\height[#__c_1] - *this\fs ;*2
                *this\caption\height = *this\height[#__c_1] - *this\fs  ;*2
              EndIf
              
              ; caption close button
              If Not *this\caption\button[0]\hide
                *this\caption\button[0]\x = (*this\x[#__c_2] + *this\width[#__c_2]) - (*this\caption\button[0]\width + *this\caption\_padding)
                *this\caption\button[0]\y = *this\y[#__c_1] + (*this\caption\height - *this\caption\button[0]\height)/2
              EndIf
              
              ; caption maximize button
              If Not *this\caption\button[1]\hide
                If *this\caption\button[0]\hide
                  *this\caption\button[1]\x = (*this\x[#__c_2] + *this\width[#__c_2]) - (*this\caption\button[1]\width + *this\caption\_padding)
                Else
                  *this\caption\button[1]\x = *this\caption\button[0]\x - (*this\caption\button[1]\width + *this\caption\_padding)
                EndIf
                *this\caption\button[1]\y = *this\y[#__c_1] + (*this\caption\height - *this\caption\button[1]\height)/2
              EndIf
              
              ; caption minimize button
              If Not *this\caption\button[2]\hide
                If *this\caption\button[1]\hide
                  *this\caption\button[2]\x = *this\caption\button[0]\x - (*this\caption\button[2]\width + *this\caption\_padding)
                Else
                  *this\caption\button[2]\x = *this\caption\button[1]\x - (*this\caption\button[2]\width + *this\caption\_padding)
                EndIf
                *this\caption\button[2]\y = *this\y[#__c_1] + (*this\caption\height - *this\caption\button[2]\height)/2
              EndIf
              
              ; caption help button
              If Not *this\caption\button[3]\hide
                If Not *this\caption\button[2]\hide
                  *this\caption\button[3]\x = *this\caption\button[2]\x - (*this\caption\button[3]\width + *this\caption\_padding)
                ElseIf Not *this\caption\button[1]\hide
                  *this\caption\button[3]\x = *this\caption\button[1]\x - (*this\caption\button[3]\width + *this\caption\_padding)
                Else
                  *this\caption\button[3]\x = *this\caption\button[0]\x - (*this\caption\button[3]\width + *this\caption\_padding)
                EndIf
                *this\caption\button[3]\y = *this\caption\button[0]\y
              EndIf
              
              ; title bar width
              If Not *this\caption\button[3]\hide
                *this\caption\width[#__c_2] = *this\caption\button[3]\x - *this\x[#__c_2] - *this\caption\_padding
              ElseIf Not *this\caption\button[2]\hide
                *this\caption\width[#__c_2] = *this\caption\button[2]\x - *this\x[#__c_2] - *this\caption\_padding
              ElseIf Not *this\caption\button[1]\hide
                *this\caption\width[#__c_2] = *this\caption\button[1]\x - *this\x[#__c_2] - *this\caption\_padding
              ElseIf Not *this\caption\button[0]\hide
                *this\caption\width[#__c_2] = *this\caption\button[0]\x - *this\x[#__c_2] - *this\caption\_padding
              Else
                *this\caption\width[#__c_2] = *this\width[#__c_1] - *this\fs*2
              EndIf
              
              ; clip text coordinate
              If *this\caption\x[#__c_2] < *this\x[#__c_4]
                *this\caption\x[#__c_4] = *this\x[#__c_4]
              Else
                *this\caption\x[#__c_4] = *this\caption\x[#__c_2]
              EndIf
              If *this\caption\y[#__c_2] < *this\y[#__c_4]
                *this\caption\y[#__c_4] = *this\y[#__c_4]
              Else
                *this\caption\y[#__c_4] = *this\caption\y[#__c_2]
              EndIf
              If *this\caption\x[#__c_2] + *this\caption\width[#__c_2] > *this\x[#__c_4] + *this\width[#__c_2]
                *this\caption\width[#__c_4] = *this\width[#__c_4]
              Else
                *this\caption\width[#__c_4] = *this\caption\width[#__c_2]
              EndIf
              If *this\caption\y[#__c_2] + *this\caption\height[#__c_2] > *this\y[#__c_4] + *this\height[#__c_2]
                *this\caption\height[#__c_4] = *this\height[#__c_4]
              Else
                *this\caption\height[#__c_4] = *this\caption\height[#__c_2]
              EndIf
              
            EndIf
          EndIf
          
          
          
          If *this\type = #PB_GadgetType_ScrollBar 
            *this\bar\hide = Bool(Not (*this\bar\max > *this\bar\page\len)) ; Bool(*this\bar\min = *this\bar\page\end) ; 
            
            ; не уверен что нужно пока оставлю
            If *this\bar\hide
              If *this\bar\page\pos > *this\bar\min
                *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
              EndIf
              
              *this\bar\page\pos = *this\bar\min
              *this\bar\thumb\pos = _bar_thumb_pos_(*this\bar, _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted))
            EndIf
            
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
              
              If *this\bar\vertical
                *this\bar\button[#__b_3]\width = 0 
                *this\bar\button[#__b_3]\height = 0                             
              Else
                *this\bar\button[#__b_3]\height = 0
                *this\bar\button[#__b_3]\width = 0                                 
              EndIf
            EndIf
            
            If *this\bar\thumb\change 
              
              If *this\parent And 
                 *this\parent\scroll
                
                If *this\bar\vertical
                  If *this\parent\scroll\v = *this
                    *this\parent\change =- 1
                    *this\parent\scroll\y =- *this\bar\page\pos
                    
                    ; ScrollArea childrens auto resize 
                    If *this\parent\container And *this\parent\count\childrens
                      ChangeCurrentElement(GetChildrens(*this\parent), *this\parent\adress)
                      While NextElement(GetChildrens(*this\parent))
                        If GetChildrens(*this\parent)\parent = *this\parent
                          Resize(GetChildrens(*this\parent), #PB_Ignore, 
                                 GetChildrens(*this\parent)\y[#__c_3] + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore)
                        EndIf
                      Wend
                    EndIf
                  EndIf
                Else
                  If *this\parent\scroll\h = *this
                    *this\parent\change =- 1
                    *this\parent\scroll\x =- *this\bar\page\pos
                    
                    ; ScrollArea childrens auto resize 
                    If *this\parent\container And *this\parent\count\childrens
                      ChangeCurrentElement(GetChildrens(*this\parent), *this\parent\adress)
                      While NextElement(GetChildrens(*this\parent))
                        If GetChildrens(*this\parent)\parent = *this\parent
                          Resize(GetChildrens(*this\parent), 
                                 GetChildrens(*this\parent)\x[#__c_3] + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                        EndIf
                      Wend
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            
            result = *this\bar\hide
          EndIf
          
          
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
              *this\bar\button[#__b_3]\height = *this\bar\max                             
              *this\bar\button[#__b_3]\y = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
            Else
              *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y 
              *this\bar\button[#__b_3]\height = *this\__height ; *this\bar\button[#__b_1]\height
              *this\bar\button[#__b_3]\width = *this\bar\max
              *this\bar\button[#__b_3]\x = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
            EndIf
            ;EndIf
            
            result = Bool(*this\resize & #__resize_change)
          EndIf
          
          
          If *this\type = #PB_GadgetType_ProgressBar
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
            
            result = Bool(*this\resize & #__resize_change)
          EndIf
          
          
          If *this\type = #PB_GadgetType_TrackBar 
            If *this\bar\button[#__b_1]\color\state <> Bool(Not *this\bar\inverted) * #__s_2 Or 
               *this\bar\button[#__b_2]\color\state <> Bool(*this\bar\inverted) * #__s_2
              *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
              *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
              *this\bar\button[#__b_3]\color\state = #__s_2
            EndIf
            
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
            
            result = Bool(*this\resize & #__resize_change)
          EndIf
          
          
          If *this\type = #PB_GadgetType_Splitter And 
             *this\Splitter 
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
                If *this\root\container
                  ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
                Else
                  ResizeGadget(*this\splitter\first, (*this\bar\button[#__b_1]\x-*this\x)+GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_1]\y-*this\y)+GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
                EndIf
              Else
                If *this\splitter\first\x <> *this\bar\button[#__b_1]\x Or ; -*this\x
                   *this\splitter\first\y <> *this\bar\button[#__b_1]\y Or ; -*this\y
                   *this\splitter\first\width <> *this\bar\button[#__b_1]\width Or
                   *this\splitter\first\height <> *this\bar\button[#__b_1]\height
                  ; Debug "splitter_1_resize "+*this\splitter\first
                  Resize(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
                EndIf
              EndIf
            EndIf
            
            If *this\splitter\second
              If *this\splitter\g_second
                If *this\root\container 
                  ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
                Else
                  ResizeGadget(*this\splitter\second, (*this\bar\button[#__b_2]\x-*this\x)+GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_2]\y-*this\y)+GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
                EndIf
              Else
                If *this\splitter\second\x <> *this\bar\button[#__b_2]\x Or ; -*this\x
                   *this\splitter\second\y <> *this\bar\button[#__b_2]\y Or ; -*this\y
                   *this\splitter\second\width <> *this\bar\button[#__b_2]\width Or
                   *this\splitter\second\height <> *this\bar\button[#__b_2]\height 
                  ; Debug "splitter_2_resize "+*this\splitter\second
                  Resize(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
                EndIf
              EndIf   
            EndIf      
            
            result = Bool(*this\resize & #__resize_change)
          EndIf
          
          
          If *this\type = #PB_GadgetType_Spin
            If *this\bar\vertical      
              ; Top button coordinate
              *this\bar\button[#__b_2]\y      = *this\y[#__c_2]+*this\height[#__c_2]/2 + Bool(*this\height%2)
              *this\bar\button[#__b_2]\height = *this\height[#__c_2]/2 - 1 
              *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\x      = (*this\x[#__c_2]+*this\width[#__c_3]) - *this\bar\button[#__b_2]\len - 1
              
              ; Bottom button coordinate
              *this\bar\button[#__b_1]\y      = *this\y[#__c_2] + 1 
              *this\bar\button[#__b_1]\height = *this\height[#__c_2]/2 - Bool(Not *this\height%2) - 1
              *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\x      = (*this\x[#__c_2]+*this\width[#__c_3]) - *this\bar\button[#__b_1]\len - 1                               
            Else    
              ; Left button coordinate
              *this\bar\button[#__b_1]\y      = *this\y[#__c_2] + 1
              *this\bar\button[#__b_1]\height = *this\height[#__c_2] - 2
              *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len/2 - 1
              *this\bar\button[#__b_1]\x      = *this\x+*this\width - *this\bar\button[#__b_1]\len - 1   
              
              ; Right button coordinate
              *this\bar\button[#__b_2]\y      = *this\y[#__c_2] + 1 
              *this\bar\button[#__b_2]\height = *this\height[#__c_2] - 2
              *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len/2 - 1
              *this\bar\button[#__b_2]\x      = *this\x[#__c_2]+*this\width[#__c_3] - *this\bar\button[#__b_2]\len/2                             
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
            
            result = Bool(*this\resize & #__resize_change)
          EndIf
        EndIf
        
        
        If *this\bar\thumb\change <> 0
          *this\bar\thumb\change = 0
        EndIf  
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Clip(*this._s_widget, childrens.b)
      ; Debug  *this\adress
      
      ; then move and size parent set clip (width&height)
      Protected _p_x2_ = *this\parent\x[#__c_2]+*this\parent\width[#__c_2]
      Protected _p_y2_ = *this\parent\y[#__c_2]+*this\parent\height[#__c_2]
      Protected _p_x4_ = *this\parent\x[#__c_4]+*this\parent\width[#__c_4]
      Protected _p_y4_ = *this\parent\y[#__c_4]+*this\parent\height[#__c_4]
      Protected _t_x2_ = *this\x+*this\width
      Protected _t_y2_ = *this\y+*this\height
      
      If *this\parent And _p_x4_ > 0 And _p_x4_ < _t_x2_ And _p_x2_ > _p_x4_ 
        *this\width[#__c_4] = _p_x4_ - *this\x[#__c_4]
      ElseIf *this\parent And _p_x2_ > 0 And _p_x2_ < _t_x2_
        *this\width[#__c_4] = _p_x2_ - *this\x[#__c_4]
      Else
        *this\width[#__c_4] = _t_x2_ - *this\x[#__c_4]
      EndIf
      
      If *this\parent And _p_y4_ > 0 And _p_y4_ < _t_y2_ And _p_y2_ > _p_y4_ 
        *this\height[#__c_4] = _p_y4_ - *this\y[#__c_4]
      ElseIf *this\parent And _p_y2_ > 0 And _p_y2_ < _t_y2_
        *this\height[#__c_4] = _p_y2_ - *this\y[#__c_4]
      Else
        *this\height[#__c_4] = _t_y2_ - *this\y[#__c_4]
      EndIf
      
      If *this\width[#__c_4] < 0
        *this\width[#__c_4] = 0
      EndIf
      
      If *this\height[#__c_4] < 0
        *this\height[#__c_4] = 0
      EndIf
      
      If (*this\width[#__c_4] Or 
          *this\height[#__c_4])
        *this\draw = #True
      Else
        *this\draw = #False
      EndIf
      
      If childrens And *this\container And *this\count\childrens
        PushListPosition(GetChildrens(*this))
        ForEach GetChildrens(*this)
          If GetChildrens(*this)\parent = *this
            Clip(GetChildrens(*this), childrens)
          EndIf
        Next
        PopListPosition(GetChildrens(*this))
      EndIf
    EndProcedure
    
    Procedure.b Resize(*this._s_widget, x.l,y.l,width.l,height.l)
       Protected.l Change_x, Change_y, Change_width, Change_height
        
        With *this
          ; #__flag_autoSize
        If \parent And \parent\type <> #__Type_Splitter And \align And
           \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\width
          Y = 0; \align\height
          Width = \parent\width[#__c_2] ; - \align\width
          Height = \parent\height[#__c_2] ; - \align\height
        EndIf
        
        
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
              \width[#__c_1] = \width-\bs*2+\fs*2 
              \width[#__c_3] = \width-\bs*2 
              If \width[#__c_1] < 0 : \width[#__c_1] = 0 : EndIf
              If \width[#__c_3] < 0 : \width[#__c_3] = 0 : EndIf
              \resize | #__resize_width | #__resize_change
            EndIf 
          EndIf  
          
          If Height <> #PB_Ignore 
            If Height < 0 : Height = 0 : EndIf
            
            If \height <> Height 
              Change_height = height-\height 
              \height = Height 
              \height[#__c_1] = \height-\bs*2+\fs*2 
              \height[#__c_3] = \height-\bs*2-\__height
              If \height[#__c_1] < 0 : \height[#__c_1] = 0 : EndIf
              If \height[#__c_3] < 0 : \height[#__c_3] = 0 : EndIf
              \resize | #__resize_height | #__resize_change
            EndIf 
          EndIf 
          
          If \resize & #__resize_change
            ; then move and size parent set clip (width&height)
            If *this\parent And *this\parent <> *this
            Clip(*this, #False)
          Else
            *this\x[#__c_4] = *this\x
            *this\y[#__c_4] = *this\y
            *this\width[#__c_4] = *this\width
            *this\height[#__c_4] = *this\height
          EndIf
          
            ; 
            *this\width[#__c_2] = *this\width[#__c_3]
            *this\height[#__c_2] = *this\height[#__c_3]
            
            ; resize vertical&horizontal scrollbars
            If (*this\scroll And *this\scroll\v And *this\scroll\h)
              If (Change_x Or Change_y)
                Resize(*this\scroll\v, *this\scroll\v\x[#__c_3], *this\scroll\v\y[#__c_3], #PB_Ignore, #PB_Ignore)
                Resize(*this\scroll\h, *this\scroll\h\x[#__c_3], *this\scroll\h\y[#__c_3], #PB_Ignore, #PB_Ignore)
              EndIf
              
              If (Change_width Or Change_height)
                Resizes(*this\scroll, 0, 0, *this\width[#__c_3], *this\height[#__c_3])
              EndIf
              
              *this\width[#__c_2] = *this\width[#__c_3] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; *this\scroll\h\bar\page\len
              *this\height[#__c_2] = *this\height[#__c_3] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; *this\scroll\v\bar\page\len
            EndIf
            
            If *this\type = #PB_GadgetType_Spin
              *this\width[#__c_2] = *this\width[#__c_3] - *this\bs*2 - *this\bar\button[#__b_3]\len
            EndIf
            
            ; then move and size parent
            If *this\container And *this\count\childrens
              PushListPosition(GetChildrens(*this))
              ForEach GetChildrens(*this)
                If GetChildrens(*this)\parent = *this ; And GetChildrens(*this)\draw 
                  If GetChildrens(*this)\align
                    If GetChildrens(*this)\align\horizontal
                      x = (*this\width[#__c_2] - (GetChildrens(*this)\align\width+GetChildrens(*this)\width))/2
                    ElseIf GetChildrens(*this)\align\right And Not GetChildrens(*this)\align\left
                      ;                       If *this\type = #PB_GadgetType_ScrollArea
                      ;                         x = *this\scroll\h\bar\max - GetChildrens(*this)\align\width
                      ;                       Else
                      x = *this\width[#__c_2] - GetChildrens(*this)\align\width
                      ;                       EndIf
                    Else
                      If *this\x[#__c_2]
                        x = (GetChildrens(*this)\x-*this\x[#__c_2]) + Change_x 
                      Else
                        x = 0
                      EndIf
                    EndIf
                    
                    If GetChildrens(*this)\align\Vertical
                      y = (*this\height[#__c_2] - (GetChildrens(*this)\align\height+GetChildrens(*this)\height))/2 
                      
                    ElseIf GetChildrens(*this)\align\bottom And Not GetChildrens(*this)\align\top
                      y = \height[#__c_2] - GetChildrens(*this)\align\height
                      
                    Else
                      If *this\y[#__c_2]
                        y = (GetChildrens(*this)\y-*this\y[#__c_2]) + Change_y 
                      Else
                        y = 0
                      EndIf
                    EndIf
                    
                    If GetChildrens(*this)\align\top And GetChildrens(*this)\align\bottom
                      Height = *this\height[#__c_2] - GetChildrens(*this)\align\height
                    Else
                      Height = #PB_Ignore
                    EndIf
                    
                    If GetChildrens(*this)\align\left And GetChildrens(*this)\align\right
                      Width = *this\width[#__c_2] - GetChildrens(*this)\align\width
                    Else
                      Width = #PB_Ignore
                    EndIf
                    
                    Resize(GetChildrens(*this), x, y, Width, Height)
                  Else
                    If (Change_x Or Change_y)
                      
                      Resize(GetChildrens(*this), 
                             GetChildrens(*this)\x[#__c_3],
                             GetChildrens(*this)\y[#__c_3], 
                             #PB_Ignore, #PB_Ignore)
                      
                    ElseIf (Change_width Or Change_height)
                      Clip(GetChildrens(*this), #True)
                    EndIf
                  EndIf
                EndIf
              Next
              PopListPosition(GetChildrens(*this))
            EndIf
          EndIf
          
          If *this\draw
            Protected result = Update(*this)
          EndIf
          
          ProcedureReturn result
        EndWith
    EndProcedure
    
    
    ;-
    Procedure SetState_Window(*this._s_widget, state.l)
      Protected.b result
      
      ; restore state
      If state = #__Window_Normal
        If Not Post(#__Event_RestoreWindow, *this)
          If *this\resize & #__resize_minimize
            *this\resize &~ #__resize_minimize
            *this\caption\button[0]\hide = 0
            *this\caption\button[2]\hide = 0
          EndIf
          *this\resize &~ #__resize_maximize
          *this\resize | #__resize_restore
          
          Resize(*this, *this\root\x[#__c_3], *this\root\y[#__c_3], 
                 *this\root\width[#__c_3], *this\root\height[#__c_3])
          
          If _is_root_(*this)
            PostEvent(#PB_Event_RestoreWindow, *this\root\window, *this)
          EndIf
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post(#__Event_MaximizeWindow, *this)
          If Not *this\resize & #__resize_minimize
            *this\root\x[#__c_3] = *this\x[#__c_3]
            *this\root\y[#__c_3] = *this\y[#__c_3]
            *this\root\width[#__c_3] = *this\width
            *this\root\height[#__c_3] = *this\height
          EndIf
          
          *this\resize | #__resize_maximize
          Resize(*this, 0,0, *this\parent\width, *this\parent\height)
          
          If _is_root_(*this)
            PostEvent(#PB_Event_MaximizeWindow, *this\root\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post(#__Event_MinimizeWindow, *this)
          If Not *this\resize & #__resize_maximize
            *this\root\x[#__c_3] = *this\x[#__c_3]
            *this\root\y[#__c_3] = *this\y[#__c_3]
            *this\root\width[#__c_3] = *this\width
            *this\root\height[#__c_3] = *this\height
          EndIf
          
          *this\caption\button[0]\hide = 1
          If *this\caption\button[1]\hide = 0
            *this\caption\button[2]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize(*this, *this\root\x[#__c_3], *this\parent\height-*this\__height, *this\root\width[#__c_3], *this\__height)
          
          If _is_root_(*this)
            PostEvent(#PB_Event_MinimizeWindow, *this\root\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure.b SetState(*this._s_widget, state.f)
      Protected result
      
      If *this\type = #__Type_Window
        result = SetState_Window(*this, state)
        
      Else
        If Change(*this\bar, state) : Update(*this)
          *this\bar\thumb\change = #False
          *this\bar\change = #True
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change(*bar._s_bar, ScrollPos.f)
      With *bar
        If ScrollPos < \min 
          ;If *this\type <> #PB_GadgetType_TabBar
          ; if SetState(height-value or width-value)
          \button[#__b_3]\fixed = ScrollPos
          ;EndIf
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
        ProcedureReturn SetState(*this, _bar_invert_(*this\bar, _bar_page_pos_(*this\bar, ThumbPos), *this\bar\inverted))
      EndIf
    EndProcedure
    
    Procedure.l SetAttribute(*this._s_widget, Attribute.l, Value.l)
      Protected Result.l
      
      With *this
        If \splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              \bar\button[#__b_1]\len = Value
              \bar\min = Value
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
    Procedure.i SetText(*this._s_widget, text.s)
      *this\text\change = #True
      *this\text\string.s = Text
    EndProcedure
    
    Procedure SetData(*this._s_widget, *data)
      *this\data = *data
    EndProcedure
    
    Procedure SetParent(*this._s_widget, *parent._s_widget, parent_item.l=0)
        If *this\parent <> *Parent
          Widget() = *this
          
          If *this\parent
            *this\parent\count\childrens - 1
            *this\root\count\childrens - Bool(*this\parent <> *this\root)
            
            ChangeCurrentElement(GetChildrens(*this\parent), *this\adress)
            MoveElement(GetChildrens(*this\parent), #PB_List_After, *Parent\adress)
            
            While PreviousElement(GetChildrens(*this\parent)) 
              If Child(GetChildrens(*this\parent), *this)
                MoveElement(GetChildrens(*this\parent), #PB_List_After, *this\adress)
              EndIf
            Wend
          EndIf
          
          *this\parent = *Parent
          
          If *this\parent
            *this\root = *this\parent\root
            *this\window = *this\parent\window
            
            *this\parent\count\childrens + 1
            *this\root\count\childrens + Bool(*this\parent <> *this\root)
          EndIf
          
          If Not (*this\parent And 
                  *this\parent\type = #PB_GadgetType_Splitter)
            *this\index = *this\root\count\childrens
            *this\level = *this\parent\level + 1
            LastElement(GetChildrens(*this\parent))
            *this\adress = AddElement(GetChildrens(*this\parent)) 
            GetChildrens(*this\parent) = *this
          EndIf
          
          If *this\parent
            If Not *this\parent\first 
              If Not *this\parent\last
                ; Debug *this\index
                *this\parent\last = *this
              EndIf
              ; Debug *this\index
              *this\parent\first = *this
            Else
              If Not *this\parent\first\after
                *this\parent\first\after = *this
                *this\before = *this\parent\first
              EndIf
              
              If *this\parent\last
                *this\parent\last\after = *this
                *this\before = *this\parent\last
              EndIf
              
              *this\parent\last = *this
            EndIf
          EndIf
        EndIf
    EndProcedure
    
    Procedure.i SetAlignment(*this._s_widget, Mode.l, Type.l=1)
      
      With *this
        Select Type
          Case 1 ; widget
            If \parent
              If Not \align
                \align.structures::_s_align = AllocateStructure(structures::_s_align)
              EndIf
              
              If Bool(Mode&#__flag_autoSize=#__flag_autoSize)
                \align\top = Bool(Not Mode&#__align_bottom)
                \align\left = Bool(Not Mode&#__align_right)
                \align\right = Bool(Not Mode&#__align_left)
                \align\bottom = Bool(Not Mode&#__align_top)
                \align\autoSize = 0
                
                ; Auto dock
                Static y2,x2,y1,x1
                Protected width = #PB_Ignore
                Protected height = #PB_Ignore
                
                If \align\left And \align\right
                  \x = x2
                  width = \parent\width[#__c_2] - x1 - x2
                EndIf
                If \align\top And \align\bottom 
                  \y = y2
                  height = \parent\height[#__c_2] - y1 - y2
                EndIf
                
                If \align\left And Not \align\right
                  \x = x2
                  \y = y2
                  x2 + \width
                  height = \parent\height[#__c_2] - y1 - y2
                EndIf
                If \align\right And Not \align\left
                  \x = \parent\width[#__c_2] - \width - x1
                  \y = y2
                  x1 + \width
                  height = \parent\height[#__c_2] - y1 - y2
                EndIf
                
                If \align\top And Not \align\bottom 
                  \x = 0
                  \y = y2
                  y2 + \height
                  width = \parent\width[#__c_2] - x1 - x2
                EndIf
                If \align\bottom And Not \align\top
                  \x = 0
                  \y = \parent\height[#__c_2] - \height - y1
                  y1 + \height
                  width = \parent\width[#__c_2] - x1 - x2
                EndIf
                
                Resize(*this, \x, \y, width, height)
                
              Else
                \align\top = Bool(Mode&#__align_top=#__align_top)
                \align\left = Bool(Mode&#__align_left=#__align_left)
                \align\right = Bool(Mode&#__align_right=#__align_right)
                \align\bottom = Bool(Mode&#__align_bottom=#__align_bottom)
                
                If Bool(Mode&#__align_center=#__align_center)
                  \align\horizontal = Bool(Not \align\right And Not \align\left)
                  \align\vertical = Bool(Not \align\bottom And Not \align\top)
                EndIf
              EndIf
              
              If \align\right
                If \align\left
                  \align\width = \parent\width[#__c_2] - \width
                Else
                  \align\width = (\parent\width[#__c_2]-\x[#__c_3])
                EndIf
              EndIf
              
              If \align\bottom
                If \align\top
                  \align\height = \parent\height[#__c_2] - \height
                Else
                  \align\height = (\parent\height[#__c_2]-\y[#__c_3])
                EndIf
              EndIf
              
              ; update parent childrens coordinate
              Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
          Case 2 ; text
          Case 3 ; image
        EndSelect
      EndWith
    EndProcedure
    
    Procedure __SetPosition(*this._s_widget, position.l, *widget_2._s_widget=#Null) ; Ok
      Protected Type
      Protected Result =- 1
      
      If *this = *Widget_2
        ProcedureReturn 0
      EndIf
      Select Position
        Case #PB_List_First 
          If *this\parent\first <> *this
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_Before, *this\parent\first\adress)
            
            While NextElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_Before, *this\parent\first\adress)
              EndIf
            Wend
            
            If *this\parent\last = *this
              *this\parent\last = *this\before
              *this\before\after = 0
              
              *this\after = *this\parent\first
              *this\after\before = *this
              
              *this\parent\first = *this
              *this\before = 0
            EndIf
          EndIf
          
        Case #PB_List_Before 
          If *this\before
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_Before, *this\before\adress)
            
            While NextElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_Before, *this\before\adress)
              EndIf
            Wend
            
            If *this\parent\last = *this
              *this\parent\last = *this\before
            EndIf
            
            *this\before\after = *this\after
            *this\after = *this\before
            *this\before = *this\before\before 
            
            If *this\before
              *this\before\after = *this
            EndIf
            *this\after\before = *this
          EndIf
          
        Case #PB_List_After 
          If *this\after
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_After, *this\after\adress)
            
            While PreviousElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *this\after
            EndIf
            
            *this\after\before = *this\before
            *this\before = *this\after
            *this\after = *this\after\after 
            
            *this\before\after = *this
            If *this\after
              *this\after\before = *this
            EndIf
          EndIf
          
        Case #PB_List_Last 
          Protected *Last._s_widget = GetParentLast(*this\parent)
          
          If *Last <> *this
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_After, *Last\adress)
            
            While PreviousElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *this\after
              *this\after\before = 0
              
              *this\before = *this\parent\last
              *this\before\after = *this
              
              *this\parent\last = *this
              *this\after = 0
            EndIf
          EndIf
          
      EndSelect
      
      
      ;redraw(root())
      PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure SetPosition(*this._s_widget, position.l, *widget_2._s_widget=#Null) ; Ok
      Protected Type
      Protected Result =- 1
      
      Protected *before._s_widget 
      Protected *after._s_widget 
      Protected *Last._s_widget
      
      If *this = *Widget_2
        ProcedureReturn 0
      EndIf
      
      Select Position
        Case #PB_List_First 
          If *this\parent\first <> *this
            SetPosition(*this, #PB_List_Before, *this\parent\first)
          EndIf
          
        Case #PB_List_Before 
          If *widget_2
            *before = *widget_2
          Else
            *before = *this\before
          EndIf
          
          If *before
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_Before, *before\adress)
            
            While NextElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_Before, *before\adress)
              EndIf
            Wend
            
            If *this\parent\last   = *this ; GetParentLast(*this) 
              *this\parent\last    = *before
            EndIf
            
            If *this\before
              *this\before\after   = *this\after
            EndIf
            
            *this\after            = *before
            *this\before           = *before\before 
            
            If Not *this\before
              *this\parent\first = *this
              *this\parent\first\before = 0
            EndIf
          EndIf
          
        Case #PB_List_After 
          If *widget_2
            *after = *widget_2
          Else
            *after = *this\after
          EndIf
          
          If *after
            *Last = GetParentLast(*after)
            
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_After, *Last\adress)
            
            While PreviousElement(GetChildrens(*this)) 
              If Child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *after
            EndIf
            
            If *this\after
              *this\after\before = *this\before
            EndIf
            
            *this\before = *after
            *this\after = *after\after 
            
            If Not *this\after
              *this\parent\last = *this
              *this\parent\last\after = 0
            EndIf
          EndIf
          
        Case #PB_List_Last 
          ;             *after = *this\parent\last
          ;           
          ;           If *this\parent\last <> *this 
          ;             *Last = GetParentLast(*after)
          ;             
          ;             ChangeCurrentElement(GetChildrens(*this), *this\adress)
          ;             MoveElement(GetChildrens(*this), #PB_List_After, *Last\adress)
          ;             
          ;             While PreviousElement(GetChildrens(*this)) 
          ;               If Child(GetChildrens(*this), *this)
          ;                 MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
          ;               EndIf
          ;             Wend
          ;             
          ;             If *this\parent\first = *this
          ;               *this\parent\first = *after
          ;             EndIf
          ;             
          ;               Debug "last - "+*after\index+" "+*this\after\index
          ;             If *this\after
          ;               *this\after\before = *this\before
          ;             EndIf
          ;             
          ;             *this\before = *after
          ;             *this\after = *after\after 
          ;             
          ;             If Not *this\after
          ; ;               If *this\before
          ; ;                 Debug "   this\before "+*this\before\index
          ; ;               EndIf
          ; ;               Debug "   this "+*this\index
          ; ;               If *this\after
          ; ;                 Debug "   this\after "+*this\after\index
          ; ;               EndIf
          ;             
          ;               *this\parent\last = *this
          ;               *this\parent\last\after = 0
          ;             EndIf
          ;           EndIf
          ;           *Last = GetParentLast(*this\parent)
          ;           
          ;           If *Last <> *this
          ;             Debug  "set Last "
          ;             SetPosition(*this, #PB_List_After, *last)
          ;           EndIf
          
      EndSelect
      
      PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetActive(*this._s_widget)
      Protected Result.i
      
      Macro _set_active_state_(_active_, _state_)
        _active_\color\state = (_state_)
        
        If Not(_active_ = _active_\root And _active_\root\type =- 5)
          If (_state_)
            Events(_active_, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
          Else
            Events(_active_, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
          EndIf
          
          PostEvent(#PB_Event_Gadget, _active_\root\canvas\window, _active_\root\canvas\gadget, #__Event_repaint)
        EndIf
        
        If _active_\gadget
          _active_\gadget\color\state = (_state_)
          
          If (_state_)
            Events(_active_\gadget, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
          Else
            Events(_active_\gadget, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
          EndIf
        EndIf
      EndMacro
      
      With *this
        If \type > 0 And GetActive()
          If GetActive()\gadget <> *this
            If GetActive() <> \window
              If _is_widget_(GetActive())
                _set_active_state_(GetActive(), #__s_0)
              EndIf
              
              GetActive() = \window
              GetActive()\gadget = *this
              
              _set_active_state_(GetActive(), #__s_2)
            Else
              If GetActive()\gadget
                GetActive()\gadget\color\state = #__s_0
                Events(GetActive()\gadget, #__Event_LostFocus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
              EndIf
              
              GetActive()\gadget = *this
              GetActive()\gadget\color\state = #__s_2
              Events(GetActive()\gadget, #__Event_Focus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
            EndIf
            
            Result = #True 
          EndIf
          
        ElseIf GetActive() <> *this
          If _is_widget_(GetActive())
            _set_active_state_(GetActive(), #__s_0)
          EndIf
          
          GetActive() = *this
          
          ;If _is_widget_(GetActive())
          _set_active_state_(GetActive(), #__s_2)
          ;EndIf
          Result = #True
        EndIf
        
        SetPosition(GetActive(), #PB_List_Last)
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    ;-
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
    
    Procedure Close_Window(*this._s_widget)
      Protected.b result
      
      ; close window
      If Not Post(#__Event_CloseWindow, *this)
        Free(*this)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_CloseWindow, *this\root\window, *this)
        EndIf
        
        result = #True
      EndIf
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
        If (_is_root_(*this) Or *this\type = #__Type_Window)
          *this\window = *this
        EndIf
        
        Root()\opened = *this
        Root()\opened\tab\opened = Item
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure.i Post(eventtype.l, *this._s_widget, eventitem.l=#PB_All, *data=0)
      Protected result.i
      
      structures::*event\widget = *this
      structures::*event\data = *data
      structures::*event\type = eventtype
      
      If Not *this\root\event_count
        ; 
        Select eventtype 
          Case #__Event_Focus, 
               #__Event_LostFocus
            
            ForEach Root()\event_list()
              If Root()\event_list()\widget = *this And Root()\event_list()\type = eventtype
                result = 1
              EndIf
            Next
            
            If Not result
              AddElement(Root()\event_list())
              Root()\event_list() = AllocateStructure(_s_event)
              Root()\event_list()\widget = *this
              Root()\event_list()\type = eventtype
              Root()\event_list()\item = eventitem
              Root()\event_list()\data = *data
            EndIf
            
        EndSelect
      EndIf
      
      If *this And *this\root\event_count
        If *this\root <> *this  
          If *this\event And
             (*this\event\type = #PB_All Or
              *this\event\type = eventtype)
            
            result = *this\event\callback()
          EndIf
          
          If *this\window And 
             *this\window\event And 
             result <> #PB_Ignore And 
             *this\window <> *this And 
             *this\window <> *this\root And 
             (*this\window\event\type = #PB_All Or
              *this\window\event\type = eventtype)
            
            result = *this\window\event\callback()
          EndIf
        EndIf
        
        If *this\root And 
           *this\root\event And 
           result <> #PB_Ignore And 
           (*this\root\event\type = #PB_All Or 
            *this\root\event\type = eventtype) 
          
          result = *this\root\event\callback()
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind(*callback, *this._s_widget=#PB_All, eventtype.l=#PB_All)
      If *this = #PB_All
        *this = Root()
      EndIf
      
      If Not *this\event
        *this\event = AllocateStructure(_s_event)
      EndIf
      
      If Not *this\root\event_count
        *this\root\event_count = 1
      EndIf
      
      *this\event\type = eventtype
      *this\event\callback = *callback
      
      If ListSize(Root()\event_list())
        ForEach Root()\event_list()
          Post(Root()\event_list()\type, Root()\event_list()\widget, Root()\event_list()\item, Root()\event_list()\data)
        Next
        ClearList(Root()\event_list())
      EndIf
      
      ProcedureReturn *this\event
    EndProcedure
    
    Procedure.i Unbind(*callback, *this._s_widget=#PB_All, eventtype.l=#PB_All)
      If *this\event
        *this\event\type = 0
        *this\event\callback = 0
        FreeStructure(*this\event)
        *this\event = 0
      EndIf
      
      ProcedureReturn *this\event
    EndProcedure
    
    ;-
    Procedure.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
      ProcedureReturn Create(#__Type_Spin, Root()\opened, x,y,width,height, min,max,0, #__spin_buttonsize, #__bar_child|flag, round, Increment)
    EndProcedure
    
    Procedure.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_TabBar, Root()\opened, x,y,width,height, min,max,pagelength, 40, #__bar_child|flag, round, 40)
    EndProcedure
    
    Procedure.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_ScrollBar, Root()\opened, x,y,width,height, min,max,pagelength, #__scroll_buttonsize, #__bar_child|flag, round, 1)
    EndProcedure
    
    Procedure.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=7)
      ProcedureReturn Create(#__Type_TrackBar, Root()\opened, x,y,width,height, min,max,0,0, #__bar_child|flag, round, 1)
    EndProcedure
    
    Procedure.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_ProgressBar, Root()\opened, x,y,width,height, min,max,0,0, #__bar_child|flag, round, 1)
    EndProcedure
    
    Procedure.i Splitter(x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i=0)
      ;       If IsGadget(First)
      ;         ProcedureReturn Create(#__Type_Splitter, 0, x,y,width,height, First,Second, 0,0, #__bar_child|flag, 0, 1)
      ;       Else
      ProcedureReturn Create(#__Type_Splitter, Root()\opened, x,y,width,height, First,Second, 0,0, #__bar_child|flag, 0, 1)
      ;       EndIf
    EndProcedure
    
    ;-
    Procedure.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
      ProcedureReturn Track(x,y,width,height, 10,100, Flag, 9)
    EndProcedure
    
    Procedure.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
      ProcedureReturn Progress(x,y,width,height, 10,100, Flag, round)
      
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      
      With *this
        ; first change default XY
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\round = round
        ;         *this\container = 1
        ;         *this\index[#__s_1] =- 1
        ;         *this\index[#__s_2] = 0
        *this\type = #__Type_Button
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        *this\fs = Bool(Not constants::_check_(Flag, #__flag_borderless))
        *this\bs = *this\fs
        
        *this\interact = 1
        *this\vertical = constants::_check_(Flag, #__flag_vertical)
        
        _set_text_flag_(*this, flag, 0, 0)
        
        *this\text\_padding = 5
        *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
        *this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
        
        ;       ; \image = AllocateStructure(_s_image)
        ;       *this\image\align\Vertical = 1
        ;       *this\image\align\horizontal = 1
        ;       _set_image_(*this, *this, Image)
        
        SetParent(*this, Root()\opened)
        
        ; \scroll = AllocateStructure(_s_scroll) 
        *this\scroll\v = widget::create(#__Type_ScrollBar, *this, 0,0,0,0, 0,0,Height, #__test_scrollbar_size, #__bar_vertical, 7)
        *this\scroll\h = widget::create(#__Type_ScrollBar, *this, 0,0,0,0, 0,0,Width, #__test_scrollbar_size, 0, 7)
        
        Resize(*this, X,Y,Width,Height)
        If Text.s
          SetText(*this, Text.s)
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    
    ;-
    Procedure.i Container(x.l,y.l,width.l,height.l, Flag.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      
      With *this
        ; first change default XY
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\container = 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        *this\type = #PB_GadgetType_ScrollArea
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        *this\fs = Bool(Not Flag&#__flag_borderless) * #__border_scroll
        *this\bs = *this\fs
        
        SetParent(*this, Root()\opened)
        
        If constants::_check_(flag, #__flag_noGadget, #False)
          OpenList(*this)
        EndIf
        
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__Type_Frame, Flag, Root()\opened)
      
      With *this
        \x =- 1
        \y =- 1
        \container =- 2
        \color = _get_colors_()
        \color\alpha = 255
        \color\back = $FFF9F9F9
        
        \__height = 16
        
        \bs = 1
        \fs = 1
        
        ;       ; \text = AllocateStructure(_s_text)
        ;       \text\edit\string = Text.s
        ;       \text\string.s = Text.s
        ;       \text\change = 1
        _set_text_flag_(*this, flag, 2, - 22)
        
        *this\text\_padding = 5
        ;*this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
        ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
        
        Resize(*this, X,Y,Width,Height)
        If Text.s
          SetText(*this, Text.s)
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Panel(x.l,y.l,width.l,height.l, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__Type_Panel, Flag, Root()\opened)
      
      With *this
        \x =- 1
        \y =- 1
        
        \container = 1
        
        \color = _get_colors_()
        \color\alpha = 255
        \color\back = $FFF9F9F9
        
        \tab\bar\page\len = Width
        \tab\bar\scroll_step = 10
        
        
        \__height = 25
        \from =- 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        
        \tab\bar\button[#__b_1]\len = 13 + 2
        \tab\bar\button[#__b_2]\len = 13 + 2
        \tab\bar\button[#__b_1]\round = 7
        \tab\bar\button[#__b_2]\round = 7
        
        \tab\bar\button[#__b_1]\arrow\size = 6
        \tab\bar\button[#__b_2]\arrow\size = 6
        \tab\bar\button[#__b_1]\arrow\type = #__arrow_type + Bool(#__arrow_type>0)
        \tab\bar\button[#__b_2]\arrow\type = #__arrow_type + Bool(#__arrow_type>0)
        
        \tab\bar\button[#__b_1]\color = _get_colors_()
        \tab\bar\button[#__b_2]\color = _get_colors_()
        
        \tab\bar\button[#__b_1]\color\alpha = 255
        \tab\bar\button[#__b_2]\color\alpha = 255
        
        \fs = 1
        \bs = Bool(Not Flag&#__flag_anchorsGadget)
        
        ; Background image
        ; \image[1] = AllocateStructure(_s_image)
        
        Resize(*this, X,Y,Width,Height)
        If Not Flag&#__flag_noGadget
          OpenList(*this)
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent._s_widget=0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      
      If *parent
        If Root() = *parent 
          Root()\parent = *this
        EndIf
      Else
        *parent = Root()
      EndIf
      
      ;       ;_set_last_parameters_(*this, #__Type_Window, Flag, *parent) 
      ;       ;Debug ""+#PB_compiler_procedure+"(func) line - "+#PB_compiler_line +" "+ root()\opened 
      ;       
      ;       ; ? ????? ???????? ??????
      ;       If Not Root()\opened 
      ;         Root()\opened = Root()
      ;       EndIf
      
      With *this
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\container = 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        *this\type = #__Type_Window
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        ; Background image
        \image\index =- 1
        
        
        ;       \flag\window\sizeGadget = constants::_check_(flag, #__Window_SizeGadget)
        ; ;       \flag\window\systemMenu = constants::_check_(flag, #__Window_SystemMenu)
        ; ;       \flag\window\MinimizeGadget = constants::_check_(flag, #__Window_MinimizeGadget)
        ; ;       \flag\window\MaximizeGadget = constants::_check_(flag, #__Window_MaximizeGadget)
        ;       \flag\window\TitleBar = constants::_check_(flag, #__Window_TitleBar)
        ;       \flag\window\Tool = constants::_check_(flag, #__Window_Tool)
        ;       \flag\window\borderless = constants::_check_(flag, #__Window_BorderLess)
        
        \caption\round = 4
        \caption\_padding = \caption\round
        \caption\color = _get_colors_()
        
        ;\caption\hide = constants::_check_(flag, #__flag_borderless)
        \caption\hide = constants::_check_(flag, #__Window_TitleBar, #False)
        \caption\button[0]\hide = constants::_check_(flag, #__Window_SystemMenu, #False)
        \caption\button[1]\hide = constants::_check_(flag, #__Window_MaximizeGadget, #False)
        \caption\button[2]\hide = constants::_check_(flag, #__Window_MinimizeGadget, #False)
        \caption\button[3]\hide = 1
        
        \caption\button[0]\color = colors::*this\red
        \caption\button[1]\color = colors::*this\blue
        \caption\button[2]\color = colors::*this\green
        
        *this\caption\button[0]\color\state = 1
        *this\caption\button[1]\color\state = 1
        *this\caption\button[2]\color\state = 1
        
        \caption\button[0]\round = 4+3
        \caption\button[1]\round = \caption\button[0]\round
        \caption\button[2]\round = \caption\button[0]\round
        \caption\button[3]\round = \caption\button[0]\round
        
        \caption\button[0]\width = 12+2
        \caption\button[0]\height = 12+2
        
        \caption\button[1]\width = \caption\button[0]\width
        \caption\button[1]\height = \caption\button[0]\height
        
        \caption\button[2]\width = \caption\button[0]\width
        \caption\button[2]\height = \caption\button[0]\height
        
        \caption\button[3]\width = \caption\button[0]\width*2
        \caption\button[3]\height = \caption\button[0]\height
        
        If \caption\button[1]\hide = 0 Or 
           \caption\button[2]\hide = 0
          \caption\button[0]\hide = 0
        EndIf
        
        If \caption\button[0]\hide = 0
          \caption\hide = 0
        EndIf
        
        If Not \caption\hide 
          \__height = constants::_check_(flag, #__flag_borderless, #False) * 23
        EndIf
        
        \fs = constants::_check_(flag, #__flag_borderless, #False) * 5
        \bs = \fs
        
        ;\round = 7
          SetParent(*this, *parent)
        
        Resize(*this, X,Y,Width,Height)
        
        If constants::_check_(flag, #__Window_NoGadgets, #False)
          OpenList(*this)
        EndIf
        If constants::_check_(flag, #__Window_NoActivate, #False)
          ;  SetActive(*this)
        EndIf 
        
        If Text And \caption\height
          \caption\text\_padding = 5
          \caption\text\string = Text
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ScrollArea(x.l,y.l,width.l,height.l, Scroll_AreaWidth.l, Scroll_AreaHeight.l, scroll_step.l=1, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      
      With *this
        ; first change default XY
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\container = 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        *this\type = #PB_GadgetType_ScrollArea
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        *this\fs = Bool(Not Flag&#__flag_borderless) * #__border_scroll
        *this\bs = *this\fs
        
          SetParent(*this, Root()\opened)
        
        If constants::_check_(flag, #__flag_noGadget, #False)
          OpenList(*this)
        EndIf
        
        ;         ; \scroll = AllocateStructure(_s_scroll) 
        \scroll\v = widget::create(#__Type_ScrollBar, *this, 0,0,0,0, 0,Scroll_AreaHeight,Height, Size, #__bar_vertical, 7, scroll_step)
        \scroll\h = widget::create(#__Type_ScrollBar, *this, 0,0,0,0, 0,Scroll_AreaWidth,Width, Size, 0, 7, scroll_step)
        
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    
    ;-
    Procedure.i Create(type.l, *parent._s_widget, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i=0, round.l=7, scroll_step.f=1.0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\type = type
        *this\round = round
        
        *this\bar\from =- 1
        *this\bar\state =- 1
        *this\bar\scroll_step = scroll_step
        
        ; *this\adress = *this
        ; *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\bar\button[#__b_1]\color = _get_colors_()
        *this\bar\button[#__b_2]\color = _get_colors_()
        *this\bar\button[#__b_3]\color = _get_colors_()
        
        *this\bar\inverted = Bool(Flag & #__bar_Inverted = Bool(*this\type <> #PB_GadgetType_TabBar) * #__bar_Inverted)
        
        _set_text_flag_(*this, flag)
        
        ; - Create Scroll
        If *this\type = #__Type_ScrollBar
          *this\class = "Scroll"
          *this\color\back = $FFF9F9F9 ; - 1 
          *this\color\front = $FFFFFFFF
          
          If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
             Flag & #__Bar_Vertical = #__Bar_Vertical
            *this\bar\vertical = #True
          EndIf
          
          If Not Flag & #__bar_nobuttons = #__bar_nobuttons
            *this\bar\button[#__b_3]\len = size
            *this\bar\button[#__b_1]\len =- 1
            *this\bar\button[#__b_2]\len =- 1
          EndIf
          
          *this\bar\button[#__b_1]\interact = #True
          *this\bar\button[#__b_2]\interact = #True
          *this\bar\button[#__b_3]\interact = #True
          
          *this\bar\button[#__b_1]\round = *this\round
          *this\bar\button[#__b_2]\round = *this\round
          *this\bar\button[#__b_3]\round = *this\round
          
          *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
          
          *this\bar\button[#__b_1]\arrow\size = #__arrow_size
          *this\bar\button[#__b_2]\arrow\size = #__arrow_size
          *this\bar\button[#__b_3]\arrow\size = 3
        EndIf
        
        ; - Create Spin
        If *this\Type = #PB_GadgetType_Spin
          *this\class = "Spin"
          *this\color\back =- 1 
          
          If Not (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                  Flag & #__Bar_Vertical = #__Bar_Vertical)
            *this\bar\vertical = #True
            *this\bar\inverted = #True
          EndIf
          
          *this\fs = Bool(Not Flag&#__flag_borderless)
          *this\bs = *this\fs
          
          ; *this\text = AllocateStructure(_s_text)
          *this\text\change = 1
          *this\text\editable = 1
          *this\text\align\Vertical = 1
          *this\text\_padding = #__spin_padding_text
          
          *this\color = _get_colors_()
          *this\color\alpha = 255
          *this\color\back = $FFFFFFFF
          
          *this\bar\button[#__b_1]\interact = #True
          *this\bar\button[#__b_2]\interact = #True
          ;*this\bar\button[#__b_3]\interact = #True
          
          If *this\bar\vertical
            *this\bar\button[#__b_3]\len = Size + 2
          Else
            *this\bar\button[#__b_3]\len = Size*2 + 3
          EndIf
          
          *this\bar\button[#__b_1]\len = Size
          *this\bar\button[#__b_2]\len = Size
          
          *this\bar\button[#__b_1]\arrow\size = #__arrow_size
          *this\bar\button[#__b_2]\arrow\size = #__arrow_size
          
          *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        EndIf
        
        ; - Create Tab
        If *this\type = #PB_GadgetType_TabBar
          *this\class = "Tab"
          *this\color\back =- 1 
          
          If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
             Flag & #__Bar_Vertical = #__Bar_Vertical
            *this\bar\vertical = #True
          EndIf
          
          If Not Flag & #__bar_nobuttons = #__bar_nobuttons
            *this\bar\button[#__b_3]\len = 0
            *this\bar\button[#__b_1]\len = 10
            *this\bar\button[#__b_2]\len = 10
          EndIf
          
          *this\__height = 30
          
          *this\bar\button[#__b_1]\interact = #True
          *this\bar\button[#__b_2]\interact = #True
          *this\bar\button[#__b_3]\interact = #True
          
          *this\bar\button[#__b_1]\round = *this\round
          *this\bar\button[#__b_2]\round = *this\round
          *this\bar\button[#__b_3]\round = *this\round
          
          *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
          
          *this\bar\button[#__b_1]\arrow\size = #__arrow_size
          *this\bar\button[#__b_2]\arrow\size = #__arrow_size
          *this\bar\button[#__b_3]\arrow\size = 3
        EndIf
        
        ; - Create Track
        If *this\Type = #PB_GadgetType_TrackBar
          *this\class = "Track"
          *this\color\back =- 1 
          
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
        
        ; - Create Progress
        If *this\type = #PB_GadgetType_ProgressBar
          *this\class = "Progress"
          *this\color\back =- 1 
          
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
        
        ; - Create Splitter
        If *this\type = #PB_GadgetType_Splitter
          *this\class = "Splitter"
          *this\color\back =- 1 
          
          If (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
              Flag & #__Bar_Vertical = #__Bar_Vertical)
            *this\cursor = #PB_Cursor_LeftRight
          Else
            *this\bar\vertical = #True
            *this\cursor = #PB_Cursor_UpDown
          EndIf
          
          If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
            *this\bar\fixed = #__b_1 
          ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
            *this\bar\fixed = #__b_2 
          EndIf
          
          *this\bar\mode = #PB_Splitter_Separator
          
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          *this\container = *this\type
          
          *this\bar\button[#__b_3]\len = #__splitter_buttonsize
          *this\bar\button[#__b_3]\round = 2
          *this\bar\button[#__b_3]\interact = #True
          
          *this\splitter = AllocateStructure(_s_splitter)
          *this\splitter\first = *param_1
          *this\splitter\second = *param_2
          
          *this\splitter\g_first = Bool(IsGadget(*this\splitter\first))
          *this\splitter\g_second = Bool(IsGadget(*this\splitter\second))
          
        Else
          If *param_1 
            SetAttribute(*this, #__bar_minimum, *param_1) 
          EndIf
          If *param_2 
            SetAttribute(*this, #__bar_maximum, *param_2) 
          EndIf
          If *param_3 
            SetAttribute(*this, #__bar_pageLength, *param_3) 
          EndIf
        EndIf
        
          
        If Not Flag & #__bar_child = #__bar_child
          *this\bar\_type = *this\Type
          *this\parent = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\adress = *parent\adress
        Else
          If *parent
              SetParent(*this, *parent)
          Else
            *this\draw = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Splitter
            If *this\splitter\first And Not *this\splitter\g_first
              SetParent(*this\splitter\first, *this)
            EndIf
            
            If *this\splitter\second And Not *this\splitter\g_second
              SetParent(*this\splitter\second, *this)
            EndIf
          EndIf
          
         If flag & #__flag_autosize = #__flag_autosize
            *this\align = AllocateStructure(_s_align)
            *this\align\autoSize = 1
            *this\align\left = 1
            *this\align\top = 1
            *this\align\right = 1
            *this\align\bottom = 1
            
            ; set parent back transporent
            *this\parent\color\back =- 1
          EndIf
          
         Resize(*this, x,y,width,height)
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Free(*this._s_widget)
      Protected Result.i
      
      With *this
        If *this
          If \scroll
            If \scroll\v
              FreeStructure(\scroll\v) : \scroll\v = 0
            EndIf
            If \scroll\h
              FreeStructure(\scroll\h)  : \scroll\h = 0
            EndIf
            ; *this\scroll = 0
          EndIf
          
          If \splitter
            If \splitter\first
              FreeStructure(\splitter\first) : \splitter\first = 0
            EndIf
            If \splitter\second
              FreeStructure(\splitter\second)  : \splitter\second = 0
            EndIf
            *this\splitter = 0
          EndIf
          
          If *this\parent 
            If *this\parent\scroll\v = *this
              FreeStructure(*this\parent\scroll\v) : *this\parent\scroll\v = 0
            EndIf
            If *this\parent\scroll\h = *this
              FreeStructure(*this\parent\scroll\h)  : *this\parent\scroll\h = 0
            EndIf
            
            If *this\parent\splitter
              If *this\parent\splitter\first = *this
                FreeStructure(*this\parent\splitter\first) : *this\parent\splitter\first = 0
              EndIf
              If *this\parent\splitter\second = *this
                FreeStructure(*this\parent\splitter\second)  : *this\parent\splitter\second = 0
              EndIf
            EndIf
          EndIf
          
          
          Debug  " - "+ListSize(GetChildrens(*this\parent)) +" "+ *this\parent\root\count\childrens +" "+ *this\parent\count\childrens
          If *this\parent And
             *this\parent\count\childrens 
            
            LastElement(GetChildrens(*this\parent))
            Repeat
              If GetChildrens(*this\parent) = *this Or
                 Child(GetChildrens(*this\parent), *this)
                
                Debug "  \"+GetChildrens(*this\parent)\index
                
                GetChildrens(*this\parent)\root\count\childrens - 1
                GetChildrens(*this\parent)\parent\count\childrens - 1;Bool(GetChildrens(*this\parent)\parent <> GetChildrens(*this\parent)\root)
                DeleteElement(GetChildrens(*this\parent), 1)
                
                If GetChildrens(*this\parent)\parent\count\childrens = 0 ; ListSize(GetChildrens(*this\parent)) = 0
                  Break
                EndIf
              ElseIf PreviousElement(GetChildrens(*this\parent)) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  " - "+ListSize(GetChildrens(*this\parent)) +" "+ *this\parent\root\count\childrens +" "+ *this\parent\count\childrens
          
          
          
          If Root()\entered = *this
            Root()\entered = *this\parent
          EndIf
          If Root()\selected = *this
            Root()\selected = *this\parent
          EndIf
          
          ; *this = 0
          ;ClearStructure(*this, _s_widget)
        EndIf
      EndWith
      
      ProcedureReturn Result
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
    
    
    ;-
    Procedure Events(*this._s_widget, _event_type_.l, _mouse_x_.l, _mouse_y_.l, _wheel_x_.b=0, _wheel_y_.b=0)
      Protected Repaint
      
      If Not _is_widget_(*this)
        If Not _is_root_(*this)
          Debug "not event widget - " + *this
        EndIf
        ProcedureReturn 
      EndIf
      
      ; set event widget 
      Widget() = *this
      
      Select _event_type_ 
        Case #__Event_Focus,
             #__Event_LostFocus 
          
;           Select *this\type
;             Case #__Type_Window,
;                  #__Type_String,
;                  #__Type_Tree, 
;                  #__Type_ListView, 
;                  #__Type_ListIcon
              
              Post(_event_type_, *this, *this\index[#__s_1])
;           EndSelect
      EndSelect
          
      If _event_type_ = #__Event_LeftButtonUp 
        Debug ""+*this\root +" "+ *this\adress +" "+  SizeOf(*this\adress) ; *this\root\adress
        
        If *this\bar\state >= 0
          If *this\bar\button[*this\bar\state]\state = #__s_2
            ;Debug " up button - " + *this\bar\state
            *this\bar\button[*this\bar\state]\state = #__s_1
            Repaint = #True
          EndIf
          
          ;Debug ""+*this\bar\state +" "+ *this\bar\from
          
          If *this\bar\state <> *this\bar\from
            If *this\bar\button[*this\bar\state]\state = #__s_1
              *this\bar\button[*this\bar\state]\state = #__s_0
              
              If *this\bar\state = #__b_3 And *this\cursor
                Debug  "  reset cur"
                ;                 set_cursor(*this, #PB_Cursor_Default)
                SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
              EndIf
              
              ; Debug " up leave button - " + *this\bar\state
              Repaint = #True
            EndIf
          EndIf
          
          *this\bar\button[#__b_3]\fixed = 0 ; reset delta pos
        EndIf
      EndIf
      
      If _event_type_ = #__Event_MouseMove Or
         _event_type_ = #__Event_MouseEnter Or
         _event_type_ = #__Event_MouseLeave Or
         _event_type_ = #__Event_LeftButtonUp
        
        ;         Protected thumb = #__b_3
        ;         
        ;         If *this\type = #PB_GadgetType_TabBar And
        ;            (_from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_1]) Or 
        ;             _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_2]))
        ;           thumb = 0 ; thumb = #__b_3 And 
        ;         EndIf
        
        If *this\bar\button[#__b_3]\interact And
           *this\bar\button[#__b_3]\state <> #__s_3 And
           _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_3]) And
           (Bool(Not *this\bar\vertical And _mouse_x_ >= *this\bar\area\pos And _mouse_x_ =< *this\bar\area\pos+*this\bar\area\len) Or 
            Bool(*this\bar\vertical And _mouse_y_ >= *this\bar\area\pos And _mouse_y_ =< *this\bar\area\pos+*this\bar\area\len))
          
          If *this\bar\from <> #__b_3
            If *this\bar\button[#__b_3]\state = #__s_0
              *this\bar\button[#__b_3]\state = #__s_1
              
              If *this\bar\from = #__b_1
                ; Debug " leave button - (1 >> 3)"
                If *this\bar\button[#__b_1]\state = #__s_1
                  *this\bar\button[#__b_1]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_2
                ; Debug " leave button - (2 >> 3)"
                If *this\bar\button[#__b_2]\state = #__s_1  
                  *this\bar\button[#__b_2]\state = #__s_0
                EndIf
              EndIf
              
              If Not *this\root\selected And *this\cursor 
                Debug " set cur"
                ; set_cursor(*this, *this\cursor)
                SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
              EndIf
              
              *this\bar\from = #__b_3
              ; Debug " enter button - 3"
              Repaint = #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_2]\interact And
               *this\bar\button[#__b_2]\state <> #__s_3 And 
               _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_2])
          
          If *this\bar\from <> #__b_2
            If *this\bar\button[#__b_2]\state = #__s_0
              *this\bar\button[#__b_2]\state = #__s_1
              
              If *this\bar\from = #__b_1
                ; Debug " leave button - (1 >> 2)"
                If *this\bar\button[#__b_1]\state = #__s_1
                  *this\bar\button[#__b_1]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                ; Debug " leave button - (3 >> 2)"
                If *this\bar\button[#__b_3]\state = #__s_1  
                  *this\bar\button[#__b_3]\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_2
              ; Debug " enter button - 2"
              Repaint = #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_1]\interact And 
               *this\bar\button[#__b_1]\state <> #__s_3 And 
               _from_point_(_mouse_x_, _mouse_y_, *this\bar\button[#__b_1])
          
          If *this\bar\from <> #__b_1
            If *this\bar\button[#__b_1]\state = #__s_0
              *this\bar\button[#__b_1]\state = #__s_1
              
              If *this\bar\from = #__b_2
                ; Debug " leave button - (2 >> 1)"
                If *this\bar\button[#__b_2]\state = #__s_1  
                  *this\bar\button[#__b_2]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                ; Debug " leave button - (3 >> 1)"
                If *this\bar\button[#__b_3]\state = #__s_1  
                  *this\bar\button[#__b_3]\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_1
              ; Debug " enter button - 1"
              Repaint = #True
            EndIf
          EndIf
          
        Else
          If *this\bar\from <>- 1
            If *this\bar\button[*this\bar\from]\state = #__s_1
              *this\bar\button[*this\bar\from]\state = #__s_0
              
              If Not *this\root\selected 
                If *this\bar\from = #__b_3 And *this\cursor
                  Debug  " reset cur"
                  ;                 set_cursor(*this, #PB_Cursor_Default)
                  SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                EndIf
              EndIf
              
              ; Debug " leave button - " + *this\bar\from
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
        
        If *this\Type <> #PB_GadgetType_TrackBar
          ; set button_1 color state
          If *this\bar\button[#__b_1]\color\state <> #__s_3 And 
             *this\bar\button[#__b_1]\color\state <> *this\bar\button[#__b_1]\state
            *this\bar\button[#__b_1]\color\state = *this\bar\button[#__b_1]\state
          EndIf
          
          ; set button_2 color state
          If *this\bar\button[#__b_2]\color\state <> #__s_3 And 
             *this\bar\button[#__b_2]\color\state <> *this\bar\button[#__b_2]\state
            *this\bar\button[#__b_2]\color\state = *this\bar\button[#__b_2]\state
          EndIf
          
          ; set thumb color state
          If *this\bar\button[#__b_3]\color\state <> #__s_3 And 
             *this\bar\button[#__b_3]\color\state <> *this\bar\button[#__b_3]\state
            *this\bar\button[#__b_3]\color\state = *this\bar\button[#__b_3]\state
          EndIf
        EndIf
        
        If Not *this\root\mouse\buttons
          *this\bar\state = *this\bar\from
        EndIf
      EndIf
      
      If _event_type_ = #__Event_MouseEnter
        *this\color\back = $ff0000ff 
        Repaint = #True
      EndIf
      
      If _event_type_ = #__Event_MouseLeave
        *this\color\back = $ff00ff00
        Repaint = #True
      EndIf
      
      If _event_type_ = #__Event_LeftButtonDown
        If *this\bar\from >= 0 And 
           *this\bar\button[*this\bar\from]\state = #__s_1
          *this\bar\button[*this\bar\from]\state = #__s_2
          *this\bar\state = *this\bar\from
          
          If *this\Type <> #PB_GadgetType_TrackBar
            ; set color state
            If *this\bar\button[*this\bar\from]\color\state <> #__s_3 And 
               *this\bar\button[*this\bar\from]\color\state <> *this\bar\button[*this\bar\from]\state
              *this\bar\button[*this\bar\from]\color\state = *this\bar\button[*this\bar\from]\state
            EndIf
          EndIf
          
          If *this\bar\from = #__b_3
            If *this\bar\vertical
              *this\bar\button[*this\bar\from]\fixed = _mouse_y_ - *this\bar\thumb\pos
            Else
              *this\bar\button[*this\bar\from]\fixed = _mouse_x_ - *this\bar\thumb\pos
            EndIf
            
            Repaint = *this\bar\button[*this\bar\from]\fixed
          ElseIf (*this\bar\from = #__b_1 And *this\bar\inverted) Or
                 (*this\bar\from = #__b_2 And Not *this\bar\inverted)
            Repaint = widget::SetState(*this, *this\bar\page\pos + *this\bar\scroll_step)
            
          ElseIf (*this\bar\from = #__b_2 And *this\bar\inverted) Or 
                 (*this\bar\from = #__b_1 And Not *this\bar\inverted)
            Repaint = widget::SetState(*this, *this\bar\page\pos - *this\bar\scroll_step)
          EndIf
        EndIf
        
        If *this\type = #__Type_Window
          *this\caption\interact = _from_point_(_mouse_x_, _mouse_y_, *this\caption, [2])
          
          ; close button
          If _from_point_(_mouse_x_, _mouse_y_, *this\caption\button[0])
            ProcedureReturn close_window(*this)
          EndIf
          
          ; maximize button
          If _from_point_(_mouse_x_, _mouse_y_, *this\caption\button[1])
            If Not *this\resize & #__resize_maximize And
               Not *this\resize & #__resize_minimize
              
              ProcedureReturn SetState_Window(*this, #__window_maximize)
            Else
              ProcedureReturn SetState_Window(*this, #__window_normal)
            EndIf
          EndIf
          
          ; minimize button
          If _from_point_(_mouse_x_, _mouse_y_, *this\caption\button[2])
            If Not *this\resize & #__resize_minimize
              ProcedureReturn SetState_Window(*this, #__window_minimize)
            EndIf
          EndIf
        EndIf
      EndIf
      
      If _event_type_ = #__Event_MouseMove
        If *this\bar\button[#__b_3]\fixed And *this = *this\root\selected And *this\bar\state
          Repaint = widget::SetPos(*this, (((Bool(Not *this\bar\vertical) * _mouse_x_) + (Bool(*this\bar\vertical) * _mouse_y_)) - *this\bar\button[#__b_3]\fixed))
          
          SetWindowTitle(EventWindow(), Str(*this\bar\page\pos) +" "+ Str(*this\bar\thumb\pos-*this\bar\area\pos))
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure CallBack()
      Protected Canvas.i = EventGadget()
      Protected eventtype.i = EventType()
      Protected Repaint, Change, enter, leave
      Protected Width = GadgetWidth(Canvas)
      Protected Height = GadgetHeight(Canvas)
      Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
      ;      mouse_x = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
      ;      mouse_y = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
      Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
      
      Protected *this._s_widget
      Root() = GetGadgetData(Canvas)
      
      Select eventtype
        Case #__Event_repaint 
          Repaint = 1
          
        Case #__Event_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          Resize(Root(), #PB_Ignore, #PB_Ignore, Width, Height)  
          ;Resize(Root()\parent, #PB_Ignore, #PB_Ignore, Width-Root()\parent\bs*2, Height-Root()\parent\bs*2-Root()\parent\__height)  
          ;         Root()\Width = Width
          ;         Root()\Height = Height 
          Repaint = 1
      EndSelect
      
      ; set mouse buttons
      If eventtype = #__Event_LeftButtonDown
        Root()\mouse\buttons | #PB_Canvas_LeftButton
      ElseIf eventtype = #__Event_RightButtonDown
        Root()\mouse\buttons | #PB_Canvas_RightButton
      ElseIf eventtype = #__Event_MiddleButtonDown
        Root()\mouse\buttons | #PB_Canvas_MiddleButton
      ElseIf eventtype = #__Event_MouseMove
        If Root()\mouse\x <> mouse_x
          Root()\mouse\x = mouse_x
          change = #True
        EndIf
        
        If Root()\mouse\y <> mouse_y
          Root()\mouse\y = mouse_y
          change = #True
        EndIf
        
        ; Drag start
        If Root()\mouse\buttons And Not Root()\mouse\drag And
           Root()\mouse\x>Root()\mouse\delta\x-3 And 
           Root()\mouse\x<Root()\mouse\delta\x+3 And 
           Root()\mouse\y>Root()\mouse\delta\y-3 And
           Root()\mouse\y<Root()\mouse\delta\y+3
          
          Root()\mouse\drag = 1
          
          repaint | Events(Root()\entered, #__Event_DragStart, mouse_x, mouse_y)
        EndIf
        
      ElseIf Not Root()\mouse\buttons And 
             (eventtype = #__Event_MouseEnter Or 
              eventtype = #__Event_MouseLeave)
        change =- 1
      EndIf
      
      ; widget enter&leave mouse events
      If change
        ; get at point
        LastElement(Root()\_childrens()) 
        Repeat                                 
          If _is_widget_(Root()\_childrens()) And Root()\_childrens()\draw And _from_point_(mouse_x, mouse_y, Root()\_childrens(), [#__c_4])
            *this = Root()\_childrens()
            
            ; scrollbars events
            If *this And *this\scroll
              If *this\scroll\v And Not *this\scroll\v\hide And 
                 *this\scroll\v\type And _from_point_(mouse_x,mouse_y, *this\scroll\v, [#__c_4])
                *this = *this\scroll\v
              ElseIf *this\scroll\h And Not *this\scroll\h\hide And 
                     *this\scroll\h\type And _from_point_(mouse_x,mouse_y, *this\scroll\h, [#__c_4])
                *this = *this\scroll\h
              EndIf
            EndIf
            
            Break
          EndIf
        Until PreviousElement(Root()\_childrens()) = #False 
        
        If Not *this : *this = Root() : EndIf
        
        ; set widget mouse
        ; state - (entered & leaved)
        If Root()\entered <> *this
          If Root()\entered And Root()\entered\state = #__s_1 And 
             Not (#__from_mouse_state And Child(*this, Root()\entered))
            Root()\entered\state = #__s_0
            
            Repaint | Events(Root()\entered, #__Event_MouseLeave, mouse_x, mouse_y)
            
            If #__from_mouse_state
              ChangeCurrentElement(Root()\_childrens(), Root()\entered\adress)
              Repeat                 
                If Root()\_childrens()\draw And Child(Root()\entered, Root()\_childrens())
                  If Root()\_childrens()\state = #__s_1
                    Root()\_childrens()\state = #__s_0
                    
                    Repaint | Events(Root()\_childrens(), #__Event_MouseLeave, mouse_x, mouse_y)
                  EndIf
                EndIf
              Until PreviousElement(Root()\_childrens()) = #False 
            EndIf
            
            Root()\entered = *this
          EndIf
          
          If *this And
             *this\state = #__s_0 
            *this\state = #__s_1
            Root()\entered = *this
            
            If #__from_mouse_state
              ForEach Root()\_childrens()
                If Root()\_childrens() = Root()\entered
                  Break
                EndIf
                
                If Root()\_childrens()\draw And Child(Root()\entered, Root()\_childrens())
                  If Root()\_childrens()\state = #__s_0
                    Root()\_childrens()\state = #__s_1
                    
                    Repaint | Events(Root()\_childrens(), #__Event_MouseEnter, mouse_x, mouse_y)
                  EndIf
                EndIf
              Next
            EndIf
            
            Repaint | Events(Root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
          EndIf
        EndIf  
      EndIf
      
      ; set active widget
      If (eventtype = #__Event_LeftButtonDown Or
          eventtype = #__Event_RightButtonDown) And _is_widget_(Root()\entered) 
        
        Root()\mouse\delta\x = mouse_x - Root()\entered\x[#__c_3]
        Root()\mouse\delta\y = mouse_y - Root()\entered\y[#__c_3]
        Root()\selected = Root()\entered
        
        Repaint | SetActive(Root()\entered)
      EndIf
      
      If eventtype <> #__Event_MouseMove
        change = 1
      EndIf
      
      ;
      If eventtype = #__Event_LeftClick Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_DragStart Or
         eventtype = #__Event_Focus
        ; 
      ElseIf eventtype = #__Event_Input Or
             eventtype = #__Event_KeyDown Or
             eventtype = #__Event_KeyUp
        
        ; widget key events
        If GetActive() 
          If GetActive()\gadget
            Repaint | Events(GetActive()\gadget, eventtype, mouse_x, mouse_y)
          Else
            Repaint | Events(GetActive(), eventtype, mouse_x, mouse_y)
          EndIf
        EndIf
        
      Else
        If Root()\entered And change
          Repaint | Events(Root()\entered, eventtype, mouse_x, mouse_y)
        EndIf
        If Root()\selected And Root()\entered <> Root()\selected And change 
          Repaint | Events(Root()\selected, eventtype, mouse_x, mouse_y)
        EndIf
      EndIf
      
      ; reset mouse buttons
      If Root()\mouse\buttons
        If eventtype = #__Event_LeftButtonUp
          Root()\mouse\buttons &~ #PB_Canvas_LeftButton
        ElseIf eventtype = #__Event_RightButtonUp
          Root()\mouse\buttons &~ #PB_Canvas_RightButton
        ElseIf eventtype = #__Event_MiddleButtonUp
          Root()\mouse\buttons &~ #PB_Canvas_MiddleButton
        EndIf
        
        If Not Root()\mouse\buttons
          ; ;         ; post drop event
          ; ;         If DD::EventDrop(Root()\entered, #__Event_LeftButtonUp)
          ; ;           Events(Root()\entered, #__Event_drop, mouse_x, mouse_y)
          ; ;         EndIf
          
          ;             If Not Root()\entered
          ;               
          ;               DD::EventDrop(-1, #__Event_leftButtonUp)
          ;               
          ;             EndIf
          
          If GetActive() 
            If GetActive()\state
              If Not Root()\mouse\drag
                Repaint | Events(GetActive(), #__Event_LeftClick, mouse_x, mouse_y)
              EndIf
            Else
              Repaint | Events(GetActive(), #__Event_MouseLeave, mouse_x, mouse_y)
              Repaint | Events(Root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
            EndIf
            
            If _is_widget_(GetActive()\gadget)
              If GetActive()\gadget\state
                If Not Root()\mouse\drag
                  Repaint | Events(GetActive()\gadget, #__Event_LeftClick, mouse_x, mouse_y)
                EndIf
              Else
                Repaint | Events(GetActive()\gadget, #__Event_MouseLeave, mouse_x, mouse_y)
                Repaint | Events(Root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
              EndIf
            EndIf
          EndIf
          
          Root()\mouse\drag = 0
          Root()\selected = 0
        EndIf
      EndIf
      
      If Repaint 
        If Root()\repaint = #True
          
          ;       If Root()\entered And Root()\entered\bar\button[#__b_3]\color\state
          ; ;         Debug Root()\entered\bar\button[#__b_3]\color\state
          ; ;       EndIf
          ;       ;       If Root()\entered And Root()\entered\type = #__Type_tree
          ;                ReDraw(Root()\entered)
          ;            Else
          ReDraw(Root())
          ;             EndIf
        EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure Resize_CanvasWindow()
      Protected canvas = GetWindowData(EventWindow())
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-GadgetX(canvas)*2, WindowHeight(EventWindow())-GadgetY(canvas)*2)
    EndProcedure
    
    Procedure Canvas(window, x.l=0,y.l=0,width.l=#PB_Ignore,height.l=#PB_Ignore, flag.i=#Null, *CallBack=#Null)
      If width = #PB_Ignore And 
         height = #PB_Ignore
        flag = #PB_Canvas_Container
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth(window, #PB_Window_InnerCoordinate)
      EndIf
      If height = #PB_Ignore
        height = WindowHeight(window, #PB_Window_InnerCoordinate)
      EndIf
      
      If flag & #PB_Canvas_Container
        width - x
        height - y
      Else
        BindEvent(#PB_Event_SizeWindow, @Resize_CanvasWindow(), Window);, Canvas)
      EndIf
      
      Protected Canvas = CanvasGadget(#PB_Any, x,y,width,height, Flag)
      Root() = AllocateStructure(_s_root)
      Root()\class = "Root"
      ; Root()\adress = Root()
      Root()\root = Root()
      Root()\opened = Root()
      Root()\parent = Root()
      Root()\window = Root()
      
      Root()\canvas\window = window
      Root()\canvas\gadget = Canvas
      
      If flag & #PB_Canvas_Container = #PB_Canvas_Container
        Root()\container = Canvas
      EndIf
      
      GetActive() = Root()
      GetActive()\root = Root()
      
      SetGadgetData(Canvas, Root())
      SetWindowData(window, Canvas)
      
      If Not *CallBack
        *CallBack = @CallBack()
        Root()\repaint = #True
      EndIf
      
      ; z-order
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
        SetWindowPos_( GadgetID(Canvas), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      CompilerEndIf
      
      BindGadgetEvent(Canvas, *CallBack)
      PostEvent(#PB_Event_Gadget, Window, Canvas, #__Event_Resize)
      
      ; SetActive(Root())
      
      ProcedureReturn Canvas
    EndProcedure
    
    Procedure OpenWindow_(Window, x.l,y.l,width.l,height.l, Title.s, Flag.i=#Null, ParentID.i=#Null)
      Protected w = OpenWindow(Window, x,y,width,height, Title, Flag, ParentID) : If Window =- 1 : Window = w : EndIf
      Protected Canvas = Canvas(Window, 0, 0, Width, Height, #PB_Canvas_Container);, @CallBack()) ;: CloseGadgetList()
      ProcedureReturn Root()
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf

Macro Uselib(_name_)
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro


;-
CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
    widget::OpenWindow_(Window, X, Y, Width, Height, Title, Flag, ParentID)
  EndMacro
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    ;ProcedureReturn
    ForEach Root()\_childrens()
      If Root()\_childrens()\bar\vertical And Root()\_childrens()\type = GadgetType(EventGadget())
        Repaint | SetState(Root()\_childrens(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(Root())
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    ;ProcedureReturn
    ForEach Root()\_childrens()
      If Not Root()\_childrens()\bar\vertical And Root()\_childrens()\type = GadgetType(EventGadget())
        Repaint | SetState(Root()\_childrens(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(Root())
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
    widget::Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    widget::SetState    (Widget(),  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    widget::Scroll  (300+10, 42+30, 250,  10, 30, 150, 230, #__bar_inverted, 7)
    widget::SetState    (Widget(),  50)  ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    widget::Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    widget::SetState    (Widget(), 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    widget::Scroll  (300+270+30, 10,  25, 120 ,0, 300, 50, #__bar_vertical|#__bar_inverted, 7)
    widget::SetState    (Widget(), 100)  ; set 2nd scrollbar (ID = 1) to 100 of 300
    
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
    widget::Track(300+10,  140+40, 250, 20, 0, 10000, 0)
    widget::SetState(Widget(), 5000)
    widget::Track(300+10,  140+40+20, 250, 20, 0, 10000, #__bar_inverted)
    widget::SetState(Widget(), 5000)
    TextGadget    (-1, 300+10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     widget::Track(300+10, 140+120, 250, 20, 0, 30, #__bar_ticks)
    widget::Track(300+10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    widget::SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    widget::Track(300+270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    widget::SetAttribute(Widget(), #__bar_Inverted, 0)
    widget::SetState(Widget(), 8000)
    widget::Track(300+270+30, 140+10, 25, 170, 0, 10000, #__bar_vertical|#__bar_inverted)
    widget::SetState(Widget(), 8000)
    
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
    widget::Progress  (300+10, 140+200+42, 250,  20, 30, 100, 0)
    widget::SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    widget::Progress  (300+10, 140+200+42+30, 250,  10, 30, 100, #__bar_inverted, 4)
    widget::SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    widget::Progress  (300+270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical, 19)
    widget::SetAttribute(Widget(), #__bar_Inverted, 0)
    widget::SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    widget::Progress  (300+270+30, 140+200,  25, 120 ,0, 300, #__bar_vertical|#__bar_inverted)
    widget::SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
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
    
    Button_0 = widget::Spin(0, 0, 0, 0, 0, 20) ; No need to specify size or coordinates
    
    Button_1 = widget::Form(0, 0, 330, 0, "form", #PB_Window_TitleBar|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget) 
    Container(10,10,100,100)
    Container(10,10,100,100)
    Container(10,10,100,100)
    CloseList()
    CloseList()
    CloseList()
    CloseList() ; No need to specify size or coordinates
    
    ;     Button_1 = widget::Tab(0, 0, 0, 0, 0, 0, 0); No need to specify size or coordinates
    ;     AddItem(Button_1, -1, "Tab_0")
    ;     AddItem(Button_1, -1, "Tab_1 (long)")
    ;     AddItem(Button_1, -1, "Tab_2")
    
    ;     Button_10 = widget::Scroll(0, 0, 0, 0, 0, 100, 20) ; No need to specify size or coordinates
    ;     Button_1 = widget::Splitter(0, 0, 0, 0, Button_10, Button_1, #PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    
    Button_2 = widget::ScrollArea(0, 0, 0, 0, 150, 150, 1) : CloseList()        ; as they will be sized automatically
    Button_3 = widget::Progress(0, 0, 0, 0, 0, 100, 30)                         ; as they will be sized automatically
    
    Button_4 = widget::Spin(0, 0, 0, 0, 50,100, #__bar_vertical) ; as they will be sized automatically
    Button_5 = widget::Tab(0, 0, 0, 0, 0, 0, 0)                  ; No need to specify size or coordinates
    AddItem(Button_5, -1, "Tab_0")
    AddItem(Button_5, -1, "Tab_1 (long)")
    AddItem(Button_5, -1, "Tab_2")
    
    widget::SetState(Button_0, 50)
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 20)
    ;widget::SetState(Splitter_1, 410/2-20)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = widget::Splitter(300+10, 140+200+130, 285+30, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    ; widget::SetState(Button_2, 5)
    widget::SetState(Splitter_0, 26)
    widget::SetState(Splitter_4, 225)
    widget::SetState(Splitter_3, 55)
    widget::SetState(Splitter_2, 15)
    
    If Button_2 And OpenList(Button_2)
      Button_4 = widget::ScrollArea(-1, -1, 50, 50, 100, 100, 1);, #__flag_noGadget)
                                                             ;       Define i
                                                             ;       For i=0 To 1000
      widget::Progress(10, 10, 50, 30, 1, 100, 30)
      ;       Next
      CloseList()
      widget::Progress(100, 10, 50, 30, 2, 100, 30)
      CloseList()
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --------------------------------------------------------------------------------------------------------------------------
; EnableXP