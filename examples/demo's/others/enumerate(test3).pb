
XIncludeFile "../../../widgets.pbi" 
;Macro widget( ) : enumwidget( ) : EndMacro

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLib(widget)
   Define i, time.q
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      For i = 0 To 99000
         Button( 5*i, 5*i, 50,50, Str(i))
      Next
      
      time = ElapsedMilliseconds( )
      Debug "--- enumerate all gadgets ---"
      If StartEnumerate( root( ) )
         ;Debug "     gadget - "+ enumWidget()\index +" "+ enumWidget()\class
         StopEnumerate( )
      EndIf
      Debug "time - "+Str(ElapsedMilliseconds( ) - time)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 11
; Folding = -
; EnableXP