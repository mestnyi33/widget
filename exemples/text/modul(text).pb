CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget"
CompilerEndIf


CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "colors.pbi"
CompilerEndIf


;-
DeclareModule Text
  
  EnableExplicit
  UseModule Constants
  UseModule Structures
  #__sOC = SizeOf(Character)
  
  ;- DECLAREs
  Declare.i Draw(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i SetText(*This._s_widget, Text.s)
  Declare.i SetFont(*This._s_widget, FontID.i)
  Declare.i GetColor(*This._s_widget, ColorType.i)
  Declare.i SetColor(*This._s_widget, ColorType.i, Color.i)
  Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
  
  Declare.i Widget(*This._s_widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  
EndDeclareModule

Module Text
  ;- PROCEDUREs
  Procedure.s Wrap (text$, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
    Protected line$, ret$="", LineRet$=""
    Protected.i CountString, i, start, found, length
    
    ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
    ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
    ;     text$ = ReplaceString(text$, #CR$, #LF$)
    ;     text$ + #LF$
    ;     
    ;CountString = CountString(text$, #LF$) 
    Protected *str.Character = @text$
    Protected *end.Character = @text$
    
    While *end\c 
      If *end\c = #LF
        start = (*end-*str) >> #PB_Compiler_Unicode
        ; Debug ""+start +" "+ Str((*end-*str)) +" "+ Str((*end-*str) / #__sOC) +" "+ #PB_Compiler_Unicode +" "+ #__sOC
        
        line$ = PeekS (*str, start)
        
        ;           For i = 1 To CountString
        ;       line$ = StringField(text$, i, #LF$)
        ;       start = Len(line$)
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
          For found = length To 1 Step - 1
            If FindString(" ", Mid(line$, found,1))
              start = found
              Break
            EndIf
          Next
          
          If found = 0 
            start = length
          EndIf
          
          ; LineRet$ + Left(line$, start) + nl$
          ret$ + Left(line$, start) + nl$
          line$ = LTrim(Mid(line$, start+1))
          start = Len(line$)
          
          If length <> start
            length = start
            
            ; Get text len
            While length > 1
              If width > TextWidth(RTrim(Left(line$, length)))
                Break
              Else
                length - 1 
              EndIf
            Wend
          EndIf
        Wend
        
        ret$ + line$ + nl$
        ;         ret$ +  LineRet$ + line$ + nl$
        ;         LineRet$=""
        *str = *end + #__sOC 
      EndIf 
      
      *end + #__sOC 
    Wend
    
    ;     Next
    
    ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
  EndProcedure
  
  
  Procedure.i Draw(*This._s_widget)
    Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
    Protected IT,Text_Y,Text_X,TxtHeight,Width,Height
    
    With *This
      If Not \Hide
        If \text\fontID : DrawingFont(\text\fontID) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\color\Back[\color\state])
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          TxtHeight=\Text\Height
          
          If \Vertical
            Width = \Height[1]-\Text\X*2
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \text\multiLine
            String.s = Text::Wrap(\Text\String.s, Width, \text\multiLine)
            CountString = CountString(String, #LF$)
          Else
            String.s = \Text\String.s
            CountString = 1
          EndIf
          
          If CountString
            If \Text\Align\Bottom
              Text_Y=(Height-(\Text\Height*CountString)-Text_Y) 
            ElseIf \Text\Align\vertical 
              Text_Y=((Height-(\Text\Height*CountString))/2)
            EndIf
            
            Static ch, tw
            
            For IT = 1 To CountString
              If \Text\Y+Text_Y < \bs : Text_Y+TxtHeight : Continue : EndIf
              
              String4 = StringField(String, IT, #LF$)
              StringWidth = TextWidth(RTrim(String4))
              
              If \Text\Align\Right
                Text_X=(Width-StringWidth-\Text\X) 
              ElseIf \Text\Align\horizontal 
                If ch <> CountString
                  ch = CountString
                  tw = Width
                EndIf
                Text_X=(Width-tw)/2+(tw-StringWidth)/2
              EndIf
              
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Vertical
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String4.s, 270, \Color\Front[\color\state])
                Text_Y+TxtHeight : If Text_Y > (Height) : Break : EndIf
              Else
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String4.s, \Color\Front[\color\state])
                Text_Y+TxtHeight : If Text_Y > (Height-TxtHeight) : Break : EndIf
              EndIf
              
            Next
          EndIf
          
        EndIf
        
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Frame[\color\state])
        EndIf
        
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure.s GetText(*This._s_widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(*This._s_widget, Text.s)
    Protected Result
    Text = ReplaceString(Text, #LFCR$, #LF$)
    Text = ReplaceString(Text, #CRLF$, #LF$)
    Text = ReplaceString(Text, #CR$, #LF$)
    Text + #LF$
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This._s_widget, FontID.i)
    Protected Result
    
    If *This\text\fontID <> FontID
      *This\text\fontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This._s_widget, ColorType.i, Color.i)
    Protected Result
    
    With *This
      Select ColorType
        Case #__color_line
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #__color_back
          If \color\Back <> Color 
            \color\Back = Color
            Result = #True
          EndIf
          
        Case #__color_front
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #__color_frame
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This._s_widget, ColorType.i)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #__color_line  : Color = \Color\Line
        Case #__color_back  : Color = \Color\Back
        Case #__color_front : Color = \Color\Front
        Case #__color_frame : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
    Protected Result
    
    With *This
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bs
        \X[1]=\X[2]-\fs
        Result = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bs
        \Y[1]=\Y[2]-\fs
        Result = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bs*2
        \Width[1] = \Width[2]+\fs*2
        Result = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bs*2
        \Height[1] = \Height[2]+\fs*2
        Result = 4
      EndIf
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure.i CallBack(*This._s_widget, EventType.i, MouseX.i, MouseY.i)
    Protected Result
    
    With *This
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure Widget(*This._s_widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \fs = Bool(Flag&#PB_Text_Border)
        \bs = \fs
        
        If Resize(*This, X,Y,Width,Height)
          \color\Frame = $C0C0C0
          \color\Back = $F0F0F0
          
          If \Vertical
            \Text\X = \fs 
            \Text\y = \fs+4 ; 2,6,1
          Else
            \Text\X = \fs+4 ; 2,6,12 
            \Text\y = \fs
          EndIf
          
          \Text\Align\vertical = 0
          \Text\Align\horizontal = 1
          \Text\multiline =- 1
          
          SetText(*This, Text)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Text
  UseModule structures
  UseModule constants
  
  
  Global *Text._s_widget = AllocateStructure(_s_widget)
  
  Procedure Canvas_CallBack()
    Select EventType()
      Case #PB_EventType_Resize
        If Resize(*Text, #PB_Ignore, #PB_Ignore, GadgetWidth(EventGadget()), #PB_Ignore)
          If StartDrawing(CanvasOutput(EventGadget()))
            Draw(*Text)
            StopDrawing()
          EndIf
        EndIf
        
    EndSelect
  EndProcedure
  
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    ResizeGadget(16, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
    ; PostEvent(#PB_Event_Gadget, 0,16, #PB_EventType_Resize)
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
    
    ;*Text\root\Canvas\Gadget = g
    *Text\Type = #PB_GadgetType_Text
    *Text\text\fontID = GetGadgetFont(#PB_Default)
    
    Widget(*Text,0, 0, 380, 330, Text.s, #__text_Center);|#__text_Middle );| #__text_WordWrap);
    SetColor(*Text, #__color_back, $CCBFB4)
    SetColor(*Text, #__color_front, $D56F1A)
    SetFont(*Text, FontID(0))
    
    SetGadgetData(g, *Text)
    BindGadgetEvent(g, @Canvas_CallBack())
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -+---vv---
; EnableXP