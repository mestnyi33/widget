IncludePath "../../../"
XIncludeFile "widgets.pbi"

;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=101,y=101, Width=600, Height=600 
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
      *Scroll\width = OutputWidth()
      *Scroll\height = OutputHeight()
      StopDrawing()
    EndIf
  EndIf
  
  Procedure.i Draw_Bars(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
    ;     Protected Repaint
    
    With *Scroll
      UnclipOutput()
      If \v And \v\page\len And \v\max<>ScrollHeight And 
         SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollHeight)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      If \h And \h\page\len And \h\max<>ScrollWidth And
         SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollWidth)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \v And Not \v\hide
        Draw(\v)
      EndIf
      If \h And Not \h\hide
        Draw(\h)
      EndIf
      
      
      DrawingMode(#PB_2DDrawing_Outlined)
      ; max coordinate
      Box(\h\x-GetState(\h), \v\y-GetState(\v), \h\Max, \v\Max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
      
      ; area coordinate
      Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
      
      ; scroll coordinate
      Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
      
      ; frame coordinate
      Box(\h\x, \v\y, 
          \h\Page\len + (Bool(Not \v\hide) * \v\width),
          \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
      
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  Procedure _Canvas_Events(Canvas.i, EventType.i)
    If EventType = #PB_EventType_ScrollChange ; bug mac os на функциях канваса GetGadgetAttribute()
      ProcedureReturn
    EndIf
    
    Protected Repaint, iWidth, iHeight
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Resizes(*Scroll, x, y, Width-x*2, Height-y*2)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; проверка
    EndSelect
    
    Repaint | CallBack(*Scroll\v, EventType)
    Repaint | CallBack(*Scroll\h, EventType)
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      
      ClipOutput(x,y, *Scroll\Width[2], *Scroll\Height[2])
      DrawImage(ImageID(0), x+*Scroll\x, y+*Scroll\y)
      UnclipOutput()
      
      Draw_Bars(*Scroll, *Scroll\Width, *Scroll\Height)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Resizes(*Scroll, x, y, Width-x*2, Height-y*2);, *Scroll\h)
        ;  Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
        
    EndSelect
    
    Repaint | CallBack(*Scroll\v, EventType, mouseX,mouseY)
    Repaint | CallBack(*Scroll\h, EventType, mouseX,mouseY)
    
    If Not (*Scroll\v\at Or *Scroll\h\at)
      Select EventType
        Case #PB_EventType_LeftButtonDown
          Debug "#PB_EventType_LeftButtonDown "
          SetAttribute(*Scroll\h, #PB_Bar_Inverted, *Scroll\h\Inverted!1)
          
          Repaint = 1
      EndSelect
    EndIf
    
    If *Scroll\v\Change
      ; An example showing the sending of messages in a vertical scrollbar.
      PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\v, #PB_EventType_ScrollChange, *Scroll\v\Direction) 
      
      ; An example showing the sending of messages to the gadget of both scrollbars.
      PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\v\Direction) 
;       *Scroll\v\Change = 0
    EndIf
    
    If *Scroll\h\Change
      ; An example showing the sending of messages in a horizontal scrollbar.
      PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\h, #PB_EventType_ScrollChange, *Scroll\h\Direction) 
      
      ; An example showing the sending of messages to the gadget of both scrollbars.
      PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\h\Direction) 
;       *Scroll\h\Change = 0
    EndIf
    
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      ; back ground
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,Width,Height, $FFFFFF)
      
;       ;       
;       If IsStop(*Scroll\v)
;         *Scroll\h\Color\Line = 0
;       Else
;         *Scroll\h\Color\Line = $FFFFFF
;       EndIf
;       
;       If IsStop(*Scroll\h)
;         *Scroll\v\Color\Line = 0
;       Else
;         *Scroll\v\Color\Line = $FFFFFF
;       EndIf
      
      ClipOutput(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Page\len, *Scroll\v\Page\len)
      ;DrawImage(ImageID(0), *Scroll\h\x-*Scroll\h\Page\Pos, *Scroll\v\y-*Scroll\v\Page\Pos)
      DrawImage(ImageID(0), *Scroll\h\x-GetState(*Scroll\h), *Scroll\v\y-GetState(*Scroll\v))
      UnclipOutput()
      
      Draw(*Scroll\v)
      Draw(*Scroll\h)
      
      ; frame 
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*Scroll\h\x-1,*Scroll\v\y-1,
          2 + Bool(*Scroll\v\hide) * *Scroll\h\Page\len + Bool(Not *Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\width)-*Scroll\h\x),
          2 + Bool(*Scroll\h\hide) * *Scroll\v\Page\len + Bool(Not *Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\height)-*Scroll\v\y), $0000FF)
      ;       ; 
      ;       Box(x, y, Width-x*2, Height-y*2, $0000FF)
      
      ; Scroll area coordinate ; (*Scroll\v\x-*Scroll\h\x)
      ;Box(*Scroll\h\x-*Scroll\h\Page\Pos, *Scroll\v\y-*Scroll\v\Page\Pos, *Scroll\h\Max, *Scroll\v\Max, $FF0000)
      ;Debug Str(((*Scroll\h\Max-*Scroll\h\Page\len)-*Scroll\h\Page\Pos))
      
       Box(*Scroll\h\x-GetState(*Scroll\h), *Scroll\v\y-GetState(*Scroll\v), *Scroll\h\Max, *Scroll\v\Max, $FF0000)
      
       ; page coordinate
       Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Page\Len, *Scroll\v\Page\Len, $00FF00)
       
       ; area coordinate
       Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\Area\Len, *Scroll\v\Area\Len, $00FFFF)
      
       ; scroll coordinate
       Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\width, *Scroll\v\height, $FF00FF)
      
       ; frame coordinate
       Box(*Scroll\h\x, *Scroll\v\y, 
           *Scroll\h\Page\len + (Bool(Not *Scroll\v\hide) * *Scroll\v\width),
           *Scroll\v\Page\len + (Bool(Not *Scroll\h\hide) * *Scroll\h\height), $FFFF00)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget_Events()
    Select EventType()
      Case #PB_EventType_ScrollChange
        Debug EventData()
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  Procedure.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
    With *Scroll     
      \v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_Vertical, Radius)
      \v\hide = \v\hide[1]
      ;\v\s = *Scroll
      
      If Both
        \h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
        \h\hide = \h\hide[1]
      Else
        \h.Widget_S = AllocateStructure(Bar_S)
        \h\hide = 1
      EndIf
      ;\h\s = *Scroll
    EndWith
    
    ProcedureReturn *Scroll
  EndProcedure
  
  If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1, 10,10, Width, Height, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
;     ; Create both scroll bars
;     *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
;     *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
    Bars(*Scroll, 16, 7, 1)
    SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
    SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
    
    ;SetAttribute(*Scroll\v, #PB_ScrollBar_Inverted, 1)
    
    ; Set scroll page position
    SetState(*Scroll\v, 70)
    SetState(*Scroll\h, 55)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @Canvas_CallBack())
    
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, *Scroll\v)
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, *Scroll\h)
    
    ;     BindEvent(#PB_Event_Widget, @Widget_Events(), 0, 1)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 4--0--
; EnableXP