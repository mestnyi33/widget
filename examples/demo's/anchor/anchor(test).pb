 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
  widget()\fs = 20 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  ; object = Window(150, 150, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  ; object = Window(150, 150, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ; object = Container(150, 150, 250, 250) : CloseList()
   object = ScrollArea(150, 150, 250, 250, 0,100, 1) : CloseList()
  widget()\fs = 20 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  a_mode(object, #__a_full, 40)
;   SizeBounds(object, 200, 200, 401, 401)
;   MoveBounds(object, 100, 100, 501, 501)
  
  ;\\
  Bind( widget( ), @CustomEvents(), #PB_EventType_Draw )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEventType( )
      Case #PB_EventType_Draw
        
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
; CursorPosition = 25
; FirstLine = 7
; Folding = -
; EnableXP