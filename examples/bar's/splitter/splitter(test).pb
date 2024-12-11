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
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Splitter_1 = Splitter(10, 10, 180, 120, -1, -1, #PB_Splitter_Vertical)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      Splitter_2 = Splitter(10, 10, 180, 120, Splitter_1, -1)
      
      widget( ) = Splitter_1
      Debug widget( )\bar\page\pos
      
      Bind( #PB_All, @events_widgets( ), #__event_down )
      Bind( #PB_All, @events_widgets( ), #__event_up )
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 8
; Folding = -
; Optimizer
; EnableXP
; DPIAware