IncludePath "../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i Editable ;= #PB_Flag_AnchorsGadget
  Global.i gEvent, gQuit, value, direction, x=10,y=10
    
  Procedure Window_0_Resize()
    ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(0, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "test get clip coordinate", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget(0,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      If Open(0, 10,10, 580, 550," Root ")
        Form(180, 50, 280, 200, "Form_1", Editable)
          Container(10,10,280-60, 200-60, Editable)
            Container(10,10,280-60-25, 200-60-25, Editable)
              Container(10,10,280-60, 200-60, Editable)
                Container(10,10,280-60, 200-60, Editable)
                  Button(-20, 10, 280-60, 20, "Button_1_container", Editable)
                CloseList()
              CloseList()
            CloseList()
          CloseList()
        
        Form(180, 300, 280, 200, "Form_2", Editable)
          Container(10,10,280-60, 200-60, Editable)
            Container(5,5,280-60, 200-60, Editable)
              Container(-30,-30,280-60, 200-60, Editable)
                Container(-30,-30,280-60, 200-60, Editable)
                  Button(10, 200-60-20-30, 280-60, 20, "Button_1_container", Editable)
                CloseList()
              CloseList()
            CloseList()
          CloseList()
        
        ReDraw(Root())
      EndIf
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP