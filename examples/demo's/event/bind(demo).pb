IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_widgets( )
     If WidgetEventType() <> #__event_MouseMove And 
       WidgetEventType() <> #__event_Draw And 
       WidgetEventType() <> #__event_StatusChange
      
      If EventWidget( )\type = #__Type_Button
        ; ClearDebugOutput()
        Debug ""+GetIndex(EventWidget())+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (gadget)"
      EndIf
      
      If GetIndex(EventWidget()) = 1
        ProcedureReturn #PB_Ignore ; no send to (window & root) - event
      EndIf
    EndIf
  EndProcedure
  
  Procedure events_windows( )
    If WidgetEventType() <> #__event_MouseMove And 
       WidgetEventType() <> #__event_Draw And
       WidgetEventType() <> #__event_StatusChange
      
      If EventWidget( )\type = #__Type_Button
        Debug "  "+GetIndex(EventWidget())+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (window)"
      EndIf
      
      If GetIndex(EventWidget()) = 2
        ProcedureReturn #PB_Ignore ; no send to (root) - event
      EndIf
    EndIf
  EndProcedure
  
  Procedure events_roots( )
    If WidgetEventType() <> #__event_MouseMove And 
       WidgetEventType() <> #__event_Draw And
       WidgetEventType() <> #__event_StatusChange
      
      If EventWidget( )\type = #__Type_Button
        Debug "    "+GetIndex(EventWidget())+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (root)"
      EndIf
    EndIf
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = #__flag_AnchorsGadget
      
      If Open(0, 10,10, 480, 480)
        Bind(#PB_All, @events_roots())
        Bind(Window(80, 100, 300, 280, "Window_2", Editable|#PB_Window_SystemMenu), @events_windows())
        ;SetColor(widget(), #PB_Gadget_BackColor, $ff00ff)
        Define *butt = Button(10,  10, 280, 80, "post event for one procedure", Editable)
        Bind(*butt, @events_widgets(), #__event_MouseEnter)
        Bind(*butt, @events_widgets(), #__event_MouseLeave)
        
        ;Bind(Button(10,  10, 280, 80, "post event for one procedure", Editable), @events_widgets())
        Bind(Button(10, 100, 280, 80, "post event for to two procedure", Editable), @events_widgets())
        Bind(Button(10, 190, 280, 80, "post event for all procedures", Editable), @events_widgets())
        
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 64
; FirstLine = 48
; Folding = ---
; EnableXP