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

;-
DeclareModule String
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro Draw(_adress_) : Text::Draw(_adress_) : EndMacro
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Events(*This.Widget_S, EventType.i)
  
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
EndDeclareModule

Module String
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure Caret(*This.Widget_S, Line.i = 0)
    ProcedureReturn Text::Caret(*This, Line)
    
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
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
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
      If Caret <> *This\Text\Caret Or Line <> *This\Index[1] Or (*This\Text\Caret[1] >= 0 And Caret1 <> *This\Text\Caret[1])
        \Text[2]\String.s = ""
        
        If *This\Index[2] = *This\Index[1]
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
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *This\Text\Caret > *This\Text\Caret[1]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *This\Text\Caret[1] > *This\Text\Caret 
              ; |<<<<<< to left
              Position = *This\Text\Caret
              \Text[2]\Len = (*This\Text\Caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *This\Text\Caret[1]
              \Text[2]\Len = (*This\Text\Caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *This\Index[1] > *This\Index[2]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \Text[1]\String.s = Left(*This\Text\String.s, \Text\Pos+Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s, 1+\Text\Pos+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Trim(Right(*This\Text\String.s, *This\Text\Len-(\Text\Pos+Position + \Text[2]\Len)), #LF$) : \Text[3]\Change = #True
        
        Line = *This\Index[1]
        Caret = *This\Text\Caret
        Caret1 = *This\Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  
  Procedure ToLeft(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
      ElseIf \Text\Caret[1] > 0 
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len 
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
      ElseIf \Text\Caret[1] < \Items()\Text\Len
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1] 
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text\Caret[1] < \Items()\Text\Len
        If \Items()\Text[2]\Len 
          Text::Remove(*This)
        Else
          \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Pos+\Text\Caret) + Mid(\Text\String.s[1],  \Items()\Text\Pos+\Text\Caret + 2)
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret) + Mid(\Text\String.s,  \Items()\Text\Pos+\Text\Caret + 2)
          \Text\Len = Len(\Text\String.s) 
        EndIf
        
        \Text\Change =- 1
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
            Text::Remove(*This)
          EndIf
          
          \Text\Caret + 1
          ; \Items()\Text\String.s = \Items()\Text[1]\String.s + Chr(\Canvas\Input) + \Items()\Text[3]\String.s ; сним не выравнивается строка при вводе слов
          \Text\String.s = InsertString(\Text\String.s, Chr.s, \Items()\Text\Pos+\Text\Caret)
          \Text\Len = Len(\Text\String.s) 
          \Text\Caret[1] = \Text\Caret 
          \Text\Change =- 1
        Else
          \Default = *This
        EndIf
        
        \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(\Canvas\Input), \Items()\Text\Pos+\Text\Caret)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
    Protected Repaint, String.s 
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This
      If \Items()\Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
        Text::Remove(*This)
        
      ElseIf \Text\Caret[1] > 0 
        \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s[1],  \Items()\Text\Pos+\Text\Caret + 1)
        \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s,  \Items()\Text\Pos+\Text\Caret + 1)
        \Text\Len = Len(\Text\String.s)  
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  ;-
  Procedure.i Events(*This.Widget_S, EventType.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *This
      If  *This\Canvas\Mouse\Buttons
        If *This\Canvas\Mouse\Y < *This\Y
          *This\Index[1] =- 1
        Else
          *This\Index[1] = (((*This\Canvas\Mouse\Y-*This\Y-*This\Text\Y)-*This\Scroll\Y) / *This\Height[2])
        EndIf
      EndIf
      
      With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse)
    EndWith
    
    With *This\items() ;  Not Scroll::is(\Scroll)
        If ListSize(*This\items()) And Not Scroll::is(*This\Scroll) ; (((*This\Scroll\v And Not *This\Scroll\v\at) Or Not *This\Scroll\v) And ((*This\Scroll\h And Not *This\Scroll\h\at) Or Not *This\Scroll\h))
          Select EventType
            Case #PB_EventType_LostFocus 
              \Text\Caret[1] = 0 ; Двойной клик на тексте
              *This\Text\Caret = 0
              *This\Text\Caret[1] = 0 
              \Text[2]\Len = 0
              ;             \Text[1]\String.s = "" : \Text[1]\Change = #True
              ;             \Text[2]\String.s = "" : \Text[2]\Change = #True
              ;             \Text[3]\String.s = "" : \Text[3]\Change = #True
              \Text[1]\Width = 0
              \Text[2]\Width = 0
              \Text[3]\Width = 0
              ; Repaint = #True
              PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_LostFocus)
              
            Case #PB_EventType_Focus 
              Repaint = #True 
              ;*This\Text\Caret[1] = *This\Text\Caret ; Показываем коректор
              PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Focus)
              
            Case #PB_EventType_LeftButtonUp
              If #PB_Cursor_Default = GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, *This\Cursor)
              EndIf
              If *This\Text\Editable And *This\Drag[1] : *This\Drag[1] = 0
                If \Text\Caret[1] > 0 And Not Bool(\Text\Caret[1] < *This\Text\Caret + 1 And *This\Text\Caret + 1 < \Text\Caret[1] + \Text[2]\Len)
                  
                  *This\Text\String.s = RemoveString(*This\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret[1], 1)
                  
                  If \Text\Caret[1] > *This\Text\Caret 
                    \Text\Caret[1] = *This\Text\Caret 
                    *This\Text\Caret[1] = *This\Text\Caret + \Text[2]\Len
                  Else
                    \Text\Caret[1] = (*This\Text\Caret-\Text[2]\Len)
                    *This\Text\Caret[1] = \Text\Caret[1]
                  EndIf
                  
                  *This\Text\String.s = InsertString(*This\Text\String.s, \Text[2]\String.s, \Text\Pos+\Text\Caret[1] + 1)
                  *This\Text\Len = Len(*This\Text\String.s)
                  \Text\String.s = InsertString(\Text\String.s, \Text[2]\String.s, \Text\Pos+\Text\Caret[1] + 1)
                  \Text\Len = Len(\Text\String.s)
                  
                  *This\Text\Change =- 1
                  \Text\Caret[1] = 0
                  Repaint =- 1
                EndIf
              Else
                Repaint =- 1
                \Text\Caret[1] = 0
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              Caret = Caret(*This)
              
              If \Text\Caret[1] =- 1 : \Text\Caret[1] = 0
                *This\Text\Caret = Caret
                *This\Text\Caret = 0
                *This\Text\Caret[1] = \Text\Len
                \Text[2]\Len = \Text\Len
                Repaint =- 1
              Else
                Repaint = 1
                
                If \Text[2]\Len
                  If *This\Text\Caret[1] > *This\Text\Caret : *This\Text\Caret[1] = *This\Text\Caret : EndIf
                  
                  If *This\Text\Caret[1] < Caret And Caret < *This\Text\Caret[1] + \Text[2]\Len
                    SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                    \Text\Caret[1] = *This\Text\Caret[1] + 1
                  Else
                    Repaint =- 1
                  EndIf
                Else
                  \Text[1]\String.s = Left(*This\Text\String.s, \Text\Pos+Caret) : \Text[1]\Change = #True
                EndIf
                
                *This\Text\Caret = Caret
                *This\Text\Caret[1] = *This\Text\Caret
              EndIf 
              
            Case #PB_EventType_LeftDoubleClick 
              \Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
              Text::SelLimits(*This) ; Выделяем слово
              Repaint =- 1
              
            Case #PB_EventType_MouseMove
              If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                *This\Text\Caret = Caret(*This)
                ; Debug *This\Canvas\Mouse\Delta\X
                
                If \Text\Caret[1] ; *This\Cursor <> GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
                  If \Text\Caret[1] < *This\Text\Caret + 1 And *This\Text\Caret + 1 < \Text\Caret[1] + \Text[2]\Len
                    SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  Else
                    \Text[1]\String.s = Left(*This\Text\String.s, \Text\Pos+*This\Text\Caret) : \Text[1]\Change = #True
                  EndIf
                  
                  *This\Text\Caret[1] = *This\Text\Caret
                  Repaint = 1
                Else
                  Repaint =- 1
                EndIf
              EndIf
              
          EndSelect
          
          If (*Focus = *This And *This\Text\Editable)
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_Input
                If Not Control
                  Repaint = ToInput(*This)
                EndIf
                
              Case #PB_EventType_KeyUp
                ;               If \Text\Numeric
                ;                 \Text\String.s[1]=\Text\String.s 
                ;               EndIf
                Repaint = #True 
                
              Case #PB_EventType_KeyDown
                Select *This\Canvas\Key
                  Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = 0 : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                  Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = \Text\Len : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                    
                  Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = ToLeft(*This) ; Ok
                  Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = ToRight(*This) ; Ok
                  Case #PB_Shortcut_Back : Repaint = ToBack(*This)
                  Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                    
                  Case #PB_Shortcut_A
                    If Control
                      *This\Text\Caret = 0
                      *This\Text\Caret[1] = \Text\Len
                      \Text[2]\Len = \Text\Len
                      Repaint = 1
                    EndIf
                    
                  Case #PB_Shortcut_X
                    If Control And \Text[2]\String.s 
                      SetClipboardText(\Text[2]\String.s)
                      Text::Remove(*This)
                      *This\Text\Caret[1] = *This\Text\Caret
                      \Text\Len = Len(\Text\String.s)
                      Repaint = #True 
                    EndIf
                    
                  Case #PB_Shortcut_C
                    If Control And \Text[2]\String.s 
                      SetClipboardText(\Text[2]\String.s)
                    EndIf
                    
                  Case #PB_Shortcut_V
                    If Control
                      Protected ClipboardText.s = GetClipboardText()
                      
                      If ClipboardText.s
                        If \Text[2]\String.s
                          Text::Remove(*This)
                        EndIf
                        
                        Select #True
                          Case *This\Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                          Case *This\Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                          Case *This\Text\Numeric 
                            If Val(ClipboardText.s)
                              ClipboardText.s = Str(Val(ClipboardText.s))
                            EndIf
                        EndSelect
                        
                        \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, *This\Text\Caret + 1)
                        *This\Text\Caret + Len(ClipboardText.s)
                        *This\Text\Caret[1] = *This\Text\Caret
                        \Text\Len = Len(\Text\String.s)
                        Repaint = #True
                      EndIf
                    EndIf
                    
                EndSelect 
                
            EndSelect
          EndIf
          
          If Repaint =- 1
            SelectionText(*This)
          EndIf
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
        \Type = #PB_GadgetType_String
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)
        
        If Flag&#PB_Flag_Flat
          \fSize[1] = 1
        ElseIf Flag&#PB_Flag_Single
          \fSize[1] = 2
        ElseIf Flag&#PB_Flag_Double
          \fSize[1] = 3
          \fSize = 2
        ElseIf Flag&#PB_Flag_Raised
          \fSize[1] = 4
          \fSize = 2
        EndIf
        
        \bSize = \fSize
        
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine =- 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 1
          EndIf
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          If \Text\Vertical
            \Text\X = \fSize+5
            \Text\y = \fSize
          Else
            \Text\X = \fSize+5
            \Text\y = \fSize
          EndIf
          
          ; set default colors
          \Color = Colors
          \Color\Fore[0] = 0
          \Color\Fore[1] = 0
          \Color\Fore[2] = 0
          \Row\Color = \Color
          \Row\Color\back[1] =- 1
          \Row\Color\frame[1] =- 1
          
          If \Text\Editable
            \Color\Back[0] = $FFFFFFFF 
            \Color\Back[1] = $FFFFFFFF
          Else
            \Color\Back[0] = $FFFAFAFA  
            \Color\Back[1] = $FFFAFAFA
          EndIf
          
          If Not \fSize[1]
            \Color\Frame[1] = $FFFFFFFF
          EndIf
          
          
          SetText(*This, Text.s)
          Resize(*This, X,Y,Width,Height)
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
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create, *This\Canvas\Gadget)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint, *This)
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
      
      Repaint | CallBack(*This, EventType())
      
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

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure GetWindowBackgroundColor(hwnd=0) ;hwnd only used in Linux, ignored in Win/Mac
    CompilerSelect #PB_Compiler_OS
        
      CompilerCase #PB_OS_Windows  
        Protected color = GetSysColor_(#COLOR_WINDOW)
        If color = $FFFFFFFF Or color=0: color = GetSysColor_(#COLOR_BTNFACE): EndIf
        ProcedureReturn color
        
      CompilerCase #PB_OS_Linux   ;thanks to uwekel http://www.purebasic.fr/english/viewtopic.php?p=405822
        Protected *style.GtkStyle, *color.GdkColor
        *style = gtk_widget_get_style_(hwnd) ;GadgetID(Gadget))
        *color = *style\bg[0]                ;0=#GtkStateNormal
        ProcedureReturn RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8)
        
      CompilerCase #PB_OS_MacOS   ;thanks to wilbert http://purebasic.fr/english/viewtopic.php?f=19&t=55719&p=497009
        Protected.i color, Rect.NSRect, Image, NSColor = CocoaMessage(#Null, #Null, "NSColor windowBackgroundColor")
        If NSColor
          Rect\size\width = 1
          Rect\size\height = 1
          Image = CreateImage(#PB_Any, 1, 1)
          StartDrawing(ImageOutput(Image))
          CocoaMessage(#Null, NSColor, "drawSwatchInRect:@", @Rect)
          color = Point(0, 0)
          StopDrawing()
          FreeImage(Image)
          ProcedureReturn color
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure  
  
  UseModule String
  Global winBackColor
  
  Global *S_0.Widget_S = AllocateStructure(Widget_S)
  Global *S_1.Widget_S = AllocateStructure(Widget_S)
  Global *S_2.Widget_S = AllocateStructure(Widget_S)
  Global *S_3.Widget_S = AllocateStructure(Widget_S)
  Global *S_4.Widget_S = AllocateStructure(Widget_S)
  Global *S_5.Widget_S = AllocateStructure(Widget_S)
  Global *S_6.Widget_S = AllocateStructure(Widget_S)
  Global *S_7.Widget_S = AllocateStructure(Widget_S)
  Global *S_8.Widget_S = AllocateStructure(Widget_S)
  
  Global *Button_0.Widget_S = AllocateStructure(Widget_S)
  Global *Button_1.Widget_S = AllocateStructure(Widget_S)
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_KeyDown ; Debug  " key "+GetGadgetAttribute(Canvas, #PB_Canvas_Key)
        Select GetGadgetAttribute(Canvas, #PB_Canvas_Key)
          Case #PB_Shortcut_Tab
            ForEach List()
              If List()\Widget = List()\Widget\Focus
                Result | CallBack(List()\Widget, #PB_EventType_LostFocus);, Canvas) 
                NextElement(List())
                ;Debug List()\Widget
                Result | CallBack(List()\Widget, #PB_EventType_Focus);, Canvas) 
                Break
              EndIf
            Next
        EndSelect
    EndSelect
    
    Select EventType()
      Case #PB_EventType_Repaint : Result = EventData()
      Case #PB_EventType_Resize : Result = EventData()
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          If Canvas = List()\Widget\Canvas\Gadget
            Result | CallBack(List()\Widget, EventType()) 
          EndIf
        Next
    EndSelect
    
    If Result 
      Text::ReDraw(0, Canvas, winBackColor)
    EndIf
    
  EndProcedure
  
  Procedure Widget_Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget " +  EventType()
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget " + EventType()
      EndIf
    EndIf
    
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 615, 310, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define height, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
    winBackColor = GetWindowBackgroundColor(WindowID(0))
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      height = 19
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      height = 18
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux ; 
      height = 19
      LoadFont(0, "monospace", 10)
      SetGadgetFont(-1,FontID(0))
    CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, height, "StringGadget to right")
    StringGadget(3, 8,  85, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 135, 290, height, "Borderless & read-only StringGadget", #PB_String_BorderLess|#PB_String_ReadOnly)
    StringGadget(6, 8, 160, 290, height, "Password", #PB_String_Password)
    StringGadget(7, 8,  185, 290, height, "")
    StringGadget(8, 8,  210, 290, 90, Text)
    
    Define i
    For i=0 To 8
      BindGadgetEvent(i, @Widget_Events())
    Next
    
    SetGadgetText(6, "GaT")
    
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
    
    ; Demo draw string on the canvas
    CanvasGadget(10,  305, 0, 310, 310, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, height, "Normal StringGadget...",0,8)
    *S_1 = Create(10, -1, 8,  35, 290, height, "123-only-4567", #PB_Flag_Flat|#PB_Text_Numeric|#PB_Text_Center)
    *S_2 = Create(10, -1, 8,  60, 290, height, "StringGadget to right", #PB_Flag_Single|#PB_Text_Right)
    *S_3 = Create(10, -1, 8,  85, 290, height, "LOWERCASE...", #PB_Flag_Double|#PB_Text_LowerCase)
    *S_4 = Create(10, -1, 8, 110, 290, height, "uppercase...", #PB_Flag_Raised|#PB_Text_UpperCase)
    *S_5 = Create(10, -1, 8, 135, 290, height, "Borderless & read-only StringGadget", #PB_Flag_BorderLess|#PB_Text_ReadOnly)
    *S_6 = Create(10, -1, 8, 160, 290, height, "Password", #PB_Text_Password)
    *S_7 = Create(10, -1, 8, 185, 290, height, "")
    *S_8 = Create(10, -1, 8,  210, 290, 90, Text);, #PB_Text_Top)
                                                 ; *S_7 = Create(10, -1, 8,  200, 290, height, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh");, #PB_Text_Numeric|#PB_Text_Center)
    
    SetText(*S_6, "GaT")
    Debug "password: "+GetText(*S_6)
    
    ;     SetColor(*S_1, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_2, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_3, #PB_Gadget_BackColor, $FFF0F0F0)
    ;     SetColor(*S_4, #PB_Gadget_BackColor, $FFF0F0F0)
    
    BindEvent(#PB_Event_Widget, @Widget_Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------0-------
; EnableXP