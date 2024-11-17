; commit 1,460 Ok
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure CallBack( )
;       Select WidgetEvent( )
;          Case #__event_Focus
;             Debug "active - event " + EventWidget( )\class
;             
;          Case #__event_LostFocus
;             Debug "deactive - event " + EventWidget( )\class
;             
;       EndSelect
   EndProcedure
   
   Procedure CanvasButtonGadget( gadget, x,y,width,height,text.s )
      CanvasGadget(gadget, x,y,width,height, #PB_Canvas_DrawFocus )
      
      If StartDrawing(CanvasOutput(gadget))
         DrawingFont(GetGadgetFont(-1))
         DrawText((DesktopScaledX(width)-TextWidth(text))/2, (DesktopScaledY(height)-TextHeight(text))/2, text)
         StopDrawing()
      EndIf
   EndProcedure
   If OpenWindow(0, 100, 100, 270, 140, "CanvasWindow", #PB_Window_SystemMenu )
      CanvasButtonGadget(10, 10, 10, 250, 120, "CanvasGadget")
   EndIf
   If Open(1, 100, 300, 270, 140, "Root_0_Window", #PB_Window_SystemMenu )
       Window( 30, 30, 200, 200, "Form", #PB_Window_SystemMenu )
      ;Root( )\text\align\right = 0
      SetWidgetClass(Root( ), "Root_0")
      SetTextWidget(Root( ), "Root_0")
      SetWindowTitle( 1, "Root_0_canvas_"+Str(GetCanvasGadget(Root())))
   EndIf
   
   If OpenWindow(2, 0, 0, 500, 500, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      SetWindowColor( 2, $ACC0DB)
      Open( 2, 10,10,235, 190 )
      SetWidgetClass(Root( ), "Root_2")
      SetTextWidget(Root( ), "Root_2")
   
      CanvasButtonGadget(20, 255, 10, 235, 190, "CanvasGadget")
      
      Open( 2, 10,210,480, 280 )
      ResizeWidget( Root( ), 10,10,460,260 )
      SetWidgetClass(root( ), "RootWindow" )
      
      ;\\
      Window( 30, 30, 200, 200, "Form", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetWidgetClass(widget( ), "Form" )
      ScrollAreaWidget( 30,30,140,140, 300,300,1 ) 
      SetWidgetClass(widget( ), "ScrollArea" )
      SpinWidget(10,10,100,50, 0,100)
      SetWidgetClass(widget( ), "Spin" )
      StringWidget(10,65,100,50,"String")
      SetWidgetClass(widget( ), "String" )
      SetActive( widget( ) )
      CloseList( )
      
      ;\\
      Window( 260, 30, 200, 200, "Form2", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetWidgetClass(widget( ), "Form2" )
      ScrollAreaWidget( 30,30,140,140, 300,300,1 ) 
      SetWidgetClass(widget( ), "ScrollArea2" )
      SpinWidget(10,10,100,50, 0,100)
      SetWidgetClass(widget( ), "Spin2" )
      StringWidget(10,65,100,50,"String2")
      SetWidgetClass(widget( ), "String2" )
      SetActive( widget( ) )
      CloseList( )
      
;       ;
       SetActive( 0 )
       SetActiveGadget( root( )\canvas\gadget )
      ;SetActiveGadget( widget( )\root\canvas\gadget )
      
      WaitEvent( );@CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 83
; FirstLine = 55
; Folding = --
; EnableXP
; DPIAware