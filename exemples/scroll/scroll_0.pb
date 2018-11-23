CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"

CompilerIf #PB_Compiler_IsMainFile
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
    
    ; draw frame on the image
    If StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,0,OutputWidth(),OutputWidth(), $000000)
      StopDrawing()
    EndIf
  EndIf
    
  Global *Vertical.Scroll_S=AllocateStructure(Scroll_S)
  Global *Horisontal.Scroll_S=AllocateStructure(Scroll_S)
  
  Procedure CallBack()
    Protected Repaint, iWidth, iHeight
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Scroll::Resizes(*Vertical, *Horisontal, 0, 0, Width, Height)
        Repaint = #True
    EndSelect
    
    If Scroll::CallBack(*Vertical, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    If Scroll::CallBack(*Horisontal, EventType(), MouseX, MouseY, WheelDelta) : Repaint = #True : EndIf
    
    iWidth = Scroll::X(*Vertical)
    iHeight = Scroll::Y(*Horisontal)
    
    If Repaint And StartDrawing(CanvasOutput(Canvas))
      Box(0,0,Width,Height, $FFFFFF)
      ClipOutput(0,0, iWidth, iHeight)
      DrawImage(ImageID(0), -*Horisontal\Page\Pos, -*Vertical\Page\Pos)
      UnclipOutput()
      
      Scroll::Draw(*Vertical)
      Scroll::Draw(*Horisontal)
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
    
    Scroll::Widget(*Vertical, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,ImageHeight(0),0, #PB_ScrollBar_Vertical, 7)
    Scroll::Widget(*Horisontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,ImageWidth(0),0, 0, 7)
        
    Scroll::SetState(*Vertical, 150)
    Scroll::SetState(*Horisontal, 100)
    
    PostEvent(#PB_Event_Gadget, 0,1,#PB_EventType_Resize)
    BindGadgetEvent(1, @CallBack())
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP