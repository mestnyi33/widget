XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Global Splitter_1, Splitter_2
  
   Procedure events_widgets( )
      widget( ) = Splitter_1
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
   
   Global v_bar, h_bar
   Global  w = 420-40, h = 280-40
   
   Procedure track_v_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   Procedure track_vh_events( )
      SetState(h_bar, w-10)
      SetState(v_bar, h-10)
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Splitter_1 = Splitter(10, 10, 180, 120, -1, -1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      
      ;v
      v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__bar_invert)
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_v_events( ), #__event_change )
      ;h
      h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 180)
      Bind( widget(), @track_h_events( ), #__event_change )
      
      Button(w+10,h+10,20,20,"")
      SetRound( widget(), 10 )
      Bind( widget(), @track_vh_events( ), #__event_Down )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 33
; Folding = --
; EnableXP
; DPIAware