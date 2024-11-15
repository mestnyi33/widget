IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_canvas_events = 1
   
   Procedure OpenTest( id, flag=0 )
      Static x,y
      OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
      Open( id, 40,40,200-80,55) : SetClass(root( ), Str(id))
      Open( id, 40,110,200-80,55) : SetClass(root( ), "1"+Str(id))
      x + 100
      y + 100
   EndProcedure
   
   
   OpenTest(1, #PB_Window_NoActivate)
   OpenTest(2, #PB_Window_NoActivate)
   OpenTest(3, #PB_Window_NoActivate)
   
   OpenWindow( 4, 330,300,200,100,"popup", #PB_Window_BorderLess, WindowID(3))
   Open(4, 10,10,100,100)
   
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableXP