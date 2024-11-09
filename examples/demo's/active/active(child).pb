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
      ;Root( )\text\align\right = 0
      SetClass(Root( ), "Root_0")
      SetText(Root( ), "Root_0")
      SetWindowTitle( 1, "Root_0_canvas_"+Str(GetGadget(Root())))
   EndIf
   
   If Open(2, 0, 0, 500, 300, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      SetClass(root( ), "RootWindow" )
      
      ;\\
      Window( 30, 30, 200, 200, "Form", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "Form" )
      ScrollArea( 30,30,140,140, 300,300,1 ) 
      SetClass(widget( ), "ScrollArea" )
      Spin(10,10,100,50, 0,100)
      SetClass(widget( ), "Spin" )
      String(10,65,100,50,"String")
      SetClass(widget( ), "String" )
      SetActive( widget( ) )
      CloseList( )
      
      ;\\
      Window( 260, 30, 200, 200, "Form2", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "Form2" )
      ScrollArea( 30,30,140,140, 300,300,1 ) 
      SetClass(widget( ), "ScrollArea2" )
      Spin(10,10,100,50, 0,100)
      SetClass(widget( ), "Spin2" )
      String(10,65,100,50,"String2")
      SetClass(widget( ), "String2" )
      SetActive( widget( ) )
      CloseList( )
      
      
      WaitEvent( );@CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 46
; FirstLine = 37
; Folding = --
; EnableXP
; DPIAware