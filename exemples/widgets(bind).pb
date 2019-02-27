IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure Widgets_Gadget_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    Select EventType 
      Case #PB_EventType_MouseEnter
        Debug ""+EventWidget +" "+ EventWidget() +" "+ EventType +" "+ WidgetEvent()
        
      Case #PB_EventType_MouseLeave
        Debug ""+EventWidget +" "+ EventWidget() +" "+ EventType +" "+ WidgetEvent()
        
      Case #PB_EventType_LeftButtonDown
        Debug "Widgets_Gadget_Events"
        
;         ; Отключает передачу сообщений в 
;         ; оконную и рутовскую процедуру
;         ProcedureReturn 1
    EndSelect
  EndProcedure
  
  Procedure Widgets_Window_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    Protected *This.Widget_S, MouseX, MouseY, DeltaX, DeltaY
    Static Drag.i
    
    ; Protected EventWidget = EventWidget()
    ; Protected EventType = WidgetEvent()
    ; Protected EventItem = GetState(EventWidget)))
    
    ;Select EventWidget
   ;   Default
        
        Select EventType 
          Case #PB_EventType_LeftButtonDown
            *This = GetAnchors(EventWidget)
            Debug "Widgets_Window_Events"
            
            If *This   
                If SetAnchors(*This)
                  Debug "изменено down"+ *This
                  Debug Drag::DropText(*This)
                EndIf
            EndIf
            
            ;         ; Отключает передачу сообщений в 
            ;         ; рутовскую процедуру
            ;         ProcedureReturn 1
            
        EndSelect
        
    ;EndSelect
    
  EndProcedure
  
  Procedure Widgets_Root_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    Select EventType 
      Case #PB_EventType_LeftButtonDown
        Debug "Widgets_Root_Events"
    EndSelect
  EndProcedure
  
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      ;       CanvasGadget(1, 10,10, 580, 550, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      ;       SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      ;       BindGadgetEvent(1, @Canvas_CallBack())
      ;       If OpenList(0, 1, #PB_GadgetType_Window)
      Define Editable = #PB_Flag_AnchorsGadget
      
      If Open(0, 10,10, 580, 550," root ")
        *win=Window(80, 100, 280, 200, "Window_2", Editable)
        
        Container(30,30,280-60, 200-60, Editable)
        Container(20,20,280-60, 200-60, Editable)
        *but=Button(100, 20, 80, 80, "Button_1", Editable)
        Button(130, 80, 80, 80, "Button_2", Editable)
        Button(70, 80, 80, 80, "Button_3", Editable)
        CloseList()
        CloseList()
  
 
        Bind(@Widgets_Gadget_Events(), *but)
        Bind(@Widgets_Window_Events(), *win)
        Bind(@Widgets_Root_Events())
        ReDraw(Root())
      EndIf
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
;       Case #PB_Event_Gadget;Widget
;         Debug ""+gettext(EventWidget()) +" "+ WidgetEvent() ;+" "+ *Value\This +" "+ *Value\Type
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = f3-
; EnableXP