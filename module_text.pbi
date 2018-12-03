CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

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
    _this_\Text\Count
  EndMacro
  
  Macro ClearItems(_this_) 
    _this_\Text\Count = 0
    _this_\Text\Change = 1 
    If _this_\Text\Editable
      _this_\Text\String = #LF$
    EndIf
    PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
  EndMacro
  
  Macro RemoveItem(_this_, _item_) 
    _this_\Text\Count - 1
    _this_\Text\Change = 1
    If _this_\Text\Count =- 1 
      _this_\Text\Count = 0 
      _this_\Text\String = #LF$
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    Else
      _this_\Text\String = RemoveString(_this_\Text\String, StringField(_this_\Text\String, _item_+1, #LF$) + #LF$)
    EndIf
  EndMacro
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*ThisWidget_S)
  Declare.s Make(*This.Widget_S, Text.s)
  Declare.i MultiLine(*This.Widget_S)
  Declare.i SelectionLimits(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i SetText(*This.Widget_S, Text.s)
  Declare.i GetFont(*This.Widget_S)
  Declare.i SetFont(*This.Widget_S, FontID.i)
  Declare.i AddLine(*This.Widget_S, Line.i, Text.s)
  Declare.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
  Declare.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
  Declare.i CallBack(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  ;Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
  
  Declare.i Caret(*This.Widget_S, Line.i = 0)
  Declare.i Remove(*This.Widget_S)
  Declare.i ToReturn(*This.Widget_S)
  Declare.i Change(*This.Widget_S, Pos.i, Len.i)
  
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
EndDeclareModule

Module Text
  ;- MACROS
  ;- PROCEDUREs
  Procedure.i Change(*This.Widget_S, Pos.i, Len.i)
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
        If (\index[2] > \index[1] Or \index[2] = \Items()\index) : \Text[1]\Change = #True
          \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
          \Text[1]\String.s = Left(\Text\String.s, \Text[1]\Len) 
          \Text[2]\Pos = \Text[1]\Len
        EndIf
        
        If (\index[2] < \index[1] Or \index[2] = \Items()\index) : \Text[3]\Change = #True
          \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
          \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
          \Text[3]\String.s = Right(\Text\String.s, \Text[3]\Len) 
        EndIf
          
        If \Text[1]\Len = \Text[3]\Pos
          \Text[2]\Len = 0
          \Text[2]\String.s = ""
        Else
          \Text[2]\Change = #True 
          \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
          \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text[2]\Pos, \Text[2]\Len) 
        EndIf
        
    EndWith
  EndProcedure
  
  Procedure.i Caret(*This.Widget_S, Line.i = 0)
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
  
  Procedure.i SelectionLimits(*This.Widget_S)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Caret + 1, 1))
      If _is_selection_end_(char)
        \Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Caret = i - 1
        \Items()\Text[2]\Len = \Caret[1] - \Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.i Remove(*This.Widget_S)
    With *This
      If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
    EndWith
  EndProcedure
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Index[2] <> \Index[1] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        If SelectElement(\Items(), \Index[2]) ;: Debug \Items()\Text\String.s
          String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + #LF$
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf   
        
        If SelectElement(\Items(), \Index[1]) ;: Debug "  "+\Items()\Text\String.s
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        
      Else
        String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + #LF$ +
                   \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
      EndIf
      
      \Index[2] + 1
      \Index[1] = \Index[2]
      
      \Caret = 0
      \Caret[1] = \Caret
      
      \Text\String.s = String.s
      \Text\Len = Len(\Text\String.s)
      \Text\Change =- 1 ; - 1 post event change widget
      
;       Debug \index[2]
;       If (\index[2] > 0 And \index[2] < ListSize(\items()) - 1) And 
;          SelectElement(\items(), \index[2]) And Not \Scroll\v\hide
;         CompilerIf Defined(Scroll, #PB_Module)
;           Scroll::SetState(\Scroll\v, (\items()\y-(Scroll::Y(\Scroll\h)-\items()\height)))
;         CompilerEndIf
;       EndIf
      
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  Procedure _Move(*This.Widget_S, Width)
    Protected Left,Right
    
    With *This
      Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Caret))
      ;If Right 
      Left = (Width + Right)
      ;If Not \Scroll\h\Buttons ; \Scroll\X <> Right
      
      If \Scroll\X < Right
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Caret = \Caret[1] And Not \Canvas\Input) ; Back string
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
  
  Procedure Move(*This.Widget_S, Width)
    Protected Left,Right
    
    With *This
      Right = TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Caret))
      ;If Right 
      Left = (Width - Right)
      ;If Not \Scroll\h\Buttons ; \Scroll\X <> Right
      
      If \Scroll\X > Right
        \Scroll\X = Right
      ElseIf \Scroll\X > Left
        \Scroll\X = Left
      ElseIf (\Scroll\X < 0 And \Caret = \Caret[1] And Not \Canvas\Input) ; Back string
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
              left.s = Left(\Text\String, \Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String, \Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Caret + 1, 1) = "."
                ;                 \Caret + 1 : \Caret[1]=\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String, \Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String, \Caret + 1, 1) <> "-"
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
  
  Procedure.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
    Protected line$, ret$="", LineRet$=""
    Protected.i CountString, i, start, ii, found, length
    
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
            If mode = 2 And CountString(Left((line$),ii), " ") > 1     And width > 71 ; button
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
      
      ret$ + LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  ;-
  Procedure AddLine(*This.Widget_S,Line.i,String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\Text\Count))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\Text\Count))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
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
      _this_\Items()\x = _this_\X[1]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[1]+_this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\Text\Count<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\Text\Count<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    With *This
      \Text\Count = ListSize(\Items())
      
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        ;         CompilerIf Defined(Scroll, #PB_Module) ; And (\Scroll\v And \Scroll\h)
        ;           Width = Abs(\Width[1]-\Text\X*2    -Scroll::Width(\Scroll\v)) ; bug in linux иногда
        ;           Height = \Height[1]-\Text\y*2      -Scroll::Height(\Scroll\h)
        ;         CompilerElse
        ;           Width = \Width[1]-\Text\X*2  
        ;           Height = \Height[1]-\Text\y*2 
        ;         CompilerEndIf
        CompilerIf Not Defined(Scroll, #PB_Module)
          \Scroll\Width[2] = \width[2]
          \Scroll\Height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \Scroll\width[2]
      height = \Scroll\height[2]
      
      ;       ; If Not \Text\Height And StartDrawing(CanvasOutput(\Canvas\Gadget)) ; с ним три раза быстрее
      ;       If StartDrawing(CanvasOutput(\Canvas\Gadget))
      ;         If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
      ;         If Not \Text\Height : \Text\Height = TextHeight("A") + 1 : EndIf
      ;         
      ;         If \Type = #PB_GadgetType_Button
      ;           \Items()\Text\Width = TextWidth(RTrim(String.s))
      ;         Else
      ;           \Items()\Text\Width = TextWidth(String.s)
      ;         EndIf
      ;         StopDrawing()
      ;       EndIf
      
      \Items()\Index[1] =- 1
      \Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; ; ; ;       ; Set line default colors             
      ; ; ; ;       \Items()\Color = \Color
      \Items()\Color\State = 1
      ; ; ; ;       \Items()\Color\Fore[\Items()\Color\State] = 0
      
      ; Update line pos in the text
      \Items()\Text\Len = Len(String.s)
      \Items()\Text\Pos = \Text\Pos
      \Text\Pos + \Items()\Text\Len + 1 ; Len(#LF$)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
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
  
  Procedure.i MultiLine(*This.Widget_S)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[2]-\Text\X*2
        Height = \Width[2]-\Text\y*2
      Else
        ;         CompilerIf Defined(Scroll, #PB_Module)
        ;           If *This\Scroll\v
        ;             width = Abs(*This\width[2]-\Text\X*2 -Scroll::Width(*This\Scroll\v)) ; bug in linux иногда
        ;           Else
        ;             width = Abs(*This\width[2]-\Text\X*2 )
        ;           EndIf
        ;           If *This\Scroll\h
        ;             height = *This\height[2]-Scroll::Height(*This\Scroll\h)
        ;           Else
        ;             height = *This\height[2]
        ;           EndIf
        width = \Scroll\width[2]-\Text\X*2-\sci\margin\width
        height = \Scroll\height[2]
        
        ;         CompilerElse
        ;           Width = \Width[2]-\Text\X*2  
        ;           Height = \Height[2]
        ;         CompilerEndIf
      EndIf
      
      ;  Debug ""+\Scroll\Width[2] +" "+ \Scroll\Height[2] +" "+ \Width[2] +" "+ \Height[2] +" "+ Width +" "+ Height
      
      If \Text\MultiLine > 0
        String.s = Wrap(\Text\String.s, Width, \Text\MultiLine)
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
        \Text\Count = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0;\Text\X
        
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Move(*This, Width)
        EndIf
        
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          \Text\Count[1] = \Text\Count
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              If AddElement(\Items())
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
                
                \Items()\x = \X[1]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[1]+\Text\X+Text_X
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
            For IT = 1 To \Text\Count
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If AddElement(\Items())
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
                
                ;                 ; Set line default colors             
                ;                 \Items()\Color = \Color
                \Items()\Color\State = 1
                
                ;                 \Items()\Color\Fore[\Items()\Color\State] = 0
                
                ; Update line pos in the text
                \Items()\Text\Pos = \Text\Pos
                \Items()\Text\Len = Len(String.s)
                \Text\Pos + \Items()\Text\Len + 1 ; Len(#LF$)
                
                _set_content_X_(*This)
                _line_resize_X_(*This)
                _line_resize_Y_(*This)
                
                If \Index[2] = ListIndex(\Items())
                  ;Debug " string "+String.s
                  \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
                  \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
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
          For IT = 1 To \Text\Count
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
  
  Procedure.i Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Resize
            ; Посылаем сообщение об изменении размера 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
            CompilerIf Defined(Scroll, #PB_Module)
              ;  Scroll::Resizes(\Scroll, \x[2]+\sci\margin\width,\Y[2],\Width[2]-\sci\margin\width,\Height[2])
              Scroll::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
            CompilerElse
              \Scroll\Width[2] = \width[2]
              \Scroll\Height[2] = \height[2]
            CompilerEndIf
          EndIf
          
          If \Text\Change
            \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          Text::MultiLine(*This)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \index[2] >= 0 And \index[2] < ListSize(\items()) - 1
            SelectElement(\items(), \index[2])
          EndIf
          
          CompilerIf Defined(Scroll, #PB_Module)
            If \Scroll\v And \Scroll\v\max <> \Scroll\Height And Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
              If \Text\editable And \index[2] > 0 And (\items()\y+\Text\y >= (Scroll::Y(\Scroll\h)-\items()\height))
                ; This is for the editor widget when you enter the key - (enter & backspace)
                Scroll::SetState(\Scroll\v, (\items()\y-(Scroll::Y(\Scroll\h)-\items()\height)))
              EndIf
              Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            ;           CompilerEndIf
;           
;           CompilerIf Defined(Scroll, #PB_Module)
;             If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
;                Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
;               Protected vDraw = Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;             EndIf
;             If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
;                Scroll::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
;               Protected hDraw = Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;             EndIf
;            
;             If vDraw
;               Scroll::Draw(\Scroll\v)
;             EndIf
;             If hDraw
;               Scroll::Draw(\Scroll\h)
;             EndIf
          CompilerEndIf
          
        EndIf 
        
        iX=\X[2]
        iY=\Y[2]
        iwidth = \Scroll\width[2]
        iheight = \Scroll\height[2]
        
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
      
      ; Draw items text
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
                CompilerIf Defined(Scroll, #PB_Module)
                  Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), 0,0) 
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
              
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\row\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
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
                
                ;                 CompilerIf Defined(Scroll, #PB_Module)
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
            ; Debug ""+ \index +" "+ *This\index[1] +" "+ *This\index[2] +" "+ *This\Caret +" "+ *This\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ; And *This\Caret = *This\Caret[1] And *This\Index[1] = *This\Index[2] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
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
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
               Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
              Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
               Scroll::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
           
            Scroll::Draw(\Scroll\v)
            Scroll::Draw(\Scroll\h)
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
  
  Procedure.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
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
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    With *This
      If X<>#PB_Ignore And 
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 1<<4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine Or \Type = #PB_GadgetType_Editor Or \Type = #PB_GadgetType_Scintilla  ; Or \Type = #PB_GadgetType_ListView
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            Text.s + #LF$
            \Text\String.s = Text.s
            ; \Text\Count = CountString(\Text\String.s, #LF$)
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
  
  Procedure.i GetFont(*This.Widget_S)
    ProcedureReturn *This\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
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
  
  Procedure.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
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
  
  Procedure.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
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
  Procedure.i Events(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last.Widget_S, *Widget.Widget_S    ; *Focus.Widget_S, 
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
                    PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
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
                \Canvas\Mouse\Delta = AllocateStructure(Mouse_S)
                \Canvas\Mouse\Delta\X = \Canvas\Mouse\X
                \Canvas\Mouse\Delta\Y = \Canvas\Mouse\Y
                \Canvas\Mouse\delta\at = \Canvas\mouse\at
                \Canvas\Mouse\Delta\buttons = \Canvas\Mouse\buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\Canvas\Mouse\Delta) : \Canvas\Mouse\Delta = 0
              ; ResetStructure(\Canvas\Mouse\Delta, Mouse_S)
              
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
  
  Procedure.i CallBack(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
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
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
        Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height)
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
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
            \Text\y = \fSize+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12
          Else
            \Text\X = \fSize+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12 
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
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
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
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, Text.s, Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Repaint, *This)
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
EndModule


;-
;- EXAMPLEs
CompilerIf #PB_Compiler_IsMainFile =99
  UseModule Text
  Global *T_0.Widget_S = AllocateStructure(Widget_S)
  Global *T_1.Widget_S = AllocateStructure(Widget_S)
  Global *T_2.Widget_S = AllocateStructure(Widget_S)
  Global *T_3.Widget_S = AllocateStructure(Widget_S)
  Global *T_4.Widget_S = AllocateStructure(Widget_S)
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        Result = 1
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height)
        Draw(*T_0, Canvas)
        Draw(*T_1, Canvas)
        Draw(*T_2, Canvas)
        Draw(*T_3, Canvas)
        Draw(*T_4, Canvas)
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "Left click "+EventGadget()+" "+EventType()
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(0, 0, 0, 270, 160, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0,  0, 0, 270, 160, #PB_Canvas_Keyboard)
    
    Widget(*T_0, 0, 10,  10, 250, 20, "TextGadget Standard (Left)")
    Widget(*T_1, 0, 10,  70, 250, 20, "TextGadget Center", #PB_Text_Center)
    Widget(*T_2, 0, 10,  40, 250, 20, "TextGadget Right", #PB_Text_Right)
    Widget(*T_3, 0, 10, 100, 250, 20, "TextGadget Border", #PB_Text_Border)
    Widget(*T_4, 0, 10, 130, 250, 20, "TextGadget Center + Border", #PB_Text_Center | #PB_Text_Border)
    
    BindEvent(#PB_Event_Widget, @Events())
    
    BindGadgetEvent(0, @CallBacks())
    PostEvent(#PB_Event_Gadget, 0,0, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Text
  Global *Text.Widget_S = AllocateStructure(Widget_S)
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Procedure Canvas_CallBack()
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(EventGadget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        If StartDrawing(CanvasOutput(EventGadget()))
          DrawingMode(#PB_2DDrawing_Default)
          Box(0,0,OutputWidth(),OutputHeight(), $FFF0F0F0)
          
          ForEach List()
            If Resize(List()\Widget, #PB_Ignore, #PB_Ignore, GadgetWidth(EventGadget()), #PB_Ignore);, EventGadget())
              Draw(List()\Widget)
              ; Draw(*Text, EventGadget())
            EndIf
          Next
          StopDrawing()
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    ResizeGadget(16, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Text.s = "строка_1"+Chr(10)+
  "строка__2"+Chr(10)+
  "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
  "строка_4"+#CRLF$+
  "строка__5";+#CRLF$
             ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
             ; Debug "len - "+Len(Text)
  
  If OpenWindow(0, 0, 0, 290, 760, "CanvasGadget", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(16, 10, 10, 200, 140*4+30, #PB_Canvas_Keyboard)
    BindGadgetEvent(16, @Canvas_CallBack())
    
    *B_0 = Create(16, -1, 0, 0, 200, 140, Text, #PB_Text_Center)
    *B_1 = Create(16, -1, 0, 150, 200, 140, Text, #PB_Text_Middle)
    *B_2 = Create(16, -1, 0, 300, 200, 140, Text, #PB_Text_Middle|#PB_Text_Right)
    *B_3 = Create(16, -1, 0, 450, 200, 140, Text, #PB_Text_Center|#PB_Text_Bottom)
    
    TextGadget(0, 10, 610, 200, 140, Text, #PB_Text_Border|#PB_Text_Center)
    ;   EditorGadget(4, 10, 220, 200, 200) : AddGadgetItem(10, -1, Text)
    ;SetGadgetFont(0,FontID)
    
    ResizeCallBack()
    ; ResizeWindow(0,WindowX(0)-180,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),0)
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ClearList(List())
    
    ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
    TextGadget(0, 10, 10, 380, 330, Text.s) 
    ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
    
    g=16
    CanvasGadget(g, 10, 350, 380, 330) 
    
    *Text = Create(g, -1, 0, 0, 380, 330, Text.s);, #PB_Text_Center|#PB_Text_Middle);
    SetColor(*Text, #PB_Gadget_BackColor, $FFCCBFB4)
    SetColor(*Text, #PB_Gadget_FrontColor, $FFD56F1A)
    SetFont(*Text, FontID(0))
    
    ; Get example
    SetGadgetFont(0, GetFont(*Text))
    SetGadgetColor(0, #PB_Gadget_BackColor, GetColor(*Text, #PB_Gadget_BackColor))
    SetGadgetColor(0, #PB_Gadget_FrontColor, GetColor(*Text, #PB_Gadget_FrontColor))
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    BindGadgetEvent(g, @Canvas_CallBack())
    PostEvent(#PB_Event_Gadget, 0,g, #PB_EventType_Resize) ; 
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -f9------+---0-----T+4-0-------------------------
; EnableXP