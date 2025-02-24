﻿;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, *w0, *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8, *w9
  
  widget::Open(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  
  *w0 = widget::Tab(310, 10, 200, 30)
  For i=0 To 3
    widget::AddItem(*w0, -1, "tab_"+Str(i))
  Next
  
  *w1 = widget::Tab(320, 50, 200, 30)
  For i=0 To 10
    widget::AddItem(*w1, -1, "tab_"+Str(i))
  Next
  
  *w3 = widget::Tab(330, 90, 200, 30)
  For i=0 To 10
    widget::AddItem(*w3, -1, "tab_rrrrrrrr"+Str(i))
  Next
  
  *w4 = widget::Tab(340, 130, 200, 30)
  For i=0 To 10
    widget::AddItem(*w4, -1, "tab_"+Str(i))
  Next

  ;   widget::SetState(*w0, -10)
  ;   widget::SetState(*w1, 250-10)
  ;   widget::SetState(*w3, 250/2)
  ;   widget::SetState(*w4, 10)
  
  ;widget::bar_Tab_SetState(*w0, -1)
  widget::bar_Tab_SetState(*w1, 9)
  widget::bar_Tab_SetState(*w3, 6)
  widget::bar_Tab_SetState(*w4, 1)
  
  
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = -
; EnableXP