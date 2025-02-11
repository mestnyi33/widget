XIncludeFile "../../../widgets.pbi"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Define bh = 140,h = bh*4 + 2, size = 100
   Define *r1, *g11, *g12, *g13, *g14, *g15
   Define *r2, *g21, *g22, *g23, *g24, *g25
   
   Procedure Events( )
      Static drag, deltax, deltay
      
      If EventWidget( ) <> root( )
         Select WidgetEvent( )
            Case #__event_down
               deltax = mouse( )\x-EventWidget( )\x
               deltay = mouse( )\y-EventWidget( )\y
;                deltax = DesktopMouseX( )-EventWidget( )\x
;                deltay = DesktopMouseY( )-EventWidget( )\y
               SetColor(EventWidget( ), #__color_frame, $ffff0000)
               
            Case #__event_dragstart
               drag = EventWidget( )
               
            Case #__event_up : Debug "up "+EventWidget( )\class ;+" "+ Entered( )\class+" "+Pressed( )\class
               drag = 0
               If EventWidget( )\enter
                  SetColor(EventWidget( ), #__color_frame, $ff0000ff)
               Else
                  SetColor(EventWidget( ), #__color_frame, $ff00ff00)
               EndIf
               
            Case #__event_mouseenter : Debug "enter "+EventWidget( )\class 
               If Not EventWidget( )\press
                  SetColor(EventWidget( ), #__color_frame, $ff0000ff)
               EndIf
               
            Case #__event_mouseleave : Debug "leave "+EventWidget( )\class 
               If Not EventWidget( )\press
                  SetColor(EventWidget( ), #__color_frame, $ff00ff00)
               EndIf
               
               
            Case #__event_mousemove
               If drag
                  ;Debug " "+eventwidget( ) +" "+ Entered( )+" "+Pressed( )
                  Resize(drag, DesktopUnscaledX(mouse( )\x-deltax), DesktopUnscaledY(mouse( )\y-deltay), #PB_Ignore, #PB_Ignore)
               ;   Resize(drag,DesktopMouseX( )-deltax, DesktopMouseY( )-deltay, #PB_Ignore, #PB_Ignore)
               EndIf
               
            Case #__event_keyup
               drag = 0
            Case #__event_keydown
               ;Debug " "+eventwidget( ) +" "+ Entered( )+" "+Pressed( )
               drag = Entered( )
               
               If drag
                  Resize(drag,X(drag)+1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
               EndIf
               
         EndSelect
      EndIf
      
   EndProcedure
   
   If OpenWindow(0, 0, 0, 685, 60+h, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      ;\\
      *r1 = Open(0, 5, 5, 335, 60+h-10)
      Define X = 50, Y = 50
      ;*g11 = Container( X+10,Y+10,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g11,"*g11")
      *g11 = Tree( X+10,Y+10,size,size ) : SetClass(*g11,"*g11") 
      Define i
      For i=0 To 10
         AddItem(*g11, -1, "item-"+Str(i)) 
      Next
      *g12 = Container( X+30,Y+30,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g12,"*g12") 
      *g13 = Container( X+50,Y+50,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g13,"*g13") 
      *g14 = Container( X+70,Y+70,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g14,"*g14") 
      ;*g15 = Container( x+90,y+90,size,size, #__flag_borderflat|#__flag_noGadgets ) : setclass(*g15,"*g15") 
      *g15 = Tree( X+90,Y+90,size,size ) : SetClass(*g15,"*g15") 
      Define i
      For i=0 To 10
         AddItem(*g15, -1, "item-"+Str(i)) 
      Next
      
      
      
      ;\\
      *r2 = Open(0, 345, 5, 335, 60+h-10, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Define X = 0, Y = 0
      ;*g21 = Container( X+10,Y+10,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g21,"*g21")
      *g21 = Tree( X+10,Y+10,size,size ) : SetClass(*g21,"*g21") : AddItem(*g21, -1, "item-1") : AddItem(*g21, -1, "item-2") : AddItem(*g21, -1, "item-3")
      *g22 = Container( X+30,Y+30,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g22,"*g22") 
      *g23 = Container( X+50,Y+50,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g23,"*g23") 
      *g24 = Container( X+70,Y+70,size,size, #__flag_borderflat|#__flag_noGadgets ) : SetClass(*g24,"*g24") 
      ;*g25 = Container( x+90,y+90,size,size, #__flag_borderflat|#__flag_noGadgets ) : setclass(*g25,"*g25") 
      *g25 = Tree( X+90,Y+90,size,size ) : SetClass(*g25,"*g25") : AddItem(*g25, -1, "item-1") : AddItem(*g25, -1, "item-2") : AddItem(*g25, -1, "item-3")
      
      
      ;\\
      Bind(#PB_All, @events( ), #__event_down)
      Bind(#PB_All, @events( ), #__event_dragstart)
      Bind(#PB_All, @events( ), #__event_up)
      
      Bind(#PB_All, @events( ), #__event_mouseenter)
      Bind(#PB_All, @events( ), #__event_mousemove)
      Bind(#PB_All, @events( ), #__event_mouseleave)
      
      Bind(#PB_All, @events( ), #__event_keydown)
      Bind(#PB_All, @events( ), #__event_keyup)
      
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 96
; Folding = --
; EnableXP
; DPIAware