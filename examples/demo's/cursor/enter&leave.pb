XIncludeFile "../../../widgets3.pbi"
UseLib( widget )

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Define bh = 140,h = bh*4 + 2
   Define *g1, *g2, *g3, *g4, *g5
   
   Procedure events()
      Static drag, deltax, deltay
      Select widgeteventtype()
         Case #__event_down
            deltax = mouse()\x-eventwidget()\x
            deltay = mouse()\y-eventwidget()\y
            setcolor(eventwidget(), #__color_frame, $ffff0000)
            
         Case #__event_dragstart
            drag = eventwidget()
            
         Case #__event_up
            Debug "up "+eventwidget()\class +" "+ enteredwidget()\class+" "+pressedwidget()\class
            If drag
            EndIf
            drag = 0
            If eventwidget()\state\enter
               setcolor(eventwidget(), #__color_frame, $ff0000ff)
            Else
               ;setcolor(eventwidget(), #__color_frame, colors::*this\blue\frame)
               setcolor(eventwidget(), #__color_frame, $ff00ff00)
            EndIf
            
         Case #__event_mouseenter
            If drag
               Debug "enter "+eventwidget()\class +" "+ enteredwidget()\class+" "+pressedwidget()\class
            EndIf
            If Not eventwidget()\state\press
               setcolor(eventwidget(), #__color_frame, $ff0000ff)
            EndIf
         Case #__event_mousemove
            If drag
               ;Debug " "+eventwidget() +" "+ enteredwidget()+" "+pressedwidget()
               resize(drag,mouse()\x-deltax, mouse()\y-deltay, #PB_Ignore, #PB_Ignore)
            EndIf
            
         Case #__event_mouseleave
            If drag
               Debug "leave "+eventwidget()\class +" "+ enteredwidget()\class+" "+pressedwidget()\class
            EndIf
            If Not eventwidget()\state\press
               setcolor(eventwidget(), #__color_frame, $ff00ff00)
            EndIf
      EndSelect
      
   EndProcedure
   
   If Open(0, 0, 0, 680, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g1 = Container( 10,10,50,50, #__flag_noGadgets ) : setclass(*g1,"*g1")
      *g2 = Container( 30,30,50,50, #__flag_noGadgets ) : setclass(*g2,"*g2") 
      *g3 = Container( 50,50,50,50, #__flag_noGadgets ) : setclass(*g3,"*g3") 
      *g4 = Container( 70,70,50,50, #__flag_noGadgets ) : setclass(*g4,"*g4") 
      *g5 = Container( 90,90,50,50, #__flag_noGadgets ) : setclass(*g5,"*g5") 
      
      ;       SetColor( *g1, #__color_farame, $ff0000ff, 0)
      ;       SetColor( *g1, #__color_farame, $ff0000ff, 1)
      ;       SetColor( *g1, #__color_farame, $ff0000ff, 2)
      
      Bind(#PB_All, @events( ), #__event_down)
      Bind(#PB_All, @events( ), #__event_dragstart)
      Bind(#PB_All, @events( ), #__event_up)
      
      Bind(#PB_All, @events( ), #__event_mouseenter)
      Bind(#PB_All, @events( ), #__event_mousemove)
      Bind(#PB_All, @events( ), #__event_mouseleave)
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 17
; Folding = --
; EnableXP