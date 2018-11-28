CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
CompilerEndIf

DeclareModule Scroll
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Macro ThumbLength(_this_)
    Round(_this_\bar\Area\len - (_this_\bar\Area\len / (_this_\bar\Max-_this_\bar\Min))*((_this_\bar\Max-_this_\bar\Min) - _this_\bar\Page\len), #PB_Round_Nearest)
  EndMacro
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\bar\Area\Pos + Round((_scroll_pos_-_this_\bar\Min) * (_this_\bar\Area\len / (_this_\bar\Max-_this_\bar\Min)), #PB_Round_Nearest)) : If _this_\bar\Vertical : _this_\bar\Y[3] = _this_\bar\Thumb\Pos : _this_\bar\Height[3] = _this_\bar\Thumb\len : Else : _this_\bar\X[3] = _this_\bar\Thumb\Pos : _this_\bar\Width[3] = _this_\bar\Thumb\len : EndIf
  EndMacro
  
  Macro x(_this_) : _this_\bar\X+Bool(_this_\bar\hide[1] Or Not _this_\bar\alpha)*_this_\bar\Width : EndMacro
  Macro y(_this_) : _this_\bar\Y+Bool(_this_\bar\hide[1] Or Not _this_\bar\alpha)*_this_\bar\Height : EndMacro
  Macro width(_this_) : Bool(Not _this_\bar\hide[1] And _this_\bar\alpha)*_this_\bar\Width : EndMacro
  Macro height(_this_) : Bool(Not _this_\bar\hide[1] And _this_\bar\alpha)*_this_\bar\Height : EndMacro
  
  Declare.b Draw(*This.Scroll_S)
  Declare.b SetState(*This.Scroll_S, ScrollPos.i)
  Declare.i SetAttribute(*This.Scroll_S, Attribute.i, Value.i)
  Declare.i SetColor(*This.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This.Scroll_S, iX.i,iY.i,iWidth.i,iHeight.i, *That.Scroll_S=#Null)
  Declare.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This.Scroll_S, EventType.i, *mouse.Mouse_S, AutoHide.b=0)
  Declare.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
  Declare.i ReDraw(*Scroll.Scroll_S)
EndDeclareModule

Module Scroll
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
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If Value>Max 
        Value=Max 
      EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.i Pos(*This.Scroll_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match( \bar\Min + Round((ThumbPos - \bar\Area\Pos) / ( \bar\Area\len / ( \bar\Max-\bar\Min)), #PB_Round_Nearest), \bar\Page\ScrollStep) 
      If ( \bar\Vertical And \bar\Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \bar\Max-\bar\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*This.Scroll_S)
    With *This
      If Not \bar\hide And \bar\Alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \bar\X[0], \bar\Y[0], \bar\Width[0], \bar\Height[0], \bar\Radius, \bar\Radius, \bar\Color[0]\Back[\bar\Color[0]\State]&$FFFFFF|\bar\Alpha<<24)
        
        If \bar\Vertical
          ; Draw left line
          If \bar\Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \bar\Radius : Box( \bar\X[2], \bar\Y[2]+\bar\Height[2]+1, \bar\Width[2], \bar\Height[2], \bar\Color[0]\Back[\bar\Color[0]\State]&$FFFFFF|\bar\Alpha<<24) : EndIf
            Line( \bar\X[0], \bar\Y[0],1, \bar\Height[0]-\bar\Radius/2,$FFFFFFFF&$FFFFFF|\bar\Alpha<<24)
          Else
            Line( \bar\X[0], \bar\Y[0],1, \bar\Height[0],$FFFFFFFF&$FFFFFF|\bar\Alpha<<24)
          EndIf
        Else
          ; Draw top line
          If \bar\Both
            Line( \bar\X[0], \bar\Y[0], \bar\Width[0]-\bar\Radius/2,1,$FFFFFFFF&$FFFFFF|\bar\Alpha<<24)
          Else
            Line( \bar\X[0], \bar\Y[0], \bar\Width[0],1,$FFFFFFFF&$FFFFFF|\bar\Alpha<<24)
          EndIf
        EndIf
        
        If \bar\Thumb\len
          ; Draw thumb
          DrawingMode( \bar\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient( \bar\Vertical, \bar\X[3], \bar\Y[3], \bar\Width[3], \bar\Height[3], \bar\Color[3]\Fore[\bar\Color[3]\State], \bar\Color[3]\Back[\bar\Color[3]\State], \bar\Radius, \bar\Alpha)
          
          ; Draw thumb frame
          If \bar\DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \bar\X[3], \bar\Y[3], \bar\Width[3], \bar\Height[3], \bar\Radius, \bar\Radius, \bar\Color[3]\Frame[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
          EndIf
        EndIf
        
        If \bar\Button\len
          ; Draw buttons
          DrawingMode( \bar\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient( \bar\Vertical, \bar\X[1], \bar\Y[1], \bar\Width[1], \bar\Height[1], \bar\Color[1]\Fore[\bar\Color[1]\State], \bar\Color[1]\Back[\bar\Color[1]\State], \bar\Radius, \bar\Alpha)
          BoxGradient( \bar\Vertical, \bar\X[2], \bar\Y[2], \bar\Width[2], \bar\Height[2], \bar\Color[2]\Fore[\bar\Color[2]\State], \bar\Color[2]\Back[\bar\Color[2]\State], \bar\Radius, \bar\Alpha)
          
          ; Draw buttons frame
          If \bar\DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \bar\X[1], \bar\Y[1], \bar\Width[1], \bar\Height[1], \bar\Radius, \bar\Radius, \bar\Color[1]\Frame[\bar\Color[1]\State]&$FFFFFF|\bar\Alpha<<24)
            RoundBox( \bar\X[2], \bar\Y[2], \bar\Width[2], \bar\Height[2], \bar\Radius, \bar\Radius, \bar\Color[2]\Frame[\bar\Color[2]\State]&$FFFFFF|\bar\Alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow( \bar\X[1]+( \bar\Width[1]-\bar\Size[1])/2, \bar\Y[1]+( \bar\Height[1]-\bar\Size[1])/2, \bar\Size[1], Bool( \bar\Vertical), \bar\Color[1]\Front[\bar\Color[1]\State]&$FFFFFF|\bar\Alpha<<24, \bar\Type[1])
          Arrow( \bar\X[2]+( \bar\Width[2]-\bar\Size[2])/2, \bar\Y[2]+( \bar\Height[2]-\bar\Size[2])/2, \bar\Size[2], Bool( \bar\Vertical)+2, \bar\Color[2]\Front[\bar\Color[2]\State]&$FFFFFF|\bar\Alpha<<24, \bar\Type[2])
        EndIf
        
        If \bar\DrawingMode = #PB_2DDrawing_Gradient
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \bar\Vertical
            Line( \bar\X[3]+( \bar\Width[3]-8)/2, \bar\Y[3]+\bar\Height[3]/2-3,9,1, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
            Line( \bar\X[3]+( \bar\Width[3]-8)/2, \bar\Y[3]+\bar\Height[3]/2,9,1, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
            Line( \bar\X[3]+( \bar\Width[3]-8)/2, \bar\Y[3]+\bar\Height[3]/2+3,9,1, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
          Else
            Line( \bar\X[3]+\bar\Width[3]/2-3, \bar\Y[3]+( \bar\Height[3]-8)/2,1,9, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
            Line( \bar\X[3]+\bar\Width[3]/2, \bar\Y[3]+( \bar\Height[3]-8)/2,1,9, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
            Line( \bar\X[3]+\bar\Width[3]/2+3, \bar\Y[3]+( \bar\Height[3]-8)/2,1,9, \bar\Color[3]\Front[\bar\Color[3]\State]&$FFFFFF|\bar\Alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i ReDraw(*Scroll.Scroll_S)
    If *Scroll\output
      StopDrawing()
    EndIf
    
    *Scroll\output = StartDrawing(CanvasOutput(*Scroll\Widget))
    ClipOutput(0,0, X(*Scroll\v), Y(*Scroll\h))
    Debug PostEvent(#PB_Event_Gadget, *Scroll\Window,*Scroll\Widget,#PB_EventType_Repaint)
    
    
    ;       If Not *Scroll\v\bar\hide
    ;         Draw(*Scroll\v)
    ;       EndIf
    ;       If Not *Scroll\h\bar\hide
    ;         Draw(*Scroll\h)
    ;       EndIf
    ;       ;StopDrawing()
  EndProcedure
  
  Procedure.b SetState(*This.Scroll_S, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    ;If *This
      With *This
      If ( \bar\Vertical And \bar\Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \bar\Max-\bar\Min)-ScrollPos) : EndIf
      
      If ScrollPos < \bar\Min : ScrollPos = \bar\Min : EndIf
      If ScrollPos > ( \bar\Max-\bar\Page\len)
        ScrollPos = ( \bar\Max-\bar\Page\len)
      EndIf
      
      If \bar\Page\Pos <> ScrollPos 
        If \bar\Page\Pos > ScrollPos
          Direction =- ScrollPos
        Else
          Direction = ScrollPos
        EndIf
        \bar\Page\Pos = ScrollPos
        
        \bar\Thumb\Pos = ThumbPos(*This, ScrollPos)
        
        If \bar\Vertical
          \v\y =- \bar\Page\Pos
          If \v\Event
            PostEvent(\v\Event, \v\Window, \v\Widget, #PB_EventType_ScrollChange, Direction) 
          EndIf
        Else
          \h\x =- \bar\Page\Pos
          If \h\Event
            PostEvent(\h\Event, \h\Window, \h\Widget, #PB_EventType_ScrollChange, Direction) 
          EndIf
        EndIf
        
        Result = #True
      EndIf
    EndWith
  ;EndIf
  
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Scroll_S, Attribute.i, Value.i)
    Protected Result.i
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum
          If \bar\Min <> Value 
            \bar\Min = Value
            \bar\Page\Pos = Value
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_Maximum
          If \bar\Max <> Value
            If \bar\Min > Value
              \bar\Max = \bar\Min + 1
            Else
              \bar\Max = Value
            EndIf
            
            If \bar\Vertical
              \v\height = \bar\Max
            Else
              \h\width = \bar\Max
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \bar\Page\len <> Value
            If Value > ( \bar\Max-\bar\Min) 
              If Not \bar\Max 
                \bar\Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает 
              EndIf
              
              If \bar\Vertical
                \v\height = \bar\Max
              Else
                \h\width = \bar\Max
              EndIf
              
              \bar\Page\len = ( \bar\Max-\bar\Min)
            Else
              \bar\Page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
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
        \bar\Color\State = 0
      Else
        Count = State
        \bar\Color\State = State
      EndIf
      
      For State = \bar\Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \bar\Color[Item]\Line[State] <> Color 
              \bar\Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \bar\Color[Item]\Back[State] <> Color 
              \bar\Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \bar\Color[Item]\Front[State] <> Color 
              \bar\Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \bar\Color[Item]\Frame[State] <> Color 
              \bar\Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Resize(*This.Scroll_S, X.i,Y.i,Width.i,Height.i, *That.Scroll_S=#Null)
    Protected Result, Lines, ScrollPage
    
    With *This
      ScrollPage = (( \bar\Max-\bar\Min) - \bar\Page\len)
      Lines = Bool( \bar\Type=#PB_GadgetType_ScrollBar)
      
      If *That
        If \bar\Vertical
          If Height=#PB_Ignore : If *That\bar\hide : Height=(*That\bar\Y+*That\bar\Height)-\bar\Y : Else : Height = *That\bar\Y-\bar\Y : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *That\bar\hide : Width=(*That\bar\X+*That\bar\Width)-\bar\X : Else : Width = *That\bar\X-\bar\X : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \bar\X[0] : EndIf 
      If Y=#PB_Ignore : Y = \bar\Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \bar\Width[0] : EndIf 
      If Height=#PB_Ignore : Height = \bar\Height[0] : EndIf
      
      ;
      If (( \bar\Max-\bar\Min) > \bar\Page\len) ; = 
        If \bar\Vertical
          \bar\Area\Pos = Y+\bar\Button\len
          \bar\Area\len = (Height-\bar\Button\len*2)
        Else
          \bar\Area\Pos = X+\bar\Button\len
          \bar\Area\len = (Width-\bar\Button\len*2)
        EndIf
        
        If \bar\Area\len
          \bar\Thumb\len = ThumbLength(*This)
          
          If ( \bar\Area\len > \bar\Button\len)
            If \bar\Button\len
              If ( \bar\Thumb\len < \bar\Button\len)
                \bar\Area\len = Round( \bar\Area\len - ( \bar\Button\len-\bar\Thumb\len), #PB_Round_Nearest)
                \bar\Thumb\len = \bar\Button\len 
              EndIf
            Else
              If ( \bar\Thumb\len < 7)
                \bar\Area\len = Round( \bar\Area\len - (7-\bar\Thumb\len), #PB_Round_Nearest)
                \bar\Thumb\len = 7
              EndIf
            EndIf
          Else
            \bar\Thumb\len = \bar\Area\len 
          EndIf
          
          If \bar\Area\len > 0
            ; Debug " scroll set state "+\bar\Max+" "+\bar\Page\len+" "+Str( \bar\Thumb\Pos+\bar\Thumb\len) +" "+ Str( \bar\Area\len+\bar\Button\len)
            If ( \bar\Type <> #PB_GadgetType_TrackBar) And ( \bar\Thumb\Pos+\bar\Thumb\len) >= ( \bar\Area\Pos+\bar\Area\len)
              SetState(*This, ScrollPage)
            EndIf
            
            \bar\Thumb\Pos = ThumbPos(*This, \bar\Page\Pos)
          EndIf
        EndIf
      EndIf
      
      
      \bar\X[0] = X : \bar\Y[0] = Y : \bar\Width[0] = Width : \bar\Height[0] = Height                                             ; Set scroll bar coordinate
      
      If \bar\Vertical
        \bar\X[1] = X + Lines : \bar\Y[1] = Y : \bar\Width[1] = Width - Lines : \bar\Height[1] = \bar\Button\len                   ; Top button coordinate on scroll bar
        \bar\X[2] = X + Lines : \bar\Width[2] = Width - Lines : \bar\Height[2] = \bar\Button\len : \bar\Y[2] = Y+Height-\bar\Height[2] ; Botom button coordinate on scroll bar
        \bar\X[3] = X + Lines : \bar\Width[3] = Width - Lines : \bar\Y[3] = \bar\Thumb\Pos : \bar\Height[3] = \bar\Thumb\len           ; Thumb coordinate on scroll bar
      Else
        \bar\X[1] = X : \bar\Y[1] = Y + Lines : \bar\Width[1] = \bar\Button\len : \bar\Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \bar\Y[2] = Y + Lines : \bar\Height[2] = Height - Lines : \bar\Width[2] = \bar\Button\len : \bar\X[2] = X+Width-\bar\Width[2]  ; Right button coordinate on scroll bar
        \bar\Y[3] = Y + Lines : \bar\Height[3] = Height - Lines : \bar\X[3] = \bar\Thumb\Pos : \bar\Width[3] = \bar\Thumb\len          ; Thumb coordinate on scroll bar
      EndIf
      
      \bar\hide[1] = Bool(Not (( \bar\Max-\bar\Min) > \bar\Page\len))
      ProcedureReturn \bar\hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*Scroll\v), iHeight = Y(*Scroll\h)
    Static hPos, vPos : vPos = *Scroll\v\bar\Page\Pos : hPos = *Scroll\h\bar\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*Scroll\h\bar\Page\Pos+iWidth 
      ScrollArea_Width=*Scroll\h\bar\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*Scroll\h\bar\Page\Pos And
           ScrollArea_Width=*Scroll\h\bar\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*Scroll\v\bar\Page\Pos+iHeight
      ScrollArea_Height=*Scroll\v\bar\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*Scroll\v\bar\Page\Pos And
           ScrollArea_Height=*Scroll\v\bar\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*Scroll\h\bar\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*Scroll\v\bar\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *Scroll\v\bar\max<>ScrollArea_Height : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
    If *Scroll\h\bar\max<>ScrollArea_Width : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
    
    If *Scroll\v\bar\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\bar\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*Scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*Scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    *Scroll\v\bar\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
    *Scroll\h\bar\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
    
    If *Scroll\v\bar\hide : *Scroll\v\bar\Page\Pos = 0 : If vPos : *Scroll\v\bar\hide = vPos : EndIf : Else : *Scroll\v\bar\Page\Pos = vPos : *Scroll\h\bar\Width = iWidth+*Scroll\v\bar\Width : EndIf
    If *Scroll\h\bar\hide : *Scroll\h\bar\Page\Pos = 0 : If hPos : *Scroll\h\bar\hide = hPos : EndIf : Else : *Scroll\h\bar\Page\Pos = hPos : *Scroll\v\bar\Height = iHeight+*Scroll\h\bar\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
;     If Not Bool(*Scroll\v And *Scroll\h) 
;       If *Scroll\v
;         ProcedureReturn Resize(*Scroll\v, X.i,Y.i,Width.i,Height.i)
;       ElseIf *Scroll\h
;         ProcedureReturn Resize(*Scroll\h, X.i,Y.i,Width.i,Height.i)
;       EndIf
;     EndIf
    
    If Width=#PB_Ignore : Width = *Scroll\v\bar\X : Else : Width+x-*Scroll\v\bar\Width : EndIf
    If Height=#PB_Ignore : Height = *Scroll\h\bar\Y : Else : Height+y-*Scroll\h\bar\Height : EndIf
    
    Protected iWidth = x(*Scroll\v)-*Scroll\h\bar\x, iHeight = y(*Scroll\h)-*Scroll\v\bar\y
    
    If *Scroll\v\bar\width And *Scroll\v\bar\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\bar\height And *Scroll\h\bar\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    *Scroll\v\bar\Hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, #PB_Ignore, *Scroll\h) : iWidth = x(*Scroll\v)-*Scroll\h\bar\x
    *Scroll\h\bar\Hide = Resize(*Scroll\h, X, Height, #PB_Ignore, #PB_Ignore, *Scroll\v) : iHeight = y(*Scroll\h)-*Scroll\v\bar\y
    
    If *Scroll\v\bar\width And *Scroll\v\bar\Page\len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *Scroll\h\bar\height And *Scroll\h\bar\Page\len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If *Scroll\v\bar\width : *Scroll\v\bar\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) : EndIf
    If *Scroll\h\bar\height : *Scroll\h\bar\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v) : EndIf
    
    ; Do we see both scrolbars?
    *Scroll\v\bar\Both = Bool(Not *Scroll\h\bar\Hide) : *Scroll\h\bar\Both = Bool(Not *Scroll\v\bar\Hide) 
    
    If *Scroll\v\bar\Hide : *Scroll\v\bar\Page\Pos = 0 : Else
      If *Scroll\h\bar\Radius : Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\bar\x-*Scroll\h\bar\x)+Bool(*Scroll\v\bar\Radius)*4, #PB_Ignore) : EndIf
    EndIf
    If *Scroll\h\bar\Hide : *Scroll\h\bar\Page\Pos = 0 : Else
      If *Scroll\v\bar\Radius : Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\bar\y-*Scroll\v\bar\y)+Bool(*Scroll\h\bar\Radius)*4) : EndIf
    EndIf

    ProcedureReturn Bool(*Scroll\v\bar\Hide|*Scroll\h\bar\Hide)
  EndProcedure
  

 Procedure.i Events(*This.Scroll_S, EventType.i, Buttons)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *This
      With *This
        Select EventType
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
          If Buttons>0
            \bar\Color[Buttons]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
          Else
            \bar\Color[1]\State = 0
            \bar\Color[2]\State = 0
            \bar\Color[3]\State = 0
          EndIf
       
        Debug ""+*This +" "+ EventType +" "+ Buttons
      
           
          Repaint = #True
          
      EndSelect
    EndWith
  EndIf  
     
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b CallBack(*This.Scroll_S, EventType.i, *mouse.Mouse_S, AutoHide.b=0)
    Protected Result, Buttons, MouseX.i, MouseY.i, WheelDelta.i=0
    Static LastX, LastY, Last, *Last.Scroll_S, Cursor, Drag, Down
    
    If *This
      With *This
        If \bar\Type = #PB_GadgetType_ScrollBar
          ; get at point buttons
          If *mouse\buttons 
            
          ElseIf (*mouse\x>=\bar\X And *mouse\x<\bar\X+\bar\Width And *mouse\y>\bar\Y And *mouse\y=<\bar\Y+\bar\Height) 
            If (*mouse\x>\bar\X[1] And *mouse\x=<\bar\X[1]+\bar\Width[1] And  *mouse\y>\bar\Y[1] And *mouse\y=<\bar\Y[1]+\bar\Height[1])
              \bar\buttons = 1
            ElseIf (*mouse\x>\bar\X[3] And *mouse\x=<\bar\X[3]+\bar\Width[3] And *mouse\y>\bar\Y[3] And *mouse\y=<\bar\Y[3]+\bar\Height[3])
              \bar\buttons = 3
            ElseIf (*mouse\x>\bar\X[2] And *mouse\x=<\bar\X[2]+\bar\Width[2] And *mouse\y>\bar\Y[2] And *mouse\y=<\bar\Y[2]+\bar\Height[2])
              \bar\buttons = 2
            Else
              \bar\buttons =- 1
            EndIf 
            
            If \bar\Vertical
              \v\mouse\at = *This
            Else
              \h\mouse\at = *This
            EndIf
          Else
            \bar\buttons = 0
            
            If \bar\Vertical
              If Not \h\bar\buttons
                \v\mouse\at = 0
              EndIf
            Else
              If Not \v\bar\buttons
                \h\mouse\at = 0
              EndIf
            EndIf
          EndIf
          
          If \bar\Vertical
            If *Last <> \v\mouse\at And \v\mouse\at = *This
              If *Last 
                Result | Events(*Last, #PB_EventType_MouseLeave,0) 
              EndIf
              Result | Events(\v\mouse\at, #PB_EventType_MouseEnter,0)
              *Last = \v\mouse\at
            EndIf
          Else
            If *Last <> \h\mouse\at And \h\mouse\at = *This
              If *Last 
                Result | Events(*Last, #PB_EventType_MouseLeave,0) 
              EndIf
              Result | Events(\h\mouse\at, #PB_EventType_MouseEnter,0)
              *Last = \h\mouse\at
            EndIf
          EndIf
          
          If *Last = *This
            If Last <> *Last\bar\Buttons
              If Last
                Result | Events(*Last, #PB_EventType_MouseLeave, Last)
              EndIf
              Result | Events(*Last, #PB_EventType_MouseEnter, *Last\bar\Buttons)
              Last = *Last\bar\Buttons
            EndIf
            
            If EventType = #PB_EventType_LeftButtonDown
              Result = Events(*Last, #PB_EventType_LeftButtonDown, *Last\bar\Buttons)
            ElseIf EventType = #PB_EventType_LeftButtonUp
              Result = Events(*Last, #PB_EventType_LeftButtonUp, *Last\bar\Buttons)
            EndIf
          EndIf
          
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *This.Scroll_S = AllocateStructure(Scroll_S)
    ; 
    Protected Vertical = Bool(Flag=#PB_ScrollBar_Vertical)
    
    If Vertical
      *Scroll\v.Scroll_S = *This
      *Scroll\v\v = *Scroll
      *Scroll\v\h = *Scroll\h
      If *Scroll\h
        *Scroll\h\v = *Scroll\v
      EndIf
    Else
      *Scroll\h.Scroll_S = *This
      *Scroll\h\h = *Scroll
      *Scroll\h\v = *Scroll\v
      If *Scroll\v
        *Scroll\v\h = *Scroll\h
      EndIf
    EndIf
    
    ; Invisible
    If Flag =- 1
      ProcedureReturn *This
    EndIf
    
    With *This
      \bar\Alpha = 255
      \bar\Alpha[1] = 0
      \bar\Radius = Radius
      \bar\Type[1] =- 1 ; -1 0 1
      \bar\Type[2] =- 1 ; -1 0 1
      \bar\Size[1] = 4
      \bar\Size[2] = 4
      \bar\X =- 1
      \bar\Y =- 1
        
      ; Цвет фона скролла
      \bar\Color[0]\State = 0
      \bar\Color[0]\Back[0] = $FFF9F9F9
      \bar\Color[0]\Frame[0] = \bar\Color\Back[0]
      
      \bar\Color[1] = Colors
      \bar\Color[2] = Colors
      \bar\Color[3] = Colors
      
      \bar\Type = #PB_GadgetType_ScrollBar
      \bar\DrawingMode = #PB_2DDrawing_Gradient
      \bar\Vertical = Vertical
      
      If \bar\Vertical
        If width < 21
          \bar\Button\len = width - 1
        Else
          \bar\Button\len = 17
        EndIf
      Else
        If height < 21
          \bar\Button\len = height - 1
        Else
          \bar\Button\len = 17
        EndIf
      EndIf
      
      If \bar\Min <> Min : SetAttribute(*This, #PB_ScrollBar_Minimum, Min) : EndIf
      If \bar\Max <> Max : SetAttribute(*This, #PB_ScrollBar_Maximum, Max) : EndIf
      If \bar\Page\len <> Pagelength : SetAttribute(*This, #PB_ScrollBar_PageLength, Pagelength) : EndIf
    EndWith
    
    ProcedureReturn Resize(*This, X,Y,Width,Height)
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, x, y, Width, Height, Min, Max, PageLength, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
      StopDrawing()
    EndIf
  EndIf
    
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
   
  Procedure CallBack()
    If EventType() = #PB_EventType_ScrollChange ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    If EventType() = #PB_EventType_Repaint ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    
    Protected Repaint, iWidth, iHeight
    Protected Canvas = EventGadget()
    *Scroll\mouse\X = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    *Scroll\mouse\Y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    *Scroll\mouse\Wheel = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    *Scroll\mouse\Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Scroll::Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
    EndSelect
    
    If Scroll::CallBack(*Scroll\v, EventType(), *Scroll\mouse)
        Debug "vert "
      Scroll::ReDraw(*Scroll) ; PostEvent(#PB_Event_Gadget, *Scroll\Window, *Scroll\Widget, #PB_EventType_Repaint, *Scroll\v)
    EndIf
    
    If Scroll::CallBack(*Scroll\h, EventType(), *Scroll\mouse)
        Debug "horz "
      Scroll::ReDraw(*Scroll) ; PostEvent(#PB_Event_Gadget, *Scroll\Window, *Scroll\Widget, #PB_EventType_Repaint, *Scroll\h)
    EndIf
   ; Debug *Scroll\mouse\at
    
;     If *Scroll\v
;        iWidth = Scroll::X(*Scroll\v)
;     Else
;       iWidth = Width
;     EndIf
;     If *Scroll\h
;        iHeight = Scroll::Y(*Scroll\h)
;     Else
;       iHeight = Height
;     EndIf
    
;     If Repaint And StartDrawing(CanvasOutput(Canvas))
;       Box(0,0,Width,Height, $FFFFFF)
;       ClipOutput(0,0, iWidth, iHeight)
;       DrawImage(ImageID(0), *Scroll\x, *Scroll\y)
;       ;DrawImage(ImageID(0), -*Scroll\h\bar\Page\Pos, -*Scroll\v\bar\Page\Pos)
;       UnclipOutput()
; 
;       Scroll::Draw(*Scroll\v)
;       Scroll::Draw(*Scroll\h)
;       StopDrawing()
;     EndIf
  EndProcedure
  
  Procedure Events()
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    Select EventType()
      Case #PB_EventType_Repaint
        Debug 66666
       ; Box(0,0,Width,Height, $FFFFFF)
       ; ClipOutput(0,0, iWidth, iHeight)
        DrawImage(ImageID(0), *Scroll\x, *Scroll\y)
        
        UnclipOutput()
        Scroll::Draw(*Scroll\v)
        Scroll::Draw(*Scroll\h)
        ;DrawImage(ImageID(0), -*Scroll\h\bar\Page\Pos, -*Scroll\v\bar\Page\Pos)
       ; UnclipOutput()
      ProcedureReturn 555
        
      Case #PB_EventType_ScrollChange
        Debug EventData()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 325, 160, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1, 10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
    ; post event
    *Scroll\Window = 0
    *Scroll\Widget = 1
    *Scroll\Event = #PB_Event_Gadget ; #PB_Event_Widget
    
    ; *Scroll\h.Scroll_S = AllocateStructure(Scroll_S)
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,ImageHeight(0), 0, #PB_ScrollBar_Vertical, 7)
    Scroll::Widget(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,ImageWidth(0), 0, 0, 7)
        
    Scroll::SetState(*Scroll\v, 150)
    Scroll::SetState(*Scroll\h, 100)
    
    
    Scroll::Resizes(*Scroll, 0, 0, 305,140)
    Scroll::ReDraw(*Scroll)
    
    ;PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @CallBack())
    BindGadgetEvent(1, @Events())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --------------------00------
; EnableXP