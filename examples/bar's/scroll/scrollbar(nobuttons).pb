XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *scrollbar
  Global.i gEvent, gQuit, g_Canvas, buttonsize
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   95, 390,  30, "", #PB_Button_Toggle)
      
      If Open(0, 10, 10, 380, 80)
        g_Canvas = GetGadget(root())
        *scrollbar = Scroll(5, 10, 370, 30, 20, 50, 8 )
        SetAttribute(*scrollbar, #__Bar_ButtonSize, 30 )
        buttonsize = GetAttribute( *scrollbar, #__Bar_ButtonSize )
        Debug "button-size - "+buttonsize
        
        Splitter(5, 5, 370, 70, *scrollbar,0)
        SetState(widget(), 70)
        
        SetGadgetState(0, buttonsize)
        SetWindowTitle(0, Str(GetState(*scrollbar)))
        
        If GetGadgetState(0)
          SetGadgetText(0, "hide scrollbar buttons")
        Else
          SetGadgetText(0, "show scrollbar buttons")
        EndIf
        
        bind(-1,-1)
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
            SetAttribute(*scrollbar, #__Bar_ButtonSize, GetGadgetState(0) * buttonsize)
            SetWindowTitle(0, Str(GetState(*scrollbar)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "hide scrollbar buttons")
            Else
              SetGadgetText(0, "show scrollbar buttons")
            EndIf
            
;             redraw(root())
            
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