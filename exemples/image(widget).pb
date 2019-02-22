IncludePath "../"
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
  
  Procedure Canvas_0_Resize()
    Protected Canvas = EventGadget()
    Protected *window = GetGadgetData(Canvas)
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        If Resize(*Image_0, #PB_Ignore, #PB_Ignore, GadgetWidth(Canvas)-20, GadgetHeight(Canvas)-20)
          ReDraw(*window)
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
      
     Open(0, 10,10, 280, 230)
      Canvas_0 = Display()
      
      *Image_0 = Image(10, 10, 260,  210, 0)
      
      ReDraw(Root())
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
        
        If WidgetEvent() = #PB_EventType_Change And EventWidget()
          Debug "Change scroll direction "+ GetAttribute(EventWidget(), #PB_Bar_Direction)
          
          Select EventWidget()
              
            Case *Image_0
              SetWindowTitle(0, Str(GetState(*Image_0)))
              SetGadgetState(1, GetState(*Image_0))
              
          EndSelect
        EndIf
        
        ReDraw(Root())
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP