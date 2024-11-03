;
#window = 0

Procedure Container(g, x,y,w,h, t$)
  Protected r = ContainerGadget(g, x,y,w,h,#PB_Container_Flat) ; в линукс и макос прозрачный
  Define s = TextGadget(-1, 0,0,w,h, t$) ; в линукс и макос прозрачный
  ;Define s = StringGadget(-1, 0,0,w,h, t$, #PB_String_BorderLess)
  SetGadgetColor(s, #PB_Gadget_BackColor, $f0f0f0)
  
  ProcedureReturn r
EndProcedure

Procedure Container2(g, x,y,w,h, t$)
  Protected r = CanvasGadget(g, x,y,w,h,#PB_Canvas_Border|#PB_Canvas_Container)
  StartDrawing(CanvasOutput(r))
  DrawingMode( #PB_2DDrawing_Default)
  Box(0,0, OutputWidth(), OutputHeight(),$f0f0f0)
  ;   DrawingMode( #PB_2DDrawing_Outlined)
  ;   Box(0,0, OutputWidth(), OutputHeight(),$000000)
  DrawingMode( #PB_2DDrawing_Transparent)
  DrawText(0,0, t$,$000000)
  StopDrawing()
  ProcedureReturn r
EndProcedure

OpenWindow(#window, 0, 0, 400, 300, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)


Container(#PB_Any, 20, 20, 180, 180, "1") ; , "1") ;  
Container(#PB_Any, 70, 10, 70, 180, "2") : CloseGadgetList( ) ; , "2") ;  
Container(#PB_Any, 40, 20, 180, 180, "3")                     ; , "3") ; 
Define four = Container(#PB_Any, 20, 20, 180, 180, "      4") ; 

Container(#PB_Any, 5, 30, 180, 30, "     5") : CloseGadgetList( ) ; , "     5") ;  
Container(#PB_Any, 5, 45, 180, 30, "     6") : CloseGadgetList( ) ; , "     6") ;  
Container(#PB_Any, 5, 60, 180, 30, "     7") : CloseGadgetList( ) ; , "     7") ;  

CloseGadgetList( ) ;  ; 4
CloseGadgetList( ) ;  ; 3
Container(#PB_Any, 10, 45, 70, 180, "8") ; , "8") ;  
Container(#PB_Any, 10, 10, 70, 30, "9") : CloseGadgetList( ) ; , "9") ;  
Container(#PB_Any, 10, 20, 70, 30, "10") : CloseGadgetList( ); , "10") ;  
Container(#PB_Any, 10, 30, 170, 130, "11") : CloseGadgetList( ) ; , "11") ;  

Container(#PB_Any, 10, 45, 70, 180, "12") ; , "12") ;  
Container(#PB_Any, 10, 5, 70, 180, "13")  ; , "13") ;  
Container(#PB_Any, 10, 5, 70, 180, "14")  ; , "14") ;  
Container(#PB_Any, 10, 10, 70, 30, "15") : CloseGadgetList( ) ; , "15") ;  
CloseGadgetList( )                                                      ;  ; 14
CloseGadgetList( )                                                      ;  ; 13
CloseGadgetList( )                                                      ;  ; 12
CloseGadgetList( )                                                      ;  ; 8
                                                                        ;CloseList( ) ;  ; 1

Debug " ---- ";+openedwidget() ; \index;text\string
OpenGadgetList( four ) ; 4
Container(#PB_Any,  -5, 80, 180, 50, "container-4") : CloseGadgetList( ) ; , "container-7") ; 
CloseGadgetList( )                                                                 ;  ; 4
Debug " ---- "                                                                     ;+openedwidget() ; \index;text\string

Repeat 
  event = WaitWindowEvent( ) 
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableXP