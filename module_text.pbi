CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
CompilerEndIf

;-
DeclareModule Text
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  
  ;- DECLAREs
  Declare.i Draw(*This.Widget, Canvas.i=-1)
  Declare.s GetText(*This.Widget)
  Declare.i SetText(*This.Widget, Text.s)
  Declare.i SetFont(*This.Widget, FontID.i)
  Declare.i GetColor(*This.Widget, ColorType.i)
  Declare.i SetColor(*This.Widget, ColorType.i, Color.i)
  Declare.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  ;Declare.i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i)
  Declare.i Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  
EndDeclareModule

Module Text
  
  ;- MACROS
  ;- PROCEDUREs
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
  
  Procedure.i _Draw(*This.Widget, Canvas.i=-1)
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
        BoxGradient(\Vertical,\X[2],\Y[2],\Width[2],\Height[2],\Color[1]\Fore,\Color[1]\Back,\Radius)
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          If \Text\Vertical
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
              \Text\String.s[1] = Wrap(\Text\String.s, Width, 1)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            Else
              \Text\String.s[1] = Wrap(\Text\String.s, Width, 0)
              ;  \Text\String.s[1] = \Text\String.s
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
            If \Text\Vertical
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
                  If Width > StringWidth
                    Text_X=(Width-StringWidth)/2
                  EndIf
                EndIf
                
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
              Next
            EndIf
          EndIf
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
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1], \Radius, \Radius, \Color[1]\Frame)
        EndIf
        
      EndIf
    EndWith 
    
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
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore,\Color[1]\Back)
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          If \Resize
            If \Text\Vertical
              Width = \Height[1]-\Text\X*2
              Height = \Width[1]-\Text\y*2
            Else
              Width = \Width[1]-\Text\X*2
              Height = \Height[1]-\Text\y*2
            EndIf
            
            If \Text\MultiLine
              \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, -1)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            ElseIf \Text\WordWrap
              \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, 1)
              \Text\CountString = CountString(\Text\String.s[1], #LF$)
            Else
              ;  \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, 0)
              \Text\String.s[1] = \Text\String.s
              \Text\CountString = 1
            EndIf
            
            If \Text\CountString
              If \Text\Align\Bottom
                Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
              ElseIf \Text\Align\Vertical
                Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
              EndIf
              
              ClearList(\Items())
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Text\Vertical
                For IT = \Text\CountString To 1 Step - 1
                  If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                  
                  String = StringField(\Text\String.s[1], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
                  \Items()\Text\Vertical = \Text\Vertical
                  \Items()\Text\x = \X[1]+\Text\Y+Text_Y+\Text\Height
                  \Items()\Text\y = \Y[1]+\Text\X+Text_X
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  ;DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
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
                  
                  AddElement(\Items())
                  \Items()\Text\x = \X[1]+\Text\X+Text_X
                  \Items()\Text\y = \Y[1]+\Text\Y+Text_Y
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  ;DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                  Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
                Next
              EndIf
            EndIf
            
            \Resize = #False
          EndIf
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
      
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
        ClipOutput(\X[2],\Y[2],\Width[2],\Height[2]) ; Bug in Mac os
      CompilerEndIf
    EndWith 
    
    
    If ListSize(*This\Items())
      With *This\Items()
        PushListPosition(*This\Items())
        ForEach *This\Items()
          If \Text\String.s
            If \Text\FontID 
              DrawingFont(\Text\FontID) 
            EndIf
            If \Text[1]\Change And \Text[1]\String.s
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              \Text[2]\X = \Text[0]\X+\Text[1]\Width
              \Text[1]\Change = #False
            EndIf
            If \Text[2]\Change And \Text[2]\String.s
              \Text[2]\Width = TextWidth(\Text[2]\String.s)
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
              \Text[2]\Change = #False
            EndIf 
            
            If \Text[2]\Len
              If \Text[1]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                If \Text\Vertical
                  DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[1]\String.s, 270, *This\Color\Front)
                Else
                  DrawText(\Text[0]\X, \Text[0]\Y, \Text[1]\String.s, *This\Color\Front)
                EndIf
              EndIf
              If \Text[2]\String.s
                DrawingMode(#PB_2DDrawing_Default)
                If \Text[0]\String.s = \Text[1]\String.s+\Text[2]\String.s
                  Box(\Text[2]\X, \Text[0]\Y,*This\width[2], \Text[0]\Height, $D77800)
                Else
                  Box(\Text[2]\X, \Text[0]\Y, \Text[2]\Width, \Text[0]\Height, $D77800)
                EndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                If \Text\Vertical
                  DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[2]\String.s, 270, *This\Color\Front)
                Else
                  DrawText(\Text[2]\X, \Text[0]\Y, \Text[2]\String.s, $FFFFFF)
                EndIf
              EndIf
              If \Text[3]\String.s
                DrawingMode(#PB_2DDrawing_Transparent)
                If \Text\Vertical
                  DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[3]\String.s, 270, *This\Color\Front)
                Else
                  DrawText(\Text[3]\X, \Text[0]\Y, \Text[3]\String.s, *This\Color\Front)
                EndIf
              EndIf
            Else
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Text\Vertical
                DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[0]\String.s, 270, *This\Color\Front)
              Else
                DrawText(\Text[0]\X, \Text[0]\Y, \Text[0]\String.s, *This\Color\Front)
              EndIf
            EndIf
          EndIf
        Next
        PopListPosition(*This\Items()) ; 
        
        If *This\Focus = *This And \Text[0]\CaretPos=\Text[0]\CaretPos[1] 
          DrawingMode(#PB_2DDrawing_XOr)             
          Line(\Text[0]\X + \Text[1]\Width, \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
        EndIf
      EndWith  
    EndIf
    
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
  
  Procedure.i CallBack(*This.Widget, EventType.i, MouseX.i, MouseY.i)
    Protected Result
    
    With *This
      If \Type = #PB_GadgetType_Text
        
      EndIf
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        
        Flag|#PB_Text_MultiLine
        
        If Not \Text\FontID : \Text\FontID = GetGadgetFont(#PB_Default) : EndIf
        
        \fSize = Bool(Flag&#PB_Text_Border)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          ;\Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          
          
          If \Text\Editable
            \Color[1]\Back = $FFFFFF 
          Else
            \Color[1]\Back = $F0F0F0  
          EndIf
          \Color[1]\Frame = $C0C0C0
          
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+4 ; 2,6,12
          Else
            \Text\X = \fSize+4 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          If Bool(Flag&#PB_Text_Center) : \Text\Align\Horisontal=1 : EndIf
          If Bool(Flag&#PB_Text_Middle) : \Text\Align\Vertical=1 : EndIf
          If Bool(Flag&#PB_Text_Right)  : \Text\Align\Right=1 : EndIf
          If Bool(Flag&#PB_Text_Bottom) : \Text\Align\Bottom=1 : EndIf
          
          \Text\String.s = Text.s
          \Text\Change = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile =99
  UseModule Text
  Global *T_0.Widget = AllocateStructure(Widget)
  Global *T_1.Widget = AllocateStructure(Widget)
  Global *T_2.Widget = AllocateStructure(Widget)
  Global *T_3.Widget = AllocateStructure(Widget)
  Global *T_4.Widget = AllocateStructure(Widget)
  
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
  Global *Text.Widget = AllocateStructure(Widget)
  
  Procedure Canvas_CallBack()
    Select EventType()
      Case #PB_EventType_Resize
        If Resize(*Text, #PB_Ignore, #PB_Ignore, GadgetWidth(EventGadget()), #PB_Ignore, EventGadget())
          If StartDrawing(CanvasOutput(EventGadget()))
            Draw(*Text, EventGadget())
            StopDrawing()
          EndIf
        EndIf
        
    EndSelect
  EndProcedure
  
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    ResizeGadget(16, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  Define cr.s = #LF$
  LoadFont(0, "Courier", 14)
  Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  ; Debug "len - "+Len(Text)
  
  If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
    TextGadget(0, 10, 10, 380, 330, Text.s, #PB_Text_Center) 
    ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
    SetGadgetColor(0, #PB_Gadget_BackColor, $CCBFB4)
    SetGadgetColor(0, #PB_Gadget_FrontColor, $D57A2E)
    SetGadgetFont(0,FontID(0) )
    
    g=16
    CanvasGadget(g, 10, 350, 380, 330) 
    
    *Text\Canvas\Gadget = g
    *Text\Type = #PB_GadgetType_Text
    *Text\Text\FontID = GetGadgetFont(#PB_Default)
    
    Widget(*Text,g, 0, 0, 380, 330, Text.s, #PB_Text_Center);|#PB_Text_Bottom );| #PB_Text_WordWrap);
    SetColor(*Text, #PB_Gadget_BackColor, $CCBFB4)
    SetColor(*Text, #PB_Gadget_FrontColor, $D56F1A)
    SetFont(*Text, FontID(0))
    
    SetGadgetData(g, *Text)
    BindGadgetEvent(g, @Canvas_CallBack())
    ;Draw(*This)
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 426
; FirstLine = 213
; Folding = -----4--------------
; EnableXP