XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *scrollbar._s_widget
  Global.i gEvent, gQuit, g_Canvas, round = 30
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   95, 390,  30, "", #PB_Button_Toggle)
      
      If OpenRoot(0, 10, 10, 380, 80)
        g_Canvas = GetCanvasGadget(root())
        *scrollbar = ScrollBarWidget(5, 10, 370, 30, 20, 50, 8, 0, round)
        SetWidgetState(widget(), 31)
        
        SplitterWidget(5, 5, 370, 70, *scrollbar,-1)
        SetWidgetState(widget(), 70)
        
        SetGadGetWidgetState(0, GetWidgetAttribute(*scrollbar, #__bar_buttonsize))
        SetWindowTitle(0, Str(GetWidgetState(*scrollbar)))
        
        If GetGadGetWidgetState(0)
          SetGadGetWidgetText(0, "box scrollbar buttons")
        Else
          SetGadGetWidgetText(0, "round scrollbar buttons")
        EndIf
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  SetWidgetAttribute(*scrollbar, #__Bar_ButtonSize, 62)
            
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            *scrollbar\round = GetGadGetWidgetState(0) * round
            *scrollbar\bar\button[0]\round = *scrollbar\round
            *scrollbar\bar\button[1]\round = *scrollbar\round
            *scrollbar\bar\button[2]\round = *scrollbar\round
            
             ; ResizeWidget(*scrollbar, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      
            
            SetWindowTitle(0, Str(GetWidgetState(*scrollbar)))
            
            If GetGadGetWidgetState(0)
              SetGadGetWidgetText(0, "box scrollbar buttons")
            Else
              SetGadGetWidgetText(0, "round scrollbar buttons")
            EndIf
            
            PostEventRepaint( root( ) )
            
          Case g_Canvas
            If widget()\change
              ; SetWindowTitle(0, Str(GetWidgetState(widget())))
              Debug GetWidgetState(widget())
              widget()\change = 0
            EndIf
            
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = --
; EnableXP