XIncludeFile "../../../widgets.pbi"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Define bh = 140,h = bh*4 + 2, size = 100
   Define *r1, *g11, *g12, *g13, *g14, *g15
   Define *r2, *g21, *g22, *g23, *g24, *g25
   
   Procedure events()
      Static drag, deltax, deltay
      
      If eventwidget() <> root()
         Select WidgetEvent()
            Case #__event_down
;                deltax = mouse()\x-eventwidget()\x
;                deltay = mouse()\y-eventwidget()\y
               deltax = DesktopMouseX()-eventwidget()\x
               deltay = DesktopMouseY()-eventwidget()\y
               SetWidgetColor(eventwidget(), #__color_frame, $ffff0000)
               
            Case #__event_dragstart
               drag = eventwidget()
               
            Case #__event_up : Debug "up "+eventwidget()\class ;+" "+ enteredwidget()\class+" "+pressedwidget()\class
               drag = 0
               If eventwidget()\enter
                  SetWidgetColor(eventwidget(), #__color_frame, $ff0000ff)
               Else
                  SetWidgetColor(eventwidget(), #__color_frame, $ff00ff00)
               EndIf
               
            Case #__event_mouseenter : Debug "enter "+eventwidget()\class 
               If Not eventwidget()\press
                  SetWidgetColor(eventwidget(), #__color_frame, $ff0000ff)
               EndIf
               
            Case #__event_mouseleave : Debug "leave "+eventwidget()\class 
               If Not eventwidget()\press
                  SetWidgetColor(eventwidget(), #__color_frame, $ff00ff00)
               EndIf
               
               
            Case #__event_mousemove
               If drag
                  ;Debug " "+eventwidget() +" "+ enteredwidget()+" "+pressedwidget()
               ;   ResizeWidget(drag,mouse()\x-deltax, mouse()\y-deltay, #PB_Ignore, #PB_Ignore)
                  ResizeWidget(drag,DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
               EndIf
               
            Case #__event_keyup
               drag = 0
            Case #__event_keydown
               ;Debug " "+eventwidget() +" "+ enteredwidget()+" "+pressedwidget()
               drag = enteredwidget()
               
               If drag
                  ResizeWidget(drag,x(drag)+1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
               EndIf
               
         EndSelect
      EndIf
      
   EndProcedure
   
   If OpenWindow(0, 0, 0, 685, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ;\\
      *r1 = OpenRoot(0, 5, 5, 335, 60+h-10)
      Define x = 50, y = 50
      *g11 = ContainerWidget( x+10,y+10,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g11,"*g11")
      *g12 = ContainerWidget( x+30,y+30,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g12,"*g12") 
      *g13 = ContainerWidget( x+50,y+50,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g13,"*g13") 
      *g14 = ContainerWidget( x+70,y+70,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g14,"*g14") 
      ;*g15 = ContainerWidget( x+90,y+90,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g15,"*g15") 
      *g15 = TreeWidget( x+90,y+90,size,size ) : SetWidgetClass(*g15,"*g15") 
      Define i
      For i=0 To 10
         AddItem(*g15, -1, "item-"+Str(i)) 
      Next
      
      
      
      ;\\
      *r2 = OpenRoot(0, 345, 5, 335, 60+h-10, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Define x = 0, y = 0
      *g21 = ContainerWidget( x+10,y+10,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g21,"*g21")
      *g22 = ContainerWidget( x+30,y+30,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g22,"*g22") 
      *g23 = ContainerWidget( x+50,y+50,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g23,"*g23") 
      *g24 = ContainerWidget( x+70,y+70,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g24,"*g24") 
      ;*g25 = ContainerWidget( x+90,y+90,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetWidgetClass(*g25,"*g25") 
      *g25 = TreeWidget( x+90,y+90,size,size ) : SetWidgetClass(*g25,"*g25") : AddItem(*g25, -1, "item-1") : AddItem(*g25, -1, "item-2") : AddItem(*g25, -1, "item-3")
      
      
      ;\\
      BindWidgetEvent(#PB_All, @events( ), #__event_down)
      BindWidgetEvent(#PB_All, @events( ), #__event_dragstart)
      BindWidgetEvent(#PB_All, @events( ), #__event_up)
      
      BindWidgetEvent(#PB_All, @events( ), #__event_mouseenter)
      BindWidgetEvent(#PB_All, @events( ), #__event_mousemove)
      BindWidgetEvent(#PB_All, @events( ), #__event_mouseleave)
      
      BindWidgetEvent(#PB_All, @events( ), #__event_keydown)
      BindWidgetEvent(#PB_All, @events( ), #__event_keyup)
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = --
; EnableXP
; DPIAware