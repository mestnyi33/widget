IncludePath "../"
XIncludeFile "widgets().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i Window_0, g_Canvas
  Global.i gEvent, gQuit
  Global *Image_0._S_bar=AllocateStructure(_S_bar)
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")  ;  "/Users/as/Desktop/Снимок экрана 2018-12-29 в 21.35.28.png") ; 
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Canvas_0_Resize()
    Protected g_Canvas = EventGadget()
    
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        If Resize(*Image_0, #PB_Ignore, #PB_Ignore, GadgetWidth(g_Canvas)-20, GadgetHeight(g_Canvas)-20)
          ; redraw(root())
        EndIf
        
    EndSelect
    
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
    ResizeGadget(1, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
    ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-80)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 250, 280+30, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   245, 240,  30, "change image", #PB_Button_Toggle)
      ComboBoxGadget   (1,    5,   245+35, 240,  30)
      AddGadgetItem(1, -1, "Default")
      AddGadgetItem(1, -1, "Center")
      AddGadgetItem(1, -1, "Mosaic")
      AddGadgetItem(1, -1, "Stretch")
      AddGadgetItem(1, -1, "Proportionally")
      
      If Open(0, 10,10, 230, 230, "", #__flag_BorderLess)
        g_Canvas = GetGadget(root())
        *Image_0 = Image(10, 10, 210,  210, 0)
        
        redraw(root())
      EndIf
      
      BindGadgetEvent(g_Canvas, @Canvas_0_Resize(), #PB_EventType_Resize)
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
            SetState(*Image_0, GetGadgetState(EventGadget()))
            redraw(root())
            
          Case 1
            SetAttribute(*Image_0, #__DisplayMode, GetGadgetState(EventGadget()))
            redraw(root())
            
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP