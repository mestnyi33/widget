XIncludeFile "../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define vertical = 0, PageLength = 0
   Global._s_WIDGET *g1, *g2, *scroll1,*scroll2,*scroll3
   
   ; scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )
   Define min = - 3
   Define max = 3
   Define event = #__event_LeftClick
   
   Procedure button_events( )
      Protected state = GetState( *scroll2 )
      Debug "click " + MouseClick( )
   
      Select EventWidget( )
         Case *g1
            state - 1
         Case *g2
            state + 1
      EndSelect
      
      If SetState( *scroll2, state )
         ;       Debug ""+
         ;             *scroll2\bar\button[1]\disable +" "+ 
         ;             *scroll2\bar\button[2]\disable
      EndIf
   EndProcedure
   
   Procedure change_events( )
      SetWindowTitle( EventWindow(), "stste ["+Str(GetState( EventWidget( )))+"]" )
      If *scroll2 = EventWidget( )
         Disable( *g1, EventWidget( )\bar\button[1]\disable )
         Disable( *g2, EventWidget( )\bar\button[2]\disable )
      EndIf
   EndProcedure
   
   If vertical
      ;\\ vertical
      If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         *scroll1 = Scroll(20, 50, 50, 250,  0, 30, PageLength, #PB_ScrollBar_Vertical|#__flag_Invert)
         
         *g1=Button(90, 10, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
         *scroll2 = Scroll(80, 50, 50, 250,  min, max, PageLength, #PB_ScrollBar_Vertical) : Bind( *scroll2, @change_events( ), #__event_Change)
         *g2=Button(90, 310, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
         
         *scroll3 = Scroll(140, 50, 50, 250,  0, 30, PageLength, #PB_ScrollBar_Vertical, 30)
         
         Debug " -setstate-v "
         SetState(*scroll1, 5)
         SetState(*scroll2, 0)
         SetState(*scroll3, 5)
         
         WaitClose( )
      EndIf
   Else
      
      ;\\ horizontal
      If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
         *scroll1 = Scroll(50, 20, 250, 50,  0, 30, PageLength)
         
         *g1=Button(10, 90, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
         *scroll2 = Scroll(50, 80, 250, 50,  min, max, PageLength ) : Bind( *scroll2, @change_events( ), #__event_Change)
         *g2=Button(310, 90, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
         
         *scroll3 = Scroll(50, 140, 250, 50,  0, 30, PageLength, #__flag_Invert) 
         
         Bind( *scroll1, @change_events( ), #__event_Change)
         Bind( *scroll3, @change_events( ), #__event_Change)
         
         Debug " -setstate-h "
         SetState(*scroll1, 5)
         ; SetState(*scroll2, 0)
         SetState(*scroll3, 5)
         
         WaitClose( )
      EndIf
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   UseWidgets( )
   
   Procedure gadget_events()
      Debug "change "+GetGadgetState(EventGadget())
   EndProcedure
   
   Procedure widget_events( )
      ;  Debug " - "
      Debug ""+EventWidget( )\bar\min +" - min"
      Debug ""+EventWidget( )\bar\max +" - max"
      Debug ""+EventWidget( )\bar\percent +" - percent"
      Debug ""
      Debug ""+EventWidget( )\bar\page\pos +" - page\pos"
      Debug ""+EventWidget( )\bar\page\len +" - page\len"
      Debug ""+EventWidget( )\bar\page\end +" - page\end"
      Debug ""
      Debug ""+EventWidget( )\bar\area\pos +" - area\pos"
      Debug ""+EventWidget( )\bar\area\len +" - area\len"
      Debug ""+EventWidget( )\bar\area\end +" - area\end"
      Debug ""
      Debug ""+EventWidget( )\bar\thumb\pos +" - thumb\pos"
      Debug ""+EventWidget( )\bar\thumb\len +" - thumb\len"
      Debug ""+EventWidget( )\bar\thumb\end +" - thumb\end"
      Debug " --------------------- "
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
         SetState( Widget( ), 30 )
         Bind( Widget( ), @widget_events( ), #__event_Change )
         
         Scroll( 10, 45, 370, 30, 20, 1, 1 )
         SetState( Widget( ), 30 )
         Bind( Widget( ), @widget_events( ), #__event_Change )
         
         Scroll( 10, 80, 370, 30, 0, 50, 0 )
         SetState( Widget( ), 30 )
         Bind( Widget( ), @widget_events( ), #__event_Change )
         
         WaitClose( )
      EndIf
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 35
; FirstLine = 24
; Folding = -4-
; EnableXP
; DPIAware