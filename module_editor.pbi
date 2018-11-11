CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
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
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare.s GetText(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare SetText(Gadget, Text.s, Item.i=0)
  Declare SetFont(Gadget, FontID.i)
  Declare AddItem(Gadget,Item,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  
EndDeclareModule

Module Editor
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  Procedure ReDraw(*This.Widget_S, Canvas =- 1)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This, Canvas)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
    ProcedureReturn Text::Caret(*This, Line)
    
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i;=7
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
            If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
              Item.i =- 1 
            Else
              Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            EndIf
            
            If LastLine <> \Line Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              ; Если выделяем сверху вниз, 
              ; если каректор находится в конце слова, 
              ; и позиция курсора неже половини высоты линии
              If (\Line[1] < \Line And Item = \Line And Position = len)
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              If (\Items()\Text\String.s = "" And Item = \Line And Position = len) Or
                 \Line[1] > \Line Or ; Если выделяем снизу вверх
                 (\Line[1] = \Line And Item = \Line And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Line[1] < \Line And                                     ; Если выделяем сверху вниз
                  PreviousElement(*This\Items()))                          ; то выбираем предыдущую линию
                
                ;                 If \Items()\Text\String.s = ""
                ;                   \Items()\Text[2]\Len = 1
                ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                ;                   Debug \Items()\Text[2]\Width[2] 
                ;                   \Items()\Text[2]\Width[2] = SelectionLen
                ;               ;\Items()\Text[2]\Width[2] = SelectionLen
                ;             EndIf
                ;             
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
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      ;Debug "7777    "+*This\Caret +" "+ *This\Caret[1] +" "+*This\Line +" "+ *This\Line[1] +" "+ \Text\String
      
      If (Caret <> *This\Caret Or Line <> *This\Line Or (*This\Caret[1] >= 0 And Caret1 <> *This\Caret[1]))
        \Text[2]\String.s = ""
        ; Debug 8888
        PushListPosition(*This\Items())
        If *This\Line[1] = *This\Line
          If *This\Caret[1] = *This\Caret And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
            \Text[2]\Width = 0 
          EndIf
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Width[2] = 0 
            \Text[2]\Len = 0 
          EndIf
        ElseIf *This\Line[1] > *This\Line
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Line[1] = *This\Line
          If *This\Caret[1] = *This\Caret 
            Position = *This\Caret[1]
            ;             If *This\Caret[1] = \Text\Len
            ;              ; Debug 555
            ;             ;  \Text[2]\Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf *This\Caret[1] > *This\Caret 
            ; |<<<<<< to left
            Position = *This\Caret
            \Text[2]\Len = (*This\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Caret[1]
            \Text[2]\Len = (*This\Caret-Position)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf *This\Line[1] > *This\Line
          ; <<<<<|
          Position = *This\Caret
          \Text[2]\Len = \Text\Len-Position
          \Text[2]\Len | Bool(\Text\Len=Position) ; 
        Else
          ; >>>>>|
          Position = 0
          \Text[2]\Len = *This\Caret
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Len = Len(\Text[1]\String.s) : \Text[1]\Change = #True
        If \Text[2]\Len > 0 : \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True : EndIf
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Len = Len(\Text[3]\String.s) : \Text[3]\Change = #True
        
        Line = *This\Line
        Caret = *This\Caret
        Caret1 = *This\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionReset(*This.Widget_S)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  
  ;-
  Procedure RemoveText(*This.Widget_S)
    ;ProcedureReturn
    
    With *This\Items()
      ;Debug *This\Line
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
  
  Procedure Remove(*This.Widget_S)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Caret - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret, 1)
          Caret + \Items()\Caret
          *This\Line - 1
          
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] < \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret[1], 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
            Else
              \Items()\Caret - Caret
              Debug \Items()\Caret
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret, 1) 
              *This\Line - 1
            EndIf
          EndIf
          Caret = \Items()\Text[2]\Len
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  Procedure _Remove(*This.Widget_S)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Caret - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret, 1)
          Caret + \Items()\Caret
          *This\Line - 1
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] > \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
              Caret = \Items()\Text[2]\Len
            Else
              \Items()\Caret - Caret
              Debug \Items()\Caret
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret, 1) 
              *This\Line - 1
            EndIf
          EndIf
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  
  
  Procedure Cut(*This.Widget_S)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
    
    With *This\Items()
      If ListSize(*This\Items()) 
        ;If \Text[2]\Len > 0
        If *This\Line[1] = *This\Line
          Debug "Cut Black"
          If \Text[2]\Len > 0
            RemoveText(*This)
          Else
            \Text[2]\String.s[1] = Mid(\Text\String.s, *This\Caret, 1)
            \Text\String.s = Left(\Text\String.s, *This\Caret - 1) + Right(\Text\String.s, \Text\Len-*This\Caret)
            \Text\String.s[1] = Left(\Text\String.s[1], *This\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-*This\Caret)
            *This\Caret - 1 
          EndIf
        Else
          Debug " Cut " +*This\Caret +" "+ *This\Caret[1]+" "+\Text[2]\Len
          
          If \Text[2]\Len > 0
            ;If *This\Line > *This\Line[1] 
            RemoveText(*This)
            ;EndIf
            
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\Line)
            EndIf
          EndIf
          
          ; Выделили сверх вниз
          If *This\Line > *This\Line[1] 
            Debug "  Cut_1_ForEach"
            
            PushListPosition(*This\Items())
            ForEach *This\Items() 
              If \Text[2]\Len > 0
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
          ElseIf *This\Line[1] > *This\Line 
            *This\Line[1] = *This\Line 
            
            *This\Caret[1] = *This\Caret  ; Выделили пос = 0 фикс = 1
            
            ;             Debug "  Cut_21_ForEach"
            ;               
            ;             PushListPosition(*This\Items())
            ;             ForEach *This\Items() 
            ;               If \Text[2]\Len > 0
            ;                 If \Text[2]\Len = \Text\Len
            ;                   DeleteElement(*This\Items(), 1) 
            ;                 Else
            ;                   RemoveText(*This)
            ;                 EndIf
            ;               EndIf
            ;             Next
            ;             PopListPosition(*This\Items())
            
          EndIf
          
          
          If *This\Line[1]>=0 And *This\Line[1]<ListSize(*This\Items())
            ;If *This\Line > *This\Line[1]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\Line[1])
            
            If Not *This\Caret
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            
            ; Выделили сверху вниз
            If *This\Line > *This\Line[1]
              *This\Line = *This\Line[1]
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
            If \Text[2]\Len > 0 
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
        If \Items()\Text[2]\Len > 0 
          String.s+\Items()\Text[2]\String.s+#LF$
        EndIf
      Next
      PopListPosition(\Items())
      
      String.s = Trim(String.s, #LF$)
      
      ; Для совместимости с виндовсовским 
      If String.s And Not *This\Caret
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  
  ;-
  Procedure ToUp(*This.Widget_S)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Line[1] > 0 And \Line = \Line[1]) : \Line[1] - 1 : \Line = \Line[1]
        SelectElement(\Items(), \Line[1])
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDown(*This.Widget_S)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Line < ListSize(\Items()) - 1 And \Line = \Line[1]) : \Line[1] + 1 : \Line = \Line[1]
        SelectElement(\Items(), \Line[1]) 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToLeft(*This.Widget_S) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Line[1] > \Line 
          Swap \Line[1], \Line
          
          If SelectElement(\Items(), \Line[1]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Line > \Line[1] And 
               \Caret[1] > \Caret
          Swap \Caret[1], \Caret
        ElseIf \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Line <> \Line[1]
          SelectionReset(*This)
          \Line = \Line[1]
          Repaint =- 1
        EndIf
      ElseIf \Caret[1] > 0 
        \Caret - 1 
      EndIf
      
      If \Caret[1] <> \Caret
        \Caret[1] = \Caret 
        Repaint =- 1 
      ElseIf Not Repaint And ToUp(*This.Widget_S)
        \Caret = \Items()\Text\Len
        \Caret[1] = \Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Line > \Line[1] 
          Swap \Line, \Line[1] 
          Swap \Caret, \Caret[1]
          
          If SelectElement(\Items(), \Line[1]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Line[1] = \Line And 
               \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Line <> \Line[1]
          SelectionReset(*This)
          \Line = \Line[1]
          Repaint =- 1
        EndIf
      ElseIf \Caret[1] < \Items()\Text\Len 
        \Caret[1] + 1 
      EndIf
      
      If \Caret <> \Caret[1]
        \Caret = \Caret[1] 
        Repaint =- 1 
      ElseIf Not Repaint And ToDown(*This)
        \Caret[1] = 0
        \Caret = \Caret[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*This.Widget_S)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *This
      If \Canvas\Input
        Chr.s = Text::Make(*This, Chr(\Canvas\Input))
        
        If Chr.s
          If \Items()\Text[2]\Len 
            If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
            \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
          EndIf
          
          \Caret + 1
          \Items()\Text\String.s = \Items()\Text[1]\String.s + Chr(\Canvas\Input) + \Items()\Text[3]\String.s
          \Text\String.s = InsertString(\Text\String.s, Chr.s, \Items()\Caret+\Caret)
          \Text\Len = Len(\Text\String.s) 
          \Caret[1] = \Caret 
          \Text\Change =- 1
        Else
          \Default = *This
        EndIf
        
        \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(\Canvas\Input), \Items()\Caret+\Caret)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
    Protected Repaint, String.s 
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ;ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This
      If \Items()\Text[2]\Len
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf  
        Remove(*This)
        
      ElseIf \Caret[1] > 0 
        Debug " "+ListIndex(\Items())+" "+\Items()\Caret+" "+\Items()\Text\String.s; 
        \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Caret+\Caret - 1) + Mid(\Text\String.s[1],  \Items()\Caret+\Caret + 1)
        \Text\String.s = Left(\Text\String.s, \Items()\Caret+\Caret - 1) + Mid(\Text\String.s,  \Items()\Caret+\Caret + 1)
        \Caret - 1 
        \Text\Change =- 1
      Else
        ; Если дошли до начала строки то 
        ; переходим в конец предыдущего итема
        If *This\Line[1] > 0 
          \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
          
          ToUp(*This)
          
          *This\Caret = \Items()\Text\Len 
          \Text\Change =- 1
        EndIf
        
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This.Widget_S)
    Protected Repaint, String.s
    
    With *This\Items()
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
          
          If *This\Caret = Len(\Text\String.s) : *This\Line[1]+1
            If *This\Line[1]>=0 And *This\Line[1]<ListSize(*This\Items())
              PushListPosition(*This\Items())
              SelectElement(*This\Items(), *This\Line[1])
              String.s = \Text\String.s
              DeleteElement(*This\Items(), 1)
              PopListPosition(*This\Items())
              \Text\String.s + String.s 
              *This\Line[1] - 1
            EndIf
          EndIf
        EndIf
        
        *This\Caret[1] = *This\Caret
        \Text\Len = Len(\Text\String.s)
        
        Repaint = #True
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Items()\Text[2]\Len > 0
        If \Line[1] > \Line : Swap \Line[1], \Line : EndIf
        
        If \Line = \Line[1] 
          String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
        Else    
          PushListPosition(\Items())
          ForEach \Items()
            Select ListIndex(\Items()) 
              Case \Line[1] : String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$
              Case \Line : String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
            EndSelect
          Next
          PopListPosition(\Items())
        EndIf
      Else
        If \Items()\Text[1]\String.s And \Items()\Text[3]\String.s
          ; курсор в нутри слова
          String.s = \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s
        ElseIf \Items()\Text[3]\String.s
          ; курсор в начале слова
          String.s = #LF$ + \Items()\Text[3]\String.s
        ElseIf \Items()\Text[1]\String.s
          ; курсор в конце слова
          String.s = \Items()\Text[1]\String.s + #LF$
        Else
          ; курсор на линии где нету слово
          String.s = #LF$
        EndIf
        String.s = Left(\Text\String.s, \Items()\Caret) + String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
      EndIf
      
      \Line[1] + 1
      \Line = \Line[1]
      
      \Caret = 0
      \Caret[1] = \Caret
      
      \Text\String.s = String.s
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      ;       Scroll::SetState(\vScroll, \vScroll\Max)
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
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
  
  Procedure ClearItems(Gadget.i)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
  
  Procedure.i CountItems(Gadget.i, Item.i=-1)
    Protected Result.i, *This.Widget_S, sublevel.i
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If Item.i=-1
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
  
  Procedure.i RemoveItem(Gadget.i, Item.i)
    Protected Result.i, *This.Widget_S, sublevel.i
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
  
  Procedure AddLine(Gadget.i,Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, Len
    Protected *This.Widget_S, Childrens.i, hide.b, *Item, sublevel.i, Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    ;Item=0
    If Not *This
      ProcedureReturn -1
    EndIf
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Style\InLine
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
        If _this_\Style\InLine
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
        ElseIf _this_\Text\Align\Horisontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
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
      Width = \Width[1]-\Text\X*2  
      Height = \Height[1]-\Text\y*2 
      
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\Items()) - 1
        LastElement(\Items())
        AddElement(\Items()) 
        Item = ListIndex(\Items())
        *Item = @\Items()
      Else
        SelectElement(\Items(), Item)
        If \Items()\sublevel>sublevel
          sublevel=\Items()\sublevel 
        EndIf
        *Item = @\Items()
        InsertElement(\Items())
        
        PushListPosition(\Items())
        While NextElement(\Items())
          \Items()\Item = ListIndex(\Items())
        Wend
        PopListPosition(\Items())
      EndIf
      ;}
      AddElement(\Items())
      Protected String.s = Text;StringField(\Text\String.s[2], IT, #LF$)
      
      ; Set line default colors             
      \Items()\Color = \Color
      \Items()\Color\State = 1
      \Items()\Color\Fore[\Items()\Color\State] = 0
      
      \Items()\Radius = \Radius
      
; ;       If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
; ;         If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
; ;         If \Type = #PB_GadgetType_Button
; ;           \Items()\Text\Width = TextWidth(RTrim(String))
; ;         Else
; ;           \Items()\Text\Width = TextWidth(String)
; ;         EndIf
; ;         StopDrawing()
; ;       EndIf
      \Items()\Text\Change = 1
      
      ; Update line pos in the text
      \Items()\Caret = Len
      \Items()\Text\Len = Len(String.s)
      Len + \Items()\Text\Len + 1 ; Len(#LF$)
      
      _set_content_X_(*This)
      _line_resize_(*This)
      
      \Items()\y = \Y[1]+\Text\Y+\Scroll\Height+Text_Y
      If \Text\Count = 1
        \Items()\Height = \Text\Height
      Else
        \Items()\Height = \Text\Height - Bool(\Flag\GridLines)
      EndIf
      \Items()\Item = ListIndex(\Items())
      
      \Items()\Text\y = \Items()\y
      \Items()\Text\Height = \Text\Height
      \Items()\Text\String.s = String.s
      
      If \Line[1] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
      
      ; Is visible lines
      \Items()\Hide = Bool( Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      If \Scroll\Width<\Items()\Text\Width
        \Scroll\Width=\Items()\Text\Width
      EndIf
      
      ; Scroll hight length
      \Scroll\Height+\Text\Height
      
      \Text\String.s = String.s +#LF$+ \Text\String.s
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure.i AddItem(Gadget, Item, Text.s,Image.i=-1,Flag.i=0)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    Protected Result.i, String.s, i.i
    Static Len
    
    With *This
      If (Item > \Text\Count Or Item < 0)
        Item = \Text\Count
      EndIf
      
      If Item = \Text\Count
        
        If Item     
          String.s = StringField(\Text\String.s, item, #LF$)+#LF$ : i = Len(String.s) : Len + i
          \Text\String.s = InsertString(\Text\String.s, #LF$ + Text.s, len )
          \Text\Len + i
        Else
          String.s = Text.s +#LF$
          \Text\String.s = String.s + \Text\String.s
          \Text\Len + Len(String.s)
        EndIf
        
        \Text\Count + 1
        
        ; AddLine(Gadget,Item,Text.s,Image,Flag)
      Else 
        Text::AddLine(*This, Item, Text.s) 
      EndIf
      
      ;         ; \Text\Change = 1
      ;         Result = 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(Gadget, Text.s, Item.i=0)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    If Text::SetText(*This, Text.s) 
      ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i SetFont(Gadget.i, FontID.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    If Text::SetFont(*This, FontID)
      ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    If *This
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
                                                      ; Get line & caret position
            If \Canvas\Mouse\Buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                SelectionReset(*This)
                
                If \Items()\Text[2]\Len > 0
                  \Text[2]\Len = 1
                Else
                  \Caret = Caret(*This, Item) 
                  \Line = ListIndex(*This\Items()) 
                  \Line[1] = Item
                  
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Line[1] <> ListIndex(\Items())
                      \Items()\Text[1]\String = ""
                      \Items()\Text[2]\String = ""
                      \Items()\Text[3]\String = ""
                    EndIf
                  Next
                  PopListPosition(\Items())
                  
                  \Caret[1] = \Caret
                  
                  If \Caret = DoubleClick
                    DoubleClick =- 1
                    \Caret[1] = \Items()\Text\Len
                    \Caret = 0
                  EndIf 
                  
                  SelectionText(*This)
                  Repaint = #True
                  
                  
                EndIf
                
              Case #PB_EventType_LeftButtonUp
                ;               If \Caret = \Caret[1] ; And \Line = \Line[1] 
                ; ;                 If Not \Drag
                ;                   ; Сбрасываем все виделения.
                ;                   PushListPosition(\Items())
                ;                   ForEach \Items() 
                ;                     If \Items()\Text[2]\Len <> 0
                ;                       \Items()\Text[2]\Len = 0 
                ;                     EndIf
                ;                   Next
                ;                   PopListPosition(\Items())
                ;                   Repaint = 1
                ; ;                 EndIf
                ;                   \Text[2]\Len = 0
                \Drag = 0
                ;               EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                  
                  If Not \Text[2]\Len
                    If \Line <> Item And Item =< ListSize(\Items())
                      If isItem(\Line, \Items()) 
                        If \Line <> ListIndex(\Items())
                          SelectElement(\Items(), \Line) 
                        EndIf
                        
                        If \Line > Item
                          \Caret = 0
                        Else
                          \Caret = \Items()\Text\Len
                        EndIf
                        
                        SelectionText(*This)
                      EndIf
                      
                      \Line = Item
                    EndIf
                    
                    If isItem(Item, \Items()) 
                      \Caret = Caret(*This, Item) 
                      SelectionText(*This)
                    EndIf
                  EndIf
                  
                  Repaint = #True
                EndIf
                
              Case #PB_EventType_LeftDoubleClick 
                DoubleClick = \Caret
                Text::SelectionLimits(*This)
                SelectionText(*This) 
                Repaint = #True
                
                \Caret = Caret(*This, \Line[1]) 
                
              Case #PB_EventType_MouseEnter
                ; Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Items()\Text[1]\Width +" "+ \Items()\Text[1]\String.s
                ClearDebugOutput()
                Debug \Text\String.s
                
              Case #PB_EventType_LostFocus : Repaint = #True
                If Bool(\Type <> #PB_GadgetType_Editor)
                  ; StringGadget
                  \Items()\Text[2]\Len = 0 ; Убыраем выделение
                EndIf
                \Caret[1] =- 1 ; Прячем коректор
                
              Case #PB_EventType_Focus : Repaint = #True
                \Caret[1] = \Caret ; Показываем коректор
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
          If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_Input ;- Input (key)
                If Not Control
                  Repaint = ToInput(*This)
                EndIf
                
              Case #PB_EventType_KeyUp
                If \Text\Numeric
                  \Text\String.s[1]=\Text\String.s 
                EndIf
                Repaint = #True 
                
              Case #PB_EventType_KeyDown
                Select *This\Canvas\Key
                  Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = 0 : *This\Caret[1] = *This\Caret : Repaint =- 1
                  Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = \Text\Len : *This\Caret[1] = *This\Caret : Repaint =- 1 
                    
                  Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
                  Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
                  Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
                  Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
                  Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
                  Case #PB_Shortcut_Return : Repaint = Text::ToReturn(*This) 
                  Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                    
                    
                  Case #PB_Shortcut_C, #PB_Shortcut_X
                    If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                      SetClipboardText(Copy(*This))
                      
                      If *This\Canvas\Key = #PB_Shortcut_X
                        Cut(*This)
                        
                        *This\Caret[1] = *This\Caret
                        Repaint = #True 
                      EndIf
                    EndIf
                    
                  Case #PB_Shortcut_V
                    If *This\Text\Editable And ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command))
                      Protected ClipboardText.s = Trim(GetClipboardText(), #CR$)
                      
                      If ClipboardText.s
                        If \Text[2]\Len > 0
                          RemoveText(*This)
                          
                          If \Text[2]\Len = \Text\Len
                            ;*This\Line[1] = *This\Line
                            ClipboardText.s = Trim(ClipboardText.s, #LF$)
                          EndIf
                          ;                         
                          PushListPosition(*This\Items())
                          ForEach *This\Items()
                            If \Text[2]\Len > 0 
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
                          Caret = \Text\Len-*This\Caret
                          String.s = \Text\String.s
                          DeleteElement(*This\Items(), 1)
                          SetText(*This\Canvas\Gadget, String.s, *This\Line[1])
                          *This\Caret = Len(\Text\String.s)-Caret
                          ;                         SelectElement(*This\Items(), *This\Line)
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
                
            EndSelect
          EndIf
          
          If Repaint
            ;\Text[3]\Change = Bool(Repaint =- 1)
            If Repaint =- 1
              SelectionText(*This) 
            EndIf
            
            If Repaint = 2
              *This\Text[0]\Change = Repaint
              \Text[1]\Change = Repaint
              \Text[2]\Change = Repaint
              \Text[3]\Change = Repaint
            EndIf
            ; *This\CaretLength = \CaretLength
            *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
          EndIf
        EndWith
      EndIf
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i _Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Focus.Widget_S, *Last.Widget_S, *Widget.Widget_S
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        If Canvas <> \Canvas\Gadget Or 
           \Type <> #PB_GadgetType_Editor
        EndIf
        
        ; Get at point widget
        \Canvas\Mouse\From = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\Canvas\Mouse\Buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\Canvas\Mouse\From 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And Not \Disable And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \Canvas\Mouse\Buttons 
                If \Canvas\Mouse\From
                  If *Last <> *This 
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
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
                    Events(*Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Events(List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Events(*This, #PB_EventType_Focus, Canvas, 0)
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
                \Canvas\Mouse\Delta\From = \Canvas\Mouse\From
                \Canvas\Mouse\Delta\Buttons = \Canvas\Mouse\Buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\Canvas\Mouse\Delta) : \Canvas\Mouse\Delta = 0
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \Canvas\Mouse\Buttons And \Canvas\Mouse\Delta And 
                 (Abs((\Canvas\Mouse\X-\Canvas\Mouse\Delta\X)+(\Canvas\Mouse\Y-\Canvas\Mouse\Delta\Y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Canvas\Gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\Canvas\Mouse\From = From(List()\Widget)
                    
                    If List()\Widget\Canvas\Mouse\From
                      If *Last
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Events(*Last, #PB_EventType_MouseEnter, Canvas, 0)
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
              If \Canvas\Mouse\Buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \Cursor <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                                                                          ; Debug 555
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              EndIf
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    ;     If (*Last = *This)
    ;       Select EventType
    ;         Case #PB_EventType_Focus          : Debug "  "+Bool((*Last = *This))+" Focus"          +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LostFocus      : Debug "  "+Bool((*Last = *This))+" LostFocus"      +" "+ *This\Text\String.s
    ;         Case #PB_EventType_MouseEnter     : Debug "  "+Bool((*Last = *This))+" MouseEnter"     +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_MouseLeave     : Debug "  "+Bool((*Last = *This))+" MouseLeave"     +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftButtonDown : Debug "  "+Bool((*Last = *This))+" LeftButtonDown" +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_LeftButtonUp   : Debug "  "+Bool((*Last = *This))+" LeftButtonUp"   +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftClick      : Debug "  "+Bool((*Last = *This))+" LeftClick"      +" "+ *This\Text\String.s
    ;       EndSelect
    ;     EndIf
    
    Protected Caret,Item.i, String.s
    
    If ListSize(*This\items())
      With *This
        If *Last = *This
          If Not \Hide And Not \Disable And \Interact ; And Widget <> Canvas And CanvasModifiers
                                                      ; Get line & caret position
            If \Canvas\Mouse\Buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                SelectionReset(*This)
                
                If \Items()\Text[2]\Len > 0
                  \Text[2]\Len = 1
                Else
                  \Caret = Caret(*This, Item) 
                  \Line = ListIndex(*This\Items()) 
                  \Line[1] = Item
                  
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Line[1] <> ListIndex(\Items())
                      \Items()\Text[1]\String = ""
                      \Items()\Text[2]\String = ""
                      \Items()\Text[3]\String = ""
                    EndIf
                  Next
                  PopListPosition(\Items())
                  
                  \Caret[1] = \Caret
                  
                  If \Caret = DoubleClick
                    DoubleClick =- 1
                    \Caret[1] = \Items()\Text\Len
                    \Caret = 0
                  EndIf 
                  
                  SelectionText(*This)
                  Repaint = #True
                  
                  
                EndIf
                
              Case #PB_EventType_LeftButtonUp
                ;               If \Caret = \Caret[1] ; And \Line = \Line[1] 
                ; ;                 If Not \Drag
                ;                   ; Сбрасываем все виделения.
                ;                   PushListPosition(\Items())
                ;                   ForEach \Items() 
                ;                     If \Items()\Text[2]\Len <> 0
                ;                       \Items()\Text[2]\Len = 0 
                ;                     EndIf
                ;                   Next
                ;                   PopListPosition(\Items())
                ;                   Repaint = 1
                ; ;                 EndIf
                ;                   \Text[2]\Len = 0
                \Drag = 0
                ;               EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                  
                  If Not \Text[2]\Len
                    If \Line <> Item And Item =< ListSize(\Items())
                      If isItem(\Line, \Items()) 
                        If \Line <> ListIndex(\Items())
                          SelectElement(\Items(), \Line) 
                        EndIf
                        
                        If \Line > Item
                          \Caret = 0
                        Else
                          \Caret = \Items()\Text\Len
                        EndIf
                        
                        SelectionText(*This)
                      EndIf
                      
                      \Line = Item
                    EndIf
                    
                    If isItem(Item, \Items()) 
                      \Caret = Caret(*This, Item) 
                      SelectionText(*This)
                    EndIf
                  EndIf
                  
                  Repaint = #True
                EndIf
                
              Case #PB_EventType_LeftDoubleClick 
                DoubleClick = \Caret
                Text::SelectionLimits(*This)
                SelectionText(*This) 
                Repaint = #True
                
                \Caret = Caret(*This, \Line[1]) 
                
              Case #PB_EventType_MouseEnter
                ; Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Items()\Text[1]\Width +" "+ \Items()\Text[1]\String.s
                ClearDebugOutput()
                Debug \Text\String.s
                
              Case #PB_EventType_LostFocus : Repaint = #True
                If Bool(\Type <> #PB_GadgetType_Editor)
                  ; StringGadget
                  \Items()\Text[2]\Len = 0 ; Убыраем выделение
                EndIf
                \Caret[1] =- 1 ; Прячем коректор
                
              Case #PB_EventType_Focus : Repaint = #True
                \Caret[1] = \Caret ; Показываем коректор
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndIf
      EndWith    
      
      With *This\items()
        If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
          CompilerElse
            Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
          CompilerEndIf
          
          Select EventType
            Case #PB_EventType_Input ;- Input (key)
              If Not Control
                Repaint = ToInput(*This)
              EndIf
              
            Case #PB_EventType_KeyUp
              If \Text\Numeric
                \Text\String.s[1]=\Text\String.s 
              EndIf
              Repaint = #True 
              
            Case #PB_EventType_KeyDown
              Select *This\Canvas\Key
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = 0 : *This\Caret[1] = *This\Caret : Repaint =- 1
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = \Text\Len : *This\Caret[1] = *This\Caret : Repaint =- 1 
                  
                Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
                Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
                Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
                Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
                Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
                Case #PB_Shortcut_Return : Repaint = Text::ToReturn(*This) 
                Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                  
                  
                Case #PB_Shortcut_C, #PB_Shortcut_X
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                    
                    If *This\Canvas\Key = #PB_Shortcut_X
                      Cut(*This)
                      
                      *This\Caret[1] = *This\Caret
                      Repaint = #True 
                    EndIf
                  EndIf
                  
                Case #PB_Shortcut_V
                  If *This\Text\Editable And ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command))
                    Protected ClipboardText.s = Trim(GetClipboardText(), #CR$)
                    
                    If ClipboardText.s
                      If \Text[2]\Len > 0
                        RemoveText(*This)
                        
                        If \Text[2]\Len = \Text\Len
                          ;*This\Line[1] = *This\Line
                          ClipboardText.s = Trim(ClipboardText.s, #LF$)
                        EndIf
                        ;                         
                        PushListPosition(*This\Items())
                        ForEach *This\Items()
                          If \Text[2]\Len > 0 
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
                        Caret = \Text\Len-*This\Caret
                        String.s = \Text\String.s
                        DeleteElement(*This\Items(), 1)
                        SetText(*This\Canvas\Gadget, String.s, *This\Line[1])
                        *This\Caret = Len(\Text\String.s)-Caret
                        ;                         SelectElement(*This\Items(), *This\Line)
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
              
          EndSelect
        EndIf
        
        If Repaint
          ;\Text[3]\Change = Bool(Repaint =- 1)
          If Repaint =- 1
            SelectionText(*This) 
          EndIf
          
          If Repaint = 2
            *This\Text[0]\Change = Repaint
            \Text[1]\Change = Repaint
            \Text[2]\Change = Repaint
            \Text[3]\Change = Repaint
          EndIf
          ; *This\CaretLength = \CaretLength
          *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Protected Repaint
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
      
      If Not \vScroll\Buttons And Not \hScroll\Buttons
        Repaint | Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
      EndIf
    EndWith
    
    ProcedureReturn Repaint
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
        \Caret[1] =- 1
        \Line =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\NoButtons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\NoLines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 2
          Else
            \Text\MultiLine =- 1
          EndIf
          
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+5
            Else
              \Text\X = \fSize+5
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+1
            Else
              \Text\X = \fSize+1
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+6
            Else
              \Text\X = \fSize+6
              \Text\y = \fSize
            EndIf
          CompilerEndIf 
          
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
          
          \Color = Colors
          \Color\Fore[0] = 0
          ;\Color\Back[1] = \Color\Back[0]
          
          If \Text\Editable
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        If Bool(\flag\NoButtons = 0 Or \flag\NoLines=0)
          Scroll::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
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
  
  
  Procedure CallBacks()
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
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        ReDraw(*This)
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBacks())
      EndWith
    EndIf
    
    ProcedureReturn g
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
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #PB_Text_WordWrap|#PB_Flag_GridLines) : Editor::SetText(g, Text.s) 
    For a = 0 To 2
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::AddItem(g, a, "")
    For a = 4 To 6
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::SetFont(g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
                *E\Text\MultiLine !- 1
                If  *E\Text\MultiLine = 1
                  SetGadgetText(100,"~wrap")
                Else
                  SetGadgetText(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\Text\MultiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\Text\MultiLine = 1
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                    Else
                      EditorGadget(0, 8, 8, 306, 133) 
                    EndIf
                    
                    SetGadgetText(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8, 306, 276, 0,g)
                    
                    CompilerIf #PB_Compiler_Version =< 546
                      BindGadgetEvent(10, @SplitterCallBack())
                    CompilerEndIf
                    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                    
                    ; ;                     ImportC ""
                    ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                    ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                    ; ;                     EndImport
                    ; ;                     
                    ; ;                     Define TXNObject.i
                    ; ;                     Dim ControlTag.i(0)
                    ; ;                     Dim ControlData.i(0)
                    ; ;                     
                    ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                    ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                    ; ;                     
                    ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                    ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                    ; ;                     EndIf
                  CompilerCase #PB_OS_Windows
                    SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                CompilerEndSelect
                
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --------------------0------+-f8------------------
; EnableXP