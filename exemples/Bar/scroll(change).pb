IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i gEvent, gQuit, value, direction=1
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
    If OpenWindow(0, 0, 0, 400, 100, "Demo change scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 380, 50, #PB_Canvas_Keyboard)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      *Bar_0 = Scroll(5, 10, 370,  30, 20,  50, 8)
      
      ReDraw(1)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If IsStart(*Bar_0)
          direction = 1
        EndIf
        If IsStop(*Bar_0)
          direction =- 1
        EndIf
        
        value + direction
        
        If SetState(*Bar_0, value)
          PostEvent(#PB_Event_Gadget, 0, 1)
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            value = GetState(*Bar_0)
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 200)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEvent() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_Bar_Direction)))
        EndIf
        
        ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP