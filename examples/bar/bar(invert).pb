IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  UseModule constants
  
  Global.i gEvent, gQuit, g_Canvas
  Global *Bar_0
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
       ButtonGadget   (0,    5,   65, 390,  30, "set  inverted scrollbar", #PB_Button_Toggle)
      
     If Open(0,10,10, 380, 50)
        g_Canvas = GetGadget(root())
        *Bar_0 = Scroll(5, 10, 370, 30, 20, 50, 8, #__Bar_Inverted)
        
        SetGadgetState(0, GetAttribute(widget(), #__Bar_Inverted))
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
            SetAttribute(*Bar_0, #__Bar_Inverted, GetGadgetState(0))
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "set inverted scrollbar")
            Else
              SetGadgetText(0, "set standart scrollbar")
            EndIf
            
            redraw(root())
            
          Case g_Canvas
            If widget()\change
              SetWindowTitle(0, Str(GetState(widget())))
            EndIf
            
        EndSelect
        
    EndSelect
    
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP