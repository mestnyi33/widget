IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_contex = 0
   test_draw_repaint = 1
   
   Global i, *test._s_widget
   
   Procedure   DrawCanvasBack(gadget, color)
      If GadgetType(gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(gadget))
         DrawingMode(#PB_2DDrawing_Default)
         Box(0,0,OutputWidth(), OutputHeight(), color)
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure   DrawCanvasFrameWidget(gadget, color)
      If GadgetType(gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(gadget))
         If GetGadGetWidgetState(gadget)
            DrawImage(0,0, GetGadGetWidgetState(gadget))
         EndIf
         If Not color
            color = Point(10,10)
         EndIf
         If color 
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(0,0,OutputWidth(), OutputHeight(), color)
         EndIf
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure HandlerEvents( )
      Protected event = WidgetEvent( ) 
      Protected *this._s_widget = EventWidget( )
      
      ;\\
      If event = #__event_MouseEnter
         Debug " -enter- "+*this\class +" ("+ *this\enter +") " + WidgetEventData( )
         DrawCanvasFrameWidget(*this\root\canvas\gadget, $00A600)
      EndIf
      
      ;\\
      If event = #__event_MouseLeave
         Debug " -leave- "+*this\class +" ("+ *this\enter +") " + WidgetEventData( )
         DrawCanvasFrameWidget(*this\root\canvas\gadget, 0)
      EndIf
      
      If event = #__event_MouseMove
         Debug " -move- "+*this\class +" "+ DesktopMouseX( ) +" "+ Str(GetMouseX(*this\root\canvas\gadget)) +" "+ *this\x +" "+ *this\y +" "+ *this\width +" "+ *this\height 
      EndIf
   EndProcedure
   
   If OpenRoot(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      BindWidgetEvent(#PB_All, @HandlerEvents( ))
      
      ButtonGadget(-1, 0,0,500,20,"")
      ButtonWidget( 0,30,500,20,"")
      
      Debug WindowX( Root()\canvas\window, #PB_Window_InnerCoordinate ) ; 518
      Debug GadgetX( Root()\canvas\gadget, #PB_Gadget_ScreenCoordinate ) ; 518
      Debug WindowWidth( Root()\canvas\window, #PB_Window_InnerCoordinate ) ; 500
      Debug GadgetWidth( Root()\canvas\gadget ) ; 500
      
      WaitCloseRoot( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 55
; FirstLine = 44
; Folding = ---
; EnableXP
; DPIAware