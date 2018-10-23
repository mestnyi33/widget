IncludePath "/Users/as/Documents/GitHub/Widget/"

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_text.pbi"
CompilerEndIf

;-
DeclareModule IPAddress
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  ;- - DECLAREs MACROs
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i Draw(*This.Widget_S, Canvas.i=-1)
  
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
EndDeclareModule

Module IPAddress
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  
  ;   Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
  ;     ProcedureReturn Text::Draw(*This, Canvas)
  ;     
  ;   EndProcedure
  Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    If Not *This\Hide
      With *This
        If Canvas=-1 
          Canvas = EventGadget()
        EndIf
        If Canvas <> \Canvas\Gadget
          ProcedureReturn
        EndIf
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[2],\Y[2],\Width[2],\Height[2]) ; Bug in Mac os
        CompilerEndIf
        
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore,\Color\Back,\Radius)
        
        
        ; Make output text
        If \Text\Change
          \Text\Height = TextHeight("A")
          \Text\Width = TextWidth(\Text\String.s)
        EndIf
        
        If (\Text\Change Or \Resize)
          If \Text\Vertical
            Width = \Height[1]-\Text\X*2-(\Image\Width+\Image\Width/2)
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2-(\Image\Width+\Image\Width/2)
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \Text\MultiLine
            \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, -1)
            \Text\CountString = CountString(\Text\String.s[2], #LF$)
          ElseIf \Text\WordWrap
            \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, 1)
            \Text\CountString = CountString(\Text\String.s[2], #LF$)
          Else
            ;  \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, 0)
            \Text\String.s[2] = \Text\String.s
            \Text\CountString = CountString(\Text\String.s[2], #LF$) + 1
          EndIf
          
          If \Text\CountString
            ClearList(\Items())
            
            If \Text\Align\Bottom
              Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
            ElseIf \Text\Align\Vertical
              Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent)
            If \Text\Vertical
              For IT = \Text\CountString To 1 Step - 1
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[2], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  Text_X=(Width-StringWidth)/2 
                EndIf
                
                AddElement(\Items())
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\Vertical = \Text\Vertical
                If \Text\Rotate = 270
                  \Items()\Text\x = \Image\Width+\X[1]+\Text\Y+Text_Y+\Text\Height+\Text\X
                  \Items()\Text\y = \Y[1]+\Text\X+Text_X
                Else
                  \Items()\Text\x = \Image\Width+\X[1]+\Text\Y+Text_Y
                  \Items()\Text\y = \Y[1]+\Text\X+Text_X+StringWidth
                EndIf
                \Items()\Text\Width = StringWidth
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                
                ;DrawRotatedText(\X[1]+\Text\Y+Text_Y, \Y[1]+\Text\X+Text_X+StringWidth, String.s, 90, \Color\Front)
                ;DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Width) : Break : EndIf
              Next
            Else
              For IT = 1 To \Text\CountString
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[2], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  Text_X=(Width-StringWidth)/2 
                EndIf
                
                AddElement(\Items())
                ;                   \Items()*This\Caret = *This\Caret 
                ;                   \Items()*This\Caret[1] = *This\Caret[1] 
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\x = (\Image\Width+\Image\Width/2)+\X[1]+\Text\X+Text_X
                \Items()\Text\y = \Y[1]+\Text\Y+Text_Y
                \Items()\Text\Width = StringWidth
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                \Image\X = \Items()\Text\x-(\Image\Width+\Image\Width/2)
                \Image\Y = \Y[1]+\Text\Y +(Height-\Image\Height)/2
                
                ;DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
              Next
            EndIf
          EndIf
        EndIf
        
        If \Text\Change
          \Text\Change = 0
        EndIf
        
        If \Resize
          \Resize = 0
        EndIf
        
      EndWith 
      
      ; Draw items text
      If ListSize(*This\Items())
        With *This\Items()
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Draw image
            If \Image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
            EndIf
            
            
            ; Draw string
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              *This\Text[3]\Width = TextWidth(Left(\Text\String.s, *This\Caret))
            EndIf 
            
            If \Text\String.s
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
              EndIf
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text[0]\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If *This\Focus = *This 
                Protected Left,Right
                Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
                Right = (*This\Width[2]-*This\Text\X-1) + Left
                
                If *This\Scroll\X < Left
                  *This\Scroll\X = Left
                ElseIf *This\Scroll\X > Right
                  *This\Scroll\X = Right
                ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1]) ; Back string
                  *This\Scroll\X = ((*This\Width[2]-*This\Text\X-1)-\Text[3]\Width) + Left
                  If *This\Scroll\X>0
                    *This\Scroll\X=0
                  EndIf
                EndIf
              EndIf
              
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
                ClipOutput(*This\X[2]+*This\Text[0]\X-1,*This\Y[2],*This\Width[2]-*This\Text[0]\X*2+2,*This\Height[2]) ; Bug in Mac os
              CompilerEndIf
              
              If \Text[2]\Len And #PB_Compiler_OS <> #PB_OS_MacOS
                If \Text[1]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
                If \Text[2]\String.s
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height+1, $DE9541)
                  
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, $FFFFFF)
                EndIf
                If \Text[3]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text[0]\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height+1, $FADBB3);$DE9541)
                EndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
              EndIf
            EndIf
            
          Next
          PopListPosition(*This\Items()) ; 
          If *This\Focus = *This 
            ;              Debug ""+ *This\Caret +" "+ *This\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *This\Text\Editable And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
            EndIf
          EndIf
        EndWith  
      EndIf
      
      ; Draw frames
      With *This
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[1]-2,\Y[1]-2,\Width[1]+4,\Height[1]+4) ; Bug in Mac os
        CompilerEndIf
        
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Default
          RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[3])
          ;           If \Radius ; Сглаживание краев)))
          ;             RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
          ;           EndIf
          ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[3])
        EndIf
        
        If \Focus = *This ;  Debug "\Focus "+\Focus
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[3])
          If \Radius ; Сглаживание краев))) ; RoundBox(\X[1],\Y[1],\Width[1]+1,\Height[1]+1,\Radius,\Radius,\Color\Frame[3])
            RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[3])
        Else
          If \fSize
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame)
          EndIf
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  
  Procedure _2Caret(*This.Widget_S, Line = 0)
    Static Caret.i 
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
          X = \Items()\X+(\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len + Len(" ")
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s+" "
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            ;             Debug "len " +Len
            For i = 0 To Len
              CursorX = X+TextWidth(Left(String.s, i))
              Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
              
              ; Получаем позицию коpректора
              If MinDistance > Distance 
                MinDistance = Distance
                Position = i
              EndIf
            Next
            
            If Caret <> Position
              *This\Text[3]\Width = TextWidth(Left(\Text\String.s, Position))
              Caret = Position
            EndIf
            
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
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
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
            
            ; Длина переноса строки
            PushListPosition(\Items())
            \Line = (((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / \Text\Height)
            Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2)) - 1)/2
            
            If LastLine <> \Line Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              If \Line[1] = \Line ; Если начинаем виделят сверху вниз
                If Position = len
                  If Item = \Line
                    If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                      \Items()\Text[2]\X = \Items()\Text[0]\X+\Items()\Text\Width
                    EndIf 
                    If Not SelectionLen
                      \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                    Else
                      \Items()\Text[2]\Width[2] = SelectionLen
                    EndIf
                  EndIf
                EndIf
                
              ElseIf \Line[1] < \Line ; Если начинаем виделят сверху вниз
                If Position = len
                  If Item = \Line
                    If Not SelectionLen
                      \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                    Else
                      \Items()\Text[2]\Width[2] = SelectionLen
                    EndIf
                  EndIf
                EndIf
                
                If PreviousElement(*This\Items())
                  If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                    \Items()\Text[2]\X = \Items()\Text[0]\X+\Items()\Text\Width
                  EndIf 
                  If Not SelectionLen
                    \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                  Else
                    \Items()\Text[2]\Width[2] = SelectionLen
                  EndIf
                EndIf
                
              ElseIf \Line[1] > \Line ; Если начинаем виделят снизу вверх
                If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                  \Items()\Text[2]\X = \Items()\Text[0]\X+\Items()\Text\Width
                EndIf 
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              LastItem = Item
              LastLine = \Line
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
  
  Procedure RemoveText(*This.Widget_S)
    With *This\Items()
      If *This\Caret > *This\Caret[1] : *This\Caret = *This\Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, *This\Caret, 1)
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, *This\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure _2SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      If (Caret <> *This\Caret Or Line <> *This\Line Or (*This\Caret[1] >= 0 And Caret1 <> *This\Caret[1]))
        \Text[2]\String.s = ""
        
        ; Если выделяем снизу вверх
        PushListPosition(*This\Items())
        If (*This\Line[1] > *This\Line)
          If PreviousElement(*This\Items()) And \Text[2]\Len : \Text[2]\Len = 0 : EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len : \Text[2]\Len = 0 : EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Line[1] = *This\Line
          ; Если выделяем с право на лево
          If *This\Caret[1] > *This\Caret 
            ; |<<<<<< to left
            Position = *This\Caret
            \Text[2]\Len = (*This\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Caret[1]
            \Text[2]\Len = (*This\Caret-Position)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf *This\Line > *This\Line[1]
          ; <<<<<|
          Position = *This\Caret
          \Text[2]\Len = \Text\Len-Position
        Else
          ; >>>>>|
          Position = 0
          \Text[2]\Len = *This\Caret
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Change = #True
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Change = #True
        
        Line = *This\Line
        Caret = *This\Caret
        Caret1 = *This\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      If Caret <> *This\Caret Or Line <> *This\Line Or (*This\Caret[1] >= 0 And Caret1 <> *This\Caret[1])
        \Text[2]\String.s = ""
        
        PushListPosition(*This\Items())
        If *This\Line[1] = *This\Line
          If *This\Caret[1] = *This\Caret And \Text[2]\Len > 0 : \Text[2]\Len = 0 : EndIf
        ElseIf *This\Line[1] > *This\Line
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 : \Text[2]\Len = 0 : EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len > 0 : \Text[2]\Len = 0 : EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Line[1] = *This\Line
          If *This\Caret[1] > *This\Caret 
            ; |<<<<<< to left
            Position = *This\Caret
            \Text[2]\Len = (*This\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Caret[1]
            \Text[2]\Len = (*This\Caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        ElseIf *This\Line > *This\Line[1]
          ; <<<<<|
          Position = *This\Caret[1]
          \Text[2]\Len = \Text\Len-Position
        Else
          ; >>>>>|
          Position = 0
          \Text[2]\Len = *This\Caret[1]
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Change = #True
        
        Line = *This\Line
        Caret = *This\Caret
        Caret1 = *This\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  
  
  Procedure ToLeft(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf  
      ElseIf \Caret[1] > 0 
        \Caret - 1 
      EndIf
      
      If \Caret[1] <> \Caret
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len 
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
      ElseIf \Caret[1] < \Items()\Text\Len
        \Caret[1] + 1 
      EndIf
      
      If \Caret <> \Caret[1] 
        \Caret = \Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Caret[1] > 0
        If \Items()\Text[2]\Len
          RemoveText(*This)
        Else         
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Caret - 1) + 
                                   Right(\Items()\Text\String.s, (\Items()\Text\Len-\Caret)) : \Caret - 1 
          \Items()\Text\Len = Len(\Items()\Text\String.s)
        EndIf
        
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Caret[1] < \Items()\Text\Len
        If \Items()\Text[2]\Len 
          RemoveText(*This)
        Else
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Caret) + 
                                   Right(\Items()\Text\String.s, (\Items()\Text\Len-\Caret) + 1)
          \Items()\Text\Len = Len(\Items()\Text\String.s)
        EndIf
        
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget_S)
    With *This\Items()
      Protected i, char = Asc(Mid(\Text\String.s, *This\Caret + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        *This\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = *This\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *This\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = *This\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *This\Caret = i - 1
        \Text[2]\Len = *This\Caret[1] - *This\Caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static Text$, DoubleClick
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Result, Buttons, Widget.i
    Static *Focus.Widget_S, *Last.Widget_S, *Widget.Widget_S, LastX, LastY, Last, Drag
    
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        If Canvas <> \Canvas\Gadget Or \Type <> #PB_GadgetType_IPAddress
          ProcedureReturn
        EndIf
        
        ; Get at point widget
        \Canvas\Mouse\From = From(*This)
        
        If Not \Hide And Not \Disable And Not \Canvas\Mouse\Buttons And \Interact 
          If EventType <> #PB_EventType_MouseLeave And \Canvas\Mouse\From 
            If *Last <> *This  
              If *Last
                If *Last > *This
                  ProcedureReturn
                Else
                  *Widget = *Last
                  ; Если с одного виджета перешли на другой, 
                  ; то посылаем событие выход для первого
                  CallBack(*Widget, #PB_EventType_MouseLeave, Canvas)
                  *Last = *This
                EndIf
              Else
                *Last = *This
              EndIf
              \Buttons = \Canvas\Mouse\From
              EventType = #PB_EventType_MouseEnter
              If Not \Checked : Buttons = \Buttons : EndIf
              \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              *Widget = *Last
              ; Debug "enter "+*Last\text\string+" "+EventType
            EndIf
          ElseIf *Last = *This
            ; Debug "leave "+*Last\text\string+" "+EventType+" "+*Widget
            If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
              \Cursor[1] = 0
            EndIf
            EventType = #PB_EventType_MouseLeave
            *Last = 0
          EndIf
        ElseIf *Widget = *This
          If EventType = #PB_EventType_LeftButtonUp And *Last = *Widget And CanvasModifiers=-1
            If Not \Canvas\Mouse\From
              CallBack(*Widget, #PB_EventType_LeftButtonUp, Canvas, 1)
              EventType = #PB_EventType_MouseLeave
            Else
              CallBack(*Widget, #PB_EventType_LeftButtonUp, Canvas, 1)
              EventType = #PB_EventType_LeftClick
            EndIf
            *Last = 0  
          EndIf
        EndIf
      EndWith
      
      ; Если канвас как родитель
      If *Last And *Widget = *This And Widget <> Canvas
        If EventType = #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
        ElseIf EventType = #PB_EventType_LeftButtonDown
          With List()\Widget
            PushListPosition(List())
            ForEach List()
              If *Widget <> List()\Widget
                If List()\Widget\Focus = List()\Widget : List()\Widget\Focus = 0
                  *Widget = List()\Widget
                  CallBack(List()\Widget, #PB_EventType_LostFocus, Canvas, 0)
                  *Widget = *Last
                EndIf
              EndIf
            Next
            PopListPosition(List())
          EndWith
          
          If *Widget\Focus <> *Widget 
            *Widget\Focus = *Widget
            *Focus = *Widget
            CallBack(*Widget, #PB_EventType_Focus, Canvas, 0)
          EndIf
        EndIf
      EndIf
    EndIf
    
    ;     If (*Widget = *This) Or (*Last = *This)
    ;       Select EventType
    ; ;         Case #PB_EventType_Focus          : Debug "Focus"          +" "+ *This\Text\String.s
    ; ;         Case #PB_EventType_LostFocus      : Debug "LostFocus"      +" "+ *This\Text\String.s
    ;         Case #PB_EventType_MouseEnter     ;: Debug "MouseEnter"     +" "+ *This\Text\String.s
    ;           If ListSize(*This\items())
    ;             Debug " "+*This\items()*This\Caret +" "+ *This\items()*This\Caret[1] +" "+ *This\items()\Text[2]\Len  +" "+ *This\Scroll\X;*This\items()\Text[1]\Width 
    ;             *This\items()\Text[1]\Width =0
    ;           EndIf
    ; ;         Case #PB_EventType_MouseLeave     : Debug "MouseLeave"     +" "+ *This\Text\String.s
    ; ;           ;         *Last = *Widget
    ; ;           ;         *Widget = 0
    ; ;         Case #PB_EventType_LeftButtonDown : Debug "LeftButtonDown" +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ; ;         Case #PB_EventType_LeftButtonUp   : Debug "LeftButtonUp"   +" "+ *This\Text\String.s
    ; ;         Case #PB_EventType_LeftClick      : Debug "LeftClick"      +" "+ *This\Text\String.s
    ;       EndSelect
    ;     EndIf
    
    
    Static MoveX, MoveY
    Protected Caret,Item.i, String.s
    
    If *Focus = *This And ListSize(*This\items())
      With *This\items()
        
        Select EventType
          Case #PB_EventType_LostFocus : Repaint = #True : *This\Caret[1] =- 1 ; Прячем коректор
          Case #PB_EventType_Focus : Repaint = #True : *This\Caret[1] = *This\Caret ; Показываем коректор
          Case #PB_EventType_LeftButtonDown
            *This\Caret = Caret(*This)
            
            If DoubleClick : DoubleClick = 0
              *This\Caret = 0
              *This\Caret[1] = \Text\Len
              \Text[2]\Len = \Text\Len
            Else
              *This\Caret[1] = *This\Caret
              \Text[2]\Len = 0
            EndIf 
            
            If \Text\Numeric
              \Text\String.s[1] = \Text\String.s
            EndIf
            
            Repaint = 2
            
          Case #PB_EventType_LeftDoubleClick : DoubleClick = 1
            SelectionLimits(*This)
            Repaint = 2
            
          Case #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
              *This\Caret = Caret(*This)
              Repaint = 2
            EndIf
            
          Case #PB_EventType_Input
            If *This\Text\Editable And Not (*This\Canvas\Key[1] & #PB_Canvas_Command)
              Protected Input, Input_2
              
              Select #True
                Case *This\Text\Lower : Input = Asc(LCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                Case *This\Text\Upper : Input = Asc(UCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                Case *This\Text\Pass  : Input = 9679 : Input_2 = *This\Canvas\Input ; "●"
                Case *This\Text\Numeric                                             ; : Debug Chr(\Canvas\Input)
                  Static Dot
                  
                  Select *This\Canvas\Input 
                    Case '.','0' To '9' : Input = *This\Canvas\Input : Input_2 = Input
                    Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
                    Default
                      Input_2 = *This\Canvas\Input
                  EndSelect
                  
                  If Not Dot And Input = '.'
                    Dot = 1
                  ElseIf Input <> '.'
                    Dot = 0
                  Else
                    Input = 0
                  EndIf
                  
                Default
                  Input = *This\Canvas\Input : Input_2 = Input
              EndSelect
              
              If Input_2
                If Input
                  If \Text[2]\Len : RemoveText(*This) : EndIf
                  *This\Caret + 1 : *This\Caret[1] = *This\Caret
                EndIf
                
                ;\Text\String.s = Left(\Text\String.s, *This\Caret-1) + Chr(Input) + Mid(\Text\String.s, *This\Caret)
                \Text\String.s = InsertString(\Text\String.s, Chr(Input), *This\Caret)
                \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), *This\Caret)
                
                If Input
                  *This\Text[3]\Change = 1
                  \Text\Len = Len(\Text\String.s)
                  PostEvent(#PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Change)
                EndIf
                
                Repaint = #True 
              EndIf
            EndIf
            
          Case #PB_EventType_KeyUp
            If \Text\Numeric
              \Text\String.s[1]=\Text\String.s 
            EndIf
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *This\Canvas\Key
              Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = 0 : *This\Caret[1] = *This\Caret : Repaint = #True 
              Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = \Text\Len : *This\Caret[1] = *This\Caret : Repaint = #True 
                
              Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = ToLeft(*This) ; Ok
              Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = ToRight(*This) ; Ok
              Case #PB_Shortcut_Back : Repaint = ToBack(*This)
              Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                
                
              Case #PB_Shortcut_X
                If \Text[2]\String.s And (*This\Canvas\Key[1] & #PB_Canvas_Control) 
                  SetClipboardText(\Text[2]\String.s)
                  RemoveText(*This)
                  *This\Caret[1] = *This\Caret
                  \Text\Len = Len(\Text\String.s)
                  Repaint = #True 
                EndIf
                
              Case #PB_Shortcut_C
                If \Text[2]\String.s And (*This\Canvas\Key[1] & #PB_Canvas_Control) 
                  SetClipboardText(\Text[2]\String.s)
                EndIf
                
              Case #PB_Shortcut_V
                If *This\Text\Editable And (*This\Canvas\Key[1] & #PB_Canvas_Control)
                  Protected ClipboardText.s = GetClipboardText()
                  
                  If ClipboardText.s
                    If \Text[2]\String.s
                      RemoveText(*This)
                    EndIf
                    
                    Select #True
                      Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                      Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                      Case \Text\Numeric 
                        If Val(ClipboardText.s)
                          ClipboardText.s = Str(Val(ClipboardText.s))
                        EndIf
                    EndSelect
                    
                    \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, *This\Caret + 1)
                    *This\Caret + Len(ClipboardText.s)
                    *This\Caret[1] = *This\Caret
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True
                  EndIf
                EndIf
                
            EndSelect 
            
            
        EndSelect
        
        If Repaint
          *This\Text[3]\Change = Bool(Repaint =- 1)
          
          SelectionText(*This)
        EndIf
      EndWith
      
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_IPAddress
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        
        Flag | #PB_Text_Numeric
        
        ; Set the default widget flag
        If Bool(Flag&#PB_Text_Top)
          Flag&~#PB_Text_Middle
        Else
          Flag|#PB_Text_Middle
        EndIf
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Widget_BorderLess)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+2 ; 2,6,1
          Else
            \Text\X = \fSize+2 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          If \Text\Pass
            Protected i,Len = Len(Text.s)
            Text.s = "" : For i=0 To Len : Text.s + "●" : Next
          EndIf
          
          Select #True
            Case \Text\Lower : \Text\String.s = LCase(Text.s)
            Case \Text\Upper : \Text\String.s = UCase(Text.s)
            Default
              \Text\String.s = Text.s
          EndSelect
          \Text\Change = #True
          \Text\Len = Len(\Text\String.s)
          
          
          If \Text\Editable
            \Color[0]\Back[1] = $FFFFFF 
          Else
            \Color[0]\Back[1] = $F0F0F0  
          EndIf
          
          ; Default frame color
          \Color[0]\Frame[1] = $BABABA
          
          ; Focus frame color
          \Color[0]\Frame[3] = $D5A719
          
          ResetColor(*This)
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
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule IPAddress
  
  Global *S_0.Widget_S = AllocateStructure(Widget_S)
  Global *S_1.Widget_S = AllocateStructure(Widget_S)
  Global *S_2.Widget_S = AllocateStructure(Widget_S)
  
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
        ForEach List()
          Resize(List()\Widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Next
        
        Result = 1
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          Result | CallBack(List()\Widget, EventType()) 
        Next
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $F0F0F0)
        
        ForEach List()
          Draw(List()\Widget)
        Next
        
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "Left click "+EventGadget()+" "+EventType()
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, 235, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    IPAddressGadget(0, 8,  10, 290, 20)
    
    ; Demo draw IPAddress on the canvas
    CanvasGadget(10,  305, 0, 310, 235, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, 20,"")
    *S_1 = Create(10, -1, 8,  35, 290, 20,"rr")
    *S_2 = Create(10, -1, 8,  60, 290, 20,"")
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 1022
; FirstLine = 1013
; Folding = -------------------------------
; EnableXP