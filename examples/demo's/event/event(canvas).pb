IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
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
   
   Procedure   DrawCanvasFrame(gadget, color)
      If GadgetType(gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(gadget))
         If GetGadgetState(gadget)
            DrawImage(0,0, GetGadgetState(gadget))
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
   
   Procedure events( )
      Protected event = __event( ) ; *event\type ; events( ) ; GetEvent( )
      Protected *this._s_widget = EventWidget( )
      
      ;\\
      If event = #__event_MouseEnter
         Debug " -enter- "+*this\class +" ("+ *this\enter +") " + WidgetEvent( )\data
         DrawCanvasFrame(*this\root\canvas\gadget, $00A600)
      EndIf
      
      ;\\
      If event = #__event_MouseLeave
         Debug " -leave- "+*this\class +" ("+ *this\enter +") " + WidgetEvent( )\data
         DrawCanvasFrame(*this\root\canvas\gadget, 0)
      EndIf
      
      If event = #__event_MouseMove
         Debug " -move- "+*this\class +" "+ Str(CanvasMousex(*this\root\canvas\gadget)) +" "+ Str(CanvasMousey(*this\root\canvas\gadget)) +" "+ *this\x +" "+ *this\y +" "+ *this\width +" "+ *this\height 
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Bind(#PB_All, @events( ))
      
      Debug WindowX( root()\canvas\window, #PB_Window_InnerCoordinate ) ; 518
      Debug GadgetX( root()\canvas\gadget, #PB_Gadget_ScreenCoordinate ) ; 518
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 63
; FirstLine = 38
; Folding = ---
; EnableXP
; DPIAware