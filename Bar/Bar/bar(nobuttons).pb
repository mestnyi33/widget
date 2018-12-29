IncludePath "../../"
XIncludeFile "module_bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Global.i gEvent, gQuit
  Global *Bar_0.Bar::Bar_S=AllocateStructure(Bar::Bar_S)
  
  Procedure Draw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Bar::Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Create_WinMain()
    If OpenWindow(0, 0, 0, 400, 100, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "show scrollbar buttons", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 50, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Bar_0 = Bar::Bar(5, 10, 370,  30, 20,  50, 8, Bar::#PB_ScrollBar_NoButtons)
      
      Draw(1)
    EndIf
  EndProcedure
  
  Create_WinMain()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            Bar::SetAttribute(*Bar_0, Bar::#PB_ScrollBar_NoButtons, GetGadgetState(0) * 17)
            If GetGadgetState(0)
              SetGadgetText(0, "hide scrollbar buttons")
            Else
              SetGadgetText(0, "show scrollbar buttons")
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        Bar::CallBack(*Bar_0, EventType())
        
        If WidgetEvent() = #PB_EventType_Change
          Debug "Change scroll direction "+ Bar::GetAttribute(EventWidget(), Bar::#PB_ScrollBar_Direction)
          
          Select EventWidget()
              
            Case *Bar_0
              SetWindowTitle(0, Str(Bar::GetState(*Bar_0)))
              SetGadgetState(1, Bar::GetState(*Bar_0))
              
          EndSelect
        EndIf
        
        Draw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP