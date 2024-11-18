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
  OpenRoot(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 10)
  Define fs = 20
  ;\\
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = ContainerWidget(50, 50, 500, 500)
  widget()\fs = DPIScaled(fs) : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  ; object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ; object = ContainerWidget(100, 100, 250, 250) : CloseWidgetList()
  ; object = ScrollAreaWidget(100, 100, 250, 250, 350,350, 1) : CloseWidgetList()
  ; object = ScrollAreaWidget(100, 100, 250, 250, 150,150, 1) : CloseWidgetList()
  
  ;\\
  widget()\fs = DPIScaled(fs) : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  a_set(object, #__a_full, DPIScaled(8))
  SetSizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
  SetMoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
  
  ;\\
  BindWidgetEvent( widget( ), @CustomEvents(), #__event_Draw )
  WaitCloseRoot( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
      Case #__event_Draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If EventWidget()\bounds\move
          Box(EventWidget()\parent\inner_x( ) + EventWidget()\bounds\move\min\x,
              EventWidget()\parent\inner_y( ) + EventWidget()\bounds\move\min\y,
              EventWidget()\bounds\move\max\x - EventWidget()\bounds\move\min\x,
              EventWidget()\bounds\move\max\y - EventWidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If EventWidget()\bounds\size
          Box(EventWidget()\frame_x( ),
              EventWidget()\frame_y( ),
              EventWidget()\bounds\size\min\width,
              EventWidget()\bounds\size\min\height, $ff00ff00)
          
          Box(EventWidget()\frame_x( ),
              EventWidget()\frame_y( ),
              EventWidget()\bounds\size\max\width,
              EventWidget()\bounds\size\max\height, $ffff0000)
        EndIf
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 64
; FirstLine = 42
; Folding = -
; EnableXP