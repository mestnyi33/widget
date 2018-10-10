CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_text.pbi"
CompilerEndIf
XIncludeFile "module_button.pbi" 
    
;-
DeclareModule String
  
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
  Declare.i Draw(*This.Widget, Canvas.i=-1)
  
  Declare.i CallBack(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
EndDeclareModule

Module String
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure Caret(*This.Widget)
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If ListSize(\Items())
        X = \Items()\X+\Items()\Text\x
        Len = \Items()\Text\Len
        FontID = \Items()\Text\FontID
        String.s = \Items()\Text\String.s
        If Not FontID : FontID = *This\Text\FontID : EndIf
        
        If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
          If FontID : DrawingFont(FontID) : EndIf
          
          For i=0 To Len
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
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Draw(*This.Widget, Canvas.i=-1)
    ProcedureReturn Text::Draw(*This, Canvas)
    
  EndProcedure
  
  
  Procedure RemoveText(*This.Widget)
    With *This
      If \Text\CaretPos > \Text\CaretPos[1] : \Text\CaretPos = \Text\CaretPos[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, \Text\CaretPos, 1)
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\CaretPos, 1)
      \Text[2]\String.s[1] = \Text[2]\String.s
      ; \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure SelectionText(*This.Widget)
    Protected CaretPos 
    
    If ListSize(*This\Items())
      With *This\Items()
        ; Если выделяем с право на лево
        If \Text\CaretPos[1] > \Text\CaretPos 
          CaretPos = \Text\CaretPos
          \Text[2]\Len = (\Text\CaretPos[1]-\Text\CaretPos)
        Else 
          CaretPos = \Text\CaretPos[1]
          \Text[2]\Len = \Text\CaretPos-\Text\CaretPos[1]
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, CaretPos) : \Text[1]\Change = #True
        
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len) : \Text[2]\Change = #True
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len)) : \Text[3]\Change = #True
        Else
          \Text[2]\String.s = ""
        EndIf
        
        *This\Text\CaretPos = FindString(*This\Text\String.s[1], \Text\String.s) - 1
      EndWith
      
    Else
      With *This
        ; Если выделяем с право на лево
        If \Text\CaretPos[1] > \Text\CaretPos 
          CaretPos = \Text\CaretPos
          \Text[2]\Len = (\Text\CaretPos[1]-\Text\CaretPos)
        Else 
          CaretPos = \Text\CaretPos[1]
          \Text[2]\Len = \Text\CaretPos-\Text\CaretPos[1]
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, CaretPos) : \Text[1]\Change = #True
        
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len) : \Text[2]\Change = #True
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len)) : \Text[3]\Change = #True
        Else
          \Text[2]\String.s = ""
        EndIf
      EndWith
    EndIf
    
    
    ProcedureReturn CaretPos
  EndProcedure
  
  Procedure SelectionLimits(*This.Widget)
    With *This
      Protected i, char = Asc(Mid(\Text\String.s, \Text\CaretPos + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        \Text\CaretPos[1] = \Text\CaretPos : \Text\CaretPos + 1
        \Text[2]\Len = \Text\CaretPos[1] - \Text\CaretPos
      Else
        For i = \Text\CaretPos To 0 Step - 1
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next
        
        If i =- 1 : \Text\CaretPos[1] = 0 : Else : \Text\CaretPos[1] = i : EndIf
        
        For i = \Text\CaretPos + 1 To \Text\Len
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next
        
        \Text\CaretPos = i - 1
        \Text[2]\Len = \Text\CaretPos[1] - \Text\CaretPos
        
        If \Text[2]\Len < 0 : \Text[2]\Len = 0 : EndIf
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.i CallBack(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static Text$, DoubleClickCaretPos =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Result, Buttons, Widget.i
    Static *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
    
    If *This
      With *This
        
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        If Canvas <> \Canvas\Gadget Or
           \Type <> #PB_GadgetType_String
          ProcedureReturn
        EndIf
    
        If CanvasModifiers
          Select EventType
            Case #PB_EventType_Input 
              \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
            Case #PB_EventType_KeyDown
              \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
              \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
            Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
              \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
              \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
              \Canvas\Mouse\At = Bool(\Canvas\Mouse\X>=\x And \Canvas\Mouse\X<\x+\Width And 
                                      \Canvas\Mouse\Y>=\y And \Canvas\Mouse\Y<\y+\Height)
            Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
                 #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
                 #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
              \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
          EndSelect
        EndIf
        
        If Not \Hide And Not \Canvas\Mouse\Buttons And \Interact 
          If EventType <> #PB_EventType_MouseLeave And \Canvas\Mouse\At 
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
              \Buttons = \Canvas\Mouse\At
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
            If Not \Canvas\Mouse\At
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
            CallBack(*Widget, #PB_EventType_Focus, Canvas, 0)
          EndIf
        EndIf
      EndIf
    EndIf
    
    
    If *Last And *Widget = *This And ListSize(*Widget\items())
      With *Widget\items()
        If Not \Hide And Not \Disable
          
          Select EventType
            Case #PB_EventType_LostFocus : Repaint = #True
              \Text[2]\Len = 0 ; Убыраем выделение
              \Text\CaretPos[1] =- 1 ; Прячем коректор
              
            Case #PB_EventType_Focus : Repaint = #True
              \Text\CaretPos[1] = \Text\CaretPos
              
            Case #PB_EventType_Input
              If *Widget\Text\Editable
                Protected Input, Input_2
                
                Select #True
                  Case *Widget\Text\Lower : Input = Asc(LCase(Chr(*Widget\Canvas\Input))) : Input_2 = Input
                  Case *Widget\Text\Upper : Input = Asc(UCase(Chr(*Widget\Canvas\Input))) : Input_2 = Input
                  Case *Widget\Text\Pass  : Input = 9679 : Input_2 = *Widget\Canvas\Input ; "●"
                  Case *Widget\Text\Numeric                                        ; : Debug Chr(\Canvas\Input)
                    Static Dot
                    
                    Select *Widget\Canvas\Input 
                      Case '.','0' To '9' : Input = *Widget\Canvas\Input : Input_2 = Input
                      Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
                      Default
                        Input_2 = *Widget\Canvas\Input
                    EndSelect
                    
                    If Not Dot And Input = '.'
                      Dot = 1
                    ElseIf Input <> '.'
                      Dot = 0
                    Else
                      Input = 0
                    EndIf
                    
                  Default
                    Input = *Widget\Canvas\Input : Input_2 = Input
                EndSelect
                
                If Input_2
                  If Input
                    If \Text[2]\Len : RemoveText(*Widget) : EndIf
                    \Text\CaretPos + 1 : \Text\CaretPos[1] = \Text\CaretPos
                  EndIf
                  
                  ;\Text\String.s = Left(\Text\String.s, \Text\CaretPos-1) + Chr(Input) + Mid(\Text\String.s, \Text\CaretPos)
                  \Text\String.s = InsertString(\Text\String.s, Chr(Input), \Text\CaretPos)
                  \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(Input_2), \Text\CaretPos)
                  
                  If Input
                    *Widget\Text\Change = 1
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
              Select *Widget\Canvas\Key
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\CaretPos = 0 : \Text\CaretPos[1] = \Text\CaretPos : Repaint = #True 
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : \Text\CaretPos = \Text\Len : \Text\CaretPos[1] = \Text\CaretPos : Repaint = #True 
                  
                Case #PB_Shortcut_Left, #PB_Shortcut_Up : \Text[2]\String.s = ""
                  If \Text\CaretPos > 0 : \Text\CaretPos - 1 
                    If \Text\CaretPos[1] <> \Text\CaretPos
                      If \Text[2]\Len 
                        If \Text\CaretPos > \Text\CaretPos[1] 
                          \Text\CaretPos = \Text\CaretPos[1] 
                          \Text\CaretPos[1] = \Text\CaretPos 
                        Else
                          \Text\CaretPos[1] = \Text\CaretPos + 1 
                          \Text\CaretPos = \Text\CaretPos[1] 
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        \Text\CaretPos[1] = \Text\CaretPos 
                      EndIf
                    EndIf
                    
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_Right, #PB_Shortcut_Down : \Text[2]\String.s = ""
                  If \Text\CaretPos[1] < \Text\Len : \Text\CaretPos[1] + 1 
                    If \Text\CaretPos <> \Text\CaretPos[1]
                      If \Text[2]\Len 
                        If \Text\CaretPos > \Text\CaretPos[1] 
                          \Text\CaretPos = \Text\CaretPos[1]+\Text[2]\Len - 1 
                          \Text\CaretPos[1] = \Text\CaretPos
                        Else
                          \Text\CaretPos = \Text\CaretPos[1] - 1
                          \Text\CaretPos[1] = \Text\CaretPos
                        EndIf
                        \Text[2]\Len = 0
                      Else
                        \Text\CaretPos = \Text\CaretPos[1] 
                      EndIf
                    EndIf
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_X
                  If \Text[2]\String.s And (*Widget\Canvas\Key[1] & #PB_Canvas_Control) 
                    SetClipboardText(\Text[2]\String.s)
                    RemoveText(*Widget)
                    \Text\CaretPos[1] = \Text\CaretPos
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_C
                  If \Text[2]\String.s And (*Widget\Canvas\Key[1] & #PB_Canvas_Control) 
                    SetClipboardText(\Text[2]\String.s)
                  EndIf
                  
                Case #PB_Shortcut_Back 
                  If \Text\CaretPos > 0
                    If \Text[2]\Len
                      RemoveText(*Widget)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, \Text\CaretPos, 1)
                      \Text\String.s = Left(\Text\String.s, \Text\CaretPos - 1) + Right(\Text\String.s, \Text\Len-\Text\CaretPos)
                      \Text\String.s[1] = Left(\Text\String.s[1], \Text\CaretPos - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-\Text\CaretPos)
                      \Text\CaretPos - 1 
                    EndIf
                    
                    \Text\CaretPos[1] = \Text\CaretPos
                    \Text\Len = Len(\Text\String.s)
                    *Widget\Text\Change = 1
                    Repaint = #True
                  EndIf
                  
                Case #PB_Shortcut_Delete 
                  If \Text\CaretPos < \Text\Len
                    If \Text[2]\String.s
                      RemoveText(*Widget)
                    Else
                      \Text[2]\String.s[1] = Mid(\Text\String.s, (\Text\CaretPos+1), 1)
                      \Text\String.s = Left(\Text\String.s, \Text\CaretPos) + Right(\Text\String.s, \Text\Len-(\Text\CaretPos+1))
                      \Text\String.s[1] = Left(\Text\String.s[1], \Text\CaretPos) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(\Text\CaretPos+1))
                    EndIf
                    
                    \Text\CaretPos[1] = \Text\CaretPos
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True
                  EndIf
                  
                Case #PB_Shortcut_V
                  If \Text\Editable And (*Widget\Canvas\Key[1] & #PB_Canvas_Control)
                    Protected ClipboardText.s = GetClipboardText()
                    
                    If ClipboardText.s
                      If \Text[2]\String.s
                        RemoveText(*Widget)
                      EndIf
                      
                      Select #True
                        Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                        Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                        Case \Text\Numeric 
                          If Val(ClipboardText.s)
                            ClipboardText.s = Str(Val(ClipboardText.s))
                          EndIf
                      EndSelect
                      
                      \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, \Text\CaretPos + 1)
                      \Text\CaretPos + Len(ClipboardText.s)
                      \Text\CaretPos[1] = \Text\CaretPos
                      \Text\Len = Len(\Text\String.s)
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
            Case #PB_EventType_LeftDoubleClick 
              DoubleClickCaretPos = \Text\CaretPos
              
              If \Text\Pass
                \Text\CaretPos = Len(\Text\String.s)
                \Text[2]\Len = \Text\CaretPos
                \Text\CaretPos[1] = 0
              Else
                SelectionLimits(*Widget)
              EndIf
              
              SelectionText(*Widget) 
              Repaint = #True
              
            Case #PB_EventType_LeftButtonDown
              \Text\CaretPos = Caret(*Widget)
              
              If \Text\CaretPos = DoubleClickCaretPos
                \Text\CaretPos = Len(\Text\String.s)
                \Text\CaretPos[1] = 0
              Else
                \Text\CaretPos[1] = \Text\CaretPos
              EndIf 
              
              If \Text\Numeric
                \Text\String.s[1] = \Text\String.s
              EndIf
              
              SelectionText(*Widget)
              DoubleClickCaretPos =- 1
              Repaint = #True
              
            Case #PB_EventType_MouseMove
              If *Widget\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                \Text\CaretPos = Caret(*Widget)
                SelectionText(*Widget)
                Repaint = #True
              EndIf
              
          EndSelect
          
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Cut(*This.Widget)
    Protected String.s
    
    With *This\Items()
      If ListSize(*This\Items()) 
        
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
      If String.s And Not \CaretPos
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.b Back(*This.Widget)
    Protected Repaint.b, String.s
    
    With *This\Items()
      If ListSize(*This\Items()) 
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_String
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        
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
          \Color[0]\Frame[1] = $BABABA
          
          ResetColor(*This)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget=AllocateStructure(Widget)
    
    If *This
      
      ;{ Генерируем идентификатор
      If Widget =- 1 Or Widget > ListSize(List()) - 1
        LastElement(List())
        AddElement(List()) 
        Widget = ListIndex(List())
        *Widget = @List()
      Else
        SelectElement(List(), Widget)
        *Widget = @List()
        InsertElement(List())
        
        PushListPosition(List())
        While NextElement(List())
          ; List()\Item = ListIndex(List())
        Wend
        PopListPosition(List())
      EndIf
      ;}
      
      List()\Widget = Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
;       Draw(*This, Canvas)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  
  Global *S_0.Widget = AllocateStructure(Widget)
  Global *S_1.Widget = AllocateStructure(Widget)
  Global *S_2.Widget = AllocateStructure(Widget)
  Global *S_3.Widget = AllocateStructure(Widget)
  Global *S_4.Widget = AllocateStructure(Widget)
  Global *S_5.Widget = AllocateStructure(Widget)
  Global *S_6.Widget = AllocateStructure(Widget)
  Global *S_7.Widget = AllocateStructure(Widget)
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_LeftButtonDown
        ;         *S_0\Focus = 0
        ;         *S_1\Focus = 0
        ;         *S_2\Focus = 0
        ;         *S_3\Focus = 0
        ;         *S_4\Focus = 0
        ;         *S_5\Focus = 0
        ;         *S_6\Focus = 0
        ;         *S_7\Focus = 0
        
    EndSelect
    
    Select EventType()
      Case #PB_EventType_Resize
        Result = 1
      Default
        
        Result | CallBack(*S_0, EventType()) 
        Result | CallBack(*S_1, EventType()) 
        Result | CallBack(*S_2, EventType()) 
        Result | CallBack(*S_3, EventType()) 
        Result | CallBack(*S_4, EventType()) 
        Result | CallBack(*S_5, EventType()) 
        Result | CallBack(*S_6, EventType()) 
        Result | CallBack(*S_7, EventType()) 
        
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $DDDEC9)
        Draw(*S_0, Canvas)
        Draw(*S_1, Canvas)
        Draw(*S_2, Canvas)
        Draw(*S_3, Canvas)
        Draw(*S_4, Canvas)
        Draw(*S_5, Canvas)
        Draw(*S_6, Canvas)
        Draw(*S_7, Canvas)
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "Left click "+EventGadget()+" "+EventType()
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(0, 0, 0, 615, 235, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    StringGadget(0, 8,  10, 290, 20, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, 20, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, 20, "Read-only StringGadget", #PB_String_ReadOnly)
    StringGadget(3, 8,  85, 290, 20, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, 20, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 140, 290, 20, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, 170, 290, 20, "Password", #PB_String_Password)
    
    StringGadget(7, 8,  200, 290, 20, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh", #PB_String_Numeric|#PB_Text_Center)
    
    ; Demo draw string on the canvas
    CanvasGadget(10,  305, 0, 310, 235, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, 20, "Normal StringGadget...")
    *S_1 = Create(10, -1, 8,  35, 290, 20, "1234567", #PB_Text_Numeric|#PB_Text_Center)
    *S_2 = Create(10, -1, 8,  60, 290, 20, "Read-only StringGadget", #PB_Text_ReadOnly|#PB_Text_Right)
    *S_3 = Create(10, -1, 8,  85, 290, 20, "LOWERCASE...", #PB_Text_LowerCase)
    *S_4 = Create(10, -1, 8, 110, 290, 20, "uppercase...", #PB_Text_UpperCase)
    *S_5 = Create(10, -1, 8, 140, 290, 20, "Borderless StringGadget", #PB_Widget_BorderLess)
    *S_6 = Create(10, -1, 8, 170, 290, 20, "Password", #PB_Text_Password)
    Button::Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_MultiLine|#PB_Widget_Default, 4)
    *S_7 = Create(10, -1, 8,  200, 290, 20, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh");, #PB_Text_Numeric|#PB_Text_Center)
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -4n++v-+f-6---r0----
; EnableXP