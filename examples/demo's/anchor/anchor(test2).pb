XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define fs = 20
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
  widget()\fs = fs*2 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  ; object = Window(100, 100, 250, 250, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  ; object = Window(5, 5, 250, 250, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
   object = Container(100, 100, 250, 250) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 350,350, 1) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 150,150, 1) : CloseList()
  
  ;\\
  widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  a_set(object, #__a_full, 18)
; ;   SetSizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
; ;   SetMoveBounds(object, fs, fs, 501-fs, 501-fs)
  
  ;\\
  Bind( widget( ), @CustomEvents(), #__event_draw )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
      Case #__event_draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If EventWidget()\bounds\move
          Box(EventWidget()\parent\x[#__c_frame] + EventWidget()\bounds\move\min\x,
              EventWidget()\parent\y[#__c_frame] + EventWidget()\parent\fs[2] + EventWidget()\bounds\move\min\y,
              EventWidget()\bounds\move\max\x-EventWidget()\bounds\move\min\x,
              EventWidget()\bounds\move\max\y-EventWidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If EventWidget()\bounds\size
;           Box(Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\min\height,
;               Eventwidget()\bounds\size\max\width-Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\max\height-Eventwidget()\bounds\size\min\height, $ffff0000)
          
          Box(EventWidget()\x[#__c_frame],
              EventWidget()\y[#__c_frame],
              EventWidget()\bounds\size\min\width,
              EventWidget()\bounds\size\min\height, $ff00ff00)
          
          Box(EventWidget()\x[#__c_frame],
              EventWidget()\y[#__c_frame],
              EventWidget()\bounds\size\max\width,
              EventWidget()\bounds\size\max\height, $ffff0000)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware