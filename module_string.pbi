CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
CompilerEndIf

;-
DeclareModule String
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  ;   Structure Struct Extends Structures::Widget
  ;     List Items.Structures::Widget()
  ;   EndStructure
  
  ;- DECLAREs
  Declare.i Draw(*This.Widget, Canvas.i=-1)
  Declare.s GetText(*This.Widget)
  Declare.i SetText(*This.Widget, Text.s)
  Declare.i SetFont(*This.Widget, FontID.i)
  Declare.i GetColor(*This.Widget, ColorType.i)
  Declare.i SetColor(*This.Widget, ColorType.i, Color.i)
  Declare.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  
EndDeclareModule

Module String
  
  ;- MACROS
  ;- PROCEDUREs
  Procedure Caret(*This.Widget)
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If ListSize(\Items())
        X = \Items()\X+\Items()\Text\x
        Len = \Items()\Text\Len
        FontID = \Items()\Text\FontID
        String.s = \Items()\Text\String.s
      Else
        X = \X[2]+\Text\x
        Len = \Text\Len
        FontID = \Text\FontID
        String.s = \Text\String.s
      EndIf
      
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
    EndWith
    
    ProcedureReturn Position
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
        For ii = length To 0 Step - 1
          If mode =- 1 And CountString(Left((line$),ii), " ") > 1      And width > 71 ; button
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
    
    ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
  EndProcedure
  
  Procedure.i Draw(*This.Widget, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    With *This
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas <> \Canvas\Gadget
        ProcedureReturn
      EndIf
      
      If Not \Hide
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore,\Color[1]\Back)
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          If \Vertical
            Width = \Height[1]-\Text\X*2
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \Resize
            If \Text\MultiLine
              \Text\String.s[1] = Wrap(\Text\String.s, Width)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            ElseIf \Text\WordWrap
              \Text\String.s[1] = Wrap(\Text\String.s, Width, 0)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            Else
              \Text\String.s[1] = \Text\String.s
              \Text\CountString = 1
            EndIf
            \Resize = #False
          EndIf
          
          If \Text\CountString
            If \Text\Align\Bottom
              Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
            ElseIf \Text\Align\Vertical
              Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent)
            If \Vertical
              For IT = \Text\CountString To 1 Step - 1
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[1], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  Text_X=(Width-StringWidth)/2 
                EndIf
                
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Width) : Break : EndIf
              Next
            Else
              For IT = 1 To \Text\CountString
                If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                
                String = StringField(\Text\String.s[1], IT, #LF$)
                StringWidth = TextWidth(RTrim(String))
                
                If \Text\Align\Right
                  Text_X=(Width-StringWidth) 
                ElseIf \Text\Align\Horisontal
                  Text_X=(Width-StringWidth)/2 
                EndIf
                
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
              Next
            EndIf
          EndIf
        EndIf
        
        
        If \Text\String.s
          If \Text[1]\String.s
            \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            \Text[2]\X = \Text[0]\X+\Text[1]\Width
          EndIf
          If \Text[2]\String.s
            \Text[2]\Width = TextWidth(\Text[2]\String.s)
            \Text[3]\X = \Text[2]\X+\Text[2]\Width
          EndIf 
        EndIf
        
        If \Text\CaretPos=\Text\CaretPos[1] ; And Property_GadgetTimer( 300 )
          DrawingMode(#PB_2DDrawing_XOr)             
          Line(\X[2]+\Text[0]\X + \Text[1]\Width, \Y[2]+\Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
          EndIf
        ;         DrawingMode(\DrawingMode)
        ;         If \Width > \Text\X
        ;           BoxGradient(\Vertical,\X[1],\Y[1]+\Text\Y,\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Width[1]-\Text\X,\Y[1],\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;         If \Height > \Text\Y
        ;           BoxGradient(\Vertical,\X[1],\Y[1],\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Text\X,\Y[1]+\Height[1]-\Text\Y,\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;       
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Frame)
        EndIf
        
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    Protected Result
    
    With *This
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas <> \Canvas\Gadget
        ProcedureReturn
      EndIf
      
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        Result = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        Result = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        Result = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        Result = 4
      EndIf
      
      \Resize = Result
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  
  Procedure.s GetText(*This.Widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(*This.Widget, Text.s)
    Protected Result
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This.Widget, FontID.i)
    Protected Result
    
    If *This\Text\FontID <> FontID
      *This\Text\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget, ColorType.i, Color.i)
    Protected Result
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_BackColor
          If \Color\Back <> Color 
            \Color\Back = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrontColor
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrameColor
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This.Widget, ColorType.i)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line
        Case #PB_Gadget_BackColor  : Color = \Color\Back
        Case #PB_Gadget_FrontColor : Color = \Color\Front
        Case #PB_Gadget_FrameColor : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
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
        
        \Text[1]\String.s = Left(\Text\String.s, CaretPos)
        
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
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
        
        \Text[1]\String.s = Left(\Text\String.s, CaretPos)
        
        If \Text[2]\Len
          \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
          \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
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
  
  Procedure.i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
    Static Text$, DoubleClickCaretPos =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Result, Buttons, Widget.i
    Static *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
    
    If Canvas=-1 
      Widget = *This
      Canvas = EventGadget()
    Else
      Widget = Canvas
    EndIf
    If Canvas <> *This\Canvas\Gadget
      ProcedureReturn
    EndIf
    
    If *This
      With *This
        \Canvas\Mouse\X = MouseX
        \Canvas\Mouse\Y = MouseY
        
        If Not \Hide And Not Drag
          If EventType <> #PB_EventType_MouseLeave And 
             (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
            
            If *Last <> *This  
              
              If *Last
                If *Last > *This
                  ProcedureReturn
                Else
                  *Widget = *Last
                  CallBack(*Widget, #PB_EventType_MouseLeave, 0, 0, 0)
                  *Last = *This
                EndIf
              Else
                *Last = *This
              EndIf
              
              \Buttons = 1
              If Not \Checked
                Buttons = \Buttons
              EndIf
              EventType = #PB_EventType_MouseEnter
              \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
              *Widget = *Last
              ; Debug "enter "+*Last\text\string+" "+EventType
            EndIf
            
          ElseIf *Last = *This
            ; Debug "leave "+*Last\text\string+" "+EventType+" "+*Widget
            If \Cursor[1] <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor[1])
              \Cursor[1] = 0
            EndIf
            EventType = #PB_EventType_MouseLeave
            *Last = 0
          EndIf
          
        ElseIf *Widget = *This
          If EventType = #PB_EventType_LeftButtonUp And *Last = *Widget And (MouseX<>#PB_Ignore And MouseY<>#PB_Ignore) 
            If Not (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
              CallBack(*Widget, Canvas, #PB_EventType_LeftButtonUp, #PB_Ignore, #PB_Ignore)
              EventType = #PB_EventType_MouseLeave
            Else
              CallBack(*Widget, Canvas, #PB_EventType_LeftButtonUp, #PB_Ignore, #PB_Ignore)
              EventType = #PB_EventType_LeftClick
            EndIf
            
            *Last = 0  
          EndIf
          
        EndIf
      EndWith
    EndIf
    
    If *Widget
      With *Widget
        
        If Not \Hide And Not \Disable
          
          Select EventType
            Case #PB_EventType_LostFocus : Repaint = #True
              \Text[2]\Len = 0 ; Убыраем выделение
              \Text\CaretPos[1] =- 1 ; Прячем коректор
              
            Case #PB_EventType_Focus : Repaint = #True
              \Text\CaretPos[1] = \Text\CaretPos ; Показываем коректор
              
            Case #PB_EventType_Input
              If \Text\Editable
                Protected Input, Input_2
                
                Select #True
                  Case \Text\Lower : Input = Asc(LCase(Chr(\Canvas\Input))) : Input_2 = Input
                  Case \Text\Upper : Input = Asc(UCase(Chr(\Canvas\Input))) : Input_2 = Input
                  Case \Text\Pass  : Input = 9679 : Input_2 = \Canvas\Input ; "●"
                  Case \Text\Numeric                                        ; : Debug Chr(\Canvas\Input)
                    Static Dot
                    
                    Select \Canvas\Input 
                      Case '.','0' To '9' : Input = \Canvas\Input : Input_2 = Input
                      Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
                      Default
                        Input_2 = \Canvas\Input
                    EndSelect
                    
                    If Not Dot And Input = '.'
                      Dot = 1
                    ElseIf Input <> '.'
                      Dot = 0
                    Else
                      Input = 0
                    EndIf
                    
                  Default
                    Input = \Canvas\Input : Input_2 = Input
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
              If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
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
  
  Procedure Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        
        Flag|#PB_Text_Middle
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        If Not \Text\FontID 
          \Text\FontID = FontID(LoadFont(-1, "Monaco spake", 12))
        EndIf
        
        \fSize = Bool(Not Flag&#PB_String_BorderLess)
        \bSize = \fSize
        
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Toggle = Bool(Flag&#PB_Button_Toggle)
          \Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          If \Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+2 ; 2,6,1
          Else
            \Text\X = \fSize+2 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          If \Text\Editable
            \Color[1]\Back[1] = $FFFFFF 
          Else
            \Color[1]\Back[1] = $F0F0F0  
          EndIf
          \Color[0]\Frame[1] = $BABABA
          
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
          
          ResetColor(*This)
          
          If Bool(Flag&#PB_Text_Center) : \Text\Align\Horisontal=1 : EndIf
          If Bool(Flag&#PB_Text_Middle) : \Text\Align\Vertical=1 : EndIf
          If Bool(Flag&#PB_Text_Right)  : \Text\Align\Right=1 : EndIf
          If Bool(Flag&#PB_Text_Bottom) : \Text\Align\Bottom=1 : EndIf
          
        EndIf
      EndIf
    EndWith
    
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
      Case #PB_EventType_Resize
        Result = 1
      Default
        
        Result | CallBack(*S_0, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_1, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_2, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_3, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_4, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_5, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_6, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*S_7, -1, EventType(), MouseX, MouseY) 
        
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $F0F0F0)
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
    
    CanvasGadget(10,  305, 0, 310, 235, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Default)
    
    Widget(*S_0, 10, 8,  10, 290, 20, "Normal StringGadget...")
    Widget(*S_1, 10, 8,  35, 290, 20, "1234567", #PB_Text_Numeric|#PB_Text_Center)
    Widget(*S_2, 10, 8,  60, 290, 20, "Read-only StringGadget", #PB_Text_ReadOnly|#PB_Text_Right)
    Widget(*S_3, 10, 8,  85, 290, 20, "LOWERCASE...", #PB_Text_LowerCase)
    Widget(*S_4, 10, 8, 110, 290, 20, "uppercase...", #PB_Text_UpperCase)
    Widget(*S_5, 10, 8, 140, 290, 20, "Borderless StringGadget", #PB_String_BorderLess)
    Widget(*S_6, 10, 8, 170, 290, 20, "Password", #PB_Text_Password)
    
    Widget(*S_7, 10, 8,  200, 290, 20, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh");, #PB_Text_Numeric|#PB_Text_Center)
    
    BindEvent(#PB_Event_Widget, @Events())
    
    BindGadgetEvent(10, @CallBacks())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 916
; FirstLine = 683
; Folding = ------------v0-38-------
; EnableXP