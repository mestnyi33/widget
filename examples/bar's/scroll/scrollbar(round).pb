XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *scrollbar._s_widget
  Global.i gEvent, gQuit, g_Canvas, round = 30
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   95, 390,  30, "", #PB_Button_Toggle)
      
      If Open(0, 10, 10, 380, 80)
        g_Canvas = GetGadget(root())
        *scrollbar = Scroll(5, 10, 370, 30, 20, 50, 8, 0, round)
        SetState(widget(), 31)
        
        Splitter(5, 5, 370, 70, *scrollbar,0)
        SetState(widget(), 70)
        
        SetGadgetState(0, GetAttribute(*scrollbar, #__bar_buttonsize))
        SetWindowTitle(0, Str(GetState(*scrollbar)))
        
        If GetGadgetState(0)
          SetGadgetText(0, "box scrollbar buttons")
        Else
          SetGadgetText(0, "round scrollbar buttons")
        EndIf
        
        bind(-1,-1)
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  SetAttribute(*scrollbar, #__Bar_ButtonSize, 100)
            
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            *scrollbar\round = GetGadgetState(0) * round
            *scrollbar\bar\button[#__b_1]\round = *scrollbar\round
            *scrollbar\bar\button[#__b_2]\round = *scrollbar\round
            *scrollbar\bar\button[#__b_3]\round = *scrollbar\round
            
             ; Resize(*scrollbar, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      
            
            SetWindowTitle(0, Str(GetState(*scrollbar)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "box scrollbar buttons")
            Else
              SetGadgetText(0, "round scrollbar buttons")
            EndIf
            
            redraw(root())
            
          Case g_Canvas
            If widget()\change
              ; SetWindowTitle(0, Str(GetState(widget())))
              Debug GetState(widget())
              widget()\change = 0
            EndIf
            
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP