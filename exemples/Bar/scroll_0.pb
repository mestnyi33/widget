IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
      StopDrawing()
    EndIf
  EndIf
    
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  
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
  
  Procedure Canvas_CallBack()
    Protected Repaint, iWidth, iHeight
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
    EndSelect
    
    If CallBack(*Scroll\v, EventType(), MouseX, MouseY) : Repaint = #True : EndIf
    If CallBack(*Scroll\h, EventType(), MouseX, MouseY) : Repaint = #True : EndIf
    
    iWidth = X(*Scroll\v)
    iHeight = Y(*Scroll\h)
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      ClipOutput(0,0, iWidth, iHeight)
      DrawImage(ImageID(0), *Scroll\x, *Scroll\y)
      UnclipOutput()
      
      Draw(*Scroll\v)
      Draw(*Scroll\h)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 325, 160, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    CanvasGadget(1,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    ; SetGadgetData(1,0) ; set parent window
    
    Bars(*Scroll, 16, 7, 1)
    SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
    SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
        
    SetState(*Scroll\v, 150)
    SetState(*Scroll\h, 100)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @Canvas_CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP