IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure events_gadgets()
    Debug ""+Str(EventWidget()\index - 1)+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (gadget)"
  EndProcedure
  
  Procedure events_widgets()
    ; ClearDebugOutput()
    Debug " "+Str(EventWidget()\index - 1)+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (widget)"
  EndProcedure
  
  Procedure events_windows()
    Debug "   "+Str(EventWidget()\index - 1)+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (window)"
  EndProcedure
  
  Procedure events_roots()
    Debug "     "+Str(EventWidget()\index - 1)+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (root)"
  EndProcedure
  
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define Editable ; = #__flag_AnchorsGadget
      
      If Open(0, 10,10, 480, 480)
        ; Bind(#PB_All, @events_roots())
        Window(80, 100, 300, 280, "Window_2", Editable)
        ;;Bind(widget(), @events_windows())
        
        Define *id._s_widget = Button(10,  10, 280, 80, "post event for one procedure", Editable)
        Button(10, 100, 280, 80, "post event for to two procedure", Editable)
        Button(10, 190, 280, 80, "post event for all procedures", Editable)
        
        ; post all default events
        ;Bind(id, @events_widgets())
        
        ; post this events
        Bind(*id, @events_gadgets(), #PB_EventType_MouseEnter)
       ; Bind(id, @events_widgets(), #PB_EventType_MouseEnter)
        Bind(*id, @events_widgets(), #PB_EventType_MouseLeave)
        ; Bind(id, @events_widgets(), #PB_EventType_LeftButtonDown)
        Bind(*id, @events_widgets(), #PB_EventType_LeftClick)
        
;         Debug @events_widgets()
;         
;         ForEach *id\bind()
;           Debug ""+ *id\bind() +" "+ *id\bind()\events();\call() ;+""
;         Next
        
        ReDraw(Root())
      EndIf
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
        ;       Case #PB_Event_Gadget;Widget
        ;         Debug ""+gettext(EventWidget()) +" "+ WidgetEvent() ;+" "+ *Value\This +" "+ *Value\event
        ;         
        ;         Select EventWidget()
        ;           Case *but
        ;             
        ;             Debug *but
        ;             
        ;         EndSelect
        ;         
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP