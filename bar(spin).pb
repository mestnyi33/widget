;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "bar().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule bar
  Define Event
  Global g_Canvas, NewList *List._S_widget()
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
      
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._S_bar = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | CallBack(*List(), EventType, MouseX, MouseY)
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  If OpenWindow(-1, 330, 220, 140, 70, "SpinGadget", #PB_Window_SystemMenu )
    g_Canvas = CanvasGadget(#PB_Any, 0,0, 140, 70, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    
    AddElement(*List()) : *List() = Spin     (20, 20, 100, 25, 0, 20)
    SetState (widget(), 5) ;: SetText(widget(), "5")   ; set initial value
    
    ReDraw(g_Canvas)
  EndIf
  
  If OpenWindow(0, 0, 0, 140, 70, "SpinGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SpinGadget     (0, 20, 20, 100, 25, 0, 20)
    SetGadgetState (0, 5) : SetGadgetText(0, "5")   ; set initial value
    
    Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
        If EventGadget() = 0
          SetGadgetText(0, Str(GetGadgetState(0)))
        EndIf
      EndIf
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; Folding = --
; EnableXP