CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "include/fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget"
  XIncludeFile "include/fixme(lin).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  IncludePath "Z:/Documents/GitHub/Widget"
  XIncludeFile "include/fixme(win).pbi"
CompilerEndIf


CompilerIf Not Defined(func, #PB_Module)
  XIncludeFile "include/func.pbi"
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
  ;-  >>>
  DeclareModule widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    
    CompilerIf Defined(fixme, #PB_Module)
      UseModule fixme
    CompilerEndIf
    
    Macro _get_colors_()
      colors::*this\blue
    EndMacro
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro This()
      structures::*event
    EndMacro
    
    Macro Root()
      This()\root
    EndMacro
    
    Macro Widget() ; Returns last created widget 
      This()\_childrens()
    EndMacro
    
    ;-
    Macro Opened()
      Root()\canvas\widget
    EndMacro
    
    Macro Entered() ; Returns mouse entered widget
      Mouse()\widget
    EndMacro
    
    Macro Focused() ; Returns keyboard focused widget
      Keyboard()\widget
    EndMacro
    
    Macro Selected() ; Returns mouse button selected widget
      Mouse()\selected
    EndMacro
    
    ;-
    Macro Mouse()
      This()\mouse
    EndMacro
    
    Macro Keyboard()
      This()\keyboard
    EndMacro
    
    Macro GetActive() ; Returns active window
      This()\active
    EndMacro
    
    Macro Repaints()
      ;  ReDraw(Root())
      Post(#PB_EventType_Repaint, Root()) ;This()\widget\root)
    EndMacro
    
    ;-
    Macro Transform()
      Root()\transform
    EndMacro
    
    Macro InitTransform()
      Transform() = AllocateStructure(_s_transform)
    EndMacro
    
    Macro SetCursor(_this_, _cursor_)
      If _cursor_ < 65560
        SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
      Else
        SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_CustomCursor, func::cursor(_cursor_))
      EndIf
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
    
    Macro _no_select_(_list_, _item_)
      ;  Bool(_list_\index <> _item_ And Not SelectElement(_list_, _item_))
      Bool(ListIndex(_list_) <> _item_ And Not SelectElement(_list_, _item_))
      ;  Bool(_item_ >= 0 And _item_ < ListSize(_list_) And ListIndex(_list_) <> _item_ And Not SelectElement(_list_, _item_))
    EndMacro
    
    ;- 
    Macro _bar_scrollarea_change_(_this_, _pos_, _len_)
      Bool(Bool((((_pos_) + _this_\bar\min) - _this_\bar\page\pos) < 0 And Bar_SetState(_this_, ((_pos_) + _this_\bar\min))) Or
           Bool((((_pos_) + _this_\bar\min) - _this_\bar\page\pos) > (_this_\bar\page\len - (_len_)) And Bar_SetState(_this_, ((_pos_) + _this_\bar\min) - (_this_\bar\page\len - (_len_)))))
    EndMacro
    
    Macro _tree_bar_update_(_this_, _pos_, _len_)
      ;       Bool(Bool((_pos_ - _this_\y - _this_\bar\page\pos) < 0 And bar_SetState(_this_, (_pos_ - _this_\y))) Or
      ;            Bool((_pos_ - _this_\y - _this_\bar\page\pos) > (_this_\bar\page\len - _len_) And
      ;                 bar_SetState(_this_, (_pos_ - _this_\y) - (_this_\bar\page\len - _len_)))) : _this_\change = 0
      _bar_scrollarea_change_(_this_, _pos_ - _this_\y, _len_)
    EndMacro
    
    Macro _bar_scrollarea_update_(_this_)
      ;Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      Resizes(_this_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;Resizes(_this_, _this_\x, _this_\y, _this_\width, _this_\height)
      ;Updates(_this_, _this_\x, _this_\y, _this_\width, _this_\height)
      _this_\width[#__c_inner] = _this_\scroll\h\bar\page\len ; *this\width[#__c_draw] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
      _this_\height[#__c_inner] = _this_\scroll\v\bar\page\len; *this\height[#__c_draw] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
      
      _this_\scroll\v\bar\area\change = #False
      _this_\scroll\h\bar\area\change = #False
    EndMacro
    
    ;- 
    Macro _get_page_height_(_this_, _scroll_, _round_ = 0)
      (_scroll_\v\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\h\hide) * (_scroll_\h\height/4)) 
    EndMacro
    
    Macro _get_page_width_(_this_, _scroll_, _round_ = 0)
      (_scroll_\h\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\v\hide) * (_scroll_\v\width/4))
    EndMacro
    
    Macro _make_area_height_(_this_, _scroll_, _width_, _height_)
      (_height_ - (Bool((_this_\width > _width_) Or Not _scroll_\h\hide) * _scroll_\h\height)) 
    EndMacro
    
    Macro _make_area_width_(_this_, _scroll_, _width_, _height_)
      (_width_ - (Bool((_this_\height > _height_) Or Not _scroll_\v\hide) * _scroll_\v\width))
    EndMacro
    
    ;- 
    Macro _from_point_(mouse_x, mouse_y, _type_, _mode_ = )
      Bool(mouse_x > _type_\x#_mode_ And mouse_x < (_type_\x#_mode_ + _type_\width#_mode_) And 
           mouse_y > _type_\y#_mode_ And mouse_y < (_type_\y#_mode_ + _type_\height#_mode_))
    EndMacro
    
    Macro _bar_in_start_(_bar_) 
      Bool(_bar_\page\pos <= _bar_\min) 
    EndMacro
    
    Macro _bar_in_stop_(_bar_) 
      Bool(_bar_\page\pos >= _bar_\page\end) 
    EndMacro
    
    Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_ = #True)
      (Bool(_inverted_) * (_bar_\page\end - (_scroll_pos_ - _bar_\min)) + Bool(Not _inverted_) * (_scroll_pos_))
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
      _child_\parent\x[#__c_required] = _child_\x 
      _child_\parent\y[#__c_required] = _child_\y
      _child_\parent\width[#__c_required] = _child_\x + _child_\width - _child_\parent\x[#__c_required]
      _child_\parent\height[#__c_required] = _child_\y + _child_\height - _child_\parent\y[#__c_required]
      
      PushListPosition(Widget())
      ForEach Widget()
        If Widget()\parent = _child_\parent
          If _child_\parent\x[#__c_required] > Widget()\x 
            _child_\parent\x[#__c_required] = Widget()\x 
          EndIf
          If _child_\parent\y[#__c_required] > Widget()\y 
            _child_\parent\y[#__c_required] = Widget()\y 
          EndIf
        EndIf
      Next
      ForEach Widget()
        If Widget()\parent = _child_\parent
          If _child_\parent\width[#__c_required] < Widget()\x + Widget()\width - _child_\parent\x[#__c_required] 
            _child_\parent\width[#__c_required] = Widget()\x + Widget()\width - _child_\parent\x[#__c_required] 
          EndIf
          If _child_\parent\height[#__c_required] < Widget()\y + Widget()\height - _child_\parent\y[#__c_required] 
            _child_\parent\height[#__c_required] = Widget()\y + Widget()\height - _child_\parent\y[#__c_required] 
          EndIf
        EndIf
      Next
      PopListPosition(Widget())
      
      If widget::Updates(_child_\parent, _child_\parent\x[#__c_inner], _child_\parent\y[#__c_inner], _child_\parent\width[#__c_draw], _child_\parent\height[#__c_draw])
        
        _child_\parent\width[#__c_inner] = _child_\parent\scroll\h\bar\page\len
        _child_\parent\height[#__c_inner] = _child_\parent\scroll\v\bar\page\len
        
        If _child_\parent\container And _child_\parent\count\childrens
          PushListPosition(Widget())
          ForEach Widget()
            If Widget()\parent = _child_\parent
              Clip(Widget(), #True)
            EndIf
          Next
          PopListPosition(Widget())
        EndIf
      EndIf
      
    EndMacro
    
    
    ;- 
    ;- 
    ;-   DECLAREs
    ;{
    Declare.i Tree_Properties(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare  SetClass(*this, class.s)
    
    Declare a_add(*this)
    Declare a_get(*this)
    Declare a_set(*this, Size.l = 5, Pos.l = -1)
    Declare a_events(eventtype.i)
    
    Declare   SetFocus(*this)
    ;Declare   Focused()
    
    Declare   Child(*this, *parent)
    Declare.l X(*this, mode.l = #__c_frame)
    Declare.l Y(*this, mode.l = #__c_frame)
    Declare.l Width(*this, mode.l = #__c_frame)
    Declare.l Height(*this, mode.l = #__c_frame)
    Declare.l GetMouseX(*this, mode.l = #__c_screen)
    Declare.l GetMouseY(*this, mode.l = #__c_screen)
    
    Declare.b Draw(*this)
    Declare   ReDraw(*this)
    Declare   SetImage(*this, *image)
    
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
    Declare.l GetCount(*this, mode.b = #False)
    Declare.i GetParent(*this)
    Declare.i GetItem(*this, parent_sublevel.l =- 1)
    
    Declare.i SetActive(*this)
    
    Declare.b Disable(*this, State.b = -1)
    Declare.b Hide(*this, State.b = -1)
    Declare.b Update(*this)
    ; Declare.b SetPos(*this, ThumbPos.i)
    Declare.b Change(*this, ScrollPos.f)
    Declare.b Resize(*this, ix.l,iy.l,iwidth.l,iheight.l)
    
    
    Declare.l CountItems(*this)
    Declare.l ClearItems(*this)
    Declare   RemoveItem(*this, Item.l) 
    
    Declare   GetWidget(index)
    
    Declare.s GetText(*this)
    Declare   SetText(*this, text.s)
    
    Declare.f GetState(*this)
    Declare.b SetState(*this, state.f)
    
    Declare.i GetItemAttribute(*this, Item.l,  Attribute.l, Column.l = 0)
    Declare.i SetItemAttribute(*this, Item.l, Attribute.l, *value, Column.l = 0)
    
    Declare.i GetItemData(*this, item.l)
    Declare.i SetItemData(*this, item.l, *data)
    
    Declare.s GetItemText(*this, Item.l, Column.l = 0)
    Declare.l SetItemText(*this, Item.l, Text.s, Column.l = 0)
    
    Declare.i GetItemImage(*this, Item.l)
    Declare.i SetItemImage(*this, Item.l, Image.i)
    
    Declare.i GetItemFont(*this, Item.l)
    Declare.i SetItemFont(*this, Item.l, Font.i)
    
    Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l = 0)
    Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l = 0)
    
    Declare.l GetItemState(*this, Item.l)
    Declare.b SetItemState(*this, Item.l, State.b)
    
    Declare.l GetAttribute(*this, Attribute.l)
    Declare.l SetAttribute(*this, Attribute.l, *value)
    
    Declare.i SetAlignment(*this, Mode.l, Type.l = 1)
    Declare.i SetData(*this, *data)
    Declare   SetParent(*this, *parent, _item.l = 0)
    
    Declare   GetPosition(*this, position.l)
    Declare   SetPosition(*this, position.l, *widget_2 = #Null)
    
    Declare.l GetColor(*this, ColorType.l)
    Declare.l SetColor(*this, ColorType.l, Color.l)
    
    Declare.i GetFont(*this)
    Declare.i SetFont(*this, FontID.i)
    
    Declare   Flag(*this, flag.i=#Null, state.b =- 1)
    Declare.i Create(type.l, *parent, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i = 0, round.l = 7, ScrollStep.f = 1.0)
    
    ; button
    Declare.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
    Declare.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
    Declare.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0)
    Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
    Declare.i CheckBox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
    Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i = 0)
    
    ; bar
    ;Declare.i Area(*parent, ScrollStep, AreaWidth, AreaHeight, Width, Height, Mode = 1)
    Declare.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, increment.f = 1.0)
    Declare.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
    Declare.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
    Declare.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7)
    Declare.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0)
    Declare.i Splitter(x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i = 0)
    
    ; list
    Declare.i Tree(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i ListView(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i = 0, round.i = 0)
    
    Declare.i Image(x.l,y.l,width.l,height.l, image.l, Flag.i = 0)
    
    ; container
    Declare.i Panel(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Container(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0)
    Declare.i Window(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, *parent = 0)
    Declare.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0)
    Declare.i MDI(x.l,y.l,width.l,height.l, Flag.i = 0) 
    
    ; menu
    Declare   ToolBar(*parent, flag.i = #PB_ToolBar_Small)
    ;     Declare   Menus(*parent, flag.i)
    ;     Declare   PopupMenu(*parent, flag.i)
    
    Declare   CallBack()
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l = 0)
    
    Declare   Updates(*this, x.l,y.l,width.l,height.l)
    Declare   Resizes(*this, x.l,y.l,width.l,height.l)
    Declare   AddItem(*this, Item.l, Text.s, Image.i = -1, flag.i = 0)
    Declare   AddColumn(*this, Position.l, Text.s, Width.l, Image.i=-1)
    
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    
    Declare   Free(*this)
    Declare.i Bind(*this, *callback, eventtype.l = #PB_All)
    Declare.i Post(eventtype.l, *this, eventitem.l = #PB_All, *data = 0)
    
    Declare   Events(*this, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
    Declare   Open(Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, Flag.i = #Null, *callback = #Null, Canvas = #PB_Any)
    Declare.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  window = -1, *CallBack = #Null)
    ;}
    
  EndDeclareModule
  
  Module widget
    Procedure   CreateIcon(img.l, type.l)
      Protected x,y,Pixel, size = 8, index.i
      
      index = CreateImage(img, size, size) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing(ImageOutput(img))
        Box(0, 0, size, size, $fff0f0f0);GetSysColor_(#COLOR_bTNFACE))
        
        If type = 1
          Restore img_arrow_down
          For y = 0 To size - 1
            For x = 0 To size - 1
              Read.b Pixel
              
              If Pixel
                Plot(x, y, $000000)
              EndIf
            Next x
          Next y
          
        ElseIf type = 2
          Restore img_arrow_down
          For y = size - 1 To 0 Step -1
            For x = 0 To size - 1
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
        
        :                                               : Plot(x + 3, y + 1, color)                        
        :                       : Plot(x + 2, y + 2, color) : Plot(x + 4, y + 1, color)                     
        :                       : Plot(x + 3, y + 2, color) : Plot(x + 5, y + 1, color)
        : Plot(x + 1, y + 3, color) : Plot(x + 4, y + 2, color)
        : Plot(x + 2, y + 3, color)                                                                       
        : Plot(x + 3, y + 3, color) : Plot(x + 2, y + 4, color)                          
        :                       : Plot(x + 3, y + 4, color)     
        :                       : Plot(x + 4, y + 4, color) : Plot(x + 3, y + 5, color) 
        :                                               : Plot(x + 4, y + 5, color)                       
        :                                               : Plot(x + 5, y + 5, color)  
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
        
        :                                               : Plot(x + 3, y + 1, color) 
        :                       : Plot(x + 2, y + 2, color) : Plot(x + 3, y + 2, color) : Plot(x + 4, y + 2, color) 
        : Plot(x + 1, y + 3, color) : Plot(x + 2, y + 3, color) : Plot(x + 3, y + 3, color) : Plot(x + 4, y + 3, color) : Plot(x + 5, y + 3, color)
        : Plot(x + 1, y + 4, color) : Plot(x + 2, y + 4, color)                         : Plot(x + 4, y + 4, color) : Plot(x + 5, y + 4, color)
        : Plot(x + 1, y + 5, color)                                                                         : Plot(x + 5, y + 5, color)
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
        
        : Plot(x + 1, y + 1, color)                        
        : Plot(x + 2, y + 1, color) : Plot(x + 2, y + 2, color)                      
        : Plot(x + 3, y + 1, color) : Plot(x + 3, y + 2, color) 
        :                       : Plot(x + 4, y + 2, color) : Plot(x + 3, y + 3, color)
        :                                               : Plot(x + 4, y + 3, color)                        
        :                       : Plot(x + 2, y + 4, color) : Plot(x + 5, y + 3, color)                          
        :                       : Plot(x + 3, y + 4, color)     
        : Plot(x + 1, y + 5, color) : Plot(x + 4, y + 4, color)
        : Plot(x + 2, y + 5, color)                       
        : Plot(x + 3, y + 5, color)  
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
        
        : Plot(x + 1, y + 1, color)                                                                         : Plot(x + 5, y + 1, color)
        : Plot(x + 1, y + 2, color) : Plot(x + 2, y + 2, color)                         : Plot(x + 4, y + 2, color) : Plot(x + 5, y + 2, color)
        : Plot(x + 1, y + 3, color) : Plot(x + 2, y + 3, color) : Plot(x + 3, y + 3, color) : Plot(x + 4, y + 3, color) : Plot(x + 5, y + 3, color)
        :                       : Plot(x + 2, y + 4, color) : Plot(x + 3, y + 4, color) : Plot(x + 4, y + 4, color)
        :                                               : Plot(x + 3, y + 5, color)
      EndIf
      
    EndProcedure
    
    Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
      ; ProcedureReturn DrawArrow(x,y, Direction, Color)
      
      Protected I
      ;Size - 2
      
      If Not Length
        Style =- 1
      EndIf
      Length = (Size + 2)/2
      
      
      If Direction = 1 ; top
        If Style > 0 : x - 1 : y + 2
          Size / 2
          For i = 0 To Size 
            LineXY((X + 1 + i) + Size,(Y + i - 1) - (Style),(X + 1 + i) + Size,(Y + i - 1) + (Style),Color)         ; Левая линия
            LineXY(((X + 1 + (Size)) - i),(Y + i - 1) - (Style),((X + 1 + (Size)) - i),(Y + i - 1) + (Style),Color) ; правая линия
          Next
        Else : x - 1 : y - 1
          For i = 1 To Length 
            If Style =- 1
              LineXY(x + i, (Size + y), x + Length, y, Color)
              LineXY(x + Length*2 - i, (Size + y), x + Length, y, Color)
            Else
              LineXY(x + i, (Size + y) - i/2, x + Length, y, Color)
              LineXY(x + Length*2 - i, (Size + y) - i/2, x + Length, y, Color)
            EndIf
          Next 
          i = Bool(Style =- 1) 
          LineXY(x, (Size + y) + Bool(i = 0), x + Length, y + 1, Color) 
          LineXY(x + Length*2, (Size + y) + Bool(i = 0), x + Length, y + 1, Color) ; bug
        EndIf
      ElseIf Direction = 3 ; bottom
        If Style > 0 : x - 1 : y + 1;2
          Size / 2
          For i = 0 To Size
            LineXY((X + 1 + i),(Y + i) - (Style),(X + 1 + i),(Y + i) + (Style),Color) ; Левая линия
            LineXY(((X + 1 + (Size*2)) - i),(Y + i) - (Style),((X + 1 + (Size*2)) - i),(Y + i) + (Style),Color) ; правая линия
          Next
        Else : x - 1 : y + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY(x + i, y, x + Length, (Size + y), Color)
              LineXY(x + Length*2 - i, y, x + Length, (Size + y), Color)
            Else
              LineXY(x + i, y + i/2 - Bool(i = 0), x + Length, (Size + y), Color)
              LineXY(x + Length*2 - i, y + i/2 - Bool(i = 0), x + Length, (Size + y), Color)
            EndIf
          Next
        EndIf
      ElseIf Direction = 0 ; в лево
        If Style > 0 : y - 1
          Size / 2
          For i = 0 To Size 
            ; в лево
            LineXY(((X + 1) + i) - (Style),(((Y + 1) + (Size)) - i),((X + 1) + i) + (Style),(((Y + 1) + (Size)) - i),Color) ; правая линия
            LineXY(((X + 1) + i) - (Style),((Y + 1) + i) + Size,((X + 1) + i) + (Style),((Y + 1) + i) + Size,Color)         ; Левая линия
          Next  
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style =- 1
              LineXY((Size + x), y + i, x, y + Length, Color)
              LineXY((Size + x), y + Length*2 - i, x, y + Length, Color)
            Else
              LineXY((Size + x) - i/2, y + i, x, y + Length, Color)
              LineXY((Size + x) - i/2, y + Length*2 - i, x, y + Length, Color)
            EndIf
          Next 
          i = Bool(Style =- 1) 
          LineXY((Size + x) + Bool(i = 0), y, x + 1, y + Length, Color) 
          LineXY((Size + x) + Bool(i = 0), y + Length*2, x + 1, y + Length, Color)
        EndIf
      ElseIf Direction = 2 ; в право
        If Style > 0 : y - 1 ;: x + 1
          Size / 2
          For i = 0 To Size 
            ; в право
            LineXY(((X + 1) + i) - (Style),((Y + 1) + i),((X + 1) + i) + (Style),((Y + 1) + i),Color) ; Левая линия
            LineXY(((X + 1) + i) - (Style),(((Y + 1) + (Size*2)) - i),((X + 1) + i) + (Style),(((Y + 1) + (Size*2)) - i),Color) ; правая линия
          Next
        Else : y - 1 : x + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY(x, y + i, Size + x, y + Length, Color)
              LineXY(x, y + Length*2 - i, Size + x, y + Length, Color)
            Else
              LineXY(x + i/2 - Bool(i = 0), y + i, Size + x, y + Length, Color)
              LineXY(x + i/2 - Bool(i = 0), y + Length*2 - i, Size + x, y + Length, Color)
            EndIf
          Next
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i Match(*value, Grid.i, Max.i = $7FFFFFFF)
      If Grid 
        *value = Round((*value/Grid), #PB_Round_Nearest) * Grid 
        If *value>Max 
          *value = Max 
        EndIf
      EndIf
      
      ProcedureReturn *value
      ;   Procedure.i Match(*value.i, Grid.i, Max.i = $7FFFFFFF)
      ;     ProcedureReturn ((Bool(*value>Max) * Max) + (Bool(Grid And *value<Max) * (Round((*value/Grid), #PB_round_nearest) * Grid)))
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
      Protected Color, Dot.b = 4, line.b = 10, Length.b = (Line + Dot*2 + 1)
      Static Len.b
      
      If ((Len%Length)<line Or (Len%Length) = (line + Dot))
        If (Len>(Line + Dot)) : Len = 0 : EndIf
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      Len + 1
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
    ;-  ANCHORs
    Macro a_draw(_this_)
      If *this\root And
         Transform() And 
         Transform()\widget And 
         Not Transform()\widget\hide
        
        ;UnclipOutput()
        ClipOutput(Transform()\main\x[#__c_clip],Transform()\main\y[#__c_clip],Transform()\main\width[#__c_clip],Transform()\main\height[#__c_clip])
        
        DrawingMode(#PB_2DDrawing_Outlined)
        If Transform()\id[1] : Box(Transform()\id[1]\x, Transform()\id[1]\y, Transform()\id[1]\width, Transform()\id[1]\height ,Transform()\id[1]\color[Transform()\id[1]\color\state]\frame) : EndIf
        If Transform()\id[2] : Box(Transform()\id[2]\x, Transform()\id[2]\y, Transform()\id[2]\width, Transform()\id[2]\height ,Transform()\id[2]\color[Transform()\id[2]\color\state]\frame) : EndIf
        If Transform()\id[3] : Box(Transform()\id[3]\x, Transform()\id[3]\y, Transform()\id[3]\width, Transform()\id[3]\height ,Transform()\id[3]\color[Transform()\id[3]\color\state]\frame) : EndIf
        If Transform()\id[4] : Box(Transform()\id[4]\x, Transform()\id[4]\y, Transform()\id[4]\width, Transform()\id[4]\height ,Transform()\id[4]\color[Transform()\id[4]\color\state]\frame) : EndIf
        If Transform()\id[5] : Box(Transform()\id[5]\x, Transform()\id[5]\y, Transform()\id[5]\width, Transform()\id[5]\height ,Transform()\id[5]\color[Transform()\id[5]\color\state]\frame) : EndIf
        If Transform()\id[6] : Box(Transform()\id[6]\x, Transform()\id[6]\y, Transform()\id[6]\width, Transform()\id[6]\height ,Transform()\id[6]\color[Transform()\id[6]\color\state]\frame) : EndIf
        If Transform()\id[7] : Box(Transform()\id[7]\x, Transform()\id[7]\y, Transform()\id[7]\width, Transform()\id[7]\height ,Transform()\id[7]\color[Transform()\id[7]\color\state]\frame) : EndIf
        If Transform()\id[8] : Box(Transform()\id[8]\x, Transform()\id[8]\y, Transform()\id[8]\width, Transform()\id[8]\height ,Transform()\id[8]\color[Transform()\id[8]\color\state]\frame) : EndIf
        ;If Transform()\id[#__a_moved] : Box(Transform()\id[#__a_moved]\x, Transform()\id[#__a_moved]\y, Transform()\id[#__a_moved]\width, Transform()\id[#__a_moved]\height ,Transform()\id[#__a_moved]\color[Transform()\id[#__a_moved]\color\state]\frame) : EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        If Transform()\id[10] : Box(Transform()\id[10]\x, Transform()\id[10]\y, Transform()\id[10]\width, Transform()\id[10]\height ,Transform()\id[10]\color[Transform()\id[10]\color\state]\frame) : EndIf
        If Transform()\id[11] : Box(Transform()\id[11]\x, Transform()\id[11]\y, Transform()\id[11]\width, Transform()\id[11]\height ,Transform()\id[11]\color[Transform()\id[11]\color\state]\frame) : EndIf
        If Transform()\id[12] : Box(Transform()\id[12]\x, Transform()\id[12]\y, Transform()\id[12]\width, Transform()\id[12]\height ,Transform()\id[12]\color[Transform()\id[12]\color\state]\frame) : EndIf
        If Transform()\id[13] : Box(Transform()\id[13]\x, Transform()\id[13]\y, Transform()\id[13]\width, Transform()\id[13]\height ,Transform()\id[13]\color[Transform()\id[13]\color\state]\frame) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        If Transform()\id[1] : Box(Transform()\id[1]\x + 1, Transform()\id[1]\y + 1, Transform()\id[1]\width - 2, Transform()\id[1]\height - 2 ,Transform()\id[1]\color[Transform()\id[1]\color\state]\back) : EndIf
        If Transform()\id[2] : Box(Transform()\id[2]\x + 1, Transform()\id[2]\y + 1, Transform()\id[2]\width - 2, Transform()\id[2]\height - 2 ,Transform()\id[2]\color[Transform()\id[2]\color\state]\back) : EndIf
        If Transform()\id[3] : Box(Transform()\id[3]\x + 1, Transform()\id[3]\y + 1, Transform()\id[3]\width - 2, Transform()\id[3]\height - 2 ,Transform()\id[3]\color[Transform()\id[3]\color\state]\back) : EndIf
        If Transform()\id[4] : Box(Transform()\id[4]\x + 1, Transform()\id[4]\y + 1, Transform()\id[4]\width - 2, Transform()\id[4]\height - 2 ,Transform()\id[4]\color[Transform()\id[4]\color\state]\back) : EndIf
        If Transform()\id[5] And 
           Not Transform()\widget\container : Box(Transform()\id[5]\x + 1, Transform()\id[5]\y + 1, Transform()\id[5]\width - 2, Transform()\id[5]\height - 2 ,Transform()\id[5]\color[Transform()\id[5]\color\state]\back) : EndIf
        If Transform()\id[6] : Box(Transform()\id[6]\x + 1, Transform()\id[6]\y + 1, Transform()\id[6]\width - 2, Transform()\id[6]\height - 2 ,Transform()\id[6]\color[Transform()\id[6]\color\state]\back) : EndIf
        If Transform()\id[7] : Box(Transform()\id[7]\x + 1, Transform()\id[7]\y + 1, Transform()\id[7]\width - 2, Transform()\id[7]\height - 2 ,Transform()\id[7]\color[Transform()\id[7]\color\state]\back) : EndIf
        If Transform()\id[8] : Box(Transform()\id[8]\x + 1, Transform()\id[8]\y + 1, Transform()\id[8]\width - 2, Transform()\id[8]\height - 2 ,Transform()\id[8]\color[Transform()\id[8]\color\state]\back) : EndIf
        
      EndIf
    EndMacro
    
    Macro a_move(_this_)
      If Transform()\id[1] ; left
        Transform()\id[1]\x = _this_\x
        Transform()\id[1]\y = _this_\y + (_this_\height - Transform()\id[1]\height)/2
      EndIf
      If Transform()\id[2] ; top
        Transform()\id[2]\x = _this_\x + (_this_\width - Transform()\id[2]\width)/2
        Transform()\id[2]\y = _this_\y
      EndIf
      If  Transform()\id[3] ; right
        Transform()\id[3]\x = _this_\x + _this_\width - Transform()\id[3]\width 
        Transform()\id[3]\y = _this_\y + (_this_\height - Transform()\id[3]\height)/2
      EndIf
      If Transform()\id[4] ; bottom
        Transform()\id[4]\x = _this_\x + (_this_\width - Transform()\id[4]\width)/2
        Transform()\id[4]\y = _this_\y + _this_\height - Transform()\id[4]\height
      EndIf
      
      If Transform()\id[5] ; left&top
        Transform()\id[5]\x = _this_\x
        Transform()\id[5]\y = _this_\y
      EndIf
      If Transform()\id[6] ; right&top
        Transform()\id[6]\x = _this_\x + _this_\width - Transform()\id[6]\width
        Transform()\id[6]\y = _this_\y
      EndIf
      If Transform()\id[7] ; right&bottom
        Transform()\id[7]\x = _this_\x + _this_\width - Transform()\id[7]\width
        Transform()\id[7]\y = _this_\y + _this_\height - Transform()\id[7]\height
      EndIf
      If Transform()\id[8] ; left&bottom
        Transform()\id[8]\x = _this_\x
        Transform()\id[8]\y = _this_\y + _this_\height - Transform()\id[8]\height
      EndIf
      
      If Transform()\id[#__a_moved] 
        Transform()\id[#__a_moved]\x = _this_\x[#__c_frame]
        Transform()\id[#__a_moved]\y = _this_\y[#__c_frame]
        Transform()\id[#__a_moved]\width = _this_\width[#__c_frame]
        Transform()\id[#__a_moved]\height = _this_\height[#__c_frame]
      EndIf
      
      If Transform()\id[10] And 
         Transform()\id[11] And
         Transform()\id[12] And
         Transform()\id[13]
        a_lines(_this_)
      EndIf
      
    EndMacro
    
    Procedure   a_lines(*this._s_widget = -1, distance = 0)
      Protected ls = 1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
      Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
      
      With *this
        If *this
          checked_x1 = *this\x[#__c_frame]
          checked_y1 = *this\y[#__c_frame]
          checked_x2 = checked_x1 + *this\width[#__c_frame]
          checked_y2 = checked_y1 + *this\height[#__c_frame]
          
          top_x1 = checked_x1 : top_x2 = checked_x2
          left_y1 = checked_y1 : left_y2 = checked_y2 
          right_y1 = checked_y1 : right_y2 = checked_y2
          bottom_x1 = checked_x1 : bottom_x2 = checked_x2
          
          Transform()\id[10]\color\state = 0
          Transform()\id[10]\x = checked_x1
          Transform()\id[10]\y = checked_y1
          Transform()\id[10]\width = ls
          Transform()\id[10]\height = checked_y2 - checked_y1
          
          Transform()\id[12]\color\state = 0
          Transform()\id[12]\x = checked_x2 - ls
          Transform()\id[12]\y = checked_y1
          Transform()\id[12]\width = ls
          Transform()\id[12]\height = checked_y2 - checked_y1
          
          Transform()\id[11]\color\state = 0
          Transform()\id[11]\x = checked_x1
          Transform()\id[11]\y = checked_y1
          Transform()\id[11]\width = checked_x2 - checked_x1
          Transform()\id[11]\height = ls
          
          Transform()\id[13]\color\state = 0
          Transform()\id[13]\x = checked_x1
          Transform()\id[13]\y = checked_y2 - ls
          Transform()\id[13]\width = checked_x2 - checked_x1
          Transform()\id[13]\height = ls
          
          If *this\parent And ListSize(Widget())
            PushListPosition(Widget())
            ForEach Widget()
              If *this <> Widget() And
                 Not Widget()\hide And
                 Widget()\mode\transform And
                 Widget()\parent = *this\parent
                
                relative_x1 = Widget()\x[#__c_frame]
                relative_y1 = Widget()\y[#__c_frame]
                relative_x2 = relative_x1 + Widget()\width[#__c_frame]
                relative_y2 = relative_y1 + Widget()\height[#__c_frame]
                
                ;Left_line
                If checked_x1 = relative_x1
                  If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                  If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                  
                  Transform()\id[10]\color\state = 2
                  Transform()\id[10]\x = checked_x1
                  Transform()\id[10]\y = left_y1
                  Transform()\id[10]\width = ls
                  Transform()\id[10]\height = left_y2 - left_y1
                  
                EndIf
                
                ;Right_line
                If checked_x2 = relative_x2
                  If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                  If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                  
                  Transform()\id[12]\color\state = 2
                  Transform()\id[12]\x = checked_x2 - ls
                  Transform()\id[12]\y = right_y1
                  Transform()\id[12]\width = ls
                  Transform()\id[12]\height = right_y2 - right_y1
                  
                EndIf
                
                ;Top_line
                If checked_y1 = relative_y1 
                  If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                  If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                  
                  Transform()\id[11]\color\state = 1
                  Transform()\id[11]\x = top_x1
                  Transform()\id[11]\y = checked_y1
                  Transform()\id[11]\width = top_x2 - top_x1
                  Transform()\id[11]\height = ls
                  
                EndIf
                
                ;Bottom_line
                If checked_y2 = relative_y2 
                  If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                  If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                  
                  Transform()\id[13]\color\state = 1
                  Transform()\id[13]\x = bottom_x1
                  Transform()\id[13]\y = checked_y2 - ls
                  Transform()\id[13]\width = bottom_x2 - bottom_x1
                  Transform()\id[13]\height = ls
                  
                EndIf
              EndIf
            Next
            PopListPosition(Widget())
            
            
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i a_Add(*this._s_widget)
      Structure DataBuffer
        cursor.i[#__anchors + 1]
      EndStructure
      
      Protected i, *Cursor.DataBuffer = ?CursorsBuffer
      
      With *this
        If Not *this\mode\transform
          *this\mode\transform = #True
          
          If Not Transform()
            InitTransform()
            
            Transform()\main = *this
            Transform()\index = #__a_moved
            
            For i = 0 To #__anchors
              Transform()\id[i]\cursor = *Cursor\cursor[i]
              
              Transform()\id[i]\color[0]\frame = $ff000000
              Transform()\id[i]\color[1]\frame = $ffFF0000
              Transform()\id[i]\color[2]\frame = $ff0000FF
              
              Transform()\id[i]\color[0]\back = $ffFFFFFF
              Transform()\id[i]\color[1]\back = $ffFFFFFF
              Transform()\id[i]\color[2]\back = $ffFFFFFF
            Next i
          EndIf
        EndIf
      EndWith
      
      ;;;;;;;;;;;;;;
      a_set(*this)
      
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
    
    Procedure.i a_get(*this._s_widget)
      ProcedureReturn Bool(Transform()\widget = *this) * Transform()\widget
    EndProcedure
    
    Procedure.i a_set(*this._s_widget, Size.l = 5, Pos.l = -1)
      Protected Result.i
      Static *LastPos
      
      If *this\mode\transform And 
         Transform()\main <> *this And 
         Transform()\widget <> *this
        *this\cursor = #PB_Cursor_Default
        ;Debug ""+Transform()\main +" "+ *this
        
        ;         If Transform()\widget
        ;           If *LastPos
        ;             ; ?????????? ?? ?????
        ;             SetPosition(Transform()\widget, #PB_list_before, *LastPos)
        ;             *LastPos = 0
        ;           EndIf
        ;         EndIf
        ;         
        ;         *LastPos = GetPosition(*this, #PB_list_after)
        ;         If *LastPos
        ;           SetPosition(*this, #PB_list_last)
        ;         EndIf
        
        
        ;         ;If *this\repaint
        ;         If Transform()\widget
        ;           Post(#PB_EventType_LostFocus, Transform()\widget, Transform()\index)
        ;         EndIf
        ;         Post(#PB_EventType_Focus, *this, Transform()\index)
        ;         ;EndIf
        
        Transform()\size = 5 + *this\fs
        Transform()\Pos = (Transform()\size-*this\fs) - (Transform()\size-*this\fs) / 3 - 1
        *this\bs = Transform()\pos + *this\fs
        
        
        Transform()\id[1]\width = Transform()\size
        Transform()\id[1]\height = Transform()\size
        
        Transform()\id[2]\width = Transform()\size
        Transform()\id[2]\height = Transform()\size
        
        Transform()\id[3]\width = Transform()\size
        Transform()\id[3]\height = Transform()\size
        
        Transform()\id[4]\width = Transform()\size
        Transform()\id[4]\height = Transform()\size
        
        Transform()\id[6]\width = Transform()\size
        Transform()\id[6]\height = Transform()\size
        
        Transform()\id[7]\width = Transform()\size
        Transform()\id[7]\height = Transform()\size
        
        Transform()\id[8]\width = Transform()\size
        Transform()\id[8]\height = Transform()\size
        
        If *this\container
          Transform()\id[5]\width = Transform()\size * 2
          Transform()\id[5]\height = Transform()\size * 2
        Else
          Transform()\id[5]\width = Transform()\size
          Transform()\id[5]\height = Transform()\size
        EndIf
        
        
        If Transform()\widget
          Result = Transform()\widget
        Else
          Result =- 1
        EndIf
        
        Transform()\widget = *this
        a_move(*this)
        Post(#PB_EventType_StatusChange, *this, Transform()\index)
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   a_events(eventtype.i)
      Static xx, yy
      Protected result, i, mouse_x.i, mouse_y.i 
      Protected mxw, myh
      Protected.l mx, my, mw, mh
      Protected.l Px,Py, Grid = 5, IsGrid = Bool(Grid>1)
      
      Macro a_index(_result_, _index_)
        ; From point anchor
        For _index_ = 0 To #__a_moved;#__anchors ; To 0 Step - 1
          If Transform()\id[_index_] And _from_point_(mouse_x, mouse_y, Transform()\id[_index_]) 
            If Transform()\id[_index_]\color\state <> #__s_1
              If _index_ <> #__a_moved
                If Transform()\widget\container And _index_ = 5
                  SetCursor(Transform()\widget, Transform()\id[#__a_moved]\cursor)
                Else
                  SetCursor(Transform()\widget, Transform()\id[_index_]\cursor)
                EndIf
              EndIf
              
              Transform()\id[_index_]\color\state = #__s_1
              _result_ = 1
            EndIf
            
            Transform()\index = _index_
            Break
            
          ElseIf Transform()\id[_index_]\color\state <> #__s_0
            SetCursor(Transform()\widget, #PB_Cursor_Default)
            Transform()\id[_index_]\color\state = #__s_0
            Transform()\index = #__a_moved
            _result_ = 1
          EndIf
        Next
        
      EndMacro
      
      Macro a_resize(_result_, _index_)
        Select _index_
          Case #__a_moved 
            If Not Transform()\widget\container
              If Transform()\widget\cursor <> Transform()\id[_index_]\cursor
                Transform()\widget\cursor = Transform()\id[_index_]\cursor
                SetCursor(Transform()\widget, Transform()\id[_index_]\cursor)
              EndIf
              
              _result_ = Resize(Transform()\widget, mx, my, #PB_Ignore, #PB_Ignore)
            EndIf
            
          Case 1 : _result_ = Resize(Transform()\widget, mx, #PB_Ignore, mxw, #PB_Ignore)
          Case 2 : _result_ = Resize(Transform()\widget, #PB_Ignore, my, #PB_Ignore, myh)
          Case 3 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, mw, #PB_Ignore)
          Case 4 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, mh)
          Case 5 : _result_ = Resize(Transform()\widget, mx, my, mxw, myh)
          Case 6 : _result_ = Resize(Transform()\widget, #PB_Ignore, my, mw, myh)
          Case 7 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, mw, mh)
          Case 8 : _result_ = Resize(Transform()\widget, mx, #PB_Ignore, mxw, mh)
        EndSelect
      EndMacro
      
      If Transform() 
        mouse_x = Mouse()\x
        mouse_y = Mouse()\y
        
        Select eventtype 
          Case #__Event_MouseMove
            If Transform()\id[Transform()\index]\color\state = #__s_2
              ;{ widget transform
              If Transform()\widget\parent
                Px = Transform()\widget\parent\x[#__c_inner]
                Py = Transform()\widget\parent\y[#__c_inner]
              EndIf
              
              mouse_x - Mouse()\delta\x
              mouse_y - Mouse()\delta\y
              
              mx = Match(mouse_x - Px + Transform()\pos, Grid)
              my = Match(mouse_y - Py + Transform()\pos, Grid)
              
              If xx <> mx Or yy <> my
                xx = mx
                yy = my
                
                If (Transform()\index = #__a_moved) Or
                   (Transform()\index = 5 And Transform()\widget\container) ; Form, Container, ScrollArea, Panel
                  mxw = #PB_Ignore
                  myh = #PB_Ignore
                Else
                  mxw = Transform()\widget\x[#__c_draw] + Transform()\widget\width[#__c_frame] - mx
                  myh = Transform()\widget\y[#__c_draw] + Transform()\widget\height[#__c_frame] - my
                EndIf
                
                mw = mx - Transform()\widget\x[#__c_draw] ; + IsGrid 
                mh = Match(mouse_y - Transform()\widget\y, Grid) ; + IsGrid 
                
                a_resize(result, Transform()\index)
              EndIf
              ;}
              
            ElseIf Not Mouse()\Buttons
              a_index(result, i)
              
            EndIf
            
          Case #__Event_leftButtonDown  
            ;Debug 
            If Entered()\mode\transform 
              If Transform()\id[Transform()\index]\color\state <> #__s_2
                If Not (_from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index]) And Transform()\index <> #__a_moved)
                  If a_set(Entered())
                    a_index(result, i)
                    ; Post(#PB_EventType_StatusChange, Entered(), Transform()\index)
                  EndIf
                EndIf
                
                If _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
                  Transform()\id[Transform()\index]\color\state = #__s_2
                EndIf
                
                ;get anchor delta pos
                If (Transform()\index = #__a_moved) Or
                   (Transform()\index = 5 And Entered()\container) ; Form, Container, ScrollArea, Panel 
                  Mouse()\delta\x = mouse_x - Entered()\x          ;[#__c_frame]
                  Mouse()\delta\y = mouse_y - Entered()\y          ;[#__c_frame]
                Else
                  Mouse()\delta\x = mouse_x - Transform()\id[Transform()\index]\x
                  Mouse()\delta\y = mouse_y - Transform()\id[Transform()\index]\y
                EndIf
              EndIf
              
              result = 1
            EndIf
            
          Case #__Event_leftButtonUp
            If Transform()\widget\mode\transform
              If Transform()\widget\cursor = #PB_Cursor_Arrows Or
                 Not _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
                Transform()\widget\cursor = #PB_Cursor_Default
                SetCursor(Transform()\widget, Transform()\widget\cursor)
              EndIf
              
              Transform()\id[Transform()\index]\color\state = #__s_0
              ;Transform()\index = #__a_moved
              result = 1
            EndIf
            
          Case #PB_EventType_KeyUp
            ;             Selected = #False
            
          Case #PB_EventType_KeyDown
            If Transform()\widget
              mx = Transform()\widget\x[#__c_draw]
              my = Transform()\widget\y[#__c_draw]
              mw = Transform()\widget\width[#__c_frame]
              mh = Transform()\widget\height[#__c_frame]
              
              Select Keyboard()\Key[1] 
                Case #PB_Canvas_Shift
                  Select Keyboard()\Key
                    Case #PB_Shortcut_Left  : mw - Grid : Transform()\index = 3  
                    Case #PB_Shortcut_Right : mw + Grid : Transform()\index = 3
                      
                    Case #PB_Shortcut_Up    : mh - Grid : Transform()\index = 4
                    Case #PB_Shortcut_Down  : mh + Grid : Transform()\index = 4
                  EndSelect
                  
                  ;                 If xx <> mx Or yy <> my
                  ;                   xx = mx
                  ;                   yy = my
                  
                  a_resize(result, Transform()\index)
                  ;                 EndIf
                  
                Case #PB_Canvas_Shift|#PB_Canvas_Control ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control|#PB_Canvas_Command
                  Select Keyboard()\Key
                    Case #PB_Shortcut_Left  : mx - Grid
                    Case #PB_Shortcut_Right : mx + Grid
                      
                    Case #PB_Shortcut_Up    : my - Grid
                    Case #PB_Shortcut_Down  : my + Grid
                  EndSelect
                  
                  If xx <> mx Or yy <> my
                    xx = mx
                    yy = my
                    
                    If Transform()\widget\container
                      Transform()\index = 5
                      mxw = #PB_Ignore
                      myh = #PB_Ignore
                    Else
                      Transform()\index = #__a_moved
                    EndIf
                    
                    a_resize(result, Transform()\index)
                  EndIf
                  
                Default
                  Select Keyboard()\Key
                      ;                   Case #PB_Shortcut_Left  : mx - Grid
                      ;                   Case #PB_Shortcut_Right : mx + Grid
                      
                    Case #PB_Shortcut_Up   
                      ForEach Widget()
                        If Transform()\widget\index-1 = Widget()\index
                          result = a_set(Widget())
                          Break
                        EndIf
                      Next
                      
                    Case #PB_Shortcut_Down  
                      ForEach Widget()
                        If Transform()\widget\index+1 = Widget()\index
                          result = a_set(Widget())
                          Break
                        EndIf
                      Next
                      
                  EndSelect
                  
              EndSelect
            EndIf
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    
    ;- 
    ;-  PRIVATEs
    ; хочу внедрит
    Macro _drawing_mode_(_mode_)
      If widget()\_drawing <> _mode_
        widget()\_drawing = _mode_
        
        DrawingMode(_mode_)
      EndIf
    EndMacro
    
    Macro _drawing_mode_alpha_(_mode_)
      If widget()\_drawing_alpha <> _mode_
        widget()\_drawing_alpha = _mode_
        
        DrawingMode(_mode_|#PB_2DDrawing_AlphaBlend)
      EndIf
    EndMacro
    
    Macro _drawing_font_(_this_)
      ; drawing font
      ; If Not _this_\hide
      
      If _this_\root\text\fontID[1] <> _this_\text\fontID
        If Not _this_\text\fontID 
          _this_\text\fontID = _this_\root\text\fontID 
        EndIf
        
        _this_\root\text\fontID[1] = _this_\text\fontID
        If _this_\text\fontID[1] <> _this_\text\fontID
          _this_\text\fontID[1] = _this_\text\fontID
          _this_\text\change = #True
        EndIf
        
        DrawingFont(_this_\text\fontID) 
        
        If #debug_draw_font
          Debug "draw current font - " + #PB_Compiler_Procedure  + " " +  _this_  + " " +  _this_\text\change
        EndIf
      EndIf
      
      ; Получаем один раз после изменения текста  
      If _this_\text\change
        If _this_\text\string 
          _this_\text\width = TextWidth(_this_\text\string) 
        EndIf
        
        _this_\text\height = TextHeight("A"); - Bool(#PB_Compiler_OS <> #PB_OS_Windows) * 2
        
        If #debug_draw_font_change
          Debug "change text size - " + #PB_Compiler_Procedure  + " " +  _this_
        EndIf
      EndIf
      
      ; EndIf
    EndMacro
    
    Macro _drawing_font_item_(_this_, _item_, _change_)
      ; drawing item font
      If _this_\root\text\fontID[1] <> _item_\text\fontID
        If Not _item_\text\fontID
          If Not _this_\text\fontID
            _this_\text\fontID = _this_\root\text\fontID
            ;_drawing_font_(_this_)
          EndIf
          
          _item_\text\fontID = _this_\text\fontID
        EndIf
        
        _this_\root\text\fontID[1] = _item_\text\fontID
        If _item_\text\fontID[1] <> _item_\text\fontID
          _item_\text\fontID[1] = _item_\text\fontID
          _item_\text\change = #True
        EndIf
        DrawingFont(_item_\text\fontID) 
      EndIf
      
      ; Получаем один раз после изменения текста  
      If  _item_\text\change; _change_
        If _item_\text\string
          _item_\text\width = TextWidth(_item_\text\string) 
        EndIf
        _item_\text\height = TextHeight("A") 
        _item_\text\change = #False
        
        If #debug_draw_item_font_change
          Debug "item change text size - " + #PB_Compiler_Procedure  + " " +  _item_\index
        EndIf
      EndIf 
    EndMacro      
    
    Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_ = 0, _alpha_ = 255)
      BackColor(_color_1_&$FFFFFF|_alpha_<<24)
      FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
      If _type_
        LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
      Else
        LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
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
      Arrow(_x_ + (_width_ - _arrow_size_)/2,_y_ + (_height_ - _arrow_size_)/2, _arrow_size_, _arrow_direction_, _color_arrow_&$FFFFFF|_alpha_<<24, _arrow_type_)
      ResetGradientColors()
    EndMacro
    
    Macro _set_item_image_(_this_, _item_, _image_)
      _item_\img\index = IsImage(_image_)
      
      If _item_\img\index
        If _this_\mode\iconsize
          _item_\img\width = _this_\mode\iconsize
          _item_\img\height = _this_\mode\iconsize
          ResizeImage(_image_, _item_\img\width, _item_\img\height)
        Else
          _item_\img\width = ImageWidth(_image_)
          _item_\img\height = ImageHeight(_image_)
        EndIf  
        
        _item_\img\index[1] = _image_ 
        _item_\img\index[2] = ImageID(_image_)
        
        _this_\row\margin\width = _this_\img\padding\left + _item_\img\width + 2
      Else
        _item_\img\index[1] =- 1
        _item_\img\index[2] = 0
        _item_\img\width = 0
        _item_\img\height = 0
      EndIf
    EndMacro
    
    Macro _repaint_(_this_)
      If _this_\root And Not _this_\repaint : _this_\repaint = 1
        PostEvent(#PB_Event_Gadget, _this_\root\canvas\window, _this_\root\canvas\gadget, #__Event_repaint);, _this_)
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
    
    
    ;-  TEXTs
    Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
      ;If _this_\text\vertical
      If _this_\text\rotate = 90
        ;         If _this_\y<>_y_
        ;           _this_\text\x = _x_ + _this_\y
        ;         Else
        _this_\text\x = _x_ + (_width_ - _this_\text\height)/2
        ;         EndIf
        
        If _this_\text\align\right
          _this_\text\y = _y_  + _this_\text\align\delta\y +  _this_\text\_padding + _this_\text\width
        ElseIf Not _this_\text\align\left
          _this_\text\y = _y_ + (_height_ + _this_\text\align\delta\y + _this_\text\width)/2
        Else
          _this_\text\y = _y_ + _height_ - _this_\text\_padding
        EndIf
        
      ElseIf _this_\text\rotate = 270
        _this_\text\x = _x_ + (_width_ - 4)
        
        If _this_\text\align\right
          _this_\text\y = _y_ + (_height_ - _this_\text\width - _this_\text\_padding) 
        ElseIf Not _this_\text\align\left
          _this_\text\y = _y_ + (_height_ - _this_\text\width)/2 
        Else
          _this_\text\y = _y_ + _this_\text\_padding 
        EndIf
        
      EndIf
      
      ;Else
      If _this_\text\rotate = 0
        ;         If _this_\x<>_x_
        ;           _this_\text\y = _y_ + _this_\y
        ;         Else
        _this_\text\y = _y_ + (_height_ - _this_\text\height)/2
        ;         EndIf
        
        If _this_\text\align\right
          _this_\text\x = _x_ + (_width_ - _this_\text\align\delta\x - _this_\text\width - _this_\text\_padding) 
        ElseIf Not _this_\text\align\left
          _this_\text\x = _x_ + (_width_ - _this_\text\align\delta\x - _this_\text\width)/2
        Else
          _this_\text\x = _x_ + _this_\text\_padding
        EndIf
        
      ElseIf _this_\text\rotate = 180
        _this_\text\y = _y_ + (_height_ - _this_\y)
        
        If _this_\text\align\right
          _this_\text\x = _x_ + _this_\text\_padding + _this_\text\width
        ElseIf Not _this_\text\align\left
          _this_\text\x = _x_ + (_width_ + _this_\text\width)/2 
        Else
          _this_\text\x = _x_ + _width_ - _this_\text\_padding 
        EndIf
        
      EndIf
      ;EndIf
    EndMacro
    
    Macro _set_text_flag_(_this_, _flag_, _x_ = 0, _y_ = 0)
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
        
        ;         ;If constants::_check_(_flag_, #__align_text)
        ;         If (_this_\text\invert And Not _this_\vertical) Or
        ;            (Not _this_\text\invert And _this_\vertical)
        ;           _this_\text\align\right = constants::_check_(_flag_, #__text_left)
        ;           _this_\text\align\left = constants::_check_(_flag_, #__text_right)
        ;           
        ;         Else
        ;           _this_\text\align\left = constants::_check_(_flag_, #__text_left)
        ;           _this_\text\align\right = constants::_check_(_flag_, #__text_right)
        ;         EndIf
        ;         
        ;         If (_this_\text\invert And _this_\vertical) Or
        ;            (_this_\text\invert And Not _this_\vertical)
        ;           _this_\text\align\bottom = constants::_check_(_flag_, #__text_top)
        ;           _this_\text\align\top = constants::_check_(_flag_, #__text_bottom)
        ;         Else
        ;           _this_\text\align\top = constants::_check_(_flag_, #__text_top)
        ;           _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
        ;         EndIf
        
        ;         If _this_\text\invert
        ;           _this_\text\align\right = constants::_check_(_flag_, #__text_left)
        ;           _this_\text\align\left = constants::_check_(_flag_, #__text_right)
        ;           
        ;         Else
        ;           _this_\text\align\left = constants::_check_(_flag_, #__text_left)
        ;           _this_\text\align\right = constants::_check_(_flag_, #__text_right)
        ;         EndIf
        ;         
        ;         If (Not _this_\text\invert And _this_\vertical) Or
        ;            (_this_\text\invert And Not _this_\vertical)
        ;           _this_\text\align\bottom = constants::_check_(_flag_, #__text_top)
        ;           _this_\text\align\top = constants::_check_(_flag_, #__text_bottom)
        ;         Else
        ;           _this_\text\align\top = constants::_check_(_flag_, #__text_top)
        ;           _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
        ;         EndIf
        
        _this_\text\align\left = constants::_check_(_flag_, #__text_left)
        _this_\text\align\right = constants::_check_(_flag_, #__text_right)
        
        _this_\text\align\top = constants::_check_(_flag_, #__text_top)
        _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
        
        
        If Not _flag_ & #__text_center
          ;           _this_\text\align\top = Bool(Not _this_\text\align\bottom)
          ;           _this_\text\align\left = Bool(Not _this_\text\align\right)
          ;           
          If Not _this_\text\align\bottom
            _this_\text\align\top = #True
          EndIf
          
          If Not _this_\text\align\right
            _this_\text\align\left = #True 
          EndIf
        EndIf
        ;EndIf
        
        If constants::_check_(_flag_, #__text_wordwrap)
          _this_\text\multiLine =- 1
        ElseIf constants::_check_(_flag_, #__text_multiline)
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0 
        EndIf
        
        If _this_\text\invert 
          _this_\text\rotate = Bool(_this_\vertical)*270 + Bool(Not _this_\vertical)*180
        Else
          _this_\text\rotate = Bool(_this_\vertical)*90
        EndIf
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
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
        
        ;  _this_\text\fontID = Root()\text\fontID
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;-  BARs
    ;{
    Declare.b Tab_Draw(*this)
    Declare.b Bar_Update(*this)
    Declare.b Bar_SetState(*this, state.f)
    
    Macro Area_Draw(_this_)
      If _this_\scroll
        If Not _this_\scroll\v\hide And _this_\scroll\v\width And _this_\scroll\v\width[#__c_clip] > 0 And _this_\scroll\v\height[#__c_clip] > 0
          Bar_Draw(_this_\scroll\v)
        EndIf
        If Not _this_\scroll\h\hide And _this_\scroll\h\height And _this_\scroll\h\width[#__c_clip] > 0 And _this_\scroll\h\height[#__c_clip] > 0
          Bar_Draw(_this_\scroll\h)
        EndIf
        
        If _this_\scroll\v And _this_\scroll\h
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; Scroll area coordinate
          Box(_this_\scroll\h\x + _this_\x[#__c_required], _this_\scroll\v\y + _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], $FF0000FF)
          
          ; Debug "" +  _this_\x[#__c_required]  + " " +  _this_\y[#__c_required]  + " " +  _this_\width[#__c_required]  + " " +  _this_\height[#__c_required]
          Box(_this_\scroll\h\x - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FFFF0000)
          
          ; page coordinate
          Box(_this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
        EndIf
      EndIf
    EndMacro
    
    Macro Area(_parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True)
      _parent_\scroll\v = Create(#__type_ScrollBar, _parent_, 0,0,#__scroll_buttonsize,0,  0,_area_height_, _height_, #__scroll_buttonsize, #__bar_child|#__bar_vertical, 7, _scroll_step_)
      _parent_\scroll\h = Create(#__type_ScrollBar, _parent_, 0,0,0,#__scroll_buttonsize,  0,_area_width_, _width_, Bool(_mode_)*#__scroll_buttonsize, #__bar_child, 7, _scroll_step_)
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
        
        If *this = *this\parent\gadget[#__panel_1] 
          *this\parent\index[#__panel_2] = State
          
          PushListPosition(Widget())
          ForEach Widget()
            If Child( Widget(), *this\parent)  
              Widget()\hide = Bool(Widget()\hide[1] Or
                                   Widget()\parent\hide Or 
                                   (Widget()\parent\type = #PB_GadgetType_Panel And
                                    Widget()\parent\index[#__panel_2] <> Widget()\_item))
            EndIf
          Next
          PopListPosition(Widget())
          
          Post(#PB_EventType_Change, *this\parent, State)
        Else
          Post(#PB_EventType_Change, *this, State)
        EndIf
        
        *this\bar\fixed = State + 1
        Result = #True
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   Tab_AddItem(*this._s_widget, Item.i, Text.s, Image.i = -1, sublevel.i = 0)
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
            
            If *this\parent\gadget[#__panel_1] = *this
              ; \parent\type = #PB_GadgetType_Panel
              ; PushListPosition(Widget())
              ForEach Widget()
                If Child( Widget(), *this\parent)
                  If Widget()\parent = *this\parent And 
                     Widget()\_item = Item
                    Widget()\_item + 1
                  EndIf
                  
                  Widget()\hide = Bool(Widget()\hide[1] Or
                                       Widget()\parent\hide Or 
                                       (Widget()\parent\type = #PB_GadgetType_Panel And
                                        Widget()\parent\index[#__panel_2] <> Widget()\_item))
                  
                EndIf
              Next
              ; PopListPosition(Widget())
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
        If *this\parent\gadget[#__panel_1] = *this ; type = #PB_GadgetType_Panel
          *this\parent\index[#__panel_1] = *this\bar\_s()\index
          *this\parent\count\items + 1 
        EndIf
        
        *this\count\items + 1 
        
        ; _set_item_image_(*this, \bar\_s(), Image)
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i Tab_removeItem(*this._s_widget, Item.l)
      If SelectElement(*this\bar\_s(), item)
        If *this\bar\_s()\index = *this\index[#__s_2]
          *this\index[#__s_2]  = item - 1
        EndIf
        
        DeleteElement(*this\bar\_s(), 1)
        *this\count\items - 1
        
        If *this\parent\gadget[#__panel_1] = *this
          *this\parent\count\items - 1
          Post(#PB_EventType_CloseItem, *this\parent, Item)
        Else
          Post(#PB_EventType_CloseItem, *this, Item)
        EndIf
        *this\bar\change = 1
      EndIf
    EndProcedure
    
    Procedure   Tab_clearItems(*this._s_widget) ; Ok
      If *this\count\items <> 0
        *this\count\items = 0
        ClearList(*this\bar\_s())
        
        If *this\parent\gadget[#__panel_1] = *this
          *this\parent\count\items = 0
          Post(#PB_EventType_CloseItem, *this\parent, #PB_All)
        Else
          Post(#PB_EventType_CloseItem, *this, #PB_All)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s Tab_GetItemText(*this._s_widget, Item.l, Column.l = 0)
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
            RoundBox(\X,\y,\width,\height,\round,\round,\color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If *this\bar\change
            If *this\bar\vertical
              *this\text\y = 6
            Else
              *this\text\x = 6
            EndIf
            
            ;             *this\parent\__width = 0
            *this\bar\max = 0
            *this\text\height = TextHeight("A")
            *this\text\width = *this\width;[2]
            
            ForEach \bar\_s()
              _drawing_font_item_(*this, *this\bar\_s(), *this\bar\_s()\change)
              
              If *this\bar\vertical
                ;                If *this\parent\__width < *this\bar\_s()\text\width + 12
                ;                  *this\parent\__width = *this\bar\_s()\text\width + 12
                ;                EndIf
                
                
                *this\bar\_s()\x = 2
                *this\bar\_s()\y = *this\bar\max
                *this\bar\_s()\width = *this\bar\button[#__b_3]\width - 3
                
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x + (*this\bar\_s()\width - *this\bar\_s()\text\width)/2
                *this\bar\_s()\height = *this\text\y*2 + *this\bar\_s()\text\height
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\fixed - 1
                  *this\bar\page\pos = *this\bar\_s()\y - ((*this\height[#__c_inner] - *this\bar\button[2]\len) - *this\bar\_s()\height) 
                EndIf
                
                *this\bar\max + *this\bar\_s()\height + Bool(*this\bar\_s()\index <> *this\count\items - 1) ; +  Bool(*this\bar\_s()\index = *this\count\items - 1) 
              Else
                *this\bar\_s()\y = 2
                *this\bar\_s()\x = *this\bar\max
                *this\bar\_s()\height = *this\bar\button[#__b_3]\height - 3
                
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y + (*this\bar\_s()\height - *this\bar\_s()\text\height)/2
                *this\bar\_s()\width = *this\text\x*2 + *this\bar\_s()\text\width
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\fixed - 1
                  *this\bar\page\pos = *this\bar\_s()\x - ((*this\width[#__c_inner] - *this\bar\button[2]\len) - *this\bar\_s()\width)
                EndIf
                
                *this\bar\max + *this\bar\_s()\width + Bool(*this\bar\_s()\index <> *this\count\items - 1) ; +  Bool(*this\bar\_s()\index = *this\count\items - 1) 
              EndIf
            Next
            
            ; then set tab state
            If *this\bar\fixed
              If *this\bar\page\pos < *this\bar\min Or 
                 *this\bar\area\len > *this\bar\max
                *this\bar\page\pos = 0
              EndIf
              
              If *this\bar\page\end And 
                 *this\bar\page\pos > *this\bar\page\end
                *this\bar\page\pos = *this\bar\page\end
              EndIf
              
              *this\bar\fixed = 0
            EndIf
            
            Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
            
            Bar_Update(*this)
            *this\bar\change = 0
          EndIf
          
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          
          ;           If *this\bar\button[#__b_2]\color\state = #__s_3 ;And 
          ;              ;*this\bar\button[#__b_2]\color\state = #__s_3
          ;             x = \bar\button[#__b_3]\x - \bar\button[#__b_1]\width
          ;           EndIf
          
          Protected State_3, Color_frame
          Protected bar_button = \bar\index
          
          ForEach \bar\_s()
            _drawing_font_item_(*this, *this\bar\_s(), 0)
            
            If \index[#__s_1] = \bar\_s()\index
              State_3 = Bool(\index[#__s_1] = \bar\_s()\index);  + Bool( \index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
            Else
              State_3 = 0
            EndIf
            
            If \index[#__s_2] = \bar\_s()\index
              State_3 = 2
            EndIf
            
            ;State_3 = \bar\_s()\color\state
            
            If *this\bar\vertical
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \y[#__c_inner] + \bar\_s()\y + \bar\_s()\height > \y[#__c_inner] ); And \x[#__c_inner] + \bar\_s()\x < \x[#__c_inner] + \width[#__c_inner])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,x + \bar\_s()\x - Bool(\index[#__s_2] = \bar\_s()\index),y + \bar\_s()\y,\bar\_s()\width + Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\height,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x + \bar\_s()\x - Bool(\index[#__s_2] = \bar\_s()\index)*2, y + \bar\_s()\y,\bar\_s()\width + Bool(\index[#__s_2] = \bar\_s()\index)*4,\bar\_s()\height,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x + \bar\_s()\x + \bar\_s()\width + 1, y + \bar\_s()\y + 1,1,\bar\_s()\height - 2, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
                  RoundBox(x + \bar\_s()\x,y + \bar\_s()\y + Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height - Bool(\index[#__s_2] = \bar\_s()\index)*4,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x + \bar\_s()\text\x, y + \bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
              EndIf
              
            Else
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \x[#__c_inner] + \bar\_s()\x + \bar\_s()\width > \x[#__c_inner] );And \x[#__c_inner] + \bar\_s()\x < \x[#__c_inner] + \width[#__c_inner])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,x + \bar\_s()\x,y + \bar\_s()\y - Bool(\index[#__s_2] = \bar\_s()\index),\bar\_s()\width,\bar\_s()\height + Bool(\index[#__s_2] = \bar\_s()\index)*2,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x + \bar\_s()\x, y + \bar\_s()\y - Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height + Bool(\index[#__s_2] = \bar\_s()\index)*4,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x + \bar\_s()\x + 1, y + \bar\_s()\y + \bar\_s()\height + 1,\bar\_s()\width - 2,1, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
                  RoundBox(x + \bar\_s()\x + Bool(\index[#__s_2] = \bar\_s()\index)*2,y + \bar\_s()\y,\bar\_s()\width - Bool(\index[#__s_2] = \bar\_s()\index)*4,\bar\_s()\height,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x + \bar\_s()\text\x, y + \bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
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
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_2]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \y[#__c_screen] + (size - size/5)
              LinearGradient(\x + \bs, fabe_x, \x + \bs, fabe_x - fabe_out)
              RoundBox(\x + \bs, fabe_x, \width - \bs,  - Size, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\y > \bar\button[#__b_3]\y
            If \bar\button[#__b_1]\y > \bar\button[#__b_3]\y
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_1]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x = \y[#__c_screen] + \height[#__c_screen] - (size - size/5)
              LinearGradient(\x + \bs, fabe_x, \x + \bs, fabe_x + fabe_out)
              RoundBox(\x + \bs, fabe_x, \width - \bs ,Size, 10,10)
            EndIf
          Else
            ;             ; to left
            ;             If (\bar\button[#__b_1]\x < \bar\button[#__b_3]\x)
            If \bar\button[#__b_2]\x < \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_2]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \x[#__c_screen] + (size - size/5)
              LinearGradient(fabe_x, \y + \bs, fabe_x - fabe_out, \y + \bs)
              RoundBox(fabe_x, \y + \bs,  - Size, \height - \bs, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\x > \bar\button[#__b_3]\x
            If \bar\button[#__b_1]\x > \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_1]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x = \x[#__c_screen] + \width[#__c_screen] - (size - size/5)
              LinearGradient(fabe_x, \y + \bs, fabe_x + fabe_out, \y + \bs)
              RoundBox(fabe_x, \y + \bs, Size, \height - \bs ,10,10)
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
              Arrow(\bar\button[#__b_1]\x + (\bar\button[#__b_1]\width - \bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y + (\bar\button[#__b_1]\height - \bar\button[#__b_1]\arrow\size)/2, 
                    \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical) + 2, \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
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
              Arrow(\bar\button[#__b_2]\x + (\bar\button[#__b_2]\width - \bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y + (\bar\button[#__b_2]\height - \bar\button[#__b_2]\arrow\size)/2, 
                    \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
            EndIf
          EndIf
          
          
        EndIf
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_frame] - 1,\y[#__c_inner] + \height[#__c_inner],\width[#__c_frame] + 2,1, \color\frame[Bool(\index[#__s_2]<> - 1)*2 ])
        ;         
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip], $FF0000FF)
        ;         ;         ;Box(\x[#__c_screen],\y[#__c_screen],\width[#__c_screen],\height[#__c_screen], $FF00F0F0)
        ;         ;         Box(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], $FF00F0F0)
        ;         Box(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00)
        
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
            RoundBox(\X,\y,\width,\height,\round,\round,\color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \type = #PB_GadgetType_ScrollBar
            If \bar\vertical
              If (\bar\page\len + Bool(\round)*(\width/4)) = \height
                Line( \x, \y, 1, \bar\page\len + 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              Else
                Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              EndIf
            Else
              If (\bar\page\len + Bool(\round)*(\height/4)) = \width
                Line( \x, \y, \bar\page\len + 1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
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
              Arrow(\bar\button[#__b_1]\x + (\bar\button[#__b_1]\width - \bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y + (\bar\button[#__b_1]\height - \bar\button[#__b_1]\arrow\size)/2, 
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
              Arrow(\bar\button[#__b_2]\x + (\bar\button[#__b_2]\width - \bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y + (\bar\button[#__b_2]\height - \bar\button[#__b_2]\arrow\size)/2, 
                    \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical) + 2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
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
                Arrow(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2, 
                      \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
              EndIf
            Else
              ; Draw thumb lines
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              If \bar\vertical
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 - 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 + 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Else
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 - 3,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 + 3,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              EndIf
              
            EndIf
          EndIf
          
          
        EndIf
        
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip], $FF00FF00)
        
      EndWith 
    EndProcedure
    
    Procedure.i Spin_Draw(*this._s_widget) 
      Scroll_Draw(*this)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\bar\button[#__b_1]\x - 2,*this\y[#__c_frame],*this\x[#__c_inner] + *this\width[#__c_draw] - *this\bar\button[#__b_1]\x + 3,*this\height[#__c_frame], *this\color\frame[*this\color\state])
      Box(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\color\frame[*this\color\state])
      
      
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
                For i = \bar\min To \bar\page\end
                  Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3 + 4) - 1, 
                       (\bar\area\pos + _thumb_ + (i - \bar\min) * \bar\percent),3, 1,\bar\button[#__b_1]\color\frame)
                Next
              Else
                Box(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3 + 4) - 1,\bar\area\pos + _thumb_, 3, *this\bar\area\len - *this\bar\thumb\len + 1, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3),\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3),\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\percent > 1
                For i = 0 To \bar\page\end - \bar\min
                  Line((\bar\area\pos + _thumb_ + i * \bar\percent), 
                       \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3 + 4) - 1,1,3,\bar\button[#__b_3]\color\Frame)
                Next
              Else
                Box(\bar\area\pos + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3 + 4) - 1,*this\bar\area\len - *this\bar\thumb\len + 1, 3, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3),1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3),1,3,\bar\button[#__b_3]\color\Frame)
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
          ;           RoundBox(\bar\thumb\pos - 1 - \bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1 + \bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          ;           RoundBox(\bar\thumb\pos + \bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1 + \bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          If \bar\button[#__b_1]\round
            If \bar\vertical
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos - \bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x + \bar\button[#__b_1]\width - 1, \bar\thumb\pos - \bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x + \bar\button[#__b_2]\width - 1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\thumb\pos - \bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos - \bar\button[#__b_1]\round,\bar\button[#__b_1]\y + \bar\button[#__b_1]\height - 1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y + \bar\button[#__b_2]\height - 1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            If \bar\vertical
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x + 1,\bar\thumb\pos - 1 - \bar\button[#__b_2]\round,\bar\button[#__b_1]\width - 2,1 + \bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x + 1,\bar\thumb\pos,\bar\button[#__b_2]\width - 2,1 + \bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos - 1 - \bar\button[#__b_2]\round,\bar\button[#__b_1]\y + 1,1 + \bar\button[#__b_2]\round,\bar\button[#__b_1]\height - 2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y + 1,1 + \bar\button[#__b_2]\round,\bar\button[#__b_2]\height - 2,
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
        
        
        If \bar\mode = #PB_Splitter_Separator 
          If \bar\vertical ; horisontal
            Box(\x, \bar\thumb\pos,\width,\bar\thumb\len,$FFFFFFFF)
          Else
            Box(\bar\thumb\pos,\y,\bar\thumb\len, \height,$FFFFFFFF)
          EndIf
          
          If \bar\vertical ; horisontal
            Box(\x + 1, \bar\thumb\pos + 1,\width - 2,\bar\thumb\len - 2,\bar\button[#__b_3]\color\Frame[#__s_2])
          Else
            Box(\bar\thumb\pos + 1,\y + 1,\bar\thumb\len - 2, \height - 2,\bar\button[#__b_3]\color\Frame[#__s_2])
          EndIf
          
          If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #PB_GadgetType_Splitter))
            Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          EndIf
          If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #PB_GadgetType_Splitter))
            Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
          EndIf
          
          ;           If \bar\vertical ; horisontal
          ;             Box(\x, \bar\thumb\pos + \bar\thumb\len/2,\width,1,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;           Else
          ;             Box(\bar\thumb\pos + \bar\thumb\len/2,\y,1, \height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;           EndIf
          ;           
          ;           If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #pb_gadgettype_splitter))
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, \bar\button[#__b_1]\width, 1, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x + \bar\button[#__b_1]\width - 1, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y + \bar\button[#__b_1]\height - 1, \bar\button[#__b_1]\width, 1, $FFFFFFFF)
          ; ;             ; Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;              Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,$FFFFFFFF)
          ;           EndIf
          ;           If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #pb_gadgettype_splitter))
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, \bar\button[#__b_2]\width, 1, $FFFFFFFF)
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;             Line(\bar\button[#__b_2]\x + \bar\button[#__b_2]\width - 1, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y + \bar\button[#__b_2]\height - 1, \bar\button[#__b_2]\width, 1, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;           ;  Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ;             Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,$FFFFFFFF)
          ;           EndIf
          ;           
          ;           ;Box(\x, \y,\width,\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
        Else
          If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #PB_GadgetType_Splitter))
            Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          EndIf
          If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #PB_GadgetType_Splitter))
            Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
          EndIf
          
          If \bar\vertical ; horisontal
            If \bar\button[#__b_3]\width > 35
              Circle(\bar\button[#__b_3]\x[#__c_frame] - (\bar\button[#__b_3]\round*2 + 2)*2 - 2, \bar\button[#__b_3]\y[#__c_frame],\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_frame] + (\bar\button[#__b_3]\round*2 + 2)*2 + 2, \bar\button[#__b_3]\y[#__c_frame],\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\width > 20
              Circle(\bar\button[#__b_3]\x[#__c_frame] - (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\y[#__c_frame],\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_frame] + (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\y[#__c_frame],\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
            EndIf
          Else
            If \bar\button[#__b_3]\height > 35
              Circle(\bar\button[#__b_3]\x[#__c_frame],\bar\button[#__b_3]\y[#__c_frame] - (\bar\button[#__b_3]\round*2 + 2)*2 - 2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_frame],\bar\button[#__b_3]\y[#__c_frame] + (\bar\button[#__b_3]\round*2 + 2)*2 + 2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
            EndIf
            If \bar\button[#__b_3]\height > 20
              Circle(\bar\button[#__b_3]\x[#__c_frame],\bar\button[#__b_3]\y[#__c_frame] - (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              Circle(\bar\button[#__b_3]\x[#__c_frame],\bar\button[#__b_3]\y[#__c_frame] + (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
            EndIf
          EndIf
          
          Circle(\bar\button[#__b_3]\x[#__c_frame], \bar\button[#__b_3]\y[#__c_frame],\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_Draw(*this._s_widget)
      With *this
        If \text\string  And (*this\type = #PB_GadgetType_Spin Or
                              *this\type = #PB_GadgetType_ProgressBar)
          
          ;           If \text\fontID 
          ;             DrawingFont(\text\fontID)
          ;           EndIf
          
          If \text\change Or *this\resize & #__resize_change
            *this\text\height = TextHeight("A")
            *this\text\width = TextWidth(*this\text\string)
            
            If *this\type = #PB_GadgetType_ProgressBar
              *this\text\rotate = (Bool(*this\bar\vertical And *this\bar\inverted) * 90)  + 
                                  (Bool(*this\bar\vertical And Not *this\bar\inverted) * 270)
            EndIf
            
            _text_change_(*this, *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner])
          EndIf
        EndIf
        
        Select \type
          Case #__type_Spin           : Spin_Draw(*this)
          Case #__type_tabBar         : Tab_Draw(*this)
          Case #__type_trackBar       : Track_Draw(*this)
          Case #__type_ScrollBar      : Scroll_Draw(*this)
          Case #__type_ProgressBar    : Progress_Draw(*this)
          Case #__type_Splitter       : Splitter_Draw(*this)
        EndSelect
        
        ;            DrawingMode(#PB_2DDrawing_Outlined)
        ;            Box(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00)
        
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
              If *this\bar\vertical And *this\width[#__c_inner] > 7 And *this\width[#__c_inner] < 21
                *this\bar\button[#__b_1]\len = *this\width[#__c_inner] - 1
                *this\bar\button[#__b_2]\len = *this\width[#__c_inner] - 1
                
              ElseIf Not *this\bar\vertical And *this\height[#__c_inner] > 7 And *this\height[#__c_inner] < 21
                *this\bar\button[#__b_1]\len = *this\height[#__c_inner] - 1
                *this\bar\button[#__b_2]\len = *this\height[#__c_inner] - 1
                
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
        
        If *this\type = #PB_GadgetType_tabBar
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
        
        If *this\type <> #PB_GadgetType_tabBar ;And *this\bar\button[#__b_3]\fixed
          
          ; if SetState(height - value or width - value)
          If *this\bar\button[#__b_3]\fixed < 0 
            Debug  "if SetState(height - value or width - value)"
            *this\bar\page\pos = *this\bar\area\len + *this\bar\button[#__b_3]\fixed
            *this\bar\button[#__b_3]\fixed = 0
          EndIf
        EndIf
        
        If *this\type = #PB_GadgetType_Splitter 
          ; one (set max)
          If Not *this\bar\max And *this\width And *this\height 
            *this\bar\thumb\len = *this\bar\button[#__b_3]\len
            *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
            
            If Not *this\bar\page\pos 
              *this\bar\page\pos = *this\bar\max/2 
            EndIf
            
            ;if splitter fixed set splitter pos to center
            If *this\bar\fixed = #__split_1
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
            Else
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\max - *this\bar\page\pos
            EndIf
          EndIf
        EndIf
        
        ; get page end
        If *this\type = #PB_GadgetType_tabBar
          *this\bar\page\end = *this\bar\max - *this\bar\area\len
        Else
          *this\bar\page\end = *this\bar\max - *this\bar\page\len
        EndIf
        If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        
        ; get thumb len
        If *this\type = #PB_GadgetType_tabBar
          *this\bar\thumb\len = *this\bar\area\len - *this\bar\page\end
          
        ElseIf *this\type = #PB_GadgetType_ScrollBar
          *this\bar\thumb\len = Round((*this\bar\area\len / (*this\bar\max - *this\bar\min)) * (*this\bar\page\len), #PB_Round_Nearest)
          
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
          If *this\type = #PB_GadgetType_tabBar
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\area\len)) 
          Else
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
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
      
      
      If *this\type = #PB_GadgetType_Splitter And
         (*this\bar\area\len - *this\bar\thumb\len) > 0
        ;               If Not *this\bar\thumb\change And *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 Debug "  - " + *this\bar\max  + " " +  *this\bar\page\pos  + " " +  *this\bar\area\len  + " " +  *this\bar\thumb\pos  + " " +  Bool(*this\resize & #__resize_change)
        ;                 *this\bar\page\pos = (*this\bar\area\len - *this\bar\thumb\len)/2
        ;               EndIf
        
        ;               If *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
        ;               EndIf
        
        ;              If *this\bar\max <> (*this\bar\area\len - *this\bar\thumb\len)
        ;                *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
        ;                
        ;                 ; If Not *this\bar\thumb\change ;And Not *this\bar\page\pos
        ;                   *this\bar\page\pos = (*this\bar\max)/2
        ;                 ;EndIf
        ;               EndIf
        
      EndIf
      
      If Not *this\bar\area\len < 0
        ; thumb pos
        If *this\type = #PB_GadgetType_Splitter And
           *this\bar\fixed And Not *this\bar\thumb\change
          ; поведение при изменении размера 
          ; чтобы вернуть fix сплиттер на свое место
          ; Debug "" + *this + " " + *this\bar\fixed
          
          If *this\bar\button[*this\bar\fixed]\fixed < 0
            *this\bar\button[*this\bar\fixed]\fixed = 0
          EndIf
          
          Protected fixed.l
          If *this\bar\button[*this\bar\fixed]\fixed > (*this\bar\area\len - *this\bar\thumb\len)
            fixed = (*this\bar\area\len - *this\bar\thumb\len)
          Else
            fixed = *this\bar\button[*this\bar\fixed]\fixed
          EndIf
          
          If fixed < 0 
            fixed = 0 
          EndIf
          
          If *this\bar\fixed = #__split_1
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
            ; Debug   "" +  *this\bar\min  + " " +  *this\bar\page\end
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
              *this\bar\button[#__b_1]\width = *this\width  -1   ; white line size
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
              *this\bar\button[#__b_2]\width = *this\width  -1   ; white line size
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\y = *this\y + *this\height - *this\bar\button[#__b_2]\height
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y           + 1 ; white line size
              *this\bar\button[#__b_2]\height = *this\height - 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\x = *this\X + *this\width - *this\bar\button[#__b_2]\width 
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
              *this\bar\button[#__b_2]\y = *this\y + *this\bar\button[#__b_2]\height + Bool(*this\height%2) 
              
              *this\bar\button[#__b_1]\y = *this\y 
              *this\bar\button[#__b_1]\height = *this\height/2 - Bool(Not *this\height%2)
              
            Else
              *this\bar\button[#__b_2]\width = *this\width/2 
              *this\bar\button[#__b_2]\x = *this\x + *this\bar\button[#__b_2]\width + Bool(*this\width%2) 
              
              *this\bar\button[#__b_1]\x = *this\x 
              *this\bar\button[#__b_1]\width = *this\width/2 - Bool(Not *this\width%2)
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
                  
                  *this\parent\y[#__c_required] =- *this\bar\page\pos
                  
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    ChangeCurrentElement(Widget(), *this\parent\adress)
                    While NextElement(Widget())
                      If Widget()\parent = *this\parent
                        Resize(Widget(), #PB_Ignore, 
                               Widget()\y[#__c_draw] + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore)
                      EndIf
                    Wend
                  EndIf
                EndIf
              Else
                If *this\parent\scroll\h = *this
                  *this\parent\change =- 1
                  *this\parent\x[#__c_required] =- *this\bar\page\pos
                  
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    ChangeCurrentElement(Widget(), *this\parent\adress)
                    While NextElement(Widget())
                      If Widget()\parent = *this\parent
                        Resize(Widget(), 
                               Widget()\x[#__c_draw] + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      EndIf
                    Wend
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          result = *this\bar\hide
        EndIf
        
        If *this\type = #PB_GadgetType_tabBar 
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
            *this\x[#__c_inner] = *this\x + *this\bs
            *this\y[#__c_inner] = *this\y + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\height[#__c_inner] = *this\height - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\width[#__c_inner] = *this\width - *this\bs - 1
          Else
            *this\y[#__c_inner] = *this\y + *this\bs
            *this\x[#__c_inner] = *this\x + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\width[#__c_inner] = *this\width - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\height[#__c_inner] = *this\height - *this\bs - 1
          EndIf
          
          If *this\bar\button[#__b_2]\len 
            If *this\bar\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_2]\x = *this\x[#__c_inner]  + (*this\width[#__c_inner] - *this\bar\button[#__b_2]\len)/2            
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\bs
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\bar\button[#__b_2]\len)/2           
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + *this\bs
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
            EndIf
          EndIf
          
          If *this\bar\button[#__b_1]\len 
            If *this\bar\vertical 
              ; Botom button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x[#__c_inner] + (*this\width[#__c_inner] - *this\bar\button[#__b_1]\len)/2             
              *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\y = *this\y + *this\height - *this\bar\button[#__b_1]\height - *this\bs
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\bar\button[#__b_1]\len)/2            
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\x = *this\X + *this\width - *this\bar\button[#__b_1]\width - *this\bs
            EndIf
          EndIf
          
          ;If *this\bar\thumb\len
          If *this\bar\vertical
            *this\bar\button[#__b_3]\x = *this\x[#__c_inner]           
            *this\bar\button[#__b_3]\width = *this\width[#__c_inner]
            *this\bar\button[#__b_3]\height = *this\bar\max                             
            *this\bar\button[#__b_3]\y = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
          Else
            *this\bar\button[#__b_3]\y = *this\y[#__c_inner]           
            *this\bar\button[#__b_3]\height = *this\height[#__c_inner]
            *this\bar\button[#__b_3]\width = *this\bar\max
            *this\bar\button[#__b_3]\x = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
          EndIf
          ;EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_ProgressBar
          *this\bar\button[#__b_1]\x        = *this\X
          *this\bar\button[#__b_1]\y        = *this\y
          
          If *this\bar\vertical
            *this\bar\button[#__b_1]\width  = *this\width
            *this\bar\button[#__b_1]\height = *this\bar\thumb\pos - *this\y 
          Else
            *this\bar\button[#__b_1]\width  = *this\bar\thumb\pos - *this\x 
            *this\bar\button[#__b_1]\height = *this\height
          EndIf
          
          If *this\bar\vertical
            *this\bar\button[#__b_2]\x      = *this\x
            *this\bar\button[#__b_2]\y      = *this\bar\thumb\pos + *this\bar\thumb\len
            *this\bar\button[#__b_2]\width  = *this\width
            *this\bar\button[#__b_2]\height = *this\height - (*this\bar\thumb\pos + *this\bar\thumb\len - *this\y)
          Else
            *this\bar\button[#__b_2]\x      = *this\bar\thumb\pos + *this\bar\thumb\len
            *this\bar\button[#__b_2]\y      = *this\y
            *this\bar\button[#__b_2]\width  = *this\width - (*this\bar\thumb\pos + *this\bar\thumb\len - *this\x)
            *this\bar\button[#__b_2]\height = *this\height
          EndIf
          
          If *this\text
            *this\text\change = 1
            *this\text\string = "%" + Str(*this\bar\page\pos)   + " " +  Str(*this\width)
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
            *this\bar\button[#__b_3]\width    = *this\bar\button[#__b_3]\len + (Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
            
            *this\bar\button[#__b_1]\y        = *this\y
            *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos - *this\y + *this\bar\thumb\len/2
            
            *this\bar\button[#__b_2]\y        = *this\bar\thumb\pos + *this\bar\thumb\len/2
            *this\bar\button[#__b_2]\height   = *this\height - (*this\bar\thumb\pos + *this\bar\thumb\len/2 - *this\y)
            
            If *this\bar\inverted
              *this\bar\button[#__b_1]\x      = *this\x + 6
              *this\bar\button[#__b_2]\x      = *this\x + 6
              *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/4 - 1 -  Bool(*this\bar\button[#__b_3]\len>10)
            Else
              *this\bar\button[#__b_1]\x      = *this\x + *this\width - *this\bar\button[#__b_1]\width - 6
              *this\bar\button[#__b_2]\x      = *this\x + *this\width - *this\bar\button[#__b_2]\width - 6 
              *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/2 + Bool(*this\bar\button[#__b_3]\len>10)
            EndIf
          Else
            *this\bar\button[#__b_1]\height   = 4
            *this\bar\button[#__b_2]\height   = 4
            *this\bar\button[#__b_3]\height   = *this\bar\button[#__b_3]\len + (Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
            
            *this\bar\button[#__b_1]\x        = *this\X
            *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos - *this\x + *this\bar\thumb\len/2
            
            *this\bar\button[#__b_2]\x        = *this\bar\thumb\pos + *this\bar\thumb\len/2
            *this\bar\button[#__b_2]\width    = *this\width - (*this\bar\thumb\pos + *this\bar\thumb\len/2 - *this\x)
            
            If *this\bar\inverted
              *this\bar\button[#__b_1]\y      = *this\y + *this\height - *this\bar\button[#__b_1]\height - 6
              *this\bar\button[#__b_2]\y      = *this\y + *this\height - *this\bar\button[#__b_2]\height - 6 
              *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/2 + Bool(*this\bar\button[#__b_3]\len>10)
            Else
              *this\bar\button[#__b_1]\y      = *this\y + 6
              *this\bar\button[#__b_2]\y      = *this\y + 6
              *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/4 - 1 -  Bool(*this\bar\button[#__b_3]\len>10)
            EndIf
          EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_Splitter And 
           *this\type = #PB_GadgetType_Splitter 
          If *this\bar\vertical
            *this\bar\button[#__b_1]\width    = *this\width
            *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos - *this\y 
            
            *this\bar\button[#__b_1]\x        = *this\x + (Bool(*this\index[#__split_1])**this\x)
            *this\bar\button[#__b_2]\x        = *this\x + (Bool(*this\index[#__split_2])**this\x)
            
            If Not ((#PB_Compiler_OS = #PB_OS_MacOS) And *this\index[#__split_1] And Not *this\parent)
              *this\bar\button[#__b_1]\y      = *this\y + (Bool(*this\index[#__split_1])**this\y)
              *this\bar\button[#__b_2]\y      = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\index[#__split_2])**this\y)
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
              
              *this\bar\button[#__b_3]\y[#__c_frame]   = (*this\bar\button[#__b_3]\y + *this\bar\button[#__b_3]\height/2)
              *this\bar\button[#__b_3]\x[#__c_frame]   = *this\x + (*this\width - *this\bar\button[#__b_3]\round)/2 + Bool(*this\width%2)
            EndIf
          Else
            *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos - *this\x 
            *this\bar\button[#__b_1]\height   = *this\height
            
            *this\bar\button[#__b_1]\y        = *this\y + (Bool(*this\index[#__split_1])**this\y)
            *this\bar\button[#__b_2]\y        = *this\y + (Bool(*this\index[#__split_2])**this\y)
            *this\bar\button[#__b_1]\x        = *this\x + (Bool(*this\index[#__split_1])**this\x)
            *this\bar\button[#__b_2]\x        = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\index[#__split_2])**this\x)
            
            *this\bar\button[#__b_2]\width    = *this\width - (*this\bar\button[#__b_1]\width + *this\bar\thumb\len)
            *this\bar\button[#__b_2]\height   = *this\height
            
            If *this\bar\thumb\len
              *this\bar\button[#__b_3]\y      = *this\y
              *this\bar\button[#__b_3]\x      = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
              *this\bar\button[#__b_3]\height = *this\height
              
              *this\bar\button[#__b_3]\x[#__c_frame]   = (*this\bar\button[#__b_3]\x + *this\bar\button[#__b_3]\width/2) ; - *this\x
              *this\bar\button[#__b_3]\y[#__c_frame]   = *this\y + (*this\height - *this\bar\button[#__b_3]\round)/2 + Bool(*this\height%2)
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
          If *this\gadget[#__split_1]
            If *this\index[#__split_1]
              If *this\root\canvas\container
                ResizeGadget(*this\gadget[#__split_1], *this\bar\button[#__b_1]\x - *this\x, *this\bar\button[#__b_1]\y - *this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              Else
                ResizeGadget(*this\gadget[#__split_1], (*this\bar\button[#__b_1]\x - *this\x) + GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_1]\y - *this\y) + GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              EndIf
            Else
              If *this\gadget[#__split_1]\x <> *this\bar\button[#__b_1]\x Or ;  - *this\x
                 *this\gadget[#__split_1]\y <> *this\bar\button[#__b_1]\y Or ;  - *this\y
                 *this\gadget[#__split_1]\width <> *this\bar\button[#__b_1]\width Or
                 *this\gadget[#__split_1]\height <> *this\bar\button[#__b_1]\height
                ; Debug "splitter_1_resize " + *this\gadget[#__split_1]
                Resize(*this\gadget[#__split_1], *this\bar\button[#__b_1]\x - *this\x, *this\bar\button[#__b_1]\y - *this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              EndIf
            EndIf
          EndIf
          
          If *this\gadget[#__split_2]
            If *this\index[#__split_2]
              If *this\root\canvas\container 
                ResizeGadget(*this\gadget[#__split_2], *this\bar\button[#__b_2]\x - *this\x, *this\bar\button[#__b_2]\y - *this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              Else
                ResizeGadget(*this\gadget[#__split_2], (*this\bar\button[#__b_2]\x - *this\x) + GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_2]\y - *this\y) + GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              EndIf
            Else
              If *this\gadget[#__split_2]\x <> *this\bar\button[#__b_2]\x Or ;  - *this\x
                 *this\gadget[#__split_2]\y <> *this\bar\button[#__b_2]\y Or ;  - *this\y
                 *this\gadget[#__split_2]\width <> *this\bar\button[#__b_2]\width Or
                 *this\gadget[#__split_2]\height <> *this\bar\button[#__b_2]\height 
                ; Debug "splitter_2_resize " + *this\gadget[#__split_2]
                Resize(*this\gadget[#__split_2], *this\bar\button[#__b_2]\x - *this\x, *this\bar\button[#__b_2]\y - *this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              EndIf
            EndIf   
          EndIf      
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_Spin
          If *this\bar\vertical      
            ; Top button coordinate
            *this\bar\button[#__b_2]\y      = *this\y[#__c_inner] + *this\height[#__c_inner]/2 + Bool(*this\height%2)
            *this\bar\button[#__b_2]\height = *this\height[#__c_inner]/2 - 1 
            *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len 
            *this\bar\button[#__b_2]\x      = (*this\x[#__c_inner] + *this\width[#__c_draw]) - *this\bar\button[#__b_2]\len - 1
            
            ; Bottom button coordinate
            *this\bar\button[#__b_1]\y      = *this\y[#__c_inner] + 1 
            *this\bar\button[#__b_1]\height = *this\height[#__c_inner]/2 - Bool(Not *this\height%2) - 1
            *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len 
            *this\bar\button[#__b_1]\x      = (*this\x[#__c_inner] + *this\width[#__c_draw]) - *this\bar\button[#__b_1]\len - 1                               
          Else    
            ; Left button coordinate
            *this\bar\button[#__b_1]\y      = *this\y[#__c_inner] + 1
            *this\bar\button[#__b_1]\height = *this\height[#__c_inner] - 2
            *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len/2 - 1
            *this\bar\button[#__b_1]\x      = *this\x + *this\width - *this\bar\button[#__b_1]\len - 1   
            
            ; Right button coordinate
            *this\bar\button[#__b_2]\y      = *this\y[#__c_inner] + 1 
            *this\bar\button[#__b_2]\height = *this\height[#__c_inner] - 2
            *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len/2 - 1
            *this\bar\button[#__b_2]\x      = *this\x[#__c_inner] + *this\width[#__c_draw] - *this\bar\button[#__b_2]\len/2                             
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
    
    Procedure.b Bar_Change(*this._s_widget, ScrollPos.f)
      With *this\bar
        If ScrollPos < \min 
          ;If *this\type <> #PB_GadgetType_tabBar
          ; if SetState(height - value or width - value)
          \button[#__b_3]\fixed = ScrollPos
          ;EndIf
          ScrollPos = \min 
          
        ElseIf \max And ScrollPos > \page\end ; = (\max - \page\len)
          If \max >= \page\len 
            ScrollPos = \page\end
          Else
            ScrollPos = \min 
          EndIf
        EndIf
        
        ;Debug  "  " + ScrollPos  + " " +  \page\pos  + " " +  \page\end
        
        If \page\pos <> ScrollPos 
          \thumb\change = \page\pos - ScrollPos
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
          
          \page\change = \thumb\change
          \page\pos = ScrollPos
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_SetState(*this._s_widget, state.f)
      Protected result
      
      If Bar_Change(*this, state) 
        Bar_Update(*this)
        
        If Not (*this\type = #PB_GadgetType_ScrollBar And _is_scrollbar_(*this))
          If *this\type <> #PB_GadgetType_tabBar
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
    
    Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, *value)
      Protected Result.l
      
      With *this
        If \type = #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              \bar\min = *value
              \bar\button[#__b_1]\len = *value
              Result = Bool(\bar\max)
              
            Case #PB_Splitter_SecondMinimumSize
              \bar\button[#__b_2]\len = *value
              Result = Bool(\bar\max)
              
            Case #PB_Splitter_FirstGadget
              *this\gadget[#__split_1] = *value
              *this\index[#__split_1] = Bool(IsGadget(*value))
              Result = 1
              
            Case #PB_Splitter_SecondGadget
              *this\gadget[#__split_2] = *value
              *this\index[#__split_2] = Bool(IsGadget(*value))
              Result = 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If \bar\min <> *value And Not *value < 0
                \bar\area\change = \bar\min - *value
                If \bar\page\pos < *value
                  \bar\page\pos = *value
                EndIf
                \bar\min = *value
                ;Debug  " min " + \bar\min + " max " + \bar\max
                Result = #True
              EndIf
              
            Case #__bar_maximum
              If \bar\max <> *value And Not *value < 0
                \bar\area\change = \bar\max - *value
                If \bar\min > *value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = *value
                EndIf
                
                If Not \bar\max
                  \bar\page\pos = \bar\max
                EndIf
                ;Debug  "   min " + \bar\min + " max " + \bar\max
                
                ;\bar\thumb\change = #True
                Result = #True
              EndIf
              
            Case #__bar_pagelength
              If \bar\page\len <> *value And Not *value < 0
                \bar\area\change = \bar\page\len - *value
                \bar\page\len = *value
                
                If Not \bar\max
                  If \bar\min > *value
                    \bar\max = \bar\min + 1
                  Else
                    \bar\max = *value
                  EndIf
                EndIf
                
                Result = #True
              EndIf
              
            Case #__bar_buttonsize
              If \bar\button[#__b_3]\len <> *value
                \bar\button[#__b_3]\len = *value
                
                If \type = #PB_GadgetType_ScrollBar
                  \bar\button[#__b_1]\len = *value
                  \bar\button[#__b_2]\len = *value
                EndIf
                
                If \type = #PB_GadgetType_tabBar
                  \bar\button[#__b_1]\len = *value
                  \bar\button[#__b_2]\len = *value
                EndIf
                
                *this\resize | #__resize_change
                Result = #True
              EndIf
              
            Case #__bar_inverted
              \bar\inverted = Bool(*value)
              ProcedureReturn Update(*this)
              
            Case #__bar_ScrollStep 
              \bar\increment = *value
              
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
    
    Procedure   Bar_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
      Protected Repaint
      Protected bar_button = *this\bar\index
      
      
      If eventtype = #__Event_MouseEnter
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_MouseLeave
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftButtonUp 
        If bar_button >= 0
          If *this\bar\button[bar_button]\state = #__s_2
            ;Debug " up button - " + bar_button
            *this\bar\button[bar_button]\state = #__s_1
            Repaint | #True
          EndIf
          
          ;Debug "" + bar_button  + " " +  *this\bar\from
          
          If bar_button <> *this\bar\from
            If *this\bar\button[bar_button]\state = #__s_1
              *this\bar\button[bar_button]\state = #__s_0
              
              If bar_button = #__b_3 
                If *this\cursor And *this\bar\button[#__b_2]\len <> $ffffff
                  ; Debug  "  reset cur"
                  ;                 set_cursor(*this, #PB_cursor_Default)
                  SetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                EndIf
              EndIf
              
              ; Debug " up leave button - " + bar_button
              Repaint | #True
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_tabBar
            If bar_button = #__b_3
              If *this\index[#__s_1] >= 0 And 
                 *this\index[#__s_2] <> *this\index[#__s_1]
                Repaint | Tab_SetState(*this, *this\index[#__s_1])
              EndIf
            EndIf
          EndIf
          
          *this\bar\index =- 1 
        EndIf
      EndIf
      
      If eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_leftButtonUp
        
        
        If *this\bar\button[#__b_3]\interact And
           *this\bar\button[#__b_3]\state <> #__s_3 And
           _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And
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
              
              If Not Selected() And *this\cursor 
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
          If *this\bar\from <> -  1
            If *this\bar\button[*this\bar\from]\state = #__s_1
              *this\bar\button[*this\bar\from]\state = #__s_0
              
              If Not Selected() 
                If *this\bar\from = #__b_3 And *this\cursor
                  If *this\bar\button[#__b_2]\len <> $ffffff
                    ; Debug  " reset cur"
                    ;                 set_cursor(*this, #PB_cursor_Default)
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
        
        If *this\type = #PB_GadgetType_tabBar
          If *this\count\items
            ForEach *this\bar\_s()
              ; If *this\bar\_s()\draw
              If _from_point_((mouse_x - *this\x[#__c_frame]) + Bool(Not *this\bar\vertical) * *this\bar\page\pos, mouse_y - *this\y[#__c_frame] + Bool(*this\bar\vertical) * *this\bar\page\pos, *this\bar\_s()) And *this\bar\from = #__b_3
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
          ;         If Not Mouse()\buttons
          ;          ; *this\bar\index = *this\bar\from
          ;         EndIf
        EndIf
        
        ; set color state
        If *this\type <> #PB_GadgetType_TrackBar
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
      
      If eventtype = #__Event_leftButtonDown
        If *this\bar\from >= 0 And 
           *this\bar\button[*this\bar\from]\state = #__s_1
          *this\bar\button[*this\bar\from]\state = #__s_2
          
          If *this\type <> #PB_GadgetType_TrackBar
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
          
          *this\bar\index = *this\bar\from
        EndIf
      EndIf
      
      If eventtype = #__Event_MouseMove
        If bar_button And 
           Selected() = *this
          If *this\bar\vertical
            Repaint | Bar_SetPos(*this, (mouse_y - Mouse()\delta\y))
          Else
            Repaint | Bar_SetPos(*this, (mouse_x - Mouse()\delta\x))
          EndIf
          
          SetWindowTitle(EventWindow(), Str(*this\bar\page\pos)  + " " +  Str(*this\bar\thumb\pos - *this\bar\area\pos))
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    ;}
    
    
    ;- 
    ;-  PUBLIC
    Macro  _start_drawing_(_this_)
      StartDrawing(CanvasOutput(_this_\root\canvas\gadget)) 
      
      _drawing_font_(_this_)
      ;       If _this_\text\fontID
      ;         DrawingFont(_this_\text\fontID) 
      ;       EndIf
    EndMacro
    
    Macro _text_scroll_x_(_this_)
      *this\change = _bar_scrollarea_change_(*this\scroll\h, _this_\text\caret\x - (Bool(_this_\text\caret\x>0) * (_this_\scroll\h\x + _this_\text\_padding + _this_\text\x)), (_this_\text\_padding*2 + _this_\text\x*2 + _this_\row\margin\width + 2)) ; ok
    EndMacro
    
    Macro _text_scroll_y_(_this_)
      *this\change = _bar_scrollarea_change_(*this\scroll\v, _this_\text\caret\y - (Bool(_this_\text\caret\y>0) * (_this_\scroll\v\y + _this_\text\_padding + _this_\text\y)), (_this_\text\_padding*2 + _this_\text\y*2 + _this_\text\caret\height)) ; ok
    EndMacro
    
    ;- 
    Macro _make_line_x_(_this_, _scroll_width_)
      If _this_\vertical
        If _this_\text\rotate = 90
          _this_\row\_s()\text\x[#__c_inner] = _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        ElseIf _this_\text\rotate = 270
          _this_\row\_s()\text\x[#__c_inner] = (_scroll_width_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        EndIf
        
      Else
        If _this_\text\rotate = 0
          If _this_\text\align\right
            _this_\row\_s()\text\x[#__c_inner] = (_scroll_width_ - _this_\row\_s()\text\width) 
          ElseIf Not _this_\text\align\left
            _this_\row\_s()\text\x[#__c_inner] = (_scroll_width_ - _this_\row\_s()\text\width)/2
          Else
            _this_\row\_s()\text\x[#__c_inner] = 0
          EndIf
          
        ElseIf _this_\text\rotate = 180
          If _this_\text\align\right
            _this_\row\_s()\text\x[#__c_inner] = _scroll_width_
          ElseIf Not _this_\text\align\left
            _this_\row\_s()\text\x[#__c_inner] = (_scroll_width_ + _this_\row\_s()\text\width)/2 
          Else
            _this_\row\_s()\text\x[#__c_inner] = _this_\row\_s()\text\width 
          EndIf
          
        EndIf
      EndIf
      
      _this_\row\_s()\text\x = _x_ + _this_\row\_s()\text\x[#__c_inner]
    EndMacro
    
    Macro _make_line_y_(_this_, _scroll_height_)
      If _this_\vertical
        If _this_\text\rotate = 90
          If _this_\text\align\bottom
            _this_\row\_s()\text\y[#__c_inner] = _scroll_height_ 
          ElseIf Not _this_\text\align\top
            _this_\row\_s()\text\y[#__c_inner] = (_scroll_height_ + _this_\row\_s()\text\width)/2
          Else
            _this_\row\_s()\text\y[#__c_inner] = _this_\row\_s()\text\width
          EndIf
          
        ElseIf _this_\text\rotate = 270
          If _this_\text\align\bottom
            _this_\row\_s()\text\y[#__c_inner] = ((_scroll_height_ - _this_\row\_s()\text\width) ) 
          ElseIf Not _this_\text\align\top
            _this_\row\_s()\text\y[#__c_inner] = (_scroll_height_ - _this_\row\_s()\text\width)/2 
          Else
            _this_\row\_s()\text\y[#__c_inner] = 0
          EndIf
          
        EndIf
        
      Else
        If _this_\text\rotate = 0
          _this_\row\_s()\text\y[#__c_inner] = _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        ElseIf _this_\text\rotate = 180
          _this_\row\_s()\text\y[#__c_inner] = (_scroll_height_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
          
        EndIf
      EndIf
      
      _this_\row\_s()\text\y = _y_ + _this_\row\_s()\text\y[#__c_inner]
    EndMacro
    
    Macro _make_scroll_x_(_this_)
      If _this_\text\align\right
        _this_\x[#__c_required] = (((_this_\width - _this_\bs*2) - _this_\scroll\align\right - _this_\text\_padding) - _this_\width[#__c_required])
      ElseIf Not _this_\text\align\left
        _this_\x[#__c_required] = (((_this_\width - _this_\bs*2) + _this_\scroll\align\left - _this_\scroll\align\right) - _this_\width[#__c_required] + Bool(_this_\width[#__c_required] % 2))/2 
      Else
        _this_\x[#__c_required] = _this_\text\_padding + _this_\scroll\align\left
      EndIf
      
      If *this\x[#__c_required] < 0
        *this\x[#__c_required] = _this_\scroll\align\left
      EndIf
    EndMacro
    
    Macro _make_scroll_y_(_this_)
      If _this_\text\align\bottom
        _this_\y[#__c_required] = (((_this_\height - _this_\bs*2) - _this_\scroll\align\bottom - _this_\text\_padding) - _this_\height[#__c_required]) 
      ElseIf Not _this_\text\align\top
        _this_\y[#__c_required] = ((((_this_\height - _this_\bs*2) + _this_\scroll\align\top - _this_\scroll\align\bottom) - _this_\height[#__c_required] + Bool(_this_\height[#__c_required] % 2))/2)
      Else
        _this_\y[#__c_required] = _this_\text\_padding + _this_\scroll\align\top
      EndIf
      
      If *this\y[#__c_required] < 0
        *this\y[#__c_required] = _this_\scroll\align\top
      EndIf
      ;     If *this\scroll\v\bar\page\pos < 0
      ;       *this\y[#__c_required] =- *this\scroll\v\bar\page\pos
      ;     EndIf
    EndMacro
    
    Macro _make_scroll_height_(_this_, _height_)
      If _this_\vertical
        _this_\width[#__c_required] + _height_ + _this_\mode\gridlines
      Else
        _this_\height[#__c_required] + _height_ + _this_\mode\gridlines
      EndIf
      
      If _this_\scroll\v And 
         _this_\scroll\v\bar\increment <> _height_ + Bool(_this_\mode\gridlines)
        _this_\scroll\v\bar\increment = _height_ + Bool(_this_\mode\gridlines)
      EndIf
    EndMacro
    
    Macro _make_scroll_width_(_this_, _width_)
      If _this_\vertical
        If _this_\text\multiline =- 1 And _this_\scroll\v
          _this_\height[#__c_required] = _make_area_height_(_this_, _this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
        Else
          If _this_\height[#__c_required] < _width_ + _this_\text\y*2 + _this_\text\caret\height
            _this_\height[#__c_required] = _width_ + _this_\text\y*2 + _this_\text\caret\height
          EndIf
        EndIf
      Else
        If _this_\text\multiline =- 1 And _this_\scroll\h
          _this_\width[#__c_required] = _make_area_width_(_this_, _this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
        Else
          If _this_\width[#__c_required] < _width_ + _this_\text\x*2 + _this_\text\caret\width
            _this_\width[#__c_required] = _width_ + _this_\text\x*2 + _this_\text\caret\width
          EndIf
        EndIf
      EndIf
    EndMacro
    
    
    ;- 
    Procedure.l _text_caret_(*this._s_widget)
      Protected i.l, X.l, Position.l =- 1,  
                MouseX.l, Distance.f, MinDistance.f = Infinity()
      
      MouseX = Mouse()\x - (*this\row\_s()\text\x + *this\x[#__c_required])
      
      ; Get caret pos
      For i = 0 To *this\row\_s()\text\len
        X = TextWidth(Left(*this\row\_s()\text\string, i))
        Distance = (MouseX - X)*(MouseX - X)
        
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
      
      Protected _line_ = *this\index[#__s_1]
      Protected _caret_last_len_ = Bool(_line_ <> *this\index[#__s_2] And 
                                        (*this\row\_s()\index < *this\index[#__s_1] Or 
                                         *this\row\_s()\index < *this\index[#__s_2])) * *this\mode\fullselection
      
      ;     If  _caret_last_len_
      ;       _caret_last_len_ = *this\width[2]
      ;     EndIf
      
      *this\row\_s()\text\edit[1]\len = _pos_
      *this\row\_s()\text\edit[2]\len = _len_
      
      *this\row\_s()\text\edit[1]\pos = 0 
      *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
      
      *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos + *this\row\_s()\text\edit[2]\len 
      *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[3]\pos
      
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
          ;         (_line_  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\mode\fullselection
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
        If *this\row\_s()\text\edit[2]\width And Not (_line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]) And
           *this\row\_s()\text\edit[2]\width <> *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width + *this\row\_s()\text\edit[3]\width) + _caret_last_len_
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width + *this\row\_s()\text\edit[3]\width) + _caret_last_len_
        EndIf
      CompilerEndIf
      
      ; для красоты
      If *this\row\_s()\text\edit[2]\width > *this\width[#__c_required]
        *this\row\_s()\text\edit[2]\width - _caret_last_len_
      EndIf
      
      ; set position (left;selected;right)
      *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
      *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x + *this\row\_s()\text\edit[1]\width) 
      *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x + *this\row\_s()\text\edit[2]\width)
      
      ; если выделили свнизу вверх
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] >= *this\row\_s()\index
        *this\text\edit[1]\len = (*this\row\_s()\text\pos + *this\row\_s()\text\edit[2]\pos)
        *this\text\edit[2]\pos = *this\text\edit[1]\len
      EndIf
      
      ; если выделили сверху ввниз
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] <= *this\row\_s()\index
        *this\text\edit[3]\pos = (*this\row\_s()\text\pos + *this\row\_s()\text\edit[3]\pos)
        *this\text\edit[3]\len = (*this\text\len - *this\text\edit[3]\pos)
      EndIf
      
      ; text/pos/len/state
      If _line_ = *this\row\_s()\index
        If *this\text\edit[2]\len <> (*this\text\edit[3]\pos - *this\text\edit[2]\pos)
          *this\text\edit[2]\len = (*this\text\edit[3]\pos - *this\text\edit[2]\pos)
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
        
        If _line_ > *this\index[#__s_2] Or
           (_line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
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
                                                                  ;     Debug  "" + *this\text\caret\pos[1]  + " " +  *this\text\caret\pos[2]
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
          If (_line_ = *this\row\_s()\index Or *this\index[#__s_2] = *this\row\_s()\index) Or    ; линия
             (_line_ < *this\row\_s()\index And *this\index[#__s_2] > *this\row\_s()\index) Or   ; верх
             (_line_ > *this\row\_s()\index And *this\index[#__s_2] < *this\row\_s()\index)      ; вниз
            
            If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s()\index
              If *this\text\caret\pos[1] > *this\text\caret\pos[2]
                _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
              EndIf
              
            ElseIf (_line_ < *this\row\_s()\index And *this\index[#__s_2] > *this\row\_s()\index) Or   ; верх
                   (_line_ > *this\row\_s()\index And *this\index[#__s_2] < *this\row\_s()\index)      ; вниз
              
              If _line_ < 0
                ; если курсор перешел за верхный предел
                *this\index[#__s_1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                ; если курсор перешел за нижный предел
                *this\index[#__s_1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s()\text\len
              EndIf
              
              _edit_sel_(*this, 0, *this\row\_s()\text\len)
              
            ElseIf _line_ = *this\row\_s()\index 
              If _line_ > *this\index[#__s_2] 
                _edit_sel_(*this, 0, *this\text\caret\pos[1])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
              EndIf
              
            ElseIf *this\index[#__s_2] = *this\row\_s()\index
              
              
              If *this\count\items = 1 And 
                 (_line_ < 0 Or _line_ > *this\count\items - 1)
                ; если курсор перешел за пределы итемов
                *this\index[#__s_1] = 0
                
                If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                  _edit_sel_(*this, *this\text\caret\pos[2], Bool(_line_ <> *this\index[#__s_2]) * (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
                
                *this\index[#__s_1] = _line_
              Else
                If _line_ < 0
                  *this\index[#__s_1] = 0
                  *this\text\caret\pos[1] = 0
                ElseIf _line_ > *this\count\items - 1
                  *this\index[#__s_1] = *this\count\items - 1
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                EndIf
                
                If *this\index[#__s_2] > _line_ 
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  _edit_sel_(*this, *this\text\caret\pos[2], (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
              EndIf
              
            EndIf
            
            If *this\index[#__s_1] = *this\row\_s()\index
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
                  *this\index[#__s_2] <> *this\row\_s()\index And _line_ <> *this\row\_s()\index)
            
            ; reset selected string
            _edit_sel_reset_(*this\row\_s())
            
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
      EndIf 
      
      ProcedureReturn _scroll_
    EndProcedure
    
    Procedure   _edit_sel_draw_(*this._s_widget, _line_, _caret_ = -1) ; Ok
      Protected Repaint.b
      
      Macro _edit_sel_is_line_(_this_)
        Bool(_this_\row\_s()\text\edit[2]\width And 
             Mouse()\x > _this_\row\_s()\text\edit[2]\x - _this_\scroll\h\bar\page\pos And
             Mouse()\y > _this_\row\_s()\text\y - _this_\scroll\v\bar\page\pos And 
             Mouse()\y < (_this_\row\_s()\text\y + _this_\row\_s()\text\height) - _this_\scroll\v\bar\page\pos And
             Mouse()\x < (_this_\row\_s()\text\edit[2]\x + _this_\row\_s()\text\edit[2]\width) - _this_\scroll\h\bar\page\pos)
      EndMacro
      
      With *this
        ; select enter mouse item
        If _line_ >= 0 And 
           _line_ < *this\count\items And 
           _line_ <> *this\row\_s()\index
          \row\_s()\color\state = 0
          SelectElement(*this\row\_s(), _line_) 
          \row\_s()\color\state = 1
        EndIf
        
        If _start_drawing_(*this)
          
          If _caret_ =- 1
            _caret_ = _text_caret_(*this) 
          Else
            ; Ctrl - A
            Repaint =- 2
          EndIf
          
          ; если перемещаем выделеный текст
          If *this\row\box\state 
            If *this\index[#__s_1] <> _line_
              *this\index[#__s_1] = _line_
              Repaint = 1
            EndIf
            
            If _edit_sel_is_line_(*this)
              If *this\text\caret\pos[2] <> *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[2] = *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[1] = *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len
                
                If _caret_ < *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len/2
                  _caret_ = *this\row\_s()\text\edit[1]\len
                Else
                  _caret_ = *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len
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
            
            If *this\index[#__s_1] <> _line_ 
              *this\index[#__s_1] = _line_ ; scroll vertical
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
      If *this\index[#__s_2] = *this\row\_s()\index 
        *this\row\selected = *this\row\_s()
        
        If *this\index[#__s_2] = *this\index[#__s_1]
          If *this\text\caret\pos[1] > *this\text\caret\pos[2]
            _edit_sel_(*this, *this\text\caret\pos[2] , *this\text\caret\pos[1] - *this\text\caret\pos[2])
          Else
            _edit_sel_(*this, *this\text\caret\pos[1] , *this\text\caret\pos[2] - *this\text\caret\pos[1])
          EndIf
        EndIf
      EndIf
      
      ;     If *this\row\count = *this\count\items
      ;       ; move caret
      ;       If *this\index[2] + 1 = *this\row\_s()\index 
      ;         ;         *this\index[1] = *this\row\_s()\index 
      ;         ;         *this\index[2] = *this\index[1]
      ;         
      ;         If *this\index[2] = *this\index[1]
      ;           If *this\text\caret\pos[1]<>*this\text\caret\pos[2]
      ;             _edit_sel_(*this, 0, *this\text\caret\pos[1] - *this\row\selected\text\len)
      ;           Else
      ;             _edit_sel_(*this, *this\text\caret\pos[1] - *this\row\selected\text\len, 0)
      ;           EndIf
      ;         EndIf
      ;         
      ;       EndIf
      ;     EndIf
      
      
      
      
      Protected  _line_ = *this\index[#__s_1]
      
      
      If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s()\index
        If *this\text\caret\pos[1] > *this\text\caret\pos[2]
          _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
        EndIf
        
      ElseIf (*this\index[#__s_2] > *this\row\_s()\index And _line_ < *this\row\_s()\index) Or   ; верх
             (*this\index[#__s_2] < *this\row\_s()\index And _line_ > *this\row\_s()\index)      ; вниз
        
        _edit_sel_(*this, 0, *this\row\_s()\text\len)
        
      ElseIf _line_ = *this\row\_s()\index 
        If _line_ > *this\index[#__s_2] 
          _edit_sel_(*this, 0, *this\text\caret\pos[1])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
        EndIf
        
      ElseIf *this\index[#__s_2] = *this\row\_s()\index
        If *this\index[#__s_2] > _line_ 
          _edit_sel_(*this, 0, *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[2], *this\row\_s()\text\len - *this\text\caret\pos[2])
        EndIf
        
      EndIf
      
      
      
      
      
      
      ProcedureReturn 
      
      If (*this\index[#__s_2] = *this\row\_s()\index Or *this\index[#__s_1] = *this\row\_s()\index) Or    ; линия
         (*this\index[#__s_2] > *this\row\_s()\index And *this\index[#__s_1] < *this\row\_s()\index) Or   ; верх
         (*this\index[#__s_2] < *this\row\_s()\index And *this\index[#__s_1] > *this\row\_s()\index)      ; вниз
        
        If (*this\index[#__s_2] > *this\row\_s()\index And *this\index[#__s_1] < *this\row\_s()\index) Or   ; верх
           (*this\index[#__s_2] < *this\row\_s()\index And *this\index[#__s_1] > *this\row\_s()\index)      ; вниз
          
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
          
        ElseIf *this\index[#__s_1] = *this\row\_s()\index 
          If *this\index[#__s_1] > *this\index[#__s_2] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[1]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[1] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        ElseIf *this\index[#__s_2] = *this\row\_s()\index
          If *this\index[#__s_2] > *this\index[#__s_1] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[2]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[2] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        EndIf
        
        *this\row\_s()\text\edit[1]\pos = 0 
        *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
        
        *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos + *this\row\_s()\text\edit[2]\len 
        *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[3]\pos
        
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
            *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + *this\mode\fullselection
          Else
            *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
            *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + Bool((*this\index[#__s_1] <  *this\index[#__s_2] And *this\row\_s()\index = *this\index[#__s_1]) Or
                                                                                                     ; (*this\index[1] <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
            (*this\index[#__s_1]  > *this\index[#__s_2] And *this\row\_s()\index = *this\index[#__s_2])) * *this\mode\fullselection
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
        *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x + *this\row\_s()\text\edit[1]\width) 
        *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x + *this\row\_s()\text\edit[2]\width)
        
        ; set cursor pos
        If *this\index[#__s_1] = *this\row\_s()\index 
          *this\text\caret\y = *this\row\_s()\text\y
          *this\text\caret\height = *this\row\_s()\text\height
          
          If *this\index[#__s_1] > *this\index[#__s_2] Or
             (*this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
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
        Bool((_char_ >= ' ' And _char_ <= '/') Or 
             (_char_ >= ':' And _char_ <= '@') Or 
             (_char_ >= '[' And _char_ <= 96) Or 
             (_char_ >= '{' And _char_ <= '~'))
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
              Case '0' To '9', '.',' - '
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
                count = Len(left.s + Trim(StringField(Mid(\text\string, \text\caret\pos[1]  + 1), 1, "."), #LF$))
                If count < 3 And (Val(left.s) > 25 Or Val(left.s + Chr.s) > 255)
                  Continue
                  ;               ElseIf Mid(\text\string, \text\caret\pos[1] + 1, 1) = "."
                  ;                 \text\caret\pos[1] + 1 : \text\caret\pos[2] = \text\caret\pos[1] 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> " - "
                Minus = 1
              ElseIf Input <> ' - '
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
    
    Procedure.b _text_paste_(*this._s_widget, Chr.s = "", Count.l = 0)
      Protected Repaint.b
      
      With *this
        If \index[#__s_1] <> \index[#__s_2] ; Это значить строки выделени
          If \index[#__s_2] > \index[#__s_1] : Swap \index[#__s_2], \index[#__s_1] : EndIf
          
          If \row\_s()\index <> \index[#__s_2]
            SelectElement(\row\_s(), \index[#__s_2])
          EndIf
          
          If Count
            \index[#__s_2] + Count
            \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
          ElseIf Chr.s = #LF$ ; to return
            \index[#__s_2] + 1
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
          \index[#__s_1] = \index[#__s_2]
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
      Protected result.b = -1, Input, Input_2, String.s, Count.i
      
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
              \index[#__s_2] + Count
              \index[#__s_1] = \index[#__s_2] 
              \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
            Else
              \text\caret\pos[1] + Len(Chr.s) 
            EndIf
            
            \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
            \text\caret\pos[2] = \text\caret\pos[1] 
            ;; \count\items = CountString(\text\string.s, #LF$)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
          SelectElement(\row\_s(), \index[#__s_2]) 
          result = 1 
        EndIf
      EndWith
      
      If result =- 1
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s text_wrap_(text$, Width.i, Mode = -1, DelimList$ = " " + Chr(9), nl$ = #LF$)
      ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
      Protected line$, ret$ = "", LineRet$ = ""
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
          start = (*end - *str) >> #PB_Compiler_Unicode
          line$ = PeekS (*str, start)
          ; Debug "" + start  + " " +  Str((*end - *str))  + " " +  Str((*end - *str) / #__sOC)  + " " +  #PB_compiler_Unicode  + " " +  #__sOC
          
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
            line$ = LTrim(Mid(line$, start + 1))
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
          ;         LineRet$ = ""
          *str = *end + #__sOC 
        EndIf 
        
        *end + #__sOC 
        
        ;     Next
      Wend
      
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndProcedure
    
    ;-
    Procedure.i Editor_Update(*this._s_widget, List row._s_rows())
      ;*this\text\string.s = make_multiline(*this, *this\text\string.s + #LF$) : ProcedureReturn
      
      Static string_out.s
      Protected Repaint, String.s, text_width, len, text.s, CountString
      Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent = 4
      
      With *this
        Protected *str.Character = @text
        Protected *end.Character = @text
        
        Protected _x_ = *this\x[#__c_inner] + *this\text\x, 
                  _y_ = *this\y[#__c_inner] + *this\text\y, 
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
        
        
        If \text\multiline
          text = text_wrap_(*this\text\string + #LF$, width, \text\multiline)
          *str.Character = @text
          *end.Character = @text
          
          ; Scroll hight reset 
          \count\items = 0
          \width[#__c_required] = \text\x*2
          \height[#__c_required] = \text\y*2
          
          While *end\c 
            If *end\c = #LF 
              len = (*end - *str)>>#PB_Compiler_Unicode
              String = PeekS (*str, len)
              
              If \text\multiline > 0
                _make_scroll_width_(*this, TextWidth(String))
              ElseIf \text\multiline < 0
                _make_scroll_width_(*this, Width)
              EndIf
              
              _make_scroll_height_(*this, TextHeight("A"))
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          CountString = CountString(*this\text\string, #LF$)
        Else
          CountString = 1
          text = *this\text\string + #LF$
          \width[#__c_required] = \text\x*2
          \height[#__c_required] = \text\y*2 ; 0
          _make_scroll_width_(*this, TextWidth(text))
          _make_scroll_height_(*this, *this\text\height)
        EndIf
        
        
        _make_scroll_x_(*this)
        _make_scroll_y_(*this)
        
        _width_ = (*this\width[#__c_required] - *this\text\x*2)
        _height_ = (*this\height[#__c_required] - *this\text\y*2)
        
        ; \max 
          If \vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #True
            EndIf
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #True
            EndIf
          EndIf
          
          ; 
          If *this\count\items <> CountString
            *this\count\items = CountString
            *this\text\change = #True
          EndIf
          
         If string_out <> text + Str(*this) 
          string_out = text + Str(*this) 
          *this\text\change = #True
        EndIf
        
        If *this\text\change
            Debug "*this\text\change - " + #PB_Compiler_Procedure
            
            *str.Character = @text
          *end.Character = @text
          
          *this\text\pos = 0
          *this\text\len = Len(*this\text\string.s)
          ;\count\items = CountString(text, #LF$)
          
          If Not \row\margin\hide
            \row\margin\width = TextWidth(Str(\count\items)) + 11
            \scroll\align\left = \row\margin\width
          EndIf
          
          If \row\count <> \count\items 
            \row\count = \count\items
            
            ClearList(row())
            Debug  " - - - - ClearList - - - - "
            
            While *end\c 
              If *end\c = #LF 
                If AddElement(row())
                  ; Update line pos in the text
                  row()\text\pos = *this\text\pos 
                  row()\text\len = (*end - *str)/#__sOC
                  *this\text\pos + row()\text\len + 1 ; Len(#LF$)
                  
                 
                  row()\text\string = PeekS (*str, row()\text\len)
                  row()\draw = 1
                  row()\y = _y_ + _this_y_
                  row()\height = \text\height
                  row()\text\height = \text\height
                  
                  row()\index = ListIndex(row())
                  row()\text\width = TextWidth(row()\text\string)
                  
                  row()\color = _get_colors_()
                  row()\color\fore[0] = 0
                  row()\color\fore[1] = 0
                  row()\color\fore[2] = 0
                  row()\color\fore[3] = 0
                  row()\color\back[0] = 0
                  row()\color\frame[0] = 0
                  
                  ; set entered color
                  If row()\index = *this\index[#__s_1]
                    row()\color\state = 1
                  EndIf
                  
                  _make_line_x_(*this, _width_)
                  _make_line_y_(*this, _height_)
                  
                  ; Margin 
                  row()\margin\string = Str(row()\index)
                  
                  If \vertical
                    row()\margin\x = row()\text\y
                    row()\margin\y = *this\y[#__c_inner] + *this\row\margin\width - TextWidth(row()\margin\string) - 3
                  Else
                    row()\margin\y = row()\text\y
                    row()\margin\x = *this\x[#__c_inner] + *this\row\margin\width - TextWidth(row()\margin\string) - 3
                  EndIf
                  
                  ;
                  _edit_sel_update_(*this)
                  
                  _this_y_ + *this\text\height + *this\mode\gridlines
                  
                EndIf
                
                ; ;               Wend : EndIf : FreeRegularExpression(0) : Else : Debug RegularExpressionError() : EndIf
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
          Else
            While *end\c 
              If *end\c = #LF 
                If SelectElement(row(), IT)
                  ; Update line pos in the text
                  row()\text\len = (*end - *str)/#__sOC
                  row()\text\pos = *this\text\pos 
                  *this\text\pos + row()\text\len + 1 ; Len(#LF$)
                  
                  String = PeekS (*str, row()\text\len)
                  
                  If row()\text\string.s <> String.s
                    row()\text\string.s = String.s
                    row()\text\change = 1
                  EndIf
                  
                  If row()\text\change <> 0
                    row()\text\width = TextWidth(String.s) 
                    
                    If *this\width[#__c_required] < row()\text\width
                      *this\width[#__c_required] = row()\text\width
                    EndIf
                    
                    _edit_sel_update_(*this)
                    row()\text\change = 0
                  EndIf
                EndIf
                
                IT + 1
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
          EndIf
          
;           ;  MessageRequester("", Str(ElapsedMilliseconds() - time) + " text parse time ")
;           If ElapsedMilliseconds() - time > 0
;             Debug Str(ElapsedMilliseconds() - time) + " text parse time " + Str(Bool(\row\count = \count\items))
;           EndIf
          
        Else
          ;           ; Scroll hight reset 
          ;           If \count\items = 0
          ;             \width[#__c_required] = 0
          ;           Else
          ;             \height[#__c_required] = 0
          ;           EndIf
          Debug  " - - - - updatelist - - - - "
          ;           
          ;           ForEach row()
          ;             If Not row()\hide
          ;               If \count\items = 0
          ;                 row()\text\width = TextWidth(row()\text\string)
          ;                 
          ;                 ; Scroll width length
          ;                 _make_scroll_width_(*this, row()\text\width)
          ;               Else
          ;                 ; Scroll hight length
          ;                 _make_scroll_height_(*this, row()\text\height)
          ;               EndIf
          ;             EndIf
          ;           Next
          ;           
          ;           ForEach row()
          ;             If Not row()\hide
          ;               _make_line_x_(*this, _width_)
          ;               
          ;               If \count\items = 0
          ;                 _edit_sel_update_(*this)
          ;               Else
          ;                 _make_line_y_(*this, _height_)
          ;               EndIf
          ;               
          ;             EndIf
          ;           Next
        EndIf
        
          
        If *this\scroll And 
           (*this\text\change Or (*this\resize And *this\text\multiline =- 1))
          
          If *this\scroll\v
            If *this\scroll\v\bar\min <>  - *this\y[#__c_required]
              Bar_SetAttribute(*this\scroll\v, #__bar_minimum,  - *this\y[#__c_required])
            EndIf
            
            If *this\scroll\v\bar\max <> *this\height[#__c_required] 
              Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *this\height[#__c_required])
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_y_(*this)
            EndIf
          EndIf
          
          If *this\scroll\h
            If *this\scroll\h\bar\min <>  - *this\x[#__c_required]
              Bar_SetAttribute(*this\scroll\h, #__bar_minimum,  - *this\x[#__c_required])
            EndIf
            
            If *this\scroll\h\bar\max <> *this\width[#__c_required] 
              Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *this\width[#__c_required])
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_x_(*this)
            EndIf
          EndIf
          
          If _bar_scrollarea_update_(*this)
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
        EndIf 
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    Procedure   _Editor_Update(*this._s_widget, List row._s_rows())
      With *this
        
        If \text\string.s
          Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
          Protected *str.Character
          Protected *End.Character
          Protected len.l, Position.l
          Protected IT,Text_X,Width,Height
          Protected TxtHeight = \text\height
          Protected ColorFont = \color\Front[Bool(*this\_state & #__s_front) * \color\state]
          
          If \vertical
            Width = \height[#__c_inner] - \text\X*2
            Height = \width[#__c_inner] - \text\y*2
          Else
            Width = \width[#__c_inner] - \text\X*2 
            Height = \height[#__c_inner] - \text\y*2
          EndIf
          
          ; make multiline text
          If \text\multiLine
            ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
            Protected text$ = *this\text\string.s + #LF$
            Protected DelimList$ = " " + Chr(9), nl$ = #LF$
            
            Protected line$
            Protected.i i, start, found, length
            
            ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
            ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
            ;     text$ = ReplaceString(text$, #CR$, #LF$)
            ;     text$ + #LF$
            ;     
            
            *str.Character = @text$
            *end.Character = @text$
            
            ; make word wrap
            While *end\c 
              If *end\c = #LF
                start = (*end - *str) >> #PB_Compiler_Unicode
                line$ = PeekS (*str, start)
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
                  
                  If Not found
                    start = length
                  EndIf
                  
                  String + Left(line$, start) + nl$
                  line$ = LTrim(Mid(line$, start + 1))
                  start = Len(line$)
                  
                  ;If length <> start
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth(RTrim(Left(line$, length)))
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  ;EndIf
                Wend
                
                String + line$ + nl$
                *str = *end + #__sOC 
              EndIf 
              
              ;CountString + 1
              *End + #__sOC 
            Wend
            
            CountString = CountString(String, #LF$)
          Else
            String.s = RemoveString(*this\text\string, #LF$) + #LF$
            CountString = 1
          EndIf
          
          ; \max 
          If \vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #True
            EndIf
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #True
            EndIf
          EndIf
          
          ; 
          If *this\count\items <> CountString
            *this\count\items = CountString
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            Debug "*this\text\change - " + #PB_Compiler_Procedure
            
            ;; editor
            If \row\count <> \count\items 
              Debug  " - - - - ClearList - - - - "
            
              *this\text\len = Len(String.s)
              *this\row\count = *this\count\items
              
              *str.Character = @String
              *End.Character = @String
              
              ClearList(row())
              *this\width[#__c_required] = 0
              *this\height[#__c_required] = 0
              
              ;
              While *End\c 
                If *End\c = #LF 
                  AddElement(row())
                  ; drawing item font
                  _drawing_font_item_(*this, row(), row()\text\change)
                  
                  row()\text\len = (*End - *str)>>#PB_Compiler_Unicode
                  row()\text\string = PeekS (*str, row()\text\len)
                  row()\text\width = TextWidth(row()\text\string)
                  
                  ;; editor
                  row()\index = ListIndex(row())
                  row()\height = row()\text\height
                  row()\text\pos = *this\text\pos : *this\text\pos + row()\text\len + 1 ; Len(#LF$)
                  
                  row()\color\back[1] = _get_colors_()\back[1]
                  row()\color\back[2] = _get_colors_()\back[2]
                  row()\color\back[3] = _get_colors_()\back[3]
                  row()\color\front[2] = _get_colors_()\front[2]
                  
                  
                  ; make line pos
                  If \vertical
                    If *this\height[#__c_required] < row()\text\width
                      *this\height[#__c_required] = row()\text\width
                    EndIf
                    
                    If \text\rotate = 270
                      row()\x = *this\width[#__c_inner] - *this\width[#__c_required] + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                    ElseIf \text\rotate = 90
                      row()\x = *this\width[#__c_required]                 - 1
                    EndIf
                    
                    *this\width[#__c_required] + TxtHeight
                  Else
                    If *this\width[#__c_required] < row()\text\width
                      *this\width[#__c_required] = row()\text\width
                    EndIf
                    
                    If \text\rotate = 0
                      row()\y = *this\height[#__c_required]                 - 1 
                    ElseIf \text\rotate = 180
                      row()\y = *this\height[#__c_inner] - *this\height[#__c_required] + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                    EndIf
                    
                    *this\height[#__c_required] + TxtHeight
                  EndIf
                  
                  *str = *End + #__sOC 
                EndIf 
                
                *End + #__sOC 
              Wend
              
            Else
              While *end\c 
                If *end\c = #LF 
                  If SelectElement(row(), IT)
                    row()\text\pos = *this\text\pos 
                    row()\text\len = (*End - *str)>>#PB_Compiler_Unicode
                    *this\text\pos + row()\text\len + 1 ; Len(#LF$)
                    
                    String.s = PeekS (*str, row()\text\len)
                    
                    If row()\text\string.s <> String.s
                      row()\text\string.s = String.s
                      row()\text\change = 1
                    EndIf
                    
                    If row()\text\change <> 0
                      row()\text\width = TextWidth(row()\text\string)
                      
                      _edit_sel_update_(*this)
                     ;; row()\text\change = 0
                    EndIf
                  EndIf
                  
                  IT + 1
                  *str = *end + #__sOC 
                EndIf 
                *end + #__sOC 
              Wend
            EndIf 
            
            ;
            ForEach row()
              If \vertical
                If \text\rotate = 270
                  row()\x - (*this\width[#__c_inner] - *this\width[#__c_required])
                EndIf
                
                row()\text\x = row()\x
                
                If \text\align\bottom
                  If \text\rotate = 270
                    row()\text\y = (*this\height[#__c_required] - row()\text\width)
                  ElseIf \text\rotate = 90
                    row()\text\y = *this\height[#__c_required]
                  EndIf
                  
                ElseIf Not \text\align\top
                  If \text\rotate = 270
                    row()\text\y = (*this\height[#__c_required] - row()\text\width) / 2
                  ElseIf \text\rotate = 90
                    row()\text\y = (*this\height[#__c_required] + row()\text\width) / 2
                  EndIf
                  
                Else
                  If \text\rotate = 270
                    row()\text\y = 0
                  ElseIf \text\rotate = 90
                    row()\text\y = row()\text\width
                  EndIf
                  
                EndIf
                
              Else
                If \text\rotate = 180
                  row()\y - (*this\height[#__c_inner] - *this\height[#__c_required])
                EndIf
                
                row()\text\y = row()\y
                
                If \text\align\right
                  If \text\rotate = 0
                    row()\text\x = (*this\width[#__c_required] - row()\text\width)
                  ElseIf \text\rotate = 180
                    row()\text\x = *this\width[#__c_required]
                  EndIf
                  
                ElseIf Not \text\align\left
                  If \text\rotate = 0
                    row()\text\x = (*this\width[#__c_required] - row()\text\width) / 2
                  ElseIf \text\rotate = 180
                    row()\text\x = (*this\width[#__c_required] + row()\text\width) / 2
                  EndIf
                  
                Else
                  If \text\rotate = 0
                    row()\text\x = 0
                  ElseIf \text\rotate = 180
                    row()\text\x = row()\text\width
                  EndIf
                  
                EndIf
              EndIf
              
              If row()\text\change <> 0
               ; _edit_sel_update_(*this)
                row()\text\change = 0
              EndIf
            Next 
          EndIf
          
          
          ; make vertical scroll y
          If \text\align\bottom
            *this\y[#__c_required] = \height[#__c_inner] - *this\height[#__c_required] - \text\y 
            
            ; vertical center
          ElseIf Not \text\align\top
            *this\y[#__c_required] = (\height[#__c_inner] - *this\height[#__c_required]) / 2
          Else
            *this\y[#__c_required] = \text\y
          EndIf
          
          ; make horizontal scroll x
          If \text\align\right
            *this\x[#__c_required] = \width[#__c_inner] - *this\width[#__c_required] - \text\x
            
            ; horizontal center
          ElseIf Not \text\align\left
            *this\x[#__c_required] = (\width[#__c_inner] - *this\width[#__c_required]) / 2
          Else
            *this\x[#__c_required] = \text\x
          EndIf
          
        EndIf
        
        If *this\change
          
          If *this\scroll\v
            If *this\scroll\v\bar\min <>- *this\y[#__c_required]
              Bar_SetAttribute(*this\scroll\v, #__bar_minimum,  - *this\y[#__c_required])
            EndIf
            
            If *this\scroll\v\bar\max <> *this\height[#__c_required] 
              Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *this\height[#__c_required])
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_y_(*this)
            EndIf
          EndIf
          
          If *this\scroll\h
            If *this\scroll\h\bar\min <>- *this\x[#__c_required]
              Bar_SetAttribute(*this\scroll\h, #__bar_minimum,  - *this\x[#__c_required])
            EndIf
            
            If *this\scroll\h\bar\max <> *this\width[#__c_required] 
              Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *this\width[#__c_required])
            EndIf
            
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            If *this\text\change
              _text_scroll_x_(*this)
            EndIf
          EndIf
          
          If _bar_scrollarea_update_(*this)
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
        EndIf 
        
      EndWith
    EndProcedure
    
    
    Procedure   Editor_Draw(*this._s_widget)
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT,Text_Y,Text_X, X,Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Make output multi line text
          If *this\text\change <> 0
            Editor_Update(*this, *this\row\_s())
            *this\text\change = 0
          EndIf
          
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           DrawingMode(#PB_2DDrawing_Gradient)
          ;           _box_gradient_(\vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
          ;         Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back[\color\state])
          ;         EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If (\text\change Or \resize)
              \row\margin\x = \x[#__c_inner]
              \row\margin\y = \y[#__c_inner]
              \row\margin\height = \height[#__c_inner]
            EndIf
            
            ; Draw margin
            DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
            Box(\row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back)
          EndIf
          
          ; Widget inner coordinate
          iX = \x[#__c_inner] + \row\margin\width 
          iY = \y[#__c_inner]
          iwidth = \width[#__c_inner]
          iheight = \height[#__c_inner]
          
          ; Draw Lines text
          If \count\items And \scroll\v And \scroll\h
            PushListPosition(\row\_s())
            ForEach \row\_s()
              ;               ; Is visible lines - -  - 
              \row\_s()\draw = 1;Bool(Not \row\_s()\hide And 
                                ;                                     \row\_s()\y + \row\_s()\height + *this\y[#__c_required] > *this\y[#__c_inner] And 
                                ;                                     (\row\_s()\y - *this\y[#__c_inner]) + *this\y[#__c_required]<*this\height[#__c_inner])
              
              ; Draw selections
              If *this\row\_s()\draw 
                ;               If (*this\text\change Or *this\resize)
                ;                 *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\x[#__c_required]
                ;                 *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\y[#__c_required]
                ;               EndIf
                
                Y = *this\row\_s()\y + *this\y[#__c_required]
                Text_X = *this\row\_s()\text\x + *this\x[#__c_required]
                Text_Y = *this\row\_s()\text\y + *this\y[#__c_required]
                
                Protected text_x_sel = \row\_s()\text\edit[2]\x + *this\x[#__c_required]
                Protected sel_x = \x[#__c_inner] + *this\text\y
                Protected sel_width = \width[#__c_inner] - *this\text\y*2
                
                Protected text_sel_state = 2 + Bool(Focused() <> *this)
                Protected text_sel_width = \row\_s()\text\edit[2]\width + Bool(Focused() <> *this) * *this\text\caret\width
                Protected text_state = *this\row\_s()\color\state
                
                text_state = Bool(*this\row\_s()\index = *this\index[#__s_1]) + Bool(*this\row\_s()\index = *this\index[#__s_1] And Focused() <> *this)*2
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный 
                  ; фон отличный от заднего фона едитора
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
                        Line(*this\x[#__c_inner] + *this\row\margin\width, *this\row\_s()\y, 1, *this\row\_s()\height, *this\color\Back) ; $FF000000);
                      EndIf
                    EndIf
                  EndIf
                  
                  ; Draw entered selection
                  ; GetActive()\gadget = *this
                  If text_state ; *this\row\_s()\index = *this\index[1] ; \color\state;
                    If *this\row\_s()\color\back[text_state]<> - 1              ; no draw transparent
                                                                                ;                     If *this\row\_s()\color\fore[text_state]
                                                                                ;                       DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                                                                                ;                       _box_gradient_(*this\vertical,sel_x,Y,sel_width, *this\row\_s()\height, *this\row\_s()\color\fore[text_state], *this\row\_s()\color\back[text_state], *this\row\_s()\round)
                                                                                ;                     Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[text_state] )
                      ;                     EndIf
                    EndIf
                    
                    If *this\row\_s()\color\frame[text_state]<> - 1 ; no draw transparent
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
                    If (*this\index[#__s_1] > *this\index[#__s_2] Or 
                        (*this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                      
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
                        DrawRotatedText(\row\_s()\text\edit[3]\x + *this\x[#__c_required], Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                      EndIf
                      
                      If \row\_s()\text\edit[2]\string.s
                        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                        DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
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
                      DrawRotatedText(\row\_s()\text\edit[1]\x + *this\x[#__c_required], Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    If \row\_s()\text\edit[2]\string.s
                      DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    If \row\_s()\text\edit[3]\string.s
                      DrawRotatedText(\row\_s()\text\edit[3]\x + *this\x[#__c_required], Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
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
                  DrawRotatedText(*this\row\_s()\margin\x + Bool(*this\vertical) * *this\x[#__c_required], *this\row\_s()\margin\y + Bool(Not *this\vertical) * *this\y[#__c_required], *this\row\_s()\margin\string, *this\text\rotate, *this\row\margin\color\front)
                EndIf
                
                ; Horizontal line
                If *this\mode\GridLines And *this\row\_s()\color\line And *this\row\_s()\color\line <> *this\row\_s()\color\back : DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*this\row\_s()\x, (*this\row\_s()\y + *this\row\_s()\height + Bool(*this\mode\gridlines>1)) + *this\y[#__c_required], *this\row\_s()\width, 1, *this\color\line)
                EndIf
              EndIf
            Next
            PopListPosition(*this\row\_s()) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And *this = Focused() ; *this\color\state
            DrawingMode(#PB_2DDrawing_XOr)             
            Box(*this\text\caret\x + *this\x[#__c_required], *this\text\caret\y + *this\y[#__c_required], *this\text\caret\width, *this\text\caret\height, $FFFFFFFF)
          EndIf
          
          ; Draw frames
          If *this\notify
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round, $FF0000FF)
            If \round : RoundBox(\x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
          ElseIf *this\bs
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\frame[\color\state])
            If \round : RoundBox(\x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
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
              len + (*end - *str)/#__sOC
              ; Debug "" + Item + " " + Str(len + Item)  + " " +  state
              
              If i = Item 
                *this\index[#__s_1] = Item
                *this\index[#__s_2] = Item
                
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
          If *this\index[#__s_1] <> Item 
            *this\index[#__s_1] = Item
            *this\index[#__s_2] = Item
            
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
    
    Procedure   Editor_AddItem(*this._s_widget, Item.l,Text.s,Image.i = -1,Flag.i = 0)
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
                  ;Debug "" +  PeekS (*str, (*end - *str)/#__sOC)  + " " +  Str((*end - *str)/#__sOC)
                  len + (*end - *str)/#__sOC
                EndIf
                
                i + 1
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
          EndIf
          
          \text\string = Trim(InsertString(string, Text.s + #LF$, len + 1), #LF$)
          
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
        _key_shift_ = Bool(Keyboard()\key[1] & #PB_Canvas_Shift)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          _key_control_ = Bool((Keyboard()\key[1] & #PB_Canvas_Control) Or (Keyboard()\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
        CompilerElse
          _key_control_ = Bool(Keyboard()\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
        CompilerEndIf
        
        Select EventType
          Case #__Event_Input ; - Input (key)
            If Not _key_control_   ; And Not _key_shift_
              If Not *this\notify And Keyboard()\input
                
                Repaint = _text_insert_(*this, Chr(Keyboard()\input))
                
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
            Select Keyboard()\key
              Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
                If _key_control_ : *this\index[#__s_2] = 0 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
                If _key_control_ : *this\index[#__s_2] = *this\count\items - 1 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_PageUp   ;: Repaint = ToPos(*this, 1, 1)
                
              Case #PB_Shortcut_PageDown ;: Repaint = ToPos(*this, - 1, 1)
                
              Case #PB_Shortcut_A        ; Ok
                If _key_control_ And
                   \text\edit[2]\len <> \text\len
                  
                  ; set caret to begin
                  \text\caret\pos[2] = 0 
                  \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                  
                  ; select first item
                  \index[#__s_2] = 0 
                  \index[#__s_1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                  
                  Repaint = _edit_sel_draw_(*this, \count\items - 1, \text\len)
                EndIf
                
              Case #PB_Shortcut_Up       ; Ok
                If *this\index[#__s_1] > _line_first_
                  If _caret_last_pos_
                    If Not Keyboard()\key[1] & #PB_Canvas_Alt 
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, 0, 0)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_1] - _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf Keyboard()\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_min_ 
                      *this\text\caret\pos[2] = _caret_min_
                    Else
                      *this\index[#__s_2] - _step_ 
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = 0
                      *this\text\caret\pos[2] = 0
                    Else
                      *this\index[#__s_2] - _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                  EndIf
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                If *this\index[#__s_1] < _line_last_
                  If _caret_last_pos_
                    If Not Keyboard()\key[1] & #PB_Canvas_Alt And Not _key_control_
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, \count\items - 1, *this\text\len)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_1] + _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf Keyboard()\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_max_ 
                      *this\text\caret\pos[2] = _caret_max_
                    Else
                      *this\index[#__s_2] + _step_ 
                      
                      If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                        _caret_max_ = *this\row\_s()\text\len
                        
                        If *this\text\caret\pos[1] <> _caret_max_
                          *this\text\caret\pos[2] = _caret_max_
                          
                          Debug "" + #PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = \count\items - 1
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      *this\index[#__s_2] + _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\row\_s()\index <> _line_last_ And
                     SelectElement(*this\row\_s(), _line_last_) 
                    _caret_max_ = *this\row\_s()\text\len
                    Debug "" + #PB_Compiler_Procedure + "*this\row\_s()\index <> _line_last_"
                  EndIf
                  
                  If *this\text\caret\pos[1] <> _caret_max_ : *this\text\caret\pos[2] = _caret_max_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Left     ; Ok
                If _key_shift_        
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], 0)  
                  Else
                    _line_ = *this\index[#__s_1] - Bool(*this\index[#__s_1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_) * _step_
                    
                    ; коректируем позицию коректора
                    If *this\row\_s()\index <> _line_ And
                       SelectElement(*this\row\_s(), _line_) 
                    EndIf
                    If *this\text\caret\pos[1] > *this\row\_s()\text\len
                      *this\text\caret\pos[1] = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\index[#__s_1] <> _line_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\row\_s()\text\len)  
                    ElseIf *this\text\caret\pos[1] > _caret_min_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] - _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] > _line_first_
                  If Keyboard()\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_start_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
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
                        *this\index[#__s_2] - _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                          *this\text\caret\pos[1] = *this\row\_s()\text\len
                          *this\text\caret\pos[2] = *this\row\_s()\text\len
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] > _caret_min_ 
                    *this\text\caret\pos[2] - _step_
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Right    ; Ok
                If _key_shift_       
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\len)  
                  Else
                    If *this\row\_s()\index <> *this\index[#__s_1] And
                       SelectElement(*this\row\_s(), *this\index[#__s_1]) 
                      _caret_max_ = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\text\caret\pos[1] > _caret_max_
                      *this\text\caret\pos[1] = _caret_max_
                    EndIf
                    
                    _line_ = *this\index[#__s_1] + Bool(*this\index[#__s_1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_) * _step_
                    
                    ; если дошли в конец строки,
                    ; то переходим в начало
                    If *this\index[#__s_1] <> _line_ 
                      Repaint = _edit_sel_draw_(*this, _line_, 0)  
                    ElseIf *this\text\caret\pos[1] < _caret_max_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] + _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] < _line_last_
                  If Keyboard()\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_stop_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
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
                        *this\index[#__s_2] + _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                          *this\text\caret\pos[1] = 0
                          *this\text\caret\pos[2] = 0
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\text\caret\pos[1] < _caret_max_ 
                    *this\text\caret\pos[2] + _step_
                    
                    
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
                ;- backup  
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
                      
                      \text\string.s = Left(\text\string.s, \row\_s()\text\pos + \text\caret\pos[1] ) + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                    Else
                      ; Если дошли до начала строки то 
                      ; переходим в конец предыдущего итема
                      If \index[#__s_1] > _line_first_ 
                        \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos + \text\caret\pos[1], 1)
                        
                        ;to up
                        \index[#__s_1] - 1
                        \index[#__s_2] - 1
                        
                        If *this\row\_s()\index <> \index[#__s_2] And
                           SelectElement(*this\row\_s(), \index[#__s_2]) 
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
                
                ;- return
              Case #PB_Shortcut_Return 
                If *this\text\multiline
                  If Not _text_paste_(*this, #LF$)
                    *this\index[#__s_2] + 1
                    *this\index[#__s_1] = *this\index[#__s_2]
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
                  
                  If Keyboard()\key = #PB_Shortcut_X
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
            
            Select Keyboard()\key
              Case #PB_Shortcut_Home,
                   #PB_Shortcut_End,
                   #PB_Shortcut_PageUp, 
                   #PB_Shortcut_PageDown,
                   #PB_Shortcut_Up,
                   #PB_Shortcut_Down,
                   #PB_Shortcut_Left,
                   #PB_Shortcut_Right,
                   #PB_Shortcut_Delete,
                   #PB_Shortcut_Return ;, #PB_Shortcut_back
                
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
    
    Procedure   _Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Static DoubleClick.i = -1
      Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
      
      With *this
        ;If \text\editable  
        
        ;Debug *this\scroll\v\bar\index
        If *this And *this\scroll\v\bar\index =- 1 And *this\scroll\h\bar\index =- 1
          If ListSize(*this\row\_s())
            If Not \hide ;And \interact
                         ; Get line position
                         ;If Mouse()\buttons ; сним двойной клик не работает
              If \scroll\v And (Mouse()\y - \y[#__c_inner] - \text\y + \scroll\v\bar\page\pos) > 0
                _line_ = ((Mouse()\y - \y[#__c_inner] - \text\y - \y[#__c_required]) / (\text\height + \mode\gridlines))
                ;  _line_ = ((Mouse()\y - \y[2] - \text\y + \scroll\v\bar\page\pos) / (\text\height + \mode\gridlines))
              Else
                _line_ =- 1
              EndIf
              ;EndIf
              ;Debug  _line_; (Mouse()\y - \y[2] - \text\y + \scroll\v\bar\page\pos)
              
              Select eventtype 
                Case #__Event_leftDoubleClick 
                  ; bug pb
                  ; в мак ос в editorgadget ошибка
                  ; при двойном клике на слове выделяет правильно 
                  ; но стирает вместе с предшествующим пробелом
                  ; в окнах выделяет уще и пробелл но стирает то что выделено
                  
                  ; Событие двойной клик происходит по разному
                  ; - mac os  - 
                  ; LeftButtonDown 
                  ; LeftButtonUp 
                  ; LeftClick 
                  ; LeftDoubleClick 
                  
                  ; - windows & linux  - 
                  ; LeftButtonDown
                  ; LeftDoubleClick
                  ; LeftButtonUp
                  ; LeftClick
                  
                  *this\index[#__s_2] = _line_
                  
                  Caret = _edit_sel_stop_(*this)
                  *this\text\caret\time = ElapsedMilliseconds()
                  *this\text\caret\pos[2] = _edit_sel_start_(*this)
                  Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], Caret)
                  *this\row\selected = \row\_s() ; *this\index[2]
                  
                Case #__Event_leftButtonDown
                  
                  If _is_item_(*this, _line_) And 
                     _line_ <> \row\_s()\index  
                    \row\_s()\color\state = 0
                    SelectElement(*this\row\_s(), _line_) 
                  EndIf
                  
                  If _line_ = \row\_s()\index
                    \row\_s()\color\state = 1
                    
                    If *this\row\selected And 
                       *this\row\selected = \row\_s() And
                       (ElapsedMilliseconds() - *this\text\caret\time) < 500
                      
                      *this\text\caret\pos[2] = 0
                      *this\row\box\state = #False
                      *this\row\selected = #Null
                      *this\index[#__s_1] = _line_
                      *this\text\caret\pos[1] = \row\_s()\text\len ; Чтобы не прокручивало в конец строки
                      Repaint = _edit_sel_draw_(*this, _line_, \row\_s()\text\len)
                      
                    Else
                      _start_drawing_(*this)
                      *this\row\selected = \row\_s()
                      
                      If *this\text\editable And _edit_sel_is_line_(*this)
                        ; Отмечаем что кликнули
                        ; по выделеному тексту
                        *this\row\box\state = 1
                        
                        Debug "sel - " + \row\_s()\text\edit[2]\width
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
                        
                        \index[#__s_2] = \row\_s()\index 
                        
                        
                        If *this\text\caret\pos[1] <> Caret
                          *this\text\caret\pos[1] = Caret
                          *this\text\caret\pos[2] = Caret 
                          Repaint =- 1
                        EndIf
                        
                        If *this\index[#__s_1] <> _line_ 
                          *this\index[#__s_1] = _line_
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
                  If Mouse()\buttons & #PB_Canvas_LeftButton 
                    Repaint = _edit_sel_draw_(*this, _line_)
                  EndIf
                  
                Case #__Event_leftButtonUp  
                  If *this\text\editable And *this\row\box\state
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
                      If *this\index[#__s_2] = *this\index[#__s_1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[2] - *this\row\selected\text\edit[2]\len
                      EndIf
                      ; Debug "" + *this\text\caret\pos[2]  + " " +  *this\row\selected\text\edit[2]\pos
                      
                      *this\row\selected\text\string = RemoveString(*this\row\selected\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\edit[2]\pos, 1)
                      *this\text\string = RemoveString(*this\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\pos + *this\row\selected\text\edit[2]\pos, 1)
                      
                      *this\row\_s()\text\string = InsertString(*this\row\_s()\text\string, *this\row\selected\text\edit[2]\string, *this\text\caret\pos[2] + 1)
                      *this\text\string = InsertString(*this\text\string, *this\row\selected\text\edit[2]\string, *this\row\_s()\text\pos + *this\text\caret\pos[2] + 1)
                      
                      
                      ;                       \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                      ;                     \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                      ;                     
                      ;                     \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      ;                     \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      ;                     
                      ;                     \text\string.s = Left(\text\string.s, \row\_s()\text\pos + \text\caret\pos[1] ) + \text\edit[3]\string
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
                      
                      If *this\index[#__s_2] <> *this\index[#__s_1]
                        ; *this\text\change =- 1
                        _edit_sel_reset_(*this\row\selected)
                        *this\index[#__s_2] = *this\index[#__s_1]
                        
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
                      *this\index[#__s_2] = _line_
                      
                      If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[#__s_1] <> _line_ 
                        *this\index[#__s_1] = _line_
                        Repaint = 1
                      EndIf
                      
                      Repaint = _edit_sel_set_(*this, _line_, Repaint)
                    EndIf
                    
                    StopDrawing() 
                    *this\row\box\state = #False
                    *this\row\selected = #Null
                    Repaint = 1
                  EndIf
                  
                Default
                  If _is_item_(*this, \index[#__s_2]) And 
                     \index[#__s_2] <> \row\_s()\index  
                    \row\_s()\color\state = 0
                    SelectElement(*this\row\_s(), \index[#__s_2]) 
                  EndIf
                  
              EndSelect
            EndIf
            
            ; edit events
            If *this\text\editable And GetActive()\gadget = *this
              Repaint | Editor_Events_Key(*this, eventtype, Mouse()\x, Mouse()\y)
            EndIf
          EndIf
        EndIf
        ;EndIf
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      Select eventtype
        Case #PB_EventType_Focus
          Post(eventtype, *this)
          Repaint = 1
          
        Case #PB_EventType_LostFocus
          Post(eventtype, *this)
          Repaint = 1
          
        Default
          Repaint = _Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      EndSelect
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;- 
    ;-  TREEs
    ;- 
    
    
    
    
    
    Declare.l Tree_Draw(*this._s_widget, List row._s_rows())
    ;Declare  _tree_events_(*this, eventtype.l, mouse_x.l = -1, mouse_y.l = -1, position.l = 0)
    
    ;- 
    Declare tt_close(*this._s_tt)
    
    Procedure tt_tree_Draw(*this._s_tt, *color._s_color = 0)
      With *this
        If *this And IsGadget(\gadget) And StartDrawing(CanvasOutput(\gadget))
          If Not *color
            *color = \color
          EndIf
          
          ;_drawing_font_(*this)
          If \text\fontID 
            DrawingFont(\text\fontID) 
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(0,1,\width,\height - 2, *color\back[*color\state])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(\text\x, \text\y, \text\string, *color\front[*color\state])
          DrawingMode(#PB_2DDrawing_Outlined)
          Line(0,0,\width,1, *color\frame[*color\state])
          Line(0,\height - 1,\width,1, *color\frame[*color\state])
          Line(\width - 1,0,1,\height, *color\frame[*color\state])
          StopDrawing()
        EndIf 
      EndWith
    EndProcedure
    
    Procedure tt_tree_callBack()
      ;     ;SetActiveWindow(This()\widget\root\canvas\window)
      ;     ;SetActiveGadget(This()\widget\root\canvas\gadget)
      ;     
      ;     If This()\widget\row\selected
      ;       This()\widget\row\selected\color\state = 0
      ;     EndIf
      ;     
      ;     This()\widget\row\selected = This()\widget\row\_s()
      ;     This()\widget\row\_s()\color\state = 2
      ;     This()\widget\color\state = 2
      ;     
      ;     ;Tree_reDraw(This()\widget)
      
      tt_close(GetWindowData(EventWindow()))
    EndProcedure
    
    Procedure tt_creare(*this._s_widget, x,y)
      With *this
        If *this
          This()\widget = *this
          \row\tt = AllocateStructure(_s_tt)
          \row\tt\visible = 1
          \row\tt\x = x + \row\_s()\x + \row\_s()\width - 1
          \row\tt\y = y + \row\_s()\y - \scroll\v\bar\page\pos
          
          \row\tt\width = \row\_s()\text\width - \width[#__c_inner] + (\row\_s()\text\x - \row\_s()\x) + 5 ; -  (\width[#__c_required] - \width); -  \row\_s()\text\x; 105 ;\row\_s()\text\width - (\width[#__c_required] - \row\_s()\width)  ; - 32 + 5 
          
          If \row\tt\width < 6
            \row\tt\width = 0
          EndIf
          
          Debug \row\tt\width ;Str(\row\_s()\text\x - \row\_s()\x)
          
          \row\tt\height = \row\_s()\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\tt\window = OpenWindow(#PB_Any, \row\tt\x, \row\tt\y, \row\tt\width, \row\tt\height, "", 
                                      #PB_Window_BorderLess|#PB_Window_NoActivate|flag, WindowID(\root\canvas\window))
          
          \row\tt\gadget = CanvasGadget(#PB_Any,0,0, \row\tt\width, \row\tt\height)
          \row\tt\color = \row\_s()\color
          \row\tt\text = \row\_s()\text
          \row\tt\text\fontID = \row\_s()\text\fontID
          \row\tt\text\x =- (\width[#__c_inner] - (\row\_s()\text\x - \row\_s()\x)) + 1
          \row\tt\text\y = (\row\_s()\text\y - \row\_s()\y) + \scroll\v\bar\page\pos
          
          BindEvent(#PB_Event_ActivateWindow, @tt_tree_callBack(), \row\tt\window)
          SetWindowData(\row\tt\window, \row\tt)
          tt_tree_Draw(\row\tt)
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close(*this._s_tt)
      If IsWindow(*this\window)
        *this\visible = 0
        ;UnbindEvent(#PB_Event_ActivateWindow, @tt_tree_callBack(), *this\window)
        CloseWindow(*this\window)
        ; ClearStructure(*this, _s_tt) ;??????
      EndIf
    EndProcedure
    
    ;- 
    Macro _tree_box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_ = $FFFFFFFF, _round_ = 2, _alpha_ = 255) 
      
      If _type_ = 1
        If _checked_
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          
          RoundBox(_x_,_y_,_width_,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_,_y_ + 1,_width_,_height_ - 2, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_ + 1,_y_,_width_ - 2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BackColor($FFB775&$FFFFFF|255<<24) 
          FrontColor($F67905&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
          RoundBox(_x_ + 3,_y_ + 1,_width_ - 6,_height_ - 2, 2,2)
          RoundBox(_x_ + 1,_y_ + 3,_width_ - 2,_height_ - 6, 2,2)
          RoundBox(_x_ + 1,_y_ + 1,_width_ - 2,_height_ - 2, 4,4)
        Else
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          
          RoundBox(_x_,_y_,_width_,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_,_y_ + 1,_width_,_height_ - 2, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_ + 1,_y_,_width_ - 2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BackColor($FFFFFF&$FFFFFF|255<<24)
          FrontColor($EEEEEE&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
          RoundBox(_x_ + 3,_y_ + 1,_width_ - 6,_height_ - 2, 2,2)
          RoundBox(_x_ + 1,_y_ + 3,_width_ - 2,_height_ - 6, 2,2)
          RoundBox(_x_ + 1,_y_ + 1,_width_ - 2,_height_ - 2, 4,4)
        EndIf
      Else
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        
        If _checked_
          BackColor($FFB775&$FFFFFF|255<<24) 
          FrontColor($F67905&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $F67905&$FFFFFF|255<<24)
          
          If _type_ = 1
            RoundBox(_x_,_y_ + 1,_width_,_height_ - 2, 4,4, $F67905&$FFFFFF|255<<24)
            RoundBox(_x_ + 1,_y_,_width_ - 2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
            
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(_x_ + 3,_y_ + 1,_width_ - 6,_height_ - 2, 2,2)
            RoundBox(_x_ + 1,_y_ + 3,_width_ - 2,_height_ - 6, 2,2)
          EndIf
          
        Else
          BackColor($FFFFFF&$FFFFFF|255<<24)
          FrontColor($EEEEEE&$FFFFFF|255<<24)
          
          LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $7E7E7E&$FFFFFF|255<<24)
          
          If _type_ = 1
            RoundBox(_x_,_y_ + 1,_width_,_height_ - 2, 4,4, $7E7E7E&$FFFFFF|255<<24)
            RoundBox(_x_ + 1,_y_,_width_ - 2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
            
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(_x_ + 3,_y_ + 1,_width_ - 6,_height_ - 2, 2,2)
            RoundBox(_x_ + 1,_y_ + 3,_width_ - 2,_height_ - 6, 2,2)
          EndIf
        EndIf
      EndIf
      
      If _checked_
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        
        If _type_ = 1
          RoundBox(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 4,4, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
                                                                                                       ; RoundBox(_x_ + (_width_ - 8)/2,_y_ + (_height_ - 8)/2, 8,8, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
        ElseIf _type_ = 3
          If _checked_ > 1
            Box(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 4,4, _color_&$FFFFFF|_alpha_<<24) ; правая линия
          Else
            If _width_ = 15
              LineXY((_x_ + 4),(_y_ + 8),(_x_ + 5),(_y_ + 9),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              LineXY((_x_ + 4),(_y_ + 9),(_x_ + 5),(_y_ + 10),_color_&$FFFFFF|_alpha_<<24); Левая линия
              
              LineXY((_x_ + 9),(_y_ + 4),(_x_ + 6),(_y_ + 10),_color_&$FFFFFF|_alpha_<<24) ; правая линия
              LineXY((_x_ + 10),(_y_ + 4),(_x_ + 7),(_y_ + 10),_color_&$FFFFFF|_alpha_<<24); правая линия
              
            Else
              LineXY((_x_ + 2),(_y_ + 6),(_x_ + 4),(_y_ + 7),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              LineXY((_x_ + 2),(_y_ + 7),(_x_ + 4),(_y_ + 8),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
              
              LineXY((_x_ + 8),(_y_ + 2),(_x_ + 5),(_y_ + 8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
              LineXY((_x_ + 9),(_y_ + 2),(_x_ + 6),(_y_ + 8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
            EndIf
          EndIf
        EndIf
      EndIf
      
    EndMacro
    
    Procedure   _Tree_Update(*this._s_widget, List *row._s_rows())
      If *this\change > 0
        *this\x[#__c_required] = 0
        *this\y[#__c_required] = 0
        *this\width[#__c_required] = 0
        *this\height[#__c_required] = 0
      EndIf
      
      ; reset item z - order
      PushListPosition(*row())
      ForEach *row()
        If *row()\parent
          *row()\parent\first = 0
          *row()\parent\last = 0
        EndIf     
      Next
      ;       PopListPosition(*row())
      Protected bp = 12; + Bool(*this\mode\check <> 4) * 8
      
      ;       
      ;       PushListPosition(*row())
      ForEach *row()
        If *row()\hide
          *row()\draw = 0
        Else
          If *this\change > 0
            ; check box position
            If *this\mode\check = 1 Or 
               *this\mode\check = 4
              *row()\box[1]\width = 12
              *row()\box[1]\height = 12
            EndIf
            
            If (*this\mode\lines Or *this\mode\buttons)
              *row()\box[0]\width = 9
              *row()\box[0]\height = 9
            EndIf
            
            ; drawing item font
            _drawing_font_item_(*this, *row(), *row()\text\change)
            
            *row()\x = *this\x[#__c_inner]
            *row()\height = *row()\text\height + 2 ;
            *row()\y = *this\y[#__c_inner] + *this\height[#__c_required]
            
            *row()\width = *this\width[#__c_inner] ; ???
          EndIf
          
          ; 
          If *this\mode\check = 4
            If *this\mode\buttons
              *row()\sublevellen = *row()\sublevel * *this\row\sublevellen + *row()\box[1]\width + 6 ;+ 18
            Else
              *row()\sublevellen = 18
            EndIf
          Else
            *row()\sublevellen = *row()\sublevel * *this\row\sublevellen + Bool(*this\mode\lines Or *this\mode\buttons) * (bp+bp/2) + Bool(*this\mode\check = 1) * 18
          EndIf
          
          If *this\mode\check = 1 Or *this\mode\check = 4
            If *row()\parent And *this\mode\check = 4
              *row()\box[1]\x = *row()\x + *row()\sublevellen - *row()\box[1]\width - *this\scroll\h\bar\page\pos
            Else
              *row()\box[1]\x = *row()\x + 6 - *this\scroll\h\bar\page\pos
            EndIf
            *row()\box[1]\y = (*row()\y + *row()\height) - (*row()\height + *row()\box[1]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; expanded & collapsed box position
          If *this\mode\lines Or *this\mode\buttons 
            ;  *row()\box[0]\x = *row()\x + *row()\sublevellen - *this\row\sublevellen + Bool(*this\mode\buttons Or *this\mode\lines) * 8 - *this\scroll\h\bar\page\pos 
            If *this\mode\check = 4
              *row()\box[0]\x = *row()\x + *row()\sublevellen - 10 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            Else
              *row()\box[0]\x = *row()\x + *row()\sublevellen - bp+2 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            EndIf
            *row()\box[0]\y = (*row()\y + *row()\height) - (*row()\height + *row()\box[0]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          If *row()\img
            ; image position
            *row()\img\x = *row()\x + *row()\sublevellen + *this\img\padding\left + 3 - *this\scroll\h\bar\page\pos
            *row()\img\y = *row()\y + (*row()\height - *row()\img\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          If *row()\text\string
            ; text position
            *row()\text\x = *row()\x + *row()\sublevellen + *this\row\margin\width + *this\text\padding\left - *this\scroll\h\bar\page\pos
            *row()\text\y = *row()\y + (*row()\height - *row()\text\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          If *this\change > 0
            *this\height[#__c_required] + *row()\height + Bool(*row()\index <> *this\count\items - 1) * *this\mode\GridLines
            
            If *this\width[#__c_required] < (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
              *this\width[#__c_required] = (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(*row())
      
      ; if the item list has changed
      If *this\change > 0
        ; *this\height[#__c_required] - *this\mode\gridlines
        
        ; change vertical scrollbar max
        If *this\scroll\v\bar\max <> *this\height[#__c_required] And
           bar_SetAttribute(*this\scroll\v, #__bar_Maximum, *this\height[#__c_required])
          
          Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; change horizontal scrollbar max
        If *this\scroll\h\bar\max <> *this\width[#__c_required] And
           bar_SetAttribute(*this\scroll\h, #__bar_Maximum, *this\width[#__c_required])
          
          Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; 
        If *this\row\selected And *this\row\scrolled
          bar_SetState(*this\scroll\v, ((*this\row\selected\y - *this\scroll\v\y) - (Bool(*this\row\scrolled>0) * (*this\scroll\v\bar\page\len - *this\row\selected\height))) ) 
          *this\scroll\v\change = 0 
          *this\row\scrolled = 0
          
          Tree_Draw(*this, *this\row\draws())
        EndIf
        
      EndIf
      
      ClearList(*this\row\draws())
      
      PushListPosition(*row())
      ForEach *row()
        *row()\draw = Bool(Not *row()\hide And 
                           ((*row()\y + *row()\height) - *this\scroll\v\bar\page\pos > *this\y[#__c_inner] And 
                            (*row()\y - *this\y[#__c_inner]) - *this\scroll\v\bar\page\pos < *this\height[#__c_inner]))
        
        ; lines for tree widget
        If *this\mode\lines And *this\row\sublevellen
          
          ; ; ;             If *row()\parent
          ; ; ;               ; set z - order position 
          ; ; ;               If Not *row()\parent\first 
          ; ; ;                 If Not *row()\parent\last
          ; ; ;                   ; Debug *row()\index
          ; ; ;                   *row()\parent\last = *row()
          ; ; ;                 EndIf
          ; ; ;                 ; Debug *row()\index
          ; ; ;                 *row()\parent\first = *row()
          ; ; ;               ElseIf *row()\parent\last
          ; ; ;                 *row()\before = *row()\parent\last
          ; ; ;                 *row()\before\after = *row()
          ; ; ;                 
          ; ; ;                 *row()\parent\last = *row()
          ; ; ;               EndIf
          ; ; ;             EndIf
          
          ; vertical lines for tree widget
          If *row()\parent 
            
            If *row()\draw
              If *row()\parent\last
                *row()\parent\last\l\v\height = 0
                
                *row()\parent\last\first = 0
              EndIf
              
              *row()\first = *row()\parent
              *row()\parent\last = *row()
            Else
              
              If *row()\parent\last
                *row()\parent\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  *row()\parent\last\l\v\y 
              EndIf
              
            EndIf
            
          Else
            If *row()\draw
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                If *this\row\first\last\first
                  *this\row\first\last\l\v\height = 0
                  
                  *this\row\first\last\first = 0
                EndIf
              EndIf
              
              *row()\first = *this\row\first
              *this\row\first\last = *row()
              
            Else
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                
                *this\row\first\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  *this\row\first\last\l\v\y
                ;Debug *row()\text\string
              EndIf
            EndIf
          EndIf
          
          *row()\l\h\y = *row()\box[0]\y + *row()\box[0]\height/2
          *row()\l\v\x = *row()\box[0]\x + *row()\box[0]\width/2
          
          If (*this\x[#__c_inner] - *row()\l\v\x) < *this\mode\lines
            If *row()\l\v\x<*this\x[#__c_inner]
              *row()\l\h\width = (*this\mode\lines - (*this\x[#__c_inner] - *row()\l\v\x))
            Else
              *row()\l\h\width = *this\mode\lines
            EndIf
            
            If *row()\draw And *row()\l\h\y > *this\y[#__c_inner] And *row()\l\h\y < *this\y[#__c_inner] + *this\height[#__c_inner]
              *row()\l\h\x = *row()\l\v\x + (*this\mode\lines - *row()\l\h\width)
              *row()\l\h\height = 1
            Else
              *row()\l\h\height = 0
            EndIf
            
            ; Vertical plot
            If *row()\first And *this\x[#__c_inner]<*row()\l\v\x
              *row()\l\v\y = (*row()\first\y + *row()\first\height -  Bool(*row()\first\sublevel = *row()\sublevel) * *row()\first\height/2) - *this\scroll\v\bar\page\pos
              If *row()\l\v\y < *this\y[#__c_inner] : *row()\l\v\y = *this\y[#__c_inner] : EndIf
              
              *row()\l\v\height = (*row()\y + *row()\height/2) - *row()\l\v\y - *this\scroll\v\bar\page\pos
              If *row()\l\v\height < 0 : *row()\l\v\height = 0 : EndIf
              If *row()\l\v\y + *row()\l\v\height > *this\y[#__c_inner] + *this\height[#__c_inner] 
                If *row()\l\v\y > *this\y[#__c_inner] + *this\height[#__c_inner] 
                  *row()\l\v\height = 0
                Else
                  *row()\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  *row()\l\v\y 
                EndIf
              EndIf
              
              If *row()\l\v\height
                *row()\l\v\width = 1
              Else
                *row()\l\v\width = 0
              EndIf
            EndIf 
            
          EndIf
        EndIf
        
        If *row()\draw And 
           AddElement(*this\row\draws())
          *this\row\draws() = *row()
        EndIf
      Next
      PopListPosition(*row())
      
    EndProcedure
    
    Procedure   Tree_Update(*this._s_widget, List row._s_rows())
      Debug #PB_Compiler_Procedure
      
      If *this\change > 0
        *this\x[#__c_required] = 0
        *this\y[#__c_required] = 0
        *this\width[#__c_required] = 0
        *this\height[#__c_required] = 0
      EndIf
      
      ; reset item z - order
      PushListPosition(row())
      ForEach row()
        If row()\parent
          row()\parent\first = 0
          row()\parent\last = 0
        EndIf     
      Next
      ;       PopListPosition(row())
      Protected bp = 12; + Bool(*this\mode\check <> 4) * 8
      
      ;       
      ;       PushListPosition(row())
      ForEach row()
        row()\index = ListIndex(row())
        
        If row()\hide
          row()\draw = 0
        Else
          If *this\change > 0
            ; check box position
            If (*this\mode\check = 1 Or 
                *this\mode\check = 4)
              row()\box[1]\width = 12
              row()\box[1]\height = 12
            EndIf
            
            If (*this\mode\lines Or *this\mode\buttons) And
               Not (row()\sublevel And *this\mode\check = 4)
              row()\box[0]\width = 9
              row()\box[0]\height = 9
            EndIf
            
            ; drawing item font
            _drawing_font_item_(*this, row(), row()\text\change)
            
            row()\height = row()\text\height + 2 ;
            row()\y = *this\y[#__c_inner] + *this\height[#__c_required]
            
            row()\x = *this\x[#__c_inner]
            row()\width = *this\width[#__c_inner] ; ???
          EndIf
          
          ;           ; sublevel position
          ;           If (*this\mode\check = 4)
          ;             If *this\mode\buttons
          ;               row()\sublevellen = row()\sublevel * *this\row\sublevellen + row()\box[1]\width + 6 ;+ 18
          ;             Else
          ;               row()\sublevellen = 18
          ;             EndIf
          ;           Else
          ;             row()\sublevellen = row()\sublevel * *this\row\sublevellen + Bool(*this\mode\lines Or *this\mode\buttons) * (bp+bp/2) + Bool(*this\mode\check = 1) * 18
          ;           EndIf
          
          row()\sublevellen = row()\sublevel * *this\row\sublevellen + Bool(*this\mode\lines Or *this\mode\buttons) * (bp+bp/2) + Bool(*this\mode\check) * 18
          
          ; check & option box position
          If (*this\mode\check = 1 Or 
              *this\mode\check = 4)
            
            If row()\parent And *this\mode\check = 4
              row()\box[1]\x = row()\x + row()\sublevellen - row()\box[1]\width - *this\scroll\h\bar\page\pos
            Else
              row()\box[1]\x = row()\x + 6 - *this\scroll\h\bar\page\pos
            EndIf
            row()\box[1]\y = (row()\y + row()\height) - (row()\height + row()\box[1]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; expanded & collapsed box position
          If (*this\mode\lines Or *this\mode\buttons) And Not (row()\sublevel And *this\mode\check = 4)
            
            If *this\mode\check = 4
              row()\box[0]\x = row()\x + row()\sublevellen - 10 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            Else
              row()\box[0]\x = row()\x + row()\sublevellen - bp+2 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            EndIf
            row()\box[0]\y = (row()\y + row()\height) - (row()\height + row()\box[0]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; image position
          If row()\img
            row()\img\x = row()\x + row()\sublevellen + *this\img\padding\left + 3 - *this\scroll\h\bar\page\pos
            row()\img\y = row()\y + (row()\height - row()\img\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; text position
          If row()\text\string
            row()\text\x = row()\x + row()\sublevellen + *this\row\margin\width + *this\text\padding\left - *this\scroll\h\bar\page\pos
            row()\text\y = row()\y + (row()\height - row()\text\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          If row()\text\edit\string
            row()\text\edit\x = row()\x + row()\sublevellen + *this\row\margin\width + *this\text\padding\left - *this\scroll\h\bar\page\pos  + *this\bar\page\pos; *this\bar\page\pos + row()\x + row()\sublevellen + 5
            row()\text\edit\y = row()\text\y
          EndIf
          
          ; vertical & horizontal scroll max value
          If *this\change > 0
            *this\height[#__c_required] + row()\height + Bool(row()\index <> *this\count\items - 1) * *this\mode\GridLines
            
            If *this\width[#__c_required] < (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
              *this\width[#__c_required] = (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
            EndIf
          EndIf
        EndIf
      Next
      ;       PopListPosition(row())
      
      ; if the item list has changed
      If *this\change > 0
        ; *this\height[#__c_required] - *this\mode\gridlines
        
        ; change vertical scrollbar max
        If *this\scroll\v\bar\max <> *this\height[#__c_required] And
           bar_SetAttribute(*this\scroll\v, #__bar_Maximum, *this\height[#__c_required])
          
          Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; change horizontal scrollbar max
        If *this\scroll\h\bar\max <> *this\width[#__c_required] And
           bar_SetAttribute(*this\scroll\h, #__bar_Maximum, *this\width[#__c_required])
          
          Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; 
        If *this\row\selected And *this\row\scrolled
          bar_SetState(*this\scroll\v, ((*this\row\selected\y - *this\scroll\v\y) - (Bool(*this\row\scrolled>0) * (*this\scroll\v\bar\page\len - *this\row\selected\height))) ) 
          *this\scroll\v\change = 0 
          *this\row\scrolled = 0
          
          Tree_Draw(*this, *this\row\draws())
        EndIf
      EndIf
      
      ; reset draw list
      ClearList(*this\row\draws())
      
      ;        PushListPosition(row())
      ForEach row()
        row()\draw = Bool(Not row()\hide And 
                          ((row()\y + row()\height) - *this\scroll\v\bar\page\pos > *this\y[#__c_inner] And 
                           (row()\y - *this\y[#__c_inner]) - *this\scroll\v\bar\page\pos < *this\height[#__c_inner]))
        
        ; lines for tree widget
        If *this\mode\lines And *this\row\sublevellen
          
          ; ; ;             If row()\parent
          ; ; ;               ; set z - order position 
          ; ; ;               If Not row()\parent\first 
          ; ; ;                 If Not row()\parent\last
          ; ; ;                   ; Debug row()\index
          ; ; ;                   row()\parent\last = row()
          ; ; ;                 EndIf
          ; ; ;                 ; Debug row()\index
          ; ; ;                 row()\parent\first = row()
          ; ; ;               ElseIf row()\parent\last
          ; ; ;                 row()\before = row()\parent\last
          ; ; ;                 row()\before\after = row()
          ; ; ;                 
          ; ; ;                 row()\parent\last = row()
          ; ; ;               EndIf
          ; ; ;             EndIf
          
          ; vertical lines for tree widget
          If row()\parent 
            
            If row()\draw
              If row()\parent\last
                row()\parent\last\l\v\height = 0
                
                row()\parent\last\first = 0
              EndIf
              
              row()\first = row()\parent
              row()\parent\last = row()
            Else
              
              If row()\parent\last
                row()\parent\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  row()\parent\last\l\v\y 
              EndIf
              
            EndIf
            
          Else
            If row()\draw
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                If *this\row\first\last\first
                  *this\row\first\last\l\v\height = 0
                  
                  *this\row\first\last\first = 0
                EndIf
              EndIf
              
              row()\first = *this\row\first
              *this\row\first\last = row()
              
            Else
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                
                *this\row\first\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  *this\row\first\last\l\v\y
                ;Debug row()\text\string
              EndIf
            EndIf
          EndIf
          
          row()\l\h\y = row()\box[0]\y + row()\box[0]\height/2
          row()\l\v\x = row()\box[0]\x + row()\box[0]\width/2
          
          If (*this\x[#__c_inner] - row()\l\v\x) < *this\mode\lines
            If row()\l\v\x<*this\x[#__c_inner]
              row()\l\h\width = (*this\mode\lines - (*this\x[#__c_inner] - row()\l\v\x))
            Else
              row()\l\h\width = *this\mode\lines
            EndIf
            
            If row()\draw And row()\l\h\y > *this\y[#__c_inner] And row()\l\h\y < *this\y[#__c_inner] + *this\height[#__c_inner]
              row()\l\h\x = row()\l\v\x + (*this\mode\lines - row()\l\h\width)
              row()\l\h\height = 1
            Else
              row()\l\h\height = 0
            EndIf
            
            ; Vertical plot
            If row()\first And *this\x[#__c_inner]<row()\l\v\x
              row()\l\v\y = (row()\first\y + row()\first\height -  Bool(row()\first\sublevel = row()\sublevel) * row()\first\height/2) - *this\scroll\v\bar\page\pos
              If row()\l\v\y < *this\y[#__c_inner] : row()\l\v\y = *this\y[#__c_inner] : EndIf
              
              row()\l\v\height = (row()\y + row()\height/2) - row()\l\v\y - *this\scroll\v\bar\page\pos
              If row()\l\v\height < 0 : row()\l\v\height = 0 : EndIf
              If row()\l\v\y + row()\l\v\height > *this\y[#__c_inner] + *this\height[#__c_inner] 
                If row()\l\v\y > *this\y[#__c_inner] + *this\height[#__c_inner] 
                  row()\l\v\height = 0
                Else
                  row()\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  row()\l\v\y 
                EndIf
              EndIf
              
              If row()\l\v\height
                row()\l\v\width = 1
              Else
                row()\l\v\width = 0
              EndIf
            EndIf 
            
          EndIf
        EndIf
        
        ; add new draw list
        If row()\draw And 
           AddElement(*this\row\draws())
          *this\row\draws() = row()
        EndIf
      Next
      PopListPosition(row())
      
    EndProcedure
    
    
    Procedure.l Tree_Draw(*this._s_widget, List *row._s_rows())
      Protected state.b
      
      With *this
        If Not \hide
          If \change <> 0
            Tree_Update(*this, *this\row\_s())
            \change = 0
          EndIf 
          
          ; Draw background
          If *this\color\alpha
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],
                     *this\width[#__c_frame],*this\height[#__c_frame],
                     *this\round,*this\round,*this\color\back[*this\color\state])
          EndIf
          
          ; Draw background image
          If *this\img\index
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(*this\img\index, *this\img\x, *this\img\y, *this\color\alpha)
          EndIf
          
          ;
          PushListPosition(*row())
          
          ; Draw all items
          ForEach *row()
            If *row()\draw
              If *row()\width <> *this\width[#__c_inner]
                *row()\width = *this\width[#__c_inner]
              EndIf
              
              ; init real drawing font
              _drawing_font_item_(*this, *row(), 0)
              
              state = *row()\color\state  ; +  Bool(*row()\color\state = #__s_2 And *this <> GetActive()\gadget)
              
              ; Draw selector back
              If *row()\childrens And *this\_flag & #__tree_property
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*this\x[#__c_inner], *row()\y - *this\scroll\v\bar\page\pos, *this\width[#__c_inner],*row()\height,*row()\round,*row()\round,*row()\color\back)
                ;RoundBox(*this\x[#__c_inner] + *this\row\sublevellen,Y,*this\width[#__c_inner] - *this\row\sublevellen,*row()\height,*row()\round,*row()\round,*row()\color\back[state])
                Line(*this\x[#__c_inner] + *this\row\sublevellen, *row()\y + *row()\height - *this\scroll\v\bar\page\pos, *this\width[#__c_inner] - *this\row\sublevellen, 1, $FFACACAC)
                
              Else
                If *row()\color\back[state]
                  DrawingMode(#PB_2DDrawing_Default)
                  RoundBox(*row()\x, *row()\y - *this\scroll\v\bar\page\pos, *row()\width, *row()\height,*row()\round,*row()\round,*row()\color\back[state])
                EndIf
              EndIf
              
              ; Draw items image
              If *row()\img\index[2]
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(*row()\img\index[2], *row()\img\x, *row()\img\y, *row()\color\alpha)
              EndIf
              
              ; Draw items text
              If *row()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(*row()\text\x, *row()\text\y, *row()\text\string.s, *this\text\rotate, *row()\color\front[state])
              EndIf
              
              ; Draw items data text
              If *row()\text\edit\string.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(*row()\text\edit\x, *row()\text\edit\y, *row()\text\edit\string.s, *this\text\rotate, *row()\color\front[state])
              EndIf
              
              ; Draw selector frame
              If *row()\childrens And *this\_flag & #__tree_property
              Else
                If *row()\color\frame[state]
                  DrawingMode(#PB_2DDrawing_Outlined)
                  RoundBox(*row()\x, *row()\y - *this\scroll\v\bar\page\pos, *row()\width, *row()\height, *row()\round,*row()\round, *row()\color\frame[state])
                EndIf
              EndIf
              
              ; Horizontal line
              If *this\mode\GridLines And 
                 *row()\color\line <> *row()\color\back
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(*row()\x, (*row()\y + *row()\height + Bool(*this\mode\gridlines>1)) - *this\scroll\v\bar\page\pos, *row()\width, 1, *this\color\line)
              EndIf
            EndIf
          Next
          
          ;           DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
          ;           Box(*this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevellen, *this\height[#__c_inner], *this\row\_s()\parent\color\back)
          
          
          ; Draw plots
          If *this\mode\lines
            ;DrawingMode(#PB_2DDrawing_XOr);|#PB_2DDrawing_AlphaBlend)
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            ;DrawingMode(#PB_2DDrawing_XOr|#PB_2DDrawing_customFilter) 
            
            ;             CustomFilterCallback(@Draw_PlotX())
            ForEach *row()
              If *row()\draw 
                If *row()\l\h\height
                  Line(*row()\l\h\x, *row()\l\h\y, *row()\l\h\width, *row()\l\h\height, *row()\color\line)
                EndIf
                ;               EndIf    
                ;             Next
                ;             
                ;             CustomFilterCallback(@Draw_PlotY())
                ;             ForEach *row()
                ;               If *row()\draw 
                If *row()\l\v\width
                  Line(*row()\l\v\x, *row()\l\v\y, *row()\l\v\width, *row()\l\v\height, *row()\color\line)
                EndIf
              EndIf    
            Next
            
            
            ; ; ;           ; Draw plots
            ; ; ;           If *this\mode\lines
            ; ; ;             ;DrawingMode(#PB_2DDrawing_XOr);|#PB_2DDrawing_AlphaBlend)
            ; ; ;             ;DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            ; ; ;              DrawingMode(#PB_2DDrawing_customFilter) 
            ; ; ;             
            ; ; ;               CustomFilterCallback(@Draw_PlotX())
            ; ; ;             ForEach *row()
            ; ; ;               If *row()\draw 
            ; ; ;                 Line(*row()\box[0]\x + *row()\box[0]\width/2, *row()\box[0]\y + *row()\box[0]\height/2, *this\mode\lines, 1, *row()\color\front[*row()\color\state])
            ; ; ;               EndIf    
            ; ; ;             Next
            ; ; ;             
            ; ; ;               CustomFilterCallback(@Draw_PlotY())
            ; ; ;             ForEach *row()
            ; ; ;               If *row()\draw 
            ; ; ;                 ;                 If *row()\before And *row()\before\sublevel = *row()\sublevel
            ; ; ;                 ;                  Line(*row()\l\v\x, *row()\before\y - *this\scroll\v\bar\page\pos, 1, *row()\y - *row()\before\y + Bool(*row()\parent\last = *row()) * *row()\height/2, *row()\color\line)
            ; ; ;                 ;                 EndIf
            ; ; ;                 If *row()\after
            ; ; ;                   Line(*row()\after\box[0]\x + *row()\after\box[0]\width/2, *row()\y - *this\scroll\v\bar\page\pos, 1, *row()\after\y - *row()\y, *row()\color\front[*row()\color\state])
            ; ; ;                 Else
            ; ; ;                   Line(*row()\box[0]\x + *row()\box[0]\width/2, *row()\y - *this\scroll\v\bar\page\pos, 1, *row()\height/2, *row()\color\front[*row()\color\state])
            ; ; ;                 EndIf
            ; ; ;               EndIf    
            ; ; ;             Next
            ; ; ;           EndIf
          EndIf
          
          ; Draw check buttons
          If *this\mode\buttons Or
             (*this\mode\check = 1 Or *this\mode\check = 4)
            DrawingMode(#PB_2DDrawing_Default)
            
            ForEach *row()
              If *row()\draw 
                If *this\mode\check
                  ; Draw box (check&option)
                  If *row()\parent And *this\mode\check = 4
                    _tree_box_(*row()\box[1]\x, *row()\box[1]\y, *row()\box[1]\width, *row()\box[1]\height, *row()\box[1]\state, 1, $FFFFFFFF, 7, 255)
                  Else;If Not (*this\mode\buttons And *row()\childrens And *this\mode\check = 4)
                    _tree_box_(*row()\box[1]\x, *row()\box[1]\y, *row()\box[1]\width, *row()\box[1]\height, *row()\box[1]\state, 3, $FFFFFFFF, 2, 255)
                  EndIf
                EndIf
                
                ; Draw button (expanded&collapsed)
                If *this\mode\buttons And *row()\childrens And 
                   Not (*row()\sublevel And *this\mode\check = 4)
                  
                  Arrow(*row()\box[0]\x + (*row()\box[0]\width - 6)/2,
                        *row()\box[0]\y + (*row()\box[0]\height - 6)/2, 
                        6, Bool(Not *row()\box[0]\state) + 2,
                        *row()\color\front[0], 0,0)   ; *row()\color\state
                EndIf 
                
              EndIf    
            Next
          EndIf
          
          ; 
          PopListPosition(*row()) ; 
          
          
          ; Draw frames
          If *this\fs
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame],*this\round,*this\round,*this\color\frame[Bool(*this\color\state) * 2])
          EndIf
          
          ; Draw scroll bars
          Area_Draw(*this)
        EndIf
      EndWith
      
    EndProcedure
    
    
    Procedure.l Tree_SetItemState(*this._s_widget, Item.l, State.b)
      Protected Result.l, collapsed.b, sublevel.l, *SelectElement
      
      If Item < 0 : Item = 0 : EndIf
      If Item > *this\count\items - 1 
        Item = *this\count\items - 1 
      EndIf
      
      *SelectElement = SelectElement(*this\row\_s(), Item) 
      
      If *SelectElement 
        If State & #__tree_Selected
          If *this\row\selected And *this\mode\check = 4 ;& #__flag_multiselect
            *this\row\selected\color\state = #__s_0
          EndIf
          *this\row\_s()\color\state = #__s_3
          *this\row\selected = *this\row\_s()
        EndIf
        
        If State & #__tree_inbetween = #__tree_inbetween
          *this\row\_s()\box[1]\state = 2 
          
        ElseIf State & #__tree_checked = #__tree_checked
          *this\row\_s()\box[1]\state = 1
        EndIf
        
        If State & #__tree_collapsed
          collapsed = 1
        EndIf
        
        If collapsed Or State & #__tree_Expanded
          *this\row\_s()\box[0]\state = collapsed
          
          sublevel = *this\row\_s()\sublevel
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel = sublevel
              Break
            ElseIf *this\row\_s()\sublevel > sublevel 
              *this\row\_s()\hide = collapsed
              ;*this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\state | *this\row\_s()\parent\hide)
              
            EndIf
          Wend
          PushListPosition(*this\row\_s())
        EndIf
        
        Result = *SelectElement
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i Tree_AddItem(*this._s_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0)
      Protected handle, *parent._s_rows
      
      ;With *this
      If *this
        If sublevel =- 1
          If *this\mode\check <> 4 And 
             *this\_flag & #__tree_optionboxes = 0
            *this\_flag | #__tree_optionboxes
            *this\mode\check = 4
          EndIf
        EndIf
        
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize(*this\row\_s()) - 1
          If LastElement(*this\row\_s())
            If *this\mode\check = 4
              If sublevel <> 0 And *this\row\_s()\parent
                If sublevel > 0 And *this\row\_s()\sublevel
                  sublevel = *this\row\_s()\sublevel
                EndIf
                *parent = *this\row\_s()\parent
              Else
                *parent = *this\row\_s()
              EndIf
            EndIf
          EndIf
          
          handle = AddElement(*this\row\_s()) 
          If position < 0 
            position = ListIndex(*this\row\_s())
          EndIf
        Else
          handle = SelectElement(*this\row\_s(), position)
          
          If sublevel < *this\row\_s()\sublevel
            sublevel = *this\row\_s()\sublevel 
          EndIf
          
          If *this\mode\check = 4
            If sublevel <> 0 And *this\row\_s()\parent
              If sublevel > 0 And *this\row\_s()\sublevel
                sublevel = *this\row\_s()\sublevel
              EndIf
              *parent = *this\row\_s()\parent
            Else
              *parent = *this\row\_s()
            EndIf
          EndIf
          
          handle = InsertElement(*this\row\_s())
        EndIf
        ;}
        
        If handle
          ;*this\row\i(Hex(position)) = ListIndex(*this\row\_s())
          
          ;             If Not \row\_s()
          ;               \row\_s() = AllocateStructure(_s_rows)
          ;             EndIf
          If Not ListIndex(*this\row\_s()) Or Not position
            *this\row\first = *this\row\_s()
          EndIf
          
          If *this\mode\check = 4
            If sublevel <> 0
              If *parent
                *this\row\_s()\parent = *parent
                ; if not the parent option add the childrens
                If *this\row\_s()\parent\parent <> *this\row\_s()\parent 
                  *this\row\_s()\parent\childrens + 1
                EndIf
                
                If sublevel > 0
                  *this\row\_s()\sublevel = Bool(*this\mode\buttons) * sublevel ;+ 
                EndIf
              Else
                ; if first item option
                *this\row\_s()\parent = *this\row\_s()
              EndIf
              
              sublevel = 0
            EndIf
            
            ; set option group
            If *this\row\_s()\parent
              *this\row\_s()\option_group = *this\row\_s()\parent
            EndIf
          EndIf
          
          If sublevel
            If sublevel > position
              sublevel = position
            EndIf
            
            PushListPosition(*this\row\_s())
            While PreviousElement(*this\row\_s()) 
              If sublevel = *this\row\_s()\sublevel
                *parent = *this\row\_s()\parent
                Break
              ElseIf sublevel > *this\row\_s()\sublevel
                *parent = *this\row\_s()
                Break
              EndIf
            Wend 
            PopListPosition(*this\row\_s())
            
            If *parent
              If sublevel > *parent\sublevel
                sublevel = *parent\sublevel + 1
                *parent\childrens + 1
              EndIf
              
              *this\row\_s()\parent = *parent
            EndIf
            
            *this\row\_s()\sublevel = sublevel
          EndIf
          
          If *this\mode\collapse And *this\row\_s()\parent And 
             *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel
            *this\row\_s()\parent\box[0]\state = 1 
            *this\row\_s()\hide = 1
          EndIf
          
          ; properties
          If *this\_Flag & #__tree_property
            If *parent And Not *parent\sublevel And Not *parent\text\fontID
              *parent\color\back = $FFF9F9F9
              *parent\color\back[1] = *parent\color\back
              *parent\color\back[2] = *parent\color\back
              *parent\color\frame = *parent\color\back
              *parent\color\frame[1] = *parent\color\back
              *parent\color\frame[2] = *parent\color\back
              *parent\color\front[1] = *parent\color\front
              *parent\color\front[2] = *parent\color\front
              *parent\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 14, #PB_Font_Bold|#PB_Font_Italic))
            EndIf
          EndIf
          
          ; add lines
          *this\row\_s()\index = ListIndex(*this\row\_s())
          *this\row\_s()\color = _get_colors_()
          *this\row\_s()\color\state = 0
          *this\row\_s()\color\back = 0 
          *this\row\_s()\color\frame = 0
          
          *this\row\_s()\color\fore[0] = 0 
          *this\row\_s()\color\fore[1] = 0
          *this\row\_s()\color\fore[2] = 0
          *this\row\_s()\color\fore[3] = 0
          
          If Text
            *this\row\_s()\text\change = 1
            *this\row\_s()\text\string = StringField(Text.s, 1, #LF$)
            *this\row\_s()\text\edit\string = StringField(Text.s, 2, #LF$)
          EndIf
          
          _set_item_image_(*this, *this\row\_s(), Image)
          
          If *this\row\selected 
            *this\row\scrolled = 0
            *this\row\selected\color\state = 0
            *this\row\selected = *this\row\_s() 
            *this\row\selected\color\state = 2 + Bool(GetActive()\gadget <> *this)
          EndIf
          
          _repaint_items_(*this)
          *this\count\items + 1
          *this\change = 1
        EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *this\count\items - 1
    EndProcedure
    
    
    Procedure.l Tree_Events_Key(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected Result, from =- 1
      Static cursor_change, Down, *row_selected._s_rows
      
      With *this
        Select eventtype 
          Case #__Event_KeyDown
            ;If *this = GetActive()\gadget
            
            Select Keyboard()\key
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
                  If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                     (Keyboard()\key[1] & #PB_Canvas_Control)
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos - 18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If (Keyboard()\key = #PB_Shortcut_Home Or
                        (Keyboard()\key[1] & #PB_Canvas_Alt))
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
                      Post(#__Event_change, *this, *this\row\_s()\index)
                      Result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\row\selected
                  If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                     (Keyboard()\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos + 18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < (*this\count\items - 1)
                    ; select modifiers key
                    If (Keyboard()\key = #PB_Shortcut_End Or
                        (Keyboard()\key[1] & #PB_Canvas_Alt))
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
                      Post(#__Event_change, *this, *this\row\_s()\index)
                      Result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos - (*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos + (*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
            EndSelect
            
            ;EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l Tree_Events(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected Repaint
      
      If eventtype = #__Event_leftButtonUp
        ; collapsed button up
        If *this\row\box\state = 2
          *this\row\box\state =- 1
          Post(#PB_EventType_Up, *this, This()\item)
          Repaint | #True
        Else
          If *this\row\selected ;And *this\row\selected\index = This()\item
                                ; Debug "" + *this\row\selected\index  + " " +  This()\item
            If Not *this\mode\check
              If *this\row\selected\_state & #__s_selected = #False
                *this\row\selected\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\selected\index)
                
                If *this\_state & #__s_entered = #False
                  Post(#PB_EventType_LeftClick, *this, This()\item)
                EndIf
              EndIf
            EndIf
          EndIf
          
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #__Event_leftClick
        If *this\row\box\state =- 1
          *this\row\box\state = 0
        Else
          Post(#PB_EventType_LeftClick, *this, This()\item)
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #__Event_rightButtonUp
        Post(#PB_EventType_RightClick, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_Focus
        If *this\count\items
          PushListPosition(*this\row\_s()) 
          ForEach *this\row\_s()
            If *this\row\_s()\color\state = #__s_3
              *this\row\_s()\color\state = #__s_2
              *this\row\_s()\_state | #__s_selected
            EndIf
          Next
          PopListPosition(*this\row\_s()) 
        EndIf
        
        ; Post(#PB_EventType_Focus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        If *this\count\items
          PushListPosition(*this\row\_s()) 
          ForEach *this\row\_s()
            If *this\row\_s()\color\state = #__s_2
              *this\row\_s()\color\state = #__s_3
              *this\row\_s()\_state &~ #__s_selected
            EndIf
          Next
          PopListPosition(*this\row\_s()) 
        EndIf
        
        ; Post(#PB_EventType_lostFocus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_rightButtonDown Or
         eventtype = #__Event_leftButtonDown ;Or eventtype = #__Event_leftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And 
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
                
                If Not (Mouse()\buttons And *this\mode\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If (eventtype = #__Event_leftButtonDown) Or 
                 (Mouse()\buttons And Not *this\mode\check)
                
                ; collapsed/expanded button
                If eventtype = #__Event_leftButtonDown And 
                   (*this\mode\buttons And *this\row\draws()\childrens) And 
                   _from_point_(mouse_x, mouse_y, *this\row\draws()\box[0])
                  
                  If SelectElement(*this\row\_s(), *this\row\draws()\index) 
                    *this\row\_s()\box[0]\state ! 1
                    *this\row\box\state = 2
                    ; Post(#PB_EventType_Down, *this, *this\row\_s()\index)
                    
                    PushListPosition(*this\row\_s())
                    While NextElement(*this\row\_s())
                      If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
                        *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\state | *this\row\_s()\parent\hide)
                      Else
                        Break
                      EndIf
                    Wend
                    PopListPosition(*this\row\_s())
                    
                    *this\change = 1
                    If *this\root
                      ReDraw(*this)
                    EndIf
                  EndIf
                  
                Else
                  ; change box (option&check)
                  If _from_point_(mouse_x, mouse_y, *this\row\draws()\box[1])
                    *this\row\box\state = 1
                    ; change box option
                    If *this\mode\check = 4 And *this\row\draws()\parent
                      If *this\row\draws()\option_group  
                        If *this\row\draws()\option_group\parent And 
                           *this\row\draws()\option_group\box[1]\state
                          *this\row\draws()\option_group\box[1]\state = 0
                        EndIf
                        
                        If *this\row\draws()\option_group\option_group <> *this\row\draws()
                          If *this\row\draws()\option_group\option_group
                            *this\row\draws()\option_group\option_group\box[1]\state = 0
                          EndIf
                          *this\row\draws()\option_group\option_group = *this\row\draws()
                        EndIf
                      EndIf
                    EndIf
                    
                    ; change box check
                    If *this\mode\threestate And
                       *this\mode\check = 1
                      
                      Select *this\row\draws()\box[1]\state 
                        Case 0 : *this\row\draws()\box[1]\state = 2
                        Case 1 : *this\row\draws()\box[1]\state = 0
                        Case 2 : *this\row\draws()\box[1]\state = 1
                      EndSelect
                    Else
                      *this\row\draws()\box[1]\state ! 1
                    EndIf
                  EndIf
                  
                  If *this\mode\check = 2
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
                      If *this\mode\check = 3
                        If *this\row\selected\_state & #__s_selected
                          *this\row\selected\_state &~ #__s_selected
                          Post(#PB_EventType_Change, *this, *this\row\selected\index)
                        EndIf
                      EndIf
                      
                      *this\row\selected\_state &~ #__s_selected
                      ;EndIf
                      
                      *this\row\selected\color\state = #__s_0
                    EndIf
                    
                    If *this\mode\check = 3
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
              
              If *this\mode\check = 3 And
                 Mouse()\buttons
                Protected _index_, _selected_index_
                
                _index_ = *this\row\draws()\index
                _selected_index_ = *this\row\selected\index
                
                PushListPosition(*this\row\_s()) 
                ForEach *this\row\_s()
                  If *this\row\_s()\draw
                    If Bool((_selected_index_ >= *this\row\_s()\index And _index_ <= *this\row\_s()\index) Or ; верх
                            (_selected_index_ <= *this\row\_s()\index And _index_ >= *this\row\_s()\index))   ; вниз
                      
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
              If Not _from_point_(mouse_x - *this\x, mouse_y - *this\y, *this, [#__c_required])
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
      
      If eventtype = #__Event_Input Or
         eventtype = #__Event_KeyDown Or
         eventtype = #__Event_KeyUp
        
        If GetActive() And GetActive()\gadget = *this
          Repaint | Tree_Events_Key(*this, eventtype, mouse_x, mouse_y)
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Macro _multi_select_items_(_this_)
      PushListPosition(*this\row\_s()) 
      ForEach *this\row\_s()
        If *this\row\_s()\draw
          If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index <= *this\row\_s()\index) Or ; верх
                  (*this\row\selected\index >= *this\row\_s()\index And *this\row\entered\index <= *this\row\_s()\index))   ; вниз
            
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
    
    
    Procedure.l ListView_Events(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected Repaint
      
      If eventtype = #__Event_Focus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_3
            *this\row\_s()\color\state = #__s_2
            *this\row\_s()\_state | #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_Focus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_2
            *this\row\_s()\color\state = #__s_3
            *this\row\_s()\_state &~ #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_lostFocus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftButtonUp
        If *this\row\selected 
          If *this\mode\check = 3
            *this\row\entered = *this\row\selected
          EndIf
          
          If *this\mode\check <> 2 
            If *this\row\selected\_state & #__s_selected = #False
              *this\row\selected\_state | #__s_selected
              Post(#PB_EventType_Change, *this, *this\row\selected\index)
              Repaint | #True
            EndIf
          EndIf
          
          If *this\_state & #__s_entered = #False
            Post(#PB_EventType_LeftClick, *this, This()\item)
            Repaint | #True
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__Event_leftClick
        Post(#PB_EventType_LeftClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_rightClick
        Post(#PB_EventType_RightClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      
      If eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_rightButtonDown Or
         eventtype = #__Event_leftButtonDown ;Or eventtype = #__Event_leftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And 
               _from_point_(mouse_x + *this\scroll\h\bar\page\pos,
                            mouse_y + *this\scroll\v\bar\page\pos, *this\row\draws())
              
              ;  
              If Not *this\row\draws()\_state & #__s_entered 
                *this\row\draws()\_state | #__s_entered 
                
                ; 
                If Not Mouse()\buttons
                  *this\row\entered = *this\row\draws()
                EndIf
                
                If *this\row\draws()\color\state = #__s_0
                  *this\row\draws()\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                ;
                If Not (Mouse()\buttons And *this\mode\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If Mouse()\buttons
                If *this\mode\check
                  *this\row\selected = *this\row\draws()
                  
                  ; clickselect items
                  If *this\mode\check = 2
                    If eventtype = #__Event_leftButtonDown
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
                      If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index <= *this\row\_s()\index) Or ; верх
                              (*this\row\entered\index <= *this\row\_s()\index And *this\row\selected\index >= *this\row\_s()\index))   ; вниз
                        
                        If *this\mode\check = 2
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
                        If *this\mode\check = 3
                          If *this\row\_s()\color\state <> #__s_2
                            *this\row\_s()\color\state = #__s_2
                            Repaint | #True
                            
                            ; reset select before this 
                            ; example(sel 5;6;7, click 7, reset 5;6)
                          ElseIf eventtype = #__Event_leftButtonDown
                            If *this\row\selected <> *this\row\_s()
                              *this\row\_s()\color\state = #__s_0
                              Repaint | #True
                            EndIf
                          EndIf
                        EndIf
                        
                      Else
                        
                        If *this\mode\check = 2
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
                        
                        If *this\mode\check = 3
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
              If Mouse()\buttons And *this\mode\check
                If *this\mode\check = 3
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
      
      If eventtype = #__Event_KeyDown 
        Protected Result, from =- 1
        Static cursor_change, Down
        
        If GetActive() And GetActive()\gadget = *this
          
          
          
          Select Keyboard()\key
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
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  ; scroll to top
                  If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos - 18) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *this\row\selected\index > 0
                  ; select modifiers key
                  If (Keyboard()\key = #PB_Shortcut_Home Or
                      (Keyboard()\key[1] & #PB_Canvas_Alt))
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
                    
                    
                    
                    If Not Keyboard()\key[1] & #PB_Canvas_Shift
                      *this\row\entered = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = 3
                      _multi_select_items_(*this)
                    EndIf
                    
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    Post(#__Event_change, *this, *this\row\_s()\index)
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Down,
                 #PB_Shortcut_End
              If *this\row\selected
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos + 18) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *this\row\selected\index < (*this\count\items - 1)
                  ; select modifiers key
                  If (Keyboard()\key = #PB_Shortcut_End Or
                      (Keyboard()\key[1] & #PB_Canvas_Alt))
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
                    
                    
                    If Not Keyboard()\key[1] & #PB_Canvas_Shift
                      *this\row\entered = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = 3
                      _multi_select_items_(*this)
                    EndIf
                    
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    Post(#__Event_change, *this, *this\row\_s()\index)
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Left
              If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                 (Keyboard()\key[1] & #PB_Canvas_Control)
                
                *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos - (*this\scroll\h\bar\page\end/10)) 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Right
              If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                 (Keyboard()\key[1] & #PB_Canvas_Control)
                
                *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos + (*this\scroll\h\bar\page\end/10)) 
                Repaint = 1
              EndIf
              
          EndSelect
          
          
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  WINDOW - e
    Procedure   Window_Draw(*this._s_widget)
      With *this 
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Protected i = 1
          
          If \fs = 1 
            For i = 1 To \round
              Line(\x[#__c_frame] + i - 1,\y[#__c_frame] + \caption\height - 1,1,Bool(\round)*(i - \round),\caption\color\back[\color\state])
              Line(\x[#__c_frame] + \width[#__c_frame] + i - \round - 1,\y[#__c_frame] + \caption\height - 1,1, - Bool(\round)*(i),\caption\color\back[\color\state])
            Next
          Else
            For i = 1 To \fs
              RoundBox(\x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i - 1, \width[#__c_frame] - i*2 + 2, Bool(\height[#__c_frame] - \__height>0)*(\height[#__c_frame] - \__height) - i*2 + 2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
              RoundBox(\x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i, \width[#__c_frame] - i*2 + 2, Bool(\height[#__c_frame] - \__height>0)*(\height[#__c_frame] - \__height) - i*2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
            Next
          EndIf
        EndIf 
        
        ; Draw back
        If \color\back[\interact * \color\state]
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          ;  RoundBox(\x[#__c_inner] - Bool(\fs),\y[#__c_inner] - Bool(\fs),\width[#__c_inner] + Bool(\fs),Bool(\height[#__c_frame] - \__height - \fs*2 + Bool(\fs)*2>0) * (\height[#__c_frame] - \__height - \fs*2 + Bool(\fs)),Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          RoundBox(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          ;  RoundBox(\x[#__c_inner] - 1,\y[#__c_inner] - 1,\width[#__c_inner] + 2,\height[#__c_inner] + 2, Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
        EndIf
        
        ; Draw background image
        If *this\img\index[2]
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(*this\img\index[2], *this\x[#__c_inner]+*this\img\x, *this\y[#__c_inner]+*this\img\y, *this\color\alpha)
        EndIf
        
        
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          If \fs = 1 
            RoundBox(\x[#__c_frame], \y[#__c_frame] + \__height, \width[#__c_frame], Bool(\height[#__c_frame] - \__height>0) * (\height[#__c_frame] - \__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
          Else
            ; draw out frame
            RoundBox(\x[#__c_frame], \y[#__c_frame] + \__height, \width[#__c_frame], Bool(\height[#__c_frame] - \__height>0) * (\height[#__c_frame] - \__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            
            ; draw inner frame 
            If \type = #__type_ScrollArea ; \scroll And \scroll\v And \scroll\h
              RoundBox(\x[#__c_inner] - 1, \y[#__c_inner] - 1, Bool(\width[#__c_frame] - \fs*2> - 2)*(\width[#__c_frame] - \fs*2 + 2), 
                       Bool(\height[#__c_frame] - \fs*2 - \__height> - 2)*(\height[#__c_frame] - \fs*2 - \__height + 2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \scroll\v\color\line)
            Else
              RoundBox(\x[#__c_inner] - 1, \y[#__c_inner] - 1, Bool(\width[#__c_frame] - \fs*2> - 2)*(\width[#__c_frame] - \fs*2 + 2), 
                       Bool(\height[#__c_frame] - \fs*2 - \__height> - 2)*(\height[#__c_frame] - \fs*2 - \__height + 2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            EndIf
          EndIf
        EndIf
        
        
        If \__height
          ; Draw caption back
          If \caption\color\back 
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_( 0, \caption\x, \caption\y, \caption\width, \caption\height - 1, \caption\color\fore[\color\state], \caption\color\back[\color\state], \round, \caption\color\alpha)
          EndIf
          
          ; Draw caption frame
          If \fs
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\caption\x, \caption\y, \caption\width, \caption\height - 1,\round,\round,\color\frame[\color\state])
            
            ; erase the bottom edge of the frame
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            BackColor(\caption\color\fore[\color\state])
            FrontColor(\caption\color\back[\color\state])
            
            ;Protected i
            For i = \round/2 + 2 To \caption\height - 2
              Line(\x[#__c_frame],\y[#__c_frame] + i,\width[#__c_frame],1, \caption\color\back[\color\state])
            Next
            
            ; two edges of the frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Line(\x[#__c_frame],\y[#__c_frame] + \round/2 + 2,1,\caption\height - \round/2,\color\frame[\color\state])
            Line(\x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \round/2 + 2,1,\caption\height - \round/2,\color\frame[\color\state])
          EndIf
          
          ;         ; Draw image
          ;         If \caption\img\index[2]
          ;           DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_AlphaBlend)
          ;           DrawAlphaImage(\caption\img\index[2], \caption\img\x, \caption\img\y, \caption\color\alpha)
          ;         EndIf
          
          If \caption\text\string
            ;ClipOutput(\caption\x[#__c_clip], \caption\y[#__c_clip], \caption\width[#__c_clip], \caption\height[#__c_clip])
            ClipOutput(\caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner])
            ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ;           RoundBox(\caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000)
            ; Draw string
            If \resize & #__resize_change
              \caption\text\x = \caption\x[#__c_inner] + \caption\text\_padding
              \caption\text\y = \caption\y[#__c_inner] + (\caption\height[#__c_inner] - TextHeight("A"))/2
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ClipOutput(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip])
          
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
              Line(\caption\button[0]\x + 1 + (\caption\button[0]\width - 6)/2, \caption\button[0]\y + (\caption\button[0]\height - 6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              Line(\caption\button[0]\x + (\caption\button[0]\width - 6)/2, \caption\button[0]\y + (\caption\button[0]\height - 6)/2, 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              
              Line(\caption\button[0]\x - 1 + 6 + (\caption\button[0]\width - 6)/2, \caption\button[0]\y + (\caption\button[0]\height - 6)/2,  - 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
              Line(\caption\button[0]\x + 6 + (\caption\button[0]\width - 6)/2, \caption\button[0]\y + (\caption\button[0]\height - 6)/2,  - 6, 6, \caption\button[0]\color\front[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
            EndIf
            
            RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, 
                     \caption\button[0]\round, \caption\button[0]\round, \caption\button[0]\color\frame[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
          EndIf
          If Not \caption\button[1]\hide
            If \caption\button[1]\color\state
              Line(\caption\button[1]\x + 2 + (\caption\button[1]\width - 4)/2, \caption\button[1]\y + (\caption\button[1]\height - 4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              Line(\caption\button[1]\x + 1 + (\caption\button[1]\width - 4)/2, \caption\button[1]\y + (\caption\button[1]\height - 4)/2, 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              
              Line(\caption\button[1]\x + 1 + (\caption\button[1]\width - 4)/2, \caption\button[1]\y + (\caption\button[1]\height - 4)/2,  - 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
              Line(\caption\button[1]\x + 2 + (\caption\button[1]\width - 4)/2, \caption\button[1]\y + (\caption\button[1]\height - 4)/2,  - 4, 4, \caption\button[1]\color\front[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
            EndIf
            
            RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height,
                     \caption\button[1]\round, \caption\button[1]\round, \caption\button[1]\color\frame[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
          EndIf
          If Not \caption\button[2]\hide
            If \caption\button[2]\color\state
              Line(\caption\button[2]\x - 2 + (\caption\button[2]\width - 4)/2, \caption\button[2]\y + (\caption\button[2]\height - 4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              Line(\caption\button[2]\x - 1 + (\caption\button[2]\width - 4)/2, \caption\button[2]\y + (\caption\button[2]\height - 4)/2, 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              
              Line(\caption\button[2]\x - 1 + 6 + (\caption\button[2]\width - 4)/2, \caption\button[2]\y + (\caption\button[2]\height - 4)/2,  - 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
              Line(\caption\button[2]\x - 2 + 6 + (\caption\button[2]\width - 4)/2, \caption\button[2]\y + (\caption\button[2]\height - 4)/2,  - 4, 4, \caption\button[2]\color\front[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
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
          *this\caption\x = *this\x[#__c_frame]
          *this\caption\y = *this\y[#__c_frame]
          *this\caption\width = *this\width[#__c_frame]
          *this\caption\height = *this\__height + *this\fs ; *this\height[#__c_frame] - *this\height[#__c_inner] - *this\fs ; 
          
          ; 
          *this\caption\x[#__c_inner] = *this\x[#__c_frame] + *this\fs
          *this\caption\y[#__c_inner] = *this\y[#__c_frame] + *this\fs
          *this\caption\height[#__c_inner] = *this\__height - *this\fs
          
          If *this\caption\height > *this\height[#__c_frame] - *this\fs ;*2
            *this\caption\height = *this\height[#__c_frame] - *this\fs  ;*2
          EndIf
          
          ; caption close button
          If Not *this\caption\button[0]\hide
            *this\caption\button[0]\x = (*this\x[#__c_inner] + *this\width[#__c_inner]) - (*this\caption\button[0]\width + *this\caption\_padding)
            *this\caption\button[0]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[0]\height)/2
          EndIf
          
          ; caption maximize button
          If Not *this\caption\button[1]\hide
            If *this\caption\button[0]\hide
              *this\caption\button[1]\x = (*this\x[#__c_inner] + *this\width[#__c_inner]) - (*this\caption\button[1]\width + *this\caption\_padding)
            Else
              *this\caption\button[1]\x = *this\caption\button[0]\x - (*this\caption\button[1]\width + *this\caption\_padding)
            EndIf
            *this\caption\button[1]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[1]\height)/2
          EndIf
          
          ; caption minimize button
          If Not *this\caption\button[2]\hide
            If *this\caption\button[1]\hide
              *this\caption\button[2]\x = *this\caption\button[0]\x - (*this\caption\button[2]\width + *this\caption\_padding)
            Else
              *this\caption\button[2]\x = *this\caption\button[1]\x - (*this\caption\button[2]\width + *this\caption\_padding)
            EndIf
            *this\caption\button[2]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[2]\height)/2
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
            *this\caption\width[#__c_inner] = *this\caption\button[3]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[2]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[2]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[1]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[1]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[0]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[0]\x - *this\x[#__c_inner] - *this\caption\_padding
          Else
            *this\caption\width[#__c_inner] = *this\width[#__c_frame] - *this\fs*2
          EndIf
          
          ; clip text coordinate
          If *this\caption\x[#__c_inner] < *this\x[#__c_clip]
            *this\caption\x[#__c_clip] = *this\x[#__c_clip]
          Else
            *this\caption\x[#__c_clip] = *this\caption\x[#__c_inner]
          EndIf
          If *this\caption\y[#__c_inner] < *this\y[#__c_clip]
            *this\caption\y[#__c_clip] = *this\y[#__c_clip]
          Else
            *this\caption\y[#__c_clip] = *this\caption\y[#__c_inner]
          EndIf
          If *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] > *this\x[#__c_clip] + *this\width[#__c_inner]
            *this\caption\width[#__c_clip] = *this\width[#__c_clip]
          Else
            *this\caption\width[#__c_clip] = *this\caption\width[#__c_inner]
          EndIf
          If *this\caption\y[#__c_inner] + *this\caption\height[#__c_inner] > *this\y[#__c_clip] + *this\height[#__c_inner]
            *this\caption\height[#__c_clip] = *this\height[#__c_clip]
          Else
            *this\caption\height[#__c_clip] = *this\caption\height[#__c_inner]
          EndIf
          
        EndIf
      EndIf
    EndProcedure
    
    Procedure   Window_SetState(*this._s_widget, state.l)
      Protected.b result
      
      ; restore state
      If state = #__Window_Normal
        If Not Post(#__Event_restoreWindow, *this)
          If *this\resize & #__resize_minimize
            *this\resize &~ #__resize_minimize
            *this\caption\button[0]\hide = 0
            *this\caption\button[2]\hide = 0
          EndIf
          *this\resize &~ #__resize_maximize
          *this\resize | #__resize_restore
          
          Resize(*this, *this\root\x[#__c_draw], *this\root\y[#__c_draw], 
                 *this\root\width[#__c_draw], *this\root\height[#__c_draw])
          
          If _is_root_(*this)
            PostEvent(#PB_Event_RestoreWindow, *this\root\canvas\window, *this)
          EndIf
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post(#__Event_MaximizeWindow, *this)
          If Not *this\resize & #__resize_minimize
            *this\root\x[#__c_draw] = *this\x[#__c_draw]
            *this\root\y[#__c_draw] = *this\y[#__c_draw]
            *this\root\width[#__c_draw] = *this\width
            *this\root\height[#__c_draw] = *this\height
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
            *this\root\x[#__c_draw] = *this\x[#__c_draw]
            *this\root\y[#__c_draw] = *this\y[#__c_draw]
            *this\root\width[#__c_draw] = *this\width
            *this\root\height[#__c_draw] = *this\height
          EndIf
          
          *this\caption\button[0]\hide = 1
          If *this\caption\button[1]\hide = 0
            *this\caption\button[2]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize(*this, *this\root\x[#__c_draw], *this\parent\height - *this\__height, *this\root\width[#__c_draw], *this\__height)
          
          If _is_root_(*this)
            PostEvent(#PB_Event_MinimizeWindow, *this\root\canvas\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_close(*this._s_widget)
      Protected.b result
      
      ; close window
      If Not Post(#__Event_closeWindow, *this)
        Free(*this)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_CloseWindow, *this\root\canvas\window, *this)
        EndIf
        
        result = #True
      EndIf
    EndProcedure
    
    Procedure   Window_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      If eventtype = #__Event_focus
        *this\color\state = #__s_2
        Post(eventtype, *this)
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        *this\color\state = #__s_3
        Post(eventtype, *this)
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseEnter
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseLeave
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseMove
        If *this = Selected()
          If *this = *this\root\canvas\container
            ResizeWindow(*this\root\canvas\window, (DesktopMouseX() - Mouse()\delta\x), (DesktopMouseY() - Mouse()\delta\y), #PB_Ignore, #PB_Ignore)
          Else
            Repaint = Resize(*this, (mouse_x - Mouse()\delta\x), (mouse_y - Mouse()\delta\y), #PB_Ignore, #PB_Ignore)
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__Event_leftButtonDown
        If *this\type = #__type_Window
          *this\caption\interact = _from_point_(mouse_x, mouse_y, *this\caption, [2])
          ;*this\color\state = 2
          
          ; close button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[0])
            ProcedureReturn Window_close(*this)
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
    ;-  DRAWINGs
    ;   Procedure Draw_text(*this._s_widget)
    ;       ; draw text
    ;       If *this\text\string
    ;         ForEach *this\row\_s()
    ;           If *this\row\_s()\text\string
    ;             If (*this\text\change Or *this\resize & #__resize_change)
    ;               *this\row\_s()\text\x = *this\x[2] + *this\row\_s()\text\x[2] + *this\x[#__c_required]
    ;               *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\y[#__c_required]
    ;             EndIf
    ;             
    ;             DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_AlphaBlend)
    ;             DrawRotatedText(*this\row\_s()\text\x, *this\row\_s()\text\y, *this\row\_s()\text\string, *this\text\rotate, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
    ;           EndIf
    ;         Next
    ;       EndIf
    ;     EndProcedure
    
    Procedure   Button_Update(*this._s_widget, List row._s_rows())
      With *this
        
        If \text\string.s
          Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
          Protected *str.Character
          Protected *End.Character
          Protected len.l, Position.l
          Protected IT,Text_X,Width,Height
          Protected TxtHeight = \text\height
          Protected ColorFont = \color\Front[Bool(*this\_state & #__s_front) * \color\state]
          
          If \vertical
            Width = \height[#__c_inner] - \text\X*2
            Height = \width[#__c_inner] - \text\y*2
          Else
            Width = \width[#__c_inner] - \text\X*2 
            Height = \height[#__c_inner] - \text\y*2
          EndIf
          
          If \text\multiLine
            ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
            Protected text$ = \text\string.s + #LF$
            Protected DelimList$ = " " + Chr(9), nl$ = #LF$
            
            Protected line$
            Protected.i i, start, found, length
            
            ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
            ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
            ;     text$ = ReplaceString(text$, #CR$, #LF$)
            ;     text$ + #LF$
            ;     
            
            *str.Character = @text$
            *end.Character = @text$
            
            While *end\c 
              If *end\c = #LF
                start = (*end - *str) >> #PB_Compiler_Unicode
                line$ = PeekS (*str, start)
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
                  
                  If Not found
                    start = length
                  EndIf
                  
                  String + Left(line$, start) + nl$
                  line$ = LTrim(Mid(line$, start + 1))
                  start = Len(line$)
                  
                  ;If length <> start
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth(RTrim(Left(line$, length)))
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  ;EndIf
                Wend
                
                String + line$ + nl$
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ; String.s = text_wrap_(\text\string.s + #LF$, Width, \text\multiLine)
            CountString = CountString(String, #LF$)
          Else
            String.s = RemoveString(*this\text\string, #LF$) + #LF$
            CountString = 1
          EndIf
          
          ; 
          If \vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #True
            EndIf
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #True
            EndIf
          EndIf
          
          ; 
          If *this\count\items <> CountString
            *this\count\items = CountString
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            If #debug_multiline
              Debug "*this\text\change - " + #PB_Compiler_Procedure
            EndIf
            
            *str.Character = @String
            *End.Character = @String
            
            ClearList(row())
            *this\width[#__c_required] = 0
            *this\height[#__c_required] = 0
            
            ;
            While *End\c 
              If *End\c = #LF 
                AddElement(row())
                row()\text\len = (*End - *str)>>#PB_Compiler_Unicode
                row()\text\string = PeekS (*str, row()\text\len)
                row()\text\width = TextWidth(row()\text\string)
                
                If \vertical
                  If *this\height[#__c_required] < row()\text\width
                    *this\height[#__c_required] = row()\text\width
                  EndIf
                  
                  If \text\rotate = 270
                    row()\x = *this\width[#__c_inner] - *this\width[#__c_required] + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  ElseIf \text\rotate = 90
                    row()\x = *this\width[#__c_required]                 - 1
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight
                Else
                  If *this\width[#__c_required] < row()\text\width
                    *this\width[#__c_required] = row()\text\width
                  EndIf
                  
                  If \text\rotate = 0
                    row()\y = *this\height[#__c_required]                 - 1 
                  ElseIf \text\rotate = 180
                    row()\y = *this\height[#__c_inner] - *this\height[#__c_required] + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight
                EndIf
                
                *str = *End + #__sOC 
              EndIf 
              
              *End + #__sOC 
            Wend
            
            ;
            ForEach row()
              If \vertical
                If \text\rotate = 270
                  row()\x - (*this\width[#__c_inner] - *this\width[#__c_required])
                EndIf
                
                row()\text\x = row()\x
                
                If \text\align\bottom
                  If \text\rotate = 270
                    row()\text\y = (*this\height[#__c_required] - row()\text\width)
                  ElseIf \text\rotate = 90
                    row()\text\y = *this\height[#__c_required]
                  EndIf
                  
                ElseIf Not \text\align\top
                  If \text\rotate = 270
                    row()\text\y = (*this\height[#__c_required] - row()\text\width) / 2
                  ElseIf \text\rotate = 90
                    row()\text\y = (*this\height[#__c_required] + row()\text\width) / 2
                  EndIf
                  
                Else
                  If \text\rotate = 270
                    row()\text\y = 0
                  ElseIf \text\rotate = 90
                    row()\text\y = row()\text\width
                  EndIf
                  
                EndIf
                
              Else
                If \text\rotate = 180
                  row()\y - (*this\height[#__c_inner] - *this\height[#__c_required])
                EndIf
                
                row()\text\y = row()\y
                
                If \text\align\right
                  If \text\rotate = 0
                    row()\text\x = (*this\width[#__c_required] - row()\text\width)
                  ElseIf \text\rotate = 180
                    row()\text\x = *this\width[#__c_required]
                  EndIf
                  
                ElseIf Not \text\align\left
                  If \text\rotate = 0
                    row()\text\x = (*this\width[#__c_required] - row()\text\width) / 2
                  ElseIf \text\rotate = 180
                    row()\text\x = (*this\width[#__c_required] + row()\text\width) / 2
                  EndIf
                  
                Else
                  If \text\rotate = 0
                    row()\text\x = 0
                  ElseIf \text\rotate = 180
                    row()\text\x = row()\text\width
                  EndIf
                  
                EndIf
              EndIf
            Next 
          EndIf
          
          
          ; make vertical scroll y
          If \text\align\bottom
            *this\y[#__c_required] = \height[#__c_inner] - *this\height[#__c_required] - \text\y 
            
            ; vertical center
          ElseIf Not \text\align\top
            *this\y[#__c_required] = (\height[#__c_inner] - *this\height[#__c_required]) / 2
          Else
            *this\y[#__c_required] = \text\y
          EndIf
          
          ; make horizontal scroll x
          If \text\align\right
            *this\x[#__c_required] = \width[#__c_inner] - *this\width[#__c_required] - \text\x
            
            ; horizontal center
          ElseIf Not \text\align\left
            *this\x[#__c_required] = (\width[#__c_inner] - *this\width[#__c_required]) / 2
          Else
            *this\x[#__c_required] = \text\x
          EndIf
          
        EndIf
        
        
      EndWith
    EndProcedure
    
    Procedure   Button_Draw(*this._s_widget)
      With *this
        If *this\color\back <> -  1
          If \color\fore <> -  1
            DrawingMode(#PB_2DDrawing_Gradient)
            ;             If \text\invert
            ;               _box_gradient_(\vertical, \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \color\Fore[\color\state],\round)
            ;             Else
            _box_gradient_(\vertical, \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\color\Fore[\color\state],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \round)
            ;             EndIf
          Else
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], \round,\round, \color\Back[Bool(*this\_state&#__s_back)*\color\state])
          EndIf
        EndIf
        
        If \text\string.s
          
          If *this\change
            If #debug_multiline
              Debug "*this\change - " + #PB_Compiler_Procedure
            EndIf
            Button_Update(*this, *this\row\_s())
            *this\change = 0
          EndIf
          
          DrawingMode(#PB_2DDrawing_Transparent)
          ForEach *this\row\_s()
            DrawRotatedText(*this\x[#__c_inner] + *this\x[#__c_required] + *this\row\_s()\text\x, *this\y[#__c_inner] + *this\y[#__c_required] + *this\row\_s()\text\y, *this\row\_s()\text\String.s, *this\text\rotate, *this\color\Front[Bool(*this\_state & #__s_front) * *this\color\state]);*this\row\_s()\color\font)
                                                                                                                                                                                                                                                                                                ;DrawRotatedText(*this\x[#__c_inner] + *this\row\_s()\text\x, *this\y[#__c_inner] + *this\row\_s()\text\y, *this\row\_s()\text\String.s, *this\text\rotate, *this\color\Front[Bool(*this\_state & #__s_front) * *this\color\state]);*this\row\_s()\color\font)
          Next 
        EndIf
        
        If #PB_GadgetType_Button = *this\type
          ; content area coordinate
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Box(*this\x[#__c_inner] + *this\x[#__c_required], *this\y[#__c_inner] + *this\y[#__c_required], *this\width[#__c_required], *this\height[#__c_required], $FFFF0000)
        EndIf
        
        If #PB_GadgetType_CheckBox = *this\type
          ; draw checkbox background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x, *this\button\y,
                   *this\button\width, *this\button\height,
                   *this\button\round, *this\button\round,
                   *this\button\color\back&$FFFFFF|*this\button\color\alpha<<24)
          
          ; draw checkbox state
          If *this\button\state & #PB_Checkbox_Inbetween = #PB_Checkbox_Inbetween
            ;         RoundBox( *this\button\x + 2, *this\button\y + 2,
            ;                   *this\button\width - 4, *this\button\height - 4, 
            ;                   *this\button\round - 2, *this\button\round - 2, 
            ;                   *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            RoundBox( *this\button\x + 4, *this\button\y + 4,
                      *this\button\width - 8, *this\button\height - 8, 
                      0, 0, 
                      *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            
          ElseIf *this\button\state & #PB_Checkbox_Checked = #PB_Checkbox_Checked
            Protected i.i
            For i = 0 To 2
              LineXY((*this\button\x + 3), (i + *this\button\y + 8),
                     (*this\button\x + 7), (i + *this\button\y + 9), 
                     *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24) 
              
              LineXY((*this\button\x + 10 + i), (*this\button\y + 3),
                     (*this\button\x + 6 + i), (*this\button\y + 10),
                     *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            Next
          EndIf 
          
          ; draw checkbox frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\round, *this\button\round, 
                   *this\button\color\frame[Bool(*this\button\state Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\button\color\alpha<<24)
        EndIf
        
        If #PB_GadgetType_Option = *this\type
          ; draw circle background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x, *this\button\y,
                   *this\button\width, *this\button\width,
                   *this\button\round, *this\button\round, 
                   *this\button\color\back&$FFFFFF|*this\button\color\alpha<<24)
          
          ; draw circle state
          If *this\button\state
            Circle(*this\button\x + *this\button\round, 
                   *this\button\y + *this\button\round, 2, 
                   *this\button\color\back[2]&$FFFFFFFF|*this\button\color\alpha<<24)
          EndIf
          
          ; draw circle frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Circle(*this\button\x + *this\button\round, *this\button\y + *this\button\round, *this\button\round, 
                 *this\button\color\frame[Bool(*this\button\state Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\button\color\alpha<<24)
        EndIf 
        
        ;;  ClipOutput(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        
        ; draw frame
        If *this\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[Bool(*this\_state & #__s_frame)**this\color\state])
        EndIf
        
        If \_flag & #__button_default
          DrawingMode(#PB_2DDrawing_Outlined)
          
          ;RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[2])
          
          RoundBox(\X[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4+2,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1])
          If \round : RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1]) : EndIf
          RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2,\Width[#__c_inner]-4,\Height[#__c_inner]-4,\round,\round,*this\color\Frame[1])
        Else
        EndIf
        
      EndWith
    EndProcedure
    
    ; old
    Procedure   _Button_Draw(*this._s_widget)
      With *this
        If *this\color\back <> -  1
          If \color\fore <> -  1
            DrawingMode(#PB_2DDrawing_Gradient)
            If \text\invert
              _box_gradient_(\vertical, \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \color\Fore[\color\state],\round)
            Else
              _box_gradient_(\vertical, \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\color\Fore[\color\state],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \round)
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], \round,\round, \color\Back[Bool(*this\_state&#__s_back)*\color\state])
          EndIf
        EndIf
        
        If \text\string.s
          DrawingMode(#PB_2DDrawing_Transparent)
          ;; ClipOutput(*this\x[#__c_inner] + *this\text\x, *this\y[#__c_inner], *this\width[#__c_inner] - *this\text\x*2, *this\height[#__c_inner])
          
          Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
          Protected *str.Character
          Protected *End.Character
          Protected len.l, Position.l
          Protected IT,Text_X,Width,Height
          Protected TxtHeight = \text\height
          Protected ColorFont = \color\Front[Bool(*this\_state & #__s_front) * \color\state]
          
          If \vertical
            Width = \height[#__c_inner] - \text\X*2
            Height = \width[#__c_inner] - \text\y*2
          Else
            Width = \width[#__c_inner] - \text\X*2 
            Height = \height[#__c_inner] - \text\y*2
          EndIf
          
          If \text\multiLine
            String.s = text_wrap_(\text\string.s + #LF$, Width, \text\multiLine)
            CountString = CountString(String, #LF$)
          Else
            ; String.s = \text\string.s + #LF$
            String.s = RemoveString(*this\text\string, #LF$) + #LF$
            CountString = 1
          EndIf
          
          If CountString
            Static ch, tw
            *str.Character = @String
            *End.Character = @String
            
            *this\y[#__c_required] = 0
            *this\x[#__c_required] = 0
            *this\width[#__c_required] = 0
            *this\height[#__c_required] = 0
            
            If ((\vertical And \text\align\right) Or
                (Not \vertical And \text\align\bottom))
              Position = Height - (\text\height*CountString) 
              
            ElseIf ((\vertical And Not \text\align\left) Or
                    (Not \vertical And Not \text\align\top))
              Position = (Height - (\text\height*CountString)) / 2
            EndIf
            
            ; ;             ; one type 
            ; ;             If \vertical
            ; ;               If \text\rotate = 270
            ; ;                 *this\x[#__c_required] = \text\x + (Height - (\text\height*CountString)) - Position
            ; ;               ElseIf \text\rotate = 90
            ; ;                 *this\x[#__c_required] = \text\x + Position
            ; ;               EndIf
            ; ;             Else
            ; ;               If \text\rotate = 0
            ; ;                 *this\y[#__c_required] = \text\y + Position
            ; ;               ElseIf \text\rotate = 180
            ; ;                 *this\y[#__c_required] = \text\y + (Height - (\text\height*CountString)) - Position
            ; ;               EndIf
            ; ;             EndIf
            
            ; For IT = 1 To CountString
            While *End\c 
              If *End\c = #LF 
                len = (*End - *str)>>#PB_Compiler_Unicode
                String4 = PeekS (*str, len)
                
                ;                 If \vertical
                ;                   If Position + \text\x < \bs : Position + TxtHeight : Continue : EndIf
                ;                 Else
                ;                   If Position + \text\y < \bs : Position + TxtHeight : Continue : EndIf
                ;                 EndIf
                ;                 
                ;               String4 = StringField(String, IT, #LF$)
                StringWidth = TextWidth(RTrim(String4))
                
                If ((\vertical And \text\align\bottom) Or (Not \vertical And \text\align\right))
                  Text_X = (Width - StringWidth)
                  
                ElseIf ((\vertical And Not \text\align\top) Or (Not \vertical And Not \text\align\left))
                  If ch <> CountString
                    ch = CountString
                    tw = Width
                  EndIf
                  Text_X = (Width - tw)/2 + (tw - StringWidth)/2
                EndIf
                
                
                If \vertical
                  *this\width[#__c_required] + TxtHeight
                  
                  If *this\height[#__c_required] < StringWidth
                    *this\height[#__c_required] = StringWidth
                    
                    If \text\rotate = 270
                      *this\y[#__c_required] = \text\y + Text_X
                    ElseIf \text\rotate = 90
                      *this\y[#__c_required] = \text\y + (width - Text_X) - *this\height[#__c_required]
                    EndIf
                  EndIf
                Else
                  *this\height[#__c_required] + TxtHeight
                  
                  If *this\width[#__c_required] < StringWidth
                    *this\width[#__c_required] = StringWidth
                    
                    If \text\rotate = 0
                      *this\x[#__c_required] = \text\X + Text_X
                    ElseIf \text\rotate = 180
                      *this\x[#__c_required] = \text\X + (width - Text_X) - *this\width[#__c_required]
                    EndIf
                  EndIf
                EndIf
                
                ; under line
                If *this\mode\lines And *this\type = #__type_hyperlink
                  Line(*this\x[#__c_inner] + Text_X,
                       *this\y[#__c_inner] + *this\y[#__c_required] + *this\height[#__c_required] - 2, 
                       StringWidth, 1, *this\color\front[*this\color\state]&$FFFFFF|*this\color\alpha<<24)
                EndIf
                
                If \vertical
                  If \text\rotate = 270
                    DrawRotatedText(\x[#__c_inner] + \text\x + (Height - Position) + 1, \y[#__c_inner] + \text\y + Text_X, String4.s, 270, ColorFont)
                  EndIf
                  If \text\rotate = 90
                    DrawRotatedText(\x[#__c_inner] + \text\y + Position - 1, \y[#__c_inner] + \text\X + (width - Text_X), String4.s, 90, ColorFont)
                  EndIf
                Else
                  If \text\rotate = 0
                    DrawRotatedText(\x[#__c_inner] + \text\X + Text_X, \y[#__c_inner] + \text\y + Position - 1, String4.s, 0, ColorFont)
                  EndIf
                  If \text\rotate = 180
                    DrawRotatedText(\x[#__c_inner] + \text\X + (Width - Text_X), \y[#__c_inner] + \text\y + (Height - Position) + Bool(#PB_Compiler_OS = #PB_OS_MacOS), String4.s, 180, ColorFont)
                  EndIf
                EndIf
                
                Position + TxtHeight 
                
                ;                 If \vertical
                ;                   If Position - \text\x > (Height - TxtHeight) : Break : EndIf
                ;                 Else
                ;                   If Position - \text\y > (Height - TxtHeight) : Break : EndIf
                ;                 EndIf
                
                *str = *End + #__sOC 
              EndIf 
              
              *End + #__sOC 
            Wend
            ; Next
            
            If \vertical
              If \text\rotate = 270
                *this\x[#__c_required] = \text\x + (Height - Position)
              ElseIf \text\rotate = 90
                *this\x[#__c_required] = \text\x + (Position - *this\width[#__c_required])
              EndIf
            Else
              If \text\rotate = 0
                *this\y[#__c_required] = \text\y + (Position - *this\height[#__c_required])
              ElseIf \text\rotate = 180
                *this\y[#__c_required] = \text\y + (Height - Position)
              EndIf
            EndIf
            
          EndIf
          
        EndIf
        
        
        If #PB_GadgetType_Button = *this\type
          ; content area coordinate
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Box(*this\x[#__c_inner] + *this\x[#__c_required], *this\y[#__c_inner] + *this\y[#__c_required], *this\width[#__c_required], *this\height[#__c_required], $FFFF0000)
        EndIf
        
        If #PB_GadgetType_CheckBox = *this\type
          ; draw checkbox background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x, *this\button\y,
                   *this\button\width, *this\button\height,
                   *this\button\round, *this\button\round,
                   *this\button\color\back&$FFFFFF|*this\button\color\alpha<<24)
          
          ; draw checkbox state
          If *this\button\state & #PB_Checkbox_Inbetween = #PB_Checkbox_Inbetween
            ;         RoundBox( *this\button\x + 2, *this\button\y + 2,
            ;                   *this\button\width - 4, *this\button\height - 4, 
            ;                   *this\button\round - 2, *this\button\round - 2, 
            ;                   *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            RoundBox( *this\button\x + 4, *this\button\y + 4,
                      *this\button\width - 8, *this\button\height - 8, 
                      0, 0, 
                      *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            
          ElseIf *this\button\state & #PB_Checkbox_Checked = #PB_Checkbox_Checked
            Protected i.i
            For i = 0 To 2
              LineXY((*this\button\x + 3), (i + *this\button\y + 8),
                     (*this\button\x + 7), (i + *this\button\y + 9), 
                     *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24) 
              
              LineXY((*this\button\x + 10 + i), (*this\button\y + 3),
                     (*this\button\x + 6 + i), (*this\button\y + 10),
                     *this\button\color\frame[2]&$FFFFFF|*this\button\color\alpha<<24)
            Next
          EndIf 
          
          ; draw checkbox frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\round, *this\button\round, 
                   *this\button\color\frame[Bool(*this\button\state Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\button\color\alpha<<24)
        EndIf
        
        If #PB_GadgetType_Option = *this\type
          ; draw circle background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(*this\button\x, *this\button\y,
                   *this\button\width, *this\button\width,
                   *this\button\round, *this\button\round, 
                   *this\button\color\back&$FFFFFF|*this\button\color\alpha<<24)
          
          ; draw circle state
          If *this\button\state
            Circle(*this\button\x + *this\button\round, 
                   *this\button\y + *this\button\round, 2, 
                   *this\button\color\back[2]&$FFFFFFFF|*this\button\color\alpha<<24)
          EndIf
          
          ; draw circle frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Circle(*this\button\x + *this\button\round, *this\button\y + *this\button\round, *this\button\round, 
                 *this\button\color\frame[Bool(*this\button\state Or *this\_state & #__s_selected)*2]&$FFFFFF|*this\button\color\alpha<<24)
        EndIf 
        
        ;;  ClipOutput(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        
        ; draw frame
        If *this\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[Bool(*this\_state & #__s_frame)**this\color\state])
        EndIf
        
        If \_flag & #__button_default
          DrawingMode(#PB_2DDrawing_Outlined)
          
          ;RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[2])
          
          RoundBox(\X[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4+2,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1])
          If \round : RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1]) : EndIf
          RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2,\Width[#__c_inner]-4,\Height[#__c_inner]-4,\round,\round,*this\color\Frame[1])
        Else
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure.i Panel_Draw(*this._s_widget)
      If *this\gadget[#__panel_1]\count\items
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\color\frame[Bool(*this\gadget[#__panel_1]\index[#__s_2] <> -1)*2 ])
        
        Tab_Draw(*this\gadget[#__panel_1]) 
      Else
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\frame[Bool(*this\index[#__panel_2]<> - 1)*2 ])
      EndIf
    EndProcedure
    
    Procedure   ScrollArea_Draw(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state])
        
        ;         DrawingMode(#PB_2DDrawing_transparent)
        ;         DrawText(*this\x[#__c_frame] + 20,*this\y[#__c_frame], Str(\index) + "_" + Str(\level), $ff000000)
        
        ; Draw background image
        If \img\index[2]
          ;ClipOutput( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner])
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\img\index[2], *this\x[#__c_required] + \img\x, *this\y[#__c_required] + \img\y, \color\alpha)
          ;ClipOutput( *this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        EndIf
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Scroll_Draw(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Scroll_Draw(\scroll\h) : EndIf
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state])
      EndWith
    EndProcedure
    
    
    ;- 
    Procedure Updates(*this._s_widget, x.l,y.l,width.l,height.l)
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
      If *this\scroll\v\bar\page\len <> height - Bool(*this\width[#__c_required] > width) * *this\scroll\h\height
        *this\scroll\v\bar\page\len = height - Bool(*this\width[#__c_required] > width) * *this\scroll\h\height
      EndIf
      
      If *this\scroll\h\bar\page\len <> width - Bool(*this\height[#__c_required] > height) * *this\scroll\v\width
        *this\scroll\h\bar\page\len = width - Bool(*this\height[#__c_required] > height) * *this\scroll\v\width
      EndIf
      
      If *this\x[#__c_required] < x
        ; left set state
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        sx = (*this\x[#__c_required] - x) 
        *this\width[#__c_required] + sx
        *this\x[#__c_required] = x
      EndIf
      
      If *this\y[#__c_required] < y
        ; top set state
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        sy = (*this\y[#__c_required] - y)
        *this\height[#__c_required] + sy
        *this\y[#__c_required] = y
      EndIf
      
      If *this\width[#__c_required] > *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
        If *this\width[#__c_required] - sx <= width And *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
          ;Debug "w - " + Str(*this\height[#__c_required] - sx)
          
          ; if on the h - scroll
          If *this\scroll\v\bar\max > height - *this\scroll\h\height
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width 
            *this\height[#__c_required] = *this\scroll\v\bar\max
            ;  Debug "w - " + *this\scroll\v\bar\max  + " " +  *this\scroll\v\height  + " " +  *this\scroll\v\bar\page\len
          Else
            *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\x[#__c_required] - x) - *this\scroll\h\height
          EndIf
        EndIf
        
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
      Else
        *this\scroll\h\bar\max = *this\width[#__c_required]
        *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
      EndIf
      
      If *this\height[#__c_required] > *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
        If *this\height[#__c_required] - sy <= Height And *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
          ;Debug " h - " + Str(*this\height[#__c_required] - sy)
          
          ; if on the v - scroll
          If *this\scroll\h\bar\max > width - *this\scroll\v\width
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
            *this\width[#__c_required] = *this\scroll\h\bar\max
            ;  Debug "h - " + *this\scroll\h\bar\max  + " " +  *this\scroll\h\width  + " " +  *this\scroll\h\bar\page\len
          Else
            *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x) - *this\scroll\v\width
          EndIf
        EndIf
        
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        *this\scroll\v\bar\max = *this\height[#__c_required]
        *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
      EndIf
      
      If *this\scroll\h\round And
         *this\scroll\v\round And
         *this\scroll\h\bar\page\len < width And 
         *this\scroll\v\bar\page\len < height
        round = (*this\scroll\h\height/4)
      EndIf
      
      If *this\width[#__c_required] >= *this\scroll\h\bar\page\len  
        If *this\scroll\h\bar\Max <> *this\width[#__c_required] 
          *this\scroll\h\bar\Max = *this\width[#__c_required]
          
          If *this\x[#__c_required] <= x 
            *this\scroll\h\bar\page\pos =- (*this\x[#__c_required] - x)
            *this\scroll\h\bar\change = 0
          EndIf
        EndIf
        
        If *this\scroll\h\width <> *this\scroll\h\bar\page\len + round
          ; Debug  "h " + *this\scroll\h\bar\page\len
          *this\scroll\h\hide = Resize(*this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len + round, #PB_Ignore)
          ;           *this\scroll\h\width = *this\scroll\h\bar\page\len + round
          ;           *this\scroll\h\hide = Bar_Update(*this\scroll\h)
          result = 1
        EndIf
      EndIf
      
      If *this\height[#__c_required] >= *this\scroll\v\bar\page\len  
        If *this\scroll\v\bar\Max <> *this\height[#__c_required]  
          *this\scroll\v\bar\Max = *this\height[#__c_required]
          
          If *this\y[#__c_required] <= y 
            ;If *this\scroll\v\bar\page\pos <> -  (*this\y[#__c_required] - y)
            *this\scroll\v\bar\page\pos =- (*this\y[#__c_required] - y)
            
            *this\scroll\v\bar\change = 0
            ; Post(#PB_EventType_change, *this\scroll\v)
            ;EndIf
          EndIf
        EndIf
        
        If *this\scroll\v\height <> *this\scroll\v\bar\page\len + round
          ; Debug  "v " + *this\scroll\v\bar\page\len
          *this\scroll\v\hide = Resize(*this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len + round)
          ;           *this\scroll\v\height = *this\scroll\v\bar\page\len + round
          ;           *this\scroll\v\hide = Bar_Update(*this\scroll\v)
          result = 1
        EndIf
      EndIf
      
      ;       If Not *this\scroll\h\hide 
      ;         If *this\scroll\h\y[#__c_draw] <> y + height - *this\scroll\h\height
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize(*this\scroll\h, #PB_Ignore, y + height - *this\scroll\h\height, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *this\scroll\h\x[#__c_draw] <> x
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize(*this\scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      ;       
      ;       If Not *this\scroll\v\hide 
      ;         If *this\scroll\v\x[#__c_draw] <> x + width - *this\scroll\v\width
      ;           ; Debug "x"
      ;           *this\scroll\v\hide = Resize(*this\scroll\v, x + width - *this\scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *this\scroll\v\y[#__c_draw] <> y
      ;           ; Debug "y"
      ;           *this\scroll\v\hide = Resize(*this\scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      
      If v_max <> *this\scroll\v\bar\Max
        v_max = *this\scroll\v\bar\Max
        *this\scroll\v\resize | #__resize_change
        *this\scroll\v\hide = Bar_Update(*this\scroll\v) 
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        *this\scroll\h\hide = Bar_Update(*this\scroll\h) 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure Resizes(*this._s_widget, x.l,y.l,width.l,height.l)
      ;       *this\width[#__c_required] = *this\scroll\h\bar\max
      ;       *this\height[#__c_required] = *this\scroll\v\bar\max
      ;       
      ;       ProcedureReturn Updates(*this, x.l,y.l,width.l,height.l)
      
      
      ;       y = #PB_Ignore 
      ;         x = #PB_Ignore 
      ;           Width = #PB_Ignore 
      ;           Height = #PB_Ignore 
      ;           
      With *this\scroll
        Protected iHeight, iWidth, v_x = #PB_Ignore, h_y = #PB_Ignore
        
        If Not *this\scroll\v Or Not *this\scroll\h
          ProcedureReturn
        EndIf
        
        If y = #PB_Ignore : y = \v\y - \v\parent\y[#__c_inner] : EndIf
        If x = #PB_Ignore : x = \h\x - \v\parent\x[#__c_inner] : EndIf
        If Width = #PB_Ignore : Width = \v\x - \h\x + \v\width : EndIf
        If Height = #PB_Ignore : Height = \h\y - \v\y + \h\height : EndIf
        
        If Width + x - *this\scroll\v\width <> *this\scroll\v\x[#__c_draw]
          v_x = Width + x - *this\scroll\v\width
        EndIf
        
        If Height + y - *this\scroll\h\height <> *this\scroll\h\y[#__c_draw]
          h_y = Height + y - *this\scroll\h\height
        EndIf
        ;Debug _make_area_height_(*this,*this\scroll, Width, Height)
        ;If
        Bar_SetAttribute(*this\scroll\v, #__bar_pagelength, _make_area_height_(*this,*this\scroll, Width, Height))
        *this\scroll\v\hide = widget::Resize(*this\scroll\v, v_x, y, #PB_Ignore, _get_page_height_(*this,*this\scroll, 1))
        ;EndIf
        
        ;If 
        Bar_SetAttribute(*this\scroll\h, #__bar_pagelength, _make_area_width_(*this,*this\scroll, Width, Height))
        *this\scroll\h\hide = widget::Resize(*this\scroll\h, x, h_y, _get_page_width_(*this,*this\scroll, 1), #PB_Ignore)
        ;EndIf
        
        If Bar_SetAttribute(*this\scroll\v, #__bar_pagelength, _make_area_height_(*this,*this\scroll, Width, Height))
          *this\scroll\v\hide = widget::Resize(*this\scroll\v, v_x, #PB_Ignore, #PB_Ignore, _get_page_height_(*this,*this\scroll, 1))
        EndIf
        
        If Bar_SetAttribute(*this\scroll\h, #__bar_pagelength, _make_area_width_(*this,*this\scroll, Width, Height))
          *this\scroll\h\hide = widget::Resize(*this\scroll\h, #PB_Ignore, h_y, _get_page_width_(*this,*this\scroll, 1), #PB_Ignore)
        EndIf
        
        *this\scroll\v\hide = Bar_Update(*this\scroll\v)
        *this\scroll\h\hide = Bar_Update(*this\scroll\h)
        ;         
        ;         *this\scroll\v\hide = *this\scroll\v\bar\hide ; Bool(*this\scroll\v\bar\min = *this\scroll\v\bar\page\end)
        ;         *this\scroll\h\hide = *this\scroll\h\bar\hide ; Bool(*this\scroll\h\bar\min = *this\scroll\h\bar\page\end)
        ;         
        ProcedureReturn Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      EndWith
    EndProcedure
    
    
    ;- 
    Procedure.i GetItem(*this, parent_sublevel.l =- 1)
      Protected result
      Protected *row._s_rows
      Protected *widget._s_widget
      
      If *this 
        If parent_sublevel =- 1
          *widget = *this
          result = *widget\_item
          
        Else
          *row = *this
          
          While *row And *row <> *row\parent
            
            If parent_sublevel = *row\parent\sublevel
              result = *row
              Break
            EndIf
            
            *row = *row\parent
          Wend
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Flag(*this._s_widget, flag.i=#Null, state.b =- 1)
      Protected result
      
      If Not flag
        result = *this\_flag
        ;       If *this\type = #PB_GadgetType_Button
        ;         ;         If *this\text\align\left
        ;         ;           result | #__button_left
        ;         ;         EndIf
        ;         ;         If *this\text\align\right
        ;         ;           result | #__button_right
        ;         ;         EndIf
        ;         ;         If *this\text\multiline
        ;         ;           result | #__button_multiline
        ;         ;         EndIf
        ;         ;         If *this\_flag & #__button_toggle
        ;         ;           result | #__button_toggle
        ;         ;         EndIf
        ;       EndIf
      Else
        If state =- 1
          result = Bool(*this\_flag & flag)
        Else
          If state 
            *this\_flag | flag
          Else
            *this\_flag &~ flag
          EndIf
          
          ; commons
          If Flag & #__flag_vertical
            *this\vertical = state
            *this\text\change = #True
          EndIf
          
          If flag & #__text_invert
            *this\text\invert = state 
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            If *this\text\invert 
              If *this\vertical
                *this\text\rotate = 270 
              Else
                *this\text\rotate = 180
              EndIf
            Else
              *this\text\rotate = Bool(*this\vertical) * 90
            EndIf
          EndIf
          
          If flag & #__text_top
            *this\text\align\top = state
          EndIf
          If flag & #__text_bottom
            *this\text\align\bottom = state
          EndIf
          
          If *this\type = #PB_GadgetType_Button
            If flag & #__button_default
              ; *this\text\align\left = state
            EndIf
            If flag & #__button_left
              *this\text\align\right = 0
              *this\text\align\left = state
            EndIf
            If flag & #__button_right
              *this\text\align\left = 0
              *this\text\align\right = state
            EndIf
            If flag & #__button_multiline
              *this\text\change = #True
              *this\text\multiline = state
            EndIf
            If flag & #__button_toggle
              If state 
                *this\_state | #__s_toggled
                *this\color\state = #__s_2
              Else
                *this\_state &~ #__s_toggled
                *this\color\state = #__s_0
              EndIf
            EndIf
            
            *this\change = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Tree Or
             *this\type = #PB_GadgetType_ListView Or
             *this\type = #__type_property
            
            If flag & #__tree_nolines
              *this\mode\lines = Bool(state) * #__tree_linesize
            EndIf
            If flag & #__tree_nobuttons
              *this\mode\buttons = state
              
              If *this\count\items
                If *this\_flag & #__tree_optionboxes
                  PushListPosition(*this\row\_s())
                  ForEach *this\row\_s()
                    If *this\row\_s()\parent And 
                       *this\row\_s()\parent\childrens
                      *this\row\_s()\sublevel = state
                    EndIf
                  Next
                  PopListPosition(*this\row\_s())
                EndIf
              EndIf
            EndIf
            If flag & #__tree_checkboxes
              If *this\_flag & #__tree_optionboxes
                *this\mode\check = Bool(state) * 4
              Else
                *this\mode\check = Bool(state)
              EndIf
            EndIf
            If flag & #__tree_threestate
              If *this\_flag & #__tree_checkboxes
                *this\mode\threestate = state
              Else
                *this\mode\threestate = 0
              EndIf
            EndIf
            If flag & #__tree_clickselect
              *this\mode\check = Bool(state) * 2
            EndIf
            If flag & #__tree_multiselect
              *this\mode\check = Bool(state) * 3
            EndIf
            If flag & #__tree_optionboxes
              If state 
                *this\mode\check = 4
              Else
                *this\mode\check = Bool(*this\_flag & #__tree_checkboxes)
              EndIf
              
              ; set option group
              If *this\count\items
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  If *this\row\_s()\parent
                    *this\row\_s()\box[1]\state = 0
                    *this\row\_s()\option_group = Bool(state) * GetItem(*this\row\_s(), 0) 
                  EndIf
                Next
                PopListPosition(*this\row\_s())
              EndIf
            EndIf
            If flag & #__tree_gridlines
              *this\mode\gridlines = state
            EndIf
            If flag & #__tree_collapse ; d
              *this\mode\collapse = state
              
              If *this\count\items
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  If *this\row\_s()\parent 
                    *this\row\_s()\parent\box[0]\state = state
                    *this\row\_s()\hide = state
                  EndIf
                Next
                PopListPosition(*this\row\_s())
              EndIf
              
              If *this\root
                ReDraw(*this)
              EndIf
            EndIf
            
            
            If (*this\mode\lines Or *this\mode\buttons Or *this\mode\check) And
               Not (*this\_flag & #__tree_property Or *this\_flag & #__tree_optionboxes)
              *this\row\sublevellen = 18 
            Else
              *this\row\sublevellen = 0
            EndIf
            
            If *this\count\items
              *this\change = 1
            EndIf
          EndIf
          
          If flag & #__text_center
            *this\text\align\left = 0
            *this\text\align\top = 0
            *this\text\align\right = 0
            *this\text\align\bottom = 0
            
            ;           Else
            ;             If Not *this\text\align\bottom
            ;               *this\text\align\top = #True
            ;             EndIf
            ;             
            ;             If Not *this\text\align\right
            ;               *this\text\align\left = #True 
            ;             EndIf
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Disable(*this._s_widget, State.b =- 1)
      If State =- 1
        ProcedureReturn Bool(*this\color\state = #__s_3)
      Else
        *this\color\state = #__s_3
        ; *this\_state = #__s_disabled
      EndIf
    EndProcedure
    
    Procedure.b Hide(*this._s_widget, State.b =- 1)
      With *this
        If State =- 1
          ProcedureReturn *this\hide 
        Else
          *this\hide = State
          *this\hide[1] = *this\hide
          
          If *this\count\childrens
            ForEach Widget()
              If Child( Widget(), *this)
                Widget()\hide = Bool(Widget()\hide[1] Or
                                     Widget()\parent\hide Or 
                                     (Widget()\parent\type = #PB_GadgetType_Panel And
                                      Widget()\parent\index[#__panel_2] <> Widget()\_item))
                
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
          While *this\adress
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
      Protected _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner]
      Protected _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner]
      Protected _p_x4_ = *this\parent\x[#__c_clip] + *this\parent\width[#__c_clip]
      Protected _p_y4_ = *this\parent\y[#__c_clip] + *this\parent\height[#__c_clip]
      Protected _t_x2_ = *this\x + *this\width
      Protected _t_y2_ = *this\y + *this\height
      
      If *this\type = #__type_tabbar And 
         *this\parent\gadget[#__panel_1] And *this\parent\gadget[#__panel_1] = *this
        _p_x2_ = *this\parent\x[#__c_frame] + *this\parent\width[#__c_frame]
        _p_y2_ = *this\parent\y[#__c_frame] + *this\parent\height[#__c_frame]
      EndIf
      
      If *this\type = #__type_scrollbar And 
         *this\parent\scroll And (*this\parent\scroll\v = *this Or *this = *this\parent\scroll\h)
        _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_draw]
        _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_draw]
      EndIf
      
      If *this\parent And _p_x4_ > 0 And _p_x4_ < _t_x2_ And _p_x2_ > _p_x4_ 
        *this\width[#__c_clip] = _p_x4_ - *this\x[#__c_clip]
      ElseIf *this\parent And _p_x2_ > 0 And _p_x2_ < _t_x2_
        *this\width[#__c_clip] = _p_x2_ - *this\x[#__c_clip]
      Else
        *this\width[#__c_clip] = _t_x2_ - *this\x[#__c_clip]
      EndIf
      
      If *this\parent And _p_y4_ > 0 And _p_y4_ < _t_y2_ And _p_y2_ > _p_y4_ 
        *this\height[#__c_clip] = _p_y4_ - *this\y[#__c_clip]
      ElseIf *this\parent And _p_y2_ > 0 And _p_y2_ < _t_y2_
        *this\height[#__c_clip] = _p_y2_ - *this\y[#__c_clip]
      Else
        *this\height[#__c_clip] = _t_y2_ - *this\y[#__c_clip]
      EndIf
      
      If *this\width[#__c_clip] < 0
        *this\width[#__c_clip] = 0
      EndIf
      
      If *this\height[#__c_clip] < 0
        *this\height[#__c_clip] = 0
      EndIf
      
      If (*this\width[#__c_clip] Or 
          *this\height[#__c_clip])
        *this\draw = #True
      Else
        *this\draw = #False
      EndIf
      
      ; clip child tab bar
      If *this\type = #__type_panel And *this\gadget[#__panel_1]
        Clip(*this\gadget[#__panel_1], 0)
      EndIf
      
      ; clip child scroll bars 
      If *this\scroll And 
         *this\scroll\v And
         *this\scroll\h
        Clip(*this\scroll\v, 0)
        Clip(*this\scroll\h, 0)
      EndIf
      
      If childrens And *this\container And *this\count\childrens
        PushListPosition(Widget())
        ForEach Widget()
          If Widget()\parent = *this
            Clip(Widget(), childrens)
          EndIf
        Next
        PopListPosition(Widget())
      EndIf
    EndProcedure
    
    Procedure.b Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Option
        *this\button\x = *this\x[#__c_inner] + 3
        *this\button\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\button\height)/2
      EndIf
      
      If *this\type = #__type_checkBox
        *this\button\x = *this\x[#__c_inner] + 3
        *this\button\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\button\height)/2
      EndIf
      
      If *this\type = #__type_Panel
        result = Bar_Update(*this\gadget[#__panel_1])
      EndIf  
      
      If *this\type = #__type_Window
        result = Window_Update(*this)
      EndIf
      
      ; ;       If *this\type = #__type_tree
      ; ;         If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
      ; ;           Tree_Update(*this, *this\row\_s())
      ; ;           StopDrawing()
      ; ;         EndIf
      ; ;         
      ; ;         result = 1
      ; ;       EndIf
      
      If *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_tabBar Or
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
        Case #__type_tabBar,
             #PB_GadgetType_Spin,
             #PB_GadgetType_Splitter,
             #PB_GadgetType_TrackBar,
             #PB_GadgetType_ScrollBar,
             #PB_GadgetType_ProgressBar
          
          ProcedureReturn Bar_Change(*this, ScrollPos)
      EndSelect
    EndProcedure
    
    Procedure.b Resize(*this._s_widget, x.l,y.l,width.l,height.l)
      Protected.b result
      Protected.l Change_x, Change_y, Change_width, Change_height
      
      With *this
        ; #__flag_autoSize
        If *this\parent And 
           *this\align And *this\align\autosize And
           *this\parent\type <> #__type_Splitter And
           *this\align\left And *this\align\top And 
           *this\align\right And *this\align\bottom
          X = 0; \align\delta\x
          Y = 0; \align\delta\y
          Width = *this\parent\width[#__c_inner] ; - \align\delta\x
          Height = *this\parent\height[#__c_inner] ; - \align\delta\y
        EndIf
        
        ; 
        ; If \bs < \fs : \bs = \fs : EndIf
        
        If X<>#PB_Ignore 
          If *this\parent 
            If *this\x[#__c_draw] <> x 
              *this\x[#__c_draw] = x 
              *this\x[#__c_container] = *this\x[#__c_draw]
              
              ; for the scroll area childrens
              If *this\parent\scroll And *this\parent\scroll\h
                *this\x[#__c_container] + *this\parent\scroll\h\bar\page\pos
              EndIf
            EndIf
            X + *this\parent\x[#__c_inner] 
          EndIf 
          
          If *this\x[#__c_frame] <> X; + *this\bs - *this\fs  
            Change_x = x - *this\x[#__c_frame] 
            *this\x[#__c_frame] = X 
            *this\x = *this\x[#__c_frame] - (*this\bs - *this\fs) 
            *this\x[#__c_inner] = *this\x + *this\bs + *this\__width 
            *this\x[#__c_window] = *this\x[#__c_frame] - *this\window\x[#__c_inner]
            
            If *this\parent And 
               *this\parent\x[#__c_inner] > *this\x And 
               *this\parent\x[#__c_inner] > *this\parent\x[#__c_clip]
              *this\x[#__c_clip] = *this\parent\x[#__c_inner]
            ElseIf *this\parent And *this\parent\x[#__c_clip] > *this\x 
              *this\x[#__c_clip] = *this\parent\x[#__c_clip]
            Else
              *this\x[#__c_clip] = *this\x
            EndIf
            
            *this\resize | #__resize_x | #__resize_change
          EndIf 
        EndIf  
        
        If Y<>#PB_Ignore 
          If *this\parent 
            If *this\y[#__c_draw] <> y 
              *this\y[#__c_draw] = y 
              *this\y[#__c_container] = *this\y[#__c_draw]
              
              ; for the scroll area childrens
              If *this\parent\scroll And *this\parent\scroll\v 
                *this\y[#__c_container] + *this\parent\scroll\v\bar\page\pos
              EndIf
            EndIf
            y + *this\parent\y[#__c_inner] 
          EndIf 
          
          If *this\y[#__c_frame] <> y 
            Change_y = y - *this\y[#__c_frame] 
            *this\y[#__c_frame] = y 
            *this\y = *this\y[#__c_frame] - (*this\bs - *this\fs)
            *this\y[#__c_inner] = *this\y + *this\bs + *this\__height
            *this\y[#__c_window] = *this\y[#__c_frame] - *this\window\y[#__c_inner]
            
            If *this\parent And *this\parent\y[#__c_inner] > *this\y And 
               *this\parent\y[#__c_inner] > *this\parent\y[#__c_clip]
              *this\y[#__c_clip] = *this\parent\y[#__c_inner]
            ElseIf \parent And *this\parent\y[#__c_clip] > *this\y 
              *this\y[#__c_clip] = *this\parent\y[#__c_clip]
            Else
              *this\y[#__c_clip] = *this\y
            EndIf
            
            *this\resize | #__resize_y | #__resize_change
          EndIf 
        EndIf  
        
        If width <> #PB_Ignore 
          If width < 0 : width = 0 : EndIf
          
          If \width[#__c_frame] <> width 
            Change_width = width - \width[#__c_frame] 
            \width[#__c_frame] = width 
            \width = \width[#__c_frame] + (\bs*2 - \fs*2)
            \width[#__c_draw] = \width - \bs*2 - \__width 
            ;If \width[#__c_frame] < 0 : \width[#__c_frame] = 0 : EndIf
            If \width[#__c_draw] < 0 : \width[#__c_draw] = 0 : EndIf
            \resize | #__resize_width | #__resize_change
            
            If *this\bar\vertical
              If *this\type = #__type_tabbar
                ; to fix the width of the 
                ; vertical tabbar items
                *this\bar\change = #True
              EndIf
            EndIf
            
            If *this\count\items
              *this\change | #__change_width
            EndIf
          EndIf 
        EndIf  
        
        If Height <> #PB_Ignore 
          If Height < 0 : Height = 0 : EndIf
          
          If \height[#__c_frame] <> Height 
            Change_height = height - \height[#__c_frame] 
            \height[#__c_frame] = Height 
            \height = \height[#__c_frame] + (\bs*2 - \fs*2)
            \height[#__c_draw] = \height - \bs*2 - \__height
            If \height[#__c_frame] < 0 : \height[#__c_frame] = 0 : EndIf
            If \height[#__c_draw] < 0 : \height[#__c_draw] = 0 : EndIf
            \resize | #__resize_height | #__resize_change
            
            If Not *this\bar\vertical
              If *this\type = #__type_tabbar
                ; to fix the height of the
                ; horizontal tabbar items
                *this\bar\change = #True
              EndIf
            EndIf
            
            If *this\count\items ;And \height[#__c_required] > \height[#__c_draw]
              *this\change | #__change_height
            EndIf
          EndIf 
        EndIf 
        
        
        If *this\resize & #__resize_change
          ; then move and size parent set clip (width&height)
          If *this\parent And *this\parent <> *this
            Clip(*this, #False)
          Else
            *this\x[#__c_clip] = *this\x
            *this\y[#__c_clip] = *this\y
            *this\width[#__c_clip] = *this\width
            *this\height[#__c_clip] = *this\height
          EndIf
          
          ; 
          *this\width[#__c_inner] = *this\width[#__c_draw]
          *this\height[#__c_inner] = *this\height[#__c_draw]
          
          ; resize vertical&horizontal scrollbars
          If (*this\scroll And *this\scroll\v And *this\scroll\h)
            If (Change_x Or Change_y)
              Resize(*this\scroll\v, *this\scroll\v\x[#__c_draw], *this\scroll\v\y[#__c_draw], #__scroll_buttonsize, #PB_Ignore)
              Resize(*this\scroll\h, *this\scroll\h\x[#__c_draw], *this\scroll\h\y[#__c_draw], #PB_Ignore, #__scroll_buttonsize)
            EndIf
            
            If (Change_width Or Change_height)
              Resizes(*this, 0, 0, *this\width[#__c_draw], *this\height[#__c_draw])
            EndIf
            
            *this\width[#__c_inner] = *this\scroll\h\bar\page\len ; *this\width[#__c_draw] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
            *this\height[#__c_inner] = *this\scroll\v\bar\page\len; *this\height[#__c_draw] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
          EndIf
          
          If *this\type = #__type_panel And *this\gadget[#__panel_1]
            If *this\gadget[#__panel_1]\bar\vertical
              *this\x[#__c_inner] = *this\x + *this\bs
              
              Resize(*this\gadget[#__panel_1], 0, 0, *this\__width, *this\height[#__c_draw])
              
              *this\x[#__c_inner] = *this\x + *this\bs + *this\__width
            Else
              *this\y[#__c_inner] = *this\y + *this\bs
              
              Resize(*this\gadget[#__panel_1], 0, 0, *this\width[#__c_draw], *this\__height)
              
              *this\y[#__c_inner] = *this\y + *this\bs + *this\__height
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_Spin
            *this\width[#__c_inner] = *this\width[#__c_draw] - *this\bs*2 - *this\bar\button[#__b_3]\len
          EndIf
          
          ; then move and size parent
          If *this\container And *this\count\childrens
            Macro ResizeD(_type_, v1, ov1, v2, ov2, adv, ndv)
              Select _type_
                Case 0  : v1 = ov1                               : v2 = ov2
                Case 1  : v1 = ov1 + (ndv - adv)/2               : v2 = ov2 + (ndv - adv)/2   ; center (right & bottom)
                Case 2  : v1 = ov1 + (ndv - adv)                 : v2 = ov2 + (ndv - adv)     ; right & bottom
                Case 3  : v1 = ov1                               : v2 = ov2 + (ndv - adv)     ; full (right & bottom)
                Case 4  : v1 = ov1 * ndv / adv                   : v2 = ov2 * ndv / adv
                Case 5  : v1 = ov1                               : v2 = ov2 + (ndv - adv)/2
                Case 6  : v1 = ov1 + (ndv - adv)/2               : v2 = ov2 + (ndv - adv) 
              EndSelect
            EndMacro
            
            PushListPosition(Widget())
            ForEach Widget()
              If Widget()\parent = *this ; And Widget()\draw 
                If Widget()\align
                  ResizeD( Widget()\align\h, x, Widget()\align\delta\x, 
                           Width, (Widget()\align\delta\x + Widget()\align\delta\width), *this\align\delta\width, *this\width)
                  
                  ResizeD( Widget()\align\v, y, Widget()\align\delta\y,
                           Height, (Widget()\align\delta\y + Widget()\align\delta\height), *this\align\delta\height, *this\height)
                  
                  ;Resize( Widget(), x, y, Width - x + Widget()\bs*2, Height - y + Widget()\bs*2)
                  Resize( Widget(), x, y, Width - x, Height - y)
                  
                Else
                  If (Change_x Or Change_y)
                    
                    Resize(Widget(), 
                           Widget()\x[#__c_draw],
                           Widget()\y[#__c_draw], 
                           #PB_Ignore, #PB_Ignore)
                    
                  ElseIf (Change_width Or Change_height)
                    ;                     If  Widget()\type = #PB_GadgetType_Panel ;(*this\gadget[#__panel_1])
                    ;                       Resize(Widget(), #PB_Ignore, #PB_Ignore, Widget()\width[#__c_draw], #PB_Ignore)
                    ;                     EndIf
                    
                    Clip(Widget(), #True)
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition(Widget())
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
        If *this And (*this\root And Transform() And Transform()\widget = *this)
          a_move(*this)
        EndIf
        
        ProcedureReturn result
      EndWith
    EndProcedure
    
    Procedure.l X(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\x[mode])
    EndProcedure
    
    Procedure.l Y(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\y[mode])
    EndProcedure
    
    Procedure.l Width(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\width[mode])
    EndProcedure
    
    Procedure.l Height(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\height[mode])
    EndProcedure
    
    ;- 
    Procedure.i AddColumn(*this._s_widget, Position.l, Text.s, Width.l, Image.i=-1)
      
      With *This
        ;         LastElement(\Columns())
        ;         AddElement(\Columns()) 
        ;         ;       Position = ListIndex(\Columns())
        ;         
        ;         \Columns()\text\string.s = Text.s
        ;         \Columns()\text\change = 1
        ;         \Columns()\x = \width[#__c_required]
        ;         \Columns()\width = Width
        ;         \Columns()\height = 24
        ;         \width[#__c_required] + Width
        ;         \height[#__c_required] = \bs*2+\Columns()\height
        ;         ;      ; ReDraw(*This)
        ;         ;       If Position = 0
        ;         ;      ;   PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         ;       EndIf
      EndWith
    EndProcedure
    
    Procedure   AddItem(*this._s_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0)
      Protected result
      
      If *this\type = #PB_GadgetType_MDI
        *this\count\items + 1
        Static pos_x, pos_y
        Protected x = 10, y = 10, width.l = 280, height.l = 180
        flag | #__window_systemmenu|#__window_sizegadget|#__window_maximizegadget|#__window_minimizegadget
        result = Window(pos_x + x, pos_y + y, Width, Height, Text, flag, *this)
        pos_y + 20 + 25
        pos_x + 20
        ProcedureReturn result
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn Editor_AddItem(*this, Item,Text, Image, flag)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree Or 
         *this\type = #__type_property
        ProcedureReturn Tree_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        ProcedureReturn Tree_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_tabBar
        ProcedureReturn Tab_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn Tab_AddItem(*this\gadget[#__panel_1], Item,Text,Image,flag)
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure   RemoveItem(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__type_Editor
        *this\text\change = 1
        *this\count\items - 1
        
        If *this\count\items =- 1 
          *this\count\items = 0 
          *this\text\string = #LF$
          
          _repaint_(*this)
          
        Else
          *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item + 1, #LF$) + #LF$)
        EndIf
        
        result = #True
      ElseIf *this\type = #__type_tree
        Protected sublevel.l
        
        If _no_select_(*this\row\_s(), Item)
          ProcedureReturn #False
        EndIf
        
        If *this\row\_s()\childrens
          sublevel = *this\row\_s()\sublevel
          *this\change = 1
          
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
        EndIf
        
        DeleteElement(*this\row\_s())
        
        If *this\row\selected And
           *this\row\selected\index >= Item 
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
        
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = Tab_removeItem(*this\gadget[#__panel_1], Item)
        
      ElseIf *this\type = #__type_tabBar
        result = Tab_removeItem(*this, Item)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l CountItems(*this._s_widget)
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure.l ClearItems(*this._s_widget)
      Protected result
      
      If *this\type = #__type_Editor
        *this\text\change = 1 
        *this\count\items = 0
        
        If *this\text\editable
          *this\text\string = #LF$
        EndIf
        
        _repaint_(*this)
        ProcedureReturn #True
      EndIf
      
      If *this\type = #__type_tree
        If *this\count\items <> 0
          *this\change =- 1
          *this\row\count = 0
          *this\count\items = 0
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = 0
          EndIf
          
          ClearList(*this\row\_s())
          ReDraw(*this)
          
          Post(#__Event_change, *this, #PB_All)
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_clearItems(*this\gadget[#__panel_1])
        
      ElseIf *this\type = #__type_tabBar
        result = Tab_clearItems(*this)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CloseList()
      If Opened() And 
         Opened()\parent And
         Opened()\root\canvas\gadget = Root()\canvas\gadget 
        
        ; Debug "" + Opened() + " - " + Opened()\class + " " + Opened()\parent + " - " + Opened()\parent\class
        If Opened()\parent\type = #__type_mdi
          Opened() = Opened()\parent\parent
        Else
          Opened() = Opened()\parent
        EndIf
      Else
        Opened() = Root()
      EndIf
    EndProcedure
    
    Procedure.i OpenList(*this._s_widget, item.l = 0)
      Protected result.i = Opened()
      
      If *this
        If (_is_root_(*this) Or 
            *this\type = #__type_Window)
          *this\window = *this
        EndIf
        
        Opened() = *this
        If *this\type = #PB_GadgetType_Panel
          Opened()\index[#__panel_1] = item
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure   SetFocus(*this._s_widget)
      Focused() = *this
    EndProcedure
    
    Procedure   GetWidget(index)
      Protected result
      
      If index =- 1
        ProcedureReturn Widget()
      Else
        ForEach Widget()
          If Widget()\index = index ; +  1
            result = Widget()
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
    
    Procedure.l GetMouseX(*this._s_widget, mode.l = #__c_screen)
      ProcedureReturn Mouse()\x - *this\x[mode]
    EndProcedure
    
    Procedure.l GetMouseY(*this._s_widget, mode.l = #__c_screen)
      ProcedureReturn Mouse()\y - *this\y[mode]
    EndProcedure
    
    Procedure.l GetDeltaX(*this._s_widget)
      ProcedureReturn (Mouse()\delta\x + Selected()\x[#__c_draw])
    EndProcedure
    
    Procedure.l GetDeltaY(*this._s_widget)
      ProcedureReturn (Mouse()\delta\y + Selected()\y[#__c_draw])
    EndProcedure
    
    Procedure.l GetButtons(*this._s_widget)
      ProcedureReturn Mouse()\buttons
    EndProcedure
    
    Procedure.i GetFont(*this._s_widget)
      ProcedureReturn *this\text\fontID
    EndProcedure
    
    Procedure.l GetCount(*this._s_widget, mode.b = #False)
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
    
    Procedure.i GetParent(*this._s_widget)
      ProcedureReturn *this\parent
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
        If Attribute = #__tree_collapsed  
          Result = *this\mode\collapse
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
        
        If *this\row\selected And 
           *this\row\selected\color\state
          ProcedureReturn *this\row\selected\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Button
        ProcedureReturn Bool(*this\_state & #__s_toggled)
      EndIf
      
      If *this\type = #PB_GadgetType_Option
        ProcedureReturn *this\button\state
      EndIf
      
      If *this\type = #PB_GadgetType_CheckBox
        ProcedureReturn *this\button\state
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn *this\index[#__s_2] ; *this\text\caret\pos
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn *this\index[#__s_2] 
      EndIf
      
      If *this\type = #PB_GadgetType_tabBar
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
          Case #__color_line  : Color = \color\Line
          Case #__color_back  : Color = \color\Back
          Case #__color_front : Color = \color\Front
          Case #__color_frame : Color = \color\Frame
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
      
      ;- Button_SetState()
      If *this\type = #__type_button
        If *this\_flag & #__button_toggle
          If *this\_state & #__s_toggled
            *this\_state &~ #__s_toggled
            
            If *this\_state & #__s_entered
              *this\color\state = #__s_1 
            Else
              *this\color\state = #__s_0 
            EndIf
            
          ElseIf state
            *this\_state | #__s_toggled
            *this\color\state = #__s_2 
          EndIf
          
          Post(#PB_EventType_Change, *this)
          result = 1
        Else
          If *this\color\state <> #__s_1
            *this\color\state = #__s_1
            result = 1
          EndIf
        EndIf
      EndIf
      
      If *this\type = #__type_IPAddress
        If *this\index[#__s_2] <> State : *this\index[#__s_2] = State
          SetText(*this, Str(IPAddressField(State,0)) + "." + 
                         Str(IPAddressField(State,1)) + "." + 
                         Str(IPAddressField(State,2)) + "." + 
                         Str(IPAddressField(State,3)))
        EndIf
      EndIf
      
      ;
      If *this\type = #__type_checkBox
        If *this\button\state <> State
          Select State
            Case #PB_Checkbox_Unchecked,
                 #PB_Checkbox_Checked
              
              *this\button\state = State
              Post(#PB_EventType_Change, *this)
              ReDraw(*this\root)
              ProcedureReturn 1
              
            Case #PB_Checkbox_Inbetween
              If *this\mode\threestate 
                *this\button\state = State
                Post(#PB_EventType_Change, *this)
                ReDraw(*this\root)
                ProcedureReturn 1
              EndIf
          EndSelect
        EndIf
      EndIf
      
      ;
      If *this\type = #__type_Option
        If *this\_group And *this\button\state <> State
          If *this\_group\_group <> *this
            If *this\_group\_group
              *this\_group\_group\button\state = 0
            EndIf
            *this\_group\_group = *this
          EndIf
          *this\button\state = State
          
          Post(#PB_EventType_Change, *this)
          ReDraw(*this\root)
          ProcedureReturn 1
        EndIf
      EndIf
      
      If *this\type = #__type_Window
        result = Window_SetState(*this, state)
      EndIf
      
      If *this\type = #__type_Editor
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
              len + (*end - *str)/#__sOC
              ; Debug "" + i + " " + Str(len + i)  + " " +  state
              
              If len + i >= state
                *this\index[#__s_1] = i
                *this\index[#__s_2] = i
                
                *this\text\caret\pos[1] = state - (len - (*end - *str)/#__sOC) - i
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              i + 1
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__s_1] <> i 
            *this\index[#__s_1] = i
            *this\index[#__s_2] = i
            
            *this\text\caret\pos[1] = (state - len - i) 
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          result = #True 
        EndIf
      EndIf
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_listView
        
        If State >= 0 And 
           State < *this\count\items And 
           *this\row\selected <> SelectElement(*this\row\_s(), State)
          
          ; mode click select
          If *this\mode\check = 2
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
                ; mode multi select
                If *this\mode\check = 3
                  If *this\row\selected\_state & #__s_selected
                    *this\row\selected\_state &~ #__s_selected
                    Post(#PB_EventType_Change, *this, *this\row\selected\index)
                  EndIf
                EndIf
                
                *this\row\selected\_state &~ #__s_selected
              EndIf
              
              *this\row\selected\color\state = #__s_0
            EndIf
            
            ; mode multi select
            If *this\mode\check = 3
              If *this\row\_s()\_state & #__s_selected = 0
                *this\row\_s()\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\_s()\index)
              EndIf
            EndIf
            
            *this\row\_s()\color\state = #__s_3
          EndIf
          
          *this\row\selected = *this\row\_s()
          *this\row\scrolled = (State+1)
          
          _repaint_items_(*this)
          ProcedureReturn #True
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_SetState(*this\gadget[#__panel_1], state)
      EndIf
      
      If *this\type = #__type_tabBar
        result = Tab_SetState(*this, state)
      EndIf
      
      Select *this\type
        Case #__type_Spin ,
             #__type_tabBar,
             #__type_trackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter       
          
          result = Bar_SetState(*this, state)
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetAttribute(*this._s_widget, Attribute.l, *value)
      Protected Result.l
      
      With *this
        If *this\type = #PB_GadgetType_Spin Or
           *this\type = #PB_GadgetType_TabBar Or
           *this\type = #PB_GadgetType_TrackBar Or
           *this\type = #PB_GadgetType_ScrollBar Or
           *this\type = #PB_GadgetType_ProgressBar Or
           *this\type = #PB_GadgetType_Splitter
          Result = Bar_SetAttribute(*this, Attribute, *value)
        EndIf
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
        ; If Text.s = "" : Text.s = #LF$ : EndIf
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
                ; \text\string.s = RemoveString(\text\string.s, #LF$) 
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
        ;         If *this\text\multiline = 0
        ;           Text = RemoveString(Text, #LF$)
        ;         EndIf
        
        Text = ReplaceString(Text, #LFCR$, #LF$)
        Text = ReplaceString(Text, #CRLF$, #LF$)
        Text = ReplaceString(Text, #CR$, #LF$)
        ;Text + #LF$
        
        If *This\text\string.s <> Text.s
          *This\text\string.s = Text.s
          *This\text\change = #True
          Result = #True
        EndIf
      EndIf
      
      *this\change = 1
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetFont(*this._s_widget, FontID.i)
      Protected Result
      
      If *this\text\fontID <> FontID
        *this\text\fontID = FontID
        ; reset current drawing font
        ; to set new current drawing font
        *this\root\text\fontID[1] =- 1 
        
        
        If *this\type = #PB_GadgetType_Editor
          *this\text\change = 1
          
          If Not Bool(*this\row\count And *this\row\count <> *this\count\items)
            Redraw(*this)
          EndIf
        Else
          ; reset current font
          *this\root\text\fontID[1] = 0
          ReDraw(*this)
          ;           ; example\font\font(demo)
          ;           If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
          ;             _drawing_font_(*this)
          ;             Draw(*this)
          ;             
          ;             StopDrawing()
          ;           EndIf
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
            If \color\Line <> Color 
              \color\Line = Color
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
            If \color\Front <> Color 
              \color\Front = Color
              Result = #True
            EndIf
            
          Case #__color_frame
            If \color\Frame <> Color 
              \color\Frame = Color
              Result = #True
            EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure   SetImage(*this._s_widget, *image)
      Protected is_image = IsImage(*image)
      
      If is_image And 
         *this\img\index[0] <> is_image
        *this\img\index[0] = is_image
        *this\img\index[1] = *image
        *this\img\index[2] = ImageID(*image)
      EndIf
    EndProcedure
    
    Procedure   SetData(*this._s_widget, *data)
      *this\data = *data
    EndProcedure
    
    Procedure   SetParent(*this._s_widget, *parent._s_widget, _item.l = 0)
      Protected x.l, y.l, *LastParent._s_widget
      
      If *parent 
        If _item < 0 
          _item = *parent\index[#__panel_1] 
        EndIf
        
        If *this\parent <> *parent Or 
           *this\_item <> _item
          *this\_item = _item
          
          *this\root = *parent\root
          *this\window = *parent\window
          
          If *parent\type = #PB_GadgetType_Panel
            If *parent\index[#__panel_2] <> _item
              *this\hide = #True
            EndIf
          EndIf
          
          If *parent\hide
            *this\hide = #True
          EndIf
          
          ; 
          If *this\parent
            *LastParent = *this\parent
            *LastParent\count\childrens - 1
            
            If _is_root_(*parent)
              FirstElement(Widget())
              MoveElement(Widget(), #PB_List_First)
            Else
              ChangeCurrentElement(Widget(), *this\adress)
              If *parent\last 
                If *parent\last = *this
                  If *parent\last\before
                    MoveElement(Widget(), #PB_List_After, *parent\last\before\adress)
                    ;   MoveElement(Widget(), #PB_list_After, *Parent\adress)
                    
                  Else
                    Debug "*parent\last - " + *parent\last\index
                    MoveElement(Widget(), #PB_List_After, *Parent\adress)
                  EndIf
                Else
                  MoveElement(Widget(), #PB_List_After, *parent\last\adress)
                EndIf
              Else
                MoveElement(Widget(), #PB_List_After, *parent\adress)
              EndIf
            EndIf
            
            
            If *this\root <> *this\parent\root
              LastElement(Widget())
            EndIf
            
            While PreviousElement(Widget()) 
              If Child(Widget(), *this)
                ; Debug Widget()\index
                Widget()\root = *parent\root
                Widget()\window = *parent\window
                
                If Widget()\scroll
                  If Widget()\scroll\v
                    Widget()\scroll\v\root = *parent\root
                    Widget()\scroll\v\window = *parent\window
                  EndIf
                  If Widget()\scroll\h
                    Widget()\scroll\v\root = *parent\root
                    Widget()\scroll\h\window = *parent\window
                  EndIf
                EndIf
                
                MoveElement(Widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
          EndIf
          
          *this\parent = *parent
          
          ; TODO
          If *this\window
            Static NewMap typecount.l()
            
            *this\count\index = typecount(Hex(*this\window) + "_" + Hex(*this\type))
            typecount(Hex(*this\window) + "_" + Hex(*this\type)) + 1
            
            *this\count\type = typecount(Hex(*parent) + "__" + Hex(*this\type))
            typecount(Hex(*parent) + "__" + Hex(*this\type)) + 1
          EndIf
          
          If Not *this\adress
            ;           If Not *parent\last And ListIndex(Widget()) > 0 ; And *parent\last\index < ListIndex(Widget())
            ;             Debug " - - - -  " + *this\class  + " " +  ListIndex(Widget()) ;\index
            ;                                                                               ;Protected *last._s_widget = GetParentLast(*parent)
            ;             SelectElement(Widget(), *parent\index + 1)
            ;             *this\adress = InsertElement(Widget())
            ;             ; *this\adress = AddElement(Widget()) 
            ;             ; *parent\last = *this\after
            ;             
            ;             ;             ; Исправляем идентификатор итема  
            ;             ;             PushListPosition(Widget())
            ;             ;             While NextElement(Widget())
            ;             ;               Widget()\index = ListIndex(Widget())
            ;             ;             Wend
            ;             ;             PopListPosition(Widget())
            ;           *this\index = *this\root\count\childrens; ListIndex(Widget()) 
            ;          Else
            LastElement(Widget())
            *this\adress = AddElement(Widget()) 
            *this\index = ListIndex(Widget()) 
            ;           EndIf
            Widget() = *this
            
            ; set z - order position 
            If Not *parent\first 
              If Not *parent\last
                ; Debug *this\index
                *parent\last = *this
              EndIf
              ; Debug *this\index
              *parent\first = *this
              
            ElseIf *parent\last
              *this\before = *parent\last
              *this\before\after = *this
              
              *parent\last = *this
            EndIf
            
            ; set transformation for the child
            If Not *this\mode\transform And *parent\mode\transform 
              *this\mode\transform = *parent\mode\transform 
              a_set(*this)
            EndIf
          EndIf
          
          ; add parent childrens count
          *parent\count\childrens + 1
          
          If *parent <> *this\root
            *this\root\count\childrens + 1
            *this\level = *parent\level + 1
          EndIf
          
          ; children reparent 
          If *LastParent And 
             *LastParent <> *parent
            
            x = *this\x[#__c_draw]
            y = *this\y[#__c_draw]
            
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
            
            ; new parent
            If *parent\scroll And 
               *parent\scroll\v And 
               *parent\scroll\h
              
              ; for the scroll area childrens
              x - *parent\scroll\h\bar\page\pos
              y - *parent\scroll\v\bar\page\pos
            EndIf
            
            ; last parent
            If *LastParent\scroll And 
               *LastParent\scroll\v And 
               *LastParent\scroll\h
              
              ; for the scroll area childrens
              x + *LastParent\scroll\h\bar\page\pos
              y + *LastParent\scroll\v\bar\page\pos
            EndIf
            
            Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
            
            If *LastParent\root <> *parent\root
              Select Root()
                Case *LastParent\root : ReDraw(*parent\root)
                Case *parent\root     : ReDraw(*LastParent\root)
              EndSelect
            EndIf
          EndIf
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i SetAlignment(*this._s_widget, Mode.l, Type.l = 1) ; ok
      Protected rx.b, ry.b
      
      With *this
        Select Type
          Case 1 ; widget
            If \parent
              If Not \parent\align
                \parent\align.structures::_s_align = AllocateStructure(structures::_s_align)
              EndIf
              If Not \align
                \align.structures::_s_align = AllocateStructure(structures::_s_align)
              EndIf
              
              ; 
              If Mode & #__align_full = #__align_full
                Mode | (Bool(Mode & #__align_right = #False) * #__align_left) |
                       (Bool(Mode & #__align_bottom = #False) * #__align_top) | 
                       (Bool(Mode & #__align_left = #False) * #__align_right) |
                       (Bool(Mode & #__align_top = #False) * #__align_bottom)
              EndIf
              
              If Mode & #__align_right = #__align_right
                rx = 2 + Bool(Mode & #__align_left = #__align_left)
              EndIf
              
              If Mode & #__align_bottom = #__align_bottom
                ry = 2 + Bool(Mode & #__align_top = #__align_top)
              EndIf
              
              If Mode & #__align_center = #__align_center
                If Not Mode & #__align_right And
                   Not Mode & #__align_left
                  rx = 1
                EndIf
                
                If Not Mode & #__align_bottom And
                   Not Mode & #__align_top
                  ry = 1
                EndIf
              EndIf
              
              If Mode & #__align_proportional = #__align_proportional
                If Mode & #__align_vertical = #__align_vertical
                  If Mode & #__align_top = #__align_top And Not Mode & #__align_left 
                    If Mode & #__align_bottom = #__align_bottom
                      ry = 4
                    Else
                      ry = 5
                    EndIf
                  Else
                    ry = 6
                  EndIf
                  
                Else
                  If Mode & #__align_left = #__align_left And Not Mode & #__align_top
                    If Mode & #__align_right = #__align_right
                      rx = 4
                    Else
                      rx = 5
                    EndIf
                  Else
                    rx = 6
                  EndIf
                EndIf
              EndIf
              
              \align\h = rx
              \align\v = ry
              
              \align\delta\x = \x[#__c_draw]
              \align\delta\y = \y[#__c_draw]
              \align\delta\width = \width
              \align\delta\height = \height
              
              \parent\align\delta\width = \parent\width
              \parent\align\delta\height = \parent\height
              
              ; docking
              If Mode & #__align_auto = #__align_auto
                If \align\h = 1 ; center
                  \align\delta\x = (\parent\width[#__c_inner] - \align\delta\width)/2
                ElseIf \align\h = 2 ; right
                  \align\delta\x = \parent\width[#__c_inner] - \align\delta\width
                EndIf
                
                If \align\v = 1 ; center
                  \align\delta\y = (\parent\height[#__c_inner] - \align\delta\height)/2
                ElseIf \align\v = 2 ; bottom
                  \align\delta\y = \parent\height[#__c_inner] - \align\delta\height
                EndIf
                
                If \align\h = 3 Or \align\v = 3
                  If \align\h = 3 ; full horizontal
                    \align\delta\width = \parent\width[#__c_inner]
                    
                    If \align\v = 0 ; top
                      \align\delta\y + \parent\align\_top
                      \parent\align\_top + *this\height
                      
                    ElseIf \align\v = 2 ; bottom
                      \align\delta\y - \parent\align\_bottom
                      \parent\align\_bottom + *this\height + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  If \align\v = 3 ; full vertical
                    \align\delta\height = \parent\height[#__c_inner] 
                    
                    If \align\h = 0 ; left
                      \align\delta\x + \parent\align\_left
                      \parent\align\_left + *this\width
                      
                    ElseIf \align\h = 2 ; right
                      \align\delta\x - \parent\align\_right
                      \parent\align\_right + *this\width + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  PushListPosition(Widget())
                  ForEach Widget()
                    If Widget()\align And
                       Widget()\parent = \parent 
                      
                      If (Widget()\align\h = 0 Or Widget()\align\h = 2)
                        Widget()\align\delta\y = \parent\align\_top
                        Widget()\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                      If (Widget()\align\v = 3 And Widget()\align\h = 3)
                        Widget()\align\delta\x = \parent\align\_left
                        Widget()\align\delta\width = \parent\align\delta\width - \parent\align\_left - \parent\align\_right
                        
                        Widget()\align\delta\y = \parent\align\_top
                        Widget()\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                    EndIf
                  Next
                  PopListPosition(Widget())
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
    
    Procedure __SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
      Protected Type
      Protected Result =- 1
      
      If *this = *Widget_2
        ProcedureReturn 0
      EndIf
      Select Position
        Case #PB_List_First 
          If *this\parent\first <> *this
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_Before, *this\parent\first\adress)
            
            While NextElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_Before, *this\parent\first\adress)
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
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_Before, *this\before\adress)
            
            While NextElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_Before, *this\before\adress)
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
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_After, *this\after\adress)
            
            While PreviousElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_After, *this\adress)
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
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_After, *this\adress)
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
    
    Procedure   SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
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
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_Before, *before\adress)
            
            While NextElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_Before, *before\adress)
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
            
            ChangeCurrentElement(Widget(), *this\adress)
            MoveElement(Widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(Widget()) 
              If Child(Widget(), *this)
                MoveElement(Widget(), #PB_List_After, *this\adress)
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
          ;             ChangeCurrentElement(Widget(), *this\adress)
          ;             MoveElement(Widget(), #PB_list_After, *Last\adress)
          ;             
          ;             While PreviousElement(Widget()) 
          ;               If Child(Widget(), *this)
          ;                 MoveElement(Widget(), #PB_list_After, *this\adress)
          ;               EndIf
          ;             Wend
          ;             
          ;             If *this\parent\first = *this
          ;               *this\parent\first = *after
          ;             EndIf
          ;             
          ;               Debug "last - " + *after\index + " " + *this\after\index
          ;             If *this\after
          ;               *this\after\before = *this\before
          ;             EndIf
          ;             
          ;             *this\before = *after
          ;             *this\after = *after\after 
          ;             
          ;             If Not *this\after
          ; ;               If *this\before
          ; ;                 Debug "   this\before " + *this\before\index
          ; ;               EndIf
          ; ;               Debug "   this " + *this\index
          ; ;               If *this\after
          ; ;                 Debug "   this\after " + *this\after\index
          ; ;               EndIf
          ;             
          ;               *this\parent\last = *this
          ;               *this\parent\last\after = 0
          ;             EndIf
          ;           EndIf
          ;                     *Last = GetParentLast(*this\parent)
          ;                     
          ;                     If *Last <> *this
          ;                       Debug  "set Last "
          ;                       SetPosition(*this, #PB_list_After, *last)
          ;                     EndIf
          
      EndSelect
      
      ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i SetActive(*this._s_widget)
      Protected Result.i
      
      Macro _set_active_state_(_active_, _state_)
        If Not(_active_ = _active_\root And _active_\root\type =- 5)
          If (_state_)
            Events(_active_, #__Event_Focus, Mouse()\x, Mouse()\y)
          Else
            Events(_active_, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          EndIf
          
          PostEvent(#PB_Event_Gadget, _active_\root\canvas\window, _active_\root\canvas\gadget, #__Event_repaint)
        EndIf
        
        If _active_\gadget
          If (_state_)
            Events(_active_\gadget, #__Event_Focus, Mouse()\x, Mouse()\y)
          Else
            Events(_active_\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          EndIf
        EndIf
      EndMacro
      
      With *this
        If *this\child  
          *this = *this\parent
        EndIf
        
        ;This()\widget = *this
        
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
                Events(GetActive()\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
              EndIf
              
              GetActive()\gadget = *this
              Events(GetActive()\gadget, #__Event_Focus, Mouse()\x, Mouse()\y)
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
        Select \type
          Case #PB_GadgetType_Tree,
               #PB_GadgetType_ListView
            
            ;             PushListPosition(*this\row\_s()) 
            ;             ForEach *this\row\_s()
            ;               If *this\row\_s()\index = Item 
            ;                 Result = *this\row\_s()\data
            ;                 ; Debug *this\row\_s()\text\string
            ;                 Break
            ;               EndIf
            ;             Next
            ;             PopListPosition(*this\row\_s())
            ; 
            If _no_select_(*this\row\_s(), item)
              ProcedureReturn #False
            EndIf
            
            Result = *this\row\_s()\data
        EndSelect
      EndWith
      
      ;     If Result
      ;       Protected *w.Widget_S = Result
      ;       
      ;       Debug "GetItemData " + Item  + " " +  Result  + " " +   *w\class
      ;     EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.s GetItemText(*this._s_widget, Item.l, Column.l = 0)
      Protected result.s
      
      If *this\count\items ; row\count
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn ""
        EndIf
        
        If *this\type = #__type_property And Column 
          Result = *this\row\_s()\text\edit\string
        Else
          Result = *this\row\_s()\text\string
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_GetItemText(*this\gadget[#__panel_1], Item, Column)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemImage(*this._s_widget, Item.l) 
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_listview Or
         *this\type = #__type_tree
        
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn #PB_Default
        EndIf
        
        Result = *this\row\_s()\img\index[1]
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_listview Or
         *this\type = #__type_tree
        
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn #False
        EndIf
        
        Result = *this\row\_s()\text\fontID
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
          
          If *this\row\_s()\box[1]\state
            If *this\mode\threestate And *this\row\_s()\box[1]\state = 2
              Result | #__tree_Inbetween
            Else
              Result | #__tree_checked
            EndIf
          EndIf
          
          If *this\row\_s()\childrens And *this\row\_s()\box[0]\state = 0
            Result | #__tree_Expanded
          Else
            Result | #__tree_collapsed
          EndIf
        EndIf
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l = 0)
      Protected Result, *color._s_color
      
      If *this\type = #PB_GadgetType_Editor
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          *color = *this\row\_s()\color
        EndIf
      ElseIf *this\type = #PB_GadgetType_Tree 
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
    
    Procedure.i GetItemAttribute(*this._s_widget, Item.l, Attribute.l, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree
        If _no_select_(*this\row\_s(), Item)
          ProcedureReturn #False
        EndIf
        
        Select Attribute
          Case #__tree_sublevel
            Result = *this\row\_s()\sublevel
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i SetItemData(*This._s_widget, item.l, *data)
      Protected Result.i
      
      If *this\count\items ; *this\type = #__type_tree
                           ;Item = *this\row\i(Hex(Item))
        
        If _no_select_(*this\row\_s(), item)
          ProcedureReturn #False
        EndIf
        
        *this\row\_s()\data = *Data
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure.l SetItemText(*this._s_widget, Item.l, Text.s, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_property
        
        ;Item = *this\row\i(Hex(Item))
        
        If _no_select_(*this\row\_s(), item)
          ProcedureReturn #False
        EndIf
        
        *this\row\count = CountString(Text.s, #LF$)
        
        If Not *this\row\count
          *this\row\_s()\text\string = Text.s
        Else
          *this\row\_s()\text\string = StringField(Text.s, 1, #LF$)
          *this\row\_s()\text\edit\string = StringField(Text.s, 2, #LF$)
        EndIf
        
        *this\row\_s()\text\change = 1
        *this\change = 1
        Result = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText(*this\gadget[#__panel_1], Item, Text, Column)
        
      ElseIf *this\type = #__type_tabBar
        If _is_item_(*this, Item) And
           SelectElement(*this\bar\_s(), Item) And 
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
      
      If *this\type = #__type_tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          If *this\row\_s()\img\index[1] <> Image
            _set_item_image_(*this, *this\row\_s(), Image)
            _repaint_items_(*this)
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont(*this._s_widget, Item.l, Font.i)
      Protected result, FontID.i = FontID(Font)
      
      If *this\type = #__type_Editor Or 
         *this\type = #__type_property Or 
         *this\type = #__type_listview Or 
         *this\type = #__type_tree
        
        If _is_item_(*this, item) And 
           SelectElement(*this\row\_s(), Item) And 
           *this\row\_s()\text\fontID <> FontID
          *this\row\_s()\text\fontID = FontID
          ;       *this\row\_s()\text\change = 1
          ;       *this\change = 1
          Result = #True
        EndIf 
        
      ElseIf *this\type = #__type_Panel
        If _is_item_(*this\gadget[#__panel_1], item) And 
           SelectElement(*this\gadget[#__panel_1]\bar\_s(), Item) And 
           *this\gadget[#__panel_1]\bar\_s()\text\fontID <> FontID
          *this\gadget[#__panel_1]\bar\_s()\text\fontID = FontID
          ;       *this\row\_s()\text\change = 1
          ;       *this\change = 1
          Result = #True
        EndIf 
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState(*this._s_widget, Item.l, State.b)
      Protected result
      
      If *this\type = #__type_Window
        ; result = Window_SetState(*this, state)
        
      ElseIf *this\type = #__type_Editor
        result = Editor_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__type_tree
        result = Tree_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__type_Panel
        ; result = Panel_SetItemState(*this, state)
        
      Else
        ; result = Bar_SetState(*this, state)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l _SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l = 0)
      Protected Result
      
      With *this
        If Item =- 1
          PushListPosition(\row\_s()) 
          ForEach \row\_s()
            Select ColorType
              Case #__color_back
                \row\_s()\color\back[Column] = Color
                
              Case #__color_Front
                \row\_s()\color\front[Column] = Color
                
              Case #__color_Frame
                \row\_s()\color\frame[Column] = Color
                
              Case #__color_line
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
    
    Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_Editor
        
        result = _SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemAttribute(*this._s_widget, Item.l, Attribute.l, *value, Column.l = 0)
      Protected result
      
      If *this\type = #__type_Window
        
      ElseIf *this\type = #__type_tree
        Select Attribute
          Case #__tree_collapsed
            *this\mode\collapse = Bool(Not *value) 
            
          Case #__tree_OptionBoxes
            *this\mode\check = Bool(*value)*2
            
        EndSelect
        
      ElseIf *this\type = #__type_Editor
        
      ElseIf *this\type = #__type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    ;- 
    ;-  CREATEs
    Procedure.i Create(type.l, *parent._s_widget, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i = 0, round.l = 7, ScrollStep.f = 1.0)
      Protected ScrollBars, *this._s_widget = AllocateStructure(_s_widget)
      
      With *this
        
        *this\x[#__c_frame] =- 2147483648
        *this\y[#__c_frame] =- 2147483648
        *this\type = type
        *this\round = round
        
        *this\bar\from =- 1
        *this\bar\index =- 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] =- 1
        
        ; *this\adress = *this
        ; *this\class = #PB_compiler_Procedure
        *this\color = _get_colors_()
        
        ; - Create Texts
        If *this\type = #PB_GadgetType_Editor Or
           *this\type = #PB_GadgetType_String Or
           *this\type = #PB_GadgetType_Button Or
           *this\type = #PB_GadgetType_Option
          
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          *this\color\back = $FFF9F9F9
          
          If *this\type = #PB_GadgetType_MDI
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "MDI"
          EndIf
          
          If *this\type = #PB_GadgetType_ScrollArea
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "ScrollArea"
          EndIf
          
          If *this\type = #PB_GadgetType_Container 
            *this\class = "Container"
            *this\fs = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Panel 
            If Flag & #__bar_vertical = #False
              *this\__height = 25
            Else
              *this\__width = 85
            EndIf
            
            *this\index[#__panel_1] = 0
            *this\index[#__panel_2] = 0
            *this\class = "Panel"
            *this\fs = 1
          EndIf
        EndIf
        
        ; - Create Containers
        If *this\type = #PB_GadgetType_Container Or
           *this\type = #PB_GadgetType_ScrollArea Or
           *this\type = #PB_GadgetType_Panel Or
           *this\type = #PB_GadgetType_MDI
          
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          *this\container = *this\type
          *this\color\back = $FFF9F9F9
          
          If *this\type = #PB_GadgetType_MDI
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "MDI"
          EndIf
          
          If *this\type = #PB_GadgetType_ScrollArea
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "ScrollArea"
          EndIf
          
          If *this\type = #PB_GadgetType_Container 
            *this\class = "Container"
            *this\fs = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Panel 
            If Flag & #__bar_vertical = #False
              *this\__height = 25
            Else
              *this\__width = 85
            EndIf
            
            *this\index[#__panel_1] = 0
            *this\index[#__panel_2] = 0
            *this\class = "Panel"
            *this\fs = 1
          EndIf
        EndIf
        
        ; - Create image
        If *this\type = #PB_GadgetType_Image
          ScrollBars = 1
          *this\class = "Image"
          *this\img\index = IsImage(*param_3)
          
          If *this\img\index
            *this\img\index[1] = *param_3
            *this\img\index[2] = ImageID(*param_3)
            *this\img\width = ImageWidth(*param_3)
            *this\img\height = ImageHeight(*param_3)
            
            *param_1 = *this\img\width 
            *param_2 = *this\img\height 
          EndIf
          
          *this\color\back = $FFF9F9F9
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
        EndIf
        
        ; - Create Bars
        If *this\type = #PB_GadgetType_ScrollBar Or 
           *this\type = #PB_GadgetType_ProgressBar Or
           *this\type = #PB_GadgetType_TrackBar Or
           *this\type = #PB_GadgetType_TabBar Or
           *this\type = #PB_GadgetType_Spin Or
           *this\type = #PB_GadgetType_Splitter
          
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
               Flag & #__bar_vertical = #__bar_vertical
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
          If *this\type = #PB_GadgetType_Spin
            *this\class = "Spin"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            ;*this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If Not (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                    Flag & #__bar_vertical = #__bar_vertical)
              *this\bar\vertical = #True
              *this\bar\inverted = #True
            EndIf
            
            *this\fs = Bool(Not Flag&#__flag_borderless)
            *this\bs = *this\fs
            
            ; *this\text = AllocateStructure(_s_text)
            *this\text\change = 1
            *this\text\editable = 1
            *this\text\align\top = 1
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
            
            ;;*this\text\change = 1
            *this\index[#__s_2] = 0 ; default selected tab
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            ;*this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #False)
            
            If Flag & #__bar_vertical = #__bar_vertical
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
          If *this\type = #PB_GadgetType_TrackBar
            *this\class = "Track"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            *this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or
               Flag & #__bar_vertical = #__bar_vertical
              *this\bar\vertical = #True
              *this\bar\inverted = #True
            EndIf
            
            If flag & #PB_TrackBar_Ticks = #PB_TrackBar_Ticks Or
               Flag & #__bar_ticks = #__bar_ticks
              *this\bar\mode = #PB_TrackBar_Ticks
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
               Flag & #__bar_vertical = #__bar_vertical
              *this\bar\vertical = #True
              *this\bar\inverted = #True
            EndIf
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            
            *this\text\change = #True
            _set_text_flag_(*this, flag|#__text_center)
          EndIf
          
          ; - Create Splitter
          If *this\type = #PB_GadgetType_Splitter
            *this\class = "Splitter"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1
            
            ;         *this\bar\button[#__b_1]\color = _get_colors_()
            ;         *this\bar\button[#__b_2]\color = _get_colors_()
            ;         *this\bar\button[#__b_3]\color = _get_colors_()
            
            ;;Debug ""+*param_1 +" "+ IsGadget(*param_1)
            
            *this\container =- *this\type 
            *this\gadget[#__split_1] = *param_1
            *this\gadget[#__split_2] = *param_2
            *this\index[#__split_1] = Bool(IsGadget(*this\gadget[#__split_1]))
            *this\index[#__split_2] = Bool(IsGadget(*this\gadget[#__split_2]))
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
              *this\bar\mode = #PB_Splitter_Separator
            EndIf
            
            If (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                Flag & #__bar_vertical = #__bar_vertical)
              *this\cursor = #PB_Cursor_LeftRight
            Else
              *this\bar\vertical = #True
              *this\cursor = #PB_Cursor_UpDown
            EndIf
            
            If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
              *this\bar\fixed = #__split_1 
            ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
              *this\bar\fixed = #__split_2 
            EndIf
            
            *this\bar\button[#__b_3]\len = #__splitter_buttonsize
            *this\bar\button[#__b_3]\interact = #True
            *this\bar\button[#__b_3]\round = 2
            
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
        EndIf
        
        ;
        If Flag & #__bar_child = #__bar_child
          *this\parent = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\adress = *parent\adress
          
          *this\child = #True
        Else
          _set_alignment_flag_(*this, *parent, flag)
          
          If *parent
            SetParent(*this, *parent, #PB_Default)
          Else
            *this\draw = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Splitter
            If *this\gadget[#__split_1] And Not *this\index[#__split_1]
              SetParent(*this\gadget[#__split_1], *this)
            EndIf
            
            If *this\gadget[#__split_2] And Not *this\index[#__split_2]
              SetParent(*this\gadget[#__split_2], *this)
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_Panel 
            *this\gadget[#__panel_1] = Create(#__type_tabBar, *this, 0,0,0,0, 0,0,0, 0, Flag|#__bar_child, 0, 30)
          EndIf
          
          If *this\container And 
             *this\type <> #PB_GadgetType_Splitter And 
             flag & #__flag_nogadgets = #False
            OpenList(*this)
          EndIf
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            Area(*this, ScrollStep, *param_1, *param_2, 0, 0)
            ; Area(*this, ScrollStep, *param_1, *param_2, width, height)
          EndIf
          
          
          ; this before resize() and after setparent()
          If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
            a_add(*this)
          EndIf
          
          If *this\fs And Not *this\mode\transform
            *this\bs = *this\fs
          EndIf
          
          Resize(*this, x,y,width,height)
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            *this\x[#__c_required] = *this\x[#__c_inner]
            *this\y[#__c_required] = *this\y[#__c_inner] 
          EndIf
          
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(#__type_TabBar, Opened(), x,y,width,height, min,max,pagelength, 40, flag, round, 40)
    EndProcedure
    
    Procedure.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, Increment.f = 1.0)
      ProcedureReturn Create(#__type_Spin, Opened(), x,y,width,height, min,max,0, #__spin_buttonsize, flag, round, Increment)
    EndProcedure
    
    Procedure.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(#__type_ScrollBar, Opened(), x,y,width,height, min,max,pagelength, #__scroll_buttonsize, flag, round, 1)
    EndProcedure
    
    Procedure.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7)
      ProcedureReturn Create(#__type_TrackBar, Opened(), x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(#__type_ProgressBar, Opened(), x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Splitter(x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i = 0)
      ProcedureReturn Create(#__type_Splitter, Opened(), x,y,width,height, First,Second, 0,0, flag, 0, 1)
    EndProcedure
    
    
    
    ;- 
    Procedure.i Tree(x.l,y.l,width.l,height.l, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      If *this
        With *this
          *this\x[#__c_frame] =- 2147483648
          *this\y[#__c_frame] =- 2147483648
          
          If Flag & #__tree_property
            *this\type = #__type_property
            *this\class = "Property"
            *this\bar\page\pos = 60
            
          ElseIf Flag & #__tree_listview
            *this\type = #PB_GadgetType_ListView
            *this\class = "ListView"
            
          Else
            *this\type = #PB_GadgetType_Tree
            *this\class = #PB_Compiler_Procedure
          EndIf
          
          ;*this\_state = #__s_front
          *this\color\alpha = 255
          *this\color\fore[#__s_0] =- 1
          *this\color\back[#__s_0] = $ffffffff ; _get_colors_()\fore
          *this\color\front[#__s_0] = _get_colors_()\front
          *this\color\frame[#__s_0] = _get_colors_()\frame
          
          *this\row\index =- 1
          *this\change = 1
          
          *this\interact = 1
          ;*this\round = round
          
          *this\text\change = 1 
          *this\text\height = 18 
          
          *this\text\padding\left = 4
          *this\img\padding\left = 2
          
          ;*this\vertical = Bool(Flag&#__flag_vertical)
          *this\fs = Bool(Not Flag&#__flag_borderLess)*2
          *this\bs = *this\fs
          
          If flag & #__tree_NoLines
            flag &~ #__tree_NoLines
          Else
            flag | #__tree_NoLines
          EndIf
          
          If flag & #__tree_NoButtons
            flag &~ #__tree_NoButtons
          Else
            flag | #__tree_NoButtons
          EndIf
          
          If flag
            Flag(*this, flag, #True)
          EndIf
          
          _set_alignment_flag_(*this, *parent, flag)
          SetParent(*this, *parent, #PB_Default)
          
          If flag & #__flag_noscrollbars = #False
            Area(*this, 1, width, height, width, height, Bool((\mode\buttons = 0 And \mode\lines = 0) = 0))
          EndIf
          Resize(*this, X,Y,Width,Height)
        EndWith
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ListView(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Tree(x,y,width,height, Flag|#__tree_nobuttons|#__tree_nolines|#__tree_listview)
    EndProcedure
    
    Procedure.i Tree_Properties(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Tree(x,y,width,height, Flag|#__tree_property)
    EndProcedure
    
    
    ;- 
    Procedure.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i = 0, round.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #PB_GadgetType_Editor
      *this\color = _get_colors_()
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Editor
        *this\class = "Text"
        ; *this\color\back =- 1 
        
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = *this\index[#__s_1]
        
        ; PB 
        *this\fs = constants::_check_(Flag, #__flag_borderLess, #False) * #__border_scroll
        *this\bs = *this\fs
        
        If *this\vertical
          *this\text\X = *this\fs
          *this\text\y = *this\fs
        Else
          *this\text\X = *this\fs + 2
          *this\text\y = *this\fs
        EndIf
        
        
        *this\mode\check = 3 ; multiselect
        *this\mode\fullselection = constants::_check_(Flag, #__flag_fullselection, #False)*7
        *this\mode\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        *this\mode\gridlines = constants::_check_(Flag, #__flag_gridlines)
        
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
    
    Procedure.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_String
      *this\color = _get_colors_()
      *this\color\fore =- 1
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
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
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      ; - Create Text
      If *this\type = #PB_GadgetType_String
        *this\class = "String"
        ; *this\color\back =- 1 
        
        ; PB 
        If Flag & #__flag_borderless = #False
          *this\fs = 1
          *this\bs = *this\fs
        EndIf
        
        If *this\vertical
          *this\text\X = *this\fs
          *this\text\y = *this\fs
        Else
          *this\text\X = *this\fs
          *this\text\y = *this\fs
        EndIf
        
        *this\text\multiline = 0
        Text = RemoveString(Text, #LF$) ; +  #LF$
        
        SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      Area(*this,1,0,0,0,0)
      
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_text
      
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
        
        *this\text\X = 1
        *this\text\multiline =- 1
        SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
      EndIf
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_button
      *this\_flag = Flag|#__text_center
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_(*this, *this\_flag)
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Button
        *this\class = "Button"
        
        *this\color = _get_colors_()
        *this\_state = #__s_front|#__s_back|#__s_frame
        
        ; PB 
        ; If Flag & #__text_border = #__text_border 
        *this\fs = 1
        *this\bs = *this\fs
        *this\text\x = 4
        *this\text\y = 4
        
        SetText(*This, Text)
      EndIf
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If flag & #__flag_anchorsGadget = #__flag_anchorsGadget
        a_add(*this)
      EndIf
      ;       If flag & #__flag_noscrollbars = #False
      ;         Area(*this, 1, 0, 0, 0, 0)
      ;       EndIf
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      ;flag|#__text_center
      
      If Root()\count\childrens
        If Widget()\type = #__type_Option
          *this\_group = Widget()\_group 
        Else
          *this\_group = Widget() 
        EndIf
      Else
        *this\_group = Opened()
      EndIf
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\type = #__type_Option
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      ;       *this\color\back =- 1; _get_colors_(); - 1
      ;       *this\color\fore =- 1
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      
      *this\button\color = _get_colors_()
      *this\button\color\back = $ffffffff
      
      *this\button\width = 15
      *this\button\height = *this\button\width
      *this\button\round = *this\button\width/2
      *this\text\x = *this\button\width + 8
      
      *this\text\multiline =- CountString(Text, #LF$)
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\type = #__type_checkBox
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      *this\mode\threestate = constants::_check_(Flag, #PB_CheckBox_ThreeState)
      *this\text\multiline =- CountString(Text, #LF$)
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      *this\button\color = _get_colors_()
      *this\button\color\back = $ffffffff
      
      *this\button\round = 2
      *this\button\height = 15
      *this\button\width = *this\button\height
      *this\text\x = *this\button\width + 8
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\cursor = #PB_Cursor_Hand
      *this\type = #__type_HyperLink
      *this\class = #PB_Compiler_Procedure 
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag|#__text_center);, 3)
      
      *this\mode\lines = constants::_check_(Flag, #PB_HyperLink_Underline)
      *this\text\multiline =- CountString(Text, #LF$)
      
      *this\_state = #__s_front
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_()\fore
      *this\color\front[#__s_0] = _get_colors_()\front
      *this\color\front[#__s_1] = Color
      
      _set_alignment_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    ;- 
    Procedure.i MDI(x.l,y.l,width.l,height.l, Flag.i = 0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(#__type_MDI, Opened(), x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_nogadgets, 0, 1)
    EndProcedure
    
    Procedure.i Panel(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Create(#__type_Panel, Opened(), x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_noscrollbars, 0, 0)
    EndProcedure
    
    Procedure.i Container(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Create(#__type_container, Opened(), x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_noscrollbars, 0, 0)
    EndProcedure
    
    Procedure.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0)
      ProcedureReturn Create(#__type_ScrollArea, Opened(), x,y,width,height, ScrollAreaWidth,ScrollAreaHeight,0, #__scroll_buttonsize, flag, 0, ScrollStep)
    EndProcedure
    
    Procedure.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__type_Frame, Flag, Opened())
      Protected *parent._s_widget = Opened()
      
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
        
        
        If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
          a_add(*this)
          ;           a_set(*this)
        EndIf
        Resize(*this, X,Y,Width,Height)
        If Text.s
          SetText(*this, Text.s)
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Image(x.l,y.l,width.l,height.l, image.l, Flag.i = 0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(#__type_Image, Opened(), x,y,width,height, 0,0,image, #__scroll_buttonsize, flag, 0, 1)
    EndProcedure
    
    ;- 
    Procedure ToolBar(*parent._s_widget, flag.i = #PB_ToolBar_Small)
      ProcedureReturn ListView(0,0,*parent\width[#__c_inner],20, flag)
    EndProcedure
    
    ;- 
    Procedure.b Draw(*this._s_widget)
      With *this
        ; drawing font
        _drawing_font_(*this)
        
        If *this\mode\transform
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*this\x, *this\y, *this\width, *this\height, $e0e0e0ff)
        EndIf
        
        Select \type
          Case #__type_Window         : Window_Draw(*this)
          Case #__type_container      : ScrollArea_Draw(*this)
          Case #__type_ScrollArea     : ScrollArea_Draw(*this)
          Case #__type_MDI            : ScrollArea_Draw(*this)
          Case #__type_Image          : ScrollArea_Draw(*this)
          Case #__type_Panel          : Panel_Draw(*this)
            
          Case #__type_String         : Editor_Draw(*this)
          Case #__type_Editor         : Editor_Draw(*this)
            
          Case #__type_tree           : Tree_Draw(*this, *this\row\draws())
          Case #__type_property     : Tree_Draw(*this, *this\row\draws())
            
          Case #__type_listView       : Tree_Draw(*this, *this\row\draws())
            
          Case #__type_text           : Button_Draw(*this)
          Case #__type_button         : Button_Draw(*this)
          Case #__type_Option         : Button_Draw(*this)
          Case #__type_checkBox       : Button_Draw(*this)
          Case #__type_HyperLink      : Button_Draw(*this)
            
          Case #__type_Spin ,
               #__type_tabBar,
               #__type_trackBar,
               #__type_ScrollBar,
               #__type_ProgressBar,
               #__type_Splitter       
            
            Bar_Draw(*this)
            
            ;             UnclipOutput()
            ;             DrawingMode(#PB_2DDrawing_Outlined)
            ;             Box(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff00ffff)
            
        EndSelect
        
        ;         If *this\scroll And *this\scroll\v And *this\scroll\h
        ;           UnclipOutput()
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           ;Box(*this\x, *this\y, *this\width, *this\height, $ffffff00)
        ;           Box(*this\x[#__c_required], *this\y[#__c_required], *this\width[#__c_required], *this\height[#__c_required], $ffff00ff)
        ;           ;Box(*this\x[#__c_required], *this\y[#__c_required], *this\scroll\h\bar\max, *this\scroll\v\bar\max,$ff0000ff)
        ;           Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len, $ff00ff00)
        ;           Box(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff00ffff)
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
      ;Debug  "" + Root()\repaint  + " " +  *this\root\repaint
      
      If StartDrawing( CanvasOutput(*this\root\canvas\gadget) )
        ; 
        If Not *this\root\text\fontID[1]
          *this\root\text\fontID[1] = PB_(GetGadgetFont)(#PB_Default)
          If Root()\text\fontID <> *this\root\text\fontID[1]
            Root()\text\fontID = *this\root\text\fontID[1]
          EndIf
        EndIf
        
        ; reset current drawing font
        ; to set new current drawing font
        *this\root\text\fontID[1] =- 1 
        
        If *this\root\canvas\repaint <> #False
          *this\root\canvas\repaint = #False
        EndIf
        
        If _is_root_(*this)
          ; 
          If *this\root\repaint = #True
            ;             CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
            ;               FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight())
            ;             CompilerElse
            FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $f0)
            ;             CompilerEndIf
          EndIf
          
          Protected count
          PushListPosition(Widget())
          ForEach Widget()
            ;             If  Widget()\class = "Tree"
            ;               Draw(Widget())
            ;             EndIf
            
            If Widget()\root\canvas\gadget = *this\root\canvas\gadget And 
               (Not Widget()\hide And Widget()\draw) And (Widget()\width[#__c_clip] > 0 And Widget()\height[#__c_clip] > 0)
              CompilerIf Not (#PB_Compiler_OS = #PB_OS_MacOS And Not Defined(fixme, #PB_Module))
                ClipOutput( Widget()\x[#__c_clip], 
                            Widget()\y[#__c_clip], 
                            Widget()\width[#__c_clip], 
                            Widget()\height[#__c_clip])
              CompilerEndIf
              
              ;               If Focused() = Widget()
              ;                 Debug "" + count  + " " +  Widget()\width[#__c_clip] : count + 1
              ;               EndIf
              Draw(Widget())
            EndIf
            
            If Widget()\mode\transform And (Widget()\width[#__c_clip] = 0 And Widget()\height[#__c_clip] = 0)
              UnclipOutput()
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(Widget()\x[#__c_inner], Widget()\y[#__c_inner], Widget()\width[#__c_inner], Widget()\height[#__c_inner], $ff00ffff)
            EndIf
          Next
          PopListPosition(Widget())
        Else
          Draw(Widget())
        EndIf
        
        ; Draw anchors 
        If Transform()
          a_draw(Transform()\widget)
        EndIf
        
        ; ; ;         ; selector
        ; ; ;         If Transform() 
        ; ; ;            UnclipOutput()
        ; ; ;          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        ; ; ;           Box(Transform()\x, Transform()\y, Transform()\width, Transform()\height , $ff000000);Transform()\color[Transform()\state]\frame) 
        ; ; ;         EndIf
        StopDrawing()
      EndIf
    EndProcedure
    
    Procedure.i _Post(eventtype.l, *this._s_widget, eventitem.l = #PB_All, *data = 0)
      Protected result.i
      
      If eventtype = #PB_EventType_repaint
        If *this = #PB_All
          If Root()\canvas\repaint = #False
            Root()\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, Root()\canvas\window, Root()\canvas\gadget, #PB_EventType_repaint, Root())
          EndIf
        Else
          If *this\root\canvas\repaint = #False
            *this\root\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #PB_EventType_repaint, *this)
          EndIf
        EndIf
      Else
        This()\item = eventitem
        This()\type = eventtype
        This()\widget = *this
        This()\data = *data
        
        ; if bind called
        If *this And *this\root\count\events
          ; Debug eventtype
          
          If Not _is_root_(*this)
            If MapSize(*this\bind())
              PushMapPosition(*this\bind())
              ForEach *this\bind()
                If *this\bind()\callback() = #PB_Ignore 
                  ProcedureReturn #PB_Ignore
                EndIf
              Next
              PopMapPosition(*this\bind())
            EndIf
            
            If MapSize(*this\window\bind()) And Not _is_window_(*this) And Not _is_root_(*this\window) 
              PushMapPosition(*this\window\bind())
              ForEach *this\window\bind()
                If *this\window\bind()\callback() = #PB_Ignore
                  ProcedureReturn #PB_Ignore
                EndIf
              Next
              PopMapPosition(*this\window\bind())
            EndIf
          EndIf
          
          If MapSize(*this\root\bind())
            PushMapPosition(*this\root\bind())
            ForEach *this\root\bind()
              If *this\root\bind()\callback() = #PB_Ignore
                ProcedureReturn #PB_Ignore
              EndIf
            Next
            PopMapPosition(*this\root\bind())
          EndIf
          
        Else
          Select eventtype 
            Case #__Event_Focus, 
                 #__Event_lostFocus
              
              ForEach This()\post()
                If This()\post()\widget = *this And 
                   This()\post()\events() = eventtype
                  result = 1
                EndIf
              Next
              
              If Not result
                AddElement(This()\post())
                This()\post() = AllocateStructure(_s_bind)
                AddMapElement(This()\post()\events(), Hex(eventtype))
                This()\post()\events() = eventtype
                This()\post()\item = eventitem
                This()\post()\widget = *this
                This()\post()\data = *data
              EndIf
          EndSelect
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i _Bind(*this._s_widget, *callback, eventtype.l = #PB_All)
      If *this = #PB_All
        *this = Root()
      EndIf
      
      If Not *this
        ProcedureReturn #False
      EndIf
      
      If Not FindMapElement(*this\bind(), Hex(*callback))
        AddMapElement(*this\bind(), Hex(*callback))
        *this\bind() = AllocateStructure(_s_bind) 
        *this\bind()\callback = *callback
        *this\bind()\widget = *this
        *this\bind()\type = eventtype
        *this\root\count\events + 1
      EndIf
      
      If Not FindMapElement(*this\bind()\events(), Hex(eventtype))
        AddMapElement(*this\bind()\events(), Hex(eventtype))
        *this\bind()\events() = eventtype
      EndIf
      
      If ListSize(This()\post())
        ForEach This()\post()
          ForEach This()\post()\events()
            ; Debug ""+This()\post()\widget +" "+ *this
            If eventtype = This()\post()\events() ; And This()\post()\widget = *this
                                                  ;Debug 54455
              Post(This()\post()\events(), This()\post()\widget, This()\post()\item, This()\post()\data)
              DeleteMapElement(This()\post()\events())
            EndIf
          Next
          DeleteElement(This()\post())
        Next
        ;ClearList(This()\post())
      EndIf
      
      ProcedureReturn *this\bind()
    EndProcedure
    
    
    Procedure.i Post(eventtype.l, *this._s_widget, eventitem.l = #PB_All, *data = 0)
      Protected result.i
      
      If eventtype = #PB_EventType_repaint
        If *this = #PB_All
          If Root()\canvas\repaint = #False
            Root()\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, Root()\canvas\window, Root()\canvas\gadget, #PB_EventType_repaint, Root())
          EndIf
        Else
          If *this\root\canvas\repaint = #False
            *this\root\canvas\repaint = #True
            PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #PB_EventType_repaint, *this)
          EndIf
        EndIf
      Else
        This()\item = eventitem
        This()\type = eventtype
        This()\widget = *this
        This()\data = *data
        
        ; if bind called
        If *this And *this\root\count\events
          ; Debug eventtype
          
          If Not _is_root_(*this)
            If MapSize(*this\bind())
              ; PushMapPosition(*this\bind())
              If FindMapElement(*this\bind(), Hex(#PB_All)) Or FindMapElement(*this\bind(), Hex(eventtype))
                
                
                ForEach *this\bind()
                  If (*this\bind()\type = #PB_All Or
                      *this\bind()\type = eventtype) And 
                     *this\bind()\callback And 
                     *this\bind()\callback() = #PB_Ignore 
                    ProcedureReturn #PB_Ignore
                  EndIf
                Next
              EndIf
              ; PopMapPosition(*this\bind())
            EndIf
            
            If MapSize(*this\window\bind()) And Not _is_window_(*this) And Not _is_root_(*this\window) 
              PushMapPosition(*this\window\bind())
              If FindMapElement(*this\window\bind(), Hex(#PB_All)) Or
                 FindMapElement(*this\window\bind(), Hex(eventtype))
                
                
                ForEach *this\window\bind()
                  If (*this\window\bind()\type = #PB_All Or 
                      *this\window\bind()\type = eventtype) And
                     *this\window\bind()\callback And 
                     *this\window\bind()\callback() = #PB_Ignore 
                    ProcedureReturn #PB_Ignore
                  EndIf
                Next
              EndIf
              PopMapPosition(*this\window\bind())
            EndIf
          EndIf
          
          If MapSize(*this\root\bind())
            PushMapPosition(*this\root\bind())
            If FindMapElement(*this\root\bind(), Hex(#PB_All)) Or
               FindMapElement(*this\root\bind(), Hex(eventtype))
              
              ForEach *this\root\bind()
                If (*this\root\bind()\type = #PB_All Or 
                    *this\root\bind()\type = eventtype) And
                   *this\root\bind()\callback And 
                   *this\root\bind()\callback() = #PB_Ignore 
                  ProcedureReturn #PB_Ignore
                EndIf
              Next
            EndIf
            PopMapPosition(*this\root\bind())
          EndIf
          
        Else
          Select eventtype 
            Case #__Event_Focus, 
                 #__Event_lostFocus
              
              ForEach This()\post()
                If This()\post()\widget = *this And 
                   This()\post()\events() = eventtype
                  result = 1
                EndIf
              Next
              
              If Not result
                AddElement(This()\post())
                This()\post() = AllocateStructure(_s_bind)
                AddMapElement(This()\post()\events(), Hex(eventtype))
                This()\post()\events() = eventtype
                This()\post()\item = eventitem
                This()\post()\widget = *this
                This()\post()\data = *data
              EndIf
          EndSelect
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind(*this._s_widget, *callback, eventtype.l = #PB_All)
      If *this = #PB_All
        *this = Root()
      EndIf
      
      If Not *this
        ProcedureReturn #False
      EndIf
      
      *this\root\count\events + 1
      
      If Not FindMapElement(*this\bind(), Hex(eventtype))
        AddMapElement(*this\bind(), Hex(eventtype))
        *this\bind() = AllocateStructure(_s_bind) 
      Else
        If Not FindMapElement(*this\bind(), Hex(*callback))
          AddMapElement(*this\bind(), Hex(*callback))
          *this\bind() = AllocateStructure(_s_bind) 
        EndIf
      EndIf
      
      *this\bind()\widget = *this
      *this\bind()\type = eventtype
      *this\bind()\callback = *callback
      
      ;Debug ""+eventtype+" "+MapSize(*this\bind())
      
      If ListSize(This()\post())
        ForEach This()\post()
          ForEach This()\post()\events()
            ; Debug ""+This()\post()\widget +" "+ *this
            If eventtype = This()\post()\events() ; And This()\post()\widget = *this
                                                  ;Debug 54455
              Post(This()\post()\events(), This()\post()\widget, This()\post()\item, This()\post()\data)
              DeleteMapElement(This()\post()\events())
            EndIf
          Next
          DeleteElement(This()\post())
        Next
        ;ClearList(This()\post())
      EndIf
      
      ProcedureReturn *this\bind()
    EndProcedure
    
    Procedure.i Unbind(*callback, *this._s_widget = #PB_All, eventtype.l = #PB_All)
      ;       If *this\event
      ;         *this\event\type = 0
      ;         *this\event\callback = 0
      ;         FreeStructure(*this\event)
      ;         *this\event = 0
      ;       EndIf
      ;       
      ;       ProcedureReturn *this\event
    EndProcedure
    
    Procedure PBFlag(Type, Flag)
      Protected flags
      
      Select Type
        Case #PB_GadgetType_CheckBox
          If Flag & #PB_CheckBox_Right = #PB_CheckBox_Right
            Flag &~ #PB_CheckBox_Right
            flags | #__text_right
          EndIf
          If Flag & #PB_CheckBox_Center = #PB_CheckBox_Center
            Flag &~ #PB_CheckBox_Center
            flags | #__text_center
          EndIf
          
        Case #PB_GadgetType_Text
          If Flag & #PB_Text_Border = #PB_Text_Border
            Flag &~ #PB_Text_Border
            flags | #__text_border
          EndIf
          If Flag & #PB_Text_Center = #PB_Text_Center
            Flag &~ #PB_Text_Center
            flags | #__text_center
          EndIf
          If Flag & #PB_Text_Right = #PB_Text_Right
            Flag &~ #PB_Text_Right
            flags | #__text_right
          EndIf
          
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
          
      EndSelect
      
      flags | Flag
      ProcedureReturn flags
    EndProcedure
    
    
    ;-  MAC OS
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
    Procedure Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
      Protected Repaint
      
      If Not _is_widget_(*this)
        If Not _is_root_(*this)
          Debug "not event widget - " + *this
        EndIf
        ProcedureReturn 0
      EndIf
      
      If *this\mode\transform
        Post(eventtype, *this, *this\index[#__s_1])
        ProcedureReturn 0
      EndIf    
      
      If *this\type = #__type_window
        Repaint = Window_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #__type_property
        Repaint = Tree_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree
        Repaint = Tree_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        Repaint = ListView_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Editor 
        Repaint = Editor_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_String
        Repaint = Editor_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        Repaint = Bar_Events(*this\gadget[#__panel_1], eventtype, mouse_x, mouse_y)
      EndIf
      
      ;
      If *this\type = #PB_GadgetType_Option Or
         *this\type = #PB_GadgetType_CheckBox
        
        Select eventtype
          Case #PB_EventType_LeftButtonDown : Repaint = #True
          Case #PB_EventType_LeftButtonUp   : Repaint = #True
            If *this\_state & #__s_entered
              If *this\type = #PB_GadgetType_CheckBox
                SetState(*this, Bool(Bool(*this\button\state & #PB_Checkbox_Checked = #PB_Checkbox_Checked) ! 1))
              Else
                SetState(*this, #True)
              EndIf
              
              Post(#PB_EventType_LeftClick, *this) 
            EndIf
        EndSelect
      EndIf
      
      If *this\type = #PB_GadgetType_Button
        If eventtype = #PB_EventType_LeftButtonUp : Repaint = #True
          If *this\_state & #__s_entered
            SetState(*this, Bool(Bool(*this\_state & #__s_toggled) ! 1))
            
            Post(#PB_EventType_LeftClick, *this) 
          EndIf
        EndIf
        
        If *this\_state & #__s_toggled = #False
          Select eventtype
            Case #PB_EventType_MouseLeave     : Repaint = #True : *this\color\state = #__s_0 
            Case #PB_EventType_LeftButtonDown : Repaint = #True : *this\color\state = #__s_2
            Case #PB_EventType_MouseEnter     : Repaint = #True : *this\color\state = #__s_1 + Bool(*this = Selected())
          EndSelect
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_HyperLink
        If eventtype <> #PB_EventType_MouseLeave And
           _from_point_(mouse_x - *this\x, mouse_y - *this\y, *this, [#__c_required])
          
          Select eventtype
            Case #PB_EventType_LeftClick : Post(eventtype, *this)
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
      
      ;
      If *this\type = #PB_GadgetType_Spin Or
         *this\type = #PB_GadgetType_tabBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_Splitter
        
        Repaint = Bar_Events(*this, eventtype, mouse_x, mouse_y, _wheel_x_, _wheel_y_)
      EndIf
      
      ;
      If MapSize(*this\bind()) 
        ;ForEach *this\bind()
        If This()\type <> eventtype  
          ;If FindMapElement(*this\bind()\events(), Hex(eventtype)) 
          If FindMapElement(*this\bind(), Hex(eventtype)) 
            Post(eventtype, *this, *this\index[#__s_1])
          EndIf
        EndIf
        ;Next
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
      ;      mouse_x = DesktopMouseX() - GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
      ;      mouse_y = DesktopMouseY() - GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
      Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
      Protected *this._s_widget = GetGadgetData(Canvas)
      
      If Root() <> *this\root
        Root() = *this\root
      EndIf
      
      Select eventtype
        Case #__Event_repaint 
          Repaint = 1
          If #debug_repaint
            Debug " - -  Canvas repaint - -  "; + widget()\row\count
          EndIf
          
        Case #__Event_resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          Repaint = Resize(Root(), #PB_Ignore, #PB_Ignore, Width, Height)  
          
          ;           If Not _is_root_(*this)
          ;             Repaint = Resize(*this, #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;            ; PushListPosition(Widget())
          ;             ;         ForEach Widget()
          ;             ;           Resize(Widget(), #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;         Next
          ;             ;         ; PopListPosition(Widget())
          ;           EndIf
          
          Repaint = 1
          
      EndSelect
      
      ; set mouse buttons
      If eventtype = #__Event_leftButtonDown
        Mouse()\buttons | #PB_Canvas_LeftButton
        
      ElseIf eventtype = #__Event_rightButtonDown
        Mouse()\buttons | #PB_Canvas_RightButton
        
      ElseIf eventtype = #__Event_MiddleButtonDown
        Mouse()\buttons | #PB_Canvas_MiddleButton
        
      ElseIf eventtype = #__Event_MouseWheel
        Mouse()\wheel\y = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_WheelDelta)
        
      ElseIf eventtype = #__Event_Input 
        Keyboard()\input = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Input)
        
      ElseIf eventtype = #__Event_KeyDown Or 
             eventtype = #__Event_KeyUp
        Keyboard()\Key = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Key)
        Keyboard()\key[1] = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Modifiers)
        
      ElseIf eventtype = #__Event_MouseMove
        If Mouse()\x <> mouse_x
          Mouse()\x = mouse_x
          change = #True
        EndIf
        
        If Mouse()\y <> mouse_y
          Mouse()\y = mouse_y
          change = #True
        EndIf
        
      ElseIf Not Mouse()\buttons And 
             (eventtype = #__Event_MouseEnter Or 
              eventtype = #__Event_MouseLeave)
        change =- 1
      EndIf
      
      ; widget enter&leave mouse events
      If change
        ; get at point
        If Root()\count\childrens
          LastElement(Widget()) 
          Repeat                                 
            If _is_widget_(Widget()) And
               Not Widget()\hide And Widget()\draw And 
               Widget()\root\canvas\gadget = Root()\canvas\gadget And 
               _from_point_(mouse_x, mouse_y, Widget(), [#__c_clip])
              
              *this = Widget()
              
              ; scrollbars events
              If *this And *this\scroll
                If *this\scroll\v And Not *this\scroll\v\hide And *this\scroll\v\type And 
                   _from_point_(mouse_x,mouse_y, *this\scroll\v, [#__c_clip])
                  *this = *this\scroll\v
                ElseIf *this\scroll\h And Not *this\scroll\h\hide And *this\scroll\h\type And 
                       _from_point_(mouse_x,mouse_y, *this\scroll\h, [#__c_clip])
                  *this = *this\scroll\h
                EndIf
              EndIf
              
              ; tabbar events
              If *this And *this\gadget[#__panel_1] 
                If Not *this\gadget[#__panel_1]\hide And  *this\gadget[#__panel_1]\type And 
                   _from_point_(mouse_x,mouse_y, *this\gadget[#__panel_1], [#__c_clip])
                  *this = *this\gadget[#__panel_1]
                EndIf
              EndIf
              
              Break
            EndIf
          Until PreviousElement(Widget()) = #False 
        EndIf
        
        If Not *this : *this = Root() : EndIf
        
        ; set widget mouse
        ; state - (entered & leaved)   
        If Entered() <> *this
          If Entered() And Entered()\_state & #__s_entered And 
             Not (#__from_mouse_state And Child(*this, Entered()))
            Entered()\_state &~ #__s_entered
            
            Repaint | Events(Entered(), #__Event_MouseLeave, mouse_x, mouse_y)
            
            If #__from_mouse_state
              ;ChangeCurrentElement(Widget(), Entered()\adress)
              SelectElement(Widget(), Entered()\index)
              Repeat                 
                If Widget()\draw And Child(Entered(), Widget())
                  If Widget()\_state & #__s_entered
                    Widget()\_state &~ #__s_entered
                    
                    Repaint | Events(Widget(), #__Event_MouseLeave, mouse_x, mouse_y)
                  EndIf
                EndIf
              Until PreviousElement(Widget()) = #False 
            EndIf
            
            Entered() = *this
          EndIf
          
          If *this And
             *this\_state & #__s_entered = #False
            *this\_state | #__s_entered
            Entered() = *this
            
            If #__from_mouse_state
              ForEach Widget()
                If Widget() = Entered()
                  Break
                EndIf
                
                If Widget()\draw And Child(Entered(), Widget())
                  If Widget()\_state & #__s_entered = #False
                    Widget()\_state | #__s_entered
                    
                    Repaint | Events(Widget(), #__Event_MouseEnter, mouse_x, mouse_y)
                  EndIf
                EndIf
              Next
            EndIf
            
            Repaint | Events(Entered(), #__Event_MouseEnter, mouse_x, mouse_y)
          EndIf
        EndIf  
      EndIf
      
      
      ; set active widget
      If (eventtype = #__Event_leftButtonDown Or
          eventtype = #__Event_rightButtonDown) And _is_widget_(Entered()) 
        
        Focused() = Entered()
        Selected() = Entered()
        Selected()\_state | #__s_selected
        
        ; If Not Entered()\mode\transform And Not (Transform() And Transform()\index)
        
        If Entered()\bar\from > 0
          ; bar mouse delta pos
          If Entered()\bar\from = #__b_3
            Mouse()\delta\x = mouse_x - Entered()\bar\thumb\pos
            Mouse()\delta\y = mouse_y - Entered()\bar\thumb\pos
          EndIf
        Else
          Mouse()\delta\x = mouse_x - Entered()\x[#__c_draw]
          Mouse()\delta\y = mouse_y - Entered()\y[#__c_draw] ; + (Entered()\x[#__c_frame] - Entered()\x)
        EndIf
        ; EndIf
        
        ;           If Entered()\child  
        ;             Repaint | SetActive(Entered()\parent)
        ;           Else
        Repaint | SetActive(Entered())
        ;           EndIf
      EndIf
      
      ; events anchors on the widget
      If Transform() And Transform()\widget
        Repaint | a_events(eventtype)
      EndIf
      
      ;
      If eventtype = #__Event_repaint 
        
      ElseIf eventtype = #__Event_leftClick 
      ElseIf eventtype = #__Event_leftDoubleClick 
      ElseIf eventtype = #__Event_rightClick 
      ElseIf eventtype = #__Event_rightDoubleClick 
        
      ElseIf eventtype = #__Event_DragStart 
      ElseIf eventtype = #__Event_Focus
        
      ElseIf eventtype = #__Event_lostFocus
        If GetActive()
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          Repaint | Events(GetActive(), #__Event_lostFocus, mouse_x, mouse_y)
          
          If GetActive()\gadget And GetActive() <> GetActive()\gadget
            Repaint | Events(GetActive()\gadget, #__Event_lostFocus, mouse_x, mouse_y)
            GetActive()\gadget = 0
          EndIf
          
          ; GetActive() = 0
        EndIf
        
      ElseIf eventtype = #__Event_MouseEnter 
        If Entered() And 
           Entered()\_state & #__s_entered = #False
          Entered()\_state | #__s_entered
          ; Debug "enter " + Entered()\class
          
          Repaint | Events(Entered(), #__Event_MouseEnter, mouse_x, mouse_y)
        EndIf
        
      ElseIf eventtype = #__Event_MouseLeave 
        If Entered() And 
           Entered()\_state & #__s_entered
          Entered()\_state &~ #__s_entered
          ; Debug "leave " + Entered()\class
          
          Repaint | Events(Entered(), #__Event_MouseLeave, mouse_x, mouse_y)
        EndIf
        
      ElseIf eventtype = #__Event_MouseMove 
        If change
          ; Drag start
          If Mouse()\buttons And 
             Mouse()\drag = #False
            Mouse()\drag = #True
            repaint | Events(Entered(), #__Event_DragStart, mouse_x, mouse_y)
          Else
            If Entered()
              Repaint | Events(Entered(), eventtype, mouse_x, mouse_y)
            EndIf
            If Selected() And
               Selected() <> Entered()
              Repaint | Events(Selected(), eventtype, mouse_x, mouse_y)
            EndIf
          EndIf
        EndIf
        
      ElseIf eventtype = #__Event_Input Or
             eventtype = #__Event_KeyDown Or
             eventtype = #__Event_KeyUp
        
        ; widget keyboard events
        If Focused()
          Repaint | Events(Focused(), eventtype, mouse_x, mouse_y)
        EndIf
        
        ;         If GetActive() 
        ;           If GetActive()\gadget
        ;             Repaint | Events(GetActive()\gadget, eventtype, mouse_x, mouse_y)
        ;           Else
        ;             Repaint | Events(GetActive(), eventtype, mouse_x, mouse_y)
        ;           EndIf
        ;         EndIf
        
      ElseIf eventtype = #__Event_leftButtonUp Or 
             eventtype = #__Event_rightButtonUp Or
             eventtype = #__Event_MiddleButtonUp
        
        ; reset mouse buttons
        If Mouse()\buttons
          If eventtype = #__Event_leftButtonUp
            Mouse()\buttons &~ #PB_Canvas_LeftButton
          ElseIf eventtype = #__Event_rightButtonUp
            Mouse()\buttons &~ #PB_Canvas_RightButton
          ElseIf eventtype = #__Event_MiddleButtonUp
            Mouse()\buttons &~ #PB_Canvas_MiddleButton
          EndIf
          
          If _is_widget_(Selected()) And Not Mouse()\buttons
            Repaint | Events(Selected(), eventtype, mouse_x, mouse_y)
            
            ;             If Selected()\_state & #__s_entered
            ;               If eventtype = #__Event_leftButtonUp
            ;                 Repaint | Events(Selected(), #__Event_leftClick, mouse_x, mouse_y)
            ;               EndIf
            ;               If eventtype = #__Event_rightButtonUp
            ;                 Repaint | Events(Selected(), #__Event_rightClick, mouse_x, mouse_y)
            ;               EndIf
            ;             EndIf
            
            
            Selected()\_state &~ #__s_selected
            If Selected()\_state & #__s_entered
              If Not Mouse()\drag
                Static ClickTime 
                ; Debug Str(ElapsedMilliseconds() - ClickTime)  + " " +  DoubleClickTime()
                
                If Not (ClickTime And (ElapsedMilliseconds() - ClickTime) < DoubleClickTime())
                  ; if the mouse button 
                  ; is released in the widget
                  ; then send the message click
                  If eventtype = #__Event_leftButtonUp
                    Repaint | Events(Selected(), #__Event_leftClick, mouse_x, mouse_y)
                  EndIf
                  If eventtype = #__Event_rightButtonUp
                    Repaint | Events(Selected(), #__Event_rightClick, mouse_x, mouse_y)
                  EndIf
                  ClickTime = ElapsedMilliseconds()
                Else
                  If eventtype = #__Event_leftButtonUp
                    Repaint | Events(Selected(), #__Event_leftDoubleClick, mouse_x, mouse_y)
                  EndIf
                  If eventtype = #__Event_rightButtonUp
                    Repaint | Events(Selected(), #__Event_rightDoubleClick, mouse_x, mouse_y)
                  EndIf
                  ClickTime = 0
                EndIf
              EndIf
            Else
              ; Repaint | Events(Selected(), #__Event_MouseLeave, mouse_x, mouse_y)
              ; Repaint | Events(Entered(), #__Event_MouseEnter, mouse_x, mouse_y)
            EndIf
            
            Mouse()\delta\x = 0
            Mouse()\delta\y = 0
            Mouse()\drag = 0
            Selected() = 0
          EndIf
        EndIf
        
      Else
        If eventtype <> #__Event_MouseMove
          change = 1
        EndIf
        
        If Entered() And change
          Repaint | Events(Entered(), eventtype, mouse_x, mouse_y)
        EndIf
        If Selected() And Entered() <> Selected() And change 
          Repaint | Events(Selected(), eventtype, mouse_x, mouse_y)
        EndIf
      EndIf
      
      If Repaint 
        ;       If Entered() And Entered()\bar\button[#__b_3]\color\state
        ; ;         Debug Entered()\bar\button[#__b_3]\color\state
        ; ;       EndIf
        ;       ;       If Entered() And Entered()\type = #__type_tree
        ;                ReDraw(Entered())
        ;            Else
        ReDraw(Root())
        ;             EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure CW_resize()
      Protected canvas = GetWindowData(EventWindow())
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
    EndProcedure
    
    Procedure CW_Active()
      Protected Repaint
      Protected canvas = GetWindowData(EventWindow())
      ;Debug  Entered()
      ;SetActiveGadget(canvas)
      
      
      ;       If _is_widget_(Entered()) 
      ;         Selected() = Entered()
      ;         Selected()\_state | #__s_selected
      ;         
      ;         If Entered()\bar\from
      ;           ; bar mouse delta pos
      ;           If Entered()\bar\from = #__b_3
      ;             Mouse()\delta\x = Mouse()\x - Entered()\bar\thumb\pos
      ;             Mouse()\delta\y = Mouse()\y - Entered()\bar\thumb\pos
      ;           EndIf
      ;         Else
      ;           Mouse()\delta\x = Mouse()\x - Entered()\x[#__c_draw]
      ;           Mouse()\delta\y = Mouse()\y - Entered()\y[#__c_draw]
      ;         EndIf
      ;         
      ;         If Entered() = Entered()\parent\scroll\v Or
      ;            Entered() = Entered()\parent\scroll\h Or 
      ;            Entered() = Entered()\parent\gadget[#__panel_1] 
      ;           
      ;           Repaint | SetActive(Entered()\parent)
      ;         Else
      ;           Repaint | SetActive(Entered())
      ;         EndIf
      ;         
      ;         Repaint | Events(Entered(), #PB_EventType_leftButtonDown, Mouse()\x, Mouse()\y)
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
        Repaint | Events(GetActive(), #__Event_lostFocus, Mouse()\x, Mouse()\y)
        
        If GetActive()\gadget And GetActive() <> GetActive()\gadget
          Repaint | Events(GetActive()\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          GetActive()\gadget = 0
        EndIf
        
        If Repaint 
          ReDraw(Root())
        EndIf 
        
        GetActive() = 0
      EndIf
    EndProcedure
    
    ;-
    Procedure   Open(window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any)
      If width = #PB_Ignore And height = #PB_Ignore
        flag = #PB_Canvas_Container
      EndIf
      
      If Not IsWindow(window) 
        window = GetWindow(Root())
        
        If Not (IsWindow(window) And
                Root()\canvas\container = Widget())
          width = Widget()\width + #__bsize * 2
          height = Widget()\height + #__height + #__bsize * 2
          window = OpenWindow(#PB_Any, Widget()\x,Widget()\y,width,height, "", #PB_Window_BorderLess)
        EndIf
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth(window, #PB_Window_InnerCoordinate) - x*2
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight(window, #PB_Window_InnerCoordinate) - y*2
      EndIf
      
      Protected g = CanvasGadget(Canvas, X, Y, Width, Height, Flag|#PB_Canvas_Keyboard) : If Canvas = -1 : Canvas = g : EndIf
      
      Root() = AllocateStructure(_s_root)
      Root()\text\fontID = PB_(GetGadgetFont)(#PB_Default)
      Root()\class = "Root"
      
      Opened() = Root()
      Entered() = Root()
      Root()\root = Root()
      Root()\parent = Root()
      Root()\window = Root()
      
      Root()\container = #__type_root
      
      Root()\canvas\window = Window
      Root()\canvas\gadget = Canvas
      
      GetActive() = Root()
      GetActive()\root = Root()
      
      
      Resize(Root(), 0,0,width,height)
      
      If flag & #PB_Canvas_Container = #PB_Canvas_Container
        If ListSize(Widget())
          If Widget()\container =- 1
            _set_alignment_flag_(Widget(), Root(), #__flag_autosize)
            Root()\canvas\container = Widget()
            OpenList(Widget())
            SetParent(Widget(), Root())
          EndIf
        Else
          Root()\canvas\container =- 1
        EndIf
        
        BindEvent(#PB_Event_SizeWindow, @CW_resize(), Window);, Canvas)
      EndIf
      
      BindEvent(#PB_Event_ActivateWindow, @CW_Active(), Window);, Canvas)
      BindEvent(#PB_Event_DeactivateWindow, @CW_Deactive(), Window);, Canvas)
      
      ; z - order
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE ) | #WS_cLIPSIBLINGS )
        SetWindowPos_( GadgetID(Canvas), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      CompilerEndIf
      
      If *CallBack
        BindGadgetEvent(Canvas, *CallBack)
      Else
        Root()\repaint = #True
      EndIf
      BindGadgetEvent(Canvas, @CallBack())
      
      PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Resize)
      
      SetGadgetData(Canvas, Root())
      SetWindowData(window, Canvas)
      
      ;       LastElement(Widget())
      ;       Root()\adress = AddElement(Widget()) 
      ;       Root()\index = ListIndex(Widget()) 
      ;       ;           EndIf
      ;       Widget() = Root()
      
      ProcedureReturn Root()
    EndProcedure
    
    Procedure.i Window(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0, *parent._s_widget = 0)
      If Not Root()
        Protected root = Open(OpenWindow(#PB_Any, X,Y,Width+#__bsize*2,Height+#__height+#__bsize*2, "", #PB_Window_BorderLess, *parent))
        Flag | #__flag_autosize
        x = 0
        y = 0
      EndIf
      
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      
      If *parent
        If Root() = *parent 
          Root()\parent = *this
        EndIf
      Else
        If Root()\canvas\container > 1
          *parent = Root()\canvas\container 
        Else
          *parent = Root()
        EndIf
      EndIf
      
      With *this
        If root
          Root()\canvas\container = *this
        EndIf
        
        *this\container =- 1
        *this\x[#__c_frame] =- 2147483648
        *this\y[#__c_frame] =- 2147483648
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        *this\round = 7
        
        *this\type = #__type_Window
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        ; Background image
        \img\index[1] =- 1
        
        
        ;       \mode\window\sizeGadget = constants::_check_(flag, #__Window_SizeGadget)
        ; ;       \mode\window\systemMenu = constants::_check_(flag, #__Window_SystemMenu)
        ; ;       \mode\window\MinimizeGadget = constants::_check_(flag, #__Window_MinimizeGadget)
        ; ;       \mode\window\MaximizeGadget = constants::_check_(flag, #__Window_MaximizeGadget)
        ;       \mode\window\titleBar = constants::_check_(flag, #__Window_titleBar)
        ;       \mode\window\tool = constants::_check_(flag, #__Window_tool)
        ;       \mode\window\borderless = constants::_check_(flag, #__Window_borderLess)
        
        \caption\round = 4
        \caption\_padding = \caption\round
        \caption\color = _get_colors_()
        
        ;\caption\hide = constants::_check_(flag, #__flag_borderless)
        \caption\hide = constants::_check_(flag, #__Window_titleBar, #False)
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
        
        \caption\button[0]\round = 4 + 3
        \caption\button[1]\round = \caption\button[0]\round
        \caption\button[2]\round = \caption\button[0]\round
        \caption\button[3]\round = \caption\button[0]\round
        
        \caption\button[0]\width = 12 + 2
        \caption\button[0]\height = 12 + 2
        
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
        
        If Text And \caption\height
          \caption\text\_padding = 5
          \caption\text\string = Text
        EndIf
        
        *this\fs = constants::_check_(flag, #__flag_borderless, #False) * #__bsize
        
        _set_alignment_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        If flag & #__Window_NoGadgets = #False
          OpenList(*this)
        EndIf
        
        ; this before resize() and after setparent()
        If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
          a_add(*this)
        EndIf
        
        If flag & #__Window_NoActivate = #False And Not *this\mode\transform
          SetActive(*this)
        EndIf 
        
        If *this\fs And Not *this\mode\transform
          *this\bs = *this\fs
        ElseIf *this\mode\transform
          ;           a_set(*this)
        EndIf
        
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  window = -1, *CallBack = #Null)
      Protected *this, g
      
      If  window = -1
        window = GetActiveWindow()
      EndIf
      
      Flag = PBFlag(Type, Flag) | #__flag_autosize
      
      Open(Window, x,y,Width,Height, #Null, *CallBack, Gadget)
      
      Select Type
        Case #PB_GadgetType_Tree      : *this = Tree(0, 0, Width, Height, flag)
        Case #PB_GadgetType_Text      : *this = Text(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_Button    : *this = Button(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_Option    : *this = Option(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_CheckBox  : *this = Checkbox(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_HyperLink : *this = HyperLink(0, 0, Width, Height, Text, *param1, flag)
        Case #PB_GadgetType_Splitter  : *this = Splitter(0, 0, Width, Height, *param1, *param2, flag)
      EndSelect
      
      If Gadget =- 1
        Gadget = GetGadget(Root())
        g = Gadget
      Else
        g = GadgetID(Gadget)
      EndIf
      SetGadgetData(Gadget, *this)
      
      Entered() = *this
      
      ProcedureReturn g
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
          
          If \type = #PB_GadgetType_Splitter
            If \gadget[#__split_1] : FreeStructure(\gadget[#__split_1]) : \gadget[#__split_1] = 0 : EndIf
            If \gadget[#__split_2] : FreeStructure(\gadget[#__split_2])  : \gadget[#__split_2] = 0 : EndIf
          EndIf
          
          If \gadget[#__panel_1]
          EndIf
          
          If *this\parent 
            If *this\parent\scroll\v = *this
              FreeStructure(*this\parent\scroll\v) : *this\parent\scroll\v = 0
            EndIf
            If *this\parent\scroll\h = *this
              FreeStructure(*this\parent\scroll\h)  : *this\parent\scroll\h = 0
            EndIf
            
            If *this\parent\type = #PB_GadgetType_Splitter
              If *this\parent\gadget[#__split_1] = *this
                FreeStructure(*this\parent\gadget[#__split_1]) : *this\parent\gadget[#__split_1] = 0
              EndIf
              If *this\parent\gadget[#__split_2] = *this
                FreeStructure(*this\parent\gadget[#__split_2])  : *this\parent\gadget[#__split_2] = 0
              EndIf
            EndIf
          EndIf
          
          
          Debug  " free - " + ListSize(Widget())  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          If *this\parent And
             *this\parent\count\childrens 
            
            LastElement(Widget())
            Repeat
              If Widget() = *this Or Child(Widget(), *this)
                
                If Widget()\root\count\childrens > 0 
                  Widget()\root\count\childrens - 1
                  If Widget()\parent <> Widget()\root
                    Widget()\parent\count\childrens - 1
                  EndIf
                  DeleteElement(Widget(), 1)
                EndIf
                
                If Not *this\root\count\childrens
                  Break
                EndIf
              ElseIf PreviousElement(Widget()) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  "   free - " + ListSize(Widget())  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          
          
          
          If Entered() = *this
            Entered() = *this\parent
          EndIf
          If Selected() = *this
            Selected() = *this\parent
          EndIf
          
          ; *this = 0
          ;ClearStructure(*this, _s_widget)
        EndIf
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf



;- 
Macro EventWidget()
  widget::This()\widget
EndMacro

Macro WidgetEvent()
  widget::This()\type
EndMacro

Macro Uselib(_name_)
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro

; IncludePath "../../"
; XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  Uselib(Widget)
  EnableExplicit
  
  Define a,i, *g._s_widget
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
  Text.s = "This is a long line." + m.s +
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
           "Otherwise it will not work." ;+ m.s +
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
    SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, 7+a, "_")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    ;SetGadgetFont(0, FontID(0))
    
    
    Open(0, 10, 200, 306, 133)
    ;Define *w = Editor(0, 0, 0, 0, #__flag_autosize) 
    *g = Editor(0, 0, 306, 133, #__flag_autosize) 
    g=getgadget(root())
    
    ;     Gadget(g, 8, 133+5+8, 306, 133, #PB_Flag_GridLines|#PB_Flag_Numeric);#PB_Text_WordWrap|#PB_Flag_GridLines) 
    ;     *g._s_widget=GetGadgetData(g)
    
    SetText(*g, Text.s) 
    ;redraw(*g)
    For a = 0 To 2
      AddItem(*g, a, "Line "+Str(a))
    Next
    AddItem(*g, 7+a, "_")
    For a = 4 To 6
      AddItem(*g, a, "Line "+Str(a))
    Next
    ;SetFont(*g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E._s_widget = GetGadgetData(g)
                
                *E\Text\MultiLine !- 1
                If  *E\Text\MultiLine = 1
                  SetGadgetText(100,"~wrap")
                Else
                  SetGadgetText(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\Text\MultiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\Text\MultiLine = 1
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                    Else
                      EditorGadget(0, 8, 8, 306, 133) 
                    EndIf
                    
                    SetGadgetText(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8, 306, 276, 0,g)
                    
                    CompilerIf #PB_Compiler_Version =< 546
                      BindGadgetEvent(10, @SplitterCallBack())
                    CompilerEndIf
                    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                    
                    ; ;                     ImportC ""
                    ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                    ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                    ; ;                     EndImport
                    ; ;                     
                    ; ;                     Define TXNObject.i
                    ; ;                     Dim ControlTag.i(0)
                    ; ;                     Dim ControlData.i(0)
                    ; ;                     
                    ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                    ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                    ; ;                     
                    ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                    ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                    ; ;                     EndIf
                  CompilerCase #PB_OS_Windows
                    SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                CompilerEndSelect
                
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -----------------------------------------------------------------------------------------------P-+mfe--B3-v-P+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP