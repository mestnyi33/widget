XIncludeFile "../../../widgets.pbi"
UseLib( widget )

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Define bh = 140,h = bh*4 + 2, size = 100
   Define *r1, *g11, *g12, *g13, *g14, *g15
   Define *r2, *g21, *g22, *g23, *g24, *g25
   
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
               
         EndSelect
      EndIf
      
   EndProcedure
   
   If OpenWindow(0, 0, 0, 685, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ;\\
      *r1 = Open(0, 5, 5, 335, 60+h-10)
      Define x = 50, y = 50
      *g11 = Container( x+10,y+10,size,size, #__flag_noGadgets ) : setclass(*g11,"*g11")
      *g12 = Container( x+30,y+30,size,size, #__flag_noGadgets ) : setclass(*g12,"*g12") 
      *g13 = Container( x+50,y+50,size,size, #__flag_noGadgets ) : setclass(*g13,"*g13") 
      *g14 = Container( x+70,y+70,size,size, #__flag_noGadgets ) : setclass(*g14,"*g14") 
      ;*g15 = Container( x+90,y+90,size,size, #__flag_noGadgets ) : setclass(*g15,"*g15") 
      *g15 = tree( x+90,y+90,size,size ) : setclass(*g15,"*g15") : AddItem(*g15, -1, "item-1") : AddItem(*g15, -1, "item-2") : AddItem(*g15, -1, "item-3")
      
      
      ;\\
      *r2 = Open(0, 345, 5, 335, 60+h-10, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Define x = 0, y = 0
      *g21 = Container( x+10,y+10,size,size, #__flag_noGadgets ) : setclass(*g21,"*g21")
      *g22 = Container( x+30,y+30,size,size, #__flag_noGadgets ) : setclass(*g22,"*g22") 
      *g23 = Container( x+50,y+50,size,size, #__flag_noGadgets ) : setclass(*g23,"*g23") 
      *g24 = Container( x+70,y+70,size,size, #__flag_noGadgets ) : setclass(*g24,"*g24") 
      ;*g25 = Container( x+90,y+90,size,size, #__flag_noGadgets ) : setclass(*g25,"*g25") 
      *g25 = tree( x+90,y+90,size,size ) : setclass(*g25,"*g25") : AddItem(*g25, -1, "item-1") : AddItem(*g25, -1, "item-2") : AddItem(*g25, -1, "item-3")
      
      
      ;\\
      Bind(#PB_All, @events( ), #__event_down)
      Bind(#PB_All, @events( ), #__event_dragstart)
      Bind(#PB_All, @events( ), #__event_up)
      
      Bind(#PB_All, @events( ), #__event_mouseenter)
      Bind(#PB_All, @events( ), #__event_mousemove)
      Bind(#PB_All, @events( ), #__event_mouseleave)
      
      Bind(#PB_All, @events( ), #__event_keydown)
      Bind(#PB_All, @events( ), #__event_keyup)
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP