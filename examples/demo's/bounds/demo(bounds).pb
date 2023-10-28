XIncludeFile "../../../widgets.pbi"

;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object
  Declare CustomEvents( )
  
  Procedure events()
      Static drag, deltax, deltay
      
      If eventwidget() <> root()
         Select widgeteventtype()
            Case #__event_down
;                deltax = mouse()\x-eventwidget()\x
;                deltay = mouse()\y-eventwidget()\y
               deltax = DesktopMouseX()-eventwidget()\x
               deltay = DesktopMouseY()-eventwidget()\y
               setcolor(eventwidget(), #__color_frame, $ffff0000)
               
            Case #__event_dragstart
               drag = eventwidget()
               
            Case #__event_up : Debug "up "+eventwidget()\class ;+" "+ enteredwidget()\class+" "+pressedwidget()\class
               drag = 0
               If eventwidget()\state\enter
                  setcolor(eventwidget(), #__color_frame, $ff0000ff)
               Else
                  setcolor(eventwidget(), #__color_frame, $ff00ff00)
               EndIf
               
            Case #__event_mouseenter : Debug "enter "+eventwidget()\class 
               If Not eventwidget()\state\press
                  setcolor(eventwidget(), #__color_frame, $ff0000ff)
               EndIf
            Case #__event_mousemove
               If drag
                  ;Debug " "+eventwidget() +" "+ enteredwidget()+" "+pressedwidget()
               ;   resize(drag,mouse()\x-deltax, mouse()\y-deltay, #PB_Ignore, #PB_Ignore)
                  resize(drag,DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
               EndIf
               
            Case #__event_mouseleave : Debug "leave "+eventwidget()\class 
               If Not eventwidget()\state\press
                  setcolor(eventwidget(), #__color_frame, $ff00ff00)
               EndIf
               
               
            Case #__event_keyup
               drag = 0
            Case #__event_keydown
               ;Debug " "+eventwidget() +" "+ enteredwidget()+" "+pressedwidget()
               drag = enteredwidget()
               
               If drag
                  resize(drag,x(drag)+1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
               EndIf
               
         Case #PB_EventType_Draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If Eventwidget()\bounds\move
          Box(Eventwidget()\parent\x[1] + Eventwidget()\bounds\move\min\x,
              Eventwidget()\parent\y[1] + Eventwidget()\bounds\move\min\y,
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
      EndIf
      
   EndProcedure
   
   Open(0, 0, 0, 700, 700, "Demo bounds", #PB_Window_ScreenCentered | #PB_Window_SystemMenu); | #PB_Window_SizeGadget)
  ;a_init(root(), 0)
  
  Container(48, 48, 604, 604)
  object = Window(150, 150, 300, 300, "Resize me !", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_SizeGadget)
  ; object = Container(150, 150, 300, 300) : CloseList()
  
  SizeBounds(object, 200, 200, 401, 401)
  MoveBounds(object, 100, 100, 501, 501)
  
  ;\\
      Bind(#PB_All, @events( ), #__event_down)
      Bind(#PB_All, @events( ), #__event_dragstart)
      Bind(#PB_All, @events( ), #__event_up)
      
      Bind(#PB_All, @events( ), #__event_mouseenter)
      Bind(#PB_All, @events( ), #__event_mousemove)
      Bind(#PB_All, @events( ), #__event_mouseleave)
      
      Bind(#PB_All, @events( ), #__event_keydown)
      Bind(#PB_All, @events( ), #__event_keyup)
      
      Bind( #PB_All, @events(), #PB_EventType_Draw )
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x64)
; Folding = --
; EnableXP