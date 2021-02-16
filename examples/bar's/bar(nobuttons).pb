IncludePath "../../"
XIncludeFile "widgets-bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global.i gEvent, gQuit, g_Canvas
  Global *scrollbar
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   95, 390,  30, "show scrollbar buttons", #PB_Button_Toggle)
      
      If Open(0, 10, 10, 380, 80)
        g_Canvas = GetGadget(root())
        *scrollbar = Scroll(5, 10, 370, 30, 20, 50, 8);, #__bar_buttonsize)
        Splitter(5, 10, 370, 70, *scrollbar,0)
        SetState(widget(), 70)
        
        SetGadgetState(0, GetAttribute(*scrollbar, #__bar_buttonsize))
        SetWindowTitle(0, Str(GetState(*scrollbar)))
        redraw(root())
      EndIf
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
            SetAttribute(*scrollbar, #__Bar_ButtonSize, GetGadgetState(0) * 30)
            SetWindowTitle(0, Str(GetState(*scrollbar)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "hide scrollbar buttons")
            Else
              SetGadgetText(0, "show scrollbar buttons")
            EndIf
            
            redraw(root())
            
          Case g_Canvas
            If widget()\change
              SetWindowTitle(0, Str(GetState(widget())))
              
              widget()\change = 0
            EndIf
            
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP