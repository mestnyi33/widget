
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   Define i, time.q, count = 10000
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      For i = 0 To count
         Container( 5*i, 5*i, 50,50)
      Next
      For i = 0 To count
         CloseList( )
      Next
      
      time = ElapsedMilliseconds( )
      Debug "--- enumerate all gadgets ---"
      If StartEnumerate( root( ) )
         ;Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnumerate( )
      EndIf
      Debug "time - "+Str(ElapsedMilliseconds( ) - time)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 20
; Folding = -
; EnableXP
; DPIAware