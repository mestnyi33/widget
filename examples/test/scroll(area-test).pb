XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   test_draw_area = 1
   
   Global si = 150
   Global pad = 0
   Global fr.f ;= -50
   
   Global g,*g._s_widget, b,*b, i, time, ss=1,Sw = 350-fr, Sh = 300-fr, count;=1000;0
   
   Procedure draw_events( )
      Protected *g._s_widget = EventWidget( )
      Debug " - "+EventString(WidgetEvent( ))
      DrawingMode(#PB_2DDrawing_Outlined)
      Box( *g\x,*g\y,*g\width,*g\height, $000000 )
   EndProcedure
   
   If Open(0, 0, 0, 305+305+20, 320, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g = ScrollArea(10, 10, 300, 300, Sw, Sh, ss, #__flag_BorderLess)
      Container( pad, pad, si, si, #PB_Container_Flat): CloseList()
      Container( Sw-si-pad, Sh-si-pad, si, si, #PB_Container_Flat): CloseList()
      CloseList()
      
      g = ScrollAreaGadget( #PB_Any, 320, 10, 300, 300, Sw, Sh, ss, #PB_ScrollArea_BorderLess)
      ContainerGadget( #PB_Any, pad, pad, si, si, #PB_Container_Flat): CloseGadgetList()
      ContainerGadget( #PB_Any, Sw-si-pad, Sh-si-pad, si, si, #PB_Container_Flat): CloseGadgetList()
      CloseGadgetList()
      
      ; Bind(*g, @draw_events( ), #__event_Draw )
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 15
; Folding = -
; EnableXP
; DPIAware