XIncludeFile "../../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure widget_events( )
      Debug ""+EventWidget()\class+" "+classFromEvent( WidgetEvent( )) +" "+ GetWidgetState(EventWidget()) +" "+ 
            EventWidget()\bar\thumb\pos ;+" "+ EventWidget()\bar\page\pos ;+" "+ EventWidget()\bar\ThumbChange( ) +" "+ EventWidget()\bar\PageChange( ) ; WidgetEventData( )
   EndProcedure
   
   If OpenRoot(0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ScrollBarWidget(10, 10, 370, 30, 20, 50, 8 )
      
      SetWidgetState(widget( ), 30 )
      SetWidgetAttribute(widget( ), #__Bar_ButtonSize, 30 )
      
      BindWidgetEvent(widget(), @widget_events())
      WaitCloseRoot( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; Folding = -
; EnableXP