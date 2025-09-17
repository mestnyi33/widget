;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, *w0, *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8, *w9
  
  widget::Open(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  Define iw = 150 ; FIXME BUG
  ;Define iw = 350
  Define ix = (850 - iw)/2
  
  *w0 = widget::Tab(ix,  10, iw, 30) : For i=0 To 10 : widget::AddItem(*w0, -1, "tab_"+Str(i)) : Next
  *w1 = widget::Tab(ix,  50, iw, 30) : For i=0 To 10 : widget::AddItem(*w1, -1, "tab_"+Str(i)) : Next
  *w3 = widget::Tab(ix,  90, iw, 30) : For i=0 To 10 : widget::AddItem(*w3, -1, "tab_"+Str(i)) : Next
  *w4 = widget::Tab(ix, 130, iw, 30) : For i=0 To 10 : widget::AddItem(*w4, -1, "tab_rrrrrrrr"+Str(i)) : Next
  *w5 = widget::Tab(ix, 170, iw, 30) : For i=0 To 10 : widget::AddItem(*w5, -1, "tab_"+Str(i)) : Next

  widget::SetState(*w0, -1)
  widget::SetState(*w1, 9)
  widget::SetState(*w3, 6)
  widget::SetState(*w4, 6)
  widget::SetState(*w5, 1)
  
  
  Debug " - "
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
  
  widget::WaitClose( )
  End
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 17
; Folding = -
; EnableXP