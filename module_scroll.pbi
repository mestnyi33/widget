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
  
  
  Declare.b Draw(*Scroll.Scroll_S)
  Declare.l Y(*Scroll.Scroll_S)
  Declare.l X(*Scroll.Scroll_S)
  Declare.l Width(*Scroll.Scroll_S)
  Declare.l Height(*Scroll.Scroll_S)
  Declare.b SetState(*Scroll.Scroll_S, ScrollPos.l)
  Declare.l SetAttribute(*Scroll.Scroll_S, Attribute.l, Value.l)
  Declare.b SetColor(*Scroll.Scroll_S, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  Declare.b Resize(*This.Scroll_S, iX.l,iY.l,iWidth.l,iHeight.l, *Scroll.Scroll_S=#Null)
  Declare.b Resizes(*v.Scroll_S, *h.Scroll_S, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This.Scroll_S, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0, AutoHide.b=0, *Scroll.Scroll_S=#Null, Window=-1, Gadget=-1)
  Declare.b Widget(*Scroll.Scroll_S, X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
  
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\Length / (_this_\Max-_this_\Min)), #PB_Round_Nearest))
  EndMacro
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\Length - (_this_\Area\Length / (_this_\Max-_this_\Min))*((_this_\Max-_this_\Min) - _this_\Page\Length), #PB_Round_Nearest)
  EndMacro
  
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
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid : If (Value>Max) : Value=Max : EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.l Pos(*This.Scroll_S, ThumbPos.l)
    Protected ScrollPos.l
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep)
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll.Scroll_S)
    With *Scroll
      If Not \Hide And \Alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[0],\Y[0],\Width[0],\Height[0],\Radius,\Radius,\Color\Back&$FFFFFF|\Alpha<<24)
        
        If \Vertical
          ; Draw left line
          If \Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \Radius : Box(\X[2],\Y[2]+\height[2]+1,\Width[2],\Height[2],\Color[0]\Back&$FFFFFF|\Alpha<<24) : EndIf
            Line(\X[0],\Y[0],1,\height[0]-\Radius/2,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[0],\Y[0],1,\Height[0],$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        Else
          ; Draw top line
          If \Both
            Line(\X[0],\Y[0],\width[0]-\Radius/2,1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[0],\Y[0],\Width[0],1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Thumb\Length
          ; Draw thumb
          DrawingMode(\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[3],\Y[3],\Width[3],\Height[3],\Color[3]\Fore,\Color[3]\Back, \Radius, \Alpha)
          
          ; Draw thumb frame
          If \DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[3],\Y[3],\Width[3],\Height[3],\Radius,\Radius,\Color[3]\Frame&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Button\Length
          ; Draw buttons
          DrawingMode(\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore,\Color[1]\Back, \Radius, \Alpha)
          BoxGradient(\Vertical,\X[2],\Y[2],\Width[2],\Height[2],\Color[2]\Fore,\Color[2]\Back, \Radius, \Alpha)
          
          ; Draw buttons frame
          If \DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color[1]\Frame&$FFFFFF|\Alpha<<24)
            RoundBox(\X[2],\Y[2],\Width[2],\Height[2],\Radius,\Radius,\Color[2]\Frame&$FFFFFF|\Alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\X[1]+(\Width[1]-\Size[1])/2,\Y[1]+(\Height[1]-\Size[1])/2, \Size[1], Bool(\Vertical), \Color[1]\Front&$FFFFFF|\Alpha<<24,\Type[1])
          Arrow(\X[2]+(\Width[2]-\Size[2])/2,\Y[2]+(\Height[2]-\Size[2])/2, \Size[2], Bool(\Vertical)+2, \Color[2]\Front&$FFFFFF|\Alpha<<24,\Type[2])
        EndIf
        
        If \DrawingMode = #PB_2DDrawing_Gradient
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2-3,9,1,\Color[3]\Front&$FFFFFF|\Alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2,9,1,\Color[3]\Front&$FFFFFF|\Alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2+3,9,1,\Color[3]\Front&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[3]+\Width[3]/2-3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front&$FFFFFF|\Alpha<<24)
            Line(\X[3]+\Width[3]/2,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front&$FFFFFF|\Alpha<<24)
            Line(\X[3]+\Width[3]/2+3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.l X(*Scroll.Scroll_S)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Y(*Scroll.Scroll_S)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Width(*Scroll.Scroll_S)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Width And \Alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Height(*Scroll.Scroll_S)
    Protected Result.l
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Height And \Alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*Scroll.Scroll_S, ScrollPos.l)
    Protected Result.b, Direction
    
    With *Scroll
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
      
      If ScrollPos < \Min : ScrollPos = \Min : EndIf
      If ScrollPos > (\Max-\Page\Length)
        ScrollPos = (\Max-\Page\Length)
      EndIf
      
      If \Page\Pos<>ScrollPos 
        If \Page\Pos>ScrollPos
          Direction =- ScrollPos
        Else
          Direction = ScrollPos
        EndIf
        
        \Page\Pos=ScrollPos
        \Thumb\Pos = ThumbPos(*Scroll, ScrollPos)
        
        If \Vertical
          \Y[3] = \Thumb\Pos
          \Height[3] = \Thumb\Length
        Else
          \X[3] = \Thumb\Pos
          \Width[3] = \Thumb\Length
        EndIf
        
        If \Gadget >- 1 
          ;Debug \Window
          If \Window =- 1
            \Window = EventWindow()
          EndIf
          
          PostEvent(#PB_Event_Widget, \Window, \Gadget, #PB_EventType_ScrollChange, Direction) 
        EndIf
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*Scroll.Scroll_S, Attribute.l, Value.l)
    Protected Result.l
    
    With *Scroll
      Select Attribute
        Case #PB_ScrollBar_Minimum
          If \Min <> Value
            \Min = Value
            \Page\Pos = Value
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_Maximum
          If \Max <> Value
            If \Min > Value
              \Max = \Min + 1
            Else
              \Max = Value
            EndIf
            
            \Page\ScrollStep = (\Max-\Min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \Page\Length <> Value
            If Value > (\Max-\Min) : \Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \Page\Length = (\Max-\Min)
            Else
              \Page\Length = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*Scroll.Scroll_S, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *Scroll
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\Line[State] = Color
          Else
            \Color[Item]\Line[State] = Color
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
            \Color\Frame[State] = Color
          Else
            \Color[Item]\Frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ResetColor(*Scroll)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  Procedure.b Resize(*This.Scroll_S, X.l,Y.l,Width.l,Height.l, *Scroll.Scroll_S=#Null)
    Protected Result, Lines, ScrollPage
    
    With *This
      ScrollPage = ((\Max-\Min) - \Page\Length)
      Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
      
      If *Scroll
        If \Vertical
          If Height=#PB_Ignore : If *Scroll\Hide : Height=(*Scroll\Y+*Scroll\Height)-\Y : Else : Height = *Scroll\Y-\Y : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *Scroll\Hide : Width=(*Scroll\X+*Scroll\Width)-\X : Else : Width = *Scroll\X-\X : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X[0] : EndIf : If Y=#PB_Ignore : Y = \Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \Width[0] : EndIf : If Height=#PB_Ignore : Height = \Height[0] : EndIf
      
      ;
      If ((\Max-\Min) >= \Page\Length)
        If \Vertical
          \Area\Pos = Y+\Button\Length
          \Area\Length = (Height-\Button\Length*2)
        Else
          \Area\Pos = X+\Button\Length
          \Area\Length = (Width-\Button\Length*2)
        EndIf
        
        If \Area\Length
          \Thumb\Length = ThumbLength(*This)
          
          If (\Area\Length > \Button\Length)
            If \Button\Length
              If (\Thumb\Length < \Button\Length)
                \Area\Length = Round(\Area\Length - (\Button\Length-\Thumb\Length), #PB_Round_Nearest)
                \Thumb\Length = \Button\Length 
              EndIf
            Else
              If (\Thumb\Length < 7)
                \Area\Length = Round(\Area\Length - (7-\Thumb\Length), #PB_Round_Nearest)
                \Thumb\Length = 7
              EndIf
            EndIf
          Else
            \Thumb\Length = \Area\Length 
          EndIf
          
          If \Area\Length > 0
            If (\Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\Length) >= (\Area\Length+\Button\Length)
              SetState(*This, ScrollPage)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
        EndIf
      EndIf
      
      
      \X[0] = X : \Y[0] = Y : \Width[0] = Width : \Height[0] = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\Length                   ; Top button coordinate on scroll bar
        \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\Length : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
        \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\Length           ; Thumb coordinate on scroll bar
      Else
        \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\Length : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\Length : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
        \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\Length          ; Thumb coordinate on scroll bar
      EndIf
      
      \Hide[1] = Bool(Not ((\Max-\Min) > \Page\Length))
      ProcedureReturn \Hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*v), iHeight = Y(*h)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*h\Page\Pos+iWidth 
      ScrollArea_Width=*h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*h\Page\Pos And
           ScrollArea_Width=*h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*v\Page\Pos+iHeight
      ScrollArea_Height=*v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*v\Page\Pos And
           ScrollArea_Height=*v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *v\Max<>ScrollArea_Height : SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
    If *h\Max<>ScrollArea_Width : SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
    
    If *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) 
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v)
    
    If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*v.Scroll_S, *h.Scroll_S, X.l,Y.l,Width.l,Height.l )
    If Width=#PB_Ignore : Width = *v\X+*v\Width : Else : Width+x : EndIf
    If Height=#PB_Ignore : Height = *h\Y+*h\Height : Else : Height+y : EndIf
    
    Protected iWidth = Width-Width(*v), iHeight = Height-Height(*h)
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    *v\Hide = Resize(*v, Width-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = Width-Width(*v)
    *h\Hide = Resize(*h, X, Height-*h\Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = Height-Height(*h)
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If *v\width : *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) : EndIf
    If *h\height : *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v) : EndIf
    
    ; Do we see both scrolbars?
    *v\Both = Bool(Not *h\Hide) 
    *h\Both = Bool(Not *v\Hide) 
    
    If *v\Hide : *v\Page\Pos = 0 : Else
      If *h\Radius : Resize(*h, #PB_Ignore, #PB_Ignore, *v\x+*v\Radius/2-1, #PB_Ignore) : EndIf
    EndIf
    If *h\Hide : *h\Page\Pos = 0 : Else
      If *v\Radius : Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h\y+*v\Radius/2-1) : EndIf
    EndIf
    
    ProcedureReturn Bool(*v\Hide|*h\Hide)
  EndProcedure
  
  Procedure.b CallBack(*This.Scroll_S, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0, AutoHide.b=0, *Scroll.Scroll_S=#Null, Window=-1, Gadget=-1)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis.Scroll_S, Cursor, Drag, Down
    
    If *This
      If EventType = #PB_EventType_LeftButtonDown
      ;  Debug "CallBack(*This.Scroll_S)"
      EndIf
      
      With *This
      If \Type = #PB_GadgetType_ScrollBar
      If \Hide And *This = *Thisis
        \Buttons = 0
        *Thisis = 0
        \Focus = 0
      EndIf
      
      ; get at point buttons
      If Down
        Buttons = \Buttons 
      Else
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
          If (Mousex>\x[1] And Mousex=<\x[1]+\Width[1] And  Mousey>\y[1] And Mousey=<\y[1]+\Height[1])
            Buttons = 1
          ElseIf (Mousex>\x[3] And Mousex=<\x[3]+\Width[3] And Mousey>\y[3] And Mousey=<\y[3]+\Height[3])
            Buttons = 3
          ElseIf (Mousex>\x[2] And Mousex=<\x[2]+\Width[2] And Mousey>\y[2] And Mousey=<\y[2]+\Height[2])
            Buttons = 2
          Else
            Buttons =- 1
          EndIf
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *Thisis = *This
            Select WheelDelta
              Case-1 : Result = SetState(*This, \Page\Pos - (\Max-\Min)/30)
              Case 1 : Result = SetState(*This, \Page\Pos + (\Max-\Min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \Buttons = 0 : Buttons = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown 
          If Not \Hide : Down = 1
            If Buttons : \Buttons = Buttons : Drag = 1 : *Thisis = *This : EndIf
            
            Select Buttons
              Case - 1
                If *Thisis = *This Or (\Height>(\Y[2]+\Height[2]) And \Buttons =- 1) 
                  If \Vertical
                    Result = SetState(*This, Pos(*This, (MouseY-\Thumb\Length/2)))
                  Else
                    Result = SetState(*This, Pos(*This, (MouseX-\Thumb\Length/2)))
                  EndIf
                EndIf
              Case 1 : Result = SetState(*This, (\Page\Pos - \Page\ScrollStep))
              Case 2 : Result = SetState(*This, (\Page\Pos + \Page\ScrollStep))
              Case 3 : LastX = MouseX - \Thumb\Pos : LastY = MouseY - \Thumb\Pos
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseMove
          If Drag
            If Bool(LastX|LastY) 
              If *Thisis = *This
                If \Vertical
                  Result = SetState(*This, Pos(*This, (MouseY-LastY)))
                Else
                  Result = SetState(*This, Pos(*This, (MouseX-LastX)))
                EndIf
              EndIf
            EndIf
          Else
            If Not \Hide
              If Buttons
                If Last <> Buttons
                  If *Thisis>0 : CallBack(*Thisis, #PB_EventType_MouseLeave, MouseX, MouseY, WheelDelta) : EndIf
                  EventType = #PB_EventType_MouseEnter
                  Last = Buttons
                EndIf
                
                If *Thisis <> *This 
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  ; Debug "Мышь находится внутри"
                  *Thisis = *This
                EndIf
                
                If Window >- 1 : \Window = Window : EndIf
                If Window >- 1 : \Gadget = Gadget : EndIf
                \Buttons = Buttons
              Else   ;   If *Thisis = *This
                EventType = #PB_EventType_MouseLeave
                \Buttons = 0
                Last = 0
              EndIf
            EndIf
          EndIf
          
      EndSelect
      
      ; set colors
      If Not \Hide
        Select EventType
          Case #PB_EventType_Focus : \Focus = #True : Result = #True
          Case #PB_EventType_LostFocus : \Focus = #False : Result = #True
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
            If Buttons>0
              \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Front = \Color[Buttons]\Front[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
            ElseIf Not Drag And Not Buttons 
              If *Thisis = *This And ((EventType = #PB_EventType_MouseLeave) And 
                                      Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)) Or 
                 EventType() = #PB_EventType_MouseLeave
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
                ; Debug "Мышь находится снаружи"
                *Thisis = 0
              EndIf
              ResetColor(*This)
            EndIf
            
            Result = #True
            
        EndSelect
      EndIf
      
      If AutoHide =- 1 : *Scroll = 0
        AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
      EndIf
      
      ; Auto hides
      If (AutoHide And Not Drag And Not Buttons) 
        If \Alpha <> \Alpha[1] : \Alpha = \Alpha[1] 
          Result =- 1
        EndIf 
      EndIf
      If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
        If \Alpha < 255 : \Alpha = 255
          
          If *Scroll
            If \Vertical
              Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
            Else
              Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
            EndIf
          EndIf
          
          Result =- 2
        EndIf 
      EndIf
      EndIf
    EndWith
  EndIf
  
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Widget(*Scroll.Scroll_S, X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l, Radius.l=0)
    
    With *Scroll
      \Alpha = 255
      \Alpha[1] = 0
      \Radius = Radius
      \Type[1] =- 1 ; -1 0 1
      \Type[2] =- 1 ; -1 0 1
      \Size[1] = 4
      \Size[2] = 4
      \Window =- 1
      \Gadget =- 1
      
      \Color[0] = Colors
      ResetColor(*Scroll)
      
      ; Цвет фона скролла
      \Color[0]\Back[1] = $FFF9F9F9
      \Color[1]\Front[1] = $FFA3A3A3
      \Color[2]\Front[1] = $FFA3A3A3
      \Color[3]\Front[1] = $FF3F3F3F
      ResetColor(*Scroll)
       
      \Type = #PB_GadgetType_ScrollBar
      \DrawingMode = #PB_2DDrawing_Gradient
      \Vertical = Bool(Flag&#PB_ScrollBar_Vertical)
      
      If \Vertical
        If width < 21
          \Button\Length = width - 1
        Else
          \Button\Length = 17
        EndIf
      Else
        If height < 21
          \Button\Length = height - 1
        Else
          \Button\Length = 17
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*Scroll, #PB_ScrollBar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*Scroll, #PB_ScrollBar_Maximum, Max) : EndIf
      If \Page\Length <> Pagelength : SetAttribute(*Scroll, #PB_ScrollBar_PageLength, Pagelength) : EndIf
    EndWith
    
    ProcedureReturn Resize(*Scroll, X,Y,Width,Height)
  EndProcedure
  
EndModule
;-

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Scroll
  
  Global *Vertical.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_0.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_1.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_2.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_3.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_4.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal_5.Scroll_S=AllocateStructure(Scroll_S)
  
  Procedure CallBacks()
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        
        Resize(*Vertical, Width-35, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Resize(*Horisontal_0, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        Resize(*Horisontal_1, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        Resize(*Horisontal_2, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        Resize(*Horisontal_3, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        Resize(*Horisontal_4, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        Resize(*Horisontal_5, #PB_Ignore, #PB_Ignore, Width-55, #PB_Ignore)
        
        Repaint = #True
    EndSelect
    
    If CallBack(*Vertical, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    
    If CallBack(*Horisontal_0, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If CallBack(*Horisontal_1, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If CallBack(*Horisontal_2, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If CallBack(*Horisontal_3, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If CallBack(*Horisontal_4, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If CallBack(*Horisontal_5, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height)
      Draw(*Vertical)
      Draw(*Horisontal_0)
      Draw(*Horisontal_1)
      Draw(*Horisontal_2)
      Draw(*Horisontal_3)
      Draw(*Horisontal_4)
      Draw(*Horisontal_5)
      StopDrawing()
    EndIf
    
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 1, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  If OpenWindow(0, 0, 0, 325, 223, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1,  10,10,305,203, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Vertical
      Widget(*Vertical, 270, 10,  25, 183 ,0, 300, 50, #PB_ScrollBar_Vertical, 4)
      SetColor(*Vertical, #PB_Gadget_BackColor, $FFF9F9F9)
      SetState(*Vertical, 100) 
    EndWith
    
    With *Horisontal_0
      \Hide = Widget(*Horisontal_0, 10, 10, 250,  18, 30, 100, 30, 0)
      SetColor(*Horisontal_0, #PB_Gadget_BackColor, $5A98FF)
      SetState(*Horisontal_0, 50) 
      \Button\Length=0
    EndWith
    With *Horisontal_1
      \Hide = Widget(*Horisontal_1, 10, 43, 250,  18, 30, 300, 30, 0)
      SetState(*Horisontal_1, 150) 
      \Type[1]=-1 : \Type[2]=1     ; Можно менять вид стрелки 
      \Size[1]=6 : \Size[2]=6      ; Можно задать размер стрелки 
    EndWith
    With *Horisontal_2
      \Hide = Widget(*Horisontal_2, 10, 76, 250,  18, 30, 100, 30, 0, 304)
      SetColor(*Horisontal_2, #PB_Gadget_BackColor, $BF853F)
      SetState(*Horisontal_2, 50) 
      \Button\Length=0
    EndWith
    With *Horisontal_3
      \Hide = Widget(*Horisontal_3, 10, 109, 250,  14, 30, 300, 30, 0, 304)
      SetState(*Horisontal_3, 150) 
      \Button\Length=35           ; Можно задать длину кнопки
      \Type[1]=0 : \Type[2]=0     ; Можно менять вид стрелки 
      \Size[1]=6 : \Size[2]=6     ; Можно задать размер стрелки 
    EndWith
    With *Horisontal_4
      \Hide = Widget(*Horisontal_4, 10, 142, 250,  18, 30, 100, 30, 0, 10)
      SetColor(*Horisontal_4, #PB_Gadget_BackColor, $2EC450)
      SetState(*Horisontal_4, 50) 
      \Button\Length=0
    EndWith
    With *Horisontal_5
      \Hide = Widget(*Horisontal_5, 10, 175, 250,  18, 30, 300, 30, 0, 10)
      SetState(*Horisontal_5, 150) 
      \Type[1]=-1 : \Type[2]=1 ; Можно менять вид стрелки 
      \Size[1]=6 : \Size[2]=6  ; Можно задать размер стрелки 
    EndWith
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    BindGadgetEvent(1, @CallBacks())
    WindowBounds(0, #PB_Default,223,#PB_Default,223) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = f-v-4--------------b---f7-8--
; EnableXP