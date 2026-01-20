
IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  
  Global NewMap widget_id.i()
  Global.i Canvas_0, gEvent, gQuit, X=10,Y=10
  
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35-20)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Open( 0, 10,10, 580,580 )
      Canvas_0 = GetCanvasGadget(Root())
      ButtonGadget   (0,    5,   600-35, 590,  30, "resize", #PB_Button_Toggle)
      
      
      Protected b = 2
      Protected iw = 280
      ;a_init(root())
      
      ;widget_id(Hex(0)) = Form(50, 50, 280, 200, "Demo dock widgets");, )
      widget_id(Hex(0)) = Container(50, 50, 280, 200);, );#__flag_AutoSize)
      
      ;widget_id(Hex(0)) = Panel(50, 50, 280, 200) : AddItem(widget_id(Hex(0)), -1, "panel")
      ;widget_id(Hex(0)) = ScrollArea(50, 50, 280, 200, iw,300)
      
      widget_id(Hex(8)) = Button(0, 0, 80, 40, "left")   
      widget_id(Hex(2)) = Button(0, 0, 80, 40, "top")     
      widget_id(Hex(4)) = Button(0, 0, 80, 40, "right")   
      widget_id(Hex(6)) = Button(0, 0, 80, 40, "bottom")   
      
      widget_id(Hex(9)) = Button(0, 0, 80, 40, "center")    
      
      widget_id(Hex(1)) = Button(0, 0, 80, 40, "left&top") 
      widget_id(Hex(3)) = Button(0, 0, 80, 40, "right&top") 
      widget_id(Hex(7)) = Button(0, 0, 80, 40, "left&bottom")
      widget_id(Hex(5)) = Button(0, 0, 80, 40, "right&bottom")
      
      CloseList()
      
      SetAlign(widget_id(Hex(8)), #__align_left   |#__align_center)
      SetAlign(widget_id(Hex(2)), #__align_top    |#__align_center)
      SetAlign(widget_id(Hex(4)), #__align_right  |#__align_center)
      SetAlign(widget_id(Hex(6)), #__align_bottom |#__align_center)
      
      SetAlign(widget_id(Hex(1)), #__align_none)
      SetAlign(widget_id(Hex(3)), #__align_right)
      SetAlign(widget_id(Hex(7)), #__align_bottom)
      SetAlign(widget_id(Hex(5)), #__align_right|#__align_bottom)
;       
      SetAlign(widget_id(Hex(9)), #__align_center)
      
      
;       SetAlign( widget_id(Hex(8)), #__align_auto, 1,0,0,0 )
;       SetAlign( widget_id(Hex(2)), #__align_auto, 0,1,0,0 )
;       SetAlign( widget_id(Hex(4)), #__align_auto, 0,0,1,0 )
;       SetAlign( widget_id(Hex(6)), #__align_auto, 0,0,0,1 )
;       
;       SetAlign( widget_id(Hex(9)), #__align_center )
;       
;       SetAlign( widget_id(Hex(1)), #__align_auto, 1,1,0,0 )
;       SetAlign( widget_id(Hex(3)), #__align_auto, 0,1,1,0 )
;       SetAlign( widget_id(Hex(7)), #__align_auto, 1,0,0,1 )
;       SetAlign( widget_id(Hex(5)), #__align_auto, 0,0,1,1 )
      
      
      
      Resize(widget_id(Hex(0)), #PB_Ignore, #PB_Ignore, 360,260)
      
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
        ElseIf Width = Width(Root())-100
          direction =- 1
        EndIf
        ;         
        Width + direction
        Height + direction
        
        If Resize(widget_id(Hex(0)), #PB_Ignore, #PB_Ignore, Width, Height)
           PostRepaint( ) 
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Define *th._s_widget = widget_id(Str(0))
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
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 104
; FirstLine = 93
; Folding = --
; EnableXP