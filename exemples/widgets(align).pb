IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global NewMap Widgets.i()
  Global.i Canvas_0, gEvent, gQuit, x=10,y=10
  
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure.i _SetAlignment(*This._S_widget, Mode.i, Type.i=1)
    ProcedureReturn SetAlignment(*This._S_widget, Mode.i, Type.i)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
      
      Define *w._S_widget = Open(0, 10, 10, 580, 600-50, "")
      Canvas_0 = _Gadget()
      
      Widgets(Str(0)) = Form(50, 50, 280, 200, "Demo dock widgets");, #PB_Flag_AnchorsGadget)
      ;Widgets(Str(0)) = Container(50, 50, 280, 200);, #PB_Flag_AnchorsGadget);#PB_Flag_AutoSize)
      ;Widgets(Str(0)) = Panel(50, 50, 280, 200) : AddItem(Widgets(Str(0)), -1, "panel")
      ;Widgets(Str(0)) = ScrollArea(50, 50, 280, 200, 280,200)
      
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
      
      
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Procedure Window_1()
    CreateImage(0,200,60):StartDrawing(ImageOutput(0)):Define i:For i=0 To 200:Circle(100,30,200-i,(i+50)*$010101):Next:StopDrawing()
    
    If OpenWindow(0, 0, 0, 700, 600, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
      WindowBounds(0, WindowWidth(0), WindowHeight(0), #PB_Ignore, #PB_Ignore)
      ButtonGadget   (0, 5, 600-35, 690,  30, "resize", #PB_Button_Toggle)
      
      Define bs, *w._S_widget = Open(0, 10, 10, 680, 600-50, "")
      
      Widgets(Str(0)) = Form(50, 50, 512, 200, "Demo dock widgets");, #PB_Flag_AnchorsGadget)
                                                                   ; ; ;       ;Widgets(Str(0)) = Container(50, 50, 512, 200) : bs = 2 ;, #PB_Flag_AnchorsGadget)
                                                                   ; ; ;       ;Widgets(Str(0)) = Panel(50, 50, 280, 200) : AddItem(Widgets(Str(0)), -1, "panel")
                                                                   ; ; ;       ;Widgets(Str(0)) = ScrollArea(50, 50, 280, 200, 280,200)
      
      Widgets(Str(1)) = Text(10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized",#PB_Text_Center)
      Widgets(Str(3)) = Button(10, 70, 200, 60, "", 0, 0)
      Widgets(Str(2)) = Editor(10,  140, 200, 20) : SetText(Widgets(Str(2)),"Editor")
      Widgets(Str(4)) = Button(10, 170, 490, 20, "Button / toggle", #PB_Button_Toggle)
      Widgets(Str(5)) = Text(220,10,190,20,"Text",#PB_Text_Center) : SetColor(Widgets(Str(5)), #PB_Gadget_BackColor, $00FFFF)
      Widgets(Str(6)) = Container( 220, 30, 190, 100,#PB_Container_Single) : SetColor(Widgets(Str(6)), #PB_Gadget_BackColor, $cccccc) 
      Widgets(Str(7)) = Editor(10,  10, 170, 50) : SetText(Widgets(Str(7)),"Editor")
      Widgets(Str(8)) = Button(10, 70, 80, 20, "Button") 
      Widgets(Str(9)) = Button(100, 70, 80, 20, "Button") 
      CloseList() 
      Widgets(Str(10)) = String(220,  140, 190, 20, "String")
      Widgets(Str(11)) = Button(420,  10, 80, 80, "Bouton")
      Widgets(Str(12)) = CheckBox(420,  90, 80, 20, "CheckBox")
      Widgets(Str(13)) = CheckBox(420,  110, 80, 20, "CheckBox")
      Widgets(Str(14)) = CheckBox(420,  130, 80, 20, "CheckBox")
      Widgets(Str(15)) = CheckBox(420,  150, 80, 20, "CheckBox")
      
      
      ;SetAlignment(Widgets(Str(1)), #PB_Vertical)
      SetAlignment(Widgets(Str(2)), #PB_Top|#PB_Left|#PB_Bottom)
      ;       SetAlignment(Widgets(Str(3)), #PB_Vertical|#PB_Right)
      SetAlignment(Widgets(Str(4)), #PB_Bottom|#PB_Right|#PB_Left)
      SetAlignment(Widgets(Str(5)), #PB_Top|#PB_Left|#PB_Right)
      SetAlignment(Widgets(Str(6)), #PB_Full)
      SetAlignment(Widgets(Str(7)), #PB_Full)
      
      SetAlignment(Widgets(Str(8)), #PB_Bottom|#PB_Right|#PB_Left)
      SetAlignment(Widgets(Str(9)), #PB_Bottom|#PB_Right|#PB_Left)
      
      SetAlignment(Widgets(Str(10)), #PB_Bottom|#PB_Right|#PB_Left)
      SetAlignment(Widgets(Str(11)), #PB_Bottom|#PB_Right|#PB_Top)
      
      SetAlignment(Widgets(Str(12)), #PB_Bottom|#PB_Right)
      SetAlignment(Widgets(Str(13)), #PB_Bottom|#PB_Right)
      SetAlignment(Widgets(Str(14)), #PB_Bottom|#PB_Right)
      SetAlignment(Widgets(Str(15)), #PB_Bottom|#PB_Right)
      
      ReDraw(Root())
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_1()
  
  Define direction = 1
  Define Width, Height
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Width = 480
          direction = 1
        ElseIf Width = Width(Root())-100
          direction =- 1
        EndIf
        ;         
        Width + direction
        Height + direction
        
        Resize(Widgets(Str(0)), #PB_Ignore, #PB_Ignore, Width, Height)
        ReDraw(Root())
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Width = Width(Widgets(Str(0)))
            Height = Height(Widgets(Str(0)))
            
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 100)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP