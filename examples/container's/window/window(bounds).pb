XIncludeFile "../../../widgets.pbi"

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Define object
  Declare CustomEvents( )
  
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 20)
  
  ; object = Window(150, 150, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  object = Container(150, 150, 300, 300) : CloseList()
  
;   SizeBounds(object, 200, 200, 400, 400)
;   MoveBounds(object, 100, 100, 500, 500)
  
  Bind( widget( ), @CustomEvents(), #PB_EventType_Draw )
  WaitClose( )
  
  Procedure CustomEvents( )
    Select WidgetEventType( )
      Case #PB_EventType_Draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If Eventwidget()\bounds\move
          Box(Eventwidget()\bounds\move\min\x,
              Eventwidget()\bounds\move\min\y,
              Eventwidget()\bounds\move\max\x-Eventwidget()\bounds\move\min\x,
              Eventwidget()\bounds\move\max\y-Eventwidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If Eventwidget()\bounds\size
          Box(Eventwidget()\bounds\size\min\width,
              Eventwidget()\bounds\size\min\height,
              Eventwidget()\bounds\size\max\width-Eventwidget()\bounds\size\min\width,
              Eventwidget()\bounds\size\max\height-Eventwidget()\bounds\size\min\height, $ffff0000)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP