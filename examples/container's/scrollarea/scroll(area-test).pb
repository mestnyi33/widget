XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   Global fr = 1
  ;Global g,*g._s_widget, b,*b, i, time, ss=50,Sw = 296, Sh = 296, count;=1000;0
  Global g,*g._s_widget, b,*b, i, time, ss=50,Sw = 300-fr*2, Sh = 300-fr*2, count;=1000;0
  
  Procedure draw_events( )
     Protected *g._s_widget = EventWidget( )
     
     Debug " - "+ClassFromEvent(WidgetEvent())+""
     DrawingMode(#PB_2DDrawing_Outlined)
     Box( *g\x,*g\y,*g\width,*g\height, $000000 )
  EndProcedure
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
     ;*g = Container(10, 10, 300, 300, #__flag_BorderLess)
     *g = ScrollArea(10, 10, 300, 300, Sw, Sh, ss, #__flag_BorderLess)
      SetFrame( *g, fr )
     
    ;SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    *b = Button(Sw-130, Sh-130, 130, 130, "Button")
    CloseList()
    
    Bind(*g, @draw_events( ), #__event_Draw )
    WaitClose()
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 18
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware