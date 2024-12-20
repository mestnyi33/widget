IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
 UseWidgets( )
 EnableExplicit
  
  Global.i Canvas_0, gEvent, gQuit, X=10,Y=10
  Global NewMap enum.i()
  
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
  
  Procedure.i _SetAlign(*This._S_widget, Mode.q, Type.i=1)
    ProcedureReturn SetAlign(*This, Mode)
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo docking enum", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
     Open(0)
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
       
      
      ;enum(Str(0)) = Form(50, 50, 280, 200, "Demo dock enum");, #__flag_Flag_AnchorsGadget)
      enum(Str(0)) = Container(50, 50, 280, 200);, #__flag_Flag_AnchorsGadget);#__flag_Flag_AutoSize)
      ;enum(Str(0)) = Panel(50, 50, 280, 200) : AddItem(enum(Str(0)), -1, "panel")
      ;enum(Str(0)) = ScrollArea(50, 50, 280, 200, 280,200)
      
      enum(Str(5)) = Button(100, 100, 80, 21, "Full_"+Str(5))
      enum(Str(2)) = Button(0, 0, 80, 21, "Top_"+Str(2))
      enum(Str(1)) = Button(0, 0, 80, 21, "Left_"+Str(1))
      enum(Str(3)) = Button(0, 0, 80, 21, Str(3)+"_Right")
      enum(Str(4)) = Button(0, 0, 80, 30, Str(4)+"_Bottom")
      enum(Str(6)) = Button(0, 0, 80, 21, Str(6)+"_Bottom")
      
      CloseList()
      
;       _SetAlign(enum(Str(1)), #__flag_Flag_AutoSize|#__align_left|#__align_right)
;       _SetAlign(enum(Str(2)), #__flag_Flag_AutoSize|#__align_top|#__align_bottom)
;       _SetAlign(enum(Str(3)), #__flag_Flag_AutoSize|#__align_top|#__align_bottom|#__align_right)
;       _SetAlign(enum(Str(4)), #__flag_Flag_AutoSize|#__align_left|#__align_right|#__align_bottom)
;       _SetAlign(enum(Str(5)), #__flag_Flag_AutoSize|#__align_full)
      
      _SetAlign(enum(Str(4)), #__flag_AutoSize|#__align_bottom)
      _SetAlign(enum(Str(6)), #__flag_AutoSize|#__align_bottom)
      _SetAlign(enum(Str(1)), #__flag_AutoSize|#__align_top)
      _SetAlign(enum(Str(2)), #__flag_AutoSize|#__align_left)
      _SetAlign(enum(Str(3)), #__flag_AutoSize|#__align_right)
      _SetAlign(enum(Str(5)), #__flag_AutoSize)
      
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
        If Width = Width(root())-100
          direction =- 1
        EndIf
;         
        Width + direction
        Height + direction
        
        If Resize(enum(Str(0)), #PB_Ignore, #PB_Ignore, Width, Height)
          ; SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(*Bar_0, #PB_Bar_Direction)))
           ReDraw( root( ))
        EndIf
      
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Define *th._s_widget = enum(Str(0))
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 52
; FirstLine = 48
; Folding = ---
; EnableXP