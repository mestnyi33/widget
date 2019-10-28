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
  
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf (#PB_Compiler_Version<547) : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    #PB_EventType_Drop
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #Anchors = 9+4
  
  #a_moved = 9
  
  ;bar buttons
  Enumeration
    #bb_1 = 1
    #bb_2 = 2
    #bb_3 = 3
  EndEnumeration
  
  ;bar position
  Enumeration
    #bp_0 = 0
    #bp_1 = 1
    #bp_2 = 2
    #bp_3 = 3
  EndEnumeration
  
  ;element position
  Enumeration
    #last =- 1
    #first = 0
    #prev = 1
    #next = 2
    #before = 3
    #after = 4
  EndEnumeration
  
  ;element coordinate 
  Enumeration
    #c_0 = 0 ; 
    #c_1 = 1 ; frame
    #c_2 = 2 ; inner
    #c_3 = 3 ; container
    #c_4 = 4 ; clip
  EndEnumeration
  
  ;color state
  Enumeration
    #s_0
    #s_1
    #s_2
    #s_3
  EndEnumeration
  
  Enumeration 1
    #Color_Front
    #Color_Back
    #Color_Line
    #Color_TitleFront
    #Color_TitleBack
    #Color_GrayText 
    #Color_Frame
  EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_Smooth 
    
    ;#PB_Bar_Vertical
    
    ;#PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
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
    #PB_Flag_Center
    #PB_Flag_Right
    #PB_Flag_Left
    #PB_Flag_Top
    #PB_Flag_Bottom
    #PB_Flag_Vertical 
    #PB_Flag_Horizontal
    #PB_Flag_AutoSize
    ;#PB_Flag_AutoRight
    ;#PB_Flag_AutoBottom
    
    #PB_Flag_Numeric
    #PB_Flag_ReadOnly
    #PB_Flag_LowerCase 
    #PB_Flag_UpperCase
    #PB_Flag_Password
    #PB_Flag_WordWrap
    #PB_Flag_MultiLine 
    #PB_Flag_InLine
    
    #PB_Flag_BorderLess
    ;     #PB_Flag_Double
    ;     #PB_Flag_Flat
    ;     #PB_Flag_Raised
    ;     #PB_Flag_Single
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AnchorsGadget
    
    #PB_Flag_FullSelection
    #PB_Flag_NoGadget
    
    #PB_Flag_Limit
  EndEnumeration
  
  #PB_Bar_Vertical = #PB_Flag_Vertical
  #PB_AutoSize = #PB_Flag_AutoSize
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Flag_Full = #PB_Flag_Left|#PB_Flag_Right|#PB_Flag_Top|#PB_Flag_Bottom
  
  
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
    #PB_s_imagetretch
    #PB_Image_Proportionally
    
    #PB_DisplayMode_AlwaysShowSelection                                    ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  EndEnumeration
  ;}
  
  ;   Structure _s_type
  ;     b.b
  ;     i.i 
  ;     s.s
  ;   EndStructure
  
  Prototype pFunc()
  
  
  ;-
  ;- - STRUCTUREs
  ;- - _s_point
  Structure _s_point
    y.l
    x.l
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    state.b ; entered; selected; disabled;
    front.i[4]
    line.i[4]
    fore.i[4]
    back.i[4]
    frame.i[4]
    alpha.a[2]
  EndStructure
  
  ;- - _s_mouse
  Structure _s_mouse Extends _s_point
    change.b
    buttons.l 
    *delta._s_mouse
  EndStructure
  
  ;- - _s_keyboard
  Structure _s_keyboard
    change.b
    input.c
    key.i[2]
  EndStructure
  
  ;- - _s_coordinate
  Structure _s_coordinate
    y.l[4]
    x.l[4]
    height.l[4]
    width.l[4]
  EndStructure
  
  ;- - _s_align
  Structure _s_align Extends _s_point
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
  EndStructure
  
  ;- - _s_arrow
  Structure _s_arrow
    size.a
    type.b
    ; direction.b
  EndStructure
  
  ;- - _s_button
  Structure _s_button Extends _s_coordinate
    len.a
    hide.b
    round.a
    ; switched.b
    interact.b
    arrow._s_arrow
    color._s_color
  EndStructure
  
  ;- - _s_box
  Structure _s_box Extends _s_button
    checked.b
  EndStructure
  
  ;- - _s_caption
  Structure _s_caption Extends _s_button
    button._s_button[3]
  EndStructure
  
  ;- - _s_transform
  Structure _s_transform
    x.i
    y.i
    width.i
    height.i
    
    hide.i
    cursor.i
    
    color._s_color[4]
  EndStructure
  
  ;- - _s_anchor
  Structure _s_anchor
    pos.i
    size.l
    index.l
    cursor.l
    delta._s_point
    *widget._s_widget
    id._s_transform[#Anchors+1]
  EndStructure
  
  ;- - _s_page
  Structure _s_page
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _s_WindowFlag
  Structure _s_windowFlag
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
  
  ;- - _s_flag
  Structure _s_flag
    Window._s_windowFlag
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    Checkboxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
    
    threestate.b
    iconsize.b
    transform.b
  EndStructure
  
  ;- - _s_image
  Structure _s_image
    y.l[3]
    x.l[3]
    height.l
    width.l
    
    index.l
    handle.i[2] ; - editor
    change.b
    
    align._s_align
  EndStructure
  
  ;- - _s_text
  Structure _s_text Extends _s_coordinate
    big.l[3]
    pos.l
    len.l
    caret.l[3] ; 0 = Pos ; 1 = PosFixed
    
    fontID.i
    string.s[3]
    change.b
    
    pass.b
    lower.b
    upper.b
    numeric.b
    editable.b
    multiLine.b
    vertical.b
    rotate.f
    
    align._s_align
  EndStructure
  
  ;- - _s_items
  Structure _s_items Extends _s_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *i_parent._s_items
    drawing.i
    
    image._s_image
    text._s_text[4]
    *box._s_box[2]
    
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
  
  ;- - _s_bar
  Structure _S_bar
    pos.l 
    ;len.l
    
    max.l
    min.l
    
    ; \type = #PB_GadgetType_ScrollBar
    ; \type = #PB_GadgetType_ProgressBar
    ; \type = #PB_GadgetType_TrackBar
    ; \type = #PB_GadgetType_Splitter
    type.l
    
    ; \hide = Bool(\page\len >= (\max-\min))
    hide.b
    change.l
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    page._S_page
    area._S_page
    thumb._S_page  
    
    ; \button\[#bb_1] = (left&top) 
    ; \button\[#bb_2] = (right&bottom) 
    ; \button\[#bb_3] = (thumb)
    button._S_button[4]
  EndStructure
  
  ;- - _s_tab
  Structure _s_tab
    index.l[3]    ; index[0]-parent tab  ; inex[1]-entered tab ; index[2]-selected tab
    count.l       ; count tab items
    opened.l      ; parent open list item id
    scrolled.l    ; panel set state tab
    bar._s_bar
    
    List tabs._s_items()
  EndStructure
  
  ;- - _s_splitter
  Structure _s_splitter
    *first._s_widget
    *second._s_widget
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll
    y.l
    x.l
    height.l[4] ; - EditorGadget
    width.l[4]
    
    *v._s_widget
    *h._s_widget
  EndStructure
  
  ;- - _s_popup
  Structure _s_popup
    gadget.i
    window.i
    
    ; *Widget._s_widget
  EndStructure
  
  ;- - _s_margin
  Structure _s_margin
    FonyID.i
    Width.i
    Color._s_color
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget ; Extends _s_bar
    y.l[5]
    x.l[5]
    height.l[5]
    width.l[5]
    
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    focus.b
    radius.a
    type.b[3] ; [2] for splitter
    from.l
    
    mode.l  ; track bar
    change.l[2]
    cursor.l[2]
    hide.b[2]
    vertical.b
    
    color._s_color[4]
    box._s_box[4]
    
    *splitter._s_splitter
    bar._S_bar
    
    *scroll._s_scroll 
    *parent._s_widget ; adress parent
    *root._s_root     ; adress root
    *window._s_widget ; adress window
    
    caption._s_caption
    
    resize.b
    
    adress.i
    drawing.i
    container.i
    countItems.i[2]
    interact.i
    *a_gadget._s_widget ; active gadget
    
    state.i
    *i_Parent._s_items
    *data
    
    *leave._s_widget
    
    *Popup._s_widget
    *option_group._s_widget
    
    fs.i 
    bs.i
    grid.i
    enumerate.i
    __height.i ; 
    
    class.s ; 
    level.l ; Вложенность виджета
    type_index.l
    type_count.l
    
    tab._s_tab
    List *childrens._s_widget()
    List *items._s_items()
    List *columns._s_widget()
    ;List *draws._s_items()
    
    flag._s_flag
    *text._s_text[4]
    *image._s_image[2]
    *align._s_align
    
    sublevellen.i
    drag.i[2]
    attribute.i
    repaint.i
    
    *event._s_event
    margin._s_margin
    *selector._s_transform[#Anchors+1]
  EndStructure
  
  ;- - _s_canvas
  Structure _s_canvas
    window.i
    gadget.i
    mouse._s_mouse
    keyboard._s_keyboard
  EndStructure
  
  ;- - _s_event
  Structure _s_event 
    *callback.pFunc
    *widget._s_widget
    type.l
    item.l
    *data
    
    ;*leave._s_widget  
    *enter._s_widget  
    *root._s_root
    
    ;draw.b
  EndStructure
  
  ;- - _s_root
  Structure _s_root Extends _s_widget
    canvas._s_canvas
    *opened._s_widget
    *active._s_widget
    
    *anchor._s_anchor
    
    eventbind.b
    List *eventlist._s_event()
  EndStructure
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *event._s_event = AllocateStructure(_s_event)
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Type()
    *event\type
  EndMacro
  
  Macro Data()
    *event\data
  EndMacro
  
  Macro Item()
    *event\item
  EndMacro
  
  Macro IsRoot(_this_)
    Bool(_this_ And _this_ = _this_\root)
  EndMacro
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  ;- - DRAG&DROP
  Macro DropText()
    DD::DropText(Widget::*value\this)
  EndMacro
  
  Macro DropAction()
    DD::DropAction(Widget::*value\this)
  EndMacro
  
  Macro DropImage(_image_, _depth_=24)
    DD::DropImage(Widget::*value\this, _image_, _depth_)
  EndMacro
  
  Macro DragText(_text_, _actions_=#PB_Drag_Copy)
    DD::Text(Widget::*value\this, _text_, _actions_)
  EndMacro
  
  Macro DragImage(_image_, _actions_=#PB_Drag_Copy)
    DD::Image(Widget::*value\this, _image_, _actions_)
  EndMacro
  
  Macro DragPrivate(_type_, _actions_=#PB_Drag_Copy)
    DD::Private(Widget::*value\this, _type_, _actions_)
  EndMacro
  
  Macro EnableDrop(_this_, _format_, _actions_, _private_type_=0)
    DD::EnableDrop(_this_, _format_, _actions_, _private_type_)
  EndMacro
  
  Macro SetAnchors(_this_)
    a_Set(_this_)
  EndMacro
  Macro GetAnchors(_this_)
    a_Get(_this_)
  EndMacro
  
  ;-
  ;- - DECLAREs
  ;-
  ;   Declare.s Class(Type.i)
  ;   Declare.i ClassType(Class.s)
  ;   Declare.i SetFont(*this, FontID.i)
  ;   Declare.i IsContainer(*this)
  ;   Declare.i Enumerate(*this.Integer, *Parent, parent_item.i=0)
  
  Declare.i ReDraw(*this=#Null)
  ;   Declare.i Draw(*this, childrens=0)
  ;   Declare.i Y(*this, Mode.i=0)
  ;   Declare.i X(*this, Mode.i=0)
  ;   Declare.i Width(*this, Mode.i=0)
  ;   Declare.i Height(*this, Mode.i=0)
  ;   Declare.i CountItems(*this)
  ;   Declare.i ClearItems(*this)
  ;   Declare.i RemoveItem(*this, Item.i)
  ;   Declare.b Hide(*this, State.b=-1)
  
  ;   Declare.i GetFocus()
  ;   Declare.i GetActive()
  Declare.i GetState(*this)
  ;   Declare.i GetButtons(*this)
  ;   Declare.i GetDeltaX(*this)
  ;   Declare.i GetDeltaY(*this)
  ;   Declare.i GetMouseX(*this)
  ;   Declare.i GetMouseY(*this)
  ;   Declare.i GetImage(*this)
  ;   Declare.i GetType(*this)
  ;   Declare.i GetData(*this)
  ;   Declare.s GetText(*this)
  ;   Declare.i GetAttribute(*this, Attribute.i)
  ;   Declare.i GetItemData(*this, Item.i)
  ;   Declare.i GetItemImage(*this, Item.i)
  Declare.s GetItemText(*this, Item.i, Column.i=0)
  ;   Declare.i GetItemAttribute(*this, Item.i, Attribute.i)
  
  ;   Declare.i GetLevel(*this)
  ;   Declare.i GetRoot(*this)
  ;   Declare.i GetGadget(*this)
  Declare.i GetWindow(*this)
  ;   Declare.i GetParent(*this)
  ;   Declare.i GetParentItem(*this)
  ;   Declare.i GetPosition(*this, Position.i)
  ;   Declare.i a_Get(*this, index.i=-1)
  ;   Declare.i GetCount(*this)
  ;   Declare.s GetClass(*this)
  
  ;   Declare.i SetTransparency(*this, Transparency.a)
  ;   Declare.i a_Set(*this)
  ;   Declare.s SetClass(*this, Class.s)
  Declare.i SetActive(*this)
  Declare.i SetState(*this, State.i)
  Declare.i SetAttribute(*this, Attribute.i, Value.i)
  Declare.i CallBack(*this, EventType.i, mouse_x=0, mouse_y=0)
  ;   Declare.i SetColor(*this, ColorType.i, Color.i, State.i=0, Item.i=0)
  ;   Declare.i SetImage(*this, Image.i)
  ;   Declare.i SetData(*this, *Data)
  Declare.i SetText(*this, Text.s)
  ;   Declare.i GetItemState(*this, Item.i)
  ;   Declare.i SetItemState(*this, Item.i, State.i)
  Declare.i From(*this, mouse_x.i, mouse_y.i)
  ;Declare.i SetPosition(*this, Position.i, *Widget_2 =- 1)
  ;Declare.i Free(*this)
  
  ;   Declare.i SetParent(*this, *Parent, parent_item.i=-1)
  ;   Declare.i SetAlignment(*this, Mode.i, Type.i=1)
  ;   Declare.i SetItemData(*this, Item.i, *Data)
  ;   Declare.i SetItemAttribute(*this, Item.i, Attribute.i, Value.i)
  ;   Declare.i SetItemText(*this, Item.i, Text.s)
  ;   Declare.i SetFlag(*this, Flag.i)
  ;   Declare.i SetItemImage(*this, Item.i, Image.i)
  
  Declare.i AddItem(*this, Item.i, Text.s, Image.i=-1, Flag.i=0)
  ;   Declare.i AddColumn(*this, Position.i, Title.s, Width.i)
  Declare.i Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.i Popup(*Widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
  ;   Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  ;   Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
  ;   Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0)
  ;   Declare.i Image(X.l,Y.l,Width.l,Height.l, Image.i, Flag.i=0)
  Declare.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1)
  ;   Declare.i Text(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  ;   Declare.i Property(X.l,Y.l,Width.l,Height.l, SplitterPos.i = 80, Flag.i=0)
  ;   Declare.i String(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  ;   Declare.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  ;   Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  Declare.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  ;   Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i=0)
  ;   Declare.i ListView(X.l,Y.l,Width.l,Height.l, Flag.i=0)
     Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
  ;   Declare.i ListIcon(X.l,Y.l,Width.l,Height.l, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  Declare.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *Widget=0)
  ;   Declare.i ExplorerList(X.l,Y.l,Width.l,Height.l, Directory.s, Flag.i=0)
  ;   Declare.i IPAddress(X.l,Y.l,Width.l,Height.l)
  ;   Declare.i Editor(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  ;   
     Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
     Declare.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
  ;   Declare.i Container(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  ;   Declare.i Frame(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0)
  ;   Declare.i Panel(X.l,Y.l,Width.l,Height.l, Flag.i=0)
  
  Declare.i CloseList()
  Declare.i OpenList(*this, Item.l=0)
  Declare.i Bind(*callback, *this=#PB_All, eventtype.l=#PB_All)
  Declare.i Post(eventtype.l, *this, eventitem.l=#PB_All, *data=0)
  Declare.i Open(Window.i, X.l,Y.l,Width.l,Height.l, Text.s="", Flag.i=0, WindowID.i=0)
  ;   Declare.i Create(Type.i, X.l,Y.l,Width.l,Height.l, Text.s, Param_1.i=0, Param_2.i=0, Param_3.i=0, Flag.i=0, Parent.i=0, parent_item.i=0)
  
  ;Declare.i Resizes(*Scroll, X.l,Y.l,Width.l,Height.l)
  
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
  Declare.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
  
  Macro _init_default_value_(_this_, _event_type_)
    Select _event_type_
      Case #PB_EventType_Repaint
        Debug " -- Canvas repaint -- " + _this_\row\draw
      Case #PB_EventType_MouseWheel
        _this_\root\canvas\mouse\wheel\y = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_WheelDelta)
      Case #PB_EventType_Input 
        _this_\root\canvas\input = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Input)
      Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
        _this_\root\canvas\Key = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Key)
        _this_\root\canvas\Key[1] = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Modifiers)
      Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
        _this_\root\canvas\mouse\x = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_MouseX)
        _this_\root\canvas\mouse\y = GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_MouseY)
        
      Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
           #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
           #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
        
        _this_\root\canvas\mouse\buttons = (Bool(_event_type_ = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                           (Bool(_event_type_ = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                           (Bool(_event_type_ = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
        
    EndSelect
  EndMacro
EndDeclareModule

Module Widget
  ;- MODULE
  ;
  Declare.i g_Callback()
  Declare.i w_Events(*this, EventType.i, EventItem.i=-1, EventData.i=0)
  Declare.i Events(*this, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
  
  ;- GLOBALs
  Global def_colors._s_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#s_0] = $80000000
    \fore[#s_0] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#s_0] = $FFE2E2E2 ; $80E2E2E2
    \frame[#s_0] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#s_1] = $80000000
    \fore[#s_1] = $FFEAEAEA ; $FFFAF8F8
    \back[#s_1] = $FFCECECE ; $80FCEADA
    \frame[#s_1] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#s_2] = $FFFEFEFE
    \fore[#s_2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#s_2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#s_2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#s_3] = $FFBABABA
    \fore[#s_3] = $FFF6F6F6 
    \back[#s_3] = $FFE2E2E2 
    \frame[#s_3] = $FFBABABA
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
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
  
  Macro _set_image_(_this_, _item_, _image_)
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
      ;_this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    Else
      _item_\image\index =- 1
      _item_\image\handle = 0
      _item_\image\width = 0
      _item_\image\height = 0
      ;_this_\row\sublevel = 0
    EndIf
  EndMacro
  
  Macro GetAdress(_this_)
    _this_\adress
  EndMacro
  
  
  ;-
  Macro set_cursor(_this_, _cursor_)
    SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
  EndMacro
  
  Macro Get_Cursor(_this_)
    GetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor)
  EndMacro
  
  Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    *event\widget = _this_
    _this_\type = _type_
    _this_\class = #PB_Compiler_Procedure
    
    ; Set parent
    If _parent_
      SetParent(_this_, _parent_, _parent_\tab\opened)
    EndIf
    
    ; _set_auto_size_
    If Bool(_flag_ & #PB_Flag_AutoSize=#PB_Flag_AutoSize) : x=0 : y=0
      _this_\align = AllocateStructure(_s_align)
      _this_\align\autoSize = 1
      _this_\align\left = 1
      _this_\align\top = 1
      _this_\align\right = 1
      _this_\align\bottom = 1
    EndIf
    
    If Bool(_flag_ & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
      
      a_Add(_this_)
      a_Set(_this_)
      
    EndIf
    
  EndMacro
  
  ;-
  ; SCROLLBAR
  Macro _childrens_move_(_this_, _change_x_, _change_y_)
    If ListSize(_this_\childrens())
      ForEach _this_\childrens()
        Resize(_this_\childrens(), 
               (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_,
               (_this_\childrens()\y-_this_\y-_this_\bs-_this_\__height) + _change_y_, 
               #PB_Ignore, #PB_Ignore)
      Next
    EndIf
  EndMacro
  
  Procedure.b splitter_size(*this._s_widget)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\first, *this\bar\button[#bb_1]\x, (*this\bar\button[#bb_2]\height+*this\bar\thumb\len)-*this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\bar\button[#bb_1]\x, *this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\bar\button[#bb_1]\x, *this\bar\button[#bb_1]\y, *this\bar\button[#bb_1]\width, *this\bar\button[#bb_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\second, *this\bar\button[#bb_2]\x, (*this\bar\button[#bb_1]\height+*this\bar\thumb\len)-*this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\bar\button[#bb_2]\x, *this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\bar\button[#bb_2]\x, *this\bar\button[#bb_2]\y, *this\bar\button[#bb_2]\width, *this\bar\button[#bb_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  Macro _bar_splitter_size_(_this_)
    If _this_\bar\Vertical
      Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\bar\thumb\pos-_this_\y)
      Resize(_this_\splitter\second, 0, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y))
    Else
      Resize(_this_\splitter\first, 0, 0, _this_\bar\thumb\pos-_this_\x, _this_\height)
      Resize(_this_\splitter\second, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x, 0, _this_\width-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\bar\area\pos + Round((_scroll_pos_-_this_\bar\min) * (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)), #PB_Round_Nearest)) 
  EndMacro
  
  Macro _thumb_len_(_this_)
    Round(_this_\bar\area\len - (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)) * ((_this_\bar\max-_this_\bar\min) - _this_\bar\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro _bar_update_v_scroll_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\y-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_-_this_\y))) Or
         Bool((_pos_-_this_\y-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              Bar_SetState(_this_, (_pos_-_this_\y) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  Macro _bar_update_h_scroll_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\x-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_-_this_\x))) Or
         Bool((_pos_-_this_\x-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              Bar_SetState(_this_, (_pos_-_this_\x) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  ; Inverted scroll bar position
  Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ; Then scroll bar start position
  Macro _bar_in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _bar_in_stop_(_bar_) : Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) : EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#bb_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#bb_1]\len + _this_\bar\button[#bb_2]\len)
    Else
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#bb_1]\len
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#bb_1]\len + _this_\bar\button[#bb_2]\len)
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len-_this_\bar\thumb\len)
  EndMacro
  
  Macro _bar_set_thumb_pos_(_this_, _scroll_pos_)
    _thumb_pos_(_this_, _scroll_pos_)
    
    If _this_\bar\thumb\pos < _this_\bar\area\pos 
      _this_\bar\thumb\pos = _this_\bar\area\pos 
    EndIf 
    
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
    
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
    
    ; _start_
    If _this_\bar\button[#bb_1]\len And _this_\bar\page\len
      If _scroll_pos_ = _this_\bar\min
        _this_\bar\button[#bb_1]\Color\state = #s_3
        _this_\bar\button[#bb_1]\interact = 0
      Else
        If _this_\bar\button[#bb_1]\Color\state <> #s_2
          _this_\bar\button[#bb_1]\Color\state = #s_0
        EndIf
        _this_\bar\button[#bb_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type=#PB_GadgetType_ScrollBar
      If _this_\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\bar\button[#bb_1]\x = _this_\bar\button\x
        _this_\bar\button[#bb_1]\y = _this_\Y 
        _this_\bar\button[#bb_1]\width = _this_\bar\button\width
        _this_\bar\button[#bb_1]\height = _this_\bar\button[#bb_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\bar\button[#bb_1]\x = _this_\X 
        _this_\bar\button[#bb_1]\y = _this_\bar\button\y
        _this_\bar\button[#bb_1]\width = _this_\bar\button[#bb_1]\len 
        _this_\bar\button[#bb_1]\height = _this_\bar\button\height 
      EndIf
    Else
      _this_\bar\button[#bb_1]\x = _this_\X
      _this_\bar\button[#bb_1]\y = _this_\Y
      
      If _this_\bar\vertical
        _this_\bar\button[#bb_1]\width = _this_\width
        _this_\bar\button[#bb_1]\height = _this_\bar\thumb\pos-_this_\y
      Else
        _this_\bar\button[#bb_1]\width = _this_\bar\thumb\pos-_this_\x
        _this_\bar\button[#bb_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\bar\button[#bb_2]\len And _this_\bar\page\len
      ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
      If _scroll_pos_ = _this_\bar\page\end
        _this_\bar\button[#bb_2]\Color\state = #s_3
        _this_\bar\button[#bb_2]\interact = 0
      Else
        If _this_\bar\button[#bb_2]\Color\state <> #s_2
          _this_\bar\button[#bb_2]\Color\state = #s_0
        EndIf
        _this_\bar\button[#bb_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\bar\type = #PB_GadgetType_ScrollBar
      If _this_\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\bar\button[#bb_2]\x = _this_\bar\button\x
        _this_\bar\button[#bb_2]\width = _this_\bar\button\width
        _this_\bar\button[#bb_2]\height = _this_\bar\button[#bb_2]\len 
        _this_\bar\button[#bb_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#bb_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\bar\button[#bb_2]\y = _this_\bar\button\y
        _this_\bar\button[#bb_2]\height = _this_\bar\button\height
        _this_\bar\button[#bb_2]\width = _this_\bar\button[#bb_2]\len 
        _this_\bar\button[#bb_2]\x = _this_\X+_this_\width-_this_\bar\button[#bb_2]\width 
      EndIf
      
    Else
      If _this_\bar\vertical
        _this_\bar\button[#bb_2]\x = _this_\x
        _this_\bar\button[#bb_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#bb_2]\width = _this_\width
        _this_\bar\button[#bb_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
      Else
        _this_\bar\button[#bb_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#bb_2]\y = _this_\Y
        _this_\bar\button[#bb_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
        _this_\bar\button[#bb_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\bar\thumb\len
      If _this_\bar\button[#bb_3]\len <> _this_\bar\thumb\len
        _this_\bar\button[#bb_3]\len = _this_\bar\thumb\len
      EndIf
      
      If _this_\bar\vertical
        _this_\bar\button[#bb_3]\x = _this_\bar\button\x 
        _this_\bar\button[#bb_3]\width = _this_\bar\button\width 
        _this_\bar\button[#bb_3]\y = _this_\bar\thumb\pos
        _this_\bar\button[#bb_3]\height = _this_\bar\thumb\len                              
      Else
        _this_\bar\button[#bb_3]\y = _this_\bar\button\y 
        _this_\bar\button[#bb_3]\height = _this_\bar\button\height
        _this_\bar\button[#bb_3]\x = _this_\bar\thumb\pos 
        _this_\bar\button[#bb_3]\width = _this_\bar\thumb\len                                  
      EndIf
      
    ElseIf _this_\bar\type <> #PB_GadgetType_ProgressBar
      ; Эфект спин гаджета
      If _this_\bar\vertical
        _this_\bar\button[#bb_2]\Height = _this_\Height/2 
        _this_\bar\button[#bb_2]\y = _this_\y+_this_\bar\button[#bb_2]\Height+Bool(_this_\Height%2) 
        
        _this_\bar\button[#bb_1]\y = _this_\y 
        _this_\bar\button[#bb_1]\Height = _this_\Height/2
        
      Else
        _this_\bar\button[#bb_2]\width = _this_\width/2 
        _this_\bar\button[#bb_2]\x = _this_\x+_this_\bar\button[#bb_2]\width+Bool(_this_\width%2) 
        
        _this_\bar\button[#bb_1]\x = _this_\x 
        _this_\bar\button[#bb_1]\width = _this_\width/2
      EndIf
    EndIf
    
    ;     If _this_\bar\text
    ;       _this_\bar\text\change = 1
    ;     EndIf
    ;     
    ; Splitter childrens auto resize       
    If _this_\Splitter And _this_\bar\change
      ;splitter_size(_this_)
      ;     If \type = #PB_GadgetType_Spin
      ;                 \text\string.s[1] = Str(\bar\page\pos) : \text\change = 1
      ;                 
      ;               ElseIf \type = #PB_GadgetType_Splitter
      _bar_splitter_size_(_this_)
    EndIf
    
    ; ScrollArea childrens auto resize 
    If _this_\parent And _this_\bar\change
      _this_\parent\change =- 1
      
      If _this_\parent\scroll
        If _this_\bar\vertical
          _this_\parent\scroll\y =- _this_\bar\page\pos 
          _childrens_move_(_this_\parent, 0, _this_\bar\change)
        Else
          _this_\parent\scroll\x =- _this_\bar\page\pos
          _childrens_move_(_this_\parent, _this_\bar\change, 0)
        EndIf
      EndIf
    EndIf
    
    ;     If _this_\bar\change
    ;       Post(#PB_EventType_StatusChange, _this_, _this_\bar\from, _this_\bar\direction)
    ;     EndIf
  EndMacro
  
  Procedure.i Bar_ChangePos(*bar._S_bar, ScrollPos.i)
    With *bar
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
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
  
  Procedure.b Bar_Update(*this._s_widget)
    With *this
      ;
      If (\bar\max-\bar\min) >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \bar\max And \width And \height
          \bar\max = \bar\area\len-\bar\button\len
          
          If Not \bar\page\pos
            \bar\page\pos = \bar\max/2
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #bb_1
          ;             \splitter\fixed[\splitter\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #bb_2
          ;             \splitter\fixed[\splitter\fixed] = \bar\area\len-\bar\page\pos-\bar\button\len
          ;           EndIf
        EndIf
        
        ;
        If \splitter 
          If \splitter\fixed
            If \bar\area\len - \bar\button\len > \splitter\fixed[\splitter\fixed] 
              \bar\page\pos = Bool(\splitter\fixed = 2) * \bar\max
              
              If \splitter\fixed[\splitter\fixed] > \bar\button\len
                \bar\area\pos + \splitter\fixed[1]
                \bar\area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \bar\area\len - \bar\button\len
              \bar\page\pos = Bool(\splitter\fixed = 1) * \bar\max
            EndIf
          EndIf
          
          ; Debug ""+\bar\area\len +" "+ Str(\bar\button[#bb_1]\len + \bar\button[#bb_2]\len)
          
          If \bar\area\len =< \bar\button\len
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
        
        If \bar\area\len > \bar\button\len
          \bar\thumb\len = Round(\bar\area\len - (\bar\area\len / (\bar\max-\bar\min)) * ((\bar\max-\bar\min) - \bar\page\len), #PB_Round_Nearest)
          
          If \bar\thumb\len > \bar\area\len 
            \bar\thumb\len = \bar\area\len 
          EndIf 
          
          If \bar\thumb\len > \bar\button\len
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
          Else
            \bar\area\len = \bar\area\len - (\bar\button\len-\bar\thumb\len)
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)                              
            \bar\thumb\len = \bar\button\len
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
        
        If \bar\area\len  
          \bar\page\end = \bar\max - \bar\page\len
          \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
          ; Debug " line-" + #PB_Compiler_Line +" "+  \bar\thumb\pos +" "+ \bar\area\end +" "+ \bar\area\len
          
          If \bar\thumb\pos = \bar\area\end And \bar\type = #PB_GadgetType_ScrollBar
            SetState(*this, \bar\max)
          EndIf
        EndIf
      EndIf
      
      If \bar\type = #PB_GadgetType_ScrollBar
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.i Bar_UpdatePos(*this._s_widget, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _set_area_coordinate_(*this)
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
        
        If (#PB_GadgetType_TrackBar = \bar\type Or \bar\type = #PB_GadgetType_ProgressBar) And \bar\vertical
          ScrollPos = _bar_invert_(*this\bar, ScrollPos, \bar\inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Bar_SetState(*this._s_widget, ScrollPos.l)
    Protected Result.b
    
    With *this
      If Bar_ChangePos(*this\bar, ScrollPos)
        \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, ScrollPos, \bar\inverted))
        
        If \splitter And \splitter\fixed = #bb_1
          \splitter\fixed[\splitter\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        
        If \splitter And \splitter\fixed = #bb_2
          \splitter\fixed[\splitter\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#bb_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#bb_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
      Else
        Select Attribute
          Case #PB_Bar_Minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              Result = #True
            EndIf
            
          Case #PB_Bar_Maximum
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
            
          Case #PB_Bar_PageLength
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
            
          Case #PB_Bar_ScrollStep 
            \bar\scrollstep = Value
            
          Case #PB_Bar_ButtonSize
            If \bar\button\len <> Value
              \bar\button\len = Value
              \bar\button[#bb_1]\len = Value
              \bar\button[#bb_2]\len = Value
              Result = #True
            EndIf
            
          Case #PB_Bar_Inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _bar_set_thumb_pos_(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
            EndIf
            
        EndSelect
      EndIf
      
      If Result
        \hide = Bar_Update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  ;- Anchors
  Macro a_Draw(_this_)
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
      ;If _this_\root\anchor\id[#a_moved] : Box(_this_\root\anchor\id[#a_moved]\x, _this_\root\anchor\id[#a_moved]\y, _this_\root\anchor\id[#a_moved]\width, _this_\root\anchor\id[#a_moved]\height ,_this_\root\anchor\id[#a_moved]\color[_this_\root\anchor\id[#a_moved]\color\state]\frame) : EndIf
      
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
  
  Macro a_Resize(_this_)
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
    
    If _this_\root\anchor\id[#a_moved] 
      _this_\root\anchor\id[#a_moved]\x = _this_\x
      _this_\root\anchor\id[#a_moved]\y = _this_\y
      _this_\root\anchor\id[#a_moved]\width = _this_\width
      _this_\root\anchor\id[#a_moved]\height = _this_\height
    EndIf
    
    If _this_\root\anchor\id[10] And _this_\root\anchor\id[11] And _this_\root\anchor\id[12] And _this_\root\anchor\id[13]
      a_Lines(_this_)
    EndIf
    
  EndMacro
  
  Procedure a_Lines(*Gadget._s_widget=-1, distance=0)
    Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    With *Gadget
      If *Gadget
        checked_x1 = \x
        checked_y1 = \y
        checked_x2 = checked_x1+\width
        checked_y2 = checked_y1+\height
        
        top_x1 = checked_x1 : top_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 
        right_y1 = checked_y1 : right_y2 = checked_y2
        bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        
        If \parent And ListSize(\parent\childrens())
          PushListPosition(\parent\childrens())
          ForEach \parent\childrens()
            If Not \parent\childrens()\hide
              relative_x1 = \parent\childrens()\x
              relative_y1 = \parent\childrens()\y
              relative_x2 = relative_x1+\parent\childrens()\width
              relative_y2 = relative_y1+\parent\childrens()\height
              
              ;Left_line
              If checked_x1 = relative_x1
                If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                
                ; \root\anchor\id[10]\color[0]\frame = $0000FF
                \root\anchor\id[10]\hide = 0
                \root\anchor\id[10]\x = checked_x1
                \root\anchor\id[10]\y = left_y1
                \root\anchor\id[10]\width = ls
                \root\anchor\id[10]\height = left_y2-left_y1
              Else
                ; \root\anchor\id[10]\color[0]\frame = $000000
                \root\anchor\id[10]\hide = 1
              EndIf
              
              ;Right_line
              If checked_x2 = relative_x2
                If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                
                \root\anchor\id[12]\hide = 0
                \root\anchor\id[12]\x = checked_x2-ls
                \root\anchor\id[12]\y = right_y1
                \root\anchor\id[12]\width = ls
                \root\anchor\id[12]\height = right_y2-right_y1
              Else
                \root\anchor\id[12]\hide = 1
              EndIf
              
              ;Top_line
              If checked_y1 = relative_y1 
                If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                
                \root\anchor\id[11]\hide = 0
                \root\anchor\id[11]\x = top_x1
                \root\anchor\id[11]\y = checked_y1
                \root\anchor\id[11]\width = top_x2-top_x1
                \root\anchor\id[11]\height = ls
              Else
                \root\anchor\id[11]\hide = 1
              EndIf
              
              ;Bottom_line
              If checked_y2 = relative_y2 
                If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                
                \root\anchor\id[13]\hide = 0
                \root\anchor\id[13]\x = bottom_x1
                \root\anchor\id[13]\y = checked_y2-ls
                \root\anchor\id[13]\width = bottom_x2-bottom_x1
                \root\anchor\id[13]\height = ls
              Else
                \root\anchor\id[13]\hide = 1
              EndIf
            EndIf
          Next
          PopListPosition(\parent\childrens())
        EndIf
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i a_Add(*this._s_widget, Size.l=6, Pos.l=-1)
    Structure DataBuffer
      cursor.i[#Anchors+1]
    EndStructure
    
    Protected i, *Cursor.DataBuffer = ?CursorsBuffer
    
    With *this
      \flag\transform = 1
      If Pos=-1
        Pos = Size-3
      EndIf
      
      If Not \root\anchor
        \root\anchor = AllocateStructure(_s_anchor)
        \root\anchor\index = #a_moved
        \root\anchor\pos = Pos
        \root\anchor\size = Size
        
        For i = 0 To #Anchors
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
  
  Procedure.i a_Get(*this._s_widget, index.i=-1)
    ProcedureReturn Bool(*this\root\anchor\id[(Bool(index.i=-1) * #a_moved) + (Bool(index.i>0) * index)]) * *this
  EndProcedure
  
  Procedure.i a_Set(*this._s_widget)
    Protected Result.i
    Static *LastPos
    
    With *this
      If Not (\parent And 
              (\parent\scroll And (*this = \parent\scroll\v Or *this = \parent\scroll\h)) Or 
              (\parent\splitter And (*this = \parent\splitter\first Or *this = \parent\splitter\second Or \from = #bb_3)))
        
        If \root\anchor\index = #a_moved And \root\anchor\widget <> *this
          ;         If \root\anchor\widget
          ;           If *LastPos
          ;             ; Возврашаем на место
          ;             SetPosition(\root\anchor\widget, #PB_List_Before, *LastPos)
          ;             *LastPos = 0
          ;           EndIf
          ;         EndIf
          ;         
          ;         *LastPos = GetPosition(*this, #PB_List_After)
          ;         If *LastPos
          ;           SetPosition(*this, #PB_List_Last)
          ;         EndIf
          
          \root\anchor\widget = *this
          
          If \container
            \root\anchor\id[5]\width = \root\anchor\size * 2
            \root\anchor\id[5]\height = \root\anchor\size * 2
          Else
            \root\anchor\id[5]\width = \root\anchor\size
            \root\anchor\id[5]\height = \root\anchor\size
          EndIf
          
          a_Resize(*this)
          Result = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i a_Remove(*this._s_widget)
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
  
  Procedure a_Callback(*this._s_widget, EventType.i, Buttons.i, mouse_x.i,mouse_y.i)
    Protected result, i 
    
    With *this
      If \root\anchor 
        Select EventType 
          Case #PB_EventType_MouseMove
            If \root\anchor\id[\root\anchor\index]\color\state = #s_2
              *this = \root\anchor\widget
              mouse_x-\root\anchor\delta\x
              mouse_y-\root\anchor\delta\y
              
              Protected.i Px,Py, Grid = \grid, IsGrid = Bool(Grid>1)
              
              If \parent
                Px = \parent\x[2]
                Py = \parent\y[2]
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
                  
                Case #a_moved 
                  If Not \container
                    If  Not \root\anchor\cursor 
                      Set_Cursor(*this, \root\anchor\id[\root\anchor\index]\cursor)
                      \root\anchor\cursor = 1
                    EndIf
                    
                    result = Resize(*this, mx, my, #PB_Ignore, #PB_Ignore)
                  EndIf
              EndSelect
              
            ElseIf Not Buttons
              ; From point anchor
              For i = #Anchors To 0 Step - 1
                If \root\anchor\id[i] And _from_point_(mouse_x, mouse_y, \root\anchor\id[i]) 
                  If i <> #a_moved And Not \root\anchor\cursor
                    If \container And i = 5
                      Set_Cursor(*this, \root\anchor\id[#a_moved]\cursor)
                    Else
                      Set_Cursor(*this, \root\anchor\id[i]\cursor)
                    EndIf
                    \root\anchor\cursor = 1
                  EndIf
                  \root\anchor\id[i]\color\state = 1
                  \root\anchor\index = i
                  Break
                Else
                  \root\anchor\id[i]\color\state = 0
                  If \root\anchor\cursor
                    Set_Cursor(*this, \root\anchor\id[0]\cursor)
                    \root\anchor\cursor = 0
                  EndIf
                EndIf
              Next
            EndIf
            
          Case #PB_EventType_LeftButtonDown  
            If \root\flag\transform
              If a_Set(*this)
              EndIf
              \flag\transform = 1
            EndIf
            
            If \flag\transform
              If _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                \root\anchor\delta\x = mouse_x-\root\anchor\id[\root\anchor\index]\x
                \root\anchor\delta\y = mouse_y-\root\anchor\id[\root\anchor\index]\y
                \root\anchor\id[\root\anchor\index]\color\state = #s_2
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            If \flag\transform
              If \root\anchor\cursor And Not _from_point_(mouse_x, mouse_y, \root\anchor\id[\root\anchor\index]) 
                Set_Cursor(*this, \root\anchor\id[0]\cursor)
                \root\anchor\cursor = 0
              EndIf
              
              \root\anchor\id[\root\anchor\index]\color\state = 0
              \root\anchor\index = 0
            EndIf
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn result
  EndProcedure
  
  
  ;-
  ;- DRAWPOPUP
  ;-
  Procedure CallBack_Popup()
    Protected *this._s_widget = GetWindowData(EventWindow())
    Protected EventItem.i
    Protected mouse_x =- 1
    Protected mouse_y =- 1
    
    If *this
      With *this
        Select Event()
          Case #PB_Event_ActivateWindow
            Protected *Widget._s_widget = GetGadgetData(\root\canvas\gadget)
            
            If CallBack(\childrens(), #PB_EventType_LeftButtonDown, WindowMouseX(\root\canvas\window), WindowMouseY(\root\canvas\window))
              ; If \childrens()\index[#s_2] <> \childrens()\index[#s_1]
              *Widget\index[#s_2] = \childrens()\index[#s_1]
              Post(#PB_EventType_Change, *Widget, \childrens()\index[#s_1])
              
              SetText(*Widget, GetItemText(\childrens(), \childrens()\index[#s_1]))
              \childrens()\index[#s_2] = \childrens()\index[#s_1]
              ;\childrens()\canvas\mouse\buttons = 0
              \childrens()\index[#s_1] =- 1
              \childrens()\focus = 1
              ;\canvas\mouse\buttons = 0
              ReDraw(*this)
              ; EndIf
            EndIf
            
            SetActiveGadget(*Widget\root\canvas\gadget)
            *Widget\color\state = 0
            ;                 *Widget\box\checked = 0
            SetActive(*Widget)
            ReDraw(*Widget\root)
            HideWindow(\root\canvas\window, 1)
            
          Case #PB_Event_Gadget
            mouse_x = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            mouse_y= GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
            
            If CallBack(From(*this, mouse_x, mouse_y), EventType(), mouse_x, mouse_y)
              ReDraw(*this)
            EndIf
            
        EndSelect
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Display_Popup(*this._s_widget, *Widget._s_widget, x.i=#PB_Ignore,y.i=#PB_Ignore)
    With *this
      If X=#PB_Ignore 
        X = \x+GadgetX(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        
        ForEach *Widget\childrens()\items()
          If *Widget\childrens()\items()\text\change = 1
            *Widget\childrens()\items()\text\height = TextHeight("A")
            *Widget\childrens()\items()\text\width = TextWidth(*Widget\childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\childrens()\scroll\width < (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
            *Widget\childrens()\scroll\width = (10+*Widget\childrens()\items()\text\width)+*Widget\childrens()\scroll\h\bar\page\pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      SetActive(*Widget\childrens())
      ;*Widget\childrens()\focus = 1
      
      Protected Width = *Widget\childrens()\scroll\width + *Widget\childrens()\bs*2 
      Protected Height = *Widget\childrens()\scroll\height + *Widget\childrens()\bs*2 
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, #PB_Ignore,#PB_Ignore, width, Height )
      If *Widget\resize
        ResizeWindow(*Widget\root\canvas\window, x, y, width, Height)
        ResizeGadget(*Widget\root\canvas\gadget, #PB_Ignore, #PB_Ignore, width, Height)
      EndIf
    EndWith
    
    ReDraw(*Widget)
    
    HideWindow(*Widget\root\canvas\window, 0, #PB_Window_NoActivate)
  EndProcedure
  
  Procedure.i Popup(*Widget._s_widget, X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    With *this
      If *this
        \root = *this
        \type = #PB_GadgetType_Popup
        \container = #PB_GadgetType_Popup
        \color = def_colors
        \color\fore = 0
        \color\back = $FFF0F0F0
        \color\alpha = 255
        \color[1]\alpha = 128
        \color[2]\alpha = 128
        \color[3]\alpha = 128
        
        If X=#PB_Ignore 
          X = *Widget\x+GadgetX(*Widget\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\root\canvas\gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        If IsWindow(*Widget\root\canvas\window)
          Protected WindowID = WindowID(*Widget\root\canvas\window)
        EndIf
        
        \root\parent = *Widget
        \root\canvas\window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \root\canvas\gadget = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(\root, 1,1, width, Height)
        
        SetWindowData(\root\canvas\window, *this)
        SetGadgetData(\root\canvas\gadget, *Widget)
        
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \root\canvas\window);, \canvas\gadget )
        BindGadgetEvent(\root\canvas\gadget, @CallBack_Popup())
      EndIf
    EndWith  
    
    ProcedureReturn *this
  EndProcedure
  
  
  
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
  
  Procedure.i Resizes(*Scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
    With *Scroll
      Protected iHeight, iWidth
      
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
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\radius And \h\radius)*(\v\bar\button\len/4+1), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\v\radius And \h\radius)*(\h\bar\button\len/4+1))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Procedure Move(*this._s_widget, Width)
    Protected Left,Right
    
    With *this
      Right =- TextWidth(Mid(\text\string.s, \items()\text\pos, \text\caret))
      Left = (Width + Right)
      
      If \scroll\x < Right
        ; Scroll::SetState(\scroll\h, -Right)
        \scroll\x = Right
      ElseIf \scroll\x > Left
        ; Scroll::SetState(\scroll\h, -Left) 
        \scroll\x = Left
      ElseIf (\scroll\x < 0 And \root\canvas\keyboard\input = 65535 ) : \root\canvas\keyboard\input = 0
        \scroll\x = (Width-\items()\text[3]\width) + Right
        If \scroll\x>0 : \scroll\x=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  ; SET_
  Procedure.i Set_State(*this._s_widget, List *this_item._s_items(), State.i)
    Protected Repaint.i, sublevel.i, Mouse_X.i, Mouse_Y.i
    
    With *this
      If ListSize(*this_item())
        Mouse_X = \root\canvas\mouse\x
        Mouse_Y = \root\canvas\mouse\y
        
        If State >= 0 And SelectElement(*this_item(), State) 
          If (Mouse_Y > (*this_item()\box[1]\y) And Mouse_Y =< ((*this_item()\box[1]\y+*this_item()\box[1]\height))) And 
             ((Mouse_X > *this_item()\box[1]\x) And (Mouse_X =< (*this_item()\box[1]\x+*this_item()\box[1]\width)))
            
            *this_item()\box[1]\checked ! 1
          ElseIf (\flag\buttons And *this_item()\childrens) And
                 (Mouse_Y > (*this_item()\box[0]\y) And Mouse_Y =< ((*this_item()\box[0]\y+*this_item()\box[0]\height))) And 
                 ((Mouse_X > *this_item()\box[0]\x) And (Mouse_X =< (*this_item()\box[0]\x+*this_item()\box[0]\width)))
            
            sublevel = *this_item()\sublevel
            *this_item()\box[0]\checked ! 1
            \change = 1
            
            PushListPosition(*this_item())
            While NextElement(*this_item())
              If sublevel = *this_item()\sublevel
                Break
              ElseIf sublevel < *this_item()\sublevel And *this_item()\i_Parent
                *this_item()\hide = Bool(*this_item()\i_Parent\box[0]\checked | *this_item()\i_Parent\hide)
              EndIf
            Wend
            PopListPosition(*this_item())
            
          ElseIf \index[#s_2] <> State : *this_item()\state = 2
            If \index[#s_2] >= 0 And SelectElement(*this_item(), \index[#s_2])
              *this_item()\state = 0
            EndIf
            ; GetState() - Value = \index[#s_2]
            \index[#s_2] = State
            
            Debug "set_state() - "+State;\index[#s_1]+" "+ListIndex(\items())
                                        ; Post change event to widget (tree, listview)
            w_Events(*this, #PB_EventType_Change, State)
          EndIf
          
          Repaint = 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure.s Text_Make(*this._s_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *this
      If \text\Numeric And Text.s <> #LF$
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
              left.s = Left(\text\string.s[1], \text\caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\text\string.s[1], \text\caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\text\string, \text\caret + 1, 1) = "."
                ;                 \text\caret + 1 : \text\caret[1]=\text\caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\text\string.s[1], \text\caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\text\string.s[1], \text\caret + 1, 1) <> "-"
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
          Case \text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  
  ;-
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
  
  Procedure.i Draw_Scroll(*this._s_widget)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *this 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\bar\area\pos+\bar\area\len) +" "+ \box[#bb_2]\x
      ;       Debug ""+Str(\bar\area\pos+\bar\area\len) +" "+ \box[#bb_2]\y
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
        ; Roundbox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \color\line[State_0]<>-1
        If \bar\Vertical
          Line( \x, \y, 1, \bar\page\len + Bool(\height<>\bar\page\len), \color\line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \x, \y, \bar\page\len + Bool(\width<>\bar\page\len), 1, \color\line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \bar\thumb\len 
        ; Draw thumb  
        If \color[3]\back[State_3]<>-1
          If \color[3]\fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[#bb_3]\x, \bar\button[#bb_3]\y, \bar\button[#bb_3]\width, \bar\button[#bb_3]\height, \color[3]\fore[State_3], \color[3]\back[State_3], \radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \color[3]\frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \bar\button[#bb_3]\x, \bar\button[#bb_3]\y, \bar\button[#bb_3]\width, \bar\button[#bb_3]\height, \radius, \radius, \color[3]\frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \bar\button[#bb_1]\len
        ; Draw buttons
        If \color[1]\back[State_1]<>-1
          If \color[1]\fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[1]\x, \bar\button[1]\y, \bar\button[1]\width, \bar\button[1]\height, \color[1]\fore[State_1], \color[1]\back[State_1], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[1]\frame[State_1]
          RoundBox( \bar\button[1]\x, \bar\button[1]\y, \bar\button[1]\width, \bar\button[1]\height, \radius, \radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \bar\button[1]\x+( \bar\button[1]\width-\bar\button[1]\arrow\size)/2, \bar\button[1]\y+( \bar\button[1]\height-\bar\button[1]\arrow\size)/2, \bar\button[1]\arrow\size, Bool( \bar\vertical),
               (Bool(Not _bar_in_start_(*this\bar)) * \color[1]\front[State_1] + _bar_in_start_(*this\bar) * \color[1]\frame[0])&$FFFFFF|Alpha, \bar\button[1]\arrow\type)
      EndIf
      
      If \bar\button[#bb_2]\len
        ; Draw buttons
        If \color[2]\back[State_2]<>-1
          If \color[2]\fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          _box_gradient_( \bar\vertical, \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width, \bar\button[#bb_2]\height, \color[2]\fore[State_2], \color[2]\back[State_2], \radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \color[2]\frame[State_2]
          RoundBox( \bar\button[#bb_2]\x, \bar\button[#bb_2]\y, \bar\button[#bb_2]\width, \bar\button[#bb_2]\height, \radius, \radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \bar\button[#bb_2]\x+( \bar\button[#bb_2]\width-\bar\button[2]\arrow\size)/2, \bar\button[#bb_2]\y+( \bar\button[#bb_2]\height-\bar\button[2]\arrow\size)/2, \bar\button[2]\arrow\size, Bool( \bar\Vertical)+2, 
               (Bool(Not _bar_in_stop_(*this\bar)) * \color[2]\front[State_2] + _bar_in_stop_(*this\bar) * \color[2]\frame[0])&$FFFFFF|Alpha, \bar\button[2]\arrow\type)
      EndIf
      
      If \bar\thumb\len And \color[3]\fore[State_3]<>-1  ; Draw thumb lines
        If \focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \bar\button[2]\arrow\size
        
        If \bar\Vertical
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2-3,size,1, LinesColor)
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2,size,1, LinesColor)
          Line( \bar\button[#bb_3]\x+(\bar\button[#bb_3]\width-(size-1))/2, \bar\button[#bb_3]\y+\bar\button[#bb_3]\height/2+3,size,1, LinesColor)
        Else
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2-3, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
          Line( \bar\button[#bb_3]\x+\bar\button[#bb_3]\width/2+3, \bar\button[#bb_3]\y+(\bar\button[#bb_3]\height-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*this._s_widget)
    ;     Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    ;     
    ;     With *this 
    ;       State_0 = \color[0]\state
    ;       State_1 = \color[1]\state
    ;       State_2 = \color[2]\state
    ;       State_3 = \color[3]\state
    ;       Alpha = \color\alpha<<24
    ;       LinesColor = \color[3]\front[State_3]&$FFFFFF|Alpha
    ;       
    ;       ; Draw scroll bar background
    ;       If \color\back[State_0]<>-1
    ;         DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    ;         RoundBox( \x[2], \y[2], \width[2], \height[2], \radius, \radius, \color\back[State_0]&$FFFFFF|Alpha)
    ;       EndIf
    ;       
    ;       ; Draw string
    ;       If \text\string
    ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
    ;         DrawText(\text\x, \text\y, \text\string, \color\front[State_3]&$FFFFFF|Alpha)
    ;       EndIf
    ;       ; Draw_String(*this._s_widget)
    ;       
    ;       If \box[#bb_2]\len
    ;         Protected Radius = \height[2]/7
    ;         If Radius > 4
    ;           Radius = 7
    ;         EndIf
    ;         
    ;         ; Draw buttons
    ;         If \color[1]\back[State_1]<>-1
    ;           If \color[1]\fore[State_1]
    ;             DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    ;           EndIf
    ;           _box_gradient_( \Vertical, \box[1]\x, \box[1]\y, \box[1]\width, \box[1]\height, \color[1]\fore[State_1], \color[1]\back[State_1], Radius, \color\alpha)
    ;         EndIf
    ;         
    ;         ; Draw buttons
    ;         If \color[2]\back[State_2]<>-1
    ;           If \color[2]\fore[State_2]
    ;             DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    ;           EndIf
    ;           _box_gradient_( \Vertical, \box[#bb_2]\x, \box[#bb_2]\y, \box[#bb_2]\width, \box[#bb_2]\height, \color[2]\fore[State_2], \color[2]\back[State_2], Radius, \color\alpha)
    ;         EndIf
    ;         
    ;         DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    ;         
    ;         ; Draw buttons frame
    ;         If \color[1]\frame[State_1]
    ;           RoundBox( \box[1]\x, \box[1]\y, \box[1]\width, \box[1]\height, Radius, Radius, \color[1]\frame[State_1]&$FFFFFF|Alpha)
    ;         EndIf
    ;         
    ;         ; Draw buttons frame
    ;         If \color[2]\frame[State_2]
    ;           RoundBox( \box[#bb_2]\x, \box[#bb_2]\y, \box[#bb_2]\width, \box[#bb_2]\height, Radius, Radius, \color[2]\frame[State_2]&$FFFFFF|Alpha)
    ;         EndIf
    ;         
    ;         ; Draw arrows
    ;         Arrow( \box[1]\x+( \box[1]\width-\box[1]\arrow\size)/2, \box[1]\y+( \box[1]\height-\box[1]\arrow\size)/2, \box[1]\arrow\size, Bool(\Vertical)*3,
    ;                (Bool(Not _bar_in_start_(*this\bar)) * \color[1]\front[State_1] + _bar_in_start_(*this\bar) * \color[1]\frame[0])&$FFFFFF|Alpha, \box[1]\arrow\type)
    ;         
    ;         ; Draw arrows
    ;         Arrow( \box[#bb_2]\x+( \box[#bb_2]\width-\box[2]\arrow\size)/2, \box[#bb_2]\y+( \box[#bb_2]\height-\box[2]\arrow\size)/2, \box[2]\arrow\size, Bool(Not \Vertical)+1, 
    ;                (Bool(Not _bar_in_stop_(*this\bar)) * \color[2]\front[State_2] + _bar_in_stop_(*this\bar) * \color[2]\frame[0])&$FFFFFF|Alpha, \box[2]\arrow\type)
    ;         
    ;         
    ;         Line(\box[1]\x-2, \y[2],1,\height[2], \color\frame&$FFFFFF|Alpha)
    ;       EndIf      
    ;     EndWith
  EndProcedure
  
  Procedure.i Draw_Combobox(*this._s_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      If \box\checked
        State = 2
      EndIf
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \bar\vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4]-\box\width-\text\x[2],\height[#c_4])
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
      EndIf
      
      \box\x = \x+\width-\box\width -\box\arrow\size/2
      \box\height = \height[2]
      \box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\box\x+(\box\width-\box\arrow\size)/2, \box\y+(\box\height-\box\arrow\size)/2, \box\arrow\size, Bool(\box\checked)+2, \color\front[State]&$FFFFFF|Alpha, \box\arrow\type)
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  ;-
  Procedure.i Draw_Tree(*this._s_widget)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF,alpha = 255, item_alpha = 255
    Protected box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    With *this
      If *this > 0
        If \text\fontID : DrawingFont(\text\fontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          ; set vertical bar state
          If \scroll And \scroll\v\bar\max And \change > 0
            \scroll\v\bar\max = \scroll\height
            ; \scroll\v\bar\max = \countItems*\text\height
            ; Debug ""+Str(\change*\text\height-\scroll\v\bar\page\len+\scroll\v\bar\thumb\len) +" "+ \scroll\v\bar\max
            If (\change*\text\height-\scroll\v\bar\page\len) <> \scroll\v\bar\page\pos  ;> \scroll\v\bar\max
                                                                                        ; \scroll\v\bar\page\pos = (\change*\text\height-\scroll\v\bar\page\len)
              SetState(\scroll\v, (\change*\text\height-\scroll\v\bar\page\len))
              Debug ""+\scroll\v\bar\page\pos+" "+Str(\change*\text\height-\scroll\v\bar\page\len)  +" "+\scroll\v\bar\max                                               
              
            EndIf
          EndIf
          
          If \scroll
            \scroll\width=0
            \scroll\height=0
          EndIf
          
          ; Resize items
          ForEach \items()
            ;\items()\height = 20
            ;             If Not \items()\text\change And Not \resize And Not \change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;               \scroll\width=0
            ;               \scroll\height=0
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\scroll\h\bar\page\len
              \items()\x=\scroll\h\x-\scroll\h\bar\page\pos
              \items()\y=(\scroll\v\y+\scroll\height)-\scroll\v\bar\page\pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = \flag\buttons
              \items()\box\height = \flag\buttons
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\handle
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\handle = \items()\image\handle
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\checkboxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box[1]\width = \flag\checkboxes
                \items()\box[1]\height = \flag\checkboxes
                
                \items()\box[1]\x = \items()\x+4
                \items()\box[1]\y = (\items()\y+\items()\height)-(\items()\height+\items()\box[1]\height)/2
              EndIf
              
              \scroll\height+\items()\height
              
              If \scroll\width < (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
                \scroll\width = (\items()\text\x-\x+\items()\text\width)+\scroll\h\bar\page\pos
              EndIf
            EndIf
            
            \items()\drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; set vertical scrollbar max value
          If \scroll\v And \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height And 
             Widget::SetAttribute(\scroll\v, #PB_Bar_Maximum, \scroll\height) : \scroll\v\bar\scrollstep = \text\height
            Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \scroll\h And \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And 
             Widget::SetAttribute(\scroll\h, #PB_Bar_Maximum, \scroll\width)
            Resizes(\scroll, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; Draw items
          ForEach \items()
            
            
            ;           If Drawing
            ;             \drawing = Drawing
            ;           EndIf
            ;           
            ;           If \drawing
            ;             ChangeCurrentElement(\items(), \drawing)
            ;             Repeat 
            
            If \items()\drawing
              \items()\width=\scroll\h\bar\page\len
              If Bool(\items()\index = \index[#s_2])
                State_3 = 2
              Else
                State_3 = Bool(\items()\index = \index[#s_1])
              EndIf
              
              ; Draw selections
              If \flag\fullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, \color\back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, \color\frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\alwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\scroll\h\bar\page\pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\scroll\h\bar\page\pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
                
              EndIf
              
              ; Draw boxes
              If \flag\buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box[0]\x+(\items()\box[0]\width-6)/2,\items()\box[0]\y+(\items()\box[0]\height-6)/2, 6, Bool(Not \items()\box[0]\checked)+2, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\box\checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,\flag\lines,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\i_Parent 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\i_Parent\height/2)-\scroll\v\bar\page\pos
                    Else 
                      start = \items()\i_Parent\y+\items()\i_Parent\height+\items()\i_Parent\height/2-\flag\lines
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\checkboxes
                Draw_Box(\items()\box[1]\x,\items()\box[1]\y,\items()\box[1]\width,\items()\box[1]\height, 3, \items()\box[1]\checked, checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\handle, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \color\front[Bool(\focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
        EndIf
        
      EndIf
    EndWith
    
  EndProcedure
  
  ;-
  Procedure.i Draw_Button(*this._s_widget)
    With *this
      Protected State = \color\state
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \color\back[State]<>-1
        If \color\fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore[State], \color\back[State], \radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[State]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw frame
      If \color\frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  
  Macro _resize_panel_(_this_, _bar_button_, _pos_)
    If _bar_in_start_(_this_\tab\bar)
      _this_\tab\bar\button[#bb_1]\width = 0
    Else
      _this_\tab\bar\button[#bb_1]\width = _this_\tab\bar\button[#bb_1]\len 
    EndIf
    
    If _bar_in_stop_(_this_\tab\bar)
      _this_\tab\bar\button[#bb_2]\width = 0
    Else
      _this_\tab\bar\button[#bb_2]\width = _this_\tab\bar\button[#bb_2]\len 
    EndIf
    
    _this_\tab\bar\button[#bb_3]\x = _this_\x[2]+1+_this_\tab\bar\button[#bb_1]\width
    _this_\tab\bar\button[#bb_3]\width = _this_\width[2]-_this_\tab\bar\button[#bb_1]\width-_this_\tab\bar\button[#bb_2]\width-1
    
    If _this_\tab\bar\vertical
      _this_\tab\bar\button[#bb_1]\x = _this_\tab\bar\button[#bb_3]\x-_this_\tab\bar\button[#bb_1]\width
      _this_\tab\bar\button[#bb_2]\x = _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width-1
    Else
      If _this_\tab\bar\button[#bb_1] = _bar_button_ 
        _bar_button_\x = _pos_+1
        _this_\tab\bar\button[#bb_2]\x = _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width-1
      Else
        _bar_button_\x = _pos_-1
        _this_\tab\bar\button[#bb_1]\x = _this_\tab\bar\button[#bb_3]\x-_this_\tab\bar\button[#bb_1]\width
      EndIf
    EndIf
    
    
    _this_\tab\bar\button[#bb_3]\y = _this_\y[2]-_this_\__height+_this_\bs+2
    _this_\tab\bar\button[#bb_3]\height = _this_\__height-1-4
    
    _this_\tab\bar\button[#bb_1]\y = _this_\tab\bar\button[#bb_3]\y
    _this_\tab\bar\button[#bb_2]\y = _this_\tab\bar\button[#bb_3]\y
    
    _this_\tab\bar\button[#bb_1]\height = _this_\tab\bar\button[#bb_3]\height
    _this_\tab\bar\button[#bb_2]\height = _this_\tab\bar\button[#bb_3]\height
    
    _this_\tab\bar\page\len = _this_\width[2] - 1
    
    ;     If _bar_in_stop_(_this_\tab\bar)
    ;       If _this_\tab\bar\max < _this_\tab\bar\min : _this_\tab\bar\max = _this_\tab\bar\min : EndIf
    ;       
    ;       If _this_\tab\bar\max > _this_\tab\bar\max-_this_\tab\bar\page\len
    ;         If _this_\tab\bar\max > _this_\tab\bar\page\len
    ;           _this_\tab\bar\max = _this_\tab\bar\max-_this_\tab\bar\page\len
    ;         Else
    ;           _this_\tab\bar\max = _this_\tab\bar\min 
    ;         EndIf
    ;       EndIf
    ;       
    ;       _this_\tab\bar\page\pos = _this_\tab\bar\max
    ;       _this_\tab\bar\thumb\pos = _thumb_pos_(_this_\tab, _this_\tab\bar\page\pos)
    ;     EndIf
    
  EndMacro
  
  
  Procedure.i Draw_Window(*this._s_widget)
    With *this 
      Protected sx,sw,x = \x
      Protected px=2,py
      Protected start, stop
      
      Protected State_3 = \color\state
      Protected Alpha = \color\alpha<<24
      
      ; Draw caption frame
      If \caption\color\back > 0
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        _box_gradient_( \Vertical, \caption\x, \caption\y, \caption\width, \caption\height, \caption\color\fore[\focus*2], \caption\color\back[\focus*2], \radius, \caption\color\alpha)
      EndIf
      
      ; Draw image
      If \image\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\text\x, \text\y, \text\string.s, \color\front[\focus*2]&$FFFFFF|Alpha)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(\caption\button[0]\x, \caption\button[0]\y, \caption\button[0]\width, \caption\button[0]\height, \caption\round, \caption\round, $FF0000FF&$FFFFFF|\color[1]\alpha<<24)
      RoundBox(\caption\button[1]\x, \caption\button[1]\y, \caption\button[1]\width, \caption\button[1]\height, \caption\round, \caption\round, $FFFF0000&$FFFFFF|\color[2]\alpha<<24)
      RoundBox(\caption\button[2]\x, \caption\button[2]\y, \caption\button[2]\width, \caption\button[2]\height, \caption\round, \caption\round, $FF00FF00&$FFFFFF|\color[3]\alpha<<24)
      
      ; Draw caption frame
      If \color\frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x[1], \y+\bs-\fs, \width[1], \__height+\fs, \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \color\back[State_3]<>-1
        If \color\fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        _box_gradient_( \Vertical, \x[2], \y[2], \width[2], \height[2], \color\fore, \color\back, \radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\handle
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\handle, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \color\frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \radius, \radius, \color\frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \color\frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x, \y, \width, \height, \radius, \radius, \color\frame[State_3]&$FFFFFF|Alpha)
      EndIf
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Draw(*this._s_widget, childrens=0)
    Protected parent_item.i
    
    With *this
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      ; Get text size
      If (\text And \text\change)
        \text\width = TextWidth(\text\string.s[1])
        \text\height = TextHeight("A")
      EndIf
      
      If \image 
        If (\image\change Or \resize Or \change)
          ; Image default position
          If \image\handle
            If (\type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\scroll\h\bar\page\len>\image\width And (\image\align\right Or \image\align\horizontal)) * (\scroll\h\bar\page\len-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\scroll\v\bar\page\len>\image\height And (\image\align\bottom Or \image\align\Vertical)) * (\scroll\v\bar\page\len-\image\height)) / (\image\align\Vertical+1)
              \image\y = \scroll\y+\image\y[1]+\y[2]
              \image\x = \scroll\x+\image\x[1]+\x[2]
              
            ElseIf (\type = #PB_GadgetType_Window)
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y+\bs+(\__height-\image\height)/2
              \text\x[2] = \image\x[2] + \image\width
            Else
              \image\x[1] = \image\x[2] + (Bool(\image\align\right Or \image\align\horizontal) * (\width-\image\width)) / (\image\align\horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\align\bottom Or \image\align\Vertical) * (\height-\image\height)) / (\image\align\Vertical+1)
              \image\x = \image\x[1]+\x[2]
              \image\y = \image\y[1]+\y[2]
            EndIf
          EndIf
        EndIf
        
        Protected image_width = \image\width
      EndIf
      
      If \text And (\text\change Or \resize Or \change)
        ;         ; Make multi line text
        ;         If \text\multiLine > 0
        ;           \text\string.s = Text_Wrap(*this, \text\string.s[1], \width-\bs*2, \text\multiLine)
        ;           \countItems = CountString(\text\string.s, #LF$)
        ;         Else
        ;           \text\string.s = \text\string.s[1]
        ;         EndIf
        
        ; Text default position
        If \text\string
          \text\x[1] = \text\x[2] + (Bool((\text\align\right Or \text\align\horizontal)) * (\width[2]-\text\width-image_width)) / (\text\align\horizontal+1)
          \text\y[1] = \text\y[2] + (Bool((\text\align\bottom Or \text\align\Vertical)) * (\height[2]-\text\height)) / (\text\align\Vertical+1)
          
          If \type = #PB_GadgetType_Frame
            \text\x = \text\x[1]+\x[2]+8
            \text\y = \text\y[1]+\y
            
          ElseIf \type = #PB_GadgetType_Window
            \text\x = \text\x[1]+\x[2]+5
            \text\y = \text\y[1]+\y+\bs+(\__height-\text\height)/2
          Else
            \text\x = \text\x[1]+\x[2]
            \text\y = \text\y[1]+\y[2]
          EndIf
        EndIf
      EndIf
      
      ; 
      If \height>0 And \width>0 And Not \hide And \color\alpha 
        ClipOutput(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4])
        
        If \image[1] And \container
          \image[1]\x = \x[2] 
          \image[1]\y = \y[2]
        EndIf
        
        ;           SetOrigin(\x,\y)
        ;           
        ;           If Not Post(#PB_EventType_Repaint, *this)
        ;             SetOrigin(0,0)
        
        
        Select \type
          Case #PB_GadgetType_Window : Draw_Window(*this)
          Case #PB_GadgetType_Tree : Draw_Tree(*this)
          Case #PB_GadgetType_ComboBox : Draw_Combobox(*this)
          Case #PB_GadgetType_Button : Draw_Button(*this)
          Case #PB_GadgetType_Spin : Draw_Spin(*this)
          Case #PB_GadgetType_ScrollBar : Draw_Scroll(*this)
        EndSelect
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Draw_Scroll(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Draw_Scroll(\scroll\h) : EndIf
        EndIf
        
        ; Draw childrens
        If childrens And ListSize(\childrens())
          ; Only selected item widgets draw
          
          ForEach \childrens() 
            ;If Not Send(\childrens(), #PB_EventType_Repaint)
            
            If \childrens()\width[#c_4] > 0 And 
               \childrens()\height[#c_4] > 0 And 
               \childrens()\tab\index = \tab\index[#s_2]
              Draw(\childrens(), childrens) 
            EndIf
            
            ;EndIf
            
            ;             ; Draw anchors 
            ;             If \childrens()\root And \childrens()\root\anchor And \childrens()\root\anchor\widget = \childrens()
            ;               a_Draw(\childrens()\root\anchor\widget)
            ;             EndIf
            ;             
            SetOrigin(\childrens()\x,\childrens()\y)
            Post(#PB_EventType_Repaint, \childrens())
            SetOrigin(0,0)
            
            
          Next
        EndIf
        
        If \width[#c_4] > 0 And \height[#c_4] > 0
          ; Demo clip coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x[#c_4],\y[#c_4],\width[#c_4],\height[#c_4], $0000FF)
          
          ; Demo default coordinate
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x,\y,\width,\height, $00FF00)
          
          If *this\focus And (*this = Root()\active\a_gadget Or *this = Root()\active)  ; Demo default coordinate
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\x,\y,\width,\height, $FF0000)
          EndIf
        EndIf
        
        UnclipOutput()
        
        ; Draw anchors 
        If \root And \root\anchor And \root\anchor\widget
          ;Debug \root\anchor\widget
          a_Draw(\root\anchor\widget)
        EndIf
        
      EndIf
      
      ; reset 
      \change = 0
      \resize = 0
      If \text
        \text\change = 0
      EndIf
      If \image
        \image\change = 0
      EndIf
      
      ; *value\type =- 1 
      ; *value\this = 0
    EndWith 
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ReDraw(*this._s_widget=#Null)
    With *this     
      If Not  *this
        *this = Root()
      EndIf
      
      If StartDrawing(CanvasOutput(\root\canvas\gadget))
        If \root\color\back
          ;DrawingMode(#PB_2DDrawing_Default)
          ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
          FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), \root\color\back)
        EndIf
        
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
  Procedure.b set_hide_state(*this._s_widget, State.b)
    With *this
      \hide = Bool(State Or \hide[1] Or \parent\hide Or (\tab\index <> \parent\tab\index[#s_2]))
      
      If \scroll And \scroll\v And \scroll\h
        \scroll\v\hide = \scroll\v\bar\hide
        \scroll\h\hide = \scroll\h\bar\hide 
      EndIf
      
      If ListSize(\childrens())
        ForEach \childrens()
          set_hide_state(\childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b Hide(*this._s_widget, State.b=-1)
    With *this
      If State =- 1
        ProcedureReturn \hide 
      Else
        \hide = State
        \hide[1] = \hide
        
        If ListSize(\childrens())
          ForEach \childrens()
            set_hide_state(\childrens(), State)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  
  
  ;- GET
  Procedure.i GetWindow(*this._s_widget)
    If *this = *this\root
      ProcedureReturn *this\root\canvas\window
    Else
      ProcedureReturn *this\window
    EndIf
  EndProcedure
  
  Procedure.i GetState(*this._s_widget)
    Protected Result.i
    
    With *this
      Select \type
          ;         Case #PB_GadgetType_Option,
          ;              #PB_GadgetType_CheckBox 
          ;           Result = \box\checked
          ;           
        Case #PB_GadgetType_Tree : Result = \index[#s_2]
        Case #PB_GadgetType_Panel : Result = \index[#s_2]
        Case #PB_GadgetType_ComboBox : Result = \index[#s_2]
        Case #PB_GadgetType_ListIcon : Result = \index[#s_2]
        Case #PB_GadgetType_ListView : Result = \index[#s_2]
        Case #PB_GadgetType_IPAddress : Result = \index[#s_2]
          
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = *this\bar\page\pos
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._s_widget, Item.i, Column.i=0)
    Protected Result.s
    
    With *this
      
      Select \type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
          ForEach \items()
            If \items()\index = Item 
              Result = \items()\text\string.s
              Break
            EndIf
          Next
          
        Case #PB_GadgetType_ListIcon
          SelectElement(\columns(), Column)
          
          ForEach \columns()\items()
            If \columns()\items()\index = Item 
              Result = \columns()\items()\text\string.s
              Break
            EndIf
          Next
      EndSelect
      
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  ;- SET
  Procedure.i SetAlignment(*this._s_widget, Mode.i, Type.i=1)
    With *this
      Select Type
        Case 1 ; widget
          If \parent
            If Not \align
              \align._s_align = AllocateStructure(_s_align)
            EndIf
            
            If Not \align\autoSize
              \align\top = Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)
              \align\left = Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              \align\right = Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)
              \align\bottom = Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)
              
              If Bool(Mode&#PB_Flag_Center=#PB_Flag_Center)
                \align\horizontal = 1
                \align\Vertical = 1
              Else
                \align\horizontal = Bool(Mode&#PB_Flag_Horizontal=#PB_Flag_Horizontal)
                \align\Vertical = Bool(Mode&#PB_Flag_Vertical=#PB_Flag_Vertical)
              EndIf
            EndIf
            
            If Bool(Mode&#PB_Flag_AutoSize=#PB_Flag_AutoSize)
              If Bool(Mode&#PB_Flag_Full=#PB_Flag_Full) 
                \align\top = 1
                \align\left = 1
                \align\right = 1
                \align\bottom = 1
                \align\autoSize = 0
              EndIf
              
              ; Auto dock
              Static y2,x2,y1,x1
              Protected width = #PB_Ignore, height = #PB_Ignore
              
              If \align\left And \align\right
                \x = x2
                width = \parent\width[2] - x1 - x2
              EndIf
              If \align\top And \align\bottom 
                \y = y2
                height = \parent\height[2] - y1 - y2
              EndIf
              
              If \align\left And Not \align\right
                \x = x2
                \y = y2
                x2 + \width
                height = \parent\height[2] - y1 - y2
              EndIf
              If \align\right And Not \align\left
                \x = \parent\width[2] - \width - x1
                \y = y2
                x1 + \width
                height = \parent\height[2] - y1 - y2
              EndIf
              
              If \align\top And Not \align\bottom 
                \x = 0
                \y = y2
                y2 + \height
                width = \parent\width[2] - x1 - x2
              EndIf
              If \align\bottom And Not \align\top
                \x = 0
                \y = \parent\height[2] - \height - y1
                y1 + \height
                width = \parent\width[2] - x1 - x2
              EndIf
              
              Resize(*this, \x, \y, width, height)
              
              \align\top = Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)+Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              \align\left = Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)+Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)+Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)
              \align\right = Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Top=#PB_Flag_Top)+Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)
              \align\bottom = Bool(Mode&#PB_Flag_Bottom=#PB_Flag_Bottom)+Bool(Mode&#PB_Flag_Right=#PB_Flag_Right)+Bool(Mode&#PB_Flag_Left=#PB_Flag_Left)
              
            EndIf
            
            If \align\right
              If \align\left And \align\right
                \align\x = \parent\width[2] - \width
              Else
                \align\x = \parent\width[2] - (\x-\parent\x[2]) ; \parent\width[2] - (\parent\width[2] - \width)
              EndIf
            EndIf
            If \align\bottom
              If \align\top And \align\bottom
                \align\y = \parent\height[2] - \height
              Else
                \align\y = \parent\height[2] - (\y-\parent\y[2]) ; \parent\height[2] - (\parent\height[2] - \height)
              EndIf
            EndIf
            
            Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i SetParent(*this._s_widget, *Parent._s_widget, parent_item.i=-1)
    Protected x.i,y.i, *LastParent._s_widget
    
    With *this
      If *this > 0 
        If parent_item =- 1
          parent_item = *Parent\index[#s_2]
        EndIf
        
        If *Parent <> \parent Or \tab\index <> parent_item
          x = \x[3]
          y = \y[3]
          
          If \parent And ListSize(\parent\childrens())
            ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) 
            DeleteElement(\parent\childrens())
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \tab\index = parent_item
          \parent = *Parent
          \root = *Parent\root
          
          \root\countItems + 1 
          
          If \parent <> \root
            \parent\countItems + 1 
            \level = \parent\level + 1
            \window = \parent\window
          Else
            \window = \parent
          EndIf
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \hide = Bool(\parent\hide Or \tab\index <> \parent\tab\index[#s_2])
          
          ;           If \scroll
          ;             If \scroll\v
          ;               \scroll\v\window = \window
          ;             EndIf
          ;             If \scroll\h
          ;               \scroll\h\window = \window
          ;             EndIf
          ;           EndIf
          
          If \parent\scroll
            x-\parent\scroll\h\bar\page\pos
            y-\parent\scroll\v\bar\page\pos
          EndIf
          
          ; Add new children 
          LastElement(\parent\childrens()) 
          \adress = AddElement(\parent\childrens())
          
          If \adress
            \parent\childrens() = *this 
            \index = \root\countItems 
          EndIf
          
          ; Make count type
          If \window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\type))
            typecount(Hex(\window)+"_"+Hex(\type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\type))
            typecount(Hex(\parent)+"__"+Hex(\type)) + 1
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
  
  Procedure.i _SetParent(*this._S_widget, *Parent._S_widget, parent_item.i=-1)
    Protected x.i,y.i, *LastParent._S_widget
    
    With *this
      If *this > 0 
        ; set root parent
        If Not *Parent\type And *this <> *Parent\parent
          ;  Debug ""+*this+" "+*Parent+" "+*Parent\parent+" "+*Parent\type
          *Parent = *Parent\parent
        EndIf
        
        If parent_item =- 1
          parent_item = *Parent\index[#s_2]
        EndIf
        
        If *Parent <> \parent Or \tab\index <> parent_item : \tab\index = parent_item
          x = \x[3]
          y = \y[3]
          
          If \parent And \parent\countItems > 0
            ChangeCurrentElement(\parent\childrens(), GetAdress(*this)) 
            DeleteElement(\parent\childrens())  
            \parent\countItems - 1
            *LastParent = Bool(\parent<>*Parent) * \parent
          EndIf
          
          \parent = *Parent
          \root = *Parent\root
          
          \index = \root\countItems : \root\countItems + 1 
          
          If \parent = \root
            \window = \parent
          Else
            \window = \parent\window
            \parent\countItems + 1 
            \level = \parent\level + 1
          EndIf
          
          ; Скрываем все виджеты скрытого родителя,
          ; и кроме тех чьи родителский итем не выбран
          \hide = Bool(\parent\hide Or \tab\index <> \parent\tab\index[#s_2])
          
          ; ????????
          If \scroll
            If \scroll\v
              \scroll\v\window = \window
            EndIf
            If \scroll\h
              \scroll\h\window = \window
            EndIf
          EndIf
          
          ; for the scroll area childrens
          If \parent\scroll
            x-\parent\scroll\h\bar\page\pos
            y-\parent\scroll\v\bar\page\pos
          EndIf
          
          ; Add new children to the parent
          LastElement(\parent\childrens()) 
          \adress = AddElement(\parent\childrens())
          \parent\childrens() = *this 
          
          ; Make count type
          If \window
            Static NewMap typecount.l()
            
            \type_index = typecount(Hex(\window)+"_"+Hex(\type))
            typecount(Hex(\window)+"_"+Hex(\type)) + 1
            
            \type_count = typecount(Hex(\parent)+"__"+Hex(\type))
            typecount(Hex(\parent)+"__"+Hex(\type)) + 1
          EndIf
          
          ;
          Resize(*this, x, y, #PB_Ignore, #PB_Ignore)
          
          If *LastParent
            ;             Debug ""+*root\width+" "+*LastParent\root\width+" "+*Parent\root\width 
            ;             Debug "From ("+ Class(*LastParent\type) +") to (" + Class(*Parent\type) +") - SetParent()"
            
            If *LastParent <> *Parent
              Select Root()
                Case *Parent\root : ReDraw(*Parent)
                Case *LastParent\root     : ReDraw(*LastParent)
              EndSelect
            EndIf
            
          EndIf
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetPosition(*this._s_widget, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
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
        
        ChangeCurrentElement(\parent\childrens(), GetAdress(*this))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\parent\childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\parent\childrens()) : MoveElement(\parent\childrens(), #PB_List_After, GetAdress(\parent\childrens()))
            Case #PB_List_After  : NextElement(\parent\childrens())     : MoveElement(\parent\childrens(), #PB_List_Before, GetAdress(\parent\childrens()))
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
  
  Procedure.i SetActive(*this._s_widget)
    Protected Result.i
    
    Macro _set_active_state_(_state_)
      Root()\active\focus = _state_
      
      If Not(Root()\active = Root()\active\root And Root()\active\root\type =- 5)
        If _state_
          Events(Root()\active, Root()\active\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Root()\active, Root()\active\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
        
        PostEvent(#PB_Event_Gadget, Root()\active\root\canvas\window, Root()\active\root\canvas\gadget, #PB_EventType_Repaint)
      EndIf
      
      If Root()\active\a_gadget
        Root()\active\a_gadget\focus = _state_
        If _state_
          Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_Focus, -1, -1)
        Else
          Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_LostFocus, -1, -1)
        EndIf
      EndIf
    EndMacro
    
    With *this
      If \type > 0
        If Root()\active\a_gadget <> *this
          
          If Root()\active <> \window
            If Root()\active
              _set_active_state_(0)
            EndIf
            
            Root()\active = \window
            Root()\active\a_gadget = *this
            
            _set_active_state_(1)
          Else
            If Root()\active\a_gadget
              Root()\active\a_gadget\focus = 0
              Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_LostFocus, -1, -1)
            EndIf
            
            Root()\active\a_gadget = *this
            Root()\active\a_gadget\focus = 1
            Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_Focus, -1, -1)
          EndIf
          
          Result = #True 
        EndIf
        
      ElseIf Root()\active <> *this
        If Root()\active
          _set_active_state_(0)
        EndIf
        
        Root()\active = *this
        
        _set_active_state_(1)
        
        Result = #True
      EndIf
      
      SetPosition(Root()\active, #PB_List_Last)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetText(*this._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    
    With *this
      If \text And \text\string.s[1] <> Text.s
        \text\string.s[1] = Text_Make(*this, Text.s)
        
        If \text\string.s[1]
          If \text\multiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \text\multiLine > 0
              Text.s + #LF$
            EndIf
            
            \text\string.s[1] = Text.s
            \countItems = CountString(\text\string.s[1], #LF$)
          Else
            \text\string.s[1] = RemoveString(\text\string.s[1], #LF$) ; + #LF$
                                                                      ; \text\string.s = RTrim(ReplaceString(\text\string.s[1], #LF$, " ")) + #LF$
          EndIf
          
          \text\string.s = \text\string.s[1]
          \text\len = Len(\text\string.s[1])
          \text\change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*this._s_widget, State.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *this
      If *this > 0
        Select \type
          Case #PB_GadgetType_IPAddress
            If \index[#s_2] <> State : \index[#s_2] = State
              SetText(*this, Str(IPAddressField(State,0))+"."+
                             Str(IPAddressField(State,1))+"."+
                             Str(IPAddressField(State,2))+"."+
                             Str(IPAddressField(State,3)))
            EndIf
            
          Case #PB_GadgetType_CheckBox
            ;             Select State
            ;               Case #PB_Checkbox_Unchecked,
            ;                    #PB_Checkbox_Checked
            ;                 \box\checked = State
            ;                 ProcedureReturn 1
            ;                 
            ;               Case #PB_Checkbox_Inbetween
            ;                 If \flag\threestate 
            ;                   \box\checked = State
            ;                   ProcedureReturn 1
            ;                 EndIf
            ;             EndSelect
            
          Case #PB_GadgetType_Option
            ;             If \option_group And \box\checked <> State
            ;               If \option_group\option_group <> *this
            ;                 If \option_group\option_group
            ;                   \option_group\option_group\box\checked = 0
            ;                 EndIf
            ;                 \option_group\option_group = *this
            ;               EndIf
            ;               \box\checked = State
            ;               ProcedureReturn 1
            ;             EndIf
            ;             
          Case #PB_GadgetType_ComboBox
            Protected *t._s_widget = \popup\childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\countItems - 1 : State = *t\countItems - 1 :  EndIf
            
            If *t\index[#s_2] <> State
              If *t\index[#s_2] >= 0 And SelectElement(*t\items(), *t\index[#s_2]) 
                *t\items()\state = 0
              EndIf
              
              *t\index[#s_2] = State
              \index[#s_2] = State
              
              If SelectElement(*t\items(), State)
                *t\items()\state = 2
                *t\change = State+1
                
                \text\string[1] = *t\items()\text\string
                \text\string = \text\string[1]
                ;                 \text[1]\string = \text\string[1]
                ;                 \text\caret = 1
                ;                 \text\caret[1] = \text\caret
                \text\change = 1
                
                w_Events(*this, #PB_EventType_Change, State)
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \countItems - 1 : State = \countItems - 1 :  EndIf
            
            If \index[#s_2] <> State
              If \index[#s_2] >= 0 And 
                 SelectElement(\items(), \index[#s_2]) 
                \items()\state = 0
              EndIf
              
              \index[#s_2] = State
              
              If SelectElement(\items(), \index[#s_2])
                \items()\state = 2
                \change = \index[#s_2]+1
                ; w_Events(*this, #PB_EventType_Change, \index[#s_2])
              EndIf
              
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            _set_image_(*this, *this, State) 
            Result = *this\image\change
            
            If Result
              If \scroll
                SetAttribute(\scroll\v, #PB_Bar_Maximum, \image\height)
                SetAttribute(\scroll\h, #PB_Bar_Maximum, \image\width)
                
                \resize = 1<<1|1<<2|1<<3|1<<4 
                Resize(*this, \x, \y, \width, \height) 
                \resize = 0
              EndIf
            EndIf
            
          Case #PB_GadgetType_Panel
            If State < 0 : State = 0 : EndIf
            If State > \tab\count - 1 : State = \tab\count - 1 :  EndIf
            
            If \tab\index[#s_2] <> State : \tab\index[#s_2] = State
              
              ForEach \childrens()
                set_hide_state(\childrens(), Bool(\childrens()\tab\index<>\tab\index[#s_2]))
              Next
              
              ;\tab\selected = SelectElement(\tab\tabs(), State)
              
              \tab\scrolled = State + 1
              Result = 1
            EndIf
            
          Default
            ProcedureReturn Bar_SetState(*this, State)
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*this._s_widget, Attribute.i, Value.i)
    Protected Resize.i
    
    With *this
      If *this > 0
        Select \type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                _set_image_(*this, *this, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \bar\button[#bb_1]\len = Value
              Case #PB_Splitter_SecondMinimumSize : \bar\button[#bb_2]\len = \bar\button[#bb_3]\len + Value
            EndSelect 
            
            If \bar\Vertical
              \bar\area\pos = \y+\bar\button[#bb_1]\len
              \bar\area\len = (\height-\bar\button[#bb_1]\len-\bar\button[#bb_2]\len)
            Else
              \bar\area\pos = \x+\bar\button[#bb_1]\len
              \bar\area\len = (\width-\bar\button[#bb_1]\len-\bar\button[#bb_2]\len)
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
                \resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*this, \x, \y, \width, \height)
                \resize = 0
            EndSelect
            
          Default
            
            Resize = Bar_SetAttribute(*this, Attribute, Value)
            
        EndSelect
        
        If Resize
          \resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  ;- ADD
  ;-
  Procedure AddItem_Tree(*this._s_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last._s_items
    
    If Not *this
      ProcedureReturn 0
    EndIf
    
    With *this
      ;{ Генерируем идентификатор
      If 0 > Item Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        If \items()\sublevel>sublevel
          sublevel=\items()\sublevel
        EndIf
        InsertElement(\items())
        
        PushListPosition(\items())
        While NextElement(\items())
          \items()\index = ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(_s_items)
      \items()\box[0] = AllocateStructure(_s_box)
      \items()\box[1] = AllocateStructure(_s_box)
      
      Static first.i
      If Item = 0
        First = \items()
      EndIf
      
      If subLevel
        If sublevel>Item
          sublevel=Item
        EndIf
        
        PushListPosition(\items())
        While PreviousElement(\items()) 
          If subLevel = \items()\subLevel
            \i_Parent = \items()\i_Parent
            Break
          ElseIf subLevel > \items()\subLevel
            \i_Parent = \items()
            Break
          EndIf
        Wend 
        PopListPosition(\items())
        
        If \i_Parent
          If subLevel > \i_Parent\subLevel
            sublevel = \i_Parent\sublevel + 1
            \i_Parent\childrens + 1
            ;  \i_Parent\box\checked = 1
            ;  \i_Parent\hide = 1
          EndIf
        EndIf
      Else                                      
        \i_Parent = first
      EndIf
      
      \items()\change = 1
      \items()\index= Item
      \items()\index[#s_1] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \text\height
      \items()\i_Parent = \i_Parent
      
      _set_image_(*this, \items(), Image)
      
      \items()\y = \scroll\height
      \scroll\height + \items()\height
      
      \image = AllocateStructure(_s_image)
      \image\handle = \items()\image\handle
      \image\width = \items()\image\width+4
      \countItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  ;-
  Procedure.i AddItem(*this._s_widget, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *this
      ;       If Not *this
      ;         ProcedureReturn 0
      ;       EndIf
      
      Select \type
        Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
          ProcedureReturn AddItem_Tree(*this, Item,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ComboBox
          Protected *Tree._s_widget = \popup\childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(_s_items)
          *Tree\items()\box[0] = AllocateStructure(_s_box)
          *Tree\items()\box[1] = AllocateStructure(_s_box)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\text\string = Text.s
          *Tree\items()\text\change = 1
          *Tree\items()\height = \text\height
          *Tree\countItems + 1 
          
          *Tree\items()\y = *Tree\scroll\height
          *Tree\scroll\height + *Tree\items()\height
          
          _set_image_(*Tree, *Tree\items(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #PB_Flag_AutoSize
        If \parent And \parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\x
          Y = 0; \align\y
          Width = \parent\width[2] ; - \align\x
          Height = \parent\height[2] ; - \align\y
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \parent : \x[3] = X : X+\parent\x+\parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \parent : \y[3] = Y : Y+\parent\y+\parent\bs+\parent\__height : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[2] = \y+\bs+\__height : \y[1] = \y[2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        
        If IsRoot(*this)
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[2] = \height-\bs*2-\__height-\__height : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        Else
          If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[2] = width-Bool(\type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
          If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\__height+\bs*2) : \height[2] = height-Bool(\type<>-1)*(\__height+\bs*2) : \height[1] = \height[2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        EndIf
        
        Select \type
          Case #PB_GadgetType_Panel
            _resize_panel_(*this, \tab\bar\button[#bb_1], \x[2])
            
            If _bar_in_stop_(\tab\bar)
              If \tab\bar\max < \tab\bar\min : \tab\bar\max = \tab\bar\min : EndIf
              
              If \tab\bar\max > \tab\bar\max-\tab\bar\page\len
                If \tab\bar\max > \tab\bar\page\len
                  \tab\bar\max = \tab\bar\max-\tab\bar\page\len
                Else
                  \tab\bar\max = \tab\bar\min 
                EndIf
              EndIf
              
              \tab\bar\page\pos = \tab\bar\max
              \tab\bar\thumb\pos = _thumb_pos_(\tab, \tab\bar\page\pos)
            EndIf
            
            
          Case #PB_GadgetType_Window
            \caption\x = \x[2]
            \caption\y = \y+\bs
            \caption\width = \width[2]
            \caption\height = \__height
            
            \caption\button[0]\width = \caption\len
            \caption\button[1]\width = \caption\len
            \caption\button[2]\width = \caption\len
            
            \caption\button[0]\height = \caption\len
            \caption\button[1]\height = \caption\len
            \caption\button[2]\height = \caption\len
            
            \caption\button[0]\x = \x[2]+\width[2]-\caption\button[0]\width-5
            \caption\button[1]\x = \caption\button[0]\x-Bool(Not \caption\button[1]\hide) * \caption\button[1]\width-5
            \caption\button[2]\x = \caption\button[1]\x-Bool(Not \caption\button[2]\hide) * \caption\button[2]\width-5
            
            \caption\button[0]\y = \y+\bs+(\__height-\caption\len)/2
            \caption\button[1]\y = \caption\button[0]\y
            \caption\button[2]\y = \caption\button[0]\y
            
            ;             Case #PB_GadgetType_Spin
            ;                   If \bar\vertical
            ;                     \box[1]\y = \y[2]+\height[2]/2+Bool(\height[2]%2) : \box[1]\height = \height[2]/2 : \box[1]\width = \box[#bb_2]\len : \box[1]\x = \x[2]+\width[2]-\box[#bb_2]\len ; Top button coordinate
            ;                     \box[#bb_2]\y = \y[2] : \box[#bb_2]\height = \height[2]/2 : \box[#bb_2]\width = \box[#bb_2]\len : \box[#bb_2]\x = \x[2]+\width[2]-\box[#bb_2]\len                 ; Bottom button coordinate
            ;                   Else
            ;                     \box[1]\y = \y[2] : \box[1]\height = \height[2] : \box[1]\width = \box[#bb_2]\len/2 : \box[1]\x = \x[2]+\width[2]-\box[#bb_2]\len                                 ; Left button coordinate
            ;                     \box[#bb_2]\y = \y[2] : \box[#bb_2]\height = \height[2] : \box[#bb_2]\width = \box[#bb_2]\len/2 : \box[#bb_2]\x = \x[2]+\width[2]-\box[#bb_2]\len/2               ; Right button coordinate
            ;                   EndIf
            ;                   
            
          Default
            
            Bar_Update(*this)
            
        EndSelect
        
        ; set clip coordinate
        If Not IsRoot(*this) And \parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \parent\scroll 
            If \parent\scroll\v : clip_v = Bool(\parent\width=\parent\width[#c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\parent\scroll\v\width : EndIf
            If \parent\scroll\h : clip_h = Bool(\parent\height=\parent\height[#c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \parent\x[#c_4]+Bool(\parent\x[#c_4]<\parent\x+\parent\bs)*\parent\bs
          clip_y = \parent\y[#c_4]+Bool(\parent\y[#c_4]<\parent\y+\parent\bs)*(\parent\bs+\parent\__height) 
          clip_width = ((\parent\x[#c_4]+\parent\width[#c_4])-Bool((\parent\x[#c_4]+\parent\width[#c_4])>(\parent\x[2]+\parent\width[2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#c_4]+\parent\height[#c_4])-Bool((\parent\y[#c_4]+\parent\height[#c_4])>(\parent\y[2]+\parent\height[2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#c_4] = clip_x : Else : \x[#c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#c_4] = clip_y : Else : \y[#c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#c_4] = clip_width - \x[#c_4] : Else : \width[#c_4] = \width - (\x[#c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#c_4] = clip_height - \y[#c_4] : Else : \height[#c_4] = \height - (\y[#c_4]-\y) : EndIf
        
        ; Resize scrollbars
        If \scroll And \scroll\v And \scroll\h
          Resizes(\scroll, 0,0, \width[2],\height[2])
        EndIf
        
        ; Resize childrens
        If ListSize(\childrens())
          If \type = #PB_GadgetType_Splitter
            _bar_splitter_size_(*this)
          Else
            ForEach \childrens()
              If \childrens()\align
                If \childrens()\align\horizontal
                  x = (\width[2] - (\childrens()\align\x+\childrens()\width))/2
                ElseIf \childrens()\align\right And Not \childrens()\align\left
                  x = \width[2] - \childrens()\align\x
                Else
                  If \x[2]
                    x = (\childrens()\x-\x[2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \childrens()\align\Vertical
                  y = (\height[2] - (\childrens()\align\y+\childrens()\height))/2 
                ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                  y = \height[2] - \childrens()\align\y
                Else
                  If \y[2]
                    y = (\childrens()\y-\y[2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \childrens()\align\top And \childrens()\align\bottom
                  Height = \height[2] - \childrens()\align\y
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \childrens()\align\left And \childrens()\align\right
                  Width = \width[2] - \childrens()\align\x
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\childrens(), x, y, Width, Height)
              Else
                Resize(\childrens(), (\childrens()\x-\x[2]) + Change_x, (\childrens()\y-\y[2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        ; anchors widgets
        If \root And \root\anchor And \root\anchor\widget = *this
          a_Resize(*this)
        EndIf
        
        If \type = #PB_GadgetType_ScrollBar
          ProcedureReturn \bar\hide
        ElseIf Change_x Or Change_y Or Change_width Or Change_height
          ProcedureReturn 1
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, Size.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7, Parent.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    With *this
      \x =- 1
      \y =- 1
      \type = Type
      \bar\type = Type
      
      \parent = Parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      \radius = Radius
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \bar\vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \bar\inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      \bar\button[#bb_3]\len = SliderLen ; min thumb size
      
      \bar\button[1]\arrow\size = 4
      \bar\button[2]\arrow\size = 4
      \bar\button[1]\arrow\type =- 1 ; -1 0 1
      \bar\button[2]\arrow\type =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \color\state = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      
      \color[1] = def_colors
      \color[2] = def_colors
      \color[3] = def_colors
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_ButtonSize=#PB_Bar_ButtonSize)
        If Size < 21
          \bar\button\len = Size - 1
        Else
          \bar\button\len = 17
        EndIf
        
        If \bar\vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If Type = #PB_GadgetType_ScrollBar
        \bar\button[#bb_1]\len = \bar\button\len
        \bar\button[#bb_2]\len = \bar\button\len
      EndIf
      
      If \bar\min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *this._s_widget, Size
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Flag_Vertical)
    
    If Vertical
      Size = width
    Else
      Size =  height
    EndIf
    
    *this = Bar(#PB_GadgetType_ScrollBar, Size, Min, Max, PageLength, Flag|Vertical, Radius)
    _set_last_parameters_(*this, #PB_GadgetType_ScrollBar, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    ;     Protected *this._s_widget = AllocateStructure(_s_widget)
    ;     _set_last_parameters_(*this, #PB_GadgetType_Spin, Flag, Root()\opened) 
    ;     
    ;     ;Flag | Bool(Not Flag&#PB_Vertical) * (#PB_Bar_Inverted)
    ;     
    ;     With *this
    ;       \x =- 1
    ;       \y =- 1
    ;       
    ;       \fs = 1
    ;       \bs = 2
    ;       
    ;       \text = AllocateStructure(_s_text)
    ;       \text\align\Vertical = 1
    ;       ;\text\align\horizontal = 1
    ;       \text\x[2] = 5
    ;       
    ;       ;\radius = Radius
    ;       \ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
    ;       \Vertical = Bool(Not Flag&#PB_Vertical=#PB_Vertical)
    ;       
    ;       \text\string.s[1] = Str(Min)
    ;       \text\change = 1
    ;       
    ;       \box[1]\arrow\size = 4
    ;       \box[2]\arrow\size = 4
    ;       \box[1]\arrow\type =- 1 ; -1 0 1
    ;       \box[2]\arrow\type =- 1 ; -1 0 1
    ;       
    ;       ; Цвет фона скролла
    ;       \color = def_colors
    ;       \color\alpha = 255
    ;       \color\back = $FFFFFFFF
    ;       \text\editable = 1
    ;       
    ;       \color[1] = def_colors
    ;       \color[2] = def_colors
    ;       \color[3] = def_colors
    ;       
    ;       \color[1]\alpha = 255
    ;       \color[2]\alpha = 255
    ;       \color[3]\alpha = 255
    ;       \color[1]\alpha[1] = 128
    ;       \color[2]\alpha[1] = 128
    ;       \color[3]\alpha[1] = 128
    ;       
    ;       
    ;       \box[#bb_2]\len = 17
    ;       
    ;       If \bar\min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
    ;       If \bar\max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
    ;       
    ;       If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*this, #PB_Bar_Inverted, #True) : EndIf
    ;       ;\bar\page\len = 10
    ;       \bar\scrollstep = 1
    ;       
    ;     EndWith
    ;     
    ;     Resize(*this, X,Y,Width,Height)
    ;     
    ;     ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Combobox(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ComboBox, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      \text = AllocateStructure(_s_text)
      \text\align\Vertical = 1
      ;\text\align\horizontal = 1
      \text\x[2] = 5
      \text\height = 20
      
      \image = AllocateStructure(_s_image)
      \image\align\Vertical = 1
      ;\image\align\horizontal = 1
      
      ;           \box\height = Height
      \box\width = 15
      \box\arrow\size = 4
      \box\arrow\type =- 1
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \popup = Popup(*this, 0,0,0,0)
      OpenList(\popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) 
      Debug \popup\childrens()
      CloseList()
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i Button(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, Image.i=-1)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Button, Flag, Root()\opened) 
    
    With *this
      \x =- 1
      \y =- 1
      \color = def_colors
      \color\alpha = 255
      
      \fs = 1
      
      \text = AllocateStructure(_s_text)
      \text\align\Vertical = 1
      \text\align\horizontal = 1
      
      \image = AllocateStructure(_s_image)
      \image\align\Vertical = 1
      \image\align\horizontal = 1
      
      SetText(*this, Text.s)
      _set_image_(*this, *this, Image)
      
      ;       ; временно из-за этого (контейнер \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget))
      ;       If \parent And \parent\root\anchor\id[1]
      ;         x+\parent\fs
      ;         y+\parent\fs
      ;       EndIf
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;- 
  Procedure.i Tree(X.l,Y.l,Width.l,Height.l, Flag.i=0)
    Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_Tree, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      ;\cursor = #PB_Cursor_Hand
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \index[#s_1] =- 1
      \index[#s_2] =- 1
      
      \image = AllocateStructure(_s_image)
      \text = AllocateStructure(_s_text)
      \text\height = 20
      
      \sublevellen = 18
      \flag\gridLines = Bool(flag&#PB_Flag_GridLines)
      \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \flag\fullSelection = 1
      \flag\alwaysSelection = 1
      
      \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \flag\checkboxes = Bool(flag&#PB_Flag_Checkboxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Flag_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar,Bool(\flag\buttons Or \flag\lines) * Size,0,0,Width, 0, 7, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Flag_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar._S_widget, *this._S_widget, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    
    *this = Bar(0, 0, 0, Max, 0, Auto|Vertical|#PB_Bar_ButtonSize, 0, 7)
    
    _set_last_parameters_(*this, #PB_GadgetType_Splitter, Flag, Root()\opened) 
    
    With *this
      \bar\button\len = 7
      \bar\thumb\len = 7
      \mode = #PB_Splitter_Separator
      
      \splitter = AllocateStructure(_S_splitter)
      \splitter\first = First
      \splitter\second = Second
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      Resize(*this, X,Y,Width,Height)
      
      If \bar\vertical
        \cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
      
      SetParent(\splitter\first, *this)
      SetParent(\splitter\second, *this)
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *this._S_widget = AllocateStructure(_S_widget) 
    _set_last_parameters_(*this, #PB_GadgetType_ScrollArea, Flag, Root()\opened)
    
    With *this
      \x =- 1
      \y =- 1
      \container = 1
      \color = def_colors
      \color\alpha = 255
      \color\back = $FFF9F9F9
      
      \fs = 1
      \bs = 2
      
      ; Background image
      \image[1] = AllocateStructure(_S_image)
      
      \scroll = AllocateStructure(_S_scroll) 
      \scroll\v = Bar(#PB_GadgetType_ScrollBar, Size, 0,ScrollAreaHeight,Height, #PB_Bar_Vertical, 7, 7, *this)
      \scroll\h = Bar(#PB_GadgetType_ScrollBar, Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *this)
      ;       Resize(\scroll\v, #PB_Ignore,#PB_Ignore,Size,#PB_Ignore)
      ;       Resize(\scroll\h, #PB_Ignore,#PB_Ignore,#PB_Ignore,Size)
      
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;-
  Procedure.i CloseList()
    Debug ""+Root() +" "+ Root()\opened +" "+ Root()\opened\parent +" "+ Root()\parent
    
    If Root()\opened\parent And Root()\opened\parent\root = Root()\opened\root
      Root()\opened = Root()\opened\parent
    Else
      Root()\opened = Root()
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*this._s_widget, Item.l=0)
    Protected result.i = Root()\opened
    
    If *this
      If *this\type = #PB_GadgetType_Window
        *this\window = *this
      EndIf
      
      Root()\opened = *this
      Root()\opened\tab\opened = Item
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i Form(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i=0, *parent._s_widget=0)
    Protected *this._s_widget = AllocateStructure(_s_widget) 
    
    If *parent 
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag, *parent) 
    Else
      OpenList(Root())
      
      _set_last_parameters_(*this, #PB_GadgetType_Window, Flag, Root()\opened) 
    EndIf
    
    With *this
      \x =- 1
      \y =- 1
      \index[#s_1] =- 1
      \index[#s_2] = 0
      
      \container =- 1
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      If Not flag&#PB_Flag_BorderLess
        \__height = 23
      EndIf
      
      \image = AllocateStructure(_s_image)
      \image\x[2] = 5 ; padding 
      
      \text = AllocateStructure(_s_text)
      \text\align\horizontal = 1
      
      \caption\color = def_colors
      \caption\color\alpha = 255
      
      \caption\len = 12
      \caption\round = 4
      
      \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \flag\window\borderLess = Bool(Flag&#PB_Flag_BorderLess)
      
      \fs = 1
      \bs = 1 ;Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \image[1] = AllocateStructure(_s_image)
      
      SetText(*this, Text.s)
      Resize(*this, X,Y,Width,Height)
      If Not Flag&#PB_Flag_NoGadget
        OpenList(*this)
      EndIf
      SetActive(*this)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Open(Window.i, X.l,Y.l,Width.l,Height.l, Text.s="", Flag.i=0, WindowID.i=0)
    Protected w.i=-1, Canvas.i=-1, *this._s_root = AllocateStructure(_s_root)
    
    If Root() And Root()\active 
      _set_active_state_(0)
    EndIf
    
    With *this
      Root() = *this
      \root = Root()
      \window = Root()
      
      \x =- 1
      \y =- 1
      \index[#s_1] =- 1
      \index[#s_2] = 0
      
      \class = "Root"
      \type = #PB_GadgetType_Window
      \container = #PB_GadgetType_Window
      
      \color = def_colors
      \color\fore = 0
      \color\back = $FFF0F0F0
      \color\alpha = 255
      \color[1]\alpha = 128
      \color[2]\alpha = 128
      \color[3]\alpha = 128
      
      
      \image = AllocateStructure(_s_image)
      \image\x[2] = 5 ; padding 
      
      \text = AllocateStructure(_s_text)
      \text\align\horizontal = 1
      
      \caption\len = 12
      \caption\round = 4
      
      \caption\color = def_colors
      \caption\color\alpha = 255
      
      \flag\window\sizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \flag\window\systemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \flag\window\borderLess = Bool(Flag&#PB_Window_BorderLess)
      
      \fs = 1
      \bs = 1
      
      ; Background image
      \image[1] = AllocateStructure(_s_image)
      
      If Text.s
        SetText(*this, Text.s)
        \__height = 23
      EndIf
      ;
      Width + \bs*2
      Height + \__height + \bs*2
      
      OpenList(Root())
      SetActive(Root())
      Resize(Root(), 0, 0, Width,Height)
      
      If Not IsWindow(Window) 
        If Text
          If flag&#PB_Window_ScreenCentered
            w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, WindowID) 
          Else
            w = OpenWindow(Window, X,Y,Width,Height, "", #PB_Window_BorderLess, WindowID) 
          EndIf
          ;Root()\color\back = 0
        Else
          w = OpenWindow(Window, X,Y,Width,Height, "", Flag, WindowID) 
          Root()\color\back = $FFF0F0F0
        EndIf
        If Window =- 1 : Window = w : EndIf
        X = 0 : Y = 0
      Else
        Root()\color\back = $FFFFFFFF
      EndIf
      
      Root()\canvas\window = Window
      Root()\canvas\gadget = CanvasGadget(#PB_Any, X,Y,Width,Height, #PB_Canvas_Keyboard)
      
      If IsGadget(Root()\canvas\gadget)
        SetGadgetData(Root()\canvas\gadget, Root())
        SetWindowData(Root()\canvas\window, Root()\canvas\gadget)
        BindGadgetEvent(Root()\canvas\gadget, @g_Callback())
      EndIf
      
      If Bool(flag & #PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget)
        
        a_Add(*this)
        
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;-
  Procedure.i Post(eventtype.l, *this._s_widget, eventitem.l=#PB_All, *data=0)
    Protected result.i
    
    *event\widget = *this
    *event\data = *data
    *event\type = eventtype
    
    If Not *this\root\eventbind
      ; 
      Select eventtype 
        Case #PB_EventType_Focus, 
             #PB_EventType_LostFocus
          
          ForEach Root()\eventlist()
            If Root()\eventlist()\widget = *this And Root()\eventlist()\type = eventtype
              result = 1
            EndIf
          Next
          
          If Not result
            AddElement(Root()\eventlist())
            Root()\eventlist() = AllocateStructure(_s_event)
            Root()\eventlist()\widget = *this
            Root()\eventlist()\type = eventtype
            Root()\eventlist()\item = eventitem
            Root()\eventlist()\data = *data
          EndIf
          
      EndSelect
    EndIf
    
    If *this And *this\root\eventbind
      If *this\event And
         *this\root <> *this And 
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
    
    If Not *this\root\eventbind
      *this\root\eventbind = 1
    EndIf
    
    *this\event\type = eventtype
    *this\event\callback = *callback
    
    If ListSize(Root()\eventlist())
      ForEach Root()\eventlist()
        Post(Root()\eventlist()\type, Root()\eventlist()\widget, Root()\eventlist()\item, Root()\eventlist()\data)
      Next
      ClearList(Root()\eventlist())
    EndIf
    
    ProcedureReturn *this\event
  EndProcedure
  
  ;- 
  Procedure.i w_Events(*this._s_widget, EventType.i, EventItem.i=-1, EventData.i=0)
    Protected Result.i 
    
    With *this 
      If *this
        ; Scrollbar
        If \parent And 
           \parent\scroll 
          Select *this 
            Case \parent\scroll\v, 
                 \parent\scroll\h 
              *this = \parent
          EndSelect
        EndIf
        
        Post(EventType, *this, EventItem, EventData)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Macro _events_panel_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    
    If _event_type_ = #PB_EventType_MouseMove
      If _this_\tab\count
        If _this_\tab\bar\button[#bb_2]\len And 
           _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2])
          
          If _this_\tab\bar\button[#bb_2]\color\state <> #s_1
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_3
              _this_\tab\bar\button[#bb_2]\color\state = #s_1
            EndIf
            
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_0
              Debug " leave tab button - left to right"
              If _this_\tab\bar\button[#bb_1]\color\state <> #s_3 
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\index[#s_1] >= 0
              Debug " leave tab - " + _this_\tab\index[#s_1]
              _this_\tab\index[#s_1] =- 1
            EndIf
            Debug " enter tab button - right"
          EndIf
          
        ElseIf _this_\tab\bar\button[#bb_1]\len And
               _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1])
          
          If _this_\tab\bar\button[#bb_1]\color\state <> #s_1
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_3
              _this_\tab\bar\button[#bb_1]\color\state = #s_1
            EndIf
            
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_0
              Debug " leave tab button - right to left"
              If _this_\tab\bar\button[#bb_2]\color\state <> #s_3  
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\index[#s_1] >= 0
              Debug " leave tab - " + _this_\tab\index[#s_1]
              _this_\tab\index[#s_1] =- 1
            EndIf
            Debug " enter tab button - left"
          EndIf
          
        Else
          If _this_\tab\index[#s_1] =- 1
            If _this_\tab\bar\button[#bb_1]\color\state <> #s_0
              Debug " leave tab button - left"
              If _this_\tab\bar\button[#bb_1]\color\state <> #s_3 
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
            EndIf
            
            If _this_\tab\bar\button[#bb_2]\color\state <> #s_0
              Debug " leave tab button - right"
              If _this_\tab\bar\button[#bb_2]\color\state <> #s_3  
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
            EndIf
          EndIf
          
          ForEach _this_\tab\tabs()
            If _this_\tab\tabs()\drawing
              If _from_point_(mouse_x, mouse_y, _this_\tab\tabs()) And
                 _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_3])
                
                If _this_\tab\index[#s_1] <> _this_\tab\tabs()\index
                  If _this_\tab\index[#s_1] >= 0
                    Debug " leave tab - " + _this_\tab\index[#s_1]
                  EndIf
                  
                  _this_\tab\index[#s_1] = _this_\tab\tabs()\index
                  Debug " enter tab - " + _this_\tab\index[#s_1]
                EndIf
                Break
                
              ElseIf _this_\tab\index[#s_1] = _this_\tab\tabs()\index
                Debug " leave tab - " + _this_\tab\index[#s_1]
                _this_\tab\index[#s_1] =- 1
                Break
              EndIf
            EndIf
          Next
        EndIf
      EndIf
      
    ElseIf _event_type_ = #PB_EventType_LeftButtonDown
      If _this_\tab\index[#s_1] =- 1
        Select #s_1
          Case _this_\tab\bar\button[#bb_1]\color\state
            If Bar_ChangePos(_this_\tab\bar, (_this_\tab\bar\page\pos - _this_\tab\bar\scrollstep))   
              If Not _bar_in_start_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#bb_2]\color\state = #s_3 
                
                Debug " enable tab button - right"
                _this_\tab\bar\button[#bb_2]\color\state = #s_0
              EndIf
              
              _this_\tab\bar\button[#bb_1]\color\state = #s_2
              Repaint = #True
            Else
              _this_\tab\bar\button[#bb_1]\color\state = #s_3
            EndIf
            
          Case _this_\tab\bar\button[#bb_2]\color\state 
            If Bar_ChangePos(_this_\tab\bar, (_this_\tab\bar\page\pos + _this_\tab\bar\scrollstep)) 
              If Not _bar_in_stop_(_this_\tab\bar) And 
                 _this_\tab\bar\button[#bb_1]\color\state = #s_3 
                
                Debug " enable tab button - left"
                _this_\tab\bar\button[#bb_1]\color\state = #s_0
              EndIf
              
              _this_\tab\bar\button[#bb_2]\color\state = #s_2 
              Repaint = #True
            Else
              _this_\tab\bar\button[#bb_2]\color\state = #s_3
            EndIf
            
        EndSelect
      Else
        Repaint = SetState(_this_, _this_\tab\index[#s_1])
      EndIf
    EndIf
    
    If _this_\width[2] > 90
      ; Минимальный размер когда будет показыватся вторая кнопка
      
      If _this_\tab\bar\button[#bb_2]\x > _this_\tab\bar\button[#bb_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1])
          If _this_\tab\bar\button[#bb_1]\color\state = #s_3 Or
             _this_\tab\bar\button[#bb_2]\color\state = #s_3 Or
             (Not _this_\tab\bar\button[#bb_1]\color\state And
              Not _this_\tab\bar\button[#bb_2]\color\state)
            
            If _this_\tab\bar\button[#bb_1]\x > _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#bb_1], _this_\x[2])
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#bb_1]\x < _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width
            If Not _bar_in_start_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#bb_1], _this_\tab\bar\button[#bb_2]\x-_this_\tab\bar\button[#bb_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#bb_1]\color\state And 
           _this_\tab\bar\button[#bb_1]\color\state <> #s_3
          _this_\tab\bar\button[#bb_1]\color\state = #s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#bb_2]\color\state And 
           _this_\tab\bar\button[#bb_2]\color\state <> #s_3
          _this_\tab\bar\button[#bb_2]\color\state = #s_3
        EndIf
      EndIf
      
      If _this_\tab\bar\button[#bb_1]\x < _this_\tab\bar\button[#bb_3]\x 
        If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_2])
          If _this_\tab\bar\button[#bb_1]\color\state = #s_3 Or
             _this_\tab\bar\button[#bb_2]\color\state = #s_3 Or
             (Not _this_\tab\bar\button[#bb_1]\color\state And
              Not _this_\tab\bar\button[#bb_2]\color\state)
            
            If _this_\tab\bar\button[#bb_2]\x < _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width
              If Not _from_point_(_mouse_x_, _mouse_y_, _this_\tab\bar\button[#bb_1]) 
                _resize_panel_(_this_, _this_\tab\bar\button[#bb_2], _this_\x[2]+_this_\width[2]-_this_\tab\bar\button[#bb_2]\width)
              EndIf
            EndIf
            
          ElseIf _this_\tab\bar\button[#bb_2]\x > _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width
            If Not _bar_in_stop_(_this_\tab\bar) 
              _resize_panel_(_this_, _this_\tab\bar\button[#bb_2], _this_\tab\bar\button[#bb_1]\x+_this_\tab\bar\button[#bb_1]\width)
            EndIf
          EndIf
        EndIf
        
        If _bar_in_start_(_this_\tab\bar) And  
           _this_\tab\bar\button[#bb_1]\color\state And 
           _this_\tab\bar\button[#bb_1]\color\state <> #s_3
          _this_\tab\bar\button[#bb_1]\color\state = #s_3
        EndIf
        If _bar_in_stop_(_this_\tab\bar) And
           _this_\tab\bar\button[#bb_2]\color\state And 
           _this_\tab\bar\button[#bb_2]\color\state <> #s_3
          _this_\tab\bar\button[#bb_2]\color\state = #s_3
        EndIf
      EndIf
    EndIf
  EndMacro
  
  Macro _events_bar_(_this_, _event_type_, _mouse_x_, _mouse_y_)
    If _event_type_ = #PB_EventType_MouseMove
      If Not _this_\root\canvas\mouse\buttons
        If _this_\bar\button[#bb_3]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_3])
          If _this_\color[#bb_3]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_3
            Debug _this_\from
            _this_\color[#bb_3]\state = #s_1
            
            If _this_\cursor
              set_cursor(_this_, _this_\cursor)
            EndIf
          EndIf
          
        ElseIf _this_\bar\button[#bb_2]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_2])
          If _this_\color[#bb_2]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_2
            Debug _this_\from
            _this_\color[#bb_2]\state = #s_1
          EndIf
          
        ElseIf _this_\bar\button[#bb_1]\len And _from_point_(_mouse_x_, _mouse_y_, _this_\bar\button[#bb_1])
          If _this_\color[#bb_1]\state <> #s_1
            If _this_\from >= 0
              _this_\color[_this_\from]\state = #s_0
            EndIf
            
            _this_\from = #bb_1
            Debug _this_\from
            _this_\color[#bb_1]\state = #s_1
          EndIf
          
        Else
          If _this_\from <>- 1 ;And Not _from_point_(mouse_x,mouse_y, _this_\bar\button[_this_\from])
            If _this_\from >= 0
              ;_this_\color[_this_\from]\state = #s_0
              
              If _this_\from = #bb_3
                If _this_\cursor
                  set_cursor(_this_, #PB_Cursor_Default)
                EndIf
              EndIf
              
            EndIf
            
            ;Debug _this_\from
            ;_this_\from =- 1
          EndIf
        EndIf
      EndIf
    EndIf
    
  EndMacro
  
  
  Procedure.i From(*this._s_widget, mouse_x.i, mouse_y.i)
    Protected *enter._s_widget, Change.b, X.l,Y.l,Width.l,Height.l, parent_item.i
    Static *r._s_widget
    
    If Root()\canvas\mouse\x <> mouse_x
      Root()\canvas\mouse\x = mouse_x
      Change = 1
    EndIf
    
    If Root()\canvas\mouse\y <> mouse_y
      Root()\canvas\mouse\y = mouse_y
      Change = 1
    EndIf
    
    If Not *this
      *this = Root() ; GetGadgetData(EventGadget())
    EndIf
    
    If Change 
      With *this
        If *this And ListSize(\childrens()) ; \countItems ; Not Root()\canvas\mouse\buttons
          PushListPosition(\childrens())    ;
          LastElement(\childrens())         ; Что бы начать с последнего элемента
          Repeat                                ; Перебираем с низу верх
            If Not \childrens()\hide And _from_point_(mouse_x,mouse_y, \childrens(), [#c_4])
              
              If ListSize(\childrens()\childrens())
                Root()\canvas\mouse\x = 0
                Root()\canvas\mouse\y = 0
                *enter = From(\childrens(), mouse_x, mouse_y)
                
                If Not *enter
                  *enter = \childrens()
                EndIf
              Else
                *enter = \childrens()
              EndIf
              
              Break
            EndIf
            
          Until PreviousElement(\childrens()) = #False 
          PopListPosition(\childrens())
        EndIf
      EndWith
      *r = *enter
    Else
      *enter = *r
    EndIf
    
    If *enter
      With *enter 
        \root\canvas\mouse\x = mouse_x
        \root\canvas\mouse\y = mouse_y
        
        ; scrollbars events
        If \scroll
          If \scroll\v And Not \scroll\v\hide And \scroll\v\type And _from_point_(mouse_x,mouse_y, \scroll\v)
            *enter = \scroll\v
          ElseIf \scroll\h And Not \scroll\h\hide And \scroll\h\type And _from_point_(mouse_x,mouse_y, \scroll\h)
            *enter = \scroll\h
          EndIf
        EndIf
        
        
        ;_from_point_button_(*enter)
        ;_from_point_tab_(*enter, mouse_x, mouse_y, \tab)
        Protected Repaint
        _events_bar_(*enter, #PB_EventType_MouseMove, mouse_x, mouse_y)
        _events_panel_(*enter, #PB_EventType_MouseMove, mouse_x, mouse_y)
        
        If ListSize(\items())
          ; items at point
          ForEach \items()
            If \items()\drawing
              If (mouse_x>\items()\x And mouse_x=<\items()\x+\items()\width And 
                  mouse_y>\items()\y And mouse_y=<\items()\y+\items()\height)
                
                \index[#s_1] = \items()\index
                ; Debug " i "+\index[#s_1]+" "+ListIndex(\items())
                Break
              Else
                \index[#s_1] =- 1
              EndIf
            EndIf
          Next
        EndIf
        
        If \type <> #PB_GadgetType_Editor
          ; Columns at point
          If ListSize(\columns())
            
            ForEach \columns()
              If \columns()\drawing
                If (mouse_x>=\columns()\x And mouse_x=<\columns()\x+\columns()\width+1 And 
                    mouse_y>=\columns()\y And mouse_y=<\columns()\y+\columns()\height)
                  
                  \index[#s_1] = \columns()\index
                  Break
                Else
                  \index[#s_1] =- 1
                EndIf
              EndIf
              
              ; columns items at point
              ForEach \columns()\items()
                If \columns()\items()\drawing
                  If (mouse_x>\x[2] And mouse_x=<\x[2]+\width[2] And 
                      mouse_y>\columns()\items()\y And mouse_y=<\columns()\items()\y+\columns()\items()\height)
                    \columns()\index[#s_1] = \columns()\items()\index
                    
                  EndIf
                EndIf
              Next
              
            Next 
            
          EndIf
        EndIf
        
      EndWith
    EndIf
    
    ProcedureReturn *enter
  EndProcedure
  
  Procedure.i Events(*this._s_widget, at.i, EventType.i, mouse_x.i, mouse_y.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *this > 0
      
      ;       *value\type = EventType
      ;       *value\this = *this
      
      With *this
        Protected canvas = \root\canvas\gadget
        Protected window = \root\canvas\window
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LostFocus : Repaint = 1 : Repaint | w_Events(*this, EventType, at)
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0  : Repaint | w_Events(*this, EventType, at)
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                  Repaint = Bar_UpdatePos(*this, (mouse_y-\bar\thumb\len/2))
                Else
                  Repaint = Bar_UpdatePos(*this, (mouse_x-\bar\thumb\len/2))
                EndIf
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ;             Debug "events() LeftClick "+\type +" "+ at +" "+ *this
            Select \type
              Case #PB_GadgetType_Button,
                   #PB_GadgetType_Tree, 
                   #PB_GadgetType_ListView, 
                   #PB_GadgetType_ListIcon
                
                If Not \root\drag
                  Repaint | w_Events(*this, EventType, \index[#s_1])
                EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonDown : Repaint | w_Events(*this, EventType, at)
            ;             Debug "events() LeftButtonDown "+\type +" "+ at +" "+ *this
            Select \type 
              Case #PB_GadgetType_Window
                If at = 1
                  ;Free(*this)
                  
                  If *this = \root
                    PostEvent(#PB_Event_CloseWindow, \root\canvas\window, *this)
                    ;Post(#PB_Event_CloseWindow, *this, EventItem, EventData)
                  EndIf
                EndIf
                
              Case #PB_GadgetType_ComboBox
                \box\checked ! 1
                
                If \box\checked
                  Display_Popup(*this, \popup)
                Else
                  HideWindow(\popup\root\canvas\window, 1)
                EndIf
                
              Case #PB_GadgetType_Option
                Repaint = SetState(*this, 1)
                
              Case #PB_GadgetType_CheckBox
                Repaint = SetState(*this, Bool(\box\checked=#PB_Checkbox_Checked) ! 1)
                
              Case #PB_GadgetType_Tree,
                   #PB_GadgetType_ListView
                Repaint = Set_State(*this, \items(), \index[#s_1]) 
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\columns(), 0)
                  Repaint = Set_State(*this, \columns()\items(), \columns()\index[#s_1]) 
                EndIf
                
              Case #PB_GadgetType_HyperLink
                If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                
              Case #PB_GadgetType_Panel
                _events_panel_(*this, #PB_EventType_LeftButtonDown, mouse_x, mouse_y)
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin, #PB_GadgetType_Splitter
                Select at
                  Case #bb_1 : Repaint = SetState(*this, (\bar\page\pos - \bar\scrollstep)) ; Up button
                  Case #bb_2 : Repaint = SetState(*this, (\bar\page\pos + \bar\scrollstep)) ; Down button
                  Case #bb_3                                                                ; Thumb button
                    If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                      delta = mouse_y - \bar\thumb\pos
                    Else
                      delta = mouse_x - \bar\thumb\pos
                    EndIf
                EndSelect
                
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            w_Events(*this, EventType, *this\from)
            
            If delta
              If \bar\vertical And Bool(\type <> #PB_GadgetType_Spin)
                Repaint = Bar_UpdatePos(*this, (mouse_y-delta))
              Else
                Repaint = Bar_UpdatePos(*this, (mouse_x-delta))
              EndIf
            Else
              ;               If lastat <> at
              ;                 If lastat > 0 
              ;                   If lastat<4
              ;                     \color[lastat]\state = 0
              ;                   EndIf
              ;                   
              ;                 EndIf
              ;                 
              ;                 If \bar\max And ((at = 1 And _bar_in_start_(*this\bar)) Or (at = 2 And _bar_in_stop_(*this\bar)))
              ;                   \color[at]\state = 0
              ;                   
              ;                 ElseIf at>0 
              ;                   
              ;                   If at<4
              ;                     \color[at]\state = 1
              ;                     \color[at]\alpha = 255
              ;                   EndIf
              ;                   
              ;                 ElseIf at =- 1
              ;                   \color[1]\state = 0
              ;                   \color[2]\state = 0
              ;                   \color[3]\state = 0
              ;                   
              ;                   \color[1]\alpha = 128
              ;                   \color[2]\alpha = 128
              ;                   \color[3]\alpha = 128
              ;                 EndIf
              ;                 
              ;                 Repaint = #True
              ;                 lastat = at
              ;               EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \bar\scrollstep = 1
                  Repaint + ((\bar\max-\bar\min) / 100)
                Else
                  Repaint + \bar\scrollstep
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \bar\scrollstep = 1
                  Repaint - ((\bar\max-\bar\min) / 100)
                Else
                  Repaint - \bar\scrollstep
                EndIf
              EndIf
              
              Repaint = SetState(*this, (\bar\page\pos + Repaint))
            EndIf  
            
          Case #PB_EventType_MouseEnter
            w_Events(*this, EventType, *this\from)
            ;             If Not Root()\canvas\mouse\buttons And IsGadget(canvas)
            ;               \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor)
            ;               ;             Debug "events() MouseEnter " +" "+ at +" "+ *this;+\type +" "+ \cursor[1]  +" "+ \cursor
            ;             EndIf
            
          Case #PB_EventType_MouseLeave
            w_Events(*this, EventType, *this\from)
            
            ;             If Not Root()\canvas\mouse\buttons And IsGadget(canvas)
            ;               SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
            ;               ;             Debug "events() MouseLeave " +" "+ at +" "+ *this;+\type +" "+ \cursor[1]  +" "+ \cursor
            ;             EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            
            \color\state = 0
            If at>0 And at<4
              \color[at]\state = 0
            EndIf
            
            If \type <> #PB_GadgetType_Panel 
              If ListSize(\columns())
                SelectElement(\columns(), 0)
              EndIf
              ForEach \items()
                If \items()\state = 1
                  \items()\state = 0
                EndIf
              Next
              \index[#s_1] =- 1
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            
            If EventType = #PB_EventType_MouseEnter
              If \type = #PB_GadgetType_ScrollBar
                If \parent And \parent\scroll And 
                   (\parent\scroll\v = *this Or *this = \parent\scroll\h)
                  
                  If ListSize(\parent\columns())
                    SelectElement(\parent\columns(), 0)
                  EndIf
                  ForEach \parent\items()
                    If \parent\items()\state = 1
                      \parent\items()\state = 0
                    EndIf
                  Next
                  \parent\index[#s_1] =- 1
                  
                EndIf
              EndIf
            EndIf
            
            Select \type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \color\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              Case #PB_GadgetType_Window
              Default
                
                If at>0 And at<4 And EventType<>#PB_EventType_MouseEnter
                  \color[at]\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
                EndIf
            EndSelect
        EndSelect
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*this._s_widget, EventType.i, mouse_x.i=0, mouse_y.i=0)
    Protected repaint.i
    
    With *this
      If Not Bool(*this And *this\root)
        ProcedureReturn
      EndIf
      
      ; Enter/Leave mouse events
      If *event\enter <> *this
        If *event\enter <> Root()
          
          ;           If *event\enter = Parent
          ;             Debug "leave first"
          ;           Else
          ;             Debug "enter Parent"
          ;           EndIf
          
          repaint = 1
        EndIf
        
        If *event\enter And *event\enter <> \Parent And *event\enter <> \Window And *event\enter <> Root() 
          If *event\enter\root\canvas\mouse\buttons
            ;             Debug "selected out"
          Else
            Events(*event\enter, *event\enter\from, #PB_EventType_MouseLeave, mouse_x, mouse_y)
          EndIf
        EndIf
        
        If *this
          If (Not *event\enter Or (*event\enter And *event\enter\parent <> *this))
            ;             If Not *event\enter
            ;               Debug "enter first"
            ;             EndIf
            ;             
            ;             If (*event\enter And *event\enter\parent <> *this)
            ;               Debug "leave parent"
            ;             EndIf
            
            If *this\root\canvas\mouse\buttons
              ;               Debug "selected ower"
            Else
              Events(*this, *this\from, #PB_EventType_MouseEnter, mouse_x, mouse_y)
            EndIf
          EndIf
          
          *this\leave = *event\enter
          *event\enter = *this
        Else
          Root()\leave = *event\enter
          *event\enter = Root()
        EndIf
      EndIf
      
      Select EventType 
        Case #PB_EventType_MouseMove,
             #PB_EventType_MouseEnter, 
             #PB_EventType_MouseLeave
          
          If Root()\canvas\mouse\buttons
            ; Drag start
            If Root()\canvas\mouse\delta And
               Not (Root()\canvas\mouse\x>Root()\canvas\mouse\delta\x-1 And 
                    Root()\canvas\mouse\x<Root()\canvas\mouse\delta\x+1 And 
                    Root()\canvas\mouse\y>Root()\canvas\mouse\delta\y-1 And
                    Root()\canvas\mouse\y<Root()\canvas\mouse\delta\y+1)
              
              If Not Root()\drag : Root()\drag = 1
                w_Events(*this, #PB_EventType_DragStart, \index[#s_2])
              EndIf
            EndIf
            
            If Root()\active\a_gadget 
              repaint | Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_MouseMove, mouse_x, mouse_y)
            EndIf  
            
          ElseIf *this And *this = *event\enter
            repaint | Events(*this, \from, #PB_EventType_MouseMove, mouse_x, mouse_y)
            repaint = 1 ; нужен для итемов при проведении мыши чтобы виделялся
          EndIf
          
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_RightButtonDown 
          
          ; Drag & Drop
          Root()\canvas\mouse\delta = AllocateStructure(_s_mouse)
          Root()\canvas\mouse\delta\x = Root()\canvas\mouse\x
          Root()\canvas\mouse\delta\y = Root()\canvas\mouse\y
          
          If *this And *this = *event\enter 
            \state = 2 
            SetActive(*this)
            
            repaint | Events(*this, \from, EventType, mouse_x, mouse_y)
            repaint = 1
          EndIf
          
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_RightButtonUp 
          
          If Root()\active\a_gadget And
             Root()\active\a_gadget\state = 2 
            Root()\active\a_gadget\state = 1 
            
            repaint | Events(Root()\active\a_gadget, Root()\active\a_gadget\from, EventType, mouse_x, mouse_y)
            
            If _from_point_(mouse_x, mouse_y, Root()\active\a_gadget, [#c_4])
              
              If Root()\active\a_gadget = *this       
                If EventType = #PB_EventType_LeftButtonUp
                  repaint | Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_LeftClick, mouse_x, mouse_y)
                EndIf
                If EventType = #PB_EventType_RightClick
                  repaint | Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_RightClick, mouse_x, mouse_y)
                EndIf
              EndIf
              
            Else
              Root()\active\a_gadget\state = 0
              repaint | Events(Root()\active\a_gadget, Root()\active\a_gadget\from, #PB_EventType_MouseLeave, mouse_x, mouse_y)
            EndIf
            
            Root()\active\a_gadget\root\canvas\mouse\buttons = 0   
            If Root()\active\a_gadget\root\canvas\mouse\delta
              FreeStructure(Root()\active\a_gadget\root\canvas\mouse\delta)
              Root()\active\a_gadget\root\canvas\mouse\delta = 0
              Root()\active\a_gadget\drag = 0
            EndIf
            
            repaint = 1
          EndIf
          
          ; Drag & Drop
          Root()\canvas\mouse\buttons = 0
          If Root()\canvas\mouse\delta
            FreeStructure(Root()\canvas\mouse\delta)
            Root()\canvas\mouse\delta = 0
            Root()\drag = 0
          EndIf
          
          ; active widget key state
        Case #PB_EventType_Input, 
             #PB_EventType_KeyDown, 
             #PB_EventType_KeyUp
          
          If *this And (Root()\active\a_gadget = *this Or *this = Root()\active)
            
            \root\canvas\keyboard\input = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Input)
            \root\canvas\keyboard\key = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Key)
            \root\canvas\keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
            
            repaint | Events(*this, 0, EventType, mouse_x, mouse_y)
          EndIf
          
      EndSelect
      
      ; anchors events
      If a_Callback(*this, EventType, \root\canvas\mouse\buttons, mouse_x,mouse_y)
        ProcedureReturn 1
      EndIf
      
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure g_Events(Canvas.i, EventType.i)
    Protected Repaint, *this._s_widget
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      mouse_x = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      mouse_y = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *root._s_widget = GetGadgetData(Canvas)
    
    
    
    Select EventType
      Case #PB_EventType_Repaint : Repaint = 1
        ;         mouse_x = 0
        ;         mouse_y = 0
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Resize(*root, #PB_Ignore, #PB_Ignore, Width, Height)  
        Repaint = 1
        
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        ; set mouse buttons
        ;If *this = *event\enter 
        If EventType = #PB_EventType_LeftButtonDown
          *root\root\canvas\mouse\buttons | #PB_Canvas_LeftButton
        ElseIf EventType = #PB_EventType_RightButtonDown
          *root\root\canvas\mouse\buttons | #PB_Canvas_RightButton
        ElseIf EventType = #PB_EventType_MiddleButtonDown
          *root\root\canvas\mouse\buttons | #PB_Canvas_MiddleButton
        EndIf
        ;EndIf
        
        Repaint | CallBack(From(*root, mouse_x, mouse_y), EventType, mouse_x, mouse_y)
        
        ; reset mouse buttons
        If *root\root\canvas\mouse\buttons
          If EventType = #PB_EventType_LeftButtonUp
            *root\root\canvas\mouse\buttons &~ #PB_Canvas_LeftButton
          ElseIf EventType = #PB_EventType_RightButtonUp
            *root\root\canvas\mouse\buttons &~ #PB_Canvas_RightButton
          ElseIf EventType = #PB_EventType_MiddleButtonUp
            *root\root\canvas\mouse\buttons &~ #PB_Canvas_MiddleButton
          EndIf
        EndIf
    EndSelect
    
    If Repaint 
      ReDraw(*root)
    EndIf
  EndProcedure
  
  Procedure.i g_Callback()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected mouse_x = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected mouse_y = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
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
          If MouseLeave = 1 And Not Bool((mouse_x>=0 And mouse_x<Width) And (mouse_y>=0 And mouse_y<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | g_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | g_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
      Static Last_X, Last_Y
      If Last_Y <> mouse_y
        Last_Y = mouse_y
        Result | g_Events(EventGadget, EventType)
      EndIf
      If Last_x <> mouse_x
        Last_x = mouse_x
        Result | g_Events(EventGadget, EventType)
      EndIf
    Else
      Result | g_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global *c, *s
  
  Procedure Enumerates(*this._S_widget, *callback)
    With *this
      If *callback
        CallCFunctionFast(*callback, *this)
        
        If ListSize(\childrens())
          ForEach \childrens()
            Enumerates(\childrens(), *callback)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure enum(*this._S_widget)
    If Not *this\hide
      Debug " class - " + *this\Class +" ("+ *this\tab\index +" - parent_item)"
    EndIf
  EndProcedure
  
  Procedure Events()
    
  EndProcedure
  
  
  If OpenWindow(3, 0, 0, 655, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(3, 0, 0, 655, 605, "Root", #PB_Flag_AnchorsGadget|#PB_Flag_BorderLess)
      Define *w,*w1,*w2
      
      
      Define *f=Form     (388, 8, 256, 303, "window1", 0)
      ;       Form     ( 8, 8, 256, 303, "window3", 0, Root()\opened)
      ;       Form     ( 8, 8, 256, 303, "window4", 0, Root()\opened)
      ScrollArea(10,10,140,140, 200,200)
      ;Button(10, 15, 80, 24,"Кнопка 1")
      Combobox(10, 15, 80, 24)
      AddItem(Widget(), -1, "Combobox")
      SetState(Widget(), 0)
      
      Button(95, 15, 80, 24,"Кнопка 2")
      CloseList()
      
      Spin(160, 10, 90, 41, 0, 10)
      Spin(160, 60, 90, 41, 0, 10, #PB_Flag_Vertical)
      
      *s=Splitter(10, 155, 300, 152, Splitter(5,5, 300, 152, Button(0, 0, 0, 0,"кнопка 15"), 
      Button(0, 0, 0, 0,"кнопка 15")), Button(0, 0, 0, 0,"кнопка 15"), #PB_Splitter_Vertical) 
      
      ;       ForEach Root()\childrens()
      ;         Debug Root()\childrens()\text\string
      ;       Next
      
      ReDraw(Root())
    EndIf
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---------------------------------------------------------------------------------------------------------------------
; EnableXP