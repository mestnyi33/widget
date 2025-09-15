IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_draw_contex = 0
   test_draw_repaint = 1
   
   Global i, *test._s_widget
   Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
      ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
      DesktopMouseX() - GadgetX(_canvas_, _mode_)
      ; WindowMouseX(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
   EndMacro
   Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
      ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
      DesktopMouseY() - GadgetY(_canvas_, _mode_)
      ; WindowMouseY(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
   EndMacro
   
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
   
   Procedure HandlerEvents( )
      Protected event = WidgetEvent( ) 
      Protected *this._s_widget = EventWidget( )
      
      ;\\
      If event = #__event_MouseEnter
         Debug " -enter- "+*this\class +" ("+ *this\enter +") " + WidgetEventData( )
         DrawCanvasFrame(*this\root\canvas\gadget, $00A600)
      EndIf
      
      ;\\
      If event = #__event_MouseLeave
         Debug " -leave- "+*this\class +" ("+ *this\enter +") " + WidgetEventData( )
         DrawCanvasFrame(*this\root\canvas\gadget, 0)
      EndIf
      
      If event = #__event_MouseMove
         Debug " -move- "+*this\class +" "+ DesktopMouseX( ) +" "+ Str(GadgetMouseX(*this\root\canvas\gadget)) +" "+ *this\x +" "+ *this\y +" "+ *this\width +" "+ *this\height
         
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Bind(#PB_All, @HandlerEvents( ))
      
      ButtonGadget(-1, 0,0,500,20,"")
      Button( 0,30,500,20,"")
      
      Debug WindowX( root()\canvas\window, #PB_Window_InnerCoordinate ) ; 518
      Debug GadgetX( root()\canvas\gadget, #PB_Gadget_ScreenCoordinate ); 518
      Debug WindowWidth( root()\canvas\window, #PB_Window_InnerCoordinate ) ; 500
      Debug GadgetWidth( root()\canvas\gadget )                             ; 500
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 83
; FirstLine = 46
; Folding = ---
; EnableXP
; DPIAware