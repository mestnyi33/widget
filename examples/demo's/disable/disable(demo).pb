XIncludeFile "../../../demo.pb"

CompilerIf #PB_Compiler_IsMainFile
   ClearDebugOutput()
   Debug " ---disable root widgets--- "
   If StartEnum( root( ), 0, 1 )
      Debug "      "+widget( )\class
      Disable( widget( ), 1)
      StopEnum( )
   EndIf
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP