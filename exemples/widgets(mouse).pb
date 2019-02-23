IncludePath "../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Procedure Widget_Handler(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    ;   Select Event()
    ;     Case #PB_Event_Widget
    ; If Not (EventType = #PB_EventType_MouseMove And Not GetButtons(EventWidget))
    If EventType <> #PB_EventType_MouseMove
      Debug ""+GetData(EventWidget)+" "+EventType
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
          Debug ""+Str(EventGadget())+" "+Str(EventType())
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
    Open(0, 0, 0, 220, 220, "w")
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
    Open(10, 0, 0, 220, 220,"", #PB_Window_ScreenCentered)
    ;Define *w_0 = Container(20, 20, 180, 180) : SetData(*w_0, 1)
    Define *w_1 = Container(0, 20, 180, 180) : SetData(*w_1, 10) : CloseList()
    
    Define *w_2 = Container(0, 20, 180, 180) : SetData(*w_2, 20)
;     Define *w_11 = Container(0, 0, 0, 0) : SetData(*w_11, 110) : CloseList()
;     Define *w_12 = Container(0, 0, 0, 0) : SetData(*w_12, 120) : CloseList()
;     Define *w_13 = Splitter(0, 0, 180, 180/2, *w_11,*w_12) : SetData(*w_13, 130)  
    CloseList()
    
    Define *w_3 = Splitter(10, 10, 180, 180, *w_1,*w_2) : SetData(*w_3, 30)
   
    
    ;SetData(Button(0, 0, 180, 50, "Button"), 100)
    
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