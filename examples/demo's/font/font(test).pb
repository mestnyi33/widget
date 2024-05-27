XIncludeFile "../../../widgets.pbi" 
;XIncludeFile "../../../widgets-font.pbi" 

   CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   UseLIB(widget)
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   Define i, *w._s_WIDGET
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    LoadFont(5, "Arial", 18)
    LoadFont(6, "Arial", 25)
    
  CompilerElse
    LoadFont(5, "Arial", 14)
    LoadFont(6, "Arial", 21)
    
  CompilerEndIf
  
  
   ;\\
   OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
   
   Define *root._s_WIDGET = Open(#window_0, 0, 0, 424, 352): *root\class = "root": SetText(*root, "root")
   *w = Tree( 10, 10, 424 - 20, 352 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 2) 
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
         ;SetItemFont(*w, i, 6)
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next 
   i=0
   For i = 1 To 100;0000
      If (i & 2) 
         SetItemFont(*w, i, 6)
         ;Debug i
      EndIf
   Next
   ;\\Close( )
   
   ;\\
   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ 
   Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
   *w = Tree( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 5)
   ;\\Close( )
   
   ;\\ 
   Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetText(*root1, "root1")
   *w = Tree( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
   *w = Tree( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
  SetFont(*w, 5)
    ;\\Close( )
   
   
   Define *root3._s_WIDGET = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetText(*root3, "root3")
   *w = Tree( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 6)
   ;\\Close( )
   
   Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetText(*root4, "root4")
   *w = Tree( 10, 10, 200 - 20, 600 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   
   
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = --
; EnableXP