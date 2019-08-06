; 23 мая 2019
; Window() > Form()
; RootGadget() > _Gadget()
; RootWindow() > _Window()

;
;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
;

;-
DeclareModule Widget
  EnableExplicit
  #Anchors = 9+4
  
  #Anchor_moved = 9
  
  ;   Structure _S_type
  ;     b.b
  ;     i.i 
  ;     s.s
  ;   EndStructure
  
  ;- - STRUCTUREs
  ;- - _S_Mouse
  Structure _S_mouse
    x.i
    y.i
    
    at.b ; - editor
    buttons.i 
    *delta._S_mouse
    direction.i
  EndStructure
  
  ;- - _S_Keyboard
  Structure _S_keyboard
    input.c
    key.i[2]
  EndStructure
  
  ;- - _S_Coordinate
  Structure _S_coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - _S_box
  Structure _S_box Extends _S_coordinate
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
  
  ;- - _S_Page
  Structure _S_page
    pos.i
    len.i
    *step
  EndStructure
  
  ;- - _S_Align
  Structure _S_align
    x.i
    y.i
    
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
    Lines.b
    Buttons.b
    GridLines.b
    Checkboxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - _S_Image
  Structure _S_image
    y.i[3]
    x.i[3]
    height.i
    width.i
    
    index.i
    imageID.i[2] ; - editor
    change.b
    
    align._S_align
  EndStructure
  
  ;- - _S_Text
  Structure _S_text Extends _S_coordinate
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
    
    align._S_align
  EndStructure
  
  ;- - _S_Bar
  ;   Structure _S_bar Extends _S_coordinate
  ;     *root._S_root   ; adress root
  ;     *window._S_widget ; adress window
  ;     *parent._S_widget ; adress parent
  ;     *scroll._S_scroll 
  ;     *first._S_widget
  ;     *second._S_widget
  ;     
  ;     ticks.b  ; track bar
  ;     smooth.b ; progress bar
  ;     
  ;     type.b[3] ; [2] for splitter
  ;     radius.a
  ;     cursor.i[2]
  ;     
  ;     max.i
  ;     min.i
  ;     hide.b[2]
  ;     *box._S_box
  ;     
  ;     focus.b
  ;     change.i[2]
  ;     resize.b
  ;     vertical.b
  ;     inverted.b
  ;     direction.i
  ;     
  ;     page._S_page
  ;     area._S_page
  ;     thumb._S_page
  ;     color._S_color[4]
  ;     *from
  ;   EndStructure
  
  ;- - _S_Scroll
  Structure _S_scroll
    y.i
    x.i
    height.i[4] ; - EditorGadget
    width.i[4]
    
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;- - _S_Items
  Structure _S_items Extends _S_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *i_parent._S_items
    drawing.i
    
    image._S_image
    text._S_text[4]
    *box._S_box
    
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
  
  ;- - _S_widget
  Structure _S_widget Extends _S_coordinate
    ; Extends _S_bar
    *root._S_root   ; adress root
    *window._S_widget ; adress window
    *parent._S_widget ; adress parent
    *scroll._S_scroll 
    *first._S_widget
    *second._S_widget
    
    ticks.b  ; track bar
    smooth.b ; progress bar
    
    type.b[3] ; [2] for splitter
    radius.a
    cursor.i[2]
    
    max.i
    min.i
    hide.b[2]
    *box._S_box
    
    focus.b
    change.i[2]
    resize.b
    vertical.b
    inverted.b
    direction.i
    
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    *from
    
    ;;;;;
    Type_Index.i
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    ParentItem.i ; index parent tab item
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
    clip._S_coordinate
    *Align._S_align
    
    *Function[4] ; IsFunction *Function=0 >> Gadget *Function=1 >> Window *Function=2 >> Root *Function=3
    sublevellen.i
    Drag.i[2]
    Attribute.i
    
    Mouse._S_mouse
    Keyboard._S_keyboard
    
    margin._S_margin
    create.b
    
    event.i
    ;message.i
    repaint.i
    *anchor._S_anchor[#Anchors+1]
    *selector._S_anchor[#Anchors+1]
  EndStructure
  
  ;- - _S_root
  Structure _S_root Extends _S_widget
    canvas.i
    canvas_window.i
  EndStructure
  
  ;- - _S_anchor
  Structure _S_anchor
    x.i
    y.i
    width.i
    height.i
    
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
  
  ;- - _S_value
  Structure _S_value
    *root._S_root
    *this._S_widget
    *last._S_widget
    *active._S_widget
    *focus._S_widget
    
    List *openedList._S_widget()
  EndStructure
  
  
  
  ;-
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Drop
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version<547 : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ;   EnumerationBinary (#PB_Window_BorderLess<<1)
  ;     #PB_Window_Transparent 
  ;     #PB_Window_Flat
  ;     #PB_Window_Single
  ;     #PB_Window_Double
  ;     #PB_Window_Raised
  ;     #PB_Window_MoveGadget
  ;     #PB_Window_CloseGadget
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Container_Double<<1)
  ;     #PB_Container_Transparent 
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Gadget_ActualSize<<1)
  ;     #PB_Gadget_Left   
  ;     #PB_Gadget_Top    
  ;     #PB_Gadget_Right  
  ;     #PB_Gadget_Bottom 
  ;     
  ;     #PB_Gadget_VCenter
  ;     #PB_Gadget_HCenter
  ;     #PB_Gadget_Full
  ;     #PB_Gadget_Center = (#PB_Gadget_HCenter|#PB_Gadget_VCenter)
  ;   EndEnumeration
  
  ;   Enumeration - 7 ; Type
  ;     #_Type_Message
  ;     #_Type_PopupMenu
  ;     #_Type_Desktop
  ;     #_Type_StatusBar
  ;     #_Type_Menu           ;  "Menu"
  ;     #_Type_Toolbar        ;  "Toolbar"
  ;     #_Type_Window         ;  "Window"
  ;     #_Type_Unknown        ;  "create" 0
  ;     #_Type_Button         ;  "Button"
  ;     #_Type_String         ;  "String"
  ;     #_Type_Text           ;  "Text"
  ;     #_Type_Checkbox       ;  "Checkbox"
  ;     #_Type_Option         ;  "Option"
  ;     #_Type_ListView       ;  "ListView"
  ;     #_Type_Frame          ;  "Frame"
  ;     #_Type_Combobox       ;  "Combobox"
  ;     #_Type_Image          ;  "Image"
  ;     #_Type_HyperLink      ;  "HyperLink"
  ;     #_Type_Container      ;  "Container"
  ;     #_Type_ListIcon       ;  "ListIcon"
  ;     #_Type_IPAddress      ;  "IPAddress"
  ;     #_Type_ProgressBar    ;  "ProgressBar"
  ;     #_Type_ScrollBar      ;  "ScrollBar"
  ;     #_Type_ScrollArea     ;  "ScrollArea"
  ;     #_Type_TrackBar       ;  "TrackBar"
  ;     #_Type_Web            ;  "Web"
  ;     #_Type_ButtonImage    ;  "ButtonImage"
  ;     #_Type_Calendar       ;  "Calendar"
  ;     #_Type_Date           ;  "Date"
  ;     #_Type_Editor         ;  "Editor"
  ;     #_Type_ExplorerList   ;  "ExplorerList"
  ;     #_Type_ExplorerTree   ;  "ExplorerTree"
  ;     #_Type_ExplorerCombo  ;  "ExplorerCombo"
  ;     #_Type_Spin           ;  "Spin"
  ;     #_Type_Tree           ;  "Tree"
  ;     #_Type_Panel          ;  "Panel"
  ;     #_Type_Splitter       ;  "Splitter"
  ;     #_Type_MDI           
  ;     #_Type_Scintilla      ;  "Scintilla"
  ;     #_Type_Shortcut       ;  "Shortcut"
  ;     #_Type_Canvas         ;  "Canvas"
  ;     
  ;     #_Type_ImageButton    ;  "ImageButton"
  ;     #_Type_Properties     ;  "Properties"
  ;     
  ;     #_Type_StringImageButton    ;  "ImageButton"
  ;     #_Type_StringButton         ;  "ImageButton"
  ;     #_Type_AnchorButton         ;  "ImageButton"
  ;     #_Type_ComboButton          ;  "ImageButton"
  ;     #_Type_DropButton           ;  "ImageButton"
  ;     
  ;   EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_NoButtons ;= 5
    #PB_Bar_Inverted 
    #PB_Bar_Direction ;= 6
    #PB_Bar_Smooth 
    #PB_Bar_Ticks 
  EndEnumeration
  
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_Checkboxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
                                                              ; #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  
  #PB_Widget_First = 1<<7
  #PB_Widget_Second = 1<<8
  #PB_Widget_FirstFixed = 1<<9
  #PB_Widget_SecondFixed = 1<<10
  #PB_Widget_FirstMinimumSize = 1<<11
  #PB_Widget_SecondMinimumSize = 1<<12
  
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
    
    #PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    
    #PB_Flag_Limit
  EndEnumeration
  
  #PB_AutoSize = #PB_Flag_AutoSize
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
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
  
  Macro _Gadget()
    Root()\canvas
  EndMacro
  
  Macro _Window()
    Root()\canvas_window
  EndMacro
  
  Macro Focus() ; active gadget
    *Value\focus
  EndMacro
  
  Macro Active() ; active window
    *Value\active
  EndMacro
  
  Macro GetFocus() ; active gadget
    *Value\focus
  EndMacro
  
  Macro GetActive() ; active window
    *Value\active
  EndMacro
  
  Macro Adress(_this_)
    _this_\adress
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
  
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  Macro boxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  Macro Invert(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro Set_Image(_item_, _image_)
    IsImage(_image_)
    
    _item_\image\change = 1
    _item_\image\index = _image_
    
    If IsImage(_image_)
      _item_\image\imageID = ImageID(_image_)
      _item_\image\width = ImageWidth(_image_)
      _item_\image\height = ImageHeight(_image_)
    Else
      _item_\image\imageID = 0
      _item_\image\width = 0
      _item_\image\height = 0
    EndIf
  EndMacro
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  Macro IsFunction(_this_)
    (Bool(_this_\function) << 1) + (Bool(_this_\window And 
                                         _this_\window\function And 
                                         _this_\window<>_this_\root And 
                                         _this_\window<>_this_ And 
                                         _this_\root<>_this_) << 2) + (Bool(_this_\root And _this_\root\function) << 3)
  EndMacro
  
  ;   Macro Match(_value_, _grid_, _max_=$7FFFFFFF)
  ;     ((Bool((_value_)>(_max_)) * (_max_)) + (Bool((_grid_) And (_value_)<(_max_)) * (Round(((_value_)/(_grid_)), #PB_Round_Nearest) * (_grid_))))
  ;   EndMacro
  
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget::*Value\this)
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget::*Value\this)
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget::*Value\this, _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget::*Value\this, _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget::*Value\this, _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget::*Value\this, _type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
  
  Declare.i Y(*this._S_widget, Mode.i=0)
  Declare.i X(*this._S_widget, Mode.i=0)
  Declare.i Width(*this._S_widget, Mode.i=0)
  Declare.i Height(*this._S_widget, Mode.i=0)
  Declare.i Draw(*this._S_widget, Childrens=0)
  Declare.i GetState(*this._S_widget)
  Declare.i SetState(*this._S_widget, State.i)
  Declare.i SetAttribute(*this._S_widget, Attribute.i, Value.i)
  Declare.i CallBack(*this._S_widget, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*this._S_widget, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*this._S_widget, iX.i,iY.i,iWidth.i,iHeight.i);, *That._S_widget=#Null)
  ;Declare.i Hide(*this._S_widget, State.i=-1)
  
  Declare.i ReDraw(*this._S_widget=#Null)
  
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  
  Declare.i Resizes(*Scroll._S_scroll, X.i,Y.i,Width.i,Height.i)
  Declare.i Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
EndDeclareModule

;- MODULE
Module Widget
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
  
  ;- GLOBALs
  Global Color_Default._S_color
  
  With Color_Default                          
    \state = 0
    \alpha = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF8F8F8 
    \back[0] = $80E2E2E2
    \frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFFAF8F8
    \back[1] = $80FCEADA
    \frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $C8E9BA81;$C8FFFCFA
    \back[2] = $C8E89C3D; $80E89C3D
    \frame[2] = $C8DC9338; $80DC9338
  EndWith
  
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
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\box 
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\height[3] = _this_\thumb\len 
      Else 
        _this_\box\width[3] = _this_\thumb\len 
      EndIf
    EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\pos+_this_\area\len 
      _this_\thumb\pos = (_this_\area\pos+_this_\area\len)-_this_\thumb\len 
    EndIf 
    
    If _this_\box
      If _this_\Vertical And Bool(_this_\type <> #PB_GadgetType_Spin) 
        _this_\box\y[3] = _this_\thumb\pos 
      Else 
        _this_\box\x[3] = _this_\thumb\pos 
      EndIf
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
    Protected min.i, max.i
    
    With *this
      min = \area\pos + \min
      max = \area\pos + Round(((\max-\min) - \area\len) * (\area\len / (\max-\min)), #PB_Round_Nearest)
      
      If ThumbPos < min : ThumbPos = min : EndIf
      If ThumbPos > max : ThumbPos = max : EndIf
      
      If ScrollPos <> ThumbPos 
        ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        If \page\step > 1
          ScrollPos = Round(ScrollPos / \page\step, #PB_Round_Nearest) * \page\step
        EndIf
        If #PB_GadgetType_TrackBar = \type And \vertical 
          ScrollPos = Invert(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
        ScrollPos = ThumbPos
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Macro _set_last_parameters_(_this_, _type_, _flag_)
    _this_\type = _type_
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
      
      ;  SetParent(_this_, *Value\OpenedList(), *Value\OpenedList()\o_i)
    EndIf
    
    ; _set_auto_size_
    If Bool(_flag_ & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
      _this_\align = AllocateStructure(_S_align)
      _this_\align\autoSize = 1
      _this_\align\left = 1
      _this_\align\top = 1
      _this_\align\Right = 1
      _this_\align\bottom = 1
    EndIf
    
    
  EndMacro
  
  
  
  
  ;-
  ;-
  ;- DRAWING
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
      If Style > 0 : y-1
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
  
  Procedure.i Draw(*this._S_widget, Childrens=0)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\area\pos+\area\len) +" "+ \box\x[2]
      ;       Debug ""+Str(\area\pos+\area\len) +" "+ \box\y[2]
      ;Debug \width
      State_0 = \color[0]\state
      State_1 = \color[1]\state
      State_2 = \color[2]\state
      State_3 = \color[3]\state
      Alpha = \color\alpha<<24
      LinesColor = \color[3]\front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \color\back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        ; Roundbox( \x[2], \y[2], \width[2], \height[2], \Radius, \Radius, \color\back[State_0]&$FFFFFF|Alpha)
        RoundBox( \x, \y, \width, \height, \Radius, \Radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \color\line[State_0]<>-1
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \thumb\len 
        ; Draw thumb  
        If \color[3]\back[State_3]<>-1
          If \color[3]\fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[3], \box\y[3], \box\width[3], \box\height[3], \color[3]\fore[State_3], \color[3]\back[State_3], \Radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \color[3]\frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \box\x[3], \box\y[3], \box\width[3], \box\height[3], \Radius, \Radius, \color[3]\frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \box\size[1]
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[1], \box\y[1], \box\width[1], \box\height[1], \color[1]\fore[State_1], \color[1]\back[State_1], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[1]\frame[State_1]
          RoundBox( \box\x[1], \box\y[1], \box\width[1], \box\height[1], \Radius, \Radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[1]+( \box\width[1]-\box\arrow_size[1])/2, \box\y[1]+( \box\height[1]-\box\arrow_size[1])/2, \box\arrow_size[1], Bool( \Vertical),
               (Bool(Not _scroll_in_start_(*this)) * \color[1]\front[State_1] + _scroll_in_start_(*this) * \color[1]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[1])
      EndIf
      
      If \box\size[2]
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          boxGradient( \Vertical, \box\x[2], \box\y[2], \box\width[2], \box\height[2], \color[2]\fore[State_2], \color[2]\back[State_2], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[2]\frame[State_2]
          RoundBox( \box\x[2], \box\y[2], \box\width[2], \box\height[2], \Radius, \Radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \box\x[2]+( \box\width[2]-\box\arrow_size[2])/2, \box\y[2]+( \box\height[2]-\box\arrow_size[2])/2, \box\arrow_size[2], Bool( \Vertical)+2, 
               (Bool(Not _scroll_in_stop_(*this)) * \color[2]\front[State_2] + _scroll_in_stop_(*this) * \color[2]\frame[0])&$FFFFFF|Alpha, \box\arrow_type[2])
      EndIf
      
      If \thumb\len And \color[3]\fore[State_3]<>-1  ; Draw thumb lines
        If \focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \box\arrow_size[2]+3
        
        If \Vertical
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2-3,size,1, LinesColor)
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2,size,1, LinesColor)
          Line( \box\x[3]+(\box\width[3]-(size-1))/2, \box\y[3]+\box\height[3]/2+3,size,1, LinesColor)
        Else
          Line( \box\x[3]+\box\width[3]/2-3, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\width[3]/2, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
          Line( \box\x[3]+\box\width[3]/2+3, \box\y[3]+(\box\height[3]-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i ReDraw(*this._S_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      
      If StartDrawing(CanvasOutput(\root\canvas))
        ;DrawingMode(#PB_2DDrawing_Default)
        ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        If Not \hide
          Draw(*this, 1)
        EndIf
        
        
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
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \x[Mode]
        Else
          Result = \x[Mode]+\width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \y[Mode]
        Else
          Result = \y[Mode]+\height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \width[Mode] And \color\alpha
          Result = \width[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*this._S_widget, Mode.i=0)
    Protected Result.i
    
    If *this
      With *this
        If Not \hide[1] And \height[Mode] And \color\alpha
          Result = \height[Mode]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
   ;- GET
  Procedure.i GetState(*this._S_widget)
    Protected Result.i
    
    With *this
      If *this
        Result = Invert(*this, \page\pos, \inverted)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select \type
        Case #PB_GadgetType_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : Result = \box\size[1]
            Case #PB_Splitter_SecondMinimumSize : Result = \box\size[2] - \box\size[3]
          EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \min  ; 1
            Case #PB_Bar_Maximum : Result = \max  ; 2
            Case #PB_Bar_Inverted : Result = \inverted
            Case #PB_Bar_NoButtons : Result = \box\size ; 4
            Case #PB_Bar_Direction : Result = \direction
            Case #PB_Bar_PageLength : Result = \page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.i SetState(*this._S_widget, State.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *this
      If *this > 0
        If #PB_GadgetType_TrackBar = \type And \vertical
          State = Invert(*this, State, \inverted)
        EndIf
        
        State = PagePos(*this, State)
        
        If \page\pos <> State 
          \thumb\pos = ThumbPos(*this, State)
          
          If \inverted
            If \page\pos > State
              \direction = Invert(*this, State, \inverted)
            Else
              \direction =- Invert(*this, State, \inverted)
            EndIf
          Else
            If \page\pos > State
              \direction =- State
            Else
              \direction = State
            EndIf
          EndIf
          
          \change = \page\pos - State
          \page\pos = State
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*this._S_widget, Attribute.i, Value.i)
    Protected Resize.i
    
    With *this
      If *this > 0
        Select \type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                Set_Image(*this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \box\size[1] = Value
              Case #PB_Splitter_SecondMinimumSize : \box\size[2] = \box\size[3] + Value
            EndSelect 
            
            If \Vertical
              \area\pos = \y+\box\size[1]
              \area\len = (\height-\box\size[1]-\box\size[2])
            Else
              \area\pos = \x+\box\size[1]
              \area\len = (\width-\box\size[1]-\box\size[2])
            EndIf
            
            ProcedureReturn 1
            
          Case #PB_GadgetType_Image
            Select Attribute
              Case #PB_DisplayMode
                
                Select Value
                  Case 0 ; Default
                    \image\align\Vertical = 0
                    \image\align\horizontal = 0
                    
                  Case 1 ; Center
                    \image\align\Vertical = 1
                    \image\align\horizontal = 1
                    
                  Case 3 ; Mosaic
                  Case 2 ; Stretch
                    
                  Case 5 ; Proportionally
                EndSelect
                
                ;Resize = 1
                \Resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*this, \x, \y, \width, \height)
                \Resize = 0
            EndSelect
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \box\size[0] = Value
                \box\size[1] = Value
                \box\size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \page\pos = Invert(*this, \page\pos)
                \thumb\pos = ThumbPos(*this, \page\pos)
                ProcedureReturn 1
                
              Case #PB_Bar_Minimum ; 1 -m&l
                If \min <> Value 
                  \min = Value
                  \page\pos + Value
                  
                  If \page\pos > \max-\page\len
                    If \max > \page\len 
                      \page\pos = \max-\page\len
                    Else
                      \page\pos = \min 
                    EndIf
                  EndIf
                  
                  If \max > \min
                    \thumb\pos = ThumbPos(*this, \page\pos)
                    \thumb\len = ThumbLength(*this)
                  Else
                    \thumb\pos = \area\pos
                    \thumb\len = \area\len
                    
                    If \Vertical 
                      \box\y[3] = \thumb\pos  
                      \box\height[3] = \thumb\len
                    Else 
                      \box\x[3] = \thumb\pos 
                      \box\width[3] = \thumb\len
                    EndIf
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_Maximum ; 2 -m&l
                If \max <> Value
                  \max = Value
                  
                  If \page\len > \max 
                    \page\pos = \min
                  EndIf
                  
                  \thumb\pos = ThumbPos(*this, \page\pos)
                  
                  If \max > \min
                    \thumb\len = ThumbLength(*this)
                  Else
                    \thumb\len = \area\len
                    
                    If \Vertical 
                      \box\height[3] = \thumb\len
                    Else 
                      \box\width[3] = \thumb\len
                    EndIf
                  EndIf
                  
                  If \page\step = 0
                    \page\step = 1
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_PageLength ; 3 -m&l
                If \page\len <> Value
                  If Value > (\max-\min)
                    If \max = 0 
                      \max = Value 
                    EndIf
                    Value = (\max-\min)
                    \page\pos = \min
                  EndIf
                  \page\len = Value
                  
                  \thumb\pos = ThumbPos(*this, \page\pos)
                  
                  If \page\len > \min
                    \thumb\len = ThumbLength(*this)
                  Else
                    \thumb\len = \box\size[3]
                  EndIf
                  
                  If \page\step = 0
                    \page\step = 1
                  EndIf
                  If \page\step < 2 And \page\len
                    \page\step = (\max-\min) / \page\len 
                  EndIf
                  
                  Resize = 1
                EndIf
                
            EndSelect
            
        EndSelect
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetColor(*this._S_widget, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *this
      If State =- 1
        Count = 2
        \color\state = 0
      Else
        Count = State
        \color\state = State
      EndIf
      
      For State = \color\state To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \color[Item]\line[State] <> Color 
              \color[Item]\line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \color[Item]\back[State] <> Color 
              \color[Item]\back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \color[Item]\front[State] <> Color 
              \color[Item]\front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \color[Item]\frame[State] <> Color 
              \color[Item]\frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
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
        If \Parent And \Parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\Right And \align\bottom
          X = 0; \align\x
          Y = 0; \align\y
          Width = \Parent\width[2] ; - \align\x
          Height = \Parent\height[2] ; - \align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \Parent : \x[3] = X : X+\Parent\x+\Parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \Resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \Parent : \y[3] = Y : Y+\Parent\y+\Parent\bs+\Parent\tabHeight : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[2] = \y+\bs+\tabHeight : \y[1] = \y[2]-\fs : \Resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[2] = \height-\bs*2-\tabHeight : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[2] = width-Bool(\type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\tabHeight+\bs*2) : \height[2] = height-Bool(\type<>-1)*(\tabHeight+\bs*2) : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        If \box And \Resize
          \hide[1] = Bool(\page\len And Not ((\max-\min) > \page\len))
          ;Debug ""+\vertical +" "+ \hide[1]
          
          If \box\size
            \box\size[1] = \box\size
            \box\size[2] = \box\size
          EndIf
          
          If \max
            If \Vertical And Bool(\type <> #PB_GadgetType_Spin)
              \area\pos = \y[2]+\box\size[1]
              \area\len = \height[2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            Else
              \area\pos = \x[2]+\box\size[1]
              \area\len = \width[2]-(\box\size[1]+\box\size[2]) - Bool(\thumb\len>0 And (\type = #PB_GadgetType_Splitter))*\thumb\len
            EndIf
          EndIf
          
          If (\type <> #PB_GadgetType_Splitter) And Bool(\Resize & (1<<4 | 1<<3))
            \thumb\len = ThumbLength(*this)
            
            If (\area\len > \box\size)
              If \box\size
                If (\thumb\len < \box\size)
                  \area\len = Round(\area\len - (\box\size[2]-\thumb\len), #PB_Round_Nearest)
                  \thumb\len = \box\size[2] 
                EndIf
              Else
                If (\thumb\len < \box\size[3]) And (\type <> #PB_GadgetType_ProgressBar)
                  \area\len = Round(\area\len - (\box\size[3]-\thumb\len), #PB_Round_Nearest)
                  \thumb\len = \box\size[3]
                EndIf
              EndIf
            Else
              \thumb\len = \area\len 
            EndIf
          EndIf
          
          If \area\len > 0 And \type <> #PB_GadgetType_Panel
            If _scroll_in_stop_(*this) And (\type = #PB_GadgetType_ScrollBar)
              SetState(*this, \max)
            EndIf
            
            \thumb\pos = ThumbPos(*this, \page\pos)
          EndIf
          
          Select \type
            Case #PB_GadgetType_Window
              \box\x = \x[2]
              \box\y = \y+\bs
              \box\width = \width[2]
              \box\height = \tabHeight
              
              \box\width[1] = \box\size
              \box\width[2] = \box\size
              \box\width[3] = \box\size
              
              \box\height[1] = \box\size
              \box\height[2] = \box\size
              \box\height[3] = \box\size
              
              \box\x[1] = \x[2]+\width[2]-\box\width[1]-5
              \box\x[2] = \box\x[1]-Bool(Not \box\hide[2]) * \box\width[2]-5
              \box\x[3] = \box\x[2]-Bool(Not \box\hide[3]) * \box\width[3]-5
              
              \box\y[1] = \y+\bs+(\tabHeight-\box\size)/2
              \box\y[2] = \box\y[1]
              \box\y[3] = \box\y[1]
              
            Case #PB_GadgetType_Panel
              \page\len = \width[2]-2
              
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
                \thumb\pos = ThumbPos(*this, \page\pos)
              EndIf
              
              \box\width[1] = \box\size : \box\height[1] = \tabHeight-1-4
              \box\width[2] = \box\size : \box\height[2] = \box\height[1]
              
              \box\x[1] = \x[2]+1
              \box\y[1] = \y[2]-\tabHeight+\bs+2
              \box\x[2] = \x[2]+\width[2]-\box\width[2]-1
              \box\y[2] = \box\y[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \box\y[1] = \y[2]+\height[2]/2+Bool(\height[2]%2) : \box\height[1] = \height[2]/2 : \box\width[1] = \box\size[2] : \box\x[1] = \x[2]+\width[2]-\box\size[2] ; Top button coordinate
                \box\y[2] = \y[2] : \box\height[2] = \height[2]/2 : \box\width[2] = \box\size[2] : \box\x[2] = \x[2]+\width[2]-\box\size[2]                                 ; Bottom button coordinate
              Else
                \box\y[1] = \y[2] : \box\height[1] = \height[2] : \box\width[1] = \box\size[2]/2 : \box\x[1] = \x[2]+\width[2]-\box\size[2]                                 ; Left button coordinate
                \box\y[2] = \y[2] : \box\height[2] = \height[2] : \box\width[2] = \box\size[2]/2 : \box\x[2] = \x[2]+\width[2]-\box\size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \box\size
                  \box\x[1] = \x[2] + Lines : \box\y[1] = \y[2] : \box\width[1] = \width - Lines : \box\height[1] = \box\size[1]                         ; Top button coordinate on scroll bar
                  \box\x[2] = \x[2] + Lines : \box\width[2] = \width - Lines : \box\height[2] = \box\size[2] : \box\y[2] = \y[2]+\height[2]-\box\size[2] ; (\area\pos+\area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \box\x[3] = \x[2] + Lines : \box\width[3] = \width - Lines : \box\y[3] = \thumb\pos : \box\height[3] = \thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \box 
                If \box\size
                  \box\x[1] = \x[2] : \box\y[1] = \y[2] + Lines : \box\height[1] = \height - Lines : \box\width[1] = \box\size[1]                        ; Left button coordinate on scroll bar
                  \box\y[2] = \y[2] + Lines : \box\height[2] = \height - Lines : \box\width[2] = \box\size[2] : \box\x[2] = \x[2]+\width[2]-\box\size[2] ; (\area\pos+\area\len)  ; Right button coordinate on scroll bar
                EndIf
                \box\y[3] = \y[2] + Lines : \box\height[3] = \height - Lines : \box\x[3] = \thumb\pos : \box\width[3] = \thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        ; set clip coordinate
        If Not IsRoot(*this) And \Parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \Parent\scroll 
            If \Parent\scroll\v : clip_v = Bool(\Parent\width=\Parent\clip\width And Not \Parent\scroll\v\hide And \Parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\Parent\scroll\v\width : EndIf
            If \Parent\scroll\h : clip_h = Bool(\Parent\height=\Parent\clip\height And Not \Parent\scroll\h\hide And \Parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\Parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \Parent\clip\x+Bool(\Parent\clip\x<\Parent\x+\Parent\bs)*\Parent\bs
          clip_y = \Parent\clip\y+Bool(\Parent\clip\y<\Parent\y+\Parent\bs)*(\Parent\bs+\Parent\tabHeight) 
          clip_width = ((\Parent\clip\x+\Parent\clip\width)-Bool((\Parent\clip\x+\Parent\clip\width)>(\Parent\x[2]+\Parent\width[2]))*\Parent\bs)-clip_v 
          clip_height = ((\Parent\clip\y+\Parent\clip\height)-Bool((\Parent\clip\y+\Parent\clip\height)>(\Parent\y[2]+\Parent\height[2]))*\Parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \clip\x = clip_x : Else : \clip\x = \x : EndIf
        If clip_y And \y < clip_y : \clip\y = clip_y : Else : \clip\y = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \clip\width = clip_width - \clip\x : Else : \clip\width = \width - (\clip\x-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \clip\height = clip_height - \clip\y : Else : \clip\height = \height - (\clip\y-\y) : EndIf
        
        ; Resize scrollbars
        If \scroll And \scroll\v And \scroll\h
          Resizes(\scroll, 0,0, \width[2],\height[2])
        EndIf
        
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Updates(*Scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v)-(\v\width-\v\Radius/2)+1, iHeight = Y(\h)-(\h\height-\h\Radius/2)+1
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
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;     \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;     \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y) ; #PB_Ignore, \h) 
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : \h\width = iWidth+\v\width : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : \v\height = iHeight+\h\height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll._S_scroll, X.i,Y.i,Width.i,Height.i)
    With *Scroll
        If y=#PB_Ignore : y = \v\y : EndIf
        If x=#PB_Ignore : x = \h\x : EndIf
        If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
        If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
        
        If \v 
          If \h
            \v\page\len = Height - Bool(Not \h\hide) * \h\height
          Else
            \v\page\len = Height
          EndIf
        EndIf
        
        If \h
          If \v
            \h\page\len = Width - Bool(Not \v\hide) * \v\width
          Else
            \h\page\len = Width
          EndIf
        EndIf
        
        If \v
          \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
        EndIf
        If \h
          \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
        EndIf
        
        If \v 
          If \h
            \v\page\len = Height - Bool(Not \h\hide) * \h\height
          Else
            \v\page\len = Height
          EndIf
        EndIf
        
        If \h
          If \v
            \h\page\len = Width - Bool(Not \v\hide) * \v\width
          Else
            \h\page\len = Width
          EndIf
        EndIf
        
        If \v
          \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len); + Bool(\v\Radius And Not \h\hide And Not \v\hide)*4)
        EndIf
        If \h
          \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore); + Bool(\h\Radius And Not \v\hide And Not \h\hide)*4, #PB_Ignore)
        EndIf
        
        If \v And \h
          If Not \v\hide 
            \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius And \h\Radius)*(\v\box\size[2]/4+1), #PB_Ignore)
          EndIf
          If Not \h\hide
            \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\v\Radius And \h\Radius)*(\h\box\size[2]/4+1))
          EndIf
        EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, Size.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7, Parent.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \x =- 1
      \y =- 1
      \type = Type
      \Parent = Parent
      If \Parent
        \root = \Parent\root
        \window = \Parent\window
      EndIf
      \Radius = Radius
      \ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Flag&#PB_Vertical=#PB_Vertical)
      \box = AllocateStructure(_S_box)
      \box\size[3] = SliderLen ; min thumb size
      
      \box\arrow_size[1] = 4
      \box\arrow_size[2] = 4
      \box\arrow_type[1] =- 1 ; -1 0 1
      \box\arrow_type[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \color\state = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      
      \color[1] = Color_Default
      \color[2] = Color_Default
      \color[3] = Color_Default
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If Size < 21
          \box\size = Size - 1
        Else
          \box\size = 17
        EndIf
        
        If \Vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *this._S_widget, Size
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Vertical)
    
    If Vertical
      Size = width
    Else
      Size =  height
    EndIf
    
    *this = Bar(#PB_GadgetType_ScrollBar, Size, Min, Max, PageLength, Flag|Vertical, Radius)
    _set_last_parameters_(*this, #PB_GadgetType_ScrollBar, Flag) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  
  
  Procedure.i From(*this._S_widget, MouseX.i, MouseY.i)
    Protected *Result._S_widget, Change.b, X.i,Y.i,Width.i,Height.i, ParentItem.i
    Static *r._S_widget
    
    If Root()\Mouse\X <> MouseX
      Root()\Mouse\X = MouseX
      Change = 1
    EndIf
    
    If Root()\Mouse\Y <> MouseY
      Root()\Mouse\Y = MouseY
      Change = 1
    EndIf
    
    If Not *this
      *this = Root() ; GetGadgetData(EventGadget())
    EndIf
    
    If Change 
      With *this
        If *this And ListSize(\Childrens()) ; \CountItems ; Not Root()\Mouse\Buttons
          ParentItem = Bool(\Type = #PB_GadgetType_Panel) * \index[2]
          
          PushListPosition(\Childrens())    ;
          LastElement(\Childrens())         ; Что бы начать с последнего элемента
          Repeat                            ; Перебираем с низу верх
            X = \Childrens()\clip\X
            Y = \Childrens()\clip\Y
            Width = X+\Childrens()\clip\Width
            Height = Y+\Childrens()\clip\Height
            
            If Not \Childrens()\Hide And \Childrens()\ParentItem = ParentItem And 
               (MouseX >=  X And MouseX < Width And MouseY >=  Y And MouseY < Height)
              
              If ListSize(\Childrens()\Childrens())
                Root()\Mouse\X = 0
                Root()\Mouse\Y = 0
                *Result = From(\Childrens(), MouseX, MouseY)
                
                If Not *Result
                  *Result = \Childrens()
                EndIf
              Else
                *Result = \Childrens()
              EndIf
              
              Break
            EndIf
            
          Until PreviousElement(\Childrens()) = #False 
          PopListPosition(\Childrens())
        EndIf
      EndWith
      *r = *Result
    Else
      *Result = *r
    EndIf
    
    If *Result
      With *Result 
        \Mouse\X = MouseX
        \Mouse\Y = MouseY
        
        If \Scroll
          ; scrollbars events
          If \Scroll\v And Not \Scroll\v\Hide And \Scroll\v\Type And (MouseX>\Scroll\v\x And MouseX=<\Scroll\v\x+\Scroll\v\Width And  MouseY>\Scroll\v\y And MouseY=<\Scroll\v\y+\Scroll\v\Height)
            *Result = \Scroll\v
          ElseIf \Scroll\h And Not \Scroll\h\Hide And \Scroll\h\Type And (MouseX>\Scroll\h\x And MouseX=<\Scroll\h\x+\Scroll\h\Width And  MouseY>\Scroll\h\y And MouseY=<\Scroll\h\y+\Scroll\h\Height)
            *Result = \Scroll\h
          EndIf
        EndIf
        
        If \box 
          If (MouseX>\box\x[3] And MouseX=<\box\x[3]+\box\Width[3] And MouseY>\box\y[3] And MouseY=<\box\y[3]+\box\Height[3])
            \from = 3
          ElseIf (MouseX>\box\x[2] And MouseX=<\box\x[2]+\box\Width[2] And MouseY>\box\y[2] And MouseY=<\box\y[2]+\box\Height[2])
            \from = 2
          ElseIf (MouseX>\box\x[1] And MouseX=<\box\x[1]+\box\Width[1] And  MouseY>\box\y[1] And MouseY=<\box\y[1]+\box\Height[1])
            \from = 1
          ElseIf (MouseX>\box\x And MouseX=<\box\x+\box\Width And MouseY>\box\y And MouseY=<\box\y+\box\Height)
            \from = 0
          Else
            \from =- 1
          EndIf
        Else
          \from =- 1
        EndIf 
        
        If \from =- 1 And \Type <> #PB_GadgetType_Editor
          ; Columns at point
          If ListSize(\Columns())
            
            ForEach \Columns()
              If \Columns()\Drawing
                If (MouseX>=\Columns()\X And MouseX=<\Columns()\X+\Columns()\Width+1 And 
                    MouseY>=\Columns()\Y And MouseY=<\Columns()\Y+\Columns()\Height)
                  
                  \index[1] = \Columns()\index
                  Break
                Else
                  \index[1] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \Columns()\items()
                If \Columns()\items()\Drawing
                  If (MouseX>\X[2] And MouseX=<\X[2]+\Width[2] And 
                      MouseY>\Columns()\items()\Y And MouseY=<\Columns()\items()\Y+\Columns()\items()\Height)
                    \Columns()\index[1] = \Columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          ElseIf ListSize(\items())
            
            ; items at point
            ForEach \items()
              If \items()\Drawing
                If (MouseX>\items()\X And MouseX=<\items()\X+\items()\Width And 
                    MouseY>\items()\Y And MouseY=<\items()\Y+\items()\Height)
                  
                  \index[1] = \items()\index
                  ; Debug " i "+\index[1]+" "+ListIndex(\items())
                  Break
                Else
                  \index[1] =- 1
                EndIf
              EndIf
            Next
            
          EndIf
        EndIf
        
      EndWith
    EndIf
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure.i CallBack(*this._S_widget, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected MouseX.i=MouseScreenX, MouseY.i=MouseScreenY, WheelDelta.l=0, AutoHide.b=0, *Scroll._S_widget=#Null;)
    Protected Result, from
    Static LastX, LastY, Last, *Thisis._S_widget, Cursor, Drag, Down
    
    With *This
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
          If \box 
            If (MouseX>\box\x[3] And MouseX=<\box\x[3]+\box\Width[3] And MouseY>\box\y[3] And MouseY=<\box\y[3]+\box\Height[3])
              from = 3
            ElseIf (MouseX>\box\x[2] And MouseX=<\box\x[2]+\box\Width[2] And MouseY>\box\y[2] And MouseY=<\box\y[2]+\box\Height[2])
              from = 2
            ElseIf (MouseX>\box\x[1] And MouseX=<\box\x[1]+\box\Width[1] And  MouseY>\box\y[1] And MouseY=<\box\y[1]+\box\Height[1])
              from = 1
            ElseIf (MouseX>\box\x And MouseX=<\box\x+\box\Width And MouseY>\box\y And MouseY=<\box\y+\box\Height)
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
          If *Thisis = *This
            Select WheelDelta
              Case-1 : Result = SetState(*This, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*This, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *Thisis = *This : EndIf
          
          Select from
            Case - 1
              If *Thisis = *This
                If \Vertical
                  Result = ScrollPos(*This, (MouseY-\thumb\len/2))
                Else
                  Result = ScrollPos(*This, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 : Result = SetState(*This, (\page\pos - \page\step))
            Case 2 : Result = SetState(*This, (\page\pos + \page\step))
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            If *Thisis = *This And Bool(LastX|LastY) 
              If \Vertical
                Result = ScrollPos(*This, (MouseY-LastY))
              Else
                Result = ScrollPos(*This, (MouseX-LastX))
              EndIf
            EndIf
          Else
            If from
              If \from <> from
                If *Thisis > 0 
                  CallBack(*Thisis, #PB_EventType_MouseLeave, MouseX, MouseY) 
                EndIf
                
                If *Thisis <> *This 
                  Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *Thisis = *This
                EndIf
                
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *Thisis = *This
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *Thisis = 0
              ;               Last = 0
            EndIf
          EndIf
          
      EndSelect
      
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \focus = 1 : Result = #True
        Case #PB_EventType_LostFocus : \focus = 0 : Result = #True
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
          If from>0
            \color[from]\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
            
            ;             \color[from]\fore = \color[from]\fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\back = \color[from]\back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\frame = \color[from]\frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ;             \color[from]\line = \color[from]\line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
          ElseIf Not Drag And Not from 
            ; ResetColor(*This)
            
            \color[0]\state = 0
            \color[1]\state = 0
            \color[2]\state = 0
            \color[3]\state = 0
          EndIf
          
          Result = #True
      EndSelect
      
      ;       If AutoHide =- 1 : *Scroll = 0
      ;         If Not *Thisis : *Thisis =- 1 : EndIf
      ;         AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
      ;       ElseIf AutoHide And *Thisis = *This
      ;         *Thisis =- 1
      ;       EndIf
      ;       
      ;       ; Auto hides
      ;       If (AutoHide And Not Drag And Not from) 
      ;         If \alpha <> \alpha[1] : \alpha = \alpha[1] 
      ;           Result =- 1
      ;         EndIf 
      ;       EndIf
      ;       If EventType = #PB_EventType_MouseEnter And *Thisis =- 1
      ;         If \alpha < 255 : \alpha = 255
      ;           
      ;           If *Scroll
      ;             If \Vertical
      ;               Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
      ;             Else
      ;               Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
      ;             EndIf
      ;           EndIf
      ;           
      ;           Result =- 2
      ;         EndIf 
      ;       EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *this._S_widget
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *root._S_widget = GetGadgetData(Canvas)
    
    Select EventType
        ;       Case #PB_EventType_Repaint ;: Repaint = 1
        ;         MouseX = 0
        ;         MouseY = 0
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Resize(*root, #PB_Ignore, #PB_Ignore, Width, Height)  
        Repaint = 1
        
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        Repaint | CallBack(From(*root, MouseX, MouseY), EventType, MouseX, MouseY)
    EndSelect
    
    If Repaint 
      ; create widgets
      If Not *root\create
        *root\create = 1
      EndIf
      
      ReDraw(*root)
    EndIf
  EndProcedure
  
  Procedure.i Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      If #PB_Compiler_OS = #PB_OS_MacOS And EventType = #PB_EventType_MouseEnter And GetActiveGadget()<>EventGadget
        SetActiveGadget(EventGadget)
      EndIf
      
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) And GetActiveGadget()=EventGadget
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
      Static Last_X, Last_Y
      If Last_Y <> Mousey
        Last_Y = Mousey
        Result | Canvas_Events(EventGadget, EventType)
      EndIf
      If Last_x <> Mousex
        Last_x = Mousex
        Result | Canvas_Events(EventGadget, EventType)
      EndIf
    Else
      Result | Canvas_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

; XIncludeFile "module_scroll.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  Global *scroll._S_scroll = AllocateStructure(_S_scroll)
  
  Define a,i
  If LoadImage(0, #PB_Compiler_Home+"Examples/Sources/Data/Background.bmp") 
    ResizeImage(0,ImageWidth(0)*2, 521);ImageHeight(0)*2)
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputHeight(), $000000)
      StopDrawing()
    EndIf
  EndIf
  
  Procedure _CallBack()
    Protected Repaint, iWidth, iHeight
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    With *scroll
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint = Resizes(*scroll, 0, 0, Width, Height)
      EndSelect
      
      If \v And CallBack(\v, EventType(), MouseX, MouseY) : Repaint = #True : EndIf
      If \h And CallBack(\h, EventType(), MouseX, MouseY) : Repaint = #True : EndIf
      
      iWidth = X(\v)
      If \h
        iHeight = Y(\h)
      Else
        iHeight = Height
      EndIf
      
      If Repaint And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,Width,Height, $FFFFFF)
        ClipOutput(0,0, iWidth, iHeight)
        ;DrawImage(ImageID(0), -\h\page\pos, -\v\page\pos)
        DrawImage(ImageID(0), -GetState(\h), -GetState(\v))
        UnclipOutput()
        
        If \v And Not \v\hide
          Draw(\v)
        EndIf
        If \h And Not \h\hide
          Draw(\h)
        EndIf
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         ; widget area coordinate
        ;         Box(x-1, y-1, Width-x*2+2, Height-y*2+2, $0000FF)
        ;         
        ;         ; Scroll area coordinate
        ;         Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
        ;         
        ;         ; page coordinate
        ;         Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        ;         
        ;         ; area coordinate
        ;         Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
        ;         
        ;         ; scroll coordinate
        ;         Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        ;         
        ;         ; frame coordinate
        ;         Box(\h\x, \v\y, 
        ;             \h\Page\len + (Bool(Not \v\hide) * \v\width),
        ;             \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
        StopDrawing()
      EndWith
    EndIf
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 325, 160, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
    With *scroll
      \v = Scroll( 0, 0,  20, 0 ,0, ImageHeight(0), 0, #PB_ScrollBar_Vertical, 9)
      ;\h = Scroll( 0, 0, 0,  20, 0, ImageWidth(0), 0, 0, 9)
      
      SetState(\v, 150)
      SetState(\h, 100) ; \h\max)
      
      
      ;ReDraw()
      PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
      BindGadgetEvent(1, @_CallBack())
      BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    EndWith
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---------------------------------------------------------
; EnableXP