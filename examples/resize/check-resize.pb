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
   
   Global h = 80
   Global._s_widget *g1, *g2, *g3, *g4, *g5, *g6
   Global word$ = "-"
   ; word$ = #LF$ ; BUG
   
   If Open(#PB_Any, 0, 0, 680, 60+h, "content position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g1 = CheckBox(    30, 30, 200, h, "butt" + word$ + "left", #__flag_Left|#__flag_TextMultiLine)
      *g2 = CheckBox(30+210, 30, 200, h, "butt" + word$ + "center" + word$ + "multi", #__flag_TextMultiLine)
      *g3 = CheckBox(30+420, 30, 200, h, "right" + word$ + "butt", #__flag_Right|#__flag_TextMultiLine)
      
      SetImage(*g1, img)
      SetImage(*g2, img)
      SetImage(*g3, img)
      
      *g4 = Splitter(0,0,0,0, *g3,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      *g5 = Splitter(30,30,620,h, *g4,*g1, #PB_Splitter_Vertical)
      *g6 = Splitter(30,30,620,h, *g5, -1)
      
      SetState(*g4, 200)
      SetState(*g5, 200*2)
      SetState(*g6, h)
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 13
; Folding = -
; EnableXP
; DPIAware