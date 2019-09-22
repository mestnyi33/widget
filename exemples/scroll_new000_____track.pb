IncludePath "/Users/as/Documents/GitHub/Widget/exemples/"
XIncludeFile "scroll_new000_____.pb"


;
; Module name   : TrackBar
; Author        : mestnyi
; Last updated  : Aug 7, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule TrackBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Coordinate
    y.l[4]
    x.l[4]
    Height.l[4]
    Width.l[4]
  EndStructure
  
  Structure Mouse
    X.l
    Y.l
    Buttons.l
  EndStructure
  
  Structure Canvas
    Mouse.Mouse
    Gadget.l
    Window.l
  EndStructure
  
  Structure Gadget Extends Coordinate
    Canvas.Canvas
    
    Text.s[3]
    ImageID.l[3]
    ;Color.Scroll::_s_color[3]
    Color.l[3]
    Ticks.b
    
    Image.Coordinate
    
    fSize.l
    bSize.l
    
    *Scroll.Scroll::_S_widget
    
    Type.l
    InnerCoordinate.Coordinate
    
    Repaint.l
    
    List Items.Gadget()
    List Columns.Gadget()
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.l)
  Declare SetState(Gadget.l, State.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.l=0)
  
EndDeclareModule

Module TrackBar
  
  ;- PROCEDURE
  
  Procedure Re(*This.Gadget)
    If Not *This\Repaint : *This\Repaint = #True : EndIf
    
;     Scroll::SetAttribute(*This\Scroll, #PB_ScrollBar_Maximum, *This\Scroll\Max)
;     Scroll::SetAttribute(*This\Scroll, #PB_ScrollBar_PageLength, *This\Scroll\Page\Len)
    Scroll::Resize(*This\Scroll, *This\X[2], *This\Y[2], *This\Width[2], *This\Height[2])
    
  EndProcedure
  
  Procedure Draw(*This.Gadget)
    With *This\Scroll
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          DrawingFont(GetGadgetFont(#PB_Default))
        CompilerEndIf
        
        If Not \Hide
          Protected s = 3, p=0
          If \Vertical
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+p,\Y+(\thumb\pos+\thumb\len-3),s,\Height-(\thumb\pos+\thumb\len-3),\Color[3]\frame[2])
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+5+p,\Y,s,\thumb\pos-1,\Color[3]\frame)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X+(\thumb\pos+\thumb\len-3),\Y+5+p,\Width-(\thumb\pos+\thumb\len-3),s,\Color[3]\frame)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\X,\Y+5+p,\thumb\pos-1,s,\Color[3]\frame[2])
          EndIf
          
;           If \Vertical
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+5+1,\Y+(\thumb\pos+\thumb\len-3),2,\Height-(\thumb\pos+\thumb\len-3),\Color[3]\frame[2])
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+5+1,\Y,2,\thumb\pos-1,\Color[3]\frame)
;           Else
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(*This\X,*This\Y,*This\Width,*This\Height,\Color\Back)
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X+(\thumb\pos+\thumb\len-3),\Y+5+1,\Width-(\thumb\pos+\thumb\len-3),2,\Color[3]\frame)
;             
;             DrawingMode(#PB_2DDrawing_Outlined)
;             Box(\X,\Y+5+1,\thumb\pos-1,2,\Color[3]\frame[2])
;           EndIf
          
          If *This\Ticks
            Protected i, ii.f, _thumb_ = (\thumb\len/2-2)
            For i=0 To \page\end
              ii = (\area\pos + Round(((i)-\min) * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
              LineXY(\X+ii,\button[3]\y+\button[3]\height-1,\X+ii,\button[3]\y+\button[3]\height-4,\Color[3]\Frame)
            Next
          EndIf
          
          Protected color_3 = \Color[3]\front[\color[1]\state+\color[2]\state]&$FFFFFF|\color\alpha<<24
          
          If \vertical
            If \direction<0
              color_3  = \Color[3]\frame[2]&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[3]\frame&$FFFFFF|\color\alpha<<24
            EndIf
          Else
            If \direction>0
              color_3  = \Color[3]\frame[2]&$FFFFFF|\color\alpha<<24
            Else
              color_3 = \Color[3]\frame&$FFFFFF|\color\alpha<<24
            EndIf
          EndIf
        
;           If \Vertical
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(\button[3]\x,\button[3]\y,\button[3]\width/2,\button[3]\height,\Color[3]\Back)
;             
;             Line(\button[3]\x,\button[3]\y,1,\button[3]\height,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y,\button[3]\width/2,1,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y+\button[3]\height-1,\button[3]\width/2,1,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width/2,\button[3]\y,\button[3]\width/2,\button[3]\height/2+1,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width/2,\button[3]\y+\button[3]\height-1,\button[3]\width/2,-\button[3]\height/2-1,\Color[3]\Frame)
;             
;           Else
;             DrawingMode(#PB_2DDrawing_Default)
;             Box(\button[3]\x,\button[3]\y,\button[3]\width,\button[3]\height/2,\Color[3]\Back)
;             
;             Line(\button[3]\x,\button[3]\y,\button[3]\width,1,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y,1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x,\button[3]\y+\button[3]\height/2,\button[3]\width/2+1,\button[3]\height/2,\Color[3]\Frame)
;             Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2,-\button[3]\width/2-1,\button[3]\height/2,\Color[3]\Frame)
;           EndIf
          
          If \Vertical
            Line(\button[3]\x,\button[3]\y+2,\button[3]\width/2+4,1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height-2-1,\button[3]\width/2+4,1,color_3)
            
            If \thumb\len <> 7
              Line(\button[3]\x,\button[3]\y+\button[3]\height/2,\button[3]\width/2+7,1,color_3)
            EndIf
            
            Line(\button[3]\x,\button[3]\y,1,\button[3]\height,color_3)
            Line(\button[3]\x,\button[3]\y,\button[3]\width/2,1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height-1,\button[3]\width/2,1,color_3)
            Line(\button[3]\x+\button[3]\width/2,\button[3]\y,\button[3]\width/2,\button[3]\height/2+1,color_3)
            Line(\button[3]\x+\button[3]\width/2,\button[3]\y+\button[3]\height-1,\button[3]\width/2,-\button[3]\height/2-1,color_3)
            
          Else
            Line(\button[3]\x+2,\button[3]\y,1,\button[3]\height/2+3,color_3)
            Line(\button[3]\x+\button[3]\width-2-1,\button[3]\y,1,\button[3]\height/2+3,color_3)
            
            If \thumb\len <> 7
              Line(\button[3]\x+\button[3]\width/2,\button[3]\y,1,\button[3]\height/2+6,color_3)
            EndIf
            
            Line(\button[3]\x,\button[3]\y,\button[3]\width,1,color_3)
            Line(\button[3]\x,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y,1,\button[3]\height/2-1,color_3)
            Line(\button[3]\x,\button[3]\y+\button[3]\height/2-1,\button[3]\width/2+1,\button[3]\height/2,color_3)
            Line(\button[3]\x+\button[3]\width-1,\button[3]\y+\button[3]\height/2-1,-\button[3]\width/2-1,\button[3]\height/2,color_3)
          EndIf
          
          If \Focus
            For i=0 To \Area\len+\Thumb\len+2 Step 2
              Line(*This\X,*This\Y+i,1,1,\Color[3]\Frame[3])
              Line(*This\X+*This\Width-1,*This\Y+i,1,1,\Color[3]\Frame[3])
              
              Line(*This\X+i,*This\Y,1,1,\Color[3]\Frame[3])
              Line(*This\X+i,*This\Y+*This\Height-1,1,1,\Color[3]\Frame[3])
            Next
          EndIf
          
          StopDrawing()
        EndIf
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure ReDraw(*This.Gadget)
    Re(*This)
    Draw(*This)
  EndProcedure
  
  
  Procedure CallBack()
    Static LastX, LastY
    Protected *This.Gadget = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Re(*This)
          
      EndSelect
      
      *This\Repaint = Scroll::CallBack(*This\Scroll, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If *This\Repaint 
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
    
    ; Draw(*This)
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetAttribute(*This\Scroll, Attribute, Value)
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.l, Attribute.l)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
        Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
        Case #PB_ScrollBar_PageLength : Result = \Scroll\Page\len
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.l, State.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetState(*This\Scroll, State)
        ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      ScrollPos = \Scroll\Page\Pos
      ;If (\Scroll\Vertical And \Scroll\Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Scroll\Max-\Scroll\Min)-ScrollPos) : EndIf
      ProcedureReturn ScrollPos
    EndWith
  EndProcedure
  
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.l=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected Pagelength.l
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        
        \Type = #PB_GadgetType_TrackBar
        \Ticks = Bool(Flag&#PB_TrackBar_Ticks)
        
        \fSize = 2
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
        
        \Color[0] = $FFFFFF
        \Color[1] = $C0C0C0
        \Color[2] = $F0F0F0
        
        *This\Scroll = Scroll::Gadget(0, 0, 0, 0, Min, Max, PageLength, Bool(Flag&#PB_TrackBar_Vertical)|Scroll::#PB_Bar_NoButtons)
        If Bool(Flag&#PB_TrackBar_Vertical)
          *This\Scroll\inverted = 1
        EndIf
        
        
        *This\Scroll\Type = \Type
        *This\Scroll\Button\Len = 9
       ; *This\Scroll\thumb\Len = 9
;         *This\Scroll\Color\Line[0] = $CBCBCB
;         *This\Scroll\Color\Line[1] = *This\Scroll\Color\Line
;         *This\Scroll\Color\Line[2] = *This\Scroll\Color\Line
;         *This\Scroll\Color\Line[3] = *This\Scroll\Color\Line
       ; Scroll::Resize(*this\Scroll, X,Y,Width,Height)
    
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
Define a,i


Procedure v_GadgetCallBack()
  TrackBar::SetState(12, GetGadgetState(EventGadget()))
EndProcedure

Procedure v_CallBack()
  SetGadgetState(2, TrackBar::GetState(EventGadget()))
EndProcedure

Procedure h_GadgetCallBack()
  TrackBar::SetState(11, GetGadgetState(EventGadget()))
EndProcedure

Procedure h_CallBack()
  SetGadgetState(1, TrackBar::GetState(EventGadget()))
EndProcedure


If OpenWindow(0, 0, 0, 605, 200, "TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget    (-1, 10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TrackBarGadget(0, 10,  40, 250, 20, 0, 10000)
  SetGadgetState(0, 5000)
  TextGadget    (-1, 10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TrackBarGadget(1, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  SetGadgetState(1, 3000)
  TextGadget    (-1,  90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBarGadget(2, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  SetGadgetState(2, 8000)
  
  TextGadget    (-1, 300+10,  20, 250, 20,"TrackBar Standard", #PB_Text_Center)
  TrackBar::Gadget(10, 300+10,  40, 250, 20, 0, 10000)
  TrackBar::SetState(10, 5000)
  TextGadget    (-1, 300+10, 100, 250, 20, "TrackBar Ticks", #PB_Text_Center)
  TrackBar::Gadget(11, 300+10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
  TrackBar::SetState(11, 3000)
  TextGadget    (-1,  300+90, 180, 200, 20, "TrackBar Vertical", #PB_Text_Right)
  TrackBar::Gadget(12, 300+270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
  TrackBar::SetState(12, 8000)
  
  BindGadgetEvent(1,@h_GadgetCallBack())
  BindGadgetEvent(11,@h_CallBack(), #PB_EventType_Change)
  BindGadgetEvent(2,@v_GadgetCallBack())
  BindGadgetEvent(12,@v_CallBack(), #PB_EventType_Change)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -8-----
; EnableXP