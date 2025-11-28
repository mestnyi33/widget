XIncludeFile "../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure gadget_events()
      Debug "change "+GetGadgetState(EventGadget())
   EndProcedure
   
   Procedure widget_events( )
      Debug "---------"
      Debug EventWidget()\bar\percent
      Debug ""
      Debug EventWidget()\bar\area\pos
      Debug EventWidget()\bar\area\len
      Debug EventWidget()\bar\area\end
      Debug EventWidget()\bar\area\change
      Debug ""
      Debug EventWidget()\bar\thumb\pos
      Debug EventWidget()\bar\thumb\len
      Debug EventWidget()\bar\thumb\end
      Debug EventWidget()\bar\thumb\change
      Debug ""
      Debug EventWidget()\bar\page\pos
      Debug EventWidget()\bar\page\len
      Debug EventWidget()\bar\page\end
      Debug EventWidget()\bar\page\change
      Debug ""
;       Debug ""+EventWidget()\class+" "+ClassFromEvent( WidgetEvent( )) +" "+ GetState(EventWidget()) +" "+ 
;             EventWidget()\bar\thumb\pos ;+" "+ EventWidget()\bar\page\pos ;+" "+ EventWidget()\bar\ThumbChange( ) +" "+ EventWidget()\bar\PageChange( ) ; WidgetEventData( )
   EndProcedure
   
   If OpenWindow( 0, 0, 0, 400, 260, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ScrollBarGadget( 1, 10, 10, 370, 30, 0, 0, 0 ) : 
      SetGadgetState( 1, 30 )
      BindGadgetEvent( 1, @gadget_events( ), #PB_EventType_LeftClick )
      
      ScrollBarGadget( 2, 10, 45, 370, 30, 20, 1, 1 )
      SetGadgetState( 2, 30 )
      BindGadgetEvent( 2, @gadget_events( ), #PB_EventType_LeftClick )
      
      ScrollBarGadget( 3, 10, 80, 370, 30, 0, 50, 0 )
      SetGadgetState( 3, 30 )
      BindGadgetEvent( 3, @gadget_events( ), #PB_EventType_LeftClick )
      
      If Open( 0, 0, 130, 400, 130 )
         Scroll( 10, 10, 370, 30, 0, 0, 0 ) : 
         SetState( widget( ), 30 )
         Bind( widget( ), @widget_events( ), #__event_Change )
         
         Scroll( 10, 45, 370, 30, 20, 1, 1 )
         SetState( widget( ), 30 )
         Bind( widget( ), @widget_events( ), #__event_Change )
         
         Scroll( 10, 80, 370, 30, 0, 50, 0 )
         SetState( widget( ), 30 )
         Bind( widget( ), @widget_events( ), #__event_Change )
         
         WaitClose( )
      EndIf
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 47
; FirstLine = 23
; Folding = -
; EnableXP
; DPIAware