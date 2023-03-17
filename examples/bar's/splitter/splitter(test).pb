XIncludeFile "../../../widgets.pbi" 

Uselib(widget)

If Open(OpenWindow(#PB_Any, 0, 0, 500+500, 340, "disable - state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 500,0, 500);,140)
  SplitterGadget(1, 10, 10, 300, 100, ButtonGadget(-1,0,0,0,0,""), ButtonGadget(-1,0,0,0,0,""), #PB_Splitter_Vertical);|#PB_Splitter_SecondFixed)
  SetGadgetAttribute(1, #PB_Splitter_FirstMinimumSize, 40)
  SetGadgetAttribute(1, #PB_Splitter_SecondMinimumSize, 40)
  ResizeGadget(1, #PB_Ignore, #PB_Ignore, 200, #PB_Ignore )
  SetGadgetState   (1,  200)
  
  Debug GetGadgetState   (1)
  
  Define Splitter_1 = widget::Splitter(10, 10, 300, 100, -1, -1, #PB_Splitter_Vertical);|#PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Resize(Splitter_1, #PB_Ignore, #PB_Ignore, 200, #PB_Ignore )
  ; Resize(Splitter_1, #PB_Ignore, #PB_Ignore, 301, #PB_Ignore )
  SetState   (Splitter_1,  300)
     Debug " - "
  Debug widget( )\bar\page\pos
  Debug widget( )\bar\page\len
  Debug widget( )\bar\page\end
  Debug widget( )\bar\page\change
  Debug widget( )\bar\percent
  Debug widget( )\bar\area\len
  Debug widget( )\bar\area\end
  Debug widget( )\bar\thumb\pos
  Debug widget( )\bar\thumb\len
  Debug widget( )\bar\thumb\end
  Debug widget( )\bar\thumb\change
  Debug ""
 
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP