 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object, parent, object1
  Declare CustomEvents( )
  
  Procedure GetBar( *this._s_widget, type=1)
     If *this\scroll
        If type = 1
           ProcedureReturn *this\scroll\v
        EndIf
        If type = 2
           ProcedureReturn *this\scroll\h
        EndIf
     EndIf
  EndProcedure
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define fs = 20
  ;\\
  parent = MDI(50, 50, 500, 500)
  SetFrame(parent, fs*2)
  
  ;\\
  ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  object = AddItem(parent, -1, "Resize me !", -1, #PB_Window_BorderLess) : Resize(object, 100, 100, 250, 250) 
  ;;object = AddItem(parent, -1, "Resize me !", -1, #__flag_BorderLess) : Resize(object, 100, 100, 250, 250) 
   
  ;\\
  SetFrame(object, fs)
  a_set(object, #__a_full, 8)
; ;   SizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
; ;   MoveBounds(object, fs, fs, 501-fs, 501-fs)
  
  object1 = ScrollArea(10, 10, 250, 250, 350,350, 1) : SetState( GetBar( object1, 1 ), 80 )
   ;  object = ScrollArea(100, 100, 250, 250, 150,150, 1) 
   Button( 50,50,100,100, GetClass(object1))
   ; Container( 50,50,100,100) : CloseList()
   ; Window(50,50,100,100, GetClass(object), #PB_Window_BorderLess | #PB_Window_SizeGadget, object) : CloseList()
   CloseList()
   
  ;\\
  Bind( widget( ), @CustomEvents(), #__event_draw )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEventType( )
      Case #__event_draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If Eventwidget()\bounds\move
          Box(Eventwidget()\parent\x[#__c_frame] + Eventwidget()\bounds\move\min\x,
              Eventwidget()\parent\y[#__c_frame] + Eventwidget()\parent\fs[2] + Eventwidget()\bounds\move\min\y,
              Eventwidget()\bounds\move\max\x-Eventwidget()\bounds\move\min\x,
              Eventwidget()\bounds\move\max\y-Eventwidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If Eventwidget()\bounds\size
;           Box(Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\min\height,
;               Eventwidget()\bounds\size\max\width-Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\max\height-Eventwidget()\bounds\size\min\height, $ffff0000)
          
          Box(Eventwidget()\x[#__c_frame],
              Eventwidget()\y[#__c_frame],
              Eventwidget()\bounds\size\min\width,
              Eventwidget()\bounds\size\min\height, $ff00ff00)
          
          Box(Eventwidget()\x[#__c_frame],
              Eventwidget()\y[#__c_frame],
              Eventwidget()\bounds\size\max\width,
              Eventwidget()\bounds\size\max\height, $ffff0000)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 56
; FirstLine = 36
; Folding = --
; EnableXP