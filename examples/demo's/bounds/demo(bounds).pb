XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *object._s_WIDGET, parent
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(root(), 10)
   
   ;\\
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
   parent = Container(50, 50, 500, 500)
   
;    SetSizeBounds(parent, -1,-1,-1,-1);, 500, 500, 500, 500)
;    SetMoveBounds(parent, -1,-1,-1,-1);, 50, 50, 50+500, 50+500)
   SetBounds(parent, #__bounds_move|#__bounds_size)
   
   ;\\
   ; *object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   *object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
   ; *object = Container(100, 100, 250, 250) : CloseList()
   ; *object = ScrollArea(100, 100, 250, 250, 350,350, 1) : CloseList()
   ; *object = ScrollArea(100, 100, 250, 250, 150,150, 1) : CloseList()
   
   ;\\
   Define fs = 20
   SetFrame( parent, fs )
   SetFrame( *object, fs )
   
   ;\\
   a_set(*object, #__a_full, DPIScaled(8))
   SetSizeBounds(*object, 200, 200);, 501-fs*2, 501-fs*2)
   SetMoveBounds(*object);, 0, 0, 501-fs*2, 501-fs*2)
   
   ;\\
   ;Bind( parent, @CustomEvents(), #__event_Draw )
   Bind( *object, @CustomEvents(), #__event_Draw )
   WaitClose( )
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
         Case #__event_Draw
            Protected *widget._s_WIDGET = *object;EventWidget( )
            
            ; Demo draw on element
            UnclipOutput()
            DrawingMode(#PB_2DDrawing_Outlined)
            
            If *widget\bounds\move
               With *widget\bounds\move
                  Box( *widget\parent\inner_x( ) + \min\x, *widget\parent\inner_y( ) + \min\y, \max\x - \min\x, \max\y - \min\y, $ff0000ff)
               EndWith
            EndIf
            
            If *widget\bounds\size
               With *widget\bounds\size
                  Box(*widget\frame_x( ), *widget\frame_y( ), \min\width, \min\height, $ff00ff00)
                  Box(*widget\frame_x( ), *widget\frame_y( ), \max\width, \max\height, $ffff0000)
               EndWith
            EndIf
      EndSelect
      
   EndProcedure
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 38
; FirstLine = 22
; Folding = -
; EnableXP