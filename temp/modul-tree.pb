; ; ;IncludePath "C:\Users\as\Documents\GitHub\"
; ; XIncludeFile "module_scroll.pbi"

;
; Name          : module_tree.pbi
; Module name   : Tree
; Author        : mestnyi
; Last updated  : Sep 17, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=71123
; 

;
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
  Structure _S_page
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _S_button
  Structure _S_button
    x.l
    y.l
    width.l
    height.l
    len.l
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget
    x.l
    y.l
    width.l
    height.l
    
    max.l
    min.l
    
    type.l
    from.l
    focus.l
    radius.l
    
    hide.b[2]
    ; disable.b[2]
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    button._S_button[4] 
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
  
  ;-
  ;- DECLAREs
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1)
  Declare.b Draw(*this._S_widget)
  Declare.l WidgetY(*this._S_widget)
  Declare.l WidgetX(*this._S_widget)
  Declare.l WidgetWidth(*this._S_widget)
  Declare.l WidgetHeight(*this._S_widget)
  
  Declare.i GetState(*this._S_widget)
  Declare.i GetAttribute(*this._S_widget, Attribute.i)
  
  Declare.b SetState(*this._S_widget, ScrollPos.l)
  Declare.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
  Declare.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this._S_widget, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  Declare.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
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
  
  ; Inverted scroll bar position
  Macro _invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ;-
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min)) * ((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
    
    If _this_\thumb\len > _this_\area\len 
      _this_\thumb\len = _this_\area\len 
    EndIf 
    
    If _this_\Vertical
      _this_\button[#Thumb]\height = _this_\thumb\len
    Else
      _this_\button[#Thumb]\width = _this_\thumb\len
    EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    ; _start_
    If _this_\thumb\pos = _this_\area\pos
      _this_\color[#Button1]\state = #Disabled
    Else
      _this_\color[#Button1]\state = #Normal
    EndIf 
    
    ; _stop_
    If _this_\thumb\pos = _this_\area\end
      _this_\color[#Button2]\state = #Disabled
    Else
      _this_\color[#Button2]\state = #Normal
    EndIf 
    
    If _this_\vertical
      _this_\button[#Thumb]\y = _this_\thumb\pos
    Else
      _this_\button[#Thumb]\x = _this_\thumb\pos
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
    
    With *this
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If ScrollPos <> ThumbPos 
        ThumbPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        
        If #PB_GadgetType_TrackBar = \type And \vertical
          ThumbPos = _invert_(*this, ThumbPos, \inverted)
        EndIf
      
        Result = SetState(*this, ThumbPos)
        ScrollPos = ThumbPos
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
        RoundBox(\X,\Y,\Width,\height,\Radius,\Radius,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Thumb]\x,\button[#Thumb]\y,\button[#Thumb]\width,\button[#Thumb]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          BoxGradient(\Vertical,\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#Button1]\x,\button[#Button1]\y,\button[#Button1]\width,\button[#Button1]\height,\Radius,\Radius,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#Button2]\x,\button[#Button2]\y,\button[#Button2]\width,\button[#Button2]\height,\Radius,\Radius,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          
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
  Procedure.l WidgetX(*this._S_widget)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l WidgetY(*this._S_widget)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.l WidgetWidth(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l WidgetHeight(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*this._S_widget)
    ProcedureReturn *this\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select Attribute
        Case #PB_Bar_Minimum : Result = \min  ; 1
        Case #PB_Bar_Maximum : Result = \max  ; 2
        Case #PB_Bar_PageLength : Result = \page\len
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
      If ScrollPos < \min : ScrollPos = \min : EndIf
      If ScrollPos > (\max-\page\len) : ScrollPos = (\max-\page\len) : EndIf
      
      If #PB_GadgetType_TrackBar = \type And \vertical
        ScrollPos = PagePos(*this, ScrollPos)
      Else
        ScrollPos = PagePos(*this, _invert_(*this, ScrollPos, \inverted))
      EndIf
      
      If \page\pos <> ScrollPos
        \thumb\pos = ThumbPos(*this, _invert_(*this, ScrollPos, \inverted))
        
        If \inverted
          If \page\pos > ScrollPos
            \direction = _invert_(*this, ScrollPos, \inverted)
          Else
            \direction =- _invert_(*this, ScrollPos, \inverted)
          EndIf
        Else
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        EndIf
        
        \page\pos = ScrollPos
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
          \thumb\pos = ThumbPos(*this, _invert_(*this, \page\pos, \inverted))
          
        Case #PB_Bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_Bar_PageLength
          If \page\len <> Value
            If Value > (\max-\min) : \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
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
      ScrollPage = ((\max-\min) - \page\len)
      Lines = Bool(\type=#PB_GadgetType_ScrollBar)
      
      ;
      If X=#PB_Ignore : X = \X : EndIf : If Y=#PB_Ignore : Y = \Y : EndIf 
      If Width=#PB_Ignore : Width = \Width : EndIf : If Height=#PB_Ignore : Height = \height : EndIf
      
      ;
      If ((\max-\min) >= \page\len)
        If \Vertical
          \Area\pos = Y+\button\len
          \Area\len = (Height-\button\len*2)
        Else
          \Area\pos = X+\button\len
          \Area\len = (Width-\button\len*2)
        EndIf
        
        If \Area\len
          \thumb\len = ThumbLength(*this)
          ; area end pos
          \area\end = \area\pos + (\area\len-\thumb\len)
            
          If (\Area\len > \button\len)
            If \button\len
              If (\thumb\len < \button\len)
                \Area\len = Round(\Area\len - (\button\len-\thumb\len), #PB_Round_Nearest)
                \area\end = \area\pos + (\height-\button\len)
                \thumb\len = \button\len 
              EndIf
            Else
              ; TrackBar
              If (\thumb\len < 7)
                \Area\len = Round(\Area\len - (7-\thumb\len), #PB_Round_Nearest)
                \area\end = \area\pos + \Area\Len 
                \thumb\len = 7
              EndIf
            EndIf
          Else
            \area\end = \area\pos + (\height-\area\len)
            \thumb\len = \Area\len 
          EndIf
          
          If \Area\len > 0
            If (\type <> #PB_GadgetType_TrackBar) And (\thumb\pos+\thumb\len) >= (\Area\len+\button\len)
              SetState(*this, ScrollPage)
            EndIf
            
            \thumb\pos = ThumbPos(*this, _invert_(*this, \page\pos, \inverted))
          EndIf
        EndIf
      EndIf
      
      
      \X = X : \Y = Y : \Width = Width : \height = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \button[#Button1]\x = X + Lines : \button[#Button1]\y = Y : \button[#Button1]\width = Width - Lines : \button[#Button1]\height = \button\len                   ; Top button coordinate on scroll bar
        \button[#Button2]\x = X + Lines : \button[#Button2]\width = Width - Lines : \button[#Button2]\height = \button\len : \button[#Button2]\y = Y+Height-\button[#Button2]\height ; Botom button coordinate on scroll bar
        \button[#Thumb]\x = X + Lines : \button[#Thumb]\width = Width - Lines : \button[#Thumb]\y = \thumb\pos : \button[#Thumb]\height = \thumb\len                  ; Thumb coordinate on scroll bar
      Else
        \button[#Button1]\x = X : \button[#Button1]\y = Y + Lines : \button[#Button1]\width = \button\len : \button[#Button1]\height = Height - Lines                  ; Left button coordinate on scroll bar
        \button[#Button2]\y = Y + Lines : \button[#Button2]\height = Height - Lines : \button[#Button2]\width = \button\len : \button[#Button2]\x = X+Width-\button[#Button2]\width  ; Right button coordinate on scroll bar
        \button[#Thumb]\y = Y + Lines : \button[#Thumb]\height = Height - Lines : \button[#Thumb]\x = \thumb\pos : \button[#Thumb]\width = \thumb\len                 ; Thumb coordinate on scroll bar
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *scroll
      Protected iWidth = WidgetX(\v), iHeight = WidgetY(\h)
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
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
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
              Case-1 : Result = SetState(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*this, \page\pos + (\max-\min)/30)
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
                  Result = ScrollPos(*this, (MouseY-\thumb\len/2))
                Else
                  Result = ScrollPos(*this, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 
              If \inverted
                Result = SetState(*this, _invert_(*this, (\page\pos + \scrollstep), \inverted))
              Else
                Result = SetState(*this, _invert_(*this, (\page\pos - \scrollstep), \inverted))
              EndIf
              
            Case 2 
                If \inverted
                Result = SetState(*this, _invert_(*this, (\page\pos - \scrollstep), \inverted))
              Else
                Result = SetState(*this, _invert_(*this, (\page\pos + \scrollstep), \inverted))
              EndIf
            
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            If *thisis = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = ScrollPos(*this, (MouseY-LastY))
              Else
                Result = ScrollPos(*this, (MouseX-LastX))
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
  
  Procedure.i Gadget(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \scrollstep = 1
      \radius = Radius
      
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
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #PB_Bar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule


DeclareModule Tree
  EnableExplicit
  
  #NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  
  #CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #BorderSingle = 4
    #BorderDouble = 8
  CompilerElse
    #BorderSingle = 256 ; 4
    #BorderDouble = 65535 ; 8
  CompilerEndIf
  
  #BorderFlat = 16    
  #AlwaysShowSelection = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  #BorderLess = 64
  #BorderRaised = 128  
  
  
  #Selected = #PB_Tree_Selected                       ; 1
  #Checked = #PB_Tree_Checked                         ; 4
  #Expanded = #PB_Tree_Expanded                       ; 2
  #Collapsed = #PB_Tree_Collapsed                     ; 8
  
  #FullSelection = 512 ; #PB_ListIcon_FullRowSelect
  
  #SmallIcon = #PB_ListIcon_LargeIcon                 ; 0 0
  #LargeIcon = #PB_ListIcon_SmallIcon                 ; 1 1
  
  Structure Coordinate
        y.l[4]
        x.l[4]
        height.l[4]
        width.l[4]
  EndStructure
  
  Structure Text Extends Coordinate
    change.b
    string.s[2]
  EndStructure
  
  Structure Image Extends Coordinate
    change.b
    handle.i[2]
  EndStructure
  
  Structure Struct Extends Coordinate
    hide.b[2]
    disable.b[2]
    
    bSize.l
    fSize.l
    
    flag.l
    
    box.Coordinate
    
    *data
    
    canvas.l
    canvas_window.l
    canvas_gadget.l
    time.l
    from.l
    focus.l
    lostfocus.l
    
    checkboxed.b
    collapsed.b
    childrens.l
    Item.l
    adress.i
    
    sublevel.l
    
    text.text[4]
    image.image
    
    FontID.i
    Attribute.l
    
    Scroll.Scroll::_S_scroll
    List Items.Struct()
  EndStructure
  
  
  Declare.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, flag.l=0)
  Declare AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
  Declare ClearItems(Gadget.l)
  Declare CountItems(Gadget.l, Item.l=-1)
  Declare RemoveItem(Gadget.l, Item.l)
  Declare GetItemAttribute(Gadget.l, Item.l, Attribute.l)
  Declare GetItemData(Gadget.l, Item.l)
  Declare SetItemData(Gadget.l, Item.l, *data)
  Declare GetItemColor(Gadget.l, Item.l, ColorType.l, Column.l=0)
  Declare SetItemColor(Gadget.l, Item.l, ColorType.l, Color.l, Column.l=0)
  Declare GetItemImage(Gadget.l, Item.l)
  Declare SetItemImage(Gadget.l, Item.l, Image.l)
  Declare GetState(Gadget.l)
  Declare SetState(Gadget.l, Item.l)
  Declare GetItemState(Gadget.l, Item.l)
  Declare SetItemState(Gadget.l, Item.l, State.l)
  Declare.s GetText(Gadget.l)
  Declare   SetText(Gadget.l, Text.s)
  Declare.s GetItemText(Gadget.l, Item.l)
  Declare SetItemText(Gadget.l, Item.l, Text.s)
  Declare Free(Gadget.l)
  Declare ReDraw(Gadget.l)
EndDeclareModule

Module Tree
  
  Procedure from(*This.Struct, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.l=-1, collapsed.l, sublevel.l, coll.l
    
    With *This
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Items()\from = \Items()\Item 
          \Items()\from =- 1
          adress = @\Items()
          Break
        EndIf
      Next
      
      ForEach \Items()
        If \Items()\Item = \Items()\focus
          If Bool(MouseX=-1 And MouseY=-1 And focus=1)
            \Items()\lostfocus = \Items()\focus
          EndIf
          adress = @\Items()
          Break
        EndIf
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If (MouseY > (\Items()\Y) And MouseY =< ((\Items()\Y+\Items()\Height))) And 
             ((MouseX > \Items()\X) And (MouseX =< (\Items()\X+\Items()\Width)))
            
            If focus
              If (MouseY > (\Items()\box\y[1]) And MouseY =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((MouseX > \Items()\box\x[1]) And (MouseX =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checkboxed ! 1
              EndIf
              
              If (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0]))) And (Not \flag&#NoButtons And \Items()\childrens)
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If sublevel = \Items()\sublevel
                    Break
                  ElseIf sublevel < \Items()\sublevel 
                    If \Items()\adress
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\adress)
                      collapsed = \Items()\collapsed
                      If \Items()\hide
                        collapsed = 1
                      EndIf
                      PopListPosition(\Items())
                    EndIf
                    
                    \Items()\hide = collapsed
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                
                If Not *This\flag&#FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Item
                    lostfocus = \Items()\focus 
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                  If lostfocus <> \Items()\Item
                    \Items()\lostfocus = lostfocus
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Item
              EndIf
              
            EndIf
            
            \Items()\from = \Items()\Item
            adress = @\Items()
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure DrawBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) ; Рисуем стрелки
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
  
  Procedure Draw(*This.Struct)
    Protected x_content,y_point,x_point, width, w=18, level,iY, start,i, back_color=$FFFFFF
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 11, box_color=$7E7E7E, alpha = 255, item_alpha = 128, height =16
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = 4
    Protected Drawing.b
    
    If Bool(*This And StartDrawing(CanvasOutput(*This\canvas))) : If *This\FontID : DrawingFont(*This\FontID) : EndIf
      If *This\fSize
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*This\x[1], *This\y[1], *This\width[1], *This\height[1], $ADADAE)
      EndIf
      
      If *This\bSize
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*This\x[2]-1, *This\y[2]-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      With *This\Items()
        If ListSize(*This\Items())
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]
          width = *This\width[2]-Scroll::Width(*This\Scroll\v)
          
          ForEach *This\Items()
            If Not \hide
              ClipOutput(*This\x[2], *This\y[2], width, *This\height[2]-Scroll::Height(*This\Scroll\h))
              
              \x=*This\x[2]
              \width=width
              \height=height
              \y=*This\Scroll\height-*This\Scroll\v\Page\Pos
              
              If \text\change = 1
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  \text\height = TextHeight("A")
                CompilerElse
                  \text\height = 11 ; TextHeight("A") ; Bug in mac os
                CompilerEndIf
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag&#NoButtons 
                x_content=2+\x+(\sublevel*w)-*This\Scroll\h\Page\Pos
              Else
                x_content=2+\x+(w+\sublevel*w)-*This\Scroll\h\Page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = (\y+height)-(height+\box\height)/2
              
              If \Image\handle
                \Image\x = 2+x_content
                \Image\y = \y+(height-\Image\height)/2
                
                *This\Image\handle = \Image\handle
                *This\Image\width = \Image\width+4
              EndIf
              
              \text\x = 3+x_content+*This\Image\width
              \text\y = \y+(height-\text\height)/2
              
              If *This\flag&#CheckBoxes
                \box\x+w-2
                \text\x+w-2
                \Image\x+w-2 
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = x_content-(w+\box\width[1])/2 - (\sublevel*w)
                \box\y[1] = (\y+height)-(height+\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height
              If *This\Scroll\Width < (\text\x+\text\width)+*This\Scroll\h\Page\Pos
                *This\Scroll\Width = (\text\x+\text\width)+*This\Scroll\h\Page\Pos
              EndIf
              
              
              Drawing = Bool(\y+\height>*This\y[2] And \y<*This\height[2])
              If Drawing
                ; Draw selections
                If *This\flag&#FullSelection
                  If \Item=\from
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\x+1,\y+1,\width-2,\height-2, $FCEADA&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\x,\y,\width,\height, $FFC288&back_color|item_alpha<<24)
                  EndIf
                  
                  If \Item=\focus
                    If \lostfocus=\focus 
                      If *This\flag&#AlwaysShowSelection
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(\x+1,\y+1,\width-2,\height-2, $E2E2E2&back_color|item_alpha<<24)
                        
                        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                        Box(\x,\y,\width,\height, $C8C8C8&back_color|item_alpha<<24)
                      EndIf
                    Else
                      item_alpha = 200
                      
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\x+1,\y+1,\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
                      
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      Box(\x,\y,\width,\height, $DC9338&back_color|item_alpha<<24)
                    EndIf
                  EndIf
                Else
                  
                  If \Item=\focus
                    If \lostfocus=\focus 
                      If *This\flag&#AlwaysShowSelection
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(\text\x+1,\y+1,\text\width-2,\height-2, $E8E8E8&back_color|item_alpha<<24)
                        
                        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                        Box(\text\x,\y,\text\width,\height, $C4C4C4&back_color|item_alpha<<24)
                      EndIf
                    Else
                      item_alpha = 200
                      
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text\x+1,\y+1,\text\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
                      
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      Box(\text\x,\y,\text\width,\height, $DC9338&back_color|item_alpha<<24)
                    EndIf
                  EndIf
                  
                EndIf
                
                ; Draw boxes
                If Not *This\flag&#NoButtons And \childrens
                  If box_type=-1
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-3)/2, 3, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 2) 
                  Else
                    DrawingMode(#PB_2DDrawing_Gradient)
                    BackColor($FFFFFF) : FrontColor($EEEEEE)
                    LinearGradient(\box\x, \box\y, \box\x, (\box\y+\box\height))
                    RoundBox(\box\x+1,\box\y+1,\box\width-2,\box\height-2,box_type,box_type)
                    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    RoundBox(\box\x,\box\y,\box\width,\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                    
                    Line(\box\x+2,\box\y+\box\height/2 ,\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                    If \collapsed : Line(\box\x+\box\width/2,\box\y+2,1,\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If Not *This\flag&#NoLines 
                x_point=\box\x+\box\width/2
                y_point=\box\y+\box\height/2
                
                If x_point>*This\x[2]
                  ; Horisontal plot
                  If Drawing
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    For i=0 To line_size Step 2
                      If Not \childrens Or (\childrens And i>box_size/2)
                        Line(x_point+i,y_point,1,1, box_color&$FFFFFF|alpha<<24)
                      EndIf
                    Next
                  EndIf
                  
                  ; Vertical plot
                  If \adress 
                    start=Bool(Not \childrens And Not \sublevel)
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress) 
                    If start : start = (*This\y[2]+\height/2)-*This\Scroll\v\Page\Pos : Else : start = \y+\height+\height/2-line_size : EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    For i=start To y_point Step 2
                      If Bool(i>*This\y And i<*This\height)
                        Select Point(x_point,i)
                          Case $F3F3F3, $F7F7F7, $FBFBFB, 16645629, 15856113, 16119285, 16382457, 4286479998, 4294177779, 4294704123
                            Continue
                          Default
                            ; Debug Point(x_point,i)
                            Line(x_point,i,1,1, box_color&$FFFFFF|alpha<<24)
                        EndSelect
                      EndIf
                    Next
                    
                    PopListPosition(*This\Items())
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                ; Draw checkbox
                If *This\flag&#CheckBoxes
                  DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checkboxed, checkbox_color, box_color, 2, alpha);, box_type)
                EndIf
                
                ; Draw image
                If \Image\handle
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                EndIf
                
                ; Draw string
                If \text\string.s
                  ClipOutput(*This\x[2], *This\y[2], \width, *This\height[2])
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  If \Item=\focus And \lostfocus<>\focus
                    DrawText(\text\x, \text\y, \text\string.s, $FFFFFF&$FFFFFF|alpha<<24)
                  Else
                    DrawText(\text\x, \text\y, \text\string.s, $000000&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
            EndIf
          Next
        EndIf
        
        UnclipOutput()
        
        ; Задаем размеры скролл баров
        If *This\Scroll\v\Page\Len And *This\Scroll\v\Max<>*This\Scroll\Height And 
           Scroll::SetAttribute(*This\Scroll\v, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
         *This\Scroll\v\ScrollStep = height
        EndIf
        If *This\Scroll\h\Page\Len And *This\Scroll\h\Max<>*This\Scroll\Width And 
           Scroll::SetAttribute(*This\Scroll\h, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Scroll::Draw(*This\Scroll\v)
        Scroll::Draw(*This\Scroll\h)
        
        StopDrawing()
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(Gadget.l)
    Protected *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    If *This
      Draw(*This)
    EndIf
  EndProcedure
  
  Procedure AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
    Static adress.i
    Protected *This.Struct, Childrens.l, hide.b
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This\Items()
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(*This\Items()) - 1
        LastElement(*This\Items())
        AddElement(*This\Items()) 
        Item = ListIndex(*This\Items())
      Else
        SelectElement(*This\Items(), Item)
        If \sublevel>sublevel
          sublevel=\sublevel 
        EndIf
        InsertElement(*This\Items())
        
        PushListPosition(*This\Items())
        While NextElement(*This\Items())
          \Item = ListIndex(*This\Items())
        Wend
        PopListPosition(*This\Items())
      EndIf
      ;}
      
      If subLevel
        If sublevel>ListIndex(*This\Items())
          sublevel=ListIndex(*This\Items())
        EndIf
        PushListPosition(*This\Items()) 
        While PreviousElement(*This\Items()) 
          If subLevel = *This\Items()\subLevel
            adress = *This\Items()\adress
            Break
          ElseIf subLevel > *This\Items()\subLevel
            adress = @*This\Items()
            Break
          EndIf
        Wend 
        If adress
          ChangeCurrentElement(*This\Items(), adress)
          If subLevel > *This\Items()\subLevel
            sublevel=*This\Items()\sublevel + 1
            *This\Items()\childrens + 1
            *This\Items()\collapsed = 1
            hide = 1
          EndIf
        EndIf
        
        PopListPosition(*This\Items()) 
        \hide = hide
      Else
        If Not Item 
          adress = FirstElement(*This\Items()) 
        EndIf
      EndIf
      
      \from =- 1
      \focus =- 1
      \lostfocus =- 1
      \time = ElapsedMilliseconds()
      \Item = Item
      \adress = adress
      \text\change = 1
      \text\string.s = Text.s ;+" ("+Str(iadress)+"-"+Str(SubLevel)+")" 
      \sublevel = sublevel
      
      If IsImage(Image)
        Select *This\Attribute
          Case #LargeIcon
            \Image\width = 32
            \Image\height = 32
            ResizeImage(Image, \Image\width,\Image\height)
            
          Case #SmallIcon
            \Image\width = 16
            \Image\height = 16
            ResizeImage(Image, \Image\width,\Image\height)
            
          Default
            \Image\width = ImageWidth(Image)
            \Image\height = ImageHeight(Image)
        EndSelect   
        
        \Image\handle = ImageID(Image)
        \Image\handle[1] = Image
      EndIf
      
      ;       Re(*This)
      
      If *This\Scroll\Height=<*This\height
        ;  Draw(*This)
      EndIf
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(Gadget.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        Result = ClearList(\Items())
        If StartDrawing(CanvasOutput(Gadget))
          Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
          StopDrawing()
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CountItems(Gadget.l, Item.l=-1)
    Protected Result.l, *This.Struct, sublevel.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If Item.l=-1
          Result = ListSize(\Items())
        Else
          PushListPosition(\Items()) 
          ForEach \Items()
            If \Items()\Item = Item 
              ; Result = \Items()\childrens 
              sublevel = \Items()\sublevel
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  Result+1
                EndIf
              Wend
              PopListPosition(\Items())
              Break
            EndIf
          Next
          PopListPosition(\Items())
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure RemoveItem(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, sublevel.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            sublevel = \Items()\sublevel
            PushListPosition(\Items())
            While NextElement(\Items())
              If sublevel = \Items()\sublevel
                Break
              ElseIf sublevel < \Items()\sublevel 
                Result = DeleteElement(\Items()) 
              EndIf
            Wend
            PopListPosition(\Items())
            Result = DeleteElement(\Items()) 
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemAttribute(Gadget.l, Item.l, Attribute.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Select Attribute
              Case #PB_Tree_SubLevel
                Result = \Items()\sublevel
                
            EndSelect
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure GetItemData(Gadget.l, Item.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemData(Gadget.l, Item.l, *data)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            \Items()\data = *data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemColor(Gadget.l, Item.l, ColorType.l, Column.l=0)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemColor(Gadget.l, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemImage(Gadget.l, Item.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\Image
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemImage(Gadget.l, Item.l, image.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item And IsImage(image)
            \Items()\Image\handle = ImageID(image)
            \Items()\Image\handle[1] = image 
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\from = \Items()\Item 
            \Items()\from =- 1
            Result = @\Items()
            Break
          EndIf
        Next
        
        ForEach \Items()
          If \Items()\Item = \Items()\focus
            \Items()\lostfocus = \Items()\focus
            If Item =- 1 : \Items()\focus =- 1 : EndIf
            Result = @\Items()
            Break
          EndIf
        Next
        
        If Item <>- 1
          ForEach \Items()
            If \Items()\hide : Continue : EndIf
            If \Items()\Item = Item
              
              If Result 
                PushListPosition(\Items()) 
                ChangeCurrentElement(\Items(), Result)
                If \Items()\focus = \Items()\Item
                  lostfocus = \Items()\focus 
                  \Items()\lostfocus =- 1
                  \Items()\focus =- 1
                EndIf
                PopListPosition(\Items()) 
                If lostfocus <> \Items()\Item
                  \Items()\lostfocus = lostfocus
                EndIf
              EndIf
              
              \Items()\focus = \Items()\Item
              \Items()\from = \Items()\Item
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\from =- 1
              EndIf
              
              Result = @\Items()
              Break
              
            EndIf
          Next
        EndIf
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected Result.l, *This.Struct 
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This 
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            Result = \Items()\Item
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(Gadget.l, Item.l, State.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            If State&#Selected
              \Items()\focus = \Items()\Item
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\from =- 1
              EndIf
              
            EndIf
            If State&#Checked
              \Items()\checkboxed = 1
            EndIf
            If State&#Collapsed Or State&#Expanded
              \Items()\collapsed = Bool(State&#Collapsed)
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#Collapsed
                    \Items()\hide = 1
                  ElseIf State&#Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemState(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = #Selected
            If \Items()\collapsed
              Result | #Collapsed
            Else
              Result | #Expanded
            EndIf
            If \Items()\checkboxed
              Result | #Checked
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetText(Gadget.l)
    Protected Result.s, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf  
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetText(Gadget.l, Text.s)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(Gadget.l, Item.l)
    Protected Result.s, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemText(Gadget.l, Item.l, Text.s)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CallBack()
    Static m_b, m_x, m_y
    
    Protected Repaint.l
    Protected Event = EventType()
    Protected Window = EventWindow()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(Canvas, #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(Canvas, #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Protected *This.Struct = GetGadgetData(Canvas)
    
    With *This
      If *This\Scroll\v
        Repaint = Scroll::CallBack(*This\Scroll\v, Event, MouseX, MouseY, WheelDelta)
        If Repaint 
          ReDraw(Canvas)
          PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Change)
        EndIf
      EndIf
      
      If *This\Scroll\h
        Repaint = Scroll::CallBack(*This\Scroll\h, Event, MouseX, MouseY, WheelDelta)
        If Repaint 
          ReDraw(Canvas)
          PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Change)
        EndIf
      EndIf
      
      If Not (*This\Scroll\v\from Or *This\Scroll\h\from)
        Select Event
          Case #PB_EventType_MouseWheel
            If Not *This\Scroll\v\Hide
              Select -WheelDelta
                Case-1 : Repaint = Scroll::SetState(*This\Scroll\v, *This\Scroll\v\Page\Pos - (*This\Scroll\v\Max-*This\Scroll\v\Min)/30)
                Case 1 : Repaint = Scroll::SetState(*This\Scroll\v, *This\Scroll\v\Page\Pos + (*This\Scroll\v\Max-*This\Scroll\v\Min)/30)
              EndSelect
            EndIf
            
          Case #PB_EventType_LeftClick
            m_b=0
            m_x=0
            m_y=0
            
          Case #PB_EventType_LeftButtonDown
            Repaint = from(*This, MouseX, MouseY, 1)
            GadgetToolTip(canvas, GetText(Canvas))
            
          Case #PB_EventType_MouseMove
            Repaint = from(*This, MouseX, MouseY)
            
            If Buttons
              If m_x = 0
                m_x=MouseX
              EndIf
              If m_y = 0
                m_y=MouseY
              EndIf
              
              If m_x<>MouseX 
                m_x=MouseX
              EndIf
              If m_y<>MouseY 
                m_y=MouseY
              EndIf
              
              If (m_x=MouseX Or m_y=MouseY) And m_b = 0
                m_b = 1
                ;Debug GetText(Canvas)
                PostEvent(#PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_DragStart)
              EndIf
            EndIf
            
          Case #PB_EventType_MouseLeave
            Repaint = from(*This,-1,-1, 0)
            
            If m_b
              m_x=0
              m_y=0
              m_b=0
            EndIf
            
          Case #PB_EventType_LostFocus
            Repaint = from(*This,-1,-1, 1)
            
          Case #PB_EventType_Focus
            PushListPosition(\Items()) 
            ForEach \Items()
              If \Items()\Item = \Items()\focus And \Items()\focus = \Items()\lostfocus 
                \Items()\lostfocus =- 1
                Repaint = 1
                Break
              EndIf
            Next
            PopListPosition(\Items()) 
            
          Case #PB_EventType_Resize : ResizeGadget(\Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            \Width = GadgetWidth(\Canvas)
            \Height = GadgetHeight(\Canvas)
            
            ; Inner coordinate
            \X[2]=\bSize
            \Y[2]=\bSize
            \Width[2] = \Width-\bSize*2
            \Height[2] = \Height-\bSize*2
            
            ; Frame coordinae
            \X[1]=\X[2]-\fSize
            \Y[1]=\Y[2]-\fSize
            \Width[1] = \Width[2]+\fSize*2
            \Height[1] = \Height[2]+\fSize*2
            
            Scroll::Resizes(*This\Scroll, *This\X[2],*This\Y[2], *This\Width[2],*This\Height[2])
            Repaint = 1
        EndSelect
      Else
        Repaint = from(*This,-1,-1, 0)
      EndIf
    EndWith 
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, flag.l=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This.Struct=AllocateStructure(Struct)
    If *This
      With *This
        If Not flag&#BorderLess
          \bSize = 2
          \fSize = 2
        EndIf
        
        \canvas_window = GetActiveWindow()
        
        \Attribute=-1
        \FontID = GetGadgetFont(#PB_Default) ; FontID(LoadFont(#PB_Any,"Tahoma",8)) ; 
        \canvas = Gadget
        \flag = flag
        
        \Width = width
        \Height = height
        
        ; Inner coordinate
        \X[2]=\bSize
        \Y[2]=\bSize
        \Width[2] = \Width-\bSize*2
        \Height[2] = \Height-\bSize*2
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize+1
        \Y[1]=\Y[2]-\fSize+1
        \Width[1] = \Width[2]+\fSize*2-2
        \Height[1] = \Height[2]+\fSize*2-2
        
        *This\Scroll\v = Scroll::Gadget(#PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 8)
        *This\Scroll\h = Scroll::Gadget(#PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(flag&#NoButtons = 0 Or flag&#NoLines=0) * 16, 0,0,0, 0, 8)
        
        PostEvent(#PB_Event_Gadget, \canvas_window, Gadget, #PB_EventType_Resize)
        ; ;         AddWindowTimer(\canvas_window, 12, 5000)
        ; ;         BindEvent(#PB_Event_Timer, @bind(), \canvas_window, Gadget)
        
        
        ;         Debug SizeOf(*This\Scroll\h)
        ;         ; Set style windows 8
        ;         *This\Scroll\v\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\Scroll\v, #PB_Gadget_BackColor, *This\Scroll\v\Color\Back, 1)
        ;         Scroll::SetColor(*This\Scroll\v, #PB_Gadget_BackColor, *This\Scroll\v\Color\Back, 2)
        ;         
        ;         *This\Scroll\h\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\Scroll\h, #PB_Gadget_BackColor, *This\Scroll\h\Color\Back, 1)
        ;         Scroll::SetColor(*This\Scroll\h, #PB_Gadget_BackColor, *This\Scroll\h\Color\Back, 2)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.l)
    Protected Result, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      FreeStructure(*This)
      ; SetGadgetData(Gadget, #Null)
      UnbindGadgetEvent(Gadget, @CallBack())
      ; SetGadgetColor(Gadget, #PB_Gadget_BackColor, $FFFFFF)
      If StartDrawing(CanvasOutput(Gadget))
        Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
        StopDrawing()
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Tree
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_Tree
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        Debug Tree::GetText(EventGadget())
        Debug Tree::GetState(EventGadget())
        Debug Tree::GetItemState(EventGadget(), Tree::GetState(EventGadget()))
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/data/toolbar/paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
  EndIf
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    ; 1_example
    AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons)                                         
    ;   ;  2_example
    ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
    ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
    ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
    ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    ;  6_example
    AddGadgetItem(g, 0, "Tree_1", 0, 1) 
    AddGadgetItem(g, 0, "Tree_2_1", 0, 2) 
    AddGadgetItem(g, 0, "Tree_2_2", 0, 3) 
    
    
    g = 10
    Gadget(g, 10, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_CheckBoxes|#FullSelection)                                         
    ; 1_example
    AddItem (g, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (g, -1, "Sub-Item 2", -1, 11)
    AddItem (g, -1, "Sub-Item 3", -1, 1)
    AddItem (g, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (g, -1, "Sub-Item 5", -1, 11)
    AddItem (g, -1, "Sub-Item 6", -1, 1)
    AddItem (g, -1, "File "+Str(a), -1, 0)  
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(g,1)
    Tree::SetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    ;Tree::SetState(g, 1)
    ;Tree::SetState(g, -1)
    ;     Debug "c "+Tree::GetText(g)
    
    g = 11
    Gadget(g, 230, 230, 210, 210, #AlwaysShowSelection|#FullSelection)                                         
    ;  3_example
    AddItem(g, 0, "Tree_0", -1 )
    AddItem(g, 1, "Tree_1_1", 0, 1) 
    AddItem(g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(g, 8, "Tree_1_1_2_1_1", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    
    AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(g, 8, "Tree_1_1_2_1_1", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(g)
    
    g = 12
    Gadget(g, 450, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons|#FullSelection)                                        
    ;   ;  2_example
    ;   AddItem (g, 0, "Normal Item "+Str(a), -1, 0)                                    
    ;   AddItem (g, 1, "Node "+Str(a), -1, 1)                                           
    ;   AddItem (g, 4, "Sub-Item 1", -1, 2)                                            
    ;   AddItem (g, 2, "Sub-Item 2", -1, 1)
    ;   AddItem (g, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(g, -1, "Tree_"+Str(i), -1) 
      Else
        AddItem(g, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 13
    Gadget(g, 670, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ;  4_example
    AddItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(g, 1, "Tree_1", -1, 1) 
    AddItem(g, 2, "Tree_2_2", -1, 2) 
    AddItem(g, 2, "Tree_2_1", -1, 1) 
    AddItem(g, 3, "Tree_3_1", -1, 1) 
    AddItem(g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    Gadget(g, 890, 230, 103, 210, #AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ;  5_example
    AddItem(g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(g, 1, "Tree_1", -1, 1) 
    AddItem(g, 2, "Tree_2_1", -1, 1) 
    AddItem(g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    Gadget(g, 890+106, 230, 103, 210, #AlwaysShowSelection|#BorderLess)                                         
    ;  6_example
    AddItem(g, 0, "Tree_1", -1, 1) 
    AddItem(g, 0, "Tree_2_1", -1, 2) 
    AddItem(g, 0, "Tree_2_2", -1, 3) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ;Free(g)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 403
; FirstLine = 394
; Folding = +-----------------------------------------------------------
; EnableXP