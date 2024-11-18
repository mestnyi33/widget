XIncludeFile "../../../widgets.pbi"

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define object
  Declare CustomEvents( )
  
  OpenRoot(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  
  ; object = WindowWidget(150, 150, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  object = ContainerWidget(150, 150, 300, 300) : CloseWidgetList()
  
  SetSizeBounds(object, 200, 200, 401, 401)
  SetMoveBounds(object, 100, 100, 501, 501)
  
  BindWidgetEvent( widget( ), @CustomEvents(), #__event_Draw )
  WaitCloseRoot( )
  
  Procedure CustomEvents( )
    Select WidgetEvent( )
      Case #__event_Draw
        
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 20
; Folding = -
; EnableXP