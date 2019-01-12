IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i Window_0, Canvas_0
  Global.i gEvent, gQuit
  Global *Image_0.Widget_S=AllocateStructure(Widget_S)
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")  ;  "/Users/as/Desktop/Снимок экрана 2018-12-29 в 21.35.28.png") ; 
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/Toolbar/Paste.png")
    End
  EndIf
  
  Procedure ReDraw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Image_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_0_Resize()
    Protected Canvas = EventGadget()
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        If Resize(*Image_0, #PB_Ignore, #PB_Ignore, GadgetWidth(Canvas)-20, GadgetHeight(Canvas)-20)
          ReDraw(Canvas)
        EndIf
        
    EndSelect
    
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
    ResizeGadget(1, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-80)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 300, 280+30, "Demo show&hide scrollWidget buttons", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   245, 290,  30, "change image", #PB_Button_Toggle)
      ComboBoxGadget   (1,    5,   245+35, 290,  30)
      AddGadgetItem(1, -1, "Default")
      AddGadgetItem(1, -1, "Center")
      AddGadgetItem(1, -1, "Mosaic")
      AddGadgetItem(1, -1, "Stretch")
      AddGadgetItem(1, -1, "Proportionally")
      
      Canvas_0 = CanvasGadget(#PB_Any, 10,10, 280, 230, #PB_Canvas_Keyboard)
      SetGadgetAttribute(Canvas_0, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Image_0 = Image(10, 10, 260,  210, 0)
      
      ReDraw(Canvas_0)
      BindGadgetEvent(Canvas_0, @Canvas_0_Resize(), #PB_EventType_Resize)
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize())
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            SetState(*Image_0, GetGadgetState(0))
          Case 1
            SetAttribute(*Image_0, #PB_DisplayMode, GetGadgetState(1))
        EndSelect
        
        ; Get interaction with the scroll Widget
        CallBack(*Image_0, EventType())
        
        If WidgetEventType() = #PB_EventType_Change
          Debug "Change scroll direction "+ GetAttribute(EventWidget(), #PB_Bar_Direction)
          
          Select EventWidget()
              
            Case *Image_0
              SetWindowTitle(0, Str(GetState(*Image_0)))
              SetGadgetState(1, GetState(*Image_0))
              
          EndSelect
        EndIf
        
        ReDraw(Canvas_0)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP