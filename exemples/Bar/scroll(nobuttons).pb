IncludePath "../../"
XIncludeFile "module_bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Bar
  
  Global.i gEvent, gQuit
  Global *Bar_0.Bar_S=AllocateStructure(Bar_S)
  
  Procedure ReDraw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "show scrollbar buttons", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 50, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Bar_0 = Scroll(5, 10, 370,  30, 20,  50, 8, #PB_Bar_NoButtons)
      
      ReDraw(1)
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
            SetAttribute(*Bar_0, #PB_Bar_NoButtons, GetGadgetState(0) * 17)
            If GetGadgetState(0)
              SetGadgetText(0, "hide scrollbar buttons")
            Else
              SetGadgetText(0, "show scrollbar buttons")
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEventType() = #PB_EventType_Change
          Debug "Change scroll direction "+ GetAttribute(EventWidget(), #PB_Bar_Direction)
          
          Select EventWidget()
              
            Case *Bar_0
              SetWindowTitle(0, Str(GetState(*Bar_0)))
              SetGadgetState(1, GetState(*Bar_0))
              
          EndSelect
        EndIf
        
        ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP