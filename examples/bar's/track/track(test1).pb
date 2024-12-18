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
   
   Procedure track_v_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   Define w = 420-40, h = 280-40
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
     ; a_init(root())
      
      Splitter_1 = Splitter(30, 30, 180, 120, -1, -1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      
      ;h
      Track( 30,5,w,20, 0, w )
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 180)
      Bind( widget(), @track_h_events( ), #__event_change )
      ;v
      Track( 5,30,20,h, 0, h, #PB_TrackBar_Vertical|#__bar_invert)
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_v_events( ), #__event_change )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 46
; FirstLine = 23
; Folding = -
; EnableXP
; DPIAware