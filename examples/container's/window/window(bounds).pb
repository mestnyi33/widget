;XIncludeFile "../../../widgets.pbi"
XIncludeFile "../../../widget-events.pbi"
Uselib(widget)

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  Procedure CustomEvents( )
    Select WidgetEventType( )
      Case #PB_EventType_Draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If Eventwidget()\bounds\size
          Box(Eventwidget()\bounds\size\width\min+1,
              Eventwidget()\bounds\size\height\min+1,
              Eventwidget()\bounds\size\width\max-Eventwidget()\bounds\size\width\min,
              Eventwidget()\bounds\size\height\max-Eventwidget()\bounds\size\height\min, $ffff0000)
        EndIf
        
        If Eventwidget()\bounds\move
          Box(Eventwidget()\bounds\move\x\min+1,
              Eventwidget()\bounds\move\y\min+1,
              Eventwidget()\bounds\move\x\max-Eventwidget()\bounds\move\x\min,
              Eventwidget()\bounds\move\y\max-Eventwidget()\bounds\move\y\min, $ff0000ff)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
  
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 0)
  
  Window(150, 150, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  ;Container(150, 150, 300, 300) : CloseList()
  SizeBounds(widget(), 200, 200, 400, 400)
  ;MoveBounds(widget(), 200, 200, 400, 400)
  MoveBounds(widget(), 100, 100, 500, 500)
  Bind( widget(), @CustomEvents(), #PB_EventType_Draw )
    
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP