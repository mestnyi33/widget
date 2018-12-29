IncludePath "../../"
XIncludeFile "module_bar.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Global.i gEvent, gQuit, value, direction
  Global *Bar_0.Bar::Bar_S=AllocateStructure(Bar::Bar_S)
  
  Procedure Draw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Bar::Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 50, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Bar_0 = Bar::Bar(5, 10, 370,  30, 20,  50, 8)
      
      Draw(1)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Bar::IsStart(*Bar_0)
          direction = 1
        EndIf
        If Bar::IsStop(*Bar_0)
          direction =- 1
        EndIf
        
        value + direction
        
        If Bar::SetState(*Bar_0, value)
          If WidgetEvent() = #PB_EventType_Change
            PostEvent(#PB_Event_Gadget, 0, 1)
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            value = Bar::GetState(*Bar_0)
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        Bar::CallBack(*Bar_0, EventType())
        
        If WidgetEvent() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(Bar::GetAttribute(EventWidget(), Bar::#PB_ScrollBar_Direction)))
        EndIf
        
        Draw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---
; EnableXP