CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "include/fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget"
CompilerEndIf


CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "include/constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "include/structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "include/colors.pbi"
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
      colors::*this\blue
    EndMacro
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro Root()
      structures::*event\root
    EndMacro
    
    Macro Widget()
      GetChildrens(Root())
    EndMacro
    
    Macro GetActive() ; Returns active window
      structures::*event\active
    EndMacro
    
    Macro GetChildrens(_this_) ; Returns active window
                               ; _this_\root\_childrens()
      *event\_childrens()
    EndMacro
    
    ;-
    Macro _is_root_(_this_)
      Bool(_this_ And _this_ = _this_\root) ; * _this_\root
    EndMacro
    
    Macro _is_item_(_this_, _item_)
      Bool(_item_ >= 0 And _item_ < _this_\count\items)
    EndMacro
    
    Macro _is_widget_(_this_)
      Bool(_this_ And _this_\adress) ; * _this_\adress
    EndMacro
    
    Macro _is_window_(_this_)
      Bool(_this_ And _this_ = _this_\window)
    EndMacro
    
    Macro _is_scrollbar_(_this_)
      Bool(_this_\parent And _this_\parent\scroll And (_this_\parent\scroll\v = _this_ Or _this_ = _this_\parent\scroll\h))
    EndMacro
    
    ;-
    Macro _bar_scrollarea_change_(_this_, _pos_, _len_)
      Bool(Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, ((_pos_)+_this_\bar\min))) Or
           Bool((((_pos_)+_this_\bar\min)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And Bar_SetState(_this_, ((_pos_)+_this_\bar\min)-(_this_\bar\page\len-(_len_)))))
    EndMacro
    
    Macro _tree_bar_update_(_this_, _pos_, _len_)
      ;       Bool(Bool((_pos_-_this_\y-_this_\bar\page\pos) < 0 And bar_SetState(_this_, (_pos_-_this_\y))) Or
      ;            Bool((_pos_-_this_\y-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
      ;                 bar_SetState(_this_, (_pos_-_this_\y) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
      _bar_scrollarea_change_(_this_, _pos_-_this_\y, _len_)
    EndMacro
    
    Macro _bar_scrollarea_update_(_this_)
      ;Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;Resizes(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      ;Updates(_this_\scroll, _this_\x, _this_\y, _this_\width, _this_\height)
      _this_\width[#__c_2] = _this_\scroll\h\bar\page\len ; *this\width[#__c_3] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
      _this_\height[#__c_2] = _this_\scroll\v\bar\page\len; *this\height[#__c_3] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
      
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
    
    Macro _make_area_height_(_scroll_, _width_, _height_)
      (_height_ - (Bool((_scroll_\width > _width_) Or Not _scroll_\h\hide) * _scroll_\h\height)) 
    EndMacro
    
    Macro _make_area_width_(_scroll_, _width_, _height_)
      (_width_ - (Bool((_scroll_\height > _height_) Or Not _scroll_\v\hide) * _scroll_\v\width))
    EndMacro
    
    ;-
    Macro _from_point_(mouse_x, mouse_y, _type_, _mode_=)
      Bool(mouse_x > _type_\x#_mode_ And mouse_x < (_type_\x#_mode_+_type_\width#_mode_) And 
           mouse_y > _type_\y#_mode_ And mouse_y < (_type_\y#_mode_+_type_\height#_mode_))
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
      (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\percent, #PB_Round_Nearest))
    EndMacro
    
    Macro _bar_thumb_pos_(_bar_, _scroll_pos_)
      (_bar_\area\pos + Round(((_scroll_pos_) - _bar_\min) * _bar_\percent, #PB_Round_Nearest)) 
      
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
    
    Macro MDI_Update(_child_)
      _child_\parent\scroll\x = _child_\x 
      _child_\parent\scroll\y = _child_\Y
      _child_\parent\scroll\width = _child_\x+_child_\width - _child_\parent\scroll\x
      _child_\parent\scroll\height = _child_\Y+_child_\height - _child_\parent\scroll\y
      
      PushListPosition(GetChildrens(_child_))
      ForEach GetChildrens(_child_)
        If GetChildrens(_child_)\parent = _child_\parent
          If _child_\parent\scroll\x > GetChildrens(_child_)\x 
            _child_\parent\scroll\x = GetChildrens(_child_)\x 
          EndIf
          If _child_\parent\scroll\y > GetChildrens(_child_)\y 
            _child_\parent\scroll\y = GetChildrens(_child_)\y 
          EndIf
        EndIf
      Next
      ForEach GetChildrens(_child_)
        If GetChildrens(_child_)\parent = _child_\parent
          If _child_\parent\scroll\width < GetChildrens(_child_)\x+GetChildrens(_child_)\width - _child_\parent\scroll\x 
            _child_\parent\scroll\width = GetChildrens(_child_)\x+GetChildrens(_child_)\width - _child_\parent\scroll\x 
          EndIf
          If _child_\parent\scroll\height < GetChildrens(_child_)\Y+GetChildrens(_child_)\height - _child_\parent\scroll\y 
            _child_\parent\scroll\height = GetChildrens(_child_)\Y+GetChildrens(_child_)\height - _child_\parent\scroll\y 
          EndIf
        EndIf
      Next
      PopListPosition(GetChildrens(_child_))
      
      If widget::Updates(_child_\parent\scroll, _child_\parent\x[#__c_2], _child_\parent\y[#__c_2], _child_\parent\width[#__c_3], _child_\parent\height[#__c_3])
        
        _child_\parent\width[#__c_2] = _child_\parent\scroll\h\bar\page\len
        _child_\parent\height[#__c_2] = _child_\parent\scroll\v\bar\page\len
        
        If _child_\parent\container And _child_\parent\count\childrens
          PushListPosition(GetChildrens(_child_))
          ForEach GetChildrens(_child_)
            If GetChildrens(_child_)\parent = _child_\parent
              Clip(GetChildrens(_child_), #True)
            EndIf
          Next
          PopListPosition(GetChildrens(_child_))
        EndIf
      EndIf
      
    EndMacro
    
    
    ;-
    ;-
    ;-  DECLAREs
    ;{
    Declare  SetClass(*this._s_widget, class.s)
    
    Declare a_add(*this._s_widget, Size.l=6, Pos.l=-1)
    Declare a_get(*this._s_widget, index.i=-1)
    Declare a_set(*this._s_widget)
    
    Declare   Child(*this, *parent)
    Declare.l X(*this, mode.l=#__c_0)
    Declare.l Y(*this, mode.l=#__c_0)
    Declare.l Width(*this, mode.l=#__c_0)
    Declare.l Height(*this, mode.l=#__c_0)
    Declare.l GetMouseX(*this, mode.l = #__c_0)
    Declare.l GetMouseY(*this, mode.l = #__c_0)
    
    Declare.b Draw(*this)
    Declare   ReDraw(*this)
    
    Declare.l GetDeltaX(*this)
    Declare.l GetDeltaY(*this)
    Declare.l GetIndex(*this)
    Declare.l GetLevel(*this)
    Declare.l GetButtons(*this)
    Declare.s GetClass(*this)
    Declare.l GetType(*this)
    Declare.i GetRoot(*this)
    Declare.i GetData(*this)
    Declare.i GetGadget(*this)
    Declare.i GetWindow(*this)
    Declare.l GetCount(*this, mode.b=#False)
    Declare.i GetParent(*this, mode.b=#False)
    
    Declare.i SetActive(*this)
    
    Declare.b Hide(*this, State.b=-1)
    Declare.b Update(*this)
    ; Declare.b SetPos(*this, ThumbPos.i)
    Declare.b Change(*this, ScrollPos.f)
    Declare.b Resize(*this, ix.l,iy.l,iwidth.l,iheight.l)
    
    
    Declare.l CountItems(*this)
    Declare.l ClearItems(*this)
    Declare   RemoveItem(*this, Item.l) 
    
    Declare GetWidget(index)
    
    Declare.s GetText(*this)
    Declare   SetText(*this, text.s)
    
    Declare.f GetState(*this)
    Declare.b SetState(*this, state.f)
    
    Declare.i GetItemAttribute(*this, Item.l,  Attribute.l, Column.l=0)
    Declare.i SetItemAttribute(*this, Item.l, Attribute.l, Value.l, Column.l=0)
    
    Declare.i GetItemData(*this, item.l)
    Declare.i SetItemData(*this, item.l, *data)
    
    Declare.s GetItemText(*this, Item.l, Column.l=0)
    Declare.l SetItemText(*this, Item.l, Text.s, Column.l=0)
    
    Declare.i GetItemImage(*this, Item.l)
    Declare.i SetItemImage(*this, Item.l, Image.i)
    
    Declare.i GetItemFont(*this, Item.l)
    Declare.i SetItemFont(*this, Item.l, Font.i)
    
    Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
    Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
    
    Declare.l GetItemState(*this, Item.l)
    Declare.b SetItemState(*this, Item.l, State.b)
    
    Declare.l GetAttribute(*this, Attribute.l)
    Declare.l SetAttribute(*this, Attribute.l, Value.l)
    
    Declare.i SetAlignment(*this, Mode.l, Type.l=1)
    Declare.i SetData(*this, *data)
    Declare   SetParent(*this, *parent, parent_item.l=0)
    
    Declare   GetPosition(*this, position.l)
    Declare   SetPosition(*this, position.l, *widget_2=#Null)
    
    Declare.l GetColor(*this, ColorType.l)
    Declare.l SetColor(*this, ColorType.l, Color.l)
    
    Declare.i GetFont(*this)
    Declare.i SetFont(*this, FontID.i)
    
    Declare.i Create(type.l, *parent._s_widget, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i=0, round.l=7, ScrollStep.f=1.0)
    
    ; button
    Declare.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
    Declare.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
    Declare.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
    Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Declare.i CheckBox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
    Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
    
    ; bar
    ;Declare.i Area(*parent, ScrollStep, AreaWidth, AreaHeight, Width, Height, Mode = 1)
    Declare.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
    Declare.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Declare.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Declare.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Declare.i Splitter(x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i=0)
    
    ; list
    Declare.i Tree(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i ListView(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.i=0)
    
    Declare.i Image(x.l,y.l,width.l,height.l, image.l, Flag.i=0)
    
    ; container
    Declare.i Panel(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i Container(x.l,y.l,width.l,height.l, Flag.i=0)
    Declare.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i=0)
    Declare.i Window(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, *parent=0)
    Declare.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l=1, Flag.i=0)
    Declare.i MDI(x.l,y.l,width.l,height.l, Flag.i=0) 
    
    Declare   CallBack()
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l=0)
    
    Declare   Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
    Declare   Resizes(*scroll._S_scroll, x.l,y.l,width.l,height.l)
    Declare   AddItem(*this, Item.i, Text.s, Image.i=-1, sublevel.i=0)
    
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    
    Declare   Free(*this)
    Declare.i Bind(*this, *callback, eventtype.l=#PB_All)
    Declare.i Post(eventtype.l, *this, eventitem.l=#PB_All, *data=0)
    
    Declare   Events(*this, event_type.l, mouse_x.l, mouse_y.l, _wheel_x_.b=0, _wheel_y_.b=0)
    Declare   Open(Window, x.l=0,y.l=0,width.l=#PB_Ignore,height.l=#PB_Ignore, Flag.i=#Null, *callback=#Null, Canvas=#PB_Any)
    Declare.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s="", *param1=#Null, *param2=#Null, *param3=#Null, Flag.i=#Null,  window=-1, *CallBack=#Null)
    ;}
    
  EndDeclareModule
  
  Module widget
    Procedure   CreateIcon(img.l, type.l)
      Protected x,y,Pixel, size=8, index.i
      
      index = CreateImage(img, size, size) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing(ImageOutput(img))
        Box(0, 0, size, size, $fff0f0f0);GetSysColor_(#COLOR_BTNFACE))
        
        If type = 1
          Restore img_arrow_down
          For y = 0 To size-1
            For x = 0 To size-1
              Read.b Pixel
              
              If Pixel
                Plot(x, y, $000000)
              EndIf
            Next x
          Next y
          
        ElseIf type = 2
          Restore img_arrow_down
          For y = size-1 To 0 Step -1
            For x = 0 To size-1
              Read.b Pixel
              
              If Pixel
                Plot(x, y, $000000)
              EndIf
            Next x
          Next y
        EndIf 
        StopDrawing()
      EndIf
      
      DataSection
        
        img_arrow_down:
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        
        
        ;       img_arrow_>:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
        ;       img_arrow_v:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,0,0,0,1,0,0
        ;       Data.b 0,1,1,0,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       
        ;       img_close
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
      EndDataSection
    EndProcedure
    
    Procedure   DrawArrow(x.l, y.l, Direction.l, color.l)
      
      If Direction = 0
        ; left                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,0,0,0,0,0
        
        :                                               : Plot(x+3, y+1, color)                        
        :                       : Plot(x+2, y+2, color) : Plot(x+4, y+1, color)                     
        :                       : Plot(x+3, y+2, color) : Plot(x+5, y+1, color)
        : Plot(x+1, y+3, color) : Plot(x+4, y+2, color)
        : Plot(x+2, y+3, color)                                                                       
        : Plot(x+3, y+3, color) : Plot(x+2, y+4, color)                          
        :                       : Plot(x+3, y+4, color)     
        :                       : Plot(x+4, y+4, color) : Plot(x+3, y+5, color) 
        :                                               : Plot(x+4, y+5, color)                       
        :                                               : Plot(x+5, y+5, color)  
      EndIf
      
      If Direction = 1
        ; up                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,1,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,0,0,0,1,0
        ; 0,0,0,0,0,0,0
        
        :                                               : Plot(x+3, y+1, color) 
        :                       : Plot(x+2, y+2, color) : Plot(x+3, y+2, color) : Plot(x+4, y+2, color) 
        : Plot(x+1, y+3, color) : Plot(x+2, y+3, color) : Plot(x+3, y+3, color) : Plot(x+4, y+3, color) : Plot(x+5, y+3, color)
        : Plot(x+1, y+4, color) : Plot(x+2, y+4, color)                         : Plot(x+4, y+4, color) : Plot(x+5, y+4, color)
        : Plot(x+1, y+5, color)                                                                         : Plot(x+5, y+5, color)
      EndIf
      
      If Direction = 2
        ; right                                                 
        ; 0,0,0,0,0,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot(x+1, y+1, color)                        
        : Plot(x+2, y+1, color) : Plot(x+2, y+2, color)                      
        : Plot(x+3, y+1, color) : Plot(x+3, y+2, color) 
        :                       : Plot(x+4, y+2, color) : Plot(x+3, y+3, color)
        :                                               : Plot(x+4, y+3, color)                        
        :                       : Plot(x+2, y+4, color) : Plot(x+5, y+3, color)                          
        :                       : Plot(x+3, y+4, color)     
        : Plot(x+1, y+5, color) : Plot(x+4, y+4, color)
        : Plot(x+2, y+5, color)                       
        : Plot(x+3, y+5, color)  
      EndIf
      
      If Direction = 3
        ; down
        ; 0,0,0,0,0,0,0
        ; 0,1,0,0,0,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,1,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot(x+1, y+1, color)                                                                         : Plot(x+5, y+1, color)
        : Plot(x+1, y+2, color) : Plot(x+2, y+2, color)                         : Plot(x+4, y+2, color) : Plot(x+5, y+2, color)
        : Plot(x+1, y+3, color) : Plot(x+2, y+3, color) : Plot(x+3, y+3, color) : Plot(x+4, y+3, color) : Plot(x+5, y+3, color)
        :                       : Plot(x+2, y+4, color) : Plot(x+3, y+4, color) : Plot(x+4, y+4, color)
        :                                               : Plot(x+3, y+5, color)
      EndIf
      
    EndProcedure
    
    Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
      ; ProcedureReturn DrawArrow(x,y, Direction, Color)
      
      Protected I
      ;Size - 2
      
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
    
    Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
      If Grid 
        Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
        If Value>Max 
          Value=Max 
        EndIf
      EndIf
      
      ProcedureReturn Value
      ;   Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
      ;     ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_round_nearest) * Grid)))
    EndProcedure
    
    Procedure.s InvertCase(Text.s)
      Protected *C.CHARACTER = @Text
      
      While (*C\c)
        If (*C\c = Asc(LCase(Chr(*C\c))))
          *C\c = Asc(UCase(Chr(*C\c)))
        Else
          *C\c = Asc(LCase(Chr(*C\c)))
        EndIf
        
        *C + #__sOC ; SizeOf(CHARACTER)
      Wend
      
      ProcedureReturn Text
    EndProcedure
    
    Procedure   Draw_Selection(X, Y, SourceColor, TargetColor)
      Protected Color, Dot.b=4, line.b = 10, Length.b = (Line+Dot*2+1)
      Static Len.b
      
      If ((Len%Length)<line Or (Len%Length)=(line+Dot))
        If (Len>(Line+Dot)) : Len=0 : EndIf
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      Len+1
      ProcedureReturn Color
    EndProcedure
    
    Procedure   Draw_PlotX(X, Y, SourceColor, TargetColor)
      Protected Color
      
      If x%2
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    Procedure   Draw_PlotY(X, Y, SourceColor, TargetColor)
      Protected Color
      
      If y%2
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    ;-
    ;- ANCHORs
    Macro _set_cursor_(_this_, _cursor_)
      SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
    EndMacro
    
    Macro a_draw(_this_)
      If _this_\root\anchor
        DrawingMode(#PB_2DDrawing_Outlined)
        If _this_\root\anchor\id[1] : Box(_this_\root\anchor\id[1]\x, _this_\root\anchor\id[1]\y, _this_\root\anchor\id[1]\width, _this_\root\anchor\id[1]\height ,_this_\root\anchor\id[1]\color[_this_\root\anchor\id[1]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[2] : Box(_this_\root\anchor\id[2]\x, _this_\root\anchor\id[2]\y, _this_\root\anchor\id[2]\width, _this_\root\anchor\id[2]\height ,_this_\root\anchor\id[2]\color[_this_\root\anchor\id[2]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[3] : Box(_this_\root\anchor\id[3]\x, _this_\root\anchor\id[3]\y, _this_\root\anchor\id[3]\width, _this_\root\anchor\id[3]\height ,_this_\root\anchor\id[3]\color[_this_\root\anchor\id[3]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[4] : Box(_this_\root\anchor\id[4]\x, _this_\root\anchor\id[4]\y, _this_\root\anchor\id[4]\width, _this_\root\anchor\id[4]\height ,_this_\root\anchor\id[4]\color[_this_\root\anchor\id[4]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[5] : Box(_this_\root\anchor\id[5]\x, _this_\root\anchor\id[5]\y, _this_\root\anchor\id[5]\width, _this_\root\anchor\id[5]\height ,_this_\root\anchor\id[5]\color[_this_\root\anchor\id[5]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[6] : Box(_this_\root\anchor\id[6]\x, _this_\root\anchor\id[6]\y, _this_\root\anchor\id[6]\width, _this_\root\anchor\id[6]\height ,_this_\root\anchor\id[6]\color[_this_\root\anchor\id[6]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[7] : Box(_this_\root\anchor\id[7]\x, _this_\root\anchor\id[7]\y, _this_\root\anchor\id[7]\width, _this_\root\anchor\id[7]\height ,_this_\root\anchor\id[7]\color[_this_\root\anchor\id[7]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[8] : Box(_this_\root\anchor\id[8]\x, _this_\root\anchor\id[8]\y, _this_\root\anchor\id[8]\width, _this_\root\anchor\id[8]\height ,_this_\root\anchor\id[8]\color[_this_\root\anchor\id[8]\color\state]\frame) : EndIf
        ;If _this_\root\anchor\id[#__a_moved] : Box(_this_\root\anchor\id[#__a_moved]\x, _this_\root\anchor\id[#__a_moved]\y, _this_\root\anchor\id[#__a_moved]\width, _this_\root\anchor\id[#__a_moved]\height ,_this_\root\anchor\id[#__a_moved]\color[_this_\root\anchor\id[#__a_moved]\color\state]\frame) : EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        If _this_\root\anchor\id[10] : Box(_this_\root\anchor\id[10]\x, _this_\root\anchor\id[10]\y, _this_\root\anchor\id[10]\width, _this_\root\anchor\id[10]\height ,_this_\root\anchor\id[10]\color[_this_\root\anchor\id[10]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[11] : Box(_this_\root\anchor\id[11]\x, _this_\root\anchor\id[11]\y, _this_\root\anchor\id[11]\width, _this_\root\anchor\id[11]\height ,_this_\root\anchor\id[11]\color[_this_\root\anchor\id[11]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[12] : Box(_this_\root\anchor\id[12]\x, _this_\root\anchor\id[12]\y, _this_\root\anchor\id[12]\width, _this_\root\anchor\id[12]\height ,_this_\root\anchor\id[12]\color[_this_\root\anchor\id[12]\color\state]\frame) : EndIf
        If _this_\root\anchor\id[13] : Box(_this_\root\anchor\id[13]\x, _this_\root\anchor\id[13]\y, _this_\root\anchor\id[13]\width, _this_\root\anchor\id[13]\height ,_this_\root\anchor\id[13]\color[_this_\root\anchor\id[13]\color\state]\frame) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        If _this_\root\anchor\id[1] : Box(_this_\root\anchor\id[1]\x+1, _this_\root\anchor\id[1]\y+1, _this_\root\anchor\id[1]\width-2, _this_\root\anchor\id[1]\height-2 ,_this_\root\anchor\id[1]\color[_this_\root\anchor\id[1]\color\state]\back) : EndIf
        If _this_\root\anchor\id[2] : Box(_this_\root\anchor\id[2]\x+1, _this_\root\anchor\id[2]\y+1, _this_\root\anchor\id[2]\width-2, _this_\root\anchor\id[2]\height-2 ,_this_\root\anchor\id[2]\color[_this_\root\anchor\id[2]\color\state]\back) : EndIf
        If _this_\root\anchor\id[3] : Box(_this_\root\anchor\id[3]\x+1, _this_\root\anchor\id[3]\y+1, _this_\root\anchor\id[3]\width-2, _this_\root\anchor\id[3]\height-2 ,_this_\root\anchor\id[3]\color[_this_\root\anchor\id[3]\color\state]\back) : EndIf
        If _this_\root\anchor\id[4] : Box(_this_\root\anchor\id[4]\x+1, _this_\root\anchor\id[4]\y+1, _this_\root\anchor\id[4]\width-2, _this_\root\anchor\id[4]\height-2 ,_this_\root\anchor\id[4]\color[_this_\root\anchor\id[4]\color\state]\back) : EndIf
        If _this_\root\anchor\id[5] And Not _this_\container : Box(_this_\root\anchor\id[5]\x+1, _this_\root\anchor\id[5]\y+1, _this_\root\anchor\id[5]\width-2, _this_\root\anchor\id[5]\height-2 ,_this_\root\anchor\id[5]\color[_this_\root\anchor\id[5]\color\state]\back) : EndIf
        If _this_\root\anchor\id[6] : Box(_this_\root\anchor\id[6]\x+1, _this_\root\anchor\id[6]\y+1, _this_\root\anchor\id[6]\width-2, _this_\root\anchor\id[6]\height-2 ,_this_\root\anchor\id[6]\color[_this_\root\anchor\id[6]\color\state]\back) : EndIf
        If _this_\root\anchor\id[7] : Box(_this_\root\anchor\id[7]\x+1, _this_\root\anchor\id[7]\y+1, _this_\root\anchor\id[7]\width-2, _this_\root\anchor\id[7]\height-2 ,_this_\root\anchor\id[7]\color[_this_\root\anchor\id[7]\color\state]\back) : EndIf
        If _this_\root\anchor\id[8] : Box(_this_\root\anchor\id[8]\x+1, _this_\root\anchor\id[8]\y+1, _this_\root\anchor\id[8]\width-2, _this_\root\anchor\id[8]\height-2 ,_this_\root\anchor\id[8]\color[_this_\root\anchor\id[8]\color\state]\back) : EndIf
        
      EndIf
    EndMacro
    
    Macro a_resize(_this_)
      If _this_\root\anchor\id[1] ; left
        _this_\root\anchor\id[1]\x = _this_\x-_this_\root\anchor\pos
        _this_\root\anchor\id[1]\y = _this_\y+(_this_\height-_this_\root\anchor\id[1]\height)/2
      EndIf
      If _this_\root\anchor\id[2] ; top
        _this_\root\anchor\id[2]\x = _this_\x+(_this_\width-_this_\root\anchor\id[2]\width)/2
        _this_\root\anchor\id[2]\y = _this_\y-_this_\root\anchor\pos
      EndIf
      If  _this_\root\anchor\id[3] ; right
        _this_\root\anchor\id[3]\x = _this_\x+_this_\width-_this_\root\anchor\id[3]\width+_this_\root\anchor\pos
        _this_\root\anchor\id[3]\y = _this_\y+(_this_\height-_this_\root\anchor\id[3]\height)/2
      EndIf
      If _this_\root\anchor\id[4] ; bottom
        _this_\root\anchor\id[4]\x = _this_\x+(_this_\width-_this_\root\anchor\id[4]\width)/2
        _this_\root\anchor\id[4]\y = _this_\y+_this_\height-_this_\root\anchor\id[4]\height+_this_\root\anchor\pos
      EndIf
      
      If _this_\root\anchor\id[5] ; left&top
        _this_\root\anchor\id[5]\x = _this_\x-_this_\root\anchor\pos
        _this_\root\anchor\id[5]\y = _this_\y-_this_\root\anchor\pos
      EndIf
      If _this_\root\anchor\id[6] ; right&top
        _this_\root\anchor\id[6]\x = _this_\x+_this_\width-_this_\root\anchor\id[6]\width+_this_\root\anchor\pos
        _this_\root\anchor\id[6]\y = _this_\y-_this_\root\anchor\pos
      EndIf
      If _this_\root\anchor\id[7] ; right&bottom
        _this_\root\anchor\id[7]\x = _this_\x+_this_\width-_this_\root\anchor\id[7]\width+_this_\root\anchor\pos
        _this_\root\anchor\id[7]\y = _this_\y+_this_\height-_this_\root\anchor\id[7]\height+_this_\root\anchor\pos
      EndIf
      If _this_\root\anchor\id[8] ; left&bottom
        _this_\root\anchor\id[8]\x = _this_\x-_this_\root\anchor\pos
        _this_\root\anchor\id[8]\y = _this_\y+_this_\height-_this_\root\anchor\id[8]\height+_this_\root\anchor\pos
      EndIf
      
      If _this_\root\anchor\id[#__a_moved] 
        _this_\root\anchor\id[#__a_moved]\x = _this_\x
        _this_\root\anchor\id[#__a_moved]\y = _this_\y
        _this_\root\anchor\id[#__a_moved]\width = _this_\width
        _this_\root\anchor\id[#__a_moved]\height = _this_\height
      EndIf
      
      If _this_\root\anchor\id[10] And _this_\root\anchor\id[11] And _this_\root\anchor\id[12] And _this_\root\anchor\id[13]
        a_lines(_this_)
      EndIf
      
    EndMacro
    
    Procedure   a_lines(*this._s_widget=-1, distance=0)
      Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
      Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
      
      With *this
        If *this
          checked_x1 = *this\x
          checked_y1 = *this\y
          checked_x2 = checked_x1+*this\width
          checked_y2 = checked_y1+*this\height
          
          top_x1 = checked_x1 : top_x2 = checked_x2
          left_y1 = checked_y1 : left_y2 = checked_y2 
          right_y1 = checked_y1 : right_y2 = checked_y2
          bottom_x1 = checked_x1 : bottom_x2 = checked_x2
          
          If *this\parent And ListSize(GetChildrens(*this))
            PushListPosition(GetChildrens(*this))
            ForEach GetChildrens(*this)
              If Not GetChildrens(*this)\hide And GetChildrens(*this)\parent = *this\parent
                relative_x1 = GetChildrens(*this)\x
                relative_y1 = GetChildrens(*this)\y
                relative_x2 = relative_x1+GetChildrens(*this)\width
                relative_y2 = relative_y1+GetChildrens(*this)\height
                
                ;Left_line
                If checked_x1 = relative_x1
                  If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                  If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                  
                  ; *this\root\anchor\id[10]\color[0]\frame = $0000FF
                  *this\root\anchor\id[10]\hide = 0
                  *this\root\anchor\id[10]\x = checked_x1
                  *this\root\anchor\id[10]\y = left_y1
                  *this\root\anchor\id[10]\width = ls
                  *this\root\anchor\id[10]\height = left_y2-left_y1
                Else
                  ; *this\root\anchor\id[10]\color[0]\frame = $000000
                  *this\root\anchor\id[10]\hide = 1
                EndIf
                
                ;Right_line
                If checked_x2 = relative_x2
                  If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                  If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                  
                  *this\root\anchor\id[12]\hide = 0
                  *this\root\anchor\id[12]\x = checked_x2-ls
                  *this\root\anchor\id[12]\y = right_y1
                  *this\root\anchor\id[12]\width = ls
                  *this\root\anchor\id[12]\height = right_y2-right_y1
                Else
                  *this\root\anchor\id[12]\hide = 1
                EndIf
                
                ;Top_line
                If checked_y1 = relative_y1 
                  If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                  If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                  
                  *this\root\anchor\id[11]\hide = 0
                  *this\root\anchor\id[11]\x = top_x1
                  *this\root\anchor\id[11]\y = checked_y1
                  *this\root\anchor\id[11]\width = top_x2-top_x1
                  *this\root\anchor\id[11]\height = ls
                Else
                  *this\root\anchor\id[11]\hide = 1
                EndIf
                
                ;Bottom_line
                If checked_y2 = relative_y2 
                  If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                  If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                  
                  *this\root\anchor\id[13]\hide = 0
                  *this\root\anchor\id[13]\x = bottom_x1
                  *this\root\anchor\id[13]\y = checked_y2-ls
                  *this\root\anchor\id[13]\width = bottom_x2-bottom_x1
                  *this\root\anchor\id[13]\height = ls
                Else
                  *this\root\anchor\id[13]\hide = 1
                EndIf
              EndIf
            Next
            PopListPosition(GetChildrens(*this))
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i a_add(*this._s_widget, Size.l=6, Pos.l=-1)
      Structure DataBuffer
        cursor.i[#__anchors+1]
      EndStructure
      
      Protected i, *Cursor.DataBuffer = ?CursorsBuffer
      
      With *this
        \flag\transform = 1
        
        If Pos=-1
          Pos = Size-3
        EndIf
        
        If Not \root\anchor
          \root\anchor = AllocateStructure(structures::_s_anchor)
          \root\anchor\index = #__a_moved
          \root\anchor\pos = Pos
          \root\anchor\size = Size
          
          For i = 0 To #__anchors
            \root\anchor\id[i]\cursor = *Cursor\cursor[i]
            
            \root\anchor\id[i]\color[0]\frame = $000000
            \root\anchor\id[i]\color[1]\frame = $FF0000
            \root\anchor\id[i]\color[2]\frame = $0000FF
            
            \root\anchor\id[i]\color[0]\back = $FFFFFF
            \root\anchor\id[i]\color[1]\back = $FFFFFF
            \root\anchor\id[i]\color[2]\back = $FFFFFF
            
            \root\anchor\id[i]\width = \root\anchor\size
            \root\anchor\id[i]\height = \root\anchor\size
            
            If \container And i = 5
              \root\anchor\id[5]\width * 2
              \root\anchor\id[5]\height * 2
            EndIf
            
            If i=10 Or i=12
              \root\anchor\id[i]\color[0]\frame = $0000FF
              ;           \root\anchor\id[i]\color[1]\frame = $0000FF
              ;           \root\anchor\id[i]\color[2]\frame = $0000FF
            EndIf
            If i=11 Or i=13
              \root\anchor\id[i]\color[0]\frame = $FF0000
              ;           \root\anchor\id[i]\color[1]\frame = $FF0000
              ;           \root\anchor\id[i]\color[2]\frame = $FF0000
            EndIf
          Next i
          
        EndIf
      EndWith
      
      DataSection
        CursorsBuffer:
        Data.i #PB_Cursor_Default
        Data.i #PB_Cursor_LeftRight
        Data.i #PB_Cursor_UpDown
        Data.i #PB_Cursor_LeftRight
        Data.i #PB_Cursor_UpDown
        Data.i #PB_Cursor_LeftUpRightDown
        Data.i #PB_Cursor_LeftDownRightUp
        Data.i #PB_Cursor_LeftUpRightDown
        Data.i #PB_Cursor_LeftDownRightUp
        Data.i #PB_Cursor_Arrows
      EndDataSection
    EndProcedure
    
    Procedure.i a_get(*this._s_widget, index.i=-1)
      ProcedureReturn Bool(*this\root\anchor\id[(Bool(index.i=-1) * #__a_moved) + (Bool(index.i>0) * index)]) * *this
    EndProcedure
    
    Procedure.i a_set(*this._s_widget)
      Protected Result.i
      Static *LastPos
      
      With *this
        If Not (\parent And 
                (\parent\scroll And (*this = \parent\scroll\v Or *this = \parent\scroll\h)) Or 
                (\parent\splitter And (*this = \parent\splitter\first Or *this = \parent\splitter\second Or \bar\from = #__b_3)))
          
          If \root\anchor\widget <> *this
            ;         If \root\anchor\widget
            ;           If *LastPos
            ;             ; ?????????? ?? ?????
            ;             SetPosition(\root\anchor\widget, #PB_list_before, *LastPos)
            ;             *LastPos = 0
            ;           EndIf
            ;         EndIf
            ;         
            ;         *LastPos = GetPosition(*this, #PB_list_after)
            ;         If *LastPos
            ;           SetPosition(*this, #PB_list_last)
            ;         EndIf
            \root\anchor\widget = *this
            
            If \container
              \root\anchor\id[5]\width = \root\anchor\size * 2
              \root\anchor\id[5]\height = \root\anchor\size * 2
            Else
              \root\anchor\id[5]\width = \root\anchor\size
              \root\anchor\id[5]\height = \root\anchor\size
            EndIf
            
            a_resize(*this)
            Result = 1
          EndIf
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i a_remove(*this._s_widget)
      Protected Result.i
      
      With *this
        If \root\anchor
          Result = \root\anchor
          FreeStructure(\root\anchor)
          \root\anchor = 0
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   a_events(*this._s_widget, EventType.i, buttons.i, mouse_x.i, mouse_y.i)
      Protected result, i 
      
      With *this
        If \root\anchor 
          Post(eventtype, *this, *this\index[#__s_1])
          
          Select EventType 
              ;             Case #PB_EventType_StatusChange
              ;               ProcedureReturn 1
              
            Case #__Event_MouseMove
              If \root\anchor\id[\root\anchor\index]\color\state = #__s_2
                *this = \root\anchor\widget
                mouse_x-\root\anchor\delta\x
                mouse_y-\root\anchor\delta\y
                
                ;Protected.i Px,Py, Grid = \grid, IsGrid = Bool(Grid>1)
                Protected.i Px,Py, Grid = 5, IsGrid = Bool(Grid>1)
                
                If \parent
                  Px = \parent\x[#__c_2]
                  Py = \parent\y[#__c_2]
                EndIf
                
                Protected mx = Match(mouse_x-Px+\root\anchor\pos, Grid)
                Protected my = Match(mouse_y-Py+\root\anchor\pos, Grid)
                Protected mw = Match((\x+\width-IsGrid)-mouse_x-\root\anchor\pos, Grid)+IsGrid
                Protected mh = Match((\y+\height-IsGrid)-mouse_y-\root\anchor\pos, Grid)+IsGrid
                Protected mxw = Match(mouse_x-\x+\root\anchor\pos, Grid)+IsGrid
                Protected myh = Match(mouse_y-\y+\root\anchor\pos, Grid)+IsGrid
                
                Select \root\anchor\index
                  Case 1 : result = Resize(*this, mx, #PB_Ignore, mw, #PB_Ignore)
                  Case 2 : result = Resize(*this, #PB_Ignore, my, #PB_Ignore, mh)
                  Case 3 : result = Resize(*this, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
                  Case 4 : result = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
                    
                  Case 5 
                    If \container ; Form, Container, ScrollArea, Panel
                      result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                    Else
                      result = Resize(*this, mx, my, mw, mh)
                    EndIf
                    
                  Case 6 : result = Resize(*this, #PB_Ignore, my, mxw, mh)
                  Case 7 : result = Resize(*this, #PB_Ignore, #PB_Ignore, mxw, myh)
                  Case 8 : result = Resize(*this, mx, #PB_Ignore, mw, myh)
                    
                  Case #__a_moved 
                    If Not \container
                      If  Not \root\anchor\cursor 
                        _set_cursor_(*this, \root\anchor\id[\root\anchor\index]\cursor)
                        \root\anchor\cursor = 1
                      EndIf
                      
                      result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                    EndIf
                EndSelect
                
              ElseIf Not Buttons
                ; From point anchor
                For i = #__anchors To 0 Step - 1
                  If \root\anchor\id[i] And _from_point_(mouse_x, mouse_y, \root\anchor\id[i]) 
                    If i <> #__a_moved And Not \root\anchor\cursor
                      If \container And i = 5
                        _set_cursor_(*this, \root\anchor\id[#__a_moved]\cursor)
                      Else
                        _set_cursor_(*this, \root\anchor\id[i]\cursor)
                      EndIf
                      \root\anchor\cursor = 1
                    EndIf
                    \root\anchor\id[i]\color\state = 1
                    \root\anchor\index = i
                    Break
                  Else
                    \root\anchor\id[i]\color\state = 0
                    If \root\anchor\cursor
                      _set_cursor_(*this, \root\anchor\id[0]\cursor)
                      \root\anchor\cursor = 0
                    EndIf
                  EndIf
                Next
              EndIf
              
            Case #__Event_LeftButtonDown  
              If \root\flag\transform
                If a_Set(*this)
                EndIf
                \flag\transform = 1
              EndIf
              
              If \flag\transform
                If _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                  \root\anchor\delta\x = mouse_x-\root\anchor\id[\root\anchor\index]\x
                  \root\anchor\delta\y = mouse_y-\root\anchor\id[\root\anchor\index]\y
                  \root\anchor\id[\root\anchor\index]\color\state = #__s_2
                EndIf
                result = 1
              EndIf
              
            Case #__Event_LeftButtonUp
              If \flag\transform
                If \root\anchor\cursor And Not _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                  _set_cursor_(*this, \root\anchor\id[0]\cursor)
                  \root\anchor\cursor = 0
                EndIf
                
                \root\anchor\id[\root\anchor\index]\color\state = 0
                \root\anchor\index = 0
                result = 1
              EndIf
              
          EndSelect
        EndIf
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    
    
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
    
    Macro _button_draw_(_vertical_, _x_,_y_,_width_,_height_, _arrow_type_, _arrow_size_, _arrow_direction_, _color_fore_,_color_back_,_color_frame_, _color_arrow_, _alpha_, _round_)
      ; Draw buttons   
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      _box_gradient_(_vertical_,_x_,_y_,_width_,_height_, _color_fore_,_color_back_, _round_, _alpha_)
      
      ; Draw buttons frame
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_,_y_,_width_,_height_,_round_,_round_,_color_frame_&$FFFFFF|_alpha_<<24)
      
      ; Draw arrows
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(_x_+(_width_-_arrow_size_)/2,_y_+(_height_-_arrow_size_)/2, _arrow_size_, _arrow_direction_, _color_arrow_&$FFFFFF|_alpha_<<24, _arrow_type_)
      ResetGradientColors()
    EndMacro
    
    Macro _set_item_image_(_this_, _item_, _image_)
      _item_\image\index = IsImage(_image_)
      
      If _item_\image\index
        If _this_\flag\iconsize
          _item_\image\width = _this_\flag\iconsize
          _item_\image\height = _this_\flag\iconsize
          ResizeImage(_image_, _item_\image\width, _item_\image\height)
        Else
          _item_\image\width = ImageWidth(_image_)
          _item_\image\height = ImageHeight(_image_)
        EndIf  
        
        _item_\image\index[1] = _image_ 
        _item_\image\index[2] = ImageID(_image_)
        
        _this_\row\sublevel = _this_\image\padding\left + _item_\image\width
      Else
        _item_\image\index[1] =- 1
        _item_\image\index[2] = 0
        _item_\image\width = 0
        _item_\image\height = 0
      EndIf
    EndMacro
    
    Macro _repaint_(_this_)
      If _this_\root And Not _this_\repaint : _this_\repaint = 1
        PostEvent(#PB_Event_Gadget, _this_\root\canvas\window, _this_\root\canvas\gadget, #__Event_Repaint);, _this_)
      EndIf
    EndMacro 
    
    Macro _repaint_items_(_this_)
      If _this_\count\items = 0 Or 
         (Not _this_\hide And _this_\row\count And 
          (_this_\count\items % _this_\row\count) = 0)
        
        _this_\change = 1
        _this_\row\count = _this_\count\items
        _repaint_(_this_)
      EndIf  
    EndMacro
    
    
    ;- TEXTs
    Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
      ;If _this_\text\vertical
      If _this_\text\rotate = 90
        ;         If _this_\y<>_y_
        ;           _this_\text\x = _x_ + _this_\y
        ;         Else
        _this_\text\x = _x_ + (_width_-_this_\text\height)/2
        ;         EndIf
        
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
        ;         If _this_\x<>_x_
        ;           _this_\text\y = _y_ + _this_\y
        ;         Else
        _this_\text\y = _y_ + (_height_-_this_\text\height)/2
        ;         EndIf
        
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
          If (_this_\text\invert And Not _this_\vertical) Or
             (Not _this_\text\invert And _this_\vertical)
            _this_\text\align\right = constants::_check_(_flag_, #__text_left)
            _this_\text\align\left = constants::_check_(_flag_, #__text_right)
            
          Else
            _this_\text\align\left = constants::_check_(_flag_, #__text_left)
            _this_\text\align\right = constants::_check_(_flag_, #__text_right)
          EndIf
          
          If (_this_\text\invert And _this_\vertical) Or
             (_this_\text\invert And Not _this_\vertical)
            _this_\text\align\bottom = constants::_check_(_flag_, #__text_top)
            _this_\text\align\top = constants::_check_(_flag_, #__text_bottom)
          Else
            _this_\text\align\top = constants::_check_(_flag_, #__text_top)
            _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
          EndIf
          
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
          _this_\text\Rotate = Bool(_this_\vertical)*90 + Bool(Not _this_\vertical)*180
        Else
          _this_\text\Rotate = Bool(_this_\vertical)*270
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
    
    Macro _set_alignment_flag_(_this_, _parent_, _flag_)
      If _flag_ & #__flag_autosize = #__flag_autosize
        _this_\align = AllocateStructure(_s_align)
        _this_\align\autoSize = 1
        _this_\align\left = 1
        _this_\align\top = 1
        _this_\align\right = 1
        _this_\align\bottom = 1
        
        If _parent_
          _parent_\color\back =- 1
        EndIf
      EndIf
    EndMacro
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;- BARs
    ;{
    Declare.b Tab_Draw(*this)
    Declare.b Bar_Update(*this)
    Declare.b Bar_SetState(*this, state.f)
    
    Macro Area_Draw(_this_)
      If _this_\scroll
        If Not _this_\scroll\v\hide And _this_\scroll\v\width And _this_\scroll\v\width[#__c_4] > 0 And _this_\scroll\v\height[#__c_4] > 0
          Bar_Draw(_this_\scroll\v)
        EndIf
        If Not _this_\scroll\h\hide And _this_\scroll\h\height And _this_\scroll\h\width[#__c_4] > 0 And _this_\scroll\h\height[#__c_4] > 0
          Bar_Draw(_this_\scroll\h)
        EndIf
        
;         If _this_\scroll\v And _this_\scroll\h
;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
;           ; Scroll area coordinate
;           Box(_this_\scroll\h\x + _this_\scroll\x, _this_\scroll\v\y + _this_\scroll\y, _this_\scroll\width, _this_\scroll\height, $FF0000FF)
;           
;           ; Debug ""+ _this_\scroll\x +" "+ _this_\scroll\y +" "+ _this_\scroll\width +" "+ _this_\scroll\height
;           Box(_this_\scroll\h\x - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FFFF0000)
;           
;           ; page coordinate
;           Box(_this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
;         EndIf
      EndIf
    EndMacro
    
    Macro Area(_parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True)
      _parent_\scroll\v = Create(#__Type_ScrollBar, _parent_, 0,0,#__scroll_buttonsize,0,  0,_area_height_, _height_, #__scroll_buttonsize, #__bar_child|#__bar_vertical, 7, _scroll_step_)
      _parent_\scroll\h = Create(#__Type_ScrollBar, _parent_, 0,0,0,#__scroll_buttonsize,  0,_area_width_, _width_, Bool(_mode_)*#__scroll_buttonsize, #__bar_child, 7, _scroll_step_)
    EndMacro
    
    
    ;-
    Procedure.i Tab_SetState(*this._s_widget, State.l)
      Protected Result.b
      
      If State < 0 
        State = 0 
      EndIf
      
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If *this\index[#__s_2] <> State 
        *this\index[#__s_2] = State
        
        If *this = *this\parent\_tab 
          *this\parent\index[#__s_2] = State
          
          PushListPosition(GetChildrens(*this))
          ForEach GetChildrens(*this)
            If Child( GetChildrens(*this), *this\parent)  
              GetChildrens(*this)\hide = Bool(GetChildrens(*this)\hide[1] Or GetChildrens(*this)\parent\hide Or 
                                              GetChildrens(*this)\_parent_item <> GetChildrens(*this)\parent\index[#__s_2])
            EndIf
          Next
          PopListPosition(GetChildrens(*this))
          
          Post(#PB_EventType_Change, *this\parent, State)
        Else
          Post(#PB_EventType_Change, *this, State)
        EndIf
        
        *this\bar\state[1] = State + 1
        Result = #True
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   Tab_AddItem(*this._s_widget, Item.i, Text.s, Image.i=-1, sublevel.i=0)
      Protected result
      
      With *this
        ; 
        *this\bar\change = #True
        
        If (Item =- 1 Or Item > ListSize(\bar\_s()) - 1)
          LastElement(\bar\_s())
          AddElement(\bar\_s()) 
          Item = ListIndex(\bar\_s())
        Else
          If SelectElement(\bar\_s(), Item)
            If Item =< *this\index[#__s_2]
              *this\index[#__s_2]  + 1
            EndIf
            
            If *this\parent\_tab = *this
              ; \parent\type = #PB_GadgetType_Panel
              ; PushListPosition(GetChildrens(*this))
              ForEach GetChildrens(*this)
                If Child( GetChildrens(*this), *this\parent)
                  If GetChildrens(*this)\parent = *this\parent And 
                     GetChildrens(*this)\_parent_item = Item
                    GetChildrens(*this)\_parent_item + 1
                  EndIf
                  
                  GetChildrens(*this)\hide = Bool( GetChildrens(*this)\hide[1] Or GetChildrens(*this)\parent\hide Or
                                                   GetChildrens(*this)\_parent_item <> GetChildrens(*this)\parent\index[#__s_2])
                EndIf
              Next
              ; PopListPosition(GetChildrens(*this))
            EndIf
            
            InsertElement(\bar\_s())
            
            PushListPosition(\bar\_s())
            While NextElement(\bar\_s())
              *this\bar\_s()\index = ListIndex(*this\bar\_s())
            Wend
            PopListPosition(\bar\_s())
          EndIf
        EndIf
        
        *this\bar\_s() = AllocateStructure(_s_tabs)
        *this\bar\_s()\color = _get_colors_()
        *this\bar\_s()\index = Item
        *this\bar\_s()\text\string = Text.s
        *this\bar\_s()\height = \height - 1
        
        ; last opened item of the parent
        If *this\parent\_tab = *this ; type = #PB_GadgetType_Panel
          *this\parent\_item = *this\bar\_s()\index
          *this\parent\count\items + 1 
        EndIf
        
        *this\_item = \bar\_s()\index
        *this\count\items + 1 
        
        ; _set_item_image_(*this, \bar\_s(), Image)
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i Tab_RemoveItem(*this._s_widget, Item.l)
      If SelectElement(*this\bar\_s(), item)
        If *this\bar\_s()\index = *this\index[#__s_2]
          *this\index[#__s_2]  = item - 1
        EndIf
        
        DeleteElement(*this\bar\_s(), 1)
        *this\count\items - 1
        
        If *this\parent\_tab = *this
          *this\parent\count\items - 1
          Post(#PB_EventType_CloseItem, *this\parent, Item)
        Else
          Post(#PB_EventType_CloseItem, *this, Item)
        EndIf
        *this\bar\change = 1
      EndIf
    EndProcedure
    
    Procedure   Tab_ClearItems(*this._s_widget) ; Ok
      If *this\count\items <> 0
        *this\count\items = 0
        ClearList(*this\bar\_s())
        
        If *this\parent\_tab = *this
          *this\parent\count\items = 0
          Post(#PB_EventType_CloseItem, *this\parent, #PB_All)
        Else
          Post(#PB_EventType_CloseItem, *this, #PB_All)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s Tab_GetItemText(*this._s_widget, Item.l, Column.l=0)
      Protected Result.s
      
      If _is_item_(*this, Item) And 
         SelectElement(*this\bar\_s(), Item) 
        Result = *this\bar\_s()\text\string
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.b Tab_Draw(*this._s_widget)
      With *this
        
        If Not \hide And \color\alpha
          If \color\back <> - 1
            ; Draw scroll bar background
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ; tab bar item update
          If *this\bar\change
            If *this\bar\vertical
              *this\text\y = 6
            Else
              *this\text\x = 6
            EndIf
            
            *this\bar\max = 0
            *this\text\height = TextHeight("A")
            *this\text\width = *this\width;[2]
            
            ForEach \bar\_s()
              *this\bar\_s()\text\width = TextWidth(*this\bar\_s()\text\string)
              *this\bar\_s()\text\height = *this\text\height
              
              If *this\bar\vertical
                ;                If *this\parent\__width < *this\bar\_s()\text\width + 12
                ;                  *this\parent\__width = *this\bar\_s()\text\width + 12
                ;                EndIf
                
                
                *this\bar\_s()\x = 2
                *this\bar\_s()\y = *this\bar\max
                *this\bar\_s()\width = *this\bar\button[#__b_3]\width-3
                
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x + (*this\bar\_s()\width - *this\bar\_s()\text\width)/2
                *this\bar\_s()\height = *this\text\y*2 + *this\bar\_s()\text\height
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\state[1] - 1
                  *this\bar\page\pos = *this\bar\_s()\y-((*this\height[#__c_2]-*this\bar\button[2]\len)-*this\bar\_s()\height) 
                EndIf
                
                *this\bar\max + *this\bar\_s()\height + Bool(*this\bar\_s()\index <> *this\count\items - 1) ;+ Bool(*this\bar\_s()\index = *this\count\items - 1) 
              Else
                *this\bar\_s()\y = 2
                *this\bar\_s()\x = *this\bar\max
                *this\bar\_s()\height = *this\bar\button[#__b_3]\height-3
                
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y + (*this\bar\_s()\height - *this\bar\_s()\text\height)/2
                *this\bar\_s()\width = *this\text\x*2 + *this\bar\_s()\text\width
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\state[1] - 1
                  *this\bar\page\pos = *this\bar\_s()\x - ((*this\width[#__c_2]-*this\bar\button[2]\len)-*this\bar\_s()\width)
                EndIf
                
                *this\bar\max + *this\bar\_s()\width + Bool(*this\bar\_s()\index <> *this\count\items - 1) ;+ Bool(*this\bar\_s()\index = *this\count\items - 1) 
              EndIf
            Next
            
            ; then set tab state
            If *this\bar\state[1]
              If *this\bar\page\pos < *this\bar\min Or 
                 *this\bar\area\len > *this\bar\max
                *this\bar\page\pos = 0
              EndIf
              
              If *this\bar\page\end And 
                 *this\bar\page\pos > *this\bar\page\end
                *this\bar\page\pos = *this\bar\page\end
              EndIf
              
              *this\bar\state[1] = 0
            EndIf
            
            Debug " tab max - "+*this\bar\max +" "+ *this\width[#__c_2] +" "+ *this\bar\page\pos +" "+ *this\bar\page\end
            
            Bar_Update(*this)
            *this\bar\change = 0
          EndIf
          
          
          
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          
          Protected State_3, Color_frame
          
          ForEach \bar\_s()
            If \index[#__s_1] = \bar\_s()\index
              State_3 = Bool(\index[#__s_1] = \bar\_s()\index); +Bool( \index[#__s_1] = \bar\_s()\index And \bar\state = #__b_3)
            Else
              State_3 = 0
            EndIf
            
            If \index[#__s_2] = \bar\_s()\index
              State_3 = 2
            EndIf
            
            ;State_3 = \bar\_s()\color\state
            
            If *this\bar\vertical
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \y[#__c_2]+\bar\_s()\y+\bar\_s()\height > \y[#__c_2] ); And \x[#__c_2]+\bar\_s()\x < \x[#__c_2]+\width[#__c_2])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,x+\bar\_s()\x-Bool(\index[#__s_2]= \bar\_s()\index),y+\bar\_s()\y,\bar\_s()\width+Bool(\index[#__s_2]=\bar\_s()\index)*2,\bar\_s()\height,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x+\bar\_s()\x-Bool(\index[#__s_2]=\bar\_s()\index)*2, y+\bar\_s()\y,\bar\_s()\width+Bool(\index[#__s_2]=\bar\_s()\index)*4,\bar\_s()\height,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x+\bar\_s()\x+\bar\_s()\width + 1, y+\bar\_s()\y + 1,1,\bar\_s()\height-2, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And \bar\state = #__b_3)
                  RoundBox(x+\bar\_s()\x,y+\bar\_s()\y+Bool(\index[#__s_2]=\bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height-Bool(\index[#__s_2]=\bar\_s()\index)*4,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x+\bar\_s()\text\x, y+\bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
              EndIf
              
            Else
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \x[#__c_2]+\bar\_s()\x+\bar\_s()\width > \x[#__c_2] );And \x[#__c_2]+\bar\_s()\x < \x[#__c_2]+\width[#__c_2])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,x+\bar\_s()\x,y+\bar\_s()\y-Bool(\index[#__s_2]= \bar\_s()\index),\bar\_s()\width,\bar\_s()\height+Bool(\index[#__s_2]= \bar\_s()\index)*2,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x+\bar\_s()\x, y+\bar\_s()\y-Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height+Bool(\index[#__s_2] = \bar\_s()\index)*4,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x+\bar\_s()\x+1, y+\bar\_s()\y+\bar\_s()\height + 1,\bar\_s()\width-2,1, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And \bar\state = #__b_3)
                  RoundBox(x+\bar\_s()\x+Bool(\index[#__s_2]=\bar\_s()\index)*2,y+\bar\_s()\y,\bar\_s()\width-Bool(\index[#__s_2]=\bar\_s()\index)*4,\bar\_s()\height,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x+\bar\_s()\text\x, y+\bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
              EndIf
            EndIf
          Next
          
          
          Protected fabe_x, fabe_out, button_size, Size = 40, color = \parent\color\fore[\parent\color\state]
          If Not color
            color = \parent\color\back[\parent\color\state]
          EndIf
          
          DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
          ResetGradientColors()
          GradientColor(0.0, Color&$FFFFFF)
          GradientColor(0.5, Color&$FFFFFF|$A0<<24)
          GradientColor(1.0, Color&$FFFFFF|245<<24)
          
          If *this\bar\vertical
            
            ;             ; to left
            ;             If (\bar\button[#__b_1]\y < \bar\button[#__b_3]\y)
            If \bar\button[#__b_2]\y < \bar\button[#__b_3]\y
              button_size = \bar\button[#__b_1]\len+5
            Else
              button_size = \bar\button[#__b_2]\len/2+5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \y[#__c_0]+(size-size/5)
              LinearGradient(\x+\bs, fabe_x, \x+\bs, fabe_x-fabe_out)
              RoundBox(\x+\bs, fabe_x, \width-\bs, -Size, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\y > \bar\button[#__b_3]\y
            If \bar\button[#__b_1]\y > \bar\button[#__b_3]\y
              button_size = \bar\button[#__b_1]\len+5
            Else
              button_size = \bar\button[#__b_1]\len/2+5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x= \y[#__c_0]+\height[#__c_0]-(size-size/5)
              LinearGradient(\x+\bs, fabe_x, \x+\bs, fabe_x+fabe_out)
              RoundBox(\x+\bs, fabe_x, \width-\bs ,Size, 10,10)
            EndIf
          Else
            ;             ; to left
            ;             If (\bar\button[#__b_1]\x < \bar\button[#__b_3]\x)
            If \bar\button[#__b_2]\x < \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len+5
            Else
              button_size = \bar\button[#__b_2]\len/2+5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \x[#__c_0]+(size-size/5)
              LinearGradient(fabe_x, \y+\bs, fabe_x-fabe_out, \y+\bs)
              RoundBox(fabe_x, \y+\bs, -Size, \height-\bs, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\x > \bar\button[#__b_3]\x
            If \bar\button[#__b_1]\x > \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len+5
            Else
              button_size = \bar\button[#__b_1]\len/2+5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x= \x[#__c_0]+\width[#__c_0]-(size-size/5)
              LinearGradient(fabe_x, \y+\bs, fabe_x+fabe_out, \y+\bs)
              RoundBox(fabe_x, \y+\bs, Size, \height-\bs ,10,10)
            EndIf
          EndIf
          
          ResetGradientColors()
          
          
          If Not \bar\button[#__b_1]\hide And (\bar\vertical And \bar\button[#__b_1]\height) Or (Not \bar\vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
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
                    \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
            EndIf
          EndIf
          
          If Not \bar\button[#__b_2]\hide And (\bar\vertical And \bar\button[#__b_2]\height) Or (Not \bar\vertical And \bar\button[#__b_2]\width)
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
                    \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
            EndIf
          EndIf
          
          
        EndIf
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_1]-1,\y[#__c_2]+\height[#__c_2],\width[#__c_1]+2,1, \color\frame[Bool(\index[#__s_2]<>-1)*2 ])
        ;         
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4], $FF0000FF)
        ;         ;         ;Box(\x[#__c_0],\y[#__c_0],\width[#__c_0],\height[#__c_0], $FF00F0F0)
        ;         ;         Box(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1], $FF00F0F0)
        ;         Box(\x[#__c_2],\y[#__c_2],\width[#__c_2],\height[#__c_2], $FF00FF00)
        
      EndWith 
    EndProcedure
    
    ;-
    Procedure.b Scroll_Draw(*this._s_widget)
      With *this
        
        ;         DrawImage(ImageID(UpImage),\bar\button[#__b_1]\x,\bar\button[#__b_1]\y)
        ;         DrawImage(ImageID(DownImage),\bar\button[#__b_2]\x,\bar\button[#__b_2]\y)
        ;         ProcedureReturn 
        
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
    
    Procedure.i Spin_Draw(*this._s_widget) 
      Scroll_Draw(*this)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\bar\button[#__b_1]\x-2,*this\y[#__c_1],*this\x[#__c_2]+*this\width[#__c_3] - *this\bar\button[#__b_1]\x+3,*this\height[#__c_1], *this\color\frame[*this\color\state])
      Box(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\color\frame[*this\color\state])
      
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0]) ; *this\color\state])
      EndIf
    EndProcedure
    
    Procedure.b Track_Draw(*this._s_widget)
      ;       *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      ;        *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      ;       *this\bar\button[#__b_3]\color\state = #__s_2
      
      Scroll_Draw(*this)
      
      With *this
        If \type = #PB_GadgetType_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \bar\vertical
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\percent > 1
                For i=\bar\min To \bar\page\end
                  Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-1, 
                       (\bar\area\pos + _thumb_ + (i-\bar\min) * \bar\percent),3, 1,\bar\button[#__b_1]\color\frame)
                Next
              Else
                Box(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-1,\bar\area\pos + _thumb_, 3, *this\bar\area\len - *this\bar\thumb\len+1, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3),\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3),\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\percent > 1
                For i=0 To \bar\page\end-\bar\min
                  Line((\bar\area\pos + _thumb_ + i * \bar\percent), 
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
    
    Procedure.b Progress_Draw(*this._s_widget)
      *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      
      Scroll_Draw(*this)
      
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
    
    Procedure.b Splitter_Draw(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Outlined);|#PB_2DDrawing_AlphaBlend)
        
        
        If \bar\mode 
          If \bar\vertical ; horisontal
            Box(\x, \bar\thumb\pos,\width,\bar\thumb\len,$FFFFFFFF)
          Else
            Box(\bar\thumb\pos,\y,\bar\thumb\len, \height,$FFFFFFFF)
          EndIf
          
          If \bar\vertical ; horisontal
            Box(\x+1, \bar\thumb\pos+1,\width-2,\bar\thumb\len-2,\bar\button[#__b_3]\Color\Frame[#__s_2])
          Else
            Box(\bar\thumb\pos+1,\y+1,\bar\thumb\len-2, \height-2,\bar\button[#__b_3]\Color\Frame[#__s_2])
          EndIf
          
          If Not \splitter\g_first And (Not \splitter\first Or (\splitter\first And Not \splitter\first\splitter))
            Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not \splitter\second Or (\splitter\second And Not \splitter\second\splitter))
            Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          EndIf
          
          ;           If \bar\vertical ; horisontal
          ;             Box(\x, \bar\thumb\pos+\bar\thumb\len/2,\width,1,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ;           Else
          ;             Box(\bar\thumb\pos+\bar\thumb\len/2,\y,1, \height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ;           EndIf
          ;           
          ;           If Not \splitter\g_first And (Not \splitter\first Or (\splitter\first And Not \splitter\first\splitter))
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, \bar\button[#__b_1]\width, 1, \bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ; ;             Line(\bar\button[#__b_1]\x+\bar\button[#__b_1]\width-1, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y+\bar\button[#__b_1]\height-1, \bar\button[#__b_1]\width, 1, $FFFFFFFF)
          ; ;             ; Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          ;              Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,$FFFFFFFF)
          ;           EndIf
          ;           If Not \splitter\g_second And (Not \splitter\second Or (\splitter\second And Not \splitter\second\splitter))
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, \bar\button[#__b_2]\width, 1, $FFFFFFFF)
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          ; ;             Line(\bar\button[#__b_2]\x+\bar\button[#__b_2]\width-1, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y+\bar\button[#__b_2]\height-1, \bar\button[#__b_2]\width, 1, \bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          ; ;           ;  Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          ;             Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,$FFFFFFFF)
          ;           EndIf
          ;           
          ;           ;Box(\x, \y,\width,\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
        Else
          If Not \splitter\g_first And (Not \splitter\first Or (\splitter\first And Not \splitter\first\splitter))
            Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not \splitter\second Or (\splitter\second And Not \splitter\second\splitter))
            Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          EndIf
          
          If \bar\vertical ; horisontal
            If \bar\button[#__b_3]\width > 35
              Circle(\bar\button[#__b_3]\x[#__c_1]-(\bar\button[#__b_3]\round*2+2)*2-2, \bar\button[#__b_3]\y[#__c_1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_1]+(\bar\button[#__b_3]\round*2+2)*2+2, \bar\button[#__b_3]\y[#__c_1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\width > 20
              Circle(\bar\button[#__b_3]\x[#__c_1]-(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\y[#__c_1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_1]+(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\y[#__c_1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
          Else
            If \bar\button[#__b_3]\Height > 35
              Circle(\bar\button[#__b_3]\x[#__c_1],\bar\button[#__b_3]\y[#__c_1]-(\bar\button[#__b_3]\round*2+2)*2-2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_1],\bar\button[#__b_3]\y[#__c_1]+(\bar\button[#__b_3]\round*2+2)*2+2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\Height > 20
              Circle(\bar\button[#__b_3]\x[#__c_1],\bar\button[#__b_3]\y[#__c_1]-(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_1],\bar\button[#__b_3]\y[#__c_1]+(\bar\button[#__b_3]\round*2+2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
            EndIf
          EndIf
          
          Circle(\bar\button[#__b_3]\x[#__c_1], \bar\button[#__b_3]\y[#__c_1],\bar\button[#__b_3]\round,\bar\button[#__b_3]\Color\Frame[#__s_2])
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_Draw(*this._s_widget)
      With *this
        If \text\string  And (*this\type = #PB_GadgetType_Spin Or
                              *this\type = #PB_GadgetType_ProgressBar)
          
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
            
            _text_change_(*this, *this\x[#__c_2], *this\y[#__c_2], *this\width[#__c_2], *this\height[#__c_2])
          EndIf
        EndIf
        
        Select \type
          Case #__Type_Spin           : Spin_Draw(*this)
          Case #__Type_TabBar         : Tab_Draw(*this)
          Case #__Type_TrackBar       : Track_Draw(*this)
          Case #__Type_ScrollBar      : Scroll_Draw(*this)
          Case #__Type_ProgressBar    : Progress_Draw(*this)
          Case #__Type_Splitter       : Splitter_Draw(*this)
        EndSelect
        
        ;            DrawingMode(#PB_2DDrawing_Outlined)
        ;            Box(\x[#__c_2],\y[#__c_2],\width[#__c_2],\height[#__c_2], $FF00FF00)
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        
        If *this\bar\change <> 0
          *this\bar\change = 0
        EndIf  
      EndWith
    EndProcedure
    
    ;-
    Procedure.b Bar_Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      If Not *this\bar\thumb\change And Bool(*this\resize & #__resize_change)
        If *this\type = #PB_GadgetType_ScrollBar 
          If *this\bar\max 
            If *this\bar\button[#__b_1]\len =- 1 And *this\bar\button[#__b_2]\len =- 1
              If *this\bar\vertical And *this\width[#__c_2] > 7 And *this\width[#__c_2] < 21
                *this\bar\button[#__b_1]\len = *this\width[#__c_2] - 1
                *this\bar\button[#__b_2]\len = *this\width[#__c_2] - 1
                
              ElseIf Not *this\bar\vertical And *this\height[#__c_2] > 7 And *this\height[#__c_2] < 21
                *this\bar\button[#__b_1]\len = *this\height[#__c_2] - 1
                *this\bar\button[#__b_2]\len = *this\height[#__c_2] - 1
                
              Else
                *this\bar\button[#__b_1]\len = *this\bar\button[#__b_3]\len
                *this\bar\button[#__b_2]\len = *this\bar\button[#__b_3]\len
              EndIf
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
        
        
        If *this\type = #PB_GadgetType_TabBar
          If *this\bar\vertical
            *this\bar\area\pos = *this\y + *this\bs
            *this\bar\area\len = *this\height - *this\bs*2
          Else
            *this\bar\area\pos = *this\x + *this\bs 
            *this\bar\area\len = *this\width - *this\bs*2
          EndIf
          
        Else
          If *this\bar\vertical
            *this\bar\area\pos = *this\y + *this\bs + *this\bar\button[#__b_1]\len
            *this\bar\area\len = *this\height - *this\bs*2 - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
          Else
            *this\bar\area\pos = *this\x + *this\bs + *this\bar\button[#__b_1]\len
            *this\bar\area\len = *this\width - *this\bs*2 - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
          EndIf
        EndIf
        
        If *this\bar\area\len < *this\bar\button[#__b_3]\len 
          *this\bar\area\len = *this\bar\button[#__b_3]\len 
        EndIf
        
        If *this\type <> #PB_GadgetType_TabBar
          ; if SetState(height-value or width-value)
          If *this\bar\button[#__b_3]\fixed < 0 
            Debug  "if SetState(height-value or width-value)"
            *this\bar\page\pos = *this\bar\area\len + *this\bar\button[#__b_3]\fixed
            *this\bar\button[#__b_3]\fixed = 0
          EndIf
        EndIf
        
        If *this\type = #PB_GadgetType_Splitter 
          ; one (set max)
          If Not *this\bar\max And *this\width And *this\height 
            *this\bar\thumb\len = *this\bar\button[#__b_3]\len
            *this\bar\max = (*this\bar\area\len-*this\bar\thumb\len)
            
            If Not *this\bar\page\pos 
              *this\bar\page\pos = *this\bar\max/2 
            EndIf
            
            ;if splitter fixed set splitter pos to center
            If *this\bar\fixed = #__b_1
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
            Else
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\max-*this\bar\page\pos
            EndIf
          EndIf
        EndIf
        
        ; get page end
        If *this\type = #PB_GadgetType_TabBar
          *this\bar\page\end = *this\bar\max - *this\bar\area\len
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
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\area\len)) 
          Else
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
          EndIf 
          
          If *this\bar\fixed 
            If *this\bar\percent < 1.0
              *this\bar\percent = 1.0
            EndIf
          EndIf
        Else
          *this\bar\percent = 1.0
        EndIf
      EndIf
      
      
      If *this\type = #PB_GadgetType_Splitter And (*this\bar\area\len - *this\bar\thumb\len) > 0
        ;               If Not *this\bar\thumb\change And *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 Debug "  - "+*this\bar\max +" "+ *this\bar\page\pos +" "+ *this\bar\area\len +" "+ *this\bar\thumb\pos +" "+ Bool(*this\resize & #__resize_change)
        ;                 *this\bar\page\pos = (*this\bar\area\len - *this\bar\thumb\len)/2
        ;               EndIf
        
        ;               If *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
        ;               EndIf
        
        ;              If *this\bar\max <> (*this\bar\area\len - *this\bar\thumb\len)
        ;                *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max-*this\bar\min) - *this\bar\page\len)) 
        ;                
        ;                 ; If Not *this\bar\thumb\change ;And Not *this\bar\page\pos
        ;                   *this\bar\page\pos = (*this\bar\max)/2
        ;                 ;EndIf
        ;               EndIf
        
      EndIf
      
      If Not *this\bar\area\len < 0
        ; thumb pos
        If *this\bar\fixed And Not *this\bar\thumb\change
          ; поведение при изменении размера 
          ; чтобы вернуть fix сплиттер на свое место
          Protected fixed.l
          ; Debug ""+*this+" "+*this\bar\fixed
          
          If *this\bar\button[*this\bar\fixed]\fixed < 0
            *this\bar\button[*this\bar\fixed]\fixed = 0
          EndIf
          
          If *this\bar\button[*this\bar\fixed]\fixed > *this\bar\area\len - *this\bar\thumb\len
            fixed =  (*this\bar\area\len - *this\bar\thumb\len)
          Else
            fixed = *this\bar\button[*this\bar\fixed]\fixed
          EndIf
          
          If fixed < 0 
            fixed = 0 
          EndIf
          
          If *this\bar\fixed = #__b_1
            *this\bar\thumb\pos = *this\bar\area\pos + fixed 
          Else
            *this\bar\thumb\pos = *this\bar\area\end - fixed 
          EndIf
          
          ; чтобы сделать паведение
          ; стандартное как в OS мне не нравится
          ;; *this\bar\button[*this\bar\fixed]\fixed = fixed
          
        Else
          ; for the scrollarea childrens
          If *this\bar\page\end And *this\bar\page\pos > *this\bar\page\end ; And *this\parent And *this\parent\scroll And *this\parent\scroll\v And *this\parent\scroll\h
            *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
            *this\bar\page\pos = *this\bar\page\end
          EndIf
          
          _scroll_pos_ = _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted)
          *this\bar\thumb\pos = _bar_thumb_pos_(*this\bar, _scroll_pos_)
        EndIf
        
        If *this\type = #PB_GadgetType_ScrollBar
          ; _in_start_
          If *this\bar\button[#__b_1]\len 
            If *this\bar\min >= _scroll_pos_
              *this\bar\button[#__b_1]\color\state = #__s_3
              ; *this\bar\button[#__b_1]\interact = #False
              ; *this\bar\button[#__b_1]\hide = #True
            Else
              If *this\bar\button[#__b_1]\color\state <> #__s_2
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_1]\interact = #True
              ; *this\bar\button[#__b_1]\hide = #False
            EndIf 
          EndIf
          
          ; _in_stop_
          If *this\bar\button[#__b_2]\len
            If _scroll_pos_ >= *this\bar\page\end
              *this\bar\button[#__b_2]\color\state = #__s_3
              ; *this\bar\button[#__b_2]\interact = #False
              ; *this\bar\button[#__b_2]\hide = #True
            Else
              If *this\bar\button[#__b_2]\color\state <> #__s_2
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_2]\interact = #True
              ; *this\bar\button[#__b_2]\hide = #False
            EndIf 
          EndIf
          
          ; disable thumb button
          If *this\bar\thumb\len
            ; Debug   ""+ *this\bar\min +" "+ *this\bar\page\end
            If *this\bar\min >= *this\bar\page\end
              *this\bar\button[#__b_3]\color\state = #__s_3
            ElseIf *this\bar\button[#__b_3]\color\state <> #__s_2
              *this\bar\button[#__b_3]\color\state = #__s_0
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      ; update draw coordinate
      If *this\draw
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
                  
                  *this\parent\scroll\y =- *this\bar\page\pos + *this\y
                  
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
                  *this\parent\scroll\x =- *this\bar\page\pos + *this\x
                  
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
          ; _in_start_
          If *this\bar\button[#__b_1]\len 
            If *this\bar\min >= _scroll_pos_
              *this\bar\button[#__b_1]\color\state = #__s_3
              ; *this\bar\button[#__b_1]\interact = #False
              *this\bar\button[#__b_1]\hide = #True
            Else
              If *this\bar\button[#__b_1]\color\state <> #__s_2
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_1]\interact = #True
              *this\bar\button[#__b_1]\hide = #False
            EndIf 
          EndIf
          
          ; _in_stop_
          If *this\bar\button[#__b_2]\len
            If _scroll_pos_ >= *this\bar\page\end
              *this\bar\button[#__b_2]\color\state = #__s_3
              ; *this\bar\button[#__b_2]\interact = #False
              *this\bar\button[#__b_2]\hide = #True
            Else
              If *this\bar\button[#__b_2]\color\state <> #__s_2
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_2]\interact = #True
              *this\bar\button[#__b_2]\hide = #False
            EndIf 
          EndIf
          
          If *this\bar\vertical
            *this\x[#__c_2] = *this\x + *this\bs
            *this\y[#__c_2] = *this\y + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\height[#__c_2] = *this\height - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\width[#__c_2] = *this\width - *this\bs - 1
          Else
            *this\y[#__c_2] = *this\y + *this\bs
            *this\x[#__c_2] = *this\x + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\width[#__c_2] = *this\width - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\height[#__c_2] = *this\height - *this\bs - 1
          EndIf
          
          If *this\bar\button[#__b_2]\len 
            If *this\bar\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_2]\x = *this\x[#__c_2]  + (*this\width[#__c_2]-*this\bar\button[#__b_2]\len)/2            
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\y = *this\y[#__c_1] + *this\bs
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y[#__c_2] + (*this\height[#__c_2]-*this\bar\button[#__b_2]\len)/2           
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\x = *this\x[#__c_1] + *this\bs
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
            EndIf
          EndIf
          
          If *this\bar\button[#__b_1]\len 
            If *this\bar\vertical 
              ; Botom button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x[#__c_2] + (*this\width[#__c_2]-*this\bar\button[#__b_1]\len)/2             
              *this\bar\button[#__b_1]\width =*this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\y = *this\Y+*this\height-*this\bar\button[#__b_1]\height - *this\bs
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y[#__c_2] + (*this\height[#__c_2]-*this\bar\button[#__b_1]\len)/2            
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\x = *this\X+*this\width-*this\bar\button[#__b_1]\width - *this\bs
            EndIf
          EndIf
          
          ;If *this\bar\thumb\len
          If *this\bar\vertical
            *this\bar\button[#__b_3]\x = *this\x[#__c_2]           
            *this\bar\button[#__b_3]\width = *this\width[#__c_2]
            *this\bar\button[#__b_3]\height = *this\bar\max                             
            *this\bar\button[#__b_3]\y = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
          Else
            *this\bar\button[#__b_3]\y = *this\y[#__c_2]           
            *this\bar\button[#__b_3]\height = *this\height[#__c_2]
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
              
              *this\bar\button[#__b_3]\y[#__c_1]   = (*this\bar\button[#__b_3]\y + *this\bar\button[#__b_3]\height/2)
              *this\bar\button[#__b_3]\x[#__c_1]   = *this\x + (*this\width-*this\bar\button[#__b_3]\round)/2 + Bool(*this\width%2)
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
              
              *this\bar\button[#__b_3]\x[#__c_1]   = (*this\bar\button[#__b_3]\x + *this\bar\button[#__b_3]\width/2) ; - *this\x
              *this\bar\button[#__b_3]\y[#__c_1]   = *this\y + (*this\height-*this\bar\button[#__b_3]\round)/2 + Bool(*this\height%2)
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
              If *this\root\canvas\container
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
              If *this\root\canvas\container 
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
              If *this\bar\increment = ValF(StrF(*this\bar\increment, i))
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
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Bar_SetPos(*this._s_widget, ThumbPos.i)
      If ThumbPos < *this\bar\area\pos : ThumbPos = *this\bar\area\pos : EndIf
      If ThumbPos > *this\bar\area\end : ThumbPos = *this\bar\area\end : EndIf
      
      If *this\bar\thumb\end <> ThumbPos : *this\bar\thumb\end = ThumbPos
        ProcedureReturn Bar_SetState(*this, _bar_invert_(*this\bar, _bar_page_pos_(*this\bar, ThumbPos), *this\bar\inverted))
      EndIf
    EndProcedure
    
    Procedure.b Bar_Change(*bar._s_bar, ScrollPos.f)
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
    
    Procedure.b Bar_SetState(*this._s_widget, state.f)
      Protected result
      
      If Bar_Change(*this\bar, state) : Bar_Update(*this)
        If Not (*this\type = #PB_GadgetType_ScrollBar And _is_scrollbar_(*this))
          If *this\type <> #PB_GadgetType_TabBar
            If *this\root\canvas\gadget <> EventGadget() 
              ReDraw(*this\root) ; сним у панель setstate хурмить
            EndIf
          EndIf
          
          Post(#PB_EventType_Change, *this, *this\bar\from)
        Else
          Post(#PB_EventType_ScrollChange, *this\parent, *this\bar\from)
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, Value.l)
      Protected Result.l
      
      With *this
        If \splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              \bar\min = Value
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
                
                *this\resize | #__resize_change
                Result = #True
              EndIf
              
            Case #__bar_inverted
              \bar\inverted = Bool(Value)
              ProcedureReturn Update(*this)
              
            Case #__bar_ScrollStep 
              \bar\increment = Value
              
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
    
    Procedure   Bar_Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l, _wheel_x_.b=0, _wheel_y_.b=0)
      Protected Repaint
      
      If event_type = #__Event_MouseEnter
        Repaint | #True
      EndIf
      
      If event_type = #__Event_MouseLeave
        Repaint | #True
      EndIf
      
      If event_type = #__Event_LeftButtonUp 
        If *this\bar\state >= 0
          If *this\bar\button[*this\bar\state]\state = #__s_2
            ;Debug " up button - " + *this\bar\state
            *this\bar\button[*this\bar\state]\state = #__s_1
            Repaint | #True
          EndIf
          
          ;Debug ""+*this\bar\state +" "+ *this\bar\from
          
          If *this\bar\state <> *this\bar\from
            If *this\bar\button[*this\bar\state]\state = #__s_1
              *this\bar\button[*this\bar\state]\state = #__s_0
              
              If *this\bar\state = #__b_3 
                If *this\cursor And *this\bar\button[#__b_2]\len <> $ffffff
                  ; Debug  "  reset cur"
                  ;                 set_cursor(*this, #PB_Cursor_Default)
                  SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                EndIf
              EndIf
              
              ; Debug " up leave button - " + *this\bar\state
              Repaint | #True
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_TabBar
            If *this\bar\state = #__b_3
              If *this\index[#__s_1] >= 0 And 
                 *this\index[#__s_2] <> *this\index[#__s_1]
                Repaint | Tab_SetState(*this, *this\index[#__s_1])
              EndIf
            EndIf
          EndIf
          
          *this\bar\state =- 1 
        EndIf
      EndIf
      
      If event_type = #__Event_MouseMove Or
         event_type = #__Event_MouseEnter Or
         event_type = #__Event_MouseLeave Or
         event_type = #__Event_LeftButtonUp
        
        
        If *this\bar\button[#__b_3]\interact And
           *this\bar\button[#__b_3]\state <> #__s_3 And
           _from_point_(mouse_x, mouse_y, *this, [#__c_2]) And
           _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_3])
          
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
                If *this\bar\button[#__b_2]\len <> $ffffff
                  ; Debug " set cur"
                  ; set_cursor(*this, *this\cursor)
                  SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
                EndIf
              EndIf
              
              *this\bar\from = #__b_3
              ; Debug " enter button - 3"
              Repaint | #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_2]\interact And
               *this\bar\button[#__b_2]\state <> #__s_3 And 
               _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_2])
          
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
              Repaint | #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_1]\interact And 
               *this\bar\button[#__b_1]\state <> #__s_3 And 
               _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_1])
          
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
              Repaint | #True
            EndIf
          EndIf
          
        Else
          If *this\bar\from <>- 1
            If *this\bar\button[*this\bar\from]\state = #__s_1
              *this\bar\button[*this\bar\from]\state = #__s_0
              
              If Not *this\root\selected 
                If *this\bar\from = #__b_3 And *this\cursor
                  If *this\bar\button[#__b_2]\len <> $ffffff
                    ; Debug  " reset cur"
                    ;                 set_cursor(*this, #PB_Cursor_Default)
                    SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  EndIf
                EndIf
              EndIf
              
              ; Debug " leave button - " + *this\bar\from
            EndIf
            
            *this\bar\from =- 1
            Repaint | #True
          EndIf
        EndIf
        
        If *this\Type = #PB_GadgetType_TabBar
          If *this\count\items
            ForEach *this\bar\_s()
              ; If *this\bar\_s()\draw
              If _from_point_((mouse_x-*this\x[#__c_1])+Bool(Not *this\bar\vertical) * *this\bar\page\pos, mouse_y-*this\y[#__c_1]+Bool(*this\bar\vertical) * *this\bar\page\pos, *this\bar\_s()) And *this\bar\from = #__b_3
                ;If _from_point_(mouse_x, mouse_y, *this\bar\_s()) And *this\bar\from = #__b_3
                If *this\index[#__s_1] <> *this\bar\_s()\index
                  If *this\index[#__s_1] >= 0
                    ; Debug " leave tab - " + *this\index[#__s_1]
                    Repaint | #True
                  EndIf
                  
                  *this\index[#__s_1] = *this\bar\_s()\index
                  ; Debug " enter tab - " + *this\index[#__s_1]
                  Repaint | #True
                EndIf
                Break
                
              ElseIf *this\index[#__s_1] = *this\bar\_s()\index
                ; Debug " leave tab - " + *this\index[#__s_1]
                *this\index[#__s_1] =- 1
                Repaint | #True
                Break
              EndIf
              ; EndIf
            Next
          EndIf
        Else       
          ;         If Not *this\root\mouse\buttons
          ;          ; *this\bar\state = *this\bar\from
          ;         EndIf
        EndIf
        
        ; set color state
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
      EndIf
      
      If event_type = #__Event_LeftButtonDown
        If *this\bar\from >= 0 And 
           *this\bar\button[*this\bar\from]\state = #__s_1
          *this\bar\button[*this\bar\from]\state = #__s_2
          
          If *this\Type <> #PB_GadgetType_TrackBar
            ; set color state
            If *this\bar\button[*this\bar\from]\color\state <> #__s_3 And 
               *this\bar\button[*this\bar\from]\color\state <> *this\bar\button[*this\bar\from]\state
              *this\bar\button[*this\bar\from]\color\state = *this\bar\button[*this\bar\from]\state
            EndIf
          EndIf
          
          If *this\bar\from = #__b_3
            Repaint = #True
          ElseIf (*this\bar\from = #__b_1 And *this\bar\inverted) Or
                 (*this\bar\from = #__b_2 And Not *this\bar\inverted)
            
            Post(#PB_EventType_Down, *this)
            Repaint | Bar_SetState(*this, *this\bar\page\pos + *this\bar\increment)
            
          ElseIf (*this\bar\from = #__b_2 And *this\bar\inverted) Or 
                 (*this\bar\from = #__b_1 And Not *this\bar\inverted)
            
            Post(#PB_EventType_Up, *this)
            Repaint | Bar_SetState(*this, *this\bar\page\pos - *this\bar\increment)
          EndIf
          
          *this\bar\state = *this\bar\from
        EndIf
      EndIf
      
      If event_type = #__Event_MouseMove
        If *this\bar\state And 
           *this\root\selected = *this
          If *this\bar\vertical
            Repaint | Bar_SetPos(*this, (mouse_y - *this\root\mouse\delta\y))
          Else
            Repaint | Bar_SetPos(*this, (mouse_x - *this\root\mouse\delta\x))
          EndIf
          
          SetWindowTitle(EventWindow(), Str(*this\bar\page\pos) +" "+ Str(*this\bar\thumb\pos-*this\bar\area\pos))
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    ;}
    
    
    ;-
    ;- PUBLIC
    Macro  _start_drawing_(_this_)
      StartDrawing(CanvasOutput(_this_\root\canvas\gadget)) 
      
      If _this_\text\fontID
        DrawingFont(_this_\text\fontID) 
      EndIf
    EndMacro
    
    Macro _text_scroll_x_(_this_)
      *this\change = _bar_scrollarea_change_(*this\scroll\h, _this_\text\caret\x-(Bool(_this_\text\caret\x>0) * (_this_\scroll\h\x+_this_\text\_padding+_this_\text\x)), (_this_\text\_padding*2+_this_\text\x*2+_this_\row\margin\width+2)) ; ok
    EndMacro
    
    Macro _text_scroll_y_(_this_)
      *this\change = _bar_scrollarea_change_(*this\scroll\v, _this_\text\caret\y-(Bool(_this_\text\caret\y>0) * (_this_\scroll\v\y+_this_\text\_padding+_this_\text\y)), (_this_\text\_padding*2+_this_\text\y*2+_this_\text\caret\height)) ; ok
    EndMacro
    
    ;-
    Macro _make_line_pos_(_this_, _len_)
      _this_\row\_s()\text\len = _len_
      _this_\row\_s()\text\pos = _this_\text\pos
      _this_\text\pos + _this_\row\_s()\text\len + 1 ; Len(#LF$)
    EndMacro
    
    Macro _make_line_x_(_this_, _scroll_width_)
      If _this_\vertical
        If _this_\text\rotate = 90
          _this_\row\_s()\text\x[#__c_2] = _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        ElseIf _this_\text\rotate = 270
          _this_\row\_s()\text\x[#__c_2] = (_scroll_width_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        EndIf
        
      Else
        If _this_\text\rotate = 0
          If _this_\text\align\right
            _this_\row\_s()\text\x[#__c_2] = (_scroll_width_ - _this_\row\_s()\text\width) 
          ElseIf _this_\text\align\horizontal
            _this_\row\_s()\text\x[#__c_2] = (_scroll_width_ - _this_\row\_s()\text\width)/2
          Else
            _this_\row\_s()\text\x[#__c_2] = 0
          EndIf
          
        ElseIf _this_\text\rotate = 180
          If _this_\text\align\right
            _this_\row\_s()\text\x[#__c_2] = _scroll_width_
          ElseIf _this_\text\align\horizontal
            _this_\row\_s()\text\x[#__c_2] = (_scroll_width_ + _this_\row\_s()\text\width)/2 
          Else
            _this_\row\_s()\text\x[#__c_2] = _this_\row\_s()\text\width 
          EndIf
          
        EndIf
      EndIf
      
      _this_\row\_s()\text\x = _x_ + _this_\row\_s()\text\x[#__c_2]
    EndMacro
    
    Macro _make_line_y_(_this_, _scroll_height_)
      If _this_\vertical
        If _this_\text\rotate = 90
          If _this_\text\align\bottom
            _this_\row\_s()\text\y[#__c_2] = _scroll_height_ 
          ElseIf _this_\text\align\vertical
            _this_\row\_s()\text\y[#__c_2] = (_scroll_height_ + _this_\row\_s()\text\width)/2
          Else
            _this_\row\_s()\text\y[#__c_2] = _this_\row\_s()\text\width
          EndIf
          
        ElseIf _this_\text\rotate = 270
          If _this_\text\align\bottom
            _this_\row\_s()\text\y[#__c_2] = ((_scroll_height_ - _this_\row\_s()\text\width) ) 
          ElseIf _this_\text\align\vertical
            _this_\row\_s()\text\y[#__c_2] = (_scroll_height_ - _this_\row\_s()\text\width)/2 
          Else
            _this_\row\_s()\text\y[#__c_2] = 0
          EndIf
          
        EndIf
        
      Else
        If _this_\text\rotate = 0
          _this_\row\_s()\text\y[#__c_2] = _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        ElseIf _this_\text\rotate = 180
          _this_\row\_s()\text\y[#__c_2] = (_scroll_height_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        EndIf
      EndIf
      
      _this_\row\_s()\text\y = _y_ + _this_\row\_s()\text\y[#__c_2]
    EndMacro
    
    Macro _make_scroll_x_(_this_)
      If _this_\text\align\right
        _this_\scroll\x = (((_this_\width - _this_\bs*2) - _this_\scroll\align\right - _this_\text\_padding) - _this_\scroll\width)
      ElseIf _this_\text\align\horizontal
        _this_\scroll\x = (((_this_\width - _this_\bs*2) + _this_\scroll\align\left - _this_\scroll\align\right) - _this_\scroll\width + Bool(_this_\scroll\width % 2))/2 
      Else
        _this_\scroll\x = _this_\text\_padding + _this_\scroll\align\left
      EndIf
      
      If *this\scroll\x < 0
        *this\scroll\x = _this_\scroll\align\left
      EndIf
    EndMacro
    
    Macro _make_scroll_y_(_this_)
      If _this_\text\align\bottom
        _this_\scroll\y = (((_this_\height - _this_\bs*2) - _this_\scroll\align\bottom - _this_\text\_padding) - _this_\scroll\height) 
      ElseIf _this_\text\align\vertical
        _this_\scroll\y = ((((_this_\height - _this_\bs*2) + _this_\scroll\align\top - _this_\scroll\align\bottom) - _this_\scroll\height + Bool(_this_\scroll\height % 2))/2)
      Else
        _this_\scroll\y = _this_\text\_padding + _this_\scroll\align\top
      EndIf
      
      If *this\scroll\y < 0
        *this\scroll\y = _this_\scroll\align\top
      EndIf
      ;     If *this\scroll\v\bar\page\pos < 0
      ;       *this\scroll\y =- *this\scroll\v\bar\page\pos
      ;     EndIf
    EndMacro
    
    Macro _make_scroll_height_(_this_, _height_)
      If _this_\vertical
        _this_\scroll\width + _height_ + _this_\flag\gridlines
      Else
        _this_\scroll\height + _height_ + _this_\flag\gridlines
      EndIf
      
      If _this_\scroll\v And 
         _this_\scroll\v\bar\increment <> _height_ + Bool(_this_\flag\gridlines)
        _this_\scroll\v\bar\increment = _height_ + Bool(_this_\flag\gridlines)
      EndIf
    EndMacro
    
    Macro _make_scroll_width_(_this_, _width_)
      If _this_\vertical
        If _this_\text\multiline =- 1 And _this_\scroll\v
          _this_\scroll\height = _make_area_height_(_this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
        Else
          If _this_\scroll\height < _width_ + _this_\text\y*2 + _this_\text\caret\height
            _this_\scroll\height = _width_ + _this_\text\y*2 + _this_\text\caret\height
          EndIf
        EndIf
      Else
        If _this_\text\multiline =- 1 And _this_\scroll\h
          _this_\scroll\width = _make_area_width_(_this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
        Else
          If _this_\scroll\width < _width_ + _this_\text\x*2 + _this_\text\caret\width
            _this_\scroll\width = _width_ + _this_\text\x*2 + _this_\text\caret\width
          EndIf
        EndIf
      EndIf
    EndMacro
    
    
    ;-
    Procedure.l _text_caret_(*this._s_widget)
      Protected i.l, X.l, Position.l =- 1,  
                MouseX.l, Distance.f, MinDistance.f = Infinity()
      
      MouseX = *this\root\mouse\x - (*this\row\_s()\text\x + *this\scroll\x)
      
      ; Get caret pos
      For i = 0 To *this\row\_s()\text\len
        X = TextWidth(Left(*this\row\_s()\text\string, i))
        Distance = (MouseX-X)*(MouseX-X)
        
        If MinDistance > Distance 
          MinDistance = Distance
          Position = i
        EndIf
      Next 
      
      ProcedureReturn Position
    EndProcedure
    
    Procedure   _edit_sel_(*this._s_widget, _pos_, _len_)
      If _pos_ < 0 : _pos_ = 0 : EndIf
      If _len_ < 0 : _len_ = 0 : EndIf
      
      If _pos_ > *this\row\_s()\text\len
        _pos_ = *this\row\_s()\text\len
      EndIf
      
      If _len_ > *this\row\_s()\text\len
        _len_ = *this\row\_s()\text\len
      EndIf
      
      Protected _line_ = *this\index[#__c_1]
      Protected _caret_last_len_ = Bool(_line_ <> *this\index[#__c_2] And 
                                        (*this\row\_s()\index < *this\index[#__c_1] Or 
                                         *this\row\_s()\index < *this\index[#__c_2])) * *this\flag\fullselection
      
      ;     If  _caret_last_len_
      ;       _caret_last_len_ = *this\width[2]
      ;     EndIf
      
      *this\row\_s()\text\edit[1]\len = _pos_
      *this\row\_s()\text\edit[2]\len = _len_
      
      *this\row\_s()\text\edit[1]\pos = 0 
      *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
      
      *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos+*this\row\_s()\text\edit[2]\len 
      *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len-*this\row\_s()\text\edit[3]\pos
      
      ; set string & size (left;selected;right)
      If *this\row\_s()\text\edit[1]\len > 0
        *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
        *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
      Else
        *this\row\_s()\text\edit[1]\string = ""
        *this\row\_s()\text\edit[1]\width = 0
      EndIf
      If *this\row\_s()\text\edit[2]\len > 0
        If *this\row\_s()\text\edit[2]\len <> *this\row\_s()\text\len
          *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
          *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + _caret_last_len_ 
          ;         + Bool((_line_ <  *this\index[2] And *this\row\_s()\index = _line_) Or
          ;                                                                                                  ;(_line_ <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
          ;         (_line_  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\flag\fullselection
        Else
          *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + _caret_last_len_
        EndIf
      Else
        *this\row\_s()\text\edit[2]\string = ""
        *this\row\_s()\text\edit[2]\width = _caret_last_len_
      EndIf
      
      If *this\row\_s()\text\edit[3]\len > 0
        *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
        *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
      Else
        *this\row\_s()\text\edit[3]\string = ""
        *this\row\_s()\text\edit[3]\width = 0
      EndIf
      
      ; because bug in mac os
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        If *this\row\_s()\text\edit[2]\width And Not (_line_ = *this\index[#__c_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]) And
           *this\row\_s()\text\edit[2]\width <> *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
        EndIf
      CompilerEndIf
      
      ; для красоты
      If *this\row\_s()\text\edit[2]\width > *this\scroll\width
        *this\row\_s()\text\edit[2]\width - _caret_last_len_
      EndIf
      
      ; set position (left;selected;right)
      *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
      *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x+*this\row\_s()\text\edit[1]\width) 
      *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x+*this\row\_s()\text\edit[2]\width)
      
      ; если выделили свнизу вверх
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__c_2] >= *this\row\_s()\index
        *this\text\edit[1]\len = (*this\row\_s()\text\pos+*this\row\_s()\text\edit[2]\pos)
        *this\text\edit[2]\pos = *this\text\edit[1]\len
      EndIf
      
      ; если выделили сверху ввниз
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__c_2] =< *this\row\_s()\index
        *this\text\edit[3]\pos = (*this\row\_s()\text\pos+*this\row\_s()\text\edit[3]\pos)
        *this\text\edit[3]\len = (*this\text\len-*this\text\edit[3]\pos)
      EndIf
      
      ; text/pos/len/state
      If _line_ = *this\row\_s()\index
        If *this\text\edit[2]\len <> (*this\text\edit[3]\pos-*this\text\edit[2]\pos)
          *this\text\edit[2]\len = (*this\text\edit[3]\pos-*this\text\edit[2]\pos)
        EndIf
        
        ; set text (left;selected;right)
        If *this\text\edit[1]\len > 0
          *this\text\edit[1]\string = Left(*this\text\string.s, *this\text\edit[1]\len) 
        Else
          *this\text\edit[1]\string = ""
        EndIf
        If *this\text\edit[2]\len > 0
          *this\text\edit[2]\string = Mid(*this\text\string.s, 1 + *this\text\edit[2]\pos, *this\text\edit[2]\len) 
        Else
          *this\text\edit[2]\string = ""
        EndIf
        If *this\text\edit[3]\len > 0
          *this\text\edit[3]\string = Right(*this\text\string.s, *this\text\edit[3]\len)
        Else
          *this\text\edit[3]\string = ""
        EndIf
        
        ;       ; set cursor pos
        ;       If _line_ = *this\row\_s()\index
        *this\text\caret\y = *this\row\_s()\text\y + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        *this\text\caret\height = *this\row\_s()\text\height
        
        If _line_ > *this\index[#__c_2] Or
           (_line_ = *this\index[#__c_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
          *this\text\caret\x = *this\row\_s()\text\edit[3]\x
          *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[3]\pos
        Else
          *this\text\caret\x = *this\row\_s()\text\edit[2]\x
          *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[2]\pos
        EndIf
        
        ;*this\text\caret\width = 1
        
        ProcedureReturn 1
        ;       EndIf
      EndIf
      
    EndProcedure
    
    Procedure   _edit_sel_set_(*this._s_widget, _line_, _scroll_) ; Ok
                                                                  ;     Debug  ""+*this\text\caret\pos[1] +" "+ *this\text\caret\pos[2]
                                                                  ;     ProcedureReturn 3
      Macro _edit_sel_reset_(_this_)
        _this_\text\edit[1]\len = 0 
        _this_\text\edit[2]\len = 0 
        _this_\text\edit[3]\len = 0 
        
        _this_\text\edit[1]\pos = 0 
        _this_\text\edit[2]\pos = 0 
        _this_\text\edit[3]\pos = 0 
        
        _this_\text\edit[1]\width = 0 
        _this_\text\edit[2]\width = 0 
        _this_\text\edit[3]\width = 0 
        
        _this_\text\edit[1]\string = ""
        _this_\text\edit[2]\string = "" 
        _this_\text\edit[3]\string = ""
      EndMacro
      
      
      If _scroll_
        
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If (_line_ = *this\row\_s()\index Or *this\index[#__c_2] = *this\row\_s()\index) Or    ; линия
             (_line_ < *this\row\_s()\index And *this\index[#__c_2] > *this\row\_s()\index) Or   ; верх
             (_line_ > *this\row\_s()\index And *this\index[#__c_2] < *this\row\_s()\index)      ; вниз
            
            If _line_ = *this\index[#__c_2]  ; And *this\index[2] = *this\row\_s()\index
              If *this\text\caret\pos[1] > *this\text\caret\pos[2]
                _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
              EndIf
              
            ElseIf (_line_ < *this\row\_s()\index And *this\index[#__c_2] > *this\row\_s()\index) Or   ; верх
                   (_line_ > *this\row\_s()\index And *this\index[#__c_2] < *this\row\_s()\index)      ; вниз
              
              If _line_ < 0
                ; если курсор перешел за верхный предел
                *this\index[#__c_1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                ; если курсор перешел за нижный предел
                *this\index[#__c_1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s()\text\len
              EndIf
              
              _edit_sel_(*this, 0, *this\row\_s()\text\len)
              
            ElseIf _line_ = *this\row\_s()\index 
              If _line_ > *this\index[#__c_2] 
                _edit_sel_(*this, 0, *this\text\caret\pos[1])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
              EndIf
              
            ElseIf *this\index[#__c_2] = *this\row\_s()\index
              
              
              If *this\count\items = 1 And 
                 (_line_ < 0 Or _line_ > *this\count\items - 1)
                ; если курсор перешел за пределы итемов
                *this\index[#__c_1] = 0
                
                If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                  _edit_sel_(*this, *this\text\caret\pos[2], Bool(_line_ <> *this\index[#__c_2]) * (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
                
                *this\index[#__c_1] = _line_
              Else
                If _line_ < 0
                  *this\index[#__c_1] = 0
                  *this\text\caret\pos[1] = 0
                ElseIf _line_ > *this\count\items - 1
                  *this\index[#__c_1] = *this\count\items - 1
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                EndIf
                
                If *this\index[#__c_2] > _line_ 
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  _edit_sel_(*this, *this\text\caret\pos[2], (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
              EndIf
              
            EndIf
            
            If *this\index[#__c_1] = *this\row\_s()\index
              ; vertical scroll
              If _scroll_ = 1
                _text_scroll_y_(*this)
              EndIf
              
              ; horizontal scroll
              If _scroll_ =- 1
                _text_scroll_x_(*this)
              EndIf
            EndIf
            
          ElseIf (*this\row\_s()\text\edit[2]\width <> 0 And 
                  *this\index[#__c_2] <> *this\row\_s()\index And _line_ <> *this\row\_s()\index)
            
            ; reset selected string
            _edit_sel_reset_(*this\row\_s())
            
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
      EndIf 
      
      ProcedureReturn _scroll_
    EndProcedure
    
    Procedure   _edit_sel_draw_(*this._s_widget, _line_, _caret_=-1) ; Ok
      Protected Repaint.b
      
      Macro _edit_sel_is_line_(_this_)
        Bool(_this_\row\_s()\text\edit[2]\width And 
             _this_\root\mouse\x > _this_\row\_s()\text\edit[2]\x-_this_\scroll\h\bar\page\pos And
             _this_\root\mouse\y > _this_\row\_s()\text\y-_this_\scroll\v\bar\page\pos And 
             _this_\root\mouse\y < (_this_\row\_s()\text\y+_this_\row\_s()\text\height)-_this_\scroll\v\bar\page\pos And
             _this_\root\mouse\x < (_this_\row\_s()\text\edit[2]\x+_this_\row\_s()\text\edit[2]\width)-_this_\scroll\h\bar\page\pos)
      EndMacro
      
      With *this
        ; select enter mouse item
        If _line_ >= 0 And 
           _line_ < *this\count\items And 
           _line_ <> *this\row\_s()\index
          \row\_s()\color\State = 0
          SelectElement(*this\row\_s(), _line_) 
          \row\_s()\color\State = 1
        EndIf
        
        If _start_drawing_(*this)
          
          If _caret_ =- 1
            _caret_ = _text_caret_(*this) 
          Else
            ; Ctrl - A
            Repaint =- 2
          EndIf
          
          ; если перемещаем выделеный текст
          If *this\row\box\checked 
            If *this\index[#__c_1] <> _line_
              *this\index[#__c_1] = _line_
              Repaint = 1
            EndIf
            
            If _edit_sel_is_line_(*this)
              If *this\text\caret\pos[2] <> *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[2] = *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[1] = *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len
                
                If _caret_ < *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len/2
                  _caret_ = *this\row\_s()\text\edit[1]\len
                Else
                  _caret_ = *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len
                EndIf
                
                Repaint =- 1
              EndIf
            Else
              If *this\text\caret\pos[2] <> _caret_
                *this\text\caret\pos[2] = _caret_
                *this\text\caret\pos[1] = _caret_
                Repaint =- 1
              EndIf
            EndIf
            
            If Repaint 
              ; set cursor pos
              *this\text\caret\y = *this\row\_s()\text\y
              *this\text\caret\height = *this\row\_s()\text\height - 1
              *this\text\caret\x = *this\row\_s()\text\x + TextWidth(Left(*this\row\_s()\text\string, _caret_))
              _text_scroll_x_(*this)
            EndIf
            
          Else
            If *this\text\caret\pos[1] <> _caret_
              *this\text\caret\pos[1] = _caret_
              Repaint =- 1 ; scroll horizontal
            EndIf
            
            If *this\index[#__c_1] <> _line_ 
              *this\index[#__c_1] = _line_ ; scroll vertical
              Repaint = 1
            EndIf
            
            Repaint = _edit_sel_set_(*this, _line_, Repaint)
          EndIf
          
          StopDrawing() 
        EndIf
      EndWith
      
      ProcedureReturn Bool(Repaint)
    EndProcedure
    
    Procedure   _edit_sel_update_(*this._s_widget)
      ; ProcedureReturn 
      
      ; key - (return & backspace)
      If *this\index[#__c_2] = *this\row\_s()\index 
        *this\row\selected = *this\row\_s()
        
        If *this\index[#__c_2] = *this\index[#__c_1]
          If *this\text\caret\pos[1] > *this\text\caret\pos[2]
            _edit_sel_(*this, *this\text\caret\pos[2] , *this\text\caret\pos[1]-*this\text\caret\pos[2])
          Else
            _edit_sel_(*this, *this\text\caret\pos[1] , *this\text\caret\pos[2]-*this\text\caret\pos[1])
          EndIf
        EndIf
      EndIf
      
      ;     If *this\text\count = *this\count\items
      ;       ; move caret
      ;       If *this\index[2] + 1 = *this\row\_s()\index 
      ;         ;         *this\index[1] = *this\row\_s()\index 
      ;         ;         *this\index[2] = *this\index[1]
      ;         
      ;         If *this\index[2] = *this\index[1]
      ;           If *this\text\caret\pos[1]<>*this\text\caret\pos[2]
      ;             _edit_sel_(*this, 0, *this\text\caret\pos[1]-*this\row\selected\text\len)
      ;           Else
      ;             _edit_sel_(*this, *this\text\caret\pos[1]-*this\row\selected\text\len, 0)
      ;           EndIf
      ;         EndIf
      ;         
      ;       EndIf
      ;     EndIf
      
      
      
      
      Protected  _line_ = *this\index[#__c_1]
      
      
      If _line_ = *this\index[#__c_2]  ; And *this\index[2] = *this\row\_s()\index
        If *this\text\caret\pos[1] > *this\text\caret\pos[2]
          _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
        EndIf
        
      ElseIf (*this\index[#__c_2] > *this\row\_s()\index And _line_ < *this\row\_s()\index) Or   ; верх
             (*this\index[#__c_2] < *this\row\_s()\index And _line_ > *this\row\_s()\index)      ; вниз
        
        _edit_sel_(*this, 0, *this\row\_s()\text\len)
        
      ElseIf _line_ = *this\row\_s()\index 
        If _line_ > *this\index[#__c_2] 
          _edit_sel_(*this, 0, *this\text\caret\pos[1])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
        EndIf
        
      ElseIf *this\index[#__c_2] = *this\row\_s()\index
        If *this\index[#__c_2] > _line_ 
          _edit_sel_(*this, 0, *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[2], *this\row\_s()\text\len - *this\text\caret\pos[2])
        EndIf
        
      EndIf
      
      
      
      
      
      
      ProcedureReturn 
      
      If (*this\index[#__c_2] = *this\row\_s()\index Or *this\index[#__c_1] = *this\row\_s()\index) Or    ; линия
         (*this\index[#__c_2] > *this\row\_s()\index And *this\index[#__c_1] < *this\row\_s()\index) Or   ; верх
         (*this\index[#__c_2] < *this\row\_s()\index And *this\index[#__c_1] > *this\row\_s()\index)      ; вниз
        
        If (*this\index[#__c_2] > *this\row\_s()\index And *this\index[#__c_1] < *this\row\_s()\index) Or   ; верх
           (*this\index[#__c_2] < *this\row\_s()\index And *this\index[#__c_1] > *this\row\_s()\index)      ; вниз
          
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
          
        ElseIf *this\index[#__c_1] = *this\row\_s()\index 
          If *this\index[#__c_1] > *this\index[#__c_2] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[1]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[1] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        ElseIf *this\index[#__c_2] = *this\row\_s()\index
          If *this\index[#__c_2] > *this\index[#__c_1] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[2]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[2] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        EndIf
        
        *this\row\_s()\text\edit[1]\pos = 0 
        *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
        
        *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos+*this\row\_s()\text\edit[2]\len 
        *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len-*this\row\_s()\text\edit[3]\pos
        
        ; set string & size (left;selected;right)
        If *this\row\_s()\text\edit[1]\len > 0
          *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
          *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
        Else
          *this\row\_s()\text\edit[1]\string = ""
          *this\row\_s()\text\edit[1]\width = 0
        EndIf
        If *this\row\_s()\text\edit[2]\len > 0
          If *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
            *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
            *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + *this\flag\fullselection
          Else
            *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
            *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + Bool((*this\index[#__c_1] <  *this\index[#__c_2] And *this\row\_s()\index = *this\index[#__c_1]) Or
                                                                                                     ; (*this\index[1] <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
            (*this\index[#__c_1]  > *this\index[#__c_2] And *this\row\_s()\index = *this\index[#__c_2])) * *this\flag\fullselection
          EndIf
        Else
          *this\row\_s()\text\edit[2]\string = ""
          *this\row\_s()\text\edit[2]\width = 0
        EndIf
        If *this\row\_s()\text\edit[3]\len > 0
          *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
          *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
        Else
          *this\row\_s()\text\edit[3]\string = ""
          *this\row\_s()\text\edit[3]\width = 0
        EndIf
        
        ; set position (left;selected;right)
        *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
        *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x+*this\row\_s()\text\edit[1]\width) 
        *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x+*this\row\_s()\text\edit[2]\width)
        
        ; set cursor pos
        If *this\index[#__c_1] = *this\row\_s()\index 
          *this\text\caret\y = *this\row\_s()\text\y
          *this\text\caret\height = *this\row\_s()\text\height
          
          If *this\index[#__c_1] > *this\index[#__c_2] Or
             (*this\index[#__c_1] = *this\index[#__c_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
            *this\text\caret\x = *this\row\_s()\text\edit[3]\x
          Else
            *this\text\caret\x = *this\row\_s()\text\edit[2]\x
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i _edit_sel_start_(*this._s_widget)
      Protected result.i, i.i, char.i
      
      Macro _edit_sel_end_(_char_)
        Bool((_char_ > = ' ' And _char_ = < '/') Or 
             (_char_ > = ':' And _char_ = < '@') Or 
             (_char_ > = '[' And _char_ = < 96) Or 
             (_char_ > = '{' And _char_ = < '~'))
      EndMacro
      
      With *this
        ; |<<<<<< left edge of the word 
        If \text\caret\pos[1] > 0 
          For i = \text\caret\pos[1] - 1 To 1 Step - 1
            char = Asc(Mid(\row\_s()\text\string.s, i, 1))
            If _edit_sel_end_(char)
              Break
            EndIf
          Next 
          
          result = i
        EndIf
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i _edit_sel_stop_(*this._s_widget)
      Protected result.i, i.i, char.i
      
      With *this
        ; >>>>>>| right edge of the word
        For i = \text\caret\pos[1] + 2 To \row\_s()\text\len
          char = Asc(Mid(\row\_s()\text\string.s, i, 1))
          If _edit_sel_end_(char)
            Break
          EndIf
        Next 
        
        result = i - 1
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s _text_insert_make_(*this._s_widget, Text.s)
      Protected String.s, i.i, Len.i
      
      With *this
        If \text\numeric And Text.s <> #LF$
          Static Dot, Minus
          Protected Chr.s, Input.i, left.s, count.i
          
          Len = Len(Text.s) 
          For i = 1 To Len 
            Chr = Mid(Text.s, i, 1)
            Input = Asc(Chr)
            
            Select Input
              Case '0' To '9', '.','-'
              Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
              Default
                Input = 0
            EndSelect
            
            If Input
              If \type = #PB_GadgetType_IPAddress
                left.s = Left(\text\string, \text\caret\pos[1] )
                Select CountString(left.s, ".")
                  Case 0 : left.s = StringField(left.s, 1, ".")
                  Case 1 : left.s = StringField(left.s, 2, ".")
                  Case 2 : left.s = StringField(left.s, 3, ".")
                  Case 3 : left.s = StringField(left.s, 4, ".")
                EndSelect                                           
                count = Len(left.s+Trim(StringField(Mid(\text\string, \text\caret\pos[1] +1), 1, "."), #LF$))
                If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                  Continue
                  ;               ElseIf Mid(\text\string, \text\caret\pos[1] + 1, 1) = "."
                  ;                 \text\caret\pos[1] + 1 : \text\caret\pos[2]=\text\caret\pos[1] 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = '-' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "-"
                Minus = 1
              ElseIf Input <> '-'
                Minus = 0
              Else
                Continue
              EndIf
              
              String.s + Chr
            EndIf
          Next
          
        ElseIf \text\pass
          Len = Len(Text.s) 
          For i = 1 To Len : String.s + "●" : Next
          
        Else
          Select #True
            Case \text\lower : String.s = LCase(Text.s)
            Case \text\upper : String.s = UCase(Text.s)
            Default
              String.s = Text.s
          EndSelect
        EndIf
      EndWith
      
      ProcedureReturn String.s
    EndProcedure
    
    Procedure.b _text_paste_(*this._s_widget, Chr.s="", Count.l=0)
      Protected Repaint.b
      
      With *this
        If \index[#__c_1] <> \index[#__c_2] ; Это значить строки выделени
          If \index[#__c_2] > \index[#__c_1] : Swap \index[#__c_2], \index[#__c_1] : EndIf
          
          If \row\_s()\index <> \index[#__c_2]
            SelectElement(\row\_s(), \index[#__c_2])
          EndIf
          
          If Count
            \index[#__c_2] + Count
            \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
          ElseIf Chr.s = #LF$ ; to return
            \index[#__c_2] + 1
            \text\caret\pos[1] = 0
          Else
            \text\caret\pos[1] = \row\_s()\text\edit[1]\len
            If Chr.s <> ""
              \text\caret\pos[1] + Len(Chr.s)
            EndIf
          EndIf
          
          ; reset items selection
          PushListPosition(*this\row\_s())
          ForEach *this\row\_s()
            If *this\row\_s()\text\edit[2]\width <> 0 
              _edit_sel_reset_(*this\row\_s())
            EndIf
          Next
          PopListPosition(*this\row\_s())
          
          \text\caret\pos[2] = \text\caret\pos[1] 
          \index[#__c_1] = \index[#__c_2]
          \text\change =- 1 
          Repaint = #True
        EndIf
        
        ;       \row\_s()\text\string.s = \row\_s()\text\edit[1]\string + Chr.s + \row\_s()\text\edit[3]\string
        ;       \row\_s()\text\len = Len(\row\_s()\text\string.s)
        
        \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure.b _text_insert_(*this._s_widget, Chr.s)
      Static Dot, Minus, Color.i
      Protected result.b=-1, Input, Input_2, String.s, Count.i
      
      With *this
        Chr.s = _text_insert_make_(*this, Chr.s)
        
        If Chr.s
          Count = CountString(Chr.s, #LF$)
          
          If Not _text_paste_(*this, Chr.s, Count)
            If \row\_s()\text\edit[2]\len 
              If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
              \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
            EndIf
            
            \row\_s()\text\edit[1]\change = 1
            \row\_s()\text\edit[1]\string.s + Chr.s
            \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s)
            
            \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
            \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
            
            If Count
              \index[#__c_2] + Count
              \index[#__c_1] = \index[#__c_2] 
              \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
            Else
              \text\caret\pos[1] + Len(Chr.s) 
            EndIf
            
            \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
            \text\caret\pos[2] = \text\caret\pos[1] 
            ;; \count\items = CountString(\text\string.s, #LF$)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
          SelectElement(\row\_s(), \index[#__c_2]) 
          result = 1 
        EndIf
      EndWith
      
      If result =- 1
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s text_wrap_(text$, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
      ; <http://www.purebasic.fr/english/viewtopic.php?f=12&t=53800>
      Protected line$, ret$="", LineRet$=""
      Protected.i CountString, i, start, found, length
      
      ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
      ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
      ;     text$ = ReplaceString(text$, #CR$, #LF$)
      ;     text$ + #LF$
      ;     
      ;CountString = CountString(text$, #LF$) 
      Protected *str.Character = @text$
      Protected *end.Character = @text$
      
      While *end\c 
        If *end\c = #LF
          start = (*end-*str) >> #PB_Compiler_Unicode
          line$ = PeekS (*str, start)
          ; Debug ""+start +" "+ Str((*end-*str)) +" "+ Str((*end-*str) / #__sOC) +" "+ #PB_Compiler_Unicode +" "+ #__sOC
          
          ;           For i = 1 To CountString
          ;       line$ = StringField(text$, i, #LF$)
          ;       start = Len(line$)
          length = start
          
          ; Get text len
          While length > 1
            If width > TextWidth(RTrim(Left(line$, length)))
              Break
            Else
              length - 1 
            EndIf
          Wend
          
          While start > length 
            For found = length To 1 Step - 1
              If FindString(" ", Mid(line$, found,1))
                start = found
                Break
              EndIf
            Next
            
            If found = 0 
              start = length
            EndIf
            
            ; LineRet$ + Left(line$, start) + nl$
            ret$ + Left(line$, start) + nl$
            line$ = LTrim(Mid(line$, start+1))
            start = Len(line$)
            
            If length <> start
              length = start
              
              ; Get text len
              While length > 1
                If width > TextWidth(RTrim(Left(line$, length)))
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          Wend
          
          ret$ + line$ + nl$
          ;         ret$ +  LineRet$ + line$ + nl$
          ;         LineRet$=""
          *str = *end + #__sOC 
        EndIf 
        
        *end + #__sOC 
        
        ;     Next
      Wend
      
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndProcedure
    
    Procedure.i make_text_multiline(*this._s_widget)
      ;*this\text\string.s = make_multiline(*this, *this\text\string.s+#LF$) : ProcedureReturn
      
      Static string_out.s
      Protected Repaint, String.s, text_width, len, text.s
      Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
      
      With *this
        Protected *str.Character = @text
        Protected *end.Character = @text
        
        Protected _x_=*this\x[#__c_2] + *this\text\x, 
                  _y_=*this\y[#__c_2] + *this\text\y, 
                  _width_, _height_, _this_y_
        
        
        If \vertical
          If *this\scroll\h And Not *this\scroll\h\hide
            width = \height - \bs*2 - \text\_padding*2 - \text\y*2 - *this\scroll\h\height
          Else
            width = \height - \bs*2 - \text\_padding*2 - \text\y*2
          EndIf
          
          Height = \width - \bs*2 
        Else
          If *this\scroll\v And Not *this\scroll\v\hide
            width = \width - \bs*2 - \text\_padding*2 - \text\x*2 - *this\scroll\v\width - 10
          Else
            width = \width - \bs*2 - \text\_padding*2 - \text\x*2
          EndIf
          
          height = \height - \bs*2
        EndIf
        
        \text\pos = 0
        
        If \text\multiline
          text = text_wrap_(*this\text\string+#LF$, width, \text\multiline)
          *str.Character = @text
          *end.Character = @text
          
          ; Scroll hight reset 
          \count\items = 0
          \scroll\width = \text\x*2
          \scroll\height = \text\y*2
          
          While *end\c 
            If *end\c = #LF 
              len = (*end-*str)>>#PB_Compiler_Unicode
              String = PeekS (*str, len)
              
              If \text\multiline > 0
                _make_scroll_width_(*this, TextWidth(String))
              ElseIf \text\multiline < 0
                _make_scroll_width_(*this, Width)
              EndIf
              
              _make_scroll_height_(*this, TextHeight("A"))
              
              *str = *end + #__sOC 
              \count\items + 1
            EndIf 
            
            *end + #__sOC 
          Wend
          
        Else
          text = *this\text\string + #LF$
          \count\items = 1
          \scroll\width = \text\x*2
          \scroll\height = \text\y*2 ; 0
          _make_scroll_width_(*this, TextWidth(text))
          _make_scroll_height_(*this, *this\text\height)
        EndIf
        
        
        _make_scroll_x_(*this)
        _make_scroll_y_(*this)
        
        _width_ = (*this\scroll\width - *this\text\x*2)
        _height_ = (*this\scroll\height - *this\text\y*2)
        
        
        If string_out <> text+Str(*this) 
          string_out = text+Str(*this) 
          *str.Character = @text
          *end.Character = @text
          
          \text\len = Len(\text\string.s)
          ;\count\items = CountString(text, #LF$)
          
          If Not \row\margin\hide
            \row\margin\width = TextWidth(Str(\count\items))+11
            \scroll\align\left = \row\margin\width
          EndIf
          
          Protected time = ElapsedMilliseconds()
          
          If \text\count <> \count\items 
            
            ClearList(\row\_s())
            Debug  "---- ClearList ----"
            
            While *end\c 
              If *end\c = #LF 
                len = (*end-*str)/#__sOC
                String = PeekS (*str, len)
                
                ; ;           If CreateRegularExpression(0, ~".*\n?") : If ExamineRegularExpression(0, string_out) : While NextRegularExpressionMatch(0) : String.s = Trim(RegularExpressionMatchString(0), #LF$) : len = Len(string.s)
                If AddElement(\row\_s())
                  \row\_s()\draw = 1
                  \row\_s()\y = _y_ + _this_y_
                  \row\_s()\height = \text\height
                  *this\row\_s()\text\height = \text\height
                  
                  \row\_s()\text\string.s = String.s
                  \row\_s()\index = ListIndex(\row\_s())
                  \row\_s()\text\width = TextWidth(String.s)
                  
                  \row\_s()\color = _get_colors_()
                  \row\_s()\color\fore[0] = 0
                  \row\_s()\color\fore[1] = 0
                  \row\_s()\color\fore[2] = 0
                  \row\_s()\color\fore[3] = 0
                  \row\_s()\color\back[0] = 0
                  \row\_s()\color\frame[0] = 0
                  
                  ; set entered color
                  If *this\row\_s()\index = *this\index[#__c_1]
                    *this\row\_s()\color\state = 1
                  EndIf
                  
                  ; Update line pos in the text
                  _make_line_pos_(*this, len)
                  _make_line_x_(*this, _width_)
                  _make_line_y_(*this, _height_)
                  
                  ; Margin 
                  *this\row\_s()\margin\string = Str(\row\_s()\index)
                  
                  If \vertical
                    *this\row\_s()\margin\x = \row\_s()\text\y
                    *this\row\_s()\margin\y = *this\y[#__c_2] + *this\row\margin\width - TextWidth(*this\row\_s()\margin\string) - 3
                  Else
                    *this\row\_s()\margin\y = \row\_s()\text\y
                    *this\row\_s()\margin\x = *this\x[#__c_2] + *this\row\margin\width - TextWidth(*this\row\_s()\margin\string) - 3
                  EndIf
                  
                  ;
                  _edit_sel_update_(*this)
                  
                  _this_y_ + *this\text\height + *this\flag\gridlines
                  
                EndIf
                
                ; ;               Wend : EndIf : FreeRegularExpression(0) : Else : Debug RegularExpressionError() : EndIf
                *str = *end + #__sOC 
              EndIf 
              *end + #__sOC 
            Wend
            
            \text\count = \count\items
            
            If \flag\gridlines
              \scroll\height - \flag\gridlines
            EndIf
            
            
          Else
            While *end\c 
              If *end\c = #LF 
                len = (*end-*str)/#__sOC
                String = PeekS (*str, len)
                
                If SelectElement(\row\_s(), IT)
                  If \row\_s()\text\string.s <> String.s Or \row\_s()\text\change
                    \row\_s()\text\string.s = String.s
                    \row\_s()\text\width = TextWidth(String.s)
                  EndIf
                  
                  ; Update line pos in the text
                  _make_line_pos_(*this, len)
                  
                  _make_line_x_(*this, _width_)
                  
                  ; Set scroll width length
                  ;_make_scroll_width_(*this, \row\_s()\text\width)
                  
                  ;
                  _edit_sel_update_(*this)
                EndIf
                
                IT+1
                *str = *end + #__sOC 
              EndIf 
              *end + #__sOC 
            Wend
          EndIf
          
          ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
          If ElapsedMilliseconds()-time > 0
            Debug Str(ElapsedMilliseconds()-time) + " text parse time " + Str(Bool(\text\count = \count\items))
          EndIf
          
        Else
          ; Scroll hight reset 
          If \count\items = 0
            \scroll\width = 0
          Else
            \scroll\height = 0
          EndIf
          Debug  "---- updatelist ----"
          
          ForEach \row\_s()
            If Not \row\_s()\hide
              If \count\items = 0
                \row\_s()\text\width = TextWidth(\row\_s()\text\string)
                
                ; Scroll width length
                _make_scroll_width_(*this, \row\_s()\text\width)
              Else
                ; Scroll hight length
                _make_scroll_height_(*this, \row\_s()\text\height)
              EndIf
            EndIf
          Next
          
          ForEach \row\_s()
            If Not \row\_s()\hide
              _make_line_x_(*this, _width_)
              
              If \count\items = 0
                _edit_sel_update_(*this)
              Else
                _make_line_y_(*this, _height_)
              EndIf
              
            EndIf
          Next
        EndIf
        
        
        
        If *this\scroll And 
           (*this\text\change Or (*this\resize And *this\text\multiline =- 1))
          
          If *this\scroll\v
            If *this\scroll\v\bar\min <> -*this\scroll\y
              Bar_SetAttribute(*this\scroll\v, #__bar_minimum, -*this\scroll\y)
            EndIf
            
            If *this\scroll\v\bar\max <> *this\scroll\height 
              Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *this\scroll\height)
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_y_(*this)
            EndIf
          EndIf
          
          If *this\scroll\h
            If *this\scroll\h\bar\min <> -*this\scroll\x
              Bar_SetAttribute(*this\scroll\h, #__bar_minimum, -*this\scroll\x)
            EndIf
            
            If *this\scroll\h\bar\max <> *this\scroll\width 
              Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *this\scroll\width)
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_x_(*this)
            EndIf
          EndIf
          
          If _bar_scrollarea_update_(*this)
            \height[#__c_2] = \scroll\v\bar\page\len
            \width[#__c_2] = \scroll\h\bar\page\len 
          EndIf
        EndIf 
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;-
    Procedure   Editor_Draw(*this._s_widget)
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT,Text_Y,Text_X, X,Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           DrawingMode(#PB_2DDrawing_Gradient)
          ;           _box_gradient_(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
          ;         Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\back[\color\state])
          ;         EndIf
          
          ;
          If \text\fontID 
            DrawingFont(\text\fontID) 
          EndIf
          
          ; Then changed text
          If \text\change
            \text\height = TextHeight("A")
            \text\width = TextWidth(\text\string.s)
          EndIf
          
          If \text\change
            Post(#PB_EventType_Change, *this)
          EndIf
          
          ; Make output multi line text
          If (\text\change Or (\resize And \text\multiline =- 1))
            make_text_multiline(*this)
          EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If (\text\change Or \resize)
              \row\margin\x = \x[#__c_2]
              \row\margin\y = \y[#__c_2]
              \row\margin\height = \height[#__c_2]
            EndIf
            
            ; Draw margin
            DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
            Box(\row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back)
          EndIf
          
          ; Widget inner coordinate
          iX=\x[#__c_2] + \row\margin\width 
          iY=\y[#__c_2]
          iwidth = \width[#__c_2]
          iheight = \height[#__c_2]
          
          ; Draw Lines text
          If \count\items And \scroll\v And \scroll\h
            PushListPosition(\row\_s())
            ForEach \row\_s()
              ; Is visible lines ---
              \row\_s()\draw = Bool(Not \row\_s()\hide And 
                                    \row\_s()\y+\row\_s()\height+*this\scroll\y>*this\y[#__c_2] And 
                                    (\row\_s()\y-*this\y[#__c_2])+*this\scroll\y<*this\height[#__c_2])
              
              ; Draw selections
              If *this\row\_s()\draw 
                ;               If (*this\text\change Or *this\resize)
                ;                 *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\scroll\x
                ;                 *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\scroll\y
                ;               EndIf
                
                Y = *this\row\_s()\y + *this\scroll\y
                Text_X = *this\row\_s()\text\x + *this\scroll\x
                Text_Y = *this\row\_s()\text\y + *this\scroll\y
                
                Protected text_x_sel = \row\_s()\text\edit[2]\x + *this\scroll\x
                Protected sel_x = \x[#__c_2] + *this\text\y
                Protected sel_width = \width[#__c_2] - *this\text\y*2
                Protected text_sel_state = 2 + Bool(GetActive()\gadget <> *this)
                Protected text_sel_width = \row\_s()\text\edit[2]\width + Bool(GetActive()\gadget <> *this) * *this\text\caret\width
                Protected text_state = *this\row\_s()\color\state
                
                text_state = Bool(*this\row\_s()\index = *this\index[#__c_1]) + Bool(*this\row\_s()\index = *this\index[#__c_1] And GetActive()\gadget <> *this)*2
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный фон отличный от заднего фона едитора
                  If *this\row\_s()\color\Back  
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[0] )
                    
                    If *this\color\Back And 
                       *this\color\Back <> *this\row\_s()\color\Back
                      ; Draw margin back color
                      If *this\row\margin\width > 0
                        ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(*this\row\margin\x, *this\row\_s()\y, *this\row\margin\width, *this\row\_s()\height, *this\row\margin\color\back)
                        Line(*this\x[#__c_2]+*this\row\margin\width, *this\row\_s()\y, 1, *this\row\_s()\height, *this\color\Back) ; $FF000000);
                      EndIf
                    EndIf
                  EndIf
                  
                  ; Draw entered selection
                  ; GetActive()\gadget = *this
                  If text_state ; *this\row\_s()\index = *this\index[1] ; \color\state;
                    If *this\row\_s()\color\back[text_state]<>-1              ; no draw transparent
                                                                              ;                     If *this\row\_s()\color\fore[text_state]
                                                                              ;                       DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                                                                              ;                       _box_gradient_(*this\vertical,sel_x,Y,sel_width, *this\row\_s()\height, *this\row\_s()\color\fore[text_state], *this\row\_s()\color\back[text_state], *this\row\_s()\round)
                                                                              ;                     Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[text_state] )
                      ;                     EndIf
                    EndIf
                    
                    If *this\row\_s()\color\frame[text_state]<>-1 ; no draw transparent
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\frame[text_state] )
                    EndIf
                  EndIf
                EndIf
                
                ; Draw text
                ; Draw string
                If *this\text\editable And *this\row\_s()\text\edit[2]\width And *this\color\front <> *this\row\_s()\color\front[2]
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    ; to right
                    If (*this\index[#__c_1] > *this\index[#__c_2] Or 
                        (*this\index[#__c_1] = *this\index[#__c_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                      
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                      
                      ;                     If *this\row\_s()\color\fore[2]
                      ;                       DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      ;                       _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                      ;                     Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                      ;                     EndIf
                      
                      If \row\_s()\text\edit[2]\string.s
                        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                        DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                      EndIf
                      
                    Else
                      ;                     If *this\row\_s()\color\fore[2]
                      ;                       DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      ;                       _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height,*this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                      ;                     Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state] )
                      ;                     EndIf
                      
                      If \row\_s()\text\edit[3]\string.s
                        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                        DrawRotatedText(\row\_s()\text\edit[3]\x + *this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                      EndIf
                      
                      If \row\_s()\text\edit[2]\string.s
                        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                        DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s+\row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                      EndIf
                      
                      If \row\_s()\text\edit[1]\string.s
                        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                        DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                      EndIf
                    EndIf
                    
                  CompilerElse
                    ;                   If *this\row\_s()\color\fore[2]
                    ;                     DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    ;                     _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                    ;                   Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                    ;                   EndIf
                    
                    DrawingMode(#PB_2DDrawing_Transparent)
                    
                    If \row\_s()\text\edit[1]\string.s
                      DrawRotatedText(\row\_s()\text\edit[1]\x + *this\scroll\x, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    If \row\_s()\text\edit[2]\string.s
                      DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    If \row\_s()\text\edit[3]\string.s
                      DrawRotatedText(\row\_s()\text\edit[3]\x + *this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                  CompilerEndIf
                  
                Else
                  If *this\row\_s()\text\edit[2]\width
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(text_x_sel, Y, text_sel_width, *this\row\_s()\height, $FFFBD9B7);*this\row\_s()\color\back[2])
                  EndIf
                  
                  If *this\color\state = 2
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                EndIf
                
                ; Draw margin text
                If *this\row\margin\width > 0
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(*this\row\_s()\margin\x+Bool(*this\vertical) * *this\scroll\x, *this\row\_s()\margin\y+Bool(Not *this\vertical) * *this\scroll\y, *this\row\_s()\margin\string, *this\text\rotate, *this\row\margin\color\front)
                EndIf
                
                ; Horizontal line
                If *this\flag\GridLines And *this\row\_s()\color\line And *this\row\_s()\color\line <> *this\row\_s()\color\back : DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*this\row\_s()\x, (*this\row\_s()\y+*this\row\_s()\height+Bool(*this\flag\gridlines>1))+*this\scroll\y, *this\row\_s()\width, 1, *this\color\line)
                EndIf
              EndIf
            Next
            PopListPosition(*this\row\_s()) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And GetActive()\gadget = *this ; *this\color\state
            DrawingMode(#PB_2DDrawing_XOr)             
            Box(*this\text\caret\x + *this\scroll\x, *this\text\caret\y+*this\scroll\y, *this\text\caret\width, *this\text\caret\height, $FFFFFFFF)
          EndIf
          
          ; Draw frames
          If *this\notify
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round, $FF0000FF)
            If \round : RoundBox(\x[#__c_1],\y[#__c_1]-1,\width[#__c_1],\height[#__c_1]+2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
          ElseIf *this\bs
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\frame[\color\state])
            If \round : RoundBox(\x[#__c_1],\y[#__c_1]-1,\width[#__c_1],\height[#__c_1]+2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
          EndIf
          
          ; Draw scroll bars
          Area_Draw(*this)
          
          If \text\change : \text\change = 0 : EndIf
          If \resize : \resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure   Editor_SetItemState(*this._s_widget, Item.l, State.i)
      Protected Result
      
      With *this
        If state < 0 Or 
           state > *this\text\len
          state = *this\text\len
        EndIf
        
        ;       If *this\text\caret\pos <> State
        ;         *this\text\caret\pos = State
        If *this\text\caret\pos <> State
          Protected i.l, len.l
          Protected *str.Character = @\text\string 
          Protected *end.Character = @\text\string 
          
          While *end\c 
            If *end\c = #LF 
              i + 1
              len + (*end-*str)/#__sOC
              ; Debug ""+Item+" "+Str(len + Item) +" "+ state
              
              If i = Item 
                *this\index[#__c_1] = Item
                *this\index[#__c_2] = Item
                
                *this\text\caret\pos = state + len + Item
                *this\text\caret\pos[1] = state
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__c_1] <> Item 
            *this\index[#__c_1] = Item
            *this\index[#__c_2] = Item
            
            *this\text\caret\pos = state + len + Item
            *this\text\caret\pos[1] = state
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          
        EndIf
        
        ; ;       PushListPosition(\row\_s())
        ; ;       Result = SelectElement(\row\_s(), Item) 
        ; ;       
        ; ;       If Result 
        ; ;         \index[1] = \row\_s()\index
        ; ;         \index[2] = \row\_s()\index
        ; ;         \row\index = \row\_s()\index
        ; ;        ; \text\caret\pos[1] = State
        ; ;        ; \text\caret\pos[2] = \text\caret\pos[1] 
        ; ;       EndIf
        ; ;       PopListPosition(\row\_s())
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   Editor_AddItem(*this._s_widget, Item.l,Text.s,Image.i=-1,Flag.i=0)
      Static len.l
      Protected l.l, i.l
      
      If *this
        With *this  
          Protected string.s = \text\string + #LF$
          
          If Item > \count\items - 1
            Item = \count\items - 1
          EndIf
          
          If (Item > 0 And Item < \count\items - 1)
            Define *str.Character = @string 
            Define *end.Character = @string 
            len = 0
            
            While *end\c 
              If *end\c = #LF 
                
                If item = i 
                  len + Item
                  Break 
                Else
                  ;Debug ""+ PeekS (*str, (*end-*str)/#__sOC) +" "+ Str((*end-*str)/#__sOC)
                  len + (*end-*str)/#__sOC
                EndIf
                
                i+1
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
          EndIf
          
          \text\string = Trim(InsertString(string, Text.s+#LF$, len+1), #LF$)
          
          l = Len(Text.s) + 1
          \text\change = 1
          \text\len + l 
          Len + l
          
          ;_repaint_items_(*this)
          \count\items + 1
          
        EndWith
      EndIf
      
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure   Editor_Events_Key(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Static _caret_last_pos_, DoubleClick.i
      Protected Repaint.i, _key_control_.i, _key_shift_.i, Caret.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\row\_s()\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
      
      With *this
        _key_shift_ = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          _key_control_ = Bool((\root\keyboard\key[1] & #PB_Canvas_Control) Or (\root\keyboard\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
        CompilerElse
          _key_control_ = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
        CompilerEndIf
        
        Select EventType
          Case #__Event_Input ; - Input (key)
            If Not _key_control_   ; And Not _key_shift_
              If Not *this\notify And *this\root\keyboard\input
                
                Repaint = _text_insert_(*this, Chr(*this\root\keyboard\input))
                
              EndIf
            EndIf
            
          Case #__Event_KeyUp
            ; Чтобы перерисовать 
            ; рамку вокруг едитора 
            ; reset all errors
            If \notify 
              \notify = 0
              ProcedureReturn - 1
            EndIf
            
          Case #__Event_KeyDown
            Select *this\root\keyboard\key
              Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
                If _key_control_ : *this\index[#__c_2] = 0 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
                If _key_control_ : *this\index[#__c_2] = *this\count\items - 1 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_PageUp   ;: Repaint = ToPos(*this, 1, 1)
                
              Case #PB_Shortcut_PageDown ;: Repaint = ToPos(*this, - 1, 1)
                
              Case #PB_Shortcut_A        ; Ok
                If _key_control_ And
                   \text\edit[2]\len <> \text\len
                  
                  ; set caret to begin
                  \text\caret\pos[2] = 0 
                  \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                  
                  ; select first item
                  \index[#__c_2] = 0 
                  \index[#__c_1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                  
                  Repaint = _edit_sel_draw_(*this, \count\items - 1, \text\len)
                EndIf
                
              Case #PB_Shortcut_Up       ; Ok
                If *this\index[#__c_1] > _line_first_
                  If _caret_last_pos_
                    If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, 0, 0)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__c_1] - _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_min_ 
                      *this\text\caret\pos[2] = _caret_min_
                    Else
                      *this\index[#__c_2] - _step_ 
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__c_2] = 0
                      *this\text\caret\pos[2] = 0
                    Else
                      *this\index[#__c_2] - _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])
                  EndIf
                ElseIf *this\index[#__c_1] = _line_first_
                  
                  If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                If *this\index[#__c_1] < _line_last_
                  If _caret_last_pos_
                    If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt And Not _key_control_
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, \count\items - 1, *this\text\len)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__c_1] + _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_max_ 
                      *this\text\caret\pos[2] = _caret_max_
                    Else
                      *this\index[#__c_2] + _step_ 
                      
                      If SelectElement(*this\row\_s(), *this\index[#__c_2]) 
                        _caret_max_ = *this\row\_s()\text\len
                        
                        If *this\text\caret\pos[1] <> _caret_max_
                          *this\text\caret\pos[2] = _caret_max_
                          
                          Debug ""+#PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__c_2] = \count\items - 1
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      *this\index[#__c_2] + _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                  EndIf
                ElseIf *this\index[#__c_1] = _line_last_
                  
                  If *this\row\_s()\index <> _line_last_ And
                     SelectElement(*this\row\_s(), _line_last_) 
                    _caret_max_ = *this\row\_s()\text\len
                    Debug ""+#PB_Compiler_Procedure + "*this\row\_s()\index <> _line_last_"
                  EndIf
                  
                  If *this\text\caret\pos[1] <> _caret_max_ : *this\text\caret\pos[2] = _caret_max_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Left     ; Ok
                If _key_shift_        
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], 0)  
                  Else
                    _line_ = *this\index[#__c_1] - Bool(*this\index[#__c_1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_) * _step_
                    
                    ; коректируем позицию коректора
                    If *this\row\_s()\index <> _line_ And
                       SelectElement(*this\row\_s(), _line_) 
                    EndIf
                    If *this\text\caret\pos[1] > *this\row\_s()\text\len
                      *this\text\caret\pos[1] = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\index[#__c_1] <> _line_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\row\_s()\text\len)  
                    ElseIf *this\text\caret\pos[1] > _caret_min_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] - _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__c_1] > _line_first_
                  If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_start_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = 0
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] - _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] - _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_min_
                        *this\index[#__c_2] - _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__c_2]) 
                          *this\text\caret\pos[1] = *this\row\_s()\text\len
                          *this\text\caret\pos[2] = *this\row\_s()\text\len
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__c_1] = _line_first_
                  
                  If *this\text\caret\pos[1] > _caret_min_ 
                    *this\text\caret\pos[2] - _step_
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Right    ; Ok
                If _key_shift_       
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\len)  
                  Else
                    If *this\row\_s()\index <> *this\index[#__c_1] And
                       SelectElement(*this\row\_s(), *this\index[#__c_1]) 
                      _caret_max_ = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\text\caret\pos[1] > _caret_max_
                      *this\text\caret\pos[1] = _caret_max_
                    EndIf
                    
                    _line_ = *this\index[#__c_1] + Bool(*this\index[#__c_1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_) * _step_
                    
                    ; если дошли в конец строки,
                    ; то переходим в начало
                    If *this\index[#__c_1] <> _line_ 
                      Repaint = _edit_sel_draw_(*this, _line_, 0)  
                    ElseIf *this\text\caret\pos[1] < _caret_max_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] + _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__c_1] < _line_last_
                  If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_stop_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] + _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] + _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_max_
                        *this\index[#__c_2] + _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__c_2]) 
                          *this\text\caret\pos[1] = 0
                          *this\text\caret\pos[2] = 0
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__c_1] = _line_last_
                  
                  If *this\text\caret\pos[1] < _caret_max_ 
                    *this\text\caret\pos[2] + _step_
                    
                    
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
                ; - backup  
              Case #PB_Shortcut_Back   
                If Not \notify
                  
                  If Not _text_paste_(*this)
                    If \row\_s()\text\edit[2]\len
                      
                      If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
                      \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
                      
                      \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      
                      \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                      
                    ElseIf \text\caret\pos[2] > 0 : \text\caret\pos[1] - 1 
                      \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                      \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                      
                      \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      
                      \text\string.s = Left(\text\string.s, \row\_s()\text\pos+\text\caret\pos[1] ) + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                    Else
                      ; Если дошли до начала строки то 
                      ; переходим в конец предыдущего итема
                      If \index[#__c_1] > _line_first_ 
                        \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos+\text\caret\pos[1], 1)
                        
                        ;to up
                        \index[#__c_1] - 1
                        \index[#__c_2] - 1
                        
                        If *this\row\_s()\index <> \index[#__c_2] And
                           SelectElement(*this\row\_s(), \index[#__c_2]) 
                        EndIf
                        ;: _edit_sel_draw_(*this, \index[2], \text\len)
                        
                        \text\caret\pos[1] = \row\_s()\text\len
                        \text\change =- 1 ; - 1 post event change widget
                        
                      Else
                        \notify = 2
                        ProcedureReturn - 1
                      EndIf
                      
                    EndIf
                  EndIf
                  
                  If \text\change
                    \text\caret\pos[2] = \text\caret\pos[1] 
                    Repaint =- 1 
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Delete
                If Not _text_paste_(*this) And 
                   (\text\caret\pos[2] < \text\len Or \row\_s()\text\edit[2]\len)
                  
                  If \row\_s()\text\edit[2]\len 
                    If \text\caret\pos[1] > \text\caret\pos[2] 
                      \text\caret\pos[1] = \text\caret\pos[2] 
                    Else
                      \text\caret\pos[2] = \text\caret\pos[1] 
                    EndIf
                    
                    \row\_s()\text\edit[2]\pos = 0 
                    \row\_s()\text\edit[2]\len = 0 
                    \row\_s()\text\edit[2]\width = 0 
                    \row\_s()\text\edit[2]\string.s = "" 
                    \row\_s()\text\edit[2]\change = 1
                    
                  Else
                    \row\_s()\text\edit[3]\string.s = Right(\row\_s()\text\string.s, \row\_s()\text\len - \text\caret\pos[1] - 1)
                    \row\_s()\text\edit[3]\len = Len(\row\_s()\text\edit[3]\string.s) : \row\_s()\text\edit[3]\change = 1
                    
                    \text\edit[3]\string = Right(\text\string.s, \text\len - (\row\_s()\text\pos + \text\caret\pos[1] ) - 1)
                    \text\edit[3]\len = Len(\text\edit[3]\string.s)
                    \text\caret\pos[2] = \text\caret\pos[1] 
                  EndIf
                  
                  \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                  \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                  
                  \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                  \text\change =- 1 
                  Repaint =- 1 
                EndIf
                
                ; - return
              Case #PB_Shortcut_Return 
                If *this\text\multiline
                  If Not _text_paste_(*this, #LF$)
                    *this\index[#__c_2] + 1
                    *this\index[#__c_1] = *this\index[#__c_2]
                    *this\text\caret\pos[2] = 0
                    *this\text\caret\pos[1] = 0
                    *this\text\change =- 1 ; - 1 post event change widget
                  EndIf
                  
                  If *this\text\change 
                    Repaint = 1
                  EndIf
                Else
                  *this\notify = 3
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_C, #PB_Shortcut_X
                If _key_control_
                  SetClipboardText(*this\text\edit[2]\string)
                  
                  If *this\root\keyboard\key = #PB_Shortcut_X
                    Repaint = _text_paste_(*this)
                  EndIf
                EndIf
                
              Case #PB_Shortcut_V
                If _key_control_ And *this\text\editable
                  Protected text.s = GetClipboardText()
                  
                  If Not *this\text\multiLine
                    text = ReplaceString(text, #LFCR$, #LF$)
                    text = ReplaceString(text, #CRLF$, #LF$)
                    text = ReplaceString(text, #CR$, #LF$)
                    text = RemoveString(text, #LF$)
                  EndIf
                  
                  Repaint = _text_insert_(*this, text)
                EndIf  
                
            EndSelect 
            
            Select *this\root\keyboard\key
              Case #PB_Shortcut_Home,
                   #PB_Shortcut_End,
                   #PB_Shortcut_PageUp, 
                   #PB_Shortcut_PageDown,
                   #PB_Shortcut_Up,
                   #PB_Shortcut_Down,
                   #PB_Shortcut_Left,
                   #PB_Shortcut_Right,
                   #PB_Shortcut_Delete,
                   #PB_Shortcut_Return ;, #PB_Shortcut_Back
                
                If Not Repaint
                  *this\notify =- 1
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_A,
                   #PB_Shortcut_C,
                   #PB_Shortcut_X, 
                   #PB_Shortcut_V
                
            EndSelect
            
        EndSelect
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   _Editor_Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l)
      Static DoubleClick.i=-1
      Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
      
      With *this
        ;If \text\editable  
        
        ;Debug *this\scroll\v\bar\state
        If *this And *this\scroll\v\bar\state =- 1 And *this\scroll\h\bar\state =- 1
          If ListSize(*this\row\_s())
            If Not \hide ;And \interact
                         ; Get line position
                         ;If \root\mouse\buttons ; сним двойной клик не работает
              If \scroll\v And (\root\mouse\y-\y[#__c_2]-\text\y+\scroll\v\bar\page\pos) > 0
                _line_ = ((\root\mouse\y-\y[#__c_2]-\text\y-\scroll\y) / (\text\height + \flag\gridlines))
                ;  _line_ = ((\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos) / (\text\height + \flag\gridlines))
              Else
                _line_ =- 1
              EndIf
              ;EndIf
              ;Debug  _line_; (\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos)
              
              Select event_type 
                Case #__Event_LeftDoubleClick 
                  ; bug pb
                  ; в мак ос в editorgadget ошибка
                  ; при двойном клике на слове выделяет правильно 
                  ; но стирает вместе с предшествующим пробелом
                  ; в окнах выделяет уще и пробелл но стирает то что выделено
                  
                  ; Событие двойной клик происходит по разному
                  ; - mac os -
                  ; LeftButtonDown 
                  ; LeftButtonUp 
                  ; LeftClick 
                  ; LeftDoubleClick 
                  
                  ; - windows & linux -
                  ; LeftButtonDown
                  ; LeftDoubleClick
                  ; LeftButtonUp
                  ; LeftClick
                  
                  *this\index[#__c_2] = _line_
                  
                  Caret = _edit_sel_stop_(*this)
                  *this\text\caret\time = ElapsedMilliseconds()
                  *this\text\caret\pos[2] = _edit_sel_start_(*this)
                  Repaint = _edit_sel_draw_(*this, *this\index[#__c_2], Caret)
                  *this\row\selected = \row\_s() ; *this\index[2]
                  
                Case #__Event_LeftButtonDown
                  
                  If _is_item_(*this, _line_) And 
                     _line_ <> \row\_s()\index  
                    \row\_s()\color\State = 0
                    SelectElement(*this\row\_s(), _line_) 
                  EndIf
                  
                  If _line_ = \row\_s()\index
                    \row\_s()\color\State = 1
                    
                    If *this\row\selected And 
                       *this\row\selected = \row\_s() And
                       (ElapsedMilliseconds() - *this\text\caret\time) < 500
                      
                      *this\text\caret\pos[2] = 0
                      *this\row\box\checked = #False
                      *this\row\selected = #Null
                      *this\index[#__c_1] = _line_
                      *this\text\caret\pos[1] = \row\_s()\text\len ; Чтобы не прокручивало в конец строки
                      Repaint = _edit_sel_draw_(*this, _line_, \row\_s()\text\len)
                      
                    Else
                      _start_drawing_(*this)
                      *this\row\selected = \row\_s()
                      
                      If *this\text\editable And _edit_sel_is_line_(*this)
                        ; Отмечаем что кликнули
                        ; по выделеному тексту
                        *this\row\box\checked = 1
                        
                        Debug "sel - "+\row\_s()\text\edit[2]\width
                        SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                      Else
                        ; reset items selection
                        PushListPosition(*this\row\_s())
                        ForEach *this\row\_s()
                          If *this\row\_s()\text\edit[2]\width <> 0 
                            _edit_sel_reset_(*this\row\_s())
                          EndIf
                        Next
                        PopListPosition(*this\row\_s())
                        
                        Caret = _text_caret_(*this)
                        
                        \index[#__c_2] = \row\_s()\index 
                        
                        
                        If *this\text\caret\pos[1] <> Caret
                          *this\text\caret\pos[1] = Caret
                          *this\text\caret\pos[2] = Caret 
                          Repaint =- 1
                        EndIf
                        
                        If *this\index[#__c_1] <> _line_ 
                          *this\index[#__c_1] = _line_
                          Repaint = 1
                        EndIf
                        
                        If Repaint
                          Repaint = Bool(_edit_sel_set_(*this, _line_, Repaint))
                        EndIf
                      EndIf
                      
                      StopDrawing() 
                    EndIf
                  EndIf
                  
                  
                Case #__Event_MouseMove  
                  If \root\mouse\buttons & #PB_Canvas_LeftButton 
                    Repaint = _edit_sel_draw_(*this, _line_)
                  EndIf
                  
                Case #__Event_LeftButtonUp  
                  If *this\text\editable And *this\row\box\checked
                    ;                   
                    ;                   If _line_ >= 0 And 
                    ;                      _line_ < \count\items And 
                    ;                      _line_ <> \row\_s()\index And 
                    ;                      SelectElement(\row\_s(), _line_) 
                    ;                   EndIf
                    ;                    
                    _start_drawing_(*this)
                    
                    ; на одной линии работает
                    ; теперь надо сделать чтоб и на другие линии можно было бросать
                    If *this\text\caret\pos[2] = *this\text\caret\pos[1] 
                      
                      ; Если бросили на правую сторону от выделеного текста.
                      If *this\index[#__c_2] = *this\index[#__c_1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[2] - *this\row\selected\text\edit[2]\len
                      EndIf
                      ; Debug ""+*this\text\caret\pos[2] +" "+ *this\row\selected\text\edit[2]\pos
                      
                      *this\row\selected\text\string = RemoveString(*this\row\selected\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\edit[2]\pos, 1)
                      *this\text\string = RemoveString(*this\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\pos+*this\row\selected\text\edit[2]\pos, 1)
                      
                      *this\row\_s()\text\string = InsertString(*this\row\_s()\text\string, *this\row\selected\text\edit[2]\string, *this\text\caret\pos[2]+1)
                      *this\text\string = InsertString(*this\text\string, *this\row\selected\text\edit[2]\string, *this\row\_s()\text\pos+*this\text\caret\pos[2]+1)
                      
                      
                      ;                       \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                      ;                     \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                      ;                     
                      ;                     \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      ;                     \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      ;                     
                      ;                     \text\string.s = Left(\text\string.s, \row\_s()\text\pos+\text\caret\pos[1] ) + \text\edit[3]\string
                      ;                     \text\change =- 1 ; - 1 post event change widget
                      
                      ;                     _text_insert_(*this, *this\row\selected\text\edit[2]\string)
                      
                      Debug *this\row\selected\index
                      ;                     *this\index[1] = *this\row\selected\index
                      ;                     *this\index[2] = *this\row\selected\index
                      ;                     Protected len = *this\row\selected\text\edit[2]\len
                      ;                     ;
                      ;                     _line_ = *this\row\selected\index
                      ;                     If _line_ >= 0 And 
                      ;                      _line_ < \count\items And 
                      ;                      _line_ <> \row\_s()\index And 
                      ;                      SelectElement(\row\_s(), _line_) 
                      ;                   EndIf
                      ;                           
                      Debug *this\row\selected\text\string
                      
                      If *this\index[#__c_2] <> *this\index[#__c_1]
                        ; *this\text\change =- 1
                        _edit_sel_reset_(*this\row\selected)
                        *this\index[#__c_2] = *this\index[#__c_1]
                        
                        ;                          *this\text\change =- 1
                        ;                       make_text_multiline(*this)
                        ;                        *this\text\change = 0
                        ;                     
                      EndIf
                      
                      *this\text\caret\pos[1] = *this\row\selected\text\edit[2]\len
                      
                      ;Swap *this\text\caret\pos[1], *this\text\caret\pos[2]
                      *this\row\selected = #Null
                      
                      Repaint = _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1])
                      ;                     If *this\text\caret\pos[1] <> Caret  ; *this\text\caret\pos[2]); + *this\row\selected\text\edit[2]\len
                      ;                       *this\text\caret\pos[1] = Caret
                      ;                       Repaint =- 1
                      ;                     EndIf
                      ;                     
                      ;                     If *this\index[1] <> _line_ 
                      ;                       *this\index[1] = _line_
                      ;                       Repaint = 1
                      ;                     EndIf
                      ;Repaint = _edit_sel_set_(*this, *this\index[1], Repaint)
                      
                      SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
                    Else
                      *this\text\caret\pos[2] = _text_caret_(*this)
                      *this\row\_s()\text\edit[2]\len = 0
                      *this\index[#__c_2] = _line_
                      
                      If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[#__c_1] <> _line_ 
                        *this\index[#__c_1] = _line_
                        Repaint = 1
                      EndIf
                      
                      Repaint = _edit_sel_set_(*this, _line_, Repaint)
                    EndIf
                    
                    StopDrawing() 
                    *this\row\box\checked = #False
                    *this\row\selected = #Null
                    Repaint = 1
                  EndIf
                  
                Default
                  If _is_item_(*this, \index[#__c_2]) And 
                     \index[#__c_2] <> \row\_s()\index  
                    \row\_s()\color\State = 0
                    SelectElement(*this\row\_s(), \index[#__c_2]) 
                  EndIf
                  
              EndSelect
            EndIf
            
            ; edit events
            If *this\text\editable And GetActive()\gadget = *this
              Repaint | Editor_Events_Key(*this, event_type, \root\mouse\x, \root\mouse\y)
            EndIf
          EndIf
        EndIf
        ;EndIf
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   Editor_Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      Select event_type
        Case #PB_EventType_Focus
          Post(event_type, *this)
          Repaint = 1
          
        Case #PB_EventType_LostFocus
          Post(event_type, *this)
          Repaint = 1
          
        Default
          Repaint = _Editor_Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l)
      EndSelect
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;-
    ;- TREEs
    ;-
    Declare.l Tree_Properties_Draw(*this._s_widget)
    
    ;-
    Declare tt_close(*this._s_tt)
    
    Procedure tt_Tree_Properties_Draw(*this._s_tt, *color._s_color=0)
      With *this
        If *this And IsGadget(\gadget) And StartDrawing(CanvasOutput(\gadget))
          If Not *color
            *color = \color
          EndIf
          
          If \text\fontID 
            DrawingFont(\text\fontID) 
          EndIf 
          DrawingMode(#PB_2DDrawing_Default)
          Box(0,1,\width,\height-2, *color\back[*color\state])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(\text\x, \text\y, \text\string, *color\front[*color\state])
          DrawingMode(#PB_2DDrawing_Outlined)
          Line(0,0,\width,1, *color\frame[*color\state])
          Line(0,\height-1,\width,1, *color\frame[*color\state])
          Line(\width-1,0,1,\height, *color\frame[*color\state])
          StopDrawing()
        EndIf 
      EndWith
    EndProcedure
    
    Procedure tt_Tree_CallBack()
      ;     ;SetActiveWindow(*event\widget\root\canvas\window)
      ;     ;SetActiveGadget(*event\widget\root\canvas\gadget)
      ;     
      ;     If *event\widget\row\selected
      ;       *event\widget\row\selected\color\State = 0
      ;     EndIf
      ;     
      ;     *event\widget\row\selected = *event\widget\row\_s()
      ;     *event\widget\row\_s()\color\State = 2
      ;     *event\widget\color\State = 2
      ;     
      ;     ;Tree_ReDraw(*event\widget)
      
      tt_close(GetWindowData(EventWindow()))
    EndProcedure
    
    Procedure tt_creare(*this._s_widget, x,y)
      With *this
        If *this
          *event\widget = *this
          \row\tt = AllocateStructure(_s_tt)
          \row\tt\visible = 1
          \row\tt\x = x+\row\_s()\x+\row\_s()\width-1
          \row\tt\y = y+\row\_s()\y-\scroll\v\bar\page\pos
          
          \row\tt\width = \row\_s()\text\width-\width[#__c_2] + (\row\_s()\text\x - \row\_s()\x) + 5 ;- (\scroll\width-\width);- \row\_s()\text\x; 105 ;\row\_s()\text\width - (\scroll\width-\row\_s()\width)  ; - 32 + 5 
          
          If \row\tt\width < 6
            \row\tt\width = 0
          EndIf
          
          Debug \row\tt\width ;Str(\row\_s()\text\x - \row\_s()\x)
          
          \row\tt\height = \row\_s()\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\tt\Window = OpenWindow(#PB_Any, \row\tt\x, \row\tt\y, \row\tt\width, \row\tt\height, "", 
                                      #PB_Window_BorderLess|#PB_Window_NoActivate|flag, WindowID(\root\canvas\window))
          
          \row\tt\gadget = CanvasGadget(#PB_Any,0,0, \row\tt\width, \row\tt\height)
          \row\tt\color = \row\_s()\color
          \row\tt\text = \row\_s()\text
          \row\tt\text\fontID = \row\_s()\text\fontID
          \row\tt\text\x =- (\width[#__c_2]-(\row\_s()\text\x-\row\_s()\x)) + 1
          \row\tt\text\y = (\row\_s()\text\y-\row\_s()\y)+\scroll\v\bar\page\pos
          
          BindEvent(#PB_Event_ActivateWindow, @tt_Tree_CallBack(), \row\tt\Window)
          SetWindowData(\row\tt\Window, \row\tt)
          tt_Tree_Properties_Draw(\row\tt)
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close(*this._s_tt)
      If IsWindow(*this\window)
        *this\visible = 0
        ;UnbindEvent(#PB_Event_ActivateWindow, @tt_Tree_CallBack(), *this\window)
        CloseWindow(*this\window)
        ; ClearStructure(*this, _s_tt) ;??????
      EndIf
    EndProcedure
    
    ;-
    Macro _tree_box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _round_=2, _alpha_=255) 
      
      If _type_ = 1
        If _checked_
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          
          RoundBox(_x_,_y_,_width_,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BackColor($FFB775&$FFFFFF|255<<24) 
          FrontColor($F67905&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_+_height_))
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
          RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
        Else
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          
          RoundBox(_x_,_y_,_width_,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BackColor($FFFFFF&$FFFFFF|255<<24)
          FrontColor($EEEEEE&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_+_height_))
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
          RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
        EndIf
      Else
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        
        If _checked_
          BackColor($FFB775&$FFFFFF|255<<24) 
          FrontColor($F67905&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_+_height_))
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $F67905&$FFFFFF|255<<24)
          
          If _type_ = 1
            RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
            RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
            
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
            RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
          EndIf
          
        Else
          BackColor($FFFFFF&$FFFFFF|255<<24)
          FrontColor($EEEEEE&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_+_height_))
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $7E7E7E&$FFFFFF|255<<24)
          
          If _type_ = 1
            RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
            RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
            
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
            RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
          EndIf
        EndIf
      EndIf
      
      If _checked_
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        
        If _type_ = 1
          RoundBox(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
                                                                                               ; RoundBox(_x_+(_width_-8)/2,_y_+(_height_-8)/2, 8,8, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
        ElseIf _type_ = 3
          If _checked_ > 1
            Box(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, _color_&$FFFFFF|_alpha_<<24) ; правая линия
          Else
            If _width_ = 15
              LineXY((_x_+4),(_y_+8),(_x_+5),(_y_+9),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              LineXY((_x_+4),(_y_+9),(_x_+5),(_y_+10),_color_&$FFFFFF|_alpha_<<24); Левая линия
              
              LineXY((_x_+9),(_y_+4),(_x_+6),(_y_+10),_color_&$FFFFFF|_alpha_<<24) ; правая линия
              LineXY((_x_+10),(_y_+4),(_x_+7),(_y_+10),_color_&$FFFFFF|_alpha_<<24); правая линия
              
            Else
              LineXY((_x_+2),(_y_+6),(_x_+4),(_y_+7),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              LineXY((_x_+2),(_y_+7),(_x_+4),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              
              LineXY((_x_+8),(_y_+2),(_x_+5),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
              LineXY((_x_+9),(_y_+2),(_x_+6),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
            EndIf
          EndIf
        EndIf
      EndIf
      
    EndMacro
    
    Macro _tree_multi_select_(_this_,  _index_, _selected_index_)
      PushListPosition(_this_\row\_s()) 
      ForEach _this_\row\_s()
        If _this_\row\_s()\draw
          _this_\row\_s()\color\state =  Bool((_selected_index_ >= _this_\row\_s()\index And _index_ =< _this_\row\_s()\index) Or ; верх
                                              (_selected_index_ =< _this_\row\_s()\index And _index_ >= _this_\row\_s()\index)) * 2  ; вниз
        EndIf
      Next
      PopListPosition(_this_\row\_s()) 
      
      ;     PushListPosition(_this_\row\draws()) 
      ;     ForEach _this_\row\draws()
      ;       If _this_\row\draws()\draw
      ;         _this_\row\draws()\color\state =  Bool((_selected_index_ >= _this_\row\draws()\index And _index_ =< _this_\row\draws()\index) Or ; верх
      ;                                            (_selected_index_ =< _this_\row\draws()\index And _index_ >= _this_\row\draws()\index)) * 2  ; вниз
      ;       EndIf
      ;     Next
      ;     PopListPosition(_this_\row\draws()) 
    EndMacro
    
    Macro _tree_set_state_(_this_, _items_, _state_)
      If _this_\flag\check And _items_\parent
        If _items_\option_group\option_group <> _items_
          If _items_\option_group\option_group
            _items_\option_group\option_group\box[#__c_1]\checked = 0
          EndIf
          _items_\option_group\option_group = _items_
        EndIf
        
        _items_\box[#__c_1]\checked ! Bool(_state_)
        
      Else
        If _this_\flag\threestate
          If _state_ & #__tree_Inbetween
            _items_\box[#__c_1]\checked = 2
          ElseIf _state_ & #__tree_Checked
            _items_\box[#__c_1]\checked = 1
          Else
            Select _items_\box[#__c_1]\checked 
              Case 0
                _items_\box[#__c_1]\checked = 2
              Case 1
                _items_\box[#__c_1]\checked = 0
              Case 2
                _items_\box[#__c_1]\checked = 1
            EndSelect
          EndIf
        Else
          _items_\box[#__c_1]\checked ! Bool(_state_)
        EndIf
      EndIf
    EndMacro
    
    
    Procedure   Tree_Properties_Update(*this._s_widget, List row._s_rows())
      *this\scroll\x = 0
      *this\scroll\y = 0
      *this\scroll\width = 0
      *this\scroll\height = 0
      ClearList(*this\row\draws())
     
;       If *this\text\change
;         *this\text\height = TextHeight("A") - Bool(#PB_Compiler_OS <> #PB_OS_Windows) * 2
;        ; *this\text\width = TextWidth(*this\text\string.s)
;       EndIf
      
      PushListPosition(row())
      ForEach row()
        If row()\parent
          row()\parent\first = 0
          row()\parent\last = 0
        EndIf     
      Next
      PopListPosition(row())
     
      PushListPosition(row())
      ForEach row()
        
        If row()\hide
          row()\draw = 0
        Else
          ; 
          If row()\text\fontID
            DrawingFont(row()\text\fontID) 
            row()\text\height = TextHeight("A") ; + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2 
          Else
            If *this\text\fontID  
              DrawingFont(*this\text\fontID) 
              row()\text\fontID = *this\text\fontID 
              row()\text\height = TextHeight("A") ; + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
            EndIf
          EndIf
          
          ; Получаем один раз после изменения текста  
          If row()\text\change
            row()\text\change = #False
            row()\text\width = TextWidth(row()\text\string.s) 
          EndIf 
          
          row()\x = *this\x[#__c_2]
          row()\width = *this\width[#__c_2] 
          
          row()\height = row()\text\height + 2 ;
          row()\y = *this\y[#__c_2] + *this\scroll\height
          
          ; check box pos
          If *this\flag\check
            row()\box[#__c_1]\x = row()\x + 3 - *this\scroll\h\bar\page\pos
            row()\box[#__c_1]\y = (row()\y+row()\height)-(row()\height+row()\box[#__c_1]\height)/2-*this\scroll\v\bar\page\pos
          EndIf
          
          ; item (expanded & collapsed box) pos
          If *this\flag\buttons Or *this\flag\lines 
            row()\box[0]\x = row()\x + row()\sublevellen - *this\row\sublevellen + Bool(*this\flag\buttons) * 4 + Bool(Not *this\flag\buttons And *this\flag\lines) * 8 - *this\scroll\h\bar\page\pos 
            row()\box[0]\y = (row()\y+row()\height)-(row()\height+row()\box[0]\height)/2-*this\scroll\v\bar\page\pos
          EndIf
          
          ; item image pos
          row()\image\x = row()\x + *this\image\padding\left + row()\sublevellen - *this\scroll\h\bar\page\pos
          row()\image\y = row()\y + (row()\height-row()\image\height)/2-*this\scroll\v\bar\page\pos
          
          ; item text pos
          row()\text\x = row()\x + *this\text\padding\left + row()\sublevellen + *this\row\sublevel - *this\scroll\h\bar\page\pos
          row()\text\y = row()\y + (row()\height-row()\text\height)/2-*this\scroll\v\bar\page\pos
          
          ;
          row()\draw = Bool(row()\y+row()\height-*this\scroll\v\bar\page\pos>*this\y[#__c_2] And 
                            (row()\y-*this\y[#__c_2])-*this\scroll\v\bar\page\pos<*this\height[#__c_2])
          
          
          ; lines for tree widget
          If *this\flag\lines And *this\row\sublevellen
            
            If row()\parent
              ;*this\row\draws()\after = 
              
              ; set z-order position 
              If Not row()\parent\first 
                If Not row()\parent\last
                  ; Debug row()\index
                  row()\parent\last = row()
                EndIf
                ; Debug row()\index
                row()\parent\first = row()
              ElseIf row()\parent\last
                row()\before = row()\parent\last
                row()\before\after = row()
                
                row()\parent\last = row()
              EndIf
              
            Else
              
              ; set z-order position 
              If Not row()\before 
                If Not row()\after
                  ; Debug row()\index
                  row()\after = row()
                EndIf
                ; Debug row()\index
                row()\before = row()
              ElseIf row()\after
                row()\before = row()\after
                row()\before\after = row()
                
                row()\after = row()
              EndIf
            EndIf
       
          EndIf
          
          
          If row()\draw And 
             AddElement(*this\row\draws())
            *this\row\draws() = row()
          EndIf
          
          
          ;              ; then set tab state
          ;              If *this\bar\_s()\index = *this\bar\state[1] - 1
          ;                *this\bar\page\pos = *this\bar\_s()\y-((*this\height[#__c_2]-*this\bar\button[2]\len)-*this\bar\_s()\height) 
          ;              EndIf
          
          ; set vertical scroll max
          *this\scroll\height + row()\height + Bool(row()\index <> *this\count\items - 1) * *this\flag\GridLines
          
          ; set horizontal scroll max
          If *this\scroll\width < (*this\row\_s()\text\x+*this\row\_s()\text\width + *this\flag\fullSelection)-*this\x[#__c_2]
            *this\scroll\width = (*this\row\_s()\text\x+*this\row\_s()\text\width + *this\flag\fullSelection)-*this\x[#__c_2]
          EndIf
        EndIf
        
      Next
      PopListPosition(row())
      
      
      If *this\scroll\v\bar\max <> *this\scroll\height And
         bar_SetAttribute(*this\scroll\v, #__bar_Maximum, *this\scroll\height)
        
        Resizes(*this\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        *this\width[#__c_2] = *this\scroll\h\bar\page\len
        *this\height[#__c_2] = *this\scroll\v\bar\page\len
      EndIf
      
      If *this\scroll\h\bar\max <> *this\scroll\width And
         bar_SetAttribute(*this\scroll\h, #__bar_Maximum, *this\scroll\width)
        
        Resizes(*this\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        *this\width[#__c_2] = *this\scroll\h\bar\page\len
        *this\height[#__c_2] = *this\scroll\v\bar\page\len
      EndIf
      
      
      If *this\row\selected And *this\row\scrolled
        bar_SetState(*this\scroll\v, ((*this\row\selected\y-*this\scroll\v\y) - (Bool(*this\row\scrolled>0) * (*this\scroll\v\bar\page\len-*this\row\selected\height))) ) 
        *this\scroll\v\change = 0 
        *this\row\scrolled = 0
        
        Tree_Properties_Draw(*this)
      EndIf
      
    EndProcedure
    
    Procedure.l Tree_Properties_Draw(*this._s_widget)
      Protected Y, state.b
      
      With *this
        If Not \hide
          If \text\fontID 
            DrawingFont(\text\fontID) 
          EndIf
          
          If \change <> 0
            Tree_Properties_Update(*this, \row\_s())
            \change = 0
          EndIf 
          
          ; Draw background
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\back[\color\state])
          
          ; Draw background image
          If \image\index[2]
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\image\index[2], \image\x, \image\y, \color\alpha)
          EndIf
          
          ;         ; Draw all items
          ;_draws_(*this, \row\_s())
          ;_draws_(*this, *this\row\draws())
          
          PushListPosition(*this\row\draws())
          ForEach *this\row\draws()
            If *this\row\draws()\draw
              If *this\row\draws()\width <> *this\width[#__c_2]
                *this\row\draws()\width = *this\width[#__c_2]
              EndIf
              
              
              If *this\text\fontID <> *this\row\draws()\text\fontID
                *this\text\fontID = *this\row\draws()\text\fontID
                DrawingFont(*this\row\draws()\text\fontID) 
              EndIf
              
              
              Y = *this\row\draws()\y - *this\scroll\v\bar\page\pos
              state = *this\row\draws()\color\state  ;+ Bool(*this\row\draws()\color\state = #__s_2 And *this <> GetActive()\gadget)
              
              ; Draw select back
              If *this\row\draws()\color\back[state]
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*this\x[#__c_2],Y,*this\width[#__c_2],*this\row\draws()\height,*this\row\draws()\round,*this\row\draws()\round,*this\row\draws()\color\back[state])
              EndIf
              
              ; Draw select frame
              If *this\row\draws()\color\frame[state]
                DrawingMode(#PB_2DDrawing_Outlined)
                RoundBox(*this\x[#__c_2],Y,*this\width[#__c_2],*this\row\draws()\height,*this\row\draws()\round,*this\row\draws()\round, *this\row\draws()\color\frame[state])
              EndIf
              
              ; Draw text
              If *this\row\draws()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(*this\row\draws()\text\x, *this\row\draws()\text\y, *this\row\draws()\text\string.s, *this\text\rotate, *this\row\draws()\color\front[state])
              EndIf
            EndIf
          Next
          
          ; Draw plots
          ;If *this\flag\lines
            ForEach *this\row\draws()
              If *this\row\draws()\draw 
         
                  ; properties
              If *this\row\draws()\parent 
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                If *this\row\draws()\parent\first = *this\row\draws()
                  ; draw frme top line
                  Line(*this\row\draws()\box[0]\x, *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, (*this\x[2]+*this\width[2])-*this\row\draws()\box[0]\x, 1, $ff000000)
                  
                  ; draw left parent line back
                  Line(*this\x[2], *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, *this\row\draws()\box[0]\x-*this\x[2], 1, *this\row\draws()\parent\color\back)
                ElseIf *this\row\draws()\parent\last = *this\row\draws()
                  Line(*this\x[2], *this\row\draws()\y+*this\row\draws()\height-*this\scroll\v\bar\page\pos, *this\row\draws()\box[0]\x-*this\x[2], 1, *this\row\draws()\parent\color\back)
                  
                  ; draw frame bottom line
                  Line(*this\row\draws()\box[0]\x, *this\row\draws()\y+*this\row\draws()\height-*this\scroll\v\bar\page\pos, (*this\x[2]+*this\width[2])-*this\row\draws()\box[0]\x, 1, $ff000000)
                  
                  ; draw lines
                  Line(*this\row\draws()\box[0]\x+1, *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, (*this\x[2]+*this\width[2])-*this\row\draws()\box[0]\x-2, 1, $fff0f0f0)
                Else
                  Line(*this\row\draws()\box[0]\x+1, *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, (*this\x[2]+*this\width[2])-*this\row\draws()\box[0]\x-2, 1, $fff0f0f0)
                  
                EndIf
                
                ; draw frame left and right lines
                Line(*this\row\draws()\box[0]\x, *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, 1, *this\row\draws()\height+1, $ff000000)
                Line((*this\x[2]+*this\width[2])-1, *this\row\draws()\y-*this\scroll\v\bar\page\pos-1, 1, *this\row\draws()\height+1, $ff000000)
                
                
                ; draw left parent back
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(*this\x[2], *this\row\draws()\parent\first\y-*this\scroll\v\bar\page\pos, *this\row\draws()\box[0]\x-*this\x[2], (*this\row\draws()\parent\last\y-*this\row\draws()\parent\first\y) + *this\row\draws()\parent\last\height, *this\row\draws()\parent\color\back)
              EndIf
              
                  
; ;                 If *this\row\draws()\childrens And *this\row\draws()\first And *this\row\draws()\last
; ;                   Line(*this\x[2]+*this\row\draws()\sublevellen+4, *this\row\draws()\first\y-*this\scroll\v\bar\page\pos, 1, (*this\row\draws()\last\y-*this\row\draws()\first\y) + *this\row\draws()\last\height, $ff000000)
; ;                   Line((*this\x[2]+*this\width[2])-1, *this\row\draws()\first\y-*this\scroll\v\bar\page\pos, 1, (*this\row\draws()\last\y-*this\row\draws()\first\y) + *this\row\draws()\last\height, $ff000000)
; ;                   
; ;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
; ;                   Box(*this\x[2], *this\row\draws()\first\y-*this\scroll\v\bar\page\pos, *this\row\draws()\sublevellen+4, (*this\row\draws()\last\y-*this\row\draws()\first\y) + *this\row\draws()\last\height, *this\row\draws()\color\back)
; ;                 EndIf
                 
                
              EndIf    
            Next
          ;EndIf
          
          ; Draw arrow
          If *this\flag\buttons ;And Not *this\flag\check = 4
            ForEach *this\row\draws()
              If *this\row\draws()\draw And *this\row\draws()\childrens
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\row\draws()\box[0]\x-1, *this\row\draws()\box[0]\y-1, *this\row\draws()\box[0]\width+2, *this\row\draws()\box[0]\height+2, 2,2, $ffffffff)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\row\draws()\box[0]\x-1, *this\row\draws()\box[0]\y-1, *this\row\draws()\box[0]\width+2, *this\row\draws()\box[0]\height+2, 2,2, $ff000000)
                
                Line(*this\row\draws()\box[0]\x+2, *this\row\draws()\box[0]\y+*this\row\draws()\box[0]\height/2, *this\row\draws()\box[0]\width-4, 1, $ff000000)
                If *this\row\draws()\box[0]\checked   
                  Line(*this\row\draws()\box[0]\x+*this\row\draws()\box[0]\width/2, *this\row\draws()\box[0]\y+2, 1, *this\row\draws()\box[0]\height-4, $ff000000)
                EndIf
              EndIf    
            Next
          EndIf
          
          PopListPosition(*this\row\draws()) ; 
                                             ;         UnclipOutput()
          
          ; Draw frames
          DrawingMode(#PB_2DDrawing_Outlined)
          If \color\state
            ; RoundBox(\x[1]+Bool(\fs),\y[1]+Bool(\fs),\width[1]-Bool(\fs)*2,\height[1]-Bool(\fs)*2,\round,\round,0);\color\back)
            RoundBox(\x[#__c_2]-Bool(\fs),\y[#__c_2]-Bool(\fs),\width[#__c_2]+Bool(\fs)*2,\height[#__c_2]+Bool(\fs)*2,\round,\round,\color\back)
            RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\frame[2])
            ;           If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\frame[2]) : EndIf  ; Сглаживание краев )))
            ;           RoundBox(\x[1]-1,\y[1]-1,\width[1]+2,\height[1]+2,\round,\round,\color\frame[2])
          ElseIf \fs
            RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\round,\round,\color\frame[\color\state])
          EndIf
          
          ; Draw scroll bars
          Area_Draw(*this)
          
          If \text\change : \text\change = 0 : EndIf
          If \resize : \resize = 0 : EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.l Tree_ReDraw(*this._s_widget, canvas_backcolor=#Null)
      If *this
        With *this
          If StartDrawing(CanvasOutput(\root\canvas\gadget))
            If canvas_backcolor And *event\_draw = 0 : *event\_draw = 1
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), canvas_backcolor)
            EndIf
            
            Tree_Properties_Draw(*this)
            StopDrawing()
          EndIf
        EndWith
      EndIf
    EndProcedure
    
    Procedure.l Tree_SetItemState(*this._s_widget, Item.l, State.b)
      Protected Result.l, collapsed.b, sublevel.l, *SelectElement
      
      ;If (*this\flag\check = 2 Or *this\flag\check = 3)
      If Item < 0 : Item = 0 : EndIf
      If Item > *this\count\items - 1 
        Item = *this\count\items - 1 
      EndIf
      
      *SelectElement = SelectElement(*this\row\_s(), Item) 
      
      If *SelectElement 
        If State & #__tree_Selected
          *this\row\_s()\color\state = #__s_3
          *this\row\selected = *this\row\_s()
        EndIf
        
        If State & #__tree_Checked
          *this\row\_s()\box[#__c_1]\checked = 1
        EndIf
        
        If State & #__tree_Collapsed
          collapsed = 1
        EndIf
        
        If collapsed Or State & #__tree_Expanded
          *this\row\_s()\box[0]\checked = collapsed
          
          sublevel = *this\row\_s()\sublevel
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel = sublevel
              Break
            ElseIf *this\row\_s()\sublevel > sublevel 
              *this\row\_s()\hide = collapsed
              ;*this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
              
            EndIf
          Wend
          PushListPosition(*this\row\_s())
        EndIf
        
        Result = *SelectElement
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l _Tree_SetItemState(*this._s_widget, Item.l, State.b)
      Protected Result.l, Repaint.b, collapsed.b
      
      ;     (*this\flag\check = 2 Or *this\flag\check = 3)
      If Item < 0 Or Item > *this\count\items - 1 
        ProcedureReturn 0
      EndIf
      ;     If Item < 0 : Item = 0 : EndIf
      ;       If Item > *this\count\items - 1 
      ;         Item = *this\count\items - 1 
      ;       EndIf
      
      Result = SelectElement(*this\row\_s(), Item) 
      
      If Result 
        If State & #__tree_Selected
          If *this\row\selected <> *this\row\_s()
            ;           If *this\row\selected
            ;             *this\row\selected\color\state = 0
            ;           EndIf
            
            *this\row\selected = *this\row\_s()
            *this\row\selected\color\state = #__s_3
            Repaint = 1
          Else
            State &~ #__tree_Selected
          EndIf
        EndIf
        
        If State & #__tree_Inbetween Or State & #__tree_Checked
          _tree_set_state_(*this, *this\row\_s(), State)
          
          Repaint = 2
        EndIf
        
        If State & #__tree_Collapsed
          *this\row\_s()\box[0]\checked = 1
          collapsed = 1
        ElseIf State & #__tree_Expanded
          *this\row\_s()\box[0]\checked = 0
          collapsed = 1
        EndIf
        
        If collapsed And *this\row\_s()\childrens
          ; 
          If Not *this\hide And *this\row\count And (*this\count\items % *this\row\count) = 0
            *this\change = 1
            Repaint = 3
          EndIf  
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
              *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
            Else
              Break
            EndIf
          Wend
          PopListPosition(*this\row\_s())
        EndIf
        
        If Repaint
          If Repaint = 2
            Post(#__Event_StatusChange, *this, Item)
          EndIf
          
          If Repaint = 1
            Post(#__Event_Change, *this, Item)
            ;Tree_Events(*this, #__Event_Change)
          EndIf
          
          _repaint_items_(*this)
        EndIf
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i Tree_Properties_AddItem(*this._s_widget, position.l, Text.s, Image.i=-1, subLevel.i=0)
      Protected handle, *parent._s_rows
      
      With *this
        If *this
          If sublevel =- 1
            *parent = *this
             \flag\check = 4
          EndIf
          
          If \flag\check = 4
            If subLevel > 1
              subLevel = 1
            EndIf
          EndIf
          
          ;{ Генерируем идентификатор
          If position < 0 Or position > ListSize(\row\_s()) - 1
            LastElement(\row\_s())
            handle = AddElement(\row\_s()) 
            position = ListIndex(\row\_s())
          Else
            handle = SelectElement(\row\_s(), position)
            
            Protected Lastlevel, Parent, mac = 0
            If mac 
              PreviousElement(\row\_s())
              If \row\_s()\sublevel = sublevel
                Lastlevel = \row\_s()\sublevel 
                \row\_s()\childrens = 0
              EndIf
              SelectElement(\row\_s(), position)
            Else
              If sublevel < \row\_s()\sublevel
                sublevel = \row\_s()\sublevel  
              EndIf
            EndIf
            
            handle = InsertElement(\row\_s())
            
            If mac And subLevel = Lastlevel
              \row\_s()\childrens = 1
              Parent = \row\_s()
            EndIf
            
            ; Исправляем идентификатор итема  
            PushListPosition(\row\_s())
            While NextElement(\row\_s())
              \row\_s()\index = ListIndex(\row\_s())
              
              If mac And \row\_s()\sublevel = sublevel + 1
                \row\_s()\parent = Parent
              EndIf
            Wend
            PopListPosition(\row\_s())
          EndIf
          ;}
          
          If handle
            
            ;;;; \row\_s() = AllocateStructure(_s_rows) с ним setstate работать перестает
            ;           \row\_s()\handle = handle
            
            If \row\sublevellen
              If Not position
               ; \row\first = \row\_s()
              EndIf
              
              If subLevel
                If sublevel>position
                  sublevel=position
                EndIf
                
                PushListPosition(\row\_s())
                While PreviousElement(\row\_s()) 
                  If subLevel = \row\_s()\sublevel
                    *parent = \row\_s()\parent
                    Break
                  ElseIf subLevel > \row\_s()\sublevel
                    *parent = \row\_s()
                    Break
                  EndIf
                Wend 
                PopListPosition(\row\_s())
                
                If *parent
                  ; properties
                  *parent\color\back = $FFD2D2D2
                  *parent\color\back[1] = *parent\color\back
                  *parent\color\back[2] = *parent\color\back
                  *parent\color\frame = *parent\color\back
                  *parent\color\frame[1] = *parent\color\back
                  *parent\color\frame[2] = *parent\color\back
                  *parent\color\front[1] = *parent\color\front
                  *parent\color\front[2] = *parent\color\front
                  *parent\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 20))
                  
                  If subLevel > *parent\sublevel
                    sublevel = *parent\sublevel + 1
                    *parent\childrens + 1
                    
                    If \flag\collapse
                      *parent\box[0]\checked = 1 
                      \row\_s()\hide = 1
                    EndIf
                  EndIf
                  \row\_s()\parent = *parent
                EndIf
                
                \row\_s()\sublevel = sublevel
              EndIf
            EndIf
            
;             If \row\_s()\parent
;               ; set z-order position 
;               If Not \row\_s()\parent\first 
;                 If Not \row\_s()\parent\last
;                   ; Debug \row\_s()\index
;                   \row\_s()\parent\last = \row\_s()
;                 EndIf
;                 ; Debug \row\_s()\index
;                 \row\_s()\parent\first = \row\_s()
;               Else
;                               If Not \row\_s()\parent\first\after
;                                 \row\_s()\parent\first\after = \row\_s()
;                                 \row\_s()\before = \row\_s()\parent\first
;                               EndIf
;                 
;                               If \row\_s()\parent\last
;                                 \row\_s()\parent\last\after = \row\_s()
;                                 \row\_s()\before = \row\_s()\parent\last
;                               EndIf
;                 
;                 \row\_s()\parent\last = \row\_s()
;               EndIf
;             EndIf
;           
            ; set option group
            If \flag\check = 4
              If \row\_s()\parent
                \row\_s()\option_group = \row\_s()\parent
              Else
                \row\_s()\option_group = *this
              EndIf
            EndIf
            
            ; add lines
            \row\_s()\index = position
            
            \row\_s()\color = _get_colors_()
            \row\_s()\color\state = 0
            \row\_s()\color\back = 0 
            \row\_s()\color\frame = 0
            
            \row\_s()\color\fore[0] = 0 
            \row\_s()\color\fore[1] = 0
            \row\_s()\color\fore[2] = 0
            \row\_s()\color\fore[3] = 0
            
            If Text
              \row\_s()\text\string = StringField(Text.s, 1, #LF$)
              \row\_s()\text\change = 1
            EndIf
            
            _set_item_image_(*this, \row\_s(), Image)
            
            If \flag\buttons
              \row\_s()\box[0]\width = \flag\buttons
              \row\_s()\box[0]\height = \flag\buttons
            EndIf
            
            If \flag\check 
              \row\_s()\box[#__c_1]\width = 12
              \row\_s()\box[#__c_1]\height = 12
            EndIf
            
            If \row\sublevellen 
              If (\flag\buttons Or \flag\lines)
                \row\_s()\sublevellen = \row\_s()\sublevel * \row\sublevellen + Bool(\flag\buttons) * 19 + Bool(\flag\check) * 18
              Else
                \row\_s()\sublevellen =  Bool(\flag\check) * 18 
              EndIf
            EndIf
            
            If *this\row\selected 
              *this\row\selected\color\state = 0
              *this\row\selected = *this\row\_s() 
              *this\row\selected\color\state = 2 + Bool(GetActive()\gadget<>*this)
            EndIf
            
            _repaint_items_(*this)
            \count\items + 1
          EndIf
        EndIf
      EndWith
      
      ProcedureReturn handle
    EndProcedure
    
    Procedure.i _Tree_Properties_AddItem(*this._s_widget, position.l, Text.s, Image.i=-1, subLevel.i=0)
      Protected handle, *parent._s_rows
      
      With *this
        If *this
          If sublevel =- 1
            *parent = *this
             \flag\check = 4
          EndIf
          
          If \flag\check = 4
            If subLevel > 1
              subLevel = 1
            EndIf
          EndIf
          
          ;{ Генерируем идентификатор
          If position < 0 Or position > ListSize(\row\_s()) - 1
            LastElement(\row\_s())
            handle = AddElement(\row\_s()) 
            position = ListIndex(\row\_s())
          Else
            handle = SelectElement(\row\_s(), position)
            
            Protected Lastlevel, Parent, mac = 0
            If mac 
              PreviousElement(\row\_s())
              If \row\_s()\sublevel = sublevel
                Lastlevel = \row\_s()\sublevel 
                \row\_s()\childrens = 0
              EndIf
              SelectElement(\row\_s(), position)
            Else
              If sublevel < \row\_s()\sublevel
                sublevel = \row\_s()\sublevel  
              EndIf
            EndIf
            
            handle = InsertElement(\row\_s())
            
            If mac And subLevel = Lastlevel
              \row\_s()\childrens = 1
              Parent = \row\_s()
            EndIf
            
            ; Исправляем идентификатор итема  
            PushListPosition(\row\_s())
            While NextElement(\row\_s())
              \row\_s()\index = ListIndex(\row\_s())
              
              If mac And \row\_s()\sublevel = sublevel + 1
                \row\_s()\parent = Parent
              EndIf
            Wend
            PopListPosition(\row\_s())
          EndIf
          ;}
          
          If handle
            ;;;; \row\_s() = AllocateStructure(_s_rows) с ним setstate работать перестает
            ;           \row\_s()\handle = handle
            
            If \row\sublevellen
              If Not position
                \row\first = \row\_s()
              EndIf
              
              If subLevel
                If sublevel>position
                  sublevel=position
                EndIf
                
                PushListPosition(\row\_s())
                While PreviousElement(\row\_s()) 
                  If subLevel = \row\_s()\sublevel
                    *parent = \row\_s()\parent
                    Break
                  ElseIf subLevel > \row\_s()\sublevel
                    *parent = \row\_s()
                    Break
                  EndIf
                Wend 
                PopListPosition(\row\_s())
                
                If *parent
                  ; properties
                  *parent\color\back = $fff0f0f0
                  *parent\color\back[1] = $fff0f0f0
                  *parent\color\back[2] = $fff0f0f0
                  *parent\color\frame = $fff0f0f0
                  *parent\color\frame[1] = $fff0f0f0
                  *parent\color\frame[2] = $fff0f0f0
                  *parent\color\front[1] = *parent\color\front
                  *parent\color\front[2] = *parent\color\front
                  *parent\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 20))
                  
                  If subLevel > *parent\sublevel
                    sublevel = *parent\sublevel + 1
                    *parent\childrens + 1
                    
                    If \flag\collapse
                      *parent\box[0]\checked = 1 
                      \row\_s()\hide = 1
                    EndIf
                  EndIf
                  \row\_s()\parent = *parent
                EndIf
                
                \row\_s()\sublevel = sublevel
              EndIf
            EndIf
            
            ; set option group
            If \flag\check = 4
              If \row\_s()\parent
                \row\_s()\option_group = \row\_s()\parent
              Else
                \row\_s()\option_group = *this
              EndIf
            EndIf
            
            ; add lines
            \row\_s()\index = position
            
            \row\_s()\color = _get_colors_()
            \row\_s()\color\state = 0
            \row\_s()\color\back = 0 
            \row\_s()\color\frame = 0
            
            \row\_s()\color\fore[0] = 0 
            \row\_s()\color\fore[1] = 0
            \row\_s()\color\fore[2] = 0
            \row\_s()\color\fore[3] = 0
            
            If Text
              \row\_s()\text\string = StringField(Text.s, 1, #LF$)
              \row\_s()\text\change = 1
            EndIf
            
            _set_item_image_(*this, \row\_s(), Image)
            
            If \flag\buttons
              \row\_s()\box[0]\width = \flag\buttons
              \row\_s()\box[0]\height = \flag\buttons
            EndIf
            
            If \flag\check 
              \row\_s()\box[#__c_1]\width = 12
              \row\_s()\box[#__c_1]\height = 12
            EndIf
            
            If \row\sublevellen 
              If (\flag\buttons Or \flag\lines)
                \row\_s()\sublevellen = \row\_s()\sublevel * \row\sublevellen + Bool(\flag\buttons) * 19 + Bool(\flag\check) * 18
              Else
                \row\_s()\sublevellen =  Bool(\flag\check) * 18 
              EndIf
            EndIf
            
            If *this\row\selected 
              *this\row\selected\color\state = 0
              *this\row\selected = *this\row\_s() 
              *this\row\selected\color\state = 2 + Bool(GetActive()\gadget<>*this)
            EndIf
            
            _repaint_items_(*this)
            \count\items + 1
          EndIf
        EndIf
      EndWith
      
      ProcedureReturn handle
    EndProcedure
    
    
    Procedure.l Tree_Events_Key(*this._s_widget, event_type.l, mouse_x.l=-1, mouse_y.l=-1)
      Protected Result, from =- 1
      Static cursor_change, Down, *row_selected._s_rows
      
      With *this
        Select event_type 
          Case #__Event_KeyDown
            ;If *this = GetActive()\gadget
            
            Select *this\root\keyboard\key
              Case #PB_Shortcut_PageUp
                If bar_SetState(*this\scroll\v, 0) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos-18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_Home Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), 0)
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                      
                      If *this\row\_s()\hide
                        While PreviousElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_Change, *this, *this\row\_s()\index)
                      Result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos+18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < (*this\count\items - 1)
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_End Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), (*this\count\items - 1))
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                      
                      If *this\row\_s()\hide
                        While NextElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_Change, *this, *this\row\_s()\index)
                      Result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos-(*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos+(*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
            EndSelect
            
            ;EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l Tree_Events(*this._s_widget, event_type.l, mouse_x.l=-1, mouse_y.l=-1)
      Protected Repaint
      
      If event_type = #__Event_LeftButtonUp
        ; collapsed button up
        If *this\row\box\checked = 2
          *this\row\box\checked =- 1
          Post(#PB_EventType_Up, *this, *event\item)
          Repaint | #True
        Else
          If *this\row\selected ;And *this\row\selected\index = *event\item
                                ; Debug ""+*this\row\selected\index +" "+ *event\item
            If Not *this\flag\check
              If *this\row\selected\_state & #__s_selected = #False
                *this\row\selected\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\selected\index)
                
                If *this\_state & #__s_entered = #False
                  Post(#PB_EventType_LeftClick, *this, *event\item)
                EndIf
              EndIf
            EndIf
          EndIf
          
          Repaint | #True
        EndIf
      EndIf
      
      If event_type = #__Event_LeftClick
        If *this\row\box\checked =- 1
          *this\row\box\checked = 0
        Else
          Post(#PB_EventType_LeftClick, *this, *event\item)
          Repaint | #True
        EndIf
      EndIf
      
      If event_type = #__Event_RightButtonUp
        Post(#PB_EventType_RightClick, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_LeftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_Focus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_3
            *this\row\_s()\color\state = #__s_2
            *this\row\_s()\_state | #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_Focus, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_Lostfocus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_2
            *this\row\_s()\color\state = #__s_3
            *this\row\_s()\_state &~ #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_LostFocus, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_MouseEnter Or
         event_type = #__Event_MouseMove Or
         event_type = #__Event_MouseLeave Or
         event_type = #__Event_RightButtonDown Or
         event_type = #__Event_LeftButtonDown ;Or event_type = #__Event_LeftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_2]) And 
               _from_point_(mouse_x + *this\scroll\h\bar\page\pos,
                            mouse_y + *this\scroll\v\bar\page\pos, *this\row\draws())
              
              ; 
              If Not *this\row\draws()\_state & #__s_entered
                *this\row\draws()\_state | #__s_entered 
                *this\row\entered = *this\row\draws()
                
                If *this\row\draws()\color\state = #__s_0
                  *this\row\draws()\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                If Not (*this\root\mouse\buttons And *this\flag\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If (event_type = #__Event_LeftButtonDown) Or 
                 (*this\root\mouse\buttons And Not *this\flag\check)
                
                ; collapsed/expanded button
                If event_type = #__Event_LeftButtonDown And 
                   *this\flag\buttons And *this\row\draws()\childrens And 
                   _from_point_(mouse_x, mouse_y, *this\row\draws()\box[0])
                  
                  If SelectElement(*this\row\_s(), *this\row\draws()\index) 
                    *this\row\box\checked = 2
                    *this\row\_s()\box[0]\checked ! 1
                    Post(#PB_EventType_Down, *this, *this\row\_s()\index)
                    
                    PushListPosition(*this\row\_s())
                    While NextElement(*this\row\_s())
                      If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
                        *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
                      Else
                        Break
                      EndIf
                    Wend
                    PopListPosition(*this\row\_s())
                    
                    ; TODO
                    If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
                      Tree_Properties_Update(*this, *this\row\_s())
                      StopDrawing()
                    EndIf
                  EndIf
                  
                Else
                  If _from_point_(mouse_x, mouse_y, *this\row\draws()\box[#__c_1])
                    _tree_set_state_(*this, *this\row\draws(), 1)
                    *this\row\box\checked = 1
                  EndIf
                  
                  If *this\flag\check = 2
                    If *this\row\draws()\_state & #__s_selected 
                      *this\row\draws()\_state &~ #__s_selected
                      *this\row\draws()\color\state = #__s_0
                    Else
                      *this\row\draws()\_state | #__s_selected
                      *this\row\draws()\color\state = #__s_2
                    EndIf
                    
                    Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                    
                  Else
                    If *this\row\selected And *this\row\selected <> *this\row\draws()
                      ;If *this\row\selected <> *this\row\draws()
                      If *this\flag\check = 3
                        If *this\row\selected\_state & #__s_selected
                          *this\row\selected\_state &~ #__s_selected
                          Post(#PB_EventType_Change, *this, *this\row\selected\index)
                        EndIf
                      EndIf
                      
                      *this\row\selected\_state &~ #__s_selected
                      ;EndIf
                      
                      *this\row\selected\color\state = #__s_0
                    EndIf
                    
                    If *this\flag\check = 3
                      If *this\row\draws()\_state & #__s_selected = 0
                        *this\row\draws()\_state | #__s_selected
                        Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                      EndIf
                    EndIf
                    
                    *this\row\draws()\color\state = #__s_2
                  EndIf
                  
                  *this\row\selected = *this\row\draws()
                EndIf
                
                
                
                
                
                ; *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                Repaint | #True
              EndIf
              
              If *this\flag\check = 3 And
                 *this\root\mouse\buttons
                Protected _index_, _selected_index_
                
                _index_ = *this\row\draws()\index
                _selected_index_ = *this\row\selected\index
                
                PushListPosition(*this\row\_s()) 
                ForEach *this\row\_s()
                  If *this\row\_s()\draw
                    If Bool((_selected_index_ >= *this\row\_s()\index And _index_ =< *this\row\_s()\index) Or ; верх
                            (_selected_index_ =< *this\row\_s()\index And _index_ >= *this\row\_s()\index))   ; вниз
                      
                      If *this\row\_s()\color\state <> #__s_2
                        *this\row\_s()\color\state = #__s_2
                        
                        Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                        Repaint | #True
                      EndIf
                      
                    ElseIf *this\row\_s()\color\state <> #__s_0
                      *this\row\_s()\color\state = #__s_0
                      
                      Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                      Repaint | #True
                    EndIf
                  EndIf
                Next
                PopListPosition(*this\row\_s()) 
              EndIf
              
            ElseIf *this\row\draws()\_state & #__s_entered
              *this\row\draws()\_state &~ #__s_entered 
              
              
              If *this\row\draws()\color\state = #__s_1
                *this\row\draws()\color\state = #__s_0
              EndIf
              
              ; TODO должен отправлять если покинули все итеми
              If Not _from_point_(mouse_x-*this\x, mouse_y-*this\y, *this\scroll)
                If *this\row\selected
                  Post(#PB_EventType_StatusChange, *this, *this\row\selected\index)
                Else
                  Post(#PB_EventType_StatusChange, *this, - 1)
                EndIf
              EndIf
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      If event_type = #__Event_Input Or
         event_type = #__Event_KeyDown Or
         event_type = #__Event_KeyUp
        
        If GetActive() And GetActive()\gadget = *this
          Repaint | Tree_Events_Key(*this, event_type, mouse_x, mouse_y)
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;-
    Procedure.l ListView_Events(*this._s_widget, event_type.l, mouse_x.l=-1, mouse_y.l=-1)
      Protected Repaint
      
      Macro _multi_select_items_(_this_)
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\draw
            If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index =< *this\row\_s()\index) Or ; верх
                    (*this\row\selected\index >= *this\row\_s()\index And *this\row\entered\index =< *this\row\_s()\index))   ; вниз
              
              If *this\row\_s()\color\state <> #__s_2
                *this\row\_s()\color\state = #__s_2
                Repaint | #True
              EndIf
              
            Else
              
              If *this\row\_s()\color\state <> #__s_0
                *this\row\_s()\color\state = #__s_0
                
                ; example(sel 5;6;7, click 5, no post change)
                If *this\row\_s()\_state & #__s_selected
                  *this\row\_s()\_state &~ #__s_selected
                EndIf
                
                Repaint | #True
              EndIf
              
            EndIf
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
      EndMacro
      
      
      If event_type = #__Event_Focus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_3
            *this\row\_s()\color\state = #__s_2
            *this\row\_s()\_state | #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_Focus, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_Lostfocus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_2
            *this\row\_s()\color\state = #__s_3
            *this\row\_s()\_state &~ #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_LostFocus, *this, *event\item)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_LeftButtonUp
        If *this\row\selected 
          If *this\flag\check = 3
            *this\row\entered = *this\row\selected
          EndIf
          
          If *this\flag\check <> 2 
            If *this\row\selected\_state & #__s_selected = #False
              *this\row\selected\_state | #__s_selected
              Post(#PB_EventType_Change, *this, *this\row\selected\index)
              Repaint | #True
            EndIf
          EndIf
          
          If *this\_state & #__s_entered = #False
            Post(#PB_EventType_LeftClick, *this, *event\item)
            Repaint | #True
          EndIf
        EndIf
      EndIf
      
      If event_type = #__Event_LeftClick
        Post(#PB_EventType_LeftClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_LeftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If event_type = #__Event_RightClick
        Post(#PB_EventType_RightClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      
      If event_type = #__Event_MouseEnter Or
         event_type = #__Event_MouseMove Or
         event_type = #__Event_MouseLeave Or
         event_type = #__Event_RightButtonDown Or
         event_type = #__Event_LeftButtonDown ;Or event_type = #__Event_LeftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_2]) And 
               _from_point_(mouse_x + *this\scroll\h\bar\page\pos,
                            mouse_y + *this\scroll\v\bar\page\pos, *this\row\draws())
              
              ;  
              If Not *this\row\draws()\_state & #__s_entered 
                *this\row\draws()\_state | #__s_entered 
                
                ; 
                If Not *this\root\mouse\buttons
                  *this\row\entered = *this\row\draws()
                EndIf
                
                If *this\row\draws()\color\state = #__s_0
                  *this\row\draws()\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                ;
                If Not (*this\root\mouse\buttons And *this\flag\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If *this\root\mouse\buttons
                If *this\flag\check
                  *this\row\selected = *this\row\draws()
                  
                  ; clickselect items
                  If *this\flag\check = 2
                    If event_type = #__Event_LeftButtonDown
                      If *this\row\draws()\_state & #__s_selected 
                        *this\row\draws()\_state &~ #__s_selected
                        *this\row\draws()\color\state = #__s_1
                      Else
                        *this\row\draws()\_state | #__s_selected
                        *this\row\draws()\color\state = #__s_2
                      EndIf
                      
                      Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                      Repaint | #True
                    EndIf
                  EndIf
                  
                  PushListPosition(*this\row\_s()) 
                  ForEach *this\row\_s()
                    If *this\row\_s()\draw
                      If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index =< *this\row\_s()\index) Or ; верх
                              (*this\row\entered\index =< *this\row\_s()\index And *this\row\selected\index >= *this\row\_s()\index))   ; вниз
                        
                        If *this\flag\check = 2
                          If *this\row\entered\_state & #__s_selected
                            If *this\row\_s()\color\state <> #__s_2
                              *this\row\_s()\color\state = #__s_2
                              
                              If *this\row\_s()\_state & #__s_selected = #False
                                ; entered to no selected
                                Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                              EndIf
                              
                              Repaint | #True
                            EndIf
                            
                          ElseIf *this\row\_s()\_state & #__s_entered
                            If *this\row\_s()\color\state <> #__s_1
                              *this\row\_s()\color\state = #__s_1
                              
                              If *this\row\_s()\_state & #__s_selected
                                If *this\row\entered\_state & #__s_selected = #False
                                  ; entered to selected
                                  Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                EndIf
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                        EndIf
                        
                        ; multiselect items
                        If *this\flag\check = 3
                          If *this\row\_s()\color\state <> #__s_2
                            *this\row\_s()\color\state = #__s_2
                            Repaint | #True
                            
                            ; reset select before this 
                            ; example(sel 5;6;7, click 7, reset 5;6)
                          ElseIf event_type = #__Event_LeftButtonDown
                            If *this\row\selected <> *this\row\_s()
                              *this\row\_s()\color\state = #__s_0
                              Repaint | #True
                            EndIf
                          EndIf
                        EndIf
                        
                      Else
                        
                        If *this\flag\check = 2
                          If *this\row\_s()\_state & #__s_selected 
                            If *this\row\_s()\color\state <> #__s_2
                              *this\row\_s()\color\state = #__s_2
                              
                              If *this\row\entered\_state & #__s_selected = #False
                                ; leaved from selected
                                Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                              EndIf
                              
                              Repaint | #True
                            EndIf
                            
                          ElseIf *this\row\_s()\_state & #__s_entered = #False
                            If *this\row\_s()\color\state <> #__s_0
                              *this\row\_s()\color\state = #__s_0
                              
                              If *this\row\entered\_state & #__s_selected
                                If *this\row\_s()\_state & #__s_selected = #False
                                  ; leaved from no selected
                                  Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                EndIf
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                        EndIf
                        
                        If *this\flag\check = 3
                          If *this\row\_s()\color\state <> #__s_0
                            *this\row\_s()\color\state = #__s_0
                            
                            ; example(sel 5;6;7, click 5, no post change)
                            If *this\row\_s()\_state & #__s_selected
                              *this\row\_s()\_state &~ #__s_selected
                            EndIf
                            
                            Repaint | #True
                          EndIf
                        EndIf
                        
                      EndIf
                    EndIf
                  Next
                  PopListPosition(*this\row\_s()) 
                  
                Else
                  If *this\row\selected And
                     *this\row\selected <> *this\row\draws()
                    *this\row\selected\_state &~ #__s_selected
                    *this\row\selected\color\state = #__s_0
                  EndIf
                  
                  *this\row\draws()\color\state = #__s_2
                  *this\row\selected = *this\row\draws()
                  ; *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                  Repaint | #True
                EndIf
              EndIf
              
            ElseIf *this\row\draws()\_state & #__s_entered
              *this\row\draws()\_state &~ #__s_entered 
              
              
              If *this\row\draws()\color\state = #__s_1
                *this\row\draws()\color\state = #__s_0
              EndIf
              
              ;
              If *this\root\mouse\buttons And *this\flag\check
                If *this\flag\check = 3
                  If *this\row\draws()\_state & #__s_selected = #False
                    *this\row\draws()\_state | #__s_selected
                  EndIf
                  
                  Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                EndIf
              EndIf
              
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      If event_type = #__Event_KeyDown 
        Protected Result, from =- 1
        Static cursor_change, Down
        
        If GetActive() And GetActive()\gadget = *this
          
          
            
            Select *this\root\keyboard\key
              Case #PB_Shortcut_PageUp
                ; TODO scroll to first visible
                If bar_SetState(*this\scroll\v, 0) 
                  *this\change = 1 
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                ; TODO scroll to last visible
                If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  *this\change = 1 
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    ; scroll to top
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos-18) 
                      *this\change = 1 
                      Repaint = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_Home Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), 0)
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                      
                      If *this\row\_s()\hide
                        While PreviousElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      If *this\row\selected 
                        *this\row\selected\_state &~ #__s_selected
                        *this\row\selected\color\state = #__s_0
                      EndIf
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = #__s_2
                      
                      
                      
                      If Not *this\root\keyboard\key[1] & #PB_Canvas_Shift
                        *this\row\entered = *this\row\selected
                      EndIf
                      
                      If *this\flag\check = 3
                        _multi_select_items_(*this)
                      EndIf
                      
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_Change, *this, *this\row\_s()\index)
                      Repaint = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos+18) 
                      *this\change = 1 
                      Repaint = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < (*this\count\items - 1)
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_End Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), (*this\count\items - 1))
                      
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                      
                      If *this\row\_s()\hide
                        While NextElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      If *this\row\selected 
                        *this\row\selected\_state &~ #__s_selected
                        *this\row\selected\color\state = #__s_0
                      EndIf
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = #__s_2
                      
                      
                      If Not *this\root\keyboard\key[1] & #PB_Canvas_Shift
                        *this\row\entered = *this\row\selected
                      EndIf
                      
                      If *this\flag\check = 3
                        _multi_select_items_(*this)
                      EndIf
                      
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_Change, *this, *this\row\_s()\index)
                      Repaint = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos-(*this\scroll\h\bar\page\end/10)) 
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos+(*this\scroll\h\bar\page\end/10)) 
                  Repaint = 1
                EndIf
                
            EndSelect
            
          
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    ;   Procedure Draw_Text(*this._s_widget)
    ;       ; draw text
    ;       If *this\text\string
    ;         ForEach *this\row\_s()
    ;           If *this\row\_s()\text\string
    ;             If (*this\text\change Or *this\resize & #__resize_change)
    ;               *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\scroll\x
    ;               *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\scroll\y
    ;             EndIf
    ;             
    ;             DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
    ;             DrawRotatedText(*this\row\_s()\text\x, *this\row\_s()\text\y, *this\row\_s()\text\string, *this\text\rotate, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
    ;           EndIf
    ;         Next
    ;       EndIf
    ;     EndProcedure
    
    ;-
    ;- WINDOW-e
    Procedure   Window_Draw(*this._s_widget)
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
          ;         If \caption\image\index[2]
          ;           DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          ;           DrawAlphaImage(\caption\image\index[2], \caption\image\x, \caption\image\y, \caption\color\alpha)
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
    
    Procedure   Window_Update(*this._s_widget)
      If *this\type = #__type_window
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
    EndProcedure
    
    Procedure   Window_SetState(*this._s_widget, state.l)
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
            PostEvent(#PB_Event_RestoreWindow, *this\root\canvas\window, *this)
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
            PostEvent(#PB_Event_MaximizeWindow, *this\root\canvas\window, *this)
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
            PostEvent(#PB_Event_MinimizeWindow, *this\root\canvas\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_Close(*this._s_widget)
      Protected.b result
      
      ; close window
      If Not Post(#__Event_CloseWindow, *this)
        Free(*this)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_CloseWindow, *this\root\canvas\window, *this)
        EndIf
        
        result = #True
      EndIf
    EndProcedure
    
    Procedure   Window_Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      If event_type = #__Event_focus
        *this\color\state = #__s_2
        Post(event_type, *this)
        Repaint = #True
      EndIf
      
      If event_type = #__Event_lostfocus
        *this\color\state = #__s_3
        Post(event_type, *this)
        Repaint = #True
      EndIf
      
      If event_type = #__Event_MouseEnter
        Repaint = #True
      EndIf
      
      If event_type = #__Event_MouseLeave
        Repaint = #True
      EndIf
      
      If event_type = #__Event_MouseMove
        If *this\root\selected = *this
          If *this\container = #__type_root
            ResizeWindow(*this\root\canvas\window, (DesktopMouseX() - *this\root\mouse\delta\x), (DesktopMouseY() - *this\root\mouse\delta\y), #PB_Ignore, #PB_Ignore)
          Else
            Repaint = Resize(*this, (mouse_x - *this\root\mouse\delta\x), (mouse_y - *this\root\mouse\delta\y), #PB_Ignore, #PB_Ignore)
          EndIf
        EndIf
      EndIf
      
      If event_type = #__Event_LeftButtonDown
        If *this\type = #__Type_Window
          *this\caption\interact = _from_point_(mouse_x, mouse_y, *this\caption, [2])
          ;*this\color\state = 2
          
          ; close button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[0])
            ProcedureReturn Window_Close(*this)
          EndIf
          
          ; maximize button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[1])
            If Not *this\resize & #__resize_maximize And
               Not *this\resize & #__resize_minimize
              
              ProcedureReturn Window_SetState(*this, #__window_maximize)
            Else
              ProcedureReturn Window_SetState(*this, #__window_normal)
            EndIf
          EndIf
          
          ; minimize button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[2])
            If Not *this\resize & #__resize_minimize
              ProcedureReturn Window_SetState(*this, #__window_minimize)
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;-
    ;- - DRAWs
    Procedure.i Panel_Draw(*this._s_widget)
      If *this\_tab\count\items
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_2]-1, *this\y[#__c_2]-1, *this\width[#__c_2]+2, *this\height[#__c_2]+2, *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_2]-1, *this\y[#__c_2]-1, *this\width[#__c_2]+2, *this\height[#__c_2]+2, *this\color\frame[Bool(*this\_tab\index[#__s_2]<>-1)*2 ])
        
        Tab_Draw(*this\_tab) 
      Else
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_1], *this\y[#__c_1], *this\width[#__c_1], *this\height[#__c_1], *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_1], *this\y[#__c_1], *this\width[#__c_1], *this\height[#__c_1], *this\color\frame[Bool(*this\index[#__s_2]<>-1)*2 ])
      EndIf
    EndProcedure
    
    Procedure   ScrollArea_Draw(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\round, *this\round, *this\color\back[*this\color\state])
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\round, *this\round, *this\color\frame[*this\color\state])
        
        ;         DrawingMode(#PB_2DDrawing_Transparent)
        ;         DrawText(*this\x[#__c_1]+20,*this\y[#__c_1], Str(\index)+"_"+Str(\level), $ff000000)
        
        ; Draw background image
        If \image\index[2]
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\index[2], *this\scroll\x + \image\x, *this\scroll\y + \image\y, \color\alpha)
        EndIf
        
        If \scroll 
          ; ClipOutput(\x[#__c_4],\y[#__c_4],\width[#__c_4],\height[#__c_4])
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Scroll_Draw(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Scroll_Draw(\scroll\h) : EndIf
        EndIf
      EndWith
    EndProcedure
    
    
    ;-
    Procedure Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
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
          ;*scroll\h\hide = Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len + round, #PB_Ignore)
          *scroll\h\width = *scroll\h\bar\page\len + round
          *scroll\h\hide = Bar_Update(*scroll\h)
          result = 1
        EndIf
      EndIf
      
      If *scroll\height >= *scroll\v\bar\page\len  
        If *scroll\v\bar\Max <> *scroll\height  
          *scroll\v\bar\Max = *scroll\height
          
          If *scroll\y =< y 
            ;If *scroll\v\bar\page\pos <>- (*scroll\y-y)
            *scroll\v\bar\page\pos =- (*scroll\y-y)
            
            *scroll\v\bar\change = 0
            ; Post(#PB_EventType_Change, *scroll\v)
            ;EndIf
          EndIf
        EndIf
        
        If *scroll\v\height <> *scroll\v\bar\page\len + round
          ; Debug  "v "+*scroll\v\bar\page\len
          ;*scroll\v\hide = Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len + round)
          *scroll\v\height = *scroll\v\bar\page\len + round
          *scroll\v\hide = Bar_Update(*scroll\v)
          result = 1
        EndIf
      EndIf
      
      ;       If Not *scroll\h\hide 
      ;         If *scroll\h\y[#__c_3] <> y+height - *scroll\h\height
      ;           ; Debug "y"
      ;           *scroll\h\hide = Resize(*scroll\h, #PB_Ignore, y+height - *scroll\h\height, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *scroll\h\x[#__c_3] <> x
      ;           ; Debug "y"
      ;           *scroll\h\hide = Resize(*scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      ;       
      ;       If Not *scroll\v\hide 
      ;         If *scroll\v\x[#__c_3] <> x+width - *scroll\v\width
      ;           ; Debug "x"
      ;           *scroll\v\hide = Resize(*scroll\v, x+width - *scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *scroll\v\y[#__c_3] <> y
      ;           ; Debug "y"
      ;           *scroll\v\hide = Resize(*scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      
      If v_max <> *scroll\v\bar\Max
        v_max = *scroll\v\bar\Max
        *scroll\v\resize | #__resize_change
        *scroll\v\hide = Bar_Update(*scroll\v) 
      EndIf
      
      If h_max <> *scroll\h\bar\Max
        h_max = *scroll\h\bar\Max
        *scroll\h\resize | #__resize_change
        *scroll\h\hide = Bar_Update(*scroll\h) 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure Resizes(*scroll._s_scroll, x.l,y.l,width.l,height.l)
      ;       *scroll\width = *scroll\h\bar\max
      ;       *scroll\height = *scroll\v\bar\max
      ;       
      ;       ProcedureReturn Updates(*scroll._s_scroll, x.l,y.l,width.l,height.l)
      
      
      ;       y=#PB_Ignore 
      ;         x=#PB_Ignore 
      ;           Width=#PB_Ignore 
      ;           Height=#PB_Ignore 
      ;           
      With *scroll
        Protected iHeight, iWidth, v_x=#PB_Ignore, h_y=#PB_Ignore
        
        If Not *scroll\v Or Not *scroll\h
          ProcedureReturn
        EndIf
        
        If y=#PB_Ignore : y = \v\y-\v\parent\y[#__c_2] : EndIf
        If x=#PB_Ignore : x = \h\x-\v\parent\x[#__c_2] : EndIf
        If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
        If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
        
        If Width+x-*scroll\v\width <> *scroll\v\x[#__c_3]
          v_x = Width+x-*scroll\v\width
        EndIf
        
        If Height+y-*scroll\h\height <> *scroll\h\y[#__c_3]
          h_y = Height+y-*scroll\h\height
        EndIf
        
        ;If
        Bar_SetAttribute(*scroll\v, #__bar_pagelength, _make_area_height_(*scroll, Width, Height))
        *scroll\v\hide = widget::Resize(*scroll\v, v_x, y, #PB_Ignore, _get_page_height_(*scroll, 1))
        ;EndIf
        
        ;If 
        Bar_SetAttribute(*scroll\h, #__bar_pagelength, _make_area_width_(*scroll, Width, Height))
        *scroll\h\hide = widget::Resize(*scroll\h, x, h_y, _get_page_width_(*scroll, 1), #PB_Ignore)
        ;EndIf
        
        If Bar_SetAttribute(*scroll\v, #__bar_pagelength, _make_area_height_(*scroll, Width, Height))
          *scroll\v\hide = widget::Resize(*scroll\v, v_x, #PB_Ignore, #PB_Ignore, _get_page_height_(*scroll, 1))
        EndIf
        
        If Bar_SetAttribute(*scroll\h, #__bar_pagelength, _make_area_width_(*scroll, Width, Height))
          *scroll\h\hide = widget::Resize(*scroll\h, #PB_Ignore, h_y, _get_page_width_(*scroll, 1), #PB_Ignore)
        EndIf
        
        *scroll\v\hide = Bar_Update(*scroll\v)
        *scroll\h\hide = Bar_Update(*scroll\h)
        ;         
        ;         *scroll\v\hide = *scroll\v\bar\hide ; Bool(*scroll\v\bar\min = *scroll\v\bar\page\end)
        ;         *scroll\h\hide = *scroll\h\bar\hide ; Bool(*scroll\h\bar\min = *scroll\h\bar\page\end)
        ;         
        ProcedureReturn Bool(*scroll\v\bar\area\change Or *scroll\h\bar\area\change)
      EndWith
    EndProcedure
    
    
    ;-
    Procedure.b Hide(*this._s_widget, State.b=-1)
      With *this
        If State =- 1
          ProcedureReturn *this\hide 
        Else
          *this\hide = State
          *this\hide[1] = *this\hide
          
          If *this\count\childrens
            ForEach GetChildrens(*this)
              If Child( GetChildrens(*this), *this)
                GetChildrens(*this)\hide = Bool( GetChildrens(*this)\hide[1] Or
                                                 GetChildrens(*this)\parent\hide Or
                                                 GetChildrens(*this)\_parent_item <> GetChildrens(*this)\parent\index[#__s_2])
              EndIf
            Next
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure   Child(*this._s_widget, *parent._s_widget)
      Protected result
      
      If *this And *parent
        If *this\parent = *parent
          result = *this
        Else
          While *this\adress ; *this\root <> *this
            If *this\parent = *parent
              result = *this
              Break
            EndIf
            
            *this = *this\parent
          Wend
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
      
      If *this\type = #__type_tabbar And 
         *this\parent\_tab And *this\parent\_tab = *this
        _p_x4_ = *this\parent\x[#__c_1]+*this\parent\width[#__c_1]
        _p_y4_ = *this\parent\y[#__c_1]+*this\parent\height[#__c_1]
      EndIf
      
      If *this\type = #__type_scrollbar And 
         *this\parent\scroll And (*this\parent\scroll\v = *this Or *this = *this\parent\scroll\h)
        
        ; for the tree scrollbars
        *this\parent\scroll\v\width[#__c_4] = *this\parent\scroll\v\width
        *this\parent\scroll\v\height[#__c_4] = *this\parent\scroll\v\height
        
        *this\parent\scroll\h\width[#__c_4] = *this\parent\scroll\h\width
        *this\parent\scroll\h\height[#__c_4] = *this\parent\scroll\h\height
        
        _p_x4_ = *this\parent\x[#__c_2]+*this\parent\width[#__c_3]
        _p_y4_ = *this\parent\y[#__c_2]+*this\parent\height[#__c_3]
      EndIf
      
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
    
    Procedure.b Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__Type_Option
        *this\option_box\x = *this\x[#__c_2] + 3
        *this\option_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\option_box\height)/2
      EndIf
      
      If *this\type = #__Type_CheckBox
        *this\check_box\x = *this\x[#__c_2] + 3
        *this\check_box\y = *this\y[#__c_2] + (*this\height[#__c_2] - *this\check_box\height)/2
      EndIf
      
      If *this\type = #__Type_Panel
        result = Bar_Update(*this\_tab)
      EndIf  
      
      If *this\type = #__Type_Window
        result = Window_Update(*this)
      EndIf
      
      If *this\type = #__Type_Tree
        If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
          Tree_Properties_Update(*this, *this\row\_s())
          StopDrawing()
        EndIf
        ;*this\change = 1
        result = 1
      EndIf
      
      If *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_TabBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_Splitter Or
         *this\type = #PB_GadgetType_Spin
        
        result = Bar_Update(*this)
      Else
        result = Bool(*this\resize & #__resize_change)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change(*this._s_widget, ScrollPos.f)
      Select *this\type
        Case #__Type_TabBar,
             #PB_GadgetType_Spin,
             #PB_GadgetType_Splitter,
             #PB_GadgetType_TrackBar,
             #PB_GadgetType_ScrollBar,
             #PB_GadgetType_ProgressBar
          
          ProcedureReturn Bar_Change(*this\bar, ScrollPos)
      EndSelect
    EndProcedure
    
    Procedure.b Resize(*this._s_widget, x.l,y.l,width.l,height.l)
      Protected.b result
      Protected.l Change_x, Change_y, Change_width, Change_height
      
      With *this
        ; Debug  *this
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
            \x[#__c_1] = \x+\bs-\fs 
            \x[#__c_2] = \x+\bs+\__width 
            
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
            \width[#__c_3] = \width-\bs*2-\__width 
            If \width[#__c_1] < 0 : \width[#__c_1] = 0 : EndIf
            If \width[#__c_3] < 0 : \width[#__c_3] = 0 : EndIf
            \resize | #__resize_width | #__resize_change
            
            If *this\bar\vertical
              If *this\type = #__type_tabbar
                ; to fix the width of the 
                ; vertical tabbar items
                *this\bar\change = #True
              EndIf
            EndIf
            
            If *this\type = #__type_tree
              *this\change = #True
            EndIf
            
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
            
            If Not *this\bar\vertical
              If *this\type = #__type_tabbar
                ; to fix the height of the
                ; horizontal tabbar items
                *this\bar\change = #True
              EndIf
            EndIf
            
            If *this\type = #__type_tree
              *this\change = #True
            EndIf
            
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
              Resize(*this\scroll\v, *this\scroll\v\x[#__c_3], *this\scroll\v\y[#__c_3], #__scroll_buttonsize, #PB_Ignore)
              Resize(*this\scroll\h, *this\scroll\h\x[#__c_3], *this\scroll\h\y[#__c_3], #PB_Ignore, #__scroll_buttonsize)
            EndIf
            
            If (Change_width Or Change_height)
              Resizes(*this\scroll, 0, 0, *this\width[#__c_3], *this\height[#__c_3])
            EndIf
            
            *this\width[#__c_2] = *this\scroll\h\bar\page\len ; *this\width[#__c_3] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
            *this\height[#__c_2] = *this\scroll\v\bar\page\len; *this\height[#__c_3] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
          EndIf
          
          If (*this\_tab)
            If *this\_tab\bar\vertical
              *this\x[#__c_2] = *this\x + *this\bs
              
              Resize(*this\_tab, 0, 0, *this\__width, *this\height[#__c_3])
              
              *this\x[#__c_2] = *this\x + *this\bs + *this\__width
            Else
              *this\y[#__c_2] = *this\y + *this\bs
              
              Resize(*this\_tab, 0, 0, *this\width[#__c_3], *this\__height)
              
              *this\y[#__c_2] = *this\y + *this\bs + *this\__height
            EndIf
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
                    ;                     If  GetChildrens(*this)\type = #PB_GadgetType_Panel ;(*this\_tab)
                    ;                       Resize(GetChildrens(*this), #PB_Ignore, #PB_Ignore, GetChildrens(*this)\width[#__c_3], #PB_Ignore)
                    ;                     EndIf
                    
                    Clip(GetChildrens(*this), #True)
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition(GetChildrens(*this))
          EndIf
          
          
          If *this\parent And 
             *this\parent\type = #__type_mdi And ; Not _is_scrollbar_(*this) And Not *this\parent\change 
             *this\parent\scroll And 
             *this\parent\scroll\v <> *this And 
             *this\parent\scroll\h <> *this And
             *this\parent\scroll\v\bar\thumb\change = 0 And
             *this\parent\scroll\h\bar\thumb\change = 0
            
            MDI_Update(*this)
          EndIf
          
        EndIf
        
        If *this\draw
          result = Update(*this)
        Else
          result = #True
        EndIf
        
        ; anchors widgets
        If *this And (*this\root And *this\root\anchor And *this\root\anchor\widget = *this)
          a_resize(*this)
        EndIf
        
        ProcedureReturn result
      EndWith
    EndProcedure
    
    Procedure.l X(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\x[mode])
    EndProcedure
    
    Procedure.l Y(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\y[mode])
    EndProcedure
    
    Procedure.l Width(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\width[mode])
    EndProcedure
    
    Procedure.l Height(*this._s_widget, mode.l=#__c_0)
      ProcedureReturn (Bool(Not *this\hide) * *this\height[mode])
    EndProcedure
    
    ;-
    Procedure   AddItem(*this._s_widget, Item.i, Text.s, Image.i=-1, sublevel.i=0)
      Protected result
      
      If *this\type = #PB_GadgetType_MDI
        *this\count\items + 1
        Static pos_x, pos_y
        Protected x = 10, y = 10, width.l = 280, height.l = 180
        sublevel | #__window_systemmenu|#__window_sizegadget|#__window_maximizegadget|#__window_minimizegadget
        result = Window(pos_x+x, pos_y+y, Width, Height, Text, sublevel, *this)
        pos_y + 20 + 25
        pos_x + 20
        ProcedureReturn result
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn Editor_AddItem(*this, Item,Text, Image, sublevel)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree
        ProcedureReturn Tree_Properties_AddItem(*this, Item,Text,Image,sublevel)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        ProcedureReturn Tree_Properties_AddItem(*this, Item,Text,Image,sublevel)
      EndIf
      
      If *this\type = #PB_GadgetType_TabBar
        ProcedureReturn Tab_AddItem(*this, Item,Text,Image,sublevel)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn Tab_AddItem(*this\_tab, Item,Text,Image,sublevel)
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure   RemoveItem(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__Type_Editor
        *this\count\items - 1
        *this\text\change = 1
        
        If *this\count\items =- 1 
          *this\count\items = 0 
          *this\text\string = #LF$
          
          _repaint_(*this)
          
        Else
          *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item+1, #LF$) + #LF$)
        EndIf
        
        result = #True
      ElseIf *this\type = #__Type_Tree
        Protected sublevel.l
        
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          ;       Debug ""+*this\row\_s()\index +" "+ Item
          ; *this\row\sublevel = 0
          
          If *this\row\_s()\childrens
            sublevel = *this\row\_s()\sublevel
            
            PushListPosition(*this\row\_s())
            While NextElement(*this\row\_s())
              If *this\row\_s()\sublevel > sublevel 
                ;Debug *this\row\_s()\text\string
                DeleteElement(*this\row\_s())
                *this\count\items - 1
                *this\row\count - 1
              Else
                Break
              EndIf
            Wend
            PopListPosition(*this\row\_s())
            
            *this\change = 1
          EndIf
          
          DeleteElement(*this\row\_s())
          
          If (*this\row\count And (*this\count\items % *this\row\count) = 0) Or 
             *this\row\count < 2 ; Это на тот случай когда итеми менше первого обнавления
            
            ; Debug "    "+*this\count\items +" "+ *this\row\count
            
            PushListPosition(*this\row\_s())
            ForEach *this\row\_s()
              ; *this\row\sublevel = *this\image\padding\left + *this\row\_s()\image\width
              *this\row\_s()\index = ListIndex(*this\row\_s())
            Next
            PopListPosition(*this\row\_s())
          EndIf 
          
          If *this\row\selected And *this\row\selected\index >= Item 
            *this\row\selected\color\state = 0
            
            PushListPosition(*this\row\_s())
            If *this\row\selected\index <> Item 
              SelectElement(*this\row\_s(), *this\row\selected\index)
            EndIf
            
            While NextElement(*this\row\_s())
              If *this\row\_s()\sublevel = sublevel 
                *this\row\selected = *this\row\_s()
                *this\row\selected\color\state = 2 + Bool(GetActive()\gadget<>*this)
                Break
              EndIf
            Wend
            PopListPosition(*this\row\_s())
          EndIf
          
          _repaint_items_(*this)
          *this\count\items - 1
          ; надо подумать
          ; *this\row\sublevel = 0
          
          result = #True
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        result = Tab_RemoveItem(*this\_tab, Item)
        
      ElseIf *this\type = #__Type_TabBar
        result = Tab_RemoveItem(*this, Item)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l CountItems(*this._s_widget)
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure.l ClearItems(*this._s_widget)
      Protected result
      
      If *this\type = #__Type_Editor
        *this\count\items = 0
        *this\text\change = 1 
        
        If *this\text\editable
          *this\text\string = #LF$
        EndIf
        
        _repaint_(*this)
        ProcedureReturn #True
      EndIf
      
      If *this\type = #__Type_Tree
        If *this\count\items <> 0
          *this\change =- 1
          *this\row\count = 0
          *this\count\items = 0
          *this\row\sublevel = 0
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = 0
          EndIf
          
          ClearList(*this\row\_s())
          
          If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
            Tree_Properties_Draw(*this)
            StopDrawing()
          EndIf
          Post(#__Event_Change, *this, #PB_All)
        EndIf
      EndIf
      
      If *this\type = #__Type_Panel
        result = Tab_ClearItems(*this\_tab)
        
      ElseIf *this\type = #__Type_TabBar
        result = Tab_ClearItems(*this)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CloseList()
      If Root()\opened And 
         Root()\opened\parent And
         Root()\opened\root\canvas\gadget = Root()\canvas\gadget 
        
        ; Debug ""+Root()\opened+" - "+Root()\opened\class+" "+Root()\opened\parent+" - "+Root()\opened\parent\class
        If Root()\opened\parent\type = #__type_mdi
          Root()\opened = Root()\opened\parent\parent
        Else
          Root()\opened = Root()\opened\parent
        EndIf
      Else
        Root()\opened = Root()
      EndIf
    EndProcedure
    
    Procedure.i OpenList(*this._s_widget, item.l=0)
      Protected result.i = Root()\opened
      
      If *this
        If (_is_root_(*this) Or 
            *this\type = #__Type_Window)
          *this\window = *this
        EndIf
        
        Root()\opened = *this
        Root()\opened\_item = item
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure   GetWidget(index)
      Protected result
      
      If index =- 1
        ProcedureReturn GetChildrens(Root())
      Else
        ForEach GetChildrens(Root())
          If GetChildrens(Root())\index = index ;+ 1
            result = GetChildrens(Root())
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetIndex(*this._s_widget)
      ProcedureReturn *this\index ; - 1
    EndProcedure
    
    Procedure.l GetLevel(*this._s_widget)
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass(*this._s_widget)
      ProcedureReturn *this\class
    EndProcedure
    
    Procedure.l GetMouseX(*this._s_widget, mode.l = #__c_0)
      ProcedureReturn *this\root\mouse\x - *this\x[mode]
    EndProcedure
    
    Procedure.l GetMouseY(*this._s_widget, mode.l = #__c_0)
      ProcedureReturn *this\root\mouse\y - *this\y[mode]
    EndProcedure
    
    Procedure.l GetDeltaX(*this._s_widget)
      ProcedureReturn *this\root\mouse\delta\x + *this\root\selected\x[#__c_3]
    EndProcedure
    
    Procedure.l GetDeltaY(*this._s_widget)
      ProcedureReturn *this\root\mouse\delta\y + *this\root\selected\y[#__c_3]
    EndProcedure
    
    Procedure.l GetButtons(*this._s_widget)
      ProcedureReturn *this\root\mouse\buttons
    EndProcedure
    
    Procedure.i GetFont(*this._s_widget)
      ProcedureReturn *this\text\fontID
    EndProcedure
    
    Procedure.l GetCount(*this._s_widget, mode.b=#False)
      If mode
        ProcedureReturn *this\count\type
      Else
        ProcedureReturn *this\count\index
      EndIf
    EndProcedure
    
    Procedure.i GetData(*this._s_widget)
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure.l GetType(*this._s_widget)
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.i GetRoot(*this._s_widget)
      ProcedureReturn *this\root ; Returns root element
    EndProcedure
    
    Procedure.i GetParent(*this._s_widget, mode.b=#False)
      If mode
        ProcedureReturn *this\_parent_item
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
      Protected Result.i
      
      If *this
        Select Position
          Case #PB_List_First  : Result = *this\parent\first
          Case #PB_List_Before : Result = *this\before
          Case #PB_List_After  : Result = *this\after
          Case #PB_List_Last   : Result = *this\parent\last
        EndSelect
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l GetAttribute(*this._s_widget, Attribute.l)
      Protected Result.l
      
      If *this\type = #PB_GadgetType_Tree
        If Attribute = #__tree_Collapsed  
          Result = *this\flag\collapse
        EndIf
      EndIf
      
      Select Attribute
        Case #__bar_minimum    : Result = *this\bar\min          ; 1
        Case #__bar_maximum    : Result = *this\bar\max          ; 2
        Case #__bar_pagelength : Result = *this\bar\page\len     ; 3
        Case #__bar_nobuttons  : Result = *this\bar\button\len   ; 4
        Case #__bar_inverted   : Result = *this\bar\inverted
        Case #__bar_direction  : Result = *this\bar\direction
      EndSelect
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.f GetState(*this._s_widget)
      If *this\type = #PB_GadgetType_ListView Or
         *this\type = #PB_GadgetType_Tree
        
        If *this\row\selected And *this\row\selected\color\state
          ProcedureReturn *this\row\selected\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Option
        ProcedureReturn *this\option_box\checked
      EndIf
      
      If *this\type = #PB_GadgetType_CheckBox
        ProcedureReturn *this\check_box\checked
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn *this\index[#__s_2] ; *this\text\caret\pos
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn *this\index[#__s_2] 
      EndIf
      
      If *this\type = #PB_GadgetType_TabBar
        ProcedureReturn *this\index[#__s_2] 
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
    EndProcedure
    
    Procedure.s GetText(*this._s_widget)
      If *this\type = #PB_GadgetType_Tree
        If *this\row\selected 
          ProcedureReturn *this\row\selected\text\string
        EndIf
      EndIf
      
      If *this\text\pass
        ProcedureReturn *this\text\edit\string
      Else
        ProcedureReturn *this\text\string
      EndIf
    EndProcedure
    
    Procedure.l GetColor(*this._s_widget, ColorType.l)
      Protected Color.l
      
      With *This
        Select ColorType
          Case #__color_line  : Color = \Color\Line
          Case #__color_back  : Color = \Color\Back
          Case #__color_front : Color = \Color\Front
          Case #__color_frame : Color = \Color\Frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;-
    Procedure SetClass(*this._s_widget, class.s)
      *this\class = class
    EndProcedure
    
    Procedure.b SetState(*this._s_widget, state.f)
      Protected result
      
      If *this\type = #__Type_Button
        If *this\_flag & #__button_Toggle
          If state
            *this\_state | #__s_toggled
            *this\color\state = #__s_2 
          Else
            *this\_state &~ #__s_toggled
            If *this\_state &~ #__s_entered
              *this\color\state = #__s_1 
            Else
              *this\color\state = #__s_0 
            EndIf
          EndIf
        EndIf
      EndIf
      
      If *this\type = #__Type_IPAddress
        If *this\index[#__s_2] <> State : *this\index[#__s_2] = State
          SetText(*this, Str(IPAddressField(State,0))+"."+
                         Str(IPAddressField(State,1))+"."+
                         Str(IPAddressField(State,2))+"."+
                         Str(IPAddressField(State,3)))
        EndIf
      EndIf
      
      If *this\type = #__Type_CheckBox
        Select State
          Case #PB_Checkbox_Unchecked,
               #PB_Checkbox_Checked
            
            If *this\check_box\checked <> State
              *this\check_box\checked = State
              Post(#PB_EventType_Change, *this)
              ReDraw(*this\root)
              ProcedureReturn 1
            EndIf
            
          Case #PB_Checkbox_Inbetween
            If *this\flag\threestate 
              If *this\check_box\checked <> State
                *this\check_box\checked = State
                Post(#PB_EventType_Change, *this)
                ReDraw(*this\root)
                ProcedureReturn 1
              EndIf
            EndIf
        EndSelect
      EndIf
      
      If *this\type = #__Type_Option
        If *this\option_group And *this\option_box\checked <> State
          If *this\option_group\option_group <> *this
            If *this\option_group\option_group
              *this\option_group\option_group\option_box\checked = 0
            EndIf
            *this\option_group\option_group = *this
          EndIf
          *this\option_box\checked = State
          
          Post(#PB_EventType_Change, *this)
          ReDraw(*this\root)
          ProcedureReturn 1
        EndIf
      EndIf
      
      If *this\type = #__Type_Window
        result = Window_SetState(*this, state)
      EndIf
      
      If *this\type = #__Type_Editor
        If state < 0 Or state > *this\text\len
          state = *this\text\len
        EndIf
        
        If *this\text\caret\pos <> State
          *this\text\caret\pos = State
          
          Protected i.l, len.l
          Protected *str.Character = @*this\text\string 
          Protected *end.Character = @*this\text\string 
          
          While *end\c 
            If *end\c = #LF 
              len + (*end-*str)/#__sOC
              ; Debug ""+i+" "+Str(len + i) +" "+ state
              
              If len + i >= state
                *this\index[#__c_1] = i
                *this\index[#__c_2] = i
                
                *this\text\caret\pos[1] = state - (len-(*end-*str)/#__sOC) - i
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              i + 1
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__c_1] <> i 
            *this\index[#__c_1] = i
            *this\index[#__c_2] = i
            
            *this\text\caret\pos[1] = (state - len - i) 
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          result = #True 
        EndIf
      EndIf
      
      If *this\type = #__Type_Tree 
        If State >= 0 And State < *this\count\items
          Protected *SelectElement = SelectElement(*this\row\_s(), State) 
        EndIf
        
        If *this\row\selected <> *SelectElement
          If *this\row\selected
            *this\row\selected\color\state = 0
          EndIf
          
          *this\row\selected = *SelectElement
          
          If *this\row\selected
            *this\row\selected\color\state = #__s_3
            *this\row\scrolled = 1
          EndIf
          
          _repaint_items_(*this)
          ProcedureReturn #True
        EndIf
      EndIf
      
      If *this\type = #__Type_ListView
        
        If State >= 0 And State < *this\count\items
          *SelectElement = SelectElement(*this\row\_s(), State) 
        EndIf
        
        If *this\row\selected <> *SelectElement
          If *this\flag\check = 2
            If *this\row\_s()\_state & #__s_selected 
              *this\row\_s()\_state &~ #__s_selected
              *this\row\_s()\color\state = #__s_0
            Else
              *this\row\_s()\_state | #__s_selected
              *this\row\_s()\color\state = #__s_3
            EndIf
            
            Post(#PB_EventType_Change, *this, *this\row\_s()\index)
            
          Else
            If *this\row\selected 
              If *this\row\selected <> *this\row\_s()
                If *this\flag\check = 3
                  If *this\row\selected\_state & #__s_selected
                    *this\row\selected\_state &~ #__s_selected
                    Post(#PB_EventType_Change, *this, *this\row\selected\index)
                  EndIf
                EndIf
                
                *this\row\selected\_state &~ #__s_selected
              EndIf
              
              *this\row\selected\color\state = #__s_0
            EndIf
            
            If *this\flag\check = 3
              If *this\row\_s()\_state & #__s_selected = 0
                *this\row\_s()\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\_s()\index)
              EndIf
            EndIf
            
            *this\row\_s()\color\state = #__s_3
          EndIf
          
          *this\row\selected = *this\row\_s()
          *this\row\scrolled = 1
          
          
          _repaint_items_(*this)
          ProcedureReturn #True
        EndIf
      EndIf
      
      If *this\type = #__Type_Panel
        result = Tab_SetState(*this\_tab, state)
      EndIf
      
      If *this\type = #__Type_TabBar
        result = Tab_SetState(*this, state)
      EndIf
      
      Select *this\type
        Case #__Type_Spin ,
             #__Type_TabBar,
             #__Type_TrackBar,
             #__Type_ScrollBar,
             #__Type_ProgressBar,
             #__Type_Splitter       
          
          result = Bar_SetState(*this, state)
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetAttribute(*this._s_widget, Attribute.l, Value.l)
      Protected Result.l
      
      With *this
        Result = Bar_SetAttribute(*this, Attribute, Value)
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetText(*this._s_widget, Text.s)
      Protected Result.i, Len.i, String.s, i.i
      
      
      If *this\type = #PB_GadgetType_Tree
        If *this\row\selected 
          *this\row\selected\text\string = Text
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ; If Text.s="" : Text.s=#LF$ : EndIf
        Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
        Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
        Text.s = ReplaceString(Text.s, #CR$, #LF$)
        ;Text + #LF$
        
        With *this
          If ListSize(*this\row\_s())
            ClearItems(*this)
          EndIf
          
          If \text\edit\string.s <> Text.s
            \text\edit\string = Text.s
            \text\string.s = _text_insert_make_(*this, Text.s)
            
            If \text\string.s
              If \text\multiline
                \count\items = CountString(\text\string.s, #LF$)
              Else
                ;             If Not \count\items
                \count\items = 1
                \text\string.s = RemoveString(\text\string.s, #LF$) 
                ;               AddElement(\row\_s())
                ;               \row\_s()\text\string = \text\string.s
                ;             EndIf
              EndIf
              
              ;           If *this And StartDrawing(CanvasOutput(*this\root\canvas\gadget))
              ;             If \text\fontID 
              ;               DrawingFont(\text\fontID) 
              ;             EndIf
              ;             
              ;             make_text_multiline(*this)
              ;             StopDrawing()
              ;           EndIf
              
              \text\len = Len(\text\string.s)
              \text\change = #True
              
              _repaint_(*this)
              
              Result = #True
            EndIf
          EndIf
        EndWith
      Else
        If *this\text\multiline = 0
          Text = RemoveString(Text, #LF$)
        EndIf
        
        Text = ReplaceString(Text, #LFCR$, #LF$)
        Text = ReplaceString(Text, #CRLF$, #LF$)
        Text = ReplaceString(Text, #CR$, #LF$)
        ;Text + #LF$
        
        If *This\Text\String.s <> Text.s
          *This\Text\String.s = Text.s
          *This\Text\Change = #True
          Result = #True
        EndIf
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetFont(*this._s_widget, FontID.i)
      Protected Result
      
      If *this\text\fontID <> FontID
        *this\text\fontID = FontID
        
        If *this\type = #PB_GadgetType_Editor
          *this\text\change = 1
          
          If Not Bool(*this\text\count And *this\text\count <> *this\count\items)
            Redraw(*this)
          EndIf
        EndIf
        
        Result = #True
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l SetColor(*this._s_widget, ColorType.l, Color.l)
      Protected Result
      
      With *This
        Select ColorType
          Case #__color_line
            If \Color\Line <> Color 
              \Color\Line = Color
              Result = #True
            EndIf
            
          Case #__color_back
            If \color\Back <> Color 
              \color\Back = Color
              Result = #True
            EndIf
            
          Case #__color_fore
            If \color\fore <> Color 
              \color\fore = Color
              Result = #True
            EndIf
            
          Case #__color_front
            If \Color\Front <> Color 
              \Color\Front = Color
              Result = #True
            EndIf
            
          Case #__color_frame
            If \Color\Frame <> Color 
              \Color\Frame = Color
              Result = #True
            EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   SetData(*this._s_widget, *data)
      *this\data = *data
    EndProcedure
    
    Procedure   SetParent(*this._s_widget, *parent._s_widget, parent_item.l=0)
      Protected x.l, y.l, *LastParent._s_widget
      
      If *parent And parent_item =- 1
        parent_item = *parent\_item
      EndIf
      
      If *Parent And (*this\parent <> *Parent Or *this\_parent_item <> parent_item)
        
        If *this\parent
          *LastParent = *this\parent
          *this\parent\count\childrens - 1
          
          If _is_root_(*Parent)
            FirstElement(GetChildrens(*this\parent))
            MoveElement(GetChildrens(*this\parent), #PB_List_First)
          Else
            ChangeCurrentElement(GetChildrens(*this\parent), *this\adress)
            MoveElement(GetChildrens(*this\parent), #PB_List_After, *Parent\adress)
          EndIf
          
          While PreviousElement(GetChildrens(*this\parent)) 
            If Child(GetChildrens(*this\parent), *this)
              MoveElement(GetChildrens(*this\parent), #PB_List_After, *this\adress)
            EndIf
          Wend
        EndIf
        
        *this\parent = *Parent
        *this\_parent_item = parent_item
        
        *this\root = *this\parent\root
        *this\window = *this\parent\window
        
        *this\hide = Bool(*this\parent\hide Or *this\_parent_item <> *this\parent\index[#__s_2])
        
        ; TODO
        If *this\window
          Static NewMap typecount.l()
          
          *this\count\index = typecount(Hex(*this\window)+"_"+Hex(*this\type))
          typecount(Hex(*this\window)+"_"+Hex(*this\type)) + 1
          
          *this\count\type = typecount(Hex(*this\parent)+"__"+Hex(*this\type))
          typecount(Hex(*this\parent)+"__"+Hex(*this\type)) + 1
        EndIf
        
        If Not *this\adress
          If *this\root\count\childrens
            *this\index = *this\root\count\childrens
            *this\level = *this\parent\level + 1
          EndIf
          
          *this\parent\count\childrens + 1
          *this\root\count\childrens + Bool(*this\parent <> *this\root)
          
          ; SelectElement(GetChildrens(*this\parent), *this\parent\index) ; LastElement(GetChildrens(*this\parent))
          LastElement(GetChildrens(*this\parent))
          *this\adress = AddElement(GetChildrens(*this\parent)) 
          GetChildrens(*this\parent) = *this
        EndIf
        
        If *this\parent
          ; set z-order position 
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
          
          
          If *LastParent And 
             *LastParent <> *Parent
            
            x = *this\x[#__c_3]
            y = *this\y[#__c_3]
            
            If *this\scroll
              If *this\scroll\v
                *this\scroll\v\root = *this\root
                *this\scroll\v\window = *this\window
              EndIf
              If *this\scroll\h
                *this\scroll\v\root = *this\root
                *this\scroll\h\window = *this\window
              EndIf
            EndIf
            
            If *this\parent\scroll And 
               *this\parent\scroll\v And 
               *this\parent\scroll\h
              
              ; for the scroll area childrens
              x - *this\parent\scroll\h\bar\page\pos
              y - *this\parent\scroll\v\bar\page\pos
            EndIf
            
            Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
            
            If *LastParent\root <> *Parent\root
              Select Root()
                Case *LastParent\root : ReDraw(*Parent)
                Case *Parent\root     : ReDraw(*LastParent)
              EndSelect
            EndIf
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
    
    Procedure   SetPosition(*this._s_widget, position.l, *widget_2._s_widget=#Null) ; Ok
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
      
      ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetActive(*this._s_widget)
      Protected Result.i
      
      Macro _set_active_state_(_active_, _state_)
        If Not(_active_ = _active_\root And _active_\root\type =- 5)
          If (_state_)
            Events(_active_, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
          Else
            Events(_active_, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
          EndIf
          
          PostEvent(#PB_Event_Gadget, _active_\root\canvas\window, _active_\root\canvas\gadget, #__Event_repaint)
        EndIf
        
        If _active_\gadget
          If (_state_)
            Events(_active_\gadget, #__Event_Focus, _active_\root\mouse\x, _active_\root\mouse\y)
          Else
            Events(_active_\gadget, #__Event_LostFocus, _active_\root\mouse\x, _active_\root\mouse\y)
          EndIf
        EndIf
      EndMacro
      
      With *this
        *event\widget = *this
        
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
                Events(GetActive()\gadget, #__Event_LostFocus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
              EndIf
              
              GetActive()\gadget = *this
              Events(GetActive()\gadget, #__Event_Focus, GetActive()\root\mouse\x, GetActive()\root\mouse\y)
            EndIf
            
            Result = #True 
          EndIf
          
        ElseIf GetActive() <> *this
          If _is_widget_(GetActive())
            _set_active_state_(GetActive(), #__s_0)
          EndIf
          
          GetActive() = *this
          _set_active_state_(GetActive(), #__s_2)
          Result = #True
        EndIf
        
        SetPosition(GetActive(), #PB_List_Last)
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    ;-
    Procedure.i GetItemData(*this._s_widget, item.l)
      Protected Result.i
      
      With *This
        Select \Type
          Case #PB_GadgetType_Tree,
               #PB_GadgetType_ListView
            
            PushListPosition(*this\row\_s()) 
            ForEach *this\row\_s()
              If *this\row\_s()\index = Item 
                Result = *this\row\_s()\data
                ; Debug *this\row\_s()\Text\String
                Break
              EndIf
            Next
            PopListPosition(*this\row\_s())
        EndSelect
      EndWith
      
      ;     If Result
      ;       Protected *w.Widget_S = Result
      ;       
      ;       Debug "GetItemData "+Item +" "+ Result +" "+  *w\Class
      ;     EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.s GetItemText(*this._s_widget, Item.l, Column.l=0)
      Protected result.s
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) 
          Result = *this\row\_s()\text\string
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        result = Tab_GetItemText(*this\_tab, Item, Column)
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemImage(*this._s_widget, Item.l) 
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          Result = *this\row\_s()\image\index[1]
        Else
          Result =- 1
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Tree Or 
             *this\type = #__Type_Editor
        
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) 
          
          Result = *this\row\_s()\text\fontID
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemState(*this._s_widget, Item.l)
      Protected Result
      
      If *this\type = #PB_GadgetType_Editor
        If item =- 1
          ProcedureReturn *this\text\caret\pos
        Else
          ProcedureReturn *this\text\caret\pos[1]
        EndIf
        
      ElseIf *this\type = #PB_GadgetType_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) 
          If *this\row\_s()\color\state
            Result | #__tree_Selected
          EndIf
          
          If *this\row\_s()\box[#__c_1]\checked
            If *this\flag\threestate And *this\row\_s()\box[#__c_1]\checked = 2
              Result | #__tree_Inbetween
            Else
              Result | #__tree_Checked
            EndIf
          EndIf
          
          If *this\row\_s()\childrens And *this\row\_s()\box[0]\checked = 0
            Result | #__tree_Expanded
          Else
            Result | #__tree_Collapsed
          EndIf
        EndIf
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l=0)
      Protected Result, *color._s_color
      
      If *this\type = #PB_GadgetType_Tree Or
         *this\type = #PB_GadgetType_Editor
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          *color = *this\row\_s()\color
        EndIf
      Else
        *color = *this\bar\button[Item]\color
      EndIf
      
      Select ColorType
        Case #__color_line  : Result = *color\line[Column]
        Case #__color_back  : Result = *color\back[Column]
        Case #__color_front : Result = *color\front[Column]
        Case #__color_frame : Result = *color\frame[Column]
      EndSelect
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i GetItemAttribute(*this._s_widget, Item.l, Attribute.l, Column.l=0)
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Tree
        If Item < 0 : Item = 0 : EndIf
        If Item > *this\count\items - 1 
          Item = *this\count\items - 1 
        EndIf
        
        If SelectElement(*this\row\_s(), Item)
          Select Attribute
            Case #__tree_SubLevel
              Result = *this\row\_s()\sublevel
          EndSelect
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;-
    Procedure.i SetItemData(*This._s_widget, item.l, *data)
      Protected Result.i;, *w.Widget_S = *Data
      
      If *this\type = #__Type_Tree
        ;Debug "SetItemData "+Item +" "+ *Data ;+" "+  *w\index
        ;     
        With *This
          PushListPosition(*this\row\_s()) 
          ForEach *this\row\_s()
            If *this\row\_s()\index = Item  ;  ListIndex(*this\row\_s()) = Item ;  
              *this\row\_s()\data = *Data
              ;Debug *this\row\_s()\Text\String
              
              Break
            EndIf
          Next
          PopListPosition(*this\row\_s())
        EndWith
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l SetItemText(*this._s_widget, Item.l, Text.s, Column.l=0)
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) And 
           *this\row\_s()\text\string <> Text 
          *this\row\_s()\text\string = Text 
          *this\row\_s()\text\change = 1
          *this\change = 1
          Result = #True
        EndIf
        
      ElseIf *this\type = #__Type_Panel
        result = SetItemText(*this\_tab, Item, Text, Column)
        
      ElseIf *this\type = #__Type_TabBar
        If _is_item_(*this, Item) And SelectElement(*this\bar\_s(), Item) And 
           *this\bar\_s()\text\string <> Text 
          *this\bar\_s()\text\string = Text 
          *this\bar\_s()\text\change = 1
          *this\change = 1
          Result = #True
        EndIf
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemImage(*this._s_widget, Item.l, Image.i) 
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          If *this\row\_s()\image\index[1] <> Image
            _set_item_image_(*this, *this\row\_s(), Image)
            _repaint_items_(*this)
          EndIf
        EndIf
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont(*this._s_widget, Item.l, Font.i)
      Protected result, FontID.i = FontID(Font)
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Tree Or
             *this\type = #__Type_Editor
        
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) And 
           *this\row\_s()\text\fontID <> FontID
          *this\row\_s()\text\fontID = FontID
          ;       *this\row\_s()\text\change = 1
          ;       *this\change = 1
          Result = #True
        EndIf 
        
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState(*this._s_widget, Item.l, State.b)
      Protected result
      
      If *this\type = #__Type_Window
        ; result = Window_SetState(*this, state)
        
      ElseIf *this\type = #__Type_Editor
        result = Editor_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__Type_Tree
        result = Tree_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__Type_Panel
        ; result = Panel_SetItemState(*this, state)
        
      Else
        ; result = Bar_SetState(*this, state)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l _SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
      Protected Result
      
      With *this
        If Item =- 1
          PushListPosition(\row\_s()) 
          ForEach \row\_s()
            Select ColorType
              Case #__color_Back
                \row\_s()\color\back[Column] = Color
                
              Case #__color_Front
                \row\_s()\color\front[Column] = Color
                
              Case #__color_Frame
                \row\_s()\color\frame[Column] = Color
                
              Case #__color_Line
                \row\_s()\color\line[Column] = Color
                
            EndSelect
          Next
          PopListPosition(\row\_s()) 
          
        Else
          If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
            Select ColorType
              Case #__color_back
                \row\_s()\color\back[Column] = Color
                
              Case #__color_front
                \row\_s()\color\front[Column] = Color
                
              Case #__color_frame
                \row\_s()\color\frame[Column] = Color
                
              Case #__color_line
                \row\_s()\color\line[Column] = Color
                
            EndSelect
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
      Protected result
      
      If *this\type = #__Type_Tree Or 
         *this\type = #__Type_Editor
        
        result = _SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemAttribute(*this._s_widget, Item.l, Attribute.l, Value.l, Column.l=0)
      Protected result
      
      If *this\type = #__Type_Window
        
      ElseIf *this\type = #__Type_Tree
        Select Attribute
          Case #__tree_Collapsed
            *this\flag\collapse = Bool(Not Value) 
            
          Case #__tree_OptionBoxes
            *this\flag\check = Bool(Value)*2
            
        EndSelect
        
      ElseIf *this\type = #__Type_Editor
        
      ElseIf *this\type = #__Type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    ;-
    ;- DRAWINGs
    Procedure   Button_Draw(*this._s_widget)
      With *this
        If *this\color\back <>- 1
          If \color\fore <>- 1
            DrawingMode(#PB_2DDrawing_Gradient)
            _box_gradient_(\Vertical,\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1],\color\Fore[\color\state],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \round)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(\x[#__c_1],\y[#__c_1],\width[#__c_1],\height[#__c_1], \round,\round, \color\Back[Bool(*this\_state&#__s_back)*\color\state])
          EndIf
        EndIf
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
          Protected IT,Text_Y,Text_X,TxtHeight,Width,Height
          Protected len.l
          Protected *str.Character
          Protected *End.Character
          TxtHeight=\Text\Height
          
          If \Vertical
            Width = \height[#__c_2]-\Text\X*2
            Height = \width[#__c_2]-\Text\y*2
          Else
            Width = \width[#__c_2]-\Text\X*2
            Height = \height[#__c_2]-\Text\y*2
          EndIf
          
          If \text\multiLine
            String.s = text_wrap_(\Text\String.s+#LF$, Width, \text\multiLine)
            CountString = CountString(String, #LF$)
          Else
            String.s = \Text\String.s+#LF$
            CountString = 1
          EndIf
          
          If CountString
            If \Vertical
              If \Text\Align\right
                Text_Y=(Height-(\Text\Height*CountString)-Text_Y) 
              ElseIf \Text\Align\horizontal 
                Text_Y=((Height-(\Text\Height*CountString))/2)
              EndIf
            Else
              If \Text\Align\Bottom
                Text_Y=(Height-(\Text\Height*CountString)-Text_Y) 
              ElseIf \Text\Align\vertical 
                Text_Y=((Height-(\Text\Height*CountString))/2)
              EndIf
            EndIf
            
            Static ch, tw
            \scroll\y = 0
            \scroll\x = 0
            \scroll\width = 0
            \scroll\height = 0
            
            *str.Character = @String
            *End.Character = @String
            
            ; For IT = 1 To CountString
            While *End\c 
              If *End\c = #LF 
                len = (*End-*str)>>#PB_Compiler_Unicode
                String4 = PeekS (*str, len)
                
                ;                 If \Vertical
                ;                   If Text_Y+\Text\x < \bs : Text_Y+TxtHeight : Continue : EndIf
                ;                 Else
                ;                   If Text_Y+\Text\Y < \bs : Text_Y+TxtHeight : Continue : EndIf
                ;                 EndIf
                ;                 
                ;               String4 = StringField(String, IT, #LF$)
                StringWidth = TextWidth(RTrim(String4))
                
                If \Vertical
                  If \Text\Align\bottom 
                    Text_X=(Width-StringWidth)
                  ElseIf \Text\Align\vertical 
                    If ch <> CountString
                      ch = CountString
                      tw = Width
                    EndIf
                    Text_X=(Width-tw)/2+(tw-StringWidth)/2
                  EndIf
                Else
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth)
                  ElseIf \Text\Align\horizontal 
                    If ch <> CountString
                      ch = CountString
                      tw = Width
                    EndIf
                    Text_X=(Width-tw)/2+(tw-StringWidth)/2
                  EndIf
                EndIf
                
                If \Vertical
                  If \scroll\height < StringWidth
                    \scroll\height = StringWidth
                    
                    If \text\rotate = 270
                      If Not \scroll\x
                        If \Text\Align\right
                          \scroll\x = \Text\x
                        ElseIf \Text\Align\horizontal 
                          \scroll\x = \Text\x+Text_y
                        Else
                          \scroll\x = \Text\x+(Height-(\Text\Height*CountString)-Text_Y) 
                        EndIf
                      EndIf
                      
                      \scroll\y = \Text\y+Text_X
                      
                    ElseIf \text\rotate = 90
                      If Not \scroll\x
                        \scroll\x = \Text\x+Text_y
                      EndIf
                      
                      \scroll\y = (\Text\Y+((width-\scroll\height)-Text_X))
                    EndIf
                  EndIf
                  
                  \scroll\width + TxtHeight
                Else
                  \scroll\height + TxtHeight
                  
                  If \scroll\width < StringWidth
                    \scroll\width = StringWidth
                    
                    If \text\rotate = 0
                      If Not \scroll\y
                        \scroll\y = \Text\y+Text_y  
                      EndIf
                      
                      \scroll\x = (\Text\X+Text_X)
                    ElseIf \text\rotate = 180
                      If Not \scroll\y
                        If \Text\Align\bottom
                          \scroll\y = \Text\y
                        ElseIf \Text\Align\vertical 
                          \scroll\y = \Text\y+Text_y
                        Else
                          \scroll\y = \Text\y+(Height-(\Text\Height*CountString)-Text_Y) 
                        EndIf
                      EndIf
                      
                      \scroll\x = \Text\X+((width-\scroll\width)-Text_X)
                    EndIf
                  EndIf
                EndIf
                
                DrawingMode(#PB_2DDrawing_Transparent)
                If \Vertical
                  If \text\rotate = 270
                    DrawRotatedText(\x[#__c_2]+\Text\x+(Height-Text_Y) + Bool(Not \Text\Align\horizontal), \y[#__c_2]+\Text\y+Text_X, String4.s, 270, \Color\Front[Bool(*this\_state & #__s_front) * \color\state])
                  EndIf
                  If \text\rotate = 90
                    DrawRotatedText(\x[#__c_2]+\Text\Y+Text_Y - 1, \y[#__c_2]+\Text\X+(width-Text_X), String4.s, 90, \Color\Front[Bool(*this\_state & #__s_front) * \color\state])
                  EndIf
                Else
                  If \text\rotate = 0
                    DrawRotatedText(\x[#__c_2]+\Text\X+Text_X, \y[#__c_2]+\Text\Y+Text_Y-1, String4.s, 0, \Color\Front[Bool(*this\_state& #__s_front) * \color\state])
                  EndIf
                  If \text\rotate = 180
                    DrawRotatedText(\x[#__c_2]+\Text\X+(Width-Text_X), \y[#__c_2]+\Text\Y+(Height-Text_Y) + Bool(Not \Text\Align\vertical), String4.s, 180, \Color\Front[Bool(*this\_state & #__s_front) * \color\state])
                  EndIf
                EndIf
                
                Text_Y+TxtHeight 
                
                ;                 If \Vertical
                ;                   If Text_Y-\Text\x > (Height-TxtHeight) : Break : EndIf
                ;                 Else
                ;                   If Text_Y-\Text\Y > (Height-TxtHeight) : Break : EndIf
                ;                 EndIf
                
                *str = *End + #__sOC 
              EndIf 
              
              *End + #__sOC 
            Wend
            ; Next
          EndIf
        EndIf
        
        If *this\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(*this\x[#__c_1],*this\y[#__c_1],*this\width[#__c_1],*this\height[#__c_1], *this\round,*this\round, *this\Color\Frame[Bool(*this\_state & #__s_frame)**this\color\state])
        EndIf
        
        If *this\type = #__Type_Button
          If *this\scroll
            ; content area coordinate
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Box(*this\x[#__c_2]+*this\scroll\x, *this\y[#__c_2]+*this\scroll\y, \scroll\width, \scroll\height, $FFFF0000)
          EndIf
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   Hyperlink_Draw(*this._s_widget)
      ; draw text
      If *this\text\string
        Button_Draw(*this)
        
        If *this\flag\lines
          Line(*this\x+*this\scroll\x+1, *this\y+*this\scroll\y+*this\scroll\height-2, 
               *this\scroll\width, 1, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
        EndIf
      EndIf
    EndProcedure
    
    Procedure   Checkbox_Draw(*this._s_widget)
      ; draw text
      If *this\text\string
        Button_Draw(*this)
      EndIf
      
      ; draw checkbox background
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(*this\check_box\x, *this\check_box\y,
               *this\check_box\width, *this\check_box\height,
               *this\check_box\round, *this\check_box\round,
               *this\check_box\color\back&$FFFFFF|*this\check_box\color\alpha<<24)
      
      ; draw checkbox state
      If *this\check_box\checked = #PB_Checkbox_Checked
        Protected i.i
        For i = 0 To 2
          LineXY((*this\check_box\x+3), (i+*this\check_box\y+8),
                 (*this\check_box\x+7), (i+*this\check_box\y+9), 
                 *this\check_box\color\frame[2]&$FFFFFF|*this\check_box\color\alpha<<24) 
          
          LineXY((*this\check_box\x+10+i), (*this\check_box\y+3),
                 (*this\check_box\x+6+i), (*this\check_box\y+10),
                 *this\check_box\color\frame[2]&$FFFFFF|*this\check_box\color\alpha<<24)
        Next
      ElseIf *this\check_box\checked = #PB_Checkbox_Inbetween
        ;         RoundBox( *this\check_box\x+2, *this\check_box\y+2,
        ;                   *this\check_box\width-4, *this\check_box\height-4, 
        ;                   *this\check_box\round-2, *this\check_box\round-2, 
        ;                   *this\check_box\color\frame[2]&$FFFFFF|*this\check_box\color\alpha<<24)
        RoundBox( *this\check_box\x+4, *this\check_box\y+4,
                  *this\check_box\width-8, *this\check_box\height-8, 
                  0, 0, 
                  *this\check_box\color\frame[2]&$FFFFFF|*this\check_box\color\alpha<<24)
      EndIf 
      
      ; draw checkbox frame
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox(*this\check_box\x,*this\check_box\y,*this\check_box\width,*this\check_box\height, *this\check_box\round, *this\check_box\round, 
               *this\check_box\color\frame[Bool(*this\check_box\checked > 0 Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\check_box\color\alpha<<24)
    EndProcedure
    
    Procedure   Option_Draw(*this._s_widget)
      ; draw text
      If *this\text\string
        Button_Draw(*this)
      EndIf
      
      ; draw circle background
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(*this\option_box\x, *this\option_box\y,
               *this\option_box\width, *this\option_box\width,
               *this\option_box\round, *this\option_box\round, 
               *this\option_box\color\back&$FFFFFF|*this\option_box\color\alpha<<24)
      
      ; draw circle state
      If *this\option_box\checked > 0 
        Circle(*this\option_box\x+*this\option_box\round, 
               *this\option_box\y+*this\option_box\round, 2, 
               *this\option_box\color\back[2]&$FFFFFFFF|*this\option_box\color\alpha<<24)
      EndIf
      
      ; draw circle frame
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(*this\option_box\x+*this\option_box\round, *this\option_box\y+*this\option_box\round, *this\option_box\round, 
             *this\option_box\color\frame[Bool(*this\option_box\checked > 0 Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\option_box\color\alpha<<24)
    EndProcedure
    
    ;-
    ;- CREATEs
    Procedure.i Create(type.l, *parent._s_widget, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i=0, round.l=7, ScrollStep.f=1.0)
      Protected ScrollBars, *this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        *this\x =- 2147483648
        *this\y =- 2147483648
        *this\type = type
        *this\round = round
        
        *this\bar\from =- 1
        *this\bar\state =- 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] =- 1
        
        ; *this\adress = *this
        ; *this\class = #PB_Compiler_Procedure
        *this\color = _get_colors_()
        
        ; - Create Container
        If *this\type = #PB_GadgetType_Container Or
           *this\type = #PB_GadgetType_ScrollArea Or
           *this\type = #PB_GadgetType_MDI
          
          If *this\type = #PB_GadgetType_MDI
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_BorderLess) * #__border_scroll
            *this\class = "MDI"
          EndIf
          
          If *this\type = #PB_GadgetType_ScrollArea
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_BorderLess) * #__border_scroll
            *this\class = "ScrollArea"
          EndIf
          
          If *this\type = #PB_GadgetType_Container 
            *this\class = "Container"
            *this\fs = 1
          EndIf
          
          *this\color\back = $FFF9F9F9
          *this\container = *this\type
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\bs = *this\fs
        EndIf
        
        ; - Create Container
        If *this\type = #PB_GadgetType_Image
          ScrollBars = 1
          *this\class = "Image"
          *this\image\index = IsImage(*param_3)
          
          If *this\image\index
            *this\image\index[1] = *param_3
            *this\image\index[2] = ImageID(*param_3)
            *this\image\width = ImageWidth(*param_3)
            *this\image\height = ImageHeight(*param_3)
            
            *param_1 = *this\image\width 
            *param_2 = *this\image\height 
          EndIf
          
          *this\color\back = $FFF9F9F9
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\fs = Bool(Not Flag&#__flag_BorderLess) * #__border_scroll
          *this\bs = *this\fs
        EndIf
        
        ; - Create Scroll
        If *this\type = #PB_GadgetType_ScrollBar
          *this\class = "Scroll"
          *this\bar\increment = ScrollStep
          
          *this\color\back = $FFF9F9F9 ; - 1 
          *this\color\front = $FFFFFFFF
          *this\bar\button[#__b_1]\color = _get_colors_()
          *this\bar\button[#__b_2]\color = _get_colors_()
          *this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
          
          If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
             Flag & #__Bar_Vertical = #__Bar_Vertical
            *this\bar\vertical = #True
          EndIf
          
          *this\bar\button[#__b_3]\len = size
          If Not Flag & #__bar_nobuttons = #__bar_nobuttons
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
          *this\bar\increment = ScrollStep
          
          *this\color\back =- 1 
          *this\bar\button[#__b_1]\color = _get_colors_()
          *this\bar\button[#__b_2]\color = _get_colors_()
          ;*this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
          
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
          
          _set_text_flag_(*this, flag)
          
        EndIf
        
        ; - Create Tab
        If *this\type = #PB_GadgetType_TabBar
          *this\class = "Tab"
          *this\bar\increment = ScrollStep
          
          *this\index[#__s_2] = 0 ; default selected tab
          
          *this\color\back =- 1 
          *this\bar\button[#__b_1]\color = _get_colors_()
          *this\bar\button[#__b_2]\color = _get_colors_()
          ;*this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #False)
          
          If Flag & #__Bar_Vertical = #__Bar_Vertical
            *this\bar\vertical = #True
            *this\vertical = *this\bar\vertical
          EndIf
          
          If Not Flag & #__bar_nobuttons = #__bar_nobuttons
            *this\bar\button[#__b_3]\len = size
            *this\bar\button[#__b_1]\len = 15
            *this\bar\button[#__b_2]\len = 15
          EndIf
          
          ;*this\__height = size
          *this\bs = 1 + Bool(Flag & #__bar_child = #False)
          *this\fs = *this\bs
          
          *this\bar\button[#__b_1]\interact = #True
          *this\bar\button[#__b_2]\interact = #True
          *this\bar\button[#__b_3]\interact = #True
          
          *this\bar\button[#__b_1]\round = 7
          *this\bar\button[#__b_2]\round = 7
          *this\bar\button[#__b_3]\round = *this\round
          
          *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
          *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
          
          *this\bar\button[#__b_1]\arrow\size = #__arrow_size
          *this\bar\button[#__b_2]\arrow\size = #__arrow_size
          ;*this\bar\button[#__b_3]\arrow\size = 3
          
          _set_text_flag_(*this, flag)
        EndIf
        
        ; - Create Track
        If *this\Type = #PB_GadgetType_TrackBar
          *this\class = "Track"
          *this\bar\increment = ScrollStep
          
          *this\color\back =- 1 
          *this\bar\button[#__b_1]\color = _get_colors_()
          *this\bar\button[#__b_2]\color = _get_colors_()
          *this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
          
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
          
          _set_text_flag_(*this, flag)
          
        EndIf
        
        ; - Create Progress
        If *this\type = #PB_GadgetType_ProgressBar
          *this\class = "Progress"
          *this\bar\increment = ScrollStep
          
          *this\color\back =- 1 
          *this\bar\button[#__b_1]\color = _get_colors_()
          *this\bar\button[#__b_2]\color = _get_colors_()
          ;*this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
          
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
          
          _set_text_flag_(*this, flag)
          
        EndIf
        
        ; - Create Splitter
        If *this\type = #PB_GadgetType_Splitter
          *this\class = "Splitter"
          *this\bar\increment = ScrollStep
          
          *this\color\back =- 1
          
          ;         *this\bar\button[#__b_1]\color = _get_colors_()
          ;         *this\bar\button[#__b_2]\color = _get_colors_()
          ;         *this\bar\button[#__b_3]\color = _get_colors_()
          
          *this\container =- *this\type 
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
          *this\bar\mode = Bool(flag & #PB_Splitter_Separator = #PB_Splitter_Separator)
          
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
        
        
        If Flag & #__bar_child = #__bar_child
          ;*this\bar\_type = *this\Type
          *this\parent = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\adress = *parent\adress
          
          
          ;           If *this\bar\vertical 
          ;             *this\width[#__c_0] = size
          ; ;             *this\width[#__c_1] = size - *this\bs*2 + *this\fs*2 
          ; ;             *this\width[#__c_2] = size - *this\bs*2
          ; ;             *this\width[#__c_3] = size - *this\bs*2
          ;           Else
          ;             *this\height[#__c_0] = size
          ; ;             *this\height[#__c_1] = size - *this\bs*2 + *this\fs*2 
          ; ;             *this\height[#__c_2] = size - *this\bs*2
          ; ;             *this\height[#__c_3] = size - *this\bs*2
          ;           EndIf
          
          ;           *this\width[#__c_3] = width - *this\bs*2
          ;           *this\height[#__c_3] = height - *this\bs*2
        Else
          _set_alignment_flag_(*this, *parent, flag)
          
          If *parent
            SetParent(*this, *parent, #PB_Default)
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
          
          If *this\container And 
             *this\type <> #PB_GadgetType_Splitter And 
             flag & #__flag_NoGadget = #False
            OpenList(*this)
          EndIf
          
          If ScrollBars And 
             flag & #__flag_NoScrollBars = #False
            Area(*this, ScrollStep, *param_1, *param_2, 0, 0)
            ; Area(*this, ScrollStep, *param_1, *param_2, width, height)
          EndIf
          
          If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
            a_add(*this)
            a_set(*this)
          EndIf
          
          Resize(*this, x,y,width,height)
          
          If ScrollBars And 
             flag & #__flag_NoScrollBars = #False
            *this\scroll\x = *this\x[#__c_2]
            *this\scroll\y = *this\y[#__c_2] 
          EndIf
          
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_TabBar, Root()\opened, x,y,width,height, min,max,pagelength, 40, flag, round, 40)
    EndProcedure
    
    Procedure.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
      ProcedureReturn Create(#__Type_Spin, Root()\opened, x,y,width,height, min,max,0, #__spin_buttonsize, flag, round, Increment)
    EndProcedure
    
    Procedure.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_ScrollBar, Root()\opened, x,y,width,height, min,max,pagelength, #__scroll_buttonsize, flag, round, 1)
    EndProcedure
    
    Procedure.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=7)
      ProcedureReturn Create(#__Type_TrackBar, Root()\opened, x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i=0, round.l=0)
      ProcedureReturn Create(#__Type_ProgressBar, Root()\opened, x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Splitter(x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i=0)
      ProcedureReturn Create(#__Type_Splitter, Root()\opened, x,y,width,height, First,Second, 0,0, flag, 0, 1)
    EndProcedure
    
    
    
    ;-
    Procedure.i Tree(x.l,y.l,width.l,height.l, Flag.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Root()\opened
      
      If *this
        With *this
          \x =- 2147483648
          \y =- 2147483648
          \type = #PB_GadgetType_Tree
          *this\class = #PB_Compiler_Procedure
          
          ;*this\_state = #__s_front
          *this\color\fore[#__s_0] =- 1
          *this\color\back[#__s_0] = $ffffffff ; _get_colors_()\fore
          *this\color\front[#__s_0] = _get_colors_()\front
          *this\color\frame[#__s_0] = _get_colors_()\frame
          
          \row\index =- 1
          \change = 1
          
          \interact = 1
          ;\round = round
          
          \text\change = 1 ; set auto size items
          \text\height = 18 
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
            ;                     \text\fontID = GetGadGetFont(TextGadget) 
            ;                     FreeGadget(TextGadget)
            Protected FontSize.CGFloat ;= 12.0  boldSystemFontOfSize  fontWithSize
                                       ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
                                       ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
            
            ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
            ;\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
            ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
            ;
            \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
            CocoaMessage(@FontSize, \text\fontID, "pointSize")
            
            ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
            
            ; Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID,"displayName"), "UTF8String"), -1, #PB_UTF8)
            
          CompilerElse
            \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
          CompilerEndIf
          
          \text\padding\left = 4
          \image\padding\left = 2
          
          \fs = Bool(Not Flag&#__tree_BorderLess)*2
          \bs = \fs
          
          \flag\gridlines = Bool(flag&#__tree_GridLines)
          
           \flag\alwaysSelection = Bool(flag&#__tree_AlwaysSelection)
          
          \flag\collapse = Bool(flag&#__tree_Collapsed) 
          \flag\threestate = Bool(flag&#__tree_ThreeState) 
          
          \flag\lines = Bool(Not flag&#__tree_NoLines) * 8 ; Это еще будет размер линии
          \flag\buttons = Bool(Not flag&#__tree_NoButtons) * 9 ; Это еще будет размер кнопки
          
          If  flag & #__tree_CheckBoxes = #__tree_CheckBoxes
            \flag\check = 1
          EndIf
          
          If flag & #__listview_ClickSelect = #__listview_ClickSelect
            \flag\check = 2
          EndIf
          
          If flag & #__listview_MultiSelect = #__listview_MultiSelect
            \flag\check = 3
          EndIf
          
          If flag & #__tree_OptionBoxes = #__tree_OptionBoxes
            \flag\check = 4
          EndIf
          
          If \flag\lines Or \flag\buttons Or \flag\check
            \row\sublevellen = 18
          EndIf
        EndIf
        
        _set_alignment_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        Area(*this, 1, width, height, width, height, Bool((\flag\buttons=0 And \flag\lines=0)=0))
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ListView(x.l,y.l,width.l,height.l, Flag.i=0)
      Protected *this._s_widget = Tree(x,y,width,height, Flag|#__tree_nobuttons|#__tree_nolines)
      
      *this\type = #PB_GadgetType_ListView
      *this\class = #PB_Compiler_Procedure
      
      ProcedureReturn *this
    EndProcedure
    
    
    ;-
    Procedure.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Root()\opened
      
      *this\round = round
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\type = #PB_GadgetType_Editor
      *this\color = _get_colors_()
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_Vertical = #__flag_Vertical
        *this\vertical = #True
      EndIf
      
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Editor
        *this\class = "Text"
        ; *this\color\back =- 1 
        
        *this\index[#__c_1] =- 1
        *this\index[#__c_2] = *this\index[#__c_1]
        
        ; PB 
        *this\fs = constants::_check_(Flag, #__flag_BorderLess, #False) * #__border_scroll
        *this\bs = *this\fs
        
        If *this\Vertical
          *this\Text\X = *this\fs
          *this\Text\y = *this\fs
        Else
          *this\Text\X = *this\fs+2
          *this\Text\y = *this\fs
        EndIf
        
        
        *this\flag\check = 3 ; multiselect
        *this\flag\fullselection = constants::_check_(Flag, #__flag_fullselection, #False)*7
        *this\flag\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        *this\flag\gridlines = constants::_check_(Flag, #__flag_gridlines)
         
        *this\row\margin\hide = constants::_check_(Flag, #__text_numeric, #False)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        _set_text_flag_(*this, flag)
        *this\text\multiline =- 1
        ; SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      Area(*this,1,0,0,0,0)
      Resize(*this, x,y,width,height)
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Root()\opened
      
      *this\round = round
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\type = #__Type_String
      *this\color = _get_colors_()
      *this\color\fore =- 1
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_Vertical = #__flag_Vertical
        *this\vertical = #True
      EndIf
      
      If *this\text\multiline
        *this\row\margin\hide = 0;Bool(Not Flag&#__string_numeric)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      Else
        *this\row\margin\hide = 1
        *this\text\numeric = Bool(Flag&#__string_numeric)
      EndIf
      
      _set_text_flag_(*this, flag)
      
      ; - Create Text
      If *this\type = #PB_GadgetType_String
        *this\class = "String"
        ; *this\color\back =- 1 
        
        ; PB 
        If Flag & #__flag_borderless = #False
          *this\fs = 1
          *this\bs = *this\fs
        EndIf
        
        If *this\Vertical
          *this\Text\X = *this\fs
          *this\Text\y = *this\fs
        Else
          *this\Text\X = *this\fs
          *this\Text\y = *this\fs
        EndIf
        
        *this\text\multiline = 0
        *this\text\align\vertical = 1
        Text = RemoveString(Text, #LF$) ;+ #LF$
        
        SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      Area(*this,1,0,0,0,0)
      
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        a_add(*this)
        a_set(*this)
      EndIf
      
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, round.l=0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Root()\opened
      
      *this\round = round
      *this\x =- 2147483648
      *this\y =- 2147483648
      *this\type = #__Type_Text
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_(*this, flag)
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Text
        *this\class = "Text"
        
        *this\color\fore =- 1
        *this\color\back = _get_colors_()\fore
        *this\color\front = _get_colors_()\front
        
        ; PB 
        If Flag & #__text_border = #__text_border 
          *this\fs = 1
          *this\bs = *this\fs
          *this\color\frame = _get_colors_()\frame
        EndIf
        
        If *this\Vertical
          *this\Text\X = *this\fs
          *this\Text\y = *this\fs
        Else
          *this\Text\X = *this\fs
          *this\Text\y = *this\fs
        EndIf
        
        *this\text\multiline =- 1
        SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        a_add(*this)
        a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i=0, Image.i=-1, round.l=0)
      Protected *this._s_widget = Text(x,y,width,height, Text, Flag|#__text_center|#__text_border, round)
      
      *this\color = _get_colors_()
      *this\type = #__Type_Button
      *this\class = #PB_Compiler_Procedure
      *this\_state = #__s_front|#__s_back|#__s_frame
      
      *this\_flag = Flag
      
      If Not Flag & #__button_multiline
        *this\text\string = RemoveString(*this\text\string, #LF$)
        *this\text\multiline = 0 
      EndIf
      
      If *this\Vertical
        *this\Text\X = *this\fs+6 
        *this\Text\y = *this\fs+6
      Else
        *this\Text\X = *this\fs+6
        *this\Text\y = *this\fs+6
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Root()\opened
      
      If Root()\count\childrens
        If GetChildrens(Root())\type = #__Type_Option
          *this\option_group = GetChildrens(Root())\option_group 
        Else
          *this\option_group = GetChildrens(Root()) 
        EndIf
      Else
        *this\option_group = Root()\opened
      EndIf
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      
      *this\type = #__Type_Option
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag)
      
      ;       *this\color\back =- 1; _get_colors_(); - 1
      ;       *this\color\fore =- 1
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      
      *this\option_box\color = _get_colors_()
      *this\option_box\color\back = $ffffffff
      
      *this\option_box\width = 15
      *this\option_box\height = *this\option_box\width
      *this\option_box\round = *this\option_box\width/2
      *this\text\x = *this\option_box\width + 8
      
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      *this\text\multiline =- CountString(Text, #LF$)
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        a_add(*this)
        a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Root()\opened
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      
      *this\type = #__Type_CheckBox
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag)
      
      *this\flag\threestate = constants::_check_(Flag, #PB_CheckBox_ThreeState)
      *this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
      *this\text\multiline =- CountString(Text, #LF$)
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      *this\check_box\color = _get_colors_()
      *this\check_box\color\back = $ffffffff
      
      *this\check_box\round = 2
      *this\check_box\height = 15
      *this\check_box\width = *this\check_box\height
      *this\text\x = *this\check_box\width + 8
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        a_add(*this)
        a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Root()\opened
      
      *this\x =- 2147483648
      *this\y =- 2147483648
      
      *this\cursor = #PB_Cursor_Hand
      *this\type = #__Type_HyperLink
      *this\class = #PB_Compiler_Procedure 
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag, 3)
      
      *this\flag\lines = constants::_check_(Flag, #PB_HyperLink_Underline)
      *this\text\multiline =- CountString(Text, #LF$)
      
      *this\_state = #__s_front
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_()\fore
      *this\color\front[#__s_0] = _get_colors_()\front
      *this\color\front[#__s_1] = Color
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
        a_add(*this)
        a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    ;-
    Procedure.i Window(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent._s_widget=0)
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
        *this\container =- 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        *this\type = #__Type_Window
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        ; Background image
        \image\index[1] =- 1
        
        
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
          \__height = constants::_check_(flag, #__flag_borderless, #False) * #__height
        EndIf
        
        \fs = constants::_check_(flag, #__flag_borderless, #False) * #__bsize
        \bs = \fs
        
        ;\round = 7
        _set_alignment_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        If Text And \caption\height
          \caption\text\_padding = 5
          \caption\text\string = Text
        EndIf
        
        If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
          a_add(*this)
          a_set(*this)
        EndIf
        
        Resize(*this, X,Y,Width,Height)
        
        If flag & #__Window_NoGadgets = #False
          OpenList(*this)
        EndIf
        
        If flag & #__Window_NoActivate = #False
          SetActive(*this)
        EndIf 
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i MDI(x.l,y.l,width.l,height.l, Flag.i=0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(#__Type_MDI, Root()\opened, x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_NoGadget, 0, 1)
    EndProcedure
    
    Procedure.i Panel(x.l,y.l,width.l,height.l, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__Type_Panel, Flag, Root()\opened)
      Protected *parent._s_widget = Root()\opened
      
      With *this
        *this\x =- 1
        *this\y =- 1
        
        If Flag & #__bar_vertical = #False
          *this\__height = 25
        Else
          *this\__width = 85
        EndIf
        
        *this\type = #__Type_Panel
        *this\class = #PB_Compiler_Procedure
        *this\container = *this\type
        
        *this\color = _get_colors_()
        *this\color\back = $FFFFFFFF
        
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          *this\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
        CompilerElse
          *this\text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        CompilerEndIf
        
        \fs = 1
        \bs = \fs
        
        ; Background image
        ; \image[1] = AllocateStructure(_s_image)
        
        ;_set_text_flag_(*this, Flag)
        _set_alignment_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        \_tab = Create(#__Type_TabBar, *this, 0,0,0,0, 0,0,0, 0, Flag|#__bar_child, 0, 30)
        
        If Not Flag & #__flag_noGadget
          OpenList(*this)
        EndIf
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Container(x.l,y.l,width.l,height.l, Flag.i=0)
      ProcedureReturn Create(#__Type_Container, Root()\opened, x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_NoScrollBars, 0, 0)
    EndProcedure
    
    Procedure.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l=1, Flag.i=0)
      ProcedureReturn Create(#__Type_ScrollArea, Root()\opened, x,y,width,height, ScrollAreaWidth,ScrollAreaHeight,0, #__scroll_buttonsize, flag, 0, ScrollStep)
    EndProcedure
    
    Procedure.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i=0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__Type_Frame, Flag, Root()\opened)
      Protected *parent._s_widget = Root()\opened
      
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
        
        _set_alignment_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        
        If Bool(flag & #__flag_anchorsGadget=#__flag_anchorsGadget)
          a_add(*this)
          a_set(*this)
        EndIf
        Resize(*this, X,Y,Width,Height)
        If Text.s
          SetText(*this, Text.s)
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Image(x.l,y.l,width.l,height.l, image.l, Flag.i=0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(#__Type_Image, Root()\opened, x,y,width,height, 0,0,image, #__scroll_buttonsize, flag, 0, 1)
    EndProcedure
    
    
    ;-
    ;-
    Procedure.b Draw(*this._s_widget)
      With *this
        If \text\fontID 
          DrawingFont(\text\fontID)
        EndIf
        
        If \text\string 
          If \text\change Or *this\resize & #__resize_change
            If Not *this\text\multiline
              *this\text\width = TextWidth(*this\text\string)
            EndIf
            *this\text\height = TextHeight("A")
          EndIf
        EndIf
        
        Select \type
          Case #__Type_Window         : Window_Draw(*this)
          Case #__Type_Container      : ScrollArea_Draw(*this)
          Case #__Type_ScrollArea     : ScrollArea_Draw(*this)
          Case #__Type_MDI            : ScrollArea_Draw(*this)
          Case #__Type_Image          : ScrollArea_Draw(*this)
          Case #__Type_Panel          : Panel_Draw(*this)
            
          Case #__Type_String         : Editor_Draw(*this)
          Case #__Type_Editor         : Editor_Draw(*this)
          Case #__Type_Tree           : Tree_Properties_Draw(*this)
          Case #__Type_ListView       : Tree_Properties_Draw(*this)
            
          Case #__Type_Text           : Button_Draw(*this)
          Case #__Type_Button         : Button_Draw(*this)
          Case #__Type_Option         : Option_Draw(*this)
          Case #__Type_CheckBox       : CheckBox_Draw(*this)
          Case #__Type_HyperLink      : Hyperlink_Draw(*this)
            
          Case #__Type_Spin ,
               #__Type_TabBar,
               #__Type_TrackBar,
               #__Type_ScrollBar,
               #__Type_ProgressBar,
               #__Type_Splitter       
            
            Bar_Draw(*this)
            
            ;             UnclipOutput()
            ;             DrawingMode(#PB_2DDrawing_Outlined)
            ;             Box(*this\x[#__c_4], *this\y[#__c_4], *this\width[#__c_4], *this\height[#__c_4], $ff00ffff)
            
        EndSelect
        
        ;         If *this\scroll And *this\scroll\v And *this\scroll\h
        ;           UnclipOutput()
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           ;Box(*this\x, *this\y, *this\width, *this\height, $ffffff00)
        ;           Box(*this\scroll\x, *this\scroll\y, *this\scroll\width, *this\scroll\height, $ffff00ff)
        ;           ;Box(*this\scroll\x, *this\scroll\y, *this\scroll\h\bar\max, *this\scroll\v\bar\max,$ff0000ff)
        ;           Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len, $ff00ff00)
        ;           Box(*this\x[#__c_4], *this\y[#__c_4], *this\width[#__c_4], *this\height[#__c_4], $ff00ffff)
        ;         EndIf
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        If *this\resize & #__resize_change
          *this\resize &~ #__resize_change
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   ReDraw(*this._s_widget)
      If StartDrawing( CanvasOutput(*this\root\canvas\gadget) )
        If Root()\canvas\repaint <> #False
          Root()\canvas\repaint = #False
        EndIf
        
        If Root()\repaint = #True
          FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
        EndIf
        
        ; Protected count
        PushListPosition(GetChildrens(*this))
        ForEach GetChildrens(*this)
          If (Not GetChildrens(*this)\hide And GetChildrens(*this)\draw) And
             GetChildrens(*this)\root\canvas\gadget = *this\root\canvas\gadget
            
            If (GetChildrens(*this)\width[#__c_4] > 0 And GetChildrens(*this)\height[#__c_4] > 0)
              CompilerIf Not (#PB_Compiler_OS = #PB_OS_MacOS And Not Defined(fixme, #PB_Module))
                ClipOutput( GetChildrens(*this)\x[#__c_4], 
                            GetChildrens(*this)\y[#__c_4], 
                            GetChildrens(*this)\width[#__c_4], 
                            GetChildrens(*this)\height[#__c_4])
              CompilerEndIf
              
              ; Debug ""+count +" "+ GetChildrens(*this)\width[#__c_4] : count + 1
              Draw(GetChildrens(*this))
            EndIf
          EndIf
        Next
        PopListPosition(GetChildrens(*this))
        
        ; Draw anchors 
        If *this\root And *this\root\anchor And 
           *this\root\anchor\widget And Not *this\root\anchor\widget\hide
          UnclipOutput()
          ;Debug *this\root\anchor\widget
          a_draw(*this\root\anchor\widget)
        EndIf
        
        ; ; ;         ; selector
        ; ; ;         If *this\root\anchor 
        ; ; ;            UnclipOutput()
        ; ; ;          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        ; ; ;           Box(*this\root\anchor\x, *this\root\anchor\y, *this\root\anchor\width, *this\root\anchor\height , $ff000000);*this\root\anchor\color[*this\root\anchor\state]\frame) 
        ; ; ;         EndIf
        StopDrawing()
      EndIf
    EndProcedure
    
    Procedure.i Post(eventtype.l, *this._s_widget, eventitem.l=#PB_All, *data=0)
      Protected result.i
      
      If eventtype = #PB_EventType_Repaint
        If *this = #PB_All
          If Root()\canvas\repaint = #False
            Root()\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, Root()\canvas\window, Root()\canvas\gadget, #PB_EventType_Repaint, Root())
          EndIf
        Else
          If *this\root\canvas\repaint = #False
            *this\root\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #PB_EventType_Repaint, *this)
          EndIf
        EndIf
      Else
        structures::*event\type = eventtype
        structures::*event\item = eventitem
        structures::*event\widget = *this
        structures::*event\data = *data
        
        If *this And *this\root\count\events
          If Not _is_root_(*this)
            If *this\event And 
               (*this\event\type = #PB_All Or *this\event\type = eventtype)
              
              result = *this\event\callback()
              
              If result = #PB_Ignore
                ProcedureReturn #PB_Ignore
              EndIf
            EndIf
            
            If Not _is_window_(*this) And Not _is_root_(*this\window) And *this\window\event And 
               (*this\window\event\type = #PB_All Or *this\window\event\type = eventtype)
              
              result = *this\window\event\callback()
              
              If result = #PB_Ignore
                ProcedureReturn #PB_Ignore
              EndIf
            EndIf
          EndIf
          
          If *this\root And *this\root\event And 
             (*this\root\event\type = #PB_All Or *this\root\event\type = eventtype) 
            
            result = *this\root\event\callback()
            
            If result = #PB_Ignore
              ProcedureReturn #PB_Ignore
            EndIf
          EndIf
        Else
          Select eventtype 
            Case #__Event_Focus, 
                 #__Event_LostFocus
              
              ForEach Root()\_events()
                If Root()\_events()\widget = *this And 
                   Root()\_events()\type = eventtype
                  result = 1
                EndIf
              Next
              
              If Not result
                AddElement(Root()\_events())
                Root()\_events() = AllocateStructure(_s_event)
                Root()\_events()\type = eventtype
                Root()\_events()\item = eventitem
                Root()\_events()\widget = *this
                Root()\_events()\data = *data
              EndIf
              
          EndSelect
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind(*this._s_widget, *callback, eventtype.l=#PB_All)
      If *this = #PB_All
        *this = Root()
      EndIf
      
      If Not *this\event
        *this\event = AllocateStructure(_s_event)
      EndIf
      
      If Not *this\root\count\events
        *this\root\count\events = 1
      EndIf
      
      *this\event\callback = *callback
      *this\event\type = eventtype
      
      If ListSize(Root()\_events())
        ForEach Root()\_events()
          Post(Root()\_events()\type, Root()\_events()\widget, Root()\_events()\item, Root()\_events()\data)
        Next
        ClearList(Root()\_events())
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
    
    Procedure.i Free(*this._s_widget)
      Protected Result.i
      
      With *this
        If *this
          If \scroll
            If \scroll\v : FreeStructure(\scroll\v) : \scroll\v = 0 : EndIf
            If \scroll\h : FreeStructure(\scroll\h)  : \scroll\h = 0 : EndIf
            ; *this\scroll = 0
          EndIf
          
          If \splitter
            If \splitter\first : FreeStructure(\splitter\first) : \splitter\first = 0 : EndIf
            If \splitter\second : FreeStructure(\splitter\second)  : \splitter\second = 0 : EndIf
            *this\splitter = 0
          EndIf
          
          If \_tab
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
          
          
          Debug  " - "+ListSize(GetChildrens(*this)) +" "+ *this\root\count\childrens +" "+ *this\parent\count\childrens
          If *this\parent And
             *this\parent\count\childrens 
            
            LastElement(GetChildrens(*this))
            Repeat
              If GetChildrens(*this) = *this Or
                 Child(GetChildrens(*this), *this)
                
                If GetChildrens(*this)\root\count\childrens > 0 
                  GetChildrens(*this)\root\count\childrens - 1
                  If GetChildrens(*this)\parent <> GetChildrens(*this)\root
                    GetChildrens(*this)\parent\count\childrens - 1
                  EndIf
                  DeleteElement(GetChildrens(*this), 1)
                EndIf
                
                If Not *this\root\count\childrens
                  Break
                EndIf
              ElseIf PreviousElement(GetChildrens(*this)) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  " - "+ListSize(GetChildrens(*this)) +" "+ *this\root\count\childrens +" "+ *this\parent\count\childrens
          
          
          
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
    Procedure Events(*this._s_widget, event_type.l, mouse_x.l, mouse_y.l, _wheel_x_.b=0, _wheel_y_.b=0)
      Protected Repaint
      
      If Not _is_widget_(*this)
        If Not _is_root_(*this)
          Debug "not event widget - " + *this
        EndIf
        ProcedureReturn 
      EndIf
      
      If *this\flag\transform
        ProcedureReturn a_events(*this, event_type, *this\root\mouse\buttons, *this\root\mouse\x, *this\root\mouse\y)
      EndIf
      
      If *this\type = #__Type_Window
        Repaint = Window_Events(*this, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        Repaint = Bar_Events(*this\_tab, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree
        Repaint = Tree_Events(*this, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        Repaint = ListView_Events(*this, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Editor 
        Repaint = Editor_Events(*this, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_String
        Repaint = Editor_Events(*this, event_type, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Button
        If event_type = #PB_EventType_LeftButtonUp
          If *this\_state & #__s_entered
            If *this\_flag & #__button_toggle
              SetState(*this, Bool(Bool(*this\_state & #__s_toggled) ! 1))
            Else
              *this\color\state = #__s_1
            EndIf
            Post(#PB_EventType_LeftClick, *this) 
            Repaint = 1
          EndIf
        EndIf
        
        If *this\_state & #__s_toggled = #False
          Select event_type
            Case #PB_EventType_MouseLeave     : *this\color\state = #__s_0 : Repaint = 1
            Case #PB_EventType_LeftButtonDown : *this\color\state = #__s_2 : Repaint = 1
            Case #PB_EventType_MouseEnter     : *this\color\state = #__s_1 + Bool(*this = *this\root\selected) : Repaint = 1
          EndSelect
        EndIf
      EndIf
      
      
      If *this\type = #__Type_Option
        Select event_type
          Case #PB_EventType_LeftButtonDown : Repaint = 1
          Case #PB_EventType_LeftButtonUp   : Repaint = 1
          Case #PB_EventType_LeftClick      : Repaint = SetState(*this, #True)
        EndSelect
      EndIf
      
      If *this\type = #__Type_CheckBox
        Select event_type
          Case #PB_EventType_LeftButtonDown : Repaint = 1
          Case #PB_EventType_LeftButtonUp   : Repaint = 1
          Case #PB_EventType_LeftClick      
            Repaint = SetState(*this, Bool(Bool(*this\check_box\checked = #PB_Checkbox_Checked) ! #True))
        EndSelect
      EndIf
      
      If *this\type = #PB_GadgetType_HyperLink
        If _from_point_(mouse_x-*this\x, mouse_y-*this\y, *this\scroll)
          Select event_type
            Case #PB_EventType_LeftClick : Post(event_type, *this)
            Case #PB_EventType_LeftButtonUp   
              SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
              *this\color\state = #__s_1 
              Repaint = 1
              
            Case #PB_EventType_MouseMove 
              If *this\_state & #__s_selected = #False  
                SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, *this\cursor)
                *this\color\state = #__s_1 
                Repaint = 1
              EndIf
              
            Case #PB_EventType_LeftButtonDown 
              SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
              *this\color\state = #__s_0 
              Repaint = 1
              
          EndSelect
        Else
          If *this\_state & #__s_selected = #False  
            SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)   
            *this\color\state = #__s_0
            Repaint = 1
          EndIf
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Spin Or
         *this\type = #PB_GadgetType_TabBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_Splitter
        
        Repaint = Bar_Events(*this, event_type, mouse_x, mouse_y, _wheel_x_, _wheel_y_)
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
      Protected *this._s_widget = GetGadgetData(Canvas)
      
      If Root() <> *this\root
        Root() = *this\root
      EndIf
      
      Select eventtype
        Case #__Event_repaint 
          Repaint = 1
          Debug " -- Canvas repaint -- "; + widget()\row\count
          
        Case #__Event_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          Repaint = Resize(Root(), #PB_Ignore, #PB_Ignore, Width, Height)  
          
          ;           If Not _is_root_(*this)
          ;             Repaint = Resize(*this, #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;            ; PushListPosition(GetChildrens(*this))
          ;             ;         ForEach GetChildrens(*this)
          ;             ;           Resize(GetChildrens(*this), #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;         Next
          ;             ;         ; PopListPosition(GetChildrens(*this))
          ;           EndIf
          
          Repaint = 1
          
      EndSelect
      
      ; set mouse buttons
      If eventtype = #__Event_LeftButtonDown
        Root()\mouse\buttons | #PB_Canvas_LeftButton
        
      ElseIf eventtype = #__Event_RightButtonDown
        Root()\mouse\buttons | #PB_Canvas_RightButton
        
      ElseIf eventtype = #__Event_MiddleButtonDown
        Root()\mouse\buttons | #PB_Canvas_MiddleButton
        
      ElseIf eventtype = #__Event_MouseWheel
        Root()\mouse\wheel\y = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_WheelDelta)
        
      ElseIf eventtype = #__Event_Input 
        Root()\keyboard\input = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Input)
        
      ElseIf eventtype = #__Event_KeyDown Or 
             eventtype = #__Event_KeyUp
        Root()\keyboard\Key = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Key)
        Root()\keyboard\key[1] = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Modifiers)
        
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
           Root()\mouse\x > Root()\mouse\delta\x - 3 And 
           Root()\mouse\x < Root()\mouse\delta\x + 3 And 
           Root()\mouse\y > Root()\mouse\delta\y - 3 And
           Root()\mouse\y < Root()\mouse\delta\y + 3
          
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
        If Root()\count\childrens
          LastElement(GetChildrens(Root())) 
          Repeat                                 
            If _is_widget_(GetChildrens(Root())) And
               Not GetChildrens(Root())\hide And GetChildrens(Root())\draw And 
               GetChildrens(Root())\root\canvas\gadget = Root()\canvas\gadget And 
               _from_point_(mouse_x, mouse_y, GetChildrens(Root()), [#__c_4])
              
              *this = GetChildrens(Root())
              
              ; scrollbars events
              If *this And *this\scroll
                If *this\scroll\v And Not *this\scroll\v\hide And *this\scroll\v\type And 
                   _from_point_(mouse_x,mouse_y, *this\scroll\v, [#__c_4])
                  *this = *this\scroll\v
                ElseIf *this\scroll\h And Not *this\scroll\h\hide And *this\scroll\h\type And 
                       _from_point_(mouse_x,mouse_y, *this\scroll\h, [#__c_4])
                  *this = *this\scroll\h
                EndIf
              EndIf
              
              ; tabbar events
              If *this And *this\_tab 
                If Not *this\_tab\hide And  *this\_tab\type And 
                   _from_point_(mouse_x,mouse_y, *this\_tab, [#__c_4])
                  *this = *this\_tab
                EndIf
              EndIf
              
              Break
            EndIf
          Until PreviousElement(GetChildrens(Root())) = #False 
        EndIf
        
        If Not *this : *this = Root() : EndIf
        
        
        ; set widget mouse
        ; state - (entered & leaved)   
        If Root()\entered <> *this
          If Root()\entered And Root()\entered\_state & #__s_entered And 
             Not (#__from_mouse_state And Child(*this, Root()\entered))
            Root()\entered\_state &~ #__s_entered
            
            Repaint | Events(Root()\entered, #__Event_MouseLeave, mouse_x, mouse_y)
            
            If #__from_mouse_state
              ;ChangeCurrentElement(GetChildrens(Root()), Root()\entered\adress)
              SelectElement(GetChildrens(Root()), Root()\entered\index)
              Repeat                 
                If GetChildrens(Root())\draw And Child(Root()\entered, GetChildrens(Root()))
                  If GetChildrens(Root())\_state & #__s_entered
                    GetChildrens(Root())\_state &~ #__s_entered
                    
                    Repaint | Events(GetChildrens(Root()), #__Event_MouseLeave, mouse_x, mouse_y)
                  EndIf
                EndIf
              Until PreviousElement(GetChildrens(Root())) = #False 
            EndIf
            
            Root()\entered = *this
          EndIf
          
          If *this And
             *this\_state & #__s_entered = #False
            *this\_state | #__s_entered
            Root()\entered = *this
            
            If #__from_mouse_state
              ForEach GetChildrens(Root())
                If GetChildrens(Root()) = Root()\entered
                  Break
                EndIf
                
                If GetChildrens(Root())\draw And Child(Root()\entered, GetChildrens(Root()))
                  If GetChildrens(Root())\_state & #__s_entered = #False
                    GetChildrens(Root())\_state | #__s_entered
                    
                    Repaint | Events(GetChildrens(Root()), #__Event_MouseEnter, mouse_x, mouse_y)
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
        
        Root()\selected = Root()\entered
        Root()\selected\_state | #__s_selected
        
        If Root()\entered\bar\from > 0
          ; bar mouse delta pos
          If Root()\entered\bar\from = #__b_3
            Root()\mouse\delta\x = mouse_x - Root()\entered\bar\thumb\pos
            Root()\mouse\delta\y = mouse_y - Root()\entered\bar\thumb\pos
          EndIf
        Else
          Root()\mouse\delta\x = mouse_x - Root()\entered\x[#__c_3]
          Root()\mouse\delta\y = mouse_y - Root()\entered\y[#__c_3]
        EndIf
        
        If Root()\entered = Root()\entered\parent\scroll\v Or
           Root()\entered = Root()\entered\parent\scroll\h Or 
           Root()\entered = Root()\entered\parent\_tab 
          
          Repaint | SetActive(Root()\entered\parent)
        Else
          Repaint | SetActive(Root()\entered)
        EndIf
      EndIf
      
      ;
      If eventtype = #__Event_Repaint 
        
      ElseIf eventtype = #__Event_LeftClick 
      ElseIf eventtype = #__Event_LeftDoubleClick 
      ElseIf eventtype = #__Event_RightClick 
      ElseIf eventtype = #__Event_RightDoubleClick 
        
      ElseIf eventtype = #__Event_DragStart 
      ElseIf eventtype = #__Event_Focus
        
      ElseIf eventtype = #__Event_LostFocus
        If GetActive()
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          Repaint | Events(GetActive(), #__Event_LostFocus, mouse_x, mouse_y)
          
          If GetActive()\gadget And GetActive() <> GetActive()\gadget
            Repaint | Events(GetActive()\gadget, #__Event_LostFocus, mouse_x, mouse_y)
            GetActive()\gadget = 0
          EndIf
          
          ; GetActive() = 0
        EndIf
        
      ElseIf eventtype = #__Event_MouseEnter 
        If Root()\entered 
          If Root()\entered\_state & #__s_entered = #False
            Root()\entered\_state | #__s_entered
            ; Debug "enter " + Root()\entered\class
            
            Repaint | Events(Root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
          EndIf
        EndIf
        
      ElseIf eventtype = #__Event_MouseLeave 
        If Root()\entered
          If Root()\entered\_state & #__s_entered
            Root()\entered\_state &~ #__s_entered
            ; Debug "leave " + Root()\entered\class
            
            Repaint | Events(Root()\entered, #__Event_MouseLeave, mouse_x, mouse_y)
          EndIf
        EndIf
        
      ElseIf eventtype = #__Event_MouseMove 
        If change
          If Root()\entered
            Repaint | Events(Root()\entered, eventtype, mouse_x, mouse_y)
          EndIf
          If Root()\selected And 
             Root()\selected <> Root()\entered
            Repaint | Events(Root()\selected, eventtype, mouse_x, mouse_y)
          EndIf
        EndIf

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
        
      ElseIf eventtype = #__Event_LeftButtonUp Or 
             eventtype = #__Event_RightButtonUp Or
             eventtype = #__Event_MiddleButtonUp
        
        ; reset mouse buttons
        If Root()\mouse\buttons
          If eventtype = #__Event_LeftButtonUp
            Root()\mouse\buttons &~ #PB_Canvas_LeftButton
          ElseIf eventtype = #__Event_RightButtonUp
            Root()\mouse\buttons &~ #PB_Canvas_RightButton
          ElseIf eventtype = #__Event_MiddleButtonUp
            Root()\mouse\buttons &~ #PB_Canvas_MiddleButton
          EndIf
          
          If _is_widget_(Root()\selected) And Not Root()\mouse\buttons
            Repaint | Events(Root()\selected, eventtype, mouse_x, mouse_y)
            
            Root()\selected\_state &~ #__s_selected
            If Root()\selected\_state & #__s_entered
              If Not Root()\mouse\drag
                Static ClickTime 
                ; Debug Str(ElapsedMilliseconds()-ClickTime) +" "+ DoubleClickTime()
                
                If Not (ClickTime And (ElapsedMilliseconds()-ClickTime) < DoubleClickTime())
                  ; if the mouse button 
                  ; is released in the widget
                  ; then send the message click
                  If eventtype = #__Event_LeftButtonUp
                    Repaint | Events(Root()\selected, #__Event_LeftClick, mouse_x, mouse_y)
                  EndIf
                  If eventtype = #__Event_RightButtonUp
                    Repaint | Events(Root()\selected, #__Event_RightClick, mouse_x, mouse_y)
                  EndIf
                  ClickTime = ElapsedMilliseconds()
                Else
                  If eventtype = #__Event_LeftButtonUp
                    Repaint | Events(Root()\selected, #__Event_LeftDoubleClick, mouse_x, mouse_y)
                  EndIf
                  If eventtype = #__Event_RightButtonUp
                    Repaint | Events(Root()\selected, #__Event_RightDoubleClick, mouse_x, mouse_y)
                  EndIf
                  ClickTime = 0
                EndIf
              EndIf
            Else
              ; Repaint | Events(Root()\selected, #__Event_MouseLeave, mouse_x, mouse_y)
              ; Repaint | Events(Root()\entered, #__Event_MouseEnter, mouse_x, mouse_y)
            EndIf
            
            Root()\mouse\delta\x = 0
            Root()\mouse\delta\y = 0
            Root()\mouse\drag = 0
            Root()\selected = 0
          EndIf
        EndIf
        
      Else
        If eventtype <> #__Event_MouseMove
          change = 1
        EndIf
        
        If Root()\entered And change
          Repaint | Events(Root()\entered, eventtype, mouse_x, mouse_y)
        EndIf
        If Root()\selected And Root()\entered <> Root()\selected And change 
          Repaint | Events(Root()\selected, eventtype, mouse_x, mouse_y)
        EndIf
        
      EndIf
      
      If Repaint 
        ;       If Root()\entered And Root()\entered\bar\button[#__b_3]\color\state
        ; ;         Debug Root()\entered\bar\button[#__b_3]\color\state
        ; ;       EndIf
        ;       ;       If Root()\entered And Root()\entered\type = #__Type_tree
        ;                ReDraw(Root()\entered)
        ;            Else
        ReDraw(Root())
        ;             EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure CW_Resize()
      Protected canvas = GetWindowData(EventWindow())
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-GadgetX(canvas)*2, WindowHeight(EventWindow())-GadgetY(canvas)*2)
    EndProcedure
    
    Procedure CW_Active()
      Protected Repaint
      Protected canvas = GetWindowData(EventWindow())
      ;Debug  Root()\entered
      ;SetActiveGadget(canvas)
      
      
      ;       If _is_widget_(Root()\entered) 
      ;         Root()\selected = Root()\entered
      ;         Root()\selected\_state | #__s_selected
      ;         
      ;         If Root()\entered\bar\from
      ;           ; bar mouse delta pos
      ;           If Root()\entered\bar\from = #__b_3
      ;             Root()\mouse\delta\x = Root()\mouse\x - Root()\entered\bar\thumb\pos
      ;             Root()\mouse\delta\y = Root()\mouse\y - Root()\entered\bar\thumb\pos
      ;           EndIf
      ;         Else
      ;           Root()\mouse\delta\x = Root()\mouse\x - Root()\entered\x[#__c_3]
      ;           Root()\mouse\delta\y = Root()\mouse\y - Root()\entered\y[#__c_3]
      ;         EndIf
      ;         
      ;         If Root()\entered = Root()\entered\parent\scroll\v Or
      ;            Root()\entered = Root()\entered\parent\scroll\h Or 
      ;            Root()\entered = Root()\entered\parent\_tab 
      ;           
      ;           Repaint | SetActive(Root()\entered\parent)
      ;         Else
      ;           Repaint | SetActive(Root()\entered)
      ;         EndIf
      ;         
      ;         Repaint | Events(Root()\entered, #PB_EventType_LeftButtonDown, Root()\mouse\x, Root()\mouse\y)
      ;         
      ;         If Repaint 
      ;           ReDraw(Root())
      ;         EndIf
      ;      EndIf
      
    EndProcedure
    
    Procedure CW_Deactive()
      Protected Repaint
      Protected canvas = GetWindowData(EventWindow())
      Root() = GetGadgetData(canvas)
      
      If GetActive()
        Repaint | Events(GetActive(), #__Event_LostFocus, Root()\mouse\x, Root()\mouse\y)
        
        If GetActive()\gadget And GetActive() <> GetActive()\gadget
          Repaint | Events(GetActive()\gadget, #__Event_LostFocus, Root()\mouse\x, Root()\mouse\y)
          GetActive()\gadget = 0
        EndIf
        
        If Repaint 
          ReDraw(Root())
        EndIf 
        
        GetActive() = 0
      EndIf
    EndProcedure
    
    Procedure Open(window, x.l=0,y.l=0,width.l=#PB_Ignore,height.l=#PB_Ignore, flag.i=#Null, *CallBack=#Null, Canvas=#PB_Any)
      Protected g 
      
      If width = #PB_Ignore And height = #PB_Ignore
        flag = #PB_Canvas_Container
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth(window, #PB_Window_InnerCoordinate) - x*2
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight(window, #PB_Window_InnerCoordinate) - y*2
      EndIf
      
      g = CanvasGadget(Canvas, X, Y, Width, Height, Flag|#PB_Canvas_Keyboard) : If Canvas=-1 : Canvas=g : EndIf
      Root() = AllocateStructure(_s_root)
      Root()\opened = Root()
      ; Root()\widget = AllocateStructure(_s_widget)
      
      Root()\class = "Root"
      Root()\root = Root()
      Root()\parent = Root()
      Root()\window = Root()
      Root()\entered = Root()
      
      Root()\container = #__type_root
      
      Root()\canvas\window = Window
      Root()\canvas\gadget = Canvas
      
      GetActive() = Root()
      GetActive()\root = Root()
      
      ; OpenList(Root())
      ; SetActive(Root())
      Resize(Root(), 0,0,width,height)
      
      
      If flag & #PB_Canvas_Container = #PB_Canvas_Container
        Root()\canvas\container = #True
      EndIf
      
      If flag & #PB_Canvas_Container
        BindEvent(#PB_Event_SizeWindow, @CW_Resize(), Window);, Canvas)
      EndIf
      
      BindEvent(#PB_Event_ActivateWindow, @CW_Active(), Window);, Canvas)
      BindEvent(#PB_Event_DeactivateWindow, @CW_Deactive(), Window);, Canvas)
      
      ; z-order
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
        SetWindowPos_( GadgetID(Canvas), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      CompilerEndIf
      
      
      If *CallBack
        BindGadgetEvent(Canvas, *CallBack)
      Else
        Root()\repaint = #True
      EndIf
      BindGadgetEvent(Canvas, @CallBack())
      
      PostEvent(#PB_Event_Gadget, Window, Canvas, #__Event_Resize)
      
      SetGadgetData(Canvas, Root())
      SetWindowData(window, Canvas)
      
      ProcedureReturn Root()
    EndProcedure
    
    Procedure.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s="", *param1=#Null, *param2=#Null, *param3=#Null, Flag.i=#Null,  window=-1, *CallBack=#Null)
      Protected *this, g, flags
      
      If  window=-1
        window = GetActiveWindow()
      EndIf
      
      Open(Window, x,y,Width,Height, #Null, *CallBack, Gadget)
      ; Root()\container = IsGadget(Root()\canvas\gadget)
      
      Select Type
        Case #PB_GadgetType_Button
          If Flag & #PB_Button_Left = #PB_Button_Left
            Flag &~ #PB_Button_Left
            flags | #__button_left
          EndIf
          If Flag & #PB_Button_Right = #PB_Button_Right
            Flag &~ #PB_Button_Right
            flags | #__button_right
          EndIf
          If Flag & #PB_Button_MultiLine = #PB_Button_MultiLine
            Flag &~ #PB_Button_MultiLine
            flags | #__button_multiline
          EndIf
          If Flag & #PB_Button_Toggle = #PB_Button_Toggle
            Flag &~ #PB_Button_Toggle
            flags | #__button_toggle
          EndIf
          If Flag & #PB_Button_Default = #PB_Button_Default
            Flag &~ #PB_Button_Default
            flags | #__button_default
          EndIf
          
          *this = Button(0, 0, Width, Height, Text, Flag | flags | #__flag_autosize)
          
        Case #PB_GadgetType_Tree
          If Flag & #PB_Tree_AlwaysShowSelection = #PB_Tree_AlwaysShowSelection
            Flag &~ #PB_Tree_AlwaysShowSelection
            flags | #__tree_alwaysselection
          EndIf
          If Flag & #PB_Tree_CheckBoxes = #PB_Tree_CheckBoxes
            Flag &~ #PB_Tree_CheckBoxes
            flags | #__tree_checkboxes 
          EndIf
          If Flag & #PB_Tree_ThreeState = #PB_Tree_ThreeState
            Flag &~ #PB_Tree_ThreeState
            flags | #__tree_threestate
          EndIf
          If Flag & #PB_Tree_NoButtons = #PB_Tree_NoButtons
            Flag &~ #PB_Tree_NoButtons
            flags | #__tree_nobuttons
          EndIf
          If Flag & #PB_Tree_NoLines = #PB_Tree_NoLines
            Flag &~ #PB_Tree_NoLines
            flags | #__tree_nolines
          EndIf
          
          *this = Tree(0, 0, Width, Height, Flag | flags | #__flag_autosize)
      EndSelect
      
      Root()\entered = *this
      
      If Gadget =- 1
        Gadget = GetGadget(Root())
        g = Gadget
      Else
        g = GadgetID(Gadget)
      EndIf
      SetGadgetData(Gadget, *this)
      
      ProcedureReturn g
    EndProcedure
  EndModule
  ;- <<< 
CompilerEndIf

;-
Macro EventWidget()
  widget::*event\widget
EndMacro

Macro WidgetEvent()
  widget::*event\type
EndMacro

Macro Uselib(_name_)
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro


;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Procedure.s get_text(m.s=#LF$)
    Protected Text.s = "This is a long line." + m.s +
                       "Who should show." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "I have to write the text in the box or not." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "The string must be very long." + m.s +
                       "Otherwise it will not work." ;+ m.s; +
    
    ProcedureReturn Text
  EndProcedure
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If Open(OpenWindow(#PB_Any, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    Define *Tree = widget::Tree(10, 10, 250, 200, #__tree_gridlines);|#__tree_nolines);, #__flag_autosize) 
    widget::AddItem(*Tree, -1, "common")
    widget::AddItem(*Tree, -1, "id", -1, 1)
    widget::AddItem(*Tree, -1, "Text", -1, 1)
    
    widget::AddItem(*Tree, -1, "layout")
    widget::AddItem(*Tree, -1, "X", -1, 1)
    widget::AddItem(*Tree, -1, "Y", -1, 1)
    widget::AddItem(*Tree, -1, "Width", -1, 1)
    widget::AddItem(*Tree, -1, "Height", -1, 1)
    
    widget::AddItem(*Tree, -1, "state")
    widget::AddItem(*Tree, -1, "Disable", -1, 1)
    widget::AddItem(*Tree, -1, "Hide", -1, 1)
    
    
   Define  *g=Tree(300, 10, 250, 200);|#__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
    
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 9, "Tree_1_1_2_1_1_5_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 10, "Tree_2",-1 )
    AddItem(*g, 11, "Tree_3", -1 )
    AddItem(*g, 12, "Tree_4", -1 )
    AddItem(*g, 13, "Tree_5", -1 )
    AddItem(*g, 14, "Tree_6", -1 )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP