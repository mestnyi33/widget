﻿;
; Os              : All
; Version         : 3
; License         : Free
; Module name     : Scroll
; Author          : mestnyi
; PB version:     : 5.46 =< 5.62
; Last updated    : 3 Aug 2019
; Topic           : https://www.purebasic.fr/english/posting.php?mode=edit&f=12&p=521603
;

CompilerIf #PB_Compiler_IsMainFile
  DeclareModule Constant
    CompilerIf #PB_Compiler_Version =< 546
      Enumeration #PB_EventType_FirstCustomValue
        #PB_EventType_Resize
      EndEnumeration
    CompilerEndIf
  EndDeclareModule
  Module Constant : EndModule : UseModule Constant
CompilerEndIf

;- >>> DECLAREMODULE
DeclareModule Scroll
  EnableExplicit
 
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
 
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  ; #PB_Bar_ScrollStep = #PB_ScrollArea_ScrollStep
 
  EnumerationBinary 4
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons
    #PB_Bar_Direction
    #PB_Bar_Inverted
  EndEnumeration
 
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
 
  #Button1 = 1
  #Button2 = 2
  #Thumb = 3
 
  ; Debug #PB_ScrollArea_ScrollStep = 5 ; mac os
  ; Debug #PB_Bar_ScrollStep

  ;- STRUCTUREs
  ;- - _S_color
  Structure _S_color
    state.b
    alpha.a[2]
    front.l[4]
    fore.l[4]
    back.l[4]
    frame.l[4]
  EndStructure
 
  ;- - _S_page
  Structure _s_page
      pos.l
      len.l
      *end
      change.f
    EndStructure
    
  ;- - _S_button
  Structure _S_button
    x.l
    y.l
    width.l
    height.l
    len.l
  EndStructure
 
  ;- - _S_scroll
  Structure _S_scroll
    x.l
    y.l
    width.l
    height.l
   
    *v._S_widget
    *h._S_widget
  EndStructure
 
  ;- - _S_bar
  Structure _S_bar
;     x.l
;     y.l
;     width.l
;     height.l
;     
;     *scroll._S_scroll
    
    max.l
    min.l
   
;     type.l
;     from.l
;     focus.l
;     round.l
   
;     hide.b[2]
    ; disable.b[2]
;     vertical.b
;     inverted.b
;     direction.l
;     scrollstep.l
   
    page._S_page
    area._S_page
    thumb._S_page
;     color._S_color[4]
;     button._S_button[4]
  EndStructure
 
  ;- - _S_widget
  Structure _S_widget
    x.l
    y.l
    width.l
    height.l
    
    *scroll._S_scroll
    bar._S_bar
    
;     max.l
;     min.l
   
    type.l
    from.l
    focus.l
    round.l
   
    hide.b[2]
    ; disable.b[2]
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
   
;     page._S_page
;     area._S_page
;     thumb._S_page
    color._S_color[4]
    button._S_button[4]
  EndStructure
 
  ;-
  ;- DECLAREs
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1)
  Declare.b Draw(*this._S_widget)
  Declare.l Y(*this._S_widget)
  Declare.l X(*this._S_widget)
  Declare.l Width(*this._S_widget)
  Declare.l Height(*this._S_widget)
 
  Declare.i GetState(*this._S_widget)
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
 
  Declare.b SetState(*this._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
 
  Declare.b Resize(*this._S_widget, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b Resizes(*this._S_widget, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*this._S_widget, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  Declare.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, round.l=0)
EndDeclareModule

;- >>> MODULE
Module Scroll
  ;- GLOBALs
  Global Color_Default._S_color
 
  With Color_Default                         
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
 
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
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
 
  ; Inverted scroll bar position
  Macro _bar_invert_( _bar_, _scroll_pos_, _inverted_ = #True )
    ;  ( Bool( _inverted_ ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min ) ) + Bool( Not _inverted_ ) * ( _scroll_pos_ ) )
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
    
  ;-
  Macro ThumbLength(_this_)
    Round(_this_\bar\area\len - (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)) * ((_this_\bar\max-_this_\bar\min) - _this_\bar\page\len), #PB_Round_Nearest)
   
    If _this_\bar\thumb\len > _this_\bar\area\len
      _this_\bar\thumb\len = _this_\bar\area\len
    EndIf
   
    If _this_\Vertical
      _this_\button[#Thumb]\height = _this_\bar\thumb\len
    Else
      _this_\button[#Thumb]\width = _this_\bar\thumb\len
    EndIf
  EndMacro
 
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\bar\area\pos + Round((_scroll_pos_-_this_\bar\min) * (_this_\bar\area\len / (_this_\bar\max-_this_\bar\min)), #PB_Round_Nearest))
   
    If _this_\bar\thumb\pos < _this_\bar\area\pos
      _this_\bar\thumb\pos = _this_\bar\area\pos
    EndIf
   
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
   
    ; _start_
    If _this_\bar\thumb\pos = _this_\bar\area\pos
      _this_\color[#Button1]\state = #Disabled
    Else
      _this_\color[#Button1]\state = #Normal
    EndIf
   
    ; _stop_
    If _this_\bar\thumb\pos = _this_\bar\area\end
      _this_\color[#Button2]\state = #Disabled
    Else
      _this_\color[#Button2]\state = #Normal
    EndIf
   
    If _this_\vertical
      _this_\button[#Thumb]\y = _this_\bar\thumb\pos
    Else
      _this_\button[#Thumb]\x = _this_\bar\thumb\pos
    EndIf
  EndMacro
 
  Procedure.i PagePos(*this._S_widget, State.i)
    With *this
      If State < \bar\min : State = \bar\min : EndIf
     
      If State > \bar\max-\bar\page\len
        If \bar\max > \bar\page\len
          State = \bar\max-\bar\page\len
        Else
          State = \bar\min
        EndIf
      EndIf
    EndWith
   
    ProcedureReturn State
  EndProcedure
 
  Procedure.i Bar_SetPos(*this._S_widget, ThumbPos.i)
    Static ScrollPos.i
    Protected Result.i
   
    With *this
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
     
      If \bar\thumb\pos <> ThumbPos
        ThumbPos = \bar\min + Round((ThumbPos - \bar\area\pos) / (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)
       
        If #PB_GadgetType_TrackBar = \type And \vertical
          ThumbPos = _bar_invert_(*this\bar, ThumbPos, \inverted)
        EndIf
     
        \bar\thumb\pos = ThumbPos
        Result = SetState(*this, ThumbPos)
      EndIf
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  ;-
  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1)
    Protected I
   
    If Direction = 1
      For i = 0 To Size
        ; в верх
        LineXY((X+i)+Size,(Y+i-1)-(Thickness),(X+i)+Size,(Y+i-1)+(Thickness),Color) ; Левая линия
        LineXY(((X+(Size))-i),(Y+i-1)-(Thickness),((X+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
      Next
    ElseIf Direction = 3
      For i = 0 To Size
        ; в низ
        LineXY((X+i),(Y+i)-(Thickness),(X+i),(Y+i)+(Thickness),Color) ; Левая линия
        LineXY(((X+(Size*2))-i),(Y+i)-(Thickness),((X+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
      Next
    ElseIf Direction = 0 ; в лево
      For i = 0 To Size 
        ; в лево
        LineXY(((X+1)+i)-(Thickness),(((Y-2)+(Size))-i),((X+1)+i)+(Thickness),(((Y-2)+(Size))-i),Color) ; правая линия
        LineXY(((X+1)+i)-(Thickness),((Y-2)+i)+Size,((X+1)+i)+(Thickness),((Y-2)+i)+Size,Color)         ; Левая линия
      Next
    ElseIf Direction = 2 ; в право
      For i = 0 To Size
        ; в право
        LineXY(((X+2)+i)-(Thickness),((Y-2)+i),((X+2)+i)+(Thickness),((Y-2)+i),Color) ; Левая линия
        LineXY(((X+2)+i)-(Thickness),(((Y-2)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y-2)+(Size*2))-i),Color) ; правая линия
      Next
    EndIf
   
  EndProcedure
 
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
      If (Value>Max) : Value=Max : EndIf
    EndIf
   
    ProcedureReturn Value
  EndProcedure
 
  Procedure.b Draw(*this._S_widget)
    With *this
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\Width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
       
        If \Vertical
          Line( \x, \y, 1, \bar\page\len + Bool(\height<>\bar\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \bar\page\len + Bool(\width<>\bar\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
       
        If \bar\thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \round, \color\alpha)
         
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\round,\round,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
       
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \round, \color\alpha)
          BoxGradient(\Vertical,\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \round, \color\alpha)
         
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\round,\round,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\round,\round,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
         
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#Button1]\x+(\button[#Button1]\width-6)/2,\button[#Button1]\y+(\button[#Button1]\height-3)/2, 3, Bool(\Vertical), \Color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          Arrow(\button[#Button2]\x+(\button[#Button2]\width-6)/2,\button[#Button2]\y+(\button[#Button2]\height-3)/2, 3, Bool(\Vertical)+2, \Color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
       
        ; Draw thumb lines
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        If \Vertical
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2-3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+(\button[#Thumb]\width-8)/2,\button[#Thumb]\y+\button[#Thumb]\height/2+3,9,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        Else
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2-3,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Line(\button[#Thumb]\x+\button[#Thumb]\width/2+3,\button[#Thumb]\y+(\button[#Thumb]\height-8)/2,1,9,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
       
      EndIf
    EndWith
  EndProcedure
 
  ;-
  Procedure.l X(*this._S_widget)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
 
  Procedure.l Y(*this._S_widget)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
 
  Procedure.l Width(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
 
  Procedure.l Height(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
 
  ;- GET
  Procedure.i GetState(*this._S_widget)
    ProcedureReturn *this\bar\page\pos
  EndProcedure
 
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
   
    With *this
      Select Attribute
        Case #PB_Bar_Minimum : Result = \bar\min  ; 1
        Case #PB_Bar_Maximum : Result = \bar\max  ; 2
        Case #PB_Bar_PageLength : Result = \bar\page\len
        Case #PB_Bar_Inverted : Result = \inverted
        Case #PB_Bar_Direction : Result = \direction
        Case #PB_Bar_NoButtons : Result = \button\len
        Case #PB_Bar_ScrollStep : Result = \scrollstep
      EndSelect
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
 
  ;- SET
  Procedure.b SetState(*this._S_widget, ScrollPos.l)
    Protected Result.b
   
    With *this
      If ScrollPos < \bar\min : ScrollPos = \bar\min : EndIf
      If ScrollPos > (\bar\max-\bar\page\len) : ScrollPos = (\bar\max-\bar\page\len) : EndIf
     
      If #PB_GadgetType_TrackBar = \type And \vertical
        ScrollPos = PagePos(*this, ScrollPos)
      Else
        ScrollPos = PagePos(*this, _bar_invert_(*this\bar, ScrollPos, \inverted))
      EndIf
     
      If \bar\page\pos <> ScrollPos
        \bar\thumb\pos = ThumbPos(*this, _bar_invert_(*this\bar, ScrollPos, \inverted))
       
        If \inverted
          If \bar\page\pos > ScrollPos
            \direction = _bar_invert_(*this\bar, ScrollPos, \inverted)
          Else
            \direction =- _bar_invert_(*this\bar, ScrollPos, \inverted)
          EndIf
        Else
          If \bar\page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        EndIf
       
        \bar\page\pos = ScrollPos
        Result = #True
      EndIf
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  Procedure.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
    Protected Result.l
   
    With *this
      Select Attribute
        Case #PB_Bar_ScrollStep
          Result = \scrollstep
          \scrollstep = Value
         
        Case #PB_Bar_NoButtons ;: Resize = 1
          \button\len = Value
          \button[#Button1]\len = Value
          \button[#Button2]\len = Value
         
          ;\Resize = 1<<1|1<<2|1<<3|1<<4
          \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;\Resize = 0
         
        Case #PB_Bar_Inverted
          \inverted = Bool(Value)
          \bar\thumb\pos = ThumbPos(*this, _bar_invert_(*this\bar, \bar\page\pos, \inverted))
         
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
           
            Result = #True
          EndIf
         
        Case #PB_Bar_PageLength
          If \bar\page\len <> Value
            If Value > (\bar\max-\bar\min) : \bar\max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \bar\page\len = (\bar\max-\bar\min)
            Else
              \bar\page\len = Value
            EndIf
           
            Result = #True
          EndIf
         
      EndSelect
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  Procedure.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
   
    With *this
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\front[State] = Color
          Else
            \Color[Item]\front[State] = Color
          EndIf
         
        Case #PB_Gadget_BackColor
          If Item=- 1
            \Color\Back[State] = Color
          Else
            \Color[Item]\Back[State] = Color
          EndIf
         
        Case #PB_Gadget_FrontColor
        Default ; Case #PB_Gadget_FrameColor
          If Item=- 1
            \Color\frame[State] = Color
          Else
            \Color[Item]\frame[State] = Color
          EndIf
         
      EndSelect
    EndWith
   
    ; ResetColor(*this)
   
    ProcedureReturn Bool(Color)
  EndProcedure
 
  ;-
  Procedure.b Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
    Protected Result, Lines, ScrollPage
   
    With *this
      ScrollPage = ((\bar\max-\bar\min) - \bar\page\len)
      Lines = Bool(\type=#PB_GadgetType_ScrollBar)
     
      ;
      If X=#PB_Ignore : X = \X : EndIf : If Y=#PB_Ignore : Y = \Y : EndIf
      If Width=#PB_Ignore : Width = \Width : EndIf : If Height=#PB_Ignore : Height = \height : EndIf
     
      ;
      If ((\bar\max-\bar\min) >= \bar\page\len)
        If \Vertical
          \bar\area\pos = Y+\button\len
          \bar\area\len = (Height-\button\len*2)
        Else
          \bar\area\pos = X+\button\len
          \bar\area\len = (Width-\button\len*2)
        EndIf
       
        If \bar\area\len
          \bar\thumb\len = ThumbLength(*this)
          ; area end pos
          \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
           
          If (\bar\area\len > \button\len)
            If \button\len
              If (\bar\thumb\len < \button\len)
                \bar\area\len = Round(\bar\area\len - (\button\len-\bar\thumb\len), #PB_Round_Nearest)
                \bar\area\end = \bar\area\pos + (\height-\button\len)
                \bar\thumb\len = \button\len
              EndIf
            Else
              ; TrackBar
              If (\bar\thumb\len < 7)
                \bar\area\len = Round(\bar\area\len - (7-\bar\thumb\len), #PB_Round_Nearest)
                \bar\area\end = \bar\area\pos + \bar\area\Len
                \bar\thumb\len = 7
              EndIf
            EndIf
          Else
            \bar\area\end = \bar\area\pos + (\height-\bar\area\len)
            \bar\thumb\len = \bar\area\len
          EndIf
         
          If \bar\area\len > 0
            If (\type <> #PB_GadgetType_TrackBar) And (\bar\thumb\pos+\bar\thumb\len) >= (\bar\area\len+\button\len)
              SetState(*this, ScrollPage)
            EndIf
           
            \bar\thumb\pos = ThumbPos(*this, _bar_invert_(*this\bar, \bar\page\pos, \inverted))
          EndIf
        EndIf
      EndIf
     
     
      \X = X : \Y = Y : \Width = Width : \height = Height                                             ; Set scroll bar coordinate
     
      If \Vertical
        \button[#Button1]\x = X + Lines : \button[#Button1]\y = Y : \button[#Button1]\width = Width - Lines : \button[#Button1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[#Button2]\x = X + Lines : \button[#Button2]\width = Width - Lines : \button[#Button2]\height = \button\len : \button[#Button2]\y = Y+Height-\button[#Button2]\height ; Botom button coordinate on scroll bar
        \button[#Thumb]\x = X + Lines : \button[#Thumb]\width = Width - Lines : \button[#Thumb]\y = \bar\thumb\pos : \button[#Thumb]\height = \bar\thumb\len                  ; Thumb coordinate on scroll bar
      Else
        \button[#Button1]\x = X : \button[#Button1]\y = Y + Lines : \button[#Button1]\width = \button\len : \button[#Button1]\height = Height - Lines                  ; Left button coordinate on scroll bar
        \button[#Button2]\y = Y + Lines : \button[#Button2]\height = Height - Lines : \button[#Button2]\width = \button\len : \button[#Button2]\x = X+Width-\button[#Button2]\width  ; Right button coordinate on scroll bar
        \button[#Thumb]\y = Y + Lines : \button[#Thumb]\height = Height - Lines : \button[#Thumb]\x = \bar\thumb\pos : \button[#Thumb]\width = \bar\thumb\len                 ; Thumb coordinate on scroll bar
      EndIf
     
      \hide[1] = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
 
  Procedure.b Updates(*this._S_widget, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *this\scroll
      Protected iWidth = X(\v), iHeight = Y(\h)
      Static hPos, vPos : vPos = \v\bar\page\pos : hPos = \h\bar\page\pos
     
      ; Вправо работает как надо
      If ScrollArea_Width<\h\bar\page\pos+iWidth
        ScrollArea_Width=\h\bar\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\bar\page\pos And
             ScrollArea_Width=\h\bar\page\pos+iWidth
        ScrollArea_Width = iWidth
      EndIf
     
      ; Вниз работает как надо
      If ScrollArea_Height<\v\bar\page\pos+iHeight
        ScrollArea_Height=\v\bar\page\pos+iHeight
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\bar\page\pos And
             ScrollArea_Height=\v\bar\page\pos+iHeight
        ScrollArea_Height = iHeight
      EndIf
     
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
     
      If ScrollArea_X<\h\bar\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\bar\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
     
      If \v\bar\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\bar\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
     
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
     
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
     
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h)
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\round And \h\round)*(\v\button\len/4+1))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\round And \h\round)*(\v\button\len/4+1), #PB_Ignore)
     
      If \v\hide : \v\bar\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\bar\page\pos = vPos : EndIf
      If \h\hide : \h\bar\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\bar\page\pos = hPos : EndIf
     
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
 
  Procedure.b Resizes(*this._S_widget, X.l,Y.l,Width.l,Height.l )
    With *this\scroll
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
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4))
      EndIf
     
      ProcedureReturn #True
    EndWith
  EndProcedure
 
  ;-
  Procedure.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static LastX, LastY, Last, *thisis._S_widget, Cursor, Drag, Down
   
    With *this
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\height)
          If \button
            If (MouseX>\button[#Thumb]\x And MouseX=<\button[#Thumb]\x+\button[#Thumb]\width And MouseY>\button[#Thumb]\y And MouseY=<\button[#Thumb]\y+\button[#Thumb]\height)
              from = #Thumb
            ElseIf (MouseX>\button[#Button2]\x And MouseX=<\button[#Button2]\x+\button[#Button2]\Width And MouseY>\button[#Button2]\y And MouseY=<\button[#Button2]\y+\button[#Button2]\height)
              from = #Button2
            ElseIf (MouseX>\button[#Button1]\x And MouseX=<\button[#Button1]\x+\button[#Button1]\Width And  MouseY>\button[#Button1]\y And MouseY=<\button[#Button1]\y+\button[#Button1]\height)
              from = #Button1
            ElseIf (MouseX>\button[0]\x And MouseX=<\button[0]\x+\button[0]\Width And MouseY>\button[0]\y And MouseY=<\button[0]\y+\button[0]\height)
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
          If *thisis = *this
            Select WheelDelta
              Case-1 : Result = SetState(*this, \bar\page\pos - (\bar\max-\bar\min)/30)
              Case 1 : Result = SetState(*this, \bar\page\pos + (\bar\max-\bar\min)/30)
            EndSelect
          EndIf
         
        Case #PB_EventType_MouseLeave
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *thisis = *this : EndIf
         
          Select from
            Case - 1
              If *thisis = *this
                If \Vertical
                  Result = Bar_SetPos(*this, (MouseY-\bar\thumb\len/2))
                Else
                  Result = Bar_SetPos(*this, (MouseX-\bar\thumb\len/2))
                EndIf
               
                \from = 3
              EndIf
            Case 1
              If \inverted
                Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos + \scrollstep), \inverted))
              Else
                Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos - \scrollstep), \inverted))
              EndIf
             
            Case 2
                If \inverted
                Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos - \scrollstep), \inverted))
              Else
                Result = SetState(*this, _bar_invert_(*this\bar, (\bar\page\pos + \scrollstep), \inverted))
              EndIf
           
            Case 3 : LastX = MouseX - \bar\thumb\pos : LastY = MouseY - \bar\thumb\pos
          EndSelect
         
        Case #PB_EventType_MouseMove
          If Drag
            If *thisis = *this And Bool(LastX|LastY)
              If \Vertical
                Result = Bar_SetPos(*this, (MouseY-LastY))
              Else
                Result = Bar_SetPos(*this, (MouseX-LastX))
              EndIf
            EndIf
          Else
            If from
              If \from <> from
                If *thisis > 0
                  CallBack(*thisis, #PB_EventType_MouseLeave, MouseX, MouseY)
                EndIf
               
                If *thisis <> *this
                  Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *thisis = *this
                EndIf
               
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *thisis = *this
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *thisis = 0
              ;               Last = 0
            EndIf
          EndIf
         
      EndSelect
     
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \focus = 1 : Result = #True
        Case #PB_EventType_LostFocus : \focus = 0 : Result = #True
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_LeftButtonUp,
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave
          If from>0
            If \color[from]\state <> #Disabled
              \color[from]\state = #Entered + Bool(EventType=#PB_EventType_LeftButtonDown)
            EndIf
          ElseIf Not Drag And Not from
            If \color\state <> #Disabled
              \color\state = #Normal
            EndIf
            If \color[#Button1]\state <> #Disabled
              \color[#Button1]\state = #Normal
            EndIf
            If \color[#Button2]\state <> #Disabled
              \color[#Button2]\state = #Normal
            EndIf
            If \color[#Thumb]\state <> #Disabled
              \color[#Thumb]\state = #Normal
            EndIf
          EndIf
         
          Result = #True
      EndSelect
    EndWith
   
    ProcedureReturn Result
  EndProcedure
 
  Procedure.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, round.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
   
    With *this
      \scrollstep = 1
      \round = round
     
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
     
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
     
      \color[#Button1] = Color_Default
      \color[#Button2] = Color_Default
      \color[#Thumb] = Color_Default
     
      \type = #PB_GadgetType_ScrollBar
      \vertical = Bool(Flag&#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
     
      If \vertical
        If width < 21
          \button\len = width - 1
        Else
          \button\len = 17
        EndIf
      Else
        If height < 21
          \button\len = height - 1
        Else
          \button\len = 17
        EndIf
      EndIf
     
      If \bar\min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
    EndWith
   
    Resize(*this, X,Y,Width,Height)
   
    ProcedureReturn *this
  EndProcedure
 
  ;-
  ;- - ENDMODULE
  ;-
EndModule



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ; IncludePath "C:\Users\as\Documents\GitHub\"
  ; XIncludeFile "module_scroll.pbi"
 
  EnableExplicit
  UseModule Scroll
 
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
 
  Enumeration
    #MyCanvas = 1   ; just to test whether a number different from 0 works now
  EndEnumeration
 
  Global *this._S_widget=AllocateStructure(_S_widget)
 
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
  Global NewList Images.canvasitem()
 
  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images())
      Images()\img    = img
      Images()\x      = x
      Images()\y      = y
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
 
  Procedure _Draw (canvas.i)
    Protected iWidth = X(*this\scroll\v), iHeight = Y(*this\scroll\h)
   
    If StartDrawing(CanvasOutput(canvas))
     
      ClipOutput(0,0, iWidth, iHeight)
     
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
     
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        DrawImage(ImageID(Images()\img),Images()\x - *this\scroll\h\bar\page\pos,Images()\y - *this\scroll\v\bar\page\pos) ; draw all images with z-order
      Next
     
      UnclipOutput()
     
      If Not *this\scroll\v\hide
        Draw(*this\scroll\v)
      EndIf
      If Not *this\scroll\h\hide
        Draw(*this\scroll\h)
      EndIf
     
      StopDrawing()
    EndIf
  EndProcedure
 
  Procedure.i HitTest (List Images.canvasitem(), x, y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
   
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        If x >= Images()\x - *this\scroll\h\bar\page\pos And x < Images()\x - *this\scroll\h\bar\page\pos + Images()\width
          If y >= Images()\y - *this\scroll\v\bar\page\pos And y < Images()\y - *this\scroll\v\bar\page\pos + Images()\height
            alpha = 255
           
            If Images()\alphatest And ImageDepth(Images()\img)>31
              If StartDrawing(ImageOutput(Images()\img))
                DrawingMode(#PB_2DDrawing_AlphaChannel)
                alpha = Alpha(Point(x-Images()\x, y-Images()\y)) ; get alpha
                StopDrawing()
              EndIf
            EndIf
           
            If alpha
              MoveElement(Images(), #PB_List_Last)
              isCurrentItem = #True
              currentItemXOffset = x - Images()\x
              currentItemYOffset = y - Images()\y
              Break
            EndIf
          EndIf
        EndIf
      Until PreviousElement(Images()) = 0
    EndIf
   
    ProcedureReturn isCurrentItem
  EndProcedure
 
  AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
  AddImage(Images(),  250,350, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
 
  hole = CreateImage(#PB_Any,100,100,32)
  If StartDrawing(ImageOutput(hole))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,100,100,RGBA($00,$00,$00,$00))
    Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
    Circle(50,50,30,RGBA($00,$00,$00,$00))
    StopDrawing()
  EndIf
  AddImage(Images(),170,70,hole,1)
 
 
  Macro GetScrollCoordinate()
    ScrollX = Images()\x
    ScrollY = Images()\Y
    ScrollWidth = Images()\x+Images()\width
    ScrollHeight = Images()\Y+Images()\height
   
    PushListPosition(Images())
    ForEach Images()
      If ScrollX > Images()\x : ScrollX = Images()\x : EndIf
      If ScrollY > Images()\Y : ScrollY = Images()\Y : EndIf
      If ScrollWidth < Images()\x+Images()\width : ScrollWidth = Images()\x+Images()\width : EndIf
      If ScrollHeight < Images()\Y+Images()\height : ScrollHeight = Images()\Y+Images()\height : EndIf
    Next
    PopListPosition(Images())
  EndMacro
 
  Procedure ScrollUpdates(*this._S_widget, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *this\scroll
      Protected iWidth = X(*this\scroll\v), iHeight = Y(*this\scroll\h)
      Static hPos, vPos : vPos = *this\scroll\v\bar\page\pos : hPos = *this\scroll\h\bar\page\pos
     
      ; Вправо работает как надо
      If ScrollArea_Width<*this\scroll\h\bar\page\pos+iWidth
        ScrollArea_Width=*this\scroll\h\bar\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>*this\scroll\h\bar\page\pos And
             ScrollArea_Width=*this\scroll\h\bar\page\pos+iWidth
        ScrollArea_Width = iWidth
      EndIf
     
      ; Вниз работает как надо
      If ScrollArea_Height<*this\scroll\v\bar\page\pos+iHeight
        ScrollArea_Height=*this\scroll\v\bar\page\pos+iHeight
        ; Верх работает как надо
      ElseIf ScrollArea_Y>*this\scroll\v\bar\page\pos And
             ScrollArea_Height=*this\scroll\v\bar\page\pos+iHeight
        ScrollArea_Height = iHeight
      EndIf
     
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
     
      If ScrollArea_X<*this\scroll\h\bar\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<*this\scroll\v\bar\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
     
      If *this\scroll\v\bar\max<>ScrollArea_Height : SetAttribute(*this\scroll\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If *this\scroll\h\bar\max<>ScrollArea_Width : SetAttribute(*this\scroll\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
     
      If *this\scroll\v\bar\page\len<>iHeight : SetAttribute(*this\scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If *this\scroll\h\bar\page\len<>iWidth : SetAttribute(*this\scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
     
      If ScrollArea_Y<0 : SetState(*this\scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(*this\scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
     
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\round And \h\round)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\round And \h\round)*(\h\height/4), #PB_Ignore)
     
      ;   If *this\scroll\v\hide : *this\scroll\v\bar\page\pos = 0 : Else : *this\scroll\v\bar\page\pos = vPos : *this\scroll\h\Width = iWidth+*this\scroll\v\Width : EndIf
      ;   If *this\scroll\h\hide : *this\scroll\h\bar\page\pos = 0 : Else : *this\scroll\h\bar\page\pos = hPos : *this\scroll\v\height = iHeight+*this\scroll\h\height : EndIf
     
      If *this\scroll\v\hide : *this\scroll\v\bar\page\pos = 0 : If vPos : *this\scroll\v\hide = vPos : EndIf : Else : *this\scroll\v\bar\page\pos = vPos : EndIf
      If *this\scroll\h\hide : *this\scroll\h\bar\page\pos = 0 : If hPos : *this\scroll\h\hide = hPos : EndIf : Else : *this\scroll\h\bar\page\pos = hPos : EndIf
     
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
 
  Procedure.i Canvas_CallBack() ; Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
   
    If CallBack(*this\scroll\v, EventType, MouseX, MouseY, WheelDelta)
      Repaint = #True
    EndIf
    If CallBack(*this\scroll\h, EventType, MouseX, MouseY, WheelDelta)
      Repaint = #True
    EndIf
   
    Select EventType
      Case #PB_EventType_LeftButtonUp
        GetScrollCoordinate()
       
        If (ScrollX<0 Or ScrollY<0)
          PushListPosition(Images())
          ForEach Images()
            If ScrollX<0
              *this\scroll\h\bar\page\pos =- ScrollX
              Images()\X-ScrollX
            EndIf
            If ScrollY<0
              *this\scroll\v\bar\page\pos =- ScrollY
              Images()\Y-ScrollY
            EndIf
          Next
          PopListPosition(Images())
        EndIf
       
    EndSelect     
   
   
    If (*this\scroll\h\from Or *this\scroll\v\from)
      Select EventType
        Case #PB_EventType_LeftButtonUp
          Debug "----------Up---------"
          GetScrollCoordinate()
          ScrollUpdates(*this, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
          ;           Protected iWidth = Width-Width(*this\scroll\v), iHeight = Height-Height(*this\scroll\h)
          ;   
          ;         Debug ""+*this\scroll\h\hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
          ;         Debug ""+*this\scroll\v\hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
         
          PushListPosition(Images())
          ForEach Images()
            ;           If *this\scroll\h\hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
            ;           If *this\scroll\v\hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
            If *this\scroll\h\hide>1 : Images()\X-*this\scroll\h\hide : EndIf
            If *this\scroll\v\hide>1 : Images()\Y-*this\scroll\v\hide : EndIf
          Next
          PopListPosition(Images())
         
         
      EndSelect
    Else
      Select EventType
        Case #PB_EventType_LeftButtonUp : Drag = #False
        Case #PB_EventType_LeftButtonDown
          isCurrentItem = HitTest(Images(), Mousex, Mousey)
          If isCurrentItem
            Repaint = #True
            Drag = #True
          EndIf
         
        Case #PB_EventType_MouseMove
          If Drag = #True
            If isCurrentItem
              If LastElement(Images())
                Images()\x = Mousex - currentItemXOffset
                Images()\y = Mousey - currentItemYOffset
                SetWindowTitle(EventWindow(), Str(Images()\x))
               
                GetScrollCoordinate()
                Repaint = Updates(*this, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
              EndIf
            EndIf
          EndIf
         
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
         
          If *this\scroll\h\bar\max<>ScrollWidth : SetAttribute(*this\scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
          If *this\scroll\v\bar\max<>ScrollHeight : SetAttribute(*this\scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
         
          Resizes(*this, 0, 0, Width, Height)
          Repaint = #True
         
      EndSelect
    EndIf
   
    If Repaint
      _Draw(#MyCanvas)
    EndIf
  EndProcedure
 
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20-100)
  EndProcedure
 
 
  If Not OpenWindow(0, 0, 0, 420, 420+100, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
 
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
 
  CanvasGadget(#MyCanvas, 10, 110, 400, 400)
  
  *this\scroll._S_scroll = AllocateStructure(_S_scroll)
  *this\scroll\v = Gadget(380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical|#PB_Bar_Inverted, 9)
  *this\scroll\h = Gadget(0, 380, 380,  20, 0, 0, 0, 0, 9)
 
  If GetGadgetState(2)
    SetGadgetState(3, GetAttribute(*this\scroll\v, #PB_Bar_Inverted))
  Else
    SetGadgetState(3, GetAttribute(*this\scroll\h, #PB_Bar_Inverted))
  EndIf
 
  Define vButton = GetAttribute(*this\scroll\v, #PB_Bar_NoButtons)
  Define hButton = GetAttribute(*this\scroll\h, #PB_Bar_NoButtons)
 
  PostEvent(#PB_Event_Gadget, 0,#MyCanvas, #PB_EventType_Resize)
  BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
 
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 2
            If GetGadgetState(2)
              SetGadgetState(3, GetAttribute(*this\scroll\v, #PB_Bar_Inverted))
            Else
              SetGadgetState(3, GetAttribute(*this\scroll\h, #PB_Bar_Inverted))
            EndIf
           
          Case 3
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #PB_Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #PB_Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            _Draw(#MyCanvas)
           
          Case 4
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * vButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            _Draw(#MyCanvas)
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --n82+f-----v--0------------------
; EnableXP