; IncludePath "/Users/as/Downloads/"
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

; ;   EnumerationBinary
; ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
; ;       #PB_Text_Right
; ;       #PB_Text_Center
; ;       #PB_Text_Border
; ;     CompilerElse ; If #PB_Compiler_OS = #PB_OS_Windows
; ;       #PB_Text_Center
; ;       #PB_Text_Right
; ;     CompilerEndIf
; ;     
; ;     #PB_Text_Bottom
; ;     
; ;     #PB_Text_UpperCase
; ;     #PB_Text_LowerCase
; ;     #PB_Text_Password
; ;     
; ;     #PB_Text_Middle 
; ;     #PB_Text_MultiLine 
; ;   EndEnumeration
; ;   
; ;   #PB_Text_ReadOnly = 256  ; #PB_String_ReadOnly
; ;   #PB_Text_Numeric = 512   ; #PB_String_Numeric
; ;   #PB_Text_WordWrap = 1024 ; #PB_Editor_WordWrap
; ;   
; ;   ;     Debug #PB_Text_Center
; ;   ;     Debug #PB_Text_Right
; ;   ;     Debug #PB_Text_Bottom
; ;   ;     
; ;   ;     Debug #PB_Text_UpperCase
; ;   ;     Debug #PB_Text_LowerCase
; ;   ;     Debug #PB_Text_Password
; ;   ;     
; ;   ;     Debug #PB_Text_Middle 
; ;   ;     Debug #PB_Text_MultiLine 
; ;   ;     
; ;   ;     Debug #PB_Text_ReadOnly
; ;   ;     Debug #PB_Text_Numeric 
; ;   ;     Debug #PB_Text_WordWrap
; ;   ;     Debug #PB_Text_Border
; ;   
  
; ;   ;- STRUCTURE
; ;   Structure Coordinate
; ;     y.i[3]
; ;     x.i[3]
; ;     Height.i[3]
; ;     Width.i[3]
; ;   EndStructure
; ;   
; ;   Structure Mouse
; ;     X.i
; ;     Y.i
; ;     Buttons.i
; ;   EndStructure
; ;   
; ;   Structure Canvas
; ;     Mouse.Mouse
; ;     Gadget.i
; ;     Window.i
; ;     
; ;     Input.c
; ;     Key.i[2]
; ;     
; ;   EndStructure
; ;   
; ;   Structure Text Extends Coordinate
; ;     ;     Char.c
; ;     Len.i
; ;     String.s[2]
; ;     Change.b
; ;     
; ;     Align.l
; ;     XAlign.b
; ;     YAlign.b
; ;     
; ;     Lower.b
; ;     Upper.b
; ;     Pass.b
; ;     Editable.b
; ;     Numeric.b
; ;     WordWrap.b
; ;     MultiLine.b
; ;     
; ;     Mode.i
; ;     
; ;     CaretPos.l[2] ; 0 = Pos ; 1 = PosFixed
; ;     
; ;   EndStructure
; ;   
; ;   Structure Struct Extends Coordinate
; ;     FontID.i
; ;     Canvas.Canvas
; ;     Colors.i[3]
; ;     
; ;     LinePos.i[2] ; 0 = Pos ; 1 = PosFixed
; ;     CaretPos.i[2] ; 0 = Pos ; 1 = PosFixed
; ;     CaretLength.i
; ;     
; ;     Text.Text[4]
; ;     ImageID.i[3]
; ;     
; ;     Image.Coordinate
; ;     
; ;     fSize.i
; ;     bSize.i
; ;     Hide.b[2]
; ;     Disable.b[2]
; ;     
; ;     Scroll.Coordinate
; ;     vScroll.Scroll::Struct
; ;     hScroll.Scroll::Struct
; ;     
; ;     Type.i
; ;     InnerCoordinate.Coordinate
; ;     
; ;     Repaint.i
; ;     Resize.b
; ;     
; ;     List Items.Widget()
; ;     List Columns.Widget()
; ;   EndStructure
; ;   
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare.s GetText(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare SetText(Gadget, Text.s, Item.i=0)
  Declare SetFont(Gadget, FontID.i)
  Declare AddItem(Gadget,Item,Text.s,Image.i=-1,Flag.i=0)
  Declare Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
  
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
  
  Procedure MakeSelectionText(*This.Widget)
    Protected CaretPos
    
    With *This\Items()
      ; Если выделяем с право на лево
      If \Text\Caret[1] > \Text\Caret 
        CaretPos = \Text\Caret
        \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
      Else 
        CaretPos = \Text\Caret[1]
        \Text[2]\Len = \Text\Caret-\Text\Caret[1]
      EndIf
      
      \Text[1]\String.s = Left(\Text\String.s, CaretPos)
      
      If \Text[2]\Len
        \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
      Else
        \Text[2]\String.s = ""
      EndIf
      
      *This\Text\Caret = FindString(*This\Text\String.s[1], \Text\String.s) - 1
    EndWith
    
    ProcedureReturn CaretPos
  EndProcedure
  
  Procedure MakeDrawText(*This.Widget, item=-1)
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
  
  Procedure CaretPos(*This.Widget)
    Protected Result.i =- 1, i.i, Len.i, Text_X.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If ListSize(\Items())
        String.s = \Items()\Text\String.s
        Text_X = \Items()\Text\x
        Len = \Items()\Text\Len
      Else
        String.s = \Text\String.s
        Text_X = \Text\x
        Len = \Text\Len
      EndIf
      
      If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        
        For i=0 To Len
          CursorX = Text_X+TextWidth(Left(String.s, i))+1
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
          
          ; Получаем позицию коpректора
          If MinDistance > Distance 
            MinDistance = Distance
            Result = i
          EndIf
        Next
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SelectionText(*This.Widget)
    Protected CaretPos
    
    With *This\Items()
      If *This\LinePos[1]>*This\LinePos
        PushListPosition(*This\Items())
        While PreviousElement(*This\Items()) : \Text[2]\Len = 0 : Wend
        PopListPosition(*This\Items())
      Else
        PushListPosition(*This\Items())
        While NextElement(*This\Items()) : \Text[2]\Len = 0 : Wend
        PopListPosition(*This\Items())
      EndIf
      
      ; Если выделяем с верху вниз
      If *This\LinePos > *This\LinePos[1]
        \Text[2]\Len = *This\Caret
      ElseIf *This\LinePos[1] > *This\LinePos
        CaretPos = *This\Caret
        \Text[2]\Len = \Text\Len-CaretPos
      Else
        ; Если выделяем с право на лево
        If *This\Caret[1] > *This\Caret 
          CaretPos = *This\Caret
          \Text[2]\Len = (*This\Caret[1]-CaretPos)
        Else 
          CaretPos = *This\Caret[1]
          \Text[2]\Len = (*This\Caret-CaretPos)
        EndIf
      EndIf
      
      If \Text[2]\Len
        \Text[1]\String.s = Left(\Text\String.s, CaretPos)
        \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
        ; \Text[3]\String.s = Mid(\Text\String.s, 1 + CaretPos + \Text[2]\Len)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
      Else
        \Text[2]\String.s = ""
      EndIf
    EndWith
    
    ProcedureReturn CaretPos
  EndProcedure
  
  Procedure RemoveText(*This.Widget)
    With *This\Items()
      ;*This\Caret = 0
      If *This\Caret > *This\Caret[1] : *This\Caret = *This\Caret[1] : EndIf
      ; Debug "  "+*This\Caret +" "+ *This\Caret[1]
      ;\Text\String.s = RemoveString(\Text\String.s, Trim(\Text[2]\String.s, #LF$), #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text[2]\String.s[1] = \Text[2]\String.s
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure Cut(*This.Widget)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
    
    With *This\Items()
      If ListSize(*This\Items()) 
        ;If \Text[2]\Len
        If *This\LinePos[1] = *This\LinePos
          Debug "Cut Black"
          If \Text[2]\Len
            RemoveText(*This)
          Else
            \Text[2]\String.s[1] = Mid(\Text\String.s, *This\Caret, 1)
            \Text\String.s = Left(\Text\String.s, *This\Caret - 1) + Right(\Text\String.s, \Text\Len-*This\Caret)
            \Text\String.s[1] = Left(\Text\String.s[1], *This\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-*This\Caret)
            *This\Caret - 1 
          EndIf
        Else
          Debug " Cut " +*This\Caret +" "+ *This\Caret[1]+" "+\Text[2]\Len
          
          If \Text[2]\Len
            ;If *This\LinePos > *This\LinePos[1] 
            RemoveText(*This)
            ;EndIf
            
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\LinePos)
            EndIf
          EndIf
          
          ; Выделили сверх вниз
          If *This\LinePos > *This\LinePos[1] 
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
            
            *This\Caret = *This\Caret[1]
            ; Выделили снизу верх 
          ElseIf *This\LinePos[1] > *This\LinePos 
            *This\LinePos[1] = *This\LinePos 
            
            *This\Caret[1] = *This\Caret  ; Выделили пос = 0 фикс = 1
            
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
          
          
          If *This\LinePos[1]>=0 And *This\LinePos[1]<ListSize(*This\Items())
            ;If *This\LinePos > *This\LinePos[1]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\LinePos[1])
            
            If Not *This\Caret
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            
            ; Выделили сверху вниз
            If *This\LinePos > *This\LinePos[1]
              *This\LinePos = *This\LinePos[1]
              *This\Caret = *This\Caret[1] ; Выделили пос = 0 фикс = 0
              \Text\String.s = String.s + \Text\String.s 
            Else
              ;;*This\Caret[1] = *This\Caret  ; Выделили пос = 0 фикс = 1
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
  
  Procedure.s Copy(*This.Widget)
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
      If String.s And Not \Caret
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.b Back(*This.Widget)
    Protected Repaint.b, String.s
    
    With *This\Items()
      If ListSize(*This\Items()) And (*This\Caret = 0 And *This\Caret = *This\Caret[1]) And ListIndex(*This\Items())  
        Debug "Back"
        
        If Not \Text[2]\Len
          If *This\LinePos[1] > *This\LinePos : *This\LinePos[1] = *This\LinePos : Else : *This\LinePos[1] - 1 : EndIf
          If (*This\LinePos[1]>=0 And *This\LinePos[1]<ListSize(*This\Items()))
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            SelectElement(*This\Items(), *This\LinePos[1])
            
            If *This\Caret = *This\Caret[1]
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            If *This\LinePos > *This\LinePos[1]
              *This\Caret[1] = *This\Caret
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
        
        SelectElement(*This\Items(), *This\LinePos[1])
        
        *This\LinePos = *This\LinePos[1]
        Repaint = #True
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget)
    Protected i, char
    
    With *This\Items()
      If \Text\Pass
        *This\Caret = \Text\Len
        \Text[2]\Len = *This\Caret
        *This\Caret[1] = 0
      Else
        char = Asc(Mid(\Text\String.s, *This\Caret + 1, 1))
        
        If (char > =  ' ' And char < =  '/') Or 
           (char > =  ':' And char < =  '@') Or 
           (char > =  '[' And char < =  96) Or 
           (char > =  '{' And char < =  '~')
          
          *This\Caret[1] = *This\Caret : *This\Caret + 1
          \Text[2]\Len = *This\Caret[1] - *This\Caret
        Else
          For i = *This\Caret To 0 Step - 1
            char = Asc(Mid(\Text\String.s, i, 1))
            If (char > =  ' ' And char < =  '/') Or 
               (char > =  ':' And char < =  '@') Or 
               (char > =  '[' And char < =  96) Or 
               (char > =  '{' And char < =  '~')
              Break
            EndIf
          Next
          
          If i =- 1 : *This\Caret[1] = 0 : Else : *This\Caret[1] = i : EndIf
          
          For i = *This\Caret + 1 To \Text\Len
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
          If \Text[2]\Len < 0 : \Text[2]\Len = 0 : EndIf
        EndIf
      EndIf
    EndWith           
  EndProcedure
  
  Procedure EditableCallBack(*This.Widget, EventType.i)
    Static Text$, DoubleClickCaretPos =- 1
    Protected Repaint.b, String.s, StartDrawing, Update_Text_Selected
    
    
    If *This
      With *This\Items()
        If Not *This\Disable
          Protected Item = (*This\Canvas\Mouse\Y-*This\Scroll\Y)/*This\Text\Height
          
          If EventType = #PB_EventType_LeftButtonDown
            *This\LinePos[1] = Item : *This\LinePos = *This\LinePos[1]
            
            PushListPosition(*This\Items())
            ForEach *This\Items() : \Text[2]\Len = 0 : Next
            PopListPosition(*This\Items())
          EndIf
          
          If EventType = #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons 
              If *This\LinePos>=0 And *This\LinePos < ListSize(*This\Items())
                SelectElement(*This\Items(), *This\LinePos)
                
                If *This\LinePos[1]>Item
                  *This\Caret = 0
                Else
                  *This\Caret = \Text\Len
                EndIf
                
                SelectionText(*This)
              EndIf
              
              *This\LinePos = Item
              If *This\LinePos>=0 And *This\LinePos < ListSize(*This\Items())
                SelectElement(*This\Items(), *This\LinePos)
              EndIf
            EndIf
          Else
            If *This\LinePos[1]>=0 And *This\LinePos[1] < ListSize(*This\Items())
              SelectElement(*This\Items(), *This\LinePos[1])
            EndIf
          EndIf
          
          
          Select EventType
            Case #PB_EventType_MouseEnter
              SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
              
            Case #PB_EventType_LostFocus : Repaint = #True
              If Not Bool(*This\Type = #PB_GadgetType_Editor)
                ; StringGadget
                \Text[2]\Len = 0 ; Убыраем выделение
              EndIf
              *This\Caret[1] =- 1 ; Прячем коректор
              
            Case #PB_EventType_Focus : Repaint = #True
              *This\Caret[1] = *This\Caret ; Показываем коректор
              
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
                    *This\Caret + 1
                    *This\Caret[1] = *This\Caret
                  EndIf
                  
                  If \Text\Numeric And Input = Input_2
                    \Text\String.s[1] = \Text\String.s
                  EndIf
                  
                  ;\Text\String.s = Left(\Text\String.s, *This\Caret-1) + Chr(Input) + Mid(\Text\String.s, *This\Caret)
                  \Text\String.s = InsertString(\Text\String.s, Chr(Input), *This\Caret)
                  \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), *This\Caret)
                  
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
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = 0 : *This\Caret[1] = *This\Caret : Repaint = #True 
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = \Text\Len : *This\Caret[1] = *This\Caret : Repaint = #True 
                  
                Case #PB_Shortcut_Left : \Text[2]\String.s = ""
                  If *This\Caret > 0 Or ListIndex(*This\Items()) : *This\Caret - 1 
                    
                    ; Если дошли до начала строки то переходим в конец предыдущего итема
                    If *This\Caret =- 1 And *This\LinePos[1] : *This\LinePos[1]-1
                      SelectElement(*This\Items(), *This\LinePos[1])
                      *This\Caret = \Text\Len-Len(#LF$)
                    EndIf
                    
                    If *This\Caret[1] <> *This\Caret
                      If \Text[2]\Len 
                        If *This\Caret > *This\Caret[1] 
                          *This\Caret = *This\Caret[1] 
                          *This\Caret[1] = *This\Caret 
                        Else
                          *This\Caret[1] = *This\Caret + 1 
                          *This\Caret = *This\Caret[1] 
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\Caret[1] = *This\Caret 
                      EndIf
                    EndIf
                    
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Right : \Text[2]\String.s = ""
                  If *This\Caret[1] < \Text\Len : *This\Caret[1] + 1 
                    
                    ; Если дошли в конец строки то переходим на начало следующего итема
                    If *This\Caret[1] = \Text\Len And *This\LinePos[1] < ListSize(*This\Items()) - 1 : *This\LinePos[1] + 1
                      SelectElement(*This\Items(), *This\LinePos[1]) : *This\Caret[1] = 0
                    EndIf
                    
                    If *This\Caret <> *This\Caret[1]
                      If \Text[2]\Len 
                        If *This\Caret > *This\Caret[1] 
                          *This\Caret = *This\Caret[1]+\Text[2]\Len - 1 
                          *This\Caret[1] = *This\Caret
                        Else
                          *This\Caret = *This\Caret[1] - 1
                          *This\Caret[1] = *This\Caret
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        *This\Caret = *This\Caret[1] 
                      EndIf
                    EndIf
                    
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Up : \Text[2]\String.s = ""
                  If *This\LinePos[1] : *This\LinePos[1]-1
                    SelectElement(*This\Items(), *This\LinePos[1])
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Down : \Text[2]\String.s = ""
                  If *This\LinePos[1] < ListSize(*This\Items()) - 1 : *This\LinePos[1] + 1
                    SelectElement(*This\Items(), *This\LinePos[1]) 
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Return
                  Debug "Return "+ListIndex(*This\Items())
                  If *This\Caret ;: *This\LinePos[1]+1
                    *This\Caret[1] = \Text\Len
                    SelectionText(*This) 
                    String.s = \Text[2]\String.s
                  EndIf
                  
                  If String.s
                    RemoveText(*This) 
                  Else
                    String.s = ""
                  EndIf
                  Debug String
                  
                  *This\LinePos[1] = AddItem(*This\Canvas\Gadget, *This\LinePos[1]+1, String.s+#LF$)
                  *This\Caret = 0
                  *This\Text\Len = Len(\Text\String.s)
                  *This\Caret[1] = *This\Caret
                  
                  ;                   If Not *This\Caret
                  ;                     SelectElement(*This\Items(), *This\LinePos[1])
                  ;                   ; *This\LinePos[1] + 1  
                  ;                   EndIf
                  
                  Scroll::SetState(*This\vScroll, *This\vScroll\Max)
                  Repaint = #True
                  
                Case #PB_Shortcut_Back 
                  Repaint = Back(*This)
                  If Not Repaint
                    Cut(*This)
                    
                    *This\Caret[1] = *This\Caret
                    \Text\Len = Len(\Text\String.s)
                    
                    Repaint = #True
                  EndIf
                  
                Case #PB_Shortcut_Delete 
                  If *This\Caret < \Text\Len
                    If \Text[2]\String.s
                      RemoveText(*This)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, (*This\Caret+1), 1)
                      \Text\String.s = Left(\Text\String.s, *This\Caret) + Right(\Text\String.s, \Text\Len-(*This\Caret+1))
                      \Text\String.s[1] = Left(\Text\String.s[1], *This\Caret) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(*This\Caret+1))
                    EndIf
                    
                    If ListSize(*This\Items())
                      PushListPosition(*This\Items())
                      ForEach *This\Items() 
                        If \Text[2]\Len = \Text\Len
                          DeleteElement(*This\Items(), 1)
                        EndIf
                      Next
                      PopListPosition(*This\Items())
                      
                      If *This\Caret = Len(\Text\String.s) : *This\LinePos[1]+1
                        If *This\LinePos[1]>=0 And *This\LinePos[1]<ListSize(*This\Items())
                          PushListPosition(*This\Items())
                          SelectElement(*This\Items(), *This\LinePos[1])
                          String.s = \Text\String.s
                          DeleteElement(*This\Items(), 1)
                          PopListPosition(*This\Items())
                          \Text\String.s + String.s 
                          *This\LinePos[1] - 1
                        EndIf
                      EndIf
                    EndIf
                    
                    *This\Caret[1] = *This\Caret
                    \Text\Len = Len(\Text\String.s)
                    
                    Repaint = #True
                  EndIf
                  
                  
                Case #PB_Shortcut_X
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                    
                    Cut(*This)
                    
                    *This\Caret[1] = *This\Caret
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_C ; Ok
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                  EndIf
                  
                Case #PB_Shortcut_V
                  If *This\Text\Editable And ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command))
                    Protected CaretPos, ClipboardText.s = Trim(GetClipboardText(), #CR$)
                    
                    If ClipboardText.s
                      If \Text[2]\Len
                        RemoveText(*This)
                        
                        If \Text[2]\Len = \Text\Len
                          ;*This\LinePos[1] = *This\LinePos
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
                      
                      \Text\String.s = InsertString( \Text\String.s, ClipboardText.s, *This\Caret + 1)
                      
                      If CountString(\Text\String.s, #LF$)
                        CaretPos = \Text\Len-*This\Caret
                        String.s = \Text\String.s
                        DeleteElement(*This\Items(), 1)
                        SetText(*This\Canvas\Gadget, String.s, *This\LinePos[1])
                        *This\Caret = Len(\Text\String.s)-CaretPos
                        ;                         SelectElement(*This\Items(), *This\LinePos)
                        ;                        *This\Caret = 0
                      Else
                        *This\Caret + Len(ClipboardText.s)
                      EndIf
                      
                      *This\Caret[1] = *This\Caret
                      \Text\Len = Len(\Text\String.s)
                      
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
            Case #PB_EventType_LeftDoubleClick 
              DoubleClickCaretPos = *This\Caret
              SelectionLimits(*This)
              SelectionText(*This) 
              Repaint = #True
              
            Case #PB_EventType_LeftButtonDown
              If \Text\Numeric : \Text\String.s[1] = \Text\String.s : EndIf
              *This\Caret = CaretPos(*This) : *This\Caret[1] = *This\Caret
              
              If *This\Caret = DoubleClickCaretPos
                DoubleClickCaretPos =- 1
                *This\Caret[1] = \Text\Len
                *This\Caret = 0
              EndIf 
              
              SelectionText(*This)
              Repaint = #True
              
            Case #PB_EventType_MouseMove
              If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                *This\Caret = CaretPos(*This)
                SelectionText(*This)
                Repaint = #True
              EndIf
              
          EndSelect
          
        EndIf
        
        If Repaint
          ; *This\CaretLength = \CaretLength
          *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Draw(*This.Widget)
    Protected Left, Right, r=1,height
    
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],*This\Color[0]\Back)
      
      
      If *This\fSize
        DrawingMode(#PB_2DDrawing_Outlined)
        ;             If \Active
        ;               Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],$FF8E00)
        ;             Else
        Box(*This\X[1],*This\Y[1],*This\Width[1],*This\Height[1],*This\Color[1]\Back)
        ;             EndIf
      EndIf
      
      
      
      *This\Text\Height = TextHeight("A")
      
      *This\Scroll\Height = *This\Text\Y
      ;       *This\Scroll\X =- *This\hScroll\Page\LinePos
      *This\Scroll\Y =- *This\vScroll\Page\Pos
      
      If ListSize(*This\Items())
       Protected CaretLength = TextWidth(Left(*This\Items()\Text\String.s, *This\Caret))
      EndIf
      
;       If *This\Resize
;         MakeDrawText(*This)
;         *This\Resize=0
;       EndIf
      
      With *This\Items()
        PushListPosition(*This\Items())
        
        ForEach *This\Items()
          \Text\Height = TextHeight("A")
          \Text\Width = TextWidth(\Text\String.s)
          \Text[1]\Width = TextWidth(\Text[1]\String.s) 
          \Text[2]\Width = TextWidth(\Text[2]\String.s)
          ;           If \Text[2]\Width%2       TextWidth(Mid(\Text\String.s, *This\Caret, *This\Caret[1]-*This\Caret))  ; 
          ;             \Text[2]\Width+1
          ;           EndIf
          
          \Text[3]\Width = TextWidth(\Text[3]\String.s)
          height = \Text\Height
          
          ; Debug ""+\Text[0]\Width +" "+ \Text[1]\Width +" "+ \Text[2]\Width +" "+ \Text[3]\Width 
          
;           ; Перемещаем корректор
;           Select *This\Text\XAlign 
;             Case 9 : *This\Scroll\X = (*This\Width-*This\Items()\Text\Width)/2
;               If *This\Scroll\X<*This\fSize*2 + r : *This\Scroll\X=*This\fSize*2 + r : EndIf
;               If *This\Caret[1] =- 1
;                 CaretLength =- *This\Scroll\X + *This\fSize*2 + r
;                 *This\Caret = CaretLength
;               EndIf
;             Case 2 : *This\Scroll\X = (*This\Width-\Text\Width-*This\fSize*2) - r
;           EndSelect
;           Select *This\Text\YAlign 
;             Case 9 : *This\Scroll\Y = (*This\Height-*This\Text\Height)/2
;             Case 2 : *This\Scroll\Y = (*This\Height-*This\Text\Height)
;           EndSelect
          
          If *This\Text\Editable
            If \Text[2]\String.s[1] And *This\Scroll\X < 0
              *This\Scroll\X + TextWidth(\Text[2]\String.s[1]) 
              \Text[2]\String.s[1] = ""
            EndIf
            
            Left =- (CaretLength-*This\fSize*2) + r
            Right = (*This\Width-CaretLength-*This\fSize*2) - r
            
            If *This\Scroll\X < Left
              *This\Scroll\X = Left
            ElseIf *This\Scroll\X > Right
              *This\Scroll\X = Right
            EndIf
            
          EndIf
          
          \Text\Y = *This\Scroll\Height+*This\Scroll\Y
          \Text\X = *This\Scroll\X - *This\hScroll\Page\Pos
          
          
          If *This\Scroll\Width<\Text\Width
            *This\Scroll\Width=\Text\Width
          EndIf
          
          *This\Scroll\Height + \Text\Height
        Next
        PopListPosition(*This\Items())
        
        ; Draw
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          ClipOutput(0,0, Scroll::X(*This\vScroll), Scroll::Y(*This\hScroll))
        CompilerEndIf
        
        PushListPosition(*This\Items())
        ForEach *This\Items()
          If \Text\String.s
            
            If \Text[2]\Len
              If \Text[2]\String.s
                If *This\LinePos[1] = *This\LinePos And *This\Caret[1]>*This\Caret
                  \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                  \Text[2]\X = \Text[3]\X-\Text[2]\Width
                Else
                  \Text[2]\X = \Text\X+\Text[1]\Width
                  \Text[3]\X = \Text[2]\X+\Text[2]\Width
                EndIf
              EndIf
              
              If \Text\String.s = \Text[1]\String.s+\Text[2]\String.s
                DrawingMode(#PB_2DDrawing_Default)
                ; Box(\Text[2]\X, \Text\Y, *This\Width[1], \Text\Height, $D77800)
                Box(\Text[2]\X, \Text\Y, \Text[2]\Width, \Text\Height, $D77800)
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(\Text\X, \Text\Y, \Text\String.s, $FFFFFF)
                
                If \Text[1]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
                EndIf
                
              Else
                If *This\LinePos[1] = *This\LinePos And *This\Caret[1] > *This\Caret
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(\Text[3]\X, \Text\Y, \Text[3]\String.s, $0B0B0B)
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, \Text\Y, \Text[2]\Width, \Text\Height, $D77800)
                    
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(\Text\X, \Text\Y, \Text[1]\String.s+\Text[2]\String.s, $FFFFFF)
                  EndIf
                  
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
                  EndIf
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Default)
                    DrawText(\Text[2]\X, \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
                  EndIf
                EndIf
              EndIf
              
              
            Else
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
            EndIf
          EndIf
        Next
        PopListPosition(*This\Items())
        
        If ListSize(*This\Items()) And *This\Caret=*This\Caret[1] ; And Property_GadgetTimer( 300 )
          DrawingMode(#PB_2DDrawing_XOr)  
          Line(*This\Items()\Text\X + CaretLength - Bool(*This\Scroll\X = Right), *This\Items()\Text\y, 1, *This\Text\Height, $FFFFFF)
        EndIf
        
      EndWith  
      
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          UnclipOutput()
        CompilerEndIf
        
      If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And
         Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
        Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        ; *This\vScroll\Page\ScrollStep = height
      EndIf
      If *This\hScroll\Page\Length And *This\hScroll\Max<>*This\Scroll\Width And
         Scroll::SetAttribute(*This\hScroll, #PB_ScrollBar_Maximum, *This\Scroll\Width)
        Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      Scroll::Draw(*This\vScroll)
      Scroll::Draw(*This\hScroll)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure ReDraw(*This.Widget)
    Draw(*This)
  EndProcedure
  
  Procedure CallBack()
    Static LastX, LastY
    Protected Repaint, *This.Widget = GetGadgetData(EventGadget())
    
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
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Widget = GetGadgetData(Gadget)
    
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
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected ScrollPos, *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected ScrollPos, *This.Widget = GetGadgetData(Gadget)
    
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure AddItem(Gadget, Item,Text.s,Image.i=-1,Flag.i=0)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This\Items()
      If Item = #PB_Any
        LastElement(*This\Items())
        AddElement(*This\Items()) 
      Else
        If (Item > (ListSize(*This\Items()) - 1))
          LastElement(*This\Items())
          AddElement(*This\Items()) 
        Else
          SelectElement(*This\Items(), Item)
          InsertElement(*This\Items())
        EndIf
      EndIf
      
      \Text\String.s = Text.s
      
      \Text\X = *This\Text\X
      \Text\Y = *This\Text\Y
      
      \Text\Editable = 1
; ;       \Text\XAlign = *This\Text\XAlign
; ;       \Text\YAlign = *This\Text\YAlign
      
      *This\Caret[1] =- 1
      \Text\Len = Len(\Text\String.s)
      
    EndWith
    
    ;;*This\Resize = 1
        
    If *This\Scroll\Height<*This\Height
      Draw(*This)
      ; Scroll::SetState(*This\vScroll, *This\vScroll\Max)
    EndIf
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure SetText(Gadget, Text.s, Item.i=0)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This\Items()
;       If *This
;       If *This\Text\String.s <> Text.s
;         *This\Text\String.s = Text.s
;         *This\Resize = 1
;         *This\Text\Change = 1
;         Draw(*This)
;       EndIf
;     EndIf
    
    Protected i,c = CountString(Text.s, #LF$)
      
      For i=0 To c
        Debug "String len - "+Len(StringField(Text.s, i + 1, #LF$))
        AddItem( Gadget, Item+i, StringField(Text.s, i + 1, #LF$))
      Next
    EndWith
  EndProcedure
  
  Procedure SetFont(Gadget.i, FontID.i)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Resize = 1
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
    Protected *This.Widget=AllocateStructure(Widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Min.i, Max.i, PageLength.i
    
    With *This
      If *This
        \Canvas\Gadget = Gadget
        \Type = #PB_GadgetType_Editor
        \Text\FontID = GetGadgetFont(#PB_Default)
        ;\Text\FontID = GetGadgetFont(Gadget)
        
        \fSize = Bool(Not Flag&#PB_String_BorderLess)
        \bSize = \fSize
        
        \Width = Width
        \Height = Height
        
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
        
        \Color[0]\Back = $C0C0C0
        \Color[0]\Frame = $F0F0F0
        
        ;\Scroll\ButtonLength = 7
        \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        If \Text\Editable
          \Color[0]\Back = $FFFFFF
        Else
          \Color[0]\Back = $F0F0F0
        EndIf
        
        \Text\X = 2
        \Text\y = \fSize
        
;         \Text\YAlign = 0 
;         If Bool(Flag&#PB_Text_Right) : \Text\XAlign = 2 : EndIf
;         If Bool(Flag&#PB_Text_Center) : \Text\XAlign = 9 : EndIf
        
        
        Scroll::widget(*This\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        Scroll::widget(*This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        
        
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        
        If Text.s
          SetText(Gadget, Text.s)
        EndIf
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
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
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  If OpenWindow(0, 0, 0, 422, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    EditorGadget(0, 8, 8, 306, 133) : SetGadgetText(0, Text.s) 
    For a = 0 To 5
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, "") : Editor::SetText(g, Text.s) 
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
; Folding = ---------------------------------
; EnableXP