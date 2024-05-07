IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
 UseLib(widget)
 EnableExplicit
  
  Global.i Canvas_0, gEvent, gQuit, x=10,y=10
  Global NewMap Widgets.i()
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure.i _SetAlignment(*This._S_widget, Mode.q, Type.i=1)
    ProcedureReturn SetAlignmentFlag(*This, Mode, Type)
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo docking widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
     Open(0)
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
       
      
      ;Widgets(Str(0)) = Form(50, 50, 280, 200, "Demo dock widgets");, #__flag_Flag_AnchorsGadget)
      Widgets(Str(0)) = Container(50, 50, 280, 200);, #__flag_Flag_AnchorsGadget);#__flag_Flag_AutoSize)
      ;Widgets(Str(0)) = Panel(50, 50, 280, 200) : AddItem(Widgets(Str(0)), -1, "panel")
      ;Widgets(Str(0)) = ScrollArea(50, 50, 280, 200, 280,200)
      
      Widgets(Str(5)) = Button(100, 100, 80, 21, "Full_"+Str(5))
      Widgets(Str(2)) = Button(0, 0, 80, 21, "Top_"+Str(2))
      Widgets(Str(1)) = Button(0, 0, 80, 21, "Left_"+Str(1))
      Widgets(Str(3)) = Button(0, 0, 80, 21, Str(3)+"_Right")
      Widgets(Str(4)) = Button(0, 0, 80, 30, Str(4)+"_Bottom")
      Widgets(Str(6)) = Button(0, 0, 80, 21, Str(6)+"_Bottom")
      
      CloseList()
      
;       _SetAlignment(Widgets(Str(1)), #__flag_Flag_AutoSize|#__align_left|#__align_right)
;       _SetAlignment(Widgets(Str(2)), #__flag_Flag_AutoSize|#__align_top|#__align_bottom)
;       _SetAlignment(Widgets(Str(3)), #__flag_Flag_AutoSize|#__align_top|#__align_bottom|#__align_right)
;       _SetAlignment(Widgets(Str(4)), #__flag_Flag_AutoSize|#__align_left|#__align_right|#__align_bottom)
;       _SetAlignment(Widgets(Str(5)), #__flag_Flag_AutoSize|#__align_full)
      
      _SetAlignment(Widgets(Str(4)), #__flag_AutoSize|#__align_bottom)
      _SetAlignment(Widgets(Str(6)), #__flag_AutoSize|#__align_bottom)
      _SetAlignment(Widgets(Str(1)), #__flag_AutoSize|#__align_top)
      _SetAlignment(Widgets(Str(2)), #__flag_AutoSize|#__align_left)
      _SetAlignment(Widgets(Str(3)), #__flag_AutoSize|#__align_right)
      _SetAlignment(Widgets(Str(5)), #__flag_AutoSize)
      
      ;BindGadgetEvent(Canvas_0, @Canvas_CallBack())
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Define direction = 1
  Define Width, Height
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Width = 100
           direction = 1
        EndIf
        If Width = Width(Root())-100
          direction =- 1
        EndIf
;         
        Width + direction
        Height + direction
        
        If Resize(Widgets(Str(0)), #PB_Ignore, #PB_Ignore, Width, Height)
          ; SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(*Bar_0, #PB_Bar_Direction)))
        EndIf
      
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Define *th._s_widget = Widgets(Str(0))
            Width = Width(*th)
            Height = Height(*th)
            
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 67
; FirstLine = 64
; Folding = ---
; EnableXP