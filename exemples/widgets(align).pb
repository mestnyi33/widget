IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global NewMap Widgets.i()
  Global.i gEvent, gQuit, x=10,y=10
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure.i _SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
    ;ProcedureReturn SetAlignment(*This.Widget_S, Mode.i, Type.i)
    With *This
      Select Type
        Case 1 ; widget
        Case 2 ; text
        Case 3 ; image
      EndSelect
      
      \Align.Align_S = AllocateStructure(Align_S)
      
      \Align\Right = 0
      \Align\Bottom = 0
      \Align\Left = 0
      \Align\Top = 0
      \Align\Horizontal = 0
      \Align\Vertical = 0
      
      If Mode&#PB_Right=#PB_Right
        \Align\x = (\Parent\Width-\Parent\bs*2 - (\x-\Parent\x-\Parent\bs)) - \Width
        \Align\Right = 1
      EndIf
      If Mode&#PB_Bottom=#PB_Bottom
        \Align\y = (\Parent\height -\Parent\bs*2- (\y-\Parent\y-\Parent\bs)) - \height
        \Align\Bottom = 1
      EndIf
      If Mode&#PB_Left=#PB_Left
        \Align\Left = 1
        If Mode&#PB_Right=#PB_Right
          \Align\x1 = (\Parent\Width - \Parent\bs*2) - \Width
        EndIf
      EndIf
      If Mode&#PB_Top=#PB_Top
        \Align\Top = 1
        If Mode&#PB_Bottom=#PB_Bottom
          \Align\y1 = (\Parent\height -\Parent\bs*2)- \height
        EndIf
      EndIf
      
      If Mode&#PB_Center=#PB_Center
        \Align\Vertical = 1
        \Align\Horizontal = 1
      EndIf
      If Mode&#PB_Vertical=#PB_Vertical
        \Align\Vertical = 1
      EndIf
      If Mode&#PB_Horizontal=#PB_Horizontal
        \Align\Horizontal = 1
      EndIf
      
      Resize(\Parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    EndWith
  EndProcedure
  
  Procedure Window_0()
    Protected i
    
    If OpenWindow(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
       ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
       
       Define *w.Widget_s = Open(0, 10, 10, 580, 600-50, "")
      Define canvas = *w\Canvas\Gadget
      
      ;Widgets(Str(50)) = Window(50, 50, 280, 200, "Demo dock widgets", #PB_Flag_AnchorsGadget)
      Widgets(Str(0)) = Container(50, 50, 280, 200, #PB_Flag_AnchorsGadget)
      
      Widgets(Str(1)) = Button(0, (200-20)/2, 80, 20, "Left_Center_"+Str(1))
      Widgets(Str(2)) = Button((280-80)/2, 0, 80, 20, "Top_Center_"+Str(2))
      Widgets(Str(3)) = Button(280-80, (200-20)/2, 80, 20, Str(3)+"_Center_Right")
      Widgets(Str(4)) = Button((280-80)/2, 200-20, 80, 20, Str(4)+"_Center_Bottom")
      Widgets(Str(5)) = Button(0, 0, 80, 20, "Default_"+Str(5))
      Widgets(Str(6)) = Button(280-80, 0, 80, 20, "Right_"+Str(6))
      Widgets(Str(7)) = Button(280-80, 200-20, 80, 20, "Bottom_"+Str(7))
      Widgets(Str(8)) = Button(0, 200-20, 80, 20, Str(8)+"_Bottom_Right")
      Widgets(Str(9)) = Button((280-80)/2, (200-20)/2, 80, 20, "Bottom_"+Str(9))
      
      CloseList()
      
      _SetAlignment(Widgets(Str(1)), #PB_Vertical)
      _SetAlignment(Widgets(Str(2)), #PB_Horizontal)
      _SetAlignment(Widgets(Str(3)), #PB_Vertical|#PB_Right)
      _SetAlignment(Widgets(Str(4)), #PB_Horizontal|#PB_Bottom)
      _SetAlignment(Widgets(Str(5)), 0)
      _SetAlignment(Widgets(Str(6)), #PB_Right)
      _SetAlignment(Widgets(Str(7)), #PB_Right|#PB_Bottom)
      _SetAlignment(Widgets(Str(8)), #PB_Bottom)
      _SetAlignment(Widgets(Str(9)), #PB_Center)
      
      
      ReDraw(canvas)
      
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
        ReDraw(Display())
    
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Width = Width(Widgets(Str(0)))
            Height = Height(Widgets(Str(0)))
            
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 10)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP