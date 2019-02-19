IncludePath "../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Procedure Widget_Handler(EventGadget, EventType, EventItem, EventData)
    ;   Select Event()
    ;     Case #PB_Event_Widget
    ; If Not (EventType = #PB_EventType_MouseMove And Not GetButtons(EventGadget))
    If EventType <> #PB_EventType_MouseMove
      Debug ""+GetData(EventGadget)+" "+EventType
    EndIf
    
    ;   EndSelect
  EndProcedure
  
  Procedure Canvas_Handler()
    Select Event()
      Case #PB_Event_Gadget
;         If EventType() = #PB_EventType_MouseEnter And GetActiveGadget()<>EventGadget()
;            SetActiveGadget(EventGadget())
;         EndIf
          
        If EventType() <> #PB_EventType_MouseMove ;Not (EventType() = #PB_EventType_MouseMove And Not GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons))
          Debug ""+EventGadget()+" "+EventType()
        EndIf
        
    EndSelect
  EndProcedure

  Procedure Handler()
    Static active
    Protected Canvas = GetWindowData(EventWindow())
        
;     Select Event()
;       Case #PB_Event_Gadget
;         If GetActiveWindow() = EventWindow()
;           If Not active
;             SetActiveGadget(Canvas)
;             PostEvent(#PB_Event_Gadget, EventWindow(), Canvas, #PB_EventType_LeftButtonDown)
;             active = 1
;             Debug 555
;           EndIf
;         EndIf
; 
;       
;     EndSelect
  EndProcedure


  BindEvent(#PB_Event_Gadget, @Canvas_Handler())

  If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
    
    ; 
    BindEvent(#PB_Event_Gadget, @Handler())
    Open(0, 0, 0, 220, 220)
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(20, 20, 180, 180), 10)
    SetData(Button(20, 20, 180, 50, ""), 100)
    SetData(Container(20, 70, 180, 180), 20)
    SetData(Button(20, 20, 180, 50, ""), 200)
    
    Redraw(Root())
    Bind(@Widget_Handler())
    
;     ; 
;     Open(0, 230, 0, 220, 220)
;     SetData(Container(20, 20, 180, 180), 1)
;     SetData(Container(20, 20, 180, 180), 10)
;     SetData(Button(20, 20, 180, 50, ""), 100)
;     SetData(Container(20, 70, 180, 180), 20)
;     SetData(Button(20, 20, 180, 50, ""), 200)
;     
;     Redraw(Root())
;     Bind(@Widget_Handler())
    
    ; Create new pb window and new pb canvas
    Open(10, 0, 0, 220, 220)
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(20, 20, 180, 180), 10)
    SetData(Button(20, 20, 180, 50, ""), 100)
    SetData(Container(20, 70, 180, 180), 20)
    SetData(Button(20, 20, 180, 50, ""), 200)
    
    Redraw(Root())
    Bind(@Widget_Handler())
    
    Repeat
      Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          Select EventType()
            Case #PB_EventType_LeftClick 
              Select EventGadget()
              EndSelect
          EndSelect
      EndSelect
      
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP