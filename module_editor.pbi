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
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  
  ;- DECLARE
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare GetState(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i CountItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare SetState(*This.Widget_S, State.i)
  Declare GetAttribute(*This.Widget_S, Attribute.i)
  Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Repaint(*This.Widget_S)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module Editor
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  Procedure.i Repaint(*This.Widget_S)
    If *This
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
    Else
      ForEach List()
        PostEvent(#PB_Event_Widget, List()\Widget\Canvas\Window, List()\Widget, #PB_EventType_Create)
      Next
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
            
            If LastLine <> \Index[1] Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              ; Если выделяем сверху вниз, 
              ; если каректор находится в конце слова, 
              ; и позиция курсора неже половини высоты линии
              If (\Index[2] < \Index[1] And Item = \Index[1] And Position = len)
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
                 \Index[2] > \Index[1] Or ; Если выделяем снизу вверх
                 (\Index[2] = \Index[1] And Item = \Index[1] And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Index[2] < \Index[1] And                                     ; Если выделяем сверху вниз
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
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      ;Debug "7777    "+*This\Caret +" "+ *This\Caret[1] +" "+*This\Index[1] +" "+ *This\Index[2] +" "+ \Text\String
      
      If (Caret <> *This\Caret Or Line <> *This\Index[1] Or (*This\Caret[1] >= 0 And Caret1 <> *This\Caret[1]))
        \Text[2]\String.s = ""
        ; Debug 8888
        PushListPosition(*This\Items())
        If *This\Index[2] = *This\Index[1]
          If *This\Caret[1] = *This\Caret And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
            \Text[2]\Width = 0 
          EndIf
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Width[2] = 0 
            \Text[2]\Len = 0 
          EndIf
        ElseIf *This\Index[2] > *This\Index[1]
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Index[2] = *This\Index[1]
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
        ElseIf *This\Index[2] > *This\Index[1]
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
        
        Line = *This\Index[1]
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
  
  Procedure.i AddLine(*This.Widget_S, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \Text\Count Or Line < 0)
        Line = \Text\Count
      EndIf
      
      For i = 0 To \Text\Count
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \Text\Count = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  Procedure RemoveText(*This.Widget_S)
    ;ProcedureReturn
    
    With *This\Items()
      ;Debug *This\Index[1]
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
          \Items()\Text\Position - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position, 1)
          Caret + \Items()\Text\Position
          *This\Index[1] - 1
          
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] < \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret[1], 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
            Else
              \Items()\Text\Position - Caret
              Debug \Items()\Text\Position
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position, 1) 
              *This\Index[1] - 1
            EndIf
          EndIf
          Caret = \Items()\Text[2]\Len
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
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
          \Items()\Text\Position - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position, 1)
          Caret + \Items()\Text\Position
          *This\Index[1] - 1
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] > \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
              Caret = \Items()\Text[2]\Len
            Else
              \Items()\Text\Position - Caret
              Debug \Items()\Text\Position
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position, 1) 
              *This\Index[1] - 1
            EndIf
          EndIf
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
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
        If *This\Index[2] = *This\Index[1]
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
            ;If *This\Index[1] > *This\Index[2] 
            RemoveText(*This)
            ;EndIf
            
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\Index[1])
            EndIf
          EndIf
          
          ; Выделили сверх вниз
          If *This\Index[1] > *This\Index[2] 
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
          ElseIf *This\Index[2] > *This\Index[1] 
            *This\Index[2] = *This\Index[1] 
            
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
          
          
          If *This\Index[2]>=0 And *This\Index[2]<ListSize(*This\Items())
            ;If *This\Index[1] > *This\Index[2]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\Index[2])
            
            If Not *This\Caret
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            
            ; Выделили сверху вниз
            If *This\Index[1] > *This\Index[2]
              *This\Index[1] = *This\Index[2]
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
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
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
      If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2]) 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToLeft(*This.Widget_S) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Caret[1] > \Caret
          Swap \Caret[1], \Caret
        ElseIf \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelectionReset(*This)
          \Index[1] = \Index[2]
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
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Caret, \Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[2] = \Index[1] And 
               \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelectionReset(*This)
          \Index[1] = \Index[2]
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
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Index[2] <> \Index[1] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        If SelectElement(\Items(), \Index[2]) ;: Debug \Items()\Text\String.s
          String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf   
        
        If SelectElement(\Items(), \Index[1]) ;: Debug "  "+\Items()\Text\String.s
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        
      Else
        String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$ +
                   \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
      EndIf
      
      \Index[2] + 1
      \Index[1] = \Index[2]
      
      \Caret = 0
      \Caret[1] = \Caret
      
      \Text\String.s = String.s
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      If SelectElement(\items(), \index[1]) And Not \Scroll\v\hide
        CompilerIf Defined(Scroll, #PB_Module)
          Scroll::SetState(\Scroll\v, ((\items()\y-\text\y)-(\Height[2]-\items()\height)))
        CompilerEndIf
      EndIf
      
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*This.Widget_S)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s, String.s
    
    With *This
      If \Canvas\Input
        Chr.s = Text::Make(*This, Chr(\Canvas\Input))
        
        If Chr.s
          If \Index[1] <> \Index[2] ; Это значить строки выделени
            If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
            
            If SelectElement(\Items(), \Index[2]) ;: Debug \Items()\Text\String.s
              String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + Chr.s
              \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
              \Caret = \Items()\Text[1]\Len
            EndIf   
            
            If SelectElement(\Items(), \Index[1]) ;: Debug "  "+\Items()\Text\String.s
              String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
              \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
            EndIf
            
            \Index[1] = \Index[2]
          Else
            If \Items()\Text[2]\Len 
              If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
            EndIf
            
            \Items()\Text\String.s = \Items()\Text[1]\String.s + Chr.s + \Items()\Text[3]\String.s
            String.s = InsertString(\Text\String.s, Chr.s, \Items()\Text\Position+\Caret + 1)
          EndIf
          
          \Caret + 1 
          \Caret[1] = \Caret 
          \Text\String.s = String.s
          \Text\Len = Len(\Text\String.s)
          \Text\Change =- 1
          
          SelectElement(\items(), \index[2]) 
      
        Else
          \Default = *This
        EndIf
        
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure _ToBack(*This.Widget_S)
    Protected Repaint, String.s 
    ;ProcedureReturn Text::ToReturn(*This,"")
    
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
        Debug " "+ListIndex(\Items())+" "+\Items()\Text\Position+" "+\Items()\Text\String.s; 
        \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Position+\Caret - 1) + Mid(\Text\String.s[1],  \Items()\Text\Position+\Caret + 1)
        \Text\String.s = Left(\Text\String.s, \Items()\Text\Position+\Caret - 1) + Mid(\Text\String.s,  \Items()\Text\Position+\Caret + 1)
        \Caret - 1 
        \Text\Change =- 1
      Else
        ; Если дошли до начала строки то 
        ; переходим в конец предыдущего итема
        If \Index[2] > 0 
          \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
          
          ToUp(*This)
          
          \Caret = \Items()\Text\Len 
          \Text\Change =- 1
        EndIf
        
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Caret[1] = \Caret 
        
              
        PushListPosition(\items())
        If SelectElement(\items(), \index[2]) And Not \Scroll\v\hide
          Scroll::SetState(\Scroll\v, ((\items()\y-\text\y)-(\Height[2]-\items()\height))) ; в конце
        EndIf
        PopListPosition(\items())
        
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToBack(*This.Widget_S, Chr.s="") ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Index[2] <> \Index[1] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        If SelectElement(\Items(), \Index[2]) ;: Debug \Items()\Text\String.s
          String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Caret = \Items()\Text[1]\Len
        EndIf   
        
        If SelectElement(\Items(), \Index[1]) ;: Debug "  "+\Items()\Text\String.s
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        
        \Index[1] = \Index[2]
        \Text\Change = 1
        
      ElseIf \Caret[1] > 0 
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret - 1)
        \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
        \Items()\Text[1]\Change = 1
        
        \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
        String.s = Left(\Text\String.s, \Items()\Text\Position+\Caret - 1) + Mid(\Text\String.s,  \Items()\Text\Position+\Caret + 1)
        \Text\Change = 1
        \Caret - 1
        
      Else
      ; Если дошли до начала строки то 
        ; переходим в конец предыдущего итема
        If \Index[2] > 0 
          String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
          
          ToUp(*This)
          
          \Caret = \Items()\Text\Len 
          \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret)
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          \Items()\Text[1]\Change = 1
          \Text\Change = 1
        
        EndIf
      EndIf
      
      If \Text\Change
        \Caret[1] = \Caret
        \Text\String.s = String.s
        \Text\Len = Len(\Text\String.s)
        
        If SelectElement(\items(), \index[1]) And Not \Scroll\v\hide
          CompilerIf Defined(Scroll, #PB_Module)
           ; Scroll::SetState(\Scroll\v, ((\items()\y-\text\y)-(\Height[2]-\items()\height)))
            Scroll::SetState(\Scroll\v, (\items()\y-(Scroll::Y(\Scroll\h)-\items()\height)))
          CompilerEndIf
        EndIf
        
        Repaint = #True
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
          
          If *This\Caret = Len(\Text\String.s) : *This\Index[2]+1
            If *This\Index[2]>=0 And *This\Index[2]<ListSize(*This\Items())
              PushListPosition(*This\Items())
              SelectElement(*This\Items(), *This\Index[2])
              String.s = \Text\String.s
              DeleteElement(*This\Items(), 1)
              PopListPosition(*This\Items())
              \Text\String.s + String.s 
              *This\Index[2] - 1
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
  
  ;-
  ;- PUBLIC
  Procedure SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Index[1] = \Items()\Index
        \Caret = State
        \Caret[1] = \Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected String.s
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Text::Redraw(*This, \Canvas\Gadget)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Canvas\Gadget
          SetActiveGadget(\Canvas\Gadget)
        EndIf
        
        If State =- 1
          \Index[1] = \Text\Count - 1
          LastElement(\Items())
          \Caret = \Items()\Text\Len
        Else
          \Index[1] = CountString(Left(String, State), #LF$)
          SelectElement(\Items(), \Index[1])
          \Caret = State-\Items()\Text\Position
        EndIf
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Caret)
        \Items()\Text[1]\Change = 1
        \Caret[1] = \Caret
        
        \Items()\Index[1] = \Items()\Index 
        ;PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
        Scroll::SetState(\Scroll\v, ((\Index[1] * \Text\Height)-\Scroll\v\Height) + \Text\Height) : \Scroll\Y =- \Scroll\v\page\Pos
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index
          Result = \Items()\Text\Position + \Caret
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Text::ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn Text::CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i)
    Text::RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    ;     If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          If Item = 0
            First = *Item
          EndIf
          
          If subLevel
            If sublevel>Item
              sublevel=Item
            EndIf
            
            PushListPosition(\Items())
            While PreviousElement(\Items()) 
              If subLevel = \Items()\subLevel
                adress = \Items()\handle
                Break
              ElseIf subLevel > \Items()\subLevel
                adress = @\Items()
                Break
              EndIf
            Wend 
            If adress
              ChangeCurrentElement(\Items(), adress)
              If subLevel > \Items()\subLevel
                sublevel = \Items()\sublevel + 1
                \Items()\handle[1] = *Item
                \Items()\childrens + 1
                \Items()\collapsed = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            \Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          \Items()\handle = adress
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          \Items()\focus =- 1
          \Items()\lostfocus =- 1
          \Items()\text\change = 1
            
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\handle = ImageID(Image)
            \Items()\Image\handle[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          Text::AddLine(*This, Item.i, Text.s)
          
;           \Items()\Color = Colors
;           \Items()\Color\State = 1
;           \Items()\Color\Fore[0] = 0 
;           \Items()\Color\Fore[1] = 0
;           \Items()\Color\Fore[2] = 0
       
          If Item = 0
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    
    If Text::SetText(*This, Text.s) 
      Text::ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    
    If Text::SetFont(*This, FontID)
      Text::ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  ;-
  Procedure.i Editable(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
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
          If \items()\Text\Numeric
            \items()\Text\String.s[1]=\items()\Text\String.s 
          EndIf
          Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Canvas\Key
            Case #PB_Shortcut_Home : \items()\Text[2]\String.s = "" : \items()\Text[2]\Len = 0 : \Caret = 0 : \Caret[1] = \Caret : Repaint =- 1
            Case #PB_Shortcut_End : \items()\Text[2]\String.s = "" : \items()\Text[2]\Len = 0 : \Caret = \items()\Text\Len : \Caret[1] = \Caret : Repaint =- 1 
              
            Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
            Case #PB_Shortcut_Return : Repaint = Text::ToReturn(*This) 
            Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
              
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If ((\Canvas\Key[1] & #PB_Canvas_Control) Or (\Canvas\Key[1] & #PB_Canvas_Command)) 
                SetClipboardText(Copy(*This))
                
                If \Canvas\Key = #PB_Shortcut_X
                  Cut(*This)
                  
                  \Caret[1] = \Caret
                  Repaint = #True 
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And ((\Canvas\Key[1] & #PB_Canvas_Control) Or (\Canvas\Key[1] & #PB_Canvas_Command))
                Protected ClipboardText.s = Trim(GetClipboardText(), #CR$)
                
                If ClipboardText.s
                  If \items()\Text[2]\Len > 0
                    RemoveText(*This)
                    
                    If \items()\Text[2]\Len = \items()\Text\Len
                      ;*This\Index[2] = *This\Index[1]
                      ClipboardText.s = Trim(ClipboardText.s, #LF$)
                    EndIf
                    ;                         
                    PushListPosition(\Items())
                    ForEach \Items()
                      If \items()\Text[2]\Len > 0 
                        If \items()\Text[2]\Len = \items()\Text\Len
                          DeleteElement(\Items(), 1) 
                        Else
                          RemoveText(*This)
                        EndIf
                      EndIf
                    Next
                    PopListPosition(\Items())
                  EndIf
                  
                  Select #True
                    Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                    Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                    Case \Text\Numeric 
                      If Val(ClipboardText.s)
                        ClipboardText.s = Str(Val(ClipboardText.s))
                      EndIf
                  EndSelect
                  
                  \Text\String.s = InsertString( \Text\String.s, ClipboardText.s, \Caret + 1)
                  
                  If CountString(\Text\String.s, #LF$)
                    Caret = \Text\Len-\Caret
                    String.s = \Text\String.s
                    DeleteElement(\Items(), 1)
                    SetText(\Canvas\Gadget, String.s, \Index[2])
                    \Caret = Len(\Text\String.s)-Caret
                    ;                         SelectElement(*This\Items(), *This\Index[1])
                    ;                        *This\Caret = 0
                  Else
                    \Caret + Len(ClipboardText.s)
                  EndIf
                  
                  \Caret[1] = \Caret
                  \Text\Len = Len(\Text\String.s)
                  
                  Repaint = #True
                EndIf
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint
        ;\Text[3]\Change = Bool(Repaint =- 1)
        If Repaint =- 1
          SelectionText(*This) 
        EndIf
        
        If Repaint = 2
          \Text[0]\Change = Repaint
          \items()\Text[1]\Change = Repaint
          \items()\Text[2]\Change = Repaint
          \items()\Text[3]\Change = Repaint
        EndIf
        ; *This\CaretLength = \CaretLength
        \Text[2]\String.s[1] = \items()\Text[2]\String.s[1]
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i _Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
    EndWith
    
    If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LeftClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftClick)
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                \index[1] =- 1
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\items()) 
                ForEach \items()
                  If \index[1] = \items()\index 
                    \Index[2] = \index[1]
                    
                    If \Flag\ClickSelect
                      \items()\Color\State ! 2
                    Else
                      \items()\Color\State = 2
                    EndIf
                    
                    ; \items()\Focus = \items()\index 
                  ElseIf ((Not \Flag\ClickSelect And \items()\Focus = \items()\index) Or \Flag\MultiSelect) And Not Control
                    \items()\index[1] =- 1
                    \items()\Color\State = 1
                    \items()\Focus =- 1
                  EndIf
                Next
                PopListPosition(\items()) 
                Repaint = 1
                
              Case #PB_EventType_LeftButtonUp
                PushListPosition(\items()) 
                ForEach \items()
                  If \index[1] = \items()\index 
                    \items()\Focus = \items()\index 
                  Else
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 1
                    EndIf
                  EndIf
                Next
                PopListPosition(\items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Y < \Y Or \Canvas\Mouse\X > Scroll::X(\Scroll\v)
                  Item.i =- 1
                ElseIf \Text\Height
                  Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \index[1] <> Item And Item =< ListSize(\items())
                  If isItem(\index[1], \items()) 
                    If \index[1] <> ListIndex(\items())
                      SelectElement(\items(), \index[1]) 
                    EndIf
                    
                    If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                      If (\Flag\MultiSelect And Not Control)
                        \items()\Color\State = 2
                      ElseIf Not \Flag\ClickSelect
                        \items()\Color\State = 1
                      EndIf
                    EndIf
                  EndIf
                  
                  If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton And itemSelect(Item, \items())
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 2
                    ElseIf Not \Flag\ClickSelect And (\Flag\MultiSelect And Not Control)
                      \items()\index[1] = \items()\index
                      \items()\Color\State = 2
                    EndIf
                  EndIf
                  
                  \index[1] = Item
                  Repaint = #True
                  
                  If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton
                    If (\Flag\MultiSelect And Not Control)
                      PushListPosition(\items()) 
                      ForEach \items()
                        If  Not \items()\Hide
                          If ((\Index[2] =< \index[1] And \Index[2] =< \items()\index And \index[1] >= \items()\index) Or
                              (\Index[2] >= \index[1] And \Index[2] >= \items()\index And \index[1] =< \items()\index)) 
                            If \items()\index[1] <> \items()\index
                              \items()\index[1] = \items()\index
                              \items()\Color\State = 2
                            EndIf
                          Else
                            \items()\index[1] =- 1
                            \items()\Color\State = 1
                            \items()\Focus =- 1
                          EndIf
                        EndIf
                      Next
                      PopListPosition(\items()) 
                    EndIf
                    
                  EndIf
                EndIf
                
              Default
                itemSelect(\Index[2], \items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
          If *Focus = *This
            Repaint | Editable(*This.Widget_S, EventType.i)
          EndIf
        EndWith
      EndIf
    Else
      *This\index[1] =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      
      If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
        If ListSize(*This\items())
          If Not \Hide And Not \Disable And \Interact
            ; Get line & caret position
            If \Canvas\Mouse\buttons
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
                  \Index[1] = ListIndex(*This\Items()) 
                  \Index[2] = Item
                  
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Index[2] <> ListIndex(\Items())
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
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                  
                  If \Index[1] <> Item And Item =< ListSize(\Items())
                    If isItem(\Index[1], \Items()) 
                      If \Index[1] <> ListIndex(\Items())
                        SelectElement(\Items(), \Index[1]) 
                      EndIf
                      
                      If \Index[1] > Item
                        \Caret = 0
                      Else
                        \Caret = \Items()\Text\Len
                      EndIf
                      
                      SelectionText(*This)
                    EndIf
                    
                    \Index[1] = Item
                  EndIf
                  
                  If isItem(Item, \Items()) 
                    \Caret = Caret(*This, Item) 
                    SelectionText(*This)
                  EndIf
                  
                  Repaint = #True
                  
                  Protected SelectionLen
                  PushListPosition(\Items()) 
                  ForEach \Items()
                    If \Index[1] = \Items()\Index Or \Index[2] = \Items()\Index
                      
                    ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                            (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
                      
                      If \Items()\Text[2]\String <> \Items()\Text\String
                        \Items()\Text[2]\Len = \Items()\Text\Len
                        If Not \Items()\Text\Len : \Items()\Text[2]\Len = 1 : EndIf
                        \Items()\Text[1]\String = "" : \Items()\Text[1]\Len = 0 : \Items()\Text[1]\Change = 1
                        \Items()\Text[3]\String = "" : \Items()\Text[3]\Len = 0 : \Items()\Text[3]\Change = 1
                        \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                      EndIf
                      
                      SelectionLen=Bool(Not \Flag\FullSelection)*7
                      ; \Items()\Text[2]\X = 0;\Items()\Text\X+\Items()\Text\Width
                      
                      If Not SelectionLen
                        \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                      Else
                        \Items()\Text[2]\Width[2] = SelectionLen
                      EndIf
                      
                      ;\Items()\Index[1] = \Items()\Index
                    Else  
                      ;\Items()\Index[1] =- 1
                      \Items()\Text[2]\String =  "" : \Items()\Text[2]\Len = 0 : \Items()\Text[2]\Change = 1
                    EndIf
                  Next
                  PopListPosition(\Items()) 
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
            Repaint | Editable(*This, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure Widget_CallBack()
    Protected String.s, *This.Widget_S = EventGadget()
    
    With *This
      Select EventType() 
        Case #PB_EventType_Create
          SetState(*This, #PB_Ignore)
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
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
        
          \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 2
          Else
            \Text\MultiLine =- 1
          EndIf
          
          \Flag\MultiSelect = 1
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+4
          Else
            \Text\X = \fSize+4
            \Text\y = \fSize
          EndIf
          
          
          \Color = Colors
          \Color\Fore[0] = 0
          
          \Row\color\alpha = 255
          \Row\Color = Colors
          \Row\Color\Fore[0] = 0
          \Row\Color\Fore[1] = 0
          \Row\Color\Fore[2] = 0
          \Row\Color\Back[0] = \Row\Color\Back[1]
          \Row\Color\Frame[0] = \Row\Color\Frame[1]
          ;\Color\Back[1] = \Color\Back[0]
          
          If \Text\Editable
            \Color\Back[0] = $FFFFFFFF 
          Else
            \Color\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\Scroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        Scroll::Widget(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        
        Resize(*This, X,Y,Width,Height)
     EndWith
      
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
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
      BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                                                                                                                 ;Debug "resize "+GadgetWidth(\Canvas\Gadget) +" "+ GadgetHeight(\Canvas\Gadget)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        Text::ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
        BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
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
    
    EditorGadget(0, 8, 8, 306, 233, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Text_WordWrap|#PB_Flag_GridLines);|#PB_Text_Right) 
    *w=GetGadgetData(g)
    
    Editor::SetText(*w, Text.s) 
    
    For a = 0 To 2
      Editor::AddItem(*w, a, "Line "+Str(a))
    Next
    Editor::AddItem(*w, a, "")
    For a = 4 To 6
      Editor::AddItem(*w, a, "Line "+Str(a))
    Next
    Editor::SetFont(*w, FontID(0))
    
    Editor::Repaint(*w)
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
                Editor::RemoveItem(g, 5)
                RemoveGadgetItem(0,5)
                
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
; Folding = ------------------------F---ff-------4-8---
; EnableXP