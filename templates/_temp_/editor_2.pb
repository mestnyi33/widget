DeclareModule Macros
  Macro StartDrawingCanvas(_canvas_)
    Bool(IsGadget(_canvas_) And StartDrawing(CanvasOutput(_canvas_)))
  EndMacro
  
  Macro StopDrawingCanvas()
    Bool(ListSize(List()) And IsGadget(List()\Widget\Canvas\Gadget) And Not StopDrawing())
  EndMacro
  
  Macro From(_this_, _buttons_=0)
    Bool(_this_\Canvas\Mouse\X>=_this_\x[_buttons_] And _this_\Canvas\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\Canvas\Mouse\Y>=_this_\y[_buttons_] And _this_\Canvas\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
  EndMacro
  
  Macro isItem(_item_, _list_)
    Bool(_item_ >= 0 And _item_ < ListSize(_list_))
  EndMacro
  
  Macro itemSelect(_item_, _list_)
    Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
  EndMacro
  
  Macro add_widget(_widget_, _hande_)
    If _widget_ =- 1 Or _widget_ > ListSize(List()) - 1
      LastElement(List())
      _hande_ = AddElement(List()) 
      _widget_ = ListIndex(List())
    Else
      _hande_ = SelectElement(List(), _widget_)
      ; _hande_ = InsertElement(List())
      PushListPosition(List())
      While NextElement(List())
        List()\Widget\Index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
  EndMacro
  
  Macro _frame_(_this_, _x_,_y_,_width_,_height_, _color_1_, _color_2_);, _radius_=0)
    ClipOutput(_x_-1,_y_-1,_width_+1,_height_+1)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2, _this_\Radius,_this_\Radius, _color_1_)  
    
    ClipOutput(_x_+_this_\Radius/3,_y_+_this_\Radius/3,_width_+2,_height_+2)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2,_this_\Radius,_this_\Radius, _color_2_)  
    
;     If _radius_ And _this_\Radius : RoundBox(_x_,_y_-1,_width_,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
;     If _radius_ And _this_\Radius : RoundBox(_x_-1,_y_-1,_width_+1,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
    
    UnclipOutput() : _clip_output_(_this_, _this_\X[1]-1,_this_\Y[1]-1,_this_\Width[1]+2,_this_\Height[1]+2)
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
  
  Macro _colors_(_adress_, _i_, _ii_, _iii_)
    ; Debug ""+_i_+" "+ _ii_+" "+ _iii_
    
    If _adress_\Color[_i_]\Line[_ii_]
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[_i_]\Line[_ii_]
    Else
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[0]\Line[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Fore[_ii_]
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[_i_]\Fore[_ii_]
    Else
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[0]\Fore[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Back[_ii_]
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[_i_]\Back[_ii_]
    Else
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[0]\Back[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Front[_ii_]
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[_i_]\Front[_ii_]
    Else
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[0]\Front[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Frame[_ii_]
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[_i_]\Frame[_ii_]
    Else
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[0]\Frame[_ii_]
    EndIf
  EndMacro
  
  Macro ResetColor(_adress_)
    
    _colors_(_adress_, 0, 1, 0)
    
    _colors_(_adress_, 1, 1, 0)
    _colors_(_adress_, 2, 1, 0)
    _colors_(_adress_, 3, 1, 0)
    
    _colors_(_adress_, 1, 1, 1)
    _colors_(_adress_, 2, 1, 1)
    _colors_(_adress_, 3, 1, 1)
    
    _colors_(_adress_, 1, 2, 2)
    _colors_(_adress_, 2, 2, 2)
    _colors_(_adress_, 3, 2, 2)
    
    _colors_(_adress_, 1, 3, 3)
    _colors_(_adress_, 2, 3, 3)
    _colors_(_adress_, 3, 3, 3)
    
  EndMacro
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _radius_)
    Bool(Sqr(Pow(((_position_x_+_radius_) - _mouse_x_),2) + Pow(((_position_y_+_radius_) - _mouse_y_),2)) =< _radius_)
  EndMacro
  
  Macro Max(_a_, _b_)
    ((_a_) * Bool((_a_) > = (_b_)) + (_b_) * Bool((_b_) > (_a_)))
  EndMacro
  
  Macro Min(_a_, _b_)
    ((_a_) * Bool((_a_) < = (_b_)) + (_b_) * Bool((_b_) < (_a_)))
  EndMacro
  
  Macro SetBit(_var_, _bit_) ; Установка бита.
    _var_ | (_bit_)
  EndMacro
  
  Macro ClearBit(_var_, _bit_) ; Обнуление бита.
    _var_ & (~(_bit_))
  EndMacro
  
  Macro InvertBit(_var_, _bit_) ; Инвертирование бита.
    _var_ ! (_bit_)
  EndMacro
  
  Macro TestBit(_var_, _bit_) ; Проверка бита (#True - установлен; #False - обнулен).
    Bool(_var_ & (_bit_))
  EndMacro
  
  Macro NumToBit(_num_) ; Позиция бита по его номеру.
    (1<<(_num_))
  EndMacro
  
  Macro GetBits(_var_, _start_pos_, _end_pos_)
    ((_var_>>(_start_pos_))&(NumToBit((_end_pos_)-(_start_pos_)+1)-1))
  EndMacro
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  Macro _set_scroll_height_(_this_)
    If _this_\Scroll And Not _this_\hide And Not _this_\Items()\Hide
      _this_\Scroll\Height+_this_\Text\Height
      
      
     ; _this_\scroll\v\max = _this_\scroll\Height
    EndIf
  EndMacro
  
  Macro _set_scroll_width_(_this_)
    If _this_\Scroll And Not _this_\items()\hide And
       _this_\Scroll\width<(_this_\items()\text\x+_this_\items()\text\width)-_this_\x[2]
      _this_\scroll\width=(_this_\items()\text\x+_this_\items()\text\width)-_this_\x[2]
;        _this_\Scroll\width<(_this_\sci\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
;       _this_\scroll\width=(_this_\sci\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
      
;       If _this_\scroll\width < _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
;         _this_\scroll\width = _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
;       EndIf
      
;        If _this_\scroll\Height < _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
;         _this_\scroll\Height = _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
;       EndIf
     
      _this_\Text\Big = _this_\Items()\Index ; Позиция в тексте самой длинной строки
      _this_\Text\Big[1] = _this_\Items()\Text\Pos ; Может и не понадобятся
      _this_\Text\Big[2] = _this_\Items()\Text\Len ; Может и не понадобятся
      
          
     ; _this_\scroll\h\max = _this_\scroll\width
     ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
;   Macro _set_line_pos_(_this_)
;     _this_\Items()\Text\Pos = _this_\Text\Pos
;     _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
;     _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
;   EndMacro
  
  Macro RowBackColor(_this_, _state_)
    _this_\Row\Color\Back[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowForeColor(_this_, _state_)
    _this_\Row\Color\Fore[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFrameColor(_this_, _state_)
    _this_\Row\Color\Frame[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFontColor(_this_, _state_)
    _this_\Color\Front[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  
  Macro _set_open_box_XY_(_this_, _items_, _x_, _y_)
    If (_this_\flag\buttons Or _this_\Flag\Lines) 
      _items_\box\width = _this_\flag\buttons
      _items_\box\height = _this_\flag\buttons
      _items_\box\x = _x_+_items_\sublevellen-(_items_\box\width)/2
      _items_\box\y = (_y_+_items_\height)-(_items_\height+_items_\box\height)/2
    EndIf
  EndMacro
  
  Macro _set_check_box_XY_(_this_, _items_, _x_, _y_)
    If _this_\Flag\CheckBoxes
      _items_\box\width[1] = _this_\Flag\CheckBoxes
      _items_\box\height[1] = _this_\Flag\CheckBoxes
      _items_\box\x[1] = _x_+(_items_\box\width[1])/2
      _items_\box\y[1] = (_y_+_items_\height)-(_items_\height+_items_\box\height[1])/2
    EndIf
  EndMacro
  
  Macro _draw_plots_(_this_, _items_, _x_, _y_)
    ; Draw plot
    If _this_\sublevellen And _this_\Flag\Lines 
      Protected line_size = _this_\Flag\Lines
      Protected x_point=_x_+_items_\sublevellen
      
      If x_point>_this_\x[2] 
        Protected y_point=_y_
        
        If Drawing
          ; Horizontal plot
          DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
          Line(x_point,y_point,line_size,1, $FF000000)
        EndIf
        
        ; Vertical plot
        If _items_\handle
          Protected start = _items_\sublevel
          
          ; это нужно если линия уходит за предели границы виджета
          If _items_\handle[1]
            PushListPosition(_items_)
            ChangeCurrentElement(_items_, _items_\handle[1]) 
            ;If \Hide : Drawing = 2 : EndIf
            PopListPosition(_items_)
          EndIf
          
          PushListPosition(_items_)
          ChangeCurrentElement(_items_, _items_\handle) 
          If Drawing  
            If start
              If _this_\sublevellen > 10
                start = (_items_\y+_items_\height+_items_\height/2) + _this_\Scroll\Y - line_size
              Else
                start = (_items_\y+_items_\height/2) + _this_\Scroll\Y
              EndIf
            Else 
              start = (_this_\y[2]+_items_\height/2)+_this_\Scroll\Y
            EndIf
            
            DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotY())
            Line(x_point,start,1, (y_point-start), $FF000000)
          EndIf
          PopListPosition(_items_)
        EndIf
      EndIf
    EndIf
  EndMacro
  
  ; val = %10011110
  ; Debug Bin(GetBits(val, 0, 3))
  ; Force to call orginal PB-Function
  Macro PB(Function)
    Function
  EndMacro
  
  ;-
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
    Declare.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
    Declare.i DrawText_(x.i, y.i, Text.s, FrontColor.i=$ffffff, BackColor.i=0)
    Declare.i ClipOutput_(x.i, y.i, width.i, height.i)
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawText_(x, y, Text, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
  CompilerEndIf
  
  Macro _clip_output_(_this_, _x_,_y_,_width_,_height_)
    If _x_<>#PB_Ignore : _this_\Clip\X = _x_ : EndIf
    If _y_<>#PB_Ignore : _this_\Clip\Y = _y_ : EndIf
    If _width_<>#PB_Ignore : _this_\Clip\Width = _width_ : EndIf
    If _height_<>#PB_Ignore : _this_\Clip\Height = _height_ : EndIf
    
;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;       ClipOutput_(_this_\Clip\X,_this_\Clip\Y,_this_\Clip\Width,_this_\Clip\Height)
;       ;ClipOutput(_this_\Clip\X,_this_\Clip\Y,_this_\Clip\Width,_this_\Clip\Height)
;       
;     CompilerElse
      ClipOutput(_this_\Clip\X,_this_\Clip\Y,_this_\Clip\Width,_this_\Clip\Height)
;     CompilerEndIf
  EndMacro
  
  
  Declare GetTextWidth(text.s, len)
  Declare SetTextWidth(Text.s, Len.i)
  Global set_text_width.s 
  
;   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;     set_text_width.s = "_№qwertyuiopasdfghjklzxcvbnm\QWERTYUIOPASDFGHJKLZXCVBNM йцукенгшщзхъфывапролджэ\ячсмитьбю./ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,][{}|'+-=()*&^%$#@!±§<>`~:?0123456789"+~"\"" : Macro TextWidth(Text) : GetTextWidth(Text, Len(Text)) : EndMacro
;   CompilerEndIf
EndDeclareModule 

Module Macros
  Global NewMap get_text_width.i()
  
  Procedure GetTextWidth(text.s, len)
    Protected i, TextWidth.i
    
    For i=1 To len
      TextWidth + get_text_width(Mid(Text.s, i, 1))
    Next
    
    ProcedureReturn TextWidth + Bool(#PB_Compiler_OS = #PB_OS_MacOS And i>1) * (i/2)
  EndProcedure
  
  Procedure SetTextWidth(Text.s, Len.i)
    Protected i, w, Key.s
    
    For i = 0 To Len 
      Key.s = Mid(Text.s, i, 1)
      
      If Not FindMapElement(get_text_width(), Key.s)
        w = PB(TextWidth)(Key)
        
        If w
          get_text_width(Key) = w
          
         ; Debug "width - "+get_text_width(Key) +" "+ gettextwidth(Key, Len(Key)) +" "+ Key +" "+ i
        EndIf
      EndIf
    Next
    
  EndProcedure
  
  
; https://www.purebasic.fr/german/viewtopic.php?f=3&t=31144
;   Procedure.i SetBit(*Target,Bit.i)
;     !mov rax,[p.p_Target]
;     !mov rcx,[p.v_Bit] 
;     !bts [rax],rcx
;   EndProcedure
;   
;   Procedure.i GetBit(*Target,Bit.i)
;     !xor rax,rax
;     !mov rcx,[p.p_Target]
;     !mov rdx,[p.v_Bit]
;     !bt [rcx],rdx
;     !setc al
;     ProcedureReturn
;   EndProcedure
  
; Procedure.i SetBits(*Target.Long, Offset.i, Value.i)
;    *Target\l | (Value << Offset)
; EndProcedure
; 
; Procedure.i GetBits(*Target.Long, Offset.i)
;    ProcedureReturn (*Target\l >> Offset) & %111
; EndProcedure
; Global Buffer.l

; SetBits(@Buffer,0,3);<- setze den Wert 4 (in 3 Bits) an die Position @Buffer + Offset (in Bits)
; Debug GetBits(@Buffer,0);<- hier wird der Wert wieder ausgelesen


  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, ZeroPoint.NSPoint
      
      CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
      
      r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
      
      r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
      
      NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
      
      CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
      
      y = OutputHeight()-y
      Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
      CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
      CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
      x = 0 : y = -Size\height
      CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
      CocoaMessage(0, Transform, "concat")
      CocoaMessage(0, NSString, "drawAtPoint:@", @ZeroPoint, "withAttributes:", Attributes)
      
      CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
    EndProcedure
    
    Procedure.i DrawText_(x.i, y.i, Text.s, FrontColor.i=$ffffff, BackColor.i=0)
      Protected.CGFloat r,g,b,a
      Protected.i NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
      
      r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
      
      r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
      
      NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
      Point\x = x : Point\y = OutputHeight()-Size\height-y
      CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
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
  
EndModule 

UseModule Macros

DeclareModule Constants
  #VectorDrawing = 0
  
  ;CompilerIf #VectorDrawing
  ;  UseModule Draw
  ;CompilerEndIf
  
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
  
  EnumerationBinary WidgetFlags
;     #PB_Text_Center
;     #PB_Text_Right
    #PB_Text_Left = 4
    #PB_Text_Bottom
    #PB_Text_Middle 
    #PB_Text_Top
    
    #PB_Text_Numeric
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
     
    #PB_Text_Reverse ; Mirror
    #PB_Text_InLine
    
    #__Flag_Vertical
    #__Flag_BorderLess
    #__Flag_Double
    #__Flag_Flat
    #__Flag_Raised
    #PB__s_flagingle
    
    #__Flag_Default
    #__Flag_Toggle
    
    #__Flag_GridLines
    #__Flag_Invisible
    
    #__Flag_MultiSelect
    #__Flag_ClickSelect
    
    #__Flag_AutoSize
    #__Flag_AutoRight
    #__Flag_AutoBottom
    
    #__Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    ; #____End____
  EndEnumeration
  
  #__Flag_Numeric = #PB_Text_Numeric
  #__Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #__Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  
  #__Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #__Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
    
  #__Flag_AlwaysSelection = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  
  #PB_Attribute_Selected = #PB_Tree_Selected                       ; 1
  #PB_Attribute_Expanded = #PB_Tree_Expanded                       ; 2
  #PB_Attribute_Checked = #PB_Tree_Checked                         ; 4
  #PB_Attribute_Collapsed = #PB_Tree_Collapsed                     ; 8
  
  #PB_Attribute_SmallIcon = #PB_ListIcon_LargeIcon                 ; 0 0
  #PB_Attribute_LargeIcon = #PB_ListIcon_SmallIcon                 ; 1 1
  
  #PB_Attribute_Numeric = 1
;   #PB_Text_Left = ~#PB_Text_Center
;   #PB_Text_Top = ~#PB_Text_Middle
;   
   EnumerationBinary WidgetFlags
      #__Flag_Limit
    EndEnumeration
    
    If (#__Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#__Flag_Limit>>1)+")"
  EndIf
  
  #PB_Gadget_FrameColor = 10
  
  #PB_ScrollBar_Direction = 1<<2
  #PB_ScrollBar_NoButtons = 1<<3
  #PB_ScrollBar_Inverted = 1<<4
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants

DeclareModule Structures
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; PB Interne Struktur Gadget MacOS
    Structure sdkGadget
      *gadget
      *container
      *vt
      UserData.i
      Window.i
      Type.i
      Flags.i
    EndStructure
  CompilerEndIf
  
  ;- STRUCTURE
  ;- - _s_point
  Structure _s_point
    y.i
    x.i
  EndStructure
  
  ;- - _s_Coordinate
  Structure _s_Coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - _s_mouse
  Structure _s_mouse
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
    *Delta._s_mouse
  EndStructure
  
  ;- - _s_align
  Structure _s_align
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - _s_page
  Structure _s_page
    Pos.i
    len.i
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - _s_flag
  Structure _s_flag
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
  
  ;- - _s_image
  Structure _s_image Extends _s_Coordinate
    handle.i[2]
    change.b
    Align._s_align
  EndStructure
  
  ;- - _s_text
  Structure _s_text Extends _s_Coordinate
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
    
    Align._s_align
    ;List Char.c()
    ;Map Char.i()
  EndStructure
    
  ;- - _s_bar
  Structure _s_bar Extends _s_Coordinate  ; Bar::_s_bar ; 
    *s._s_scroll
    
    ; splitter bar
    *First._s_bar 
    *Second._s_bar
    
    ; track bar
    Ticks.b
    
    ; progress bar
    Smooth.b
    
    at.b
    Type.i[3] ; [2] for splitter
    Radius.a
    ArrowSize.a[3]
    ArrowType.b[3]
    
    Max.i
    Min.i
    *Step
    Hide.b[2]
    
    Focus.b
    Change.b
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    ButtonLen.i[4]
    
    Page._s_page
    Area._s_page
    Thumb._s_page
    Color._s_color[4]
  EndStructure
  
  ;- - _s_event
  Structure Post_S
    Gadget.i
    Window.i
    Type.i
    Event.i
    *Function
    *Widget._s_bar
    *Active._s_bar
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll Extends _s_Coordinate
    ;Post.Post_S
    
    *v._s_bar
    *h._s_bar
  EndStructure
  
  ;- - _s_canvas
  Structure _s_canvas
    Mouse._s_mouse
    Gadget.i[3]
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  ;- - _s_margin
  Structure _s_margin
    FonyID.i
    Width.i
    Color._s_color
  EndStructure
  
  ;- - _s_scintilla
  Structure _s_scintilla
    Margin._s_margin
  EndStructure
  
  ;- - _s_row
  Structure _s_row Extends _s_Coordinate
    Color._s_color
  EndStructure
  
  ;- - _s_color
  Structure Colors_S
    State.b
;     Front.i[4]
;     Fore.i[4]
;     Back.i[4]
;     Line.i[4]
;     Frame.i[4]
;      Alpha.a[2]
  EndStructure
  
  ;- - _s_rows
  Structure _s_rows Extends _s_Coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    handle.i[2]
    
    Color.Colors_S
    Text._s_text[4]
    Image._s_image
    box._s_Coordinate
    
    Hide.b[2]
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    Focus.i
    LostFocus.i
    
    Checked.b[2]
    Vertical.b
    Radius.i
    
    change.b
    sublevel.i
    ;sublevelpos.i
    sublevellen.i
    
    collapsed.b
    childrens.i
    *data  ; set/get item data
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget Extends _s_Coordinate
    Type.i
    handle.i    ; Adress of new list element
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
   ;;; line.i[3]   ; 
    
    CountItems.i[2]
    
    Sci._s_scintilla
    *Widget._s_widget
    Canvas._s_canvas
    Color._s_color
    Text._s_text[4]
    Clip._s_Coordinate
    *tooltip._s_text
    scroll._s_scroll
    image._s_image
    flag._s_flag
    
    bSize.b
    fSize.b[2]
    Hide.b[2]
    Disable.b[2]
    Interact.b ; будет ли взаимодействовать с пользователем?
    Cursor.i[2]
    
    
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    Buttons.i
    
    *data
    change.b
    radius.i
    vertical.b
    checked.b[2]
    sublevellen.i
    
    attribute.i
    
    *Default
    row._s_row
    List *Items._s_rows()
    List *Lines._s_rows()
    List *Columns._s_widget()
    Repaint.i ; Будем посылать сообщение что надо перерисовать а после надо сбрасывать переменую
  EndStructure
  
  ;-
  ;- Colors
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors._s_color
  
  With Colors                          
    \State = 0
    
    ;- Серые цвета 
    ;     ; Цвета по умолчанию
    ;     \Front[0] = $FF000000
    ;     \Fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;     \Back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;     \Line[0] = $FFA3A3A3
    ;     \Frame[0] = $FFA5A5A5 ; $FFBABABA
    ;     
    ;     ; Цвета если мышь на виджете
    ;     \Front[1] = $FF000000
    ;     \Fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;     \Back[1] = $FFCECECE ; $FFEAEAEA ; 
    ;     \Line[1] = $FF5B5B5B
    ;     \Frame[1] = $FF8F8F8F
    ;     
    ;     ; Цвета если нажали на виджет
    ;     \Front[2] = $FFFFFFFF
    ;     \Fore[2] = $FFE2E2E2
    ;     \Back[2] = $FFB4B4B4
    ;     \Line[2] = $FFFFFFFF
    ;     \Frame[2] = $FF6F6F6F
    
    ;- Зеленые цвета
    ;             ; Цвета по умолчанию
    ;             \Front[0] = $FF000000
    ;             \Fore[0] = $FFFFFFFF
    ;             \Back[0] = $FFDAFCE1  
    ;             \Frame[0] = $FF6AFF70 
    ;             
    ;             ; Цвета если мышь на виджете
    ;             \Front[1] = $FF000000
    ;             \Fore[1] = $FFE7FFEC
    ;             \Back[1] = $FFBCFFC5
    ;             \Frame[1] = $FF46E064 ; $FF51AB50
    ;             
    ;             ; Цвета если нажали на виджет
    ;             \Front[2] = $FFFEFEFE
    ;             \Fore[2] = $FFC3FDB7
    ;             \Back[2] = $FF00B002
    ;             \Frame[2] = $FF23BE03
    
    ;- Синие цвета
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
    \Fore[2] = $FFE9BA81;$C8FFFCFA
    \Back[2] = $FFE89C3D ; $80E89C3D
    \Frame[2] = $FFDC9338; $80DC9338
    
    ;         ;- Синие цвета 2
    ;         ; Цвета по умолчанию
    ;         \Front[0] = $FF000000
    ;         \Fore[0] = $FFF8F8F8 ; $FFF0F0F0 
    ;         \Back[0] = $FFE5E5E5
    ;         \Frame[0] = $FFACACAC 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \Front[1] = $FF000000
    ;         \Fore[1] = $FFFAF8F8 ; $FFFCF4EA
    ;         \Back[1] = $FFFAE8DB ; $FFFCECDC
    ;         \Frame[1] = $FFFC9F00
    ;         
;             ; Цвета если нажали на виджет
;             \Front[2] = $FF000000;$FFFFFFFF
;             \Fore[2] = $FFFDF7EF
;             \Back[2] = $FFFBD9B7
;             \Frame[2] = $FFE59B55
    
  EndWith
  
  Global *Focus._s_widget
  Global NewList List._s_widget()
  Global Use_List_Canvas_Gadget,  _scroll_height_2
            
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures


DeclareModule Bar
  EnableExplicit
  
  ;- - STRUCTUREs
  ;- - _s_Coordinate
  Structure _s_Coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    State.b ; entered; selected; focused; lostfocused
    Front.i[4]
    Line.i[4]
    Fore.i[4]
    Back.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - _s_page
  Structure _s_page
    Pos.i
    len.i
  EndStructure
  
  ;   ;- - Splitter_S
  ;   Structure Splitter_S Extends _s_Coordinate
  ;     Type.i
  ;   EndStructure
  
  ;- - _s_bar
  Structure _s_bar Extends _s_Coordinate
    *s._s_scroll
    
    ; splitter bar
    *First._s_bar 
    *Second._s_bar
    
    ; track bar
    Ticks.b
    
    ; progress bar
    Smooth.b
    
    at.b
    Type.i[3] ; [2] for splitter
    Radius.a
    ArrowSize.a[3]
    ArrowType.b[3]
    
    Max.i
    Min.i
    *Step
    Hide.b[2]
    
    Focus.b
    Change.b
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    ButtonLen.i[4]
    
    Page._s_page
    Area._s_page
    Thumb._s_page
    Color._s_color[4]
  EndStructure
  
  ;- - _s_event
  Structure Post_S
    Gadget.i
    Window.i
    Type.i
    Event.i
    *Function
    *Widget._s_bar
    *Active._s_bar
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll Extends _s_Coordinate
    ;Post.Post_S
    
    *v._s_bar
    *h._s_bar
  EndStructure
  
  ;-
  ;- - DECLAREs CONSTANTs
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #PB_Gadget_FrameColor = 10
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Direction = 1<<2
  #PB_Bar_NoButtons = 1<<3
  #PB_Bar_Inverted = 1<<4
  #PB_Bar_Ticks = 1<<5
  #PB__s_barmooth = 1<<6
  
  #PB_Bar_First = 1<<7
  #PB__s_barecond = 1<<8
  #PB_Bar_FirstFixed = 1<<9
  #PB__s_barecondFixed = 1<<10
  #PB_Bar_FirstMinimumSize = 1<<11
  #PB__s_barecondMinimumSize = 1<<12
  
  ;- - DECLAREs GLOBALs
  Global *Bar.Post_S
  
  Prototype.i Resize(*This, iX.i,iY.i,iWidth.i,iHeight.i) 
  
  ;- - DECLAREs MACROs
  Macro IsBar(_this_)
    Bool(_this_ And (_this_\Type = #PB_GadgetType_ScrollBar Or _this_\Type = #PB_GadgetType_TrackBar Or _this_\Type = #PB_GadgetType_ProgressBar Or _this_\Type = #PB_GadgetType_Splitter))
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
  
  Macro X(_this_) 
    (_this_\X + Bool(_this_\hide[1] Or Not _this_\color\alpha) * _this_\Width) 
  EndMacro
  Macro Y(_this_) 
    (_this_\Y + Bool(_this_\hide[1] Or Not _this_\color\alpha) * _this_\Height) 
  EndMacro
  Macro Width(_this_) 
    (Bool(Not _this_\hide[1] And _this_\color\alpha) * _this_\Width) 
  EndMacro
  Macro Height(_this_) 
    (Bool(Not _this_\hide[1] And _this_\color\alpha) * _this_\Height) 
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
  
  ;-
  ;- - DECLAREs
  Declare.i Draw(*This._s_bar)
  Declare.i GetState(*This._s_bar)
  Declare.i SetState(*This._s_bar, ScrollPos.i)
  Declare.i GetAttribute(*This._s_bar, Attribute.i)
  Declare.i SetAttribute(*This._s_bar, Attribute.i, Value.i)
  Declare.i CallBack(*This._s_bar, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*This._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This._s_bar, iX.i,iY.i,iWidth.i,iHeight.i);, *That._s_bar=#Null)
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
  
  Declare.i Bars(*Scroll._s_scroll, Size.i, Radius.i, Both.b)
  Declare.i Resizes(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i)
  Declare.i Draws(*Scroll._s_scroll, ScrollHeight.i, ScrollWidth.i)
  Declare.i Updates(*Scroll._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
EndDeclareModule

Module Bar
  ;- MODULE
  
  *Bar = AllocateStructure(Post_S)
  *Bar\Type =- 1
  
  Global Colors._s_color
  
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
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min)) * ((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest) : If _this_\Thumb\Len > _this_\Area\Len : _this_\Thumb\Len = _this_\Area\Len : EndIf : If _this_\Vertical : _this_\Height[3] = _this_\Thumb\len : Else : _this_\Width[3] = _this_\Thumb\len : EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Thumb\Pos < _this_\Area\Pos : _this_\Thumb\Pos = _this_\Area\Pos : EndIf : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : Else : _this_\X[3] = _this_\Thumb\Pos : EndIf
  EndMacro
  
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
          LineXY(((X+2)+i)-(Style),((Y+1)+i),((X+2)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Style),(((Y+1)+(Size*2))-i),((X+2)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
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
  EndProcedure
  
  Procedure.i Pos(*This._s_bar, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = \Min + Round((ThumbPos - \Area\Pos) / (\Area\len / (\Max-\Min)), #PB_Round_Nearest)
      ScrollPos = Round(ScrollPos/(\Step + Bool(Not \Step)), #PB_Round_Nearest) * \Step
      If (\Vertical And \Type = #PB_GadgetType_TrackBar)
        ScrollPos = Invert(*This, ScrollPos, \Inverted)
      EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Macro ResizeSplitter(_this_)
    
    If _this_\Vertical
      _this_\x[1] = _this_\x
      _this_\y[1] = _this_\y
      _this_\width[1] = _this_\width
      _this_\height[1] = _this_\Thumb\Pos-_this_\y
      
      _this_\x[2] = _this_\x
      _this_\y[2] = _this_\Thumb\Pos+_this_\Thumb\len
      _this_\width[2] = _this_\width
      _this_\height[2] = _this_\Height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y)
    Else
      _this_\x[1] = _this_\x
      _this_\y[1] = _this_\y
      _this_\width[1] = _this_\Thumb\Pos-_this_\x
      _this_\height[1] = _this_\height
      
      _this_\x[2] = _this_\Thumb\Pos+_this_\Thumb\len
      _this_\y[2] = _this_\y
      _this_\width[2] = _this_\width-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x)
      _this_\height[2] = _this_\height
    EndIf
    
    If _this_\Type[1]
      Resize(_this_\First, _this_\x[1], _this_\y[1], _this_\width[1], _this_\height[1])
    EndIf
    If _this_\Type[2]
      Resize(_this_\Second, _this_\x[2], _this_\y[2], _this_\width[2], _this_\height[2])
    EndIf
    
  EndMacro
  
  Procedure.i DrawProgress(*This._s_bar)
    With *This 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\y,\Width-4,\Thumb\Pos, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X+2,\y+2,\Width-4,\Thumb\Pos-2, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,\height-\Thumb\Pos, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x)-2,\height-4, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,\Thumb\Pos-\x,\height-4, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),0)
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
  
  Procedure.i DrawSplitter(*This._s_bar)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *This
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
          fColor = 0;\Color[3]\Frame[0]
          DrawingMode(#PB_2DDrawing_Outlined) 
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
          Color = 0;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined) 
          If \Vertical ; horisontal
            ClipOutput(\x[3], \y[3]+\height[3]-\Thumb\len, \width[3], \Thumb\len);, $0000FF)
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            UnclipOutput()
          Else
            ClipOutput(\x[3]+\width[3]-\Thumb\len, \y[3], \Thumb\len, \height[3]);, $0000FF)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
            UnclipOutput()
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined) 
          If \Vertical
            ;Box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,Color)
          Else
            ;Box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,Color)
          EndIf
        EndIf
        
        ;         If \Vertical
        ;           ;Box(\x[3], \y[3]+\height[3]-\Thumb\len, \width[3], \Thumb\len, $FF0000)
        ;           Box(X,Y,Width,Height/2,$0000FF)
        ;         Else
        ;           ;Box(\x[3]+\width[3]-\Thumb\len, \y[3], \Thumb\len, \height[3], $FF0000)
        ;           Box(X,Y,Width/2,Height,$0000FF)
        ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i DrawScroll(*This._s_bar)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \x[2]
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Y[2]
      
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
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
          BoxGradient( \Vertical, \X[3], \Y[3], \Width[3], \Height[3], \Color[3]\Fore[State_3], \Color[3]\Back[State_3], \Radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \Color[3]\Frame[State_3] 
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X[3], \Y[3], \Width[3], \Height[3], \Radius, \Radius, \Color[3]\Frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \ButtonLen
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \X[1], \Y[1], \Width[1], \Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], \Radius, \color\alpha)
        EndIf
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], \Radius, \color\alpha)
        EndIf
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        If \Color[2]\Frame[State_2]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Arrow( \X[1]+( \Width[1]-\ArrowSize[1])/2, \Y[1]+( \Height[1]-\ArrowSize[1])/2, \ArrowSize[1], Bool( \Vertical),
               (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \ArrowType[1])
        
        Arrow( \X[2]+( \Width[2]-\ArrowSize[2])/2, \Y[2]+( \Height[2]-\ArrowSize[2])/2, \ArrowSize[2], Bool( \Vertical)+2, 
               (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \ArrowType[2])
        
      EndIf
      
      If \Thumb\len And \Color[3]\Fore[State_3]  ; Draw thumb lines
        If \Focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2-3,9,1, LinesColor)
          Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2,9,1, LinesColor)
          Line( \X[3]+(\Width[3]-8)/2, \Y[3]+\Height[3]/2+3,9,1, LinesColor)
        Else
          Line( \X[3]+\Width[3]/2-3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
          Line( \X[3]+\Width[3]/2, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
          Line( \X[3]+\Width[3]/2+3, \Y[3]+(\Height[3]-8)/2,1,9, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i DrawTrack(*This._s_bar)
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
        Box(\X[3],\Y[3],\Width[3]/2,\Height[3],\Color[3]\Back[\Color[3]\State])
        
        Line(\X[3],\Y[3],1,\Height[3],\Color[3]\Frame[\Color[3]\State])
        Line(\X[3],\Y[3],\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3],\Y[3]+\Height[3]-1,\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3]+\Width[3]/2,\Y[3],\Width[3]/2,\Height[3]/2+1,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3]+\Width[3]/2,\Y[3]+\Height[3]-1,\Width[3]/2,-\Height[3]/2-1,\Color[3]\Frame[\Color[3]\State])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[3],\Y[3],\Width[3],\Height[3]/2,\Color[3]\Back[\Color[3]\State])
        
        Line(\X[3],\Y[3],\Width[3],1,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3],\Y[3],1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3]+\Width[3]-1,\Y[3],1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3],\Y[3]+\Height[3]/2,\Width[3]/2+1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\X[3]+\Width[3]-1,\Y[3]+\Height[3]/2,-\Width[3]/2-1,\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
      EndIf
      
      If \Ticks
        Protected PlotStep = (\width)/(\Max-\Min)
        
        For i=3 To (\Width-PlotStep)/2 
          If Not ((\X+i-3)%PlotStep)
            Box(\X+i, \Y[3]+\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
        For i=\Width To (\Width-PlotStep)/2+3 Step - 1
          If Not ((\X+i-6)%PlotStep)
            Box(\X+i, \Y[3]+\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw(*This._s_bar)
    If *This > 0
      With *This
        If *This>0 And *This\Type And Not \hide And \color\alpha And \Height>0 And \width>0
          Select \Type
            Case #PB_GadgetType_TrackBar : DrawTrack(*This)
            Case #PB_GadgetType_ScrollBar : DrawScroll(*This)
            Case #PB_GadgetType_Splitter : DrawSplitter(*This)
            Case #PB_GadgetType_ProgressBar : DrawProgress(*This)
          EndSelect
          
          If \Type = #PB_GadgetType_Splitter
            If \Type[1]
              Draw(\First)
            EndIf
            If \Type[2]
              Draw(\Second)
            EndIf
          EndIf
        EndIf
        
        ; reset 
        \Change = 0
        \Resize = 0
        *Bar\Type =- 1 
        *Bar\Widget = 0
      EndWith 
    EndIf
  EndProcedure
  
  Procedure.i Draws(*Scroll._s_scroll, ScrollHeight.i, ScrollWidth.i)
    ;     Protected Repaint
    
    With *Scroll
      UnclipOutput()
      If \v And \v\page\len And \v\max<>ScrollHeight And 
         SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollHeight)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      If \h And \h\page\len And \h\max<>ScrollWidth And
         SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollWidth)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \v And Not \v\hide
        Draw(\v)
      EndIf
      If \h And Not \h\hide
        Draw(\h)
      EndIf
      
      
      DrawingMode(#PB_2DDrawing_Outlined)
      ; max coordinate
      Box(\h\x-GetState(\h), \v\y-GetState(\v), \h\Max, \v\Max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
      
      ; area coordinate
      Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
      
      ; scroll coordinate
      Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
      
      ; frame coordinate
      Box(\h\x, \v\y, 
          \h\Page\len + (Bool(Not \v\hide) * \v\width),
          \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
      
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  ;-
  Procedure.i GetState(*This._s_bar)
    ProcedureReturn Invert(*This, *This\Page\Pos, *This\Inverted)
  EndProcedure
  
  Procedure.i SetState(*This._s_bar, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This > 0
        If (\Vertical And \Type = #PB_GadgetType_TrackBar)
          ScrollPos = Invert(*This, ScrollPos, \Inverted)
        EndIf
        
        If ScrollPos < \Min
          ScrollPos = \Min 
        EndIf
        
        If ScrollPos > \Max-\Page\len
          If \Max > \Page\len 
            ScrollPos = \Max-\Page\len
          Else
            ScrollPos = \Min 
          EndIf
        EndIf
        
        If \Page\Pos <> ScrollPos 
          \Thumb\Pos = ThumbPos(*This, ScrollPos)
          
          If \Inverted
            If \Page\Pos > ScrollPos
              \Direction = Invert(*This, ScrollPos, \Inverted)
            Else
              \Direction =- Invert(*This, ScrollPos, \Inverted)
            EndIf
          Else
            If \Page\Pos > ScrollPos
              \Direction =- ScrollPos
            Else
              \Direction = ScrollPos
            EndIf
          EndIf
          
          *Bar\Widget = *This
          *Bar\Type = #PB_EventType_Change
          \Page\Pos = ScrollPos
          \Change = 1
          
          If \Type = #PB_GadgetType_Splitter
            ResizeSplitter(*This)
          EndIf
          
          If \s
            If \Vertical
              \s\y =- \Page\Pos
            Else
              \s\x =- \Page\Pos
            EndIf
          EndIf
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*This._s_bar, Attribute.i)
    Protected Result.i
    
    With *This
      If *This > 0
        Select Attribute
          Case #PB_Bar_Minimum : Result = \Min
          Case #PB_Bar_Maximum : Result = \Max
          Case #PB_Bar_Inverted : Result = \Inverted
          Case #PB_Bar_PageLength : Result = \Page\len
          Case #PB_Bar_NoButtons : Result = \ButtonLen
          Case #PB_Bar_Direction : Result = \Direction
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This._s_bar, Attribute.i, Value.i)
    Protected Resize.i
    
    With *This
      If *This > 0
        If \Type = #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : \ButtonLen[1] = Value
            Case #PB_Splitter_SecondMinimumSize : \ButtonLen[2] = \ButtonLen[3] + Value
          EndSelect 
          
          If \Vertical
            \Area\Pos = \Y+\ButtonLen[1]
            \Area\len = (\Height-\ButtonLen[1]-\ButtonLen[2])
          Else
            \Area\Pos = \X+\ButtonLen[1]
            \Area\len = (\Width-\ButtonLen[1]-\ButtonLen[2])
          EndIf
          
          ProcedureReturn 1
        EndIf
        
        Select Attribute
          Case #PB_Bar_NoButtons : Resize = 1
            \ButtonLen[0] = Value
            \ButtonLen[1] = Value
            \ButtonLen[2] = Value
            
          Case #PB_Bar_Inverted
            \Inverted = Bool(Value)
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
                  \Y[3] = \Thumb\Pos  
                  \Height[3] = \Thumb\len
                Else 
                  \X[3] = \Thumb\Pos 
                  \Width[3] = \Thumb\len
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
                  \Height[3] = \Thumb\len
                Else 
                  \Width[3] = \Thumb\len
                EndIf
              EndIf
              
              If \Step = 0
                \Step = 1
              EndIf
              
              Resize = 1
            EndIf
            
          Case #PB_Bar_PageLength ; 3 -m&l
            If \Page\len <> Value
                If \Max = 0 
                  \Max = Value 
                EndIf
;               If Value > (\Max-\Min)
;                 Value = (\Max-\Min)
;                 \Page\Pos = \Min
;               EndIf
              \Page\len = Value
              
              \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              
              If \Page\len > \Min
                \Thumb\len = ThumbLength(*This)
              Else
                \Thumb\len = \ButtonLen[3]
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
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetColor(*This._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
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
  
  Procedure.i Resize(*This._s_bar, X.i,Y.i,Width.i,Height.i);, *That._s_bar=#Null)
    Protected Lines.i
    
    If *This > 0
      If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And Width=#PB_Ignore And Height=#PB_Ignore)
        *Bar\Widget = *This
        *Bar\Type = #PB_EventType_Resize
      EndIf
      
      With *This
        
        ;         If *This <> *That And *That And *That\hide
        ;           If \Vertical
        ;             If Height=#PB_Ignore 
        ;               Height=(*That\Y+*That\Height)-\Y 
        ;             EndIf
        ;           Else
        ;             If Width=#PB_Ignore
        ;               Width=(*That\X+*That\Width)-\X 
        ;             EndIf
        ;           EndIf
        ;         EndIf
        
        
        ; Set scroll bar coordinate
        If X=#PB_Ignore : X = \X : Else : If \X <> X : \X = X : \Resize | 1<<1 : EndIf : EndIf  
        If Y=#PB_Ignore : Y = \Y : Else : If \Y <> Y : \Y = Y : \Resize | 1<<2 : EndIf : EndIf  
        If Width=#PB_Ignore : Width = \Width : Else : If \Width <> Width : \Width = Width : \Resize | 1<<3 : EndIf : EndIf  
        If Height=#PB_Ignore : Height = \Height : Else : If \Height <> Height : \Height = Height : \Resize | 1<<4 : EndIf : EndIf 
        
        If \Resize
          Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
          \hide[1] = Bool(Not ((\Max-\Min) > \Page\Len))
          
          If \ButtonLen
            \ButtonLen[1] = \ButtonLen
            \ButtonLen[2] = \ButtonLen
          EndIf
          
          If \Vertical
            \Area\Pos = \Y+\ButtonLen[1]
            \Area\len = \Height-(\ButtonLen[1]+\ButtonLen[2])
          Else
            \Area\Pos = \X+\ButtonLen[1]
            \Area\len = \width-(\ButtonLen[1]+\ButtonLen[2])
          EndIf
          
          If Bool(\Resize & (1<<4 | 1<<3))
            If Not \hide And \Area\len
              \Thumb\len = ThumbLength(*This)
              
              If (\Area\len > \ButtonLen)
                If \ButtonLen
                  If (\Thumb\len < \ButtonLen)
                    \Area\len = Round(\Area\len - (\ButtonLen-\Thumb\len), #PB_Round_Nearest)
                    \Thumb\len = \ButtonLen 
                  EndIf
                Else
                  If (\Thumb\len < \ButtonLen[3]) And (\Type <> #PB_GadgetType_ProgressBar)
                    \Area\len = Round(\Area\len - (\ButtonLen[3]-\Thumb\len), #PB_Round_Nearest)
                    \Thumb\len = \ButtonLen[3]
                  EndIf
                EndIf
              Else
                \Thumb\len = \Area\len 
              EndIf
              
              If \Area\len > 0
                If IsStop(*This) And (\Type <> #PB_GadgetType_TrackBar)
                  SetState(*This, \Max)
                EndIf
                
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              EndIf
            EndIf
          EndIf
          
          If \Vertical
            If \ButtonLen
              \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \ButtonLen[1]                       ; Top button coordinate on scroll bar
              \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \ButtonLen[2] : \Y[2] = (\Area\Pos+\Area\len)   ; Bottom button coordinate on scroll bar
            EndIf
            \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len                   ; Thumb coordinate on scroll bar
          Else
            If \ButtonLen
              \X[1] = X : \Y[1] = Y + Lines : \Height[1] = Height - Lines : \Width[1] = \ButtonLen[1]                      ; Left button coordinate on scroll bar
              \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \ButtonLen[2] : \X[2] = (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
            EndIf
            \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len                  ; Thumb coordinate on scroll bar
          EndIf
          
          If (\Type = #PB_GadgetType_Splitter)
            ResizeSplitter(*This)
          EndIf
        EndIf
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Updates(*Scroll._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
      \v\Hide = Bar::Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\Y + Bool(\h\Hide) * \h\Height) - \v\Y) ; #PB_Ignore, \h) 
      \h\Hide = Bar::Resize(\h, #PB_Ignore, #PB_Ignore, (\v\X + Bool(\v\Hide) * \v\Width) - \h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\Page\Pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\Page\Pos = vPos : \h\Width = iWidth+\v\Width : EndIf
      If \h\hide : \h\Page\Pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\Page\Pos = hPos : \v\Height = iHeight+\h\Height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i)
    
    With *Scroll
      ;     If Width=#PB_Ignore : Width = \v\X : Else : Width+x-\v\Width : EndIf
      ;       If Height=#PB_Ignore : Height = \h\Y : Else : Height+y-\h\Height : EndIf
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, (\h\Y+Bool(\h\Hide) * \h\Height)-\v\y)
      ;       SetAttribute(\h, #PB_Bar_PageLength, (\v\X+Bool(\v\Hide) * \v\width)-\h\x)
      ;       
      ;       \v\Hide = Resize(\v, Width, Y, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y)) 
      ;       \h\Hide = Resize(\h, X, Height, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore) 
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, (\h\Y+Bool(\h\Hide) * \h\Height)-\v\y)
      ;       SetAttribute(\h, #PB_Bar_PageLength, (\v\X+Bool(\v\Hide) * \v\width)-\h\x)
      ;       
      ;       ; 
      ;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore)
      ;       
      ;       If Not \v\Hide 
      ;         Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      ;       EndIf
      ;       If Not \h\Hide 
      ;         Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      ;       EndIf
      ;       
      ;      Debug ""+Width +" "+ \h\Page\len
      ;        \Width[2] = x(\v)-\h\x ; \h\Page\len ;
      ;     \Height[2] = y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
      ;     ProcedureReturn 1
      
      If y=#PB_Ignore : y = \v\Y : EndIf
      If x=#PB_Ignore : x = \h\X : EndIf
      If Width=#PB_Ignore : Width = \v\X-\h\X+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\Y-\v\Y+\h\height : EndIf
      
;       \v\Page\len = Height - Bool(Not \h\hide) * \h\height
;       \h\Page\len = Width - Bool(Not \v\hide) * \v\width
;       
;       \v\Hide = Resize(\v, Width+x-\v\Width, y, #PB_Ignore, \v\Page\len)
;       \h\Hide = Resize(\h, x, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
;       
;       \v\Page\len = Height - Bool(Not \h\hide) * \h\height
;       \h\Page\len = Width - Bool(Not \v\hide) * \v\width
;       
;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len + Bool(\v\Radius And Not \h\Hide And Not \v\Hide)*4)
;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len + Bool(\h\Radius And Not \v\Hide And Not \h\hide)*4, #PB_Ignore)
;       
;       \Width[2] = \h\Page\len ;  x(\v)-\h\x ; 
;       \Height[2] =\v\Page\len ;  y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
;       ProcedureReturn 1
      
      
      ;       If \h\Max < \width ; Width-Bool(Not \v\Hide) * \v\width
      ;         \h\Max = \width ; Width-Bool(Not \v\Hide) * \v\width
      ;       EndIf
      ;       If \v\Max < Height-Bool(Not \h\Hide) * \h\height
      ;         \v\Max = Height-Bool(Not \h\Hide) * \h\height
      ;       EndIf
      
      ;       ; Debug ""+Width +" "+ Str(\v\X-\h\X+\v\width)
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, Height - Bool(Not \h\hide) * \h\height) 
      ;       SetAttribute(\h, #PB_Bar_PageLength, Width - Bool(Not \v\hide) * \v\width)  
      ;       
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, \v\Page\len)
      ;       \h\Hide = Resize(\h, x, y+\v\Page\len, \h\Page\len, #PB_Ignore)
      ;       
      ;       SetAttribute(\v, #PB_Bar_PageLength, Height - Bool(Not \h\hide) * \h\height)
      ;       SetAttribute(\h, #PB_Bar_PageLength, Width - Bool(Not \v\hide) * \v\width)
      ;       
      ;       \v\Hide = Resize(\v, x+\h\Page\len, #PB_Ignore, #PB_Ignore, \v\Page\len + Bool(\v\Radius And Not \h\Hide)*4)
      ;       \h\Hide = Resize(\h, #PB_Ignore, y+\v\Page\len, \h\Page\len + Bool(\h\Radius And Not \v\Hide)*4, #PB_Ignore)
      ;       
      ;       \Width[2] = \h\Page\len ;  x(\v)-\h\x ; 
      ;       \Height[2] =\v\Page\len ;  y(\h)-\v\y  ; \v\Page\len ;(\h\Y + Bool(Not \h\Hide) * \h\Height) - \v\y;
      ;       ProcedureReturn 1
      
      ;       If Width=#PB_Ignore 
      ;         Width = \v\X+\v\Width
      ;       EndIf
      ;       If Height=#PB_Ignore 
      ;         Height = \h\Y+\h\Height
      ;       EndIf
      
      SetAttribute(\v, #PB_Bar_PageLength, Height-Bool(Not \h\Hide) * \h\height)
      SetAttribute(\h, #PB_Bar_PageLength, Width-Bool(Not \v\Hide) * \v\width)
      
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, \v\Page\len)
      ;      \h\Hide = Resize(\h, x, y+\v\Page\len, \h\Page\len, #PB_Ignore)
      ;       \v\Hide = Resize(\v, x+\h\Page\Len, y, #PB_Ignore, (\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y)
      ;       \h\Hide = Resize(\h, x, y+\v\Page\len, (\v\X+Bool(\v\Hide) * \v\width) - \h\X, #PB_Ignore)
      
      \v\Hide = Resize(\v, Width+x-\v\Width, Y, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, X, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
      ;       \v\Hide = Resize(\v, Width+x-\v\Width, Y, #PB_Ignore, (\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y)
      ;       \h\Hide = Resize(\h, X, Height+y-\h\Height, (\v\X+Bool(\v\Hide) * \v\width) - \h\X, #PB_Ignore)
      
      SetAttribute(\v, #PB_Bar_PageLength, Height-Bool(Not \h\Hide) * \h\height)
      SetAttribute(\h, #PB_Bar_PageLength, Width-Bool(Not \v\Hide) * \v\width)
      
      ;        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y) + Bool(\v\Radius And Not \h\Hide)*4)
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X) + Bool(\h\Radius And Not \v\Hide)*4, #PB_Ignore)
      ;      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X), #PB_Ignore)
      
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len, #PB_Ignore)
      
      ;       \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(\h\hide) * ((\h\Y+\h\Height)-\v\Y))
      ;       \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, Bool(\v\hide) * ((\v\X+\v\Width)-\h\X), #PB_Ignore)
      
      If Not \v\Hide 
        \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not \h\Hide 
        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      EndIf
      ;;; Debug \v\Page\len
      
      ;       SetAttribute(\v, #PB_Bar_PageLength, ((\h\Y+Bool(\h\Hide) * \h\Height) - \v\Y))
      ;       SetAttribute(\h, #PB_Bar_PageLength, ((\v\X+Bool(\v\Hide) * \v\width) - \h\X))
      
      
      ProcedureReturn 1
    EndWith
  EndProcedure
  
  Procedure.i Events(*This._s_bar, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    If *This > 0
      
      *Bar\Widget = *This
      *Bar\Type = EventType
      
      With *This
        Select EventType
          Case #PB_EventType_Focus : \Focus = 1 : Repaint = 1
          Case #PB_EventType_LostFocus : \Focus = 0 : Repaint = 1
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0
          Case #PB_EventType_LeftDoubleClick 
            If \Type = #PB_GadgetType_ScrollBar
              Select at
                Case - 1
                  If \Vertical
                    Repaint = (MouseScreenY-\Thumb\len/2)
                  Else
                    Repaint = (MouseScreenX-\Thumb\len/2)
                  EndIf
                  
                  Repaint = SetState(*This, Pos(*This, Repaint))
              EndSelect
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            If \Type = #PB_GadgetType_ScrollBar
              Select at
                Case 1 : Repaint = SetState(*This, (\Page\Pos - \Step)) ; Up button
                Case 2 : Repaint = SetState(*This, (\Page\Pos + \Step)) ; Down button
              EndSelect
            EndIf
            
            Select at
              Case 3                                                  ; Thumb button
                If \Vertical
                  delta = MouseScreenY - \Thumb\Pos
                Else
                  delta = MouseScreenX - \Thumb\Pos
                EndIf
            EndSelect
            
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = (MouseScreenY-delta)
              Else
                Repaint = (MouseScreenX-delta)
              EndIf
              
              Repaint = SetState(*This, Pos(*This, Repaint))
            Else
              If \Type = #PB_GadgetType_Splitter And at <> 3
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
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
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If at > 0
              \Color[at]\State = 0
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            If ((at = 1 And IsStart(*This)) Or (at = 2 And IsStop(*This)))
              \Color[at]\State = 0
              at = 0
            EndIf
            
            If at>0
              \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              
              If \Type = #PB_GadgetType_Splitter And at = 3
                If Not \Vertical
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
                Else
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_UpDown)
                EndIf
              EndIf
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If Not cursor
                cursor = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
              
            EndIf
        EndSelect
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This._s_bar, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected repaint.i
    Static Last.i, Down.i, *Scroll._s_bar, *Last._s_bar, mouseB.i, mouseat.i, Buttons
    
    With *This
      Select EventType 
        Case #PB_EventType_LeftButtonDown, 
             #PB_EventType_MiddleButtonDown, 
             #PB_EventType_RightButtonDown
          Buttons = 1
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonUp
          Buttons = 0
      EndSelect
      
      If *This > 0 And Not \hide And \color\alpha
        If Not MouseScreenX
          MouseScreenX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
        EndIf
        If Not MouseScreenY
          MouseScreenY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
        EndIf
        
        ; get at point buttons
        If mouseB Or Buttons
        ElseIf (MouseScreenX>=\X And MouseScreenX<\X+\Width And MouseScreenY>\Y And MouseScreenY=<\Y+\Height) 
          If (MouseScreenX>\X[1] And MouseScreenX=<\X[1]+\Width[1] And  MouseScreenY>\Y[1] And MouseScreenY=<\Y[1]+\Height[1])
            \at = 1
          ElseIf (MouseScreenX>\X[3] And MouseScreenX=<\X[3]+\Width[3] And MouseScreenY>\Y[3] And MouseScreenY=<\Y[3]+\Height[3])
            \at = 3
          ElseIf (MouseScreenX>\X[2] And MouseScreenX=<\X[2]+\Width[2] And MouseScreenY>\Y[2] And MouseScreenY=<\Y[2]+\Height[2])
            \at = 2
          Else
            \at =- 1
          EndIf 
          
          Select EventType 
            Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
            Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = *This
        Else
          \at = 0
          
          Select EventType 
            Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
              EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = 0
        EndIf
        
        If *Scroll <> mouseat And 
           *This = mouseat
          *Last = *Scroll
          *Scroll = mouseat
        EndIf
        
        Select EventType 
          Case #PB_EventType_Focus
            If \at       
              *Bar\Active = *This
              repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
            EndIf
            
          Case #PB_EventType_LostFocus 
            If *Bar\Active
              *Bar\Active = 0 
              repaint | Events(*This, - 1, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
            EndIf
            
        EndSelect
        
        If *Scroll = *This
          If Last <> \at
            ;
            ; Debug ""+Last +" "+ *This\at +" "+ *This +" "+ *Last
            If Last > 0 Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, Last, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            If Not \at Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY) : *Last = 0
            EndIf
            
            If Not last ; Or (Last =- 1 And \at = 2 And *Last)
              repaint | Events(*This, - 1, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
            If \at > 0
              repaint | Events(*This, \at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
            
            Last = \at
          EndIf
          
          Select EventType 
            Case #PB_EventType_MouseWheel
              Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta) ; bug in mac os
              
              If \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY, -WheelDelta)
              ElseIf *Bar\Active
                repaint | Events(*Bar\Active, - 1, EventType, MouseScreenX, MouseScreenY, WheelDelta)
              EndIf
              
            Case #PB_EventType_LeftButtonDown : mouseB = 1
              If \at
                If *Bar\Active <> *This
                  If *Bar\Active
                    repaint | Events(*Bar\Active, \at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
                  EndIf
                  repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
                  *Bar\Active = *This
                EndIf
                
                Down = \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
              
            Case #PB_EventType_LeftButtonUp : mouseB = 0
              If Down
                repaint | Events(*This, Down, EventType, MouseScreenX, MouseScreenY)
                Down = 0
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \at
                repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              EndIf
          EndSelect
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  ;-
  Procedure.i Bar(Type.i, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7)
    Protected *This._s_bar = AllocateStructure(_s_bar)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = Type
      \Radius = Radius
      \ButtonLen[3] = SliderLen ; min thumb size
      \Ticks = Bool(Flag&#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB__s_barmooth)
      \Vertical = Bool(Flag&#PB_Bar_Vertical)
      
      \ArrowSize[1] = 4
      \ArrowSize[2] = 4
      \ArrowType[1] =- 1 ; -1 0 1
      \ArrowType[2] =- 1 ; -1 0 1
      
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
      
      If Not Bool(Flag&#PB_Bar_NoButtons)
        If \Vertical
          If width < 21
            \ButtonLen = width - 1
          Else
            \ButtonLen = 17
          EndIf
        Else
          If height < 21
            \ButtonLen = height - 1
          Else
            \ButtonLen = 17
          EndIf
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    ProcedureReturn Bar(#PB_GadgetType_ScrollBar, X,Y,Width,Height, Min, Max, PageLength, Flag, Radius)
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    ;Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_bar_smooth
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Bar_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_ProgressBar, X,Y,Width,Height, Min, Max, 0, Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Bar_Vertical|#PB_Bar_Inverted)
    ProcedureReturn Bar(#PB_GadgetType_TrackBar, X,Y,Width,Height, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected *Bar._s_bar
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Bar_Vertical
    Protected *This._s_bar, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    *This = Bar(0, X,Y,Width,Height, 0, Max, 0, Vertical|#PB_Bar_NoButtons, 0, 7)
    
    With *This
      \First = First
      \Second = Second
      
      \Type = #PB_GadgetType_Splitter
      
      *Bar = \First 
      ; thisis bar
      If Not IsGadget(First) And IsBar(*Bar)
        \Type[1] = *Bar\Type
      EndIf
      
      *Bar = \Second 
      ; thisis bar
      If Not IsGadget(Second) And IsBar(*Bar)
        \Type[2] = *Bar\Type
      EndIf
      
      If \Vertical
        SetState(*This, \height/2-1)
      Else
        SetState(*This, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Bars(*Scroll._s_scroll, Size.i, Radius.i, Both.b)
    With *Scroll     
      \v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_Bar_Vertical, Radius)
      \v\hide = \v\hide[1]
      \v\s = *Scroll
      
      If Both
        \h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
        \h\hide = \h\hide[1]
      Else
        \h._s_bar = AllocateStructure(_s_bar)
        \h\hide = 1
      EndIf
      \h\s = *Scroll
    EndWith
    
    ProcedureReturn *Scroll
  EndProcedure
EndModule

;-
Macro GetActiveWidget()
  Bar::*Bar\Active
EndMacro

Macro EventWidget()
  Bar::*Bar\Widget
EndMacro

Macro WidgetEventType()
  Bar::*Bar\Type
EndMacro


;-
DeclareModule Procedures
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  Declare.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
  Declare.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Thickness.i = 1, Length.i = 1)
  Declare.s Font_GetNameFromGadgetID(GadgetID)
  Declare.i GetCurrentDpi()
  Declare.i IsHideGadget(Gadget)
EndDeclareModule 

Module Procedures
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      ImportC ""
        pango_context_list_families(*context, *families, *n_families); PangoFontFamily
        pango_context_get_font_description(*context)
        pango_font_description_get_family(*desc)
        pango_font_family_get_name(*family)
        pango_font_family_is_monospace(*family)
        pango_font_description_from_string(str.p-utf8)
        
        ;  gtk_widget_modify_font_(GadgetID, pango_font_description_from_string("Monospace bold 10")) ; gtk2
				;; for reset use ...
        ;  gtk_widget_modify_font_(GadgetID, #Null)
        
        ;  gtk_widget_override_font(GadgetID, pango_font_description_from_string("Monospace bold 10")) ; gtk3
		    ;; for reset use ...
        ;  gtk_widget_override_font(GadgetID, #Null)

;       EndImport
;       ImportC ""
        g_object_get_property(*object.GObject, property.p-utf8, *gval)
        
        
        gtk__s_widgetet_visible(*widget.GtkWidget, visible)
        gtk_widget_get_visible(*widget.GtkWidget)
      EndImport
  CompilerEndSelect
  
  Procedure.i IsHideGadget(Gadget)
    Protected.i Ret
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        ret = gtk_widget_get_visible(GadgetID(Gadget))
      CompilerCase #PB_OS_MacOS
        ret = CocoaMessage(0, GadgetID(Gadget), "isHidden")
    CompilerEndSelect
    
    ProcedureReturn Ret
  EndProcedure

  
  #G_TYPE_INT  = 24
  
  Procedure.i GetCurrentDpi()
    Protected.i Ret
    ; "Current dpi value: " + Str(GetCurrentDpi()/1024)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected gVal.GValue
        
        g_value_init_(@gval, #G_TYPE_INT)
        g_object_get_property(gtk_settings_get_default_(), "gtk-xft-dpi", @gval)
        Ret = g_value_get_int_(@gval)
        g_value_unset_(@gval)
    CompilerEndSelect
    
    ProcedureReturn Ret
  EndProcedure

  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
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
  
  Procedure.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ;Value = (Bool(Grid) * (Round((Value/Grid), #PB_Round_Nearest) * Grid) + Bool(Not Grid) * Value)
    Value = (Round((Value/((Grid) + Bool(Not (Grid)))), #PB_Round_Nearest) * (Grid))
    If Value>Max : Value=Max : EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.s Font_GetNameFromGadgetID(GadgetID)
    ; http://www.chabba.de/
    Protected Name.s
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected Description.i, Family.i
        
        Description = pango_context_get_font_description(gtk_widget_get_pango_context_(GadgetID))
        Family = pango_font_description_get_family(Description)
        
        If Family
          Name = PeekS(Family, -1, #PB_UTF8)
        EndIf
    CompilerEndSelect
    
    ProcedureReturn Name
  EndProcedure
  
  Procedure.i Font_IsMonospace(FontName.s)
    Protected IsMonospace = #False
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected   PangoContext = gdk_pango_context_get_()
        Protected.i PangoFamilies, PangoFamily, pFamilyName
        Protected.i pPangoFamily
        Protected.i I, nFamilies
        
        pango_context_list_families(PangoContext, @PangoFamilies, @nFamilies)
        pPangoFamily= PangoFamilies
        For I= 1 To nFamilies
          PangoFamily= PeekI(pPangoFamily);                    not sure about 'long', but yet no error
          If PangoFamily
            pFamilyName= pango_font_family_get_name(PangoFamily)
            If pFamilyName
              If PeekS(pFamilyName, -1, #PB_UTF8) = FontName;  compare names
                IsMonospace= pango_font_family_is_monospace(PangoFamily)
                Break
              EndIf
            EndIf
          EndIf
          pPangoFamily+ SizeOf(PangoFamily)
        Next I
        g_free_(PangoFamilies)
    CompilerEndSelect
    
    ProcedureReturn IsMonospace
  EndProcedure


EndModule 

UseModule Procedures
;-
DeclareModule Text
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro CountItems(_this_)
    _this_\CountItems
  EndMacro
  
  Macro ClearItems(_this_) 
    _this_\CountItems = 0
    _this_\Text\Change = 1 
    If _this_\Text\Editable
      _this_\Text\String = #LF$
    EndIf
    If Not _this_\Repaint : _this_\Repaint = 1
      PostEvent(#PB_Event_Gadget, _this_\Canvas\Window, _this_\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
  EndMacro
  
  Macro RemoveItem(_this_, _item_) 
    _this_\CountItems - 1
    _this_\Text\Change = 1
    If _this_\CountItems =- 1 
      _this_\CountItems = 0 
      _this_\Text\String = #LF$
      If Not _this_\Repaint : _this_\Repaint = 1
        PostEvent(#PB_Event_Gadget, _this_\Canvas\Window, _this_\Canvas\Gadget, #PB_EventType_Repaint)
      EndIf
    Else
      _this_\Text\String = RemoveString(_this_\Text\String, StringField(_this_\Text\String, _item_+1, #LF$) + #LF$)
    EndIf
  EndMacro
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*This_s_widget)
  Declare.s Make(*This._s_widget, Text.s)
  Declare.i MultiLine(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i SetText(*This._s_widget, Text.s)
  Declare.i GetFont(*This._s_widget)
  Declare.i SetFont(*This._s_widget, FontID.i)
  Declare.i AddLine(*This._s_widget, Line.i, Text.s)
  Declare.i GetColor(*This._s_widget, ColorType.i, State.i=0)
  Declare.i SetColor(*This._s_widget, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
  Declare.i CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (*This._s_widget, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  
  Declare.i Caret(*This._s_widget, Line.i = 0)
  Declare.i Remove(*This._s_widget)
  Declare.i Change(*This._s_widget, Pos.i, Len.i)
  Declare.i Insert(*This._s_widget, Chr.s)
  Declare.i Cut(*This._s_widget) 
  
  Declare.i ToUp(*This._s_widget)
  Declare.i ToDown(*This._s_widget)
  Declare.i ToLeft(*This._s_widget)
  Declare.i ToRight(*This._s_widget)
  Declare.i ToBack(*This._s_widget)
  Declare.i ToReturn(*This._s_widget)
  Declare.i ToInput(*This._s_widget)
  Declare.i ToDelete(*This._s_widget)
  Declare.i SelReset(*This._s_widget)
  Declare.i SelLimits(*This._s_widget)
  
  Declare.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
EndDeclareModule

Module Text
  ;- MACROS
  ;- PROCEDUREs
  Procedure.i Remove(*This._s_widget)
    With *This
      If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
      \Text\Len = Len(\Text\String.s)
    EndWith
  EndProcedure
  
  Procedure.i CaretPos(mouse_x_minus_string_x.i, string.s, string_len.i)
    Protected result.i =- 1, i.i, x.i, distance.f, min_distance.f = Infinity()
    
    For i = 0 To string_len : x = TextWidth(Left(String.s, i))
      distance = (mouse_x_minus_string_x-x)*(mouse_x_minus_string_x-x)
      
      If min_distance > distance 
        min_distance = distance
        result = i
      EndIf
    Next
    
    ProcedureReturn result    
  EndProcedure
  
  Procedure.i CaretLen(mouse_x_minus_string_x.i, string.s, string_len.i)
    Protected result.i =- 1, i.i, x.i, distance.f, min_distance.f = Infinity()
    
    For i = 0 To string_len : x = TextWidth(Left(String.s, i))
      distance = (mouse_x_minus_string_x-x)*(mouse_x_minus_string_x-x)
      
      If min_distance > distance 
        min_distance = distance
        result = x
      EndIf
    Next
    
    ProcedureReturn result    
  EndProcedure
  
  Procedure.i Caret(*This._s_widget, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          X = (\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len; + Len(" ")
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s;+" "
          If Not FontID : FontID = \Text\FontID : EndIf
          
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
            
            SelectionLen=Bool(Not \Flag\FullSelection)*7
            
            ; Длина переноса строки
            PushListPosition(\Items())
            If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
              Item.i =- 1 
            Else
              Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            EndIf
            
            If LastLine <> \Index[1] Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
                 \Index[2] > \Index[1] Or ; Если выделяем снизу вверх
                 (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
                  PreviousElement(*This\Items()))                                    ; то выбираем предыдущую линию
                
                If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                  \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                EndIf 
                
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              LastItem = Item
              LastLine = \Index[1]
            EndIf
            PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Change(*This._s_widget, Pos.i, Len.i)
    With *This
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
        \Text[1]\String.s = Left(\Text\String.s, \Text[1]\Len) 
        \Text[2]\Pos = \Text[1]\Len
        \Text[1]\Change = #True
      EndIf
      
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
        \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
        \Text[3]\String.s = Right(\Text\String.s, \Text[3]\Len) 
        \Text[3]\Change = #True
      EndIf
      
      If \Text[1]\Len = \Text[3]\Pos
        \Text[2]\Len = 0
        \Text[2]\String.s = ""
      Else
        \Text[2]\Change = #True 
        \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
        \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text[2]\Pos, \Text[2]\Len) 
      EndIf
       ;Debug "chang "+\Text[1]\String.s;Left(\Text\String.s, pos)
      
    EndWith
  EndProcedure
  
  Procedure.i SelReset(*This._s_widget)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i SelSet(*This._s_widget)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        \Items()\Text[2]\Len = \Items()\Text\Len 
        \Items()\Text[2]\Width[2] = \Flag\FullSelection
        \Items()\Text[1]\String = ""
        \Items()\Text[2]\String = "" 
        \Items()\Text[3]\String = ""
        \Items()\Text[2]\Width = 0 
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i SelLimits(*This._s_widget)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  
  ;-
  Procedure _Move(*This._s_widget, Width)
    Protected Left,Right
    
    With *This
      Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Text\Caret))
      ;If Right 
      Left = (Width + Right)
      ;If Not \Scroll\h\Buttons ; \Scroll\X <> Right
      
      If \Scroll\X < Right
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Text\Caret = \Text\Caret[1] And Not \Canvas\Input) ; Back string
        \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
        If \Scroll\X>0
          \Scroll\X=0
        EndIf
      EndIf
      ;EndIf
      
      Debug " "+\Width[1] +" "+ Width +" "+ Left +" "+ Right + " " + \Scroll\X
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure __Move(*This._s_widget, Width)
    Protected Left,Right
    
    With *This
      Right = TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Text\Caret))
      ;If Right 
      Left = (Width - Right)
      ;If Not \Scroll\h\Buttons ; \Scroll\X <> Right
      
      If \Scroll\X > Right
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Text\Caret = \Text\Caret[1] And Not \Canvas\Input) ; Back string
        \Scroll\X = (Width-\Items()\Text[3]\Width) - Right
        If \Scroll\X>0
          \Scroll\X=0
        EndIf
      EndIf
      ;EndIf
      
      ; Debug " "+\Width[1] +" "+ Width +" "+ Left +" "+ Right + " " + \Scroll\X
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure Move(*This._s_widget, Width)
    Protected Left,Right
    
    With *This
      Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Text\Caret))
      Left = (Width + Right)
      
      If \Scroll\X < Right
       ; Bar::SetState(\Scroll\h, -Right)
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
       ; Bar::SetState(\Scroll\h, -Left) 
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Canvas\Input = 65535 ) : \Canvas\Input = 0
        \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
        If \Scroll\X>0 : \Scroll\X=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.s Make(*This._s_widget, Text.s)
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
  
  Procedure.i Paste(*This._s_widget, Chr.s, Count.i=0)
    Protected Repaint, String.s
    
    With *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        ;           PushListPosition(\Items())
        If SelectElement(\Items(), \Index[2])
          String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Caret = \Items()\Text[1]\Len 
        EndIf   
        
        If SelectElement(\Items(), \Index[1])
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        ;           PopListPosition(\Items())
        
        If Count
          \Index[2] + Count
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\String.s = String.s
        \Text\Len = Len(\Text\String.s)
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      ;         SelectElement(\Items(), \index[2]) 
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Cut(*This._s_widget)
    ProcedureReturn Paste(*This._s_widget, "")
  EndProcedure
  
  Procedure.i Insert(*This._s_widget, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text::Make(*This, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Paste(*This, Chr.s, Count)
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          String.s = InsertString(\Text\String.s, Chr.s, \Items()\Text\Pos+\Text\Caret + 1)
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\Caret[1] = \Text\Caret 
          \Text\String.s = String.s
          \Text\Len = Len(\Text\String.s)
          \Text\Change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\Items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;- - KeyBoard
  Procedure.i ToUp(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDown(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2]) 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToLeft(*This._s_widget) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
          Repaint =- 1
        EndIf
      ElseIf \Text\Caret[1] > 0
        If \Text\Caret > \Items()\text\len
          \Text\Caret = \Items()\text\len
        EndIf
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      ElseIf Not Repaint And ToUp(*This._s_widget)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This._s_widget) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[2] = \Index[1] And 
               \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
          Repaint =- 1
        EndIf
      ElseIf \Text\Caret[1] < \Items()\Text\Len 
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1]
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      ElseIf Not Repaint And ToDown(*This)
        \Text\Caret[1] = 0
        \Text\Caret = \Text\Caret[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToInput(*This._s_widget)
    Protected Repaint
    
    With *This
      If \Canvas\Input
        Repaint = Insert(*This, Chr(\Canvas\Input))
        
        If Not Repaint
          \Default = *This
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This._s_widget) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If Not Paste(*This, #LF$)
        String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + #LF$ +
                   \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
        
        \Text\Caret = 0
        \Index[2] + 1
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\String.s = String.s
        \Text\Len = Len(\Text\String.s)
        \Text\Change =- 1 ; - 1 post event change widget
      EndIf
      
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToBack(*This._s_widget)
    Protected Repaint, String.s, Cut.i
    ;ProcedureReturn Text::ToReturn(*This,"")
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ;  ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This 
      \Canvas\Input = 65535
      
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len
          \Items()\Text\Change = 1
          
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Text\Caret[1] - 1) + \Items()\Text[3]\String.s
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          \Items()\Text\Change = 1
          
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s,  \Items()\Text\Pos + \Text\Caret + 1)
          \Text\Change =- 1 ; - 1 post event change widget
          \Text\Caret - 1 
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            ToUp(*This)
            
            \Text\Caret = \Items()\Text\Len 
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDelete(*This._s_widget)
    Protected Repaint, String.s
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len
          \Items()\Text\Change = 1
          
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          \Items()\Text\Change = 1
          
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret) + Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\CountItems-1) ; ListSize(\Items()) - 1
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  Procedure.s Wrap (*This._s_widget, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
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
  
  ;-
  Procedure AddLine(*This._s_widget, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\CountItems))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\CountItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\CountItems)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\CountItems)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\CountItems)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-_this_\Items()\Text\Width)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+_this_\Items()\Text\Width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\Text\Width+_this_\Image\Width)/2)+Indent
            Image_X=(Width-_this_\Items()\Text\Width-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-_this_\Items()\Text\Width)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-_this_\Items()\Text\Width)
        ElseIf _this_\Text\Align\Horizontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        Else
          Text_X=_this_\sci\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X[2]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[2]+_this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\CountItems<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\CountItems<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    With *This
      \CountItems = ListSize(\Items())
      
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Not Defined(Bar, #PB_Module)
          \scroll\width[2] = \width[2]
          \scroll\height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \scroll\width[2]
      height = \scroll\height[2]
  
      \Items()\Index[1] =- 1
      \Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default color state           
      \Items()\Color\State = 1
      
      ; Update line pos in the text
      \Items()\Text\Len = Len(String.s)
      \Items()\Text\Pos = \Text\Pos
      \Text\Pos + \Items()\Text\Len + 1 ; Len(#LF$)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
      
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    ;     If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          \Items() = AllocateStructure(_s_rows)
        
          If Item = 0
            First = *Item
          EndIf
          
          If subLevel
            If sublevel>Item
              sublevel=Item
            EndIf
            
            PushListPosition(\Items())
            While PreviousElement(\Items()) 
              If subLevel = \Items()\subLevel
                adress = \Items()\handle
                Break
              ElseIf subLevel > \Items()\subLevel
                adress = @\Items()
                Break
              EndIf
            Wend 
            If adress
              ChangeCurrentElement(\Items(), adress)
              If subLevel > \Items()\subLevel
                sublevel = \Items()\sublevel + 1
                \Items()\handle[1] = *Item
                \Items()\childrens + 1
                \Items()\collapsed = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            \Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          \Items()\handle = adress
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          \Items()\focus =- 1
          \Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\handle = ImageID(Image)
            \Items()\Image\handle[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          AddLine(*This, Item.i, Text.s)
          \Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
          ;           \Items()\Color = Colors
          ;           \Items()\Color\State = 1
          ;           \Items()\Color\Fore[0] = 0 
          ;           \Items()\Color\Fore[1] = 0
          ;           \Items()\Color\Fore[2] = 0
          
          If Item = 0
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure.i MultiLine(*This._s_widget)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[2]-\Text\X*2
        Height = \Width[2]-\Text\y*2
      Else
        width = \scroll\width[2]-\Text\X*2-\sci\margin\width
        height = \scroll\height[2]
      EndIf
      
     ; Debug ""+\scroll\width[2] +" "+ \Width[0] +" "+ \Width[1] +" "+ \Width[2] +" "+ Width
      ;Debug ""+\scroll\width[2] +" "+ \scroll\height[2] +" "+ \Width[2] +" "+ \Height[2] +" "+ Width +" "+ Height
      
      If \Text\MultiLine > 0
        
        String.s = Wrap(*This, \Text\String.s, Width, \Text\MultiLine)
;         \CountItems = CountString(String.s, #LF$)
;         
;         For IT = 1 To \CountItems
;           
;           Debug StringField(String.s, IT, #LF$)
;           
;         Next
    
      Else
        String.s = \Text\String.s
      EndIf
      
      \Text\Pos = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        If \Text\Editable And \Text\Change=-1 
          ; Посылаем сообщение об изменении содержимого 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
        EndIf
        
        \Text\String.s[2] = String.s
        \CountItems = CountString(String.s, #LF$)
        ;; \Text\Len = Len(String.s)
        
        ; Scroll width reset 
        \Scroll\Width = 0;\Text\X
        
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Move(*This, Width)
        EndIf
        
        If \CountItems[1] <> \CountItems Or \Text\Vertical
          \CountItems[1] = \CountItems
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \CountItems To 1 Step - 1
              
;               If AddElement(\Items())
;                 String = StringField(\Text\String.s[2], IT, #LF$)
;                 
;                 \Items()\Focus =- 1
;                 \Items()\Index[1] =- 1
;                 
;                 If \Type = #PB_GadgetType_Button
;                   \Items()\Text\Width = TextWidth(RTrim(String))
;                 Else
;                   \Items()\Text\Width = TextWidth(String)
;                 EndIf
;                 
;                 If \Text\Align\Right
;                   Text_X=(Width-\Items()\Text\Width) 
;                 ElseIf \Text\Align\Horizontal
;                   Text_X=(Width-\Items()\Text\Width-Bool(\Items()\Text\Width % 2))/2 
;                 EndIf
;                 
;                 \Items()\x = \X[2]+\Text\Y+\Scroll\Height+Text_Y
;                 \Items()\y = \Y[2]+\Text\X+Text_X
;                 \Items()\Width = \Text\Height
;                 \Items()\Height = Width
;                 \Items()\Index = ListIndex(\Items())
;                 
;                 \Items()\Text\Editable = \Text\Editable 
;                 \Items()\Text\Vertical = \Text\Vertical
;                 If \Text\Rotate = 270
;                   \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
;                   \Items()\Text\y = \Items()\y
;                 Else
;                   \Items()\Text\x = \Image\Width+\Items()\x
;                   \Items()\Text\y = \Items()\y+\Items()\Text\Width
;                 EndIf
;                 \Items()\Text\Height = \Text\Height
;                 \Items()\Text\String.s = String.s
;                 \Items()\Text\Len = Len(String.s)
;                 
;                 _set_scroll_height_(*This)
;               EndIf
;               
            Next
          Else
            For IT = 1 To \CountItems
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If AddElement(\Items())
                \Items() = AllocateStructure(_s_rows)
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String.s))
                Else
                  \Items()\Text\Width = TextWidth(String.s)
                EndIf
                
                \Items()\Index[1] =- 1
                \Items()\Focus =- 1
                \Items()\Radius = \Radius
                \Items()\Text\String.s = String.s
                \Items()\Index = ListIndex(\Items())
                
                ; Set line default colors             
                \Items()\Color\State = 1
                
                ; Update line pos in the text
                \Items()\Text\Pos = \Text\Pos
                \Items()\Text\Len = Len(String.s)
                \Text\Pos + \Items()\Text\Len + 1 ; Len(#LF$)
                
                _set_content_X_(*This)
                _line_resize_X_(*This)
                _line_resize_Y_(*This)
                
                If \Index[2] = ListIndex(\Items())
                  ;Debug " string "+String.s
                  \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
                  \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
                EndIf
                
                ; Scroll width length
                _set_scroll_width_(*This)
                
                ; Scroll hight length
                _set_scroll_height_(*This)
                
                ;                 AddLine(*This, ListIndex(\Items()), String.s)
              EndIf
            Next
          EndIf
        Else
          For IT = 1 To \CountItems
            String.s = StringField(\Text\String.s[2], IT, #LF$)
            
            If SelectElement(\Items(), IT-1)
              If \Items()\Text\String.s <> String.s Or \Items()\Text\Change
                \Items()\Text\String.s = String.s
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String.s))
                Else
                  \Items()\Text\Width = TextWidth(String.s)
                EndIf
              EndIf
              
              ; Update line pos in the text
              \Items()\Text\Pos = \Text\Pos
              \Items()\Text\Len = Len(String.s)
              \Text\Pos + \Items()\Text\Len + 1 ; Len(#LF$)
              
              ; Resize item
              If (Left And Not  Bool(\Scroll\X = Left))
                _set_content_X_(*This)
              EndIf
              
              _line_resize_X_(*This)
              
              ; Set scroll width length
              _set_scroll_width_(*This)
            EndIf
          Next
        EndIf
      Else
        ; Scroll hight reset 
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
        ForEach \Items()
          If Not \Items()\Hide
            _set_content_X_(*This)
            _line_resize_X_(*This)
            _line_resize_Y_(*This)
            
            ; Scroll hight length
            _set_scroll_height_(*This)
          EndIf
        Next
      EndIf
      
      
      If \scroll\v And \scroll\v\max <> \scroll\height And 
         Bar::SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height - Bool(\flag\gridLines)) 
        Bar::Resizes(\scroll, 0, 0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \scroll\h And \scroll\h\max<>\scroll\width And 
         Bar::SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
        Bar::Resizes(\scroll, 0, 0, #PB_Ignore, #PB_Ignore)
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure CheckBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
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
  
  Procedure Selection(X, Y, SourceColor, TargetColor)
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
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i _Draw(*This._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        ; Debug "Draw "
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
          
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Resize
            ; Посылаем сообщение об изменении размера 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
            CompilerIf Defined(Bar, #PB_Module)
              ;  Bar::Resizes(\Scroll, \x[2]+\sci\margin\width,\Y[2],\Width[2]-\sci\margin\width,\Height[2])
              Bar::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
              \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
            CompilerElse
              \scroll\width[2] = \width[2]
              \scroll\height[2] = \height[2]
            CompilerEndIf
          EndIf
          
          If \Text\Change
            \Text\Height[1] = TextHeight("A") + Bool(\CountItems<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          Text::MultiLine(*This)
        ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \Text\Change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \Scroll\v And \Scroll\v\max <> \Scroll\Height And Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                If \Text\editable And (\Items()\y >= (\scroll\height[2]-\Items()\height))
                ; This is for the editor widget when you enter the key - (enter & backspace)
                Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
              EndIf
              
                Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
            EndIf
              
            CompilerEndIf
          EndIf
          EndIf 
        
        iX=\X[2]
        iY=\Y[2]
        iwidth = \scroll\width[2]
        iheight = \scroll\height[2]
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
        
        ; Draw margin back color
        If \sci\margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \sci\margin\width, iHeight, \sci\margin\Color\Back); $C8D7D7D7)
        EndIf
        
          
          
        
      EndWith 
      
      ; Draw Lines text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            ;\Hide = Bool(Not Drawing)
            
            If \hide
              Drawing = 0
            EndIf
            
            If Drawing
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
                ;               ElseIf *This\Text\FontID 
                ;                 DrawingFont(*This\Text\FontID) 
              EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              If *This\Focus = *This And *This\Text\Editable
                Protected Left = Move(*This, \Width)
              EndIf
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*This\Image\width)*4
              ; Draw coordinates 
              \sublevellen = *This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\flag\buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
              \Image\X + \sublevellen + indent
              \Text\X + \sublevellen + *This\Image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*This)
            EndIf
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X
            Text_Y = \Text\Y+*This\Scroll\Y
            ; Debug Text_X
            
            ; expanded & collapsed box
            _set_open_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; checked box
            _set_check_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; Draw selections
            If Drawing And (\Index=*This\Index[1] Or \Index=\focus Or \Index=\Index[1]) ; \Color\State;
              If *This\Row\Color\Back[\Color\State]<>-1                                 ; no draw transparent
                If *This\Row\Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,RowForeColor(*This, \Color\State) ,RowBackColor(*This, \Color\State) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,RowBackColor(*This, \Color\State) )
                EndIf
              EndIf
              
              If *This\Row\Color\Frame[\Color\State]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, RowFrameColor(*This, \Color\State) )
              EndIf
            EndIf
            
            ; Draw plot
            _draw_plots_(*This, *This\Items(), *This\x+*This\Scroll\X, \box\y+\box\height/2)
            
            If Drawing
              ; Draw boxes
              If *This\flag\buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Bar, #PB_Module)
                  Bar::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), 0,0) 
                CompilerEndIf
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, *This\row\color\alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
             ; _clip_output_(*This, *This\X[2], #PB_Ignore, *This\scroll\width[2], #PB_Ignore) 
              
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\row\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
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
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *This\Row\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                EndIf
                
                ;                 CompilerIf Defined(Bar, #PB_Module)
                ;                   Debug ""+*This\Scroll\X +" "+ *This\Scroll\h\page\pos
                ;                 CompilerEndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *This\sci\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*This\sci\margin\width-TextWidth(Str(\Index)) - 5, \Y+*This\Scroll\Y, Str(\Index), *This\sci\margin\Color\Front)
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \index +" "+ *This\index[1] +" "+ *This\index[2] +" "+ *This\Text\Caret +" "+ *This\Text\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ; And *This\Text\Caret = *This\Text\Caret[1] And *This\Index[1] = *This\Index[2] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Text\Caret > *This\Text\Caret[1])
                Line((\Text\X+*This\Scroll\X) + \Text[1]\Width + \Text[2]\Width - Bool(*This\Scroll\X = Left), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\Text\X+*This\Scroll\X) + \Text[1]\Width - Bool(*This\Scroll\X = Left), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          UnclipOutput()
          ; Draw scroll bars
          CompilerIf Defined(Bar, #PB_Module)
            If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
               Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
              Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
            EndIf
            If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
               Bar::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
              Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
            EndIf
            
            Bar::Draw(\Scroll\v)
            Bar::Draw(\Scroll\h)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \color\alpha)
          EndIf
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          If \Color\State = 2
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\front[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\front[2]) : EndIf  ; Сглаживание краев )))
          Else
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            If \Color\State = 2
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\front[2])
            Else
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            EndIf
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Draw(*This._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        ; Debug "Draw "
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Resize
            ; Посылаем сообщение об изменении размера 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
            CompilerIf Defined(Bar, #PB_Module)
              If *This\Scroll\v And *This\Scroll\h
                ;  Bar::Resizes(\Scroll, \x[2]+\sci\margin\width,\Y[2],\Width[2]-\sci\margin\width,\Height[2])
                Bar::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
                \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
                \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              Else
                
                \scroll\width[2] = \width[2]
              \scroll\height[2] = \height[2]
            EndIf
            CompilerElse
              \scroll\width[2] = \width[2]
              \scroll\height[2] = \height[2]
            CompilerEndIf
          EndIf
          
          If \Text\Change
            If set_text_width
              SetTextWidth(set_text_width, Len(set_text_width))
              set_text_width = ""
            EndIf
            
           \Text\Height[1] = TextHeight("A") + Bool(\CountItems<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          MultiLine(*This)
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \Text\Change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \Scroll\v And \Scroll\v\max <> \Scroll\Height And Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                If \Text\editable And (\Items()\y >= (\scroll\height[2]-\Items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
                EndIf
                
                Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
              \scroll\height[2] = *This\Scroll\v\Page\len ; y(*This\Scroll\h)-*This\Scroll\v\y ;
            EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        iX=\X[2]
        iY=\Y[2]
        iwidth = \scroll\width[2]
        iheight = \scroll\height[2]
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
        
        ; Draw margin back color
        If \sci\margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \sci\margin\width, iHeight, \sci\margin\Color\Back); $C8D7D7D7)
        EndIf
        
        ; Caaret move
        If \Text\Editable And ListSize(\Items()) And \Focus = *This And \Canvas\Mouse\Buttons
;           If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
;             \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
;           EndIf 
       Protected Left
          CompilerIf Defined(Bar, #PB_Module)
           ; If ((\Scroll\v And Not \Scroll\v\at) And (\Scroll\h And Not \Scroll\h\at))
           ;  Debug 4444
          Left = Move(*This, \Items()\Width)
          ;  EndIf
          CompilerElse
            Left = Move(*This, \Items()\Width)
          CompilerEndIf
        EndIf
        
      EndWith 
      
      Protected sw
      ; Draw Lines text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            ;\Hide = Bool(Not Drawing)
            
               If sw<\text\x+\text\width
                sw=\text\x+\text\width
              EndIf
              
            
            If \hide
              Drawing = 0
            Else
           EndIf
            
            If Drawing
              
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
                ;               ElseIf *This\Text\FontID 
                ;                 DrawingFont(*This\Text\FontID) 
              EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
;               If *This\Focus = *This And *This\Text\Editable
;                 Protected Left = Move2(*This, \Width)
;               EndIf
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*This\Image\width)*4
              ; Draw coordinates 
              \sublevellen = *This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\flag\buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
              \Image\X + \sublevellen + indent
              \Text\X + \sublevellen + *This\Image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*This)
            EndIf
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X
            Text_Y = \Text\Y+*This\Scroll\Y
            ; Debug Text_X
            
            ; expanded & collapsed box
            _set_open_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; checked box
            _set_check_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; Draw selections
            If Drawing And (\Index=*This\Index[1] Or \Index=\focus Or \Index=\Index[1]) ; \Color\State;
              If *This\Row\Color\Back[\Color\State]<>-1                                 ; no draw transparent
                If *This\Row\Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,RowForeColor(*This, \Color\State) ,RowBackColor(*This, \Color\State) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,RowBackColor(*This, \Color\State) )
                EndIf
              EndIf
              
              If *This\Row\Color\Frame[\Color\State]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, RowFrameColor(*This, \Color\State) )
              EndIf
            EndIf
            
            ; Draw plot
            _draw_plots_(*This, *This\Items(), *This\x+*This\Scroll\X, \box\y+\box\height/2)
            
            If Drawing
              ; Draw boxes
              If *This\flag\buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Bar, #PB_Module)
                  Bar::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), *This\Scroll\v\ArrowType[1],1) 
                CompilerEndIf
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, *This\row\color\alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              ; _clip_output_(*This, *This\X[2], #PB_Ignore, *This\scroll\width[2], #PB_Ignore) 
              
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\row\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
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
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *This\Row\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                EndIf
                
                ;                 CompilerIf Defined(Bar, #PB_Module)
                ;                   Debug ""+*This\Scroll\X +" "+ *This\Scroll\h\page\pos
                ;                 CompilerEndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *This\sci\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*This\sci\margin\width-TextWidth(Str(\Index)) - 5, \Y+*This\Scroll\Y, Str(\Index), *This\sci\margin\Color\Front)
              EndIf
              
            EndIf
            
          Next
          PopListPosition(*This\Items()) ; 
        EndIf
      EndWith  
      
      
      With *This
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\Items()) And (\Text\Editable Or \Items()\Text\Editable) And \Focus = *This
          DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\Text\X+\Scroll\X) + \Items()\Text[1]\Width + 
               Bool(Not \Items()\Text[1]\Width Or (\Index[1] = \Index[2] And \Text\Caret > \Text\Caret[1]))*\Items()\Text[2]\Width - Bool(\Scroll\X = Left), 
               \Items()\Y+\Scroll\Y, 1, Height, $FFFFFFFF)
          
;           Debug \Items()\Text[1]\Width + 
;                Bool(Not \Items()\Text[1]\Width Or (\Index[1] = \Index[2] And \Text\Caret > \Text\Caret[1]))*\Items()\Text[2]\Width - Bool(\Scroll\X = Left)
        EndIf
        
        UnclipOutput()
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
             Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
            Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
            \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
          EndIf
          If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
             Bar::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
            Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
            \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
          EndIf
          
          Bar::Draw(\Scroll\v)
          Bar::Draw(\Scroll\h)
          
          If \Scroll\v And \Scroll\h
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*This\Scroll\h\x-Bar::GetState(*This\Scroll\h), *This\Scroll\v\y-Bar::GetState(*This\Scroll\v), *This\Scroll\h\Max, *This\Scroll\v\Max, $FF0000)
            Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Page\Len, *This\Scroll\v\Page\Len, $FF00FF00)
            Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Area\Len, *This\Scroll\v\Area\Len, $FF00FFFF)
            ;Debug \x+*This\scroll\width
            Box(sw, *This\y, 2, *This\height, $FFFF0000)
           EndIf
        CompilerEndIf
        
        _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
        
      EndWith
      
      ; Draw frames
      With *This
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          If \Color\State = 2
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\front[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\front[2]) : EndIf  ; Сглаживание краев )))
          Else
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            If \Color\State = 2
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\front[2])
            Else
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            EndIf
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \Canvas\Gadget 
        ElseIf Canvas <> \Canvas\Gadget
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*This)
          StopDrawing()
        EndIf
      EndWith
    Else
      If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,OutputWidth(),OutputHeight(), BackColor)
        
        With List()\Widget
          ForEach List()
            If Canvas = \Canvas\Gadget
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;-
  ;- - SET&GET
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
    
    With *This
      If X<>#PB_Ignore And 
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bSize
        \X[1]=\X[2]-\fSize
        \Resize | 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize | 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize | 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize | 1<<4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.s GetText(*This._s_widget)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \Text\MultiLine > 0
              Text.s + #LF$
            EndIf
            
            \Text\String.s = Text.s
            \CountItems = CountString(\Text\String.s, #LF$)
          Else
            \Text\String.s = RemoveString(\Text\String.s, #LF$) + #LF$
            ; \Text\String.s = RTrim(ReplaceString(\Text\String.s, #LF$, " ")) + #LF$
          EndIf
          
          \Text\Len = Len(\Text\String.s)
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetFont(*This._s_widget)
    ProcedureReturn *This\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*This._s_widget, FontID.i)
    Protected Result.i
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Text\Change = 1
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This._s_widget, ColorType.i, Color.i, State.i=1)
    Protected Result, Count
    State = 0
    
    With *This
      If State = 0
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color\Line[State] <> Color 
              \Color\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color\Back[State] <> Color 
              \Color\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color\Front[State] <> Color 
              \Color\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color\Frame[State] <> Color 
              \Color\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This._s_widget, ColorType.i, State.i=0)
    Protected Color.i
    
    With *This
      If Not State
        State = \Color\State
      EndIf
      
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line[State]
        Case #PB_Gadget_BackColor  : Color = \Color\Back[State]
        Case #PB_Gadget_FrontColor : Color = \Color\Front[State]
        Case #PB_Gadget_FrameColor : Color = \Color\Frame[State]
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  ;-
  Procedure.i Events(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last._s_widget, *Widget._s_widget    ; *Focus._s_widget, 
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Result, Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        ;         If Canvas <> \Canvas\Gadget
        ;           ProcedureReturn 
        ;         EndIf
        
        ; Get at point widget
        \Canvas\mouse\at = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\Canvas\Mouse\buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\Canvas\mouse\at 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And Not \Disable And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \Canvas\Mouse\buttons 
                If \Canvas\mouse\at
                  If *Last <> *This 
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *This
                      EndIf
                    Else
                      *Last = *This
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                  
                ElseIf (*Last = *This)
                  If EventType = #PB_EventType_LeftButtonUp 
                    Events(*Function, *Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LostFocus
              If (*Focus = *This)
                *Last = *Focus
                Events(*Function, *Focus, #PB_EventType_LostFocus, Canvas, 0)
                *Last = *Widget
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Events(*Function, List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    ; 
                    If Not List()\Widget\Repaint : List()\Widget\Repaint = 1
                      PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    EndIf
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Events(*Function, *This, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *This) 
          Select EventType
            Case #PB_EventType_LeftButtonDown
              If Not \Canvas\Mouse\Delta
                \Canvas\Mouse\Delta = AllocateStructure(_s_mouse)
                \Canvas\Mouse\Delta\X = \Canvas\Mouse\X
                \Canvas\Mouse\Delta\Y = \Canvas\Mouse\Y
                \Canvas\Mouse\delta\at = \Canvas\mouse\at
                \Canvas\Mouse\Delta\buttons = \Canvas\Mouse\buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\Canvas\Mouse\Delta) : \Canvas\Mouse\Delta = 0
              ; ResetStructure(\Canvas\Mouse\Delta, _s_mouse)
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \Canvas\Mouse\buttons And \Canvas\Mouse\Delta And 
                 (Abs((\Canvas\Mouse\X-\Canvas\Mouse\Delta\X)+(\Canvas\Mouse\Y-\Canvas\Mouse\Delta\Y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Canvas\Gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\Canvas\mouse\at = From(List()\Widget)
                    
                    If List()\Widget\Canvas\mouse\at
                      If *Last
                        Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Events(*Function, *Last, #PB_EventType_MouseEnter, Canvas, 0)
                    EndIf
                  EndIf
                Next
                PopListPosition(List())
              EndIf
              
              If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
                \Cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \Cursor[1] 
                \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              
            Case #PB_EventType_MouseMove ; bug mac os
              If \Canvas\Mouse\buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \Cursor <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                                                                          ; Debug 555
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              EndIf
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    If (*Last = *This) Or (*Focus = *This And *This\Text\Editable); Or (*Last = *Focus)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Result | CallFunctionFast(*Function, *This, EventType)
      CompilerElse
        Result | CallCFunctionFast(*Function, *This, EventType)
      CompilerEndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    If Canvas =- 1
      With *This
        Select EventType
          Case #PB_EventType_Repaint
            Debug " -- Canvas repaint -- "
          Case #PB_EventType_Input 
            \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
            \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \Canvas\Mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                      (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                      (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \Canvas\Mouse\buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
            CompilerEndIf
        EndSelect
      EndWith
    EndIf
    
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
              Result | Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Events(*Function, *This, EventType, Canvas, CanvasModifiers)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the default widget flag
        Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#__Flag_BorderLess
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#__Flag_BorderLess)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height)
          \Text\Vertical = Bool(Flag&#__Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine =- 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 1
          EndIf
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize + 2
          Else
            \Text\X = \fSize + 4
            \Text\y = \fSize
          EndIf
          
          \Color = Colors
          \Color\Back = \Color\Fore
          \Color\Fore = 0
          
          If Not \bSize
            \Color\Frame = \Color\Back
          EndIf
          
          SetText(*This, Text.s)
          \Resize = 0
          
          
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      If Not *This\Repaint : *This\Repaint = 1
        PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
      EndIf
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This._s_widget = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      ; Repaint | CallBack(*This, EventType())
      
      If Repaint 
        Text::ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
    Protected *This._s_widget = AllocateStructure(_s_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, Text.s, Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
        *This\Canvas\Window = GetActiveWindow()
        *This\Canvas\Gadget = Gadget
        If Not *This\Repaint : *This\Repaint = 1
          PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint) ; , *This)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
EndModule

DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  Declare.i Update(*This._s_widget)
  
  ;- DECLARE
  Declare.i SetItemState(*This._s_widget, Item.i, State.i)
  Declare GetState(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i ClearItems(*This._s_widget)
  Declare.i CountItems(*This._s_widget)
  Declare.i RemoveItem(*This._s_widget, Item.i)
  Declare SetState(*This._s_widget, State.i)
  Declare GetAttribute(*This._s_widget, Attribute.i)
  Declare SetAttribute(*This._s_widget, Attribute.i, Value.i)
  Declare SetText(*This._s_widget, Text.s, Item.i=0)
  Declare SetFont(*This._s_widget, FontID.i)
  Declare.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Make(*This._s_widget)
  Declare.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  Declare.i Draw(*This._s_widget)
EndDeclareModule

Module Editor
  Global *Buffer = AllocateMemory(10000000)
  Global *Pointer = *Buffer
  
  Procedure.i Update(*This._s_widget)
    *This\Text\String.s = PeekS(*Buffer)
    *This\Text\Change = 1
  EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i Canvas_CallBack()
  
  ;-
  ;- PUBLIC
  Procedure.i Caret(*This._s_widget, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, MouseX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          MouseX = \Canvas\Mouse\X - (\Items()\Text\X+\Scroll\X)
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (MouseX-X)*(MouseX-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \Text\Caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\Items())
            ;             If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \Index[1] Or LastItem <> Item
            ;               \Items()\Text[2]\Width[2] = 0
            ;               
            ;               If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
            ;                  \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
            ;                  (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*This\Items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
            ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
            ;                 EndIf 
            ;                 
            ;                 ; \Items()\Text[2]\Width = (\Items()\Width-\Items()\Text\Width) + TextWidth(\Items()\Text[2]\String.s)
            ;                 
            ;                 If \Flag\FullSelection
            ;                   \Items()\Text[2]\Width[2] = \Flag\FullSelection
            ;                 Else
            ;                   \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
            ;                 EndIf
            ;               EndIf
            ;               
            ;               LastItem = Item
            ;               LastLine = \Index[1]
            ;             EndIf
            ;             PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Change(*This._s_widget, Pos.i, Len.i)
    With *This
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Change = #True
      EndIf
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Change = 1
      EndIf
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      If (\Text[1]\Change Or \Text[3]\Change)
        If \Text[1]\Change
          \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
          \Text[1]\String.s = Left(\Text\String.s, \Text[1]\Len) 
          \Text[2]\Pos = \Text[1]\Len
        EndIf
        
        If \Text[3]\Change
          \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
          \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
          \Text[3]\String.s = Right(\Text\String.s, \Text[3]\Len)
        EndIf
        
        If \Text[1]\Len <> \Text[3]\Pos 
          \Text[2]\Change = 1 
          \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
          \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text[2]\Pos, \Text[2]\Len) 
        Else
          \Text[2]\Len = 0 : \Text[2]\String.s = ""
        EndIf
        
        \Text[1]\Change = 0 : \Text[3]\Change = 0 
      EndIf
      
      
      
      ;       If CountString(\Text[3]\String.s, #LF$)
      ;         Debug "chang "+\Items()\Text\String.s +" "+ CountString(\Text[3]\String.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure SelectionText(*This._s_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *This
      ;Debug "7777    "+\Text\Caret +" "+ \Text\Caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\Text\String
      
      If (Caret <> \Text\Caret Or Line <> \Index[1] Or (\Text\Caret[1] >= 0 And Caret1 <> \Text\Caret[1]))
        \Items()\Text[2]\String.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
            \Items()\Text[2]\Width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Width[2] = 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret 
            Pos = \Text\Caret[1]
            ;             If \Text\Caret[1] = \Items()\Text\Len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \Text\Caret[1] > \Text\Caret 
            ; |<<<<<< to left
            Pos = \Text\Caret
            Len = (\Text\Caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \Text\Caret[1]
            Len = (\Text\Caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \Text\Caret
          Len = \Items()\Text\Len-Pos
          ; Len - Bool(\Items()\Text\Len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \Text\Caret
        EndIf
        
        Change(*This, Pos, Len)
        
        Line = \Index[1]
        Caret = \Text\Caret
        Caret1 = \Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i SelReset(*This._s_widget)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  
  Procedure.i SelLimits(*This._s_widget)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure Move(*This._s_widget, Width)
    Protected Left,Right
    
    With *This
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \Text\Big) ;And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \Items()\Text\String.s
        Protected string_len.i = \Items()\Text\Len
        Protected mouse_x.i = \Canvas\Mouse\X-(\Items()\Text\X+\Scroll\X)
        
        For i = 0 To string_len
          cursor_x = TextWidth(Left(String.s, i))
          Distance = (mouse_x-cursor_x)*(mouse_x-cursor_x)
          
          If MinDistance > Distance 
            MinDistance = Distance
            Right =- cursor_x
            Caret = i
          EndIf
        Next
        
        Left = (Width + Right)
        \Items()\Text[3]\Width = TextWidth(Right(String.s, string_len-Caret))
        
        If \Scroll\X < Right
          Bar::SetState(\Scroll\h, -Right) ;: \Scroll\X = Right
        ElseIf \Scroll\X > Left
          Bar::SetState(\Scroll\h, -Left) ;: \Scroll\X = Left
        ElseIf (\Scroll\X < 0 And \Canvas\Input = 65535 ) : \Canvas\Input = 0
          \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
          If \Scroll\X>0 : \Scroll\X=0 : EndIf
        EndIf
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.i Make(*This._s_widget)
    Protected String1.s, String2.s, String3.s, Count.i
    
    With *This
      If ListSize(\Lines())
        \CountItems = 0;CountString(\text\string, #LF$)
        
        ForEach \Lines()
          If \Lines()\Index =- 1 : \CountItems + 1
            If String1.s
              String1.s +#LF$+ \Lines()\Text\String.s 
            Else
              String1.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String1.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index = \CountItems
            If String2.s
              String2.s +#LF$+ \Lines()\Text\String.s 
            Else
              String2.s + \Lines()\Text\String.s
            EndIf
            DeleteElement(\Lines())
          EndIf
        Next : String2.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index > 0
            If String3.s
              String3.s +#LF$+ \Lines()\Text\String.s 
            Else
              String3.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String3.s + #LF$
        
        \Text\String.s = String1.s + String2.s + \Text\String.s + String3.s
        \CountItems = CountString(\Text\string, #LF$)
        \Text\Len = Len(\Text\String.s)
        \Text\Change = 1
        
        ; ;         ForEach \Lines()
        ; ;         ;  Text_AddLine(*This,\Lines()\Index, \Lines()\Text\String.s)
        ; ;         Next 
        ClearList(\Lines())
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Paste(*This._s_widget, Chr.s, Count.i=0)
    Protected Repaint.i
    
    With *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        SelReset(*This)
        
        If Count
          \Index[2] + Count
          \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        Else
          \Text\Caret = \Items()\Text[1]\Len + Len(Chr.s)
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      \Text\String.s = \Text[1]\String + Chr.s + \Text[3]\String
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Insert(*This._s_widget, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text::Make(*This, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Paste(*This, Chr.s, Count)
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\String.s = \Text[1]\String + Chr.s + \Text[3]\String
          \Text\Caret[1] = \Text\Caret 
          ; \CountItems = CountString(\Text\String.s, #LF$)
          \Text\Change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\Items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Cut(*This._s_widget)
    ProcedureReturn Paste(*This._s_widget, "")
  EndProcedure
  
  Procedure.s Wrap (Text.s, Width.i, Mode.i=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$=""
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;     
    CountString = CountString(Text.s, #LF$) 
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
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
          If width > TextWidth(RTrim(Left(line$, length)))
            Break
          Else
            length - 1 
          EndIf
        Wend
      Wend
      
      ret$ + LineRet$ + line$ + #CR$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  ;-
  Procedure AddLine(*This._s_widget, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\CountItems))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\CountItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\CountItems)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\CountItems)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\CountItems)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-_this_\Items()\Text\Width)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+_this_\Items()\Text\Width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\Text\Width+_this_\Image\Width)/2)+Indent
            Image_X=(Width-_this_\Items()\Text\Width-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-_this_\Items()\Text\Width)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-_this_\Items()\Text\Width)
        ElseIf _this_\Text\Align\Horizontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        Else
          Text_X=_this_\sci\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X[2]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[2]+_this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\CountItems<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\CountItems<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\Items()\Text\Pos = _this_\Text\Pos - Bool(_this_\Text\MultiLine = 1)*_this_\Items()\index ; wordwrap
      _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
      _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *This
      \CountItems = ListSize(\Items())
      
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Not Defined(Bar, #PB_Module)
          \scroll\width[2] = \width[2]-\sci\margin\width
          \scroll\height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \scroll\width[2]
      height = \scroll\height[2]
      
      \Items()\Index[1] =- 1
      \Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default color state           
      \Items()\Color\State = 1
      
      ; Update line pos in the text
      _set_line_pos_(*This)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i MultiLine(*This._s_widget)
    Protected Repaint, String.s, text_width, Len.i
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[2]-\Text\X*2
        Height = \Width[2]-\Text\y*2
      Else
        width = \scroll\width[2]-\Text\X*2-\sci\margin\width
        height = \scroll\height[2]
      EndIf
      
      ; Debug ""+\scroll\width[2] +" "+ \Width[0] +" "+ \Width[1] +" "+ \Width[2] +" "+ Width
      ;Debug ""+\scroll\width[2] +" "+ \scroll\height[2] +" "+ \Width[2] +" "+ \Height[2] +" "+ Width +" "+ Height
      
      If \Text\MultiLine > 0
        String.s = Wrap(\Text\String.s, Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s
      EndIf
      
      \Text\Pos = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        \Text\String.s[2] = String.s
        \CountItems = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Move(*This, Width)
        EndIf
        
        If \CountItems[1] <> \CountItems Or \Text\Vertical
          \CountItems[1] = \CountItems
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \CountItems To 1 Step - 1
              If AddElement(\Items())
                \Items() = AllocateStructure(_s_rows)
                String = StringField(\Text\String.s[2], IT, #LF$)
                
                \Items()\Focus =- 1
                \Items()\Index[1] =- 1
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String))
                Else
                  \Items()\Text\Width = TextWidth(String)
                EndIf
                
                If \Text\Align\Right
                  Text_X=(Width-\Items()\Text\Width) 
                ElseIf \Text\Align\Horizontal
                  Text_X=(Width-\Items()\Text\Width-Bool(\Items()\Text\Width % 2))/2 
                EndIf
                
                \Items()\x = \X[2]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[2]+\Text\X+Text_X
                \Items()\Width = \Text\Height
                \Items()\Height = Width
                \Items()\Index = ListIndex(\Items())
                
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\Vertical = \Text\Vertical
                If \Text\Rotate = 270
                  \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
                  \Items()\Text\y = \Items()\y
                Else
                  \Items()\Text\x = \Image\Width+\Items()\x
                  \Items()\Text\y = \Items()\y+\Items()\Text\Width
                EndIf
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                _set_scroll_height_(*This)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \Text\String.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\Items())
                    \Items() = AllocateStructure(_s_rows)
                    
                    \Items()\Text\String.s = Trim(RegularExpressionMatchString(0), #LF$)
                    \Items()\Text\Width = TextWidth(\Items()\Text\String.s) ; Нужен для скролл бара
                    
                    \Items()\Focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\Color\State = 1 ; Set line default colors
                    \Items()\Radius = \Radius
                    \Items()\Index = ListIndex(\Items())
                    
                    ; Update line pos in the text
                    _set_line_pos_(*This)
                    
                    _set_content_X_(*This)
                    _line_resize_X_(*This)
                    _line_resize_Y_(*This)
                    
                    ; Scroll width length
                    _set_scroll_width_(*This)
                    
                    ; Scroll hight length
                    _set_scroll_height_(*This)
                  EndIf
                Wend
              EndIf
              
              FreeRegularExpression(0)
            Else
              Debug RegularExpressionError()
            EndIf
            
            
            
            
            ;             ;; 294 ; 124
            ;             Protected *Sta.Character = @\Text\String.s[2], *End.Character = @\Text\String.s[2] : #SOC = SizeOf (Character)
            ;While *End\c 
            ;               If *End\c = #LF And AddElement(\Items())
            ;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
            ;                 
            ;                 \Items()\Text\String.s = PeekS (*Sta, Len) ;Trim(, #LF$)
            ;                 
            ; ;                 If \Type = #PB_GadgetType_Button
            ; ;                   \Items()\Text\Width = TextWidth(RTrim(\Items()\Text\String.s))
            ; ;                 Else
            ; ;                   \Items()\Text\Width = TextWidth(\Items()\Text\String.s)
            ; ;                 EndIf
            ;                 
            ;                 \Items()\Focus =- 1
            ;                 \Items()\Index[1] =- 1
            ;                 \Items()\Color\State = 1 ; Set line default colors
            ;                 \Items()\Radius = \Radius
            ;                 \Items()\Index = ListIndex(\Items())
            ;                 
            ;                 ; Update line pos in the text
            ;                 ; _set_line_pos_(*This)
            ;                 \Items()\Text\Pos = \Text\Pos - Bool(\Text\MultiLine = 1)*\Items()\index ; wordwrap
            ;                 \Items()\Text\Len = Len                                                  ; (\Items()\Text\String.s)
            ;                 \Text\Pos + \Items()\Text\Len + 1                                        ; Len(#LF$)
            ;                 
            ;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\Text\Pos +" "+ \Items()\Text\Len
            ;                 
            ;                 _set_content_X_(*This)
            ;                 _line_resize_X_(*This)
            ;                 _line_resize_Y_(*This)
            ;                 
            ;                 ; Scroll width length
            ;                 _set_scroll_width_(*This)
            ;                 
            ;                 ; Scroll hight length
            ;                 _set_scroll_height_(*This)
            ;                 
            ;                 *Sta = *End + #SOC 
            ;               EndIf 
            ;               
            ;               *End + #SOC 
            ;             Wend
            ;;;;  FreeMemory(*End)
            
            ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
            Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          EndIf
        Else
          Protected time2 = ElapsedMilliseconds()
          
          If CreateRegularExpression(0, ~".*\n?")
            If ExamineRegularExpression(0, \Text\String.s[2])
              While NextRegularExpressionMatch(0) : IT+1
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                If SelectElement(\Items(), IT-1)
                  If \Items()\Text\String.s <> String.s
                    \Items()\Text\String.s = String.s
                    
                    If \Type = #PB_GadgetType_Button
                      \Items()\Text\Width = TextWidth(RTrim(String.s))
                    Else
                      \Items()\Text\Width = TextWidth(String.s)
                    EndIf
                  EndIf
                  
                  ; Update line pos in the text
                  _set_line_pos_(*This)
                  
                  ; Resize item
                  If (Left And Not  Bool(\Scroll\X = Left))
                    _set_content_X_(*This)
                  EndIf
                  
                  _line_resize_X_(*This)
                  
                  ; Set scroll width length
                  _set_scroll_width_(*This)
                EndIf
                
              Wend
            EndIf
            
            FreeRegularExpression(0)
          Else
            Debug RegularExpressionError()
          EndIf
          
          Debug Str(ElapsedMilliseconds()-time2) + " text parse time2 "
          
        EndIf
      Else
        ; Scroll hight reset 
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
        ForEach \Items()
          If Not \Items()\Hide
            _set_content_X_(*This)
            _line_resize_X_(*This)
            _line_resize_Y_(*This)
            
            ; Scroll hight length
            _set_scroll_height_(*This)
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure CheckBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
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
  
  Procedure Selection(X, Y, SourceColor, TargetColor)
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
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Draw(*This._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        
        ; Then changed text
        If \Text\Change
          If set_text_width
            SetTextWidth(set_text_width, Len(set_text_width))
            set_text_width = ""
          EndIf
          
          \Text\Height[1] = TextHeight("A") + Bool(\CountItems<>1 And \Flag\GridLines)
          If \Type = #PB_GadgetType_Tree
            \Text\Height = 20
          Else
            \Text\Height = \Text\Height[1]
          EndIf
          \Text\Width = TextWidth(\Text\String.s)
          
          If \sci\margin\width 
            \CountItems = CountString(\Text\String.s, #LF$)
            \sci\margin\width = TextWidth(Str(\CountItems))+11
            ;  Bar::Resizes(\Scroll, \x[2]+\sci\margin\width+1,\Y[2],\Width[2]-\sci\margin\width-1,\Height[2])
          EndIf
        EndIf
        
        ; Then resized widget
        If \Resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
          
          CompilerIf Defined(Bar, #PB_Module)
            ;  Bar::Resizes(\Scroll, \x[2]+\sci\margin\width,\Y[2],\Width[2]-\sci\margin\width,\Height[2])
            Bar::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
            \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
            \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
          CompilerElse
            \scroll\width[2] = \width[2]
            \scroll\height[2] = \height[2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\X[2]
        iY=\Y[2]
        iwidth = \scroll\width[2]
        iheight = \scroll\height[2]
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          MultiLine(*This)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \Text\Change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Bar, #PB_Module)
              If \Scroll\v And \Scroll\v\max <> \Scroll\Height And 
                 Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                
                \Scroll\v\Step = \Text\Height
                
                If \Text\editable And (\Items()\y >= (\scroll\height[2]-\Items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
                EndIf
                
                Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
                \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
                
                If \Scroll\v\Hide 
                  \scroll\width[2] = \Width[2]
                  \Items()\Width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\Scroll\v\Hide +" "+ \Scroll\Height
                EndIf
              EndIf
              
              If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
                 Bar::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
                Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                \scroll\width[2] = *This\Scroll\h\Page\len ; x(*This\Scroll\v)-*This\Scroll\h\x ; 
                \scroll\height[2] = *This\Scroll\v\Page\len; y(*This\Scroll\h)-*This\Scroll\v\y ;
                                                          ;  \scroll\width[2] = \width[2] - Bool(Not \Scroll\v\Hide)*\Scroll\v\Width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \Canvas\input And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
                Debug ""+\Scroll\h\Max +" "+ Str(\Items()\text\x+\Items()\text\width)
                
                If \Scroll\h\Max = (\Items()\text\x+\Items()\text\width)
                  Bar::SetState(\Scroll\h, \Scroll\h\Max)
                Else
                  Bar::SetState(\Scroll\h, \Scroll\h\Page\Pos + TextWidth(Chr(\Canvas\input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ;
        If \Text\Editable And ListSize(\Items())
          If \Text\Change =- 1
            \Text[1]\Change = 1
            \Text[3]\Change = 1
            \Text\Len = Len(\Text\String.s)
            Change(*This, \Text\Caret, 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \Items()\Text[1]\Change : \Items()\Text[1]\Change = #False
            \Items()\Text[1]\Width = TextWidth(\Items()\Text[1]\String.s)
            
            ; demo
            ;             Protected caret1, caret = \Text\Caret[2]
            
            ; Положение карета
            If \Text\Caret[1] = \Text\Caret
              \Text\Caret[2] = \Items()\Text[1]\Width
              ;               caret1 = \Text\Caret[2]
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \Text\Caret[2] = 0
            ElseIf \index[1] = ListSize(\Items())
              \Text\Caret[2] = \Items()\Text\Width
            ElseIf \Items()\Text\Len = \Items()\Text[2]\Len
              \Text\Caret[2] = \Items()\Text\Width
            EndIf
            
            ;             If Caret<>\Text\Caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \Text\Caret[2] +" "+\index[1] +" "+\index[2]
            ;               caret = \Text\Caret[2]
            ;             EndIf
            
          EndIf
          
          If \Items()\Text[2]\Change : \Items()\Text[2]\Change = #False 
            \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text[1]\Width
            \Items()\Text[2]\Width = TextWidth(\Items()\Text[2]\String.s) ; + Bool(\Items()\Text[2]\Len =- 1) * \Flag\FullSelection ; TextWidth() - bug in mac os
            
            \Items()\Text[3]\X = \Items()\Text[2]\X+\Items()\Text[2]\Width
          EndIf 
          
          If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
            \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
          EndIf 
          
          If (\Focus = *This And \Canvas\Mouse\Buttons And (Not \Scroll\v\at And Not \Scroll\h\at)) 
            Protected Left = Move(*This, \Items()\Width)
          EndIf
        EndIf
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
        
        ; Draw margin back color
        If \sci\margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \sci\margin\width, \Height[2], \sci\margin\Color\Back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            ;\Hide = Bool(Not Drawing)
            
            If \hide
              Drawing = 0
            EndIf
            
            If Drawing
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
                ;               ElseIf *This\Text\FontID 
                ;                 DrawingFont(*This\Text\FontID) 
              EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                ; Debug "get caret "+\Text[3]\Len
                \Text[2]\Width = TextWidth(\Text[2]\String.s) + Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *This\Flag\FullSelection ; TextWidth() - bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*This\Image\width)*4
              ; Draw coordinates 
              \sublevellen = *This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\flag\buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
              \Image\X + \sublevellen + indent
              \Text\X + \sublevellen + *This\Image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*This)
            EndIf
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X
            Text_Y = \Text\Y+*This\Scroll\Y
            ; Debug Text_X
            
            ; expanded & collapsed box
            _set_open_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; checked box
            _set_check_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; Draw selections
            If Drawing And (\Index=*This\Index[1] Or \Index=\focus Or \Index=\Index[1]) ; \Color\State;
              If *This\Row\Color\Back[\Color\State]<>-1                                 ; no draw transparent
                If *This\Row\Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,RowForeColor(*This, \Color\State) ,RowBackColor(*This, \Color\State) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,RowBackColor(*This, \Color\State) )
                EndIf
              EndIf
              
              If *This\Row\Color\Frame[\Color\State]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, RowFrameColor(*This, \Color\State) )
              EndIf
            EndIf
            
            ; Draw plot
            _draw_plots_(*This, *This\Items(), *This\x+*This\Scroll\X, \box\y+\box\height/2)
            
            If Drawing
              ; Draw boxes
              If *This\flag\buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Bar, #PB_Module)
                  Bar::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), 0,0) 
                CompilerEndIf
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, *This\row\color\alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X-1, #PB_Ignore, \Width+2+*This\sci\margin\width, #PB_Ignore) 
              ; _clip_output_(*This, *This\X[2], #PB_Ignore, *This\scroll\width[2], #PB_Ignore) 
              
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\row\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
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
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *This\Row\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *This\sci\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*This\sci\margin\width-TextWidth(Str(\Index))-3, \Y+*This\Scroll\Y, Str(\Index), *This\sci\margin\Color\Front);, *This\sci\margin\Color\Back)
              EndIf
            EndIf
            
;             ; text x
;             Box(\text\x, *This\y, 2, *This\height, $FFFF0000)
;         
          Next
          PopListPosition(*This\Items()) ; 
        EndIf
      EndWith  
      
      
      With *This
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\Items()) And (\Text\Editable Or \Items()\Text\Editable) And \Focus = *This : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\Text\X+\Scroll\X) + \Text\Caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \Scroll\X), \Items()\Y+\Scroll\Y, 1, Height, $FFFFFFFF)
        EndIf
        
        UnclipOutput()
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
          ;              Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
          ;             Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
          ;              Bar::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
          ;             Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Bar::Draw(\Scroll\v)
          Bar::Draw(\Scroll\h)
         ; (_this_\sci\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\Scroll\h\x-Bar::GetState(*This\Scroll\h), *This\Scroll\v\y-Bar::GetState(*This\Scroll\v), *This\Scroll\h\Max, *This\Scroll\v\Max, $FF0000)
          Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Page\Len, *This\Scroll\v\Page\Len, $FF00FF00)
          Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Area\Len, *This\Scroll\v\Area\Len, $FF00FFFF)
        CompilerEndIf
        
        _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
        
      EndWith
      
      ; Draw frames
      With *This
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          If \Color\State = 2
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\front[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\front[2]) : EndIf  ; Сглаживание краев )))
          Else
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            If \Color\State = 2
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\front[2])
            Else
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            EndIf
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \Canvas\Gadget 
        ElseIf Canvas <> \Canvas\Gadget
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*This)
          StopDrawing()
        EndIf
      EndWith
    Else
      If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,OutputWidth(),OutputHeight(), BackColor)
        
        With List()\Widget
          ForEach List()
            If Canvas = \Canvas\Gadget
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i ToUp(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        ;If (\Items()\y+\Scroll\Y =< \Y[2])
        Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
          Bar::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
        Else
          Bar::SetState(\Scroll\h, 0)
        EndIf
        ;Change(*This, \Text\Caret, 0)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDown(*This._s_widget)
    Static Line
    Protected Repaint, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If Shift
        
        If \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[1]) 
          Change(*This, \Text\Caret[1], \Items()\Text\Len-\Text\Caret[1])
        Else
          SelectElement(\Items(), \Index[2]) 
          Change(*This, 0, \Items()\Text\Len)
        EndIf
        ; Debug \Text\Caret[1]
        \Index[2] + 1
        ;         \Text\Caret = Caret(*This, \Index[2]) 
        ;         \Text\Caret[1] = \Text\Caret
        SelectElement(\Items(), \Index[2]) 
        Change(*This, 0, \Text\Caret[1]) 
        SelectionText(*This)
        Repaint = 1 
        
      Else
        If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[2]) 
          ;If (\Items()\y >= (\scroll\height[2]-\Items()\height))
          Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
          ;EndIf
          
          If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
            Bar::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
          Else
            Bar::SetState(\Scroll\h, 0)
          EndIf
          
          ;Change(*This, \Text\Caret, 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToLeft(*This._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    
    With *This
      If \Items()\Text[2]\Len And Not Shift
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret[1] = \Text\Caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \Text\Caret > 0
        If \Text\Caret > \Items()\text\len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку 
          \Text\Caret = \Items()\text\len - CountString(\Items()\Text\String.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \Text\Caret - 1 
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf ToUp(*This._s_widget)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToRight(*This._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    
    With *This
      ;       If \Index[1] <> \Index[2]
      ;         If Shift 
      ;           \Text\Caret + 1
      ;           Swap \Index[2], \Index[1] 
      ;         Else
      ;           If \Index[1] > \Index[2] 
      ;             Swap \Index[1], \Index[2] 
      ;             Swap \Text\Caret, \Text\Caret[1]
      ;             
      ;             If SelectElement(\Items(), \Index[2]) 
      ;               \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
      ;               \Items()\Text[1]\Change = #True
      ;             EndIf
      ;             
      ;             SelReset(*This)
      ;             \Text\Caret = \Text\Caret[1] 
      ;             \Index[1] = \Index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \Items()\Text[2]\Len
      ;         If \Text\Caret[1] > \Text\Caret 
      ;           Swap \Text\Caret[1], \Text\Caret 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \Text\Caret[1] = \Text\Caret 
      ;         Else
      ;           \Text\Caret + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \Items()\Text[2]\Len And Not Shift
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
          
          ;           SelReset(*This)
          ;           \Text\Caret = \Text\Caret[1] 
          ;           \Index[1] = \Index[2]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret = \Text\Caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \Text\Caret < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку
        \Text\Caret + 1
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
      ElseIf ToDown(*This)
        \Text\Caret = 0
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToInput(*This._s_widget)
    Protected Repaint
    
    With *This
      If \Canvas\Input
        Repaint = Insert(*This, Chr(\Canvas\Input))
        
        If Not Repaint
          \Default = *This
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This._s_widget) ; Ok
    
    With  *This
      If Not Paste(*This, #LF$)
        \Index[2] + 1
        \Text\Caret = 0
        \Index[1] = \Index[2]
        \Text\Caret[1] = \Text\Caret
        \Text\Change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i ToBack(*This._s_widget)
    Protected Repaint, String.s, Cut.i
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    *This\Canvas\Input = 65535
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 : \Text\Caret - 1 
          \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret)
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s) : \Items()\Text[1]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret) + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            ToUp(*This)
            
            \Text\Caret = \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDelete(*This._s_widget)
    Protected Repaint, String.s
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          \Items()\Text[3]\Len = Len(\Items()\Text[3]\String.s) : \Items()\Text[3]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text[3]\String = Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text[3]\len = Len(\Text[3]\String.s)
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\CountItems-1) ; ListSize(\Items()) - 1
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToPos(*This._s_widget, Pos.i, Len.i)
    Protected Repaint
    
    With *This
      SelReset(*This)
      
      If Len
        Select Pos
          Case 1 : FirstElement(\items()) : \Text\Caret = 0
          Case - 1 : LastElement(\items()) : \Text\Caret = \items()\Text\Len
        EndSelect
        
        \index[1] = \items()\index
        Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \Text\Caret = Bool(Pos =- 1) * \items()\Text\Len 
        Bar::SetState(\Scroll\h, Bool(Pos =- 1) * \Scroll\h\Max)
      EndIf
      
      \Text\Caret[1] = \Text\Caret
      \index[2] = \index[1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure.i Text_AddLine(*This._s_widget, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \CountItems Or Line < 0)
        Line = \CountItems
      EndIf
      
      For i = 0 To \CountItems
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \CountItems = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          ;\Items() = AllocateMemory(SizeOf(_s_rows) )
          \Items() = AllocateStructure(_s_rows)
          
          If Item = 0
            First = *Item
          EndIf
          
          If subLevel
            If sublevel>Item
              sublevel=Item
            EndIf
            
            PushListPosition(\Items())
            While PreviousElement(\Items()) 
              If subLevel = \Items()\subLevel
                adress = \Items()\handle
                Break
              ElseIf subLevel > \Items()\subLevel
                adress = @\Items()
                Break
              EndIf
            Wend 
            If adress
              ChangeCurrentElement(\Items(), adress)
              If subLevel > \Items()\subLevel
                sublevel = \Items()\sublevel + 1
                \Items()\handle[1] = *Item
                \Items()\childrens + 1
                \Items()\collapsed = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            \Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          \Items()\handle = adress
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          \Items()\focus =- 1
          \Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\handle = ImageID(Image)
            \Items()\Image\handle[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          AddLine(*This, Item.i, Text.s)
          \Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \Items()\Color = Colors
                           ;           \Items()\Color\State = 1
                           ;           \Items()\Color\Fore[0] = 0 
                           ;           \Items()\Color\Fore[1] = 0
                           ;           \Items()\Color\Fore[2] = 0
          
          If Item = 0
            If Not \Repaint : \Repaint = 1
              PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
            EndIf
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure SetAttribute(*This._s_widget, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This._s_widget, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This._s_widget, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Index[1] = \Items()\Index
        \Text\Caret = State
        \Text\Caret[1] = \Text\Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This._s_widget, State.i)
    Protected String.s, *Line
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Redraw(*This, \Canvas\Gadget)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Canvas\Gadget
          SetActiveGadget(\Canvas\Gadget)
        EndIf
        
        PushListPosition(\Items())
        If State =- 1
          \Index[1] = \CountItems - 1
          *Line = LastElement(\Items())
          \Text\Caret = \Items()\Text\Len
        Else
          \Index[1] = CountString(Left(String, State), #LF$)
          *Line = SelectElement(\Items(), \Index[1])
          If *Line
            \Text\Caret = State-\Items()\Text\Pos
          EndIf
        EndIf
        
        ;If *Line
        ;         \Index[2] = \Index[1]
        ;         \Text[1]\Change = 1
        ;         \Text[3]\Change = 1
        ;         Change(*This, \Text\Caret, 0)
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Text\Caret)
        \Items()\Text[1]\Change = 1
        \Text\Caret[1] = \Text\Caret
        
        \Items()\Index[1] = \Items()\Index 
        Bar::SetState(\Scroll\v, (\items()\y-((\scroll\height[2]+\Text\y)-\items()\height))) ;((\Index[1] * \Text\Height)-\Scroll\v\Height) + \Text\Height)
        
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         EndIf
        Redraw(*This)
        ;EndIf
        PopListPosition(\Items())
        
        ; Debug \Index[2]
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This._s_widget)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index
          Result = \Items()\Text\Pos + \Text\Caret
        EndIf
      Next
      PopListPosition(\Items())
      
      ; Debug \text[1]\len
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This._s_widget)
    Text::ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This._s_widget)
    ProcedureReturn Text::CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This._s_widget, Item.i)
    Text::RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.s GetText(*This._s_widget)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(*This._s_widget, Text.s, Item.i=0)
    Protected i
    
    With *This
      If Text::SetText(*This, Text.s)
        If Not \Repaint : \Repaint = 1
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*This._s_widget, FontID.i)
    
    With *This
      If Text::SetFont(*This, FontID)
        If Not Bool(\CountItems[1] And \CountItems[1] <> \CountItems)
          Redraw(*This, \Canvas\Gadget)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  ;-
  Procedure SelSet(*This._s_widget, Line.i)
    Protected Repaint.i
    
    With *This
      
      If \Index[1] <> Line And Line =< ListSize(\Items())
        If isItem(\Index[1], \Items()) 
          If \Index[1] <> ListIndex(\Items())
            SelectElement(\Items(), \Index[1]) 
          EndIf
          
          If \Index[1] > Line
            \Text\Caret = 0
          Else
            \Text\Caret = \Items()\Text\Len
          EndIf
          
          Repaint | SelectionText(*This)
        EndIf
        
        \Index[1] = Line
      EndIf
      
      If isItem(Line, \Items()) 
        \Text\Caret = Caret(*This, Line) 
        Repaint | SelectionText(*This)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\Items()) 
      ForEach \Items()
        If (\Index[1] = \Items()\Index Or \Index[2] = \Items()\Index)
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
          
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String = \Items()\Text\String 
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \Items()\Text[2]\Len
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String =  "" 
          \Items()\Text[2]\Len = 0 
        EndIf
      Next
      PopListPosition(\Items()) 
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editable(*This._s_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *This
      Shift = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\Canvas\Key[1] & #PB_Canvas_Control) Or (\Canvas\Key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not Control         ; And Not Shift
            Repaint = ToInput(*This)
          EndIf
          
        Case #PB_EventType_KeyUp ; Баг в мак ос не происходить событие если зажать cmd
                                 ;  Debug "#PB_EventType_KeyUp "
                                 ;           If \items()\Text\Numeric
                                 ;             \items()\Text\String.s[1]=\items()\Text\String.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Canvas\Key
            Case #PB_Shortcut_Home : Repaint = ToPos(*This, 1, Control)
            Case #PB_Shortcut_End : Repaint = ToPos(*This, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = ToPos(*This, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = ToPos(*This, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\Text[2]\Len <> \Text\Len Or Not \Text[2]\Len)
                ForEach \items()
                  \Items()\Text[2]\Len = \Items()\Text\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                  \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                  \Items()\Text[1]\String = "" : \Items()\Text[1]\Change = 1 : \Items()\Text[1]\Len = 0
                  \Items()\Text[3]\String = "" : \Items()\Text[3]\Change = 1 : \Items()\Text[3]\Len = 0
                Next
                
                \Text[1]\Len = 0 : \Text[1]\String = ""
                \Text[3]\Len = 0 : \Text[3]\String = #LF$
                \index[2] = 0 : \index[1] = ListSize(\Items()) - 1
                \Text\Caret = \Items()\Text\Len : \Text\Caret[1] = \Text\Caret
                \Text[2]\String = \Text\String : \Text[2]\Len = \Text\Len
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
            Case #PB_Shortcut_Return : Repaint = ToReturn(*This) 
            Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\Text[2]\String)
                
                If \Canvas\Key = #PB_Shortcut_X
                  Repaint = Cut(*This)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And Control
                Repaint = Insert(*This, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \Text\Caret<\Text\Caret[1]
          ; Debug \Text\Caret[1]-\Text\Caret
          Change(*This, \Text\Caret, \Text\Caret[1]-\Text\Caret)
        Else
          ; Debug \Text\Caret-\Text\Caret[1]
          Change(*This, \Text\Caret[1], \Text\Caret-\Text\Caret[1])
        EndIf
      EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Events(*This._s_widget, EventType.i)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Bar::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Bar::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      
      If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
        If ListSize(*This\items())
          If Not \Hide And Not \Disable And \Interact
            ; Get line position
            If \Canvas\Mouse\buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \Items()\Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Text::SelLimits(*This)      ; Выделяем слово
                SelectionText(*This)
                
                ;                 \Items()\Text[2]\Change = 1
                ;                 \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                itemSelect(Item, \Items())
                Caret = Caret(*This, Item)
                
                If \Items()\Text\Caret[1] =- 1 : \Items()\Text\Caret[1] = 0
                  *This\Text\Caret[1] = 0
                  *This\Text\Caret = \Items()\Text\Len
                  SelectionText(*This)
                  Repaint = 1
                  
                Else
                  SelReset(*This)
                  
                  If \Items()\Text[2]\Len
                    
                    
                    
                  Else
                    
                    \Text\Caret = Caret
                    \Text\Caret[1] = \Text\Caret
                    \Index[1] = \Items()\Index 
                    \Index[2] = \Index[1]
                    
                    PushListPosition(\Items())
                    ForEach \Items() 
                      If \Index[2] <> ListIndex(\Items())
                        \Items()\Text[1]\String = ""
                        \Items()\Text[2]\String = ""
                        \Items()\Text[3]\String = ""
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    If \Text\Caret = DoubleClick
                      DoubleClick =- 1
                      \Text\Caret[1] = \Items()\Text\Len
                      \Text\Caret = 0
                    EndIf 
                    
                    SelectionText(*This)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = SelSet(*This, Item)
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
            Repaint | Editable(*This, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetActiveWindow() ; GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#__Flag_BorderLess)+1
        \bSize = \fSize
        
        \flag\buttons = Bool(flag&#__Flag_NoButtons)
        \Flag\Lines = Bool(flag&#__Flag_NoLines)
        \Flag\FullSelection = Bool(Not flag&#__Flag_FullSelection)*7
        \Flag\AlwaysSelection = Bool(flag&#__Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#__Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#__Flag_GridLines)
        
        \Text\Vertical = Bool(Flag&#__Flag_Vertical)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        
        If Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#PB_Text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Flag\MultiSelect = 1
        ;\Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        
        \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
        \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
        \Text\Align\Right = Bool(Flag&#PB_Text_Right)
        \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
        
        If \Text\Vertical
          \Text\X = \fSize 
          \Text\y = \fSize+2
        Else
          \Text\X = \fSize+2
          \Text\y = \fSize
        EndIf
        
        
        \Color = Colors
        \Color\Fore[0] = 0
        
        \sci\margin\width = Bool(Flag&#__Flag_Numeric)
        \sci\margin\Color\Back = $C8F0F0F0 ; \Color\Back[0] 
        
        \Row\color\alpha = 255
        \Row\Color = Colors
        \Row\Color\Fore[0] = 0
        \Row\Color\Fore[1] = 0
        \Row\Color\Fore[2] = 0
        \Row\Color\Back[0] = \Row\Color\Back[1]
        \Row\Color\Frame[0] = \Row\Color\Frame[1]
        ;\Color\Back[1] = \Color\Back[0]
        
        
        
        If \Text\Editable
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
      EndIf
      
      ; create scrollbars
      Bar::Bars(\Scroll, 16, 7, Bool(\Text\MultiLine <> 1))
      
      Resize(*This, X,Y,Width,Height)
      ;       \Text\String = #LF$
      ;       \Text\Change = 1  
      SetText(*This, Text.s)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      ;If Not *This\Repaint : *This\Repaint = 1
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint, *This)
      ;EndIf
      ;       PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      ;       BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
      ;       SetGadgetData(Canvas, *This)
      ;       BindGadgetEvent(Canvas, @Canvas_CallBack())
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This._s_widget = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint 
          If *This\Repaint : *This\Repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This._s_widget = AllocateStructure(_s_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        ;         PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
        ;         BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
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
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #__Flag_GridLines|#__Flag_Numeric|#PB_Text_WordWrap) 
    *g._s_widget=GetGadgetData(g)
    
    Editor::SetText(*g, Text.s) 
    ;Text::Redraw(*w)
    
    For a = 0 To 2
       Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::AddItem(*g, a, "")
    For a = 4 To 6
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::SetFont(*g, FontID(0))
    
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
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = +-----0------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP