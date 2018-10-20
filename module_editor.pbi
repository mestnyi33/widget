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
  
  Procedure item_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
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
            *This\focus = 0
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
                
                \Items()\checked ! 1
                *This\Change = 1
              EndIf
              
              If (Not \flag&#NoButtons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
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
                ; Get entered item only on image and text 
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
                    *This\Item = \Items()\Item
                    *This\Change = 1
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Item
              EndIf
              
            EndIf
            
            If \Items()\from <> \Items()\Item 
              \Items()\from = \Items()\Item
              *This\from = \Items()\from
            ;  *This\text = \Items()\text 
            EndIf
            
            adress = @\Items()
            
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
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
      Debug *This\Line
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
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      If (Caret <> *This\Caret Or Caret1 <> *This\Caret[1] Or Line <> *This\Line)
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
        ElseIf *This\Line[1] > *This\Line
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
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Change = #True
        EndIf
        
        Line = *This\Line
        Caret = *This\Caret
        Caret1 = *This\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget_S) ; Ok
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
  
  
  Procedure Cut(*This.Widget_S)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
    
    With *This\Items()
      If ListSize(*This\Items()) 
        ;If \Text[2]\Len
        If *This\Line[1] = *This\Line
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
          ElseIf *This\Line[1] > *This\Line 
            *This\Line[1] = *This\Line 
            
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
      If String.s And Not *This\Caret
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.b Back(*This.Widget_S)
    Protected Repaint.b, String.s
    
    With *This\Items()
      If ListSize(*This\Items()) And (*This\Caret = 0 And *This\Caret = *This\Caret[1]) And ListIndex(*This\Items())  
        Debug "Back"
        
        If Not \Text[2]\Len
          If *This\Line[1] > *This\Line : *This\Line[1] = *This\Line : Else : *This\Line[1] - 1 : EndIf
          If (*This\Line[1]>=0 And *This\Line[1]<ListSize(*This\Items()))
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            SelectElement(*This\Items(), *This\Line[1])
            
            If *This\Caret = *This\Caret[1]
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            If *This\Line > *This\Line[1]
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
        
        SelectElement(*This\Items(), *This\Line[1])
        
        *This\Line = *This\Line[1]
        Repaint = #True
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure SelectUpLine(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Line[1] > 0
        \Line[1] - 1
        SelectElement(\Items(), \Line[1])
        \Line = \Line[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure SelectDownLine(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Line[1] < ListSize(\Items()) - 1 
        \Line[1] + 1
        SelectElement(\Items(), \Line[1]) 
        \Line = \Line[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure CaretToLeft(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Caret[1] >= 0 
        If \Items()\Text[2]\Len
          If \Caret > \Caret[1] 
            Swap \Caret, \Caret[1]
          EndIf      
        Else         
          \Caret - 1 
        EndIf
        
        If \Caret < 0
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          SelectUpLine(*This)
          \Caret = \Items()\Text\Len
        EndIf
        
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure CaretToRight(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Caret[1] =< \Items()\Text\Len
        If \Items()\Text[2]\Len 
          If \Caret > \Caret[1] 
            Swap \Caret, \Caret[1]
          EndIf
        Else
          *This\Caret[1] + 1 
        EndIf
        
        If \Caret[1] > \Items()\Text\Len 
          ; Если дошли в конец строки то
          ; переходим на начало следующего итема
          SelectDownLine(*This)
          \Caret[1] = 0
        EndIf
        
        \Caret = \Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  Procedure EditableCallBack(*This.Widget_S, EventType.i)
    Static MoveX, MoveY
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint.b, Item.i, String.s, StartDrawing, Update_Text_Selected
    
     If *This
      With *This
        If Not \Hide And Not \Disable And \Interact ; And Widget <> Canvas And CanvasModifiers
          ; Get line & caret position
          If \Canvas\Mouse\Buttons 
            Item.i = (((\Canvas\Mouse\Y-\Text\Y)-\Scroll\Y) / \Text\Height)  ; item_from(*This, \Canvas\Mouse\X, \Canvas\Mouse\Y) ; 
          EndIf
          
          Select EventType 
            Case #PB_EventType_LeftButtonDown
              MoveX = \Canvas\Mouse\X 
              MoveY = \Canvas\Mouse\Y
              
              If \Items()\Text[2]\Len
                \Text[2]\Len = 1
              Else
                \Caret = Caret(*This, Item) 
                \Line = ListIndex(*This\Items()) 
                \Line[1] = Item
              EndIf
              
            Case #PB_EventType_LeftButtonUp
              If \Caret = \Caret[1] ; And \Line = \Line[1] 
;                 If Not \Drag
                  ; Сбрасываем все виделения.
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Items()\Text[2]\Len <> 0
                      \Items()\Text[2]\Len = 0 
                    EndIf
                  Next
                  PopListPosition(\Items())
                  Repaint = 1
;                 EndIf
                  \Text[2]\Len = 0
;                 \Drag = 0
              EndIf
              
            Case #PB_EventType_MouseMove  
              If \Canvas\Mouse\Buttons 
                If \Drag = 0 And (Abs((\Canvas\Mouse\X-MoveX)+(\Canvas\Mouse\Y-MoveY)) >= 6) : \Drag=1
                  Debug "DragStart";PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_DragStart)
                EndIf
                
                
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
                  
                  \Caret = Caret(*This, Item) 
                  SelectionText(*This)
                EndIf
              EndIf
              
            Default
              itemSelect(\Line[1], \Items())
          EndSelect
        EndIf
      EndWith    
    EndIf
    
    
    If *This
      With *This\Items()
        Select EventType
          Case #PB_EventType_MouseEnter
            SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
            
          Case #PB_EventType_LostFocus : Repaint = #True
            If Bool(*This\Type <> #PB_GadgetType_Editor)
              ; StringGadget
              \Text[2]\Len = 0 ; Убыраем выделение
            EndIf
            *This\Caret[1] =- 1 ; Прячем коректор
            
          Case #PB_EventType_Focus : Repaint = #True
            *This\Caret[1] = *This\Caret ; Показываем коректор
            
          Case #PB_EventType_LeftDoubleClick 
            DoubleClickCaret = *This\Caret
            SelectionLimits(*This)
            SelectionText(*This) 
            Repaint = #True
            
            *This\Caret = Caret(*This, *This\Line[1]) 
            
          Case #PB_EventType_LeftButtonDown
            *This\Caret[1] = *This\Caret
            
            If \Text\Numeric 
              \Text\String.s[1] = \Text\String.s 
            EndIf
            
            If *This\Caret = DoubleClickCaret
              DoubleClickCaret =- 1
              *This\Caret[1] = \Text\Len
              *This\Caret = 0
            EndIf 
            
            SelectionText(*This)
            Repaint = #True
            
          Case #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
              ;                 *This\Caret = Caret(*This)
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
                
              Case #PB_Shortcut_Up ; Ok
                Repaint = SelectUpLine(*This)
               
              Case #PB_Shortcut_Left ; Ok
                Repaint = CaretToLeft(*This)
                           
              Case #PB_Shortcut_Right 
                Repaint = CaretToRight(*This)
                
              Case #PB_Shortcut_Down 
                Repaint = SelectDownLine(*This)
                
              Case #PB_Shortcut_Return
                Debug "Return "+ListIndex(*This\Items())
                If *This\Caret ;: *This\Line[1]+1
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
                
                *This\Line[1] = AddItem(*This\Canvas\Gadget, *This\Line[1]+1, String.s+#LF$)
                *This\Caret = 0
                *This\Text\Len = Len(\Text\String.s)
                *This\Caret[1] = *This\Caret
                
                ;                   If Not *This\Caret
                ;                     SelectElement(*This\Items(), *This\Line[1])
                ;                   ; *This\Line[1] + 1  
                ;                   EndIf
                
                Scroll::SetState(*This\vScroll, *This\vScroll\Max)
                Repaint = #True
                
              Case #PB_Shortcut_Back 
                Repaint = Back(*This)
                If Not Repaint
                  Cut(*This)
                  
                  *This\Caret[1] = *This\Caret
                  \Text\Len = Len(\Text\String.s)
                  
                  Repaint = 2
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
                  Protected Caret, ClipboardText.s = Trim(GetClipboardText(), #CR$)
                  
                  If ClipboardText.s
                    If \Text[2]\Len
                      RemoveText(*This)
                      
                      If \Text[2]\Len = \Text\Len
                        ;*This\Line[1] = *This\Line
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
        
        If Repaint
          \Text[3]\Change = Bool(Repaint =- 1)
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
  
  Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
    Protected Drawing, Wrap, String.s, StringWidth
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
              Width = \Height[1]-\Text\X*2
              Height = \Width[1]-\Text\y*2
            Else
              Width = \Width[1]-\Text\X*2
              Height = \Height[1]-\Text\y*2
            EndIf
            
            Wrap = Bool(\Text\MultiLine Or \Text\WordWrap)
            If Wrap
              \Text\String.s[2] = Text::Wrap(\Text\String.s, Width-(\Image\Width+\Image\Width/2), Bool(\Text\WordWrap)-Bool(\Text\MultiLine))
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
                  
                  Text_Y+\Text\Height 
                Next
              Else
                For IT = 1 To \Text\CountString
                  String = StringField(\Text\String.s[2], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
                  \Items()\x = \X[1]+\Text\X
                  \Items()\y = \Y[1]+\Text\Y+Text_Y
                  \Items()\Width = Width
                  \Items()\Height = \Text\Height
                  \Items()\Item = ListIndex(\Items())
                  
                  \Items()\Text\x = (\Image\Width+\Image\Width/2)+\X[1]+\Text\X+Text_X
                  \Items()\Text\y = \Y[1]+\Text\Y+Text_Y
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  \Image\X = \Items()\Text\x-(\Image\Width+\Image\Width/2)
                  \Image\Y = \Y[1]+\Text\Y +(Height-\Image\Height)/2
                  
                  Text_Y+\Text\Height 
                Next
              EndIf
            EndIf
          EndIf
          
          If \Text\Change
            Debug "\Text\Change "+\Text\Change
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
          *This\Scroll\Height = 0
          *This\Scroll\Width = 0
          
          Protected back_color=$FFFFFF, item_alpha = 128
          Protected BackColor = ($E89C3D&back_color)|item_alpha<<24
          
          PushListPosition(*This\Items())
          ForEach *This\Items()
            If \Hide : Continue : EndIf
            
            Drawing = Bool(\y+\height>*This\y[2] And \y<*This\height[2])
            If Drawing
              ; Draw selections
              If \Item=*This\Line
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x+1,\y+1,\width-2,\height-2, ($FCEADA&back_color)|item_alpha<<24)  ; ((Color & $FFFFFF) << 32) $FCEADA $00A5FF $CBC0FF
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x,\y,\width,\height, ($FFC288&back_color)|item_alpha<<24) ; $FFC288 $0045FF
              EndIf
              
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
                
                If \Text[1]\Change Or \Text[2]\Change Or \Text[3]\Change
                  Debug "   "+ \Text[1]\Change +" "+ \Text[2]\Change +" "+ \Text[3]\Change
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
                  \Text[3]\Width = TextWidth(Left(\Text\String.s, *This\Caret))
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
                
                If *This\Text\Editable And \Text[2]\Len ; And #PB_Compiler_OS <> #PB_OS_MacOS
                  
                  
                  If \Text[2]\String.s
                    If *This\Line[1] = *This\Line And *This\Caret[1]>*This\Caret
                      \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    Else
                      \Text[2]\X = \Text\X+\Text[1]\Width
                      \Text[3]\X = \Text[2]\X+\Text[2]\Width
                    EndIf
                  EndIf
                  
                  If \Text\String.s = \Text[1]\String.s+\Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Default)
                    ; Box((\Text[2]\X+*This\Scroll\X), \Text\Y, \Width-((\Text[2]\X-\Text\X)+*This\Scroll\X), \Text\Height, $D77800)
                    Box((\Text[2]\X+*This\Scroll\X), \Text\Y, \Text[2]\Width, \Text\Height, $D77800)
                    
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText((\Text\X+*This\Scroll\X), \Text\Y, \Text\String.s, $FFFFFF)
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text\X+*This\Scroll\X), \Text\Y, \Text[1]\String.s, $0B0B0B)
                    EndIf
                    
                  Else
                    If *This\Line[1] = *This\Line And *This\Caret[1] > *This\Caret
                      If \Text[3]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text[3]\X+*This\Scroll\X), \Text\Y, \Text[3]\String.s, $0B0B0B)
                      EndIf
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Default)
                        Box((\Text[2]\X+*This\Scroll\X), \Text\Y, \Text[2]\Width, \Text\Height, $D77800)
                        
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text\X+*This\Scroll\X), \Text\Y, \Text[1]\String.s+\Text[2]\String.s, $FFFFFF)
                      EndIf
                      
                      If \Text[1]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text\X+*This\Scroll\X), \Text\Y, \Text[1]\String.s, $0B0B0B)
                      EndIf
                    Else
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text\X+*This\Scroll\X), \Text\Y, \Text\String.s, $0B0B0B)
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Default)
                        DrawText((\Text[2]\X+*This\Scroll\X), \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
                      EndIf
                    EndIf
                  EndIf
                  
                  ; ; ;                   If \Text[1]\String.s
                  ; ; ;                     DrawingMode(#PB_2DDrawing_Transparent)
                  ; ; ;                     DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  ; ; ;                   EndIf
                  ; ; ;                   If \Text[2]\String.s
                  ; ; ;                     DrawingMode(#PB_2DDrawing_Default)
                  ; ; ;                     ;                   If \Text[0]\String.s = \Text[1]\String.s+\Text[2]\String.s
                  ; ; ;                     ;                     Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y,*This\width[2]-\Text[2]\X, \Text[0]\Height, $DE9541)
                  ; ; ;                     ;                   Else
                  ; ; ;                     Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $DE9541)
                  ; ; ;                     ;                   EndIf
                  ; ; ;                     DrawingMode(#PB_2DDrawing_Transparent)
                  ; ; ;                     DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, $FFFFFF)
                  ; ; ;                   EndIf
                  ; ; ;                   If \Text[3]\String.s
                  ; ; ;                     DrawingMode(#PB_2DDrawing_Transparent)
                  ; ; ;                     DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text[0]\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  ; ; ;                   EndIf
                Else
                  If \Text[2]\Len
                    DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
                    If \Text\String.s = (\Text[1]\String.s+\Text[2]\String.s)
                      Box((\Text[2]\X+*This\Scroll\X), \Text\Y, \Width-((\Text[2]\X-\Text\X)+*This\Scroll\X), \Text\Height, ($FADBB3));&back_color)|item_alpha<<24)
                    Else
                      Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, ($FADBB3));&back_color)|item_alpha<<24)
                    EndIf
                  EndIf
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
              EndIf
            EndIf
            
            If Not Wrap And *This\Scroll\Width<\Text\Width
              *This\Scroll\Width=\Text\Width
            EndIf
            
            *This\Scroll\Height + \Text\Height
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Text\Editable And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] : DrawingMode(#PB_2DDrawing_XOr)             
            Line(((\Text[0]\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
          EndIf
          
          If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And
             Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
            Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ; *This\vScroll\Page\ScrollStep = height
          EndIf
          If Not Wrap And *This\hScroll\Page\Length And *This\hScroll\Max<>*This\Scroll\Width And
             Scroll::SetAttribute(*This\hScroll, #PB_ScrollBar_Maximum, *This\Scroll\Width)
            Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          Scroll::Draw(*This\vScroll)
          If Not Wrap
            Scroll::Draw(*This\hScroll)
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
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Text::Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
          Scroll::Resizes(*This\vScroll, *This\hScroll, *This\x[2]+1,*This\Y[2]+1,*This\Width[2]-2,*This\Height[2]-2)
          Repaint = *This\Resize
          
      EndSelect
      
      Repaint | Scroll::CallBack(*This\vScroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      Repaint | Scroll::CallBack(*This\hScroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      
      If Not *This\vScroll\Buttons And Not *This\hScroll\Buttons
        Repaint | EditableCallBack(*This, EventType())
      EndIf
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
    
    ; Draw(*This)
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
        
        \fSize = Bool(Not Flag&#PB_Widget_BorderLess)+1
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
            \Text\y = \bSize
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
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        If Not Bool(\Text\WordWrap Or \Text\MultiLine)
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
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        ReDraw(*This)
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBack())
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
; Folding = -v-----------f8-v0v----B--8+--Hg-----v--
; EnableXP