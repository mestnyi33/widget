CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerEndIf

;-
;- XIncludeFile
;-
CompilerIf Not Defined(macros, #PB_Module)
  XIncludeFile "../macros.pbi"
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
  XIncludeFile "bar().pb"
CompilerEndIf

;-
DeclareModule Editor
  EnableExplicit
  UseModule macros
  UseModule constants
  UseModule structures
  
  Macro _get_colors_()
    colors::*this\blue
  EndMacro
  
  
  ;   Macro _const_
  ;     constants::#__
  ;   EndMacro
  
  ;   Macro _s_widget
  ;     structures::_s_widget
  ;   EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro GetActive() ; Returns active window
    *event\active
  EndMacro
  
  Macro SetActive(_this_) ; Returns active window
    *event\active\gadget = _this_
  EndMacro
  
  ;   Macro Widget() ; Returns widget
  ;     *event\widget
  ;   EndMacro
  ;   
  
  ;- - DECLAREs MACROs
  ;Declare.i Update(*this)
  
  ;- DECLARE
  Declare   SetFont(*this, FontID.i)
  
  Declare   GetState(*this)
  Declare   SetState(*this, State.l)
  
  Declare.s GetText(*this)
  Declare   SetText(*this, Text.s, Item.l=0)
  
  Declare   GetAttribute(*this, Attribute.i)
  Declare   SetAttribute(*this, Attribute.i, Value.i)
  
  Declare   SetItemState(*this, Item.l, State.i)
  Declare   GetItemState(*this, item.l)
  
  Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
  Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
  
  Declare   ClearItems(*this)
  Declare   CountItems(*this)
  Declare   RemoveItem(*this, Item.l)
  Declare   AddItem(*this, Item.l, Text.s, Image.i=-1, Flag.i=0)
  
  Declare   Draw(*this)
  Declare   ReDraw(*this)
  Declare   events(*this, EventType.l)
  Declare   events_key_editor(*this, eventtype.l, mouse_x.l, mouse_y.l)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i create(type.l, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
  
EndDeclareModule

Module Editor
  CompilerIf Defined(fixme, #PB_Module)
    UseModule fixme
  CompilerEndIf
  
  ;   Global *Buffer = AllocateMemory(10000000)
  ;   Global *Pointer = *Buffer
  ;   
  ;   Procedure.i Update(*this._s_widget)
  ;     *this\text\string.s = PeekS(*Buffer)
  ;     *this\text\change = 1
  ;   EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i g_callback()
  
  Macro _from_X_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_))
  EndMacro
  
  Macro _from_Y_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_from_X_(_mouse_x_, _mouse_y_, _type_, _mode_) And _from_Y_(_mouse_x_, _mouse_y_, _type_, _mode_))
  EndMacro
  
  
  Macro _repaint_(_this_)
    If _this_\root And Not _this_\repaint : _this_\repaint = 1
      PostEvent(#PB_Event_Gadget, _this_\root\window, _this_\root\canvas, #PB_EventType_Repaint);, _this_)
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
  
  
  ;-
  ;- PUBLIC
  Procedure _start_drawing_(*this._s_widget)
    If StartDrawing(CanvasOutput(*this\root\canvas)) 
      
      If *this\text\fontID
        DrawingFont(*this\text\fontID) 
      EndIf
      
      ProcedureReturn #True
    EndIf    
  EndProcedure
  
  ;-
  Macro _text_scroll_x_(_this_)
    *this\change = bar::_scrollarea_change_(*this\scroll\h, _this_\text\caret\x-(Bool(_this_\text\caret\x>0) * (_this_\scroll\h\x+_this_\text\_padding+_this_\text\x)), (_this_\text\_padding*2+_this_\text\x*2+_this_\row\margin\width+2)) ; ok
  EndMacro
  
  Macro _text_scroll_y_(_this_)
    *this\change = bar::_scrollarea_change_(*this\scroll\v, _this_\text\caret\y-(Bool(_this_\text\caret\y>0) * (_this_\scroll\v\y+_this_\text\_padding+_this_\text\y)), (_this_\text\_padding*2+_this_\text\y*2+_this_\text\caret\height)) ; ok
  EndMacro
  
  ;-
  Procedure.l _text_caret_(*this._s_widget)
    Protected i.l, X.l, Position.l =- 1,  
              MouseX.l, Distance.f, MinDistance.f = Infinity()
    
    MouseX = *this\root\mouse\x - *this\row\_s()\text\x
    
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
    
    Protected _line_ = *this\index[1]
    Protected _caret_last_len_ = Bool(_line_ <> *this\index[2] And 
                                      (*this\row\_s()\index < *this\index[1] Or 
                                       *this\row\_s()\index < *this\index[2])) * *this\flag\fullselection
    
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
      If *this\row\_s()\text\edit[2]\width And Not (_line_ = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]) And
         *this\row\_s()\text\edit[2]\width <> *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
        *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
      EndIf
    CompilerEndIf
    
    ; для красоты
    If *this\row\_s()\text\edit[2]\width > *this\scroll\width
      *this\row\_s()\text\edit[2]\width - _caret_last_len_
    EndIf
    
    ; set position (left;selected;right)
    *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x[2] 
    *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x+*this\row\_s()\text\edit[1]\width) 
    *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x+*this\row\_s()\text\edit[2]\width)
    
    ; если выделили свнизу вверх
    ; то запоминаем позицию начала текста[3]
    If *this\index[2] >= *this\row\_s()\index
      *this\text\edit[1]\len = (*this\row\_s()\text\pos+*this\row\_s()\text\edit[2]\pos)
      *this\text\edit[2]\pos = *this\text\edit[1]\len
    EndIf
    
    ; если выделили сверху ввниз
    ; то запоминаем позицию начала текста[3]
    If *this\index[2] =< *this\row\_s()\index
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
      
      If _line_ > *this\index[2] Or
         (_line_ = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
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
        If (_line_ = *this\row\_s()\index Or *this\index[2] = *this\row\_s()\index) Or    ; линия
           (_line_ < *this\row\_s()\index And *this\index[2] > *this\row\_s()\index) Or   ; верх
           (_line_ > *this\row\_s()\index And *this\index[2] < *this\row\_s()\index)      ; вниз
          
          If _line_ = *this\index[2]  ; And *this\index[2] = *this\row\_s()\index
            If *this\text\caret\pos[1] > *this\text\caret\pos[2]
              _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
            Else
              _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
            EndIf
            
          ElseIf (_line_ < *this\row\_s()\index And *this\index[2] > *this\row\_s()\index) Or   ; верх
                 (_line_ > *this\row\_s()\index And *this\index[2] < *this\row\_s()\index)      ; вниз
            
            If _line_ < 0
              ; если курсор перешел за верхный предел
              *this\index[1] = 0
              *this\text\caret\pos[1] = 0
            ElseIf _line_ > *this\count\items - 1
              ; если курсор перешел за нижный предел
              *this\index[1] = *this\count\items - 1
              *this\text\caret\pos[1] = *this\row\_s()\text\len
            EndIf
            
            _edit_sel_(*this, 0, *this\row\_s()\text\len)
            
          ElseIf _line_ = *this\row\_s()\index 
            If _line_ > *this\index[2] 
              _edit_sel_(*this, 0, *this\text\caret\pos[1])
            Else
              _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
            EndIf
            
          ElseIf *this\index[2] = *this\row\_s()\index
            
            
            If *this\count\items = 1 And 
               (_line_ < 0 Or _line_ > *this\count\items - 1)
              ; если курсор перешел за пределы итемов
              *this\index[1] = 0
              
              If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                _edit_sel_(*this, 0, *this\text\caret\pos[2])
              Else
                *this\text\caret\pos[1] = *this\row\_s()\text\len
                _edit_sel_(*this, *this\text\caret\pos[2], Bool(_line_ <> *this\index[2]) * (*this\row\_s()\text\len - *this\text\caret\pos[2]))
              EndIf
              
              *this\index[1] = _line_
            Else
              If _line_ < 0
                *this\index[1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                *this\index[1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s()\text\len
              EndIf
              
              If *this\index[2] > _line_ 
                _edit_sel_(*this, 0, *this\text\caret\pos[2])
              Else
                _edit_sel_(*this, *this\text\caret\pos[2], (*this\row\_s()\text\len - *this\text\caret\pos[2]))
              EndIf
            EndIf
            
          EndIf
          
          If *this\index[1] = *this\row\_s()\index
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
                *this\index[2] <> *this\row\_s()\index And _line_ <> *this\row\_s()\index)
          
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
          If *this\index[1] <> _line_
            *this\index[1] = _line_
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
          
          If *this\index[1] <> _line_ 
            *this\index[1] = _line_ ; scroll vertical
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
    If *this\index[2] = *this\row\_s()\index 
      *this\row\selected = *this\row\_s()
      
      If *this\index[2] = *this\index[1]
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
    
    
    
    
    Protected  _line_ = *this\index[1]
    
    
    If _line_ = *this\index[2]  ; And *this\index[2] = *this\row\_s()\index
      If *this\text\caret\pos[1] > *this\text\caret\pos[2]
        _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
      Else
        _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
      EndIf
      
    ElseIf (*this\index[2] > *this\row\_s()\index And _line_ < *this\row\_s()\index) Or   ; верх
           (*this\index[2] < *this\row\_s()\index And _line_ > *this\row\_s()\index)      ; вниз
      
      _edit_sel_(*this, 0, *this\row\_s()\text\len)
      
    ElseIf _line_ = *this\row\_s()\index 
      If _line_ > *this\index[2] 
        _edit_sel_(*this, 0, *this\text\caret\pos[1])
      Else
        _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
      EndIf
      
    ElseIf *this\index[2] = *this\row\_s()\index
      If *this\index[2] > _line_ 
        _edit_sel_(*this, 0, *this\text\caret\pos[2])
      Else
        _edit_sel_(*this, *this\text\caret\pos[2], *this\row\_s()\text\len - *this\text\caret\pos[2])
      EndIf
      
    EndIf
    
    
    
    
    
    
    ProcedureReturn 
    
    If (*this\index[2] = *this\row\_s()\index Or *this\index[1] = *this\row\_s()\index) Or    ; линия
       (*this\index[2] > *this\row\_s()\index And *this\index[1] < *this\row\_s()\index) Or   ; верх
       (*this\index[2] < *this\row\_s()\index And *this\index[1] > *this\row\_s()\index)      ; вниз
      
      If (*this\index[2] > *this\row\_s()\index And *this\index[1] < *this\row\_s()\index) Or   ; верх
         (*this\index[2] < *this\row\_s()\index And *this\index[1] > *this\row\_s()\index)      ; вниз
        
        *this\row\_s()\text\edit[1]\len = 0 
        *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
        
      ElseIf *this\index[1] = *this\row\_s()\index 
        If *this\index[1] > *this\index[2] 
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[1]
        Else
          *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[1] 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
        EndIf
        
      ElseIf *this\index[2] = *this\row\_s()\index
        If *this\index[2] > *this\index[1] 
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
          *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + Bool((*this\index[1] <  *this\index[2] And *this\row\_s()\index = *this\index[1]) Or
                                                                                                   ; (*this\index[1] <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
          (*this\index[1]  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\flag\fullselection
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
      If *this\index[1] = *this\row\_s()\index 
        *this\text\caret\y = *this\row\_s()\text\y
        *this\text\caret\height = *this\row\_s()\text\height
        
        If *this\index[1] > *this\index[2] Or
           (*this\index[1] = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
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
      If \index[1] <> \index[2] ; Это значить строки выделени
        If \index[2] > \index[1] : Swap \index[2], \index[1] : EndIf
        
        If \row\_s()\index <> \index[2]
          SelectElement(\row\_s(), \index[2])
        EndIf
          
        If Count
          \index[2] + Count
          \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \index[2] + 1
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
        \index[1] = \index[2]
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
            \index[2] + Count
            \index[1] = \index[2] 
            \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret\pos[1] + Len(Chr.s) 
          EndIf
          
          \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
          \text\caret\pos[2] = \text\caret\pos[1] 
          ;; \count\items = CountString(\text\string.s, #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\row\_s(), \index[2]) 
        result = 1 
      EndIf
    EndWith
    
    If result =- 1
      *this\notify = 1
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  ;-
  Macro _make_line_pos_(_this_, _len_)
    _this_\row\_s()\text\len = _len_
    _this_\row\_s()\text\pos = _this_\text\pos
    _this_\text\pos + _this_\row\_s()\text\len + 1 ; Len(#LF$)
  EndMacro
  
  Macro _make_line_x_(_this_, _scroll_width_)
    If _this_\vertical
      If _this_\text\rotate = 90
        _this_\row\_s()\text\x[2] = _this_\text\x + _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      ElseIf _this_\text\rotate = 270
        _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      EndIf
      
    Else
      If _this_\text\rotate = 0
        If _this_\text\align\right
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_\row\_s()\text\width) 
        ElseIf _this_\text\align\horizontal
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ - _this_\row\_s()\text\width)/2
        Else
          _this_\row\_s()\text\x[2] = _this_\text\x
        EndIf
        
      ElseIf _this_\text\rotate = 180
        If _this_\text\align\right
          _this_\row\_s()\text\x[2] = _this_\text\x + _scroll_width_
        ElseIf _this_\text\align\horizontal
          _this_\row\_s()\text\x[2] = _this_\text\x + (_scroll_width_ + _this_\row\_s()\text\width)/2 
        Else
          _this_\row\_s()\text\x[2] = _this_\text\x + _this_\row\_s()\text\width 
        EndIf
        
      EndIf
    EndIf
    
    _this_\row\_s()\text\x = _x_ + _this_\row\_s()\text\x[2] + _this_\scroll\x
  EndMacro
  
  Macro _make_line_y_(_this_, _scroll_height_)
    If _this_\vertical
      If _this_\text\rotate = 90
        If _this_\text\align\bottom
          _this_\row\_s()\text\y[2] = _this_\text\y + _scroll_height_ 
        ElseIf _this_\text\align\vertical
          _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ + _this_\row\_s()\text\width)/2
        Else
          _this_\row\_s()\text\y[2] = _this_\text\y + _this_\row\_s()\text\width
        EndIf
        
      ElseIf _this_\text\rotate = 270
        If _this_\text\align\bottom
          _this_\row\_s()\text\y[2] = _this_\text\y + ((_scroll_height_ - _this_\row\_s()\text\width) ) 
        ElseIf _this_\text\align\vertical
          _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ - _this_\row\_s()\text\width)/2 
        Else
          _this_\row\_s()\text\y[2] = _this_\text\y
        EndIf
        
      EndIf
      
    Else
      If _this_\text\rotate = 0
        _this_\row\_s()\text\y[2] = _this_\text\y + _this_y_ - Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      ElseIf _this_\text\rotate = 180
        _this_\row\_s()\text\y[2] = _this_\text\y + (_scroll_height_ - _this_y_) + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        
      EndIf
    EndIf
    
    _this_\row\_s()\text\y = _y_ + _this_\row\_s()\text\y[2]
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
       _this_\scroll\v\bar\scroll_step <> _height_ + Bool(_this_\flag\gridlines)
      _this_\scroll\v\bar\scroll_step = _height_ + Bool(_this_\flag\gridlines)
    EndIf
  EndMacro
  
  Macro _make_scroll_width_(_this_, _width_)
    If _this_\vertical
      If _this_\text\multiline =- 1 And _this_\scroll\v
        _this_\scroll\height = bar::make_area_height(_this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
      Else
        If _this_\scroll\height < _width_ + _this_\text\y*2 + _this_\text\caret\height
          _this_\scroll\height = _width_ + _this_\text\y*2 + _this_\text\caret\height
        EndIf
      EndIf
    Else
      If _this_\text\multiline =- 1 And _this_\scroll\h
        _this_\scroll\width = bar::make_area_width(_this_\scroll, _this_\width - _this_\bs*2 - _this_\text\_padding*2, _this_\height - _this_\bs*2 - _this_\text\_padding*2)
      Else
        If _this_\scroll\width < _width_ + _this_\text\x*2 + _this_\text\caret\width
          _this_\scroll\width = _width_ + _this_\text\x*2 + _this_\text\caret\width
        EndIf
      EndIf
    EndIf
  EndMacro
  
  
  Procedure.s make_text_wrap(*this._s_widget, text$, softWrapPosn.i, hardWrapPosn.i=-1, delimList$=" "+Chr(9), nl$=#LF$, liStart$="")
    ; ## Main function ##
    ; -- Word wrap in *one or more lines* of a text file, or in a window with a fixed-width font
    ; in : text$       : text which is to be wrapped;
    ;                    may contain #CRLF$ (Windows), or #LF$ (Linux and modern Mac systems) as line breaks
    ;      softWrapPosn: the desired maximum length (number of characters) of each resulting line
    ;                    if a delimiter was found (not counting the length of the inserted nl$);
    ;                    if no delimiter was found at a position <= softWrapPosn, a line might
    ;                    still be longer if hardWrapPosn = 0 or > softWrapPosn
    ;      hardWrapPosn: guaranteed maximum length (number of characters) of each resulting line
    ;                    (not counting the length of the inserted nl$);
    ;                    if hardWrapPosn <> 0, each line will be wrapped at the latest at
    ;                    hardWrapPosn, even if it doesn't contain a delimiter;
    ;                    default setting: hardWrapPosn = softWrapPosn
    ;      delimList$  : list of characters which are used as delimiters;
    ;                    any delimiter in line$ denotes a position where a soft wrap is allowed
    ;      nl$         : string to be used as line break (normally #CRLF$ or #LF$)
    ;      liStart$    : string at the beginning of each list item
    ;                    (providing this information makes proper indentation possible)
    ;
    ; out: return value: text$ with given nl$ inserted at appropriate positions
    ;
    ; <http://www.purebasic.fr/english/viewtopic.php?f=12&t=53800>
    Protected.i numLines, i, indentLen=-1, length, TextWidth
    Protected line$, line1$, indent$, ret$="", ret1$="", start, start1, found, length1
    
    Protected *str.Character = @text$
    Protected *end.Character = @text$
    
    If hardWrapPosn < 0
      length = softWrapPosn/6
    Else
      length = softWrapPosn 
    EndIf
    
    If softWrapPosn < 10
      softWrapPosn = 10
    EndIf
    
      While *end\c 
        If *end\c = #LF
          start = (*end-*str)>>#PB_Compiler_Unicode
          line$ = PeekS (*str, start)
          
          ; Get text len
          If hardWrapPosn < 0
            If length <> start
              length = start
              
              While length > 1
                If softWrapPosn >= TextWidth(Left(line$, length))
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          EndIf
          
          While start > length
            For i = length To 1 Step - 1
              If FindString(" ", Mid(line$,i,1))
                start = i
                Break
              EndIf
            Next
            
            If i = 0 
              start = length
            EndIf
            
            ret$ + RTrim(Left(line$, start)) + nl$
            line$ = LTrim(Mid(line$, start+1))
            start = Len(line$)
          Wend
          
          ret$ + line$ + nl$
          
          *str = *end + #__sOC 
        EndIf 
        
        *end + #__sOC 
      Wend
    
    ProcedureReturn ret$
  EndProcedure
  
  Procedure.i make_text_multiline(*this._s_widget)
    ;*this\text\string.s = make_multiline(*this, *this\text\string.s+#LF$) : ProcedureReturn
    
    Static string_out.s
    Protected Repaint, String.s, text_width, len, text.s
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      Protected *str.Character = @text
      Protected *end.Character = @text
      
      Protected _x_=*this\x[2], 
                _y_=*this\y[2], 
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
        text = make_text_wrap(*this, *this\text\string+#LF$, width, \text\multiline)
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
                \row\_s()\y = _y_ + \text\y + _this_y_
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
                If *this\row\_s()\index = *this\index[1]
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
                  *this\row\_s()\margin\y = *this\y[2] + *this\row\margin\width - TextWidth(*this\row\_s()\margin\string) - 3
                Else
                  *this\row\_s()\margin\y = \row\_s()\text\y
                  *this\row\_s()\margin\x = *this\x[2] + *this\row\margin\width - TextWidth(*this\row\_s()\margin\string) - 3
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
        If \countitems = 0
          \scroll\width = 0
        Else
          \scroll\height = 0
        EndIf
        Debug  "---- updatelist ----"
        
        ForEach \row\_s()
          If Not \row\_s()\hide
            If \countitems = 0
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
            
            If \countitems = 0
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
            Bar::SetAttribute(*this\scroll\v, #__bar_minimum, -*this\scroll\y)
          EndIf
          
          If *this\scroll\v\bar\max <> *this\scroll\height 
            Bar::SetAttribute(*this\scroll\v, #__bar_maximum, *this\scroll\height)
          EndIf
          
          ; This is for the caret and scroll when entering the key - (enter & backspace) 
          If *this\text\change
            _text_scroll_y_(*this)
          EndIf
        EndIf
        
        If *this\scroll\h
          If *this\scroll\h\bar\min <> -*this\scroll\x
            Bar::SetAttribute(*this\scroll\h, #__bar_minimum, -*this\scroll\x)
          EndIf
          
          If *this\scroll\h\bar\max <> *this\scroll\width 
            Bar::SetAttribute(*this\scroll\h, #__bar_maximum, *this\scroll\width)
          EndIf
          
          ; This is for the caret and scroll when entering the key - (enter & backspace) 
          If *this\text\change
            _text_scroll_x_(*this)
          EndIf
        EndIf
        
        If bar::_scrollarea_update_(*this)
          \height[2] = \scroll\v\bar\page\len
          \width[2] = \scroll\h\bar\page\len 
        EndIf
      EndIf 
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  ;-
  ;- - DRAWINGs
  Procedure Draw(*this._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width, Drawing
    
    If Not *this\hide
      
      With *this
        ; Draw back color
        If \color\fore[\color\state]
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\back[\color\state])
        EndIf
        
        ;
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        ; Then changed text
        If \text\change
          \text\height = TextHeight("A")
          \text\width = TextWidth(\text\string.s)
        EndIf
        
        ; Then resized widget
        If \resize
          ; Посылаем сообщение об изменении размера 
          ; PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Resize, \resize)
          Bar::Resizes(\scroll, \x[0]+\bs, \y[0]+\bs, \width[0]-\bs*2, \height[0]-\bs*2)
          
          ;           ; ;           Macro get_scroll_area_height(_this_)
          ;           ; ;             (_this_\height - _this_\bs*2 - (Bool((_this_\scroll\width > _this_\width - _this_\bs*2) Or Not _this_\scroll\h\hide) * _this_\scroll\h\height) + Bool(_this_\scroll\v\round And _this_\scroll\h\round And Not _this_\scroll\h\hide) * (_this_\scroll\h\height/4)) 
          ;           ; ;           EndMacro
          ;           ; ;           
          ;           ; ;           Macro get_scroll_area_width(_this_)
          ;           ; ;             (_this_\width - _this_\bs*2 - (Bool((_this_\scroll\height > _this_\height - _this_\bs*2) Or Not _this_\scroll\v\hide) * _this_\scroll\v\width) + Bool(_this_\scroll\v\round And _this_\scroll\h\round And Not _this_\scroll\v\hide) * (_this_\scroll\v\width/4))
          ;           ; ;           EndMacro
          ;           ; ;           
          ;           ; ;           Macro get_scroll_height(_this_)
          ;           ; ;             (_this_\v\height - Bool(_this_\v\round And _this_\h\round And Not _this_\h\hide) * (_this_\h\height/4)) 
          ;           ; ;           EndMacro
          ;           ; ;           
          ;           ; ;           Macro get_scroll_width(_this_)
          ;           ; ;             (_this_\h\width - Bool(_this_\v\round And _this_\h\round And Not _this_\v\hide) * (_this_\v\width/4))
          ;           ; ;           EndMacro
          ;           ; ;           
          ;           ; ;           \scroll\v\hide = Bar::Resize(\scroll\v, \x[0]+\width[0]-\bs - \scroll\v\width, \y[0]+\bs, #PB_Ignore, get_scroll_area_height(*this))
          ;           ; ;           Bar::SetAttribute(*this\scroll\v, #__bar_pagelength, get_scroll_height(*this\scroll))
          ;           ; ;           
          ;           ; ;           \scroll\h\hide = Bar::Resize(\scroll\h, \x[0]+\bs, \y[0]+\height[0]-\bs - \scroll\h\height, get_scroll_area_width(*this), #PB_Ignore)
          ;           ; ;           Bar::SetAttribute(*this\scroll\h, #__bar_pagelength, get_scroll_width(*this\scroll))
          ;           ; ;           
          ;           ; ;           \scroll\v\hide = Bar::Resize(\scroll\v, \x[0]+\width[0]-\bs - \scroll\v\width, \y[0]+\bs, #PB_Ignore, get_scroll_area_height(*this))
          ;           ; ;           Bar::SetAttribute(*this\scroll\v, #__bar_pagelength, get_scroll_height(*this\scroll))
          ;           ; ;           
          ;           ; ;           \scroll\h\hide = Bar::Resize(\scroll\h, \x[0]+\bs, \y[0]+\height[0]-\bs - \scroll\h\height, get_scroll_area_width(*this), #PB_Ignore)
          ;           ; ;           Bar::SetAttribute(*this\scroll\h, #__bar_pagelength, get_scroll_width(*this\scroll))
          ;           
          ;           
          ;           Bar::SetAttribute(*this\scroll\v, #__bar_pagelength, Bar::make_area_height(*this\scroll, *this\width - *this\bs*2, *this\height - *this\bs*2))
          ;           \scroll\v\hide = Bar::Resize(\scroll\v, \x[0]+\width[0]-\bs - \scroll\v\width, \y[0]+\bs, #PB_Ignore, Bar::_get_page_height_(*this\scroll, 1))
          ;           
          ;           Bar::SetAttribute(*this\scroll\h, #__bar_pagelength, Bar::make_area_width(*this\scroll, *this\width - *this\bs*2, *this\height - *this\bs*2))
          ;           \scroll\h\hide = Bar::Resize(\scroll\h, \x[0]+\bs, \y[0]+\height[0]-\bs - \scroll\h\height, Bar::get_page_width(*this\scroll, 1), #PB_Ignore)
          ;           
          ;           If Bar::SetAttribute(*this\scroll\v, #__bar_pagelength, Bar::make_area_height(*this\scroll, *this\width - *this\bs*2, *this\height - *this\bs*2))
          ;             \scroll\v\hide = Bar::Resize(\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Bar::_get_page_height_(*this\scroll, 1))
          ;           EndIf
          ;           
          ;           If Bar::SetAttribute(*this\scroll\h, #__bar_pagelength, Bar::make_area_width(*this\scroll, *this\width - *this\bs*2, *this\height - *this\bs*2))
          ;             \scroll\h\hide = Bar::Resize(\scroll\h, #PB_Ignore, #PB_Ignore, Bar::get_page_width(*this\scroll, 1), #PB_Ignore)
          ;           EndIf
          ;           
          
          
          If \scroll\h
            \width[2] = \scroll\h\bar\page\len 
          EndIf
          If \scroll\v
            \height[2] = \scroll\v\bar\page\len
          EndIf
        EndIf
        
        ; Make output multi line text
        If (\text\change Or (\resize And \text\multiline =- 1))
          make_text_multiline(*this)
        EndIf
        
        ; Draw margin back color
        If \row\margin\width > 0
          If (\text\change Or \resize)
            \row\margin\x = \x[2]
            \row\margin\y = \y[2]
            \row\margin\height = \height[2]
          EndIf
          
          ; Draw margin
          DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
          Box(\row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back)
        EndIf
        
        ; Widget inner coordinate
        iX=\x[2] + \row\margin\width 
        iY=\y[2]
        iwidth = \width[2]
        iheight = \height[2]
        
        ; Draw Lines text
        If \count\items And \scroll\v And \scroll\h
          PushListPosition(\row\_s())
          ForEach \row\_s()
            ; Is visible lines ---
            \row\_s()\draw = Bool(Not \row\_s()\hide And 
                                  \row\_s()\y+\row\_s()\height+*this\scroll\y>*this\y[2] And 
                                  (\row\_s()\y-*this\y[2])+*this\scroll\y<*this\height[2])
            
            If (*this\text\change Or *this\resize) Or *this\scroll\h\change
                *this\row\_s()\text\x = (*this\x[2] + *this\row\_s()\text\x[2]) + *this\scroll\x
              ;  *this\row\_s()\text\y = *this\y[2] + *this\row\_s()\text\y[2] + *this\scroll\y
              EndIf
              
             
            ; Draw selections
            If *this\row\_s()\draw 
              Y = *this\row\_s()\y + *this\scroll\y
              Text_X = *this\row\_s()\text\x ;+ *this\scroll\x
              Text_Y = *this\row\_s()\text\y + *this\scroll\y
              
              Protected text_x_sel = \row\_s()\text\edit[2]\x + *this\scroll\x
              Protected sel_x = \x[2] + *this\text\y
              Protected sel_width = \width[2] - *this\text\y*2
              Protected text_sel_state = 2 + Bool(GetActive()\gadget <> *this)
              Protected text_sel_width = \row\_s()\text\edit[2]\width + Bool(GetActive()\gadget <> *this) * *this\text\caret\width
              Protected text_state = *this\row\_s()\color\state
              
              text_state = Bool(*this\row\_s()\index = *this\index[1]) + Bool(*this\row\_s()\index = *this\index[1] And GetActive()\gadget <> *this)*2
              
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
                      Line(*this\x[2]+*this\row\margin\width, *this\row\_s()\y, 1, *this\row\_s()\height, *this\color\Back) ; $FF000000);
                    EndIf
                  EndIf
                EndIf
                
                ; Draw entered selection
                ; GetActive()\gadget = *this
                If text_state ; *this\row\_s()\index = *this\index[1] ; \color\state;
                  If *this\row\_s()\color\back[text_state]<>-1              ; no draw transparent
                    If *this\row\_s()\color\fore[text_state]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,sel_x,Y,sel_width, *this\row\_s()\height, *this\row\_s()\color\fore[text_state], *this\row\_s()\color\back[text_state], *this\row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[text_state] )
                    EndIf
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
                  If (*this\index[1] > *this\index[2] Or 
                      (*this\index[1] = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                    
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    
                  Else
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height,*this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state] )
                    EndIf
                    
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
                  If *this\row\_s()\color\fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                  EndIf
                  
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
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round, $FF0000FF)
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
        ElseIf *this\bs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[\color\state])
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
        EndIf
        
        ; Draw scroll bars
        bar::_scrollarea_draw_(*this)
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure ReDraw(*this._s_widget)
    If *this And *this\root And StartDrawing(CanvasOutput(*this\root\canvas))
      ; If *this\root\fontID : DrawingFont(*this\root\fontID) : EndIf
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FFf0f0f0)
      
      Draw(*this) 
      StopDrawing()
    EndIf
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure   AddItem(*this._s_widget, Item.l,Text.s,Image.i=-1,Flag.i=0)
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
  
  Procedure   SetAttribute(*this._s_widget, Attribute.i, Value.i)
    With *this
      
    EndWith
  EndProcedure
  
  Procedure   GetAttribute(*this._s_widget, Attribute.i)
    Protected Result
    
    With *this
      ;       Select Attribute
      ;         Case #__bar_Minimum    : Result = \scroll\bar\min
      ;         Case #__bar_Maximum    : Result = \scroll\bar\max
      ;         Case #__bar_PageLength : Result = \scroll\bar\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure   SetItemState(*this._s_widget, Item.l, State.i)
    Protected Result
    Protected i.l, len.l
    
    With *this
      If state < 0 Or 
         state > *this\text\len
        state = *this\text\len
      EndIf
      
      ;       If *this\text\caret\pos <> State
      ;         *this\text\caret\pos = State
      If *this\text\caret\pos <> State
        
        Protected *str.Character = @\text\string 
        Protected *end.Character = @\text\string 
        
        While *end\c 
          If *end\c = #LF 
            i + 1
            len + (*end-*str)/#__sOC
            ; Debug ""+Item+" "+Str(len + Item) +" "+ state
            
            If i = Item 
              *this\index[1] = Item
              *this\index[2] = Item
              
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
        If *this\index[1] <> Item 
          *this\index[1] = Item
          *this\index[2] = Item
          
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
  
  Procedure   GetItemState(*this._s_widget, item.l)
    If item =- 1
      ProcedureReturn *this\text\caret\pos
    Else
      ProcedureReturn *this\text\caret\pos[1]
    EndIf
  EndProcedure
  
  Procedure   SetState(*this._s_widget, State.l) ; Ok
    Protected i.l, len.l
    
    With *this
      If state < 0 Or 
         state > *this\text\len
        state = *this\text\len
      EndIf
      
      If *this\text\caret\pos <> State
        *this\text\caret\pos = State
        
        Protected *str.Character = @\text\string 
        Protected *end.Character = @\text\string 
        
        While *end\c 
          If *end\c = #LF 
            len + (*end-*str)/#__sOC
            ; Debug ""+i+" "+Str(len + i) +" "+ state
            
            If len + i >= state
              *this\index[1] = i
              *this\index[2] = i
              
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
        If *this\index[1] <> i 
          *this\index[1] = i
          *this\index[2] = i
          
          *this\text\caret\pos[1] = (state - len - i) 
          *this\text\caret\pos[2] = *this\text\caret\pos[1]
        EndIf
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure   GetState(*this._s_widget)
    ProcedureReturn *this\index[2] ; *this\text\caret\pos
  EndProcedure
  
  Procedure   ClearItems(*this._s_widget)
    *this\count\items = 0
    *this\text\change = 1 
    
    If *this\text\editable
      *this\text\string = #LF$
    EndIf
    
    _repaint_(*this)
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*this._s_widget)
    ProcedureReturn *this\count\items
  EndProcedure
  
  Procedure.i RemoveItem(*this._s_widget, Item.l)
    *this\count\items - 1
    *this\text\change = 1
    
    If *this\count\items =- 1 
      *this\count\items = 0 
      *this\text\string = #LF$
      
      _repaint_(*this)
      
    Else
      *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item+1, #LF$) + #LF$)
    EndIf
  EndProcedure
  
  Procedure.s GetText(*this._s_widget)
    With *this
      If \text\pass
        ProcedureReturn \text\edit\string
      Else
        ProcedureReturn \text\string
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*this._s_widget, Text.s, Item.l=0)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    Text.s = ReplaceString(Text.s, #CR$, #LF$)
    
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
          
          ;           If *this And StartDrawing(CanvasOutput(*this\root\canvas))
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
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*this._s_widget, FontID.i)
    
    With *this
      If \text\fontID <> FontID 
        \text\fontID = FontID
        \text\change = 1
        
        If Not Bool(\text\count And \text\count <> \count\items)
          Redraw(*this)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
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
        If Item >= 0 And Item < *this\count\items And SelectElement(*this\row\_s(), Item)
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
  
  Procedure.l GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l=0)
    Protected Result
    
    With *this
      If Item >= 0 And Item < *this\count\items And SelectElement(*this\row\_s(), Item)
        Select ColorType
          Case #__color_back
            Result = \row\_s()\color\back[Column]
            
          Case #__color_front
            Result = \row\_s()\color\front[Column]
            
          Case #__color_frame
            Result = \row\_s()\color\frame[Column]
            
          Case #__color_line
            Result = \row\_s()\color\line[Column]
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    With *this
      If x>=0 And X<>#PB_Ignore And 
         \x[0] <> X
        \x[0] = X 
        \x[2]=\x[0]+\bs
        \x[1]=\x[2]-\fs
        \resize = 1<<1
      EndIf
      If y>=0 And Y<>#PB_Ignore And 
         \y[0] <> Y
        \y[0] = Y
        \y[2]=\y[0]+\bs
        \y[1]=\y[2]-\fs
        \resize = 1<<2
      EndIf
      If Width>=0 And Width<>#PB_Ignore And
         \width[0] <> Width 
        \width[0] = Width 
        \width[2] = \width[0]-\bs*2
        \width[1] = \width[2]+\fs*2
        \resize = 1<<3
      EndIf
      If Height>=0 And Height<>#PB_Ignore And 
         \height[0] <> Height
        \height[0] = Height 
        \height[2] = \height[0]-\bs*2
        \height[1] = \height[2]+\fs*2
        \resize = 1<<4
      EndIf
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure   events_key_editor(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
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
        Case #PB_EventType_Input ; - Input (key)
          If Not _key_control_   ; And Not _key_shift_
            If Not *this\notify And *this\root\keyboard\input
              
              Repaint = _text_insert_(*this, Chr(*this\root\keyboard\input))
              
            EndIf
          EndIf
          
        Case #PB_EventType_KeyUp
          ; Чтобы перерисовать 
          ; рамку вокруг едитора 
          ; reset all errors
          If \notify 
            \notify = 0
            ProcedureReturn - 1
          EndIf
          
        Case #PB_EventType_KeyDown
          Select *this\root\keyboard\key
            Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
              If _key_control_ : *this\index[2] = 0 : EndIf
              Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
              
            Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
              If _key_control_ : *this\index[2] = *this\count\items - 1 : EndIf
              Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
              
            Case #PB_Shortcut_PageUp   ;: Repaint = ToPos(*this, 1, 1)
              
            Case #PB_Shortcut_PageDown ;: Repaint = ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A        ; Ok
              If _key_control_ And
                 \text\edit[2]\len <> \text\len
                
                ; set caret to begin
                \text\caret\pos[2] = 0 
                \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                
                ; select first item
                \index[2] = 0 
                \index[1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                
                Repaint = _edit_sel_draw_(*this, \count\items - 1, \text\len)
              EndIf
              
            Case #PB_Shortcut_Up       ; Ok
              If *this\index[1] > _line_first_
                If _caret_last_pos_
                  If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[1] = _caret_last_pos_
                    *this\text\caret\pos[2] = _caret_last_pos_
                  EndIf
                  _caret_last_pos_ = 0
                EndIf
                
                If _key_shift_
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                    Repaint = _edit_sel_draw_(*this, 0, 0)  
                  Else
                    Repaint = _edit_sel_draw_(*this, *this\index[1] - _step_, *this\text\caret\pos[1])  
                  EndIf
                ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  If *this\text\caret\pos[1] <> _caret_min_ 
                    *this\text\caret\pos[2] = _caret_min_
                  Else
                    *this\index[2] - _step_ 
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                  
                Else
                  If _key_control_
                    *this\index[2] = 0
                    *this\text\caret\pos[2] = 0
                  Else
                    *this\index[2] - _step_
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
                EndIf
              ElseIf *this\index[1] = _line_first_
                
                If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                  Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
            Case #PB_Shortcut_Down     ; Ok
              If *this\index[1] < _line_last_
                If _caret_last_pos_
                  If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt And Not _key_control_
                    *this\text\caret\pos[1] = _caret_last_pos_
                    *this\text\caret\pos[2] = _caret_last_pos_
                  EndIf
                  _caret_last_pos_ = 0
                EndIf
                
                If _key_shift_
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                    Repaint = _edit_sel_draw_(*this, \count\items - 1, *this\text\len)  
                  Else
                    Repaint = _edit_sel_draw_(*this, *this\index[1] + _step_, *this\text\caret\pos[1])  
                  EndIf
                ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  If *this\text\caret\pos[1] <> _caret_max_ 
                    *this\text\caret\pos[2] = _caret_max_
                  Else
                    *this\index[2] + _step_ 
                    
                    If SelectElement(*this\row\_s(), *this\index[2]) 
                      _caret_max_ = *this\row\_s()\text\len
                      
                      If *this\text\caret\pos[1] <> _caret_max_
                        *this\text\caret\pos[2] = _caret_max_
                        
                        Debug ""+#PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                  
                Else
                  If _key_control_
                    *this\index[2] = \count\items - 1
                    *this\text\caret\pos[2] = *this\text\len
                  Else
                    *this\index[2] + _step_
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
              ElseIf *this\index[1] = _line_last_
                
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
                  Repaint = _edit_sel_draw_(*this, *this\index[2], 0)  
                Else
                  _line_ = *this\index[1] - Bool(*this\index[1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_) * _step_
                  
                  ; коректируем позицию коректора
                  If *this\row\_s()\index <> _line_ And
                     SelectElement(*this\row\_s(), _line_) 
                  EndIf
                  If *this\text\caret\pos[1] > *this\row\_s()\text\len
                    *this\text\caret\pos[1] = *this\row\_s()\text\len
                  EndIf
                  
                  If *this\index[1] <> _line_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\row\_s()\text\len)  
                  ElseIf *this\text\caret\pos[1] > _caret_min_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] - _step_)  
                  EndIf
                EndIf
                
              ElseIf *this\index[1] > _line_first_
                If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  *this\text\caret\pos[2] = _edit_sel_start_(*this)
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
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
                      *this\index[2] - _step_
                      
                      If SelectElement(*this\row\_s(), *this\index[2]) 
                        *this\text\caret\pos[1] = *this\row\_s()\text\len
                        *this\text\caret\pos[2] = *this\row\_s()\text\len
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
                
              ElseIf *this\index[1] = _line_first_
                
                If *this\text\caret\pos[1] > _caret_min_ 
                  *this\text\caret\pos[2] - _step_
                  Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
            Case #PB_Shortcut_Right    ; Ok
              If _key_shift_       
                If _key_control_
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\len)  
                Else
                  If *this\row\_s()\index <> *this\index[1] And
                     SelectElement(*this\row\_s(), *this\index[1]) 
                    _caret_max_ = *this\row\_s()\text\len
                  EndIf
                  
                  If *this\text\caret\pos[1] > _caret_max_
                    *this\text\caret\pos[1] = _caret_max_
                  EndIf
                  
                  _line_ = *this\index[1] + Bool(*this\index[1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_) * _step_
                  
                  ; если дошли в конец строки,
                  ; то переходим в начало
                  If *this\index[1] <> _line_ 
                    Repaint = _edit_sel_draw_(*this, _line_, 0)  
                  ElseIf *this\text\caret\pos[1] < _caret_max_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] + _step_)  
                  EndIf
                EndIf
                
              ElseIf *this\index[1] < _line_last_
                If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  *this\text\caret\pos[2] = _edit_sel_stop_(*this)
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
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
                      *this\index[2] + _step_
                      
                      If SelectElement(*this\row\_s(), *this\index[2]) 
                        *this\text\caret\pos[1] = 0
                        *this\text\caret\pos[2] = 0
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
                
              ElseIf *this\index[1] = _line_last_
                
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
                    
                    \text\string.s = Left(\text\string.s, \row\_s()\text\pos+\text\caret\pos[1] ) + \text\edit[3]\string
                    \text\change =- 1 ; - 1 post event change widget
                  Else
                    ; Если дошли до начала строки то 
                    ; переходим в конец предыдущего итема
                    If \index[1] > _line_first_ 
                      \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos+\text\caret\pos[1], 1)
                      
                      ;to up
                      \index[1] - 1
                      \index[2] - 1
                      
                      If *this\row\_s()\index <> \index[2] And
                         SelectElement(*this\row\_s(), \index[2]) 
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
                  *this\index[2] + 1
                  *this\index[1] = *this\index[2]
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
  
  ;-
  Procedure   events(*this._s_widget, eventtype.l)
    Static DoubleClick.i=-1
    Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
    
    With *this
      ;If \text\editable
      Protected scroll
      If \scroll\v
        Repaint | Bar::events(\scroll\v, EventType, \root\mouse\x, \root\mouse\y)
        scroll | Bool(*this\scroll\v\from <>- 1)
      EndIf       
      If \scroll\h
        Repaint | Bar::events(\scroll\h, EventType, \root\mouse\x, \root\mouse\y)
        scroll | Bool(*this\scroll\h\from <>- 1)
      EndIf
      
      If *this And Not scroll
        If ListSize(*this\row\_s())
          If Not \hide And \interact
            ; Get line position
            ;If \root\mouse\buttons ; сним двойной клик не работает
            If \scroll\v And (\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos) > 0
              _line_ = ((\root\mouse\y-\y[2]-\text\y-\scroll\y) / (\text\height + \flag\gridlines))
              ;  _line_ = ((\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos) / (\text\height + \flag\gridlines))
            Else
              _line_ =- 1
            EndIf
            ;EndIf
            ;Debug  _line_; (\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos)
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
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
                
                *this\index[2] = _line_
                
                Caret = _edit_sel_stop_(*this)
                *this\text\caret\time = ElapsedMilliseconds()
                *this\text\caret\pos[2] = _edit_sel_start_(*this)
                Repaint = _edit_sel_draw_(*this, *this\index[2], Caret)
                *this\row\selected = \row\_s() ; *this\index[2]
                
              Case #PB_EventType_LeftButtonDown
                
                If _line_ >= 0 And 
                   _line_ < \count\items And 
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
                    *this\index[1] = _line_
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
                      SetGadgetAttribute(*this\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
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
                      
                      \index[2] = \row\_s()\index 
                      
                      
                      If *this\text\caret\pos[1] <> Caret
                        *this\text\caret\pos[1] = Caret
                        *this\text\caret\pos[2] = Caret 
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[1] <> _line_ 
                        *this\index[1] = _line_
                        Repaint = 1
                      EndIf
                      
                      If Repaint
                        Repaint = Bool(_edit_sel_set_(*this, _line_, Repaint))
                      EndIf
                    EndIf
                    
                    StopDrawing() 
                  EndIf
                EndIf
                
                
              Case #PB_EventType_MouseMove  
                If \root\mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = _edit_sel_draw_(*this, _line_)
                EndIf
                
              Case #PB_EventType_LeftButtonUp  
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
                    If *this\index[2] = *this\index[1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
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
                    
                    If *this\index[2] <> *this\index[1]
                      ; *this\text\change =- 1
                      _edit_sel_reset_(*this\row\selected)
                      *this\index[2] = *this\index[1]
                      
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
                    
                    SetGadgetAttribute(*this\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
                  Else
                    *this\text\caret\pos[2] = _text_caret_(*this)
                    *this\row\_s()\text\edit[2]\len = 0
                    *this\index[2] = _line_
                    
                    If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      Repaint =- 1
                    EndIf
                    
                    If *this\index[1] <> _line_ 
                      *this\index[1] = _line_
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
                If \index[2] >= 0 And 
                   \index[2] < \count\items And 
                   \index[2] <> \row\_s()\index  
                  \row\_s()\color\State = 0
                  SelectElement(*this\row\_s(), \index[2]) 
                EndIf
                
            EndSelect
          EndIf
          
          ; edit events
          If *this\text\editable And GetActive()\gadget = *this
            Repaint | events_key_editor(*this, EventType, \root\mouse\x, \root\mouse\y)
          EndIf
        EndIf
      EndIf
      ;EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure g_callback()
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.l = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    Protected Repaint, *this._s_widget = GetGadgetData(EventGadget)
    Protected *deactive._s_widget = GetActive()\gadget
    
    With *this
      If EventType = #PB_EventType_LeftButtonDown
        ;Debug  ""+*this +" "+ *this\parent
        
        ;If Not (_from_point_(*this\root\mouse\x, *this\root\mouse\y, *this\scroll\v))
        GetActive()\gadget = *this
        ;EndIf
        
        If *deactive
          ;           ForEach *deactive\row\_s()
          ;             If *deactive\row\_s()\color\state
          ;               *deactive\row\_s()\color\state = 3
          ;             EndIf
          ;           Next
          ReDraw(*deactive)
        EndIf
        ;         ForEach *this\row\_s()
        ;           If *this\row\_s()\color\state = 3
        ;             *this\row\_s()\color\state = 1
        ;           EndIf
        ;         Next
      EndIf
      
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- "+EventGadget
          
        Case #PB_EventType_Input 
          \root\keyboard\input = GetGadgetAttribute(\root\canvas, #PB_Canvas_Input)
          \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
        Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
          \root\keyboard\key = GetGadgetAttribute(\root\canvas, #PB_Canvas_Key)
          \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
        Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
          \root\mouse\x = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseX)
          \root\mouse\y = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseY)
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            \root\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                  (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                  (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            \root\mouse\buttons = GetGadgetAttribute(\root\canvas, #PB_Canvas_Buttons)
          CompilerEndIf
      EndSelect
      
      
      Select EventType
        Case #PB_EventType_Repaint 
          \row\count = \count\items
          
          If *this\repaint 
            *this\repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas)-*this\x*2, GadgetHeight(\root\canvas)-*this\y*2)
      EndSelect
      
      Repaint | events(*this, EventType)
      
      If Repaint 
        ReDraw(*this)
      EndIf
      
    EndWith
  EndProcedure
  
  Macro _set_text_flag_(_this_, _flag_)
    ;     If Not _this_\text
    ;       _this_\text = AllocateStructure(_s_text)
    ;     EndIf
    
    If _this_\text
      _this_\text\x = 5
      _this_\text\y = 2
      _this_\text\_padding = 0
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
        _this_\text\Rotate = Bool(_this_\vertical)*90 + Bool(Not _this_\vertical)*180
      Else
        _this_\text\Rotate = Bool(_this_\vertical)*270
      EndIf
      
      If _this_\type = #PB_GadgetType_Editor Or
         _this_\type = #PB_GadgetType_String
        
        _this_\color\fore = 0
        _this_\text\caret\pos =- 1 ; add no test
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
  
  Procedure.i Create(type.l, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If *this
      With *this
        \type = type
        
        \x =- 1
        \y =- 1
        \interact = 1
        
        \index[1] =- 1
        \index[2] =- 1
        \round = round
        
        \color = _get_colors_()
        
        \vertical = constants::_check_(Flag, #__flag_Vertical)
        \fs = Bool(Not constants::_check_(Flag, #__flag_BorderLess))*#__border_scroll
        \bs = \fs
        
        If Not Bool(flag&#__flag_wordwrap)
          Flag|#__text_multiline
        EndIf
        
        \flag\multiSelect = 1
        \flag\fullselection = Bool(Not constants::_check_(Flag, #__flag_fullselection))*7
        \flag\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        \flag\gridlines = constants::_check_(Flag, #__flag_gridlines)
        ;\flag\checkBoxes = constants::_check_(Flag, #__flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        ;\flag\bar\buttons = constants::_check_(Flag, #__flag_NoButtons)
        ;\flag\lines = constants::_check_(Flag, #__flag_NoLines)
        
        \row\margin\hide = Bool(Not constants::_check_(Flag, #__text_numeric))
        \row\margin\color\front = $C8000000 ; \color\back[0] 
        \row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        _set_text_flag_(*this, Flag)
        ; *this\text\_padding = 0
      EndIf
      
      ;If Width Or Height
      ; \scroll = AllocateStructure(_s_scroll) 
      \scroll\v = Bar::Create(#PB_GadgetType_ScrollBar, 16, 0,0,0, #PB_ScrollBar_Vertical, 7, *this)
      \scroll\h = Bar::Create(#PB_GadgetType_ScrollBar, 16, 0,0,0, 0, 7, *this)
      
      Resize(*this, X,Y,Width,Height)
      ;EndIf
      
      ; set text
      If Text
        SetText(*this, Text.s)
      Else
        \repaint = #True
        \text\change = #True
        ;\text\string = #LF$
        ;\count\items = 1
        ;\text\len = 1
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    CompilerIf #PB_Compiler_IsMainFile
      Protected *this._s_widget = create(#PB_GadgetType_Editor, 0, 0, Width, Height, "", Flag)
    CompilerElse
      Protected *this._s_widget = create(#PB_GadgetType_Editor, 0, 0, Width, Height, "", Flag)
    CompilerEndIf
    
    If *this
      With *this
        *this\root = AllocateStructure(_s_root)
        *this\root\window = GetActiveWindow()
        *this\root\canvas = Gadget
        GetActive() = *this\root
        GetActive()\root = *this\root
        
        ;
        If *this\repaint
          PostEvent(#PB_Event_Gadget, *this\root\window, *this\root\canvas, constants::#PB_EventType_Repaint)
        EndIf
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @g_callback())
        
        ; z-order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        CompilerEndIf
      EndWith
    EndIf
    
    ProcedureReturn Gadget
  EndProcedure
EndModule

DeclareModule String
  UseModule constants
  
  Structure _s_widget Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module String
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected *this._s_widget = editor::create(#PB_GadgetType_String, X, Y, Width, Height, "", Flag)
    
    *this\type = #PB_GadgetType_String
    *this\text\multiline = Bool(Flag&#__string_multiline)
    *this\text\numeric = Bool(Flag&#__string_numeric)
    *this\row\margin\hide = 1
    ;*this\text\align\Vertical = 1
    
    If Text.s
      editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._s_widget
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_String
    
    If Flag&#__string_multiline
      *this\text\multiline = 1
    ElseIf Flag&#__text_wordwrap
      *this\text\multiline =- 1
    Else
      *this\text\multiline = 0
    EndIf
    
    If *this\text\multiline
      *this\row\margin\hide = #False
      *this\row\margin\color\front = $C8000000 
      *this\row\margin\color\back = $C8F0F0F0  
    Else
      *this\row\margin\hide = 1
      *this\text\numeric = Bool(Flag&#__string_numeric)
    EndIf
    
    *this\text\align\vertical = Bool(Not *this\text\align\bottom And Not *this\text\align\top)
    
    If Text.s
      Editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  UseModule constants
  
  Global *S_0._s_widget
  Global *S_1._s_widget
  Global *S_2._s_widget
  Global *S_3._s_widget
  Global *S_4._s_widget
  Global *S_5._s_widget
  Global *S_6._s_widget
  Global *S_7._s_widget
  Global *S_8._s_widget
  Global *S_9._s_widget
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget"
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget"
      EndIf
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, XAlign.f)
    EndImport
  CompilerEndIf
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define height=60, Text1.s = "Borderless StringGadget" + #LF$ + " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  
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
  Define Text.s = get_text(#LF$)
  ;     
  Procedure resize_splitter()
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, (height+5)*7+20+90+160, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    ;       height = 20
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
    ;       height = 18
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    ;       height = 20
    ;       LoadFont(0, "monospace", 9)
    ;       SetGadgetFont(-1,FontID(0))
    ;     CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Read-only StringGadget...", #PB_String_ReadOnly)
    StringGadget(1, 8,  (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric|Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Center)
    StringGadget(2, 8,  (height+5)*2+10, 290, height, "Right-text StringGadget", Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Right)
    StringGadget(3, 8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, Text1, #PB_String_BorderLess)
    StringGadget(6, 8, (height+5)*6+10, 140, height, "")
    StringGadget(7, 150+8, (height+5)*6+10, 140, height, "Password", #PB_String_Password)
    ;     StringGadget(8, 8, (height+5)*8+10, 290, 90, Text)
    
    ;     Define i
    ;     For i=0 To 7
    ;       BindGadgetEvent(i, @Events())
    ;     Next
    
    SetTextAlignment()
    SetGadgetText(7, "GaT")
    Debug "Get gadget text "+GetGadgetText(7)
    
    *S_0 = GetGadgetData(Gadget(10, 305+8,  10, 290, height, "Read-only StringGadget...", #__string_readonly|#__text_top))
    *S_1 = GetGadgetData(Gadget(11, 305+8,  (height+5)*1+10, 290, height, "123-only-4567", #__string_numeric|#__string_center))
    *S_2 = GetGadgetData(Gadget(12, 305+8,  (height+5)*2+10, 290, height, "Right-text StringGadget", #__string_right|#__text_bottom))
    *S_3 = GetGadgetData(Gadget(13, 305+8,  (height+5)*3+10, 290, height, "LOWERCASE...", #__string_lowercase))
    *S_4 = GetGadgetData(Gadget(14, 305+8, (height+5)*4+10, 290, height, "uppercase...", #__string_uppercase))
    *S_5 = GetGadgetData(Gadget(15, 305+8, (height+5)*5+10, 290, height, Text1, #__flag_borderless))
    *S_6 = GetGadgetData(Gadget(16, 305+8, (height+5)*6+10, 140, height, ""))
    *S_7 = GetGadgetData(Gadget(17, 305+150+8, (height+5)*6+10, 140, height, "Password", #__string_password))
    ;     ; *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90+150, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline))
    ;     *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline))
    ;     *S_9 = GetGadgetData(Gadget(19, 305+8, (height+5)*9+10+60, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_wordwrap))
    
    SetText(*S_7, "GaT")
    Debug "Get widget text "+GetText(*S_7)
    
    
    EditorGadget(21, 0,0,0,0)
    EditorGadget(22, 0,0,0,0, #PB_Editor_WordWrap)
    
    Editor::Gadget(211, 0,0,0,0, #__flag_gridlines)
    Editor::Gadget(212, 0,0,0,0, #__flag_gridlines|#__editor_wordwrap)
    
    SetGadgetText(21, get_text(#LF$))
    SetGadgetText(22, get_text(""))
    
    SetText(GetGadgetData(211), get_text(#LF$))
    SetText(GetGadgetData(212), get_text(""))
    
    For a = 0 To 2
      AddGadgetItem((21), a, "Line "+Str(a))
      Editor::AddItem(GetGadgetData(211), a, "Line "+Str(a))
    Next
    AddGadgetItem((21), 7+a, "_")
    Editor::AddItem(GetGadgetData(211), 7+a, "_")
    For a = 4 To 6
      AddGadgetItem((21), a, "Line "+Str(a))
      Editor::AddItem(GetGadgetData(211), a, "Line "+Str(a))
    Next
    
    SplitterGadget(23, 0,0,0,0, 211,21 )
    SplitterGadget(213, 0,0,0,0, 212,22 )
    
    SplitterGadget(25, 8,(height+5)*7+10,600, 250, 213,23, #PB_Splitter_Vertical )
    ;SetGadgetState(25, 30)
    ;SetGadgetState(25, 97)
    ;SetGadgetState(25, 82)
    ;SetGadgetState(25, 99)
    SetGadgetState(25, 126)
    BindGadgetEvent(25, @resize_splitter())
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; ; ; CompilerIf #PB_Compiler_IsMainFile
; ; ;   UseModule String
; ; ;   UseModule constants
; ; ;   
; ; ;   Global *S_0._s_widget
; ; ;   Global *S_1._s_widget
; ; ;   Global *S_2._s_widget
; ; ;   Global *S_3._s_widget
; ; ;   Global *S_4._s_widget
; ; ;   Global *S_5._s_widget
; ; ;   Global *S_6._s_widget
; ; ;   Global *S_7._s_widget
; ; ;   Global *S_8._s_widget
; ; ;   Global *S_9._s_widget
; ; ;   
; ; ;   ;   *this._const_
; ; ;   ;   
; ; ;   ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
; ; ;   
; ; ;   UsePNGImageDecoder()
; ; ;   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
; ; ;     End
; ; ;   EndIf
; ; ;   
; ; ;   Procedure Events()
; ; ;     Protected String.s
; ; ;     
; ; ;     Select EventType()
; ; ;       Case #PB_EventType_Focus
; ; ;         String.s = "focus "+EventGadget()+" "+EventType()
; ; ;       Case #PB_EventType_LostFocus
; ; ;         String.s = "lostfocus "+EventGadget()+" "+EventType()
; ; ;       Case #PB_EventType_Change
; ; ;         String.s = "change "+EventGadget()+" "+EventType()
; ; ;     EndSelect
; ; ;     
; ; ;     If IsGadget(EventGadget())
; ; ;       If EventType() = #PB_EventType_Focus
; ; ;         Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
; ; ;       Else
; ; ;         Debug String.s +" - gadget"
; ; ;       EndIf
; ; ;     Else
; ; ;       If EventType() = #PB_EventType_Focus
; ; ;         Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
; ; ;       Else
; ; ;         Debug String.s +" - widget"
; ; ;       EndIf
; ; ;     EndIf
; ; ;     
; ; ;   EndProcedure
; ; ;   
; ; ;   ; Alignment text
; ; ;   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
; ; ;     ImportC ""
; ; ;       gtk_entry_set_alignment(Entry.i, XAlign.f)
; ; ;     EndImport
; ; ;   CompilerEndIf
; ; ;   
; ; ;   Procedure SetTextAlignment()
; ; ;     ; Alignment text
; ; ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
; ; ;       CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
; ; ;       CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
; ; ;       
; ; ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
; ; ;       If OSVersion() > #PB_OS_Windows_XP
; ; ;         SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
; ; ;         SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
; ; ;       Else
; ; ;         SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
; ; ;         SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
; ; ;       EndIf
; ; ;       
; ; ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
; ; ;       ;       ImportC ""
; ; ;       ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
; ; ;       ;       EndImport
; ; ;       
; ; ;       gtk_entry_set_alignment(GadgetID(1), 0.5)
; ; ;       gtk_entry_set_alignment(GadgetID(2), 1)
; ; ;     CompilerEndIf
; ; ;   EndProcedure
; ; ;   
; ; ;   Define height=60, Text1.s = "Borderless StringGadget" + #LF$ + " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
; ; ;   
; ; ;   Define Text.s
; ; ;   Procedure.s get_text(m.s=#LF$)
; ; ;     Protected Text.s = "This is a long line." + m.s +
; ; ;                        "Who should show." + 
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        "I have to write the text in the box or not." + 
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        m.s +
; ; ;                        "The string must be very long." + m.s +
; ; ;                        "Otherwise it will not work." ;+ m.s; +
; ; ;     
; ; ;     ProcedureReturn Text
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure resize_splitter()
; ; ;     SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
; ; ;   EndProcedure
; ; ;   
; ; ;   If OpenWindow(0, 0, 0, 616, 316, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
; ; ;     EditorGadget(1, 0,0,0,0)
; ; ;     EditorGadget(2, 0,0,0,0, #PB_Editor_WordWrap)
; ; ;    
; ; ;     Editor::Gadget(11, 0,0,0,0)
; ; ;     Editor::Gadget(12, 0,0,0,0, #__editor_wordwrap)
; ; ;     
; ; ;     SetGadgetText(1, get_text(#LF$))
; ; ;     SetGadgetText(2, get_text(""))
; ; ;     
; ; ;     SetText(GetGadgetData(11), get_text(#LF$))
; ; ;     SetText(GetGadgetData(12), get_text(""))
; ; ;     
; ; ;     SplitterGadget(3, 0,0,0,0, 1,11 )
; ; ;     SplitterGadget(13, 0,0,0,0, 2,12 )
; ; ;     
; ; ;     SplitterGadget(5, 8,8,600, 300, 13,3, #PB_Splitter_Vertical )
; ; ;     ;SetGadgetState(5, 30)
; ; ;     ;SetGadgetState(5, 97)
; ; ;     SetGadgetState(5, 82)
; ; ;     ;SetGadgetState(5, 99)
; ; ;     BindGadgetEvent(5, @resize_splitter())
; ; ;     
; ; ;     
; ; ;     ;     *S_8 = GetGadgetData(Gadget(17, 305+8, (height+5)*8+10, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline))
; ; ;     ;     *S_9 = GetGadgetData(Gadget(18, 305+8, (height+5)*9+10+60, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_wordwrap))
; ; ;     ;     SplitterGadget(2, 305+8,8,(height+5)*1+10, 290, 17,18 )
; ; ;     
; ; ;     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; ; ;   EndIf
; ; ; CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---------------------------------------------------------------------
; EnableXP