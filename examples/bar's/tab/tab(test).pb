XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i,*g0,*g1,*g2,*g3,*g4,*g5,*g6,*g7,*g8,*g9
  
  Open(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  Define iw = 150 
  ;Define iw = 350
  Define ix = (850 - iw)/2
  
 *g0 = Tab(ix,  10, iw, 30) : For i=0 To 10 : AddItem(*g0, -1, "tab_"+Str(i)) : Next
 *g1 = Tab(ix,  50, iw, 30) : For i=0 To 10 : AddItem(*g1, -1, "tab_"+Str(i)) : Next
 *g3 = Tab(ix,  90, iw, 30) : For i=0 To 10 : AddItem(*g3, -1, "tab_"+Str(i)) : Next
 *g4 = Tab(ix, 130, iw, 30) : For i=0 To 10 : AddItem(*g4, -1, "tab_rrrrrrrr"+Str(i)) : Next
 *g5 = Tab(ix, 170, iw, 30) : For i=0 To 10 : AddItem(*g5, -1, "tab_"+Str(i)) : Next

  SetState(*g0, -1)
  SetState(*g1, 9)
  SetState(*g3, 6)
  SetState(*g4, 6)
  SetState(*g5, 1)
  
  ReDraw( root() )
  
  widget( ) = *g0
  
  Debug " - "
  Debug ""+widget( )\bar\min +" - min"
  Debug ""+widget( )\bar\max +" - max"
  Debug ""+widget( )\bar\percent +" - percent"
  Debug ""
  Debug ""+widget( )\bar\page\pos +" - page\pos"
  Debug ""+widget( )\bar\page\len +" - page\len"
  Debug ""+widget( )\bar\page\end +" - page\end"
  Debug ""
  Debug ""+widget( )\bar\area\pos +" - area\pos"
  Debug ""+widget( )\bar\area\len +" - area\len"
  Debug ""+widget( )\bar\area\end +" - area\end"
  Debug ""
  Debug ""+widget( )\bar\thumb\pos +" - thumb\pos"
  Debug ""+widget( )\bar\thumb\len +" - thumb\len"
  Debug ""+widget( )\bar\thumb\end +" - thumb\end"
  Debug " - "
  
  WaitClose( )
  End
CompilerEndIf

;  - 
; 0 - min
; 456 - max
; 0.3028571429 - percent
; 
; 456 - page\pos
; 0 - page\len
; 350 - page\end
; 
; 15 - area\pos
; 350 - area\len
; 320 - area\end
; 
; 121 - thumb\pos
; 214 - thumb\len
; 121 - thumb\end
;  - 

;[TAB_0] 0.3028571429 >< 0 456 >< 456 0 350 >< 15 350 320 >< 121 214 121 

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 46
; FirstLine = 30
; Folding = -
; EnableXP
; DPIAware