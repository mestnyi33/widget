XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   test_draw_area = 1
   
   Global si = 150
   Global pad = 0
   Global fr = 0
   ;Global g,*g._s_widget, b,*b, i, time, ss=50,Sw = 296, Sh = 296, count;=1000;0
   Global g,*g._s_widget, b,*b, i, time, ss=1,Sw = 300-fr*2, Sh = 300-fr*2, count;=1000;0
   
   Procedure draw_events( )
      Protected *g._s_widget = EventWidget( )
      Debug " - "+ClassFromEvent(WidgetEvent( ))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box( *g\x,*g\y,*g\width,*g\height, $000000 )
   EndProcedure
   
   If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;*g = Container(10, 10, 300, 300, #__flag_BorderLess)
      *g = ScrollArea(10, 10, 300, 300, Sw, Sh, ss, #__flag_BorderLess)
    ;   SetFrame( *g, fr )
     ; Debug ""+fr+" "+Sw+" "+DPIScaledX(298) +" "+ DPIUnscaledX(DPIScaledX(298)) +" "+ DPIUnscaledX(298)
      
      ;SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
      Button(pad, pad, si, si, "Button1")
      Button(Sw-si-pad, Sh-si-pad, si, si, "Button2")
      CloseList()
      
      Bind(*g, @draw_events( ), #__event_Draw )
      WaitClose()
      ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware