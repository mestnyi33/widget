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
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*ThisWidget_S, Canvas.i=-1)
  Declare.s Make(*This.Widget_S, Text.s)
  Declare.i MultiLine(*This.Widget_S)
  Declare.i SelectionLimits(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i SetText(*This.Widget_S, Text.s)
  Declare.i GetFont(*This.Widget_S)
  Declare.i SetFont(*This.Widget_S, FontID.i)
  Declare.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
  Declare.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
EndDeclareModule

Module Text
  
  ;- MACROS
  ;- PROCEDUREs
  Procedure.i Clip(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    ; Static Clip_X.i,Clip_Y.i,Clip_Width.i,Clip_Height.i
    
    With *This
      If X<>#PB_Ignore 
        \Clip\X = X
      EndIf
      If Y<>#PB_Ignore 
        \Clip\Y = Y
      EndIf
      If Width<>#PB_Ignore 
        \Clip\Width = Width
      EndIf
      If Height<>#PB_Ignore 
        \Clip\Height = Height
      EndIf
      
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
        ClipOutput(\Clip\X,\Clip\Y,\Clip\Width,\Clip\Height)
      CompilerEndIf
    EndWith
  EndProcedure
  
  Procedure.s Make(*This.Widget_S, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric
        Static Dot, Minus
        Protected Chr.s, Input.i
        
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
            If Not Dot And Input = '.'
              Dot = 1
            ElseIf Input <> '.'
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-'
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
    
    Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    Text.s = ReplaceString(Text.s, #CR$, #LF$)
    Text.s + #LF$
    
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
            If mode =- 1 And CountString(Left((line$),ii), " ") > 1     And width > 71 ; button
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
      
      ret$ +  LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget_S)
    With *This
      Protected i, char = Asc(Mid(\Items()\Text\String.s, \Caret + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        \Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        \Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        \Caret = i - 1
        \Items()\Text[2]\Len = \Caret[1] - \Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.i MultiLine(*This.Widget_S)
    Static Len
    Protected Repaint, String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\InLine
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
        If _this_\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-StringWidth)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+StringWidth)/2+Indent
          Else
            Text_X=((Width-StringWidth+_this_\Image\Width)/2)+Indent
            Image_X=(Width-StringWidth-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-StringWidth)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-StringWidth) 
        ElseIf _this_\Text\Align\Horisontal
          Text_X=(Width-StringWidth-Bool(StringWidth % 2))/2 
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_(_this_)
      _this_\Items()\x = _this_\X[1]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[1]+_this_\Text\X+Image_X
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
    EndMacro
    
    
    With *This
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Defined(Scroll, #PB_Module)
          Width = \Width[1]-\Text\X*2    -Scroll::Width(\vScroll)
          Height = \Height[1]-\Text\y*2  -Scroll::Height(\hScroll)
        CompilerElse
          Width = \Width[1]-\Text\X*2  
          Height = \Height[1]-\Text\y*2 
        CompilerEndIf
      EndIf
      
      If \Text\MultiLine
        String.s = Text::Wrap(\Text\String.s, Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s
      EndIf
      
      Len = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        ; Посылаем сообщение об изменении содержимого 
        If \Text\Editable And \Text\Change=-1 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
        EndIf
        
        \Text\String.s[2] = String.s
        \Text\Count = CountString(String.s, #LF$)
        
        \Scroll\Width = 0 
        _set_content_Y_(*This)
        
        If ListSize(\Items()) 
          Protected Left,Right
          
          Right =- TextWidth(Mid(\Text\String.s, \Items()\Caret, \Caret))
          Left = (Width + Right)
          ; Debug " "+Left+" "+Right
          
          If *This\Scroll\X < Right
            *This\Scroll\X = Right
          ElseIf *This\Scroll\X > Left
            *This\Scroll\X = Left
          ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
            *This\Scroll\X = (\Items()\Width-\Items()\Text[3]\Width) + Right
            If *This\Scroll\X>0
              *This\Scroll\X=0
            EndIf
          EndIf
          
        EndIf
        
        
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          ClearList(\Items())
          \Scroll\Height = 0
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              AddElement(\Items())
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If \Type = #PB_GadgetType_Button
                StringWidth = TextWidth(RTrim(String))
              Else
                StringWidth = TextWidth(String)
              EndIf
              
              If \Text\Align\Right
                Text_X=(Width-StringWidth) 
              ElseIf \Text\Align\Horisontal
                Text_X=(Width-StringWidth-Bool(StringWidth % 2))/2 
              EndIf
              
              \Items()\x = \X[1]+\Text\Y+\Scroll\Height+Text_Y
              \Items()\y = \Y[1]+\Text\X+Text_X
              \Items()\Width = \Text\Height
              \Items()\Height = Width
              \Items()\Item = ListIndex(\Items())
              
              \Items()\Text\Editable = \Text\Editable 
              \Items()\Text\Vertical = \Text\Vertical
              If \Text\Rotate = 270
                \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
                \Items()\Text\y = \Items()\y
              Else
                \Items()\Text\x = \Image\Width+\Items()\x
                \Items()\Text\y = \Items()\y+StringWidth
              EndIf
              \Items()\Text\Width = StringWidth
              \Items()\Text\Height = \Text\Height
              \Items()\Text\String.s = String.s
              \Items()\Text\Len = Len(String.s)
              
              ; Указываем какие линии будут видни
              If Not Bool(\Items()\x >\x[2] And (\Items()\x-\x[2])+\Items()\width<\width[2])
                \Items()\Hide = 1
              EndIf
              
              \Scroll\Height+\Text\Height 
            Next
          Else
            For IT = 1 To \Text\Count
              AddElement(\Items())
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If \Type = #PB_GadgetType_Button
                StringWidth = TextWidth(RTrim(String))
              Else
                StringWidth = TextWidth(String)
              EndIf
              
              _set_content_X_(*This)
              
              \Items()\Caret = Len
              \Items()\Text\Len = Len(String.s)
              Len + \Items()\Text\Len
              
              _line_resize_(*This)
              
              \Items()\y = \Y[1]+\Text\Y+\Scroll\Height+Text_Y
              \Items()\Height = \Text\Height
              \Items()\Item = ListIndex(\Items())
              
              \Items()\Text\Editable = \Text\Editable 
              \Items()\Text\y = \Items()\y
              \Items()\Text\Width = StringWidth
              \Items()\Text\Height = \Text\Height
              \Items()\Text\String.s = String.s
              
              If \Line[1] = ListIndex(\Items())
                ;Debug " string "+String.s
                \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
                \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
              EndIf
              
              ; Указываем какие линии будут видни
              If \Type <> #PB_GadgetType_Editor
                \Items()\Hide = Bool( Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
              EndIf
              
              If \Scroll\Width<\Items()\Text\Width
                \Scroll\Width=\Items()\Text\Width
              EndIf
              
              \Scroll\Height+\Text\Height
            Next
          EndIf
          
          \Text\Count[1] = \Text\Count
        Else
          For IT = 1 To \Text\Count
            SelectElement(\Items(), IT-1)
            String.s = StringField(\Text\String.s[2], IT, #LF$)
            
            If \Items()\Text\String.s <> String.s Or \Items()\Text\Change
              \Items()\Text\String.s = String.s
              
              If \Type = #PB_GadgetType_Button
                StringWidth = TextWidth(RTrim(String.s))
              Else
                StringWidth = TextWidth(String.s)
              EndIf
              
              \Items()\Caret = Len
              \Items()\Text\Len = Len(String.s)
              Len + \Items()\Text\Len
              
              \Items()\Text\Width = StringWidth
              \Items()\Text\String.s = String.s
              
              If \Scroll\Width<\Items()\Text\Width
                \Scroll\Width=\Items()\Text\Width
              EndIf
            Else
              StringWidth = \Items()\Text\Width 
            EndIf
            
            ; Resize item
            If (Left And Not  Bool(\Scroll\X = Left)); Or \Resize
              _set_content_X_(*This)
            EndIf
            
            _line_resize_(*This)
          Next
        EndIf
      Else
        _set_content_Y_(*This)
        
        PushListPosition(\Items())
        ForEach \Items()
          StringWidth = \Items()\Text\Width 
          ;If Not (Right And Not  Bool(*This\Scroll\X = Right))
          _set_content_X_(*This)
          ;  EndIf
          
          _line_resize_(*This)
        Next
        PopListPosition(\Items())
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height, Drawing
    
    If Not *This\Hide
      
      With *This
        If Canvas=-1 
          Canvas = EventGadget()
        EndIf
        If Canvas <> \Canvas\Gadget
          ProcedureReturn
        EndIf
        
        Clip(*This, \X[2],\Y[2],\Width[2],\Height[2])
        
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore,\Color\Back,\Radius)
        
        ; Make output text
        If (\Text\String.s Or \Text\Change Or \Resize)
          If \Text\FontID 
            DrawingFont(\Text\FontID) 
          EndIf
          
          If \Text\Change
            \Text\Height = TextHeight("A") + 1
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          If (\Text\Change Or \Resize)
            MultiLine(*This)
          EndIf
          
          If \Text\Change
            \Text\Change = 0
          EndIf
          
          If \Resize
            \Resize = 0
          EndIf
        EndIf 
      EndWith 
      
      ; Draw items text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            
            If Not \Hide
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
              EndIf
              
              ; Draw string
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text\String.s
                Clip(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
                
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
                ;               
                If *This\Focus = *This 
                  Protected Left,Right
                  Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
                  Right = (\Width + Left)
                  
                  If *This\Scroll\X < Left
                    *This\Scroll\X = Left
                  ElseIf *This\Scroll\X > Right
                    *This\Scroll\X = Right
                  ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                    *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                    If *This\Scroll\X>0
                      *This\Scroll\X=0
                    EndIf
                  EndIf
                EndIf
                
                If *This\Color\Front[3] And \Text[2]\Len > 0 
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS ; Bug in Mac os 
                    If *This\Caret[1] > *This\Caret
                      \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                      
                      If \Text[3]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                      EndIf
                      
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*This\Scroll\X), \Text\Y, \Text[2]\Width+\Text[2]\Width[2], \Text\Height, *This\Color\Frame[3])
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawRotatedText((\Text\X+*This\Scroll\X), \Text\Y, \Text[1]\String.s+\Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[3])
                      EndIf
                      
                      If \Text[1]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawRotatedText((\Text\X+*This\Scroll\X), \Text\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                      EndIf
                    Else
                      ;                     \Text[2]\X = \Text\X+\Text[1]\Width
                      ;                     \Text[3]\X = \Text[2]\X+\Text[2]\Width
                      
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text\X+*This\Scroll\X), \Text\Y, \Text\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                      
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*This\Scroll\X), \Text\Y, (\Text[2]\Width+\Text[2]\Width[2]), \Text\Height, *This\Color\Frame[3])
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[3])
                      EndIf
                    EndIf
                    
                  CompilerElse
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height, *This\Color\Frame[3])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[3])
                    EndIf
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text[0]\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                    EndIf
                  CompilerEndIf
                Else
                  If \Text[2]\Len > 0
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height, *This\Color\Frame[3])
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *This\Text\Editable And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFFFF)
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        ;         Clip(*This, \X[1]-2,\Y[1]-2,\Width[1]+4,\Height[1]+4)
        Clip(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
        
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[3])
          If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[3]) : EndIf  ; Сглаживание краев )))
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[3])
        ElseIf \fSize
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame)
        EndIf
        
        If \Default
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[3])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[3]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[3])
          EndIf
        EndIf
        
      EndWith
    EndIf
    
  EndProcedure
  
  ;-
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
    Protected Result,i,Len, String.s
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Make(*This, Text.s)
        Debug text+" "+\Text\String.s
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If Not \Text\MultiLine
            \Text\String.s = RemoveString(\Text\String.s, #LF$) + #LF$
          EndIf
        EndIf
        
        \Text\Len = Len(\Text\String.s)
        \Text\Change = #True
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetFont(*This.Widget_S)
    ProcedureReturn *This\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    Protected Result
    
    If *This\Text\FontID <> FontID
      *This\Text\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
    Protected Result
    
    With *This
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
    EndWith
    
    ResetColor(*This)
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line[State]
        Case #PB_Gadget_BackColor  : Color = \Color\Back[State]
        Case #PB_Gadget_FrontColor : Color = \Color\Front[State]
        Case #PB_Gadget_FrameColor : Color = \Color\Frame[State]
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas = \Canvas\Gadget
        \Canvas\Window = EventWindow()
      Else
        ProcedureReturn
      EndIf
      
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
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
          Case #PB_EventType_Input 
            \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown
            \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
            \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \Canvas\Mouse\Buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                      (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                      (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
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
              Result | CallCFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              Result | CallFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            CompilerElse
              Result | CallCFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            CompilerEndIf
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Result | CallFunctionFast(*Function, *This, EventType, Canvas, CanvasModifiers)
    CompilerElse
      Result | CallCFunctionFast(*Function, *This, EventType, Canvas, CanvasModifiers)
    CompilerEndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        
        ; Set the default widget flag
        Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Widget_BorderLess
        
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
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine =- 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 1
          EndIf
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
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
          
          If \Text\Editable
            \Color[0]\Back[1] = $FFFFFFFF 
          Else
            \Color[0]\Back[1] = $FFF0F0F0  
          EndIf
          \Color[0]\Frame[1] = $FFBABABA
          
          \Color[0]\Front[1] = $FF000000
          ResetColor(*This)
          
          SetText(*This, Text.s)
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
; Folding = --6--j----0----0------------
; EnableXP