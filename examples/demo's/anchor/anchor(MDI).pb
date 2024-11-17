 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global object, parent, object1
  Declare CustomEvents( )
  
  Procedure GetBar( *this._s_WIDGET, type.w, index.b = 0 )
         If type = #PB_WidgetType_Scroll
            If *this\scroll
               If index = 1
                  ProcedureReturn *this\scroll\v
               EndIf
               If index = 2
                  ProcedureReturn *this\scroll\h
               EndIf
            EndIf
         EndIf
      EndProcedure
      
      
  ;\\
  OpenRootWidget(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define fs = 20
  ;\\
  parent = MDIWidget(50, 50, 500, 500)
  SetWidgetFrame(parent, fs*2)
  
  ;\\
  ; object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  ; object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  object = AddItem(parent, -1, "Resize me !", -1, #PB_Window_BorderLess) : ResizeWidget(object, 100, 100, 250, 250) 
  ;;object = AddItem(parent, -1, "Resize me !", -1, #__flag_BorderLess) : ResizeWidget(object, 100, 100, 250, 250) 
   
  ;\\
  SetWidgetFrame(object, fs)
  a_set(object, #__a_full, 8)
; ;   SetSizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
; ;   SetMoveBounds(object, fs, fs, 501-fs, 501-fs)
  
  object1 = ScrollAreaWidget(10, 10, 250, 250, 350,350, 1) : SetState( GetBar( object1, #PB_WidgetType_Scroll, 1 ), 80 )
   ;  object = ScrollAreaWidget(100, 100, 250, 250, 150,150, 1) 
   ButtonWidget( 50,50,100,100, GetWidgetClass(object1))
   ; ContainerWidget( 50,50,100,100) : CloseWidgetList()
   ; WindowWidget(50,50,100,100, GetWidgetClass(object), #PB_Window_BorderLess | #PB_Window_SizeGadget, object) : CloseWidgetList()
   CloseWidgetList()
   
  ;\\
  BindWidgetEvent( widget( ), @CustomEvents(), #__event_draw )
  WaitCloseRootWidget( )
  
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
; CursorPosition = 45
; FirstLine = 41
; Folding = --
; EnableXP