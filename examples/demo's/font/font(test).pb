XIncludeFile "../../../widgets.pbi" 
;XIncludeFile "../../../widgets-font.pbi" 

   CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   Define i, *w._s_WIDGET, count = 10
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    LoadFont(5, "Arial", 18)
    LoadFont(6, "Arial", 25)
    
  CompilerElse
    LoadFont(5, "Arial", 14)
    LoadFont(6, "Arial", 21)
    
  CompilerEndIf
  
  
   ;\\
   OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
   
   Define *root._s_WIDGET = Open(#window_0, 0, 0, 424, 352): *root\class = "root": SetTextWidget(*root, "root")
   *w = TreeWidget( 10, 10, 424 - 20, 352 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 2) 
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
         ;SetItemFont(*w, i, 6)
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next 
   i=0
   Debug "----"
   For i = 1 To count
      If (i & 2) 
         SetItemFont(*w, i, 6)
         ;Debug i
      EndIf
   Next
   ;\\Close( )
   
   ;\\
   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ 
   Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetTextWidget(*root0, "root0")
   *w = TreeWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 5)
   ;\\Close( )
   
   ;\\ 
   Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetTextWidget(*root1, "root1")
   *w = TreeWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetTextWidget(*root2, "root2")
   *w = TreeWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
  SetFont(*w, 5)
    ;\\Close( )
   
   
   Define *root3._s_WIDGET = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetTextWidget(*root3, "root3")
   *w = TreeWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 6)
   ;\\Close( )
   
   Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetTextWidget(*root4, "root4")
   *w = TreeWidget( 10, 10, 200 - 20, 600 - 20) ; , #__flag_autosize )
   For i = 1 To count
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   
   
   WaitClose( )
   
CompilerEndIf


; #__event_Repaint
; #__event_Repaint
; #__event_Repaint
; #__event_Repaint
; #__event_Repaint
; #__event_Repaint
;      -     
;  draw current font - Draw 4303741968 0 4299401872
;  draw current font - update_items_ 4312244888 4299401872 4299355456
;  draw current font - update_items_ 4312246504 4299355456 4299401872
;  draw current font - update_items_ 4312248120 4299401872 4299355456
;  draw current font - update_items_ 4312249736 4299355456 4299401872
;  draw current font - update_items_ 4312251352 4299401872 4299355456
;  draw current font - update_items_ 4312252968 4299355456 4299401872
;  draw current font - update_items_ 4312254584 4299401872 4299355456
;  draw current font - update_items_ 4312264264 4299355456 4299401872
;  draw current font - update_items_ 4312265880 4299401872 4299355456
;  draw current font - update_items_ 4312267496 4299355456 4299401872
;  draw current font - update_items_ 4312269112 4299401872 4299355456
;  draw current font - update_items_ 4312270728 4299355456 4299401872
;  draw current font - update_items_ 4312272344 4299401872 4299355456
;  draw current font - update_items_ 4312273960 4299355456 4299401872
;  draw current font - update_items_ 4312275576 4299401872 4299355456
;  draw current font - update_items_ 4312277576 4299355456 4299401872
;  draw current font - update_items_ 4312279192 4299401872 4299355456
;  draw current font - update_items_ 4312280808 4299355456 4299401872
;  draw current font - update_items_ 4312282424 4299401872 4299355456
;  draw current font - update_items_ 4312284040 4299355456 4299401872
;  draw current font - update_items_ 4312285656 4299401872 4299355456
;  draw current font - update_items_ 4312287272 4299355456 4299401872
;  draw current font - update_items_ 4312288888 4299401872 4299355456
;  draw current font - update_items_ 4312290888 4299355456 4299401872
;  draw current font - update_items_ 4312292504 4299401872 4299355456
;  draw current font - update_items_ 4312294120 4299355456 4299401872
;  draw current font - update_items_ 4312295736 4299401872 4299355456
;  draw current font - update_items_ 4312297352 4299355456 4299401872
;  draw current font - update_items_ 4312298968 4299401872 4299355456
;  draw current font - update_items_ 4312300584 4299355456 4299401872
;  draw current font - update_items_ 4312302200 4299401872 4299355456
;  draw current font - update_items_ 4312304200 4299355456 4299401872
;  draw current font - update_items_ 4312305816 4299401872 4299355456
;  draw current font - update_items_ 4312307432 4299355456 4299401872
;  draw current font - update_items_ 4312309048 4299401872 4299355456
;  draw current font - update_items_ 4312310664 4299355456 4299401872
;  draw current font - update_items_ 4312312280 4299401872 4299355456
;  draw current font - update_items_ 4312313896 4299355456 4299401872
;  draw current font - update_items_ 4312315512 4299401872 4299355456
;  draw current font - update_items_ 4312317512 4299355456 4299401872
;  draw current font - update_items_ 4312319128 4299401872 4299355456
;  draw current font - update_items_ 4312320744 4299355456 4299401872
;  draw current font - update_items_ 4312322360 4299401872 4299355456
;  draw current font - update_items_ 4312323976 4299355456 4299401872
;  draw current font - update_items_ 4312325592 4299401872 4299355456
;  draw current font - update_items_ 4312327208 4299355456 4299401872
;  draw current font - update_items_ 4312328824 4299401872 4299355456
;  draw current font - update_items_ 4312330824 4299355456 4299401872
;  draw current font - update_items_ 4312332440 4299401872 4299355456
;  draw current font - draw_items_ 4312243272 4299355456 4299401872
;  draw current font - draw_items_ 4312244888 4299401872 4299355456
;  draw current font - draw_items_ 4312246504 4299355456 4299401872
;  draw current font - draw_items_ 4312248120 4299401872 4299355456
;  draw current font - draw_items_ 4312249736 4299355456 4299401872
;  draw current font - draw_items_ 4312251352 4299401872 4299355456
;  draw current font - draw_items_ 4312252968 4299355456 4299401872
;  draw current font - Draw 4312391696 4299401872 4300426464
;  draw current font - Draw 4312411664 4300426464 4299401872
;  draw current font - Draw 4303919120 4299401872 4300426464
;  draw current font - Draw 4370939408 4300426464 4299401872
;  draw current font - Draw 4320347664 4299401872 4299355456
;  draw current font - Draw 4320369680 4299355456 4299401872
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 19
; Folding = --
; EnableXP