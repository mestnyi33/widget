XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Global object 
   Global v_bar, h_bar
   Global  w = 420-40, h = 280-40
   
   Procedure events_widgets( )
      widget( ) = object
      Debug " - "+classfromevent(WidgetEvent())
      Debug ""+widget( )\bar\page\pos +" - page\pos"
      Debug ""+widget( )\bar\page\len +" - page\len"
      Debug ""+widget( )\bar\page\end +" - page\end"
      Debug ""+widget( )\bar\page\change +" - page\change"
      Debug ""+widget( )\bar\percent +" - percent"
      Debug ""+widget( )\bar\area\len +" - area\len"
      Debug ""+widget( )\bar\area\end +" - area\end"
      Debug ""+widget( )\bar\thumb\pos +" - thumb\pos"
      Debug ""+widget( )\bar\thumb\len +" - thumb\len"
      Debug ""+widget( )\bar\thumb\end +" - thumb\end"
      Debug ""+widget( )\bar\thumb\change +" - thumb\change"
      Debug " - "
   EndProcedure
   
   Procedure create_test( mode = 0, min = 0 )
      Protected w = 180
      Protected h = 120
      
      If h_bar
         w = GetState(h_bar)
      EndIf
      If v_bar
         h = GetState(v_bar)
      EndIf
      
      If mode = 1
         object = Splitter(10, 10, w, h, Text(0,0,0,0,"fixed"), -1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      ElseIf  mode = 2
         object = Splitter(10, 10, w, h, -1, Text(0,0,0,0,"fixed"), #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      Else
         object = Splitter(10, 10, w, h, Text(0,0,0,0,"first"), Text(0,0,0,0,"second"), #PB_Splitter_Vertical)
      EndIf
      ;Resize(object, #PB_Ignore, #PB_Ignore, w,h)
      If min
         SetAttribute(object, #PB_Splitter_FirstMinimumSize, min)
         SetAttribute(object, #PB_Splitter_SecondMinimumSize, min)
      EndIf
   EndProcedure
   
   Procedure track_v_events( )
      Resize(object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(object, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   Procedure resize_events( )
      Protected *first._s_WIDGET = GetAttribute( object, #PB_Splitter_FirstGadget )
      Protected *second._s_WIDGET = GetAttribute( object, #PB_Splitter_SecondGadget )
      
      Debug "(1) - "+*first\x[#__c_draw] +" "+ *first\y[#__c_draw] +" "+ *first\width[#__c_draw] +" "+ *first\height[#__c_draw]
      Debug " (2) - "+*second\x[#__c_draw] +" "+ *second\y[#__c_draw] +" "+ *second\width[#__c_draw] +" "+ *second\height[#__c_draw]
   EndProcedure
   
   Procedure track_vh_events( )
      If GetState( EventWidget( ) )
         SetState(h_bar, 180)
         SetState(v_bar, 120)
      Else
         SetState(h_bar, w-10)
         SetState(v_bar, h-10)
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "press key_(0-1-2) to replace object", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      create_test( 0, 30 )
      Bind( object, @resize_events( ), #__event_resize )
      
      SetState(object, 20)
      ;v
      ;v_bar=Splitter( w+10,10,20,h, -1, -1, #__flag_Invert)
      v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__flag_Invert)
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_v_events( ), #__event_change )
      ;h
      ;h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
      h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 60)
      Bind( widget(), @track_h_events( ), #__event_change )
      
      Button(w+10,h+10,20,20,"", #__flag_Buttontoggle)
      SetRound( widget(), 10 )
      Bind( widget(), @track_vh_events( ), #__event_Down )
      
      ReDraw(root())
      
      widget() = object
      Debug  widget()\width
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 83
; FirstLine = 77
; Folding = ---
; EnableXP