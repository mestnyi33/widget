IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, *but, *win
  
  Procedure Widgets_Gadget_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    If EventType <> #PB_EventType_MouseMove
      Debug " gadget "+ EventType
    EndIf
    
;     Protected *This._S_widget
;     
;     Select EventType 
;       Case #PB_EventType_MouseEnter
;         Debug ""+EventWidget +" "+ EventWidget() +" "+ EventType +" "+ WidgetEvent()
;         
;       Case #PB_EventType_MouseLeave
;         Debug ""+EventWidget +" "+ EventWidget() +" "+ EventType +" "+ WidgetEvent()
;         
;       Case #PB_EventType_LeftButtonDown
;         Debug "Widgets_Gadget_Events"
;         
;         *This = GetAnchors(EventWidget)
;             If *This   
;                 If SetAnchors(*This)
;                   Debug "изменено down"+ *This
;                   Debug DropText()
;                 EndIf
;             EndIf
;             
; ;         ; Отключает передачу сообщений в 
; ;         ; оконную и рутовскую процедуру
;          ProcedureReturn 1
;     EndSelect
  EndProcedure
  
  Procedure Widgets_Window_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    If EventType <> #PB_EventType_MouseMove
      Debug " window "+ EventType
    EndIf
    
;     ; Protected EventWidget = EventWidget()
;     ; Protected EventType = WidgetEvent()
;     ; Protected EventItem = GetState(EventWidget)))
;     
;     ;Select EventWidget
;    ;   Default
;         
;         Select EventType 
;           Case #PB_EventType_LeftButtonDown
;             Debug "Widgets_Window_Events"
;             
;             
;             ;         ; Отключает передачу сообщений в 
;             ;         ; рутовскую процедуру
;             ;         ProcedureReturn 1
;             
;         EndSelect
;         
;     ;EndSelect
    
  EndProcedure
  
  Procedure Widgets_Root_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    If EventType <> #PB_EventType_MouseMove
      Debug " root "+ EventType
    EndIf
    
;     Select EventType 
;       Case #PB_EventType_Create
;         Debug "class - "+GetClass(EventWidget) +" "+ EventWidget() +" "+ EventType +" "+ WidgetEvent()
;         ; ProcedureReturn 1
;         
;       Case #PB_EventType_LeftButtonDown
;         Debug "Widgets_Root_Events"
;     EndSelect
  EndProcedure
  
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      Define Editable ; = #PB_Flag_AnchorsGadget
      
      If Open(0, 10,10, 580, 550," root ")
        *win=Form(80, 100, 400, 360, "Window_2", Editable)
        
        Container(30,30,400-60, 360-60, Editable)
        Container(20,20,400-60, 360-60, Editable)
        *but=Button(100, 20, 80, 80, "Button_1", Editable)
    
        Tree(130, 80, 180, 180, Editable)
        
        Define i
        For i=0 To 20
          AddItem(Widget(), i, "item_"+ Str(i))
        Next
        
        Define *progress = Progress(30, 80, 80+40, 80, 30, 60, Editable)
        Define *track = Track(30, 170, 80+40, 30, 30, 60, Editable)
        Define *splitter = Splitter(10, 80, 130, 150, *progress, *track, #PB_Splitter_Separator)
        SetState(*progress, 50)
        SetState(*track, 50)
        
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
; Folding = -0-
; EnableXP