IncludePath "../../"
XIncludeFile "widgets().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i gEvent, gQuit, g_Canvas
  Global *Bar_0
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "show scrollbar buttons", #PB_Button_Toggle)
      
      If Open(0, 10, 10, 380, 50, "", #__flag_BorderLess)
        g_Canvas = GetGadget(root())
        *Bar_0 = Scroll(5, 10, 370, 30, 20, 50, 8, #__Bar_ButtonSize)
        
        SetGadgetState(0, GetAttribute(widget(), #__Bar_ButtonSize))
        SetWindowTitle(0, Str(GetState(widget())))
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
            Debug Str(GetGadgetState(0) * 30)
            SetAttribute(*Bar_0, #__Bar_ButtonSize, GetGadgetState(0) * 30)
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP