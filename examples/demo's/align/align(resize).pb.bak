IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  
  Global NewMap ID.i()
  Global.i Canvas_0, gEvent, gQuit, x=10,y=10
  
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define *w._S_widget = Open(0)
      ;Canvas_0 = GetGadget(Root())
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
      
      
      Protected b = 2
      Protected iw = 280
      ;a_init(root())
      
      ;ID(Hex(0)) = Form(50, 50, 280, 200, "Demo dock widgets");, #__flag_AnchorsGadget)
      ID(Hex(0)) = Container(50, 50, 280, 200);, #__flag_AnchorsGadget);#__flag_AutoSize)
      
      ;ID(Hex(0)) = Panel(50, 50, 280, 200) : AddItem(ID(Hex(0)), -1, "panel")
      ;ID(Hex(0)) = ScrollArea(50, 50, 280, 200, iw,300)
      ;a_set(widget())
      
      
      ID(Hex(8)) = Button(0, 0, 80, 40, "left")   
      ID(Hex(2)) = Button(0, 0, 80, 40, "top")     
      ID(Hex(4)) = Button(0, 0, 80, 40, "right")   
      ID(Hex(6)) = Button(0, 0, 80, 40, "bottom")   
      
      ID(Hex(9)) = Button(0, 0, 80, 40, "center")    
      
      ID(Hex(1)) = Button(0, 0, 80, 40, "left&top") 
      ID(Hex(3)) = Button(0, 0, 80, 40, "right&top") 
      ID(Hex(7)) = Button(0, 0, 80, 40, "left&bottom")
      ID(Hex(5)) = Button(0, 0, 80, 40, "right&bottom")
      
      CloseList()
      
      SetAlign(ID(Hex(8)), #__align_left   |#__align_center)
      SetAlign(ID(Hex(2)), #__align_top    |#__align_center)
      SetAlign(ID(Hex(4)), #__align_right  |#__align_center)
      SetAlign(ID(Hex(6)), #__align_bottom |#__align_center)
      
      SetAlign(ID(Hex(1)), #__align_none)
      SetAlign(ID(Hex(3)), #__align_right)
      SetAlign(ID(Hex(7)), #__align_bottom)
      SetAlign(ID(Hex(5)), #__align_right|#__align_bottom)
      
      SetAlign(ID(Hex(9)), #__align_center)
      
      
;       SetAlign( ID(Hex(8)), #__align_auto, 1,0,0,0 )
;       SetAlign( ID(Hex(2)), #__align_auto, 0,1,0,0 )
;       SetAlign( ID(Hex(4)), #__align_auto, 0,0,1,0 )
;       SetAlign( ID(Hex(6)), #__align_auto, 0,0,0,1 )
;       
;       SetAlign( ID(Hex(9)), #__align_center )
;       
;       SetAlign( ID(Hex(1)), #__align_auto, 1,1,0,0 )
;       SetAlign( ID(Hex(3)), #__align_auto, 0,1,1,0 )
;       SetAlign( ID(Hex(7)), #__align_auto, 1,0,0,1 )
;       SetAlign( ID(Hex(5)), #__align_auto, 0,0,1,1 )
      
      
      
      Resize(ID(Hex(0)), #PB_Ignore, #PB_Ignore, 360,260)
      
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
        If Width = 480
          direction = 1
        ElseIf Width = WidgetWidth(Root())-100
          direction =- 1
        EndIf
        ;         
        Width + direction
        Height + direction
        
        Resize(ID(Hex(0)), #PB_Ignore, #PB_Ignore, Width, Height)
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Define *th._s_widget = ID(Str(0))
            Width = WidgetWidth(*th)
            Height = WidgetHeight(*th)
            
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
; CursorPosition = 57
; FirstLine = 42
; Folding = --
; EnableXP