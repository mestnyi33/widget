
DeclareModule Widget
  EnableExplicit
  #Anchors = 9
  
  
  ;- - STRUCTUREs
  ;- - Default_S
  Structure Default_S
    Gadget.i
    Window.i
    Type.i
    Event.i
    *Function
     *This.Widget_S
     *Last.Widget_S
;    *Widget.Widget_S
    *Active.Widget_S
    *Focus.Widget_S
  EndStructure
  
  ;- - Coordinate_S
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - Box_S
  Structure Box_S Extends Coordinate_S
    Size.i[4]
    Checked.b[2] 
    ;Toggle.b
    
    ArrowSize.a[3]
    ArrowType.b[3]
    
    ThreeState.b
    *Color.Color_S[4]
  EndStructure
  
  ;- - Color_S
  Structure Color_S
    State.b ; entered; selected; focused; lostfocused
    Front.i[4]
    Line.i[4]
    Fore.i[4]
    Back.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
  EndStructure
  
  ;- - Align_S
  Structure Align_S
    X.i
    y.i
    x1.i
    y1.i
    Left.b
    Top.b
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - Flag_S
  Structure Flag_S
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - Image_S
  Structure Image_S Extends Coordinate_S
    index.i
    ImageID.i
    change.b
    Align.Align_S
  EndStructure
  
  ;- - Text_S
  Structure Text_S Extends Coordinate_S
    Big.i[3]
    Pos.i
    Len.i
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    FontID.i
    String.s[3]
    Change.b
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Align.Align_S
  EndStructure
  
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    p_i.i  ; index parent tab item
    *p.Widget_S ; adress parent
    *s.Scroll_S ; 
    *a.Items_S
    *SplitterFirst.Widget_S
    *SplitterSecond.Widget_S
    First.i
    Second.i
    ; track bar
    Ticks.b
    
    ; progress bar
    Smooth.b
    
    at.b
    Type.i[3] ; [2] for splitter
    Radius.a
    
    Max.i
    Min.i
    *Step
    Hide.b[2]
    *Box.Box_S
    
    Focus.b
    Change.i[2]
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    *v.Widget_S
    *h.Widget_S
  EndStructure
  
  ;- - Items_S
  Structure Items_S Extends Coordinate_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *a.Items_S
    Drawing.i
    
    Image.Image_S
    Text.Text_S[4]
    *Box.Box_S
    
    State.b
    Hide.b[2]
    Caret.i[3]  ; 0 = Pos ; 1 = PosFixed
    Vertical.b
    Radius.i
    
    change.b
    sublevel.i
    sublevellen.i
    
    childrens.i
    *data      ; set/get item data
  EndStructure
  
  ;- - Mouse_S
  Structure Mouse_S
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
    *Delta.Mouse_S
  EndStructure
  
  ;- - Canvas_S
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i[3]
    Window.i
    *Widget.Widget_S
    
    Input.c
    Key.i[2]
  EndStructure
  
  
  ;- - Anchor_S
  Structure Anchor_S
    X.i[2]
    Y.i[2]
    Pos.i
    State.i
    Width.i
    Height.i
    Hide.i[2]
    *p.Widget_S ; adress parent
    Cursor.i[2]
    Color.Color_S[4]
  EndStructure
  
  
  ;- - Widget_S
  Structure Widget_S Extends Bar_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    
    
    *Popup.Widget_S
    
    *anchor.Anchor_S[#Anchors+1]
    Grid.i
    Enumerate.i
    *data
    
    *OptionGroup.Widget_S
    
    fs.i 
    bs.i
    TabHeight.i
    
    Text.Text_S[4]
    Image.Image_S
    Flag.Flag_S
    
    List *Childrens.Widget_S()
    List *Items.Items_S()
    List *Columns.Widget_S()
    ;List *Draws.Items_S()
    
    
    *Align.Align_S
    clip.Coordinate_S
    
    Cursor.i[2]
    
    sublevellen.i
    Drag.i[2]
    Attribute.i
    Canvas.Canvas_S
  EndStructure
  
  
  ;-
  ;- - DECLAREs CONSTANTs
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version =< 546
      #PB_EventType_Resize
    CompilerEndIf
    #PB_EventType_Free
    #PB_EventType_Create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  #PB_Bar_NoButtons = 5
  #PB_Bar_Direction = 6
  
  EnumerationBinary 4
    #PB_Bar_Smooth 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks 
  EndEnumeration
  
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
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
    
    #PB_Flag_AutoSize
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    #PB_Flag_AnchorsGadget
    
    #PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    
    #PB_Flag_Limit
  EndEnumeration
  
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
    #PB_Image_Stretch
    #PB_Image_Proportionally
    
    #PB_DisplayMode_NoFullSelection  ; = 512 ; #PB_ListIcon_FullRowSelect
    #PB_DisplayMode_AlwaysShowSelection                                    ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  EndEnumeration
  
  ;- - DECLAREs GLOBALs
  Global *Value.Default_S
  
  Prototype.i Resize(*This, iX.i,iY.i,iWidth.i,iHeight.i) 
  
  ;- - DECLAREs MACROs
  ;-
  Macro PB(Function)
    Function
  EndMacro
  
  Macro Use(_window_, _canvas_)
    Bool(IsWindow(_window_) And IsGadget(_canvas_))
    
    Widget::*value\window = _window_
    Widget::*value\gadget = _canvas_
  EndMacro
  
  Macro IsBar(_this_)
    Bool(_this_ And (_this_\Type = #PB_GadgetType_ScrollBar Or _this_\Type = #PB_GadgetType_TrackBar Or _this_\Type = #PB_GadgetType_ProgressBar Or _this_\Type = #PB_GadgetType_Splitter))
  EndMacro
  
  Macro IsWidget(_this_)
    Bool(_this_>0 And _this_\Type And Not IsGadget(First) ) * _this_
  EndMacro
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  
  Macro IsStart(_this_)
    Bool(_this_\Page\Pos =< _this_\Min)
  EndMacro
  
  ; Then scroll bar end position
  Macro IsStop(_this_)
    Bool(_this_\Page\Pos >= (_this_\Max-_this_\Page\len))
  EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=1)
    (Bool(_inverted_) * ((_this_\Min + (_this_\Max - _this_\Page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro SetImage(_item_, _image_)
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
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.i Y(*This.Widget_S)
  Declare.i X(*This.Widget_S)
  Declare.i Width(*This.Widget_S)
  Declare.i Height(*This.Widget_S)
  Declare.i Draw(*This.Widget_S, Childrens=0)
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, State.i)
  Declare.i GetAttribute(*This.Widget_S, Attribute.i)
  Declare.i SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare.i CallBack(*This.Widget_S, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This.Widget_S, iX.i,iY.i,iWidth.i,iHeight.i);, *That.Widget_S=#Null)
  Declare.i Hide(*This.Widget_S, State.i)
  Declare.i GetImage(*This.Widget_S)
  Declare.i GetType(*This.Widget_S)
  Declare.i SetData(*This.Widget_S, *Data)
  Declare.i GetData(*This.Widget_S)
  Declare.i SetText(*This.Widget_S, Text.s)
  Declare.s GetText(*This.Widget_S)
  Declare.i GetItemState(*This.Widget_S, Item.i)
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare.i GetParent(*This.Widget_S)
  Declare.i GetParentItem(*This.Widget_S)
  
  Declare.i SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
  Declare.i SetItemData(*This.Widget_S, Item.i, *Data)
  Declare.i GetItemData(*This.Widget_S, Item.i)
  Declare.i CountItems(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare.i SetItemAttribute(*This.Widget_S, Item.i, Attribute.i, Value.i)
  Declare.i GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
  Declare.i Enumerate(*This.Integer, *Parent.Widget_S, Item.i=0)
  Declare.i SetItemText(*This.Widget_S, Item.i, Text.s)
  Declare.s GetItemText(*This.Widget_S, Item.i)
  
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
  Declare.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
  Declare.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
  Declare.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
  Declare.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Window(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
  Declare.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i CheckBox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Popup(*Widget.Widget_S, X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i ComboBox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
  Declare.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
  Declare.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  
  Declare.i OpenList(*This.Widget_S, Item.i=0)
  Declare.i CloseList()
  Declare.i SetParent(*This.Widget_S, *Parent.Widget_S, Item.i=0)
  Declare.i AddItem(*This.Widget_S, Item.i, Text.s, Image.i=-1, Flag.i=0)
  
  Declare.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.i CallBacks(*This.Widget_S, EventType.i, MouseX.i=0, MouseY.i=0)
  Declare.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
EndDeclareModule

Module Widget
  ;- MODULE
  
  *Value = AllocateStructure(Default_S)
  *Value\Type =- 1
  *Value\Gadget =- 1
  *Value\Window =- 1
  
  Global Colors.Color_S
  Global NewList *openedlist.Widget_S()
  
  With Colors                          
    \State = 0
    ; - Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
  EndWith
  
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
  CompilerEndIf
  
  Macro SetAutoSize(_this_, _state_)
    _this_\Canvas\Gadget = *Value\Gadget
    _this_\Canvas\Window = *Value\Window
    
    If Bool(_state_) : x=0 : y=0
      _this_\Align = AllocateStructure(Align_S)
      _this_\Align\Left = 1
      _this_\Align\Top = 1
      _this_\Align\Right = 1
      _this_\Align\Bottom = 1
    EndIf
  EndMacro
  
  Macro SetLastParent(_this_)
    ; Set parent
    If LastElement(*openedlist())
      If _this_\Type = #PB_GadgetType_Option
        If ListSize(*openedlist()\Childrens()) 
          If *openedlist()\Childrens()\Type = #PB_GadgetType_Option
            _this_\OptionGroup = *openedlist()\Childrens()\OptionGroup 
          Else
            _this_\OptionGroup = *openedlist()\Childrens() 
          EndIf
        Else
          _this_\OptionGroup = *openedlist()
        EndIf
      EndIf
      SetParent(_this_, *openedlist(), *openedlist()\o_i)
    EndIf
  EndMacro
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min)) * ((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
    : If _this_\Thumb\Len > _this_\Area\Len : _this_\Thumb\Len = _this_\Area\Len : EndIf 
    : If _this_\Box : If _this_\Vertical And Bool(_this_\Type <> #PB_GadgetType_Spin) : _this_\Box\Height[3] = _this_\Thumb\len : Else : _this_\Box\Width[3] = _this_\Thumb\len : EndIf : EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) 
    : If _this_\Thumb\Pos < _this_\Area\Pos : _this_\Thumb\Pos = _this_\Area\Pos : EndIf 
    : If _this_\Thumb\Pos > _this_\Area\Pos+_this_\Area\Len : _this_\Thumb\Pos = (_this_\Area\Pos+_this_\Area\Len)-_this_\Thumb\Len : EndIf 
    : If _this_\Box : If _this_\Vertical And Bool(_this_\Type <> #PB_GadgetType_Spin) : _this_\Box\y[3] = _this_\Thumb\Pos : Else : _this_\Box\x[3] = _this_\Thumb\Pos : EndIf : EndIf
  EndMacro
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_Round_Nearest) * Grid)))
  EndProcedure
  
  ;-
  ;- Anchors
  Macro Draw_Anchors(_this_)
    DrawingMode(#PB_2DDrawing_Outlined)
    If _this_\anchor[9] : Box(_this_\anchor[9]\x, _this_\anchor[9]\y, _this_\anchor[9]\width, _this_\anchor[9]\height ,_this_\anchor[9]\color[_this_\anchor[9]\State]\frame) : EndIf
    
    DrawingMode(#PB_2DDrawing_Default)
    If _this_\anchor[1] : Box(_this_\anchor[1]\x, _this_\anchor[1]\y, _this_\anchor[1]\width, _this_\anchor[1]\height ,_this_\anchor[1]\color[_this_\anchor[1]\State]\back) : EndIf
    If _this_\anchor[2] : Box(_this_\anchor[2]\x, _this_\anchor[2]\y, _this_\anchor[2]\width, _this_\anchor[2]\height ,_this_\anchor[2]\color[_this_\anchor[2]\State]\back) : EndIf
    If _this_\anchor[3] : Box(_this_\anchor[3]\x, _this_\anchor[3]\y, _this_\anchor[3]\width, _this_\anchor[3]\height ,_this_\anchor[3]\color[_this_\anchor[3]\State]\back) : EndIf
    If _this_\anchor[4] : Box(_this_\anchor[4]\x, _this_\anchor[4]\y, _this_\anchor[4]\width, _this_\anchor[4]\height ,_this_\anchor[4]\color[_this_\anchor[4]\State]\back) : EndIf
    If _this_\anchor[5] And Not _this_\Container : Box(_this_\anchor[5]\x, _this_\anchor[5]\y, _this_\anchor[5]\width, _this_\anchor[5]\height ,_this_\anchor[5]\color[_this_\anchor[5]\State]\back) : EndIf
    If _this_\anchor[6] : Box(_this_\anchor[6]\x, _this_\anchor[6]\y, _this_\anchor[6]\width, _this_\anchor[6]\height ,_this_\anchor[6]\color[_this_\anchor[6]\State]\back) : EndIf
    If _this_\anchor[7] : Box(_this_\anchor[7]\x, _this_\anchor[7]\y, _this_\anchor[7]\width, _this_\anchor[7]\height ,_this_\anchor[7]\color[_this_\anchor[7]\State]\back) : EndIf
    If _this_\anchor[8] : Box(_this_\anchor[8]\x, _this_\anchor[8]\y, _this_\anchor[8]\width, _this_\anchor[8]\height ,_this_\anchor[8]\color[_this_\anchor[8]\State]\back) : EndIf
    
    DrawingMode(#PB_2DDrawing_Outlined)
    If _this_\anchor[1] : Box(_this_\anchor[1]\x, _this_\anchor[1]\y, _this_\anchor[1]\width, _this_\anchor[1]\height ,_this_\anchor[1]\color[_this_\anchor[1]\State]\frame) : EndIf
    If _this_\anchor[2] : Box(_this_\anchor[2]\x, _this_\anchor[2]\y, _this_\anchor[2]\width, _this_\anchor[2]\height ,_this_\anchor[2]\color[_this_\anchor[2]\State]\frame) : EndIf
    If _this_\anchor[3] : Box(_this_\anchor[3]\x, _this_\anchor[3]\y, _this_\anchor[3]\width, _this_\anchor[3]\height ,_this_\anchor[3]\color[_this_\anchor[3]\State]\frame) : EndIf
    If _this_\anchor[4] : Box(_this_\anchor[4]\x, _this_\anchor[4]\y, _this_\anchor[4]\width, _this_\anchor[4]\height ,_this_\anchor[4]\color[_this_\anchor[4]\State]\frame) : EndIf
    If _this_\anchor[5] : Box(_this_\anchor[5]\x, _this_\anchor[5]\y, _this_\anchor[5]\width, _this_\anchor[5]\height ,_this_\anchor[5]\color[_this_\anchor[5]\State]\frame) : EndIf
    If _this_\anchor[6] : Box(_this_\anchor[6]\x, _this_\anchor[6]\y, _this_\anchor[6]\width, _this_\anchor[6]\height ,_this_\anchor[6]\color[_this_\anchor[6]\State]\frame) : EndIf
    If _this_\anchor[7] : Box(_this_\anchor[7]\x, _this_\anchor[7]\y, _this_\anchor[7]\width, _this_\anchor[7]\height ,_this_\anchor[7]\color[_this_\anchor[7]\State]\frame) : EndIf
    If _this_\anchor[8] : Box(_this_\anchor[8]\x, _this_\anchor[8]\y, _this_\anchor[8]\width, _this_\anchor[8]\height ,_this_\anchor[8]\color[_this_\anchor[8]\State]\frame) : EndIf
  EndMacro
  
  Macro Resize_Anchors(_this_)
    If _this_\anchor[1] 
      _this_\anchor[1]\x = _this_\x-_this_\anchor[1]\width+_this_\anchor[1]\Pos
      _this_\anchor[1]\y = _this_\y+(_this_\height-_this_\anchor[1]\height)/2
    EndIf
    If _this_\anchor[2] 
      _this_\anchor[2]\x = _this_\x+(_this_\width-_this_\anchor[2]\width)/2
      _this_\anchor[2]\y = _this_\y-_this_\anchor[2]\height+_this_\anchor[2]\Pos
    EndIf
    If  _this_\anchor[3]
      _this_\anchor[3]\x = _this_\x+_this_\width-_this_\anchor[3]\Pos
      _this_\anchor[3]\y = _this_\y+(_this_\height-_this_\anchor[3]\height)/2
    EndIf
    If _this_\anchor[4] 
      _this_\anchor[4]\x = _this_\x+(_this_\width-_this_\anchor[4]\width)/2
      _this_\anchor[4]\y = _this_\y+_this_\height-_this_\anchor[4]\Pos
    EndIf
    If _this_\anchor[5] 
      _this_\anchor[5]\x = _this_\x-_this_\anchor[5]\width+_this_\anchor[5]\Pos
      _this_\anchor[5]\y = _this_\y-_this_\anchor[5]\height+_this_\anchor[5]\Pos
    EndIf
    If _this_\anchor[6] 
      _this_\anchor[6]\x = _this_\x+_this_\width-_this_\anchor[6]\Pos
      _this_\anchor[6]\y = _this_\y-_this_\anchor[6]\height+_this_\anchor[6]\Pos
    EndIf
    If _this_\anchor[7] 
      _this_\anchor[7]\x = _this_\x+_this_\width-_this_\anchor[7]\Pos
      _this_\anchor[7]\y = _this_\y+_this_\height-_this_\anchor[7]\Pos
    EndIf
    If _this_\anchor[8] 
      _this_\anchor[8]\x = _this_\x-_this_\anchor[8]\width+_this_\anchor[8]\Pos
      _this_\anchor[8]\y = _this_\y+_this_\height-_this_\anchor[8]\Pos
    EndIf
    If _this_\anchor[9] 
      _this_\anchor[9]\x = _this_\x
      _this_\anchor[9]\y = _this_\y
      _this_\anchor[9]\width = _this_\width
      _this_\anchor[9]\height = _this_\height
    EndIf
  EndMacro
  
  Procedure Events_Anchors(*This.Widget_S, mouse_x,mouse_y)
    With *This
      Protected px,py,Grid = \Grid
      
      If \p
        px = \p\x[2]
        py = \p\y[2]
      EndIf
      
      Protected mx = Match(mouse_x-px, Grid)
      Protected my = Match(mouse_y-py, Grid)
      Protected mw = Match((\x+\Width-Bool(Grid>1))-mouse_x, Grid)+Bool(Grid>1)
      Protected mh = Match((\y+\height-Bool(Grid>1))-mouse_y, Grid)+Bool(Grid>1)
      Protected mxw = Match(mouse_x-\x, Grid)+Bool(Grid>1)
      Protected myh = Match(mouse_y-\y, Grid)+Bool(Grid>1)
      
      Select \anchor
        Case \anchor[1] : Resize(*This, mx, #PB_Ignore, mw, #PB_Ignore)
        Case \anchor[2] : Resize(*This, #PB_Ignore, my, #PB_Ignore, mh)
        Case \anchor[3] : Resize(*This, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
        Case \anchor[4] : Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
          
        Case \anchor[5] 
          If \Container
            Resize(*This, mx, my, #PB_Ignore, #PB_Ignore)
          Else
            Resize(*This, mx, my, mw, mh)
          EndIf
        Case \anchor[6] : Resize(*This, #PB_Ignore, my, mxw, mh)
        Case \anchor[7] : Resize(*This, #PB_Ignore, #PB_Ignore, mxw, myh)
        Case \anchor[8] : Resize(*This, mx, #PB_Ignore, mw, myh)
          
        Case \anchor[9] 
          If Not \Container
            Resize(*This, mx, my, #PB_Ignore, #PB_Ignore)
          EndIf
      EndSelect
    EndWith
  EndProcedure
  
  Procedure CallBack_Anchors(*This.Widget_S, EventType.i, Buttons.i, MouseScreenX.i,MouseScreenY.i)
    Protected i 
    Static Result.i, *p.Widget_S
    
    With *This
      Select EventType 
        Case #PB_EventType_MouseMove
          If *p And *p\anchor
            Protected x = MouseScreenX-*p\anchor\x[1]
            Protected y = MouseScreeny-*p\anchor\y[1]
            
            Events_Anchors(*p, x,y)
            
            ProcedureReturn 1
            
          ElseIf Not Buttons
            For i = #Anchors To 1 Step - 1
              If \anchor[i]
                If (MouseScreenX>\anchor[i]\X And MouseScreenX=<\anchor[i]\X+\anchor[i]\Width And 
                    MouseScreenY>\anchor[i]\Y And MouseScreenY=<\anchor[i]\Y+\anchor[i]\Height)
                  
                  If \anchor <> \anchor[i] : \anchor = \anchor[i]
                    If Not \anchor[i]\State
                      \anchor[i]\State = 1
                    EndIf
                    
                    \anchor[i]\Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor[i]\Cursor)
                    If i<>5
                      Result = 1
                    EndIf
                  EndIf
                  
                ElseIf \anchor[i]\State = 1
                  \anchor[i]\State = 0
                  \anchor = 0
                  
                  If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) <> \anchor[i]\Cursor[1]
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor[i]\Cursor[1])
                  EndIf
                  Result = 0
                EndIf
              EndIf
            Next
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          
          If \anchor : \anchor\State = 2 : *p = *This 
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor\Cursor)
            \anchor\x[1] = MouseScreenX-\anchor\x
            \anchor\y[1] = MouseScreenY-\anchor\y
            ProcedureReturn 0
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If \anchor : \anchor\State = 1 : *p = 0
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor\Cursor[1])
            ProcedureReturn 0
          EndIf
          
      EndSelect
      
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetAnchors(*This.Widget_S, State)
    ; ProcedureReturn
    
    Structure DataBuffer
      cursor.i[#Anchors+1]
    EndStructure
    
    Protected *Cursor.DataBuffer = ?CursorsBuffer
    
    With *This
      If \p
        \Grid = \p\Grid
      Else
        \Grid = 5
      EndIf
      
      If State
        Protected i
        
        For i=1 To #Anchors
          \anchor[i] = AllocateStructure(Anchor_S)
          \anchor[i]\p = *This
          \anchor[i]\Cursor = *Cursor\Cursor[i]
          \anchor[i]\Color[0]\Frame = $000000
          \anchor[i]\Color[1]\Frame = $FF0000
          \anchor[i]\Color[2]\Frame = $0000FF
          
          \anchor[i]\Color[0]\Back = $FFFFFF
          \anchor[i]\Color[1]\Back = $FFFFFF
          \anchor[i]\Color[2]\Back = $FFFFFF
          
          \anchor[i]\Height = 6
          \anchor[i]\Width = 6
          \anchor[i]\Pos = \anchor[i]\Height/2
        Next i
        
         ; \anchor[9]\Width * 2
        
        If \Container
          \anchor[5]\Width * 2
          \anchor[5]\Height * 2
          \anchor[5]\Pos = 9
        EndIf
        
      EndIf
    EndWith
    
    DataSection
      CursorsBuffer:
      Data.i 0
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
  
  
  ;-
  Procedure.i SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
    With *This
      If \p
        Select Type
          Case 1 ; widget
          Case 2 ; text
          Case 3 ; image
        EndSelect
        
        \Align.Align_S = AllocateStructure(Align_S)
        
        \Align\Right = 0
        \Align\Bottom = 0
        \Align\Left = 0
        \Align\Top = 0
        \Align\Horizontal = 0
        \Align\Vertical = 0
        
        If Mode&#PB_Right=#PB_Right
          \Align\x = (\p\Width-\p\bs*2 - (\x-\p\x-\p\bs)) - \Width
          \Align\Right = 1
        EndIf
        If Mode&#PB_Bottom=#PB_Bottom
          \Align\y = (\p\height-\p\bs*2 - (\y-\p\y-\p\bs)) - \height
          \Align\Bottom = 1
        EndIf
        If Mode&#PB_Left=#PB_Left
          \Align\Left = 1
          If Mode&#PB_Right=#PB_Right
            \Align\x1 = (\p\Width - \p\bs*2) - \Width
          EndIf
        EndIf
        If Mode&#PB_Top=#PB_Top
          \Align\Top = 1
          If Mode&#PB_Bottom=#PB_Bottom
            \Align\y1 = (\p\height -\p\bs*2)- \height
          EndIf
        EndIf
        
        If Mode&#PB_Center=#PB_Center
          \Align\Horizontal = 1
          \Align\Vertical = 1
        EndIf
        If Mode&#PB_Horizontal=#PB_Horizontal
          \Align\Horizontal = 1
        EndIf
        If Mode&#PB_Vertical=#PB_Vertical
          \Align\Vertical = 1
        EndIf
        
        Resize(\p, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.s Make(*This.Widget_S, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric And Text.s <> #LF$
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
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String, \Text\Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String, \Text\Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Text\Caret + 1, 1) = "."
                ;                 \Text\Caret + 1 : \Text\Caret[1]=\Text\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String, \Text\Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String, \Text\Caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.s Wrap (*This.Widget_S, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$="", TextWidth
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;  
    
    
    CountString = CountString(Text.s, #LF$) 
    ; Protected time = ElapsedMilliseconds()
    
    ; ;     Protected Len
    ; ;     Protected *s_0.Character = @Text.s
    ; ;     Protected *e_0.Character = @Text.s 
    ; ;     #SOC = SizeOf (Character)
    ; ;       While *e_0\c 
    ; ;         If *e_0\c = #LF
    ; ;           Len = (*e_0-*s_0)>>#PB_Compiler_Unicode
    ; ;           line$ = PeekS(*s_0, Len) ;Trim(, #LF$)
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
        If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ;   
          Break
        Else
          length - 1
        EndIf
      Wend 
      
      ;  Debug ""+start +" "+ length
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
              found + FindString(delimList$, Mid(RTrim(line$),ii,1))
              If found <> 2
                Continue
              EndIf
            Else
              found = FindString(delimList$, Mid(line$,ii,1))
            EndIf
            
            If found
              start = ii
              Break
            EndIf
          Next
        EndIf
        
        If found
          found = 0
        Else
          start = length
        EndIf
        
        LineRet$ + Left(line$, start) + nl$
        line$ = LTrim(Mid(line$, start+1))
        start = Len(line$)
        length = start
        
        ; Get text len
        While length > 1
          ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
          If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ; 
            Break
          Else
            length - 1
          EndIf
        Wend 
        
      Wend   
      
      ret$ + LineRet$ + line$ + #CR$+nl$
      LineRet$=""
    Next
    
    ; ;       *s_0 = *e_0 + #SOC : EndIf : *e_0 + #SOC : Wend
    ;Debug  ElapsedMilliseconds()-time
    ; MessageRequester("",Str( ElapsedMilliseconds()-time))
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
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
  
  Procedure.i Pos(*This.Widget_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = \Min + Round((ThumbPos - \Area\Pos) / (\Area\len / (\Max-\Min)), #PB_Round_Nearest)
      ScrollPos = Round(ScrollPos/(\Step + Bool(Not \Step)), #PB_Round_Nearest) * \Step
      If (\Vertical And \Type = #PB_GadgetType_TrackBar)
        ScrollPos = Invert(*This, ScrollPos, \inverted)
      EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      Resize(_this_\SplitterFirst, 0, 0, _this_\width, _this_\Thumb\Pos-_this_\y)
      Resize(_this_\SplitterSecond, 0, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y))
    Else
      Resize(_this_\SplitterFirst, 0, 0, _this_\Thumb\Pos-_this_\x, _this_\height)
      Resize(_this_\SplitterSecond, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\Pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro Resize_Childrens(_this_, _change_x_, _change_y_)
    ForEach _this_\Childrens()
      Resize(_this_\Childrens(), (_this_\Childrens()\x-_this_\x-_this_\bs) + _change_x_, (_this_\Childrens()\y-_this_\y-_this_\bs-_this_\TabHeight) + _change_y_, #PB_Ignore, #PB_Ignore)
    Next
  EndMacro
  
  Procedure Tree_AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last.Items_S
    
    If Not *This
      ProcedureReturn 0
    EndIf
    
    With *This
      ;{ Генерируем идентификатор
      If 0 > Item Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        ;       PreviousElement(\items())
        ;       If \a\sublevel = \items()\sublevel
        ;          \a = \items()
        ;       EndIf
        
        ;       SelectElement(\items(), Item)
        If \a\sublevel = *last\sublevel
          \a = *last
        EndIf
        
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
      
      \items() = AllocateStructure(Items_S)
      \items()\Box = AllocateStructure(Box_S)
      
      If subLevel
        If sublevel>ListIndex(\items())
          sublevel=ListIndex(\items())
        EndIf
      EndIf
      
      If \a
        If subLevel = \a\subLevel 
          \items()\a = \a\a
        ElseIf subLevel > \a\subLevel 
          \items()\a = \a
          *last = \items()
        ElseIf \a\a
          \items()\a = \a\a\a
        EndIf
        
        If \items()\a And subLevel > \items()\a\subLevel
          sublevel = \items()\a\sublevel + 1
          \items()\a\childrens + 1
          ;             \items()\a\Box\Checked = 1
          ;             \items()\hide = 1
        EndIf
      Else
        \items()\a = \items()
      EndIf
      
      
      \a = \items()
      \items()\change = 1
      \items()\index= Item
      \items()\index[1] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \Text\height
      
      SetImage(\items(), Image)
      
      \items()\y = \s\height
      \s\height + \items()\height
      
      \image\imageID = \items()\image\imageID
      \image\width = \items()\image\width+4
      \CountItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure Property_AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *adress.Items_S
    
    If Not *This
      ProcedureReturn 0
    EndIf
    
    With *This
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\items()) - 1
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
          \items()\index= ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(Items_S)
      \items()\Box = AllocateStructure(Box_S)
      
      If subLevel
        If sublevel>ListIndex(\items())
          sublevel=ListIndex(\items())
        EndIf
        
        PushListPosition(\items()) 
        While PreviousElement(\items()) 
          If subLevel = \items()\subLevel
            *adress = \items()\a
            Break
          ElseIf subLevel > \items()\subLevel
            *adress = \items()
            Break
          EndIf
        Wend 
        PopListPosition(\items()) 
        
        If *adress
          If subLevel > *adress\subLevel
            sublevel = *adress\sublevel + 1
            *adress\childrens + 1
            ;             *adress\Box\Checked = 1
            ;             \items()\hide = 1
          EndIf
        EndIf
      EndIf
      
      \items()\change = 1
      \items()\index= Item
      \items()\index[1] =- 1
      \items()\a = *adress
      \items()\text\change = 1
      
      Protected Type$ = Trim(StringField(Text, 1, " "))
      Protected Info$ = Trim(StringField(Text, 2, " ")) 
      
      If sublevel
        If Info$ : Info$+":" : EndIf
      EndIf
      
      Protected Title$ = Trim(StringField(Text, 3, " "))
      
      
      \items()\text\string.s = Info$
      \items()\text[1]\string.s = Title$
      \items()\sublevel = sublevel
      \items()\height = \Text\height
      
      SetImage(\items(), Image)
      \CountItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  
  ;-
  ;- DRAWING
  Procedure.i Draw_String(*This.Widget_S, scroll_x,scroll_y)
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw frame
      If \Color\Back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      EndIf
      
      ;       If \Text\Change : \Text\Change = #False
      ;         \Text\Width = TextWidth(\Text\String.s) 
      ;         
      ;         If \Text\FontID 
      ;           \Text\Height = TextHeight("A") 
      ;         Else
      ;           \Text\Height = *This\Text\Height[1]
      ;         EndIf
      ;       EndIf 
      
      If \Text[1]\Change : \Text[1]\Change = #False
        \Text[1]\Width = TextWidth(\Text[1]\String.s) 
      EndIf 
      
      If \Text[3]\Change : \Text[3]\Change = #False 
        \Text[3]\Width = TextWidth(\Text[3]\String.s)
      EndIf 
      
      If \Text[2]\Change : \Text[2]\Change = #False 
        \Text[2]\X = \Text\X+\Text[1]\Width
        ; Debug "get caret "+\Text[3]\Len
        \Text[2]\Width = TextWidth(\Text[2]\String.s) ;+ Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *This\Flag\FullSelection ; TextWidth() - bug in mac os
        \Text[3]\X = \Text[2]\X+\Text[2]\Width
      EndIf 
      
      Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
      Protected angle.f
      
      Macro RowBackColor(_this_, _state_)
        _this_\Color\Back[_state_]&$FFFFFFFF|_this_\color\alpha<<24
      EndMacro
      Macro RowForeColor(_this_, _state_)
        _this_\Color\Fore[_state_]&$FFFFFFFF|_this_\color\alpha<<24
      EndMacro
      Macro RowFrameColor(_this_, _state_)
        _this_\Color\Frame[_state_]&$FFFFFFFF|_this_\color\alpha<<24
      EndMacro
      Macro RowFontColor(_this_, _state_)
        _this_\Color\Front[_state_]&$FFFFFFFF|_this_\color\alpha<<24
      EndMacro
      
      Height = \Text\Height
      Y = \Text\Y
      Text_X = \Text\X
      Text_Y = \Text\Y
      Angle = Bool(\Text\Vertical) * *This\Text\Rotate
      Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\color\alpha<<24
      Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\color\alpha<<24
      
      ; Draw string
      If \Text[2]\Len And *This\Color\Front <> *This\Color\Front[2]
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          If (*This\Text\Caret[1] > *This\Text\Caret And *This\index[2] = *This\index[1]) Or
             (\index = *This\index[1] And *This\index[2] > *This\index[1])
            \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
            
            If *This\index[2] = *This\index[1]
              \Text[2]\X = \Text[3]\X-\Text[2]\Width
            EndIf
            
            If \Text[3]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
            EndIf
            
            If *This\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
            
            If \Text[1]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(Text_X, Text_Y, \Text\String.s, angle, Front_BackColor_1)
            
            If *This\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
          EndIf
        CompilerElse
          If \Text[1]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
          EndIf
          
          If *This\Color\Fore[2]
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
          EndIf
          
          If \Text[2]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
          EndIf
          
          If \Text[3]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
          EndIf
        CompilerEndIf
        
      Else
        If \Text[2]\Len
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
        EndIf
        
        If \Color\State = 2
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
        Else
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
        EndIf
      EndIf
      
      ; Draw caret
      If \Text\Editable And \Focus : DrawingMode(#PB_2DDrawing_XOr)   
        Line(\Text\X + \Text[1]\Width + Bool(\Text\Caret[1] > \Text\Caret) * \Text[2]\Width - Bool(#PB_Compiler_OS = #PB_OS_Windows), \Text\y, 1, \Text\Height, $FFFFFFFF)
      EndIf
      
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
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
  
  Procedure.i Draw_Window(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      Protected sx,sw,x = \x
      Protected px=2,py
      Protected start, stop
      
      Protected State_3 = \Color[3]\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw caption frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y+\bs, \Width[2], \TabHeight, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      EndIf
      
      ;       ; Draw image
      ;       If \image[1]\adress
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\adress, \image[1]\x, \image[1]\y, \color[1]\alpha)
      ;       EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x+5, \Text\y-(\TabHeight+\Text\height)/2, \Text\String.s, \Color\Front[State_3]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw caption frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y+\bs-\fs, \Width[1], \TabHeight+\fs, \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \Color\back[State_3]<>-1
        If \Color\Fore[State_3]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State_3], \Color\Back[State_3], \Radius, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \Color\Frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Frame[State_3]&$FFFFFF|Alpha)
      EndIf
    EndWith
  EndProcedure
  
   Procedure Draw_ListIcon(*This.Widget_S, scroll_x,scroll_y)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = 4
    Protected Drawing.b,column_width,column_height,column_x,l=1, n, height = 18, text_color=$000000
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    
    ;     If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\bs, *This\bs, *This\width[2], *This\height[2], back_color)
      
      With *This\Columns()\Items()
        If *This\image\width
          n=19
          column_x = *This\bs+(n*(1+Bool(*This\flag\CheckBoxes))) + 4
        EndIf
        column_x - *This\s\h\page\Pos
        column_width = column_x
        *This\s\v\Step = height+Bool(*This\flag\GridLines)*2+l
        
        ForEach *This\Columns()
          ;If ListSize(*This\Columns()\Items())
          column_height = *This\Columns()\height
          ;*This\s\Width=*This\bs
          *This\s\height=*This\bs+column_height
          *This\Columns()\x=column_width ; + 20;*This\Columns()\Image\width
          iWidth = *This\Columns()\x + *This\Columns()\width
          iWidth = *This\width[2]-Width(*This\s\v)
          iHeight = *This\height[2]-Height(*This\s\h)
          
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            ClipOutput(*This\bs, *This\bs, *This\width[2], iHeight)
          CompilerEndIf
          
          If *This\Columns()\text\change = 1
            *This\Columns()\text\height = TextHeight("A") 
            *This\Columns()\text\width = TextWidth(*This\Columns()\text\string.s)
            *This\Columns()\text\change = 0
          EndIf
          
          *This\Columns()\text\x = 5+*This\Columns()\x
          *This\Columns()\text\y = *This\Columns()\y+(column_height+2-*This\Columns()\text\height)/2
          
          ;Drawing = Bool(\y+\height>*This\bs+*This\Columns()\height And \y<*This\height[2])
          
          PushListPosition(*This\Items())
          ForEach *This\Columns()\Items()
            If Not \hide
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                ClipOutput(*This\bs, *This\bs+column_height, iwidth, iHeight) ; Bug
              CompilerEndIf
              
              
              \x=*This\bs+*This\Columns()\x-column_x; ;
              \width=iwidth
              \height=height
              \y=*This\s\height-*This\s\v\page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A") 
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag\buttons 
                x_content=*This\bs+column_width-column_x+2+(w+\sublevel*w)-*This\s\h\page\Pos
              Else
                x_content=*This\bs+column_width-column_x+2+(\sublevel*w)-*This\s\h\page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = \y+(\height-\box\height)/2
              
              If \Image\ImageID
                \Image\x = 2+x_content
                \Image\y = \y+(\height-\Image\height)/2
                
                *This\Image\ImageID = \Image\ImageID
                *This\Columns()\Image\width = \Image\width+10
              EndIf
              
              If \text\width
                \text\x = 1+x_content+*This\Columns()\Image\width+Bool(*This\Flag\CheckBoxes)
                \text\y = \y+(\height-\text\height)/2
              EndIf
              
              If *This\Flag\CheckBoxes
                \box\x+n-2
                \text\x+n-2
                \Image\x+n-2
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = *This\bs+4
                \box\y[1] = \y+(\height-\box\height[1])/2
              EndIf
              
              *This\s\height+\height+l+Bool(*This\Flag\GridLines)*2
              ;               If *This\s\Width < (\text\x+\text\width+n)+*This\s\h\page\Pos
              ;                 *This\s\Width = (\text\x+\text\width+n)+*This\s\h\page\Pos
              ;               EndIf
              
              Drawing = Bool(\y+\height>*This\bs+*This\Columns()\height And \y<*This\height[2])
              If Drawing
                ;If (\index=\focus And \lostfocus<>\focus) Or
                If    (*This\Focus And *This\Flag\FullSelection And *This\Index[1] = \Index )
                  
                  box_color = $FFFFFF
                  text_color=$FFFFFF
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                
                ; Draw selections
                If \index=\Index[1] ;Or \index=\focus ; \index=*This\Index[1] ; с этим остается последное виделеное слово
                  Protected SelectionPos, SelectionLen 
                  If *This\Flag\FullSelection
                    SelectionPos = *This\bs
                    SelectionLen = iwidth
                  Else
                    SelectionPos = \Text\X - 2
                    SelectionLen = \Text\width + 4
                  EndIf
                  
                  ; Draw items back color
                  If *This\Color\Fore
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                   ; BoxGradient(\Vertical,SelectionPos,\Y,SelectionLen,\Height,*This\Color\Fore[\Color\State],*This\Color\Back[\Color\State],\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                   ; RoundBox(SelectionPos,\Y,SelectionLen,\Height,\Radius,\Radius,*This\Color\Back[\Color\State])
                  EndIf
                  ;Debug Point(\x+2,\y+2)
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(SelectionPos,\y,SelectionLen,\height, *This\Color\Frame[*This\Color\State])
                EndIf
                
                ; Draw boxes
                If *This\flag\buttons And \childrens
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \Box\Checked[1])+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                EndIf
              EndIf
              
              
              If Drawing
                If ListIndex(*This\Columns())=0
                  ; Draw checkbox
                  If *This\Flag\CheckBoxes
                    Draw_Box(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \Box\checked, checkbox_color, box_color, 2, alpha);, box_type)
                  EndIf
                  
                  ; Draw image
                  If \Image\ImageID
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawAlphaImage(\Image\ImageID, \Image\x, \Image\y, alpha)
                  EndIf
                EndIf
                
                ; Draw string
                If \text\string.s
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    ClipOutput(*This\Columns()\x, *This\bs+column_height, *This\Columns()\width, iHeight)
                  CompilerEndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                  
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    UnclipOutput()
                  CompilerEndIf
                EndIf
                
                If *This\Flag\GridLines
                  ; Horizontal line
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*This\bs, (\y+\height)+l, iwidth, l, $ADADAE&$FFFFFF|alpha<<24)
                  ;Box(*This\Columns()\x-column_x, (\y+\height)+l, *This\Columns()\width+column_x, l, $ADADAE&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items())
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            UnclipOutput()
          CompilerEndIf
          
          
          
          
          
          
          DrawingMode(#PB_2DDrawing_Default)
          ; Box(*This\bs, 0, iwidth, column_height+3, back_color)
          ; Draw
          DrawingMode(#PB_2DDrawing_Gradient)
          ;BoxGradient(0,*This\Columns()\x+1, 0, *This\Columns()\width-1, column_height, $FFFFFF,$F4F4F5)
          
          If ListIndex(*This\Columns())=0
            DrawingMode(#PB_2DDrawing_Gradient)
            BoxGradient(0,*This\bs, 0, iwidth, column_height, $FFFFFF,$F4F4F5)
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(*This\Columns()\x-column_x, column_height, iwidth,1,$ADADAE)
          
          
          ; Vertical line
          If *This\Flag\GridLines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bs, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bs, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bs, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bs, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\Columns()\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(*This\Columns()\text\x, *This\Columns()\text\y, *This\Columns()\text\string.s, $000000&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\bs
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*This\bs-1, *This\Columns()\height+1, *This\width[2]+2, 1, $FFFFFF)
          EndIf
          
          column_width + *This\Columns()\width
          ;EndIf
        Next
        
        *This\s\Height = *This\s\Height-l-Bool(*This\Flag\GridLines)*2
        
        ; Задаем размеры скролл баров
        CompilerIf Defined(Bar, #PB_Module)
          Bar::Draws(*This\s, *This\s\Height, *This\s\Width)
        CompilerEndIf
        
        If *This\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          Box((*This\bs-*This\fs), (*This\bs-*This\fs), *This\width[1], *This\height[1], $ADADAE)
        EndIf
        
        If *This\bs
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\bs-1, *This\bs-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
        EndIf
        
        
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Draw_Scroll(*This.Widget_S, scroll_x,scroll_y)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Box\x[2]
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Box\y[2]
      ;Debug \width
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \Color\Line[State_0]<>-1
        If \Vertical
          Line( \X, \Y, 1, \Page\len + Bool(\height<>\Page\len), \Color\Line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \X, \Y, \Page\len + Bool(\width<>\Page\len), 1, \Color\Line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \Thumb\len 
        ; Draw thumb  
        If \Color[3]\back[State_3]<>-1
          If \Color[3]\Fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[3], \Box\y[3], \Box\Width[3], \Box\Height[3], \Color[3]\Fore[State_3], \Color[3]\Back[State_3], \Radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \Color[3]\Frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[3], \Box\y[3], \Box\Width[3], \Box\Height[3], \Radius, \Radius, \Color[3]\Frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \Box\Size[1]
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool( \Vertical),
               (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
      EndIf
      
      If \Box\Size[2]
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool( \Vertical)+2, 
               (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
      EndIf
      
      If \Thumb\len And \Color[3]\Fore[State_3]<>-1  ; Draw thumb lines
        If \Focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line( \Box\x[3]+(\Box\Width[3]-8)/2, \Box\y[3]+\Box\Height[3]/2-3,9,1, LinesColor)
          Line( \Box\x[3]+(\Box\Width[3]-8)/2, \Box\y[3]+\Box\Height[3]/2,9,1, LinesColor)
          Line( \Box\x[3]+(\Box\Width[3]-8)/2, \Box\y[3]+\Box\Height[3]/2+3,9,1, LinesColor)
        Else
          Line( \Box\x[3]+\Box\Width[3]/2-3, \Box\y[3]+(\Box\Height[3]-8)/2,1,9, LinesColor)
          Line( \Box\x[3]+\Box\Width[3]/2, \Box\y[3]+(\Box\Height[3]-8)/2,1,9, LinesColor)
          Line( \Box\x[3]+\Box\Width[3]/2+3, \Box\y[3]+(\Box\Height[3]-8)/2,1,9, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*This.Widget_S, scroll_x,scroll_y)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String, \Color\Front[State_3]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*This.Widget_S, scroll_x,scroll_y)
      
      If \Box\Size[2]
        Protected Radius = \height[2]/7
        If Radius > 4
          Radius = 7
        EndIf
        
          ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], Radius, \color\alpha)
        EndIf
         
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], Radius, Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], Radius, Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
      
        ; Draw arrows
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool(\Vertical)*3,
               (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
        
        ; Draw arrows
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool(Not \Vertical)+1, 
               (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
        
        
        Line(\Box\x[1]-2, \y[2],1,\height[2], \Color\Frame&$FFFFFF|Alpha)
      EndIf      
    EndWith
  EndProcedure
  
  Procedure.i Draw_ScrollArea(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \s And (\s\v And \s\h)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\s\h\x-GetState(\s\h), \s\v\y-GetState(\s\v), \s\h\Max, \s\v\Max, $FFFF0000)
        Box(\s\h\x, \s\v\y, \s\h\Page\Len, \s\v\Page\Len, $FF00FF00)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Container(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Frame(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      If \Text\String.s
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \TabHeight/2
        Box(\x[1], \y+h, 6, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\Text\x+\Text\width+3, \y+h, \width[1]-((\Text\x+\Text\width)-\x)-3, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[1], \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1]+\width[1]-\fs, \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1], \Y[1]+\height[1]-\fs, \width[1], \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Panel(*This.Widget_S, scroll_x,scroll_y)
    Protected State_3.i, Alpha.i, Color_Frame.i
    
    With *This 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \x
      Protected start, stop
      
      Protected clip_x = \clip\x+\Box\Size[1]+3
      Protected clip_width = \clip\width-\Box\Size[1]-\Box\Size[2]-6
      
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \width[2]>(\Box\width[1]+\Box\width[2]+4)
        ClipOutput(clip_x, \clip\y, clip_width, \clip\height)
        
        ForEach \items()
          If \index[2] = \items()\index
            State_3 = 2
            \items()\y = \y+2
            \items()\Height=\TabHeight-1
          Else
            State_3 = \items()\State
            \items()\y = \y+4
            \items()\Height=\TabHeight-4-1
          EndIf
          Color_Frame = \Color\Frame[State_3]&$FFFFFF|Alpha
      
          \items()\image\x[1] = 8 ; Bool(\items()\image\width) * 4
          
          If \items()\Text\Change
            \items()\Text\width = TextWidth(\items()\Text\String)
            \items()\Text\height = TextHeight("A")
          EndIf
          
          \items()\x = 2+x-\Page\Pos+\Box\Size[1]+1
          \items()\width = \items()\Text\width + \items()\image\x[1]*2 + \items()\image\width + Bool(\items()\image\width) * 3
          x + \items()\width + 1
          
          \items()\image\x = \items()\x+\items()\image\x[1] - 1
          \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
          
          \items()\Text\x = \items()\image\x + \items()\image\width + Bool(\items()\image\width) * 3
          \items()\Text\y = \items()\y+(\items()\height-\items()\Text\height)/2
          
          If State_3 = 2
            sx = \items()\x
            sw = \items()\width
            start = Bool(\items()\x<\Area\Pos+1 And \items()\x+\items()\width>\Area\Pos+1)*2
            stop = Bool(\items()\x<\Area\Pos+\Area\len-2 And \items()\x+\items()\width>\Area\Pos+\Area\len-2)*2
          EndIf
          
          \items()\Drawing = Bool(Not \items()\hide And \items()\x+\items()\width>\x+\bs And \items()\x<\x+\width-\bs)
          
          If \items()\Drawing
            ; Draw thumb  
            If \Color\back[State_3]<>-1
              If \Color\Fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              BoxGradient( \Vertical, \items()\X, \items()\Y, \items()\Width, \items()\Height, \Color\Fore[State_3], Bool(State_3 <> 2)*\Color\Back[State_3] + (Bool(State_3 = 2)*\Color\Front[State_3]), \Radius, \color\alpha)
            EndIf
            
            ; Draw string
            If \items()\Text\String
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\items()\Text\x, \items()\Text\y, \items()\Text\String.s, \Color\Front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \items()\image\imageID
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, \color\alpha)
            EndIf
            
            ; Draw thumb frame
            If \Color\Frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\items()\X, \items()\Y, \items()\Width, 1, Color_Frame)                     ; top
                Line(\items()\X, \items()\Y, 1, \items()\Height, Color_Frame)                    ; left
                Line((\items()\X+\items()\width)-1, \items()\Y, 1, \items()\Height, Color_Frame) ; right
              Else
                RoundBox( \items()\X, \items()\Y, \items()\Width, \items()\Height, \Radius, \Radius, Color_Frame)
              EndIf
            EndIf
          EndIf
          
          \items()\Text\Change = 0
        Next
        
        ClipOutput(\clip\x, \clip\y, \clip\width, \clip\height)
        
        If ListSize(\items())
          Protected Value = (\Box\Size[1]+(((\items()\x+\Page\Pos)-\x)+\items()\width)-1)
          
          If \Max <> Value : \Max = Value
            \Area\Pos = \X+\Box\Size[1]
            \Area\len = \width-(\Box\Size[1]+\Box\Size[2])
            \Thumb\len = ThumbLength(*This)
            \Step = \Thumb\len
            
            If \Change > 0 And SelectElement(\Items(), \Change-1)
              Protected State = ((\Box\Size[1]+(\items()\x+\items()\width)-\x[2])-\Page\len)
              
              If State < \Min
                State = \Min 
              EndIf
              
              If State > \Max-\Page\len
                If \Max > \Page\len 
                  State = \Max-\Page\len
                Else
                  State = \Min 
                EndIf
              EndIf
              
              \Page\Pos = State
            EndIf
          EndIf
        EndIf
        
        ; Линии на концах для красоты
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        If Not IsStart(*This)
          Line(\Box\x[1]+\Box\width[1]+1, \Box\y[1], 1, \TabHeight-5+start, \Color\Frame[start]&$FFFFFF|Alpha)
        EndIf
        If Not IsStop(*This)
          Line(\Box\x[2]-2, \Box\y[1], 1, \TabHeight-5+stop, \Color\Frame[stop]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Line(\X[2], \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\Area\Pos, \Y+\TabHeight, sx-\Area\Pos, 1, \Color\Frame&$FFFFFF|Alpha)
        Line(sx+sw, \Y+\TabHeight, \width-((sx+sw)-\x), 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\Box\x[2]-2, \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\X, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X+\width-1, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X, \Y+\height-1, \width, 1, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
    EndWith
    
    With *This
      Protected State_1 = \Color[1]\State
      Protected State_2 = \Color[2]\State
      
      If \Box\Size[1] Or \Box\Size[2]
        ; Draw buttons
        
        If State_1 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Box\Color[1]\Back[State_1]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Box\Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        If State_2 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Box\Color[2]\Back[State_2]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Box\Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool( \Vertical),
               (Bool(Not IsStart(*This)) * \Box\Color[1]\Front[State_1] + IsStart(*This) * \Box\Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
        
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool( \Vertical)+2, 
               (Bool(Not IsStop(*This)) * \Box\Color[2]\Front[State_2] + IsStop(*This) * \Box\Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Progress(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\y,\Width-4,\Thumb\Pos, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X+2,\y+2,\Width-4,\Thumb\Pos-2, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,(\height-\Thumb\Pos), \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x)-2,\height-4, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),0)
        
        ;Debug ""+\x+" "+\Thumb\Pos
      EndIf
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X+1, \Y+1, \Width-2, \Height-2, \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color[3]\Frame)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Property(*This.Widget_S, scroll_x,scroll_y)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 255
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    
    With *This
      If *This > 0
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          X = \X
          Y = \Y
          Width = \Width 
          Height = \Height
          
          ; Позиция сплиттера 
          Size = \Thumb\len
          
          If \Vertical
            Pos = \Thumb\Pos-y
          Else
            Pos = \Thumb\Pos-x
          EndIf
          
          
          ; set vertical bar state
          If \s\v\Max And \Change > 0
            If (\Change*\Text\height-\s\h\Page\len) > \s\h\Max
              \s\h\Page\Pos = (\Change*\Text\height-\s\h\Page\len)
            EndIf
          EndIf
          
          \s\Width=0
          \s\height=0
          
          ForEach \items()
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\s\h\Page\len
              \items()\x=\s\h\x-\s\h\Page\Pos
              \items()\y=(\s\v\y+\s\height)-\s\v\Page\Pos
              
              If \items()\text\change = 1
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = box_size
              \items()\box\height = box_size
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\CheckBoxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = box_1_size
                \items()\box\height[1] = box_1_size
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \s\height+\items()\height
              
              If \s\Width < (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
                \s\Width = (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; Задаем размеры скролл баров
          If \s\v And \s\v\Page\Len And \s\v\Max<>\s\height And 
             Widget::SetAttribute(\s\v, #PB_Bar_Maximum, \s\height)
            Widget::Resizes(\s, \x-\s\h\x+1, \y-\s\v\y+1, #PB_Ignore, #PB_Ignore)
            \s\v\Step = \Text\height
          EndIf
          
          If \s\h And \s\h\Page\Len And \s\h\Max<>\s\Width And 
             Widget::SetAttribute(\s\h, #PB_Bar_Maximum, \s\Width)
            Widget::Resizes(\s, \x-\s\h\x+1, \y-\s\v\y+1, #PB_Ignore, #PB_Ignore)
          EndIf
          
          
          
          ForEach \items()
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            If \items()\Drawing
              \items()\width = \s\h\Page\len
              State_3 = \items()\State
              
              ; Draw selections
              If Not \items()\Childrens And \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\Box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\Box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\a 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\a\height/2)-\s\v\Page\Pos
                    Else 
                      start = \items()\a\y+\items()\a\height+\items()\a\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\CheckBoxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\Box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\clip\x,\clip\y,\clip\width-(\width-(\Thumb\Pos-\x)),\clip\height)
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x+(\Thumb\Pos-\x),\clip\y,\clip\width-(\Thumb\Pos-\x),\clip\height)
              
              ;\items()\text[1]\x[1] = 5
              \items()\text[1]\x = \x+\items()\text[1]\x[1]+\Thumb\len
              \items()\text[1]\y = \items()\text\y
              ; Draw string
              If \items()\text[1]\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text[1]\x+pos, \items()\text[1]\y, \items()\text[1]\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
          ; Draw Splitter
          DrawingMode(#PB_2DDrawing_Outlined) 
          Line((X+Pos)+Size/2,Y,1,Height, \Color\Frame)
        EndIf
        
        
        ;         If \bs
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           Box(\x, \y, \width, \height, $ADADAE)
        ;         EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Tree(*This.Widget_S, scroll_x,scroll_y)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 255
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    With *This
      If *This > 0
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          ; set vertical bar state
          If \s\v\Max And \Change > 0
            \s\v\Max = \s\height
            ; \s\v\Max = \CountItems*\Text\height
            ; Debug ""+Str(\Change*\Text\height-\s\v\Page\len+\s\v\Thumb\len) +" "+ \s\v\Max
            If (\Change*\Text\height-\s\v\Page\len) <> \s\v\Page\Pos  ;> \s\v\Max
                                                                      ; \s\v\Page\Pos = (\Change*\Text\height-\s\v\Page\len)
              SetState(\s\v, (\Change*\Text\height-\s\v\Page\len))
              Debug ""+\s\v\Page\Pos+" "+Str(\Change*\Text\height-\s\v\Page\len)  +" "+\s\v\Max                                               
              
            EndIf
          EndIf
          
          \s\Width=0
          \s\height=0
          
          ; Resize items
          ForEach \items()
            ;\items()\height = 20
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;               \s\Width=0
            ;               \s\height=0
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\s\h\Page\len
              \items()\x=\s\h\x-\s\h\Page\Pos
              \items()\y=(\s\v\y+\s\height)-\s\v\Page\Pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = box_size
              \items()\box\height = box_size
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\CheckBoxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = box_1_size
                \items()\box\height[1] = box_1_size
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \s\height+\items()\height
              
              If \s\Width < (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
                \s\Width = (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; set vertical scrollbar max value
          If \s\v And \s\v\Page\Len And \s\v\Max<>\s\height And 
             Widget::SetAttribute(\s\v, #PB_Bar_Maximum, \s\height) : \s\v\Step = \Text\height
            Widget::Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \s\h And \s\h\Page\Len And \s\h\Max<>\s\Width And 
             Widget::SetAttribute(\s\h, #PB_Bar_Maximum, \s\Width)
            Widget::Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; Draw items
          ForEach \items()
            
            
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            
            If \items()\Drawing
              \items()\width=\s\h\Page\len
              State_3 = \items()\State
              
              ; Draw selections
              If \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\Box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\Box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\a 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\a\height/2)-\s\v\Page\Pos
                    Else 
                      start = \items()\a\y+\items()\a\height+\items()\a\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\CheckBoxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\Box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
        EndIf
        
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Text(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_CheckBox(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\Box\height)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked = #PB_Checkbox_Checked
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        For i = 0 To 2
          LineXY((\box\X+3),(i+\box\Y+8),(\box\X+7),(i+\box\Y+9), \Color\Frame[\Focus*2]&$FFFFFF|Alpha) 
          LineXY((\box\X+10+i),(\box\Y+3),(\box\X+6+i),(\box\Y+10), \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
        Next
      ElseIf \box\Checked = #PB_Checkbox_Inbetween
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \box\x+2,\box\y+2,\box\width-4,\box\height-4, \Radius-2, \Radius-2, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Option(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1, box_color=$7E7E7E
    
    With *This
      Protected Alpha = \color\alpha<<24
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\Box\width)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\width, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(\box\x+\box\width/2,\box\y+\box\width/2,\box\width/2, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked > 0
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Circle(\box\x+\box\width/2,\box\y+\box\width/2,2, \Color\Frame[\Focus*2]&$FFFFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Splitter(*This.Widget_S, scroll_x,scroll_y)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      If *This > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        ; Позиция сплиттера 
        Size = \Thumb\len
        
        If \Vertical
          Pos = \Thumb\Pos-y
        Else
          Pos = \Thumb\Pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \Area\len)
          fColor = \Color\Frame&$FFFFFF|Alpha;\Color[3]\Frame[0]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Width,Pos,fColor) 
            EndIf
            If \Type[2]<>#PB_GadgetType_Splitter
              Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),fColor)
            EndIf
          Else
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Pos,Height,fColor) 
            EndIf 
            If \Type[2]<>#PB_GadgetType_Splitter
              Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = $FF000000;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          Else
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            ;Box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,\Color\Frame&$FFFFFF|Alpha)
          Else
            ;Box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\Color\Frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \Vertical
        ; ;           ;Box(\Box\x[3], \Box\y[3]+\Box\Height[3]-\Thumb\len, \Box\Width[3], \Thumb\len, $FF0000)
        ; ;           Box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;Box(\Box\x[3]+\Box\Width[3]-\Thumb\len, \Box\y[3], \Thumb\len, \Box\Height[3], $FF0000)
        ; ;           Box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Track(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\X[0],*This\Y[0],*This\Width[0],*This\Height[0],\Color[0]\Back)
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0]+5,\Y[0],a,\Height[0],\Color[3]\Frame)
        Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,(\y+\height)-\Thumb\Pos,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0],\Y[0]+5,\Width[0],a,\Color[3]\Frame)
        Box(\X[0],\Y[0]+5,\Thumb\Pos-\x,a,\Color[3]\Back[2])
      EndIf
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\Box\x[3],\Box\y[3],\Box\Width[3]/2,\Box\Height[3],\Color[3]\Back[\Color[3]\State])
        
        Line(\Box\x[3],\Box\y[3],1,\Box\Height[3],\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3],\Box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3]+\Box\Height[3]-1,\Box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]/2,\Box\y[3],\Box\Width[3]/2,\Box\Height[3]/2+1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]/2,\Box\y[3]+\Box\Height[3]-1,\Box\Width[3]/2,-\Box\Height[3]/2-1,\Color[3]\Frame[\Color[3]\State])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\Box\x[3],\Box\y[3],\Box\Width[3],\Box\Height[3]/2,\Color[3]\Back[\Color[3]\State])
        
        Line(\Box\x[3],\Box\y[3],\Box\Width[3],1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3],1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]-1,\Box\y[3],1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3]+\Box\Height[3]/2,\Box\Width[3]/2+1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]-1,\Box\y[3]+\Box\Height[3]/2,-\Box\Width[3]/2-1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
      EndIf
      
      If \Ticks
        Protected PlotStep = 5;(\width)/(\Max-\Min)
        
        For i=3 To (\Width-PlotStep)/2 
          If Not ((\X+i-3)%PlotStep)
            Box(\X+i, \Y[3]+\Box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
        For i=\Width To (\Width-PlotStep)/2+3 Step - 1
          If Not ((\X+i-6)%PlotStep)
            Box(\X+i, \Box\y[3]+\Box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Image(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      
      ClipOutput(\x[2],\y[2],\s\h\Page\len,\s\v\Page\len)
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame)
      EndIf
    EndWith
    
    With *This\s
      ; Scroll area coordinate
      Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
    EndWith
  EndProcedure
  
  Procedure.i Draw_Button(*This.Widget_S, scroll_x,scroll_y)
    With *This
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_ComboBox(*This.Widget_S, scroll_x,scroll_y)
    With *This
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      If \Box\Checked
        State = 2
      EndIf
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        ClipOutput(\clip\x,\clip\y,\clip\width-\Box\width-\Text\x[2],\clip\height)
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
        ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      EndIf
      
      \Box\x = \x+\width-\Box\width -\Box\ArrowSize/2
      \Box\Height = \height[2]
      \Box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\Box\x+(\Box\Width-\Box\ArrowSize)/2, \Box\y+(\Box\Height-\Box\ArrowSize)/2, \Box\ArrowSize, Bool(\Box\Checked)+2, \Color\Front[State]&$FFFFFF|Alpha, \Box\ArrowType)
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_HyperLink(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        If \Flag\Lines
          Line(\Text\x, \Text\y+\Text\height-2, \Text\width, 1, \Color\Front[\Color\State]&$FFFFFF|Alpha)
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[\Color\State]&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front[\Color\State]&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw(*This.Widget_S, Childrens=0)
    Protected x,y
    
    If *This > 0 And *This\Type 
      With *This
        CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
          DrawingFont(GetGadgetFont(-1))
        CompilerEndIf
        
        ; Get text size
        If \Text\Change
          \Text\width = TextWidth(\Text\String.s[1])
          \Text\height = TextHeight("A")
        EndIf
        
        If \Text\Change Or \Resize Or \Change
          ; Make multi line text
          If \Text\MultiLine > 0
            \Text\String.s = Wrap(*This, \Text\String.s[1], \Width-\bs*2, \Text\MultiLine)
            \CountItems = CountString(\Text\String.s, #LF$)
          Else
            \Text\String.s = \Text\String.s[1]
          EndIf
          
          ; Text default position
          If \Text\String
            \Text\x[1] = \Text\x[2] + (Bool((\Text\Align\Right Or \Text\Align\Horizontal)) * (\width[2]-\Text\width)) / (\Text\Align\Horizontal+1)
            \Text\y[1] = \Text\y[2] + (Bool((\Text\Align\Bottom Or \Text\Align\Vertical)) * (\height[2]-\Text\height)) / (\Text\Align\Vertical+1)
            
            If \Type = #PB_GadgetType_Frame
              \Text\x = \Text\x[1]+\x[2]+8
              \Text\y = \Text\y[1]+\y
            Else
              \Text\x = \Text\x[1]+\x[2]
              \Text\y = \Text\y[1]+\y[2]
            EndIf
          EndIf
          
          ; Image default position
          If \image\imageID
            If (\Type = #PB_GadgetType_Image)
              \image\x[1] = \image\x[2] + (Bool(\s\h\Page\len>\image\width And (\image\Align\Right Or \image\Align\Horizontal)) * (\s\h\Page\len-\image\width)) / (\image\Align\Horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\s\v\Page\len>\image\height And (\image\Align\Bottom Or \image\Align\Vertical)) * (\s\v\Page\len-\image\height)) / (\image\Align\Vertical+1)
              \image\y = \s\y+\image\y[1]+\y[2]
              \image\x = \s\x+\image\x[1]+\x[2]
            Else
              \image\x[1] = \image\x[2] + (Bool(\image\Align\Right Or \image\Align\Horizontal) * (\width-\image\width)) / (\image\Align\Horizontal+1)
              \image\y[1] = \image\y[2] + (Bool(\image\Align\Bottom Or \image\Align\Vertical) * (\height-\image\height)) / (\image\Align\Vertical+1)
              \image\y = \image\y[1]+\y[2]
              \image\x = \image\x[1]+\x[2]
            EndIf
          EndIf
        EndIf
        
        ; 
        If \height>0 And \width>0 And Not \hide And \color\alpha 
          ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
          
          
          Select \Type
            Case -1 : Draw_Window(*This, x,y)
            Case #PB_GadgetType_HyperLink : Draw_HyperLink(*This, x,y)
            Case #PB_GadgetType_Property : Draw_Property(*This, x,y)
            Case #PB_GadgetType_String : Draw_String(*This, x,y)
            Case #PB_GadgetType_ListView : Draw_Tree(*This, x,y)
            Case #PB_GadgetType_Tree : Draw_Tree(*This, x,y)
            Case #PB_GadgetType_Text : Draw_Text(*This, x,y)
            Case #PB_GadgetType_ComboBox : Draw_ComboBox(*This, x,y)
            Case #PB_GadgetType_CheckBox : Draw_CheckBox(*This, x,y)
            Case #PB_GadgetType_Option : Draw_Option(*This, x,y)
            Case #PB_GadgetType_Panel : Draw_Panel(*This, x,y)
            Case #PB_GadgetType_Frame : Draw_Frame(*This, x,y)
            Case #PB_GadgetType_Image : Draw_Image(*This, x,y)
            Case #PB_GadgetType_Button : Draw_Button(*This, x,y)
            Case #PB_GadgetType_TrackBar : Draw_Track(*This, x,y)
            Case #PB_GadgetType_Spin : Draw_Spin(*This, x,y)
            Case #PB_GadgetType_ScrollBar : Draw_Scroll(*This, x,y)
            Case #PB_GadgetType_Splitter : Draw_Splitter(*This, x,y)
            Case #PB_GadgetType_Container : Draw_Container(*This, x,y)
            Case #PB_GadgetType_ProgressBar : Draw_Progress(*This, x,y)
            Case #PB_GadgetType_ScrollArea : Draw_ScrollArea(*This, x,y)
          EndSelect
          
          
          If \Container
            ; Draw image
            If \image\imageID
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
            EndIf
          EndIf
          
          ; Draw Childrens
          If Childrens And ListSize(\Childrens())
            ForEach \Childrens() 
              ; Only selected item widgets draw
              If \Childrens()\p_i = Bool(\Type = #PB_GadgetType_Panel) * \index[2]
                Draw(\Childrens(), Childrens) 
              EndIf
            Next
          EndIf
          
          
          If \s 
            ; ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
            If \s\v And \s\v\Type And Not \s\v\Hide : Draw_Scroll(\s\v, x,y) : EndIf
            If \s\h And \s\h\Type And Not \s\h\Hide : Draw_Scroll(\s\h, x,y) : EndIf
          EndIf
          
          ; Demo clip
          If \clip\width>0 And \clip\height>0
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\clip\x,\clip\y,\clip\width,\clip\height, $0000FF)
          EndIf
          
          ; Demo coordinate
          If \width>0 And \height>0
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\x,\y,\width,\height, $00FF00)
          EndIf
          
          UnclipOutput()
          Draw_Anchors(*This)
        EndIf
        
        ; reset 
        \Change = 0
        \Resize = 0
        \Text\Change = 0
        \image\change = 0
        
        *Value\Type =- 1 
        ;*Value\This = 0
      EndWith 
    EndIf
  EndProcedure
  
  ;-
  Procedure Draw_Popup(*This.Widget_S)
    With *This
      
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        ;  Debug ""+Widgets("Widgets_0") +" "+\Childrens()
        ;       DrawingMode(#PB_2DDrawing_Default)
        ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        ForEach \Childrens()
          ;           If ListSize(\Childrens()\Items())
          ;             Debug \Childrens()\Items()\Text\String
          ;           EndIf
          Draw(\Childrens())
        Next
        
        StopDrawing()
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure CallBack_Popup()
    Protected Repaint, *This.Widget_S
    
    Select Event()
      Case #PB_Event_ActivateWindow
        *This.Widget_S = GetWindowData(EventWindow())
        
        PostEvent(#PB_Event_Gadget, EventWindow(), *This\Canvas\Gadget, #PB_EventType_LeftButtonDown)
        SetActiveWindow(*This\Canvas\Widget\Canvas\Window)
        ;SetActiveGadget(*This\Canvas\Widget\Canvas\Gadget)
        SetText(*This\Canvas\Widget, GetItemText(*This\Childrens(), *This\Childrens()\index[1]))
        ;*This\Canvas\Widget\Canvas\Mouse\Buttons = 0
        *This\Canvas\Widget\Color\State = 0
        *This\Canvas\Widget\Box\Checked = 0
        HideWindow(EventWindow(), 1)
        *This = 0
        
      Case #PB_Event_Repaint
        *This.Widget_S = GetWindowData(EventWindow())
      Case #PB_Event_Gadget
        *This.Widget_S = GetGadgetData(EventGadget())
    EndSelect
    
    If *This
      With *This
        If ListSize(\Childrens())
          ForEach \Childrens()
            Repaint | CallBack(\Childrens(), EventType())
          Next
        EndIf
        
        If Repaint
          Draw_Popup(*This)
          If EventType() = #PB_EventType_LeftButtonDown
            *This\Canvas\Mouse\Buttons = 0
            *This\Childrens()\Canvas\Mouse\Buttons = 0
            
            ;PostEvent(#PB_Event_Widget, *This\Canvas\Widget\Canvas\Window, *This\Canvas\Widget\Canvas\Gadget, #PB_EventType_Change)
            ; HideWindow(EventWindow(), 1)
          EndIf
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Popup(*Widget.Widget_S, X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      If *This
        \Type = #PB_GadgetType_Popup
        If X=#PB_Ignore 
          X = *Widget\x+GadgetX(*Widget\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        
        If IsWindow(*Widget\Canvas\Window)
          Protected WindowID = WindowID(*Widget\Canvas\Window)
        EndIf
        
        ; Debug "show tooltip "+\string
        ;         If Not Window
        \Canvas\Widget = *Widget
        \Canvas\Window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \Canvas\Gadget = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(*This, 0,0, width, Height)
        
        SetWindowData(\Canvas\Window, *This)
        SetGadgetData(\Canvas\Gadget, *This)
        
        ;BindEvent(#PB_Event_SizeWindow, @CallBack_Popup(), \Canvas\Window, \Canvas\Gadget )
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \Canvas\Window);, \Canvas\Gadget )
                                                                              ;BindEvent(#PB_Event_Repaint, @CallBack_Popup(), \Canvas\Window, \Canvas\Gadget )
        BindGadgetEvent(\Canvas\Gadget, @CallBack_Popup())
        ;Draw_Popup(*This)
        ;         ;         Else
        ;         ;           ResizeWindow(Window, \x[1],\y[1],\width,\height[1])
        ;         ;           SetGadgetText(GetWindowData(Window), \string)
        ;         ;           HideWindow(Window, 0, #PB_Window_NoActivate)
        ;         ;         EndIf
        ;       ElseIf IsWindow(Window)
        ;         ;         HideWindow(Window, 1, #PB_Window_NoActivate)
        ;         CloseWindow(Window)
        ;         ;  Debug "hide tooltip "
      EndIf
    EndWith  
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Display_Popup(*This.Widget_S, *Widget.Widget_S, x.i=#PB_Ignore,y.i=#PB_Ignore)
    With *This
      If X=#PB_Ignore 
        X = \x+GadgetX(\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(*Widget\Canvas\Gadget))
        
        ForEach *Widget\Childrens()\Items()
          If *Widget\Childrens()\items()\text\change = 1
            *Widget\Childrens()\items()\text\height = TextHeight("A")
            *Widget\Childrens()\items()\text\width = TextWidth(*Widget\Childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\Childrens()\s\Width < (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\s\h\Page\Pos
            *Widget\Childrens()\s\Width = (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\s\h\Page\Pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      Protected *Tree.Widget_S = *Widget\Childrens()
      *Tree\Focus=1
      Protected Width = *Tree\s\width + *Tree\bs*2 
      Protected Height = *Tree\s\height + *Tree\bs*2 ; CountItems * *Tree\Text\height + *Tree\bs*2
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, 0,0, width, Height )
      ResizeWindow(*Widget\Canvas\Window, x, y, width, Height)
      ResizeGadget(*Widget\Canvas\Gadget, #PB_Ignore, #PB_Ignore, width, Height)
      ;Resize(*Widget, 0,0, width, Height )
    EndWith
    
    Draw_Popup(*Widget)
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure.i X(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Color\Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Color\Alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Width And \Color\Alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Height And \Color\Alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Enumerate(*This.Integer, *Parent.Widget_S, Item.i=0)
    Protected Result.i
    
    With *Parent
      If Not *This
        ProcedureReturn 0
      EndIf
      
      If Not \Enumerate
        Result = FirstElement(\Childrens())
      Else
        Result = NextElement(\Childrens())
      EndIf
      
      \Enumerate = Result
      
      If Result
        If \Childrens()\p_i <> Item
          ProcedureReturn Enumerate(*This, *Parent, Item)
        EndIf
        
        PokeI(*This, PeekI(@\Childrens()))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Hides(*This.Widget_S, State.i)
    With *This
      If State
        \Hide = 1
      Else
        \Hide = \Hide[1]
        If \s
          \s\v\Hide = \s\v\Hide[1]
          \s\h\Hide = \s\h\Hide[1]
        EndIf
      EndIf
      
      If ListSize(\Childrens())
        ForEach \Childrens()
          Hides(\Childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Hide(*This.Widget_S, State.i)
    With *This
      \Hide = State
      \Hide[1] = \Hide
      
      If ListSize(\Childrens())
        ForEach \Childrens()
          Hides(\Childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i GetParent(*This.Widget_S)
    ProcedureReturn *This\p
  EndProcedure
  
  Procedure.i GetParentItem(*This.Widget_S)
    ProcedureReturn *This\p_i
  EndProcedure
  
  Procedure.i SetParent(*This.Widget_S, *Parent.Widget_S, Item.i=0)
    Protected x,y
    
    With *This
      If *This > 0
        x = \x[3]
        y = \y[3]
        ;Debug ""+\y+" "+\y[3]
        
        If \p And ListSize(\p\Childrens())
          ;           ForEach \p\Childrens()
          ;             If \p\Childrens() = *This
          ;               Debug ""+ \p\Childrens()\type +" "+ \p\Childrens()\text\string
          ;               DeleteElement(\p\Childrens())
          ;             EndIf
          ;           Next
          
          If ChangeCurrentElement(\p\Childrens(), *This\adress)
            DeleteElement(\p\Childrens())
          EndIf
        EndIf
        
        \p = *Parent
        \p_i = Item
        \Canvas = \p\Canvas
        
        \Hide = Bool(Item > 0 Or \p\Hide)
        
        LastElement(\p\Childrens())
        If AddElement(\p\Childrens())
          \p\Childrens() = *This 
          \p\Childrens()\adress = @\p\Childrens()
        EndIf
        
        If \p\s
          x-\p\s\h\Page\Pos
          y-\p\s\v\Page\Pos
        EndIf
        
        Resize(*This, x, y, #PB_Ignore, #PB_Ignore)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i OpenList(*This.Widget_S, Item.i=0)
    With *This
      If *This > 0
        LastElement(*openedlist())
        If AddElement(*openedlist())
          *openedlist() = *This 
         *openedlist()\o_i = Item
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i CloseList()
    If LastElement(*openedlist())
      If *openedlist()\Type = #PB_GadgetType_Popup
        Draw_Popup(*openedlist())
      EndIf
      
      DeleteElement(*openedlist())
    EndIf
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *This
      
      Select \Type
        Case #PB_GadgetType_Panel
          LastElement(\items())
          AddElement(\items())
          
          ; last opened item of the parent
          \o_i = ListIndex(\Items())
          
          \items() = AllocateStructure(Items_S)
          \items()\index = ListIndex(\items())
          \items()\Text\String = Text.s
          \items()\Text\Change = 1
          \items()\height = \TabHeight
          \CountItems + 1 
          
          SetImage(\items(), Image)
          
        Case #PB_GadgetType_Property
          ProcedureReturn Property_AddItem(*This, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
          ProcedureReturn Tree_AddItem(*This, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ComboBox
          Protected *Tree.Widget_S = \Popup\Childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(Items_S)
          *Tree\items()\Box = AllocateStructure(Box_S)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\Text\String = Text.s
          *Tree\items()\Text\Change = 1
          *Tree\items()\height = \Text\height
          *Tree\CountItems + 1 
          
          *Tree\items()\y = *Tree\s\height
          *Tree\s\height + *Tree\items()\height
          
          SetImage(*Tree\items(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s[1] <> Text.s
        \Text\String.s[1] = Make(*This, Text.s)
        
        If \Text\String.s[1]
          If \Text\MultiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \Text\MultiLine > 0
              Text.s + #LF$
            EndIf
            
            \Text\String.s[1] = Text.s
            \CountItems = CountString(\Text\String.s[1], #LF$)
          Else
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$) ; + #LF$
                                                                      ; \Text\String.s = RTrim(ReplaceString(\Text\String.s[1], #LF$, " ")) + #LF$
          EndIf
          
          \Text\String.s = \Text\String.s[1]
          \Text\Len = Len(\Text\String.s[1])
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetState(*This.Widget_S)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Option,
             #PB_GadgetType_CheckBox 
          Result = \Box\Checked
          
        Case #PB_GadgetType_Tree : Result = \index[2]
        Case #PB_GadgetType_ListView : Result = \index[2]
        Case #PB_GadgetType_Panel : Result = \index[2]
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = Invert(*This, \Page\Pos, \inverted)
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This > 0
        Select \Type
          Case #PB_GadgetType_CheckBox
            Select State
              Case #PB_Checkbox_Unchecked,
                   #PB_Checkbox_Checked
                \Box\Checked = State
                ProcedureReturn 1
                
              Case #PB_Checkbox_Inbetween
                If \Box\ThreeState 
                  \Box\Checked = State
                  ProcedureReturn 1
                EndIf
            EndSelect
            
          Case #PB_GadgetType_Option
            If \OptionGroup And \Box\Checked <> State
              If \OptionGroup\OptionGroup <> *This
                If \OptionGroup\OptionGroup
                  \OptionGroup\OptionGroup\Box\Checked = 0
                EndIf
                \OptionGroup\OptionGroup = *This
              EndIf
              \Box\Checked = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_ComboBox
            Protected *t.Widget_S = \Popup\Childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\CountItems - 1 : State = *t\CountItems - 1 :  EndIf
            
            If *t\index[2] <> State
              If *t\index[2] >= 0 And SelectElement(*t\items(), *t\index[2]) 
                *t\items()\State = 0
              EndIf
              
              If SelectElement(*t\items(), State)
                *Value\Type = #PB_EventType_Change
                *Value\This = *This
                *t\items()\State = 2
                *t\Change = State+1
                
                \Text\String[1] = *t\Items()\Text\String
;                 \Text[1]\String = \Text\String[1]
;                 \Text\Caret = 1
;                 \Text\Caret[1] = \Text\Caret
                \Text\Change = 1
                
                ;Debug #PB_GadgetType_ComboBox;\Type
                PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_Change)
                PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
              EndIf
              
              *t\index[2] = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State
              If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
                \items()\State = 0
              EndIf
              
              If SelectElement(\items(), State)
                *Value\Type = #PB_EventType_Change
                *Value\This = *This
                \items()\State = 2
                \Change = State+1
                
                PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_Change)
                PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
              EndIf
              
              \index[2] = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            Result = SetImage(*This, State)
            
            If Result
              If \s
                SetAttribute(\s\v, #PB_Bar_Maximum, \image\height)
                SetAttribute(\s\h, #PB_Bar_Maximum, \image\width)
                
                \Resize = 1<<1|1<<2|1<<3|1<<4 
                Resize(*This, \x, \y, \width, \height) 
                \Resize = 0
              EndIf
            EndIf
            
          Case #PB_GadgetType_Panel
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State : \index[2] = State
              Debug State
              ForEach \Childrens()
                Hides(\Childrens(), Bool(\Childrens()\p_i<>State))
              Next
              
              \Change = State+1
              Result = 1
            EndIf
            
          Default
            If (\Vertical And \Type = #PB_GadgetType_TrackBar)
              State = Invert(*This, State, \inverted)
            EndIf
            
            If State < \Min
              State = \Min 
            EndIf
            
            If State > \Max-\Page\len
              If \Max > \Page\len 
                State = \Max-\Page\len
              Else
                State = \Min 
              EndIf
            EndIf
            
            If \Page\Pos <> State 
              \Thumb\Pos = ThumbPos(*This, State)
              
              If \inverted
                If \Page\Pos > State
                  \Direction = Invert(*This, State, \inverted)
                Else
                  \Direction =- Invert(*This, State, \inverted)
                EndIf
              Else
                If \Page\Pos > State
                  \Direction =- State
                Else
                  \Direction = State
                EndIf
              EndIf
              
              *Value\This = *This
              *Value\Type = #PB_EventType_Change
              \Change = \Page\Pos - State
              \Page\Pos = State
              
              If \Type = #PB_GadgetType_Spin
                \Text\String.s[1] = Str(\Page\Pos)
                \Text\Change = 1
              ElseIf \Type = #PB_GadgetType_Splitter
                Resize_Splitter(*This)
              Else
                If \p
                  \p\Change =- 1
                  
                  If \p\s
                    If \Vertical
                      \p\s\y =- \Page\Pos
                      Resize_Childrens(\p, 0, \Change)
                    Else
                      \p\s\x =- \Page\Pos
                      Resize_Childrens(\p, \Change, 0)
                    EndIf
                  EndIf
                EndIf
              EndIf
              
              Result = #True
            EndIf
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : Result = \Box\Size[1]
            Case #PB_Splitter_SecondMinimumSize : Result = \Box\Size[2] - \Box\Size[3]
          EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \Min  ; 1
            Case #PB_Bar_Maximum : Result = \Max  ; 2
            Case #PB_Bar_Inverted : Result = \inverted
            Case #PB_Bar_NoButtons : Result = \Box\Size ; 4
            Case #PB_Bar_Direction : Result = \Direction
            Case #PB_Bar_PageLength : Result = \Page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    Protected Resize.i
    
    With *This
      If *This > 0
        Select \Type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                SetImage(*This, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \Box\Size[1] = Value
              Case #PB_Splitter_SecondMinimumSize : \Box\Size[2] = \Box\Size[3] + Value
            EndSelect 
            
            If \Vertical
              \Area\Pos = \Y+\Box\Size[1]
              \Area\len = (\Height-\Box\Size[1]-\Box\Size[2])
            Else
              \Area\Pos = \X+\Box\Size[1]
              \Area\len = (\Width-\Box\Size[1]-\Box\Size[2])
            EndIf
            
            ProcedureReturn 1
            
          Case #PB_GadgetType_Image
            Select Attribute
              Case #PB_DisplayMode
                
                Select Value
                  Case 0 ; Default
                    \image\Align\Vertical = 0
                    \image\Align\Horizontal = 0
                    
                  Case 1 ; Center
                    \image\Align\Vertical = 1
                    \image\Align\Horizontal = 1
                    
                  Case 3 ; Mosaic
                  Case 2 ; Stretch
                    
                  Case 5 ; Proportionally
                EndSelect
                
                ;Resize = 1
                \Resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*This, \x, \y, \width, \height)
                \Resize = 0
            EndSelect
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \Box\Size[0] = Value
                \Box\Size[1] = Value
                \Box\Size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \Page\Pos = Invert(*This, \Page\Pos)
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                ProcedureReturn 1
                
              Case #PB_Bar_Minimum ; 1 -m&l
                If \Min <> Value 
                  \Min = Value
                  \Page\Pos + Value
                  
                  If \Page\Pos > \Max-\Page\len
                    If \Max > \Page\len 
                      \Page\Pos = \Max-\Page\len
                    Else
                      \Page\Pos = \Min 
                    EndIf
                  EndIf
                  
                  If \Max > \Min
                    \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\Pos = \Area\Pos
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \Box\y[3] = \Thumb\Pos  
                      \Box\Height[3] = \Thumb\len
                    Else 
                      \Box\x[3] = \Thumb\Pos 
                      \Box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_Maximum ; 2 -m&l
                If \Max <> Value
                  \Max = Value
                  
                  If \Page\len > \Max 
                    \Page\Pos = \Min
                  EndIf
                  
                  \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                  
                  If \Max > \Min
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \Box\Height[3] = \Thumb\len
                    Else 
                      \Box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  If \Step = 0
                    \Step = 1
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_PageLength ; 3 -m&l
                If \Page\len <> Value
                  If Value > (\Max-\Min)
                    If \Max = 0 
                      \Max = Value 
                    EndIf
                    Value = (\Max-\Min)
                    \Page\Pos = \Min
                  EndIf
                  \Page\len = Value
                  
                  \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                  
                  If \Page\len > \Min
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\len = \Box\Size[3]
                  EndIf
                  
                  If \Step = 0
                    \Step = 1
                  EndIf
                  If \Step < 2 And \Page\len
                    \Step = (\Max-\Min) / \Page\len 
                  EndIf
                  
                  Resize = 1
                EndIf
                
            EndSelect
            
        EndSelect
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Tree
          ForEach \items()
            If \items()\index= Item 
              Select Attribute
                Case #PB_Tree_SubLevel
                  Result = \items()\sublevel
                  
              EndSelect
              Break
            EndIf
          Next
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemAttribute(*This.Widget_S, Item.i, Attribute.i, Value.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Panel
          If SelectElement(\items(), Item)
            Select Attribute 
              Case #PB_Button_Image
                Result = SetImage(\items(), Value)
            EndSelect
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemState(*This.Widget_S, Item.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result, sublevel
    
    With *This
      Select \Type
        Case #PB_GadgetType_ListView
          If (\Flag\MultiSelect Or \Flag\ClickSelect)
            Result = SelectElement(\items(), Item) 
            If Result 
              \items()\State = Bool(State)+1
            EndIf
          EndIf
          
        Case #PB_GadgetType_Tree
          
          If Item < 0 : Item = 0 : EndIf
          If Item > \CountItems : Item = \CountItems :  EndIf
          ;       
          ;       If \index[2] <> Item
          ;         If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
          ;           \items()\State = 0
          ;         EndIf
          ;         
          ;         If SelectElement(\items(), Item)
          ;           *Value\Type = #PB_EventType_Change
          ;           *Value\Widget = *This
          ;           \items()\State = 2
          ;           \Change = Item+1
          ;           
          ;           PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_Change)
          ;           PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
          ;         EndIf
          ;         
          ;         \index[2] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\Flag\MultiSelect Or \Flag\ClickSelect)
          PushListPosition(\Items())
          Result = SelectElement(\Items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \Items()\Index[1] = \Items()\Index
              \Items()\State = Bool(State)+1
            EndIf
            
            \Items()\Box\Checked = Bool(State&#PB_Tree_Collapsed)
            
            If \Items()\Box\Checked Or State&#PB_Tree_Expanded
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#PB_Tree_Collapsed
                    \Items()\hide = 1
                  ElseIf State&#PB_Tree_Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            
          EndIf
          PopListPosition(\Items())
          ; EndIf
          
          ;          If \index[1] >= 0 And SelectElement(\items(), \index[1]) 
          ;                 Protected sublevel.i
          ;                 
          ;                 If (MouseScreenY > (\items()\box\y[1]) And MouseScreenY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
          ;                    ((MouseScreenX > \items()\box\x[1]) And (MouseScreenX =< (\items()\box\x[1]+\items()\box\width[1])))
          ;                   
          ;                   \items()\Box\Checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (MouseScreenY > (\items()\box\y[0]) And MouseScreenY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
          ;                        ((MouseScreenX > \items()\box\x[0]) And (MouseScreenX =< (\items()\box\x[0]+\items()\box\width[0])))
          ;                   
          ;                   sublevel = \items()\sublevel
          ;                   \items()\Box\Checked ! 1
          ;                   \Change = 1
          ;                   
          ;                   PushListPosition(\items())
          ;                   While NextElement(\items())
          ;                     If sublevel = \items()\sublevel
          ;                       Break
          ;                     ElseIf sublevel < \items()\sublevel And \items()\a
          ;                       \items()\hide = Bool(\items()\a\Box\Checked Or \items()\a\hide) * 1
          ;                     EndIf
          ;                   Wend
          ;                   PopListPosition(\items())
          ;                   
          ;                 ElseIf \index[2] <> \index[1] : \items()\State = 2
          ;                   If \index[2] >= 0 And SelectElement(\items(), \index[2])
          ;                     \items()\State = 0
          ;                   EndIf
          ;                   \index[2] = \index[1]
          ;                 EndIf
          ;                 
          ;                 Repaint = 1
          ;               EndIf
      EndSelect     
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemData(*This.Widget_S, Item.i)
    Protected Result.i
    
    With *This
      PushListPosition(\items()) 
      ForEach \items()
        If \items()\index = Item 
          Result = \items()\data
          ; Debug \items()\Text\String
          Break
        EndIf
      Next
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemData(*This.Widget_S, Item.i, *Data)
    Protected Result.i
    ;   Debug "SetItemData "+Item +" "+ *Data
    ;     
    With *This
      PushListPosition(\items()) 
      ForEach \items()
        If \items()\index = Item  ;  ListIndex(\items()) = Item ;  
          \items()\data = *Data
          Break
        EndIf
      Next
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*This.Widget_S, Item.i)
    Protected Result.s
    
    With *This
      ForEach \items()
        If \items()\index = Item 
          Result = \items()\Text\String.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemText(*This.Widget_S, Item.i, Text.s)
    Protected Result.i
    
    With *This
      ForEach \items()
        If \items()\index = Item 
          
          If \Type = #PB_GadgetType_Property
            \items()\text[1]\string.s = Text
          Else
            \items()\text\string.s = Text
          EndIf
          
          ;\items()\Text\String.s = Text.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetData(*This.Widget_S)
    ProcedureReturn *This\data
  EndProcedure
  
  Procedure.i SetData(*This.Widget_S, *Data)
    Protected Result.i
    
    With *This
      \data = *Data
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetImage(*This.Widget_S)
    ProcedureReturn *This\image\index
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i GetType(*This.Widget_S)
    ProcedureReturn *This\Type
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn *This\CountItems
  EndProcedure
  
  Procedure.i ClearItems(*This.Widget_S) 
    With *This
      \CountItems = 0
      \Text\Change = 1 
      If \Text\Editable
        \Text\String = #LF$
      EndIf
      
      ClearList(\Items())
      \s\v\Hide = 1
      \s\h\Hide = 1
      
      ;       If Not \Repaint : \Repaint = 1
      ;        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
      ;       EndIf
    EndWith
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i) 
    With *This
      \CountItems = ListSize(\Items()) ; - 1
      \Text\Change = 1
      
      If \CountItems =- 1 
        \CountItems = 0 
        \Text\String = #LF$
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug Item
        If SelectElement(\Items(), Item)
          DeleteElement(\Items())
        EndIf
        
        \Text\String = RemoveString(\Text\String, StringField(\Text\String, Item+1, #LF$) + #LF$)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *This
      If State =- 1
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i);, *That.Widget_S=#Null)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *This > 0
      If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And Width=#PB_Ignore And Height=#PB_Ignore)
        ; *Value\Widget = *This
        *Value\Type = #PB_EventType_Resize
      EndIf
      
      With *This
        ; Set scroll bar coordinate
        If X=#PB_Ignore : X = \X : Else : If \p : \x[3] = X : X+\p\x+\p\bs : EndIf
          If \X <> X : Change_x = x-\x : \X = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \Resize | 1<<1 : EndIf 
        EndIf  
        If Y=#PB_Ignore : Y = \Y : Else : If \p : \y[3] = Y : Y+\p\y+\p\bs+\p\TabHeight : EndIf
          If \Y <> Y : Change_y = y-\y : \Y = Y : \y[2] = \y+\bs+\TabHeight : \y[1] = \y[2]-\fs : \Resize | 1<<2 : EndIf 
        EndIf  
        If Width=#PB_Ignore : Width = \Width : Else : If \Width <> Width : Change_width = width-\width : \Width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
        If Height=#PB_Ignore : Height = \Height : Else : If \Height <> Height : Change_height = height-\height : \Height = Height : \height[2] = \height-\bs*2-\TabHeight : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        
        If \Box And \Resize ;And \Type = #PB_GadgetType_ScrollBar
          Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
          \hide[1] = Bool(\Page\len And Not ((\Max-\Min) > \Page\Len))
          
          If \Box\Size
            \Box\Size[1] = \Box\Size
            \Box\Size[2] = \Box\Size
          EndIf
          
          If \Max
            If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
              \Area\Pos = \Y[2]+\Box\Size[1]
              \Area\len = \Height[2]-(\Box\Size[1]+\Box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            Else
              \Area\Pos = \X[2]+\Box\Size[1]
              \Area\len = \width[2]-(\Box\Size[1]+\Box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            EndIf
          EndIf
          
          If (\Type <> #PB_GadgetType_Splitter) And Bool(\Resize & (1<<4 | 1<<3))
            \Thumb\len = ThumbLength(*This)
            
            If (\Area\len > \Box\Size)
              If \Box\Size
                If (\Thumb\len < \Box\Size)
                  \Area\len = Round(\Area\len - (\Box\Size[2]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \Box\Size[2] 
                EndIf
              Else
                If (\Thumb\len < \Box\Size[3]) And (\Type <> #PB_GadgetType_ProgressBar)
                  \Area\len = Round(\Area\len - (\Box\Size[3]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \Box\Size[3]
                EndIf
              EndIf
            Else
              \Thumb\len = \Area\len 
            EndIf
          EndIf
          
          If \Area\len > 0 And \Type <> #PB_GadgetType_Panel
            If IsStop(*This) And (\Type = #PB_GadgetType_ScrollBar)
              SetState(*This, \Max)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
          
          If \Type = #PB_GadgetType_Spin
            If \Vertical
              \Box\y[1] = \y[2]+\Height[2]/2+Bool(\Height[2]%2) : \Box\Height[1] = \Height[2]/2 : \Box\Width[1] = \Box\Size[2] : \Box\x[1] = \x[2]+\width[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
              \Box\y[2] = \y[2] : \Box\Height[2] = \Height[2]/2 : \Box\Width[2] = \Box\Size[2] : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2]                                 ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
            Else
              \Box\y[1] = \y[2] : \Box\Height[1] = \Height[2] : \Box\Width[1] = \Box\Size[2]/2 : \Box\x[1] = \x[2]+\width[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
              \Box\y[2] = \y[2] : \Box\Height[2] = \Height[2] : \Box\Width[2] = \Box\Size[2]/2 : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2]/2 ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
            EndIf
            
            \Box\y[3] = \y[2] + Lines : \Box\Height[3] = Height - Lines : \Box\x[3] = \Thumb\Pos : \Box\Width[3] = \Thumb\len                  ; Thumb coordinate on scroll bar
            
          ElseIf \Type = #PB_GadgetType_Panel
            \Page\len = \Width[2]-2
            
            If IsStop(*This)
              If \Max < \Min
                \Max = \Min 
              EndIf
              
              If \Max > \Max-\Page\len
                If \Max > \Page\len
                  \Max = \Max-\Page\len
                Else
                  \Max = \Min 
                EndIf
              EndIf
              
              \Page\Pos = \Max
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
            EndIf
            
            \Box\x[1] = \x[2]+1
            \Box\y[1] = \y[2]-\TabHeight+\bs+2
            \Box\x[2] = \x[2]+\width[2]-\Box\width[2]-1
            \Box\y[2] = \Box\y[1]
            
            \Box\width[1] = \Box\Size
            \Box\width[2] = \Box\Size
            
            \Box\height[1] = \TabHeight-1-4
            \Box\height[2] = \Box\height[1]
          Else
            If \Vertical
              If \Box\Size
                \Box\x[1] = \x[2] + Lines : \Box\y[1] = \y[2] : \Box\Width[1] = Width - Lines : \Box\Height[1] = \Box\Size[1]                       ; Top button coordinate on scroll bar
                \Box\x[2] = \x[2] + Lines : \Box\Width[2] = Width - Lines : \Box\Height[2] = \Box\Size[2] : \Box\y[2] = \y[2]+\height[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)   ; Bottom button coordinate on scroll bar
              EndIf
              \Box\x[3] = \x[2] + Lines : \Box\Width[3] = Width - Lines : \Box\y[3] = \Thumb\Pos : \Box\Height[3] = \Thumb\len                   ; Thumb coordinate on scroll bar
            ElseIf \Box 
              If \Box\Size
                \Box\x[1] = \x[2] : \Box\y[1] = \y[2] + Lines : \Box\Height[1] = Height - Lines : \Box\Width[1] = \Box\Size[1]                      ; Left button coordinate on scroll bar
                \Box\y[2] = \y[2] + Lines : \Box\Height[2] = Height - Lines : \Box\Width[2] = \Box\Size[2] : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
              EndIf
              \Box\y[3] = \y[2] + Lines : \Box\Height[3] = Height - Lines : \Box\x[3] = \Thumb\Pos : \Box\Width[3] = \Thumb\len                  ; Thumb coordinate on scroll bar
            EndIf
          EndIf
          
        EndIf 
        
        ; set clip coordinate
        If \p And \x < \p\clip\x+\p\bs : \clip\x = \p\clip\x+\p\bs : Else : \clip\x = \x : EndIf
        If \p And \y < \p\clip\y+\p\bs+\p\TabHeight : \clip\y = \p\clip\y+\p\bs+\p\TabHeight : Else : \clip\y = \y : EndIf
        
        If \p And \p\s And \p\s\v And \p\s\h
          Protected v=Bool(\p\width=\p\clip\width And Not \p\s\v\Hide And \p\s\v\type = #PB_GadgetType_ScrollBar)*(\p\s\v\width) ;: If Not v : v = \p\bs : EndIf
          Protected h=Bool(\p\height=\p\clip\height And Not \p\s\h\Hide And \p\s\h\type = #PB_GadgetType_ScrollBar)*(\p\s\h\height) ;: If Not h : h = \p\bs : EndIf
        EndIf
        
        If \p And \x+\width>\p\clip\x+\p\clip\width-v-\p\bs : \clip\width = \p\clip\width-v-\p\bs-(\clip\x-\p\clip\x) : Else : \clip\width = \width-(\clip\x-\x) : EndIf
        If \p And \y+\height>=\p\clip\y+\p\clip\height-h-\p\bs : \clip\height = \p\clip\height-h-\p\bs-(\clip\y-\p\clip\y) : Else : \clip\height = \height-(\clip\y-\y) : EndIf
        
        ; Resize scrollbars
        If \s 
          Resizes(\s, 0,0, \Width[2],\Height[2])
        EndIf
        
        ; Resize childrens
        If ListSize(\Childrens())
          If \Type = #PB_GadgetType_Splitter
            Resize_Splitter(*This)
          Else
            ForEach \Childrens()
              If \Childrens()\Align
                If \Childrens()\Align\Horizontal
                  x = (\width[2] - (\Childrens()\Align\x+\Childrens()\width))/2
                ElseIf \Childrens()\Align\Right And Not \Childrens()\Align\Left
                  x = (\width[2] - (\Childrens()\Align\x+\Childrens()\width));+Bool(\Grid>1)
                Else
                  If \x[2]
                    x = (\Childrens()\x-\x[2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Vertical
                  y = (\height[2] - (\Childrens()\Align\y+\Childrens()\height))/2 
                ElseIf \Childrens()\Align\Bottom And Not \Childrens()\Align\Top
                  y = (\height[2] - (\Childrens()\Align\y+\Childrens()\height));+Bool(\Grid>1)
                Else
                  If \y[2]
                    y = (\Childrens()\y-\y[2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Top And \Childrens()\Align\Bottom
                  Height = \height[2]-\Childrens()\Align\y1;+Bool(\Grid>1)
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \Childrens()\Align\Left And \Childrens()\Align\Right
                  Width = \width[2]-\Childrens()\Align\x1;+Bool(\Grid>1)
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\Childrens(), x, y, Width, Height)
                ;Resize(\Childrens(), (\Childrens()\x-\x[2]) + Change_x, (\Childrens()\y-\y[2]) + Change_y, \width[2], \height[2])
              Else
                Resize(\Childrens(), (\Childrens()\x-\x[2]) + Change_x, (\Childrens()\y-\y[2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        ; anchors widgets
        Resize_Anchors(*This)
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v)-(\v\Width-\v\Radius/2)+1, iHeight = Y(\h)-(\h\Height-\h\Radius/2)+1
      Static hPos, vPos : vPos = \v\Page\Pos : hPos = \h\Page\Pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\Page\Pos+iWidth 
        ScrollArea_Width=\h\Page\Pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\Page\Pos And
             ScrollArea_Width=\h\Page\Pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\Page\Pos+iHeight
        ScrollArea_Height=\v\Page\Pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\Page\Pos And
             ScrollArea_Height=\v\Page\Pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\Page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\Page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;     \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;     \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\Y + Bool(\h\Hide) * \h\Height) - \v\Y) ; #PB_Ignore, \h) 
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\X + Bool(\v\Hide) * \v\Width) - \h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\Page\Pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\Page\Pos = vPos : \h\Width = iWidth+\v\Width : EndIf
      If \h\hide : \h\Page\Pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\Page\Pos = hPos : \v\Height = iHeight+\h\Height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    With *Scroll
      If y=#PB_Ignore : y = \v\Y : EndIf
      If x=#PB_Ignore : x = \h\X : EndIf
      If Width=#PB_Ignore : Width = \v\X-\h\X+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\Y-\v\Y+\h\height : EndIf
      
      ;       If \v\p
      ;         y - \v\p\bs
      ;       EndIf
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, Width+x-\v\Width, y, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, x, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len); + Bool(\v\Radius And Not \h\Hide And Not \v\Hide)*4)
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len, #PB_Ignore); + Bool(\h\Radius And Not \v\Hide And Not \h\hide)*4, #PB_Ignore)
      
      If Not \v\Hide 
        \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not \h\Hide 
        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      EndIf
      ProcedureReturn 1 ; Bool(Not Bool(\v\Hide And \h\Hide))
    EndWith
  EndProcedure
  
  
  ;-
  ;- EDITABLE
  Procedure.i Remove(*This.Widget_S)
    With *This
      If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Pos+\Text\Caret, 1)
      \Text\Len = Len(\Text\String.s[1])
    EndWith
  EndProcedure
  
  Procedure.i SelLimits(*This.Widget_S)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Text\String.s[1], \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If \s
        X = (\Text\X+\s\X)
      Else
        X = \Text\X
      EndIf
      
      Len = \Text\Len
      FontID = \Text\FontID
      String.s = \Text\String.s[1]
      
      If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
        If FontID : DrawingFont(FontID) : EndIf
        
        For i = 0 To Len
          CursorX = X + TextWidth(Left(String.s, i))
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
          
          ; Получаем позицию коpректора
          If MinDistance > Distance 
            MinDistance = Distance
            Position = i
          EndIf
        Next
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This
      If Caret <> *This\Text\Caret Or Line <> *This\index[1] Or (*This\Text\Caret[1] >= 0 And Caret1 <> *This\Text\Caret[1])
        \Text[2]\String.s = ""
        
        If *This\index[2] = *This\index[1]
          If *This\Text\Caret[1] > *This\Text\Caret 
            ; |<<<<<< to left
            Position = *This\Text\Caret
            \Text[2]\Len = (*This\Text\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Text\Caret[1]
            \Text[2]\Len = (*This\Text\Caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *This\Text\Caret > *This\Text\Caret[1]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *This\Text\Caret[1] > *This\Text\Caret 
              ; |<<<<<< to left
              Position = *This\Text\Caret
              \Text[2]\Len = (*This\Text\Caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *This\Text\Caret[1]
              \Text[2]\Len = (*This\Text\Caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *This\index[1] > *This\index[2]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \Text[1]\String.s = Left(*This\Text\String.s[1], \Text\Pos+Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s[1], 1+\Text\Pos+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Trim(Right(*This\Text\String.s[1], *This\Text\Len-(\Text\Pos+Position + \Text[2]\Len)), #LF$) : \Text[3]\Change = #True
        
        Line = *This\index[1]
        Caret = *This\Text\Caret
        Caret1 = *This\Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure ToLeft(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
      ElseIf \Text\Caret[1] > 0 
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text[2]\Len 
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
      ElseIf \Text\Caret[1] < \Text\Len
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1] 
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text\Caret[1] < \Text\Len
        If \Text[2]\Len 
          Remove(*This)
        Else
          \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 2)
          \Text\Len = Len(\Text\String.s[1]) 
        EndIf
        
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*This.Widget_S)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *This
      If \Canvas\input
        Chr.s = Make(*This, Chr(\Canvas\input))
        
        If Chr.s
          If \Text[2]\Len 
            Remove(*This)
          EndIf
          
          \Text\Caret + 1
          ; \items()\Text\String.s[1] = \items()\Text[1]\String.s + Chr(\Canvas\input) + \items()\Text[3]\String.s ; сним не выравнивается строка при вводе слов
          \Text\String.s[1] = InsertString(\Text\String.s[1], Chr.s, \Text\Pos+\Text\Caret)
          \Text\Len = Len(\Text\String.s[1]) 
          \Text\Caret[1] = \Text\Caret 
          \Text\Change =- 1
        Else
          ;\Default = *This
        EndIf
        
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
    Protected Repaint, String.s 
    
    If *This\Canvas\input : *This\Canvas\input = 0
      ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This
      \Canvas\input = 65535
      
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
        Remove(*This)
        
      ElseIf \Text\Caret[1] > 0 
        \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 1)
        \Text\Len = Len(\Text\String.s[1])  
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editable(*This.Widget_S, EventType.i, MouseScreenX.i, MouseScreenY.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *This
      *This\index[1] = 0
      
      With *This
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If #PB_Cursor_Default = GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, *This\Cursor)
            EndIf
            If *This\Text\Editable And *This\Drag[1] : *This\Drag[1] = 0
              If \Text\Caret[2] > 0 And Not Bool(\Text\Caret[2] < *This\Text\Caret + 1 And *This\Text\Caret + 1 < \Text\Caret[2] + \Text[2]\Len)
                
                *This\Text\String.s[1] = RemoveString(*This\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret[2], 1)
                
                If \Text\Caret[2] > *This\Text\Caret 
                  \Text\Caret[2] = *This\Text\Caret 
                  *This\Text\Caret[1] = *This\Text\Caret + \Text[2]\Len
                Else
                  \Text\Caret[2] = (*This\Text\Caret-\Text[2]\Len)
                  *This\Text\Caret[1] = \Text\Caret[2]
                EndIf
                
                *This\Text\String.s[1] = InsertString(*This\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                *This\Text\Len = Len(*This\Text\String.s[1])
                \Text\String.s[1] = InsertString(\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                \Text\Len = Len(\Text\String.s[1])
                
                *This\Text\Change =- 1
                \Text\Caret[2] = 0
                Repaint =- 1
              EndIf
            Else
              Repaint =- 1
              \Text\Caret[2] = 0
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            Caret = Caret(*This)
            
            If \Text\Caret[1] =- 1 : \Text\Caret[1] = 0
              *This\Text\Caret = 0
              *This\Text\Caret[1] = \Text\Len
              \Text[2]\Len = \Text\Len
              Repaint =- 1
            Else
              Repaint = 1
              
              If \Text[2]\Len
                If *This\Text\Caret[1] > *This\Text\Caret : *This\Text\Caret[1] = *This\Text\Caret : EndIf
                
                If *This\Text\Caret[1] < Caret And Caret < *This\Text\Caret[1] + \Text[2]\Len
                  SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  \Text\Caret[2] = *This\Text\Caret[1] + 1
                Else
                  Repaint =- 1
                EndIf
              Else
                Repaint =- 1
              EndIf
              
              *This\Text\Caret = Caret
              *This\Text\Caret[1] = *This\Text\Caret
            EndIf 
            
          Case #PB_EventType_LeftDoubleClick 
            \Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
            SelLimits(*This)    ; Выделяем слово
            Repaint =- 1
            
          Case #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
              Caret = Caret(*This)
              If *This\Text\Caret <> Caret
                
                If \Text\Caret[2] ; *This\Cursor <> GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
                  If \Text\Caret[2] < Caret + 1 And Caret + 1 < \Text\Caret[2] + \Text[2]\Len
                    SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  Else
                    \Text[1]\String.s = Left(*This\Text\String.s[1], \Text\Pos+*This\Text\Caret) : \Text[1]\Change = #True
                  EndIf
                  
                  *This\Text\Caret[1] = Caret
                  Repaint = 1
                Else
                  Repaint =- 1
                EndIf
                
                *This\Text\Caret = Caret
              EndIf
            EndIf
        EndSelect
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
        CompilerElse
          Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
        CompilerEndIf
        
        Select EventType
          Case #PB_EventType_Input
            If Not Control
              Repaint = ToInput(*This)
            EndIf
            
          Case #PB_EventType_KeyUp
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *This\Canvas\Key
              Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = 0 : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
              Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = \Text\Len : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                
              Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = ToLeft(*This) ; Ok
              Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = ToRight(*This) ; Ok
              Case #PB_Shortcut_Back : Repaint = ToBack(*This)
              Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                
              Case #PB_Shortcut_A
                If Control
                  *This\Text\Caret = 0
                  *This\Text\Caret[1] = \Text\Len
                  \Text[2]\Len = \Text\Len
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_X
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                  Remove(*This)
                  *This\Text\Caret[1] = *This\Text\Caret
                  \Text\Len = Len(\Text\String.s[1])
                  Repaint = #True 
                EndIf
                
              Case #PB_Shortcut_C
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                EndIf
                
              Case #PB_Shortcut_V
                If Control
                  Protected ClipboardText.s = GetClipboardText()
                  
                  If ClipboardText.s
                    If \Text[2]\String.s
                      Remove(*This)
                    EndIf
                    
                    Select #True
                      Case *This\Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                      Case *This\Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                      Case *This\Text\Numeric 
                        If Val(ClipboardText.s)
                          ClipboardText.s = Str(Val(ClipboardText.s))
                        EndIf
                    EndSelect
                    
                    \Text\String.s[1] = InsertString(\Text\String.s[1], ClipboardText.s, *This\Text\Caret + 1)
                    *This\Text\Caret + Len(ClipboardText.s)
                    *This\Text\Caret[1] = *This\Text\Caret
                    \Text\Len = Len(\Text\String.s[1])
                    Repaint = #True
                  EndIf
                EndIf
                
            EndSelect 
            
        EndSelect
        
        If Repaint =- 1
          SelectionText(*This)
        EndIf
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;- 
  Procedure.i Events(*This.Widget_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    If *This > 0
      
      *Value\This = *This
      *Value\Type = EventType
      
      With *This
        ; 
        If \anchor[1]
          If EventType = #PB_EventType_MouseEnter
            If (\Type = #PB_GadgetType_Splitter And at = 3)
              \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
            Else
              \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
            EndIf
          EndIf
          
          If EventType = #PB_EventType_LeftButtonDown 
            If *Value\Focus <> *This
              If *Value\Focus
                PostEvent(#PB_Event_Widget, *Value\Window, *Value\Focus, #PB_EventType_StatusChange, #PB_EventType_LostFocus)
              EndIf
              PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_StatusChange, #PB_EventType_Focus)
              PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
              
              *Value\Focus = *This
            EndIf
          EndIf
          ProcedureReturn - 1
        EndIf
        
        If EventType = #PB_EventType_MouseMove
          
          ; items at point
          ForEach \items()
            If \items()\Drawing
              If \at=-1 And (MouseScreenX>\items()\X And MouseScreenX=<\items()\X+\items()\Width And 
                  MouseScreenY>\items()\Y And MouseScreenY=<\items()\Y+\items()\Height)
                
                If \index[1] <> \items()\index
                  \index[1] = \items()\index
                  If Not \items()\State
                    \items()\State = 1
                  EndIf
                  
                  If \Change[1] <> \index[1]
                    
                    If \Type = #PB_GadgetType_Tree Or (Not \items()\Childrens And \Type = #PB_GadgetType_Property )
                      PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_StatusChange, \index[1])
                    EndIf
                    
                    \Change[1] = \index[1]
                  EndIf
                  
                  repaint=1
                EndIf
                
              ElseIf \items()\State = 1
                \items()\State = 0
                \index[1] =- 1
                repaint=1
              EndIf
            EndIf
          Next
        EndIf
        
        Select EventType
          Case #PB_EventType_Focus : \Focus = 1 : Repaint = 1
            Debug "events() Focus "+\Type
            
          Case #PB_EventType_LostFocus : \Focus = 0 : Repaint = 1
            Debug "events() LostFocus "+\Type
            
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0
            Debug "events() LeftButtonUp "+\Type
            
          Case #PB_EventType_LeftClick 
            Debug "events() LeftClick "+\Type
            If \Type = #PB_GadgetType_Button
              PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_LeftClick, \index[1])
              ;  PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
              Repaint = #True
            EndIf
            
          Case #PB_EventType_LeftDoubleClick 
            If \Type = #PB_GadgetType_ScrollBar
              Select at
                Case - 1
                  If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                    Repaint = (MouseScreenY-\Thumb\len/2)
                  Else
                    Repaint = (MouseScreenX-\Thumb\len/2)
                  EndIf
                  
                  Repaint = SetState(*This, Pos(*This, Repaint))
              EndSelect
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            Debug "events() LeftButtonDown "+\Type
            
            If \Type = #PB_GadgetType_ComboBox
              \Box\Checked ! 1
              
              If \Box\Checked
                Display_Popup(*This, \Popup)
                HideWindow(\Popup\Canvas\Window, 0, #PB_Window_NoActivate)
              Else
                HideWindow(\Popup\Canvas\Window, 1)
              EndIf
              
            ElseIf \Type = #PB_GadgetType_HyperLink
              If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
              EndIf
              
            ElseIf \Type = #PB_GadgetType_Option
              Repaint = SetState(*This, 1)
              
            ElseIf \Type = #PB_GadgetType_Panel
                
              Protected State
              
              Select at
                Case 1
                  State = \Page\Pos - \Step
                  
                  If State < \Min
                    State = \Min 
                  EndIf
                  
                  If State > \Max-\Page\len
                    If \Max > \Page\len 
                      State = \Max-\Page\len
                    Else
                      State = \Min 
                    EndIf
                  EndIf
                  
                  \Page\Pos = State
                  Repaint = 1
                  
                Case 2
                  State = \Page\Pos + \Step
                  
                  If State < \Min
                    State = \Min 
                  EndIf
                  
                  If State > \Max-\Page\len
                    If \Max > \Page\len 
                      State = \Max-\Page\len
                    Else
                      State = \Min 
                    EndIf
                  EndIf
                  
                  \Page\Pos = State
                   Repaint = 1
                 
                Default
                  If \index[1]<>-1
                    Repaint = SetState(*This, \index[1])
                  EndIf
              EndSelect
              
            
            ElseIf \Type = #PB_GadgetType_CheckBox
              Repaint = SetState(*This, Bool(\Box\Checked=#PB_Checkbox_Checked) ! 1)
              
            ElseIf \Type = #PB_GadgetType_ScrollBar Or \Type = #PB_GadgetType_Spin
              Select at
                Case 1 : Repaint = SetState(*This, (\Page\Pos - \Step)) ; Up button
                Case 2 : Repaint = SetState(*This, (\Page\Pos + \Step)) ; Down button
              EndSelect
              
            ElseIf ListSize(\items())
              If \index[1] >= 0 And SelectElement(\items(), \index[1]) 
                Protected sublevel.i
                
                If (MouseScreenY > (\items()\box\y[1]) And MouseScreenY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
                   ((MouseScreenX > \items()\box\x[1]) And (MouseScreenX =< (\items()\box\x[1]+\items()\box\width[1])))
                  
                  \items()\Box\Checked[1] ! 1
                ElseIf (\flag\buttons And \items()\childrens) And
                       (MouseScreenY > (\items()\box\y[0]) And MouseScreenY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
                       ((MouseScreenX > \items()\box\x[0]) And (MouseScreenX =< (\items()\box\x[0]+\items()\box\width[0])))
                  
                  sublevel = \items()\sublevel
                  \items()\Box\Checked ! 1
                  \Change = 1
                  
                  PushListPosition(\items())
                  While NextElement(\items())
                    If sublevel = \items()\sublevel
                      Break
                    ElseIf sublevel < \items()\sublevel And \items()\a
                      \items()\hide = Bool(\items()\a\Box\Checked Or \items()\a\hide) * 1
                    EndIf
                  Wend
                  PopListPosition(\items())
                  
                ElseIf \index[2] <> \index[1] : \items()\State = 2
                  If \index[2] >= 0 And SelectElement(\items(), \index[2])
                    \items()\State = 0
                  EndIf
                  \index[2] = \index[1]
                EndIf
                
                Repaint = 1
              EndIf
            EndIf
            
            ; scrollbar & splitter
            If at = 3                                                  ; Thumb button
              If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                delta = MouseScreenY - \Thumb\Pos
              Else
                delta = MouseScreenX - \Thumb\Pos
              EndIf
            EndIf
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                Repaint = (MouseScreenY-delta)
              Else
                Repaint = (MouseScreenX-delta)
              EndIf
              
              Repaint = SetState(*This, Pos(*This, Repaint))
            Else
              If at <> 3
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \Cursor[1])
              EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \Step = 1
                  Repaint + ((\Max-\Min) / 100)
                Else
                  Repaint + \Step
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \Step = 1
                  Repaint - ((\Max-\Min) / 100)
                Else
                  Repaint - \Step
                EndIf
              EndIf
              
              Repaint = SetState(*This, (\Page\Pos + Repaint))
            EndIf  
            
          Case #PB_EventType_MouseEnter
            ;Debug "events() MouseEnter "+\Type
            
          Case #PB_EventType_MouseLeave
            ;Debug "events() MouseLeave "+\Type
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            
            Select \Type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \Color\State = 0
            EndSelect
            
            ;If at=-1
            ;  Debug "leave "+\Type +" "+ at
            ; EndIf
            
            If at > 0
              ;,Debug "leave "+*This +" "+ \Type
              \Color[at]\State = 0
            Else
              ; Debug ""+*This +" "+ EventType +" "+ lastat
              
              If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
              EndIf
              
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
            EndIf
            
            ; Debug \Type
            ; For list
            If \Type <> #PB_GadgetType_Panel And \index[1]>=0 And SelectElement(\items(), \index[1])
              If \items()\State = 1
                \items()\State = 0
                \index[1] =- 1
              EndIf
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            
            Select \Type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \Color\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
            EndSelect
            
            If ((at = 1 And IsStart(*This)) Or (at = 2 And IsStop(*This)))
              \Color[at]\State = 0
              at = 0
            EndIf
            
            If at>0
              ; Debug "enter "+*This +" "+ \Type
              \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              ;;Debug at
              If \Type = #PB_GadgetType_Property
                If at = 3
                \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
                EndIf
              ElseIf ((\Type = #PB_GadgetType_Splitter Or \Type = #PB_GadgetType_Property) And at = 3)
                \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
              Else
                \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
              EndIf
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If Not \cursor[1]
              ;  \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
              EndIf
             ; SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \Cursor[1])
              
            EndIf
            
        EndSelect
        
        If \Text\Editable
          Repaint | Editable(*This, EventType, MouseScreenX.i, MouseScreenY.i)
        EndIf
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected repaint.i, Canvas = EventGadget()
    Static Last.i, Down.i, *Lastat.Widget_S, *Last.Widget_S, *mouseat.Widget_S
    
    With *This
      If *This > 0 And \color\alpha And Not \hide
        If Not MouseScreenX
          MouseScreenX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
        EndIf
        If Not MouseScreenY
          MouseScreenY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
        EndIf
        
        \Canvas\Mouse\x = MouseScreenX
        \Canvas\Mouse\y = MouseScreenY
        
        Select EventType 
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
            EventType = #PB_EventType_MouseMove
            
          Case #PB_EventType_LeftButtonDown, 
               #PB_EventType_MiddleButtonDown, 
               #PB_EventType_RightButtonDown
            \Canvas\Mouse\Buttons = 1
            
          Case #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonUp
            \Canvas\Mouse\Buttons = 0
            
            ; active widget key state
          Case #PB_EventType_Input, 
               #PB_EventType_KeyDown, 
               #PB_EventType_KeyUp
            
            \Canvas\input = GetGadgetAttribute(Canvas, #PB_Canvas_Input)
            \Canvas\Key = GetGadgetAttribute(Canvas, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(Canvas, #PB_Canvas_Modifiers)
            
            If *Value\Focus = *This
              repaint | Events(*This, 0, EventType, MouseScreenX, MouseScreenY)
            ElseIf *Value\Active = *This
              repaint | Events(*This, 0, EventType, MouseScreenX, MouseScreenY)
            EndIf
        EndSelect
        
        ; anchors events
        If CallBack_Anchors(*This, EventType.i, \Canvas\Mouse\Buttons, MouseScreenX.i,MouseScreenY.i)
          ProcedureReturn 1
        EndIf
        
        ; Если виджет под скроллбаром родителя то выходим
        If Bool(\p And \p\s And *This<>\p\s\v And \p\s\h<>*This And (\p\s\v\at Or \p\s\h\at))
          ProcedureReturn 1
        EndIf
        
        ; scrollbars events
        If \s
          If \s\v And \s\v\Type And (CallBack(\s\v, EventType.i, MouseScreenX.i, MouseScreenY.i) Or \s\v\at)
            ProcedureReturn 1
          EndIf
          If \s\h And \s\h\Type And (CallBack(\s\h, EventType.i, MouseScreenX.i, MouseScreenY.i) Or \s\h\at)
            ProcedureReturn 1
          EndIf
        EndIf
        
        ; Debug ""+*This+" "+EventType +" "+ \Canvas\Mouse\Buttons
        
        ; get at point buttons
        If \Canvas\Mouse\Buttons
        ElseIf (MouseScreenX>=\X And MouseScreenX<\X+\Width And MouseScreenY>\Y And MouseScreenY=<\Y+\Height) 
          If \Box And (MouseScreenX>\Box\x And MouseScreenX=<\Box\x+\Box\Width And  MouseScreenY>\Box\y And MouseScreenY=<\Box\y+\Box\Height)
            \at =- 1
          ElseIf \Box And (MouseScreenX>\Box\x[1] And MouseScreenX=<\Box\x[1]+\Box\Width[1] And  MouseScreenY>\Box\y[1] And MouseScreenY=<\Box\y[1]+\Box\Height[1])
            \at = 1
          ElseIf \Box And (MouseScreenX>\Box\x[3] And MouseScreenX=<\Box\x[3]+\Box\Width[3] And MouseScreenY>\Box\y[3] And MouseScreenY=<\Box\y[3]+\Box\Height[3])
            \at = 3
          ElseIf \Box And (MouseScreenX>\Box\x[2] And MouseScreenX=<\Box\x[2]+\Box\Width[2] And MouseScreenY>\Box\y[2] And MouseScreenY=<\Box\y[2]+\Box\Height[2])
            \at = 2
          Else
            \at =- 1
          EndIf 
          
          *mouseat = *This
          
          
          If Not \State
              repaint | Events(*This, \at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
              *Value\Last = *This
              \State = 1
            EndIf
            
          Else
            
            If \State 
              If \State = 2 
                \State = 1
                repaint | Events(*This, \at, #PB_EventType_LeftButtonUp, MouseScreenX, MouseScreenY)
              EndIf
              
              \State  = 0
              repaint | Events(*This, \at, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
              If \p : \p\State = 0 : EndIf
              *Value\Last = 0
            EndIf
            
          \at = 0
          
          
          *mouseat = 0
        EndIf
        
        If *mouseat And *Lastat <> *mouseat
          If *Lastat
            repaint | Events(*Lastat, 0, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
          EndIf
          If *mouseat
            repaint | Events(*mouseat, 0, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
          EndIf
          
          *Last = *mouseat
          *Lastat = *mouseat
        EndIf
        
        ;         Select EventType 
        ;           Case #PB_EventType_Focus
        ;             If \at And *Value\Active <> *This
        ;               *Value\Active = *This
        ;               repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
        ;             EndIf
        ;             
        ;           Case #PB_EventType_LostFocus 
        ;             If *Value\Active
        ;               *Value\Active = 0 
        ;               repaint | Events(*This, - 1, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
        ;             EndIf
        ;         EndSelect
        
        If *Lastat = *This
          If Last <> \at
            ;
            ; Debug ""+Last +" "+ *This\at +" "+ *This +" "+ *Last
            If Last > 0 Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, Last, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            If Not \at Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            
            If \at > 0 Or (\at And Not last) ; Or (Last =- 1 And \at = 2 And *Last)
              repaint | Events(*This, \at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
            
            Last = \at
          EndIf
          
          
          
          Select EventType 
            Case #PB_EventType_MouseWheel
              If \Type=#PB_GadgetType_ScrollBar 
                Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta) ; bug in mac os
                
                If \at
                  repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY, -WheelDelta)
                ElseIf *Value\Active
                  repaint | Events(*Value\Active, - 1, EventType, MouseScreenX, MouseScreenY, WheelDelta)
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If \at : \State = 2
                If *Value\Active <> *This
                  If *Value\Active
                    repaint | Events(*Value\Active, \at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
                  EndIf
                  repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
                  *Value\Active = *This
                EndIf
                
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
              
            Case #PB_EventType_LeftButtonUp
              If *Value\Active = *This : \State = 1
                repaint | Events(*Value\Active, *Value\Active\at, EventType, MouseScreenX, MouseScreenY)
                repaint | Events(*Value\Active, *Value\Active\at, #PB_EventType_LeftClick, MouseScreenX, MouseScreenY)
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
          EndSelect
        EndIf
        
        ;         ; Callback Childrens
        ;         If ListSize(\Childrens())
        ;           ForEach \Childrens() 
        ;             ;               If *Value\Active <> \Childrens()
        ;             repaint | CallBack(\Childrens(), EventType.i, MouseScreenX.i, MouseScreenY.i)
        ;             ;               EndIf
        ;           Next
        ;         EndIf
      EndIf
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i CallBacks(*This.Widget_S, EventType.i, MouseX.i=0, MouseY.i=0)
    Protected Repaint 
    
    If *This > 0 And Not *This\Hide
      Repaint | CallBack(*This, EventType, MouseX, MouseY)
      
      With *This
        ForEach \Childrens()
          Repaint | CallBacks(\Childrens(), EventType, MouseX, MouseY)
        Next 
      EndWith
    EndIf
    
    ProcedureReturn 1
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = Type
      \Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Flag&#PB_Vertical=#PB_Vertical)
      \Box = AllocateStructure(Box_S)
      \Box\Size[3] = SliderLen ; min thumb size
      
      \Box\ArrowSize[1] = 4
      \Box\ArrowSize[2] = 4
      \Box\ArrowType[1] =- 1 ; -1 0 1
      \Box\ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \Color\State = 0
      \Color\Back = $FFF9F9F9
      \Color\Frame = \Color\Back
      \Color\Line = $FFFFFFFF
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If \Vertical
          If width < 21
            \Box\Size = width - 1
          Else
            \Box\Size = 17
          EndIf
        Else
          If height < 21
            \Box\Size = height - 1
          Else
            \Box\Size = 17
          EndIf
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Vertical)
    ProcedureReturn Bar(#PB_GadgetType_ScrollBar, X,Y,Width,Height, Min, Max, PageLength, Flag|Vertical, Radius)
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth ; |(Bool(#PB_Vertical) * #PB_Bar_Inverted)
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_ProgressBar, X,Y,Width,Height, Min, Max, 0, Smooth|Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_TrackBar, X,Y,Width,Height, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    
    ;Flag | Bool(Not Flag&#PB_Vertical) * (#PB_Bar_Inverted)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = #PB_GadgetType_Spin
      
      \fs = 1
      \bs = 2
      
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\x[2] = 5
      
      ;\Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Not Flag&#PB_Vertical=#PB_Vertical)
      \Box = AllocateStructure(Box_S)
      
      \Text\String.s[1] = Str(Min)
      \Text\Change = 1
              
      \Box\ArrowSize[1] = 4
      \Box\ArrowSize[2] = 4
      \Box\ArrowType[1] =- 1 ; -1 0 1
      \Box\ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Text\Editable = 1
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      
      \Box\Size[2] = 17
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      ;\Page\len = 10
      \Step = 1
      
    EndWith
    
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \s = AllocateStructure(Scroll_S)
      \Type = #PB_GadgetType_Image
      \Color = Colors
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,\image\height, Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,\image\width,Width, 0, 7) : \s\h\p = *This
      
      SetImage(*This, Image)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Type = #PB_GadgetType_Button
      \Color = Colors
      \color\alpha = 255
      
      \fs = 1
      
      \Text\Align\Vertical = 1
      \Text\Align\Horizontal = 1
      
      \image\Align\Vertical = 1
      \image\Align\Horizontal = 1
      
      SetText(*This, Text.s)
      SetImage(*This, Image)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Cursor = #PB_Cursor_Hand
      \Type = #PB_GadgetType_HyperLink
      \Color = Colors
      \color\alpha = 255
      
      \fs = 1
      \Color\Front[1] = Color
      \Color\Front[2] = Color
      
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      \Text\MultiLine = 1
      
      \Text\x[2] = 5
      \Flag\Lines = Bool(Flag&#PB_HyperLink_Underline=#PB_HyperLink_Underline)
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Type = #PB_GadgetType_Text
      \Color = Colors
      \color\alpha = 255
      
      \fs = 1
      
      \Text\x[2] = 3
      \Text\y[2] = 0
      
      Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
      
      If Bool(Flag&#PB_Text_WordWrap)
        Flag&~#PB_Text_MultiLine
        \Text\MultiLine =- 1
      EndIf
      
      If Bool(Flag&#PB_Text_MultiLine)
        Flag&~#PB_Text_WordWrap
        \Text\MultiLine = 1
      EndIf
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ComboBox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Type = #PB_GadgetType_ComboBox
      \Color = Colors
      \color\alpha = 255
      
      \fs = 1
      \index[1] =- 1
      \index[2] =- 1
      
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      \Text\x[2] = 5
      
      \Box = AllocateStructure(Box_S)
      \Box\height = Height
      \Box\width = 15
      \Box\ArrowSize = 4
      \Box\ArrowType =- 1
      
      \index[1] =- 1
      \index[2] =- 1
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = Bool(Not flag&#PB_DisplayMode_NoFullSelection)
      \Flag\AlwaysSelection = Bool(flag&#PB_DisplayMode_AlwaysShowSelection)
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \Canvas\Window = *Value\Window
      \Canvas\Gadget = *Value\Gadget
      \Popup = Popup(*This, 0,0,0,0)
      OpenList(\Popup)
      Tree(0,0,330,330, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons)
      CloseList()
      \Popup\Childrens()\s\h\height=0
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i CheckBox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Type = #PB_GadgetType_CheckBox
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text\x[2] = 25
      
      \Radius = 3
      \Box = AllocateStructure(Box_S)
      \Box\height = 15
      \Box\width = 15
      \Box\ThreeState = Bool(Flag&#PB_CheckBox_ThreeState=#PB_CheckBox_ThreeState)
      
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Type = #PB_GadgetType_Option
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text\x[2] = 25
      
      \Box = AllocateStructure(Box_S)
      \Box\height = 15
      \Box\width = 15
      \Radius = 7
      
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Cursor = #PB_Cursor_IBeam
      \Type = #PB_GadgetType_String
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Text\Editable = 1
      
      \bs = 1
      \fs = 1
      
      \Text\x[2] = 3
      \Text\y[2] = 0
      
      \Text\Align\Vertical = 1
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      ;\Cursor = #PB_Cursor_Hand
      \s = AllocateStructure(Scroll_S) 
      \Type = #PB_GadgetType_Tree
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = Bool(Not flag&#PB_DisplayMode_NoFullSelection)
      \Flag\AlwaysSelection = Bool(flag&#PB_DisplayMode_AlwaysShowSelection)
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,Width, 0, 7) : \s\h\p = *This
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      ;\Cursor = #PB_Cursor_Hand
      \s = AllocateStructure(Scroll_S) 
      \Type = #PB_GadgetType_Tree
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = Bool(Not flag&#PB_DisplayMode_NoFullSelection)
      \Flag\AlwaysSelection = Bool(flag&#PB_DisplayMode_AlwaysShowSelection)
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,Width, 0, 7) : \s\h\p = *This
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      ;\Cursor = #PB_Cursor_Hand
      \s = AllocateStructure(Scroll_S) 
      \Type = #PB_GadgetType_ListView
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      
      If StartDrawing(CanvasOutput(*Value\Gadget))
        
        \Text\height = TextHeight("A")
        
        StopDrawing()
      EndIf
      
      \sublevellen = 0
      \Flag\Lines = 0
      \flag\buttons = 0
      
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = Bool(Not flag&#PB_DisplayMode_NoFullSelection)
      \Flag\AlwaysSelection = Bool(flag&#PB_DisplayMode_AlwaysShowSelection)
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,0, 0,0,0, 0, 0) : \s\h\p = *This
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Container =- 2
      \Type = #PB_GadgetType_Frame
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \TabHeight = 16
      
      \bs = 1
      \fs = 1
      
      \Text\String.s[1] = Text.s
      \Text\Change = 1
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar.Widget_S, *This.Widget_S, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    *This = Bar(0, X,Y,Width,Height, 0, Max, 0, Auto|Vertical|#PB_Bar_NoButtons, 0, 7)
    
    With *This
      \Thumb\len = 7
      \Type = #PB_GadgetType_Splitter
      
      \SplitterFirst = First
      \SplitterSecond = Second
      
      If \SplitterFirst
        \Type[1] = \SplitterFirst\Type
      EndIf
      
      If \SplitterSecond
        \Type[2] = \SplitterSecond\Type
      EndIf
      
      SetParent(\SplitterFirst, *This)
      SetParent(\SplitterSecond, *This)
      
      If \Vertical
        \Cursor = #PB_Cursor_UpDown
        SetState(*This, \height/2-1)
      Else
        \Cursor = #PB_Cursor_LeftRight
        SetState(*This, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \X =- 1
      \Y =- 1
      
      \Box = AllocateStructure(Box_S)
      \Thumb\len = 7
      \Box\Size[3] = 7 ; min thumb size
      SetAttribute(*This, #PB_Bar_Maximum, Width) 
      
      ;\Container = 1
      \Type = #PB_GadgetType_Property
      
      
      \Cursor = #PB_Cursor_LeftRight
      SetState(*This, SplitterPos)
      
      
      \s = AllocateStructure(Scroll_S) 
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = Bool(Not flag&#PB_DisplayMode_NoFullSelection)
      \Flag\AlwaysSelection = Bool(flag&#PB_DisplayMode_AlwaysShowSelection)
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,Width, 0, 7) : \s\h\p = *This
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  ;- Containers
  Procedure.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Container = 1
      \s = AllocateStructure(Scroll_S) 
      \Type = #PB_GadgetType_ScrollArea
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \fs = 1
      \bs = 2
      
      \s\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,ScrollAreaHeight,Height, #PB_Vertical, 7) : \s\v\p = *This
      \s\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,ScrollAreaWidth,Width, 0, 7) : \s\h\p = *This
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Container = 1
      \Type = #PB_GadgetType_Container
      \Color = Colors
      \color\alpha = 255
      \Color\Back =- 1;  $FFF9F9F9
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      \Container = 1
      \Type = #PB_GadgetType_Panel
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] = 0
      
      \Box = AllocateStructure(Box_S)
      \Box\Size = 13 
      
      \Box\ArrowSize[1] = 6
      \Box\ArrowSize[2] = 6
      \Box\ArrowType[1] =- 1
      \Box\ArrowType[2] =- 1
      \Box\Color[1] = Colors
      \Box\Color[2] = Colors
      
      \Box\color[1]\alpha = 255
      \Box\color[2]\alpha = 255
      
      \Page\len = Width
      ;\Max = Width
      \TabHeight = 25
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Window(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
    If LastElement(*openedlist()) And *openedlist()\Type =- 1
      CloseList()
    EndIf
    
    With *This
      \Container =- 1
      \Type =- 1
      \Color = Colors
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \TabHeight = 25
      
      \fs = 1
      \bs = 5
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetLastParent(*This) : SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
Macro GetActiveWidget()
  Widget::*Value\Active
EndMacro

Macro EventWidget()
  Bool(Not IsGadget(Widget::PB(EventGadget)())) * Widget::PB(EventGadget)() + Bool(IsGadget(Widget::PB(EventGadget)())) * Widget::*Value\This
EndMacro

Macro WidgetEvent()
  Bool(Not IsGadget(Widget::PB(EventGadget)())) * Widget::PB(EventType)() + Bool(IsGadget(Widget::PB(EventGadget)())) * Widget::*Value\Type
EndMacro

Macro EventGadget()
  (Bool(Event()<>Widget::#PB_Event_Widget) * Widget::PB(EventGadget)() + Bool(Event()=Widget::#PB_Event_Widget) * Widget::*Value\Gadget)
EndMacro



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  
  ;   IncludePath "../"
  ;   XIncludeFile "widgets.pbi"
  
  EnableExplicit
  UseModule Widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i,NewMap Widgets.i()
  
;   Procedure ReDraw(Gadget.i)
;     If StartDrawing(CanvasOutput(Gadget))
;       DrawingMode(#PB_2DDrawing_Default)
;       Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
;       
;       ForEach Widgets()
;         Draw(Widgets(), 1)
;       Next
;       
;       StopDrawing()
;     EndIf
;   EndProcedure
  
  Procedure ReDraw(Canvas)
    If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
      ;       DrawingMode(#PB_2DDrawing_Default)
      ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FFEEEEEE)
      
      Draw(Widgets("Container"), 1)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resize(Widgets("Container"), x, y, Width-x*2, Height-y*2)  
        Repaint = 1 
    EndSelect
    
    Repaint | CallBacks(Widgets("Container"), EventType, mouseX,mouseY)
    
    If Repaint
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
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
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
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
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  If OpenWindow(3, 0, 0, 995, 455, "Position de la souris sur la fenêtre", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(100, 0, 0, 995, 455, #PB_Canvas_Keyboard )
    BindGadgetEvent(100, @Canvas_CallBack())
    
    If Use(3, 100)
      
      Widgets("Container") = Container(0, 0, 995, 455);, #PB_Flag_AutoSize) 
      
      Widgets(Str(#PB_GadgetType_Button)) = Button(5, 5, 160,70, "Button_"+Str(#PB_GadgetType_Button) ) ; ok
      Widgets(Str(#PB_GadgetType_String)) = String(5, 80, 160,70, "String_"+Str(#PB_GadgetType_String)) ; ok
      Widgets(Str(#PB_GadgetType_Text)) = Text(5, 155, 160,70, "Text_"+Str(#PB_GadgetType_Text))        ; ok
      Widgets(Str(#PB_GadgetType_CheckBox)) = CheckBox(5, 230, 160,70, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Str(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween); ok
      Widgets(Str(#PB_GadgetType_Option)) = Option(5, 305, 160,70, "Option_"+Str(#PB_GadgetType_Option) ) : SetState(Widgets(Str(#PB_GadgetType_Option)), 1)                                                       ; ok
      Widgets(Str(#PB_GadgetType_ListView)) = ListView(5, 380, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_ListView)), -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ListView)), i, "item_"+Str(i)) : Next
      
      Widgets(Str(#PB_GadgetType_Frame)) = Frame(170, 5, 160,70, "Frame_"+Str(#PB_GadgetType_Frame) )
      Widgets(Str(#PB_GadgetType_ComboBox)) = ComboBox(170, 80, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), i, "item_"+Str(i)) : Next : SetState(Widgets(Str(#PB_GadgetType_ComboBox)), 0) 
      Widgets(Str(#PB_GadgetType_Image)) = Image(170, 155, 160,70, 0, #PB_Image_Border ) ; ok
      Widgets(Str(#PB_GadgetType_HyperLink)) = HyperLink(170, 230, 160,70,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) ; ok
      Widgets(Str(#PB_GadgetType_Container)) = Container(170, 305, 160,70, #PB_Container_Flat )
      Widgets(Str(101)) = Option(10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetState(Widgets(Str(101)), 1)  
      Widgets(Str(102)) = Option(10, 40, 110,20, "Option_widget" )  
      CloseList()
      ;     ListIconGadget(#PB_GadgetType_ListIcon, 170, 380, 160,70,"ListIconGadget_"+Str(#PB_GadgetType_ListIcon),120 )                           ; ok
      
      ;     IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,70 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    ; ok
      Widgets(Str(#PB_GadgetType_ProgressBar)) = Progress(335, 80, 160,70,0,100) : SetState(Widgets(Str(#PB_GadgetType_ProgressBar)), 50)
      Widgets(Str(#PB_GadgetType_ScrollBar)) = Scroll(335, 155, 160,70,0,100,20) : SetState(Widgets(Str(#PB_GadgetType_ScrollBar)), 40)
      Widgets(Str(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 230, 160,70,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Str(201)) = Button(0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) : Widgets(Str(202)) = Button(180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseList()
      Widgets(Str(#PB_GadgetType_TrackBar)) = Track(335, 305, 160,70,0,100) : SetState(Widgets(Str(#PB_GadgetType_TrackBar)), 25)
      ;     WebGadget(#PB_GadgetType_Web, 335, 380, 160,70,"" )
      
      Widgets(Str(#PB_GadgetType_ButtonImage)) = Button(500, 5, 160,70, "", 0, 1)
      ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 80, 160,70 )
      ;     DateGadget(#PB_GadgetType_Date, 500, 155, 160,70 )
      ;     EditorGadget(#PB_GadgetType_Editor, 500, 230, 160,70 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "EditorGadget_"+Str(#PB_GadgetType_Editor))  
      ;     ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 305, 160,70,"" )
      ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 380, 160,70,"" )
      ;     
      ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,70,"" )
      Widgets(Str(#PB_GadgetType_Spin)) = Spin(665, 80, 160,70,20,100)
      Widgets(Str(#PB_GadgetType_Tree)) = Tree( 665, 155, 160, 70 ) : AddItem(Widgets(Str(#PB_GadgetType_Tree)), -1, "Tree_"+Str(#PB_GadgetType_Tree)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_Tree)), i, "item_"+Str(i)) : Next
      Widgets(Str(#PB_GadgetType_Panel)) = Panel(665, 230, 160,70) : AddItem(Widgets(Str(#PB_GadgetType_Panel)), -1, "Panel_"+Str(#PB_GadgetType_Panel)) : Widgets(Str(255)) = Button(0, 0, 90,20, "Button_255" ) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_Panel)), i, "item_"+Str(i)) : Next : CloseList()
      
      OpenList(Widgets(Str(#PB_GadgetType_Panel)), 1)
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt") 
      CloseList()
      CloseList()
      CloseList()
      SetState( Widgets(Str(#PB_GadgetType_Panel)), 15)
      
      Widgets(Str(301)) = Spin(0, 0, 100,20,0,10, #PB_Vertical);, "Button_1")
      Widgets(Str(302)) = Spin(0, 0, 100,20,0,10);, "Button_2")
      Widgets(Str(#PB_GadgetType_Splitter)) = Splitter(665, 305, 160,70,Widgets(Str(301)), Widgets(Str(302)));, #PB_Splitter_Vertical);, Button(0, 0, 100,20, "ButtonGadget"), Button(0, 0, 0,20, "StringGadget")) 
                                                                                                             ;     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                                                                                                             ;       MDIGadget(#PB_GadgetType_MDI, 665, 380, 160,70,1, 2);, #PB_MDI_AutoSize)
                                                                                                             ;     CompilerEndIf
                                                                                                             ;     InitScintilla()
                                                                                                             ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,70,0 )
                                                                                                             ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 80, 160,70 ,-1)
                                                                                                             ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 155, 160,70 )
      
      CloseList()
      
      ReDraw(100)
    EndIf
    
    Repeat
      Define  Event = WaitWindowEvent()
      ;       If Event
      ;       Define  Window = EventWindow()
      ;         If IsWindow(Window)
      ;            MouseState( )
      ;           Select Window
      ;             Case 1 :EventMain(Event, Window)
      ;           EndSelect
      ;         EndIf
      ;       EndIf
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----------------------------4----------fl--------------------------9------------------------------------------------------------------------------vRA-
; EnableXP