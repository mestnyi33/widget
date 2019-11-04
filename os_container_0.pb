CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure GadgetsClipCallBack( GadgetID, lParam )
    If GadgetID And GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
      SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS|#WS_CLIPCHILDREN )
      SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
CompilerEndIf

Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
  CompilerEndIf
EndProcedure

Procedure draw(g, color=$F0F0F0)
  StartDrawing(CanvasOutput(g))
  DrawingMode(#PB_2DDrawing_Default)
  Box(0,0,OutputWidth(), OutputHeight(), color)
  
  DrawingMode(#PB_2DDrawing_Outlined)
  Box(0,0,OutputWidth(), OutputHeight(), 0)
  
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(2,0, Str(g), 0)
  StopDrawing()
EndProcedure

Procedure gevent()
  Protected g = EventGadget()
  Protected buttons = GetGadgetAttribute(g, #PB_Canvas_Buttons)
  
  Select EventType()
    Case #PB_EventType_MouseEnter
      If buttons
        draw(g, $0000FF)
      Else
        draw(g, $FF0000)
      EndIf
      
    Case #PB_EventType_MouseLeave
      draw(g, $00FF00)
      
  EndSelect
EndProcedure

If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
  
  CanvasGadget(0,0, 0, 220,220, #PB_Canvas_Container) : draw(0)
  CanvasGadget(1,20, 20, 180, 180, #PB_Canvas_Container) : draw(1)
  
  CanvasGadget(9,70, 10, 70, 180,  #PB_Canvas_Container) : draw(9) : CloseGadgetList() ;
  
  CanvasGadget(2,20, 20, 180, 180, #PB_Canvas_Container) : draw(2)
  CanvasGadget(3,20, 20, 180, 180, #PB_Canvas_Container) : draw(3)
  
  CanvasGadget(4,0, 20, 180, 30,  #PB_Canvas_Container) : draw(4) : CloseGadgetList()
  CanvasGadget(5,0, 35, 180, 30,  #PB_Canvas_Container) : draw(5) : CloseGadgetList() 
  CanvasGadget(6,0, 50, 180, 30,  #PB_Canvas_Container) : draw(6) : CloseGadgetList() 
  CanvasGadget(7,20, 70, 180, 180,  #PB_Canvas_Container) : draw(7) : CloseGadgetList()
  
  CloseGadgetList()
  CloseGadgetList()
  CanvasGadget(8,10, 70, 70, 180,  #PB_Canvas_Container) : draw(8) : CloseGadgetList()
  
  For i=0 To 9
    BindGadgetEvent(i, @gevent())
  Next
  
  ClipGadgets(UseGadgetList(0))
  Repeat
    Event = WaitWindowEvent()
    
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP