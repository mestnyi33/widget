IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i gEvent, gQuit
  Global Button_0, Button_1, Button_2, *Splitter_0.Widget_S, *Splitter_1.Widget_S

  Procedure _ReDraw(Gadget.i)
    If StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
      
      Draw(*Splitter_1)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 430, 280, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   245, 420,  30, "start change scrollbar", #PB_Button_Toggle)
      
;       CanvasGadget(1, 10,10, 410, 230, #PB_Canvas_Keyboard)
;       SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      Open(0,10,10, 410, 230)
      
      Button_0 = Button(0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
      Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      Button_2 = Button(0, 0, 0, 0, "Button 2") ; as they will be sized automatically
      *Splitter_0 = Splitter(0, 0, 390, 210, Button_0, Button_1, #PB_Splitter_Separator)
      *Splitter_1 = Splitter(10, 10, 390, 210, Button_2, *Splitter_0, #PB_Splitter_Vertical)

      ReDraw(Root())
    EndIf
  EndProcedure
  
  Window_0()
  
  Define value, direction = 1
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If _scroll_in_start_(*Splitter_1)
          direction = 1
        EndIf
        
        If _scroll_in_stop_(*Splitter_1)
          direction =- 1
        EndIf
        
        value + direction
        
        If SetState(*Splitter_1, value)
          ReDraw(Root())
        EndIf
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            value = GetState(*Splitter_1)
            If GetGadgetState(0)
              AddWindowTimer(0, 1, 10)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        ;CallBacks(*Splitter_1, EventType())
        
        If WidgetEvent() = #PB_EventType_Change
          SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_Bar_Direction)))
        EndIf
        
        ReDraw(Root())
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP