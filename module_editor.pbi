IncludePath "/Users/as/Documents/GitHub/Widget/"
; XIncludeFile "module_scroll.pbi"
; 
; ;
; ; Module name   : Editor
; ; Author        : mestnyi
; ; Last updated  : Aug 28, 2018
; ; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70650
; ; 
; 
; 
; EnableExplicit
; ;-
; DeclareModule Editor
;   EnableExplicit
CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_Text.pbi"
CompilerEndIf

DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
 
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare.s GetText(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare SetText(Gadget, Text.s, Item.i=0)
  Declare SetFont(Gadget, FontID.i)
  Declare AddItem(Gadget,Item,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare CallBack()
  Declare.i Draw(*This.Widget_S, Canvas.i=-1)
  
EndDeclareModule

Module Editor
  ; ;   UseModule Constant
  ;- PROCEDURE
  
  Procedure.i LenWrap (text$, width.i, length.i=-1)
    ; in : width : available width in pixels
    ;      text$ : This function does not require that the text is
    ;              actually shown in the gadget.
    ; out: maximum number of characters of text$ (counted from the left)
    ;      which fit into the available width
    If length =- 1 : length = Len(text$) : EndIf
    While (length > 0 And TextWidth(RTrim(Left(text$, length))) >= width) : length - 1 : Wend
    
    ProcedureReturn length  ; -1 on error
  EndProcedure
  
  Procedure.s LineWrap (line$, softWrapWidth.i, hardWrapWidth.i=-1, delimList$=" "+Chr(9), nl$=#LF$, indent$="")
    ; -- Word wrap in *one line* in a window (can have a variable-width font)
    ; in: line$  : line which is to be wrapped
    ;     indent$: "" or a string consisting of blanks, used for indenting lines of list items
    ;
    ;     For the meaning of the other parameters see function WordWrapW().
    Protected.i posn, found, i, softWrapPosn, hardWrapPosn, firstChar=Len(indent$)+1
    Protected ret$=""
    
    
    posn = Len(line$)
    softWrapPosn = LenWrap(line$, softWrapWidth, posn)
    
    If softWrapPosn < firstChar
      ProcedureReturn line$
    EndIf
    
    While posn > softWrapPosn
      ; search for rightmost delimiter <= softWrapPosn:
      For i = softWrapPosn To firstChar Step - 1
        found = FindString(delimList$, Mid(line$,i,1))
        If found
          posn = i
          Break
        EndIf
      Next
      
      If found = 0    ; if there is no delimiter <= softWrapPosn
        If hardWrapWidth < 0
          ; insert hard wrap at position of soft wrap:
          posn = softWrapPosn
        Else
          ; search for leftmost delimiter > softWrapPosn:
          For i = softWrapPosn+1 To posn
            found = FindString(delimList$, Mid(line$,i,1))
            If found
              posn = i
              Break
            EndIf
          Next
          If hardWrapWidth > 0
            hardWrapPosn = LenWrap(line$, hardWrapWidth)
            If hardWrapPosn < posn
              ; insert hard wrap at given position:
              posn = hardWrapPosn
            EndIf
          EndIf
        EndIf
      EndIf
      
      ret$ + Left(line$, posn) + nl$
      line$ = LTrim(Mid(line$, posn+1))
      
      If line$ <> ""
        line$ = indent$ + line$
      EndIf
      
      ;       Protected p = posn
      posn = Len(line$)
      ;       Debug " "+posn +" - "+ p
      
      softWrapPosn = LenWrap(line$, softWrapWidth, posn)
    Wend
    
    ProcedureReturn ret$ + line$
  EndProcedure
  
  Procedure.s WordWrap (text$, softWrapWidth.i, hardWrapWidth.i=-1, delimList$=" "+Chr(9), nl$=#LF$, liStart$="")
    ; ## Main function ##
    ; -- Word wrap in *one or more lines* in a window (can have a variable-width font)
    ; in : text$        : text which is to be wrapped;
    ;                     may contain #CRLF$ (Windows), or #LF$ (Linux and modern Mac systems) as line breaks
    ;      softWrapWidth: the desired maximum width (pixels) of each resulting line
    ;                     if a delimiter was found (not counting the length of the inserted nl$);
    ;                     if no delimiter was found at a position <= softWrapWidth, a line might
    ;                     still be longer if hardWrapWidth = 0 or > softWrapWidth
    ;      hardWrapWidth: guaranteed maximum width (pixels) of each resulting line
    ;                     (not counting the length of the inserted nl$);
    ;                     if hardWrapWidth <> 0, each line will be wrapped at the latest at
    ;                     hardWrapWidth, even if it doesn't contain a delimiter;
    ;                     default setting: hardWrapWidth = softWrapWidth
    ;      delimList$   : list of characters which are used as delimiters;
    ;                     any delimiter in line$ denotes a position where a soft wrap is allowed
    ;      nl$          : string to be used as line break (normally #CRLF$ or #LF$)
    ;      liStart$     : string at the beginning of each list item
    ;                     (providing this information makes proper indentation possible)
    ;
    ; out: return value : text$ with given nl$ inserted at appropriate positions
    ;
    ; <http://www.purebasic.fr/english/viewtopic.php?f=12&t=53800>
    Protected.i numLines, i, indentPixels, indentLen=-1
    Protected line$, indent$, ret$=""
    
    text$ = ReplaceString(text$, #LFCR$, #LF$)
    text$ = ReplaceString(text$, #CRLF$, #LF$)
    text$ = ReplaceString(text$, #CR$, #LF$)
    text$ + #LF$
    
    numLines = CountString(text$, #LF$)
    
    For i = 1 To numLines
      line$ = StringField(text$, i, #LF$)
      
      If FindString(line$, liStart$) = 1
        If indentLen = -1
          indentPixels = TextWidth(liStart$)
          indentLen = LenWrap(Space(Len(text$)), indentPixels)
        EndIf
        indent$ = Space(indentLen)
      Else
        indent$ = ""
      EndIf
      
      ret$ + LineWrap(line$, softWrapWidth, hardWrapWidth, delimList$, nl$, indent$) + nl$
    Next
    
    ;ProcedureReturn ReplaceString(ret$, " ", "*")
    ProcedureReturn ret$
  EndProcedure
  
  Procedure MakeSelectionText(*This.Widget_S)
    Protected Caret
    
    With *This\Items()
      ; Если выделяем с право на лево
      If \Text\Caret[1] > \Text\Caret 
        Caret = \Text\Caret
        \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
      Else 
        Caret = \Text\Caret[1]
        \Text[2]\Len = \Text\Caret-\Text\Caret[1]
      EndIf
      
      \Text[1]\String.s = Left(\Text\String.s, Caret)
      
      If \Text[2]\Len
        \Text[2]\String.s = Mid(\Text\String.s, 1 + Caret, \Text[2]\Len)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Caret + \Text[2]\Len))
      Else
        \Text[2]\String.s = ""
      EndIf
      
      *This\Text\Caret = FindString(*This\Text\String.s[1], \Text\String.s) - 1
    EndWith
    
    ProcedureReturn Caret
  EndProcedure
  
  Procedure MakeDrawText(*This.Widget_S, item=-1)
    Protected IT,Text_Y,Text_X, String.s, String1.s, StringWidth, CountString, Width, Height, adress.i, caret_pos, caret_pos_1 =- 1
    
    With *This
      Width = \Width[2]
      Height = \Height[2]
      
      If \Text\MultiLine
        String.s = WordWrap(\Text\String.s, \Width[1]-\Text\X*2, - 1)
        CountString = CountString(String, #LF$)
      ElseIf \Text\WordWrap
        String.s = WordWrap(\Text\String.s, \Width[1]-\Text\X*2)
        CountString = CountString(String, #LF$)
      Else
        String.s = \Text\String.s
        CountString = 1
      EndIf
      
      If CountString
        \Text\String.s[1] = String.s
        *This\Text\Len = Len(String.s)
        
        If ListSize(*This\Items())
          caret_pos = \Items()\Text\Caret
          caret_pos_1 = \Items()\Text\Caret[1]
        EndIf
        ClearList(\Items())
        
        If Bool((\Text\Align & #PB_Text_Bottom) = #PB_Text_Bottom) 
          Text_Y=(Height-(\Text\Height * CountString)-\Text\Y) 
        ElseIf Bool((\Text\Align & #PB_Text_Middle) = #PB_Text_Middle) 
          Text_Y=((Height-(\Text\Height * CountString))/2) 
        EndIf
        
        For IT = 1 To CountString
          If \Text\Y+Text_Y < \Y[2] : Text_Y+\Text\Height : Continue : EndIf
          
          String1 = StringField(String, IT, #LF$)
          StringWidth = TextWidth(String1)
          
          If Bool((\Text\Align & #PB_Text_Right) = #PB_Text_Right) 
            Text_X=(Width-StringWidth-\Text\X) 
          ElseIf Bool((\Text\Align & #PB_Text_Center) = #PB_Text_Center) 
            Text_X=(Width-StringWidth)/2 
          EndIf
          
          If Text_X<\Text\X : Text_X=\Text\X : EndIf
          
          ;
          AddElement(\Items())
          \Items()\Text\Caret[1] =- 1
          \Items()\Text\x = Text_X
          \Items()\Text\y = \Text\Y+Text_Y
          \Items()\Text\Width = StringWidth
          \Items()\Text\Height = \Text\Height
          \Items()\Text\String.s = String1.s
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          
          If ListIndex(*This\Items()) = item
            adress = @*This\Items()
            \Items()\Text\Caret = caret_pos
            \Items()\Text\Caret[1] = caret_pos_1
            ;;Debug \Items()\Text\Caret
            ;            Debug "caret_pos "+caret_pos
            ;          Debug \Items()\Text\Caret[1]
            ;         Debug \Items()\Text\String.s
          EndIf
          
          Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
        Next
      EndIf
      
      If adress
        ChangeCurrentElement(*This\Items(), adress)
        
        MakeSelectionText(*This)
        
        ;         Debug \Items()\Text\Caret
        ;         Debug \Items()\Text\Caret[1]
        ;; Debug \Items()\Text\String.s
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line = 0)
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
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            For i = 0 To Len
              CursorX = X+TextWidth(Left(String.s, i))
              Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
              
              ; Получаем позицию коpректора
              If MinDistance > Distance 
                MinDistance = Distance
                Position = i
              EndIf
            Next
            
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
    ;ProcedureReturn
    
    With *This\Items()
      Debug *This\Text\Line
      ;*This\Text\Caret = 0
      If *This\Text\Caret > *This\Text\Caret[1] : *This\Text\Caret = *This\Text\Caret[1] : EndIf
      ; Debug "  "+*This\Text\Caret +" "+ *This\Text\Caret[1]
      ;\Text\String.s = RemoveString(\Text\String.s, Trim(\Text[2]\String.s, #LF$), #PB_String_CaseSensitive, 0, 1) ; *This\Text\Caret
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Text\Caret
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Text\Caret
      \Text[2]\String.s[1] = \Text[2]\String.s
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      If (Caret <> *This\Text\Caret Or Line <> *This\Text\Line)
        \Text[2]\String.s = ""
        
        ; Если выделяем снизу вверх
        PushListPosition(*This\Items())
        If (*This\Text\Line[1] > *This\Text\Line)
          If PreviousElement(*This\Items()) And \Text[2]\Len : \Text[2]\Len = 0 : EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len : \Text[2]\Len = 0 : EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Text\Line[1] = *This\Text\Line
          ; Если выделяем с право на лево
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
        ElseIf *This\Text\Line[1] > *This\Text\Line
          ; <<<<<|
          Position = *This\Text\Caret
          \Text[2]\Len = \Text\Len-Position
        Else
          ; >>>>>|
          Position = 0
          \Text[2]\Len = *This\Text\Caret
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Change = #True
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Change = #True
        EndIf
        
        Line = *This\Text\Line
        Caret = *This\Text\Caret
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget_S) ; Ok
    With *This\Items()
      Protected i, char = Asc(Mid(\Text\String.s, *This\Text\Caret + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        *This\Text\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = *This\Text\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *This\Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = *This\Text\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *This\Text\Caret = i - 1
        \Text[2]\Len = *This\Text\Caret[1] - *This\Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure Cut(*This.Widget_S)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
    
    With *This\Items()
      If ListSize(*This\Items()) 
        ;If \Text[2]\Len
        If *This\Text\Line[1] = *This\Text\Line
          Debug "Cut Black"
          If \Text[2]\Len
            RemoveText(*This)
          Else
            \Text[2]\String.s[1] = Mid(\Text\String.s, *This\Text\Caret, 1)
            \Text\String.s = Left(\Text\String.s, *This\Text\Caret - 1) + Right(\Text\String.s, \Text\Len-*This\Text\Caret)
            \Text\String.s[1] = Left(\Text\String.s[1], *This\Text\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-*This\Text\Caret)
            *This\Text\Caret - 1 
          EndIf
        Else
          Debug " Cut " +*This\Text\Caret +" "+ *This\Text\Caret[1]+" "+\Text[2]\Len
          
          If \Text[2]\Len
            ;If *This\Text\Line > *This\Text\Line[1] 
            RemoveText(*This)
            ;EndIf
            
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\Text\Line)
            EndIf
          EndIf
          
          ; Выделили сверх вниз
          If *This\Text\Line > *This\Text\Line[1] 
            Debug "  Cut_1_ForEach"
            
            PushListPosition(*This\Items())
            ForEach *This\Items() 
              If \Text[2]\Len
                If \Text[2]\Len = \Text\Len
                  DeleteElement(*This\Items(), 1) 
                Else
                  RemoveText(*This)
                EndIf
              EndIf
            Next
            PopListPosition(*This\Items())
            
            *This\Text\Caret = *This\Text\Caret[1]
            ; Выделили снизу верх 
          ElseIf *This\Text\Line[1] > *This\Text\Line 
            *This\Text\Line[1] = *This\Text\Line 
            
            *This\Text\Caret[1] = *This\Text\Caret  ; Выделили пос = 0 фикс = 1
            
            ;             Debug "  Cut_21_ForEach"
            ;               
            ;             PushListPosition(*This\Items())
            ;             ForEach *This\Items() 
            ;               If \Text[2]\Len
            ;                 If \Text[2]\Len = \Text\Len
            ;                   DeleteElement(*This\Items(), 1) 
            ;                 Else
            ;                   RemoveText(*This)
            ;                 EndIf
            ;               EndIf
            ;             Next
            ;             PopListPosition(*This\Items())
            
          EndIf
          
          
          If *This\Text\Line[1]>=0 And *This\Text\Line[1]<ListSize(*This\Items())
            ;If *This\Text\Line > *This\Text\Line[1]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\Text\Line[1])
            
            If Not *This\Text\Caret
              *This\Text\Caret = \Text\Len-Len(#LF$)
            EndIf
            
            ; Выделили сверху вниз
            If *This\Text\Line > *This\Text\Line[1]
              *This\Text\Line = *This\Text\Line[1]
              *This\Text\Caret = *This\Text\Caret[1] ; Выделили пос = 0 фикс = 0
              \Text\String.s = String.s + \Text\String.s 
            Else
              ;;*This\Text\Caret[1] = *This\Text\Caret  ; Выделили пос = 0 фикс = 1
              \Text\String.s = \Text\String.s + String.s 
            EndIf
            
            \Text\Len = Len(\Text\String.s)
          EndIf
          
          PushListPosition(*This\Items())
          ForEach *This\Items()
            If \Text[2]\Len 
              Debug "  Cut_2_ForEach"
              If \Text[2]\Len = \Text\Len
                DeleteElement(*This\Items(), 1) 
              Else
                RemoveText(*This)
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items())
          
        EndIf
        ;EndIf  
      EndIf
    EndWith
  EndProcedure
  
  Procedure.s Copy(*This.Widget_S)
    Protected String.s
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Text[2]\Len 
          String.s+\Items()\Text[2]\String.s+#LF$
        EndIf
      Next
      PopListPosition(\Items())
      
      String.s = Trim(String.s, #LF$)
      ; Для совместимости с виндовсовским 
      If String.s And Not *This\Text\Caret
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.b Back(*This.Widget_S)
    Protected Repaint.b, String.s
    
    With *This\Items()
      If ListSize(*This\Items()) And (*This\Text\Caret = 0 And *This\Text\Caret = *This\Text\Caret[1]) And ListIndex(*This\Items())  
        Debug "Back"
        
        If Not \Text[2]\Len
          If *This\Text\Line[1] > *This\Text\Line : *This\Text\Line[1] = *This\Text\Line : Else : *This\Text\Line[1] - 1 : EndIf
          If (*This\Text\Line[1]>=0 And *This\Text\Line[1]<ListSize(*This\Items()))
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            SelectElement(*This\Items(), *This\Text\Line[1])
            
            If *This\Text\Caret = *This\Text\Caret[1]
              *This\Text\Caret = \Text\Len-Len(#LF$)
            EndIf
            If *This\Text\Line > *This\Text\Line[1]
              *This\Text\Caret[1] = *This\Text\Caret
            EndIf
            
            \Text\String.s + String.s 
            \Text\Len = Len(\Text\String.s)
          EndIf
        EndIf
        
        ForEach *This\Items() 
          If \Text[2]\Len
            If \Text[2]\Len = \Text\Len
              DeleteElement(*This\Items(), 1) 
            Else
              RemoveText(*This)
            EndIf
          EndIf
        Next
        
        SelectElement(*This\Items(), *This\Text\Line[1])
        
        *This\Text\Line = *This\Text\Line[1]
        Repaint = #True
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure EditableCallBack(*This.Widget_S, EventType.i)
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint.b, String.s, StartDrawing, Update_Text_Selected
    
    
    If *This
      With *This\Items()
        If Not *This\Disable
          ; Protected adress.i, lastItem.i, Item = (*This\Canvas\Mouse\Y-*This\Scroll\Y)/*This\Text\Height
          If *This\Canvas\Mouse\Buttons 
            Protected Item.i = (((*This\Canvas\Mouse\Y-*This\Text\Y)-*This\Scroll\Y) / *This\Text\Height)
          EndIf
          
          Select EventType 
            Case #PB_EventType_LeftButtonDown
              ; С начало сбрасываем все виделения.
              PushListPosition(*This\Items())
              ForEach *This\Items() 
                If \Text[2]\Len <> 0
                  \Text[2]\Len = 0 
                EndIf
              Next
              PopListPosition(*This\Items())
              
              *This\Text\Caret = Caret(*This, Item) 
              *This\Text\Line = ListIndex(*This\Items()) 
              *This\Text\Line[1] = Item
              
            Case #PB_EventType_MouseMove  
              If *This\Canvas\Mouse\Buttons
                If *This\Text\Line <> Item And Item =< ListSize(*This\Items())
                  ; Leaved text line
                  If isItem(*This\Text\Line, *This\Items()) 
                    If *This\Text\Line <> ListIndex(*This\Items())
                      SelectElement(*This\Items(), *This\Text\Line) 
                    EndIf
                    
                    If *This\Text\Line > Item
                      *This\Text\Caret = 0
                    Else
                      *This\Text\Caret = \Text\Len
                    EndIf
                    
                    SelectionText(*This)
                  EndIf
                  
                  *This\Text\Line = Item
                EndIf
                
                *This\Text\Caret = Caret(*This, Item) 
                SelectionText(*This)
              EndIf
              
            Default
              itemSelect(*This\Text\Line[1], *This\Items())
          EndSelect
          
          
          
          
          
          Select EventType
            Case #PB_EventType_MouseEnter
              SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
              
            Case #PB_EventType_LostFocus : Repaint = #True
              If Not Bool(*This\Type = #PB_GadgetType_Editor)
                ; StringGadget
                \Text[2]\Len = 0 ; Убыраем выделение
              EndIf
              *This\Text\Caret[1] =- 1 ; Прячем коректор
              
            Case #PB_EventType_Focus : Repaint = #True
              *This\Text\Caret[1] = *This\Text\Caret ; Показываем коректор
              
            Case #PB_EventType_LeftDoubleClick 
              DoubleClickCaret = *This\Text\Caret
              SelectionLimits(*This)
              SelectionText(*This) 
              Repaint = #True
              
            Case #PB_EventType_LeftButtonDown
              *This\Text\Caret[1] = *This\Text\Caret
              
              If \Text\Numeric 
                \Text\String.s[1] = \Text\String.s 
              EndIf
              
              If *This\Text\Caret = DoubleClickCaret
                DoubleClickCaret =- 1
                *This\Text\Caret[1] = \Text\Len
                *This\Text\Caret = 0
              EndIf 
              
              SelectionText(*This)
              Repaint = #True
              
            Case #PB_EventType_MouseMove
              If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                ;                 *This\Text\Caret = Caret(*This)
                ;                 SelectionText(*This)
                Repaint = #True
              EndIf
              
            Case #PB_EventType_Input
              If *This\Text\Editable
                Protected Input, Input_2
                
                Select #True
                  Case \Text\Lower : Input = Asc(LCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case \Text\Upper : Input = Asc(UCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case \Text\Pass  : Input = 9679 : Input_2 = *This\Canvas\Input ; "●"
                  Case \Text\Numeric
                    ;                     Debug *This\Canvas\Input
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
                    If \Text[2]\String.s
                      RemoveText(*This)
                    EndIf
                    *This\Text\Caret + 1
                    *This\Text\Caret[1] = *This\Text\Caret
                  EndIf
                  
                  If \Text\Numeric And Input = Input_2
                    \Text\String.s[1] = \Text\String.s
                  EndIf
                  
                  ;\Text\String.s = Left(\Text\String.s, *This\Text\Caret-1) + Chr(Input) + Mid(\Text\String.s, *This\Text\Caret)
                  \Text\String.s = InsertString(\Text\String.s, Chr(Input), *This\Text\Caret)
                  \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), *This\Text\Caret)
                  
                  If Input
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
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = 0 : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = \Text\Len : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                  
                Case #PB_Shortcut_Left : \Text[2]\String.s = ""
                  If *This\Text\Caret > 0 Or ListIndex(*This\Items()) : *This\Text\Caret - 1 
                    
                    ; Если дошли до начала строки то переходим в конец предыдущего итема
                    If *This\Text\Caret =- 1 And *This\Text\Line[1] : *This\Text\Line[1]-1
                      SelectElement(*This\Items(), *This\Text\Line[1])
                      *This\Text\Caret = \Text\Len-Len(#LF$)
                    EndIf
                    
                    If *This\Text\Caret[1] <> *This\Text\Caret
                      If \Text[2]\Len 
                        If *This\Text\Caret > *This\Text\Caret[1] 
                          *This\Text\Caret = *This\Text\Caret[1] 
                          *This\Text\Caret[1] = *This\Text\Caret 
                        Else
                          *This\Text\Caret[1] = *This\Text\Caret + 1 
                          *This\Text\Caret = *This\Text\Caret[1] 
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\Text\Caret[1] = *This\Text\Caret 
                      EndIf
                    EndIf
                    
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Right : \Text[2]\String.s = ""
                  If *This\Text\Caret[1] < \Text\Len : *This\Text\Caret[1] + 1 
                    
                    ; Если дошли в конец строки то переходим на начало следующего итема
                    If *This\Text\Caret[1] = \Text\Len And *This\Text\Line[1] < ListSize(*This\Items()) - 1 : *This\Text\Line[1] + 1
                      SelectElement(*This\Items(), *This\Text\Line[1]) : *This\Text\Caret[1] = 0
                    EndIf
                    
                    If *This\Text\Caret <> *This\Text\Caret[1]
                      If \Text[2]\Len 
                        If *This\Text\Caret > *This\Text\Caret[1] 
                          *This\Text\Caret = *This\Text\Caret[1]+\Text[2]\Len - 1 
                          *This\Text\Caret[1] = *This\Text\Caret
                        Else
                          *This\Text\Caret = *This\Text\Caret[1] - 1
                          *This\Text\Caret[1] = *This\Text\Caret
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\Text\Caret = *This\Text\Caret[1] 
                      EndIf
                    EndIf
                    
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Up : \Text[2]\String.s = ""
                  If *This\Text\Line[1] : *This\Text\Line[1]-1
                    SelectElement(*This\Items(), *This\Text\Line[1])
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Down : \Text[2]\String.s = ""
                  If *This\Text\Line[1] < ListSize(*This\Items()) - 1 : *This\Text\Line[1] + 1
                    SelectElement(*This\Items(), *This\Text\Line[1]) 
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Return
                  Debug "Return "+ListIndex(*This\Items())
                  If *This\Text\Caret ;: *This\Text\Line[1]+1
                    *This\Text\Caret[1] = \Text\Len
                    SelectionText(*This) 
                    String.s = \Text[2]\String.s
                  EndIf
                  
                  If String.s
                    RemoveText(*This) 
                  Else
                    String.s = ""
                  EndIf
                  Debug String
                  
                  *This\Text\Line[1] = AddItem(*This\Canvas\Gadget, *This\Text\Line[1]+1, String.s+#LF$)
                  *This\Text\Caret = 0
                  *This\Text\Len = Len(\Text\String.s)
                  *This\Text\Caret[1] = *This\Text\Caret
                  
                  ;                   If Not *This\Text\Caret
                  ;                     SelectElement(*This\Items(), *This\Text\Line[1])
                  ;                   ; *This\Text\Line[1] + 1  
                  ;                   EndIf
                  
                  Scroll::SetState(*This\vScroll, *This\vScroll\Max)
                  Repaint = #True
                  
                Case #PB_Shortcut_Back 
                  Repaint = Back(*This)
                  If Not Repaint
                    Cut(*This)
                    
                    *This\Text\Caret[1] = *This\Text\Caret
                    \Text\Len = Len(\Text\String.s)
                    
                    Repaint = #True
                  EndIf
                  
                Case #PB_Shortcut_Delete 
                  If *This\Text\Caret < \Text\Len
                    If \Text[2]\String.s
                      RemoveText(*This)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, (*This\Text\Caret+1), 1)
                      \Text\String.s = Left(\Text\String.s, *This\Text\Caret) + Right(\Text\String.s, \Text\Len-(*This\Text\Caret+1))
                      \Text\String.s[1] = Left(\Text\String.s[1], *This\Text\Caret) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(*This\Text\Caret+1))
                    EndIf
                    
                    If ListSize(*This\Items())
                      PushListPosition(*This\Items())
                      ForEach *This\Items() 
                        If \Text[2]\Len = \Text\Len
                          DeleteElement(*This\Items(), 1)
                        EndIf
                      Next
                      PopListPosition(*This\Items())
                      
                      If *This\Text\Caret = Len(\Text\String.s) : *This\Text\Line[1]+1
                        If *This\Text\Line[1]>=0 And *This\Text\Line[1]<ListSize(*This\Items())
                          PushListPosition(*This\Items())
                          SelectElement(*This\Items(), *This\Text\Line[1])
                          String.s = \Text\String.s
                          DeleteElement(*This\Items(), 1)
                          PopListPosition(*This\Items())
                          \Text\String.s + String.s 
                          *This\Text\Line[1] - 1
                        EndIf
                      EndIf
                    EndIf
                    
                    *This\Text\Caret[1] = *This\Text\Caret
                    \Text\Len = Len(\Text\String.s)
                    
                    Repaint = #True
                  EndIf
                  
                  
                Case #PB_Shortcut_X
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                    
                    Cut(*This)
                    
                    *This\Text\Caret[1] = *This\Text\Caret
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_C ; Ok
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                  EndIf
                  
                Case #PB_Shortcut_V
                  If *This\Text\Editable And ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command))
                    Protected Caret, ClipboardText.s = Trim(GetClipboardText(), #CR$)
                    
                    If ClipboardText.s
                      If \Text[2]\Len
                        RemoveText(*This)
                        
                        If \Text[2]\Len = \Text\Len
                          ;*This\Text\Line[1] = *This\Text\Line
                          ClipboardText.s = Trim(ClipboardText.s, #LF$)
                        EndIf
                        ;                         
                        PushListPosition(*This\Items())
                        ForEach *This\Items()
                          If \Text[2]\Len 
                            If \Text[2]\Len = \Text\Len
                              DeleteElement(*This\Items(), 1) 
                            Else
                              RemoveText(*This)
                            EndIf
                          EndIf
                        Next
                        PopListPosition(*This\Items())
                      EndIf
                      
                      Select #True
                        Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                        Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                        Case \Text\Numeric 
                          If Val(ClipboardText.s)
                            ClipboardText.s = Str(Val(ClipboardText.s))
                          EndIf
                      EndSelect
                      
                      \Text\String.s = InsertString( \Text\String.s, ClipboardText.s, *This\Text\Caret + 1)
                      
                      If CountString(\Text\String.s, #LF$)
                        Caret = \Text\Len-*This\Text\Caret
                        String.s = \Text\String.s
                        DeleteElement(*This\Items(), 1)
                        SetText(*This\Canvas\Gadget, String.s, *This\Text\Line[1])
                        *This\Text\Caret = Len(\Text\String.s)-Caret
                        ;                         SelectElement(*This\Items(), *This\Text\Line)
                        ;                        *This\Text\Caret = 0
                      Else
                        *This\Text\Caret + Len(ClipboardText.s)
                      EndIf
                      
                      *This\Text\Caret[1] = *This\Text\Caret
                      \Text\Len = Len(\Text\String.s)
                      
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
          EndSelect
          
        EndIf
        
        If Repaint
          ; *This\Text\CaretLength = \CaretLength
          *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
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
        If \Text\String.s
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
            
            If Bool(\Text\MultiLine Or \Text\WordWrap)
              \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, Bool(\Text\WordWrap)-Bool(\Text\MultiLine))
              \Text\CountString = CountString(\Text\String.s[2], #LF$)
            Else
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
            If \Text\String.s
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
              EndIf
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text[0]\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(Left(\Text\String.s, *This\Text\Caret))
              EndIf 
              
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
                ClipOutput(*This\X[2]+*This\Text[0]\X-1,*This\Y[2],*This\Width[2]-*This\Text[0]\X*2+2,*This\Height[2]) ; Bug in Mac os
              CompilerEndIf
              
              If *This\Focus = *This 
                Protected Left,Right
                Left =- \Text[3]\Width 
                Right = (*This\Width[2]-*This\Text\X-1)-\Text[3]\Width
                
                If *This\Scroll\X < Left
                  *This\Scroll\X = Left
                ElseIf *This\Scroll\X > Right
                  *This\Scroll\X = Right
                EndIf
                
                ;                 If \Text[2]\String.s[1] And *This\Scroll\X < 0
                ;                   *This\Scroll\X + TextWidth(\Text[2]\String.s[1]) 
                ;                   \Text[2]\String.s[1] = ""
                ;                 EndIf
              EndIf
              
              If \Text[2]\Len And #PB_Compiler_OS <> #PB_OS_MacOS
                If \Text[1]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
                If \Text[2]\String.s
                  DrawingMode(#PB_2DDrawing_Default)
                  ;                   If \Text[0]\String.s = \Text[1]\String.s+\Text[2]\String.s
                  ;                     Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y,*This\width[2]-\Text[2]\X, \Text[0]\Height, $DE9541)
                  ;                   Else
                  Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $DE9541)
                  ;                   EndIf
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
                  Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $FADBB3);$DE9541)
                EndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
              EndIf
            EndIf
            
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *This\Text\Editable And *This\Text\Caret = *This\Text\Caret[1] And *This\Text\Line = *This\Text\Line[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text[0]\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
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
  
  Procedure ReDraw(*This.Widget_S, Canvas =- 1)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This, Canvas)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure CallBack()
    Static LastX, LastY
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
      \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
      \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      Protected iHeight = \Height-Scroll::Height(*This\hScroll)
      Protected iWidth = \Width-Scroll::Width(*This\vScroll)
      
      Select EventType()
          ;         Case #PB_EventType_MouseEnter
          ;           \vScroll\hide = \vScroll\hide[1]
          ;           \hScroll\hide = \hScroll\hide[1]
          ;           ReDraw(*This)
          ;           
          ;         Case #PB_EventType_MouseLeave
          ;           If Not Bool(\vScroll\buttons Or \hScroll\buttons)
          ;             \vScroll\hide = 1
          ;             \hScroll\hide = 1
          ;           EndIf
          ;           ReDraw(*This)
          
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Resize = 1
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
          
          ; Inner coordinae
          \X[2]=\bSize
          \Y[2]=\bSize
          \Width[2] = \Width-\bSize*2
          \Height[2] = \Height-\bSize*2
          
          ; Frame coordinae
          \X[1]=\X[2]-\fSize
          \Y[1]=\Y[2]-\fSize
          \Width[1] = \Width[2]+\fSize*2
          \Height[1] = \Height[2]+\fSize*2
          
          Scroll::Resizes(*This\vScroll, *This\hScroll, *This\x[2]+1,*This\Y[2]+1,*This\Width[2]-2,*This\Height[2]-2)
          ReDraw(*This)
          
      EndSelect
      
      Repaint = Scroll::CallBack(*This\vScroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y,0, -1)
      If Repaint 
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
      
      Repaint = Scroll::CallBack(*This\hScroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y,0, -1)
      If Repaint 
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
      
      ;Debug *This\hScroll\Buttons
      
      If Not *This\vScroll\Buttons And Not *This\hScroll\Buttons
        ;Or (\Canvas\Mouse\X<*This\Width[2]-Scroll::Width(*This\vScroll) And \Canvas\Mouse\Y<*This\Height[2]-Scroll::Height(*This\hScroll))
        Repaint = EditableCallBack(*This, EventType())
        If Repaint
          ReDraw(*This)
        EndIf
      EndIf
      
    EndWith
    
    ; Draw(*This)
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\PageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected ScrollPos, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected ScrollPos, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure AddItem(Gadget, Item,Text.s,Image.i=-1,Flag.i=0)
    Protected String.s, i, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This\Items()
      *This\Text\CountString = CountString(*This\Text\String.s, #LF$)
      
      For i=0 To *This\Text\CountString
        If Item = i
          If String.s
            String.s  +#LF$+ Text
          Else
            String.s  + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(*This\Text\String.s, i + 1, #LF$)
        Else
          String.s + StringField(*This\Text\String.s, i + 1, #LF$)
        EndIf
      Next
      
      *This\Text\String.s = String.s 
      *This\Text\Len = Len(String.s)
       *This\Text\Change = 1
    EndWith
    
        If *This\Scroll\Height<*This\Height
          ReDraw(*This, *This\Canvas\Gadget)
        EndIf
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure SetText(Gadget, Text.s, Item.i=0)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    If *This
      With *This\Items()
        If *This\Text\String.s <> Text.s
          ;           If *This\Text\String.s
          ;             *This\Text\String.s +#LF$+ Text.s
          ;           Else
          ;             *This\Text\String.s = Text.s
          ;           EndIf
          *This\Text\String.s = Text.s
          *This\Text\Len = Len(Text.s)
          *This\Text\Change = 1
          ReDraw(*This)
        EndIf
        
        ;         Protected i,c = CountString(Text.s, #LF$)
        ;         
        ;         For i=0 To c
        ;           Debug "String len - "+Len(StringField(Text.s, i + 1, #LF$))
        ;           AddItem( Gadget, Item+i, StringField(Text.s, i + 1, #LF$))
        ;         Next
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure SetFont(Gadget.i, FontID.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Resize = 1
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        *This\Text\Caret[1] =- 1
        
        ; Set the default widget flag
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
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
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
            \Text\y = \fSize+5
          Else
            \Text\X = \fSize+5
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
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Min.i, Max.i, PageLength.i
    
    With *This
      If *This
        Widget(*This, Gadget, X, Y, Width, Height, "", Flag)
        
        Scroll::Widget(*This\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        Scroll::Widget(*This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        
        SetGadgetData(Gadget, *This)
        ReDraw(*This)
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  If OpenWindow(0, 0, 0, 422, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    For a = 0 To 5
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #PB_Text_WordWrap) : Editor::SetText(g, Text.s) 
    For a = 0 To 5
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::SetFont(g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 276, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---------------------------------------
; EnableXP