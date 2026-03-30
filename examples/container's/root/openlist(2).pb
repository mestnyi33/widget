IncludePath "../../../"
XIncludeFile "widgets.pbi"
UseWidgets( )
  

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global._s_root *g0, *g1, *g2
  
  *g0=Open(0, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu)
  *g0\class="first"
  
  Container(10,10,100,100)
  Container(10,10,90,90)
  CloseList()
  CloseList()
  Debug Opened()\class
  *g1=Open(1, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu)
  
  
  
  *g2=Open(2, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu)
  *g2\class="last"
  
  Debug ""+*g1\PrevRoot( )\class +" "+ *g1\NextRoot( )\class
  If *g2\afterroot
     Debug "1"+*g1\afterroot\class 
  EndIf
  If *g2\beforeroot
     Debug "2"+*g1\beforeroot\class
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 18
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware