XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define h = 185, bh = 20+9
   Define._s_widget *g1, *g2, *g3, *g4, *g5, *g6
   
   If Open(0, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g1 = ScrollArea(    30, 30, 200, h, 301,h-bh )
      Button( 0,30,80,30, "button_1")
      CloseList( )
      
      *g2 = ScrollArea(30+210, 30, 200, h, 301,h-bh )
      Button( (301-80)/2,30,80,30, "button_2")
      CloseList( )
      
      *g3 = ScrollArea(30+420, 30, 200, h, 301,h-bh )
      Button( (301-80),30,80,30, "button_3")
      CloseList( )
      
      *g4 = Splitter(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      *g5 = Splitter(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
      *g6 = Splitter(30,30,620,h, *g5,#Null)
      
      SetState(*g4, 200)
      SetState(*g5, 200*2)
      SetState(*g6, h)
      
      SetAttribute(*g2, #PB_ScrollArea_X, (DPIUnScaled(*g2\scroll\h\bar\page\end))/2 )
      SetAttribute(*g3, #PB_ScrollArea_X, (DPIUnScaled(*g3\scroll\h\bar\page\end)) )
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 31
; Folding = -
; EnableXP
; DPIAware