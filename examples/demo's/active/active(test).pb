; commit 1,460 Ok
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_set = 1
   test_focus_show = 1
   
   
   Procedure OpenMenu( parent )
      Protected *menu = CreateMenuBar( parent ) 
      ;SetClass(widget( )\root, "mainroot" )
      
      ;\\
      BarTitle("Title-1")
      BarItem(1, "title-1-item-1")
      BarSeparator( )
      
      OpenSubBar("title-1-sub-item")
      BarItem(3, "title-1-item")
      BarSeparator( )
      ;
      OpenSubBar("title-2-sub-item")   
      BarItem(13, "title-2-item")
      BarSeparator( )
      ;
      OpenSubBar("title-3-sub-item")   
      BarItem(23, "test(EVENT)")
      CloseSubBar( ) 
      ;
      BarSeparator( )
      BarItem(14, "title-2-item")
      CloseSubBar( ) 
      ;
      BarSeparator( )
      BarItem(4, "title-1-item")
      CloseSubBar( ) 
      ;
      BarSeparator( )
      BarItem(2, "title-1-item-2")
      
      ;\\
      BarTitle("Title-2")
      ;    BarItem(5, "title-2-item-1")
      ;    BarItem(6, "title-2-item-2")
      
      ;\\
      BarTitle("Title-event-test")
      BarItem(7, "test")
      BarSeparator( )
      BarItem(8, "quit")
      
      ;\\
      BarTitle("Title-4")
      BarItem(9, "title-4-item-1")
      BarItem(10, "title-4-item-2")
      
;       ;Bind(*menu, @TestHandler(), -1, 7)
;       Bind(*menu, @QuitHandler(), -1, 8)
;       Bind(*menu, @TestHandler(), -1, 23)
      
   EndProcedure
   
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
   
   Procedure CanvasButtonGadget( gadget, X,Y,Width,Height,Text.s )
      CanvasGadget(gadget, X,Y,Width,Height, #PB_Canvas_DrawFocus )
      
      If StartDrawing(CanvasOutput(gadget))
         DrawingFont(GetGadgetFont(-1))
         DrawText((DesktopScaledX(Width)-TextWidth(Text))/2, (DesktopScaledY(Height)-TextHeight(Text))/2, Text)
         StopDrawing()
      EndIf
   EndProcedure
   If OpenWindow(0, 100, 100, 270, 140, "CanvasWindow", #PB_Window_SystemMenu )
      CanvasButtonGadget(10, 10, 10, 250, 120, "CanvasGadget")
   EndIf
   If Open(1, 100, 300, 270, 140, "Root_0_Window", #PB_Window_SystemMenu )
      OpenMenu( root())
      Window( 30, 30, 200, 200, "Form", #PB_Window_SystemMenu )
      ;Root( )\text\align\right = 0
      SetClass(root( ), "Root_0")
      SetText(root( ), "Root_0")
      SetWindowTitle( 1, "Root_0_canvas_"+Str(GetCanvasGadget(root())))
   EndIf
   
   If OpenWindow(2, 0, 0, 500, 500, " focus demo ", #PB_Window_SystemMenu |
                                                    #PB_Window_ScreenCentered )
      SetWindowColor( 2, $ACC0DB)
      Open( 2, 10,10,235, 190 )
      SetClass(root( ), "Root_2")
      SetText(root( ), "Root_2")
      
      CanvasButtonGadget(20, 255, 10, 235, 190, "CanvasGadget")
      
      Open( 2, 10,210,480, 280 )
      OpenMenu( root())
      Resize( root( ), 10,10,460,260 )
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
      
      ;       ;
      SetActive( 0 )
      SetActiveGadget( root( )\canvas\gadget )
      ;SetActiveGadget( widget( )\root\canvas\gadget )
      
      WaitEvent( );@CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = --
; EnableXP
; DPIAware