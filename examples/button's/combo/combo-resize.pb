XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Global img = 1
   If Not LoadImage(img, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DPIResolutionX() > 1
      ResizeImage(img, DPIScaledX(ImageWidth(img)),DPIScaledY(ImageHeight(img)))
   EndIf
   
   Global h = 100
   Global *g1, *g2, *g3, *g4, *g5, *g6
   Global word$ = "-"
   ; word$ = #LF$ ; BUG
   
   If Open(0, 0, 0, 680, 60+h, "content position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g1 = ComboBox( 30, 30, 200, h)
      AddItem(*g1, -1, "combo" + word$ + "left", img )
      SetState(*g1,0)
      
      *g2 = ComboBox( 30+210, 30, 200, h, #__flag_TextCenter)
      AddItem(*g2, -1, "combo" + word$ + "center" + word$ + "multi", img )
      SetState(*g2,0)
      
      *g3 = ComboBox( 30+420, 30, 200, h, #__flag_Right)
      AddItem(*g3, -1, "right" + word$ + "combo", img )
      SetState(*g3,0)
      
      ;
      *g4 = Splitter( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
      *g6 = Splitter( 30,30,620,h, *g5,-1)
      
      SetState(*g4, 200)
      SetState(*g5, 200*2+#__bar_splitter_size)
      SetState(*g6, h)
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 13
; Folding = -
; EnableXP