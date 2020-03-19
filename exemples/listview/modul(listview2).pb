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
DeclareModule ListView
  
  EnableExplicit
  UseModule Constants
  UseModule Structures
  
  ;- DECLAREs
  Declare.i Draw(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i SetText(*This._s_widget, Text.s)
  Declare.i SetFont(*This._s_widget, FontID.i)
  Declare.i GetColor(*This._s_widget, ColorType.i)
  Declare.i SetColor(*This._s_widget, ColorType.i, Color.i)
  Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
  Declare.i CallBack(*This._s_widget, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This._s_widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i AddItem(*This._s_widget,Item.i,Text.s,Image.i=-1,Flag.i=0)
EndDeclareModule

Module ListView
  Procedure.i AddItem(*This._s_widget,Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static len.l
    Protected l.l, i.l
    
    If *this
      With *this  
        Protected string.s = \text\string + #LF$
        
        If Item > \count\items - 1
          Item = \count\items - 1
        EndIf
        
        If (Item > 0 And Item < \count\items - 1)
          Define *str.Character = @string 
          Define *end.Character = @string 
          len = 0
          
          While *end\c 
            If *end\c = #LF 
              
              If item = i 
                len + Item
                Break 
              Else
                ;Debug ""+ PeekS (*str, (*end-*str)/#__sOC) +" "+ Str((*end-*str)/#__sOC)
                len + (*end-*str)/#__sOC
              EndIf
              
              i+1
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
        EndIf
        
        \text\string = Trim(InsertString(string, Text.s+#LF$, len+1), #LF$)
        
        l = Len(Text.s) + 1
        \text\change = 1
        \text\len + l 
        Len + l
        
        ;_repaint_items_(*this)
        \count\items + 1
        
      EndWith
    EndIf
    
    ProcedureReturn *this\count\items
  EndProcedure
  
  ;- MACROS
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
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
        
        If \color\fore
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\color\Fore[\color\state],\color\Back[\color\state])
        Else
          DrawingMode(#PB_2DDrawing_Default)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\color\Back[\color\state])
        EndIf
        
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
            String.s = Wrap(\Text\String.s, Width, \text\multiLine)
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
              
              
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Vertical
                ; DrawRotatedText(\X[1]+\Text\Y+(Height-Text_Y)+2, \Y[1]+\Text\X+Text_X, String4.s, 270, \Color\Front[\color\state])
                DrawRotatedText((\X[1]+\Text\Y+Text_Y)-2, \Y[1]+\Text\X+width-Text_X, String4.s, 90, \Color\Front[\color\state])
                Text_Y+TxtHeight : If Text_Y > Height : Break : EndIf
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
    
    If *this\text\fontID <> FontID
      *this\text\fontID = FontID
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
          
        Case #__color_fore
          If \color\fore <> Color 
            \color\fore = Color
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
  
  Procedure.i CallBack(*This._s_widget, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Scroll._s_widget, Cursor, Drag
    
    With *This
      If Not \Hide
        If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
          If \color\state <> 1
            ;\color\state = 1
            Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
            Result = 1
          EndIf
          
          Select EventType
            Case #PB_EventType_LeftButtonUp 
              ;\color\state = 1
              Result = 1
              
            Case #PB_EventType_LeftButtonDown 
              ;\color\state = 2
              Result = 1
              
          EndSelect
        Else
          If \color\state <> 0
            ;\color\state = 0
            If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              ; Debug "Мышь находится снаружи"
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
            EndIf
            Result = 1
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure Widget(*This._s_widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \fs = Bool(Flag&#PB_Text_Border)
        \bs = \fs
        
        
        If Resize(*This, X,Y,Width,Height)
          \Vertical = Bool(Flag&#__text_Vertical)
          
          \color = colors::*this\grey1
          \color\state = 1
          
          \Text\MultiLine =- 1; Bool(Flag&#__text_WordWrap)
          
          If \Vertical
            \Text\X = \fs+2
            \Text\y = \fs+2 ; 2,6,1
          Else
            \Text\X = \fs+2 ; 2,6,12 
            \Text\y = \fs
          EndIf
          
;           \Text\align\horizontal=1
;           \Text\align\Vertical=1
         ; SetText(*This, Text)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule ListView
  UseModule structures
  UseModule constants
  
  
  Global *Button_0._s_widget = AllocateStructure(_s_widget)
  Global *Button_1._s_widget = AllocateStructure(_s_widget)
  
  Procedure Canvas_CallBack()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
;         If Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
;           Result = 1
;         EndIf
;         If Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore)
           Result = 1
;         EndIf
      Default
        
        If CallBack(*Button_0, EventType(), MouseX, MouseY, WheelDelta) 
          Result = 1
        EndIf
        If CallBack(*Button_1, EventType(), MouseX, MouseY, WheelDelta) 
          Result = 1
        EndIf
        
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height)
        Draw(*Button_0)
        Draw(*Button_1)
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(0, 0, 0, 325+80, 260, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g=1
    CanvasGadget(g,  10,10,305,240, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Button_0
      ;\Canvas\Gadget = g
      \Type = #PB_GadgetType_Text
      \text\FontID = GetGadgetFont(#PB_Default)
      
      Widget(*Button_0, 120, 10,  200, 100, "Button (Vertical)", #__text_Center|#__text_Middle|#PB_Text_Border | #__text_Vertical)
      
      Define LN = 150
      
      For a = 0 To LN
        AddItem (*Button_0, -1, "Item "+Str(a), 0,1)
      Next
    EndWith
    
    With *Button_1
      ;\Canvas\Gadget = g
      \Type = #PB_GadgetType_Text
      \text\FontID = GetGadgetFont(#PB_Default)
      
      Widget(*Button_1, 10, 10, 100,  200, "Button (horizontal)", #PB_Text_Border)
      For a = 0 To LN
        AddItem (*Button_1, -1, "Item "+Str(a), 0,1)
      Next
    
    EndWith
    
    BindGadgetEvent(g, @Canvas_CallBack())
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = v------------
; EnableXP