;-
DeclareModule String
  EnableExplicit
  
  EnumerationBinary
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      #PB_Text_Right
      #PB_Text_Center
      #PB_Text_Border
    CompilerElse ; If #PB_Compiler_OS = #PB_OS_Windows
      #PB_Text_Center
      #PB_Text_Right
    CompilerEndIf
    
    #PB_Text_Bottom
    
    #PB_Text_UpperCase
    #PB_Text_LowerCase
    #PB_Text_Password
    
    #PB_Text_Middle 
    #PB_Text_MultiLine 
  EndEnumeration
  
  #PB_Text_ReadOnly = 256 ; #PB_String_ReadOnly
  #PB_Text_Numeric = 512  ; #PB_String_Numeric
  #PB_Text_WordWrap = 1024; #PB_Editor_WordWrap
  
  ;   Debug #PB_Text_Center
  ;   Debug #PB_Text_Right
  ;   Debug #PB_Text_Bottom
  ;   
  ;   Debug #PB_Text_UpperCase
  ;   Debug #PB_Text_LowerCase
  ;   Debug #PB_Text_Password
  ;   
  ;   Debug #PB_Text_Middle 
  ;   Debug #PB_Text_MultiLine 
  ;   
  ;   Debug #PB_Text_ReadOnly
  ;   Debug #PB_Text_Numeric 
  
  
  
  ;- STRUCTURE
  Structure Coordinate
    y.l[3]
    x.l[3]
    Height.l[3]
    Width.l[3]
  EndStructure
  
  Structure Mouse
    X.l
    Y.l
    Buttons.l
    At.i
  EndStructure
  
  Structure Canvas
    Mouse.Mouse
    Gadget.l
    Window.l
    
    Input.c
    Key.l[2]
    
  EndStructure
  
  Structure Text Extends Coordinate
    ;     Char.c
    Len.l
    String.s[2]
    Change.b
    
    Align.l
    
    XAlign.b
    YAlign.b
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    Wrap.b
    MultiLine.b
    
    Caret.l[2] ; 0 = Pos ; 1 = PosFixed
    
    Mode.l
  EndStructure
  
  Structure Widget Extends Coordinate
    FontID.i
    Canvas.Canvas
    
    Text.Text[4]
    ImageID.l[3]
    Color.l[3]
    ;CaretLength.l
    
    Image.Coordinate
    
    fSize.l
    bSize.l
    Hide.b[2]
    Disable.b[2]
    Interact.b
    Buttons.i
    Checked.b
    
    Scroll.Coordinate
    
    Type.l
    InnerCoordinate.Coordinate
    
    Repaint.l
    
    List Items.Widget()
    List Columns.Widget()
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.l)
  Declare.s GetText(Gadget.l)
  Declare SetState(Gadget.l, State.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
  
  Declare SetFont(Gadget, FontID.i)
EndDeclareModule

Module String
  
  ;- PROCEDURE
  
  Procedure Caret(*This.Widget, Reset=0)
    Protected Position.l =- 1, i.l, Caret.l, CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
        If \FontID : DrawingFont(\FontID) : EndIf
        
        ; get caret position
        For i = 0 To \Text\Len
          CursorX = \Text\x + TextWidth(Left(\Text\String.s, i))
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
          If MinDistance > Distance : MinDistance = Distance : Position = i : EndIf
        Next i
        
;         \Text\Caret = Position
;         If Reset 
;           \Text[2]\Len = 0
;           \Text\Caret[1] = \Text\Caret 
;         EndIf
;         
;         ; Если выделяем с право на лево
;         If \Text\Caret[1] > \Text\Caret 
;           Caret = \Text\Caret
;           \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
;         Else 
;           Caret = \Text\Caret[1]
;           \Text[2]\Len = \Text\Caret-\Text\Caret[1]
;         EndIf
;         
;         \Text[1]\String.s = Left(\Text\String.s, Caret)
;         
;         If \Text[2]\Len
;           \Text[2]\String.s = Mid(\Text\String.s, 1 + Caret, \Text[2]\Len)
;           \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Caret + \Text[2]\Len))
;         Else
;           \Text[2]\String.s = ""
;         EndIf
;         
;         \Text[1]\Width = TextWidth(\Text[1]\String.s) 
;         \Text[2]\Width = TextWidth(\Text[2]\String.s)
;         
;         \Text[2]\X = \Text\X+\Text[1]\Width
;         \Text[3]\X = \Text[2]\X+\Text[2]\Width
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure _Caret(*This.Widget)
    Protected Repaint.l =- 1, i.l, CursorX.l, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
        If \FontID : DrawingFont(\FontID) : EndIf
        
        For i=0 To \Text\Len
          CursorX = \Text\x + TextWidth(Left(\Text\String.s, i)) + 1
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
          
          ; Получаем позицию коpректора
          If MinDistance > Distance 
            MinDistance = Distance
            Repaint = i
          EndIf
        Next
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure _SelectionText(*This.Widget)
    Protected Caret
    
    With *This
      ; Если выделяем с право на лево
      If \Text\Caret[1] > \Text\Caret 
        Caret = \Text\Caret
        \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
      Else 
        Caret = \Text\Caret[1]
        \Text[2]\Len = \Text\Caret-\Text\Caret[1]
      EndIf
      
      If \Text[2]\Len
        \Text[1]\String.s = Left(\Text\String.s, Caret)
        \Text[2]\String.s = Mid(\Text\String.s, 1 + Caret, \Text[2]\Len)
        ; \Text[3]\String.s = Mid(\Text\String.s, 1 + Caret + \Text[2]\Len)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Caret + \Text[2]\Len))
      Else
        \Text[2]\String.s = ""
      EndIf
      
    EndWith
    
    ProcedureReturn Caret
  EndProcedure
  
  Procedure _4SelectionText(*This.Widget)
    Protected Len.i, Caret.i, String.s
    
    If ListSize(*This\Items())
    With *This\Items()
      If \Text\Caret[1] =- 1
        \Text[2]\Len = 0
      Else
        If \Text[2]\String.s <> ""
          \Text[2]\String.s = ""
        EndIf
        
        ; Если выделяем с лево на право
        If \Text\Caret > \Text\Caret[1] 
          Caret = \Text\Caret[1]
          Len = (\Text\Caret-\Text\Caret[1])
        Else 
          Caret = \Text\Caret
          Len = (\Text\Caret[1]-\Text\Caret)
        EndIf
        
        String.s = Left(\Text\String.s, Caret) 
        If \Text[1]\String.s <> String.s
          \Text[1]\String.s = String.s
          \Text[1]\Change = #True
          *This\Text\Caret = FindString(*This\Text\String.s[1], \Text\String.s) - 1
        EndIf
        
        String.s = Mid(\Text\String.s, 1+Caret, Len) 
        If \Text[2]\String.s <> String.s
          \Text[2]\String.s = String.s
          \Text[2]\Change = #True
        EndIf  
        
        String.s = Right(\Text\String.s, \Text\Len-(Caret+Len))
        If \Text[3]\String.s <> String.s
          \Text[3]\String.s = String.s  
          \Text[3]\Change = #True
        EndIf
        
        If \Text[2]\Len <> Len
          \Text[2]\Len = Len
        EndIf
        
      EndIf
    EndWith
    EndIf
  EndProcedure
  
  Procedure _1SelectionText(*This.Widget)
    Protected Caret.i =- 1, String.s, Len.i 
    
    If ListSize(*This\Items())
      With *This\Items()
        ; Если выделяем с право на лево
        If \Text\Caret[1] > \Text\Caret 
          Caret = \Text\Caret
          Len = (\Text\Caret[1]-\Text\Caret)
        Else 
          Caret = \Text\Caret[1]
          Len = \Text\Caret-\Text\Caret[1]
        EndIf
        
        If Not Len And \Text[2]\String.s <> ""
          \Text[2]\String.s = ""
        EndIf
        
        If Caret = 0 
          If \Text[1]\String.s <> ""
            \Text[1]\String.s = ""
          EndIf
          *This\Text\Caret = 0
        ElseIf Caret > 0
          String.s = Left(\Text\String.s, Caret) 
          If \Text[1]\String.s <> String.s
            \Text[1]\String.s = String.s
            \Text[1]\Change = #True
          EndIf
          *This\Text\Caret = FindString(*This\Text\String.s[1], \Text\String.s) - 1
        EndIf
        
        If \Text[2]\Len <> Len
          String.s = Mid(\Text\String.s, 1 + Caret, \Text[2]\Len) 
          If \Text[2]\String.s <> String.s
            \Text[2]\String.s = String.s
            \Text[2]\Change = #True
          EndIf  
          String.s = Right(\Text\String.s, \Text\Len-(Caret + \Text[2]\Len))
          If \Text[3]\String.s <> String.s
            \Text[3]\String.s = String.s  
            \Text[3]\Change = #True
          EndIf
          \Text[2]\Len = Len
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Caret
  EndProcedure
  
  Procedure _2SelectionText(*This.Widget)
    If ListSize(*This\Items())
      With *This\Items()
        If \Text\Caret[1] =- 1
          \Text[2]\Len = 0
        Else
          If \Text[2]\String.s <> ""
            \Text[2]\String.s = ""
          EndIf
          
          \Text[1]\Change = #True
          \Text[2]\Change = #True
          \Text[3]\Change = #True
          
          ; Если выделяем с право на лево
          If \Text\Caret[1] > \Text\Caret 
            \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
            \Text[1]\String.s = Left(\Text\String.s, \Text\Caret)
            \Text[3]\String.s = Right(\Text\String.s, \Text\Len-\Text\Caret[1])
            \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text\Caret, \Text[2]\Len)
          Else 
            \Text[2]\Len = \Text\Caret-\Text\Caret[1]
            \Text[1]\String.s = Left(\Text\String.s, \Text\Caret[1])
            \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(\Text\Caret[1] + \Text[2]\Len))
            \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text\Caret[1], \Text[2]\Len)
          EndIf
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure SelectionText(*This.Widget)
    Protected Caret
    
    With *This
      \Text[2]\String.s = ""
      
      ; Если выделяем с право на лево
      If \Text\Caret[1] > \Text\Caret 
        \Text[2]\Len = (\Text\Caret[1]-\Text\Caret)
        \Text[1]\String.s = Left(\Text\String.s, \Text\Caret)
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-\Text\Caret[1])
        ;\Text[3]\String.s = Mid(\Text\String.s, 1+\Text\Caret[1])
        \Text[2]\String.s = Left(\Text\String.s, \Text\Caret[1])
        \Text[2]\String.s = Right(\Text[2]\String.s, Len(\Text[2]\String.s)-\Text\Caret)
        ;\Text[2]\String.s = Mid(\Text\String.s, 1 + \Text\Caret, \Text[2]\Len)
      Else 
        \Text[2]\Len = \Text\Caret-\Text\Caret[1]
        \Text[1]\String.s = Left(\Text\String.s, \Text\Caret[1])
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(\Text\Caret[1] + \Text[2]\Len))
        \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text\Caret[1], \Text[2]\Len)
      EndIf
      
    EndWith
    
    ProcedureReturn Caret
  EndProcedure
  Procedure __SelectionText(*This.Widget)
    Protected Caret.i =- 1, String.s, Len.i 
    
    ;If ListSize(*This\Items())
      With *This;\Items()
        ; Если выделяем с право на лево
        If \Text\Caret[1] > \Text\Caret 
          Caret = \Text\Caret
          Len = (\Text\Caret[1]-\Text\Caret)
        Else 
          Caret = \Text\Caret[1]
          Len = \Text\Caret-\Text\Caret[1]
        EndIf
        
        If Caret = 0 
          If \Text[1]\String.s <> ""
            \Text[1]\String.s = ""
          EndIf
          *This\Text\Caret = 0
        ElseIf Caret > 0
          String.s = Left(\Text\String.s, Caret) 
          If \Text[1]\String.s <> String.s
            \Text[1]\String.s = String.s
            \Text[1]\Change = #True
          EndIf
        ;  *This\Text\Caret = FindString(*This\Text\String.s[1], \Text\String.s) - 1
        EndIf
        
        If \Text[2]\Len <> Len
          String.s = Mid(\Text\String.s, 1 + Caret, Len) 
          If \Text[2]\String.s <> String.s
            \Text[2]\String.s = String.s
            \Text[2]\Change = #True
          EndIf  
          String.s = Right(\Text\String.s, \Text\Len-(Caret + Len))
          If \Text[3]\String.s <> String.s
            \Text[3]\String.s = String.s  
            \Text[3]\Change = #True
          EndIf
          \Text[2]\Len = Len
        EndIf
        
        If Not Len And \Text[2]\String.s <> ""
          \Text[2]\String.s = ""
        EndIf
      EndWith
    ;EndIf
    
    ProcedureReturn Caret
   EndProcedure
  
  Procedure.i _CallBack(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
;     Static Text$, DoubleClickCaret =- 1
;     Protected Repaint, StartDrawing, Update_Text_Selected
;     
;     Protected Result, Buttons, Widget.i
;     Static *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
;     
;     If *This
;       With *This
;         
;         If Canvas=-1 
;           Widget = *This
;           Canvas = EventGadget()
;         Else
;           Widget = Canvas
;         EndIf
;         If Canvas <> \Canvas\Gadget Or
;            \Type <> #PB_GadgetType_String
;           ProcedureReturn
;         EndIf
;     
;         If CanvasModifiers
;           Select EventType
;             Case #PB_EventType_Input 
;               \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
;             Case #PB_EventType_KeyDown
;               \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
;               \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
;             Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
;               \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
;               \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
;               \Canvas\Mouse\At = Bool(\Canvas\Mouse\X>=\x And \Canvas\Mouse\X<\x+\Width And 
;                                       \Canvas\Mouse\Y>=\y And \Canvas\Mouse\Y<\y+\Height)
;             Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
;                  #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
;                  #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
;               \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
;           EndSelect
;         EndIf
;         
;         If Not \Hide And Not \Canvas\Mouse\Buttons And \Interact 
;           If EventType <> #PB_EventType_MouseLeave And \Canvas\Mouse\At 
;             If *Last <> *This  
;               If *Last
;                 If *Last > *This
;                   ProcedureReturn
;                 Else
;                   *Widget = *Last
;                   ; Если с одного виджета перешли на другой, 
;                   ; то посылаем событие выход для первого
;                   _CallBack(*Widget, #PB_EventType_MouseLeave, Canvas)
;                   *Last = *This
;                 EndIf
;               Else
;                 *Last = *This
;               EndIf
;               \Buttons = \Canvas\Mouse\At
;               EventType = #PB_EventType_MouseEnter
;               If Not \Checked : Buttons = \Buttons : EndIf
;               \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
;               SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
;               *Widget = *Last
;               ; Debug "enter "+*Last\text\string+" "+EventType
;             EndIf
;           ElseIf *Last = *This
;             ; Debug "leave "+*Last\text\string+" "+EventType+" "+*Widget
;             If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
;               SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
;               \Cursor[1] = 0
;             EndIf
;             EventType = #PB_EventType_MouseLeave
;             *Last = 0
;           EndIf
;         ElseIf *Widget = *This
;           If EventType = #PB_EventType_LeftButtonUp And *Last = *Widget And CanvasModifiers=-1
;             If Not \Canvas\Mouse\At
;               _CallBack(*Widget, #PB_EventType_LeftButtonUp, Canvas, 1)
;               EventType = #PB_EventType_MouseLeave
;             Else
;               _CallBack(*Widget, #PB_EventType_LeftButtonUp, Canvas, 1)
;               EventType = #PB_EventType_LeftClick
;             EndIf
;             *Last = 0  
;           EndIf
;         EndIf
;       EndWith
;       
;       ; Если канвас как родитель
;       If *Last And *Widget = *This And Widget <> Canvas
;         If EventType = #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
;         ElseIf EventType = #PB_EventType_LeftButtonDown
;           With List()\Widget
;             PushListPosition(List())
;             ForEach List()
;               If *Widget <> List()\Widget
;                 If List()\Widget\Focus = List()\Widget : List()\Widget\Focus = 0
;                   *Widget = List()\Widget
;                   _CallBack(List()\Widget, #PB_EventType_LostFocus, Canvas, 0)
;                   *Widget = *Last
;                 EndIf
;               EndIf
;             Next
;             PopListPosition(List())
;           EndWith
;           
;           If *Widget\Focus <> *Widget 
;             *Widget\Focus = *Widget
;             _CallBack(*Widget, #PB_EventType_Focus, Canvas, 0)
;           EndIf
;         EndIf
;       EndIf
;     EndIf
;     
;     
;     If *Last And *Widget = *This And ListSize(*Widget\items())
;       With *Widget\items()
;         If Not \Hide And Not \Disable
;           
;           Select EventType
;             Case #PB_EventType_LostFocus : Repaint = #True
;               \Text[2]\Len = 0 ; Убыраем выделение
;               \Text\Caret[1] =- 1 ; Прячем коректор
;               
;             Case #PB_EventType_Focus : Repaint = #True
;               \Text\Caret[1] = \Text\Caret
;               
;             Case #PB_EventType_Input
;               If *Widget\Text\Editable
;                 Protected Input, Input_2
;                 
;                 Select #True
;                   Case *Widget\Text\Lower : Input = Asc(LCase(Chr(*Widget\Canvas\Input))) : Input_2 = Input
;                   Case *Widget\Text\Upper : Input = Asc(UCase(Chr(*Widget\Canvas\Input))) : Input_2 = Input
;                   Case *Widget\Text\Pass  : Input = 9679 : Input_2 = *Widget\Canvas\Input ; "●"
;                   Case *Widget\Text\Numeric                                        ; : Debug Chr(\Canvas\Input)
;                     Static Dot
;                     
;                     Select *Widget\Canvas\Input 
;                       Case '.','0' To '9' : Input = *Widget\Canvas\Input : Input_2 = Input
;                       Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
;                       Default
;                         Input_2 = *Widget\Canvas\Input
;                     EndSelect
;                     
;                     If Not Dot And Input = '.'
;                       Dot = 1
;                     ElseIf Input <> '.'
;                       Dot = 0
;                     Else
;                       Input = 0
;                     EndIf
;                     
;                   Default
;                     Input = *Widget\Canvas\Input : Input_2 = Input
;                 EndSelect
;                 
;                 If Input_2
;                   If Input
;                     If \Text[2]\Len : RemoveText(*Widget) : EndIf
;                     \Text\Caret + 1 : \Text\Caret[1] = \Text\Caret
;                   EndIf
;                   
;                   ;\Text\String.s = Left(\Text\String.s, \Text\Caret-1) + Chr(Input) + Mid(\Text\String.s, \Text\Caret)
;                   \Text\String.s = InsertString(\Text\String.s, Chr(Input), \Text\Caret)
;                   \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), \Text\Caret)
;                   
;                   If Input
;                     *Widget\Text\Change = 1
;                     \Text\Len = Len(\Text\String.s)
;                     PostEvent(#PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Change)
;                   EndIf
;                   
;                   Repaint = #True 
;                 EndIf
;               EndIf
;               
;             Case #PB_EventType_KeyUp
;               If \Text\Numeric
;                 \Text\String.s[1]=\Text\String.s 
;               EndIf
;               Repaint = #True 
;               
;             Case #PB_EventType_KeyDown
;               Select *Widget\Canvas\Key
;                 Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\Caret = 0 : \Text\Caret[1] = \Text\Caret : Repaint = #True 
;                 Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\Caret = \Text\Len : \Text\Caret[1] = \Text\Caret : Repaint = #True 
;                   
;                 Case #PB_Shortcut_Left, #PB_Shortcut_Up : \Text[2]\String.s = ""
;                   If \Text\Caret > 0 : \Text\Caret - 1 
;                     If \Text\Caret[1] <> \Text\Caret
;                       If \Text[2]\Len 
;                         If \Text\Caret > \Text\Caret[1] 
;                           \Text\Caret = \Text\Caret[1] 
;                           \Text\Caret[1] = \Text\Caret 
;                         Else
;                           \Text\Caret[1] = \Text\Caret + 1 
;                           \Text\Caret = \Text\Caret[1] 
;                         EndIf
;                         \Text[2]\Len = 0
;                       Else
;                         \Text\Caret[1] = \Text\Caret 
;                       EndIf
;                     EndIf
;                     
;                     Repaint = #True 
;                   EndIf
;                   
;                 Case #PB_Shortcut_Right, #PB_Shortcut_Down : \Text[2]\String.s = ""
;                   If \Text\Caret[1] < \Text\Len : \Text\Caret[1] + 1 
;                     If \Text\Caret <> \Text\Caret[1]
;                       If \Text[2]\Len 
;                         If \Text\Caret > \Text\Caret[1] 
;                           \Text\Caret = \Text\Caret[1]+\Text[2]\Len - 1 
;                           \Text\Caret[1] = \Text\Caret
;                         Else
;                           \Text\Caret = \Text\Caret[1] - 1
;                           \Text\Caret[1] = \Text\Caret
;                         EndIf
;                         \Text[2]\Len = 0
;                       Else
;                         \Text\Caret = \Text\Caret[1] 
;                       EndIf
;                     EndIf
;                     Repaint = #True 
;                   EndIf
;                   
;                 Case #PB_Shortcut_X
;                   If \Text[2]\String.s And (*Widget\Canvas\Key[1] & #PB_Canvas_Control) 
;                     SetClipboardText(\Text[2]\String.s)
;                     RemoveText(*Widget)
;                     \Text\Caret[1] = \Text\Caret
;                     \Text\Len = Len(\Text\String.s)
;                     Repaint = #True 
;                   EndIf
;                   
;                 Case #PB_Shortcut_C
;                   If \Text[2]\String.s And (*Widget\Canvas\Key[1] & #PB_Canvas_Control) 
;                     SetClipboardText(\Text[2]\String.s)
;                   EndIf
;                   
;                 Case #PB_Shortcut_Back 
;                   If \Text\Caret > 0
;                     If \Text[2]\Len
;                       RemoveText(*Widget)
;                     Else
;                       \Text[2]\String.s[1] = Mid(\Text\String.s, \Text\Caret, 1)
;                       \Text\String.s = Left(\Text\String.s, \Text\Caret - 1) + Right(\Text\String.s, \Text\Len-\Text\Caret)
;                       \Text\String.s[1] = Left(\Text\String.s[1], \Text\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-\Text\Caret)
;                       \Text\Caret - 1 
;                     EndIf
;                     
;                     \Text\Caret[1] = \Text\Caret
;                     \Text\Len = Len(\Text\String.s)
;                     *Widget\Text\Change = 1
;                     Repaint = #True
;                   EndIf
;                   
;                 Case #PB_Shortcut_Delete 
;                   If \Text\Caret < \Text\Len
;                     If \Text[2]\String.s
;                       RemoveText(*Widget)
;                     Else
;                       \Text[2]\String.s[1] = Mid(\Text\String.s, (\Text\Caret+1), 1)
;                       \Text\String.s = Left(\Text\String.s, \Text\Caret) + Right(\Text\String.s, \Text\Len-(\Text\Caret+1))
;                       \Text\String.s[1] = Left(\Text\String.s[1], \Text\Caret) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(\Text\Caret+1))
;                     EndIf
;                     
;                     \Text\Caret[1] = \Text\Caret
;                     \Text\Len = Len(\Text\String.s)
;                     Repaint = #True
;                   EndIf
;                   
;                 Case #PB_Shortcut_V
;                   If \Text\Editable And (*Widget\Canvas\Key[1] & #PB_Canvas_Control)
;                     Protected ClipboardText.s = GetClipboardText()
;                     
;                     If ClipboardText.s
;                       If \Text[2]\String.s
;                         RemoveText(*Widget)
;                       EndIf
;                       
;                       Select #True
;                         Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
;                         Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
;                         Case \Text\Numeric 
;                           If Val(ClipboardText.s)
;                             ClipboardText.s = Str(Val(ClipboardText.s))
;                           EndIf
;                       EndSelect
;                       
;                       \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, \Text\Caret + 1)
;                       \Text\Caret + Len(ClipboardText.s)
;                       \Text\Caret[1] = \Text\Caret
;                       \Text\Len = Len(\Text\String.s)
;                       Repaint = #True
;                     EndIf
;                   EndIf
;                   
;               EndSelect 
;               
;             Case #PB_EventType_LeftDoubleClick 
;               DoubleClickCaret = \Text\Caret
;               
;               If \Text\Pass
;                 \Text\Caret = Len(\Text\String.s)
;                 \Text[2]\Len = \Text\Caret
;                 \Text\Caret[1] = 0
;               Else
;                 SelectionLimits(*Widget)
;               EndIf
;               
;               SelectionText(*Widget) 
;               Repaint = #True
;               
;             Case #PB_EventType_LeftButtonDown
;               \Text\Caret = Caret(*Widget)
;               
;               If \Text\Caret = DoubleClickCaret
;                 \Text\Caret = Len(\Text\String.s)
;                 \Text\Caret[1] = 0
;               Else
;                 \Text\Caret[1] = \Text\Caret
;               EndIf 
;               
;               If \Text\Numeric
;                 \Text\String.s[1] = \Text\String.s
;               EndIf
;               
;               SelectionText(*Widget)
;               DoubleClickCaret =- 1
;               Repaint = #True
;               
;             Case #PB_EventType_MouseMove
;               If *Widget\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
;                 \Text\Caret = Caret(*Widget)
;                 SelectionText(*Widget)
;                 Repaint = #True
;               EndIf
;               
;           EndSelect
;           
;         EndIf
;       EndWith
;     EndIf
;     
;     ProcedureReturn Repaint
  EndProcedure
  
  
  Procedure RemoveText(*This.Widget)
    With *This
      If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret, 1)
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret, 1)
      \Text[2]\String.s[1] = \Text[2]\String.s
      ; \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget)
    With *This
      Protected i, char = Asc(Mid(\Text\String.s, \Text\Caret + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        \Text\Caret[1] = \Text\Caret : \Text\Caret + 1
        \Text[2]\Len = \Text\Caret[1] - \Text\Caret
      Else
        For i = \Text\Caret To 0 Step - 1
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next
        
        If i =- 1 : \Text\Caret[1] = 0 : Else : \Text\Caret[1] = i : EndIf
        
        For i = \Text\Caret + 1 To \Text\Len
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next
        
        \Text\Caret = i - 1
        \Text[2]\Len = \Text\Caret[1] - \Text\Caret
        
        If \Text[2]\Len < 0 : \Text[2]\Len = 0 : EndIf
      EndIf
    EndWith           
  EndProcedure
  
  Procedure EditableCallBack(*This.Widget, EventType.l)
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    
    If *This
      With *This
        If Not \Disable
          Select EventType
            Case #PB_EventType_LostFocus : Repaint = #True
              \Text[2]\Len = 0 ; Убыраем выделение
              \Text\Caret[1] =- 1 ; Прячем коректор
              
            Case #PB_EventType_Focus : Repaint = #True
              \Text\Caret[1] = \Text\Caret ; Показываем коректор
              
            Case #PB_EventType_Input
              If *This\Text\Editable
                Protected Input, Input_2
                
                Select #True
                  Case *This\Text\Lower : Input = Asc(LCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case *This\Text\Upper : Input = Asc(UCase(Chr(*This\Canvas\Input))) : Input_2 = Input
                  Case *This\Text\Pass  : Input = 9679 : Input_2 = *This\Canvas\Input ; "●"
                  Case *This\Text\Numeric                                        ; : Debug Chr(\Canvas\Input)
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
                    \Text\Caret + 1 : \Text\Caret[1] = \Text\Caret
                  EndIf
                  
                  ;\Text\String.s = Left(\Text\String.s, \Text\Caret-1) + Chr(Input) + Mid(\Text\String.s, \Text\Caret)
                  \Text\String.s = InsertString(\Text\String.s, Chr(Input), \Text\Caret)
                  \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), \Text\Caret)
                  
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
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\Caret = 0 : \Text\Caret[1] = \Text\Caret : Repaint = #True 
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\Caret = \Text\Len : \Text\Caret[1] = \Text\Caret : Repaint = #True 
                  
                Case #PB_Shortcut_Left, #PB_Shortcut_Up : \Text[2]\String.s = ""
                  If \Text\Caret > 0 : \Text\Caret - 1 
                    If \Text\Caret[1] <> \Text\Caret
                      If \Text[2]\Len 
                        If \Text\Caret > \Text\Caret[1] 
                          \Text\Caret = \Text\Caret[1] 
                          \Text\Caret[1] = \Text\Caret 
                        Else
                          \Text\Caret[1] = \Text\Caret + 1 
                          \Text\Caret = \Text\Caret[1] 
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        \Text\Caret[1] = \Text\Caret 
                      EndIf
                    EndIf
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Right, #PB_Shortcut_Down : \Text[2]\String.s = ""
                  If \Text\Caret[1] < \Text\Len : \Text\Caret[1] + 1 
                    If \Text\Caret <> \Text\Caret[1]
                      If \Text[2]\Len 
                        If \Text\Caret > \Text\Caret[1] 
                          \Text\Caret = \Text\Caret[1]+\Text[2]\Len - 1 
                          \Text\Caret[1] = \Text\Caret
                        Else
                          \Text\Caret = \Text\Caret[1] - 1
                          \Text\Caret[1] = \Text\Caret
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        \Text\Caret = \Text\Caret[1] 
                      EndIf
                    EndIf
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_X
                  If \Text[2]\String.s And (*This\Canvas\Key[1] & #PB_Canvas_Control) 
                    SetClipboardText(\Text[2]\String.s)
                    RemoveText(*This)
                    \Text\Caret[1] = \Text\Caret
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_C
                  If \Text[2]\String.s And (*This\Canvas\Key[1] & #PB_Canvas_Control) 
                    SetClipboardText(\Text[2]\String.s)
                  EndIf
                  
                Case #PB_Shortcut_Back 
                  If \Text\Caret > 0
                    If \Text[2]\Len
                      RemoveText(*This)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, \Text\Caret, 1)
                      \Text\String.s = Left(\Text\String.s, \Text\Caret - 1) + Right(\Text\String.s, \Text\Len-\Text\Caret)
                      \Text\String.s[1] = Left(\Text\String.s[1], \Text\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-\Text\Caret)
                      \Text\Caret - 1 
                    EndIf
                    
                    \Text\Caret[1] = \Text\Caret
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True
                  EndIf
                  
                Case #PB_Shortcut_Delete 
                  If \Text\Caret < \Text\Len
                    If \Text[2]\String.s
                      RemoveText(*This)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, (\Text\Caret+1), 1)
                      \Text\String.s = Left(\Text\String.s, \Text\Caret) + Right(\Text\String.s, \Text\Len-(\Text\Caret+1))
                      \Text\String.s[1] = Left(\Text\String.s[1], \Text\Caret) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(\Text\Caret+1))
                    EndIf
                    
                    \Text\Caret[1] = \Text\Caret
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True
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
                      
                      \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, \Text\Caret + 1)
                      \Text\Caret + Len(ClipboardText.s)
                      \Text\Caret[1] = \Text\Caret
                      \Text\Len = Len(\Text\String.s)
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
            Case #PB_EventType_LeftDoubleClick 
              DoubleClickCaret = \Text\Caret
              
              If \Text\Pass
                \Text\Caret = Len(\Text\String.s)
                \Text[2]\Len = \Text\Caret
                \Text\Caret[1] = 0
              Else
                SelectionLimits(*This)
              EndIf
              
              SelectionText(*This) 
              Repaint = #True
              
            Case #PB_EventType_LeftButtonDown
              \Text\Caret = Caret(*This)
              
              If \Text\Caret = DoubleClickCaret
                \Text\Caret = 0
                \Text\Caret[1] = Len(\Text\String.s)
              Else
                \Text\Caret[1] = \Text\Caret
              EndIf 
              
              If \Text\Numeric
                \Text\String.s[1] = \Text\String.s
              EndIf
              
              SelectionText(*This)
              DoubleClickCaret =- 1
              Repaint = #True
              
            Case #PB_EventType_MouseMove
              If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                \Text\Caret[1] = Caret(*This)
                ;Debug ""+\Text\Caret+" "+\Text\Caret[1]  
                SelectionText(*This)
                Repaint = #True
              EndIf
              
          EndSelect
          
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Re(*This.Widget)
    With *This
      If Not *This\Repaint : *This\Repaint = #True : EndIf
      
    EndWith   
  EndProcedure
  
  Procedure Draw(*This.Widget)
    Protected Left, Right, r=1
    With *This
      If \Repaint And StartDrawing(CanvasOutput(\Canvas\Gadget))
        If \FontID : DrawingFont(\FontID) : EndIf
        Box(\X[1],\Y[1],\Width[1],\Height[1],\Color[0])
        
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          If (\Text[2]\Len Or \Text\Caret=\Text\Caret[1])
            Box(\X[1],\Y[1],\Width[1],\Height[1],$FF8E00)
          Else
            Box(\X[1],\Y[1],\Width[1],\Height[1],\Color[1])
          EndIf
        EndIf
        
        If \ImageID : DrawImage(\ImageID, \x,\y+(\height-\Image\Height)/2) : EndIf
        
        \Text\Height = TextHeight("A")
        \Text\Width = TextWidth(\Text\String.s)
        \Text[1]\Width = TextWidth(\Text[1]\String.s) 
        \Text[2]\Width = TextWidth(\Text[2]\String.s)
        Protected CaretLength = TextWidth(Left(\Text\String.s, \Text\Caret))
        
        ; Перемещаем корректор
        If \Text\Editable
          If \Text[2]\String.s[1] And \Scroll\X < 0
            \Scroll\X + TextWidth(\Text[2]\String.s[1]) 
            \Text[2]\String.s[1] = ""
          EndIf
        EndIf
        
        If Bool((\Text\Align & #PB_Text_Bottom) = #PB_Text_Bottom) 
          \Scroll\Y = (\Height-\Text\Height)
        ElseIf Bool((\Text\Align & #PB_Text_Middle) = #PB_Text_Middle) 
          \Scroll\Y = (\Height-\Text\Height)/2
        EndIf
        
        If Bool((\Text\Align & #PB_Text_Right) = #PB_Text_Right) 
          \Scroll\X = (\Width-\Text\Width-\fSize*2) - r
        ElseIf Bool((\Text\Align & #PB_Text_Center) = #PB_Text_Center) 
          If (\Width-\Text\Width)/2>\fSize*2 + r 
            \Scroll\X=(\Width-\Text\Width)/2 
            If \Text\Caret[1] =- 1
              CaretLength =- \Scroll\X + \fSize*2 + r
              \Text\Caret = CaretLength
            EndIf
          EndIf
        EndIf
        
        Left =- (CaretLength-\fSize*2) + r
        Right = (\Width-CaretLength-\fSize*2) - r
        
        If \Scroll\X < Left
          \Scroll\X = Left
        ElseIf \Scroll\X > Right
          \Scroll\X = Right
        EndIf
        
        \Text\X = \Scroll\X 
        \Text\Y = \Scroll\Y 
        
        If \Text\String.s
          If \Text[2]\Len
            ;             If \Text[1]\String.s
            ;               DrawingMode(#PB_2DDrawing_Transparent)
            ;               DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
            ;             EndIf
            ;             
            ;             If \Text[2]\String.s
            ; ;               DrawingMode(#PB_2DDrawing_Default)
            ;               \Text[2]\X = \Text\X+\Text[1]\Width
            ;               \Text[3]\X = \Text[2]\X+\Text[2]\Width
            ; ;               DrawText(\Text[2]\X, \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
            ;             EndIf
            ;             
            ;             If \Text[3]\String.s
            ;               DrawingMode(#PB_2DDrawing_Transparent)
            ;               DrawText(\Text[3]\X, \Text\Y, \Text[3]\String.s, $0B0B0B)
            ;             EndIf
            
            If \Text\Caret[1] > \Text\Caret
              
              If \Text[2]\String.s
                \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, \Text\Caret[1]))
                \Text[2]\X = \Text[3]\X-\Text[2]\Width 
              EndIf
              
              DrawingMode(#PB_2DDrawing_Default)
              Box(\Text[2]\X, \Text\Y, \Text[2]\Width, \Text\Height, $D77800)
              
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(\Text\X, \Text\Y, \Text[1]\String.s+\Text[2]\String.s, $FFFFFF, $D77800)
              
              If \Text[1]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
              EndIf
              
              If \Text[3]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(\Text[3]\X, \Text\Y, \Text[3]\String.s, $0B0B0B)
              EndIf
            Else
              If \Text[2]\String.s
                \Text[2]\X = \Text\X+\Text[1]\Width
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf
              
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
              
              If \Text[2]\String.s
                DrawingMode(#PB_2DDrawing_Default)
                DrawText(\Text[2]\X, \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
              EndIf
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
          EndIf
        EndIf
        
        If \Text\Caret=\Text\Caret[1] ; And Property_GadgetTimer( 300 )
          DrawingMode(#PB_2DDrawing_XOr)             
          Line(\Text\X + CaretLength - Bool(\Scroll\X = Right), \Text\Y, 1, \Text\Height, $FFFFFF)
        EndIf
        
        ; 
        If \Text\Numeric
          If \Text\String.s[1]<>\Text\String.s
            DrawingMode(#PB_2DDrawing_Default)
            Box(\X[1],\Y[1],\Width[1],\Height[1],\Color[0])
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Text\Y, "!!! Недопустимый символ", $0000FF)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X[1],\Y[1],\Width[1],\Height[1],$0000FF)
          EndIf
        EndIf
        
        \Repaint = #False
        StopDrawing()
      EndIf
    EndWith  
  EndProcedure
  
  Procedure ReDraw(*This.Widget)
    Re(*This)
    Draw(*This)
  EndProcedure
  
  
  Procedure CallBack()
    Static LastX, LastY
    Protected *This.Widget = GetGadgetData(EventGadget())
    
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
          Re(*This)
          
      EndSelect
      
      
      If EditableCallBack(*This, EventType())
        ReDraw(*This)
      EndIf
      
      ;       *This\Repaint = Scroll::CallBack(*This\Scroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      ;       If *This\Repaint 
      ;         ReDraw(*This)
      ;         PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      ;       EndIf
    EndWith
    
    ; Draw(*This)
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.l, Attribute.l)
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
  
  Procedure SetState(Gadget.l, State.l)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected ScrollPos, *This.Widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure.s GetText(Gadget.l)
    Protected ScrollPos, *This.Widget = GetGadgetData(Gadget)
    
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure SetFont(Gadget, FontID.i)
    Protected *This.Widget = GetGadgetData(Gadget)
    
    With *This
      \FontID = FontID
      ReDraw(*This)
    EndWith
  EndProcedure
  
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
    Protected *This.Widget=AllocateStructure(Widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Min.l, Max.l, PageLength.l
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        \Type = #PB_GadgetType_String
        \FontID = GetGadgetFont(#PB_Default)
        
        Flag|#PB_Text_Middle
        
        \fSize = Bool(Not Flag&#PB_String_BorderLess)
        \bSize = \fSize
        
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
        
        \Color[1] = $C0C0C0
        \Color[2] = $F0F0F0
        
        ;\Scroll\ButtonLength = 7
        \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
        
        ;         \Text\X = \fSize
        ;         \Text\y = \fSize
        
        If Bool(Flag&#PB_Text_Center) : \Text\Align | #PB_Text_Center : EndIf
        If Bool(Flag&#PB_Text_Middle) : \Text\Align | #PB_Text_Middle : EndIf
        If Bool(Flag&#PB_Text_Right)  : \Text\Align | #PB_Text_Right : EndIf
        If Bool(Flag&#PB_Text_Bottom) : \Text\Align | #PB_Text_Bottom : EndIf
        
        ;         \Text\YAlign = Bool(Flag&#PB_Text_Center)
        ;         
        ;         \Text\Align = Flag
        ; ;         If Bool(Flag&#PB_Text_Center)
        ; ;           \Text\Align | #PB_Text_Center
        ; ;         EndIf
        ; ;         If Bool(Flag&#PB_Text_Middle)
        ; ;           \Text\Align | #PB_Text_Middle
        ; ;         EndIf
        ; ;         
        ;         If Not \Text\MultiLine
        ;           \Text\YAlign = 9 
        ;           If Bool(Flag&#PB_Text_Right) : \Text\XAlign = 2 : EndIf
        ;           If Bool(Flag&#PB_Text_Center) : \Text\XAlign = 9 : EndIf
        ;         EndIf
        
        If \Text\Editable
          \Color[0] = $FFFFFF
        Else
          \Color[0] = $F0F0F0
        EndIf
        
        \Text\String.s[1] = Text.s
        
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
        
        \Text\Caret[1] =- 1
        \Text\Len = Len(\Text\String.s)
        
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  
  Procedure CallBack()
    Select EventType()
      Case #PB_EventType_Change
        If GadgetType(EventGadget()) = #PB_GadgetType_String
          Debug GetGadgetText(EventGadget())
        Else
          Debug GetText(EventGadget())
        EndIf
        
    EndSelect
  EndProcedure
  
  
  LoadFont(0, "Courier", 20)
  Text.s = "Vertical and Horizontal" + #CRLF$ + "Centered Text in" + #CRLF$ + "Multiline StringGadget"
  
  If OpenWindow(0, 0, 0, 605, 235, "StringGadget Flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    StringGadget(0, 8,  10, 290, 20, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, 20, "1234567", #PB_String_Numeric|#PB_Text_Center)
    StringGadget(2, 8,  60, 290, 20, "Read-only StringGadget", #PB_String_ReadOnly|#PB_Text_Right)
    StringGadget(3, 8,  85, 290, 20, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, 20, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 140, 290, 20, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, 170, 290, 20, "Password", #PB_String_Password)
    
    StringGadget(7, 8,  200, 290, 20, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh", #PB_String_Numeric|#PB_Text_Center)
    
    Gadget(10, 300+8,  10, 290, 20, "Normal StringGadget...")
    Gadget(11, 300+8,  35, 290, 20, "1234567", #PB_Text_Numeric|#PB_Text_Center)
    Gadget(12, 300+8,  60, 290, 20, "Read-only StringGadget", #PB_Text_ReadOnly|#PB_Text_Right)
    Gadget(13, 300+8,  85, 290, 20, "LOWERCASE...", #PB_Text_LowerCase)
    Gadget(14, 300+8, 110, 290, 20, "uppercase...", #PB_Text_UpperCase)
    Gadget(15, 300+8, 140, 290, 20, "Borderless StringGadget", #PB_String_BorderLess)
    Gadget(16, 300+8, 170, 290, 20, "Password", #PB_Text_Password)
    
    Gadget(17, 300+8,  200, 290, 20, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh", #PB_String_Numeric|#PB_Text_Center)
    
    BindEvent(#PB_Event_Gadget, @CallBack())
    
    Repeat 
      Event = WaitWindowEvent()
      
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
; Folding = --v---84----4------------
; EnableXP