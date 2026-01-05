XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure widget_events( )
      Debug ""+EventWidget()\class+" "+EventString( WidgetEvent( )) +" "+ GetState(EventWidget()) +" "+ 
            EventWidget()\bar\thumb\pos ;+" "+ EventWidget()\bar\page\pos ;+" "+ EventWidget()\bar\ThumbChange( ) +" "+ EventWidget()\bar\PageChange( ) ; WidgetEventData( )
   EndProcedure
   
   If Open( 0, 0, 0, 400, 130, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Scroll( 10, 10, 370, 30, 20, 50, 8 )
      
      SetState( Widget( ), 30 )
      SetAttribute( Widget( ), #__Bar_ButtonSize, 30 )
      
      Bind( Widget( ), @widget_events( ), #__event_Change )
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware