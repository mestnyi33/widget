
;-
DeclareModule Widget
  EnableExplicit
  ;-
  ;- - CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Drop
  EndEnumeration
  
  #Anchors = 9+4
  
  #Anchor_moved = 9
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version<547 : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 16
    #PB_Bar_Vertical
    
    ;#PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  ; coordinate widget
  #_c_0 = 0
  #_c_1 = 1 ; frame
  #_c_2 = 2 ; inner
  #_c_3 = 3 ; container
  #_c_4 = 4 ; clip  
  
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_Checkboxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
                                                              ;                                                             ; #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  EnumerationBinary WidgetFlags
    #PB_Center
    #PB_Right
    #PB_Left = 4
    #PB_Top
    #PB_Bottom
    #PB_Vertical 
    #PB_Horizontal
    #PB_Flag_AutoSize
    
    #PB_Toggle
    #PB_BorderLess
    
    #PB_Text_Numeric
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
    #PB_Text_InLine
    
    #PB_Flag_Double
    #PB_Flag_Flat
    #PB_Flag_Raised
    #PB_Flag_Single
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    #PB_Flag_AnchorsGadget
    
    ;#PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    #PB_Flag_NoGadget
    #PB_Flag_Limit
  EndEnumeration
  
  ;#PB_Bar_Vertical = #PB_Vertical
  #PB_AutoSize = #PB_Flag_AutoSize
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Hex(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Full = #PB_Left|#PB_Right|#PB_Top|#PB_Bottom
  #PB_Gadget_FrameColor = 10
  
  ; Set/Get Attribute
  #PB_DisplayMode = 1<<13
  #PB_Image = 1<<13
  #PB_Text = 1<<14
  #PB_Flag = 1<<15
  #PB_State = 1<<16
  
  
  #PB_DisplayMode_Default =- 1
  
  Enumeration
    #PB_DisplayMode_SmallIcon ;  = #PB_ListIcon_LargeIcon                 ; 0 0
    #PB_DisplayMode_LargeIcon ;  = #PB_ListIcon_SmallIcon                 ; 1 1
  EndEnumeration
  
  EnumerationBinary Attribute
    #PB_State_Selected        ; = #PB_Tree_Selected                       ; 1
    #PB_State_Expanded        ; = #PB_Tree_Expanded                       ; 2
    #PB_State_Checked         ; = #PB_Tree_Checked                        ; 4
    #PB_State_Collapsed       ; = #PB_Tree_Collapsed                      ; 8
    
    #PB_Image_Center
    #PB_Image_Mosaic
    #PB_S_imagetretch
    #PB_Image_Proportionally
    
    #PB_DisplayMode_AlwaysShowSelection                                    ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  EndEnumeration
  ;}
  
  Prototype pFunc(*this)
  Prototype fcallback()
  
  
  ;- - STRUCTUREs
  ;- - _S_event
  Structure _S_event
    *leave._S_widget  
    *enter._S_widget  
    *active._S_widget
    *widget._S_widget
    
    type.l
    item.l
    draw.b
    
    *callback.fcallback
    *data
  EndStructure
  
  ;- - _S_point
  Structure _S_point
    y.i
    x.i
  EndStructure
  
  ;- - _S_Coordinate
  Structure _S_coordinate Extends _S_point
    height.i
    width.i
  EndStructure
  
  ;- - _S_mouse
  Structure _S_mouse Extends _S_point
    buttons.i 
    delta._S_point
    wheel._S_point
  EndStructure
  
  ;- - _S_keyboard
  Structure _S_keyboard
    input.c
    key.i[2]
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._S_bar
    *second;._S_bar
    
    fixed.i[3]
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    interact.b
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_box
  Structure _S_box
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
    
    size.i[4]
    hide.b[4]
    checked.b[2] 
    ;toggle.b
    
    arrow_size.a[3]
    arrow_type.b[3]
    
    threeState.b
    *color._S_color[4]
  EndStructure
  
  ;- - _S_Color
  Structure _S_color
    state.b ; entered; selected; focused; lostfocused
    front.i[4]
    line.i[4]
    fore.i[4]
    back.i[4]
    frame.i[4]
    alpha.a[2]
  EndStructure
  
  ;- - _S_anchor
  Structure _S_anchor Extends _S_coordinate
    delta_x.i
    delta_y.i
    
    class.s
    hide.i
    pos.i ; anchor position on the widget
    state.b ; mouse state 
    cursor.i[2]
    
    *widget._S_widget
    color._S_color[4]
  EndStructure
  
  ;- - _S_Page
  Structure _S_page
    pos.i
    len.i
    *end
  EndStructure
  
  ;- - _S_Align
  Structure _S_align Extends _S_point
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
  EndStructure
  
  ;- - _S_WindowFlag
  Structure _S_windowFlag
    SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
    MinimizeGadget.b ; 13238272   - #PB_Window_MinimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    MaximizeGadget.b ; 13172736   - #PB_Window_MaximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
    Invisible.b      ; 268435456  - #PB_Window_Invisible       ; creates the Window but don't display.
    TitleBar.b       ; 12582912   - #PB_Window_TitleBar        ; creates a Window With a titlebar.
    Tool.b           ; 4          - #PB_Window_Tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
    BorderLess.b     ; 2147483648 - #PB_Window_BorderLess      ; creates a Window without any borders.
    ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
    WindowCentered.b ; 2          - #PB_Window_WindowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
                     ;                X,Y parameters are ignored.
    Maximize.b       ; 16777216   - #PB_Window_Maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
    Minimize.b       ; 536870912  - #PB_Window_Minimize        ; Opens the Window minimized.
    NoGadgets.b      ; 8          - #PB_Window_NoGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    NoActivate.b     ; 33554432   - #PB_Window_NoActivate      ; Don't activate the window after opening.
  EndStructure
  
  ;- - _S_Flag
  Structure _S_flag
    Window._S_windowFlag
    InLine.b
    ;     Lines.b
    ;     Buttons.b
    ;     GridLines.b
    ;     Checkboxes.b
    FullSelection.b
    ;     AlwaysSelection.b
    ;     MultiSelect.b
    ;     ClickSelect.b
    ;     optiongroup.l
    
    lines.b
    buttons.b
    gridlines.b
    checkboxes.b
    optiongroup.b
    threestate.b
    collapse.b
    alwaysselection.b
    multiselect.b
    clickselect.b
    iconsize.b
  EndStructure
  
  ;- - _S_padding
  Structure _S_padding
    left.l
    top.l
    right.l
    bottom.l
  EndStructure
  
  ;- - _S_Image
  Structure _S_image
    index.l
    handle.i
    
    y.i[3]
    x.i[3]
    height.i
    width.i
    
    imageID.i[2] ; - editor
    change.b
    
    padding._S_padding
    align._S_align
  EndStructure
  
  ;- - _S_Text
  Structure _S_text 
    y.i[3]
    x.i[3]
    height.i[2]
    width.i[2]
    
    big.i[3]
    pos.i
    len.i
    caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    fontID.i
    string.s[3]
    change.b
    
    lower.b
    upper.b
    pass.b
    editable.b
    numeric.b
    multiLine.b
    vertical.b
    rotate.f
    
    padding._S_padding
    align._S_align
  EndStructure
  
  ;- - _S_Scroll
  Structure _S_scroll
    y.i
    x.i
    height.i[4] ; - EditorGadget
    width.i[4]
    
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;- - _S_line
  Structure _S_line
    v._S_coordinate
    h._S_coordinate
  EndStructure
  
  ;- - _S_tt
  Structure _S_tt Extends _S_coordinate
    window.i
    gadget.i
    
    visible.b
    
    text._S_text
    image._S_image
    color._S_color
  EndStructure
  
  ;- - _S_Items
  Structure _S_items Extends _S_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    drawing.i
    
    image._S_image
    text._S_text[4]
    *box._S_box
    *i_parent._S_items
    
    state.b
    hide.b[2]
    caret.i[3]  ; 0 = Pos ; 1 = PosFixed
    vertical.b
    radius.a
    
    change.b
    sublevel.i
    sublevellen.i
    
    childrens.i
    *data      ; set/get item data
  EndStructure
  
  ;- - _S_rows
  Structure _S_rows Extends _S_coordinate
    index.l  ; Index of new list element
    handle.i ; Adress of new list element
    
    draw.b
    hide.b
    radius.a
    sublevel.l
    childrens.l
    sublength.l
    
    ;Font._S_font
    fontID.i
    len.l
    *optiongroup._S_rows
    
    text._S_text
    color._S_color
    image._S_image
    box._S_box[2]
    l._S_line ; 
    
    *last._S_rows
    *first._S_rows
    *parent._S_rows
    
    *data      ; set/get item data
  EndStructure
  
  ;- - _S_row
  Structure _S_row 
    index.l
    ;handle.i
    
    box.b
    draw.l
    drag.b
    ;resize.l
    
    count.l
    FontID.i
    scrolled.b
    
    *tt._S_tt
    
    sublevel.l
    sublength.l
    
    ;Font._S_font
    
    *first._S_rows
    *selected._S_rows
  EndStructure
  
  ;- - _S_Popup
  Structure _S_popup
    gadget.i
    window.i
    
    ; *Widget._S_widget
  EndStructure
  
  ;- - _S_Margin
  Structure _S_margin
    FonyID.i
    Width.i
    Color._S_color
  EndStructure
  
  ;- - _S_canvas
  Structure _S_canvas
    window.i
    gadget.i
    ; widget.i
    
    input.c
    key.i[2]
    mouse._S_mouse
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget 
    index_.l
    handle.i
    
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
    
    *event._S_event 
    *splitter._S_splitter
    
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *parent._S_widget ; adress parent
    *scroll._S_scroll 
    ;     *first._S_widget
    ;     *second._S_widget
    
    mode.b  ; track bar
    
    from.i
    type.b[3] ; [2] for splitter
    radius.a
    cursor.i[2]
    
    
    hide.b[2]
    *box._S_box
    
    focus.b
    change.i[2]
    resize.b
    vertical.b
    inverted.b
    direction.i
    scrollstep.i
    
    max.i
    min.i
    page._S_page
    area._S_page
    thumb._S_page
    button._S_button[4]
    
    color._S_color[4]
    
    type_index.l
    type_count.l
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    parent_item.i ; index parent tab item
    *i_Parent._S_items
    *data
    
    *Deactive._S_widget
    *Leave._S_widget
    
    *Popup._S_widget
    *OptionGroup._S_widget
    
    fs.i 
    bs.i
    Grid.i
    Enumerate.i
    TabHeight.i
    
    Level.i ; Вложенность виджета
    Class.s ; 
    
    List *childrens._S_widget()
    List *items._S_items()
    List *columns._S_widget()
    ;List *draws._S_items()
    Map *Count()
    
    Flag._S_flag
    *Text._S_text[4]
    *Image._S_image[2]
    *Align._S_align
    
    ;*Function[4] ; IsFunction *Function=0 >> Gadget *Function=1 >> Window *Function=2 >> Root *Function=3
    sublevellen.i
    Drag.i[2]
    Attribute.i
    
    Mouse._S_mouse
    Keyboard._S_keyboard
    
    margin._S_margin
    create.b
    
    ; event.i
    ;message.i
    repaint.i
    *anchor._S_anchor[#Anchors+1]
    *selector._S_anchor[#Anchors+1]
    
    ; new
    row._S_row
    List *draws._S_rows()
    List rows._S_rows()
  EndStructure
  
  ;- - _S_parent
  Structure _S_parent
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
    
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *scroll._S_scroll 
    
    type.b[3] ; [2] for splitter
    
    hide.b[2]
    
    change.i[2]
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    
    CountItems.i[2]
    
    parent_item.i ; index parent tab item
    
    fs.i 
    bs.i
    Grid.i
    TabHeight.i
    
    List *childrens._S_widget()
  EndStructure
  
  ;- - _S_root
  Structure _S_root Extends _S_widget
    canvas._S_canvas
  EndStructure
  
  ;- - _S_value
  Structure _S_value
    event._S_event
    
    *root._S_root
    *last._S_widget
    *active._S_widget
    *focus._S_widget
    
    List *openedList._S_widget()
  EndStructure
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *Value._S_value = AllocateStructure(_S_value)
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    *Value\root
  EndMacro
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root)
  EndMacro
  
  
  ;   Macro IsBar(_this_)
  ;     Bool(_this_ And (_this_\type = #PB_GadgetType_ScrollBar Or _this_\type = #PB_GadgetType_TrackBar Or _this_\type = #PB_GadgetType_ProgressBar Or _this_\type = #PB_GadgetType_Splitter))
  ;   EndMacro
  
  Macro IsWidget(_this_)
    Bool(_this_>Root() And _this_<AllocateStructure(_S_widget)) * _this_ ; Bool(MemorySize(_this_)=MemorySize(AllocateStructure(_S_widget))) * _this_
  EndMacro
  
  Macro IsChildrens(_this_)
    ListSize(_this_\childrens())
  EndMacro
  
  ;   Define w  ;TypeOf(_this_)  ; 
  ;   Define *w._S_widget=AllocateStructure(_S_widget)
  ;   Define *w1._S_widget=AllocateStructure(_S_widget)
  ;   Debug ""+*w+" "+*w1+" "+MemorySize(*w)+" "+MemorySize(*w1)
  ;   Debug MemorySize(AllocateStructure(_S_widget))
  ;   Debug *value\this
  ;   Debug IsWidget(345345345999)
  
  
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
  
  ; Then scroll bar start position
  Macro _scroll_in_start_(_this_) : Bool(_this_\page\pos =< _this_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _scroll_in_stop_(_this_) : Bool(_this_\page\pos >= (_this_\max-_this_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.i Resize(*this, iX.i,iY.i,iWidth.i,iHeight.i);, *That=#Null)
  Declare.i SetData(*this, *Data)
  Declare.i ReDraw(*this=#Null)
  Declare.i Container(index.l, X.i,Y.i,Width.i,Height.i, Flag.i=0)
  
  Declare.i CloseList()
  Declare.i OpenList(*this, Item.i=0, Type=-5)
  Declare.i SetParent(*this, *Parent, parent_item.i=-1)
  
  Declare.i Open(Window.i, X.i,Y.i,Width.i,Height.i, Text.s="", Flag.i=0, WindowID.i=0)
  Declare.i Post(EventType.i, *this, EventItem.i=#PB_All, *Data=0)
  Declare.i Bind(*callback, *this=#PB_All, EventType.i=#PB_All)
  ;   Declare.i Unbind(*callback, *this=#PB_All, EventType.i=#PB_All)
  Declare.l CallBack(*this._S_widget, EventType.l, mouse_x.l, mouse_y.l)
EndDeclareModule

Module Widget
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _multi_select_(_this_,  _index_, _selected_index_)
    PushListPosition(_this_\rows()) 
    ForEach _this_\rows()
      If _this_\rows()\draw
        _this_\rows()\color\state =  Bool((_selected_index_ >= _this_\rows()\index And _index_ =< _this_\rows()\index) Or ; верх
                                          (_selected_index_ =< _this_\rows()\index And _index_ >= _this_\rows()\index)) * 2  ; вниз
      EndIf
    Next
    PopListPosition(_this_\rows()) 
    
    ;     PushListPosition(_this_\draws()) 
    ;     ForEach _this_\draws()
    ;       If _this_\draws()\draw
    ;         _this_\draws()\color\state =  Bool((_selected_index_ >= _this_\draws()\index And _index_ =< _this_\draws()\index) Or ; верх
    ;                                            (_selected_index_ =< _this_\draws()\index And _index_ >= _this_\draws()\index)) * 2  ; вниз
    ;       EndIf
    ;     Next
    ;     PopListPosition(_this_\draws()) 
  EndMacro
  
  Macro _set_item_image_(_this_, _item_, _image_)
    _item_\image\change = IsImage(_image_)
    
    If _item_\image\change
      If _this_\flag\iconsize
        _item_\image\width = _this_\flag\iconsize
        _item_\image\height = _this_\flag\iconsize
        ResizeImage(_image_, _item_\image\width, _item_\image\height)
        
      Else
        _item_\image\width = ImageWidth(_image_)
        _item_\image\height = ImageHeight(_image_)
        
      EndIf  
      
      _item_\image\index = _image_ 
      _item_\image\handle = ImageID(_image_)
      _this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    Else
      _item_\image\index =- 1
    EndIf
  EndMacro
  
  Macro _set_active_(_this_)
    If *value\event\active <> _this_
      If *value\event\active 
        *value\event\active\color\state = 0
        *value\event\active\mouse\buttons = 0
        
        If *value\event\active\row\selected 
          *value\event\active\row\selected\color\state = 3
        EndIf
        
        If _this_\root\canvas\gadget <> *value\event\active\root\canvas\gadget 
          ; set lost focus canvas
          PostEvent(#PB_Event_Gadget, *value\event\active\root\canvas\window, *value\event\active\root\canvas\gadget, #PB_EventType_Repaint);, *value\event\active)
        EndIf
        
        Result | Events(*value\event\active, #PB_EventType_LostFocus, mouse_x, mouse_y)
      EndIf
      
      If _this_\row\selected And _this_\row\selected\color\state = 3
        _this_\row\selected\color\state = 2
      EndIf
      
      _this_\color\state = 2
      *value\event\active = _this_
      Result | Events(_this_, #PB_EventType_Focus, mouse_x, mouse_y)
    EndIf
  EndMacro
  
  Macro _set_state_(_this_, _items_, _state_)
    
    If _this_\flag\optiongroup And _items_\parent
      If _items_\optiongroup\optiongroup <> _items_
        If _items_\optiongroup\optiongroup
          _items_\optiongroup\optiongroup\box[1]\checked = 0
        EndIf
        _items_\optiongroup\optiongroup = _items_
      EndIf
      
      _items_\box[1]\checked ! Bool(_state_)
      
    Else
      If _this_\flag\threestate
        If _state_ & #PB_Tree_Inbetween
          _items_\box[1]\checked = 2
        ElseIf _state_ & #PB_Tree_Checked
          _items_\box[1]\checked = 1
        Else
          Select _items_\box[1]\checked 
            Case 0
              _items_\box[1]\checked = 2
            Case 1
              _items_\box[1]\checked = 0
            Case 2
              _items_\box[1]\checked = 1
          EndSelect
        EndIf
      Else
        _items_\box[1]\checked ! Bool(_state_)
      EndIf
    EndIf
    
  EndMacro
  
  Macro _repaint_(_this_)
    If _this_\row\count = 0 Or 
       (Not _this_\hide And _this_\row\draw And 
        (_this_\row\count % _this_\row\draw) = 0)
      
      _this_\change = 1
      _this_\row\draw = _this_\row\count
      PostEvent(#PB_Event_Gadget, _this_\root\canvas\window, _this_\root\canvas\gadget, #PB_EventType_Repaint, _this_)
    EndIf  
  EndMacro
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If Value>Max 
        Value=Max 
      EndIf
    EndIf
    
    ProcedureReturn Value
    ;   Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ;     ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_Round_Nearest) * Grid)))
  EndProcedure
  
  ;- MODULE
  ;
  Declare.i g_CallBack()
  ;Declare.i Event_Widgets(*this, EventType.i, EventItem.i=-1, EventData.i=0)
  ;Declare.i Events(*this, at.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i = 0)
  
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
  
  Macro _set_def_colors_(_this_)
    ;*value\event\widget = _this_
    _this_\scrollstep = 1
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\color[#_b_1] = def_colors
    _this_\color[#_b_2] = def_colors
    _this_\color[#_b_3] = def_colors
  EndMacro
  
  
  ;- MACOS
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
    
    Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        CocoaMessage(@alpha, nscolorspace, "alphaComponent")
        rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
        ProcedureReturn rgba
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
        ProcedureReturn rgb
      EndIf
    EndProcedure
    
  CompilerEndIf
  
  ;-
  
  Macro Set_Cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_Cursor(_this_)
    GetGadgetAttribute(_this_\root\canvas, #PB_Canvas_Cursor)
  EndMacro
  
  
  ; SCROLLBAR
  Macro _thumb_len_(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    ;     If _this_\thumb\len > _this_\area\len 
    ;       _this_\thumb\len = _this_\area\len 
    ;     EndIf 
    
    If _this_\box 
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\height[3] = _this_\thumb\len 
      Else 
        _this_\box\width[3] = _this_\thumb\len 
      EndIf
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
        If _this_\color[#_b_1]\state <> #Selected
          _this_\color[#_b_1]\state = #Normal
        EndIf
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
      ; Debug ""+ Bool(_this_\thumb\pos = _this_\area\end) +" "+ Bool(_scroll_pos_ = _this_\page\end)
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_b_2]\state = #Disabled
        _this_\button[#_b_2]\interact = 0
      Else
        If _this_\color[#_b_2]\state <> #Selected
          _this_\color[#_b_2]\state = #Normal
        EndIf
        _this_\button[#_b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type = #PB_GadgetType_ScrollBar
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
  
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\thumb\pos-_this_\y)
      Resize(_this_\splitter\second, 0, (_this_\thumb\pos+_this_\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\thumb\pos+_this_\thumb\len)-_this_\y))
    Else
      Resize(_this_\splitter\first, 0, 0, _this_\thumb\pos-_this_\x, _this_\height)
      Resize(_this_\splitter\second, (_this_\thumb\pos+_this_\thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  
  Procedure.b splitter_size(*this._S_widget)
  EndProcedure
  
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
  
  
  Procedure.i SetPos_Bar(*this._S_widget, ThumbPos.i)
    
  EndProcedure
  
  Procedure.b SetState_Bar(*this._S_widget, ScrollPos.l)
    
  EndProcedure
  
  Procedure.l SetAttribute_Bar(*this._S_widget, Attribute.l, Value.l)
    
  EndProcedure
  
  Procedure.b Resizes_Bar(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    
  EndProcedure
  
  
  
  ;-
  ;- DRAWPOPUP
  ;-
  ;-
  Procedure.s Class(Type.i)
    Protected Result.s
    
    Select Type
      Case #PB_GadgetType_Button         : Result = "Button"
      Case #PB_GadgetType_ButtonImage    : Result = "ButtonImage"
      Case #PB_GadgetType_Calendar       : Result = "Calendar"
      Case #PB_GadgetType_Canvas         : Result = "Canvas"
      Case #PB_GadgetType_CheckBox       : Result = "Checkbox"
      Case #PB_GadgetType_ComboBox       : Result = "Combobox"
      Case #PB_GadgetType_Container      : Result = "Container"
      Case #PB_GadgetType_Date           : Result = "Date"
      Case #PB_GadgetType_Editor         : Result = "Editor"
      Case #PB_GadgetType_ExplorerCombo  : Result = "ExplorerCombo"
      Case #PB_GadgetType_ExplorerList   : Result = "ExplorerList"
      Case #PB_GadgetType_ExplorerTree   : Result = "ExplorerTree"
      Case #PB_GadgetType_Frame          : Result = "Frame"
      Case #PB_GadgetType_HyperLink      : Result = "HyperLink"
      Case #PB_GadgetType_Image          : Result = "Image"
      Case #PB_GadgetType_IPAddress      : Result = "IPAddress"
      Case #PB_GadgetType_ListIcon       : Result = "ListIcon"
      Case #PB_GadgetType_ListView       : Result = "ListView"
      Case #PB_GadgetType_MDI            : Result = "MDI"
      Case #PB_GadgetType_OpenGL         : Result = "OpenGL"
      Case #PB_GadgetType_Option         : Result = "Option"
      Case #PB_GadgetType_Popup          : Result = "Popup"
      Case #PB_GadgetType_Panel          : Result = "Panel"
      Case #PB_GadgetType_Property       : Result = "Property"
      Case #PB_GadgetType_ProgressBar    : Result = "ProgressBar"
      Case #PB_GadgetType_Scintilla      : Result = "Scintilla"
      Case #PB_GadgetType_ScrollArea     : Result = "ScrollArea"
      Case #PB_GadgetType_ScrollBar      : Result = "ScrollBar"
      Case #PB_GadgetType_Shortcut       : Result = "Shortcut"
      Case #PB_GadgetType_Spin           : Result = "Spin"
      Case #PB_GadgetType_Splitter       : Result = "Splitter"
      Case #PB_GadgetType_String         : Result = "String"
      Case #PB_GadgetType_Text           : Result = "Text"
      Case #PB_GadgetType_TrackBar       : Result = "TrackBar"
      Case #PB_GadgetType_Tree           : Result = "Tree"
      Case #PB_GadgetType_Unknown        : Result = "Unknown"
      Case #PB_GadgetType_Web            : Result = "Web"
      Case #PB_GadgetType_Window         : Result = "Window"
      Case #PB_GadgetType_Root           : Result = "Root"
    EndSelect
    
    ProcedureReturn Result.s
  EndProcedure
  
  Procedure.i ClassType(Class.s)
    Protected Result.i
    
    Select Trim(Class.s)
      Case "Button"         : Result = #PB_GadgetType_Button
      Case "ButtonImage"    : Result = #PB_GadgetType_ButtonImage
      Case "Calendar"       : Result = #PB_GadgetType_Calendar
      Case "Canvas"         : Result = #PB_GadgetType_Canvas
      Case "Checkbox"       : Result = #PB_GadgetType_CheckBox
      Case "Combobox"       : Result = #PB_GadgetType_ComboBox
      Case "Container"      : Result = #PB_GadgetType_Container
      Case "Date"           : Result = #PB_GadgetType_Date
      Case "Editor"         : Result = #PB_GadgetType_Editor
      Case "ExplorerCombo"  : Result = #PB_GadgetType_ExplorerCombo
      Case "ExplorerList"   : Result = #PB_GadgetType_ExplorerList
      Case "ExplorerTree"   : Result = #PB_GadgetType_ExplorerTree
      Case "Frame"          : Result = #PB_GadgetType_Frame
      Case "HyperLink"      : Result = #PB_GadgetType_HyperLink
      Case "Image"          : Result = #PB_GadgetType_Image
      Case "IPAddress"      : Result = #PB_GadgetType_IPAddress
      Case "ListIcon"       : Result = #PB_GadgetType_ListIcon
      Case "ListView"       : Result = #PB_GadgetType_ListView
      Case "MDI"            : Result = #PB_GadgetType_MDI
      Case "OpenGL"         : Result = #PB_GadgetType_OpenGL
      Case "Option"         : Result = #PB_GadgetType_Option
      Case "Popup"          : Result = #PB_GadgetType_Popup
      Case "Panel"          : Result = #PB_GadgetType_Panel
      Case "Property"       : Result = #PB_GadgetType_Property
      Case "ProgressBar"    : Result = #PB_GadgetType_ProgressBar
      Case "Scintilla"      : Result = #PB_GadgetType_Scintilla
      Case "ScrollArea"     : Result = #PB_GadgetType_ScrollArea
      Case "ScrollBar"      : Result = #PB_GadgetType_ScrollBar
      Case "Shortcut"       : Result = #PB_GadgetType_Shortcut
      Case "Spin"           : Result = #PB_GadgetType_Spin
      Case "Splitter"       : Result = #PB_GadgetType_Splitter
      Case "String"         : Result = #PB_GadgetType_String
      Case "Text"           : Result = #PB_GadgetType_Text
      Case "TrackBar"       : Result = #PB_GadgetType_TrackBar
      Case "Tree"           : Result = #PB_GadgetType_Tree
      Case "Unknown"        : Result = #PB_GadgetType_Unknown
      Case "Web"            : Result = #PB_GadgetType_Web
      Case "Window"         : Result = #PB_GadgetType_Window
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Style.b = 1, Length.i = 1)
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
      If Style > 0 : x-1 : y+1
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
  
  ;   Procedure Init_Event( *this._S_widget)
  ;     If *this
  ;       With *this
  ;         If ListSize(\childrens())
  ;           ForEach \childrens()
  ;             If \childrens()\deactive
  ;               If \childrens()\deactive <> \childrens()
  ;                 ; Events(\childrens()\deactive, \childrens()\deactive\from, #PB_EventType_LostFocus, 0, 0)
  ;               EndIf
  ;               
  ;               ;Events(\childrens(), \childrens()\from, #PB_EventType_Focus, 0, 0)
  ;               \childrens()\deactive = 0
  ;             EndIf
  ;             
  ;             If ListSize(\childrens()\childrens())
  ;               Init_Event(\childrens())
  ;             EndIf
  ;           Next
  ;         EndIf
  ;       EndWith
  ;     EndIf
  ;   EndProcedure
  
  
  ; SET_
  Procedure.i Post(EventType.i, *this._S_widget, EventItem.i=#PB_All, *Data=0)
    Protected result.i
    
    *Value\event\widget = *this
    *Value\event\type = eventtype
    *Value\event\data = *data
    
    If *this\event And
       (*this\event\type = #PB_All Or
        *this\event\type = eventtype)
      
      result = *this\event\callback()
    EndIf
    
    If result <> #PB_Ignore And 
       *this\window <> *this And 
       *this\root <> *this\window And 
       *this\window\event And 
       (*this\window\event\type = #PB_All Or
        *this\window\event\type = eventtype)
      
      result = *this\window\event\callback()
    EndIf
    
    If result <> #PB_Ignore And
       Root()\event And 
       (Root()\event\type = #PB_All Or 
        Root()\event\type = eventtype) 
      
      result = Root()\event\callback()
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Bind(*callback, *this._S_widget=#PB_All, EventType.i=#PB_All)
    Protected Repaint.i
    
    If *this = #PB_All
      *this = Root()
    EndIf
    
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callback
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Unbind(*callback, *this._S_widget=#PB_All, EventType.i=#PB_All)
    Protected Repaint.i
    
    *this\event\type = 0
    *this\event\callback = 0
    FreeStructure(*this\event)
    *this\event = 0
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  ;- DRAWING
  Procedure.i Draw_Box(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  ;-
  Procedure.b Draw_Scroll(*this._S_widget)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x,\y,\width,\height,\radius,\radius,\color\back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\color[3]\fore[\color[3]\state],\color[3]\back[\color[3]\state], \radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\radius,\radius,\color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2-3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2+3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2-3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2+3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\color[#_b_1]\fore[\color[#_b_1]\state],\color[#_b_1]\back[\color[#_b_1]\state], \radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\color[#_b_2]\fore[\color[#_b_2]\state],\color[#_b_2]\back[\color[#_b_2]\state], \radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\radius,\radius,\color[#_b_1]\frame[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\radius,\radius,\color[#_b_2]\frame[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_1]\x+(\button[#_b_1]\width-\button[#_b_1]\arrow_size)/2,\button[#_b_1]\y+(\button[#_b_1]\height-\button[#_b_1]\arrow_size)/2, \button[#_b_1]\arrow_size, Bool(\Vertical), \color[#_b_1]\front[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_1]\arrow_type)
          Arrow(\button[#_b_2]\x+(\button[#_b_2]\width-\button[#_b_2]\arrow_size)/2,\button[#_b_2]\y+(\button[#_b_2]\height-\button[#_b_2]\arrow_size)/2, \button[#_b_2]\arrow_size, Bool(\Vertical)+2, \color[#_b_2]\front[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw(*this._S_widget, Childrens=0)
    Protected parent_item.i
    
    With *this
      If \root And \root\create And Not \create 
        ;         If Not IsRoot(*this)
        ;           \function[2] = Bool(\window And \window\function[1] And \window<>\root And \window<>*this) * \window\function[1]
        ;           \function[3] = Bool(\root And \root\function[1]) * \root\function[1]
        ;         EndIf
        ;         \function = Bool(\function[1] Or \function[2] Or \function[3])
        
        ;  Event_Widgets(*this, #PB_EventType_create, - 1)
        
        \create = 1
      EndIf
      
      ; Get text size
      If (\text And \text\change)
        \text\width = TextWidth(\text\string.s[1])
        \text\height = TextHeight("A")
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4])
        
        ; Demo default coordinate
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x,\y,\width,\height, \color\back)
        
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\x+2, \y, Str(\index), $FF000000)
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
        
        ; Draw Childrens
        If Childrens And ListSize(\childrens())
          ; Only selected item widgets draw
          parent_item = Bool(\type = #PB_GadgetType_Panel) * \index[2]
          LastElement(\childrens())         ; Что бы начать с последнего элемента
          Repeat                            ; Перебираем с низу верх
                                            ;ForEach \childrens() 
                                            ;If Not Send(\childrens(), #PB_EventType_Repaint)
            
            If \childrens()\width[#_c_4] > 0 And 
               \childrens()\height[#_c_4] > 0 And 
               \childrens()\parent_item = parent_item
              Draw(\childrens(), Childrens) 
            EndIf
            
            ;EndIf
            
            
          Until PreviousElement(\childrens()) = #False 
          ; Next
        EndIf
        
        If \width[#_c_4] > 0 And \height[#_c_4] > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x[#_c_4],\y[#_c_4],\width[#_c_4],\height[#_c_4], $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $F00F00)
        EndIf
        
        UnclipOutput()
        
      EndIf
      
      ; reset 
      \change = 0
      \resize = 0
      If \text
        \text\change = 0
      EndIf
      If \Image
        \image\change = 0
      EndIf
      
      ; *Value\type =- 1 
      ; *Value\this = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      ;       Init_Event(*this)
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        ;DrawingMode(#PB_2DDrawing_Default)
        ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        Draw(*this, 1)
        
        
        ;       ; Selector
        ;         If \root\anchor 
        ;           box(\root\anchor\x, \root\anchor\y, \root\anchor\width, \root\anchor\height ,\root\anchor\color[\root\anchor\state]\frame) 
        ;         EndIf
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  ;-
  ;- ADD & GET & SET
  ;-
  Procedure.i X(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\x[Mode]
  EndProcedure
  
  Procedure.i Y(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\y[Mode]
  EndProcedure
  
  Procedure.i Width(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\width[Mode]
  EndProcedure
  
  Procedure.i Height(*this._S_widget, Mode.i=0)
    ProcedureReturn *this\height[Mode]
  EndProcedure
  
  Procedure.i CountItems(*this._S_widget)
    ProcedureReturn *this\countItems
  EndProcedure
  
  Procedure.i Hides(*this._S_widget, State.i)
    With *this
      If State
        \hide = 1
      Else
        \hide = \hide[1]
        If \scroll And \scroll\v And \scroll\h
          \scroll\v\hide = \scroll\v\hide[1]
          \scroll\h\hide = \scroll\h\hide[1]
        EndIf
      EndIf
      
      If ListSize(\childrens())
        ForEach \childrens()
          Hides(\childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Hide(*this._S_widget, State.i=-1)
    With *this
      If State.i=-1
        ProcedureReturn \hide 
      Else
        \hide = State
        \hide[1] = \hide
        
        If ListSize(\childrens())
          ForEach \childrens()
            Hides(\childrens(), State)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Enumerate(*this.Integer, *Parent._S_widget, parent_item.i=0)
    Protected Result.i
    
    With *Parent
      If Not *this
        ;  ProcedureReturn 0
      EndIf
      
      If Not \Enumerate
        Result = FirstElement(\childrens())
      Else
        Result = NextElement(\childrens())
      EndIf
      
      \Enumerate = Result
      
      If Result
        If \childrens()\parent_item <> parent_item 
          ProcedureReturn Enumerate(*this, *Parent, parent_item)
        EndIf
        
        ;         If ListSize(\childrens()\childrens())
        ;           ProcedureReturn Enumerate(*this, \childrens(), Item)
        ;         EndIf
        
        PokeI(*this, PeekI(@\childrens()))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.i SetParent(*this._S_widget, *Parent._S_widget, parent_item.i=-1)
    Protected x.i,y.i, *LastParent._S_widget
    
    With *this
      If *this > 0 
        If parent_item =- 1
          parent_item = *Parent\index[2]
        EndIf
        
        If *Parent <> \parent Or \parent_item <> parent_item
          x = \x[#_c_3]
          y = \y[#_c_3]
          
          If \parent And ListSize(\parent\childrens())
            ChangeCurrentElement(\parent\childrens(),*this\adress) 
            DeleteElement(\parent\childrens())
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \parent_item = parent_item
          \Parent = *Parent
          \root = \parent\root
          
          \root\countItems + 1 
          If \parent <> \root
            \parent\countItems + 1 
            \Level = \parent\Level + 1
            \Window = \parent\Window
          Else
            \Window = \parent
          EndIf
          
          ; Add new children 
          If \index < 0 Or \index > ListSize(\parent\childrens()) - 1
            LastElement(\parent\childrens())
            \adress = AddElement(\parent\childrens()) 
            \index = ListIndex(\parent\childrens())
          Else
            SelectElement(\parent\childrens(), \index)
           \adress = InsertElement(\parent\childrens())
          EndIf
          
          If \adress
            \parent\childrens() = *this 
            \index_ = \root\CountItems
          EndIf
          
          ; Make count type
          If \Window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\Type))
            typecount(Hex(\window)+"_"+Hex(\Type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\Type))
            typecount(Hex(\parent)+"__"+Hex(\Type)) + 1
          EndIf
          
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \Hide = Bool(\Parent\Hide Or \parent_item <> \Parent\index[#Selected])
          
          If \Scroll
            If \Scroll\v
              \Scroll\v\Window = \Window
            EndIf
            If \Scroll\h
              \Scroll\h\Window = \Window
            EndIf
          EndIf
          
          If \Parent\Scroll
            x-\Parent\Scroll\h\Page\Pos
            y-\Parent\Scroll\v\Page\Pos
          EndIf
          
          ;
          Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
          
          If *LastParent
            ;             Debug ""+*root\width+" "+*LastParent\root\width+" "+*Parent\root\width 
            ;             Debug "From ("+ Class(*LastParent\type) +") to (" + Class(*Parent\type) +") - SetParent()"
            
            If *LastParent <> *Parent
              Select Root() 
                Case *Parent\root     : ReDraw(*Parent)
                Case *LastParent\root : ReDraw(*LastParent)
              EndSelect
            EndIf
            
          EndIf
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetPosition(*this._S_widget, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
    With *this
      If IsRoot(*this)
        ProcedureReturn
      EndIf
      
      If \parent
        ;
        If (\type = #PB_GadgetType_ScrollBar And \parent\type = #PB_GadgetType_ScrollArea) Or
           \parent\type = #PB_GadgetType_Splitter
          *this = \parent
        EndIf
        
        ChangeCurrentElement(\parent\childrens(), *this\adress)
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\parent\childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\parent\childrens()) : MoveElement(\parent\childrens(), #PB_List_After, \parent\childrens()\Adress)
            Case #PB_List_After  : NextElement(\parent\childrens())     : MoveElement(\parent\childrens(), #PB_List_Before, \parent\childrens()\Adress)
            Case #PB_List_Last   : MoveElement(\parent\childrens(), #PB_List_Last)
          EndSelect
          
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\parent\childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\parent\childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
        ; \parent\childrens()\adress = @\parent\childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  Procedure.i SetFocus(*this._S_widget, State.i)
    With *this
      
      If State =- 1
        If *this And *Value\focus <> *this ;And (\type <> #PB_GadgetType_Window)
          If *Value\focus 
            \deactive = *Value\focus 
            ;*Value\focus\root\anchor = 0 
            *Value\focus\focus = 0
          EndIf
          If Not \deactive 
            \deactive = *this 
          EndIf
          ;\root\anchor = \root\anchor[#Anchor_moved]
          *Value\focus = *this
          \focus = 1
        EndIf
      Else
        \focus = State
        ;\root\anchor = Bool(State) * \root\anchor[#Anchor_moved]
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetActive(*this._S_widget)
    ; Возвращаемые значения
    ; Если функция завершается успешно, 
    ; возвращаемое значения - дескриптор 
    ; последнего активного окна.
    Protected Result.i
    
    With *this
      ;       If \root\anchor[#Anchor_moved] And Not \root\anchor
      ;         Event_Widgets(*this, #PB_EventType_Change, \root\anchor)
      ;       EndIf
      
      If *this And \root And \root\type = #PB_GadgetType_Window
        \root\focus = 1
      EndIf
      
      If \window And *Value\active <> \window                                     And \window<>Root() And Not \root\anchor[#Anchor_moved]
        If *Value\active                                                          And *Value\active<>Root()
          \window\deactive = *Value\active 
          *Value\active\focus = 0
        EndIf
        If Not \window\deactive 
          \window\deactive = \window 
        EndIf
        
        If *Value\focus ; Если деактивировали окно то деактивируем и гаджет
          If *Value\focus\window = \window\deactive
            *Value\focus\focus = 0
          ElseIf *Value\focus\window = \window
            *Value\focus\focus = 1
          EndIf
        EndIf
        
        Result = \window\deactive
        *Value\active = \window
        \window\focus = 1
      EndIf
      
      If *this And *Value\focus <> *this And (\type <> #PB_GadgetType_Window Or \root\anchor[#Anchor_moved])
        If *Value\focus
          \deactive = *Value\focus 
          *Value\focus\focus = 0
        EndIf
        
        If Not \deactive 
          \deactive = *this 
        EndIf
        
        *Value\focus = *this
        \focus = 1
      EndIf
      
      If \window
        If \window\root
          PostEvent(#PB_Event_Gadget, \window\root\canvas\window, \window\root\canvas, #PB_EventType_Repaint)
        EndIf
        If \window\deactive And \window<>\window\deactive
          PostEvent(#PB_Event_Gadget, \window\deactive\root\canvas\window, \window\deactive\root\canvas, #PB_EventType_Repaint)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetForeground(*this._S_widget)
    Protected repaint
    
    With *this
      ; SetActiveGadget(\root\canvas)
      SetPosition(\window, #PB_List_Last)
      SetActive(*this)
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i SetData(*this._S_widget, *Data)
    Protected Result.i
    
    With *this
      \data = *Data
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  ;- CHANGE
  Procedure.i Resize(*this._S_widget, X.i,Y.i,Width.i,Height.i)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #PB_Flag_AutoSize
        If \parent And \parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\x
          Y = 0; \align\y
          Width = \parent\width[#_c_2] ; - \align\x
          Height = \parent\height[#_c_2] ; - \align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \parent : \x[#_c_3] = X : X+\parent\x+\parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[#_c_2] = \x+\bs : \x[#_c_1] = \x[#_c_2]-\fs : \resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \parent : \y[#_c_3] = Y : Y+\parent\y+\parent\bs+\parent\tabHeight : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[#_c_2] = \y+\bs+\tabHeight : \y[#_c_1] = \y[#_c_2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[#_c_2] = \width-\bs*2 : \width[#_c_1] = \width[#_c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[#_c_2] = \height-\bs*2-\tabHeight : \height[#_c_1] = \height[#_c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[#_c_2] = width-Bool(\type<>-1)*(\bs*2) : \width[#_c_1] = \width[#_c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\tabHeight+\bs*2) : \height[#_c_2] = height-Bool(\type<>-1)*(\tabHeight+\bs*2) : \height[#_c_1] = \height[#_c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        If \box And \resize
          \hide[1] = Bool(\page\len And Not ((\max-\min) > \page\len))
          
          If \vertical
            If Not \width
              \hide[1] = 1
            EndIf
          Else
            If Not \height
              \hide[1] = 1
            EndIf
          EndIf
          
          If \box\size
            \box\size[1] = \box\size
            \box\size[2] = \box\size
          EndIf
          
          If \max
            If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
              \area\pos = \y[#_c_2]+\box\size[1]
              \area\len = \height[#_c_2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            Else
              \area\pos = \x[#_c_2]+\box\size[1]
              \area\len = \width[#_c_2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            EndIf
          EndIf
          
          If (\type <> #PB_GadgetType_Splitter) And Bool(\resize & (1<<4 | 1<<3))
            \thumb\len = _thumb_len_(*this)
            
            
            If (\area\len > \box\size)
              If \box\size
                If (\thumb\len < \box\size)
                  \area\len = Round(\area\len - (\box\size[2]-\thumb\len), #PB_Round_Nearest)
                  \area\end = \area\pos + (\area\len- (\box\size[2]-\thumb\len))
                  \thumb\len = \box\size[2] 
                EndIf
              Else
                If (\thumb\len < \box\size[3]) And (\type <> #PB_GadgetType_ProgressBar)
                  \area\len = Round(\area\len - (\box\size[3]-\thumb\len), #PB_Round_Nearest)
                  \area\end = \area\pos + (\height[#_c_2]-\box\size[3]) 
                  \thumb\len = \box\size[3]
                EndIf
              EndIf
            Else
              \area\end = \area\pos + (\height[#_c_2]-\area\len)
              \thumb\len = \area\len 
            EndIf
          EndIf
          
          ;           If \area\len > 0 And \type <> #PB_GadgetType_Panel
          ;             If _scroll_in_stop_(*this) And (\type = #PB_GadgetType_ScrollBar)
          ;               SetState(*this, \max)
          ;             EndIf
          ;             
          ;             \thumb\pos = _thumb_pos_(*this, \page\pos)
          ;           EndIf
          If \area\len > 0 And \type <> #PB_GadgetType_Panel
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
            
            ;             If \type <> #PB_GadgetType_TrackBar And \thumb\pos = \area\end
            ;               SetState(*this, \max)
            ;             EndIf
          EndIf
          
          Select \type
            Case #PB_GadgetType_Window
              \box\x = \x[#_c_2]
              \box\y = \y+\bs
              \box\width = \width[#_c_2]
              \box\height = \tabHeight
              
              \box\width[1] = \box\size
              \box\width[2] = \box\size
              \box\width[3] = \box\size
              
              \box\height[1] = \box\size
              \box\height[2] = \box\size
              \box\height[3] = \box\size
              
              \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\width[1]-5
              \box\x[2] = \box\x[1]-Bool(Not \box\hide[2]) * \box\width[2]-5
              \box\x[3] = \box\x[2]-Bool(Not \box\hide[3]) * \box\width[3]-5
              
              \box\y[1] = \y+\bs+(\tabHeight-\box\size)/2
              \box\y[2] = \box\y[1]
              \box\y[3] = \box\y[1]
              
            Case #PB_GadgetType_Panel
              \page\len = \width[#_c_2]-2
              
              If _scroll_in_stop_(*this)
                If \max < \min : \max = \min : EndIf
                
                If \max > \max-\page\len
                  If \max > \page\len
                    \max = \max-\page\len
                  Else
                    \max = \min 
                  EndIf
                EndIf
                
                \page\pos = \max
                \thumb\pos = _thumb_pos_(*this, \page\pos)
              EndIf
              
              \box\width[1] = \box\size : \box\height[1] = \tabHeight-1-4
              \box\width[2] = \box\size : \box\height[2] = \box\height[1]
              
              \box\x[1] = \x[#_c_2]+1
              \box\y[1] = \y[#_c_2]-\tabHeight+\bs+2
              \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\width[2]-1
              \box\y[2] = \box\y[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \box\y[1] = \y[#_c_2]+\height[#_c_2]/2+Bool(\height[#_c_2]%2) : \box\height[1] = \height[#_c_2]/2 : \box\width[1] = \box\size[2] : \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\size[2] ; Top button coordinate
                \box\y[2] = \y[#_c_2] : \box\height[2] = \height[#_c_2]/2 : \box\width[2] = \box\size[2] : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2]                                         ; Bottom button coordinate
              Else
                \box\y[1] = \y[#_c_2] : \box\height[1] = \height[#_c_2] : \box\width[1] = \box\size[2]/2 : \box\x[1] = \x[#_c_2]+\width[#_c_2]-\box\size[2]                                 ; Left button coordinate
                \box\y[2] = \y[#_c_2] : \box\height[2] = \height[#_c_2] : \box\width[2] = \box\size[2]/2 : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \box\size
                  \box\x[1] = \x[#_c_2] + Lines : \box\y[1] = \y[#_c_2] : \box\width[1] = \width - Lines : \box\height[1] = \box\size[1]                         ; Top button coordinate on scroll bar
                  \box\x[2] = \x[#_c_2] + Lines : \box\width[2] = \width - Lines : \box\height[2] = \box\size[2] : \box\y[2] = \y[#_c_2]+\height[#_c_2]-\box\size[2] ; (\area\pos+\area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \box\x[3] = \x[#_c_2] + Lines : \box\width[3] = \width - Lines : \box\y[3] = \thumb\pos : \box\height[3] = \thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \box 
                If \box\size
                  \box\x[1] = \x[#_c_2] : \box\y[1] = \y[#_c_2] + Lines : \box\height[1] = \height - Lines : \box\width[1] = \box\size[1]                        ; Left button coordinate on scroll bar
                  \box\y[2] = \y[#_c_2] + Lines : \box\height[2] = \height - Lines : \box\width[2] = \box\size[2] : \box\x[2] = \x[#_c_2]+\width[#_c_2]-\box\size[2] ; (\area\pos+\area\len)  ; Right button coordinate on scroll bar
                EndIf
                \box\y[3] = \y[#_c_2] + Lines : \box\height[3] = \height - Lines : \box\x[3] = \thumb\pos : \box\width[3] = \thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        ;         If \type = #PB_GadgetType_ScrollBar Or
        ;            \type = #PB_GadgetType_ProgressBar Or
        ;            \type = #PB_GadgetType_TrackBar Or
        ;            \type = #PB_GadgetType_Splitter
        ;           
        ;           Resize_Bar(*this, x,y,width,height)
        ;         EndIf
        
        ; set clip coordinate
        If Not IsRoot(*this) And \parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \parent\scroll 
            If \parent\scroll\v : clip_v = Bool(\parent\width=\parent\width[#_c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\parent\scroll\v\width : EndIf
            If \parent\scroll\h : clip_h = Bool(\parent\height=\parent\height[#_c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \parent\x[#_c_4]+Bool(\parent\x[#_c_4]<\parent\x+\parent\bs)*\parent\bs
          clip_y = \parent\y[#_c_4]+Bool(\parent\y[#_c_4]<\parent\y+\parent\bs)*(\parent\bs+\parent\tabHeight) 
          clip_width = ((\parent\x[#_c_4]+\parent\width[#_c_4])-Bool((\parent\x[#_c_4]+\parent\width[#_c_4])>(\parent\x[#_c_2]+\parent\width[#_c_2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#_c_4]+\parent\height[#_c_4])-Bool((\parent\y[#_c_4]+\parent\height[#_c_4])>(\parent\y[#_c_2]+\parent\height[#_c_2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#_c_4] = clip_x : Else : \x[#_c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#_c_4] = clip_y : Else : \y[#_c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#_c_4] = clip_width - \x[#_c_4] : Else : \width[#_c_4] = \width - (\x[#_c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#_c_4] = clip_height - \y[#_c_4] : Else : \height[#_c_4] = \height - (\y[#_c_4]-\y) : EndIf
        
        ; Resize scrollbars
        If \scroll And \scroll\v And \scroll\h
          Resizes_Bar(\scroll, 0,0, \width[#_c_2],\height[#_c_2])
        EndIf
        
        ; Resize childrens
        If ListSize(\childrens())
          If \type = #PB_GadgetType_Splitter
            Resize_Splitter(*this)
          Else
            ForEach \childrens()
              If \childrens()\align
                If \childrens()\align\horizontal
                  x = (\width[#_c_2] - (\childrens()\align\x+\childrens()\width))/2
                ElseIf \childrens()\align\right And Not \childrens()\align\left
                  x = \width[#_c_2] - \childrens()\align\x
                Else
                  If \x[#_c_2]
                    x = (\childrens()\x-\x[#_c_2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \childrens()\align\Vertical
                  y = (\height[#_c_2] - (\childrens()\align\y+\childrens()\height))/2 
                ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                  y = \height[#_c_2] - \childrens()\align\y
                Else
                  If \y[#_c_2]
                    y = (\childrens()\y-\y[#_c_2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \childrens()\align\top And \childrens()\align\bottom
                  Height = \height[#_c_2] - \childrens()\align\y
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \childrens()\align\left And \childrens()\align\right
                  Width = \width[#_c_2] - \childrens()\align\x
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\childrens(), x, y, Width, Height)
              Else
                Resize(\childrens(), (\childrens()\x-\x[#_c_2]) + Change_x, (\childrens()\y-\y[#_c_2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  ;-
  ;- Containers
  Macro _set_last_parameters_(_this_, _type_, _flag_)
    *Value\event\widget = _this_
    _this_\type = _type_
    _this_\handle = _this_
    
    ;     If _this_\root
    ;       _this_\index = _this_\root\index
    ;       _this_\root\index + 1
    ;     Else
    ;       _this_\index = 1
    ;     EndIf
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    If LastElement(*Value\OpenedList())
      If _this_\type = #PB_GadgetType_Option
        If ListSize(*Value\OpenedList()\childrens()) 
          If *Value\OpenedList()\childrens()\type = #PB_GadgetType_Option
            _this_\OptionGroup = *Value\OpenedList()\childrens()\OptionGroup 
          Else
            _this_\OptionGroup = *Value\OpenedList()\childrens() 
          EndIf
        Else
          _this_\OptionGroup = *Value\OpenedList()
        EndIf
      EndIf
      
      SetParent(_this_, *Value\OpenedList(), *Value\OpenedList()\o_i)
    EndIf
    
  EndMacro
  
  Procedure.i Container(index.l, X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Container, Flag) 
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \color = def_colors
      \color\alpha = 255
      \color\fore = 0
      \color\back = $FFF6F6F6
      
      \index = index
      \index[1] =- 1
      \index[2] = 0
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      Resize(*this, X.i,Y.i,Width.i,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Form(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, *Widget._S_widget=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    
    *this\class = #PB_Compiler_Procedure
    
    If *Widget 
      *this\type = #PB_GadgetType_Window
      SetParent(*this, *Widget)
      
      If Bool(Flag & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
        ;         AddAnchors(*this)
      EndIf
    Else ;If *root
      If LastElement(*Value\OpenedList()) 
        ChangeCurrentElement(*Value\OpenedList(), Root()\Adress)
        While NextElement(*Value\OpenedList())
          DeleteElement(*Value\OpenedList())
        Wend
      EndIf
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag) 
    EndIf
    
    With *this
      \x =- 1
      \y =- 1
      \container =- 1
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      \index[1] =- 1
      \index[2] = 0
      \tabHeight = 25
      
      \Image = AllocateStructure(_S_image)
      \image\x[2] = 5 ; padding 
      
      \text = AllocateStructure(_S_text)
      \text\align\horizontal = 1
      
      \box = AllocateStructure(_S_box)
      \box\size = 12
      \box\color = def_colors
      \box\color\alpha = 255
      
      ;       \box\color[1]\alpha = 128
      ;       \box\color[2]\alpha = 128
      ;       \box\color[3]\alpha = 128
      
      
      \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \flag\window\borderLess = Bool(Flag&#PB_Window_BorderLess)
      
      \fs = 1
      \bs = 1 ;Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(_S_image)
      
      ;       SetText(*this, Text.s)
      Resize(*this, X.i,Y.i,Width.i,Height)
      OpenList(*this)
      SetActive(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i CloseList()
    If LastElement(*Value\OpenedList())
      If *Value\OpenedList()\type = #PB_GadgetType_Popup
        ReDraw(*Value\OpenedList())
      EndIf
      
      DeleteElement(*Value\OpenedList())
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._S_widget, Item.i=0, Type=-5)
    With *this
      If *this > 0
        If \type = #PB_GadgetType_Window
          \window = *this
        EndIf
        
        If LastElement(*Value\OpenedList()) ;<> *this
          If AddElement(*Value\OpenedList())
            *Value\OpenedList() = *this 
            *Value\OpenedList()\o_i = Item
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *this\container
  EndProcedure
  
  Procedure.i Open(Window.i, X.i,Y.i,Width.i,Height.i, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, Canvas.i=-1, *this._S_root = AllocateStructure(_S_root)
    
    With *this
      If Not IsWindow(Window) And Window >- 2
        w = OpenWindow(Window, X,Y,Width,Height, Text.s, Flag, WindowID) 
        If Window =- 1 
          Window = w 
        EndIf
        X = 0 
        Y = 0
      EndIf
      
      If Window <>- 2 ; IsWindow(w)
        Canvas = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
        BindGadgetEvent(Canvas, @g_CallBack())
      EndIf
      
      \x =- 1
      \y =- 1
      \root = *this
      
      If Text.s
        \type =- 1
        \container =- 1
        \color = def_colors
        \color\fore = 0
        \color\back = $FFF0F0F0
        \color\alpha = 255
        \color[1]\alpha = 128
        \color[2]\alpha = 128
        \color[3]\alpha = 128
        
        \index[1] =- 1
        \index[2] = 0
        \tabHeight = 25
        
        \Image = AllocateStructure(_S_image)
        \image\x[2] = 5 ; padding 
        
        \text = AllocateStructure(_S_text)
        \text\align\horizontal = 1
        
        \box = AllocateStructure(_S_box)
        \box\size = 12
        \box\color = def_colors
        \box\color\alpha = 255
        
        \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
        \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
        \flag\window\borderLess = Bool(Flag&#PB_Window_BorderLess)
        
        \fs = 1
        \bs = 1
        
        ; Background image
        \Image[1] = AllocateStructure(_S_image)
        
        ;         SetText(*this, Text.s)
        SetActive(*this)
      Else
        \type = #PB_GadgetType_Root
        \container = #PB_GadgetType_Root
        
        \text = AllocateStructure(_S_text) ; без него в окнах вилетает ошибка
        
        \color\alpha = 255
      EndIf
      
      Resize(*this, 0, 0, Width,Height)
      
      LastElement(*Value\OpenedList())
      If AddElement(*Value\OpenedList())
        *Value\OpenedList() = *this
      EndIf
      
      ;AddAnchors(\root)
      Root() = \root
      Root()\canvas\window = Window
      Root()\canvas\gadget = Canvas
      Root()\adress = @*Value\OpenedList()
      
      *Value\last = Root()
      
      If IsGadget(Canvas)
        SetGadgetData(Canvas, *this)
        SetWindowData(Window, Canvas)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;- 
  Procedure Events(*this._S_widget, eventtype.l, mouse_x.l=-1, mouse_y.l=-1, position.l=0)
    Protected Result, down
    
    Select eventtype
      Case #PB_EventType_MouseEnter
        ;Debug ""+*this\index +" "+ *this\CountItems
        Debug "enter - "+*this +" "+ *this\index
        If *this\color\state = 0
          *this\color\state = 1
        EndIf
        *this\color\fore = 0
        *this\color\back = $FF0000FF
        Result = 1
        
      Case #PB_EventType_MouseLeave
        Debug "leave - "+*this +" "+ *this\index
        If *this\color\state = 1
          *this\color\state = 0
        EndIf
        *this\color\fore = 0
        *this\color\back = $FF00FF00
        Result = 1
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Callback(*this._S_widget, eventtype.l, mouse_x.l, mouse_y.l)
    Static repaint
    
    With *this
;               If _from_point_(mouse_x, mouse_y, *this, [4]) ;And Not (*value\event\enter And *value\event\enter\index > *this\index)  
;                 If *value\event\enter <> *this And Not (*value\event\enter And *value\event\enter\index > *this\index)  
;                   If Not *this\state : *this\state = 1
;                     repaint = Events(*this, #PB_EventType_MouseEnter, mouse_x, mouse_y)
;                   EndIf
;                   
;                   *value\event\enter = *this
;                 EndIf
;                 
;                 
;               ElseIf *this\state : *this\state = 0
;                 repaint = Events(*this, #PB_EventType_MouseLeave, mouse_x, mouse_y)
;                 
;                 *value\event\enter = 0
;               EndIf
      
      If ListSize(\childrens()) ;  \CountItems ; 
                                ;Debug "pp "+\childrens()\index
        
        LastElement(\childrens())         ; Что бы начать с последнего элемента
        Repeat                            ; Перебираем с низу верх
                                          ;ForEach \childrens()
          Debug ""+ListIndex(\childrens()) +" "+ \childrens()\index_ +" "+ \childrens()\index
          
          If _from_point_(mouse_x, mouse_y, \childrens(), [4]) And Not (*value\event\enter And *value\event\enter\index_ > \childrens()\index_)  ;And Not (*value\event\enter And _from_point_(mouse_x, mouse_y, *value\event\enter, [4]))
            If *value\event\enter <> \childrens() ; And Not (*value\event\enter And *value\event\enter\index > \childrens()\parent\index) 
;               If *value\event\enter And (*value\event\enter\parent = \childrens()\parent Or *value\event\enter = \childrens()\parent)
;               EndIf
              
;               If *value\event\enter And *value\event\enter\parent = \childrens()\parent
;                 If *value\event\enter\color\State : *value\event\enter\color\State = 0
;                   repaint = Events(*value\event\enter, #PB_EventType_MouseLeave, mouse_x, mouse_y)
;                 EndIf
;               EndIf
              
              
              If Not \childrens()\state : \childrens()\state = 1
                ;                 If (*value\event\enter And *value\event\enter\State And 
                ;                     *value\event\enter\index < \childrens()\index And \childrens()\parent = *value\event\enter\parent)
                ;                   repaint = Events(*value\event\enter, #PB_EventType_MouseLeave, mouse_x, mouse_y)
                ;                 EndIf
                repaint = Events(\childrens(), #PB_EventType_MouseEnter, mouse_x, mouse_y)
              EndIf
              
              *value\event\enter = \childrens()
            EndIf
            
          Else
            If \childrens()\state : \childrens()\state = 0
;               If *value\event\enter ;And *value\event\enter\color\state = 0 : *value\event\enter\color\state = 1
;                 repaint = Events(*value\event\enter, #PB_EventType_MouseEnter, mouse_x, mouse_y)
;               EndIf
              
              repaint = Events(\childrens(), #PB_EventType_MouseLeave, mouse_x, mouse_y)
              *value\event\enter = 0
            EndIf
          EndIf
          
          ; if children have children's
          If ListSize(\childrens()\childrens()) ;  \childrens()\CountItems ; 
            Callback(\childrens(), eventtype, mouse_x, mouse_y)
          EndIf
          ;Next
        Until PreviousElement(\childrens()) = #False 
        
      EndIf
      
      If repaint
        Debug " repaint - "+repaint 
        repaint = 0
        ProcedureReturn 1
      Else
        
        If EventType = #PB_EventType_LeftButtonDown
          Debug *value\event\enter
        EndIf
        
      EndIf
    EndWith
    ProcedureReturn 1
  EndProcedure
  
  Procedure g_CallBack()
    Protected Repaint.b
    Protected EventType.i = EventType()
    Protected *this._S_widget = GetGadgetData(EventGadget())
    
    ;     If mouse_x =- 1 And mouse_y =- 1
    Select EventType
      Case #PB_EventType_Repaint
        Debug " -- Canvas repaint -- " + *this\row\draw
      Case #PB_EventType_MouseWheel
        *this\root\canvas\mouse\wheel\y = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_WheelDelta)
      Case #PB_EventType_Input 
        *this\root\canvas\input = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Input)
      Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
        *this\root\canvas\Key = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Key)
        *this\root\canvas\Key[1] = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Modifiers)
      Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
        *this\root\canvas\mouse\x = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_MouseX)
        *this\root\canvas\mouse\y = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_MouseY)
        
      Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
           #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
           #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux
          *this\root\canvas\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                            (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                            (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
        CompilerElse
          *this\root\canvas\mouse\buttons = GetGadgetAttribute(*this\root\canvas\gadget, #PB_Canvas_Buttons)
        CompilerEndIf
        
    EndSelect
    ;       
    ;       mouse_x = *this\canvas\mouse\x
    ;       mouse_y = *this\canvas\mouse\y
    ;     EndIf
    
    
    With *this
      Select EventType
        Case #PB_EventType_Repaint
          \row\draw = \row\count
          Repaint = 1
          
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas\gadget), GadgetHeight(\root\canvas\gadget))   
          
          If \scroll\v\page\len And \scroll\v\max<>\scroll\height-Bool(\flag\gridlines) And
             SetAttribute_Bar(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height-Bool(\flag\gridlines))
            
            Resizes_Bar(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \scroll\h\page\len And \scroll\h\max<>\scroll\width And
             SetAttribute_Bar(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
            
            Resizes_Bar(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \resize = 1<<3
            \width[2] = (\scroll\v\x + Bool(\scroll\v\hide) * \scroll\v\width) - \x[2]
          EndIf 
          
          If \resize = 1<<4
            \height[2] = (\scroll\h\y + Bool(\scroll\h\hide) * \scroll\h\height) - \y[2]
          EndIf
          
          If StartDrawing(CanvasOutput(\root\canvas\gadget))
            Draw(*this)
            StopDrawing()
          EndIf
      EndSelect
      
      ;       Protected w = From(*this, *this\canvas\mouse\x, *this\canvas\mouse\y)
      ;       
      ;       If w
      ;         Repaint | CallBack(w, EventType)
      ;       EndIf
      ;  Debug 8888888
      Repaint | CallBack(*this, EventType, *this\root\canvas\mouse\x, *this\root\canvas\mouse\y)
      
      If Repaint
        ReDraw(*this)
      EndIf
      
    EndWith
  EndProcedure
  
EndModule


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
    
    ; 
    Open(0, 0, 0, 220, 220)
    Container(1, 20, 20, 180, 180)
    Container(9,70, 10, 70, 180, #PB_Flag_NoGadget) ; bug
    Container(2,20, 20, 180, 180)
    Container(3,20, 20, 180, 180)
    ;  Container(20, 20, 180, 180), 30)
    Container(4,0, 20, 180, 30, #PB_Flag_NoGadget)
    Container(5,0, 35, 180, 30, #PB_Flag_NoGadget)
    Container(6,0, 50, 180, 30, #PB_Flag_NoGadget)
    Container(7,20, 70, 180, 180, #PB_Flag_NoGadget)
    ;  Container(20, 20, 180, 50), 200)
    CloseList()
    CloseList()
    Container(8,10, 70, 70, 180, #PB_Flag_NoGadget)
    
    Redraw(Root())
    
    Repeat
      Event = WaitWindowEvent()
      
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --------------------------------------------4---
; EnableXP