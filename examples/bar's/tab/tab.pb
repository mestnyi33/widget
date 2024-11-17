
XIncludeFile "../../../widgets.pbi" 

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global i, tab_1, tab_2, tab_3, tab_4
   
   If Open(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;
      tab_1 = TabBarWidget(310, 10, 200, 30)
      For i=0 To 3
         AddItem(tab_1, -1, "tab_"+Str(i))
      Next
      ;
      tab_2 = TabBarWidget(320, 50, 200, 30)
      For i=0 To 10
         AddItem(tab_2, -1, "tab_"+Str(i))
      Next
      ;
      tab_3 = TabBarWidget(330, 90, 200, 30)
      For i=0 To 10
         AddItem(tab_3, -1, Space(5)+"tab_"+Str(i)+Space(5))
      Next
      ;
      tab_4 = TabBarWidget(340, 130, 200, 30)
      For i=0 To 10
         AddItem(tab_4, -1, "tab_"+Str(i))
      Next
      ;
      SetState(tab_1, -1)
      SetState(tab_2, 9)
      SetState(tab_3, 6)
      SetState(tab_4, 1)
      
      ;
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
      
      WaitClose( )
      End
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; FirstLine = 2
; Folding = -
; EnableXP